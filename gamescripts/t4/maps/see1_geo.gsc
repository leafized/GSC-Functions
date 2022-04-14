

////////////////////////// Seelow 1 ////////////////////////////
////////////////////////////////////////////////////////////////
/* 

Scripter: Alex Liu
Builder: Jason Schoonover

*/
////////////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;



main()
{
	maps\createart\see1_art::main();
	thread maps\see1_fx::vision_settings();

	maps\_destructible_opel_blitz::init();

	maps\_load::main();	
}
