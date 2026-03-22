---@type SMODS.Joker
AKYRS.LetterJoker = SMODS.Joker:extend{
    akyrs_is_letter = true,
    in_pool = function (self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled or false
    end
}


-- HOLY SHIT NEW PAGE this one is dedicated to the letters
-- update nevermind i add whatever the fuck i wanna

-- maxwell's notebook
AKYRS.LetterJoker {
    atlas = 'guestJokerArts',
    pos = { x = 0, y = 0 },
    pools = { ["Letter"] = true },
    key = "maxwells_notebook",
    rarity = 3,
    cost = 4,
    akyrs_credits = {
        art = {
            "larantula_l"
        },
        attrib = {
            ["larantula_l"] = "art",
        },
    },
    loc_vars = function(self, info_queue, card)
        
        if AKYRS.config.show_joker_preview then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_maxwell_example"]
        end
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_larantula"]
        return {
            vars = {  }
        }
    end,
    config = {
        
    },
    
    calculate = function(self, card, context)
        if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and G.GAME.aiko_current_word then
            local word = G.GAME.aiko_current_word
            
            if not word then return {} end
            word = string.lower(word)
            --print(word)
            if context.cardarea == G.play and context.individual then
                AKYRS.maxwell_enhance_card(word, context)
            end

            if context.joker_main then     
  
                AKYRS.maxwell_generate_card(word, context)
            end
        end
    end,
    blueprint_compat = true,
}

AKYRS.LetterJoker{
    atlas = 'AikoyoriJokers',
    key = "henohenomoheji",
    pos = {
        x = 6, y = 0
    },
    loc_vars = function(self, info_queue, card)
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
        }
    end,
    rarity = 1,
    cost = 2,
    config = {
        name = "Henohenomoheji",
    },

}

-- yee
AKYRS.LetterJoker{
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true, },
    key = "yee",
    pos = {
        x = 8, y = 2
    },
    rarity = 2,
    cost = 5,
    config = {
        name = "Yee",
        extras = {
            chips = 20,
            mult = 12,
            xchips = 1,
            xchips_add = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd" ..(AKYRS.is_mod_loaded("Cryptid") and "_cass_none" or ""),
                vars = {
                    card.ability.extras.xchips_add,
                    card.ability.extras.xchips,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.chips,
                card.ability.extras.mult,
            }
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal("absurd") then
            if context.akyrs_pre_play then
                return {
                    message = localize("k_akyrs_yee"),
                    colour = G.C.GREEN,
                    func = function ()
                        AKYRS.change_letter_to(context.akyrs_pre_play_cards[1],"y", true)
                        context.akyrs_pre_play_cards[1]:juice_up(0.5,1)
                        AKYRS.change_letter_to(context.akyrs_pre_play_cards[2],"e", true)
                        context.akyrs_pre_play_cards[2]:juice_up(0.5,1)
                    end
                }
            end
            if context.before then
                if not (context.scoring_name == "High Card" or context.scoring_name == "cry_None") then
                    return {
                        message = localize("k_upgrade_ex"),
                        message_card = card,
                        func = function ()
                            SMODS.scale_card(card,{ ref_table = card.ability.extras, ref_value = 'xchips', scalar_value = "xchips_add"})
                        end
                    }
                end
            end
            if context.joker_main then
                return {
                    xchips = card.ability.extras.xchips
                }
            end
        else
            if context.individual and context.cardarea == G.play and G.GAME.aiko_current_word then
                local w = AKYRS.get_letter_freq_from_cards(G.play.cards)
                local l = string.lower(context.other_card:get_letter_with_pretend())
                if (w["y"] and w["y"] >= 1 and w["e"] and w["e"] >= 2) and (l == "y" or l == "e") then
                    return {
                        mult = card.ability.extras.mult,
                        chips = card.ability.extras.chips
                    }
                end
            end
        end

    end
}

AKYRS.LetterJoker {
    key = "g",
    atlas = 'guestJokerArts',
    pos = { x = 1, y = 0 },
    pools = { ["Letter"] = true, ["Meme"] = true  },
    akyrs_credits = {
        art = {
            "larantula_l"
        },
        attrib = {
            ["larantula_l"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_zap_card"]
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_larantula"]
    end,
    rarity = 3,
    cost = 7,
    config = {
    },
    calculate = function (self, card, context)
        if context.joker_main and G.GAME.aiko_current_word and G.GAME.current_round.hands_played == 0 then
            return {
                func = function()
                    ---@type Card[]
                    G.play.cards = G.play.cards
                    table.sort(G.play.cards,AKYRS.hand_sort_function)
                    local l = G.play.cards[1]:get_letter_with_pretend()
                    if l and string.lower(l) == "g" then
                        for x,_c in ipairs(G.play.cards) do
                            _c.ability.aiko_about_to_be_destroyed = true
                        end
                        AKYRS.do_things_to_card( G.hand.cards, function (card)
                            card:set_ability(G.P_CENTERS['m_akyrs_zap_card'])
                        end)
                    end
                end
            }
        end
        if context.destroying_card and context.destroying_card.ability.aiko_about_to_be_destroyed then
            return { remove = true }
        end
    end,
}

AKYRS.LetterJoker {
    key = "d_se_dab",
    atlas = 'AikoyoriJokers',
    pos = { x = 1, y = 6 },
    pools = { ["Letter"] = true, ["Meme"] = true  },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.gain_xchips
            }
        }
    end,
    rarity = 2,
    cost = 6,
    config = {
        extras = {
            gain_xchips = 0.2,
        }
    },
    calculate = function (self, card, context)
        if context.joker_main then
            local encha = {}
            for _, c in ipairs(G.play.cards) do
                table.insert(encha, c.config.center.key)
            end
            AKYRS.remove_dupes(encha)
            if #encha >= 3 then
                local all_cards = {}
                for _, c in ipairs(G.play.cards) do
                    table.insert(all_cards, c)
                end
                for _, c in ipairs(G.hand.cards) do
                    table.insert(all_cards, c)
                end
                local cards_matching = table.akyrs_filter(all_cards, function (v,k,t)
                    return string.lower(v:get_letter_with_pretend() or "") == "d"
                end, true)
                AKYRS.do_things_to_card(cards_matching,function (cd)
                    cd.ability.perma_x_chips = (cd.ability.perma_x_chips or 0) + card.ability.extras.gain_xchips
                    AKYRS.juice_like_tarot( cd )
                    return true
                end)
            end
        end
    end,
}

AKYRS.LetterJoker {
    key = "c",
    atlas = 'AikoyoriJokers',
    pos = { x = 2, y = 6 },
    pools = { ["Letter"] = true, ["Meme"] = true },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.chips
            }
        }
    end,
    rarity = 1,
    cost = 3,
    config = {
        extras = {
            chips = 20,
        }
    },
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and string.lower(context.other_card:get_letter_with_pretend()) == "c" then
            return {
                chips = card.ability.extras.chips
            }
        end
    end,
}
AKYRS.LetterJoker {
    key = "e",
    atlas = 'AikoyoriJokers',
    pos = { x = 3, y = 6 },
    pools = { ["Letter"] = true, ["Meme"] = true },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.mult
            }
        }
    end,
    rarity = 1,
    cost = 3,
    config = {
        extras = {
            mult = 4,
        }
    },
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and string.lower(context.other_card:get_letter_with_pretend()) == "e" then
            return {
                mult = card.ability.extras.mult
            }
        end
    end,
}

AKYRS.LetterJoker {
    key = "catchphrase",
    atlas = 'AikoyoriJokers',
    pos = { x = 4, y = 6 },
    pools = { ["Letter"] = true, ["Meme"] = true },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.mult
            }
        }
    end,
    rarity = 2,
    cost = 3,
    config = {
        extras = {
            mult = 8,
        }
    },
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.hand and string.lower(context.other_card:get_letter_with_pretend()) == "h" then
            return {
                mult = card.ability.extras.mult
            }
        end
    end,
}

AKYRS.LetterJoker {
    key = "press_f",
    atlas = 'pressf',
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    pools = { ["Letter"] = true, ["Meme"] = true },
    akyrs_credits = {
        art = {
            "lyman"
        },
        attrib = {
            ["lyman"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_lyman"]
        return {
            vars = {
                card.ability.extras.mult
            }
        }
    end,
    rarity = 2,
    cost = 3,
    config = {
        extras = {
            mult = 8,
        }
    },
    calculate = function (self, card, context)
        -- im too lazy rn so i just copied vremade code and changed it
        if context.destroy_card and not context.blueprint then
            if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and string.lower(context.full_hand[1]:get_letter_with_pretend()) == "f" then
                if AKYRS.has_room(G.consumeables) then
                    AKYRS.simple_event_add(function()
                            SMODS.add_card {
                                set = 'Umbral',
                                key_append = 'akyrs_press_f'
                            }
                            return true
                        end, 0)
                    return {
                        message = localize('k_akyrs_plus_umbral'),
                        colour = G.C.AKYRS_UMBRAL_P,
                        remove = true
                    }
                end
                return {
                    remove = true
                }
            end
        end
    end,
}



AKYRS.LetterJoker {
    key = "ojisan_koubun",
    atlas = 'AikoyoriJokers',
    pos = { x = 6, y = 6 },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS["tag_double"]
        return {
            vars = {
                card.ability.extras.last_letter
            }
        }
    end,
    rarity = 3,
    cost = 7,
    config = {
        extras = {
            last_letter = "???"
        }
    },
    calculate = function (self, card, context)
        if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and G.GAME.aiko_current_word then
            if context.before then
                if G.play and string.lower(G.play.cards[1]:get_letter_with_pretend()) == card.ability.extras.last_letter then
                    return {
                        func = function ()
                            AKYRS.simple_event_add(
                                function ()
                                    add_tag(G.P_TAGS.tag_double)
                                    return true
                                end
                            )
                        end,
                        message = localize("k_akyrs_ojisan"),
                    }
                end
            end
            if context.joker_main then
                local s = AKYRS.split(G.GAME.aiko_current_word)
                card.ability.extras.last_letter = string.lower(s[#s])
            end
        end
    end,
    blueprint_compat = false,
	demicoloncompat = true,
}

