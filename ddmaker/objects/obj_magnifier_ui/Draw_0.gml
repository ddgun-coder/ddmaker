/// @description Insert description here
// You can write your code in this editor
draw_set_alpha(image_alpha);
draw_self();
var _id =obj_make_manager.current_obj_id
var _draw_x = x + 64;
var _draw_y = y + 64;
if (_id != noone) {
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
	}
}
draw_set_alpha(1);