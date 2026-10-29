G.STATES.AKYRS_BOSS_SELECT = "akyrs_boss_select"

function AKYRS.update_custom_states(self, dt)
    if self.STATE == self.STATES.AKYRS_BOSS_SELECT then
        self:akyrs_update_boss_select(dt)
    end
end

local ubs = Game.update_blind_select
function Game:update_blind_select(dt)
    if G.GAME.akyrs_select_boss and not G.GAME.akyrs_boss_selected then
        if G.blind_select then 
            G.E_MANAGER:add_event(Event({
            trigger = 'before', delay = 0.2,
            func = function()
                G.blind_prompt_box.alignment.offset.y = -10
                if G.blind_select then
                    G.blind_select.alignment.offset.y = 40
                    G.blind_select.alignment.offset.x = 0
                end
                return true
            end}))
            G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if G.blind_select then
                    G.blind_select:remove()
                    G.blind_select = nil
                end
                G.blind_prompt_box:remove()
                self.STATE = self.STATES.AKYRS_BOSS_SELECT
                self.STATE_COMPLETE = false
                delay(0.2)
                return true
            end}))
            self.STATE = self.STATES.AKYRS_BOSS_SELECT
        end
    end
    return ubs(self,dt)
end
function Game:akyrs_update_boss_select(dt)
    if self.buttons then self.buttons:remove(); self.buttons = nil end
    AKYRS.deal_with_leftover_uis(self)
    if self.shop then self.shop:remove(); self.shop = nil end

    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.BLIND_SELECT)
        G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
        G.STATE_COMPLETE = true
        G.CONTROLLER.interrupt.focus = true
        G.E_MANAGER:add_event(Event({ func = function() 
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                play_sound('cancel')
                G.AKYRS_BLIND_CHOICE_ANTE = UIBox{
                    definition = {
                        n = G.UIT.ROOT,
                        config = {
                            w = 5, h = 5,
                        },
                        nodes = {
                            AKYRS.button_prefab {
                                button = 'akyrs_go_to_blind_select',
                                minw = 5, minh = 5,
                                children = {
                                    AKYRS.text_prefab { text = "GO TO BLIND SELECT (DEBUG)"}
                                }
                            }
                        }
                    },
                    config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29},major = G.hand, bond = 'Weak'}
                }
                G.AKYRS_BLIND_CHOICE_ANTE.alignment.offset.y = 0.8-(G.hand.T.y - G.jokers.T.y) + G.AKYRS_BLIND_CHOICE_ANTE.T.h
                G.ROOM.jiggle = G.ROOM.jiggle + 3
                G.AKYRS_BLIND_CHOICE_ANTE.alignment.offset.x = 0
                G.CONTROLLER.lock_input = false
                return true
            end
        }))  ; return true end}))
    end
end

G.FUNCS.akyrs_go_to_blind_select = function ()
    if G.AKYRS_BLIND_CHOICE_ANTE then
        G.E_MANAGER:add_event(Event({
          trigger = 'before', delay = 0.2,
          func = function()
            G.AKYRS_BLIND_CHOICE_ANTE.alignment.offset.y = 40
            G.AKYRS_BLIND_CHOICE_ANTE.alignment.offset.x = 0
            return true
        end}))
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            G.STATE_COMPLETE = false
            G.STATE = G.STATES.BLIND_SELECT
            G.GAME.akyrs_boss_selected = true
            G.AKYRS_BLIND_CHOICE_ANTE:remove()
            delay(0.2)
            return true
        end}))
    end
end