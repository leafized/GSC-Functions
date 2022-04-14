main()
{
	// maps\mp\mp_broadside_fx::main();

	maps\mp\_load::main();
	
	// maps\mp\mp_broadside_amb::main();

	// maps\mp\_compass::setupMiniMap("compass_map_mp_broadside");

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
