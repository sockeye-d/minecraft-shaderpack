#version 120

#include "util/blur.inc"

/*
const int gcolorFormat = RGBA32F;
const bool gcolorMipmapEnabled = true;
const int colortex4Format = RGBA32F;
const bool colortex4MipmapEnabled = true;
const int colortex5Format = RGBA32F;
const bool colortex5MipmapEnabled = true;
*/

uniform sampler2D gcolor;
uniform int worldTime;
uniform int frameCounter;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

void main() {
	vec4 color = vec4(0);

	/* DRAWBUFFERS:4 */
	gl_FragData[0] = blur(gcolor, texcoord, BLOOM_PASS_0_SIZE, BLOOM_PASS_0_RES, vec2(1, 0), float(frameCounter)); //gcolor
}
