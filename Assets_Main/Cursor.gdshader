shader_type spatial;
uniform sampler2D albedo : source_color, filter_nearest;
void vertex()
{
	UV = UV * vec2(3.0,2.0);
}
void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);

	//ALBEDO = (color_base * texture_color).rgb;
	ALPHA = (color_base * texture_color).a  * (sin(TIME*4.0)*0.8);
	EMISSION = vec3(0.5,0.5,0.5) * (sin(TIME*4.0)+1.0);
	//EMISSION = (color_base * texture_color).rgb;
}