/// @description Insert description here
// You can write your code in this editor
enum Way { 
	NONE,
	INPUT,
	OUTPUT,
}
rail_item = [];
way = [Way.OUTPUT, Way.NONE, Way.OUTPUT, Way.INPUT];
way_number = 4;
input_number = 1;
output_number = 1;

function cal() {
	static get_spined_array = function() {
		var result_array = [];
		var _input_index = 0;
		array_copy(result_array, 0, way, 0, array_length(way));
	
		for (var i = 0; i < way_number; i++) {
			if (result_array[i] == Way.INPUT) {
				_input_index = i;
				break;
			}
		}
		var _val;
		repeat(_input_index) {
			_val = array_shift(result_array);
			array_push(result_array, _val);
		}
		return result_array;
	}
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
	
	switch (input_number) {
		case 0 : 
			sprite_index = spr_no_way_rail;
			break;
		case 1 :
			switch (output_number) {
				case 1 :
					sprite_index = spr_one_way_rail;	
					break;
				case 2 :
					var _array = get_spined_array();
					switch (array_get_index(_array, Way.NONE)) {
						case 1 :
							sprite_index = spr_two_way_rail2;
							break;
						case 2 :
							sprite_index = spr_two_way_rail1;
							break;
						case 3 :
							sprite_index = spr_two_way_rail3;
							break;
					}
					break;
				case 3 :
					sprite_index = spr_three_way_rail;	
					break;
			}
			image_angle = (array_get_index(way, Way.INPUT) - 2) * 90;
			break;
	}
}

cal();