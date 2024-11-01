/// @description Insert description here
// You can write your code in this editor
event_inherited();
var _id;
for (var i = 0; i < 4; i++) {
	_id = connected_output[i];
	if (instance_exists(_id) and _id.object_index == obj_rail) {
		_id.connected_input[direction_reverse(i)] = noone;
	}
	_id = connected_input[i];
	if (instance_exists(_id) and _id.object_index == obj_rail) {
		_id.connected_output[direction_reverse(i)] = noone;
	}
}