local cardSellHook = Card.sell_card
local sell_hook = G.FUNCS.sell_card

G.FUNCS.sell_card = function(e)
    local card = e.config.ref_table
    if card.ability.akyrs_latticed then
        card:sell_card()
        return
    end
    sell_hook(e)
end


function Card:sell_card()
    if self.ability.akyrs_latticed then
        AKYRS.nope_buzzer(self,nil,G.C.playable)
        self:highlight(false)
        return
    end
    if (not (AKYRS.sigmaable_areas(self.area) and self.ability.akyrs_sigma)) or (AKYRS.is_card_not_sigma(self)) then
        self.akyrs_is_being_sold = true
        return cardSellHook(self)
    else
        AKYRS.nope_buzzer(self,nil,G.C.playable)
        self:highlight(false)
    end
end