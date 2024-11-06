/// @description Insert description here
// You can write your code in this editor
if (!is_set) exit;

var _pre_make_state = make_state;
if (keyboard_check_pressed(ord("Q"))) {
	set_make_type(State.RAIL);
}
else if (keyboard_check_pressed(ord("S"))) {
	set_make_type(State.WAY_CHANGER);
}
else if (keyboard_check_pressed(ord("C"))) {
	set_make_type(State.WAY_MAGNIFIER);
}
else if (keyboard_check_pressed(ord("F"))) {
	set_make_type(State.FACTORY);
}
else if (keyboard_check_pressed(ord("R"))) {
	init_direction = init_direction + 1 mod 4;
	current_valible_dir = init_direction; 
}

if (_pre_make_state != make_state) {
	if (_pre_make_state == State.RAIL) {
		rail_end_action();
	}
}

if (make_state != State.NONE) {
	create_buil_ui();
	if (curve < 1) curve += 1 / 60;
	buil_ui_y = buil_ui_y_init - animcurve_channel_evaluate(ani_channel, curve) * ui_dy ;
	mouse_floor_x = floor((mouse_x + 16) / 32) * 32;
	mouse_floor_y = floor((mouse_y + 16) / 32) * 32;
	mouse_grid_x = floor(mouse_floor_x / 32) - 1;
	mouse_grid_y = floor(mouse_floor_y / 32) - 1;
	//found obj
	current_obj_id = collision_point(mouse_floor_x, mouse_floor_y, obj_abs_component, false, false)
	switch(make_state) {
		case State.RAIL :
			if (previous_rail_id == noone) {
				var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
				if (_dir[0] != Direct.NONE and _dir[1] == Io.OUTPUT) {
					current_valible_dir = _dir[0];
				}
				else {
					current_valible_dir = init_direction;
				}
			}
			break;
		case State.FACTORY :
			factory_placeable = ds_grid_get_sum(place_grid, mouse_grid_x, mouse_grid_y, mouse_grid_x + obj_factory_id.width - 1, mouse_grid_y + obj_factory_id.height - 1) == 0;
			break;
		case State.WAY_MAGNIFIER :
			check_obj();
			break;
	}		
}
else {
	if (curve > 0) curve -= 1 / 40;
	buil_ui_y = buil_ui_y_init - animcurve_channel_evaluate(ani_channel, curve) * ui_dy ;
}
//각 make_satet에 따른 step 부분

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
var mouse_on_ui = build_ui_id == noone or position_meeting(mouse_x, mouse_y, build_ui_id);
if (mouse_check_button(mb_left)) {
	if (!mouse_on_ui) {
		make_obj();
	}
}
else if (mouse_check_button_released(mb_left)) {
	if (make_state == State.RAIL) {
		rail_end_action();	
		current_valible_dir = init_direction; 
	}
}

if (mouse_check_button(mb_right)) {
	delete_obj();	
}

mouse_blend = c_white;
mouse_sprite_angle = 0;
image_angle = 0;
if (mouse_on_ui) {
	mouse_sprite = noone;
}
else {
	switch(make_state) {
		case State.RAIL : 
			mouse_sprite =  rail_index.show_spr;
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
			mouse_sprite = obj_factory_id.spr;
			mouse_sprite_angle = current_valible_dir * 90;
			break;
	
	}
}