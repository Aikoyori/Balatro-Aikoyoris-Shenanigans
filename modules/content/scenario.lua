SMODS.ConsumableType{
    key = "Scenario",
    primary_colour = HEX("5D8956FF"),
    secondary_colour = HEX("FF5887BD"),
    collection_rows = { 5,5,5 },
    shop_rate = 0,
    default = "c_akyrs_replicant_music_streaming"
}

for i = 0, 2 do
    for j = 0, 14 do
        SMODS.Consumable {
            key = "scenario_"..i.."_"..j,
            set = "Scenario",
            atlas = "scenarioCards",
            pos = { x = j, y = i },
            config = {
                extras = 2,
            },
        }
    end
end