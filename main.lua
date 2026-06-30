Love = require("love") --require? i hardly know re.
local ffi = require("ffi")
ffi.cdef[[
void dsp_note_on(int timbre, float freq, float gain);
void dsp_note_off(float freq);
int  start_audio();
]]
local audio = ffi.load("audio.dll")
local instrument = 1
function Love.load()
    Notes = require("notes")
    Roll = require("roll/roll")
    H = Love.graphics.getHeight()
    W = Love.graphics.getWidth()
    Tempo = 200
    L = 64
    Roll.initialize(L)
    Love.graphics.setColor(0.8,0,0)
end

local audio_started = false

function Love.keypressed(key)
    local note = Notes.ktn(key) or nil
    local freq = Notes.ntf(note) or nil
    if key then
        if not audio_started then
            audio.start_audio()
            audio_started = true
        end
        if freq then
            audio.dsp_note_on(instrument, freq, 0.5)
        end
    end
    if key == "space" then
        Roll:pp()
        T = Love.timer.getTime()
    end
    if key == "1" then
        instrument = 1
    end
    if key == "2" then
        instrument = 2
    end
end

function Love.keyreleased(key)
    local note = Notes.ktn(key) or nil
    local freq = Notes.ntf(note) or nil
    if freq then
        audio.dsp_note_off(freq)
    end
end

function Love.mousepressed(x, y, button, istouch)
    if button == 1 then
        local gridx = math.ceil(x/16)
        local gridy = math.ceil(y/32)
        Roll.addNote(L, gridx, gridy)
    end
end

function Love.update(dt)
    -- Roll:update(audio, instrument)
end

function Love.draw()
    local rNotes = Roll:getNotes(L)

    -- draw a simple grid: white if bit = 1, black if 0
    for note = 0, L - 1 do           -- row index
        local row = rNotes[note]
        for pos = 0, L - 1 do        -- column index
            local v = row.posnotes[pos]

            if v ~= 0 then
                -- example: each cell is 4x4 pixels
                local x = pos * (W / 16)
                local y = note * (H / 32)
                Love.graphics.rectangle("fill", x, y, W / 16, H / 32)
            end
        end
    end

    Roll.free(rNotes, L)
end
