
SMODS.Back{
    key = "letter_deck",
    name = "Letter Deck",
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
        akyrs_selection = 1e100,
        discards = 2,
        akyrs_wording_enabled = true,
        akyrs_start_with_no_cards = true,
        akyrs_letters_mult_enabled = true,
        akyrs_hide_normal_hands = true,
        ante_scaling = 2,
        hand_size = 2,
        vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
    },
}

SMODS.Back{
    key = "mega_letter_deck",
    name = "Mega Letter Deck",
    atlas = 'deckBacks',
    pos = {x = 3, y = 0},
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
        akyrs_selection = 1e100,
        discards = 2,
        akyrs_wording_enabled = true,
        akyrs_start_with_no_cards = true,
        akyrs_letters_mult_enabled = true,
        akyrs_hide_normal_hands = true,
        ante_scaling = 40,
        hand_size = 25,
        vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
    },
    apply = function (self, back)
        G.GAME.starting_params.hands = 1
        G.GAME.round_resets.hands = 1
    end
}

SMODS.Back{
    key = "math_deck",
    name = "Math Deck",
    atlas = 'deckBacks',
    pos = {x = 4, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            self.config.akyrs_math_threshold,
            5 + self.config.akyrs_selection,
            self.config.akyrs_gain_selection_per_ante
        } }
    end,
    config = {
        akyrs_starting_letters = AKYRS.math_deck_characters,
        akyrs_start_with_no_cards = true,
        akyrs_mathematics_enabled = true,
        akyrs_character_stickers_enabled = true,
        akyrs_no_skips = true,
        akyrs_selection = 0,
        akyrs_gain_selection_per_ante = 1,
        discards = 1,
        --akyrs_always_skip_shops = true,
        akyrs_math_threshold = 1,
        hand_size = 6,
        akyrs_power_of_x_scaling = 13.69,
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
    pos = {x = 3, y = 1},
    omit = true,
    draw = function (self, card, layer)
        
    end,
    config = {
    },
}

if not MP and not BalatroMultiplayer and not AKYRS.is_mod_loaded("Multiplayer") then
    SMODS.Back{
        key = "scuffed_misprint",
        atlas = "deckBacks",
        pos = { x = 7, y = 0},
        config = { akyrs_misprint_min = 1e-4, akyrs_misprint_max = 1e4 },
        set_badges = function (self, card, badges)
        end,
        loc_vars = function (self, info_queue, card)
            --info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
            return {
                vars = {
                    self.config.akyrs_misprint_min,
                    self.config.akyrs_misprint_max
                }
            }
        end,
        apply = function(self)
            G.GAME.modifiers.akyrs_misprint = true
        end,
    }
end

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

SMODS.Back{
    key = "ultimate_freedom",
    atlas = "deckBacks",
    pos = { x = 9, y = 0},
    config = { akyrs_any_drag = true, akyrs_ultimate_freedom = true },
    set_badges = function (self, card, badges)
    end,
    loc_vars = function (self, info_queue, card)
    end,
}

SMODS.Back{
    key = "ranking_deck",
    name = "Ranking Deck",
    atlas = 'deckBacks',
    pos = {x = 4, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.ante_scaling
            }
        }
    end,
    config = {
        akyrs_split_rank_deck = true,
        ante_scaling = 2.5,
    },
}

SMODS.Back{
    key = "suitable_deck",
    name = "Suitable Deck",
    atlas = 'deckBacks',
    pos = {x = 5, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.ante_scaling
            }
        }
    end,
    config = {
        akyrs_split_suit_deck = true,
        ante_scaling = 1.5,
    },
}

SMODS.Back{
    key = "split_deck",
    name = "Split Deck",
    atlas = 'deckBacks',
    pos = {x = 2, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.discards
            }
        }
    end,
    config = {
        akyrs_split_deck = true, discards = 2
    },
}

SMODS.Back{
    key = "inversion_deck",
    name = "Inversion Deck",
    atlas = 'deckBacks',
    pos = {x = 6, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
        }
    end,
    config = {
        akyrs_inversion_deck = true,
    },
}

SMODS.Back{
    key = "down_deck",
    name = "Down Deck",
    atlas = 'deckBacks',
    pos = {x = 8, y = 1},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.joker_slot
            }
        }
    end,
    config = {
        joker_slot = 1,
        akyrs_down_deck = true,
    },
}
SMODS.Back{
    key = "judge_deck",
    name = "Judge Deck",
    atlas = 'deckBacks',
    pos = {x = 0, y = 3},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.akyrs_starting_life,
                self.config.akyrs_life_heal.round,
                self.config.joker_slot,
            }
        }
    end,
    config = {
        akyrs_starting_life = 500,
        akyrs_life_heal = {
            round = 40
        },
        joker_slot = 1,
    },
}
SMODS.Back{
    key = "prism_deck",
    name = "Prism Deck",
    atlas = 'deckBacks',
    pos = {x = 1, y = 2},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.akyrs_starting_life,
                self.config.joker_slot,
                self.config.consumable_slot,
            }
        }
    end,
    config = {
        akyrs_starting_life = 1500,
        akyrs_life_decay_mode = "kaleidoscope",
        akyrs_life_heal = {
            round = 0
        },
        joker_slot = 1,
        consumable_slot = 1,
    },
}

if AKYRS.config.experimental_features then
    SMODS.Back{
        key = "developer_deck",
        name = "Developer Deck",
        atlas = 'deckBacks',
        pos = {x = 9, y = 1},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "kaleidoscopic_deck",
        name = "Kaleidoscopic Deck",
        atlas = 'deckBacks',
        pos = {x = 2, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "dotted_deck",
        name = "Dotted Deck",
        atlas = 'deckBacks',
        pos = {x = 4, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "sheared_deck",
        name = "Deck of the Sheared",
        atlas = 'deckBacks',
        pos = {x = 0, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "vision_deck",
        name = "Deck of the Vision",
        atlas = 'deckBacks',
        pos = {x = 3, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "animosity_deck",
        name = "Deck of the Animosity",
        atlas = 'deckBacks',
        pos = {x = 5, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "weaver_deck",
        name = "Deck of the Weaver",
        atlas = 'deckBacks',
        pos = {x = 6, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "puppet_deck",
        name = "Deck of the Puppets",
        atlas = 'deckBacks',
        pos = {x = 7, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "shining_deck",
        name = "Deck of the Shining",
        atlas = 'deckBacks',
        pos = {x = 8, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "flora_deck",
        name = "Flora Deck",
        atlas = 'deckBacks',
        pos = {x = 9, y = 2},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "discord_deck",
        name = "Discord Deck",
        atlas = 'deckBacks',
        pos = {x = 1, y = 1},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
    SMODS.Back{
        key = "nitro_deck",
        name = "Nitro Deck",
        atlas = 'deckBacks',
        pos = {x = 0, y = 1},
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                }
            }
        end,
        config = {
        },
    }
end