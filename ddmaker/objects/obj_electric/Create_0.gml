/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;
network = noone;

function direction_to_bit(_way_array) {
	var bit = 0;
	var _val = 0;
	for (var i = 0; i < 4; i++) {
		if (_way_array[i] != noone and _way_array[i].object_index == obj_electric) {
			_val = 1;
		}
		else {
			_val = 0;
		}
        // (3 - i)만큼 비트를 이동하고 bit_value에 추가
        bit |= _val << (3 - i);
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

function init_connection() {
	check_linked_obj();
	for (var i = 0; i < 4; i++) {
		if (instance_exists(linked_obj[i])) {
			with (linked_obj[i]) {
				check_linked_obj();
				image_index = direction_to_bit(linked_obj);
			}
		}
	}
	image_index = direction_to_bit(linked_obj);
	if (linked_number == 0) {
		network = new electric_network();
		image_blend = network.my_color;
	}
}

function set_network_recursion() {
	var new_network = new electric_network();
	network = new_network;
	image_blend = network.my_color;
	
	set_network(network);
}

function set_network(newtwork) {
	for (var i = 0; i < 4; i++) {
		if (instance_exists(linked_obj[i]) and linked_obj[i].object_index == obj_electric and linked_obj[i].network == noone) {
			with (linked_obj[i]) {
				network = newtwork;
				image_blend = network.my_color;
				set_network(newtwork);
			}
		}
	}
}

init_connection();
alarm[0] = 1;