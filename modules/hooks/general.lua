-- This file contains general hooks that has a bunch of things in them

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_cards_playable = 5
    ret.starting_params.akyrs_start_with_no_cards = false
    ret.starting_params.deck_size_letter = 1
    ret.akyrs_character_stickers_enabled = false
    ret.akyrs_wording_enabled = false
    ret.akyrs_has_not_spelled_a_single_word = false
    ret.akyrs_temptation_resisted = false
    ret.akyrs_mathematics_enabled = false
    ret.akyrs_letters_mult_enabled = false
    ret.akyrs_letters_xmult_enabled = false
    ret.akyrs_parser_var = AKYRS.math_default_const
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    ret.akyrs_any_drag = false
    ret.akyrs_ultimate_freedom = false
    ret.aiko_current_wordaiko_current_word = nil
    ret.aiko_current_word_table = {}
    ret.aiko_words_played = {}
    ret.letters_to_give = {}
    ret.akyrs_ranks_played = {}
    ret.akyrs_suits_played = {}
    ret.akyrs_pure_hand_modifier = { multiplier = 2, power = 1, level = 1, played = 0 }
    ret.akyrs_pure_unlocked = false
    ret.akyrs_generated_but_not_redeemed_vouchers_check = {}
    ret.akyrs_list_of_generated_but_not_redeemed_vouchers = {}
    ret.aiko_letters_consumable_rate = 0
    ret.current_round.akyrs_scoring_set = nil
    -- table of key { n_add = 0, d_add = 1, n_mult = 1, d_mult = 1 } // tho only one of these should exist
    ret.akyrs_prob_mod = {

    }
    AKYRS.replenishLetters()
    ret.current_round.akyrs_picked_poker_hands = "High Card"
    ret.current_round.akyrs_round_played_cards = {}
    ret.current_round.aiko_round_played_words = {}
    ret.current_round.aiko_round_correct_letter = {}
    ret.current_round.aiko_round_misaligned_letter = {}
    ret.current_round.aiko_round_incorrect_letter = {}
    ret.current_round.aiko_played_suits = {}
    ret.current_round.aiko_played_ranks = {}
    ret.current_round.aiko_played_ench = {}
    ret.current_round.akyrs_last_played_letters = {}
    ret.current_round.discards_sub = 0
    ret.current_round.hands_sub = 0
    ret.current_round.aiko_infinite_hack = "8"
    ret.current_round.advanced_blind = false
    ret.akyrs_last_ante = nil
    ret.akyrs_umbral_atmosphere_score_inc = 100
    ret.akyrs_umbral_atmosphere_uses = 0
    ret.akyrs_umbral_intrusive_usage_set = -4
    ret.round_resets.blind_choices.akyrs_Solo = ""
    ret.round_resets.blind_states.akyrs_Solo = "Upcoming"
    ret.current_round.akyrs_hands_played = {}

    -- this one prevents crashes
    ret.modifiers.scaling = ret.modifiers.scaling or 1

    -- this one will get set to true once player has bought an Emerald OR used one of the Workstation Card
    ret.akyrs_has_capability_to_trade = false
    -- 
    -- note to self (this is the first time i am going to bother document this so i don't hallucinate shit up)
    -- this is an indexed table (array as we call it in literally other languages) each one representing villager workstation you redeem in the shop
    -- each entry should contain information about each villager's trades
    --  key : should contain data about the villager's profession ID (so to reference back). it should contain class prefix (profession) and also mod ID
    --  level : villager's current level (as in ranks)
    --  total_xp : total experience that a villager had gained
    --  trades : another "array" containing trade entry which in itself contains
    --    key : trade's registry key, for reference, again
    --    stock_left : in Minecraft, there's a limit to how much
    --    
    --    
    ret.akyrs_curent_trades = {}
    ret.akyrs_trade_unlocked = {}

    return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.discards_sub = 0
    G.GAME.current_round.hands_sub = 0
    G.GAME.current_round.aiko_infinite_hack = "∞"
    if G.GAME.akyrs_last_ante ~= G.GAME.round_resets.ante or G.GAME.akyrs_letter_target then
        G.GAME.akyrs_letter_target = pseudorandom_element(AKYRS.raw_scrabble_letters, pseudoseed(G.GAME.pseudorandom.seed.."akyrs".."letter_pick"))
        G.GAME.akyrs_last_ante = G.GAME.round_resets.ante
    end
    
    EMPTY(G.GAME.akyrs_last_played_letters)
    G.GAME.akyrs_last_played_letters = {}
    G.GAME.current_round.akyrs_last_action = nil
    G.GAME.current_round.aiko_played_suits = {}
    G.GAME.current_round.aiko_played_ranks = {}
    G.GAME.current_round.aiko_played_ench = {}
    G.GAME.current_round.akyrs_hands_played = {}
    local candidate_hands = AKYRS.filter_table(AKYRS.keyvalue_to_list(G.GAME.hands), function (hand_info, ind)
        return hand_info[2].played > 0
    end, false, true)
    if #candidate_hands > 0 then
        local hand_to_set = pseudorandom_element(candidate_hands, "akyrs_candidate_hand_for_bosses")
        if G.GAME.current_round.akyrs_picked_poker_hands then G.GAME.current_round.akyrs_picked_poker_hands = hand_to_set[1] end
    end
end


local gameUpdate = Game.update

function Game:update(dt)
    if AKYRS.bal_cur_val ~= AKYRS.bal() then
        AKYRS.mod_debug_info_set()
        AKYRS.bal_cur_val = AKYRS.bal()
    end
    if G.GAME then
        G.GAME.modifiers.scaling = G.GAME.modifiers.scaling or 1
        local s = gameUpdate(self, dt)
        G.GAME.alphabet_rate = G.GAME.alphabet_rate or 0
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
        AKYRS.expensive_calculation()
    end

    --print(collectgarbage("count"))

    return s
end

local cardUpdateHook = Card.update
function Card:update(dt)
    local x = cardUpdateHook(self,dt)
    if G.GAME.akyrs_ultimate_freedom and not self.states.drag.can then
        self.states.drag.can = true
    end
    if G.GAME.akyrs_ultimate_freedom and not self.states.click.can then
        self.states.click.can = true
    end
    if G.STATE == G.STATES.HAND_PLAYED then
        self.ability.akyrs_executed_debuff = false
        if self.area == G.play then
            for suitkey, suit in pairs(SMODS.Suits) do
                if(suitkey ~= nil and self:is_suit(suitkey) and G.GAME.current_round.aiko_played_suits) then
                    G.GAME.current_round.aiko_played_suits[suitkey] = true
                end
            end
            if(self:get_id() and G.GAME.current_round.aiko_played_ranks) and self:get_id() then
                G.GAME.current_round.aiko_played_ranks[self:get_id()] = true
            end
            if(self:get_id() and G.GAME.current_round.aiko_played_ench) and self.config.center_key then
                G.GAME.current_round.aiko_played_ench[self.config.center_key] = true
            end
        end

    end
    if self.ability.akyrs_stay_sigma then
        self.getting_sliced = false
        self.ability.akyrs_stay_sigma = true
        self.ability.akyrs_sigma = true
    end
    if self.ability.akyrs_sigma then
        self.ability.akyrs_stay_sigma = true
        self.children.center.pinch.x = false
        self.children.center.pinch.y = false
        self.ability.perishable = false
    end
    if self.seal == "akyrs_carmine" and G.STATE ~= G.STATES.HAND_PLAYED then
        if self.debuffed_by_blind then
            if G.GAME.current_round.hands_played == 0 then
                self.debuff = false
            else
                self.debuff = true
            end
        end
    end
    if self.config.center_key == "j_akyrs_emerald" and self.sell_cost ~= self.cost * self.ability.extras.xcost then
        local emerald = SMODS.find_card("j_akyrs_emerald")
        self.ability.extras.amnt = #emerald
        self.sell_cost = AKYRS.bal_val((self.cost + #emerald) * self.ability.extras.xcost,(self.cost + self.ability.extras.pluscost) ^ self.ability.extras.ecost)
    end
    if G.STATE == G.STATES.SELECTING_HAND then
        if not self.ability.akyrs_executed_debuff and G.GAME.blind and not G.GAME.blind.disabled then
            if G.GAME.blind.debuff.akyrs_suit_debuff_hand then
                for suit, _ in pairs(G.GAME.current_round.aiko_played_suits) do
                    if self:is_suit(suit) then
                        self:set_debuff(true)
                    end
                end
            end
            if G.GAME.blind.debuff.akyrs_rank_debuff_hand then
                if G.GAME.current_round.aiko_played_ranks[self:get_id()] and self:get_id() then
                    self:set_debuff(true)
                end
            end
            if G.GAME.blind.debuff.akyrs_enhancement_debuff_hand then
                if self.config.center_key and self.ability.set == "Enhanced" and G.GAME.current_round.aiko_played_ench[self.config.center_key] then
                    self:set_debuff(true)
                end
            end
            if G.GAME.blind.debuff.akyrs_all_seals_perma_debuff then
                if self.seal and not self.ability.akyrs_undebuffable then
                    self.ability.akyrs_perma_debuff = true
                end
            end
            self.ability.akyrs_executed_debuff = true
        elseif G.GAME.blind and G.GAME.blind.disabled then
            if G.GAME.blind.debuff.akyrs_suit_debuff_hand or G.GAME.blind.debuff.aiko_played_ranks then
                self:set_debuff(false)
            end
            self.ability.akyrs_executed_debuff = true
            
        end
    end
    -- permanent debuff shenanigans
    if self.ability.akyrs_undebuffable then
        self.ability.akyrs_perma_debuff = false
        self.ability.perma_debuff = false
        self:set_debuff(false)
    end
    if self.ability.akyrs_perma_debuff and not self.ability.akyrs_undebuffable then
        self:set_debuff(true)
    end
    if self.ability.akyrs_forced_selection and not self.ability.akyrs_undebuffable and self.area and self.area.highlighted then
        local isAlreadyInHighlighted = false
        for gg,gk in ipairs(self.area.highlighted) do
            if gk == self then
                isAlreadyInHighlighted = true
                break
            end
        end
        if not isAlreadyInHighlighted and #self.area.highlighted < self.area.config.highlighted_limit then
            self:highlight(true)
            self.area:add_to_highlighted(self)
            self.ability.forced_selection = true
        end
    end
end

function AKYRS.expensive_calculation()
    --nuGC(nil,nil, false)
    if G.STATE == G.STATES.HAND_PLAYED then
        G.GAME.current_round.akyrs_executed_debuff = false

        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            SMODS.calculate_context(
            {
                akyrs_score_change = true,
                last_mult = G.GAME.aiko_last_mult, 
                last_chips = G.GAME.aiko_last_chips,
                current_mult = G.GAME.current_round.current_hand.mult,
                current_chips  = G.GAME.current_round.current_hand.chips
            })
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips
        end
        if G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled and not G.GAME.blind.debuff.akyrs_scoring_set then
            AKYRS.set_scoring_parameter_backup('akyrs_math_display')
            G.GAME.blind.debuff = G.GAME.blind.debuff or {}
            G.GAME.blind.debuff.akyrs_scoring_set = true
        end
    end
    if G.STATE == G.STATES.BLIND_SELECT then
        if G.GAME.blind and G.GAME.blind.debuff and G.GAME.blind.debuff.initial_action_acted then
            G.GAME.blind.debuff.initial_action_acted = nil
        end
    end
    if G.STATE == G.STATES.SELECTING_HAND then
        
        if AKYRS.should_calculate_word() and G.GAME.blind.debuff.akyrs_is_puzzle_blind then
            if not G.GAME.blind.disabled and not G.GAME.blind.defeated and not G.GAME.current_round.akyrs_scoring_set then
                AKYRS.set_scoring_parameter_backup('akyrs_puzzle_display')
            end
        end
        if not G.GAME.blind.debuff.initial_action_act_set and not G.GAME.blind.disabled then
            G.GAME.blind.debuff.initial_action_acted = false
            G.GAME.blind.debuff.initial_action_act_set = true
        end
        if  G.GAME.blind.debuff.akyrs_pick_cards and not G.GAME.blind.disabled then
            if AKYRS.picker_initial_action and not G.GAME.blind.debuff.initial_action_acted then
                AKYRS.picker_initial_action()
                G.GAME.blind.debuff.initial_action_acted = true
            end
        end
    end
    

end

function customDeckHooks(self, card_protos)
    if self.GAME.starting_params.akyrs_start_with_no_cards then
        return {}
    end
    return card_protos
end

local startRunHook = Game.start_run
function Game:start_run(args)
    G.AKYRS_DISPLAY_QUEUE = nil
    G.AKYRS_CARD_EVAL_RAN = nil
    -- print("PRE RUN")
    local ret = startRunHook(self, args)
    -- print("POST RUN")
    
    AKYRS.reset_math_parser({
        vars = G.GAME.akyrs_parser_var or AKYRS.math_default_const,
    })
    if self.aiko_wordle then
        self.aiko_wordle:remove() self.aiko_wordle = nil
    end

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
        G.GAME.planet_rate = 0
    end
    if self.GAME.modifiers.akyrs_no_joker then
        for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
            G.GAME.banned_keys[v.key] = true
        end
    end
    if self.GAME.modifiers.akyrs_no_tarot then
        for k, v in ipairs(G.P_CENTER_POOLS.Tarot) do
            G.GAME.banned_keys[v.key] = true
        end
        G.GAME.tarot_rate = 0
    end
    if self.GAME.modifiers.akyrs_no_planet then
        for k, v in ipairs(G.P_CENTER_POOLS.Planet) do
            G.GAME.banned_keys[v.key] = true
        end
        G.GAME.planet_rate = 0
    end
    if self.GAME.modifiers.akyrs_can_buy_playing_cards then
        G.GAME.playing_card_rate = 4
    end
    
    if G.GAME.modifiers.akyrs_no_skips then
        G.GAME.akyrs_no_skips = G.GAME.modifiers.akyrs_no_skips
    end
    if G.GAME.modifiers.akyrs_hatena_deck then
        G.GAME.akyrs_hatena_deck = G.GAME.modifiers.akyrs_hatena_deck
    end
    
    if G.GAME.modifiers.akyrs_always_skip_shops then
        G.GAME.akyrs_always_skip_shops = G.GAME.modifiers.akyrs_always_skip_shops
    end
    if G.GAME.modifiers.akyrs_shops_after_boss then
        G.GAME.akyrs_shops_after_boss = G.GAME.modifiers.akyrs_shops_after_boss
    end
    if G.GAME.modifiers.akyrs_hatena_everything then
        G.GAME.akyrs_hatena_everything = G.GAME.modifiers.akyrs_hatena_everything
    end
    if self.GAME.modifiers.akyrs_no_hints then
        AKYRS.simple_event_add(
            function()
                G.GAME.akyrs_no_hints = true
                return true
            end, 0.5
        )
    end
    recalculateHUDUI()
    if G.GAME.current_round.advanced_blind then
        recalculateBlindUI()
    end
    if G.GAME.akyrs_any_drag then
        G.GAME.akyrs_temptation_resisted = true
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
    if #G.play.cards > 0 then
        for _,c in ipairs(G.play.cards) do
            G.deck:emplace(c)
        end
        G.play.cards = {}
    end
    for _,c in ipairs(G.playing_cards) do
        c:set_sprites(c.config.center,c.config.card)
    end
    return ret
end

local cardSetCostHook = Card.set_cost
function Card:set_cost()
    local ret = cardSetCostHook(self)
    if self.ability.akyrs_self_destructs then
        self.cost = 1
        self.sell_cost = 1
    end
    if self.ability.akyrs_sale then
        self.cost = 1
        self.sell_cost = 1
    end
    return ret
end

local discardAbilityHook = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    local ret = discardAbilityHook(e)
    if G.hand and G.hand.highlighted then
        for _, _c in ipairs(G.hand.highlighted) do
            if _c.ability.akyrs_attention then
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
                return ret
            end
        end
    end

    if #G.hand.highlighted > 0 and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end
    return ret
end



local cardRemoveHookFirst = Card.remove
function Card:remove()
    if self.akyrs_letter and type(self.akyrs_letter) == "table" then
        for _,lt in ipairs(self.akyrs_letter) do
            lt:remove()
        end
        self.akyrs_letter = nil
    end
    return cardRemoveHookFirst(self)
end

local cardRemoveHook = Card.remove
function Card:remove()
    local area = self.area or self.akyrs_lastcardarea

    if (not (AKYRS.sigmaable_areas(area) and self.ability.akyrs_sigma)) or (AKYRS.is_card_not_sigma(self)) or area.being_removed then
        --print("CARD CAN BE REMOVED SAFELY")
        if not G.AKYRS_RUN_BEING_DELETED and not (area and (area.config.collection or area.config.temporary or area.config.view_deck)) and area and AKYRS.game_areas(area) then
            if not area.being_removed then

                pcall(SMODS.calculate_context,{ akyrs_card_remove = true, card_getting_removed = self, being_sold = self.akyrs_is_being_sold })
            end
        end

        local l = cardRemoveHook(self)
        self.REMOVED = true
        return l
    elseif not self.area then
        local copy = copy_card(self)
        cardRemoveHook(self)
        AKYRS.simple_event_add(
            function ()
                area:emplace(copy)
                return true
            end, 0
        )
        AKYRS.nope_buzzer(self,nil,G.C.playable)
    end

end

local cardDissolveHook = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)

    if (AKYRS.is_card_not_sigma(self)) or not (AKYRS.sigmaable_areas(self.area) and self.ability.akyrs_sigma) then
        cardDissolveHook(self,dissolve_colours, silent, dissolve_time_fac, no_juice)
    end
end


local endRoundHook = end_round
function end_round()
    -- heavy handed as hell approach i do not like it but it should only let end_round run once at least in theory
    if G.AKYRS_ACTIVATED_END_ROUND then
        
        G.STATE = G.STATES.ROUND_EVAL
        return
    end

    
    local shouldNotEndRoundPuzzleBlind = G.GAME.current_round.advanced_blind and not G.GAME.aiko_puzzle_win and true or nil
    local shouldNotEndRoundMathDeck = G.GAME.akyrs_mathematics_enabled and not AKYRS.is_value_within_threshold(G.GAME.blind.chips,G.GAME.chips,G.GAME.akyrs_math_threshold)

    
    if (shouldNotEndRoundPuzzleBlind or shouldNotEndRoundMathDeck) and (G.GAME.current_round.hands_left > 0) then
        G.STATE = G.STATES.SELECTING_HAND
        G.STATE_COMPLETE = false
    else
        local ret = endRoundHook()
        G.AKYRS_ACTIVATED_END_ROUND = true
        --AKYRS.end_round_hook()
        return ret
    end
end


local updateSelectHandHook = Game.update_selecting_hand
function Game:update_selecting_hand(dt)
    local ret = updateSelectHandHook(self, dt)
    G.AKYRS_ACTIVATED_END_ROUND = nil
    if not self.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    elseif G.GAME.aiko_current_word ~= nil then
        G.GAME.aiko_current_word = nil
    end


    return ret
end

local updateHandPlayedHook = Game.update_hand_played
function Game:update_hand_played(dt)
    local ret = updateHandPlayedHook(self, dt)
    G.AKYRS_ACTIVATED_END_ROUND = nil
    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    if not self.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
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

local removeNode = Node.remove
function Node:remove()
    self.being_removed = true
    return removeNode(self)
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
    
    if self and self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        G.GAME.aikoyori_evaluation_value = 0
    end
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
    if self and self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        G.GAME.aikoyori_evaluation_value = 0
    end
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
    
    if G.GAME.starting_params.akyrs_inversion_deck then
        AKYRS.invert_selection(G.hand, hook)
    end

    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
        G.GAME.blind.debuff.primed = false
    end
    
    if G.hand and G.hand.highlighted then
        for _, _c in ipairs(G.hand.highlighted) do
            if _c.ability.akyrs_attention then
                return ret
            end
        end
    end

    if G.GAME.blind and not G.GAME.blind.disabled then
        if G.GAME.blind.debuff.akyrs_alternate_action and G.GAME.current_round.akyrs_last_action == "discard" then
            stop_use()
            G.CONTROLLER:save_cardarea_focus('hand')
            ease_discard(-1)
            AKYRS.simple_event_add(
                function ()
                    for _,c in ipairs(G.hand.highlighted) do
                        c:highlight(false)
                    end
                    G.buttons:get_UIE_by_ID("discard_button").disable_button = false
                    G.hand.highlighted = {}
                    return true
                end, 0
            )
            return
        end
        if G.GAME.blind.debuff.akyrs_reduce_other then
            ease_hands_played(-G.GAME.blind.debuff.akyrs_reduce_other)
            AKYRS.simple_event_add(
                function ()
                    if G.GAME.current_round.hands_left <= 0 then
                        end_round()
                    end
                    return true
                end
            )
        end
    end
    G.GAME.current_round.akyrs_last_action = "discard"
    local r = dcfhHook(e,hook)
    return r
end

local playCardEval = G.FUNCS.play_cards_from_highlighted

G.FUNCS.play_cards_from_highlighted = function(e)
    if G.GAME.blind.debuff.akyrs_reduce_other then
        ease_discard(-G.GAME.blind.debuff.akyrs_reduce_other)
    end
    if G.GAME.starting_params.akyrs_inversion_deck then
        AKYRS.invert_selection(G.hand)
    end
    local ret = playCardEval(e)
    return ret
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
G.FUNCS.evaluate_play = function(e)
    for i, c in ipairs(G.play.cards) do
        c.ability.akyrs_played_this_round = true
    end
    G.GAME.akyrs_ranks_played = G.GAME.akyrs_ranks_played or {}
    G.GAME.akyrs_suits_played = G.GAME.akyrs_suits_played or {}
    for i,c in ipairs(G.play.cards) do
        if not SMODS.has_no_rank(c) then
            G.GAME.akyrs_ranks_played[c:get_id()] = (G.GAME.akyrs_ranks_played[c:get_id()] or 0) + 1
        end
        if not SMODS.has_no_suit(c) and c.base and c.base.suit then
            G.GAME.akyrs_suits_played[c.base.suit] = (G.GAME.akyrs_suits_played[c.base.suit] or 0) + 1
        end
    end
    --print(G.GAME.aikoyori_evaluation_value)
    if G.GAME.akyrs_mathematics_enabled and not AKYRS.is_finite(G.GAME.aikoyori_evaluation_value) then
        AKYRS.blocking_unlock_achievement("ach_akyrs_div_0_math")
        AKYRS.simple_event_add(function ()
        error([[Galaxy Collapse!




Obviously this is not a real crash please do not report else I will have to remove your kneecaps.

Press [R] to restart your game.














Also technically this crash saves you from bricked runs so thank me later :D
















































        ]],4)
        return true
        end, 0,"achievement")
        return {}
    end
    if G.GAME.aikoyori_evaluation_value and G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
        
        attention_text({
            scale =  1.5, text = ""..G.GAME.aikoyori_evaluation_value, hold = 15, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
    end
    if G.GAME.aikoyori_variable_to_set and G.GAME.aikoyori_value_to_set_to_variable and not G.GAME.aikoyori_evaluation_value and G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
        attention_text({
            scale =  1.5, text = G.GAME.aikoyori_variable_to_set.." = "..tostring(G.GAME.aikoyori_value_to_set_to_variable), hold = 15, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
    end
   
    if G.GAME.blind.debuff.akyrs_perma_selection then
        if type(G.GAME.blind.debuff.akyrs_perma_selection) == "table" then
            local ps = G.GAME.blind.debuff.akyrs_perma_selection
            for i, k in ipairs(G.play.cards) do
                if SMODS.pseudorandom_probability(G.GAME.blind, ps.seed, ps.num, ps.denum) then
                    k.ability.akyrs_forced_selection = true
                end
            end
        else
            for i, k in ipairs(G.play.cards) do
                k.ability.akyrs_forced_selection = true
            end
        end
    end
    -- print(#G.play.cards)
    local word_split = nil
    if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled or AKYRS.word_blind() then

        
        local aiko_current_word_split = {}
        word_split = {}
        local cards = {}
        for i, k in ipairs(G.play.cards) do
            table.insert(cards,k)
        end
        table.sort(cards,AKYRS.hand_sort_function)
        for i, v in ipairs(cards) do
            if v.ability and v.ability.aikoyori_letters_stickers then
                local alpha = v.ability.aikoyori_letters_stickers:lower()
                if alpha == "#" and v.ability.aikoyori_pretend_letter then
                    -- if wild is set fr tbh
                    alpha = v.ability.aikoyori_pretend_letter:lower()
                elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                    alpha = '★'
                end
                
                for _, ltr in ipairs(AKYRS.word_splitter(alpha)) do
                    table.insert(aiko_current_word_split, ltr)
                    word_split[string.upper(ltr)] = true
                end
            end 
        end
        local w = table.concat(aiko_current_word_split,"")
        check_for_unlock({type = "akyrs_spell_word", word = w, lowercase_word = string.lower(w)})
        
        local wordData = {}
        
        local all_wildcards = true
        for _, val in ipairs(aiko_current_word_split) do
            if val ~= "#" then
                all_wildcards = false
                break
            end
        end
        if all_wildcards then
            if AKYRS.example_words[#aiko_current_word_split - 2] then
                G.GAME.aiko_current_word = string.lower(AKYRS.example_words[#aiko_current_word_split - 2])
                wordData.valid = true
                wordData.word = G.GAME.aiko_current_word
            end
        else
            if (AKYRS.WORD_CHECKED[aiko_current_word_split]) then
                --print("WORD "..word_hand_str.." IS IN MEMORY AND THUS SHOULD USE THAT")
                wordData = AKYRS.WORD_CHECKED[aiko_current_word_split]
            else
                --print("WORD "..word_hand_str.." IS NOT IN MEMORY ... CHECKING")
                wordData = AKYRS.check_word(aiko_current_word_split)
                AKYRS.WORD_CHECKED[aiko_current_word_split] = wordData
            end
        end


        --print(wordData)
        if wordData.valid then
            check_for_unlock({type = "akyrs_spell_valid_word", word = w, lowercase_word = string.lower(w)})
            G.GAME.akyrs_has_not_spelled_a_single_word = false
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
                _card:set_letters(v.ability.aikoyori_letters_stickers)
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
                elseif letter_count[string.lower(char)] and letter_count[string.lower(char)] > 0 then
                    if not G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] then
                        G.GAME.current_round.aiko_round_misaligned_letter[string.lower(char)] = true
                    end
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
    local ret = eval_hook(e)
    
    if( G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled or AKYRS.word_blind() ) and word_split then
        EMPTY(G.GAME.akyrs_last_played_letters)
        G.GAME.akyrs_last_played_letters = word_split
    end
    if G.GAME.aikoyori_variable_to_set and G.GAME.aikoyori_value_to_set_to_variable then
        AKYRS.parser_set_var(G.GAME.aikoyori_variable_to_set , G.GAME.aikoyori_value_to_set_to_variable)
    end
    if G.GAME.aikoyori_evaluation_value and G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
        if G.GAME.aikoyori_evaluation_replace then
            
            ease_chips(G.GAME.aikoyori_evaluation_value)
        else
            ease_chips(G.GAME.chips + G.GAME.aikoyori_evaluation_value)
        end
    end
    if G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
        G.GAME.aikoyori_evaluation_value = 0
    else
        G.GAME.aikoyori_evaluation_value = nil
    end
    G.GAME.aikoyori_variable_to_set = nil
    G.GAME.aikoyori_value_to_set_to_variable = nil
    G.GAME.aiko_current_word = nil
    
    G.GAME.aiko_current_word_table = {}
    
    G.GAME.current_round.akyrs_last_action = "play"
    return ret
end


local cardAreaInitHook = CardArea.init
function CardArea:init(X, Y, W, H, config)
    local r = cardAreaInitHook(self,X,Y,W,H,config)    
    if G.GAME.akyrs_ultimate_freedom and not self.states.collide.can then
        self.states.collide.can = true
    end
    return r
end

AKYRS.original_set_ability = Card.set_ability

function Card:set_ability(c,i,d)
    if self and self.ability and self.ability.akyrs_sigma then return end
    -- this one is for collection
    if self.config.center and not (self.config.center.set == "Enhanced" or self.config.center.set == "Default") and (AKYRS.card_any_drag()) and not AKYRS.is_mod_loaded("Cryptlib") then
        self.is_null = true
    end
    local r = AKYRS.original_set_ability(self,c,i,d)
    self:akyrs_mod_card_value_init(c, i, d)


    if self.config.card and self.config.center.set == "Enhanced" or self.config.center.set == "Default" and not self.is_null then
        self:set_base(self.config.card, i)
        if self.ability.akyrs_special_card_type == "suit" then
            self.base.nominal = 0
        elseif SMODS.Ranks[self.config.card.value] then
            self.base.nominal = SMODS.Ranks[self.config.card.value].nominal
        end
    end
    
    if (self.config.center or c).set == "Joker" and AKYRS.should_conceal_card(self, (self.config.center or c)) then
        self.T.w = G.CARD_W
        self.T.h = G.CARD_H
        AKYRS.simple_event_add(
            function ()
                self.cost = 5
                self.sell_cost = 3
                return true
            end, 0)
    end

    if(i) then
        self.akyrs_old_ability = AKYRS.deep_copy(self.ability)
    end
    return r
end

function AKYRS.change_base_set_card(self)
    if G.GAME.akyrs_any_drag or G.GAME.akyrs_ultimate_freedom then
        AKYRS.simple_event_add(
            function ()
                if self and not (self.config.center.set == "Enhanced" or self.config.center.set == "Default") then
                    local card = pseudorandom_element(G.P_CARDS,pseudoseed("akyrsmodcard"))
                    self:set_base(card)
                    if self.children and self.children.front then
                        self.children.front:remove()
                        self.children.front = nil
                    end
                    --print(self.base)
                    --print("TS IS SO ASS" ,suit.key,rank.key)
                    --print(self.base)
                    --[[
                        if self.ability.set == "Voucher" then
                            self:set_base(AKYRS.construct_case_base("akyrs_voucher","akyrs_non_playing"), true)
                        elseif self.ability.set == "Booster" then
                            self:set_base(AKYRS.construct_case_base("akyrs_booster","akyrs_non_playing"), true)
                        elseif self.ability.consumeable then
                            self:set_base(AKYRS.construct_case_base("akyrs_consumable","akyrs_non_playing"), true)
                        elseif self.ability.set == "Joker" then
                            self:set_base(AKYRS.construct_case_base("akyrs_joker","akyrs_non_playing"), true)
                        else
                            self:set_base(AKYRS.construct_case_base("akyrs_thing","akyrs_non_playing"), true)
                        end
                    ]]
                end
                return true
            end, 0, "akyrs_misc")
    end
end

local cardBaseHooker = Card.set_base
function Card:set_base(card, initial, manual_sprites)
    local ret = cardBaseHooker(self, card, initial, manual_sprites)
    self.aiko_draw_delay = math.random() * 1.75 + 0.25
    self.akyrs_impostor_card = false
    if self.base.name and not self.ability.aikoyori_letters_stickers then
        self:set_letters_random()
        self.ability.forced_letter_render = false
    end
    
    if self.config.card and self.config.center.set == "Enhanced" or self.config.center.set == "Default" then
        if self.ability.akyrs_special_card_type == "suit" then
            self.base.nominal = 0
        elseif SMODS.Ranks[self.config.card.value] then
            self.base.nominal = SMODS.Ranks[self.config.card.value].nominal
        end
    end
    
    return ret
end
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)

    
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

AKYRS.do_not_misprint = {
    ["j_misprint"] = true
}

function Card:akyrs_mod_card_value_init(center, initial, delay)
    
    if G.GAME.modifiers.akyrs_misprint and not (self.ability or {}).misprinted and center and not AKYRS.do_not_misprint[center.key] then
        --local x = self.ability
        local x = AKYRS.deep_copy((G.P_CENTERS[center.key] or center).config)
        --print(y.config)
        AKYRS.mod_card_values(x,{random = {digits_min = -4, digits_max = 4, min = 1e-4, max = 1e4,scale = 1, can_negate = false}})
        --print(y.config)
        for n, v in pairs(x) do
            self.ability[n] = x[n] or self.ability[n]
        end
        self.ability.misprinted = true
    end
    
    if #SMODS.find_card("j_akyrs_chicken_jockey") > 0 and self.config.center_key == "j_popcorn" then
        local jj = SMODS.find_card("j_akyrs_chicken_jockey")
        if AKYRS.bal("absurd") then
            self.ability.extra = jj[#jj].ability.extras.decrease_popcorn_absurd
            self.ability.mult = jj[#jj].ability.extras.popcorn_original_absurd
        else
            self.ability.extra = jj[#jj].ability.extras.decrease_popcorn
        end
    end
    if self.config.center_key == "j_akyrs_emerald" then
        self.sell_cost = AKYRS.bal_val(self.cost * self.ability.extras.xcost,(self.cost + self.ability.extras.pluscost) ^ self.ability.extras.ecost)
        if self.sell_cost ~= self.sell_cost then self.sell_cost = 1e300 end
    end
    if #SMODS.find_card("j_akyrs_gift_voucher") > 0 then
        local gifts = SMODS.find_card("j_akyrs_gift_voucher")
        for _, _c in ipairs(gifts) do
            if self.config.center.set == _c.ability.extras.type then
                AKYRS.simple_event_add(
                    function ()
                        if self.area == G.shop_jokers or self.area == G.load_shop_jokers and self.cost ~= 0 then
                            self.cost = 0
                            AKYRS.juice_like_tarot(self)
                            AKYRS.force_save()
                        end
                        return true
                    end, 0
                )
            end
        end
    end
    if G.GAME.modifiers.akyrs_all_cards_are_stone then
        if self.ability.set == "Default" or self.ability.set == "Enhanced" then
            AKYRS.original_set_ability(self,G.P_CENTERS["m_stone"])
            if self.ability.bonus == 0 then
                self.ability.bonus = 50
            end
        end
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
    c.debuffed_by_blind = self.debuffed_by_blind
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
    self.debuffed_by_blind = cardTable.debuffed_by_blind
    
    _c = self.config.center

    if _c and AKYRS.should_conceal_card(self, _c) then
        for key, spriters in pairs(self.children) do
            if self.children[key] and key ~= "center" and key ~= "shadow" and key ~= "back" then
                if spriters.atlas then
                    spriters.atlas = G.ASSET_ATLAS["akyrs_blank"]
                    spriters:set_sprite_pos({ x = 0, y = 0})
                end
            elseif key == "center" then
                AKYRS.simple_event_add(
                    function ()
                        spriters.T.w = G.CARD_W
                        spriters.T.h = G.CARD_H
                        return true
                    end, 0, "other"
                )
            end
        end
    end
    return c
end

local getNominalHook = Card.get_nominal
function Card:get_nominal(mod)
    if self.is_null and self.ability.aikoyori_letters_stickers then
        return -10 - string.byte(self.ability.aikoyori_letters_stickers)
    end
    if not AKYRS.should_score_chips(self.config.center, self) and not mod then
        return -10
    end
    local ret = getNominalHook(self, mod)
    if self.ability and self.ability.akyrs_special_card_type then
        local mult = 1
        local rank_mult = 1
        if mod == 'suit' then mult = 10000 end
        local suit_nominal = self.base.suit_nominal
        local rank_nominal = self.base.nominal
        local face_nominal = self.base.face_nominal
        local orig_suit_nominal = self.base.suit_nominal_original
        if self.ability.effect == 'Stone Card' or (self.config.center.no_suit and self.config.center.no_rank) then
            mult = -10000
        elseif self.config.center.no_suit then
            mult = 0
        elseif self.config.center.no_rank then
            rank_mult = 0
        end
        if mod == "suit" and self.ability.akyrs_special_card_type == "rank" then
            suit_nominal = suit_nominal - 50
            orig_suit_nominal = 0
        elseif not mod and self.ability.akyrs_special_card_type == "suit" then
            rank_nominal = rank_nominal - 50
            face_nominal = 0
        end
        ret = 10*rank_nominal*rank_mult + suit_nominal*mult + (orig_suit_nominal or 0)*0.0001*mult + 10*face_nominal*rank_mult + 0.000001*self.unique_val
    end
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
                    -- aces should be last :3
                    if a.base.id == 14 then return false end return a.base.id > b.base.id
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
    if self.config.type == 'akyrs_collections' then
        for k, card in ipairs(self.cards) do
            card.T.r = 0.1*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
            local max_cards = math.max(#self.cards, self.config.temp_limit)
            card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)
            if #self.cards > 2 or (#self.cards > 1 and self == G.consumeables) or (#self.cards > 1 and self.config.spread) then
                card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/(#self.cards-1)) + 0.5*(self.card_w - card.T.w)
            elseif #self.cards > 1 and self ~= G.consumeables then
                card.T.x = self.T.x + (self.T.w-self.card_w)*((k - 0.5)/(#self.cards)) + 0.5*(self.card_w - card.T.w)
            else
                card.T.x = self.T.x + self.T.w/2 - self.card_w/2 + 0.5*(self.card_w - card.T.w)
            end
            local highlight_height = G.HIGHLIGHT_H/2
            --if not card.highlighted then highlight_height = 0 end
            card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height+ (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x)
            card.T.x = card.T.x + card.shadow_parrallax.x/30
        end
        table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 - 100*(a.pinned and a.sort_id or 0) < b.T.x + b.T.w/2 - 100*(b.pinned and b.sort_id or 0) end)
    end   
    if G.GAME.akyrs_ultimate_freedom and not self.states.collide.can then
        self.states.collide.can = true
    end
    if G.GAME.akyrs_ultimate_freedom and self == G.play and self.states.collide.can then
        self.states.collide.can = false
    end
end

local cardAreaDrawHook = CardArea.draw
function CardArea:draw()
    local r = cardAreaDrawHook(self)

    self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
    for k, v in ipairs(self.ARGS.draw_layers) do
        if self.config.type == 'akyrs_credits' or self.config.type == 'akyrs_solitaire_tableau' or self.config.type == 'akyrs_solitaire_foundation' or self.config.type == 'akyrs_solitaire_waste' or self.config.type == 'akyrs_cards_temporary_dragged' or self.config.type == 'akyrs_collections' and self.cards then 
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


    if self.effect.config.akyrs_selection then
        AKYRS.simple_event_add(
            function ()
                
                SMODS.change_play_limit(self.effect.config.akyrs_selection)
                SMODS.change_discard_limit(self.effect.config.akyrs_selection)
                return true
            end
        )
    end
    if self.effect.config.akyrs_start_with_no_cards then
        G.GAME.starting_params.akyrs_start_with_no_cards = true
    end
    if self.effect.config.akyrs_character_stickers_enabled then
        G.GAME.akyrs_character_stickers_enabled = true
    end
    if self.effect.config.akyrs_wording_enabled then
        G.GAME.akyrs_wording_enabled = true
        G.GAME.akyrs_has_not_spelled_a_single_word = true
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
    if self.effect.config.akyrs_power_of_x_scaling then
        G.GAME.akyrs_power_of_x_scaling = self.effect.config.akyrs_power_of_x_scaling
    end
    if self.effect.config.akyrs_always_skip_shops then
        G.GAME.akyrs_always_skip_shops = self.effect.config.akyrs_always_skip_shops
    end
    if self.effect.config.akyrs_no_skips then
        G.GAME.akyrs_no_skips = self.effect.config.akyrs_no_skips
    end
    if self.effect.config.akyrs_gain_selection_per_ante then
        G.GAME.akyrs_gain_selection_per_ante = self.effect.config.akyrs_gain_selection_per_ante
    end
    if self.effect.config.akyrs_split_deck then
        G.GAME.starting_params.akyrs_split_deck = self.effect.config.akyrs_split_deck
    end
    if self.effect.config.akyrs_split_rank_deck then
        G.GAME.starting_params.akyrs_split_rank_deck = self.effect.config.akyrs_split_rank_deck
    end
    if self.effect.config.akyrs_split_suit_deck then
        G.GAME.starting_params.akyrs_split_suit_deck = self.effect.config.akyrs_split_suit_deck
    end
    if self.effect.config.akyrs_inversion_deck then
        G.GAME.starting_params.akyrs_inversion_deck = self.effect.config.akyrs_inversion_deck
    end
    if self.effect.config.akyrs_down_deck then
        G.GAME.starting_params.akyrs_down_deck = self.effect.config.akyrs_down_deck
    end
    if self.effect.config.akyrs_ultimate_freedom then
        G.GAME.starting_params.akyrs_ultimate_freedom = self.effect.config.akyrs_ultimate_freedom
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
            end, 0.02
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
            end, 0.02
        )
    end
    if G.GAME.starting_params.akyrs_ultimate_freedom then
        G.GAME.akyrs_temptation_resisted = true
        G.GAME.akyrs_ultimate_freedom = G.GAME.starting_params.akyrs_ultimate_freedom
    end

    if G.GAME.starting_params.akyrs_hatena_deck then
        G.GAME.akyrs_hatena_deck = G.GAME.starting_params.akyrs_hatena_deck
    end

    if G.GAME.starting_params.akyrs_hatena_everything then
        G.GAME.akyrs_hatena_deck = G.GAME.starting_params.akyrs_hatena_everything
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
        AKYRS.initialise_deck_letter(G.GAME.starting_params.akyrs_starting_letters)
    end
    AKYRS.simple_event_add(
        function ()
            if G.GAME.modifiers.akyrs_start_with_letter_deck then
                G.GAME.starting_params.akyrs_starting_letters = AKYRS.scrabble_letters
                AKYRS.initialise_deck_letter(G.GAME.starting_params.akyrs_starting_letters)
                G.GAME.akyrs_character_stickers_enabled = true
                G.GAME.akyrs_wording_enabled = true
                G.GAME.akyrs_has_not_spelled_a_single_word = true
                SMODS.change_play_limit(1e100)
                SMODS.change_discard_limit(1e100)
            end
            return true
        end, 0
    )
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
            if (not joker.debuff and joker.ability.immutable) then
                if (joker.ability.immutable.akyrs_priority_draw_suit) then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "suit",joker.ability.immutable.akyrs_priority_draw_suit}
                    --print(joker.ability.akyrs_priority_draw_suit)
                end
                if joker.ability.immutable.akyrs_priority_draw_rank then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "rank",joker.ability.immutable.akyrs_priority_draw_rank}
                    --print(joker.ability.akyrs_priority_draw_rank)
                end
                if joker.ability.immutable.akyrs_priority_draw_conditions == "Face Cards" then
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
                -- why did i need to do this
                local r, r2 = pcall(function(k) return k:get_id() end,k)
                if 
                ((l[2] == "suit" and k:is_suit(l[3]) and not SMODS.has_no_suit(k))) or
                ((l[2] == "rank" and 
                type(k) == "table" and (
                    r2 == 
                    SMODS.Ranks[l[3]].id) 
                    and 
                    (not SMODS.has_no_rank(k)))) or
                ((l[2] == "face" and k:is_face() == l[3]))
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
        for x, ca in ipairs(G.I.CARDAREA) do
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
        for x, ca in ipairs(G.I.CARDAREA) do
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
    if (G.PROFILES[G.SETTINGS.profile].akyrs_balance == "absurd" and (MP) and true) then
        G.AKYRS_MULTIPLAYER_NOTICE_INTRO = true
        AKYRS.start_onboarding(true, true)
    elseif (G.PROFILES[G.SETTINGS.profile].akyrs_balance == "absurd" and not Talisman) then
        G.AKYRS_TALISMAN_NOTICE_INTRO = true
        AKYRS.set_bal("adequate")
    else
        AKYRS.start_onboarding()
    end
    return r
end


local startMaterializeHook = Card.start_materialize
function Card:start_materialize(cols, slnt, timefac)
    if not cols and not AKYRS.should_conceal_card(self,self.config.center) then
        if self.ability.set == "Umbral" then
            cols = { G.C.AKYRS_UMBRAL_P, G.C.AKYRS_UMBRAL_Y }
        elseif self.ability.set == "Replicant" then
            cols = { G.C.AKYRS_REPLICANT_O, G.C.AKYRS_REPLICANT_P }
        elseif self.ability.set == "Alphabet" then
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
    end
    if AKYRS.should_conceal_card(self,self.config.center) then
        cols = {HEX("000000")}
    end
    local h = startMaterializeHook(self, cols, slnt, timefac)
    return h
end

local blindDisable = Blind.disable
function Blind:disable()
    if self.debuff.akyrs_cannot_be_disabled and not G.AKYRS_FORCE_BLIND_DISABLE then
        AKYRS.nope_buzzer()
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
        AKYRS.nope_buzzer(uib and uib.children and uib.children[1] and uib.children[1].children[1].children[1] or nil)

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
    if G.GAME.modifiers.akyrs_all_blinds_are then
        return G.GAME.modifiers.akyrs_all_blinds_are
    end
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
    if self then
        G.GAME.akyrs_blind_just_defeated = true
    end
    local x = blindDefeatHook(self,silent)
    return x
end

local selectBlindHook = G.FUNCS.select_blind
G.FUNCS.select_blind = function(e)
    G.GAME.akyrs_ui_should_recalculate = true
    if G.GAME.modifiers.akyrs_obtain_every_round then
        if AKYRS.has_room(G.jokers) then
            SMODS.add_card({ key = G.GAME.modifiers.akyrs_obtain_every_round })
        end
    end
    return selectBlindHook(e)
end

local setBlindHook = Blind.set_blind
function Blind:set_blind(blind, initial, silent)
    

    if blind and G.GAME.akyrs_ui_should_recalculate then
        recalculateBlindUI()
        G.GAME.akyrs_ui_should_recalculate = nil
    end
    if G.GAME.blind and G.GAME.blind.in_blind and not G.GAME.blind.defeated and G.GAME.blind.debuff.akyrs_cannot_be_overridden and 
    (not G.GAME.blind.debuff.akyrs_can_be_replaced_by or G.GAME.blind.debuff.akyrs_can_be_replaced_by[blind.key])
    then
        --AKYRS.nope_buzzer()
    else
        return setBlindHook(self,blind, initial, silent)
    end
end

local rst_blind = reset_blinds
function reset_blinds()
    if G.GAME.modifiers.akyrs_all_blinds_are then
        rst_blind()
        for bl, cho in pairs(G.GAME.round_resets.blind_choices) do
            G.GAME.round_resets.blind_choices[bl] = G.GAME.modifiers.akyrs_all_blinds_are
        end
    else
        rst_blind()
    end
end

local dfd2h = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(...)
    if G.STATE == G.STATES.ROUND_EVAL then return end
    return dfd2h(...)
end

local card_use_cons = Card.use_consumeable
function Card:use_consumeable(...)
    if G.GAME.starting_params.akyrs_inversion_deck then
        AKYRS.invert_selection(G.hand)
    end
    return card_use_cons(self,...)
end

local showman_hook = SMODS.showman
function SMODS.showman(c_k)
    if G.GAME.modifiers.akyrs_allow_duplicates then
        return true
    end
    return showman_hook(c_k)
end
