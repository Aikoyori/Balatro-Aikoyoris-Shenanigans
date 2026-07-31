
local alphabet_digital_hallucinations_compat = {
	colour = HEX("3e63c2"),
	loc_key = "k_akyrs_plus_alphabet",
	create = function()
		local ccard = create_card("Alphabet", G.consumeables, nil, nil, nil, nil, nil, "diha")
		ccard:set_edition({ negative = true }, true)
		ccard:add_to_deck()
		G.consumeables:emplace(ccard)
	end,
}
local umbral_digital_hallucinations_compat = {
	colour = G.C.AKYRS_UMBRAL_P,
	loc_key = "k_akyrs_plus_umbral",
	create = function()
		SMODS.add_card{ set = "Umbral", edition = "e_negative" }
	end,
}
local replicant_digital_hallucinations_compat = {
	colour = G.C.AKYRS_UMBRAL_P,
	loc_key = "k_akyrs_plus_replicant",
	create = function()
		SMODS.add_card{ set = "Replicant", edition = "e_negative" }
	end,
}
local ease_bg_umbral = function(self)
    ease_background_colour({ new_colour = G.C.AKYRS_UMBRAL_P, special_colour = G.C.AKYRS_UMBRAL_P})
end

local ease_bg_replicant = function(self)
    ease_background_colour({ new_colour = G.C.AKYRS_REPLICANT_O, special_colour = G.C.AKYRS_REPLICANT_C})
end


SMODS.Booster{
    key = "letter_pack_1",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 0, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_2",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_3",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_4",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 3, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "jumbo_letter_pack_1",
    set = "Booster",
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_jumbo"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 4, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 6,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "jumbo_letter_pack_2",
    set = "Booster",
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_jumbo"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 5, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 6,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "mega_letter_pack_1",
    set = "Booster",
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_mega"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 6, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 8,
    select_card = 'consumeables',
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "mega_letter_pack_2",
    set = "Booster",
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_letter_pack_mega"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 7, y = 0 },
    group_key = "k_akyrs_alphabet_pack",
    cost = 8,
    select_card = 'consumeables',
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
-- umbral pack


SMODS.Booster{
    key = "umbral_pack_1",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 0, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 4,
    weight = 0.5,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "umbral_pack_2",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 4,
    weight = 0.5,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "umbral_pack_3",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 4,
    weight = 0.5,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "umbral_pack_4",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 3, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 4,
    weight = 0.5,
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    draw_hand = true,
    kind = "umbral_pack",
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "jumbo_umbral_pack_1",
    set = "Booster",
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_jumbo"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 4, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 6,
    weight = 0.5,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "jumbo_umbral_pack_2",
    set = "Booster",
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_jumbo"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 5, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 6,
    weight = 0.5,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "mega_umbral_pack_1",
    set = "Booster",
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_mega"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 6, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    cost = 8,
    weight = 0.125,
    draw_hand = true,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "mega_umbral_pack_2",
    set = "Booster",
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_umbral_pack_mega"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 7, y = 1 },
    group_key = "k_akyrs_umbral_pack",
    draw_hand = true,
    cost = 8,
    weight = 0.125,
    kind = "umbral_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Umbral", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_umbral,
    cry_digital_hallucinations = umbral_digital_hallucinations_compat,
}



SMODS.Booster{
    key = "replica_pack_1",
    set = "Booster",
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_replica_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 0, y = 2 },
    group_key = "k_akyrs_replica_pack",
    cost = 4,
    weight = 0.2,
    draw_hand = true,
    kind = "replica_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Replicant", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_replicant,
    cry_digital_hallucinations = replicant_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "replica_pack_2",
    set = "Booster",
    config = { extra = 4, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_replica_pack_normal"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 2 },
    group_key = "k_akyrs_replica_pack",
    cost = 4,
    weight = 0.2,
    draw_hand = true,
    kind = "replica_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Replicant", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_replicant,
    cry_digital_hallucinations = replicant_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "jumbo_replica_pack_1",
    set = "Booster",
    config = { extra = 4, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_replica_pack_jumbo"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 2 },
    group_key = "k_akyrs_replica_pack",
    cost = 6,
    weight = 0.2,
    draw_hand = true,
    kind = "replica_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Replicant", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_replicant,
    cry_digital_hallucinations = replicant_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "mega_replica_pack_1",
    set = "Booster",
    config = { extra = 4, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
            key = "p_akyrs_replica_pack_mega"
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 3, y = 2 },
    group_key = "k_akyrs_replica_pack",
    cost = 8,
    weight = 0.04,
    draw_hand = true,
    kind = "replica_pack",
    create_card = function (self, card, i) 
        return SMODS.create_card{ set = "Replicant", area = G.pack_cards, skip_materialize = true }
    end,
    ease_background_colour = ease_bg_replicant,
    cry_digital_hallucinations = replicant_digital_hallucinations_compat,
}