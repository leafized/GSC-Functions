main()
{
	//maps\mp\mp_struggle_fx::main();

	maps\mp\_load::main();

	//maps\mp\mp_struggle_amb::main();
	
	//maps\mp\_compass::setupMiniMap("compass_map_mp_struggle");
	
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
}
