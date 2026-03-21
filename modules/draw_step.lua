AKYRS.status_card_render_offset_x = 0.5
AKYRS.status_card_render_offset_y = 0.2
function AKYRS.aikoyori_draw_extras(card, layer)
    ---@type Card
    card = card
    if not card then return end
    if not (AKYRS.should_draw_letter(card)) then return end

    local letter_key = card:get_letter_with_pretend()
    local is_wild = card.ability.aikoyori_letters_stickers == "#" and card.ability.aikoyori_pretend_letter and card.ability.aikoyori_pretend_letter ~= ''
    if not letter_key then return end
    ---@type Sprite[]
    local stickers = AKYRS.aikoyori_letters_stickers

    local movement_mod = 0.05 * math.sin(1.1 * (G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
    local center = card.children.center

    local function draw_status(status)
        if AKYRS.config.colourblind_ui then
            status = status .. "_hc"
        end
        ---@type Sprite
        local sticker = stickers[status]
        
        sticker.role.draw_major = card
        sticker.VT = card.VT
        local scale_fac = card.T.w / G.CARD_W
        local rox, roy = AKYRS.status_card_render_offset_x * scale_fac, AKYRS.status_card_render_offset_y * scale_fac
        sticker:draw_shader('dissolve', 0, nil, nil, center, 0.1, nil, -rox, roy)
        sticker:draw_shader('dissolve', nil, nil, nil, center, nil, nil, -rox, roy-0.02 + movement_mod * 0.9)
    end

    local round = G.GAME.current_round
    local lkey_lower = letter_key:lower()
    if round.aiko_round_correct_letter and round.aiko_round_correct_letter[lkey_lower] then
        draw_status("correct")
    elseif round.aiko_round_misaligned_letter and round.aiko_round_misaligned_letter[lkey_lower] then
        draw_status("misalign")
    elseif round.aiko_round_incorrect_letter and round.aiko_round_incorrect_letter[lkey_lower] then
        draw_status("incorrect")
    end
    local tint = false
    if is_wild then
        tint = true
    end

    if card.akyrs_letter and type(card.akyrs_letter) == "table" then
        if tint then
            for i,st in ipairs(card.akyrs_letter) do
                ---@type Sprite
                st = st 
                local pos =  ((#card.akyrs_letter) - (i)) * 0.5
                st:draw_shader('akyrs_magenta_tint', nil, nil, nil, center, nil, nil, nil, -pos-0.02 + movement_mod * 0.9)
            end
        else
            for i,st in ipairs(card.akyrs_letter) do
                local pos =  ((#card.akyrs_letter) - (i)) * 0.5
                st:draw_shader('dissolve', nil, nil, nil, center, nil, nil, nil, -pos-0.02 + movement_mod * 0.9)
            end
        end
    end
end

SMODS.DrawStep{
    key = "extras",
    order = 50,
    func = function (card, layer)
        AKYRS.aikoyori_draw_extras(card,layer)
    end,
    conditions = { vortex = false, facing = 'front' },
}
local old_draw_step_front = SMODS.DrawSteps.front.func
SMODS.DrawStep:take_ownership('front', {
    func = function(self, layer)
    if not self.is_null then
        old_draw_step_front(self,layer)
    elseif self.children.front then
        self.children.front:remove()
        self.children.front = nil
    end
    end,
})

local origSoulRender = SMODS.DrawSteps.floating_sprite.func
SMODS.DrawStep:take_ownership('floating_sprite',{
    func = function (self, layer)
        if self.config and self.config.center_key and self.config.center_key == "j_akyrs_aikoyori" then
            if self.config.center.soul_pos and (self.config.center.discovered or self.bypass_discovery_center) then
                local scale_mod = 0.1
                local rotate_mod = 0
                if AKYRS.bal("absurd") and not G.SETTINGS.reduced_motion then
                    
                    local x = G.TIMERS.REAL * 0.2
                    rotate_mod = ((1 - math.abs((-x-math.floor(-x)) * math.sin(-x*math.pi)) ^ 0.6)*2) * 2 * math.pi
                else
                    rotate_mod = 0.08*math.cos(1.94236*G.TIMERS.REAL) + (AKYRS.bal_val(0,math.pi) or 0)
                end
                
                local xmod = 0
                local ymod = 0.1*math.sin(2.1654*G.TIMERS.REAL) - 0.1
                self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,xmod,ymod,nil, 0.6)
                self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod,xmod,ymod-0.2)
                if self.edition then 
                    for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                        if v.apply_to_float then
                            if self.edition[v.key:sub(3)] then
                                self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod,xmod,ymod-0.2)
                            end
                        end
                    end
                end
            end
        else
            origSoulRender(self,layer)
        end
    end
})

SMODS.DrawStep{
    key = "pinned_sticker",
    order = 95,
    func = function(self)
        if self.pinned then
            if not AKYRS.pinned_sticker then
                AKYRS.pinned_sticker = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["akyrs_aikoyoriStickers"], {x = 4,y = 0}) 
            end
            AKYRS.pinned_sticker.role.draw_major = self
            AKYRS.pinned_sticker:draw_shader('dissolve', nil, nil, nil, self.children.center,nil,nil,nil,-0.3)
            AKYRS.pinned_sticker:draw_shader('voucher', nil, nil, nil, self.children.center,nil,nil,nil,-0.3)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys["akyrs_redeem_voucher"] = true
SMODS.draw_ignore_keys["akyrs_collection_ui"] = true


SMODS.DrawStep {
    key = 'misc_btns',
    order = -30,
    func = function(self)
        --Draw any tags/buttons
        if self.children.akyrs_wildcard then self.children.akyrs_wildcard:draw() end
        if self.children.akyrs_redeem_voucher then self.children.akyrs_redeem_voucher:draw() end
        if self.children.akyrs_collection_ui then self.children.akyrs_collection_ui:draw() end
    end,
} 