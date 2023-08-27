#version 120

#include "util/generic.inc"

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform int worldTime;
uniform int moonPhase;

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.


void main() {
	vec3 color;
	vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
	pos = gbufferModelViewInverse * gbufferProjectionInverse * pos;
	pos.xyz = normalize(pos.xyz);
	vec3 sp = sunPosition(worldTime);
	vec3 mp = moonPosition(worldTime);
	vec3 baseSky = sky(pos.xyz, sp);
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		color = baseSky + sunAndMoon(pos.xyz, sp, mp, moonPhase);
	}

/* RENDERTARGETS:0,1 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
	gl_FragData[1] = vec4(baseSky, 1.0); //colortex1
}
