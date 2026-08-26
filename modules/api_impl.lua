-- this file contains implementation for crossmod-able APIs
-- for files with functions you can hook please look in api.lua

AKYRS.generate_icon_blinds = function(key, config)
    if not key then return end
    local z = config.table or {}
    local cache = config.cache or false
    local icon_size = config.icon_size or false
    local full_ui = config.full_ui or false
    local fsz = config.font_size or false
    local dfctysz = config.text_size_for_full or false
    local info_queue = config.info_queue or {}
    local sprite = nil
    local atlas, pos,mod_prefix = AKYRS.blind_icons_data(key)
    if cache then
        AKYRS.icon_sprites[key] = AKYRS.icon_sprites[key] or Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
        sprite = AKYRS.icon_sprites[key]
    else
        sprite = Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
    end
    local keyed = "dd_"..(mod_prefix and (mod_prefix.."_") or "")..key
    z[#z+1] = {
        n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = full_ui and "lc" or "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[keyed] },
        nodes = {
            {n=G.UIT.O, config={object = sprite, scale = fsz}},
        }
    }
    if full_ui then
        AKYRS.full_ui_add(z[#z].nodes, keyed, dfctysz)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies[keyed]
    end
end

AKYRS.generate_difficulty_icons = function(diff, config)

    if not diff then return end
    local z = config.table or {}
    local cache = config.cache or false
    local icon_size = config.icon_size or false
    local atlas, pos, mod_prefix = AKYRS.blind_icons_data(diff)
    local full_ui = config.full_ui or false
    local fsz = config.font_size or false
    local dfctysz = config.text_size_for_full or false
    local info_queue = config.info_queue or {}
    local sprite = nil
    if cache then
        AKYRS.icon_sprites[diff] = AKYRS.icon_sprites[diff] or Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
        sprite = AKYRS.icon_sprites[diff]
    else
        sprite = Sprite(0,0,1*icon_size,1*icon_size, atlas, pos)
    end
    local blind_txt_dmy = "dd_"..(mod_prefix and (mod_prefix.."_") or "")..diff.."_blind"
    z[#z+1] = {
        n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[blind_txt_dmy]},
        nodes = {
            {n=G.UIT.O, config={object = sprite, scale = fsz}},
        }
    }
    if full_ui then
        AKYRS.full_ui_add(z[#z].nodes, blind_txt_dmy, dfctysz)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies[blind_txt_dmy]
    end
end
---@class AKYRS.HardcoreChallenge: SMODS.Challenge 
---@field stake string stake
---@field difficulty number difficulty
---@overload fun(self: AKYRS.HardcoreChallenge): AKYRS.HardcoreChallenge
AKYRS.HardcoreChallenge = SMODS.Challenge:extend {
    obj_table = AKYRS.HC_CHALLENGES,
    obj_buffer = AKYRS.HC_CHALLENGES_BUFFER,
    get_obj = function(self, key)
        for _, v in ipairs(AKYRS.HC_CHALLENGES) do
            if v.id == key then return v end
        end
    end,
    set = "Challenge",
    required_params = {
        'key',
    },
    akyrs_is_hardcore = true,
    deck = { type = "Hardcore Challenge Deck" },
    rules = { custom = {}, modifiers = {} },
    jokers = {},
    consumeables = {},
    vouchers = {},
    restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
    unlocked = function(self) return true end,
    class_prefix = 'hc',
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.misc.hardcore_challenge_names, self.key, self.loc_txt, 'name')
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.id = self.key
        -- only needs to be called once
        SMODS.insert_pool(AKYRS.HC_CHALLENGES, self)
        SMODS.Challenge.super.register(self)
    end,
    inject = function(self) end,
}



AKYRS.add_blind_extra_info = function(blind,ability_text_table,extras)
    extras = extras or {}
    local icon_size = extras.icon_size or 0.5
    local fsz = extras.text_size or 0.5
    local dfctysz = extras.difficulty_text_size or 0.5
    local bsz = extras.border_size or 1
    local set_parent_child = extras.set_parent_child or false
    local cache = extras.cached_icons or false
    local full_ui = extras.full_ui or false
    local hide = extras.hide or {  }
    local row = extras.row or false
    local info_queue = extras.info_queue or {}
    local z = {}
    local data = {table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue}

    if blind and blind.debuff then
        if blind.debuff.akyrs_blind_difficulty and not hide.difficulty then
            AKYRS.generate_difficulty_icons(blind.debuff.akyrs_blind_difficulty, data)
        end
        if blind.debuff.akyrs_is_forgotten_blind and not hide.forgotten_blind then
            AKYRS.generate_icon_blinds("forgotten_blind",data)
        end
        if blind.debuff.akyrs_cannot_be_disabled and not hide.disabled then
            AKYRS.generate_icon_blinds("no_disabling",data)
        end
        if blind.debuff.akyrs_cannot_be_rerolled and not hide.reroll then
            AKYRS.generate_icon_blinds("no_reroll",data)
        end
        if blind.debuff.akyrs_is_word_blind and not hide.word_blind then
            AKYRS.generate_icon_blinds("word_blind",data)
        end
        if blind.debuff.akyrs_is_puzzle_blind and not hide.puzzle_blind then
            AKYRS.generate_icon_blinds("puzzle_blind",data)
        end
        if blind.debuff.akyrs_is_endless_blind and not hide.endless_blind then
            AKYRS.generate_icon_blinds("endless_blind",data)
        end
        if blind.debuff.akyrs_is_postwin_blind and not hide.postwin_blind then
            AKYRS.generate_icon_blinds("postwin_blind",data)
        end
        if blind.debuff.akyrs_cannot_be_overridden and not hide.no_overriding then
            AKYRS.generate_icon_blinds("no_overriding",data)
        end
        if blind.debuff.akyrs_cannot_be_skipped and not hide.no_overriding then
            AKYRS.generate_icon_blinds("no_skipping",data)
        end
        AKYRS.other_mods_blind_icons(blind,ability_text_table,extras, data)
    end
    if z and #z > 0 and blind and ability_text_table then
        local xd = {
            n = full_ui and G.UIT.R or G.UIT.R,
            config = { align = "cm", padding = 0.1, can_collide = true, hover = true},
            nodes = z
        }
        if set_parent_child then
            ability_text_table.UIBox:set_parent_child(xd, ability_text_table)
            --print("CHILD = "..#ability_text_table.children)
            ability_text_table.UIBox:recalculate()
        else
            ability_text_table[#ability_text_table+1] = xd
        end
    end
    if z then return z end
end


local int_checks = {["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true, }

function AKYRS.get_sprite_for_letter(card, letter) -- quote on quote, can actually be any length, returns G.ASSET_ATLAS[youatlas], pos
    if not letter then return end
    if aiko_alphabets_to_num_no_wild[string.lower(letter)] then
        local i = aiko_alphabets_to_num_no_wild[string.lower(letter)]
        if letter:upper() == letter then -- this is for uppercase
            return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = math.floor((i - 1) / 10) }
        else
            return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 3 + math.floor((i - 1) / 10) } 
        end
    end
    if letter == "#" then
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 6, y = 2 }
    end
    if int_checks[letter] then
        local v = tonumber(letter)
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = v, y = 6 }
    end
    if AKYRS.non_letter_symbols_reverse[letter] then
        local i = AKYRS.non_letter_symbols_reverse[letter]
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 7 + math.floor((i - 1) / 10) }
    end
    if AKYRS.other_mods_get_sprite_for_letter(card, letter) then
        return AKYRS.other_mods_get_sprite_for_letter(card, letter)
    end
end


AKYRS.blind_icons_data = function (key)
    
    if key == "expert" then          return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 0, y = 1}, "akyrs" end
    if key == "master" then          return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 1, y = 1}, "akyrs" end
    if key == "ultima" then          return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 2, y = 1}, "akyrs" end
    if key == "remaster" then        return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 3, y = 1}, "akyrs" end
    if key == "lunatic" then         return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 4, y = 1}, "akyrs" end
    if key == "dx" then              return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 0, y = 2}, "akyrs" end
    if key == "no_reroll" then       return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 0, y = 0}, "akyrs" end
    if key == "no_disabling" then    return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 1, y = 0}, "akyrs" end
    if key == "no_face" then         return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 2, y = 0}, "akyrs" end
    if key == "forgotten_blind" then return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 5, y = 1}, "akyrs" end
    if key == "word_blind" then      return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 6, y = 1}, "akyrs" end
    if key == "puzzle_blind" then    return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 7, y = 1}, "akyrs" end
    if key == "postwin_blind" then   return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 8, y = 1}, "akyrs" end
    if key == "endless_blind" then   return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 9, y = 1}, "akyrs" end
    if key == "no_overriding" then   return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 1, y = 2}, "akyrs" end
    if key == "no_skipping" then     return  G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], { x = 2, y = 2}, "akyrs" end
    if AKYRS.other_mods_blind_icons_pos(key) then return AKYRS.other_mods_blind_icons_pos(key) end
    return G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"], {x = 9, y = 9}, "akyrs"
end


AKYRS.suit_to_atlas = function (suit_key, card)

    local deckskin = SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[suit_key]]
    local palette = deckskin.palette_map and deckskin.palette_map[G.SETTINGS.colour_palettes[suit_key] or ''] or (deckskin.palettes or {})[1]
    if palette then
        if palette.akyrs_pure_suit then
            return G.ASSET_ATLAS[palette.akyrs_pure_suit.atlas_key], palette.akyrs_pure_suit.pos 
        end
    end
    local is_hc = G.SETTINGS.colour_palettes[suit_key] == "hc"
    if suit_key == "Hearts" then
        -- print("<3")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (is_hc and 4 or 0), y = 0}
    end
    if suit_key == "Clubs" then
        -- print("|-8o")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (is_hc and 5 or 1), y = 0}
    end
    if suit_key == "Diamonds" then
        -- print("<>")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (is_hc and 6 or 2), y = 0}
    end
    if suit_key == "Spades" then
        -- print("|-C>")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (is_hc and 7 or 3), y = 0}
    end
    -- if mod dev is reading this i am open to having your stuff be here if you wanna so contact me
    -- btw art done by papermoon from paperback
    if suit_key == "paperback_Stars" then
        return G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 0, y = (is_hc and 1 or 0)}
    end
    if suit_key == "paperback_Crowns" then
        return G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 1, y = (is_hc and 1 or 0)}
    end
    if SMODS.Suits[suit_key] and SMODS.Suits[suit_key].akyrs_pure_suit_atlas then
        return G.ASSET_ATLAS[SMODS.Suits[suit_key].akyrs_pure_suit_atlas.atlas_key], SMODS.Suits[suit_key].akyrs_pure_suit_atlas.pos 
    end
    if AKYRS.other_mods_suit_to_atlas(suit_key, card) then
        return AKYRS.other_mods_suit_to_atlas(suit_key, card)
    end
    if AKYRS_CROSSMOD.suit_to_atlas_map[suit_key] then
        local t = AKYRS_CROSSMOD.suit_to_atlas_map[suit_key]
        if type(t) == "function" then
            return t(suit_key, card)
        end
        if type(t) == "table" then
            local a, p = unpack(t)
            if type(a) == "string" then
                return G.ASSET_ATLAS[a], p
            end
            return a, p
        end
    end
    return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 8, y = 0}
end
AKYRS.rank_to_atlas = function (rank_key, card)
    
    if SMODS.Ranks[rank_key] and SMODS.Ranks[rank_key].akyrs_pure_rank_atlas then
        return G.ASSET_ATLAS[SMODS.Ranks[rank_key].akyrs_pure_rank_atlas.atlas_key], SMODS.Ranks[rank_key].akyrs_pure_rank_atlas.pos 
    end
    if rank_key == "Jack" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 9, y = 0}
    end
    if rank_key == "Queen" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 10, y = 0}
    end
    if rank_key == "King" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 11, y = 0}
    end
    if rank_key == "Ace" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 0, y = 1}
    end
    -- if mod dev is reading this i am open to having your stuff be here if you wanna so contact me
    if rank_key == "paperback_Apostle" then
        return G.ASSET_ATLAS['akyrs_paperback_pure'], { x = 2, y = 0}
    end
    --          nan check v                           
    if tonumber(rank_key) and (tonumber(rank_key) == tonumber(rank_key)) and tonumber(rank_key) >= 2 and tonumber(rank_key) <= 10 then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 11 - tonumber(rank_key), y = 1}
    end
    if AKYRS.other_mods_rank_to_atlas(rank_key, card) then
        return AKYRS.other_mods_rank_to_atlas(rank_key, card)
    end
    if AKYRS_CROSSMOD.rank_to_atlas_map[rank_key] then
        local t = AKYRS_CROSSMOD.rank_to_atlas_map[rank_key]
        if type(t) == "function" then
            return t(rank_key, card)
        end
        if type(t) == "table" then
            local a, p = unpack(t)
            if type(a) == "string" then
                return G.ASSET_ATLAS[a], p
            end
            return a, p
        end
    end
    return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 10, y = 1}
end

-- below are how i do them

AKYRS.plural_centers = function(word)
    if word == "jokers" then return "joker" end
    if word == "cards" then return "card" end
    if word == "enhanceds" then return "enhanced" end
    if word == "vouchers" then return "voucher" end
    if word == "tarots" then return "tarot" end
    if word == "planets" then return "planet" end
    if word == "spectrals" then return "spectral" end
    if word == "umbrals" then return "umbral" end
    if word == "replicants" then return "replicant" end
    if AKYRS.other_mods_plural_centers(word) then return AKYRS.other_mods_plural_centers(word) end
    return nil
end

function AKYRS.is_star(center_key)
    if center_key == "c_star" then return true end
    if center_key == "c_mf_rot_star" then return true end
    return AKYRS.other_mods_is_star(center_key)
end

function AKYRS.maxwell_card_to_area_map(word)
    local count = 1
    local center = G.P_CENTER_POOLS.Tarot
    local area = G.consumeables
    local centerName = nil
    if word == "joker" or word == "jokers" then
        area = G.jokers
        center = G.P_CENTER_POOLS.Joker
        centerName = "Joker"
    end
    if word == "card" or word == "cards" then
        area = G.deck
        center = G.P_CARDS
        centerName = "Cards"
    end
    if word == "enhanced" or word == "enhanceds"  then
        area = G.deck
        center = G.P_CENTER_POOLS.Enhanced
    end
    if word == "tarot" or word == "tarots" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Tarot
        centerName = "Tarot"
    end
    if word == "planet" or word == "planets" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Planet
        centerName = "Planet"
    end
    if word == "spectral" or word == "spectrals" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Spectral
        centerName = "Spectral"
    end
    if word == "umbral" or word == "umbrals" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Umbral
        centerName = "Umbral"
    end
    if AKYRS.other_mods_maxwell_card_to_area_map(word) then
        area, center, centerName = AKYRS.other_mods_maxwell_card_to_area_map(word)
    end
    if AKYRS.plural_centers(word) then
        count = count + pseudorandom(pseudoseed("maniwishiwassleeping"),0,9)
    end
    return center,area,count,centerName
end

-- why the fuck is it in an if else !!! WTF???

function AKYRS.maxwell_word_to_edition_map(word)
    if word == "neg" or word == "negs" or word == "negative" or word == "negatives" then return "Negative","e_negative" end
    if word == "holo" or word == "holos" or word == "holographic" or word == "holographics" then return "Holographic","e_holo" end
    if word == "poly" or word == "polies" or word == "polychrome" or word == "polychromes" then return "Polychrome","e_polychrome" end
    if word == "foil" or word == "foils" or word == "foiled" or word == "foileds" then return "Foil","e_foil" end
    if word == "sliced" then return "akyrs_sliced","e_akyrs_sliced" end
    if word == "noir" then return "akyrs_noire","e_akyrs_noire" end
    if word == "texel" then return "akyrs_texelated","e_akyrs_texelated" end
    if word == "burnt" or word == "burned" or word == "flame" then return "akyrs_burnt","e_akyrs_burnt" end
    if word == "charged" or word == "powered" or word == "energized" or word == "energised" then return "akyrs_charged","e_akyrs_charged" end
    if AKYRS.other_mods_word_to_edition_map(word) then return AKYRS.other_mods_word_to_edition_map(word) end
    return nil,nil
end

function AKYRS.maxwell_word_to_enhancement_map(word)
    if word == "gold" or word == "golden" or word == "aurum" or word == "aurums" or word == "golds" or word == "goldens" or word == "shiny" then
        return G.P_CENTERS.m_gold
    end
    if word == "iron" or word == "steel" or word == "reinforced" or word == "irons" or word == "galvanised" or word == "galvanized" or word == "stainless" then
        return G.P_CENTERS.m_steel
    end
    if word == "rock" or word == "rocky" or word == "stone" or word == "stoned" or word == "pebble" or word == "rocked" or word == "hard" then
        return G.P_CENTERS.m_stone
    end
    if word == "lucky" or word == "clover" or word == "chance" or word == "gambling" or word == "lucked" or word == "luckier" or word == "luckiest" then
        return G.P_CENTERS.m_lucky
    end
    if word == "glass" or word == "glasses" or word == "shatter" or word == "shatters" or word == "break" or word == "breaks" or word == "fragile" or word == "silicon" then
        return G.P_CENTERS.m_glass
    end
    if word == "wild" or word == "wildcard" or word == "any" or word == "all" or word == "every" or word == "able" or word == "bewildered" then
        return G.P_CENTERS.m_wild
    end
    if word == "multiply" or word == "mult" or word == "red" or word == "ding" then
        return G.P_CENTERS.m_mult
    end
    if word == "chips" or word == "chip" or word == "blue" or word == "blip" or word == "bonus" then
        return G.P_CENTERS.m_bonus
    end
    if word == "brick" or word == "heavy" or word == "bonk" or word == "throw" then
        return G.P_CENTERS["m_akyrs_brick_card"]
    end
    if word == "scoreless" then
        return G.P_CENTERS["m_akyrs_scoreless"]
    end
    if word == "base" or word == "plain" or word == "boring" or word == "nothing" or word == "undo" or word == "remove" or word == "delete" then
        return G.P_CENTERS.c_base
    end
    if word == "ash" then
        return G.P_CENTERS["m_akyrs_ash_card"]
    end
    if word == "?" or word == "what" or word == "wtf" or word == "huh" then
        return G.P_CENTERS["m_akyrs_hatena"]
    end
    if word == "item" or word == "box" or word == "kart" then
        return G.P_CENTERS["m_akyrs_item_box"]
    end
    if word == "insolate" then
        return G.P_CENTERS["m_akyrs_item_box"]
    end
    if word == "canopy" or word == "plant" or word == 'tree' or word == 'tress' or word == 'forest' or word == 'forests' then
        return G.P_CENTERS["m_akyrs_canopy_card"]
    end
    if word == "thailand" or word == "thai" then
        return G.P_CENTERS["m_akyrs_thai_tea_card"]
    end
    if word == "matcha" then
        return G.P_CENTERS["m_akyrs_matcha_card"]
    end
    if word == "grey" then
        return G.P_CENTERS["m_akyrs_earl_grey_tea_card"]
    end
    if word == "net" then
        return G.P_CENTERS["m_akyrs_net_card"]
    end
    if word == "droplet" or word == "droplets" then
        return G.P_CENTERS["m_akyrs_droplet_card"]
    end
    if word == "zap" or word == "zappy" or word == "electric" or word == "electricity" or word == "electricities" then
        return G.P_CENTERS["m_akyrs_zap_card"]
    end
    if word == "semibreve" then
        return G.P_CENTERS["m_akyrs_semibreve_card"]
    end
    if word == "minim" then
        return G.P_CENTERS["m_akyrs_minim_card"]
    end
    if word == "crotchet" then
        return G.P_CENTERS["m_akyrs_crotchet_card"]
    end
    if word == "wafer" then
        return G.P_CENTERS["m_akyrs_wafer_card"]
    end
    if word == "shore" or word == "beach" then
        return G.P_CENTERS["m_akyrs_shore_card"]
    end
    if word == "cloud" or word == "cloudy" then
        return G.P_CENTERS["m_akyrs_cloud_card"]
    end
    if word == "nightshade" then
        return G.P_CENTERS["m_akyrs_nightshade_card"]
    end
    if AKYRS.other_mods_word_to_enhancement_map(word) then
        return AKYRS.other_mods_word_to_enhancement_map(word)
    end
    return nil
end


function AKYRS.maxwell_enhance_card(enhancement, context)
    local axd = AKYRS.capitalize(enhancement)
    local da,baby = AKYRS.maxwell_word_to_edition_map(enhancement)
    --print(da)
    --print(baby)
    if (da) then
        context.other_card:set_edition(baby, false, false)
    end

    if (AKYRS.maxwell_word_to_enhancement_map(enhancement)) then
        context.other_card:set_ability(AKYRS.maxwell_word_to_enhancement_map(enhancement),nil,true)
    end
end


function AKYRS.maxwell_generate_card(cardtype, context)

    local center,area,count,name = AKYRS.maxwell_card_to_area_map(string.lower(cardtype))
    for i = 1, count do
        if name == "Cards" then
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
            local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
            area:emplace(carder)
            table.insert(G.playing_cards, carder)
        elseif area == G.deck then
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
            local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, pseudorandom_element(G.P_CENTER_POOLS.Enhanced,pseudoseed("maxwellrandom")), {playing_card = G.playing_card})
            area:emplace(carder)
            table.insert(G.playing_cards, carder)
        elseif name then
            --print(cardtype)
            --print(name)
            pcall(function()
                if area and AKYRS.has_room(area) then
                    
                    local carder = create_card(name, area, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                    if carder then
                        area:emplace(carder)
                    end
                end
            end)
        end 
    end

end

function AKYRS.scenario_modifiers(value, typer)
    G.GAME.AKYRS_SCENARIOS = G.GAME.AKYRS_SCENARIOS or {}
    if typer == "cloud" and G.GAME.AKYRS_SCENARIOS then
        return value * 2
    end
    return value
end