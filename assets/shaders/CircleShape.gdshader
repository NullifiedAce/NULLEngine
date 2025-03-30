shader_type canvas_item;

void fragment() {
	vec2 uv = UV * 2.0 - 1.0; // Transform UV to range [-1, 1]
	float dist = length(uv);
	if (dist > 1.0) {
		discard; // Discard pixels outside the circle
	}
	COLOR = texture(TEXTURE, UV);
}