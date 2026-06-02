#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"

void dsp_process(float* out, int frames, float sr);

void audio_callback(ma_device* device, void* output, const void* input, ma_uint32 frameCount) {
    dsp_process((float*)output, (int)frameCount, (float)device->sampleRate);
}

__declspec(dllexport)
int start_audio() {
    ma_device_config cfg = ma_device_config_init(ma_device_type_playback);
    cfg.playback.format   = ma_format_f32;
    cfg.playback.channels = 1;
    cfg.sampleRate        = 48000;
    cfg.dataCallback      = audio_callback;

    static ma_device dev;
    if (ma_device_init(NULL, &cfg, &dev) != MA_SUCCESS)
        return 0;

    ma_device_start(&dev);
    return 1;
}
