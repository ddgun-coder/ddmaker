/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(image_alpha);
draw_self();
var _id = obj_make_manager.current_obj_id
var _draw_x = x + 64;
var _draw_y = y + 64;
if (_id != noone and instance_exists(_id)) {
	draw_sprite_ext(_id.sprite_index, _id.image_index, _draw_x, _draw_y, _id.image_xscale, _id.image_yscale, _id.image_angle, _id.image_blend, image_alpha);
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
	}
}
draw_set_alpha(1);