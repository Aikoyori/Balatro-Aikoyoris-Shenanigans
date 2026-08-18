AKPOP = SMODS.current_mod
AKPOP.meta_mod = true
AKPOP.hide_in_menu = true
AKPOP.aikoshen_loaded = false
AKPOP.aikoshen_is_dev_ver = false
AKPOP.aikoshen = SMODS.Mods.aikoyorisshenanigans

if AKPOP.aikoshen then
    print("Aikoyori's Shenanigans version "..AKPOP.aikoshen.version)
    if not AKPOP.aikoshen.can_load then
        print("Aikoyori's Shenanigans cannot load!")
    else
        AKPOP.aikoshen_loaded = true
    end
    if AKPOP.aikoshen.version:find("-dev") then
        print("Dev version detected! You're on your own.")
        AKPOP.aikoshen_is_dev_ver = true
    end
end

G.FUNCS.akpop_open_link = function(e)
    love.system.openURL( e.config.ref_table[1] )
end
G.FUNCS.akpop_open_mods_folder = function(e)
    local platform = love.system.getOS()
    if platform == "Linux" then
        os.execute("xdg-open \""..SMODS.MODS_DIR.."\"")
    elseif platform == "OS X" then
        -- this is purely for opening mods dir
        os.execute("open \""..SMODS.MODS_DIR.."\"")
    else
        love.system.openURL( SMODS.MODS_DIR )
    end
end
G.FUNCS.akpop_can_open_mods_folder = function(e)
    local platform = love.system.getOS()
    local can = true
    if platform == "Android" or platform == "iOS" then
        can = false
    end
    if can then
        e.config.button = 'akpop_open_mods_folder'
        e.config.colour = G.C.RED
    else
        e.config.button = nil
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
    end
end

local smods_loc_hook = SMODS.load_mod_localization
function SMODS.load_mod_localization(paz, modid, depth)

    local is_pop_in = false
    if modid == '_' and (depth or 0) < 1 then
        for k, v in ipairs(SMODS.mod_list) do
            if v.id == AKPOP.id then
                is_pop_in = true
                break
            end
        end
        -- print(is_pop_in and "exist" or "not exist")
        if not is_pop_in then
            -- print("added")
            SMODS.mod_list[#SMODS.mod_list+1] = AKPOP
        end
    end

    local returnx = {smods_loc_hook(paz, modid, depth)}

    if modid == AKPOP.id and (depth or 0) < 1 then
        for k, v in ipairs(SMODS.mod_list) do
            if v.id == AKPOP.id then
                -- print("found pop, removing")
                table.remove(SMODS.mod_list, k)
            end
        end
    end


    return unpack(returnx)
    
end


local gmainmenuhook = Game.main_menu
function Game:main_menu(chctx)
    if not AKPOP.aikoshen_loaded then
        local uinodes = {}
        local uinodes_text = {}
        local key = "akpop_warning_stable_outdated_smods"
        local key_btn = "k_akpop_download_smods"
        if AKPOP.aikoshen_is_dev_ver then
            key = "akpop_warning_dev_mod_version"
            key_btn = "k_akpop_download_aikoshen"
        end
        localize{type = "descriptions", key = key, set = "Other", default_col = G.C.WHITE, nodes = uinodes, vars = {}, scale = 2}
        localize{type = "name", key = key, set = "Other", default_col = G.C.WHITE, nodes = uinodes_text, vars = {}, scale = 2}
        G.E_MANAGER:add_event(
            Event{
                trigger = "after",
                delay = 0.1,
                func = function ()
                    G.FUNCS.overlay_menu{
                        definition = create_UIBox_generic_options({
                            contents = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "cr" },
                                    nodes = {
                                        UIBox_button({
                                            label = { "x" },
                                            minw = 0.5,
                                            minh = 0.5,
                                        }),
                                    },
                                },
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm" },
                                    nodes = {transparent_multiline_text(uinodes_text)},
                                },
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm" },
                                    nodes = {transparent_multiline_text(uinodes)},
                                },
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm", padding = 0.1 },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm" },
                                            nodes = {
                                                UIBox_button({
                                                    label = { localize(key_btn) },
                                                    button = 'akpop_open_link',
                                                    shadow = 0,
                                                    minw = 8,
                                                    colour = G.C.DARK_EDITION,
                                                    ref_table = {
                                                        AKPOP.aikoshen_is_dev_ver and
                                                        "https://github.com/Aikoyori/Balatro-Aikoyoris-Shenanigans/releases/latest" or
                                                        "https://github.com/Steamodded/smods/releases/latest"
                                                    }
                                                }),
                                            },
                                        },
                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm" },
                                            nodes = {
                                                UIBox_button({
                                                    label = { localize("k_akpop_open_mod_dir") },
                                                    button = 'akpop_open_mods_folder',
                                                    func = 'akpop_can_open_mods_folder',
                                                    minw = 4,
                                                }),
                                            },
                                        },
                                    },
                                },
                            },
                            no_back = true,
                        }),
                        config = {
                            no_esc = true,
                        }
                    }
                    return true
                end,
            }
        )
    end
    return gmainmenuhook(self,chctx)
end