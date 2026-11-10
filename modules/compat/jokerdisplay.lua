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
end