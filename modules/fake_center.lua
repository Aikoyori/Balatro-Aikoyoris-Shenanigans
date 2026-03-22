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
        info_queue[#info_queue+1] = { set = "Other", key = "akyrs_concealed"}
    end,
    atlas = "eggymariHatenaSprite",
}
