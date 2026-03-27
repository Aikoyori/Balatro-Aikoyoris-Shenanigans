SMODS.ConsumableType{
    key = "Umbral",
    primary_colour = HEX("ffd45b"),
    secondary_colour = HEX("925ac3"),
    collection_rows = { 5, 5 },
    shop_rate = 3,
    default = "c_akyrs_umbral_break_up"
}

SMODS.UndiscoveredSprite{
    key = "Umbral",
    atlas = "umbra_undisc",
    pos = {x=0, y=0}
}

--[[
misc.dictionary.b_key_cards
misc.dictionary.k_key
misc.labels.key
descriptions.Other.undiscovered_key
]]
--[[

]]
--[[
-- does not work well with editions and is kinda hard to read so i scrapped it

local umbra_alt_col_spr = function (self, card, front)
    if not card.akyrs_almost_front then
        card.akyrs_almost_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["akyrs_umbra_2"], self.pos)
        card.akyrs_almost_front.layered_parallax = nil
        card.akyrs_almost_front.states.hover = card.states.hover
        card.akyrs_almost_front.states.click = card.states.click
        card.akyrs_almost_front.states.drag = card.states.drag
        card.akyrs_almost_front.states.collide.can = false
        card.akyrs_almost_front:set_role({major = card, role_type = 'Glued', draw_major = card})
    end
end
local umbra_draw = function (self, card, layer)
    if card.config.center.discovered or self.bypass_discovery_center then
        card.akyrs_almost_front:draw_shader('akyrs_color_shift', nil, card.ARGS.send_to_shader)
    end
end

]]

SMODS.Consumable{
    set = "Umbral",
    key = "umbral_graduate",
    atlas = "umbra",
    pos = {x=0,y=0},
    loc_vars = function (self, info_queue, card)
        local disallow = not not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
        local text = G.GAME.akyrs_last_umbral and localize{type = "name_text",key = G.GAME.akyrs_last_umbral, set = "Umbral"} or localize("ph_akyrs_unknown")
        if G.GAME.akyrs_last_umbral and not disallow then
            info_queue[#info_queue+1] = G.P_CENTERS[G.GAME.akyrs_last_umbral]
        end
        return {
            main_end = {
                { n = G.UIT.R, config = { padding = 0.1, colour = disallow and G.C.RED or G.C.GREEN, r = 0.1}, nodes = {
                    {
                        n = G.UIT.T, config = {scale = 0.3, text = text}
                    }
                }}
            }
        }
    end,
    can_use = function (self, card)
        return not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
    end,
    use = function (self, card, area, copier)
        AKYRS.simple_event_add(function ()
            AKYRS.juice_like_tarot(card)
            local disallow = not not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
            if not disallow then
                SMODS.add_card{key = G.GAME.akyrs_last_umbral}
            end
            return 0
        end, 0)
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_realist",
    atlas = "umbra",
    pos = {x=1,y=0},
    config = {
        max_highlighted = 1,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_insolate_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.simple_event_add(function ()
            AKYRS.juice_like_tarot(card)
            AKYRS.do_things_to_card(G.hand.highlighted,function (_card)
                _card:set_ability(G.P_CENTERS["m_akyrs_insolate_card"])
            end, {stay_flipped_delay = 1,stagger = 0.1, fifo = true})
            return true
        end, 0)
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_tribal",
    atlas = "umbra",
    pos = {x=2,y=0},
    config = {
        min_highlighted = 0,
        max_highlighted = 99999,
    },
    can_use = function (self, card)
        return (G.hand.highlighted and #G.hand.highlighted > 0) or AKYRS.is_mod_loaded("Cryptid")
    end,
    loc_vars = function (self, info_queue, card)
        if not G.hand then return {
            vars = {
                "???", "???"
            }
        } end
        local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        local pl = AKYRS.get_planet_for_hand(h)
        if pl then
            info_queue[#info_queue+1] = G.P_CENTERS[pl]
        end
        return {
            vars = {
                localize(h, "poker_hands") ~= "ERROR" and localize(h, "poker_hands") or "???", 
                pl and localize({type = "name_text", set = "Planet", key = pl}) or "???",
            }
        }
        
    end,
    use = function (self, card, area, copier)
        AKYRS.simple_event_add(function ()
            table.sort(G.hand.highlighted,AKYRS.hand_sort_function_immute)
            AKYRS.juice_like_tarot(card)
            local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            local pl = AKYRS.get_planet_for_hand(h)
            if pl then
                SMODS.add_card{key = pl}
            end
            return true 
        end, 0)
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_gambit",
    atlas = "umbra",
    pos = {x=3,y=0},
    config = {
        extras = 3,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cards = AKYRS.pseudorandom_elements(G.hand.cards,card.ability.extras,pseudoseed("akyrs_umbral_gambit_c"))
        local rank = pseudorandom_element({"King","Queen","Ace"},pseudoseed("akyrs_umbral_gambit_r"))
        AKYRS.do_things_to_card(cards,function (_card)
            _card = SMODS.change_base(_card,nil,rank)
        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_kingpin",
    atlas = "umbra",
    pos = {x=4,y=0},
    can_use = function (self, card)
        return G.STATE == G.STATES.SELECTING_HAND or #G.hand.cards > 0
    end,
    config = {
        extra = 2,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "pinned_left", set = "Other" }
        return {
            vars = {
                card.ability.extra
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.simple_event_add(
            function ()
                for i = 1, card.ability.extra do
                    local c = SMODS.add_card{ area = G.hand, set = "Base", seal = SMODS.poll_seal({guaranteed = true,}), rank = "King" }
                    c.pinned = true
                    c:juice_up(0.3,0.3)
                end
                return true
            end
        )
    end
    
}
AKYRS.tea_cards = {"m_akyrs_thai_tea_card", "m_akyrs_matcha_card", "m_akyrs_earl_grey_tea_card", }
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_tea_time",
    atlas = "umbra",
    pos = {x=5,y=0},
    config = {
        min_highlighted = 1,
        max_highlighted = 1
    },
    loc_vars = function (self, info_queue, card)
        for _,k in ipairs(AKYRS.tea_cards) do
            info_queue[#info_queue+1] = G.P_CENTERS[k] 
        end
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,function (_card)
            local ench = pseudorandom_element(AKYRS.tea_cards,pseudoseed("akyrs_umbral_tea_time"))
            _card:set_ability(G.P_CENTERS[ench])
        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_break_up",
    atlas = "umbra",
    config = {
        min_highlighted = 3,
        max_highlighted = 3
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_break_up_tip"]

        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    can_use = function (self, card)
        local has_no_rank, has_no_suit 
        for _, c in ipairs(G.hand.highlighted) do
            if SMODS.has_no_suit(c) then
                has_no_suit = true
            end
            if SMODS.has_no_rank(c) then
                has_no_rank = true
            end
        end
        return (#G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted >= card.ability.min_highlighted) and not (has_no_rank and has_no_suit)
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _, c in ipairs(G.hand.highlighted) do
            if not SMODS.has_no_suit(c) then
                local c2 = AKYRS.copy_p_card(c, nil, nil, G.playing_card)
                c2.ability.akyrs_special_card_type = "rank"
                c2:set_sprites(c2.config.center,c2.config.card)
                SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
            end
            if not SMODS.has_no_rank(c) then
                local c2 = AKYRS.copy_p_card(c, nil, nil, G.playing_card)
                c2.ability.akyrs_special_card_type = "suit"
                c2:set_sprites(c2.config.center,c2.config.card)
                SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
            end
            -- requested by autumm
            c.no_graveyard = true
            -- no destroy context because it technically is not gone
            c:start_dissolve({ G.C.AKYRS_UMBRAL_P, G.C.AKYRS_UMBRAL_Y, }, 1 )
        end
        
    end,
    pos = {x=6,y=0},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_public_transport",
    atlas = "umbra",
    pos = {x=7,y=0},
    config = {
        max_highlighted = 1,
        akyrs_create = 2,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.akyrs_create,
                card.ability.max_highlighted
            }
        }
    end,
    use = function (z, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local ud = pseudorandom_element({1,-1},pseudoseed("akyrs_umbral_pubtp_updown"))
        for _,_c in ipairs(G.hand.highlighted) do
            for i = 1, card.ability.akyrs_create do
                local c2 = AKYRS.copy_p_card(_c, nil, nil, G.playing_card)
                if SMODS.has_no_rank(c2) then
                    unlock_achievement("ach_akyrs_literally_cryptid")
                end
                if not c2.is_null then
                    c2 = SMODS.modify_rank(c2, ud*i)
                end
                SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
                if c2 then c2:juice_up(0.3,0.3) end
            end
            AKYRS.deselect_from_area(_c)
            
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_corruption",
    atlas = "umbra",
    pos = {x=8,y=0},
    can_use = function (self, card)
        return #G.hand.cards > 0 
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local ud = pseudorandom_element({"dupe","destroy"},pseudoseed("akyrs_umbral_corrupt_pick"))
        local cds = AKYRS.pseudorandom_elements(G.hand.cards,math.ceil(#G.hand.cards/2),pseudoseed("akyrs_umbral_corrupt_cards"))
        for _,_card in ipairs(cds) do
            if ud == "dupe" then
                local c2 = AKYRS.copy_p_card(_card)
                SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
            else
                SMODS.calculate_context({ remove_playing_cards = true, removed = _card})
                _card:start_dissolve({G.C.AKYRS_UMBRAL_P,G.C.AKYRS_UMBRAL_P},1)
            end
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_fomo",
    atlas = "umbra",
    pos = {x=9,y=0},
    config = {
        extras = {
            create = 1,
            take = 12
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.create,
                card.ability.extras.take
            }
        }
    end,
    can_use = function (self, card)
        -- wtf? talisman
        for _,v in ipairs(G.GAME.current_round.voucher) do
            if G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers[v] then
                return false
            end
        end
        return #G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers > 0 and AKYRS.can_afford(card.ability.extras.take)
    end,
    in_pool = function (self, args)
        return #G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers > 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        ease_dollars(-card.ability.extras.take)
        for i = 1, card.ability.extras.create do
            local to_redeem = pseudorandom_element(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers,pseudoseed("akyrs_umbral_fomo_voucher"))
            local _c = SMODS.create_card{ set = "Voucher", key = to_redeem }
            _c.cost = 0
            G.play:emplace(_c)
            _c:redeem()
            if G.shop_vouchers and G.shop_vouchers.cards then
                for _,_cds in ipairs(G.shop_vouchers.cards) do
                    if _cds.config.center_key == to_redeem then
                        _cds:remove()
                    end
                end
            end
            AKYRS.simple_event_add(
                function ()
                    _c:start_dissolve(nil,2)
                    return true
                end, 1
            )
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_misfortune",
    atlas = "umbra",
    pos = {x=0,y=1},
    config = {
        max_highlighted = 2
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_hatena"]
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_item_box"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,
            function (_c)
                if _c.config.center_key == "m_akyrs_hatena" then
                    _c:set_ability(G.P_CENTERS["m_akyrs_item_box"])
                else
                    _c:set_ability(G.P_CENTERS["m_akyrs_hatena"])
                end
                AKYRS.deselect_from_area(_c)
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_book_smart",
    atlas = "umbra",
    pos = {x=1,y=1},
    config = {
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for i = 1, card.ability.extras do
            if not AKYRS.has_room(G.consumeables) then break end
            local _c = SMODS.add_card{set = "Umbral"}
            _c:juice_up(0.3,0.3)
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_prisoner",
    atlas = "umbra",
    pos = {x=2,y=1},
    config = {
        max_highlighted = 2
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_brick_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,
            function (_c)
                _c:set_ability(G.P_CENTERS["m_akyrs_brick_card"])
                AKYRS.deselect_from_area(_c)
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_overgrowth",
    atlas = "umbra",
    pos = {x=3,y=1},
    config = {
        max_highlighted = 4
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_canopy_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,
            function (_c)
                _c:set_ability(G.P_CENTERS["m_akyrs_canopy_card"])
                AKYRS.deselect_from_area(_c)
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_intrusive_thoughts",
    atlas = "umbra",
    pos = {x=4,y=1},
    config = {
        extras = {
            xmoney = 3,
            setdollarmult = 2,
            emoney = 2,
            odds = 0.5,
        }
    },
    
    calculate = function (self, card, context)
        if context.selling_card and context.card == card then
            local die_question_mark = SMODS.pseudorandom_probability(card,"akyrs_umbral_intrusive",1 ,2, "akyrs_umbral_intrusive", true)
            return {
                message = localize("k_akyrs_umbral_intrusive_"..(die_question_mark and "would_die" or "would_win")),
                colour = (die_question_mark and G.C.GREEN or G.C.RED),
                func = function ()
                    AKYRS.force_save()
                end
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        G.GAME.akyrs_umbral_intrusive_usage_set = G.GAME.akyrs_umbral_intrusive_usage_set or -4
        return {
            key = self.key .. (AKYRS.bal("absurd") and "_absurd" or ""),
            vars = {
                AKYRS.bal("absurd") and card.ability.extras.emoney or card.ability.extras.xmoney,
                card.ability.extras.odds * 100,
                SMODS.signed_dollars(G.GAME.akyrs_umbral_intrusive_usage_set)
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local die_question_mark = SMODS.pseudorandom_probability(card,"akyrs_umbral_intrusive",card.ability.extras.odds ,1, "akyrs_umbral_intrusive", true)
        local d_dollar = 0
        if die_question_mark then
            if AKYRS.bal("absurd") then
                if G.STAGE == G.STAGES.RUN then 
                    G.GAME.akyrs_defeated_by_center = self.key
                    G.TAROT_INTERRUPT = nil
                    G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
                end
            else
                AKYRS.simple_event_add(
                    function ()
                        d_dollar = -G.GAME.dollars + G.GAME.akyrs_umbral_intrusive_usage_set
                        ease_dollars(d_dollar)
                        G.GAME.akyrs_umbral_intrusive_usage_set = -4
                        return true
                    end, 0
                )
            end
        else
            if AKYRS.bal("absurd") then
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
            else
                AKYRS.simple_event_add(
                    function ()
                        d_dollar = G.GAME.dollars * ( card.ability.extras.xmoney - 1 )
                        G.GAME.akyrs_umbral_intrusive_usage_set = (G.GAME.akyrs_umbral_intrusive_usage_set or -4) * card.ability.extras.setdollarmult
                        ease_dollars(d_dollar)
                        return true
                    end, 0
                )
            end
        end
        AKYRS.force_save()
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_weeping_angel",
    atlas = "umbra",
    pos = {x=5,y=1},
    config = {
        extras = 2
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _,_c in ipairs(G.hand.cards) do
            AKYRS.simple_event_add(
                function ()
                    play_sound('card1')
                    _c:juice_up(0.3, 0.3)
                    _c:flip()
                    return true
                end, 0.25
            )
        end
        AKYRS.simple_event_add(
            function ()
                local money_obtain = 0
                for _,_c in ipairs(G.hand.cards) do
                    if _c.facing == "back" then
                        money_obtain = money_obtain + card.ability.extras
                    end
                end
                if money_obtain ~= 0 then
                    ease_dollars(money_obtain)
                end
                return true
            end, 0.25
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_bunker",
    atlas = "umbra",
    pos = {x=6,y=1},
    config = {
        max_highlighted = 1
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(
            G.hand.highlighted,
            function (_card)
                local ench = SMODS.poll_enhancement({guaranteed = true, key = "akyrs_umbral_bunker_ench"})
                local edition = poll_edition("akyrs_umbral_bunker_edition", nil, nil, true)
                local seal = SMODS.poll_seal({guaranteed = true, key = "akyrs_umbral_bunker_seal"})
                _card:set_ability(G.P_CENTERS[ench])
                _card:set_seal(seal)
                _card:set_edition(edition)
                _card.ability.akyrs_forced_selection = true
            end
        )
    end
}

SMODS.Consumable{
    set = "Umbral",
    key = "umbral_rock",
    atlas = "umbra",
    pos = {x=7,y=1},
    config = {
        extras = 10
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _,_c in ipairs(G.hand.cards) do
            AKYRS.simple_event_add(
                function ()
                    _c.ability.perma_bonus = _c.ability.perma_bonus + card.ability.extras
                    _c:juice_up(0.3, 0.3)
                    play_sound("tarot1")
                    return true
                end
            )
        end
    end
}

SMODS.Consumable{
    set = "Umbral",
    key = "umbral_crust",
    atlas = "umbra",
    pos = {x=8,y=1},
    config = {
        extras = 0.1
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _,_c in ipairs(G.hand.cards) do
            if _c:is_suit("Clubs") then
                AKYRS.simple_event_add(
                    function ()
                        _c.ability.perma_x_mult = _c.ability.perma_x_mult + card.ability.extras
                        _c:juice_up(0.3, 0.3)
                        play_sound("tarot1")
                        return true
                    end
                )
            end
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_mantle",
    atlas = "umbra",
    pos = {x=9,y=1},
    config = {
        extras = 0.1
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _,_c in ipairs(G.hand.cards) do
            if _c:is_suit("Spades") then
                AKYRS.simple_event_add(
                    function ()
                        _c.ability.perma_x_chips = _c.ability.perma_x_chips + card.ability.extras
                        _c:juice_up(0.3, 0.3)
                        play_sound("tarot1")
                        return true
                    end
                )
            end
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_core",
    atlas = "umbra",
    pos = {x=0,y=2},
    config = {
        extras = 1
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _,_c in ipairs(G.hand.cards) do
            if _c:is_suit("Hearts") then
                AKYRS.simple_event_add(
                    function ()
                        _c.ability.perma_p_dollars = _c.ability.perma_p_dollars + card.ability.extras
                        _c:juice_up(0.3, 0.3)
                        play_sound("tarot1")
                        return true
                    end
                )
            end
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_atmosphere",
    atlas = "umbra",
    pos = {x=1,y=2},
    config = {
    },
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    loc_vars = function (self, info_queue, card)
        G.GAME.akyrs_umbral_atmosphere_score_inc = G.GAME.akyrs_umbral_atmosphere_score_inc or 100
        G.GAME.akyrs_umbral_atmosphere_uses = G.GAME.akyrs_umbral_atmosphere_uses or 0
        return {
            vars = {
                G.GAME.akyrs_umbral_atmosphere_score_inc,
                G.GAME.akyrs_umbral_atmosphere_score_inc + 100 * (G.GAME.akyrs_umbral_atmosphere_uses + 1)^2
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        G.GAME.akyrs_umbral_atmosphere_score_inc = G.GAME.akyrs_umbral_atmosphere_score_inc or 100
        G.GAME.akyrs_umbral_atmosphere_uses = (G.GAME.akyrs_umbral_atmosphere_uses or 0) + 1
        for _,_c in ipairs(G.hand.cards) do
            if _c:is_suit("Diamonds") then
                AKYRS.simple_event_add(
                    function ()
                        _c.ability.perma_score = _c.ability.perma_score + G.GAME.akyrs_umbral_atmosphere_score_inc
                        _c:juice_up(0.3, 0.3)
                        play_sound("tarot1")
                        return true
                    end
                )
            end
        end
        AKYRS.simple_event_add(
            function ()
                G.GAME.akyrs_umbral_atmosphere_score_inc =  G.GAME.akyrs_umbral_atmosphere_score_inc + 100 * (G.GAME.akyrs_umbral_atmosphere_uses)^2
                return true
            end, 0
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_nyctophobia",
    atlas = "umbra",
    pos = {x=2,y=2},
    can_use = function (self, card)
        return true
    end,
    config = {
        extra = 1
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for i = 1, card.ability.extra do
            local c = SMODS.add_card{ edition = "e_negative", set = "Tarot"}
            c:juice_up(0.3, 0.3)
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_puzzle",
    atlas = "umbra",
    pos = {x=3,y=2},
    config = {
        min_highlighted = 2,
        max_highlighted = 2,
    },
    loc_vars = function (self, info_queue, card)
        if G.GAME.akyrs_character_stickers_enabled and AKYRS.config.show_joker_preview then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_letter_puzzle_umbral_expl"]
        end
        return {
            vars = {
                card.ability.min_highlighted
            }
        }
    end,
    can_use = function (self, card)
        return #G.hand.highlighted >= math.max(2,card.ability.min_highlighted) and #G.hand.highlighted <= card.ability.max_highlighted
    end, 
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        table.sort(G.hand.highlighted,AKYRS.hand_sort_function_immute)
        AKYRS.do_things_to_card(
            G.hand.highlighted,
            function (_card, index)
                if index == 1 then
                    if G.hand.highlighted[2] then
                        ---@type Card
                        local c2 = G.hand.highlighted[2]
                        if c2.edition then
                            _card:set_edition(c2.edition.key)
                        end
                        if c2.seal then
                            _card:set_seal(c2.seal)
                        end
                        if not SMODS.has_no_suit(c2) and c2.base and c2.base.suit then
                            _card = SMODS.change_base(_card, c2.base.suit )
                            if _card and _card.ability.akyrs_special_card_type == "rank" then
                                _card.ability.akyrs_special_card_type = nil
                                _card:set_sprites(_card.config.center,_card.config.card)
                            end
                        end
                        if _card then
                            if _card:get_letter_with_pretend() and c2:get_letter_with_pretend() then
                                _card:set_letters(_card:get_letter_with_pretend()..c2:get_letter_with_pretend())
                            end
                        end
                    end
                else
                    SMODS.calculate_context({ remove_playing_cards = true, removed = _card})
                    _card:start_dissolve({G.C.AKYRS_UMBRAL_P, G.C.AKYRS_UMBRAL_Y})
                end
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_electrify",
    atlas = "umbra",
    pos = {x=4,y=2},
    config = {
        max_highlighted = 1,
    },
    loc_vars = function (self, info_queue, card)
        
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_zap_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(
            G.hand.highlighted,
            function (_card)
                _card:set_ability(G.P_CENTERS["m_akyrs_zap_card"])
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_bounce",
    atlas = "umbra",
    pos = {x=7,y=2},
    config = {
        max_highlighted = 1,
    },
    loc_vars = function (self, info_queue, card)
        
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_net_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(
            G.hand.highlighted,
            function (_card)
                _card:set_ability(G.P_CENTERS["m_akyrs_net_card"])
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_hydrate",
    atlas = "umbra",
    pos = {x=8,y=2},
    config = {
        max_highlighted = 2,
    },
    loc_vars = function (self, info_queue, card)
        
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_droplet_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(
            G.hand.highlighted,
            function (_card)
                _card:set_ability(G.P_CENTERS["m_akyrs_droplet_card"])
            end
        )
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_d1",
    atlas = "umbra",
    pos = {x=5,y=2},
    config = {
        extras = {
            d = 1,
            n = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.n,
                card.ability.extras.d,
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        G.GAME.akyrs_prob_mod = G.GAME.akyrs_prob_mod or {}
        table.insert(G.GAME.akyrs_prob_mod, {n_add = card.ability.extras.n, d_add = card.ability.extras.d, id = "d1"})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_exit_plan",
    atlas = "umbra",
    pos = {x=0,y=3},
    config = {
        extras = {
            n = 1,
            d = 2,
            mp_percent_of_req = 0.30,
        }
    },
    loc_vars = function (self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card ,card.ability.extras.n, card.ability.extras.d, "akyrs_umbral_exit_plan" )
        return {
            vars = {
                n, d, card.ability.extras.mp_percent_of_req * 100, get_blind_amount(G.GAME.round_resets.ante) * card.ability.extras.mp_percent_of_req
            },
            key = self.key .. AKYRS.mp_check("","_mp")
        }
    end,
    select_card = 'consumeables',
    can_use = function (self, card)
        if G.GAME.blind and G.GAME.blind.in_blind then
            return true
        end
        return false
    end,
    use = function (self, card, area, copier)
        if G.GAME.blind and G.GAME.blind.in_blind then
            local should = SMODS.pseudorandom_probability(card, "akyrs_umbral_exit_plan" ,card.ability.extras.n, card.ability.extras.d )
            if should then 
                if AKYRS.is_mp() then
                    SMODS.mod_score({ add = get_blind_amount(G.GAME.round_resets.ante) * card.ability.extras.mp_percent_of_req})
                    if true then
                        AKYRS.simple_event_add(function ()
                            if not AKYRS.is_mp() or not MP.is_pvp_boss() then
                                AKYRS.force_check_win()
                            else
                                MP.ACTIONS.play_hand(G.GAME.chips, G.GAME.current_round.hands_left)
                            end
                            return true
                        end,0)
                    end
                else
                    G.GAME.blind:disable()
                end
            else
                -- nope
                AKYRS.simple_event_add(function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.AKYRS_UMBRAL_P,
                        align = 'cm',
                        offset = { x = 0, y = 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4); return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end)
            end
        else
            if card.area and card.area ~= G.consumeables then
                if AKYRS.has_room(G.consumeables, card) then
                    G.consumeables:emplace(card)
                    card:add_to_deck()
                else
                    alert_no_space(card, G.consumeables)
                end
            end
        end

    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_free_will",
    atlas = "umbra",
    pos = {x=6,y=2},
    soul_pos = {x=9,y=2, draw=function (card, scale_mod, rotate_mod)
        if card.children.floating_sprite then
            rotate_mod = -G.TIMERS.REAL * 0.731
            local sc = -0.25
            local xm = 0.2 * math.cos(G.TIMERS.REAL)
            local ym = 0.2 * math.sin(G.TIMERS.REAL)
            card.children.floating_sprite:draw_shader('dissolve', 0, nil,nil,card.children.center,sc, rotate_mod,xm,ym+0.2,nil, 0.6)
            card.children.floating_sprite:draw_shader('dissolve', nil, nil,nil,card.children.center,sc, rotate_mod,xm,ym,nil, 0.6)
        end
    end},
    hidden = true,
    soul_rate = 0.05,
    can_repeat_soul = true,
    soul_set = 'Replicant',
    config = {
        extras = {
            mod = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.mod
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        SMODS.change_play_limit(card.ability.extras.mod)
        SMODS.change_discard_limit(card.ability.extras.mod)
    end
}