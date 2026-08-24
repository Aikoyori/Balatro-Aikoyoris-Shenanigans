

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
---@field can_redeem fun(self: AKYRS.Bet|table, card: Card): boolean? a check to see if you can redeem it (because it can do more than voucher usually do, for example ghastly limelight will need to check if you can have multiple)
---@field multi_use boolean can this be used multiple times
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
    can_redeem = function (self, card)
        return (self.multi_use or not G.GAME.akyrs_redeemed_bet_key_table[self.key])
    end,
    badge_colour = HEX("69535D"),
    in_pool = function (self, args)
        return (self.multi_use or not G.GAME.akyrs_redeemed_bet_key_table[self.key])
    end,
}

AKYRS.Bet {
    key = "expert_play",
    atlas = 'aikoyoriBets', pos = { x = 0, y = 0 } ,

    config = {
        extras = {
            slot = 2
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
            num = 1,
            denom = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extras.num, card.ability.extras.denom, 'akyrs_bet_raise_stake_chance' )
        return {
            vars = {
                n, d,
            }
        }
    end,
    multi_use = true,
    can_redeem = function (self, card)
        return #G.GAME.applied_stakes < #G.P_CENTER_POOLS.Stake and AKYRS.has_room(G.jokers)
    end,
    redeem = function (self, card) 
        local potential_stakes = AKYRS.get_applicable_stakes()
        local stake_to_apply = pseudorandom_element(potential_stakes, "akyrs_bet_expert_play_random_stake")
        local applied_stakes_keys = AKYRS.apply_stake_mid_game(stake_to_apply)
        
        AKYRS.simple_event_add(function ()
            if SMODS.pseudorandom_probability(card, 'akyrs_bet_raise_stake_chance' , card.ability.extras.num, card.ability.extras.denom ) then
                SMODS.add_card{ rarity = 'Rare', set = 'Joker'}
            else
                AKYRS.nopeinator(card, { parent_this = card.akyrs_real_card })
            end
            return true
        end,0)
        for _, stk in ipairs(applied_stakes_keys) do
            local stake_config = G.P_STAKES[stk]
            local fake_stake_card = AKYRS.fake_card_sprite({
                atlas = stake_config.atlas,
                pos = stake_config.pos,
            },{
                h = G.CARD_H / 2,
                w = G.CARD_H / 2,
                x = card.T.x + 2,
                y = card.T.y,
            })
            G.play:emplace(fake_stake_card)
            AKYRS.simple_event_add(function ()
                AKYRS.voucher_style_text(fake_stake_card, {
                    top_text = localize{type = 'name_text', set = "Stake", key = stk },
                    bottom_text = localize('k_akyrs_applied_ex'),
                })
                return true
            end,0)
        end
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
        info_queue[#info_queue+1] = { key = 'akyrs_locked', set = 'Other' }
        return {
            vars = {
                card.ability.extras.slot
            }
        }
    end,
    multi_use = true,
    redeem = function (self, card) 
        G.GAME.akyrs_lock_card_amnt = (G.GAME.akyrs_lock_card_amnt or 0) + 1
        if G.STATE == G.STATES.SHOP and G.shop_jokers.cards then
            local card_to_lock = pseudorandom_element(G.shop_jokers.cards, "akyrs_bet_alaahp_lock")
            if card_to_lock then SMODS.Stickers.akyrs_locked:apply(card_to_lock, true) end
        end
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_lock_card_amnt = (G.GAME.akyrs_lock_card_amnt or 1) - 1
    end,
}

AKYRS.Bet {
    key = "flames_of_desires",
    atlas = 'aikoyoriBets', pos = { x = 3, y = 0 } ,

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
    multi_use = true,
    redeem = function (self, card) 
        local suits_in_deck = AKYRS.get_suit_freq_from_cards(G.playing_cards, true)
        local suit_to_absolutely_annihilate = pseudorandom_element(AKYRS.filter_table(SMODS.Suits, function (st)
            return suits_in_deck[st.key]
        end, false, true), 'akyrs_bet_flames_of_desires_suit')
        if suit_to_absolutely_annihilate then
            local cards_potential = AKYRS.filter_table(G.playing_cards, function (c)
                return c:is_suit(suit_to_absolutely_annihilate.key)
            end, true, true)
            for _, c in ipairs(cards_potential) do
                AKYRS.remove_value_from_table(G.playing_cards, c)
                SMODS.destroy_cards({c})
            end
        end
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
        }
    },
    loc_vars = function (self, info_queue, card)
        for _,ct in ipairs(G.P_CENTER_POOLS.Enhanced) do
            if ct.akyrs_note_card then
                info_queue[#info_queue+1] = ct
            end
        end
        return {
            vars = {
            }
        }
    end,
    multi_use = true,
    redeem = function (self, card) 
        local weight_total = 0
        local filtered = AKYRS.map(AKYRS.filter_table(G.P_CENTER_POOLS.Enhanced, function (ct)
            return ct.akyrs_note_card
        end, true, true), function (v, k)
            weight_total = weight_total + v.akyrs_note_card.weight
            return { value = v.key, weight = v.akyrs_note_card.weight }
        end)
        filtered[#filtered+1] = { value = 'c_base', weight = weight_total }
        AKYRS.filter_table(G.playing_cards,
            function (cx)
                local selected = AKYRS.weighted_randomiser(filtered, "akyrs_bet_resonance_of_chaos_select")
                cx:set_ability(G.P_CENTERS[selected])
            end, true, true)
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
}
AKYRS.Bet {
    key = "ghastly_limelight",
    atlas = 'aikoyoriBets', pos = { x = 5, y = 0 } ,

    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    can_redeem = function (self, card)
        if G.jokers and G.jokers.cards then
            local candidates = AKYRS.filter_table(G.jokers.cards, function (c)
                return not SMODS.is_eternal(c)
            end,true, true)
            return #candidates >= 2
        end
        return false
    end,
    redeem = function (self, card) 
        local candidates = AKYRS.filter_table(G.jokers.cards, function (c)
            return not SMODS.is_eternal(c)
        end,true, true)
        local target_joker = pseudorandom_element(candidates, "akyrs_bet_ghastly_limelight_pick")
        local other_jokers = AKYRS.filter_table(G.jokers.cards, function (c)
            return c ~= target_joker
        end, true, true)
        local rarity = AKYRS.rarity_map(target_joker.config.center.rarity)
        local sets = target_joker.ability.set
        SMODS.destroy_cards({target_joker})
        AKYRS.do_things_to_card(other_jokers, function (_card, index)
            local key = SMODS.poll_object{ type = sets, rarities = {rarity}, allow_legendaries = true }
            _card.ability.misprinted = nil
            _card:set_ability(G.P_CENTERS[key])
        end)
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
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    redeem = function (self, card) 
        G.GAME.akyrs_life_decay_mode = "normal"
        AKYRS.update_life_ui(G)
        
    end,
    unredeem = function (self, card) 
        -- i don't think there's much to do here ngl it's a one way action
    end,
    in_pool = function (self, args)
        return not AKYRS.is_life_enabled()
    end,
}

AKYRS.Bet {
    key = "double_or_nothing",
    atlas = 'aikoyoriBets', pos = { x = 7, y = 0 } ,
    config = {
        extras = {
            payouts = 2
        }
    },
    multi_use = true,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.payouts,
                (G.GAME.akyrs_blind_size_mult or 2),
            }
        }
    end,
    redeem = function (self, card) 
        G.GAME.akyrs_payouts_multiplier = (G.GAME.akyrs_payouts_multiplier or 1) * card.ability.extras.payouts
        G.GAME.akyrs_blind_size_mult = G.GAME.akyrs_blind_size_mult or 2
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * G.GAME.akyrs_blind_size_mult
        G.GAME.akyrs_blind_size_mult = G.GAME.akyrs_blind_size_mult + 1
        AKYRS.update_all_blind_select()
    end,
    unredeem = function (self, card) 
        
    end,
}