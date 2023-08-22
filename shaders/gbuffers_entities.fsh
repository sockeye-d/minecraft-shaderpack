#version 120

#include "util/generic.inc"

uniform sampler2D texture;
uniform vec4 entityColor;
uniform int worldTime;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
	color = applyLighting(color, normal, lightmap, sunPosition(worldTime), moonPosition(worldTime));

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
