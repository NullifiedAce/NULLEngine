shader_type canvas_item;

// Uniforms
uniform float uTime : hint_range(0.0, 10000.0);
uniform float uSpeed : hint_range(0.0, 10.0) = 1.0;
uniform float uFrequency : hint_range(0.0, 50.0) = 10.0;
uniform float uWaveAmplitude : hint_range(0.0, 1.0) = 0.05;

// Effect type enum equivalent
// 0 = DREAMY
// 1 = WAVY
// 2 = HEAT_WAVE_HORIZONTAL
// 3 = HEAT_WAVE_VERTICAL
// 4 = FLAG
uniform int effectType = 0;

// Helper function for wavy offsets
vec2 get_wiggle_offset(vec2 uv, float time) {
	float offset_x = 0.0;
	float offset_y = 0.0;

	if (effectType == 0) {
		// DREAMY
		offset_x = sin((uv.y * uFrequency) + time * uSpeed) * uWaveAmplitude;
		offset_y = cos((uv.x * uFrequency) + time * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == 1) {
		// WAVY
		offset_y = sin((uv.x * uFrequency) + time * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == 2) {
		// HEAT_WAVE_HORIZONTAL
		offset_x = sin((uv.y * uFrequency * 2.0) + time * uSpeed) * (uWaveAmplitude * 0.5);
	}
	else if (effectType == 3) {
		// HEAT_WAVE_VERTICAL
		offset_y = sin((uv.x * uFrequency * 2.0) + time * uSpeed) * (uWaveAmplitude * 0.5);
	}
	else if (effectType == 4) {
		// FLAG
		offset_y = sin((uv.x * uFrequency) + time * uSpeed) * (uWaveAmplitude * 1.5);
		offset_x = cos((uv.y * uFrequency * 0.5) + time * uSpeed) * (uWaveAmplitude * 0.5);
	}

	return vec2(offset_x, offset_y);
}

// Safe texture sampling (prevents edge clipping)
vec4 safe_texture(sampler2D tex, vec2 uv) {
	// Clamp to avoid sampling outside [0,1]
	// This keeps the last pixel row/column instead of fading to transparent
	uv = clamp(uv, 0.001, 0.999);
	return texture(tex, uv);
}

void fragment() {
	vec2 uv = UV;
	vec2 offset = get_wiggle_offset(uv, uTime);
	COLOR = safe_texture(TEXTURE, uv + offset);
}
