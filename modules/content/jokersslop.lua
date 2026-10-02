
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
            local cds = AKYRS.filter_table(G.playing_cards, function (item)
                return item.ability.akyrs_played_this_round and not (item:get_id() == 6 or item:get_id() == 7)
            end, true, true)
            if #cds == 0 then
                return {
                    xmult = card.ability.extras.xmult,
                }
            end
        end
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
        if context.post_trigger and context.other_card then
            return {
                swap = true,
            }
        end
    end
}
