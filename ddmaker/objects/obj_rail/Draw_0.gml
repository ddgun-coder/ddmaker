/// @description Insert description here
// You can write your code in this editor
draw_self();

if (is_opposite_input) {
	draw_text(x - 64, y - 64, string("box_is_out : {0}", box_is_out));	
	draw_text(x - 64, y - 84, string("opened_opposite_input : {0}", opened_opposite_input));	
}