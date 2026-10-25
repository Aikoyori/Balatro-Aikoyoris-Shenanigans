
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
                for i = 1, x do
                    AKYRS.simple_event_add(function ()
                        AKYRS.Currencies['curr_akyrs_emerald']:change_value(1)
                        AKYRS.Currencies['curr_akyrs_emerald']:transactional_sound(x)
                        return true
                    end, 0.4 * math.max(0.05, 1 / x), 'akyrs_sfx')
                end
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

AKYRS.create_ui_for_trade_item = function (index, deal, deals_table)
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
                            object = AKYRS.create_object_for_ui(G.P_CENTERS[deal.key], 0.7)
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
                children = {
                    AKYRS.text_prefab{
                        text = localize('b_buy')
                    }
                },
            }
        }
    }
end