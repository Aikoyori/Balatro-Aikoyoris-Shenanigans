local strange_route_jokers = { j_joker = true, j_akyrs_thornring = true }

local thornringtextinputhook = G.FUNCS.text_input_key

G.FUNCS.text_input_key = function (args)
    local hook_config = G.CONTROLLER.text_input_hook.config.ref_table
    local text = hook_config.text
    local should_thornring = text.ref_value == 'setup_seed' or text.ref_value == 'seed'
    if ({ THORNRING = true, THORNRIN = true })[text.ref_table[text.ref_value]] and should_thornring then
        hook_config.max_length = 9
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


local startRunHook = Game.start_run
function Game:start_run(args)
    local thornringer = false
    local from_save = args.savetext
    if args.seed == 'THORNRING' then
        args.seed = nil
        thornringer = true
    end
    local ret = startRunHook(self, args)
    if (thornringer) or (G.GAME.akyrs_strange_sequence) then
        G.GAME.akyrs_strange_sequence = 1
        AKYRS.simple_event_add(function ()
            if not from_save then
                --local card = SMODS.add_card({ key = 'j_akyrs_thornring', set = "Joker", no_edition = true })
                --card.ability.akyrs_sigma = true
                G.GAME.akyrs_forced_shop_jokers = { 'j_akyrs_thornring','j_joker' }
                G.GAME.akyrs_forced_shop_boosters = { 'p_spectral_mega_1', 'p_spectral_mega_1' }
                G.GAME.akyrs_forced_shop_vouchers = { 'v_akyrs_banquet' }
            end
            AKYRS.set_background_shaders("akyrs_aiko_gradiented_pulse") 
            G.GAME.current_round.voucher = SMODS.get_next_vouchers()
            return true
        end)
    end
    return ret
end


local create_card_for_shop_hook = create_card_for_shop
function create_card_for_shop(area)
    if G.GAME.akyrs_strange_sequence == 1 then
        if G.GAME.akyrs_forced_shop_jokers and G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers] then
            local c = G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers]

            local _center = G.P_CENTERS[c] or G.P_CENTERS.c_base

            local c1 = Card(area.T.x + area.T.w/2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, _center, {bypass_discovery_center = true, bypass_discovery_ui = true})
            if strange_route_jokers[c] then
                create_shop_card_ui(c1)
            end
            G.GAME.akyrs_forced_shop_jokers[#G.GAME.akyrs_forced_shop_jokers] = nil
            return c1
        end
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
    if G.GAME.akyrs_strange_sequence == 1 then
        local card = ...
        if not strange_route_jokers[card.config.center.key] then
            return
        end
    end
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
    if G.GAME.akyrs_strange_sequence == 1 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        if ctg_hook_just_in_case then
            ctg_hook_just_in_case(e)
            e.config.colour = G.C.RED
            e.config.button = 'toggle_shop'
        end
    end
end

local canreroll = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    if G.GAME.akyrs_strange_sequence == 1 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canreroll(e)
    end
end

local canbuy = G.FUNCS.can_buy
G.FUNCS.can_buy = function(e)
    local card = e.config.ref_table
    if (G.GAME.akyrs_strange_sequence == 1 and not strange_route_jokers[card.config.center.key]) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canbuy(e)
    end
end

local canopen = G.FUNCS.can_open
G.FUNCS.can_open = function(e)
    local card = e.config.ref_table
    if (G.GAME.akyrs_strange_sequence == 1 and not strange_route_jokers[card.config.center.key]) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        return canopen(e)
    end
end

local etnerlahok = SMODS.is_eternal

function SMODS.is_eternal(card, trigger)
    if (G.GAME.akyrs_strange_sequence == 1 and strange_route_jokers[card.config.center.key]) then
        return true
    end
    return etnerlahok(card, trigger)
end

function AKYRS.strange_monologue()
    return AKYRS.debug_opts.monologue_music
end