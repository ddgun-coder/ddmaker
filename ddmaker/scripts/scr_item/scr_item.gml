// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Rail(spr, show_spr, obj) constructor {
	self.spr = spr;
	self.show_spr = show_spr;
	self.obj = obj;
	array_push(global.rail_array, self);
}

function create_item(_x, _y, _depth, _dir, _next_tile_id, _item_type) {
	_id = instance_create_depth(_x, _y, _depth, obj_box);
	_id.direct = _dir;
	_id.set_next_tile(id);
	_id.item_type = other.item_type;
	_id.sprite_index = _id.item_type.spr;
}

global.factory_array = [];
global.rail_array = [];
new Rail(spr_one_way_rail, spr_one_way_rail_show, obj_rail);
new Rail(spr_rail_input, spr_rail_input_show, obj_rail_input);
new Rail(spr_rail_output, spr_rail_output_show, obj_rail_output);
function Item(spr, item_name) constructor  {
	self.spr = spr;
	self.item_name = item_name;
	hash = variable_get_hash(item_name);
}

global.wood = new Item(spr_wood, "wood");
global.box = new Item(spr_box, "box");
global.wool = new Item(spr_wool, "wool");
global.furniture = new Item(spr_furniture, "furniture");
global.furniture2 = new Item(spr_furniture2, "furniture2");

function Factory(spr, input_item, output_item, name, input_index, output_index, _show_spr = noone) constructor  {
	self.spr = spr;
	if (_show_spr == noone) {
		show_spr = asset_get_index(sprite_get_name(spr) + "_frame");
	}
	else {
		show_spr = _show_spr;	
	}
	self.input_item = input_item;
	self.output_item = output_item;
	hash = variable_get_hash(name);
	self.input_index = input_index;
	self.output_index = output_index;
	width = floor(sprite_get_width(spr) / 32);
	height = floor(sprite_get_height(spr) / 32);
	array_push(global.factory_array, self);
	function is_output_index(_x, _y) {
		if (is_array(output_index[0])) {
			
		}	
		else {
			if (_x == output_index[0] and _y == output_index[1]) {
				return true;
			}
		}
		
		return false;
	}
	function is_input_index(_x, _y) {
		if (is_array(input_index[0])) {
			
		}	
		else {
			if (_x == input_index[0] and _y == input_index[1]) {
				return true;
			}
		}
		
		return false;
	}
	function get_tile_IO(_x, _y) {
		if (is_output_index(_x, _y)) return Io.OUTPUT;
		if (is_input_index(_x, _y)) return Io.INPUT;
		return noone;
	}
}

global.furniture_factory = new Factory(spr_furniture_fac, [global.wood, global.wood], [global.furniture], "furniture_factory", [0, 1], [1, 1]);
global.furniture_factory2 = new Factory(spr_furniture_fac2, [global.furniture, global.wool, global.wool, global.wool], [global.furniture2], "furniture_factory2", [0, 0], [1, 1], spr_furniture_fac_frame);