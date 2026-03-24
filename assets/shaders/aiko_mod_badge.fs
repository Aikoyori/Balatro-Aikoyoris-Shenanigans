#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define PI 3.14159265358979323846

extern MY_HIGHP_OR_MEDIUMP vec2 aiko_mod_badge;
extern MY_HIGHP_OR_MEDIUMP vec2 uibox_pos;
extern MY_HIGHP_OR_MEDIUMP vec2 uibox_size;
extern MY_HIGHP_OR_MEDIUMP number iTime;


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
    vec4 tex = colour;
    if (aiko_mod_badge.g < 0.0001) {
        tex.r = tex.r + aiko_mod_badge.g * 0.00001;
    }
    if (uibox_pos.x < 0.0001) {
        tex.r = tex.r + uibox_pos.x * 0.00001;
    }
    if (uibox_size.x < 0.0001) {
        tex.r = tex.r + uibox_size.x * 0.00001;
    }
    if (iTime < 0.0001) {
        tex.r = tex.r + iTime * 0.00001;
    }
    /*
    vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    uv.x = uv.x * (love_ScreenSize.x/love_ScreenSize.y);
    uv.y = uv.y / (20.);
    */
    vec2 oguv = screen_coords / vec2(love_ScreenSize.x/love_ScreenSize.y) * 0.05;
    vec2 uv = screen_coords / vec2(love_ScreenSize.x/love_ScreenSize.y) * 0.00140;
    uv = uv * rotationMatrix(PI * 0.15);
    uv *= 20.1;
    uv += vec2 (iTime / 3.0, iTime / 3.0);
    uv.y+=sin(iTime*5.0+uv.x*5.0)*0.05;
    
    vec2 color = vec2(step(0.5, fract(uv.x)),step(0.5, fract(uv.y)));
    float luminance = rgb2hsv(tex.rgb).b;
    number factor = 1.0;
    if (color.x != color.y){
        tex.rgb = vec3(0.71,0.51,0.81);
        factor = step(0.65,luminance)*0.8+0.4;
    }

    tex.rgb = tex.rgb * (factor + 0.3*((sin(iTime * 2.0 + length(oguv) * 5.0) + 1.0)*0.5));
    
    // vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    return tex;
}