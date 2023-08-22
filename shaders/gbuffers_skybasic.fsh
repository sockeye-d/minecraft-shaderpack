#version 120

#include "util/generic.inc"

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform int worldTime;

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.

vec3 skylight(vec3 r, vec3 l, vec3 m)
{
    // Utility macros
    #define impulse(x, k) k*x*exp(1.0 - k*x)
    #define sustain(x, k, p) pow(1.0 - exp(-k*x), p)
    #define SUN_SIZE 0.0025
    
    // Get the "time"
    float sunBrightness = smoothstep(-0.3, 1.0, l.y);
    
    // Get the gradient value
    float cx = (max(0.0, r.y) + 0.3) * sunBrightness * 0.9;
    // Distort gradient value by how far away it is from the sun
    // replicating the Earth's shadow
    cx -= acos(dot(r, l)*0.5+0.5)*0.03;
    
    // Compute sky gradient
    vec3 baseColor = max(vec3(0), vec3(impulse(cx, 8.0),
                          0.5*sustain(cx, 32.0, 10.0) + 0.2*impulse(cx, 6.0),
                          sustain(cx, 10.0, 5.0))) * pow(sunBrightness, 0.7);
    
    // Get the halo around the sun and the gradient from bottom to top
    vec3 sunHalo = pow(dot(r, l)*0.5+0.5, 32.0) * smoothstep(-0.5, 1.0, r.y) * vec3(1.0, 0.8, 0.7) * baseColor * 4.0;
    sunHalo += exp(-abs(r.y) * sunBrightness * 2.0) * sunBrightness * baseColor*2.0;
    
    vec3 sunDisk = smoothstep(1.0 - SUN_SIZE, 1.0, max(0.0, dot(r, l)))*vec3(1.0,0.55,0.1) * 100.0 * smoothstep(-0.02, 1.0, r.y);
    vec3 moonDisk = smoothstep(1.0 - SUN_SIZE * 0.5, 1.0 - SUN_SIZE * 0.3, max(0.0, dot(r, m)))*vec3(0.85, 0.9, 1.0) * 1.0;
    
    // Final color = base color + sun halo + sun disk + constant value so nights aren't completely black
    vec3 finalColor = baseColor;
    finalColor += sunHalo;
    finalColor += sunDisk;
    finalColor += moonDisk;
    finalColor += vec3(0.05, 0.05, 0.1)*0.3;
    
    return finalColor;
}

void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = inverse(gbufferModelView) * gbufferProjectionInverse * pos;
		color = skylight(normalize(pos.xyz), sunPosition(worldTime), moonPosition(worldTime));
	}

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}