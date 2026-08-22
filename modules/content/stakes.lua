SMODS.Stake {
    key = "outer",
    atlas = "aikoStakes", pos = {x = 1, y = 1},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 1, y = 1},
    applied_stakes = {  },
    modifiers = function ()
        G.GAME.starting_params.hands = G.GAME.starting_params.hands + 1
    end
}

SMODS.Stake {
    key = "inner",
    atlas = "aikoStakes", pos = {x = 2, y = 1},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 2, y = 1},
    applied_stakes = {  },
    modifiers = function ()
        G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size + 1
    end
}

SMODS.Stake {
    key = "lime",
    atlas = "aikoStakes", pos = {x = 3, y = 1},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 3, y = 1},
    applied_stakes = { "white" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("a8ff50"),
    modifiers = function ()
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * 1.5
    end
}
SMODS.Stake {
    key = "lemon",
    atlas = "aikoStakes", pos = {x = 4, y = 1},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 4, y = 1},
    applied_stakes = { "white" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("f4e756"),
    modifiers = function ()
        G.GAME.modifiers.scaling = 2
    end
}
SMODS.Stake {
    key = "turquoise",
    atlas = "aikoStakes", pos = {x = 2, y = 2},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 2, y = 2},
    applied_stakes = { "akyrs_lime","akyrs_lemon" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("00ffff"),    
    modifiers = function ()
        G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + 1
    end
}
SMODS.Stake {
    key = "amethyst",
    atlas = "aikoStakes", pos = {x = 1, y = 0},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 1, y = 0},
    applied_stakes = { "akyrs_turquoise" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("d087ff"),
    calculate = function (self, context)
        if context.blind_defeated then
            local cards_with_no_crystals = AKYRS.filter_table(G.playing_cards, function (_card)
                return not _card.ability.akyrs_crystalised
            end)
            local c2a = pseudorandom_element(cards_with_no_crystals, "akyrs_amethyst_stake")
            if c2a then
                c2a:add_sticker('akyrs_crystalised', true)
            end
        end
    end,
    modifiers = function ()
        G.GAME.starting_params.hands = G.GAME.starting_params.hands + 1
    end
}
SMODS.Stake {
    key = "wooden",
    atlas = "aikoStakes", pos = {x = 0, y = 3},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 0, y = 3},
    applied_stakes = { "akyrs_amethyst" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("ad8455"),
    calculate = function (self, context)
        if context.setting_blind then
            AKYRS.simple_event_add(
                function ()
                    local _card = SMODS.add_card{ set = "Base", area = G.deck }
                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                    return true
                end
            )
        end
    end,
    modifiers = function ()
    end
}
SMODS.Stake {
    key = "bismuth",
    atlas = "aikoStakes", pos = {x = 3, y = 0},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 3, y = 0},
    applied_stakes = { "akyrs_wooden" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("72db94"),
    calculate = function (self, context)
    end,
    modifiers = function ()
        G.GAME.modifiers.akyrs_spawn_latticed = true
    end,
}

SMODS.Stake {
    key = "copper",
    atlas = "aikoStakes", pos = {x = 0, y = 0},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 0, y = 0},
    applied_stakes = { "akyrs_bismuth" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("d79458"),    
    modifiers = function ()
        G.GAME.modifiers.akyrs_spawn_oxidising = true
    end
}
SMODS.Stake {
    key = "high_contrast",
    atlas = "aikoStakes", pos = {x = 0, y = 1},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 0, y = 1},
    applied_stakes = { "akyrs_copper" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("f4ff12"),
    calculate = function (self, context)
    end,
    modifiers = function ()
        G.GAME.modifiers.scaling = 3
    end,
}
SMODS.Stake {
    key = "hydrogel",
    atlas = "aikoStakes", pos = {x = 4, y = 0},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 4, y = 0},
    applied_stakes = { "akyrs_high_contrast" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("ff87d8"),
    calculate = function (self, context)
        if context.blind_defeated then
            local candidates = AKYRS.filter_table(G.playing_cards, function (_card)
                return not _card.ability.akyrs_sus
            end)
            local c2a = pseudorandom_element(candidates, "akyrs_hydrogel_stake")
            if c2a then
                c2a:add_sticker('akyrs_sus', true)
            end
        end
    end,
    modifiers = function ()
        G.GAME.modifiers.scaling = 3
    end,
}
SMODS.Stake {
    key = "spotify",
    atlas = "aikoStakes", pos = {x = 1, y = 2},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 1, y = 2},
    applied_stakes = { "akyrs_hydrogel" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("60f78e"),
    calculate = function (self, context)
        if context.blind_defeated and G.GAME.blind.config.blind.boss then
            local cards_with_no_rental = AKYRS.filter_table(G.jokers.cards, function (_card)
                return not _card.ability.rental
            end)
            local c2a = pseudorandom_element(cards_with_no_rental, "akyrs_spotify_stake")
            if c2a then
                c2a:juice_up()
                c2a:add_sticker('rental', true)
            end
        end
    end,
    modifiers = function ()
        G.GAME.modifiers.scaling = 3
    end,
}
SMODS.Stake {
    key = "aluminium",
    atlas = "aikoStakes", pos = {x = 2, y = 0},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 2, y = 0},
    applied_stakes = { "akyrs_spotify" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("c4cbd9"),
    modifiers = function ()
        G.GAME.win_ante = G.GAME.win_ante + 1
    end,
}
SMODS.Stake {
    key = "steam",
    atlas = "aikoStakes", pos = {x = 3, y = 2},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 3, y = 2},
    applied_stakes = { "akyrs_aluminium" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("57829b"),
    modifiers = function ()
        G.GAME.modifiers.akyrs_spawn_steam_sale = true
    end,
}
SMODS.Stake {
    key = "netherite",
    atlas = "aikoStakes", pos = {x = 0, y = 2},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 0, y = 2},
    applied_stakes = { "akyrs_steam", "gold" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("3b3939"),
    modifiers = function ()
        G.GAME.starting_params.discards = G.GAME.starting_params.discards + 1
        G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + 2
    end,
}
SMODS.Stake {
    key = "doom",
    atlas = "aikoStakes", pos = {x = 4, y = 2},
    sticker_atlas = "aikoStakeStickers", sticker_pos = {x = 4, y = 2},
    applied_stakes = { "akyrs_netherite" },
    prefix_config = { applied_stakes = { mod = false } },
    colour = HEX("070707"),
    modifiers = function ()
        G.GAME.modifiers.akyrs_spawn_self_destruct = true
    end,
}