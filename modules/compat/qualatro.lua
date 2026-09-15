if AKYRS.is_mod_loaded("Qualatro") then
    

    SMODS.Sound({
        key = "layer_aikoyori",
        path = "layer_aikoyori.ogg",
        pitch = 1,
    })

    function AKYRS.qualatro_add_sounds(tabler)
        tabler["j_akyrs_aikoyori"] = SMODS.Sounds["akyrs_layer_aikoyori"].sound_code
    end
end