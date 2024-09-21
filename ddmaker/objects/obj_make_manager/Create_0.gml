/// @description Insert description here
// You can write your code in this editor
enum State {
	NONE,
	RAIL
}

enum Direct {
	RIGHT,
	UP,
	LEFT,
	DOWN,
	NONE
}

function make_obj() {
	var dir = Direct.NONE;
	if (mouse_previous_x > mouse_floor_x) {
		dir = Direct.LEFT;
	}
	else if (mouse_previous_x < mouse_floor_x) {
		dir = Direct.RIGHT;	
	}
	else if (mouse_previous_y > mouse_floor_y) {
		dir = Direct.UP;	
	}
	else if (mouse_previous_y < mouse_floor_y) {
		dir = Direct.DOWN;	
	}

	var _id = noone;
	switch (make_state) {
		case State.RAIL :
			//found obj
			with (obj_rail) {
				if (collision_point(other.mouse_previous_x, other.mouse_previous_y, obj_rail, false, false)) {
					_id = id;
					break;
				}
			}
			//obj exists;
			if (dir != Direct.NONE and _id != noone) {
				_id.way[dir] = Way.OPEN;
				show_debug_message(dir);
			}	
			break;
	
	}
}


make_state = State.NONE;
mouse_floor_x = 0;
mouse_floor_y = 0;

mouse_previous_x = 0;
mouse_previous_y = 0;