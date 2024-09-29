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
start_smae_shape = true;

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
	if (current_dir != Direct.NONE) {
		current_valible_dir = current_dir;
	}
	var _current_obj_id = noone;
	//found obj
	with (obj_abs_component) {
		if (collision_point(other.mouse_floor_x, other.mouse_floor_y, id, false, false)) {
			_current_obj_id = id;
			break;
		}
	}
	
	//make obj
	switch (make_state) {
		case State.RAIL :
			//변화가 없으면 return
			if (_current_obj_id != noone and current_dir == Direct.NONE) {
				return;
			}
			
			if (_current_obj_id == noone) {
				//Create rail at current location
				_id =instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_rail);
				//Reorient rail from previous location 
				_id.set_one_way_direction(current_dir);
				//클릭해서 이어준 경우는 변경이 아닌 추가 형태
				if (clicked_id != noone and clicked_id.object_index == obj_rail) {
					clicked_id.add_output(current_dir);
					clicked_id = noone;
				}
				
				//꺾을때 마다 방향 변경
				if (previous_rail_id != noone) {
					if (start_smae_shape) {
						start_smae_shape = false;
						previous_rail_id.set_one_way_direction(current_dir);
					}
					else {
						if (previous_rail_id.is_completed) {
							previous_rail_id.add_output(current_dir);
						}
						else {
							previous_rail_id.change_output(current_dir);		
						}
					}
					previous_rail_id.is_completed = true;
				}
				//이전의 레일을 기억
				previous_rail_id = _id;
			}
			else if (_current_obj_id != previous_rail_id and previous_rail_id != noone) {
				//마지막 끝맺음을 완벽하게 만들기 위한 부분
				if (_current_obj_id.object_index == obj_rail) {
					_current_obj_id.add_input((current_dir + 2) % 4);
					previous_rail_id.change_output(current_dir);
					previous_rail_id.is_completed = true;
					previous_rail_id = _current_obj_id;
				}
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

clicked_id = noone;