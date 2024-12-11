shader_type spatial;

void fragment() {
	vec4 color = vec4(0.2, 1.0, 0.0, 0.4); 
    ALBEDO = color.rgb; // 표면 색상 (초록색)
    ALPHA = color.a;    // 투명도 (0.5 = 반투명)
}