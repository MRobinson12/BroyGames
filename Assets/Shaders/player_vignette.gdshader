shader_type canvas_item;
uniform vec2 player_position;
uniform vec4 color : source_color = vec4(0.305, 0.298, 0.341,1);
const float SCALE = 0.15;
uniform float camera_zoom = 1;

const float ASPECT_RATIO = 0.5625;
const float SOFTNESS = 0.6;


float vignette(vec2 dude){
	float val = distance(vec2(dude.x , dude.y * ASPECT_RATIO), vec2(player_position.x , player_position.y * ASPECT_RATIO));
	float zoom_scale = SCALE * camera_zoom;
	val = val / zoom_scale;
	float circle = smoothstep(0.2, SOFTNESS, val);
	return circle;
}

void fragment(){
	COLOR = vec4(color.rgb , vignette(UV));
	
}
