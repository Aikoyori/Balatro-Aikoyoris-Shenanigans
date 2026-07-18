#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PREC highp
#else
	#define PREC mediump
#endif

#define PI 3.14159265358978

extern PREC number time;
extern PREC number spin_time;
extern PREC vec4 colour_1;
extern PREC vec4 colour_2;
extern PREC vec4 colour_3;
extern PREC number contrast;
extern PREC number spin_amount;


#define PIXEL_SIZE_FAC 480.
#define SPIN_EASE 0.5


vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //Convert to UV coords (0-1) and floor for pixel effect
    /*
    PREC number pixel_size = length(love_ScreenSize.xy)/1000.0;
    PREC vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy) - vec2(0.12, 0.);
    PREC number uv_len = length(uv);
    */
    //Convert to 0-1.. coordinates but...
    PREC number aspect = love_ScreenSize.x/love_ScreenSize.y ;
    PREC vec2 uv = screen_coords / vec2(love_ScreenSize.x) ;
    
    PREC number pixel_size = length(love_ScreenSize.xy)/PIXEL_SIZE_FAC;
    uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    PREC vec2 uv_centered = uv - vec2(0.0, -0.6 );

    PREC number uv_len = length(uv) * 20.;

    // convert to polar coordinates

    PREC vec2 polarcoord = vec2(atan(uv_centered.y / uv_centered.x),distance(uv_centered, vec2(0.,0.)));

    PREC number spumamnt = 0.085 * 20.*(1.*spin_amount*uv_len + (1. - 1.*spin_amount));

    PREC number emit = sin ( time * 0.13 ) * PI * 2.0;

    PREC number colour1_angles = floor ( mod ( ( (  polarcoord.x + (spin_time + ( spumamnt * 0.50) ) * 0.01 + (emit) * 0.15) / (PI / 06.) + time * 0.023  ) , 2.0 ) ) ;
    PREC number colour2_angles = floor ( mod ( ( (  polarcoord.x + (spin_time + ( spumamnt * 1.50) ) * 0.07 + (time) * 0.30) / (PI / 04.) + time * 0.041  ) , 2.0 ) ) ;
    PREC number colour3_angles = floor ( mod ( ( (  polarcoord.x + (spin_time + (-spumamnt * 2.75) ) * 0.04 + (emit) * 0.07) / (PI / 22.) + emit * 0.069  ) , 2.0 ) ) ;

    PREC vec4 ret_col = vec4(0.0,0.0,0.0,1.);

    ret_col += colour1_angles * contrast * colour_1 * 0.3;
    ret_col += colour2_angles * contrast * colour_2 * 0.4;
    ret_col += colour3_angles * contrast * colour_3 * 0.3;
    

    return ret_col;
}