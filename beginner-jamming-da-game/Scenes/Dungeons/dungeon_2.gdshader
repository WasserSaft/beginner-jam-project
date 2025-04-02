shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	c.rgb = 1.0 - c.rgb;
	c.rgb *= 0.3; //darkens the image
	COLOR = c;
}