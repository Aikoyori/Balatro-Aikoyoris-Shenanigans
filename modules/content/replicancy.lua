SMODS.ConsumableType{
    key = "Replicant",
    primary_colour = HEX("a30262"),
    secondary_colour = HEX("ff9a56"),
    collection_rows = { 4, 5 },
    shop_rate = 0,
    default = "c_akyrs_replicant_music_streaming"
}

SMODS.UndiscoveredSprite{
    key = "Replicant",
    atlas = "replicant_undisc",
    pos = {x=0, y=0}
}

SMODS.Consumable{
    key = "replicant_forecast",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=0, y=0},
    config = {
        extras = 2,
    },
    can_use = function (self, card)
        return true
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for i = 1, card.ability.extras do
            if not AKYRS.has_room(G.consumeables) then break end
            local _c = SMODS.add_card{set = "Replicant"}
            _c:juice_up(0.3,0.3)
        end
    end
}

SMODS.Consumable{
    key = "replicant_connection",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=1, y=0},
    config = {
        max_highlighted = 3,
        extras = 3,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "akyrs_crystalised" }
        return {
            vars = {
                card.ability.max_highlighted,
                card.ability.extras,
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _, c in ipairs(G.hand.highlighted) do
            for i = 1, card.ability.extras do
                AKYRS.simple_event_add(function ()
                    local cnew = AKYRS.copy_p_card(c, nil, nil, nil, nil, G.hand)
                    local s = pseudorandom_element(SMODS.Suits, "akyrs_replicant_connection_suit")
                    local r = pseudorandom_element(SMODS.Ranks, "akyrs_replicant_connection_rank")
                    SMODS.change_base(cnew, s.key, r.key)
                    SMODS.Stickers.akyrs_crystalised:apply(cnew, true)
                    SMODS.calculate_context({ playing_card_added = true, cards = { cnew }})
                    return true
                end, 0)
            end
        end
    end

}

SMODS.Consumable{
    key = "replicant_steganography",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=2, y=0},
    config = {
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_concealed", set = "Other" }
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        if AKYRS.has_room(G.jokers) then
            
        end
        for i = 1, card.ability.extras do
            AKYRS.simple_event_add(function ()
                if AKYRS.has_room(G.jokers) then
                    local cnew = SMODS.add_card{ set = "Joker", rarity = 'Rare'}
                    SMODS.Stickers.akyrs_concealed:apply(cnew, true)
                end
                return true
            end, 0)
        end
    end
}

SMODS.Consumable{
    key = "replicant_database",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=3, y=0},
    config = {
        extras = {
            add = 1,
            disca = 1,
            per_card = 3,
        },
    },
    select_card = 'consumeables',
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (math.max(G.GAME.starting_params.play_limit,G.GAME.starting_params.play_limit) + card.ability.extras.add),
                card.ability.extras.disca,
                card.ability.extras.per_card,
            }
        }
    end,
    can_use = function (self, card)
        return G.GAME.blind.in_blind
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local to_return = (math.max(G.GAME.starting_params.play_limit,G.GAME.starting_params.play_limit) + card.ability.extras.add)
        local cards = AKYRS.pseudorandom_elements(G.hand.cards,to_return,pseudoseed("akyrs_replicant_db_select"))
        local actual_cards_discarded_count = #cards
        table.sort(cards, AKYRS.hand_sort_function)
        for _,c in ipairs(cards) do
            draw_card(c.area, G.deck, 0, "down", nil, c)
        end
        AKYRS.simple_event_add(function ()
            ease_discard(card.ability.extras.disca * math.floor(actual_cards_discarded_count / card.ability.extras.per_card))
            G.deck:shuffle("akyrs_shuffled_db_replicant")
            AKYRS.fill_hand()
            return true
        end)
    end,
}

SMODS.Consumable{
    key = "replicant_short_form_content",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=4, y=0},
    config = {
        extras = -1,
        extras_mp = 1,
    },
    select_card = 'consumeables',
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (AKYRS.is_mp() and card.ability.extras_mp or card.ability.extras),
            },
            key = self.key ..(AKYRS.is_mp() and "_mp" or "")
        }
    end,
    can_use = function (self, card)
        return G.STATE == G.STATES.BLIND_SELECT
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        G.GAME.akyrs_sfc_used = (AKYRS.is_mp() and card.ability.extras_mp or card.ability.extras)
        local blinds_candidate = AKYRS.filter_table(G.P_BLINDS, function (item)
            return item.boss and item.boss.showdown and (not item.in_pool or item:in_pool())
        end, false, true)
        local blind_to_go = pseudorandom_element(blinds_candidate, "akyrs_short_form_replicant")
        AKYRS.start_blind_arbitrarily(blind_to_go.key)
    end
}

SMODS.Consumable{
    key = "replicant_smart_home",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=5, y=0},
    config = {
        extras = 4,
        min_highlighted = 0,
        max_highlighted = 99999,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_attention", set = "Other" }
        if not G.hand then return {
            vars = {
                "???", "???"
            }
        } end
        local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        return {
            vars = {
                card.ability.extras,
                localize(h, "poker_hands") ~= "ERROR" and localize(h, "poker_hands") or "???", 
            }
        }
    end,
    can_use = function (self, card)
        return #G.hand.highlighted > 0 or AKYRS.is_mod_loaded("Cryptid")
    end,
    use = function (self, card, area, copier)
        AKYRS.simple_event_add(function ()
            if #G.hand.highlighted > 0 or AKYRS.is_mod_loaded("Cryptid") then
                table.sort(G.hand.highlighted or {},AKYRS.hand_sort_function_immute)
                AKYRS.juice_like_tarot(card)
                local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                SMODS.smart_level_up_hand(card, h, false, card.ability.extras)
                AKYRS.do_things_to_card(G.hand.highlighted,
                    function (cx)
                        SMODS.Stickers.akyrs_attention:apply(cx, true)
                    end
                )
            end
            return true 
        end, 0)
    end
}

SMODS.Consumable{
    key = "replicant_music_streaming",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=6, y=0},
    config = {
        min_highlighted = 0,
        max_highlighted = 1,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "perishable", set = "Other", vars = { G.GAME.perishable_rounds, G.GAME.perishable_rounds } }
        return {
            vars = {
                card.ability.max_highlighted,
            }
        }
    end,
    can_use = function (self, card)
        return #G.jokers.highlighted > card.ability.min_highlighted and #G.jokers.highlighted <= card.ability.max_highlighted
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local filtered = AKYRS.filter_table(G.jokers.highlighted, function (ca)
            return not ca.ability.perishable
        end, true, true)
        AKYRS.do_things_to_card(filtered,
            function (cx)
                SMODS.Stickers.perishable:apply(cx, true)
                SMODS.add_card{ set = "Spectral", edition = "e_negative" }
            end
        )
    end
}


SMODS.Consumable{
    key = "replicant_file_sharing",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=7, y=0},
    config = {
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                2,
            }
        }
    end,
    can_use = function (self, card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            return ca ~= card
        end, true, true)
        return #cards == 2
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            return ca ~= card
        end, true, true)
        local card1 = cards[1]
        local card2 = cards[2]
        local card1ogarea = card1.area
        local card2ogarea = card2.area
        if card1 and card2 and card1.area and card2.area then
            if not AKYRS.is_playing_card(card1) then
                AKYRS.apply_random_p_attrib(card1)
            end
            if not AKYRS.is_playing_card(card2) then
                AKYRS.apply_random_p_attrib(card2)
            end
            AKYRS.draw_cards_back_to_hand({card1}, card2ogarea)
            AKYRS.draw_cards_back_to_hand({card2}, card1ogarea)
        end
    end
}



SMODS.Consumable{
    key = "replicant_ota",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=8, y=0},
    config = {
        extras = {
            select = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "rental", set = "Other", vars = { G.GAME.rental_rate } }
        return {
            vars = {
                card.ability.extras.select,
            }
        }
    end,
    can_use = function (self, card)
        local filtered = AKYRS.filter_table(G.jokers.cards, function (ca)
            return not ca.ability.rental
        end, true, true)
        return #filtered >= card.ability.extras.select
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local filtered = AKYRS.filter_table(G.jokers.cards, function (ca)
            return not ca.ability.rental
        end, true, true)
        local selected = AKYRS.pseudorandom_elements(filtered, card.ability.extras.select, "akyrs_replicant_ota_jkr_select")
        AKYRS.do_things_to_card(selected,
            function (cx)
                SMODS.Stickers.rental:apply(cx, true)
                SMODS.add_card{ set = "Tarot", edition = "e_negative" }
                SMODS.add_card{ set = "Tarot", edition = "e_negative" }
            end
        )
    end
}


SMODS.Consumable{
    key = "replicant_daw",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=9, y=0},
    config = {
    },
    loc_vars = function (self, info_queue, card)
        for _,ct in ipairs(G.P_CENTER_POOLS.Enhanced) do
            if ct.akyrs_note_card then
                info_queue[#info_queue+1] = ct
            end
        end
    end,
    can_use = function (self, card)
        return #G.hand.cards >= 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local filtered = AKYRS.map(AKYRS.filter_table(G.P_CENTER_POOLS.Enhanced, function (ct)
            return ct.akyrs_note_card
        end, true, true), function (v, k)
            return { value = v.key, weight = v.akyrs_note_card.weight }
        end)
        AKYRS.do_things_to_card(G.hand.cards,
            function (cx)
                local selected = AKYRS.weighted_randomiser(filtered, "akyrs_replicant_daw_select")
                cx:set_ability(G.P_CENTERS[selected])
            end
        )
    end
}



SMODS.Consumable{
    key = "replicant_instant_messaging",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=0, y=1},
    config = {
    },
    loc_vars = function (self, info_queue, card)
    end,
    can_use = function (self, card)
        return #G.hand.cards >= 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local candidates = AKYRS.filter_table(G.hand.cards, function (ct)
            return not SMODS.has_no_rank(ct) and not SMODS.has_no_suit(ct) 
        end, true, true)
        local ranks = AKYRS.map(candidates, function (v, k)
            return v.config.card
        end)
        local shuffled = AKYRS.scramble_list(ranks, "akyrs_replicant_im")
        AKYRS.do_things_to_card(candidates,
            function (cx, inde)
                cx.AKYRS_NULL_STAYS = true
                cx:set_base(shuffled[inde])
                cx.AKYRS_NULL_STAYS = false
            end
        )
    end
}


SMODS.Consumable{
    key = "replicant_enshittification",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=1, y=1},
    config = {
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "eternal", set = "Other" }
        info_queue[#info_queue+1] = { key = "rental", set = "Other", vars = { G.GAME.rental_rate } }

    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cd = SMODS.add_card({ edition = "e_negative", set = "Joker"})
        SMODS.Stickers.eternal:apply(cd, true)
        SMODS.Stickers.rental:apply(cd, true)
    end
}

SMODS.Consumable{
    key = "replicant_digital_art",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=2, y=1},
    config = {
        extras = {
            gain = 2,
            give_away = -1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.give_away,
                card.ability.extras.gain,
            }
        }
    end,
    can_use = function (self, card)
        return G.GAME.starting_params.discard_limit > 1
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        SMODS.change_discard_limit(card.ability.extras.give_away)
        G.hand:change_size(card.ability.extras.gain)
        if #G.hand.cards > 0 then
            AKYRS.fill_hand()
        end
    end
}


SMODS.Consumable{
    key = "replicant_common_scam",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=3, y=1},
    config = {
        extras = {
            gain = 1,
            give_away = -1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.give_away,
                card.ability.extras.gain,
            }
        }
    end,
    can_use = function (self, card)
        return G.GAME.starting_params.play_limit > 1
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        SMODS.change_play_limit(card.ability.extras.give_away)
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
            if G.consumeables then 
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            end
        return true end }))
    end
}


SMODS.Consumable{
    key = "replicant_third_party_cookies",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=4, y=1},
    config = {
        extras = {
            n = 1,
            d = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_latticed", set = "Other" }
        local n, d = SMODS.get_probability_vars(card, card.ability.extras.n,card.ability.extras.d, "c_akyrs_replicant_third_party_cookies_lattice_chance")
        return {
            vars ={
                n, d
            }
        }
    end,
    can_use = function (self, card)
        return G.jokers.config.card_limit - #G.jokers.cards > 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local to_create = G.jokers.config.card_limit - #G.jokers.cards
        for i = 1, to_create do
            local cdx = SMODS.add_card({key = key, set = "Joker", attributes = {"food"}})
            local latticed = SMODS.pseudorandom_probability(card, "c_akyrs_replicant_third_party_cookies_lattice_chance", card.ability.extras.n,card.ability.extras.d)
            if latticed then
                SMODS.Stickers.akyrs_latticed:apply(cdx, true)  
            end
        end
    end
}


SMODS.Consumable{
    key = "replicant_silicon_fabrication",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=5, y=1},
    config = {
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akyrs_wafer_card
        info_queue[#info_queue+1] = G.P_CENTERS.e_akyrs_charged
    end,
    can_use = function (self, card)
        local eligible_cards = AKYRS.filter_table(G.hand.cards, function (cfx, ind)
            return cfx.config.center.key ~= "m_akyrs_wafer_card"
        end, true, true)
        return #G.hand.cards > 0 and #eligible_cards > 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local eligible_cards = AKYRS.filter_table(G.hand.cards, function (cfx, ind)
            return cfx.config.center.key ~= "m_akyrs_wafer_card"
        end, true, true)
        local candidates = AKYRS.pseudorandom_elements(eligible_cards, 2, "akyrs_replicant_3rdparty_wafer")
        for _, v in ipairs(candidates) do
            AKYRS.remove_value_from_table(eligible_cards,v)
        end
        local candidates_edition = AKYRS.pseudorandom_elements(eligible_cards, 2, "akyrs_replicant_3rdparty_edition")
        AKYRS.do_things_to_card(candidates, function (cardx, index)
            cardx:set_ability(G.P_CENTERS.m_akyrs_wafer_card)
        end)
        AKYRS.do_things_to_card(candidates_edition, function (cardx, index)
            cardx:set_edition('e_akyrs_charged')
        end)
    end
}


SMODS.Consumable{
    key = "replicant_get_rich_quick",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=6, y=1},
    config = {
        extras = {
            emoney = 2,
            odds = 0.5,
        }
    },
    
    calculate = function (self, card, context)
        if context.selling_card and context.card == card then
            local die_question_mark = SMODS.pseudorandom_probability(card,"akyrs_replicant_get_rich_quick",1 ,2, nil, true)
            return {
                message = localize("k_akyrs_replicant_get_rich_quick_"..(die_question_mark and "would_die" or "would_win")),
                colour = (die_question_mark and G.C.GREEN or G.C.RED),
                func = function ()
                    AKYRS.force_save()
                end
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.emoney,
                card.ability.extras.odds * 100,
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local die_question_mark = SMODS.pseudorandom_probability(card,"akyrs_replicant_get_rich_quick",card.ability.extras.odds ,1, nil , true)
        local d_dollar = 0
        if die_question_mark then
            AKYRS.force_lose(self.key)
        else
            AKYRS.simple_event_add(
                function ()
                    if Talisman and type(to_big(G.GAME.dollars)) == "table" then
                        d_dollar = to_big(G.GAME.dollars):pow(card.ability.extras.emoney) - to_big(G.GAME.dollars)
                    else
                        d_dollar = G.GAME.dollars ^ card.ability.extras.emoney - G.GAME.dollars
                    end
                    ease_dollars(d_dollar)
                    return true
                end, 0
            )
        end
        AKYRS.force_save()
    end
}

