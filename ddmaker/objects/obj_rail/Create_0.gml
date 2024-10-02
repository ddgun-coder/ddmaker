/// @description Insert description here
// You can write your code in this editor
enum Way { 
	NONE,
	INPUT,
	OUTPUT,
}
way = [Way.OUTPUT, Way.NONE, Way.INPUT, Way.NONE];
way_number = 4;
input_number = 1;
output_number = 1;
is_completed = false;
current_direction = Direct.NONE;
connected_output = array_create(4, noone);
connected_input = array_create(4, noone);
cur_output = 0;
temp_dir = Direct.NONE;

function finalize_output(_Direct) {
	 if (is_completed) {
		add_output(_Direct);
	}
	else {
		change_output(_Direct);
	}
	is_completed = true;
}

function get_cur_output_direction() {
	var _cur_order = 0;
	for (var i = 0; i < way_number; i++) {
		if (connected_output[i] != noone) {
			if (_cur_order < cur_output) {
				_cur_order++;
				continue;
			}
			return i;
		}
	}
	return noone;
}

function cycle_output(_box_id) {
	var _cur_order = 0;
	for (var i = 0; i < way_number; i++) {
		if (connected_output[i] != noone) {
			if (_cur_order < cur_output) {
				_cur_order++;
				continue;
			}
			_box_id.direct = i;
			_box_id.next_tile = connected_output[i];
			cur_output = (cur_output + 1) mod output_number;
			return;
		}
	}
	cur_output = (cur_output + 1) mod output_number;
}


function change_input(_Direct) {
	if (input_number == 1) {
		var _index = array_get_index(way, Way.INPUT);
		if (_index == _Direct or (_index + 2) % way_number == _Direct) return;
		way[_Direct] = Way.INPUT;
		way[_index] = Way.NONE;
	}
	cal_sprite_and_angle();
}

function add_output(_Direct) {
	if (way[_Direct] == Way.NONE) way[_Direct] = Way.OUTPUT;
	cal_sprite_and_angle();
}

function add_input(_Direct) {
	if (way[_Direct] == Way.NONE) way[_Direct] = Way.INPUT;
	cal_sprite_and_angle();
}

function change_output(_Direct) {
	if (output_number == 1) {
		var _index = array_get_index(way, Way.OUTPUT);
		if (_index == _Direct or (_index + 2) % way_number == _Direct) return;
		way[_Direct] = Way.OUTPUT;
		way[_index] = Way.NONE;
	}
	cal_sprite_and_angle();
}

function set_one_way_direction(_Direct) { 
	input_number = 1;
	output_number = 1;
	switch (_Direct) {
		case Direct.RIGHT :
			way = [Way.OUTPUT, Way.NONE, Way.INPUT, Way.NONE];
		break;
		case Direct.LEFT :
			way = [Way.INPUT, Way.NONE, Way.OUTPUT, Way.NONE];
		break;
		case Direct.UP :
			way = [Way.NONE, Way.OUTPUT, Way.NONE, Way.INPUT];
		break;
		case Direct.DOWN :
			way = [Way.NONE, Way.INPUT, Way.NONE, Way.OUTPUT];
		break;
	}
	cal_sprite_and_angle();
}

function check_output_connected() {
	for (var i = 0; i < way_number; i++) {
		connected_output[i] = noone;
		if (way[i] == Way.OUTPUT) {
			var _dxy = get_direction_dxdy(i);
			var _id = instance_place(x + _dxy[0], y + _dxy[1], obj_rail);
			if (_id != noone and _id.way[direction_reverse(i)] == Way.INPUT) {
				connected_output[i] = _id;
				_id.connected_input[direction_reverse(i)] = id;
			}
		}
	}
}

function check_input_connected() {
	for (var i = 0; i < way_number; i++) {
		connected_input[i] = noone;
		if (way[i] == Way.INPUT) {
			var _dxy = get_direction_dxdy(i);
			var _id = instance_place(x + _dxy[0], y + _dxy[1], obj_rail);
			if (_id != noone and _id.way[direction_reverse(i)] == Way.OUTPUT) {
				connected_input[i] = _id;
				_id.connected_output[direction_reverse(i)] = id;
			}
		}
	}
}

function cal_sprite_and_angle() {
	var _out_number = 0;
	var _input_number = 0;
	//cal input/output number
	for (i = 0; i < way_number; i++) {
		if (way[i] == Way.OUTPUT) {
			_out_number++;
		}
		else if (way[i] == Way.INPUT) {
			_input_number++;	
		}
	}
	output_number = _out_number;
	input_number = _input_number;
	//default
	sprite_index = spr_no_way_rail;	
	image_angle = 0;
	var _input_ind, _output_ind, _none_ind;
	var _in_ind;
	switch (input_number) {
		case 1 :
			switch (output_number) {
				case 1 :
					_input_ind = array_get_index(way, Way.INPUT);
					_output_ind = array_get_index(way, Way.OUTPUT);
					
					if ((_input_ind + 1) % way_number == _output_ind) {
						//INPUT 왼쪽에 OUTPUT
						sprite_index = spr_one_way_rail3;	
					}
					else if ((_output_ind + 1) % way_number == _input_ind) {
						//OUTPUT 왼쪽에 INPUT
						sprite_index = spr_one_way_rail2;	
					}
					else {
						//둘 다 아님 == 반대편에 NONE이 존재
						sprite_index = spr_one_way_rail;	
					}
					break;
				case 2 :
					_input_ind = array_get_index(way, Way.INPUT);
					_none_ind = array_get_index(way, Way.NONE);
					if ((_input_ind + 1) % way_number == _none_ind) {
						//INPUT 왼쪽에 NONE
						sprite_index = spr_two_way_rail2;	
					}
					else if ((_none_ind + 1) % way_number == _input_ind) {
						//NONE 왼쪽에 INPUT
						sprite_index = spr_two_way_rail3;	
					}
					else {
						//둘 다 아님 == 반대편에 OUTPUT 존재
						sprite_index = spr_two_way_rail1;
					}
					break;
				case 3 :
					sprite_index = spr_three_way_rail;	
					break;
			}
			image_angle = (array_get_index(way, Way.INPUT) - 2) * 90;
			break;
		case 2 :
			if (output_number == 1) {
				_output_ind = array_get_index(way, Way.OUTPUT);
				_none_ind = array_get_index(way, Way.NONE);
				if ((_output_ind + 1) % way_number == _none_ind) {
					//OUTPUT 왼쪽에 NONE
					sprite_index = spr_two_way_rail5;	
				}
				else if ((_none_ind + 1) % way_number == _output_ind) {
					//NONE 왼쪽에 OUTPUT
					sprite_index = spr_two_way_rail6;	
				}
				else {
					//둘 다 아님 == 반대편에 INPUT 존재
					sprite_index = spr_two_way_rail4;
				}
				image_angle = (array_get_index(way, Way.OUTPUT) - 2) * 90;
			}
			else if (output_number == 2) {
				sprite_index = spr_cross_way_normal;
				if (way[0] == way[1]) {
					if (way[0] == Way.OUTPUT) {
						image_angle = 0;
					}
					else {
						image_angle = 180;
					}
				}
				else {
					if (way[0] == Way.OUTPUT) {
						image_angle = 270;
					}
					else {
						image_angle = 90;
					}
				}
			}
			//input, output 각각 2개 인 경우는 cross로 사용
			break;
		case 3 :
			if (output_number == 1) {
				sprite_index = spr_three_way_rail2;
				image_angle = (array_get_index(way, Way.OUTPUT) - 2) * 90;
			}
			break;
	}
	check_output_connected();
	check_input_connected();
}