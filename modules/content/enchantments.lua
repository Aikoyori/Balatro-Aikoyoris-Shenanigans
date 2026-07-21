G.P_CENTER_POOLS.Enchantment = {}
local function ench_row(text, enchantment)    
    local curse = (AKYRS.Enchantments[enchantment[1]] or {}).curse
    return {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    colour = curse and G.C.RED or G.C.UI.TEXT_DARK,
                    scale = 0.32,
                    text = text,
                }
            }
        }
    }
end
SMODS.Edition{
    key = "enchanted",
    shader = "akyrs_enchanted",
    config = {
        name = "akyrs_enchanted"
    },
    sound = { sound = "akyrs_enchanted", per = 1, vol = 0.7 },
    in_shop = false,
    loc_vars = function (self, info_queue, card)
        return {
            
        }
    end,
    generate_ui = function (self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Joker.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cx = {}
        if (card and #card.akyrs_enchantments > 0) then
            for _,en in ipairs(card.akyrs_enchantments) do
                --print(en[1],en[2])
                local o = AKYRS.Enchantments[en[1]]
                cx[#cx+1] = ench_row(localize{ type = "name_text", key = en[1], set = "Enchantment", vars = {localize("f_akyrs_localize_enchantment_level")(en[2])}}, en)
            end
        else
            cx[#cx+1] = ench_row(localize("k_akyrs_enchantment_none"))
        end
        desc_nodes[#desc_nodes+1] = {
                { n = G.UIT.R, config = { padding = 0.1, colour = G.C.CLEAR, r = 0.1}, nodes = cx }
            }

    end,
    -- localize("k_akyrs_enchantment_none")
    calculate = function (self, card, context)
        local fx = {}
        for _,en in ipairs(card.akyrs_enchantments) do
            fx[#fx+1] = AKYRS.Enchantments[en[1]]:calculate(card, context, en[2])
        end
        return SMODS.merge_effects(fx)
    end,
    on_apply = function (card)
        card.akyrs_enchantments = card.akyrs_enchantments or {}
    end,
    on_remove = function (card)
        card.akyrs_enchantments = {}
    end,
    weight = 0,
}

function AKYRS.apply_enchantment(card, enchantment_key, level, forced)
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    if not AKYRS.Enchantments[enchantment_key] then error("Enchantment not found?") return end
    if not AKYRS.Enchantments[enchantment_key]:is_valid_level(level) and not forced then
        error("Invalid Level")
    end
    if not card.edition or not card.edition.key == "akyrs_enchanted" then card:set_edition({ akyrs_enchanted = true }) end
    card.akyrs_enchantments[#card.akyrs_enchantments+1] = {enchantment_key, level}
    AKYRS.Enchantments[enchantment_key].discovered = true
    SMODS.calculate_context({ akyrs_enchantment_applied = true, applied_enchantment_data = {enchantment_key, level} })
end
function AKYRS.remove_enchantment(card, enchantment_key, forced)
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    local removed_ench = {}
    local x = AKYRS.filter_table(card.akyrs_enchantments, function (ench, i)
        local b = ench[1] ~= key or (not AKYRS.Enchantments[ench[1]]:can_be_removed(card, ench[2]) and not forced)
        if b then
            removed_ench[#removed_ench+1] = ench
        end
        return b
    end, true, true)
    card.akyrs_enchantments = x
    SMODS.calculate_context({ akyrs_enchantment_removed = true, removed_enchantments = removed_ench })
    if #card.akyrs_enchantments == 0 then card:set_edition({}) end
end
function AKYRS.clear_enchantments(card, forced)
    if not card.edition or not card.edition.key == "akyrs_enchanted" then return end
    local removed_ench = {}
    local x = AKYRS.filter_table(card.akyrs_enchantments, function (ench, i)
        local b = not AKYRS.Enchantments[ench[1]]:can_be_removed(card, ench[2]) and not forced
        if b then
            removed_ench[#removed_ench+1] = ench
        end
        return b
    end, true, true)
    card.akyrs_enchantments = x
    SMODS.calculate_context({ akyrs_enchantment_removed = true, removed_enchantments = removed_ench })
    if #card.akyrs_enchantments == 0 then
        card:set_edition({})
    end
    
end

AKYRS.Enchantments = {}
AKYRS.Enchantments_Buffer = {}


SMODS.UndiscoveredSprite{
    key = "Enchantment",
    atlas = "enchantedbook",
    pos = { x = 1, y = 0 }
}

SMODS.UndiscoveredCompat["Enchantment"] = true

---@class AKYRS.Enchantment: SMODS.Center
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, card: Card|table, level: number): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://github.com/Steamodded/smods/wiki/Localization#loc_vars) documentation for return value details. 
---@field calculate? fun(self: SMODS.Center|table, card: Card|table, context: CalcContext|table, level: number): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://github.com/Steamodded/smods/wiki/calculate_functions) docs for details. 
---@overload fun(self: AKYRS.Enchantment): AKYRS.Enchantment
AKYRS.Enchantment = SMODS.GameObject:extend{
    set = "Enchantment",
    required_params = {
        "key",
    },
    class_prefix = "ench",
    locked_atlas = "enchantedbook",
    akyrs_undiscover_tooltip = true,
    locked_pos = { x = 1, y = 0},
    obj_table = AKYRS.Enchantments,
    obj_buffer = AKYRS.Enchantments_Buffer,
    atlas = "akyrs_enchantedbook",
    max_level = 1,
    curse = false,
    config = {
        akyrs_level = 1,
    },
    incompat_list = {

    },
    can_be_removed = function(self, card, level)
        return not self.curse
    end,
    is_compatible = function (self, other_key)
        return not self.incompat_list[other_key] and not AKYRS.Enchantments[other_key].incompat_list[self.key]
    end,
    inject = function(self) 
    end,
    is_valid_level = function(self, level)
        return math.floor(level) == level and level >= 1 and level <= self.max_level
    end,
    get_weight_from_level = function(self, level)
        return 2 ^ ((self.max_level - level) + 1)
    end,
    badge_colour = HEX("654b17"),
    get_weights_for_randomiser = function (self, level)
        local weights = {}
        for single_level = 1, self.max_level do
            table.insert(weights, {
                value = {
                    key = self.key,
                    level = single_level
                },
                weight = self:get_weight_from_level(single_level)
            })
        end
        return weights
    end,
    calculate = function (self, card, context, level)
        
    end,
    loc_vars = function (self, info_queue, card, level)
    end,
    draw = function (card, scale_mod, rotate_mod)
        if card.children and card.children.center then
            card.children.center:draw_shader('akyrs_enchanted',0, nil, nil, card.children.center,nil, nil,nil,nil, 0.6)
        end
    end,
    akyrs_shader_overlay = 'akyrs_enchanted',
}


AKYRS.Enchantment {
    key = "mending",
    calculate = function (self, card, context, level)
        if (context.repetition or context.retrigger_joker_check) and context.other_card == card then
            return {
                repetitions = 1,
            }
            
        end
    end
}
AKYRS.Enchantment {
    key = "efficiency",
    max_level = 5,
    loc_vars = function (self, info_queue, card, level)
        local n, d = SMODS.get_probability_vars(card, level * 16, 100, "akyrs_ench_efficiency", nil, true)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                n,
            }
        }
    end,
    calculate = function (self, card, context, level)
        
    end
}