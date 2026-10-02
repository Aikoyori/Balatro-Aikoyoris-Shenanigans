
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
