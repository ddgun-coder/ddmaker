/// @description Insert description here
// You can write your code in this editor
if (direct == Direct.NONE) {
	image_index = 1;
}
else if (is_moved == false) {
	image_index = 2;
}
else {
	image_index = 0;	
}

box_movement();
//움직이는 부분

if (x != xprevious or y != yprevious) {
	is_moved = true;
}	
else {
	is_moved = false;
}

if (!instance_exists(next_tile)) {
	direct = Direct.NONE;
	set_next_tile(noone); 
}
metting_next_tile();
//next_tile에 도착했는지 확인

if (direct == Direct.NONE) {
	if (!instance_exists(noone)) {
		var _id = instance_position(x, y, obj_rail);
		if (_id != noone) {
			_id.cycle_output(id);
		}
	}
	else {
		if (place_meeting(x, y, next_tile)) {
			switch (next_tile.object_index) {
				case obj_rail :
					next_tile.cycle_output(id);
					break;
			}
		}
	}
}
//다음 tile 찾기

if (repository_id != noone) {
	show_xscale -= 0.03;
	show_yscale -= 0.03;
	if (show_xscale <= 0) {
		instance_destroy();
	}
}
else if (is_first) {
	show_xscale += 0.03;	
	show_yscale += 0.03;	
	if (show_yscale >= 1) {
		show_yscale = 1;
		show_xscale = 1;
		is_first = false;
	}
}