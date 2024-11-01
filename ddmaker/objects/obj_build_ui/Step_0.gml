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
show_debug_message(cur_state);
y = obj_make_manager.buil_ui_y;

if (mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id)) {
	var _dx;
	_dx = floor((mouse_x - x) / (spr_width + 10));
	if (0 <= _dx and _dx < array_length(cur_array)) {
		cur_index = _dx;
		switch (obj_make_manager.make_state) {
			case State.FACTORY :
				obj_make_manager.obj_factory_id = cur_array[cur_index];
				break;
			case State.RAIL :
				obj_make_manager.rail_index = cur_array[cur_index];
				break;
		}
	}
}