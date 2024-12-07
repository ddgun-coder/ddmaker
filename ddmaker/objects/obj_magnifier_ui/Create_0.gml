/// @description Insert description here
// You can write your code in this editor
image_alpha = 0;

function draw_inOut_put(_id, _draw_x, _draw_y) {
	var _str = _id.obj_factory_id;
	var _tilex = 0;
	var _tiley = 0;
	
	var _left = _draw_x - sprite_get_xoffset(_str.show_spr);
	var _top = _draw_y - sprite_get_yoffset(_str.show_spr);
	
	for (var i = 0; i < _str.width; i++) {
		for (var j = 0; j < _str.height; j++) {
			_tilex = _left + i * 32 + 16;
			_tiley = _top + j * 32 + 16;
			if (_id.is_output_tile(i, j)) {
				draw_sprite(spr_rail_check_ui, 2, _tilex, _tiley);
			}
			else if(_id.is_input_tile(i, j)) {
				draw_sprite(spr_rail_check_ui, 1, _tilex, _tiley);
			}
			else {
				draw_sprite(spr_rail_check_ui, 0, _tilex, _tiley);
			}
		}
	}
	_draw_y += sprite_get_yoffset(_str.show_spr) + 16;
	return _draw_y;
}

function draw_factory_item_state(_id, _draw_x, _draw_y) {
	draw_sprite(spr_need, 0,_draw_x, _draw_y);
	draw_stock(_id.need_item_stock, _draw_x, _draw_y + 16);
	draw_sprite(spr_cur, 0, _draw_x, _draw_y + 64);
	draw_stock(_id.cur_item_stock, _draw_x, _draw_y + 80);
	return _draw_y + 150;
}

function draw_generator_item_state(_id, _draw_x, _draw_y) {
	var _dx = sprite_width / 2 - 16;
	var _dy;
	var _xscale = (_dx - 8) / 32;
	draw_sprite(_id.fuel_item_type.spr, 0, _draw_x - _dx, _draw_y);
	draw_sprite_ext(spr_generator_fuel_ui, 0, _draw_x - _dx + 16, _draw_y, _xscale, 1, 0, c_white, 1);
	draw_sprite_part_ext(spr_generator_fuel_ui_in, 1, 0, 0, 64 * _id.fuel_tank / _id.fuel_max_cap, 16, _draw_x - _dx + 16, _draw_y - sprite_get_yoffset(spr_generator_fuel_ui), _xscale, 1, c_white, 1);
	_draw_y += 16;
	draw_sprite(spr_generator_electric_ui, 0, _draw_x, _draw_y);
	_dy = 64 * _id.electric / _id.electric_cap;
	draw_sprite_part(spr_generator_electric_ui, 1, 0, 0, 64, _dy, _draw_x - sprite_get_xoffset(spr_generator_electric_ui), _draw_y + 64 - _dy);
	
	return _draw_y + 64;
}

function set_image_yscale(_draw_y) {
	image_yscale = max(1, (_draw_y - y) / 256);
}

function draw_stock(_str, _draw_x, _draw_y) {
	var _names = struct_get_names(_str);
	var _num = array_length(_names);
	for (var i = 0; i < _num; i++) {
		_item_str = _str[$ _names[i]];
		draw_sprite(_item_str.type.spr, 0, _draw_x - 32, _draw_y + i * 16);
		draw_text(_draw_x, _draw_y + i * 16, string(" : {0}", _item_str.number));
	}
}

function draw_rail_connection(_id) {
	var _dir = floor(_id.image_angle / 90);
	var _sign;
	if (_id.io == Io.INPUT) {
		_sign = 1;
	}
	else if (_id.io == Io.OUTPUT) {
		_sign = -1;
	}
	else {
		_sign = 0;
		return;
	}
	var _xy = get_direction_dxdy(_dir, 32);
	for (var i = 1; i < _id.connected_distance; i++) {
		draw_sprite_ext(spr_rail_line, 0, _id.x + _xy[0] * _sign * i, _id.y + _xy[1] * _sign * i, 1, 1, _id.image_angle, c_white, 1);
	}
}

function draw_item_array(_array, init_x, init_y) {
	var _str;
	var _num = array_length(_array);
	var dx = 0;
	draw_sprite(spr_brakets, 0, init_x + dx, init_y);
	dx += 16;
	if (_num == 0) {
		dx += 8;
	}
	else {
		for (var i = 0; i < _num; i++) {
			_str = _array[i];
			draw_sprite_ext(_str.type.spr, 0, init_x + dx,init_y, 1, 1, 0, c_white, 0.3);
			draw_sprite_part(_str.type.spr, 0, 0, 0, 16, 16 * _str.time / _str.time_max, init_x + dx - 8,init_y - 8);
			dx += 18;
		}
	}
	draw_sprite(spr_brakets, 1, init_x + dx, init_y);
}