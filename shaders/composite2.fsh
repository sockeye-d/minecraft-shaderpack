#version 120

#define GODRAY_RES 24.0 // [12.0 24.0 48.0 64.0]

#include "util/generic.inc"
#include "util/blur.inc"

uniform sampler2D gcolor;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform float near;
uniform float far;
uniform float wetness;
uniform float rainStrength;
uniform int worldTime;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

float linearize(float depth) {
    return (near * far) / (depth * (near - far) + far);
}

void main() {
    float sunValue = abs(mod(float(worldTime) - 6000.0, 24000.0) - 12000.0) / 12000.0;
	vec4 color = texture2D(gcolor, texcoord);
    float depth = texture2D(depthtex0, texcoord).r;
    vec4 sunPos = vec4(sunPosition(worldTime), 1);
    sunPos = gbufferModelView * sunPos;
    sunPos = gbufferProjection * sunPos;
    sunPos /= sunPos.w;
    vec2 sunProj = sunPos.xy * 0.5 + 0.5;
    vec2 fade = abs(2.0 * clamp(sunProj, vec2(0), vec2(1)) - 1.0);
    fade = 1.0 - fade;
    vec4 godrays = radialBlur(gcolor, texcoord, sunProj, GODRAY_RES) * 0.02 * fade.x * fade.y;

/* DRAWBUFFERS:0 */
    gl_FragData[0] = color + godrays; //gcolor
}
