Love = require("love") --require? i hardly know re.
local ffi = require("ffi")
ffi.cdef[[
void dsp_note_on(float freq, float gain);
void dsp_note_off(float freq);
int  start_audio();
]]
local audio = ffi.load("audio.dll")

function Love.load()
    Notes = require("notes")
end

local audio_started = false

function Love.keypressed(key)
    local freq = Notes.ktn(key) or nil
    if key then
        if not audio_started then
            audio.start_audio()
            audio_started = true
        end
        if freq then
            audio.dsp_note_on(freq, 0.5)
        end
    end
end

function Love.keyreleased(key)
    local freq = Notes.ktn(key) or nil
    if freq then
        audio.dsp_note_off(freq)
    end
end

function Love.update(dt)
    
end


function Love.draw()

end