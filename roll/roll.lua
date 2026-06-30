local roll = {}

roll.notes = {}

roll.playing = false

roll.pf = nil

roll.natps = {}

local ffi = require("ffi")

ffi.cdef[[
    
]]

local croll = ffi.load("roll.dll")

function roll:initialize()
    Love.filesystem.write()
end

function roll:addNote(pos, note)
    croll.write_pattern(pos, note)
end

function roll:getNotes()
    
end

function roll:pp()
    if not roll.playing then
        roll.playing = true
    else
        roll.playing = false
    end
end

function roll:update(audio, instrument)

end

function roll:draw(x, y)
    Love.graphics.setColor(0.8, 0, 0)
    Love.graphics.rectangle("fill", (x-1)*20, (y-1)*10, 20, 10)
end

return roll
