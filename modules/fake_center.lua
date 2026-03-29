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
    set_badges = function (self, card, badges)
        if self.discovered then SMODS.create_mod_badges({ mod = togabalatro },badges) end
    end,
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
    set_badges = function (self, card, badges)
        if self.discovered then SMODS.create_mod_badges({ mod = togabalatro },badges) end
    end,
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

AKYRS.FakeCenter{
    key = "paperback_pure_star",
    akyrs_credits = {
        art = {
            "papermoon"
        },
        attrib = {
            ["papermoon"] = "art",
        },
    },
    set_badges = function (self, card, badges)
        if self.discovered then SMODS.create_mod_badges({ mod = AKYRS.get_mod_data("paperback") },badges) end
    end,
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    set_sprites = function (self, card, front)
        if not card.children.fake_front then
            AKYRS.simple_event_add(function()
                card.children.fake_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 0, y = (is_hc and 1 or 0)})
                card.children.fake_front.states.hover = card.states.hover
                card.children.fake_front.states.click = card.states.click
                card.children.fake_front.states.drag = card.states.drag
                card.children.fake_front.states.collide.can = false
                card.children.fake_front:set_role({major = card, role_type = 'Glued', draw_major = card})
            return true end, 0, "akyrs_misc")        end
    end,
    prefix_config = {
        atlas = false
    },
    atlas = "centers",
    pos = { x = 1, y = 0 }
}

AKYRS.FakeCenter{
    key = "paperback_pure_crown",
    akyrs_credits = {
        art = {
            "papermoon"
        },
        attrib = {
            ["papermoon"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    set_badges = function (self, card, badges)
        if self.discovered then SMODS.create_mod_badges({ mod = AKYRS.get_mod_data("paperback") },badges) end
    end,
    set_sprites = function (self, card, front)
        if not card.children.fake_front then
            AKYRS.simple_event_add(function()
                card.children.fake_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 1, y = (is_hc and 1 or 0)})
                card.children.fake_front.states.hover = card.states.hover
                card.children.fake_front.states.click = card.states.click
                card.children.fake_front.states.drag = card.states.drag
                card.children.fake_front.states.collide.can = false
                card.children.fake_front:set_role({major = card, role_type = 'Glued', draw_major = card})
            return true end, 0, "akyrs_misc")
        end
    end,
    prefix_config = {
        atlas = false
    },
    atlas = "centers",
    pos = { x = 1, y = 0 }
}

AKYRS.FakeCenter{
    key = "paperback_pure_apostle",
    akyrs_credits = {
        art = {
            "papermoon"
        },
        attrib = {
            ["papermoon"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    set_badges = function (self, card, badges)
        if self.discovered then SMODS.create_mod_badges({ mod = AKYRS.get_mod_data("paperback") },badges) end
    end,
    set_sprites = function (self, card, front)
        if not card.children.fake_front then
            AKYRS.simple_event_add(function()
                card.children.fake_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 2, y = 0})
                card.children.fake_front.states.hover = card.states.hover
                card.children.fake_front.states.click = card.states.click
                card.children.fake_front.states.drag = card.states.drag
                card.children.fake_front.states.collide.can = false
                card.children.fake_front:set_role({major = card, role_type = 'Glued', draw_major = card})
            return true end, 0, "akyrs_misc")
        end
    end,
    prefix_config = {
        atlas = false
    },
    atlas = "centers",
    pos = { x = 1, y = 0 }
}

AKYRS.FakeCenter{
    key = "judgement_miss",
    akyrs_credits = {
        art = {
            "tje.tsu"
        },
        attrib = {
            ["tje.tsu"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    prefix_config = {
    },
    atlas = "judgement",
    pos = { x = 0, y = 0 }
}


AKYRS.FakeCenter{
    key = "judgement_good",
    akyrs_credits = {
        art = {
            "tje.tsu"
        },
        attrib = {
            ["tje.tsu"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    prefix_config = {
    },
    atlas = "judgement",
    pos = { x = 1, y = 0 }
}

AKYRS.FakeCenter{
    key = "judgement_great",
    akyrs_credits = {
        art = {
            "tje.tsu"
        },
        attrib = {
            ["tje.tsu"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    prefix_config = {
    },
    atlas = "judgement",
    pos = { x = 2, y = 0 }
}

AKYRS.FakeCenter{
    key = "judgement_perfect",
    akyrs_credits = {
        art = {
            "tje.tsu"
        },
        attrib = {
            ["tje.tsu"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    prefix_config = {
    },
    atlas = "judgement",
    pos = { x = 3, y = 0 }
}

AKYRS.FakeCenter{
    key = "judgement_cperfect",
    akyrs_credits = {
        art = {
            "tje.tsu"
        },
        attrib = {
            ["tje.tsu"] = "art",
        },
    },
    loc_vars = function (self, info_queue, card)
        if card and card.area and AKYRS.is_in_typical_area(card.area) then
            info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_non_functional"]
        end
    end,
    prefix_config = {
    },
    atlas = "judgement",
    pos = { x = 4, y = 0 }
}
