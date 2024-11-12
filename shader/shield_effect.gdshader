shader_type canvas_item;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float amplitude = 0.5;
    float frequency = 3.0;
	float value = 0.0;
	
    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

uniform vec4 smoke_color = vec4(0.5, 0.8, 1.0, 1.0); // 하늘색 연기 색상
uniform float spread_speed = 1.0; // 연기 확산 속도
uniform float intensity = 0.8; // 연기 강도
uniform float border_thickness = 0.3; // 테두리 두께

void fragment() {
	vec4 color = vec4(0.2,0.0,0.0,0.0);
	//vec2 uv = SCREEN_UV;
	vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    float dist_left = uv.x;
    float dist_right = 1.0 - uv.x;
    float dist_top = uv.y;
    float dist_bottom = 1.0 - uv.y;
	
	vec2 point = vec2(0.5, 0.5);
	if (distance(point, uv) < 0.1) {
		color = vec4(1.0,0.0,0.0,1.0);
	}

	//float min_dist = min(min(dist_left, dist_right), min(dist_top, dist_bottom));
    //vec4 color = smoke_color;
    //color.a *= uv.x - 0.5;
    //COLOR = color;
	COLOR = color;
}