/// @description Insert description here
// You can write your code in this editor

if (fuel_tank > 0 and electric_cap > electric + fuel_item_type.fuel_efficiency * fuel_speed) {
	fuel_tank -= fuel_speed;
	electric += fuel_item_type.fuel_efficiency * fuel_speed;
}

alarm[0] = 8;