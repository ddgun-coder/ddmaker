/// @description Insert description here
// You can write your code in this editor
if (direct == Direct.NONE) {
	image_index = 1;
}
else {
	image_index = 0;	
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
if (!place_meeting(x + _dx, y + _dy, object_index)) {
	x += _dx;
	y += _dy;
}
//움직이는 부분

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
//next_tile에 도착했는지 확인
if (next_tile != noone and !instance_exists(next_tile)) {
	direct = Direct.NONE;
	set_next_tile(noone); 
}

if (direct == Direct.NONE) {
	if (next_tile == noone) {
		var _id = instance_position(x, y, obj_rail);
		if (_id != noone) {
			_id.cycle_output(id);
		}
	}
	else {
		switch (next_tile.object_index) {
			case obj_rail :
				if (place_meeting(x, y, next_tile)) {
					next_tile.cycle_output(id);
				}
				break;
			case obj_repository :
				
				break;
		}

	}
}
//다음 tile 찾기