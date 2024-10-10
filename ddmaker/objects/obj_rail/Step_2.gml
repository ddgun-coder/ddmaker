/// @description Insert description here
// You can write your code in this editor

if (is_opposite_input) {
	if (box_is_out) {
		var _dir = get_cur_input();
		var _bool = _dir != noone 
			and opposite_array[_dir] != noone 
			and opposite_array[_dir].opposite_in
		if (_bool) {
			var _box_id = opposite_array[_dir];
			_box_id.opposite_in = false;
			_box_id.direct = _dir;
			_box_id.set_next_tile(id, true);
			box_is_out = false;
		}
	}
}