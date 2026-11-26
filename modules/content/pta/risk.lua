SMODS.ConsumableType{
    key = "Risk",
    primary_colour = HEX("ffa661"),
    secondary_colour = HEX("7b194e"),
    collection_rows = { 5, 5 },
    shop_rate = 1,
    default = "c_akyrs_umbral_break_up"
}

SMODS.UndiscoveredSprite{
    key = "Risk",
    atlas = "ptaRisk",
    pos = { x=8, y=2 }
}

---@class AKYRS.PTA.Risk: SMODS.Consumable
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, risk: table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://docs.smods.dev/API%20Documentation/Localization#loc_vars) documentation for return value details. 
---@field risk_calculate? fun(self: SMODS.Center|table, risk: table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://docs.smods.dev/API%20Documentation/Calculate-Functions) docs for details. 
---@field risk_difficulty? number determines reward for the pack
---@overload fun(self: AKYRS.PTA.Risk): AKYRS.PTA.Risk
AKYRS.PTA.Risk = SMODS.Consumable:extend {
    set = 'Risk',
    atlas = "ptaRisk",
    inject = function (self, i)
        self.use = AKYRS.PTA.risk_card_use
        local old_can_use = self.can_use
        self.can_use = function (self, card)
            if G.GAME.blind.in_blind and G.GAME.blind.boss then
                return false
            end
            if old_can_use then
                return old_can_use(self, card)
            end
            return true
        end,
        SMODS.Consumable.inject(self, i)
    end,
    risk_difficulty = 1,
}

---@type fun(self: SMODS.Consumable|table, card: Card|table, area: CardArea|table, copier?: table)
AKYRS.PTA.risk_card_use = function (self, card, area, copier)
    -- makes a risk "object"
    G.GAME.akyrs_risk_used[#G.GAME.akyrs_risk_used+1] = {
        key = self.key,
        ability = copy_table(card.ability), -- mostly for value manip reasons
    }
end

-- reminder that these only get calculate on boss blinds

AKYRS.PTA.Risk{
    key = "risk_hinder",
    atlas = "ptaRisk",
    pos = {x=0,y=0},
    config = {
        extras = {
            cards_x = 10,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.cards_x
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    local cards_target = AKYRS.pseudorandom_elements(
                    AKYRS.filter_table(G.playing_cards, function (item, index)
                        return not item.ability.akyrs_debuffed_by_risk_hinder and not item.debuff
                    end, true, true), risk.ability.extras.cards_x, 'akyrs_risk_hinder_pick')
                    AKYRS.map(cards_target, function (item, index)
                        item.ability.akyrs_debuffed_by_risk_hinder = true
                        item:set_debuff(true)
                    end, true)
                end
            }
        end
        if context.debuff_card and context.debuff_card.ability.akyrs_debuffed_by_risk_hinder then
            return {
                debuff = true
            }
        end
    end,
}

AKYRS.PTA.Risk{
    key = "risk_hinder",
    atlas = "ptaRisk",
    pos = {x=0,y=0},
    config = {
        extras = {
            cards_x = 10,
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                card.ability.extras.cards_x
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    local cards_target = AKYRS.pseudorandom_elements(
                    AKYRS.filter_table(G.playing_cards, function (item, index)
                        return not item.ability.akyrs_debuffed_by_risk_hinder and not item.debuff
                    end, true, true), risk.ability.extras.cards_x, 'akyrs_risk_hinder_pick')
                    AKYRS.map(cards_target, function (item, index)
                        item.ability.akyrs_debuffed_by_risk_hinder = true
                        item:set_debuff(true)
                    end, true)
                end
            }
        end
        if context.debuff_card and context.debuff_card.ability.akyrs_debuffed_by_risk_hinder then
            return {
                debuff = true
            }
        end
    end,
}

AKYRS.PTA.Risk{
    key = "risk_hollow",
    atlas = "ptaRisk",
    pos = {x=1,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    local cards_target = (G.consumeables.cards or {})
                    AKYRS.map(cards_target, function (item, index)
                        item:set_debuff(true)
                    end, true)
                end
            }
        end
    end,
}

AKYRS.PTA.Risk{
    key = "risk_leak",
    atlas = "ptaRisk",
    pos = {x=2,y=0},
    config = {
        extras = {
            lose = 1
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                SMODS.signed_dollars(risk.ability.extras.lose),
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.individual and context.cardarea == G.play then
            return {
                dollars = -risk.ability.extras.lose
            }
        end
    end,
}

AKYRS.PTA.Risk{
    key = "risk_shrink",
    atlas = "ptaRisk",
    pos = {x=3,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
}

AKYRS.PTA.Risk{
    key = "risk_synthesis",
    atlas = "ptaRisk",
    pos = {x=4,y=0},
    config = {
        extras = {
            create = 7,
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                risk.ability.extras.create
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    for i = 1, risk.ability.extras.create do
                        AKYRS.simple_event_add(function ()
                            local c = SMODS.add_card { area = G.play, set = 'Base' }
                            AKYRS.simple_event_add(function ()
                                draw_card(G.play, G.deck)
                                return true
                            end)
                            return true
                        end)
                    end
                end
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_burden",
    atlas = "ptaRisk",
    pos = {x=5,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    AKYRS.simple_event_add(function ()
                        local cd = pseudorandom_element(AKYRS.filter_table(G.jokers.cards, function (item, index)
                            return not item.ability.eternal
                        end, true, true), 'akyrs_risk_burden_pick')
                        if cd then
                            AKYRS.do_things_to_card({cd}, function (_card, index)
                                SMODS.Stickers.eternal:apply(_card, true)
                            end)
                        end
                        return true
                    end)
                end
            }
        end
    end
}
AKYRS.PTA.Risk{
    key = "risk_ethereal",
    atlas = "ptaRisk",
    pos = {x=6,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    AKYRS.simple_event_add(function ()
                        local cd = pseudorandom_element(AKYRS.filter_table(G.jokers.cards, function (item, index)
                            return not item.ability.perishable
                        end, true, true), 'akyrs_risk_ethereal_pick')
                        if cd then
                            AKYRS.do_things_to_card({cd}, function (_card, index)
                                SMODS.Stickers.perishable:apply(_card, true)
                            end)
                        end
                        return true
                    end)
                end
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_cyclone",
    atlas = "ptaRisk",
    pos = {x=7,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.akyrs_pre_play then
            return {
                func = function ()
                    local hcard = #G.hand.cards
                    if hcard > 0 then
                        for i = hcard, 1, -1 do
                            AKYRS.simple_event_add(function ()
                                local drawn_c = G.hand:remove_card()
                                if not drawn_c or drawn_c.highlighted then return true end
                                G.deck:emplace(drawn_c)
                                play_sound('card1')
                                return true
                            end, 0.1)
                        end
                        local dcard = #G.discard.cards
                        for i = dcard, 1, -1 do
                            AKYRS.simple_event_add(function ()
                                local drawn_c = G.discard:remove_card()
                                if not drawn_c then return true end
                                G.deck:emplace(drawn_c)
                                play_sound('card1')
                                return true
                            end, 0.1)
                        end
                        AKYRS.simple_event_add(function ()
                            G.deck:shuffle("akyrs_risk_cyclone_shuffle")
                            return true
                        end, 1)
                    end
                end
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_perpetuate",
    atlas = "ptaRisk",
    pos = {x=8,y=0},
    config = {
        extras = {
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.hand_drawn then
            return {
                func = function ()
                    local hcard = #G.discard.cards
                    if hcard > 0 then
                        for i = hcard, 1, -1 do
                            AKYRS.simple_event_add(function ()
                                local drawn_c = G.discard:remove_card()
                                if not drawn_c or drawn_c.highlighted then return true end
                                G.deck:emplace(drawn_c, #G.deck.cards)
                                play_sound('card1')
                                return true
                            end, 0.1)
                        end
                    end
                end
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_crime",
    atlas = "ptaRisk",
    pos = {x=0,y=1},
    config = {
        extras = {
            hz = 1
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                -risk.ability.extras.hz
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    G.hand:change_size(-risk.ability.extras.hz)
                end
            }
        end
        if context.end_of_round and context.main_eval then
            return {
                func = function ()
                    G.hand:change_size(risk.ability.extras.hz)
                end
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_double_down",
    atlas = "ptaRisk",
    pos = {x=1,y=1},
    config = {
        extras = {
            blsz = 2
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                risk.ability.extras.blsz
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                xblindsize = risk.ability.extras.blsz
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_eclipse",
    atlas = "ptaRisk",
    pos = {x=2,y=1},
    config = {
        extras = {
            lvl = 1
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                -risk.ability.extras.lvl
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
        if context.before then
            table.sort( G.hand.highlighted, AKYRS.hand_sort_function )
            local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            return {
                level_up = -risk.ability.extras.lvl,
            }
        end
    end
}

AKYRS.PTA.Risk{
    key = "risk_stunted",
    atlas = "ptaRisk",
    pos = {x=3,y=1},
    config = {
        extras = {
            n = 1,
            d = 2
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        local n, d = SMODS.get_probability_vars(risk, risk.ability.extras.n, risk.ability.extras.d, 'akyrs_risk_stunted_odds')
        return {
            vars = {
                n , d
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
    end
}

AKYRS.PTA.Risk{
    key = "risk_backfire",
    atlas = "ptaRisk",
    pos = {x=4,y=1},
    config = {
        extras = {
            n = 1,
            d = 2
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        local n, d = SMODS.get_probability_vars(risk, risk.ability.extras.n, risk.ability.extras.d, 'akyrs_risk_backfire_odds')
        return {
            vars = {
                n , d
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
    end
}

AKYRS.PTA.Risk{
    key = "risk_elusive",
    atlas = "ptaRisk",
    pos = {x=5,y=1},
    config = {
        extras = {
            triggered = 0,
            facedown = 1,
        }
    },
    akyrs_originally_from_pta = true,
    loc_vars = function (self, info_queue, risk)
        return {
            vars = {
                
            }
        }
    end,
    risk_difficulty = 2,
    risk_calculate = function (self, risk, context)
        if context.stay_flipped then
            if context.other_card and context.from_area == G.deck and context.to_area == G.hand then
                risk.ability.extras.triggered = (risk.ability.extras.triggered or 0) + 1
                if (risk.ability.extras.triggered <= risk.ability.extras.facedown) then
                    return {
                        stay_flipped = true
                    }
                end
            end
        end
        if context.hand_drawn then
            risk.ability.extras.triggered = 0
        end
        if context.after then
            return {
                func = function ()
                    AKYRS.map(G.hand.cards, function (car, index)
                        AKYRS.simple_event_add(function ()
                            car:flip()
                            return true
                        end)
                    end, true)
                end
            }
        end
    end
}