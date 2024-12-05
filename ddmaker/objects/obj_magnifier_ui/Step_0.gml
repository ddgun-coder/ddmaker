/// @description Insert description here
// You can write your code in this editor
if (!instance_exists(obj_make_manager)) {
	exit;
}
x = mouse_x;
y = mouse_y - sprite_get_height(sprite_index) - 15;

if (obj_make_manager.make_state == State.WAY_MAGNIFIER) {
	image_alpha = min(1, obj_make_manager.magnifier_time / 40);	
}
else {
	image_alpha = 0;
}