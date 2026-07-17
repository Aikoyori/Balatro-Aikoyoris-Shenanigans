

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
    for k, v in pairs(card.config.center.config.akyrs_hand_types) do
		SMODS.smart_level_up_hand(used_consumable, v, true, number)
    end
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

AKYRS.mod_card_values = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local reference = config.reference or AKYRS.deep_copy(table_in)
    local randomize = config.random

    local function modify_values(table_in, ref, depth)
        if not ref or type(ref) ~= "table" then return end
        if depth > 2 then return end
        for k, v in pairs(table_in) do 
            local rand = 1
            if randomize then
                local val = pseudorandom("akyrs_mod_val")
                local val2 = pseudorandom("akyrs_mod_val_2",randomize.digits_min, randomize.digits_max)
                rand = val * 10 ^ val2
            end
            
            if type(v) == "number" then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] then
                        table_in[k] = (ref[k] + add) * multiply * rand
                    end
                end
            elseif type(v) == "table" and ref and k and not unkeyword[k] then
                modify_values(v, ref[k], depth + 1)
            elseif Talisman and type(v) == "table" and v.to_number and (to_number(v) == v) then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] then
                        table_in[k] = (to_big(ref[k]) + to_big(add)) * to_big(multiply) * to_big(rand)
                    end
                end
            end
        end
    end
    if table_in == nil then
        return
    end
    if type(reference) == 'table' then
        modify_values(table_in, reference, 0)
    end
end

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
        ["Balance"] = AKYRS.bal() or "BALANCE NOT SET."
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

function AKYRS.end_round_hook()
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
                    return true
                end,
                delay = 0,
            }), 'base')
        end
    else
        for i, card in ipairs(x) do
            card.ability.akyrs_played_this_round = false
        end
    end
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
                if AKYRS.bal("adequate") then
                    --AKYRS.ease_lives_mp(card.ability.extras.lives_mp)
                    ease_dollars(card.ability.extras.lives_mp_set_money)
                else
                    AKYRS.ease_lives_mp(-G.GAME.round_resets.ante + card.ability.extras.lives_mp_set)
                end
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
                    local odder = AKYRS.bal("absurd") or SMODS.pseudorandom_probability(card,"akyrs_ash_card",1,card.ability.extras.odds)
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