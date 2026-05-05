shader_type canvas_item;

uniform vec4 bg_color_top : source_color = vec4(0.01, 0.01, 0.07, 1.0);
uniform vec4 bg_color_bottom : source_color = vec4(0.01, 0.02, 0.05, 1.0);

uniform vec4 star_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 blue_star_color : source_color = vec4(0.55, 0.78, 1.0, 1.0);

// Vihertävä sumu
uniform vec4 green_glow_color : source_color = vec4(0.18, 0.55, 0.30, 1.0);
uniform vec4 green_glow_color_2 : source_color = vec4(0.05, 0.22, 0.14, 1.0);

uniform float speed = 0.03;
uniform float density = 60.0;
uniform float glow_strength = 0.22;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x)
		+ (c - a) * u.y * (1.0 - u.x)
		+ (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
	float value = 0.0;
	float amp = 0.5;

	for (int i = 0; i < 4; i++) {
		value += noise(p) * amp;
		p *= 2.0;
		amp *= 0.5;
	}

	return value;
}

void fragment() {
	vec2 uv = UV;

	// Tumma tausta
	vec3 col = mix(bg_color_top.rgb, bg_color_bottom.rgb, uv.y);

	// Vihertävä sumu
	vec2 nebula_uv = uv * 2.2;
	nebula_uv += vec2(TIME * 0.010, TIME * 0.005);

	float n1 = fbm(nebula_uv);
	float n2 = fbm(nebula_uv * 1.7 + vec2(4.2, 2.7));
	float n3 = fbm(nebula_uv * 0.9 - vec2(TIME * 0.004, TIME * 0.006));

	float nebula = n1 * 0.5 + n2 * 0.3 + n3 * 0.2;
	nebula = smoothstep(0.42, 0.82, nebula);

	vec3 nebula_color = mix(
		green_glow_color.rgb,
		green_glow_color_2.rgb,
		uv.x
	);

	col += nebula_color * nebula * glow_strength;

	// Vilkkuvat tähdet
	float stars = 0.0;
	float blue_stars = 0.0;

	for (int i = 1; i <= 3; i++) {
		float fi = float(i);

		vec2 grid_uv = uv * density * fi;
		grid_uv.y += TIME * speed * fi * 20.0;

		vec2 cell = floor(grid_uv);
		vec2 local = fract(grid_uv) - vec2(0.5);

		float r = rand(cell + vec2(fi, fi * 2.0));

		if (r > 0.985 - fi * 0.003) {
			float size = mix(0.03, 0.12, rand(cell + vec2(fi * 3.0, fi * 4.0)));
			float d = length(local);

			float twinkle = 0.6 + 0.4 * sin(
				TIME * (2.0 + rand(cell + vec2(10.0, 20.0)) * 4.0) + r * 10.0
			);

			float star = smoothstep(size, 0.0, d) * twinkle;

			if (rand(cell + vec2(99.0, 12.0)) > 0.78) {
				blue_stars += star;
			} else {
				stars += star;
			}
		}
	}

	col += star_color.rgb * clamp(stars, 0.0, 1.0);
	col += blue_star_color.rgb * clamp(blue_stars, 0.0, 1.0);

	COLOR = vec4(col, 1.0);
}