-- This file contains hooks mainly focusing on letters & null cards

AKYRS.replenishLetters = function()
    if (G.GAME and G.GAME.letters_to_give) then
        for _, k in ipairs(G.GAME.akyrs_mathematics_enabled and AKYRS.math_deck_characters or aiko_alphabets_no_wilds ) do
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
        self:set_letters(l)
    else
        self:set_letters(pseudorandom_element(AKYRS.scrabble_letters, pseudoseed('aiko:letters')))
    end
end

function Card:set_letters(letter)
    if not self.ability then return end
    self.ability.aikoyori_letters_stickers = letter
    self:set_sprites(self.config.center,not self.is_null and self.config.card)
end

function Card:set_pretend_letters(letter)
    if self.ability and self.ability.aikoyori_letters_stickers == "#" then
        self.ability.aikoyori_pretend_letter = letter
        self:set_sprites(self.config.center,not self.is_null and self.config.card)
    end
end

function Card:remove_letters()
    self.ability.aikoyori_letters_stickers = nil
    self:set_sprites(self.config.center,not self.is_null and self.config.card)
end

-- parse hand on cards rearrangement

local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local area = self.area
    local tempted = false
    self.akyrs_oldarea = self.area or self.akyrs_oldarea
    for i, k in ipairs(G.CONTROLLER.collision_list) do
        if (k:is(CardArea)) then
            if (k.config.akyrs_emplace_func and AKYRS.emplace_funcs[k.config.akyrs_emplace_func](k, self)) or AKYRS.card_conf_any_drag(k,self) or AKYRS.card_any_drag() then
                area = k
                tempted = true
                break
            end
        end
        
        if (k:is(Card)) and false then
            if (k.area and k.area.config.akyrs_emplace_func and AKYRS.emplace_funcs[k.config.akyrs_emplace_func](k.area, self)) or AKYRS.card_conf_any_drag(k,self) or AKYRS.card_any_drag() then
                area = k.area
                tempted = true
                break
            end
        end
    end
    if area and area ~= self.area then
        if G.GAME.akyrs_ultimate_freedom or (area.config.card_limit + AKYRS.edition_extend_card_limit(self) >= #area.cards + 1 or area == G.hand or area == G.deck) then
            if self.akyrs_oldarea == G.hand or self.akyrs_oldarea == G.deck then
                AKYRS.remove_value_from_table(G.playing_cards,self)
            end
            for i, cardarea in ipairs(G.I.CARDAREA) do
                if cardarea and cardarea.cards then
                    cardarea:remove_card(self)
                end
            end
            
            if tempted then
                G.GAME.akyrs_temptation_resisted = false
            end
            if area == G.hand or area == G.deck then
                table.insert(G.playing_cards,self)
            end
            AKYRS.draw_card(self.area, area, 1, 'up', nil, self ,0)
            AKYRS.simple_event_add(
                function ()
                    
                    self.akyrs_oldarea = nil
                    return true
                end, 0
            )
            area:align_cards()
        end
        --print("TARGET SUSPECT")

    end
    local c = cardReleaseRecalcHook(self)

    if (G.hand and self.area and self.area == G.hand and G.STATE == G.STATES.SELECTING_HAND and AKYRS.full_hand_recalc())  then
        G.GAME.aikoyori_evaluation_value = 0
        self.area:parse_highlighted()
    end
    if G.deck and self.area and self.area == G.jokers and self.config.center_key == "j_akyrs_hibana" then
        G.deck:shuffle()
    end
    if self.config.center_key == "j_akyrs_corkscrew" and self.area and self.area.cards then
        for _,cx in ipairs(self.area.cards) do
            if cx.config.center_key == "j_akyrs_corkscrew" then
                local current = AKYRS.find_index(cx.area.cards,cx)
                cx.ability.extras.immutable.index = current
                cx.ability.extras.emult = AKYRS.pos_to_val(cx.ability.extras.immutable.index,#cx.area.cards)
            end
        end
    end
    return c
end 

function Card:get_letter_with_pretend()
    if not self.ability then return nil end
    local letter = self.ability.aikoyori_letters_stickers
    if letter == "#" and self.ability.aikoyori_pretend_letter and self.ability.aikoyori_pretend_letter ~= '' then
        letter = self.ability.aikoyori_pretend_letter
    end
    return letter
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    local nominal_old = self.base.nominal
    if self.is_null then self.base.nominal = 0 end
    local c = getChipBonusHook(self)
    if (self.ability.set == 'Enhanced' and self.config.center_key == "m_akyrs_scoreless") or (not AKYRS.should_score_chips(self.config.center,self)) then
        c = c - self.base.nominal
    end
    self.base.nominal = nominal_old
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
function copy_card(...)
    local other, new_card, card_scale, playing_card, strip_edition = ...
    
    local c = {copyCardHook(...)}
    c[1].is_null = other.is_null
    c[1].akyrs_judgement = other.akyrs_judgement
    c[1].akyrs_old_ability = other.ability
    c[1].akyrs_enchantments = other.akyrs_enchantments
    c[1].akyrs_stored_enchantments = other.akyrs_stored_enchantments
    local refresh_sprite = c[1].ability.akyrs_special_card_type ~= other.ability.akyrs_special_card_type
    c[1].ability.akyrs_special_card_type = other.ability.akyrs_special_card_type

    if c[1].ability.akyrs_special_card_type == "suit" then
        c[1].base.nominal = 0
    elseif c[1].base and c[1].base.value and SMODS.Ranks[c[1].base.value] then
        c[1].base.nominal = SMODS.Ranks[c[1].base.value].nominal
    end
    c[1]:set_sprites()
    if c[1].base.value then
        c[1]:set_sprites(c[1].config and c[1].config.center,c[1].config and c[1].config.card)
    end
    AKYRS.check_8H_tldr()
    return unpack(c)
end

local isSuitHook = Card.is_suit
function Card:is_suit(...)
    if self and self.is_null then return false end
    if not self then print("AKYRS > HOW IS IT NIL???") return false end
    return isSuitHook(self, ...)
end

local getIDHook = Card.get_id
function Card:get_id()
    if next(SMODS.find_card("j_akyrs_liar_dancer")) and self.area then
        local held_cards = AKYRS.filter_table(G.hand.cards, function (cd)
            return not cd.highlighted
        end,true,true)
        local selected_cards = AKYRS.filter_table(AKYRS.combine_table(G.hand.cards,G.play.cards), function (cd)
            return cd.highlighted or cd.area == G.play
        end,true,true)
        local i = AKYRS.find_index(selected_cards, self)
        if i and held_cards[i] then
            return getIDHook(held_cards[i])
        end
        
    end
    if (self.ability.set ~= "Default" and self.ability.set ~= "Enhanced") and not AKYRS.is_mod_loaded("Cryptid") then
        return -math.random(100, 1000000)
    end
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
    if next(SMODS.find_card("j_akyrs_henohenomoheji")) then
        if self and self.get_letter_with_pretend and self.ability and self.ability.aikoyori_letters_stickers and G.GAME.akyrs_character_stickers_enabled and
        (self:get_letter_with_pretend():lower() == "j" or 
        self:get_letter_with_pretend():lower() == "q" or 
        self:get_letter_with_pretend():lower() == "k") then
            return true
        end
    elseif self.is_null and not next(SMODS.find_card("j_pareidolia")) then return false end
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
    if card.is_null then return true end
    --if card.base.value and card.base.value == "akyrs_non_playing" then return true end
    if card.ability.akyrs_special_card_type == "suit" then
        return true
    end
    local ret = noRankHook(card)
    return ret
end

local noSuitHook = SMODS.has_no_suit
function SMODS.has_no_suit(card)
    if card.is_null then return true end
    --if card.base.value and card.base.value == "akyrs_non_playing" then return true end
    
    if card.ability.akyrs_special_card_type == "rank" and not SMODS.has_any_suit(card) then
        return true
    end
    local ret = noSuitHook(card)
    return ret
end


local cashOutHook = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
    G.GAME.akyrs_win_checked = nil
    SMODS.calculate_context({akyrs_round_eval = true, dollars = G.GAME.current_round.dollars})
    if G.GAME.blind_on_deck == "Boss" then
        G.GAME.akyrs_blind_random = nil
        if G.GAME.akyrs_gain_selection_per_ante then
            SMODS.change_play_limit(G.GAME.akyrs_gain_selection_per_ante)
            SMODS.change_discard_limit(G.GAME.akyrs_gain_selection_per_ante)
        end
    end
    
    if G.aiko_wordle then
        G.aiko_wordle:remove(); G.aiko_wordle = nil
    end
    if not G.GAME.current_round.advanced_blind or G.GAME.aiko_puzzle_win then
        local ret = {cashOutHook(e)}
        if G.GAME.challenge then
            local challenge_center = G.CHALLENGES[G.GAME.challenge] or AKYRS.HC_CHALLENGES[G.GAME.challenge]
            if challenge_center and challenge_center.type == "highscore" then
                G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore = G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore or {}
                G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore[G.GAME.challenge] = math.max(G.GAME.round, (G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore[G.GAME.challenge] or 0))
                set_challenge_unlock()
                G:save_settings()
            end

        end
        if G.GAME.akyrs_previous_scoring_key then
            G.GAME.current_round.akyrs_scoring_set = nil
            SMODS.set_scoring_calculation(G.GAME.akyrs_previous_scoring_key)
            G.GAME.akyrs_previous_scoring_key = nil
        end
        G.GAME.aiko_puzzle_win = nil
        G.GAME.current_round.advanced_blind = false
        G.GAME.current_round.aiko_round_played_words = {}
        G.GAME.current_round.aiko_round_correct_letter = {}
        G.GAME.current_round.aiko_round_misaligned_letter = {}
        G.GAME.current_round.aiko_round_incorrect_letter = {}
        G.GAME.current_round.advanced_blind = false
        return unpack(ret)
    else
        return nil
    end
end
