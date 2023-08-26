#ifndef NOISE_INC
#include "noise.inc"
#define NOISE_INC
#endif

#define AXIS_X vec3(1, 0, 0)
#define AXIS_Y vec3(0, 1, 0)
#define AXIS_Z vec3(0, 0, 1)

#define PI  3.1415927
#define TAU 6.2831853

vec3 rot(vec3 p, vec3 k, float t)
{
    k = normalize(k);
    return mix(k*dot(k,p), p, cos(t)) + cross(k, p)*sin(t);
}

vec3 sunPosition(int ticks) {
    float t = (float(ticks) / 24000.0) * TAU;
    return rot(AXIS_X, AXIS_Z, t);
}

vec3 moonPosition(int ticks) {
    float t = (float(ticks + 12000) / 24000.0) * TAU;
    return rot(AXIS_X, AXIS_Z, t);
}

#define invMix(a, b, x) ((x - a) / (b - a))

float remap(float inMin, float inMax, float outMin, float outMax, float x) {
    mix(outMin, outMax, invMix(x, inMin, inMax));
}

vec2 modifyLightmap(vec2 lm)
{
    return lm * lm;
}

vec4 applyLighting(vec4 color, vec3 normal, vec2 lightmap, vec3 sunPos, vec3 moonPos) {
    vec3 c = color.rgb;
    vec3 l = vec3(0);

    lightmap = modifyLightmap(lightmap);

    vec3 sun = vec3(max(0.0, dot(normal, sunPos))*0.5+0.5) * 5.0;
    sun = mix(vec3(0), sun, smoothstep(-0.3, 0.3, sunPos.y));
    sun *= mix(vec3(1.0, 0.5, 0.0), vec3(1), max(0.0, sunPos.y));
    sun *= lightmap.g;
    l += sun;

    float moon = max(0.0, dot(normal, moonPos))*0.5+0.5;
    moon = mix(0.0, moon, smoothstep(-0.3, 0.3, moonPos.y));
    moon *= lightmap.g;
    moon *= 0.5;
    l += moon;

    l += lightmap.r * vec3(1.0, 0.8, 0.4);

    c *= l;
    //return vec4(normal, color.a);
    return vec4(c, color.a);
}

vec4 applyLightmap(vec4 color, vec2 lightmap, vec3 sunPos, vec3 moonPos) {
    vec3 c = color.rgb;
    vec3 l = vec3(0);

    lightmap = modifyLightmap(lightmap);

    l += lightmap.g * smoothstep(-0.3, 0.3, sunPos.y);

    l += lightmap.r * vec3(1.0, 0.8, 0.4);

    c *= l;

    return vec4(c, color.a);
}

vec3 sunAndMoon(vec3 r, vec3 l, vec3 m, int moonPhase) {
    #define SUN_SIZE 0.0025
    #define MOON_SIZE 0.001

    vec3 sunDisk = smoothstep(1.0 - SUN_SIZE, 1.0, max(0.0, dot(r, l)))*vec3(1.0,0.55,0.1) * 5000.0 * smoothstep(-0.1, 1.0, r.y);
    vec3 moonDisk = smoothstep(1.0 - MOON_SIZE, 1.0 - MOON_SIZE * 0.99, max(0.0, dot(r, m)))*vec3(1) * 4.0;

    vec2 moonLocalCoord = clamp((mat3(m, cross(m, AXIS_Z), AXIS_Z) * r).yz / acos(1.0 - MOON_SIZE), vec2(-1), vec2(1));
    vec3 moonSphere = vec3(moonLocalCoord, sqrt(1.0 - dot(moonLocalCoord, moonLocalCoord))).xzy;
    float moonTex = fbm(moonSphere*2.0, 2.0);
    moonTex *= moonTex * moonTex;
    moonDisk *= max(0.0, moonTex * 0.9 + 0.1);
    moonDisk *= max(0.0, dot(moonSphere, rot(AXIS_Y, AXIS_X, -float(moonPhase) / 7.0 * TAU))) * 2.0 * vec3(0.7, 0.8, 1) + 0.05;

    return sunDisk + moonDisk;
}

vec3 skylight(vec3 r, vec3 l, vec3 m, int moonPhase)
{
    // Utility macros
    #define impulse(x, k) k*x*exp(1.0 - k*x)
    #define sustain(x, k, p) pow(1.0 - exp(-k*x), p)
    
    // Get the "time"
    float sunBrightness = smoothstep(-0.3, 1.0, l.y);
    
    // Get the gradient value
    float cx = (max(0.0, r.y) + 0.3) * sunBrightness * 0.9;
    // Distort gradient value by how far away it is from the sun
    // replicating the Earth's shadow
    cx -= acos(dot(r, l)*0.5+0.5)*0.03;
    
    // Compute sky gradient
    vec3 baseColor = max(vec3(0), vec3(impulse(cx, 8.0),
                          0.5*sustain(cx, 32.0, 10.0) + 0.2*impulse(cx, 6.0),
                          sustain(cx, 10.0, 5.0))) * pow(sunBrightness, 0.7);
    
    // Get the halo around the sun and the gradient from bottom to top
    vec3 sunHalo = pow(dot(r, l)*0.5+0.5, 32.0) * smoothstep(-0.5, 1.0, r.y) * vec3(1.0, 0.8, 0.7) * baseColor * 4.0;
    sunHalo += exp(-abs(r.y) * sunBrightness * 2.0) * sunBrightness * baseColor*2.0;
    
    // Final color = base color + sun halo + sun disk + constant value so nights aren't completely black
    vec3 finalColor = baseColor * 3.0;
    finalColor += sunHalo * 3.0;
    finalColor += sunAndMoon(r, l, m, moonPhase);

    finalColor += vec3(0.05, 0.05, 0.1)*0.3;
    
    return finalColor;
}

bool compare(float a, float b, float e) {
    return abs(b - a) < e;
}

bool isBlockType(vec2 id, int type) {
    return compare(id.x, float(type), 0.5);
}