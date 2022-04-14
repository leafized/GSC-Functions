main()
{
	// fix this when you have your own fx loops
	// maps\mp\mp_wetlands_fx::main();
	
//	maps\see1_fx::main();		// must be before _load::main
	maps\mp\_load::main();
	
	// maps\mp\mp_wetlands_amb::main();

	// uncomment this when you have your own mini-map for this map
	maps\mp\_compass::setupMiniMap("compass_map_mp_wetlands");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");

	setVolFog(1100, 4100, 1360, -448, 0.62, 0.59, 0.52, 0);
}
