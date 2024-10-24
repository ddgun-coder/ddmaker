// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum Io {
	OUTPUT,
	INPUT,
	BOTH
}

function get_linked_output_way(_x, _y, _get_io = false) {
	var _id, _xy;
	for (var i = 0; i < 4; i++) {
		_xy = get_direction_dxdy(i);
		_id = instance_position(_x + _xy[0], _y + _xy[1], obj_abs_component);
		if (_id != noone) {
			var _io = get_IO(_id, _x + _xy[0], _y + _xy[1]);
			if (_io == Io.INPUT) {
				if (_get_io) {
					return [i, Io.INPUT];
				}
				else {
					return i;
				}
			}
			else if (_io == Io.OUTPUT) {
				if (_get_io) {
					return [direction_reverse(i), Io.OUTPUT];
				}
				else {
					return direction_reverse(i);
				}
			}
		}
	}
	if (_get_io) {
		return [Direct.NONE, Io.BOTH];
	}
	else {
		return Direct.NONE;
	}
}

function get_IO(_id, _dx, _dy) {
	switch (_id.object_index) {
		case obj_repository :
			return Io.INPUT
		case obj_extractor :
			return Io.OUTPUT
		case obj_factory :
			return _id.get_factory_IO(_dx, _dy);
	}
}

function is_opposite_direction(dir1, dir2) {
	if (dir1 == 0 and dir2 == 2) or (dir1 == 2 and dir2 == 0) {
		return true;	
	}
	if (dir1 == 1 and dir2 == 3) or (dir1 == 3 and dir2 == 1) {
		return true;	
	}
	return false;
}

function direction_reverse(_Direct){
	return (_Direct + 2) mod 4;
}

function get_direction_dxdy(_Direct, _len = 32) {
	switch(_Direct) {
		case Direct.DOWN :
			return [0, _len];
		case Direct.UP :
			return [0, -_len];
		case Direct.LEFT :
			return [-_len, 0];
		case Direct.RIGHT :
			return [_len, 0];
	}
}

function cal_direction(x2, y2, x1, y1) {
	if (x2 > x1) {
		return Direct.LEFT;
	}
	else if (x2 < x1) {
		return Direct.RIGHT;	
	}
	else if (y2 > y1) {
		return Direct.UP;	
	}
	else if (y2 < y1) {
		return Direct.DOWN;	
	}
	return Direct.NONE;
}
