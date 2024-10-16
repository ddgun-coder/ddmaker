/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
item_array = [];
repository_limit = 100;
item_hash = {};

function a(num, _type) constructor {
	number = num;
	type = _type;
}

function add_item(_item) {
	array_push(item_array, _item);
	if (struct_exists_from_hash(item_hash, _item.hash)) {
		item_hash[$ _item.item_name].number += 1;
	}
	else {
		item_hash[$ _item.item_name] = new a(1 , _item);
	}
}


function is_array_below_limit() {
	return array_length(item_array) < repository_limit;
}