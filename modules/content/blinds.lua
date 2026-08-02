


local function talismanCheck(v,big,omega,jen)
    if Talisman then
        if Talisman.config_file.break_infinity == "omeganum" then
            if Jen then
                return jen
            end
            return omega
        end
        return big
    end
    return v
end

SMODS.Blind{
    key = "the_choice",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("918b8b"),
    atlas = 'aikoyoriBlindsChips',
    debuff = {
        akyrs_is_word_blind = true,
    },
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 1 },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    loc_vars = function (self)
        return {
            vars = {
                string.upper(G.GAME.akyrs_letter_target)
            }
        }
    end,
    debuff_hand = function (self, cards, hand, handname, check)
        if not G.GAME.akyrs_character_stickers_enabled or self.disabled then return false end
        for i, v in ipairs(cards) do
            local l = string.upper(v:get_letter_with_pretend())
            if l and l == string.upper(G.GAME.akyrs_letter_target) then
                return false
            end
        end
        return true
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                localize("k_akyrs_random_letter")
            }
        }
    end
}

SMODS.Blind{
    key = "the_reject",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("a2a2a2"),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 2 },
    debuff = {
        akyrs_is_word_blind = true,
    },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    loc_vars = function (self)
        return {
            vars = {
                string.upper(G.GAME.akyrs_letter_target)
            }
        }
    end,
    debuff_hand = function (self, cards, hand, handname, check)
        if not G.GAME.akyrs_character_stickers_enabled or self.disabled then return false end
        for i, v in ipairs(cards) do
            local l = string.upper(v:get_letter_with_pretend())
            if l and G.GAME.akyrs_last_played_letters[string.upper(G.GAME.akyrs_letter_target)] then
                return true
            end
        end
        return false
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                localize("k_akyrs_random_letter")
            }
        }
    end
}


SMODS.Blind{
    key = "the_redo",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ffd611"),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 3 },
    debuff = {
        akyrs_is_word_blind = true,
    },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    debuff_hand = function (self, cards, hand, handname, check)
        if not G.GAME.akyrs_character_stickers_enabled or self.disabled then return false end
        for i, v in ipairs(cards) do
            local l = string.upper(v:get_letter_with_pretend())
            if l and G.GAME.akyrs_last_played_letters[l] then
                return true
            end
        end
        return false
    end,
}

SMODS.Blind{
    key = "the_reverse",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ff7d49"),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 4 },
    debuff = {
        akyrs_is_word_blind = true,
    },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    loc_vars = function (self)
        return {
            vars = {
                string.upper(G.GAME.akyrs_letter_target)
            }
        }
    end,
    set_blind = function (self)
        G.GAME.words_reversed = true
    end,
    disable = function (self)
        G.GAME.words_reversed = nil
    end,
    defeat = function (self)
        G.GAME.words_reversed = nil
    end,
    
}

local vowels_list = {
    a = true,
    e = true,
    i = true,
    o = true,
    u = true,
}

SMODS.Blind{
    key = "the_selfish",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("5dd6ff"),
    atlas = 'aikoyoriBlindsChips2',
    debuff = {
        akyrs_is_word_blind = true,
        akyrs_num = 1, akyrs_denom = 3
    },
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 1 },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.debuff.akyrs_num,  self.debuff.akyrs_denom, "akyrs_the_selfish_flip")
        return {
            vars = {
                n, d
            }
        }
    end,
    collection_loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.debuff.akyrs_num,  self.debuff.akyrs_denom, "akyrs_the_selfish_flip")
        return {
            vars = {
                n, d
            }
        }
    end,
    recalc_debuff = function (self, card, from_blind)
        if card and (card:get_letter_with_pretend()) and vowels_list[string.lower(card:get_letter_with_pretend())] then
            if SMODS.pseudorandom_probability(self, "akyrs_the_selfish_flip", self.debuff.akyrs_num,  self.debuff.akyrs_denom) then
                return true
            end
        end
    end
}

SMODS.Blind{
    key = "the_polite",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ff9430"),
    atlas = 'aikoyoriBlindsChips2',
    debuff = {
        akyrs_is_word_blind = true,
    },
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 2 },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.modify_scoring_hand then
                ---@type Card
                local oth = context.other_card
                if oth and oth:get_letter_with_pretend() and vowels_list[string.lower(oth:get_letter_with_pretend())] then
                    return {
                        remove_from_hand = true
                    }
                end
            end
        end
    end,
}


local to_big = to_big or function(x) return x end

SMODS.Blind{
    key = "the_libre",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('a74ce8'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 5 },
    debuff = {
        disable_chip_x = 2
    },
    loc_vars = function(self)
        local orig_chips = to_big(AKYRS.get_true_original_blind_amount(self.mult))
        return { vars = {orig_chips  * to_big(G.GAME.round_resets.ante * self.debuff.disable_chip_x) }, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "X 2X"..localize("k_akyrs_power_ante")}, key = self.key }
    end,
    set_blind = function(self)
    end,
    drawn_to_hand = function(self)
        
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        AKYRS.modify_blind_size({ set = to_big(AKYRS.get_true_original_blind_amount(self.mult)) * to_big(G.GAME.round_resets.ante) * to_big(self.debuff.disable_chip_x)})
            
    end,
    defeat = function(self)
        
    end,
    press_play = function(self)
    end

}
AKYRS.picker_primed_action = function ()
    AKYRS.modify_blind_size({ mult = G.GAME.blind.debuff.score_change })
end
AKYRS.picker_initial_action = function() 
    G.E_MANAGER:add_event(Event({
        trigger = "before",
        func = function ()
            G.hand:unhighlight_all()
            local cards_candidate = AKYRS.filter_table(G.hand.cards or {}, function (c, k)
                return not c.highlighted and not c.ability.akyrs_perma_selection
            end, true, true)
            AKYRS.remove_dupes(cards_candidate)
            local cards_to_pick = AKYRS.pseudorandom_elements(cards_candidate,G.hand.config.highlighted_limit, "akyrpickerseed")
            table.sort(cards_to_pick, AKYRS.hand_sort_function)
            
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.2,
                func = function ()
                    local i=1
                    ---@type table
                    for i,v in ipairs(cards_to_pick) do                        
                        AKYRS.simple_event_add(function ()
                            v:highlight(true)
                            G.hand:add_to_highlighted(v)
                            return true
                        end)
                    end
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function ()
                            G.GAME.blind.debuff.primed = true
                            AKYRS.force_save()
                            return true
                        end
                    }))
                    return true
                end
            }))
            return true
        end
    },"base",true))
end
SMODS.Blind{
    key = "the_picker",
    dollars = 5,
    mult = 1.25,
    boss_colour = HEX('67e38b'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 6 },
    debuff = {
        primed = false,
        acted = false,
        initial_action_acted = false,
        initial_action_act_set = false,
        hand_per_hand = 3,
        lock = false,
        score_change = 1.25,
        akyrs_pick_cards = true,
    },
    loc_vars = function(self)
        return { vars = {G.hand.config.highlighted_limit, self.debuff.score_change}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { localize("k_akyrs_up_to_sel"), 1.2 }, key = self.key }
    end,
    set_blind = function(self)
        G.GAME.blind.debuff.orig_chips = G.GAME.blind.chips
    end,
    drawn_to_hand = function(self)
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.debuff.orig_chips * 2
    end,
    defeat = function(self)
    end,
    press_play = function(self)
        G.GAME.blind.debuff.primed = false
        G.GAME.blind.debuff.acted = false
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            func = function ()
                G.GAME.blind.debuff.initial_action_act_set = false
                return true
            end
        })
    end
}

SMODS.Blind {
    key = "the_height",
    dollars = 7,
    mult = 0.5,
    boss_colour = HEX('36adff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 7 },
    debuff = {
        requirement_scale = 2
    },
    loc_vars = function(self)
        return { vars = {self.debuff.requirement_scale}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "2"}, key = self.key }
    end,
}
SMODS.Blind {
    key = "the_expiry",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('ca60ff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 8 },
    set_blind = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = true
        end
    end,
    
    disable = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = false
            k.debuff = false
        end
    end
}

SMODS.Blind {
    key = "the_nature",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('3d8a55'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 4, max = 10},
    debuff = {
        dec_mult = 0.9,
    },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.dec_mult }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 0.9 }
        }
    end,
    calculate = function (self, blind, context)
        if context.individual and not context.end_of_round and (context.cardarea == G.hand or context.cardarea == G.play or context.cardarea == "unscored") then
            if context.other_card:is_face(true) then
                return { Xmult = blind.debuff.dec_mult }
            end
        end
    end,
    pos = { x = 0, y = 9 },
}

SMODS.Blind {
    key = "the_key",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('8c7d36'),
    debuff = {
        akyrs_perma_selection = { num = 1, denum = 4, seed = "akyrs_boss_the_key" }
    },
    loc_vars = function(self)
        local n, d = SMODS.get_probability_vars(self, self.debuff.akyrs_perma_selection.num,self.debuff.akyrs_perma_selection.denum,self.debuff.akyrs_perma_selection.seed )
        return {
            vars = {
                n, d
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                1, 4
            }
        }
    end,
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 12 },
    calculate = function (self, card, context)
        
    end,
    press_play = function (self)
    end
}


SMODS.Blind{
    key = "the_reverse",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ff7d49"),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 4 },
    debuff = {
        akyrs_is_word_blind = true,
    },
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled)
    end,
    loc_vars = function (self)
        return {
            vars = {
                string.upper(G.GAME.akyrs_letter_target)
            }
        }
    end,
    set_blind = function (self)
        G.GAME.words_reversed = true
    end,
    disable = function (self)
        G.GAME.words_reversed = nil
    end,
    defeat = function (self)
        G.GAME.words_reversed = nil
    end,
    
}


SMODS.Blind{
    key = "the_alignment",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("825bff"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 4, max = 10},
    pos = { x = 0, y = 15 },
    debuff = {
        
    },
    in_pool = function(self)
        return true
    end,
    calculate = function (self, blind, context)
        if context.modify_scoring_hand and not blind.disabled then
            local index = AKYRS.find_index(context.full_hand, context.other_card)
            if index and index == 1 or index == #context.full_hand then
                return {
                    remove_from_hand = true
                }
            end
            
        end
    end
    
}

SMODS.Blind{
    key = "the_duality",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ff6e96"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 4, max = 10},
    pos = { x = 0, y = 16 },
    debuff = {
        
    },
    in_pool = function(self)
        return true
    end,
    calculate = function (self, blind, context)
        if context.before and not blind.disabled then
            for i = 1, #G.play.cards do
                if i == 1 or i ==  #G.play.cards then
                    G.play.cards[i]:set_debuff(true)
                end
            end
            
        end
    end
    
}

SMODS.Blind{
    key = "the_collapse",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ffcb7b"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 17 },
    debuff = {
        akyrs_no_gain_cash = true
    },
    in_pool = function(self)
        return true
    end,
    
}

SMODS.Blind{
    key = "the_bonsai",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("b8f083"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 4, max = 10},
    pos = { x = 0, y = 18 },
    config = {
        numer = 1,
        denum = 3,
    },
    in_pool = function(self)
        return true
    end,
    loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.config.numer, self.config.denum, "akyrs_bonsai_blind")
        return {
            vars = {
                n, d
            }
        }
    end,
    collection_loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.config.numer, self.config.denum, "akyrs_bonsai_blind")
        return {
            vars = {
                n, d
            }
        }
    end,
    calculate = function (self, blind, context)
        if context.modify_scoring_hand and not blind.disabled then
            if SMODS.pseudorandom_probability(self, "akyrs_bonsai_blind",self.config.numer, self.config.denum) and context.other_card:is_face() then
                return {
                    remove_from_hand = true
                }
            end
        end
    end
}


SMODS.Blind{
    key = "the_base",
    dollars = 5,
    mult = 1,
    boss_colour = HEX("32f9ff"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 19 },
    debuff = {
        akyrs_no_retriggers = true
    },
}

SMODS.Blind{
    key = "the_stomata",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("72b06d"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 20 },
    debuff = {
        akyrs_deduct_play = 1
    },
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.individual and context.cardarea == G.play then
                if context.other_card:is_face(true) then
                    return {
                        dollars = -blind.debuff.akyrs_deduct_play
                    }
                end
            end
        end
    end,
}


SMODS.Blind{
    key = "the_rhizome",
    dollars = 5,
    mult = 1.5,
    boss_colour = HEX("c89bcf"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 21 },
    debuff = {
        akyrs_mult_blind_size = 1.5
    },
    loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_blind_size
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_blind_size
            }
        }
    end,
    disable = function (self)
        AKYRS.modify_blind_size({set = AKYRS.get_true_original_blind_amount(self.mult)})
    end,
    calculate = function (self, blind, context)
        if context.before and G.GAME.current_round.akyrs_hands_played[context.scoring_name] and not blind.disabled then
            return {
                func = function ()
                    AKYRS.modify_blind_size({ mult = blind.debuff.akyrs_mult_blind_size })
                end
            }
        end
    end
}


SMODS.Blind{
    key = "the_shrink",
    dollars = 5,
    mult = 12,
    boss_colour = HEX("8087ff"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 22 },
    debuff = {
        akyrs_mult_blind_size = 0.5
    },
    loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_blind_size
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_blind_size
            }
        }
    end,
    disable = function (self)
        AKYRS.modify_blind_size({set = AKYRS.get_true_original_blind_amount(2)})
    end,
    calculate = function (self, blind, context)
        if context.before and not G.GAME.current_round.akyrs_hands_played[context.scoring_name] and not blind.disabled then
            return {
                func = function ()
                    AKYRS.modify_blind_size({ mult = blind.debuff.akyrs_mult_blind_size })
                end
            }
        end
    end
}

SMODS.Blind{
    key = "the_harmonic",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("f0ad82"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 23 },
    debuff = {
    },
    config = {
    },
    set_blind = function (self)
        G.hand:change_size(1)
    end,
    disable = function (self)
        G.hand:change_size(-1)
    end,
    defeat = function (self)
        G.hand:change_size(-1)
    end,
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.hand_drawn then
                return {
                    func = function ()
                        AKYRS.simple_event_add(
                            function ()
                                local cards_candidate = AKYRS.filter_table(G.hand.cards, function(cds, inx) 
                                    return not cds.highlighted
                                end, true, true)
                                local picks = AKYRS.pseudorandom_elements(cards_candidate, 1, "akyrs_blind_harmonics")
                                for _, cd in ipairs(picks) do
                                    G.hand:add_to_highlighted(cd)
                                end
                                G.FUNCS.discard_cards_from_highlighted(nil, true)
                                return true
                            end
                        )
                    end
                }
            end
        end
    end
}

SMODS.Blind{
    key = "the_sinusoidal",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ffb4ea"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 24 },
    debuff = {
    },
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.stay_flipped then
                if context.other_card and context.from_area == G.deck and context.to_area == G.hand then
                    if G.hand.config.card_limit - #G.hand.cards <= 2 then
                        return {
                            stay_flipped = true
                        }
                    end
                end
            end
        end
    end
}

SMODS.Blind{
    key = "the_saw",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("8becc4"),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 4, max = 10},
    pos = { x = 0, y = 25 },
    debuff = {
    },
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.destroy_card and context.cardarea == G.play and context.destroy_card == context.scoring_hand[1] then
                return {
                    remove = true
                }
            end
        end
    end
}


-- le finale bosse


-- Showdown Bosses
SMODS.Blind {
    key = "final_periwinkle_pinecone",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('7da8f0'),
    atlas = 'aikoyoriBlindsChips', 
    debuff = {
        --akyrs_all_seals_perma_debuff = true
    },
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 10 },
    calculate = function (self, blind, context)
        if context.akyrs_pre_play and not blind.disabled then
            return {
                func = function ()
                    local hcard = #G.hand.cards
                    for i = hcard, 1, -1 do
                        AKYRS.simple_event_add(function ()
                            local drawn_c = G.hand:remove_card()
                            if not drawn_c or drawn_c.highlighted then return true end
                            G.deck:emplace(drawn_c)
                            play_sound('card1')
                            return true
                        end, 0.1)
                    end
                    local dcard = #G.discard.cards
                    for i = dcard, 1, -1 do
                        AKYRS.simple_event_add(function ()
                            local drawn_c = G.discard:remove_card()
                            if not drawn_c then return true end
                            G.deck:emplace(drawn_c)
                            play_sound('card1')
                            return true
                        end, 0.1)
                    end
                    AKYRS.simple_event_add(function ()
                        G.deck:shuffle("akyrs_periwinkle_shuffle")
                        return true
                    end, 1)
                    for i = 1, math.min(G.hand.config.card_limit, #G.deck.cards) do
                        AKYRS.simple_event_add(function ()
                            local drawn_c = G.deck:remove_card()
                            G.hand:emplace(drawn_c)
                            play_sound('card1')
                            return true
                        end, 0.1)
                    end
                end
            }
        end
    end
}
SMODS.Blind {
    key = "final_razzle_raindrop",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('ff40ac'),
    debuff = {
    },
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 11 },
    calculate = function (self, blind, context)
        if context.press_play and not blind.disabled then
            return {
                func = function ()
                    AKYRS.simple_event_add(
                        function ()
                            local suits_played = 0
                            local suit_checked = {}
                            for ke, va in pairs(SMODS.Suits) do
                                for _, card_2_check in ipairs(G.play.cards) do
                                    if card_2_check:is_suit(ke) and not suit_checked[ke] then
                                        suit_checked[ke] = true
                                        suits_played = suits_played + 1
                                        break
                                    end
                                end
                            end
                            local picks = AKYRS.pseudorandom_elements(G.hand.cards, suits_played, "akyrs_blind_harmonics")
                            for _, cd in ipairs(picks) do
                                G.hand:add_to_highlighted(cd)
                            end
                            G.FUNCS.discard_cards_from_highlighted(nil, true)
                            return true
                        end
                    )
                end
            }
        end
    end
}

SMODS.Blind {
    key = "final_velvet_vapour",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('911468'),    
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 10 },
    debuff = {
    },
    config = {
        numer = 2, denom = 3,
    },
    loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.config.numer, self.config.denom, "akyrs_velvet_chance")
        return {
            vars = {
                n, d,
            }
        }
    end,
    collection_loc_vars = function (self)
        local n, d = SMODS.get_probability_vars(self, self.config.numer, self.config.denom, "akyrs_velvet_chance")
        return {
            vars = {
                n, d,
            }
        }
    end,
    calculate = function (self, blind, context)
        if context.press_play and not blind.disabled then
            return {
                func = function ()
                    AKYRS.simple_event_add(
                        function ()
                            local card_to_check = G.play.cards[1]
                            if not card_to_check or SMODS.has_no_rank(card_to_check) then return true end
                            local cards_candidate = AKYRS.filter_table(G.hand.cards, function(cds, inx) 
                                return cds:get_id() == card_to_check:get_id() and not cds.highlighted
                            end, true, true)
                            for _, cd in ipairs(cards_candidate) do
                                if SMODS.pseudorandom_probability(blind, "akyrs_velvet_chance", blind.effect.numer, blind.effect.denom) then
                                    G.hand:add_to_highlighted(cd)
                                end
                            end
                            G.FUNCS.discard_cards_from_highlighted(nil, true)
                            return true
                        end
                    )
                end
            }
        end
    end,
    
}

SMODS.Blind {
    key = "final_chamomile_cloud",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('f0ae22'),    
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 9 },
    debuff = {
    },
    calculate = function (self, blind, context)
        if context.press_play and not blind.disabled then
            return {
                func = function ()
                    AKYRS.simple_event_add(
                        function ()
                            local suit_checked = {}
                            local suit_list = {}
                            for ke, va in pairs(SMODS.Suits) do
                                for _, card_2_check in ipairs(G.hand.cards) do
                                    if card_2_check:is_suit(ke) and not suit_checked[ke] then
                                        suit_checked[ke] = true
                                        table.insert(suit_list, ke)
                                        break
                                    end
                                end
                            end
                            local suit = pseudorandom_element(suit_list,"akyrs_chamomile_pick_suit")
                            local cards_candidate = AKYRS.filter_table(G.hand.cards, function(cds, inx) 
                                return cds:is_suit(suit) and not cds.highlighted
                            end, true, true)
                            for _, cd in ipairs(cards_candidate) do
                                G.hand:add_to_highlighted(cd)
                            end
                            G.FUNCS.discard_cards_from_highlighted(nil, true)
                            return true
                        end
                    )
                end
            }
        end
    end,
    
}

SMODS.Blind {
    key = "final_lilac_lasso",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('973fd5'),
    debuff = {
        jokers_not_debuffed = 4,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 13 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.jokers_not_debuffed }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 4 }
        }
    end,
    set_blind = function (self)
        self.prepped = true
    end,
    drawn_to_hand = function (self)
        if self.prepped and G.jokers.cards[1] then
            local jokers = {}
            local undebuffed = {}
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:set_debuff(false)
                jokers[#jokers+1] = G.jokers.cards[i] 
            end 
            for i = 1, (self.debuff.jokers_not_debuffed or 4) do
                if #jokers == 0 then break end
                local _card = pseudorandom_element(jokers, pseudoseed('lilac_lasso'))
                for l,j in ipairs(jokers) do
                    if j == _card then
                        table.insert(undebuffed, j)
                        table.remove(jokers, l)
                        break
                    end
                end
            end 
            
            for i, jkr in ipairs(jokers) do
                jkr:set_debuff(true)
            end
            local r_und = {}
            for i = #undebuffed, 1, -1 do
                table.insert(r_und, undebuffed[i])
            end
            for i, carder in ipairs(r_und) do
                G.E_MANAGER:add_event(
                    Event{
                        trigger = "after",
                        delay = AKYRS.get_speed_mult(carder)*0.05,
                        func = function ()
                            carder:juice_up(0.5,1)
                            return true
                        end
                    }
                )
            end
        end
        self.prepped = nil
        
    end,
    press_play =function (self)
        if G.jokers.cards[1] then
            self.triggered = true
            self.prepped = true
        end
    end,
    disable = function (self)
        
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
        end 
    end
}


SMODS.Blind {
    key = "final_salient_stream",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('358dff'),    
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 11 },
    debuff = {
        akyrs_alternate_action = true
    },
    debuff_hand = function (self, cards, hand, handname, check)
        if G.GAME.current_round.akyrs_last_action and G.GAME.current_round.akyrs_last_action == "play" and not G.GAME.blind.disabled  then
            return true
        end
        return false
    end,
    
}

SMODS.Blind {
    key = "final_luminous_lemonade",
    dollars = 8,
    mult = 2,
    boss_colour = SMODS.Gradients['akyrs_luminous'],    
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 12 },
    debuff = {
    },
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.debuff_hand then
                if G.GAME.current_round.hands_left ~= (G.STATE == G.STATES.SELECTING_HAND and 1 or 0) then
                    return {
                        debuff = true
                    }
                end
            end
        end
    end
    
}

SMODS.Blind {
    key = "final_glorious_glaive",
    dollars = 8,
    mult = 2,
    boss_colour = SMODS.Gradients['akyrs_glorious'],    
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 13 },
    debuff = {
        akyrs_mult_per_played = 0.85
    },
    loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_per_played
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.debuff.akyrs_mult_per_played
            }
        }
    end,
    calculate = function (self, blind, context)
        if context.individual and not context.repetition and context.cardarea == G.play and not G.GAME.blind.disabled then
            return {
                xscore = blind.debuff.akyrs_mult_per_played,
            }
        end
    end
    
}


-- forgotten blinds
SMODS.Blind {
    key = "forgotten_weights_of_the_past",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('60203f'),
    debuff = {
        ante_scaler = 2,
        current_ante = nil,
        akyrs_is_forgotten_blind = true,
        akyrs_cannot_be_overridden = true,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 14 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.ante_scaler }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 2 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 0  -- :3
    end,
    set_blind = function (self)
        G.GAME.blind.debuff.current_ante = G.GAME.round_resets.ante
    end,
    calculate = function (self, blind, context)
        if context.individual and context.cardarea == G.play and not context.repetition and not blind.disabled then
            local old_ante = blind.debuff.current_ante
            blind.debuff.current_ante = blind.debuff.current_ante*blind.debuff.ante_scaler
            ease_ante(-old_ante + blind.debuff.current_ante)
        end
    end
}
SMODS.Blind {
    key = "forgotten_prospects_of_the_future",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('2b664f'),
    debuff = {
        ante_scaler = 1,
        akyrs_is_forgotten_blind = true,
        akyrs_cannot_be_overridden = true,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 15 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.ante_scaler }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    set_blind = function (self)
        G.GAME.blind.debuff.current_ante = G.GAME.round_resets.ante
    end,
    calculate = function (self, blind, context)
        if context.after and not blind.disabled then
            ease_ante(blind.debuff.ante_scaler * #G.hand.cards)
        end
    end
}
SMODS.Blind {
    key = "forgotten_uncertainties_of_life",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('2c5c6c'),
    debuff = {
        hand_shrinker = 1,
        akyrs_is_forgotten_blind = true,
        akyrs_cannot_be_overridden = true,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 16 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.hand_shrinker }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    calculate = function (self, blind, context)
        if context.after and not context.end_of_round and not blind.disabled then
            G.hand:change_size(-blind.debuff.hand_shrinker)
        end
    end
}

SMODS.Blind {
    key = "forgotten_inevitability_of_death",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('4d494b'),
    debuff = {
        discard_dealer = 1,
        akyrs_is_forgotten_blind = true,
        akyrs_cannot_be_overridden = true,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 17 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.discard_dealer }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    calculate = function (self, blind, context)
        if context.blind_defeated and not blind.disabled then
            return{
                func = function ()
                    ease_dollars(-G.GAME.chips / G.GAME.blind.chips)
                end
            }
        end
    end
}


SMODS.Blind {
    key = "expert_confrontation",
    dollars = 10,
    mult = 1,
    boss_colour = HEX('ce36ff'),
    debuff = {
        akyrs_blind_difficulty = "expert",
    },
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 7, max = 10},
    pos = { x = 0, y = 18 },
    debuff_hand = function (self, cards, hand, handname, check)
        local has_face = false
        for i,j in ipairs(cards) do
            if j:is_face() then
                has_face = true
                break
            end
        end
        return not has_face
    end,
    loc_vars = function (self)
        return {
        }
    end,
    collection_loc_vars = function (self)
        return {
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante
    end,

}
SMODS.Blind {
    key = "expert_fluctuation",
    dollars = 10,
    mult = 2.25,
    boss_colour = HEX('ff6c9a'),
    debuff = {
        mult_min = 0.01,
        mult_max = 1.1,
        akyrs_blind_difficulty = "expert",
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 9, max = 10},
    pos = { x = 0, y = 19 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.mult_min, self.debuff.mult_max }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 0.01, 1.1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante > G.GAME.win_ante
    end,
    calculate = function (self, blind, context)
        if context.before and not blind.disabled then
            local xm = pseudorandom(pseudoseed("akyrs_fluctuation"))*(blind.debuff.mult_max - blind.debuff.mult_min) + blind.debuff.mult_min
            return {
                xscore = xm
            }
        end
    end,

}
SMODS.Blind {
    key = "expert_straightforwardness",
    dollars = 10,
    mult = 1.75,
    boss_colour = HEX('4d77ff'),
    debuff = {
        akyrs_blind_difficulty = "expert",
        ch = 0.25,
        mul = 0.25
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 7, max = 10},
    pos = { x = 0, y = 20 },
    loc_vars = function (self)
        return {
            vars = {
                self.debuff.ch * 100,
                self.debuff.mul * 100,
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.debuff.ch * 100,
                self.debuff.mul * 100,
            }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante > G.GAME.win_ante
    end,
    modify_hand = function (self, cards, poker_hands, text, mult, hand_chips)
        if Talisman then
            return to_big(self.debuff.mul) * mult, to_big(self.debuff.ch) * hand_chips, true
        end
        return self.debuff.mul  * mult , self.debuff.ch * hand_chips, true
        -- return mult, hand_chips, false
    end,
}
SMODS.Blind {
    key = "expert_entanglement",
    dollars = 10,
    mult = 2,
    boss_colour = HEX('1fb643'),
    debuff = {
        akyrs_blind_difficulty = "expert",
    },
    stay_flipped = function (self, area, card)
        if area == G.hand and G.hand.cards then
            local ranks = {}
            for i, v in ipairs(G.hand.cards) do
                if v.base and v.base.suit and not SMODS.has_no_suit(v) and v.facing == 'front' then
                    ranks[v.base.suit] = true
                end
            end
            if card.base and card.base.suit and ranks[card.base.suit] and not SMODS.has_no_suit(card) then
                return true
            end
        end
        return false
    end,
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 7, max = 10},
    pos = { x = 0, y = 21 },
    
    loc_vars = function (self)
        return {
        }
    end,
    collection_loc_vars = function (self)
        return {
        }
    end,
}
SMODS.Blind {
    key = "expert_manuscript",
    dollars = 10,
    mult = 2,
    boss_colour = HEX('ffa530'),
    debuff = {
        akyrs_blind_difficulty = "expert",
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 7, max = 10},
    pos = { x = 0, y = 22 },
    modify_hand = function (self, cards, poker_hands, text, mult, hand_chips)
        AKYRS.simple_event_add(
            function ()
                ease_dollars(-mult)
                return true
            end, 0
        )
        return mult, hand_chips, true
    end,
    --[[
    calculate = function (self, blind, context)
        if context.individual and context.area == G.play and not context.repetition then
            local x = localize(context.scoring_name,"poker_hands")
            local y = G.GAME.hands[scoring_hand]
            return {
                dollars = -y.mult
            }
                
        end
    end]]
}
SMODS.Blind {
    key = "expert_inflation",
    dollars = 10,
    mult = 2,
    boss_colour = HEX('7371ff'),
    debuff = {
        akyrs_blind_difficulty = "expert",
        akyrs_anteth_power_of_x_blind_req = 1.5,
        akyrs_anteth_power_of_x_blind_req_multiplier = 1,
        akyrs_anteth_power_of_x_blind_req_power = 0.5,
        akyrs_is_postwin_blind = true,
    },
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 8, max = 10},
    pos = { x = 0, y = 23 },
}

SMODS.Blind {
    key = "master_faraway_island",
    dollars = 14,
    mult = 2,
    boss_colour = HEX('4bbdff'),
    debuff = {
        akyrs_blind_difficulty = "master",
    },
    
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante, {ignore_showdown_check = true}
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 8, max = 10},
    pos = { x = 0, y = 3 },
    set_blind = function (self)
        SMODS.change_play_limit(1)
    end,
    disable = function (self)
        SMODS.change_play_limit(-1)
    end,
    defeat = function (self)
        SMODS.change_play_limit(-1)
    end,
    debuff_hand = function (self, cards, hand, handname, check)
        for i, c in ipairs(cards) do
            if SMODS.has_no_rank(c) or SMODS.has_no_suit(c) then
                return false
            end
        end
        return true
    end
}
SMODS.Blind {
    key = "master_plywood_forest",
    dollars = 14,
    mult = 2,
    boss_colour = HEX('f74d4d'),
    debuff = {
        akyrs_blind_difficulty = "master",
    },
    
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante, {ignore_showdown_check = true}
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 8, max = 10},
    pos = { x = 0, y = 4 },
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.destroy_card and context.cardarea == G.hand then
                return {
                    remove = true,
                }
            end
        end
    end
}
SMODS.Blind {
    key = "master_golden_jade",
    dollars = 14,
    mult = 2,
    boss_colour = HEX('d0521a'),
    debuff = {
        akyrs_blind_difficulty = "master",
        akyrs_deduct_mult = 0.75,
    },
    loc_vars = function (self)
        return {
            vars = {self.debuff.akyrs_deduct_mult}
        }
    end,

    collection_loc_vars = function (self)
        return {
            vars = { self.debuff.akyrs_deduct_mult }
        }
    end,    
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante, {ignore_showdown_check = true}
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 12, max = 10},
    pos = { x = 0, y = 5 },
    calculate = function (self, blind, context)
        if context.individual and context.cardarea == G.play and not blind.disabled then
            
            blind.debuff.current_money = blind.debuff.current_money or G.GAME.dollars
            local old_money = blind.debuff.current_money or G.GAME.dollars
            blind.debuff.current_money = blind.debuff.current_money * blind.debuff.akyrs_deduct_mult
            return {
                func = function ()
                    ease_dollars(-old_money + blind.debuff.current_money)
                end
            }
        end
    end
}
SMODS.Blind {
    key = "master_milk_crown_on_sonnetica",
    dollars = 14,
    mult = 2,
    boss_colour = HEX('5f848c'),
    debuff = {
        akyrs_blind_difficulty = "master",
    },
    config = {
        xscore = 0.75,
    },
    
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante, {ignore_showdown_check = true}
    end,
    loc_vars = function (self)
        return {
            vars = {
                self.config.xscore
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.config.xscore
            }
        }
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 12, max = 10},
    pos = { x = 0, y = 6 },
    calculate = function (self, blind, context)
        if context.individual and context.cardarea == G.play and not blind.disabled then
            if context.other_card:is_face() then
                return {
                    xscore = blind.effect.xscore
                }
            end
        end
    end
}
SMODS.Blind {
    key = "master_bug",
    dollars = 14,
    mult = 2,
    boss_colour = HEX('4de740'),
    debuff = {
        akyrs_blind_difficulty = "master",
    },
    
    in_pool = function (self)
        return G.GAME.round_resets.ante >= G.GAME.win_ante, {ignore_showdown_check = true}
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 12, max = 10},
    pos = { x = 0, y = 7 },
    calculate = function (self, blind, context)
        if context.after and not context.repetition and not blind.disabled then
            return {
                func = function ()
                    local jkrs = AKYRS.get_non_eternals(G.jokers, blind)
                    if #jkrs > 0 then
                        local card_to_destroy = pseudorandom_element(jkrs, "akyrs_bug_destroy")
                        if card_to_destroy then
                            SMODS.destroy_cards({card_to_destroy})
                        end
                    end
                end
            }

        end
    end
}

SMODS.Blind {
    key = "ultima_lost_umbrella",
    dollars = 14,
    mult = 3,
    boss_colour = HEX('595959'),
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "ultima",
        akyrs_is_endless_blind = true,
        akyrs_cannot_be_overridden = true,
        akyrs_cannot_be_skipped = true,
    },
    config = {
        cards_left = 2  
    },
    loc_vars = function (self)
        return {
            vars = {
                self.config.cards_left,
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                self.config.cards_left,
            }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante >= self.boss.min and G.GAME.won, {ignore_showdown_check = true}
    end,
    drawn_to_hand = function (self)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(true)
        end
    end,
    press_play =function (self)
        if G.jokers.cards[1] then
            self.triggered = true
            self.prepped = true
        end
    end,
    disable = function (self)
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(false)
        end 
    end,
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 9, max = 10},
    pos = { x = 0, y = 8 },
    calculate = function (self, blind, context)
        if context.remove_playing_cards then
            return {
                func = function ()
                    blind.effect.cards_left = blind.effect.cards_left - #context.removed
                    if blind.effect.cards_left <= 0 then
                        AKYRS.force_disable_blind()
                    end
                end
            }
        end
    end
}


SMODS.Blind{
    key = "the_thought",
    dollars = 5,
    mult = 2,
    boss_colour =HEX('95df3e'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 0 },
    debuff = {
        special_blind = true,
        infinite_discards = true,
        akyrs_is_word_blind = true,
        akyrs_is_puzzle_blind = true,
    },
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        G.GAME.word_todo = AKYRS.aiko_pickRandomInTable(AKYRS.puzzle_words)
        
        
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
        
        --print ("Word is "..G.GAME.word_todo)
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    G.hand:change_size(3)                    
                    G.GAME.current_round.discards_sub = G.GAME.current_round.discards_left + 1
                    self.discards_sub = G.GAME.current_round.discards_left + 1 -- math.max(G.GAME.current_round.discards_left, 0)
                    ease_discard(-self.discards_sub)
                    
                    G.GAME.current_round.hand_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
                    self.hands_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
                    ease_hands_played(-self.hands_sub)
                    ease_background_colour{new_colour = HEX('95df3e'), special_colour = HEX('ffd856'), tertiary_colour = G.C.BLACK, contrast = 3}
                    
                    return true
                end
            })
        )
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    recalculateHUDUI()
                    recalculateBlindUI()
                    return true
                end
            })
        )
        -- add 5 temp wilds to hand so players don't get fucked royally
        AKYRS.simple_event_add(
            function ()
                AKYRS.fill_hand()
                for i = 1, 5 do
                    AKYRS.simple_event_add(
                        function ()
                            local wldcrd = Card(11.5,15,G.CARD_W,G.CARD_H,pseudorandom_element(G.P_CARDS,pseudoseed("thethoughtblind")),G.P_CENTERS['c_base'],{playing_card = G.playing_card})
                            wldcrd.is_null = true
                            wldcrd.ability.akyrs_self_destructs = true
                            AKYRS.change_letter_to(wldcrd,"#")
                            G.hand:emplace(wldcrd)
                            return true
                        end, 0.1
                    )
                end
                return true
            end, 0
        )
    end,
    drawn_to_hand = function(self)
        AKYRS.simple_event_add(
            function()
                G.deck:shuffle("akyrsthought")
                G.FUNCS.draw_from_discard_to_deck()
                return true
            end,0.2
        )
    end,
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and not G.GAME.akyrs_has_not_spelled_a_single_word)
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        ease_hands_played(self.hands_sub or G.GAME.current_round.hand_sub)
        ease_discard(self.discards_sub or G.GAME.current_round.discards_sub)
        
        recalculateHUDUI()
        recalculateBlindUI()
        
    end,
    defeat = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
        recalculateHUDUI()
        recalculateBlindUI()
    end,
    calculate = function (self, blind, context)
        if context.after then
            return {
                func =function ()
                    
                    if true then
                        AKYRS.simple_event_add(
                            function()
                                AKYRS.force_check_win({ force_draw = true})
                                return true
                            end, 0
                        )
                    end
                end
            }
        end
    end

}

SMODS.Blind{
    key = "the_bomb",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('FF6F4B'),
    atlas = 'aikoyoriBlindsChips2', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 14 },
    debuff = {
        special_blind = true,
        infinite_discards = true,
        akyrs_is_word_blind = true,
        akyrs_is_puzzle_blind = true,
        akyrs_cannot_be_disabled = true,
    },
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        
        
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
        
        --print ("Word is "..G.GAME.word_todo)
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    --ease_background_colour{new_colour = HEX('95df3e'), special_colour = HEX('ffd856'), tertiary_colour = G.C.BLACK, contrast = 3}
                    G.hand:change_size(9)
                    SMODS.change_play_limit(1e4)
                    SMODS.change_discard_limit(1e4)
                    
                    for _, _c in ipairs(G.jokers.cards) do
                        ---@type Card
                        _c = _c
                        _c:set_debuff(true)
                    end
                    for _, _c in ipairs(G.consumeables.cards) do
                        ---@type Card
                        _c = _c
                        _c:set_debuff(true)
                    end
                    return true
                end
            })
        )
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    recalculateHUDUI()
                    recalculateBlindUI()
                    return true
                end
            })
        )
        -- add 5 temp wilds to hand so players don't get fucked royally
        AKYRS.simple_event_add(
            function ()
                AKYRS.fill_hand()
                for i = 2, 5 do
                    AKYRS.simple_event_add(
                        function ()
                            local prompt_card = Card(11.5,15,G.CARD_W,G.CARD_H,pseudorandom_element(G.P_CARDS,pseudoseed("thebombblind")),G.P_CENTERS['c_base'],{playing_card = G.playing_card})
                            prompt_card.is_null = true
                            prompt_card.ability.akyrs_attention = true
                            AKYRS.simple_event_add(
                                function ()
                                    local ante = Talisman and to_number(G.GAME.round_resets.ante) or G.GAME.round_resets.ante
                                    local fct = 2 * (i - 1) - 1
                                    local max_freq = (70000/(fct))/ante^1.5 / (AKYRS.config.full_dictionary and 1 or 10)
                                    local min_freq = (15000/(fct))/ante^1.03 / (AKYRS.config.full_dictionary and 1 or 10)
                                    local prompt, freq = AKYRS.get_bomb_prompt(
                                    {
                                        min_freq = min_freq, 
                                        max_freq = max_freq, 
                                        min_length = i, 
                                        max_length = i, 
                                        seed = "thebombblind_carder"
                                    })
                                    if prompt then
                                        AKYRS.change_letter_to(prompt_card,prompt)
                                        prompt_card.ability.akyrs_word_freq = freq
                                        G.hand:emplace(prompt_card)
                                        table.insert(G.playing_cards, prompt_card)
                                    end
                                    return true
                                end, 0)
                            return true
                        end, 0.2
                    )
                end
                return true
            end, 0
        )
    end,
    drawn_to_hand = function(self)
        AKYRS.simple_event_add(
            function()
                G.deck:shuffle("akyrsthought")
                G.FUNCS.draw_from_discard_to_deck()
                return true
            end,0.2
        )
    end,
    in_pool = function(self)
        return (G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and not G.GAME.akyrs_has_not_spelled_a_single_word)
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        
        for _, _c in ipairs(G.jokers.cards) do
            ---@type Card
            _c = _c
            _c:set_debuff(false)
        end
        for _, _c in ipairs(G.consumeables.cards) do
            ---@type Card
            _c = _c
            _c:set_debuff(false)
        end
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
        G.hand:change_size(-9)
        SMODS.change_play_limit(-1e4)
        SMODS.change_discard_limit(-1e4)
        
        recalculateHUDUI()
        recalculateBlindUI()
        
    end,
    defeat = function(self)
        G.GAME.current_round.advanced_blind = false
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
        G.hand:change_size(-9)
        SMODS.change_play_limit(-1e4)
        SMODS.change_discard_limit(-1e4)
        recalculateHUDUI()
        recalculateBlindUI()
        for _, _c in ipairs(G.consumeables.cards) do
            ---@type Card
            _c = _c
            _c:set_debuff(false)
        end
    end,
    press_play = function(self)
        
    end,
    calculate = function (self, blind, context)
        if context.debuff_hand then 
            
            local hand = context.full_hand
            table.sort(hand, AKYRS.hand_sort_function)
            local s = AKYRS.word_hand_combine(hand)
            local hand_return, word_data = AKYRS.word_hand_search(s, hand, #s)
            if not ((word_data or {}).valid) then
            return {
                debuff = true,
                debuff_text = localize("k_akyrs_must_contain_word"),
                func = function ()
                    AKYRS.simple_event_add(
                        function()
                            if G.STATE == G.STATES.HAND_PLAYED then
                                G.FUNCS.akyrs_force_draw_from_discard_to_hand()
                            else
                        end
                        return true
                    end, 0)
                end
                }
            end
            
        end
        if context.after then
            return {
                func = function ()
                    
                    for _, _c in ipairs(G.jokers.cards) do
                        ---@type Card
                        _c = _c
                        _c:set_debuff(true)
                    end
                    for _, _c in ipairs(G.consumeables.cards) do
                        ---@type Card
                        _c = _c
                        _c:set_debuff(true)
                    end
                    
                    AKYRS.simple_event_add(
                        function()
                            G.deck:shuffle("akyrsbombblind")
                            G.FUNCS.draw_from_discard_to_deck()
                            return true
                        end,0.2
                    )
                    AKYRS.simple_event_add(
                        function()
                            if not G.GAME.akyrs_win_checked then
                                
                                AKYRS.simple_event_add(
                                function()
                                    local attention_no_longer_in_hand = true
                                    for _,_c in ipairs(G.playing_cards) do
                                        if _c.ability.akyrs_attention then
                                            attention_no_longer_in_hand = false
                                        end
                                    end
                                    G.GAME.aiko_puzzle_win = attention_no_longer_in_hand
                                    if true then
                                        AKYRS.simple_event_add(
                                            function()
                                                AKYRS.force_check_win({ force_draw = true})
                                                return true
                                            end, 0
                                        )
                                    end
                                    return true
                                end, 0.2)
                            end
                            return true
                        end,0.2
                    )
                end
            }
        end
    end
}


SMODS.Blind{
    key = "the_bent",
    dollars = 5,
    mult = 2,
    boss_colour = HEX("ff5454"),
    atlas = 'aikoyoriBlindsChips2',
    debuff = {
        special_blind = true,
        akyrs_is_puzzle_blind = true,
    },
    config = {
        times_left = 2,
    },
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 0 },
    in_pool = function(self)
        return G.GAME.round_resets.hands > 1 and G.GAME.round_resets.ante >= self.boss.min
    end,
    loc_vars = function (self)
        return {
            vars = {
                localize(G.GAME.current_round.akyrs_picked_poker_hands, "poker_hands") or "????",
                self.config.times_left,
            }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = {
                localize("k_akyrs_random_played_hand"),
                self.config.times_left,
            }
        }
    end,
    set_blind = function (self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        recalculateBlindUI()
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        recalculateBlindUI()
    end,
    calculate = function (self, blind, context)
        if not blind.disabled then
            if context.before then
                if context.scoring_name == G.GAME.current_round.akyrs_picked_poker_hands then
                    SMODS.calculate_effect({
                        func = function ()
                            blind.effect.times_left = (blind.effect.times_left) - 1
                            if blind.effect.times_left <= 0 then
                                G.GAME.aiko_puzzle_win = true
                            end                         
                        end
                    }, blind)
                end
                return {
                    func = function ()
                        AKYRS.simple_event_add(
                            function()
                                AKYRS.force_check_win({ force_draw = true, state_to_go = G.STATES.SELECTING_HAND })
                                return true
                            end, 0
                        )
                        recalculateBlindUI()

                    end
                }
            end
        end
    end,
}
