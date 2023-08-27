#version 120

#include "util/generic.inc"
#include "util/color.inc"

uniform sampler2D texture;
uniform float wetness;
uniform int worldTime;

varying vec2 lightmap;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 normal;
varying vec2 blockType;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	if (isBlockType(blockType, 1)) {
		color.rgb *= color.rgb * color.rgb * color.rgb * color.rgb * color.rgb;
		color.rgb *= 5.0;
	}

	if (isBlockType(blockType, 2)) {
		color.rgb *= color.rgb * color.rgb;
		color.rgb *= 10.0;
	}

	if (isBlockType(blockType, 3)) {
		color.rgb = saturation(color.rgb, 0.5);
		color.rgb *= color.rgb * color.rgb * color.rgb * color.rgb * color.rgb;
		color.rgb *= 100.0;
	}

	if (isBlockType(blockType, 4)) {
		color.rgb = color.rgb + pow(color.rgb, vec3(20)) * 25.0;
	}

	if (isBlockType(blockType, 5)) {
		color.rgb = color.rgb + pow(color.rgb, vec3(20)) * 50.0;
	}

	if (isBlockType(blockType, 6)) {
		color.rgb = color.rgb + pow(color.rgb, vec3(10)) * 1000.0;
	}
	
	LIGHTING

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
