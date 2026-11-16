---@type {[string]: AKYRS.Config_Item}
AKYRS.Configs = {}
---@type string[]
AKYRS.Configs_List = {}

---@type {[string]:AKYRS.Config_Item[]}
AKYRS.Configs_Per_Category = {
    main = {},
    accessibility = {},
}

G.FUNCS.akyrs_default_callback = function (e)
    local conf = e.cycle_config
    conf.ref_table[conf.ref_value] = e.to_key
    AKYRS.Configs[conf.ref_value]:save_func(e)
end
---@alias AKYRS.Config_Types 'boolean' | 'choice'
---@alias AKYRS.Config_Category 'main' | 'accessibility' | 'assist'

---@class AKYRS.Config_Item: SMODS.GameObject
---@field config_type AKYRS.Config_Types is it a toggle or a choice
---@field config_category AKYRS.Config_Category which pane
---@field requires_restart boolean mh
---@field loc_vars? fun(self: SMODS.Center|table, info_queue: table, card: Card|table): table? Provides simple control over displaying descriptions and tooltips of the card. See [`loc_vars`](https://docs.smods.dev/API%20Documentation/Localization#loc_vars) documentation for return value details. 
---@field get_options fun(self): table options for select options
---@field generate_config_ui fun(self): table to generate ui for config menu
---@field save_func fun(self) save function
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
    get_options = function (self)
        return {

        }
    end,
    is_visible = function (self)
        return true
    end,
    generate_ui = SMODS.Center.generate_ui,
    generate_config_ui = function (self)
        if self.config_type == 'boolean' then
            return { n = G.UIT.R, config = { align = "rt"}, nodes = {
                    { n = G.UIT.C, config = {
                        align = "cm", padding = 0.0, r = 1
                    }, nodes = {
                        create_toggle({
                            label = localize({ type = 'name_text', key = self.key, set = self.set }) .. (self.requires_restart and "*" or ''),
                            ref_table = self.ref_table,
                            ref_value = self.key,
                            label_scale = 0.4,
                            callback = self.save_func
                            })
                        }
                    },
                    self.hide_help_icon and AKYRS.create_hover_tooltip{ tooltip_table = AKYRS.Configs, tooltip_key = self.key }
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
                        text = localize({ type = 'name_text', key = self.key, set = self.set }).. (self.requires_restart and "*" or ''),
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
                        current_option = self.ref_table[self.key],
                        opt_callback = "akyrs_default_callback",
                        ref_table = self.ref_table,
                        ref_value = self.key
                        })
                    }
                },
                    self.hide_help_icon and AKYRS.create_hover_tooltip{ tooltip_table = AKYRS.Configs, tooltip_key = self.key }
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
    key = 'enable_assist_options',
    config_category = 'assist',
}