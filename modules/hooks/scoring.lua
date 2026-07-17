-- this file focuses on PURE scoring/joker calculation hooks
function Card.aiko_trigger_external(card)
end

--[[
]]
local hookCalFx = SMODS.calculate_effect
AKYRS.repetable_fx_calc = function(effect, scored_card, from_edition, pre_jokers)
    local card = effect.card or scored_card
    local r
    if card and card.ability and card.ability.akyrs_oxidising and not effect.akyrs_ignore_copper_calculation then
        local psrd = pseudorandom(pseudoseed("akyrs_oxidising_"..card.config.center_key))
        local compr
        if Talisman then compr = to_big(psrd) * to_big(4) > to_big(card.ability.akyrs_oxidising - 1) else compr = psrd * 4 > card.ability.akyrs_oxidising - 1 end
        if  compr then
            r = hookCalFx(effect, scored_card, from_edition, pre_jokers)
        else
            r = hookCalFx({ message = localize("k_nope_ex"), colour = HEX("b74912"),}, card, from_edition, pre_jokers)
        end
        if G.GAME.blind and mult and G.GAME.blind.debuff.akyrs_score_face_with_my_dec_mult and G.GAME.blind.debuff.dec_mult then
            if scored_card and scored_card:is_face(true) then
                G.E_MANAGER:add_event(Event({trigger = 'immediate', blocking = false, blockable = true, func = function () scored_card:juice_up(0.1); return true end}))
                r = SMODS.calculate_individual_effect(effect, scored_card, "xmult", G.GAME.blind.debuff.dec_mult, false, false)
                percent = (percent or 0) + (percent_delta or 0.08)
            end
        end
    else
        r = hookCalFx(effect, scored_card, from_edition, pre_jokers)
    end
    return r
end
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    local r,x,b,c = AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
    local extratrigs = (scored_card and scored_card.ability and scored_card.ability.akyrs_card_extra_triggers) and scored_card.ability.akyrs_card_extra_triggers or 0
    extratrigs = extratrigs + (scored_card and scored_card.edition and scored_card.edition.akyrs_card_extra_triggers or 0)
    if extratrigs > 0 then
        for i = 1, extratrigs do
            --print("RE-actual-TRIGGERED")
            --[[
            G.E_MANAGER:add_event(Event(
            {trigger = 'before', 
            blocking = true, 
            blockable = true, 
            func = function () 
                scored_card:juice_up(0.1); 
                AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
                return true
            end}),'base')
            
            ]]
            scored_card:juice_up(0.1); 
            AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
        end
    end
    return r,x,b,c
end
--[[
local evalCardHook = eval_card
function eval_card(card,context)
    
    local r,s = evalCardHook(card,context)
    local extratrigs = card.ability and card.ability.akyrs_card_extra_triggers or 0
    extratrigs = extratrigs + (card.edition and card.edition.akyrs_card_extra_triggers or 0)
    if extratrigs > 0 then
        for i = 1, extratrigs do
            print("RE-actual-TRIGGERED")
            r,s = evalCardHook(card,context)
        end
    end
    return r,s
end
]]

--[[
local vanillaRanks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"}
local prevRankMap = {"Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"}
AKYRS.RanksPrevSet = {}
for j, k in ipairs(vanillaRanks) do
    AKYRS.RanksPrevSet[k] = SMODS.Ranks[k].prev
    local rankIsAlreadyInThere = false
    for i, v in ipairs(AKYRS.RanksPrevSet[k]) do
        if prevRankMap[i] == v then
            rankIsAlreadyInThere = true
        end
    end
    if not rankIsAlreadyInThere then
        SMODS.Rank:take_ownership(k,{
            prev = {
                unpack(AKYRS.RanksPrevSet[k]),
                prevRankMap[j]
            }
        }, true)
    end
end
]]

local get_blind_amount_hook = get_blind_amount
function get_blind_amount(ante)
    local r = get_blind_amount_hook(ante)
    if G.GAME.akyrs_power_of_x_scaling then
        if Talisman then
            r = to_big(G.GAME.akyrs_power_of_x_scaling):pow(ante)*10
        else
            r = math.pow(G.GAME.akyrs_power_of_x_scaling,ante)*10
        end
    end
    if G.GAME.akyrs_random_scale then
        if Talisman then
            G.GAME.akyrs_blind_random = G.GAME.akyrs_blind_random or (r*(pseudorandom(pseudoseed("akyrs_random_scale"),to_number(G.GAME.akyrs_random_scale.min)*1000,to_number(G.GAME.akyrs_random_scale.max)*1000))/1000)
        else
            G.GAME.akyrs_blind_random = G.GAME.akyrs_blind_random or (r*(pseudorandom(pseudoseed("akyrs_random_scale"),G.GAME.akyrs_random_scale.min*1000,G.GAME.akyrs_random_scale.max*1000))/1000)
        end
        r = G.GAME.akyrs_blind_random
    end
    
    return r
end

-- taking over high card so it doesn't do the thing
local highcard_func = SMODS.PokerHands['High Card'].evaluate
SMODS.PokerHand:take_ownership("High Card",{
    evaluate = function (parts, hand)
        if not G.GAME.akyrs_mathematics_enabled then
            return highcard_func(parts,hand)
        end
        return {}
    end
})

-- if not G.GAME.akyrs_win_checked then
--     AKYRS.simple_event_add(
--         function ()
--             if not G.GAME.akyrs_win_checked and not AKYRS.is_mod_loaded("NotJustYet") then
--                 AKYRS.force_check_win({ force_draw = true})
--             end
--             return true
--         end, 0
--     )
-- end

local calc_indiv_fx = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local aaa = {calc_indiv_fx(effect, scored_card, key, amount, from_edition)}
        --print(key,amount)
        
        if effect == 'akyrs_no_calculate' then
            G.GAME.akyrs_no_calculate = true
        end
    return unpack(aaa)
end

local smodgetprobvar = SMODS.get_probability_vars
function SMODS.get_probability_vars(trigger_obj, base_numerator, base_denominator, identifier, from_roll, non_modifiable)
    local n, d = smodgetprobvar(trigger_obj, base_numerator, base_denominator, identifier, from_roll, non_modifiable)
    if not non_modifiable then
        G.GAME.akyrs_prob_mod = G.GAME.akyrs_prob_mod or {}
        for _, mod in ipairs(G.GAME.akyrs_prob_mod) do
            if mod.n_add then
                n = n + mod.n_add
            end
            if mod.d_add then
                d = d + mod.d_add
            end
            if mod.n_mult then
                n = n * mod.n_mult
            end
            if mod.d_mult then
                n = n * mod.d_mult
            end
        end
    end
    return n, d
end


local calcrep = SMODS.calculate_repetitions
SMODS.calculate_repetitions = function(card, context, reps)
    if G.GAME.blind and G.GAME.blind.debuff.akyrs_no_retriggers and not G.GAME.blind.disabled then
        return {}
    end
	local reps = calcrep(card, context, reps)
	reps = reps or { 1 }
	return reps
end

local easedol = ease_dollars
ease_dollars = function(amnt, insta)
    if G.GAME.blind and G.GAME.blind.debuff.akyrs_no_gain_cash and not G.GAME.blind.disabled then
        return 
    end
    return easedol(amnt, insta)
end


-- detect animation skip
local cardevalstat = card_eval_status_text
function card_eval_status_text(...)
	local args = { ... }
    G.AKYRS_CARD_EVAL_RAN = true
    local r = {cardevalstat(...)}
    return unpack(r)
end

local add_tag_ref = add_tag
function add_tag(...)
    local args = { ... }
    if args[1] == G.P_TAGS["tag_charm"] then
        AKYRS.trigger_tldr_conditions("got_charm_tag")
    end
    local rx = add_tag_ref(...)
    return rx
    
end
