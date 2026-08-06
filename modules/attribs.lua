SMODS.Attribute{
    -- for jokers that affect scenarios
    key = "scenario",
    keys = {

    }
}

SMODS.Attribute{
    -- for jokers that has effects in letter mode only
    key = "letter",
    keys = {

    }
}
SMODS.Attribute{
    -- for jokers that has effects with pure cards/hands
    key = "pure",
    keys = {
        'j_akyrs_butcher_vanity',
    }
}

SMODS.Attribute{
    -- for jokers that can deal debuffs
    key = "debuff",
    keys = {
        "j_akyrs_quasi_connectivity",
        "j_akyrs_it_is_forbidden_to_dog",
    }
}

SMODS.Attribute{
    -- for jokers that can deal debuffs to jokers
    key = "joker_debuff",
    keys = {
        "j_akyrs_quasi_connectivity",
    }
}

SMODS.Attribute{
    -- for jokers that can deals debuffs to playing cards
    key = "playing_card_debuff",
    keys = {
        "j_akyrs_quasi_connectivity",
    }
}

SMODS.Attribute{
    -- for jokers that affect selection size
    key = "selection",
    keys = {
        "j_akyrs_quasi_connectivity",
    }
}

SMODS.Attribute{
    -- for jokers that affect play size
    key = "play_size",
    keys = {
        "j_akyrs_quasi_connectivity",
        "j_akyrs_brushing_clothes_pattern",
    }
}

SMODS.Attribute{
    -- for jokers that affect discard size
    key = "discard_size",
    keys = {
        "j_akyrs_quasi_connectivity",
    }
}


SMODS.add_attribute(
    'mult', {
        'j_akyrs_observer',
        'j_akyrs_tldr_joker',
        'j_akyrs_ghastling',
        'j_akyrs_pissandshittium',
        'j_akyrs_don_chan',
        'j_akyrs_nokotan',
        'j_akyrs_ghastling',
    }
)

SMODS.add_attribute(
    'chips', {
        'j_akyrs_diamond_pickaxe',
        'j_akyrs_2fa',
        'j_akyrs_ash_joker',
        'j_akyrs_katsu_chan',
        'j_akyrs_lagtrain',
        'j_akyrs_sushi',
    }
)

SMODS.add_attribute(
    'xmult', {
        'j_akyrs_quasi_connectivity',
        'j_akyrs_it_is_forbidden_to_dog',
        'j_akyrs_tldr_joker',
        'j_akyrs_gaslighting',
        'j_akyrs_neurosama',
        'j_akyrs_happy_ghast',
        'j_akyrs_mukuroju_no_hakamori',
        'j_akyrs_corkscrew',
        'j_akyrs_no_hints_here',
        'j_akyrs_konton_boogie',
        'j_akyrs_butcher_vanity',
    }
)

SMODS.add_attribute(
    'xchips', {
        'j_akyrs_netherite_pickaxe',
        'j_akyrs_evilneuro',
        'j_akyrs_nutrient',
        'j_akyrs_yamada_perfect',
        'j_akyrs_xaleidoscopix',
        'j_akyrs_mikudashi',
    }
)

SMODS.add_attribute(
    'score', {
    }
)

SMODS.add_attribute(
    'xscore', {
        'j_akyrs_so_close',
        'j_akyrs_trend_angelina',
        'j_akyrs_snow_pea',
        'j_akyrs_7wonders',
    }
)

SMODS.add_attribute(
    'blindsize', {
    }
)

SMODS.add_attribute(
    'xblindsize', {
    }
)

SMODS.add_attribute(
    'balance', {
    }
)

SMODS.add_attribute(
    'swap', {
        'j_akyrs_reciprocal_joker',
        'j_akyrs_inverse_joker',
    }
)

SMODS.add_attribute(
    'retrigger', {
        'j_akyrs_yona_yona_dance',
        'j_akyrs_tetoris',
    }
)

SMODS.add_attribute(
    'scaling', {
        'j_akyrs_diamond_pickaxe',
        'j_akyrs_2fa',
        'j_akyrs_neurosama',
        'j_akyrs_evilneuro',
        'j_akyrs_gaslighting',
        'j_akyrs_ash_joker',
        'j_akyrs_mukuroju_no_hakamori',
        'j_akyrs_lagtrain',
        'j_akyrs_konton_boogie',
        'j_akyrs_yamada_perfect',
        'j_akyrs_trend_angelina',
        'j_akyrs_xaleidoscopix',
    }
)

SMODS.add_attribute(
    'reset', {
        'j_akyrs_gaslighting',
        'j_akyrs_2fa',
    }
)

SMODS.add_attribute(
    'suit', {
        'j_akyrs_2fa',
        'j_akyrs_deck_shovel',
        -- diamonds
        'j_akyrs_nijika',
        'j_akyrs_shine_bright_like_a_diamond',
        'j_akyrs_xaleidoscopix',
        -- hearts
        'j_akyrs_hibana',
        'j_akyrs_kita',
        'j_akyrs_mikudashi',
        -- spades
        'j_akyrs_bocchi',
        -- clubs
        'j_akyrs_ryou',
        'j_akyrs_snow_pea',

    }
)

SMODS.add_attribute(
    'diamonds', {
        'j_akyrs_nijika',
        'j_akyrs_shine_bright_like_a_diamond',
        'j_akyrs_xaleidoscopix',
    }
)

SMODS.add_attribute(
    'hearts', {
        'j_akyrs_hibana',
        'j_akyrs_kita',
        'j_akyrs_mikudashi',
    }
)

SMODS.add_attribute(
    'spades', {
        'j_akyrs_bocchi',
    }
)

SMODS.add_attribute(
    'clubs', {
        'j_akyrs_ryou',
        'j_akyrs_snow_pea',
    }
)

SMODS.add_attribute(
    'hand_type', {
        'j_akyrs_so_close',
    }
)

SMODS.add_attribute(
    'rank', {
        'j_akyrs_2fa',
        -- A
        'j_akyrs_hibana',
        'j_akyrs_shine_bright_like_a_diamond',
        -- 4
        'j_akyrs_yona_yona_dance',
        -- 5 
        -- 7 [yona is a dupe]
        'j_akyrs_7wonders',

        -- Face Cards
        'j_akyrs_butcher_vanity',

    }
)

SMODS.add_attribute(
    'ace', {
        'j_akyrs_hibana',
        'j_akyrs_shine_bright_like_a_diamond',
    }
)

SMODS.add_attribute(
    'two', {
    }
)

SMODS.add_attribute(
    'three', {
    }
)

SMODS.add_attribute(
    'four', {
        'j_akyrs_yona_yona_dance',
    }
)

SMODS.add_attribute(
    'five', {
        'j_akyrs_hibana',
    }
)

SMODS.add_attribute(
    'six', {
    }
)

SMODS.add_attribute(
    'seven', {
        'j_akyrs_yona_yona_dance',
        'j_akyrs_7wonders',
    }
)

SMODS.add_attribute(
    'eight', {
    }
)

SMODS.add_attribute(
    'nine', {
    }
)

SMODS.add_attribute(
    'ten', {
    }
)

SMODS.add_attribute(
    'jack', {
    }
)

SMODS.add_attribute(
    'queen', {
    }
)

SMODS.add_attribute(
    'king', {
    }
)

SMODS.add_attribute(
    'face', {
        'j_akyrs_hibana',
        'j_akyrs_butcher_vanity',
    }
)

SMODS.add_attribute(
    'economy', {
        'j_akyrs_pissandshittium',
        'j_akyrs_ryou',
        'j_akyrs_gift_voucher',
    }
)

SMODS.add_attribute(
    'generation', {
        'j_akyrs_goodbye_sengen',
        'j_akyrs_nijika',
        'j_akyrs_kita',
        'j_akyrs_bocchi',
        'j_akyrs_pandora_paradoxxx',
        'j_akyrs_space_elevator',
        'j_akyrs_chicken_jockey',
        'j_akyrs_biochamber',
        'j_akyrs_shine_bright_like_a_diamond',
    }
)

SMODS.add_attribute(
    'destroy_card', {
        'j_akyrs_netherite_pickaxe',
        'j_akyrs_eat_pant',
        'j_akyrs_charred_roach',
        'j_akyrs_goodbye_sengen',
        'j_akyrs_story_of_undertale',
    }
)

SMODS.add_attribute(
    'hands', {
        
    }
)

SMODS.add_attribute(
    'discard', {
        'j_akyrs_kyoufuu_all_back',
        'j_akyrs_dried_ghast',
        'j_akyrs_deck_shovel',
    }
)

SMODS.add_attribute(
    'hand_size', {
    }
)

SMODS.add_attribute(
    'chance', {
        'j_akyrs_koshian',
    }
)

SMODS.add_attribute(
    'joker_slot', {
    }
)

SMODS.add_attribute(
    'mod_chance', {
    }
)

SMODS.add_attribute(
    'copying', {
        'j_akyrs_sulfur_cube',
    }
)

SMODS.add_attribute(
    'full_deck', {
    }
)

SMODS.add_attribute(
    'passive', {
    }
)

SMODS.add_attribute(
    'joker', {
        'j_akyrs_shimmer_bucket',
        'j_akyrs_chicken_jockey',
        'j_akyrs_biochamber',
    }
)

SMODS.add_attribute(
    'tarot', {
        'j_akyrs_goodbye_sengen',
        'j_akyrs_kita',
    }
)

SMODS.add_attribute(
    'planet', {
        'j_akyrs_nijika',
    }
)

SMODS.add_attribute(
    'spectral', {
        'j_akyrs_space_elevator',
    }
)

SMODS.add_attribute(
    'enhancements', {
        'j_akyrs_diamond_pickaxe',
        'j_akyrs_netherite_pickaxe',
        'j_akyrs_charred_roach',
        'j_akyrs_bashame',
        'j_akyrs_mikudashi',
    }
)

SMODS.add_attribute(
    'seals', {
        'j_akyrs_bocchi',
    }
)

SMODS.add_attribute(
    'editions', {
        'j_akyrs_aether_portal',
        'j_akyrs_edge',
    }
)

SMODS.add_attribute(
    'tag', {
        'j_akyrs_pandora_paradoxxx',
    }
)

SMODS.add_attribute(
    'skip', {
    }
)

SMODS.add_attribute(
    'modify_card', {
        'j_akyrs_diamond_pickaxe',
        'j_akyrs_2fa',
        'j_akyrs_hibana',
        'j_akyrs_mukuroju_no_hakamori',
        'j_akyrs_liar_dancer',
        'j_akyrs_story_of_undertale',
    }
)

SMODS.add_attribute(
    'perma_bonus', {
        'j_akyrs_lagtrain',
    }
)

SMODS.add_attribute(
    'prevents_death', {
        'j_akyrs_you_tried',
    }
)

SMODS.add_attribute(
    'boss_blind', {
    }
)

SMODS.add_attribute(
    'reroll', {
    }
)

SMODS.add_attribute(
    'on_sell', {
        'j_akyrs_turret',
    }
)

SMODS.add_attribute(
    'sell_value', {
        'j_akyrs_emerald',
        'j_akyrs_nokotan',
        'j_akyrs_koshitan',
        'j_akyrs_koshian',
    }
)

SMODS.add_attribute(
    'food', {
        'j_akyrs_sushi',
        'j_akyrs_nutrient',
    }
)

SMODS.add_attribute(
    'space', {
    }
)