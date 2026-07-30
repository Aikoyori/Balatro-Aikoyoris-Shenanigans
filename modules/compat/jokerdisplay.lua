if JokerDisplay then
    local jod = JokerDisplay.Definitions
    -- JokerDisplay text replacements
    JokerDisplay.Global_Definitions.Replace["akyrs_hide_jd"] = {
        priority = 1000,
        replace_text = {},
        replace_reminder = {},
        replace_extra = {},
        replace_modifiers = {},
        replace_debuff_text = {},
        replace_debuff_reminder = {},
        replace_debuff_extra = {},
        replace_debuff_text = { { text = "????????", colour = G.C.UI.TEXT_INACTIVE } },
        stop_calc = true,
        is_replaced_func = function (card, custom_parent)
            return AKYRS.should_hide_ui() or AKYRS.should_conceal_card(card, (card.config.center))
        end
    }
    jod["j_akyrs_redstone_repeater"] = {
        text = {
            {
                border_nodes = {
                    { text = "X"},
                    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp" }
                },
                border_colour = G.C.MULT
            }
        },
        reminder_text = {
            { text = "(" },
            {
                border_nodes = {
                    { text = "X" ,colour = G.C.WHITE },
                    { ref_table = "card.joker_display_values", ref_value = "mult_stored", retrigger_type = "exp" ,colour = G.C.WHITE  }
                },
            },
            { text = " stored)" },
        },
        calc_function = function(card)
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.mult_stored = card.ability.extra.mult_stored
        end
    }
    -- will be dealt with later
    --[[
    jod["j_akyrs_observer"] = {
        text = {
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult_stored", retrigger_type = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "+", colour = G.C.YELLOW },
            { ref_table = "card.joker_display_values", ref_value = "times_increment", retrigger_type = "mult", colour = G.C.YELLOW },
            { text = "x", colour = G.C.YELLOW },
            { text = "/"},
            { text = "+",colour = G.C.MULT },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "times", retrigger_type = "mult", colour = G.C.YELLOW },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "total_times", retrigger_type = "mult", colour = G.C.YELLOW },
                { text = "->" },
                { text = "+",colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
                { text = ")" },
            },
            {
            },
        },
        calc_function = function(card)
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.mult_stored = card.ability.extra.mult_stored
            card.joker_display_values.times = card.ability.extra.times
            card.joker_display_values.total_times = card.ability.extra.total_times
            card.joker_display_values.times_left = card.ability.extra.total_times - card.ability.extra.times
            card.joker_display_values.times_increment = card.ability.extra.times_increment
        end
    }
    jod["j_akyrs_quasi_connectivity"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp" }
                },
            }
        },
        reminder_text = {
            { text = "(disable random)"},
        },
        calc_function = function(card)
            card.joker_display_values.mult = card.ability.extra.mult
        end
    }
    jod["j_akyrs_diamond_pickaxe"] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "total", retrigger_type = "mult", colour = G.C.CHIPS }
        },
        reminder_text = {
            { text = "(Stone -> Other)"},
        },
        extra = {
            {
                { text = "(" },
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chip_add_stack", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = " x " },
                { ref_table = "card.joker_display_values", ref_value = "chip_add", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = ")" },
            },
            {
            },
        },
        calc_function = function(card)
            card.joker_display_values.chip_add = card.ability.extra.chip_add
            card.joker_display_values.chip_add_stack = card.ability.extra.chip_add_stack
            card.joker_display_values.total = card.ability.extra.chip_add * card.ability.extra.chip_add_stack
        end
    }
    jod["j_akyrs_netherite_pickaxe"] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "total", retrigger_type = "mult", colour = G.C.CHIPS }
        },
        reminder_text = {
            { text = "(destroy Stone)"},
        },
        extra = {
            {
                { text = "(" },
                { text = "+" },
                { ref_table = "card.joker_display_values", ref_value = "chip_add_stack", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = " x " },
                { ref_table = "card.joker_display_values", ref_value = "chip_add", retrigger_type = "mult", colour = G.C.CHIPS },
                { text = ")" },
            },
            {
            },
        },
        calc_function = function(card)
            card.joker_display_values.chip_add = card.ability.extra.chip_add
            card.joker_display_values.chip_add_stack = card.ability.extra.chip_add_stack
            card.joker_display_values.total = card.ability.extra.chip_add * card.ability.extra.chip_add_stack
        end
    }
    jod["j_akyrs_utage_charts"] = {
        text = {
            { text = "+", colour = G.C.AKYRS_PLAYABLE },
            { ref_table = "card.joker_display_values", ref_value = "play_mod", colour = G.C.AKYRS_PLAYABLE }
        },
        reminder_text = {
            { text = "(selectable Card)"},
        },
        calc_function = function(card)
            card.joker_display_values.play_mod = card.ability.play_mod
        end
    }
    jod["j_akyrs_it_is_forbidden_to_dog"] = {
        text = {
            {
                border_nodes = {
                    
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp" }
                }
            }
        },
        reminder_text = {
            { text = "(/dbf card)"},
        },
        calc_function = function(card)
            card.joker_display_values.mult = card.ability.extra.mult
        end
    }
    jod["j_akyrs_eat_pant"] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                }
            }
        },
        reminder_text = {
            { text = "(#cards == "},
            { ref_table = "card.joker_display_values", ref_value = "card_target", retrigger_type = "exp" },
            { text = ")"},
        },
        calc_function = function(card)
            card.joker_display_values.card_target = math.floor(card.ability.extra.card_target)
            card.joker_display_values.adder = card.ability.extra.extra
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        end
    }
    jod["j_akyrs_tsunagite"] = {
        text = {
            { text = "if sum <= "},
            { ref_table = "card.joker_display_values", ref_value = "total", retrigger_type = "exp", colour = G.C.YELLOW },
        },
        reminder_text = {
            { text = "(Reset @ Ante End)"},
        },
        extra = {
            
            {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xchips", retrigger_type = "exp" },
                        border_colour = G.C.CHIPS
                    }
                },
                { text = " / "},
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
                    }
                },
            },
            {
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "exp", colour = G.C.CHIPS },
                { text = " / "},
                { text = "+", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp", colour = G.C.MULT },
            },
        },
        calc_function = function(card)
            card.joker_display_values.total = card.ability.extra.total
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.Xchips = card.ability.extra.Xchips
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        end
    }
    jod["j_akyrs_yona_yona_dance"] = {
        reminder_text = {
            { text = "(4,7)" },
        },
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            return (playing_card:get_id() == 4 or playing_card:get_id() == 7) and
                joker_card.ability.extra.times * JokerDisplay.calculate_joker_triggers(joker_card) or 0
        end
    }
    jod["j_akyrs_tldr_joker"] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
            { text = "/C" },
        },
        reminder_text = {
            {
                text = "(High Card)"
            }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            card.joker_display_values.mult = card.ability.extra.mult
        end,
    }
    jod["j_akyrs_reciprocal_joker"] = {
        text = {
            { text = "Mult", colour = G.C.MULT },
            { text = "="},
            { text = "Chips", colour = G.C.CHIPS },
            { text = "/"},
            { text = "Mult", colour = G.C.MULT },
        },
        calc_function = function(card)
        end,
    }
    jod["j_akyrs_2fa"] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
        },
        reminder_text = {
            { text = "(random rank/suit)"},
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.add = card.ability.extra.extra
        end,
    }
    jod["j_akyrs_gaslighting"] = {
        text = {
            {
                border_nodes = {
                    { text = "X"},
                    { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" },
                }
            }
        },
        reminder_text = {
            { text = "(Fire =/= Reset)"},
        },
        calc_function = function(card)
            card.joker_display_values.xmult = card.ability.extra.xmult
            card.joker_display_values.add = card.ability.extra.extra
        end,
    }
    jod["j_akyrs_hibana"] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "display_state"},
        },
        text_config = { colour = G.C.YELLOW },
        calc_function = function(card)
            card.joker_display_values.table = card.ability.extra.possible_table
            card.joker_display_values.cycle = card.ability.akyrs_cycler
            card.joker_display_values.tab = card.joker_display_values.table[card.joker_display_values.cycle]
            card.joker_display_values.display_state = localize(card.joker_display_values.tab[3][1],card.joker_display_values.tab[3][2])
        end,
    }
    jod["j_akyrs_neurosama"] = {
        text = {
            {
                border_nodes = {
                    { text = "X"},
                    { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" },
                },
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "suits"},
        },
        calc_function = function(card)
            card.joker_display_values.xmult = card.ability.extras.xmult
            card.joker_display_values.add = card.ability.extras.xmult_inc
            card.joker_display_values.suits = "(Hearts"..(#SMODS.find_card("j_akyrs_evilneuro") > 0 and " or Spades" or "")..")"
        end,
    }
    jod["j_akyrs_evilneuro"] = {
        text = {
            {
                border_nodes = {
                    { text = "X"},
                    { ref_table = "card.joker_display_values", ref_value = "xchips", retrigger_type = "exp" },
                },
                border_colour = G.C.CHIPS
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "suits"},
        },
        calc_function = function(card)
            card.joker_display_values.xchips = card.ability.extras.xchips
            card.joker_display_values.add = card.ability.extras.xchips_inc
            card.joker_display_values.suits = "(Clubs"..(#SMODS.find_card("j_akyrs_neurosama") > 0 and " or Diamonds" or "")..")"
        end,
    }]]
end