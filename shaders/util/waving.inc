#ifndef NOISE_INC
#include "noise.inc"
#define NOISE_INC
#endif

vec3 wavingOffset(vec3 p, float time, float str) {
    return (rgbNoise(p * 0.1 + time * vec3(1, 0.5, 0.25) * 2.0) - 0.5) * str * vec3(1, 0.5, 1);
}
