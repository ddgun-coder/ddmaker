/// @description Insert description here
// You can write your code in this editor
if (!instance_exists(obj_make_manager)) {
	visible = false;
	exit;
}
else {
	visible = true;	
}

if (keyboard_check_pressed(ord("E"))) {
	set_next_item();
}

if (obj_make_manager.make_state != State.NONE) cur_state = obj_make_manager.make_state;
set_cur_array();
x = xstart;
y = obj_make_manager.buil_ui_y;



var display_x =	device_mouse_x_to_gui(0);
var display_y = device_mouse_y_to_gui(0);
if (mouse_check_button_pressed(mb_left) and position_meeting(display_x, display_y, id)) {
	set_tile(display_x);
}