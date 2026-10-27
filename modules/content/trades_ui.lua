
AKYRS.determine_emerald_sell_value = function (card)
    if card.config.center.key == "j_akyrs_emerald" then
        return 5
    end
    if card.ability.set == "Joker" then
        if card.config.center.rarity == 2 then return 2 end
        if card.config.center.rarity == 3 then return 3 end
        if card.config.center.rarity == 4 then return 6 end
    end
    
    return AKYRS.set_to_emerald_sell_cost[card.ability.set] or 1
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

G.FUNCS.akyrs_emerald_pawnbroker_update_value = function (e)
    local filtered_result = AKYRS.filter_table(SMODS.merge_lists{ G.jokers.highlighted, G.consumeables.highlighted }, function (item, index)
        return item and not SMODS.is_eternal(item)
    end, true, true)
    local value = 0
    
    if #filtered_result > 0 then 
        for i, c in ipairs(filtered_result) do
            value = value + AKYRS.determine_emerald_sell_value(c)
        end
    end
    AKYRS.pawnbroker_value_text = number_format(value)
end

G.FUNCS.akyrs_emerald_sell_selected_cards = function (e)
    local filtered_result = AKYRS.filter_table(SMODS.merge_lists{ G.jokers.highlighted, G.consumeables.highlighted }, function (item, index)
        return item and not SMODS.is_eternal(item)
    end, true, true)
    play_sound('akyrs_villager_yes', nil, 2.2)
    stop_use()
    if #filtered_result > 0 then 
        for i, c in ipairs(filtered_result) do
            local x = AKYRS.determine_emerald_sell_value(c)
            AKYRS.simple_event_add(function ()
                SMODS.destroy_cards({c}, {
                    silent = true,
                    immediate = true,
                })
                AKYRS.smoothly_ease_emerald(x)
                return true
            end, 0.4 * math.max(0.001, 1 / x))
        end
    end
end


AKYRS.generate_deals = function (deals, typer)
    local tblodeal = {}
    for i = 1, deals do
        tblodeal[#tblodeal+1] = AKYRS.generate_singular_deal(typer)
    end
    return tblodeal
end
AKYRS.generate_singular_deal = function ( typ )
    local key = SMODS.poll_object { type = typ, types = not typ and {
        "Consumeables",
        "Joker",
        "Scenario",
    }, filter = function (pool)
        return AKYRS.filter_table(pool, function (item, index)
            return item.key ~= "j_akyrs_emerald"
        end, true, true)
    end, seed = 'akyrs_villager_merchant_deals' }
    return { key = key, cost = AKYRS.determine_emerald_buy_cost(G.P_CENTERS[key]) }
end

AKYRS.create_ui_for_trade_item = function (index, deal, deals_table, object)
    local object = object or AKYRS.create_object_for_ui(G.P_CENTERS[deal.key], 0.7)
    -- reminder: returns a G.UIT.C because these will (likely) be put side by side
    return {
        n = G.UIT.C,
        config = {
            minw = 1.7,
            minh = 1.5,
            colour = G.C.UI.TRANSPARENT_DARK,
            padding = 0.1,
            align = 'cm',
            r = 0.1,
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = 'cm',
                    w = 1,
                    h = 0.5,
                },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = object
                        }
                    },
                }
            },
            {
                n = G.UIT.R,
                config = {
                    align = 'cm',
                    maxw = 1.5,
                    maxh = 0.7,
                },
                nodes = {
                    AKYRS.emerald_indicator({
                        ref_table = deals_table[index],
                        ref_value = "cost",
                        align = 'cm',
                        padding = 0.1,
                    }),
                }
            },
            AKYRS.button_prefab{
                w = 1,
                h = 0.7,
                ref_table = {
                    object = object,
                    deal = deal,
                },
                button = 'akyrs_ui_trade_item_purchase',
                func = 'akyrs_ui_trade_item_can_purchase',
                children = {
                    AKYRS.text_prefab{
                        text = localize('b_buy')
                    }
                },
            }
        }
    }, object
end

G.FUNCS.akyrs_ui_trade_item_can_purchase = function (e)
    local ref = e.config.ref_table
    AKYRS.button_enable_func(e, {
        func = function (e)
            return not AKYRS.Currencies.curr_akyrs_emerald:has_not_enough_money_check(ref.deal.cost)
        end,
        button = 'akyrs_ui_trade_item_purchase',
    })
end

G.FUNCS.akyrs_ui_trade_item_purchase = function (e)
    local ref = e.config.ref_table
    local ar = AKYRS.get_area_for_card(ref.object)
    if AKYRS.has_room(ar) then
        local c2 = SMODS.copy_card(ref.object, { no_add = true })
        SMODS.add_to_deck(c2, { area = ar })
        local x = ref.deal.cost
        play_sound('akyrs_villager_yes')
        AKYRS.smoothly_ease_emerald(-x)
        AKYRS.remove_value_from_table(G.GAME.akyrs_deals, ref.deal)
        local progress = AKYRS.VILLAGER_SHOP_PANEL.scroll_progress
        G.FUNCS.akyrs_change_tab(AKYRS.TABS_DEF['villager_shop'].last_clicked_button)
        AKYRS.VILLAGER_SHOP_PANEL:set_scroll_progress({ x = progress.x, y = progress.y})
    else
        alert_no_space(ref.object, ar)
    end
end


G.FUNCS.akyrs_ui_merchant_can_reroll = function (e)
    AKYRS.button_enable_func(e, {
        func = function (e)
            return not AKYRS.Currencies.curr_akyrs_emerald:has_not_enough_money_check(G.GAME.akyrs_deals_reroll_price)
        end,
        button = 'akyrs_ui_merchant_reroll',
    })
end

G.FUNCS.akyrs_ui_merchant_can_add_deals = function (e)
    local ref = e.config.ref_table
    AKYRS.button_enable_func(e, {
        func = function (e)
            return not AKYRS.Currencies.curr_akyrs_emerald:has_not_enough_money_check(G.GAME.akyrs_deals_add_row_price)
        end,
        colour = G.C.GREEN,
        button = 'akyrs_ui_merchant_add_deals',
    })
end


G.FUNCS.akyrs_ui_merchant_reroll = function (e)
    AKYRS.smoothly_ease_emerald(-G.GAME.akyrs_deals_reroll_price)
    G.GAME.akyrs_deals_reroll_price = G.GAME.akyrs_deals_reroll_price + 3
    G.GAME.akyrs_deals = AKYRS.generate_deals(#G.GAME.akyrs_deals)
    G.FUNCS.akyrs_change_tab(AKYRS.TABS_DEF['villager_shop'].last_clicked_button)
end


G.FUNCS.akyrs_ui_merchant_add_deals = function (e)
    AKYRS.smoothly_ease_emerald(-G.GAME.akyrs_deals_reroll_price)
    G.GAME.akyrs_deals_reroll_price = G.GAME.akyrs_deals_reroll_price + 3
    G.GAME.akyrs_deals_added_rows = G.GAME.akyrs_deals_added_rows + 1
    G.GAME.akyrs_deals_add_row_price = G.GAME.akyrs_deals_add_row_price + 3 * G.GAME.akyrs_deals_added_rows
    G.GAME.akyrs_deals = SMODS.merge_lists({G.GAME.akyrs_deals, AKYRS.generate_deals(3)})
    G.FUNCS.akyrs_change_tab(AKYRS.TABS_DEF['villager_shop'].last_clicked_button)
end


G.FUNCS.akyrs_enchantsmith_tab_button = function (e)
    AKYRS.multi_state_button_func(e, {
        conf_func = function (e)
            if G.GAME.akyrs_unlocked_enchantsmith then
                return { button = 'akyrs_change_tab', colour = G.C.BOOSTER }
            end
            if AKYRS.Currencies.curr_akyrs_emerald:has_not_enough_money_check(50) then
                return { button = false, colour = G.C.UI.BACKGROUND_INACTIVE }
            end
            return { button = 'akyrs_ui_enchantsmith_unlock', colour = G.C.DARK_EDITION }
        end
    })
end


G.FUNCS.akyrs_ui_enchantsmith_unlock = function (e)
    AKYRS.smoothly_ease_emerald(-50)
    G.GAME.akyrs_unlocked_enchantsmith = true
    G.FUNCS.akyrs_change_tab(e)
end
