/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
alarm[0] = 8;
obj_factory_id = noone;
show_sprite_index = noone;

input_tile = [[]];
output_tile = [[]];
input_tile_x = [];
output_tile_x = [];
input_tile_y = [];
output_tile_y = [];
center_x = 0;
center_y = 0;
left_top_x = 0;
left_top_y = 0;
cur_item_array = [];
cur_item_stock = {};
need_item_array = [];
need_item_stock = {};
obj_making = false;
making_process = 0;
making_process_max = 60 * 2;
output_number = 0;
fuel_item_type = noone;
cur_output = 0;
electric_cap = 100;
electric = 0;
fuel_tank = 0;
fuel_speed = 0;
fuel_max_cap = 0;

function get_exit_directions(_x, _y) {
    var _dir = [];

    if _y == 0
        array_push(_dir, Direct.UP);
    if _y == obj_factory_id.height - 1
		array_push(_dir, Direct.DOWN);
    if _x == 0
       array_push(_dir, Direct.LEFT);
    if _x == obj_factory_id.width - 1
        array_push(_dir, Direct.RIGHT);

    return _dir;
}

function is_output_tile(_x, _y) {
	if (is_array(output_tile[0])) {
			
	}	
	else {
		if (_x == output_tile[0] and _y == output_tile[1]) {
			return true;
		}
	}
		
	return false;
}
function is_input_tile(_x, _y) {
	if (is_array(input_tile[0])) {
			
	}	
	else {
		if (_x == input_tile[0] and _y == input_tile[1]) {
			return true;
		}
	}
		
	return false;
}
function get_tile_IO(_x, _y) {
	if (is_output_tile(_x, _y)) return Io.OUTPUT;
	if (is_input_tile(_x, _y)) return Io.INPUT;
	return noone;
}

function cycle_output() {
	var _cur_order = 0;
	var _id = noone;
	for (var i = 0; i < way_number; i++) {
		_id = linked_obj[i];
		if (_id != noone and (_id.object_index == obj_rail or _id.object_index == obj_repository)) {
			if (_cur_order < cur_output) {
				_cur_order++;
				continue;
			}
			cur_output = (cur_output + 1) mod linked_number;
			return i;
		}
	}
	return noone;
}

function extract_obj() {
	var _dir = cycle_output();
	if (_dir == noone) return;
	
	var _is_created = false;
	if (!check_extractable(linked_obj[_dir], _dir)) return;

	with (linked_obj[_dir]) {
		if (!place_meeting(other.output_tile_x, other.output_tile_y, obj_box)) {
			create_item(other.output_tile_x, other.output_tile_y, depth - 1, _dir, id, other.item_type);
			_is_created = true;
		}
	}
	if (_is_created) {
		output_number--;
	}
}

function item_stock(num, _type) constructor {
	number = num;
	type = _type;
}

function can_add_item(_item) {
	show_debug_message(_item == fuel_item_type);
	return _item == fuel_item_type and fuel_max_cap >= fuel_tank + 1;
}

function can_make_output() {
	var _names = struct_get_names(need_item_stock);
	var _num = array_length(_names);
	for (var i = 0; i < _num; i++) {
		if (need_item_stock[$ _names[i]].number > cur_item_stock[$ _names[i]].number) {
			return false;
		}
	}
	return true;
}

function make_output() {
	var _names = struct_get_names(need_item_stock);
	var _num = array_length(_names);
	for (var i = 0; i < _num; i++) {
		cur_item_stock[$ _names[i]].number -= need_item_stock[$ _names[i]].number;
	}
	output_number++;
	obj_making = false;
}

function add_item(_item) {
	fuel_tank += 1;
	/*
	cur_item_stock[$ _item.item_name].number += 1;
	if (can_make_output()) obj_making = true;
	*/
}

function array_to_stock(_array) {
	var _result = {};
	var _item;
	var _num = array_length(_array);
	for (var i = 0; i < _num; i++) {
		_item = _array[i];
		if (struct_exists_from_hash(_result, _item.hash)) {
			var _str = struct_get_from_hash(_result, _item.hash);
			_str.number += 1;
		}
		else {
			struct_set_from_hash(_result, _item.hash, new item_stock(1, _item));
		}
	}
	return _result;
}

function reset_cur_item_stock() {
	struct_foreach(need_item_stock, function(name, val) {
		cur_item_stock[$ name] = new item_stock(0, val.type);
	});
}

function get_factory_IO(_x, _y, _check_outside = true) {
	if (_check_outside) if (!position_meeting(_x, _y, id)) return noone;
	var _tile_x = floor((_x - left_top_x) / 32);
	var _tile_y = floor((_y - left_top_y) / 32);
	return get_tile_IO(_tile_x, _tile_y);
}

function get_output_x(_tilex) {
	return _tilex * 32 + left_top_x + 16;
}
function get_output_y(_tiley) {
	return _tiley * 32 + left_top_y + 16;
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
	return _result = [];
}

function get_factory_spined_array(_x, _y, _angle, _factory_id) {
	_result = [];
	switch (_angle) {
		case 0:	
			_result[0] = _x;
			_result[1] = _y;
			break;
		case 90:
			_result[0] = _y;
			_result[1] = _factory_id.width - _x - 1;
			break;
		case 180:	
			_result[0] = _factory_id.width - _x - 1;
			_result[1] = _factory_id.height - _y - 1;
			break;
		case 270	:	
			_result[0] = _factory_id.height - _y - 1; 
			_result[1] = _x;
			break;
		
	}
	return _result;
}

function init_factory(_obj_factory_id) {
	obj_factory_id = _obj_factory_id;
	if (obj_factory_id == noone or obj_factory_id == undefined) return;
	var _top = get_factory_spined_array(obj_factory_id.origin_index[0], obj_factory_id.origin_index[1],image_angle, obj_factory_id);
	left_top_x = x - _top[0] * 32 - 16;
	left_top_y = y - _top[1] * 32 - 16;
	set_output();
	set_input();
	center_x = left_top_x + sprite_get_height(sprite_index) / 2;
	center_y = left_top_y + sprite_get_width(sprite_index) / 2;
	need_item_array = obj_factory_id.input_item;
	need_item_stock = array_to_stock(need_item_array);
	reset_cur_item_stock();
}

function set_output() {
	fuel_item_type = obj_factory_id.fuel_type;
	fuel_max_cap = obj_factory_id.fuel_max_cap;
	fuel_speed = obj_factory_id.fuel_speed;
	electric_cap = obj_factory_id.electric_cap;
}

function set_input() {
	if (!is_array(obj_factory_id.input_index[0])) {
		input_tile = get_factory_spined_array(obj_factory_id.input_index[0], obj_factory_id.input_index[1], image_angle, obj_factory_id);
		var _directs = get_exit_directions(obj_factory_id.input_index[0], obj_factory_id.input_index[1]);
		var _num = array_length(_directs);
		var _xy, _x, _y, _id;
		for (var i = 0; i < _num; i++) {
			_xy = get_direction_dxdy(_directs[i], 1);
			_x = get_output_x(obj_factory_id.input_index[0] + _xy[0]);
			_y = get_output_y(obj_factory_id.input_index[1] + _xy[1]);
			_id = instance_position(_x, _y, obj_rail);
			if (_id != noone and _id.object_index == obj_rail) {
				_id.check_output_connected();
			}
		}
	}
}