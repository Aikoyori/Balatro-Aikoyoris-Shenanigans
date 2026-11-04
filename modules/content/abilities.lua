
AKYRS.BaseAbilities = {}
AKYRS.BaseAbilities_Buffer = {}
AKYRS.Abilities = {

}

AKYRS.Abilities_Buffer = {
    
}

AKYRS.Abilities_Tables = {
    
}

---@class AKYRS.AbilityBase : SMODS.GameObject
---@field ability_calculate? fun(self: SMODS.Center|table, ability: table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://docs.smods.dev/API%20Documentation/Calculate-Functions) docs for details. 
---@field apply? fun(self)
---@overload fun(o: AKYRS.AbilityBase): AKYRS.AbilityBase
AKYRS.AbilityBase = SMODS.GameObject:extend{
    required_params = {'key', 'set'},
    register = function (self)
        AKYRS.Abilities[self.set][self.key] = self
        AKYRS.Abilities_Tables[self.set][#AKYRS.Abilities_Tables[self.set]+1] = self
        AKYRS.Abilities_Buffer[self.set][#AKYRS.Abilities_Buffer[self.set]+1] = self.key
    end
}