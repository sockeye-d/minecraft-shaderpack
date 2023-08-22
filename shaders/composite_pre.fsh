#version 120

/*
const int colortex8Format = RGBA32F;
const bool colortex8MipmapEnabled = true;
*/
uniform sampler2D colortex8;
uniform int frameCounter;

varying vec2 texcoord;

void main() {
	vec3 color = texture2D(colortex8, texcoord).rgb;

    color = vec3(1);

/* RENDERTARGETS:8 */
	gl_FragData[0] = vec4(texture2D(myFramebuffer, texcoord)); //persistent data
}
