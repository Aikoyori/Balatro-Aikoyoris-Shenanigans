local aikoyori_mod_config = SMODS.current_mod.config

aikoyori_mod_config.wildcard_behaviour = aikoyori_mod_config.wildcard_behaviour or 1

function AKYRS.table_contains(tbl, x)
    local found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end


AKYRS.aiko_pickRandomInTable = function(t)
    return t[math.random(1, #t)]
end

aiko_alphabets = {}
aiko_alphabets_no_wilds = {}
aiko_alphabets_to_num = {}
for i = 97, 122 do
    table.insert(aiko_alphabets, string.char(i))
    table.insert(aiko_alphabets_no_wilds, string.char(i))
    aiko_alphabets_to_num[string.char(i)] = i - 96
end
table.insert(aiko_alphabets,"#")
aiko_alphabets_to_num["#"] = 27

function AKYRS.alphabet_delta(alpha, delta)
    local numero = string.byte(alpha) + delta
    while numero < string.byte(' ') do
        numero = numero + 95
    end
    if numero > string.byte('~') then
        numero = (numero - string.byte(' ')) % 95 + string.byte(' ')
    end
    return string.char(numero)
end

card_suits = {}
card_suits_with_meta = {}
card_ranks = {}
card_rank_numbers = {}
card_ranks_with_meta = {}

for k, v in pairs(SMODS.Ranks) do
    table.insert(card_ranks_with_meta,v)
end

table.sort(card_ranks_with_meta, function(s1,s2)
    --print("COMPARING "..s1.key.." and "..s2.key)
    return s1.sort_nominal < s2.sort_nominal
end)

for i, v in pairs(card_ranks_with_meta) do
    table.insert(card_ranks,v.key)
    card_rank_numbers[v.key] = i
    --print(v.key,i)
end


for k, v in pairs(SMODS.Suits) do
    table.insert(card_suits, k)
    table.insert(card_suits_with_meta, v)
end

function AKYRS.getNextIDs(id)
    nexts = {}
    if(card_ranks_with_meta[id]) then
            --print(table_to_string(card_ranks_with_meta[id]))
        for i, v in ipairs(card_ranks_with_meta[id].next) do
            table.insert(nexts,card_rank_numbers[v]) 
        end
    end
    --print(table_to_string(nexts))
    return nexts
end


function AKYRS.aiko_intersect_table(a,b)
    local ai = {}
    for _,v in ipairs(a) do
        ai[v] = true
    end
    local ret = {}
    for _,v in ipairs(b) do
        if ai[v] then
            ret[#ret + 1] = v
        end
    end
    return ret
end


function AKYRS.concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function AKYRS.getFirstElementOfTable(t)
    for k, v in pairs(t) do
        return v
    end
end

function AKYRS.getFirstKeyOfTable(t)
    for k, v in pairs(t) do
        return k
    end
end


AKYRS.pickableSuit = { "S", "H", "C", "D" }
AKYRS.pickableRank = { "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" }
AKYRS.rankToNumber = { ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["T"] = 10,
   ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14 }
function AKYRS.concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

AKYRS.allTarotExceptWheel = {}
-- symbols
AKYRS.non_letter_symbols = {
    "_", "-", "@", "!", "?", "+", "/", "\\", "*", ".", "'", '"', "&", " ", ":", ";", "=", ",", "(",")","[","]","{","}","$","%","^", "`", "~", "|", "<", ">"
}
AKYRS.non_letter_symbols_reverse = {}
for _, symbol in ipairs(AKYRS.non_letter_symbols) do
    AKYRS.non_letter_symbols_reverse[symbol] = true
end


function AKYRS.aiko_mod_startup(self)
    if not self then return end
    if not AKYRS.aikoyori_letters_stickers then
        AKYRS.aikoyori_letters_stickers = {}
    end
    for i, v in ipairs(aiko_alphabets_no_wilds) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v:upper()] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = math.floor((i - 1) / 10) })
        AKYRS.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 3 + math.floor((i - 1) / 10) })
    end
    AKYRS.aikoyori_letters_stickers["#"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 6, y = 2 })
    AKYRS.aikoyori_letters_stickers["correct"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 7, y = 2 })
    AKYRS.aikoyori_letters_stickers["misalign"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 8, y = 2 })
    AKYRS.aikoyori_letters_stickers["incorrect"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 9, y = 2 })
    for v = 0, 9 do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v..""] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (v) % 10, y = 6 + math.floor((v) / 10) })
    end
    for i, v in ipairs(AKYRS.non_letter_symbols) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 7 + math.floor((i - 1) / 10) })
    end
    
end


function AKYRS.randomCard()
    local suit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    local rank =AKYRS.aiko_pickRandomInTable(AKYRS.pickableRank)
    return suit .. "_" .. rank
end

function AKYRS.randomSameRank(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    while newSuit == suit do
        newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    end
    return newSuit .. "_" .. rank
end

function AKYRS.randomSameSuit(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank =AKYRS.aiko_pickRandomInTable(AKYRS.pickableRank)
    while newRank == rank do
        newRank = AKYRS.pickableRank[math.random(1, 13)]
    end
    return suit .. "_" .. newRank
end

function AKYRS.randomConsecutiveRank(cardCode, up, randomSuit)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = rank
    newRank = AKYRS.pickableRank[math.fmod(AKYRS.rankToNumber[rank] - 1, #AKYRS.pickableRank) + 1]
    if randomSuit then
        local newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
        while newSuit == suit do
            newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
        end
        return newSuit .. "_" .. newRank
    else
        return suit .. "_" .. newRank
    end
end

function table_to_string(tables)
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string(stra).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end
function table_to_string_depth(tables, depth)
    if depth == 0 then
        local keys = ""
        for k, _ in pairs(tables) do
            keys= keys..k..":k , "
        end
        return "["..#tables.."]"
    end
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string_depth(stra, depth - 1).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end

function getSpecialBossBlindText(key)
    if (key == "bl_akyrs_the_thought") then
        return {localize("ph_aiko_beat_puzzle"),localize("ph_word_puzzle")}
    else
        return {localize("ph_akyrs_unknown"),localize("ph_akyrs_unknown")}
    end
end
function getGameOverBlindText()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key then
        if (G.GAME.blind.config.blind.key == "bl_akyrs_the_thought") then
            return string.upper(G.GAME.word_todo)
        else
            return "?????"
        end
    else
        return "?????"
    end
end

function AKYRS.isBlindKeyAThing(inta)
    local comp = inta or G.GAME.blind
    return comp and comp.config and comp.config.blind and comp.config.blind.key and true or nil
end
function AKYRS.getBlindKeySafe(inta)
    local comp = inta or G.GAME.blind
    return comp and comp.config and comp.config.blind and comp.config.blind.key or ""
end

function AKYRS.checkBlindKey(blind_key)
    if AKYRS.isBlindKeyAThing() and blind_key == G.GAME.blind.config.blind.key then
        return true
    end
    return false
end

AKYRS.get_speed_mult = function(card)
    return ((card and (card.area == G.jokers or
        card.area == G.consumeables or
        card.area == G.hand or 
        card.area == G.play or
        card.area == G.shop_jokers or 
        card.area == G.shop_booster or
        card.area == G.load_shop_vouchers
    )) and G.SETTINGS.GAMESPEED) or 1
end

-- credit to nh6574 for helping with this bit
AKYRS.card_area_preview = function(cardArea, desc_nodes, config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local original_card = config.original_card or AKYRS.current_hover_card or nil
    local speed_mul = config.speed or AKYRS.get_speed_mult(original_card)
    local card_limit = config.card_limit or #config.cards or 1
    local override = config.override or false
    local cards = config.cards or {}
    local padding = config.padding or 0.07
    local func_after = config.func_after or nil
    local init_delay = config.init_delay or 1
    local func_list = config.func_list or nil
    local func_delay = config.func_delay or 0.2
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local scale = config.scale or 1
    local type = config.type or "title"
    local box_height = config.box_height or 0
    local highlight_limit = config.highlight_limit or 0
    if override or not cardArea then
        cardArea = CardArea(
            G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
            , width * G.CARD_W, height * G.CARD_H,
            {card_limit = card_limit, type = type, highlight_limit = highlight_limit, collection = true,temporary = true}
        )
        for i, card in ipairs(cards) do
            card.T.w = card.T.w * scale
            card.T.h = card.T.h * scale
            card.VT.h = card.T.h
            card.VT.h = card.T.h
            local area = cardArea
            if(card.config.center) then
                -- this properly sets the sprite size <3
                card:set_sprites(card.config.center)
            end
            area:emplace(card)
        end
    end
    local uiEX = {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, minh = box_height },
        nodes = {
            {n = G.UIT.O, config = { object = cardArea }}
        }
    }
    if cardArea then
        if desc_nodes then
            desc_nodes[#desc_nodes+1] = {
                uiEX
            }
        end
    end
    if func_after or func_list then 
        G.E_MANAGER:clear_queue("akyrs_desc")
    end
    if func_after then 
        G.E_MANAGER:add_event(Event{
            delay = init_delay * speed_mul,
            blockable = false,
            trigger = "after",
            func = function ()
                func_after(cardArea)
                return true
            end
        },"akyrs_desc")
    end
    
    if func_list then 
        for i, k in ipairs(func_list) do
            G.E_MANAGER:add_event(Event{
                delay = func_delay * i * speed_mul,
                blockable = false,
                trigger = "after",
                func = function ()
                    k(cardArea)
                    return true
                end
            },"akyrs_desc")
        end
    end
    return uiEX
end

AKYRS.temp_card_area = CardArea(
    -99990,-99990,0,0,
    {card_limit = 999999, type = 'title', highlight_limit = 0, collection = true}
)

AKYRS.create_random_card = function(seed)
    return Card(0,0, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS,pseudoseed(seed)), G.P_CENTERS.c_base)
end


function AKYRS.change_base_skip(card, suit, rank)
    if not card then return false end
    local _suit = SMODS.Suits[suit or card.base.suit]
    local _rank = SMODS.Ranks[rank or card.base.value]
    if not _suit or not _rank then
        sendWarnMessage(('Tried to call SMODS.change_base with invalid arguments: suit="%s", rank="%s"'):format(suit, rank), 'Util')
        return false
    end
    card:set_base(G.P_CARDS[('%s_%s'):format(_suit.card_key, _rank.card_key)], true)
    return card
end

function AKYRS.embedded_ui_sprite( sprite_atlas, sprite_pos, desc_nodes, config )
    if not config then config = {} end
    local sprite_atli = G.ASSET_ATLAS[sprite_atlas]
    local height = config.h or sprite_atli.py
    local width = config.w or sprite_atli.px
    local scale = config.scale or 1
    local padding = config.padding or 0.07
    local rounded = config.rounded or 0.1
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local box_height = config.box_height or 0
    local aspect_ratio = sprite_atli.px / sprite_atli.py
    local longer_value = math.max(sprite_atli.px, sprite_atli.py)
    local sprt = Sprite(
        G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
        ,width*scale/(aspect_ratio*longer_value), height*scale/(aspect_ratio*longer_value),
        sprite_atli, sprite_pos
    )
    local uiEX = 
    {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, minh = box_height, r = rounded },
        nodes = {
            {n = G.UIT.O, config = { object = sprt }}
        }
    }
    if desc_nodes then
        desc_nodes[#desc_nodes+1] = {uiEX}
    end
    return uiEX
end
AKYRS.mod_card_values = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local reference = config.reference or table_in
    local function modify_values(table_in, ref)
        for k, v in pairs(table_in) do
            if type(v) == "number" then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] then
                        table_in[k] = (ref[k] + add) * multiply
                    end
                end
            elseif type(v) == "table" and ref and k then
                modify_values(v, ref[k])
            end
        end
    end
    if table_in == nil then
        return
    end
    modify_values(table_in, reference)
end

AKYRS.mod_card_values_misprint = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local base = config.base or 5
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local reference = config.reference or table_in
    local random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. " - " .. "modcardvalue"
    local function modify_values(table_in, ref)
        for k, v in pairs(table_in) do
            if type(v) == "number" then
                if ref and ref[k] and not unkeyword[k] then
                    local a = pseudorandom(pseudoseed(random_seed.."a"))
                    local b = pseudorandom(pseudoseed(random_seed.."b"))
                    -- Exp-normal distributed random numbers
                    local factor = math.pow(base, math.sqrt(-2 * math.log(a)) * math.cos(2 * math.pi * b))
                    local res = ref[k] * factor
                    if k == "max_highlighted" then
                        res = math.ceil(res)
                    end
                    table_in[k] = res
                end
            elseif type(v) == "table" and ref and k then
                modify_values(v, ref[k])
            end
        end
    end
    if table_in == nil then
        return
    end
    local min_highlighted = table_in.min_highlighted
    modify_values(table_in, table_in)
    if min_highlighted then
        table_in.min_highlighted = table_in.max_highlighted
    end
end


AKYRS.deep_copy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[AKYRS.deep_copy(orig_key)] = AKYRS.deep_copy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

AKYRS.get_default_ability = function(key)
    return G.P_CENTERS[key] and G.P_CENTERS[key].config or {}
end

AKYRS.word_splitter = function(word)
    
    local wordArray = {}
    for i = 1, #word do
      table.insert(wordArray, word:sub(i, i))
    end
    return wordArray
end
AKYRS.word_to_cards = function(word)
    
    local wordArray = AKYRS.word_splitter(word)
    local cards = {}
    for i, k in ipairs(wordArray) do
      local new_c = AKYRS.create_random_card("maxwellui")
      new_c.is_null = true
      new_c.ability.aikoyori_letters_stickers = k
      new_c.ability.forced_letter_render = true
      table.insert(cards, new_c)
    end
    return cards
end

SMODS.Gradient{
    key = "akyrs_mod_title",
    colours = {
        HEX("ef4444"),
        HEX("eab308"),
        HEX("2dd4bf"),
    },
    cycle = 5
}

SMODS.Gradient{
    key = "akyrs_unset_letter",
    colours = {
        G.C.GREEN,
        G.C.BLUE,
        G.C.RED,
    },
    cycle = 1
}

AKYRS.HardcoreChallenge = SMODS.Challenge:extend {
    obj_table = AKYRS.HC_CHALLENGES,
    obj_buffer = {},
    get_obj = function(self, key)
        for _, v in ipairs(AKYRS.HC_CHALLENGES) do
            if v.id == key then return v end
        end
    end,
    set = "Challenge",
    required_params = {
        'key',
    },
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

function AKYRS.find_stake_from_level(level)
    for i, k in pairs(G.P_STAKES) do 
        if k.stake_level == level then
            return i, k
        end
    end
    return nil, nil
end

AKYRS.crypternity = function (e)
    if Cryptid then 
        e.stickers = {"cry_absolute"}
    else
        e.eternal = true
    end
    return e
end

AKYRS.swap_case = function (word)
    if not word then return nil end
    local swapped = ""
    for i = 1, #word do
        local c = word:sub(i, i)
        if c:match("%l") then
            swapped = swapped .. c:upper()
        elseif c:match("%u") then
            swapped = swapped .. c:lower()
        else
            swapped = swapped .. c
        end
    end
    return swapped
end

local uppercaser = {
    ["`"] = "~",
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    [";"] = ":",
    ["'"] = '"',
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["\\"] = "|",
    ["["] = "{",
    ["]"] = "}",
}

function AKYRS.get_shifted_from_key(key)
    local k = key
    if key and uppercaser[key] then 
        k = uppercaser[key]
    elseif string.upper(key) ~= key then
        k = string.upper(key)
    end
    return k
end

function AKYRS.is_value_within_threshold(target, value, threshold_percent)
    local threshold = target * (threshold_percent / 100)
    if Talisman then
        return to_big(math.abs(target - value)):lte(threshold)
    end
    return math.abs(target - value) <= threshold
end

function AKYRS.adjust_rounding(num)
    return math.floor(num*10)/10
end

function AKYRS.does_hand_only_contain_symbols(cardarea)
    if G.deck and G.deck.cards and #G.deck.cards > 0 then return false end
    for i,k in ipairs(cardarea.cards) do
        if tonumber(k.ability.aikoyori_letters_stickers) then
            return false
        end
    end
    return true
end

AKYRS.make_new_card_area = function(config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local card_limit = config.card_limit or 52
    local margin_left = config.ml or 0.
    local margin_top = config.mt or 0
    local type = config.type or "title"
    local temporary = config.temporary or false
    local akyrs_pile_drag = config.pile_drag or nil
    local highlight_limit = config.highlight_limit or 0
    local emplace_func = config.emplace_func or nil
    local use_room = config.use_room or true
    local ca = CardArea(
        (use_room and G.ROOM.T.x or 0) + margin_left * (use_room and G.ROOM.T.w or 1), (use_room and G.ROOM.T.h or 0) + margin_top
        , width , height,
        {card_limit = card_limit, type = type, highlight_limit = highlight_limit, akyrs_emplace_func = emplace_func, temporary = temporary, akyrs_pile_drag=akyrs_pile_drag }
    )
    ca.states.collide.can = true
    ca.states.release_on.can = true
    return ca
end

AKYRS.destroy_existing_cards = function(cardarea)
    if cardarea and cardarea.cards then
        for i,k in ipairs(cardarea.cards) do
            k:start_dissolve(nil, true)
        end
    end
    if cardarea then 
        cardarea:remove()
    end
end


function AKYRS.draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    delay = delay or 0.1 
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = delay,
        blocking = not (G.SETTINGS.GAMESPEED >= 999 and ((to == G.hand and from == G.deck) or (to == G.deck and from == G.hand))), -- Has to be these specific draws only, otherwise it's buggy
        
        func = function()
            if card then 
                if from then card = from:remove_card(card) end
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
                if to then
                    to:emplace(card, nil, stay_flipped)
                else
                    
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            else
                card = to:draw_card_from(from, stay_flipped, discarded_only)
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            end
            if not mute and drawn then
                if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                    G.VIBRATION = G.VIBRATION + 0.6
                end
                play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
            end
            if sort then
                to:sort()
            end
            SMODS.drawn_cards = SMODS.drawn_cards or {}
            if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
            
            if card and forced_facing then 
                card.facing = forced_facing
                card.sprite_facing = forced_facing
            end
            return true
        end
      }))
end
function AKYRS.instant_draw_card(from, to, percent, dir, sort, card, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    if card then 
        if from then card = from:remove_card(card) end
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
        if to then
            to:emplace(card, nil, stay_flipped)
        else
            
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    else
        card = to:draw_card_from(from, stay_flipped, discarded_only)
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    end
    if not mute and drawn then
        if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
            G.VIBRATION = G.VIBRATION + 0.6
        end
        play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
    end
    if sort then
        to:sort()
    end
    SMODS.drawn_cards = SMODS.drawn_cards or {}
    if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
    
    if card and forced_facing then 
        card.facing = forced_facing
        card.sprite_facing = forced_facing
    end
    return true
        
end

AKYRS.simple_event_add = function (func, delay)
    G.E_MANAGER:add_event(Event{
        trigger = 'after',
        delay = delay or 0.1,
        func = func
    })
end

AKYRS.check_type = function(d)
    local type_map = {
        {"Controller",Controller},
        {"Particles",Particles},
        {"DynaText",DynaText},
        {"Back",Back},
        {"Blind",Blind},
        {"Card",Card},
        {"Tag",Tag},
        {"CardArea",CardArea},
        {"UIElement",UIElement},
        {"UIBox",UIBox},
        {"AnimatedSprite",AnimatedSprite},
        {"Sprite",Sprite},
        {"Card_Character",Card_Character},
        {"Event",Event},
        {"EventManager",EventManager},
        {"Game",Game},
        {"Moveable",Moveable},
        {"Node",Node},
        {"Object",Object},
    }

    for i, class_ref in ipairs(type_map) do
        if d:is(class_ref[2]) then
            return class_ref[1]
        end
    end

    return type(d)
end

function AKYRS.is_in_table(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function AKYRS.find_index(table, value)
    for index, v in ipairs(table) do
        if v == value then
            return index
        end
    end
    return nil
end

function AKYRS.remove_value_from_table(tbl, value)
    local index = AKYRS.find_index(tbl, value)
    if index then
        table.remove(tbl, index)
        return true
    end
    return false
end

function AKYRS.recalculate_cardarea_bundler(cardarea, func, reset)
    local logic = func or function(x) return x.states.drag.is or x.states.click.is end
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        if logic(card) then
            
            card.following_cards = reset and {} or (card.following_cards or {})
            for ke, card2 in ipairs(cardarea.cards) do
                if ke > k and not AKYRS.is_in_table(card.following_cards,card2) and not card2.is_being_pulled then
                    table.insert(card.following_cards, card2)
                    --print(AKYRS.C2S(card2))
                    --print("CARDS IN THE THING - "..AKYRS.TBL_C2S(card.following_cards))
                    
                end
            end
        end

    end
    cardarea.last_card_amnt = #cardarea.cards
end
function AKYRS.reset_cardarea_bundler(cardarea)
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        card.following_cards = nil

    end
end

function AKYRS.C2S(card)
    return (card.base.value .. " of " .. card.base.suit)
end


function AKYRS.TBL_C2S(table)
    local result = ""
    for _, card in ipairs(table) do
        if type(card) == "table" and card.base and card.base.value and card.base.suit then
            result = result .. AKYRS.C2S(card) .. ", "
        else
            return nil
        end
    end
    return result:sub(1, -3) -- Remove the trailing ", "
end

function AKYRS.is_valid_enhancement(name)
    for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
        local first_part = string.split(v.name," ")[1]
        if first_part == name then
            return true
        end
    end
    return false
end

function AKYRS.is_valid_edition(name)
    for _, v in pairs(G.P_CENTER_POOLS.Edition) do
        if v.name == name then
            return true
        end
    end
    return false
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end


function AKYRS.capitalize(stringIn)
    return string.gsub(" " .. stringIn, "%W%l", string.upper):sub(2)
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
                local carder = create_card(name, area, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                if carder then
                    area:emplace(carder)
                end
            end)
        end 
    end

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

AKYRS.plural_centers = {
    ["jokers"]    = "joker",
    ["cards"]     = "card",
    ["enhanceds"] = "enhanced",
    ["vouchers"]  = "voucher",
    ["tarots"]    = "tarot",
    ["planets"]   = "planet",
    ["spectrals"] = "spectral",
}

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
    if AKYRS.plural_centers[word] then
        count = count + pseudorandom(pseudoseed("maniwishiwassleeping"),0,9)
    end
    return center,area,count,centerName
end

function AKYRS.maxwell_word_to_edition_map(word)
    if word == "neg" or word == "negs" or word == "negative" or word == "negatives" then return "Negative","e_negative" end
    if word == "holo" or word == "holos" or word == "holographic" or word == "holographics" then return "Holographic","e_holo" end
    if word == "poly" or word == "polies" or word == "polychrome" or word == "polychromes" then return "Polychrome","e_polychrome" end
    if word == "foil" or word == "foils" or word == "foiled" or word == "foileds" then return "Foil","e_foil" end
    if word == "sliced" then return "akyrs_sliced","e_akyrs_sliced" end
    if word == "noir" then return "akyrs_noire","e_akyrs_noire" end
    if word == "texel" then return "akyrs_texelated","e_akyrs_texelated" end
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
    return nil
end

function AKYRS.remove_comma(string)
    return string.gsub(string, ",", "")
end

function AKYRS.score_catches_fire_or_not()
    if not G.GAME or not G.GAME.blind then return false end

    if type(G.GAME.blind.chips) == "string" then
        local stud = tonumber(AKYRS.remove_comma(G.GAME.blind.chips))
        G.GAME.blind.chips = Talisman and to_big(stud) or stud

    end
    if Talisman then
        G.GAME.current_round.current_hand.chips = to_big(G.GAME.current_round.current_hand.chips)
        G.GAME.current_round.current_hand.mult = to_big(G.GAME.current_round.current_hand.mult)
        G.GAME.blind.chips = to_big(G.GAME.blind.chips)
    end
    return G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult > G.GAME.blind.chips
end


AKYRS.word_letter_count = function(word)
    
    local wordArray = {}
    for i = 1, #word do
        wordArray[word:sub(i, i)] = wordArray[word:sub(i, i)] and wordArray[word:sub(i, i)] + 1 or 1
    end
    return wordArray
end

AKYRS.get_letter_freq_from_cards = function(listofcards)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        local w = string.lower(v:get_letter_with_pretend())
        wordArray[w] = wordArray[w] and wordArray[w] + 1 or 1
    end
    return wordArray
end
AKYRS.icons_pos = {
    ["expert"]          = { x = 0, y = 1},
    ["master"]          = { x = 1, y = 1},
    ["ultima"]          = { x = 2, y = 1},
    ["remaster"]        = { x = 3, y = 1},
    ["lunatic"]         = { x = 4, y = 1},
    ["dx"]              = { x = 0, y = 2},
    ["no_reroll"]       = { x = 0, y = 0},
    ["no_disabling"]    = { x = 1, y = 0},
    ["no_face"]         = { x = 2, y = 0},
    ["forgotten_blind"] = { x = 5, y = 1},
    ["word_blind"]      = { x = 6, y = 1},
    ["puzzle_blind"]    = { x = 7, y = 1},
    ["postwin_blind"]   = { x = 8, y = 1},
    ["endless_blind"]   = { x = 9, y = 1},
}
AKYRS.icon_sprites = {}

AKYRS.remove_formatting = function(string_in)
    return string.gsub(string_in, "{.-}", "")
end
AKYRS.full_ui_add = function(nodes, key, scale)
    local m = G.localization.descriptions["DescriptionDummy"][key]
    local l = {
        {
            n = G.UIT.R,
            nodes = {
                { n = G.UIT.T, config = { text = m.name, colour = G.C.UI.TEXT_LIGHT, scale = scale*1.2 }},
            }
        }
    }
    if m.text and false then
        for i, tx in ipairs(m.text) do
            table.insert(l, 
                {
                    n = G.UIT.R,
                    nodes = {
                        { n = G.UIT.T, config = { text = AKYRS.remove_formatting(tx), colour = G.C.UI.TEXT_LIGHT, scale = scale }},
                    }
                }
            )
        end
    end
    
    local x = {
        n = G.UIT.C,
        config = { align = "lm", padding = 0.1 },
        nodes = {
            { n = G.UIT.R, config = {}, nodes = l },
            
        }
    }
    table.insert(nodes, x)
end
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
    if cache then
        AKYRS.icon_sprites[key] = AKYRS.icon_sprites[key] or Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.icons_pos[key])
        sprite = AKYRS.icon_sprites[key]
    else
        sprite = Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.icons_pos[key])
    end
    local keyed = "dd_akyrs_"..key
    z[#z+1] = {
        n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = full_ui and "lc" or "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[keyed] },
        nodes = {
            {n=G.UIT.O, config={object = sprite, scale = fsz}},
        }
    }
    if full_ui then
        AKYRS.full_ui_add(z[#z].nodes, "dd_akyrs_"..key, dfctysz)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies[keyed]
    end
end
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

    if blind and blind.debuff then
        if blind.debuff.akyrs_blind_difficulty and not hide.difficulty then
            local sprite = nil
            if cache then
                AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty] = AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty] or Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.icons_pos[blind.debuff.akyrs_blind_difficulty])
                sprite = AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty]
            else
                sprite = Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.icons_pos[blind.debuff.akyrs_blind_difficulty])
            end
    
            local blind_txt_dmy = "dd_akyrs_"..blind.debuff.akyrs_blind_difficulty.."_blind"
            z[#z+1] = {
                n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[blind_txt_dmy] },
                nodes = {
                    {n=G.UIT.O, config={object = sprite, scale = fsz}},
                }
            }
            if full_ui then
                AKYRS.full_ui_add(z[#z].nodes, blind_txt_dmy, dfctysz)
                info_queue[#info_queue+1] = AKYRS.DescriptionDummies[blind_txt_dmy]
            end
        end
        if blind.debuff.akyrs_cannot_be_disabled and not hide.disabled then
            AKYRS.generate_icon_blinds("no_disabling",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_cannot_be_rerolled and not hide.reroll then
            AKYRS.generate_icon_blinds("no_reroll",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_forgotten_blind and not hide.forgotten_blind then
            AKYRS.generate_icon_blinds("forgotten_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_word_blind and not hide.word_blind then
            AKYRS.generate_icon_blinds("word_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_puzzle_blind and not hide.puzzle_blind then
            AKYRS.generate_icon_blinds("puzzle_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_endless_blind and not hide.endless_blind then
            AKYRS.generate_icon_blinds("endless_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_postwin_blind and not hide.postwin_blind then
            AKYRS.generate_icon_blinds("postwin_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
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

AKYRS.hand_sort_function = function (a,b)
    if G.GAME and G.GAME.words_reversed then
        return a.T.x > b.T.x
    end
    return a.T.x < b.T.x    
end

G.FUNCS.go_to_aikoyori_discord_server = function(e)
    love.system.openURL( "https://discord.gg/JVg8Bynm7k" )
end

AKYRS.shallow_indexed_table_copy = function(t)
    local t2 = {}
    for i,k in ipairs(t) do
        table.insert(t2,k)
    end
    return t2
end

AKYRS.get_current_blind_config = function()
    return G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
end

function AKYRS.search_UIT_for_id(uit, id)
    if not id or not uit then return nil end
    for _, node in ipairs(uit.nodes or {}) do
        if node.config and node.config.id == id then
            return node
        elseif node.nodes then
            local result = AKYRS.search_UIT_for_id(node, id)
            if result then
                return result
            end
        end
    end
    return nil
end

AKYRS.blacklist_mod = {
    ["cry_prob"] = true,
    ["akyrs_cycler"] = true,
    ["immutable"] = true,
}


AKYRS.edition_extend_card_limit = function(card)
    if card then
        if card.edition then
            if card.edition.key == "e_negative" then
                return 1
            end
            if card.edition.key == "e_akyrs_noire" then
                return 2
            end
        end
    end
    return 0
end

AKYRS.card_any_drag = function()
    return G and G.GAME and G.GAME.akyrs_any_drag and not G.OVERLAY_MENU
end