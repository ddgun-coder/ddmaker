/// @description Insert description here
// You can write your code in this editor
if (is_item_received()) {
	check_linked_obj_one_way(output_dir);
	if (is_linked) {
		extract_obj();
	}
}