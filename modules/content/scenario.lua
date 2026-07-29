AKYRS.Scenarios = {}
AKYRS.Scenarios_Buffer = {}

local offset = {x = 4.8,y = 0.5}
local offset_each = {x = 0.2,y = 0}

AKYRS.Scenario_Tag = Object:extend()

-- honestly this is just tag code but modified because it works

function AKYRS.Scenario_Tag:init(_scenario, for_collection, _blind_type)
    self.key = _scenario
    local proto = AKYRS.Scenarios[_scenario]
    self.config = copy_table(proto.config)
    self.pos = proto.pos
    self.name = proto.name
    self.akyrs_scenario_tally = G.GAME.akyrs_scenario_tally or 0
    self.triggered = false
    G.akyrs_scenario_id = G.akyrs_scenario_id or 0
    self.ID = G.akyrs_scenario_id
    G.akyrs_scenario_id = G.akyrs_scenario_id + 1
    G.GAME.akyrs_scenario_tally = G.GAME.akyrs_scenario_tally and (G.GAME.akyrs_scenario_tally + 1) or 1
    if not for_collection then self:set_ability() end

end


function AKYRS.Scenario_Tag:set_ability()
    local obj = AKYRS.Scenarios[self.key]
    if obj and obj.set_ability and type(obj.set_ability) == 'function' then
        obj:set_ability(self)
    end
end


function AKYRS.Scenario_Tag:save()
    return {
        key = self.key,
        akyrs_scenario_tally = self.akyrs_scenario_tally, 
        ability = self.ability,
    }
end

function AKYRS.Scenario_Tag:load(tag_savetable)
    self.key = tag_savetable.key
    local proto = AKYRS.Scenarios[self.key]
    self.config = copy_table(proto.config)
    self.pos = proto.pos
    self.name = proto.name
    self.akyrs_scenario_tally = tag_savetable.akyrs_scenario_tally
    self.ability = tag_savetable.ability
    G.GAME.akyrs_scenario_tally = math.max(self.akyrs_scenario_tally, G.GAME.akyrs_scenario_tally) + 1
    self.from_load = true
end

function AKYRS.Scenario_Tag:juice_up(_scale, _rot)
    if self.tag_sprite then self.tag_sprite:juice_up(_scale, _rot) end
end


function AKYRS.Scenario_Tag:generate_UI(_size, z)
    _size = _size or 0.8

    local tag_sprite_tab = nil

    local tag_sprite = SMODS.create_sprite(0, 0, _size*1, _size*1, SMODS.get_atlas((not self.hide_ability) and AKYRS.Scenarios[self.key].tag_atlas or "tags"), ((self.hide_ability) and G.tag_undiscovered.pos or (self.tag_pos or self.pos)))
    tag_sprite.T.scale = 1
    tag_sprite_tab = {n= G.UIT.C, config={align = "cm", ref_table = self, group = self.tally}, nodes={
        {n=G.UIT.O, config={w=_size*1,h=_size*1, colour = G.C.BLUE, object = tag_sprite, focus_with_object = true}},
    }}
    tag_sprite:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'},
    })
    tag_sprite.float = true
    tag_sprite.T.z = z
    tag_sprite.states.hover.can = true
    tag_sprite.states.drag.can = false
    tag_sprite.states.collide.can = true
    tag_sprite.config = {scenario_tag = self, force_focus = true}

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

function AKYRS.Scenario_Tag:get_uibox_table(tag_sprite)
    tag_sprite = tag_sprite or self.tag_sprite
    tag_sprite.ability_UIBox_table = generate_card_ui(AKYRS.Scenarios[self.key], nil, loc_vars, (self.hide_ability) and 'Undiscovered' or 'Tag', nil, (self.hide_ability), nil, nil, self)
    return tag_sprite
end

function AKYRS.Scenario_Tag:remove_from_game()
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
                G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key+1]:set_alignment({type = 'bl',
                offset = offset,
                xy_bond = 'Weak',
                role_type = 'Minor', 
                major = G.ROOM_ATTACH})
            else
                G.AKYRS_SCENARIO_TAG_HUD[HUD_tag_key+1]:set_role({
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



---@type SMODS.Center
AKYRS.Scenario = SMODS.GameObject:extend{
    required_params = {
        "key"
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
    pos = { x = j, y = i },
    inject = function(self) 
    end,
    config = {

    },
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

  for i = 1, #G.GAME.akyrs_scenario do
  end
  AKYRS.sort_depth()
  G.GAME.akyrs_scenario[#G.GAME.akyrs_scenario+1] = _tag
  if not _tag.from_load then SMODS.calculate_context({akyrs_scenario_applied = _tag}) end
  _tag.from_load = nil
  G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD].is_scenario_tag = true
  _tag.HUD_tag = G.AKYRS_SCENARIO_TAG_HUD[#G.AKYRS_SCENARIO_TAG_HUD]
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

for i = 0, 2 do
    for j = 0, 14 do
        AKYRS.Scenario {
            key = "scenario_"..i.."_"..j,
            set = "Scenario",
            pos = { x = j, y = i },
            calculate = function (self, card, context)
                if context.main_scoring then
                    return {
                        mult = 10,
                    }
                end
            end
        }
    end
end

