#include common_scripts\utility; 
#include maps\_utility;
main()
{
	maps\_destructible_opel_blitz::init();
	maps\_destructible_type94truck::init();
	maps\_zombiemode::main();
	
	splitscreen_fog_setup();
	
		
}

//splitscreen fog
splitscreen_fog_setup()
{
	if( IsSplitScreen() )
	{
		start_dist = 700;
		halfway_dist = 2000;
		halfway_height = 10000;
		cull_dist = 2000;
		base_height = 0;
		red = 0.115;
		green = 0.123;
		blue = 0.141;
		trans_time = 0;

		cull_dist = 2000;
		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
}

