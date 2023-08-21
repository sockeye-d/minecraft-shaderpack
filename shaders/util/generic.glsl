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
