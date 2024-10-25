/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
obj_factory_id = noone;
show_sprite_index = noone;

input_tile = [[]];
output_tile = [[]];
input_tile_x = [];
outpu_tile_x = [];
input_tile_y = [];
outpu_tile_y = [];
input_type_number = -1;
output_type_number = -1;
center_x = 0;
center_y = 0;
left_top_x = 0;
left_top_y = 0;
cur_item_array = [];
need_item_array = [];


function get_factory_IO(_x, _y, _check_outside = true) {
	if (_check_outside) if (!position_meeting(_x, _y, id)) return noone;
	var _tile_x = floor((_x - left_top_x) / 32);
	var _tile_y = floor((_y - left_top_y) / 32);
	return obj_factory_id.get_tile_IO(_tile_x, _tile_y);
}


function init_factory(_obj_factory_id) {
	obj_factory_id = _obj_factory_id;
	if (obj_factory_id == noone or obj_factory_id == undefined) return;
	
	var _unieuq_array = array_unique(obj_factory_id.input_item);
	input_type_number = array_length(_unieuq_array);
	if (!is_array(obj_factory_id.input_index[0])) {
		input_tile = obj_factory_id.input_index;

	}
	if (!is_array(obj_factory_id.output_index[0])) {
		output_tile = obj_factory_id.output_index;

	}
	left_top_x = x - 16;
	left_top_y = y - 16;
	center_x = left_top_x + sprite_get_height(sprite_index) / 2;
	center_y = left_top_y + sprite_get_width(sprite_index) / 2;
}