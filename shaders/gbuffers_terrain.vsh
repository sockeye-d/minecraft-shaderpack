#version 120

#include "util/generic.inc"

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;

void main() {
	normal = gl_Normal;
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightmap = invMix(vec2(1.05 / 32.0), vec2(32.0 / 33.05), (gl_TextureMatrix[1] * gl_MultiTexCoord1).st);
	glcolor = gl_Color;
}