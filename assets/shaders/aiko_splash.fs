#define BLACK 0.6*vec4(79./255.,99./255., 103./255., 1./0.6)
#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PREC highp
#else
	#define PREC mediump
#endif

#define PI 3.14159265358978

extern PREC number time;
extern PREC number vort_speed;
extern PREC vec4 colour_1;
extern PREC vec4 colour_2;
extern PREC number mid_flash;
extern PREC number vort_offset;


#define PIXEL_SIZE_FAC 640.
#define SPIN_EASE 0.5


mat2 rotationMatrix(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// https://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
// shadertoy fucking broke on me

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //Convert to UV coords (0-1) and floor for pixel effect
    /*
    PREC number pixel_size = length(love_ScreenSize.xy)/1000.0;
    PREC vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy) - vec2(0.12, 0.);
    PREC number uv_len = length(uv);
    */
    //Convert to 0-1.. coordinates but...
    vec4 tex = vec4(0.,0.,0.,1.);
    if (mid_flash < 0.0001) {
        tex.r = tex.r + mid_flash * 0.00001;
    }
    if (vort_offset < 0.0001) {
        tex.r = tex.r + vort_offset * 0.00001;
    }
    if (vort_speed < 0.0001) {
        tex.r = tex.r + vort_speed * 0.00001;
    }
    if (colour_1.r < 0.0001) {
        tex.r = tex.r + colour_1.r * 0.00001;
    }
    if (colour_2.r < 0.0001) {
        tex.r = tex.r + colour_2.r * 0.00001;
    }
    /*
    vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    uv.x = uv.x * (love_ScreenSize.x/love_ScreenSize.y);
    uv.y = uv.y / (20.);
    */
    float iTime = time / 15.0;
    PREC number aspect = love_ScreenSize.x/love_ScreenSize.y ;
    PREC vec2 uv = screen_coords / vec2(love_ScreenSize.x) ;
    
    PREC number pixel_size = length(love_ScreenSize.xy)/PIXEL_SIZE_FAC;
    uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    uv *= 15.1;
    vec2 uvc = (uv + vec2(0.5,0.5));
    uvc = uvc * rotationMatrix(-PI * 0.075 * iTime + 0.572);
    PREC number dist = distance(uvc, vec2(0.5,0.5));
    
    uvc = uvc * rotationMatrix(-PI * 0.075 * sin(pow(dist, 1.3)));
    vec2 color = vec2(step(0.5, fract(uvc.x)),step(0.5, fract(uvc.y)));
    float luminance = rgb2hsv(tex.rgb).b;
    number factor = 1.0;
    if (color.x != color.y){
        tex.rgb = vec3(1.,0.,1.) * 0.7;
        //factor = step(0.65,luminance)*0.8+0.4;
    }
    number dist_pow = pow((dist * 0.15), 2.4);
    tex.rgb *= vec3(1.,0.,1.) * (1. - dist_pow);
    tex.rgb += vec3(1.,0.,1.) * 0.3 * (1. - dist_pow);

    //tex.rgb = tex.rgb * (factor + 0.3*((sin(iTime * 2.0 + length(oguv) * 5.0) + 1.0)*0.5));
    
    // vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    return tex + vec4(colour.rgb * mid_flash, 1.);

}