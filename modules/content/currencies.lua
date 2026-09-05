
---@type { [string]: AKYRS.Currency }
AKYRS.Currencies = {}
AKYRS.Currencies_Buffer = {}

---@class AKYRS.Currency : SMODS.GameObject
---@field shop_colour fun(self:AKYRS.Currency, amount:number):table? return table of table of colours for shop dynatext
---@field has_not_enough_money_check fun(self:AKYRS.Currency, cost: number):bool? used for shop checks, value should be positive
---@field change_value fun(self:AKYRS.Currency):bool? use for transactions, not negated so if used for cost you muse pass in negative value
---@field get_value fun(self:AKYRS.Currency): number? get the currency value
---@field transactional_sound fun(self:AKYRS.Currency, mod: number)? play sound when it is bought
---@overload fun(self: AKYRS.Currency): AKYRS.Currency
AKYRS.Currency = SMODS.GameObject:extend {
    required_params = {
        'key'
    },
    class_prefix = 'curr',
    obj_table = AKYRS.Currencies,
    obj_buffer = AKYRS.Currencies_Buffer,
    inject = function (self, i)
        
    end,
    shop_colour = function (self)
        return { G.C.WHITE }
    end,
    has_not_enough_money_check = function (self, amount)
        return false
    end,
    change_value = function (self, amount)
    end,
    get_value = function (self)
        return 0
    end,
    transactional_sound = function (self, mod)
        play_sound("coin1")
    end,
}

AKYRS.Currency{
    key = "dollars",
    prefix_config = {key = {mod = false}}, 
    shop_colour = function (self)
        return {G.C.MONEY}
    end,
    has_not_enough_money_check = function (self, cost)
        return cost > G.GAME.dollars - G.GAME.bankrupt_at
    end,
    get_value = function (self)
        return G.GAME.dollars
    end,
    change_value = function (self, value)
        ease_dollars(value)
    end
}
AKYRS.Currency{
    key = "life",
    shop_colour = function (self)
        return {G.C.GREEN}
    end,
    has_not_enough_money_check = function (self, cost)
        return cost >= G.GAME.akyrs_life_internal
    end,
    get_value = function (self)
        return G.GAME.akyrs_life
    end,
    change_value = function (self, value)
        AKYRS.mod_life(value)
    end,
    transactional_sound = function (self, mod)
        play_sound("akyrs_maimai_dmg", 1, 0.3)
    end,
}

--Checks if the cost of a non voucher card is greater than what the player can afford and changes the 
--buy button visuals accordingly
--
---@param e {}
--**e** Is the UIE that called this function
G.FUNCS.akyrs_can_buy = function(e)
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    if AKYRS.Currencies[currency]:has_not_enough_money_check(e.config.ref_table.akyrs_special_cost) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'akyrs_buy_from_shop'
    end
    if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

--Checks if the cost of a non voucher card is greater than what the player can afford and changes the 
--buy button visuals accordingly
--
---@param e {}
--**e** Is the UIE that called this function
G.FUNCS.akyrs_can_buy_and_use = function(e)
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    if AKYRS.Currencies[currency]:has_not_enough_money_check(e.config.ref_table.akyrs_special_cost) or (not e.config.ref_table:can_use_consumeable()) then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        if e.config.ref_table.highlighted then
          e.UIBox.states.visible = true
        end
        e.config.colour = G.C.SECONDARY_SET.Voucher
        e.config.button = 'akyrs_use_card'
    end
end

--Checks if the cost of a voucher card is greater than what the player can afford and changes the 
--redeem button visuals accordingly
--
---@param e {}
--**e** Is the UIE that called this function
G.FUNCS.akyrs_can_redeem = function(e)
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    if AKYRS.Currencies[currency]:has_not_enough_money_check(e.config.ref_table.akyrs_special_cost) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'akyrs_use_card'
    end
end

--Checks if the cost of a booster pack is too much 
--adjusts booster button visuals accordingly
--
---@param e {}
--**e** Is the UIE that called this function
G.FUNCS.akyrs_can_open = function(e)
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    if AKYRS.Currencies[currency]:has_not_enough_money_check(e.config.ref_table.akyrs_special_cost) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'akyrs_use_card'
    end
end


function G.FUNCS.akyrs_use_card(e)
    local card = e.config.ref_table
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    e.config.ref_table.cost = 0
    AKYRS.Currencies[currency]:change_value(-e.config.ref_table.akyrs_special_cost)
    AKYRS.Currencies[currency]:transactional_sound()
    G.FUNCS.use_card(e) 
end

function G.FUNCS.akyrs_buy_from_shop(e)
    local currency = (e.config.ref_value or e.config.ref_table.akyrs_currency or { currency = "curr_dollars"}).currency
    --print(e.config.ref_table.akyrs_special_cost, currency)
    if G.FUNCS.check_for_buy_space(e.config.ref_table) then
        e.config.ref_table.cost = 0
        AKYRS.Currencies[currency]:change_value(-e.config.ref_table.akyrs_special_cost)
        AKYRS.Currencies[currency]:transactional_sound()
        G.FUNCS.buy_from_shop(e) 
    end
end


function AKYRS.create_custom_shop_card_ui(card, args)
  local args = args or {}
  local type, area = args.type, args.area
  local currency = args.currency or "curr_dollars"
  local curr_loc = (localize(currency, 'akyrs_currencies') or { prefix = "ERR? ", suffix = " ?"})
  card.akyrs_currency = { currency = currency }
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.43,
      blocking = false,
      blockable = false,
      func = (function()
        if card.opening then return true end
        local t1 = {
            n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
                  {n=G.UIT.O, config={object = DynaText(
                  {string = {{prefix = curr_loc.prefix,suffix = curr_loc.suffix, ref_table = card, ref_value = 'akyrs_special_cost'}}, 
                  colours = AKYRS.Currencies[currency]:shop_colour(),
                  shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
                }}
            }}
        local t2 = card.ability.set == 'Voucher' and {
          n=G.UIT.ROOT, config = {ref_table = card, ref_value = { currency = currency }, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'akyrs_can_redeem', button = 'redeem_from_shop', hover = true}, nodes={
              {n=G.UIT.T, config={text = localize('b_redeem'),colour = G.C.WHITE, scale = 0.4}}
          }} or card.ability.set == 'Bet' and {
          n=G.UIT.ROOT, config = {ref_table = card, ref_value = { currency = currency }, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'akyrs_can_redeem', button = 'redeem_from_shop', hover = true}, nodes={
          {n=G.UIT.T, config={text = localize('b_redeem'),colour = G.C.WHITE, scale = 0.4}}
          }} or card.ability.set == 'Booster' and {
          n=G.UIT.ROOT, config = {ref_table = card, ref_value = { currency = currency }, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'akyrs_can_open', button = 'open_booster', hover = true}, nodes={
              {n=G.UIT.T, config={text = localize('b_open'),colour = G.C.WHITE, scale = 0.5}}
          }} or {
          n=G.UIT.ROOT, config = {ref_table = card, ref_value = { currency = currency }, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, func = 'akyrs_can_buy', button = 'buy_from_shop', hover = true}, nodes={
              {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
          }}
        local t3 = {
          n=G.UIT.ROOT, config = {id = 'buy_and_use', ref_table = card, ref_value = { currency = currency }, minh = 1.1, padding = 0.1, align = 'cr', colour = G.C.RED, shadow = true, r = 0.08, minw = 1.1, func = 'akyrs_can_buy_and_use', button = 'buy_from_shop', hover = true, focus_args = {type = 'none'}}, nodes={
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
            {n=G.UIT.C, config = {align = 'cm'}, nodes={
              {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
              }},
              {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_and_use'),colour = G.C.WHITE, scale = 0.3}}
              }},
            }} 
          }}
          

        card.children.price = UIBox{
          definition = t1,
          config = {
            align="tm",
            offset = {x=0,y=1.5},
            major = card,
            bond = 'Weak',
            parent = card
          }
        }

        card.children.buy_button = UIBox{
          definition = t2,
          config = {
            align="bm",
            offset = {x=0,y=-0.3},
            major = card,
            bond = 'Weak',
            parent = card
          }
        }

        if card.ability.consumeable then --and card:can_use_consumeable(true, true)
          card.children.buy_and_use_button = UIBox{
            definition = t3,
            config = {
              align="cr",
              offset = {x=-0.3,y=0},
              major = card,
              bond = 'Weak',
              parent = card
            }
          }
        end

        card.children.price.alignment.offset.y = card.ability.set == 'Booster' and 0.5 or 0.38

          return true
      end)
    }))
end