/// @description Insert description here
// You can write your code in this editor
underground_distance = 6;
matched_underground_id = noone;
matched_distance = 0;
matched_sign = 0; 
current_io = Io.BOTH;
previous_maked_rail_id = noone;
current_maked_rail_id = noone;
temp_rail_ids = [];
camera_movement_speed = 8;
camera_size_scale = 1;
camera_size_limit = floor(min(room_width / global.camera_width, room_height / global.camera_height));
generator_id = noone;
enum State {
	NONE,
	RAIL,
	WAY_CHANGER,
	WAY_MAGNIFIER,
	FACTORY,
	GENERATOR
}

enum Direct {
	RIGHT,
	UP,
	LEFT,
	DOWN,
	NONE
}

function control_camera() {	
	//set camera sizeq
	var cw = camera_get_view_width(view_camera[0]);
	var ch = camera_get_view_height(view_camera[0]);
	var dx = 0;
	var dy = 0;
	if (mouse_wheel_down()) {
		camera_size_scale = min(camera_size_limit, camera_size_scale + 0.1);
	}
	else if (mouse_wheel_up()) {
		camera_size_scale = max(1, camera_size_scale - 0.1);
	}
	dx = cw - round(camera_size_scale * global.camera_width);
	dy = ch - round(camera_size_scale * global.camera_height);
	cw = round(camera_size_scale * global.camera_width);
	ch = round(camera_size_scale * global.camera_height);
	camera_set_view_size(view_camera[0], cw, ch);
	
	//set camera xy
	var cx = camera_get_view_x(view_camera[0]) + dx / 2;
	var cy = camera_get_view_y(view_camera[0]) + dy / 2;
	if (keyboard_check(ord("A"))) {
		cx -= camera_movement_speed;
	}
	if (keyboard_check(ord("D"))) {
		cx += camera_movement_speed;
	}
	if (keyboard_check(ord("S"))) {
		cy += camera_movement_speed;
	}
	if (keyboard_check(ord("W"))) {
		cy -= camera_movement_speed;
	}
	
	cx = median(0, cx, room_width - cw);
	cy = median(0, cy, room_height - ch);

	camera_set_view_pos(view_camera[0], cx, cy);
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
				obj_factory_id = global.factory_array[global.factory_array_index];
				break;
			case State.RAIL :
				rail_index = global.rail_array[global.rail_array_index];
				break;
			case State.GENERATOR :
				generator_id = global.generator_array[global.generator_array_index];
				break;
		}
	}
}

function get_factory_placeable2(_obj_factory_id, _dir) {
	var _result = get_place_grid_origin(_obj_factory_id.width, _obj_factory_id.height, mouse_grid_x, mouse_grid_y, _obj_factory_id.origin_index[0], _obj_factory_id.origin_index[1], _dir);
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
place_grid = ds_grid_create(250, 250);
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
ui_dy = 300;
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
	obj_rail.in_build = false;
	previous_maked_rail_id = noone;
	current_maked_rail_id = noone;
	temp_rail_ids = [];
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
		if (!instance_exists(previous_rail_id) and !instance_exists(current_obj_id)) { 
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y, true);
			if (_dir[0] != Direct.NONE and _dir[1] == Io.OUTPUT) {
				current_dir = _dir[0];
				start_same_shape = false;
				current_valible_dir = current_dir;
			}
		}
		else {
			var _dir = get_linked_output_way(mouse_floor_x, mouse_floor_y);
			if (_dir != Direct.NONE) {
				current_dir = _dir;
				start_same_shape = false;
				current_valible_dir = current_dir;
			}
		}
	}
}

function set_maked_rail() {
	var _num = array_length(temp_rail_ids);
	if (_num >= 2) {
		current_maked_rail_id = temp_rail_ids[_num - 1];
		previous_maked_rail_id = temp_rail_ids[_num - 2];
	}
}

function rollback_rail() {					
	if (current_obj_id == previous_maked_rail_id) {
		instance_destroy(previous_rail_id);
		previous_rail_id = current_obj_id;
		if (instance_exists(current_obj_id)) current_obj_id.is_completed = false;
		array_pop(temp_rail_ids);
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
				if (!instance_exists(current_obj_id)) {
					current_obj_id = noone;	
				}
				if (!instance_exists(previous_rail_id)) {
					previous_rail_id = noone;	
				}
				set_maked_rail();
				if (current_obj_id != noone) {
					//변화가 없으면 return
					if (current_dir == Direct.NONE) {
						return;
					}
					
					//이미 존재하는 rail 기억하는 부분
					if (previous_rail_id == noone) {
						if (current_obj_id.object_index == obj_rail) {
							previous_rail_id = current_obj_id;
						}
					}
					else if (current_obj_id.object_index != obj_rail) {
						previous_rail_id.finalize_output(current_dir);
					}
					else if (current_obj_id.in_build and previous_rail_id.in_build) {
						rollback_rail()
					}
				}

				if (current_obj_id == noone) {
					if (is_first_rail) {
						is_first_rail = false;
						current_dir = current_valible_dir
					}
					//Create rail at current location
					var _id =instance_create_depth(mouse_floor_x, mouse_floor_y, depth, obj_rail);
					array_push(temp_rail_ids, _id);
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
				
				if (previous_rail_id != noone and current_obj_id != noone and current_obj_id != previous_rail_id) {
					//마지막 끝맺음을 완벽하게 만들기 위한 부분
					if (current_obj_id.object_index == obj_rail) {
						current_obj_id.add_input(direction_reverse(current_dir));
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
				//obj_rail_input, obj_rail_output 형태
				if (!instance_exists(current_obj_id)) {			
					var _id = instance_create_depth(mouse_floor_x, mouse_floor_y, depth, rail_index.obj);
					_id.image_angle = mouse_sprite_angle mod 360;
					if (instance_exists(matched_underground_id)) {
						matched_underground_id.connected_rail_id = _id;
						matched_underground_id.init_rail(matched_distance);
						_id.connected_rail_id = matched_underground_id;
						_id.init_rail(matched_distance);
						matched_underground_id = noone;
					}
					else {
						_id.init_rail(0);	
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
				make_Facility(obj_factory_id, obj_factory)
			}
			break;
		case State.GENERATOR :
			if (factory_placeable) {
				make_Facility(generator_id, obj_generaotr)
			}
			break;
	}
}

function make_Facility(_str, _obj) {
	var _id = instance_create_depth(mouse_floor_x, mouse_floor_y, depth, _obj);
	_id.sprite_index = _str.spr;
	_id.image_angle = mouse_sprite_angle mod 360;
	set_place_grid(_id, , mouse_sprite_angle);
	_id.init_factory(_str);
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