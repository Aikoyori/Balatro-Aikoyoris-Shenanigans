if Partner_API then
        
    SMODS.Atlas {
        key = "aikoPartners",
        path = "aikoPartners.png",
        px = 46,
        py = 58
    }


    Partner_API.Partner {
        
        key = "aikoyori",
        name = "Aikoyori Partner",
        atlas = "aikoPartners",
        unlocked = false,
        discovered = true,
        pos = {x = 1, y = 0},
        config = {extra = {related_card = "j_akyrs_aikoyori", chips = 0, retrigg = 1}},
        loc_vars = function(self, info_queue, card)
            local rtx = 1
            local me = SMODS.find_card("j_akyrs_aikoyori")
            if next(me) then rtx = rtx * #me + 1 end
            return { vars = {card.ability.extra.retrigg} }
        end,
        calculate = function(self, card, context)
            if context.repetition and not context.repetition_only then
                local rtx = 1
                local me = SMODS.find_card("j_akyrs_aikoyori")
                if next(me) then rtx = rtx * #me + 1 end
                return {
                    message_card = card,
                    repetitions = card.ability.extra.retrigg * rtx
                }
            end
        end,
        check_for_unlock = function(self, args)
            for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
                if v.key == "j_akyrs_aikoyori" then
                    if get_joker_win_sticker(v, true) >= 8 then
                        return true
                    end
                    break
                end
            end
        end,
    }
end