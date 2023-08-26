#version 120

#include "util/generic.inc"
#include "util/water.inc"

uniform sampler2D texture;
uniform sampler2D normals;

uniform int worldTime;
uniform int moonPhase;
uniform float aspectRatio;
uniform float viewWidth;
uniform float viewHeight;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec3 vertexPos;

float fresnel(vec3 n, vec3 rd) {
    return max(0.0, pow(1.0-dot(reflect(rd.xyz, n), n), 5.0));
}

void main() {
	vec3 wave = waterHeight(vertexPos.xz * WAVE_SIZE, frameTimeCounter * WAVE_SPEED, 4.0) * WAVE_HEIGHT * 0.2;
	vec3 waveVec = normalFromGrad(wave.yz);
	vec3 n = (tbn(normalize(normal)) * waveVec).xzy;

	vec4 viewDir = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
	viewDir = (gbufferModelViewInverse * gbufferProjectionInverse * viewDir);

	vec4 color = vec4(vec3(0.2, 0.5, 1.0)*0.8, 0.5);

	color = applyLighting(color, n, lightmap, sunPosition(worldTime), moonPosition(worldTime));
	vec3 reflected = reflect(normalize(viewDir.xyz), n);
	vec3 sky = skylight(reflected, sunPosition(worldTime), moonPosition(worldTime), moonPhase) * vec3(0.5, 0.8, 1);

	float fr = fresnel(normal, viewDir.xyz);
	color.rgb += sky * fr;
	color.a = 1.0-(1.0-fresnel(normal, viewDir.xyz))*(1.0 - color.a);

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
