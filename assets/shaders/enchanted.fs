#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif


#define PI 3.14159265358979323846

extern MY_HIGHP_OR_MEDIUMP float time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;


number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

mat2 rotationMatrix(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float rand(float va){
    return fract(va*1000.4556);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel( texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 st = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a) / 1.5;

    // modify tex.rgb for output
    st *= rotationMatrix(PI*0.2);
    vec4 hslcol = HSL(tex);
    float time = (fract(time*0.001))*1700.;
    float time2 = (fract(time*0.0008))*700.;
    vec4 c = vec4(0.0);
    vec3 target = vec3(0.7,0.1,0.9);
    float val0 = (st.x*0.03-time);
    float val1 = fract(val0)+1.0;
    float x = mix(rand(floor(val0)),rand(floor(val0)+1.0),fract(val1))*2.0;
    st *= rotationMatrix(PI*0.35);
    val0 = (st.x*.04+time2);
    val1 = fract(val0)+1.0;
    float y = mix(rand(floor(val0)),rand(floor(val0)+1.0),fract(val1))*2.0;
    c.a *= x * 2.;
    c += vec4(0.4*x);
    c.a *= y * 2.;
    c += vec4(0.5*y);
    c.rgb *= 3.;

    float x2 = (pow(distance(vec2(0.5,0.5), uv) * 1.1,3.));
    vec3 x3 = ((smoothstep(0.8,0.9,hslcol.b)*0.1+0.3) * pow((1.- x2) * 1.70, 3.) * target);
    vec4 colout = tex+((c*vec4(target*(x2 * 0.3 + 0.2),0.0)*vec4(x3,1.)));
    //colout.rgb *= min(((x3)*3.), vec3(1.));
    colout.rgb -= vec3(x2);
    //colout.rgb += vec3(0.3);
    
    //colout.rgb *= 0.8;
    //colout.rgb += 0.05;
    return colout;
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0.,0.,0.,scale);
}
#endif