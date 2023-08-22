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

vec3 ticksToSunPos(int ticks, float sunPathRotation) {
    float t = (float(ticks) / 24000.0) * TAU;
    return rot(AXIS_X, AXIS_Z, t);
}

vec3 sunPosition(int ticks) {
    return ticksToSunPos(ticks, 0.0);
}

vec3 moonPosition(int ticks) {
    return ticksToSunPos(ticks + 12000, 0.0);
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

    vec3 sun = vec3(max(0.0, dot(normal, sunPos))*0.5+0.5);
    sun = mix(vec3(0), sun, smoothstep(-0.3, 1.0, sunPos.y));
    sun *= mix(vec3(1.0, 0.5, 0.0), vec3(1), max(0.0, sunPos.y));
    sun *= lightmap.g;
    l += sun;

    float moon = max(0.0, dot(normal, moonPos))*0.5+0.5;
    moon = mix(0.0, moon, smoothstep(-0.3, 1.0, moonPos.y));
    moon *= lightmap.g;
    moon *= 0.5;
    l += moon;

    l += lightmap.r * vec3(1.0, 0.8, 0.4);

    c *= l;
    
    return vec4(c, color.a);
}

vec4 applyLightmap(vec4 color, vec2 lightmap, vec3 sunPos, vec3 moonPos) {
    vec3 c = color.rgb;
    vec3 l = vec3(0);

    lightmap = modifyLightmap(lightmap);

    l += lightmap.g * smoothstep(-0.3, 1.0, sunPos.y);

    l += lightmap.r * vec3(1.0, 0.8, 0.4);

    c *= l;

    return vec4(c, color.a);
}