/// @description Insert description here
// You can write your code in this editor
image_index = item_maked;
if (item_maked) {
	
}
else {
	item_extract_time++;
	if (item_extract_time >= item_extract_max_time) {
		item_extract_max_time -= item_extract_time;
		item_maked = true;
	}
}