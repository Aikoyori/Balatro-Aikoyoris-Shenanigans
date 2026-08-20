if AKYRS.is_mod_loaded('MultiplayerSPDRN')then
    -- 90% of this code is copied from MP Speedrun, please excuse my slop job pls thx
    SPDRN.Gamemode.AKYRS_HC = 'akyrs_hardcore'
    local function create_lobby_with_gamemode(key)
        _pending_gamemode_key = key
        SPDRN._lobby_kind = SPDRN.LobbyKind.PRIVATE
        G.FUNCS.exit_overlay_menu()

        local gm = MPAPI.GameModes[key]
        local lobby = MPAPI.create_lobby(SPDRN.id, { max_players = gm and gm:get_max_players('private') or 16 })
        if not lobby then
            _pending_gamemode_key = nil
            SPDRN._lobby_kind = nil
            return
        end

        SPDRN.setup_lobby_events(lobby)

        lobby:on('connected', function()
            SPDRN.sendDebugMessage('Lobby created: ' .. tostring(lobby.code))
            love.system.setClipboardText(lobby.code)
            if _pending_gamemode_key then
                -- stake = 1 (White) is a harmless universal default -- only Seed Scout's start_run
                -- falls back to it (self._meta_stake, if a draft survivor is ever missing a .stake),
                -- everyone else ignores it, same as how `deck` defaults to Blue Deck for every mode
                -- regardless of whether that mode actually uses a single deck.
                lobby:set_metadata({ gamemode = _pending_gamemode_key, deck = SPDRN.Deck.DEFAULT, ruleset = SPDRN.Ruleset.ORDER, kind = SPDRN.LobbyKind.PRIVATE, stake = 1 })
                _pending_gamemode_key = nil
            end
        end)
    end

    local function change_gamemode(key)
        local lobby = SPDRN.lobby.ref
        if lobby and lobby.is_host then
            local meta = lobby:get_metadata()
            -- If the new mode needs a different number of decks, the saved deck(s) no longer fit;
            -- reset to the default so the host re-picks the right count via the deck button.
            local need = SPDRN.required_deck_count(MPAPI.GameModes[key])
            local have = type(meta.deck) == 'table' and #meta.deck or 1
            local deck = (have == need and meta.deck) or SPDRN.Deck.DEFAULT
            -- stake/challenge are preserved across a switch (harmless for modes that don't use
            -- them) so a host who already picked one doesn't lose it if they switch back to a mode
            -- that does -- stake falls back to White (1) since every mode's metadata already
            -- carries some value for it (see create_lobby_with_gamemode's universal default).
            lobby:set_metadata({ gamemode = key, deck = deck, ruleset = meta.ruleset or SPDRN.Ruleset.ORDER, stake = meta.stake or 1, challenge = meta.challenge, duration_cap_opt_in = meta.duration_cap_opt_in })
        end
        G.FUNCS.exit_overlay_menu()
    end
    AKYRS.should_tick_down = function ()
        return #G.E_MANAGER.queues.base <= 2
    end
    local function hc_challenge_pool(count)
        local indices = {}
        for i = 1, #AKYRS.HC_CHALLENGES_BUFFER do
            indices[i] = i
        end
        for i = #indices, 2, -1 do
            local j = math.random(i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        local pool = {}
        for i = 1, math.min(count, #indices) do
            local c = AKYRS.HC_CHALLENGES[AKYRS.HC_CHALLENGES_BUFFER[indices[i]]]
            pool[i] = { key = 'b_akyrs_hardcore_challenges', id = c.id, challenge_id = c.id, challenge_name = localize(c.id, "hardcore_challenge_names")  }
        end
        return pool
    end

    local function decorate_challenge_tile(card, item)
        if not (type(item) == 'table' and item.challenge_name) then
            return
        end
        card.children.mp_challenge_label = UIBox({
            definition = {
                n = G.UIT.ROOT,
                config = { padding = 0, colour = G.C.CLEAR },
                nodes = {
                    { n = G.UIT.R, config = { r = 0.08, padding = 0.06, align = 'cm', minw = card.T.w - 0.1, colour = G.C.BLACK, shadow = true }, nodes = {
                        { n = G.UIT.T, config = { text = item.challenge_name, colour = G.C.UI.TEXT_LIGHT, scale = 0.26, shadow = true } },
                    } },
                },
            },
            config = { align = 'tmi', offset = { x = 0, y = -0.4 }, parent = card },
        })
    end

    MPAPI.GameMode({
        key = SPDRN.Gamemode.AKYRS_HC,
        display_name = 'Hardcore',
        max_players = {
            public = 16,
            private = 16,
        },
        -- Opts into MPAPI.BanPick.start running in private lobbies too, not just matchmaking (this
        -- mode is never queueable, same rationale as All Deck).
        always_draft = true,
        ban_pick = {
            pool_size = 5,
            keep = 1,
            build_pool = function() return hc_challenge_pool(5) end,
            decorate_tile = decorate_challenge_tile,
        },
        -- §16.7: duration cap is a per-gamemode option (has_duration_cap); this mode doesn't
        -- have it turned on yet, so no duration_cap_seconds is set.
        init = function(self)
            self._win_fired = false
            self._forfeited = {}
        end,
        -- Single run, same ante>=9 win detection as Gold Stake Single -- confirmed (Phase 0 of the
        -- implementation plan) that no installed Challenge overrides win_ante away from 8.
        calculate = function(self, context)
            if not context.ante_change then
                return
            end
            local ante = context.ante
            if ante < 9 then
                self._win_fired = false
                return
            end
            if self._win_fired then
                return
            end
            self._win_fired = true
            SPDRN.record_run_completed()

            local lobby = MPAPI.get_current_lobby()
            if not lobby then
                return
            end
            return { winner = lobby.player_id }
        end,
        on_player_forfeit = function(self, player_id)
            local winner_id = self:check_single_survivor(player_id)
            if not winner_id then
                return
            end
            return { winner = winner_id }
        end,
        start_run = function(self, deck_ref, seed)
            -- deck_ref is a { key, challenge_id, challenge_name } draft survivor in matchmaking/
            -- private-lobby play (always_draft); practice mode has no draft (solo, per
            -- ui/main_menu/practice.lua) and instead stamps the id straight into lobby metadata,
            -- read here via self._meta_challenge (see SPDRN.begin_run).
            local challenge_id = (type(deck_ref) == 'table' and deck_ref.challenge_id) or self._meta_challenge
            local idx = challenge_id and AKYRS.get_hc_challenge_int_from_id(challenge_id)
            local challenge = idx and idx > 0 and AKYRS.HC_CHALLENGES[idx]
            if not challenge then
                SPDRN.sendWarnMessage('spdrn_challenge: unknown hardcore challenge id: ' .. tostring(challenge_id))
            end
            G.FUNCS.start_run(nil, {
                stake = 1,
                seed = seed,
                challenge = challenge,
            })
        end,
    })
    G.FUNCS.akyrs_select_hardcore_speedrun = function()
        create_lobby_with_gamemode(SPDRN.Gamemode.AKYRS_HC)
    end
    G.FUNCS.akyrs_spdrn_practice_hc_challenge = function()
        G.FUNCS.exit_overlay_menu()
        SPDRN.open_challenge_select(nil, function(challenge_id)
            -- The deck is irrelevant to Challenge's start_run (the challenge fixes its own deck);
            -- pass the default so _start_practice's deck-list normalization has something to work
            -- with, same as every other gamemode's deck param.
            SPDRN._start_practice(SPDRN.Gamemode.AKYRS_HC, 'Hardcore Challenge Deck', { challenge = challenge_id })
        end)
    end

    local _on_confirm = nil
    local _current_index = 1

    local function build_hc_challenge_select_uibox()
        local names = {}
        for i, k in ipairs(AKYRS.HC_CHALLENGES_BUFFER) do
            local c = AKYRS.HC_CHALLENGES[k]
            names[i] = localize(c.id, "hardcore_challenge_names") or c.name or c.id
        end

        local contents = {
            { n = G.UIT.R, config = { align = 'cm', padding = 0.1 }, nodes = {
                { n = G.UIT.T, config = { text = 'Select Hardcore Challenge', scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
            } },
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.15 },
                nodes = {
                    create_option_cycle({
                        options = names,
                        opt_callback = 'spdrn_challenge_select_cycle',
                        current_option = _current_index,
                        colour = G.C.RED,
                        w = 5,
                    }),
                },
            },
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.15 },
                nodes = {
                    UIBox_button({ button = 'spdrn_challenge_select_confirm', label = { localize('b_select') or 'Select' }, colour = G.C.BLUE, minw = 3, minh = 0.7, scale = 0.5 }),
                },
            },
        }

        return create_UIBox_generic_options({ contents = contents })
    end

    function SPDRN.open_challenge_select(current_challenge_id, on_confirm)
        _on_confirm = on_confirm
        _current_index = 1
        if current_challenge_id then
            local idx = AKYRS.get_hc_challenge_int_from_id(current_challenge_id)
            if idx and idx > 0 then
                _current_index = idx
            end
        end
        G.FUNCS.overlay_menu({ definition = build_hc_challenge_select_uibox() })
    end

    G.FUNCS.spdrn_challenge_select_cycle = function(args)
        _current_index = args.to_key
    end

    G.FUNCS.spdrn_challenge_select_confirm = function()
        local cb = _on_confirm
        _on_confirm = nil
        local challenge = AKYRS.HC_CHALLENGES[AKYRS.HC_CHALLENGES_BUFFER[_current_index]]
        if G.OVERLAY_MENU and G.OVERLAY_MENU ~= true then
            G.FUNCS.exit_overlay_menu()
        end
        if cb and challenge then
            cb(challenge.id)
        end
    end
    
    G.FUNCS.akyrs_spdrn_change_hc_challenge = function()
        change_gamemode(SPDRN.Gamemode.AKYRS_HC)
    end

end