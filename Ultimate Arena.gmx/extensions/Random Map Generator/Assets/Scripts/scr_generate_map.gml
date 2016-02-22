/* Main script to generate a map
 *
 * Arguments:
 * 0: size of the map
 * 1: featuresize
 * 2: the waterlevel
 * 3: the size of the beaches
 *
 * Returns nothing
 *
 */

width         = argument0;
height        = argument0;
featuresize   = argument1;
waterlevel    = argument2;
mountainlevel = argument3;
beachsize     = argument4;
seamless      = argument5;

// set room size
room_set_height(room_map, height * tile_size);
room_set_width(room_map, width * tile_size);
randomize();

// create heightmap
for (var i = 0; i < width; i += featuresize) {
  for (var j = 0; j < height; j += featuresize) {
    scr_set_sample(i, j, random_range(-1, 1));
  }
}

// build map
var samplesize = featuresize;
var scale = 1.0;
while (samplesize > 1) {
  scr_diamond_square(samplesize, scale);
  samplesize /= 2;
  scale /= 2.0;
}
    
// set tiles (Here you can add the tiles/terrains you want in the map)
global.grid = grid;
for (var i = 0; i < width; i += 1) {
  for (var j = 0; j < height; j += 1) {
    // tiles
    if (scr_sample(i,j) > mountainlevel)
      global.grid[i,j] = 3; // mountain
    else if (scr_sample(i,j) > waterlevel)
      global.grid[i,j] = 2; // grass
    else if (scr_sample(i,j) > waterlevel - beachsize)
      global.grid[i,j] = 1; // sand
    else
      global.grid[i,j] = 0; // water
  }
}

// create minimap surface
var surf = surface_create(512, 512);
surface_set_target(surf);

var green  = make_color_rgb( 69, 157, 69);
var blue   = make_color_rgb( 48, 102,201);
var yellow = make_color_rgb(222, 196,104);
var brown1 = make_color_rgb(164, 141, 60);
var brown2 = make_color_rgb(130, 112, 48);
var brown3 = make_color_rgb( 94,  80, 34);
var map_tile_size = (512 / width);

// give each terrain a unique color in the minimap
for (var i = 0; i < width; i += 1) {
  for (var j = 0; j < height; j += 1) {
    var point = scr_sample(i,j);
    if (point > mountainlevel + 0.4) {
      draw_set_color(brown1);
    } else if (point > mountainlevel + 0.2) {
      draw_set_color(brown2);
    } else if (point > mountainlevel) {
      draw_set_color(brown3);
    } else if (point > waterlevel) {
      draw_set_color(green);
    } else if (point > (waterlevel - beachsize)) {
      draw_set_color(yellow);
    } else {
      draw_set_color(blue);
    }
    draw_rectangle(i * map_tile_size, j * map_tile_size, (i + 1) * map_tile_size, (j + 1) * map_tile_size, false);
  }
}
surface_reset_target();

// create the minimap background 
global.bck_minimap = background_create_from_surface(surf, 0, 0, 512, 512, 0, 0);
surface_free(surf);

// go to the game room
room_goto(room_map);