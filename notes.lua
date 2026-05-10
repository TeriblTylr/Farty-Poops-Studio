notes = {}

notes.ntf = function(note)
    local note_freqs = {}
    if note then
        for i = 1, 128 do
            table.insert(note_freqs, note, 440*(2^((note-70)/12)))
        end
    end
    return note_freqs[note]
end

notes.ktn = function(key)
    local key_notes = {
        ["a"] = 70,
        ["w"] = 71,
        ["s"] = 72,
        ["e"] = 73,
        ["d"] = 74,
        ["f"] = 75,
        ["t"] = 76,
        ["g"] = 77,
        ["y"] = 78,
        ["h"] = 79,
        ["u"] = 80,
        ["j"] = 81
    }
    return key_notes[key]
end

return notes