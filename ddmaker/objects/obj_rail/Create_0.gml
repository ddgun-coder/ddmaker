/// @description Insert description here
// You can write your code in this editor
enum Way { 
	NONE,
	INPUT,
	OUTPUT,
}
rail_item = [];//현재 rail가 가지고 있는 item
way = [Way.OUTPUT, Way.NONE, Way.INPUT, Way.NONE];
way_number = 4;
input_number = 1;
output_number = 1;
is_completed = false;

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
	way[_Direct] = Way.OUTPUT;
	cal_sprite_and_angle();
}

function add_input(_Direct) {
	way[_Direct] = Way.INPUT;
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
}