/// @description Insert description here
// You can write your code in this editor
if (obj_making) {
	making_process++;
	image_blend = merge_color(c_white, c_red, making_process/making_process_max);
	if (making_process >= making_process_max) {
		making_process -= making_process_max;
		make_output();
	}	
}
else {
	image_blend = c_white;	
}

/*
if (output_number > 0) {
	check_linked_obj(output_tile_x, output_tile_y);
	if (is_linked) {
		extract_obj();
	}
}