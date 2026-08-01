#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PREC highp
#else
	#define PREC mediump
#endif

#define PI 3.14159265358979323846

extern PREC number left;
extern PREC number total;
extern PREC vec4 texture_details;
extern PREC vec2 image_details;


mat2 rotationMatrix(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}
vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    PREC vec2 uv_centered = (uv-vec2(0.5, 0.5)) * 2.;
    // convert to polar coordinates

    PREC vec2 polarcoord = vec2(atan(uv_centered.y, uv_centered.x) + PI,distance(uv_centered, vec2(0.,0.)));
    
    tex *= vec4(1.,1.,1.,((1. - step(((left / total)) * PI * 2. ,2. * PI - polarcoord.x )))*0.7+0.2 );

    return tex * colour;
}