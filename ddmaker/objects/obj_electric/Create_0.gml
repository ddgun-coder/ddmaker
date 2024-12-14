/// @description Insert description here
// You can write your code in this editor
event_inherited();
image_speed = 0;
network = noone;
disconnect_checker = false;

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
		set_network(new electric_network());
	}
}

function set_network_recursion() {
	var new_network = new electric_network();
	set_network(new_network);
	
	recursive_add(new_network);
}

function recursive_add(new_network) {
	for (var i = 0; i < 4; i++) {
		if (instance_exists(linked_obj[i]) and linked_obj[i].object_index == obj_electric and linked_obj[i].network == noone) {
			with (linked_obj[i]) {
				set_network(new_network);
				recursive_add(new_network);
			}
		}
	}
}

function set_network(new_network) {
	network = new_network;
	image_blend = new_network.my_color;
	array_push(new_network.ids, id);  
}

function add_electirc() {
	var check = array_create(4, false);
	var count = 0;
	for (var i = 0; i < 4; i++) {
		if (instance_exists(linked_obj[i]) and linked_obj[i].object_index == obj_electric and linked_obj[i].network != noone) {
			check[i] = true;
			count++;
		}
	}
	if (count == 0) {
		set_network(new electric_network());
	}
	else if (count == 1) {
		var _ind = array_get_index(check, true);
		set_network(linked_obj[_ind].network);
	}
	else {
		var remain_network = noone;
		var network_array = [];
		for (var i = 0; i < 4; i++) {
			if (check[i]) {
				if (remain_network == noone) {
					remain_network = linked_obj[i].network;
				}
				else {
					array_push(network_array, linked_obj[i].network);
				}
			}
		}
		remain_network.add_network(network_array);
	}	
}

function set_near_network() {
	static reset_network = function() {
		array_foreach(network.ids, function(_element, _index) {
			if (instance_exists(_element)) _element.disconnect_checker = true;
		});
		disconnect_checker = false;
	}
	
	if (network == noone) return;
	reset_network();
	
	var new_id_group;
	for (var i = 0; i < 4; i++) {
		new_id_group[i] = [];
	}
	var new_id_group_number = 0;
	for (var i = 0; i < 4; i++) {
		check_area(new_id_group[i], linked_obj[i]);
		if (array_length(new_id_group[i]) > 0) new_id_group_number++; 
	}
	//4방향 id를 조사
	
	if (new_id_group_number > 1) {
		var _num;
		var _ids, new_network;
		var count = 0;
		for (var i = 0; i < 4; i++) {
			_ids = new_id_group[i];
			if (array_length(_ids) == 0) continue;
			if (count > 0) {
				_num = array_length(_ids);
				new_network = new electric_network();
				for (var j = 0; j < _num; j++) {
					with (_ids[j]) {
						set_network(new_network);
					}
				}
			}
			else {
				network.ids = _ids;
			}
			count++;
		}
	} //2개 이상 쪼개지면 새로운 network 만들기 (첫번째는 기존으로 감)
	else if (new_id_group_number == 0) {
		var _ind = array_get_index(global.electric_network_array, network);
		array_delete(global.electric_network_array, _ind, 1);
		delete network;
	} //아무것도 없으면 해당 network 삭제
}

function check_area(_array, _id) {
	if (instance_exists(_id) and _id.object_index == obj_electric and _id.network == network and _id.disconnect_checker == true) {
		with (_id) {
			disconnect_checker = false;
			array_push(_array, id);
			for (var i = 0; i < 4; i++) {
				check_area(_array, linked_obj[i]);
			}
		}
	}
}

init_connection();
alarm[0] = 1;