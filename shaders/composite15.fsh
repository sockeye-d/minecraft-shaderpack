#version 120

#include "util/color.inc"

/*
const int gcolorFormat = RGBA32F;
const bool gcolorMipmapEnabled = true;
*/

uniform sampler2D gcolor;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform int worldTime;

uniform ivec2 eyeBrightnessSmooth;

varying vec2 texcoord;

vec2 getTile(vec2 p, float tile)
{
    float tileWidth = 1.-exp2(-floor(tile));
    return vec2((p)/exp2(floor(tile))/2.+vec2(tileWidth, 0));
}

vec3 combineBloomTiles(vec2 uv, sampler2D tex) {
	vec3 c = vec3(0);
	float f = 1.0;
	for(float i = 0.0; i < 6.0; i++) {
		c += texture2D(tex, getTile(uv, i)).rgb * f;
		f *= 0.5;
	}
	return c;
}

void main() {
	vec3 color = texture2D(gcolor, texcoord).rgb;
	float sunValue = abs(mod(float(worldTime) - 6000.0, 24000.0) - 12000.0) / 12000.0;
	float eyeAdjust = float(eyeBrightnessSmooth.r * 0.25 + eyeBrightnessSmooth.g*mix(1.0, 2.0, sunValue));
	eyeAdjust += 1.0;
	eyeAdjust /= 240.0;
	eyeAdjust = max(0.01, eyeAdjust);

	vec3 bloom = combineBloomTiles(texcoord, colortex5) * 0.2 + texture2D(colortex4, texcoord).rgb * 0.2;
	bloom *= bloom;
	bloom /= eyeAdjust * eyeAdjust * eyeAdjust;

	color += bloom;

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(hillAcesTonemap(color / eyeAdjust), 1.0); //gcolor
	//gl_FragData[0] = texture2D(colortex5, texcoord);
}
