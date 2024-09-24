/// @description Insert description here
// You can write your code in this editor
enum State {
	NONE,
	RAIL,
	WAY_CHANGER
}

enum Direct {
	RIGHT,
	UP,
	LEFT,
	DOWN,
	NONE
}

mouse_sprite = noone;
mouse_sprite_angle = 0;
current_valible_dir = Direct.RIGHT;
previous_rail_id = noone;

function make_obj() {
	//get direction
	current_dir = Direct.NONE;
	if (mouse_previous_x > mouse_floor_x) {
		current_dir = Direct.LEFT;
	}
	else if (mouse_previous_x < mouse_floor_x) {
		current_dir = Direct.RIGHT;	
	}
	else if (mouse_previous_y > mouse_floor_y) {
		current_dir = Direct.UP;	
	}
	else if (mouse_previous_y < mouse_floor_y) {
		current_dir = Direct.DOWN;	
	}
	if (current_dir != Direct.NONE) current_valible_dir = current_dir;
	var _current_obj_id = noone;
	//found obj
	with (obj_rail) {
		if (point_in_rectangle(other.mouse_floor_x, other.mouse_floor_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {
			_current_obj_id = id;
			break;
		}
	}
	//make obj
	switch (make_state) {
		case State.RAIL :
			//Create rail at current location
			if (_current_obj_id == noone) {
				_id =instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_rail);
				_id.set_one_way_direction(current_dir);
				//Reorient rail from previous location 
				if (previous_rail_id != noone) {
					previous_rail_id.change_output(current_dir);
				}
				previous_rail_id = _id;
			}
			else if (_current_obj_id != previous_rail_id and previous_rail_id != noone) {
				_current_obj_id.change_input((current_dir + 2) % 4);
				previous_rail_id.change_output(current_dir);
				previous_rail_id = noone;
			}
			break;
		case State.WAY_CHANGER :
			//obj exists;
			if (current_dir != Direct.NONE) {
				if (_current_obj_id != noone) {
					if (_id.way[current_dir] == Way.NONE) {
						_id.way[current_dir] = Way.OUTPUT;
						_id.cal_sprite_and_angle();
						return;
					}
				}
			}
			break;
	}
}


make_state = State.NONE;
//현재의 위치
mouse_floor_x = 0;
mouse_floor_y = 0;
//이전의 위치
mouse_previous_x = 0;
mouse_previous_y = 0;