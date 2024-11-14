/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
connected_rail_id = noone;
connected_distance = 0;
io = Io.INPUT;
show_info = false;
item_queue_ready = [];
item_array = [];
input_dir = direction_reverse(floor(image_angle / 90));

function item_info(type) constructor{
	self.type = type;
	time = 0;
	time_max = 10 * other.connected_distance;
	function add_time() {
		time = min(time_max, time + 1);
	}
	function is_reached() {
		return time >= time_max;	
	}
}

function init_rail(_dis) {
	connected_distance = _dis;
	item_queue_ready = [];
	input_dir = direction_reverse(floor(image_angle / 90));
	check_linked_obj_one_way(input_dir);
	var _id = linked_obj[input_dir];
	if (instance_exists(_id) and _id.object_index == obj_rail) {
		_id.check_output_connected();
	}	
}

function is_array_below_limit() {
	return array_length(item_queue_ready) < connected_distance;
}

function add_item(_type) {
	array_push(item_queue_ready, new item_info(_type));
}

