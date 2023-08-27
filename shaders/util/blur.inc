#define BLOOM_PASS_0_SIZE 0.005
#define BLOOM_PASS_0_RES 4.0
#define BLOOM_PASS_1_SIZE 0.02
#define BLOOM_PASS_1_RES 16.0

vec2 hash21(float p) {
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

float hash12(vec2 p) {
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float gaussian(float x) {
    return exp(-8.0*x*x);
}

vec4 blur(sampler2D tex, vec2 uv, float size, float res, vec2 direction, float time) {
    vec4 r = vec4(0);
    float tw = 0.0;
    float st = 1.0 / res;

    for(float x = -0.5; x < 0.5; x += st) {
        vec2 uv2 = uv + direction * x * size;
        float w = gaussian(x);
        tw += w;
        r += max(vec4(0), textureLod(tex, uv2, 0.0) * w);
    }

    return r / tw;
}

vec4 radialBlur(sampler2D tex, vec2 uv, vec2 center, float res) {
    vec4 r = vec4(0);
    float tw = 0.0;
    float st = 1.0 / res;

    for(float x = 0.0; x < 1.0; x += st) {
        r += max(vec4(0), textureLod(tex, (uv - center) * x + center, 3.0));
    }

    return r * st;
}