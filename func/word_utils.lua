AKYRS.scrabble_distribution = {
    a = 9, b = 2, c = 2, d = 4, e = 12, f = 2, g = 3, h = 2, i = 9, j = 1, 
    k = 1, l = 4, m = 2, n = 6, o = 8, p = 2, q = 1, r = 6, s = 4, t = 6, 
    u = 4, v = 2, w = 2, x = 1, y = 2, z = 1, ["#"] = 2
}

AKYRS.scrabble_scores = {
    a = 1, b = 3, c = 3, d = 2, e = 1, f = 4, g = 2, h = 4, i = 1, j = 8, 
    k = 5, l = 1, m = 3, n = 1, o = 1, p = 3, q = 10, r = 1, s = 1, t = 1, 
    u = 1, v = 4, w = 4, x = 8, y = 4, z = 10, ["#"] = 0
}

AKYRS.math_deck_distribution = {
    ["1"] = 5,
    ["2"] = 3,
    ["3"] = 3,
    ["4"] = 3,
    ["5"] = 3,
    ["6"] = 3,
    ["7"] = 3,
    ["8"] = 3,
    ["9"] = 3,
    ["0"] = 6,
    ["("] = 1,
    [")"] = 1,
    ["+"] = 4,
    ["-"] = 6,
    ["/"] = 5,
    ["*"] = 6,
    ["^"] = 2,
    ["."] = 4,
}

AKYRS.math_deck_pro_distribution = {
    ["1"] = 3, ["2"] = 3, ["3"] = 3, ["4"] = 3, ["5"] = 3, ["6"] = 3, ["7"] = 3, ["8"] = 3, ["9"] = 3, ["0"] = 6, ["("] = 3,
    [")"] = 3, ["+"] = 4, ["-"] = 4, ["/"] = 4, ["*"] = 4, ["^"] = 1, ["."] = 4, ["="] = 4,
    ["a"] = 2, ["b"] = 2, ["c"] = 2, ["d"] = 2, ["e"] = 2, ["f"] = 2, ["g"] = 2, ["h"] = 2, ["i"] = 2, ["j"] = 2,
    ["k"] = 2, ["l"] = 2, ["m"] = 2, ["n"] = 2, ["o"] = 2, ["p"] = 2, ["q"] = 2, ["r"] = 2, ["s"] = 2, ["t"] = 2,
    ["u"] = 2, ["v"] = 2, ["w"] = 2, ["x"] = 2, ["y"] = 2, ["z"] = 2
}

AKYRS.scrabble_letters = {}
AKYRS.scrabble_letters_sorted_score = {}
AKYRS.raw_scrabble_letters = {}
AKYRS.math_deck_characters = {}
AKYRS.math_deck_pro_characters = {}

for letter, count in pairs(AKYRS.scrabble_distribution) do
    table.insert(AKYRS.raw_scrabble_letters, letter)
    for i = 1, count do
        table.insert(AKYRS.scrabble_letters, letter)
    end
end

for letter, count in pairs(AKYRS.math_deck_distribution) do
    for i = 1, count do
        table.insert(AKYRS.math_deck_characters, letter)
    end
end
for letter, count in pairs(AKYRS.math_deck_pro_distribution) do
    for i = 1, count do
        table.insert(AKYRS.math_deck_pro_characters, letter)
    end
end

AKYRS.get_scrabble_score = function(letter)
    if not letter then return 0 end
    if #letter > 1 then
        local w = AKYRS.word_splitter(letter) 
        local sc = 0
        for _, ltr in ipairs(w) do
            sc = sc + AKYRS.get_scrabble_score(ltr)
        end
        return sc
    end
    if AKYRS.scrabble_scores[letter] then
        return AKYRS.scrabble_scores[letter]
    end
    if AKYRS.scrabble_scores[letter:lower()] then
        return AKYRS.scrabble_scores[letter:lower()]
    end
    return 0
end