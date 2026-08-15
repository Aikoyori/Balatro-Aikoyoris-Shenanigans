local cardSellHook = Card.sell_card
local sell_hook = G.FUNCS.sell_card

G.FUNCS.sell_card = function(e)
    local card = e.config.ref_table
    if card.ability.akyrs_latticed then
        card:sell_card()
        return
    end
    
    if card.config.center.rarity == 3 then
        AKYRS.trigger_tldr_conditions("sold_a_rare_joker")
    end
    
    if card.config.center.key == "j_akyrs_tldr_joker" then
        AKYRS.trigger_tldr_conditions("has_sold_tldr")
    end
    sell_hook(e)
end


function Card:sell_card()
    if self.ability.akyrs_latticed then
        AKYRS.nope_buzzer(self,nil,G.C.playable)
        self:highlight(false)
        return
    end
    if (not (AKYRS.sigmaable_areas(self.area) and self.ability.akyrs_sigma)) or (AKYRS.is_card_not_sigma(self)) then
        self.akyrs_is_being_sold = true
        return cardSellHook(self)
    else
        AKYRS.nope_buzzer(self,nil,G.C.playable)
        self:highlight(false)
    end
end

local csc = Card.can_sell_card
function Card:can_sell_card(ctx) 
    if self.ability.akyrs_latticed then
        return false
    end
   return csc(self,ctx) 
end



local startRunHook = Game.start_run
function Game:start_run(args)
    G.SCORE_DISPLAY_QUEUE = nil
    G.AKYRS_CARD_EVAL_RAN = nil
    AKYRS.NO_UNHIGHLIGHT = nil
    G.AKYRS_LOCK_CARD_SELECTION = nil
    --print("PRE RUN")
    local ret = startRunHook(self, args)
    --print("POST RUN")
    
    AKYRS.reset_math_parser({
        vars = G.GAME.akyrs_parser_var or AKYRS.math_default_const,
    })
    if self.aiko_wordle then
        self.aiko_wordle:remove() self.aiko_wordle = nil
    end

    if not self.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
        --print("CHECK SUCCESS")
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
    
    if self.GAME.modifiers.akyrs_no_tarot_except_twof then
        for k, v in ipairs(G.P_CENTER_POOLS.Tarot) do
            if v.key ~= "c_wheel_of_fortune" then
                G.GAME.banned_keys[v.key] = true
            end
        end
        G.GAME.planet_rate = 0
    end
    if self.GAME.modifiers.akyrs_no_joker then
        for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
            G.GAME.banned_keys[v.key] = true
        end
    end
    if self.GAME.modifiers.akyrs_no_tarot then
        for k, v in ipairs(G.P_CENTER_POOLS.Tarot) do
            G.GAME.banned_keys[v.key] = true
        end
        G.GAME.tarot_rate = 0
    end
    if self.GAME.modifiers.akyrs_no_planet then
        for k, v in ipairs(G.P_CENTER_POOLS.Planet) do
            G.GAME.banned_keys[v.key] = true
        end
        G.GAME.planet_rate = 0
    end
    if self.GAME.modifiers.akyrs_can_buy_playing_cards then
        G.GAME.playing_card_rate = 4
    end
    
    if G.GAME.modifiers.akyrs_no_skips then
        G.GAME.akyrs_no_skips = G.GAME.modifiers.akyrs_no_skips
    end
    if G.GAME.modifiers.akyrs_hatena_deck then
        G.GAME.akyrs_hatena_deck = G.GAME.modifiers.akyrs_hatena_deck
    end
    
    if G.GAME.modifiers.akyrs_always_skip_shops then
        G.GAME.akyrs_always_skip_shops = G.GAME.modifiers.akyrs_always_skip_shops
    end
    if G.GAME.modifiers.akyrs_shops_after_boss then
        G.GAME.akyrs_shops_after_boss = G.GAME.modifiers.akyrs_shops_after_boss
    end
    if G.GAME.modifiers.akyrs_hatena_everything then
        G.GAME.akyrs_hatena_everything = G.GAME.modifiers.akyrs_hatena_everything
    end
    if self.GAME.modifiers.akyrs_no_hints then
        AKYRS.simple_event_add(
            function()
                G.GAME.akyrs_no_hints = true
                return true
            end, 0.5
        )
    end
    recalculateHUDUI()
    if G.GAME.current_round.advanced_blind then
        recalculateBlindUI()
    end
    if G.GAME.akyrs_any_drag then
        G.GAME.akyrs_temptation_resisted = true
        AKYRS.simple_event_add(
            function()
                G.jokers.states.collide.can = true
                G.consumeables.states.collide.can = true
                G.hand.states.collide.can = true
                G.deck.states.collide.can = true
                return true
            end, 0.5
        )
    end
    if #G.play.cards > 0 then
        for _,c in ipairs(G.play.cards) do
            G.deck:emplace(c)
        end
        G.play.cards = {}
    end
    for _,c in ipairs(G.playing_cards) do
        c:set_sprites(c.config.center,c.config.card)
    end
    AKYRS.update_life_ui(self)
    if G.jokers then
        G.jokers.config.highlighted_limit = 9e9
    end
    if G.consumeables then
        G.consumeables.config.highlighted_limit = 9e9
    end
    return ret
end


-- life is on the line that's why it's here too
local card_eval_status_text_ref = card_eval_status_text
function card_eval_status_text(card, ...)

    if AKYRS.is_life_enabled() and card then
        AKYRS.simple_event_add(function ()
            AKYRS.mod_life(AKYRS.get_life_drain(card), false, true)
            if G.akyrs_life_ui then
                G.akyrs_life_ui:get_UIE_by_ID("value_container"):juice_up(0.1,0.1)
            end
            return true
        end, 0)
    end
    
    
	local returnd = {card_eval_status_text_ref(card, ...)}
    return unpack(returnd)
end

local cuibdttp = create_UIBox_detailed_tooltip
function create_UIBox_detailed_tooltip(_center)
    if AKYRS.should_hide_ui() then
        return {
            n = G.UIT.ROOT,
            config = { maxw = 0, maxh = 0, colour = G.C.CLEAR},
            nodes = {}
        }
    end
    return cuibdttp(_center)
end


local eq_meta = Card.__eq or function (a,b) return rawequal(a, b) end
function Card:__eq(other)
    if G.STAGE == G.STAGES.RUN then
        if ((other.config or {}).center or {}).key == "j_akyrs_sulfur_cube" and other.akyrs_sulphur_card then
            return rawequal(self, other) or rawequal(self.akyrs_sulphur_card, other)
        end
        if ((other.config or {}).center or {}).key == "j_akyrs_sulfur_cube" and other.akyrs_sulphur_card then
            return rawequal(other, self) or rawequal(other.akyrs_sulphur_card, self)
        end
    end
    return rawequal(self, other)
end

local asds = AnimatedSprite.draw_self
function AnimatedSprite:draw_self()
    if not self.state then self.state = {} end
    return asds(self)
end



local game_start_up_ref = Game.start_up
function Game:start_up(...)
    local result = {game_start_up_ref(self, ...)}
	return unpack(result)
end

local tag_apply = Tag.apply_to_run
function Tag:apply_to_run(context)
    if not self.akyrs_enabled then return end
    return tag_apply(self,context)
end

local caalign = CardArea.align_cards
function CardArea:align_cards()
    if self.cards then
        for _, c in ipairs(self.cards) do
            AKYRS.post_rotate_cards(c)
        end
    end
    local x = caalign(self)
    if self.cards then
        for _, c in ipairs(self.cards) do
            AKYRS.rotate_cards(c)
        end
    end
    return x
end