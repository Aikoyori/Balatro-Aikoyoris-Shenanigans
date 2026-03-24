

SMODS.UndiscoveredSprite{
    key = "akyrs_Bet",
    prefix_config = false
    atlas = "Voucher",
    pos = { x = 8, y = 2}
}
---@type SMODS.Center
AKYRS.Bet = SMODS.Center:extend {
    set = 'Bet',
    cost = 0,
    atlas = 'Voucher',
    discovered = false,
    unlocked = true,
    available = false,
    pos = { x = 0, y = 0 },
    config = {},
    class_prefix = 'bet',
    required_params = {
        'key',
    },
    badge_colour = HEX("CC2332")
}
AKYRS.Bet {
    key = "call",
    atlas = 'aikoyoriVouchers', pos = { x = 8, y = 0 } ,
    cost = 0,
    config = {
        extras = {
            slot = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.slot
            }
        }
    end,
    redeem = function (self, card) 
        G.GAME.akyrs_allow_hard_bosses = true
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extras.slot
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_allow_hard_bosses = true
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extras.slot
    end,
}