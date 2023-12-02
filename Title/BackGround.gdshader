shader_type canvas_item;
uniform vec2 mouse = vec2(0.0,0.0);

void fragment() {
	vec2 distortedUV = UV;
	distortedUV.x += distortedUV.y * -0.1;
	distortedUV.y += distortedUV.x * 0.1;
	vec4 pixelColor = texture( TEXTURE, distortedUV * 1.0 - vec2( 0.1, 0.05 ) * TIME + mouse);
	COLOR = pixelColor;
}
