#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

const char* get_filepath() 
{
    const char *appdata = getenv("APPDATA");
    char *path = malloc(512);

    sprintf(path, "%s\\LOVE\\Farty Poops Studio\\pattern.bin", appdata);
    return path;
}

__declspec(dllexport)
void init_pattern(unsigned short length)
{
    const char *path = get_filepath();
    FILE *f = fopen(path, "wb+");
    free((void*)path);

    if (!f) {
        perror("Failed to open file");
        return;
    }

    size_t pad_bytes = (16 * length) + 2;
    unsigned char *zeros = calloc(pad_bytes, 1);
    fwrite(zeros, 1, pad_bytes, f);
    free(zeros);

    fseek(f, 0, SEEK_SET);
    fwrite(&length, 2, 1, f);

    fclose(f);
}

__declspec(dllexport)
void write_pattern(unsigned short length, unsigned short pos, unsigned short note)
{
    const char *path = get_filepath();
    FILE *f = fopen(path, "rb+");
    free((void*)path);

    if (!f) {
        perror("Failed to open file");
        return;
    }

    unsigned int line_offset = ((length / 8) * note) + 2;
    unsigned short byte_offset = pos / 8;
    unsigned short bit_offset = pos % 8;

    unsigned char bit;

    fseek(f, line_offset + byte_offset, SEEK_SET);
    fread(&bit, 1, 1, f);

    bit ^= (1 << bit_offset);

    fseek(f, -1, SEEK_CUR); // seek_cur? i hardly know ur.
    fwrite(&bit, 1, 1, f);

    fclose(f);
}

typedef struct {
    unsigned short pos;
    unsigned short *posnotes;
} rollNotes;

__declspec(dllexport)
rollNotes* read_pattern(unsigned short length)
{
    const char *path = get_filepath();
    FILE *f = fopen(path, "rb");
    free((void*)path);

    if (!f) {
        perror("Failed to open file");
        return NULL;
    }

    fseek(f, 2, SEEK_SET);

    rollNotes *notes = malloc(128 * sizeof(rollNotes));

    unsigned int bytes_per_note = length / 8;

    for (int note = 0; note < 128; note++) {
        notes[note].pos = note;
        notes[note].posnotes = calloc(length, sizeof(unsigned short));

        for (int byte = 0; byte < bytes_per_note; byte++) {
            unsigned char b;
            fread(&b, 1, 1, f);

            for (int bit = 0; bit < 8; bit++) {
                int pos = byte * 8 + bit;
                if (pos < length) {
                    notes[note].posnotes[pos] = (b >> bit) & 1;
                }
            }
        }
    }

    fclose(f);
    return notes;
}


__declspec(dllexport)
void free_pattern(rollNotes *notes, unsigned short length)
{
    for (int i = 0; i < 128; i++) {
        free(notes[i].posnotes);
    }
    free(notes);
}
