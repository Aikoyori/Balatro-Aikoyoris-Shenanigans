AKYRS.PseudoCard = Object:extend()

function AKYRS.PseudoCard:init(rank, rank_id,suit_name) 
    self.base = {}
    self.base.rank = rank
    self.base.id = rank_id
    self.base.value = suit_name
    self.debuff = false
end

function AKYRS.PseudoCard:get_id()
    return self.base.id
end
