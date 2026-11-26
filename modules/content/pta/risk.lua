SMODS.ConsumableType{
    key = "Risk",
    primary_colour = HEX("ffa661"),
    secondary_colour = HEX("7b194e"),
    collection_rows = { 5, 5 },
    shop_rate = 3,
    default = "c_akyrs_umbral_break_up"
}

SMODS.UndiscoveredSprite{
    key = "Risk",
    atlas = "ptaRisk",
    pos = { x=8, y=2 }
}

---@class AKYRS.PTA.Risk: SMODS.Consumable
---@field risk_func? fun(self: SMODS.Consumable|table, risk:table) Function for when Risk cards are applied during Boss Blinds
---@field risk_calculate? fun(self: SMODS.Center|table, risk: table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://docs.smods.dev/API%20Documentation/Calculate-Functions) docs for details. 
---@overload fun(self: AKYRS.PTA.Risk): AKYRS.PTA.Risk
AKYRS.PTA.Risk = SMODS.Consumable:extend {
    set = 'Risk',
    atlas = "ptaRisk",
    inject = function (self, i)
        self.use = AKYRS.PTA.risk_card_use
        self.can_use = function (self, card)
            if G.GAME.blind.in_blind and G.GAME.blind.boss then
                return false
            end
            return true
        end,
        SMODS.Consumable.inject(self, i)
    end,
}

---@type fun(self: SMODS.Consumable|table, card: Card|table, area: CardArea|table, copier?: table)
AKYRS.PTA.risk_card_use = function (self, card, area, copier)
    -- makes a risk "object"
    G.GAME.akyrs_risk_used[#G.GAME.akyrs_risk_used+1] = {
        key = self.key,
        ability = copy_table(card.ability), -- mostly for value manip reasons
    }
end

AKYRS.PTA.Risk{
    key = "risk_hinder",
    atlas = "ptaRisk",
    pos = {x=0,y=0},
    config = {
        extras = {
            cards_x = 10,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.cards_x
            }
        }
    end,
    risk_calculate = function (self, risk, context)
        if context.setting_blind then
            return {
                func = function ()
                    local cards_target = AKYRS.pseudorandom_elements(G.playing_cards, risk.ability.extras.cards_x, 'akyrs_risk_hinder_pick')
                    AKYRS.map(cards_target, function (item, index)
                        item.ability.akyrs_debuffed_by_risk_hinder = true
                        item:set_debuff(true)
                    end, true)
                end
            }
        end
        if context.debuff_card and context.debuff_card.ability.akyrs_debuffed_by_risk_hinder then
            return {
                debuff = true
            }
        end
    end,
}