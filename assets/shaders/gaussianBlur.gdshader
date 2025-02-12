shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0);
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 resolution = vec2(textureSize(screen_texture, 0));
	vec4 color = vec4(0.0);

	vec2 offsets[5] = vec2[](vec2(0.0, 0.0), vec2(1.3846153846, 0.0), vec2(-1.3846153846, 0.0), vec2(3.2307692308, 0.0), vec2(-3.2307692308, 0.0));
	float weights[5] = float[](0.2270270270, 0.3162162162, 0.3162162162, 0.0702702703, 0.0702702703);

	for (int i = 0; i < 5; i++) {
		color += texture(screen_texture, uv + (offsets[i] * blur_amount / resolution)) * weights[i];
	}

	COLOR = vec4(color.rgb, 1.0); // Ensure the ColorRect remains visible while applying the effect
}
