#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif


extern MY_HIGHP_OR_MEDIUMP vec2 faded;
extern MY_HIGHP_OR_MEDIUMP vec4 uie_details;
extern MY_HIGHP_OR_MEDIUMP number uie_scale;
extern MY_HIGHP_OR_MEDIUMP number uie_rot;


mat2 rotationMatrix(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = colour;
    if (faded.g < 0.0001) {
        tex.r = tex.r + faded.g * 0.00001;
    }
    if (uie_details.x < 0.0001) {
        tex.r = tex.r + uie_details.x * 0.00001;
    }
    if (uie_scale < 0.0001) {
        tex.r = tex.r + uie_scale * 0.00001;
    }
    if (uie_rot < 0.0001) {
        tex.r = tex.r + uie_rot * 0.00001;
    }
    /*
    vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;

    uv.x = uv.x * (love_ScreenSize.x/love_ScreenSize.y);
    uv.y = uv.y / (20.);
    */
    
    // vec2 uv = (screen_coords - uibox_pos) / uibox_size.xy;
    tex.a = tex.a / 4.0;
    return tex;
}