shader_type canvas_item;

uniform float wave_weight = 3.0;
uniform float frequency = 15.0;
uniform float speed = 2.0;

void vertex() {
	VERTEX.y += wave_weight * sin((frequency * UV.x) + (speed * TIME));
}