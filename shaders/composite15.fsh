#version 120

#include "util/color.inc"

/*
const int gcolorFormat = RGBA32F;
const bool gcolorMipmapEnabled = true;
*/
uniform sampler2D gcolor;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

void main() {
	vec3 color = textureLod(gcolor, texcoord, 0.0).rgb;

	float eyeAdjust = float(eyeBrightnessSmooth.r + eyeBrightnessSmooth.g*2.0);
	eyeAdjust += 1.0;
	eyeAdjust /= 240.0;
	eyeAdjust = max(0.01, eyeAdjust);

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(hillAcesTonemap(color / eyeAdjust), 1.0); //gcolor
}