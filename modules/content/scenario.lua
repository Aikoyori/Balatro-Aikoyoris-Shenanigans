AKYRS.Scenarios = {}
AKYRS.Scenarios_Buffer = {}


local offset = {x = 4.8,y = 0.5}
local offset_each = {x = -0.2,y = 0}

AKYRS.Scenario_Tag = Object:extend()

-- honestly this is just tag code but modified because it works

function AKYRS.Scenario_Tag:init(_scenario, for_collection, _blind_type)
    self.key = _scenario
    local proto = AKYRS.Scenarios[_scenario]
    self.sc_config = copy_table(proto.config)
    self.config = proto
    self.pos = proto.pos
    self.name = proto.name
    self.akyrs_scenario_tally = G.GAME.akyrs_scenario_tally or 0
    self.triggered = false
    self.akyrs_total_rounds = proto.akyrs_total_rounds or 4
    self.akyrs_rounds_left = proto.akyrs_rounds_left or proto.akyrs_total_rounds or 4
    G.akyrs_scenario_id = G.akyrs_scenario_id or 0
    self.ID = G.akyrs_scenario_id
    G.akyrs_scenario_id = G.akyrs_scenario_id + 1
    G.GAME.akyrs_scenario_tally = G.GAME.akyrs_scenario_tally and (G.GAME.akyrs_scenario_tally + 1) or 1
    if not for_collection then self:set_ability() end

end


function AKYRS.Scenario_Tag:set_ability()
    local obj = AKYRS.Scenarios[self.key]
    self.ability = copy_table(obj.config)
    self.scenario = copy_table(obj.scenario)
    self.akyrs_total_rounds = obj.akyrs_total_rounds or 4
    self.akyrs_rounds_left = obj.akyrs_rounds_left or obj.akyrs_total_rounds or 4
    if obj and obj.set_ability and type(obj.set_ability) == 'function' then
        obj:set_ability(self)
    end
end


function AKYRS.Scenario_Tag:save()
    return {
        key = self.key,
        akyrs_scenario_tally = self.akyrs_scenario_tally, 
        ability = self.ability,
        rounds_left = self.akyrs_rounds_left,
        total_rounds = self.akyrs_total_rounds,
    }
end

function AKYRS.Scenario_Tag:load(tag_savetable)
    self.key = tag_savetable.key
    local proto = AKYRS.Scenarios[self.key]
    self.sc_config = copy_table(proto.config)
    self.config = proto
    self.pos = proto.pos
    self.name = proto.name
    self.scenario = proto.scenario
    self.akyrs_rounds_left = tag_savetable.rounds_left
    self.akyrs_total_rounds = tag_savetable.total_rounds
    self.akyrs_scenario_tally = tag_savetable.akyrs_scenario_tally
    self.ability = tag_savetable.ability
    G.GAME.akyrs_scenario_tally = math.max(self.akyrs_scenario_tally, G.GAME.akyrs_scenario_tally) + 1
    self.from_load = true
end

function AKYRS.Scenario_Tag:juice_up(_scale, _rot)
    if self.tag_sprite then self.tag_sprite:juice_up(_scale, _rot) end
end

function AKYRS.get_scenario_wheel_progress_offset(sc_proto)
    if sc_proto.scenario and sc_proto.scenario.colour == "pink" then
        if sc_proto.scenario.side == "light" then
            return { 0, -0.41 }
        else
            return { 0, 0.41 }
        end
    end
    return { 0, 0 }
end

function AKYRS.Scenario_Tag:generate_UI(_size, z)
    _size = _size or 0.8

    local tag_sprite_tab = nil

    local tag_sprite = SMODS.create_sprite(0, 0, _size*1, _size*1, SMODS.get_atlas((not self.hide_ability) and AKYRS.Scenarios[self.key].tag_atlas or "tags"), ((self.hide_ability) and G.tag_undiscovered.pos or (self.tag_pos or self.pos)))
    tag_sprite.T.scale = 1
    tag_sprite_tab = {n= G.UIT.C, config={align = "cm", ref_table = self, group = self.tally}, nodes={
        {n=G.UIT.O, config={w=_size*1,h=_size*1, colour = G.C.BLUE, object = tag_sprite, focus_with_object = true}},
    }}
    tag_sprite.float = true
    tag_sprite.T.z = z
    tag_sprite.states.hover.can = true
    tag_sprite.states.drag.can = false
    tag_sprite.states.collide.can = true
    tag_sprite.config = {scenario_tag = self, force_focus = true}
    tag_sprite:define_draw_steps({{
        shader = 'akyrs_pinwheel_progress',
        send = {
            {name = 'left', ref_table = self, ref_value = 'akyrs_rounds_left'},
            {name = 'total', ref_table = self, ref_value = 'akyrs_total_rounds'},
            {name = 'image_details', func = function() return tag_sprite:get_image_dims() end},
            {name = 'texture_details', func = function() return tag_sprite:get_pos_pixel() end},
            {name = 'pinwheel_offset', func = function() return AKYRS.get_scenario_wheel_progress_offset(self) end},
        }}})

    tag_sprite.hover = function(_self)
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not _self.hovering and _self.states.visible then
                _self.hovering = true
                if _self == tag_sprite then
                    _self.hover_tilt = 3
                    _self:juice_up(0.05, 0.02)
                    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
                    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
                end

                self:get_uibox_table(tag_sprite)
                _self.config.h_popup =  G.UIDEF.card_h_popup(_self)
                _self.config.h_popup_config = {align =  'tm', offset = {x=0,y=-0.15},parent = _self}
                Node.hover(_self)
                if _self.children.alert then 
                    _self.children.alert:remove()
                    _self.children.alert = nil
                    if self.key and AKYRS.Scenarios[self.key] then AKYRS.Scenarios[self.key].alerted = true end
                    G:save_progress()
                end
            end
        end
    end
    tag_sprite.stop_hover = function(_self) _self.hovering = false; Node.stop_hover(_self); _self.hover_tilt = 0 end

    tag_sprite:juice_up()
    self.tag_sprite = tag_sprite

    return tag_sprite_tab, tag_sprite
end

local colour_map = {
    yellowlight = G.C.AKYRS_AKYRS_SCENARIO_YELLOW,
    pinklight = G.C.AKYRS_AKYRS_SCENARIO_PINK,
    bluelight = G.C.AKYRS_AKYRS_SCENARIO_BLUE,
    yellowdark = G.C.AKYRS_AKYRS_SCENARIO_DARK_YELLOW,
    pinkdark = G.C.AKYRS_AKYRS_SCENARIO_DARK_PINK,
    bluedark = G.C.AKYRS_AKYRS_SCENARIO_DARK_BLUE,
}
local text_colour_map = {
    yellowlight = G.C.UI.TEXT_DARK,
    pinklight = G.C.UI.TEXT_LIGHT,
    bluelight = G.C.UI.TEXT_LIGHT,
    yellowdark = G.C.UI.TEXT_LIGHT,
    pinkdark = G.C.UI.TEXT_LIGHT,
    bluedark = G.C.UI.TEXT_LIGHT,
}

function AKYRS.Scenario_Tag:get_uibox_table(tag_sprite)
    tag_sprite = tag_sprite or self.tag_sprite
    
    local name_to_check, loc_vars = self.name, {}
    local info_q = {}
    local bgs = {}
    if AKYRS.Scenarios[self.key].loc_vars then loc_vars = AKYRS.Scenarios[self.key]:loc_vars(info_q,self) end
    local cntr = { key = loc_vars.key or self.key, set = 'Scenario', vars = loc_vars.vars }
    tag_sprite.ability_UIBox_table = generate_card_ui(cntr, nil, loc_vars.vars, (self.hide_ability) and 'Undiscovered' or 'Scenario', bgs, (self.hide_ability), loc_vars.main_start, loc_vars.main_end, self)
    local info_vars = {
        self.akyrs_rounds_left,
        self.akyrs_total_rounds, 
        localize(self.scenario.side, "akyrs_colour"),
        localize(self.scenario.colour, "akyrs_colour"), 
        colours = {
            colour_map[self.scenario.colour..(self.scenario.side or "dark")],
            text_colour_map[self.scenario.colour..(self.scenario.side or "dark")],
        }
    }
    generate_card_ui(AKYRS.DescriptionDummies["dd_akyrs_scenario_tooltip"], tag_sprite.ability_UIBox_table, info_vars)
    for _, iq in ipairs(info_q) do
        generate_card_ui(iq, tag_sprite.ability_UIBox_table)
    end
    --print(tag_sprite.ability_UIBox_table)
    tag_sprite.ability_UIBox_table.badges = tag_sprite.ability_UIBox_table.badges or {}
    tag_sprite.ability_UIBox_table.badges.card_type = "Scenario"
    tag_sprite.config.center = self.config
    tag_sprite.ability = self.ability

    return tag_sprite
end

function AKYRS.Scenario_Tag:remove_from_game()
    if self.tag_removed then
        self:tag_removed()
    end
    local tag_key = nil
    
    for k, v in pairs(G.GAME.akyrs_scenario) do
        if v == self then tag_key = k end
    end
    table.remove(G.GAME.akyrs_scenario, tag_key)
end

function AKYRS.Scenario_Tag:remove()
    self:remove_from_game()
    local HUD_tag_key = nil
    for k, v in pairs(G.AKYRS_SCENARIO_TAG_HUD) do
        if v == self.HUD_tag then HUD_tag_key = k end
    end

    if HUD_tag_key then 
        if G.AKYRS_SCENARIO_TAG_HUD and G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key+1] then
            if HUD_tag_key == 1 then
                G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key+1]:set_alignment({type = 'bli',
                offset = offset,
                xy_bond = 'Weak',
                role_type = 'Minor', 
                major = G.ROOM_ATTACH})
            else
                G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key+1]:set_role({
                offset = offset_each,
                xy_bond = 'Weak',
                major = G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key-1]})
            end
        end
        table.remove(G.AKYRS_SCENARIO_TAG_HUD, HUD_tag_key)
    end

    self.HUD_tag:remove()
end

function AKYRS.Scenario_Tag:calculate(context)
    local obj = AKYRS.Scenarios[self.key]
    if type(obj.calculate) == 'function' then
        return obj:calculate(self, context)
    end
end


SMODS.UndiscoveredSprite{
    key = "Scenario",
    atlas = "undiscoveredScenario",
    pos = { x = 0, y = 0 }
}

SMODS.UndiscoveredCompat["Scenario"] = true

G.C.SECONDARY_SET.Scenario = HEX("645474FF")
---@type SMODS.Center
AKYRS.Scenario = SMODS.Center:extend{
    required_params = {
        "key",
        "scenario",
    },
    scenario = {
        colour = "?",
        side = "?",
    },
    class_prefix = "sc",
    set = "Scenario",
    calculate = function (self, card, context)
    end,
    atlas = "akyrs_scenarioTags",
    obj_table = AKYRS.Scenarios,
    obj_buffer = AKYRS.Scenarios_Buffer,
    atlas = "akyrs_scenarioCards",
    tag_atlas = "akyrs_scenarioTags",
    badge_colour = HEX("645474FF"),
    pos = { x = j, y = i },
    inject = function(self) 
        
        G.P_CENTER_POOLS.Scenario = G.P_CENTER_POOLS.Scenario or {}
        self.config.consumeable = {}
        G.P_CENTER_POOLS.Scenario[#G.P_CENTER_POOLS.Scenario+1] = self
        G.P_CENTERS[self.key] = self
    end,
    discovered = false,
    config = {

    },
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local newkey = self.key
        if self.akyrs_scenario_random then
            newkey = SMODS.poll_object{ pool = AKYRS.Scenarios_Buffer, filter = function(pool)
                return AKYRS.filter_table(pool,function(obj) 
                    local obj_tbl = self.obj_table[obj]
                    local cm, sc = obj_tbl.scenario, self.scenario
                    return cm.colour == sc.colour and (cm.side == sc.side or self.akyrs_scenario_random) and not obj_tbl.akyrs_scenario_random and not obj_tbl.akyrs_clean_scenario
                end,true,true)
            end, seed = "akyrs_scenario_"..(self.scenario or {colour = "?"}).colour}
        end
        local newobj = AKYRS.Scenarios[newkey]
        AKYRS.remove_scenarios(function (cd)
            if AKYRS.Scenarios[cd.key] then
                local sc, cm = AKYRS.Scenarios[cd.key].scenario, newobj.scenario
                return (cm.side == sc.side) and cm.colour == sc.colour
            end
            return false
        end)
        if not self.akyrs_clean_scenario then
            local scnrtag = AKYRS.Scenario_Tag(newobj.key)
            if not self.akyrs_scenario_random then
                for k, v in pairs(scnrtag.ability) do
                    scnrtag.ability[k] = card.ability[k]
                end
            end
            AKYRS.add_scenario_tag(scnrtag)
            if self.use_extras then
                self:use_extras(card, area, copier, scnrtag)
            end
        end
    end
}



function AKYRS.add_scenario_tag(_tag)
  G.AKYRS_SCENARIO_TAG_HUD = G.AKYRS_SCENARIO_TAG_HUD or {}
  local z = 10 + #G.AKYRS_SCENARIO_TAG_HUD * 0.001
  local tag_sprite_ui = _tag:generate_UI(nil, z)
  ---@type UIBox
  G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD+1] = UIBox{
      definition = {n=G.UIT.ROOT, config={align = "cm",padding = 0.0, colour = G.C.CLEAR}, nodes={
        tag_sprite_ui
      }},
      config = {
        instance_type = "ABOVE_UIBOX",
        align = G.AKYRS_SCENARIO_TAG_HUD[1] and 'rc' or 'bli',
        offset = G.AKYRS_SCENARIO_TAG_HUD[1] and offset_each or offset,
        role_type = (not G.AKYRS_SCENARIO_TAG_HUD[1]) and 'Minor' or nil, 
        major = G.AKYRS_SCENARIO_TAG_HUD[1] and G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD] or G.ROOM_ATTACH}
  }
  G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD].role.major.T.z = z
  discover_card(AKYRS.Scenarios[_tag.key])

  G.GAME.akyrs_scenario[#G.GAME.akyrs_scenario+1] = _tag
  if not _tag.from_load then 
    SMODS.calculate_context({akyrs_scenario_applied = _tag}) 
    if _tag.tag_added then
        _tag:tag_added()
    end
   end
  _tag.from_load = nil
  G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD].is_scenario_tag = true
  _tag.HUD_tag = G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD]
  _tag.HUD_tag_sprites = tag_sprite_ui
end

function AKYRS.remove_scenarios(func)
    local strm = AKYRS.filter_table(G.GAME.akyrs_scenario, func ,true,true)
    AKYRS.filter_table(strm, function (x)
        return x:remove()
    end ,true,true)
end

function AKYRS.is_scenario_active(key)
    return (next(AKYRS.filter_table(G.GAME.akyrs_scenario, function (x)
        return x.key == key
    end, true, true)) or next(SMODS.find_card(key))) and true or false
end




--[[
SMODS.ConsumableType{
    key = "Scenario",
    primary_colour = HEX("5D8956FF"),
    secondary_colour = HEX("FF5887BD"),
    collection_rows = { 5,5,5 },
    shop_rate = 0,
    default = "c_akyrs_replicant_music_streaming"
}]]

AKYRS.Scenario {
    key = "genesis",
    set = "Scenario",
    pos = { x = 0, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    akyrs_clean_scenario = true
}
AKYRS.Scenario {
    key = "day",
    set = "Scenario",
    pos = { x = 1, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
            mult = 10
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.mult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                mult = card.ability.extras.mult
            }
        end
    end
}
AKYRS.Scenario {
    key = "night",
    set = "Scenario",
    pos = { x = 2, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
            chips = 25
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.chips
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                chips = card.ability.extras.chips
            }
        end
    end
}
AKYRS.Scenario {
    key = "sunrise",
    set = "Scenario",
    pos = { x = 3, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
            xmult = 1.3
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end
}
AKYRS.Scenario {
    key = "sunset",
    set = "Scenario",
    pos = { x = 4, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
            dollars = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.dollars)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                dollars = card.ability.extras.dollars
            }
        end
    end
}
AKYRS.Scenario {
    key = "high_noon",
    set = "Scenario",
    pos = { x = 5, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    calculate = function (self, card, context)
        if context.setting_blind then
            return {
                func = function ()
                    if AKYRS.has_room(G.jokers) then
                        SMODS.add_card{ set = "Joker" }
                    end
                end
            }
        end
    end
}
AKYRS.Scenario {
    key = "eclipse",
    set = "Scenario",
    pos = { x = 6, y = 0 },
    scenario = {
        colour = "yellow",
        side = "light",
    },
    config = {
        extras = {
            xblindsize = 0.95
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xblindsize
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                xblindsize = card.ability.extras.xblindsize
            }
        end
    end
}
AKYRS.Scenario {
    key = "yellow_hatena",
    set = "Scenario",
    pos = { x = 7, y = 0 },
    scenario = {
        colour = "yellow",
    },
    akyrs_scenario_random = true
}

AKYRS.Scenario {
    key = "clear",
    set = "Scenario",
    pos = { x = 8, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    akyrs_clean_scenario = true,
}
AKYRS.Scenario {
    key = "cloudy",
    set = "Scenario",
    pos = { x = 9, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    akyrs_total_rounds = 2,
    config = {
        extras = {
            dollars = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.dollars)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then 
            return {
                dollars = card.ability.extras.dollars
            }
        end
    end,
}

AKYRS.Scenario {
    key = "rain",
    set = "Scenario",
    pos = { x = 10, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    config = {
        extras = {
            discards = 3,
            hand_size = -1,
            hand_size_taken = 0
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.discards),
                SMODS.signed(card.ability.extras.hand_size),
                SMODS.signed(card.ability.extras.hand_size_taken),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                func = function ()
                    ease_discard(card.ability.extras.discards)
                    G.hand:change_size(card.ability.extras.hand_size)
                    card.ability.extras.hand_size_taken = card.ability.extras.hand_size_taken + card.ability.extras.hand_size
                end
            }
        end
        if context.end_of_round and context.main_eval then
            return {
                func = function ()
                    G.hand:change_size(-card.ability.extras.hand_size_taken)
                    card.ability.extras.hand_size_taken = 0
                end
            }
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        G.hand:change_size(-card.ability.extras.hand_size_taken)
    end,
    use_extras = function(self, card, area, copier, tag)
    end,
    tag_added = function (self, tag)
        G.hand:change_size(card.ability.extras.hand_size_taken)
    end,
    tag_removed = function (self, tag)
        G.hand:change_size(-card.ability.extras.hand_size_taken)
    end,
}

AKYRS.Scenario {
    key = "snow",
    set = "Scenario",
    pos = { x = 11, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    config = {
        extras = {
            xchips = 3,
            hand_ease_down = -1
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.ability.extras.xchips),
                SMODS.signed(card.ability.extras.hand_ease_down),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then 
            return {
                xchips = card.ability.extras.xchips,
                func = function ()
                    ease_hands_played(card.ability.extras.hand_ease_down)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "hail",
    set = "Scenario",
    pos = { x = 12, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    config = {
        extras = {
            chips = 62.5,
            xchips = 0.8
        }
    },
    akyrs_total_rounds = 5,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.chips),
                (card.ability.extras.xchips),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play then 
            return {
                chips = card.ability.extras.chips,
                xchips = card.ability.extras.xchips,
            }
        end
    end,
}

AKYRS.Scenario {
    key = "thunder",
    set = "Scenario",
    pos = { x = 13, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    config = {
        extras = {
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['e_akyrs_charged']
        info_queue[#info_queue+1] = G.P_CENTERS['m_akyrs_zap_card']
        return {
            vars = {
                SMODS.signed(card.ability.extras.chips),
                (card.ability.extras.xchips),
            }
        }
    end,
    calculate = function (self, card, context)
        if context.before then 
            return {
                func = function ()
                    local cardy = pseudorandom_element(G.hand.cards, "akyrs_thunder_pick")
                    local cds = { cardy }
                    AKYRS.do_things_to_card(cds, function (cd, index)
                        cd:set_ability(G.P_CENTERS['m_akyrs_zap_card'])
                        cd:set_edition({ akyrs_charged = true }, true)
                    end)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "tornado",
    set = "Scenario",
    pos = { x = 14, y = 0 },
    scenario = {
        colour = "yellow",
        side = "dark",
    },
    config = {
        extras = {
            hands = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.hands)
            }
        }
    end,
    akyrs_total_rounds = 2,
    calculate = function (self, card, context)
        if context.setting_blind then
            return {
                func = function ()
                    ease_hands_played(card.ability.extras.hands)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "void",
    set = "Scenario",
    pos = { x = 0, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    akyrs_clean_scenario = true
}

AKYRS.Scenario {
    key = "plains",
    set = "Scenario",
    pos = { x = 1, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            xmult = 1.2,
            xchips = 1.3,
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return {
            vars = {
                card.ability.extras.xmult,
                card.ability.extras.xchips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card.config.center.key == "m_mult" then
                return {
                    xmult = card.ability.extras.xmult
                }
            end
            if context.other_card.config.center.key == "m_bonus" then
                return {
                    xchips = card.ability.extras.xchips
                }
            end
        end
    end,
}

AKYRS.Scenario {
    key = "forest",
    set = "Scenario",
    pos = { x = 1, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            xmult = 1.2,
            xchips = 1.3,
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return {
            vars = {
                card.ability.extras.xmult,
                card.ability.extras.xchips,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card.config.center.key == "m_mult" then
                return {
                    xmult = card.ability.extras.xmult
                }
            end
            if context.other_card.config.center.key == "m_bonus" then
                return {
                    xchips = card.ability.extras.xchips
                }
            end
        end
    end,
}