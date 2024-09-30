/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;
item_maked = false;
item_extract_speed = 1;
item_extract_max_time = 60;
item_extract_time = 0;
cur_output = 0;
item_type = global.wood;

function cycle_output() {
	var _cur_order = 0;
	for (var i = 0; i < way_number; i++) {
		if (linked_obj[i].object_index == obj_rail and linked_obj[i] != noone) {
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
			if (!place_meeting(other.x, other.y, obj_box)) {
				_id = instance_create_depth(other.x, other.y, depth - 1, obj_box);
				_id.direct = _dir;
				_id.next_tile = id;
				_is_created = true;
			}
		}
	}
	if (_is_created) {
		item_maked = false;
	}
}