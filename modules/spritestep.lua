
SMODS.SpriteStep {
	key = "enchanted",
	func = function(self, image, quad, sprite)
		local shader = G.SHADERS['akyrs_enchanted_step']
		love.graphics.setShader(shader)
		local card = sprite.parent or sprite.role.major
        shader:send("time", G.TIMERS.REAL)
        shader:send("texture_details",sprite:get_pos_pixel())
        shader:send("image_details",sprite:get_image_dims())
		love.graphics.draw(image,quad,0,0)
	end,
	should_apply = function(self, sprite)
		local card = sprite.parent or sprite.role.major
		if card and card.ability then
			return card.akyrs_enchantments or card.akyrs_stored_enchantments
		end
		return false
	end,
	order = 0
}