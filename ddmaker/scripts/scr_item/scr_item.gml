// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Item(spr, item_name) constructor  {
	self.spr = spr;
	self.item_name = item_name;
	hash = variable_get_hash(item_name);
}

global.wood = new Item(spr_wood, "wood");
global.box = new Item(spr_box, "box");
global.wool = new Item(spr_wool, "wool");
global.furniture = new Item(spr_furniture, "furniture");

function Factory(spr, input_item, output_item, name, input_index, output_index, obj_facetory_index) constructor  {
	self.spr = spr;
	self.input_item = input_item;
	self.output_item = output_item;
	hash = variable_get_hash(name);
	self.input_index = input_index;
	self.output_index = output_index;
	self.obj_facetory_index = obj_facetory_index;
	width = floor(sprite_get_width(spr) / 32);
	height = floor(sprite_get_height(spr) / 32);
}

global.furniture_factory = new Factory(spr_furniture_fac, [global.wood, global.wood], [global.furniture], "furniture_factory", [0, 1], [1, 1], obj_furniture_fac);