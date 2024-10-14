// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Item(spr, item_name) constructor  {
	self.spr = spr;
	self.item_name = item_name;
	hash = variable_get_hash(item_name);
}

global.wood = new Item(spr_wood, "wood");
global.box = new Item(spr_box, "box");