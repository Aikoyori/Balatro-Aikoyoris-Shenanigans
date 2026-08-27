

AKYRS.game_areas = function(area)
    return area == G.play or area == G.hand or area == G.deck or area == G.discard or area == G.jokers or area == G.consumeables or nil
end
AKYRS.sigmaable_areas = function(area)
    return area == G.hand or area == G.deck or area == G.discard or area == G.jokers or area == G.consumeables or nil
end
AKYRS.non_removing_play_state = function()
    return G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.ROUND_EVAL
end
AKYRS.is_card_not_sigma = function(card) 
    return card.ability.consumeable or card.ability.set == "Booster" or card.ability.set == "Voucher" or nil
end

AKYRS.nope_buzzer = function(major, text, colour, rotate, scale, hold)
    play_sound("akyrs_loud_incorrect_buzzer",1,0.2)
    attention_text({
        text = text or localize("k_nope_ex"),
        scale = scale or 1, 
        hold = hold or 1.0,
        rotate = rotate or math.pi / 8,
        backdrop_colour = colour or G.GAME.blind.boss_colour,
        align = "cm",
        major = major or G.GAME.blind,
        offset = {x = 0, y = 0.1}
    })
end


function AKYRS.get_p_card_ranks(not_r)
    not_r = not_r or {}
    local ranks = {}
    if not G.playing_cards then return {} end
    for i,j in ipairs(G.playing_cards) do
        --print(j.base.value)
        if j and not SMODS.has_no_rank(j) and j.base.value and SMODS.Ranks[j.base.value] and not not_r[j.base.value] and not AKYRS.find_index(ranks,SMODS.Ranks[j.base.value]) then
            table.insert(ranks,SMODS.Ranks[j.base.value])
        end
    end
    return ranks
end

AKYRS.sort_top = function(a, b)
    return (a.akyrs_stay_on_top or 0) < (b.akyrs_stay_on_top or 0)
end

AKYRS.should_hide_ui = function()
    return next(SMODS.find_card("j_akyrs_no_hints_here")) or G.GAME.akyrs_no_hints or nil
end


AKYRS.blacklist_mod = {
    ["cry_prob"] = true,
    ["akyrs_cycler"] = true,
    ["immutable"] = true,
    ["pos"] = true,
    ["atlas"] = true,
    ["soul_pos"] = true,
}

AKYRS.edition_extend_card_limit = function(card)
    if card then
        if card.edition then
            if card.edition.key == "e_negative" then
                return 1
            end
            if card.edition.key == "e_akyrs_noire" then
                return 2
            end
        end
    end
    return 0
end

AKYRS.card_any_drag = function()
    return G and G.GAME and ((G.GAME.akyrs_any_drag and not G.OVERLAY_MENU) or G.GAME.akyrs_ultimate_freedom)
end

AKYRS.construct_case_base = function(suit, rank)
    
    local _suit = SMODS.Suits[suit]
    local _rank = SMODS.Ranks[rank]
    if not _suit or not _rank then
        return nil, ('Tried to call SMODS.change_base with invalid arguments: suit="%s", rank="%s"'):format(suit, rank)
    end
    return G.P_CARDS[('%s_%s'):format(_suit.card_key, _rank.card_key)]
end


AKYRS.bal = function(balance)
    if balance then
        return G.PROFILES[G.SETTINGS.profile].akyrs_balance == balance
    end
    return G.PROFILES[G.SETTINGS.profile].akyrs_balance
end

AKYRS.set_bal = function(balance)
    G.PROFILES[G.SETTINGS.profile].akyrs_balance = balance
end

AKYRS.toggle_bal = function(balance)
    G.PROFILES[G.SETTINGS.profile].akyrs_balance = G.PROFILES[G.SETTINGS.profile].akyrs_balance == "adequate" and "absurd" or "adequate"
end

AKYRS.bal_overridable = function(balance, override)
    return override and AKYRS.bal(override) or AKYRS.bal(balance)
end

AKYRS.bal_val = function(adeq,absu)
    if AKYRS.bal("adequate") then return adeq end
    if AKYRS.bal("absurd") then return absu end
end

AKYRS.bal_val_overridable = function(adeq,absu,override)
    if AKYRS.bal_overridable("adequate",override) then return adeq end
    if AKYRS.bal_overridable("absurd",override) then return absu end
end


function AKYRS.bulk_level_up(center, card, area, copier, number, silent)
	local used_consumable = copier or card
	if not number then
		number = 1
	end
	for _, v in pairs(card.config.center.config.akyrs_hand_types) do
		update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
			handname = localize(v, "poker_hands"),
			chips = G.GAME.hands[v].chips,
			mult = G.GAME.hands[v].mult,
			level = G.GAME.hands[v].level,
		})
		SMODS.smart_level_up_hand(used_consumable, v, silent, number)
	end
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

function AKYRS.silent_bulk_level_up(center, card, area, copier, number)
	local used_consumable = copier or card
	if not number then
		number = 1
	end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_words_long'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    
    SMODS.upgrade_poker_hands({
        from = card,
        hands = card.config.center.config.akyrs_hand_types,
        level_up = number,
        instant = true,
    })
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

function AKYRS.blk_lvl_up(hands, card, number)
	local used_consumable = card
	if not number then
		number = 1
	end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_akyrs_multiple_hands'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    for k, v in pairs(hands) do
		SMODS.smart_level_up_hand(used_consumable, k, true, number)
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end


AKYRS.shallow_indexed_table_copy = function(t)
    local t2 = {}
    for i,k in ipairs(t) do
        table.insert(t2,k)
    end
    return t2
end

AKYRS.get_current_blind_config = function()
    return G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
end

function AKYRS.search_UIT_for_id(uit, id)
    if not id or not uit then return nil end
    for _, node in ipairs(uit.nodes or {}) do
        if node.config and node.config.id == id then
            return node
        elseif node.nodes then
            local result = AKYRS.search_UIT_for_id(node, id)
            if result then
                return result
            end
        end
    end
    return nil
end


AKYRS.icon_sprites = {}

AKYRS.remove_formatting = function(string_in)
    return string.gsub(string_in, "{.-}", "")
end
AKYRS.full_ui_add = function(nodes, key, scale)
    local m = G.localization.descriptions["DescriptionDummy"][key]
    if not m then assert("You forgot the localization!") end
    local l = {
        {
            n = G.UIT.R,
            nodes = {
                { n = G.UIT.T, config = { text = m.name, colour = G.C.UI.TEXT_LIGHT, scale = scale*1.2 }},
            }
        }
    }
    if m.text and false then
        for i, tx in ipairs(m.text) do
            table.insert(l, 
                {
                    n = G.UIT.R,
                    nodes = {
                        { n = G.UIT.T, config = { text = AKYRS.remove_formatting(tx), colour = G.C.UI.TEXT_LIGHT, scale = scale }},
                    }
                }
            )
        end
    end
    
    local x = {
        n = G.UIT.C,
        config = { align = "lm", padding = 0.1 },
        nodes = {
            { n = G.UIT.R, config = {}, nodes = l },
            
        }
    }
    table.insert(nodes, x)
end

AKYRS.hand_sort_function = function (a,b)
    if G.GAME and G.GAME.words_reversed then
        return a.T.x > b.T.x
    end
    return a.T.x < b.T.x    
end

AKYRS.hand_sort_function_immute = function (a,b)
    return a.T.x < b.T.x    
end


G.FUNCS.go_to_aikoyori_discord_server = function(e)
    love.system.openURL( "https://discord.gg/JVg8Bynm7k" )
end


G.FUNCS.akyrs_open_link = function(e)
    love.system.openURL( e.config.link )
end


AKYRS.get_letter_freq_from_cards = function(listofcards)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        local w = string.lower(v:get_letter_with_pretend())
        wordArray[w] = wordArray[w] and wordArray[w] + 1 or 1
    end
    return wordArray
end
AKYRS.get_ranks_freq_from_cards = function(listofcards)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        if not SMODS.has_no_rank(v) then
            local w = v:get_id()
            wordArray[w] = wordArray[w] and wordArray[w] + 1 or 1
        end
    end
    return wordArray
end

AKYRS.get_suit_freq_from_cards = function(listofcards, no_count_wild)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        if not SMODS.has_no_suit(v) then
            if no_count_wild and v.base and v.base.suit then
                wordArray[v.base.suit] = wordArray[v.base.suit] and wordArray[v.base.suit] + 1 or 1
            else
                for j,st in pairs(SMODS.Suits) do
                    if v:is_suit(j) then
                        wordArray[j] = wordArray[j] and wordArray[j] + 1 or 1
                    end
                end
            end
        end
    end
    return wordArray
end

AKYRS.get_enhancements_freq_from_cards = function(listofcards)
    
    local enchamarr = {}
    for i,v in ipairs(listofcards) do
        if v.config and v.config.center and v.config.center.key ~= "c_base" then
            enchamarr[v.config.center.key] = enchamarr[v.config.center.key] and enchamarr[v.config.center.key] + 1 or 1
        end
    end
    return enchamarr
end

function AKYRS.is_valid_enhancement(name)
    for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
        local first_part = string.split(v.name," ")[1]
        if first_part == name then
            return true
        end
    end
    return false
end

function AKYRS.is_valid_edition(name)
    for _, v in pairs(G.P_CENTER_POOLS.Edition) do
        if v.name == name then
            return true
        end
    end
    return false
end

function AKYRS.recalculate_cardarea_bundler(cardarea, func, reset)
    local logic = func or function(x) return x.states.drag.is or x.states.click.is end
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        if logic(card) then
            
            card.following_cards = reset and {} or (card.following_cards or {})
            for ke, card2 in ipairs(cardarea.cards) do
                if ke > k and not AKYRS.is_in_table(card.following_cards,card2) and not card2.is_being_pulled then
                    table.insert(card.following_cards, card2)
                    --print(AKYRS.C2S(card2))
                    --print("CARDS IN THE THING - "..AKYRS.TBL_C2S(card.following_cards))
                    
                end
            end
        end

    end
    cardarea.last_card_amnt = #cardarea.cards
end
function AKYRS.reset_cardarea_bundler(cardarea)
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        card.following_cards = nil

    end
end

AKYRS.crypternity = function (e)
    e.akyrs_sigma = true
    return e
end


AKYRS.word_to_cards = function(word)
    
    local wordArray = AKYRS.word_splitter(word)
    local cards = {}
    for i, k in ipairs(wordArray) do
        local new_c = AKYRS.create_random_card("maxwellui")
        new_c.is_null = true
        new_c:set_letters(k)
        new_c.ability.forced_letter_render = true
        table.insert(cards, new_c)
    end
    return cards
end

AKYRS.w2hand = function( word )
    local t = AKYRS.word_to_cards( word )
    for _,c in ipairs(t) do table.insert(G.playing_cards,c) G.hand:emplace(c) end
end

function AKYRS.should_multiply_value(center, abil_key)
    local validability = {
        x_mult = true,
        x_chips = true,
        h_x_chips = true,
        min_highlighted = true, -- don't change it
    }
    if not validability[abil_key] then
        return true
    end
    local new_ability = {
        x_mult = center.config.Xmult or center.config.x_mult,
        x_chips = center.config.x_chips,
        h_x_chips = center.config.h_x_chips,
    }
    if validability[abil_key] and new_ability[abil_key] then
        return true
    end
    return false
end

AKYRS.mod_card_values = function(card, config)
    if not config then config = {} end
    if not card then return end 
    if not card.config and not card.config.center then return end 
    local tw = card.T.w
    local th = card.T.h
    local card_table_to_load = card:save()
    local og_save = card:save()
    local add = config.add or 0
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local reference
    if config.prefer_original_value then
        reference = config.reference or card.config.center.config or og_save.ability or card.ability or AKYRS.deep_copy(card)
    else
        reference = config.reference or og_save.ability or card.config.center.config or card.ability or AKYRS.deep_copy(card)
    end
    local randomize = config.random

    local function modify_values(_table_in, ref, depth)
        if not ref or type(ref) ~= "table" then return end
        if depth > 2 then return end
        for k, v in pairs(_table_in) do 
            local rand = 1
            if randomize then
                local val = pseudorandom("akyrs_mod_val")
                local val2 = pseudorandom("akyrs_mod_val_2",randomize.digits_min, randomize.digits_max)
                rand = val * 10 ^ val2
            end
            if AKYRS.should_multiply_value(card.config.center, k) then
                if type(v) == "number" then
                    if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                        if ref and ref[k] then
                            _table_in[k] = (ref[k] + add) * multiply * rand
                        end
                    end
                elseif type(v) == "table" and ref and k and not unkeyword[k] then
                    modify_values(v, ref[k], depth + 1)
                elseif Talisman and type(v) == "table" and v.to_number and (to_number(v) == v) then
                    if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                        if ref and ref[k] then
                            _table_in[k] = (to_big(ref[k]) + to_big(add)) * to_big(multiply) * to_big(rand)
                        end
                    end
                end
            end
        end
    end
    if type(reference) == 'table' then
        modify_values(card_table_to_load.ability, reference, 0)
    end
    card:load(card_table_to_load)
    card.T.w = tw
    card.T.h = th
    card:set_sprites(card.config.center)
end

-- genuinely do not use this function bruh
AKYRS.mod_card_values_misprint = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local multiply = config.multiply or 1
    local randomize = config.random or {digits_min = 1, digits_max = 1, min = 1, max = 1,scale = 1 }
    local random_seed = config.randomseed or "modcardvalue"
    random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. " - " .. random_seed
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or AKYRS.blacklist_mod or {}
    local function_check = config.func or function(name, value) return true end
    local reference = config.reference or table_in
    local function modify_values(table_in, ref)
        for k, v in pairs(table_in) do
            if type(v) == "number" then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] and function_check(k,ref[k]) then
                        local numberstr = randomize.can_negate and pseudorandom_element({"","-",pseudoseed(random_seed.."a")}) or ""
                        local digits = pseudorandom(pseudoseed(random_seed.."ab"),randomize.digits_min,randomize.digits_max)
                        for i = 1,digits do
                            numberstr = numberstr .. pseudorandom(pseudoseed(random_seed.."b"),0,9)
                        end
                        if numberstr == "" or numberstr == "-" then
                            numberstr = "0"
                        end
                        local number = tonumber(numberstr) * (10 ^ randomize.scale)
                        number = math.fmod(number,randomize.max - randomize.min) + randomize.min
                        table_in[k] = (ref[k] + add) * multiply * number
                    end
                end
            elseif type(v) == "table" and ref and k then
                modify_values(v, ref[k])
            end
        end
    end
    if table_in == nil then
        return
    end
    modify_values(table_in, reference)
end

AKYRS.get_suits = function(tbl_o_cards) 
    local s = {}
    local st = {}
    for _,card in ipairs(tbl_o_cards) do
        for suit,_ in pairs(SMODS.Suits) do
            if card:is_suit(suit) and not st[suit] then
                table.insert(s,suit)
                st[suit] = true
            end
        end
    end
    return s,st
end

AKYRS.mod_debug_info_set = function ()
    AKYRS.debug_info = {
        -- ["Balance"] = AKYRS.bal() or "BALANCE NOT SET."
    }
end
AKYRS.mod_debug_info_set()

AKYRS.should_draw_letter = function(card)
    return G.GAME.akyrs_character_stickers_enabled or (card.ability and card.ability.forced_letter_render) or AKYRS.word_blind()
end
AKYRS.should_calculate_word = function()
    return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled) or AKYRS.word_blind()
end


AKYRS.force_check_win = function (config)
    config = config or {}
    if not G.GAME.blind or G.GAME.akyrs_win_checked then return end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        delay = 0,
        func = function()
            local new_round
            if G.GAME.akyrs_win_checked then return true end
            if not G.GAME.akyrs_mathematics_enabled and not G.GAME.current_round.advanced_blind then
                if AKYRS.compare(G.GAME.chips,">=",G.GAME.blind.chips) or AKYRS.compare(G.GAME.current_round.hands_left,"<",1) then
                    new_round = true
                end
            end
            if G.GAME.current_round.advanced_blind and G.GAME.aiko_puzzle_win or AKYRS.compare(G.GAME.current_round.hands_left,"<",1) then
                if G.GAME.aiko_puzzle_win or G.GAME.current_round.hands_left < 1 then
                    new_round = true
                end
            elseif G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
                if (G.GAME.blind and AKYRS.is_value_within_threshold(G.GAME.blind.chips, G.GAME.chips, G.GAME.akyrs_math_threshold)) or AKYRS.compare(G.GAME.current_round.hands_left,"<",1) or AKYRS.does_hand_only_contain_symbols(G.hand) then
                    new_round = true
                end
            end
            if new_round then
                G.GAME.akyrs_win_checked = true
            end
            if new_round and config.traditional_win then
                end_round()
            elseif new_round and not config.no_winnage then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
                AKYRS.simple_event_add(function ()
                    AKYRS.simple_event_add(function ()
                            G.FUNCS.draw_from_hand_to_deck()
                            G.FUNCS.draw_from_discard_to_deck()
                            G.STATE = G.STATES.ROUND_EVAL
                            return true
                        end, 0)
                    return true
                end, 0)
            elseif not new_round then
                G.STATE = config.state_to_go or G.STATES.SELECTING_HAND
                if config.force_draw then
                    AKYRS.fill_hand()
                    AKYRS.force_save()
                end
            end
            G.STATE_COMPLETE = false
            return true
        end
    }))
end

AKYRS.set_special_card_type = function(card, type)
    if card and card.ability then card.ability.akyrs_special_card_type = type 
        card:set_sprites(card.config.center,card.config.card)
    end
end

AKYRS.initialise_deck_letter = function(letters)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.playing_cards = {}
            
            local deckloop = G.GAME.starting_params.deck_size_letter or 1
            local usedLetter = {}
            for loops = 1, deckloop do
                for i, letter in pairs(letters) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('aikoyori:akyrs_letter_randomer'))
                    local car = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'],
                        { playing_card = G.playing_card })
                    car.is_null = true

                    -- misprintize
                    if G.GAME.modifiers and G.GAME.modifiers.cry_misprint_min and G.GAME.modifiers.cry_misprint_max then
                        for k, v in pairs(G.playing_cards) do
                            Cryptid.misprintize(car)
                        end
                    end
                    if not G.GAME.starting_params.akyrs_letters_no_uppercase then
                        if not usedLetter[letter:lower()] then letter = letter:upper() usedLetter[letter:lower()]=true else letter = letter:lower() end
                    end
                    car:set_letters(letter)
                    G.deck:emplace(car)

                    table.insert(G.playing_cards, car)
                    -- for cryptid
                    if G.GAME.modifiers and G.GAME.modifiers.cry_ccd then
                        for k, v in pairs(G.playing_cards) do
                            v:set_ability(Cryptid.random_consumable('cry_ccd', { "no_doe", "no_grc" }, nil, nil, true),
                                true, nil)
                        end
                    end
                end
            end
            G.GAME.starting_deck_size = #G.playing_cards


            G.deck:shuffle('akyrsletterdeck')
            return true
        end
    }))
end

---@params config? table config
AKYRS.get_bomb_prompt = function(config)
    config = config or {}
    local seed = config.seed or "bullshit"
    local max_freq = math.min(config.max_freq or 1e10,1e10) -- max is er with this number
    local min_freq = math.max(config.min_freq or 1000,1) 
    local max_length = math.min(config.max_length or 5, 5)
    local min_length = math.max(config.min_length or 2, 2)
    local matching = table.akyrs_filter(AKYRS.pickable_bomb_prompts, 
        function(value) 
            local f = AKYRS.bomb_prompts[value] 
            return f >= min_freq and f <= max_freq and #value >= min_length and #value <= max_length
        end)
    local freq, word
    word = pseudorandom_element(matching, seed, {})
    freq = AKYRS.bomb_prompts[word]
    return word, freq
end


G.FUNCS.akyrs_force_draw_from_discard_to_hand = function(e)
G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = function()
        local discard_count = #G.discard.cards
        for i=1, discard_count do --draw cards from deck
            draw_card(G.discard, G.hand, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
        end
        return true
    end
    }))
end

AKYRS.draw_cards_back_to_hand = function(cards, to)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local cx = #cards
            for i=1, cx do --draw cards from deck
                draw_card(cards[i].area, to, i*100/cx,'up', nil ,cards[i], 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
                if (cards[i].area ~= to) then
                    if AKYRS.is_playing_card_area(cards[i].area) then
                        AKYRS.remove_value_from_table(G.playing_cards, cards[i]) 
                    end
                    if AKYRS.is_playing_card_area(to) then
                        table.insert(G.playing_cards, cards[i]) 
                    end
                end
            end
            return true
        end
        }))
end

AKYRS.create_hover_tooltip = function(args)
    args = args or {}
    return {
        n = args.top_level_node or G.UIT.C,
        config = { 
            align = "cm"
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    hover = true,
                    can_collide = true, 
                    r = args.round or 0.1,
                    maxh = args.w or 0.5,
                    maxw = args.h or 0.5,
                    minh = args.w or 0.5,
                    minw = args.h or 0.5,
                    focus_args = { snap_to = true },
                    detailed_tooltip = AKYRS.DescriptionDummies[args.tooltip_key or "dd_akyrs_yona_yona_ex"], 
                    func = args.func,
                    colour = args.colour or G.C.BLUE,
                    padding = args.padding or 0.1,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = args.text or "i",
                            colour = args.text_colour or G.C.WHITE,
                            scale = args.scale or 0.3,
                        }
                    }
                }
            }
        }
    }
end

function AKYRS.invert_selection(area, is_boss)
    if (not area or not area.cards) or is_boss then return end
    local tobe_hilight = {}
    local tobe_unhilight = {}
    for _, c in ipairs(area.cards) do
        if not AKYRS.is_in_table(area.highlighted, c) then
            table.insert(tobe_hilight, c)
        else
            table.insert(tobe_unhilight, c)
        end
    end
    for _, c in ipairs(tobe_unhilight) do
        c:highlight(false)
    end
    area.highlighted = {}
    if #tobe_hilight ==  0 then
        local cd = pseudorandom_element(area.cards, "AKYRS.invert_selection")
        table.insert(tobe_hilight, cd)
    end
    for _, c in ipairs(tobe_hilight) do
        c.highlighted = true
        table.insert(area.highlighted, c)
    end
end

AKYRS.aiko_click = function (self)
    Card.click(self)
    AKYRS.simple_event_add(
        function ()
            self.akyrs_clicked_cnt = (self.akyrs_clicked_cnt or -1) + 1
            self:juice_up(self.akyrs_clicked_cnt * 0.1, self.akyrs_clicked_cnt*0.1)
            local pitch = AKYRS.shift_semitone(1, AKYRS.semitones_from_tone_table(AKYRS.NOTE_MAJOR,self.akyrs_clicked_cnt))
            play_sound('generic1', pitch)
            play_sound('akyrs_piano', pitch, 0.5)
            if self.akyrs_clicked_cnt >= 7 then
                G.SETTINGS.paused = true
                self.akyrs_clicked_cnt = -1
                G.FUNCS.overlay_menu({
                definition = create_UIBox_generic_options({
                    contents = {
                        AKYRS.SOL.get_UI_definition()
                    }
                    }),
                })
            end 
            return true
        end, 0, "akyrs_misc"
    )
end

AKYRS.apply_random_p_attrib = function(self)
    local card = pseudorandom_element(G.P_CARDS,pseudoseed("akyrsmodcard"))
    self:set_base(card)
    self.is_null = true
    if self.children and self.children.front then
        self.children.front:remove()
        self.children.front = nil
    end
end

AKYRS.is_playing_card_area = function(ca)
    return ca == G.hand or ca == G.deck
end
AKYRS.is_playing_card = function(cr)
    return cr.ability and (cr.ability.set == "Default" or cr.ability.set == "Enhanced")
end


AKYRS.is_mp = function()
    if (MP and (MP.LOBBY.code or MP.LOBBY.ruleset_preview)) then return true end
end

AKYRS.mp_check = function(sp,mp)
    if MP and (MP.LOBBY.code or MP.LOBBY.ruleset_preview) then return mp end
    return sp
end

AKYRS.ease_lives_mp = function(lives)
    if MP and MP and (MP.LOBBY.code or MP.LOBBY.ruleset_preview) then MP.UI.ease_lives(lives) MP.GAME.lives = MP.GAME.lives + lives end
end

AKYRS.mod_scenario_rounds = function (sc, mod, instant, juice, timer)
    if not AKYRS.is_scenario_tag(sc) then return end
    local fx = function ()
        local fnl = math.max(0,math.min(sc.akyrs_rounds_left + mod, sc.akyrs_total_rounds))
        if not timer then 
            local returnval = SMODS.calculate_context({ akyrs_scenario_ticks = sc, original_amnt = sc.akyrs_rounds_left, mod = mod, final_amount = fnl }) 
            -- TODO: do something with return values
        end
        sc.akyrs_rounds_left = fnl
        if sc.config.akyrs_timed_scenario then
            sc.akyrs_previous_left_number = sc.akyrs_previous_left_number or sc.akyrs_total_rounds
            local decreases = (sc.akyrs_rounds_left <= 3) and 0.25 or (sc.akyrs_rounds_left < 10) and 0.5 or 1
            if mod < 0 then
                if math.floor(sc.akyrs_previous_left_number / decreases - 1) ~= math.floor(sc.akyrs_rounds_left / decreases) then
                    sc.akyrs_previous_left_number = sc.akyrs_previous_left_number - decreases
                    sc:juice_up(0.1,0.1)
                    play_sound('button', 2, 0.3)
                    play_sound('button', 0.5, 0.3)
                end
            else
                sc.akyrs_previous_left_number = math.ceil(sc.akyrs_rounds_left)
            end

        end
        if juice then sc:juice_up(0.3,0.3) end
        if sc.akyrs_rounds_left <= 0 and not sc.removed then
            if sc.config.tag_expire then sc.config:tag_expire(sc) 
                SMODS.calculate_context({akyrs_scenario_tag_expired = _tag}) 
            end
            
            if sc.config.akyrs_timed_scenario then
                play_sound('glass'..pseudorandom("akyrs_scenario_expire",1,6), 2, 0.4)
            end
            sc:remove()
        end
        return true
    end
    if instant then fx() else AKYRS.simple_event_add(fx, 0) end
end

function AKYRS.end_round_hook()
    G.GAME.akyrs_lock_card_working_amount = G.GAME.akyrs_lock_card_amnt
    for _, sc in ipairs(G.GAME.akyrs_scenario) do
        if not sc.config.akyrs_no_decays then 
            SMODS.calculate_effect({ message = localize("k_akyrs_downgrade_ex"), func = function ()
                AKYRS.mod_scenario_rounds(sc, -1)
            end }, sc)
        end
    end
    AKYRS.SEVEN_WONDERS_CARDS_THAT_SHOULD_GIVE_XSCORE = nil
    local x = G.playing_cards
    if G.GAME.blind.debuff.akyrs_destroy_unplayed then
        for i, card in ipairs(x) do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    if not card.ability.akyrs_played_this_round and G.GAME.blind.debuff.akyrs_destroy_unplayed then
                        card.area:remove_card(card)
                        
                        SMODS.destroy_cards({card})
                        AKYRS.remove_value_from_table(G.playing_cards, card)
                    end
                    card.ability.akyrs_played_this_round = false
                    card.ability.akyrs_scored_this_round = false
                    card.ability.akyrs_debuffed_by_dog = nil
                    return true
                end,
                delay = 0,
            }), 'base')
        end
    else
        for i, card in ipairs(x) do
            card.ability.akyrs_played_this_round = false
            card.ability.akyrs_scored_this_round = false
            card.ability.akyrs_debuffed_by_dog = nil
        end
    end
    for _, level in ipairs({"common","uncommon","rare"}) do
        if level ~= "rare" or G.GAME.blind_on_deck == "Boss" then
            G.GAME.akyrs_chicanery_rerolls_info[level.."_left"] = G.GAME.akyrs_chicanery_rerolls_info[level.."_has"]
        end
    end
    G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round = false
    --print(G.GAME.blind_on_deck)
    if G.GAME.akyrs_life_heal then
        local life_heal = 0
        if G.GAME.akyrs_life_heal.ante > 0 and G.GAME.blind_on_deck == "Boss" then
            life_heal = life_heal + G.GAME.akyrs_life_heal.ante
        end
        if G.GAME.akyrs_life_heal.round > 0 then
            life_heal = life_heal + G.GAME.akyrs_life_heal.round
        end
        if life_heal ~= 0 then 
            AKYRS.mod_life(life_heal, false, 1)
        end
    end
    if #SMODS.find_card("j_akyrs_you_tried") > 0 and AKYRS.is_mp() and not MP.is_pvp_boss() then        
        local card = SMODS.find_card("j_akyrs_you_tried")[1]
        AKYRS.simple_event_add(function()
            if card.ability.extras.last_life ~= MP.GAME.lives then
                SMODS.destroy_cards({card})
                card.ability.extras.unset = false
                ease_dollars(card.ability.extras.lives_mp_set_money)
            end
            return true
        end, 0)   
    end
    if G.GAME.akyrs_sfc_used then
        if AKYRS.is_mp() then
            AKYRS.ease_lives_mp(G.GAME.akyrs_sfc_used)
        else
            ease_ante(G.GAME.akyrs_sfc_used)
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + G.GAME.akyrs_sfc_used
        end

    end
    G.GAME.akyrs_sfc_used = nil
    
    if G.playing_card then
        AKYRS.remove_dupes(G.playing_cards)
    end
    for _, cardarea in ipairs(G.I.CARDAREA) do
        if cardarea and cardarea.cards then
            
            for i, card in ipairs(cardarea.cards) do
                local is_pc = AKYRS.is_being_used_as_playing_card(card)
                if card.ability.akyrs_self_destructs then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.destroy_cards({card})
                            AKYRS.remove_value_from_table(G.playing_cards,card)
                            return true
                        end,
                        delay = 0.5,
                    }), 'base')
                end
                if card.ability.akyrs_attention then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.destroy_cards({card})
                            AKYRS.remove_value_from_table(G.playing_cards,card)
                            return true
                        end,
                        delay = 0.5,
                    }), 'base')
                end
                if card.ability.akyrs_sus then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local ros = pseudorandom_element({"r","s"},"akyrs_sus_random")
                            if ros == "r" then
                                rank = pseudorandom_element(SMODS.Ranks,"akyrs_sus_r")
                                SMODS.change_base(card, nil, rank.key)
                            elseif ros == "s" then
                                suit = pseudorandom_element(SMODS.Suits,"akyrs_sus_s")
                                SMODS.change_base(card, suit.key, nil)
                            end
                            return true
                        end,
                        delay = 0.5,
                    }), 'base')
                end
                if SMODS.get_enhancements(card)["m_akyrs_ash_card"] or card.config.center_key == "j_akyrs_ash_joker" then
                    local odder = SMODS.pseudorandom_probability(card,"akyrs_ash_card",1,card.ability.extras.odds)
                    if odder then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.destroy_cards({card})
                                return true
                            end,
                            delay = 0.5,
                        }), 'base')
                    end

                end
                if SMODS.get_enhancements(card)["m_akyrs_item_box"] and card.ability.akyrs_triggered then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.destroy_cards({card})
                            return true
                        end,
                        delay = 0.5,
                    }), 'base')
                end
                if card.edition and card.edition.key == "e_akyrs_burnt" then
                    local odder = SMODS.pseudorandom_probability(card,"akyrs_ash_card",1,card.edition.extras.odds)
                    if odder then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local area = card.area
                                if area == G.jokers or area == G.consumeables then
                                    SMODS.add_card({ key = "j_akyrs_ash_joker"})
                                    
                                end
                                if area == G.deck or area == G.hand or area == G.discard then
                                    local c = SMODS.add_card({ key = "m_akyrs_ash_card" , area = G.deck})
                                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                                    table.insert(G.playing_cards, c)
                                end
                                SMODS.destroy_cards({card})
                                
                                return true
                            end,
                            delay = 0.5,
                        }), 'base')
                    end
                end
                if card.ability.akyrs_triggered then
                    card.ability.akyrs_triggered = nil
                end
            end
            AKYRS.simple_event_add(
                function ()
                    cardarea.cards = AKYRS.filter_table(cardarea.cards, function (c)
                        return not c.REMOVED and not c.being_removed
                    end, true, true)
                    AKYRS.remove_dupes(cardarea.cards)
                    return true
                end, 0
            )
        end
    end
end

function AKYRS.end_round_event()
    AKYRS.simple_event_add(function ()
        AKYRS.end_round_hook()
        return true
    end, 0)
end

function AKYRS.should_show_card_previews()
    return AKYRS.config.show_joker_preview and not G.DENY_DYNAMIC_TEXT -- mainly for slay the jokers
end
function AKYRS.edition_loc_center_key_getter(card)
    -- noire has card limit shemamigans sooooo
    if card.area then
        if card.area == G.jokers then
            return "_joker"
        end
        if card.area == G.consumeables then
            return "_joker"
        end
        if card.area == G.hand or card.area == G.play then
            return "_hand"
        end
    end
    if card.ability or (card.config or {}).center then
        local ct = (card.ability or card.config.center or {})
        local set = ct.set 
        
        if set == "Joker" then
            return "_joker"
        end
        if ct.consumeable then
            return "_consumable"
        end
        if set == "Default" or set == "Enhanced" then
            return "_hand"
        end
    end
    return ""
end

function AKYRS.blocking_unlock_achievement(achievement_name)
    if G.PROFILES[G.SETTINGS.profile].all_unlocked and (G.ACHIEVEMENTS and G.ACHIEVEMENTS[achievement_name] and not G.ACHIEVEMENTS[achievement_name].bypass_all_unlocked and SMODS.config.achievements < 3) or (SMODS.config.achievements < 3 and (G.GAME.seeded or G.GAME.challenge)) then return true end
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        blockable = true,
        blocking = true,
        func = function()
            if G.STATE ~= G.STATES.HAND_PLAYED then 
                if G.PROFILES[G.SETTINGS.profile].all_unlocked and (G.ACHIEVEMENTS and G.ACHIEVEMENTS[achievement_name] and not G.ACHIEVEMENTS[achievement_name].bypass_all_unlocked and SMODS.config.achievements < 3) or (SMODS.config.achievements < 3 and (G.GAME.seeded or G.GAME.challenge)) then return true end
                local achievement_set = false
                if not G.ACHIEVEMENTS then fetch_achievements() end
                G.SETTINGS.ACHIEVEMENTS_EARNED[achievement_name] = true
                G:save_progress()
                
                if G.ACHIEVEMENTS[achievement_name] and G.ACHIEVEMENTS[achievement_name].mod then 
                    if not G.ACHIEVEMENTS[achievement_name].earned then
                        --|THIS IS THE FIRST TIME THIS ACHIEVEMENT HAS BEEN EARNED
                        achievement_set = true
                        G.FILE_HANDLER.force = true
                    end
                    G.ACHIEVEMENTS[achievement_name].earned = true
                end
                
                if achievement_set then 
                    notify_alert(achievement_name)
                    return true
                end
                if G.F_NO_ACHIEVEMENTS and not (G.ACHIEVEMENTS[achievement_name] or {}).mod then return true end

                --|LOCAL SETTINGS FILE
                --|-------------------------------------------------------
                if not G.ACHIEVEMENTS then fetch_achievements() end

                G.SETTINGS.ACHIEVEMENTS_EARNED[achievement_name] = true
                G:save_progress()
                if G.ACHIEVEMENTS[achievement_name] and not G.STEAM then 
                    if not G.ACHIEVEMENTS[achievement_name].earned then
                        --|THIS IS THE FIRST TIME THIS ACHIEVEMENT HAS BEEN EARNED
                        achievement_set = true
                        G.FILE_HANDLER.force = true
                    end
                    G.ACHIEVEMENTS[achievement_name].earned = true
                end
                --|-------------------------------------------------------


                --|STEAM ACHIEVEMENTS
                --|-------------------------------------------------------
                if G.STEAM then 
                    if G.ACHIEVEMENTS[achievement_name] then 
                        if not G.ACHIEVEMENTS[achievement_name].earned then
                            --|THIS IS THE FIRST TIME THIS ACHIEVEMENT HAS BEEN EARNED
                            achievement_set = true
                            G.FILE_HANDLER.force = true
                            local achievement_code = G.ACHIEVEMENTS[achievement_name].steamid
                            local success, achieved = G.STEAM.userStats.getAchievement(achievement_code)
                            if not success or not achieved then
                                G.STEAM.send_control.update_queued = true
                                G.STEAM.userStats.setAchievement(achievement_code)
                            end
                        end
                        G.ACHIEVEMENTS[achievement_name].earned = true
                    end
                end
                --|-------------------------------------------------------

                --|Other platforms
                --|-------------------------------------------------------

                --|-------------------------------------------------------

                if achievement_set then notify_alert(achievement_name) end
                return true
            end
        end
        }), 'achievement')
end

-- used internally for some bosses, should not be used by any cards if possible
function AKYRS.force_disable_blind()
    G.AKYRS_FORCE_BLIND_DISABLE = true
    G.GAME.blind:disable()
    G.AKYRS_FORCE_BLIND_DISABLE = nil

end


function AKYRS.get_free_joker_roll_tier()
    return G.GAME and G.GAME.akyrs_premium_joker_roll_tier or 0
end

-- add redemption code here
AKYRS.redemption_codes = {
    "dQw4w9WgXcQ", -- astley man
    "lgAlH2HwbGA", -- worlders from pjsk
    "H88kps8X4Mk", -- hanaichi monme zutomayo
    "dOrMufo2Hx8", -- aki no mikakunin seibutsu cover that won the vocacolle
    "qXkkhP0d_iM", -- same song but the original
    "zjEMFuj23B4", -- zutomayo shader
    "3GzRDW3hZ1k", -- deco27 hao
    "JZaFgVQwXmA", -- hiiragi magnetite disclose flick
    "Soy4jGPHr3g", -- tetoris
    "PqpCRSOUuIE", -- ABM signaling
    "e5_XSeN9Y4k", -- aiaigasa ui
    "_gWn38pnmqI", -- snooze shiki ver
    "F38EuG2dAyM", -- doctor kidori
    "zO3nTu4rCKQ", -- we are charlie kirk mandarin dub
    "OHAjc-ayhus", -- abuku yorushika
    "000-000-000", -- ok what the fuck do i do with this one
}

function AKYRS.get_random_redemption_code(seed)
    if not seed or not G.GAME or not G.GAME.pseudorandom then return "WECHALIEKRK" end -- won't you say so, joe
    return G.GAME and pseudorandom_element(AKYRS.redemption_codes, seed and "akyrs_redemption_code_voucher_".. G.SEED.."_"..seed or "akyrs_redemption_code") or "?????????"
end

function AKYRS.trigger_tldr_conditions(condition)
    if condition and G.GAME.akyrs_tldr_conditions[condition] == false then
        G.GAME.akyrs_tldr_conditions[condition] = true
    end
    for _, c in pairs(G.GAME.akyrs_tldr_conditions) do
        if not c then
            return
        end
    end
    G.GAME.akyrs_tldr_conditions_all_done = true
end

function AKYRS.check_8H_tldr()
    if G.STAGE ~= G.STAGES.RUN then return end
    if G.GAME.akyrs_tldr_conditions["have_at_least_two_eight_of_hearts"] then return end
    local filtered_eight = AKYRS.filter_table(G.playing_cards,function (c,i,d)
        return c.base.value == "8" and c.base.suit == "Hearts" and not SMODS.has_no_rank(c) and not SMODS.has_no_suit(c)
    end,true,true)
    if #filtered_eight > 2 then
        AKYRS.trigger_tldr_conditions("have_at_least_two_eight_of_hearts")
    end
end

local akyrs_tldr_conditions_list = {
    "won_blind_oneshot",
    "has_sold_tldr",
    "got_charm_tag",
    "used_replicant",
    "redeemed_voucher",
    "sold_a_rare_joker",
    "used_intrusive_thought",
    "joker_slots_filled",
    "straight_and_flush_played_in_one_round",
    "have_at_least_two_eight_of_hearts",
}

function AKYRS.get_tldr_condition_from_index(index)
    return G.GAME.akyrs_tldr_conditions[akyrs_tldr_conditions_list[index]]
end


function AKYRS.honest_ease_background_colour(colours_targets, delay) 
    delay = delay or 0.3
    for k, v in pairs(colours_targets) do
        if type(v) == "table" then
            AKYRS.ease_colour_null_checked(G.C.BACKGROUND[k], v, delay)
        else
            ease_value(G.C.BACKGROUND, k, v - G.C.BACKGROUND[k], false, nil, true, delay)
        end
    end
end


function AKYRS.ease_colour_null_checked(old_colour, new_colour, delay, alphas)
    for i, v in ipairs(old_colour) do
        if old_colour[i] ~= nil and new_colour[i] ~= nil and (i ~= 4 or alphas) then
            AKYRS.better_ease_value(old_colour, i, new_colour[i] - old_colour[i], false, 'REAL', nil, true, delay, "inoutcirc", "akyrs_bg")
        else
            old_colour[i] = old_colour[i]
        end
    end
end


function AKYRS.set_background_shaders(shader_key, colours_to)
    
    local old_contrast = G.C.BACKGROUND.contrast
    
    G.ARGS.spin = G.ARGS.spin or {
        amount = 0,
        real = 0,
        eased = 0
    }
    if not SMODS.Shaders[shader_key] then return end
    local send_t = SMODS.Shaders[shader_key].send_vars and SMODS.Shaders[shader_key]:send_vars() or {
                {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
                {name = 'spin_time', ref_table = G.TIMERS, ref_value = 'BACKGROUND'},
                {name = 'colour_1', ref_table = G.C.BACKGROUND, ref_value = 'C'},
                {name = 'colour_2', ref_table = G.C.BACKGROUND, ref_value = 'L'},
                {name = 'colour_3', ref_table = G.C.BACKGROUND, ref_value = 'D'},
                {name = 'contrast', ref_table = G.C.BACKGROUND, ref_value = 'contrast'},
                {name = 'spin_amount', ref_table = G.ARGS.spin, ref_value = 'amount'}
            }
    AKYRS.simple_event_add(
    function ()    
        AKYRS.honest_ease_background_colour({contrast = 0}, 1)
        AKYRS.simple_event_add(
        function ()
            colours_to = colours_to or {contrast = old_contrast}
            G.SPLASH_BACK:define_draw_steps({{
            shader = shader_key,
            send = send_t}})
            AKYRS.honest_ease_background_colour(colours_to, 1)
            return true
        end, 1.2, "akyrs_bg")
        return true
    end, 0, "akyrs_bg")
end


function AKYRS.load_pool(pool, meta)
    for k, v in pairs(pool) do
        v.key = k
        if not v.wip and not v.demo then
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
end

function AKYRS.save_pool(pool)
    if not pool then return end
    for k, v in pairs(pool) do
        G.ARGS.save_progress.UDA[k] = (v.unlocked and 'u' or '')..(v.discovered and 'd' or '')..(v.alerted and 'a' or '')
    end
end

function AKYRS.merge_effects(...)
    local t = {}
    for _, v in ipairs({...}) do
        for _, vv in ipairs(v) do
            if vv == true or (type(vv) == "table" and next(vv)) then
                table.insert(t, vv)
            end
        end
    end
    local returnval = table.remove(t, 1)
    local function merge(fxlist, returntbl, ind)
        if type(fxlist) == "table" and type(returntbl) == "table" then
            if fxlist[ind] == nil then return end
            returntbl.extra = fxlist[ind]
            return merge(fxlist, returntbl.extra, ind + 1)
        end
        return returntbl
    end
    merge(t, returnval, 1)
    return returnval
end

AKYRS.set_fake_ability = function(card, center_key, ogcard)
    card.fake_key = center_key
    card.params = {} 
    card.T = { x = 0, y = 0, w = 0, h = 0, scale = 1}
    card.original_T = { x = 0, y = 0, w = 0, h = 0, scale = 1}
    card.config = card.config or {}
    setmetatable(card, Card)
    Card.set_ability(card, G.P_CENTERS[center_key])
    setmetatable(card, nil)
end

AKYRS.pure_card_split = function (crd, no_pure_rank, no_pure_suit, area)
    local cardies = {}
    if not SMODS.has_no_suit(crd) and not no_pure_rank then
        local c2 = SMODS.copy_card(crd, { area = area })
        c2.ability.akyrs_special_card_type = "rank"
        c2:set_sprites(c2.config.center,c2.config.card)
        table.insert(cardies, c2)
        SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
    end
    if not SMODS.has_no_rank(crd) and not no_pure_suit then
        local c3 = SMODS.copy_card(crd, { area = area })
        c3.ability.akyrs_special_card_type = "suit"
        c3:set_sprites(c3.config.center,c3.config.card)
        table.insert(cardies, c2)
        SMODS.calculate_context({ playing_card_added = true, cards = { c3 } })
    end
    -- requested by autumm
    crd.no_graveyard = true
    -- no destroy context because it technically is not gone
    SMODS.destroy_cards({crd})
    return cardies
end

function AKYRS.is_scenario_tag(c)
    return (c and c.is and c:is(AKYRS.Scenario_Tag))
end

function AKYRS.get_card_area_name(ca) -- for debugging purposes lol
    if ca == G.play then return "play" end
    if ca == G.hand then return "hand" end
    if ca == G.deck then return "deck" end
    if ca == G.jokers then return "jokers" end
    if ca == G.consumeables then return "consumeables" end
    if ca == G.discard then return "discard" end
    if ca == 'unscored' then return "unscored" end
    return "wtf?"
end

function AKYRS.set_splash_shader(ctx, vor_spd)
    local splash_args = {mid_flash = ctx == 'splash' and 1.6 or 0.}
    ease_value(splash_args, 'mid_flash', -(ctx == 'splash' and 1.6 or 0), nil, nil, nil, 4)
    local colour1 = {name = 'colour_1', ref_table = G.C, ref_value = 'AKYRS_AIKOYORI_MAIN'}
    local colour2 = {name = 'colour_2', ref_table = G.C, ref_value = 'AKYRS_AIKOYORI_ALT'}
    if Entropy then
        colour1.ref_table = Entropy
        colour1.ref_value = "entropic_gradient"
        colour2.ref_table = Entropy
        colour2.ref_value = "reverse_legendary_gradient"
    end
    G.SPLASH_BACK:define_draw_steps({{
        shader = 'akyrs_aiko_splash',
        send = {
            {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
            {name = 'vort_speed', val = vor_spd or 0.4},
            colour1,
            colour2,
            {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
            {name = 'vort_offset', val = 0},
        }}})
end


function AKYRS.lerp(a, b, t) 
    return a + t * ( b - a )
end

AKYRS.const.pi = "31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989380952572010654858632788659361533818279682303019520353018529689957736225994138912497217752834791315155748572424541506959508295331168617278558890750983817546374649393192550604009277016711390098488240128583616035637076601047101819429555961989467678374494482553797747268471040475346462080466842590694912933136770289891521047521620569660240580381501935112533824300355876402474964732639141992726042699227967823547816360093417216412199245863150302861829745557067498385054945885869269956909272107975093029553211653449872027559602364806654991198818347977535663698074265425278625518184175746728909777727938000816470600161452491921732172147723501414419735685481613611573525521334757418494684385233239073941433345477624168625189835694855620992192221842725502542568876717904946016534668049886272327917860857843838279679766814541009538837863609506800642251252051173929848960841284886269456042419652850222106611863067442786220391949450471237137869609563643719172874677646575739624138908658326459958133904780275900994657640789512694683983525957098258226205224894077267194782684826014769909026401363944374553050682034962524517493996514314298091906592509372216964615157098583874105978859597729754989301617539284681382686838689427741559918559252459539594310499725246808459872736446958486538367362226260991246080512438843904512441365497627807977156914359977001296160894416948685558484063534220722258284886481584560285060168427394522674676788952521385225499546667278239864565961163548862305774564980355936345681743241125150760694794510965960940252288797108931456691368672287489405601015033086179286809208747609178249385890097149096759852613655497818931297848216829989487226588048575640142704775551323796414515237462343645428584447952658678210511413547357395231134271661021359695362314429524849371871101457654035902799344037420073105785390621983874478084784896833214457138687519435064302184531910484810053706146806749192781911979399520614196634287544406437451237181921799983910159195618146751426912397489409071864942319615679452080951465502252316038819301420937621378559566389377870830390697920773467221825625996615014215030680384477345492026054146659252014974428507325186660021324340881907104863317346496514539057962685610055081066587969981635747363840525714591028970641401109712062804390397595156771577004203378699360072305587631763594218731251471205329281918261861258673215791984148488291644706095752706957220917567116722910981690915280173506712748583222871835209353965725121083579151369882091444210067510334671103141267111369908658516398315019701651511685171437657618351556508849099898599823873455283316355076479185358932261854896321329330898570642046752590709154814165498594616371802709819943099244889575712828905923233260972997120844335732654893823911932597463667305836041428138830320382490375898524374417029132765618093773444030707469211201913020330380197621101100449293215160842444859637669838952286847831235526582131449576857262433441893039686426243410773226978028073189154411010446823252716201052652272111660396665573092547110557853763466820653109896526918620564769312570586356620185581007293606598764861179104533488503461136576867532494416680396265797877185560845529654126654085306143444318586769751456614068007002378776591344017127494704205622305389945613140711270004078547332699390814546646458807972708266830634328587856983052358089330657574067954571637752542021149557615814002501262285941302164715509792592309907965473761255176567513575178296664547791745011299614890304639947132962107340437518957359614589019389713111790429782856475032031986915140287080859904801094121472213179476477726224142548545403321571853061422881375850430633217518297986622371721591607716692547487389866549494501146540628433663937900397692656721463853067360965712091807638327166416274888800786925602902284721040317211860820419000422966171196377921337575114959501566049631862947265473642523081770367515906735023507283540567040386743513622224771589150495309844489333096340878076932599397805419341447377441842631298608099888687413260472156951623965864573021631598193195167353812974167729478672422924654366800980676928238280689964004824354037014163149658979409243237896907069779422362508221688957383798623001593776471651228935786015881617557829735233446042815126272037343146531977774160319906655418763979293344195215413418994854447345673831624993419131814809277771038638773431772075456545322077709212019051660962804909263601975988281613323166636528619326686336062735676303544776280350450777235547105859548702790814356240145171806246436267945612753181340783303362542327839449753824372058353114771199260638133467768796959703098339130771098704085913374641442822772634659470474587847787201927715280731767907707157213444730605700733492436931138350493163128404251219256517980694113528013147013047816437885185290928545201165839341965621349143415956258658655705526904965209858033850722426482939728584783163057777560688876446248246857926039535277348030480290058760758251047470916439613626760449256274204208320856611906254543372131535958450687724602901618766795240616342522577195429162991930645537799140373404328752628889639958794757291746426357455254079091451357111369410911939325191076020825202618798531887705842972591677813149699009019211697173727847684726860849003377024242916513005005168323364350389517029893922334517220138128069650117844087451960121228599371623130171144484640903890644954440061986907548516026327505298349187407866808818338510228334508504860825039302133219715518430635455007668282949304137765527939751754613953984683393638304746119966538581538420568533862186725233402830871123282789212507712629463229563989898935821167456270102183564622013496715188190973038119800497340723961036854066431939509790190699639552453005450580685501956730229219139339185680344903982059551002263535361920419947455385938102343955449597783779023742161727111723643435439478221818528624085140066604433258885698670543154706965747458550332323342107301545940516553790686627333799585115625784322988273723198987571415957811196358330059408730681216028764962867446047746491599505497374256269010490377819868359381465741268049256487985561453723478673303904688383436346553794986419270563872931748723320837601123029911367938627089438799362016295154133714248928307220126901475466847653576164773794675200490757155527819653621323926406160136358155907422020203187277605277219005561484255518792530343513984425322341576233610642506390497500865627109535919465897514131034822769306247435363256916078154781811528436679570611086153315044521274739245449454236828860613408414863776700961207151249140430272538607648236341433462351897576645216413767969031495019108575984423919862916421939949072362346468441173940326591840443780513338945257423995082965912285085558215725031071257012668302402929525220118726767562204154205161841634847565169998116141010029960783869092916030288400269104140792886215078424516709087000699282120660418371806535567252532567532861291042487761825829765157959847035622262934860034158722980534989650226291748788202734209222245339856264766914905562842503912757710284027998066365825488926488025456610172967026640765590429099456815065265305371829412703369313785178609040708667114965583434347693385781711386455873678123014587687126603489139095620099393610310291616152881384379099042317473363948045759314931405297634757481193567091101377517210080315590248530906692037671922033229094334676851422144773793937517034436619910403375111735471918550464490263655128162288244625759163330391072253837421821408835086573917715096828874782656995995744906617583441375223970968340800535598491754173818839994469748676265516582765848358845314277568790029095170283529716344562129640435231176006651012412006597558512761785838292041974844236080071930457618932349229279650198751872127267507981255470958904556357921221033346697499235630254947802490114195212382815309114079073860251522742995818072471625916685451333123948049470791191532673430282441860414263639548000448002670496248201792896476697583183271314251702969234889627668440323260927524960357996469256504936818360900323809293459588970695365349406034021665443755890045632882250545255640564482465151875471196218443965825337543885690941130315095261793780029741207665147939425902989695946995565761218656196733786236256125216320862869222103274889218654364802296780705765615144632046927906821207388377814233562823608963208068222468012248261177185896381409183903673672220888321513755600372798394004152970028783076670944474560134556417254370906979396122571429894671543578468788614445812314593571984922528471605049221242470141214780573455105008019086996033027634787081081754501193071412233908663938339529425786905076431006383519834389341596131854347546495569781038293097164651438407007073604112373599843452251610507027056235266012764848308407611830130527932054274628654036036745328651057065874882256981579367897669742205750596834408697350201410206723585020072452256326513410559240190274216248439140359989535394590944070469120914093870012645600162374288021092764579310657922955249887275846101264836999892256959688159205600101655256375678"

AKYRS.const.pi = AKYRS.map(AKYRS.split(AKYRS.const.pi), function (x)
    return tonumber(x)
end, true)