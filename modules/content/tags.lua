SMODS.Tag{
    key = "spell_itself_tag",
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    loc_vars = function (self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS["p_akyrs_mega_letter_pack_1"]
    end,
    atlas = "akyrs_aikoyoriTags", pos = { x = 0, y = 0},
    apply = function (self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep("+",G.C.BLUE,function ()
                local key = 'p_akyrs_mega_letter_pack_'..(math.random(1,2))
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end 
    end
}

SMODS.Tag{
    key = "umbral_tag",
    loc_vars = function (self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS["p_akyrs_mega_umbral_pack_1"]
    end,
    atlas = "akyrs_aikoyoriTags", pos = { x = 1, y = 0},
    apply = function (self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep("+",G.C.AKYRS_UMBRAL_P,function ()
                local key = 'p_akyrs_mega_umbral_pack_'..(math.random(1,2))
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end 
    end
}
SMODS.Tag{
    key = "replicant_tag",
    loc_vars = function (self, info_queue, tag)
        info_queue[#info_queue+1] = G.P_CENTERS["p_akyrs_replica_pack_1"]
    end,
    atlas = "akyrs_aikoyoriTags", pos = { x = 2, y = 0},
    apply = function (self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep("+",G.C.AKYRS_UMBRAL_P,function ()
                local key = 'p_akyrs_replica_pack_'..(math.random(1,2))
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end 
    end
}