-- This file contains hooks mainly focusing on letters & null cards

AKYRS.replenishLetters = function()
    if (G.GAME and G.GAME.letters_to_give) then
        for _, k in ipairs(aiko_alphabets_no_wilds) do
            table.insert(G.GAME.letters_to_give, k)
        end
    end
end

function Card:set_letters_random()
    if (G.GAME and G.GAME.letters_to_give) then
        if (#G.GAME.letters_to_give == 0) then
            G.GAME.used_up_uppercase = true
            AKYRS.replenishLetters()
        end
        local index = pseudorandom(pseudoseed('aiko:letters'), 1, #G.GAME.letters_to_give)
        local l = table.remove(G.GAME.letters_to_give, index)
        if not G.GAME.used_up_uppercase then l = l:upper() end
        if G.GAME.akyrs_mathematics_enabled then 
            self.is_null = true
        end
        self.ability.aikoyori_letters_stickers = l
    else
        self.ability.aikoyori_letters_stickers = pseudorandom_element(AKYRS.scrabble_letters, pseudoseed('aiko:letters'))
    end
end

function Card:set_letters(letter)
    self.ability.aikoyori_letters_stickers = letter
end

function Card:set_pretend_letters(letter)
    if self.ability.aikoyori_letters_stickers == "#" then
        self.ability.aikoyori_pretend_letter = letter
    end
end

function Card:remove_letters()
    self.ability.aikoyori_letters_stickers = nil
end

-- Rendering Letters
function AKYRS.aikoyori_draw_extras(card, layer)
    if card and AKYRS.aikoyori_letters_stickers and (G.GAME.akyrs_character_stickers_enabled or card.ability.forced_letter_render) then
        if card.ability.aikoyori_letters_stickers and AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers] then
            local movement_mod = 0.05 * math.sin(1.1 * (G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
            local rot_mod = 0.02 * math.sin(0.72 * (G.TIMERS.REAL + card.aiko_draw_delay)) + 0.03
            if G.GAME.current_round.aiko_round_correct_letter and G.GAME.current_round.aiko_round_correct_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["correct"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["correct"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_misaligned_letter and G.GAME.current_round.aiko_round_misaligned_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["misalign"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["misalign"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_incorrect_letter and G.GAME.current_round.aiko_round_incorrect_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["incorrect"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["incorrect"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            end
            local letter_to_render = card.ability.aikoyori_letters_stickers
            local tint = false
            if (card.ability.aikoyori_letters_stickers == "#" and card.ability.aikoyori_pretend_letter) and AKYRS.aikoyori_letters_stickers[letter_to_render] then
                letter_to_render = card.ability.aikoyori_pretend_letter
                tint = true
            end
            if AKYRS.aikoyori_letters_stickers[letter_to_render] then
                AKYRS.aikoyori_letters_stickers[letter_to_render].role.draw_major = card
                AKYRS.aikoyori_letters_stickers[letter_to_render].VT = card.VT
                AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('dissolve', 0, nil, nil,
                    card.children.center, 0.1, nil, nil, nil)
                if tint then
                    AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('akyrs_magenta_tint', nil, nil, nil,
                        card.children.center, nil, nil, nil, -0.02 + movement_mod * 0.9, nil)
                else 
                    AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('dissolve', nil, nil, nil,
                        card.children.center, nil, nil, nil, -0.02 + movement_mod * 0.9, nil)
                end
            end

        end
    end
end


-- parse hand on cards rearrangement

local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local area = self.area
    self.akyrs_oldarea = self.area or self.akyrs_oldarea
    for i, k in ipairs(G.CONTROLLER.collision_list) do
        if (k:is(CardArea)) then
            if (k.config.akyrs_emplace_func and k.config.akyrs_emplace_func(k, self)) or AKYRS.card_any_drag() then
                area = k
                break
            end
        end
        
        if (k:is(Card)) and false then
            if (k.area and k.area.config.akyrs_emplace_func and k.area.config.akyrs_emplace_func(k.area, self)) or AKYRS.card_any_drag() then
                area = k.area
                break
            end
        end
    end
    if area and area ~= self.area then
        if area.config.card_limit + AKYRS.edition_extend_card_limit(self) >= #area.cards + 1 or area == G.hand or area == G.deck then
            self.akyrs_oldarea:remove_card(self)
            AKYRS.draw_card(self.area, area, 1, 'up', nil, self ,0)
            area:align_cards()
        end
        --print("TARGET SUSPECT")

    end
    local c = cardReleaseRecalcHook(self)

    if G.hand and self.area and self.area == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        self.area:parse_highlighted()
    end
    if G.deck and self.area and self.area == G.jokers and self.config.center_key == "j_akyrs_hibana" then
        G.deck:shuffle()
    end
    return c
end 

function Card:get_letter_with_pretend()
    local letter = self.ability.aikoyori_letters_stickers
    if letter == "#" and self.ability.aikoyori_pretend_letter and self.ability.aikoyori_pretend_letter ~= '' then
        letter = self.ability.aikoyori_pretend_letter
    end
    return letter
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.is_null then self.base.nominal = 0 end
    local c = getChipBonusHook(self)
    if SMODS.has_enhancement(self, "m_akyrs_scoreless") then
        c = c - self.base.nominal
    end
    return c
end

local getMultBonusHook = Card.get_chip_mult
function Card:get_chip_mult()
    local c = getMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_mult_enabled then
        c = c +
        AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers)
    end
    return c
end

local getXMultBonusHook = Card.get_chip_x_mult
function Card:get_chip_x_mult()
    local c = getXMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_xmult_enabled then
        c = c +
            (1 + (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers) / 10))
    end
    return c
end

local copyCardHook = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition)
    local c = copyCardHook(other, new_card, card_scale, playing_card, strip_edition)
    c.is_null = other.is_null
    c.akyrs_old_ability = other.ability
    return c
end

local isSuitHook = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if self and self.is_null then return false end
    local c = isSuitHook(self, suit, bypass_debuff, flush_calc)
    return c
end

local getIDHook = Card.get_id
function Card:get_id()
    if self.is_null then
        if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_mult_enabled then
            --print(self.ability.aikoyori_letters_stickers)
            return -10 - string.byte(self.ability.aikoyori_letters_stickers)
        else
            return -math.random(100, 1000000)
        end
    end
    local c = getIDHook(self)
    return c
end

local isFaceHook = Card.is_face
function Card:is_face(from_boss)
    if #SMODS.find_card("j_akyrs_henohenomoheji") > 0 then
        if self and self.get_letter_with_pretend and self.ability and self.ability.aikoyori_letters_stickers and G.GAME.akyrs_character_stickers_enabled and
        (self:get_letter_with_pretend():lower() == "j" or 
        self:get_letter_with_pretend():lower() == "q" or 
        self:get_letter_with_pretend():lower() == "k") then
            return true
        end
    end
    if self.is_null and not next(find_joker("Pareidolia")) then return false end
    local c = isFaceHook(self, from_boss)
    return c
end

function table.aiko_shallow_copy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

local noRankHook = SMODS.has_no_rank
function SMODS.has_no_rank(card)
    if card.is_null then return false end
    local ret = noRankHook(card)
    return ret
end

local noSuitHook = SMODS.has_no_suit
function SMODS.has_no_suit(card)
    if card.is_null then return false end
    local ret = noSuitHook(card)
    return ret
end

local playCardEval = G.FUNCS.play_cards_from_highlighted

G.FUNCS.play_cards_from_highlighted = function(e)
    local ret = playCardEval(e)
    return ret
end

local cashOutHook = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
    if not G.GAME.current_round.advanced_blind or G.GAME.aiko_puzzle_win then
        local ret = cashOutHook(e)
        G.GAME.aiko_puzzle_win = nil
        G.GAME.current_round.advanced_blind = false
        G.GAME.current_round.aiko_round_played_words = {}
        G.GAME.current_round.aiko_round_correct_letter = {}
        G.GAME.current_round.aiko_round_misaligned_letter = {}
        G.GAME.current_round.aiko_round_incorrect_letter = {}
        G.GAME.current_round.advanced_blind = false
        return ret
    else
        return nil
    end
end
