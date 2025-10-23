shader_type canvas_item;

uniform vec4 u_frame_bounds = vec4(0.0, 0.0, 1.0, 1.0);
uniform float ang = 0.0;
uniform float dist = 4.0;
uniform float str = 1.0;
uniform float thr = 0.1;
uniform float ang_offset = 0.0;

uniform sampler2D alt_mask;
uniform bool use_mask = false;
uniform float thr2 = 0.1;

uniform vec3 dropColor: source_color;

uniform float hue = 0.0;
uniform float saturation = 0.0;
uniform float brightness = 0.0;
uniform float contrast = 0.0;

uniform float AA_STAGES = 0.0;

const vec3 GRAYSCALE_VALUES = vec3(0.3098039215686275, 0.607843137254902, 0.0823529411764706);
const float E_CONST = 2.718281828459045;
const int MAX_AA = 8;

// ---- Color adjustment helpers ----
vec3 apply_hue_rotate(vec3 a_color, float a_hue) {
	float float_angle = radians(a_hue);
	mat3 m1 = mat3(
		vec3(0.213, 0.213, 0.213),
		vec3(0.715, 0.715, 0.715),
		vec3(0.072, 0.072, 0.072)
	);
	mat3 m2 = mat3(
		vec3(0.787, -0.213, -0.213),
		vec3(-0.715, 0.285, -0.715),
		vec3(-0.072, -0.072, 0.928)
	);
	mat3 m3 = mat3(
		vec3(-0.213, 0.143, -0.787),
		vec3(-0.715, 0.140, 0.715),
		vec3(0.928, -0.283, 0.072)
	);
	mat3 m = m1 + cos(float_angle) * m2 + sin(float_angle) * m3;
	return m * a_color;
}

vec3 apply_saturation(vec3 a_color, float value) {
	float v = value;
	if (v > 0.0) { v = v * 3.0; }
	v = (1.0 + (v / 100.0));
	vec3 grayscale = vec3(dot(a_color, GRAYSCALE_VALUES));
	return clamp(mix(grayscale, a_color, v), 0.0, 1.0);
}

vec3 apply_contrast(vec3 a_color, float value) {
	float v = (1.0 + (value / 100.0));
	if (v > 1.0) {
		v = (((0.00852259 * pow(E_CONST, 4.76454 * (v - 1.0))) * 1.01) - 0.0086078159) * 10.0;
		v += 1.0;
	}
	return clamp((a_color - 0.25) * v + 0.25, 0.0, 1.0);
}

vec3 apply_hsbc(vec3 color) {
	color = color + (brightness / 255.0);
	color = apply_hue_rotate(color, hue);
	color = apply_contrast(color, contrast);
	color = apply_saturation(color, saturation);
	return color;
}

vec2 hash22(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx + p3.yz) * p3.zy);
}

// intensity_pass: returns 0.0 or 1.0 depending on threshold tests (with optional mask)
float intensity_pass(vec2 frag_coord, float cur_threshold, bool use_mask_flag, sampler2D main_tex, sampler2D alt_tex) {
	vec4 col = texture(main_tex, frag_coord);

	float mask_intensity = 0.0;
	if (use_mask_flag) {
		vec4 m = texture(alt_tex, frag_coord);
		mask_intensity = mix(0.0, 1.0, m.b);
	}

	if (col.a == 0.0) {
		return 0.0;
	}

	float intensity = dot(col.rgb, GRAYSCALE_VALUES);
	if (mask_intensity > 0.0) {
		return (intensity > thr2) ? 1.0 : 0.0;
	} else {
		return (intensity > cur_threshold) ? 1.0 : 0.0;
	}
}

// antialias: jittered multi-sample of intensity_pass to smooth threshold edges
float antialias(vec2 frag_coord, float cur_threshold, bool use_mask_flag, sampler2D main_tex, sampler2D alt_tex) {
	if (AA_STAGES == 0.0) {
		return intensity_pass(frag_coord, cur_threshold, use_mask_flag, main_tex, alt_tex);
	}

	float aa_st = AA_STAGES;
	float AA_TOTAL_PASSES = aa_st * aa_st + 1.0;
	const float AA_JITTER = 0.5;

	float acc = intensity_pass(frag_coord, cur_threshold, use_mask_flag, main_tex, alt_tex);

	ivec2 ts = textureSize(main_tex, 0);
	vec2 inv_ts = vec2(1.0 / float(max(ts.x, 1)), 1.0 / float(max(ts.y, 1)));

	for (int i = 0; i < MAX_AA * MAX_AA; i++) {
		int x = i / MAX_AA;
		int y = i - (MAX_AA * x);
		if (float(x) >= AA_STAGES || float(y) >= AA_STAGES) {
			continue;
		}
		vec2 jitter = AA_JITTER * (2.0 * hash22(vec2(float(x), float(y))) - 1.0);
		vec2 offset = jitter * inv_ts;
		acc += intensity_pass(frag_coord + offset, cur_threshold, use_mask_flag, main_tex, alt_tex);
	}

	return acc / AA_TOTAL_PASSES;
}

// create_drop_shadow: compute rim/drop contribution
vec3 create_drop_shadow(vec3 col_in, float cur_threshold, bool use_mask_flag, sampler2D main_tex, sampler2D alt_tex, vec2 uv) {
	float intensity = antialias(uv, cur_threshold, use_mask_flag, main_tex, alt_tex);

	ivec2 ts = textureSize(main_tex, 0);
	vec2 image_ratio = vec2(1.0 / float(max(ts.x, 1)), 1.0 / float(max(ts.y, 1)));

	vec2 checked_pixel = vec2(
		uv.x + (dist * cos(ang + ang_offset) * image_ratio.x),
		uv.y - (dist * sin(ang + ang_offset) * image_ratio.y)
	);

	float drop_shadow_amount = 0.0;
	if (checked_pixel.x > u_frame_bounds.x && checked_pixel.y > u_frame_bounds.y &&
	    checked_pixel.x < u_frame_bounds.z && checked_pixel.y < u_frame_bounds.w) {
		vec4 sample_col = texture(main_tex, checked_pixel);
		drop_shadow_amount = sample_col.a;
	}

	col_in += dropColor * ((1.0 - (drop_shadow_amount * str)) * intensity);
	return col_in;
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);

	vec3 unpremultiplied = (col.a > 0.0) ? (col.rgb / col.a) : col.rgb;
	vec3 out_color = apply_hsbc(unpremultiplied);

	out_color = create_drop_shadow(out_color, thr, use_mask, TEXTURE, alt_mask, UV);

	COLOR = vec4(out_color * col.a, col.a);
}
