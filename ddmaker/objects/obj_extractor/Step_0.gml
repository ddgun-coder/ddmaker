/// @description Insert description here
// You can write your code in this editor
image_index = item_maked;
if (item_maked) {
	if (is_linked) {
		extract_obj();
	}
	else {
		check_linked_obj();
	}
}
else {
	item_extract_time++;
	if (item_extract_time >= item_extract_max_time) {
		item_extract_time -= item_extract_max_time;
		item_maked = true;
	}
}