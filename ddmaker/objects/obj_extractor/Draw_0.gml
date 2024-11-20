/// @description Insert description here
// You can write your code in this editor
draw_self();
if (item_type != noone) {
	if (!item_maked) {
		draw_set_alpha(0.5);
	}
	draw_sprite(item_type.spr, 0, x, y);
	draw_set_alpha(1);
}
