

local poker_hand_desc = {}
local poker_hands_name = {}
for i = 3, 45 do
    poker_hand_desc["akyrs_"..i.."-letter Word"] = {
        "Create a valid "..i.."-letter English word",
        "without extra letters"
    }
    poker_hands_name["akyrs_"..i.."-letter Word"] = i.."-letter Word"
end


local aiko_alphabets_no_wilds = {}
for i = 97, 122 do
    table.insert(aiko_alphabets_no_wilds, string.char(i))
end
local word_letter = {
    "Apple", "Bee", "Cat", "Dog", "Earth", "Fire", "Ghost", "Hat", "Ice", "Jar", 
    "Kite", "Lemon", "Mushroom", "Night", "Onion", "Pie", "Quill", "Rat", "Spoon", "Tea", 
    "Umbrella", "Vase", "Water", "Xylophone", "Yarn", "Zoom"
}
local alphabets_cards_loc = {}

for k, v in ipairs(aiko_alphabets_no_wilds) do
    local upper = string.upper(v)
    alphabets_cards_loc["c_akyrs_alphabet_"..v] = {
        name = upper.." for "..word_letter[k],
        text = { "Convert all selected cards'","letter to {C:red}#1#{}"},
    }
end 

alphabets_cards_loc["c_akyrs_alphabet_wild"] = {
    name = "#",
    text = { "Convert up to #2# selected card's","letter to {C:red}Wild (#1#){}" },
}

poker_hands_name["akyrs_Word Hand"] = "Word Hand"
poker_hand_desc["akyrs_Word Hand"] = {'Play a valid dictionary word'}

poker_hands_name["akyrs_expression"] = "Expression"
poker_hand_desc["akyrs_expression"] = {'Create a valid mathematical expression'}

poker_hands_name["akyrs_modification"] = "Modification"
poker_hand_desc["akyrs_modification"] = {'Modify current chip value'}

poker_hands_name["akyrs_assignment"] = "Assignment"
poker_hand_desc["akyrs_assignment"] = {'Assign a value to a variable'}

poker_hands_name["akyrs_tripair"] = "Tripair"
poker_hand_desc["akyrs_tripair"] = {'Three sets of Pairs of different ranks'}

poker_hands_name["akyrs_triplush"] = "Triplush"
poker_hand_desc["akyrs_triplush"] = {'Three sets of Pairs of different ranks','that also contains a Flush'}

poker_hands_name["akyrs_twintriple"] = "Twin Triple"
poker_hand_desc["akyrs_twintriple"] = {'Two sets of Three of a Kind'}

poker_hands_name["akyrs_twinflupple"] = "Twin Flupple"
poker_hand_desc["akyrs_twinflupple"] = {'Twin Triple that also contains a Flush'}

poker_hands_name["akyrs_twinflush"] = "Twin Flush"
poker_hand_desc["akyrs_twinflush"] = {'Two sets of Flushes'}

poker_hands_name["akyrs_flushbung"] = "Flushbung"
poker_hand_desc["akyrs_flushbung"] = {'A double-sized Flush'}

poker_hands_name["akyrs_twinstraight"] = "Twin Straight"
poker_hand_desc["akyrs_twinstraight"] = {'Two sets of Straights', 'with no duplicating ranks'}

poker_hands_name["akyrs_direstraight"] = "Dire Straight"
poker_hand_desc["akyrs_direstraight"] = {'Straight with at least double the length'}

poker_hands_name["akyrs_twinstraightflush"] = "Twin Straight Flush"
poker_hand_desc["akyrs_twinstraightflush"] = {'Two sets of Straights and Flush', 'with no duplicating ranks'}

return {
    descriptions = {
        Alphabet = alphabets_cards_loc,
        Back={
            b_akyrs_letter_deck = {
                name = 'Letter Deck',
                text = 
                { 
                    'Letters-Only Deck',
                    "Letters give {C:mult}Mult{}", 
                    "{C:red}X#1#{} base Blind Size",
                    "{C:red}+#2#{} Discards",
                    "{C:attention}+#3#{} Hand Size",
                },
            },
            b_akyrs_math_deck = {
                name = 'Math Deck',
                text = { 'Make Maths Expressions',
                'Get within {C:red,f:6}±{C:red}#1#%{}',
                'of the Blind Requirements',
                'Gain {C:akyrs_playable}+#3#{} selection per Ante',
                },
            },
            b_akyrs_hardcore_challenges={
                name="Hardcore Challenge Deck",
                text={
                    "",
                },
            },
            b_akyrs_scuffed_misprint={
                name="Scuffed Misprint Deck",
				text = {
					"Values of most cards",
					"are {C:attention}randomized{}",
                    "{C:inactive}(From X#1# to X#2#)",
                    "me vs the guy she tells you not to worry about"
				},
            },
            b_akyrs_freedom={
                name="Freedom Deck",
				text = {
					"You can drag cards",
					"to place them anywhere.",
				},
            },
            b_akyrs_ultimate_freedom={
                name="Ultimate Freedom Deck",
				text = {
					"You can drag {E:1,C:attention}any{} cards",
					"to place them anywhere.",
				},
            },
            b_akyrs_split_deck={
                name="Split Deck",
				text = {
					"Start with all cards",
                    "{C:attention}split{} in half",
                    "{C:red}+#1#{} Discard"
				},
            },
            b_akyrs_ranking_deck={
                name="Ranking Deck",
				text = {
					"Start with {C:attention}no suit",
                    "{C:red}X#1#{} blind size",
				},
            },
            b_akyrs_suitable_deck={
                name="Suitable Deck",
				text = {
					"Start with {C:attention}no ranks",
                    "{C:red}X#1#{} blind size",
				},
            },
            b_akyrs_inversion_deck={
                name="Inversion Deck",
				text = {
					"Card selection is {C:attention}inverted",
				},
            },
            b_akyrs_down_deck={
                name="Down Deck",
				text = {
					"{C:attention}+#1#{} Joker Slots",
					"All Jokers are {C:attention}flipped face down{}",
                    "before purchase",
				},
            },
            b_akyrs_cry_misprint_ultima={
                name="Ultima Misprint Deck",
				text = {
					"Values of cards",
					"and poker hands",
					"are {C:attention}randomized{}",
                    "{C:inactive}(From X#1# to X#2#)",
                    "The challenge is to not crash the game."
				},
            },
            b_akyrs_mega_letter_deck = {
                name = 'Mega Letter Deck',
                text = 
                { 
                    'Letter Deck',
                    "but {C:attention}+#3#{} Hand Size", 
                    "you only have {C:red}1 hand{}",
                    "{C:red}X#1#{} base Blind Size",
                },
            },
            b_akyrs_developer_deck = {
                name = 'Developer Deck',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_prism_deck = {
                name = 'Prism Deck',
                text = 
                { 
                    'Start with {X:dark_edition,C:white}#1#{} Life',
                    'with {C:red,E:1}heavier{} punishments',
                    'Life {C:red}does not{} replenish',
                    '{C:dark_edition}+#2#{} Joker Slot',
                    '{C:dark_edition}+#3#{} Consumable Slot',
                },
            },
            b_akyrs_kaleidoscopic_deck = {
                name = 'Kaleidoscopic Deck',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_sheared_deck = {
                name = 'Deck of the Sheared',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_vision_deck = {
                name = 'Deck of the Vision',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_animosity_deck = {
                name = 'Deck of the Animosity',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_weaver_deck = {
                name = 'Deck of the Weaver',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_puppet_deck = {
                name = 'Deck of the Puppets',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_shining_deck = {
                name = 'Deck of the Shining',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_dotted_deck = {
                name = 'Dotted Deck',
                text = 
                { 
                    --[[
                    'Lose {C:blue}Hands{} and {C:red}Discards{}',
                    'but gain the other upon action',
                    'Lose immediately if you have',
                    'less than 1 {C:blue}Hand{}',
                    'Cards that are drawn twice in',
                    'the round are {C:red,E:akyrs_shrivel}destroyed{}',
                    ]]
                    '{C:blue}Hands{} and {C:red}Discards{}',
                    'are {C:attention}traded',
                },
            },
            b_akyrs_flora_deck = {
                name = 'Flora Deck',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_discord_deck = {
                name = 'Discord Deck',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_nitro_deck = {
                name = 'Nitro Deck',
                text = 
                { 
                    '{C:red,s:1.5,E:akyrs_shrivel}WIP{}',
                },
            },
            b_akyrs_judge_deck = {
                name = 'Judge Deck',
                text = 
                { 
                    'Start with {X:green,C:white}#1#{} Life',
                    '{X:green,C:white}+#2#{} Life per round',
                    '{C:dark_edition}+#3#{} Joker Slot',
                },
            },
        },
        Blind={
            bl_akyrs_the_thought= {
                name = "The Thought",
                text = {
                    "Solve 5-letter puzzle to win!",
                }
            },
            bl_akyrs_the_libre= {
                name = "The Libre",
                text = {
                    "Disabling this boss",
                    "Sets Blind Req. to #1#",
                }
            },
            bl_akyrs_the_picker= {
                name = "The Picker",
                text = {
                    "X#2# Score Requirement when you",
                    "change the given card selection",
                }
            },
            bl_akyrs_the_height= {
                name = "The Height",
                text = {
                    "Score Requirement becomes X#1#",
                    "your round score on non-final hands",
                }
            },
            bl_akyrs_the_expiry= {
                name = "The Expiry",
                text = {
                    "All consumables are",
                    "permanently debuffed",
                }
            },
            bl_akyrs_the_nature= {
                name = "The Nature",
                text = {
                    "Face cards (both held and played)",
                    "give X#1# Mult each",
                }
            },
            bl_akyrs_the_key= {
                name = "The Key",
                text = {
                    "Played cards have a #1# in #2#",
                    "chance to be forever selected",
                }
            },
            bl_akyrs_the_alignment= {
                name = "The Alignment",
                text = {
                    "First and last played cards",
                    "will not score",
                }
            },
            bl_akyrs_the_duality= {
                name = "The Duality",
                text = {
                    "First and last played cards",
                    "are debuffed",
                }
            },
            bl_akyrs_the_collapse= {
                name = "The Collapse",
                text = {
                    "Money cannot change during the round",
                }
            },
            bl_akyrs_the_bonsai= {
                name = "The Bonsai",
                text = {
                    "Face cards have #1# in #2# chance",
                    "to not score",
                }
            },
            bl_akyrs_the_base= {
                name = "The Base",
                text = {
                    "No retriggers",
                }
            },
            bl_akyrs_final_periwinkle_pinecone= {
                name = "Periwinkle Pinecone",
                text = {
                    "Shuffle remaining cards",
                    "and draw to hand after hand played",
                }
            },
            bl_akyrs_final_razzle_raindrop = {
                name = "Razzle Raindrop",
                text = {
                    "Discard held in hand cards",
                    "per unique suits played",
                }
            },
            bl_akyrs_final_velvet_vapour = {
                name = "Velvet Vapour",
                text = {
                    "#1# in #2# chance for each card",
                    "with the same rank as first",
                    "played card to be discarded",
                }
            },
            bl_akyrs_final_chamomile_cloud = {
                name = "Chamomile Cloud",
                text = {
                    "Discard all cards with",
                    "a random suit every hand drawn",
                }
            },
            bl_akyrs_final_salient_stream = {
                name = "Salient Stream",
                text = {
                    "Must alternate between",
                    "Play and Discard",
                }
            },
            bl_akyrs_final_luminous_lemonade = {
                name = "Luminous Lemonade",
                text = {
                    "Non-final Hands",
                    "will not score",
                }
            },
            bl_akyrs_final_glorious_glaive = {
                name = "Glorious Glaive",
                text = {
                    "X#1# Score per card played",
                }
            },
            bl_akyrs_final_lilac_lasso = {
                name = "Lilac Lasso",
                text = {
                    "All but #1# Jokers randomly",
                    "debuffed every hand",
                }
            },
            bl_akyrs_forgotten_weights_of_the_past = {
                name = "Weights of the Past",
                text = {
                    "X#1# Ante per Card scored",
                }
            },
            bl_akyrs_forgotten_prospects_of_the_future = {
                name = "Prospects of the Future",
                text = {
                    "+#1# Ante per Card held in hand",
                }
            },
            bl_akyrs_forgotten_uncertainties_of_life = {
                name = "Uncertainties of Life",
                text = {
                    "-#1# hand size permanently after hand played",
                }
            },
            bl_akyrs_forgotten_inevitability_of_death = {
                name = "Inevitability of Death",
                text = {
                    "Lose money at the end of the round",
                    "By Final Score divided by Blind Requirement"
                }
            },
            bl_akyrs_expert_confrontation = {
                name = "Confrontation",
                text = {
                    "Hand must include face cards",
                }
            },
            bl_akyrs_expert_fluctuation = {
                name = "Fluctuation",
                text = {
                    "Randomly multiply score by",
                    "between #1# and #2# before hand played",
                }
            },
            bl_akyrs_expert_straightforwardness = {
                name = "Straightforwardness",
                text = {
                    "All Hands starts with",
                    "#1#% base Chip and #2#% base Mult",
                }
            },
            bl_akyrs_expert_entanglement = {
                name = "Entanglement",
                text = {
                    "All but one cards from each suit",
                    "are drawn face down",
                }
            },
            bl_akyrs_expert_manuscript = {
                name = "Manuscript",
                text = {
                    "Lose money per hand equal to",
                    "played Poker Hand's Base Mult",
                }
            },
            bl_akyrs_expert_inflation = {
                name = "Inflation",
                text = {
                    "Absurdly large blind",
                }
            },
            bl_akyrs_the_choice = {
                name = "The Choice",
                text = {
                    "Played words must contain '#1#'",
                }
            },
            bl_akyrs_the_reject = {
                name = "The Reject",
                text = {
                    "Played words must not contain '#1#'",
                }
            },
            bl_akyrs_the_redo = {
                name = "The Redo",
                text = {
                    "Played words must not contain letter",
                    "from last played words this Blind",
                }
            },
            bl_akyrs_the_reverse = {
                name = "The Reverse",
                text = {
                    "Words must be played in reverse",
                }
            },
            bl_akyrs_master_faraway_island = {
                name = "Faraway Island",
                text = {
                    "Hand must contain at least",
                    "one card without suit or rank",
                }
            },
            bl_akyrs_master_plywood_forest = {
                name = "Plywood Forest",
                text = {
                    "All cards held in hand",
                    "are destroyed after hand scores"
                }
            },
            bl_akyrs_master_golden_jade = {
                name = "Golden Jade",
                text = {
                    "X#1# your money per card scored",
                }
            },
            bl_akyrs_master_milk_crown_on_sonnetica = {
                name = "Milk Crown on Sonnetica",
                text = {
                    "X#1# Score when a face card scores",
                }
            },
            bl_akyrs_master_bug = {
                name = "BUG",
                text = {
                    "One random Joker destroyed",
                    "after hand scores"
                }
            },
            bl_akyrs_the_bomb= {
                name = "The Bomb",
                text = {
                    "Defuse the bomb!",
                }
            },
            bl_akyrs_the_stomata= {
                name = "The Stomata",
                text = {
                    "-$1 per Face Card Scored",
                }
            },
            bl_akyrs_the_rhizome= {
                name = "The Rhizome",
                text = {
                    "#1#X blind size when",
                    "repeating already played hands",
                }
            },
            bl_akyrs_the_shrink= {
                name = "The Shrink",
                text = {
                    "#1#X blind size every",
                    "unique hand played",
                }
            },
            bl_akyrs_the_harmonic= {
                name = "The Harmonic",
                text = {
                    "Randomly select one card to",
                    "discard after any hand is drawn",
                    "+1 Hand Size",
                }
            },
            bl_akyrs_the_sinusoidal= {
                name = "The Sinusoidal",
                text = {
                    "Last 2 cards drawn are",
                    "drawn face down",
                }
            },
            bl_akyrs_the_saw= {
                name = "The Saw",
                text = {
                    "First scored card is destroyed",
                }
            },
            bl_akyrs_the_saw= {
                name = "The Saw",
                text = {
                    "First scored card is destroyed",
                }
            },
            bl_akyrs_the_selfish= {
                name = "The Selfish",
                text = {
                    "#1# in #2# of vowels",
                    "are debuffed",
                }
            },
            bl_akyrs_the_polite= {
                name = "The Polite",
                text = {
                    "Vowels will not score",
                }
            },
            bl_akyrs_the_bent= {
                name = "The Bent",
                text = {
                    "Play a #1#",
                    "#2# times",
                }
            },
            bl_akyrs_ultima_lost_umbrella = {
                name = "Lost Umbrella",
                text = {
                    "All Jokers debuffed until",
                    "#1# playing cards destroyed",
                }
            },
        },
        DescriptionDummy={
            -- config
            dd_akyrs_wildcard_behaviour_1 = {
                name = "Wildcard Behaviour",
                text = {
                    '{C:attention}Automatic','Automatically find a letter for wildcards','which do not have letters set. (Default).',
                }
            },
            dd_akyrs_wildcard_behaviour_2 = {
                name = "Wildcard Behaviour",
                text = {
                    '{C:attention}Force No Unset','The play button will be disabled','if you selected an unset wild card.' ,
                }
            },
            dd_akyrs_wildcard_behaviour_3 = {
                name = "Wildcard Behaviour",
                text = {
                    '{C:attention}Always Manual','Wildcards do not have letter assigned to them by default.','When played, will not attempt to find letters. (Can help with performance)' ,
                }
            },
            dd_akyrs_wildcard_behaviour_4 = {
                name = "Wildcard Behaviour",
                text = {
                    '{C:attention}Auto Set', 'Automatically find a letter for wildcard and','also set the letter automatically to the target if it is unset.', 
                }
            },
            dd_akyrs_balance_settings = {
                name = "Balance Settings",
                text = {
                    "{C:green,E:2}Adequate", "Balanced towards vanilla",
                    "{C:red,E:1}Absurd{C:inactive} (Requires Talisman or Amulet)", "Bigger Number, Crazier Effects,","Direr Consequences"
                }
            },
            dd_akyrs_card_preview_tooltip = {
                name = "Card Preview Tooltip",
                text = {
                    'Some cards have a small "Preview" window where the effect of the cards',
                    'is demonstrated. If you are experiencing crashes after hovering a card',
                    'turning this off might help',
                },
            },
            dd_akyrs_crt_shader_toggle = {
                name = "CRT Shader",
                text = {
                    'Normally, the game {C:attention}always{} render CRT shader despite',
                    'you turning it to 0 in settings which is why everything looks so saturated',
                    'Turning this off means everything will be less saturated {C:inactive}(If you like the faded look)',
                },
            },
            dd_akyrs_full_dictionary = {
                name = "Full Dictionary",
                text = {
                    'Use the full dictionary of {C:attention,E:1}500k{} entries instead of 50k entries',
                    'From a lot of testing, full dictionary {C:attention}can{} cause quite a lag spike',
                    'when playing large words but you will have a lot more word choices.',
                    'Reduced dictionary meanwhile means that things like many {C:attention}plural forms{}',
                    'won\'t be available. But is less likely to be laggy',
                    'This also impacts {C:attention}The Bomb{} boss blinds\' prompt choice',
                },
            },
            dd_akyrs_toggle_colourblind_ui = {
                name = "High Contrast UI",
                text = {
                    'Some UI might be hard to read for certain people.',
                    'For now, changes certain place where green and yellow appear to orange and blue',
                },
            },
            dd_akyrs_experimental_feature = {
                name = "Experimental Features",
                text = {
                    '{s:1.5}Here be dragons!',
                    '{s:1.4}If you have to think to enable it, {s:1.4,E:akyrs_shrivel,C:red}don\'t.',
                    'Enable experimental features for the mod',
                    'These may be broken, nonfunctional at all, or {C:red}outright brick your saves{}',
                    '{C:inactive}(very unlikely but it can and will happen)',
                    'This is mainly for my use so that I can release bugfixes',
                    'for the mod while working on new content at the same time',
                    'I will not stop you from enabling it but it is unfinished after all',
                },
            },
            -- tooltips
            dd_akyrs_maxwell_example={
                name="Example",
                text={
                    "{C:inactive,s:0.8}For example, Spelling {C:spectral,s:0.8}'Spectral'",
                    "{C:inactive,s:0.8}gives you a {C:spectral,s:0.8}Spectral{C:inactive,s:0.8} Card",
                },
            },
            dd_akyrs_yona_yona_ex={
                name="Visual Example",
                text={
                },
            },
            dd_akyrs_2fa_example={
                name="Example Hand",
                text={
                },
            },
            dd_akyrs_credit_larantula={
                name="Art Credit",
                text={
                    "{X:dark_edition,C:white}@larantula_l{}"
                },
            },
            dd_akyrs_credit_gud={
                name="Art Credit",
                text={
                    "{X:dark_edition,C:white}@gudusername_53951{}"
                },
            },
            dd_akyrs_credit_lyman={
                name="Art Credit",
                text={
                    "{X:dark_edition,C:white}@lyman{}"
                },
            },
            dd_akyrs_credit_marcyptata64={
                name="Art Credit",
                text={
                    "{X:akyrs_gappie_cred,C:white}@marcyptata64{}"
                },
            },
            dd_akyrs_hibana_conditions={
                name="Cycle Option",
                text={
                    "{X:dark_edition,C:white}1{} - Aces",
                    "{X:dark_edition,C:white}2{} - Face Cards",
                    "{X:dark_edition,C:white}3{} - Hearts",
                    "{X:dark_edition,C:white}4{} - 5",
                },
            },
            dd_akyrs_tldr_tldr_old={
                name="Too Long; Ain't reading allat",
                text={
                    "{C:mult}+#1#{} Mult per card",
                    "played and in hand",
                },
            },
            dd_akyrs_tldr_tldr_absurd={
                name="Too Long; Ain't reading allat",
                text={
                    "{C:white,X:mult} X#1# {} Mult",
                },
            },
            dd_akyrs_aikoyori_base_ability={
                name="Steamodded & Lovely Ability",
                text={
                    "{X:mult,C:white} X#1# {} Mult per",
                    "{C;attention}non-face{} cards scored",
                },
            },
            dd_akyrs_aikoyori_base_ability_absurd={
                name="Steamodded, Lovely & Talisman Ability",
                text={
                    "{X:dark_edition,C:white} ^#1# {} Mult per",
                    "{C;attention}non-face{} cards scored",
                },
            },
            dd_akyrs_aikoyori_cryptid_ability={
                name="Cryptid Ability",
                text={
                    "If hand only contains {C:attention}a single Ace{}",
                    "Create a {C:dark_edition}Negative{} {C:green}Code{} card",
                },
            },
            dd_akyrs_aikoyori_more_fluff_ability={
                name="More Fluff Ability",
                text={
                    "Add {C:attention}1{} round to {C:colourcard}Colour Cards{}",
                    "when they gain a round",
                },
            },
            dd_akyrs_aikoyori_entropy_ability={
                name="Entropy Ability",
                text={
                    "If {C:attention}full hand{} contains at least",
                    "{C:attention}4{} cards of different rank and suit,",
                    "create a {C:dark_edition}Negative{} {C:spectral}Flipside{}",
                },
            },
            dd_akyrs_aikoyori_sdmstuff_ability={
                name="SDM_0's Stuff Ability",
                text={
                    "If {C:attention}played hand{} contains",
                    "a {C:attention}Full House{}, create a",
                    "{C:dark_edition}Negative{} {C:attention}Bakery{} card",
                },
            },
            dd_akyrs_aikoyori_togasstuff_ability={
                name="TOGA's Stuff Ability",
                text={
                    "If you gain less than {C:money}$10{}",
                    "at the end of the round,",
                    "create a random Booster tag",
                    "from {C:attention}TOGA's Stuff{}",
                },
            },
            dd_akyrs_cryptposting_ability={
                name="Cryptposting Ability",
                text={
                    "Create a {X:attention,E:1}Joker{} when",
                    "Blind is skipped",
                    "{C:inactive}(No room needed)"
                },
            },
            dd_akyrs_aikoyori_pta_ability={
                name="Paya's Terrible Additions Ability",
                text={
                    "Earn extra {C:blue}Pyroxenes{}",
                    "equal to {C:money}money{} earned this round"
                },
            },
            dd_akyrs_placeholder_art={
                name="Placeholder Art",
                text={
                    "This card is using a",
                    "{C:attention}Placeholder art.",
                    "It will be changed later",
                },
            },
            dd_akyrs_prism_ability={
                name="Prism Ability",
                text={
                    "Create a Negative {C:attention}Myth Card{}",
                    "if Hand doesn't contain a {C:attention}Flush"
                },
            },
            dd_akyrs_garbshit_ability={
                name="GARBSHIT Ability",
                text={
                    "Create a {C:dark_edition}Negative {C:attention}Stamp Card{}",
                    "When a {C:attention}Joker{} is sold"
                },
            },
            dd_akyrs_finity_ability={
                name="Finity Ability",
                text={
                    "Create a {C:dark_edition}Negative {C:spectral}Finity{}",
                    "When a {C:attention}Showdown{} Blind is defeated"
                },
            },
            dd_akyrs_bakery_ability={
                name="Bakery Ability",
                text={
                    "{C:dark_edition} +1 {}{C:attention} Charm{} available in shop{}",
                },
            },
            dd_akyrs_astronomica_ability={
                name="Astronomica Ability",
                text={
                    "{C:purple}Multiply score{} by",
                    "number of cards played",
                    "below hand size",
                },
            },
            dd_akyrs_vallkarri_ability={
                name="Vall-Karri Ability",
                text={
                    "Create a {C:dark_edition}Negative{} {C:attention}Aesthetic Card",
                    "If {C:blue}Hands{} = {C:red}Discards{} after pressing play"
                },
            },
            dd_akyrs_grab_bag_ability={
                name="Grab Bag Ability",
                text={
                    "Create a {C:dark_edition}Negative{} {C:attention}Ephemeral Card",
                    "When blind is selected"
                },
            },
            dd_akyrs_ortalab_ability={
                name="Ortalab Ability",
                text={
                    "Upgrade the {C:attention}corresponding{} poker hand",
                    "When {C:attention}Zodiac{} cards are used"
                },
            },
            dd_akyrs_hotpot_ability={
                name="Hot Potato Ability",
                text={
                    "Earn {C:blue,f:hpot_plincoin}͸icks{} equal to",
                    "{C:attention}ten{} times the final {C:chips}Chips{} in scoring"
                },
            },
            dd_akyrs_phanta_ability={
                name="Phanta Ability",
                text={
                    "If {C:attention}played hand{} contains",
                    "a {C:attention}Four of a Kind{}, create a",
                    "{C:dark_edition}Negative{} {C:attention}Hanafuda{} card",
                },
            },
            dd_akyrs_kino_ability={
                name="Balatro Goes Kino Ability",
                text={
                    "Create a {C:dark_edition}Negative{} {C:Confection}Confection{}",
                    "when playing on {C:attention}odd{} number of {C:blue}hands",
                    "{C:inactive}(Number before clicking play)",
                },
            },
            dd_akyrs_maximus_ability={
                name="Maximus Ability",
                text={
                    "When selling a {C:planet}Planet{} Card",
                    "Create a {C:dark_edition}Negative{} {C:horoscope}Horoscope{}",
                },
            },
            dd_akyrs_sagatro_ability={
                name="Sagatro Ability",
                text={
                    "When selling a {C:tarot}Tarot{} Card",
                    "Create a {C:dark_edition}Negative{} {C:sgt_divinatio}Divinatio{}",
                },
            },
            dd_akyrs_qualatro_ability={
                name="Qualatro Ability",
                text={
                    "{C:attention}Rip{} gains 1 {C:attention}Quality",
                },
            },
            dd_akyrs_nhh_cryptid = {
                name = "If Cryptid is installed...",
                text = { 
                    "Gives {X:dark_edition,C:white} ^#1# {} Mult instead",
                }
            },
            dd_akyrs_mukuroju_no_hakamori = {
                name = "{f:5}躯樹の墓守",
                text = { 
                    "{f:5}このジョーカーは、カードのランクを#3#{C:inactive,f:5}「#4#」{f:5}回",
                    "{C:attention,f:5}変換する{f:5}たびに{f:5}倍率 {X:mult,C:white} X#1# {f:5} を得る",
                    "{C:inactive}({C:inactive,f:5}現在 倍率 {X:mult,C:white} X#2# {C:inactive})",
                }
            },
            dd_akyrs_mukuroju_no_hakamori_en = {
                name = "Mukuroju no Hakamori",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "every #3# {C:inactive}[#4#]{} cards whose rank have {C:attention}changed",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                }
            },
            -- blind icons
            dd_akyrs_expert_blind  = {
                name="Expert Blind",
                text={
                    "Blind with higher",
                    "difficulty than usual",
                },
            },
            dd_akyrs_master_blind  = {
                name="Master Blind",
                text={
                    "Blind with even higher",
                    "difficulty level",
                },
            },
            dd_akyrs_ultima_blind  = {
                name="Ultima Blind",
                text={
                    "Extremely difficult blind",
                    "{scale:0.7,C:inactive}(I feel like I've seen this somewhere)",
                },
            },
            dd_akyrs_remaster_blind  = {
                name="Re:Master Blind",
                text={
                    "Buffed version of existing blinds",
                    "{scale:0.7,C:inactive}(I feel like I've seen this somewhere too)",
                },
            },
            dd_akyrs_lunatic_blind  = {
                name="Lunatic Blind",
                text={
                    "Even more difficult than Ultima Blinds",
                    "{scale:0.7,C:inactive}(I feel like I've seen this somewhere as well)",
                },
            },
            dd_akyrs_dx_blind  = {
                name="DX Blind",
                text={
                    "Upgraded Ante 8 Blinds",
                    "from More Fluff",
                },
            },
            dd_akyrs_no_reroll  = {
                name="No Rerolling",
                text={
                    "This blind cannot be rerolled",
                },
            },
            dd_akyrs_no_disabling  = {
                name="No Disabling",
                text={
                    "This blind cannot be disabled",
                },
            },
            dd_akyrs_no_overriding  = {
                name="No Overriding",
                text={
                    "This blind cannot be overridden",
                    "until it's defeated",
                },
            },
            dd_akyrs_no_skipping  = {
                name="No Skipping",
                text={
                    "This blind cannot be skipped",
                },
            },
            dd_akyrs_forgotten_blind  = {
                name="Forgotten Blind",
                text={
                    "This blind can only appear",
                    "in Negative Antes"
                },
            },
            dd_akyrs_word_blind  = {
                name="Word Blind",
                text={
                    "This blind can only appear",
                    "when it is possible to",
                    "play words",
                },
            },
            dd_akyrs_puzzle_blind  = {
                name="Puzzle Blind",
                text={
                    "This blind can only be defeated",
                    "by completing certain criteria",
                },
            },
            dd_akyrs_postwin_blind  = {
                name="Post Win Blind",
                text={
                    "This blind appears on Antes",
                    "above winning Ante",
                },
            },
            dd_akyrs_endless_blind  = {
                name="Endless Blind",
                text={
                    "This blind only appears",
                    "in Endless Mode",
                },
            },
            dd_akyrs_kessoku_band  = {
                name="{f:5}結束バンド {}(Kessoku Band)",
                text={
                    "This Joker looks like it",
                    "wants to {C:akyrs_bocchi}R{C:akyrs_kita}o{C:akyrs_nijika}c{C:akyrs_ryou}k{}!",
                },
            },
            dd_akyrs_copper_scrape_tip  = {
                name="Scraping",
                text={
                    "Fixed {C:green}10% chance{}",
                    "to {C:attention}scrape{} off",
                    "{C:attention}a layer{} of oxidation",
                    "when a consumable is {C:attention}used{}",
                },
            },
            dd_akyrs_pure_cards_tip  = {
                name="Pure Cards",
                text={
                    "{C:attention}Pure Cards{} can form {C:attention}Pure Hands",
                    "{C:attention}Pure Hands{} give more",
                    "base {C:chips}Chips{} and {C:mult}Mult",
                    "but can only be played if played hand",
                    "only has {C:attention}Pure Cards{}",
                    "For example, this is a {C:attention}Pure Flush{}",
                },
            },
            dd_akyrs_pure_cards_tip_no_preview  = {
                name="Pure Cards",
                text={
                    "{C:attention}Pure Cards{} can form {C:attention}Pure Hands",
                    "{C:attention}Pure Hands{} give more",
                    "base {C:chips}Chips{} and {C:mult}Mult",
                    "but can only be played if played hand",
                    "only has {C:attention}Pure Cards{}",
                    "For example, you can make a {C:attention}Pure Flush{}",
                    "with five {C:clubs}Pure Clubs{} card",
                },
            },
            dd_akyrs_letter_puzzle_umbral_expl  = {
                name="Letter & Puzzle",
                text={
                    "{C:attention}Combine{} both letters",
                    "onto one card",
                },
            },
            j_hatena  = {
                name="????????",
                text={
                    "This card's ability {C:attention}hidden{}",
                },
            },
            dd_akyrs_neon_seal_ex  = {
                name="Example",
                text={
                    "If you play {C:attention}3{} cards with this seal",
                    "and hold {C:green}1{} card with this seal in hand",
                    "it will create {C:green}1{} {C:akyrs_umbral_p,X:akyrs_umbral_y}Umbral{} Card",
                    "{C:inactive}(The lesser number)",
                },
            },
            dd_akyrs_non_functional = {
                name="Warning!",
                text={
                    "{C:red,E:akyrs_shrivel,s:1.9}This card",
                    "{C:red,E:akyrs_shrivel,s:1.8}will NOT work!",
                },
            },
            dd_akyrs_scenario_tooltip = {
                name="Scenario",
                text={
                    "{B:1,V:2}#3# #4#{}",
                    "{C:blue}#1#{} / #2# Rounds Left",
                },
            },
            dd_akyrs_scenario_tag_tooltip = {
                name="Scenario",
                text={
                    "{B:1,V:2}#3# #4#{}",
                    "Will last {C:blue}#2#{} Rounds in Tag form",
                },
            },
            dd_akyrs_tag_toggle_tooltip = {
                name="Tags",
                text={
                    "Click to {C:attention}toggle{}",
                    "ability activation",
                },
            },
        },
        Edition={
            e_akyrs_texelated = {
                name = "Texelated",
                text = {
                    "{C:white,X:chips}X#1#{} Chips",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_noire_joker = {
                name = "Noire",
                text = {
                    "{C:dark_edition}+#1#{} Joker Slots",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_noire_consumable = {
                name = "Noire",
                text = {
                    "{C:dark_edition}+#1#{} Consumable Slots",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_noire_hand = {
                name = "Noire",
                text = {
                    "{C:dark_edition}+#1#{} Hand Size",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_noire = {
                name = "Noire",
                text = {
                    "{C:dark_edition}+#1#{} Maximum Slot Size",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_charged = {
                name = "Charged",
                text = {
                    "{C:purple}+#1#{} Score",
                    "Gain {C:purple}+#2# {C:inactive}[+#3#]{} every trigger",
                }
            },
            e_akyrs_sliced = {
                name = "Sliced",
                text = {
                    "{C:attention}Halves{} all values",
                    "Effects calculate {C:attention}twice",
                }
            },
            e_akyrs_burnt = {
                name = "Burnt",
                text = {
                    "{C:green}#1# in #2#{} chance",
                    "of disintegrating into Ash",
                    "at the end of the round"
                }
            },
            e_akyrs_enchanted = {
                name = "Enchanted",
                text = {
                }
            },
        },
        Enchantment = {
            ench_akyrs_multi_enchant_book = {
                name="Enchanted Book",
                text={
                    "Contains {C:attention}more than one{} enchantments",
                },
            },
            ench_akyrs_unbreaking = {
                name="Unbreaking #1#",
                text={
                    "When this card gets {C:attention}destroyed{}",
                    "{C:attention}Fixed {C:green}#2#%{} chance to",
                    "duplicate this card without enchantment",
                },
            },
            ench_akyrs_efficiency = {
                name="Efficiency #1#",
                text={
                    "{C:attention}Fixed {C:green}#2#%{} chance to",
                    "copy ability of the {C:attention}left card",
                    "{B:1,C:white} #3# {}",
                },
            },
            ench_akyrs_mending = {
                name="Mending",
                text={
                    "{C:attention}Retrigger{} once",
                },
            },
            ench_akyrs_fire_aspect = {
                name="Fire Aspect #1#",
                text={
                    "{C:purple}+#2#%{} Score when triggered",
                },
            },
            ench_akyrs_fortune = {
                name="Fortune #1#",
                text={
                    "{C:green}+#2#%{} probability",
                    "on {C:attention}this{} card",
                },
            },
            ench_akyrs_greed = {
                name="Greed #1#",
                text={
                    "Selling a card gives {C:money}+#2#%{}",
                    "of its sell cost to {C:attention}this{} card",
                },
            },
            ench_akyrs_silk_touch = {
                name="Silk Touch #1#",
                text={
                    "When discarded, remove {C:attention}enhancement{}",
                    "and add bonus {C:white,X:mult} X#2# {} Mult to this card",
                },
            },
            ench_akyrs_cornucopia = {
                name="Cornucopia",
                text={
                    "When played, create a copy {C:attention}this card{} and add to played hand",
                    "{C:attention}removing Enchantment{} from the copy",
                },
            },
        },
        Enhanced={
            -- blindside :tm:
            m_bld_the_choice = {
                name = "The Choice",
                text = {
					"{X:dark_edition,C:white}Faded{}",
                    "{X:red,C:white}X#1#{} Mult",
                    "Played hand must contain {B:1}#2#{} blinds",
                }
            },
            m_bld_the_reject = {
                name = "The Reject",
                text = {
					"{X:dark_edition,C:white}Faded{}",
                    "{X:blue,C:white}X#1#{} Chips",
                    "Played hand must not contain {B:1}#2#{} blinds",
                }
            },
            m_bld_the_redo = {
                name = "The Redo",
                text = {
					"{X:dark_edition,C:white}Yellow{}",
                    "When played, {C:attention}retrigger{}",
                    "held in hand effect {C:attention}once",
                }
            },
            m_akyrs_brick_card = {
                name="Brick Card",
                text={
                    "{C:mult}+#1#{} Mult",
                    "No Rank or Suit"
                },
            },
            m_akyrs_scoreless = {
                name="Scoreless",
                text={
                    "Does not score"
                },
            },
            m_akyrs_ash_card = {
                name="Ash Card",
                text={
                    "{C:blue}+#1#{} Chips",
                    "No rank, no suits",
                    "{C:green}#2# in #3#{} chance",
                    "of disintegrating into nothing",
                    "at the end of the round"
                },
            },
            m_akyrs_ash_card_absurd = {
                name="Ash Card",
                text={
                    "{C:purple,X:edition} ^#1# {} Chips",
                    "No rank, no suits",
                    "{C:attention}Always{} disintegrating into nothing",
                    "at the end of the round"
                },
            },
            m_akyrs_hatena = {
                name="? Card",
                text={
                    {
                        "{C:green}#1# in #2#{} chance to gain {C:money}$#3#",
                        "{C:green}#4# in #5#{} chance to gain {C:money}$#6#",
                        "{C:green}#7# in #8#{} chance to give {C:mult}+#9#{} Mult",
                        "on initial scoring and {X:mult,C:white} X#10# {} on retriggers",
                    },
                    {
                        "No rank, no suit, always scores"
                    }
                }
            },
            m_akyrs_item_box = {
                name="Item Box Card",
                text={
                    {
                        "Create a {C:attention}random{}",
                        "{C:tarot}consumable{} card when {C:attention}scored",
                        "{C:inactive}(Must have room)"
                    },
                    {
                        "{C:red,E:1}Self-destructs{} and the end of the round",
                        "if successfully triggered"
                    },
                    {
                        "No rank, no suit, always scores"
                    }
                }
            },
            m_akyrs_insolate_card = {
                name = "Insolate Card",
                text = {
                    "This card gains {C:white,X:mult} X#1# {} Mult when played",
                    "if played hand {C:attention}contains NO{} repeating {C:attention}enhancements",
                    "{C:inactive}(Currently {C:white,X:mult} X#2# {C:inactive} Mult){}" 
                }
            },
            m_akyrs_canopy_card = {
                name = "Canopy Card",
                text = {
                    "Once per hand, {C:attention}double click{} this card",
                    "to {C:attention}reduce{} its rank by {C:attention}1{}",
                    "{B:1,V:2}#1#{}",
                }
            },
            m_akyrs_thai_tea_card = {
                name = "Thai Tea Card",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                }
            },
            m_akyrs_matcha_card = {
                name = "Matcha Card",
                text = {
                    "{X:purple,C:white} X#1# {} Score",
                    "{X:blind,C:white} X#1# {} Blind Size",
                }
            },
            m_akyrs_earl_grey_tea_card = {
                name = "Earl Grey Tea Card",
                text = {
                    "{C:money} +$#1#{} if this card is played",
                    "but not scored",
                }
            },
            m_akyrs_zap_card = {
                name = "Zap Card",
                text = {
                    "{C:attention}Duplicates{} itself",
                    "without the enhancement",
                    "every {C:attention}#1#{} {C:inactive}(#2#){} times",
                    "this card scores"
                }
            },
            m_akyrs_net_card = {
                name = "Net Card",
                text = {
                    {
                        "{C:white,X:mult}X#1#{} Mult",
                        "when held in hand",
                    },
                    {
                        "{C:money}#2#{} when held in hand",
                        "at the end of the round",
                    }
                }
            },
            m_akyrs_droplet_card = {
                name = "Droplet Card",
                text = {
                    "{C:green}#1# in #2#{} chance to give",
                    "{C:red}+#3#{} Discard when discarded",
                }
            },
            m_akyrs_semibreve_card = {
                name = "Semibreve Card",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "{C:mult}+#2#{} Mult",
                }
            },
            m_akyrs_minim_card = {
                name = "Minim Card",
                text = {
                    "{C:white,X:chips}X#1#{} Chips",
                    "{C:mult}+#2#{} Mult",
                }
            },
            m_akyrs_crotchet_card = {
                name = "Crotchet Card",
                text = {
                    "{C:white,X:chips}X#1#{} Chips",
                    "{C:white,X:mult}X#2#{} Mult",
                }
            },
            m_akyrs_wafer_card = {
                name = "Wafer Card",
                text = {
                    "{C:white,X:purple}X#1#{} Score",
                    "on last hand of round",
                }
            },
            m_akyrs_shore_card = {
                name = "Shore Card",
                text = {
                    "{C:white,X:mult}X#1#{} Mult",
                    "{C:green}#3# in #4#{} chance",
                    "to be destroyed when scored",
                    "{C:green}#5# in #6#{} chance to spread",
                    "to a random card held in hand",
                    "with extra {C:white,X:mult}X#2#{} Mult",
                }
            },
            m_akyrs_cloud_card = {
                name = "Cloud Card",
                text = {
                    "Gain {C:money}#1#{} per",
                    "one of these in your deck",
                    "at the {C:attention}end of the round",
                }
            },
            m_akyrs_nightshade_card = {
                name = "Nightshade Card",
                text = {
                    "{C:white,X:chips}X#1#{} Chips",
                    "{C:attention}Debuffs itself{} for the round if not",
                    "played immediately {C:attention}after drawn",
                }
            },
            m_akyrs_tap_card = {
                name = "Tap Card",
                text = {
                    {
                        "{C:white,X:blind}X#1#{} Blind Size",
                        "No rank, no suit, always scores",
                    },
                }
            },
            m_akyrs_tap_card_life = {
                name = "Tap Card",
                text = {
                    {
                        "{C:white,X:blind}X#1#{} Blind Size",
                        "No rank, no suit, always scores",
                    },
                    {
                        "Lose {C:attention}half as much{}",
                        "{C:green}Life{} from normal",
                    },
                }
            },
        },
        FakeCenter = {
            fc_akyrs_eggymari_hatena_art = {
                name = "Concealed Card Art",
                text = {
                    "Appears with {C:attention}Concealed Stickers",
                    "and in certain {C:attention}challenges{}!"
                }
            },
            fc_akyrs_toga_charmap = {
                name = "Character Map",
                text = {
                    "Install {C:attention}TOGA's Stuff{} to find out!"
                }
            },
            fc_akyrs_toga_winword = {
                name = "Microsoft Word",
                text = { 
                    "Install {C:attention}TOGA's Stuff{} to find out!"
                }
            },
            fc_akyrs_paperback_pure_star = {
                name = "Pure Star Card",
                text = { 
                    "Install {C:attention}Paperback{} for {C:attention}Star{} suit!"
                }
            },
            fc_akyrs_paperback_pure_crown = {
                name = "Pure Crown Card",
                text = { 
                    "Install {C:attention}Paperback{} for {C:attention}Crown{} suit!"
                }
            },
            fc_akyrs_paperback_pure_apostle = {
                name = "Pure Apostle Card",
                text = { 
                    "Install {C:attention}Paperback{} for {C:attention}Apostle{}!"
                }
            },
            fc_akyrs_judgement_miss = {
                name = "Miss",
                text = { 
                    "Used in {C:green}Life{} Mechanics"
                }
            },
            fc_akyrs_judgement_good = {
                name = "Good",
                text = { 
                    "Used in {C:green}Life{} Mechanics"
                }
            },
            fc_akyrs_judgement_great = {
                name = "Great",
                text = { 
                    "Used in {C:green}Life{} Mechanics"
                }
            },
            fc_akyrs_judgement_perfect = {
                name = "Perfect",
                text = { 
                    "Used in {C:green}Life{} Mechanics"
                }
            },
            fc_akyrs_judgement_cperfect = {
                name = "Critical Perfect",
                text = { 
                    "Used in {C:green}Life{} Mechanics"
                }
            },
        },
        Joker={
            -- toga
            j_akyrs_toga_charmap = {
                name = "Character Map",
                text = {
                    "Create an Alphabet {C:attention}Alphabet{} card for the most",
                    "common letter played if there's only {C:attention}one{} most common letter"
                }
            },
            j_akyrs_toga_winword = {
                
                name = "Microsoft Word",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "per letter if a word is played",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                }
            },
            j_akyrs_redstone_repeater = {
                name = "Redstone Repeater",
                text = { "Swaps the current {C:white,X:mult} Mult {} value", "with the stored {C:mult}Mult",
                    "then {C:white,X:mult} X#2# {} Mult", 
                        -- "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
                    --"{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}" 
                    }
            },
            j_akyrs_observer = {
                name = "Observer",
                text = { "This Joker gains {C:mult}+#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                    "a card that is not Observer {C:attention}wiggles",
                    "{s:0.8}Times needed increases by {C:attention}#5#{}",
                    "{s:0.8}every time this Joker gains {C:mult}Mult{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}" }
            },
            j_akyrs_quasi_connectivity = {
                name = "Quasi Connectivity",
                text = { "{C:white,X:mult} X#1# {} Mult", 
                    "Disables one {C:attention}random Joker{}",
                    "after a hand is played",
                    "{s:0.8}Debuffs itself if it's",
                    "{s:0.8}the sole card"
                }
            },
            j_akyrs_diamond_pickaxe = {
                name = "Diamond Pickaxe",
                text = {
                    "Siphons {C:chips}#2#{} Chips",
                    "from every {C:attention}Stone{} Card scored",
                    "and {C:attention}adds{} that amount to this Joker",
                    "{C:inactive}(Remove Stone if card has no Chips left)",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                }
            },
            j_akyrs_netherite_pickaxe = {
                name = "Netherite Pickaxe",
                text = {
                    "Destroy played {C:attention}Stone{} Cards",
                    "and gain {X:chips,C:white} X#2# {} Chips each Stone Card {C:attention}destroyed",
                    "{C:inactive}(Currently {X:chips,C:white} X#1# {C:inactive} Chips){}" ,
                }
            },
            j_akyrs_utage_charts = {
                name = "Utage Charts",
                text = {
                    "{C:akyrs_playable}+#1#{} Card Selection"
                }
            },
            j_akyrs_maxwells_notebook = {
                name = "Maxwell's Notebook",
                text = { 
                    "Spelling the type of a card",
                    "gives you {C:attention}one{} of that card",
                    "Spelling enhancements enhance",
                    "the {C:attention}scored card{} to the one you spelled",
                    "{C:inactive}(Must have room)",
                }
            },
            j_akyrs_it_is_forbidden_to_dog = {
                name = "It is forbidden to dog",
                text = { 
                    "When this Joker scores",
                    "debuffed cards held in hand each",
                    "give {X:mult,C:white} X#1#{} Mult",
                    "{C:inactive}(Due to technical limitations)",
                    "A {C:attention}random{} card in hand is debuffed",
                    "every hand {C:attention}drawn"
                }
            },
            j_akyrs_eat_pant = {
                name = "eat pant",
                text = { 
                    "If played hand contains exactly {C:attention}4{} cards",
                    "{C:red}destroys first two played cards{} and loses",
                    "{X:mult,C:white} 1/#2# {} of its current {X:mult,C:white}XMult{} {C:inactive}(cumulative)",
                    "per card destroyed",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                    "{C:inactive}(Can underflow below {X:mult,C:white} X1 {C:inactive})",
                }
            },
            j_akyrs_tsunagite = {
                name = "{f:5,C:akyrs_luminous}系ぎて",
                text = { 
                    "Played cards permanently gain {X:mult,C:white} X#2#{} Mult",
                    "if played cards' {C:chips}chips{} is divisible by {C:attention}#1#"
                }
            },
            j_akyrs_yona_yona_dance = {
                name = "Yona Yona Dance",
                text = { 
                    "Retrigger each played {C:attention}4{} and {C:attention}7{}",
                    "{C:attention}#1#{} additional times",
                    "{C:inactive,s:0.9,f:akyrs_MochiyPopOne}ならば踊らにゃ損、踊らにゃ損です!{}",
                }
            },
            j_akyrs_tldr_joker = {
                name = "TL;DR Joker",
                text = {
                    {
                        "{C:white,X:mult} X#1# {} Mult only if",
                        "{C:attention}all{} of the following conditions",
                        "are satisfied at least once this run",
                        "Otherwise {C:mult}+#2#{} Mult per card"
                    },
                    {
                        "In peace there is cult, in between there is {C:red}Mult{}. Soon as they are blue, finish all of ten clues.",
                        "First one is a must, won a blind with a {C:red}gust{}. The flame is quite hot, so win round with {C:red}one shot.",
                        "Second is for sure, shops are full of allure. This one must be {C:attention}sold, once{} and then thou must hold.",
                        "Third time is the {C:purple}Charm{}, as they said getting warm. Some mods made it lag, but for sure get the {C:purple}Tag.",
                        "Fourth wall made to break, in this case in the wake. \"{C:akyrs_replicant_o}Replicant{} aren't gold, so {C:attention}use{} it\" thou are told.",
                        "Fifth one is easy, just make sure they will see. {C:attention}Vouchers{} are not free. {C:attention}Redeem{} one, that's decree.",
                        "Sixth clue forms a plan, {C:attention}selling{} one of thy clan. {C:red}Rare{} one thou will need, shows thyself without greed.",
                        "Seventh makes a note, In the way found a moat. {C:akyrs_umbral_p,X:akyrs_umbral_y}Intrusive{} wins the round. before luck lost the ground.",
                        "Eighth one makes a change, in effort to arrange. {C:attention}Fill{} them with {C:attention}Jokers{}, don't need sort, however.",
                        "Ninth one sounds silly, {C:attention}Straight{}'s played when thou see. {C:attention}Flush{} too, the {C:attention}same round{}, all theses suit are abound.",
                        "Tenth clue is the last, it is not but a card. Have {C:attention}two{} 8 of {C:hearts}Hearts{}. Finish all, Mult be thine."
                    }
                }
            },
            j_akyrs_tldr_joker_2 = { -- TODO: find somewhere to fit this in
                name = "TL;DR Joker 2",
                text = {
                    "In the vast world of {C:attention,E:1,s:1.1}Balatro{}, a deity arrived. Only someone with such geniusness would be",
                    "able to comprehend such deity, such graceful godlike figure would only give you a few words at most",
                    '"It is a fact of life that preseverance is the key to ultimate truth" said deity.',
                    'That was more than a few words, was not it. And what exactly does this deity mean by "ultimate truth"',
                    'The attentiveness of this issue arose when someone had the great idea to persevere all over the place',
                    '"Only such genius could achieve this ultimate truth" asked some guy in his late 20s',
                    'He would crush his records of the least genius specimen of all time, ranking below even Spongiforms',
                    'The title is not a lie, he is literally not that smart. Yet he tried. He has been trying to go back to',
                    'grade school to get back to what is needed for a functioning adult to survive in this modern day.',
                    'His job as a janitor for NASA does pay enough for a curriculum at some high end vocational school.',
                    'His perseverance, or rather his stubbornness has led him to multiple bad decisions in his life.',
                    'When he was a kid, he thought {C:purple}Stone{}henge was made by aliens and that The {C:attention}7 Wonders{} of the world are merely nature',
                    'After everything, he knew he was ready to face the deity, again. He knew this {C:attention}ceremony{} like the back of his hands.',
                    '"O\'lord shall save me from this burning hellscape of reality" chanted him. An image appeared in front of him, like a hologram of some sort.',
                    '"The Bluezoozh devais is readih tuh pearh" proclaimed the hologram. He stood in disbelief. Never knew the deity was this high tech to use',
                    'such advanced human technology as Bluetooth. He whipped out his Phone 17 Pro Max Ultra Ultimate & Knuckles and connect to the device named "Deity Portal".',
                    '"The Bluezoozh devais is duh uh connected-uh-successfully" the hologram exclaimed. "You have a carl".',
                    'Mistakenly heard, he drove a car off the cliff the hologram originally appeared. It seemed that he is, after all',
                    'going crazy. With Every fibre of his being burned into ash, the screen on his car said {C:white,X:mult} X#1# {} Mult',
                    'It was all the man needed to know. He finally made peace with the fact that that fucking deity is useless',
                    'The deity then suddenly appeared in front of his almost-burnt body. This deity had planned your demise since your first meet',
                    '"You have presevered all over the place. It is time for you to leave this world peacefully"',
                    'With that, everything disappeared into darkness. Left with only desires to become better self.',
                }
            },
            j_akyrs_reciprocal_joker = {
                name = "Reciprocal Joker",
                text = { 
                    "Set {X:mult,C:white}Mult{} to",
                    "{X:chips,C:white}Chips{} divided by {X:mult,C:white}Mult{}",
                }
            },
            j_akyrs_inverse_joker = { -- TODO: find a couple for the reciprocal
                name = "Inverse Joker",
                text = { 
                    "Set {X:chips,C:white}Chips{} to",
                    "{X:mult,C:white}Mult{} divided by {X:chips,C:white}Chips{}",
                }
            },
            j_akyrs_kyoufuu_all_back = {
                name = "Kyoufuu All Back",
                text = { 
                    "Return previously {C:attention}played and discarded",
                    "{C:attention and played{} cards back to deck"
                }
            },
            j_akyrs_2fa = {
                name = "Two-Factor Authentication",
                text = { 
                    "{C:attention}All Played Cards'{} Rank",
                    "and Suit are {C:attention}randomized{} after scoring",
                    "and gains {C:chips}+#1#{} Chips per card played",
                    "{C:attention}Halves{} at the end of the round.",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                    "{C:inactive,s:0.8}PSA: Please enable 2FA on all your online accounts!",
                }
            },
            j_akyrs_gaslighting = {
                name = "Gaslighting",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult every hand played",
                    "{C:attention}Will certainly not reset at all if score catches fire.",
                    "{C:inactive,s:0.7}Trust me, not Jimbo.",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                }
            },
            j_akyrs_hibana = {
                name = "Hibana",
                text = { 
                    "{C:attention}#1#{} are first to be drawn",
                    "{C:attention}Cycles{} through a list every round",
                    "{C:inactive}(Current Option : {C:white,X:dark_edition} #2# {C:inactive})"
                }
            },
            j_akyrs_centrifuge = {
                name = "Centrifuge",
                text = { 
                    "If at least {C:attention}3{} cards were played",
                    "First and last card {C:attention}+#1#{} Rank",
                    "all other cards {C:attention}-#1#{} Rank",
                    "Gives {C:chips}+#2#{} Chips per card played",
                }
            },
            j_akyrs_centrifuge_absurd = { -- TODO: nerf this and put it somewhere on consumable
                name = "Centrifuge",
                    text = { 
                        "If at least {C:attention}3{} cards were played",
                        "First and last card {C:attention}+#1#{} Rank",
                        "Both gains new enhancement and edition",
                        "all other cards {C:attention}-#1#{} Rank",
                        "and becomes {C:attention}Scoreless{}",
                }
            },
            j_akyrs_henohenomoheji = {
                name = "Henohenomoheji",
                text = { 
                    "Cards with Letter {C:attention}K{},{C:attention}Q{}, and {C:attention}J",
                    "are considered {C:attention}Face{} Cards",
                }
            },
            j_akyrs_neurosama = {
                name = "Neuro Sama",
                text = { 
                    {
                        "This Joker gains {X:mult,C:white} X#2# {} Mult",
                        "for every {C:hearts}Hearts{} and {C:spades}Spades{} scored",
                        "If hand contains both {C:hearts}Hearts{} and {C:spades}Spades{}",
                    },
                    {
                        "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
                    }
                }
            },
            j_akyrs_evilneuro = {
                name = "Evil Neuro",
                text = { 
                    {
                        "This Joker gains {X:chips,C:white} X#2# {} Chips",
                        "for every {C:clubs}Clubs{} and {C:diamonds}Diamonds{} scored",
                        "If hand contains both {C:clubs}Clubs{} and {C:diamonds}Diamonds{}",
                    },
                    {
                        "{C:inactive}(Currently {X:chips,C:white} X#1# {C:inactive} Chips)",
                    }
                }
            },
            j_akyrs_dried_ghast = {
                name = "Dried Ghast",
                text = { 
                    "Play with {C:red}no discards{}",
                    "for the next {C:blue}#1# rounds{}",
                    "and create {T:j_akyrs_ghastling,C:purple}Ghastling{}",
                    "{C:red}Self-destructs{}",
                }
            },
            j_akyrs_ghastling = {
                name = "Ghastling",
                text = { 
                    "{C:mult}+#2#{} Mult",
                    "And after playing {C:attention}#1#{} hands,",
                    "creates a {T:j_akyrs_happy_ghast,C:purple}Happy Ghast{}",
                    "{C:red}Self-destructs{}",
                    "Decreases by {C:blue}1{} more every hand",
                    "per {T:j_ice_cream,C:blue}Ice Cream{} present",
                }
            },
            j_akyrs_happy_ghast = {
                name = "Happy Ghast",
                text = { 
                    "{X:mult,C:white}X#1#{} Mult",
                }
            },
            j_akyrs_charred_roach = {
                name = "Charred Roach",
                text = { 
                    "{C:red}Destroying and selling{} cards",
                    "grants you a {C:attention}Burnt{} copy of them",
                }
            },
            j_akyrs_ash_joker = {
                name = "Ash Joker",
                text = { 
                    "{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance",
                    "of disintegrating",
                    "at the end of the round",
                    "but gain {C:chips}+#4#{} Chips",
                    "if it survives"
                }
            },
            j_akyrs_yee = {
                name = "Yee",
                text = { 
                    "If played word contains {C:green}a Y{} and {C:green}two E's{},",
                    "Gain {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "Per Scored {C:attention}Y's{} and {C:blue}E's{}",
                    "{s:0.7,C:inactive}bobobobo bo bobo bo bobo bobobobo bo bobo YEE{}"
                }
            },
            j_akyrs_chicken_jockey = {
                name = "Chicken Jockey",
                text = {
                    { 
                        "{C:attention}Obtain{} a {C:red}Popcorn{} when {C:attention}buying{} a non-Joker card",
                        "{C:inactive}(Must have room){}",
                        "{s:0.7,C:inactive}Absolute Cinema.{}",
                    }
                }
            },
            j_akyrs_tetoris = {
                name = "Tetoris",
                text = { 
                    "Cards played are scored again {C:attention}backwards",
                    "{s:0.9,C:inactive,f:5}テテテテト テト テテテテトリス!{}"
                }
            },
            j_akyrs_aikoyori = {
                name = "{C:dark_edition,E:akyrs_rainbow_wiggle}Aikoyori",
                text = { 
                    "This {E:akyrs_obfuscate}Joker?{} gains more abilities",
                    "the more {C:attention}mods{} you installed",
                    "{C:inactive}The self-insert of all time!"
                }
            },
            j_akyrs_mukuroju_no_hakamori = {
                name = "{f:5}躯樹の墓守",
                text = { 
                    "{f:5}このジョーカーは、カードのランクを#3#{C:inactive,f:5}「#4#」{f:5}回",
                    "{C:attention,f:5}変換する{f:5}たびに{f:5}倍率 {X:mult,C:white} X#1# {f:5} を得る",
                    "{C:inactive}({C:inactive,f:5}現在 倍率 {X:mult,C:white} X#2# {C:inactive})",
                }
            },
            j_akyrs_mukuroju_no_hakamori_en = {
                name = "Mukuroju no Hakamori",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "every #3# {C:inactive}[#4#]{} cards whose rank have {C:attention}changed",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                }
            },
            j_akyrs_emerald = {
                name = "Emerald",
                text = { 
                    {
                        "This joker sells for {X:money,C:black}X#1#{}",
                        "its buy cost plus how many of Emerald you have ({C:money}$#2#{} + {C:money}$#3#{})",
                        "{C:inactive}(Will do more things in future updates trust)",
                    },
                    {
                        "{C:inactive}Holding this Joker makes it more likely to find",
                        "{C:inactive}another one of the same."
                    }

                }
            },
            j_akyrs_shimmer_bucket = {
                name = "Shimmer Bucket",
                text = { 
                    "After exiting the shop,",
                    "Destroy and Create {C:attention}#1#{} Jokers",
                    "with the {C:attention}same{} rarity as the Joker",
                    "{C:attention}immediately to the left{} of this joker",
                    "{C:red}Self-destructs{}",
                }
            },
            j_akyrs_space_elevator = {
                name = "Space Elevator",
                text = { 
                    {
                        "Score {C:attention}#1# {C:blue}#2#s{} {C:inactive}(#4#){}",
                        "to move on to the next {C:attention}Phase{} {C:inactive}(#3#/6)",
                        "Get {C:dark_edition}Negative {C:spectral}Spectral{} when completing a phase",
                    },
                }
            },
            j_akyrs_turret = {
                name = "Turret",
                text = { 
                    "Sell this Joker to destroy",
                    "Joker {C:attention}to the right and gives {X:money,C:black}X#2#{}",
                    "of its {C:attention}sell{} cost back {C:inactive}({C:money}$#1#{C:inactive}){}",
                    "{E:1,C:red}Bypasses Eternal",
                }
            },
            j_akyrs_aether_portal = {
                name = "Aether Portal",
                text = { 
                    "When Blind is Selected",
                    "Joker {C:attention}to the left{}",
                    "gains a {C:attention}new{} edition",
                    "{C:green}#1# in #2#{} chance to {C:red}destroy",
                    "the portal in this process",
                    "{C:inactive}(All editions weighted equally)",
                }
            },
            j_akyrs_corkscrew = {
                name = "Corkscrew",
                text = { 
                    "{C:white,X:mult} X#1#{} Mult",
                    "{C:attention}Randomize position{}",
                    "after clicking Play",
                    "{C:inactive}(Can stay still){}",
                }
            },
            j_akyrs_goodbye_sengen = {
                name = "Goodbye Sengen",
                text = { 
                    "If {C:attention}first hand of round{} has {C:attention}a single{} card,",
                    "destroy it and create a {C:tarot}Justice{}",
                    "{C:inactive}(Must have room){}",
                    "{C:inactive,f:5}引きこもり絶対ジャスティス俺の私だけの折の中で{}",
                }
            },
            j_akyrs_liar_dancer = {
                name = "Liar Dancer",
                text = { 
                    "{C:attention}All played cards'{} ranks are considered",
                    "as cards {C:attention}held in hand{} in the same position",
                }
            },
            j_akyrs_pissandshittium = {
                name = "Pissandshittium",
                text = { 
                    "Tells the URL where to download",
                    "{X:akyrs_pissandshittium,C:white}Pissandshittium{}",
                    "{C:akyrs_pissandshittium}+$#1#{} when you play a hand",
                }
            },
            j_akyrs_pandora_paradoxxx = {
                name = "PANDORA PARADOXXX",
                text = { 
                    "Give {C:attention}Standard Tag",
                    "for every {C:attention}#1#{C:inactive} (#2#) {}playing card",
                    "played and scored"
                }
            },
            j_akyrs_story_of_undertale = {
                name = "Story of Undertale",
                text = { 
                    "Appears on {C:attention}Ante 4{} and above",
                    "Your actions have {C:attention}consequences.",
                    "{C:inactive}(Genocide Route: At least 10 playing cards are destroyed){}",
                    "{C:inactive}(Neutral Route: At least one playing card has been modified or destroyed){}",
                    "{C:inactive}(Pacifist Route: Playing cards are not modified or destroyed){}",
                }
            },
            j_akyrs_story_of_undertale_neutral = {
                name = "Story of Undertale (N)",
                text = { 
                    "Create a {C:red}Rare{} Joker & {C:red}self-destructs{}",
                    "at the end of the round",
                    "{C:inactive}(Neutral Route: A card has been modified or destroyed){}",
                }
            },
            j_akyrs_story_of_undertale_genocide = {
                name = "Story of Undertale (G)",
                text = { 
                    "{X:mult,C:white} X#1# {} Mult",
                    "Always {C:purple}Eternal{}",
                    "{C:inactive}(Genocide Route: At least 10 cards are destroyed){}",
                }
            },
            j_akyrs_story_of_undertale_pacifist = {
                name = "Story of Undertale (P)",
                text = { 
                    "Create a {C:red}Legendary{} Joker & {C:red}self-destructs{}",
                    "at the end of the round",
                    "{C:inactive}(Pacifist Route: Cards are not modified or destroyed){}",
                }
            },
            j_akyrs_no_hints_here = {
                name = "No Hints Here!",
                text = { 
                    "{X:mult,C:white} X#1# {} Mult",
                    "Hides {C:attention}all{} tooltips",
                }
            },
            j_akyrs_brushing_clothes_pattern = {
                name = "Brushing Clothes Pattern",
                text = { 
                    "Add {C:attention}first held{} card to played hand",
                    "{C:inactive}(The card will be on the leftmost)"
                }
            },
            j_akyrs_you_tried = {
                name = "You Tried",
                text = { 
                    "{C:attention}Prevents death{} and",
                    "Halves your current Ante {C:inactive}(rounding up)",
                    "Sets money to {C:money}$#2#",
                    "then {E:akyrs_snaking,C:red}self-destructs",
                }
            },
            j_akyrs_you_tried_mp = {
                name = "You Tried",
                text = { 
                    "When losing to {C:attention}non-PvP{} blinds",
                    "Gain {C:money}$#2#",
                    "then {E:akyrs_snaking,C:red}self-destructs",
                }
            },
            j_akyrs_don_chan = {
                name = "Don-Chan",
                text = { 
                    "Add {C:attention}#1#%{}",
                    "of current {X:chips,C:white}Chips{} to {C:white,X:mult}Mult",
                }
            },
            j_akyrs_katsu_chan = {
                name = "Katsu-Chan",
                text = { 
                    "Add {C:attention}#1#%{}",
                    "of current {C:white,X:mult}Mult{} to {X:chips,C:white}Chips",
                }
            },
            j_akyrs_lagtrain = {
                name = "Lagtrain",
                text = { 
                    "Played and unscored cards",
                    "gain {C:chips}+#1#{} Chips",
                }
            },
            j_akyrs_bocchi = {
                name = {
                    "{f:5}後藤ひとり{}" , 
                    "{s:0.7}Gotoh Hitori"
                },
                text = { 
                    {
                        "Add an {C:attention}Enhanced Sealed {C:spades}Spades{} to hand",
                        "per {C:attention}Kessoku Band{} Jokers held when {C:attention}hand is played",
                    }
                }
            },
            j_akyrs_kita = {
                name = {
                    "{f:5}喜多郁代{}" , 
                    "{s:0.7}Kita Ikuyo"
                },
                text = { 
                    {
                        "If played hand contains a {C:attention}Flush{}",
                        "and a card with {C:hearts}Hearts{} suit,",
                        "Create {C:tarot}The Lovers{}",
                        "{C:inactive}(Must have room){}",
                    }
                }
            },
            j_akyrs_ryou = {
                name = {
                    "{f:5}山田リョウ{}" , 
                    "{s:0.7}Yamada Ryou"
                },
                text = { 
                    {
                        "Once per round, use this {C:attention}card{}",
                        "to immediately gain up to {C:money}#1#{}",
                        "{C:inactive}(Left: {C:money}#2#{C:inactive}, #3# this round)",
                    },
                    {
                        "Gain {C:money}#4#{} per unscored {C:clubs}Clubs{}"
                    }
                }
            },
            j_akyrs_nijika = {
                name = {
                    "{f:5}伊地知虹夏{}" , 
                    "{s:0.7}Ijichi Nijika"
                },
                text = { 
                    {
                        "If {C:attention}played hand{} contains a {C:attention}Straight{}",
                        "and has a {C:diamonds}Diamonds{} suit",
                        "Create a {C:dark_edition}Negative {C:planet}Planet Card{} of your most played hand"
                    },
                }
            },
            j_akyrs_blue_portal = {
                name = "Blue Portal",
                text = { 
                    {
                        "{C:white,X:chips} X#1# {} Chips",
                        "{C:attention}2{} free Joker slots",
                        "required to purchase",
                        "Spawns a matching",
                        "{C:attention}Orange Portal{} when purchase"
                    },
                }
            },
            j_akyrs_orange_portal = {
                name = "Orange Portal",
                text = { 
                    {
                        "{C:white,X:mult} X#1# {} Mult",
                    },
                }
            },
            j_akyrs_g = {
                name = {
                    'Awesome fucking evil blue',
                    'flaming skull next to',
                    'a keyboard with the "g"',
                    'key being highlighted',
                },
                text = {
                    'If first hand played is a word',
                    'and starts with a {C:white,X:blue}g{}',
                    '{E:akyrs_shrivel,C:red}Destroy all cards played{}',
                    'and enhance all cards in hand to {C:blue}Zap Cards{}'
                }
            },
            j_akyrs_d_se_dab = {
                name = "D se Dab",
                text = {
                    'When at least {C:attention}3 distinct{} enhanced cards are played',
                    'Cards with letter {C:attention}D{} in hand and in play',
                    'permanently {C:attention}gain{} {C:white,X:chips} X#1# {} Chips',
                    '{C:inactive,s:0.8}Cool Clothes + Attitude + New Hand Moves'
                }
            },
            j_akyrs_c = {
                name = "c",
                text = {
                    'Cards with letter {C:attention}C{}',
                    ' gives {C:chips}+#1#{} Chips each when scored',
                    '{C:inactive,s:0.8}cue Tobu - Cloud 9'
                }
            },
            j_akyrs_koshitan = {
                name = {
                    "{f:5}虎視虎子",
                    "{s:0.7}Koshi Torako"
                },
                text = {
                    'When blind is {C:attention}selected',
                    'Takes {C:money}$#1#{} and adds',
                    '{C:money}$#2#{} to this Joker\'s',
                    '{C:money}sell value{}',
                }
            },
            j_akyrs_nokotan = {
                name = {
                    "{f:5}鹿乃子のこ",
                    "{s:0.7}Shikanoko Noko"
                },
                text = {
                    'Gives {C:mult}Mult{} equal to',
                    '{C:mult}#1#X{} the {C:attention}combined{} sell value of Jokers',
                    '{C:attention}immediately{} to the left and right of this Joker',
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                }
            },
            j_akyrs_koshian = {
                name = {
                    "{f:5}虎視餡子",
                    "{s:0.7}Koshi Anko"
                },
                text = {
                    'This Joker\'s {C:attention}sell value{} is equal to',
                    'product of {C:green}numerator and denominator{} of probability',
                    'with base chance of {C:attention}2 in 2',
                    "{C:inactive}(Currently {C:green}#1# in #2#{C:inactive})",
                }
            },
            j_akyrs_bashame = {
                name = {
                    "{f:5}馬車芽めめ",
                    "{s:0.7}Bashame Meme"
                },
                text = {
                    'This Joker gain {C:money}$#1#{} of {C:attention}sell value{}',
                    'when a {C:attention}Canopy Card{} is scored',
                }
            },
            j_akyrs_e = {
                name = "E",
                text = {
                    'Cards with letter {C:attention}E{}',
                    ' gives {C:mult}+#1#{} Mult each when scored',
                    '{C:inactive,s:0.8}Why did they put Markiplier\'s face on Lord Farquaad again?'
                }
            },
            j_akyrs_catchphrase = {
                name = "Catchphrase",
                text = {
                    'Cards with letter {C:attention}H{}',
                    'held in hand gives {C:mult}+#1#{} Mult each when scored',
                    '{C:inactive,s:0.8}Mung Daal tryna find shi'
                }
            },
            j_akyrs_furina = {
                name = "Furina, the Hydro Archon",
                text = {
                    'Gain {C:red}+#1#{} Discard',
                    "When hand is {C:attention}played"
                }
            },
            j_akyrs_gift_voucher = {
                name = "Gift Voucher",
                text = {
                    '{C:attention}#1#{} Cards are free in shop',
                    "{C:attention}Changes{} to a different consumable type",
                    "at the end of the round",
                }
            },
            j_akyrs_press_f = {
                name = "Press {X:grey}F{} to Pay Respect",
                text = {
                    "If {C:attention}hand{} contains",
                    "a single {C:attention}F{}, destroy it and",
                    "create an {C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} card",
                    "{C:inactive}(Must have room)",
                }
            },
            j_akyrs_ojisan_koubun = {
                name = {
                    "{f:5}お返事まだカナ？(水)おじさん構文{f:akyrs_NotoEmoji}😁❗", 
                    "{s:0.7}Ojisan Style Text",
                },
                text = {
                    "If {C:attention}first letter{} of played {C:attention}hand",
                    "matches {C:attention}last letter{}",
                    "of last played {C:attention}word{} {C:inactive}(#1#)",
                    "create a {C:attention}Double Tag",
                }
            },
            j_akyrs_sushi = {
                name = {
                    "Sushi",
                },
                text = {
                    "{C:chips}+#1#{} Chips",
                    "{C:chips}#2#{} Chips",
                    "when you {C:attention}buy{} a Joker from shop",
                }
            },
            j_akyrs_biochamber = {
                name = {
                    "Biochamber",
                },
                text = {
                    "Create a {C:attention}Nutrient",
                    "When hand is played",
                    "{C:inactive}(Must have room)",
                }
            },
            j_akyrs_nutrient = {
                name = {
                    "Nutrient",
                },
                text = {
                    "{C:white,X:chips}X#1#{} Chips",
                    "{C:white,X:chips}-X#2#{} Chips",
                    "and the end of the round",
                }
            },
            j_akyrs_shine_bright_like_a_diamond = {
                name = {
                    "Shine Bright like a Diamond",
                },
                text = {
                    "Add a permanent copy of",
                    "{C:attention}Ace{} of {C:diamonds}Diamonds{}",
                    "to every {C:attention}played{} hand",
                }
            },
            j_akyrs_so_close = {
                name = {
                    "So Close!",
                },
                text = {
                    "If hand contains a {C:attention}Two Pair",
                    "Add {C:purple}#1#%{} of Blind Size to Score",
                    "per cards held in hand",
                }
            },
            j_akyrs_snow_pea = {
                name = {
                    "Snow Pea",
                },
                text = {
                    "{C:white,X:purple}X#1#{} Score if played hand",
                    "contains {C:attention}no {C:clubs}non-Clubs{} cards",
                }
            },
            j_akyrs_konton_boogie = {
                name = {
                    "{f:5}混沌ブギ",
                    "Konton Boogie",
                },
                text = {
                    {
                        "This Joker gains {C:white,X:mult} X#1# {} Mult",
                        "per unscored card",
                    },
                    {
                        "This Joker loses {C:white,X:mult} X#2# {} Mult",
                        "if hand has {C:attention}no unscored cards",
                    },
                    {
                        "{C:inactive}(Currently {C:white,X:mult} X#3# {C:inactive} Mult)",
                    }
                }
            },
            j_akyrs_yamada_perfect = {
                name = {
                    "{f:5}山田PERFECT",
                    "Yamada Perfect",
                },
                text = {
                    {
                        "This Joker gains {C:white,X:chips} X#1# {} Chips",
                        "per scored card if played hand contains a {C:attention}Flush",
                    },
                    {
                        "This Joker loses {C:white,X:chips} X#2# {} Chips instead",
                        "per {V:1}#4#{} played",
                        "{C:inactive}Suit changes every hand",
                    },
                    {
                        "{C:inactive}(Currently {C:white,X:chips} X#3# {C:inactive} Chips)",
                    }
                }
            },
            j_akyrs_trend_angelina = {
                name = {
                    "{f:5}流行アンジェリーナ",
                    "Trend Angelina",
                },
                text = {
                    {
                        "This Joker gains {C:white,X:purple} X#1# {} Score",
                        "if played hand contains a {C:attention}Straight",
                    },
                    {
                        "This Joker loses {C:white,X:purple} X#2# {} Score",
                        "per {C:attention}duplicated ranks{} in scoring hand",
                    },
                    {
                        "{C:inactive}(Currently {C:white,X:purple} X#3# {C:inactive} Score)",
                    }
                }
            },
            j_akyrs_gappie = {
                name = {
                    "Gappie",
                },
                text = {
                    {
                        "If you have {C:blue}1{} Hand and {C:red}0{} Discards left",
                        "{C:attention}Draw{} the remaining deck",
                        "and this joker gains {C:white,X:mult} X#2# {} Mult",
                        "{C:inactive}(Currently {C:white,X:mult} X#1# {C:inactive} Mult)",
                    },
                }
            },
            j_akyrs_xaleidoscopix = {
                name = {
                    "{f:5}Xaleid◆scopiX{}",
                    "{s:0.7}xi{}",
                },
                text = {
                    {
                        "Played {C:diamonds}Diamonds{} give {X:chips,C:white} X#1# {} Chips",
                        "This Joker gains {X:chips,C:white} X#4# {} Chips",
                        "every #2# {C:inactive}(#3#){} {C:diamonds}Diamonds{} played",
                    },
                }
            },
            j_akyrs_butcher_vanity = {
                name = {
                    "BUTCHER VANITY",
                    "{s:0.7}FLAVOR FOLEY{}",
                },
                text = {
                    {
                        "Played {C:attention}Face Cards{} are split",
                        "into {C:attention}Pure Rank{} and {C:attention}Pure Suit{} cards",
                        "Pure {C:attention}Face Cards{} give {X:mult,C:white} X#1# {} Mult",
                        "when {C:attention}held in hand{}",
                    },
                }
            },
            j_akyrs_deck_shovel = {
                name = {
                    "Deck Shovel",
                },
                text = {
                    {
                        "Automatically discards {C:attention}already discarded ranks{}",
                        "{C:attention}and suits{} this hand at no cost",
                        "when {C:attention}new cards{} are drawn",
                    },
                    
                }
            },
            j_akyrs_mikudashi = {
                name = {
                    "{f:5}ミクだし",
                    "{s:0.7}[Under My Heel (MIKU dashi)] by hya"
                },
                text = {
                    {
                        "{C:hearts}Heart{} scored gives {X:chips,C:white} X#1# {} Chips each",
                        "{C:hearts}Hearts{} cannot be {C:red}discarded{}",
                    },
                    
                }
            },
            j_akyrs_companion_cube = {
                name = {
                    "Companion Cube"
                },
                text = {
                    {
                        "{C:hearts}Heart{} cards becomes {C:attention}Ash cards",
                        "{C:attention}Ash cards{} give {C:mult}+#1#{} Mult",
                    },
                }
            },
            j_akyrs_edge = {
                name = {
                    "EDGE Extended"
                },
                text = {
                    {
                        "Apply {C:dark_edition}Polychrome{} to a {C:attention}random card",
                        "every time you draw cards",
                        "if {C:attention}no {C:dark_edition}Polychrome{} is held in hand",
                    },
                }
            },
            j_akyrs_7wonders = {
                name = {
                    "7 Wonders",
                    "{s:0.8}Sakuzyo"
                },
                text = {
                    {
                        "After {C:attention}all other 7s{} in your deck were {C:attention}scored{} this round",
                        "{X:purple,C:white} X#1# {} Score on the {C:attention}last one{} that scores",
                    },
                }
            },
            j_akyrs_sulfur_cube = {
                name = {
                    "Sulfur Cube",
                },
                text = {
                    {
                        "Copy a {C:attention}random Joker{}'s ability from the collection",
                        "Changes {C:attention}at the end of the round",
                    },
                    {
                        "You can spend {C:money}#1#{} to reroll this ability"
                    }
                }
            },
        },
        Judgement = {
            judgement_akyrs_none_none = {
                name = "None",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_none_normal = {
                name = "None",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_none_kaleidoscope = {
                name = "None",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
            judgement_akyrs_miss_none = {
                name = "Miss",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_miss_normal = {
                name = "Miss",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_miss_kaleidoscope = {
                name = "Miss",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
            judgement_akyrs_good_none = {
                name = "Good",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_good_normal = {
                name = "Good",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_good_kaleidoscope = {
                name = "Good",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
            judgement_akyrs_great_none = {
                name = "Great",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_great_normal = {
                name = "Great",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_great_kaleidoscope = {
                name = "Great",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
            judgement_akyrs_perfect_none = {
                name = "Perfect",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_perfect_normal = {
                name = "Perfect",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_perfect_kaleidoscope = {
                name = "Perfect",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
            judgement_akyrs_critical_perfect_none = {
                name = "Critical Perfect",
                text = {
                    "{C:white,X:green}#1#{} Life on Playing Cards",
                    "{C:white,X:green}#2#{} Life on Jokers",
                },
            },
            judgement_akyrs_critical_perfect_normal = {
                name = "Critical Perfect",
                text = {
                    "{C:white,X:green}#1#{} Life",
                },
            },
            judgement_akyrs_critical_perfect_kaleidoscope = {
                name = "Critical Perfect",
                text = {
                    "{C:white,X:blue}#1#{} Life",
                },
            },
        },
        Partner = {
            pnr_akyrs_aikoyori = {
                
                name = "smol Aiko",
                text = {
                    "Retrigger {C:attention}every{} card {C:attention}#1#{} times",
                },
                unlock={
                    "Used {C:attention}Aikoyori",
                    "to win on {C:attention}Gold",
                    "{C:attention}Stake{} difficulty",
                },
            }
        },
        Akyrs_Dialog = {
            akyrs_balance_dialog_intro = {
                name = "", 
                text = {
                    "Hello! Thank you and Welcome to {E:akyrs_rainbow_wiggle}Aikoyori's Shenanigans{}",
                    "I am {E:2,C:dark_edition}Aikoyori{} and I will guide you through",
                    "some necessary settings. Let's get started!"
                }
            },
            akyrs_balance_dialog_intro_again = {
                name = "", 
                text = {
                    "Hello again! Since you previous",
                    "{E:akyrs_rainbow_wiggle}Aikoyori's Shenanigans{} gameplay",
                    "I have detected some {E:1,C:attention}changes{}",
                    "that needed to be addressed",
                    "Let's get it out of the way."
                }
            },
            akyrs_balance_dialog_cryptid = {
                name = "", 
                text = {
                    "Hmmm... It seems like {E:2,C:blue}Cryptid{} has been installed.",
                    "I'll go ahead and apply the {E:1,C:red}Absurd{} Balance.",
                    "If you want to change it to {E:2,C:green}Adequate{},",
                    "You can change it in the mod configuration at any time.",
                }
            },
            akyrs_balance_dialog_playbook = {
                name = "", 
                text = {
                    "Oh wow! It seems like {E:2,C:dark_edition}Playbook{} has been installed.",
                    "I'll go ahead and apply the {E:1,C:red}Absurd{} Balance.",
                    "If you want to change it to {E:2,C:green}Adequate{},",
                    "You can change it in the mod configuration at any time.",
                }
            },
            akyrs_balance_dialog_multiplayer_initialise = {
                name = "", 
                text = {
                    "Huh? {E:2,C:dark_edition}Balatro Multiplayer{} has been installed.",
                    "Due to advantageous reasons I'll go ahead and put",
                    "The game on {E:2,C:green}Adequate{} Balance.",
                    "You won't be able to change it while",
                    "{E:2,C:dark_edition}Balatro Multiplayer{} is active.",
                    "Some content also {E:2,C:dark_edition}won't be available{}",
                }
            },
            akyrs_balance_dialog_multiplayer_start_from_already_set_profile = {
                name = "", 
                text = {
                    "It seems that {E:2,C:dark_edition}Balatro Multiplayer{} has been installed.",
                    "at some point when on this {E:1,C:red}Absurd{} save file",
                    "Due to advantageous reasons I'll have to put",
                    "The game on {E:2,C:green}Adequate{} Balance.",
                    "You won't be able to change it while",
                    "{E:2,C:dark_edition}Balatro Multiplayer{} is active.",
                    "Some content also {E:2,C:dark_edition}won't be available{}",
                }
            },
            akyrs_balance_dialog_details = {
                name = "", 
                text = {
                    "This mod comes included with {E:2,C:green}Adequate{} Balance",
                    "and {E:1,C:red}Absurd{} Balance.",
                    "- {E:2,C:green}Adequate{} - The intended experience.",
                    "balanced around Vanilla but slightly more unique",
                    "- {E:1,C:red}Absurd{} (Requires Talisman or Amulet)",
                    "Bigger Number, Special Abilities, ",
                    "Crazier effects, Direr Consequences.",
                    "{C:inactive}--------------------------------------------------------",
                    "You can change these at any time in the mod settings."
                }
            },
        },
        Other={
            akyrs_self_destructs={
                name="Self-Destructive",
                text={
                    "{C:red}Self-Destructs{}",
                    "at the end of the round",
                },
            },
            akyrs_sigma={
                name="Sigma",
                text={
                    "{C:red}Unremovable{} and",
                    "{C:red}Indestructible{}",
                    "{C:inactive,s:0.8}how do i get him off",
                },
            },
            akyrs_oxidising={
                name="Oxidising",
                text={
                    "{C:red}#1#%{} chance to not trigger",
                    "Turns into {C:attention}#2#{} {C:inactive}(+#5#%){} in {C:attention}#3#{} #4#",
                },
            },
            akyrs_oxidising_full={
                name="Oxidising",
                text={
                    "{C:red}#1#%{} chance to not trigger",
                },
            },
            akyrs_attention={
                name="Attention",
                text={
                    "{C:red}Cannot be discarded{}",
                    "{C:attention}Must be played{}",
                    "{C:red}Self-destructs{} after played",
                },
            },
            akyrs_concealed={
                name="Concealed",
                text={
                    "This card's ability is {C:red}always hidden",
                },
            },
            akyrs_crystalised={
                name="Crystalised",
                text={
                    "Hand will {C:red}not score{} when played",
                    "{C:attention}Remove{} this sticker {C:attention}when played",
                },
            },
            akyrs_latticed={
                name="Latticed",
                text={
                    "{C:red}Cannot{} be sold by normal means",
                },
            },
            akyrs_sus={
                name="Sus",
                text={
                    "{C:red}Randomly{} changes either",
                    "{C:attention}suit{} or {C:attention}rank{}",
                    "at the end of the round",
                },
            },
            akyrs_sale={
                name="90% Sale",
                text={
                    "Sell value cannot change",
                },
            },
            akyrs_carmine_seal={
                name="Carmine Seal",
                text={
                    "Always undebuffed",
                    "on {C:attention}first hand{} of the round",
                },
            },
            akyrs_neon_seal={
                name="Neon Seal",
                text={
                    "Create an {C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} Card",
                    "if this card is played but {C:attention}not{} scored",
                    "{C:inactive}(Must have room)",
                },
            },
            akyrs_twin_seal={
                name="Twin Seal",
                text={
                    "Copies a {C:attention}random{} Joker's",
                    "{C:attention}main{} ability when scored",
                    "{C:inactive}(Will not copy per-card ability){}",
                },
            },
            akyrs_fault_seal={
                name="Fault Seal",
                text={
                    "{C:green}Base 1 in x{C:green,E:akyrs_exponent,s:0.7}2{C:green}chance{} to retrigger {C:attention}x{} times",
                    "where {C:attention}x{} is the number of cards played",
                    "if all cards in played hand has {C:attention}any seal{}",
                    "{C:inactive}(Currently {C:green}#1# in #2#{C:inactive} -> {C:attention}#3# {C:inactive}times)",
                },
            },
            akyrs_deformed_seal={
                name="Deformed Seal",
                text={
                    "Create a {C:attention}Self-Destructive{} copy of this card",
                    "and add it to {C:attention}played hand{} when played",
                },
            },
            akyrs_chip_mult_xchip_xmult={
                name="Gives",
                text={
                    "{C:chips}+#1#{} Chips {C:mult}+#2#{} Mult",
                    "{X:chips,C:white} X#3# {} Chips {X:mult,C:white} X#4# {} Mult",
                    "per scored card",
                },
            },
            akyrs_gain_chip_mult_xchip_xmult={
                name="Joker Gains",
                text={
                    "Joker gains",
                    "{C:chips}+#1#{} Chips {C:mult}+#2#{} Mult",
                    "{X:chips,C:white} X#3# {} Chips {X:mult,C:white} X#4# {} Mult",
                },
            },
            akyrs_tsunagite_scores={
                name="Total",
                text={
                    "Current total:",
                    "{s:1.2,C:attention}#1#{}",
                },
            },
            akyrs_tsunagite_name={
                name="Joker Name",
                text={
                    "{s:1.5}Tsunagite",
                    "{C:inactive,s:0.9}(Tsu-nah-gi-teh)"
                },
            },
            akyrs_hardcore_challenge_locked = {
                name = "Locked",
                text={
                    "Win a challenge run to unlock",
                    "Hardcore Challenge mode",
                },
            },
            undiscovered_umbral = {
                name="Not Discovered",
                text={
                    "Purchase or use",
                    "this card in an",
                    "unseeded run to",
                    "learn what it does",
                },
            },
            undiscovered_bet = {
                name="Not Discovered",
                text={
                    "Redeem this card",
                    "in an unseeded run to",
                    "learn what it does",
                },
            },
            undiscovered_replicant = {
                name="Not Discovered",
                text={
                    "Purchase or use",
                    "this card in an",
                    "unseeded run to",
                    "learn what it does",
                },
            },
            undiscovered_alphabet = {
                name="Not Discovered",
                text={
                    "Purchase or use this card",
                    "in a unseeded Letter mode run",
                    "to discover what it does",
                },
            },
            undiscovered_enchantment = {
                name="Not Discovered",
                text={
                    "Obtain Enchanted Book",
                    "or enchant something with this",
                    "in a unseeded run",
                    "to discover what it does",
                },
            },
            undiscovered_scenario = {
                name="Not Discovered",
                text={
                    "Hold or Begin this Scenario",
                    "in a unseeded run",
                    "to discover what it does",
                },
            },
            pinned_left={
                name="Pinned Left",
                text={
                    "This card stays",
                    "pinned to the",
                    "leftmost position",
                },
            },
            akyrs_pinned_right={
                name="Pinned Right",
                text={
                    "This card stays",
                    "pinned to the",
                    "rightmost position",
                },
            },
            akyrs_playing_card_suit={
                text={
                    "{V:1}#2#",
                },
            },
            akyrs_playing_card_rank={
                text={
                    "{C:light_black}#1#",
                },
            },
            akyrs_no_rank = {
                text = { "No rank" }
            },
            akyrs_no_suit = {
                text = { "No Suit" }
            },
            -- booster packs
            p_akyrs_letter_pack_normal = { 
                name = "Letter Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Alphabets{} cards to",
                    "keep for later use",
                },
            },
            p_akyrs_letter_pack_jumbo = { 
                name = "Jumbo Letter Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Alphabets{} cards to",
                    "keep for later use",
                },
            },
            p_akyrs_letter_pack_mega = { 
                name = "Mega Letter Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Alphabets{} cards to",
                    "keep for later use",
                },
            },
            p_akyrs_umbral_pack_normal = {
                name="Umbral Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} cards to",
                    "be used immediately",
                },
            },
            p_akyrs_umbral_pack_jumbo = {
                name="Jumbo Umbral Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} cards to",
                    "be used immediately",
                },
            },
            p_akyrs_umbral_pack_mega = {
                name="Mega Umbral Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} cards to",
                    "be used immediately",
                },
            },
            p_akyrs_replica_pack_normal = {
                name="Replica Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_replicant_o}Replicant{} cards to",
                    "be used immediately",
                },
            },
            p_akyrs_replica_pack_jumbo = {
                name="Jumbo Replica Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_replicant_o}Replicant{} cards to",
                    "be used immediately",
                },
            },
            p_akyrs_replica_pack_mega = {
                name="Mega Replica Pack",
                text={
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2# {C:akyrs_replicant_o}Replicant{} cards to",
                    "be used immediately",
                },
            },
            akyrs_copper_sticker={
                name="Copper Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Copper",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_inner_sticker={
                name="Inner Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Inner",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_outer_sticker={
                name="Outer Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Outer",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_lime_sticker={
                name="Lime Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Lime",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_lemon_sticker={
                name="Lemon Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Lemon",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_turquoise_sticker={
                name="Turquoise Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Turquoise",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_amethyst_sticker={
                name="Amethyst Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Amethyst",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_wooden_sticker={
                name="Wooden Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Wooden",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_bismuth_sticker={
                name="Bismuth Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Bismuth",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_high_contrast_sticker={
                name="High Contrast Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}High Contrast",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_hydrogel_sticker={
                name="Hydrogel Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Hydrogel",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_spotify_sticker={
                name="Spotify Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Spotify",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_aluminium_sticker={
                name="Aluminium Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Aluminium",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_steam_sticker={
                name="Steel Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Steam",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_netherite_sticker={
                name="Netherite Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Netherite",
                    "{C:attention}Stake{} difficulty",
                },
            },
            akyrs_doom_sticker={
                name="Doomsday Sticker",
                text={
                    "Used this Joker",
                    "to win on {C:attention}Doom",
                    "{C:attention}Stake{} difficulty",
                },
            },
        },
        Planet={
            c_akyrs_p_ara={
                name="Ara",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_crux={
                name="Crux",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_indus={
                name="Indus",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_puppis={
                name="Puppis",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_lacerta={
                name="Lacerta",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_eridanus={
                name="Eridanus",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_reticulum={
                name="Reticulum",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_horologium={
                name="Horologium",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_telescopium={
                name="Telescopium",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips",
                },
            },
            c_akyrs_p_microscopium={
                name="Microscopium",
                text={
                    "{S:0.8}({S:0.8,C:red}lvl.???{S:0.8}){} Level up",
                    "{C:attention}#1#",
                    "{C:attention} and longer hands",
                },
            },
            c_akyrs_planet_bishop_ring = {
                name="Bishop Ring",
                text={
                    "{S:0.8}({S:0.8,C:red}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}Pure Hands",
                    "Multiplier: {C:mult}#2#{} + {C:attention}#3#",
                },
            }
        },
        Scenario= {
            sc_akyrs_genesis = {
                name="Genesis",
                text={
                    "Clear {C:akyrs_scenario_dark_yellow}Light Yellow{} Scenarios",
                },
            },
            sc_akyrs_day = {
                name="Day",
                text={
                    "{C:mult}+#1#{} Mult",
                },
            },
            sc_akyrs_night = {
                name="Night",
                text={
                    "{C:chips}+#1#{} Chips",
                },
            },
            sc_akyrs_sunrise = {
                name="Sunrise",
                text={
                    "{X:mult,C:white}X#1#{} Mult",
                },
            },
            sc_akyrs_sunset = {
                name="Sunset",
                text={
                    "Gain {C:money}#1#{} every hand",
                },
            },
            sc_akyrs_high_noon = {
                name="High Noon",
                text={
                    "Create a {C:attention}Joker{}",
                    "when blind is {C:attention}selected",
                    "{C:inactive}(Must have room)",
                },
            },
            sc_akyrs_eclipse = {
                name="Eclipse",
                text={
                    "{X:blind,C:white}X#1#{} Blind Size",
                },
            },
            sc_akyrs_yellow_hatena = {
                name="Randomize Yellow",
                text={
                    "Randomize a {X:akyrs_scenario_yellow}Yellow{} Scenario",
                },
            },
            sc_akyrs_clear = {
                name="Clear",
                text={
                    "Clear {X:akyrs_scenario_dark_yellow,C:akyrs_scenario_yellow}Dark{} {X:akyrs_scenario_dark_yellow,C:akyrs_scenario_yellow}Yellow{} Scenarios",
                },
            },
            sc_akyrs_cloudy = {
                name="Cloudy",
                text={
                    "Gain {C:money}#1#{} every hand",
                },
            },
            sc_akyrs_rain = {
                name="Rain",
                text={
                    "When hand is played, {C:red}#1#{} Discards",
                    "and {C:attention}#2#{} Hand Size until the end of round"
                },
            },
            sc_akyrs_snow = {
                name="Snow",
                text={
                    "{X:chips,C:white}X#1#{} Chips",
                    "When hand is played",
                    "{C:blue}#2#{} Hand until the end of round",
                },
            },
            sc_akyrs_hail = {
                name="Hail",
                text={
                    "{C:chips}#1#{} Chips and {X:chips,C:white} X#2#{} Chips per card scored",
                },
            },
            sc_akyrs_thunder = {
                name="Thunder",
                text={
                    "Random card in hand becomes a {C:dark_edition}Charged{} {C:attention}Zap Card{}",
                },
            },
            sc_akyrs_tornado = {
                name="Tornado",
                text={
                    "Discarding discards {C:red}all{} cards in hand",
                    "{C:blue}#1#{} Hand when setting blind",
                },
            },
            sc_akyrs_void = {
                name="Void",
                text={
                    "Clear {C:akyrs_scenario_dark_pink}Light Pink{} Scenarios",
                },
            },
            sc_akyrs_plains = {
                name="Plains",
                text={
                    "Held {C:mult}Mult{} and {C:chips}Bonus{} Cards",
                    "gives {X:mult,C:white}X#1#{} Mult and {X:chips,C:white}X#2#{} Chips, respectively",
                },
            },
            sc_akyrs_forest = {
                name="Forest",
                text={
                    "Retrigger all {C:attention}Canopy{} Cards played",
                },
            },
            sc_akyrs_river = {
                name="River",
                text={
                    "{C:red}#1#{} Discard every Discard on your {C:attention}last hand",
                },
            },
            sc_akyrs_desert = {
                name="Desert",
                text={
                    "{C:money}#1#{} every round",
                    "Halves upon {C:red}discarding",
                },
            },
            sc_akyrs_city = {
                name="City",
                text={
                    "Retrigger {C:attention}every card",
                    "adjacent to {C:attention}Stone Card",
                },
            },
            sc_akyrs_underground = {
                name="Underground",
                text={
                    "{C:attention}Unscored cards{} give {X:mult,C:white}X#1#{} Mult",
                },
            },
            sc_akyrs_pink_hatena = {
                name="Randomize Pink",
                text={
                    "Randomize a {X:akyrs_scenario_pink,C:white}Pink{} Scenario",
                },
            },
            sc_akyrs_clean = {
                name="Clean",
                text={
                    "Clear {X:akyrs_scenario_dark_pink,C:white}Dark{} {X:akyrs_scenario_dark_pink,C:white}Pink{} Scenarios",
                },
            },
            sc_akyrs_purified = {
                name="Purified",
                text={
                    "Retrigger all {C:attention}Pure{} Cards",
                    "Split {C:attention}first played{} card into {C:attention}Pure Rank{}",
                    "and {C:attention}Pure Suit{} cards",
                },
            },
            sc_akyrs_dusty = {
                name="Dusty",
                text={
                    "Tags give {C:white,X:mult}X#1#{} Mult each",
                },
            },
            sc_akyrs_leaves = {
                name="Leaves",
                text={
                    "Debuff {C:attention}all{} sealed cards",
                    "{C:green}#1# in #2# chance{} to retrigger all non-sealed cards",
                },
            },
            sc_akyrs_foggy = {
                name="Foggy",
                text={
                    "{C:white,X:purple}X#1#-X#2#{} Score",
                },
            },
            sc_akyrs_smoke = {
                name="Smoke",
                text={
                    "If score is {}on fire",
                    "{C:white,X:mult}X#2#{} Mult and {C:white,X:purple}X#1#{} Score",
                    "{C:attention}until{} it isn't",
                    "{C:inactive}(Up to 100 times)",
                },
            },
        },
        Spectral={},
        Stake={
            stake_akyrs_inner = {
                name = "Inner Stake",
                text = {
                    "{C:attention}+1{} Hand Size",
                }
            },
            stake_akyrs_outer = {
                name = "Outer Stake",
                text = {
                    "{C:blue}+1{} Hand",
                }
            },
            stake_akyrs_lime = {
                name = "Lime Stake",
                text = {
                    "{C:red}X1.5{} Blind Size",
                    "{s:0.8}Applies White Stake",
                }
            },
            stake_akyrs_lemon = {
                name = "Lemon Stake",
                text = {
                    "{C:attention}Faster{} Ante Scaling",
                    "{s:0.8}Applies White Stake",
                }
            },
            stake_akyrs_turquoise = {
                name = "Turquoise Stake",
                text = {
                    "Starts with extra {C:money}$1{}",
                    "Applies Lime and Lemon Stake, together",
                }
            },
            stake_akyrs_amethyst = {
                name = "Amethyst Stake",
                text = {
                    "A random Playing Card gain a {C:attention}Crystalised{} Sticker every round",
                    "{S:0.8}(Hand will not score when played, remove sticker when played)",
                    "Start with {C:blue}+1{} Hand",
                    "{s:0.8}Applies Turquoise Stake",
                }
            },
            stake_akyrs_wooden = {
                name = "Wooden Stake",
                text = {
                    "Add a random Playing Card to deck when blind is {C:attention}selected{}",
                    "{s:0.8}Applies Amethyst Stake",
                }
            },
            stake_akyrs_bismuth = {
                name = "Bismuth Stake",
                text = {
                    "Jokers can have {C:attention}Latticed{} Sticker",
                    "{S:0.8}(Cannot be sold through normal means)",
                    "{s:0.8}Applies Wooden Stake",
                }
            },
            stake_akyrs_copper = {
                name = "Copper Stake",
                text = {
                    "Cards can have {C:attention}Oxidising{} Sticker",
                    "{s:0.8}Applies Bismuth Stake",
                }
            },
            stake_akyrs_high_contrast = {
                name = "High Contrast Stake",
                text = {
                    "{C:attention}Even faster{} Ante Scaling",
                    "{s:0.8}Applies Copper Stake",
                }
            },
            stake_akyrs_hydrogel = {
                name = "Hydrogel Stake",
                text = {
                    "A random Playing Card gain a {C:attention}Sus{} Sticker every round",                    
                    "{s:0.8}(Randomly changes either suit or rank at the end of the round)",
                    "{s:0.8}Applies High Contrast Stake",
                }
            },
            stake_akyrs_spotify = {
                name = "Spotify Stake",
                text = {
                    "A random Joker gain {C:money}Rental{} Sticker",
                    "when a {C:attention}Boss Blind{} is defeated",
                    "{s:0.8}Applies Hydrogel Stake",
                }
            },
            stake_akyrs_aluminium = {
                name = "Aluminium Stake",
                text = {
                    "{C:red}+1{} Win Ante",
                    "{s:0.8}Applies Spotify Stake",
                }
            },
            stake_akyrs_steam = {
                name = "Steam Stake",
                text = {
                    "Many cards in the shop have {C:red}Sale{} Sticker",
                    "(Lose {C:money}$0.5{} at end of round)",
                    "{s:0.8}Applies Aluminium Stake",
                }
            },
            stake_akyrs_netherite = {
                name = "Netherite Stake",
                text = {
                    "Starts with extra {C:money}$2{} and {C:red}+1{} Discard",
                    "{s:0.8}Applies Steam Stake and Gold Stake, together",
                }
            },
            stake_akyrs_doom = {
                name = "Doomsday Stake",
                text = {
                    "Cards can have {C:attention}Self-Destructive{} Sticker",
                    "{C:red}Self-Destructs{} at the end of the round",
                    "{s:0.8}Applies Netherite Stake",
                }
            },
        },
        Tag={
            tag_akyrs_spell_itself_tag={
                name="Tag that spells Tag",
                text={
                    "Gives a free",
                    "{C:blue}Mega Alphabet Pack",
                },
            },
            tag_akyrs_umbral_tag={
                name="Umbral Tag",
                text={
                    "Gives a free",
                    "{C:akyrs_umbral_p}Mega Umbral Pack",
                },
            },
            tag_akyrs_replicant_tag={
                name="Replicant Tag",
                text={
                    "Gives a free",
                    "{C:akyrs_replicant_o}Replica Pack",
                },
            },
        },
        Tarot={
            c_akyrs_wof_nopes = {
                name="The Wheel of Fortune (Modified)",
                text={
                    "Does not do anything.",
                },
            },
        },
        Bet={
            bet_akyrs_expert_play={
                name="Expert Play!",
                text={
                    "{C:attention}Expert{} and higher bosses may appear",
                    "{C:dark_edition}+#1#{} Consumable Slot",
                },
            },
            bet_akyrs_raise_the_stake={
                name="Raise the Stake!",
                text={
                    "Applies a random {C:attention}Stake{} (if possible)",
                    "Applies a random {C:dark_edition}Edition{} to a Joker",
                },
            },
            bet_akyrs_a_lock_and_a_hard_place={
                name="A Lock and a Hard Place!",
                text={
                    "A {C:attention}random{} shop item is always {C:attention}locked",
                    "It {C:attention}must be purchased{} for it to disappear",
                },
            },
            bet_akyrs_flames_of_desires={
                name="Flames of Desires!",
                text={
                    "{C:attention}Destroy{} every cards",
                    "that has a {C:attention}random{} suit from the deck",
                },
            },
            bet_akyrs_resonance_of_chaos={
                name="Resonance of Chaos!",
                text={
                    "All cards in decks has their enhancements",
                    "{C:attention}locked{} to any of the {C:attention}Note Cards",
                },
            },
            bet_akyrs_ghastly_limelight={
                name="Ghastly Limelight!",
                text={
                    "All cards in decks has their enhancements",
                    "{C:attention}locked{} to any of the {C:attention}Note Cards",
                },
            },
            bet_akyrs_kaleidoscope={
                name="Kaleidoscope!",
                text={
                    "All cards in decks has their enhancements",
                    "{C:attention}locked{} to any of the {C:attention}Note Cards",
                },
            },
        },
        Voucher={
            v_akyrs_alphabet_soup={
                name="Alphabet Soup",
                text={
                    "{C:attention}Letters{} appear on playing cards",
                    "Words can be made with playing cards",
                    "{C:akyrs_playable}+#1#{} Card Selection"
                },
            },
            v_akyrs_crossing_field={
                name="Crossing Field",
                text={
                    "{C:attention}Letters{} give {C:mult}Mult{}",
                    "based on their {C:attention}Scrabble value{}",
                    "{C:akyrs_playable}+#1#{} Card Selection"
                },
            },
            v_akyrs_banquet={
                name="Banquet",
                text={
                    "{C:akyrs_playable}+#1#{} Card Selection",
                    "{C:attention}+#1#{} Hand Size",
                },
            },
            v_akyrs_worlds_end={
                name="World's End",
                text={
                    "{C:akyrs_playable}+#1#{} Card Selection",
                    "{C:attention}+#1#{} Hand Size",
                },
            },
            v_akyrs_i_owe_you={
                name="I Owe You",
                text={
                    "{C:inactive}Jimbo's not got a lot of money right now",
                    "{C:inactive}It would genuinely help him if you give him the money",
                    "{C:inactive}Perhaps he could repay you in the future.",
                },
            },
            v_akyrs_premium_free_joker={
                name="Premium Free Joker",
                text={
                    "Allows {C:attention}3{} {C:blue}Common{} rerolls for",
                    "joker from the {C:attention}Jimbo's Chance Chicanery",
                },
            },
            v_akyrs_super_premium_free_joker={
                name="Super Premium Free Joker",
                text={
                    "Allows {C:attention}1 {C:green}guaranteed Uncommon{} roll per {C:attention}round",
                    "in {C:attention}Jimbo's Chance Chicanery",
                },
            },
            v_akyrs_ultra_premium_free_joker={
                name="Ultra Premium Free Joker",
                text={
                    "Allows {C:attention}1 {C:red}guaranteed Rare{} roll per {C:attention}ante",
                    "in {C:attention}Jimbo's Chance Chicanery",
                },
            },
        },
        AikoyoriExtraBases={
            null_card = { name = 'Null', text = { 'A simple and blank card','with nothing on it'},},
            lettersMult = {name = '',text = { '{C:mult}+#2#{} Mult'},},
            lettersXMult = {name = '',text = { '{C:white,X:mult}X#3#{} Mult'},},
            letterCardFrequency = {name = '',text = { 'Frequency: {C:attention}#4#'},},
            lettersWild = {name = 'Wild Card',text = { 'Able to be set to specific letter', 'but yields no scoring'},},
            letters = {name = 'Letter Card',text = { '{s:1.4,C:attention}#1#','Allows Words','to be played'},},
            symbols = {name = 'Symbol Card',text = { '{s:1.4,C:attention}#1#','These symbols','are used in specific circumstances'},},
            numbers = {name = 'Number Card',text = { '{s:1.4,C:attention}#1#','Allows creating','mathematical expressions'},},
        },
        Sleeve = {
            sleeve_akyrs_letter = {
                name = "Letter Sleeve",
                text = { 
                    "Start with {C:red}Letters{} Enabled",
             }
            },
            sleeve_akyrs_letter_alt = {
                name = "Letter Sleeve",
                text = { 
                    "Start with",
                    "{C:white,X:dark_edition}X#1#{} Deck Size",
                    "{C:red}+#2#{} Discards",
                    "{C:attention}+#3#{} Hand Size",
                    "{C:red}X#4#{} base Blind Size",
             }
            },
            sleeve_akyrs_letter_math_pro = {
                name = "Math Deck Pro",
                text = { 
                    "Start with additional",
                    "{C:attention}2{} sets of {C:attention}English alphabet{}",
                    "and {C:attention}4{} Equal signs",
                    "{C:blue}+#1#{} Extra Hand",
                    "{C:attention}+#2#{} Extra Hand Size",
                    "{C:red}+#3#{} Extra Discards",
             }
            },
            sleeve_akyrs_freedom={
                name="Freedom Sleeve",
				text = {
					"You can {C:attention}drag{} cards",
					"to place them anywhere.",
				},
            },
            sleeve_akyrs_freedom_alt={
                name="Ultimate Freedom",
				text = {
					"You can drag {C:attention}any{} cards",
					"to place them anywhere.",
				},
            },
            sleeve_akyrs_cry_misprint_ultima={
                name="Ultima Misprint Sleeve",
				text = {
					"Values of cards",
					"and poker hands",
					"are {C:attention}randomized{}",
                    "{C:inactive}(From X#1# to X#2#)",
                    "The challenge is to not crash the game."
				},
            },
            sleeve_akyrs_cry_misprint_ultima_alt={
                name="Ultima Misprint Sleeve+",
				text = {
					"Values of cards",
					"and poker hands",
					"are {C:attention}super randomized{}",
                    "{C:inactive}(With extra X#1# to X#2#)",
                    "The challenge is to not crash the game."
				},
            },
            sleeve_akyrs_inversion={
                name="Inversion Sleeve",
				text = {
					"Card selection is {C:attention}inverted",
				},
            },
            sleeve_akyrs_inversion_double_inverted={
                name="Double Inversion Sleeve",
				text = {
					"Card selection is {E:akyrs_snaking,C:dark_edition}doubly {C:attention}inverted",
				},
            },
        },
        Umbral = {
            c_akyrs_umbral_graduate = {
                name="Graduate",
				text = {
                    "Creates the last",
                    "{C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} card",
                    "used during this run",
                    "{s:0.8,C:akyrs_umbral_p,X:akyrs_umbral_y} Graduate {s:0.8} excluded",
				},
            },
            c_akyrs_umbral_realist = {
                name="Realist",
				text = {
                    "Enhances up to {C:attention}#1#{} selected card",
                    "into {C:attention}Insolate Cards{}",
				},
            },
            c_akyrs_umbral_tribal = {
                name="Tribal",
				text = {
                    "Create a {C:planet}Planet Card{}",
                    "for the selected {C:attention}poker hand",
                    "{C:inactive}(Selecting {C:attention}#1#{C:inactive}, creating {C:attention}#2#{C:inactive})",
				},
            },
            c_akyrs_umbral_gambit = {
                name="Gambit",
				text = {
                    "Converts up to {C:attention}#1#{} random cards",
                    "in hand into either {C:attention}Kings{}, {C:attention}Queens{}",
                    "or {C:attention}Aces{}"
				},
            },
            c_akyrs_umbral_kingpin = {
                name="Kingpin",
				text = {
                    "Adds {C:attention}#1#{} sealed {C:attention}Left-Pinned{} Kings",
                    "to hand",
				},
            },
            c_akyrs_umbral_tea_time = {
                name="Tea Time",
                text={
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "a {C:attention}random Tea Cards{}",
                },
            },
            c_akyrs_umbral_break_up = {
                name="Break Up",
                text={
                    "Splits {C:attention}#1#{} selected cards",
                    "into {C:attention}Pure Suit{} and {C:attention}Rank{} cards",
                    "{C:inactive}(If possible)"
                },
            },
            c_akyrs_umbral_public_transport = {
                name="Public Transport",
                text={
                    "Create {C:attention}#1#{} copies of",
                    "{C:attention}#2#{} selected card",
                    "with {C:attention}consecutive{} ranks",
                    "{C:inactive}(Can go in either direction)",
                },
            },
            c_akyrs_umbral_corruption = {
                name="Corruption",
                text={
                    "{C:green}50-50 chance{} to either {C:attention}duplicate",
                    "or {C:red}destroy {C:attention}half{} of the cards in your hand"
                },
            },
            c_akyrs_umbral_fomo = {
                name="Fear of Missing Out",
                text={
                    "Randomly redeem #1# {C:attention}previously unredeemed",
                    "{C:attention} Voucher {}that has {C:attention}ever appeared{}",
                    "in the shop for {C:money}$#2#{}"
                },
            },
            c_akyrs_umbral_misfortune = {
                name="Misfortune",
                text={
                    {
                        "Enhances {C:attention}#1#",
                        "selected card to",
                        "{C:attention}? Cards{}",
                    },
                    {
                        "Enhance it to {C:attention}Item Box Cards{} instead",
                        "If the Card is already {C:attention}? Card{}",
                    },
                }
            },
            c_akyrs_umbral_book_smart = {
                name="Book Smart",
                text={
                    "Create up to {C:attention}#1#{} random",
                    "{C:akyrs_umbral_p,X:akyrs_umbral_y} Umbral {} Cards",
                    "{C:inactive}(Must have room){}"
                },
            },
            c_akyrs_umbral_prisoner = {
                name="Prisoner",
                text=
                {
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "{C:attention}Brick Cards{}",
                },
            },
            c_akyrs_umbral_overgrowth = {
                name="Overgrowth",
                text=
                {
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "{C:attention}Canopy Cards{}",
                },
            },
            c_akyrs_umbral_intrusive_thoughts = {
                name="Intrusive Thoughts",
                text={
                    {
                        "{X:money,C:black}$X#1#{} but {C:green}fixed #2#% chance{} to",
                        "{E:1,C:red}Set money to #3#{}",
                    },
                    
                    {
                        "{C:attention}Sell{} this card to see {C:attention}if you would have lost money{}",
                    }
                    },
            },
            c_akyrs_umbral_weeping_angel = {
                name="Weeping Angel",
                text=
                {
                    "Temporarily {C:attention}flips all cards{} in current hand",
                    "{C:money}+$#1#{} per {C:attention}face down{} cards after flipping{}",
                },
            },
            c_akyrs_umbral_bunker = {
                name="Bunker",
                text=
                {
                    "Select {C:attention}#1#{} card in hand",
                    "to give a random {C:attention}Enhancement, Edition, Seal{} to it",
                    "but {C:attention}force{} it to be {C:attention}selected{}",
                },
            },
            c_akyrs_umbral_rock = {
                name="Rock",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {C:chips}+#1# {}Chips",
                    "to {C:attention}all cards{} in hands",
                },
            },
            c_akyrs_umbral_crust = {
                name="Crust",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {X:mult,C:white} X#1# {} Mult",
                    "to {C:attention}all {C:clubs}Clubs{} cards in hand",
                },
            },
            c_akyrs_umbral_mantle = {
                name="Mantle",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {X:chips,C:white} X#1# {} Chips",
                    "to {C:attention}all {C:spades}Spades{} cards in hand",
                },
            },
            c_akyrs_umbral_core = {
                name="Core",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {C:money}+$#1#{}",
                    "to {C:attention}all {C:hearts}Hearts{} cards in hand",
                },
            },
            c_akyrs_umbral_atmosphere = {
                name="Atmosphere",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {C:purple}+#1#{} Score",
                    "to {C:attention}all {C:diamonds}Diamonds{} cards in hand",
                    "{C:inactive}(Next use will give {C:purple}+#2#{C:inactive} Score)"
                },
            },
            c_akyrs_umbral_nyctophobia = {
                name="Nyctophobia",
                text=
                {
                    "Creates {C:attention}#1# {}random",
                    "{C:dark_edition}Negative {C:tarot}Tarot{} card",
                },
            },
            c_akyrs_umbral_puzzle = {
                name="Puzzle",
                text=
                {
                    "Select {C:attention}#1#{} cards,",
                    "apply {C:attention}Suits, Edition, and Seal {}",
                    "of the {C:attention}right{} card",
                    "into the {C:attention}left{} card",
                    "then {C:red,E:akyrs_shrivel}destroy{} the right card",
                    "{C:inactive}(Drag to rearrange)",
                },
            },
            c_akyrs_umbral_electrify= {
                name="Electrify",
                text=
                {
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "{C:attention}Zap Card{}",
                },
            },
            c_akyrs_umbral_d1 = {
                name="D1",
                text=
                {
                    "Add {C:green}#1#{} to {C:green}numerator{}",
                    "and {C:green}#2#{} to {C:green}denominator{}",
                    "to all chances {C:inactive}(if possible)",
                    "{C:inactive}(Note: Applies last)",
                },
            },
            c_akyrs_umbral_bounce= {
                name="Bounce",
                text=
                {
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "{C:attention}Net Card{}",
                },
            },
            c_akyrs_umbral_hydrate= {
                name="Hydrate",
                text=
                {
                    "Enhances {C:attention}#1#",
                    "selected card to",
                    "{C:attention}Droplet Cards{}",
                },
            },
            c_akyrs_umbral_exit_plan = {
                name="Exit Plan",
                text=
                {
                    "{C:green}#1# in #2#{} chance to",
                    "{C:attention}disable{} the blind's effect",
                },
            },
            c_akyrs_umbral_exit_plan_mp = {
                name="Exit Plan",
                text=
                {
                    "{C:green}#1# in #2#{} chance to",
                    "Gain {C:purple}#3#%{} of current",
                    "{C:attention}base blind size{} as {C:purple}score{}",
                    "{C:inactive}(Currently {C:purple}+#4#{C:inactive} Score)",
                },
            },
            c_akyrs_umbral_free_will = {
                name="Free Will",
                text=
                {
                    "{C:akyrs_playable}+#1#{} Card Selection Limit",
                },
            },
        },
        Replicant= {
            c_akyrs_replicant_forecast = {
                name = "Forecast",
                text = {
                    "Receive up to {C:attention}#1#{}",
                    "{C:akyrs_replicant_o}Replicant{} Cards",
                    "{C:inactive}(Room must be accounted for)",
                }
            },
            c_akyrs_replicant_connection = {
                name = "Connection",
                text = {
                    "Up to {C:attention}#1#{} cards are allowed be selected",
                    "to make #2# duplicates which {C:attention}differentiates",
                    "itself from the original by {C:attention}rank and suit{}",
                    "{C:purple}Crystalised{} sticker is then applied to created copies",
                }
            },
            c_akyrs_replicant_steganography = {
                name = "Steganography",
                text = {
                    "Receive up to {C:attention}#1#{}",
                    "Concealed {C:red}Rare{} Jokers",
                    "{C:inactive}(Room must be accounted for)",
                }
            },
            c_akyrs_replicant_database = {
                name = "Database",
                text = {
                    "Up to {C:attention}#1#{} random cards are selected",
                    "to {C:attention}return{} them back to deck",
                    "Temporarily receives {C:red}+#2#{} Discard",
                    "per #3# cards discarded",
                }
            },
            c_akyrs_replicant_short_form_content = {
                name = "Short Form Content",
                text = {
                    "Initiate a fight with random {C:attention}Showdown Blind {}immediately{}",
                    "{C:attention}#1#{} Ante when it is {C:attention}defeated",
                    "{C:inactive}(Must be used while selecting blind)",
                }
            },
            c_akyrs_replicant_short_form_content_mp = {
                name = "Short Form Content",
                text = {
                    "Initiate a fight with random {C:attention}Showdown Blind {}immediately{}",
                    "{C:attention}+#1#{} Life when it is {C:attention}defeated",
                    "{C:inactive}(Must be used while selecting blind)",
                }
            },
            c_akyrs_replicant_smart_home = {
                name = "Smart Home",
                text = {
                    "Cards shall be selected to create {C:attention}Poker Hand",
                    "that will be {C:attention}upgraded {}#1# times",
                    "then {C:attention}Attention{} stickers",
                    "are applied to selected cards",
                    "{C:inactive}(Selecting {C:attention}#1#{C:inactive})",
                }
            },
            c_akyrs_replicant_music_streaming = {
                name = "Music Streaming",
                text = {
                    "Up to {C:attention}#1#{} Joker may be selected",
                    "to be {C:attention}applied Perishable{}",
                    "then creates {C:attention}equal{} amount of",
                    "{C:dark_edition}Negative{} {C:spectral}Spectral{} Cards",
                }
            },
            c_akyrs_replicant_file_sharing = {
                name = "File Sharing",
                text = {
                    "Exactly {C:attention}#1#{} cards are selected",
                    "to swap places",
                }
            },
            c_akyrs_replicant_ota = {
                name = "Over-the-air",
                text = {
                    "{C:attention}#1#{} random Jokers are selected",
                    "to be {C:attention}applied Rental{}",
                    "then creates {C:attention}double{} the amount of",
                    "{C:dark_edition}Negative{} {C:spectral}Tarot{} Cards",
                }
            },
            c_akyrs_replicant_daw = {
                name = "Digital Audio Workstation",
                text = {
                    "Enhanced state of all cards in hand",
                    "are {C:attention}randomised{} into one of {C:attention}Note Cards",
                    "{C:inactive}(It is more likely to get longer notes)",
                }
            },
            c_akyrs_replicant_instant_messaging = {
                name = "Instant Messaging",
                text = {
                    "{C:attention}All cards{} in hand",
                    "will have its rank and suit {C:attention}shuffled{}",
                }
            },
            c_akyrs_replicant_enshittification = {
                name = "Enshittification",
                text = {
                    "Create a {C:dark_edition}Negative{} {C:money}Rental {C:purple}Eternal{} Joker",
                }
            },
            c_akyrs_replicant_digital_art = {
                name = "Digital Art",
                text = {
                    "Give up {C:red}#1#{} Discard Size",
                    "for permanent {C:attention}+#2#{} Hand Size",
                }
            },
            c_akyrs_replicant_common_scam = {
                name = "Common Scam",
                text = {
                    "Give up {C:red}#1#{} Play Size",
                    "for permanent {C:dark_edition}+#2#{} Joker Slot",
                    "and {C:dark_edition}+#2#{} Consumables Slot",
                }
            },
            c_akyrs_replicant_third_party_cookies = {
                name = "Third Party Cookies",
                text = {
                    "Fill your Joker slots",
                    "with Food Joker",
                    "{C:green}#1# in #2#{} chance for each",
                    "to have {C:purple}Latticed{} sticker"
                }
            },
            c_akyrs_replicant_silicon_fabrication = {
                name = "Silicon Fabrication",
                text = {
                    "Two random card in hand is",
                    "converted into {C:attention}Wafer Card{}",
                    "Another two random card in hand will have",
                    "{C:dark_edition}Charged{} applied to it",
                }
            },
            c_akyrs_replicant_get_rich_quick = {
                name="Get Rich Quick",
                text={
                    {
                        "{X:akyrs_money_x,C:akyrs_money_c}$^#1#{} but {C:green}fixed #2#% chance{} to",
                        "{E:1,C:red}Lose the run immediately{}",
                    },
                    
                    {
                        "{C:attention}Sell{} this card to see {C:attention}if you would have lost{}",
                    }
                    },
            },
        }
    },
    misc = {
        achievement_names={
            ach_akyrs_spell_aikoyori = "Unfortunately Aikoyori is not real",
            ach_akyrs_repeater_into_another_one = "Repeater Locking",
            ach_akyrs_happy_ghast_grown = "Uneasy Alliance",
            ach_akyrs_both_pickaxe = "Dual Wielding",
            ach_akyrs_win_klondike = "Back to Basics",
            ach_akyrs_spell_very_long_word = "Supercalifragilisticexpialidociousing my antidisestablishmentarianism",
            ach_akyrs_spell_long_word = "Long Live The New Fresh",
            ach_akyrs_we_no_speak_americano = "We No Speak Americano",
            ach_akyrs_resist_the_temptation = "Resist the Temptation",
            ach_akyrs_thatll_be_5_wheat = "That'll be 5 Wheat, please",
            ach_akyrs_literally_cryptid = "Literally Cryptid",
            ach_akyrs_div_0_math = "#ERR# ach_akyrs_div_0_math not found",
            ach_akyrs_average_daily_scrandle = "Average Daily Scrandle",
        },
        achievement_descriptions={
            ach_akyrs_spell_aikoyori = "Spell Aikoyori",
            ach_akyrs_repeater_into_another_one = "Channels output from a repeater into another one",
            ach_akyrs_happy_ghast_grown = "Grow a Happy Ghast from its dried form",
            ach_akyrs_both_pickaxe = "Get both pickaxes!",
            ach_akyrs_win_klondike = "Win the Klondike!",
            ach_akyrs_spell_very_long_word = "Spell a valid very long words (25+ letters) (Full Dictionary Required)",
            ach_akyrs_spell_long_word = "Spell a valid long words (12+ letters)",
            ach_akyrs_we_no_speak_americano = "Win a run of Letter Deck without spelling a single word",
            ach_akyrs_resist_the_temptation = "Win a run of Freedom Deck without the freedom part",
            ach_akyrs_thatll_be_5_wheat = "Fill your Joker slots with Emeralds",
            ach_akyrs_literally_cryptid = "Use Public Transport on cards with no ranks",
            ach_akyrs_div_0_math = "What did you think was going to happen?",
            ach_akyrs_average_daily_scrandle = "Turn a Food Joker into a Popcorn",
        },
        blind_states={},
        akyrs_balancing_wizard = {
        },
        challenge_names={
            c_akyrs_space_oddity = "Space Oddity",
            c_akyrs_4_hibanas = "Hibana for Eternity",
        },
        hardcore_challenge_names={
            hc_akyrs_spark = "Sparks",
            hc_akyrs_secured_two_factor = "Secured by 2FA",
            hc_akyrs_detroit = "Detroit",
            hc_akyrs_detroit_2 = "Detroit II",
            hc_akyrs_detroit_3 = "Detroit III",
            hc_akyrs_detroit_4 = "Detroit IV",
            hc_akyrs_detroit_5 = "Detroit: Become Human",
            hc_akyrs_half_life = "Half-Life",
            hc_akyrs_half_life_2 = "Half-Life 2",
            hc_akyrs_thin_yo_deck = "thin yo deck bro",
            hc_akyrs_thin_yo_deck_2 = "for the love of god thin your deck",
            hc_akyrs_national_debt = "National Debt",
            hc_akyrs_extra_defensive_bulwark = "Extra Defensive Bulwark",
            hc_akyrs_no_hints_here = "Knowledge Test",
            hc_akyrs_no_hints_here_gold_edition = "Close-Book Finals",
            hc_akyrs_wordle_galore = "Chain of Thoughts",
            hc_akyrs_bomb_galore = "Keep Wording and Nobody Explodes",
            hc_akyrs_hatena_jokers = "????????",
            hc_akyrs_hatena_everything = "???????????????",
            hc_akyrs_bonfire_lit = "Bonfire Lit",
        },
        collabs={},
        dictionary={
            b_umbral_cards = "Umbral Cards",
            b_replicant_cards = "Replicant Cards",
            b_scenario_cards = "Scenario Cards",
            b_alphabet_cards = "Alphabet Cards",
            k_umbral = "Umbral",
            k_replicant = "Replicant",
            k_alphabet = "Alphabet",
            k_scenario = "Scenario",
            k_bet = "Bet",
            k_enchantment = "Enchantment",

            b_akyrs_alphabets="Alphabet Cards",
            k_aikoyoriextrabases = "Extra Base",
            k_akyrs_alphabets = "Alphabet",
            k_akyrs_bet= "Bet",
            k_akyrs_enchantment= "Enchantment",
            k_akyrs_current_req = "current",
            k_akyrs_alphabets_pack = "Alphabet Pack",
            k_alphabets = "Alphabet Pack",
            k_created = "Created!",
            k_akyrs_up_to_sel = "x",
            ph_aiko_beat_puzzle = "Solve the following",
            ph_word_puzzle = "Word Puzzle",
            ph_aiko_defuse = "Get rid of",
            ph_aiko_bomb = "Word Bomb!",
            ph_akyrs_play_for = "Play for",
            k_akyrs_random_played_hand = "random played Poker Hand",
            k_akyrs_must_pay_attention = "Must have Attention Card in hand!",
            k_akyrs_must_contain_word = "Hand must contain word!",
            ph_puzzle_clear = "Puzzle Clear!",
            ph_akyrs_unknown = "???",
            k_akyrs_item_box_trigger = "?",


            akyrs_start_with = "Starts with ",
            akyrs_stored_open = "(Currently",
            akyrs_stored_close = ")",
            k_akyrs_reciprocaled = "Reciprocal'd!",
            k_akyrs_inversed = "Inverse'd!",
            k_akyrs_centrifuged = "Centrifuged!",
            k_akyrs_drawn_discard = "All Back!",
            k_akyrs_2fa_generate = "Generated!",
            k_akyrs_2fa_regen = "Code Refreshed!",
            k_akyrs_2fa_reset = "2FA Reset!",
            k_akyrs_extinguish = "Extinguished...",
            k_akyrs_burn = "Burn!",
            k_akyrs_constellation = "Constellation",
            k_words_long = "12+-letter Words",
            k_akyrs_multiple_hands = "Multiple Hands",
            k_akyrs_hibana_change = "Nanana...",
            k_akyrs_gift_change = "New Promo!",
            k_akyrs_with = "with",
            k_akyrs_credits = "Credits",
            k_akyrs_created_by = "Created by",
            k_akyrs_additional_art_by = "Featuring Arts by",
            k_akyrs_additional_help_by = "Additional Help",
            k_akyrs_drmonty_help = "for helping with balancing",
            k_akyrs_special_thanks = "Special Thanks",
            k_akyrs_cross_mods_creds = "Cross-Mod Art Credits",
            k_akyrs_please_dont_kill_me = "pleasedontkillmepleasedontkillmepleasedontkillme",
            k_akyrs_sharetest_cred_1 = "everyone who played, helped test, shared",
            k_akyrs_sharetest_cred_2 = "and made content about the mod",
            k_akyrs_thanks_you_for_playing = "and you!",
            k_akyrs_difficult = "Difficult",
            k_akyrs_dried = "Dried...",
            k_akyrs_moisture = "Moisturised!",
            k_akyrs_growth = "Growth!",
            k_akyrs_back = "Reverse!",
            k_akyrs_cinema = "Cinema!",
            k_akyrs_received = "Received",
            k_akyrs_sendoff = "Blast Off!",
            k_akyrs_yee = "Yee!",
            k_akyrs_pissandshittium = "https://pissandshittium.org/",
            k_akyrs_pandora_give_tag = "Re:MASTER 15",
            k_akyrs_pandora_hit = "Critical!",
            k_akyrs_downgrade_ex = "Downgrade!",
            k_akyrs_woah_undertale = "Woah..",
            k_akyrs_story_of_undertale = "Story of Undertale..",
            k_akyrs_value_up = "Value UP!",
            k_akyrs_ojisan = "Replied!",
            k_akyrs_gain_discard = "<SPLASH>",
            
            k_akyrs_use_from_drag = "FORCE USE",
            k_akyrs_use_from_drag_apply = "APPLY",
            k_akyrs_use_from_drag_voucher = "(Redeem)",
            k_akyrs_use_from_drag_consumable = "(Consumable)",
            k_akyrs_use_from_drag_joker = "(Initial Effect)",
            k_akyrs_use_from_drag_pcard = "(Add to Deck)",
            b_akyrs_normal_jokers = "Normal Jokers",
            b_akyrs_letter_jokers = "Letter Jokers",
            k_akyrs_ate_up = "Eaten Up!",
            b_akyrs_words = "Words",
            k_akyrs_check_word_check = "Check",


            k_akyrs_ryo_borrowed_money = "Borrowed Money...",
            k_akyrs_nijika_planet = ":D",

            k_akyrs_fps = " FPS",

            k_akyrs_random_letter = "randomly selected letter",
            k_akyrs_tsunagi_absurd_wheel_nope = "1 Miss!",
            k_akyrs_umbral_intrusive_would_die = "Lucky!",
            k_akyrs_umbral_intrusive_would_win = "Aw Dangit!",
            k_akyrs_replicant_get_rich_quick_would_die = "Lucky!",
            k_akyrs_replicant_get_rich_quick_would_win = "Aw Dangit!",
            k_akyrs_solitaire = "Klondike",

            k_akyrs_cannot_be_disabled = "Cannot Be Disabled",
            k_akyrs_cannot_be_rerolled = "Cannot Be Rerolled",
            k_akyrs_blind_difficult_expert = "Expert Blinds",
            k_akyrs_blind_difficult_master = "Master Blinds",
            k_akyrs_blind_difficult_ultima = "Ultima Blinds",
            k_akyrs_blind_difficult_remaster = "Re:Master Blinds",

            k_akyrs_confrontation_has_face_in_hand_warning = "Must not hold face cards in hand",
            k_akyrs_crystalised_warning = "Crystalised Card will make hand not score!",

            k_akyrs_title = "Aikoyori's Shenanigans",
            k_akyrs_join_akyrs_discord = "Discord (Bugs & Feedback)",

            k_akyrs_hardcore_challenge_mode = "Hardcore Challenge Mode",
            k_akyrs_hardcore_challenge_mode_flavour = "Tough and completely optional Challenges",
            k_akyrs_hardcore_challenge_mode_flavour_2 = "Unfair and unbalanced on purpose",
            k_akyrs_hardcore_challenge_mode_flavour_3  = "Not for the faint of heart",
            k_akyrs_hardcore_challenge_mode_wish_1  = "May luck be on your side should you",
            k_akyrs_hardcore_challenge_mode_wish_2  = "choose to try these.",
            k_akyrs_hardcore_challenge_mode_tip_1  = "Probably also a funny way to",
            k_akyrs_hardcore_challenge_mode_tip_2  = "test how overpowered a joker is",
            b_akyrs_hc_challenges = "Hardcore",
            b_akyrs_hc_challenges_full_txt = "Hardcore Challenges",
            k_akyrs_hardcore_challenge_difficulty = "Difficulty",

            k_akyrs_type_in_letter = "Type in a letter",
            k_akyrs_letter_btn_currently = "Currently",
            k_akyrs_word_check_init = "Type in word and Click Check!",
            k_akyrs_word_tab_reduced_tip_1 = "Expecting a word but is not valid?",
            k_akyrs_word_tab_reduced_tip_2 = "Try enabling Full Dictionary in the config!",
            k_akyrs_word_tab_reduced_tip_3 = "(At a cost of some performance)",
            k_akyrs_letter_btn_unset = "Unset",
            k_akyrs_letter_btn_auto = "Auto",
            k_akyrs_letter_btn_set = "Set",
            k_akyrs_letter_btn_swap_case = "Swap Case",
            k_akyrs_you_tried = "You tried :star:",
            k_akyrs_alphabetically = "Letter",

            k_akyrs_textbox_notice = "Due to how the game works, you'll have to",
            k_akyrs_textbox_notice_2 = "interact with the textbox for text to show up",

            k_akyrs_plus_alphabet = "+1 Alphabet Card",
            k_akyrs_plus_umbral = "+1 Umbral Card",
            k_akyrs_plus_replicant = "+1 Replicant Card",
            k_akyrs_plus_scenario = "+1 Scenario Card",

            k_akyrs_solitaire_redeal = "Redeal",

            ph_akyrs_math_score_1 = "Score within ",
            ph_akyrs_math_score_2 = "% of",
            k_akyrs_power_ante = "ante",

            k_akyrs_score_mult_pre = "X",
            k_akyrs_score_mult_append = " Score",

            k_akyrs_wild_card = "Wild Card",
            k_akyrs_kitan = "Kita~n",

            k_akyrs_copper_oxidation_stage_1 = "Unoxidised",
            k_akyrs_copper_oxidation_stage_2 = "Exposed",
            k_akyrs_copper_oxidation_stage_3 = "Weathered",
            k_akyrs_copper_oxidation_stage_4 = "Oxidised",
            k_akyrs_oxidise_ex = "Oxidised!",
            k_akyrs_scrape_ex = "Scrape!",
            k_akyrs_round_singular = "round",
            k_akyrs_round_plural = "rounds",
            k_consumable_type = "Consumable Type",

            k_akyrs_balance_dialog_intro_next = "Next",
            k_akyrs_balance_dialog_cryptid_accept = "Sounds Good. (End)",
            k_akyrs_balance_dialog_cryptid_decline = "I want to hear more!",
            k_akyrs_balance_dialog_details_next = "Alright, I'll pick...",
            k_akyrs_balance_dialog_mp_accept = "OK (End)",
            k_akyrs_balance_dialog_finish_wizard = "Let's Go! (End)",

            k_akyrs_wildcard_behaviour_txt = "Wildcards Behaviour",
            k_akyrs_config_balance_txt = "Balance",

            k_akyrs_wildcard_behaviours={
                'Automatic',
                'Force No Unset',
                'Always Manual',
                'Auto Set', 
            },
            
            k_akyrs_pure_hands = "Pure Hands",

            k_akyrs_wildcard_behaviours_description={
                {'Automatically find a letter for wildcards','which do not have letters set. (Default).'},
                {'The play button will be disabled','if you selected an unset wild card.',} ,
                {'Wildcards do not have letter assigned to them by default.','When played, will not attempt to find letters. (Can help with performance)',} ,
                {'Automatically find a letter for wildcard and','also set the letter automatically to the target if it is unset.',} 
            },

            k_akyrs_balance_selects={
                'Adequate',
                'Absurd',
            },
            
            k_akyrs_balance_selects_no_talisman={
                'Adequate',
            },
            
            k_akyrs_balance_dialog_adequate_text = "Adequate",
            k_akyrs_balance_dialog_adequate_description = "Balanced towards Vanilla",
            k_akyrs_balance_dialog_absurd_text = "Absurd",
            k_akyrs_balance_dialog_absurd_description = "(Requires Talisman/Amulet) Bigger Number, Crazier effects, Direr Consequences.",
            
            k_akyrs_card_preview = "Enable Card Previews",
            k_akyrs_toggle_crt = "Enable CRT Shaders",
            k_akyrs_restart_required = "Options with * means restart is required",
            k_akyrs_toggle_full_dictionary = "Enable Full Dictionary*",
            k_akyrs_toggle_experimental_feature = "Enable Experimental Features*",
            k_akyrs_toggle_colourblind_ui = "High Contrast UI",
            k_akyrs_emerald = "Emerald",
            k_akyrs_supercommon = "Supercommon",
            k_akyrs_unique = "Unique",
            k_akyrs_alphabet_pack = "Alphabets",
            k_akyrs_umbral_pack = "Umbral Pack",
            k_akyrs_replica_pack = "Replica Pack",

            b_bet = "Bets",
            b_judgement = "Judgements",
            b_enchantment = "Enchantments",
            b_scenario = "Scenarios",



            k_akyrs_shoveled_ex = "Shoveled!",
            k_akyrs_canopy_downable_yes = "Active!",
            k_akyrs_canopy_downable_no = "Activated",
            k_akyrs_cloud_card_tally = "Cloud Cards",
            k_akyrs_cloud_card_tally_buffed = "Cloudy Day",
            k_akyrs_desert_money = "Desert Well",

            k_akyrs_not_used = "Not used",
            k_akyrs_used = "Used",


            k_akyrs_shop_close = "Close",

            k_akyrs_chicanery_round = "This Round",
            k_akyrs_chicanery_ante = "This Ante",
            k_akyrs_chicanery_rolls_common = "Common",
            k_akyrs_chicanery_rolls_uncommon = "Uncommon",
            k_akyrs_chicanery_rolls_rare = "Rare",
            k_akyrs_chicanery_rolls_common_arrows = "▲",
            k_akyrs_chicanery_rolls_uncommon_arrows = "",
            k_akyrs_chicanery_rolls_rare_arrows = "",
            k_akyrs_chicanery_rolls_left="Rolls Left",
            k_akyrs_chicanery_buy="BUY",
            k_akyrs_chicanery_btn="J",

            k_akyrs_enchantment_none="Allows multiple abilities to be added",
            k_akyrs_enchantment_none_blank="None :(",
            k_akyrs_edge_prism="<PRISM>",

            f_akyrs_localize_enchantment_level = function (level)
                if math.abs(level) > 3999 then
                    return level > 0 and "+INF" or "-INF"
                end
                if level == 0 then return "0" end
                local strout = level > 0 and "" or "-"
                local ones        = { "", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"}
                local tenths      = { "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"}
                local hundredths  = { "", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"}
                local thousandths = { "", "M", "MM", "MMM", "M?", "?", "?M", "?MM", "?MMM", "M?"}
                local places = { thousandths, hundredths, tenths, ones }
                for i, v in ipairs({1000,100,10,1}) do
                    strout = strout .. places[i][math.floor(math.fmod(math.abs(level), v * 10) / v) + 1]
                end
                return strout
            end
        },
        high_scores={},
        labels={
            akyrs_self_destructs="Self-Destructive",
            akyrs_pinned_right=">> Pinned >>",
            pinned_left="<< Pinned <<",
            akyrs_sigma="Sigma",
            akyrs_oxidising="Oxidising",
            akyrs_attention="Attention",
            akyrs_concealed="Concealed",
            akyrs_crystalised="Crystalised",
            akyrs_latticed="Latticed",
            akyrs_sus="Sus",
            akyrs_sale="90% Sale",
            akyrs_carmine_seal="Carmine Seal",
            akyrs_neon_seal="Neon Seal",
            akyrs_twin_seal="Twin Seal",
            akyrs_fault_seal="Fault Seal",
            akyrs_deformed_seal="Deformed Seal",
            akyrs_texelated = "Texelated",
            akyrs_noire = "Noire",
            akyrs_sliced = "Sliced",
            akyrs_burnt = "Burnt",
            akyrs_charged = "Charged",
            akyrs_enchanted = "Enchanted",
            k_akyrs_emerald = "Emerald",
            k_akyrs_supercommon = "Supercommon",
            k_akyrs_unique = "Unique",
            k_fakecenter = "???",
            umbral = "Umbral",
            replicant = "Replicant",
            scenario = "Scenario",
            alphabet = "Alphabet",
            enchantment = "Enchantment",
            bet = "Bet"
        },
        akyrs_colour = {
            yellow = "Yellow",
            pink = "Pink",
            blue = "Blue",
            dark = "Dark",
            light = "Light",
            none = "???",
        },
        poker_hand_descriptions=poker_hand_desc,
        poker_hands=poker_hands_name,
        quips={},
        ranks={
            akyrs_non_playing = "A kind"
        },
        suits_plural={
            akyrs_joker = "Jokers",
            akyrs_consumable = "Consumables",
            akyrs_booster = "Boosters",
            akyrs_voucher = "Vouchers",
            akyrs_thing = "Something"
        },
        suits_singular={
            akyrs_joker = "Joker",
            akyrs_consumable = "Consumable",
            akyrs_booster = "Booster",
            akyrs_voucher = "Vouchers",
            akyrs_thing = "Something"
        },
        tutorial={},
        v_dictionary={
            k_akyrs_pure="Pure #1#",
            k_akyrs_score_add="+#1# Score",
            k_akyrs_score_x="X#1# Score",
            k_akyrs_score_exp="^#1# Score",
            ph_akyrs_hand="#1# Hand",
            ph_akyrs_hands="#1# Hands",
            k_akyrs_score_minus="-#1# Score",
            k_akyrs_word_check_valid="#1# is a VALID word!",
            k_akyrs_word_check_invalid="#1# is NOT a VALID word.",
            k_akyrs_click_for_credits_of="Click to view credits for #1#",
            k_akyrs_chicanery_rolls_left="#1#/#2# Rolls Left",
            k_akyrs_enchantment_lvl="#1# Lv.#2#",
            k_akyrs_enchantment_lvl_single_level="#1#",
        },
        akyrs_misc = {
            mod_label = {
                {"Aikoyori's","Shenanigans"},
                {"Aikoyori's","Shinigimas"},
                {"Aikoshen"},
                {"The Shenanigans of Aikoyori"},
                {"mr shenanigans' aikoyori"},
                {"Aikoyori's Jokers"},
                {"AKYRS"},
                {"Aikomod"},
                {"New Super","Aikoyori Shenanigans"},
                {"An Aikoyori Mod"},
                {"Shenaiko"},
                {"Aikoslop","Shenslop"},
                {"Shenanigan","Aikoyori's"},
                {"Steal the","Aikoshen"},
                {"Aikoyori the Movie:","The Game: The Mod"},
                {"iroyokia's","playbook real"},
                {"aish"},
                {"The Wacky","and Wonderous Shenanigans","in the world of Aikoyori"},
                {"Solitaireyori","Wordlenanigans"},
                {"{f:5}アイコヨリ","{f:5}しぇなにがんす"},
                {"aiko?"},
            },
            flavour_text = {
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
                {"don't try Cold Beans...?",},
                {"also try Paya's Terrible Additions",},
                {"also try Entropy",},
                {"also try Revo's Vault",},
                {"also try Oblivion",},
                {"You were used up.",},
                {"{f:5}どうしてこんな目に に に",},
                {"{f:5}限界まで足掻いた人生は","{f:5}想像よりも狂っているらしい", },
                {"{f:5}スーパーアイドルの笑顔よりも",},
                {"{f:5}あの八月の午後よりも",},
                {"{f:5}105℃のより光る君へ",},
                {"Not to get political but","what the fuck is an oatmeal",},
                {"In Alpha for a year!",},
                {"Blindmaxxing Consumablepilled",},
                {"Did you do your Wordle today?",},
                {"Gamified Video",},
                {"Cryptid got nothing on me",},
                {"keys cow",},
                {"Did you know that I can","absolutely put anything here?",},
                {"Imagine doing all of this","and then have a mod crash lol",},
                {"Don't divide by 0!",},
                {"Probably a great tool for STEM!",},
                {"{X:dark_edition,C:white}^2{} Fun when played",},
                {"\\#StopAIslop",},
                {"\\#StopGenAIinVocaloid",},
                {"Art by real artists!",},
                {"& Knuckles",},
                {"New FUNKY Mode",},
                {"featuring Dante from DMC",},
                {"it sure happened",},
                {"Will not appear in Deltarune",},
                {"{X:red,C:white}??",},
                {"\\#BringBackWotakuSnoozeSHIKIver",},
                {"Driving in my car, right after a beer",},
                {"*freedom motif*",},
                {"You can't find your hands.",},
                {"Did you know that this actually supports","multiline flavour text?", "I'm honestly shocked!"},
                {"Are you a cute fraud?"},
                {"Contains some Britishness..."},
                {"hashire hashire umamusume"},
                {"contains some references!"},
                {"look behind you."},
                {"As seen on (Twitch.)TV!"},
                {"And we're (not) out of beta", "we're (never) releasing on time"},
                {"Harikitte Ikou!"},
                {"catgirls are the best","{s:0.6}ivy said it not me"},
                {"Re:Re:MASTER 15+"},
                {"it's so sad Steve Jobs died of ligma","Who's Steve Jobs?","Ligma Balls."},
                {"Be proud of your death count!"},
                {"BE CRIME DO GAY",} ,
                {"*NAVAL INVASION ALERT*",},
                {"x = (-b[+/-]sqrt((b^2)-4ac))/2a",},
                {"Release the Mona clones!"},
                {"hop on synthv"},
                {"{f:akyrs_MochiyPopOne}「[疑]ロキ」簡単w"},
                {"\\#downwiththeimposter",},
                {"lowk why does that one guy in family guy", "look like peter griffin"},
                {"He is only 20 years old."},
                {"fuuuck dude this mod cost so much money im so fucked"},
                {"one of my friends call me Michael Jordan"},
                {"Watch Cosmic Princess Kaguya!"},
                {"yuri > yaoi lowk"},
                {"Spotify is evil"},
                {"collect my pages"},
                {"What do you call a mod that's", "complete 180 from Vanilla?"},
                {"what the fuck? aiko this is your 6th redesign"},
                {"*wheeze*"},
                {"... ___ ... (sad face)"},
                {"ts pmo icl"},
            }
        },
        v_text={
            ch_c_sliced_space={
                "Start run with a {C:dark_edition}Sliced{} Space Joker",
            },
            ch_c_akyrs_half_debuff={
                "{C:attention}Half{} of your undebuffed cards are permanently debuffed every round",
            },
            ch_c_akyrs_half_self_destruct={
                "{C:attention}Half{} of everything you have gain {C:red,T:self_destructs}Self-Destruct Sticker{} every round"
            },
            ch_c_akyrs_no_tarot_except_twof={
                "No {C:tarot}Tarot{} Cards will spawn except {C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{}",
            },
            ch_c_akyrs_no_tarot={
                "No {C:tarot}Tarot{} Cards will spawn",
            },
            ch_c_akyrs_no_planet={
                "No {C:planet}Planet{} Cards will spawn",
            },
            ch_c_akyrs_no_jokers={
                "No {C:red}Jokers{} will spawn",
            },
            ch_c_akyrs_all_cards_are_stone={
                "All cards are {C:purple}Stone{} cards",
            },
            ch_c_akyrs_allow_duplicates={
                "{C:attention}Duplicates{} can spawn",
            },
            ch_c_akyrs_idea_by_astrapboy={
                "Idea by {C:attention}astrapboy",
            },
            ch_c_akyrs_idea_by_missingnumber={
                "Idea by {C:attention}missingnumber",
            },
            ch_c_akyrs_idea_by_saharabat={
                "Idea by {C:attention}saharabat",
            },
            ch_c_akyrs_no_hints={
                "{C:attention}All tooltips{} are {C:red}hidden",
            },
            ch_c_akyrs_start_with_letter_deck={
                "Play with {C:attention,T:b_akyrs_letter_deck}Letter Deck",
            },
            ch_c_akyrs_no_skips={
                "{C:attention}Skipping Blinds{} are {C:red}not allowed",
            },
            ch_c_akyrs_all_blinds_are={
                "{C:attention}All Blinds{} are {C:attention}#1#",
            },
            ch_c_akyrs_hatena_deck={
                "{C:attention}All Jokers{} are {C:red}concealed",
            },
            ch_c_akyrs_hatena_everything={
                "{C:attention}All cards{} are {C:red}concealed",
            },
            ch_c_akyrs_always_skip_shops={
                "{C:attention}Shops{} are {C:red}skipped",
            },
            ch_c_akyrs_shops_after_boss={
                "{C:attention}Shops{} only appear after {C:red}Boss Blinds",
            },
            ch_c_akyrs_obtain_every_round={
                "{C:attention}Obtain{} a {C:attention}#1#{} every round",
            },
        },
    },
}