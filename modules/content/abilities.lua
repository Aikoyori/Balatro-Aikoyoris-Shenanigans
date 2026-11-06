
AKYRS.BaseAbilities = {}
AKYRS.BaseAbilities_Buffer = {}

AKYRS.Abilities = {

}
---@type {[string]: AKYRS.AbilityBase}
AKYRS.All_Abilities = {

}

AKYRS.Abilities_Buffer = {
    
}

AKYRS.Abilities_Tables = {
    
}

function AKYRS.apply_ability(key)
    local ab = AKYRS.All_Abilities[key]
    if ab and ab:can_apply() then
        local abx = {
            key = key,
            ability = copy_table(ab.config),
        }
        if ab:can_apply(abx.ability) then 
            G.GAME.akyrs_abilities = G.GAME.akyrs_abilities or {}
            G.GAME.akyrs_abilities[#G.GAME.akyrs_abilities+1] = abx
            ab:apply(abx.ability)
            return abx
        end
    end
end

---@class AKYRS.AbilityBase : SMODS.GameObject
---@field ability_calculate? fun(self: SMODS.Center|table, ability: table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://docs.smods.dev/API%20Documentation/Calculate-Functions) docs for details.
---@field generate_ui? fun(self: SMODS.Center|table, info_queue: table, card: Card|table, desc_nodes: table, specific_vars: table, full_UI_table: table) Provides complex control over the UI display of the card. See [`generate_ui`](https://docs.smods.dev/API%20Documentation/Localization#generate_ui-advanced) documentation for details.  
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, card: Card|table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://docs.smods.dev/API%20Documentation/Localization#loc_vars) documentation for return value details. ---@field in_pool? fun(self: SMODS.Center|table, args: table): boolean? , table? Allows configuring if the card is allowed to spawn. 
---@field can_apply? fun(self, ability: table): boolean can you do it?
---@field apply? fun(self, ability: table) do the thing
---@field remove? fun(self, ability: table) undo the thing
---@field in_pool? fun(self: SMODS.Center|table, args: table): boolean? , table? Allows configuring if the card is allowed to spawn. 
---@overload fun(o: AKYRS.AbilityBase): AKYRS.AbilityBase
AKYRS.AbilityBase = SMODS.GameObject:extend{
    required_params = {'key', 'group'},
    set = 'Ability',
    config = {},
    obj_table = {},
    class_prefix = 'ab',
    register = function (self)
        AKYRS.All_Abilities[self.key] = self
        AKYRS.Abilities[self.group] = AKYRS.Abilities[self.group] or {}
        AKYRS.Abilities_Tables[self.group] = AKYRS.Abilities_Tables[self.group] or {}
        AKYRS.Abilities_Buffer[self.group] = AKYRS.Abilities_Buffer[self.group] or {}
        AKYRS.Abilities[self.group][self.key] = self
        AKYRS.Abilities_Tables[self.group][#AKYRS.Abilities_Tables[self.group]+1] = self
        AKYRS.Abilities_Buffer[self.group][#AKYRS.Abilities_Buffer[self.group]+1] = self.key
    end,
    generate_ui = SMODS.Center.generate_ui,
    create_fake_card = function(self)
        return { ability = copy_table(self.config), fake_card = self.key }
    end,
    in_pool = function (self, args)
        return AKYRS.has_room(G.jokers)
    end,
    can_apply = function (...)
        return self.in_pool(...)
    end,

}

---@class AKYRS.DiscordAbility : AKYRS.AbilityBase
---@overload fun(o: AKYRS.DevDeckAbility): AKYRS.DevDeckAbility
AKYRS.DevDeckAbility = AKYRS.AbilityBase:extend{
    group = "DevDeck",
    class_prefix = 'ab_dev',
}


---@class AKYRS.DiscordAbility : AKYRS.AbilityBase
---@field negative? boolean is it a fucked up shit or not
---@overload fun(o: AKYRS.DiscordAbility): AKYRS.DiscordAbility
AKYRS.DiscordAbility = AKYRS.AbilityBase:extend{
    group = "DiscordDecks",
    class_prefix = 'ab_discord',
    negative = false,
}

AKYRS.DevDeckAbility{
    key = 'tenfold_money',
    config = {
        moneyx = 10,
    },
    apply = function (self, ability)
        ease_dollars(G.GAME.dollars * ability.moneyx)
    end,
}
AKYRS.DevDeckAbility{
    key = 'get_a_negative_rare',
    config = {
        moneyx = 10,
    },
    apply = function (self, ability)
        SMODS.add_card{ set = "Joker", rarity = 'Rare', edition = 'e_negative'}
    end,
}
AKYRS.DevDeckAbility{
    key = 'get_hundred_dollar',
    config = {
        money = 100,
    },
    apply = function (self, ability)
        ease_dollars(ability.money)
    end,
}
AKYRS.DevDeckAbility{
    key = 'fill_slot_with_uncommon',
    config = {
        money = 100,
    },
    in_pool = function (self, args)
        return AKYRS.has_room(G.jokers)
    end,
    can_apply = function (self, ability)
        return AKYRS.has_room(G.jokers)
    end,
    apply = function (self, ability)
        SMODS.add_card{ set = "Joker", rarity = 'Legendary'}
    end,
}
AKYRS.DevDeckAbility{
    key = 'get_legendary',
    config = {
        
    },
    in_pool = function (self, args)
        return AKYRS.has_room(G.jokers)
    end,
    apply = function (self, ability)
        SMODS.add_card{ set = "Joker", rarity = 'Legendary'}
    end,
}

AKYRS.DevDeckAbility{
    key = 'each_card_gives_xmult',
    config = {
        xmult = 1.5
    },
    in_pool = function (self, args)
        return AKYRS.has_room(G.jokers)
    end,
    ability_calculate = function (self, ability, context)
        if context.individual and context.cardarea == G.play then
            return ability
        end
    end,
}
AKYRS.DevDeckAbility{
    key = 'next_shop_is_free',
    config = {
        free = 1
    },
    apply = function (self, ability)
        G.GAME.akyrs_free_shops = (G.GAME.akyrs_free_shops or 0) + 1
    end
}
AKYRS.DevDeckAbility{
    key = 'double_all_payouts',
    apply = function (self, ability)
        G.GAME.akyrs_payouts_multiplier = (G.GAME.akyrs_payouts_multiplier or 1) * 2
    end
}
AKYRS.DevDeckAbility{
    key = 'negative_all',
    in_pool = function (self, args)
        
    end,
    apply = function (self, ability)
        AKYRS.do_things_to_card(SMODS.merge_lists(G.jokers.cards, G.consumeables.cards), function (_card, index)
            _card:set_edition('e_negative')
        end)
    end
}

AKYRS.DevDeckAbility{
    key = 'double_click_suit',
    in_pool = function (self, args)
        
    end,
    apply = function (self, ability)
        G.GAME.akyrs_double_click_suit_change = true
    end
}