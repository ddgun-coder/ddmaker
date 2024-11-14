/// @description Insert description here
// You can write your code in this editor

direct = Direct.NONE;
next_tile = noone;
next_tile_x = 0;
next_tile_y = 0;
image_speed = 0;
is_moved = false;
repository_id = noone;
factory_id = noone;
item_type = noone;
opposite_in = false;
pre_tile_id = noone;
moved = false;
moved_frame = 0;
is_first = true;
show_xscale = 0;
show_yscale = 0;

function box_movement() {
	var _is_stop = false;
	with (next_tile) {
		if (object_index == obj_factory and obj_making) {
			_is_stop = true;
		}
	}
	
	if (_is_stop) {
		return;	
	}
	var _dx = 0;
	var _dy = 0;
	switch(direct) {
		case Direct.DOWN :
			_dy += 1;
			break;
		case Direct.UP :
			_dy -= 1;
			break;
		case Direct.LEFT :
			_dx -= 1;
			break;
		case Direct.RIGHT :
			_dx += 1;
			break;
	}

	if (_dx != 0 or _dy != 0) {
		if (!place_meeting(x + _dx, y + _dy, object_index)) {
			x += _dx;
			y += _dy;
			moved = true;
			moved_frame = 0;
		}
		else {
			/*
			moved_frame++; 
			if (moved_frame > 5) {
				direct = Direct.NONE;
				set_next_tile(noone);
				moved = false;
			}
			*/
		}
	}
}

function set_next_tile(_id, exception = false) {
	//direct 를먼저 할 것, 또한 이 _id는 자신의 밑에 있는 obj_rail을 의미
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
		return;
	}
	
	if (next_tile.object_index == obj_factory) {
		var _dxy = get_direction_dxdy(direct, 32);
		next_tile_x = pre_tile_id.x + _dxy[0];
		next_tile_y = pre_tile_id.y + _dxy[1];
		return;
	}
	
	next_tile_x = _id.x;
	next_tile_y = _id.y;
}

function position_meeting_next_tile() {
	if (!position_meeting(x, y, next_tile)) return;
	
	if (next_tile.object_index == obj_factory and repository_id == noone) {
		var _io = next_tile.get_factory_IO(x, y, false);
		if (_io == Io.INPUT and next_tile.obj_making == false and next_tile.can_add_item(item_type)) {
			next_tile.add_item(item_type);
			repository_id = next_tile;
		}
		else {
			instance_destroy();
		}
		return;
	}	
}

function go_and_add_item(_id, _type) {
	repository_id = _id;
	_id.add_item(other.item_type);
}

function place_meeting_next_tile() {
	if (!place_meeting(x, y, next_tile)) return;
	switch(next_tile.object_index) {
		case obj_rail_input :
		case obj_repository :
			if (repository_id == noone and next_tile.is_array_below_limit()) {
				go_and_add_item(next_tile, item_type);
			}
			break;
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

function metting_next_tile() {
	if (next_tile == noone) return;
	
	switch (next_tile.object_index) {
		case obj_factory :
			position_meeting_next_tile();
			break ;
		default: 
			place_meeting_next_tile();
			break;
	}
}