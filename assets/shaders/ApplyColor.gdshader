shader_type canvas_item;

uniform float hue : hint_range(-360.0, 360.0) = 0.0;          // Hue from -360 to 360
uniform float saturation : hint_range(0.0, 100.0) = 100.0;    // Saturation from 0 to 100
uniform float brightness : hint_range(-100.0, 100.0) = 0.0;   // Brightness from -100 to 100
uniform float contrast : hint_range(-100.0, 100.0) = 0.0;     // Contrast from -100 to 100

vec3 rgb_to_hsv(vec3 color) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(color.bg, K.wz), vec4(color.gb, K.xy), step(color.b, color.g));
	vec4 q = mix(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 hsv) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(hsv.xxx + K.xyz) * 6.0 - K.www);
	return hsv.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Convert to HSV for hue and saturation adjustments
	vec3 hsv = rgb_to_hsv(color.rgb);
	hsv.x += hue / 360.0;  // Normalize hue to 0-1 range
	hsv.y = clamp(hsv.y * (saturation / 100.0), 0.0, 1.0);  // Adjust saturation (0-100 to 0-1)
	color.rgb = hsv_to_rgb(hsv);

	// Brightness adjustment (simplified)
	color.rgb += brightness / 100.0;  // Add brightness

	// Contrast adjustment
	// - Contrast from -100 to 100 is mapped to a multiplier where 0 = no change.
	// - Values below 0 compress the range, and values above 0 expand it.
	float contrast_factor = (1.0 + contrast / 100.0);
	color.rgb = (color.rgb - 1.0) * contrast_factor + 1.0;  // Center around 0.5 and scale by contrast factor

	// Output the final color
	COLOR = color;
}
