shader_type canvas_item;


void fragment() {
	if (length(UV - vec2(0.5)) < 0.48) {
		COLOR = COLOR;
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}