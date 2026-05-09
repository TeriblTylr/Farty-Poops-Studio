Love = require("love") --require? i hardly know re.
local ffi = require("ffi")
ffi.cdef[[
int start_audio();
void dsp_set_freq(float f);
void dsp_set_gain(float g);
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
            audio.dsp_set_freq(freq)
        end
        audio.dsp_set_gain(0.5)
    end
end

function Love.keyreleased(key)
    audio.dsp_set_gain(0.0)
end

function Love.update(dt)
    
end


function Love.draw()

end