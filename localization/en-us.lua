return {
    descriptions = {
        Alphabets = {
            
        },
        Back={
            b_akyrs_letter_deck = {
                name = 'Letter Deck',
                text = { 'Letters-Only Deck',
                        "with Scrabble Distribution", 
                        "{C:mult}Mult{} and {C:white,X:mult}Xmult{} Enabled", 
                        "Play {C:playable}as many{} cards", 
                        "as you want per hand",
                        "{C:red}X#1#{} base Blind Size",
                        "{C:red}+#2#{} Discards",
                        "{C:attention}+#3#{} Hand Size",
                    },
            },
            b_akyrs_math_deck = {
                name = 'Math Deck',
                text = { 'Make Maths Expressions',
                'Get within {C:red}+-#1#%{}',
                'of the Blind Requirements',
                '{C:red}+#2#{} Discards & {C:attention}+#3#{} Hand Size',
                },
            },
            b_akyrs_hardcore_challenges={
                name="Hardcore Challenge Deck",
                text={
                    "",
                },
            },
            b_akyrs_scuffed_misprint={
                name="Slightly Less Scuffed Misprint Deck",
				text = {
					"Values of most cards",
					"are multiplied by a",
                    "factor of #2#^X, with",
                    "X being {C:attention}randomized{} over a",
                    "standard normal distribution",
                    "{C:inactive}~43% chance of x1, ~16% chance of x#1# or x#2#,",
                    "{C:inactive}~0.8% chance of x#3# or x#4#, etc. to x0 and xInfinity"
				},
            },
            b_akyrs_freedom={
                name="Freedom Deck",
				text = {
					"You can drag cards",
					"to place it anywhere.",
                    "ART IN PROGRESS"
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
                    "#1# cards randomly selected every hand",
                    "X#2# Score Requirement on deselect",
                    "Activates once per hand",
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
                    "Played cards cannot be",
                    "deselected ever again",
                }
            },
            bl_akyrs_final_periwinkle_pinecone= {
                name = "Periwinkle Pinecone",
                text = {
                    "Sealed cards are",
                    "permanently debuffed",
                }
            },
            bl_akyrs_final_razzle_raindrop = {
                name = "Razzle Raindrop",
                text = {
                    "Played suits are",
                    "debuffed",
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
                    "Face cards must not be held in hand",
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
                    "base #1# Chip and #2# Mult",
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
        },
        DescriptionDummy={
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
            dd_akyrs_aikoyori_base_ability={
                name="Base Ability",
                text={
                    "{X:mult,C:white} X#1# {} Mult per",
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
                    "create a {C:attention}Spare CD{} Tag",
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
        },
        Edition={
            e_akyrs_texelated = {
                name = "Texelated",
                text = {
                    "{C:mult}#1#{} Mult",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_noire = {
                name = "Noire",
                text = {
                    "{C:dark_edition}+#1#{} Card Limit for where this card is",
                    "{C:white,X:mult}X#2#{} Mult"
                }
            },
            e_akyrs_sliced = {
                name = "Sliced",
                text = {
                    "Triggers twice",
                    "All values are halved"
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
            }
        },
        Joker={
            j_akyrs_utage_charts = {
                name = "Utage Charts",
                text = {
                    "{C:playable}+#1#{} Hand Selection"
                }
            },
            j_akyrs_netherite_pickaxe = {
                name = "Netherite Pickaxe",
                text = {
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Card scored",
                    "{C:red,E:1}Destroy all scored",
                    "{C:attention,E:1}Stone{C:red,E:1} cards afterwards"
                }
            },
            j_akyrs_diamond_pickaxe = {
                name = "Diamond Pickaxe",
                text = {
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Card scored",
                    "and change every scored {C:attention}Stone{} card",
                    "to a random {C:attention}non-Stone Upgrades{}"
                }
            },
            j_akyrs_redstone_repeater = {
                name = "Redstone Repeater",
                text = { "Swaps the current {C:white,X:mult} Mult {}", "with the stored {C:mult}Mult",
                    "then {C:white,X:mult} X#2# {} Mult", "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
                    "{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}" }
            },
            j_akyrs_observer = {
                name = "Observer",
                text = { "This Joker gains {C:mult}#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                    "{C:chips}Chips{} or {C:mult}Mult{} value changes",
                    "{s:0.8}Times needed increases by {C:attention}#5#{}",
                    "{s:0.8}every time this Joker gains {C:mult}Mult{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}" }
            },
            j_akyrs_quasi_connectivity = {
                name = "Quasi Connectivity",
                text = { "{C:white,X:mult} X#1# {} Mult", "Disables one {C:attention}random Joker{}",
                    "after a hand is played",
                    "{s:0.8}Debuffs itself if it's",
                    "{s:0.8}the sole card"
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
                    "Debuffed Cards held in hand or played",
                    "give {X:mult,C:white} X#1#{} Mult each",
                    "{C:inactive,s:0.8}Does NOT work properly on macOS",
                    "{C:inactive,s:0.8}Please check back later if you're on macOS",
                }
            },
            j_akyrs_eat_pant = {
                name = "eat pant",
                text = { 
                    "If played hand contains exactly {C:attention}#1#{} cards",
                    "This joker gains {X:mult,C:white} X#2# {} Mult for every scored cards",
                    "{C:red}Destroys all played cards{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                }
            },
            j_akyrs_tsunagite = {
                name = "Tsunagite",
                text = { 
                    "Gives value listed",
                    "if played hand sum does not exceed {C:attention}#1#{}",
                    "Joker gain the value listed",
                    "When a {C:tarot,T:c_wheel_of_fortune}Wheel of Fortune{} is used",
                }
            },
            j_akyrs_yona_yona_dance = {
                name = "Yona Yona Dance",
                text = { 
                    "Retrigger each played {C:attention}4{} and {C:attention}7{}",
                    "{C:attention}#1#{} additional times",
                    "{C:inactive,s:0.9}naraba odoranya son{}",
                    "{C:inactive,s:0.9}odoranya son desu{}",
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
                        "From the ancient {C:white,X:red}Chinese{} who are credited with inventing playing cards in the {C:attention}9th century{} to the spread of card",
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
            j_akyrs_reciprocal_joker = {
                name = "Reciprocal Joker",
                text = { 
                    "Set {X:mult,C:white}Mult{} to",
                    "{X:chips,C:white}Chips{} divided by {X:mult,C:white}Mult{}",
                }
            },
            j_akyrs_kyoufuu_all_back = {
                name = "Kyoufuu All Back",
                text = { 
                    "Return previously {C:attention}discarded Cards",
                    "back to deck on {C:attention}final discard{}"
                }
            },
            j_akyrs_2fa = {
                name = "Two-Factor Authentication",
                text = { 
                    "{C:attention}All Played Cards'{} Rank",
                    "and Suit are {C:attention}randomized{} after scoring",
                    "and gains {C:chips}+#1#{} Chips per card played",
                    "{C:attention}Resets{} at the end of the round.",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                    "{C:inactive,s:0.8}PSA: Please enable 2FA on all your online accounts!",
                }
            },
            j_akyrs_gaslighting = {
                name = "Gaslighting",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult every hand played",
                    "{C:attention}Will not reset at all if score catches fire.",
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
                    "This Joker gains {X:mult,C:white} X#2# {} Mult",
                    "for every {C:hearts}Hearts{} scored",
                    "and if {T:j_akyrs_evilneuro,C:red}Evil Neuro{} is present,",
                    "also gains {X:mult,C:white} X#2# {} Mult",
                    "for every {C:spades}Spades{} scored",
                    "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
                }
            },
            j_akyrs_evilneuro = {
                name = "Evil Neuro",
                text = { 
                    "This Joker gains {X:chips,C:white} X#2# {} Chips",
                    "for every {C:clubs}Clubs{} scored",
                    "and if {T:j_akyrs_neurosama,C:red}Neuro Sama{} is present,",
                    "also gains {X:chips,C:white} X#2# {} Chips",
                    "for every {C:diamonds}Diamonds{} scored",
                    "{C:inactive}(Currently {X:chips,C:white} X#1# {C:inactive} Chips)",
                }
            },
            j_akyrs_dried_ghast = {
                name = "Dried Ghast",
                text = { 
                    "Play with {C:red}no discards{}",
                    "for the next {C:blue}#1# rounds{}",
                    "and create {T:j_akyrs_ghastling,C:purple}Ghastling{}",
                    "{C:red}Self-destructs{}",
                    "Resets back to {C:blue}#2#{} if score catches fire",
                }
            },
            j_akyrs_ghastling = {
                name = "Ghastling",
                text = { 
                    "{C:mult}+#2#{} Mult",
                    "And after playing {C:attention}#1#{} hands,",
                    "creates a {T:j_akyrs_happy_ghast,C:purple}Happy Ghast{}",
                    "{C:red}Self-destructs{}",
                    "Decreses by {C:blue}1{} more every hand",
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
                    "{C:red}Destroying{} cards",
                    "grants you a {C:attention}Burnt{} copy of it",
                }
            },
            j_akyrs_ash_joker = {
                name = "Ash Joker",
                text = { 
                    "{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance",
                    "of disintegrating into nothing",
                    "at the end of the round"
                }
            },
            j_akyrs_yee = {
                name = "Yee",
                text = { 
                    "If played word contains {C:attention}a Y{} and {C:blue}two E's{},",
                    "Gain {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "Per Scored {C:attention}Y's{} and {C:blue}E's{}",
                    "{s:0.7,C:inactive}Who even remembered this???{}"
                }
            },
            j_akyrs_chicken_jockey = {
                name = "Chicken Jockey",
                text = { 
                    "Every {C:red}Popcorn{} obtained",
                    "while this Joker is present",
                    "decreses Mult by {C:red}-#3#{} per round instead",
                    "Gain {X:mult,C:white}X#1#{} Mult per",
                    "{C:red}Popcorn{} eaten.",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                    "{s:0.7,C:inactive}Absolute Cinema.{}"
                }
            },
            j_akyrs_tetoris = {
                name = "Tetoris",
                text = { 
                    "{C:attention}L{}, {C:attention}S{}, {C:attention}O{}, {C:attention}Z{}, {C:attention}J{}, {C:attention}I{}, and {C:attention}T{}",
                    "gives {C:chips}+#1#{} Chips when scored",
                    "and {X:chips,C:white}X#2#{} Chips if any one those is present.",
                    "{s:0.7,C:inactive}teteteteto teto tetete tetoris!{}"
                }
            },
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
            j_akyrs_aikoyori = {
                name = "Aikoyori",
                text = { 
                    "This Joker gains more abilities",
                    "the {C:attention}more{} mods you installed",
                }
            }
        },
        Other={
            akyrs_self_destructs={
                name="Self-Destructive",
                text={
                    "{C:red}Self-Destructs{} at ",
                    "the end of the round",
                },
            },
            akyrs_debuff_seal={
                name="Debuff Seal",
                text={
                    "{C:red}Debuffs itself{}",
                    "when drawn to hand",
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
                name="Totals",
                text={
                    "Aces count as 1",
                    "Face Cards count as 10",
                },
            },
            akyrs_hardcore_challenge_locked = {
                name = "Locked",
                text={
                    "Win a challenge run to unlock",
                    "Hardcore Challenge mode",
                },
            }
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
        },
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={
            v_akyrs_alphabet_soup={
                name="Alphabet Soup",
                text={
                    "{C:attention}Letters{} appear on playing cards",
                    "Words can be made with playing cards",
                    "{C:attention}Letters{} give {C:white,X:mult}XMult{} based on",
                    "1 + tenth of their {C:attention}Scrabble value{}",
                    "{C:inactive}e.g. 1+(value/10){}",
                },
            },
            v_akyrs_crossing_field={
                name="Crossing Field",
                text={
                    "{C:attention}Letters{} give {C:mult}Mult{}",
                    "based on their {C:attention}Scrabble value{}",
                },
            },
        },
        AikoyoriExtraBases={
            aiko_x_akyrs_null = {
                name = 'Null',
                text = { 'No rank or suit'},
            },
            lettersA = {name = 'Letter A',text = { '{C:mult}+#1#{} Mult'},},
            lettersB = {name = 'Letter B',text = { '{C:mult}+#1#{} Mult'},},
            lettersC = {name = 'Letter C',text = { '{C:mult}+#1#{} Mult'},},
            lettersD = {name = 'Letter D',text = { '{C:mult}+#1#{} Mult'},},
            lettersE = {name = 'Letter E',text = { '{C:mult}+#1#{} Mult'},},
            lettersF = {name = 'Letter F',text = { '{C:mult}+#1#{} Mult'},},
            lettersG = {name = 'Letter G',text = { '{C:mult}+#1#{} Mult'},},
            lettersH = {name = 'Letter H',text = { '{C:mult}+#1#{} Mult'},},
            lettersI = {name = 'Letter I',text = { '{C:mult}+#1#{} Mult'},},
            lettersJ = {name = 'Letter J',text = { '{C:mult}+#1#{} Mult'},},
            lettersK = {name = 'Letter K',text = { '{C:mult}+#1#{} Mult'},},
            lettersL = {name = 'Letter L',text = { '{C:mult}+#1#{} Mult'},},
            lettersM = {name = 'Letter M',text = { '{C:mult}+#1#{} Mult'},},
            lettersN = {name = 'Letter N',text = { '{C:mult}+#1#{} Mult'},},
            lettersO = {name = 'Letter O',text = { '{C:mult}+#1#{} Mult'},},
            lettersP = {name = 'Letter P',text = { '{C:mult}+#1#{} Mult'},},
            lettersQ = {name = 'Letter Q',text = { '{C:mult}+#1#{} Mult'},},
            lettersR = {name = 'Letter R',text = { '{C:mult}+#1#{} Mult'},},
            lettersS = {name = 'Letter S',text = { '{C:mult}+#1#{} Mult'},},
            lettersT = {name = 'Letter T',text = { '{C:mult}+#1#{} Mult'},},
            lettersU = {name = 'Letter U',text = { '{C:mult}+#1#{} Mult'},},
            lettersV = {name = 'Letter V',text = { '{C:mult}+#1#{} Mult'},},
            lettersW = {name = 'Letter W',text = { '{C:mult}+#1#{} Mult'},},
            lettersX = {name = 'Letter X',text = { '{C:mult}+#1#{} Mult'},},
            lettersY = {name = 'Letter Y',text = { '{C:mult}+#1#{} Mult'},},
            lettersZ = {name = 'Letter Z',text = { '{C:mult}+#1#{} Mult'},},
            xlettersA = {name = 'Letter A',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersB = {name = 'Letter B',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersC = {name = 'Letter C',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersD = {name = 'Letter D',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersE = {name = 'Letter E',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersF = {name = 'Letter F',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersG = {name = 'Letter G',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersH = {name = 'Letter H',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersI = {name = 'Letter I',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersJ = {name = 'Letter J',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersK = {name = 'Letter K',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersL = {name = 'Letter L',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersM = {name = 'Letter M',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersN = {name = 'Letter N',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersO = {name = 'Letter O',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersP = {name = 'Letter P',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersQ = {name = 'Letter Q',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersR = {name = 'Letter R',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersS = {name = 'Letter S',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersT = {name = 'Letter T',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersU = {name = 'Letter U',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersV = {name = 'Letter V',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersW = {name = 'Letter W',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersX = {name = 'Letter X',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersY = {name = 'Letter Y',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersZ = {name = 'Letter Z',text = { '{C:white,X:mult}X#2#{} Mult'},},
            ["letters_"] = {name = 'Underscore',text = { '{C:mult}No Extra{} Mult'},},
            ["letters-"] = {name = 'Hyphen',text = { '{C:mult}No Extra{} Mult'},},
            ["letters@"] = {name = 'At Sign',text = { '{C:mult}No Extra{} Mult'},},
            ["letters!"] = {name = 'Exclamation Mark',text = { '{C:mult}No Extra{} Mult'},},
            ["letters?"] = {name = 'Question Mark',text = { '{C:mult}No Extra{} Mult'},},
            ["letters+"] = {name = 'Plus Sign',text = { '{C:mult}No Extra{} Mult'},},
            ["letters/"] = {name = 'Slash',text = { '{C:mult}No Extra{} Mult'},},
            ["letters\\"] = {name = 'Backslash',text = { '{C:mult}No Extra{} Mult'},},
            ["letters*"] = {name = 'Asterisk',text = { '{C:mult}No Extra{} Mult'},},
            ["letters."] = {name = 'Period',text = { '{C:mult}No Extra{} Mult'},},
            ["letters'"] = {name = 'Single Quote',text = { '{C:mult}No Extra{} Mult'},},
            ['letters"'] = {name = 'Double Quote',text = { '{C:mult}No Extra{} Mult'},},
            ['letters&'] = {name = 'Ampersand',text = { '{C:mult}No Extra{} Mult'},},
            ['letters '] = {name = 'Space',text = { '{C:mult}No Extra{} Mult'},},
            ['letters:'] = {name = 'Colon',text = { '{C:mult}No Extra{} Mult'},},
            ['letters;'] = {name = 'Semicolon',text = { '{C:mult}No Extra{} Mult'},},
            ['letters='] = {name = 'Equal Sign',text = { '{C:mult}No Extra{} Mult'},},
            ['letters,'] = {name = 'Comma',text = { '{C:mult}No Extra{} Mult'},},
            ['letters('] = {name = 'Opening Parenthesis',text = { '{C:mult}No Extra{} Mult'},},
            ['letters)'] = {name = 'Closing Parenthesis',text = { '{C:mult}No Extra{} Mult'},},
            ['letters['] = {name = 'Opening Square Bracket',text = { '{C:mult}No Extra{} Mult'},},
            ['letters]'] = {name = 'Closing Square Bracket',text = { '{C:mult}No Extra{} Mult'},},
            ['letters{'] = {name = 'Opening Curly Bracket',text = { '{C:mult}No Extra{} Mult'},},
            ['letters}'] = {name = 'Closing Curly Bracket',text = { '{C:mult}No Extra{} Mult'},},
            ['letters$'] = {name = 'Dollar Sign',text = { '{C:mult}No Extra{} Mult'},},
            ['letters%'] = {name = 'Percent',text = { '{C:mult}No Extra{} Mult'},},
            ['letters^'] = {name = 'Caret',text = { '{C:mult}No Extra{} Mult'},},
            ['letters`'] = {name = 'Backtick',text = { '{C:mult}No Extra{} Mult'},},
            ['letters~'] = {name = 'Tilde',text = { '{C:mult}No Extra{} Mult'},},
            ['letters|'] = {name = 'Pipe',text = { '{C:mult}No Extra{} Mult'},},
            ['letters<'] = {name = 'Less Than',text = { '{C:mult}No Extra{} Mult'},},
            ['letters>'] = {name = 'Greater Than',text = { '{C:mult}No Extra{} Mult'},},

            ["xletters_"] = {name = 'Underscore',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters-"] = {name = 'Hyphen',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters@"] = {name = 'At Sign',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters!"] = {name = 'Exclamation Mark',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters?"] = {name = 'Question Mark',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters+"] = {name = 'Plus Sign',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters/"] = {name = 'Slash',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters\\"] = {name = 'Backslash',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters*"] = {name = 'Asterisk',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters."] = {name = 'Period',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ["xletters'"] = {name = 'Single Quote',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters"'] = {name = 'Double Quote',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters&'] = {name = 'Ampersand',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters '] = {name = 'Space',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters:'] = {name = 'Colon',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters;'] = {name = 'Semicolon',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters='] = {name = 'Equal Sign',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters,'] = {name = 'Comma',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters('] = {name = 'Opening Parenthesis',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters)'] = {name = 'Closing Parenthesis',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters['] = {name = 'Opening Square Bracket',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters]'] = {name = 'Closing Square Bracket',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters{'] = {name = 'Opening Curly Bracket',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters}'] = {name = 'Closing Curly Bracket',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters$'] = {name = 'Dollar Sign',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters%'] = {name = 'Percent',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters^'] = {name = 'Caret',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters`'] = {name = 'Backtick',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters~'] = {name = 'Tilde',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters|'] = {name = 'Pipe',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters<'] = {name = 'Less Than',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters>'] = {name = 'Greater Than',text = { '{C:white,X:mult}No Extra{} XMult'},},
    
            ['letters0'] = {name = 'Zero',text = { '{C:mult}No Extra{} Mult'},},
            ['letters1'] = {name = 'One',text = { '{C:mult}No Extra{} Mult'},},
            ['letters2'] = {name = 'Two',text = { '{C:mult}No Extra{} Mult'},},
            ['letters3'] = {name = 'Three',text = { '{C:mult}No Extra{} Mult'},},
            ['letters4'] = {name = 'Four',text = { '{C:mult}No Extra{} Mult'},},
            ['letters5'] = {name = 'Five',text = { '{C:mult}No Extra{} Mult'},},
            ['letters6'] = {name = 'Six',text = { '{C:mult}No Extra{} Mult'},},
            ['letters7'] = {name = 'Seven',text = { '{C:mult}No Extra{} Mult'},},
            ['letters8'] = {name = 'Eight',text = { '{C:mult}No Extra{} Mult'},},
            ['letters9'] = {name = 'Nine',text = { '{C:mult}No Extra{} Mult'},},
            ['xletters0'] = {name = 'Zero',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters1'] = {name = 'One',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters2'] = {name = 'Two',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters3'] = {name = 'Three',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters4'] = {name = 'Four',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters5'] = {name = 'Five',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters6'] = {name = 'Six',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters7'] = {name = 'Seven',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters8'] = {name = 'Eight',text = { '{C:white,X:mult}No Extra{} XMult'},},
            ['xletters9'] = {name = 'Nine',text = { '{C:white,X:mult}No Extra{} XMult'},},

            lettersWild = {name = 'Wild Card',text = { '{C:mult}No Extra{} Mult'},},
            xlettersWild = {name = 'Wild Card',text = { '{C:white,X:mult}No Extra{} XMult'},},
            lettersWildSet = {name = 'Wild Card',text = { 'Able to be set to specific letter'},},
            letterNotScored = {name = '',text = { 'Allows Words','to be played'},},
            letterNotScoredSymbols = {name = '',text = { 'These symbols','are used in specific circumstances'},},
            letterNotScoredNumbers = {name = '',text = { 'Allows creating','mathematical expressions'},},
        },
        Sleeve = {
            sleeve_akyrs_letter = {
                name = "Letter Sleeve",
                text = { 
                    "Start with {C:red}Letters{} Enabled",
                    "Along with with its {C:white,X:mult}Xmult{}",
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
					"You can drag cards",
					"to place it anywhere.",
                    "ART IN PROGRESS"
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
        }
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
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
            hc_akyrs_half_life = "Half-Life",
            hc_akyrs_half_life_2 = "Half-Life 2",
            hc_akyrs_thin_yo_deck = "thin yo deck bro",
            hc_akyrs_thin_yo_deck_2 = "for the love of god thin your deck",
            hc_akyrs_national_debt = "National Debt"
        },
        collabs={},
        dictionary={
            b_akyrs_alphabets="Alphabet Cards",
            k_aikoyoriextrabases = "Extra Base",
            k_akyrs_alphabets = "Alphabet",
            k_akyrs_current_req = "current",
            k_akyrs_alphabets_pack = "Alphabet Pack",
            k_alphabets = "Alphabet Pack",
            k_created = "Created!",
            ph_aiko_beat_puzzle = "Solve the following",
            ph_word_puzzle = "Word Puzzle",
            ph_puzzle_clear = "Puzzle Clear!",
            ph_akyrs_unknown = "???",
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
            k_akyrs_hibana_change = "Nanana...",
            k_akyrs_with = "with",
            k_akyrs_credits = "Credits",
            k_akyrs_created_by = "Created by",
            k_akyrs_additional_art_by = "Additional Art by",
            k_akyrs_difficult = "Difficult",
            k_akyrs_dried = "Dried...",
            k_akyrs_moisture = "Moisturised!",
            k_akyrs_growth = "Growth!",
            k_akyrs_back = "Reverse!",
            k_akyrs_cinema = "Cinema!",

            k_akyrs_random_letter = "randomly selected letter",

            k_akyrs_cannot_be_disabled = "Cannot Be Disabled",
            k_akyrs_cannot_be_rerolled = "Cannot Be Rerolled",
            k_akyrs_blind_difficult_expert = "Expert Blinds",
            k_akyrs_blind_difficult_master = "Master Blinds",
            k_akyrs_blind_difficult_ultima = "Ultima Blinds",
            k_akyrs_blind_difficult_remaster = "Re:Master Blinds",

            k_akyrs_confrontation_has_face_in_hand_warning = "Must not hold face cards in hand",

            k_akyrs_title = "Aikoyori's Shenanigans",
            k_akyrs_join_akyrs_discord = "Join my Discord",

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
            k_akyrs_letter_btn_unset = "Unset",
            k_akyrs_letter_btn_auto = "Auto",
            k_akyrs_letter_btn_set = "Set",
            k_akyrs_letter_btn_swap_case = "Swap Case",

            k_akyrs_textbox_notice = "Due to how the game works, you'll have to",
            k_akyrs_textbox_notice_2 = "interact with the textbox for text to show up",

            k_akyrs_plus_alphabet = "+1 Alphabet",

            k_akyrs_solitaire_redeal = "Redeal",
            
            k_akyrs_wildcard_behaviours={
                'Automatic',
                'Force No Unset',
                'Always Manual',
                'Auto Set', 
            },
            k_akyrs_wildcard_behaviours_description={
                {'Automatically find a letter for wildcards','which do not have letters set. (Default).'},
                {'The play button will be disabled','if you selected an unset wild card.',} ,
                {'Wildcards do not have letter assigned to them by default.','When played, will not attempt to find letters. (Can help with performance)',} ,
                {'Automatically find a letter for wildcard and','also set the letter automatically to the target if it is unset.',} 
            },

            k_akyrs_joker_preview = "Enable Joker Preview Window",
            k_akyrs_joker_preview_description={
                'Some Jokers have a small "Preview" window where the effect of the Joker',
                'is demonstrated. If you are experiencing crashes related to "blind" being',
                'nil when hovering on certain Jokers. Turning this off might mitigate that issue.',
            },
        },
        high_scores={},
        labels={
            akyrs_self_destructs="Self-Destructive",
            akyrs_debuff_seal="Seal-Debuffed",
            akyrs_texelated = "Texelated",
            akyrs_noire = "Noire",
            akyrs_sliced = "Sliced",
            akyrs_burnt = "Burnt"
        },
        poker_hand_descriptions={
            ["akyrs_3-letter Word"] =  {'Create a valid '.. 3 ..'-letter English word', 'without extra letters'},
            ["akyrs_4-letter Word"] =  {'Create a valid '.. 4 ..'-letter English word', 'without extra letters'},
            ["akyrs_5-letter Word"] =  {'Create a valid '.. 5 ..'-letter English word', 'without extra letters'},
            ["akyrs_6-letter Word"] =  {'Create a valid '.. 6 ..'-letter English word', 'without extra letters'},
            ["akyrs_7-letter Word"] =  {'Create a valid '.. 7 ..'-letter English word', 'without extra letters'},
            ["akyrs_8-letter Word"] =  {'Create a valid '.. 8 ..'-letter English word', 'without extra letters'},
            ["akyrs_9-letter Word"] =  {'Create a valid '.. 9 ..'-letter English word', 'without extra letters'},
            ["akyrs_10-letter Word"] = {'Create a valid '.. 10 ..'-letter English word', 'without extra letters'},
            ["akyrs_11-letter Word"] = {'Create a valid '.. 11 ..'-letter English word', 'without extra letters'},
            ["akyrs_12-letter Word"] = {'Create a valid '.. 12 ..'-letter English word', 'without extra letters'},
            ["akyrs_13-letter Word"] = {'Create a valid '.. 13 ..'-letter English word', 'without extra letters'},
            ["akyrs_14-letter Word"] = {'Create a valid '.. 14 ..'-letter English word', 'without extra letters'},
            ["akyrs_15-letter Word"] = {'Create a valid '.. 15 ..'-letter English word', 'without extra letters'},
            ["akyrs_16-letter Word"] = {'Create a valid '.. 16 ..'-letter English word', 'without extra letters'},
            ["akyrs_17-letter Word"] = {'Create a valid '.. 17 ..'-letter English word', 'without extra letters'},
            ["akyrs_18-letter Word"] = {'Create a valid '.. 18 ..'-letter English word', 'without extra letters'},
            ["akyrs_19-letter Word"] = {'Create a valid '.. 19 ..'-letter English word', 'without extra letters'},
            ["akyrs_20-letter Word"] = {'Create a valid '.. 20 ..'-letter English word', 'without extra letters'},
            ["akyrs_21-letter Word"] = {'Create a valid '.. 21 ..'-letter English word', 'without extra letters'},
            ["akyrs_22-letter Word"] = {'Create a valid '.. 22 ..'-letter English word', 'without extra letters'},
            ["akyrs_23-letter Word"] = {'Create a valid '.. 23 ..'-letter English word', 'without extra letters'},
            ["akyrs_24-letter Word"] = {'Create a valid '.. 24 ..'-letter English word', 'without extra letters'},
            ["akyrs_25-letter Word"] = {'Create a valid '.. 25 ..'-letter English word', 'without extra letters'},
            ["akyrs_26-letter Word"] = {'Create a valid '.. 26 ..'-letter English word', 'without extra letters'},
            ["akyrs_27-letter Word"] = {'Create a valid '.. 27 ..'-letter English word', 'without extra letters'},
            ["akyrs_28-letter Word"] = {'Create a valid '.. 28 ..'-letter English word', 'without extra letters'},
            ["akyrs_29-letter Word"] = {'Create a valid '.. 29 ..'-letter English word', 'without extra letters'},
            ["akyrs_30-letter Word"] = {'Create a valid '.. 30 ..'-letter English word', 'without extra letters'},
            ["akyrs_31-letter Word"] = {'Create a valid '.. 31 ..'-letter English word', 'without extra letters'},
            ["akyrs_expression"] = {'Create a valid mathematical expression'},
            ["akyrs_modification"] = {'Modify current chip value'},
            ["akyrs_assignment"] = {'Assign a value to a variable'},
        },
        poker_hands={
            ["akyrs_3-letter Word"] =  "3".."-letter Word" ,
            ["akyrs_4-letter Word"] =  "4".."-letter Word" ,
            ["akyrs_5-letter Word"] =  "5".."-letter Word" ,
            ["akyrs_6-letter Word"] =  "6".."-letter Word" ,
            ["akyrs_7-letter Word"] =  "7".."-letter Word" ,
            ["akyrs_8-letter Word"] =  "8".."-letter Word" ,
            ["akyrs_9-letter Word"] =  "9".."-letter Word" ,
            ["akyrs_10-letter Word"] = "10".."-letter Word",
            ["akyrs_11-letter Word"] = "11".."-letter Word",
            ["akyrs_12-letter Word"] = "12".."-letter Word",
            ["akyrs_13-letter Word"] = "13".."-letter Word",
            ["akyrs_14-letter Word"] = "14".."-letter Word",
            ["akyrs_15-letter Word"] = "15".."-letter Word",
            ["akyrs_16-letter Word"] = "16".."-letter Word",
            ["akyrs_17-letter Word"] = "17".."-letter Word",
            ["akyrs_18-letter Word"] = "18".."-letter Word",
            ["akyrs_19-letter Word"] = "19".."-letter Word",
            ["akyrs_20-letter Word"] = "20".."-letter Word",
            ["akyrs_21-letter Word"] = "21".."-letter Word",
            ["akyrs_22-letter Word"] = "22".."-letter Word",
            ["akyrs_23-letter Word"] = "23".."-letter Word",
            ["akyrs_24-letter Word"] = "24".."-letter Word",
            ["akyrs_25-letter Word"] = "25".."-letter Word",
            ["akyrs_26-letter Word"] = "26".."-letter Word",
            ["akyrs_27-letter Word"] = "27".."-letter Word",
            ["akyrs_28-letter Word"] = "28".."-letter Word",
            ["akyrs_29-letter Word"] = "29".."-letter Word",
            ["akyrs_30-letter Word"] = "30".."-letter Word",
            ["akyrs_31-letter Word"] = "31".."-letter Word",
            ["akyrs_expression"] = "Expression",
            ["akyrs_modification"] = "Modification",
            ["akyrs_assignment"] = "Assignment",
        },
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
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
            ch_c_akyrs_allow_duplicates={
                "{C:attention}Duplicates{} can spawn",
            },
            ch_c_akyrs_idea_by_astrapboy={
                "Idea by {C:attention}astrapboy",
            },
        },
    },
}