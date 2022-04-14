main()
{	
	//maps\mp\mp_brandenburg_fx::main();

	precachemodel("collision_geo_128x128x128");

	maps\mp\_load::main();

	//maps\mp\mp_brandenburg_amb::main();

	//maps\mp\_compass::setupMiniMap("compass_map_mp_brandenburg");
		
	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "german";
	game["axis_soldiertype"] = "german";

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_brandenburg_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_brandenburg_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_brandenburg_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_brandenburg_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_brandenburg_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_brandenburg_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_brandenburg_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_brandenburg_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_brandenburg_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_brandenburg_E";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2100");
	
	spawncollision("collision_geo_128x128x128","collider",(2964, 9470, -113), (0, 348.6, 0));

	// enable new player spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);

}
