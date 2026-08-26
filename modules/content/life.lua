AKYRS.Judgements = {}
AKYRS.Judgement_Buffer = {}
AKYRS.Judgement_Stickers = {}

function AKYRS.get_life_drain(card, force_mode, force_life_mode)
    local life_drain = 0
    if not AKYRS.Judgements[card.akyrs_judgement] then return 0 end
    if not AKYRS.Judgements[card.akyrs_judgement].value then return 0 end
    if not AKYRS.Judgements[card.akyrs_judgement].value[force_mode or AKYRS.get_life_mode(card)] then return 0 end
    life_drain = ((AKYRS.Judgements[card.akyrs_judgement]).value[force_mode or AKYRS.get_life_mode(card)][force_life_mode or AKYRS.get_type_for_life_loc(card)] or 0 )
    -- some more code for tap card
    if SMODS.has_enhancement(card,"m_akyrs_tap_card") then
        life_drain = math.ceil(life_drain / 2)
    end
    return life_drain
end

function AKYRS.get_type_for_life_loc(card)
    local typer = "joker"
    if card.ability.set == "Default" or card.ability.set == "Enhanced" then
        typer = "playing_card"
    end
    return typer
end

function AKYRS.is_life_enabled()
    return G.GAME.akyrs_life_decay_mode == "normal" or G.GAME.akyrs_life_decay_mode == "kaleidoscope"
end
function AKYRS.get_life_mode()
    return G.GAME.akyrs_life_decay_mode
end
function AKYRS.get_life()
    return G.GAME.akyrs_life
end

function AKYRS.get_life_cover_type()
    return G.GAME.akyrs_life_cover_sprite == "kaleidoscope_pre" or G.GAME.akyrs_life_cover_sprite == "kaleidoscope" and "kaleidoscope" or "normal" 
end

function AKYRS.mod_life(life, forced, duration, set)
    if life == 0 and not set then return end
    if G.GAME.akyrs_life == life and set then return end
    local life_target = math.min(G.GAME.akyrs_life + life, G.GAME.akyrs_starting_life or 500)
    if set then life_target = life end
    G.GAME.akyrs_life_internal = life_target
    if duration and (duration == true or duration <= 0) then
        G.GAME.akyrs_life = G.GAME.akyrs_life_internal
        return
    end
    AKYRS.better_ease_value(G.GAME, "akyrs_life", G.GAME.akyrs_life_internal, nil, 'REAL', true, true, (duration ~= true and duration or 0.5), 'inexpo')
end

---@type SMODS.GameObject 
AKYRS.Judgement = SMODS.GameObject:extend {
    obj_table = AKYRS.Judgements,
    obj_buffer = AKYRS.Judgement_Buffer,
    set = 'Judgement',
    required_params = {
        "key",
    },
    discovered = true,
    locked = false,
    available = true,
    class_prefix = "judgement",
    atlas = "akyrs_judgement",
    pos = { x = 0, y = 0 },
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        AKYRS.Judgement.super.register(self)
        self.order = #self.obj_buffer
    end,
    value = {
        normal = {
            joker = 0,
            playing_card = 0,
        },
        kaleidoscope = {
            joker = 0,
            playing_card = 0,
        },
    },
    loc_vars = function(self, info_queue, card)
        if card.akyrs_collection_judgement then
            return {
                vars = {
                    self.value[AKYRS.get_life_mode() == "none" and "normal" or AKYRS.get_life_mode()].playing_card,
                    self.value[AKYRS.get_life_mode() == "none" and "normal" or AKYRS.get_life_mode()].joker,
                }
            }
        end
        return {
            vars = {
                SMODS.signed(AKYRS.get_life_drain(card))
            }
        }
    end,
    inject = function(self)
        self.judgement_sprite = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, self.atlas, self.pos)
        AKYRS.Judgement_Stickers[self.key] = self.judgement_sprite
    end,
}

AKYRS.Judgement {
    key = "none",
    atlas = "blank",
    value = {
        normal = {
            joker = -7,
            playing_card = -3,
        },
        kaleidoscope = {
            joker = -10,
            playing_card = -5,
        },
    }
}

AKYRS.Judgement {
    key = "miss",
    pos = { x = 0, y = 0 },
    value = {
        normal = {
            joker = -5,
            playing_card = -2,
        },
        kaleidoscope = {
            joker = -7,
            playing_card = -3,
        },
    }
}

AKYRS.Judgement {
    key = "good",
    pos = { x = 1, y = 0 },
    value = {
        normal = {
            joker = -3,
            playing_card = -1,
        },
        kaleidoscope = {
            joker = -5,
            playing_card = -2,
        },
    }
}

AKYRS.Judgement {
    key = "great",
    pos = { x = 2, y = 0 },
    value = {
        normal = {
            joker = -1,
            playing_card = -0.5,
        },
        kaleidoscope = {
            joker = -3,
            playing_card = -1,
        },
    }
}

AKYRS.Judgement {
    key = "perfect",
    pos = { x = 3, y = 0 },
    value = {
        normal = {
            joker = -0,
            playing_card = -0,
        },
        kaleidoscope = {
            joker = -1,
            playing_card = -0.5,
        },
    }
}

AKYRS.Judgement {
    key = "critical_perfect",
    pos = { x = 4, y = 0 },
    value = {
        normal = {
            joker = -0,
            playing_card = -0,
        },
        kaleidoscope = {
            joker = -0,
            playing_card = -0,
        },
    }
}