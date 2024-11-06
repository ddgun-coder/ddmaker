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

function set_make_type(_type) {
	if (make_state == _type) {
		make_state = State.NONE;
	}
	else {
		make_state = _type;
		switch(make_state) {
			case State.FACTORY :
				obj_factory_id = global.factory_array[0];
				break;
			case State.RAIL :
				rail_index = global.rail_array[0];
				break;
		}
	}
}

function set_place_grid(_id, val = 1, dir = 0) {
	var dx, dy, w, h;
	with (_id) {
		switch (image_angle) {
	        case 0: // 오른쪽(0도)
	            dx = floor((_id.x - 16) / 32);
	            dy = floor((_id.y - 16) / 32);
	            w = ceil(sprite_width / 32) - 1;
	            h = ceil(sprite_height / 32) - 1;
	            break;
        
	        case 270: // 아래쪽(90도)
	            dx = floor((_id.x - 16) / 32) - ceil(sprite_height / 32) + 1;
	            dy = floor((_id.y - 16) / 32);
	            w = ceil(sprite_height / 32) - 1;
	            h = ceil(sprite_width / 32) - 1;
	            break;
        
	        case 180: // 왼쪽(180도)
	            dx = floor((_id.x - 16) / 32) - ceil(sprite_width / 32) + 1;
	            dy = floor((_id.y - 16) / 32) - ceil(sprite_height / 32) + 1;
	            w = ceil(sprite_width / 32) - 1;
	            h = ceil(sprite_height / 32) - 1;
	            break;
        
	        case 90: // 위쪽(270도)
	            dx = floor((_id.x - 16) / 32);
	            dy = floor((_id.y - 16) / 32) - ceil(sprite_width / 32) + 1;
	            w = ceil(sprite_height / 32) - 1;
	            h = ceil(sprite_width / 32) - 1;
	            break;
        
	        default:
	            dx = floor((_id.x - 16) / 32);
	            dy = floor((_id.y - 16) / 32);
	            w = ceil(sprite_width / 32) - 1;
	            h = ceil(sprite_height / 32) - 1;
	            break;
	    }
	}
	ds_grid_set_region(place_grid, dx, dy, dx + w, dy + h, val);	
}

init_direction = Direct.RIGHT;
rail_array_index = 0;
place_grid = ds_grid_create(150, 150);
mouse_sprite = noone;
mouse_sprite_angle = 0;
current_valible_dir = Direct.RIGHT;
previous_rail_id = noone;
start_smae_shape = true;
current_dir = Direct.NONE;
magnifier_time = 0;
magnifier_id = noone;
current_obj_id = noone;
factory_placeable = false;
mouse_blend = c_white;
obj_factory_id = noone;
rail_index = noone;
alarm[0] = 1;
is_set = false;
place_able = false;
ui_dy = 200;
buil_ui_y_init = camera_get_view_height(view_camera[0]) + ui_dy - sprite_get_height(spr_make_ui) + sprite_get_yoffset(spr_make_ui);
buil_ui_y = buil_ui_y_init;
ani_cur = animcurve_get(ani_incre1);
ani_channel = ani_cur.channels[0];
curve = 0;
build_ui_id = noone;

function create_buil_ui() {
	if (instance_exists(obj_build_ui)) return;
	
	build_ui_id = instance_create_depth(255, buil_ui_y, depth, obj_build_ui);
}

function delete_buil_ui() {
	if (build_ui_id != noone) instance_destroy(build_ui_id);
}

function rail_end_action() {
	if (previous_rail_id != noone and previous_rail_id.output_number == 1) {
		var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
		if (_dir[0] != Direct.NONE and _dir[1] == Io.INPUT) {
			previous_rail_id.change_output(_dir[0]);
		}
		previous_rail_id.is_completed = true;
	}
	previous_rail_id = noone;
	start_smae_shape = true;
}

function delete_obj() {
	switch (make_state) {
		case State.RAIL :
			if (current_obj_id != noone and current_obj_id.object_index == obj_rail) {
				current_obj_id.delete_obj_with_box();	
			}
			break;	
		default :
			instance_destroy()
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
	current_dir = cal_direction(mouse_previous_x, mouse_previous_y, mouse_floor_x, mouse_floor_y);
	if (current_dir != Direct.NONE) {
		current_valible_dir = current_dir;
	}
	else {
		if (previous_rail_id == noone) { 
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
			if (_dir[0] != Direct.NONE and _dir[1] == Io.OUTPUT) {
				current_dir = _dir[0];
				start_smae_shape = false;
				current_valible_dir = current_dir;
			}
		}
		else {
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
			if (_dir[0] != Direct.NONE and _dir[1] == Io.INPUT) {
				current_dir = _dir[0];
				start_smae_shape = false;
				current_valible_dir = current_dir;
			}
		}
	}
	//make obj
	switch (make_state) {
		case State.RAIL :
			if (rail_index.obj == obj_rail) {
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
					set_place_grid(_id);
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
			}
			else {
				var _id = instance_create_depth(mouse_floor_x, mouse_floor_y, depth, rail_index.obj);
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
			if (factory_placeable) {
				var _id = instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_factory);
				_id.sprite_index = obj_factory_id.spr;
				_id.image_angle = mouse_sprite_angle mod 360;
				set_place_grid(_id, , mouse_sprite_angle);
				_id.init_factory(obj_factory_id);
			}
			break;
	}
}

mouse_grid_x = 0;
mouse_grid_y = 0;
make_state = State.NONE;
//현재의 위치
mouse_floor_x = 0;
mouse_floor_y = 0;
//이전의 위치
mouse_previous_x = 0;
mouse_previous_y = 0;

clicked_id = noone;