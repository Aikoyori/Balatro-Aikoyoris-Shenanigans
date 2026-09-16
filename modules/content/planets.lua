SMODS.Consumable{
    set = "Planet",
    key = "planet_vulcanus",
    atlas = "aikoPlanets2",
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'pair_hands',
    pos = {x=0, y=0},
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.pair_hands.keys, hand)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    config = {

    },
    weight = 2,
    loc_vars = function (self, info_queue, card)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_pairs'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.pair_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_nauvis",
    atlas = "aikoPlanets2",
    pos = {x=1, y=0},
    config = {

    },
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.unique_combination_hands.keys, hand)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'unique_combination_hands',
    weight = 4,
    loc_vars = function (self, info_queue, card)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_unique_hand_combo'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.unique_combination_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_fulgora",
    atlas = "aikoPlanets2",
    pos = {x=2, y=0},
    config = {

    },
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.flush_hands.keys, hand)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'flush_hands',
    weight = 2,
    loc_vars = function (self, info_queue, card)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_flush_hands'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.flush_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_gleba",
    atlas = "aikoPlanets2",
    pos = {x=3, y=0},
    config = {

    },
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.straight_hands.keys, hand)
    end,
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'straight_hands',
    weight = 2,
    loc_vars = function (self, info_queue, card)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_straight_hands'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.straight_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_aquilo",
    atlas = "aikoPlanets2",
    pos = {x=4, y=0},
    config = {

    },
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.combination_hands.keys, hand)
    end,
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'combination_hands',
    weight = 1,
    loc_vars = function (self, info_queue, card)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_any_combo_hands'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.combination_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_shattered",
    atlas = "aikoPlanets2",
    pos = {x=5, y=0},
    config = {

    },
    akyrs_is_planet_for_hand = function (self, hand)
        return AKYRS.is_in_table(SMODS.Attributes.gt5_hands.keys, hand)
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_factorio_planet'), G.C.AKYRS_FACTORIO_PLANET, nil, 1.2)
    end,
    akyrs_planet_show_up = true,
    akyrs_applicable_hands = 'gt5_hands',
    weight = 3,
    loc_vars = function (self, info_queue, card)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return G.GAME.akyrs_has_played_gt5
    end,
    use = function (self, card, area, copier)
        AKYRS.auto_planet_anim(card, localize('k_akyrs_gt5_hands'))
        SMODS.upgrade_poker_hands{
            hands = SMODS.Attributes.gt5_hands.keys,
            instant = true,
        }
    end
}

SMODS.Consumable{
    set = "Planet",
    key = "planet_bishop_ring",
    atlas = "aikoPlanets",
    akyrs_planet_show_up = true,
    pos = {x=0, y=0},
    config = {
        extra = 1,
    },
    weight = 20,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                G.GAME.akyrs_pure_hand_modifier.level,
                G.GAME.akyrs_pure_hand_modifier.multiplier,
                card.ability.extra * 0.5 * G.GAME.akyrs_pure_hand_modifier.level
            }
        }
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_theoretical_planet'), G.C.AKYRS_THEORETICAL_PLANET, nil, 1.2)
    end,
    can_use = function (self, card)
        return true
    end,
    in_pool = function (self, args)
        return G.GAME.akyrs_pure_unlocked
    end,
    use = function (self, card, area, copier)
        G.GAME.akyrs_pure_unlocked = true
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_akyrs_pure_hands'),chips = '...', mult = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {mult = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            return true end }))
        update_hand_text({delay = 0}, {chips = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = nil
            return true end }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
        delay(1.3)
        G.GAME.akyrs_pure_hand_modifier.multiplier = G.GAME.akyrs_pure_hand_modifier.multiplier + card.ability.extra * 0.5 * G.GAME.akyrs_pure_hand_modifier.level
        G.GAME.akyrs_pure_hand_modifier.level = G.GAME.akyrs_pure_hand_modifier.level + card.ability.extra
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}

function AKYRS.auto_planet_anim(card,handname)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=handname or "???",chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end