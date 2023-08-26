#version 120

#include "util/blur.inc"

uniform sampler2D gcolor;
uniform sampler2D colortex4;
uniform float aspectRatio;
uniform int frameCounter;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

void main() {
	vec4 color = vec4(0);

	/* DRAWBUFFERS:4 */
	gl_FragData[0] = blur(colortex4, texcoord, BLOOM_PASS_0_SIZE * aspectRatio, BLOOM_PASS_0_RES, vec2(0, 1), float(frameCounter)); //gcolor
}
