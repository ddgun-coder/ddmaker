/// @description Insert description here
// You can write your code in this editor
linked_obj = [noone, noone, noone, noone];

function check_linked_obj() {
	with (obj_abs_component) {
		if (collision_point(x + 32, y, id, false, false)) {
			linked_obj[Direct.RIGHT] = id;
			break;
		}
	}
	with (obj_abs_component) {
		if (collision_point(x - 32, y, id, false, false)) {
			linked_obj[Direct.LEFT] = id;
			break;
		}
	}
	with (obj_abs_component) {
		if (collision_point(x, y + 32, id, false, false)) {
			linked_obj[Direct.DOWN] = id;
			break;
		}
	}
	with (obj_abs_component) {
		if (collision_point(x, y - 32, id, false, false)) {
			linked_obj[Direct.UP] = id;
			break;
		}
	}
}