

#include maps\_utility;

// main function for handeling Snipe_geo
main()
{
	setVolFog(8000, 11000, 8000, 17000, 100/255, 100/255, 100/255, 1);

	level.campaign = "russian";
	
	maps\_load::main();
	wait_for_first_player();
	visionsetnaked("Sniper_default", 1);
}