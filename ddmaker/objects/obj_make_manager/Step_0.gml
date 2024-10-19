/// @description Insert description here
// You can write your code in this editor

if (!is_set) exit;
if (keyboard_check_pressed(ord("Q"))) {
	make_state = State.RAIL;
}
else if (keyboard_check_pressed(ord("S"))) {
	make_state = State.WAY_CHANGER;
}
else if (keyboard_check_pressed(ord("C"))) {
	make_state = State.WAY_MAGNIFIER;
}
else if (keyboard_check_pressed(ord("F"))) {
	make_state = State.FACTORY;
	obj_factory_id = global.furniture_factory;
}

if (make_state != State.NONE) {
	mouse_floor_x = floor((mouse_x + 16) / 32) * 32;
	mouse_floor_y = floor((mouse_y + 16) / 32) * 32;
	mouse_grid_x = floor(mouse_floor_x / 32) - 1;
	mouse_grid_y = floor(mouse_floor_y / 32) - 1;
	//found obj
	current_obj_id = collision_point(mouse_floor_x, mouse_floor_y, obj_abs_component, false, false)
	switch(make_state) {
		case State.FACTORY :
			factory_placeable = ds_grid_get_sum(place_grid, mouse_grid_x, mouse_grid_y, mouse_grid_x + obj_factory_id.width - 1, mouse_grid_y + obj_factory_id.height - 1) == 0;
			break;
		case State.WAY_MAGNIFIER :
			check_obj();
			break;
	}		
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

if (mouse_check_button(mb_right)) {
	delete_obj();	
}
mouse_blend = c_white;
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
	case State.FACTORY :
		if(!factory_placeable) mouse_blend =  c_red;
		mouse_sprite = factory_index.spr;
		break;
}