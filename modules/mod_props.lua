-- steamodded wtf why was i not told about this

SMODS.current_mod.ui_config = {
    colour = G.C.AKYRS_AIKOYORI_HAIR_MAIN_HAIR_DARK, -- Main UI box
    bg_colour = G.C.AKYRS_AIKOYORI_BG, -- Background
    back_colour = G.C.AKYRS_AIKOYORI_CARDIGAN, -- Back button
    tab_button_colour = G.C.AKYRS_AIKOYORI_BOW_SHADE, -- Tabs buttons
    outline_colour = G.C.AKYRS_AIKOYORI_HAIR, -- Main UI box outline
    author_colour = G.C.AKYRS_AIKOYORI_HAIR, -- Author text
    author_bg_colour = G.C.AKYRS_AIKOYORI_HAIR, -- Author box background
    author_outline_colour = G.C.AKYRS_AIKOYORI_BOW, -- Author box outline
    collection_bg_colour = G.C.AKYRS_AIKOYORI_BG,
    collection_back_colour = G.C.AKYRS_AIKOYORI_CARDIGAN, -- Collection background (Defaults to back_colour)
    collection_outline_colour = G.C.AKYRS_AIKOYORI_HAIR, -- Collection background (Defaults to outline_colour)
    collection_option_cycle_colour = G.C.AKYRS_AIKOYORI_BOW_SHADE, -- Collection option cycle button
}

SMODS.current_mod.extra_tabs = function()
  return {
    --[[
    {
      label = localize("k_akyrs_credits"),
    },
    ]]
    {
      label = localize("k_akyrs_solitaire"),
      tab_definition_function = AKYRS.SOL.get_UI_definition
    },
  }
end

AKYRS.create_credits_big = function(sprite_atlas, name, width)
  local cards_print = AKYRS.word_to_cards(name)

  return {
    n = G.UIT.R,
    config = {minw = 1, maxw = 1, minh = 1, maxh = 1, },
    nodes = {
      sprite_atlas and {
        n = G.UIT.C,
        config = { minw = 1, maxw = 1, minh = 1, maxh = 1, align = "cm" },
        nodes = {
          AKYRS.embedded_ui_sprite(sprite_atlas, { x = 0, y = 0 }, nil, {
            w = 200,
            h = 200,
            manual_scale = 180,
            fxh = 1,
            fxw = 1,
            padding = 0,
            rounded = 0.5
          }),
        }
      },
      {
        n = G.UIT.C,
        config = { w = 4, minh = 1.4, align = "tl" },
        nodes = {
          AKYRS.card_area_preview(G.creditCardArea, nil, {
            cards = cards_print,
            h = 0.3,
            w = width,
            ml = 0,
            override = true,
            scale = 0.5,
            type = "akyrs_credits",
          }),
        }
      },
    }
  }
end
AKYRS.create_credits = function(sprite_atlas, name, credits_internal_name, width, colour, credits_nodes)
  return {
    n = G.UIT.R,
    config = { padding = 0 },
    nodes = {
      sprite_atlas and {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.1, button = "akyrs_your_collection_credits", ref_table = {credit = credits_internal_name or "none"} },
        nodes = {
          AKYRS.embedded_ui_sprite(sprite_atlas, { x = 0, y = 0 }, nil, {
            w = 200,
            h = 200,
            manual_scale = 200,
            padding = 0,
            rounded = 0.5
          }),
        }
      },
      {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.1  },
        nodes = {
          {
            n = G.UIT.R,
            config = {},
            nodes = {
              {
                n = G.UIT.T, config = {
                  text = name,
                  colour = colour or G.C.WHITE,
                  scale = 0.4,
                }
              }
            }
          },
          credits_nodes or nil
        }
      },
    }
  }
end

function AKYRS.create_button_icon(sprite_atlas, px, py, uit)
  return {
    n = uit or G.UIT.C,
    nodes = {
      AKYRS.embedded_ui_sprite(sprite_atlas, { x = px or 0, y = py or 0 }, nil, {
        w = 18,
        h = 18,
        manual_scale = 54,
        padding = 0,
        rounded = 0.5
      }),
    }
  }
end
function AKYRS.create_link_sprite_btn(platform, link)
  local col = G.C.BLACK
  local px, py = 0, 0
  if platform == "youtube" then
    col = G.C.RED
    px, py = 0, 0
  end
  if platform == "bsky" then
    col = G.C.BLUE
    px, py = 1, 0
  end
  if platform == "twitter" then
    col = G.C.BLUE
    px, py = 2, 0
  end
  if platform == "pixeljoint" then
    col = G.C.BOOSTER
    px, py = 3, 0
  end
  
  return 
  {
    n = G.UIT.C,
    config = {
      button = "akyrs_open_link",
      link = link or "https://aikoyori.xyz",
      colour = darken(col, 0.4),
      padding = 0.05,
      r = 0.1,
      emboss = 0.05,
      hover = true,
    },
    nodes = {
      AKYRS.create_button_icon("akyrs_misc_icons", px, py)
    }
  }
end

SMODS.current_mod.custom_ui = function (mod_nodes)
  mod_nodes = EMPTY(mod_nodes)
  local tg = G.ROOM
  ---@type Card
  local aikocard = Card(tg.T.x,tg.T.y,G.CARD_W,G.CARD_H,nil,G.P_CENTERS['j_akyrs_aikoyori'], { bypass_discovery_center = true, bypass_discovery_ui = true })
  aikocard.ambient_tilt = 0
  local cards1 = {
    aikocard
  }
  aikocard.click = AKYRS.aiko_click
  local node1 = {
    n = G.UIT.C,
    config = { w = 8, align = "tm", r = 0.1 , h = 6, padding = 0.2, colour = G.C.AKYRS_HAIR_DARKER},
    nodes = {
      {
        n = G.UIT.R,
        config = { align = "tm" },
        nodes = {
          { n = G.UIT.O, config = { object = 
          DynaText{
            string = localize("k_akyrs_title"), 
            scale = 1, 
            colours = {SMODS.Gradients["akyrs_mod_title"]},
            pop_in = 0.1,
            float = 1,
            bump_rate = 10,
            text_effect = 'akyrs_rainbow_wiggle',
            bump_amount = 5,
          }
          } }
        }
      },
      {
        n = G.UIT.R,
        config = { align = "tm" },
        nodes = {
          {
            n = G.UIT.C,
            config = {padding = 0.2},
            nodes = {
              {
                n = G.UIT.R,
                config = {},
                nodes = {
                  { n = G.UIT.T, config = { text = localize("k_akyrs_created_by"), scale = 0.5, colour = G.C.WHITE } }
                }
              },
              {
                n = G.UIT.R,
                config = { w = 4, align = "cm" },
                nodes = {
                  {
                    n = G.UIT.C,
                    config = { w = 4, align = "rm" },
                    nodes = {
                      AKYRS.card_area_preview(G.creditCardArea, nil, {
                        cards = cards1,
                        h = 1.6,
                        w = 1.0,
                        override = true,
                        scale = 1.5,
                        type = "akyrs_credits",
                      }),
                    }
                  },
                }
              },
              {
                n = G.UIT.R,
                config = {},
                nodes = {
                  UIBox_button({
                    colour = HEX('5865F2'), minw = 3.5, minh = 1, padding = 0.1, emboss = 0.2, button = "go_to_aikoyori_discord_server", label = {localize("k_akyrs_join_akyrs_discord")}
                  })
                }
              },
            }
          },
        }
      },
    }
  }
  table.insert(mod_nodes, node1)
end

SMODS.current_mod.extra_tabs = function ()
  return {
    { 
      label = localize("k_akyrs_credits"),
      tab_definition_function = function ()
        return {
          n = G.UIT.ROOT,
          config = {
            r = 0.5,
            padding = 0.5,
            colour = G.C.AKYRS_HAIR_DARKER,
            align = "cm",
          },
          nodes = {
            {
              n = G.UIT.C,
              config = {padding = 0.05},
              nodes = {
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_additional_art_by"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                AKYRS.create_credits("akyrs_larantula_l_credits", "@larantula_l", "larantula_l", 3.1, nil,
                {
                  n = G.UIT.R,
                  config = { padding = 0.02 },
                  nodes = {
                    AKYRS.create_link_sprite_btn("youtube", "https://www.youtube.com/@Larantula"),
                  }
                }),
                AKYRS.create_credits("akyrs_plasma_credits", "@eggymari", "eggymari", 2.7, nil, 
                {
                  n = G.UIT.R,
                  config = { padding = 0.02 },
                  nodes = {
                    AKYRS.create_link_sprite_btn("youtube", "https://www.youtube.com/@PlasmaPhrase"),
                    AKYRS.create_link_sprite_btn("twitter", "https://twitter.com/plasmaphrase"),
                  }
                }),
                AKYRS.create_credits("akyrs_gud_credits", "@gudusername_53951", "gudusername_53951", 3.6),
                AKYRS.create_credits("akyrs_lyman_credits", "@Lyman", "lyman", 1.9, nil,
                {
                  n = G.UIT.R,
                  config = { padding = 0.02 },
                  nodes = {
                    AKYRS.create_link_sprite_btn("pixeljoint", "https://pixeljoint.com/p/172299.htm"),
                  }
                }),
              }
            },
            {
              n = G.UIT.C,
              config = {padding = 0.05},
              nodes = {
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_additional_help_by"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                AKYRS.create_credits("akyrs_drmonty_credits", "@dr_monty_the_snek", "dr_monty_the_snek", 3.5, nil,
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_drmonty_help"), scale = 0.3, colour = G.C.WHITE } }
                  }
                }),
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_cross_mods_creds"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = "TheOneGoofAli, PaperMoon", scale = 0.3, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_special_thanks"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = "haya_underscore, SleepyG11", scale = 0.3, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = "TheCoroboCorner, ThunderEdge", scale = 0.35, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = "TheUnseenExplosion, focussh0ck, sizaak", scale = 0.3, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  nodes = {
                    { n = G.UIT.C, nodes = {{ n = G.UIT.T, config = { text = "lily.felli", scale = 0.3, colour = G.C.WHITE } }}, },
                    { n = G.UIT.C, nodes = {{ n = G.UIT.T, config = { text = localize("k_akyrs_please_dont_kill_me"), scale = 0.2, colour = G.C.GREY } }}, },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_sharetest_cred_1"), scale = 0.3, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_sharetest_cred_2"), scale = 0.3, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_thanks_you_for_playing"), scale = 0.3, colour = G.C.WHITE } },
                  }
                },
              }
            }
          }
        }
      end
    }
  }
end

-- copied from breeze https://discord.com/channels/1116389027176787968/1337300709602754611/1337705824859979817
AKYRS.save_config = function(e)
  local status, err = pcall(SMODS.save_mod_config,AKYRS)
  if status == false then
      sendErrorMessage("Failed to perform a manual mod config save.", 'Aikoyori\'s Shenanigans') -- sorry 
  end
end

G.FUNCS.akyrs_change_wildcard_behaviour = function (e)
  AKYRS.config.wildcard_behaviour = e.to_key
  AKYRS.save_config(e)
end

G.FUNCS.akyrs_change_balance_toggle = function (e)
  local text_col = G.C.UI.TEXT_LIGHT
  G.PROFILES[G.SETTINGS.profile].akyrs_balance = AKYRS.rev_balance_map[e.to_key]
  if G.PROFILES[G.SETTINGS.profile].akyrs_balance == "absurd" and not Talisman then
    G.PROFILES[G.SETTINGS.profile].akyrs_balance = "adequate"
    text_col = G.C.RED
  end
  G:save_settings()
end

G.FUNCS.akyrs_change_joker_preview_stuff = function (e)
  AKYRS.save_config(e)
end

G.FUNCS.akyrs_update_wildcard_tooltip = function (e)
  e.config.detailed_tooltip = AKYRS.DescriptionDummies["dd_akyrs_wildcard_behaviour_"..AKYRS.config.wildcard_behaviour]
end

G.FUNCS.akyrs_change_crt_toggle = function (e)
  AKYRS.save_config(e)
end

G.FUNCS.save_config = function (e)
  AKYRS.save_config(e)
end

AKYRS.balance_map = {
  ["adequate"] = 1,
  ["absurd"] = 2,
}
AKYRS.rev_balance_map = {
  "adequate", "absurd"
}

SMODS.current_mod.config_tab = function ()

  return {
    n = G.UIT.ROOT, config = { minw = 9, minh = 5 ,align = "tm",colour = G.C.UI.TRANSPARENT_DARK, r = 0.1 },
    nodes = {
      { n = G.UIT.R, config = {align = "rt"}, nodes = {
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.1,
          }, nodes = {
            {n = G.UIT.T, config = {
              text = localize("k_akyrs_wildcard_behaviour_txt"),
              scale = 0.4,
              colour = G.C.UI.TEXT_LIGHT
            }}
            }
          },          
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.1,
            id = "akyrs_wildcard_behaviour_desc_dyna"
          }, nodes = {
              create_option_cycle({
                options = localize('k_akyrs_wildcard_behaviours'),
                scale = 0.7,
                w = 4.5,
                current_option = AKYRS.config.wildcard_behaviour,
                opt_callback = "akyrs_change_wildcard_behaviour",
                ref_table = AKYRS.config,
                ref_value = "wildcard_behaviour"

              })
            }
          },
          AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_wildcard_behaviour_1", func = "akyrs_update_wildcard_tooltip" }
        },
      },
      -- wildcard description
      -- balance
      not MP and { n = G.UIT.R, config = {align = "rt"}, nodes = {
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.1,
          }, nodes = {
            {n = G.UIT.T, config = {
              text = localize("k_akyrs_config_balance_txt"),
              scale = 0.4,
              colour = G.C.UI.TEXT_LIGHT
            }}
            }
          },          
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.1,
            id = "akyrs_wildcard_behaviour_desc_dyna"
          }, nodes = {
              create_option_cycle({
                options = localize('k_akyrs_balance_selects' .. (not Talisman and "_no_talisman" or "")),
                scale = 0.7,
                w = 4.5,
                current_option = AKYRS.balance_map[G.PROFILES[G.SETTINGS.profile].akyrs_balance],
                opt_callback = "akyrs_change_balance_toggle",
                ref_table = G.PROFILES[G.SETTINGS.profile],
                ref_value = "akyrs_balance"

              })
            }
          },
          AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_balance_settings" }
        } 
      },
      -- joker previews
      
      { n = G.UIT.R, config = { align = "rt"}, nodes = {
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.05,
          }, nodes = {
            
            create_toggle({
              label = localize("k_akyrs_card_preview"),
              ref_table = AKYRS.config,
              ref_value = "show_joker_preview",
              label_scale = 0.4,
              callback = G.FUNCS.akyrs_change_joker_preview_stuff
            })
            }
          },
          
          AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_card_preview_tooltip" }
        } 
      },

      { n = G.UIT.R, config = { align = "rt"}, nodes = {
        { n = G.UIT.C, config = {
            align = "cm", padding = 0.05,
        }, nodes = {
          
          create_toggle({
            label = localize("k_akyrs_toggle_crt"),
            ref_table = AKYRS.config,
            ref_value = "turn_on_crt",
            label_scale = 0.4,
            callback = G.FUNCS.akyrs_change_crt_toggle
          })
          }
        },
        AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_crt_shader_toggle" }
        } 
      },
      { n = G.UIT.R, config = { align = "rt"}, nodes = {
        { n = G.UIT.C, config = {
            align = "cm", padding = 0.05,
        }, nodes = {
          
          create_toggle({
            label = localize("k_akyrs_toggle_full_dictionary"),
            ref_table = AKYRS.config,
            ref_value = "full_dictionary",
            label_scale = 0.4,
            callback = G.FUNCS.save_config
          })
          }
        },
        AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_full_dictionary" }
        } 
      },
      { n = G.UIT.R, config = { align = "rt"}, nodes = {
        { n = G.UIT.C, config = {
            align = "cm", padding = 0.05,
        }, nodes = {
          
          create_toggle({
            label = localize("k_akyrs_toggle_colourblind_ui"),
            ref_table = AKYRS.config,
            ref_value = "colourblind_ui",
            label_scale = 0.4,
            callback = G.FUNCS.save_config
          })
          }
        },
        AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_toggle_colourblind_ui" }
        } 
      },
      { n = G.UIT.R, config = { align = "rt"}, nodes = {
        { n = G.UIT.C, config = {
            align = "cm", padding = 0.05,
        }, nodes = {
          
          create_toggle({
            label = localize("k_akyrs_toggle_experimental_feature"),
            ref_table = AKYRS.config,
            ref_value = "experimental_features",
            label_scale = 0.4,
            callback = G.FUNCS.save_config
          })
          }
        },
        AKYRS.create_hover_tooltip{ tooltip_key = "dd_akyrs_experimental_feature" }
        } 
      },
      {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.2 },
        nodes = {
          { n = G.UIT.T, config = { text = localize("k_akyrs_restart_required"), scale = 0.4, colour = G.C.UI.TEXT_INACTIVE } }
        }
      },
    }
  }
end


SMODS.current_mod.menu_cards = function ()
    return {
		{key = 'j_akyrs_aikoyori'},
        func = function() 
            local mycards = AKYRS.filter_table(G.title_top.cards, function (c,i)
                --print(c.config.center_key)
                return c.config.center_key == "j_akyrs_aikoyori" end,true,true)
            local mecardonlyone = mycards[1]
            if mecardonlyone then
                --- @Card
                mecardonlyone = mecardonlyone
                if AKYRS.is_mod_loaded("Entropy") then
                    mecardonlyone:set_edition("e_entr_freaky")
                end
                mecardonlyone.click = AKYRS.aiko_click
                mecardonlyone.bypass_discovery_center = true
            end
        end
	}
end

AKYRS.mod_name_alts = {
  "Aikoyori's Shenanigans",
  "Aikoyori's Shinigimas",
  "Aikoshen",
  "The Shenanigans of Aikoyori",
  "mr shenanigans' aikoyori",
  "Aikoyori's Jokers",
  "AKYRS",
  "Aikomod",
  "New Super Aikoyori Shenanigans",
  "An Aikoyori Mod",
  "Shenaiko",
  "Aikoslop Shenfoid",
  "Shenanigan Aikoyori's",
  "Steal the Aikoshen", 
  "Aikoyori the Movie: The Game: The Mod",
  "iroyokia's playbook real",
  "aish",
  "The Wacky and Wonderous Shenanigans in the world of Aikoyori",
  "Solitaireyori Wordlenanigans",
}
AKYRS.mod_flavour_text = {
  {"now with 1000% more aliases!",},
  {"now with 100% more freedom!",},
  {"please don't play hardcore challenges",},
  {"acknowledged by localthunk",},
  {"my wife left me...",},
  {"luigi wouldn't have done this",},
  {"also use Pissandshittium",},
  {"also use MyPayIndia",},
  {"What's 9 + 10?",},
  {"also try Phanta",},
  {"also try Finity",},
  {"also try Hot Potato",},
  {"also try Stocking Stuffer",},
  {"also try Feli's Jokeria",},
  {"also try Cold Beans...?",},
  {"also try Paya's Terrible Additions",},
  {"also try Entropy",},
  {"also try Revo's Vault",},
  {"You were used up.",},
  {"どうしてこんな目に　に　に", font = G.FONTS[5]},
  {"限界まで足掻いた人生は　想像よりも狂っているらしい", font = G.FONTS[5]},
  {"スーパーアイドルの笑顔よりも　あの八月の午後よりも", font = G.FONTS[5]},
  {"105℃のより光る君へ", font = G.FONTS[5]},
  {"Not to get political but what the fuck is an oatmeal",},
  {"In Alpha for a year!",},
  {"Blindmaxxing Consumablepilled",},
  {"Did you do your Wordle today?",},
  {"Gamified Video",},
  {"Cryptid got nothing on me",},
  {"keys cow",},
  {"Did you know that I can absolutely put anything here?",},
  {"Imagine doing all of this and then have a mod crash lol",},
  {"Don't divide by 0!",},
  {"Probably a great tool for STEM!",},
  {"^2 Fun when played",},
  {"#StopAIslop",},
  {"#StopGenAIinVocaloid",},
  {"Art by real artists!",},
  {"& Knuckles",},
  {"New Funky Mode",},
  {"featuring Dante from DMC",},
  {"it sure happened",},
  {"Will not appear in Deltarune",},
  {"(??)",},
  {"#BringBackWotakuSnooze",},
  {"Driving in my car, right after a beer",},
  {"*freedom motif*",},
  {"You can't find your hands.",},
}