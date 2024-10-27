/// @description Insert description here
// You can write your code in this editor
image_alpha = 0;

function draw_stock(_str, _draw_x, _draw_y) {
	var _names = struct_get_names(_str);
	var _num = array_length(_names);
	for (var i = 0; i < _num; i++) {
		_item_str = _str[$ _names[i]];
		draw_sprite(_item_str.type.spr, 0, _draw_x - 32, _draw_y + i * 16);
		draw_text(_draw_x, _draw_y + i * 16, string(" : {0}", _item_str.number));
	}
}