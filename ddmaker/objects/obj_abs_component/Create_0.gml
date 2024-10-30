/// @description Insert description here
// You can write your code in this editor
linked_obj = [noone, noone, noone, noone];
is_linked = true;
way_number = 4;
linked_number = 0;
direction_index = Direct.NONE;

function check_linked_obj(_x = x, _y = y) {
	var _id = noone;
	
	linked_obj[Direct.RIGHT] = collision_point(_x + 32, _y, obj_abs_component, false, true);
	linked_obj[Direct.LEFT] = collision_point(_x - 32, _y, obj_abs_component, false, true);
	linked_obj[Direct.DOWN] = collision_point(_x, _y + 32, obj_abs_component, false, true);
	linked_obj[Direct.UP] = collision_point(_x, _y - 32, obj_abs_component, false, true);
	check_is_linked();
}

function verify_linked_obj() {
	for (var i = 0; i < 4; i++) {
		if (!instance_exists(linked_obj[i])) {
			linked_obj[i] = noone;
		}
	}
}

function check_is_linked() {
	linked_number = 0;
	for (var i = 0; i < way_number; i++) {
		if (linked_obj[i] != noone) {
			linked_number++;
		}
	}
	is_linked = linked_number > 0
}

check_linked_obj();