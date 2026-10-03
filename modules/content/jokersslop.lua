
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
    in_pool = function (self, args)
        return true, { allow_duplicates = true }
    end
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
    in_pool = function (self, args)
        return true, { allow_duplicates = true }
    end
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
    in_pool = function (self, args)
        return true, { allow_duplicates = true }
    end
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
    in_pool = function (self, args)
        return true, { allow_duplicates = true }
    end
}
