local roll = {}

roll.notes = {}

roll.playing = false

local ffi = require("ffi")

ffi.cdef[[
    void init_pattern(unsigned short length);
    void write_pattern(unsigned short length, unsigned short pos, unsigned short note);

    typedef struct {
        unsigned short pos;
        unsigned short *posnotes;
    } rollNotes;

    rollNotes* read_pattern(unsigned short length);
    void free_pattern(rollNotes *notes, unsigned short length);
]]

local croll = ffi.load("roll.dll")

function roll.initialize(length)
    croll.init_pattern(length)
end

function roll.addNote(length, pos, note)
    croll.write_pattern(length, pos, note)
end

function roll:getNotes(length)
    local rNotes = croll.read_pattern(length)
    return rNotes
end

function roll:pp()
    if not roll.playing then
        roll.playing = true
    else
        roll.playing = false
    end
end

-- function roll:update(audio, instrument)

-- end

-- function roll:draw(x, y)

-- end

function roll.free(rNotes, length)
    croll.free_pattern(rNotes, length)
end

return roll
