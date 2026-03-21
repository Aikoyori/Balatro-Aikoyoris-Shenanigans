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
    
    vec2 color = vec2(step(0.5, fract(uv.x)),step(0.5, fract(uv.y)));
    number factor = 1.0;
    if (color.x != color.y){
        factor = 0.85;
    }

    tex.rgb = tex.rgb * (factor + 0.3*((sin(iTime * 2.0 + length(oguv) * 3.0) + 1.0)*0.5));
    
    // vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    return tex;
}