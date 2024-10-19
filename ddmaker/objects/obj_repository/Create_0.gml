/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
item_array = [];
repository_limit = 100;
item_hash = {};

function item_stock(num, _type) constructor {
	number = num;
	type = _type;
}

function add_item(_item) {
	array_push(item_array, _item);
	if (struct_exists_from_hash(item_hash, _item.hash)) {
		var _str = struct_get_from_hash(item_hash, _item.hash);
		_str.number += 1;
	}
	else {
		struct_set_from_hash(item_hash, _item.hash, new item_stock(1 , _item));
	}
}


function is_array_below_limit() {
	return array_length(item_array) < repository_limit;
}