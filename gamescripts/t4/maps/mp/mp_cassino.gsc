
main()
{
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_temp");
	
	game["allies"] = "russian";
	game["axis"] = "german";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "russian";
	game["axis_soldiertype"] = "german";
	
	
}