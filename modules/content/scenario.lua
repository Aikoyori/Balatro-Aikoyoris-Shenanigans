---@type table<string,AKYRS.Scenario>
AKYRS.Scenarios = {}
---@type AKYRS.Scenario[]
AKYRS.Scenarios_Buffer = {}


local offset = {x = 4.8,y = 0.5}
local offset_each = {x = -0.2,y = 0}
---@class AKYRS.Scenario_Tag: Object
---@field sc_config? AKYRS.Scenario_Tag
---@field key? string
---@field akyrs_total_rounds? number
---@field akyrs_rounds_left? number
AKYRS.Scenario_Tag = Object:extend()

-- honestly this is just tag code but modified because it works

---comment
---@param _scenario string
---@param for_collection boolean
---@param _blind_type any
function AKYRS.Scenario_Tag:init(_scenario, for_collection, _blind_type)
    self.key = _scenario
    local proto = AKYRS.Scenarios[_scenario]
    self.sc_config = copy_table(proto.config)
    self.config = proto
    self.scenario_tag = true
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

function AKYRS.Scenario_Tag:update(scaled_dt, real_dt)
    
end
function AKYRS.Scenario_Tag:juice_up(_scale, _rot)
    if self.tag_sprite then self.tag_sprite:juice_up(_scale, _rot) end
end

function AKYRS.get_scenario_wheel_progress_offset(sc_proto)
    if sc_proto.scenario and sc_proto.scenario.colour == "pink" then
        if sc_proto.scenario.side == "light" then
            return { 0, -0.41 }
        else
            return { 0, 0.21 }
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

AKYRS.sc_colour_map = {
    yellowlight = G.C.AKYRS_AKYRS_SCENARIO_YELLOW,
    pinklight = G.C.AKYRS_AKYRS_SCENARIO_PINK,
    bluelight = G.C.AKYRS_AKYRS_SCENARIO_BLUE,
    yellowdark = G.C.AKYRS_AKYRS_SCENARIO_DARK_YELLOW,
    pinkdark = G.C.AKYRS_AKYRS_SCENARIO_DARK_PINK,
    bluedark = G.C.AKYRS_AKYRS_SCENARIO_DARK_BLUE,
}
AKYRS.sc_text_colour_map = {
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
    local obj = AKYRS.Scenarios[self.key]
    if obj.loc_vars then loc_vars = obj:loc_vars(info_q,self) end
    local cntr = { key = loc_vars.key or self.key, set = 'Scenario', vars = loc_vars.vars }
    tag_sprite.ability_UIBox_table = generate_card_ui(obj, nil, loc_vars.vars, (self.hide_ability) and 'Undiscovered' or 'Scenario', bgs, (self.hide_ability), loc_vars.main_start, loc_vars.main_end, self)
    local info_vars = {
        self.akyrs_rounds_left or 4,
        self.akyrs_total_rounds or 4, 
        localize(self.scenario.side or "none", "akyrs_colour"),
        localize(self.scenario.colour or "none", "akyrs_colour"), 
        colours = {
            AKYRS.sc_colour_map[self.scenario.colour..(self.scenario.side or "dark")],
            AKYRS.sc_text_colour_map[self.scenario.colour..(self.scenario.side or "dark")],
        }
    }
    local multiboxone = {}
    tag_sprite.ability_UIBox_table.info = tag_sprite.ability_UIBox_table.info or {}
    localize{ type = "descriptions", set = "DescriptionDummy", vars = info_vars, key = 'dd_akyrs_scenario_tooltip'..(self.config.akyrs_timed_scenario and "_time" or ""), nodes = multiboxone }
    AKYRS.add_box_to_uitable(tag_sprite.ability_UIBox_table, multiboxone)
    if not obj.akyrs_no_decays then 
        local multiboxtwo = {}
        localize{ type = "descriptions", set = "DescriptionDummy", vars = info_vars, key = 'dd_akyrs_scenario_tag_charges_decreases', nodes = multiboxtwo } 
        AKYRS.add_box_to_uitable(tag_sprite.ability_UIBox_table, multiboxtwo)
    end
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
    if self.config and self.config.tag_removed then
        self.config:tag_removed(self)
    end
    local tag_key = nil
    
    for k, v in pairs(G.GAME.akyrs_scenario) do
        if v == self then tag_key = k end
    end
    SMODS.calculate_context({akyrs_scenario_tag_removed = self}) 
    table.remove(G.GAME.akyrs_scenario, tag_key)
end

function AKYRS.Scenario_Tag:remove()
    self:remove_from_game()
    self.removed = true
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

function AKYRS.get_random_scenario_key(colour, side, config)
    config = config or {}
    local any_colour = config.any_colour or nil
    local any_side = config.any_side or nil
    -- this is for if i need them
    local pick_randoms = config.pick_randoms or nil
    local pick_cleans = config.pick_cleans or nil
    local seed = config.seed or ("akyrs_scenario" .. (colour and ("_"..colour) or "") .. (side and ("_"..side) or ""))

    newkey = SMODS.poll_object{ pool = AKYRS.Scenarios_Buffer, filter = function(pool)
        return AKYRS.filter_table(pool,function(obj) 
            local obj_tbl = AKYRS.Scenarios[obj]
            local cm = obj_tbl.scenario
            return (any_colour or colour == cm.colour) and (any_side or side == cm.side) and (not obj_tbl.akyrs_scenario_random or pick_randoms) and (not obj_tbl.akyrs_clean_scenario or pick_cleans)
        end,true,true)
    end, seed = seed}
    return newkey
end


SMODS.UndiscoveredSprite{
    key = "Scenario",
    atlas = "undiscoveredScenario",
    pos = { x = 0, y = 0 }
}

SMODS.UndiscoveredCompat["Scenario"] = true

G.C.SECONDARY_SET.Scenario = HEX("645474FF")
---@class AKYRS.Scenario: SMODS.Center
---@field tag_added? fun(self: AKYRS.Scenario|table, _tag:AKYRS.Scenario_Tag, card_source: Card): nil m
---@field pre_new_tag? fun(self: AKYRS.Scenario|table, card:Card, area:CardArea, copier:Card ): nil
---@field use_extras? fun(self: AKYRS.Scenario|table, card:Card, area:CardArea, copier:Card, tag:AKYRS.Scenario_Tag | nil ): nil
---@field tag_removed? fun(self: AKYRS.Scenario|table, _tag:AKYRS.Scenario_Tag): nil
---@field tag_expire? fun(self: AKYRS.Scenario|table, _tag:AKYRS.Scenario_Tag): nil
---@field tag_update? fun(self: AKYRS.Scenario|table, tag:AKYRS.Scenario_Tag, dt: number, real_dt:number): nil
---@overload fun(self: AKYRS.Scenario): AKYRS.Scenario
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
    get_total_rounds = function (self, instance) 
        if self.akyrs_clean_scenario or self.akyrs_scenario_random then return "???" end
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local newkey = self.key
        if self.akyrs_scenario_random then
            newkey = AKYRS.get_random_scenario_key(self.scenario.colour, nil, { any_side = true })
        end
        local newobj = AKYRS.Scenarios[newkey]

        if self.pre_new_tag then
            self:pre_new_tag(card, area, copier)
        end
        AKYRS.remove_scenarios(function (cd)
            if AKYRS.Scenarios[cd.key] then
                local sc, cm = AKYRS.Scenarios[cd.key].scenario, newobj.scenario
                return (cm.side == sc.side) and cm.colour == sc.colour
            end
            return false
        end)
        local scnrtag
        if not self.akyrs_clean_scenario then
            scnrtag = AKYRS.Scenario_Tag(newobj.key)
            if not self.akyrs_scenario_random then
                for k, v in pairs(scnrtag.ability) do
                    scnrtag.ability[k] = card.ability[k]
                end
            end
            AKYRS.add_scenario_tag(scnrtag)
        end
        if self.use_extras then
            self:use_extras(card, area, copier, scnrtag)
        end
    end
}



function AKYRS.add_scenario_tag(_tag, card_source)
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
    local tagobj = AKYRS.Scenarios[_tag.key]
    G.GAME.akyrs_scenario[#G.GAME.akyrs_scenario+1] = _tag
    if not _tag.from_load then 
        SMODS.calculate_context({akyrs_scenario_tag_applied = _tag}) 
        if tagobj.tag_added then
            tagobj:tag_added(_tag, card_source)
        end
    else
        _tag.akyrs_previous_left_number = _tag.akyrs_rounds_left + 1
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

function AKYRS.is_scenario_tag_active(key)
    return (next(AKYRS.filter_table(G.GAME.akyrs_scenario, function (x)
        return x.key == key
    end, true, true)))
end

function AKYRS.is_scenario_type_active(scenario_config, ignore_side, ignore_colour)
    if not scenario_config or not scenario_config then return end
    local sc = AKYRS.filter_table(G.GAME.akyrs_scenario, function (sc)
        return (ignore_side or sc.config.scenario.side == scenario_config.side) and (ignore_colour or sc.config.scenario.colour == scenario_config.colour)
    end, true, true)
    return #sc > 0, sc
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
    config = {
        extras = {
            dollars = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.dollars)
            }
        }
    end,
    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier, tag)
        if AKYRS.is_scenario_type_active(self.scenario) then
            ease_dollars(card.ability.extras.dollars)
        end
    end
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
            chips = 75
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
            xblindsize = 0.9
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
    config = {
        extras = {
            hand = 1,
            discards = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.hand),
                SMODS.signed(card.ability.extras.discards),
            }
        }
    end,
    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier)
        if AKYRS.is_scenario_type_active(self.scenario) then
            ease_hands_played(card.ability.extras.hand)
            ease_discard(card.ability.extras.discards)
        end
    end
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
    tag_added = function (self, tag, card)
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
            chips = 112.5,
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
    config = {
        extras = {
            max_money = 30,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.max_money)
            }
        }
    end,

    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier)
        if AKYRS.is_scenario_type_active(self.scenario) then
            ease_dollars(math.max(0,math.min(G.GAME.dollars, card.ability.extras.max_money)))
        end
    end,
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
    pos = { x = 2, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_akyrs_canopy_card
        return {
            vars = {
            }
        }
    end,
    calculate = function (self, card, context)
        if context.repetition and context.other_card.config.center.key == "m_akyrs_canopy_card" and context.cardarea == G.play then
            return {
                repetitions = 1,
            }
        end
    end,
}

AKYRS.Scenario {
    key = "river",
    set = "Scenario",
    pos = { x = 3, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            dsc = 1
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.dsc)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.pre_discard and not context.hook and G.GAME.current_round.hands_left == 1 then
            return {
                func = function()
                    ease_discard(card.ability.extras.dsc, true)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "river",
    set = "Scenario",
    pos = { x = 3, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            dsc = 1
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.dsc)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.pre_discard and not context.hook and G.GAME.current_round.hands_left == 1 then
            return {
                func = function()
                    ease_discard(card.ability.extras.dsc, true)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "desert",
    set = "Scenario",
    pos = { x = 4, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            dollars = 16,
        }
    },
    akyrs_total_rounds = 4,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.dollars)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.pre_discard and not context.hook then
            return {
                func = function()
                    if card.ability.extras.dollars <= 1 then
                        if card.is and card:is(Card) and card.shatter then
                            card:shatter()
                        else
                            card:remove()
                        end
                    end
                    card.ability.extras.dollars = card.ability.extras.dollars / 2
                end,
                message = localize("k_akyrs_downgrade_ex")
            }
        end
        if context.modify_final_cashout then
            return {
                modify = card.ability.extras.dollars,
                cashout_row = { 
                    name = 'custom_akyrs_desert', 
                    pitch = 0.95,
                    bonus = true,
                    text_scale = 0.5,
                    text = localize("k_akyrs_desert_money"),
                    text_colour = G.C.AKYRS_AKYRS_SCENARIO_PINK,
                }
            }
        end
    end,
}

AKYRS.Scenario {
    key = "city",
    set = "Scenario",
    pos = { x = 5, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
            }
        }
    end,
    calculate = function (self, card, context)
        if context.repetition and context.other_card.area and AKYRS.is_in_playing_card_area(context.other_card.area) and context.cardarea == context.other_card.area then
            local cdx = context.other_card
            local repetitions = 0
            local i = AKYRS.find_index(cdx.area.cards, cdx)
            local left, rght = i > 1 and cdx.area.cards[i - 1], i < #cdx.area.cards and cdx.area.cards[i + 1]
            repetitions = repetitions + (left and left.config and left.config.center and left.config.center.key == "m_stone" and 1 or 0)
                                      + (rght and rght.config and rght.config.center and rght.config.center.key == "m_stone" and 1 or 0)
            if repetitions > 0 then
                return {
                    repetitions = repetitions
                }
            end
        end
    end,
}

AKYRS.Scenario {
    key = "underground",
    set = "Scenario",
    pos = { x = 6, y = 1 },
    scenario = {
        colour = "pink",
        side = "light",
    },
    config = {
        extras = {
            xmult = 1.5,
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.ability.extras.xmult)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == 'unscored' then
            return {
                xmult = card.ability.extras.xmult
            }
        end
    end,
}

AKYRS.Scenario {
    key = "pink_hatena",
    set = "Scenario",
    pos = { x = 7, y = 1 },
    scenario = {
        colour = "pink",
    },
    akyrs_scenario_random = true,
}
AKYRS.Scenario {
    key = "clean",
    set = "Scenario",
    pos = { x = 8, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            upgrades = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.upgrades
            }
        }
    end,
    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier)
        if AKYRS.is_scenario_type_active(self.scenario) then
            local _, mpph = AKYRS.get_most_played()
            if mpph then
                SMODS.upgrade_poker_hands {
                    hands = {mpph},
                    level_up = card.ability.extras.upgrades
                }
            end
        end
    end
}
AKYRS.Scenario {
    key = "purified",
    set = "Scenario",
    pos = { x = 9, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_pure_cards_tip"]
        return {
            vars = {
            }
        }
    end,
    calculate = function (self, card, context)
        if context.akyrs_postdraw_to_play and context.card_index == 1 and not context.postdraw_card.ability.akyrs_special_card_type then
            return {
                func = function() AKYRS.pure_card_split(context.postdraw_card, nil, nil, G.play) end
            }
        end
        if context.repetition and context.other_card.ability.akyrs_special_card_type and context.cardarea == context.other_card.area then
            return {
                repetitions = 1,
            }
        end
    end,
}

AKYRS.Scenario {
    key = "dusty",
    set = "Scenario",
    pos = { x = 10, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            xmult = 1.67,
        }
    },
    akyrs_total_rounds = 5,
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
                func = function() 
                    for _, tg in ipairs(G.GAME.tags) do
                        SMODS.calculate_effect({
                            xmult = card.ability.extras.xmult,
                            juice_card = tg.HUD_tag,
                        }, card)
                    end
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "leaves",
    set = "Scenario",
    pos = { x = 11, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            carbon = 1,
            dioxide = 3,
        }
    },
    akyrs_total_rounds = 2,
    loc_vars = function (self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card,card.ability.extras.carbon,card.ability.extras.dioxide, "akyrs_scenario_leaves_retrigger")
        return {
            vars = {
                n,
                d,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.debuff_card and context.debuff_card.seal then
            return {
                debuff = true
            }
        end
        if context.repetition and context.cardarea == context.other_card.area and not context.other_card.seal then 
            if SMODS.pseudorandom_probability(card, "akyrs_scenario_leaves_retrigger", card.ability.extras.carbon,card.ability.extras.dioxide) then
                return {
                    repetitions = 1
                }
            end
        end
    end,
}

AKYRS.Scenario {
    key = "foggy",
    set = "Scenario",
    pos = { x = 12, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            xscore_low_bound = 0.8,
            xscore_hi_bound = 2.5,
        }
    },
    akyrs_total_rounds = 5,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xscore_low_bound,
                card.ability.extras.xscore_hi_bound,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then 
            return {
                xscore = (pseudorandom("akyrs_scenarios_foggy_xscore") * (card.ability.extras.xscore_hi_bound - card.ability.extras.xscore_low_bound) + card.ability.extras.xscore_low_bound)
            }
        end
    end,
}

AKYRS.Scenario {
    key = "smoke",
    set = "Scenario",
    pos = { x = 13, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            xscore = 2,
            xmult_decrease = 0.75,
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xscore,
                card.ability.extras.xmult_decrease,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then 
            return {
                func = function ()
                    local c = 0
                    while SMODS.calculate_round_score() >= G.GAME.blind.chips and c < 100 do
                        SMODS.calculate_effect({
                            xmult = card.ability.extras.xmult_decrease,
                            xscore = card.ability.extras.xscore,
                        }, card)
                        c = c + 1
                    end
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "smog",
    set = "Scenario",
    pos = { x = 14, y = 1 },
    scenario = {
        colour = "pink",
        side = "dark",
    },
    config = {
        extras = {
            xbl_min = 0.5,
            xbl_max = 0.9,
        }
    },
    akyrs_total_rounds = 3,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xbl_min,
                card.ability.extras.xbl_max,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.setting_blind then 
            return {
                xblindsize = pseudorandom("akyrs_scenario_smoke_blind_size") * (card.ability.extras.xbl_max - card.ability.extras.xbl_min) + card.ability.extras.xbl_min,
                remove_default_message = true,
                message = localize({ type = "variable", key = "a_xblind_size", vars = {"???"}}),
                colour = G.C.DYN_UI.DARK,
                sound_override = 'xblindsize',
                message_card = card.HUG_tag or card
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        recalculateBlindUI()
    end,
    remove_from_deck = function (self, card, from_debuff)
        recalculateBlindUI()
    end,
    tag_removed = function (self, tag)
        recalculateBlindUI()
    end
}

AKYRS.Scenario {
    key = "neutral",
    set = "Scenario",
    pos = { x = 0, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            tags = 3
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.tags,
            }
        }
    end,
    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier)
        if AKYRS.is_scenario_type_active(self.scenario) then
            for i = 1, card.ability.extras.tags do
                AKYRS.simple_event_add(function ()
                    local tag_key = SMODS.poll_object{ type = 'Tag', seed = "akyrs_scenario_neutral_random_tag" }
                    add_tag(Tag(tag_key))
                    return true
                end, 0.5)
            end
        end
    end,
}

AKYRS.Scenario {
    key = "happy",
    set = "Scenario",
    pos = { x = 1, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            chips = 15,
            chips_g = 5,
            rounds_gain = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. (AKYRS.should_calculate_word() and "_letter" or ""), 
            vars = {
                SMODS.signed(card.ability.extras.chips),
                SMODS.signed(card.ability.extras.chips_g),
                card.ability.extras.rounds_gain,
            }
        }
    end,
    akyrs_total_rounds = 4,
    akyrs_rounds_left = 2,
    calculate = function (self, card, context)
        if context.main_scoring or context.joker_main then
            return {
                chips = card.ability.extras.chips
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 or ({ h = true, a = true })[context.other_card:get_letter_with_pretend(true) or ""] then
                return {
                    func = function ()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extras,
                            ref_value = "chips",
                            scalar_value = "chips_g",
                        })
                    end
                }
            end
            if (context.other_card:get_id() == 5 or ({ x = true, d = true })[context.other_card:get_letter_with_pretend(true) or ""]) and AKYRS.is_scenario_tag(card) then
                return {
                    func = function ()
                        AKYRS.mod_scenario_rounds(card, card.ability.extras.rounds_gain, nil, nil, true)
                    end,
                    message = localize("k_upgrade_ex"),
                }
            end
        end
    end,
}

AKYRS.Scenario {
    key = "sad",
    set = "Scenario",
    pos = { x = 2, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            mult = 5,
            mult_g = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. (AKYRS.should_calculate_word() and "_letter" or ""), 
            vars = {
                SMODS.signed(card.ability.extras.mult),
                SMODS.signed(card.ability.extras.mult_g),
            }
        }
    end,
    akyrs_total_rounds = 30,
    akyrs_rounds_left = 15,
    akyrs_no_decays = true,
    calculate = function (self, card, context)
        if context.before then
            return {
                func = function ()
                    SMODS.scale_card(card,{
                        ref_table = card.ability.extras,
                        ref_value = "mult",
                        scalar_value = "mult_g",
                        scalar_factor = #context.scoring_hand
                    })
                end
            }
        end
        if context.main_scoring or context.joker_main then
            return {
                mult = card.ability.extras.mult,
            }
        end
        if context.discard then
            return {
                func = function ()
                    AKYRS.mod_scenario_rounds(card, 1, nil, true)
                end
            }
        end
        if context.akyrs_postdraw_to_play then
            return {
                func = function ()
                    AKYRS.mod_scenario_rounds(card, -2, nil, true)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "excited",
    set = "Scenario",
    pos = { x = 3, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            c_dollars = 2,
            t_p_dollars = 5,
            t_c_dollars = 1,
            xdollars = 0.25,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. (AKYRS.should_calculate_word() and "_letter" or ""), 
            vars = {
                SMODS.signed_dollars(card.ability.extras.c_dollars),
                SMODS.signed_dollars(card.ability.extras.t_p_dollars),
                SMODS.signed_dollars(card.ability.extras.t_c_dollars),
                (card.ability.extras.xdollars),
            }
        }
    end,
    akyrs_total_rounds = 30,
    akyrs_no_decays = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) and not card.removed then
            if context.main_scoring or context.joker_main then
                return {
                    func = function ()
                        AKYRS.simple_event_add(function ()
                            if not card.removed then
                                ease_dollars(card.ability.extras.t_p_dollars, true)
                                AKYRS.mod_scenario_rounds(card, -1, true, true)
                            end
                            return true
                        end, 0)
                    end
                }
            end
            if context.akyrs_postdraw_to_play then
                return {
                    func = function ()
                        AKYRS.simple_event_add(function ()
                            if not card.removed then
                                ease_dollars(card.ability.extras.t_c_dollars, true)
                                AKYRS.mod_scenario_rounds(card, -1, true, true)
                            end
                            return true
                        end, 0)
                    end
                }
            end
        else
            if context.end_of_round and context.main_eval then
                return {
                    dollars = card.ability.extras.c_dollars
                }
            end
        end
    end,
    tag_expire = function (self, tag)
        ease_dollars(- G.GAME.dollars + G.GAME.dollars * tag.ability.extras.xdollars, true)
    end
}

AKYRS.Scenario {
    key = "anger",
    set = "Scenario",
    pos = { x = 4, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            xmult = 16,
            xmult_multer = 0.5,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.ability.extras.xmult),
            }
        }
    end,
    akyrs_total_rounds = 50,
    akyrs_no_decays = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) and context.post_trigger then
            return {
                func = function ()
                    AKYRS.mod_scenario_rounds(card, -1, nil, true)
                end
            }
        end
        if context.joker_main or context.main_scoring then
            return {
                xmult = card.ability.extras.xmult,
                func = function ()
                end
            }
        end
        if context.after then
            if SMODS.last_hand_oneshot then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extras,
                    ref_value = 'xmult',
                    scalar_factor = 0.5,
                    operation = 'X',
                    scaling_message = { message = localize('k_akyrs_downgrade_ex') },
                })
            end
            return {
                func = function ()
                    AKYRS.simple_event_add(function()
                        if card.ability.extras.xmult <= 1 then
                            if AKYRS.is_scenario_tag(card) then 
                                card:remove()
                            else
                                SMODS.shatters(card)
                            end
                        end
                    return true 
                        
                    end, 0)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "surprise",
    set = "Scenario",
    pos = { x = 5, y = 2 },
    scenario = {
        colour = "blue",
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
    akyrs_total_rounds = 6,
    akyrs_no_decays = true,
    calculate = function (self, card, context)
        if context.akyrs_pre_pre_discard and not context.hook then
            return {
                func = function ()
                    AKYRS.NO_UNHIGHLIGHT = card

                    local consumable = SMODS.add_card{ set = 'Consumeables', seed = "akyrs_scenario_surprise", key = AKYRS.surprise_debug }
                    local sel = math.max(G.GAME.starting_params.discard_limit, G.GAME.starting_params.play_limit)


                    AKYRS.simple_event_add(function ()
                        if #G.hand.highlighted == 0 then
                            ---@type Card[]|nil
                            local random_so_no_crash = AKYRS.pseudorandom_elements(G.hand.cards, sel, "akyrs_scenario_surprise_anti_crash")
                            for _, rsnc in ipairs(random_so_no_crash) do
                                if rsnc.area and not rsnc.REMOVED and not rsnc.getting_sliced then
                                    rsnc.area:add_to_highlighted(rsnc)
                                end
                            end
                        end
                        return #G.hand.highlighted > 0 
                    end, 0)

                    G.FUNCS.use_card({ config = { ref_table = consumable, } })
                    AKYRS.simple_event_add(function ()
                        G.STATE_COMPLETE = false
                        return true
                    end, 0)
                    

                    if AKYRS.is_scenario_tag(card) then
                        AKYRS.mod_scenario_rounds(card, -1, nil, true)
                    end
                end
            }
        end
        if context.akyrs_post_discard and not context.hook then
            return {
                func = function ()
                    AKYRS.simple_event_add(function ()
                        AKYRS.remove_phantom_cards()
                        return true
                    end, 0)
                end
            }
        end
    end,
}

AKYRS.Scenario {
    key = "kyne",
    set = "Scenario",
    pos = { x = 6, y = 2 },
    scenario = {
        colour = "blue",
        side = "light",
    },
    config = {
        extras = {
            card_gain = 4,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.card_gain),
                card.akyrs_rounds_left and SMODS.signed_dollars(card.akyrs_rounds_left) or "$???",
            }
        }
    end,
    akyrs_total_rounds = 30,
    akyrs_no_decays = true,
    calculate = function (self, card, context)
        if context.money_altered then
            return {
                func = function ()
                    if context.amount < 0 then
                        AKYRS.mod_scenario_rounds(card, context.amount, nil, true)
                    end
                end
            }
        end
        if context.ending_shop then
            return {
                dollars = AKYRS.is_scenario_tag and card.akyrs_rounds_left or card.ability.extras.card_gain
            }
        end
    end,
}
AKYRS.Scenario {
    key = "blue_hatena",
    set = "Scenario",
    pos = { x = 7, y = 2 },
    scenario = {
        colour = "blue",
    },
    akyrs_scenario_random = true,
}
AKYRS.Scenario {
    key = "water",
    set = "Scenario",
    pos = { x = 8, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.seconds_gain),
                (card.ability.extras.rounds_held),
                (card.ability.extras.rounds_max),
            }
        }
    end,
    akyrs_clean_scenario = true,
    pre_new_tag = function (self, card, area, copier)
        if AKYRS.is_scenario_type_active(self.scenario) then
            SMODS.add_card{
                set = "Consumeable",
                edition = 'e_negative',
            }
        end
    end
}
AKYRS.Scenario {
    key = "snack",
    set = "Scenario",
    pos = { x = 9, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
            seconds_gain = 1,
            rounds_held = 0,
            rounds_max = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.seconds_gain),
                (card.ability.extras.rounds_held),
                (card.ability.extras.rounds_max),
            }
        }
    end,
    akyrs_total_rounds = 30,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
            if context.akyrs_postdraw_to_play then
                return {
                    func = function ()
                        AKYRS.mod_scenario_rounds(card, card.ability.extras.seconds_gain, nil, true)
                        SMODS.calculate_effect({                
                            message = localize{type='variable', key = "k_akyrs_seconds", vars = {card.ability.extras.seconds_gain}},
                        }, card)
                    end
                }
            end
            if context.end_of_round and not context.repetition and not context.individual then
                return {
                    func = function ()
                        AKYRS.simple_event_add(function ()
                            card.ability.extras.rounds_held = card.ability.extras.rounds_held + 1
                            if card.ability.extras.rounds_held >= card.ability.extras.rounds_max and AKYRS.has_room(G.jokers) then
                                card.ability.extras.rounds_held = card.ability.extras.rounds_held - card.ability.extras.rounds_max
                                SMODS.add_card{ set = "Joker", rarity = "Rare" }
                            end
                            return true
                        end)
                    end
                }
            end
        else
            if context.end_of_round and not context.repetition and not context.individual then
                return {
                    func = function ()
                        AKYRS.simple_event_add(function ()
                            if AKYRS.has_room(G.jokers) then
                                SMODS.add_card{ set = "Joker",}
                            end
                            return true
                        end)
                    end
                }
            end
        end
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if (G.SETTINGS.paused and not G.STATE == G.STATES.HAND_PLAYED) or AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}

AKYRS.Scenario {
    key = "dish",
    set = "Scenario",
    pos = { x = 10, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
            c_dollars = 2,
            t_dollars = 0,
            t_dollars_g = 2,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed_dollars(card.ability.extras.c_dollars),
                (card.ability.extras.t_dollars_g),
                SMODS.signed_dollars(card.ability.extras.t_dollars / 2),
                SMODS.signed_dollars(card.ability.extras.t_dollars),
            }
        }
    end,
    akyrs_total_rounds = 24,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
            if context.money_altered and context.from_shop then
                return {
                    func = function ()
                        if context.amount < 0 then
                                SMODS.scale_card(card,{
                                    ref_table = card.ability.extras,
                                    ref_value = "t_dollars",
                                    scalar_table = context,
                                    scalar_value = 'amount',
                                    scalar_factor = -1
                                })
                        end
                    end
                }
            end
            if context.ending_shop then
                return {
                    dollars = card.ability.extras.t_dollars / 2,
                    func = function ()
                        card.ability.extras.t_dollars = 0
                        card.akyrs_rounds_left = card.akyrs_total_rounds 
                        card.akyrs_previous_left_number = card.akyrs_rounds_left
                        SMODS.calculate_effect({                
                            message = localize("k_reset"),
                        }, card)
                    end
                }
            end
        else
            if context.ending_shop then
                return {
                    dollars = card.ability.extras.c_dollars,
                }
            end
        end
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if G.shop and AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}

AKYRS.Scenario {
    key = "meal",
    set = "Scenario",
    pos = { x = 11, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
            c_bpc = 1,
            t_bpsz = 3,
            t_bpch = 1,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.extras.c_bpc),
                SMODS.signed(card.ability.extras.t_bpsz),
                SMODS.signed(card.ability.extras.t_bpch),
            }
        }
    end,
    akyrs_total_rounds = 5,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
            if context.skipping_booster then
                return {
                    func = function ()
                        card.akyrs_rounds_left = card.akyrs_total_rounds 
                        card.akyrs_previous_left_number = card.akyrs_rounds_left
                        SMODS.calculate_effect({                
                            message = localize("k_reset"),
                        }, card)
                    end
                }
            end
        else
            
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) + card.ability.extras.c_bpc
    end,
    remove_from_deck = function (self, card, area, copier, tag)
        G.GAME.modifiers.extra_boosters = (G.GAME.modifiers.extra_boosters or 0) - card.ability.extras.c_bpc
    end,
    tag_added = function (self, _tag, card_source)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + _tag.ability.extras.t_bpsz
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + _tag.ability.extras.t_bpch
    end,
    tag_removed = function (self, _tag)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - _tag.ability.extras.t_bpsz
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - _tag.ability.extras.t_bpch
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 and AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}

AKYRS.Scenario {
    key = "buffet",
    set = "Scenario",
    pos = { x = 12, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        card_limit = 2,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                SMODS.signed(card.ability.card_limit)
            }
        }
    end,
    akyrs_total_rounds = 15,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
            if context.modify_shop_card then
                return {
                    func = function ()
                        AKYRS.simple_event_add(function() 
                            context.card.ability.couponed = true
                            context.card:set_cost()
                        return true end, 0)
                    end
                }
            end
            if context.starting_shop then
                return {
                    func = function ()
                        G.GAME.current_round.reroll_cost = 0
                        AKYRS.simple_event_add(function() 
                            if G.shop_jokers and G.shop_jokers.cards and G.shop_booster and G.shop_booster.cards then 
                                for k, v in pairs(G.shop_jokers.cards) do
                                    v.ability.couponed = true
                                    v:set_cost()
                                end
                                for k, v in pairs(G.shop_booster.cards) do
                                    v.ability.couponed = true
                                    v:set_cost()
                                end
                                return true
                            end
                            return true
                        end, 0)
                    end
                }
                
            end
            if context.buying_card or context.open_booster then
                card.ability.akyrs_shop_purchased = true
            end
            if context.selling_card and G.STATE == G.STATES.SHOP then
                return {
                    func = function ()
                        AKYRS.mod_scenario_rounds(card, -card.akyrs_rounds_left, nil, nil, true)
                    end
                }
            end
            if context.ending_shop then
                if not card.ability.akyrs_shop_purchased then
                    card.ability.akyrs_shop_purchased = false
                    return {
                        func = function ()
                            card.akyrs_rounds_left = card.akyrs_total_rounds 
                            card.akyrs_previous_left_number = card.akyrs_rounds_left
                            SMODS.calculate_effect({                
                                message = localize("k_reset"),
                            }, card)
                        end
                    }
                end
                card.ability.akyrs_shop_purchased = false
            end
        else
            
        end
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if ((G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 ) or G.STATE == G.STATES.SHOP) and AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}

AKYRS.Scenario {
    key = "mushroom",
    set = "Scenario",
    pos = { x = 13, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
            tally = 0,
            dollars = 18,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.ability.extras.dollars),
                (card.ability.extras.tally),
            }
        }
    end,
    akyrs_total_rounds = 30,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
            if context.money_altered then
                return {
                    func = function ()
                        card.ability.extras.tally = card.ability.extras.tally + math.abs(context.amount)
                        if card.ability.extras.tally >= card.ability.extras.dollars and G.STATE == G.STATES.SHOP then
                            local q, r = math.floor(card.ability.extras.tally / card.ability.extras.dollars), (card.ability.extras.tally % card.ability.extras.dollars)
                            card.ability.extras.tally = r
                            for i = 1, AKYRS.to_num(q) do
                                AKYRS.simple_event_add(function() 
                                    local bp = SMODS.add_card{ set = "Booster", area = G.shop_booster }
                                    create_shop_card_ui(bp, 'Booster', G.shop_booster)
                                    bp.ability.couponed = true
                                    bp:set_cost()
                                    return true
                                end, 0)
                            end
                        end

                    end
                }
            end
            if context.open_booster then
                return {
                    func = function ()
                        card.akyrs_rounds_left = card.akyrs_total_rounds 
                        card.akyrs_previous_left_number = card.akyrs_rounds_left
                        SMODS.calculate_effect({                
                            message = localize("k_reset"),
                        }, card)
                    end
                }
            end
        else
            if context.akyrs_pre_play then
                return {
                    func = function ()
                        local ench = SMODS.poll_object{type = "Enhanced", seed = "akyrs_mushroom_card_enhance"}
                        local card_to_enh = pseudorandom_element(context.akyrs_pre_play_held,"akyrs_mushroom_card_pick")
                        if card_to_enh and ench then
                            AKYRS.do_things_to_card({card_to_enh}, function (cx, index)
                                cx:set_ability(G.P_CENTERS[ench])
                            end)
                        end
                    end
                }
            end
            
        end
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if (G.SETTINGS.paused and not G.STATE == G.STATES.HAND_PLAYED) or AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}

AKYRS.Scenario {
    key = "sos",
    set = "Scenario",
    pos = { x = 14, y = 2 },
    scenario = {
        colour = "blue",
        side = "dark",
    },
    config = {
        extras = {
            
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.ability.extras.dollars),
                (card.ability.extras.tally),
            }
        }
    end,
    akyrs_total_rounds = 800,
    akyrs_no_decays = true,
    akyrs_timed_scenario = true,
    calculate = function (self, card, context)
        if AKYRS.is_scenario_tag(card) then
        else
        end
    end,
    tag_update = function (self, tag, dt, real_dt) 
        if (G.SETTINGS.paused and not G.STATE == G.STATES.HAND_PLAYED) or AKYRS.should_tick_down() then
            AKYRS.mod_scenario_rounds(tag, -real_dt, true, nil, true)
        end
    end,
}