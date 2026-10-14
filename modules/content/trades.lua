---@type {[string]:AKYRS.TradeProfession}
AKYRS.TradeProfessions = {}
---@type string[]
AKYRS.TradeProfessions_Keys = {}


---@class AKYRS.TradeProfession: SMODS.GameObject
---@field trade_ui fun(self:AKYRS.TradeProfession):table[] ui for the trading part lol. this must return table of nodes
---@field full_trade_ui fun(self:AKYRS.TradeProfession):table ui for trading part + villager sprite object. DO NOT OVERRIDE UNLESS YOU NEED TO. returns root object
---@field is_enabled fun(self:AKYRS.TradeProfession):boolean is it enabled? used to constant check so don't print bruh 
---@field enable fun(self:AKYRS.TradeProfession, enable:boolean) enable it brah
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
        AKYRS.VILLAGER_SHOP_PANEL = SMODS.UIScrollBox({
            content = {
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        colour = G.C.CLEAR,
                        padding = 0.05,
                    },
                    nodes = self:trade_ui()
                },
                config = { align = "cm"}
            },
            overflow = {
                node_config = {
                    minh = 6,
                    maxh = 6,
                    minw = 8,
                    maxw = 8,
                    padding = 0.01,
                    r = 0.1,
                },
            }

        })
        return {
            n = G.UIT.ROOT,
            config = {
                emboss = 0.05,
                minh = 6,
                maxh = 6,
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
                        SMODS.GUI.scrollbar({
                        h = 6,
                        w = 0.2,
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
                                object = SMODS.create_sprite(G.HUD.T.x, G.HUD.T.y, 95 / G.TILESIZE * 0.6, 205 / G.TILESIZE * 0.6, self.atlas, self.pos)
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

AKYRS.TradeProfession {
    key = 'pawnbroker',
    pos = { x = 1, y = 0 },
    trade_ui = function (self)
        return {
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
            AKYRS.text_prefab({ text = "lush cave here 12", uit = G.UIT.R}),
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