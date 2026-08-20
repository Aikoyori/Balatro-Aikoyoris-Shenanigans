AKYRS = SMODS.current_mod

-- i love jonh debugpkus
assert(SMODS.current_mod.lovely, "Lovely patches were not loaded.\nMake sure your mod folder is not nested (there should be a bunch of files in the mod folder and not just another folder).")

assert(SMODS.load_file("./modules/pre.lua"))()
assert(SMODS.load_file("./modules/atlasses.lua"))()
assert(SMODS.load_file("./modules/colours.lua"))()
assert(SMODS.load_file("./modules/fonts.lua"))()
--assert(SMODS.load_file("./func/numbers.lua"))()
if AKYRS.config.full_dictionary then
    assert(SMODS.load_file("./func/words/words.lua"))()
    assert(SMODS.load_file("./func/words/bomb_prompts.lua"))()
else
    assert(SMODS.load_file("./func/words/words_reduced.lua"))()
    assert(SMODS.load_file("./func/words/bomb_prompts_reduced.lua"))()
end
assert(SMODS.load_file("./func/words/puzzle_words.lua"))()
assert(SMODS.load_file("./func/word_utils.lua"))()

assert(SMODS.load_file("./modules/content/vanilla_override.lua"))()
assert(SMODS.load_file("./modules/utils/misc.lua"))()
assert(SMODS.load_file("./modules/utils/utils_mod.lua"))()
assert(SMODS.load_file("./modules/utils/value_replacement.lua"))()
assert(SMODS.load_file("./modules/custom_minigames/solitaire_card_type.lua"))()
assert(SMODS.load_file("./modules/hooks/general.lua"))() -- misc hook
assert(SMODS.load_file("./modules/hooks/card.lua"))() -- misc hook
assert(SMODS.load_file("./modules/hooks/letter.lua"))() -- for letter & null cards mechanics
assert(SMODS.load_file("./modules/hooks/scoring.lua"))() -- pure scoring
assert(SMODS.load_file("./modules/hooks/debug.lua"))() -- debug
assert(SMODS.load_file("./modules/hooks/ui.lua"))() -- uir
assert(SMODS.load_file("./modules/hooks/new_hooking_stuff.lua"))()

assert(SMODS.load_file("./modules/sounds.lua"))()
assert(SMODS.load_file("./modules/desc.lua"))()
assert(SMODS.load_file("./modules/pseudocard.lua"))()

assert(SMODS.load_file("./modules/custom_minigames/solitaire.lua"))() -- solitaire boss
assert(SMODS.load_file("./modules/custom_minigames/solitaire_ui.lua"))()

assert(SMODS.load_file("./modules/mod_props.lua"))()
assert(SMODS.load_file("./modules/api_impl.lua"))()
assert(SMODS.load_file("./modules/api.lua"))()
assert(SMODS.load_file("./modules/draw_step.lua"))()
assert(SMODS.load_file("./modules/card_attrib.lua"))()
assert(SMODS.load_file("./modules/scoring_params.lua"))()
assert(SMODS.load_file("./modules/fake_center.lua"))()


assert(SMODS.load_file("./modules/content/back.lua"))()
assert(SMODS.load_file("./modules/content/rarity.lua"))()
assert(SMODS.load_file("./modules/content/alphabet_cards.lua"))()
assert(SMODS.load_file("./modules/content/umbral.lua"))()
assert(SMODS.load_file("./modules/content/replicancy.lua"))()
assert(SMODS.load_file("./modules/content/planets.lua"))()
assert(SMODS.load_file("./modules/content/constellation.lua"))()
assert(SMODS.load_file("./modules/content/boosters.lua"))()
assert(SMODS.load_file("./modules/content/seals.lua"))()
assert(SMODS.load_file("./modules/content/stickers.lua"))()
assert(SMODS.load_file("./modules/content/blinds.lua"))()
assert(SMODS.load_file("./modules/content/stakes.lua"))()
assert(SMODS.load_file("./modules/content/cards.lua"))()
assert(SMODS.load_file("./modules/content/life.lua"))()
assert(SMODS.load_file("./modules/content/enchantments.lua"))()
assert(SMODS.load_file("./modules/content/vouchers.lua"))()
assert(SMODS.load_file("./modules/content/bets.lua"))()
assert(SMODS.load_file("./modules/content/scenario.lua"))()

assert(SMODS.load_file("./modules/content/edition.lua"))()
assert(SMODS.load_file("./modules/content/tags.lua"))()
assert(SMODS.load_file("./modules/ui.lua"))()
if AKYRS.config.experimental_features then
    assert(SMODS.load_file("./modules/content/trades.lua"))()
end
assert(SMODS.load_file("./modules/challenges_ui.lua"))()
assert(SMODS.load_file("./modules/content/jokers.lua"))()
assert(SMODS.load_file("./modules/content/letterjokers.lua"))()
assert(SMODS.load_file("./modules/content/legendaries.lua"))()
assert(SMODS.load_file("./modules/content/achievements.lua"))()

assert(SMODS.load_file("./modules/content/challenges.lua"))()
assert(SMODS.load_file("./modules/content/pokerhands.lua"))()

assert(SMODS.load_file("./modules/compat/malverk.lua"))()
assert(SMODS.load_file("./modules/compat/cryptid.lua"))()
assert(SMODS.load_file("./modules/compat/entropy.lua"))()
assert(SMODS.load_file("./modules/compat/sleeves.lua"))()
assert(SMODS.load_file("./modules/compat/talisman.lua"))()
assert(SMODS.load_file("./modules/compat/jokerdisplay.lua"))()
assert(SMODS.load_file("./modules/compat/cartomancer.lua"))()
assert(SMODS.load_file("./modules/compat/notjustyet.lua"))()
assert(SMODS.load_file("./modules/compat/togasstuff.lua"))()
assert(SMODS.load_file("./modules/compat/partner.lua"))()
assert(SMODS.load_file("./modules/compat/ortalab.lua"))()
assert(SMODS.load_file("./modules/compat/paperback.lua"))()
assert(SMODS.load_file("./modules/compat/qualatro.lua"))()
assert(SMODS.load_file("./modules/compat/multiplayer.lua"))()
assert(SMODS.load_file("./modules/compat/multiplayerspeedrun.lua"))()
assert(SMODS.load_file("./modules/compat/blindside.lua"))()
assert(SMODS.load_file("./modules/compat/tmj.lua"))()


assert(SMODS.load_file("./modules/attribs.lua"))()

-- cross mod loading
for _,mod in pairs(SMODS.Mods) do
    if mod.can_load and mod.path and not mod.meta_mod then
        pcall(function ()
            local p = SMODS.load_file("AikoyorisShenanigans.lua", mod.id)
            if p then
                local ret = p()
                if p.dingling_object then
                    G._RUN_HOOK(p) -- game functions
                end
            end
        end)
    end

end

