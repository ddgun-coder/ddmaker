/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
connected_rail_id = noone;
io = Io.OUTPUT;
connected_distance = 0;
output_dir = image_angle / 90;
cur_item = noone;

function init_rail(_dis) {
	connected_distance = _dis;
	output_dir = floor(image_angle / 90);
}

function is_item_received() {
	if (!instance_exists(connected_rail_id)) return false;
	var _array = connected_rail_id.item_queue_ready;
	var _info = array_first(_array);
	if (_info == undefined) return false;
	return _info.is_reached();
}	

function get_item() {
	if (!instance_exists(connected_rail_id)) return false;
	var _array = connected_rail_id.item_queue_ready;
	return array_shift(_array).type;
}

function extract_obj() {
	
}