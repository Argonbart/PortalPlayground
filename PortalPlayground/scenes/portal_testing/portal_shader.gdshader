shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D portal_tex : source_color;

void fragment() {
	vec4 col = texture(portal_tex, SCREEN_UV);
	ALBEDO = col.rgb;
	ALPHA = 1.0;
}