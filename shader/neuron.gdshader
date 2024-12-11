shader_type canvas_item;

uniform vec2 mouse_position = vec2(0.5, 0.5);
uniform vec4 wave_color: source_color = vec4(1.0, 2.0, 4.0, 1.0);
uniform float wave_transparency: hint_range(0.0, 1.0) = 1.0;
//uniform float edge_thickness = 0.02; // 가장자리 효과 범위 조정

mat2 rotate2D(float r) {
    // 2D 회전 행렬
    return mat2(vec2(cos(r), sin(r)), vec2(-sin(r), cos(r)));
}

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

void fragment() {
    // 텍스처 좌표
    //vec2 uv = (FRAGCOORD.xy / TEXTURE_PIXEL_SIZE.y) * 0.001;	
	vec2 uv =UV;
    // 초기 색상
    vec3 col = vec3(0.0);
    // 시간
    float t = TIME;
    // 노이즈 계산을 위한 변수
    vec2 n = vec2(0.0), q;
    vec2 N = vec2(0.0);
    // 초기 위치
    vec2 p = uv + sin(t * 0.1 / 10.0);
    // 초기 스케일
    float S = 10.0;
    // 회전 행렬
    mat2 m = rotate2D(1.0 - (mouse_position.x * 0.001));
    
    // 노이즈 생성 루프
    for (float j = 0.0; j < 30.0; j++) {
        // 위치와 노멀 벡터 회전
        p *= m;
        n *= m;
        // 노이즈 값 계산
        q = p * S + j + n + t;
        n += sin(q);
        N += cos(q) / S;
        // 스케일 증가
        S *= 1.2;
    }

    // 0으로 나누는 것을 방지
    float lengthN = max(length(N), 0.001);
    // 최종 색상 계산
    col = wave_color.rgb * pow((N.x + N.y + 0.4) + 0.005 / lengthN, 2.1);

    // 밝기 값을 계산하여 어두운 부분을 투명하게 만듦
    float brightness = length(col); // 색상의 밝기 계산
    float alpha = wave_transparency * smoothstep(0.1, 0.3, brightness); // 밝기에 따른 알파 값 조정
    // 화면 가장자리 부분에서만 효과가 나타나도록 설정
	float edge_thickness = fbm(vec2(uv.x,uv.y) + TIME * 0.5) * 0.15 - 0.015;
    float edge_effect = smoothstep(edge_thickness, 0.0, min(min(uv.x, 1. - uv.x), min(uv.y, 1. - uv.y)));
	
    // 알파 값에 가장자리 효과를 곱하여 사이드에서만 이펙트가 나타나게 함
    COLOR = vec4(col, alpha * edge_effect * 0.5);
}
