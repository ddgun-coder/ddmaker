/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(image_alpha);
draw_self();
var _id = obj_make_manager.current_obj_id
if (!instance_exists(_id) or obj_make_manager.make_state != State.WAY_MAGNIFIER) {
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
var _draw_y = y + 48;

draw_sprite_ext(_spr, _id.image_index, _draw_x, _draw_y, _id.image_xscale, _id.image_yscale, _id.image_angle, _id.image_blend, image_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
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
		draw_text(_draw_x, _draw_y + 24, string("{0} / {1}", _id.repository_limit, array_length(_id.item_array)));
		draw_stock(_id.item_hash, _draw_x, _draw_y + 64);
		break;
	case obj_factory :
		var _str = _id.obj_factory_id;
		var _tilex = 0;
		var _tiley = 0;
		
		for (var i = 0; i < _str.width; i++) {
			for (var j = 0; j < _str.height; j++) {
				_tilex = _draw_x + (i - 1) * 32 + 16;
				_tiley = _draw_y + (j - 1) * 32 + 16;
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
		draw_sprite(spr_need, 0,_draw_x, _draw_y + 48);
		draw_stock(_id.need_item_stock, _draw_x, _draw_y + 64);
		draw_sprite(spr_cur, 0, _draw_x, _draw_y + 112);
		draw_stock(_id.cur_item_stock, _draw_x, _draw_y + 128);
		break;
	case obj_rail_input :
		if (!instance_exists(_id.connected_rail_id)) break;
		draw_rail_connection(_id);
		draw_item_array(_id.item_queue_ready, x + 8, _draw_y + 48);
		break;
	case obj_rail_output :
		if (!instance_exists(_id.connected_rail_id)) break;
		draw_rail_connection(_id);
		draw_item_array(_id.connected_rail_id.item_queue_ready, x + 8, _draw_y + 48);
		break;
}
draw_set_alpha(1);