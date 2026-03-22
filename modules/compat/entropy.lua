if AKYRS.is_mod_loaded("Entropy") then
    local derivative_part_func = (SMODS.PokerHandParts.entr_derivative_part or {}).func
    SMODS.PokerHandPart:take_ownership("entr_derivative_part",{
        func = function (hand)
            local cards = AKYRS.filter_table(hand, function (item, key)
                return not item.is_null
            end, true, true)
            if AKYRS.should_calculate_word() then
                local normal_calculate = false
                local s = AKYRS.word_hand_combine(hand)
                if #s == 0 then normal_calculate = true end
                local hand_return, word_data = AKYRS.word_hand_search(s, hand, #s)
                if #hand_return == 0 then
                    normal_calculate = true
                end
                if normal_calculate then
                    return derivative_part_func(hand)
                else
                    return {}
                end
            end
            if #cards == 0 then
                return derivative_part_func(hand)
            end
        end
    } )
end