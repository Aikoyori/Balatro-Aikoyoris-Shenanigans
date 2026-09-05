-- this function is for when i wanna test ui
function AKYRS.debug_ui(ui) 
  G.FUNCS.overlay_menu({
    definition = create_UIBox_generic_options({
        contents = {
          ui
        }
      }),
		config = { align = "cm", offset = { x = 0, y = 0 }, major = G.ROOM_ATTACH, bond = 'Weak' }
  })
end


function G.FUNCS.akyrs_open_shop_window(e)
    if G.AKYRS_ACTIVE_SHOP and G[G.AKYRS_ACTIVE_SHOP] then
        G.FUNCS.akyrs_close_shop_window({config = {ref_table = G.AKYRS_ACTIVE_SHOP}})
    end
    
    if AKYRS.ShopPages[e.config.ref_table].show then
        AKYRS.ShopPages[e.config.ref_table]:show()
    end
    if G.shop then
      G.shop.alignment.offset.y = G.ROOM.T.y+11
    end
    G.AKYRS_ACTIVE_SHOP = e.config.ref_table
    G[G.AKYRS_ACTIVE_SHOP].alignment.offset.y = AKYRS.ShopPages[e.config.ref_table].target_y or -5.5 
end

function G.FUNCS.akyrs_close_shop_window(e)
  if G[e.config.ref_table] then
    if AKYRS.ShopPages[e.config.ref_table].hide then
        AKYRS.ShopPages[e.config.ref_table]:hide()
    end
    if G.shop then
      G.shop.alignment.offset.y = -5.3
    end
    G[e.config.ref_table].alignment.offset.y = 11
    G.AKYRS_ACTIVE_SHOP = nil
  end
end

function G.FUNCS.akyrs_close_active_shop_window(e)
  if G.AKYRS_ACTIVE_SHOP then
    if G.shop then
      G.shop.alignment.offset.y = -5.3
    end
    G[G.AKYRS_ACTIVE_SHOP].alignment.offset.y = 11
    if AKYRS.ShopPages[G.AKYRS_ACTIVE_SHOP].hide then
        AKYRS.ShopPages[G.AKYRS_ACTIVE_SHOP]:hide()
    end
    G.AKYRS_ACTIVE_SHOP = nil
  end
end


function G.FUNCS.akyrs_shop_btn_func(e)
  local shop = e.config.ref_table
  local shop_enabled = AKYRS.ShopPages[shop]:is_enabled()
  
  if G.AKYRS_ACTIVE_SHOP ~= shop and G.STATE == G.STATES.SHOP and shop_enabled and AKYRS.is_hud_slided then
    e.config.button = "akyrs_open_shop_window"
    e.config.colour = AKYRS.ShopPages[shop].button_colour
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end

function G.FUNCS.akyrs_shop_close_btn_func(e)
  local shop = e.config.ref_table
  if G.AKYRS_ACTIVE_SHOP == shop then
    e.config.button = "akyrs_close_shop_window"
    e.config.colour = G.C.RED
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end


function AKYRS.close_button_prefab(shop)
  return AKYRS.button_prefab({
      children = {
          AKYRS.text_prefab{ text = localize("k_akyrs_shop_close"), scale = 0.4 }
      },
      colour = G.C.RED,
      w = 1.5,
      h = 0.5,
      padding = 0.02,
      focus_args = { snap_to = true, nav = "wide" },
      ref_table = shop,
      func = "akyrs_shop_close_btn_func",
      button = "akyrs_close_shop_window",
  })
end

function AKYRS.attach_to_shop_sign(shop_sign)
  if G.AKYRS_SHOP_OVERLAY then G.AKYRS_SHOP_OVERLAY:remove() G.AKYRS_SHOP_OVERLAY = nil end
  G.AKYRS_SHOP_OVERLAY = UIBox{
    definition = AKYRS.UIDEF.shift_hud_button(),
      config = {align=('cli'), offset = {x=4.3,y=1.1},major = shop_sign}
  }
end

function G.FUNCS.akyrs_close_hud_btn_func(e)
  AKYRS.button_enable_func(e, {
    func = function (e)
      return AKYRS.is_hud_slided
    end,
    button = 'akyrs_shift_hud'
  })
end

function G.FUNCS.akyrs_more_less_hud_btn_func(e)
  AKYRS.button_enable_func(e, {
    func = function (e)
      return G.STATE == G.STATES.SHOP
    end,
    button = 'akyrs_shift_hud'
  })
end

function AKYRS.UIDEF.shift_hud_button()
  local scale = 0.3
  if AKYRS.is_hud_slided then
    AKYRS.strings.shop_more_button = localize("k_akyrs_shop_panel_hide")
  else
    AKYRS.strings.shop_more_button = localize("k_akyrs_shop_panel_reveal")
  end
  return {n=G.UIT.ROOT, config = {align = "cm", padding = 0, colour = G.C.CLEAR}, nodes={
      {n=G.UIT.R, config={align = "cm", r=0.1, colour = G.C.CLEAR, shadow = true, id = 'button_area', padding = 0.2}, nodes={
        {n=G.UIT.C, config={id = 'shift_hud_inner', align = "cm", minw = 0.1 ,padding = 0.1, r = 0.1, hover = true, colour = G.C.BOOSTER, button = "akyrs_shift_hud", shadow = true}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, maxh = 1.8}, nodes={
            {n=G.UIT.T, config={text='', scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, vert = true, func = 'set_button_pip', focus_args = { button = 'leftstick', orientation = 'c' }}}
          }},
          {n=G.UIT.R, config={align = "cm", padding = 0.1, maxh = 1.8}, nodes={
            {n=G.UIT.T, config={ref_table = AKYRS.strings, ref_value = 'shop_more_button', scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, vert = true}}
          }},
        }},
      }}
    }}
end


function AKYRS.UIDEF.hud_underlay()
    local scale = 0.4

    local contents = {}
    local ui_stuff = {}

    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK

    ui_stuff[#ui_stuff+1] = 
          {n=G.UIT.R, config={id = 'shift_hud_inner', align = "cm", minw = 4 ,padding = 0.05, r = 0.1, hover = true, colour = G.C.RED, button = "akyrs_shift_hud", func = "akyrs_close_hud_btn_func",  shadow = true, ref_table = {false}}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('k_akyrs_shop_close'), scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, }}
            }},
          }}
        
    
    ui_stuff[#ui_stuff+1] = 
      AKYRS.text_prefab{ uit = G.UIT.R, align = 'cm', text = localize("k_akyrs_shops_list"), colour = G.C.EDITION, scale = 0.5 }
    for _, k in ipairs(AKYRS.ShopPages_Buffer) do
        ui_stuff[#ui_stuff+1] = AKYRS.ShopPages[k]:_INTERNAL_generate_button()
    end

    contents.buttons = {
      {n=G.UIT.C, config={align = "cm", r=0.1, colour = G.C.CLEAR, shadow = true, id = 'button_area', padding = 0.2}, nodes=ui_stuff}
    }

    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, minh = 30, padding = 0.08}, nodes={
          {n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes=contents.buttons},
          }},
        }}
      }}
    }}
end

AKYRS.strings = AKYRS.strings or {
  shop_more_button = "REPLACE_THIS",
}

AKYRS.ShopPages = {}
AKYRS.ShopPages_Buffer = {}

---@class AKYRS.ShopPage : SMODS.GameObject
---@field create_ui fun(self:AKYRS.ShopPage):table? UI Table for the custom shop. This does NOT need UIT Root as it will create the close button automatically. Note that this returns just one node (that is designated by G.UIT.R, preferrably)
---@field get_button_texts fun(self:AKYRS.ShopPage, enabled: boolean?):string[][]? a table consisting of strings for the buttons. this should be an index to AKYRS.strings (for ease of reuse) and a localize name. this is called ONLY UPON UPDATING SHOP ENABLEMENT
---@field create_button fun(self:AKYRS.ShopPage):table? in case i hate myself and want 100% custom button for some reason lol
---@field enable fun(self:AKYRS.ShopPage, enable: boolean)? do i even need to explain this
---@field is_enabled fun(self:AKYRS.ShopPage): boolean? okay i think you are just trolling now if you want me to explain this
---@field button_height number? button height in the hud underlay
---@field target_y number? in case higher or lower ui is needed
---@field button_colour table? the colour of the button in the shop underlay
---@field show fun(self:AKYRS.ShopPage)? function to run extra code when showing the shop
---@field hide fun(self:AKYRS.ShopPage)? function to run extra code when showing the shop
---@overload fun(self: AKYRS.ShopPage): AKYRS.ShopPage
AKYRS.ShopPage = SMODS.GameObject:extend {
    required_params = {
        'key'
    },
    target_y = -5.5,
    class_prefix = 'shoppage',
    obj_table = AKYRS.ShopPages,
    obj_buffer = AKYRS.ShopPages_Buffer,
    button_colour = G.C.RED,
    create_ui = function ()
        return {

        }
    end,
    _INTERNAL_setup_shop_strings_and_ui = function(self, text_only)
        if self:is_enabled() and not text_only then
            AKYRS.create_shop_ui_key(self.key)
        end
        local tables_of_salt = self:get_button_texts(self:is_enabled())
        for _, vx in ipairs(tables_of_salt) do
            AKYRS.strings[vx[1]] = localize(unpack(vx[2]))
        end
    end,
    is_enabled = function (self)
        return false
    end,
    enable = function (self, enable)
        
    end,
    get_button_texts = function (self, enabled)
        return {
            -- remember: AKYRS.string key and localize argument,
            { self.key .. "_l1", {"k_akyrs_shop_cor"}},
        }
    end,
    _INTERNAL_generate_button = function(self)
        if self.create_button then
            return self:create_button()
        end
        local ch = {}
        local btn_txts = self:get_button_texts()
        for _,v in ipairs(btn_txts) do
            ch[#ch+1] = AKYRS.text_prefab{ uit = G.UIT.R, ref_table = AKYRS.strings, ref_value = v[1], scale = 0.4 }
        end
        return AKYRS.button_prefab({
            children = ch,
            colour = self.button_colour or G.C.GREEN,
            padding = 0.02,
            h = self.button_height or 0.6,
            ref_table = self.key,
            func = "akyrs_shop_btn_func",
            button = "akyrs_open_shop_window",
        })    
    end,
    inject = function (self, i)
        
    end,
}


function AKYRS.toggle_shop_availability(shop, is_available, strings_only)
    if not AKYRS.ShopPages[shop] then error(AKYRS.ShopPages[shop].. " is not a valid shop lol") end
    AKYRS.ShopPages[shop]:enable(is_available)
    AKYRS.ShopPages[shop]:_INTERNAL_setup_shop_strings_and_ui(strings_only)
end

AKYRS.ShopPage{
    key = "jimbos_chicanery",
    create_ui = function (self)
        ---@type CreateCard
        local parameters = {
            set = "Joker",
            area = G.akyrs_jimbo_chicanery_cardarea,
            key_append = "akyrs_jimbo_chicanery_starting",
            silent = true,
          bypass_discovery_center = true,
        }

        G.akyrs_jimbo_chicanery_cardarea = CardArea(
            0,
            0,
            1.05*G.CARD_W,
            1.05*G.CARD_H, 
            {card_limit = 1, type = 'akyrs_credits', highlight_limit = 1, negative_info = true})

        if not G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round then
            AKYRS.simple_event_add(function ()
            local c = SMODS.create_card(parameters)
            c.T.y = G.ROOM.T.y + 11
            c.VT.y = G.ROOM.T.y + 11
            G.akyrs_jimbo_chicanery_cardarea:emplace(c)
            c:juice_up()
            return true
            end, 0)
        end
        return {
            n = G.UIT.R, -- DONE: dont forget to change this to root when adding to the UI or not actually
            config = { minw = 12, minh = 8, colour = G.C.UI.TRANSPARENT_DARK, r = 0.1, padding = 0.1, align = "cm" },
            nodes = {
                AKYRS.dynatext_prefab({
                    uit = G.UIT.R,
                    align = 'cm',
                    dynatext = {
                        string = {localize("k_akyrs_chicanery_title")},
                        scale = 0.7,
                        pop_in = 0.1,
                        float = 1,
                        bump_rate = 10,
                        text_effect = 'akyrs_rainbow_wiggle',
                        bump_amount = 5,
                    },
                }),
            -- first bullshit
                {
                    n = G.UIT.R,
                    config = { minw = 0, minh = 6, align = "cm", padding = 0.25,
                    },
                    nodes = {
                    AKYRS.singly_padded_shop_box({
                        {
                        n = G.UIT.C,
                        config = { colour = G.C.UI.TRANSPARENT_DARK, minw = 4, minh = 5.5, padding = 0.25, r = 0.07, align = "cm",
                        },
                        nodes = {
                            {
                            n = G.UIT.R,
                            config = { align = "cm" },
                            nodes = {
                                {
                                n = G.UIT.O,
                                config = {
                                    object = G.akyrs_jimbo_chicanery_cardarea, -- fucking death
                                }
                                }
                            }
                            },
                            AKYRS.chicanery_purchase_button() 
                        },
                        }
                    })
                    ,{
                        n = G.UIT.C,
                        config = { colour = G.C.UI.TRANSPARENT_DARK, minw = 4, minh = 5.5, r = 0.07, align = "cm", padding = 0.05,
                        },
                        nodes = {
                            AKYRS.chicanery_reroll_btns("common"),
                            AKYRS.chicanery_reroll_btns("uncommon"),
                            AKYRS.chicanery_reroll_btns("rare"),
                        },
                        },
                    },
                }
            }
        }
    end,
    is_enabled = function (self)
        return G.GAME.akyrs_jimbo_owes_you
    end,
    enable = function (self, enable)
        G.GAME.akyrs_jimbo_owes_you = enable
    end,
    button_height = 1.2,
    get_button_texts = function (self, enabled)
        if enabled then
            return {
                { self.key .. "_l1", {"k_akyrs_chicanery_btn_1"}},
                { self.key .. "_l2", {"k_akyrs_chicanery_btn_2"}},
            }
        end
        return {
            { self.key .. "_l1", {"k_akyrs_shop_cor"}},
            { self.key .. "_l2", {"k_akyrs_shop_cor"}},
        }
    end,
}
AKYRS.ShopPage {
    key = "life_shop",
    create_ui = function (self)
        G.akyrs_life_shop = CardArea(
            0,
            0,
            3.05*G.CARD_W,
            0.65*G.CARD_H, 
            {card_limit = 3, type = 'shop', highlight_limit = 1, negative_info = true})
        AKYRS.fill_life_reroll()
            -- 3 cards
        return {
            n = G.UIT.R, 
            config = { minw = 12.3, minh = 8, colour = G.C.UI.TRANSPARENT_DARK, r = 0.1, padding = 0.25, align = "m" },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { minw = 0, minh = 1, align = "c", padding = 0.05,},
                    nodes = {
                        { 
                            n = G.UIT.C,
                            config = { colour = G.C.UI.TRANSPARENT_DARK, minw = 4, minh = 1, padding = 0.1, r = 0.07, align = "cm",                            },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm" },
                                    nodes = {
                                        AKYRS.button_prefab {
                                            children = {
                                                AKYRS.text_prefab{ text = "Reroll" },
                                                AKYRS.text_prefab{ text = " " },
                                                AKYRS.text_prefab{ ref_table = G.GAME, ref_value = 'akyrs_life_reroll_cost', scale = 0.6 },
                                                AKYRS.text_prefab{ text = " Life", scale = 0.6 },
                                            },
                                            h = 1,
                                            w = 4,
                                            align = "cm",
                                            colour = G.C.RED,
                                            button = 'akyrs_life_reroll',
                                            func = 'akyrs_life_can_reroll',
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm" },
                                    nodes = {
                                        AKYRS.button_prefab {
                                            children = {
                                                AKYRS.text_prefab{ text = "+"},
                                                AKYRS.text_prefab{ ref_table = G.GAME, ref_value = 'akyrs_life_top_up_life'},
                                                AKYRS.text_prefab{ text = " Life"},
                                                AKYRS.text_prefab{ text = " " },
                                                AKYRS.text_prefab{ text = "$", scale = 0.6 },
                                                AKYRS.text_prefab{ ref_table = G.GAME, ref_value = 'akyrs_life_top_up_dollars', scale = 0.6 },
                                            },
                                            h = 1,
                                            w = 4,
                                            align = "cm",
                                            colour = G.C.GREEN,
                                            button = 'akyrs_life_topup',
                                            func = 'akyrs_life_can_topup',
                                        }
                                    }
                                },
                            },
                        },
                        AKYRS.singly_padded_shop_box({
                            {
                            n = G.UIT.C,
                            config = { colour = G.C.UI.TRANSPARENT_DARK, minw = 4, minh = 1, padding = 0.25, r = 0.07, align = "cm",                            },
                            nodes = {
                                {
                                n = G.UIT.R,
                                config = { align = "cm" },
                                nodes = {
                                    {
                                    n = G.UIT.O,
                                    config = {
                                        object = G.akyrs_life_shop, -- fucking death
                                    }
                                    }
                                }
                                },
                            },
                            }
                        })
                    },
                },
                {
                    n = G.UIT.R,
                    config = { minw = 0, minh = 0, align = "cm", padding = 0.1,},
                    nodes = {
                        AKYRS.button_prefab {
                            children = {
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "Randomize Judgement"},
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "-67 Life"},
                            },
                            colour = G.C.GREEN,
                            padding = 0.1,
                            uit = G.UIT.C,
                            w = 2.2,
                            maxw = 2.2,
                            scale = 0.3,
                        },
                        AKYRS.button_prefab {
                            children = {
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "Upgrade 1 Judgement"},
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "-67 Life"},
                            },
                            colour = G.C.GREEN,
                            padding = 0.1,
                            uit = G.UIT.C,
                            w = 2.2,
                            maxw = 2.2,
                            scale = 0.3,
                        },
                        AKYRS.button_prefab {
                            children = {
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "Return Cards"},
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "to Deck"},
                            },
                            colour = G.C.BOOSTER,
                            padding = 0.1,
                            uit = G.UIT.C,
                            w = 2.2,
                            maxw = 2.2,
                            scale = 0.3,
                        },
                        AKYRS.button_prefab {
                            children = {
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "Draw Full"},
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "-30 Life"},
                            },
                            colour = G.C.RED,
                            padding = 0.1,
                            uit = G.UIT.C,
                            w = 2.2,
                            maxw = 2.2,
                            scale = 0.3,
                        },
                        AKYRS.button_prefab {
                            children = {
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "Draw One"},
                                AKYRS.text_prefab{ uit = G.UIT.R, text = "-5 Life"},
                            },
                            colour = G.C.RED,
                            padding = 0.1,
                            uit = G.UIT.C,
                            w = 2.2,
                            maxw = 2.2,
                            scale = 0.3,
                        },
                    },
                }
            }
        }
    end,
    is_enabled = function (self)
        return G.GAME.akyrs_is_life_shop_enabled
    end,
    enable = function (self, enable)
        G.GAME.akyrs_is_life_shop_enabled = enable
    end,
    get_button_texts = function (self, enabled)
        if enabled then
            return {
              { self.key, {'k_akyrs_life_shop_btn'}}
            }
        end
        return {
          { self.key, {"k_akyrs_shop_cor"}},
        }
    end,
    button_colour = G.C.DARK_EDITION,
    show = function (self)
        if G.akyrs_life_ui then
          G.akyrs_life_ui.T.x = 17
          G.akyrs_life_ui.T.y = 6
        end
    end,
    hide = function (self)
        AKYRS.simple_event_add(function ()
                G.FUNCS.draw_from_hand_to_deck()
                return true
            end, 0)
        if G.akyrs_life_ui then
          G.akyrs_life_ui.T.x = 9
          G.akyrs_life_ui.T.y = 3
        end
    end,
}

function AKYRS.chicanery_reroll_btns(level) 
  local per = "round"
  local scale = 0.3
  if level == "rare" then per = "ante" end
  return 
      {
        n = G.UIT.R, config = { colour = G.C.GREEN, minw = 3, minh = 1, r = 0.05, padding = 0.1, align = "cm", emboss = 0.1, hover = true, button = 'akyrs_reroll_jimbo', func = 'akyrs_reroll_jimbo_can_use', ref_table = { level } },
        nodes = {
          { n = G.UIT.R, config = { padding = 0.05 },nodes = { 
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = "🔁" , scale = scale, font = SMODS.Fonts["akyrs_611aiko"] } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize("k_akyrs_chicanery_rolls_"..level), scale = scale } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize("k_akyrs_chicanery_rolls_"..level.."_arrows") , scale = scale, font = SMODS.Fonts["akyrs_611aiko"] } } } },
          },},
          { n = G.UIT.R, config = { padding = 0.05 },nodes = { 
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, ref_table = G.GAME.akyrs_chicanery_rerolls_info, ref_value = level.."_left", scale = scale * 1.4 } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = "/", scale = scale * 1.4 } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, ref_table = G.GAME.akyrs_chicanery_rerolls_info, ref_value = level.."_has", scale = scale * 1.4 } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize("k_akyrs_chicanery_rolls_left") , scale = scale * 1.4 } } } },
          },},
          { n = G.UIT.R, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize("k_akyrs_chicanery_"..per), scale = scale, } } } },
        }
      }
end

function AKYRS.chicanery_purchase_button() 
  local scale = 0.4
  return 
      {
        n = G.UIT.R, config = { colour = G.C.GREEN, minw = 3, minh = 0.75, r = 0.05, padding = 0.05, align = "cm", emboss = 0.1, hover = true, button = 'akyrs_buy_jimbo', func = 'akyrs_can_buy_jimbo' },
        nodes = {
          { n = G.UIT.C, config = { padding = 0, align = "cm" },nodes = { 
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize("k_akyrs_chicanery_buy"), scale = scale } } } },
          },},
          { n = G.UIT.C, config = { padding = 0, align = "cm" },nodes = { 
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = "$", scale = scale * 1.4 } } } },
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, ref_table = G.GAME.akyrs_chicanery_rerolls_info, ref_value = "buy_cost", scale = scale * 1.4 } } } },
          },},
        }
      }
end


function AKYRS.singly_padded_shop_box(childrens, uit)
  return 
    {n=uit or G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes=childrens}
end

function AKYRS.doubly_padded_shop_box(childrens, uit)
  return AKYRS.singly_padded_shop_box({
      {n=uit or G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes=childrens}
    })
end

function AKYRS.dyn_container_maker(childrens)
    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes=childrens
              },
              }, false)
        }}
    return t
end


function G.FUNCS.akyrs_reroll_jimbo(e)
  local info_table = e.config.ref_table
  local level = info_table[1]
  SMODS.calculate_context({reroll_shop = true, cost = 0})
  if G.akyrs_jimbo_chicanery_cardarea and G.akyrs_jimbo_chicanery_cardarea.cards then
    for _, c in ipairs(G.akyrs_jimbo_chicanery_cardarea.cards) do
      c:remove()
    end
    local valid_rarities = {}
    ---@type CreateCard
    local parameters = {
      set = "Joker",
      area = G.akyrs_jimbo_chicanery_cardarea,
      bypass_discovery_center = true,
    }
    if info_table[1] == "common" then
      valid_rarities = nil
    elseif info_table[1] == "uncommon" then
      valid_rarities = { "Uncommon", "Rare" }
    elseif info_table[1] == "rare" then
      valid_rarities = { "Rare" }
    end
    local jkr_key = SMODS.poll_object{ type = "Joker", seed = "akyrs_jimbo_chicanery_"..info_table[1], rarities = valid_rarities}
    parameters.key = jkr_key
    play_sound('coin2')
    G.GAME.akyrs_chicanery_rerolls_info[level.."_left"] = math.max(G.GAME.akyrs_chicanery_rerolls_info[level.."_left"] - 1, 0)
    local c = SMODS.create_card(parameters)
    G.akyrs_jimbo_chicanery_cardarea:emplace(c)
    c:juice_up()
  end
end

function G.FUNCS.akyrs_reroll_jimbo_can_use(e)
  local info_table = e.config.ref_table
  local level = info_table[1]
  if G.GAME.akyrs_chicanery_rerolls_info[level.."_left"] > 0 and not G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round then
    e.config.button = "akyrs_reroll_jimbo"
    if info_table[1] == "uncommon" then
      e.config.colour = G.C.RARITY[2]
    elseif info_table[1] == "rare" then
      e.config.colour = G.C.RARITY[3]
    else
      e.config.colour = G.C.RARITY[1]
    end
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end

function G.FUNCS.akyrs_buy_jimbo(e)
  local bought_at_least_one = false
  if G.akyrs_jimbo_chicanery_cardarea and G.akyrs_jimbo_chicanery_cardarea.cards then
    for _, c in ipairs(G.akyrs_jimbo_chicanery_cardarea.cards) do
      if not AKYRS.has_room(G.jokers) then
        if not bought_at_least_one then
          alert_no_space(c, G.jokers)
          goto buy_jimbo_break
        end
      else
        G.akyrs_jimbo_chicanery_cardarea:remove_card(c)
        SMODS.add_to_deck(c)
        ease_dollars(-G.GAME.akyrs_chicanery_rerolls_info.buy_cost)
        G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round = true
        bought_at_least_one = true
      end
    end
  end
  ::buy_jimbo_break::
end

function G.FUNCS.akyrs_can_buy_jimbo(e)
  if not G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round and #G.akyrs_jimbo_chicanery_cardarea.cards > 0 and G.GAME.dollars - G.GAME.akyrs_chicanery_rerolls_info.buy_cost >= G.GAME.bankrupt_at then
    e.config.button = "akyrs_buy_jimbo"
    e.config.colour = G.C.GREEN
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end

function AKYRS.fill_life_reroll()
  if G.akyrs_life_shop then
    if G.akyrs_life_shop.cards then
      for i = #G.akyrs_life_shop.cards, 1, -1 do
        local c = G.akyrs_life_shop.cards[i]
        G.akyrs_life_shop:remove_card(c)
        c:remove()
      end
    end
  end
  local boosterpack = SMODS.create_card({
    set = "Booster",
    attributes = { 'mega' },
    bypass_discovery_center = true,
    key_append = "akyrs_life_shop_booster",
    x = G.akyrs_life_shop.T.x,
    y = G.akyrs_life_shop.T.y,
  })
  boosterpack.akyrs_special_cost = boosterpack.cost * 3
  AKYRS.create_custom_shop_card_ui(boosterpack, { currency = "curr_akyrs_life" })
  G.akyrs_life_shop:emplace(boosterpack)

  local uncommon = SMODS.create_card({
    set = "Joker",
    rarity = "Uncommon",
    bypass_discovery_center = true,
    key_append = "akyrs_life_shop_uncommon",
    x = G.akyrs_life_shop.T.x,
    y = G.akyrs_life_shop.T.y,
  })
  uncommon.akyrs_special_cost = uncommon.cost * 2
  AKYRS.create_custom_shop_card_ui(uncommon, { currency = "curr_akyrs_life" })
  G.akyrs_life_shop:emplace(uncommon)

  local rare = SMODS.create_card({
    set = "Joker",
    rarity = "Rare",
    bypass_discovery_center = true,
    key_append = "akyrs_life_shop_rare",
    x = G.akyrs_life_shop.T.x,
    y = G.akyrs_life_shop.T.y,
  })
  rare.akyrs_special_cost = rare.cost * 4
  AKYRS.create_custom_shop_card_ui(rare, { currency = "curr_akyrs_life" })
  G.akyrs_life_shop:emplace(rare)
  local is_kdx = AKYRS.get_life_mode() == 'kaleidoscope'
  local should_legen = is_kdx or pseudorandom('akyrs_life_shop_legendary') > 0.8
  local legendary = SMODS.create_card({
    set = "Joker",
    rarity = should_legen and "Legendary" or 'Rare',
    legendary = should_legen,
    bypass_discovery_center = true,
    key_append = "akyrs_life_shop_legendary",
    x = G.akyrs_life_shop.T.x,
    y = G.akyrs_life_shop.T.y,
  })
  legendary.akyrs_special_cost = legendary.cost * (should_legen and 12 or 4)
  AKYRS.create_custom_shop_card_ui(legendary, { currency = "curr_akyrs_life" })
  G.akyrs_life_shop:emplace(legendary)
end

function G.FUNCS.akyrs_life_can_reroll(e)
  if not AKYRS.Currencies.curr_akyrs_life:has_not_enough_money_check(G.GAME.akyrs_life_reroll_cost) then
    e.config.button = 'akyrs_life_reroll'
    e.config.colour = G.C.RED
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end


function G.FUNCS.akyrs_life_reroll(e)
  AKYRS.Currencies.curr_akyrs_life:transactional_sound()
  AKYRS.mod_life( -G.GAME.akyrs_life_reroll_cost)
  G.GAME.akyrs_life_reroll_cost = G.GAME.akyrs_life_reroll_cost + 5
  AKYRS.fill_life_reroll()
end


function G.FUNCS.akyrs_life_can_topup(e)
  if G.GAME.akyrs_life_internal < G.GAME.akyrs_starting_life and not AKYRS.Currencies.curr_dollars:has_not_enough_money_check(G.GAME.akyrs_life_top_up_dollars) then
    e.config.button = 'akyrs_life_topup'
    e.config.colour = G.C.GREEN
  else
    e.config.button = nil
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
  end
end


function G.FUNCS.akyrs_life_topup(e)
    AKYRS.Currencies.curr_dollars:transactional_sound()
    AKYRS.Currencies.curr_dollars:change_value(-G.GAME.akyrs_life_top_up_dollars)
    AKYRS.mod_life(G.GAME.akyrs_life_top_up_life)
    local is_kdx = AKYRS.get_life_mode() == 'kaleidoscope'
    G.GAME.akyrs_life_top_up_dollars = G.GAME.akyrs_life_top_up_dollars * 2
    G.GAME.akyrs_life_top_up_life = G.GAME.akyrs_life_top_up_life + (is_kdx and 15 or 10)
end
