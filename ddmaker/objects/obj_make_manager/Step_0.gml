/// @description Insert description here
// You can write your code in this editor
if (keyboard_check_pressed(ord("Q"))) {
	make_state = State.RAIL;
}
else if (keyboard_check_pressed(ord("S"))) {
	make_state = State.WAY_CHANGER;
}
else if (keyboard_check_pressed(ord("C"))) {
	make_state = State.WAY_MAGNIFIER;
}

if (make_state != State.NONE) {
	mouse_floor_x = floor((mouse_x + 16) / 32) * 32;
	mouse_floor_y = floor((mouse_y + 16) / 32) * 32;
	//found obj
	current_obj_id = collision_point(mouse_floor_x, mouse_floor_y, obj_abs_component, false, false);
}
if (make_state == State.WAY_MAGNIFIER) {
	check_obj();
}

if (mouse_check_button_pressed(mb_left)) {
	clicked_id = noone;
	with (obj_abs_component) {
		if (collision_point(other.mouse_floor_x, other.mouse_floor_y, id, false, false)) {
			other.clicked_id = id;
			break;
		}
	}
	if (clicked_id != noone) {
		start_smae_shape = false;	
	}
}

if (mouse_check_button(mb_left)) {
	make_obj();
}
else {
	current_valible_dir = Direct.NONE;
	if (previous_rail_id != noone) {
		previous_rail_id.is_completed = true;	
	}
	previous_rail_id = noone;
	start_smae_shape = true;
}

switch(make_state) {
	case State.RAIL : 
		mouse_sprite =  spr_one_way_rail_show;
		mouse_sprite_angle = current_valible_dir * 90;
		break;
	case State.WAY_CHANGER : 
		mouse_sprite =  spr_way_changer;
		break;
	case State.WAY_MAGNIFIER : 
		mouse_sprite =  spr_way_magnifier;
		break;
}