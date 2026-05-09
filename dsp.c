static float phase = 0.0f;
static float g_freq = 440.0f;
static float g_gain = 0.3f;

__declspec(dllexport)
void dsp_set_freq(float f) {
    g_freq = f;
}

__declspec(dllexport)
void dsp_set_gain(float g) {
    g_gain = g; // insert badass skeleton keyboard here
}

__declspec(dllexport)
void dsp_process(float* out, int frames, float sr) {
    float inc = g_freq / sr;

    for (int i = 0; i < frames; i++) {
        out[i] = (phase < 0.5f ? g_gain : -g_gain);

        phase += inc;
        if (phase >= 1.0f)
            phase -= 1.0f;
    }
}