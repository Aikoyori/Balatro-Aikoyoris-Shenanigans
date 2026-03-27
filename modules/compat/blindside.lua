if AKYRS.is_mod_loaded("Blindside") and AKYRS.config.experimental_features then
    BLINDSIDE.Blind{
        key = "the_choice",
        atlas = "aikoBlindside",
        pos = { x = 0, y = 0},
        hues = { "Faded" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_reject",
        atlas = "aikoBlindside",
        pos = { x = 1, y = 0},
        hues = { "Faded" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_redo",
        atlas = "aikoBlindside",
        pos = { x = 2, y = 0},
        hues = { "Yellow" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_reverse",
        atlas = "aikoBlindside",
        pos = { x = 3, y = 0},
        hues = { "Red" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_selfish",
        atlas = "aikoBlindside",
        pos = { x = 4, y = 0},
        hues = { "Blue" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_polite",
        atlas = "aikoBlindside",
        pos = { x = 5, y = 0},
        hues = { "Yellow" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_libre",
        atlas = "aikoBlindside",
        pos = { x = 6, y = 0},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_picker",
        atlas = "aikoBlindside",
        pos = { x = 7, y = 0},
        hues = { "Green" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_height",
        atlas = "aikoBlindside",
        pos = { x = 8, y = 0},
        hues = { "Blue" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_expiry",
        atlas = "aikoBlindside",
        pos = { x = 9, y = 0},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_nature",
        atlas = "aikoBlindside",
        pos = { x = 0, y = 1},
        hues = { "Green" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_key",
        atlas = "aikoBlindside",
        pos = { x = 1, y = 1},
        hues = { "Yellow" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_alignment",
        atlas = "aikoBlindside",
        pos = { x = 2, y = 1},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_duality",
        atlas = "aikoBlindside",
        pos = { x = 3, y = 1},
        hues = { "Red" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_collapse",
        atlas = "aikoBlindside",
        pos = { x = 4, y = 1},
        hues = { "Yellow" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_bonsai",
        atlas = "aikoBlindside",
        pos = { x = 5, y = 1},
        hues = { "Green" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_base",
        atlas = "aikoBlindside",
        pos = { x = 6, y = 1},
        hues = { "Blue" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_stomata",
        atlas = "aikoBlindside",
        pos = { x = 7, y = 1},
        hues = { "Green" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_rhizome",
        atlas = "aikoBlindside",
        pos = { x = 8, y = 1},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_shrink",
        atlas = "aikoBlindside",
        pos = { x = 9, y = 1},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_harmonic",
        atlas = "aikoBlindside",
        pos = { x = 0, y = 2},
        hues = { "Yellow" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_sinusoidal",
        atlas = "aikoBlindside",
        pos = { x = 1, y = 2},
        hues = { "Purple" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
    BLINDSIDE.Blind{
        key = "the_saw",
        atlas = "aikoBlindside",
        pos = { x = 2, y = 2},
        hues = { "Green" },
        config = {
            extra = {
                value = 1,
            }
        },
        set_badges = function (self, card, badges)
            if self.discovered then SMODS.create_mod_badges({ mod = BLINDSIDE.current_mod },badges) end
        end,
        calculate = function( self, info_queue, card)
        end,
        
        upgrade = function(card) 
            if not card.ability.extra.upgraded then
                -- do smth
                card.ability.extra.upgraded = true
            end
        end
    }
end