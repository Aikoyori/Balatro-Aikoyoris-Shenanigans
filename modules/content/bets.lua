

SMODS.UndiscoveredSprite{
    key = "Bet",
    prefix_config = {
        atlas = false
    },
    atlas = "Voucher",
    pos = { x = 8, y = 2}
}

SMODS.UndiscoveredCompat["Bet"] = true

---@class AKYRS.Bet:SMODS.Center
---@field can_redeem fun(self: AKYRS.Bet|table): boolean? a check to see if you can redeem it (because it can do more than voucher usually do, for example ghastly limelight will need to check if you can have multiple)
---@overload fun(self: AKYRS.Bet): AKYRS.Bet
AKYRS.Bet = SMODS.Center:extend {
    set = 'Bet',
    cost = 3,
    akyrs_undiscover_tooltip = true,
    akyrs_locked_sprites = {
        atlas = "Voucher",
        pos = { x = 8, y = 3},
    },
    akyrs_undiscovered_sprites = {
        atlas = "Voucher",
        pos = { x = 8, y = 2},
    },
    multi_use = false,
    allow_takebacks = false,
    atlas = 'Voucher',
    discovered = false,
    pos = { x = 0, y = 0 },
    config = {},
    class_prefix = 'bet',
    required_params = {
        'key',
    },
    use = function(self, card, copier)
        card:redeem()
    end,
    badge_colour = HEX("CC2332"),
    in_pool = function (self, args)
        return (self.multi_use or not G.GAME.akyrs_redeemed_bet_key_table[self.key])
    end,
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
    config = {
        extras = {
            slot = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                
            }
        }
    end,
    redeem = function (self, card) 
        -- apply a stake modifier and start a new run i guess
        -- give random joker edition
    end,
    unredeem = function (self, card) 
        -- remove stake modifier
        -- actually no no takebacks on this one
        -- it would make the code way more complicated and won't be super compatible
    end,
}

AKYRS.Bet {
    key = "a_lock_and_a_hard_place",
    atlas = 'aikoyoriBets', pos = { x = 2, y = 0 } ,
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
        G.GAME.akyrs_lock_card_amnt = (G.GAME.akyrs_lock_card_amnt or 0) + 1
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_lock_card_amnt = (G.GAME.akyrs_lock_card_amnt or 1) - 1
    end,
}

AKYRS.Bet {
    key = "flames_of_desires",
    atlas = 'aikoyoriBets', pos = { x = 3, y = 0 } ,
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
        -- burn a suit off a deck
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
}
AKYRS.Bet {
    key = "resonance_of_chaos",
    atlas = 'aikoyoriBets', pos = { x = 4, y = 0 } ,
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
        -- burn a suit off a deck
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
}
AKYRS.Bet {
    key = "ghastly_limelight",
    atlas = 'aikoyoriBets', pos = { x = 5, y = 0 } ,
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
        print("fuck!")
        -- burn a suit off a deck
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
}

AKYRS.Bet {
    key = "kaleidoscope",
    atlas = 'aikoyoriBets', pos = { x = 6, y = 0 } ,
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
        -- burn a suit off a deck
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
}