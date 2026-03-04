function AKYRS.UIDEF.hc_challenges(from_game_over)
    if G.PROFILES[G.SETTINGS.profile].all_unlocked or #G.PROFILES[G.SETTINGS.profile].challenge_progress.completed > 0 then
        G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked = true
    end
    
    if not G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked then
        local loc_nodes = {}
        localize { type = 'descriptions', key = 'akyrs_hardcore_challenge_locked', set = 'Other', nodes = loc_nodes, vars = {}, default_col = G.C.WHITE }

        return {
            n = G.UIT.ROOT,
            config = { align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8.02, minw = 7 },
            nodes = {
                transparent_multiline_text(loc_nodes)
            }
        }
    end

    G.run_setup_seed = nil
    if G.OVERLAY_MENU then
        local seed_toggle = G.OVERLAY_MENU:get_UIE_by_ID('run_setup_seed')
        if seed_toggle then seed_toggle.states.visible = false end
    end

    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 7},
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK  },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            func = 'akyrs_challenge_flame_handler',
                            id = 'akyrs_flame_challenge', 
                            object = Moveable(100,0,0,0), w = 0, h = 0,no_role = true,
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.1 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode'), scale = 0.6, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_flavour'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_flavour_2'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_flavour_3'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_wish_1'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_wish_2'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_tip_1'), scale = 0.3, colour = G.C.UI.TEXT_INACTIVE, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('k_akyrs_hardcore_challenge_mode_tip_2'), scale = 0.3, colour = G.C.UI.TEXT_INACTIVE, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", minw = 8.5, minh = 1.5, padding = 0.2 },
                        nodes = {
                            UIBox_button({
                                id = from_game_over and 'from_game_over' or nil,
                                label = { localize('b_new_challenge') },
                                button =
                                'akyrs_hc_challenge_list',
                                minw = 4,
                                scale = 0.4,
                                minh = 0.6
                            }),
                        }
                    }
                }
            },
        }
    }
end



G.FUNCS.akyrs_hc_challenge_list = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = AKYRS.UIDEF.hc_challenge_list((e.config.id == 'from_game_over')),
    }
    if (e.config.id == 'from_game_over') then G.OVERLAY_MENU.config.no_esc = true end
end

G.FUNCS.akyrs_change_hc_challenge_list_page = function(args)
    if not args or not args.cycle_config then return end
    if G.OVERLAY_MENU then
    local ch_list = G.OVERLAY_MENU:get_UIE_by_ID('hc_challenge_list')
    if ch_list then 
    if ch_list.config.object then 
        ch_list.config.object:remove() 
        ch_list.config.object = nil
    end
    ch_list.config.object = UIBox{
        definition =  G.UIDEF.akyrs_hc_challenge_list_page(args.cycle_config.current_option-1),
        config = {offset = {x=0,y=0}, align = 'cm', parent = ch_list}
    }
    G.FUNCS.akyrs_change_hc_challenge_description{config = {id = 'nil'}}
    end
end
end


G.FUNCS.akyrs_change_hc_challenge_description = function(e)
    if G.OVERLAY_MENU then
      local desc_area = G.OVERLAY_MENU:get_UIE_by_ID('challenge_area')
      if desc_area and desc_area.config.oid ~= e.config.id then
        if desc_area.config.old_chosen then desc_area.config.old_chosen.config.chosen = nil end
        e.config.chosen = 'vert'
        if desc_area.config.object then 
          desc_area.config.object:remove() 
        end
        desc_area.config.object = UIBox{
          definition =  G.UIDEF.challenge_description(e.config.id, nil, nil , true),
          config = {offset = {x=0,y=0}, align = 'cm', parent = desc_area}
        }
        desc_area.config.oid = e.config.id 
        desc_area.config.old_chosen = e
      end
    end
  end

function G.UIDEF.akyrs_hc_challenge_list_page(_page)
local snapped = false
local challenge_list = {}

G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore = G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore or {}
for k, v in ipairs(AKYRS.HC_CHALLENGES) do
    if k > G.AKYRS_HC_CHALLENGE_PAGE_SIZE*(_page or 0) and k <= G.AKYRS_HC_CHALLENGE_PAGE_SIZE*((_page or 0) + 1) then
    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.config.id == 'challenge_page' then snapped = true end
    local challenge_completed =  G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id or '']
    local is_challenge_high_score = v.type == "highscore" and (G.PROFILES[G.SETTINGS.profile].akyrs_challenge_highscore[v.key] or 0) or nil
    local difficultyString = ''
    local numberDiff = nil
    if v.difficulty and v.difficulty > 0 then
        if v.difficulty > 15 then
            difficultyString = "⭐"
            numberDiff = tostring(v.difficulty)
        else
            for i = 1, v.difficulty do
                difficultyString = difficultyString.."⭐"
            end
        end
    end
    
    local difficultyDynaText = DynaText{
        scale = 0.3,
        colours = {G.C.UI.TEXT_LIGHT},
        string = {localize("k_akyrs_hardcore_challenge_difficulty").." "},
    }
    local dynaTextFakeAhhDiff = DynaText{
        scale = 0.3,
        colours = {G.C.UI.TEXT_LIGHT},
        string = {numberDiff or ""},
    }
    local dynaTextObject = DynaText{
        scale = 0.3,
        colours = {G.C.UI.TEXT_LIGHT},
        string = {difficultyString},
        font = SMODS.Fonts["akyrs_NotoEmoji"]
    }
            challenge_list[#challenge_list + 1] =
            {n=G.UIT.R, config={align = '', padding = 0.08, colour = AKYRS.C.DARKER_TRANS, r = 0.2, minw = 0.8}, nodes = {{
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05, minw = 6 },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = { align = 'cl', padding = 0.05, minw = 1 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = k .. '', scale = 0.4, colour = G.C.WHITE } },
                                }
                            },
                            UIBox_button({ id = k, col = true, label = { localize(v.id, 'hardcore_challenge_names'), }, button =
                            'akyrs_change_hc_challenge_description', colour = G.C.RED, minw = 4, scale = 0.4, minh = 0.6, focus_args = { snap_to = not snapped } }),
                            {
                                n = G.UIT.C,
                                config = { align = 'cm', padding = 0.1, minw = 0.6 },
                                nodes = {
                                    {
                                        n = G.UIT.C,
                                        config = { minh = 0.4, minw = 0.4, emboss = 0.05, r = 0.1, colour = challenge_completed and G.C.GREEN or (is_challenge_high_score and G.C.PURPLE or G.C.BLACK), align = "cm" },
                                        nodes = 
                                            is_challenge_high_score and {
                                            { n = G.UIT.T, config = { text = is_challenge_high_score, scale = 0.3, colour = G.C.WHITE } } or
                                            nil} or {challenge_completed and
                                            { n = G.UIT.O, config = { object = Sprite(0, 0, 0.4, 0.4, G.ASSET_ATLAS["icons"], { x = 1, y = 0 }) } } or
                                            nil} 
                                        
                                    },
                                }
                            }
                        }
                    }
                }
            },
                {n=G.UIT.R, config={align = '', minw = 0.8, padding = 0.05}, nodes = {
                    {n=G.UIT.O, config={object = difficultyDynaText}},
                    {n=G.UIT.O, config={object = dynaTextFakeAhhDiff}},
                    {n=G.UIT.O, config={object = dynaTextObject}},
                }}
            }}
            snapped = true
        end
end

return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, colour = G.C.CLEAR}, nodes=challenge_list}
end

function AKYRS.UIDEF.hc_challenge_list(from_game_over)
    G.AKYRS_HC_CHALLENGE_PAGE_SIZE = 5
    local challenge_pages = {}
    for i = 1, math.ceil(#AKYRS.HC_CHALLENGES / G.AKYRS_HC_CHALLENGE_PAGE_SIZE) do
        table.insert(challenge_pages,
            localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#AKYRS.HC_CHALLENGES / G.AKYRS_HC_CHALLENGE_PAGE_SIZE)))
    end
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.FUNCS.akyrs_change_hc_challenge_list_page { cycle_config = { current_option = 1 } }
            return true
        end)
    }))

    local _ch_comp, _ch_tot = 0, #AKYRS.HC_CHALLENGES
    for k, v in ipairs(AKYRS.HC_CHALLENGES) do
        if v.id and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id or ''] then
          _ch_comp = _ch_comp + 1
        end
    end

    local t = create_UIBox_generic_options({
        back_id = from_game_over and 'from_game_over' or nil,
        back_func = 'setup_run',
        back_id = 'hc_challenge_list',
        contents = {
            {
                n = G.UIT.O,
                config = {
                    func = 'akyrs_challenge_flame_handler',
                    id = 'akyrs_flame_challenge_list', 
                    object = Moveable(100,0,0,0), w = 0, h = 0,no_role = true,
                }
            },
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.0 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.1, minh = 7, minw = 4.2 },
                        nodes = {
                            { n = G.UIT.O, config = { id = 'hc_challenge_list', object = Moveable() } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.1 },
                        nodes = {
                            create_option_cycle({ id = 'challenge_page', scale = 0.9, h = 0.3, w = 3.5, options =
                            challenge_pages, cycle_shoulders = true, opt_callback = 'akyrs_change_hc_challenge_list_page', current_option = 1, colour =
                            G.C.RED, no_pips = true, focus_args = { snap_to = true } })
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.1 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize { type = 'variable', key = 'challenges_completed', vars = { _ch_comp, _ch_tot } }, scale = 0.4, colour = G.C.WHITE } },
                        }
                    },

                }
            },
            {
                n = G.UIT.C,
                config = { align = "cm", minh = 9, minw = 11.5 },
                nodes = {
                    { n = G.UIT.O, config = { id = 'challenge_area', object = Moveable() } },
                }
            },
        }
    })
    return t
end


G.FUNCS.akys_start_hc_challenge_run = function(e)
    if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end
    local stake = (G.P_STAKES[e.config.stake] and G.P_STAKES[e.config.stake].stake_level) or (type(e.config.stake) == "number" and e.config.stake) or 1
    G.FUNCS.start_run(e, {stake = stake, challenge = AKYRS.HC_CHALLENGES[e.config.id]})
end

local startChallengeRunHook = G.FUNCS.start_challenge_run
G.FUNCS.start_challenge_run = function(e)
    if not e.config.stake then 
        local ret = startChallengeRunHook(e)
    else
        if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end
        local stake = (G.P_STAKES[e.config.stake] and G.P_STAKES[e.config.stake].stake_level) or (type(e.config.stake) == "number" and e.config.stake) or 1
        G.FUNCS.start_run(e, {stake = stake, challenge = G.CHALLENGES[e.config.id]})
    end
  end
  

G.FUNCS.akyrs_hc_challenge_deck_view_challenge = function(e)
G.FUNCS.overlay_menu{
    definition = create_UIBox_generic_options({back_func = 'deck_info', contents ={
        G.UIDEF.challenge_description(AKYRS.get_hc_challenge_int_from_id(e.config.id.id or ''), nil, true, true)
    }
    })
}
end

function AKYRS.get_hc_challenge_int_from_id(_id)
    for k, v in pairs(AKYRS.HC_CHALLENGES) do
        if v.id == _id then return k end
    end
    return 0
end

AKYRS.colours_from_difficulty = function(diffInt)
    if diffInt == nil or diffInt == 0 then
        return {colour = HEX('FFA500'), accent = HEX('FFFFFF')}
    elseif diffInt >= 10 then
        return {colour = HEX('8833ff'), accent = HEX('7420a8')}
    else
        local ratio = diffInt / 10
        local r = math.floor(255 * (1 - ratio) + 136 * ratio)
        local g = math.floor(165 * (1 - ratio) + 51 * ratio)
        local b = math.floor(0 * (1 - ratio) + 255 * ratio)
        return {colour = {r / 255, g / 255, b / 255, 1}, accent = {r / 255, g / 255, b / 255, 1}}
    end
end

G.FUNCS.akyrs_challenge_flame_handler = function(e)
    G.C.AKYRS_UI_HC_LICK = G.C.AKYRS_UI_HC_LICK or {1, 1, 1, 1}
    for i=1, 3 do
        G.C.AKYRS_UI_HC_LICK[i] = math.min(math.max(((G.C.AKYRS_UI_HC_LICK[i]*0.5+G.C.PURPLE[i]*0.5) + 0.1)^2, 0.1), 1)
    end

    G.ARGS.akyrs_flame_handler = G.ARGS.akyrs_flame_handler or {
        challenge_entry = {
            id = 'akyrs_flame_challenge', 
            arg_tab = 'akyrs_flame_challenge',
            colour = HEX('8833ff'),
            accent = HEX('7420a8'),
            w = G.ROOM.T.w/2,
            h = G.ROOM.T.h,
            x = 0,
            y = 5.75,
            intensity = 7
        },
        challenge_list = {
            id = 'akyrs_flame_challenge_list', 
            arg_tab = 'akyrs_flame_challenge',
            colour = HEX('8833ff'),
            accent = HEX('7420a8'),
            w = 22,
            h = 25,
            x = 0,
            y = 12.5,
            intensity = 1,
            intensity_controlled_by_diff = true,
            colour_controlled_by_diff = true,
        },
    }
    for k, v in pairs(G.ARGS.akyrs_flame_handler) do
        if e.config.id == v.id then 
        if not e.config.object:is(Sprite) or e.config.object.ID ~= v.ID then 
            e.config.object:remove()
            e.config.object = Sprite(0, 0, v.w, v.h, G.ASSET_ATLAS["akyrs_aikoyori_intro"], {x = 0, y = 0})
            v.ID = e.config.object.ID
            G.ARGS[v.arg_tab] = {
                intensity = 0,
                real_intensity = 0,
                intensity_vel = 0,
                colour_1 = v.colour,
                colour_2 = v.accent,
                timer = G.TIMERS.REAL
            }      
            e.config.object:set_alignment({
                major = e.parent,
                type = 'bmi',
                offset = {x=v.x,y=v.y},
                xy_bond = 'Weak'
            })
            e.config.object:define_draw_steps({{
            shader = 'akyrs_trimmed_flame',
            send = {
                {name = 'time', ref_table = G.ARGS[v.arg_tab], ref_value = 'timer'},
                {name = 'amount', ref_table = G.ARGS[v.arg_tab], ref_value = 'real_intensity'},
                {name = 'image_details', ref_table = e.config.object, ref_value = 'image_dims'},
                {name = 'texture_details', ref_table = e.config.object.RETS, ref_value = 'get_pos_pixel'},
                {name = 'colour_1', ref_table =  G.ARGS[v.arg_tab], ref_value = 'colour_1'},
                {name = 'colour_2', ref_table =  G.ARGS[v.arg_tab], ref_value = 'colour_2'},
                {name = 'id', val =  e.config.object.ID},
            }}})
            e.config.object:get_pos_pixel()
        end
        local _F = G.ARGS[v.arg_tab]
        local exptime = math.exp(-0.6*G.real_dt)
        
        _F.intensity = v.intensity
        if v.intensity_controlled_by_diff and AKYRS.current_hc_difficulty then
            _F.intensity = AKYRS.current_hc_difficulty * 2 or v.intensity
        end

        if v.colour_controlled_by_diff and AKYRS.current_hc_difficulty then
            local x = AKYRS.colours_from_difficulty(AKYRS.current_hc_difficulty)
            for i = 1, 4 do
            _F.colour_1[i] = _F.colour_1[i] * 0.9 + x.colour[i] * 0.1
            _F.colour_2[i] = _F.colour_2[i] * 0.9 + x.accent[i] * 0.1
            end
        end
        _F.timer = _F.timer + G.real_dt*(1 + _F.intensity*0.05)
        if _F.intensity_vel < 0 then _F.intensity_vel = _F.intensity_vel*(1 - 10*G.real_dt) end
            _F.intensity_vel = (1-exptime)*(_F.intensity - _F.real_intensity)*G.real_dt*40 + exptime*(_F.intensity_vel)
            _F.real_intensity = math.max(0, _F.real_intensity + _F.intensity_vel)
            _F.change = (_F.change or 0)*(1 - 4.*G.real_dt) + ( 4.*G.real_dt)*(_F.real_intensity < _F.intensity - 0.0 and 1 or 0)*_F.real_intensity
        end
    end
    end
