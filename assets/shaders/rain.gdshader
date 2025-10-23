shader_type canvas_item;

// Uniforms
uniform float uScale;
uniform float uIntensity;
uniform float uTime;
uniform float uPuddleY;
uniform float uPuddleScaleY;
uniform sampler2D uBlurredScreen;
uniform sampler2D uMask;
uniform vec3 uRainColor;
uniform sampler2D screen_texture : hint_screen_texture;

// Random function
float rand(vec2 a) {
	return fract(sin(dot(a, vec2(12.9898, 78.233))) * 43758.5453);
}

// Rain distortion function
float rainDist(vec2 p, float scale, float intensity) {
	p *= 0.05; // Adjusted for smaller raindrops
	p.x += p.y * 0.1;
	p.y -= uTime * 500.0 / scale;
	p.y *= 0.03;
	float ix = floor(p.x);
	p.y += mod(ix, 2.0) * 0.5 + (rand(vec2(ix)) - 0.5) * 0.3;
	float iy = floor(p.y);
	vec2 index = vec2(ix, iy);
	p -= index;
	p.x += (rand(index.yx) * 2.0 - 1.0) * 0.35;
	vec2 a = abs(p - 0.5);
	float res = max(a.x * 0.8, a.y * 0.5) - 0.1;
	bool empty = rand(index) < mix(1.0, 0.1, intensity);
	return empty ? 1.0 : res;
}

// Main fragment function
void fragment() {
	vec2 uv = SCREEN_UV; // Use screen coordinates
	vec4 scene_color = texture(screen_texture, uv); // Sample the game screen

	vec3 add = vec3(0.0);
	float rainSum = 0.0;

	const int numLayers = 4;
	float scales[4] = float[](1.0, 1.8, 2.6, 4.8);

	for (int i = 0; i < numLayers; i++) {
		float scale = scales[i];
		// Scale the raindrop size by uScale
		float r = rainDist(uv * scale * (uScale * 100.0) + 500.0 * float(i), scale, uIntensity);
		if (r < 0.0) {
			float v = (1.0 - exp(r * 5.0)) / scale * 2.0;
			// Adjust the distortion to account for smaller raindrops
			uv.x += v * 10.0 / (uScale * 100.0);
			uv.y -= v * 2.0 / (uScale * 100.0);
			add += vec3(0.1, 0.15, 0.2) * v;
			rainSum += (1.0 - rainSum) * 0.75;
		}
	}

	vec4 final_color = texture(screen_texture, uv); // Sample screen again with distortion
	final_color.rgb += add; // Apply rain effect
	final_color.rgb = mix(final_color.rgb, uRainColor, 0.1 * rainSum);

	COLOR = final_color; // Output final blended color
}
