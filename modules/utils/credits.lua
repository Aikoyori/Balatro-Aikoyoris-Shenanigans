---@type { [string]: AKYRS.Credit }
AKYRS.Credits = {}
AKYRS.Credits_Lookups_By_Item = {}
---@type string[]
AKYRS.Credit_Buffer = {}

AKYRS.CREDIT_TYPES = { 'art' , 'idea' , 'code' , 'balancing' }

---@alias AKYRS.CreditCategory 'main' | 'extras' | 'crossmod'
---@alias AKYRS.CreditType 'art' | 'idea' | 'code' | 'balancing'
---@alias AKYRS.CreditItem [ string, AKYRS.CreditType ]

---@class AKYRS.Credit: SMODS.GameObject
---@field username string username (appearing after @) NOTE: DISPLAY NAMES ARE IN LOCALIZATION
---@field atlas? string 
---@field pos? table|{ x : integer, y : integer } 
---@field accredited AKYRS.CreditItem[] 
---@field social_links [string, string] 
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
        if self.accredited then
            for index, acr_obj in ipairs(self.accredited) do
                AKYRS.Credits_Lookups_By_Item[acr_obj[1]] = AKYRS.Credits_Lookups_By_Item[acr_obj[1]] or {}
                AKYRS.Credits_Lookups_By_Item[acr_obj[1]][#AKYRS.Credits_Lookups_By_Item[acr_obj[1]]+1] = { self.key, acr_obj[2] }
                self.accredited_reverse_lookup[acr_obj[1]] = acr_obj[2]
                for _, credtype in ipairs(acr_obj[2]) do
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