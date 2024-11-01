/// @description Insert description here
// You can write your code in this editor
if (obj_make_manager.make_state == State.FACTORY) {
	var _dx = x;
	var num = array_length(global.factory_array);
	draw_self();
	for (var i = 0; i < num; i++) {
		if (obj_make_manager.obj_factory_id == global.factory_array[i]){
			draw_sprite(spr_fac_2x2_glow, 0, _dx, y);	
		}
		draw_sprite(global.factory_array[i].spr, 0, _dx, y);
		_dx += sprite_get_width(global.factory_array[i].spr) + 10;	
	}
}