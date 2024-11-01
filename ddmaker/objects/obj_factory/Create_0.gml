/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
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
item_type = noone;
cur_output = 0;

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

	with (linked_obj[_dir]) {
		if (way[direction_reverse(_dir)] == Way.INPUT) {
			if (!place_meeting(other.output_tile_x, other.output_tile_y, obj_box)) {
				create_item(other.output_tile_x, other.output_tile_y, depth - 1, _dir, id, other.item_type);
				_is_created = true;
			}
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
	var _names = struct_get_names(need_item_stock);
	var _num = array_length(_names);
	for (var i = 0; i < _num; i++) {
		if (_names[i] == _item.item_name and need_item_stock[$ _names[i]].number > cur_item_stock[$ _names[i]].number) {
			return true;
		}
	}
	return false;
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
	cur_item_stock[$ _item.item_name].number += 1;
	if (can_make_output()) obj_making = true;
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
	return obj_factory_id.get_tile_IO(_tile_x, _tile_y);
}

function get_output_x(_tilex) {
	return _tilex * 32 + x;
}
function get_output_y(_tiley) {
	return _tiley * 32 + y;
}

function init_factory(_obj_factory_id) {
	obj_factory_id = _obj_factory_id;
	if (obj_factory_id == noone or obj_factory_id == undefined) return;
	left_top_x = x - 16;
	left_top_y = y - 16;
	item_type = obj_factory_id.output_item[0];
	if (!is_array(obj_factory_id.input_index[0])) {
		input_tile = obj_factory_id.input_index;

	}
	if (!is_array(obj_factory_id.output_index[0])) {
		output_tile = obj_factory_id.output_index;
		output_tile_x = get_output_x(output_tile[0]);
		output_tile_y = get_output_y(output_tile[1]);
		check_linked_obj(output_tile_x, output_tile_y);
	}
	center_x = left_top_x + sprite_get_height(sprite_index) / 2;
	center_y = left_top_y + sprite_get_width(sprite_index) / 2;
	need_item_array = obj_factory_id.input_item;
	need_item_stock = array_to_stock(need_item_array);
	reset_cur_item_stock();
}