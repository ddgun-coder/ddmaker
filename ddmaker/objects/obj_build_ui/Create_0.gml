/// @description Insert description here
// You can write your code in this editor
image_xscale = 5;
cur_index = array_get_index(global.factory_array, obj_make_manager.obj_factory_id);
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