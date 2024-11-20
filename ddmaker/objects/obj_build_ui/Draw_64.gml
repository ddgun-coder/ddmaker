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
}	