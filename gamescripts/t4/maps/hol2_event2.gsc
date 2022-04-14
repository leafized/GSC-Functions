
#include maps\hol2;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#using_animtree("generic_human");


start_event2()
{
	
	level.maddock = getent("actor_ally_brit_hol_maddock", "classname");
	level.maddock.name = "Sgt. Maddock";
	squad = getaiarray( "allies");
	players = get_players();
	event2_players_start = getentarray("event2_players_start", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event2_players_start[i].origin+ (-10000,-10000,-10000));
		players[i] setplayerangles( event2_players_start[i].angles);
	}
		wait 0.5;
	
	squad_start_spots = getentarray("event2_squad_origins", "targetname");
	for (i=0; i < squad.size; i++)
	{
		squad[i] teleport(squad_start_spots[i].origin, squad_start_spots[i].angles);
	}
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event2_players_start[i].origin);
		players[i] setplayerangles( event2_players_start[i].angles);
	}
	do_set_pacifist(squad, true);
				// event 1 GO
	players = get_players();
	array_thread(players, ::player_speed_set, 150,1);
	squad_setup(squad);
	event2_setup();

}

event2_setup()
{		
	maps\hol2_fx::event_1_amb();	
	array_thread (level.betty_trigs, ::squad_down_when_bettied);
	
			// first objective thing
		getent("obj6_trig", "script_noteworthy") trigger_off();
			
	event2_initial_ambush();
}
		
player_too_eager()
{
	self endon ("bridge3_fight_begin");
	players = get_players();
	array_thread (players, :: waitfor_player_attack,"bridge3_fight_begin");	
	trig = getent("bridge3_covered_area", "targetname");
	trig thread waittill_trig_n_notify("bridge3_fight_begin");
	wait 20;
	array_thread (players, ::player_stands_too_long);
}


player_stands_too_long()
{
	self endon ("bridge3_fight_begin");
	secs_standing = 0;
	for (i=0;i < 4;)
	{
		if (self getstance() == "stand" && self.origin[1] > 100)
		{
			i++;
			wait 1;
		}
		wait 1;
	}
	level notify ("bridge3_fight_begin");
}

event2_initial_ambush()
{
	spawners = getentarray("bridge3_guys_infight", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] add_spawn_function(::solo_set_pacifist,true);
	}
	level thread unload_group_after_spawn();
	players = get_players();
	//tripwires = getentarray("trip_wires", "targetname");
	//array_thread(tripwires, ::prep_trip_wires);
	//spawners = getentarray("event1_snow_guys", "targetname");
	//maps\_spawner::flood_spawner_scripted(spawners);
	waittillframeend;
	level thread discover_bridge3_guys();
	level thread wake_up_bridge3_guys();
	
			// wait for trig to move friendly up
	trig = getent("redshirt_moveup", "targetname");
	if (isdefined(trig))
	{
		trig waittill ("trigger");
	}	
	level thread wait_n_notify(10, "convoy2_past");	
		
			// extends the fog distance
	maps\hol2_fx::event_1_amb_2();
	
	 			// wait for notify for first group to be dead, move to second part of event
	level waittill_aigroupcleared ("snow_ambushers");
	level notify ("bridge3_infantry_cleared");
	//trig delete();
	event1_after_ambush();
}

bridge3_after_disarm()
{
	trig = getent("plant_bomb_on_bridge", "targetname");
	trig waittill ("trigger");
	level thread meet_hero_in_forest();
	level notify ("bridge3_disarmed");
	wait 0.5;
	objective_control(2);
	 getent("bridge3_bomb", "targetname") delete();
  trig delete();
  iprintln("Good work, thats the last bridge in this area.  Our Convoy will be through here in a few hours, the rendevous is just up ahead");
  trig = getent ("woods_moveup_trig", "targetname");
	trig thread trigger_and_delete();
	wait 1;
	trig delete();
  squad = getaiarray("allies");
  do_set_pacifist(squad, true);
	maps\hol2_event2::event2_start_runback();
}
		
event1_after_ambush()
{
  level endon ("bridge3_disarmed");
  trig1 = getent ("wait_for_bomb_pos", "targetname");
	trig1 thread trigger_and_delete();
	getent("plant_bomb_on_bridge", "targetname") trigger_on();
	level thread bridge3_after_disarm();
	wait 8;
  //trig delete();
  iprintln("Those krauts were wiring this bridge.");
  wait 6;
 	iprintln("More dynamine on this one, Wilkins come dismantle it");  
}

		// here is when the enemies on the hill start retreating
event2_start_runback()
{

	runback_guys = getaiarray("axis"); 
	kill_guys_in_array(runback_guys); 
	wait 0.2;
	squad = getaiarray("allies");
	do_set_Pacifist(squad, true);
	event2_wood_stroll();
}

event2_wood_stroll()
{
			// wait until you get near the camp
	
	roadguys = getentarray("road_guys", "script_noteworthy");
  for (i=0;i < roadguys.size; i++)
  {
  	roadguys[i] delete();
  }
  breakit = false;
	while (breakit == false)
	{
		breakit = true;
		ai = getaiarray("allies");
		for (i=0; i < ai.size; i++)
		{
			if (ai[i].origin[1] < 4500)
			{
				breakit = false;
			}
		}
		wait 2;
	}
	getent("obj6_trig", "script_noteworthy") trigger_on();
	maps\hol2_event3::event3_setup();
}

		//**TEMP Redo this temp shiznit
walk_toward_sarge(num)
{
	level endon ("bridge3_fight_begin");
	self.animname = "generic";
	self set_run_anim("patrol_walk");
	level waittill ("engineers_jumping");
	node = getnode("patrol_to_node"+num, "script_noteworthy");
	self thread maps\_spawner::go_to_node(node);
}

discover_bridge3_guys()
{
	level endon ("bridge3_fight_begin");
	trig = getent("into_bridge3_trig", "targetname");
	trig waittill ("trigger");
	wait 5;
	iprintln("More Jerries setting up bombs on that bridge");
	patrolguys = getentarray("bridge3_patrol_guys", "script_noteworthy");
	ncount = 0;
	for (i=0; i < patrolguys.size; i++)
	{
		if (isai(patrolguys[i]))
		{
			patrolguys[i] thread walk_toward_sarge(ncount);	
			ncount++;
		}
	}
	
	wait 5;
		iprintln("Looks like the end of the convoy, let's split up and take them out quietly");
	wait 8;
	getent("flank_bridge3_trig", "targetname") thread trigger_and_delete();
	wait 15;
	flag_set("bridge3_peaceful");
	wait 7;
	iprintln("They've spotted us! Open fire!");
	level notify ("bridge3_fight_begin");
}
	
wake_up_bridge3_guys()
{
	level thread bridge3_reinforcement_truck_passively();
	level waittill ("bridge3_fight_begin");
	flag_set("brige3_fightstarted");
	colortrig = getent("flank_bridge3_trig", "targetname");
	if (isdefined(colortrig))
	{
		colortrig thread trigger_and_delete();
	}
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] allowedstances ("stand", "crouch", "prone");
		allies[i] set_sneak_walk(false);
	}
	maps\_spawner::kill_spawnerNum(17);
	if (!flag("bridge3_peaceful"))
	{
		level thread bridge3_reinforcement_truck();
	}
	wait randomfloat(1);
	nodes = getnodearray("bridge3_cover_nodes", "script_noteworthy");
	nodecount = 0;
	snowguys = getaiarray("axis");
	cap = grab_ai_by_script_noteworthy("b3_captain", "axis");
	snowguys = array_remove(snowguys, cap);
	for (i=0; i < snowguys.size; i++)
	{
		if (isdefined(nodes[nodecount]) && snowguys[i].script_noteworthy != "ambush_reinforcement_guys")
		{
			snowguys[i] solo_set_pacifist(false);
			snowguys[i] thread maps\_spawner::go_to_node(nodes[nodecount]);
			nodecount++;
		}
	}
}

bridge3_reinforcement_truck_passively()
{
	level endon ("bridge3_active_truck");
	flag_wait("bridge3_peaceful");
	trig = getent("bridge3_reinforce_trig", "targetname") thread trigger_and_delete();
	wait 0.5;
	truck = getent("bridge3_reinforcement_truck", "targetname");
	node = getvehiclenode("reinforcements_passby", "targetname");
	truck attachpath(node);
	truck startpath();
	truck.unload_group = "all";
	wait 5;
	flag_wait("brige3_fightstarted");
	truck setspeed (0,5,5);
	truck notify ("unload");
	maps\_spawner::kill_spawnernum(40);
	wait 14;
	snowguys = getentarray("ambush_reinforcement_guys", "script_noteworthy");
	do_set_pacifist(snowguys, false);
}
	

bridge3_reinforcement_truck()
{
	level notify ("bridge3_active_truck");
	sdk = getent("bridge3_convoy_6", "targetname");
	if (isdefined(sdk))
	{
		while (sdk.origin[0] < 700)
		{
			wait 0.5;
			if (!isdefined(sdk))
				break;
		}
	}
	trig = getent("bridge3_reinforce_trig", "targetname") thread trigger_and_delete();
	wait 2;
	vehicle = getent("ambush_reinforcement_truck", "script_noteworthy");
	vehicle.unload_group = "all";
	maps\_spawner::kill_spawnernum(40);
	vehicle waittill ("unload");
	
	wait 20;
	
	
	snowguys = getentarray("ambush_reinforcement_guys", "script_noteworthy");
	do_set_pacifist(snowguys, false);
	
}




ambush_drivebys_delete()
{
	node = getvehiclenode("endof_driveby", "targetname");
	while (1)
	{
		node waittill ("trigger", truck);
		if (truck == self)
			break;
	}
	wait 0.2;
	self notify ("pathend");
	self vehicle_deleteme();
}

	
prep_trip_wires()
{
	self waittill ("trigger", guy);
	radiusdamage(guy.origin, 1000, 10000,9999);
	playfx(level._effect["tripwire"], guy.origin);
}

unload_group_after_spawn()
{
	trig = getent("ambush_driveby_trig", "script_noteworthy");
	trig waittill ("trigger");
	allies = getaiarray("allies");
	array_thread(allies, ::set_sneak_walk, true);
	
	wait 1.2;
	level thread player_too_eager();
	truck = getent("bridge3_setup_guys_truck", "targetname");
	trucks = getentarray("bridge3_convoy_pass", "script_noteworthy");
	array_thread(trucks, ::ambush_drivebys_delete);
	level thread bridge3_engineers_anim(truck);
	truck thread truck_unload_and_go();
	sdk_stop_n_own();
	sdk = getent("bridge3_convoy_6", "targetname");
	if (isdefined(sdk))
	{
		sdk clearturrettarget();
		sdk resumespeed(5);
	}
}

truck_unload_and_go()
{
	node = getvehiclenode("bridge3_truck_unload_node", "targetname");
	node waittill ("trigger");
	self setspeed (0,10,10);
	self notify ("unload");
	wait 8;
	self.unload_group = "all";
	self resumespeed (10);
	wait 5;
	self notify ("unload");
}
	

bridge3_engineers_anim(truck)
{
	level endon ("bridge3_fight_begin");
	eng1 = grab_ai_by_script_noteworthy("b3_engineer_1", "axis");
	eng1.animname = "bridge3_engineer1";
	eng2 = grab_ai_by_script_noteworthy("b3_engineer_2", "axis");
	eng2.animname = "bridge3_engineer2";
	cap = grab_ai_by_script_noteworthy("b3_captain", "axis");
	cap.animname = "bridge3_commander";
	cap endon ("death");
	eng1 endon ("death");
	eng2 endon ("death");
	eng1 thread set_run_anim( "b3_engineers_walk");
	eng2 thread set_run_anim( "b3_engineers_walk");
	cap thread set_run_anim( "comander_walk");
	engineers = [];
	eng1 thread bridge3_engineers_awake();
	eng2 thread bridge3_engineers_awake();
	cap thread bridge3_cap_awake();
	
	truck waittill ("unload");
	wait 3; 
	cap thread bridge3_commander_anim();
	wait 5;
	engineers = array_add ( engineers, eng1 );
	engineers = array_add ( engineers, eng2 );
	animSpot = getent("engineers_jumpdown_startpoint", "targetname");
	animSpot anim_reach(engineers, "b3_engineers_jumpdown");
	level notify ("engineers_jumping");
	animSpot anim_single(engineers, "b3_engineers_jumpdown");
	
	
	node1 = getnode("engineer1_setup_node", "targetname");
	node2 = getnode("engineer2_setup_node", "targetname");
	node1 thread bridge3_engineer_arm(eng1);
	node2 thread bridge3_engineer_arm(eng2);

}
bridge3_commander_anim()
{
	level endon ("bridge3_fight_begin");
	self endon ("death");
	spot = getent("commander_perch", "targetname");
	spot anim_reach_solo(self, "commander_transition");
	spot anim_single_solo(self, "commander_transition");
	spot anim_loop_solo(self, "commander_loop", undefined, "death");
}

bridge3_engineer_arm(guy)
{
	level endon ("bridge3_fight_begin");
	self endon ("death");
	self anim_reach_solo(guy, "b3_engineers_walk");
	self anim_loop_solo(guy, "arm_dynamite", undefined, "death");
}

bridge3_cap_awake()
{
	self endon ("death");
	level waittill ("bridge3_fight_begin");
	spot = getent("commander_perch", "targetname");
	self stopanimscripted();
	spot anim_reach_solo(self, "commander_alarm");
	spot thread anim_single_solo(self, "commander_alarm");
	wait 2.4;
	self thread reset_run_anim();
	self solo_set_pacifist(false);
}
bridge3_engineers_awake()
{
	self endon ("death");
	level waittill ("bridge3_fight_begin");
	wait 0.1;
	self thread reset_run_anim();
	self stopanimscripted();
	self solo_set_pacifist(false);
}


sdk_stop_n_own()
{
	level endon("sdk_passed");
	level endon ("start_trip_wires");
	sdk = getent("bridge3_convoy_6", "targetname");
	sdk endon ("pathend");
	sdk endon ("death");
	node = getvehiclenode("sdk_passed", "targetname");
	node thread waittill_trig_n_notify("sdk_passed", sdk);
	level waittill ("bridge3_fight_begin");
	for (i=1; i < 7; i++)
	{
		node = getvehiclenode("sdk_stop"+i, "targetname");
		node thread waittill_trig_n_notify("sdk_awaken", sdk, i);
	}
	level waittill ("sdk_awaken");
	sdk setspeed (0,10,10);
	wait 3;
	flag_set("sdk_stopped");
	node = getvehiclenode("sdk_stop"+level.sdknode, "targetname");
	sdk thread sdk_luv_you(25);
	sdk sdk_movearound_thread(node);
	sdk setspeed (0,100,100);
	lastnode = getvehiclenode ("sdk_passed", "targetname");
	fightnode = getvehiclenode("sdk_fight_node1", "targetname");
	sdk setswitchnode(fightnode, lastnode);
	sdk setspeed (10,5,5);
}


sdk_movearound_thread(tnode)
{
	level endon ("bridge3_infantry_cleared");
	self endon ("death");
	fightnode = getvehiclenode("sdk_fight_node1", "targetname");
	self setswitchnode(tnode, fightnode);
	while (1)
	{
		self resumespeed(1);
		wait randomint(5);
		self setspeed(0,5,5);
		wait randomint(10);
	}
}
			


meet_hero_in_forest()
{
	newguy = [];
	guys = getentarray("scouts", "targetname");
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::solo_set_pacifist,true);
	}
	wait 1;
	for (i=0; i < guys.size; i++)
	{
		newguy[i] = guys[i] stalingradspawn();
		wait 0.1;
		if (newguy[i].script_noteworthy == "newhero")
		{
			level.newhero = newguy[i];
			level.newhero.name = "Cpl. Goddard";
		}
	}
	level thread scouts_emerge();
	wait 5;
	for (i=0; i < guys.size; i++)
	{
		newguy[i] set_sneak_walk(true);
	}
}

scouts_emerge()
{
	trig = getent("scouts_emerge_trig", "targetname");
	trig waittill ("trigger");
	wait 1;
	iprintln("Flash");
	wait 3;
	iprintln("Thunder");
	guy1 = grab_ai_by_script_noteworthy("newhero","allies");
	guy2 = grab_ai_by_script_noteworthy("sidekick","allies");
	node1 = getnode("newhero_node", "targetname");
	node2 = getnode("sidekick_node", "targetname");
	guy1 thread maps\_spawner::go_to_node(node1);
	guy2 thread maps\_spawner::go_to_node(node2);
	wait 5;
	iprintln("Nice to see you guys");
	wait 3;
	iprintln("German Supply depot down there, we can take it.  Watch out for tripwires");
	guys = getaiarray("allies");
	for (i=0; i < guys.size; i++)
	{
		guys[i] allowedstances ("stand", "crouch", "prone");
		guys[i] set_sneak_walk(true);
	}
	guy = grab_ai_by_script_noteworthy("sidekick","allies");
	if (isdefined(guy))
	{
		guy set_force_color("g");
	}
	guy2 = grab_ai_by_script_noteworthy("newhero","allies");
	if (isdefined(guy2))
	{
		guy2 set_force_color("b");
	}
	getent("pre_tripwire_chain", "targetname") thread trigger_and_delete();
	wait 2;
	iprintln("I'll check it out");
	betty_controller();

}

sdk_luv_you(offset)
{
	self notify ("stop_turret");
	self endon("stop_turret");
	self endon("death");
	self endon ("pathend");
	level endon ("start_trip_wires");
	while (isalive(self))
	{
		allies = getaiarray("allies");
		cantanksee = false;
		players = get_players();
		cointoss = randomint(10);
		if (cointoss > 6)
		{
			tanktarget = players[randomint(players.size)];
		}
		else
		{
			tanktarget = allies[randomint(allies.size)];
		}
		self setTurretTargetEnt (tanktarget, (randomint(offset) - randomint(offset), randomint(offset) - randomint(offset), randomint(offset) - randomint(offset)));
		wait randomint(5);
		shoottime = randomint(50);
		for (i=0; i < shoottime; i++)
			{
			if (isdefined(tanktarget) && isalive(tanktarget))
			self setTurretTargetEnt (tanktarget, (randomint(offset) - randomint(offset), randomint(offset) - randomint(offset), randomint(offset) - randomint(offset)));
			wait 0.25;
			self fireweapon();
			}
		self clearturrettarget();	
	}
}

squad_down_when_bettied()
{
	level endon ("sarge_at_e3_door");
	spot = self.origin;
	self waittill ("trigger");
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		dist = distance(spot, allies[i].origin);
		if (isdefined(dist) && dist < 300 && allies[i] != level.maddock)
		{
			allies[i] stopanimscripted();
			allies[i] thread anim_single_solo(allies[i], "dive");
		}
	}
}

dive_and_betty()
{
	self stopanimscripted();
	self anim_single_solo(self, "dive");
	if (isdefined(self.targetbetty))
	{
		self.targetbetty anim_reach_solo(self, "trav");
	}
}

betty_controller()
{	

	guys = getaiarray("allies");
	for (i=0; i < guys.size; i++)
	{
		guys[i].mycolor = get_force_color();
		guys[i] disable_ai_color();
		guys[i] reset_run_anim();
		guys[i].animname = "trip_wire_guys1";
	}
	flag_set("path2_clear");
	flag_set("path1_clear");
	level.maddock thread wire_path("trip_wire_guys1", "1a", "3b");
	wait 8;
	iprintln("Watch out, we got a tripwire attached to a betty here.  Be careful, hit the deck quick if you trigger one");
	wait 8;
	getent("post_tripwire_trig", "script_noteworthy") thread wait_n_notify(3, "trigger");	
	guys = array_remove(guys, level.maddock);
	guys[0] thread wire_path("trip_wire_guys3", "1b", "2a", "path2");
	if (isdefined(guys[1]))
		guys[1] thread wire_path("trip_wire_guys2", "1a", "4b", "path1");
	wait 0.1;
	flag_wait("path1_clear");
	flag_wait("path2_clear");
	if (isdefined (guys[2]))
		guys[2] thread wire_path("trip_wire_guys3", "1a", "6a", "path1");
	if (isdefined (guys[3]))
		guys[3] thread wire_path("trip_wire_guys2", "1b", "5b", "path2");
	wait 0.2;
	flag_wait("path1_clear");
	flag_wait("path2_clear");
	if (isdefined(guys[4]))
		guys[4] thread wire_path("trip_wire_guys2", "1a", "4b", "path1");
	if (isdefined (guys[5]))
		guys[5] thread wire_path("trip_wire_guys2", "1b", "2a", "path2");
	wait 0.2;
	flag_wait("path1_clear");
	if (isdefined (guys[6]))
		guys[6] thread wire_path("trip_wire_guys3", "1a", "6a");
	wait 0.1;
}


wire_path(aname, spot1, spot2, path)
{
	if (isdefined(path))
	{
		flag_clear(path+"_clear");
	}
	wait randomfloat (1);
	self.animname = aname;
	self set_run_anim( "walk");
	spot = getent("tripwire_"+spot1, "targetname");
	self.targetbetty = spot;
	spot anim_reach_solo(self, "trav");
	if (isdefined(path))
	{
		flag_set(path+"_clear");
	}
	spot anim_single_solo(self, "trav");
		

	if (self == level.maddock )
	{
		self.animname = "trip_wire_guys2";
		self set_run_anim( "walk");
	}

	spot = getent("tripwire_"+spot2, "targetname");
	self.targetbetty = spot;
	spot anim_reach_solo(self, "trav");
	spot anim_single_solo(self, "trav");
	self enable_ai_color();
	self.targetbetty = undefined;
}
	
