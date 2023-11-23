shader_type canvas_item;

uniform float wave_weight = 3.0;
uniform float frequency = 15.0;
uniform float speed = 2.0;
uniform float time_scale : hint_range(0.25, 10.0, 0.25) = 5.0;

void vertex() {
//	float wave_1 = wave_weight * cos(time_scale * (-TIME * speed) + UV.x * TAU / 0.1 / 2.0) / 2.0;
//	float wave_2 = wave_weight * sin(time_scale * -TIME + UV.x * TAU / 0.1 / 2.0) / 2.0;
//	VERTEX.y += wave_1;
	VERTEX.y += wave_weight * sin((frequency * UV.x) + (speed * TIME));
}