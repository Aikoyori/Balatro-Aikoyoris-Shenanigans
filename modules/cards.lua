--SMODS.Enhancement{
--    key = "null",
--    atlas = 'cardUpgrades',
--    pos = {x = 0, y = 0},
--    loc_txt =  	{
--        name = 'Null',
--        text = { 'No Base Chips' },
--    },
--    replace_base_card = true,
--    no_rank = true,
--    no_suit = true,
--    always_scores = true,
--    weight = 0,
--    config = {
--        bonus = 0,
--        bonus_chips = 0,
--        mult = 0,
--    }
--}

SMODS.Back{
    key = "letter_deck",
    atlas = 'deckBacks',
    pos = {x = 0, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            self.config.ante_scaling,
            self.config.discards,
            self.config.hand_size
        } }
    end,
    config = {
        akyrs_starting_letters = AKYRS.scrabble_letters,
        starting_deck_size = 100,
        selection = 1e100,
        discards = 2,
        akyrs_start_with_no_cards = true,
        akyrs_letters_mult_enabled = true,
        akyrs_letters_xmult_enabled = true,
        akyrs_hide_normal_hands = true,
        ante_scaling = 2,
        hand_size = 2,
        vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
    },
}
SMODS.Back{
    key = "math_deck",
    atlas = 'deckBacks',
    pos = {x = 4, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            self.config.akyrs_math_threshold,
            self.config.discards,
            self.config.hand_size
        } }
    end,
    config = {
        akyrs_starting_letters = AKYRS.math_deck_characters,
        akyrs_start_with_no_cards = true,
        akyrs_mathematics_enabled = true,
        akyrs_character_stickers_enabled = true,
        akyrs_no_skips = true,
        selection = 1e100,
        discards = 1,
        akyrs_math_threshold = 2,
        hand_size = 6,
        akyrs_power_of_ten_scaling = 4,
        akyrs_hide_normal_hands = true,
        akyrs_hide_high_card = true,
        akyrs_hand_to_not_hide = {["akyrs_expression"] = true,["akyrs_modification"] = true },
        akyrs_random_scale = {min = 0.5, max = 9.5},
    },
}


SMODS.Back{
    key = "hardcore_challenges",
    name = "Hardcore Challenge Deck",
    atlas = 'deckBacks',
    pos = {x = 1, y = 0},
    omit = true,
    config = {
    },
}


SMODS.Back{
    key = "scuffed_misprint",
    atlas = "deckBacks",
    pos = { x = 7, y = 0},
    config = { akyrs_misprint_base = 5 },
    set_badges = function (self, card, badges)
    end,
    loc_vars = function (self, info_queue, card)
        --info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
        return {
            vars = {
                self.config.akyrs_misprint_base
            }
        }
    end,
    apply = function(self)
        G.GAME.modifiers.akyrs_misprint = true
    end,

}
SMODS.Back{
    key = "freedom",
    atlas = "deckBacks",
    pos = { x = 8, y = 0},
    config = { akyrs_any_drag = true },
    set_badges = function (self, card, badges)
    end,
    loc_vars = function (self, info_queue, card)
    end,
}


SMODS.Enhancement{
    key = "brick_card",
    atlas = 'cardUpgrades',
    pos = {x = 1, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            card.ability.extra.mult
        } }
    end,
    config = {
        extra = {
            mult = 10
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}



SMODS.Enhancement{
    key = "scoreless",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
        } }
    end,
    never_scores = true,
    replace_base_card = false,
    overrides_base_rank = true
}


SMODS.Enhancement{
    key = "ash_card",
    atlas = 'cardUpgrades',
    pos = {x = 2, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            card.ability.extras.chips,
            G.GAME.probabilities.normal or 1,
            card.ability.extras.odds,
        } }
    end,
    config = {
        extras = {
            chips = 35,
            odds = 4
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                chips = card.ability.extras.chips
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}
