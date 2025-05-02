AKYRS.LetterJoker = SMODS.Joker:extend{
    in_pool = function (self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled or false
    end
}

-- repeater
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 0
    },
    key = "redstone_repeater",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 1,
            mult = 2,
            starting_mult = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_stored, card.ability.extra.mult, card.ability.extra.starting_mult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card then
            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            card.ability.extra.mult_stored = stored
            update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })
            return {
                message = "Swapped!",
                xmult = card.ability.extra.mult,
            }
        end
    end,
    blueprint_compat = true
}


local NON_STONE_UPGRADES = {}
for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
    if v.key ~= 'm_stone' then
        NON_STONE_UPGRADES[#NON_STONE_UPGRADES + 1] = v
    end
end
-- observer
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 1,
        y = 0
    },
    key = "observer",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 2,
            mult = 4,
            times = 2,
            total_times = 2,
            times_increment = 1,
            mult_change = 0,
            chip_change = 0
        },
        name = "Observer"
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult_stored, card.ability.extra.times,
                card.ability.extra.total_times, card.ability.extra.times_increment }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult_stored,
            }
        end
    end,
    blueprint_compat = true
}
-- quasi connectivity
SMODS.Joker {

    atlas = 'AikoyoriJokers',
    pos = {
        x = 2,
        y = 0
    },
    key = "quasi_connectivity",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    config = {
        name = "Quasi Connectivity",
        extra = {
            mult = 6,
            first_hand = true
        }
    },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local quasiCount = 0
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == "Quasi Connectivity" then
                    quasiCount = quasiCount + 1
                end
                if (G.jokers.cards[i] ~= card or #G.jokers.cards < 2) then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end

                G.jokers.cards[i]:set_debuff(false)
            end
            -- remove the current card from the list
            if not G.GAME.aiko_has_quasi then
                jokers[card] = nil
                G.GAME.aiko_has_quasi = true
            end
            for i = 1, quasiCount do
                if (#jokers > 0) then
                    local _card = pseudorandom_element(jokers, pseudoseed('akyrj:quasi_connectivity'))
                    if _card then
                        _card:set_debuff(true)
                        _card:juice_up(1, 1)
                    end
                    jokers[_card] = nil
                end
            end
            G.GAME.aiko_has_quasi = false
            card.ability.extra.first_hand = false
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.mult,
            }
        end
        if context.selling_card then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:set_debuff(false)
                end
            end
        end
    end,
    blueprint_compat = true
}
-- diamond pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 3,
        y = 0
    },
    key = "diamond_pickaxe",
    rarity = 2,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Diamond Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 2,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                for i = 1, card.ability.extra.chip_add_stack do
                    context.other_card:juice_up(0.5, 2)
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                return {
                    juice_card = context.other_card,
                    func = function ()
                        context.other_card:set_ability(
                            pseudorandom_element(NON_STONE_UPGRADES, pseudoseed('akyrj:pickaxe')), nil, true)
                                
                    end
                }
            end
        end
    end,
    blueprint_compat = false
}
-- netherite pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 4,
        y = 0
    },
    key = "netherite_pickaxe",
    rarity = 2,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Netherite Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 5,
        }
    },
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        
        if AKYRS.config.show_joker_preview then
            local cards = {}
            for i = 1,5 do
                local carder = AKYRS.create_random_card("netheritepick")
                carder:set_ability(G.P_CENTERS["m_stone"], true)
                table.insert(cards, carder)
            end
            AKYRS.card_area_preview(G.akyrsCardsPrev, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.2,
                h = 0.6,
                ml = 0,
                scale = 0.5,
                func_delay = 1.0,
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                k:start_dissolve({G.C.CHIPS}, true)
                            end
                        end
                    end
                end,
            })
        end
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                context.other_card.ability.aiko_about_to_be_destroyed = true
                for i = 1, card.ability.extra.chip_add_stack do
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                
            end
        end

        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.destroy_card.ability.eternal then
            
            if context.destroy_card.ability.aiko_about_to_be_destroyed then
                return { remove = true }
            end
        end
    end,
    blueprint_compat = false
}
-- utage charts
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 5,
        y = 0
    },
    key = "utage_charts",
    rarity = 3,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.play_mod }
        }
    end,
    config = {
        name = "Playable Cards",
        play_mod = 1,
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable + card.ability.play_mod
        G.hand:aiko_change_playable(card.ability.play_mod)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable - card.ability.play_mod
        G.hand:aiko_change_playable(-card.ability.play_mod)
    end,
    blueprint_compat = false,
}

local function is_valid_pool(name)
    return G.P_CENTER_POOLS[name] and true or false
end

-- it is forbidden to dog
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 7,
        y = 0
    },
    key = "it_is_forbidden_to_dog",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                card.ability.extra.mult
             }
        }
    end,
    config = {
        extra = {
            mult = 1.5,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.other_card.debuff and not context.end_of_round and 
        (   context.cardarea == G.play or 
            context.cardarea == G.hand ) then
            return {
                xmult = card.ability.extra.mult
            }
        end
    end,
    blueprint_compat = true,
}

-- eat pant
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 8,
        y = 0
    },
    key = "eat_pant",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                math.floor(card.ability.extra.card_target),
                card.ability.extra.extra,
                card.ability.extra.Xmult,
             }
        }
    end,
    config = {
        extra = {
            extra = 0.4,
            card_target = 4,
            Xmult = 1,
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then	
            return {
                xmult = card.ability.extra.Xmult
            }
        end
        if context.individual and context.cardarea == G.play and #context.full_hand == math.floor(card.ability.extra.card_target) then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.extra
            return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
        end		
        if context.destroy_card and (context.cardarea == G.play or context.cardarea == 'unscored') and not context.blueprint and not context.destroy_card.ability.eternal then
            if #context.full_hand == math.floor(card.ability.extra.card_target) then
                return { remove = true }
            end
        end
    end,
    blueprint_compat = true,
}


-- tsunagite
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 9,
        y = 0
    },
    soul_pos = {
        x = 9,
        y = 1
    },
    key = "tsunagite",
    rarity = 4,
    cost = 30,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "akyrs_chip_mult_xchip_xmult", set = 'Other', vars = { 
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.Xchips,
            card.ability.extra.Xmult, } }
        info_queue[#info_queue+1] = {key = "akyrs_gain_chip_mult_xchip_xmult", set = 'Other', vars = { 
            card.ability.extra.gain_chips,
            card.ability.extra.gain_mult,
            card.ability.extra.gain_Xchips,
            card.ability.extra.gain_Xmult } }
        info_queue[#info_queue+1] = {key = "akyrs_tsunagite_scores", set = 'Other', }
        return {
            vars = { 
                card.ability.extra.total,
            }
        }
    end,
    config = {
        extra = {
            total = 15,
            chips = 15,
            Xchips = 1.15,
            mult = 15,
            Xmult = 1.15,
            base_chips = 15,
            base_Xchips = 1.15,
            base_mult = 15,
            base_Xmult = 1.15,
            gain_chips = 15,
            gain_Xchips = 0.05,
            gain_mult = 5,
            gain_Xmult = 0.05,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local total = 0
            for i,k in ipairs(G.play.cards) do

                if not SMODS.has_no_rank(k)then
                    total = total + k.base.nominal
                    if k.base.value == 'Ace' then
                        total = total - 10
                    end                    
                end

            end
            if total <= 15 then
                return {
                    chips = card.ability.extra.chips,
                    xchips = card.ability.extra.Xchips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.Xmult
                }
            end

        end		
        if context.using_consumeable then
            if context.consumeable.config.center_key == 'c_wheel_of_fortune' then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain_chips 
                card.ability.extra.Xchips = card.ability.extra.Xchips + card.ability.extra.gain_Xchips 
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain_mult 
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.gain_Xmult
                SMODS.calculate_effect({
                    message= localize('k_upgrade_ex')
                }, card)
            end
        end
        --[[
        if context.end_of_round then
            if G.GAME.blind.boss and (
                card.ability.extra.chips ~= card.ability.extra.base_chips or
                card.ability.extra.Xchips ~= card.ability.extra.base_Xchips or
                card.ability.extra.mult ~= card.ability.extra.base_mult or
                card.ability.extra.Xmult ~= card.ability.extra.base_Xmult  
            ) then
                card.ability.extra.chips = card.ability.extra.base_chips
                card.ability.extra.Xchips = card.ability.extra.base_Xchips 
                card.ability.extra.mult = card.ability.extra.base_mult 
                card.ability.extra.Xmult = card.ability.extra.base_Xmult 
                SMODS.calculate_effect({
                    message= localize('k_reset')
                }, card)
            end
        end]]
    end,
    blueprint_compat = true,
}


-- yona yona dance
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 1
    },
    key = "yona_yona_dance",
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        if AKYRS.config.show_joker_preview then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_yona_yona_ex"]
        end
        return {
            vars = { 
                card.ability.extra.times,
             }
        }
    end,
    config = {
        extra = {
            times = 2
        },
    },

    calculate = function(self, card, context)
        if context.repetition and (context.other_card:get_id() == 4 or context.other_card:get_id() == 7) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.times,
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "tldr_joker",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 6,
        y = 1
    },
    soul_pos = {
        x = 7,
        y = 1
    },
    rarity = 1,
    cost = 2,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_tldr_tldr", vars = {card.ability.extra.mult}}
        return {
            vars = { 
                card.ability.extra.mult,
             }
        }
    end,
    config = {
        extra = {
            mult = 2
        },
    },
    calculate = function(self, card, context)
        if context.joker_main or context.individual and not context.end_of_round and (context.cardarea == G.hand or context.cardarea == G.play) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "reciprocal_joker",
    pos = {
        x = 1,
        y = 1
    },
    rarity = 1,
    cost = 2,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    config = {
        extra = {
        },
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize('k_akyrs_reciprocaled'),
                func = function()
                    mult = mod_mult(hand_chips / mult)
                    
                    update_hand_text({ delay = 0, immediate = false }, { mult = mult, chips = hand_chips })
                end
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "kyoufuu_all_back",
    pos = {
        x = 2,
        y = 1
    },
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    config = {
        extra = {
        },
    },
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_left == 1 then
            return {
                message = localize('k_akyrs_drawn_discard'),
                func = function()
                    G.FUNCS.draw_from_discard_to_deck()
                end
            }
        end
    end,
    blueprint_compat = false,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "2fa",
    pos = {
        x = 3,
        y = 1
    },
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        if AKYRS.config.show_joker_preview then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_2fa_example"]
        end
        return {
            vars = {
                card.ability.extra.extra,
                card.ability.extra.chips
            }
        }
    end,
    config = {
        extra = {
            chips = 0,
            extra = 8,
        },
    },
    calculate = function(self, card, context)
        if context.before then
            
            for i, _card in ipairs(G.play.cards) do
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.extra
            end
            return {
                message = localize("k_akyrs_2fa_generate")
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers  then
            return {
                message = localize("k_akyrs_2fa_reset"),
                func = function ()
                    card.ability.extra.chips = 0
                end
            }
        end
        if context.after and not context.blueprint then
            
            for i, _card in ipairs(G.play.cards) do
                local percent = math.abs(1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3)
                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    blocking = false,
                    delay = 0.2*i*AKYRS.get_speed_mult(_card),
                    func = function ()
                        if G.play and G.play.cards then
                            local percent = math.abs(1.15 - (i-0.999)/(#G.play.cards-0.998)*0.3)
                            if G.play.cards[i] then
                                G.play.cards[i]:flip()
                            end
                            --G.play.cards[i]:a_cool_fucking_spin(1,math.pi * 100)
                            play_sound('card1', percent);
                        end
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    delay = 0.5*AKYRS.get_speed_mult(card)+0.2*i*AKYRS.get_speed_mult(_card),
                    blocking = false,
                    func = function ()
                            
                        if G.play and G.play.cards then
                            local _rank = nil
                            local _suit = nil
                            while _rank == nil or _suit == nil do
                                _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('akyrs2far'))
                                _suit = pseudorandom_element(SMODS.Suits, pseudoseed('akyrs2fas'))
                            end
                            
                            
                            --G.play.cards[i]:a_cool_fucking_spin(1,10)
                            
                            if G.play.cards[i] then
                                SMODS.change_base(G.play.cards[i],_suit.key,_rank.key)
                                G.play.cards[i]:flip()
                            end
                            
                        end

                        return true
                    end
                })
            end
            delay((0.5*AKYRS.get_speed_mult(card)+0.2*#G.play.cards))
            return {
                message = localize("k_akyrs_2fa_regen"),
                
            }
        end
    end,
    blueprint_compat = false,
}

-- gaslighting 
SMODS.Joker{
    
    atlas = 'AikoyoriJokers',
    key = "gaslighting",
    pos = {
        x = 4,
        y = 1
    },
    rarity = 3,
    cost = 3,
    config = {
        extra = {
            xmult = 1,
            extra = 0.5,
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.extra,
                card.ability.extra.xmult,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.final_scoring_step and G.GAME.blind then
            
                local comp = false
                if Talisman then
                    comp = G.GAME.blind.chips:lt(G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult)
                else
                    
                    comp = G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult >= G.GAME.blind.chips
                end
                G.E_MANAGER:add_event(
                    Event{
                        func = function ()
                            local comp = false
                            if Talisman then
                                comp = G.GAME.blind.chips:lt(G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult)
                            else
                                
                                comp = G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult >= G.GAME.blind.chips
                            end
                            if comp then
                                card.ability.extra.xmult = 1
                            else 
                                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.extra
                            end
                            return true
                        end
                    }
                )
                if comp then
                    return {
                        message = localize("k_akyrs_extinguish")
                    }
                else 
                    return {
                        message = localize("k_akyrs_burn"),
                    }
                end
        end
    end
}

-- hibana 
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "hibana",
    pos = {
        x = 5,
        y = 1
    },
    soul_pos = {
        x = 8,
        y = 1
    },
    rarity = 3,
    cost = 7,
    config = {
        extra = {
            possible_table = {
                {"Ace", "Rank", {"k_aces", "dictionary"}},
                {"Face Cards", "Condition", {"k_face_cards","dictionary"}},
                {"Hearts", "Suit", {"Hearts", 'suits_plural'}},
                {"5", "Rank", {"5", "ranks"}}
            },
        },
        akyrs_cycler = 1,
        akyrs_priority_draw_rank = "Ace",
        akyrs_priority_draw_suit = nil,
        akyrs_priority_draw_conditions = nil,
    },
    loc_vars = function(self, info_queue, card)
        if card.ability.akyrs_cycler ~= 1 and card.ability.akyrs_cycler ~= 2 and card.ability.akyrs_cycler ~= 3 and card.ability.akyrs_cycler ~= 4 then
            card.ability.akyrs_cycler = 1
        end
        local table = card.ability.extra.possible_table[math.floor(card.ability.akyrs_cycler)]
        info_queue[#info_queue+1] = { key = "dd_akyrs_hibana_conditions", set = "DescriptionDummy"}
        return {
            vars = {
                localize(table[3][1],table[3][2]),
                card.ability.akyrs_cycler,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            if card.ability.akyrs_cycler ~= 1 and card.ability.akyrs_cycler ~= 2 and card.ability.akyrs_cycler ~= 3 and card.ability.akyrs_cycler ~= 4 then
                card.ability.akyrs_cycler = 1
            end
            card.ability.akyrs_priority_draw_rank = nil
            card.ability.akyrs_priority_draw_suit = nil
            card.ability.akyrs_priority_draw_conditions = nil
            card.ability.akyrs_cycler = math.fmod(card.ability.akyrs_cycler,#(card.ability.extra.possible_table)) + 1
            local curr = card.ability.extra.possible_table[card.ability.akyrs_cycler]
            if curr[2] == "Rank" then
                card.ability.akyrs_priority_draw_rank = curr[1]
            end
            if curr[2] == "Suit" then
                card.ability.akyrs_priority_draw_suit = curr[1]
            end
            if curr[2] == "Condition" then
                card.ability.akyrs_priority_draw_conditions = curr[1]
            end
            return {
                message = localize('k_akyrs_hibana_change')
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)        
        card.ability.akyrs_cycler = math.floor(card.ability.akyrs_cycler)
        card.ability.akyrs_priority_draw_rank = nil
        card.ability.akyrs_priority_draw_suit = nil
        card.ability.akyrs_priority_draw_conditions = nil
        local curr = card.ability.extra.possible_table[card.ability.akyrs_cycler]
        if curr[2] == "Rank" then
            card.ability.akyrs_priority_draw_rank = curr[1]
        end
        if curr[2] == "Suit" then
            card.ability.akyrs_priority_draw_suit = curr[1]
        end
        if curr[2] == "Condition" then
            card.ability.akyrs_priority_draw_conditions = curr[1]
        end
        if G.deck then
            G.deck:shuffle()
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        if G.deck then
            G.deck:shuffle()
        end
    end
}


-- HOLY SHIT NEW PAGE this one is dedicated to the letters
-- update nevermind i add whatever the fuck i wanna

-- maxwell's notebook
AKYRS.LetterJoker {
    atlas = 'guestJokerArts',
    pos = {
        x = 0,
        y = 0
    },
    key = "maxwells_notebook",
    rarity = 3,
    cost = 4,
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

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "centrifuge",
    pos = {
        x = 0, y = 2
    },
    rarity = 1,
    cost = 2,
    config = {
        extra = {
            rank_delta = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                1
            }
        }
    end,
    calculate = function (self, card, context)
        if context.after and #G.play.cards >= 3 and not context.blueprint then

            for i, card2 in ipairs(G.play.cards) do
                
                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    blocking = false,
                    -- the abs thing is so it does the center to the sides effect
                    -- TODO: Maybe make it flip from center to border like a centrifuge, not priority tho
                    delay = 0.2*i*AKYRS.get_speed_mult(card),
                    func = function ()
                        if G.play and G.play.cards then
                            local percent = math.abs(1.15 - (i-0.999)/(#G.play.cards-0.998)*0.3)
                            if G.play.cards[i] then
                                G.play.cards[i]:flip()
                            end
                            play_sound('card1', percent);
                        end
                        return true
                    end
                })
                G.E_MANAGER:add_event(
                    Event{
                        trigger = 'after',
                        delay = 0.5*AKYRS.get_speed_mult(card)+(0.2*i)*AKYRS.get_speed_mult(card),
                        func = function ()
                            local rankToChangeTo = card2.base.value
                            if i == 1 or i == #G.play.cards then
                                rankToChangeTo = pseudorandom_element(SMODS.Ranks[card2.base.value].next,pseudoseed("akyrscentrifuge"))
                            else
                                rankToChangeTo = pseudorandom_element(SMODS.Ranks[card2.base.value].prev,pseudoseed("akyrscentrifuge"))
                            end
                            card2:flip()
                            card2 = SMODS.change_base(card2, nil, rankToChangeTo)
                            return true
                        end
                    }
                )
            end
            delay(0.5*AKYRS.get_speed_mult(card)+0.2*#G.play.cards)
            return {
                message = localize("k_akyrs_centrifuged")
            }
        end
    end

}

AKYRS.LetterJoker{
    atlas = 'AikoyoriJokers',
    key = "henohenomoheji",
    pos = {
        x = 6, y = 0
    },
    rarity = 1,
    cost = 2,
    config = {
        name = "Henohenomoheji",
    },

}

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "neurosama",
    pos = {
        x = 1, y = 2
    },
    rarity = 3,
    cost = 6,
    config = {
        name = "Neuro Sama",
        extras = {
            xmult = 1,
            xmult_inc = 0.1,
        }
    },
    loc_vars = function (self,info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult,
                card.ability.extras.xmult_inc
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Hearts") or (context.other_card:is_suit("Spades") and SMODS.find_card("j_akyrs_evilneuro")) then
                return {
                    message = localize("k_upgrade_ex"),
                    func = function ()
                        card.ability.extras.xmult = card.ability.extras.xmult + card.ability.extras.xmult_inc
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

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "evilneuro",
    pos = {
        x = 2, y = 2
    },
    rarity = 3,
    cost = 6,
    config = {
        name = "Evil Neuro",
        extras = {
            xchips = 1,
            xchips_inc = 0.1,
        }
    },
    loc_vars = function (self,info_queue, card)
        return {
            vars = {
                card.ability.extras.xchips,
                card.ability.extras.xchips_inc
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Clubs") or (context.other_card:is_suit("Diamonds") and SMODS.find_card("j_akyrs_neurosama")) then
                return {
                    message = localize("k_upgrade_ex"),
                    func = function ()
                        card.ability.extras.xchips = card.ability.extras.xchips + card.ability.extras.xchips_inc
                    end
                }
            end
        end
        if context.joker_main then
            return {
                xchips = card.ability.extras.xchips
            }
        end
    end,
    blueprint_compat = true
}



-- happy ghast family

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "dried_ghast",
    pos = {
        x = 3, y = 2
    },
    rarity = 1,
    cost = 3,
    config = {
        name = "Dried Ghast",
        extras = {
            rounds_left = 2
        }
    },
    loc_vars = function (self,info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_ghastling"]
        return {
            vars = {
                card.ability.extras.rounds_left,
                2
            }
        }
    end,
    calculate = function (self, card, context)
        if context.setting_blind and not context.blueprint then
            return {
                message = localize("k_akyrs_dried"),
                func = function ()
                    card.ability.current_round_discards = G.GAME.round_resets.discards
                    G.GAME.current_round.discards_left = 0
                end
            }
        end
        if context.selling_card and context.card == card and not context.blueprint then
            G.GAME.current_round.discards_left = card.ability.current_round_discards 
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if not card.ability.do_not_decrease then
                return {
                    message = localize("k_akyrs_moisture"),
                    func = function ()
                        card.ability.extras.rounds_left = card.ability.extras.rounds_left - 1
                        if card.ability.extras.rounds_left <= 0 then
                            card:start_dissolve({G.C.BLUE}, nil, 0.5)
                            SMODS.add_card({ key = "j_akyrs_ghastling"})
                        end
                    end
                }
            else
                return {
                    func = function ()
                        card.ability.do_not_decrease = false
                    end
                }
            end

        end
        if context.final_scoring_step and not context.blueprint then
            if AKYRS.score_catches_fire_or_not() then
                return {
                    message = localize("k_reset"),
                    func = function ()
                        card.ability.extras.rounds_left = 2
                        card.ability.do_not_decrease = true
                    end
                }
            end
        end
    end,
}

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "ghastling",
    pos = {
        x = 4, y = 2
    },
    rarity = 2,
    cost = 6,
    config = {
        name = "Ghastling",
        extras = {
            rounds_left = 10,
            mult = 21.6
        }
    },
    in_pool = function (self, args)
        return false
    end,
    loc_vars = function (self,info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_happy_ghast"]
        return {
            vars = {
                card.ability.extras.rounds_left,
                card.ability.extras.mult,
                3
            }
        }
    end,
    calculate = function (self, card, context)
        if context.after and context.cardarea == G.jokers and not context.blueprint then
            if not card.ability.do_not_decrease then
                return {
                    message = localize("k_akyrs_growth"),
                    func = function ()
                        card.ability.extras.rounds_left = card.ability.extras.rounds_left - (#SMODS.find_card("j_ice_cream") + 1)
                        if card.ability.extras.rounds_left <= 0 then
                            card:start_dissolve({G.C.RED}, nil, 0.5)
                            SMODS.add_card({ key = "j_akyrs_happy_ghast"})
                        end
                    end
                }
            else
                return {
                    func = function ()
                        card.ability.do_not_decrease = false
                    end
                }
            end

        end
        if context.joker_main then
            return {
                mult = card.ability.extras.mult
            }
        end
    end,
    blueprint_compat = true
}


SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "happy_ghast",
    pos = {
        x = 5, y = 2
    },
    rarity = 3,
    cost = 10,
    config = {
        name = "Happy Ghast",
        extras = {
            xmult = 4.2
        }
    },
    in_pool = function (self, args)
        return false
    end,
    loc_vars = function (self,info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end,
    blueprint_compat = true
}

-- charred roach
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "charred_roach",
    pos = {
        x = 6, y = 2
    },
    rarity = 2,
    cost = 6,
    config = {
        name = "Charred Roach",
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
        info_queue[#info_queue+1] = G.P_CENTERS["e_akyrs_burnt"]
        
    end,
    calculate = function (self, card, context)
        if context.akyrs_card_remove and not SMODS.get_enhancements(context.card_getting_removed)['e_akyrs_burnt'] and context.card_getting_removed ~= card
        and not (context.card_getting_removed.config and context.card_getting_removed.config.center_key and context.card_getting_removed.config.center_key == "j_akyrs_ash_joker") then
            return {
                func = function ()
                    if context.card_getting_removed.area == G.jokers then
                        local copy = copy_card(context.card_getting_removed,nil,nil,nil, true)
                        copy:set_edition('e_akyrs_burnt')
                        copy.sell_cost = 0
                        G.jokers:emplace(copy)
                    end
                end
            }
        end
        if context.remove_playing_cards and not context.blueprint then
            return {
                func = function ()
                    local new_cards = {}
                    for k, val in ipairs(context.removed) do
                        if not SMODS.get_enhancements(val)["m_akyrs_ash_card"] then
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local copy = copy_card(val,nil,nil,G.playing_card, true)
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, copy)
                            copy:set_edition('e_akyrs_burnt')
                            copy:add_to_deck()
                            copy.sell_cost = 0
                            G.hand:emplace(copy)
                            copy:start_materialize(nil)
                            new_cards[#new_cards+1] = copy
                        end

                    end

                    playing_card_joker_effects(new_cards)
                end
            }
        end
    end

}
-- ash joker
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "ash_joker",
    pos = {
        x = 7, y = 2
    },
    rarity = 1,
    cost = 0,
    in_pool = function (self, args)
        return false
    end,
    config = {
        name = "Ash Joker",
        extras = {
            chips = 35,
            odds = 4
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
        return {
            vars = {
                card.ability.extras.chips,
                G.GAME.probabilities.normal,
                card.ability.extras.odds,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extras.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            local odder = pseudorandom("burnt") < G.GAME.probabilities.normal / card.ability.extras.odds
            card.ability.akyrs_ash_disintegrate = odder
        end
    end
}
-- yee
AKYRS.LetterJoker{
    atlas = 'AikoyoriJokers',
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
            mult = 12
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
        return {
            vars = {
                card.ability.extras.chips,
                card.ability.extras.mult,
            }
        }
    end,
    calculate = function (self, card, context)
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
}
-- chicken jockey
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "chicken_jockey",
    pos = {
        x = 9, y = 2
    },
    rarity = 2,
    cost = 4,
    config = {
        name = "Chicken Jockey",
        extras = {
            xmult = 1,
            xmult_inc = 2,
            decrease_popcorn = 10,
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = localize{set = "Joker", key = "j_popcorn"}
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_placeholder_art"}
        return {
            vars = {
                card.ability.extras.xmult_inc,
                card.ability.extras.xmult,
                card.ability.extras.decrease_popcorn,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extras.xmult
            }
        end

        if context.akyrs_card_remove 
        and (context.card_getting_removed.config and context.card_getting_removed.config.center_key and context.card_getting_removed.config.center_key == "j_popcorn") then
            return {
                message = localize("k_upgrade_ex"),
                func = function ()
                    card.ability.extras.xmult = card.ability.extras.xmult + card.ability.extras.xmult_inc
                end
            }
        end
    end
}


-- TETORIS
AKYRS.tetoris_piece = {
    l = true,
    s = true,
    o = true,
    z = true,
    j = true,
    i = true,
    t = true,
}
AKYRS.LetterJoker {
    key = "tetoris",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0, y = 3
    },
    rarity = 3,
    cost = 7,
    config = {
        name = "Tetoris",
        extras = {
            chips = 10,
            xchips = 2.1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.chips,
                card.ability.extras.xchips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.akyrs_character_stickers_enabled then
            if AKYRS.tetoris_piece[string.lower(context.other_card:get_letter_with_pretend())] then
                return {
                    chips = card.ability.extras.chips,
                }
            end
        end
        if context.joker_main then
            local c = AKYRS.get_letter_freq_from_cards(G.play.cards)
            if (c["l"] or c["s"] or c["o"] or c["z"] or c["j"] or c["i"] or c["t"]) and G.GAME.akyrs_character_stickers_enabled then
                return {
                    xchips = card.ability.extras.xchips,
                }
            end
        end
    end
}
SMODS.Joker {
    key = "aikoyori",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 1, y = 3
    },
    soul_pos = {
        x = 2, y = 3
    },
    rarity = 4,
    cost = 7,
    config = {
        name = "Aikoyori",
        extras = {
            base = {
                xmult = 1.984
            }
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_base_ability", vars = {card.ability.extras.base.xmult}}
        if Cryptid then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_cryptid_ability"}
        end
        if SMODS.Mods.MoreFluff then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_more_fluff_ability"}
        end
        if Entropy then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_entropy_ability"}
            info_queue[#info_queue+1] = G.P_CENTERS["c_entr_flipside"]
        end
        if SDM_0s_Stuff_Mod then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_sdmstuff_ability"}
        end
        if togabalatro then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_togasstuff_ability"}
            info_queue[#info_queue+1] = {set = "Tag", key = "tag_toga_togajokershop"}
        end
        return {
            
        }
    end,
    calculate = function (self, card, context)
        if context.before then
            if Cryptid and #G.play.cards == 1 and G.play.cards[1]:get_id() == 14 then
                SMODS.add_card({set = "Code", area = G.consumeables, edition = "e_negative"})
            end
            if Entropy and #context.full_hand >= 4 then
                local suits_in_hand = {}
                local ranks_in_hand = {}
                local all_card_unique = true
                for i, k in ipairs(context.full_hand) do
                    if not SMODS.has_no_suit(k) and not SMODS.has_no_rank(k) then
                        if not suits_in_hand[k.base.suit] and not ranks_in_hand[k:get_id()] then
                            suits_in_hand[k.base.suit] = true
                            ranks_in_hand[k:get_id()] = true
                        else
                            all_card_unique = false
                            break
                        end
                    end
                end
                if all_card_unique then
                    SMODS.add_card({set = "Spectral", key = "c_entr_flipside", area = G.consumeables, edition = "e_negative"})
                end
            end
            if SDM_0s_Stuff_Mod then
                if next(context.poker_hands["Full House"]) then
                    SMODS.add_card({set = "Bakery", area = G.consumeables, edition = "e_negative"})
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                return {
                    xmult = card.ability.extras.base.xmult
                }
            end
        end
        if context.akyrs_round_eval then
            if togabalatro and context.dollars < 10 then
                local tag = Tag("tag_toga_togajokershop")
                add_tag(tag)
            end
        end
    end
}