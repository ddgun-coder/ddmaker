// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.electric_network_array = [];
function electric_network() constructor {
	ids = [];
	array_push(global.electric_network_array, self);
	
	function add_network(_network_array) {
		var _num = array_length(_network_array);
		for (var i = 0; i < _num; i++) {
				
		}
	}
	
	function get_rand_hsv() {
		var _num = array_length(global.electric_network_array)
		if (_num == 1) return make_color_hsv(irandom(255), irandom_range(255 * 0.7, 255), irandom_range(255 * 0.8, 255));
		var valid = false;
		var check, new_color, hue, saturation, brightness;
		while (!valid) {
			hue = irandom(255);                 // 0~360 랜덤 Hue
	        saturation = irandom_range(255 * 0.7, 255); // 채도 0.7~1.0
	        brightness = irandom_range(255 * 0.8, 255);
		
			new_color = make_color_hsv(hue, saturation, brightness);
			check = false;
	        for (var j = 0; j < _num; j++) {
	            if (color_distance(new_color, global.electric_network_array[j].my_color) < 30) {
					check = true;
	                break;
	            }
			}
			if (!check) return new_color;
        }
	}
	
	function color_distance(color1, color2) {
		var r1 = color_get_red(color1);
	    var g1 = color_get_green(color1);
	    var b1 = color_get_blue(color1);

	    var r2 = color_get_red(color2);
	    var g2 = color_get_green(color2);
	    var b2 = color_get_blue(color2);

	    return sqrt(sqr(r1 - r2) + sqr(g1 - g2) + sqr(b1 - b2));
	}
	
	my_color = c_black;
	my_color = get_rand_hsv();
}
