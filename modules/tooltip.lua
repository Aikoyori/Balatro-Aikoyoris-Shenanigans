AKYRS.custom_tooltip = {}
local function scenario_transform(pos, self) 
    return { x = pos.x * 1.2 + (pos.y > 0 and 5 or - 5), y = pos.y}
end

local function replicant_transform(pos, self) 
    return SMODS.GUI.rotate_vertex({ x = pos.x * 1.1, y = pos.y * 1.1,}, -0.09)
end

AKYRS.RD = 0
local function umbral_transform(pos, self) 
    if math.abs(pos.x) < 0.01 and math.abs(pos.y) < 0.1 then return pos end
    local pos = SMODS.GUI.rotate_vertex({ x = pos.x * 1.3, y = pos.y * 1.3,}, -((pos.w / 2 - math.abs(pos.x)) + (pos.h / 2 - math.abs(pos.y)) / 1280) )
    return SMODS.GUI.rotate_vertex(pos, 0.6)
    -- return { x = pos.x * 1.1 + xo, y = pos.y * 1.1 + yo,}
end


AKYRS.tooltipped_set = { Scenario = true, Replicant = true, Judgement = true, Umbral = true }
AKYRS.custom_tooltip.container = function (card, aut)
    if card.ability and AKYRS.config.fancy_ui then
        --print(card.ability.set)
       if AKYRS.tooltipped_set[card.ability.set] then
            local card_type_background = aut.card_type == 'Locked' and G.C.BLACK or aut.card_type == 'Undiscovered' and darken(G.C.JOKER_GREY, 0.3) or darken(G.C.BLACK, 0.1)
            local transform_func
            local corners
            local corner_rad
            local outer_col
            local extra_outer_bg
            local alpha = 0.8
            if card.ability.set == 'Scenario' then
                local dark = card.config.center.scenario.side == "dark"
                local colour = G.C['AKYRS_AKYRS_SCENARIO_'..string.upper(dark and "dark_" or "")..string.upper(card.config.center.scenario.colour)]
                local colour_side_dark = G.C['AKYRS_AKYRS_SCENARIO_DARK_'..string.upper(card.config.center.scenario.colour)]
                local colour_side_light = G.C['AKYRS_AKYRS_SCENARIO_'..string.upper(card.config.center.scenario.colour)]
                card_type_background = aut.card_type == 'Locked' and G.C.BLACK or aut.card_type == 'Undiscovered' and darken(G.C.JOKER_GREY, 0.3) or colour_side_dark
                extra_outer_bg = dark and G.C.WHITE or colour_side_light
                outer_col = dark and colour_side_dark or G.C.WHITE
                transform_func = scenario_transform
                alpha = 1
            end
            if card.ability.set == 'Replicant' then
                card_type_background = aut.card_type == 'Locked' and G.C.BLACK or aut.card_type == 'Undiscovered' and darken(G.C.JOKER_GREY, 0.3) or darken(G.C.AKYRS_REPLICANT_C, 0.1)
                extra_outer_bg = G.C.WHITE
                outer_col = G.C.AKYRS_REPLICANT_O
                corners = SMODS.GUI.superellipse(1, 4, 4)
                corner_rad = 2
                transform_func = replicant_transform
                alpha = 1
            end
            if card.ability.set == 'Umbral' then
                card_type_background = aut.card_type == 'Locked' and G.C.BLACK or aut.card_type == 'Undiscovered' and darken(G.C.JOKER_GREY, 0.3) or darken(G.C.AKYRS_UMBRAL_DP, 0)
                outer_col = G.C.AKYRS_UMBRAL_P
                extra_outer_bg = G.C.AKYRS_UMBRAL_Y
                corners = SMODS.GUI.superellipse(2, 4, 4)
                corner_rad = 2
                transform_func = umbral_transform
                alpha = 1
            end
            return {n=G.UIT.ROOT, config = {align = 'cm', colour =  G.C.CLEAR, unbounded_size = true, corners = corners}, nodes = {
                    {n=G.UIT.R, config = {align = "cm", add_info = true, padding = 0.0, unbounded_size = true, corners = corners, }, nodes = {
                        {n=G.UIT.C, config = { minw = 0.6 }, nodes = { { n = G.UIT.R, config = { h = 0.6, w = 0.6 }} }},
                        {n=G.UIT.C, config = {padding = outer_col and 0.05, r = 0.12, res = corner_rad, colour = outer_col or lighten(G.C.JOKER_GREY, 0.5), emboss = outer_col and 0.07, box_transform = transform_func, unbounded_size = true, corners = corners}, nodes = {
                            {n=G.UIT.R, config = {padding = extra_outer_bg and 0.05, r = extra_outer_bg and 0.12, res = corner_rad, colour = extra_outer_bg or lighten(G.C.JOKER_GREY, 0.5), emboss = not extra_outer_bg and 0.07, box_transform = transform_func, unbounded_size = true, corners = corners}, nodes = {
                                {n=G.UIT.C, config = {align = "cm", padding = 0.07, r = 0.1, res = corner_rad, colour = adjust_alpha(card_type_background, alpha), add_name = true, add_main = true, add_badges = true, box_transform = transform_func, unbounded_size = true, corners = corners}, nodes = {}}
                            }}
                        }},
                        {n=G.UIT.C, config = { minw = 0.6 }, nodes = { { n = G.UIT.R, config = { h = 0.6, w = 0.6 }} }},
                    }},
                }}, {
                    
                }
        end
    end
end

AKYRS.custom_tooltip.name = function (card, aut)
    if card.ability and AKYRS.config.fancy_ui then
        --print(card.ability.set)
        if card.akyrs_collection_judgement then
            return {
                n = G.UIT.R, config = { padding = 0.1, align = 'cm'}, nodes = 
                AKYRS.map(aut, function (item, index)
                    return item
                end, true)
            }
        end
        if card.ability.set == 'Replicant' then
            return {
                n = G.UIT.R, config = { padding = 0.1, align = 'c'}, nodes = 
                AKYRS.map(aut, function (item, index)
                    --print(item.nodes[1].nodes[1].config.object.font)
                    --item.nodes[1].nodes[1].config.object.font
                    item.nodes[1].nodes[1].config.object.T.r = -0.04
                    item.nodes[1].nodes[1].config.object.role.offset = { x = 0, y = -0.05 }
                    return item
                end, true)
            }
        end
    end
end