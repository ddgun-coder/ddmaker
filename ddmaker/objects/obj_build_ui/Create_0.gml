/// @description Insert description here
// You can write your code in this editor
image_xscale = 5;
cur_array = [];
spr_width = 64;
cur_state = State.NONE;
function set_cur_array() {
	switch (cur_state) {
		case State.FACTORY :
			cur_array = global.factory_array;
			spr_width = 64;
			break;	
		case State.RAIL :
			cur_array = global.rail_array;
			spr_width = 32;	
			break;
	}	
}

function set_next_item() {
	var _num = array_length(cur_array);
	switch (obj_make_manager.make_state) {
		case State.FACTORY :
			global.factory_array_index = (global.factory_array_index + 1) mod _num;
			obj_make_manager.obj_factory_id = cur_array[global.factory_array_index];
			break;
		case State.RAIL :
			global.rail_array_index = (global.rail_array_index + 1) mod _num;
			obj_make_manager.rail_index = cur_array[global.rail_array_index];
			break;
	}	
}