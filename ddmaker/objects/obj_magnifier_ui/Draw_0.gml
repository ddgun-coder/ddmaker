/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(image_alpha);
draw_self();
var _id = obj_make_manager.current_obj_id
if (_id == noone or !instance_exists(_id)) {
	draw_set_alpha(1);	
	exit;
}

var _switch_obj = noone;

var _spr = noone;
if (_id.object_index == obj_factory) {
	_spr = _id.obj_factory_id.show_spr;
}
else {
	_spr = _id.sprite_index;	
}

var _draw_x = x + 64;
var _draw_y = y + 64;

draw_sprite_ext(_spr, _id.image_index, _draw_x, _draw_y, _id.image_xscale, _id.image_yscale, _id.image_angle, _id.image_blend, image_alpha);
switch (_id.object_index) {
	case obj_rail :
		var _dxy;
		if (_id.output_number <= 1) {
			for (var i = 0; i < 4; i++) {
				_dxy = get_direction_dxdy(i);
				draw_sprite(spr_rail_check_ui, _id.way[i], _draw_x + _dxy[0], _draw_y + _dxy[1]);
			}
		}
		else {
			var _cur_dir = _id.get_cur_output_direction();
			for (var i = 0; i < 4; i++) {
				_dxy = get_direction_dxdy(i);
				if (_id.way[i] == Way.OUTPUT) {
					draw_sprite(spr_rail_cur_output_ui, i != _cur_dir, _draw_x + _dxy[0], _draw_y + _dxy[1]);	
				}
				else {
					draw_sprite(spr_rail_check_ui, _id.way[i], _draw_x + _dxy[0], _draw_y + _dxy[1]);	
				}
			}	
		}
		break;
	case obj_repository :
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle)
		draw_text(_draw_x, _draw_y + 24, string("{0} / {1}", _id.repository_limit, array_length(_id.item_array)));
		var _str;
		with (_id) {
			var _names = struct_get_names(item_hash);
			var _num = array_length(_names);
			for (var i = 0; i < _num; i++) {
				_str = item_hash[$ _names[i]];
				draw_sprite(_str.type.spr, 0, _draw_x - 32, _draw_y + 64 + i * 16);
				draw_text(_draw_x, _draw_y + 64 + i * 16, string(" : {0}", _str.number));
			}
		}
		break;
	case obj_factory :
		var _str = _id.obj_factory_id;
		var _tilex = 0;
		var _tiley = 0;
		
		for (var i = 0; i < _str.width; i++) {
			for (var j = 0; j < _str.height; j++) {
				_tilex = _draw_x + (i - 1) * 32 + 16;
				_tiley = _draw_y + (j - 1) * 32 + 16;
				if (_str.is_output_index(i, j)) {
					draw_sprite(spr_rail_check_ui, 2, _tilex, _tiley);
				}
				else if(_str.is_input_index(i, j)) {
					draw_sprite(spr_rail_check_ui, 1, _tilex, _tiley);
				}
				else {
					draw_sprite(spr_rail_check_ui, 0, _tilex, _tiley);
				}
			}
		}
		break;
}
draw_set_alpha(1);