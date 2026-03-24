

SMODS.UndiscoveredSprite{
    key = "Bet",
    atlas = "Voucher",
    pos = { x = 8, y = 2}
}
---@type SMODS.Center
AKYRS.Bet = SMODS.Center:extend {
    set = 'Bet',
    cost = 0,
    akyrs_undiscover_tooltip = true,
    akyrs_locked_sprites = {
        atlas = "Voucher",
        pos = { x = 8, y = 3},
    },
    akyrs_undiscovered_sprites = {
        atlas = "Voucher",
        pos = { x = 8, y = 2},
    },
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
    key = "expert_play",
    atlas = 'aikoyoriBets', pos = { x = 0, y = 0 } ,
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

AKYRS.Bet {
    key = "raise_the_stake",
    atlas = 'aikoyoriBets', pos = { x = 1, y = 0 } ,
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