
local hook_capture = Game.hook_capture or function (e) return e end
function Game:hook_capture()
    G.GAME.hook_as_capt = "Game.hook_capture" -- new API
    G._RUN_HOOK()
end