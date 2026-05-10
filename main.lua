Love = require("love") --require? i hardly know re.
local ffi = require("ffi")
ffi.cdef[[
void dsp_note_on(float freq, float gain);
void dsp_note_off(float freq);
int  start_audio();
]]
local audio = ffi.load("audio.dll")

local pf = nil

local natps = {}

function Love.load()
    Notes = require("notes")
    Roll = require("roll")
    H = Love.graphics.getHeight()
    W = Love.graphics.getWidth()
    Tempo = 200
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
            audio.dsp_note_on(freq, 0.5)
        end
    end
    if key == "space" then
        Roll:pp()
        T = Love.timer.getTime()
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
        local gridx = math.ceil(x/20)
        local gridy = math.ceil(y/10)
        Roll:addNote(gridx, gridy)
    end
end

function Love.update(dt)
    if Roll.playing then
        local t2 = Love.timer.getTime() - T
        local pos = math.ceil((t2/60)*(Tempo))
        local rNotes = Roll:getNotes()
        local note = rNotes[pos]
        local cf = Notes.ntf(note)
        if natps[pos] == nil then
            print(pos)
            if note then
                local pf = Notes.ntf(note-1)
            end
            if cf ~= nil then
                audio.dsp_note_on(cf, 0.5)
            end
            natps[pos] = true
        end
    elseif pf ~= nil then
        audio.dsp_note_off(pf)
    end
end


function Love.draw()
    local rNotes = Roll:getNotes()
    for pos, note in pairs(rNotes) do
        Roll:draw(pos, note)
    end
end