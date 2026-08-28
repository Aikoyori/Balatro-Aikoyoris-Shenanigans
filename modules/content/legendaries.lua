local to_number = to_number or function(x) return x end

-- her
SMODS.Joker {
    key = "furina",
    atlas = 'furina',
    pools = { ["Genshin Impact"] = true,},
    pos = {
        x = 0, y = 0
    },
    soul_pos = {
        x = 1, y = 0, draw = function (card, scale_mod, rotate_mod)
            card.children.floating_sprite:draw_shader('dissolve',0, nil, nil, card.children.center,scale_mod, rotate_mod,0,0 - 0.3,nil, 0.6)
            card.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod,0,0-0.5)
        end
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extra },
        }
    end,
    rarity = 4,
    cost = 20,
    config = {
        extra = 2
    },
    calculate = function (self, card, context)
        if context.press_play then
            return {
                func = function ()
                    ease_discard(card.ability.extra)
                end
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
    hpot_unbreedable = true,
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
    pools = { ["Rhythm Games"] = true, ["Maimai"] = true },
    key = "tsunagite",
    rarity = 4,
    cost = 20,
    loc_vars = function(self, info_queue, card)
        local total = 0
        if G.hand and G.hand.highlighted then
            for i,k in ipairs(G.hand.highlighted) do
                total = total + k:get_chip_bonus()
            end
        end
        info_queue[#info_queue+1] = {key = "akyrs_tsunagite_scores", set = 'Other', vars = {
            total
        } }
        info_queue[#info_queue+1] = {key = "akyrs_tsunagite_name", set = 'Other', }
        return {
            vars = { 
                15,
                card.ability.extra.gain_Xmult,
            }
        }
    end,
    config = {
        extra = {
            total = 15,
            gain_Xmult = 0.15,
        }
    },
    calculate = function(self, card, context)
        if context.akyrs_pre_play then
            return {
                func = function ()
                    local total = 0
                    for i,k in ipairs(context.akyrs_pre_play_cards) do
                        total = total + k:get_chip_bonus()
                    end
                    if math.fmod(total,15) == 0 then
                        for i,k in ipairs(context.akyrs_pre_play_cards) do
                            AKYRS.simple_event_add(function()
                                AKYRS.juice_like_tarot(card)
                                k:juice_up(0.3, 0.5)
                                SMODS.scale_card(k, { ref_table = k.ability, ref_value = "perma_x_mult", scalar_table = card.ability.extra, scalar_value = "gain_Xmult" })
                                return true
                            end, 0.5)
                        end
                    end
                end
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}

SMODS.Joker{
    key = "gappie",
    cost = 20,
    config = {
        extras = {
            xmlt = 1,
            xmlt_gain = 1,
            activated = false,
        }
    },
    atlas = "gappie",
    rarity = 4,
    akyrs_credits = {
        art = {
            "marcyptata64"
        },
        person_in_question = {
            "marcyptata64"
        },
        attrib = {
            ["marcyptata64"] = "art",
            ["gappie"] = "person_in_question",
        },
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_marcyptata64"]
        return {
            vars = {
                card.ability.extras.xmlt, 
                card.ability.extras.xmlt_gain, 
            }
        }
    end,
    hpot_unbreedable = true,
    set_sprites = function (self, card, front)
        if card.ability and card.ability.extras and card.ability.extras.activated then
            card.children.center:set_sprite_pos({x = 1, y = 0})
        end
    end,
    calculate = function (self, card, context)
        ---@type Card 
        card = card
        if context.hand_drawn and not card.ability.extras.activated then
            if G.GAME.current_round.hands_left == 1 and G.GAME.current_round.discards_left == 0 then
                return {
                    func = function ()
                        card.ability.extras.activated = true
                        AKYRS.simple_event_add(function ()
                            card.children.center:set_sprite_pos({x = 1, y = 0})
                            return true
                        end, 0)
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extras,
                            ref_value = "xmlt",
                            scalar_value = "xmlt_gain",
                        })
                        SMODS.draw_cards(#G.deck.cards)
                        ---@type Sprite[]
                        card.children = card.children
                        AKYRS.force_save()
                    end
                }
            end
        end
        if (context.end_of_round and context.main_eval) then
            return {
                message = localize("k_reset"),
                func = function ()
                    card.ability.extras.activated = false
                    card.children.center:set_sprite_pos({x = 0, y = 0})
                end
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extras.xmlt
            }
        end
    end
}


local toga_tags = {"tag_toga_togajokerbooster","tag_toga_togajokerziparchive","tag_toga_togarararchive","tag_toga_togacardcabarchive","tag_toga_togaxcopydnaarchive",}
local cryptposting_joker = {"j_joker","j_crp_joker_2","j_crp_joker_3","j_crp_joker_4","j_crp_joker_5","j_crp_joker_6","j_crp_joker_7","j_crp_joker_8","j_crp_joker?","j_crp_joker_0"}
SMODS.Joker {
    pools = { ["Self-Insert"] = true, },
    key = "aikoyori",
    atlas = 'aikoyoriSelfInsert',
    pos = {
        x = 0, y = 0
    },
    soul_pos = {
        x = 1, y = 0
    },
    rarity = 4,
    cost = 20,
    config = {
        name = "Aikoyori",
        extras = {
            base = {
                xmult = 1.984,
                emult = 1.5,
            }
        }
    },
    hpot_unbreedable = true,
    set_ability = function (self, card, initial, delay_sprites)
        ---@type Card
        card = card
        local dt = os.time()
        card.ability.akyrs_aiko_sprite = pseudorandom("akyrs_sprite_"..dt, 0 ,5)
    end,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_base_ability", vars = {card.ability.extras.base.xmult}}
        if AKYRS.is_mod_loaded("Cryptid")  then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_cryptid_ability"}
        end
        if MoreFluff then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_more_fluff_ability"}
        end
        if AKYRS.is_mod_loaded("Entropy") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_entropy_ability"}
        end
        if SDM_0s_Stuff_Mod then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_sdmstuff_ability"}
        end
        if togabalatro then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_togasstuff_ability"}
        end
        if PTASaka then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_aikoyori_pta_ability"}
        end
        if Cryptposting then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_cryptposting_ability"}
        end
        if AKYRS.is_mod_loaded("Prism") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_prism_ability"}
        end
        if garb_enabled then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_garbshit_ability"}
        end
        if AKYRS.is_mod_loaded("finity") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_finity_ability"}
        end
        if Bakery_API then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_bakery_ability"}
        end
        if AKYRS.is_mod_loaded("Astronomica") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_astronomica_ability"}
        end
        if AKYRS.is_mod_loaded("vallkarri") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_vallkarri_ability"}
        end
        if AKYRS.is_mod_loaded("GrabBag") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_grab_bag_ability"}
        end
        if AKYRS.is_mod_loaded("ortalab") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_ortalab_ability"}
        end
        if AKYRS.is_mod_loaded("HotPotato") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_hotpot_ability"}
        end
        if AKYRS.is_mod_loaded("GSPhanta") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_phanta_ability"}
        end
        if AKYRS.is_mod_loaded("kino") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_kino_ability"}
        end
        if AKYRS.is_mod_loaded("Maximus") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_maximus_ability"}
        end
        if AKYRS.is_mod_loaded("Sagatro") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_sagatro_ability"}
        end
        if AKYRS.is_mod_loaded("Qualatro") then
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_qualatro_ability"}
        end
        return {
        }
    end,
    add_to_deck = function (self, card, from_debuff)
        if Bakery_API then
            G.GAME.modifiers.Bakery_extra_charms = G.GAME.modifiers.Bakery_extra_charms and G.GAME.modifiers.Bakery_extra_charms + 1 or 1
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        if Bakery_API then
            G.GAME.modifiers.Bakery_extra_charms = G.GAME.modifiers.Bakery_extra_charms and G.GAME.modifiers.Bakery_extra_charms - 1 or 1
        end
    end,
    calculate = function (self, card, context)
        if context.skip_blind then
            if Cryptposting then
                SMODS.calculate_effect({
                    func = function()
                        local jkr = pseudorandom_element(cryptposting_joker,pseudoseed("aikocryptposting"))
                        SMODS.add_card({set = "Joker", key = jkr})
                    end
                }, card)
            end
        end
        if context.setting_blind then
            if AKYRS.is_mod_loaded("GrabBag") then
                SMODS.calculate_effect({
                    func = function()
                        SMODS.add_card({set = "Ephemeral", area = G.consumeables, edition = "e_negative"})
                    end
                }, card)
            end
        end
        if context.akyrs_ortalab_zodiac_used then
            return {
                func = function ()
                    AKYRS.simple_event_add(
                        function()
                            SMODS.upgrade_poker_hands({
                                from = card, 
                                hands = {context.zodiac_proto.config.extra.hand_type},
                                level_up = 1,
                            })
                            return true
                        end
                    )
                end, 0
            }
        end
        if context.before then
            if AKYRS.is_mod_loaded("Cryptid") and #G.play.cards == 1 and G.play.cards[1]:get_id() == 14 then
                SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Code", area = G.consumeables, edition = "e_negative"}) end}, card)
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
                    SMODS.calculate_effect({ func = function() SMODS.add_card({key = "c_entr_flipside", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
            if AKYRS.is_mod_loaded("sdm0sstuff") then
                if next(context.poker_hands["Full House"]) then
                    SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Bakery", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
            if AKYRS.is_mod_loaded("GSPhanta") then
                if next(context.poker_hands["Four of a Kind"]) and G.P_CENTER_POOLS.phanta_hanafuda then
                    SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Hanafuda", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
            if AKYRS.is_mod_loaded("vallkarri") then
                if G.GAME.current_round.hands_left == G.GAME.current_round.discards_left then
                    SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Aesthetic", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
            if AKYRS.is_mod_loaded("Prism") then
                if not next(context.poker_hands["Flush"]) then
                    SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Myth", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
            if AKYRS.is_mod_loaded("kino") then
                if math.fmod(G.GAME.current_round.hands_played, 2) == 1 then
                    SMODS.calculate_effect({ func = function() SMODS.add_card({set = "confection", area = G.consumeables, edition = "e_negative"}) end}, card)
                end
            end
        end 
        if AKYRS.is_mod_loaded("Astronomica") then
            if context.after then
                local cards_below_hand = math.max(G.hand.config.card_limit - #G.play.cards ,1)
                if cards_below_hand > 1 then
                    SMODS.calculate_effect({akyrs_xscore = cards_below_hand}, card)
                end
            end
        end
        if AKYRS.is_mod_loaded("HotPotato") then
            if context.final_scoring_step then
                SMODS.calculate_effect ({
                    func = function ()
                        ease_spark_points(math.floor(hand_chips) * 10.0)
                    end
                }, card)
            end
        end
        if AKYRS.is_mod_loaded("finity") and context.blind_defeated and G.GAME.blind and G.GAME.blind.boss and G.GAME.blind.config.blind.boss.showdown then
            SMODS.calculate_effect({ func = function() SMODS.add_card({key = "c_finity_finity", area = G.consumeables, edition = "e_negative"}) end}, card)
        end
        if garb_enabled and context.selling_card and context.card.ability.set == "Joker" then
            SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Stamp", area = G.consumeables, edition = "e_negative"}) end}, card)
        end
        if AKYRS.is_mod_loaded("Maximus") and context.selling_card and context.card.ability.set == "Planet" then
            SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Horoscope", edition = "e_negative"}) end}, card)
        end
        if AKYRS.is_mod_loaded("Sagatro") and context.selling_card and context.card.ability.set == "Tarot" then
            SMODS.calculate_effect({ func = function() SMODS.add_card({set = "Divinatio", edition = "e_negative"}) end}, card)
        end
        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                return {
                        xmult = card.ability.extras.base.xmult
                }
            end
        end
        if context.akyrs_round_eval then
            local d = Talisman and to_big(context.dollars) or context.dollars
            local v = Talisman and to_big(10) or 10
            local c = d < v
            if togabalatro and c then
                local tag = Tag(pseudorandom_element(toga_tags,pseudoseed("akyrs_aikoyori_toga_tags")))
                add_tag(tag)
            end
            if PTASaka then
                if Talisman then
                    ease_pyrox(to_number(context.dollars))
                else
                    ease_pyrox(context.dollars)
                end
            end
        end
    end,
    blueprint_compat = true
}