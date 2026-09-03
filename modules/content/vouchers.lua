SMODS.Voucher {
    key = "alphabet_soup",
    atlas = 'aikoyoriVouchers', pos = { x = 2, y = 0 } ,
    cost = 8,
    config = {
        extras = {
            addentum_hand = 1
            addentum = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.addentum,
                card.ability.extras.addentum_hand,
            }
        }
    end,
    redeem = function (self, card) 
        G.GAME.akyrs_character_stickers_enabled = true
        G.GAME.akyrs_wording_enabled = true
        SMODS.change_play_limit(card.ability.extras.addentum)
        SMODS.change_discard_limit(card.ability.extras.addentum)
        G.hand:change_size(card.ability.extras.addentum_hand)
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_character_stickers_enabled = false
        SMODS.change_play_limit(-card.ability.extras.addentum)
        SMODS.change_discard_limit(-card.ability.extras.addentum)
        G.hand:change_size(-card.ability.extras.addentum_hand)
        G.GAME.akyrs_wording_enabled = false
        for _,c in ipairs(G.playing_cards) do
            c:set_sprites(c.config.center,c.config.card)
        end
    end,
    in_pool = function (self, args)
        return not G.GAME.akyrs_mathematics_enabled
    end
}

local set_sprite_with_canvas = function(self, card, front)
    G.E_MANAGER:add_event(Event({
        blockable = false,
        func = function()
            card.canvas_text = SMODS.CanvasSprite {
                canvasW = 71, canvasH = 95,
                text_offset = { x = 36.5, y = 86 },
                text_colour = G.C.UI.TEXT_DARK,
                text_width = 72,
                text_height = 12,
                text_font = "akyrs_Vouchie",
                ref_table = G.GAME.akyrs_redemption_codes or {},
                ref_value = self.akyrs_special_vouchers,
            }
            return true
        end
    }))
end

SMODS.Voucher {
    key = "crossing_field",
    atlas = 'aikoyoriVouchers', pos = { x = 3, y = 0 } ,
    cost = 12,
    requires = { "v_akyrs_alphabet_soup" },
    config = {
        extras = {
            addentum_hand = 1
            addentum = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.addentum,
                card.ability.extras.addentum_hand,
            }
        }
    end,
    redeem = function (self, card) 
        G.GAME.akyrs_letters_mult_enabled = true
        SMODS.change_play_limit(card.ability.extras.addentum)
        SMODS.change_discard_limit(card.ability.extras.addentum)
        G.hand:change_size(card.ability.extras.addentum_hand)
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_letters_mult_enabled = false
        SMODS.change_play_limit(-card.ability.extras.addentum)
        SMODS.change_discard_limit(-card.ability.extras.addentum)
        G.hand:change_size(-card.ability.extras.addentum_hand)
    end,
    in_pool = function (self, args)
        return not G.GAME.akyrs_mathematics_enabled
    end
}

SMODS.Voucher {
    key = "banquet",
    atlas = 'aikoyoriVouchers', pos = { x = 0, y = 0 } ,
    cost = 15,
    config = {
        extras = {
            addentum = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.addentum
            }
        }
    end,
    redeem = function (self, card) 
        SMODS.change_play_limit(card.ability.extras.addentum)
        SMODS.change_discard_limit(card.ability.extras.addentum)
        G.hand:change_size(card.ability.extras.addentum)
    end,
    unredeem = function (self, card) 
        SMODS.change_play_limit(-card.ability.extras.addentum)
        SMODS.change_discard_limit(-card.ability.extras.addentum)
        G.hand:change_size(-card.ability.extras.addentum)
    end,
}

SMODS.Voucher {
    key = "worlds_end",
    atlas = 'aikoyoriVouchers', pos = { x = 1, y = 0 } ,
    cost = 25,
    config = {
        extras = {
            addentum = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras.addentum
            }
        }
    end,
    requires = { "v_akyrs_banquet" },
    redeem = function (self, card) 
        SMODS.change_play_limit(card.ability.extras.addentum)
        SMODS.change_discard_limit(card.ability.extras.addentum)
        G.hand:change_size(card.ability.extras.addentum)
    end,
    unredeem = function (self, card) 
        SMODS.change_play_limit(-card.ability.extras.addentum)
        SMODS.change_discard_limit(-card.ability.extras.addentum)
        G.hand:change_size(-card.ability.extras.addentum)
    end,
}

SMODS.Voucher {
    key = "i_owe_you",
    atlas = 'aikoyoriVouchers', pos = { x = 4, y = 0 } ,
    cost = 10,
    config = {
    },
    loc_vars = function (self, info_queue, card)
        return {
        }
    end,
    requires = {  },
    redeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = 0
        AKYRS.toggle_shop_availability('shoppage_akyrs_jimbos_chicanery', true)
        G.FUNCS.akyrs_shift_hud(true)
    end,
    unredeem = function (self, card) 
        AKYRS.toggle_shop_availability('shoppage_akyrs_jimbos_chicanery', false)
    end,
    calculate = function (self, card, context)
        if context.starting_shop then
            if AKYRS.get_free_joker_roll_tier() == 0 then
                SMODS.add_voucher_to_shop("v_akyrs_premium_free_joker")
            elseif AKYRS.get_free_joker_roll_tier() == 1 then
                SMODS.add_voucher_to_shop("v_akyrs_super_premium_free_joker")
            elseif AKYRS.get_free_joker_roll_tier() == 2 then
                SMODS.add_voucher_to_shop("v_akyrs_ultra_premium_free_joker")
            end
        end
    end,
    disable_shine = true,
}

SMODS.Voucher {
    key = "premium_free_joker",
    atlas = 'aikoyoriVouchers', pos = { x = 5, y = 0 } ,
    cost = 5,
    config = {
    },
    loc_vars = function (self, info_queue, card)
        return {
        }
    end,
    redeem_voucher_level = 1,
    set_sprites = set_sprite_with_canvas,
    akyrs_special_vouchers = "normal",
    in_pool = function (self, args)
        return false
    end,
    requires = { "v_akyrs_i_owe_you" },
    redeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = (G.GAME.akyrs_premium_joker_roll_tier or 0) + 1
        G.GAME.akyrs_chicanery_rerolls_info.common_has = G.GAME.akyrs_chicanery_rerolls_info.common_has + 3
        G.GAME.akyrs_chicanery_rerolls_info.common_left = G.GAME.akyrs_chicanery_rerolls_info.common_left + 3
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = (G.GAME.akyrs_premium_joker_roll_tier or 0) - 1
        G.GAME.akyrs_chicanery_rerolls_info.common_has = G.GAME.akyrs_chicanery_rerolls_info.common_has - 3
        G.GAME.akyrs_chicanery_rerolls_info.common_left = G.GAME.akyrs_chicanery_rerolls_info.common_left - 3
    end,
}

SMODS.Voucher {
    key = "super_premium_free_joker",
    atlas = 'aikoyoriVouchers', pos = { x = 6, y = 0 } ,
    cost = 15,
    akyrs_special_vouchers = "super",
    config = {
    },
    loc_vars = function (self, info_queue, card)
        return {
        }
    end,
    set_sprites = set_sprite_with_canvas,
    in_pool = function (self, args)
        return false
    end,
    requires = { "v_akyrs_premium_free_joker" },
    redeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = G.GAME.akyrs_premium_joker_roll_tier + 1
        G.GAME.akyrs_chicanery_rerolls_info.uncommon_has = G.GAME.akyrs_chicanery_rerolls_info.uncommon_has + 1
        G.GAME.akyrs_chicanery_rerolls_info.uncommon_left = G.GAME.akyrs_chicanery_rerolls_info.uncommon_left + 1
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = G.GAME.akyrs_premium_joker_roll_tier - 1
        G.GAME.akyrs_chicanery_rerolls_info.uncommon_has = G.GAME.akyrs_chicanery_rerolls_info.uncommon_has - 1
        G.GAME.akyrs_chicanery_rerolls_info.uncommon_left = G.GAME.akyrs_chicanery_rerolls_info.uncommon_left - 1
    end,
}
SMODS.Voucher {
    key = "ultra_premium_free_joker",
    atlas = 'aikoyoriVouchers', pos = { x = 7, y = 0 } ,
    cost = 30,
    akyrs_special_vouchers = "ultra",
    config = {
    },
    set_sprites = set_sprite_with_canvas,
    loc_vars = function (self, info_queue, card)
        return {
        }
    end,
    in_pool = function (self, args)
        return false
    end,
    requires = { "v_akyrs_super_free_joker" },
    redeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = G.GAME.akyrs_premium_joker_roll_tier + 1
        G.GAME.akyrs_chicanery_rerolls_info.rare_has = G.GAME.akyrs_chicanery_rerolls_info.rare_has + 1
        G.GAME.akyrs_chicanery_rerolls_info.rare_left = G.GAME.akyrs_chicanery_rerolls_info.rare_left + 1
    end,
    unredeem = function (self, card) 
        G.GAME.akyrs_premium_joker_roll_tier = G.GAME.akyrs_premium_joker_roll_tier - 1
        G.GAME.akyrs_chicanery_rerolls_info.rare_has = G.GAME.akyrs_chicanery_rerolls_info.rare_has - 1
        G.GAME.akyrs_chicanery_rerolls_info.rare_left = G.GAME.akyrs_chicanery_rerolls_info.rare_left - 1
    end,
}
