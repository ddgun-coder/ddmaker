/// @description Insert description here
// You can write your code in this editor
if (!instance_exists(connected_rail_id)) connected_rail_id = noone;
var _num = array_length(item_queue_ready);
for (var i = 0; i < _num; i++) {
	item_queue_ready[i].add_time();
}