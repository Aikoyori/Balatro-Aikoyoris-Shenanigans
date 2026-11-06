
SMODS.Scoring_Calculation{
    key = "puzzle_display",
    func = function (self, chips, mult, flames)
        local to_big = to_big or function(x) return x end
        return to_big(0)
    end,
    order = 999,
    replace_ui = function(self)
        return {
            n = G.UIT.R,
            config = { id = 'hand_operator_container' },
            nodes = {

            }
        }
    end,
}

SMODS.Scoring_Calculation{
    key = "math_display",
    order = 999,
    func = function (self, chips, mult, flames)
        local to_big = to_big or function(x) return x end
        return to_big(G.GAME.aikoyori_evaluation_value) - to_big(G.GAME.chips)
    end,
    replace_ui = function(self)
        return {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.1, id = 'hand_operator_container' },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({ string = {{ ref_table = G.GAME, ref_value = "aikoyori_evaluation_value" }}, scale = 0.6, colours = {G.C.WHITE}, akyrs_number_format = 1e15 })
                    }
                }
            }
        }
    end,
    update_ui = function (self, container, chip_display, mult_display, operator)
        container.UIBox:update()
    end
}
