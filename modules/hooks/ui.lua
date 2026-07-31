-- this file has ui hooks lol


local cardGetUIBoxRef = Card.generate_UIBox_ability_table

function Card:generate_UIBox_ability_table(vars)
    local ret = cardGetUIBoxRef(self,vars)
    if (G.GAME.akyrs_character_stickers_enabled or self.ability.forced_letter_render) and self.ability.aikoyori_letters_stickers then
        local letter = self.ability.aikoyori_letters_stickers

        if letter and letter == "#" then
            letter = "#"
        else
            if letter then
                letter = letter
            end
        end
        local loc_vars = {}
        if (letter) then
            loc_vars = {
                letter,
                (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers)),
                1 + (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers) / 10),
                self.ability.akyrs_word_freq
            }
        end
        
        local last_letter = string.lower(string.sub(letter, -1))
        local key = "letters"

        if(AKYRS.non_letter_symbols_reverse[last_letter] or last_letter == "#") then
            key = "symbols"
        end
        if(tonumber(last_letter)) then
            key = "numbers"
        end

        if self.is_null and (self.ability.set == "Enhanced" or self.ability.set == "Default") then
            --print(table_to_string(ret))
            local newRetTable = table.aiko_shallow_copy(ret)

            newRetTable.name = {}
            localize({
                type = 'name_text',
                key = 'aiko_x_akyrs_null',
                set = 'AikoyoriExtraBases',
                vars = { colours = { G.C.BLUE } },
                nodes =
                    newRetTable.name
            })
            newRetTable.name = newRetTable.name[1]
            newRetTable.main = AKYRS.deep_copy(ret.main)
            newRetTable.info = {}
            newRetTable.type = {}

            for i, v in ipairs(ret.info) do
                if i > 0 then
                    table.insert(newRetTable.info, v)
                end
            end
            if ((G.GAME.akyrs_character_stickers_enabled or self.ability.forced_letter_render) and letter) then
                generate_card_ui({ key = key, set = 'AikoyoriExtraBases', vars = loc_vars }, newRetTable)
            else
                generate_card_ui({ key = 'null_card', set = 'AikoyoriExtraBases', vars = loc_vars }, newRetTable)
            end
            
            if self.ability.set ~= 'Default' then
                --[[
                for i, v in ipairs(ret.main) do
                    if i > 0 then
                        table.insert(newRetTable.main, v)
                    end
                end]]
                for i, v in ipairs(ret.type) do
                    if i > 0 then
                        table.insert(newRetTable.type, v)
                    end
                end
            else

            end


            ret = newRetTable
        else
            if ((G.GAME.akyrs_character_stickers_enabled or self.ability.forced_letter_render) and letter) then
                generate_card_ui({ key = key, set = 'AikoyoriExtraBases', vars = loc_vars }, ret)
            end
        end
    end
    if self.akyrs_enchantments and #self.akyrs_enchantments > 0 then
        for i, enchstr in ipairs(self.akyrs_enchantments) do
            local lx = AKYRS.Enchantments[enchstr[1]]:loc_vars({}, self, enchstr[2]) or {}
            lx.key = enchstr[1]
            lx.set = 'Enchantment'
            generate_card_ui(lx, ret)
        end
    end
    if self.akyrs_stored_enchantments and #self.akyrs_stored_enchantments > 0 then
        for i, enchstr in ipairs(self.akyrs_stored_enchantments) do
            local lx = AKYRS.Enchantments[enchstr[1]]:loc_vars({}, self, enchstr[2]) or {}
            lx.key = enchstr[1]
            lx.set = 'Enchantment'
            generate_card_ui(lx, ret)
        end
    end
    return ret
end

local blindRemoveHook = Blind.remove
function Blind:remove()
    if not AKYRS.do_not_remove_blind then
        return blindRemoveHook and blindRemoveHook(self) or Moveable.remove(self)
    end
    
end

function recalculateBlindUI()
    if G.HUD_blind then
        local blind_hud_ui_function = create_UIBox_HUD_blind
        local config = G.HUD_blind.config
        -- for blindside
        if G.GAME.selected_back.effect.center.config.extra and G.GAME.selected_back.effect.center.config.extra.blindside then
            blind_hud_ui_function = create_UIBox_HUD_jokerblind
            --config = {major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = {x=0,y=-10}, bond = 'Weak'}
        end
        -- note!!!! blind HUD are recalculated for proper popups!
        -- target your blind HUD thingiest here
        AKYRS.do_not_remove_blind = true
        G.HUD_blind:remove()
        G.HUD_blind = UIBox{
            definition = blind_hud_ui_function(),
            config = config
        }
    
        --AKYRS.remove_all(G.HUD_blind.children,function(v) print("A") return v and v.config and (v.config.object ~= G.GAME.blind) end)
        --[[
        G.HUD_blind.UIRoot:remove()
        G.HUD_blind.definition = create_UIBox_HUD_blind()
        G.HUD_blind:set_parent_child(G.HUD_blind.definition, nil)

        ]]
        AKYRS.do_not_remove_blind = nil
        G.HUD_blind:recalculate()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0,
          func = function()
            if G.SHOP_SIGN then
                G.SHOP_SIGN.alignment.offset.y = -15
            end
            return true
          end
        }))
        G.GAME.akyrs_ui_should_recalculate = nil
    end
end

local setBlindHook = Blind.set_blind
function Blind:set_blind(x, y, z)
    local abc = setBlindHook(self,x ,y,z)
    --if x then recalculateBlindUI() end
    
    return abc
end

function recalculateHUDUI()
    if G.HUD then
        ease_discard(0, true, true)
        G.HUD:recalculate()
    end
end

local easeDiscardHook = ease_discard
function ease_discard(mod, instant, silent)
    local discard_UI = G.HUD:get_UIE_by_ID('discard_UI_count')
    if discard_UI then
        if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards and not G.GAME.blind.disabled and not G.GAME.blind.disabled and not G.GAME.aiko_puzzle_win then
            G.GAME.current_round.aiko_infinite_hack = "∞"
            discard_UI.config.object.font = G.FONTS[8] -- thanks go noto core
            discard_UI.config.object.config.string[1].ref_value = "aiko_infinite_hack"
            --discard_UI.config.object.T.r = 1.57
            attention_text({
                text = localize("ph_akyrs_unknown"),
                scale = 0.8, 
                hold = 0.7,
                cover = discard_UI.parent,
                cover_colour = G.C.RED,
                align = 'cm',
            })
            --Play a chip sound
            if not silent then play_sound('chips2') end
            discard_UI.config.object:update_text(true)
        else
            discard_UI.config.object.config.string[1].ref_value = "discards_left"
            discard_UI.config.object.T.r = 0
            discard_UI.config.object.font = G.LANG.font
            local ret = easeDiscardHook(mod, instant, silent)
            return ret
        end
    end

end

local cardHoverHook = Card.hover
function Card:hover()
    AKYRS.current_hover_card = self
    local ret = cardHoverHook(self)
    return ret
end
local nodeHoverHook = Node.hover
function Node:hover()
    if AKYRS.should_hide_ui() then
        if self.config.h_popup then
            AKYRS.remove_objects_in_nodes(self.config.h_popup.nodes)
        end
        self.config.h_popup = nil
    end
    local ret = nodeHoverHook(self)
    return ret
end

local tagGenUI = Tag.generate_UI
function Tag:generate_UI(_sz)
    local x = {tagGenUI(self,_sz)}
    if AKYRS.should_hide_ui() then
        x[2].hover = function() end
    end
    return unpack(x)
end
local taghoverproxy = G.FUNCS.hover_tag_proxy
G.FUNCS.hover_tag_proxy = function(e)
    if not AKYRS.should_hide_ui() then
        taghoverproxy(e)
    end
end

local genCardUIHook = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if AKYRS.should_hide_ui() then
        return {
            main = {},
            info = {},
            type = {},
            name = nil,
            badges = badges or {},
        }
    end
    return genCardUIHook(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
end

local uiboxspc = UIBox.set_parent_child

function UIBox:set_parent_child(node, parent)
    if node then
        return uiboxspc(self,node,parent)
    end

end

local cardStopHoverHook = Card.stop_hover
function Card:stop_hover()
    local ret = cardStopHoverHook(self)
    return ret
end

local chalUnlock = set_challenge_unlock
function set_challenge_unlock()
    local ret = chalUnlock()

    if G.PROFILES[G.SETTINGS.profile].all_unlocked then return end

    if not G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked then
        if G.PROFILES[G.SETTINGS.profile].challenges_unlocked then
            local challenges_unlocked, challenge_alls = 0, #G.CHALLENGES
            for k, v in ipairs(G.CHALLENGES) do
                if v.id and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id or ''] then
                    challenges_unlocked = challenges_unlocked + 1
                end
            end
            if (challenges_unlocked >= 1) then
                G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked = true
                notify_alert('b_akyrs_hardcore_challenges', "Back")
            end
        end
    end
    return ret
end

G.FUNCS.akyrs_wildcard_check = function(e)
    G.FUNCS.set_button_pip(e)
    local colour = G.C.GREEN
    local button = nil
    if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then
        button = 'akyrs_wildcard_open_wildcard_ui'
        if not e.config.ref_table.ability.aikoyori_pretend_letter then
            colour = AKYRS.config.wildcard_behaviour == 3 and SMODS.Gradients["akyrs_unset_letter"] or G.C.RED
        elseif e.config.ref_table.ability.aikoyori_pretend_letter == "#" then
            colour = G.C.YELLOW
        end
    else
        colour = G.C.UI.BACKGROUND_INACTIVE
        button = nil
    end
    e.config.button = button
    e.config.colour = colour
end

G.FUNCS.akyrs_wildcard_open_wildcard_ui = function(e)
    if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then 
        --print("SUCCESS!")
        local card = e.config.ref_table
        G.FUNCS.overlay_menu{
            definition = AKYRS.UIDEF.wildcards_set_letter_ui(card)
        }
        --print(inspect(e.config.ref_table))
    else
        
    end
end


G.FUNCS.akyrs_wildcard_set_letter_wildcard = function(e)
    
    local card = e.config.ref_table.card
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(e.config.ref_table.letter ~= "" and e.config.ref_table.letter or nil)
                return true
            end
        }
    )
    AKYRS.better_input_selected = nil
    G.FUNCS.exit_overlay_menu()
end

G.FUNCS.akyrs_wildcard_set_letter_wildcard_auto = function(e)
    
    local card = e.config.ref_table.card
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters("#")
                card:highlight(false)
                return true
            end
        }
    )
    card.area:remove_from_highlighted(card, true)
    AKYRS.better_input_selected = nil
    G.FUNCS.exit_overlay_menu()
end
    
G.FUNCS.akyrs_wildcard_unset_letter_wildcard = function(e)
    
    local card = e.config.ref_table.card
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(nil)
                card:highlight(false)
                return true
            end
        }
    )
    AKYRS.better_input_selected = nil
    G.FUNCS.exit_overlay_menu()
end
G.FUNCS.akyrs_wildcard_switch_case_letter_wildcard = function(e)
    
    local card = e.config.ref_table.card
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(AKYRS.swap_case(card.ability.aikoyori_pretend_letter))
                card:highlight(false)
                return true
            end
        }
    )
    AKYRS.better_input_selected = nil
    G.FUNCS.exit_overlay_menu()
end

G.FUNCS.akyrs_wildcard_quit_set_letter_wildcard_menu = function(e)
    AKYRS.better_input_selected = nil
    G.FUNCS.exit_overlay_menu()
end


function AKYRS.UIDEF.wildcards_set_letter_ui(card)
    local data = { letter = card.ability.aikoyori_pretend_letter or '', card = card }
    
    
    return create_UIBox_generic_options({
        back_func = 'akyrs_wildcard_quit_set_letter_wildcard_menu',
        contents = {
                {
                    n = G.UIT.R,
                    config = { padding = 0.05,  w = 6, colour = G.C.CLEAR, align = 'cm' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cm' },
                            nodes = {
                                AKYRS.create_better_text_input({
                                    w = 4.5,
                                    h = 1,
                                    max_length = 1, 
                                    extended_corpus = true, 
                                    prompt_text = "",
                                    ref_table = data,
                                    ref_value = "letter",
                                    id = "wild_card",
                                    keyboard_offset = 4.5,
                                })
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { align = "cm", padding = 0.1 },
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.GREEN,
                                            button = "akyrs_wildcard_set_letter_wildcard",
                                            label = { localize("k_akyrs_letter_btn_set") },
                                            ref_table = data,
                                            minw = 2.5,
                                            focus_args = { set_button_pip = true, button = 'leftshoulder', orientation = 'rm'},
                                        }),
                                    },
                                },
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.YELLOW,
                                            text_colour = G.C.UI.TEXT_DARK,
                                            button = "akyrs_wildcard_set_letter_wildcard_auto",
                                            label = { localize("k_akyrs_letter_btn_auto") },
                                            ref_table = data,
                                            minw = 2.5,
                                            focus_args = { set_button_pip = true, button = 'rightshoulder', orientation = 'rm', snap_to = true },
                                        }),
                                    },
                                },
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.RED,
                                            text_colour = G.C.WHITE,
                                            button = "akyrs_wildcard_unset_letter_wildcard",
                                            ref_table = data,
                                            label = { localize("k_akyrs_letter_btn_unset") },
                                            minw = 2.5,
                                            focus_args = {},
                                        }),
                                    },
                                },
                            },
                        },
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cl' },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        scale = 0.3,
                                        text = localize("k_akyrs_textbox_notice")
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cl' },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        scale = 0.3,
                                        text = localize("k_akyrs_textbox_notice_2")
                                    }
                                }
                            }
                        },
                    }
                },
            }
        }
    )
end

function AKYRS.UIDEF.wildcards_ui(card)
    local colour = G.C.GREEN
    local text_colour = G.C.UI.TEXT_LIGHT
    local text = ""
    if card.ability.aikoyori_letters_stickers == "#" then
        if not card.ability.aikoyori_pretend_letter then
            text = localize("k_akyrs_letter_btn_unset")
            colour = AKYRS.config.wildcard_behaviour == 3 and SMODS.Gradients["akyrs_unset_letter"] or G.C.RED
        elseif card.ability.aikoyori_pretend_letter == "#" then
            text = localize("k_akyrs_letter_btn_auto")
            colour = G.C.YELLOW
            text_colour = G.C.UI.TEXT_DARK
        else
            text = localize("k_akyrs_letter_btn_set")
        end
    end
    if card.area and card.area == G.hand then
        return {
            n = G.UIT.ROOT,
            config = { padding = 0, colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { padding = 0.15, align = 'cl' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = 'cl' },
                            nodes = {
                                {

                                    n = G.UIT.C,
                                    config = { align = "cl" },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { 
                                                    ref_table = card, 
                                                    align = "cl", 
                                                    maxw = 1.25, 
                                                    padding = 0.1, 
                                                    r = 0.08, 
                                                    minw = 1.9, 
                                                    minh = 1.5, 
                                                    hover = true, 
                                                    shadow = true, 
                                                    colour = colour, 
                                                    button = "akyrs_wildcard_open_wildcard_ui", 
                                                },
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = localize("k_akyrs_letter_btn_currently"), colour = text_colour, scale = 0.4, shadow = true } },
                                                    }
                                                },
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = text, colour = text_colour, scale = 0.6, shadow = true, func = 'set_button_pip', 
                                                            focus_args = {
                                                            button = 'leftshoulder', 
                                                            orientation = 'bm',
                                                        }, } },
                                                    }
                                                },
                                            }
                                        }
                                    }
                                },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                            }
                        },
                    }
                },
            }
        }
    end
end

function AKYRS.UIDEF.use_ui(card)
    local colour = G.C.AKYRS_AIKOYORI_BOW
    local text_colour = G.C.UI.TEXT_LIGHT
    local added_to_deck = card.added_to_deck
    
    local text = localize("k_akyrs_use_from_drag")
    local text2 = localize("k_akyrs_use_from_drag_consumable")
    if card.config.center.set == "Voucher" then
        text2 = localize("k_akyrs_use_from_drag_voucher")
    end
    if card.config.center.set == "Joker" then
        if added_to_deck then return {n = G.UIT.ROOT, nodes = {}} end
        text = localize("k_akyrs_use_from_drag_apply")
        text2 = localize("k_akyrs_use_from_drag_joker")
    end
    if card.config.center.set == "Default" or card.config.center.set == "Enhanced" then
        text = localize("k_akyrs_use_from_drag_apply")
        text2 = localize("k_akyrs_use_from_drag_pcard")
    end
    if card.area then
        return {
            n = G.UIT.ROOT,
            config = { padding = 0, colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { padding = 0.15, align = 'cl' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = 'cl' },
                            nodes = {
                                {

                                    n = G.UIT.C,
                                    config = { align = "cl" },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { 
                                                    ref_table = card, 
                                                    align = "cl", 
                                                    maxw = 1.25, 
                                                    padding = 0.1, 
                                                    r = 0.08, 
                                                    minw = 2.2, 
                                                    minh = 1, 
                                                    hover = true, 
                                                    shadow = true, 
                                                    colour = colour, 
                                                    button = "akyrs_use_snatch", 
                                                },
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = text, colour = text_colour, scale = 0.4, shadow = true } },
                                                    }
                                                },
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = text2, colour = text_colour, scale = 0.25, shadow = true } },
                                                    }
                                                },
                                            }
                                        },
                                    }
                                },
                            }
                        },
                    }
                },
            }
        }
    end
end

function AKYRS.UIDEF.special_joker_use(card)
    local colour = G.C.RED
    local text_colour = G.C.UI.TEXT_LIGHT
    local added_to_deck = card.added_to_deck
    
    local text = localize("b_use")
    if card.config.center.key == "j_akyrs_sulfur_cube" then
        text = localize("k_reroll")
    end
    if card.area then
        return {
            n = G.UIT.ROOT,
            config = { padding = 0, colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { padding = 0.15, align = 'cl' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = 'cl' },
                            nodes = {
                                {

                                    n = G.UIT.C,
                                    config = { align = "cr" },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { 
                                                    ref_table = card, 
                                                    align = "cr", 
                                                    maxw = 1.25, 
                                                    padding = 0.1, 
                                                    r = 0.08, 
                                                    func = "akyrs_can_use_special",
                                                    minw = 2.2, 
                                                    minh = 0.6, 
                                                    hover = true, 
                                                    shadow = true, 
                                                    colour = colour, 
                                                    button = "akyrs_use_special", 
                                                },
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = text, colour = text_colour, scale = 0.4, shadow = true } },
                                                    }
                                                },
                                            }
                                        },
                                    }
                                },
                            }
                        },
                    }
                },
            }
        }
    end
end
G.FUNCS.akyrs_can_use_special = function(e)
    local card = e.config.ref_table
    local can_use = true
    if card.config.center.key == "j_akyrs_sulfur_cube" then
        if G.GAME.dollars - card.ability.extras.cost < G.GAME.bankrupt_at then
            can_use = false
        end
    end
    if can_use then
        e.config.colour = G.C.RED
        e.config.button = "akyrs_use_special"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end
G.FUNCS.akyrs_use_special = function (e)
    local card = e.config.ref_table
    
    if card.config.center.key == "j_akyrs_sulfur_cube" then
        ease_dollars(card.ability.extras.cost)
        local k = SMODS.poll_object{ type = "Joker", seed = "akyrs_sulfur_cube" }
        card.ability.extras.copying_key = k
        if card.akyrs_sulphur_card then
            card.akyrs_sulphur_card:remove()
            card.akyrs_sulphur_card = nil
        end
        card.akyrs_sulphur_card = Card(card.T.x, card.T.y, 0, 0, nil, G.P_CENTERS[k] )
        AKYRS.remove_value_from_table(G.I.CARD, card.akyrs_sulphur_card)
        card.akyrs_sulphur_card.akyrs_parent = card
        card.akyrs_sulphur_card:add_to_deck()
    end
    
end

-- add buttons n shi
local cardhighlighthook = Card.highlight
function Card:highlight(is_higlighted)
    local ret = cardhighlighthook(self, is_higlighted)

    if self.base and (self.area and self.area == G.hand) and self.ability.aikoyori_letters_stickers == "#" then
        if is_higlighted and self.area and self.area ~= G.play and self.area.config.type ~= 'shop' then

            self.children.akyrs_wildcard = UIBox {
                definition = AKYRS.UIDEF.wildcards_ui(self),
                config = { align =
                    "cl",
                    offset = { x = 1, y = -0.75 },
                    parent = self }
            }
        end
    end
    if AKYRS.is_in_typical_area(self.area) and AKYRS.card_any_drag() and self.ability.set ~= "Default" and self.ability.set ~= "Enhanced" then
        self.children.akyrs_redeem_voucher = UIBox {
            definition = AKYRS.UIDEF.use_ui(self),
            config = { align =
                "cl",
                offset = { x = 1, y = 0.65 },
                parent = self }
        }
    end
    if AKYRS.can_card_be_used(self) and self.area then
        self.children.akyrs_use_box = UIBox {
            definition = AKYRS.UIDEF.special_joker_use(self),
            config = { align =
                "cr",
                offset = { x = -1, y = 0.85 },
                parent = self }
        }
    end
    if not is_higlighted then
        if self.children.akyrs_wildcard then
            self.children.akyrs_wildcard:remove()
            self.children.akyrs_wildcard = nil
        end
        if self.children.akyrs_redeem_voucher then
            self.children.akyrs_redeem_voucher:remove()
            self.children.akyrs_redeem_voucher = nil
        end
        if self.children.akyrs_use_box then
            self.children.akyrs_use_box:remove()
            self.children.akyrs_use_box = nil
        end
    end
    return ret
end

local useCardHook = G.FUNCS.use_card
G.FUNCS.use_card = function (e,m,ns)
    local card = e.config.ref_table
    if card.ability.set == "Replicant" then
        AKYRS.trigger_tldr_conditions("used_replicant")
    end
    if card.config.center.key == "c_akyrs_umbral_intrusive_thoughts" then
        AKYRS.trigger_tldr_conditions("used_intrusive_thought")
    end
    local area = card.area
    local prev_state = G.STATE
    local dont_dissolve = nil
    local delay_fac = 1
    if area == G.hand and card.ability.aikoyori_letters_stickers == "#" then
        G.FUNCS.akyrs_wildcard_open_wildcard_ui(e)
        return true
    end
    local r = useCardHook(e,m,ns)
    return r
    
end

local canPlayHook = G.FUNCS.can_play
G.FUNCS.can_play = function(e)
    local shouldDisableButton = false
    local runOGHook = true
    if AKYRS.config.wildcard_behaviour == 2 and G.GAME.akyrs_character_stickers_enabled then
        
        for i,k in ipairs(G.hand.highlighted) do
            if k.ability.aikoyori_letters_stickers == "#" and not k.ability.aikoyori_pretend_letter then
                shouldDisableButton = true
                break
            end
        end
    elseif G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_mathematics_enabled then
        
        local word_hand = {}
        local hand = {}
        for i,k in ipairs(G.hand.highlighted) do
            table.insert(hand,k)
        end
        table.sort(hand, AKYRS.hand_sort_function)
        for _, v in pairs(hand) do
            if not v.ability then return {} end
            local alpha = v.ability.aikoyori_letters_stickers:lower()
            if alpha == "#" and v.ability.aikoyori_pretend_letter then
                -- if wild is set fr tbh
                alpha = v.ability.aikoyori_pretend_letter:lower()
            elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                alpha = '★'
            end
            table.insert(word_hand, alpha)
                
        end
        
        local to_number = to_number or function(l) return l end
        local expression = table.concat(word_hand)
        local stat, val = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,expression)
        local stat2, val = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,""..to_number(G.GAME.chips)..expression)
        local assignment_parts = {}
        for part in expression:gmatch("[^=]+") do
            table.insert(assignment_parts, part)
        end
        local stat3 = false
        if #assignment_parts == 2 then
            local variable, value_expression = assignment_parts[1], assignment_parts[2]
            local status, value = pcall(AKYRS.MathParser.solve, AKYRS.MathParser, value_expression)
            if status then
                stat3 = true
            end
        end


        if not stat and not stat2 and not stat3 then
            shouldDisableButton = true
            runOGHook = false
        end
    end
    if G.AKYRS_LOCK_CARD_SELECTION then
        shouldDisableButton = true
    end
    if shouldDisableButton then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        runOGHook = false
    end
    if runOGHook then
        return canPlayHook(e)
    end
end

local discardAbilityHook = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    
    local shouldDisableButton = false
    if G.AKYRS_LOCK_CARD_SELECTION then
        shouldDisableButton = true
    end
    if G.hand and G.hand.highlighted then
        for _, _c in ipairs(G.hand.highlighted) do
            if _c.ability.akyrs_attention then
                shouldDisableButton = true
                break
            end
            if next(SMODS.find_card("j_akyrs_mikudashi")) and _c:is_suit("Hearts") then
                shouldDisableButton = true
                break
            end
        end
    end
    if shouldDisableButton then        
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        local ret = discardAbilityHook(e)
        return ret
    end
    --[[
    if #G.hand.highlighted > 0 and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end]]
end


function UIBox:akyrs_set_parent_child_with_pos(node, parent, pos)
    local UIE = UIElement(parent, self, node.n, node.config)

    --set the group of the element
    if parent and parent.config and parent.config.group then if UIE.config then UIE.config.group = parent.config.group else UIE.config = {group = parent.config.group} end end

    --set the button for the element
    if parent and parent.config and parent.config.button then if UIE.config then UIE.config.button_UIE = parent else UIE.config = {button_UIE = parent} end end
    if parent and parent.config and parent.config.button_UIE then if UIE.config then UIE.config.button_UIE = parent.config.button_UIE else UIE.config = {button = parent.config.button} end end

    if node.n and node.n == G.UIT.O and UIE.config.button then
        UIE.config.object.states.click.can = false
    end

    --current node is a container
    if (node.n and node.n == G.UIT.C or node.n == G.UIT.R or node.n == G.UIT.ROOT) and node.nodes then
        for k, v in pairs(node.nodes) do
            self:set_parent_child(v, UIE)
        end
    end

    if not parent then
        self.UIRoot = UIE 
        self.UIRoot.parent = self
    else
        table.insert(parent.children, pos, UIE)
    end
    if node.config and node.config.mid then 
        self.Mid = UIE
    end
end


local ogBlindBox = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
    local x = ogBlindBox()
    local blind_setup = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local shit = AKYRS.add_blind_extra_info(blind_setup,nil,{text_size = 0.35,border_size = 0.3, difficulty_text_size = 0.3, cached_icons = true, row = true})

    local bldis = G.GAME.blind and G.GAME.blind.disabled or false

    --print(inspect(G.GAME.blind))

    
    local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local elem = x.nodes[2].nodes[2].nodes[2]


    if bl and elem then
        local blindloc = AKYRS.getBlindText(G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck] or "nololxd")
        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        if blindloc[1] then elem.nodes[1].nodes[1].config.text = blindloc[1] end
        if blindloc[2] then elem.nodes[2].nodes = {
            { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
            { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
            { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED, id = 'HUD_blind_count', shadow = true } }
        }
        end
    end    
    if #shit > 0 then
        G.akyrs_blind_icons = true
        table.insert(x.nodes[2].nodes,2,{
            n = G.UIT.R, config = { align = "cm", id = "akyrs_blind_attributes"}, nodes = shit
        })
        table.insert(x.nodes[2].nodes,2, { n = G.UIT.B, config = { h = 0.1, w = 0.1 } })
    else
        G.akyrs_blind_icons = nil
    end

    return x
end

local blindSetTextHook = Blind.set_text
function Blind:set_text()
    local x = blindSetTextHook(self)
    G.HUD_blind:recalculate()
    return x
end

local ogBlindSel = create_UIBox_blind_choice
function create_UIBox_blind_choice(type, run_info)
    local x = ogBlindSel(type, run_info)
    local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]]
    local elem = AKYRS.search_UIT_for_id(x, "blind_desc")
    if bl and elem then
        local blindloc = AKYRS.getBlindText(G.GAME.round_resets.blind_choices[type] or "nololxd", "blind_select")
        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        if blindloc[1] then
            pcall(function ()
                elem.nodes[2].nodes[1].nodes[1].config.text = blindloc[1]
            end)
        end
        if blindloc[2] then
            pcall(function ()
            elem.nodes[2].nodes[2].nodes = {
            
                { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
                { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
                { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED, shadow = true } }
            }
            end)
        end

    end
    return x
end


local ogBlindUIPopup = create_UIBox_blind_popup
function create_UIBox_blind_popup(bl, disco, vars)
    local x = ogBlindUIPopup(bl,disco,vars)
    
    local info_queue = {}
    AKYRS.add_blind_extra_info(bl,nil,{text_size = 0.25, difficulty_text_size = 0.3, full_ui = true, info_queue = info_queue})
    if #info_queue > 0 then
        local noders = {}
        local all_nodes = {}
        x.n = G.UIT.R
        --table.insert(noders,x)
        for i, valueinfo in ipairs(info_queue) do
            local full_UI_table = {
                main = {},
                info = {},
                type = {},
                name = 'done',
                badges = {}
            }
            local desc = generate_card_ui(valueinfo, full_UI_table)
            if desc then
                table.insert(noders,{
                    n = G.UIT.R, config = { align = "cm"}, nodes = {
                        {n=G.UIT.C, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
                            info_tip_from_rows(desc.info[1], desc.info[1].name)
                        }}
                    }
                })
            end
        end
        table.insert(all_nodes,
        { n = G.UIT.C, config={align = "cm", func = 'show_infotip',object = Moveable(),ref_table = next(noders) and noders or nil}, nodes = {
            x
        }})
        --table.insert(all_nodes,x)
        return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes=all_nodes}
    end
    return x
end

local locHooker = localize
function localize(args, misc_cat)
    if not args then args = {} end
    return locHooker(args, misc_cat)
end

--[[
G.FUNCS.HUD_blind_debuff = function(e)
	local scale = 0.4
	local num_lines = #G.GAME.blind.loc_debuff_lines
	while G.GAME.blind.loc_debuff_lines[num_lines] == '' do
		num_lines = num_lines - 1
	end
	local padding = 0.05
	if num_lines > 5 then
		local excess_height = (0.3 + padding)*(num_lines - 5)
		padding = padding - excess_height / (num_lines + 1)
	end
	e.config.padding = padding
	if num_lines > #e.children then
		for i = #e.children+1, num_lines do
			local node_def = {n = G.UIT.R, config = {align = "cm", minh = 0.3, maxw = 4.2}, nodes = {
				{n = G.UIT.T, config = {ref_table = G.GAME.blind.loc_debuff_lines, ref_value = i, scale = scale * 0.9, colour = G.C.UI.TEXT_LIGHT}}}}
			e.UIBox:set_parent_child(node_def, e)
		end
	elseif num_lines + (G.skill_deck and 1 or 0) + (G.akyrs_blind_icons and 1 or 0) < #e.children then
		for i = num_lines+1, #e.children do
			e.children[i]:remove()
			e.children[i] = nil
		end
	end
	assert(G.HUD_blind == e.UIBox)
	e.UIBox:recalculate()

end
]]
local moveableRemoveHook = Moveable.remove
function Moveable:remove()
    if self.children and type(self.children) == 'table' then
        for i, ch in pairs(self.children) do
            ch.REMOVED = true
            ch:remove()
        end
    end
    self.REMOVED = true
    return moveableRemoveHook(self)
end

AKYRS.mod_run_info_hands = function(object, in_collection)
    --print("RUN")
    local show_power
    if Talisman then
        show_power = to_big(G.GAME.akyrs_pure_hand_modifier.power) ~= to_big(1)
    else 
        show_power = G.GAME.akyrs_pure_hand_modifier.power ~= 1
    end
    local to_number = to_number or function(l) return tonumber(l) end
    if G.GAME.akyrs_pure_unlocked and not in_collection then
        table.insert(object.nodes, 1,{
                n = G.UIT.R,
                config = { colour = G.C.AKYRS_UMBRAL_Y, r = 0.05, padding = 0.1 },
                nodes =     {
            {n=G.UIT.C, config={align = "cl", padding = 0, minw = 5}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.HAND_LEVELS[math.floor(to_number(math.min(7, G.GAME.akyrs_pure_hand_modifier.level)))], minw = 1.5, outline = 0.8, outline_colour = G.C.WHITE}, nodes={
                {n=G.UIT.T, config={text = localize('k_level_prefix')..number_format(G.GAME.akyrs_pure_hand_modifier.level), scale = 0.5, colour = G.C.UI.TEXT_DARK}}
                }},
                {n=G.UIT.C, config={align = "cm", minw = 4.5, maxw = 4.5}, nodes={
                {n=G.UIT.T, config={text = ' '..localize("k_akyrs_pure_hands"), scale = 0.45, colour = G.C.BLACK, shadow = true}}
                }}
            }},
            {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
                {n=G.UIT.T, config={text = "×", scale = 0.45, colour = G.C.AKYRS_UMBRAL_Y}},
                {n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = G.C.AKYRS_UMBRAL_P, minw = 1.1}, nodes={
                    {n=G.UIT.T, config={text = number_format(G.GAME.akyrs_pure_hand_modifier.multiplier, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
                    {n=G.UIT.B, config={w = 0.08, h = 0.01}}
                }},
                show_power and {n=G.UIT.T, config={text = "^", scale = 0.45, colour = G.C.AKYRS_UMBRAL_P}},
                show_power and {n=G.UIT.C, config={align = "cl", padding = 0.01, r = 0.1, colour = G.C.AKYRS_UMBRAL_Y, minw = 1.1}, nodes={
                    {n=G.UIT.B, config={w = 0.08,h = 0.01}},
                    {n=G.UIT.T, config={text = number_format(G.GAME.akyrs_pure_hand_modifier.power, 1000000), scale = 0.45, colour = G.C.UI.TEXT_DARK}}
                }}
            }},
            not show_power and {n=G.UIT.B, config={w = 0.8,h = 0.01}},
            {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.T, config={text = '  #', scale = 0.45, colour = G.C.UI.TEXT_DARK, shadow = true}}
                }},
            {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.L_BLACK,r = 0.1, minw = 0.9}, nodes={
                {n=G.UIT.T, config={text = G.GAME.akyrs_pure_hand_modifier.played, scale = 0.45, colour = G.C.FILTER, shadow = true}},
            }}
            }
        })
    end
    return object
end

local refresh_col_sel = G.FUNCS.refresh_contrast_mode
G.FUNCS.refresh_contrast_mode = function(...)
    
    if G.aiko_wordle then
        G.aiko_wordle:remove(); G.aiko_wordle = nil
    end
    if not G.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
        G.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
    return refresh_col_sel(...)
end


local gameMainMenuRef = Game.main_menu
function Game:main_menu(change_context)
    gameMainMenuRef(self, change_context)
    UIBox({
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        scale = 0.3,
                        text = "Aikoyori's Shenanigans v"..AKYRS.version,
                        colour = G.C.UI.TEXT_LIGHT
                    }
                }
            }
        },
        config = {
            align = "tli",
            bond = "Weak",
            offset = {
                x = 0,
                y = 0
            },
            major = G.ROOM_ATTACH
        }
    })
end

AKYRS.rows_needed_for_icon = function()
    return (G.skill_deck and 1 or 0) + (G.akyrs_blind_icons and 1 or 0) 
end

local tagGen = Tag.generate_UI
function Tag:generate_UI(_size)
    local tag_sprite_tab, tag_sprite = tagGen(self, _size)
    if AKYRS.should_conceal_card(nil,self.config) then
        tag_sprite.atlas = G.ASSET_ATLAS["akyrs_aikoyoriTags"]
        tag_sprite:set_sprite_pos({x = 0, y = 9})
    end
    return tag_sprite_tab, tag_sprite
end



local additionsTabHook = buildAdditionsTab
function buildAdditionsTab(mod)
        if mod == AKYRS then
            --[[
        local consumable_nodes = {}
        for _, key in ipairs(SMODS.ConsumableType.visible_buffer) do
            local id = 'your_collection_'..key:lower()..'s'
            local tally = modsCollectionTally(G.P_CENTER_POOLS[key])
            if tally.of > 0 then
                consumable_nodes[#consumable_nodes+1] = UIBox_button({button = id, label = {localize('b_'..key:lower()..'_cards')}, count = tally, minw = 4, id = id, colour = G.C.SECONDARY_SET[key], text_colour = G.C.UI[key]})
            end
        end
        if #consumable_nodes > 3 then
            consumable_nodes = { UIBox_button({ button = 'your_collection_consumables', label = {localize('b_stat_consumables'), localize{ type = 'variable', key = 'c_types', vars = {#consumable_nodes} } }, count = modsCollectionTally(G.P_CENTER_POOLS.Consumeables), minw = 4, minh = 4, id = 'your_collection_consumables', colour = G.C.FILTER }) }
        end

        local leftside_nodes = {}
        for _, v in ipairs { { k = 'Joker', minh = 1.7, scale = 0.6 }, { k = 'Back', b = 'decks' }, { k = 'Voucher' } } do
            v.b = v.b or v.k:lower()..'s'
            v.l = v.l or v.b
            local tally = modsCollectionTally(G.P_CENTER_POOLS[v.k])
            if tally.of > 0 then
                leftside_nodes[#leftside_nodes+1] = UIBox_button({button = 'your_collection_'..v.b, label = {localize('b_'..v.l)}, count = modsCollectionTally(G.P_CENTER_POOLS[v.k]),  minw = 5, minh = v.minh, scale = v.scale, id = 'your_collection_'..v.b})
            end
        end
        if #consumable_nodes > 0 then
            leftside_nodes[#leftside_nodes + 1] = {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1, r = 0.2, colour = G.C.BLACK },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm", maxh = 2.9 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_cap_consumables'), scale = 0.45, colour = G.C.L_BLACK, vert = true, maxh = 2.2 } },
                        }
                    },
                    { n = G.UIT.C, config = { align = "cm", padding = 0.15 }, nodes = consumable_nodes }
                }
            }
        end

        local rightside_nodes = {}
        for _, v in ipairs { { k = 'Enhanced', b = 'enhancements', l = 'enhanced_cards'}, { k = 'Seal' }, { k = 'Edition' }, { k = 'Booster', l = 'booster_packs' }, { b = 'tags', p = G.P_TAGS }, { b = 'blinds', p = G.P_BLINDS, minh = 2.0 }, } do
            v.b = v.b or v.k:lower()..'s'
            v.l = v.l or v.b
            v.p = v.p or G.P_CENTER_POOLS[v.k]
            local tally = modsCollectionTally(v.p)
            if tally.of > 0 then
                rightside_nodes[#rightside_nodes+1] = UIBox_button({button = 'your_collection_'..v.b, label = {localize('b_'..v.l)}, count = modsCollectionTally(v.p),  minw = 5, minh = v.minh, id = 'your_collection_'..v.b})
            end
        end
        local has_other_gameobjects = create_UIBox_Other_GameObjects()
        if has_other_gameobjects then
            rightside_nodes[#rightside_nodes+1] = UIBox_button({button = 'your_collection_other_gameobjects', label = {localize('k_other')}, minw = 5, id = 'your_collection_other_gameobjects', focus_args = {snap_to = true}})
        end

        local t = {n=G.UIT.R, config={align = "cm",padding = 0.2, minw = 7}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes = leftside_nodes },
        {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes = rightside_nodes }
        }}

        local modNodes = {}
        table.insert(modNodes, t)
            ]]
        additionsTabHook(mod) -- call original to keep functionality, other mods maybe hooking into this
		return {
        label = localize("b_additions"),
        chosen = SMODS.LAST_SELECTED_MOD_TAB == "additions" or false,
        tab_definition_function = function()
            SMODS.LAST_SELECTED_MOD_TAB = "additions"
            
            -- finished : check design mockup on notes
            -- jokers [non-letter/letter] consumables -- done
            -- blinds boosters vouchers editions others
            -- seals deck tags
            local first_row = {}
            local second_row = {}
            local third_row = {}
            local joker_normal = AKYRS.card_collection_ui_template('j_akyrs_tldr_joker')
            local joker_letter = AKYRS.card_collection_ui_template('j_akyrs_catchphrase')
            local consumables_planet = AKYRS.card_collection_ui_template('c_akyrs_p_lacerta')
            local consumables_umbral = AKYRS.card_collection_ui_template('c_akyrs_umbral_intrusive_thoughts')
            local consumables_alphabet = AKYRS.card_collection_ui_template('c_akyrs_alphabet_a')
            local blind_card = AKYRS.fake_blind_chip("bl_akyrs_the_thought")
            local booster_umbral = AKYRS.card_collection_ui_template("p_akyrs_jumbo_umbral_pack_1")
            local voucher_alphabet = AKYRS.card_collection_ui_template("v_akyrs_alphabet_soup")
            local editioned_joker = AKYRS.card_collection_ui_template("j_oops")
            local other_cards = AKYRS.card_collection_ui_template("j_joker", { atlas_key = "akyrs_eggymariHatenaSprite" })
            local tag_card = AKYRS.fake_card_sprite({ atlas = "akyrs_aikoyoriTags", pos = { x = 0, y = 0}})
            local thai_tea_card = AKYRS.card_collection_ui_template("m_akyrs_thai_tea_card", nil, "S_6")
            local deck_overlaid = AKYRS.card_collection_ui_template("j_joker", { atlas_key = "akyrs_deckBacks" })
            local sealed_card = AKYRS.card_collection_ui_template("c_base", nil, "C_7")
            sealed_card:set_seal("akyrs_carmine", true, true)
            editioned_joker:set_edition({akyrs_noire = true}, true, true)
            joker_normal.click = function (self)
                G.FUNCS.akyrs_your_collection_non_letter_jokers(self)
            end
            joker_letter.click = function (self)
                G.FUNCS.akyrs_your_collection_letter_jokers(self)
            end
            consumables_planet.click = function (self)
                G.FUNCS.your_collection_consumables(self)
            end
            consumables_umbral.click = function (self)
                G.FUNCS.your_collection_consumables(self)
            end
            consumables_alphabet.click = function (self)
                G.FUNCS.your_collection_consumables(self)
            end
            blind_card.click = function (self)
                G.FUNCS.your_collection_blinds(self)
            end
            booster_umbral.click = function (self)
                G.FUNCS.your_collection_boosters(self)
            end
            voucher_alphabet.click = function (self)
                G.FUNCS.your_collection_vouchers(self)
            end
            editioned_joker.click = function (self)
                G.FUNCS.your_collection_editions(self)
            end
            other_cards.click = function (self)
                G.FUNCS.your_collection_other_gameobjects(self)
            end
            tag_card.click = function (self)
                G.FUNCS.your_collection_tags(self)
            end
            thai_tea_card.click = function (self)
                G.FUNCS.your_collection_enhancements(self)
            end
            sealed_card.click = function (self)
                G.FUNCS.your_collection_seals(self)
            end
            deck_overlaid.click = function (self)
                G.FUNCS.your_collection_decks(self)
            end
            AKYRS.create_card_collection_underlay(joker_normal,{
                text = localize("b_akyrs_normal_jokers"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Joker, nil, {
                    no_count = function (center)
                        return not center.akyrs_is_letter
                    end
                })
            })
            AKYRS.create_card_collection_underlay(joker_letter,{
                text = localize("b_akyrs_letter_jokers"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Joker, nil, {
                    no_count = function (center)
                        return center.akyrs_is_letter
                    end
                })
            })
            AKYRS.create_card_collection_underlay(consumables_umbral,{
                text = localize("b_stat_consumables"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Consumeables, nil)
            })
            AKYRS.create_card_collection_underlay(blind_card,{
                height = 1.8,
                text = localize("b_blinds"),
                tally = AKYRS.modsCollectionTally(G.P_BLINDS, nil)
            })
            AKYRS.create_card_collection_underlay(booster_umbral,{
                text = localize("b_booster_packs"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Booster, nil)
            })
            AKYRS.create_card_collection_underlay(voucher_alphabet,{
                text = localize("b_vouchers"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Voucher, nil)
            })
            AKYRS.create_card_collection_underlay(editioned_joker,{
                text = localize("b_editions"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Edition, nil)
            })
            AKYRS.create_card_collection_underlay(tag_card,{
                text = localize("b_tags"),
                height = 1.2,
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Tag, nil)
            })
            AKYRS.create_card_collection_underlay(other_cards,{
                text = localize("k_other"),
            })
            AKYRS.create_card_collection_underlay(thai_tea_card,{
                text = localize("b_enhanced_cards"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Enhanced, nil)
            })
            AKYRS.create_card_collection_underlay(sealed_card,{
                text = localize("b_seals"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Seal, nil)
            })
            AKYRS.create_card_collection_underlay(deck_overlaid,{
                text = localize("b_decks"),
                tally = AKYRS.modsCollectionTally(G.P_CENTER_POOLS.Back, nil)
            })
            -- jonkler
            first_row[#first_row+1] = AKYRS.card_area_preview(
                nil,
                nil,
                {
                    orientation = G.UIT.C,
                    override = true,
                    w = 3.6,
                    h = 0.8,
                    type = "akyrs_collections",
                    cards = {joker_normal, joker_letter},
                    highlight_limit = 0,
                }
            )
            -- consumable
            first_row[#first_row+1] = AKYRS.card_area_preview(
                nil,
                nil,
                {
                    orientation = G.UIT.C,
                    override = true,
                    w = 2.2,
                    h = 0.8,
                    type = "akyrs_collections",
                    cards = {consumables_planet, consumables_umbral, consumables_alphabet},
                    highlight_limit = 0,
                }
            )
            --
            second_row[#second_row+1] = AKYRS.card_area_preview(
                nil,
                nil,
                {
                    orientation = G.UIT.C,
                    override = true,
                    w = 6.0,
                    h = 0.8,
                    type = "akyrs_collections",
                    cards = {blind_card, booster_umbral, voucher_alphabet, editioned_joker, tag_card},
                    highlight_limit = 0,
                }
            )
            third_row[#third_row+1] = AKYRS.card_area_preview(
                nil,
                nil,
                {
                    orientation = G.UIT.C,
                    override = true,
                    w = 6.0,
                    h = 1,
                    type = "akyrs_collections",
                    cards = {thai_tea_card, sealed_card, other_cards, deck_overlaid},
                    highlight_limit = 0,
                }
            )
            return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 6,
                    align = "tm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { padding = 0.25 },
                        nodes = first_row,
                    },
                    {
                        n = G.UIT.R,
                        config = { padding = 0.25 },
                        nodes = second_row,
                    },
                    {
                        n = G.UIT.R,
                        config = { padding = 0.25 },
                        nodes = third_row,
                    },
                }
            }
        end
    }
	end
	return additionsTabHook(mod)
end


function AKYRS.modsCollectionTally(pool, set, extras)
    local set = set or nil
    local obj_tally = {tally = 0, of = 0}
    extras = extras or {}

    for _, v in pairs(pool) do
        if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id and not v.no_collection and ((extras.no_count and extras.no_count(v)) or not extras.no_count) then
            if set then
                if v.set and v.set == set then
                    obj_tally.of = obj_tally.of+1
                    if v.discovered then 
                        obj_tally.tally = obj_tally.tally+1
                    end
                end
            else
                obj_tally.of = obj_tally.of+1
                if v.discovered then 
                    obj_tally.tally = obj_tally.tally+1
                end
            end
        end
    end

    return obj_tally
end


create_UIBox_your_collection_aikoshen_jokers = function(letter)
    local jkrs = {}
    for i, v in ipairs(G.P_CENTER_POOLS.Joker) do
        if v.akyrs_is_letter == letter then
            table.insert(jkrs, v)
        end
    end
    return SMODS.card_collection_UIBox(jkrs, {5,5,5}, {
        no_materialize = true, 
        modify_card = function(card, center) card.sticker = get_joker_win_sticker(center) end,
        h_mod = 0.95,
    })
end


create_UIBox_akyrs_credits_collection = function(author)
    local jkrs = {}
    for i, pool in pairs(G.P_CENTER_POOLS) do
        --print(pool)
        for i2, v in ipairs(pool) do
            if v.akyrs_credits and v.akyrs_credits.attrib and v.akyrs_credits.attrib[author] then
                table.insert(jkrs, v)
            end
        end
    end
    return SMODS.card_collection_UIBox(jkrs, {5,5,5}, {
        no_materialize = true, 
        modify_card = function(card, center) 
            card.sticker = get_joker_win_sticker(center)
         end,
        h_mod = 0.95,
    })
end

create_UIBox_akyrs_collection_bet = function(author)
    local jkrs = {}
    for i, v in pairs(G.P_CENTER_POOLS.Bet) do
        --print(pool)
        table.insert(jkrs, v)
    end
    return SMODS.card_collection_UIBox(jkrs, {5,5,5}, {
        no_materialize = true, 
        h_mod = 0.95,
    })
end

create_UIBox_akyrs_collection_judgement = function()
    local jkrs = {}
    for i, v in ipairs(AKYRS.Judgement_Buffer) do
        --print(pool)
        table.insert(jkrs, AKYRS.Judgements[v])
    end
    return SMODS.card_collection_UIBox(jkrs, {6}, {
        no_materialize = true, 
        center = "c_base",
        modify_card = function (card, center, i, j)
            card.akyrs_judgement = center.key
            card.akyrs_collection_judgement = true
        end,
        h_mod = 0.95,
    })
end
AKYRS.enchantment_collection_UIBox = function(_pool, rows, args)
    args = args or {}
    args.w_mod = args.w_mod or 1
    args.h_mod = args.h_mod or 1
    args.card_scale = args.card_scale or 1
    local deck_tables = {}
    local pool_fake = SMODS.collection_pool(_pool)
    local pool = {}
    local sortorder = 0
    for i, _c in ipairs(pool_fake) do
        for i = 1, _c.max_level do
            pool[#pool+1] = {_c, i, sortorder}
            sortorder = sortorder + 1
        end
    end
    table.sort(pool, function(a,b) return a[3] < b[3] end)
    --print(pool)

    G.your_collection = {}
    local cards_per_page = 0
    local row_totals = {}
    for j = 1, #rows do
        if cards_per_page >= #pool and args.collapse_single_page then
            rows[j] = nil
        else
            row_totals[j] = cards_per_page
            cards_per_page = cards_per_page + rows[j]
            G.your_collection[j] = CardArea(
                G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
                (args.w_mod*rows[j]+0.25)*G.CARD_W,
                args.h_mod*G.CARD_H,
                {card_limit = rows[j], type = args.area_type or 'title', highlight_limit = 0, collection = true}
            )
            table.insert(deck_tables,
            {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
                {n=G.UIT.O, config={object = G.your_collection[j]}}
            }})
        end
    end

    local options = {}
    for i = 1, math.ceil(#pool/cards_per_page) do
        table.insert(options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#pool/cards_per_page)))
    end

    G.FUNCS.AKYRS_enchanted_collection_page = function(e)
        if not e or not e.cycle_config then return end
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards, 1, -1 do
            local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
            c:remove()
            c = nil
            end
        end
        for j = 1, #rows do
            for i = 1, rows[j] do
                local data = pool[i+row_totals[j] + (cards_per_page*(e.cycle_config.current_option - 1))]
                if not data then break end
                local center = data[1]
                if not center then break end
                local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W*args.card_scale, G.CARD_H*args.card_scale, G.P_CARDS.empty, (args.center and G.P_CENTERS[args.center]) or center)
                if args.modify_card then args.modify_card(card, center, i, j) end
                card.ability.akyrs_level = data[2]
                if not args.no_materialize then card:start_materialize(nil, i>1 or j>1) end
                G.your_collection[j]:emplace(card)
            end
        end
        INIT_COLLECTION_CARD_ALERTS()
    end

    G.FUNCS.AKYRS_enchanted_collection_page{ cycle_config = { current_option = 1 }}

    local t = create_UIBox_generic_options({
        colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
        bg_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
        back_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (G.ACTIVE_MOD_UI.ui_config or {}).back_colour),
        outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or
                (G.ACTIVE_MOD_UI.ui_config or {}).outline_colour),
        back_func = (args and args.back_func) or G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection', snap_back = args.snap_back, infotip = args.infotip, contents = {
          {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
          (not args.hide_single_page or cards_per_page < #pool) and {n=G.UIT.R, config={align = "cm"}, nodes={
            create_option_cycle({options = options, w = 4.5, cycle_shoulders = true, opt_callback = 'AKYRS_enchanted_collection_page', current_option = 1, colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour or G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
          }} or nil,
      }})
    return t
end
create_UIBox_akyrs_collection_enchantment = function()
    local jkrs = {}
    for i, v in ipairs(AKYRS.Enchantments_Buffer) do
        --print(pool)
        local en = AKYRS.Enchantments[v]
        table.insert(jkrs, en)
    end
    return AKYRS.enchantment_collection_UIBox(jkrs, {5,5,5}, {
        no_materialize = true, 
        h_mod = 0.95,
    })
end


G.FUNCS.akyrs_your_collection_non_letter_jokers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_aikoshen_jokers(),
    }
end

G.FUNCS.akyrs_your_collection_letter_jokers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_aikoshen_jokers(true),
    }
end

G.FUNCS.akyrs_your_collection_credits = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_akyrs_credits_collection(e.config.ref_table.credit),
    }
end
G.FUNCS.akyrs_your_collection_bet = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_akyrs_collection_bet(),
    }
end

G.FUNCS.akyrs_your_collection_judgement = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_akyrs_collection_judgement(),
    }
end

G.FUNCS.akyrs_your_collection_enchantment = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_akyrs_collection_enchantment(),
    }
end

local create_mod_badge_hook = SMODS.create_mod_badge
function SMODS.create_mod_badge(mod, obj, width, text_height)
    if mod == AKYRS then
        return AKYRS.badge_func()
    end
    return create_mod_badge_hook(mod, obj, width, text_height)
end

local cbmb = SMODS.create_blind_mod_badge
function SMODS.create_blind_mod_badge()

    if G.GAME.blind and G.GAME.blind.config.blind and G.GAME.blind.config.blind.mod then
        local mod = G.GAME.blind.config.blind.mod
        if mod == AKYRS then
            
            local mnind = pseudorandom("akyrs_mod_name", 1, #G.localization.misc.akyrs_misc.mod_label)
            local mod_name_node = {
                n = G.UIT.R, config = {colour = G.C.CLEAR, padding = 0.1}, nodes = {}
            }
            localize({ type = "akyrs_misc", key = "mod_label",  index = mnind, nodes = mod_name_node.nodes, scale = 1.2, text_colour = mod.badge_text_colour, akyrs_dynatext_shadow = false, akyrs_default_dynatext_effect = '1' , akyrs_force_no_popin = true, akyrs_y_offset = -0.05})
            local mod_full_node = {
                n = G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {mod_name_node}
            } 
            for k, v in ipairs(mod_name_node.nodes) do
                mod_name_node.nodes[k] = {n = G.UIT.C, config = { align = "m"}, nodes = mod_name_node.nodes[k]}
            end
            --local text = DynaText({string = {{ref_table = G.GAME.blind_badge, ref_value = 'name'}}, colours = {mod.badge_text_colour or G.C.WHITE}, shadow = true, silent = true, float = true, scale = 0.36})
            local bs = UIBox({
                        definition = mod_full_node,
                        config = {
                            align= 'cm',
                        }
                    })
            local text_scroll = SMODS.UIScrollBox({
                    content = bs,
                    container = {
                        config = {
                            can_collide = false,
                        }
                    },
                    overflow = {
                        node_config = {
                            no_overflow = not mod.no_marquee and "h" or false,
                            maxw = not mod.no_marquee and 4.4 or nil,
                        },
                        config = {
                            can_collide = false,
                        }
                    },
                    sync_mode = "offset",
                    scroll_move = function(self, dt)
                        local dx = self:get_scroll_distance()
                        if dx == 0 or mod.no_marquee then return end
                        if not self.scroll_start_pause then
                            self.scroll_start_pause = 1.5
                        end
                        if self.scroll_start_pause > 0 and self.scroll_offset.x >= 0 then
                            self.scroll_start_pause = self.scroll_start_pause - G.real_dt
                        else
                            self.scroll_offset.x = (self.scroll_offset.x or 0) + G.real_dt / 1.5
                            if self.scroll_offset.x > self.content_container.T.w then
                                self.scroll_start_pause = 1.5
                                self.scroll_offset.x = -self.T.w - 0.1
                            end
                        end
                    end,
                })
            return {n=G.UIT.R, config={align = "cm", padding = 0.03*0.9, minh = 0.4}, nodes={
                {n=G.UIT.O, config={object = text_scroll}},
            }}
        end
    end
    return cbmb()
end
local gfhbb = G.FUNCS.HUD_blind_badge
G.FUNCS.HUD_blind_badge = function(e)
    if G.GAME.blind.in_blind then
        if G.GAME.blind.config.blind.mod and G.GAME.blind.config.blind.mod == AKYRS then
            if G.GAME.blind.config.blind.mod then
                if not e.children[1] then 
                    local mod = G.GAME.blind.config.blind.mod
                    G.GAME.blind_badge.name = mod.display_name
                    e.UIBox:add_child(SMODS.create_blind_mod_badge(), e)
                    e.config.colour = mod.badge_colour or G.C.DYN_UI.MAIN
                    e.config.emboss = 0.05
                    e.config.shader = 'akyrs_aiko_mod_badge'
                    e.states.visible = true
                end
            elseif e.children[1] then
                e.states.visible = false
                e.children[1]:remove()
                e.children[1] = nil
            end
        end
    end
end

function AKYRS.mod_loc_vars(card, loc_vars)
    if card.is_null or card.config.center_key == "m_akyrs_scoreless" or card.ability.akyrs_special_card_type == "suit" then
        loc_vars.nominal_chips = nil
    end
end
local sort_z = function (a, b)
    return a.T.z < b.T.z
end
function AKYRS.sort_depth()
    for tbl_k, instance_tables in pairs(G.I) do
        local neg_z = {}
        local zero_z = {}
        local pos_z = {}
        for _, inst in ipairs(instance_tables) do
            inst.T.z = inst.T.z or 0
            if inst.T.z > 0 then
                pos_z[#pos_z+1] = inst
            elseif inst.T.z < 0 then
                neg_z[#neg_z+1] = inst
            else
                zero_z[#zero_z+1] = inst
            end
        end
        local should_even_do_anything = #neg_z > 0 or #pos_z > 0
        if should_even_do_anything then
            local tbl_set = {}
            for _, zs in ipairs({neg_z, zero_z, pos_z}) do
                if #zs > 0 then
                    if zs ~= zero_z then
                        table.sort(zs, sort_z)
                    end
                    for _, v in ipairs(zs) do
                        tbl_set[#tbl_set+1] = v
                    end
                end
            end
            G.I[tbl_k] = tbl_set
        end
        
    end
end