// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

float comlex_abs (float re, float im){
    return sqrt(re*re + im*im);
}

float mandelbrot(vec2 st){
    float re = st.x;
    float im = st.y;

    float z_re = 0.0;
    float z_im = 0.0;

    float y_re = 0.0;
    float y_im = 0.0;

    for(int i=0;i<100;i++){
    y_re = (z_re*z_re - z_im*z_im) + re;
    y_im = (2.0*z_re*z_im) + im;
    z_re = y_re;
    z_im = y_im;

    if (comlex_abs(z_re, z_im) > 10000.0){
        return(float(i)*0.008);
    }
}
    return comlex_abs(z_re, z_im);
}

void main() {
    float duration = 40.0;
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    float zoom = -1.0 + (pow(1.1,100.0*mod(u_time,duration)/duration)); //300000.0
    vec2 center =  vec2(-0.621516,0.4609075);//vec2(0.3901885,0.6028052);

    //scale(vec2(sin(u_time)+1.0));

    st = scale(vec2(1.0/zoom)) * st + (center - vec2(1.0/(2.0*zoom)));

    vec3 color = vec3(0.);
    float mandel_color = mandelbrot(st);
    color = vec3(mandelbrot(st));
    color = vec3(mandel_color, 0.2* mandel_color*mandel_color, 5.0 * mandel_color*mandel_color);

    gl_FragColor = vec4(color,1.0);
}
