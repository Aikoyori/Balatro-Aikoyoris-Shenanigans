local all_sets = {}
for i,k in pairs(G.P_CENTER_POOLS) do
    all_sets[i] = true
end

SMODS.Sticker{
    key = "self_destructs",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 0, y = 0},
    rate = 0,
    badge_colour = G.C.RED,
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    should_apply = function (self, card, center, area, bypass_reroll)
        if self.sets[card.ability.set] then
            if G.GAME.modifiers.akyrs_spawn_self_destruct and pseudorandom((area == G.pack_cards and 'akyrs_packs_self_destruct' or 'akyrs_self_destruct')..G.GAME.round_resets.ante) > 0.9 then
                return true
            end
        end
        return false
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card:set_cost()
    end
}

SMODS.Sticker{
    key = "sigma",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 3, y = 0},
    rate = 0,
    badge_colour = HEX("ee36ff"),
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability.akyrs_stay_sigma = true
        card:set_cost()
    end,
    
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('akyrs_texelated', nil, card.ARGS.send_to_shader, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

AKYRS.copper_stickers = {
}



SMODS.Sticker{
    key = "oxidising",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 5, y = 0},
    rate = 0,
    badge_colour = HEX("b74912"),
    sets =  all_sets,
    should_apply = function (self, card, center, area, bypass_reroll)
        if self.sets[card.ability.set] then
            if G.GAME.modifiers.akyrs_spawn_oxidising and pseudorandom((area == G.pack_cards and 'akyrs_packs_oxi_' or 'akyrs_oxi_')..G.GAME.round_resets.ante) > 0.7 then
                return true
            end
        end
        return false
    end,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_copper_scrape_tip"]
        return {
            key = AKYRS.compare(card.ability[self.key],">=", 4) and self.key.."_full" or self.key,
            vars = {
                (card.ability[self.key] - 1) * 25,
                localize("k_akyrs_copper_oxidation_stage_"..card.ability[self.key]+1),
                card.ability.akyrs_oxidising_round,
                card.ability.akyrs_oxidising_round ~= 1 and localize("k_akyrs_round_plural") or localize("k_akyrs_round_singular"),
                25
            }
        }
    end,
    apply = function(self, card, val)
        if val == true then val = 1 else val = nil end
        card.ability[self.key] = val
        card.ability.akyrs_oxidising_round = val > 0 and 2 or nil
        card.cost = math.floor(card.cost / 2)
    end,
    calculate = function (self, card, context)
        if context.akyrs_copper_end_of_round then
            return {
                akyrs_ignore_copper_calculation = true,
                func = function ()
                    card.ability.akyrs_oxidising_round = card.ability.akyrs_oxidising_round - 1
                    if AKYRS.compare(card.ability.akyrs_oxidising_round,"<=", 0) and AKYRS.compare(card.ability[self.key],"<", 4) then
                        SMODS.calculate_effect({
                            func = function ()
                                card.ability[self.key] = card.ability[self.key] + 1
                                card.ability.akyrs_oxidising_round = 2
                            end
                        }, card)
                    end
                end,
                message = localize("k_akyrs_oxidise_ex"),
                colour = HEX("337a57")
            }
        end
        if context.using_consumeable then
            return {
                akyrs_ignore_copper_calculation = true,
                func = function ()
                    local psrd = pseudorandom(pseudoseed("akyrs_oxidising_scrape_"..card.config.center_key))
                    local cond = AKYRS.compare(card.ability[self.key],">", 1) or AKYRS.compare(card.ability.akyrs_oxidising_round,"<", 2)
                    if cond and psrd >= 0.9 then
                        SMODS.calculate_effect(
                            {
                                akyrs_ignore_copper_calculation = true,
                                func = function ()
                                    AKYRS.simple_event_add(
                                        function ()
                                            card.ability[self.key] = (card.ability[self.key] or 4) - 1
                                            card.ability.akyrs_oxidising_round = 2
                                            return true
                                        end, 0
                                    )
                                end,
                                message = localize("k_akyrs_scrape_ex"),
                                colour = HEX("994433")
                            }, card
                        )
                    elseif cond then
                        SMODS.calculate_effect(
                            {
                                akyrs_ignore_copper_calculation = true,
                                message = localize("k_nope_ex"),
                                colour = G.C.PURPLE
                            }, card
                        )
                    end
                end,
            }
        end
    end,
    draw = function (self, card, layer)
        local val = card.ability.akyrs_oxidising and math.min(4,math.max(1,card.ability.akyrs_oxidising)) or 1
        
        AKYRS.copper_stickers[val] = AKYRS.copper_stickers[val] or Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["akyrs_aikoyoriStickers"], { x = 4 + val, y = 0})
        AKYRS.copper_stickers[val].role.draw_major = card
        AKYRS.copper_stickers[val]:draw_shader('dissolve', nil, nil, nil, card.children.center)
    end
}



SMODS.Sticker{
    key = "attention",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 0, y = 1},
    rate = 0,
    badge_colour = HEX("FF6D6D"),
    sets =  { ["Default"] = true, ["Enhanced"] = true, ["Base"] = true },
    apply = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function (self, card, context)
        if context.debuff_hand and card.area == G.hand then
            local contains_attention = false
            for _,_c in ipairs(context.full_hand) do
                if _c.ability.akyrs_attention then
                    contains_attention = true
                end
            end
            if not contains_attention then
                return {
                    debuff = true,
                    debuff_text = localize("k_akyrs_must_pay_attention"),
                    func = function ()
                        AKYRS.simple_event_add(
                            function()
                                card:juice_up(0.2,0.2)
                            return true
                        end, 0)
                    end
                }
            end
        end
        if context.destroy_card and (context.cardarea == G.play or context.cardarea == 'unscored') then
            if card == context.destroy_card then
                return {
                    remove = true
                }
            end
        end
    end,
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}


SMODS.Sticker{
    key = "concealed",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 1, y = 1},
    rate = 0,
    badge_colour = HEX("6394ff"),
    sets =  all_sets,
    should_apply = function (self, card, center, area, bypass_reroll)
        if self.sets[card.ability.set] then
            if G.GAME.modifiers.akyrs_spawn_concealed and pseudorandom((area == G.pack_cards and 'akyrs_packs_concealed_' or 'akyrs_concealed_')..G.GAME.round_resets.ante) > 0.7 then
                return true
            end
        end
        return false
    end,
    apply = function (self, card, val)
        card.ability[self.key] = val
        card:set_ability(card.config.center)
        card:set_sprites(card.config.center, card.config.base)
        card.cost = 5
        card.sell_cost = 3
    end,
    calculate = function(self, card, context)
    end,    
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

SMODS.Sticker{
    key = "crystalised",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 2, y = 1},
    rate = 0,
    badge_colour = HEX("d285ff"),
    sets =  { ["Default"] = true, ["Enhanced"] = true, ["Base"] = true },
    calculate = function(self, card, context)
        if context.debuff_hand and AKYRS.find_index(context.full_hand, card) then
            return {
                debuff = true,
                debuff_text = localize("k_akyrs_crystalised_warning"),
                function ()
                    AKYRS.simple_event_add(
                        function()
                            card:juice_up(0.2,0.2)
                        return true
                    end, 0)
                end
            }
        end
        if context.after and (context.cardarea == G.play or context.cardarea == 'unscored') then
            return {
                func = function()
                    AKYRS.simple_event_add(
                        function ()
                            self:apply(card, false)
                            AKYRS.juice_like_tarot(card)
                            return true
                        end
                    )
                end
            }
        end
    end,    
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

SMODS.Sticker{
    key = "latticed",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 3, y = 1},
    rate = 0,
    badge_colour = HEX("54bcc0"),
    sets =  { ["Joker"] = true },
    should_apply = function (self, card, center, area, bypass_reroll)
        if self.sets[card.ability.set] and AKYRS.should_give_eternal_likes(area) then
            if G.GAME.modifiers.akyrs_spawn_latticed and center.eternal_compat and pseudorandom((area == G.pack_cards and 'akyrs_packs_latticed_' or 'akyrs_latticed_')..G.GAME.round_resets.ante) > 0.7 then
                return true
            end
        end
        return false
    end,
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

SMODS.Sticker{
    key = "sus",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 2, y = 0},
    rate = 0,
    badge_colour = HEX("72c8dd"),
    sets =  { ["Default"] = true, ["Enhanced"] = true, ["Base"] = true },
    calculate = function (self, card, context)
    end,
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}

SMODS.Sticker{
    key = "sale",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 4, y = 1},
    rate = 0,
    sets =  all_sets,
    should_apply = function (self, card, center, area, bypass_reroll)
        if self.sets[card.ability.set] then
            if G.GAME.modifiers.akyrs_spawn_steam_sale and pseudorandom((area == G.pack_cards and 'akyrs_packs_sale_' or 'akyrs_sale_')..G.GAME.round_resets.ante) > 0.4 then
                return true
            end
        end
        return false
    end,
    badge_colour = HEX("749265"),
    sets =  all_sets,
    config = {
        extras = {
            reduce = 0.5
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extras.reduce
            }
        }
    end,
    apply = function (self, card, val)
        card.ability[self.key] = val
        card.cost = 1
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            if card.ability.akyrs_sale then
                return {
                    dollars = -self.config.extras.reduce
                }
            end
        end
    end,
    calculate = function (self, card, context)
    end,
}


SMODS.Sticker{
    key = "pinned_right",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 9, y = 0},
    rate = 0,
    badge_colour = G.C.BLUE,
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    should_apply = function (self, card, center, area, bypass_reroll)
        return false
    end,
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center,nil,nil,0.15,-0.4)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center,nil,nil,0.15,-0.4)
    end
}

SMODS.Sticker{
    key = "locked",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 9, y = 1},
    rate = 0,
    badge_colour = G.C.PURPLE,
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    should_apply = function (self, card, center, area, bypass_reroll)
        return false
    end,
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center,nil,nil)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center,nil,nil)
    end
}

SMODS.Sticker{
    key = "marked",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 0, y = 2},
    rate = 0,
    badge_colour = G.C.BLACK,
    sets =  { ["Enhanced"] = true, ["Default"] = true },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                type(card.ability.akyrs_marked) == "string" and card.ability.akyrs_marked or "??????????"
            },
        }
    end,
    apply = function (self, card, val)
        card.ability.akyrs_marked = val
    end,
    calculate = function(self, card, context)
        if context.akyrs_mod_card_draw then
            AKYRS.map(context.priorities, function (cx)
                if cx.card == card then
                    cx.priority = cx.priority * 16
                end
            end, true)
            return {
                priority_modified = true
            }
        end
    end,
    should_apply = function (self, card, center, area, bypass_reroll)
        return false
    end,
}

SMODS.Sticker{
    key = "forced_selection",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 1, y = 2},
    rate = 0,
    badge_colour = G.C.BLACK,
    sets =  { ["Enhanced"] = true, ["Default"] = true },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
            },
        }
    end,
}
