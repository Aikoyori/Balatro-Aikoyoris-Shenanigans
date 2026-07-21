local function numberToColor(num)
  if num == 1 then
    return AKYRS.config.colourblind_ui and G.C.ORANGE or G.C.GREEN
  elseif num == 2 then
    return AKYRS.config.colourblind_ui and G.C.BLUE or G.C.YELLOW
  elseif num == 3 then
    return G.C.GREY
  end
  return G.C.TRANSPARENT_DARK
end

local function numberToTextColor(num)
  if num == 1 then
    return AKYRS.config.colourblind_ui and G.C.BLACK or G.C.WHITE
  elseif num == 2 then
    return AKYRS.config.colourblind_ui and G.C.WHITE or G.C.BLACK
  elseif num == 3 then
    return G.C.WHITE
  end
  return G.C.TRANSPARENT_DARK
end


function INFINITE_DISCARD_UI(temp_col2, scale)
  return {
    {
      n = G.UIT.R,
      config = { align = "cm", r = 0.1, minw = 1.2, minh = 0.7, colour = temp_col2 },
      nodes = {
        { n = G.UIT.O, config = { object = DynaText({ string = { { string = "" } }, font = G.LANGUAGES['en-us'].font, colours = { HEX("00000000") }, shadow = true, rotate = true, scale = 2 * scale }), id = 'discard_UI_count' } },
        { n = G.UIT.T, config = { text = "8", hover = true, shadow = true, colour = G.C.RED, vert = true, scale = 2 * scale } },
      }
    }
  }
end

function create_UIBOX_Aikoyori_WordPuzzleBox()
  local nodesnshit = {}
  for a, x in ipairs(G.GAME.current_round.aiko_round_played_words) do
    local subnoteforrow = {}
    for b, y in ipairs(x) do
      -- 1 is letter and [2] is stats
      table.insert(subnoteforrow, {
        n = G.UIT.C,
        config = { padding = 0.1, minw = 0.4, maxh = 0.5, colour = numberToColor(y[2]) },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              align = "c",
              text = y[1],
              colour = numberToTextColor(y[2]),
              scale = 0.3
            }
          }
        }
      })
    end
    table.insert(
      nodesnshit,
      {
        n = G.UIT.R,
        config = { padding = 0.0, maxh = 0.5 },
        nodes = subnoteforrow

      }
    )
  end
  return {
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      minw = 2,
      minh = 0.6,
      padding = 0.2,
      colour = G.C.UI.TRANSPARENT_DARK,
      r = 0.1,
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
        },
        nodes = nodesnshit
      }
    }
  }
end

  
G.FUNCS.akyrs_letter_dialog = function(e)
  G.FUNCS.overlay_menu{
    definition = create_UIBox_options(),
  }
end

-- thunk didn't have this so i might as well add the shift key

function AKYRS.create_better_keyboard_input(args)
  local keyboard_rows = {
    '`1234567890-=',
    'qwertyuiop[]\\',
    'asdfghjkl;\'',
    'zxcvbnm,./',
    args.space_key and ' ' or nil
  }
  local keyboard_button_rows = {
      {},{},{},{},{},{}
  }
  for k, v in ipairs(keyboard_rows) do
      for i = 1, #v do
          local c = v:sub(i,i)
          keyboard_button_rows[k][#keyboard_button_rows[k] +1] = AKYRS.create_better_keyboard_button(c, c == ' ' and 'y' or nil, args.osk)

      end
  end
  return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
    {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes = {
      {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK, emboss = 0.05, r = 0.1, mid = true}, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes = {
          {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes = {
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[1]},
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[2]},
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[3]},
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[4]},
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[5]},
              {n=G.UIT.R, config={align = "cm",padding = 0.04, colour = G.C.CLEAR}, nodes=keyboard_button_rows[6]}
          }},
          (args.backspace_key or args.return_key) and {n=G.UIT.C, config={align = "r", padding = 0.05, colour = G.C.CLEAR, minw = 5}, nodes = {
              args.backspace_key and {n=G.UIT.R, config={align = "r", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('backspace', 'x', args.osk)}} or nil,
              args.return_key and {n=G.UIT.R, config={align = "r", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('return', 'start', args.osk)}} or nil,
              args.shift_key and {n=G.UIT.R, config={align = "r", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_toggle_keyboard_button('lshift', 'leftstick', args.osk)}} or nil,
              {n=G.UIT.R, config={align = "r", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('back', 'b', args.osk)}}
          }} or nil
        }},
      }}
    }},
    
  }}
end

-- mainly for shift button support

function AKYRS.create_better_keyboard_button(key, binding, osk)
  local key_label = (key == 'backspace' and 'Backspace') or (key == ' ' and 'Space') or (key == 'back' and 'Back') or (key == 'return' and 'Enter')  or (key == 'lshift' and 'Shift') or (AKYRS.shift_toggled and AKYRS.get_shifted_from_key(key)) or key
  local is_one_of_those = key == 'backspace' or key == ' ' or key == 'back' or key == 'return' or key == 'lshift' and true or false
  return UIBox_button{ akyrs_osk = osk,label = {key_label}, button = "akyrs_key_update", func = not is_one_of_those and 'akyrs_shifted_keyboard_keys' or nil, ref_table = {key = key == 'back' and 'return' or key},
      minw = key == ' ' and 9 or key == 'return' and 3 or key == 'backspace' and 3.5 or key == 'back' and 3.5 or key == 'lshift' and 4 or 0.8,
      minh = key == 'return' and 1 or key == 'backspace' and 1 or key == 'back' and 0.5 or key == 'lshift' and 1 or 0.7,
      col = true, colour = G.C.GREY, scale = 0.4, focus_args = binding and {button = binding, orientation = 'cr', set_button_pip= true, snap_to = key == ' ' and true or false} or nil,
    }
end
function AKYRS.create_toggle_keyboard_button(key, binding, osk)
  local key_label = (key == 'lshift' and 'Shift') or key
  return UIBox_button{ akyrs_osk = osk,label = {key_label}, button = "akyrs_toggle_key_button", func = key=="lshift" and "akyrs_shift_enabled" or nil, ref_table = {key = key == 'back' and 'return' or key},
      minw = key == ' ' and 9 or key == 'return' and 3 or key == 'backspace' and 3.5 or key == 'back' and 3.5 or key == 'lshift' and 4 or 0.8,
      minh = key == 'return' and 1 or key == 'backspace' and 1 or key == 'back' and 0.5 or key == 'lshift' and 1 or 0.7,
      col = true, colour = G.C.GREY, scale = 0.4, focus_args = binding and {button = binding, orientation = 'cr', set_button_pip= true, snap_to = key == ' ' and true or false} or nil}
end



G.FUNCS.akyrs_wildcard_check = function(e)
  G.FUNCS.set_button_pip(e)
  local colour = G.C.GREEN
  local button = nil
  if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then
      button = 'akyrs_wildcard_open_wildcard_ui'
      if not e.config.ref_table.ability.aikoyori_pretend_letter then
          colour = AKYRS.config.wildcard_behaviour == 3 and SMODS.Gradients["akyrs_unset_letter"] or G.C.RED
      elseif e.config.ref_table.ability.aikoyori_pretend_letter == "#" then
          colour = G.C.YELLOW
      end
  else
      colour = G.C.UI.BACKGROUND_INACTIVE
      button = nil
  end
  e.config.button = button
  e.config.colour = colour
end

G.FUNCS.akyrs_shift_enabled = function(e)  if AKYRS.shift_toggled then
    e.config.colour = G.C.PURPLE
  else
    e.config.colour = G.C.GREY
  end

end
G.FUNCS.akyrs_shifted_keyboard_keys = function(e)
  
  --[[
  if new and old ~= new then
    e.children[1].children[1].config.object.config.string = {new}
    e.children[1].children[1].config.object:update_text(true)
  end]]
end

--[[
G.FUNCS.akyrs_shifted_keyboard_keys = function(e)
  local args = e.config.ref_table
  local old = e.children[1].children[1].children[1].config.text
  local old_node = e.children[1].children[1].children[1].config
  local new = nil
  if AKYRS.shift_toggled and args.key then
    new = AKYRS.get_shifted_from_key(args.key)
  elseif AKYRS.shift_toggled and old:upper() ~= old then
    new = old:upper()
  else
    new = args.key
  end
  if new and old ~= new then
    e.children[1].children[1]:remove()
    old_node.text = new
    e.children[1].children[1] = UIBox{
      definition = {n=G.UIT.T, config=old_node},
      config = { align = 'cm', offset = {x=0,y=0}, major = e.children[1], parent = e.children[1]}

    }
  end
end
]]

G.FUNCS.akyrs_toggle_key_button = function(e)
  local args = e.config.ref_table
  if args.key and args.key == "lshift" then
    AKYRS.shift_toggled = not AKYRS.shift_toggled
    local OSkeyboard_e = e.config.akyrs_osk.parent.parent.parent
    local x = e.config.akyrs_osk
    if OSkeyboard_e.children.controller_keyboard then
      
      G.CONTROLLER:mod_cursor_context_layer(-1)
      OSkeyboard_e.children.controller_keyboard:remove()
      G.CONTROLLER.screen_keyboard = nil
      OSkeyboard_e.children.controller_keyboard = UIBox{
      definition = AKYRS.create_better_keyboard_input{backspace_key = true, return_key = true, space_key = true, shift_key = true, osk = x},
      config = {
        align= 'cm',
        offset = {x = 0, y = G.CONTROLLER.text_input_hook.config.ref_table.keyboard_offset or -4},
        major = x.UIBox, parent = OSkeyboard_e}
      }
      
      G.CONTROLLER.screen_keyboard = OSkeyboard_e.children.controller_keyboard
      G.CONTROLLER:mod_cursor_context_layer(1)
    end
  end
end
G.FUNCS.akyrs_key_update = function(e)
  local args = e.config.ref_table
  if args.key then 
    G.CONTROLLER:key_press_update(args.key) 
  end
end
-- so it support shift and disables the fullscreen dim

function AKYRS.create_better_text_input(args)
  args = args or {}
  args.colour = copy_table(args.colour) or copy_table(G.C.BLUE)
  args.hooked_colour = copy_table(args.hooked_colour) or darken(copy_table(G.C.BLUE), 0.3)
  args.w = args.w or 2.5
  args.h = args.h or 0.7
  args.hide_keyboard = args.hide_keyboard or false
  args.text_scale = args.text_scale or 0.4
  args.max_length = args.max_length or 16
  args.all_caps = args.all_caps or false
  args.prompt_text = args.prompt_text or ""
  args.current_prompt_text = args.ref_table[args.ref_value] or ''
  args.id = args.id or "text_input"

  local text = {ref_table = args.ref_table, ref_value = args.ref_value, letters = {}, current_position = string.len(args.ref_table[args.ref_value])}
  local ui_letters = {}
  for i = 1, args.max_length do
    text.letters[i] = (args.ref_table[args.ref_value] and (string.sub(args.ref_table[args.ref_value], i, i) or '')) or ''
    ui_letters[i] = {n=G.UIT.T, config={ref_table = text.letters, ref_value = i, scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, id = args.id..'_letter_'..i}}
  end
  args.text = text

  local position_text_colour = lighten(copy_table(G.C.BLUE), 0.4)

  ui_letters[#ui_letters+1] = {n=G.UIT.T, config={ref_table = args, ref_value = 'current_prompt_text', scale = args.text_scale, colour = lighten(copy_table(args.colour), 0.4), id = args.id..'_prompt'}}
  ui_letters[#ui_letters+1] = {n=G.UIT.B, config={r = 0.03,w=0.1, h=0.4, colour = position_text_colour, id = args.id..'_position', func = 'flash'}}

  local t = 
      {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR}, nodes = {
          {n=G.UIT.C, config={id = args.id, align = "cm", padding = 0.05, r = 0.1, hover = true, colour = args.colour,minw = args.w, min_h = args.h, button = 'select_text_input', shadow = true}, nodes={
            {n=G.UIT.R, config={ref_table = args, padding = 0.05, align = "cm", r = 0.1, colour = G.C.CLEAR}, nodes={
              {n=G.UIT.R, config={ref_table = args, align = "cm", r = 0.1, colour = G.C.CLEAR, func = 'akyrs_text_input', hide_keyboard = args.hide_keyboard}, nodes=
                ui_letters
              }
            }}
          }}
        }}
  return t
end

-- TEXT INPUT IS JANK

G.FUNCS.akyrs_text_input = function(e)
  local args = e.config.ref_table
  if G.CONTROLLER.text_input_hook == e then
    e.parent.parent.config.colour = args.hooked_colour
    args.current_prompt_text = ''
    args.current_position_text = args.position_text
  else
    e.parent.parent.config.colour = args.colour
    args.current_prompt_text = (args.text.ref_table[args.text.ref_value] and args.text.ref_table[args.text.ref_value] and args.prompt_text or '')
    args.current_position_text = ''
  end

  local OSkeyboard_e = e.parent.parent.parent
  if G.CONTROLLER.text_input_hook == e and (not e.config or not e.config.hide_keyboard) then
    if not OSkeyboard_e.children.controller_keyboard then 
      OSkeyboard_e.children.controller_keyboard = UIBox{
        definition = AKYRS.create_better_keyboard_input{backspace_key = true, return_key = true, space_key = true, shift_key = true, osk = e},
        config = {
          align= 'cm',
          offset = {x = 0, y = G.CONTROLLER.text_input_hook.config.ref_table.keyboard_offset or -4},
          major = e.UIBox, parent = OSkeyboard_e}
      }
      G.CONTROLLER.screen_keyboard = OSkeyboard_e.children.controller_keyboard
      G.CONTROLLER:mod_cursor_context_layer(1)
    end
  elseif OSkeyboard_e.children.controller_keyboard then
    OSkeyboard_e.children.controller_keyboard:remove()
    OSkeyboard_e.children.controller_keyboard = nil
    G.CONTROLLER.screen_keyboard = nil
    AKYRS.shift_toggled = nil
    G.CONTROLLER:mod_cursor_context_layer(-1)
  else
    if not AKYRS.better_input_selected then
      AKYRS.better_input_selected = true
      AKYRS.simple_event_add(
        function ()
          G.FUNCS.select_text_input(e.parent.parent)
          return true
        end, 0.05
      )
    end
  end
end


function AKYRS.UIBox_dynatext_button(args)
  args = args or {}
  args.button = args.button or "exit_overlay_menu"
  args.func = args.func or nil
  args.key = args.key or "generic"
  args.colour = args.colour or G.C.RED
  args.choice = args.choice or nil
  args.chosen = args.chosen or nil
  args.label = args.label or {}
  args.minw = args.minw or 2.7
  args.maxw = args.maxw or (args.minw - 0.2)
  if args.minw < args.maxw then args.maxw = args.minw - 0.2 end
  args.minh = args.minh or 0.9
  args.scale = args.scale or 0.5
  args.focus_args = args.focus_args or nil
  args.text_colour = args.text_colour or G.C.UI.TEXT_LIGHT
  local but_UIT = args.col == true and G.UIT.C or G.UIT.R

  local but_UI_label = {}
  AKYRS.dynatext = AKYRS.dynatext or {}
  AKYRS.dynatext[args.key] = AKYRS.dynatext[args.key] or DynaText{
    string = args.label,
    scale = args.scale,
    colours = {args.text_colour},
    shadow = args.shadow,
  }
  local button_pip = nil
  if args.focus_args and args.focus_args.set_button_pip then 
    button_pip ='set_button_pip'
  end
  table.insert(but_UI_label, {n=G.UIT.R, config={align = "cm", padding = 0, minw = args.minw, maxw = args.maxw}, nodes={
    {n=G.UIT.O, config={
      object = AKYRS.dynatext[args.key]
    },
    {n=G.UIT.T, config={text = '', scale = args.scale, colour = args.text_colour, shadow = args.shadow, focus_args = button_pip and args.focus_args or nil, func = button_pip, ref_table = args.ref_table}},
  }}})
  return 
  {n= but_UIT, config = {align = 'cm'}, nodes={
  {n= G.UIT.C, config={
      align = "cm",
      padding = args.padding or 0,
      r = 0.1,
      hover = true,
      colour = args.colour,
      one_press = args.one_press,
      button = (args.button ~= 'nil') and args.button or nil,
      choice = args.choice,
      chosen = args.chosen,
      focus_args = args.focus_args,
      minh = args.minh - 0.3*(args.count and 1 or 0),
      shadow = true,
      func = args.func,
      id = args.id,
      back_func = args.back_func,
      ref_table = args.ref_table,
      mid = args.mid
    }, nodes=
    but_UI_label
    }}}
end

AKYRS.akyrs_selection = {
  adequate = nil,
  absurd = nil
}

AKYRS.balance_intro_end = function (set)
  G.PROFILES[G.SETTINGS.profile].akyrs_balance = set
  G:save_settings()
  G.akyrs_current_balancing_page = nil
  G.FUNCS.exit_overlay_menu()
  G.SETTINGS.paused = false
  if G.AKYRS_AIKOYORI then
    G.akyrs_aiko_y = 20
    AKYRS.simple_event_add(
      function ()
        
      if G.AKYRS_AIKOYORI then
            G.AKYRS_AIKOYORI:remove()
            G.AKYRS_AIKOYORI = nil
      end
        return true
      end, 1
    )
  end
end

G.FUNCS.akyrs_balance_select_button_enabled = function(e)
  if not AKYRS.akyrs_selection.adequate and not AKYRS.akyrs_selection.absurd then
    e.config.colour = G.C.GREY
    e.config.button = nil
  else
    e.config.colour = G.C.GREEN
    e.config.button = "akyrs_advance_balance_intro"
  end
end

AKYRS.balance_box = function(page)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu({
    definition = AKYRS.UIBox_balancing_intro(page),
    config = {
        align = "cm",
        offset = {x=-2,y=10},
        major = G.ROOM_ATTACH,
        bond = 'Weak',
        no_esc = true
    }
})
end

G.FUNCS.akyrs_select_balance_checkbox = function(val, e)
  
  if e.config.ref_table.ref_value == "adequate" or (e.config.ref_table.ref_value == "absurd" and not Talisman) then
    AKYRS.akyrs_selection.adequate = true
    AKYRS.akyrs_selection.absurd = false
    
  end
  if e.config.ref_table.ref_value == "absurd" then
    AKYRS.akyrs_selection.absurd = true
    AKYRS.akyrs_selection.adequate = false
  end
end

G.FUNCS.akyrs_advance_balance_intro = function(e)
  --print(inspect(e.config))
  if G.akyrs_current_balancing_page == "intro" or G.akyrs_current_balancing_page == "intro_again" then
    if AKYRS.is_mod_loaded("Multiplayer") then
      AKYRS.balance_box("multiplayer")
    elseif AKYRS.is_mod_loaded("Playbook")  then
      AKYRS.balance_box("playbook")
    elseif AKYRS.is_mod_loaded("Cryptid") then
      AKYRS.balance_box("cryptid")
    else
      AKYRS.balance_box("details")
    end
  elseif G.akyrs_current_balancing_page == "multiplayer" then
    G.AKYRS_MULTIPLAYER_NOTICE_INTRO = nil
    if e.config.id == "accept" then
      AKYRS.balance_intro_end("adequate")
    end
  elseif G.akyrs_current_balancing_page == "cryptid" or G.akyrs_current_balancing_page == "playbook" then
    if e.config.id == "accept" then
      AKYRS.balance_intro_end("absurd")
    else
      AKYRS.balance_box("details")
    end
  elseif G.akyrs_current_balancing_page == "details" then
    AKYRS.balance_box("pick")
  elseif G.akyrs_current_balancing_page == "pick" then
    local picked = nil
    if AKYRS.akyrs_selection.adequate then
      picked = 'adequate'
    end
    if AKYRS.akyrs_selection.absurd then
      picked = 'absurd'
    end
    if picked then
      AKYRS.balance_intro_end(picked)
    end
  end
end

function AKYRS.UIBox_balancing_intro(page)
  G.akyrs_current_balancing_page = page
  local child_elements = {}
  local buttons = {}
    local shx = {}
  if page == "intro" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_intro", set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_intro_next')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        colour = G.C.BLUE,
        minw = 4
      }),
    }
  elseif page == "intro_again" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_intro_again", set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_intro_next')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        colour = G.C.BLUE,
        minw = 4
      }),
    }
  elseif page == "multiplayer" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_multiplayer_".. (G.AKYRS_MULTIPLAYER_NOTICE_INTRO and "start_from_already_set_profile" or "initialise"), set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_mp_accept')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        id = 'accept',
        colour = G.C.GREEN,
        minw = 6
      }),
    }
  elseif page == "playbook" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_playbook", set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_cryptid_decline')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        id = 'decline',
        colour = G.C.RED,
        minw = 4
      }),
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_cryptid_accept')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        id = 'accept',
        colour = G.C.GREEN,
        minw = 4
      }),
    }
  elseif page == "cryptid" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_cryptid", set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_cryptid_decline')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        id = 'decline',
        colour = G.C.RED,
        minw = 4
      }),
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_cryptid_accept')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        id = 'accept',
        colour = G.C.GREEN,
        minw = 4
      }),
    }
  elseif page == "details" then
    localize{type = "descriptions", key = "akyrs_balance_dialog_details", set = "Akyrs_Dialog", default_col = G.C.WHITE, nodes = shx, vars = {}, scale = 2}
    child_elements = {transparent_multiline_text(shx)}
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_details_next')},
        button = 'akyrs_advance_balance_intro',
        page = page,
        colour = G.C.BLUE,
        minw = 4
      }),
    }
  elseif page == "pick" then
    child_elements = {
      { n = G.UIT.R, config = { padding = 0.1, align = "cl" }, nodes = {
        { n = G.UIT.C, config = { padding = 0.1, align = "cl" }, nodes = {
          create_toggle({w = 0, label = '', scale = 1, ref_table = AKYRS.akyrs_selection, ref_value = 'adequate', callback = G.FUNCS.akyrs_select_balance_checkbox}),
        }},
        { n = G.UIT.C, config = { padding = 0.1, align = "cl" }, nodes = {
          { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize('k_akyrs_balance_dialog_adequate_text'), scale = 0.8}}
        }}
      }},
      { n = G.UIT.R, nodes = {
        { n = G.UIT.T, config = { colour = G.C.JOKER_GREY, text = localize('k_akyrs_balance_dialog_adequate_description'), scale = 0.5}}
      }},
      { n = G.UIT.R, config = { h = 0.5, w = 0.1 }, nodes = {{ n = G.UIT.B, config = { h = 0.5, w = 0.1 } },}},
      { n = G.UIT.R, config = { padding = 0.1, align = "cl" }, nodes = {
        { n = G.UIT.C, config = { padding = 0.1, align = "cl" }, nodes = Talisman and {
          create_toggle({w = 0, label = '', scale = 1, ref_table = AKYRS.akyrs_selection, ref_value = 'absurd', callback = G.FUNCS.akyrs_select_balance_checkbox}),
        } or {
          {
            n = G.UIT.R, config = { align = "cm", minw = 0.5, minh = 0.5, padding = 0.2, colour = G.C.UI.TEXT_INACTIVE, outline = 1.5, outline_colour = G.C.WHITE, r = 0.2, emboss = 0.1 },
            nodes = {
              { n = G.UIT.T, config = { text = "-", colour = G.C.WHITE, scale = 0.3}}
            }
          }
        },},
        { n = G.UIT.C, config = { padding = 0.1, align = "cl" }, nodes = {
          { n = G.UIT.T, config = { colour = G.C.WHITE, text = localize('k_akyrs_balance_dialog_absurd_text'), scale = 0.8}}
        }}
      }},
      { n = G.UIT.R, nodes = {
        { n = G.UIT.T, config = { colour = G.C.JOKER_GREY, text = localize('k_akyrs_balance_dialog_absurd_description'), scale = 0.5}}
      }},
      
      
      
    }
    buttons = {
      UIBox_button({
        label = {localize('k_akyrs_balance_dialog_finish_wizard')},
        button = 'akyrs_advance_balance_intro',
        func = 'akyrs_balance_select_button_enabled',
        page = page,
        minw = 4
      }),
    }
  end
  return {
    n = G.UIT.ROOT, config = { align = "cm", colour = {0.32,0.36,0.41,0.6}, padding = 32.01, r = 0.1, can_collide = true}, nodes = {
      {
        n = G.UIT.R, config = {padding = 0.0},  nodes = {
          {
            n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.05, minh = G.ROOM.T.h - 3, minw = G.ROOM.T.w - 4, can_collide = true, colour = G.C.L_BLACK, outline_colour = G.C.JOKER_GREY, emboss = 0.1}, nodes = child_elements
          },
          {
            n = G.UIT.R, config = {align = "cr", r = 0.1, padding = 0.2, minh = 1, minw = G.ROOM.T.w - 4, can_collide = true, colour = mix_colours(G.C.L_BLACK,G.C.BLACK,0.5), outline_colour = mix_colours(G.C.JOKER_GREY,G.C.BLACK,0.5), emboss = 0.1 }, nodes = {
              {
                n = G.UIT.C, config = { padding = 0.2 }, nodes = AKYRS.wrap_in_col(buttons)
              }
            }
          },
        }
      }
    }
  }
end


AKYRS.start_onboarding = function (forced, meet_again)
  -- i will not show that on startup anymore
  if not AKYRS.bal() then
    AKYRS.set_bal("adequate")
  end
  if false then
    AKYRS.simple_event_add(
        function()
            if not G.PROFILES[G.SETTINGS.profile].akyrs_balance or forced or meet_again then
                G.SETTINGS.paused = true
                G.FUNCS.overlay_menu({
                    definition = AKYRS.UIBox_balancing_intro("intro"..(meet_again and "_again" or "")),
                    config = {
                        align = "cm",
                        offset = {x=-2,y=10},
                        major = G.ROOM_ATTACH,
                        bond = 'Weak',
                        no_esc = true
                    }
                })
                local atl = G.ASSET_ATLAS['akyrs_aikoyori_intro']
                local scale = 60
                G.AKYRS_AIKOYORI = G.AKYRS_AIKOYORI or Sprite(16,12,scale*atl.px/1000,scale*atl.py/1000, atl,{ x = 0, y = 0 })
                G.AKYRS_AIKOYORI.T.y = 3
                G.akyrs_aiko_y = 0 
            end
            return true
        end, 0,"akyrs_desc"
    )
  end
end

function AKYRS.UIBox_HUD_villager_trading()
  return {
    n = G.UIT.ROOT,
    config = {},
    nodes = {
      {
        n = G.UIT.C,
        config = {},

      }
    }
  }
end

function G.FUNCS.akyrs_check_word_btn(e)
  local etet = AKYRS.split(AKYRS.word_check_data.word_check)
  AKYRS.word_check_data.validated_info = AKYRS.check_word(etet)
  if AKYRS.word_check_data.validated_info then
    if AKYRS.word_check_data.validated_info.valid then
      AKYRS.word_check_data.current_col = G.C.GREEN
      AKYRS.word_check_data.text_disp = (localize{ type = "variable", key = "k_akyrs_word_check_valid", vars = {AKYRS.word_check_data.validated_info.word}})
    else
      AKYRS.word_check_data.current_col = G.C.RED
      AKYRS.word_check_data.text_disp = (localize{ type = "variable", key = "k_akyrs_word_check_invalid", vars = {AKYRS.word_check_data.word_check}})
    end
  end
end

function G.FUNCS.akyrs_update_word_checker_text(e)
end

function AKYRS.UIDEF.words_run_info_tab()
  AKYRS.word_check_data = {word_check = "", text_disp = localize("k_akyrs_word_check_init"), current_col = G.C.UI.TEXT_LIGHT}
  return {
				n = G.UIT.ROOT,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
          -- part where it shows you words you played in the future ???
          -- for now i am making a word checker
          {
            n = G.UIT.C,
            config = { align = "cm", padding = 0.2 },
            nodes = {
              { n = G.UIT.R, config = {align = "cm",}, nodes = {
                {
                  n = G.UIT.O,
                  config = {
                    id = "dynatext_stuff",
                    object = DynaText({string = {
                      { ref_table = AKYRS.word_check_data, ref_value = "text_disp" }
                    }, colours = {AKYRS.word_check_data.current_col}, shadow = true, pop_in = 0, float = true, scale = .6, silent = true})
                  }
                }
              } },
              {
                n = G.UIT.R,
                config = { padding = 0.05, w = 6.5, align = 'cm' },
                nodes = {
                  AKYRS.create_better_text_input({
                    w = 6.5,
                    h = 1,
                    max_length = 45, 
                    extended_corpus = true, 
                    prompt_text = "",
                    hide_keyboard = true,
                    ref_table = AKYRS.word_check_data,
                    ref_value = "word_check",
                    id = "check_wild",
                    keyboard_offset = 4.5,
                  })
                }
              },
              { n = G.UIT.R, config = {align = "cm",}, nodes = {
                UIBox_button({
                  button = "akyrs_check_word_btn",
                  label = { localize("k_akyrs_check_word_check") }
                })
              } },
              not AKYRS.config.full_dictionary and { n = G.UIT.R, config = { align = "cm", padding = 0.05}, nodes = {
                { n = G.UIT.C, config = { align = "cm", padding = 0.05}, nodes = 
                  {
                    {
                      n = G.UIT.R, config = { align = "cm" }, nodes = {
                        {
                          n = G.UIT.T,
                          config = {
                            text = localize("k_akyrs_word_tab_reduced_tip_1"),
                            scale = 0.3,
                            colour = G.C.UI.TEXT_INACTIVE
                          }
                        }
                      }
                    },
                    {
                      n = G.UIT.R, config = { align = "cm" }, nodes = {
                        {
                          n = G.UIT.T,
                          config = {
                            text = localize("k_akyrs_word_tab_reduced_tip_2"),
                            scale = 0.3,
                            colour = G.C.UI.TEXT_INACTIVE
                          }
                        }
                      }
                    },
                    {
                      n = G.UIT.R, config = { align = "cm" }, nodes = {
                        {
                          n = G.UIT.T,
                          config = {
                            text = localize("k_akyrs_word_tab_reduced_tip_3"),
                            scale = 0.3,
                            colour = G.C.UI.TEXT_INACTIVE
                          }
                        }
                      }
                    },
                  }
                },
              }} or nil,
            },
          }
        },
			}
end

function AKYRS.run_info_tab()
  local ret = {}
  if AKYRS.should_calculate_word() then
    table.insert(ret, {
          label = localize('b_akyrs_words'),
          tab_definition_function = AKYRS.UIDEF.words_run_info_tab,
      })
  end
  return unpack(ret)
end



function AKYRS.UIDEF.premium_joker_roll()
  local ret = { 
    n = G.UIT.ROOT,
    config = {
      r = 0.1,
      padding = 0.1,
    },
    nodes = {

    }
  }
  -- check the notability note i wrote for mockup 
  -- red is G.UIT.R
  -- blue and G.UIT.C
  -- yellow is G.akyrs_joker_rolls
  -- - aikoyori
  if not G.akyrs_joker_rolls or (G.akyrs_joker_rolls and G.akyrs_joker_rolls.REMOVED) then
    G.akyrs_joker_rolls = CardArea(
        0, 0,
        1.25*G.CARD_W,
        1.25*G.CARD_H, 
      {card_limit = 1, type = 'joker', highlight_limit = 0, negative_info = 'joker'})
  end
  if AKYRS.get_free_joker_roll_tier() > 0 then
    ret.nodes[#ret.nodes+1] = 
      {
        n = G.UIT.R,
        -- the card area
        nodes = {
          {
            n = G.UIT.C,
            nodes = {
              {
                n = G.UIT.R,
                nodes = {
                  {
                    n = G.UIT.O,
                    config = {
                      object = G.akyrs_joker_rolls,
                    }
                  }
                }
              }
            }
          },
          {
            n = G.UIT.C,
            nodes = {
              {
                n = G.UIT.R,
                nodes = {
                  {
                    n = G.UIT.T,
                    config = {
                      text = "PLACEHOLDER 1",
                      scale = 0.4,
                      colour = G.C.WHITE
                    }
                  }
                }
              },
              {
                n = G.UIT.R,
                nodes = {
                  {
                    n = G.UIT.T,
                    config = {
                      text = "PLACEHOLDER 2",
                      scale = 0.4,
                      colour = G.C.WHITE
                    }
                  }
                }
              },
              {
                n = G.UIT.R,
                nodes = {
                  {
                    n = G.UIT.T,
                    config = {
                      text = "PLACEHOLDER 3",
                      scale = 0.4,
                      colour = G.C.WHITE
                    }
                  }
                }
              },
            }
          },
        }
      }
    
  end
  return ret
end

AKYRS.get_life_sprite_pos = function (typer)
  if typer == "low" then
    return { x = 1, y = 0 }
  elseif typer == "verylow" then
    return { x = 2, y = 0 }
  elseif typer == "over" then
    return { x = 3, y = 0 }
  elseif typer == "kaleidoscope_pre" then
    return { x = 0, y = 1 }
  elseif typer == "kaleidoscope" then
    return { x = 1, y = 1 }
  end
  return { x = 0, y = 0}
end 

function AKYRS.UIDEF.akyrs_life_underlay(mode)
  local pos = AKYRS.get_life_sprite_pos(G.GAME.akyrs_life_cover_sprite)
  AKYRS.life_sprite = Sprite(0,0,3,3,G.ASSET_ATLAS.akyrs_life_indicator, pos)
  local dyna = DynaText{
    string = {
      {
        ref_table = G.GAME,
        ref_value = "akyrs_life_disp"
      }
    },
    colours = { G.C.WHITE },
    akyrs_number_format = 1e10,
  }
  return {
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      colour = G.C.CLEAR,
    },
    nodes = {
      {
        n = G.UIT.C,
        config = {
          align = "cm",
          
        },
        nodes = {
          {
            n = G.UIT.R,
            config = {
              shader = "akyrs_faded",
              align = "cm", 
            },
            nodes = {
              {
                n = G.UIT.O,
                config = {
                  object = AKYRS.life_sprite,
                  id = "life_sprite",
                }
              },
            }
          },
          {
            n = G.UIT.R,
            config = {
              padding = -3.8,
              align = "cm", 
            },
            nodes = {
              {
                n = G.UIT.C,
                config = {
                  align = "rc", 
                },
                nodes = {
                  {
                    n = G.UIT.O,
                    config = {
                      object = dyna,
                      id = "value_container",
                    }
                  }
                }
              },
            }
          },
        }
      }
    }
  }
end

function AKYRS.update_life_ui(game_ob)
  if game_ob.akyrs_life_ui then
      game_ob.akyrs_life_ui:remove() game_ob.akyrs_life_ui = nil
  end
  if AKYRS.life_sprite then
      AKYRS.life_sprite:remove() AKYRS.life_sprite = nil
  end
  --print(AKYRS.is_life_enabled())
  if AKYRS.is_life_enabled() then
      game_ob.akyrs_life_ui = UIBox {
          definition = AKYRS.UIDEF.akyrs_life_underlay(AKYRS.get_life_mode()),
          config = { align = "mb", offset = { x = 1, y = 0.4 }, major = G.jokers, bond = 'Weak' }
      }
  end
end


function AKYRS.badge_func() 
  mod = AKYRS
  local mod_name_node = {
      n = G.UIT.C, nodes = {}
  } 
  local mod_desc_node = {
      n = G.UIT.C, nodes = {}
  } 
  local mnind = pseudorandom("akyrs_mod_name", 1, #G.localization.misc.akyrs_misc.mod_label)
  local mftind = pseudorandom("akyrs_mod_flavour_text", 1, #G.localization.misc.akyrs_misc.flavour_text)
  localize({ type = "akyrs_misc", key = "mod_label",  index = mnind, nodes = mod_name_node.nodes, scale = 1.2, text_colour = mod.badge_text_colour, akyrs_dynatext_shadow = false, akyrs_default_dynatext_effect = '1' , akyrs_force_no_popin = true, akyrs_y_offset = -0.05})
  localize({ type = "akyrs_misc", key = "flavour_text",  index = mftind, nodes = mod_desc_node.nodes, scale = 0.8, text_colour = mod.badge_text_colour , akyrs_dynatext_shadow = false, akyrs_default_dynatext_effect = '0', akyrs_force_no_popin = true, akyrs_y_offset = -0.05})
  -- localize jank
  for k, v in ipairs(mod_name_node.nodes) do
      mod_name_node.nodes[k] = {n = G.UIT.R, config = { align = "m"}, nodes = mod_name_node.nodes[k]}
  end
  for k, v in ipairs(mod_desc_node.nodes) do
      mod_desc_node.nodes[k] = {n = G.UIT.R, config = { align = "m"}, nodes = mod_desc_node.nodes[k]}
  end
  local size = 0.9
  local size_desc = 0.6
  --local font = G.LANG.font
  --local font_desc = mod_flavour_tex.font or G.LANG.font
  local max_text_width = 2 - 2*0.05 - 4*0.03*size - 2*0.03
  local calced_text_width = 0
  local max_calced_text_width = 0
  local text_nodes =
      {
          { n = G.UIT.R, config = {minw =  0.6, align = "cm",}, nodes = {
              {n=G.UIT.B, config={h=0.1,w=0.03}},
              mod_name_node,
              {n=G.UIT.B, config={h=0.1,w=0.03}},
          }},
          { n = G.UIT.R, config = {minw =  0.6, align = "cm",}, nodes = {
              {n=G.UIT.B, config={h=0.1,w=0.03}},
              mod_desc_node,
              {n=G.UIT.B, config={h=0.1,w=0.03}},
          }}
      }
  return {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.R, config={align = "cm", shader = "akyrs_aiko_mod_badge", minw = 0.6, colour = mod.badge_colour or G.C.GREEN, r = 1, minh = 0.36, emboss = 0.05, padding = 0.03*0.9}, nodes=text_nodes}
  }}
end

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

function AKYRS.chicanery_reroll_btns(level) 
  local per = "round"
  local scale = 0.3
  if level == "rare" then per = "ante" end
  return 
      {
        n = G.UIT.R, config = { colour = G.C.GREEN, minw = 3, minh = 1, r = 0.05, padding = 0.1, align = "cm", emboss = 0.1, hover = true, button = 'akyrs_reroll_jimbo', func = 'akyrs_reroll_jimbo_can_use', ref_table = { level } },
        nodes = {
          { n = G.UIT.R, config = { padding = 0.05 },nodes = { 
            { n = G.UIT.C, nodes = { { n = G.UIT.T, config = { colour = G.C.WHITE, text = "`" , scale = scale, font = SMODS.Fonts["akyrs_611aiko"] } } } },
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

function AKYRS.jimbo_chance_chicanery()
  local parameters = {
    set = "Joker",
    area = G.akyrs_jimbo_chicanery_cardarea,
    key_append = "akyrs_jimbo_chicanery_starting",
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
    n = G.UIT.R, -- TODO: dont forget to change this to root when adding to the UI or not actually
    config = { minw = 12, minh = 8, colour = G.C.UI.TRANSPARENT_DARK, r = 0.1, padding = 0.25, align = "cm" },
    nodes = {
      -- first bullshit
      {
        n = G.UIT.R,
        config = { minw = 0, minh = 8, align = "cm", padding = 0.25,
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
end

function G.FUNCS.akyrs_reroll_jimbo(e)
  local info_table = e.config.ref_table
  local level = info_table[1]
  if G.akyrs_jimbo_chicanery_cardarea and G.akyrs_jimbo_chicanery_cardarea.cards then
    for _, c in ipairs(G.akyrs_jimbo_chicanery_cardarea.cards) do
      c:remove()
    end
    local parameters = {
      set = "Joker",
      area = G.akyrs_jimbo_chicanery_cardarea,
      key_append = "akyrs_jimbo_chicanery_"..info_table[1],
    }
    if info_table[1] == "uncommon" then
      parameters.rarity = "Uncommon"
    elseif info_table[1] == "rare" then
      parameters.rarity = "Rare"
    end
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
  ease_dollars(-G.GAME.akyrs_chicanery_rerolls_info.buy_cost)
  if G.akyrs_jimbo_chicanery_cardarea and G.akyrs_jimbo_chicanery_cardarea.cards then
    for _, c in ipairs(G.akyrs_jimbo_chicanery_cardarea.cards) do
      G.akyrs_jimbo_chicanery_cardarea:remove_card(c)
      SMODS.add_to_deck(c)
    end
  end
  G.GAME.akyrs_chicanery_rerolls_info.purchased_this_round = true
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

function G.FUNCS.akyrs_open_shop_window(e)
  G.AKYRS_ACTIVE_SHOP = e.config.ref_table
  G[G.AKYRS_ACTIVE_SHOP].alignment.offset.y = -5.7 
end

function G.FUNCS.akyrs_close_shop_window(e)
  if G[e.config.ref_table] then
    G[e.config.ref_table].alignment.offset.y = 11
    G.AKYRS_ACTIVE_SHOP = nil
  end
end

function G.FUNCS.akyrs_close_active_shop_window(e)
  G[G.AKYRS_ACTIVE_SHOP].alignment.offset.y = 11
  G.AKYRS_ACTIVE_SHOP = nil
end

function G.FUNCS.akyrs_shop_btn_func(e)
  local shop = e.config.ref_table
  if G.AKYRS_ACTIVE_SHOP ~= shop and G.STATE == G.STATES.SHOP then
    e.config.button = "akyrs_open_shop_window"
    e.config.colour = G.C.RED
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

function AKYRS.button_prefab(args) 
  args = args or {}
  return 
      {
        n = args.uit or G.UIT.R, config = { colour = args.colour or G.C.RED, minw = args.w or 0.5, minh = args.h or 0.5, r = 0.05, padding = args.padding or 0.05, align = "cm", emboss = 0.1, hover = true, button = args.button, func = args.func, ref_table = args.ref_table, ref_value = args.ref_value },
        nodes = args.children or {}
      }
end


function AKYRS.text_prefab(args) 
  args = args or {}
  return { n = args.uit or G.UIT.C, nodes = { { n = G.UIT.T, config = args.config or { colour = G.C.WHITE, text = args.text or "AIKO U SUCK WTFF", scale = args.scale or 0.4 } } } }
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
      ref_table = shop,
      func = "akyrs_shop_close_btn_func",
      button = "akyrs_close_shop_window",
  })
end

function AKYRS.refresh_shop_sign()
  if not G.SHOP_SIGN then return end
  G.SHOP_SIGN:remove()
  G.SHOP_SIGN = nil
  G.AKYRS_SHOP_SIGN_REFRESH_ONLY = true
  G.UIDEF.shop()
  G.AKYRS_SHOP_SIGN_REFRESH_ONLY = nil
end

