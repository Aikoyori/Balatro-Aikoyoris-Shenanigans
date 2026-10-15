---@type {[string]:AKYRS.TradeProfession}
AKYRS.TradeProfessions = {}
---@type string[]
AKYRS.TradeProfessions_Keys = {}


---@class AKYRS.TradeProfession: SMODS.GameObject
---@field trade_ui fun(self:AKYRS.TradeProfession):table[] ui for the trading part lol. this must return table of nodes
---@field full_trade_ui fun(self:AKYRS.TradeProfession):table ui for trading part + villager sprite object. DO NOT OVERRIDE UNLESS YOU NEED TO. returns root object
---@field is_enabled fun(self:AKYRS.TradeProfession):boolean is it enabled? used to constant check so don't print bruh 
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
    full_trade_ui = function (self)
        if AKYRS.VILLAGER_SHOP_PANEL and AKYRS.VILLAGER_SHOP_PANEL.remove then
            AKYRS.VILLAGER_SHOP_PANEL:remove()
            AKYRS.VILLAGER_SHOP_PANEL = nil
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
                config = { align = "cm"}
            },
            overflow = {
                node_config = {
                    minh = 5.5,
                    maxh = 5.5,
                    minw = 8 + (self.no_scroll and 0.5 or 0),
                    maxw = 8 + (self.no_scroll and 0.5 or 0),
                    padding = 0.01,
                    r = 0.1,
                    outline = 1,
                    outline_colour = G.C.GREEN,
                },
            }

        }
        AKYRS.VILLAGER_SHOP_PANEL = self.no_scroll and UIBox(box.content) or SMODS.UIScrollBox(box)
        return {
            n = G.UIT.ROOT,
            config = {
                emboss = 0.05,
                minh = 5.5,
                maxh = 5.5,
                r = 0.1,
                minw = 8,
                align = "cm",
                padding = 0.2,
                colour = G.C.BLACK,
            },
            nodes = {
                -- trading content
                {
                    n = G.UIT.C,
                    config = self.no_scroll and box.overflow.node_config,
                    nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                object = AKYRS.VILLAGER_SHOP_PANEL
                            }
                        }
                    }
                },
                -- scrollbar
                {
                    n = G.UIT.C,
                    nodes = {
                        not self.no_scroll and SMODS.GUI.scrollbar({
                            h = 5.5,
                            w = 0.5,
                            min = 0,
                            max = 1,
                            bg_colour = { 0, 0, 0, 0.15 },
                            scroll_collision_obj = AKYRS.VILLAGER_SHOP_PANEL,
                            knob_h = 0.6,
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
            }
        }
    end,
    inject = function(self)
        
    end,
}

AKYRS.determine_emerald_sell_value = function (card)
    if card.config.center.key == "j_akyrs_emerald" then
        return 5
    end
    if card.ability.set == "Joker" then
        if card.config.center.rarity == 2 then return 2 end
        if card.config.center.rarity == 3 then return 3 end
        if card.config.center.rarity == 4 then return 6 end
    end
    return 1 
end

G.FUNCS.akyrs_emerald_can_sell_selected_cards = function (e)
    local filtered_result = AKYRS.filter_table(SMODS.merge_lists{ G.jokers.highlighted, G.consumeables.highlighted }, function (item, index)
        return item and not SMODS.is_eternal(item)
    end, true, true)
    AKYRS.button_enable_func(e, {
        func = function (e)
            return #filtered_result > 0
        end,
        button = 'akyrs_emerald_sell_selected_cards'
    })
end

G.FUNCS.akyrs_emerald_sell_selected_cards = function (e)
    local filtered_result = AKYRS.filter_table(SMODS.merge_lists{ G.jokers.highlighted, G.consumeables.highlighted }, function (item, index)
        return item and not SMODS.is_eternal(item)
    end, true, true)
    play_sound('akyrs_villager_yes', nil, 2.2)
    SMODS.destroy_cards(filtered_result)
    if #filtered_result > 0 then 
        for i, c in ipairs(filtered_result) do
            local x = AKYRS.determine_emerald_sell_value(c)
            AKYRS.Currencies['curr_akyrs_emerald']:change_value(x)
            AKYRS.Currencies['curr_akyrs_emerald']:transactional_sound(x)
        end
    end
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
    trade_ui = function (self)
        return {
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "sulfur cave here 12", uit = G.UIT.R}),
        }
    end
}