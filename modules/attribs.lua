SMODS.Attribute{
    -- for jokers that affect scenarios
    key = "scenario",
    keys = {
        'j_akyrs_snooze',
        'j_akyrs_jelly_hoshiumi',


        'p_akyrs_scenario_pack_1', 'p_akyrs_scenario_pack_2', 'p_akyrs_scenario_pack_3', 'p_akyrs_scenario_pack_4', 

        'p_akyrs_scenario_pack_flavoured_1', 'p_akyrs_scenario_pack_flavoured_2', 

        'p_akyrs_scenario_pack_full_flavoured_1', 'p_akyrs_scenario_pack_full_flavoured_2', 
    }
}

SMODS.Attribute{
    -- for jokers that has effects in letter mode only
    key = "letter",
    keys = {
        'j_akyrs_maxwells_notebook',
        'j_akyrs_henohenomoheji',
        'j_akyrs_yee',
        'j_akyrs_g',
        'j_akyrs_d_se_dab',
        'j_akyrs_c',
        'j_akyrs_e',
        'j_akyrs_catchphrase',
        'j_akyrs_press_f',
        'j_akyrs_ojisan_koubun',


        'p_akyrs_letter_pack_1', 'p_akyrs_letter_pack_2', 'p_akyrs_letter_pack_3', 'p_akyrs_letter_pack_4', 

        'p_akyrs_jumbo_letter_pack_1', 'p_akyrs_jumbo_letter_pack_2',

        'p_akyrs_mega_letter_pack_1', 'p_akyrs_mega_letter_pack_2',
    }
}
SMODS.Attribute{
    -- for jokers that has effects with pure cards/hands
    key = "pure",
    keys = {
        'j_akyrs_butcher_vanity',
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
        "j_akyrs_it_is_forbidden_to_dog",
    }
}

SMODS.Attribute{
    -- for jokers that affect selection size
    key = "selection",
    keys = {
        "j_akyrs_utage_charts",
    }
}

SMODS.Attribute{
    -- for jokers that affect play size
    key = "play_size",
    keys = {
        "j_akyrs_utage_charts",
        "j_akyrs_brushing_clothes_pattern",
    }
}

SMODS.Attribute{
    -- for jokers that affect discard size
    key = "discard_size",
    keys = {
        "j_akyrs_utage_charts",
    }
}

SMODS.Attribute{
    -- for jokers that has shi with umbral
    key = "umbral",
    keys = {
        'j_akyrs_press_f',


        'p_akyrs_umbral_pack_1', 'p_akyrs_umbral_pack_2', 'p_akyrs_umbral_pack_3', 'p_akyrs_umbral_pack_4', 

        'p_akyrs_jumbo_umbral_pack_1', 'p_akyrs_jumbo_umbral_pack_2',

        'p_akyrs_mega_umbral_pack_1', 'p_akyrs_mega_umbral_pack_2',
    }
}


SMODS.Attribute{
    -- for shi that has shi w replicant
    key = "replicant",
    keys = {
        'j_akyrs_rin_penrose',

        'p_akyrs_replica_pack_1', 'p_akyrs_replica_pack_2', 

        'p_akyrs_jumbo_replica_pack_1', 

        'p_akyrs_mega_replica_pack_1', 
    }
}



--- default attribs


SMODS.add_attribute(
    'mult', {
        'j_akyrs_observer',
        'j_akyrs_tldr_joker',
        'j_akyrs_ghastling',
        'j_akyrs_pissandshittium',
        'j_akyrs_don_chan',
        'j_akyrs_nokotan',
        'j_akyrs_ghastling',
        'j_akyrs_tono_goranshin',
        'j_akyrs_aipai_dancehall',

        'j_akyrs_john',

        'j_akyrs_yee',
        'j_akyrs_e',
        'j_akyrs_catchphrase',
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
        'j_akyrs_yoidore_shirazu',

        'j_akyrs_john',


        'j_akyrs_yee',
        'j_akyrs_c',
        
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

        'j_akyrs_doro_no_bunzai',

        'j_akyrs_sixseven',

        'j_akyrs_tsunagite',
        'j_akyrs_gappie',
        'j_akyrs_aikoyori',
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
        'j_akyrs_coolish',
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
        'j_akyrs_darekanuitekure',
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
        'j_akyrs_upside_down',
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
        'j_akyrs_ghastling',
        'j_akyrs_evilneuro',
        'j_akyrs_gaslighting',
        'j_akyrs_ash_joker',
        'j_akyrs_mukuroju_no_hakamori',
        'j_akyrs_lagtrain',
        'j_akyrs_konton_boogie',
        'j_akyrs_yamada_perfect',
        'j_akyrs_trend_angelina',
        'j_akyrs_xaleidoscopix',
        'j_akyrs_d_se_dab',
        'j_akyrs_bubble',
        'j_akyrs_aipai_dancehall',
        'j_akyrs_yoidore_shirazu',
        'j_akyrs_yoru_ni_kakeru',
        'j_akyrs_walker',
    }
)

SMODS.add_attribute(
    'reset', {
        'j_akyrs_gaslighting',
        'j_akyrs_2fa',
        'j_akyrs_konton_boogie',
        'j_akyrs_aipai_dancehall',
    }
)

SMODS.add_attribute(
    'suit', {
        'j_akyrs_2fa',
        'j_akyrs_deck_shovel',
        'j_akyrs_mr_virtualizer',
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
        'j_akyrs_cartoongirl',
        'j_akyrs_shade_no_hokori',
        -- clubs
        'j_akyrs_ryou',
        'j_akyrs_snow_pea',
        'j_akyrs_outlaws',

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
        'j_akyrs_cartoongirl',
        'j_akyrs_shade_no_hokori',
    }
)

SMODS.add_attribute(
    'clubs', {
        'j_akyrs_ryou',
        'j_akyrs_snow_pea',
        'j_akyrs_outlaws',
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
        'j_akyrs_liar_dancer',
        'j_akyrs_yoidore_shirazu',
        'j_akyrs_yoidore_shirazu',
        -- A
        'j_akyrs_hibana',
        'j_akyrs_shine_bright_like_a_diamond',
        -- 4
        'j_akyrs_yona_yona_dance',
        -- 5 
        -- 6 
        -- 7 [yona is a dupe]
        'j_akyrs_sixseven',
        'j_akyrs_7wonders',

        -- Face Cards
        'j_akyrs_butcher_vanity',
        'j_akyrs_henohenomoheji',
        'j_akyrs_aikoyori',
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
        'j_akyrs_sixseven',
    }
)

SMODS.add_attribute(
    'seven', {
        'j_akyrs_sixseven',
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
        'j_akyrs_henohenomoheji',
    }
)

SMODS.add_attribute(
    'economy', {
        'j_akyrs_pissandshittium',
        'j_akyrs_ryou',
        'j_akyrs_gift_voucher',
        'j_akyrs_chinese_speaker',
        'j_akyrs_arch_illager',
        'j_akyrs_koshitan',
        'j_akyrs_koshian',
        'j_akyrs_bashame',
        'j_akyrs_darekanuitekure',
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
        'j_akyrs_snooze',
        'j_akyrs_twrp',
        'j_akyrs_chicken_roll',
        'j_akyrs_cartoongirl',
        'j_akyrs_matryoshka',
        'j_akyrs_laplus_darkness',
        'j_akyrs_jelly_hoshiumi',
        'j_akyrs_rin_penrose',
        'j_akyrs_dupe_glitch',

        'j_akyrs_gambler',


        'j_akyrs_maxwells_notebook',
        'j_akyrs_press_f',
    }
)

SMODS.add_attribute(
    'destroy_card', {
        'j_akyrs_netherite_pickaxe',
        'j_akyrs_eat_pant',
        'j_akyrs_charred_roach',
        'j_akyrs_goodbye_sengen',
        'j_akyrs_story_of_undertale',
        'j_akyrs_doro_no_bunzai',
        'j_akyrs_spicy_pillow',
        
    }
)

SMODS.add_attribute(
    'hands', {
        'j_akyrs_furina',
        'j_akyrs_gappie',
    }
)

SMODS.add_attribute(
    'discard', {
        'j_akyrs_kyoufuu_all_back',
        'j_akyrs_dried_ghast',
        'j_akyrs_deck_shovel',
        'j_akyrs_furina',
        'j_akyrs_gappie',
        'j_akyrs_telepathy',
        'j_akyrs_shade_no_hokori',
    }
)

SMODS.add_attribute(
    'hand_size', {
        'j_akyrs_gappie',
        'j_akyrs_shoka',
    }
)

SMODS.add_attribute(
    'chance', {
        'j_akyrs_koshian',
        'j_akyrs_outlaws',
    }
)

SMODS.add_attribute(
    'joker_slot', {
    }
)

SMODS.add_attribute(
    'mod_chance', {
        'j_akyrs_outlaws',
        'j_akyrs_fortunate_son',
    }
)

SMODS.add_attribute(
    'copying', {
        'j_akyrs_sulfur_cube',
    }
)

SMODS.add_attribute(
    'full_deck', {
        'j_akyrs_7wonders',
    }
)

SMODS.add_attribute(
    'passive', {
        'j_akyrs_mr_virtualizer',
        'j_akyrs_outlaws',
        'j_akyrs_loser_girl',
        'j_akyrs_fortunate_son',
    }
)

SMODS.add_attribute(
    'joker', {
        'j_akyrs_shimmer_bucket',
        'j_akyrs_chicken_jockey',
        'j_akyrs_biochamber',
        'j_akyrs_sulfur_cube',

        'j_akyrs_elephant',
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
        'j_akyrs_bubble',
        'j_akyrs_mr_virtualizer',


        'j_akyrs_maxwells_notebook',
        'j_akyrs_g',
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
        'j_akyrs_maxwells_notebook',
    }
)

SMODS.add_attribute(
    'tag', {
        'j_akyrs_pandora_paradoxxx',
        'j_akyrs_ojisan_koubun',
    }
)

SMODS.add_attribute(
    'skip', {
        'j_akyrs_rin_penrose',
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
        'j_akyrs_doro_no_bunzai',
        'j_akyrs_incredible_ink',
        'j_akyrs_superliminal',
        'j_akyrs_yoidore_shirazu',
        'j_akyrs_yoru_ni_kakeru',


        'j_akyrs_maxwells_notebook',
    }
)

SMODS.add_attribute(
    'perma_bonus', {
        'j_akyrs_lagtrain',
        'j_akyrs_d_se_dab',
        'j_akyrs_tsunagite',
    }
)

SMODS.add_attribute(
    'prevents_death', {
        'j_akyrs_you_tried',
    }
)

SMODS.add_attribute(
    'boss_blind', {
        'j_akyrs_secretary',
        'j_akyrs_arch_illager',
    }
)

SMODS.add_attribute(
    'reroll', {
    }
)

SMODS.add_attribute(
    'on_sell', {
        'j_akyrs_turret',
        'j_akyrs_chicken_roll',

        'j_akyrs_elephant',
    }
)

SMODS.add_attribute(
    'sell_value', {
        'j_akyrs_emerald',
        'j_akyrs_nokotan',
        'j_akyrs_koshitan',
        'j_akyrs_koshian',
        'j_akyrs_bashame',
    }
)

SMODS.add_attribute(
    'food', {
        'j_akyrs_sushi',
        'j_akyrs_nutrient',
        'j_akyrs_chicken_roll',
        'j_akyrs_coolish',
    }
)

SMODS.add_attribute(
    'space', {
        'j_akyrs_edge',
    }
)

SMODS.add_attribute(
    'lose_economy', {
        'j_akyrs_koshitan',
        'j_akyrs_secretary',
    }
)

SMODS.add_attribute(
    'normal', {
        'p_akyrs_letter_pack_1', 'p_akyrs_letter_pack_2', 'p_akyrs_letter_pack_3', 'p_akyrs_letter_pack_4', 

        'p_akyrs_umbral_pack_1', 'p_akyrs_umbral_pack_2', 'p_akyrs_umbral_pack_3', 'p_akyrs_umbral_pack_4', 

        'p_akyrs_replica_pack_1', 'p_akyrs_replica_pack_2', 

        'p_akyrs_scenario_pack_1', 'p_akyrs_scenario_pack_2', 'p_akyrs_scenario_pack_3', 'p_akyrs_scenario_pack_4', 
    }
)
SMODS.add_attribute(
    'jumbo', {
        'p_akyrs_jumbo_letter_pack_1', 'p_akyrs_jumbo_letter_pack_2',

        'p_akyrs_jumbo_umbral_pack_1', 'p_akyrs_jumbo_umbral_pack_2',

        'p_akyrs_jumbo_replica_pack_1', 
        
        'p_akyrs_scenario_pack_flavoured_1', 'p_akyrs_scenario_pack_flavoured_2', 
    }
)
SMODS.add_attribute(
    'mega', {
        'p_akyrs_mega_letter_pack_1', 'p_akyrs_mega_letter_pack_2',
        
        'p_akyrs_mega_umbral_pack_1', 'p_akyrs_mega_umbral_pack_2',

        'p_akyrs_mega_replica_pack_1', 

        'p_akyrs_scenario_pack_full_flavoured_1', 'p_akyrs_scenario_pack_full_flavoured_2', 
    }
)

-- SMODS.populate_attributes()

-- fuckass poker hans 



SMODS.Attribute{
    -- hands that contain flushes
    key = "flush_hands",
    keys = {
        'Flush',
        'Straight Flush',
        'Flush House',
        'akyrs_triplush',
        'akyrs_quadplush',
        'akyrs_triplush',
        'akyrs_quadplush',
        'akyrs_twinflupple',
        'akyrs_tripletflupple',
        'akyrs_twinflush',
        'akyrs_flushbung',
        'akyrs_direstraightflush',
        'akyrs_twinstraightflush',
    }
}

SMODS.Attribute{
    -- hands that contain straights
    key = "straight_hands",
    keys = {
        'Straight',
        'Straight Flush',
        'akyrs_twinstraight',
        'akyrs_direstraight',
        'akyrs_direstraightflush',
        'akyrs_twinstraightflush',
    }
}


SMODS.Attribute{
    -- hands that contain at least one pair
    key = "pair_hands",
    keys = {
        'Pair',
        'Two Pair',
        'Three of a Kind',
        'Four of a Kind',
        'Five of a Kind',
        'Flush Five',
        'Full House',
        'akyrs_tripair',
        'akyrs_triplush',
        'akyrs_quadpair',
        'akyrs_quadplush',
        'akyrs_twintriple',
        'akyrs_twinflupple',
        'akyrs_triplettriple',
        'akyrs_tripletflupple',
        'akyrs_twinstraight',
        'akyrs_twinstraightflush',
    }
}


SMODS.Attribute{
    -- hands that contain at least 3oak
    key = "3oak_hands",
    keys = {
        'Three of a Kind',
        'Four of a Kind',
        'Five of a Kind',
        'Flush Five',
        'Full House',
        'Flush House',
        'akyrs_twintriple',
        'akyrs_twinflupple',
        'akyrs_triplettriple',
        'akyrs_tripletflupple',
    }
}

SMODS.Attribute{
    -- hands that contain at least 4oak
    key = "4oak_hands",
    keys = {
        'Four of a Kind',
        'Five of a Kind',
        'Flush Five',
    }
}

SMODS.Attribute{
    -- hands that contain at least two unique hands (i.e. full house = 3oak + pair)
    key = "unique_combination_hands",
    keys = {
        'Straight Flush',
        'Full House',
        'Flush Five',
        'Flush House',
        'akyrs_triplush',
        'akyrs_quadplush',
        'akyrs_twinflupple',
        'akyrs_tripletflupple',
        'akyrs_direstraightflush',
        'akyrs_twinstraightflush',
    }
}

SMODS.Attribute{
    -- hands that contain at least two hands (i.e. two pair = pair + pair)
    key = "combination_hands",
    keys = {
        'Two Pair',
        'Straight Flush',
        'Full House',
        'Flush Five',
        'Flush House',
        'akyrs_tripair',
        'akyrs_triplush',
        'akyrs_quadpair',
        'akyrs_quadplush',
        'akyrs_twintriple',
        'akyrs_twinflupple',
        'akyrs_triplettriple',
        'akyrs_tripletflupple',
        'akyrs_twinflush',
        'akyrs_flushbung',
        'akyrs_twinstraight',
        'akyrs_direstraight',
        'akyrs_direstraightflush',
        'akyrs_twinstraightflush',
    }
}

SMODS.Attribute{
    -- hands that you need more than 5 play size, all of these are from my mod
    key = "gt5_hands",
    keys = {
        'akyrs_tripair',
        'akyrs_triplush',
        'akyrs_quadpair',
        'akyrs_quadplush',
        'akyrs_twintriple',
        'akyrs_twinflupple',
        'akyrs_triplettriple',
        'akyrs_tripletflupple',
        'akyrs_twinflush',
        'akyrs_flushbung',
        'akyrs_twinstraight',
        'akyrs_direstraight',
        'akyrs_direstraightflush',
        'akyrs_twinstraightflush',
    }
}

