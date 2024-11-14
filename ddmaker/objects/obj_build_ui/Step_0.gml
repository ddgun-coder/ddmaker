/// @description Insert description here
// You can write your code in this editor
if (!instance_exists(obj_make_manager)) {
	visible = false;
	exit;
}
else {
	visible = true;	
}

if (obj_make_manager.make_state != State.NONE) cur_state = obj_make_manager.make_state;
set_cur_array();
x = camera_get_view_x(view_camera[0]) + xstart;
y = obj_make_manager.buil_ui_y + camera_get_view_y(view_camera[0]);

if (mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id)) {
	var _dx;
	var _cur_index;
	_dx = floor((mouse_x - x + 16) / (spr_width + 10));
	if (0 <= _dx and _dx < array_length(cur_array)) {
		_cur_index = _dx;
		switch (obj_make_manager.make_state) {
			case State.FACTORY :
				global.factory_array_index = _dx;
				obj_make_manager.obj_factory_id = cur_array[_cur_index];
				break;
			case State.RAIL :
				global.rail_array_index = _dx;
				obj_make_manager.rail_index = cur_array[_cur_index];
				break;
		}
	}
}