notes = {}

notes.ktn = function(key)
    local note_freqs = {
        ["a"] = 440.00,
        ["w"] = 466.16,
        ["s"] = 493.88,
        ["e"] = 523.25,
        ["d"] = 554.37,
        ["f"] = 587.33,
        ["t"] = 622.25,
        ["g"] = 659.25,
        ["y"] = 698.46,
        ["h"] = 739.99,
        ["u"] = 783.99,
        ["j"] = 830.61
    }
    return note_freqs[key]
end

return notes