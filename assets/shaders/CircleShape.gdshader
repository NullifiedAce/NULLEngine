shader_type canvas_item;

uniform float radius : hint_range(0.0, 2.0) = 1.0; // Editable circle radius

void fragment() {
	vec2 uv = UV * 2.0 - 1.0; // Transform UV to range [-1, 1]
	float dist = length(uv);
	if (dist > radius) {
		discard; // Discard pixels outside the circle
	}
	COLOR = texture(TEXTURE, UV);
}
