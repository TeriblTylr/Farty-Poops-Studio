Love = require("love") --require? i hardly know re.
local ffi = require("ffi")
ffi.cdef[[
void dsp_note_on(int timbre, float freq, float gain);
void dsp_note_off(float freq);
void dsp_all_notes_off(void);
int  start_audio();
]]
local audio = ffi.load("audio.dll")
local instrument = 1
Pos = 0
local t = 0
function Love.load()
    Notes = require("notes")
    Roll = require("roll/roll")
    H = Love.graphics.getHeight()
    W = Love.graphics.getWidth()
    Tempo = 200
    L = 64
    Roll.initialize(L)
    Love.graphics.setColor(0.9,0,0) --color? i hardly know or.
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
    H = Love.graphics.getHeight()
    W = Love.graphics.getWidth()
    if button == 1 then
        local gridx = math.floor(x/math.floor(W/64))
        local gridy = math.floor(y/math.floor(H/128))
        Roll.addNote(L, gridx, gridy)
    end
end


local function every(interval, dt, timer)
    timer = timer + dt -- timer? i hardly know er.
    if timer >= interval then
        timer = timer - interval
        return true, timer
    end
    return false, timer
end


function Love.update(dt)

    local fire, newt = every(60 / Tempo, dt, t)
    t = newt -- lizard lizard lizard lizard

    if fire then
        Roll:update(audio, instrument)
    end

end
function Love.draw()
    Roll:draw()
end
