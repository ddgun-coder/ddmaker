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
	var _itme = array_shift(_array);
	return _itme.type;
}

function extract_obj() {
	var _dir = output_dir;
	var _is_created = false;

	with (linked_obj[_dir]) {
		if (way[direction_reverse(_dir)] == Way.INPUT) {
			if (!place_meeting(other.x, other.y, obj_box)) {
				var _type = other.get_item();
				create_item(other.x, other.y, depth - 1, _dir, id, _type);
				_is_created = true;
			}
		}
	}
	if (_is_created) {
		item_maked = false;
	}
}