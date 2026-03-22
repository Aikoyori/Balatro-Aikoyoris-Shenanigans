local to_number = to_number or function(x) return x end

-- repeater
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 0
    },
    pools = { ["Minecraft"] = true, ["Redstone"] = true },
    key = "redstone_repeater",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 1,
            mult = 2.25,
            starting_mult = 1,
            exp = 1.5
        }
    },

    loc_vars = function(self, info_queue, card)
        local multer = {
            {
                n = G.UIT.R,
                config = { alin = "cm", padding = 0.05},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = { text = localize("akyrs_start_with"), colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
                            }
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            SMODS.GUI.operator(0.2),
                            {
                                n = G.UIT.C,
                                config = { align = "cm", padding = 0.1 },
                                nodes = {
                                    AKYRS.faux_score_container(card.ability.extra, "starting_mult", { align = 'lc', w = 1, h = 0.5, scale = 0.15 })
                                }
                            },
                        }
                    },
                    
                }
            },
            {
                n = G.UIT.R,
                config = { alin = "cm", padding = 0.05},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = { text = localize("akyrs_stored_open"), colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
                            }
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            SMODS.GUI.operator(0.2),
                            {
                                n = G.UIT.C,
                                config = { align = "cm", padding = 0.1 },
                                nodes = {
                                    AKYRS.faux_score_container(card.ability.extra, "mult_stored", { align = 'lc', w = 1, h = 0.5, scale = 0.15 })
                                }
                            },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = { text = localize("akyrs_stored_close"), colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
                            }
                        }
                    },
                    
                }
            },
        }
        if AKYRS.bal("absurd") then
            return {
                key = self.key..'_absurd',
                vars = { card.ability.extra.mult_stored, card.ability.extra.exp, card.ability.extra.starting_mult },
                main_end = multer,
            }
        end
        return {
            vars = { card.ability.extra.mult_stored, card.ability.extra.mult, card.ability.extra.starting_mult },
            main_end = multer,
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card or context.forcetrigger then
            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            card.ability.extra.mult_stored = stored
            update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })
            
            local ind = AKYRS.find_index(card.area.cards, card)
            if ind and ind > 1 and card.area.cards[ind - 1].config.center_key == card.config.center_key then
                check_for_unlock({type = "akyrs_repeater_into_another_one"})
            end
            if AKYRS.bal("absurd") then
                return {
                    message = "Swapped!",
                    emult = card.ability.extra.exp,
                }
            end
            return {
                message = "Swapped!",
                xmult = card.ability.extra.mult,
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
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
            mult_stored = 0,
            xmult_stored = 1,
            mult = 4,
            xmult = 1,
            times = 2,
            total_times = 2,
            times_increment = 1,
            mult_change = 0,
            chip_change = 0
        },
        name = "Observer"
    },

    loc_vars = function(self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key..'_absurd',
                vars = { card.ability.extra.xmult, card.ability.extra.xmult_stored, card.ability.extra.times,
                    card.ability.extra.total_times, card.ability.extra.times_increment }
            }
        end
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult_stored, card.ability.extra.times,
                card.ability.extra.total_times, card.ability.extra.times_increment }
        }
    end,
    calculate = function(self, card, context)
        if context.akyrs_score_change and AKYRS.bal("absurd") and not context.blueprint then
            -- this does not need scaling
            card.ability.extra.times = card.ability.extra.times - 1
            return {
                func = function()
                    card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
                        instant = true,
                        card_align = "m",
                        message = localize {
                            type = 'variable',
                            key = 'a_remaining',
                            vars = { card.ability.extra.times }
                        },
                    })
                    --update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })

                    if card.ability.extra.times <= 0 then
                        card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
                            instant = true,
                            card_align = "m",
                            message = localize {
                                type = 'variable',
                                key = 'a_remaining',
                                vars = { card.ability.extra.times }
                            },
                        })
                        -- this also does NOT need scaling
                        card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
                        card.ability.extra.times = card.ability.extra.total_times
                        -- this however do
                        SMODS.scale_card(card,{
                            ref_table = card.ability.extra,
                            ref_value = "xmult_stored",
                            scalar_value = "xmult",
                        })
                    end
                    card.ability.extra.mult_change = mult
                    card.ability.extra.chip_change = chips
                end
            }
        end
        if context.individual and AKYRS.bal("adequate") and (context.cardarea == G.hand or context.cardarea == G.jokers or context.cardarea == G.play) and not context.blueprint then
            SMODS.calculate_effect({
                message = localize { type = 'variable', key = 'a_remaining', vars = { card.ability.extra.times }},
                card = card,
                func = function ()
                    card.ability.extra.times = card.ability.extra.times - 1
                    if card.ability.extra.times <= 0 then
                        SMODS.calculate_effect({
                            func = function ()
                                -- same deal here
                                SMODS.scale_card(card,{
                                    ref_table = card.ability.extra,
                                    ref_value = "mult_stored",
                                    scalar_value = "mult",
                                })
                                if context.other_card then
                                    AKYRS.simple_event_add(
                                        function()
                                        if context.other_card then AKYRS.juice_like_tarot(context.other_card) 
                                        end return true end
                                    )
                                end
                                card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
                                card.ability.extra.times = card.ability.extra.total_times
                            end,
                            card = card,
                        })
                    end
                end
            })
        end
        if context.joker_main or context.forcetrigger then
            return AKYRS.bal_val(
                {
                    mult = card.ability.extra.mult_stored,
                },
                {
                    xmult = card.ability.extra.xmult_stored,
                }
            )
        end
    end,
	demicoloncompat = true,
    blueprint_compat = true
}
-- quasi connectivity
SMODS.Joker {

    pools = { ["Minecraft"] = true, ["Redstone"] = true },
    atlas = 'AikoyoriJokers',
    pos = {
        x = 2,
        y = 0
    },
    key = "quasi_connectivity",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key..'_absurd',
            vars = { card.ability.extra.emult }
            }
        end
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    config = {
        name = "Quasi Connectivity",
        extra = {
            mult = 6,
            emult = 4,
            first_hand = true
        }
    },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            return {
                func = function()
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
                        local re = AKYRS.bal("absurd") and 2 or 1
                        for i = 1, re do
                            local _card = pseudorandom_element(jokers, pseudoseed('akyrs:quasi_connectivity'))
                            local iter = 1
                            while _card and _card.debuff and iter < #jokers do
                                local _card = pseudorandom_element(jokers, pseudoseed('akyrs:quasi_connectivity'))
                                iter = iter + 1
                            end
                            if _card then
                                _card:set_debuff(true)
                                _card:juice_up(1, 1)
                            end
                            jokers[_card] = nil
                        end
                    end
                end
                G.GAME.aiko_has_quasi = false
                card.ability.extra.first_hand = false
            end
            }
        end
        if context.joker_main or context.forcetrigger then
            return AKYRS.bal_val(
                {
                    xmult = card.ability.extra.mult,
                },
                {
                    emult = card.ability.extra.emult,
                }
            )
        end
        if context.selling_card then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:set_debuff(false)
                end
            end
        end
    end,
	demicoloncompat = true,
    blueprint_compat = true
}
-- diamond pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    enhancement_gate = "m_stone",
    pools = { ["Minecraft"] = true },
    pos = {
        x = 3,
        y = 0
    },
    key = "diamond_pickaxe",
    rarity = 2,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        if AKYRS.bal("absurd") then
            return {
                key = self.key..'_absurd',
                vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack_absurd }
            }
        end
        return {
            vars = { card.ability.extra.chips_adequate, card.ability.extra.chips_take }
        }
    end,
    config = {
        name = "Diamond Pickaxe",
        extra = {
            chip_add = 64,
            chips_adequate = 0,
            chips_take = 10,
            chip_add_stack_absurd = 12,
        }
    },
    add_to_deck = function (self, card, from_debuff)
        if #SMODS.find_card("j_akyrs_netherite_pickaxe") > 0 then
            check_for_unlock({ type = "akyrs_both_pickaxe" })
        end
    end,
    calculate = function(self, card, context)
        if AKYRS.bal("absurd") then
            if context.before and not context.blueprint or context.forcetrigger then
                AKYRS.simple_event_add(
                    function()
                        for _,cardhand in ipairs(G.hand.cards) do
                            cardhand:set_ability(G.P_CENTERS["m_stone"])
                            cardhand:juice_up(0.5, 2)
                        end
                        return true
                    end
                )
            end
            if context.individual and context.cardarea == G.play then
                if context.other_card.config.center_key == "m_stone" then
                    for i = 1, to_number(card.ability.extra.chip_add_stack_absurd) do
                        context.other_card:juice_up(0.5, 2)
                        SMODS.calculate_effect({
                            chips = card.ability.extra.chip_add,
                            juice_card = context.other_card,
                        },card)
                    end
                    return {
                        juice_card = context.other_card,
                        func = function ()
                            if  not context.blueprint then
                            context.other_card:set_ability(
                                pseudorandom_element(NON_STONE_UPGRADES, pseudoseed('akyrj:pickaxe')), nil, true)
                            end
                        end
                    }
                end
            end    
        else
            if context.before and not context.blueprint then
                for _, _c in ipairs(context.full_hand) do
                    SMODS.calculate_effect({
                        func = function ()
                            if _c.config.center_key == "m_stone" then
                                AKYRS.simple_event_add(
                                    function ()
                                        if AKYRS.compare(_c.ability.bonus - card.ability.extra.chips_take,">",0) then
                                            AKYRS.juice_like_tarot(_c)
                                            _c.ability.bonus = _c.ability.bonus - card.ability.extra.chips_take
                                            card.ability.extra.chips_adequate = card.ability.extra.chips_adequate + card.ability.extra.chips_take
                                        else
                                            AKYRS.juice_like_tarot(_c)
                                            card.ability.extra.chips_adequate = card.ability.extra.chips_adequate + _c.ability.bonus
                                            _c:set_ability(G.P_CENTERS["c_base"])
                                            _c.ability.bonus = 0
                                        end
                                        return true
                                    end
                                )
                            end
                        end,
                        message = localize("k_upgrade_ex")
                    }, card)
                end
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips_adequate
                }
            end
        end

    end,
	demicoloncompat = true,
    blueprint_compat = true
}
-- netherite pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    enhancement_gate = "m_stone",
    pools = { ["Minecraft"] = true },
    pos = {
        x = 4,
        y = 0
    },
    key = "netherite_pickaxe",
    rarity = 3,
    cost = 8,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        if AKYRS.bal("absurd") then
            return {
                key = self.key..'_absurd',
                vars = { card.ability.extra.xchip_add, card.ability.extra.chip_add_stack_absurd, card.ability.extra.xchip_storage  }
            }
        end
        return {
            vars = { card.ability.extra.xchips_adequate, card.ability.extra.xchips_add_when_stone_gone }
        }
    end,
    add_to_deck = function (self, card, from_debuff)
        if #SMODS.find_card("j_akyrs_diamond_pickaxe") > 0 then
            check_for_unlock({ type = "akyrs_both_pickaxe" })
        end
    end,
    config = {
        name = "Netherite Pickaxe",
        extra = {
            xchip_add = 0.64,
            xchip_storage = 1,
            
            xchips_adequate = 1,
            xchips_add_when_stone_gone = 0.1,

            
            chip_add = 64,
            chip_add_stack_absurd = 18,
        }
    },
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        
        if AKYRS.should_show_card_previews() then
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
                                SMODS.calculate_context({ remove_playing_cards = true, removed = k})
                                k:start_dissolve({G.C.CHIPS}, true)
                            end
                        end
                    end
                end,
            })
        end
    end,
    calculate = function(self, card, context)
        if AKYRS.bal("absurd") then
            if context.individual and context.cardarea == G.play and not context.blueprint then
                if context.other_card.config.center_key == "m_stone" then
                    context.other_card.ability.aiko_about_to_be_destroyed = true
                    SMODS.calculate_effect({
                        func = function ()
                            SMODS.scale_card(card,{
                                ref_table = card.ability.extra,
                                ref_value = "xchip_storage",
                                scalar_value = "xchip_add",
                                -- smods whyyyyy
                                operation = function (ref_t,ref_v,initial,scalar)
                                    ref_t[ref_v] = initial + scalar * card.ability.extra.chip_add_stack_absurd
                                end
                            })
                            
                        end
                    },card)
                end
            end

            if (context.joker_main or context.forcetrigger) then
                return {
                    xchips = card.ability.extra.xchip_storage
                }
            end

            if context.pre_discard and not context.forcetrigger then
                return {
                    func = function ()
                        AKYRS.simple_event_add(
                            function()
                                for _,cardhand in ipairs(context.full_hand) do
                                    cardhand:set_ability(G.P_CENTERS["m_stone"])
                                    cardhand:juice_up(0.5, 2)
                                end
                                return true
                            end
                        )
                    end
                }
            end

            if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.destroy_card.ability.eternal then
                if context.destroy_card.ability.aiko_about_to_be_destroyed then
                    return { remove = true }
                end
            end
        else
            if context.destroy_card and not context.blueprint then
                for _, _c in ipairs(context.full_hand) do
                    if _c.config.center_key == "m_stone" and context.destroy_card == _c then
                        AKYRS.simple_event_add(
                            function ()
                                card.ability.extra.xchips_adequate = card.ability.extra.xchips_adequate + card.ability.extra.xchips_add_when_stone_gone
                                return true
                            end
                        )
                        return {
                            message = localize("k_upgrade_ex"),
                            remove = true
                        }
                    end
                end
            end
            if context.joker_main then
                return {
                    xchips = card.ability.extra.xchips_adequate
                }
            end
        end

    end,
	demicoloncompat = true,
    blueprint_compat = true
}
-- utage charts
SMODS.Joker {
    pools = { ["Rhythm Games"] = true, ["Maimai"] = true, ["Music"] = true, },
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
        play_mod = 3,
    },
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(card.ability.play_mod)
        SMODS.change_discard_limit(card.ability.play_mod)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(-card.ability.play_mod)
        SMODS.change_discard_limit(-card.ability.play_mod)
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
        if AKYRS.bal("absurd") then
            info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_scoreless"]
        end
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"),
            vars = { 
                AKYRS.bal_val(card.ability.extra.mult, card.ability.extra.emult_absurd)
            }
        }
    end,
    config = {
        extra = {
            mult = 1.5,
            emult_absurd = 1.2,
        }
    },
    calculate = function(self, card, context)
        if AKYRS.bal("absurd") then
            if context.individual and context.cardarea == 'unscored' then
                return {
                    emult = card.ability.extra.emult_absurd,
                    func = function ()
                        context.other_card:set_ability(G.P_CENTERS["m_akyrs_scoreless"])
                        context.other_card:juice_up(0.5,1)
                    end
                }
            end
        else
            if context.hand_drawn and not context.blueprint then
                local to_be_debuffed = {}
                for _, _card in ipairs(G.play.cards) do if not _card.debuff then table.insert(to_be_debuffed, _card) end end
                for _, _card in ipairs(G.hand.cards) do if not _card.debuff then table.insert(to_be_debuffed, _card) end end
                local card_to_debuff = pseudorandom_element(to_be_debuffed, "akyrs_forbiddendog")
                if card_to_debuff then
                    return {
                        func = function ()
                            card_to_debuff:set_debuff(true)
                        end
                    }
                end
            end
            if context.joker_main then
                local debuffed = {}
                for _, _card in ipairs(G.hand.cards) do if _card.debuff then table.insert(debuffed, _card) end end
                for _, _card in ipairs(debuffed) do
                    SMODS.calculate_effect({ xmult = card.ability.extra.mult }, _card)
                end
            end
        end
    end,
	demicoloncompat = true,
    blueprint_compat = true,
}

-- eat pant
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 8,
        y = 0
    },
    pools = { ["Meme"] = true },
    key = "eat_pant",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
            vars = AKYRS.bal_val({ 
                math.floor(card.ability.extra.card_target),
                card.ability.extra.extra,
                card.ability.extra.Xmult,
             }, { 
                "heheheha",
                card.ability.extra.extra_absurd,
                card.ability.extra.Xmult_absurd,
             })
        }
    end,
    config = {
        extra = {
            extra = 16,
            extra_absurd = 2,
            card_target = 4,
            Xmult = 1,
            Xmult_absurd = 1,
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then	
            return {
                xmult = AKYRS.bal_val(card.ability.extra.Xmult,card.ability.extra.Xmult_absurd)
            }
        end
        if AKYRS.bal("absurd") then
            if context.individual and context.cardarea == G.play and next(context.poker_hands["Two Pair"]) or context.forcetrigger then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    card = card,
                    func = function ()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "Xmult_absurd",
                            scalar_value = "extra_absurd"
                        })
                    end
                }
            end
            if context.destroy_card and (context.cardarea == G.play or context.cardarea == 'unscored') and not context.blueprint and not context.destroy_card.ability.eternal and not context.forcetrigger then
                if next(context.poker_hands["Two Pair"]) then
                    return { remove = true }
                end
            end
        else
            if context.destroy_card then
                if #context.full_hand == 4 then
                    if context.destroy_card == context.full_hand[1] or context.destroy_card == context.full_hand[2] then
                        return {
                            message = localize('k_akyrs_downgrade_ex'),
                            colour = G.C.MULT,
                            remove = true,
                            func = function ()
                                card.ability.extra.Xmult = card.ability.extra.Xmult * (1-(1)/card.ability.extra.extra)
                            end
                        }
                    end
                end
            end
        end
    end,
	demicoloncompat = true,
    blueprint_compat = true,
}



-- yona yona dance
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 1
    },
    pools = { ["J-POP"] = true },
    key = "yona_yona_dance",
    rarity = 3,
    cost = 8,
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
	demicoloncompat = true,
}

SMODS.Joker {
    key = "tldr_joker",
    atlas = 'AikoyoriJokers',
	pools = { ["Meme"] = true },
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
        if AKYRS.bal("absurd") then
            info_queue[#info_queue+1] = G.P_CENTERS["j_chaos"]
            info_queue[#info_queue+1] = G.P_CENTERS["c_moon"]
            info_queue[#info_queue+1] = G.P_CENTERS["v_grabber"]
            info_queue[#info_queue+1] = G.P_CENTERS["j_ceremonial"]
            if AKYRS.is_mod_loaded("Cryptid") then
                info_queue[#info_queue+1] = G.P_CENTERS["c_cry_summoning"]
                info_queue[#info_queue+1] = G.P_CENTERS["j_cry_exponentia"]
                info_queue[#info_queue+1] = G.P_BLINDS["bl_cry_tax"]
            end
            info_queue[#info_queue+1] = G.P_CENTERS["m_lucky"]
            info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_shimmer_bucket"]
            info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_tldr_tldr_absurd", vars = {card.ability.extra.xmult}}
            info_queue[#info_queue+1] = G.P_CENTERS["v_akyrs_alphabet_soup"]
            info_queue[#info_queue+1] = G.P_CENTERS["j_oops"]
        else
            info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
            info_queue[#info_queue+1] = {set = "DescriptionDummy", key = "dd_akyrs_tldr_tldr", vars = {card.ability.extra.mult}}
        end
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
            scale = 0.7,
            vars = { 
                AKYRS.bal_val(card.ability.extra.mult,card.ability.extra.xmult)
            }
        }
    end,
    config = {
        extra = {
            mult = 2,
            xmult = 3
        },
    },
    calculate = function(self, card, context)
        if AKYRS.bal("absurd") then
                if context.joker_main or context.forcetrigger then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        else
            if context.joker_main or context.individual and not context.end_of_round and (context.cardarea == G.hand or context.cardarea == G.play) or context.forcetrigger then
                return AKYRS.bal_val(
                    {
                        mult = card.ability.extra.mult
                    }
                )
            end
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
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
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
            vars = {
            }
        }
    end,
    config = {
        extra = {
        },
    },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                message = localize('k_akyrs_reciprocaled'),
                func = function()
                    if AKYRS.bal("absurd") then
                        hand_chips = mod_mult(mult / hand_chips)
                    else
                        mult = mod_mult(hand_chips / mult)
                    end
                    update_hand_text({ delay = 0, immediate = false }, { mult = mult, chips = hand_chips })
                end
            }
        end
    end,
	demicoloncompat = true,
    blueprint_compat = true,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "kyoufuu_all_back",
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
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
        if context.hand_drawn or context.forcetrigger then
            return {
                message = localize('k_akyrs_drawn_discard'),
                func = function()
                    AKYRS.simple_event_add(
                        function ()
                            G.FUNCS.draw_from_discard_to_deck()

                            AKYRS.simple_event_add(
                                function ()
                                    AKYRS.remove_dupes(G.deck.cards)
                                    return true
                                end, 0
                            )
                            return true
                        end, 0
                    )
                end
            }
        end
    end,
    blueprint_compat = false,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pools = { ["Tech"] = true, },
    key = "2fa",
    pos = {
        x = 3,
        y = 1
    },
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        if AKYRS.config.show_joker_preview then
            info_queue[#info_queue + 1] = AKYRS.DescriptionDummies["dd_akyrs_2fa_example"]
        end
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extra.xchips_gain,
                    card.ability.extra.xmult_gain,
                    card.ability.extra.xchips,
                    card.ability.extra.xmult,
                }
            }            
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

            xmult = 1,
            xchips = 1,
            xmult_gain = .1,
            xchips_gain = 0.3,
        },
    },
    calculate = function(self, card, context)
        if context.before or context.forcetrigger then
            for i, _card in ipairs(G.play.cards) do
                SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "chips", scalar_value = "extra" })
            end
            return {
                message = localize("k_akyrs_2fa_generate")
            }
        end
        if (context.joker_main or context.forcetrigger) and AKYRS.bal("adequate") then
            return {
                chips = card.ability.extra.chips
            }
        end
        if (context.joker_main or context.forcetrigger) and AKYRS.bal("absurd") then
            return {
                xchips = card.ability.extra.xchips,
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and AKYRS.bal("adequate") then
            return {
                message = localize("k_akyrs_2fa_reset"),
                func = function()
                    card.ability.extra.chips = card.ability.extra.chips / 2
                end
            }
        end
        if context.after and not context.blueprint then
            return {
                func = function()
                    for i, _card in ipairs(G.play.cards) do
                        local original_rank = _card:get_id()
                        local original_suit = _card.base.suit
                        G.E_MANAGER:add_event(Event {
                            trigger = 'after',
                            blocking = false,
                            delay = 0.2 * AKYRS.get_speed_mult(_card),
                            func = function()
                                if G.play and G.play.cards then
                                    local percent = math.abs(1.15 - (i - 0.999) / (#G.play.cards - 0.998) * 0.3)
                                    if G.play.cards[i] then
                                        G.play.cards[i]:flip()
                                    end
                                    --G.play.cards[i]:a_cool_fucking_spin(1,math.pi * 100)
                                    play_sound('card1', percent);
                                end
                                return true
                            end
                        })
                        G.E_MANAGER:add_event(Event {
                            trigger = 'after',
                            delay = 0.5 * AKYRS.get_speed_mult(card),
                            blocking = false,
                            func = function()
                                if G.play and G.play.cards then
                                    local _rank = nil
                                    local _suit = nil
                                    while _rank == nil or _suit == nil do
                                        _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('akyrs2far'))
                                        _suit = pseudorandom_element(SMODS.Suits, pseudoseed('akyrs2fas'))
                                    end
                                    if G.play.cards[i] then
                                        assert(SMODS.change_base(G.play.cards[i], _suit.key, _rank.key))
                                        G.play.cards[i]:flip()
                                        if G.play.cards[i]:get_id() == original_rank and AKYRS.bal("absurd") then
                                            SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "xchips", scalar_value = "xchips_gain" })
                                        end
                                        if G.play.cards[i].base.suit == original_suit and AKYRS.bal("absurd") then
                                            SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "xmult_gain" })
                                        end
                                    end
                                end

                                return true
                            end
                        })
                    end
                    delay((0.5 * AKYRS.get_speed_mult(card) + 0.2 * #G.play.cards))
                end,
                message = localize("k_akyrs_2fa_regen"),
            }
        end
    end,
    demicoloncompat = true,
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
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            xmult = 1,
            extra = 0.5,
            eemult = 1.21,
            eemult_negative = 0.35,
            chance = 3,
            super_mario = 1,
        },
    },
    loc_vars = function(self, info_queue, card)
        if AKYRS.bal("absurd") then
            local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'akyrs_gaslighting_absurd')
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extra.eemult,
                    card.ability.extra.eemult_negative,
                    num,
                    denom,
                }
            }
        end
        return {
            vars = {
                card.ability.extra.extra,
                card.ability.extra.xmult,
            }
        }
    end,
    calculate = function(self, card, context)
        if AKYRS.bal("absurd") and (context.joker_main or context.forcetrigger) then
            local odder = SMODS.pseudorandom_probability(card, "akyrs_gaslighting_absurd",1, card.ability.extra.chance, 'akyrs_gaslighting_absurd')
            if odder then
                return {
                    eemult = card.ability.extra.eemult
                }
            else
                return {
                    eemult = card.ability.extra.eemult_negative

                }
            end
        end
        if AKYRS.bal("adequate") then
            if context.joker_main or context.forcetrigger then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
            if context.final_scoring_step and G.GAME.blind then
                
                    G.E_MANAGER:add_event(
                        Event{
                            func = function ()
                                if SMODS.last_hand_oneshot then
                                    card.ability.extra.xmult = 1
                                else 
                                    
                                    SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "extra" })
                                end
                                return true
                            end
                        }
                    )
                    if SMODS.last_hand_oneshot then
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
 
    end,
    demicoloncompat = true,
    blueprint_compat = true,
}

-- hibana 
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "hibana",
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
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
        possible_table = {
            {"Ace", "Rank", {"k_aces", "dictionary"}},
            {"Face Cards", "Condition", {"k_face_cards","dictionary"}},
            {"Hearts", "Suit", {"Hearts", 'suits_plural'}},
            {"5", "Rank", {"5", "ranks"}}
        },
        immutable = {
            akyrs_cycler = 1,
            akyrs_priority_draw_rank = "Ace",
            akyrs_priority_draw_suit = nil,
            akyrs_priority_draw_conditions = nil,
        },
    },
    set_ability = function (self, card, initial, delay_sprites)
        if card.ability.immutable.akyrs_cycler ~= 1 and card.ability.immutable.akyrs_cycler ~= 2 and card.ability.immutable.akyrs_cycler ~= 3 and card.ability.immutable.akyrs_cycler ~= 4 then
            card.ability.immutable.akyrs_cycler = 1
        end
    end,
    loc_vars = function(self, info_queue, card)
        if card.ability.immutable.akyrs_cycler ~= 1 and card.ability.immutable.akyrs_cycler ~= 2 and card.ability.immutable.akyrs_cycler ~= 3 and card.ability.immutable.akyrs_cycler ~= 4 then
            card.ability.immutable.akyrs_cycler = 1
        end
        local table = card.ability.possible_table[math.floor(card.ability.immutable.akyrs_cycler)]
        info_queue[#info_queue+1] = { key = "dd_akyrs_hibana_conditions", set = "DescriptionDummy"}
        return {
            vars = {
                localize(table[3][1],table[3][2]),
                card.ability.immutable.akyrs_cycler,
            }
        }
    end,
    calculate = function (self, card, context)
        if (context.end_of_round or context.forcetrigger) and context.cardarea == G.jokers then
            if card.ability.immutable.akyrs_cycler ~= 1 and card.ability.immutable.akyrs_cycler ~= 2 and card.ability.immutable.akyrs_cycler ~= 3 and card.ability.immutable.akyrs_cycler ~= 4 then
                card.ability.immutable.akyrs_cycler = 1
            end
            card.ability.immutable.akyrs_priority_draw_rank = nil
            card.ability.immutable.akyrs_priority_draw_suit = nil
            card.ability.immutable.akyrs_priority_draw_conditions = nil
            card.ability.immutable.akyrs_cycler = math.fmod(card.ability.immutable.akyrs_cycler,#(card.ability.possible_table)) + 1
            local curr = card.ability.possible_table[card.ability.immutable.akyrs_cycler]
            if curr[2] == "Rank" then
                card.ability.immutable.akyrs_priority_draw_rank = curr[1]
            end
            if curr[2] == "Suit" then
                card.ability.immutable.akyrs_priority_draw_suit = curr[1]
            end
            if curr[2] == "Condition" then
                card.ability.immutable.akyrs_priority_draw_conditions = curr[1]
            end
            return {
                message = localize('k_akyrs_hibana_change')
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)        
        card.ability.immutable.akyrs_cycler = math.floor(card.ability.immutable.akyrs_cycler)
        card.ability.immutable.akyrs_priority_draw_rank = nil
        card.ability.immutable.akyrs_priority_draw_suit = nil
        card.ability.immutable.akyrs_priority_draw_conditions = nil
        local curr = card.ability.possible_table[card.ability.immutable.akyrs_cycler]
        if curr[2] == "Rank" then
            card.ability.immutable.akyrs_priority_draw_rank = curr[1]
        end
        if curr[2] == "Suit" then
            card.ability.immutable.akyrs_priority_draw_suit = curr[1]
        end
        if curr[2] == "Condition" then
            card.ability.immutable.akyrs_priority_draw_conditions = curr[1]
        end
        if G.deck then
            G.deck:shuffle()
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        if G.deck then
            G.deck:shuffle()
        end
    end,
    demicoloncompat = true,
    hpot_unbreedable = true,
}


SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "centrifuge",
    pools = { ["Science"] = true },
    pos = {
        x = 0, y = 2
    },
    rarity = 2,
    cost = 2,
    config = {
        extra = {
            rank_delta = 1,
            chips = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_scoreless"]
            return {
                key = self.key .. "_absurd",
                vars = {
                    1,
                }
            }
        end
        return {
            vars = {
                1,
                card.ability.extra.chips
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
                    delay = 0.2*AKYRS.get_speed_mult(card),
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
                        delay = 0.5*AKYRS.get_speed_mult(card),
                        func = function ()
                            local rankToChangeTo = card2.base.value
                            local ed = poll_edition("akyrs_centrifuge_absurd_edition",1, true, true)
                            local en = SMODS.poll_enhancement({guaranteed = true, key = "akyrs_centrifuge_absurd"})
                            if type(en) == "string" then en = G.P_CENTERS[en] end
                            local rim = true
                            if i == 1 or i == #G.play.cards then
                                rankToChangeTo = pseudorandom_element(SMODS.Ranks[card2.base.value].next,pseudoseed("akyrscentrifuge"))
                            else
                                en = G.P_CENTERS["m_akyrs_scoreless"]
                                rankToChangeTo = pseudorandom_element(SMODS.Ranks[card2.base.value].prev,pseudoseed("akyrscentrifuge"))
                                rim = false
                            end
                            card2:flip()
                            assert(SMODS.change_base(card2, nil, rankToChangeTo))
                            if AKYRS.bal("absurd") then
                                card2:set_ability(en)
                                if rim then card2:set_edition(ed) end
                                
                            end
                            return true
                        end
                    }
                )
            end
            delay(0.1*AKYRS.get_speed_mult(card)+0.3*#G.play.cards)
        end
        if context.joker_main and AKYRS.bal("adequate") then
            return {
                chips = card.ability.extra.chips * #G.play.cards,
                message = localize("k_akyrs_centrifuged")
            }
        end
    end,
    demicoloncompat = true,

}


SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "neurosama",
    pools = { ["Vtuber"] = true, },
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
            xmult_absurd = 1,
            xmult_inc_absurd = 1.2,
        }
    },
    loc_vars = function (self,info_queue, card)
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
            vars = AKYRS.bal_val({
                card.ability.extras.xmult,
                card.ability.extras.xmult_inc
            },
            {
                card.ability.extras.xmult_absurd,
                card.ability.extras.xmult_inc_absurd
            })
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and not next(context.poker_hands["Flush"]) then
            if context.other_card:is_suit("Hearts") or ((context.other_card:is_suit("Spades") and next(SMODS.find_card("j_akyrs_evilneuro")))) then
                return {
                    message_card = card,
                    func = function ()
                        if Talisman then
                            card.ability.extras.xmult_absurd = to_big(card.ability.extras.xmult_absurd)
                            card.ability.extras.xmult_inc_absurd = to_big(card.ability.extras.xmult_inc_absurd)
                        end
                        if AKYRS.bal("absurd") then
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult_absurd", scalar_value = "xmult_inc_absurd" })
                        else
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult", scalar_value = "xmult_inc" })
                        end
                    end
                }
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xmult = AKYRS.bal_val(card.ability.extras.xmult,card.ability.extras.xmult_absurd)
            }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
    hpot_unbreedable = true,
}

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "evilneuro",
    pools = { ["Vtuber"] = true, },
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
            xchips_absurd = 1.1,
            xchips_inc_absurd = 1.1,
        }
    },
    loc_vars = function (self,info_queue, card)
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"), 
            vars = AKYRS.bal_val({
                card.ability.extras.xchips,
                card.ability.extras.xchips_inc
            },
            {
                card.ability.extras.xchips_absurd,
                card.ability.extras.xchips_inc_absurd
            })
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint and not next(context.poker_hands["Flush"]) then
            if context.other_card:is_suit("Clubs") or ((context.other_card:is_suit("Diamonds") and next(SMODS.find_card("j_akyrs_neurosama")))) then
                return {
                    message_card = card,
                    func = function ()
                        if AKYRS.bal("adequate") then
                            
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xchips", scalar_value = "xchips_inc" })
                        end
                        if AKYRS.bal("absurd") then
                            card.ability.extras.xchips_absurd = to_big(card.ability.extras.xchips_absurd)
                            card.ability.extras.xchips_inc_absurd = to_big(card.ability.extras.xchips_inc_absurd)
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xchips_absurd", scalar_value = "xchips_inc_absurd",
                                operation = function (ref_t,ref_v,initial,scalar)
                                    ref_t[ref_v] = initial ^ scalar 
                                end })
                        end
                    end
                }
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
                xchips = AKYRS.bal_val(card.ability.extras.xchips,card.ability.extras.xchips_absurd)
            }
        end
    end,
    blueprint_compat = true,
    demicoloncompat = true,
    hpot_unbreedable = true,
}

-- happy ghast family

-- also for future reference scale_card should not be used on round timer

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "dried_ghast",
    pools = { ["Minecraft"] = true, },
    pos = {
        x = 3, y = 2
    },
    rarity = 3,
    cost = 6,
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
        if (context.end_of_round and context.cardarea == G.jokers or context.forcetrigger) and not context.blueprint then
            if not card.ability.do_not_decrease then
                return {
                    message = localize("k_akyrs_moisture"),
                    func = function ()
                        card.ability.extras.rounds_left = card.ability.extras.rounds_left - 1
                        if card.ability.extras.rounds_left <= 0 then
                            card:start_dissolve({G.C.BLUE}, nil, 0.5)
                            local c = SMODS.add_card({ key = "j_akyrs_ghastling"})
                            c.ability.akyrs_from_dried = true
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
    end,
    demicoloncompat = true,
}

SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "ghastling",
    pools = { ["Minecraft"] = true, },
    pos = {
        x = 4, y = 2
    },
    rarity = 3,
    cost = 8,
    config = {
        name = "Ghastling",
        extras = {
            rounds_left = 10,
            rounds_left_absurd = 20,
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
                AKYRS.bal_val(card.ability.extras.rounds_left,card.ability.extras.rounds_left_absurd),
                card.ability.extras.mult,
                3
            }
        }
    end,
    calculate = function (self, card, context)
        if (context.after and context.cardarea == G.jokers or context.forcetrigger) and not context.blueprint then
            if not card.ability.do_not_decrease then
                return {
                    message = localize("k_akyrs_growth"),
                    func = function ()
                        card.ability.extras.rounds_left = card.ability.extras.rounds_left - (#SMODS.find_card("j_ice_cream") + 1)
                        card.ability.extras.rounds_left_absurd = card.ability.extras.rounds_left_absurd - (#SMODS.find_card("j_ice_cream") + 1)
                        if AKYRS.bal_val(card.ability.extras.rounds_left <= 0,card.ability.extras.rounds_left_absurd <= 0) then
                            card:start_dissolve({G.C.RED}, nil, 0.5)
                            if card.ability.akyrs_from_dried then
                                check_for_unlock({ type = "akyrs_happy_ghast_grown_from_dried"})
                            end
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
        if (context.joker_main or context.forcetrigger) then
            return {
                mult = card.ability.extras.mult
            }
        end
    end,
    demicoloncompat = true,
    blueprint_compat = true
}


SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "happy_ghast",
    pools = { ["Minecraft"] = true, },
    pos = {
        x = 5, y = 2
    },
    rarity = 3,
    cost = 10,
    config = {
        name = "Happy Ghast",
        extras = {
            xmult = 4.32,
            eemult_absurd = 2.16
        }
    },
    in_pool = function (self, args)
        return false
    end,
    loc_vars = function (self,info_queue, card)
        return {
            key = AKYRS.bal_val(self.key, self.key.."_absurd"),
            vars = {
                AKYRS.bal_val(card.ability.extras.xmult,card.ability.extras.eemult_absurd)
            }
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal_val(context.joker_main,context.individual and context.cardarea == G.play) or context.forcetrigger then
            return AKYRS.bal_val({
                xmult = card.ability.extras.xmult
            },{
                emult = card.ability.extras.eemult_absurd
            })
        end
    end,
    demicoloncompat = true,
    blueprint_compat = true
}

-- charred roach
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true, },
    key = "charred_roach",
    pos = {
        x = 6, y = 2
    },
    rarity = 2,
    cost = 7,
    config = {
        name = "Charred Roach",
        extras = {
        }
    },
    demicoloncompat = true,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["e_akyrs_burnt"]
        
    end,
    calculate = function (self, card, context)
        if context.akyrs_card_remove and context.card_getting_removed.config.center_key ~= "j_akyrs_charred_roach" and not (context.card_getting_removed.edition and context.card_getting_removed.edition.key == "e_akyrs_burnt")
        then
            return {
                func = function ()
                    local crm = context.card_getting_removed
                    if crm.ability.set == "Joker" and crm.config.center_key ~= "j_akyrs_ash_joker" then
                        local copy = copy_card(crm,nil,nil,nil, true)
                        copy:set_edition('e_akyrs_burnt')
                        copy.sell_cost = 0
                        G.jokers:emplace(copy)
                    end
                    if (crm.ability.set == "Enhanced" or crm.ability.set == "Default") and not (crm.config.center_key == "m_akyrs_ash_card") then
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local copy = copy_card(crm,nil,nil,G.playing_card, true)
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, copy)
                        copy:set_edition('e_akyrs_burnt')
                        if #G.hand.cards > 0 then
                            G.hand:emplace(copy)
                        else
                            G.deck:emplace(copy)
                        end
                        copy:add_to_deck()
                        copy.sell_cost = 0
                        copy:start_materialize(nil)
                        playing_card_joker_effects({copy})
                    end
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
            chips_gain = 15,
            echips = 2,
            odds = 4
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.echips,
                }
            }
        end
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extras.odds, 'akyrs_ash_joker_adequate')
        return {
            vars = {
                card.ability.extras.chips,
                n,
                d,
                card.ability.extras.chips_gain
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main or context.forcetrigger then
            return AKYRS.bal_val({
                chips = card.ability.extras.chips
            }, {
                echips = card.ability.extras.echips
            })
        end
        if context.end_of_round and context.cardarea == G.jokers then
            local odder = AKYRS.bal("absurd") or 
                SMODS.pseudorandom_probability(card,"akyrs_ash_joker_adequate", 1, card.ability.extras.odds)
            if odder then
                card.ability.akyrs_ash_disintegrate = odder
            else
                SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "chips", scalar_value = "chips_gain" })
            end
        end
    end,
    demicoloncompat = true,
}
-- chicken jockey
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true, },
    key = "chicken_jockey",
    pos = {
        x = 9, y = 2
    },
    rarity = 3,
    cost = 4,
    config = {
        name = "Chicken Jockey",
        extras = {
            xmult = 1,
            xmult_inc = 1,
            emult = 1,
            emult_inc = 1,
            decrease_popcorn = 9,
            popcorn_original_absurd = 5,
            decrease_popcorn_absurd = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = localize{key = "j_popcorn", vars = {20,4}}
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.emult_inc,
                    card.ability.extras.emult,
                    card.ability.extras.decrease_popcorn_absurd,
                    card.ability.extras.popcorn_original_absurd,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xmult_inc,
                card.ability.extras.xmult,
                card.ability.extras.decrease_popcorn,
            }
        }
    end,
    blueprint_compat = true,
	demicoloncompat = true,
    calculate = function (self, card, context)
        if AKYRS.bal("absurd") then
            if context.setting_blind then
                if AKYRS.has_room(G.jokers) then
                    SMODS.add_card{key = "j_popcorn"}
                end
            end
        else
            if context.buying_card and context.card.config.center.pools and context.card.config.center.pools["Food"] and not context.blueprint then
                --- @type Card
                local _c = context.card
                AKYRS.simple_event_add(function ()
                    _c:flip()
                    delay(1)
                    AKYRS.simple_event_add(function ()
                        unlock_achievement("ach_akyrs_average_daily_scrandle")
                        _c:set_ability(G.P_CENTERS.j_popcorn)
                        _c:flip()
                        return true
                    end,0)
                    return true
                end,0)
            end
        end
        if context.joker_main then
            return AKYRS.bal_val({
                xmult = card.ability.extras.xmult
            },{
                emult = card.ability.extras.emult
            })
        end

        if context.akyrs_card_remove  and not context.being_sold
        and (context.card_getting_removed.config and context.card_getting_removed.config.center_key and context.card_getting_removed.config.center_key == "j_popcorn") then
            if context.card_getting_removed.ability.mult - context.card_getting_removed.ability.extra <= 0 then
                return {
                    func = AKYRS.bal_val(function ()
                        SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult", scalar_value = "xmult_inc" })
                    end,
                    function ()
                        SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "emult", scalar_value = "emult_inc" })
                    end
                    )
                }
            end
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
SMODS.Joker {
    key = "tetoris",
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0, y = 3
    },
    rarity = 2,
    cost = 7,
    config = {
        name = "Tetoris",
        extras = {
            chips = 10,
            xchips = 2.1,
            immutable = {
                counter = 0
            }
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key.."_absurd",
                vars = {
                    card.ability.extras.immutable.counter,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.chips,
                card.ability.extras.xchips,
            }
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal("absurd") then
            
            if context.akyrs_pre_play then
                return {
                    func = function ()
                        card.ability.extras.immutable.counter = card.ability.extras.immutable.counter + #G.hand.highlighted
                    end
                }
            end
            if context.end_of_round and context.cardarea == G.jokers then
                card.ability.extras.immutable.counter = math.max(card.ability.extras.immutable.counter,0)
                SMODS.calculate_effect({func = function() 
                    if card.ability.extras.immutable.counter >= 160 then
                        SMODS.add_card{ key = "c_soul", set = "Spectral", edition = "e_negative"} 
                        card.ability.extras.immutable.counter = card.ability.extras.immutable.counter - 160
                    end
                end})
                SMODS.calculate_effect({func = function() 
                    if card.ability.extras.immutable.counter >= 4 then
                        SMODS.add_card{ set = "Spectral", edition = "e_negative", soulable = true} 
                        card.ability.extras.immutable.counter = card.ability.extras.immutable.counter - 4
                    end
                end})
            end
        else
            if context.joker_main then
                local c = AKYRS.get_letter_freq_from_cards(G.play.cards)
                local r = AKYRS.get_ranks_freq_from_cards(G.play.cards)
                local s = AKYRS.get_suit_freq_from_cards(G.play.cards)
                if (c["l"] or c["s"] or c["o"] or c["z"] or c["j"] or c["i"] or c["t"] or r[11] or r[10] or s["Spades"]) and G.GAME.akyrs_character_stickers_enabled then
                    return {
                        xchips = card.ability.extras.xchips,
                    }
                end
            end
        end
    end,
    hpot_unbreedable = true,
}

SMODS.Joker{
    pools = { ["Rhythm Games"] = true, ["Maimai"] = true, ["Music"] = true,  },
    key = "mukuroju_no_hakamori",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 3, y = 3
    },
    rarity = 3,
    cost = 7,
    config = {
        name = "躯樹の墓守",
        extras = {
            xmult = 1,
            xmult_absurd = 1,
            xmult_add = 0.5,
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            info_queue[#info_queue+1] = {key = 'dd_akyrs_mukuroju_en_absurd', vars = { card.ability.extras.xmult_absurd }, set = "DescriptionDummy"}
        else
            info_queue[#info_queue+1] = {key = 'dd_akyrs_mukuroju_en', vars = { card.ability.extras.xmult_add, card.ability.extras.xmult }, set = "DescriptionDummy"}
        end

        info_queue[#info_queue+1] = G.P_CENTERS['c_star']
        if MoreFluff then
            info_queue[#info_queue+1] = G.P_CENTERS['c_mf_rot_star']
        end
        return {
            key = self.key .. AKYRS.bal_val("","_absurd"),
            vars = AKYRS.bal_val({
                card.ability.extras.xmult_add,
                card.ability.extras.xmult
            },{
                card.ability.extras.xmult_absurd
            })
        }
    end,
    calculate = function (self, card, context)
        if context.using_consumeable and not context.blueprint and (
        AKYRS.is_star(context.consumeable.config.center_key)
        ) then

            return {
                func = function()
                    if AKYRS.bal("absurd") then
                        SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult_absurd", scalar_table = {["s"] = 8}, scalar_value = "s", operation = "X" })
                    else
                        SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult", scalar_value = "xmult_add" })
                    end
                end
            }
        end
        if context.joker_main then
            return {
                xmult = AKYRS.bal_val(card.ability.extras.xmult,card.ability.extras.xmult_absurd)
            }
        end
    end,
    blueprint_compat = true,
    perishable_compat = false,

}
SMODS.Joker{
    pools = { ["Minecraft"] = true },
    key = "emerald",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 4, y = 3
    },
    rarity = "akyrs_emerald",
    cost = 2,
    config = {
        name = "Emerald",
        extras = {
            xcost = 2,
            pluscost = 4,
            ecost = 2,
            amnt = 0,
        }
    },
    add_to_deck = function (self, card, from_debuff)
        G.GAME.akyrs_has_capability_to_trade = true
        AKYRS.simple_event_add(function ()
            local emerald_list = AKYRS.filter_table(G.jokers.cards, function (cd, ind)
                return cd.config.center.key == self.key
            end, true, true)
            --print(#emerald_list, G.jokers.config.card_limit, #emerald_list == G.jokers.config.card_limit)
            if #emerald_list == G.jokers.config.card_limit then
                check_for_unlock({ type = "full_emerald_in_slot" })
            end
            return true
        end, 0, "akyrs_desc")
    end,
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.pluscost,
                    card.ability.extras.ecost,
                    card.cost,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xcost,
                card.cost,
                card.ability.extras.amnt,
            }
        }
    end,
    in_pool = function (self, args)
        return true, {
            allow_duplicates = next(SMODS.find_card("j_akyrs_emerald"))
        }       
    end
}
SMODS.Joker{
    pools = { ["Terraria"] = true, },
    key = "shimmer_bucket",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 5, y = 3
    },
    rarity = 3,
    cost = 15,
    config = {
        name = "Shimmer Bucket",
        extras = {
            create_factor = 2,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.create_factor,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.ending_shop and not context.blueprint then
            local index = AKYRS.find_index(G.jokers.cards,card)
            if index and #G.jokers.cards > 1 and G.jokers.cards[index-1] and index > 1 then
                local othercard = G.jokers.cards[index-1]
                if not SMODS.is_eternal(othercard,card) then
                    local rarity = othercard.config.center.rarity
                    othercard:start_dissolve({G.C.AKYRS_PLAYABLE},1.1)
                    othercard:remove_from_deck()
                    for i=1, card.ability.extras.create_factor do
                        SMODS.calculate_effect({
                            func = function ()
                                SMODS.add_card{rarity = rarity, set = "Joker", legendary = (rarity == 4)}
                            end
                        }, card)
                    end
                    AKYRS.simple_event_add(function ()
                        card:start_dissolve({G.C.AKYRS_PLAYABLE},1.1)
                        return true
                    end)
                end
            end
        end
    end,
    eternal_compat = false
}

SMODS.Joker{
    key = "space_elevator",
    pools = { ["Satisfactory"] = true, },
    atlas = 'AikoyoriJokers',
    pos = {
        x = 6, y = 3
    },
    rarity = 2,
    cost = 7,
    config = {
        name = "Space Elevator",
        extras = {
            phase = 1,
            target_play = 10,
            played = 0,
            target_rank = nil,
            ranks_chosen = {}
        }
    },
    loc_vars = function (self, info_queue, card)
        card.ability.extras.phase = math.floor(card.ability.extras.phase)
        card.ability.extras.target_play = math.floor(card.ability.extras.target_play)
        
        if card.ability.extras.phase > 5 or card.ability.extras.phase < 1 then 
            card.ability.extras.phase = 1
        end
        return {
            vars = {
                card.ability.extras.target_play,
                card.ability.extras.target_rank and localize(card.ability.extras.target_rank,"ranks") or "<"..localize("k_rank")..">",
                card.ability.extras.phase,
                card.ability.extras.played,
            }
        }
    end,
    set_ability = function (self, card, initial, delay_sprites)
        if initial then

        end
    end,
    add_to_deck = function (self, card, from_debuff)
        local r = pseudorandom_element(AKYRS.get_p_card_ranks(card.ability.extras.ranks_chosen),pseudoseed("akyrs_space_elevator")) 
            or pseudorandom_element(SMODS.Ranks,pseudoseed("akyrs_space_elevator")) 
        if r then
            card.ability.extras.target_rank = r.key
            card.ability.extras.ranks_chosen[r.key] = true
        end
        card.ability.extras.played = 0
    end,
    calculate = function (self, card, context)
        if context.individual and not context.forcetrigger and not context.repetition and not context.repetition_only and not context.blueprint and not context.retrigger_joker and context.cardarea == G.play then
            if not SMODS.has_no_rank(context.other_card) and context.other_card.base.value then
                if context.other_card.base.value == card.ability.extras.target_rank then
                    card.ability.extras.played = card.ability.extras.played + 1
                    --print(card.ability.extras.played)
                    if card.ability.extras.played >= card.ability.extras.target_play then
                        card.ability.extras.phase = card.ability.extras.phase + 1
                        local r = pseudorandom_element(AKYRS.get_p_card_ranks(card.ability.extras.ranks_chosen),pseudoseed("akyrs_space_elevator"))
                        if not r then
                            EMPTY(card.ability.extras.ranks_chosen)
                            r = pseudorandom_element(AKYRS.get_p_card_ranks(card.ability.extras.ranks_chosen),pseudoseed("akyrs_space_elevator"))
                        end
                        if r then
                            card.ability.extras.target_rank = r.key
                            card.ability.extras.ranks_chosen[r.key] = true
                        end
                        if card.ability.extras.phase > 5 then
                            SMODS.add_card{ key = "c_soul", set = "Spectral", edition = "e_negative"}
                            card.ability.extras.phase = 1
                        else
                            SMODS.add_card{ set = "Spectral", edition = "e_negative" }
                        end
                        card.ability.extras.target_play = pseudorandom(pseudoseed("akyrs_space_elevator_num"),5*card.ability.extras.phase+7,7*card.ability.extras.phase)
                        card.ability.extras.played = 0
                        return {
                            message = localize("k_akyrs_sendoff")
                        }
                    else
                        return {
                            message = localize("k_akyrs_received")
                        }
                    end
                end
            end
        end
    end,
    perishable_compat = false
}


SMODS.Joker{
    key = "turret",
    atlas = 'AikoyoriJokers',
    pools = { ["Portal"] = true, },
    pos = {
        x = 7, y = 3
    },
    rarity = 2,
    cost = 4, 
    config = {
        extras = {
            mulx = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        if G.jokers then
            local index = AKYRS.find_index(G.jokers.cards,card)
            if index and #G.jokers.cards > 1 and G.jokers.cards[index+1] and index < #G.jokers.cards then
                local othercard = G.jokers.cards[index+1]
                return {
                    vars = 
                    {
                        math.max(othercard.sell_cost * card.ability.extras.mulx,0),
                        card.ability.extras.mulx
                    }
                }
            end
        end
        return {
            vars = {
                "??",
                card.ability.extras.mulx
            }
        }
    end,
    calculate = function (self, card, context)
        if context.selling_card and context.card == card and not context.blueprint then
            
            local index = AKYRS.find_index(G.jokers.cards,card)
            if index and #G.jokers.cards > 1 and G.jokers.cards[index+1] and index < #G.jokers.cards then
                local othercard = G.jokers.cards[index+1]
                return {
                    func = function ()
                        othercard:start_dissolve({G.C.RED},1.6)
                    end,
                    dollars = math.max(othercard.sell_cost * card.ability.extras.mulx,0)
                }
            end
        end
    end,
    eternal_compat = false,
}
SMODS.Joker{
    key = "aether_portal",
    atlas = 'AikoyoriJokers',
    pools = { ["Minecraft"] = true, },
    pos = {
        x = 8, y = 3
    },
    rarity = 2,
    cost = 7, 
    config = {
        extras = {
            odds = 4
        }
    },
    loc_vars = function (self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, 1, card.ability.extras.odds,"akyrs_aether_chance")
        return {
            vars = {
                n,
                d
            }
        }
    end,
    calculate = function (self, card, context)
        if context.setting_blind and not context.blueprint then
            
            local index = AKYRS.find_index(G.jokers.cards,card)
            if index and #G.jokers.cards > 1 and G.jokers.cards[index-1] and index > 1 then
                local other = G.jokers.cards[index-1]
                local filtered_pool = AKYRS.filter_table(G.P_CENTER_POOLS.Edition,function (c,i,a)
                    return c.weight > 0 and c:in_pool({source = "akyrs_aether_portal"})
                end,false,true)
                local edition = pseudorandom_element(filtered_pool, "akyrs_aether_portal_pick")
                if edition then
                    other:set_edition(edition.key)
                end
                if SMODS.pseudorandom_probability(card,"akyrs_aether_portal",1,card.ability.extras.odds) then
                    card:start_dissolve({G.C.BLUE},1.6)
                end
            end
        end
    end
}

SMODS.Joker{
    key = "corkscrew",
    atlas = 'AikoyoriJokers',
    pools = { ["Hamsterball"] = true, },
    pos = {
        x = 9, y = 3
    },
    rarity = 1,
    cost = 3,
    config = {
        extras = { xmult = 2, emult = 1, immutable = {index = 1} }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            local current = nil
            if card.area then
                current = AKYRS.find_index(card.area.cards,card)
                card.ability.extras.emult = AKYRS.pos_to_val(card.ability.extras.immutable.index,#card.area.cards)
            end
            return {
                key = self.key .. "_absurd",
                vars = {
                    (G.GAME and current) and card.ability.extras.emult or localize("ph_akyrs_unknown")
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    add_to_deck = function (self, card, from_debuff)
        if card.area and card.area.cards then
            local current = AKYRS.find_index(card.area.cards,card)
            card.ability.extras.immutable.index = current
            card.ability.extras.emult = AKYRS.pos_to_val(card.ability.extras.immutable.index,#card.area.cards)
        end
    end,
    calculate = function (self, card, context)
        if context.before then
            if card.area and card.area.cards then
                return {
                    func = function ()
                        local where = pseudorandom("akyrs_corkscrew_move_target",1,#card.area.cards)
                        local current = AKYRS.find_index(card.area.cards,card)
                        card.area.cards[where],card.area.cards[current or 1] = card.area.cards[current],card.area.cards[where]
                        card.ability.extras.immutable.index = current
                        card.area:align_cards()
                        card.ability.extras.emult = AKYRS.pos_to_val(card.ability.extras.immutable.index,#card.area.cards)
                    end
                }
            end
        end
        if context.joker_main then
            if AKYRS.bal("adequate") then
                return {
                    xmult = card.ability.extras.xmult
                }
            else
                return {
                    emult = card.ability.extras.emult
                }
            end

        end
    end,
    blueprint_compat = true
}
SMODS.Joker{
    key = "goodbye_sengen",
    atlas = 'AikoyoriJokers',
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
    pos = {
        x = 0, y = 4
    },
    rarity = 2,
    cost = 7,
    config = {
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["c_justice"]
        return {
            key = self.key..AKYRS.bal_val("","_absurd")
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal("absurd") then
            if context.using_consumeable and context.consumeable.config.center_key == "c_justice" then
                return {
                    func = function ()
                        SMODS.smart_level_up_hand(nil,"High Card",nil,G.GAME.hands["High Card"].level)
                    end
                }
            end
        else
            if context.destroy_card and not context.blueprint then
                if context.destroy_card == context.full_hand[1] and #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                    if AKYRS.has_room(G.consumeables) then
                        return {
                            func = function()
                                AKYRS.simple_event_add(
                                    function ()
                                        SMODS.add_card{ key = "c_justice", set = "Tarot" } 
                                        return true
                                    end, 0
                                )
                            end,
                            message = localize('k_plus_tarot'),
                            colour = G.C.PURPLE,
                            remove = true
                        }
                    end
                    return {
                        remove = true
                    }
                end
            end
        end

    end
}

SMODS.Joker{
    key = "liar_dancer",
    atlas = 'AikoyoriJokers',
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
    pos = {
        x = 1, y = 4
    },
    rarity = 3,
    cost = 7,
    config = {
        extras = {
            level_down = 1,
            level_up_mult = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key..AKYRS.bal_val("","_absurd"),
            vars = {
                card.ability.extras.level_down,
                card.ability.extras.level_down * card.ability.extras.level_up_mult
            }
        }
    end,
    calculate = function (self, card, context)
        
        if AKYRS.bal("absurd") then
            if context.before and not context.blueprint then
                return {
                    func = function()
                        local h = {}
                        for mei, _ in pairs(G.GAME.hands) do
                            if not next(context.poker_hands[mei]) then
                                h[mei] = true
                            end
                        end
                        AKYRS.blk_lvl_up(h)
                    end
                }
            end
        else
            if context.before and not context.blueprint then
                local cx = false
                if Talisman then
                    cx = G.GAME.hands[context.scoring_name].level:gt(to_big(1))
                else
                    cx = G.GAME.hands[context.scoring_name].level > 1
                end
                if not context.poker_hands["Straight"] or (context.poker_hands["Straight"] and not next(context.poker_hands["Straight"])) and cx then
                    SMODS.smart_level_up_hand(card,context.scoring_name,nil,-card.ability.extras.level_down)
                    SMODS.smart_level_up_hand(card,"Straight",nil,card.ability.extras.level_down * card.ability.extras.level_up_mult)
                    SMODS.smart_level_up_hand(card,"Straight Flush",nil,card.ability.extras.level_down * card.ability.extras.level_up_mult)
                end
            end
        end
    end
}
SMODS.Joker{
    key = "pissandshittium",
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true },
    pos = {
        x = 4, y = 4
    },
    rarity = 1,
    cost = 2,
    config = {
        extras = {
            mult = 6.000,
            eeemult = 0.1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. AKYRS.bal_val("","_absurd"),
            vars = {
                AKYRS.bal_val(card.ability.extras.mult,1 + card.ability.extras.eeemult)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                message = localize("k_akyrs_pissandshittium"),
                colour = AKYRS.C.PISSANDSHITTIUM,
                remove_default_message = true,
                mult = AKYRS.bal_val(card.ability.extras.mult,nil),
                emult = AKYRS.bal_val(nil,1 + card.ability.extras.eeemult),
            }
        end
    end,
    blueprint_compat = true
}
SMODS.Joker{
    key = "pandora_paradoxxx",
    atlas = 'AikoyoriJokers',
    pools = { ["Rhythm Games"] = true, ["Maimai"] = true, ["Music"] = true, },
    pos = {
        x = 5, y = 4
    },
    rarity = 3,
    cost = 9,
    config = {
        extras = {
            count = 15,
            current = 0,
            odds_absurd = 3
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_standard"}
        -- numerator & denominator :3
        if AKYRS.bal("absurd") then
            local n, d = SMODS.get_probability_vars(card,1,card.ability.extras.odds_absurd,"akyrs_pandora_paradoxx")
            return {
                key = self.key.."_absurd",
                vars = {
                    n,d
                }
            } 
        end
        return {
            vars = {
                card.ability.extras.count,
                card.ability.extras.current
            }
        }

    end,
    calculate = function (self, card, context)
        if context.playing_card_added and AKYRS.bal("absurd") then
            return {
                func = function ()
                    for i = 1, #context.cards do
                        if SMODS.pseudorandom_probability(card,"akyrs_pandora_paradoxxx",1,card.ability.extras.odds_absurd) then
                            local tag = Tag("tag_standard")
                            add_tag(tag)
                            SMODS.calculate_effect({
                                message = localize("k_akyrs_pandora_give_tag"),
                            }, card)
                        end
                    end
                end
            }
        end
        if context.before and AKYRS.bal("adequate") then
            return {
                func = function ()
                    for _,_c in ipairs(context.scoring_hand) do
                        card.ability.extras.current = card.ability.extras.current + 1
                        SMODS.calculate_effect({
                            juice_card = _c,
                            message = card.ability.extras.current
                        }, card)
                        if card.ability.extras.current >= card.ability.extras.count then 
                            SMODS.calculate_effect({
                                message = localize("k_akyrs_pandora_give_tag"),
                                func = function()
                                local tag = Tag("tag_standard")
                                add_tag(tag)
                                    card.ability.extras.current = 0
                                end
                            }, card)
                        end
                    end
                end
            }
        end
    end,
    blueprint_compat = true
}
SMODS.Joker{
    key = "story_of_undertale",
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true,  ["Undertale"] = true, },
    pos = {
        x = 6, y = 4
    },
    rarity = 2,
    cost = 6,
    config = {
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['j_mr_bones']
    end,
    calculate = function (self, card, context)
        if context.blind_defeated then
            SMODS.calculate_effect({
                card = card,
                message = localize("k_akyrs_woah_undertale"),
            })
            return {
                message = localize("k_akyrs_story_of_undertale"),
                func = function ()
                    local destructable_jokers = {}
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] ~= card 
                        and not SMODS.is_eternal(G.jokers.cards[i]) 
                        and not G.jokers.cards[i].getting_sliced 
                        and G.jokers.cards[i].config.center_key ~= "j_mr_bones" 
                        then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
                    end
                    local joker_to_destroy = destructable_jokers[#destructable_jokers]
    
                    if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then 
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            (context.blueprint_card or card):juice_up(0.8, 0.8)
                            
                            SMODS.add_card{ key = "j_mr_bones", set = "Joker", edition = "e_negative"}
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                        return true end }))
                    end
                end
            }
        end
    end,
    blueprint_compat = false
}
SMODS.Joker{
    key = "no_hints_here",
    atlas = 'AikoyoriJokers',
    pools = { ["Rhythm Games"] = true, ["ADOFAI"] = true, ["Music"] = true,  },
    pos = {
        x = 7, y = 4
    },
    rarity = 2,
    cost = 6,
    config = {
        extras = {
            xmult = 3,
            emult = 2.5
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.emult,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xmult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            if AKYRS.bal("absurd") then
                return {
                    emult = card.ability.extras.emult
                }
            else
                return {
                    xmult = card.ability.extras.xmult
                }
            end
        end
    end,
    blueprint_compat = true
}
SMODS.Joker{
    key = "brushing_clothes_pattern",
    enhancement_gate = "m_wild",
    atlas = 'AikoyoriJokers',
    pools = { ["Rhythm Games"] = true, ["Chunithm"] = true },
    pos = {
        x = 8, y = 4
    },
    rarity = 2,
    cost = 6,
    config = {
        extras = {
            xchips = 2,
            xchips_absurd = 1,
            xchips_gain_absurd = 2,
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                card.ability.extras.xchips_gain_absurd,
                card.ability.extras.xchips_absurd,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xchips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and next(context.poker_hands["Flush"]) and not context.blueprint then
            if context.other_card.ability.name == "Wild Card" then
                return {
                    message_card = card,
                    func = function ()
                        if AKYRS.bal("absurd") then
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xchips", scalar_value = "xchips_gain"})
                        end
                    end
                }
            end
        end
        if AKYRS.bal("adequate") and context.press_play then
            local cardsers = G.hand.highlighted
            local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(cardsers)
            if next(poker_hands["Flush"]) then
                return {
                    func = function()
                        local filtered = AKYRS.filter_table(cardsers, function (cr)
                            return cr.config and cr.config.center_key == "m_wild"
                        end, true, true)
                        AKYRS.do_things_to_card(filtered, function (card, index)
                            SMODS.modify_rank(card, 1)
                        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true, dont_unhighlight = true})
                    end
                }
            end
        end
        if context.joker_main then
            return {
                xchips = AKYRS.bal_val(nil,card.ability.extras.xchips)
            }
        end
    end,
    blueprint_compat = true
}

SMODS.Joker{
    key = "you_tried",
    atlas = 'AikoyoriJokers',
    pools = { ["Meme"] = true, },
    pos = {
        x = 9, y = 4
    },
    rarity = 3,
    cost = 12,
    config = {
        extras = {
            ante_set = 3,
            money_set = 4,
            lives_mp = 1,
            lives_mp_set = 4,
            lives_mp_set_money = 31,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. AKYRS.bal_val("","_absurd") .. AKYRS.mp_check("","_mp"),
            vars = {
                AKYRS.mp_check(card.ability.extras.ante_set, AKYRS.bal_val(card.ability.extras.lives_mp,card.ability.extras.lives_mp_set)),
                AKYRS.mp_check(card.ability.extras.money_set,card.ability.extras.lives_mp_set_money),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.final_scoring_step and AKYRS.is_mp() then
            card.ability.extras.last_life = MP.GAME.lives
            card.ability.extras.unset = true
        end
        if context.end_of_round and context.game_over and not context.blueprint and not AKYRS.is_mp() then
            card:start_dissolve({G.C.YELLOW},1.6)
            return {
                saved = localize("k_akyrs_you_tried"),
                func = function ()
                    if AKYRS.bal("adequate") and not AKYRS.is_mp() then
                        for i,k in ipairs(G.jokers.cards) do
                            if not SMODS.is_eternal(k) then
                                k:start_dissolve({G.C.YELLOW},1.6)
                            end
                        end
                    end
                    local old_ante = G.GAME.round_resets.ante
                    if AKYRS.bal("adequate") then
                        ease_ante((-math.floor(G.GAME.round_resets.ante/2)))
                    else
                        ease_ante(-G.GAME.round_resets.ante + card.ability.extras.ante_set)
                    end
                end
            }
        end
    end,
}

SMODS.Joker{
    key = "don_chan",
    atlas = 'AikoyoriJokers',
    pools = { ["Rhythm Games"] = true, ["Taiko no Tatsujin"] = true, },
    pos = {
        x = 0, y = 5
    },
    rarity = 1,
    cost = 5,
    config = {
        extras = {
            percent = .1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. AKYRS.bal_val("","_absurd"),
            vars = {
                card.ability.extras.percent * 100,
            }
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal_val(context.joker_main,context.individual and context.cardarea == G.play) or context.forcetrigger then
            return {
                mult = hand_chips * card.ability.extras.percent,
                func = function ()
                    AKYRS.simple_event_add(function ()
                        play_sound('akyrs_don',percent or 1, 0.6)
                        return true
                    end)
                end,
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}
SMODS.Joker{
    key = "katsu_chan",
    atlas = 'AikoyoriJokers',
    pools = { ["Rhythm Games"] = true, ["Taiko no Tatsujin"] = true, },
    pos = {
        x = 1, y = 5
    },
    rarity = 1,
    cost = 5,
    config = {
        extras = {
            percent = .1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. AKYRS.bal_val("","_absurd"),
            vars = {
                card.ability.extras.percent * 100,
            }
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal_val(context.joker_main,context.individual and context.cardarea == G.play) or context.forcetrigger then
            return {
                chips = mult * card.ability.extras.percent,
                func = function ()
                    AKYRS.simple_event_add(function ()
                        play_sound('akyrs_katsu',percent or 1, 0.6)
                        return true
                    end)
                end,
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}



SMODS.Joker{
    key = "lagtrain",
    atlas = 'AikoyoriJokers',
    pools = { ["Vocaloid"] = true, ["J-POP"] = true },
    pos = {
        x = 2, y = 5
    },
    rarity = 2,
    cost = 8,
    config = {
        extras = {
            chips = 0,
            xchips = 1,
            chips_g = 12,
            xchips_g = 0.1,
        }
    },
    loc_vars = function (self, info_queue, card)
        local _,_2,c = love.window.getMode()
        local x = math.max(c.refreshrate - love.timer.getFPS( ),0) 
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.xchips_g * 240 / c.refreshrate,
                    c.refreshrate,
                    card.ability.extras.xchips,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.chips_g,
                card.ability.extras.chips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before and context.poker_hands["Straight"] and next(context.poker_hands["Straight"]) or context.forcetrigger then
            return {
                func = function ()
                    local _,_2,c = love.window.getMode()
                    local x = math.max((c.refreshrate or 0) - love.timer.getFPS( ),0)
                    SMODS.calculate_effect({
                        message = love.timer.getFPS( )..localize("k_akyrs_fps"),
                        message_card = card,
                    }, card)
                    if AKYRS.bal("absurd") then
                        SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xchips", scalar_value = "xchips_g",
                            operation = function (rt,rv,int,sc)
                                rt[rv] = int + sc * x * 240 / c.refreshrate
                            end
                        })
                    end


                end
            }
        end
        if AKYRS.bal("adequate") then
            if context.individual and context.cardarea == "unscored" then
                SMODS.scale_card(context.other_card, { ref_table = context.other_card.ability, ref_value = "perma_bonus", scalar_table = card.ability.extras,scalar_value = "chips_g", })
            end
        end
        if context.joker_main or context.forcetrigger then
            if AKYRS.bal("absurd") then
                return {
                    xchips = card.ability.extras.xchips
                }
            end
            return {
                chips = card.ability.extras.chips
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}


SMODS.Joker{
    key = "bocchi",
    atlas = 'AikoyoriJokers',
    pools = { ["Anime"] = true, ["Bocchi the Rock"] = true, ["Kessoku Band"] = true, },
    pos = {
        x = 3, y = 5
    },
    rarity = 3,
    cost = 9,
    config = {
        extras = {
            xmult = 1,
            xmult_absurd = 1.1,
            xmult_g = 0.25,
            xmult_g_absurd = 1.3,
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.xmult_g_absurd,
                    card.ability.extras.xmult_absurd,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.xmult_g,
                card.ability.extras.xmult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before or context.forcetrigger then
            return {
                func = function ()
                    local x = AKYRS.filter_table(G.jokers.cards,function(t) return AKYRS.is_in_pool(t,"Kessoku Band") end, true, true)
                    local sts, stschk = AKYRS.get_suits(G.play.cards)
                    if (AKYRS.bal_val((#G.play.cards) == 1 and G.play.cards[1]:is_suit("Spades"),stschk["Spades"])) or context.forcetrigger then
                        if AKYRS.bal("absurd") then
                            SMODS.scale_card(card, { ref_table = card.ability.extras, ref_value = "xmult_absurd", scalar_value = "xmult_g_absurd",
                                operation = function (rt,rv,int,sc)
                                    if Talisman then
                                        rt[rv] = to_big(int):pow(sc * #x)
                                    end
                                end
                            })
                        else
                            SMODS.scale_card(card, {ref_table = card.ability.extras, ref_value = "xmult", scalar_value = "xmult_g", operation = function (rt,rv,int,sc)
                                    rt[rv] = int + sc * #x
                                end})
                        end
                    end
                end
            }
        end
        if context.joker_main or context.forcetrigger then
            if AKYRS.bal("absurd") then
                return {
                    xmult = card.ability.extras.xmult_absurd
                }
            end
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}

SMODS.Joker{
    key = "kita",
    atlas = 'AikoyoriJokers',
    pools = { ["Anime"] = true, ["Bocchi the Rock"] = true, ["Kessoku Band"] = true, },
    pos = {
        x = 4, y = 5
    },
    rarity = 2,
    cost = 6,
    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Tarot", key = "c_lovers", vars = {1, localize("k_akyrs_wild_card")}}
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
            }
        end
        return {
        }
    end,
    calculate = function (self, card, context)
        if (context.before or context.forcetrigger) and AKYRS.bal("adequate") then
            return {
                message = localize("k_akyrs_kitan"),
                colour = G.C.RED,
                func = function ()
                    local sts, stschk = AKYRS.get_suits(G.play.cards)
                    if (next(context.poker_hands["Flush"]) and stschk["Hearts"]) or context.forcetrigger then
                        if AKYRS.has_room(G.consumeables) then
                            SMODS.add_card({key = "c_lovers", set = "Tarot"})
                        end
                    end
                end
            }
        end
        if (context.individual and context.cardarea == G.play or context.forcetrigger) and AKYRS.bal("absurd") then
            return {
                message = localize("k_akyrs_kitan"),
                colour = G.C.RED,
                func = function ()
                    if context.other_card:is_suit("Hearts") then
                        SMODS.add_card({key = "c_lovers", set = "Tarot", edition = "e_negative"})
                    end
                end
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
    hpot_unbreedable = true,
}

SMODS.Joker{
    key = "ryou",
    atlas = 'AikoyoriJokers',
    pools = { ["Anime"] = true, ["Bocchi the Rock"] = true, ["Kessoku Band"] = true, },
    pos = {
        x = 5, y = 5
    },
    rarity = 1,
    cost = 2,
    config = {
        extras = {
            debt = 12,
            add_debt = 3,
            debt_absurd = 6,
            factor_debt_absurd = 2,
        }
    },
    add_to_deck = function (self, card, from_debuff)
        card.ability.extras.obtain_bal = AKYRS.bal_val()
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - AKYRS.bal_val_overridable(card.ability.extras.debt,card.ability.extras.debt_absurd,card.ability.extras.obtain_bal)
    end,
    remove_from_deck =function (self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + AKYRS.bal_val_overridable(card.ability.extras.debt,card.ability.extras.debt_absurd,card.ability.extras.obtain_bal)
    end,
    loc_vars = function (self, info_queue, card)
        if (card.ability.extras.obtain_bal or AKYRS.bal()) == "absurd" then
            return {
                key = self.key .. "_absurd",
                vars = {
                    card.ability.extras.debt_absurd,
                    card.ability.extras.factor_debt_absurd,
                }
            }
        end
        return {
            vars = {
                card.ability.extras.debt,
                card.ability.extras.add_debt,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before and context.poker_hands and #context.poker_hands["Pair"] > 0 then
            return {
                message = localize("k_akyrs_ryo_borrowed_money"),
                func = function ()
                    local pairs_of_clubs = 0
                    for _,e_pair in ipairs(context.poker_hands["Pair"]) do
                        local is_pair_of_clubs = true
                        for _,e_card in ipairs(e_pair) do
                            if not e_card:is_suit("Clubs") then
                                is_pair_of_clubs = false
                            end
                        end
                        if is_pair_of_clubs then
                            pairs_of_clubs = pairs_of_clubs + 1
                        end
                        
                    end
                    
                    if AKYRS.bal_overridable("absurd",card.ability.extras.obtain_bal) then
                        if pairs_of_clubs > 0 then
                            local old_bkrpt_at = card.ability.extras.debt_absurd -- 6,12,24
                            -- new debt should be 12,24,48, etc.
                            -- was told to leave this here
                            -- https://www.reddit.com/r/mildlyinfuriating/comments/zrct25/the_last_time_i_buy_kfc_almost_13_for_this/
                            SMODS.scale_card(card, {ref_table = card.ability.extras, ref_value = "debt_absurd", scalar_table = {["a"] = pairs_of_clubs * card.ability.extras.factor_debt_absurd }, scalar_value = "a", operation = "X" })
                            -- the difference should also account for when, for some reason, the joker value changes like Cryptid's misprintize function
                            -- all those numbers should be positive so i just absurd - old bkrpt ig
                            G.GAME.bankrupt_at = G.GAME.bankrupt_at - (card.ability.extras.debt_absurd - old_bkrpt_at)
                        end
                    else
                        if pairs_of_clubs > 0 then
                            SMODS.scale_card(card, {ref_table = card.ability.extras, ref_value = "debt", scalar_value = "add_debt"})
                            G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extras.add_debt
                        end
                    end
                end
            }
        end
    end,
	demicoloncompat = true,
    hpot_unbreedable = true,
}


SMODS.Joker{
    key = "nijika",
    atlas = 'AikoyoriJokers',
    pools = { ["Anime"] = true, ["Bocchi the Rock"] = true, ["Kessoku Band"] = true, },
    pos = {
        x = 6, y = 5
    },
    rarity = 2,
    cost = 8,
    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        if AKYRS.bal("absurd") then
            return {
                key = self.key .. "_absurd",
            }
        end
        return {
        }
    end,
    calculate = function (self, card, context)
        if AKYRS.bal("absurd") then
            if context.individual and context.cardarea == G.play and context.other_card and context.other_card:is_suit("Diamonds") and next(context.poker_hands.Straight) then
                return {
                    message = localize("k_akyrs_nijika_planet"),
                    func = function ()
                        local pl = AKYRS.get_most_played()
                        SMODS.add_card({soulable = true, key = pl, edition = "e_negative"})
                    end
                }
            end
        else
            if context.joker_main and next(context.poker_hands.Straight) then
                local diac = 0
                for _,cr in ipairs(G.play.cards) do
                    if cr:is_suit("Diamonds") then
                        diac = diac + 1
                    end
                end
                if diac >= 1 then
                    return {
                        message = localize("k_akyrs_nijika_planet"),
                        func = function ()
                            local pl = AKYRS.get_most_played()
                            SMODS.add_card({key = pl, edition = "e_negative"})
                        end
                    }
                end
            end
        end
    end,
	demicoloncompat = true,
    hpot_unbreedable = true,
}

SMODS.Joker {
    
    key = "blue_portal",
    atlas = 'AikoyoriJokers',
    pools = { ["Portal"] = true, ["Video Games"] = true, },
    pos = {
        x = 2, y = 4
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_orange_portal"]
        return {
            vars = {card.ability.extras.xc},
            main_end = {
                { n = G.UIT.R, config = { padding = 0.1, colour = G.C.ORANGE, r = 0.1}, nodes = {
                    {
                        n = G.UIT.T, config = {scale = 0.3, text = card.ability.extras.link}
                    }
                }}
            }
        }
    end,
    set_ability = function (self, card, initial, delay_sprites)
        card.ability.extras.link = AKYRS.random_string(10)
    end,
    add_to_deck = function (self, card, from_debuff)
        AKYRS.simple_event_add(
            function()
                local c1 = SMODS.add_card({ key = "j_akyrs_orange_portal"})
                c1.ability.extras.link = card.ability.extras.link
                return true
            end
        )
    end,
    remove_from_deck = function (self, card, from_debuff)
        local s = SMODS.find_card("j_akyrs_orange_portal")
        for _,_c in ipairs(s) do
            if _c.ability.extras.link == card.ability.extras.link then
                _c:start_dissolve({G.C.ORANGE})
            end
        end
    end,
    
    rarity = 3,
    cost = 9,
    config = {
        extras = {
            link = "?????",
            xc = 2.5
        }
    },
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.extras.xc
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}

SMODS.Joker {
    
    key = "orange_portal",
    atlas = 'AikoyoriJokers',
    pools = { ["Portal"] = true, ["Video Games"] = true, },
    pos = {
        x = 3, y = 4
    },
    in_pool = function (self, args)
        return false
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extras.xm },
            main_end = {
                { n = G.UIT.R, config = { padding = 0.1, colour = G.C.BLUE, r = 0.1}, nodes = {
                    {
                        n = G.UIT.T, config = {scale = 0.3, text = card.ability.extras.link}
                    }
                }}
            }
        }
    end,
    remove_from_deck = function (self, card, from_debuff)
        local s = SMODS.find_card("j_akyrs_blue_portal")
        for _,_c in ipairs(s) do
            if _c.ability.extras.link == card.ability.extras.link then
                _c:start_dissolve({G.C.ORANGE})
            end
        end
    end,
    rarity = "akyrs_unique",
    cost = 9,
    config = {
        extras = {
            link = "?????",
            xm = 2.5,
        }
    },
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extras.xm
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
}


SMODS.Joker {
    
    key = "koshitan",
    atlas = 'AikoyoriJokers',
    pools = { ["Shikanokonokonokokoshitantan"] = true, ["Anime"] = true,},
    pos = {
        x = 7, y = 5
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extras.taketh, card.ability.extras.addth },
        }
    end,
    rarity = 2,
    cost = 5,
    config = {
        extras = {
            taketh = 1,
            addth = 5
        }
    },
    calculate = function (self, card, context)
        if context.setting_blind then
            return {
                dollars = -card.ability.extras.taketh,
                message = localize("k_akyrs_value_up"),
                func = function ()
                    AKYRS.simple_event_add(
                        function ()
                            card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extras.addth
                            card:set_cost()
                            return true
                        end
                    )
                end
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
    hpot_unbreedable = true,
}


SMODS.Joker {
    
    key = "nokotan",
    atlas = 'AikoyoriJokers',
    pools = { ["Shikanokonokonokokoshitantan"] = true, ["Anime"] = true,},
    pos = {
        x = 8, y = 5
    },
    loc_vars = function (self, info_queue, card)
        local value = 0
            if card.area and card.area.cards then
            local location = AKYRS.find_index(card.area.cards, card)
            --- @type Card
            local left_card = card.area.cards[location-1]
            --- @type Card
            local right_card = card.area.cards[location+1]
            if left_card then value = value + left_card.sell_cost end
            if right_card then value = value + right_card.sell_cost end
        end
        return {
            vars = { card.ability.extras.scaleth, value * card.ability.extras.scaleth },
        }
    end,
    rarity = 2,
    cost = 6,
    config = {
        extras = {
            scaleth = 2,
        }
    },
    calculate = function (self, card, context)
        if context.joker_main and card.area and card.area.cards then
            local location = AKYRS.find_index(card.area.cards, card)
            --- @type Card
            local left_card = card.area.cards[location-1]
            --- @type Card
            local right_card = card.area.cards[location+1]
            local value = 0
            if left_card then value = value + left_card.sell_cost end
            if right_card then value = value + right_card.sell_cost end
            return {
                mult = card.ability.extras.scaleth * value
            }
        end
    end,
    blueprint_compat = true,
	demicoloncompat = true,
    hpot_unbreedable = true,
}


SMODS.Joker {
    
    key = "koshian",
    atlas = 'AikoyoriJokers',
    pools = { ["Shikanokonokonokokoshitantan"] = true, ["Anime"] = true,},
    pos = {
        x = 9, y = 5
    },
    loc_vars = function (self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 2, 2, "koshian_calc")
        card.sell_cost = n + d
        return {
            vars = { n, d },
        }
    end,
    rarity = 1,
    cost = 3,
    config = {
        
    },
    add_to_deck = function (self, card, dt)
        local n, d = SMODS.get_probability_vars(card, 2, 2, "koshian_calc")
        card.sell_cost = n + d
    end,
    
    calculate = function (self, card, context)
        
    end,
    hpot_unbreedable = true,
}



SMODS.Joker {
    
    key = "bashame",
    enhancement_gate = "m_akyrs_canopy_card",
    atlas = 'AikoyoriJokers',
    pools = { ["Shikanokonokonokokoshitantan"] = true, ["Anime"] = true,},
    pos = {
        x = 0, y = 6
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_canopy_card"]
        return {
            vars = { card.ability.extra },
        }
    end,
    rarity = 2,
    cost = 5,
    config = {
        extra = 1
    },
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if SMODS.get_enhancements(context.other_card)["m_akyrs_canopy_card"] then
                return {
                    message = localize("k_akyrs_value_up"),
                    func = function()
                        card.ability.extra_value = card.ability.extra_value + card.ability.extra
                        card:set_cost()
                    end
                } 
            end
        end
    end,
    blueprint_compat = false,
	demicoloncompat = true,
    hpot_unbreedable = true,
}

SMODS.Joker {
    key = "gift_voucher",
    atlas = 'guestJokerArts',
    pos = { x = 2, y = 0 },
    akyrs_credits = {
        art = {
            "gudusername_53951"
        },
        idea = {
            "gudusername_53951"
        },
        attrib = {
            ["gudusername_53951"] = {"art", "idea"},
        },
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_gud"]
        return {
            vars = {
                card.ability.extras.type and localize("k_"..string.lower(card.ability.extras.type or "fakecenter")) or "<"..localize("k_consumable_type")..">"
            }
        }
    end,
    rarity = 2,
    cost = 7,
    config = {
        extras = {
            type = nil
        }
    },
    set_ability = function (self, card, initial, delay_sprites)
    end,
    add_to_deck = function (self, card, from_debuff)
        local sts = AKYRS.get_consumable_set()
        card.ability.extras.type = pseudorandom_element(sts, "akyrs_gift_voucher_initial")
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                func = function()
                    local sts = AKYRS.get_consumable_set()
                    card.ability.extras.type = pseudorandom_element(sts, "akyrs_gift_voucher")
                end,
                message = localize("k_akyrs_gift_change")
            }
        end
    end,
    blueprint_compat = false,
	demicoloncompat = true,
}

SMODS.Joker {
    key = "sushi",
    atlas = 'AikoyoriJokers',
    pos = { x = 5, y = 6 },
    pools = { Food = true },
    config = {
        extras = {
            chips = 300,
            reduce_chips = -100,
        }
    },
    rarity = 3,
    cost = 7,

    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.chips,
                card.ability.extras.reduce_chips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extras.chips
            }
        end
        if context.buying_card and context.card and context.card ~= card and context.card.ability and context.card.ability.set == "Joker" and not context.blueprint then
            return {
                func = function ()
                    SMODS.scale_card(card,{
                        ref_table = card.ability.extras,
                        ref_value = "chips",
                        scalar_value = "reduce_chips",
                        scaling_message = { message = localize("k_akyrs_downgrade_ex") },
                    })
                    if card.ability.extras.chips <= 0 then
                        AKYRS.simple_event_add(function ()
                            card.pinch.x = true
                            SMODS.calculate_effect(
                                { message = localize("k_akyrs_ate_up")},
                                card
                            )
                            card:remove()
                            return true
                        end, 0.5)
                    end
                end,
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "biochamber",
    atlas = 'AikoyoriJokers',
    pos = { x = 7, y = 6 },
    pools = { ["Video Games"] = true, ["Factorio"] = true, },
    config = {
    },
    rarity = 2,
    cost = 7,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_nutrient"]
        return {
            vars = {
                
            }
        }
    end,
    calculate = function (self, card, context)
        if context.press_play then
            return {
                func = function()
                    AKYRS.simple_event_add(
                        function() 
                            if AKYRS.has_room(G.jokers) then
                                SMODS.add_card{ key = "j_akyrs_nutrient"}
                            end
                            return true
                        end, 0
                    )
                end
            }
        end
    end,
}

SMODS.Joker {
    key = "nutrient",
    atlas = 'AikoyoriJokers',
    pos = { x = 8, y = 6 },
    pools = { ["Video Games"] = true, Food = true, ["Factorio"] = true,  },
    config = {
        extras = {
            xc = 1.6,
            reduce = -0.2
        }
    },
    rarity = 1,
    cost = 1,
    in_pool = function (self, args)
        return false
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xc,
                -card.ability.extras.reduce
            }
        }
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                func = function()
                    SMODS.scale_card(card,{
                        ref_table = card.ability.extras,
                        ref_value = "xc",
                        scalar_value = "reduce",
                        scaling_message = { message = localize("k_akyrs_downgrade_ex") },
                    })

                    AKYRS.simple_event_add(function ()
                        if card.ability.extras.xc <= 1 then
                            card.pinch.x = true
                            SMODS.calculate_effect(
                                { message = localize("k_akyrs_ate_up")},
                                card
                            )
                            card:remove()
                        end
                        return true
                    end, 0.5)
                end
            }
        end
        if context.joker_main and not context.blueprint then
            return {
                xchips = card.ability.extras.xc
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "shine_bright_like_a_diamond",
    pools = { Meme = true },
    atlas = 'AikoyoriJokers',
    pos = { x = 9, y = 6 },
    pools = {  },
    config = {
        extras = {
            xc = 1.6,
            reduce = -0.2
        }
    },
    rarity = 2,
    cost = 4,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    calculate = function (self, card, context)
        if context.press_play then
            return {
                func = function()
                    AKYRS.simple_event_add(function() 
                        SMODS.add_card({suit = "Diamonds", rank = "Ace", area = G.play})
                        return true
                    end, 0)
                end
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "so_close",
    pools = { ["Video Game"] = true, ["Peggle"] = true },
    atlas = 'AikoyoriJokers',
    pos = { x = 0, y = 7 },
    pools = {  },
    config = {
        extras = {
            score_xbase = 0.03
        }
    },
    rarity = 2,
    cost = 7,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.score_xbase * 100
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.poker_hands and context.poker_hands["Two Pair"] and context.cardarea == G.hand then
            return {
                akyrs_score = card.ability.extras.score_xbase * (G.GAME.blind.chips or 0)
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "snow_pea",
    atlas = 'AikoyoriJokers',
    pools = { ["Video Game"] = true, ["Plants vs Zombies"] = true },
    pos = { x = 1, y = 7 },
    pools = {  },
    config = {
        extras = {
            xscore = 1.75,
        },
    },
    rarity = 3,
    cost = 8,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xscore
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                akyrs_xscore = card.ability.extras.xscore
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "konton_boogie",
    atlas = 'AikoyoriJokers',
    pos = { x = 2, y = 7 },
    pools = { ["Vocaloid"] = true, },
    pools = {  },
    config = {
        extras = {
            gain = 0.1,
            lose = 0.5,
            xmult = 1,
        },
    },
    rarity = 2,
    cost = 8,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.gain,
                card.ability.extras.lose,
                card.ability.extras.xmult,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before and #context.full_hand == #context.scoring_hand and not context.blueprint then
            return {
                func = function ()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extras,
                        ref_value = 'xmult',
                        scalar_value = 'lose',
                        scaling_message = { localize("k_akyrs_downgrade_ex") },
                        operation = function(ref_table, ref_value, initial, scalar_value)
                            ref_table[ref_value] = math.max(ref_table[ref_value] - scalar_value, 1)
                        end,
                    })
                end
            }
        end
        if context.individual and context.cardarea == 'unscored' and not context.blueprint then
            return {
                func = function ()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extras,
                        ref_value = 'xmult',
                        scalar_value = 'gain',
                    })
                end
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "yamada_perfect",
    atlas = 'AikoyoriJokers',
    pos = { x = 3, y = 7 },
    pools = { ["Vocaloid"] = true, },
    pools = {  },
    config = {
        extras = {
            gain = 0.1,
            lose = 0.1,
            xchips = 1,
            suit = nil,
        },
    },
    set_ability = function (self, card, initial, delay_sprites)
    end,
    add_to_deck = function (self, card, from_debuff)
        card.ability.extras.suit = pseudorandom_element(SMODS.Suits,"akyrs_yamadaperfect_suit").key
    end,
    rarity = 2,
    cost = 6,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.gain,
                card.ability.extras.lose,
                card.ability.extras.xchips,
                card.ability.extras.suit and localize(card.ability.extras.suit,"suits_plural") or ("<"..localize("k_suit")..">"),
                colours = {
                    card.ability.extras.suit and G.C.SUITS[card.ability.extras.suit] or G.C.FILTER
                }
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and not context.blueprint and context.cardarea == G.play then
            if not card.ability.extras.suit then
                card.ability.extras.suit = pseudorandom_element(SMODS.Suits,"akyrs_yamadaperfect_suit").key
            end
            if context.other_card and context.other_card:is_suit(card.ability.extras.suit) then
                SMODS.calculate_effect({
                    func = function ()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extras,
                            ref_value = 'xchips',
                            scalar_value = 'lose',
                            scaling_message = { localize("k_akyrs_downgrade_ex") },
                            operation = function(ref_table, ref_value, initial, scalar_value)
                                ref_table[ref_value] = math.max(ref_table[ref_value] - scalar_value, 1)
                            end,
                        })
                    end
                }, card)
            end
            if context.poker_hands and next(context.poker_hands["Flush"]) and not context.other_card:is_suit(card.ability.extras.suit) then
                SMODS.calculate_effect({
                    func = function ()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extras,
                            ref_value = 'xchips',
                            scalar_value = 'gain',
                        })
                    end
                }, card)
            end
        end
        if context.joker_main then
            return {
                xchips = card.ability.extras.xchips
            }
        end
        if context.after and context.cardarea == card.area then
            return {
                message = localize("k_reset"),
                func = function ()
                    card.ability.extras.suit = pseudorandom_element(SMODS.Suits,"akyrs_yamadaperfect_suit").key
                end,
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "trend_angelina",
    atlas = 'AikoyoriJokers',
    pos = { x = 4, y = 7 },
    pools = { ["Vocaloid"] = true, },
    pools = {  },
    config = {
        extras = {
            gain = 0.4,
            lose = 0.1,
            xscore = 1,
        },
    },
    rarity = 2,
    cost = 6,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.gain,
                card.ability.extras.lose,
                card.ability.extras.xscore,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before and not context.blueprint then
            if context.poker_hands and next(context.poker_hands["Straight"]) then
                SMODS.calculate_effect({
                    func = function ()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extras,
                            ref_value = 'xscore',
                            scalar_value = 'gain',
                        })
                    end
                }, card)
            end
            return {
                func = function ()
                    local freq = AKYRS.get_ranks_freq_from_cards(context.scoring_hand)
                    for k, v in pairs(freq) do
                        if v > 1 then
                            SMODS.calculate_effect({
                                func = function ()
                                    for _, cx in ipairs(context.scoring_hand) do
                                        if cx:get_id() == k then
                                            cx:juice_up(0.2, 0.2)
                                        end
                                    end
                                    SMODS.scale_card(card, {
                                        ref_table = card.ability.extras,
                                        ref_value = 'xscore',
                                        scalar_value = 'lose',
                                        scaling_message = { localize("k_akyrs_downgrade_ex") },
                                        operation = function(ref_table, ref_value, initial, scalar_value)
                                            ref_table[ref_value] = math.max(ref_table[ref_value] - scalar_value, 1)
                                        end,
                                    })
                                end
                            }, card)
                        end
                    end
                end
            }
        end
        if context.joker_main then
            return {
                akyrs_xscore = card.ability.extras.xscore
            }
        end
    end,
    blueprint_compat = true,
}
