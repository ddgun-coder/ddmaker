/// @description Insert description here
// You can write your code in this editor
underground_distance = 6;
matched_underground_id = noone;
matched_distance = 0;
matched_sign = 0; 
current_io = Io.BOTH;
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

function found_matched_rail() {
	current_io = rail_index.io;
	if (current_io == Io.INPUT) {
		matched_sign = 1;
	}
	else if (current_io == Io.OUTPUT) {
		matched_sign = -1;
	}
	else {
		matched_sign = 0;
		return;
	}
	var _rail_id = noone;
	var _xy = get_direction_dxdy(init_direction, 32);
	for (var i = 1; i < underground_distance; i++) {
		_rail_id = collision_point(mouse_floor_x + _xy[0] * i * matched_sign, mouse_floor_y + _xy[1] * i * matched_sign, [obj_rail_input, obj_rail_output], false, false)
		if (_rail_id != noone and _rail_id.connected_rail_id == noone and current_io != _rail_id.io and floor(_rail_id.image_angle / 90) == init_direction) {
			matched_underground_id = _rail_id;
			matched_distance = i;
			return;
		}
	}
	matched_underground_id = noone;
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

function get_factory_placeable2(_obj_factory_id, _dir) {
	var _result = get_place_grid_origin(_obj_factory_id.width, obj_factory_id.height, mouse_grid_x, mouse_grid_y, obj_factory_id.origin_index[0], obj_factory_id.origin_index[1], _dir);
	return ds_grid_get_sum(place_grid, _result[0], _result[1], _result[0] + _result[2] - 1, _result[1] + _result[3] - 1) == 0;
}

function get_factory_placeable(_obj_factory_id, _dir) {
	var dx, dy, w, h;
	switch (_dir) {
	    case 0: // 오른쪽(0도)
	        dx = mouse_grid_x;
	        dy = mouse_grid_y;
	        w = _obj_factory_id.width;
	        h = _obj_factory_id.height;
	        break;
        
	    case 270: // 아래쪽(90도)
	        dx = mouse_grid_x - _obj_factory_id.height + 1;
	        dy = mouse_grid_y;
	        w = _obj_factory_id.height;
	        h = _obj_factory_id.width;
	        break;
        
	    case 180: // 왼쪽(180도)
	        dx = mouse_grid_x - _obj_factory_id.width + 1;
	        dy = mouse_grid_y - _obj_factory_id.height + 1;
	        w = _obj_factory_id.width;
	        h = _obj_factory_id.height;
	        break;
        
	    case 90: // 위쪽(270도)
	        dx = mouse_grid_x;
	        dy = mouse_grid_y - _obj_factory_id.width + 1;
	        w = _obj_factory_id.height;
	        h = _obj_factory_id.width;
	        break;
        
	    default:
	        dx = mouse_grid_x;
	        dy = mouse_grid_y;
	        w = _obj_factory_id.width;
	        h = _obj_factory_id.height;
	        break;
	}
	return ds_grid_get_sum(place_grid, dx, dy, dx + w - 1, dy + h - 1) == 0;
}

function get_spined_array_index(_x, _y, _angle, _array_width, _array_height) {
	var _result;
	switch (_angle) {
		case 0:	
			_result[0] = _x;
			_result[1] = _y;
			break;
		case 90:
			_result[0] = _y;
			_result[1] = _array_width - _x - 1;
			break;
		case 180:	
			_result[0] = _array_width - _x - 1;
			_result[1] = _array_height - _y - 1;
			break;
		case 270:	
			_result[0] = _array_height - _y - 1; 
			_result[1] = _x;
			break;
		default :
			_result = [-1, -1];
			break;
	}
	return _result;
}



function get_place_grid_origin(_width, _height, _x, _y, _origin_x, _origin_y, _dir) {
	var dx, dy, w, h;
	switch(_dir) {
		case 0:
		case 180:
			w = _width;
	        h = _height;
			break;
		case 90:
		case 270:
			w = _height;
	        h = _width;
			break;
	}
	var spined_origin = get_spined_array_index(_origin_x, _origin_y, _dir, _width, _height);
	dx = _x + _origin_x - spined_origin[0];
	dy = _y + _origin_y - spined_origin[1];
	return [dx, dy, w, h];
}

function get_place_grid_normal(_width, _height, _x, _y, _dir) {
	var dx, dy, w, h;
	switch (_dir) {
		  case 0: // 오른쪽(0도)
	            dx = _x;
	            dy = _y;
	            w = _width;
	            h = _height;
	            break;
			case 90 :
				dx = _x;
	            dy = _y - _width + 1;
	            w = _height;
	            h = _width;
	            break;
			case 180:
				dx = _x - _width + 1;
	            dy = _y - _height + 1;
	            w = _width;
	            h = _height;
				break;
			case 270:
				dx = _x - _height + 1;
	            dy = _y;
	            w = _height;
	            h = _width;
				break;
	}
	return [dx, dy, w, h];
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
        
	        case 270:
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
        
	        case 90: 
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
start_same_shape = true;
is_first_rail = true;
current_dir = Direct.NONE;
magnifier_time = 0;
magnifier_id = noone;
current_obj_id = noone;
factory_placeable = false;
mouse_blend = c_white;
obj_factory_id = noone;
rail_index = global.rail_array[0];
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
	start_same_shape = true;
	is_first_rail = true;
}

function delete_obj() {
	if (!instance_exists(current_obj_id)) return;
	switch (current_obj_id.object_index) {
		case obj_rail :
			current_obj_id.delete_obj_with_box();	
			break;	
		default :
			instance_destroy(current_obj_id)
			break;
	}
}

function check_obj() {
	if (!instance_exists(current_obj_id)) {
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

function rotateRailToMouse() {
	current_dir = cal_direction(mouse_previous_x, mouse_previous_y, mouse_floor_x, mouse_floor_y);
	if (current_dir != Direct.NONE) {
		current_valible_dir = current_dir;
	}
	else {
		if (!instance_exists(previous_rail_id)) { 
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
			if (_dir[0] != Direct.NONE and _dir[1] == Io.OUTPUT) {
				current_dir = _dir[0];
				start_same_shape = false;
				current_valible_dir = current_dir;
			}
		}
		else {
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
			if (_dir[0] != Direct.NONE and _dir[1] == Io.INPUT) {
				current_dir = _dir[0];
				start_same_shape = false;
				current_valible_dir = current_dir;
			}
		}
	}
}

function make_obj() {
	//get direction
	if (rail_index.obj == obj_rail and make_state == State.RAIL) {
		rotateRailToMouse();
	}
	//make obj
	switch (make_state) {
		case State.RAIL :
			if (rail_index.obj == obj_rail) {
				//변화가 없으면 return
				if (current_obj_id != noone and current_dir == Direct.NONE) {
					return;
				}
				//이미 존재하는 rail 기억하는 부분
				if (previous_rail_id == noone and current_obj_id != noone) {
					if (current_obj_id.object_index == obj_rail) {
						previous_rail_id = current_obj_id;	
					}
				}
				//변화가 없으면 return
				if (instance_exists(current_obj_id)) {
				    // current_dir이 NONE일 때
				    if (current_dir == Direct.NONE) {
				        if (current_obj_id.object_index == obj_rail and instance_exists(previous_rail_id)) {
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
					if (is_first_rail) {
						is_first_rail = false;
						current_dir = current_valible_dir
					}
					//Create rail at current location
					var _id =instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_rail);
					set_place_grid(_id);
					//Reorient rail from previous location 
					_id.set_one_way_direction(current_dir);
					//클릭해서 이어준 경우는 변경이 아닌 추가 형태
					if (instance_exists(clicked_id) and clicked_id.object_index == obj_rail) {
						clicked_id.add_output(current_dir);
						clicked_id = noone;
					}
				
					//꺾을때 마다 방향 변경
					if (instance_exists(previous_rail_id)) {
						if (start_same_shape) {
							start_same_shape = false;
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
				if (!instance_exists(current_obj_id)) {			
					var _id = instance_create_depth(mouse_floor_x, mouse_floor_y, depth, rail_index.obj);
					_id.image_angle = mouse_sprite_angle mod 360;
					if (instance_exists(matched_underground_id)) {
						matched_underground_id.connected_rail_id = _id;
						matched_underground_id.connected_distance = matched_distance;
						_id.connected_rail_id = matched_underground_id;
						_id.connected_distance = matched_distance;
					}
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