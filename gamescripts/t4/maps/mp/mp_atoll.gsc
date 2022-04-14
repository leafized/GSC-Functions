main()
{
	maps\mp\createart\mp_atoll_art::main();

	//maps\mp\mp_atoll_fx::main();

	maps\mp\_load::main();
	

	// maps\mp\mp_atoll_amb::main();

	// uncomment this when you have your own mini-map for this map
	maps\mp\_compass::setupMiniMap("compass_map_mp_atoll");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "marines";
	game["axis"] = "japanese";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "pacific";
	game["axis_soldiertype"] = "pacific";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
//	setdvar( "useUnifiedSpawning", "1" );

}
