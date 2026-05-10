local roll = {}

roll.notes = {}

roll.playing = false

roll.pf = nil

roll.natps = {}

function roll:addNote(pos, note)
    roll.notes[pos] = note
end

function roll:getNotes()
    return roll.notes
end

function roll:pp()
    if not roll.playing then
        roll.playing = true
    else
        roll.playing = false
    end
end

function roll:update(audio)
    if roll.playing then
        local t2 = Love.timer.getTime() - T
        local pos = math.ceil((t2/60)*(Tempo))
        local rNotes = Roll:getNotes()
        local note = rNotes[pos]
        local cf = Notes.ntf(note)
        local pnote = rNotes[pos-1]
        if roll.natps[pos] == nil then
            print(pos)
            if pnote then
                roll.pf = Notes.ntf(pnote)
            end
            if cf ~= nil then
                audio.dsp_note_on(cf, 0.5)
            end
            Roll.natps[pos] = true
        end
        if roll.natps[pos-1] == true then
            if roll.pf ~= nil then audio.dsp_note_off(roll.pf) end
        end
    elseif roll.pf ~= nil then
        audio.dsp_note_off(roll.pf)
    end
end

function roll:draw(x, y)
    Love.graphics.setColor(0.8, 0, 0)
    Love.graphics.rectangle("fill", (x-1)*20, (y-1)*10, 20, 10)
end

return roll
