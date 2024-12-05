/// @description Insert description here
// You can write your code in this editor
image_xscale = 5;
image_yscale = 2;
cur_array = [];
spr_width = 64;
cur_state = State.NONE;
function set_cur_array() {
	switch (cur_state) {
		case State.FACTORY :
			cur_array = global.factory_array;
			spr_width = 64;
			break;	
		case State.GENERATOR :
			cur_array = global.generator_array;
			spr_width = 64;
			break;	
		case State.RAIL :
			cur_array = global.rail_array;
			spr_width = 32;	
			break;
	}	
}

function get_glowspr(_width, _height) {
	if (_width == 32 and _height == 32) {
		return 	spr_fac_1x1_glow;
	}
	if (_width == 64 and _height == 64) {
		return 	spr_fac_2x2_glow;
	}
	if (_width == 96 and _height == 96) {
		return 	spr_fac_3x3_glow;
	}
	if (_width == 32 * 4 and _height == 32 * 4) {
		return 	spr_fac_4x4_glow;
	}
	if (_width == 32 * 5 and _height == 32 * 5) {
		return 	spr_fac_5x5_glow;
	}
}

function check_button_size(_dx) {
	var _left = xstart - 16;
	var _right, _width, _spr;
	var _num = array_length(cur_array);
	for (var i = 0; i < _num; i++) {
		_spr = cur_array[i].spr;
		_xoffset = sprite_get_xoffset(_spr);
		_yoffset = sprite_get_yoffset(_spr);
		_width = sprite_get_width(_spr);
		_right = _left + _width;
		if (median(_left, _dx, _right) == _dx) {
			global.generator_array_index = i;
			obj_make_manager.generator_id = cur_array[i];
			return;
		}
		_left += _width + 10;
	}
}

function set_next_item() {
	var _num = array_length(cur_array);
	switch (obj_make_manager.make_state) {
		case State.FACTORY :
			global.factory_array_index = (global.factory_array_index + 1) mod _num;
			obj_make_manager.obj_factory_id = cur_array[global.factory_array_index];
			break;
		case State.GENERATOR :
			global.generator_array_index = (global.generator_array_index + 1) mod _num;
			obj_make_manager.generator_id = cur_array[global.generator_array_index];
			break;
		case State.RAIL :
			global.rail_array_index = (global.rail_array_index + 1) mod _num;
			obj_make_manager.rail_index = cur_array[global.rail_array_index];
			break;
	}	
}

function set_tile(display_x) {
	var _dx;
	_dx = floor((display_x - x + 16) / (spr_width + 10));
	if (0 <= _dx and _dx < array_length(cur_array)) {
		switch (obj_make_manager.make_state) {
			case State.FACTORY :
				global.factory_array_index = _dx;
				obj_make_manager.obj_factory_id = cur_array[_dx];
				break;
			case State.RAIL :
				global.rail_array_index = _dx;
				obj_make_manager.rail_index = cur_array[_dx];
				break;
		}
	}
	switch (obj_make_manager.make_state) {
		case State.GENERATOR :
			check_button_size(display_x);
			break;
	} 
}