
SMODS.Joker {
    key = "john",
    atlas = 'aikoSlop',
    pos = { x = 0, y = 0 },
    pools = {  },
    config = {
        extras = {
            mult = 2,
            chips = 80,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            set = "SlopJoker",
            vars = {
                card.ability.extras.mult,
                card.ability.extras.chips,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.joker_main then
            if context.scoring_name == "High Card" then
                return {
                    chips = card.ability.extras.chips,
                }
            else
                return {
                    mult = card.ability.extras.mult,
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "sixseven",
    atlas = 'aikoSlop',
    pos = { x = 1, y = 0 },
    pools = {  },
    config = {
        extras = {
            xmult = 6.7,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            set = "SlopJoker",
            vars = {
                card.ability.extras.xmult,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.joker_main then
            local should_give = true
            local cds = AKYRS.map(G.GAME.current_round.aiko_played_ranks, function (item, key)
                if key ~= 6 and key ~= 7 then should_give = false end
            end)
            if should_give and G.GAME.current_round.aiko_played_ranks[6] and G.GAME.current_round.aiko_played_ranks[7] then
                return {
                    xmult = card.ability.extras.xmult,
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "upside_down",
    atlas = 'aikoSlop',
    pos = { x = 2, y = 0 },
    pools = {  },
    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            set = "SlopJoker",
            vars = {
                card.ability.extras.xmult,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.post_trigger and context.other_card and not context.other_context.end_of_round then
            return {
                swap = true,
            }
        end
    end,
}

SMODS.Joker {
    key = "elephant",
    atlas = 'aikoSlop',
    pos = { x = 3, y = 0 },
    pools = {  },
    config = {
        extras = {
            jkr = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            set = "SlopJoker",
            vars = {
                card.ability.extras.jkr,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    set_ability = function (self, card, initial, delay_sprites)
        if initial then card:add_sticker('eternal', true) end
    end,
    calculate = function (self, card, context)
        if context.selling_self then
            return {
                func = function ()
                    for i = 1, card.ability.extras.jkr do
                        if AKYRS.has_room(G.jokers) then
                            SMODS.add_card{ set = 'Joker', rarity = 'Common' }
                        end
                    end
                end
            }
        end
        if context.end_of_round and context.main_eval then
            return {
                func = function ()
                    card.ability.eternal = false
                end
            }
        end
    end,
}

SMODS.Joker {
    key = "walker",
    atlas = 'aikoSlop',
    pos = { x = 4, y = 0 },
    pools = {  },
    config = {
        extras = {
            chips = 0,
            chips_g = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            set = "SlopJoker",
            vars = {
                card.ability.extras.chips,
                card.ability.extras.chips_g,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.before and not next(context.poker_hands['Straight']) then
            return {
                func = function ()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extras,
                        ref_value = 'chips',
                        scalar_value = 'chips_g',
                    })
                end
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extras.chips
            }
        end
    end,
}

SMODS.Joker {
    key = "fortunate_son",
    atlas = 'aikoSlop',
    pos = { x = 5, y = 0 },
    pools = {  },
    config = {
        extras = {

        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
        return {
            set = "SlopJoker",
            vars = {
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.fix_probability and context.trigger_obj and context.trigger_obj.config.center.key == 'c_wheel_of_fortune' then
            return {
                numerator = context.denominator
            }
        end
    end,
}

SMODS.Joker {
    key = "gambler",
    atlas = 'aikoSlop',
    pos = { x = 6, y = 0 },
    pools = {  },
    config = {
        extras = {
            num = 1, denom = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
        local n1, d1 = SMODS.get_probability_vars(card, card.ability.extras.num, card.ability.extras.denom, 'akyrs_slop_gambler' )
        return {
            set = "SlopJoker",
            vars = {
                n1, d1,
            }
        }
    end,
    rarity = 'akyrs_slop',
    cost = 2,
    calculate = function (self, card, context)
        if context.setting_blind then
            return {
                func = function ()
                    AKYRS.simple_event_add(function ()
                        if AKYRS.has_room(G.consumeables) then
                            if SMODS.pseudorandom_probability(card, 'akyrs_slop_gambler', card.ability.extras.num, card.ability.extras.denom ) then
                                SMODS.calculate_effect({
                                    message = localize("k_plus_tarot"),
                                    func = function ()
                                        SMODS.add_card{ key = 'c_wheel_of_fortune' }
                                    end
                                }, card)
                            else
                                AKYRS.nopeinator(card) 
                            end
                            
                        end
                        return true
                    end, 0)
                end
            }
        end
    end,
}
