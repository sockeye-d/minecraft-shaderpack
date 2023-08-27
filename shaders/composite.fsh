#version 120

/*
const int gcolorFormat = RGBA32F;
const int colortex1Format = RGB16F;
const bool colortex1MipmapEnabled = true;
const bool gcolorMipmapEnabled = true;
const int colortex4Format = RGB16F;
const bool colortex4MipmapEnabled = true;
const int colortex5Format = RGB16F;
const bool colortex5MipmapEnabled = true;
*/

uniform sampler2D gcolor;

varying vec2 texcoord;

void main() {
	vec3 color = texture2D(gcolor, texcoord).rgb;

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}
