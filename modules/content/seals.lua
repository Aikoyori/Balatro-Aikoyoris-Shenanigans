SMODS.Seal{
    key = "carmine",
    atlas = 'aikoyoriStickers',
    pos = {x = 1, y = 0},
    badge_colour = HEX('4a3b3b'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },

    calculate = function(self, card, context)

    end,
}

SMODS.Seal{
    key = "neon",
    atlas = 'aikoyoriStickers',
    pos = {x = 5, y = 1},
    badge_colour = HEX('5bbee0'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },
    loc_vars =function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies['dd_akyrs_neon_seal_ex']
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == "unscored" then
            return {
                func = function ()
                    if AKYRS.has_room(G.consumeables) then
                        SMODS.calculate_effect({
                            message = localize("k_akyrs_plus_umbral"),
                        }, card)
                        AKYRS.simple_event_add(function ()
                            SMODS.add_card{ set = "Umbral" }
                            h[index]:juice_up(0.5,0.5)
                            return true
                        end, 0)
                    end
                end,
            }
        end
    end,
}


SMODS.Seal{
    key = "twin",
    atlas = 'aikoyoriStickers',
    pos = {x = 6, y = 1},
    badge_colour = HEX('ff84a8'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },

    calculate = function(self, card, context)
        if context.main_scoring and G.jokers and G.jokers.cards and context.area == G.play then
            local copyable = AKYRS.filter_table(G.jokers.cards, function (item)
                return item.config.center and item.config.center.blueprint_compat
            end, true, true)
            local joker = pseudorandom_element(copyable, "akyrs_twin_seal_select_jonkler")
            if joker then
                AKYRS.simple_event_add(function ()
                    joker:juice_up(0.5,0.5)
                    return true
                end, 0)
                local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                local ctx = {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true}
                local x = SMODS.blueprint_effect(card, joker, ctx)
                return x
            end
        end
    end,
}



SMODS.Seal{
    key = "fault",
    atlas = 'aikoyoriStickers',
    pos = {x = 7, y = 1},
    badge_colour = HEX('b7f058'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },
    loc_vars = function (self, info_queue, card)
        local t = ((G.hand or {}).highlighted or {})
        if G.STATE == G.STATES.HAND_PLAYED then
            t = G.play.cards
        end
        local s = AKYRS.filter_table(t, function (item)
                return item.seal ~= nil
        end, true, true)
        local n, d = SMODS.get_probability_vars(card, 1, #s * #s, "akyrs_fault_seal")
        return {
            vars = {
                #s == #t and #t > 0 and n or 0,
                math.max(d, 0),
                #s
            }
        }
    end,
    calculate = function(self, card, context)
        if context.repetition then
            local p = AKYRS.filter_table(G.play.cards, function (item)
                return item.seal ~= nil
            end, true, true)
            if #p == #G.play.cards and #p > 0 then
                local roll = SMODS.pseudorandom_probability(card, "akyrs_fault_seal", 1, #p * #p) 
                if roll then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = #p,
                    }
                end
            end

        end
    end,
}



SMODS.Seal{
    key = "deformed",
    atlas = 'aikoyoriStickers',
    pos = {x = 8, y = 1},
    badge_colour = HEX('c76d71'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "akyrs_self_destructs"}
    end,
    calculate = function(self, card, context)
        if context.press_play and card.area == G.hand and AKYRS.find_index(G.hand.highlighted, card) then
            return {
                func = function()
                    AKYRS.simple_event_add(function() 
                        local c = AKYRS.copy_p_card(card, nil, nil, nil, nil, G.play)
                        c:add_sticker('akyrs_self_destructs', true)
                        return true
                    end, 0)
                end
            }
        end
    end,
}

