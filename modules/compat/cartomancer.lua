if Cartomancer then
    local cartomancer_strng_hook = Card.cart_to_string
    function Card:cart_to_string(arg) 
        local r =  cartomancer_strng_hook(self,arg)
        if arg.deck_view and Cartomancer.SETTINGS.deck_view_stack_enabled then
            if AKYRS.should_draw_letter(self) then
                if self.is_null and self.ability.aikoyori_letters_stickers then
                    r = self.ability.aikoyori_letters_stickers
                elseif self.ability.aikoyori_letters_stickers then
                    r = r..self.ability.aikoyori_letters_stickers
                end
            end
            if self.ability.akyrs_special_card_type and not self.is_null then 
                r = r.."_PURE_"..self.ability.akyrs_special_card_type
            end
        end
        return r
        
    end
end