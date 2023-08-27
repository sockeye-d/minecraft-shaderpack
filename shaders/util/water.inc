#ifndef NOISE_INC
#include "noise.inc"
#define NOISE_INC
#endif

#define WAVE_SIZE 0.5
#define WAVE_SPEED 1.0
#define WAVE_HEIGHT 0.2

vec2 singleWaveDx(float x) {
    return vec2(sin(x), cos(x));
}

vec3 waterHeight(in vec2 p, float time, float octaves) {
    float a = 2.718;
    float b = 0.5;

    float f = 1.0;
    float m = 1.0;

    float r = 0.0;
    vec2 d = vec2(0);
    
    for(float i = 0.0; i < octaves; i++) {
        vec4 octave = noised(vec3(p * f + time * (i + 1.0), time + i * 0.707).xzy);
        r += octave.x * m;
        d += octave.yz;
        f *= a;
        m *= b;
        p.xy = p.yx * vec2(-1, 1);
    }
    return vec3(r, d);
}

vec3 normalFromGrad(vec2 d)
{
    vec3 a = normalize(vec3(1, -d.x, 0)),
         b = normalize(vec3(0, -d.y, 1));
    return cross(a, b);
}

mat3 tbn(vec3 n)
{
    vec3 b1, b2;
    // If n is near the x - axis , use the y - axis . Otherwise use the x - axis .
    if ( n.x > 0.9)
        b1 = vec3(0.0, 1.0, 0.0);
    else
        b1 = vec3(1.0, 0.0, 0.0);
    b1 -= n * dot(b1 , n); // Make b1 orthogonal to n

    b1 = normalize(b1);
    b2 = cross (n, b1);

    return mat3(b1, b2, n);
}
