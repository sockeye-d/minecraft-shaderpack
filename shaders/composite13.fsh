#version 120

#include "util/blur.inc"

uniform sampler2D gcolor;
uniform sampler2D colortex4;
uniform int worldTime;
uniform int frameCounter;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

void main() {
	vec4 color = vec4(0);
	vec2 uv = texcoord;
    float size = exp2(floor(log2(1.-uv.x)));
    
	uv = vec2(fract(uv.x/size), min(1.0, uv.y/size));

	/* DRAWBUFFERS:5 */
	if (texcoord.y < size)
		gl_FragData[0] = blur(colortex4, uv, BLOOM_PASS_1_SIZE / size, BLOOM_PASS_1_RES, vec2(1, 0), float(frameCounter));
}
