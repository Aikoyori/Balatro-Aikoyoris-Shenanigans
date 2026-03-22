G.P_CENTER_POOLS.FakeCenter = {}

---@type SMODS.Center
AKYRS.FakeCenter = SMODS.Center:extend {
    unlocked = true,
    discovered = true,
    pos = { x = 0, y = 0 },
    cost = 3,
    config = {},
    set = 'FakeCenter',
    atlas = 'Joker',
    class_prefix = 'fc',
    required_params = {
        'key',
    },
    inject = function(self)
        -- call the parent function to ensure all pools are set
        SMODS.Center.inject(self)
    end,
    badge_colour = HEX('000000'),
    badge_text_colour = HEX('FFFFFF'),
    set_card_type_badge = function (self, card, badges)
        badges = {}
    end,
}

AKYRS.FakeCenter{
    key = "eggymari_hatena_art",
    akyrs_credits = {
        art = {
            "eggymari"
        },
        attrib = {
            ["eggymari"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
        info_queue[#info_queue+1] = { set = "Other", key = "akyrs_concealed"}
    end,
    atlas = "eggymariHatenaSprite",
}

AKYRS.FakeCenter{
    key = "toga_charmap",
    akyrs_credits = {
        art = {
            "toga"
        },
        attrib = {
            ["toga"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
        return {
            set = (AKYRS.is_mod_loaded("TOGAPack") and "Joker" or "FakeCenter"),
            key = (AKYRS.is_mod_loaded("TOGAPack") and "j_akyrs_toga_charmap" or "fc_akyrs_toga_charmap"),
        }
    end,
    atlas = "togasstuff_crossmod",
    pos = { x = 0, y = 0 }
}

AKYRS.FakeCenter{
    key = "toga_winword",
    akyrs_credits = {
        art = {
            "toga"
        },
        attrib = {
            ["toga"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
        return {
            vars = {
                0.1992, 1
            },
            set = (AKYRS.is_mod_loaded("TOGAPack") and "Joker" or "FakeCenter"),
            key = (AKYRS.is_mod_loaded("TOGAPack") and "j_akyrs_toga_winword" or "fc_akyrs_toga_winword"),
        }
    end,
    atlas = "togasstuff_crossmod",
    pos = { x = 1, y = 0 }
}
