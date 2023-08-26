#version 120

#include "util/blur.inc"

uniform sampler2D gcolor;
uniform sampler2D colortex5;
uniform int worldTime;
uniform float aspectRatio;
uniform int frameCounter;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

void main() {
	vec4 color = vec4(0);
	vec2 uv = texcoord;
    float size = exp2(floor(log2(1.-uv.x)));

	/* DRAWBUFFERS:5 */
	if (texcoord.y < size)
		gl_FragData[0] = blur(colortex5, uv, BLOOM_PASS_1_SIZE * aspectRatio, BLOOM_PASS_1_RES, vec2(0, 1), float(frameCounter));
}
