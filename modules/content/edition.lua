SMODS.Edition{
    key = "texelated",
    shader = "akyrs_texelated",
    config = {
        extra = {
            x_chip = 0.8,
            x_mult = 2;
        }
    },
    
    calculate =  function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                xchips = card.edition.extra.x_chip,
                Xmult = card.edition.extra.x_mult
            }
        end
        if context.pre_joker and (context.cardarea == G.jokers)  then
            return {
                xchips = card.edition.extra.x_chip,
                Xmult = card.edition.extra.x_mult
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                ((card.edition or self.config or {}).extra or {}).x_chip,
                ((card.edition or self.config or {}).extra or {}).x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_texelated_sfx", per = 1.2, vol = 0.4 },
    in_shop = true,
    weight = 7,
}

SMODS.Edition{
    key = "noire",
    shader = "akyrs_noire",
    config = {
        extra ={
            x_mult = 0.5,
        },
        card_limit = 2
    },
    calculate =  function (self, card, context)
        if context.main_scoring and (context.cardarea == G.hand or context.cardarea == G.play)  then
            return {
                Xmult = card.edition.extra.x_mult
            }
        end
        if context.pre_joker and (context.cardarea == G.jokers)  then
            return {
                Xmult = card.edition.extra.x_mult
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. AKYRS.edition_loc_center_key_getter(card),
            vars = {
                self.config.card_limit,
                self.config.extra.x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_noire_sfx", per = 0.8, vol = 0.3 },
    in_shop = true,
    weight = 3,
}

SMODS.Edition{
    key = "sliced",
    shader = "akyrs_sliced",
    config = {
        extra = {
            mod_mult = 0.5,
        },
        akyrs_card_extra_triggers = 1
    },
    disable_base_shader = true,
    sound = { sound = "akyrs_sliced_sfx", per = 0.8, vol = 0.3 },
    in_shop = true,
    in_pool = function (self, args)
        if args.source == "akyrs_aether_portal" then
            return false
        end
        return true
    end,
    on_apply = function (card)
        if not card.ability.akyrs_upgrade_sliced and card.config and card.config.center_key and G.P_CENTERS[card.config.center_key] then
            -- i rly dont wanna support the cryptid edition deck for this  this has already caused me so many problems
            --print("SLICED "..card.config.center.key)
            local x = AKYRS.deep_copy(G.P_CENTERS[card.config.center_key].config)
            AKYRS.mod_card_values(x,{multiply = 0.5, unkeywords = AKYRS.blacklist_mod})
            for n, v in pairs(x) do
                --print("SLICED "..n.." : "..AKYRS.bool_to_str(v))
                card.ability[n] = x[n] or card.ability[n]
            end
            card.ability.akyrs_upgrade_sliced = true
        end
    end,
    on_remove = function (card)
        card:set_ability(G.P_CENTERS[card.config.center_key])
        card.ability.akyrs_upgrade_sliced = false
    end,
    weight = 5,
}

SMODS.Edition{
    key = "burnt",
    shader = "akyrs_burnt",
    config = {
        extras = {
            odds = 7,
        },
        name = "akyrs_burnt"
    },
    disable_base_shader = true,
    sound = { sound = "akyrs_burnt_sfx", per = 1.2, vol = 0.3 },
    in_shop = false,
    in_pool = function (self, args)
        if args.source == "akyrs_aether_portal" then
            return false
        end
        return true
    end,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_ash_card"]
        info_queue[#info_queue+1] = G.P_CENTERS["j_akyrs_ash_joker"]
        local n,d = SMODS.get_probability_vars(card,1,self.config.extras.odds,"akyrs_burnt_edition")
        return {
            vars = {
                n,d
            }
        }
    end,
    calculate = function (self, card, context)
        
    end,
    weight = 0,
}


SMODS.Edition{
    key = "charged",
    shader = "akyrs_charged",
    config = {
        extra = {
            score = 100,
            score_gain = 20,
            score_gain_gain = 5,
        },
    },
    sound = { sound = "akyrs_charged", per = 0.8, vol = 0.3 },
    in_shop = true,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (card.edition or self.config).extra.score,
                (card.edition or self.config).extra.score_gain,
                (card.edition or self.config).extra.score_gain_gain,
            }
        }
    end,
    calculate =  function (self, card, context)
        if context.main_scoring and (context.cardarea == G.play)  then
            SMODS.calculate_effect({
                score = card.edition.extra.score
            }, card)
            return {
                func = function ()
                    card.edition.extra.score = card.edition.extra.score + card.edition.extra.score_gain
                    card.edition.extra.score_gain = card.edition.extra.score_gain + card.edition.extra.score_gain_gain
                end
            }
        end
        if context.pre_joker and (context.cardarea == G.jokers)  then
            SMODS.calculate_effect({
                score = card.edition.extra.score
            }, card)
            return {
                func = function ()
                    card.edition.extra.score = card.edition.extra.score + card.edition.extra.score_gain
                    card.edition.extra.score_gain = card.edition.extra.score_gain + card.edition.extra.score_gain_gain
                end
            }
        end
    end,
    weight = 5,
}