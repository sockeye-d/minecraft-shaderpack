attribute vec2 mc_Entity;
#version 120

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
	vec4 v = gl_Vertex + vec4(cameraPosition, 0);
	if(isBlockType(mc_Entity, 10)) {
		vec3 offset = wavingOffset(v.xyz, frameTimeCounter, 0.1);
		v.xyz += offset;
	}
	v.xyz -= cameraPosition;
	
	normal = gl_Normal.xyz;
	gl_Position = gl_ModelViewProjectionMatrix * v;
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightmap = invMix(vec2(1.05 / 32.0), vec2(32.0 / 33.05), (gl_TextureMatrix[1] * gl_MultiTexCoord1).st);
	glcolor = gl_Color;
	blockType = mc_Entity;
}