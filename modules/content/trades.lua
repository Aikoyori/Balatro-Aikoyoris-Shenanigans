---@type {[string]:AKYRS.TradeProfession}
AKYRS.TradeProfessions = {}
---@type string[]
AKYRS.TradeProfessions_Keys = {}


---@class AKYRS.TradeProfession: SMODS.GameObject
---@field trade_ui fun(self:AKYRS.TradeProfession):table[] ui for the trading part lol. this must return table of nodes
---@field full_trade_ui fun(self:AKYRS.TradeProfession):table ui for trading part + villager sprite object. DO NOT OVERRIDE UNLESS YOU NEED TO. returns root object
---@field extra_top_ui fun(self:AKYRS.TradeProfession):table ui for additional thing like reroll button
---@field extra_left_ui fun(self:AKYRS.TradeProfession):table ui for left additional thing like reroll button
---@field extra_right_ui fun(self:AKYRS.TradeProfession):table ui for right additional thing like reroll button
---@field get_shop_size fun(self:AKYRS.TradeProfession):{ w: number, h : number} nomber for shop height so it is not as tall
---@field loc_vars? fun(self: AKYRS.TradeProfession|table, info_queue: table, card: Card|table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://github.com/Steamodded/smods/wiki/Localization#loc_vars) documentation for return value details. 
---@field refresh_shop_ui fun(self:AKYRS.TradeProfession) fucking kill shop ui
---@field is_enabled fun(self:AKYRS.TradeProfession):boolean is it enabled? used to constant check so don't print bruh 
---@field button_func string button func in `G.FUNCS` for the tab for enable thing stuff like that
---@field enable fun(self:AKYRS.TradeProfession, enable:boolean) enable it brah
---@field no_scroll boolean does it scroll?
---@overload fun(self:AKYRS.TradeProfession): AKYRS.TradeProfession
AKYRS.TradeProfession = SMODS.GameObject:extend{
    set = 'TradeProfession',
    obj_table = AKYRS.TradeProfessions,
    obj_buffer = AKYRS.TradeProfessions_Keys,
    atlas = "akyrs_villager",
    pos = { x = 0, y = 0 },
    required_params = {
        'key',
    },
    class_prefix = 'profession',
    trade_ui = function ()
        return {
            AKYRS.text_prefab({
                text = "lush cave here " .. self.key
            })
        }
    end,
    config = {},
    create_fake_card = function(self)
        return { ability = copy_table(self.config), fake_card = self.key }
    end,
    generate_ui = function (...)
        return SMODS.Center.generate_ui(...)
    end,
    full_trade_ui = function (self)
        AKYRS.VILLAGER_SHOP_PANEL_KEY = self.key
        if AKYRS.VILLAGER_SHOP_PANEL and AKYRS.VILLAGER_SHOP_PANEL.remove then
            AKYRS.VILLAGER_SHOP_PANEL:remove()
            AKYRS.VILLAGER_SHOP_PANEL = nil
        end
        local extra_top_ui = nil
        if self.extra_top_ui then
            extra_top_ui = self:extra_top_ui()
        end
        local extra_left_ui = nil
        if self.extra_left_ui then
            extra_left_ui = self:extra_left_ui()
        end
        local extra_right_ui = nil
        if self.extra_right_ui then
            extra_right_ui = self:extra_right_ui()
        end
        local shop_size = {}
        if self.get_shop_size then
            shop_size = self:get_shop_size()
        end
        local box = {
            content = {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        colour = G.C.CLEAR,
                        padding = 0.15,
                    },
                    nodes = self:trade_ui()
                },
                config = { align = "cm" }
            },
            overflow = {
                node_config = {
                    minh = shop_size.h or 5.5,
                    maxh = shop_size.h or 5.5,
                    minw = shop_size.w or (8 + (self.no_scroll and 0.5 or 0)),
                    maxw = shop_size.w or (8 + (self.no_scroll and 0.5 or 0)),
                    padding = 0.01,
                    r = 0.1,
                    align = 'm',
                    outline = 1,
                    outline_colour = G.C.GREEN,
                },
            }

        }
        AKYRS.VILLAGER_SHOP_PANEL = self.no_scroll and UIBox(box.content) or SMODS.UIScrollBox(box)
        local tradingui = {
            { n = G.UIT.R, nodes = {
                {
                    n = G.UIT.C,
                    config = self.no_scroll and box.overflow.node_config,
                    nodes = {
                        { n = G.UIT.R, nodes = {
                            
                            {
                                n = G.UIT.O,
                                config = {
                                    object = AKYRS.VILLAGER_SHOP_PANEL
                                }
                            }
                        }},
                    }
                },
                -- scrollbar
                {
                    n = G.UIT.C,
                    nodes = {
                        not self.no_scroll and SMODS.GUI.scrollbar({
                            h = shop_size.h or 5.5,
                            w = 0.5,
                            min = 0,
                            max = 1,
                            bg_colour = { 0, 0, 0, 0.15 },
                            scroll_collision_obj = AKYRS.VILLAGER_SHOP_PANEL,
                            knob_h = 1.4,
                            scroll_mult = 1
                        })
                    }
                },
                -- the villager sprite :sob:
                {
                    n = G.UIT.C,
                    config = {
                        maxw = 3,
                    },
                    nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                object = SMODS.create_sprite(G.HUD.T.x, G.HUD.T.y, 95 / G.TILESIZE * 0.55, 205 / G.TILESIZE * 0.55, self.atlas, self.pos)
                            }
                        }
                    }
                },
            }},
            -- trading content

        }
        if extra_top_ui then
            table.insert(tradingui, 1, extra_top_ui)
        end
        if extra_right_ui then
            table.insert(tradingui[1].nodes, 3, extra_right_ui)
        end
        if extra_left_ui then
            table.insert(tradingui[1].nodes, 1, extra_left_ui)
        end
        return {
            n = G.UIT.ROOT,
            config = {
                emboss = 0.05,
                minh = shop_size.h or 5.5,
                maxh = shop_size.h or 5.5,
                r = 0.1,
                minw = 8,
                align = "cm",
                padding = 0.2,
                colour = G.C.BLACK,
            },
            nodes = tradingui
        }
    end,
    refresh_shop_ui = function(self)
        AKYRS.VILLAGER_SHOP_PANEL_KEY = self.key
        local old = AKYRS.VILLAGER_SHOP_PANEL
        local parent = old.parent
        local shop_size = {}
        if self.get_shop_size then
            shop_size = self:get_shop_size()
        end
        local box = {
            content = {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        colour = G.C.CLEAR,
                        padding = 0.15,
                    },
                    nodes = self:trade_ui()
                },
                config = { align = "cm" }
            },
            overflow = {
                node_config = {
                    minh = shop_size.h or 5.5,
                    maxh = shop_size.h or 5.5,
                    minw = shop_size.w or (8 + (self.no_scroll and 0.5 or 0)),
                    maxw = shop_size.w or (8 + (self.no_scroll and 0.5 or 0)),
                    padding = 0.01,
                    r = 0.1,
                    outline = 1,
                    outline_colour = G.C.GREEN,
                },
            }
        }
        local xkcd = self.no_scroll and UIBox(box.content) or SMODS.UIScrollBox(box)

        if old and old.remove then
            old:remove()
        end
        parent.config.object = xkcd
        parent.UIBox:recalculate()
    end,
    inject = function(self)
        
    end,
}

AKYRS.set_to_emerald_sell_cost = {
    Spectral = 2,
    Scenario = 3,
    Replicant = 2,
}

AKYRS.set_to_emerald_buy_cost = {
    Spectral = 4,
    Scenario = 6,
    Replicant = 4,
}

AKYRS.determine_emerald_buy_cost = function (center)
    if center.key == "j_akyrs_emerald" then
        return 10
    end
    if center.set == "Joker" then
        if center.rarity == 2 then return 4 end
        if center.rarity == 3 then return 8 end
        if center.rarity == 4 then return 20 end
    end
    
    return AKYRS.set_to_emerald_buy_cost[center.set] or 2
end



AKYRS.TradeProfession {
    key = 'pawnbroker',
    no_scroll = true,
    pos = { x = 1, y = 0 },
    trade_ui = function (self)
        return {
            {
                n = G.UIT.R,
                config = { minw = 8, minh = 5.5, align = 'cm' },
                nodes = {
                    AKYRS.row_prefab({
                        minw = 8,
                        minh = 5.5,
                        nodes = {
                            AKYRS.emerald_indicator({
                                ref_table = AKYRS,
                                ref_value = 'pawnbroker_value_text',
                                scale = 2,
                                align = 'cm',
                                padding = 0.1,
                                text_func = 'akyrs_emerald_pawnbroker_update_value',
                            }),
                            AKYRS.button_prefab({ 
                                padding = 0.1,
                                func = 'akyrs_emerald_can_sell_selected_cards',
                                button = 'akyrs_emerald_sell_selected_cards',
                                children = {
                                    AKYRS.text_prefab({localize = {'b_akyrs_sell_selected'}})
                                }
                            }),
                        }
                    }),
                }
            }
        }
    end
}


AKYRS.TradeProfession {
    key = 'merchant',
    pos = { x = 2, y = 0 },
    extra_left_ui = function (self)
        return AKYRS.row_prefab{
            padding = 0.1,
            uit = G.UIT.C,
            h = 5,
            nodes = {
                AKYRS.button_prefab{
                    colour = G.C.RED,
                    h = 2.2,
                    w = 2,
                    button = 'akyrs_ui_merchant_reroll',
                    func = 'akyrs_ui_merchant_can_reroll',
                    children = {
                        AKYRS.text_prefab { localize = { "k_reroll" }, scale = 0.5, uit = G.UIT.R },
                        AKYRS.emerald_indicator({
                            ref_table = G.GAME,
                            ref_value = 'akyrs_deals_reroll_price',
                            scale = 1.5,
                            padding = 0.1,
                            text_func = 'akyrs_emerald_pawnbroker_update_value',
                        }),
                    }
                },
                AKYRS.button_prefab{
                    colour = G.C.GREEN,
                    h = 2.2,
                    w = 2,
                    button = 'akyrs_ui_merchant_add_deals',
                    func = 'akyrs_ui_merchant_can_add_deals',
                    children = {
                        AKYRS.text_prefab { localize = { "k_akyrs_add_trade_row" }, scale = 0.5, uit = G.UIT.R },
                        AKYRS.emerald_indicator({
                            ref_table = G.GAME,
                            ref_value = 'akyrs_deals_add_row_price',
                            scale = 1.5,
                            align = 'cm',
                            padding = 0.1,
                            text_func = 'akyrs_emerald_pawnbroker_update_value',
                        }),
                    }
                },
            }
        }
    end,
    get_shop_size = function (self)
        return {
            w = 5.8,
        }
    end,
    trade_ui = function (self)
        local uit = {{ n = G.UIT.R, config = { padding = 0.1,}, nodes = {} }}
        for i, c in ipairs(G.GAME.akyrs_deals) do
            uit[#uit].nodes[#(uit[#uit].nodes)+1] = AKYRS.create_ui_for_trade_item(i, c, G.GAME.akyrs_deals)
            if #uit[#uit].nodes >= 3 then
                uit[#uit+1] = { n = G.UIT.R, config = { padding = 0.1,} , nodes = {} }
            end
        end
        return {
            {
                n = G.UIT.R,
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { minw = 5.8, align = 'cm' },
                        nodes = {
                            {
                                n = G.UIT.R,
                                nodes = uit,
                            }
                        }
                    }
                }
            }
        }
    end
}

AKYRS.TradeProfession {
    key = 'enchantsmith',
    pos = { x = 3, y = 0 },
    no_scroll = true,
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. (not self:is_enabled() and "_locked" or ""),
            vars = {
                elements = {
                    AKYRS.emerald_icon({ scale = 0.6 })
                }
            }
        }
    end,
    is_enabled = function (self)
        return G.GAME.akyrs_unlocked_enchantsmith
    end,
    button_func = 'akyrs_enchantsmith_tab_button',
    trade_ui = function (self)
        AKYRS.akyrs_enchantsmith_bias = AKYRS.akyrs_enchantsmith_bias or "1"
        AKYRS.akyrs_enchantsmith_enchantment_count = AKYRS.akyrs_enchantsmith_enchantment_count or "1"
        return {
            {
                n = G.UIT.C,
                config = { minw = 3.8, minh = 5.5, align = 'cm' },
                nodes = {
                    AKYRS.row_prefab({
                        minw = 3.8,
                        minh = 5.5,
                        nodes = {
                            AKYRS.emerald_indicator({
                                ref_table = AKYRS,
                                ref_value = 'enchantsmith_value_text',
                                scale = 2,
                                align = 'cm',
                                minw = 3.5, maxw = 3.5,
                                padding = 0.1,
                                text_func = 'akyrs_emerald_enchantment_cost_update_value',
                            }),
                            AKYRS.button_prefab({ 
                                padding = 0.3,
                                colour = G.C.PURPLE,
                                func = 'akyrs_emerald_can_enchant_selected_cards',
                                button = 'akyrs_emerald_enchant_selected_cards',
                                children = {
                                    AKYRS.text_prefab({localize = {'b_akyrs_enchant_selected'}})
                                }
                            }),
                            -- todo: make a numerical spinner for enchantments and level (bias)
                            AKYRS.row_prefab{
                                nodes = {
                                    AKYRS.text_prefab{ uit = G.UIT.R, localize = { 'k_akyrs_ench_power' }},
                                    AKYRS.numerical_input({
                                        w = 1.5, h = 0.7, step_w = 0.7, 
                                        extended_corpus = true, 
                                        prompt_text = "",
                                        all_colour = G.C.PALE_GREEN,
                                        id = "akyrs_enchantsmith_bias", ref_table = AKYRS, ref_value = "akyrs_enchantsmith_bias",
                                        keyboard_offset = -3.2, text_scale = 0.5, button_scale = 0.7, max = 30, min = 1,
                                    }),
                                }
                            },
                            AKYRS.row_prefab{
                                nodes = {
                                    AKYRS.text_prefab{ uit = G.UIT.R, localize = { 'k_akyrs_num_o_ench' }},
                                    AKYRS.numerical_input({
                                        w = 1.5, h = 0.7, step_w = 0.7, 
                                        extended_corpus = true, 
                                        prompt_text = "",
                                        all_colour = G.C.PURPLE,
                                        id = "akyrs_enchantsmith_count", ref_table = AKYRS, ref_value = "akyrs_enchantsmith_enchantment_count",
                                        keyboard_offset = -3.2, text_scale = 0.5, button_scale = 0.7, max = 4, min = 1,
                                    }),
                                }
                            },
                            AKYRS.text_prefab{ uit = G.UIT.R, text = '-- x -- x --'},
                        }
                    }),
                }
            },
            {
                n = G.UIT.C,
                config = { minw = 3.8, minh = 5.5, align = 'cm' },
                nodes = {
                    AKYRS.row_prefab({
                        minw = 3.8,
                        minh = 5.5,
                        nodes = {
                            AKYRS.emerald_indicator({
                                ref_table = AKYRS,
                                ref_value = 'pawnbroker_value_text',
                                scale = 2,
                                align = 'cm',
                                padding = 0.1,
                                text_func = 'akyrs_emerald_pawnbroker_update_value',
                            }),
                            AKYRS.button_prefab({ 
                                padding = 0.1,
                                func = 'akyrs_emerald_can_sell_selected_cards',
                                button = 'akyrs_emerald_sell_selected_cards',
                                children = {
                                    AKYRS.text_prefab({localize = {'b_akyrs_sell_selected'}})
                                }
                            }),
                        }
                    }),
                }
            },
        }
    end
}