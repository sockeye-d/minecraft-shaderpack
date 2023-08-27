float luminance(vec3 col) {
    return dot(col, vec3(0.2126, 0.7152, 0.0722));
}

vec3 saturation(vec3 col, float sat) {
    return mix(vec3(luminance(col)), col, sat);
}

vec3 hillAces(vec3 col) {
    col = max(vec3(0), col) * mat3(
    vec3(0.59719, 0.35458, 0.04823),
    vec3(0.07600, 0.90834, 0.01566),
    vec3(0.02840, 0.13383, 0.83777));
    
    vec3 a = col * (col + 0.0245786) - 0.000090537;
    vec3 b = col * (0.983729 * col + 0.4329510) + 0.238081;
    col = a/b;
    
    return clamp(col * mat3(
    vec3( 1.60475, -0.53108, -0.07367),
    vec3(-0.10208,  1.10813, -0.00605),
    vec3(-0.00327, -0.07276,  1.07602)), vec3(0), vec3(1));
}

vec3 narkowiczACES(vec3 col) {
    return (col * (2.51 * col + 0.03)) / (col * (2.43 * col + 0.59) + 0.14);
}

vec3 reinhard(vec3 col) {
    return col / (col + 0.5);
}

vec3 tonemap(vec3 col) { return reinhard(col); }
