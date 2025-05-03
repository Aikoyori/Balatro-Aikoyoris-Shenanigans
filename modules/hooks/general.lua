-- This file contains general hooks that has a bunch of things in them

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_cards_playable = 5
    ret.starting_params.akyrs_start_with_no_cards = false
    ret.starting_params.deck_size_letter = 1
    ret.akyrs_character_stickers_enabled = false
    ret.akyrs_wording_enabled = false
    ret.akyrs_mathematics_enabled = false
    ret.akyrs_letters_mult_enabled = false
    ret.akyrs_letters_xmult_enabled = false
    ret.akyrs_parser_var = AKYRS.math_default_const
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    ret.akyrs_any_drag = false
    ret.aiko_current_wordaiko_current_word = nil
    ret.aiko_current_word_table = {}
    ret.aiko_words_played = {}
    ret.letters_to_give = {}
    ret.aiko_letters_consumable_rate = 0
    AKYRS.replenishLetters()
    ret.current_round.aiko_round_played_words = {}
    ret.current_round.aiko_round_correct_letter = {}
    ret.current_round.aiko_round_misaligned_letter = {}
    ret.current_round.aiko_round_incorrect_letter = {}
    ret.current_round.aiko_played_suits = {}
    ret.current_round.akyrs_last_played_letters = {}
    ret.current_round.discards_sub = 0
    ret.current_round.hands_sub = 0
    ret.current_round.aiko_infinite_hack = "8"
    ret.current_round.advanced_blind = false
    ret.akyrs_last_ante = nil

    return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.discards_sub = 0
    G.GAME.current_round.hands_sub = 0
    if G.GAME.akyrs_last_ante ~= G.GAME.round_resets.ante then
        G.GAME.akyrs_letter_target = pseudorandom_element(AKYRS.raw_scrabble_letters, pseudoseed(G.GAME.pseudorandom.seed.."akyrs".."letter_pick"))
        G.GAME.akyrs_last_ante = G.GAME.round_resets.ante
    end
    
    EMPTY(G.GAME.akyrs_last_played_letters)
    G.GAME.akyrs_last_played_letters = {}
    G.GAME.current_round.aiko_played_suits = {}
end

function CardArea:aiko_change_playable(delta)
    
    self.config.highlighted_limit = self.config.highlighted_limit + delta
    G.GAME.aiko_cards_playable = self.config.highlighted_limit
    if Cryptid then
        G.GAME.modifiers.cry_highlight_limit = self.config.highlighted_limit
        
    end

    if delta ~= 0 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled) and G.GAME.alphabet_rate == 0 then
        G.GAME.alphabet_rate = 1
    end
    if not (G.GAME.akyrs_character_stickers_enabled or G.GAME.akyrs_wording_enabled) and G.GAME.alphabet_rate > 0 then
        G.GAME.alphabet_rate = 0
    end
    if G.GAME.blind and G.GAME.blind.debuff.requirement_scale and not G.GAME.blind.disabled then
        if G.GAME.current_round.hands_left >= 1 and G.GAME.current_round.hands_played > 0 then
            G.GAME.blind.chips = G.GAME.chips * G.GAME.blind.debuff.requirement_scale
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
    if G.STATE == G.STATES.HAND_PLAYED then
        G.GAME.current_round.akyrs_executed_debuff = false
        for suitkey, suit in pairs(SMODS.Suits) do
            for _, card in ipairs(G.play.cards) do
                if(suitkey ~= nil and card:is_suit(suitkey) and G.GAME.current_round.aiko_played_suits) then
                    G.GAME.current_round.aiko_played_suits[suitkey] = true
                    goto akyrs_suit_check_continue
                end
            end
            ::akyrs_suit_check_continue::
        end

        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips

            for i = 1, #G.jokers.cards do
                if (G.jokers.cards[i].aiko_trigger_external) and not G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:aiko_trigger_external()
                    --print("CHANGED !!!")
                end
            end
        end
        if G.GAME.blind.debuff.akyrs_perma_selection then
            for i, k in ipairs(G.play.cards) do
                k.ability.akyrs_forced_selection = true
            end
        end
        if G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
            if G.GAME.current_round and G.GAME.current_round.current_hand then
                G.GAME.current_round.current_hand.chips = 0
                G.GAME.current_round.current_hand.mult = 0
            end
            
            update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0})
        end
    end
    if G.STATE == G.STATES.SELECTING_HAND then
        if not G.GAME.blind.debuff.initial_action_act_set and not G.GAME.blind.disabled then
            G.GAME.blind.debuff.initial_action_acted = false
            G.GAME.blind.debuff.initial_action_act_set = true
        end
        if not G.GAME.current_round.akyrs_executed_debuff and AKYRS.all_card_areas and G.GAME.blind and not G.GAME.blind.disabled  then
            if G.GAME.blind.debuff.akyrs_suit_debuff_hand then
                if AKYRS.all_card_areas then 
                    for suit, _ in pairs(G.GAME.current_round.aiko_played_suits) do
                        for _,area in ipairs(AKYRS.all_card_areas) do
                            if (area and area.cards) then
                                for j,c in ipairs(area.cards) do
                                    if c:is_suit(suit) then
                                        c:set_debuff(true)
                                    end
                                end
                            end
                
                        end
                        
                    end
                end
            end
            if G.GAME.blind.debuff.akyrs_all_seals_perma_debuff and not G.GAME.blind.disabled then
                if AKYRS.all_card_areas then 
                    for _,area in ipairs(AKYRS.all_card_areas) do
                        if (area and area.cards) then
                            for j,c in ipairs(area.cards) do
                                if c.seal and not c.ability.akyrs_undebuffable then
                                    c.ability.akyrs_perma_debuff = true
                                end
                            end
                        end
            
                    end
                        
                end
            end
            G.GAME.current_round.akyrs_executed_debuff = true
        end

        if  G.GAME.blind.debuff.akyrs_pick_cards and not G.GAME.blind.disabled then
            if AKYRS.picker_initial_action and not G.GAME.blind.debuff.initial_action_acted then
                AKYRS.picker_initial_action()
                G.GAME.blind.debuff.initial_action_acted = true
            end
        end
    end
    
    -- permanent debuff shenanigans
    if AKYRS.all_card_areas then 
        for i,k in ipairs(AKYRS.all_card_areas) do
            if (k and k.cards) then
                for j,l in ipairs(k.cards) do
                    if l.ability.akyrs_undebuffable then
                        l.ability.akyrs_perma_debuff = false
                        l.ability.perma_debuff = false
                        l:set_debuff(false)
                    end
                    if l.ability.akyrs_perma_debuff and not l.ability.akyrs_undebuffable then
                        l:set_debuff(true)
                    end
                    if l.ability.akyrs_forced_selection and not l.ability.akyrs_undebuffable then
                        local isAlreadyInHighlighted = false
                        for gg,gk in ipairs(l.area.highlighted) do
                            if gk == l then
                                isAlreadyInHighlighted = true
                                break
                            end
                        end
                        if not isAlreadyInHighlighted and #l.area.highlighted < l.area.config.highlighted_limit then
                            l:highlight(true)
                            l.area:add_to_highlighted(l)
                            l.ability.forced_selection = true
                        end
                    end
                end
            end
        end
    end


    return s
end

function customDeckHooks(self, card_protos)
    if self.GAME.starting_params.akyrs_start_with_no_cards then
        return {}
    end
    return card_protos
end

local startRunHook = Game.start_run
function Game:start_run(args)
    local ret = startRunHook(self, args)
    AKYRS.reset_math_parser({
        vars = G.GAME.akyrs_parser_var or AKYRS.math_default_const,
    })
    if not self.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
        --print("CHECK SUCCESS")
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
    if self.GAME.modifiers.akyrs_no_tarot_except_twof then
        for k, v in ipairs(G.P_CENTER_POOLS.Tarot) do
            if v.key ~= "c_wheel_of_fortune" then
                G.GAME.banned_keys[v.key] = true
            end
        end
    end
    recalculateHUDUI()
    recalculateBlindUI()
    if G.GAME.akyrs_any_drag then
        AKYRS.simple_event_add(
            function()
                G.jokers.states.collide.can = true
                G.consumeables.states.collide.can = true
                G.hand.states.collide.can = true
                G.deck.states.collide.can = true
                return true
            end
        )
    end
    return ret
end

local cardSetCostHook = Card.set_cost
function Card:set_cost()
    local ret = cardSetCostHook(self)
    if self.ability.akyrs_self_destructs then
        self.sell_cost = -1
    end
    return ret
end

local discardAbilityHook = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    local ret = discardAbilityHook(e)
    if #G.hand.highlighted > 0 and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end
    return ret
end

local cardSellHook = Card.sell_card

function Card:sell_card()
    self.akyrs_is_being_sold = true
    local c = cardSellHook(self)
    return c
end
AKYRS.area_to_check_remove = function(area)
    return area == G.play or area == G.hand or area == G.deck or area == G.jokers or area == G.consumeables or nil
end
local cardRemoveHook = Card.remove
function Card:remove()
    local area = self.area or self.akyrs_lastcardarea

    if not G.AKYRS_RUN_BEING_DELETED and not self.akyrs_is_being_sold and not (area and (area.config.collection or area.config.temporary or area.config.view_deck)) and area and AKYRS.area_to_check_remove(area) then
        pcall(SMODS.calculate_context,{ akyrs_card_remove = true, card_getting_removed = self })
    end

    local l = cardRemoveHook(self)
    return l
end

local endRoundHook = end_round
function end_round()
    if (G.GAME.current_round.advanced_blind and not G.GAME.aiko_puzzle_win) and (G.GAME.current_round.hands_left > 0)
    then
        G.STATE_COMPLETE = true
        G.STATE = G.STATES.SELECTING_HAND
    else
        local ret = endRoundHook()
        for _, cardarea in ipairs(AKYRS.all_card_areas) do
            if cardarea and cardarea.cards then
                for i, card in ipairs(cardarea.cards) do

                    if card.ability.akyrs_self_destructs then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card:start_dissolve({ G.C.RED }, nil, 1.6)
                                return true
                            end,
                            delay = 0.5,
                        }), 'base')
                    end
                    if SMODS.get_enhancements(card)["m_akyrs_ash_card"] or card.config.center_key == "j_akyrs_ash_joker" then
                        local odder = pseudorandom("ashed") < G.GAME.probabilities.normal / card.ability.extras.odds
                        if odder then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:start_dissolve({ G.C.BLACK }, nil, 1.6)
                                    return true
                                end,
                                delay = 0.5,
                            }), 'base')
                        end

                    end
                    if card.edition and card.edition.key == "e_akyrs_burnt" then
                        local odder = pseudorandom("burnt") < G.GAME.probabilities.normal / card.edition.extras.odds
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
                                    card:start_dissolve({ G.C.BLACK }, nil, 1.6)
                                    
                                    return true
                                end,
                                delay = 0.5,
                            }), 'base')
                        end
                    end
                end
            end
        end
        return ret
    end
end


local updateSelectHandHook = Game.update_selecting_hand
function Game:update_selecting_hand(dt)
    local ret = updateSelectHandHook(self, dt)
    
    if G.GAME.aiko_current_word ~= nil then
        G.GAME.aiko_current_word = nil
    end


    if not self.aiko_wordle and AKYRS.isBlindKeyAThing() == "bl_akyrs_the_thought" then
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end

    return ret
end

local updateHandPlayedHook = Game.update_hand_played
function Game:update_hand_played(dt)
    local ret = updateHandPlayedHook(self, dt)
    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    if not self.aiko_wordle then
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
    return ret
end

local updateNewRoundHook = Game.update_new_round
function Game:update_new_round(dt)
    local ret = updateNewRoundHook(self, dt)
    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    
    return ret
end


local deleteRunHook = Game.delete_run
function Game:delete_run()
    self.AKYRS_RUN_BEING_DELETED = true
    local ret = deleteRunHook(self)

    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    self.AKYRS_RUN_BEING_DELETED = nil
    return ret
end


function Card:a_cool_fucking_spin(time, radian)
    Moveable.a_cool_fucking_spin(self, time, radian)
end

function Moveable:a_cool_fucking_spin(time, radian)
    if G.SETTINGS.reduced_motion then return end
    local radian = radian or math.pi * 2

    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        type = 'lerp',
        ref_table = self.VT,
        ref_value = 'r',
        ease_to = radian,
        delay = time,
        func = (function(t)
            self.VT.r = t
            self.T.r = t
            return t
        end)
    }))
end

local add2highlightHook = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    local ret = add2highlightHook(self,card,silent)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end

local removeFhighlightHook = CardArea.remove_from_highlighted
function CardArea:remove_from_highlighted(card, force)
    local ret = removeFhighlightHook(self,card, force)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end
local unhighlightallHook = CardArea.unhighlight_all
function CardArea:unhighlight_all()
    local ret = unhighlightallHook(self)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end

local dcfhHook = G.FUNCS.discard_cards_from_highlighted 
G.FUNCS.discard_cards_from_highlighted = function (e,hook)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
        G.GAME.blind.debuff.primed = false
    end
    local r = dcfhHook(e,hook)
    return r
end

local loadBlind = Blind.load
function Blind:load(blindTable)
    local r = loadBlind(self,blindTable)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
        self.debuff.lock = true
        G.E_MANAGER:add_event(Event{
            trigger = "before",
            delay = 0,
            func = function ()
                self.debuff.initial_action_act_set = false
                
                G.E_MANAGER:add_event(Event{
                    func = function ()
                        self.debuff.primed = true
                        self.debuff.acted = false
                        G.E_MANAGER:add_event(Event{
                            trigger = "before",
                            func = function ()
                                self.debuff.lock = false
                                return true
                            end
                })
                        return true
                    end
                })
                return true
            end
        })
    end
    return r
end


local eval_hook = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function()
    if G.GAME.aikoyori_evaluation_value then
        attention_text({
            scale =  1.5, text = ""..G.GAME.aikoyori_evaluation_value, hold = 15, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
    end
    if G.GAME.aikoyori_variable_to_set and G.GAME.aikoyori_value_to_set_to_variable and not G.GAME.aikoyori_evaluation_value then
        attention_text({
            scale =  1.5, text = G.GAME.aikoyori_variable_to_set.." = "..tostring(G.GAME.aikoyori_value_to_set_to_variable), hold = 15, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
    end
    -- print(#G.play.cards)
    local word_split = nil
    if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled then
        
        local aiko_current_word_split = {}
        word_split = {}
        local cards = {}
        for i, k in ipairs(G.play.cards) do
            table.insert(cards,k)
        end
        table.sort(cards,AKYRS.hand_sort_function)
        for i, j in ipairs(cards) do
            if j.ability.aikoyori_letters_stickers then
                table.insert(aiko_current_word_split,string.lower(j:get_letter_with_pretend()))
                word_split[string.upper(j:get_letter_with_pretend())] = true
            end
        end
        local wordData = {}
        if (AKYRS.WORD_CHECKED[aiko_current_word_split]) then
            --print("WORD "..word_hand_str.." IS IN MEMORY AND THUS SHOULD USE THAT")
            wordData = AKYRS.WORD_CHECKED[aiko_current_word_split]
        else
            --print("WORD "..word_hand_str.." IS NOT IN MEMORY ... CHECKING")
            wordData = AKYRS.check_word(aiko_current_word_split)
            AKYRS.WORD_CHECKED[aiko_current_word_split] = wordData
        end
        --print(wordData)
        if wordData.valid then
            G.GAME.aiko_current_word = wordData.word
            G.GAME.aiko_current_word_table = aiko_current_word_split
            G.GAME.aiko_words_played[wordData.word] = true
            G.GAME.current_round.aiko_round_played_words[wordData.word] = true
            if AKYRS.config.wildcard_behaviour == 4 then -- set letters in hand  on mode 4 lol !!!
                for g,card in ipairs(G.play) do
                    if card.ability.aikoyori_letters_stickers == "#" and aiko_current_word_split and aiko_current_word_split[g] then
                        card.ability.aikoyori_pretend_letter = aiko_current_word_split[g]
                    end
                end
            end
        end
    end
    if G.GAME.aiko_current_word then
        attention_text({
            scale =  1.5, text = string.upper(G.GAME.aiko_current_word), hold = 15, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
    end
    if(G.GAME.aiko_current_word) then
            
        local word_table = {}
        for char in G.GAME.aiko_current_word:gmatch(".") do
            table.insert(word_table, char)
        end
        for k,v in ipairs(G.hand.cards) do
            if v.highlighted then
                local _card = copy_card(v, nil, nil, G.playing_card)
                _card.ability.akyrs_self_destructs = true
                _card.ability.aikoyori_letters_stickers = v.ability.aikoyori_letters_stickers
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.deck:emplace(_card)
                _card:add_to_deck()
            end

        end
        if G.GAME.word_todo then
            local todo_table = {}
            for char in G.GAME.word_todo:gmatch(".") do
                table.insert(todo_table, char)
            end

            local result_string = ""
            local result_string_arr = {}
            for i, char in ipairs(todo_table) do
                if word_table[i] and string.upper(word_table[i]) == string.upper(char) then
                    result_string = result_string .. "-"
                    table.insert(result_string_arr,"-")
                else
                    result_string = result_string .. char
                    table.insert(result_string_arr,char)
                end
            end
            local word_for_display = {
    
            }
            local letter_count = {
    
            }
            for _, char in ipairs(result_string_arr) do
                local lower_char = string.lower(char)
                letter_count[lower_char] = (letter_count[lower_char] or 0) + 1
            end
    
            for i, char in ipairs(word_table) do
                if todo_table[i] and string.upper(char) == string.upper(todo_table[i]) then
                    G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] = true
                    table.insert(word_for_display,{string.lower(char), 1})
                elseif letter_count[string.lower(char)] and letter_count[string.lower(char)] > 0 and not G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] then
                    G.GAME.current_round.aiko_round_misaligned_letter[string.lower(char)] = true
                    
                    table.insert(word_for_display,{string.lower(char), letter_count[string.lower(char)] > 0 and 2 or 3})
                    letter_count[string.lower(char)] = letter_count[string.lower(char)] - 1
                else
                    if not G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] and not G.GAME.current_round.aiko_round_misaligned_letter[string.lower(char)] then
                        G.GAME.current_round.aiko_round_incorrect_letter[string.lower(char)] = true
                    end
                    table.insert(word_for_display,{string.lower(char), 3})
                end
            end
            
    
            table.insert(G.GAME.current_round.aiko_round_played_words,word_for_display)    
            if string.upper(G.GAME.word_todo) == string.upper(G.GAME.aiko_current_word) then
                --print("WIN!")
                G.GAME.aiko_puzzle_win = true
            end
        end
    end
    local ret = eval_hook()
    
    if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and word_split then
        EMPTY(G.GAME.akyrs_last_played_letters)
        G.GAME.akyrs_last_played_letters = word_split
    end
    if G.GAME.aikoyori_variable_to_set and G.GAME.aikoyori_value_to_set_to_variable then
        AKYRS.parser_set_var(G.GAME.aikoyori_variable_to_set , G.GAME.aikoyori_value_to_set_to_variable)
    end
    if G.GAME.aikoyori_evaluation_value then
        if G.GAME.aikoyori_evaluation_replace then
            
            ease_chips(G.GAME.aikoyori_evaluation_value)
        else
            ease_chips(G.GAME.chips + G.GAME.aikoyori_evaluation_value)
        end
    end
    G.GAME.aikoyori_evaluation_value = nil
    G.GAME.aikoyori_variable_to_set = nil
    G.GAME.aikoyori_value_to_set_to_variable = nil
    G.GAME.aiko_current_word = nil
    
    G.GAME.aiko_current_word_table = {}
    return ret
end


local cardAreaInitHook = CardArea.init
function CardArea:init(X, Y, W, H, config)
    local r = cardAreaInitHook(self,X,Y,W,H,config)
    if not config.temporary and not config.collection then
        if not AKYRS.all_card_areas then
            AKYRS.all_card_areas = {}
        end
        table.insert(AKYRS.all_card_areas,self)
    end
    return r
end

local cardAreaRemoveHook = CardArea.remove
function CardArea:remove()
    local r = cardAreaRemoveHook(self)
    if not AKYRS.all_card_areas then return end
    for k, v in pairs(AKYRS.all_card_areas) do
        if v == self then
            table.remove(AKYRS.all_card_areas, k)
        end
    end
    return r
end

local setCardAbilityHook = Card.set_ability

function Card:set_ability(c,i,d)
    local r = setCardAbilityHook(self,c,i,d)
    
    if(i) then
        self.akyrs_old_ability = AKYRS.deep_copy(self.ability)
    end
    return r
end


local cardBaseHooker = Card.set_base
function Card:set_base(card, initial)
    local ret = cardBaseHooker(self, card, initial)
    self.aiko_draw_delay = math.random() * 1.75 + 0.25
    self.akyrs_impostor_card = false
    if self.base.name and not self.ability.aikoyori_letters_stickers then
        self:set_letters_random()
        self.ability.forced_letter_render = false
    end
    return ret
end
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)
    
    self:akyrs_mod_card_value_init()
    self.akyrs_upgrade_sliced = false
    
    return ret
end

local cardAreaEmplaceFunction = CardArea.emplace
function CardArea:emplace(c,l,fl)
    if c and type(c) == "table" then
        c.akyrs_lastcardarea = self
    end
    return cardAreaEmplaceFunction(self,c,l,fl)
end

local setCAHook = Card.set_card_area
function Card:set_card_area(area)
    local x = setCAHook(self,area)
    if area and type(area) == "table" then
        self.akyrs_lastcardarea = area
    end
    return x
end

function Card:akyrs_mod_card_value_init()
    if G.GAME.modifiers.akyrs_misprint then
        -- Update cards.lua scuffed_misprint if you update this
        local misprint_base = 5

        local x = AKYRS.deep_copy(self.ability)
        AKYRS.mod_card_values_misprint(x,{base = misprint_base, scale = 1, can_negate = false})
        x.x_chips = self.ability.x_chips == 1 and 1 or self.ability.x_chips
        x.h_x_chips = self.ability.h_x_chips == 1 and 1 or self.ability.h_x_chips
        x.x_mult = self.ability.x_mult == 1 and 1 or self.ability.x_mult
        x.h_x_mult = self.ability.h_x_mult == 1 and 1 or self.ability.h_x_mult
        self.ability = x
    end
    if #SMODS.find_card("j_akyrs_chicken_jockey") > 0 and self.config.center_key == "j_popcorn" then
        local jj = SMODS.find_card("j_akyrs_chicken_jockey")
        local val = jj[#jj].ability.extras.decrease_popcorn
        self.ability.extra = val
    end
  
end

local cardSave = Card.save
function Card:save()
    local c = cardSave(self)
    c.is_null = self.is_null
    c.highlighted = self.highlighted
    c.akyrs_old_ability = self.akyrs_old_ability
    c.akyrs_upgrade_sliced = self.akyrs_upgrade_sliced
    c.akyrs_impostor_card = self.akyrs_impostor_card
    return c
end

local cardLoad = Card.load
function Card:load(cardTable, other_card)
    local c = cardLoad(self, cardTable, other_card)
    self.is_null = cardTable.is_null
    self.highlighted = cardTable.highlighted
    self.akyrs_old_ability = cardTable.akyrs_old_ability
    self.akyrs_upgrade_sliced = cardTable.akyrs_upgrade_sliced
    self.akyrs_impostor_card = cardTable.akyrs_impostor_card
    return c
end

local getNominalHook = Card.get_nominal
function Card:get_nominal(mod)
    if self.is_null and self.ability.aikoyori_letters_stickers then
        return -10 - string.byte(self.ability.aikoyori_letters_stickers)
    end
    local ret = getNominalHook(self, mod)
    return ret
end


local cardAreaAlignHook = CardArea.align_cards
function CardArea:align_cards()
    local r = cardAreaAlignHook(self)
    if self.config.type == 'akyrs_credits' and self.cards then

        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                --card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
                local max_cards = math.max(#self.cards, self.config.temp_limit)
                card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)

                local highlight_height = G.HIGHLIGHT_H
                if not card.highlighted then highlight_height = 0 end
                card.T.y = self.T.y - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1)*0.04*math.sin(2.*G.TIMERS.REAL + card.T.y*1.471 + card.T.x*1.471) -- + math.abs(1.3*(-#self.cards/2 + k-0.5)/(#self.cards))^2
                card.T.x = card.T.x + card.shadow_parrallax.x/30
            end
        end
        --table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end
    if self.config.type == 'akyrs_solitaire_tableau' then
        for k, card in ipairs(self.cards) do
            if not card.states.drag.is and not card.is_being_pulled then 
                --card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
                local face_down_cards = {}
                local face_up_cards = {}

                for _, card in ipairs(self.cards) do
                    if card.area == self then
                        if card.facing == 'back' then
                            table.insert(face_down_cards, card)
                        else
                            table.insert(face_up_cards, card)
                        end
                    end

                end

                table.sort(face_up_cards, function(a, b)
                    return a.base.id > b.base.id
                end)

                for _, card in ipairs(face_up_cards) do
                    table.insert(face_down_cards, card)
                end

                self.cards = face_down_cards
                card.T.y = self.T.y + 0.5 * (k-1)
                card.T.x = self.T.x
            end
            
            if not card.is_being_pulled and not card.akyrs_card_held then
                card.states.collide.can = true
                card.states.drag.can = true
                card.states.click.can = true
            else
                
            end

            if (AKYRS.SOL.current_state ~= AKYRS.SOL.states.START_DRAW and AKYRS.SOL.current_state ~= AKYRS.SOL.states.INACTIVE) then
                if k == #self.cards then
                    card.following_cards = nil
                    card.card_held = nil
                    if card.facing == 'back' then
                        card:flip()
                        card.sprite_facing = card.facing
                    end
                    card.ability.akyrs_solitaire_revealed = true
                else
                    if not card.ability.akyrs_solitaire_revealed then
                            
                        card.states.drag.can = false
                        card.states.click.can = false
                        if card.sprite_facing == 'front' then
                            card.sprite_facing = 'back'
                        end
                        if card.facing == 'front' then
                            card.facing = 'back'
                        end
                    end
                end 
            else
                card.states.collide.can = false
                card.states.drag.can = false
                card.states.click.can = false
            end
            if AKYRS.SOL.current_state == AKYRS.SOL.states.START_DRAW then
                card.facing = 'back'
                card.sprite_facing = 'back'
            end

        end
        --table.sort(self.cards, function (a, b) return a.T.y + a.T.y/2 < b.T.y + b.T.y/2 end)
    end
    if self.config.type == 'akyrs_solitaire_foundation' then

        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                --card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)

                card.T.y = self.T.y
                card.T.x = self.T.x
            end
        end
        --table.sort(self.cards, function (a, b) return a.T.y + a.T.y/2 < b.T.y + b.T.y/2 end)
    end
    if self.config.type == 'akyrs_solitaire_waste' then

        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                local xm = math.max(0, (k - #self.cards) + 2 )
                card.T.y = self.T.y
                card.T.x = self.T.x + (xm)*0.5
            end
            if k == #self.cards then
                card.states.drag.can = true
                card.states.click.can = true
            else
                card.states.drag.can = false
                card.states.click.can = false
            end
        end
        --table.sort(self.cards, function (a, b) return a.T.y + a.T.y/2 < b.T.y + b.T.y/2 end)
    end
    if self.config.type == 'akyrs_cards_temporary_dragged' then

        for k, card in ipairs(self.cards) do
            if not card.states.drag.is and not card.is_being_pulled then 
                --card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)

                card.T.y = self.T.y + 0.5 * (k)
                card.T.x = self.T.x
            end

        end
        --table.sort(self.cards, function (a, b) return a.T.y + a.T.y/2 < b.T.y + b.T.y/2 end)
    end
    return r
end
local cardAreaDrawHook = CardArea.draw
function CardArea:draw()
    local r = cardAreaDrawHook(self)

    self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
    for k, v in ipairs(self.ARGS.draw_layers) do
        if self.config.type == 'akyrs_credits' or self.config.type == 'akyrs_solitaire_tableau' or self.config.type == 'akyrs_solitaire_foundation' or self.config.type == 'akyrs_solitaire_waste' or self.config.type == 'akyrs_cards_temporary_dragged' and self.cards then 
            for i = 1, #self.cards do 
                if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                    if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                end
            end
        end
    end
    return r
end


local applyToRunBackHook = Back.apply_to_run

function Back:apply_to_run()
    if self.effect.config.akyrs_starting_letters then
        G.GAME.starting_params.akyrs_starting_letters = self.effect.config.akyrs_starting_letters
    end
    if self.effect.config.akyrs_letters_no_uppercase then
        G.GAME.starting_params.akyrs_letters_no_uppercase = self.effect.config.akyrs_letters_no_uppercase
    end
    local c = applyToRunBackHook(self)


    if self.effect.config.selection then
        G.GAME.aiko_cards_playable = math.max(G.GAME.aiko_cards_playable, self.effect.config.selection)
        if Cryptid and G.GAME.modifiers.cry_highlight_limit then
            G.GAME.modifiers.cry_highlight_limit = math.max(G.GAME.modifiers.cry_highlight_limit, self.effect.config.selection)
        end
    end
    if self.effect.config.akyrs_start_with_no_cards then
        G.GAME.starting_params.akyrs_start_with_no_cards = true
    end
    if self.effect.config.akyrs_character_stickers_enabled then
        G.GAME.akyrs_character_stickers_enabled = true
    end
    if self.effect.config.akyrs_wording_enabled then
        G.GAME.akyrs_wording_enabled = true
    end

    if self.effect.config.akyrs_mathematics_enabled then
        G.GAME.akyrs_mathematics_enabled = true
    end
    if self.effect.config.akyrs_random_scale then
        G.GAME.akyrs_random_scale = self.effect.config.akyrs_random_scale
    end
    if self.effect.config.akyrs_letters_mult_enabled then
        G.GAME.akyrs_letters_mult_enabled = true
    end
    if self.effect.config.akyrs_letters_xmult_enabled then
        G.GAME.akyrs_letters_xmult_enabled = true
    end
    if self.effect.config.akyrs_power_of_ten_scaling then
        G.GAME.akyrs_power_of_ten_scaling = true
    end
    if self.effect.config.akyrs_no_skips then
        G.GAME.akyrs_no_skips = self.effect.config.akyrs_no_skips
    end

    if self.effect.config.akyrs_any_drag then
        G.GAME.akyrs_any_drag = self.effect.config.akyrs_any_drag
        AKYRS.simple_event_add(
            function()
                G.jokers.states.collide.can = true
                G.consumeables.states.collide.can = true
                G.hand.states.collide.can = true
                G.deck.states.collide.can = true
                return true
            end, 0.5
        )
    end
    if G.GAME.starting_params.akyrs_any_drag then
        G.GAME.akyrs_any_drag = G.GAME.starting_params.akyrs_any_drag
        AKYRS.simple_event_add(
            function()
                G.jokers.states.collide.can = true
                G.consumeables.states.collide.can = true
                G.hand.states.collide.can = true
                G.deck.states.collide.can = true
                return true
            end, 0.5
        )
    end

    if self.effect.config.akyrs_math_threshold then
        G.GAME.akyrs_math_threshold = self.effect.config.akyrs_math_threshold
    else
        G.GAME.akyrs_math_threshold = 10
    end
    if self.effect.config.akyrs_hide_normal_hands then
        for k, v in pairs(G.GAME.hands) do
            if (k~= "High Card" and not self.effect.config.akyrs_hide_high_card) or (self.effect.config.akyrs_hand_to_not_hide and not self.effect.config.akyrs_hand_to_not_hide[k]) then
                v.visible = false
            else
                v.visible = true
            end
        end
    end
    if G.GAME.starting_params.akyrs_starting_letters then
        
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_cards = {}
                
                local deckloop = G.GAME.starting_params.deck_size_letter or 1
                local usedLetter = {}
                for loops = 1, deckloop do
                    for i, letter in pairs(G.GAME.starting_params.akyrs_starting_letters) do
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
    return c
end

local function compareFirstElement(a,b)
    return a[1] < b[1]
end

local shufflingEverydayHook = CardArea.shuffle
function CardArea:shuffle(_seed)
    local r = shufflingEverydayHook(self, _seed)
    if self == G.deck then
        --print("everyday shuffling")
        local priorityqueue = {}
        local cardsPrioritised = {}
        local cardsOther = {}
        for d, joker in ipairs(G.jokers.cards) do
            if (not joker.debuff) then
                if (joker.ability.akyrs_priority_draw_suit) then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "suit",joker.ability.akyrs_priority_draw_suit}
                    --print(joker.ability.akyrs_priority_draw_suit)
                end
                if joker.ability.akyrs_priority_draw_rank then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "rank",joker.ability.akyrs_priority_draw_rank}
                    --print(joker.ability.akyrs_priority_draw_rank)
                end
                if joker.ability.akyrs_priority_draw_conditions == "Face Cards" then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "face",true}
                    --print(joker.ability.akyrs_priority_draw_conditions)
                end
            end
        end
        table.sort(priorityqueue,compareFirstElement)
        local cards = self.cards
        for i, k in ipairs(cards) do
            local priority = 0
            
            for j, l in ipairs(priorityqueue) do
                if 
                (l[2] == "suit" and k:is_suit(l[3])) or
                (l[2] == "rank" and k:get_id() == SMODS.Ranks[l[3]].id and not SMODS.has_no_suit(k)) or
                (l[2] == "face" and k:is_face() == l[3])
                 then
                    --print(k.base.name, l[1], l[2], l[3])
                    priority = priority + l[1]
                end
            end

            if priority > 0 then
                cardsPrioritised[#cardsPrioritised+1] = {priority,k}
            else
                cardsOther[#cardsOther+1] = k
            end
        end
        table.sort(cardsPrioritised,compareFirstElement)
        for _, card in ipairs(cardsPrioritised) do
            table.insert(cardsOther, card[2])
        end
        self.cards = cardsOther
        self:set_ranks()
    end
    return r
end


local evalRnd = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
    if G.GAME.modifiers.akyrs_half_debuff then
        local slf = {}
        for x, ca in ipairs(AKYRS.all_card_areas) do
            if ca and ca.cards and ca ~= G.vouchers then
                for i, k in ipairs(ca.cards) do
                    if not k.akyrs_self_destructs then
                        table.insert(slf, k)
                    end
                end
            end
        end
        -- Randomly sort slf
        for i = #slf, 2, -1 do
            local j = math.random(i)
            slf[i], slf[j] = slf[j], slf[i]
        end
        -- Only apply to half the cards
        local half_count = math.floor(#slf / 2)
        for i = 1, half_count do
            local k = slf[i]
            if not k.debuff then
                k.ability.akyrs_perma_debuff = true
                k:juice_up(0.9, 0.5)
            end
        end
    end
    local ret = evalRnd()
    if G.GAME.modifiers.akyrs_half_self_destruct then
        local slf = {}
        for x, ca in ipairs(AKYRS.all_card_areas) do
            if ca and ca.cards and ca ~= G.vouchers then
                for i, k in ipairs(ca.cards) do
                    if not k.akyrs_self_destructs then
                        table.insert(slf, k)
                    end
                end
            end
        end
        -- Randomly sort slf
        for i = #slf, 2, -1 do
            local j = math.random(i)
            slf[i], slf[j] = slf[j], slf[i]
        end
        -- Only apply to half the cards
        local half_count = math.floor(#slf / 2)
        for i = 1, half_count do
            local k = slf[i]
            if not k.debuff then
                k.ability.akyrs_self_destructs = true
                k:juice_up(0.9, 0.5)
            end
        end
    end
    return ret
end


G.FUNCS.akyrs_difficult_blind_alert = function(e)
    if not e.children.alert then
        e.children.alert = UIBox{
          definition = create_UIBox_card_alert({no_bg = true,text = localize('k_akyrs_difficult'), scale = 0.3}),
          config = {
            instance_type = 'ALERT',
            align="tri",
            offset = {x = 0.3, y = -0.18},
            major = e, parent = e}
        }
        e.children.alert.states.collide.can = false
    end
end

G.FUNCS.akyrs_do_nothing = function(e)
end

local XmainMenuHook = Game.main_menu
function Game:main_menu(ctx)
    local r = XmainMenuHook(self,ctx)
    if self.title_top then
        local tg = self.title_top
        local card = Card(tg.T.x,tg.T.y,G.CARD_W,G.CARD_H,nil,G.P_CENTERS['j_akyrs_aikoyori'])
        card.T.w = card.T.w * 1.4
        card.T.h = card.T.h * 1.4
        
        G.title_top.T.w = G.title_top.T.w * 1.7675
        G.title_top.T.x = G.title_top.T.x - 0.8
        card:set_sprites(card.config.center)
        card.no_ui = true
        card.states.visible = false
        self.title_top:emplace(card)
        self.title_top:align_cards()
        G.E_MANAGER:add_event(
            Event{
                delay = 0.5,
                func = function ()
                    if ctx == "splash" then
                        card.states.visible = true
                        card:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
                    else
                        card.states.visible = true
                        card:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
                    end
                    return true
                end
            }
        )
    end


    return r
end


local startMaterializeHook = Card.start_materialize
function Card:start_materialize(cols, slnt, timefac)
    if self.ability.set == "Alphabet" then
        if AKYRS.non_letter_symbols_reverse[self.ability.extra.letter] then
            cols = {HEX("3b82f6")}
        elseif self.ability.extra.letter == "#" then
            cols = {HEX("ff2d8d")}
        elseif tonumber(self.ability.extra.letter) then
            cols = {HEX("0ca400")}
        elseif self.ability.extra.letter:match("[AEIOUaeiou]") then
            cols = {HEX("2d99ff")}
        elseif self.ability.extra.letter:match("[Yy]") then
            cols = {HEX("f59e0b")} 
        else
            cols = {HEX("52525b")}
        end
    end
    local h = startMaterializeHook(self, cols, slnt, timefac)
    return h
end

local blindDisable = Blind.disable
function Blind:disable()
    if self.debuff.akyrs_cannot_be_disabled then
        play_sound("akyrs_loud_incorrect_buzzer",1,0.1)
        attention_text({
            text = localize("k_nope_ex"),
            scale = 1, 
            hold = 1.0,
            rotate = math.pi / 8,
            backdrop_colour = G.GAME.blind.boss_colour,
            align = "cm",
            major = G.GAME.blind,
            offset = {x = 0, y = 0.1}
        })
        return
    end
    return blindDisable(self)
end

AKYRS.can_boss_be_rerolled = function (boss_key)
    if G.P_BLINDS[boss_key] and G.P_BLINDS[boss_key].debuff.akyrs_cannot_be_rerolled then return false end
    return true
end

local rerollBossHook = G.FUNCS.reroll_boss 
G.FUNCS.reroll_boss = function(e)
    
    if not AKYRS.can_boss_be_rerolled(G.GAME.round_resets.blind_choices.Boss) then
        local uib = G.blind_select_opts.boss:get_UIE_by_ID("blind_desc")
        play_sound("akyrs_loud_incorrect_buzzer",1,0.1)
        attention_text({
            text = localize("k_nope_ex"),
            scale = 1, 
            hold = 1.0,
            rotate = math.pi / 8,
            backdrop_colour = G.GAME.blind.boss_colour,
            align = "cm",
            major =  uib and uib.children and uib.children[1] and uib.children[1].children[1].children[1] or nil,
            offset = {x = 0, y = 0.1}
        })

    else
        local x = rerollBossHook(e)
        return x
    end
end

local reroll_button_hook = G.FUNCS.reroll_boss_button
G.FUNCS.reroll_boss_button = function(e)
    if not AKYRS.can_boss_be_rerolled(G.GAME.round_resets.blind_choices.Boss) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        e.children[1].children[1].config.shadow = false
        if e.children[2] then e.children[2].children[1].config.shadow = false end 
    else
        local x = reroll_button_hook(e)
        return x
    end

end

local getNewBossHook = get_new_boss
get_new_boss = function()
    if not AKYRS.can_boss_be_rerolled(G.GAME.round_resets.blind_choices.Boss) and not G.GAME.akyrs_blind_just_defeated then
        -- TODO: FIX THIS
        return G.GAME.round_resets.blind_choices.Boss
    else
        G.GAME.akyrs_blind_just_defeated = nil
        local x = getNewBossHook()
        return x
    end

end

local blindDefeatHook = Blind.defeat
function Blind:defeat(silent)
    local x = blindDefeatHook(self,silent)
    if self.boss then
        G.GAME.akyrs_blind_just_defeated = true
    end
    return x
end