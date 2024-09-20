/// @description Insert description here
// You can write your code in this editor
if (keyboard_check_pressed(ord("Q"))) {
	make_state = State.RAIL;
}

if (make_state != State.NONE) {
	mouse_floor_x = floor(mouse_x / 32) * 32;
	mouse_floor_y = floor(mouse_y / 32) * 32;
}