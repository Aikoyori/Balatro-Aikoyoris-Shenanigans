
AKYRS.example_words = {
    "cry",
    "card",
    "jimbo",
    "thrash",
    "sticker",
    "foreword",
    "mainframe",
    "mainlander",
    "hyperactive",
    "skeletonised",
    "neanderthaler",
    "televisionally",
    "demographically",
    "tropostereoscope",
    "erythroneocytosis",
    "heteroscedasticity",
    "unmisunderstandable",
    "adrenocorticosteroid",
    "poluphloisboiotatotic",
    "polioencephalomyelitis",
    "overintellectualization",
    "formaldehydesulphoxylate",
    "demethylchlortetracycline",
    "mentor-on-the-lake-village",
    "electroencephalographically",
    "antidisestablishmentarianism",
    "cyclotrimethylenetrinitramine",
    "##############################",
    "dichlorodiphenyltrichloroethane",
    "################################",
    "#################################",
    "##################################",
    "###################################",
    "####################################",
    "#####################################",
    "######################################",
    "#######################################",
    "########################################",
    "#########################################",
    "##########################################",
    "###########################################",
    "############################################",
    "pneumonoultramicroscopicsilicovolcanoconiosis",
}

AKYRS.aiko_word_hand_values = {
    -- starts at 3
    { chips = 2.5, mult = 25, upgrade_chips = 1, upgrade_mult = 10 }, -- 3 letter
    { chips = 3, mult = 35, upgrade_chips = 1.5, upgrade_mult = 15 }, -- 4 letter
    { chips = 3.5, mult = 45, upgrade_chips = 3, upgrade_mult = 20 }, -- 5 letter
    { chips = 4.5, mult = 65, upgrade_chips = 4, upgrade_mult = 25 }, -- 6 le- you get the point im not doing this
    { chips = 5.5, mult = 80, upgrade_chips = 6, upgrade_mult = 35 }, -- 7, tho i have to go up to like 45 because the table above lol
    { chips = 7, mult = 95, upgrade_chips = 7, upgrade_mult = 45 },
    { chips = 8, mult = 125, upgrade_chips = 9, upgrade_mult = 55 },
    { chips = 10, mult = 140, upgrade_chips = 11, upgrade_mult = 70 },
    { chips = 12, mult = 160, upgrade_chips = 13, upgrade_mult = 80 },
    { chips = 14, mult = 185, upgrade_chips = 15, upgrade_mult = 95 },
    { chips = 16, mult = 200, upgrade_chips = 17, upgrade_mult = 110 },
    { chips = 20, mult = 240, upgrade_chips = 19, upgrade_mult = 130 },
    { chips = 26, mult = 300, upgrade_chips = 22, upgrade_mult = 160 },
    { chips = 35, mult = 380, upgrade_chips = 28, upgrade_mult = 210 },
    { chips = 50, mult = 500, upgrade_chips = 40, upgrade_mult = 300 },
    { chips = 65, mult = 650, upgrade_chips = 50, upgrade_mult = 350 },
    { chips = 85, mult = 850, upgrade_chips = 65, upgrade_mult = 450 },
    { chips = 110, mult = 1100, upgrade_chips = 80, upgrade_mult = 600 },
    { chips = 130, mult = 1300, upgrade_chips = 90, upgrade_mult = 700 },
    { chips = 150, mult = 1500, upgrade_chips = 100, upgrade_mult = 800 },
    { chips = 180, mult = 1800, upgrade_chips = 120, upgrade_mult = 1000 },
    { chips = 220, mult = 2200, upgrade_chips = 150, upgrade_mult = 1250 },
    { chips = 270, mult = 2700, upgrade_chips = 190, upgrade_mult = 1600 },
    { chips = 330, mult = 3300, upgrade_chips = 240, upgrade_mult = 2000 },
    { chips = 400, mult = 4000, upgrade_chips = 300, upgrade_mult = 2500 },
    { chips = 500, mult = 5000, upgrade_chips = 350, upgrade_mult = 3000 },
    { chips = 620, mult = 6400, upgrade_chips = 420, upgrade_mult = 3800 },
    { chips = 780, mult = 8000, upgrade_chips = 550, upgrade_mult = 4800 },
    { chips = 960, mult = 10000, upgrade_chips = 680, upgrade_mult = 6000 },
    { chips = 1200, mult = 12000, upgrade_chips = 800, upgrade_mult = 7500 },
    { chips = 1500, mult = 16000, upgrade_chips = 1000, upgrade_mult = 9500 },
    { chips = 1900, mult = 22000, upgrade_chips = 1300, upgrade_mult = 13000 },
    { chips = 2400, mult = 30000, upgrade_chips = 1700, upgrade_mult = 18000 },
    { chips = 3100, mult = 40000, upgrade_chips = 2300, upgrade_mult = 24000 },
    { chips = 4000, mult = 50000, upgrade_chips = 3000, upgrade_mult = 30000 },
    { chips = 5200, mult = 70000, upgrade_chips = 3800, upgrade_mult = 40000 },
    { chips = 6800, mult = 95000, upgrade_chips = 5000, upgrade_mult = 55000 },
    { chips = 8800, mult = 125000, upgrade_chips = 6500, upgrade_mult = 75000 },
    { chips = 11500, mult = 160000, upgrade_chips = 8000, upgrade_mult = 95000 },
    { chips = 15000, mult = 200000, upgrade_chips = 10000, upgrade_mult = 120000 },
    { chips = 22000, mult = 280000, upgrade_chips = 15000, upgrade_mult = 170000 },
    { chips = 32000, mult = 400000, upgrade_chips = 22000, upgrade_mult = 240000 },
    { chips = 44000, mult = 560000, upgrade_chips = 30000, upgrade_mult = 330000 },
    { chips = 58000, mult = 750000, upgrade_chips = 40000, upgrade_mult = 450000 },
    { chips = 75000, mult = 1000000, upgrade_chips = 50000, upgrade_mult = 600000 },
}

local function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end
-- some skeleton
if AKYRS.config.wildcard_behaviour == 1 then
    -- default: shouldn't do anything
elseif AKYRS.config.wildcard_behaviour == 2 then
    -- warn on unset: this should be on the play cards function
elseif AKYRS.config.wildcard_behaviour == 3 then
    -- warn on unset: this should not run the recursive to find letters basically
elseif AKYRS.config.wildcard_behaviour == 4 then
    -- warn on unset: this should set pretend letters to that of the card
end


function AKYRS.get_dictionary()
    return AKYRS_WORDS
end


function AKYRS._INTERNAL_check_word_coroutine(str_arr_in)
    --print("what")
    local wild_positions = {}
    local wild_count = 0
    local d = AKYRS.get_dictionary()

    for i = 1, #str_arr_in do
        if str_arr_in[i] == "#" then
            wild_count = wild_count + 1
            wild_positions[wild_count] = i
        end
    end

    -- If no wildcards, check directly
    if wild_count == 0 then
        local word_str = table.concat(str_arr_in)
        local firstletter = string.sub(word_str, 1,3)
        return { valid = firstletter and d[firstletter] and d[firstletter][word_str], word = firstletter and d[firstletter] and d[firstletter][word_str] and word_str or nil }
    end
    local function backtrack(index)
        if index > wild_count then
            local word_str = table.concat(str_arr_in)
            local firstletter = string.sub(word_str, 1, 3)
            if firstletter and d[firstletter] and d[firstletter][word_str] and #word_str == #str_arr_in then
                return { valid = true, word = word_str }
            end
            return nil
        end

        local pos = wild_positions[index]
        for i = 1, #aiko_alphabets_no_wilds do
            str_arr_in[pos] = aiko_alphabets_no_wilds[i]
            local result = backtrack(index + 1)
            if result then return result end
        end
        str_arr_in[pos] = "#"
        return nil
    end

    return backtrack(1) or { valid = false, word = nil }
end

function AKYRS.check_word(str_arr_in)
    local check_coroutine = coroutine.create(AKYRS._INTERNAL_check_word_coroutine)
    local success, result = coroutine.resume(check_coroutine, str_arr_in)
    if success then
        return result
    else
        return { valid = false, word = nil}
    end
end

AKYRS.WORD_CHECKED = {

}

function AKYRS.word_hand_combine(hand_in, length)
    if not (((G.GAME.akyrs_character_stickers_enabled) or (G.GAME.akyrs_wording_enabled)) or AKYRS.word_blind()) then 
    return {} end
    local word_hand = {}
    local hand = AKYRS.shallow_indexed_table_copy(hand_in)
    table.sort(hand, AKYRS.hand_sort_function)
    for _, v in ipairs(hand) do
        if not v.ability or not v.ability.aikoyori_letters_stickers then return {} end
        local alpha = v.ability.aikoyori_letters_stickers:lower()
        if alpha == "#" and v.ability.aikoyori_pretend_letter then
            -- if wild is set fr tbh
            alpha = v.ability.aikoyori_pretend_letter:lower()
        elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
            alpha = '★'
        end
        for _, ltr in ipairs(AKYRS.word_splitter(alpha)) do
            table.insert(word_hand, ltr)
        end 
    end
    if #word_hand ~= (length or #word_hand) then
        return {}
    end
    return word_hand
end

function AKYRS.word_hand_search(word_hand, hand, length)
    local word_hand_str = table.concat(word_hand)
    
    local all_wildcards = true
    for _, val in ipairs(word_hand) do
        if val ~= "#" then
            all_wildcards = false
            break
        end
    end
    if all_wildcards then
        if AKYRS.example_words[length-2] then
            G.GAME.aiko_current_word = string.lower(AKYRS.example_words[length-2])
            return { hand }, { valid = true, word = string.lower(AKYRS.example_words[length-2]) }
        else
            return {}, {}
        end
    end
    local wordData = {}
    --print("CHECK TIME! FOR '"..word_hand_str.."' IS THE WORD")
    if (AKYRS.WORD_CHECKED[word_hand_str]) then
        --print("WORD "..word_hand_str.." IS IN MEMORY AND THUS SHOULD USE THAT")
        wordData = AKYRS.WORD_CHECKED[word_hand_str]
    else
        --print("WORD "..word_hand_str.." IS NOT IN MEMORY ... CHECKING")
        wordData = AKYRS.check_word(word_hand)
        AKYRS.WORD_CHECKED[word_hand_str] = wordData
    end
    if wordData.valid then
        G.GAME.aiko_current_word = wordData.word
        local aiko_current_word_split = {}
        return {hand}, wordData
    else 
        return {}, wordData
    end
end

AKYRS.words_hand = {}
for i = 3, 45 do
    local hv = AKYRS.aiko_word_hand_values[i-1]
    local exampler = {}
    for j = 1, #AKYRS.example_words[i-2] do
        local c = AKYRS.example_words[i-2]:sub(j,j)
        table.insert(exampler,{
            AKYRS.randomCard(),
            true,
            nil,
            akyrs_letter = c,
            is_null = true
        })
    end
    
    table.insert(AKYRS.words_hand, i.."-letter Word")
    SMODS.PokerHand {
        no_collection = true,
        key = i.."-letter Word",
        visible = false,
        example = exampler,
        evaluate = function(parts, hand_in)
            local s = AKYRS.word_hand_combine(hand_in, i)
            if #s == 0 then return {} end
            local hand_return = AKYRS.word_hand_search(s, hand_in, i)
            --print(hand_return)
            return hand_return
        end,
        chips = hv.chips,
        mult = hv.mult,
        l_chips = hv.upgrade_chips,
        l_mult = hv.upgrade_mult,
    }
end

SMODS.PokerHand {
    key = "Word Hand",
    visible = false,
    example = {
        { AKYRS.randomCard(), true, nil, akyrs_letter = "E", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "x", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "a", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "m", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "p", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "l", is_null = true},
        { AKYRS.randomCard(), true, nil, akyrs_letter = "e", is_null = true},
    },
    evaluate = function(parts, hand_in)
        return {}
    end,
    akyrs_visual_chips = function(self)
        return "???"
    end,
    akyrs_visual_mult = function(self)
        return "???"
    end,
    chips = 0,
    mult = 0,
    l_chips = 0,
    l_mult = 0,
}

SMODS.PokerHand{
    key = "expression",
    chips = 0,
    mult = 0,
    l_chips = 0,
    l_mult = 0,
    visible = false,
    example = {
        { "", true, nil, akyrs_letter = "3", is_null = true},
        { "", true, nil, akyrs_letter = "7", is_null = true},
        { "", true, nil, akyrs_letter = "*", is_null = true},
        { "", true, nil, akyrs_letter = "4", is_null = true},
        { "", true, nil, akyrs_letter = "+", is_null = true},
        { "", true, nil, akyrs_letter = "2", is_null = true},
        { "", true, nil, akyrs_letter = "7", is_null = true},
    },
    evaluate = function(parts, hand_in)
        if ((not G.GAME.akyrs_character_stickers_enabled) or (not G.GAME.akyrs_mathematics_enabled)) then 
        return {} end
        local word_hand = {}
        local hand = AKYRS.shallow_indexed_table_copy(hand_in)
        table.sort(hand, AKYRS.hand_sort_function)
        for _, v in pairs(hand) do
            if not v.ability or not v.ability.aikoyori_letters_stickers then return {} end
            local alpha = v.ability.aikoyori_letters_stickers:lower()
            if alpha == "#" and v.ability.aikoyori_pretend_letter then
                -- if wild is set fr tbh
                alpha = v.ability.aikoyori_pretend_letter:lower()
            elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                alpha = '★'
            end
            table.insert(word_hand, alpha)
                
        end
        
        local expression = table.concat(word_hand)
        
        
        local status, value = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,expression)
        if not status or #hand < 1 then return {} end
        G.GAME.aikoyori_evaluation_value = value
        G.GAME.aikoyori_evaluation_replace = false
        G.GAME.akyrs_previous_scoring_key = G.GAME.current_scoring_calculation
        AKYRS.set_scoring_parameter_backup('akyrs_math_display')
        if (G.STATE == G.STATES.HAND_PLAYED) then
            G.GAME.aikoyori_evaluation_value = value
        end
        return {hand}
    end,
}
SMODS.PokerHand{
    key = "modification",
    chips = 0,
    mult = 0,
    l_chips = 0,
    l_mult = 0,
    visible = false,
    example = {
        { "", true, nil, akyrs_letter = "/", is_null = true},
        { "", true, nil, akyrs_letter = "2", is_null = true},
        { "", true, nil, akyrs_letter = "5", is_null = true},
    },
    evaluate = function(parts, hand_in)
        if ((not G.GAME.akyrs_character_stickers_enabled) or (not G.GAME.akyrs_mathematics_enabled)) then 
        return {} end
        local word_hand = {}
        local hand = AKYRS.shallow_indexed_table_copy(hand_in)
        table.sort(hand, AKYRS.hand_sort_function)
        for _, v in pairs(hand) do
            if not v.ability or not v.ability.aikoyori_letters_stickers then return {} end
            local alpha = v.ability.aikoyori_letters_stickers:lower()
            if alpha == "#" and v.ability.aikoyori_pretend_letter then
                -- if wild is set fr tbh
                alpha = v.ability.aikoyori_pretend_letter:lower()
            elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                alpha = '★'
            end
            table.insert(word_hand, alpha)
                
        end
        
        local expression = table.concat(word_hand)
        local to_number = to_number or function(l) return l end
        local expression_with_chips = tostring(to_number(G.GAME.chips))..table.concat(word_hand)
        
        
        local status_check, value_fake = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,expression)
        local status, value = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,expression_with_chips)
        if status_check or #hand < 1 then return {} end
        if not status then return {} end
        G.GAME.aikoyori_evaluation_value = value
        G.GAME.aikoyori_evaluation_replace = true
        AKYRS.set_scoring_parameter_backup('akyrs_math_display')
        if (G.STATE == G.STATES.HAND_PLAYED) then

            G.GAME.aikoyori_evaluation_value = value
           
        end
        return {hand}
    end,
}
SMODS.PokerHand{
    key = "assignment",
    chips = 0,
    mult = 0,
    l_chips = 0,
    l_mult = 0,
    visible = false,
    example = {
        { "", true, nil, akyrs_letter = "x", is_null = true},
        { "", true, nil, akyrs_letter = "=", is_null = true},
        { "", true, nil, akyrs_letter = "7", is_null = true},
    },
    evaluate = function(parts, hand_in)
        if ((not G.GAME.akyrs_character_stickers_enabled) or (not G.GAME.akyrs_mathematics_enabled)) then 
        return {} end
        local word_hand = {}
        local hand = AKYRS.shallow_indexed_table_copy(hand_in)
        table.sort(hand, AKYRS.hand_sort_function)
        for _, v in pairs(hand) do
            if not v.ability or not v.ability.aikoyori_letters_stickers then return {} end
            local alpha = v.ability.aikoyori_letters_stickers:lower()
            if alpha == "#" and v.ability.aikoyori_pretend_letter then
                -- if wild is set fr tbh
                alpha = v.ability.aikoyori_pretend_letter:lower()
            elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                alpha = '★'
            end
            table.insert(word_hand, alpha)
                
        end
        
        local expression = table.concat(word_hand)
        local parts = {}
        for part in expression:gmatch("[^=]+") do
            table.insert(parts, part)
        end

        if #parts ~= 2 then
            return {}
        end

        local variable, value_expression = parts[1], parts[2]
        local status, value = pcall(AKYRS.MathParser.solve, AKYRS.MathParser, value_expression)

        if not status then
            return {}
        end

        G.GAME.aikoyori_variable_to_set = variable
        G.GAME.aikoyori_value_to_set_to_variable = value
        return {hand}
    end,
}

if AKYRS.config.experimental_features then
-- actual poker hands here
SMODS.PokerHand {
    key = "tripair",
    visible = false,
    chips = 120, mult = 12,
    l_chips = 35, l_mult = 3,

    example = {
        {"S_A", true},
        {"H_A", true},
        {"C_T", true},
        {"S_T", true},
        {"D_8", true},
        {"C_8", true},
    },
    evaluate = function (parts, hand)
        if #parts._2 < 3 then
            return {}
        end
        return parts._all_pairs
    end
}
SMODS.PokerHand {
    key = "triplush",
    visible = false,
    chips = 240, mult = 18,
    l_chips = 65, l_mult = 9,

    example = {
        {"C_A", true},
        {"C_A", true},
        {"C_T", true},
        {"C_T", true},
        {"C_8", true},
        {"S_8", true},
    },
    evaluate = function (parts, hand)
        if #parts._2 < 3 or #parts._flush < 1 then
            return {}
        end
        return parts._all_pairs
    end
}

SMODS.PokerHandPart {
    key = 'all_triples',
    func = function(hand)
        local _3 = get_X_same(3, hand, true)
        if not next(_3) then return {} end
        return {SMODS.merge_lists(_3)}
    end
}

SMODS.PokerHand {
    key = "twintriple",
    visible = false,
    chips = 140, mult = 10,
    l_chips = 40, l_mult = 5,

    example = {
        {"C_7", true},
        {"S_7", true},
        {"H_7", true},
        {"C_3", true},
        {"S_3", true},
        {"H_3", true},
    },
    evaluate = function (parts, hand)
        if #parts._3 < 2 then
            return {}
        end
        return parts.akyrs_all_triples
    end
}
SMODS.PokerHand {
    key = "twinflupple",
    visible = false,
    chips = 300, mult = 15,
    l_chips = 60, l_mult = 8,

    example = {
        {"C_5", true},
        {"C_5", true},
        {"C_5", true},
        {"C_4", true},
        {"C_4", true},
        {"H_4", true},
    },
    evaluate = function (parts, hand)
        if #parts._3 < 2 or #parts._flush < 1 then
            return {}
        end
        return parts.akyrs_all_triples
    end
}

function AKYRS.get_multi_flush(hand)
    local ret = {}
    local counted_cards = {}
    local four_fingers = SMODS.four_fingers('flush')
    local suits = SMODS.Suit.obj_buffer
    if #hand < four_fingers then 
        --print("asd")
        return ret 
    else
        for j = 1, #suits do
            local t = {}
            local suit = suits[j]
            local flush_count = 0
            for i=1, #hand do
                local card = hand[i]
                if not AKYRS.is_in_table(counted_cards, card) then
                    if card:is_suit(suit, nil, true) then 
                        --print("suit found "..suit)
                        flush_count = flush_count + 1;  
                        t[#t+1] = card 
                        table.insert(counted_cards, card)
                    end 
                end
            end
            if flush_count >= four_fingers then
                --print("flush found")
                table.insert(ret, t)
                t = {}
                flush_count = 0
            end
        end
        return ret
    end
end

SMODS.PokerHandPart {
    key = 'mflush',
    func = function(hand)
        return AKYRS.get_multi_flush(hand)
    end
}
SMODS.PokerHandPart {
    key = 'all_flushes',
    func = function(hand)
        local _flush = AKYRS.get_multi_flush(hand)
        if not next(_flush) then return {} end
        return {SMODS.merge_lists(_flush)}
    end
}
SMODS.PokerHandPart {
    key = 'all_straight',
    func = function(hand)
        local straight = get_straight(hand, SMODS.four_fingers('straight') , SMODS.shortcut(), SMODS.wrap_around_straight())
        if not next(straight) then return {} end
        return {SMODS.merge_lists(straight)}
    end
}

SMODS.PokerHand {
    key = "twinflush",
    visible = false,
    chips = 700, mult = 10,
    l_chips = 40, l_mult = 15,

    example = {
        {"C_A", true},
        {"C_K", true},
        {"C_K", true},
        {"C_T", true},
        {"C_9", true},
        {"D_8", true},
        {"D_5", true},
        {"D_5", true},
        {"D_4", true},
        {"D_2", true},
    },
    evaluate = function (parts, hand)
        if #parts.akyrs_mflush < 2 then
            return {}
        end
        local cards_counted = {}
        for _, part in ipairs(parts.akyrs_mflush) do
            for _, card in ipairs(part) do
                if not AKYRS.is_in_table(cards_counted, card) then
                    table.insert(cards_counted, card)
                else 
                    return {}
                end
            end
        end
        return parts.akyrs_all_flushes
    end
}

SMODS.PokerHand {
    key = "flushbung",
    visible = false,
    chips = 700, mult = 12,
    l_chips = 35, l_mult = 12,

    example = {
        {"C_A", true},
        {"C_K", true},
        {"C_K", true},
        {"C_T", true},
        {"C_9", true},
        {"C_8", true},
        {"C_5", true},
        {"C_5", true},
        {"C_4", true},
        {"C_2", true},
    },
    evaluate = function (parts, hand)
        if #parts.akyrs_mflush < 1 then
            return {}
        end
        local cards_counted = {}
        for _, part in ipairs(parts.akyrs_mflush) do
            local count = 0
            for _, card in ipairs(part) do
                if not AKYRS.is_in_table(cards_counted, card) then
                    count = count + 1
                    table.insert(cards_counted, card)
                else 
                    return {}
                end
                if count >= SMODS.four_fingers('flush') * 2 then
                    return parts.akyrs_mflush
                end
            end
        end
        return {}
    end
}


SMODS.PokerHand {
    key = "twinstraight",
    visible = false,
    chips = 900, mult = 8,
    l_chips = 65, l_mult = 17,

    example = {
        {"C_A", true},
        {"H_K", true},
        {"S_Q", true},
        {"D_J", true},
        {"D_T", true},
        {"H_8", true},
        {"S_7", true},
        {"D_6", true},
        {"C_5", true},
        {"C_4", true},
    },
    evaluate = function (parts, hand)
        if #parts._straight < 2 then
            return {}
        end
        local cards_counted = {}
        for _, part in ipairs(parts._straight) do
            for _, card in ipairs(part) do
                if not AKYRS.is_in_table(cards_counted, card) then
                    table.insert(cards_counted, card)
                else 
                    return {}
                end
            end
        end
        return parts.akyrs_all_straight
    end
}

SMODS.PokerHandPart {
    key = 'doublestraight',
    func = function(hand) return get_straight(hand, SMODS.four_fingers('straight') * 2, SMODS.shortcut(), SMODS.wrap_around_straight()) end
}

SMODS.PokerHand {
    key = "direstraight",
    visible = false,
    chips = 900, mult = 6,
    l_chips = 50, l_mult = 25,
    example = {
        {"C_A", true},
        {"H_K", true},
        {"S_Q", true},
        {"D_J", true},
        {"D_T", true},
        {"C_9", true},
        {"H_8", true},
        {"S_7", true},
        {"D_6", true},
        {"C_5", true},
    },
    evaluate = function (parts, hand)
        if #parts.akyrs_doublestraight < 1 then
            return {}
        end
        return parts.akyrs_all_straight
    end
}

SMODS.PokerHand {
    key = "twinstraightflush",
    visible = false,
    chips = 1600, mult = 60,
    l_chips = 140, l_mult = 40,
    example = {
        {"C_A", true},
        {"C_K", true},
        {"C_Q", true},
        {"S_J", true},
        {"S_T", true},
        {"S_7", true},
        {"S_6", true},
        {"S_5", true},
        {"C_4", true},
        {"C_3", true},
    },
    evaluate = function (parts, hand)
        if #parts._straight < 2 or #parts.akyrs_mflush < 2 then
            return {}
        end
        return SMODS.merge_lists(parts.akyrs_all_straight, parts.akyrs_all_flushes)
    end
}

SMODS.PokerHand {
    key = "twinstraightflush",
    visible = false,
    chips = 2400, mult = 90,
    l_chips = 210, l_mult = 60,
    example = {
        {"C_A", true},
        {"C_K", true},
        {"C_Q", true},
        {"S_J", true},
        {"S_T", true},
        {"S_7", true},
        {"S_6", true},
        {"S_5", true},
        {"C_4", true},
        {"C_3", true},
    },
    evaluate = function (parts, hand)
        if #parts._straight < 2 or #parts.akyrs_mflush < 2 then
            return {}
        end
        return SMODS.merge_lists(parts.akyrs_all_straight, parts.akyrs_all_flushes)
    end
}
end