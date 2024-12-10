/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;

function direction_to_bit(_way_array) {
	var bit = 0;
	for (var i = 0; i < 4; i++) {
		if (_way_array[i] != noone) {
			_way_array[i] = true;
		}
		else {
			_way_array[i] = false;
		}
        // (3 - i)만큼 비트를 이동하고 bit_value에 추가
        bit |= _way_array[i] << (3 - i);
	}
	return bit;
}
/*
function set_spr(_way_array) {
	var sprite_array = [
	    sprite_0000, sprite_0001, sprite_0010, sprite_0011,
	    sprite_0100, sprite_0101, sprite_0110, sprite_0111,
	    sprite_1000, sprite_1001, sprite_1010, sprite_1011,
	    sprite_1100, sprite_1101, sprite_1110, sprite_1111
	];
	return sprite_array[direction_to_bit(_way_array)];
}	
*/
image_index = direction_to_bit(linked_obj);