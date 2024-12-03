/// @description Insert description here
// You can write your code in this editor
var _dx, _num, _dy;
set_cur_array();
draw_self();
switch (cur_state) {
	case State.FACTORY : 
		_dx = xstart;
		_dy = obj_make_manager.buil_ui_y + 16;
		_num = array_length(cur_array);
		for (var i = 0; i < _num; i++) {
			if (global.factory_array_index == i){
				draw_sprite(spr_fac_2x2_glow, 0, _dx, _dy);	
			}
			draw_sprite(cur_array[i].spr, 0, _dx, _dy);
			_dx += sprite_get_width(cur_array[i].spr) + 10;	
		}
		break;
	case State.RAIL :
		_dx = xstart;
		_dy = obj_make_manager.buil_ui_y + 32;
		_num = array_length(cur_array);
		var _spr;
		for (var i = 0; i < _num; i++) {
			if (global.rail_array_index == i){
				draw_sprite(spr_fac_1x1_glow, 0, _dx, _dy);	
			}
			_spr = cur_array[i].spr;
			draw_sprite(_spr, 0, _dx, _dy);
			_dx += sprite_get_width(_spr) + 10;	
		}
		break;
	case State.GENERATOR : 
		_dx = xstart - 16;
		_dy = obj_make_manager.buil_ui_y + 40;
		_num = array_length(cur_array);
		var _xoffset, _yoffset, _width, _height, _spr;
		for (var i = 0; i < _num; i++) {
			_spr = cur_array[i].spr;
			_xoffset = sprite_get_xoffset(_spr);
			_yoffset = sprite_get_yoffset(_spr);
			_width = sprite_get_width(_spr)
			_height = sprite_get_height(_spr)
			draw_sprite(_spr, 0, _dx + _xoffset, _dy + _yoffset - _height / 2);
			if (global.generator_array_index == i){
				draw_sprite(get_glowspr(_width, _height), 0, _dx + _xoffset, _dy + _yoffset - _height / 2);	
			}
			_dx += _width + 10;	
		}	
		break;
}	
		draw_sprite(spr_cursor, 0, mouse_x, mouse_y);