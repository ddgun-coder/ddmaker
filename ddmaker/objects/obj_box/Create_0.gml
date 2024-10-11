/// @description Insert description here
// You can write your code in this editor
direct = Direct.NONE;
next_tile = noone;
next_tile_x = 0;
next_tile_y = 0;
image_speed = 0;
is_moved = false;
repository_id = noone;
item_type = noone;
opposite_in = false;

function set_next_tile(_id, exception = false) {
	//direct 를먼저 할 것.
	next_tile = _id;
	if (_id == noone) return;
	
	if (exception) {
		next_tile_x = _id.x;
		next_tile_y = _id.y;
		return;
	}
	
	if (next_tile.object_index == obj_rail and next_tile.is_opposite_input) {
		var _dxy = get_direction_dxdy(direction_reverse(direct), 17);
		next_tile_x = _id.x + _dxy[0];
		next_tile_y = _id.y + _dxy[1];
		opposite_in = true;
	}
	else {
		next_tile_x = _id.x;
		next_tile_y = _id.y;
	}
}

function metting_next_tile() {
	if (place_meeting(x, y, next_tile)) {
		if (next_tile.object_index == obj_repository) {
			if (next_tile.is_array_below_limit()) {
				repository_id = next_tile;
			}
		}
		
		var is_completed = false;
		switch(direct) {	
			case Direct.RIGHT :
				if (x > next_tile_x) {
					is_completed = true;
				}
				break;
			case Direct.LEFT :
				if (x < next_tile_x) {
					is_completed = true;
				}
				break;
			case Direct.DOWN :
				if (y > next_tile_y) {
					is_completed = true;
				}
				break;
			case Direct.UP :
				if (y < next_tile_y) {
					is_completed = true;
				}
				break;
		}
		if (is_completed) {
			x = next_tile_x;
			y = next_tile_y;
			direct = Direct.NONE;
		}
	}	
}