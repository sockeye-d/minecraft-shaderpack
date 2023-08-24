#version 120

#include "util/generic.inc"
#include "util/water.inc"

uniform float frameTimeCounter;

uniform vec3 cameraPosition;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 vertexPos;

void main() {
	vec4 v = gl_Vertex + vec4(cameraPosition, 0);
	vec3 wave = waterHeight(v.xz * WAVE_SIZE, frameTimeCounter * WAVE_SPEED, 1.0) * WAVE_HEIGHT;
	v.y += wave.x - WAVE_HEIGHT;
	vertexPos = v.xyz;
	v -= vec4(cameraPosition, 0);
	
	normal = gl_Normal.xyz;
	gl_Position = gl_ModelViewProjectionMatrix * v;
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightmap = invMix(vec2(1.05 / 32.0), vec2(32.0 / 33.05), (gl_TextureMatrix[1] * gl_MultiTexCoord1).st);
	glcolor = gl_Color;
}