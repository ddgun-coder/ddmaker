/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
obj_factory_id = noone;

input_tile = [[]];
output_tile = [[]];
input_tile_x = [];
outpu_tile_x = [];
input_tile_y = [];
outpu_tile_y = [];
input_type_number = -1;
output_type_number = -1;


function init_factory(_obj_factory_id) {
	obj_factory_id = _obj_factory_id;
	if (obj_factory_id == noone or obj_factory_id == undefined) return;
	
	var _unieuq_array = array_unique(obj_factory_id.input_item);
	input_type_number = array_length(_unieuq_array);
	if (!is_array(obj_factory_id.input_index[0])) {
		input_tile = obj_factory_id.input_index;
		input_tile_x = [x + input_tile[0] * 32];
		input_tile_y = [y + input_tile[1] * 32];
	}
	if (!is_array(obj_factory_id.output_index[0])) {
		output_tile = obj_factory_id.output_index;
		output_tile_x = [x + output_tile[0] * 32];
		output_tile_y = [y + output_tile[1] * 32];
	}
}