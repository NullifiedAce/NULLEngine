shader_type canvas_item;

uniform float hue : hint_range(-360, 360);         // Allow negative hue
uniform float saturation : hint_range(-100, 100);  // Allow negative saturation
uniform float brightness : hint_range(-255, 255);  // Allow negative brightness
uniform float contrast : hint_range(-255, 255);    // Allow negative contrast
uniform float alpha : hint_range(0, 255) = 255;          // Controls transparency

vec3 apply_hue(vec3 color, float hue_angle) {
	float angle = radians(hue_angle);
	vec3 k = vec3(0.57735, 0.57735, 0.57735); // Equal weights for each channel
	float cos_angle = cos(angle);
	return color * cos_angle + cross(k, color) * sin(angle) + k * dot(k, color) * (1.0 - cos_angle);
}

vec3 apply_hsb_effect(vec3 color) {
	// Apply brightness adjustment
	color = clamp(color + (brightness / 255.0), 0.0, 1.0);

	// Apply hue adjustment
	color = apply_hue(color, hue);

	// Apply contrast adjustment
	color = clamp((color - 0.5) * (1.0 + (contrast / 255.0)) + 0.5, 0.0, 1.0);

	// Apply saturation adjustment
	vec3 intensity = vec3(dot(color, vec3(0.30980392156, 0.60784313725, 0.08235294117)));
	color = clamp(mix(intensity, color, (1.0 + (saturation / 100.0))), 0.0, 1.0);

	return color;
}

void fragment() {
	// Get the current fragment color (input color)
	vec4 input_color = COLOR;

	// Apply HSB and contrast adjustments
	vec3 out_color = apply_hsb_effect(input_color.rgb);

	// Compute final alpha
	float final_alpha = input_color.a * (alpha / 255.0);

	// Output the modified color and final alpha
	COLOR = vec4(out_color * final_alpha, final_alpha);
}
