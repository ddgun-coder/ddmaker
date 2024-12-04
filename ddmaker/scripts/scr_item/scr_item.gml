// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Rail(spr, show_spr, obj, is_output) constructor {
	self.spr = spr;
	self.show_spr = show_spr;
	self.obj = obj;
	self.io = is_output;
	array_push(global.rail_array, self);
}

function create_item(_x, _y, _depth, _dir, _next_tile_id, _item_type) {
	_id = instance_create_depth(_x, _y, _depth, obj_box);
	_id.direct = _dir;
	_id.set_next_tile(id);
	_id.item_type = _item_type;
	_id.sprite_index = _id.item_type.spr;
}

global.factory_array = [];
global.generator_array = [];
global.rail_array = [];
global.factory_array_index = 0;
global.rail_array_index = 0;
global.generator_array_index = 0;
new Rail(spr_one_way_rail, spr_one_way_rail_show, obj_rail, Io.BOTH);
new Rail(spr_rail_input, spr_rail_input_show, obj_rail_input, Io.INPUT);
new Rail(spr_rail_output, spr_rail_output_show, obj_rail_output, Io.OUTPUT);
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
global.coal = new Item(spr_coal, "coal");

function get_frame_spr(_width, _height) {
	if (_width == 2 and _height == 2) {
		return 	spr_furniture_fac_frame2x2;
	}
	if (_width == 3 and _height == 3) {
		return 	spr_furniture_fac_frame3x3;
	}
}

function Facility(spr, input_item, output_item, name, input_index, output_index, _origin_index = [0, 0]) constructor  {
	self.spr = spr;
	self.input_item = input_item;
	self.output_item = output_item;
	hash = variable_get_hash(name);
	self.input_index = input_index;
	self.output_index = output_index;
	width = floor(sprite_get_width(spr) / 32);
	height = floor(sprite_get_height(spr) / 32);
	show_spr = get_frame_spr(width, height);
	origin_index = _origin_index;
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
	function get_index_IO(_x, _y) {
		if (is_output_index(_x, _y)) return Io.OUTPUT;
		if (is_input_index(_x, _y)) return Io.INPUT;
		return noone;
	}
	function get_origin_array_spin(_angle) {
		_result = [];
		switch (_angle) {
			case 0:	
				_result[0] = origin_index[0];
				_result[1] = origin_index[1];
				break;
			case 90:
				_result[0] = origin_index[1];
				_result[1] = width - origin_index[0] - 1;
				break;
			case 180:	
				_result[0] = width - origin_index[0] - 1;
				_result[1] = height - origin_index[1] - 1;
				break;
			case 270	:	
				_result[0] = height - origin_index[1] - 1; 
				_result[1] = origin_index[0];
				break;
		
		}
		return _result;
	}
}

function Generator(spr, input_item, output_item, name, input_index, output_index, _origin_index = [0, 0]) : Facility(spr, input_item, output_item, name, input_index, output_index, _origin_index) constructor {
	array_push(global.generator_array, self);
}

function Factory(spr, input_item, output_item, name, input_index, output_index, _origin_index = [0, 0]) : Facility(spr, input_item, output_item, name, input_index, output_index, _origin_index) constructor  {
	array_push(global.factory_array, self);
}

global.furniture_factory = new Factory(spr_furniture_fac, [global.wood, global.wood], [global.furniture], "furniture_factory", [0, 1], [1, 1]);
global.furniture_factory2 = new Factory(spr_furniture_fac2, [global.furniture, global.wool, global.wool, global.wool], [global.furniture2], "furniture_factory2", [0, 0], [1, 1]);
global.coal_generator = new Generator(spr_coal_generator_small, [global.coal], [], "coal_generator", [0, 1], []);
global.coal_generator_big = new Generator(spr_coal_generator_big, [global.coal, global.coal, global.coal], [], "coal_generator", [0, 1], []);
