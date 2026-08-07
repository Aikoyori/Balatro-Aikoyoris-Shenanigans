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