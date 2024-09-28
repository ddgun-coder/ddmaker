/// @description Insert description here
// You can write your code in this editor
linked_obj = [noone, noone, noone, noone];
is_linked = true;
way_number = 4;
linked_number = 0;
direction_index = Direct.NONE;

function check_linked_obj() {
	linked_obj[Direct.RIGHT] = instance_position(x + 32, y, obj_abs_component);
	linked_obj[Direct.LEFT] = instance_position(x - 32, y, obj_abs_component);
	linked_obj[Direct.DOWN] = instance_position(x, y + 32, obj_abs_component);
	linked_obj[Direct.UP] = instance_position(x, y - 32, obj_abs_component);
	check_is_linked();
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