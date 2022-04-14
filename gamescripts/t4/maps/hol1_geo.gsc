#include maps\_utility;
main()
{
	maps\_load::main();


	// fog and culling parameters
	level.fog_r = 0.375;
	level.fog_g = 0.408;
	level.fog_b = 0.389;
	
	level.fog_normal_near = 0;
	level.fog_normal_mid = 800;
	level.fog_normal_height = 600;

	level.cull_distance = 5000;


	// set fog
	setVolFog( level.fog_normal_near, level.fog_normal_mid, level.fog_normal_height, 0, level.fog_r, level.fog_g, level.fog_b, 2 );  

	// set culling
	setculldist( level.cull_distance );
}