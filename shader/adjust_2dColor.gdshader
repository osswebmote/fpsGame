shader_type canvas_item;
uniform vec3 col = vec3(0.2, 0.2, 0.2);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv =UV;
	float edge_effect = smoothstep(0.03, 0.0, min(min(uv.x, 1. - uv.x), min(uv.y, 1. - uv.y)));
	COLOR = vec4(col, edge_effect * 0.5);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
