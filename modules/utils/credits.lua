---@type { [string]: AKYRS.Credit }
AKYRS.Credits = {}
AKYRS.Credits_Lookups_By_Item = {}
AKYRS.Credits_List_by_Item = {}
---@type string[]
AKYRS.Credit_Buffer = {}
AKYRS.Credit_Zone_List = {}

AKYRS.CREDIT_TYPES = { 'art' , 'idea' , 'code' , 'balancing' }
AKYRS.CREDIT_ZONES = { 'main' , 'extras' , 'crossmod' , 'original' }

---@alias AKYRS.CreditCategory 'main' | 'extras' | 'crossmod' | 'original'
---@alias AKYRS.CreditType 'art' | 'idea' | 'code' | 'balancing'
---@alias AKYRS.CreditItem [ string, AKYRS.CreditType ]

---@class AKYRS.Credit: SMODS.GameObject
---@field username string username (appearing after @) NOTE: DISPLAY NAMES ARE IN LOCALIZATION
---@field atlas? string 
---@field pos? table|{ x : integer, y : integer } 
---@field accredited AKYRS.CreditItem[] 
---@field social_links [string, string][]
---@field category AKYRS.CreditCategory
---@field no_atlas boolean
---@overload fun(self: AKYRS.Credit): AKYRS.Credit
AKYRS.Credit = SMODS.GameObject:extend{
    required_params = {
        "key",
        "username",
    },
    class_prefix = "credits",
    set = "Credits",
    category = 'main',
    obj_table = AKYRS.Credits,
    obj_buffer = AKYRS.Credit_Buffer,
    badge_colour = HEX("63549E"),
    pos = { x = 0, y = 0 },
    inject = function(self) 
        self.accredited_reverse_lookup = {}
        self.accredited_category_list = {}
        self.accredited_keys = {}
        AKYRS.Credit_Zone_List[self.category] = AKYRS.Credit_Zone_List[self.category] or {}
        AKYRS.Credit_Zone_List[self.category][#AKYRS.Credit_Zone_List[self.category]+1] = self
        if self.accredited then
            for index, acr_obj in ipairs(self.accredited) do
                AKYRS.Credits_Lookups_By_Item[acr_obj[1]] = AKYRS.Credits_Lookups_By_Item[acr_obj[1]] or {}
                AKYRS.Credits_List_by_Item[acr_obj[1]] = AKYRS.Credits_List_by_Item[acr_obj[1]] or {}
                AKYRS.Credits_Lookups_By_Item[acr_obj[1]][#AKYRS.Credits_Lookups_By_Item[acr_obj[1]]+1] = { self.key, acr_obj[2] }
                self.accredited_reverse_lookup[acr_obj[1]] = acr_obj[2]
                for _, credtype in ipairs(acr_obj[2]) do

                    AKYRS.Credits_List_by_Item[acr_obj[1]][credtype] = AKYRS.Credits_List_by_Item[acr_obj[1]][credtype] or {}
                    AKYRS.Credits_List_by_Item[acr_obj[1]][credtype][#AKYRS.Credits_List_by_Item[acr_obj[1]][credtype]+1] = self.key

                    self.accredited_category_list[credtype] = self.accredited_category_list[credtype] or {}
                    self.accredited_category_list[credtype][#self.accredited_category_list[credtype]+1] = acr_obj[1]
                end
            end
            for _, ks in ipairs(AKYRS.CREDIT_TYPES) do
                if self.accredited_category_list[ks] then
                    for _, itm in ipairs(self.accredited_category_list[ks]) do
                        self.accredited_keys[#self.accredited_keys+1] = itm
                    end
                end
            end
            AKYRS.remove_dupes(self.accredited_keys)
        end
    end,
    generate_credit_item = function (self)
        local cred_obj = self
        local extra_nodes = {}
        local extra_nodes_nx = {}
        local extra_nodes_crdts = {}
        localize { type = 'descriptions', set = 'Credits', key = self.key, nodes = extra_nodes_nx, default_col = G.C.UI.TEXT_LIGHT }
        extra_nodes[#extra_nodes+1] = transparent_multiline_text(extra_nodes_nx)
        extra_nodes[#extra_nodes].config.align = 'lc'
        if cred_obj.social_links then
        for _, conj in ipairs(cred_obj.social_links) do
            extra_nodes_crdts[#extra_nodes_crdts+1] = AKYRS.create_link_sprite_btn(conj[1], conj[2])
        end
        extra_nodes[#extra_nodes+1] = {
            n = G.UIT.R,
            config = { padding = 0.02 },
            nodes = extra_nodes_crdts
        }
        end
        return AKYRS.create_credits(cred_obj.atlas, "@"..cred_obj.username, self.key, 3.1, nil, extra_nodes, cred_obj)
    end,
    discovered = true,
}

AKYRS.Credit{
    key = 'larantula_l',
    username = 'larantula_l',
    atlas = 'larantula_l_credits',
    accredited = {
        { 'j_akyrs_maxwells_notebook', { 'art' }},
        { 'j_akyrs_g', { 'art' }},
    },
    social_links = {
        { "youtube", "https://www.youtube.com/@Larantula" }
    },
}

AKYRS.Credit{
    key = 'eggymari',
    username = 'eggymari',
    atlas = 'plasma_credits',
    accredited = {
        { 'fc_akyrs_eggymari_hatena_art', { 'art' }},
    },
    social_links = {
        {"youtube", "https://www.youtube.com/@PlasmaPhrase"},
        {"twitter", "https://twitter.com/plasmaphrase"},
    },
}

AKYRS.Credit{
    key = 'gudusername_53951',
    username = 'gudusername_53951',
    atlas = 'gud_credits',
    accredited = {
        { 'j_akyrs_gift_voucher', { 'art', 'idea' }},
    },
    social_links = {
    },
}

AKYRS.Credit{
    key = 'lyman',
    username = 'Lyman',
    atlas = 'lyman_credits',
    accredited = {
        { 'j_akyrs_press_f', { 'art' }},
    },
    social_links = {
        { "pixeljoint" , "https://pixeljoint.com/p/172299.htm"}
    },
}

AKYRS.Credit{
    key = 'tje.tsu',
    username = 'tje.tsu',
    atlas = 'tsu_credits',
    accredited = {
        { 'fc_akyrs_judgement_miss', { 'art' }},
        { 'fc_akyrs_judgement_good', { 'art' }},
        { 'fc_akyrs_judgement_great', { 'art' }},
        { 'fc_akyrs_judgement_perfect', { 'art' }},
        { 'fc_akyrs_judgement_cperfect', { 'art' }},
    },
    social_links = {
        
    },
}

AKYRS.Credit{
    key = 'marcyptata64',
    username = 'marcyptata64',
    atlas = 'marcyptata64_credits',
    accredited = {
        { 'j_akyrs_gappie', { 'art' }},
    },
    social_links = {
        { "newgrounds", "https://marcyptata64.newgrounds.com/" }
    },
}

AKYRS.Credit{
    key = 'dr_monty_the_snek',
    username = 'dr_monty_the_snek',
    atlas = 'drmonty_credits',
    category = 'extras',
    accredited = {
        { 'j_akyrs_diamond_pickaxe', { 'balancing' }},
        { 'j_akyrs_it_is_forbidden_to_dog', { 'balancing' }},
        { 'j_akyrs_yona_yona_dance', { 'balancing' }},
        { 'j_akyrs_gaslighting', { 'balancing' }},
        { 'j_akyrs_dried_ghast', { 'balancing' }},
        { 'j_akyrs_charred_roach', { 'balancing' }},
        { 'j_akyrs_turret', { 'balancing' }},
        { 'j_akyrs_goodbye_sengen', { 'balancing' }},
        { 'j_akyrs_kita', { 'balancing' }},
        { 'j_akyrs_nijika', { 'balancing' }},
        { 'e_akyrs_noire', { 'balancing' }},
    },
    social_links = {
        
    },
}

-- TODO: run this snippet when all risk cards are added to get a table for proper credits
--[[]]
--[[
local ellen_c = {}
local ariyi_c = {}
for _, c in ipairs(G.P_CENTER_POOLS.Risk) do
    if G.P_CENTERS[c.key].akyrs_originally_from_pta then
        ellen_c[#ellen_c+1] = { c.key, { 'idea' }}
        ariyi_c[#ariyi_c+1] = { c.key, { 'idea', 'art' }}
    end
end
]]

AKYRS.Credit{
    key = 'haya',
    username = 'hayaunderscore',
    no_atlas = true,
    category = 'original',
    accredited = {

    },
    social_links = {
        
    },
}

AKYRS.Credit{
    key = 'ariyi',
    username = 'ariyi',
    atlas = 'ariyi_credits',
    category = 'original',
    accredited = {
        
    },
    social_links = {
        
    },
}


AKYRS.Credit{
    key = 'frostice482',
    username = 'frostice482',
    category = 'extras',
    no_atlas = true,
    accredited = {
        
    },
    social_links = {
        
    },
}

AKYRS.Credit{
    key = 'toga',
    username = 'TheOneGoofAli',
    category = 'crossmod',
    no_atlas = true,
    accredited = {
        { 'fc_akyrs_toga_charmap', { 'art' }},
        { 'fc_akyrs_toga_winword', { 'art' }},
    },
    social_links = {
        
    },
}

AKYRS.Credit{
    key = 'papermoon',
    username = 'PaperMoon',
    category = 'crossmod',
    no_atlas = true,
    accredited = {
        { 'fc_akyrs_paperback_pure_star', { 'art' }},
        { 'fc_akyrs_paperback_pure_crown', { 'art' }},
        { 'fc_akyrs_paperback_pure_apostle', { 'art' }},
    },
    social_links = {
        
    },
}

AKYRS.Credit{
    key = 'papu',
    username = 'elpapud6',
    category = 'extras',
    no_atlas = true,
    social_links = {
    },
}
AKYRS.Credit{
    key = 'enigmatic42',
    username = 'enigmatic42',
    category = 'extras',
    no_atlas = true,
    social_links = {
    },
}