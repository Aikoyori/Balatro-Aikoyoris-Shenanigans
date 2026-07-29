AKYRS.Scenarios = {}
AKYRS.Scenarios_Buffer = {}

AKYRS.Scenario_Tag = Object:extend()

function AKYRS.Scenario_Tag:init(_tag, for_collection, _blind_type)
    self.key = _tag
    local proto = AKYRS.Scenarios[_tag] or G.tag_undiscovered
    self.config = copy_table(proto.config)
    self.pos = proto.pos
    self.name = proto.name
    self.tally = G.GAME.tag_tally or 0
    self.triggered = false
    G.tagid = G.tagid or 0
    self.ID = G.tagid
    G.tagid = G.tagid + 1
    self.ability = {
        orbital_hand = '['..localize('k_poker_hand')..']',
        blind_type = _blind_type
    }
    G.GAME.tag_tally = G.GAME.tag_tally and (G.GAME.tag_tally + 1) or 1
    if not for_collection then self:set_ability() end
end


AKYRS.Scenario = SMODS.GameObject:extend{
    required_params = {
        "key"
    },
    atlas = "akyrs_scenarioTags",
    config = {

    },
}


function AKYRS.add_scenario_tag(_tag)
  G.AKYRS_SCENARIO_TAG_HUD = G.AKYRS_SCENARIO_TAG_HUD or {}
  G.HUD_tags = G.HUD_tags or {}
  local tag_sprite_ui = _tag:generate_UI()
  G.HUD_tags[#G.HUD_tags+1] = UIBox{
      definition = {n=G.UIT.ROOT, config={align = "cm",padding = 0.05, colour = G.C.CLEAR}, nodes={
        tag_sprite_ui
      }},
      config = {
        align = G.HUD_tags[1] and 'rc' or 'bli',
        offset = G.HUD_tags[1] and {x=0,y=0} or {x=0.0,y=9.5},
        major = G.HUD_tags[1] and G.HUD_tags[#G.HUD_tags] or G.jokers}
  }
  discover_card(G.P_TAGS[_tag.key])

  for i = 1, #G.GAME.tags do
    G.GAME.tags[i]:apply_to_run({type = 'tag_add', tag = _tag})
  end
  
  G.GAME.tags[#G.GAME.tags+1] = _tag
  if not _tag.from_load then SMODS.calculate_context({tag_added = _tag}) end
  _tag.from_load = nil
  _tag.HUD_tag = G.HUD_tags[#G.HUD_tags]
end



SMODS.ConsumableType{
    key = "Scenario",
    primary_colour = HEX("5D8956FF"),
    secondary_colour = HEX("FF5887BD"),
    collection_rows = { 5,5,5 },
    shop_rate = 0,
    default = "c_akyrs_replicant_music_streaming"
}

for i = 0, 2 do
    for j = 0, 14 do
        SMODS.Consumable {
            key = "scenario_"..i.."_"..j,
            set = "Scenario",
            atlas = "scenarioCards",
            pos = { x = j, y = i },
            config = {
                extras = 2,
            },
        }
    end
end

