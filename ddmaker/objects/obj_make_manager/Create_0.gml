/// @description Insert description here
// You can write your code in this editor
enum State {
	NONE,
	RAIL,
	WAY_CHANGER,
	WAY_MAGNIFIER,
	FACTORY
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
current_dir = Direct.NONE;
magnifier_time = 0;
magnifier_id = noone;
current_obj_id = noone;
facetory_placeable = false;
factory_index = global.furniture_factory;
mouse_blend = c_white;

function delete_obj() {
	switch (make_state) {
		case State.RAIL :
			if (current_obj_id != noone and current_obj_id.object_index == obj_rail) {
				current_obj_id.delete_obj_with_box();	
			}
			break;	
	}
}

function check_obj() {
	if (current_obj_id == noone) {
		magnifier_time = 0;
		return;
	}
	if (!instance_exists(obj_magnifier_ui)) instance_create_depth(0, 0, -500, obj_magnifier_ui);
	if (magnifier_id == current_obj_id) {
		magnifier_time++;	
	}
	else {
		magnifier_time = 0;
		magnifier_id = current_obj_id;
	}
	
	switch(current_obj_id.object_index) {
		case obj_rail :
			break;
	}
}

function make_obj() {
	//get direction
	current_dir = Direct.NONE;
	current_dir = cal_direction(mouse_previous_x, mouse_previous_y, mouse_floor_x, mouse_floor_y);
	if (current_dir != Direct.NONE) {
		current_valible_dir = current_dir;
	}
	//make obj
	switch (make_state) {
		case State.RAIL :
			//이미 존재하는 rail 기억하는 부분
			if (previous_rail_id == noone and current_obj_id != noone) {
				if (current_obj_id.object_index == obj_rail) {
					previous_rail_id = current_obj_id;	
				}
			}
			//변화가 없으면 return
			if (current_obj_id != noone) {
			    // current_dir이 NONE일 때
			    if (current_dir == Direct.NONE) {
			        if (current_obj_id.object_index == obj_rail && previous_rail_id != noone) {
			            start_same_shape = false;
			        }
			        return; // 더 이상 처리할 게 없으니 return
			    }

			    // current_dir이 NONE이 아닐 때
			    if (current_obj_id.object_index != obj_rail && previous_rail_id != noone) {
			        previous_rail_id.finalize_output(current_dir);
			    }
			}
			
			if (current_obj_id == noone) {
				//Create rail at current location
				var _id =instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_rail);
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
						previous_rail_id.is_completed = true;
					}
					else {
						previous_rail_id.finalize_output(current_dir);
					}
				}
				//이전의 레일을 기억
				previous_rail_id = _id;
			}
			else if (current_obj_id != previous_rail_id and previous_rail_id != noone) {
				//마지막 끝맺음을 완벽하게 만들기 위한 부분
				if (current_obj_id.object_index == obj_rail) {
					current_obj_id.add_input((current_dir + 2) % 4);
					if (previous_rail_id.is_completed) {
						previous_rail_id.add_output(current_dir);
					}
					else {
						previous_rail_id.change_output(current_dir);
						previous_rail_id.is_completed = true;
					}
					previous_rail_id = current_obj_id;
				}
			}
			break;
		case State.WAY_CHANGER :
			//obj exists;
			if (current_dir != Direct.NONE) {
				if (current_obj_id != noone) {
					
				}
			}
			break;
		case State.FACTORY :
			
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