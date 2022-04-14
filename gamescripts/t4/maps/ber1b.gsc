// scripting by Bloodlust
// level design by BSouds

#include maps\_utility;
#include maps\ber1b_util;

main()
{
	// Set this to the maximum number of friendly troops you want to be in your squad.
	// MUST be called before maps\_load::main();
	// This is for 3 possible co-op players, plus the Sarge character
	level.maxfriendlies = 8;
	
	// Required to set up the vehicles through the vehicle script
	maps\_t34::main("vehicle_rus_tracked_t34");
	maps\_mganim::main();
	
	// Setup the drones
	character\char_rus_r_rifle::precache();
	level.drone_spawnFunction["allies"] = character\char_rus_r_rifle::main; 
	maps\_drones::init();
	
	// load map defaults
	maps\ber1b_fx::main();
	maps\_load::main();
	maps\createcam\ber1b_cam::main(); 
	maps\ber1b_amb::main();
	maps\ber1b_anim::main();
	maps\ber1b_status::main();
	
	// Create a new threat bias group. If it already exists, do nothing
	createthreatbiasgroup("mg42_guys");
	createthreatbiasgroup("squad");
	
	// Make first group ignored by second group
	setignoremegroup("squad", "mg42_guys");
	setignoremegroup("mg42_guys", "squad");
	
	gunner = getent("russian_gunner", "targetname");
	gunner.ignoreme = true;
	gunner.pacifist = true;
	gunner thread magic_bullet_shield();
	
	setVolFog(5000, 5000, 8000, 17000, 100/255, 100/255, 100/255, 1);

	wait_for_first_player();
	ber1b_main();
}

// main function for handeling Berlin 1b
ber1b_main()
{
	/#
	maps\_status::show_task("event1");
	#/
	
	thread gunners();
	thread bunker1();
	thread bunker2();
	
	level thread maps\_camsys::playback_scene("intro");
		
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] freezecontrols(true);
		players[i] shellshock("teargas", randomfloatrange(15, 25));
	}
	
//	iprintlnbold("Stand up, comrades!");
//	wait 2;
//	iprintlnbold("Stand and fight, men!");
//	wait 2;
//	iprintlnbold("We MUST get into the train station!");
//	wait 2;
//	iprintlnbold("It is our only way into Berlin!");
//	wait 2;
//	iprintlnbold("For the Motherland!");
//	wait 2;
//	iprintlnbold("CHAAAAAAAAAAAAARGE!");


	iprintlnbold("THIS LEVEL IS NO LONGER IN PRODUCTION AND WILL NOT BE FIXED");
	
	set_friendlychain("fc1", "targetname");
	setup_squad();
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] freezecontrols(false);
	}
	
	thread objectives();
	thread tank();
	thread die_coward();
	thread last_stand();
}

// set up squadmates and heroes
setup_squad()
{
	players = get_players();
	
	guys = getaiarray("allies");
	for(i = 0; i < guys.size; i++)
	{
		if(isdefined(guys[i].targetname))
		{
			if(guys[i].targetname == "bloodlust")
			{
					level.sarge = guys[i];
					level.sarge.animname = "sarge";
					level.sarge.script_noteworthy = "sarge";
					level.sarge.script_grenades = 4;
					level.sarge setthreatbiasgroup("squad");
					level.sarge thread magic_bullet_shield();
			}
			
			if(guys[i].targetname == "boris")
			{
					level.boris = guys[i];
					level.boris.animname = "boris";
					level.boris.script_noteworthy = "boris";
					level.boris.script_grenades = 4;
					level.boris setthreatbiasgroup("squad");
					level.boris thread magic_bullet_shield();
			}
			
			if(guys[i].targetname != "russian_gunner")
			{
				guys[i].health = 5;
				guys[i] setgoalentity(players[0]);
				guys[i].goalradius = 1024;
			}
		}
	}
}

// handles the objectives for the map
objectives()
{
	//adds the objective , states it as active, gives you the string reference
	last_obj = getent("ber1_obj", "targetname");
	objective_add(1, "current", &"BER1B_OBJECTIVE1", last_obj.origin);
	
	trigger = getent("last_stand", "targetname");
	trigger waittill("trigger");
	
	objective_state (1, "done");
	
	wait 1;
	
	objective_add(1, "current", &"BER1B_OBJECTIVE2");
	
	waittill_aigroupcleared("laststand");

	objective_state (2, "done");
}

// set MGs to manual and shoot at drones till Player gets closer to the MOAB explosion crater
gunners()
{
	gunner = getentarray("gunner", "script_noteworthy");
	for(i = 0; i < gunner.size; i++)
	{
		gunner[i].ignoreall = true;
		gunner[i] thread magic_bullet_shield();
		gunner[i] setthreatbiasgroup("mg42_guys");
	}
	
	mg = getentarray("misc_turret", "classname");
	for( i = 0; i < mg.size; i++ )
	{
		mg[i].script_fireondrones = true;
		mg[i] thread maps\_mgturret::mg42_target_drones(undefined, "axis", undefined);
	}
	
	trigger = getent("start_mgs", "targetname");
	trigger waittill("trigger");
	
	mg = getentarray("misc_turret", "classname");
	for(i = 0; i < mg.size; i++)
	{
		mg[i].script_fireondrones = false;
		mg[i].dronefailed = false;
	}
	
	gunner = getentarray("gunner", "script_noteworthy");
	for(i = 0; i < gunner.size; i++)
	{
		gunner[i].ignoreall = false;
		gunner[i] thread stop_magic_bullet_shield();
	}
	
	level thread maps\ber1_melee::main("vigz", "targetname", true, undefined);
}

// kills the player if they retreat
die_coward()
{
	mg = getent("pwner", "targetname");
	trigger_warn = getent("coward_warning", "targetname");
	trigger_kill = getent("coward_killer", "targetname");

	while(1)
	{	
		trigger_warn waittill("trigger");
		
		print3d(mg.origin +(0,0,80), "Not one step backwards, comrades!!!", (1.0, 0.8, 0.5), 1, 3);
		print3d(mg.origin +(0,0,80), "Move forward or be shot as a coward and traitor to the Motherland!!!", (1.0, 0.8, 0.5), 1, 3);
		
		trigger_kill waittill("trigger", who);
	
		mg setmode("manual");
		mg settargetentity(who); 
		mg startfiring();
	}
}

// manage train station defenders
last_stand()
{
	trigger = getent("last_stand", "targetname");
	trigger waittill("trigger");
	thread maps\_squad_manager::manage_spawners("laststand", 10, 16,"laststand_over", 0.3, undefined);
}

// handles the action of the destroyed train yard tank that opens the way to Berlin
tank()
{
	trigger = getent("spawn_tank", "targetname");
	trigger waittill("trigger");
	
	wait 1;
	
	tank = getent("tank", "targetname");
	tanktarget = getent("tanktarget", "targetname");
	
	vnode = getvehiclenode("auto1769","targetname");
	vnode waittill ("trigger");
	
	exploder(10);
	
	vnode = getvehiclenode("auto1770","targetname");
	vnode waittill ("trigger");
	
	exploder(11);

	waittill_aigroupcleared("laststand");
	wait(randomfloatrange(2, 5));
	
	tank setturrettargetent(tanktarget);
	tank waittill ("turret_on_target");
	tank fireWeapon();
	
	exploder(12);
	earthquake(0.3, 1.5, tanktarget.origin, 512);
	
	print3d(level.sarge.origin +(0,0,80), "Our way into Berlin has been opened!", (1.0, 0.8, 0.5), 1, 3);
	print3d(level.sarge.origin +(0,0,80), "Follow me to glory, comrades!", (1.0, 0.8, 0.5), 1, 3);
	
	maps\_camsys::playback_scene("end");
	
	missionsuccess("ber2",false);
}

#using_animtree("generic_human");
bunker1()
{
	gunner = getent("bunker_gunner1", "targetname");
	gunner thread magic_bullet_shield();
	gunner.deathanim = %death_explosion_up10;
	mg = getent("bunker01_mg", "targetname");
	
	trigger = getent("bunker01_trigger", "targetname");
	trigger waittill("trigger");
	
	exploder(14);
	
	if(issentient(gunner))
	{
		if(isdefined(gunner.magic_bullet_shield))
		{
			gunner thread stop_magic_bullet_shield();
		}
		
		waittillframeend;
		gunner doDamage(gunner.health + 1, (0,180,72));
	}

	mg notify("stop_using_built_in_burst_fire");
	mg notify("stopfiring");
	wait 0.1;
	mg delete();
	trigger delete();
}

#using_animtree("generic_human");
bunker2()
{
	gunner = getent("bunker_gunner2", "targetname");
	gunner thread magic_bullet_shield();
	gunner.deathanim = %death_explosion_up10;
	mg = getent("bunker02_mg", "targetname");
	
	trigger = getent("bunker02_trigger", "targetname");
	trigger waittill("trigger");
	
	exploder(15);
	
	if(issentient(gunner))
	{
		if(isdefined(gunner.magic_bullet_shield))
		{
			gunner thread stop_magic_bullet_shield();
		}
		
		waittillframeend;
		gunner doDamage(gunner.health + 1, (0,180,72));
	}

	mg notify("stop_using_built_in_burst_fire");
	mg notify("stopfiring");
	wait 0.1;
	mg delete();
	trigger delete();
}