/*
	Der Frost / Nazi Zombie Sniperbolt Tutorial Version 2.0
		Scripter: Sparks
		Tutorial: Sniperbolt

	Version 1.0 (9/24/2009 7:51:18 PM)
		-- Initial Release Of Source Files
*/

// Tutorial From Sniperbolt!

// Utilities
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
#include maps\_zombiemode_zone_manager; 
#include maps\_music;

// DLC3 Utilities
#include maps\dlc3_code;
#include maps\dlc3_teleporter;

main()
{
	level.DLC3 = spawnStruct(); // Leave This Line Or Else It Breaks Everything
	
	// Must Change These To Your Maps
	level.DLC3.createArt = maps\createart\nazi_zombie_tutorial_art::main;
	level.DLC3.createFX = maps\createfx\nazi_zombie_tutorial_fx::main;
	// level.DLC3.myFX = ::preCacheMyFX;
	
	/*--------------------
	 FX
	----------------------*/
	DLC3_FX();
	
	/*--------------------
	 LEVEL VARIABLES
	----------------------*/	
	
	// Variable Containing Helpful Text For Modders -- Don't Remove
	level.modderHelpText = [];
	
	//
	// Change Or Tweak All Of These LEVEL.DLC3 Variables Below For Your Level If You Wish
	//
	
	// Edit The Value In Mod.STR For Your Level Introscreen Place
	level.DLC3.introString = &"nazi zombie tes";
	
	// Weapons. Pointer function automatically loads weapons used in Der Riese.
	level.DLC3.weapons = maps\dlc3_code::include_weapons;
	
	// Power Ups. Pointer function automatically loads power ups used in Der Riese.
	level.DLC3.powerUps =  maps\dlc3_code::include_powerups;
	
	// Adjusts how much melee damage a player with the perk will do, needs only be set once. Stock is 1000.
	level.DLC3.perk_altMeleeDamage = 1000; 
	
	// Adjusts barrier search override. Stock is 400.
	level.DLC3.barrierSearchOverride = 400;
	
	// Adjusts power up drop max per round. Stock is 3.
	level.DLC3.powerUpDropMax = 3;
	
	// _loadout Variables
	level.DLC3.useCoopHeroes = true;
	
	// Bridge Feature
	level.DLC3.useBridge = false;
	
	// Hell Hounds
	level.DLC3.useHellHounds = true;
	
	// Mixed Rounds
	level.DLC3.useMixedRounds = true;
	
	// Magic Boxes -- The Script_Noteworthy Value Names On Purchase Trigger In Radiant
	boxArray = [];
	boxArray[ boxArray.size ] = "start_chest";
	boxArray[ boxArray.size ] = "chest1";
	boxArray[ boxArray.size ] = "chest2";
	boxArray[ boxArray.size ] = "chest3";
	boxArray[ boxArray.size ] = "chest4";
	boxArray[ boxArray.size ] = "chest5";
	level.DLC3.PandoraBoxes = boxArray;
	
	// Initial Zone(s) -- Zone(s) You Want Activated At Map Start
	zones = [];
	zones[ zones.size ] = "start_zone";
	level.DLC3.initialZones = zones;
	
	// Electricity Switch -- If False Map Will Start With Power On
	level.DLC3.useElectricSwitch = true;
	
	// Electric Traps
	level.DLC3.useElectricTraps = true;
	
	// _zombiemode_weapons Variables
	level.DLC3.usePandoraBoxLight = true;
	level.DLC3.useChestPulls = true;
	level.DLC3.useChestMoves = true;
	level.DLC3.useWeaponSpawn = true;
	level.DLC3.useGiveWeapon = true;
	
	// _zombiemode_spawner Varibles
	level.DLC3.riserZombiesGoToDoorsFirst = true;
	level.DLC3.riserZombiesInActiveZonesOnly = true;
	level.DLC3.assureNodes = true;
	
	// _zombiemode_perks Variables
	level.DLC3.perksNeedPowerOn = true;
	
	// _zombiemode_devgui Variables
	level.DLC3.powerSwitch = true;
	
	/*--------------------
	 FUNCTION CALLS - PRE _Load
	----------------------*/
	level thread DLC3_threadCalls();	
	
	/*--------------------
	 ZOMBIE MODE
	----------------------*/
	[[level.DLC3.weapons]]();
	[[level.DLC3.powerUps]]();
	maps\_zombiemode::main();
	
	/*--------------------
	 FUNCTION CALLS - POST _Load
	----------------------*/
	level.zone_manager_init_func = ::dlc3_zone_init;
	level thread DLC3_threadCalls2();
}

dlc3_zone_init()
{

	add_adjacent_zone( "initial_zone", "zone1", "enter_zone1" );
	add_adjacent_zone( "zone1", "zone2", "enter_zone2" );
	/*
	=============
	///ScriptDocBegin
	"Name: add_adjacent_zone( <zone_1>, <zone_2>, <flag>, <one_way> )"
	"Summary: Sets up adjacent zones."
	"MandatoryArg: <zone_1>: Name of first Info_Volume"
	"MandatoryArg: <zone_2>: Name of second Info_Volume"
	"MandatoryArg: <flag>: Flag to be set to initiate zones"
	"OptionalArg: <one_way>: Make <zone_1> adjacent to <zone_2>. Defaults to false."
	"Example: add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );"
	///ScriptDocEnd
	=============
	*/

	// Outside East Door
	//add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );
}