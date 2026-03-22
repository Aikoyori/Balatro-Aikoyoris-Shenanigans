if AKYRS.is_mod_loaded("TOGAPack") then
    SMODS.Joker{
        key = "toga_charmap",
        atlas = "togasstuff_crossmod",
        rarity = 1,
        cost = 3,
        pos = { x = 0, y = 0},
        in_pool = function (self, args)
            return G.GAME.akyrs_character_stickers_enabled
        end,
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = togabalatro },badges) end
        end,
        config = {
            extras = { money = 1 }
        },
        blueprint_compat = true,
        calculate = function (self, card, context)
            if context.joker_main and G.GAME.akyrs_character_stickers_enabled then
                local w = AKYRS.get_letter_freq_from_cards(G.play.cards)
                local max_freq = 0
                local most_common_letter = nil
                for letter, freq in pairs(w) do
                    if freq > max_freq then
                        max_freq = freq
                        most_common_letter = letter
                    elseif freq == max_freq then
                        most_common_letter = nil -- Tie, no single most common letter
                    end
                end
                if most_common_letter then
                    return {
                        func = function ()
                            if AKYRS.has_room(G.consumeables) then
                                SMODS.add_card({area = G.consumeables, set = 'Alphabet', key = 'c_akyrs_alphabet_'..most_common_letter})
                            end
                        end
                    }
                end
            end
        end
        
    }
    SMODS.Joker{
        key = "toga_winword",
        atlas = "togasstuff_crossmod",
        pos = { x = 1, y = 0},
        in_pool = function (self, args)
            return G.GAME.akyrs_character_stickers_enabled
        end,
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = togabalatro },badges) end
        end,
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                    card.ability.extras.xmult_gain,
                    card.ability.extras.xmult
                }
            }
        end,
        rarity = 3,
        cost = 8,
        config = {
            extras = { xmult_gain = 0.1992, xmult = 1 }
        },
        calculate = function (self, card, context)
            if context.individual and context.cardarea == G.play then
                if G.GAME.aiko_current_word and not context.blueprint then
                    return {
                        func = function ()
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extras,
                                ref_value = "xmult",
                                scalar_value = "xmult_gain",
                            })
                        end
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extras.xmult
                }
            end
        end,
        blueprint_compat = true
        
    }
end