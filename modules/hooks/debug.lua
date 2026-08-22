-- this file focuses on hooks i used to debug

local debugKeysNShit = Controller.key_press_update
function Controller:key_press_update(key, dt)
    local c = debugKeysNShit(self, key, dt)
    local _card = self.hovering.target
    if not _RELEASE_MODE and _card then
        if key == ',' then
            if _card.playing_card then
                _card:set_letters(AKYRS.alphabet_delta(_card.ability.aikoyori_letters_stickers, -1))
            end
        end
        if key == '.' then
            if _card.playing_card then
                _card:set_letters(AKYRS.alphabet_delta(_card.ability.aikoyori_letters_stickers, 1))
            end
        end
        if key == ";" then
            if (_card and _card.ability) then
                _card.ability.akyrs_self_destructs = not not not _card.ability.akyrs_self_destructs
            end
        end
    end
    return c
end

-- ty ivy
if not _RELEASE_MODE then
    SMODS.Keybind {
        key = "itdoesntfuckingmatter",
        key_pressed = "\\",
        action = function()
            for _, v in pairs(SMODS.Mods) do
                if v.can_load and v.path then
                    SMODS.handle_loc_file(v.path)
                end
            end
            return init_localization()
        end
    }
end