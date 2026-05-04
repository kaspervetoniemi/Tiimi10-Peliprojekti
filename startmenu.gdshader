shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.01, 0.01, 0.06, 1.0);
uniform vec4 star_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float speed = 0.03;
uniform float density = 60.0;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
	vec3 col = bg_color.rgb;
	float stars = 0.0;

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
			float twinkle = 0.6 + 0.4 * sin(TIME * (2.0 + rand(cell + vec2(10.0, 20.0)) * 4.0) + r * 10.0);
			stars += smoothstep(size, 0.0, d) * twinkle;
		}
	}

	col += star_color.rgb * clamp(stars, 0.0, 1.0);
	COLOR = vec4(col, 1.0);
}