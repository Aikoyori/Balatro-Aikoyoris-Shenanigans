--[[local l = SMODS.Rank{
    key = "non_playing",
    card_key = "SP",
    pos = { x = 0 },
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    nominal = 0,
    suit_map = {
        akyrs_joker = 0
    },
    shorthand = "-",
    strength_effect = {
        ignore = true
    },
    in_pool = function (self, args)
        return false
    end,
    inject = function(self)
    end,
    
}

local j = SMODS.Suit{
    key = "joker",
    card_key = "j",
    pos = { y = 0 },
    ui_pos = { x = 0, y = 0 },
    akyrs_hidden = true,
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = 'special_suit_icon',
    hc_ui_atlas  = 'special_suit_icon',
    
    inject = function(self)
        --SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.JOKER_LC,
    hc_colour = AKYRS.C.JOKER_HC,
    in_pool = function (self, args)
        return false
    end
}
local c = SMODS.Suit{
    key = "consumable",
    card_key = "c",
    pos = { y = 0 },
    ui_pos = { x = 1, y = 0 },
    akyrs_hidden = true,
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = 'special_suit_icon',
    hc_ui_atlas  = 'special_suit_icon',
    
    inject = function(self)
        --SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.CONSU_LC,
    hc_colour = AKYRS.C.CONSU_HC,
    in_pool = function (self, args)
        return false
    end
}
local b = SMODS.Suit{
    key = "booster",
    card_key = "b",
    pos = { y = 0 },
    ui_pos = { x = 2, y = 0 },
    akyrs_hidden = true,
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = 'special_suit_icon',
    hc_ui_atlas  = 'special_suit_icon',
    
    inject = function(self)
        --SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.BOOST_LC,
    hc_colour = AKYRS.C.BOOST_HC,
    in_pool = function (self, args)
        return false
    end
}
local y = SMODS.Suit{
    key = "voucher",
    card_key = "v",
    pos = { y = 0 },
    ui_pos = { x = 3, y = 0 },
    akyrs_hidden = true,
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = 'special_suit_icon',
    hc_ui_atlas  = 'special_suit_icon',
    
    inject = function(self)
        --SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.VOUCH_LC,
    hc_colour = AKYRS.C.VOUCH_HC,
    in_pool = function (self, args)
        return false
    end
}
local th = SMODS.Suit{
    key = "thing",
    card_key = "th",
    pos = { y = 0 },
    ui_pos = { x = 4, y = 0 },
    akyrs_hidden = true,
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = 'special_suit_icon',
    hc_ui_atlas  = 'special_suit_icon',
    
    inject = function(self)
        --SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.THING_LC,
    hc_colour = AKYRS.C.THING_HC,
    in_pool = function (self, args)
        return false
    end
}
]]
