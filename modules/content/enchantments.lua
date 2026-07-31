
local function ench_row(text, enchantment)    
    enchantment = enchantment or {}
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
        if (card and card.akyrs_enchantments and #card.akyrs_enchantments > 0) then
            for _,en in ipairs(card.akyrs_enchantments) do
                --print(en[1],en[2])
                local o = AKYRS.Enchantments[en[1]]
                cx[#cx+1] = ench_row(localize{ type = "name_text", key = en[1], set = "Enchantment", vars = {localize("f_akyrs_localize_enchantment_level")(en[2])}}, en)
            end
        else
            cx[#cx+1] = ench_row(localize("k_akyrs_enchantment_none_blank"))
        end
        desc_nodes[#desc_nodes+1] = {
                { n = G.UIT.R, config = { padding = 0.1, colour = G.C.CLEAR, r = 0.1}, nodes = cx }
            }

    end,
    -- localize("k_akyrs_enchantment_none")
    calculate = function (self, card, context)
        local fx = {}
        if card and context and card.akyrs_enchantments and next(card.akyrs_enchantments) then
            for _,en in ipairs(card.akyrs_enchantments) do
                local enchant_obj = AKYRS.Enchantments[en[1]]
                local effect = enchant_obj:enchantment_calculate(card, context, en[2])
                if effect then
                    if enchant_obj.requires_effect_calc then
                        SMODS.calculate_effect(effect, card)
                    else
                        fx[#fx+1] = effect
                    end
                end
            end
        end
        return AKYRS.merge_effects(fx)
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

    end
    if not AKYRS.Enchantments[enchantment_key]:can_apply(level, card) and not card.ability.set == "Enchantment" and not forced then
        error("Incompatible")
    end
    if ((not card.edition or not (card.edition.key == "e_akyrs_enchanted")) and not (card.ability.set == "Enchantment") ) then 
        card:set_edition({ akyrs_enchanted = true }) 
    end
    AKYRS.Enchantments[enchantment_key].discovered = true
    AKYRS.Enchantments[enchantment_key].unlocked = true
    
    if card.ability.set == "Enchantment" and card.config.center.key ~= "ench_akyrs_multi_enchant_book" then
        local ogench = { card.config.center.key, card.ability.akyrs_level }
        local combined_enchant = {ogench}
        card:set_ability(AKYRS.Enchantments["ench_akyrs_multi_enchant_book"])
        card.akyrs_enchantments = nil
        card.akyrs_stored_enchantments = combined_enchant
    end 
    local table_set = card.config.center.key == "ench_akyrs_multi_enchant_book" and 'akyrs_stored_enchantments' or 'akyrs_enchantments'
    local upgraded_from = nil
    
    if not forced then
        local ench_obj = {enchantment_key, level}
        local max_ench = {}
        local ench_order = {}
        --print(card.akyrs_enchantments)
        for _, val in ipairs(card[table_set]) do
            table.insert(ench_order, val[1])
            
            --print(val[1]," level ",val[2])
            if max_ench[val[1]] == nil then max_ench[val[1]] = val[2] 
            else 
                if val[2] > max_ench[val[1]] then
                    max_ench[val[1]] = val[2]
                end
            end
        end
        --print(max_ench)
        local target_lvl = AKYRS.Enchantments[enchantment_key]:target_level_after_upgrade(max_ench[enchantment_key], ench_obj)
        if AKYRS.Enchantments[enchantment_key]:is_valid_level(target_lvl) then
            if not max_ench[enchantment_key] or target_lvl > max_ench[enchantment_key] then
                if not max_ench[enchantment_key] then table.insert(ench_order, enchantment_key) end
                upgraded_from = {enchantment_key, max_ench[enchantment_key] or 0}
                --print("from",max_ench[enchantment_key],"to",target_lvl,"for",enchantment_key)
                if max_ench[enchantment_key] and max_ench[enchantment_key] > 0 then
                    SMODS.calculate_context({ akyrs_enchantment_removed = true, removed_enchantments = {{enchantment_key, max_ench[enchantment_key] or 0}} })
                end
                max_ench[enchantment_key] = target_lvl
                AKYRS.Enchantments[enchantment_key]:apply(card, level)
            end
        end
        local ench_table = {}
        for _,ench_key in ipairs(ench_order) do
            ench_table[#ench_table+1] = {ench_key, max_ench[ench_key]}
        end
        card[table_set] = ench_table
    else
        card[table_set][#card[table_set]+1] = {enchantment_key, level}
        AKYRS.Enchantments[enchantment_key]:apply(card, level)
    end
    SMODS.calculate_context({ akyrs_enchantment_applied = true, applied_enchantment_data = {enchantment_key, level}, upgraded_from = upgraded_from })
end
function AKYRS.remove_enchantment(card, enchantment_key, forced)
    card.akyrs_enchantments = card.akyrs_enchantments or {}
    local removed_ench = {}
    local x = AKYRS.filter_table(card.akyrs_enchantments, function (ench, i)
        local b = ench[1] ~= key or (not AKYRS.Enchantments[ench[1]]:can_be_removed(card, ench[2]) and not forced)
        if not b then
            AKYRS.Enchantments[ench[1]]:remove(card, ench[2])
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
        if not b then
            AKYRS.Enchantments[ench[1]]:remove(card, ench[2])
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

function AKYRS.has_enchantment(card, enchantment_key)
    if not card.akyrs_enchantments then return false end
    for _, en in ipairs(card.akyrs_enchantments) do
        if en[1] == enchantment_key then return true end
    end
    return false
end

-- returns a list of matching enchantments
function AKYRS.get_enchantment(card, enchantment_key)
    if not card.akyrs_enchantments then return {} end
    if not enchantment_key then return card.akyrs_enchantments end
    local enchantments = AKYRS.filter_table(card.akyrs_enchantments, function (en, i)
        return en[1] == enchantment_key
    end, true, true)
    return enchantments
end

function AKYRS.get_max_level_enchantments_for(card, enchantment_key)
    if not card.akyrs_enchantments then return nil end
    if not enchantment_key then return nil end
    local max_lvl = nil
    for _, en in ipairs(card.akyrs_enchantments) do
        if en[1] == enchantment_key then 
            if not max_lvl or en[2] > max_lvl then
                max_lvl = en[2]
            end
        end
    end
    return max_lvl
end


function AKYRS.create_enchanted_book(enchantment_list)
    local card = {}
    if #enchantment_list == 1 then
        card = SMODS.add_card{ set = "Enchantment", key = enchantment_list[1][1], area = G.consumeables }
        card.ability.akyrs_level = enchantment_list[1][2] or 1
    else
        card = SMODS.add_card{ set = "Enchantment", key = "ench_akyrs_multi_enchant_book", area = G.consumeables }
        for _, k in ipairs(enchantment_list) do
            if not k[2] then k[2] = 1 end
        end
        card.akyrs_stored_enchantments = enchantment_list
    end
    return card
end

AKYRS.Enchantments = {}
AKYRS.Enchantments_Buffer = {}


SMODS.UndiscoveredSprite{
    key = "Enchantment",
    atlas = "enchantedbook",
    pos = { x = 1, y = 0 }
}

G.P_CENTER_POOLS.Enchantment = {}
SMODS.UndiscoveredCompat["Enchantment"] = true

---@class AKYRS.Enchantment: SMODS.Center
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, card: Card|table, level: number): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://github.com/Steamodded/smods/wiki/Localization#loc_vars) documentation for return value details. 
---@field enchantment_calculate? fun(self: SMODS.Center|table, card: Card|table, context: CalcContext|table, level: number): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://github.com/Steamodded/smods/wiki/calculate_functions) docs for details. 
---@field use? fun(self: SMODS.Center|table, card: Card|table, area: CardArea|table, copier?: table) Defines behaviour when this consumable is used. 
---@field can_use? fun(self: SMODS.Center|table, card: Card|table): boolean? Return `true` if the consumable is allowed to be used. 
---@field apply?  fun(self: SMODS.Center|table, card: Card|table, level: number)? 
---@field remove? fun(self: SMODS.Center|table, card: Card|table, level: number)? 
---@field can_be_removed? fun(self: SMODS.Center|table, card: Card|table, level: number): boolean?
---@field keep_on_use? fun(self: SMODS.Center|table, card: Card|table): boolean? Return `true` if the consumable should stay after use.
---@field can_apply? fun(self: SMODS.Center|table, level:number,  other_card: Card|table): boolean? 
---@field allowed_func? fun(self: SMODS.Center|table, card: Card|table): boolean? Function to ask if you can apply achievement
---@field allowed_set? table? sets that you can apply the enchantment with, overridden by allowed_func
---@field requires_effect_calc? bool? instead of adding it to return calculates individually
---@field in_pool? fun(self: SMODS.Center|table, args: table): boolean? , table? Allows configuring if the card is allowed to spawn. 
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
        consumeable = {
        },
        min_highlighted = 1,
        max_highlighted = 1,
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
    target_level_after_upgrade = function (self, curr_level, target_ench)
        curr_level = curr_level or 0
        if self.key ~= target_ench[1] then return 0 end
        if target_ench[2] >= curr_level then return math.max(curr_level + 1, target_ench[2]) end
        return curr_level
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
    get_weight = function (self, level)
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
    allowed_set = {
        ["Joker"] = true,
        ["Default"] = true,
        ["Enhanced"] = true,
    },
    allowed_func = function(self, card)
        if not self.allowed_set[card.ability.set] and card.ability.set ~= "Enchantment" then return false end
        return true
    end,
    in_pool = function (self, args)
        if not args.treasure and self.treasure then return false end
        return true
    end,
    can_apply = function (self, level, other_card)
        if other_card.akyrs_enchantments then
            for _,enc in ipairs(other_card.akyrs_enchantments) do
                if not self:is_compatible(enc[1]) then
                    return false
                end
            end
        end
        if not self:allowed_func(other_card) then return false end 
        return true
    end,
    enchantment_calculate = function (self, card, context, level)
        
    end,
    loc_vars = function (self, info_queue, card, level)
    end,
    draw = function (card, scale_mod, rotate_mod)
        if card.children and card.children.center then
            card.children.center:draw_shader('akyrs_enchanted',0, nil, self.ARGS.send_to_shader, card.children.center,nil, nil,nil,nil, 0.6)
        end
    end,
    can_use = function (self, card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            return ca ~= card and (self:can_apply(card.ability.akyrs_level, ca) or ca.ability.set == "Enchantment")
        end, true, true)
        return #cards >= card.ability.min_highlighted and #cards <= card.ability.max_highlighted
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            return ca ~= card and (self:can_apply(card.ability.akyrs_level, ca) or ca.ability.set == "Enchantment")
        end, true, true)
        AKYRS.do_things_to_card(cards, function (card2, index)
            AKYRS.apply_enchantment(card2, self.key, card.ability.akyrs_level)
        end)
    end,
    apply = function (self, card, level)
        
    end,
    remove = function (self, card, level)
        
    end,
    inject = function(self)
        if not G.P_CENTER_POOLS[self.set] then G.P_CENTER_POOLS[self.set] = {} end
        G.P_CENTERS[self.key] = self
        if not self.omit then SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self) end
        for k, v in pairs(SMODS.ObjectTypes) do
            -- Should "cards" be formatted as `{[<center key>] = true}` or {<center key>}?
            -- Changing "cards" and "pools" wouldn't be hard to do, just depends on preferred format
            if ((self.pools and self.pools[k]) or (v.cards and v.cards[self.key])) then
                v:inject_card(self)
            end
        end
        if self.attributes then
            for _, attribute in ipairs(self.attributes) do
                if SMODS.Attributes[attribute] then
                    self.attributes[attribute] = true
                    SMODS.Attributes[attribute].keys = SMODS.merge_lists({SMODS.Attributes[attribute].keys or {}, {self.key}})
                end
            end
        end
        if self.soul_atlas and not self.soul_pos then
            self.soul_pos = { x = 0, y = 0 }
        end
    end,
    akyrs_shader_overlay = 'akyrs_enchanted',
}


AKYRS.Enchantment {
    key = "multi_enchant_book",
    weight = 0,
    in_pool = function (self, args)
        return false
    end,
    can_apply = function (self, level, other_card)
        return false
    end,
    
    generate_ui = function (self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Joker.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cx = {}
        if (card and card.akyrs_stored_enchantments and #card.akyrs_stored_enchantments > 0) then
            for _,en in ipairs(card.akyrs_stored_enchantments) do
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
    
    can_use = function (self, card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            if card.akyrs_stored_enchantments then
                for _, en in ipairs(card.akyrs_stored_enchantments) do
                    if AKYRS.Enchantments[en[1]]:can_apply(en[2], ca) then
                        return card ~= ca
                    end
                end
            end
            return card ~= ca
        end, true, true)
        return #cards >= card.ability.min_highlighted and #cards <= card.ability.max_highlighted
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cards = AKYRS.filter_table(AKYRS.combine_table(G.jokers.highlighted, G.consumeables.highlighted, G.hand.highlighted),
        function (ca)
            if card.akyrs_stored_enchantments then
                for _, en in ipairs(card.akyrs_stored_enchantments) do
                    if AKYRS.Enchantments[en[1]]:can_apply(en[2], ca) then
                        return card ~= ca
                    end
                end
            end
            return card ~= ca
        end, true, true)
        AKYRS.do_things_to_card(cards, function (card2, index)
            if card.akyrs_stored_enchantments then
                for _, en in ipairs(card.akyrs_stored_enchantments) do
                    if AKYRS.Enchantments[en[1]]:can_apply(en[2], card2) then
                        AKYRS.apply_enchantment(card2, en[1], en[2])
                    end
                end
            end
        end)
    end,
}
AKYRS.Enchantment {
    key = "mending",
    enchantment_calculate = function (self, card, context, level)
        if (context.repetition or context.retrigger_joker_check) and context.other_card == card then
            return {
                repetitions = 1,
            }
            
        end
    end,
    treasure = true,
}
AKYRS.Enchantment {
    key = "efficiency",
    max_level = 5,
    requires_effect_calc = true,
    allowed_set = {
        Joker = true
    },
    loc_vars = function (self, info_queue, card, level)
        local n, d = SMODS.get_probability_vars(card, level * 16, 100, "akyrs_ench_efficiency", nil, true)
        local compatible = false
        if card and card.area and card.area.cards then
            local ind = AKYRS.find_index(card.area.cards,card)
            if ind > 1 then 
                local copying = card.area.cards[ind - 1]
                compatible = copying and copying ~= card and copying.config.center.blueprint_compat
            end
        end
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                n,
                localize('k_' .. (compatible and 'compatible' or 'incompatible')),
                colours = {
                    compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
                }
            },
        }
    end,
    enchantment_calculate = function (self, card, context, level)
        if card and card.area and card.area.cards then
            local ind = AKYRS.find_index(card.area.cards,card)
            if ind == 1 then return {} end
            local copying = card.area.cards[ind - 1]
            local bp_result = SMODS.blueprint_effect(card, copying, context)
            if bp_result then
                --print("real 2")
                local result = SMODS.pseudorandom_probability(card, "akyrs_ench_efficiency", level * 16, 100, nil, true)
                if result then
                    return bp_result
                end
            end
        end
    end
}

AKYRS.Enchantment {
    key = "unbreaking",
    max_level = 3,
    loc_vars = function (self, info_queue, card, level)
        local n, d = SMODS.get_probability_vars(card, level * 25, 100, "akyrs_ench_unbreaking", nil, true)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                n
            }
        }
    end,
}
AKYRS.Enchantment {
    key = "fire_aspect",
    max_level = 2,
    loc_vars = function (self, info_queue, card, level)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                level * 2
            }
        }
    end,
    enchantment_calculate = function (self, card, context, level)
    end
}

AKYRS.Enchantment {
    key = "fortune",
    max_level = 6,
    loc_vars = function (self, info_queue, card, level)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                level * 50
            }
        }
    end,
    allowed_func = function (self, card)
        return true
    end,
    enchantment_calculate = function (self, card, context, level)
        if context.mod_probability and context.trigger_obj == card then
            return {
                numerator = context.numerator * (1 + (0.5 * level))
            }
        end
    end
}

AKYRS.Enchantment {
    key = "greed",
    max_level = 4,
    loc_vars = function (self, info_queue, card, level)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                level * 50
            }
        }
    end,
    allowed_func = function (self, card)
        return card.ability.set == "Joker" or card.ability.consumeable
    end,
    enchantment_calculate = function (self, card, context, level)
        if context.selling_card and context.card and context.card ~= card then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_table = context.card,
                scalar_value = "sell_cost",
                scalar_factor = level * 0.5,
                scaling_message = {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            })
            card:set_cost()
        end
    end
}

AKYRS.Enchantment {
    key = "silk_touch",
    max_level = 2,
    loc_vars = function (self, info_queue, card, level)
        return {
            vars = {
                localize("f_akyrs_localize_enchantment_level")(level),
                level * 0.25
            }
        }
    end,
    allowed_set = {
        ["Default"] = true,
        ["Enhanced"] = true,
    },
    enchantment_calculate = function (self, card, context, level)
        if context.discard and context.other_card == card then
            if card.ability.set ~= "Default" then
                return {
                    func = function ()
                        card:set_ability(G.P_CENTERS.c_base)
                        SMODS.scale_card(card, {
                            ref_table = card.ability,
                            ref_value = "perma_x_mult",
                            scalar_table = { level * 0.25 },
                            scalar_value = 1,
                            scaling_message = {
                                colour = G.C.MONEY
                            }
                        })
                    end
                }
            end
        end
    end
}
AKYRS.Enchantment {
    key = "cornucopia",
    max_level = 1,
    allowed_set = {
        ["Default"] = true,
        ["Enhanced"] = true,
    },
    enchantment_calculate = function (self, card, context, level)
        
        if context.press_play then
            return {
                func = function()
                    AKYRS.simple_event_add(function() 
                        local c2 = SMODS.copy_card(card, { strip_edition = true })
                        SMODS.calculate_context({ playing_card_added = true, cards = { c2 } })
                        return true
                    end, 0)
                end
            }
        end
    end
}