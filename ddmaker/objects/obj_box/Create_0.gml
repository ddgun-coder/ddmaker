/// @description Insert description here
// You can write your code in this editor
direct = Direct.NONE;
next_tile = noone;
next_tile_x = 0;
next_tile_y = 0;
image_speed = 0;

function set_next_tile(_id) {
	next_tile = _id;
	if (_id == noone) return;
	
	next_tile_x = _id.x;
	next_tile_y = _id.y;
}