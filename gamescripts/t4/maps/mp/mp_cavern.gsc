#include common_scripts\utility;
#include maps\mp\_utility;
main()
{
	level.scr_sound["elevator_start"] = "elevator_start";
	level.scr_sound["elevator_loop"] = "elevator_loop";
	level.scr_sound["elevator_end"] = "elevator_end";
	
	//needs to be first for create fx
	maps\mp\mp_cavern_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_cavern_amb::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_cavern");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
}