shader_type canvas_item;
uniform vec2 player_position;
uniform vec4 color : source_color = vec4(0.305, 0.298, 0.341,1);
uniform float camera_zoom = 1;
uniform vec2 lights[2];

const float ASPECT_RATIO = 0.5625;
const float SCALE = 0.15; //0.15
const float SOFTNESS = 0.6;


float player_vignette(vec2 screen){
	float val = distance(vec2(screen.x , screen.y * ASPECT_RATIO), vec2(player_position.x , player_position.y * ASPECT_RATIO));
	float zoom_scale = SCALE * camera_zoom;
	val = val / zoom_scale;
	float circle = smoothstep(0.2, SOFTNESS, val);
	return circle;
}

float other_vignette(vec2 screen, vec2 light_position, float scale){
	float val = distance(vec2(screen.x , screen.y * ASPECT_RATIO), vec2(light_position.x , light_position.y * ASPECT_RATIO));
	float zoom_scale = scale * camera_zoom;
	val = val / zoom_scale;
	float circle = smoothstep(0.2, SOFTNESS, val);
	return circle;
}

void fragment(){
	float lightest_val = player_vignette(UV);
	for (int i = 0; i < lights.length(); i++){
		float light_val = other_vignette(UV, lights[i], 0.05);
		if (light_val < lightest_val)
			lightest_val = light_val;
	}
	COLOR = vec4(color.rgb , lightest_val);
	
}
