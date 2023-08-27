#version 120

#include "util/generic.inc"

uniform sampler2D texture;
uniform float wetness;
uniform int worldTime;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	LIGHTING

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
