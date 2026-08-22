local to_big = to_big or function(x) return x end

local aikoyori_mod_config = (SMODS.current_mod or AKYRS).config

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
aiko_alphabets_to_num_no_wild = {}
for i = 97, 122 do
    table.insert(aiko_alphabets, string.char(i))
    table.insert(aiko_alphabets_no_wilds, string.char(i))
    aiko_alphabets_to_num[string.char(i)] = i - 96
    aiko_alphabets_to_num_no_wild[string.char(i)] = i - 96
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
for v, symbol in ipairs(AKYRS.non_letter_symbols) do
    AKYRS.non_letter_symbols_reverse[symbol] = v
end


function AKYRS.aiko_mod_startup(self)
    if not self then return end
    if not AKYRS.aikoyori_letters_stickers then
        AKYRS.aikoyori_letters_stickers = {}
    end
    AKYRS.aikoyori_letters_stickers["correct"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 0, y = 0 })
    AKYRS.aikoyori_letters_stickers["misalign"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 1, y = 0 })
    AKYRS.aikoyori_letters_stickers["incorrect"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 2, y = 0 })
    AKYRS.aikoyori_letters_stickers["correct_hc"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 3, y = 0 })
    AKYRS.aikoyori_letters_stickers["misalign_hc"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 4, y = 0 })
    AKYRS.aikoyori_letters_stickers["incorrect_hc"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_misc_overlay"], { x = 5, y = 0 })
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
    local card_limit = config.card_limit or #(config.cards or {"1"})
    local override = config.override or false
    local cards = config.cards or {}
    local padding = config.padding or 0.07
    local func_after = config.func_after or nil
    local init_delay = config.init_delay or 1
    local func_list = config.func_list or nil
    local func_delay = config.func_delay or 0.2
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local node_orientation = config.orientation or G.UIT.R
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
        n = node_orientation,
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
    return uiEX, cardarea
end

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
    local manual_scale = config.manual_scale
    local fix_height = config.fxh
    local fix_width = config.fxw
    local scale = config.scale or 1
    local padding = config.padding or 0.07
    local rounded = config.rounded or 0.1
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local box_height = config.box_height or 0
    local aspect_ratio = sprite_atli.px / sprite_atli.py
    local longer_value = not manual_scale and math.max(sprite_atli.px, sprite_atli.py) or manual_scale
    local sprt = Sprite(
        G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
        ,width*scale/(aspect_ratio*longer_value), height*scale/(aspect_ratio*longer_value),
        sprite_atli, sprite_pos
    )
    local uiEX = 
    {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, r = rounded, minh = box_height or fix_height, maxh = fix_height, minw = fix_width, maxw = fix_width },
        nodes = {
            {n = G.UIT.O, config = { object = sprt }}
        }
    }
    if desc_nodes then
        desc_nodes[#desc_nodes+1] = {uiEX}
    end
    return uiEX
end

--[[
AKYRS.deep_copy = function(orig, seen, depth)
    depth = depth or 10
    if depth == 0 then return orig end
    seen = seen or {}
    if type(orig) ~= 'table' then
        return orig
    end
    if seen[orig] then
        return seen[orig]
    end
    local copy = {}
    seen[orig] = copy
    for orig_key, orig_value in next, orig, nil do
        copy[AKYRS.deep_copy(orig_key, seen, depth - 1)] = AKYRS.deep_copy(orig_value, seen, depth - 1)
    end
    setmetatable(copy, AKYRS.deep_copy(getmetatable(orig), seen, depth - 1))
    return copy
end]]

AKYRS.deep_copy = function(orig, seen, depth)
    depth = depth or 10
    if depth <= 0 then return orig end
    seen = seen or {}
    if type(orig) ~= 'table' then
        return orig
    end
    if seen[orig] then
        return seen[orig]
    end
    local copy = {}
    seen[orig] = copy
    for orig_key, orig_value in next, orig, nil do
        copy[AKYRS.deep_copy(orig_key, seen, depth - 1)] = AKYRS.deep_copy(orig_value, seen, depth - 1)
    end
    setmetatable(copy, (getmetatable(orig)))
    return copy
end

AKYRS.get_default_ability = function(key)
    return G.P_CENTERS[key] and G.P_CENTERS[key].config or {}
end

function AKYRS.find_stake_from_level(level)
    for i, k in pairs(G.P_STAKES) do 
        if k == level then
            return i, k
        end
        if k.key == level then
            return i, k
        end
        if k.stake_level == level then
            return i, k
        end
    end
    return nil, nil
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
        return to_big(to_big(target) - to_big(value)):abs() <= to_big(threshold)
    end
    return math.abs(target - value) <= threshold
end

function AKYRS.adjust_rounding(num)
    return math.floor(num*10)/10
end

AKYRS.simple_event_add = function (func, delay, queue, config)
    config = config or {}
    G.E_MANAGER:add_event(Event{
        trigger = config.trigger or 'after',
        delay = delay or 0.1,
        func = func,
        blocking = config.blocking,
        blockable = config.blockable,
    }, queue, config.front)
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

function AKYRS.is_in_table(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function AKYRS.find_index(tbl, value)
    for index, v in ipairs(tbl) do
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


function AKYRS.remove_comma(string)
    return string.gsub(string, ",", "")
end


AKYRS.word_letter_count = function(word)
    
    local wordArray = {}
    for i = 1, #word do
        wordArray[word:sub(i, i)] = wordArray[word:sub(i, i)] and wordArray[word:sub(i, i)] + 1 or 1
    end
    return wordArray
end

function AKYRS.remove_all(t, predicate)
    for i=#t, 1, -1 do
        local v=t[i]
        table.remove(t, i)
        if v and predicate(v) and v.children then
            AKYRS.remove_all(v.children, predicate)
        end
        if v and predicate(v) then v:remove() end
        v = nil
    end
    for _, v in pairs(t) do
        if predicate(v) then
            if v.children then 
                AKYRS.remove_all(v.children, predicate)
            end
            v:remove()
            v = nil
        end
    end
end


function AKYRS.akyrs_remove(uibox,predicate)
    
    if uibox == G.OVERLAY_MENU then G.REFRESH_ALERTS = true end
    uibox.UIRoot:remove()
    for k, v in pairs(G.I[uibox.config.instance_type or 'UIBOX']) do
        if v == uibox then
            table.remove(G.I[uibox.config.instance_type or 'UIBOX'], k)
            break;
        end
    end
    AKYRS.remove_all(uibox.children, predicate)
    Moveable.remove(uibox)
end

AKYRS.word_splitter = function(word)
    
    local wordArray = {}
    for i = 1, #word do
        table.insert(wordArray, word:sub(i, i))
    end
    return wordArray
end

AKYRS.remove_objects_in_nodes = function(nodes)
    if #nodes <= 0 then return end
    for _, node in ipairs(nodes) do
        if node.config and node.config.object then 
            node.config.object:remove()
        end
        if node.nodes then
            AKYRS.remove_objects_in_nodes(node.nodes)
        end
    end
end

AKYRS.remove_dupes = function(tabled)
    if not tabled then return end
    local seen = {}
    for i = #tabled, 1, -1 do
        local card = tabled[i]
        if seen[card] then
            table.remove(tabled, i)
        else
            seen[card] = true
        end
    end
end

AKYRS.word_blind = function()
    return (G.GAME.blind and G.GAME.blind.debuff and G.GAME.blind.debuff.akyrs_is_word_blind)
end

AKYRS.pos_to_val = function(ind,targ)
    if not ind or not targ then return end
    local calc_ind = ind - (targ+1) / 2
    local v, v2 = pcall(function ()
        return Talisman and (to_big(1.1):pow(calc_ind)) or 1.1 ^ calc_ind
    end)
    return v and v2 or 1
end

function AKYRS.balala(joker, poker)
    AKYRS.simple_event_add(function()error("it's balala time!",4) return true end,0)
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


AKYRS.wrap_in_col = function(table_ui)
    local x = {}
    for _,v in ipairs(table_ui) do
        x[#x+1] = { n = G.UIT.C, nodes = {v}}
    end
    return x
end


AKYRS.is_in_pool = function(card,pool)
    if not card then return false end
    if not card.config then return false end
    if not card.config.center or not card.config.center.pools then return false end
    return card.config.center.pools[pool]
end

---comment
---@return string|nil planet planet for most played hand
---@return string|nil hand hand name lol
---@return integer tally how many times it has been played
AKYRS.get_most_played = function()
    local _handname, _played, _order, _planet = 'High Card', -1, 100, 'c_pluto'
    for k, v in pairs(G.GAME.hands) do
        if v.played > _played or (v.played == _played and _order > v.order) then 
            _played = v.played
            _handname = k
        end
    end
    if _handname then
        _planet = AKYRS.get_planet_for_hand(_handname)
    end
    return _planet, _handname, _played
end

AKYRS.get_planet_for_hand = function(_hand)
    local _planet
    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
        if v.config.hand_type == _hand then
            _planet = v.key
        end
        if v.config.akyrs_hand_types then
            for i,v2 in ipairs(v.config.akyrs_hand_types) do
                if v2 == _hand then
                    _planet = v.key
                end
            end
        end
    end
    return _planet
end

AKYRS.is_mod_loaded = function(var) 
    if not var then return false end
    return (SMODS.Mods[var] and SMODS.Mods[var].can_load) and true or false
end
AKYRS.get_mod_data = function(var) 
    if not var then return false end
    return (SMODS.Mods[var] and SMODS.Mods[var].can_load) and SMODS.Mods[var] or nil
end
function AKYRS.juice_like_tarot(card)
    play_sound('tarot1')
    card:juice_up(0.3, 0.5)
end
---@param cards Card[] list of cards
---@param func fun(_card: Card, index: number): nil callback for each card
---@param config? table config for the function
---@param queue? string event queue
function AKYRS.do_things_to_card(cards, func, config, queue) -- func(card)
    queue = queue or "base"
    config = config or {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true}
    if not cards then return end
    for i, card in ipairs(cards) do
        AKYRS.simple_event_add(
            function ()
                
                if not config.no_sound and card then
                    play_sound('card1')
                end
                if not config.no_juice then
                    card:juice_up(0.3, 0.3)
                end
                if not config.no_flip then
                    card:flip()
                end
                if not config.fifo then
                    if(config.stay_flipped_delay) then
                        delay(config.stay_flipped_delay, queue)
                    end
                    AKYRS.simple_event_add(
                        function ()
                            func(card, i)
                            if not config.no_sound and card then
                                play_sound("card1",math.abs(1.15 - (i-0.999)/(#cards-0.998)*0.3))
                            end
                            if not config.no_juice then
                                card:juice_up(0.3, 0.3)
                            end
                            if not config.no_flip then
                                card:flip()
                            end
                            if not config.dont_unhighlight and card.highlighted and card.area then
                                card.area:remove_from_highlighted(card)
                            end
                            return true
                        end,config.finish_flipped_delay or 0.5, queue
                    )
                end

                return true
            end,config.stagger or 0, queue
        )
        if config.fifo and config.fifo_wait_for_finish then
            AKYRS.simple_event_add(
                function ()
                    func(card, i)
                    if not config.no_sound and card then
                        play_sound("card1",math.abs(1.15 - (i-0.999)/(#cards-0.998)*0.3))
                    end
                    if not config.no_juice then
                        card:juice_up(0.3, 0.3)
                    end

                    if not config.no_flip then
                        card:flip()
                    end
                    if not config.dont_unhighlight and card.highlighted and card.area then
                        card.area:remove_from_highlighted(card)
                    end
                    return true
                end,config.finish_flipped_delay or 0.5, queue
            )
        end
    end
    if(config.fifo and config.stay_flipped_delay) then
        delay(config.stay_flipped_delay or 0, queue)
        for i, card in ipairs(cards) do
            if config.fifo and not config.fifo_wait_for_finish then
                AKYRS.simple_event_add(
                    function ()
                        if not config.once then
                        end

                        func(card, i)
                        if not config.no_sound and card then
                            play_sound("card1",math.abs(1.15 - (i-0.999)/(#cards-0.998)*0.3))
                        end
                        if not config.no_juice then
                            card:juice_up(0.3, 0.3)
                        end

                        if not config.no_flip then
                            card:flip()
                        end
                        if not config.dont_unhighlight and card.highlighted and card.area then
                            card.area:remove_from_highlighted(card)
                        end
                        return true
                    end,config.finish_flipped_delay or 0.5, queue
                )
            end
        end
    end

end

function AKYRS.pseudorandom_elements(tables, count, seed, args)
    if not count then count = 1 end
    local outp = {}
    local tb = {}
    for i,j in ipairs(tables) do
        table.insert(tb,j)
    end
    
    if count >= #tb then
        return tb
    end
    for i = 1,count do
        local elem = pseudorandom_element(tb,seed,args)
        table.insert(outp,elem)
        AKYRS.remove_value_from_table(tb,elem)
    end
    return outp
end

function AKYRS.copy_p_card(original, new_card, card_scale, playing_card, strip_edition, area_to_add_to)
    area_to_add_to = area_to_add_to or G.hand
    playing_card = playing_card or G.playing_card
    playing_card = (playing_card and playing_card + 1) or 1
    local card = copy_card(original, new_card, card_scale, playing_card, strip_edition)
    table.insert(G.playing_cards,card)
    if area_to_add_to then
        area_to_add_to:emplace(card)
    end
    card:set_sprites(card.config.center,card.config.card)
    return card
end
function AKYRS.deselect_from_area(card)
    if card.area then
        card.area:remove_from_highlighted(card)
    end
end

function AKYRS.can_afford(money)
    if Talisman then
        
        return to_big(money) < to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)
    end
    return money < G.GAME.dollars - G.GAME.bankrupt_at
end


function AKYRS.do_nothing(...)
    return ...
end

-- function AKYRS.has_room(cardarea, card, extra, buffer, count)
--     extra = extra or 0
--     if not cardarea.cards then return true end
--     if buffer then buffer = buffer + (count or 1) end
--     return #cardarea.cards + extra < cardarea.config.card_limit + (card and AKYRS.edition_extend_card_limit(card) or 0)
-- end


-- ok so they added this new things
function AKYRS.has_room(cardarea, card, extra, buffer, count)
    return #cardarea.cards + (extra or 0) < cardarea.config.card_limit
end

function AKYRS.force_save()
    AKYRS.simple_event_add(
        function ()
            save_run()
            G.FILE_HANDLER.force = true
            return true
        end
    )
end


-- i fucking hate talisman™
function AKYRS.compare(val1, sign, val2)
    local value1 = Talisman and to_big(val1) or val1
    local value2 = Talisman and to_big(val2) or val2
    if sign == "==" then return value1 == value2 end
    if sign == ">=" then return value1 >= value2 end
    if sign == "<=" then return value1 <= value2 end
    if sign == ">" then return value1 > value2 end
    if sign == "<" then return value1 < value2 end
    if sign == "~=" or sign == "!=" then return value1 ~= value2 end
end

AKYRS.get_non_eternals = function (area, trigger)
    if area and area.cards then
        local cards = {}
        for _,c in ipairs(area.cards) do
            if not SMODS.is_eternal(c, trigger) then
                table.insert(cards, c)
            end
        end
        return cards
    end
    return {}
end

local validLetters = {}
for i = 48, 57 do -- 0-9
    table.insert(validLetters, string.char(i))
end
for i = 65, 90 do -- A-Z
    table.insert(validLetters, string.char(i))
end
for i = 97, 122 do -- a-z
    table.insert(validLetters, string.char(i))
end

function AKYRS.random_string(length)
    local stri = ""
    for i = 1, length do
        stri = stri .. pseudorandom_element(validLetters, "akyrs_random_string")
    end
    return stri

end

function AKYRS.round(val)
    local neg = val < 0 and -1 or 1
    local ve = math.abs(val)
    if ve - math.floor(ve) >= 0.5 then
        return neg * math.ceil(ve)
    else
        return neg * math.floor(ve)
    end
end
-- https://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion
function AKYRS.hsl2rgb(h,s,l,al) 
    local a=s*math.min(l,1-l);
    local f = function(n, k) k = math.fmod((n+h/30),12); return l - a*math.max(math.min(k-3,9-k,1),-1) end
    return {f(0),f(8),f(4),al};
end
-- https://gist.github.com/FGRibreau/3790217
table.akyrs_filter = function(t, filterIter, isIndexed)
    local out = {}
    if isIndexed then
        for k, v in ipairs(t) do
            if filterIter(v, k, t) then table.insert(out, v) end
        end
    else
        for k, v in pairs(t) do
            if filterIter(v, k, t) then out[k] = v end
        end
    end

    return out
end

function AKYRS.faux_score_container(ref_t, ref_v, args)
    local scale = args.scale or 0.4
    local type = args.type or 'faux_mult'
    local colour = args.colour or G.C.MULT
    local align = args.align or 'cl'
    local func = args.func
    local text = args.text or type..'_text'
    local w = args.w or 2
    local h = args.h or 1
    return
    {n=G.UIT.R, config={align = align, minw = w, minh = h, r = 0.1, colour = colour, emboss = 0.05}, nodes={
        align == 'cl' and {n=G.UIT.B, config={w = 0.1, h = 0.1}} or nil,
        {n=G.UIT.O, config={func = func, text = text, type = type, scale = scale*2.3, object = DynaText({
            string = {{ref_table = ref_t, ref_value = ref_v}},
            colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3
        })}},
        align ~= 'cl' and {n=G.UIT.B, config={w = 0.1, h = 0.1}} or nil,
    }}
end


function AKYRS.relock_achievement(achievement_name)
    if G.PROFILES[G.SETTINGS.profile].all_unlocked and (G.ACHIEVEMENTS and G.ACHIEVEMENTS[achievement_name] and not G.ACHIEVEMENTS[achievement_name].bypass_all_unlocked and SMODS.config.achievements < 3) or (SMODS.config.achievements < 3 and (G.GAME.seeded or G.GAME.challenge)) then return true end
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        blockable = false,
        blocking = false,
        func = function()
            if G.STATE ~= G.STATES.HAND_PLAYED then 
                if G.PROFILES[G.SETTINGS.profile].all_unlocked and (G.ACHIEVEMENTS and G.ACHIEVEMENTS[achievement_name] and not G.ACHIEVEMENTS[achievement_name].bypass_all_unlocked and SMODS.config.achievements < 3) or (SMODS.config.achievements < 3 and (G.GAME.seeded or G.GAME.challenge)) then return true end
                local achievement_set = nil
                if not G.ACHIEVEMENTS then fetch_achievements() end
                G.SETTINGS.ACHIEVEMENTS_EARNED[achievement_name] = nil
                G:save_progress()
                
                if G.ACHIEVEMENTS[achievement_name] and G.ACHIEVEMENTS[achievement_name].mod then 
                    if G.ACHIEVEMENTS[achievement_name].earned then
                        --|THIS IS THE FIRST TIME THIS ACHIEVEMENT HAS BEEN EARNED
                        achievement_set = true
                        G.FILE_HANDLER.force = true
                    end
                    G.ACHIEVEMENTS[achievement_name].earned = nil
                end
                
                if achievement_set then 
                    return true
                end
                if G.F_NO_ACHIEVEMENTS and not (G.ACHIEVEMENTS[achievement_name] or {}).mod then return true end

                --|LOCAL SETTINGS FILE
                --|-------------------------------------------------------
                if not G.ACHIEVEMENTS then fetch_achievements() end

                G.SETTINGS.ACHIEVEMENTS_EARNED[achievement_name] = nil
                G:save_progress()
                if G.ACHIEVEMENTS[achievement_name] and not G.STEAM then 
                    if G.ACHIEVEMENTS[achievement_name].earned then
                        --|THIS IS THE FIRST TIME THIS ACHIEVEMENT HAS BEEN EARNED
                        achievement_set = true
                        G.FILE_HANDLER.force = true
                    end
                    G.ACHIEVEMENTS[achievement_name].earned = nil
                end
                return true
            end
        end
        }), 'achievement')
end


function AKYRS.print_table_simple(tlb) 
    local str = "{"
    for k, v in pairs(tlb) do
        str = str .. k .." = " .. tostring(type(v) == 'table' and '<table>' or v) .. ", "
    end
    str = str .. "}"
    return str
end

function AKYRS.get_consumable_set()
    local sets = {}
    for name, _ in pairs(SMODS.ConsumableTypes) do
        if (G.GAME[string.lower(name).."_rate"] and G.GAME[string.lower(name).."_rate"] > 0) then
            table.insert(sets, name)
        end
    end
    return sets
end

function AKYRS.set_scoring_parameter_backup(parameter)
    G.GAME.akyrs_previous_scoring_key = G.GAME.current_scoring_calculation.key
    SMODS.set_scoring_calculation(parameter)
    G.GAME.current_round.akyrs_scoring_set = true
end

-- structure
-- a table contains smaller tables of
--  - func = a function event (anything)
--  - delay = delay before the next event is executed

--- @param event_def {func: fun()?, delay: number?}[] a table of stuff i just explained
function AKYRS.create_event_chain( event_def, index )
    index = index or 1
    if not event_def[index] then return end
    AKYRS.simple_event_add(
        function ()
            event_def[index].func()
            delay(event_def[index].delay)
            AKYRS.create_event_chain(event_def, index + 1)
            return true
        end, 0
    )

end


function AKYRS.is_in_typical_area(area)
    return area == G.jokers or area == G.hand or area == G.consumeables
end

function AKYRS.is_in_playing_card_area(area)
    return area == G.hand or area == G.play or area == G.deck or area == G.discard
end

function AKYRS.is_in_joker_type_area(area)
    return area == G.jokers or area == G.consumeables
end

-- value and weight are them props
function AKYRS.weighted_randomiser(list_of_things, seed)
    local total = 0
    for _, thing in ipairs(list_of_things) do
        total = total + thing.weight
    end
    local randomised = pseudorandom(seed) * total
    for _, thing in ipairs(list_of_things) do
        if randomised < thing.weight then
            return thing.value
        end
        randomised = randomised - thing.weight
    end
end

function AKYRS.create_card_collection_underlay(card, info)
    info = info or {}
    local tally = info.tally or {}

    card.children.akyrs_collection_ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = { padding = 0, colour = G.C.CLEAR, can_collide = false },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { colour = HEX("22222266"), padding = 0.05, r = 0.2, minw = 1, minh = 2, align = "mb" },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { padding = 0.1, align = "cm" },
                            nodes = {
                                {
                                    n = G.UIT.C, config = { padding = 0.1 },
                                    nodes = { 
                                        { n = G.UIT.T, config = { text = info.text or "?????", scale = 0.4, colour = G.C.UI.TEXT_LIGHT } }
                                    }
                                },
                            }
                        },
                        { n = G.UIT.R, config = { h = 0.5, w = 0.1 }, nodes = {{ n = G.UIT.B, config = { h = info.height or 1.7, w = 0.1 } },}},
                        {
                            n = G.UIT.R,
                            config = { padding = 0.1, align = "cm"  },
                            nodes = {
                                {
                                    n = G.UIT.C, config = { padding = 0.1, colour = G.C.GREEN, r = 0.1, align = "cm"  },
                                    nodes = { 
                                        { n = G.UIT.T, config = { text = tally.tally or "???" , scale = 0.4, colour = G.C.UI.TEXT_LIGHT } }
                                    }
                                },
                                {
                                    n = G.UIT.C, config = {  },
                                    nodes = { 
                                        { n = G.UIT.T, config = { text = "/" , scale = 0.6, colour = G.C.ORANGE } }
                                    }
                                },
                                {
                                    n = G.UIT.C, config = { padding = 0.1, colour = G.C.GREY, r = 0.1, align = "cm"  },
                                    nodes = { 
                                        { n = G.UIT.T, config = { text = tally.of or "???", scale = 0.4, colour = G.C.UI.TEXT_LIGHT } }
                                    }
                                },
                            }
                        },
                    }
                }
            }
        },
        config = { align = "cm",
            offset = { x = 0, y = 0.1 },
            --bond = "Weak",
            r_bond = "Weak",
            parent = card }
    }
end

function AKYRS.fake_blind_chip(key, args)
    if not key or not G.P_BLINDS[key] then return end
    args = args or {}
    local blind = G.P_BLINDS[key]
    local temp_blind = AnimatedSprite(0,0, 1.3, 1.3, G.ANIMATION_ATLAS[blind.discovered and blind.atlas or 'blind_chips'],
    blind.discovered and blind.pos or G.b_undiscovered.pos)
    temp_blind.states.click.can = false
    temp_blind.states.drag.can = false
    temp_blind.states.hover.can = true
    local card = Card(0 ,0 , 1.3, 1.3, G.P_CARDS.empty, G.P_CENTERS.c_base)
    temp_blind.states.click.can = false
    card.states.drag.can = false
    card.states.hover.can = true
    card.children.center = temp_blind
    temp_blind:set_role({major = card, role_type = 'Glued', draw_major = card})
    card.set_sprites = function(...)
        local args = {...}
        if not args[1].animation then return end
        local c = card.children.center
        Card.set_sprites(...)
        card.children.center = c
    end
    temp_blind:define_draw_steps({
        { shader = 'dissolve', shadow_height = 0.05 },
        { shader = 'dissolve' }
    })
    temp_blind.float = true
    card.states.collide.can = true
    card.config.blind = blind
    card.config.force_focus = true
    if blind.discovered and not blind.alerted then
        blinds_to_be_alerted[#blinds_to_be_alerted + 1] = card
    end
    card.hover = function()
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
            if not card.hovering and card.states.visible then
                card.hovering = true
                card.hover_tilt = 3
                card:juice_up(0.05, 0.02)
                play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
                if args.show_popup then
                    card.config.h_popup = create_UIBox_blind_popup(blind, card.config.blind.discovered)
                    card.config.h_popup_config = card:align_h_popup()
                end
                Node.hover(card)
                if card.children.alert then
                    card.children.alert:remove()
                    card.children.alert = nil
                    card.config.blind.alerted = true
                    G:save_progress()
                end
            end
        end
        card.stop_hover = function()
            card.hovering = false; Node.stop_hover(card); card.hover_tilt = 0
        end
    end
    return card
end

function AKYRS.fake_card_sprite(sprite, args)
    if not sprite or not sprite.atlas or not sprite.pos then return end
    args = args or {}
    local temp_spr = Sprite(args.x or 0, args.y or 0, args.w or 1, args.h or 1, G.ASSET_ATLAS[sprite.atlas], sprite.pos)
    temp_spr.states.click.can = false
    temp_spr.states.drag.can = false
    temp_spr.states.hover.can = true
    temp_spr.VT.x = args.x or 0
    temp_spr.VT.y = args.y or 0
    local card = Card(args.x or 0 ,args.y or 0 , args.w or 1, args.h or 1, G.P_CARDS.empty, G.P_CENTERS.c_base)
    card.VT.x = args.x or 0
    card.VT.y = args.y or 0
    temp_spr.states.click.can = false
    card.states.drag.can = false
    card.states.hover.can = true
    card.children.center = temp_spr
    temp_spr:set_role({major = card, role_type = 'Glued', draw_major = card})
    card.set_sprites = function(...)
        local args = {...}
        if not args[1].animation then return end
        local c = card.children.center
        Card.set_sprites(...)
        card.children.center = c
    end
    temp_spr:define_draw_steps({
        { shader = 'dissolve', shadow_height = 0.05 },
        { shader = 'dissolve' }
    })
    temp_spr.float = true
    card.states.collide.can = true
    card.config.force_focus = true
    card.hover = function()
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
            if not card.hovering and card.states.visible then
                card.hovering = true
                card.hover_tilt = 3
                card:juice_up(0.05, 0.02)
                play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
                Node.hover(card)
            end
        end
        card.stop_hover = function()
            card.hovering = false; Node.stop_hover(card); card.hover_tilt = 0
        end
    end
    return card
end

---@return Card
function AKYRS.card_collection_ui_template(key, override_sprite, p_card)
    local tg = G.ROOM

    local c = Card(tg.T.x,tg.T.y,G.CARD_W * 0.7,G.CARD_H * 0.7,G.P_CARDS[p_card],G.P_CENTERS[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
    c.no_ui = true
    if override_sprite then
        ---@type Sprite
        AKYRS.simple_event_add(
            function ()
                local cnt = c.children.center
                cnt.atlas = G.ASSET_ATLAS[override_sprite.atlas_key or "Joker"]
                cnt:set_sprite_pos(override_sprite.pos or { x = 0, y = 0})
                return true
            end, 0, "akyrs_misc"
        )
        
    end
    return c
end

function AKYRS.split(str, pattern)
    local a = {}
    for i in string.gmatch(str, pattern or ".") do
        table.insert(a, i)
    end
    return a
end


-- pitch related
AKYRS.NOTE_MAJOR = {0, 2, 4, 5, 7, 9, 11}
AKYRS.NOTE_MINOR = {0, 2, 3, 5, 7, 8, 10}

function AKYRS.shift_semitone(percent,semitone)
    return percent*(1.05946309436 ^ semitone)
end

function AKYRS.semitones_from_tone_table(tone_table, tone)
    local octaves = 0
    if tone >= #tone_table then
        octaves = math.floor(tone/#tone_table)
        tone = math.fmod(tone,#tone_table)
    end
    return tone_table[tone + 1] + octaves * 12
end

function AKYRS.start_blind_arbitrarily(key)
    G.GAME.blind_on_deck = "akyrs_Solo"
    G.GAME.round_resets.blind_choices.akyrs_Solo = key
    G.FUNCS.select_blind({config = { ref_table = G.P_BLINDS[key] }, UIBox = {get_UIE_by_ID = function(...) end}})
end

function AKYRS.combine_table(...)
    local out = {}
    for _, tab in ipairs({...}) do
        for _,ele in pairs(tab) do
            table.insert(out, ele)
        end
    end
    return out
end


function AKYRS.combine_key_table(...)
    local out = {}
    for _, tab in ipairs({...}) do
        for ki,ele in pairs(tab) do
            out[ki] = ele
        end
    end
    return out
end



function AKYRS.filter_table(tbl, predicate, ordered_in, ordered_out) 
    if not tbl or not predicate then return {} end
    if #tbl == 0 and ordered_in then return {} end
    local table_out = {}
    if ordered_in then
        for k,v in ipairs(tbl) do
            if predicate(v, k) then
                if ordered_out then
                    table.insert(table_out,v)
                else
                    table_out[k] = v
                end
            end
        end
    else
        for k,v in pairs(tbl)  do
            if predicate(v, k) then
                if ordered_out then
                    table.insert(table_out,v)
                else
                    table_out[k] = v
                end
            end
        end 
    end
    return table_out
end

-- predicate expect a return of new value
function AKYRS.map(tbl, predicate, ordered_in) 
    if not tbl or not predicate then return {} end
    if #tbl == 0 and ordered_in then return {} end
    local nextfunc = ordered_in and ipairs or pairs
    local table_out = {}
    for k,v in nextfunc(tbl) do
        if predicate(v, k) then
            local nv = predicate(v, k)
            table_out[k] = nv
        end
    end
    return table_out
end

function AKYRS.keyvalue_to_list(tbl) 
    if not tbl then return {} end
    local table_out = {}
    for k,v in pairs(tbl) do
        table.insert(table_out, {k, v})
    end
    return table_out
end

AKYRS.modify_blind_size = function(params)
    SMODS.mod_blind_size(params)
    if false then
        if not params or type(params) ~= "table" then return end
        if params.set then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function ()
                    G.GAME.blind.chips = Talisman and to_big(params.set) or params.set
                    return true
                end
            }))
        end
        if params.mult then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function ()
                    G.GAME.blind.chips = G.GAME.blind.chips * params.mult
                    return true
                end
            }))
        end
        if params.add then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function ()
                    G.GAME.blind.chips = G.GAME.blind.chips + params.add
                    return true
                end
            }))
        end
        if not params.no_sound then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function ()
                    play_sound('timpani')
                    return true
                end,
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function ()
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                if not params.no_juice then
                    G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
                end
                return true
            end
        }))
    end
end
AKYRS.get_true_original_blind_amount = function(mult)
    return get_blind_amount(G.GAME.round_resets.ante)*mult*G.GAME.starting_params.ante_scaling
end

-- apparently i have to do filo


AKYRS.scramble_list = function(tblx, seed)
    local keys = {}
    local values = {}
    local output = {}
    for k, v in pairs(tblx) do
        table.insert(keys, k)
        table.insert(values, v)
    end
    local count = #keys
    for i = 1, count do
        local k2i = pseudorandom_element(keys, seed .. "_key")
        local v2i = pseudorandom_element(values, seed .. "_value")
        output[k2i] = v2i
        AKYRS.remove_value_from_table(keys, k2i)
        AKYRS.remove_value_from_table(values, v2i)
    end
    return output
end

function AKYRS.fill_hand()
    local to_draw = G.hand.config.card_limit - #G.hand.cards
    SMODS.draw_cards(to_draw)
end

function AKYRS.bool_to_str(thing)
    if type(thing) == 'boolean' then
        return thing and "True" or "False"
    end
    return thing
end

function AKYRS.get_pool_with_predicate(pool, predicate)
    local pool = SMODS.get_clean_pool(pool)
    if not predicate then return pool end
    local pool_export = {}
    if type(predicate) == "function" then
        for index, item in ipairs(pool) do
            if predicate(item, index, pool) then
                table.add(pool_export, item)
            end
        end
    end
    return pool_export
end

function AKYRS.force_lose(key)
    if G.STAGE == G.STAGES.RUN then 
        if MPAPI and MPAPI.get_current_lobby() then
            SPDRN._run_lost_shown = true
            MPAPI.RLOGCodes.run_died:write()
            SPDRN.show_run_lost_screen()
        else
            G.GAME.akyrs_defeated_by_center = key
            G.TAROT_INTERRUPT = nil
            G.GAME.AKYRS_DEAD = true
            G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
            AKYRS.force_save()
        end
    end
end

function AKYRS.force_lose_or_lose_life(key)
    if G.STAGE == G.STAGES.RUN then 
        if AKYRS.is_mp() then
            AKYRS.ease_lives_mp(-1)
        else
            AKYRS.force_lose(key)
        end
    end
end


function AKYRS.better_ease_value(ref_table, ref_value, mod, floored, timer_type, not_blockable, blocking, delay, ease_type, queue)
    mod = mod or 0

    --Ease from current chips to the new number of chips
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = (not_blockable == false),
        blocking = blocking,
        ref_table = ref_table,
        ref_value = ref_value,
        ease_to = mod,
        timer = timer_type,
        delay =  delay or 0.3,
        ease = ease_type,
        func = (function(t) if floored then return math.floor(t) else return t end end)
    }), queue or 'akyrs_life')
end

function AKYRS.format_string(number)
    if not number then return "???" end
    if number - math.floor(number) == 0 then
        return string.format("%.1d", number)
    end
    return string.format("%.1f", number)
end

---@param card Card
function AKYRS.is_being_used_as_playing_card(card)
    return card.area and (card.area == G.hand or card.area == G.deck or card.area == G.discard)
end

function AKYRS.ui_auto_table(ui_nodes, args)
    args = args or {}
    local columns = args.columns or 4
    local starting_node = args.starting_node or G.UIT.C
    local w = args.w or 0.7
    local h = args.h or 0.5
    local cell_conf = args.cell_config or { maxw = w, maxh = h, minw = w, minh = h, h = h, w = w, r = 0.1, align = "cm" }
    local row_conf = args.row_config or { padding = 0.1, align = "cl", minh = h, maxh = h, h = h }
    local exp = {
        n = starting_node,
        nodes = {

        }
    }
    local row = {
        n = G.UIT.R,
        config = row_conf,
        nodes = {

        }
    }
    for i, nod in ipairs(ui_nodes) do
        row.nodes[#row.nodes+1] = {
            n = G.UIT.C,
            config = cell_conf,
            nodes = {
                nod
            }
        }
        if #row.nodes >= columns then
            exp.nodes[#exp.nodes+1] = row
            row = {
                n = G.UIT.R,
                config = row_conf,
                nodes = {

                }
            }
        end
    end
    if #row.nodes > 0 then exp.nodes[#exp.nodes+1] = row end
    return exp
end

local rari = {
    "Common", "Uncommon", "Rare", "Legendary"
}
function AKYRS.rarity_map(inp)
    return rari[inp] or inp
end

function AKYRS.set_whole(cardlist, centerkey)
    for _, c in ipairs(cardlist) do
        c:set_ability(G.P_CENTERS[centerkey])
    end
end

function AKYRS.should_give_eternal_likes(area)
    return (area == G.shop_jokers) or (area == G.pack_cards) 
end


function AKYRS.end_of_round_scenario_check(cd, area)
    return cd and (AKYRS.Scenario_Tag:is(cd)) or (cd.area == area) 
end

function AKYRS.add_box_to_uitable(fulluitable, nodes)
    if not fulluitable then return end
    fulluitable.main.main_box_flag = true
    fulluitable.multi_box = fulluitable.multi_box or {}
    fulluitable.multi_box[#fulluitable.multi_box+1] = nodes
end

function AKYRS.should_act_as_consumable(center)
    if not center or not center.set then
        return false
    end
    local s = center.set
    return s == "Scenario" or s == "Enchantment"
    
end

function AKYRS.remove_phantom_cards()
    
    for _, cara in ipairs(G.I.CARDAREA) do
        for _, c in ipairs(G.I.CARD) do
            if cara ~= c.area then
                AKYRS.remove_value_from_table(cara.cards, c)
            end
            AKYRS.remove_dupes(cara.cards)
        end
    end
    AKYRS.remove_dupes(G.playing_cards)
end
function AKYRS.deselect_all_from_all_areas()
    for _, cara in ipairs(G.I.CARDAREA) do
        if next(cara.highlighted) then
            for i = #cara.highlighted, 1, -1 do
                c = cara.highlighted[i]
                if c and not c.ability.akyrs_forced_selection then cara:remove_from_highlighted(c) end
            end
        end
    end
end

AKYRS.to_num = to_number or function(x)
	return x
end


function AKYRS.get_currently_applied_stake_keys()
    local currently_applied = {}
    for _, ind in ipairs(G.GAME.applied_stakes) do
        currently_applied[#currently_applied+1] = G.P_CENTER_POOLS.Stake[ind].key
    end
    return currently_applied
end

function AKYRS.get_potential_next_stake_for_application( current_st )
    local potentials = {}
    for _, stake_conf in ipairs(G.P_CENTER_POOLS.Stake) do
        if stake_conf.applied_stakes and AKYRS.is_in_table(stake_conf.applied_stakes, current_st) then
            potentials[#potentials+1] = stake_conf.key
        end
    end
    -- if no potential is found then make it as if i am asking for white stakes + whatever other stake that doesn't apply a stake
    if #potentials == 0 then
        for _, stake_conf in ipairs(G.P_CENTER_POOLS.Stake) do
            if not stake_conf.applied_stakes or #stake_conf.applied_stakes == 0 then
                potentials[#potentials+1] = stake_conf.key
            end
        end
    end
    return potentials
end


function AKYRS.get_applicable_stakes()
    local applied = AKYRS.get_currently_applied_stake_keys()
    local potentials = {}
    for _, stake_key in ipairs(applied) do
        potentials[#potentials+1] = AKYRS.get_potential_next_stake_for_application(stake_key)
    end
    local returnvalue = AKYRS.filter_table(SMODS.merge_lists(potentials), function (item) return not AKYRS.is_in_table(applied, item) end, true, true)
    return returnvalue
end



function AKYRS.apply_stake_mid_game( stake_to_apply_key, passes )
    local stake_config = G.P_STAKES[stake_to_apply_key]
    local stake_numerical_id = AKYRS.map(G.P_STAKES,function (item, key)
        return item.order
    end)[stake_to_apply_key]
    -- is it already applied?
    if AKYRS.is_in_table(G.GAME.applied_stakes, stake_numerical_id) then
        -- then do not lol
        return {}
    end
    local applied_stakes_keys = {}
    if stake_config.modifiers then
        stake_config.modifiers()
    end
    if stake_config.applied_stakes then
        for _, stake_keys in ipairs(stake_config.applied_stakes) do
            local stakes = AKYRS.apply_stake_mid_game(stake_keys, (passes or 0) + 1)
            if (passes or 0) == 0 then 
                applied_stakes_keys = SMODS.merge_lists{ stakes , applied_stakes_keys }
            end
        end
    end
    G.GAME.applied_stakes = G.GAME.applied_stakes or {}
    G.GAME.applied_stakes[#G.GAME.applied_stakes+1] = stake_numerical_id
    applied_stakes_keys[#applied_stakes_keys + 1] = stake_to_apply_key
    AKYRS.remove_dupes()
    table.sort(G.GAME.applied_stakes)
    if (passes or 0) == 0 then 
        AKYRS.update_all_blind_select()
    end
    return applied_stakes_keys
end

function AKYRS.update_all_blind_select(delay)
    if G.STATE == G.STATES.BLIND_SELECT then 
        for _, v in ipairs({'small', 'big', 'boss'}) do
            AKYRS.simple_event_add(function ()
                AKYRS.update_blind_select_column(v, delay)
                return true
            end, 0, nil, { trigger = "after"})
        end
    end
end


function AKYRS.capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function AKYRS.update_blind_select_column(col, delay, callbacks)
    local ch = AKYRS.capitalize(col)
    if not G.blind_select_opts[col] then return end
    if G.STATE ~= G.STATES.BLIND_SELECT then return end
    stop_use()
    G.CONTROLLER.locks.boss_reroll = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          play_sound('other1')
          G.blind_select_opts[col]:set_role({xy_bond = 'Weak'})
          G.blind_select_opts[col].alignment.offset.y = 20
          return true
        end
      }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = delay or 0.2,
      func = (function()
        local par = (G.blind_select_opts[col] or {}).parent
        if callbacks then
            callbacks()
        end
        G.blind_select_opts[col]:remove()
        G.blind_select_opts[col] = UIBox{
          T = {par.T.x, 0, 0, 0, },
          definition =
            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
              UIBox_dyn_container({create_UIBox_blind_choice(ch)},false,get_blind_main_colour(ch), ch == "Boss" and mix_colours(G.C.BLACK, get_blind_main_colour(ch), 0.8))
            }},
          config = {align="bmi",
                    offset = {x=0,y=G.ROOM.T.y + 9},
                    major = par,
                    xy_bond = 'Weak'
                  }
        }
        par.config.object = G.blind_select_opts[col]
        par.config.object:recalculate()
        G.blind_select_opts[col].parent = par
        G.blind_select_opts[col].alignment.offset.y = 0
        
        G.E_MANAGER:add_event(Event({blocking = false, trigger = 'after', delay = 0.5,func = function()
            G.CONTROLLER.locks.boss_reroll = nil
            return true
          end
        }))

        save_run()
        for i = 1, #G.GAME.tags do
          if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
        end
        return true
      end)
    }))
end


function AKYRS.create_fake_card(args)
    local args = args or {}
    args.atlas = args.atlas or 'centers'
    args.pos = args.pos or { x = 0, y = 0 }
    args.h = args.h or G.CARD_H
    args.w = args.w or G.CARD_W
    local x = args.x or 0
    local y = args.y or 0
    card = Card(x,y,args.w,args.h, nil, 'c_base')
    card.akyrs_card_sprites = args
    card:set_sprites()
    return card
end


function AKYRS.voucher_style_text(card, conf)
    local conf = conf or {}
    
    local top_dynatext = nil
    local bot_dynatext = nil

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            top_dynatext = DynaText({string = conf.top_text or "TOP TEXT", colours = {G.C.WHITE}, rotate = 1,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 0.6/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR})
            bot_dynatext = DynaText({string = conf.bottom_text or "BOTTOM TEXT", colours = {G.C.WHITE}, rotate = 2,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 1.4/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR, pitch_shift = 0.25})
            card:juice_up(0.3, 0.5)
            if conf.event_callback then
                conf.event_callback()
            end
            card.children.top_disp = UIBox{
                definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                    {n=G.UIT.O, config={object = top_dynatext}}
                                }},
                config = {align="tm", offset = {x=0,y=0},parent = card}
            }
            card.children.bot_disp = UIBox{
                    definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                        {n=G.UIT.O, config={object = bot_dynatext}}
                                    }},
                    config = {align="bm", offset = {x=0,y=0},parent = card}
                }
        return true end }))
    delay(0.6)
    if conf.callback then
        conf.callback()
    end
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = conf.delay or 3.2, func = function()
        top_dynatext:pop_out(4)
        bot_dynatext:pop_out(4)
        return true end }))

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
        card.children.top_disp:remove()
        card.children.top_disp = nil
        card.children.bot_disp:remove()
        card.children.bot_disp = nil
        card:start_dissolve()
    return true end }))
end

function AKYRS.nopeinator(card, config)
    local config = config or {}
    AKYRS.simple_event_add(function()
        attention_text({
            text = localize(config.text_key or 'k_nope_ex'),
            scale = 1.3,
            hold = 1.4,
            major = config.parent_this or card,
            backdrop_colour = config.colour or G.C.PURPLE,
            align = 'cm',
            offset = { x = 0, y = 0 },
            silent = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.06 * G.SETTINGS.GAMESPEED,
            blockable = false,
            blocking = false,
            func = function()
                play_sound('tarot2', 0.76, 0.4); return true
            end
        }))
        play_sound('tarot2', 1, 0.4)
        card:juice_up(0.3, 0.5)
        return true
    end)
end