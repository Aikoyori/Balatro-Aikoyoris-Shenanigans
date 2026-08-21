
AKYRS.pure_hands_modifier = 2

AKYRS.change_letter_to = function(card,letter,respect_wild)
    if not card or not letter then return false end
    if respect_wild and card.ability.aikoyori_letters_stickers == "#" then
        card.ability.aikoyori_pretend_letter = letter
    else
        card:set_letters(letter)
    end
    
end

-- i hate writing lua in the patch\
-- also return blind requirement
AKYRS.mod_blind_requirement = function(blind,chips)
    if blind.debuff.akyrs_anteth_power_of_x_blind_req then
        local ante_power = G.GAME.round_resets.ante ^ blind.debuff.akyrs_anteth_power_of_x_blind_req_power * blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier
        chips = chips * blind.debuff.akyrs_anteth_power_of_x_blind_req ^ ante_power
    end
    return chips
end

-- this one returns a node so we can add it to the blind popup
AKYRS.mod_blind_display = function(blind)
    if blind.debuff.akyrs_anteth_power_of_x_blind_req then
        local blind_exp_has_power = blind.debuff.akyrs_anteth_power_of_x_blind_req_power and blind.debuff.akyrs_anteth_power_of_x_blind_req_power ~= 1
        local blind_exp_has_multi = blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier and blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier ~= 1

        local pwrd = blind.debuff.akyrs_anteth_power_of_x_blind_req .. "^" .. 
            (blind_exp_has_multi and "("..blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier or "") ..
            (blind_exp_has_power and "("..localize('k_akyrs_power_ante').."^"..blind.debuff.akyrs_anteth_power_of_x_blind_req_power..")" or localize('k_akyrs_power_ante')) ..
            (blind_exp_has_multi and ")" or "") 


        return {n=G.UIT.T, config={text = pwrd..localize('k_x_base'), scale = 0.4, colour = G.C.RED}}
    end
end

function AKYRS.does_hand_only_contain_symbols(cardarea)
    if G.deck and G.deck.cards and #G.deck.cards > 0 then return false end
    for i,k in ipairs(cardarea.cards) do
        if tonumber(k.ability.aikoyori_letters_stickers) then
            return false
        end
    end
    return true
end

AKYRS.make_new_card_area = function(config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local card_limit = config.card_limit or 52
    local margin_left = config.ml or 0.
    local margin_top = config.mt or 0
    local type = config.type or "title"
    local temporary = config.temporary or false
    local akyrs_pile_drag = config.pile_drag or nil
    local highlight_limit = config.highlight_limit or 0
    local emplace_func = config.emplace_func or nil
    local sol_emplace_func = config.sol_emplace_func or nil
    local use_room = config.use_room or true
    local ca = CardArea(
        (use_room and G.ROOM.T.x or 0) + margin_left * (use_room and G.ROOM.T.w or 1), (use_room and G.ROOM.T.h or 0) + margin_top
        , width , height,
        {card_limit = card_limit, type = type, highlight_limit = highlight_limit, akyrs_emplace_func = emplace_func, akyrs_sol_emplace_func = sol_emplace_func, temporary = temporary, akyrs_pile_drag=akyrs_pile_drag }
    )
    ca.states.collide.can = true
    ca.states.release_on.can = true
    return ca
end

AKYRS.destroy_existing_cards = function(cardarea)
    if cardarea and cardarea.cards then
        for i,k in ipairs(cardarea.cards) do
            SMODS.destroy_cards({k})
        end
    end
    if cardarea then 
        cardarea:remove()
    end
end


function AKYRS.draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only, forced_facing)
    if not to or not to.cards then return true end
    percent = percent or 50
    delay = delay or 0.1 
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = delay,
        blocking = not (G.SETTINGS.GAMESPEED >= 999 and ((to == G.hand and from == G.deck) or (to == G.deck and from == G.hand))), -- Has to be these specific draws only, otherwise it's buggy
        
        func = function()
            if not to or not to.cards then return true end
            if card then 
                if from then card = from:remove_card(card) end
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
                if to then
                    to:emplace(card, nil, stay_flipped)
                else
                    
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            else
            if not to then return true end
                card = to:draw_card_from(from, stay_flipped, discarded_only)
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            end
            if not mute and drawn then
                if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                    G.VIBRATION = G.VIBRATION + 0.6
                end
                play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
            end
            if sort then
                to:sort()
            end
            SMODS.drawn_cards = SMODS.drawn_cards or {}
            if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
            
            if card and forced_facing then 
                card.facing = forced_facing
                card.sprite_facing = forced_facing
            end
            return true
        end
      }),"akyrs_desc")
end
function AKYRS.instant_draw_card(from, to, percent, dir, sort, card, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    if card then 
        if from then card = from:remove_card(card) end
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
        if to then
            to:emplace(card, nil, stay_flipped)
        else
            
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    else
        card = to:draw_card_from(from, stay_flipped, discarded_only)
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    end
    if not mute and drawn then
        if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
            G.VIBRATION = G.VIBRATION + 0.6
        end
        play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
    end
    if sort then
        to:sort()
    end
    SMODS.drawn_cards = SMODS.drawn_cards or {}
    if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
    
    if card and forced_facing then 
        card.facing = forced_facing
        card.sprite_facing = forced_facing
    end
    return true
        
end

function AKYRS.getGameOverBlindText()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key then
        if (G.GAME.blind.config.blind.key == "bl_akyrs_the_thought") then
            return string.upper(G.GAME.word_todo)
        else
            return nil
        end
    else
        return nil
    end
end


function AKYRS.getBlindText(key, collection)
    if G.GAME.akyrs_mathematics_enabled then
        return {
            localize("ph_akyrs_math_score_1")..G.GAME.akyrs_math_threshold..localize("ph_akyrs_math_score_2")
            ,nil
        }
    elseif (key == "bl_akyrs_the_thought") and ((G.GAME.blind and not G.GAME.blind.disabled) or collection) then
        return {localize("ph_aiko_beat_puzzle"),localize("ph_word_puzzle")}
    elseif (key == "bl_akyrs_the_bomb") and ((G.GAME.blind and not G.GAME.blind.disabled) or collection) then
        return {localize("ph_aiko_defuse"),localize("ph_aiko_bomb")}
    elseif (key == "bl_akyrs_the_bent") and ((G.GAME.blind and not G.GAME.blind.disabled) or collection) then
        local blind_config = G.P_BLINDS[key].config
        local live_blind = (G.GAME.blind and G.GAME.blind.effect or { times_left = blind_config.times_left })
        local times_left = 2
        if collection then
            times_left = blind_config.times_left
        else
            times_left = live_blind.times_left
        end
        --print(collection, times_left)
        return {localize("ph_akyrs_play_for"),localize({ type = "variable", vars = { times_left }, key = "ph_akyrs_hand" .. (times_left ~= 1 and "s" or "") })}
    else
        return {nil,nil}
    end
end

function AKYRS.getCashOutText(config,scale,stake_sprite, num_dollars)
    
    if G.GAME.aiko_puzzle_win then
        config.saved = false
        G.GAME.current_round.dollars = G.GAME.current_round.dollars + G.GAME.blind.dollars
        return {n=G.UIT.C, config={padding = 0.05, align = 'cm', minw = 2}, nodes={
            {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {' '..localize('ph_puzzle_clear')..' '}, colours = {G.C.EDITION}, shadow = true, pop_in = 0, float = true, scale = .8*scale, silent = true})}}
            }}
        }}
    end
    if config.saved then return end

    if G.GAME.akyrs_mathematics_enabled then
        return {n=G.UIT.C, config={padding = 0.05, align = 'cm'}, nodes={
            {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {' '..localize("ph_akyrs_math_score_1")..G.GAME.akyrs_math_threshold..localize("ph_akyrs_math_score_2")..' '}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}}
            }},
            {n=G.UIT.R, config={align = 'cm', minh = 0.8}, nodes={
                {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
                {n=G.UIT.T, config={text = G.GAME.blind.chip_text, scale = scale_number(G.GAME.blind.chips, scale, 100000), colour = G.C.RED, shadow = true}}
            }}
        }}
    end
end
function AKYRS.setCashOutDollars(config,scale,stake_sprite, num_dollars)
end

function AKYRS.mod_skip_box(blind_type, ax, original)
    
    blind_type = blind_type or 'Small'
    local blind_choice = {
        config = G.P_BLINDS[G.GAME.round_resets.blind_choices[blind_type]],
    }

    if blind_choice.config.debuff.akyrs_cannot_be_skipped then
        return nil
    end
    return original
end

function AKYRS.blind_handler()
    if G.GAME.blind_on_deck == 'Boss' then
        G.GAME.current_round.voucher = SMODS.get_next_vouchers()
        G.GAME.round_resets.blind_states.Boss = 'Defeated'
        if AKYRS.is_mod_loaded("Cryptid") then
            -- thanks cryptid
            if G.GAME.current_round.cry_voucher_stickers.pinned == false then
                G.GAME.current_round.voucher = SMODS.get_next_vouchers()
                G.GAME.current_round.cry_voucher_stickers = Cryptid.next_voucher_stickers()
                G.GAME.current_round.cry_voucher_edition = cry_get_next_voucher_edition() or {}
                G.GAME.current_round.cry_bonusvouchers = {}
                G.GAME.cry_bonusvouchersused = {}
                for i = 1, G.GAME.cry_bonusvouchercount do
                    G.GAME.current_round.cry_bonusvouchers[i] = SMODS.get_next_vouchers()
                end
                if G.GAME.modifiers.cry_no_vouchers then
                    very_fair_quip = pseudorandom_element(G.localization.misc.very_fair_quips, pseudoseed("cry_very_fair"))
                end
            end
        end
        G.GAME.GB_BLINDS_SKIPPED_THIS_ANTE = 0
        for k, v in ipairs(G.playing_cards) do
            v.ability.played_this_ante = nil
            v.ability.discarded_this_ante = nil
        end
    else
        G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Defeated'
    end
end

---@param card Card card
---@param sprite Sprite sprite
---@params overlay number[] colour idk
function AKYRS.back_render_override(card, sprite, overlay)
    -- performance wise it should not be TOO bad from general testing
    if sprite.atlas.key == "akyrs_deckBacks" and sprite.sprite_pos.x == 3 and sprite.sprite_pos.y == 1 then
        --sprite:draw_shader('dissolve',nil,nil,overlay and true)
        sprite:draw_shader('akyrs_enchanted',nil,nil,overlay and true)
        return true
    end
    return nil
end

---@param self Game game
AKYRS.mod_playing_cards = function(self)
    if self.GAME.starting_params.akyrs_split_deck then
        local cards = {}
        for i = 1, #G.playing_cards do
            ---@type Card
            local _c = G.playing_cards[i]
            local _c2 = AKYRS.copy_p_card(_c,nil, nil, nil, nil, G.deck)
            table.insert(cards,_c2)
            AKYRS.set_special_card_type(_c, "suit")
        end
        for _, _c2 in ipairs(cards) do
            AKYRS.set_special_card_type(_c2, "rank")
        end
    end
    if self.GAME.starting_params.akyrs_split_rank_deck then
        local cards = {}
        for i = 1, #G.playing_cards do
            ---@type Card
            local _c = G.playing_cards[i]
            AKYRS.set_special_card_type(_c, "rank")
        end
    end
    if self.GAME.starting_params.akyrs_split_suit_deck then
        local cards = {}
        for i = 1, #G.playing_cards do
            ---@type Card
            local _c = G.playing_cards[i]
            AKYRS.set_special_card_type(_c, "suit")
        end
    end
end

function AKYRS.defeated_by_center_ui(center_key) 
    label = localize('k_defeated_by')
    local center = G.P_CENTERS[center_key]
    local c = SMODS.create_card{ key = center_key, set = center.set, skip_materialize = true }
    local area = AKYRS.card_area_preview( G.akyrs_lose, nil, {
        override = true,
        w = 1,
        h = 0.9,
        ml = 0,
        mb = 0.5,
        scale = 0.8,
        cards = {c},
        type = "akyrs_credits",
    })
    
    return {
        {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = localize{type ='name_text', key = center_key, set = center.set}, colours = {G.C.WHITE},shadow = true, float = true,maxw = 2.2, scale = 0.45})}}
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={area}
        },
    }, label
end

function AKYRS.should_use_default_blind_handler()
    return AKYRS.is_mod_loaded("Cryptid")
end