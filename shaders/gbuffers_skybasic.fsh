#version 120

#include "util/generic.inc"

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform int worldTime;
uniform int moonPhase;

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.


void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = inverse(gbufferModelView) * gbufferProjectionInverse * pos;
		color = skylight(normalize(pos.xyz), sunPosition(worldTime), moonPosition(worldTime), moonPhase);
	}

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}
