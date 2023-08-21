#include "generic.glsl"

vec4 applyLighting(vec4 color, vec3 normal, vec2 lightmap, vec3 light) {
    return color * max(0.0, dot(normal, light));
}