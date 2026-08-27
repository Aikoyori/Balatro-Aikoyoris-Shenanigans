--SMODS.Enhancement{
--    key = "null",
--    atlas = 'cardUpgrades',
--    pos = {x = 0, y = 0},
--    loc_txt =  	{
--        name = 'Null',
--        text = { 'No Base Chips' },
--    },
--    replace_base_card = true,
--    no_rank = true,
--    no_suit = true,
--    always_scores = true,
--    weight = 0,
--    config = {
--        bonus = 0,
--        bonus_chips = 0,
--        mult = 0,
--    }
--}


SMODS.Enhancement{
    key = "brick_card",
    atlas = 'cardUpgrades',
    pos = {x = 1, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            card.ability.extra.mult
        } }
    end,
    config = {
        extra = {
            mult = 10
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}



SMODS.Enhancement{
    key = "scoreless",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
        } }
    end,
    in_pool = function (self, args)
        return false
    end,
    never_scores = true,
    replace_base_card = false,
}


SMODS.Enhancement{
    key = "ash_card",
    atlas = 'cardUpgrades',
    pos = {x = 2, y = 0},
    loc_vars = function (self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card,1,card.ability.extras.odds,"akyrs_ash_card")
        return { vars = {
            card.ability.extras.chips,
            n,d
        } }
    end,
    config = {
        extras = {
            chips = 35,
            echips = 2,
            odds = 4
        }
    },
    in_pool = function (self, args)
        return false
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                chips = card.ability.extras.chips
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}

SMODS.Enhancement{
    key = "hatena",
    atlas = 'cardUpgrades',
    pos = {x = 3, y = 0},
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    config = {
        extras = {
            odds_d = 2,
            d = 1, 
            odds_d10 = 10,
            d10 = 10,
            nom_mults = 4,
            denom_mults = 5,
            mult_init = 6,
            xmult_retrig = 1.3
        }
    },
    loc_vars = function (self, info_queue, card)
        local n_dollar_1, d_dollar_1 = SMODS.get_probability_vars(card,1,card.ability.extras.odds_d,"akyrs_hatena_d1") -- odds of getting 1 money
        local n_dollar_10, d_dollar_10 = SMODS.get_probability_vars(card,1,card.ability.extras.odds_d10,"akyrs_hatena_d10") -- odds of getting 10 money
        local n_dollar_mult, d_dollar_mult = SMODS.get_probability_vars(card,card.ability.extras.nom_mults,card.ability.extras.denom_mults,"akyrs_hatena_mults") -- odds of getting mults
        return {
            vars = {
                n_dollar_1, d_dollar_1,card.ability.extras.d,
                n_dollar_10, d_dollar_10,card.ability.extras.d10,
                n_dollar_mult, d_dollar_mult,card.ability.extras.mult_init,card.ability.extras.xmult_retrig,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card,"akyrs_hatena_d1",1,card.ability.extras.odds_d) then
                SMODS.calculate_effect({
                    dollars = card.ability.extras.d
                }, card)
            end
            if SMODS.pseudorandom_probability(card,"akyrs_hatena_d10",1,card.ability.extras.odds_d10) then
                SMODS.calculate_effect({
                    dollars = card.ability.extras.d10
                }, card)
            end
            if SMODS.pseudorandom_probability(card,"akyrs_hatena_mults",card.ability.extras.nom_mults,card.ability.extras.denom_mults) then
                if card.akyrs_triggered then
                    return {
                        xmult = card.ability.extras.xmult_retrig
                    }
                else
                    return {
                        mult = card.ability.extras.mult_init,
                        func = function()
                            card.akyrs_triggered = true
                        end
                    }
                end
            end
        end
        if context.final_scoring_step then
            return {
                func = function()
                    card.akyrs_triggered = nil
                end
            }
        end
    end
}


SMODS.Enhancement{
    key = "item_box",
    atlas = 'cardUpgrades',
    pos = {x = 4, y = 0},
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
    config = {
        extras = {
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                message = localize("k_akyrs_item_box_trigger"),
                func = function ()
                    AKYRS.simple_event_add(
                        function ()
                            --[[
                            -- this is just me being stupid
                            if AKYRS.has_room(G.consumeables) then
                                card.ability.akyrs_triggered = true
                                local k, lim = nil, 0
                                repeat
                                    lim = lim + 1
                                    k = pseudorandom_element(G.P_CENTER_POOLS.Consumeables,pseudoseed("akyrs_item_box_consumable_pick"))
                                until (not k.hidden and (not k.in_pool or k:in_pool({})) and not G.GAME.banned_keys[k.key]) or lim >= #G.P_CENTER_POOLS.Consumeables
                                if not lim >= #G.P_CENTER_POOLS.Consumeables then
                                    SMODS.add_card{key = k.key}
                                end
                            end
                            ]]
                            if AKYRS.has_room(G.consumeables) then
                                SMODS.add_card{set = "Consumeables", area = G.consumeables}
                            end
                            card.ability.akyrs_triggered = true
                            return true
                        end, 0
                    )
                end
            }
        end
    end
}



SMODS.Enhancement{
    key = "insolate_card",
    atlas = 'cardUpgrades',
    pos = {x = 5, y = 0},
    config = {
        extras = {
            xmult = 1,
            xmult_add = 0.1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult_add,
                card.ability.extras.xmult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before and context.cardarea == G.play then
            return {
                func = function ()
                    local r = AKYRS.get_enhancements_freq_from_cards(G.play.cards)
                    local s = true
                    for k,v in pairs(r) do
                        if v > 1 then
                            s = false
                            break
                        end
                    end
                    if s then
                        SMODS.calculate_effect({
                            message = localize("k_upgrade_ex"),
                            func = function ()
                                card.ability.extras.xmult = card.ability.extras.xmult + card.ability.extras.xmult_add
                            end
                        }, card)
                    end
                end
            }
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end
}

SMODS.Enhancement{
    key = "canopy_card",
    atlas = 'cardUpgrades',
    config = {
        extras = {
            akyrs_can_downrank = true
        }
    },
    pos = {x = 9, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extras.akyrs_can_downrank and "k_akyrs_canopy_downable_yes" or "k_akyrs_canopy_downable_no"),
                colours = {
                    card.ability.extras.akyrs_can_downrank and G.C.GREEN or G.C.UI.TEXT_INACTIVE,
                    card.ability.extras.akyrs_can_downrank and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_DARK,
                }
            }
        }
    end,
    calculate = function (self, card, context)
        if context.after then
            return {
                func = function ()
                    card.ability.extras.akyrs_can_downrank = true
                end
            }
        end
    end
}
SMODS.Enhancement{
    key = "thai_tea_card",
    atlas = 'cardUpgrades',
    pos = {x = 7, y = 0},
    config = {
        extras = {
            xmult = 1.6,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end
}
SMODS.Enhancement{
    key = "matcha_card",
    atlas = 'cardUpgrades',
    pos = {x = 8, y = 0},
    config = {
        extras = {
            xscore = 1.5,
            xblind = 1.1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xscore,
                card.ability.extras.xblind,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xscore = card.ability.extras.xscore,
                xblindsize = card.ability.extras.xblind,
            }
        end
    end
}
SMODS.Enhancement{
    key = "earl_grey_tea_card",
    atlas = 'cardUpgrades',
    pos = {x = 9, y = 0},
    config = {
        extras = {
            dollars = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.dollars
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == 'unscored' then
            return {
                dollars = card.ability.extras.dollars
            }
        end
    end
}

SMODS.Enhancement{
    key = "net_card",
    atlas = 'cardUpgrades',
    pos = {x = 1, y = 1},
    config = {
        extras = {
            xmult = 0.5,
        },
        h_dollars = 8
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult,
                SMODS.signed_dollars(card.ability.h_dollars),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.hand then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end
}

SMODS.Enhancement{
    key = "droplet_card",
    atlas = 'cardUpgrades',
    pos = {x = 2, y = 1},
    config = {
        extras = {
            n = 1,
            d = 3,
            discard = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card,card.ability.extras.n,card.ability.extras.d,"akyrs_droplet")
        return {
            vars = {
                n,d,
                card.ability.extras.discard,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.discard and context.other_card == card then
            return {
                func = function ()
                    local success = SMODS.pseudorandom_probability(card,"akyrs_droplet",card.ability.extras.n,card.ability.extras.d)
                    if success then
                        ease_discard(card.ability.extras.discard)
                        SMODS.calculate_effect({
                            localize("k_akyrs_gain_discard")
                        })
                    end
                end,
            }
        end
    end
}


SMODS.Enhancement{
    key = "zap_card",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 1},
    config = {
        extras = {
            trigger_triggered = 0,
            trigger_needed = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.trigger_needed,
                card.ability.extras.trigger_triggered
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                func = function ()
                    card.ability.extras.trigger_triggered = (card.ability.extras.trigger_triggered or 0) + 1
                    if card.ability.extras.trigger_triggered >= card.ability.extras.trigger_needed then
                        local times = card.ability.extras.trigger_triggered / card.ability.extras.trigger_needed
                        local remainder = card.ability.extras.trigger_triggered - (card.ability.extras.trigger_needed * math.floor(times))
                        
                        card.ability.extras.trigger_triggered = remainder
                        for i = 1, times do
                            SMODS.calculate_effect({
                                message = localize("k_duplicated_ex"),
                                func = function ()
                                    AKYRS.simple_event_add(
                                        function ()
                                            local c2 = AKYRS.copy_p_card(card,nil,nil,nil,nil,G.hand)
                                            c2:set_ability(G.P_CENTERS.c_base)
                                            SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
                                            return true
                                        end
                                    )
                                end
                            }, card)
                        end
                    end
                end,
                message = localize("k_upgrade_ex")
            }
        end
    end
}


SMODS.Enhancement{
    key = "semibreve_card",
    atlas = 'cardUpgrades',
    pos = {x = 3, y = 1},
    config = {
        bonus = 10,
        mult = 3,
    },
    akyrs_note_card = {
        weight = 8
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.bonus,
                card.ability.mult,
            }
        }
    end,
}


SMODS.Enhancement{
    key = "minim_card",
    atlas = 'cardUpgrades',
    pos = {x = 4, y = 1},
    config = {
        extras = {
            bonus_X_chips = 1.2,
            mult = 5,
        }
    },
    akyrs_note_card = {
        weight = 3
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.bonus_X_chips,
                card.ability.extras.mult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xchips = card.ability.extras.bonus_X_chips,
                mult = card.ability.extras.mult,
            }
        end
    end
}

SMODS.Enhancement{
    key = "crotchet_card",
    atlas = 'cardUpgrades',
    pos = {x = 5, y = 1},
    config = {
        extras = {
            bonus_X_chips = 1.42,
            bonus_X_mult = 1.67,
        }
    },
    akyrs_note_card = {
        weight = 1
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.bonus_X_chips,
                card.ability.extras.bonus_X_mult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.extras.bonus_X_mult,
            }
        end
        if context.main_scoring and context.cardarea == G.hand then
            return {
                xchips = card.ability.extras.bonus_X_chips,
            }
        end
    end
}

SMODS.Enhancement{
    key = "wafer_card",
    atlas = 'cardUpgrades',
    pos = {x = 6, y = 1},
    config = {
        extras = {
            xscore = 2.5,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xscore,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            return {
                xscore = card.ability.extras.xscore,
            }
        end
    end
}

SMODS.Enhancement{
    key = "shore_card",
    atlas = 'cardUpgrades',
    pos = {x = 7, y = 1},
    config = {
        extras = {
            xmult = 1.4,
            xmult_gain = 0.3,
            xmult_gain_cumulative = 0,
            destroy_chance_n = 1,
            destroy_chance_d = 3,
            spread_chance_n = 1,
            spread_chance_d = 1.5,
        }
    },
    loc_vars = function (self, info_queue, card)
        local n1, d1 = SMODS.get_probability_vars(card,card.ability.extras.destroy_chance_n,card.ability.extras.destroy_chance_d, "akyrs_nightshade_card_break")
        local n2, d2 = SMODS.get_probability_vars(card,card.ability.extras.spread_chance_n,card.ability.extras.spread_chance_d, "akyrs_nightshade_card_spread")
        return {
            vars = {
                card.ability.extras.xmult,
                card.ability.extras.xmult_gain,
                n1,d1,
                n2,d2,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and
            SMODS.pseudorandom_probability(card, 'akyrs_nightshade_card_break', card.ability.extras.destroy_chance_n,card.ability.extras.destroy_chance_d) then
                if SMODS.pseudorandom_probability(card, 'akyrs_nightshade_card_spread', card.ability.extras.spread_chance_n,card.ability.extras.spread_chance_d) then
                    SMODS.calculate_effect({
                        func = function()
                            local cd_target = pseudorandom_element(G.hand.cards, 'akyrs_nightshade_card_spread_pick')
                            if cd_target then
                                AKYRS.simple_event_add(function ()
                                    cd_target:set_ability(G.P_CENTERS.m_akyrs_shore_card)
                                    cd_target.ability.extras.xmult_gain_cumulative = card.ability.extras.xmult_gain_cumulative
                                    SMODS.scale_card(cd_target, {
                                        ref_table = cd_target.ability.extras,
                                        ref_value = "xmult_gain_cumulative",
                                        scalar_value = "xmult_gain",
                                        no_message = true,
                                    })
                                    SMODS.scale_card(cd_target, {
                                        ref_table = cd_target.ability.extras,
                                        ref_value = "xmult",
                                        scalar_value = "xmult_gain_cumulative",
                                    })
                                    return true
                                end, 0)
                            end
                        end
                    }, card)
                end
            return { remove = true }
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end
}

SMODS.Enhancement{
    key = "cloud_card",
    atlas = 'cardUpgrades',
    pos = {x = 8, y = 1},
    config = {
        extras = {
            dollars = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.dollars * (AKYRS.is_scenario_active("sc_akyrs_cloudy") and 3 or 1))
            }
        }
    end,
    calculate = function (self, card, context)
    end
}

SMODS.Enhancement{
    key = "nightshade_card",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 2},
    config = {
        extras = {
            must_be_played_immediately = false,
            xchips = 2.5,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xchips
            }
        }
    end,
    calculate = function (self, card, context)
        if context.hand_drawn and card.area == G.hand then
            if card.ability.extras.must_be_played_immediately then
                return {
                    func = function ()
                        card:set_debuff(true)
                    end
                }
                else
                    card.ability.extras.must_be_played_immediately = true
                end
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                xchips = card.ability.extras.xchips
            }
        end
    end
}

SMODS.Enhancement{
    key = "tap_card",
    atlas = 'cardUpgrades',
    pos = {x = 1, y = 2},
    config = {
        extras = {
            xblindsize = 0.94
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xblindsize
            },
            key = AKYRS.is_life_enabled() and self.key.."_life" or self.key
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xblindsize = card.ability.extras.xblindsize
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}
