shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float whitening: hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	tex = mix(tex, vec4(1.0, 1.0, 1.0, tex.a), whitening);
	COLOR = tex * modulate;
}
