#version 120

#include "util/generic.inc"
#include "util/color.inc"

uniform sampler2D gcolor;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform float near;
uniform float far;
uniform float wetness;
uniform float rainStrength;
uniform int worldTime;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
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
    vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
    pos = gbufferModelViewInverse * gbufferProjectionInverse * pos;
    pos.xyz = normalize(pos.xyz);
    vec3 fog = exp(-vec3(0.004, 0.006, 0.008) * (wetness * 2.0 + 0.75) * linearize(depth));

    color.rgb = mix(color.rgb, texture2D(colortex1, texcoord).rgb * (sunValue + 0.1) + vec3(0.05, 0.05, 0.07), 1.0-fog);

/* DRAWBUFFERS:0 */
    gl_FragData[0] = color; //gcolor
}
