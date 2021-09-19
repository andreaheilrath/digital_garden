// Author Andrea Heilrath

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform float strip;

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float slide = 0.;
    float strip = 28.0;
    float duration = 222.0;
    float zoom =  fract(u_time*0.5) * 2.0; //+ (pow(1.15,80.0*mod(u_time,duration)/duration)); //300000.0
    vec2 center = vec2(0.5-slide,0.5-slide); //0.3901885,0.6028052);
    st = st / zoom + (center - vec2(1.0/(2.0*zoom)));
    vec3 color = vec3(0.0);

    vec2 pos = vec2(0.5)-st;

    float r = length(pos)*2.0;
    float a = atan(pos.y,pos.x)*strip;

    float f = cos(a*8.);
    //f = abs(cos(a*3.));
    // f = abs(cos(a*2.5))*.5+.3;
    // f = abs(cos(a*12.)*sin(a*3.))*.8+.1;
    // f = smoothstep(-.5,1., cos(a*10.))*0.2+0.5;

    color = vec3(smoothstep(f,f-0.5,r*cos(a*4.0*fract(u_time))) );

    gl_FragColor = vec4(color, 1.0);
}
