SMODS.Rarity{
    key = "emerald",
    default_weight = 0.3,
    badge_colour = HEX('73ff33'),
    disable_if_empty = true,
    pools = {
        ["Joker"] = true
    },
    get_weight = function(self, weight, object_type)
        local x = SMODS.find_card("j_akyrs_emerald")
        return (G.GAME and next(x)) and 0.45 + 0.05 * #x or 0.02
    end,

}

SMODS.Rarity{
    key = "supercommon",
    default_weight = 0,
    badge_colour = HEX('8c94a3'),
    disable_if_empty = true,
    pools = {
        ["Joker"] = true
    },

}

SMODS.Rarity{
    key = "unique",
    default_weight = 0,
    badge_colour = HEX('ed9a78'),
    pools = {
        ["Joker"] = true
    },

}