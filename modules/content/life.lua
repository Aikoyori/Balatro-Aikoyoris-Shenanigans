AKYRS.Judgements = {}
AKYRS.Judgement_Buffer = {}
AKYRS.Judgement_Stickers = {}

function AKYRS.get_life_drain(card)
    if not AKYRS.Judgements[card.akyrs_judgement] then return 0 end
    if not AKYRS.Judgements[card.akyrs_judgement].value then return 0 end
    if not AKYRS.Judgements[card.akyrs_judgement].value[AKYRS.get_life_mode(card)] then return 0 end
    return ((AKYRS.Judgements[card.akyrs_judgement]).value[AKYRS.get_life_mode(card)][AKYRS.get_type_for_life_loc(card)] or 0 )
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
    loc_vars = function(self, info_queue, card)
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