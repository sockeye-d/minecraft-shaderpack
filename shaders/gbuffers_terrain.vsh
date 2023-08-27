#version 120
attribute vec2 mc_Entity;

#include "util/generic.inc"
#include "util/waving.inc"

uniform float frameTimeCounter;
uniform vec3 cameraPosition;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec2 blockType;

void main() {
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	vec4 v = gl_Vertex + vec4(cameraPosition, 0);
	vec3 offset = wavingOffset(v.xyz * vec3(1, 0.1, 1), frameTimeCounter, 0.2);
	if(isBlockType(mc_Entity, 10)) {
		v.xyz += offset;
	}

	if(isBlockType(mc_Entity, 11)) {
		v.xyz += offset * (1.0-fract(texcoord.y * 128.0));
	}

	v.xyz -= cameraPosition;
	
	normal = gl_Normal.xyz;
	gl_Position = gl_ModelViewProjectionMatrix * v;
	lightmap = invMix(vec2(1.05 / 32.0), vec2(32.0 / 33.05), (gl_TextureMatrix[1] * gl_MultiTexCoord1).st);
	glcolor = gl_Color;
	blockType = mc_Entity;
}
