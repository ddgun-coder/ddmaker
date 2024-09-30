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
	switch(direct) {
		case Direct.RIGHT :
			if (x > next_tile.x) {
				direct = Direct.NONE;
			}
			break;
		case Direct.LEFT :
			if (x < next_tile.x) {
				direct = Direct.NONE;
			}
			break;
		case Direct.DOWN :
			if (y > next_tile.y) {
				direct = Direct.NONE;
			}
			break;
		case Direct.UP :
			if (y < next_tile.y) {
				direct = Direct.NONE;
			}
			break;
	}
}

if (direct == Direct.NONE) {
	if (place_meeting(x, y, next_tile)) {
		next_tile.cycle_output(id);
	}
}