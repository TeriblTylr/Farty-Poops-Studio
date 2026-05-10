// dsp.c
#define _USE_MATH_DEFINES
#include <math.h>

#define MAX_VOICES 16

typedef struct {
    int   active;
    int   timbre;
    float freq;
    float gain;
    float phase;
} Voice;

static Voice voices[MAX_VOICES];

__declspec(dllexport)
void dsp_all_notes_off(void) {
    for (int i = 0; i < MAX_VOICES; i++)
        voices[i].active = 0;
}

__declspec(dllexport)
void dsp_note_on(int timbre, float freq, float gain) {
    // find a free voice
    for (int i = 0; i < MAX_VOICES; i++) {
        if (!voices[i].active) {
            voices[i].active = 1;
            voices[i].timbre = timbre;
            voices[i].freq   = freq;
            voices[i].gain   = gain;
            voices[i].phase  = 0.0f;
            return;
        }
    }
    // simple: if no free voice, steal voice 0
    voices[0].active = 1;
    voices[0].timbre = timbre;
    voices[0].freq   = freq;
    voices[0].gain   = gain;
    voices[0].phase  = 0.0f;
}

__declspec(dllexport)
void dsp_note_off(float freq) {
    // naive: turn off first voice with matching freq
    for (int i = 0; i < MAX_VOICES; i++) {
        if (voices[i].active && voices[i].freq == freq) {
            voices[i].active = 0;
            return;
        }
    }
}

__declspec(dllexport)
void dsp_process(float* out, int frames, float sr) {
    for (int i = 0; i < frames; i++) {
        float mix = 0.0f;

        for (int v = 0; v < MAX_VOICES; v++) {
            if (!voices[v].active) continue;
            float inc = voices[v].freq / sr;
            switch (voices[v].timbre) {
                case 1:
                    float s   = (voices[v].phase < 0.5f ? voices[v].gain : -voices[v].gain);

                    mix += s;

                    voices[v].phase += inc;
                    if (voices[v].phase >= 1.0f)
                        voices[v].phase -= 1.0f;
                    break;
                case 2:
                    s = sinf(voices[v].phase) * voices[v].gain;

                    mix += s;

                    voices[v].phase += inc;
                    if (voices[v].phase >= (float)M_PI)
                        voices[v].phase -= (float)M_PI;
                    break;
            }
        }
        out[i] = mix;
    }
}
