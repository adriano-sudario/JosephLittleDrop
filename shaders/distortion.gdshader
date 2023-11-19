shader_type spatial;

uniform float wave_weight = 0.05;
uniform vec3 albedo:source_color;
uniform vec2 speed = vec2(7.5, 7.5);

void vertex() {
	VERTEX.y += sin(TIME * speed.y + VERTEX.x * speed.x) * wave_weight;
}

void fragment() {
	ALBEDO = albedo;
}