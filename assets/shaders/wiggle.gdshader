shader_type canvas_item;

// Effect types
const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

// Shader uniforms
uniform float uTime;
uniform int effectType;
uniform float uSpeed;
uniform float uFrequency;
uniform float uWaveAmplitude;

vec2 sineWave(vec2 pt, vec2 tex_size) {
	float x = 0.0;
	float y = 0.0;

	if (effectType == EFFECT_TYPE_DREAMY) {
		float w = 1.0 / tex_size.y;
		float h = 1.0 / tex_size.x;
		pt.x = floor(pt.x / h) * h;
		float offsetX = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
		pt.y += floor(offsetX / w) * w;
		pt.y = floor(pt.y / w) * w;
		float offsetY = sin(pt.y * (uFrequency / 2.0) + uTime * (uSpeed / 2.0)) * (uWaveAmplitude / 2.0);
		pt.x += floor(offsetY / h) * h;
	} else if (effectType == EFFECT_TYPE_WAVY) {
		float offsetY = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
		pt.y += offsetY;
	} else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL) {
		x = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	} else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL) {
		y = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	} else if (effectType == EFFECT_TYPE_FLAG) {
		y = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
		x = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;
	}
	return vec2(pt.x + x, pt.y + y);
}

void fragment() {
	vec2 uv = UV;
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	uv = sineWave(uv, tex_size);
	COLOR = texture(TEXTURE, uv);
}
