

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
                    "but {C:blue}+#3#{} Hand Size", 
                    "you only have {C:red}1 hand{}",
                    "{C:red}X#1#{} base Blind Size",
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
            dd_akyrs_tldr_tldr={
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
            dd_akyrs_mukuroju_en = {
                name = "Mukuroju no Hakamori",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "per {C:tarot}The Star{} used",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                }
            },
            dd_akyrs_mukuroju_en_absurd = {
                name = "Mukuroju no Hakamori",
                text = { 
                    "This Joker {C:attention}octuples{} ({X:mult,C:white} X8 {})",
                    "its {X:mult,C:white} XMult {} every time {C:tarot}The Star{} is used",
                    "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
                }
            },
            dd_akyrs_nhh_cryptid = {
                name = "If Cryptid is installed...",
                text = { 
                    "Gives {X:dark_edition,C:white} ^#1# {} Mult instead",
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
            dd_akyrs_break_up_tip  = {
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
            dd_akyrs_break_up_tip_no_preview  = {
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
                    "This card is {C:attention}completely{} unknown",
                    "{C:inactive}(and you will never know what it is)",
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
            e_akyrs_dyed = {
                name = "Dyed",
                text = {
                    "{C:purple}+#1#{} Score",
                    "Gain {C:purple}+#2#{} every trigger",
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
                    "[WIP]",
                }
            },
        },
        Enchantment = {
            ench_akyrs_unbreaking = {
                name="Unbreaking",
                text={
                    "When this card gets {C:attention}destroyed{}",
                    "{C:attention}Fixed {C:green}#1#%{} chance to",
                    "duplicate this card",
                },
            },
            ench_akyrs_effeciency = {
                name="Efficiency",
                text={
                    "When this card gets {C:attention}destroyed{}",
                    "{C:attention}Fixed {C:green}#1#%{} chance to",
                    "duplicate this card",
                },
            },
        },
        Enhanced={
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
                    "{C:green}#2# in #3#{} chance",
                    "of disintegrating into nothing",
                    "at the end of the round"
                },
            },
            m_akyrs_ash_card_absurd = {
                name="Ash Card",
                text={
                    "{C:purple,X:edition} ^#1# {} Chips",
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
                    "Reduce the rank of this card by {C:attention}1{}",
                    "if {C:attention}held in hand{} after scoring",
                }
            },
            m_akyrs_thai_tea_card = {
                name = "Thai Tea Card",
                text = {
                    "{X:mult,C:white} X#1# {} Mult",
                    "{C:inactive,s:0.8}The {s:0.8}absurd{C:inactive,s:0.8}ly good smell of it {s:0.8}alone",
                    "{C:inactive,s:0.8}is sure to make any {s:0.8}Mouth{s:0.8} water{C:inactive,s:0.8}s" 

                }
            },
            m_akyrs_matcha_card = {
                name = "Matcha Card",
                text = {
                    "{X:chips,C:white} X#1# {} Chips",
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
                    "on first hand of round",
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
            j_akyrs_redstone_repeater_absurd = {
                name = "Redstone Repeater",
                text = { "Swaps the current {C:white,X:mult} Mult {} value", "with the stored {C:mult}Mult",
                "then {C:white,X:dark_edition} ^#2# {} Mult", 
                        -- "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
                    --"{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}" 
                    }
            },
            j_akyrs_observer = {
                name = "Observer",
                text = { "This Joker gains {C:mult}#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                    "a card gets triggered.",
                    "{s:0.8}Times needed increases by {C:attention}#5#{}",
                    "{s:0.8}every time this Joker gains {C:mult}Mult{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}" }
            },
            j_akyrs_observer_absurd = {
                name = "Observer",
                text = { "This Joker gains {X:mult,C:white} X#1# {} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                    "{C:chips}Chips{} or {C:mult}Mult{} value changes",
                    "{s:0.8}Times needed increases by {C:attention}#5#{}",
                    "{s:0.8}every time this Joker gains {X:mult,C:white}XMult{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}" 
                }
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
            j_akyrs_quasi_connectivity_absurd = {
                name = "Quasi Connectivity",
                text = { "{C:white,X:dark_edition} ^#1# {} Mult", 
                    "Disables two {C:attention}random Jokers{}",
                    "after a hand is played",
                    "{s:0.8}Debuffs itself if you have",
                    "{s:0.8}2 Jokers or less"
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
            j_akyrs_diamond_pickaxe_absurd = {
                name = "Diamond Pickaxe",
                text = {
                    "After a hand is played, turn {C:attention}all{} cards",
                    "you held into {C:attention}Stone Card{}",
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Card scored",
                    "and change every scored {C:attention}Stone{} card",
                    "to a random {C:attention}non-Stone Upgrades{}",
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
            j_akyrs_netherite_pickaxe_absurd = {
                name = "Netherite Pickaxe",
                text = {
                    "Turn {C:attention}all Discarded{} cards",
                    "into {C:attention}Stone Cards{}",
                    "Gains {C:attention}#2#{} stacks of {X:chips,C:white} X#1# {} Chips",
                    "for every {C:attention}Stone{} Card scored",
                    "{C:red,E:1}Destroy all scored",
                    "{C:attention,E:1}Stone{C:red,E:1} cards afterwards",
                    "{C:inactive}(Currently {X:chips,C:white} X#3# {C:inactive} Chips){}" 
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
            j_akyrs_it_is_forbidden_to_dog_absurd = {
                name = "It is forbidden to dog",
                text = { 
                    "{C:attention}Unscored{} played cards",
                    "give {X:dark_edition,C:white} ^#1#{} Mult each",
                    "{C:attention}All{} unscored cards becomes {C:attention}Scoreless{}",
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
            j_akyrs_eat_pant_absurd = {
                name = "eat pant",
                text = { 
                    "If played hand contains a {C:attention}Two Pair{}",
                    "This joker gains {X:mult,C:white} X#2# {} Mult for every scored card",
                    "{C:red}Destroys all played cards{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                }
            },
            j_akyrs_tsunagite = {
                name = "{f:5,C:akyrs_luminous}系ぎて",
                text = { 
                    "Played cards permanently gain {X:mult,C:white} X#2#{} Mult",
                    "if played cards' {C:chips}chips{} is divisible by {C:attention}#1#"
                }
            },
            j_akyrs_tsunagite_absurd = {
                name = "{f:5,C:akyrs_luminous}系ぎて{}",
                text = { 
                    "Gives value listed",
                    "Joker gain the value listed",
                    "When a {C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} is used",
                    "{C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} always fails",
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
                        "In the immersive and strategic world of {C:attention,E:1,s:1.5}Balatro{}, a distinctive role is played by this special joker card,",
                        "equipped with a potent ability known as the '{C:mult}+#1#{} Mult.' This ability dramatically enhances a player's score",
                        "under specific conditions, primarily centered around the presence of any {C:attention}High Card{} in the hand, which includes",
                        "but is not limited to traditional {C:attention}high-ranking cards{} like {C:attention}Aces, Kings, Queens, and Jacks.{}",
                        "Even then, the ability of this card goes further. But let's not get ahead of ourselves by going through with it before learning that",
                        "{C:attention,E:1,s:1.5}Balatro{} expands the definition of scoring to include key strategic cards that heighten gameplay impact.",
                        "This transformative {C:mult}multiplier{} is not just an advantage but a central aspect of strategic planning in {C:attention,E:1,s:1.5}Balatro{}.",
                        "It compels players to consider their hand composition carefully, aiming to incorporate {C:attention}High Cards{} and maximize benefits.",
                        "Delving into the history of gambling, card games have been a corner{C:tarot}stone{} of gaming culture for centuries.",
                        "by {C:attention}activating for every card in hand and at play{}, this ability ensures you will gain a high score by merely playing a {C:attention}High Card{}.",
                        "From the ancient {C:white,X:red,f:4}中国人{} who are credited with inventing playing cards in the {C:attention}9th century{} to the spread of card",
                        "games across Europe during the {C:chips}Middle Ages{}, gambling has evolved into a sophisticated form of entertainment and strategy.",
                        "The concept of {C:mult}multipliers{}, like the '{C:mult}+#1#{} Mult' in {C:attention,E:1,s:1.5}Balatro{}, echoes innovations in probability and risk-taking found",
                        "throughout gambling history, where players sharpened their skills to navigate the {C:green}uncertainties of chance.{}",
                        "These elements of chance and strategy create a rich tapestry of gameplay where players harness both their intuition and",
                        "analytical abilities. The presence of the '{C:mult}+#1#{} Mult' deepens {C:attention,E:1,s:1.5}Balatro{}'s complexity, fostering a richly engaging",
                        "environment where tactical decision-making is crucial. Players dynamically shift the game balance by leveraging the {C:mult}multiplier{},",
                        "turning potential {C:chips}deficits{} into {C:dark_edition,E:1}commanding leads{}. Thus, the '{C:mult}+#1#{} Mult' feature isn't merely a rule but a critical",
                        "strategic tool and an exhilarating element.",
                }
            },
            j_akyrs_tldr_joker_absurd = {
                name = "TL;DR Joker",
                text = {
                    "In the beginning, there was {C:attention,E:1,s:1.1}Balatro{} - not a deity, but something more complex - an ever-shuffling embodiment of {C:akyrs_playable}chaos{} wrapped in crisp, digital playing cards. The game exists",
                    "in a liminal space between logic and {C:tarot}lunacy{}, math and mirage, where {C:green}probability{} becomes pliable and poker mutates into myth with each {C:blue}hand{}. In {C:attention,E:1,s:1.1}Balatro{}, one doesn’t merely {E:2,C:attention}play{}",
                    "poker. One communes with the improbable. Here, {C:attention}straights{} stretch into the surreal, and {C:attention}flushes whisper forbidden geometry. {C:akyrs_playable}The{} deck is alive, vibrating with potential energy",
                    "and pixelated menace, as every draw feels like yanking {C:attention}Ceremonial Dagger{} from a haunted {C:attention}Mega Buffoon Pack{}. And looming large above the fray is the pantheon of the unholy: the",
                    "Jokers. They are not jesters; they are gods. Mathematical spirits dressed as {C:akyrs_playable}clown{}s. Each Joker bends the rules, breaks them, and sometimes eats them whole, fueling strategies",
                    "built on hubris, spreadsheets, and primal instinct alike. Enter the {C:attention}TL;DR Joker{}, a Joker whispered of in halls of madness and theory: a rectangular rune inscribed with a",
                    "singular prophecy: “{C:white,X:mult} X#1# {} Mult if hand contains a high card” It is simple. It is divine. It is arbitrarily brilliant. Why {C:white,X:mult} X#1# {}? Why not {C:white,X:mult} X1.19542 {} Mult? Or {C:white,X:mult} X638.95 {}? Or {C:white,X:mult,f:6} Xπ {}",
                    "Mult? Because {C:white,X:mult} X#1# {} is the sacred number of drama. Because three is the number of the holy sprit,  {C:attention}face cards{}, triangles in triforce, wheels on tricycles. Because to look upon a",
                    "hand and see a {C:attention}King{}, and be told, {C:attention,E:1}“You may multiply,”{} is to witness design at the intersection of {C:akyrs_playable}chaos{} theory and stylish arrogance. The {C:attention}TL;DR Joker{} does not beg for synergy.",
                    "It {C:attention}demands{} reverence and vigilance. It turns high cards into sacred relics, their mere presence {C:spectral}summoning{} power. No longer are {C:attention}Jacks{} just teenage nobility in a velvet blazer of",
                    "mid-value. Now they are conduits of cosmic {C:white,X:mult} XMult {}, bridges to {C:dark_edition}exponentia{}l escalation. And let us speak plainly of {C:attention}“high cards”{} - those royal specters of cardboard rank. The",
                    "{C:attention}Jack{}, swaggering in adolescent cunning. The {C:attention}Queen{}, dangerous and divine. The {C:attention}King{}, a heavy-headed monarch wielding {C:attention}tax{} burdens and {C:white,X:mult} XMult {}ipliers alike. And the {C:attention}Ace{} -",
                    "ambiguous, adaptable, alpha and omega, god-tier wildness incarnate. To draw one is {C:tarot}lucky{}. To play one is strategy. To combine one with {C:attention}TL;DR Joker{} is to summon an equation so",
                    "violent, it punches through the spreadsheet matrix. It’s not just a combo. It’s a lifestyle. A statement. A mathematical swagger. Decks warp around it. You start seeking",
                    "{C:attention}royalty{} not out of vanity, but devotion. The {C:hearts}hearts{} beat faster. The {C:spades}spades{} dig deeper. The {C:diamonds}diamonds{} glint with purpose. Even the {C:clubs}clubs{}, usually so brutish, now {C:attention}shimmer{} with",
                    "refined potential. Every draw becomes a prayer: please, let it be a {C:attention}Queen{}. Or a {C:attention}King{}. Or her {C:attention}Jack{}. Because even if the poker hand is garbage, a single face card sanctifies it.",
                    "{C:attention,E:1,s:1.1}Balatro{} becomes not a game of best hands, but of best {C:attention}conditions{} for value. A trash hand with a King is not trash - it’s a {C:white,X:mult} X#1# {}-fueled engine of consequence. Let us now wander",
                    "backward in time - centuries before Jokers, before {C:attention,E:1,s:1.1}Balatro{}, before silicon and CPUs - back to 9th century {C:white,X:red,f:4}中国{}, where {C:attention}playing cards{} began. There, amid scrolls and shadow puppets,",
                    "the corner{C:tarot}stone{} of gaming was born. The uncertainty of paper, the dance of fate inked in {C:attention}characters{} and calligraphy. In that world, {C:green}luck{} was not an {C:attention}adversary{} - it was an",
                    "{C:attention}elemental truth{}. {C:green}Dice{} were cast not for control, but for communion with the unknown. Chance was worshipped as a muse, not solved as a math problem. And so too, in {C:attention,E:1,s:1.1}Balatro{}, do",
                    "we feel this ancient reverence for uncertainty. The {C:attention}TL;DR Joker{}, in its modern mask, is ancestor to those ancient principles. It is the phoenix feather embedded in a digital",
                    "deck, the whisper of dynasties. It reminds us that no matter how far we've come - from silk cards to OLED screens - we are still haunted and humbled by the {C:green}uncertainties of",
                    "chance{}. So when we draw a {C:attention}high card{}, and {C:attention}TL;DR Joker{} flickers into being, we do not merely multiply - we {C:attention}invoke{} the ancient. The timeless. The chaotic. We become both",
                    "strategist and supplicant, mathematician and {C:red}myst{}ic. The run ends. The screen fades. The Joker remains. {C:attention}TL;DR Joker{}. {C:attention}High cards{}. High stakes. High living. It is not just a",
                    "mechanic. It is a metaphor. {C:attention,E:1,s:1.1}Balatro{} teaches that success is built not only on full hands, but on full {C:hearts}hearts{}. Sometimes, all it takes is a King - and a Joker who notices"
                }
            },
            j_akyrs_reciprocal_joker = {
                name = "Reciprocal Joker",
                text = { 
                    "Set {X:mult,C:white}Mult{} to",
                    "{X:chips,C:white}Chips{} divided by {X:mult,C:white}Mult{}",
                }
            },
            j_akyrs_reciprocal_joker_absurd = {
                name = "Reciprocal Joker",
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
            j_akyrs_2fa_absurd = {
                name = "Two-Factor Authentication",
                text = { 
                    "{C:attention}All Played Cards'{} Rank",
                    "and Suit are {C:attention}randomized{} after scoring",
                    "Gains {X:chips,C:white} X#1# {} Chips if rank stays the same",
                    "Gains {X:mult,C:white} X#2# {} Mult if suit stays the same",
                    "{C:inactive}(Currently {X:chips,C:white} X#3# {C:inactive} Chips",
                    "{C:inactive}and {X:mult,C:white} X#4# {C:inactive} Mult)",
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
            j_akyrs_gaslighting_absurd = {
                name = "Gaslighting",
                text = { 
                    "{C:edition,X:dark_edition,s:1.1} ^^#1# {} Mult",
                    "{C:attention}Definitely won't make you lose.",
                    "{C:inactive,s:0.6}You're just imagining things about me having",
                    "{C:inactive,s:0.6}#3# in #4# chance to give {X:inactive,C:white,s:0.6} ^^#2# {C:inactive,s:0.6} Mult instead",
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
            j_akyrs_centrifuge_absurd = {
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
            j_akyrs_henohenomoheji_absurd = {
                name = "Henohenomoheji",
                text = { 
                    "Cards with Letter {C:attention}K{}, {C:attention}Q{}, and {C:attention}J",
                    "are considered as {C:attention}Kings{}, {C:attention}Queens{},",
                    "and {C:attention}Jacks{} respectively",
                }
            },
            j_akyrs_neurosama = {
                name = "Neuro Sama",
                text = { 
                    {
                        "If hand {C:attention}DOES NOT{} contain a {C:attention}Flush",
                    },
                    {
                        "This Joker gains {X:mult,C:white} X#2# {} Mult",
                        "for every {C:hearts}Hearts{} scored",
                    },
                    {
                        
                        "If {T:j_akyrs_evilneuro,C:red}Evil Neuro{} is present,",
                        "also gains {X:mult,C:white} X#2# {} Mult",
                        "for every {C:spades}Spades{} scored",
                    },
                    {
                        "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
                    }
                }
            },
            j_akyrs_neurosama_absurd = {
                name = "Neuro Sama",
                text = { 
                    {
                        "If hand {C:attention}DOES NOT{} contain a {C:attention}Flush",
                    },
                    {
                        "This Joker {C:attention}multiplies{} its {X:mult,C:white}XMult{} by {X:mult,C:white} X#2# {}",
                        "for every {C:hearts}Hearts{} scored",
                    },{
                        "If {T:j_akyrs_evilneuro,C:red}Evil Neuro{} is present,",
                        "also {C:attention}multiplies{} its {X:mult,C:white}XMult{} by {X:mult,C:white} X#2# {}",
                        "for every {C:spades}Spades{} scored",
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
                        "If hand {C:attention}DOES NOT{} contain a {C:attention}Flush",
                    },
                    {
                        "This Joker gains {X:chips,C:white} X#2# {} Chips",
                        "for every {C:clubs}Clubs{} scored",
                    },
                        {
                        "If {T:j_akyrs_neurosama,C:red}Neuro Sama{} is present,",
                        "also gains {X:chips,C:white} X#2# {} Chips",
                        "for every {C:diamonds}Diamonds{} scored",
                    },
                    {
                        "{C:inactive}(Currently {X:chips,C:white} X#1# {C:inactive} Chips)",
                    }
                }
            },
            j_akyrs_evilneuro_absurd = {
                name = "Evil Neuro",
                text = { 
                    {
                        "If hand {C:attention}DOES NOT{} contain a {C:attention}Flush",
                    },
                    {
                        "This Joker {C:attention}exponentiates{} its {X:chips,C:white}XChips{} by {X:edition,C:purple} ^#2# {}",
                        "for every {C:clubs}Clubs{} scored",
                    },
                    {
                        "If {T:j_akyrs_neurosama,C:red}Neuro Sama{} is present,",
                        "also {C:attention}exponentiates{} its {X:chips,C:white}XChips{} by {X:edition,C:purple} ^#2# {}",
                        "for every {C:diamonds}Diamonds{} scored",
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
            j_akyrs_happy_ghast_absurd = {
                name = "Happy Ghast",
                text = { 
                    "{C:white,X:dark_edition} ^#1# {} Mult per card scored",
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
            j_akyrs_ash_joker_absurd = {
                name = "Ash Joker",
                text = { 
                    "{C:purple,X:edition} ^#1# {} Chips",
                    "{C:attention}Always{} disintegrating into nothing",
                    "at the end of the round"
                }
            },
            j_akyrs_yee = {
                name = "Yee",
                text = { 
                    "If played word contains {C:green}a Y{} and {C:green}two E's{},",
                    "Gain {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "Per Scored {C:attention}Y's{} and {C:blue}E's{}",
                    "{s:0.7,C:inactive}Who even remembered this???{}"
                }
            },
            j_akyrs_yee_absurd = {
                name = "Yee",
                text = { 
                    "{C:attention}Before hand is scored{}, change",
                    "{C:attention}first two{} letters of played hand",
                    "to {C:green}Y{} and {C:green}E{}.",
                    "This joker gain {X:chips,C:white} X#1# {} Chips",
                    "if hand is {C:attention}NOT{} a {C:attention}High Card",
                    "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
                    "{s:0.7,C:inactive}bobobobo bo bobo bo bobo bobobobo bo bobo YEE{}"
                }
            },
            j_akyrs_yee_absurd_cass_none = {
                name = "Yee",
                text = { 
                    "{C:attention}Before hand is scored{}, change",
                    "{C:attention}first two{} letters of played hand",
                    "to {C:green}Y{} and {C:green}E{}.",
                    "This joker gain {X:chips,C:white} X#1# {} Chips",
                    "if hand is {C:attention}NOT{} a {C:attention}High Card{} or {C:attention}None",
                    "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
                    "{s:0.7,C:inactive}bobobobo bo bobo bo bobo bobobobo bo bobo YEE{}"
                }
            },
            j_akyrs_chicken_jockey = {
                name = "Chicken Jockey",
                text = {
                    { 
                        "{C:attention}Every{} food Joker becomes {C:red}Popcorn{} when {C:attention}bought",
                        "Every {C:red}Popcorn{} obtained while this Joker",
                        "is present decreases Mult by {C:red}-#3#{} per round instead",
                        "Gain {X:mult,C:white}X#1#{} Mult per {C:red}Popcorn{} eaten.",
                        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                        "{s:0.7,C:inactive}Absolute Cinema.{}"
                    }
                }
            },
            j_akyrs_chicken_jockey_absurd = {
                name = "Chicken Jockey",
                text = { 
                    {
                        "Every {C:red}Popcorn{} obtained while this Joker is present",
                        "starts at {C:red}#4#{} Mult and decreases Mult by {C:red}-#3#{} per round instead",
                        "Gain {X:dark_edition,C:white}^#1#{} Mult per {C:red}Popcorn{} eaten.",
                        "{C:inactive}(Currently {X:dark_edition,C:white} ^#2# {C:inactive} Mult)",
                        "{s:0.7,C:inactive}They want me to fight the chicken?{}"
                    },
                    {
                        "Creates a {C:red}Popcorn{}",
                        "when Blind is selected",
                        "{C:inactive}(Must have room)",
                        "{s:0.7,C:inactive}Absolute Cinema.{}"
                    }
                }
            },
            j_akyrs_tetoris = {
                name = "Tetoris",
                text = { 
                    "{X:chips,C:white}X#2#{} Chips if any of",
                    "{C:attention}L{}, {C:attention}S{}{C:inactive}(pades), {C:attention}O{}, {C:attention}Z{}, {C:attention}J{C:inactive}(ack), {C:attention}I{}, and {C:attention}T{}{C:inactive}(en)",
                    "are played",
                    "{s:0.9,C:inactive,f:5}テテテテト テト テテテテトリス!{}"
                }
            },
            j_akyrs_tetoris_absurd = {
                name = "Tetoris",
                text = { 
                    "Increase {C:attention}lines cleared{} by {C:attention}1{} per card played",
                    "If at least {C:attention}4{} lines are cleared at the end of the round",
                    "Create a {C:dark_edition}Negative{} {C:spectral}Spectral Card{} and {C:attention}reduce{} lines cleared by {C:attention}4{}",
                    "If at least {C:attention}160{} lines are cleared at the end of the round",
                    "Create a {C:dark_edition}Negative{} {C:spectral}The Soul{} and {C:attention}reduce{} lines cleared by {C:attention}160{}",
                    "{C:inactive}(Lines Cleared : {X:attention,C:white} #1# {C:inactive})",
                    "{s:0.9,C:inactive,f:5}興味がないこと本気じゃないもの全部後回しで{}",
                    "{s:0.9,C:inactive,f:5}知ってることは知らんぷり私は終わってる{}",
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
                    "{f:5}このジョーカーは、{f:5,C:tarot}星{f:5}を使用するたびに",
                    "{f:5}倍率 {X:mult,C:white} X#1# {f:5} を得る",
                    "{C:inactive}({C:inactive,f:5}現在 倍率 {X:mult,C:white} X#2# {C:inactive})",
                }
            },
            j_akyrs_mukuroju_no_hakamori_absurd = {
                name = "{f:5}躯樹の墓守",
                text = { 
                    "{f:5}このジョーカーは、{f:5,C:tarot}星{f:5}を使用するたびに",
                    "{f:5}自分の倍率は {X:mult,C:white,f:5} 八倍 {f:5} で殖える",
                    "{C:inactive}({C:inactive,f:5}現在 倍率 {X:mult,C:white} X#1# {C:inactive})",
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
            j_akyrs_emerald_absurd = {
                name = "Emerald",
                text = { 
                    {
                        "This joker sells for {X:akyrs_money_x,C:akyrs_money_c}(x+#1#)^#2#{}",
                        "where {X:akyrs_money_x,C:akyrs_money_c}x{} is its buy cost ({C:money}$#3#{})",
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
                        "{s:1.4,C:attention}Phase {s:1.4,C:blue}#3#",
                        "Score {s:1.4,C:attention}#1# {s:1.4,C:blue}#2#s{} {C:inactive}(#4#){}",
                        "to move on to the next {C:attention}Phase",
                    },
                    {
                        "Completing each {C:attention}Phase",
                        "grants you a {C:dark_edition}Negative Spectral Card",
                        "Finishing Phase {C:blue}5",
                        "grants you a {C:dark_edition}Negative Soul Card",
                        "and resets to Phase {C:blue}1",
                        "Rank changes every {C:attention}phase{}",
                    }
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
                    "{C:attention}Moves itself{}",
                    "after clicking Play",
                }
            },
            j_akyrs_corkscrew_absurd = {
                name = "Corkscrew",
                text = { 
                    "{C:white,X:dark_edition,E:2} ^#1#{} Mult",
                    "{C:attention}Value is based on its position{}",
                    "{C:attention}Moves itself{} after clicking Play",
                    "{C:inactive}(Drag to check value)",
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
            j_akyrs_goodbye_sengen_absurd = {
                name = "Goodbye Sengen",
                text = { 
                    "Doubles level of {C:attention}High Card{}",
                    "When a {C:tarot}Justice{} is used",
                    "{C:inactive,f:5}引きこもり絶対ジャスティス俺の私だけの折の中で{}",
                }
            },
            j_akyrs_liar_dancer = {
                name = "Liar Dancer",
                text = { 
                    "If hand does not contain a {C:attention}Straight{}",
                    "{C:attention}reduce{} the level of it by {C:red}-#1#{}",
                    "and level up {C:attention}Straight{} and",
                    "{C:attention}Straight Flush{} by {C:blue}#2#{}",
                    "{C:inactive}(Hand cannot be downgraded below 1){}",
                    "{C:inactive,f:5}(踊れ 踊れ 嘘に踊れ){}",
                }
            },
            j_akyrs_liar_dancer_absurd = {
                name = "Liar Dancer",
                text = { 
                    "Upgrade every {C:attention}Poker Hands{}",
                    "the {C:attention}played hand{} does {C:attention}NOT{} contain",
                    "{C:inactive,f:5}(踊れ 踊れ 嘘に踊れ){}",
                }
            },
            j_akyrs_pissandshittium = {
                name = "Pissandshittium",
                text = { 
                    "Tells the URL where to download",
                    "{X:akyrs_pissandshittium,C:white}Pissandshittium{}",
                    "{C:akyrs_pissandshittium}+#1#{} Mult",
                }
            },
            j_akyrs_pissandshittium_absurd = {
                name = "Pissandshittium",
                text = { 
                    "Tells the URL where to download",
                    "{X:akyrs_pissandshittium,C:white}Pissandshittium{}",
                    "{X:akyrs_pissandshittium,C:white}^#1#{} Mult",
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
            j_akyrs_pandora_paradoxxx_absurd = {
                name = "PANDORA PARADOXXX",
                text = { 
                    "{C:green}#1# in #2# chance{} to give {C:attention}Standard Tag",
                    "when a {C:attention}playing card{} added to deck",
                }
            },
            j_akyrs_story_of_undertale = {
                name = "Story of Undertale",
                text = { 
                    "When blind is {C:attention}defeated",
                    "Destroy the rightmost {C:attention}destructible{}",
                    "{C:attention}non-Mr.Bones{} Joker and create",
                    "a {C:dark_edition}Negative {C:attention}Mr.Bones{}",
                    "{C:inactive}(Must have room in between...?)",
                    "Mr.Bones {E:akyrs_snaking,C:red}does not need{}",
                    "score requirements to activate",
                }
            },
            j_akyrs_no_hints_here = {
                name = "No Hints Here!",
                text = { 
                    "{X:mult,C:white} X#1# {} Mult",
                    "Hides {C:attention}all{} tooltips",
                }
            },
            j_akyrs_no_hints_here_absurd = {
                name = "No Hints Here!",
                text = { 
                    "{X:dark_edition,C:white} ^#1# {} Mult",
                    "Hides {C:attention}all{} tooltips",
                }
            },
            j_akyrs_brushing_clothes_pattern = {
                name = "Brushing Clothes Pattern",
                text = { 
                    "If played hand contains a {C:attention}Flush",
                    "and at least one of them is {C:attention}Wild Card",
                    "Increase the Rank of all played",
                    "{C:attention}Wild Cards{} by 1",
                }
            },
            j_akyrs_brushing_clothes_pattern_absurd = {
                name = "Brushing Clothes Pattern",
                text = { 
                    "If played hand contains a {C:attention}Flush",
                    "and at least one of them is {C:attention}Wild Card",
                    "This joker {X:chips,C:white} X#1# {} its Chips value",
                    "when a {C:attention}Wild Cards{} is scored",
                    "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
                }
            },
            j_akyrs_you_tried = {
                name = "You Tried",
                text = { 
                    "{C:attention}Prevents death{} and",
                    "{C:red}Destroy all your Jokers",
                    "Halves your current Ante {C:inactive}(rounding up)",
                    "Sets money to {C:money}$#2#",
                    "then {E:akyrs_snaking,C:red}self-destructs",
                }
            },
            j_akyrs_you_tried_mp = {
                name = "You Tried",
                text = { 
                    "When losing to {C:attention}non-PvP{} blinds",
                    --"{C:red}Destroy all your Jokers",
                    --"{C:attention}+#1#{} Life",
                    "Gain {C:money}$#2#",
                    "then {E:akyrs_snaking,C:red}self-destructs",
                }
            },
            j_akyrs_you_tried_absurd = {
                name = "You Tried",
                text = { 
                    "{C:attention}Prevents death{} and",
                    "Set Ante to {C:attention}#1#{}",
                    "then {E:akyrs_snaking,C:red}self-destructs",
                }
            },
            j_akyrs_you_tried_absurd_mp = {
                name = "You Tried",
                text = { 
                    "{C:attention}Prevents death{} and",
                    "Set Life to {C:attention}#1#{}",
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
            j_akyrs_don_chan_absurd = {
                name = "Don-Chan",
                text = { 
                    "Add {C:attention}#1#%{}",
                    "of current {X:chips,C:white}Chips{} to {C:white,X:mult}Mult",
                    "when a card {C:attention}scores",
                }
            },
            j_akyrs_katsu_chan = {
                name = "Katsu-Chan",
                text = { 
                    "Add {C:attention}#1#%{}",
                    "of current {C:white,X:mult}Mult{} to {X:chips,C:white}Chips",
                }
            },
            j_akyrs_katsu_chan_absurd = {
                name = "Katsu-Chan",
                text = { 
                    "Add {C:attention}#1#%{}",
                    "of current {C:white,X:mult}Mult{} to {X:chips,C:white}Chips",
                    "when a card {C:attention}scores",
                }
            },
            j_akyrs_lagtrain = {
                name = "Lagtrain",
                text = { 
                    "Played and unscored cards",
                    "gain {C:chips}+#1#{} Chips",
                }
            },
            j_akyrs_lagtrain_absurd = {
                name = "Lagtrain",
                text = { 
                    "If played hand contained a {C:attention}Straight",
                    "gain {X:chips,C:white} X#1# {} Chips per {C:white,X:mult}FPS{} below #2#",
                    "{C:inactive}(Currently {X:chips,C:white} X#3# {C:inactive} Chips)",
                }
            },
            j_akyrs_bocchi = {
                name = {
                    "{f:5}後藤ひとり{}" , 
                    "{s:0.7}Gotoh Hitori"
                },
                text = { 
                    {
                        "This Joker gains {C:white,X:mult} X#1# {} Mult",
                        "per {C:attention}Kessoku Band{} Jokers held",
                        "if played hand contains {C:attention}a single {C:spades}Spade",
                        "{C:inactive}(Currently {C:white,X:mult} X#2# {C:inactive} Mult)",
                    }
                }
            },
            j_akyrs_bocchi_absurd = {
                name = {
                    "{f:5}後藤ひとり{}" , 
                    "{s:0.7}Gotoh Hitori"
                },
                text = { 
                    {
                        "This Joker {C:attention}exponentiates{} its {C:white,X:mult} XMult {} by {C:white,X:dark_edition} ^#1# {}",
                        "per {C:attention}Kessoku Band{} Jokers held",
                        "if played hand contains only {C:spades}Spades",
                        "{C:inactive}(Currently {C:white,X:mult} X#2# {C:inactive} Mult)",
                    },
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
            j_akyrs_kita_absurd = {
                name = {
                    "{f:5}喜多郁代{}" , 
                    "{s:0.7}Kita Ikuyo"
                },
                text = { 
                    {
                        "Create {C:dark_edition}Negative {C:tarot}The Lovers{}",
                        "per {C:hearts}Hearts{} scored",
                    },
                }
            },
            j_akyrs_ryou = {
                name = {
                    "{f:5}山田リョウ{}" , 
                    "{s:0.7}Yamada Ryou"
                },
                text = { 
                    {
                        "Go up to {C:red}-$#1#{} in debt",
                        "Debt limit {C:red}-$#2#{}",
                        "if hand contains a {C:attention}Pair{} of {C:clubs}Clubs{}",
                    },
                }
            },
            j_akyrs_ryou_absurd = {
                name = {
                    "{f:5}山田リョウ{}" , 
                    "{s:0.7}Yamada Ryou"
                },
                text = { 
                    {
                        "Go up to {C:red}-$#1#{} in debt",
                        "Debt limit {X:red,C:white}X#2#{} per",
                        "{C:attention}Pairs{} of {C:clubs}Clubs{} played",
                    },
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
            j_akyrs_nijika_absurd = {
                name = {
                    "{f:5}伊地知虹夏{}" , 
                    "{s:0.7}Ijichi Nijika"
                },
                text = { 
                    {
                        "If {C:attention}played hand{} contains a {C:attention}Straight{}",
                        "Create a {C:dark_edition}Negative {C:planet}Planet Card{}",
                        "of your most played hand per {C:diamonds}Diamonds{} played",
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
                    'sum of {C:green}numerator and denominator{} of probability',
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
                    '{C:inactive,s:0.8}Why did they put Markiplier\'s face on Lord Farquaad again?'
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
                    "{C:white,X:purple}X#1#{} Score",
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
                        "per card if played hand contains a {C:attention}Flush",
                    },
                    {
                        "This Joker loses {C:white,X:chips} X#2# {} Chips instead",
                        "per {V:1}#4#{} scored",
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
                        "{C:attention}Draw{} your whole deck ",
                        "and this joker gains {C:white,X:mult} X#2# {} Mult",
                        "{C:inactive}(Currently {C:white,X:mult} X#1# {C:inactive} Mult)",
                    },
                }
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
                    "Lose {C:money}$#1#{} at",
                    "end of round",
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
                    "per number of cards with {C:attention}Neon Seal{}",
                    "held or played, {C:attention}whichever is less{}",
                    "when hand is played",
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
                    "if all cards in played hand has {C:attention}Fault Seal{}",
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
            pinned_left={
                name="Pinned",
                text={
                    "This card stays",
                    "pinned to the",
                    "leftmost position",
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
            
            akyrs_perma_score = {
                text = {
                    "{C:purple}#1#{} Score",
                },
            },
            akyrs_perma_h_score = {
                text = {
                    "{C:purple}#1#{} Score if held in hand",
                },
            },
            akyrs_perma_xscore = {
                text = {
                    "{X:purple,C:white}X#1#{} Score",
                },
            },
            akyrs_perma_h_xscore = {
                text = {
                    "{X:purple,C:white}X#1#{} Score if held in hand",
                },
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
        Spectral={},
        Stake={
            stake_akyrs_inner = {
                name = "Inner Stake",
                text = {
                    "{C:blue}+1{} Hand Size",
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
                    "{s:0.8}Applies Bismuth Stake",
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
                    "{C:blue}+#1#{} Hand Size",
                },
            },
            v_akyrs_worlds_end={
                name="World's End",
                text={
                    "{C:akyrs_playable}+#1#{} Card Selection",
                    "{C:blue}+#1#{} Hand Size",
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
                    "{C:blue}+#3#{} Hand Size",
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
                    "Adds {C:attention}#1#{} sealed {C:attention}Pinned{} Kings",
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
                    "Splits {C:attention}#1#{} selected card",
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
            c_akyrs_umbral_intrusive_thoughts_absurd = {
                name="Intrusive Thoughts",
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
                    "to {C:attention}all {C:clubs}Clubs{} cards in hands",
                },
            },
            c_akyrs_umbral_mantle = {
                name="Mantle",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {X:chips,C:white} X#1# {} Chips",
                    "to {C:attention}all {C:spades}Spades{} cards in hands",
                },
            },
            c_akyrs_umbral_core = {
                name="Core",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {C:money}+$#1#{}",
                    "to {C:attention}all {C:hearts}Hearts{} cards in hands",
                },
            },
            c_akyrs_umbral_atmosphere = {
                name="Atmosphere",
                text=
                {
                    "Give {C:attention}permanent{} bonus of {C:purple}+#1#{} Score",
                    "to {C:attention}all {C:diamonds}Diamonds{} cards in hands",
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
                    "Temporarily receives {C:red}+#2#{} Discard"
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
                    "then creates {C:attention}equal{} amount of",
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
                }
            },
            c_akyrs_replicant_third_party_cookies = {
                name = "Third Party Cookies",
                text = {
                    "Fill your Joker slots",
                    "with {C:purple}Latticed{} Food Joker",
                }
            },
            c_akyrs_replicant_silicon_fabrication = {
                name = "Silicon Fabrication",
                text = {
                    "A random card in hand is",
                    "converted into {C:attention}Wafer Card{}",
                    "Another random card in hand will have",
                    "{C:dark_edition}Dyed{} applied to it",
                }
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
        },
        collabs={},
        dictionary={
            b_umbral_cards = "Umbral Cards",
            b_replicant_cards = "Replicant Cards",
            b_alphabet_cards = "Alphabet Cards",
            k_umbral = "Umbral",
            k_replicant = "Replicant",
            k_alphabet = "Alphabet",

            b_akyrs_alphabets="Alphabet Cards",
            k_aikoyoriextrabases = "Extra Base",
            k_akyrs_alphabets = "Alphabet",
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
            k_akyrs_umbral_intrusive_would_die = "Safe!",
            k_akyrs_umbral_intrusive_would_win = "Missed!",
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
            k_akyrs_restart_required = "* = Restart Required",
            k_akyrs_toggle_full_dictionary = "Enable Full Dictionary*",
            k_akyrs_toggle_experimental_feature = "Enable Experimental Features*",
            k_akyrs_emerald = "Emerald",
            k_akyrs_supercommon = "Supercommon",
            k_akyrs_unique = "Unique",
            k_akyrs_alphabet_pack = "Alphabets",
            k_akyrs_umbral_pack = "Umbral Pack",
            k_akyrs_replica_pack = "Replica Pack",
        },
        high_scores={},
        labels={
            akyrs_self_destructs="Self-Destructive",
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
            akyrs_dyed = "Dyed",
            akyrs_enchanted = "Enchanted",
            k_akyrs_emerald = "Emerald",
            k_akyrs_supercommon = "Supercommon",
            k_akyrs_unique = "Unique",
            umbral = "Umbral",
            replicant = "Replicant",
            alphabet = "Alphabet",
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
        },
    },
}