shader_type spatial;

uniform float wave_weight = 0.075;
uniform vec3 albedo:source_color = vec3(0.62, 0.44, 1.0);
uniform vec2 speed = vec2(7.5, 7.5);

void vertex() {
	VERTEX.y += sin(TIME * speed.y + VERTEX.x * speed.x) * wave_weight;
}

void fragment() {
	ALBEDO = albedo;
}