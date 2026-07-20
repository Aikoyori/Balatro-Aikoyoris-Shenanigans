
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
    calculate = function (self, card, context)
        for _,en in ipairs(card.akyrs_enchantments) do
            AKYRS.Enchantments[en].calculate(AKYRS.Enchantments[en], card, context)
        end
    end,
    on_apply = function (card)
        card.akyrs_enchantments = {}
    end,
    on_remove = function (card)
        card.akyrs_enchantments = {}
    end,
    weight = 0,
}

function AKYRS.apply_enchantment(card, enchantment_key)
    if not card.edition or not card.edition.key == "akyrs_enchanted" then card:set_edition({ akyrs_enchanted = true }) end
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    if not AKYRS.Enchantments[enchantment_key] then print("Enchantment not found?") end
    card.akyrs_enchantments[#card.akyrs_enchantments+1] = enchantment_key
end
function AKYRS.remove_enchantment(card, enchantment_key)
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    AKYRS.remove_value_from_table(card.akyrs_enchantments, key)
    if #card.akyrs_enchantments == 0 then card:set_edition({}) end
end
function AKYRS.clear_enchantments(card, enchantment_key)
    if not card.edition or not card.edition.key == "akyrs_enchanted" then return end
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    AKYRS.remove_value_from_table(card.akyrs_enchantments, key)
    if #card.akyrs_enchantments == 0 then card:set_edition({}) end
end

AKYRS.Enchantments = {}

---@type SMODS.Center
AKYRS.Enchantment = SMODS.GameObject:extend{
    set = "Enchantment",
    required_params = {
        "key",
        "max_level"
    },
    max_level = 1,
    get_level = function(self,ench_power)
        return self.max_level
    end,
    get_weight_from_level = function(self, level)
        return 2 ^ ((self.max_level - level) + 1)
    end,
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
}