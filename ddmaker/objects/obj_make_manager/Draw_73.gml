/// @description Insert description here
// You can write your code in this editor
if (make_state != State.NONE and mouse_sprite != noone) {
	draw_sprite_ext(mouse_sprite, 0, mouse_floor_x, mouse_floor_y, 1, 1, mouse_sprite_angle, mouse_blend, 1);	
}


//place_grid 확인용
for (var i = 0; i < 35; i++) {
	//draw_line(i *32, 0, i * 32, 768);
	for (var j = 0; j < 20; j++) {
		draw_text(i * 32 + 32, j * 32 + 32, place_grid[# i, j]);	
	}
}