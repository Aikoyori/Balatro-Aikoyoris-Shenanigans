if CardSleeves then
    CardSleeves.Sleeve {
        key = "letter",
        atlas = "aikoyoriSleeves",
        pos = { x = 0, y = 0 },
        config = {
            vouchers = {'v_akyrs_alphabet_soup' } 
        },
        loc_vars = function(self)
            local key, vars
            --print(self.get_current_deck_key())
            if self.get_current_deck_key() == "b_akyrs_letter_deck" then
                key = self.key .. "_alt"
                self.config = { deck_size = 2, discards = 6, hand_size = 6, ante_scaling = 12 }
                vars = { self.config.deck_size, self.config.discards, self.config.hand_size, self.config.ante_scaling  }
            elseif self.get_current_deck_key() == "b_akyrs_math_deck" then
                key = self.key .. "_math_pro"
                self.config = { akyrs_starting_letters = AKYRS.math_deck_pro_characters, akyrs_letters_no_uppercase = true, hands = 2, hand_size = 2, discards = 2 }
                vars = { self.config.hands, self.config.hand_size, self.config.discards,   }
            else
                key = self.key
                self.config = { vouchers = {'v_akyrs_alphabet_soup' }, ante_scaling = 2, deck_size = 1, akyrs_hand_to_not_hide = {["akyrs_expression"] = true,["akyrs_modification"] = true,["akyrs_assignment"] = true }, }
                vars = {  }
            end
            return { key = key, vars = vars }
        end,
        apply = function(self, sleeve)
            G.GAME.starting_params.deck_size_letter = sleeve.config.deck_size
            if (sleeve.config.akyrs_starting_letters) then
                G.GAME.starting_params.akyrs_starting_letters = sleeve.config.akyrs_starting_letters
            end
            if (sleeve.config.akyrs_letters_no_uppercase) then
                G.GAME.starting_params.akyrs_letters_no_uppercase = sleeve.config.akyrs_letters_no_uppercase
            end
            if (sleeve.config.akyrs_hand_to_not_hide) then
                G.GAME.starting_params.akyrs_hand_to_not_hide = sleeve.config.akyrs_hand_to_not_hide
            end
            CardSleeves.Sleeve.apply(sleeve)
        end
    }
end