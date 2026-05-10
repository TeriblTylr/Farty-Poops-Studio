local roll = {}

roll.notes = {}

roll.playing = false

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

function roll:draw(x, y)
    Love.graphics.setColor(0.8, 0, 0)
    Love.graphics.rectangle("fill", (x-1)*20, (y-1)*10, 20, 10)
end

return roll
