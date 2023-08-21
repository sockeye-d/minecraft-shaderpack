#version 120

#include "util/lighting.glsl"

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform sampler2D normals;
uniform int worldTime;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color = applyLighting(color, texture2D(normals, texcoord), sunPosition(worldTime));

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}