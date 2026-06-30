local roll = {}

roll.rNotes = {}

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

function roll:update(audio, instrument)
    if self.playing == true then
        audio.dsp_all_notes_off()
        self.rNotes = self:getNotes(L)
        for note = 0, 127 do
            if self.rNotes[note].posnotes[Pos] ~= 0 then
                audio.dsp_note_on(instrument, Notes.ntf(note), 0.5)
            end
        end
        self.free(self.rNotes, L)
        Pos = (Pos + 1) % 64
    end
end

function roll:draw()
    self.rNotes = Roll:getNotes(L)

    for note = 0, 127 do
        local row = self.rNotes[note]
        for pos = 0, L - 1 do
            local v = row.posnotes[pos]

            if v ~= 0 then
                local x = pos * math.floor(W / L)
                local y = note * math.floor(H / 128)
                Love.graphics.rectangle("fill", x, y, math.floor(W/L), math.floor(H/128))
            end
        end
    end

    self.free(self.rNotes, L)
end

function roll.free(rNotes, length)
    croll.free_pattern(rNotes, length)
end

return roll
