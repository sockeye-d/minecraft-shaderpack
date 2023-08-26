float hash13(vec3 p3) {
	p3 = fract(p3 * .1031);
    p3 += dot(p3, p3.zyx + 31.32);
    return fract((p3.x + p3.y) * p3.z);
}

vec3 hash33(vec3 p3)
{
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy + p3.yxx)*p3.zyx);

}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 w = fract(x);

    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);

    float a = hash13( p+vec3(0,0,0) );
    float b = hash13( p+vec3(1,0,0) );
    float c = hash13( p+vec3(0,1,0) );
    float d = hash13( p+vec3(1,1,0) );
    float e = hash13( p+vec3(0,0,1) );
    float f = hash13( p+vec3(1,0,1) );
    float g = hash13( p+vec3(0,1,1) );
    float h = hash13( p+vec3(1,1,1) );

    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;

    return (k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z);
}

float fbm(vec3 p, float octaves) {
    float r = 0.0;
    for(float i = 0.0; i < octaves; i++) {
        r += noise(p * exp(i)) * exp(-i);
    }
    return r;
}

vec4 noised( in vec3 x )
{
    vec3 p = floor(x);
    vec3 w = fract(x);

    // vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    // vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);

    vec3 u = 3.0*w*w - 2.0*w*w*w;
    vec3 du = 6.0*w*(1.0-w);

    float a = hash13( p+vec3(0,0,0) );
    float b = hash13( p+vec3(1,0,0) );
    float c = hash13( p+vec3(0,1,0) );
    float d = hash13( p+vec3(1,1,0) );
    float e = hash13( p+vec3(0,0,1) );
    float f = hash13( p+vec3(1,0,1) );
    float g = hash13( p+vec3(0,1,1) );
    float h = hash13( p+vec3(1,1,1) );

    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;

    return vec4( -1.0+2.0*(k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z),
        2.0* du * vec3( k1 + k4*u.y + k6*u.z + k7*u.y*u.z,
            k2 + k5*u.z + k4*u.x + k7*u.z*u.x,
            k3 + k6*u.x + k5*u.y + k7*u.x*u.y ) );
}
