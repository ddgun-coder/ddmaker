/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
item_array = [];
repository_limit = 100;

function is_array_below_limit() {
	return array_length(item_array) < repository_limit;
}