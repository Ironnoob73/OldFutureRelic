shader_type spatial;
uniform sampler2D albedo : source_color, filter_nearest;
void vertex()
{
	UV = UV * vec2(2.0,1.0);
}
void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);

	ALBEDO = (color_base * texture_color).rgb;
}