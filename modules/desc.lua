AKYRS.DescriptionDummy{
    key = "maxwell_example",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if desc_nodes ~= full_UI_table.main and AKYRS.should_show_card_previews() then
            local cards = {}
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            table.insert(cards, AKYRS.create_random_card("maxwellui") )
            local letters = {'s','p','e','c','t','r','a','l'}
            for index, value in ipairs(cards) do
                value.ability.forced_letter_render = true
                value.is_null = true
                value:set_letters(letters[index])
            end
            AKYRS.card_area_preview(G.akyrsCardsPrev, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.4,
                h = 0.5,
                ml = 0,
                box_height = 2.5,
                alignment = "bm",
                scale = 0.5,
                func_delay = 0.1* AKYRS.get_speed_mult(AKYRS.current_hover_card),
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    blockable = false,
                                    delay = (0.1*i) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                                    func = function ()
                                        k.highlighted = true
                                        return true
                                    end
                                },"akyrs_desc")
                            end
                        end

                        G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            blockable = false,
                            blocking = false,
                            delay = (1+0.5) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                            func = function ()

                                if ca and ca.cards then            
                                    for i,k in ipairs(ca.cards) do
                                        k:start_dissolve({G.C.RED}, true, 0)
                                    end
                                    local cn = create_card("Spectral", ca, nil, nil, true, true, nil)
                                    cn.T.scale = 0.5
                                    ca:emplace(cn)
                                end
                                return true
                            end
                        },"akyrs_desc")
                    end
                end,
            })
        end

    end,
}

AKYRS.DescriptionDummy{
    key = "yona_yona_ex",
    generate_ui = function(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        SMODS.Joker.super.generate_ui(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        if AKYRS.should_show_card_previews() then
            local cards = {}
            local card = AKYRS.create_random_card("yona")
            card:set_base(G.P_CARDS["S_4"], true)
            table.insert(cards,card)
            local card = AKYRS.create_random_card("yona")
            card:set_base(G.P_CARDS["C_7"], true)
            table.insert(cards,card)
            AKYRS.card_area_preview(G.yonacards,desc_nodes,{
                override = true,
                cards = cards,
                w = 1.2,
                h = 0.6,
                ml = 0,
                scale = 0.5,
                func_delay = 0.5,
                func_list = {
                    function (ca) if ca and ca.cards then ca.cards[1]:juice_up() end end,
                    function (ca) if ca and ca.cards then ca.cards[1]:juice_up() end end,
                    function (ca) if ca and ca.cards then ca.cards[2]:juice_up() end end,
                    function (ca) if ca and ca.cards then ca.cards[2]:juice_up() end end,
                }
            })
        end
    end,
}

AKYRS.DescriptionDummy{
    key = "2fa_example",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if desc_nodes ~= full_UI_table.main and AKYRS.should_show_card_previews() then
            local cards = {}
            table.insert(cards, AKYRS.create_random_card("2faui") )
            table.insert(cards, AKYRS.create_random_card("2faui") )
            table.insert(cards, AKYRS.create_random_card("2faui") )
            table.insert(cards, AKYRS.create_random_card("2faui") )
            table.insert(cards, AKYRS.create_random_card("2faui") )
            AKYRS.card_area_preview(G.akyrsCardsPrev2fa, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.4,
                h = 0.5,
                ml = 0,
                box_height = 2.5,
                alignment = "bm",
                scale = 0.5,
                func_delay = 0,
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    blockable = false,
                                    delay = (0.5 + 0.1*i) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                                    func = function ()
                                        k.highlighted = true
                                        G.E_MANAGER:add_event(Event{
                                            trigger = 'after',
                                            blocking = false,
                                            delay = 0.2*i,
                                            func = function ()
                                                if ca and ca.cards then
                                                    if ca.cards[i] then
                                                        ca.cards[i]:flip()
                                                    end
                                                end
                                                return true
                                            end
                                        },"akyrs_desc")
                                        return true
                                    end
                                },"akyrs_desc")
                            end
                        end

                        G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            blockable = false,
                            blocking = false,
                            delay = 2.5 * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                            func = function ()

                                if ca and ca.cards then            
                                    for i,k in ipairs(ca.cards) do
                                        local _rank = nil
                                        local _suit = nil
                                        while _rank == nil or _suit == nil do
                                            _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('akyrs2fadr'))
                                            _suit = pseudorandom_element(SMODS.Suits, pseudoseed('akyrs2fads'))
                                        end
                                        
                                        
                                        if ca.cards[i] then
                                            AKYRS.change_base_skip(ca.cards[i],_suit.key,_rank.key)
                                            ca.cards[i]:flip()
                                        end
                                    end
                                end
                                return true
                            end
                        },"akyrs_desc")
                    end
                end,
            })
        end

    end,
}
-- credits
AKYRS.DescriptionDummy{
    key = "credit_larantula",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

        AKYRS.embedded_ui_sprite("akyrs_larantula_l_credits",{x = 0, y = 0}, desc_nodes, {
            w = 800,
            h = 800,
            rounded = 0.5
        })
    end,
}

AKYRS.DescriptionDummy{
    key = "credit_gud",
}

AKYRS.DescriptionDummy{
    key = "credit_lyman",
}

AKYRS.DescriptionDummy{
    key = "credit_marcyptata64",
}


AKYRS.DescriptionDummy{
    key = "wildcard_behaviour_1",
}
AKYRS.DescriptionDummy{
    key = "wildcard_behaviour_2",
}
AKYRS.DescriptionDummy{
    key = "wildcard_behaviour_3",
}
AKYRS.DescriptionDummy{
    key = "wildcard_behaviour_4",
}

AKYRS.DescriptionDummy{
    key = "balance_settings",
}

AKYRS.DescriptionDummy{
    key = "card_preview_tooltip",
}
AKYRS.DescriptionDummy{
    key = "crt_shader_toggle",
}

AKYRS.DescriptionDummy{
    key = "crt_shader_toggle",
}

AKYRS.DescriptionDummy{
    key = "full_dictionary",
}

AKYRS.DescriptionDummy{
    key = "toggle_colourblind_ui",
}

AKYRS.DescriptionDummy{
    key = "experimental_feature",
}

--popup

AKYRS.DescriptionDummy{
    key = "tldr_tldr",
}
AKYRS.DescriptionDummy{
    key = "expert_blind"
}
AKYRS.DescriptionDummy{
    key = "master_blind"
}
AKYRS.DescriptionDummy{
    key = "ultima_blind"
}
AKYRS.DescriptionDummy{
    key = "remaster_blind"
}
AKYRS.DescriptionDummy{
    key = "lunatic_blind"
}
AKYRS.DescriptionDummy{
    key = "dx_blind"
}
AKYRS.DescriptionDummy{
    key = "no_disabling"
}
AKYRS.DescriptionDummy{
    key = "no_reroll"
}
AKYRS.DescriptionDummy{
    key = "no_overriding"
}
AKYRS.DescriptionDummy{
    key = "no_skipping"
}
AKYRS.DescriptionDummy{
    key = "word_blind"
}
AKYRS.DescriptionDummy{
    key = "puzzle_blind"
}
AKYRS.DescriptionDummy{
    key = "forgotten_blind"
}
AKYRS.DescriptionDummy{
    key = "postwin_blind"
}
AKYRS.DescriptionDummy{
    key = "endless_blind"
}
AKYRS.DescriptionDummy{
    key = "kessoku_band",
}
AKYRS.DescriptionDummy{
    key = "copper_scrape_tip",
}
AKYRS.DescriptionDummy{
    key = "break_up_tip",
    loc_vars=function (self, info_queue, card)
        return {
            key = AKYRS.should_show_card_previews() and self.key or self.key.."_no_preview"
        }
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if AKYRS.should_show_card_previews() then
            local cards = {
            }
            for i = 1,5 do
                local c = AKYRS.create_random_card("break_up") 
                assert(SMODS.change_base(c,"Clubs"))
                AKYRS.set_special_card_type(c,"suit")
                table.insert(cards, c)
            end
            AKYRS.card_area_preview(G.akyrs_pure_hands_tip,desc_nodes,{
                override = true,
                cards = cards,
                w = 2.1,
                h = 0.6,
                ml = 0,
                mb = 0.5,
                scale = 0.5,
            })
        end
    end,
}
AKYRS.DescriptionDummy{
    key = "letter_puzzle_umbral_expl",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if AKYRS.should_show_card_previews() then
            local cards = {
            }
            for i = 1,2 do
                local c = AKYRS.create_random_card("puzzle_letter") 
                table.insert(cards, c)
            end
            AKYRS.card_area_preview(G.akyrs_pure_hands_tip,desc_nodes,{
                override = true,
                cards = cards,
                w = 1.4,
                h = 0.6,
                ml = 0,
                mb = 0.5,
                scale = 0.5,
                func_list = {
                    function(ca) delay(2.0, "akyrs_desc") end,
                    function(ca) if ca then
                        AKYRS.do_things_to_card(ca.cards, function (c,i)
                            if ca and ca.cards then
                                if i == 1 then
                                    local c2 = ca.cards[2]
                                    if c:get_letter_with_pretend() and c2:get_letter_with_pretend() then
                                        c:set_letters(c:get_letter_with_pretend()..c2:get_letter_with_pretend())
                                    end
                                else
                                    c:start_dissolve({G.C.AKYRS_UMBRAL_P, G.C.AKYRS_UMBRAL_Y}, true)
                                end
                            end
                        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true, no_sound = true}, "akyrs_desc")
                    end end,
                }
            })
        end
    end,
}

AKYRS.DescriptionDummy{
    key = "neon_seal_ex",
}

if SMODS.DynaTextEffect then
    SMODS.DynaTextEffect {
        key = "obfuscate",
        func = function (dynatext, index, letter)
            letter.letter = love.graphics.newText(dynatext.font.FONT, string.char(math.fmod((string.byte(letter.char) + math.fmod(math.floor(G.TIMERS.REAL * 142.1 + index), 192)), 94)+ 33))
        end
    }

    SMODS.DynaTextEffect {
        key = "rainbow_wiggle",
        func = function (dynatext, index, letter)
            letter.colour = AKYRS.hsl2rgb(math.fmod((G.TIMERS.REAL + index) * 50, 360), 1, 0.75)
            letter.offset.y = math.cos(G.TIMERS.REAL * 2.95 + index) * 9
            letter.scale = (((math.sin((G.TIMERS.REAL + index)*2.9443) + 1)/2) + 6 )/6
        end
    }
    SMODS.DynaTextEffect {
        key = "snaking",
        func = function (dynatext, index, letter)
            letter.offset.x = math.sin((G.TIMERS.REAL + index) * 7.95) * 7
            letter.offset.y = math.cos((G.TIMERS.REAL + index) * 7.95) * 7
        end
    }
    SMODS.DynaTextEffect {
        key = "shrivel",
        func = function (dynatext, index, letter)
            letter.offset.x = math.sin((G.TIMERS.REAL * 14511.15 + index * 534.415) * 7.95) * 5
            letter.offset.y = math.cos((G.TIMERS.REAL * 534.15 + index * 14511.415) * 7.95) * 5
        end
    }
    SMODS.DynaTextEffect {
        key = "exponent",
        func = function (dynatext, index, letter)
            letter.offset.y = 20
            letter.offset.x = 20
        end
    }
end