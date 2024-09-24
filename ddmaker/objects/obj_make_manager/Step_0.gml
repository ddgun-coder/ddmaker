/// @description Insert description here
// You can write your code in this editor
if (keyboard_check_pressed(ord("Q"))) {
	make_state = State.RAIL;
}
else if (keyboard_check_pressed(ord("S"))) {
	make_state = State.WAY_CHANGER;
}

if (make_state != State.NONE) {
	mouse_floor_x = floor((mouse_x + 16) / 32) * 32;
	mouse_floor_y = floor((mouse_y + 16) / 32) * 32;
}

if (mouse_check_button(mb_left)) {
	make_obj();
}
else {
	current_valible_dir = Direct.NONE;
	previous_rail_id = noone;
}

switch(make_state) {
	case State.RAIL : 
		mouse_sprite =  spr_one_way_rail_show;
		mouse_sprite_angle = current_valible_dir * 90;
		break;
	case State.WAY_CHANGER : 
		mouse_sprite =  spr_way_changer;
		break;
}