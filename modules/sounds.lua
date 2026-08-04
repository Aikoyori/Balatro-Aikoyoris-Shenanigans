SMODS.Sound({
    key = "letter_booster_pack_music",
    path = "letterPack.ogg",
    sync = {
        ['music1'] = true,
        ['music2'] = true,
        ['music3'] = true,
        ['music4'] = true,
        ['music5'] = true,
        ['akyrs_umbral_booster_pack_music'] = true,
    },
    select_music_track = function(self) 
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'letter_pack' and 100 or nil
    end    
})
SMODS.Sound({
    key = "umbral_booster_pack_music",
    path = "umbralpack.ogg",
    sync = {
        ['music1'] = true,
        ['music2'] = true,
        ['music3'] = true,
        ['music4'] = true,
        ['music5'] = true,
        ['akyrs_letter_booster_pack_music'] = true,
    },
    select_music_track = function(self) 
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'umbral_pack' and 100 or nil
    end    
})

SMODS.Sound({
    key = "noire_sfx",
    path = "noire.ogg",
    
})

SMODS.Sound({
    key = "texelated_sfx",
    path = "texelated.ogg",
})

SMODS.Sound({
    key = "sliced_sfx",
    path = "sliced.ogg",
})

SMODS.Sound({
    key = "burnt_sfx",
    path = "burnt.ogg",
})

SMODS.Sound({
    key = "enchant1",
    path = "enchant/enchant1.ogg",
})
SMODS.Sound({
    key = "enchant2",
    path = "enchant/enchant2.ogg",
})
SMODS.Sound({
    key = "enchant3",
    path = "enchant/enchant3.ogg",
})

SMODS.Sound({
    key = "loud_incorrect_buzzer",
    path = "loudbuzzer.ogg",
})

SMODS.Sound({
    key = "piano",
    path = "piano.ogg",
})

SMODS.Sound({
    key = "don",
    path = "don.ogg",
})

SMODS.Sound({
    key = "katsu",
    path = "katsu.ogg",
})

SMODS.Sound({
    key = "xscore",
    path = "xscore.ogg",
})

SMODS.Sound({
    key = "charged",
    path = "charged.ogg",
})

-- hook to play randomized sounds 
local plsnd = play_sound
function play_sound(snd, per, vol)
    if snd == "akyrs_enchanted" then
        snd = pseudorandom_element({"akyrs_enchant1","akyrs_enchant2","akyrs_enchant3",},pseudoseed("akyrs_enchanted_sound"))
    end
    return plsnd(snd, per, vol)
end


SMODS.Sound({
    key = "layer_aikoyori",
    path = "layer_aikoyori.ogg",
    pitch = 1,
})
