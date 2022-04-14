main()
{
	//maps\mp\createart\mp_downfall_art::main();

	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_downfall");
	
	//maps\mp\mp_downfall_fx::main();


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

}
