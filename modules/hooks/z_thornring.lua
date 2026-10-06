local strange_sequence_jokers = { j_joker = true, j_akyrs_thornring = true }

SMODS.Blind{
    key = "the_nil",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("4f6367"),
    atlas = 'aikoyoriBlindsChips3',
    boss = {min = 1,},
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_cannot_be_rerolled = true,
    },
    pos = { x = 0, y = 15 },
    in_pool = function (self)
        return false
    end,
    no_collection = true,
    calculate = function (self, blind, context)
        if context.akyrs_prevent_win and (G.GAME.current_round.hands_left ~= 0 or G.GAME.current_round.discards_left ~= 0) then
            return {
                prevent_win = true
            }
        end
    end
}

SMODS.Joker {
    key = "thornring",
    atlas = 'AikoyoriJokers',
    pos = { x = 1, y = 9 },
    pools = {  },
    config = {
        extra_slots_used = -1,
        extras = {
            activated = false
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                
            }
        }
    end,
    akyrs_joker_use_btn = true,
    akyrs_joker_can_use = function (self, card)
        return #AKYRS.filter_table(SMODS.merge_lists({G.jokers.cards or {}, G.consumeables.cards or {}}), function (item, index)
            return item.ability.akyrs_the_jimbo
        end, true, true) > 0 and not card.ability.extras.activated
    end,
    akyrs_joker_use = function (self, card)
        card.ability.extras.activated = true
        local other_jokers = AKYRS.filter_table(SMODS.merge_lists({G.jokers.cards or {}, G.consumeables.cards or {}}), function (item, index)
            return item ~= card and not item.ability.akyrs_the_jimbo
        end, true, true)
        if #other_jokers > 0 then SMODS.destroy_cards(other_jokers) end
        local jimbucko = AKYRS.filter_table(SMODS.merge_lists({G.jokers.cards or {}, G.consumeables.cards or {}}), function (item, index)
            return item.ability.akyrs_the_jimbo
        end, true, true)
        AKYRS.do_things_to_card(jimbucko, function (_card, index)
            AKYRS.mod_card_values(_card, { func = function (value, key, _card, reference_center)
                return value * 2
            end})
        end)
        
    end,
    rarity = 'akyrs_unique',
    no_collection = true,
    cost = 6,
    calculate = function (self, card, context)
        if context.end_of_round and context.main_eval then
            return {
                func = function() card.ability.extras.activated = false end
            }
        end
    end,
}

-- sequence notes for self (redux)
-- sequence 1: 
-- start of run -> shop 1 (generate a jimbo)
-- buy jimbo? -> go to sequence 2 (plays jingle)
-- otherwise abort sequence
-- sequence 2: after obtain jimbo from shop 1 --> ante 2 shop 1 (generate a thorn ring that costs however many )
-- you must use thorn ring every round after that
AKYRS.strange_sequence = {}

function AKYRS.strange_sequence.abort(no_jingle)
    G.GAME.akyrs_strange_sequence = nil
    G.GAME.akyrs_strange_sequence_aborted = true
    G.GAME.akyrs_strange_sequence_modulate = nil
    AKYRS.update_all_blind_select()
    AKYRS.set_background_shaders("background") 
    G.GAME.selected_back = Back(G.P_CENTERS.b_red)
    if not no_jingle then play_sound('akyrs_ss_snd_ominous_cancel') end
end

function AKYRS.strange_sequence.proceed(no_jingle)
    G.GAME.akyrs_strange_sequence = (G.GAME.akyrs_strange_sequence or 0) + 1
    AKYRS.strange_sequence.steps(G.GAME.akyrs_strange_sequence)
    if not no_jingle then G.GAME.akyrs_strange_sequence_modulate = (G.GAME.akyrs_strange_sequence_modulate or 1) + 1 play_sound('akyrs_ss_snd_ominous') end
end

function AKYRS.strange_sequence.steps(step)
    local functions = {
        function () -- step 1 is set up during run start so no need to so anything here
            
        end,
        function () -- step 2 is in motion once you buy jimbo from shop 1 up until you get to the first shop of ante 2
            
        end,
        function () -- step 3 happens once you enter shop
            G.GAME.round_resets.blind_choices.Boss = 'bl_akyrs_the_nil'
        end,
        function () -- step 4 happens when you buy the ring from the shop
            G.GAME.round_resets.blind_choices.Boss = 'bl_akyrs_the_nil'
        end,
    }
    if functions[step] == nil then return end
    return (functions[step])()
end

AKYRS.strange_sequence.STATES = {
    PASS = 1,
    AWAIT = 2,
    FAIL = 3,
}

---@alias AKYRS.strange_sequence.CheckFunc fun(context: CalcContext):AKYRS.strange_sequence.STATES

---continuously run in case if something is messed up
---@param context CalcContext context
---@param extras table
---@return boolean check if true, keep going
---@return boolean jingle? should play the jingle?
function AKYRS.strange_sequence.continuous_check(_context, number)
    local functions = {
        ---@param context CalcContext
        function (context) -- step 1 criteria: have a jimbo in your joker slot
            if (context.joker_type_destroyed or context.selling_card) and context.card.ability.akyrs_the_jimbo then
                return false, true
            end
            return true
        end,
        ---@param context CalcContext
        function (context) 
            return true
        end,
        ---@param context CalcContext
        function (context) 
            if (context.joker_type_destroyed or context.selling_card) and context.card.ability.akyrs_the_thornring then
                return false, true
            end
            return true
        end,
        function (context) 
            return true
        end,
    }
    if functions[number] == nil then return true end
    return (functions[number])(_context)
end

---@param context CalcContext context
---@param extras table
---@return AKYRS.strange_sequence.STATES state
---@return boolean jingle? should play the jingle?
function AKYRS.strange_sequence.check_flags_funcs(_context)
    ---@type AKYRS.strange_sequence.CheckFunc[]
    local functions = {
        ---@param context CalcContext
        function (context) -- step 1 criteria: have a jimbo in your joker slot
            if context.buying_card then
                if context.card.config.center.key == 'j_joker' then
                    return AKYRS.strange_sequence.STATES.PASS, true
                end
            end
            if context.ending_shop then
                return AKYRS.strange_sequence.STATES.FAIL, true
            end
            return AKYRS.strange_sequence.STATES.AWAIT
        end,
        ---@param context CalcContext
        function (context) -- step 2 check is done in ante 2 shop 1
            if context.beat_boss and context.end_of_round and not context.repetition and not context.individual and G.GAME.round_resets.ante == 1 then
                G.GAME.akyrs_forced_shop_jokers = { 'j_akyrs_thornring' }
                return AKYRS.strange_sequence.STATES.PASS, false
            end
        end,
        ---@param context CalcContext
        function (context) -- step 3 buy the thornring
            if context.buying_card then
                if context.card.config.center.key == 'j_akyrs_thornring' then
                    return AKYRS.strange_sequence.STATES.PASS, true
                end
            end
            if context.ending_shop then
                return AKYRS.strange_sequence.STATES.FAIL, true
            end
            return AKYRS.strange_sequence.STATES.AWAIT
        end,
        function (context) -- step 4 beat the nil boss (note nil boss will not be defeated until you run out of hands)
            return AKYRS.strange_sequence.STATES.AWAIT
        end,
    }
    if functions[G.GAME.akyrs_strange_sequence] == nil then return end
    return (functions[G.GAME.akyrs_strange_sequence])(_context)
end

---@param context CalcContext context
function AKYRS.strange_sequence.check_flags(context)
    local checks, jingle = AKYRS.strange_sequence.check_flags_funcs(context)
    local continuous_checks_result = true
    for i = 1, G.GAME.akyrs_strange_sequence - 1 do
        local r1, r2 = AKYRS.strange_sequence.continuous_check(context, i)
        continuous_checks_result, jingle = continuous_checks_result and r1, jingle or r2
        if not continuous_checks_result then break end
    end
    if checks == AKYRS.strange_sequence.STATES.PASS and continuous_checks_result then
        AKYRS.strange_sequence.proceed(not jingle)
    elseif checks == AKYRS.strange_sequence.STATES.FAIL or not continuous_checks_result then
        AKYRS.strange_sequence.abort(not jingle)
    end
end


local thornringtextinputhook = G.FUNCS.text_input_key

G.FUNCS.text_input_key = function (args)
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    local text = hook_config.text
    local should_thornring = text.ref_value == 'setup_seed' or text.ref_value == 'seed'
    if ({ THORNRING = true, THORNRIN = true })[text.ref_table[text.ref_value]] and should_thornring then
        hook_config.max_length = math.max(hook_config.max_length, 9)
    else
        hook_config.max_length = 8
    end
    local x = {thornringtextinputhook(args)}
    return unpack(x)
end

local ctin_thhr = create_text_input
function create_text_input(args)
    if args and args.ref_value == 'setup_seed' or args.ref_value == 'seed' then
        args.max_length = args.max_length + 1
        local xp = {ctin_thhr(args)}
        return unpack(xp)
    end
    return ctin_thhr(args)
end

SMODS.Back{
    key = "red_hatena_deck",
    name = "Red Deck?",
    omit = true,
    config = {
        discards = 1,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.discards
            }
        }
    end
}

local startRunHook = Game.start_run
function Game:start_run(args)
    local thornringer = false
    local from_save = args.savetext
    --print(args) -- default to red deck
    if args.seed == 'THORNRING' then
        thornringer = true
    else
        if args.deck_choice then
            if args.deck_choice.name == 'Red Deck?' then
                args.deck_choice.name = 'Red Deck'
            end
        end
    end
    if thornringer then
        args = { deck_choice = { name = 'Red Deck?' }, stake_choice = args.stake_choice }
        G.viewed_sleeve = nil
    end
    --print(args) -- default to red deck
    local ret = startRunHook(self, args)
    if (thornringer) or (G.GAME.akyrs_strange_sequence) then
        G.GAME.akyrs_strange_sequence = G.GAME.akyrs_strange_sequence or 1
        G.GAME.akyrs_strange_sequence_modulate = G.GAME.akyrs_strange_sequence_modulate or 1
        AKYRS.simple_event_add(function ()
            if not from_save then
                --local card = SMODS.add_card({ key = 'j_akyrs_thornring', set = "Joker", no_edition = true })
                --card.ability.akyrs_sigma = true
                G.GAME.akyrs_forced_shop_jokers = { 'j_joker' }
                G.GAME.akyrs_forced_shop_boosters = {  }
                G.GAME.akyrs_forced_shop_vouchers = {  }
            end
            AKYRS.set_background_shaders("akyrs_aiko_gradiented_pulse") 
            G.GAME.current_round.voucher = SMODS.get_next_vouchers()
            return true
        end)
    end
    if G.GAME.selected_back.name == "Red Deck?" and not G.GAME.akyrs_strange_sequence then
        G.GAME.selected_back = Back(G.P_CENTERS.b_red)
    end
    return ret
end


local create_card_for_shop_hook = create_card_for_shop
function create_card_for_shop(area)
    if G.GAME.akyrs_forced_shop_jokers and G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers] then
        local c = G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers]

        local _center = G.P_CENTERS[c] or G.P_CENTERS.c_base

        local c1 = Card(area.T.x + area.T.w/2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, _center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        create_shop_card_ui(c1)
        if G.GAME.akyrs_strange_sequence == 1 then c1.ability.akyrs_the_jimbo = true end
        if G.GAME.akyrs_strange_sequence == 3 then 
            c1.ability.akyrs_the_thornring = true 
            local cost = 0
            AKYRS.map(G.jokers.cards, function (item, index)
                if not item.ability.akyrs_the_jimbo and not SMODS.is_eternal(item) then
                    cost = cost + item.sell_cost
                end
            end)
            AKYRS.map(G.consumeables.cards, function (item, index)
                if not item.ability.akyrs_the_jimbo and not SMODS.is_eternal(item) then
                    cost = cost + item.sell_cost
                end
            end)
            c1.cost = cost + G.GAME.dollars - G.GAME.bankrupt_at
        end
        G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers] = nil
        return c1
    end
    local card = create_card_for_shop_hook(area) 
    return card
end

local getpackhook = get_pack
function get_pack(_key, _type)
    if G.GAME.akyrs_strange_sequence == 1 then
        if G.GAME.akyrs_forced_shop_boosters and G.GAME.akyrs_forced_shop_boosters[#G.GAME.akyrs_forced_shop_boosters] then
            local c1 = G.GAME.akyrs_forced_shop_boosters[#G.GAME.akyrs_forced_shop_boosters] or 'p_arcana_normal_1'
            G.GAME.akyrs_forced_shop_boosters[#G.GAME.akyrs_forced_shop_boosters] = nil
            return G.P_CENTERS[c1]
        end
    end
    return getpackhook(_key, _type)
end

local getvouchers = SMODS.get_next_vouchers
function SMODS.get_next_vouchers(vouchers)
    if G.GAME.akyrs_strange_sequence == 1 then
        if G.GAME.akyrs_forced_shop_boosters and G.GAME.akyrs_forced_shop_vouchers[#G.GAME.akyrs_forced_shop_vouchers] then
            local ret = copy_table(G.GAME.akyrs_forced_shop_vouchers)
            local spawn = AKYRS.map(G.GAME.akyrs_forced_shop_vouchers,function (item)
                return true, item
            end, true)
            ret.spawn = spawn
            return ret
        end
    end
    return getvouchers(vouchers)
end

local cscui = create_shop_card_ui
function create_shop_card_ui(...)
    --[[
    if G.GAME.akyrs_strange_sequence == 1 then
        local card = ...
        if not strange_sequence_jokers[card.config.center.key] then
            return
        end
    end]]
    return cscui(...)
end

local gupshop = Game.update_shop
function Game.update_shop(...)
    local tt = false
    if not G.STATE_COMPLETE then
        tt = true
    end
    local x = {gupshop(...)}
    if tt then
        G.shop:get_UIE_by_ID('next_round_button').config.func = 'can_toggle_shop'
    end
    return unpack
end

local ctg_hook_just_in_case = G.FUNCS.can_toggle_shop
G.FUNCS.can_toggle_shop = function (e)
    if G.GAME.akyrs_strange_sequence == 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        if ctg_hook_just_in_case then
            ctg_hook_just_in_case(e)
        end
        e.config.colour = G.C.RED
        e.config.button = 'toggle_shop'
    end
end

local canreroll = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    if G.GAME.akyrs_strange_sequence == 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canreroll(e)
    end
end

--[[
local canbuy = G.FUNCS.can_buy
G.FUNCS.can_buy = function(e)
    local card = e.config.ref_table
    if (G.GAME.akyrs_strange_sequence == 1 and not strange_sequence_jokers[card.config.center.key]) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canbuy(e)
    end
end

local canopen = G.FUNCS.can_open
G.FUNCS.can_open = function(e)
    local card = e.config.ref_table
    if (G.GAME.akyrs_strange_sequence == 1 and not strange_sequence_jokers[card.config.center.key]) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canopen(e)
    end
end
]]
local etnerlahok = SMODS.is_eternal

function SMODS.is_eternal(card, trigger)
    if (G.GAME.akyrs_strange_sequence == 1 and strange_sequence_jokers[card.config.center.key]) then
        return true
    end
    return etnerlahok(card, trigger)
end

function AKYRS.strange_monologue()
    return AKYRS.debug_opts.monologue_music
end
