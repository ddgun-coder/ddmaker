// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_item_movement(){

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
