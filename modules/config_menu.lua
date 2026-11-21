---@type {[string]: AKYRS.Config_Item}
AKYRS.Configs = {}
---@type string[]
AKYRS.Configs_List = {}

---@type {[string]:AKYRS.Config_Item[]}
AKYRS.Configs_Per_Category = {
    main = {},
    accessibility = {},
    assist = {},
}

G.FUNCS.akyrs_default_callback = function (e)
    local conf = e.cycle_config
    local cfobj = AKYRS.Configs[conf.ref_value]
    --print(e)
    if cfobj.save_value_directly then
        conf.ref_table[conf.ref_value] = e.to_val
    else
        conf.ref_table[conf.ref_value] = e.to_key
    end
    cfobj:save_func(e)
end

G.FUNCS.akyrs_default_button_callback = function (e)
    local conf = e.config.ref_table
    AKYRS.Configs[conf.ref_value]:button_func(e)
end


AKYRS.assist_mode_config_ui = function()
    local has_require_restart = false
    local config_tab_nodes = {}
    for _, category in ipairs({ 'assist'}) do
        local config_for_panel = {
        {
            n = G.UIT.R,
            config = {
            align = 'cm',
            },
            nodes = {
            {
                n = G.UIT.T,
                config = {
                text = localize('k_akyrs_config_cat_'..category),
                scale = 0.6,
                colour = G.C.WHITE,
                }
            }
            }
        }
        }
        for _, config_obj in ipairs(AKYRS.Configs_Per_Category[category]) do
        if config_obj:is_visible() then
            has_require_restart = has_require_restart or config_obj.requires_restart
            config_for_panel[#config_for_panel+1] = config_obj:generate_config_ui()
        end
        end
        config_tab_nodes[#config_tab_nodes+1] = {
        n = G.UIT.C,
        config = {
            padding = 0.2,
            colour = G.C.DYN_UI.BOSS_MAIN,
            r = 1,
        },
        nodes = config_for_panel,
        }
    end
    return create_UIBox_generic_options({
        contents = {
            {
            n = G.UIT.R, config = { minw = 1, minh = 1 ,align = "tm",colour = G.C.UI.TRANSPARENT_DARK, r = 0.1 },
            nodes = {
            {
                n = G.UIT.R,
                config = {
                padding = 0.1
                },
                nodes = config_tab_nodes
            },
            has_require_restart and 
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.2 },
                nodes = {
                { n = G.UIT.T, config = { text = localize("k_akyrs_restart_required"), scale = 0.4, colour = G.C.AKYRS_TRANSPARENT_TEXT } }
                }
            },
            }
        }
        },
        back_func = "openModUI_"..G.ACTIVE_MOD_UI.id,
    })
end



---@alias AKYRS.Config_Types 'boolean' | 'choice' | 'button'
---@alias AKYRS.Config_Category 'main' | 'accessibility' | 'assist'

---@class AKYRS.Config_Item: SMODS.GameObject
---@field config_type AKYRS.Config_Types is it a toggle or a choice
---@field config_category AKYRS.Config_Category which pane
---@field requires_restart boolean mh
---@field save_value_directly boolean save option value directly
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, card: Card|table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://docs.smods.dev/API%20Documentation/Localization#loc_vars) documentation for return value details. 
---@field get_options fun(self): table options for select options
---@field generate_config_ui fun(self): table to generate ui for config menu
---@field get_text fun(self): string get text for button, second argument is mostly for secondary text like thing in button
---@field save_func fun(self, e:UINode) save function
---@field button_func fun(self, e:UINode) button function for button
---@field get_refs fun(self): table ref table and ref value func
---@field hide_help_icon boolean help icon
---@field is_visible fun(self): boolean hide certain config
---@overload fun(self: AKYRS.Config_Item): AKYRS.Config_Item
AKYRS.Config_Item = SMODS.GameObject:extend {
    required_params = {
        'key',
        'config_type',
    },
    inject = function (self)
        self.ref_table = AKYRS.config
        self.ref_value = self.key
        local r = self:get_refs()
        if r then
            self.ref_table = r.ref_table or self.ref_table
            self.ref_value = r.ref_value or self.ref_value
        end
        AKYRS.Configs_Per_Category[self.config_category][#AKYRS.Configs_Per_Category[self.config_category]+1] = self
    end,
    create_fake_card = SMODS.Center.create_fake_card,
    obj_table = AKYRS.Configs,
    obj_buffer = AKYRS.Configs_List,
    set = 'AikoShenConfig',
    prefix_config = false,
    config_type = 'boolean',
    config_category = 'main',
    save_func = function (self, e)
        AKYRS.save_config(e)
    end,
    button_func = function (self, e)
        AKYRS.save_config(e)
    end,
    get_options = function (self)
        return {

        }
    end,
    get_refs = function (self)
    end,
    is_visible = function (self)
        return true
    end,
    get_text = function (self)
        return localize({ type = 'name_text', key = self.key, set = self.set }), 'Secondary Text'
    end,
    generate_ui = SMODS.Center.generate_ui,
    generate_config_ui = function (self)
        local str = { self:get_text() }
        if self.config_type == 'boolean' then
            return { n = G.UIT.R, config = { align = "rt"}, nodes = {
                    { n = G.UIT.C, config = {
                        align = "cm", padding = 0.0, r = 1
                    }, nodes = {
                        create_toggle({
                            label = (str[1] and str[1] or '') .. (self.requires_restart and "*" or ''),
                            ref_table = self.ref_table,
                            ref_value = self.key,
                            label_scale = 0.4,
                            callback = self.save_func
                            })
                        }
                    },
                    not self.hide_help_icon and AKYRS.create_hover_tooltip{ tooltip_table = AKYRS.Configs, tooltip_key = self.key }
                }
            }
        end
        if self.config_type == 'choice' then
            local opts = self.get_options()
            return { n = G.UIT.R, config = {align = "rt"}, nodes = {
                { n = G.UIT.C, config = {
                    align = "cm", padding = 0.1,
                }, nodes = {
                    {n = G.UIT.T, config = {
                        text = (str[1] and str[1] or '').. (self.requires_restart and "*" or ''),
                        scale = 0.4,
                        colour = G.C.UI.TEXT_LIGHT
                        }}
                    }
                },
                { n = G.UIT.C, config = {
                    align = "cm", padding = 0.0,
                    id = self.key.. "_dynatext"
                }, nodes = {
                    create_option_cycle({
                        options = opts,
                        scale = 0.7,
                        w = 4.5,
                        current_option = self.save_value_directly and AKYRS.find_index(opts,self.ref_table[self.key]) or self.ref_table[self.key],
                        opt_callback = "akyrs_default_callback",
                        ref_table = self.ref_table,
                        ref_value = self.key
                        })
                    }
                },
                    not self.hide_help_icon and AKYRS.create_hover_tooltip{ tooltip_table = AKYRS.Configs, tooltip_key = self.key }
                },
            }
        end
        if self.config_type == 'button' then
            return { n = G.UIT.R, config = {align = "mt"}, nodes = {
                { n = G.UIT.C, config = {
                    align = "cm", padding = 0.1,
                }, nodes = {
                        {n = G.UIT.T, config = {
                        text = (str[1] and str[1] or '').. (self.requires_restart and "*" or ''),
                        scale = 0.4,
                        colour = G.C.UI.TEXT_LIGHT
                        }},
                        { n = G.UIT.C, config = {
                            align = "cm", padding = 0.0,
                        }, nodes = {
                            AKYRS.button_prefab({
                                ref_table = {
                                    ref_table = self.ref_table,
                                    ref_value = self.key,
                                },
                                padding = 0.3,
                                button = 'akyrs_default_button_callback',
                                children = {
                                    AKYRS.text_prefab({
                                        text = str[2] and str[2] or ''
                                    })
                                }
                            })
                        },},
                    },
                },
                not self.hide_help_icon and AKYRS.create_hover_tooltip{ tooltip_table = AKYRS.Configs, tooltip_key = self.key }
                },
            }
        end
    end
}
--[[
config file so i can just add
	wildcard_behaviour = 1,
	show_joker_preview = true,
	balance = "adequate",
	turn_on_crt = true,
	full_dictionary = true,
	legacy_challenges = false,
	experimental_features = false,

	-- accessibility is good :3
	colourblind_ui = false,
	fancy_ui = true,
	mechanics_tutorial = true,
	enable_assist_options = false,
	osk_with_mouse = false,
	assist_options = {
		scenario_timer_multiplier = 1,
		scenario_clicks_instead_of_seconds = false,
	}
]]
AKYRS.Config_Item{
    key = 'wildcard_behaviour',
    config_type = 'choice',
    loc_vars = function (self, info_queue, card)
        return {
            key = self.key .. '_' .. (self.ref_table[self.ref_value])
        }
    end,
    get_options = function (self)
        return localize('k_akyrs_wildcard_behaviours')
    end
}
AKYRS.Config_Item{
    key = 'show_joker_preview',
}

AKYRS.Config_Item{
    key = 'disable_tag_rework',
}

AKYRS.Config_Item{
    key = 'legacy_challenges',
}

AKYRS.Config_Item{
    key = 'experimental_features',
    requires_restart = true,
    save_func = function (self)
        if not RELEASE_MODE then
            AKYRS.save_config(e)
        else
            AKYRS.config.experimental_features = false
            AKYRS.save_config(e)
        end
    end,
    is_visible = function (self)
        return AKYRS.config.experimental_features or AKYRS.hidden_option_visible
    end
}

AKYRS.Config_Item{
    key = 'fancy_ui',
    config_category = 'accessibility',
    is_visible = function (self)
        return not not SMODS.create_tooltip
    end
}
AKYRS.Config_Item{
    key = 'colourblind_ui',
    config_category = 'accessibility',
}
AKYRS.Config_Item{
    key = 'osk_with_mouse',
    config_category = 'accessibility',
}
AKYRS.Config_Item{
    key = 'mechanics_tutorial',
    config_category = 'accessibility',
    is_visible = function (self)
        return AKYRS.Tutorials
    end
}
AKYRS.Config_Item{
    key = 'open_assist_options',
    config_type = 'button',
    get_text = function (self)
        return nil, localize({ type = 'name_text', key = self.key, set = self.set })
    end,
    button_func = function (self, e)
        G.SETTINGS.paused = true
        G.FUNCS.overlay_menu{
            definition = AKYRS.assist_mode_config_ui(),
        }
    end,
    hide_help_icon = true,
    config_category = 'accessibility',
}

AKYRS.Config_Item{
    key = 'enable_assist_options',
    config_category = 'assist',
}

AKYRS.Config_Item{
    key = 'timer_use_clicks',
    get_refs = function (self)
        return {
            ref_table = AKYRS.config.assist_options
        }
    end,
    config_category = 'assist',
}

AKYRS.Config_Item{
    key = 'timer_multiplier',
    get_refs = function (self)
        return {
            ref_table = AKYRS.config.assist_options
        }
    end,
    config_type = 'choice',
    save_value_directly = true,
    get_options = function (self)
        return {
            0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        }
    end,
    config_category = 'assist',
}


AKYRS.Config_Item{
    key = 'life_no_autolose',
    get_refs = function (self)
        return {
            ref_table = AKYRS.config.assist_options
        }
    end,
    config_category = 'assist',
}

AKYRS.Config_Item{
    key = 'no_aikoshen_content',
    get_refs = function (self)
        return {
            ref_table = AKYRS.config.assist_options
        }
    end,
    config_category = 'assist',
}
