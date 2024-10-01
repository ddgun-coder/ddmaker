/// @description Insert description here
// You can write your code in this editor
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
if (!place_meeting(x + _dx, y + _dy, object_index)) {
	x += _dx;
	y += _dy;
}

if (place_meeting(x, y, next_tile)) {
	var is_completed = false;
	switch(direct) {
		case Direct.RIGHT :
			if (x > next_tile.x) {
				is_completed = true;
			}
			break;
		case Direct.LEFT :
			if (x < next_tile.x) {
				is_completed = true;
			}
			break;
		case Direct.DOWN :
			if (y > next_tile.y) {
				is_completed = true;
			}
			break;
		case Direct.UP :
			if (y < next_tile.y) {
				is_completed = true;
			}
			break;
	}
	if (is_completed) {
		x = next_tile.x;
		y = next_tile.y;
		direct = Direct.NONE;
	}
}

if (direct == Direct.NONE) {
	if (place_meeting(x, y, next_tile)) {
		next_tile.cycle_output(id);
	}
}