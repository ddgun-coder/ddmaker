/// @description Insert description here
// You can write your code in this editor
if (make_state != State.NONE and mouse_sprite != noone) {
	draw_sprite_ext(mouse_sprite, 0, mouse_floor_x, mouse_floor_y, 1, 1, mouse_sprite_angle, mouse_blend, 1);	
	if (matched_underground_id != noone) {
		var _xy = get_direction_dxdy(init_direction, 32);
		for (var i = 1; i < matched_distance; i++) {
			draw_sprite_ext(spr_rail_line, 0, mouse_floor_x + _xy[0] * matched_sign * i, mouse_floor_y + _xy[1] * matched_sign * i, 1, 1, init_direction * 90, c_white, 1);
		}
	}
}


/*
//place_grid 확인용
for (var i = 0; i < 35; i++) {
	//draw_line(i *32, 0, i * 32, 768);
	for (var j = 0; j < 20; j++) {
		draw_text(i * 32 + 32, j * 32 + 32, place_grid[# i, j]);	
	}
}
*/