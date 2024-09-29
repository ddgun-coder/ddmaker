/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;
item_maked = false;
item_extract_speed = 1;
item_extract_max_time = 60;
item_extract_time = 0;

item_type = global.wood;

function extract_obj() {
	var _is_created = false;
	for (var i = 0; i < way_number; i++) {
		if (linked_obj[i] == noone) continue;
		with (linked_obj[i]) {
			if (object_index == obj_rail) {
				if (way[direction_reverse(i)] == Way.INPUT) {
					if (array_length(rail_item) < rail_item_limit) {
						_id = instance_create_depth(other.x, other.y, depth - 1, obj_box);
						array_push(rail_item, _id);
						_is_created = true;
					}
				}
			}
		}
		if (_is_created) {
			item_maked = false;
			break;
		}
	}	
}