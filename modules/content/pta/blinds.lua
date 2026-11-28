
AKYRS.PTA.CastBlind = SMODS.Blind:extend {
    dollars = 6,
    mult = 2,
    atlas = 'akyrs_ptaBlinds',
    boss_colour = HEX("4f6367"), 
    pos = { x = 0, y = 1 },
    boss = { min = 0, },
    in_pool = function (self)
        return false
    end,
    akyrs_cast_blinds = true,
    config = {
    },
    debuff = {
        akyrs_cannot_be_overridden = true,
        akyrs_cannot_be_rerolled = true
    },
    set_blind = function (self)
        local most_mult = 0
        for _, blind_key in ipairs(G.GAME.akyrs_pta_cast_blinds) do
            G.akyrs_additional_blinds = G.akyrs_additional_blinds or {}
            local bl = Blind(0,0,2,1)
            local blind = G.P_BLINDS[blind_key]
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            G.GAME.blind.akyrs_casted_blind = true
            bl:set_blind(blind, nil, true)
            most_mult = math.max(most_mult, blind.mult or 1)
            G.GAME.blind = ogbl
            G.GAME.blind.effect = SMODS.merge_defaults(type(blind.config) == "table" and copy_table(blind.config) or {}, G.GAME.blind.effect)
            G.GAME.blind.debuff = SMODS.merge_defaults(type(blind.debuff) == "table" and copy_table(blind.debuff) or {}, G.GAME.blind.debuff)
            G.akyrs_additional_blinds[#G.akyrs_additional_blinds+1] = bl
        end
        G.GAME.blind.chips = AKYRS.get_true_original_blind_amount(most_mult)
    end,
    disable = function (self)
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            bl:disable()
        end, true)
    end,
    defeat = function (self)
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            bl:defeat()
        end, true)
    end,
    stay_flipped = function (self, area, card)
        local x = false
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            x = x or bl:stay_flipped(area, card)
            G.GAME.blind = ogbl
        end, true)
        return x
    end,
    debuff_hand = function (self, cards, hand, handname, check)
        local x = false
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            x = x or bl:debuff_hand(cards, hand, handname, check)
            G.GAME.blind = ogbl
        end, true)
        return x
    end,
    modify_hand = function (self, cards, poker_hands, text, mult, hand_chips)
        local ch, ml, modded = mult, hand_chips, false
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            local ch2, m2, modded2 = bl:modify_hand(cards, poker_hands, text, ml, ch, scoring_hand)
            if modded2 then
                modded = true
                ch, ml = ch2, m2
            end
            G.GAME.blind = ogbl
        end, true)
        return ch, ml, modded
    end,
    recalc_debuff = function (self, card, from_blind)
        local x = false
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            bl:debuff_card(card, from_blind)
            x = x or card.debuffed_by_blind
            G.GAME.blind = ogbl
        end, true)
        return x
    end,
    drawn_to_hand = function (self, cards, hand, handname, check)
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            bl:drawn_to_hand()
            G.GAME.blind = ogbl
        end, true)
    end,
    press_play = function (self)
        AKYRS.map(G.akyrs_additional_blinds, function (bl, i)
            local ogbl = G.GAME.blind
            G.GAME.blind = bl
            bl:press_play()
            G.GAME.blind = ogbl
        end, true)
    end,
    calculate = function (self, blind, context)
        -- this whole mess was to fix debuffing not working in calculate. tested on paperback lol
        local calc_results = AKYRS.map( AKYRS.filter_table(G.akyrs_additional_blinds, function (bl, i)
            return bl.config.blind.calculate
                end, true, true), function (bl, i)
            if bl then
                local ogbl = G.GAME.blind
                G.GAME.blind = bl
                local y = { bl.config.blind:calculate(bl, context) }
                G.GAME.blind = ogbl
                return unpack(y)
            end
        end, true)
        if #calc_results > 0 then
            local calc_return = {}
            for _, acalctable in ipairs(calc_results) do
                for calc_key, calcvalue in pairs(acalctable) do
                    if type(calcvalue) == 'boolean' or (type(calcvalue) == 'table' and calcvalue.is and Card.is(calcvalue)) then
                        calc_return[calc_key] = calcvalue
                        acalctable[calc_key] = nil
                    end
                end
            end
            --print(calc_return)
            --print(calc_results)
            calc_return.extras = SMODS.merge_effects(calc_results)
            return calc_return
        end
    end
}

AKYRS.PTA.CastBlind{
    key = "pta_the_cast",
    pos = { x = 0, y = 1 },
    in_pool = function (self)
        return false
    end,
}
AKYRS.PTA.CastBlind{
    key = "pta_final_catastrophic_cast",
    boss = {
        showdown = true,
        min = 1
    },
    pos = { x = 0, y = 10 },
    in_pool = function (self)
        return false
    end,
}