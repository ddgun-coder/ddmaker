/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;
item_maked = false;
item_extract_speed = 1;
item_extract_max_time = 60;
item_extract_time = 0;
cur_output = 0;

function is_avaliable(_id) {
	if (_id == noone) return false; 
	
	switch(_id.object_index) {
		case obj_rail :
		case obj_repository :
			return true;
	}
	return false;
}

function cycle_output() {
	var _cur_order = 0;
	var _id = noone;
	for (var i = 0; i < way_number; i++) {
		_id = linked_obj[i];
		if (is_avaliable(_id)) {
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
		if (!place_meeting(other.x, other.y, obj_box)) {
			create_item(other.x, other.y, depth - 1, _dir, id, other.item_type);
			_is_created = true;
		}
	}
	if (_is_created) {
		item_maked = false;
	}
}