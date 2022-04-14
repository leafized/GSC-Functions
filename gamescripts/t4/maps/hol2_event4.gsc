#include maps\hol2;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#using_animtree("generic_human");

		// this skipto begins with the gulch ambush
start_event4()
{
			// turns off triggers that should be off only when using this skipto
	skipto_trigs_off();
	
			// initialize global vars
	level.maddock = getent("actor_ally_brit_hol_maddock", "classname");
	level.maddock.name = "Sgt. Maddock";
	newhero = getent("newhero", "script_noteworthy");
	level.newhero = newhero stalingradspawn();	
	level.newhero.name = "Cpl. Goddard";
	wait 0.1;
	level.newhero.dontavoidplayer = true;
	squad = getaiarray("allies");
	players = get_players();
	event4_players_start = getentarray("event4_players_start", "targetname");
			
			// set the players way outside the world so we can teleport the squad up without being in view
	for (i=0; i < players.size ; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin + (-10000,-10000,-10000));
	}
	

	wait 0.2;
	
			// warp squad to starting points
	squad_start_spots = getentarray("event4_squad_origins", "targetname");
	for (i=0; i < squad.size ; i++)
	{
		squad[i] teleport(squad_start_spots[i].origin, squad_start_spots[i].angles);	
	}
	
			// warp players to starting points
	players = get_players();
	event4_players_start = getentarray("event4_players_start", "targetname");
	for (i=0; i < players.size ; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin);
		players[i] setplayerangles( event4_players_start[i].angles);
	}
						
	level thread objective_control(7);
			// Done with the skip-to functionality, on to the real event setup
	event4_setup();
}

start_graveyard()
{
			// turns off triggers that should be off only when using this skipto
	skipto_trigs_off();
	pre_event4_trigs_off();
	level.event4 = true;
	level.event3 = false;
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] takeweapon("rocket_barrage");
	}
	
			// initialize global vars
	level.maddock = getent("actor_ally_brit_hol_maddock", "classname");
	level.maddock.name = "Sgt. Maddock";
	newhero = getent("newhero", "script_noteworthy");
	level.newhero = newhero stalingradspawn();	
	level.newhero.name = "Cpl. Goddard";
	wait 0.1;
	squad = getaiarray("allies");
	players = get_players();
	event4_players_start = getstructarray("grave_player_start_positions", "targetname");
			
			// set the players way outside the world so we can teleport the squad up without being in view
	for (i=0; i < players.size ; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin + (-10000,-10000,-10000));
	}
	
	wait 0.2;
				// warp squad to starting points
	squad_start_spots = getstructarray("grave_squad_start_positions", "targetname");
	for (i=0; i < squad.size ; i++)
	{
		squad[i] teleport(squad_start_spots[i].origin, squad_start_spots[i].angles);	
	}
	
			// warp players to starting points
	players = get_players();
	for (i=0; i < players.size ; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin);
		players[i] setplayerangles( event4_players_start[i].angles);
	}
						
	level thread objective_control(7);
			// Done with the skip-to functionality, on to the real event setup
	getent("graveyard_fallback_pos", "targetname") notify ("triggeR");

	scripted_spawn_go(3);
	scripted_spawn_go(4);
	wait 0.5;
	woods_tiger = getent("woods_tiger", "targetname");
	gulch_tiger = getent("gulch_tiger", "targetname");
	gulch_panzer = getent("gulch_panzer", "targetname");
	
	woods_node = getvehiclenode("woods_tiger_firenode", "targetname");
	woods_tiger attachpath(woods_node);
	woods_tiger startpath();
	woods_tiger setspeed(0,10,10);
	gulch_node = getvehiclenode("tiger_gate_stop", "targetname");
	gulch_tiger attachpath(gulch_node);
	gulch_tiger startpath();
	gulch_tiger setspeed(2,10,10);
	gulch_panzer vehicle_deleteme();
	event4_savetheday();
}
		
		
event4_setup()
{
	pre_event4_trigs_off();
			// these vars are used to reference and adjust snowfall levels in hol2_fx
	level.event4 = true;
	level.event3 = false;
			// set ambient effects for this event
	maps\hol2_fx::event_4_amb() ;
	level.maddock.ignoreme = true;
	plant_indicators();
	
			// run some funcs to stop playing from running down the road
	level thread event4_convoy_spots_player_on_road();
	level thread event4_player_running_away();
	
	trig = getent("gulch_ambush_pos_trig", "targetname");
	trig thread trigger_and_delete();
	level thread newhero_by_plunger();
	level waittill ("all_dynamite_planted");
	
	trig = getent("ambush_trig_1", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	getent("tanks_come_early", "targetname") delete();
			// notify that the event has started, which stops the "get to ambush positions" countdown
	level notify ("countdown_done");
	
			// set the friendly chain to the gulch

	wait 0.2;
			
			// turn off all triggers from events 2&3, since we will be re-using the area

			
			// complete previous objective, add the "Destroy convoy" objective

			// bring in the convoy
	level thread event4_convoy_comes();
	level thread man_the_mg();
	turnoff_house_turrets();
			// do the mid IGC and other stuff in that func
	
	event4_mid_igc();
}

arrow_bounce()
{
	self endon ("killit");
	wait 0.5;
	spot = self.origin;
	while (1)
	{
		self moveto (spot+(0,0,55), 1, .7, .3);
		wait 1;
		self moveto (spot+(0,0,-55), 1, .5, .5);
		wait 1;
	}
}


plant_indicators()
{
	allies = getaiarray("allies");
	do_set_pacifist(allies, true);				
	
	for (i=0; i < 4; i++)
	{
		arrow = getent("dynamite_arrow_indicator"+i, "targetname");
		spot = getstruct("e4_dynamite_plant"+i, "targetname");
		arrow moveto ((spot.origin+(0,0,110)), 0.000001);
		//arrow thread arrow_bounce();
		trig = getent("e4_dyn_plant_trig"+i, "targetname");
		trig thread planting_dynamite(i);
	}
} 
		
planting_dynamite(num)
{
	self waittill ("trigger");
	getent("e4_dynamite_"+num, "targetname") trigger_on();
	arrow = getent("dynamite_arrow_indicator"+num, "targetname");
	arrow notify ("killit");
	arrow delete();
	level notify ("dyn_planted"+num);
	self delete();
}
	



		// this turns off all triggers used in the same area in the previous such as friendly chains
pre_event4_trigs_off()
{
			// turn off the friendly chains
	pre_event4_chains = getentarray("pre_event4_chains", "script_noteworthy");
	for (i=0; i < pre_event4_chains.size ; i++)
	{
		pre_event4_chains[i] delete();
	}
			// turn off any trigs that had a script_noteworthy available
	pre_event4_trigs = getentarray("pre_event4_trigs", "script_noteworthy");
	for (i=0; i < pre_event4_trigs.size ; i++)
	{
		pre_event4_trigs[i] delete();
	}	
			// turn off individual triggers that had script_noteworthy taken
	trig = getent("obj6_trig", "script_noteworthy");
	if (isdefined(trig)) 
	{
		trig delete();		
	}
	getent("throwsmoke_trig", "targetname") trigger_off();
	blocker = getent("block_ai_from_street", "targetname");
	blocker connectpaths();
	blocker delete();

	dupes = getentarray("e4_dupe_vehicles" , "script_noteworthy");
	for (i=0; i<dupes.size; i++)
	{
		dupes[i] trigger_off();
	}
	
}




event4_mid_igc()
{
	
			//set squad to not shoot
	allies = getaiarray("allies");
	do_set_pacifist(allies, true);				
	squad = getaiarray("allies");
	for (i=0; i < squad.size; i++)
	{
		squad[i] allowedstances("prone", "crouch");
	}
			//took out level waittill ("introscreen_complete"); until I fix the IGC cam
			// play the IGC
	iprintln ("Hold your fire lads...wait for my signal");
	wait 0.3;
	wait 7;
	level thread event4_didplayer_gunjump();
	level endon ("jump_the_gun");
	wait 2.5;

	iprintln("Steady now...");
	wait 8;
	iprintln ("Hold your fire...");
	if (!flag("gulch_ambush_started"))
	{
		getent("convoy_arrives_trig", "script_noteworthy") trigger_on();
	}
	wait 5;
	iprintln ("Get ready....");
	wait 2;
}
	
		// controls gameplay from IGC to just before ambush starts
event4_convoy_comes()
{
		// spawn in the convoy, set em on paths, set them to not shoot
	enemies = getaiarray("axis");
	level thread do_set_pacifist(enemies, true);
	wait 0.1;		
	
		// initialize this variable to check whether the axis soldiers have been woken from pacifist 

	wait 1;

		// set each vehicle to stop on the appropriate node
		// ** TO DO **Not being used at the moment, but may bring back if this script_gatetrigger thing doesn't work
	vehicles = getentarray("gulch_convoy", "script_noteworthy");
	for (i=0; i < vehicles.size; i++)
	{
		if (isdefined(vehicles[i]) && vehicles[i].classname == "script_vehicle")
		{
			waitnode_name = vehicles[i].targetname+"_gulchstop";
			waitnode = getvehiclenode(waitnode_name, "targetname");
			vehicles[i].dontunloadonend = true;
			vehicles[i] thread stop_on_node(waitnode);
		}
		else if(vehicles[i].classname == "script_origin")
		{
			vehicles[i] delete();
		}
	}

	truck2_in_place();

	

						
		// start the thread that spawns the tanks in
	event4_ambush_start();
	event4_tanks_coming();
}

	

truck2_in_place()
{
	truck = getent("2nd_truck", "targetname");
	node = getvehiclenode("2nd_truck_gulchstop", "targetname");
	node waittill_trig_n_notify("truck2here", truck);	
	wait 1;
	flag_set("truck2here");
	wait 1;
	level notify ("dynamite_ready");
	temp_dynamite_trig_to_player();
	vehicles = getentarray("gulch_convoy", "script_noteworthy");
	blowspot = getent("dynamite_blow_position", "targetname");
	playfx(level._effect["road_dynamite"], blowspot.origin);
	array_thread(vehicles, ::convoy_blown_anims);
	wait 0.01;
	//blowspot radiusdamage(blowspot.origin, 750, 1000,500);
	blowspot delete();
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		earthquake(0.6, 2, players[i].origin, 500);
	}
	bombs = getentarray("dynamite_models", "script_noteworthy");
	for (i=0; i < bombs.size; i++)
	{
		bombs[i] delete();
	}
	guy = [];
	guys = getentarray("fake_ragdollers", "targetname");
	for (i=0; i < guys.size; i++)
	{
		guy[i] = guys[i] stalingradspawn();
	}
	wait 0.05;
	for (i=0; i < guy.size; i++)
	{
		guy[i] magicgrenade(guy[i].origin+(0,20,-20), guy[i].origin+(0,20,-30), 0.1);
		physicsexplosionsphere(guy[i].origin+(0,20, -30), 150, 5, 1);
	}
	wait 0.5;
	flag_set("gulch_ambush_started");
	level notify ("gulch_ambush_started");
	wait 1;
	vehicles = getentarray("gulch_convoy", "script_noteworthy");
	for (i=0; i < vehicles.size; i++)
	{
		vehicles[i].dontunloadonend = undefined;
		vehicles[i].unload_group = "all";
		vehicles[i] notify ("unload");
		if (vehicles[i].vehicletype == "halftrack")
		{
			node = getvehiclenode("MOVE_HALFTRACK", "targetname");
			vehicles[i] attachpath(node);
			vehicles[i] startpath();
		}
	}
	axis = getaiarray("axis");
	for (i=0; i < 4; i++)
	{
		axis[i] thread convoy_crawlers();
	}
}

			// this thread wakes up the friendly and enemy AI when the ambush in the gulch commences
event4_ambush_start()
{	
			//set friendlies to fire
	level thread do_set_pacifist(getaiarray("allies"), false);
			// grab all enemies, and run a thread that only wakes up some of them, sets a delay on the rest, 
			// then the rest wake up and start fighitng shortly after
	enemies = getaiarray("axis");
	do_set_pacifist(enemies, false);
}
	
		// set the last truck in the convoy on its escape path
backout_lane2_truck3()
{
	if (flag("e4_convoy_notinplace"))
		return;
	truck = get_true_vehicle("2nd_lane_truck3", "targetname");
	truck setspeed(70,1000,1000);
}
		// set the third truck in the convoy on its escape path
backout_lane2_truck2()
{
	if (flag("e4_convoy_notinplace"))
		return;
	truck = get_true_vehicle("2nd_lane_truck2", "targetname");
	truck setspeed(70,1000,1000);
}
		// set the halftrack on its escape path
backout_halftrack()
{
	if (flag("e4_convoy_notinplace"))
		return;
	truck = get_true_vehicle("gulch_halftrack", "targetname");
	node = getvehiclenode("halftrack_halfway", "targetname");
	truck setspeed(70,1000,1000);
}
				// sets the first car to slowly roll back towards the end of the ambush
kubel1_rollback()
{
	if (flag("e4_convoy_notinplace"))
		return;
	kubel = getent("1st_vehicle", "targetname");
	kubel setspeed(70,1000,1000);
}

		// set the 2nd kubel on its escape path
backout_kubel2()
{
	if (flag("e4_convoy_notinplace"))
		return;
	node = getvehiclenode("kubel2_node3", "targetname");
	kubel2 = get_true_vehicle("2nd_kubel", "targetname");
	kubel2 setspeed(70,1000,1000);
}
		// set this truck on its escape path
backout_truck2()
{
	truck = get_true_vehicle("2nd_truck", "targetname");
	truck setspeed(70,1000,1000);
}

event4_convoy_kills_player_on_road()
{
	self endon ("death");
	tank = get_true_vehicle("2nd_truck", "targetname");
	if (tank.health > 0)
		tank setTurretTargetvec(self.origin);
	wait 0.3;
	if (tank.health > 0)
		tank fireweapon();
	wait 0.2;
	tank fireweapon();
	wait 0.01;
	self dodamage(30, tank.origin);
	wait 0.2;
	tank fireweapon();
	wait 0.01;
	self dodamage(30, tank.origin);
	wait 0.2;
	wait 0.01;
	self dodamage(self.health *10, tank.origin);
	wait 0.3;
}	

event4_player_running_away()
{
	while (!flag("gulch_ambush_started"))
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i].origin[1] > 11700)
			{
				iprintln("Wilkins where the hell are you going?  Get back here!");
				wait 10;
			}
		}
		wait 0.5;
	}
}

event4_convoy_spots_player_on_road()
{
	level endon ("gulch_ambush_started");
	trig = getent("tanks_come_early", "targetname");
	trig waittill ("trigger");
	getent("ambush_trig_1", "targetname") delete();
	wait 0.5;
	trucks = getentarray("gulch_convoy", "script_noteworthy");
	for (i=0; i < trucks.size; i++)
	{
		trucks[i]setspeed(10, 10, 10);
	}
	for (i=0; i < 4; i++)
	{
		wait 0.7;
		players = get_players();
		for (j=0; j < players.size; j++)
		{
			if (players[j].origin[1] > 13050)
			{
				players[j] thread event4_convoy_kills_player_on_road();
			}
		}
	}		
	for (i=0; i < 40; i++)
	{
		wait 0.7;
		players = get_players();
		for (j=0; j < players.size; j++)
		{
			players[j] thread event4_convoy_kills_player_on_road();
		}
	}
}
		// controls gameplay post ambush up until the player is defending at the flak
event4_tanks_coming()
{
	maps\_spawner::kill_spawnernum(10);
	trig = getent("event4_flak_savetrig", "script_noteworthy");
	//trig trigger_on();
			// move squad onto road to intercept enemy infantry
	
		// spawn in the tanks
	wait 5;
	scripted_spawn_go(3);
	wait 0.5;
	trig delete();
	tankgroup1 = getentarray("gulch_tanks", "script_noteworthy");
	for (i=0; i < tankgroup1.size; i++)
	{
		if (tankgroup1[i].classname == "script_vehicle")
		{
			node = getvehiclenode(tankgroup1[i].targetname+"_start_node", "targetname");
			tankgroup1[i] attachpath(node);
			tankgroup1[i] startpath();
			tankgroup1[i] mgoff();
		}
	}
			//**TEMP - no compass ent for tiger
	gulch_tiger = getent("gulch_tiger", "targetname");
	gulch_tiger RemoveVehicleFromCompass();

	
	wait 4;
	
	enemies = getentarray("gulch_convoy_riders", "script_noteworthy");
	wait_n_kill_array(enemies, 10);
	wait 10;
	
			// spawn in troops
	spawners = getentarray("gulch_floods", "targetname");	
	maps\_spawner::flood_spawner_scripted(spawners);	
	wait 1;
	maps\_spawner::kill_spawnernum(20);
		
			// wait till tanks get into the gulch a bit, then have the objective to fall back, and have 
			// friendlies run back as well
	level thread tank_blow_house();
	level.newhero enable_ai_color();
	iprintln ("Tanks!");
			// send friendlies to next chain at flak
	trig = getent("fallback_flak_positions", "targetname");
	trig thread trigger_and_delete();
	objective_control(9);
	iprintln ("Fall back to the 88!  We can hold the Panzers from there!");

	//level thread flak_mg_nosight_toggle();
	
			// turns on a flood spawner in the flak area
	getent("flak_defense_trig", "script_noteworthy") trigger_on();


		
			// wait till tanks hit end of gulch path, then connect em on next path into camp
	wait 1;
			// make sure friendlies don't stop and fight in the face of the big german push
	array_thread(getaiarray("allies"), ::squad_ignoreall_till_nearflak);
	
	level thread tanks_enter_camp();
	//level thread friendlies_stuck_ingulch();
		
			//  Moving gulch spawners up so they get to the player quicker

	
			// start thread to call the tiger in through the woods 
	level thread event4_tigers_close_in();		
	
	wait 1;
}
	
squad_ignoreall_till_nearflak()
{
	self endon ("death");
	self.ignoreall = true;
	self.ignoreme = true;
	while (self.origin[1] > 9900)
	{
		wait 1;
	}
	self.ignoreall = false;
	self.ignoreme = false;
}
	
		// takes a vehicle wait node, waits for (self) to hit it, sets (self) on new given path
vehicle_reaquire_path(waitnodename, newnodename)
{
	if (self.health > 0)
	{
		wait_node = getvehiclenode(waitnodename, "targetname");
		wait 1;
		self setwaitnode(wait_node);
		self waittill ("reached_wait_node");
		new_path = getvehiclenode(newnodename, "targetname");
		self attachpath(new_path);
		self startpath();
	}
}


	
		// set (self) tank mg's to shoot for given seconds out of every 10  seconds
		// pretty sure it's not working anymore
gulch_panzer_mg(shoot_time)
{
	/*
	tanktarget = 1;
	self endon("death");
	self endon("stop_mg");
	while (isalive(self))
	{
		if (tanktarget ==1)
		{
			for (i=0; i<self.mgturret.size; i++)
			{
				self mgoff();
			}
			wait (10-shoot_time);
			tanktarget =2;
		}
		else if (tanktarget ==2)
		{
			for (i=0; i<self.mgturret.size; i++)
			{
				self mgon();
			}
				wait (shoot_time);
				tanktarget =1;
		}
	}
	*/
}

convoy_stop_animation()
{
	wait 12;
	if (isalive(self))
	{
		self clearanim(%root, 1);
	}
}

			// this controls events once the tanks have come into town and the flak gets destroyed							
event4_tigers_close_in()
{
	
			// these few lines trigger and control entranceguys and tank.  Turning it on now in case player 
			//tries to cheese it out by running back early
	trig = getent("waitfor_entranceguys_trig", "targetname");
	trig trigger_on();
		
			// wait a bit for the woods tiger to come in after panzer enters camp, get the flak to set as target
	// speedy E4
	wait 60;
	// speedy E4
	wait 15;
	gulch_tiger = getent("gulch_tiger", "targetname");
	my_flak = getent("my_flak", "targetname");
		
			//  spawn in the woodstiger, grab the node for the tiger to stop and fire
	scripted_spawn_go(4);
	wait 0.3;
	woodstiger = getent("woods_tiger", "targetname");
	woodstiger startpath();
	woodstiger_knock_node = getvehiclenode("woodstiger_knock_node", "targetname");
	woodstiger setwaitnode(woodstiger_knock_node);
	woodstiger waittill ("reached_wait_node");
	level thread falling_tree();
	//level thread woodstiger_tree_knockover();
	wait 0.2;
	woodstiger_firenode = getvehiclenode("woods_tiger_firenode", "targetname");
	woodstiger setwaitnode(woodstiger_firenode);
	woodstiger waittill ("reached_wait_node");
	woodstiger setspeed (0,10,10);
	level thread floored_at_flak(my_flak);
	my_flak.health = 1;
					// blow up the flak, then target the player with tiger.  
	woodstiger setTurretTargetEnt(my_flak, (0,0,90));
	woodstiger joltbody (woodstiger.origin+(0,0,20), 0.5);
	playfxontag(level._effect["tiger_fakefire"], woodstiger, "tag_flash");
	wait 0.1;
	user = my_flak getvehicleowner();
	if (isdefined(user))
	{
		my_flak useby(user);
	}
	my_flak makevehicleunusable();
	wait 0.1;
	my_flak.health = 1;
	org = my_flak.origin;

	players = get_players();
	for (i=0; i < players.size; i++)
	{
		dist = distance(org, players[i].origin);
		if (dist < 200)
		{
			players[i] thread shock_me("death", 5);
			players[i] EnableInvulnerability();
		}
	}
	radiusdamage(my_flak.origin, 50, 6, 4);
	wait 0.1;
	for (i=0; i < players.size; i++)
	{
		players[i] DisableInvulnerability();

	}
	woodstiger clearturrettarget();
	flag_set("e4_flakfight_over");
	iprintln ("Crikies!  No use staying here lads, retreat to the Church!");
			// warp in the friendly chain
	trig = getent("graveyard_fallback_pos", "targetname");
	trig thread trigger_and_delete();
	flak_flankers = getentarray("flak_flank_guys", "targetname");
	dospawn_array(flak_flankers);
	
			// have 2nd tiger start shooting at player
	woodstiger thread gulch_panzer_mg(3);

			// NEXT main thread
	event4_entranceguys_come();
}

floored_at_flak(flak)
{
	org = flak.origin;
	flak waittill ("death");
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		dist = distance(org, players[i].origin);
		if (dist < 350)
		{
			players[i] thread shock_me("death", 5);
		}
	}
}

		// takes in a turret offset and time for the main turret on (self) tank to shoot at player
tanks_luv_you(offset, shoottime)
{
	self notify ("stop_turret");
	self endon("stop_turret");
	self endon("death");
	level.shootingguy = true;
	while (isalive(self))
	{
		cantanksee = false;
		players = get_players();
		tanktarget = players[randomint(players.size)];
		if (self.health > 0) 
		{
			self setTurretTargetEnt (tanktarget, (randomint(offset) - randomint(offset), randomint(offset) - randomint(offset), randomint(offset) - randomint(offset)));
		}
		wait shoottime;
		if (self.health > 0) 
		{
			self fireweapon();
		}
		if (self.health > 0) 
		{
			self clearturrettarget();	
		}
	}
}


		// checks if player blew the ambush by firing, throwing a grenade early, or running up onto the road		
event4_didplayer_gunjump()
{
	//level thread right_lane_pullovers();
	//level thread left_lane_pullovers();
	
	level thread event4_gunjump_loop();

	
			// eventually the player will shoot his weapon etc.
			// However if the player waited until the ambush started, this flag will be set and it will be fine
			// if he jumped the gun early, the convoy ownage thread will basically have the convoy own the player

	convoy_ownage();
	
}

		// checks if player screwed the ambush by shooting or throwing grenade
event4_gunjump_loop()
{
	level endon ("gulch_ambush_started");
	level endon ("dynamite_ready");
	players = get_players();
	array_thread(players, ::waitfor_player_attack, "jump_the_gun");
	level waittill ("jump_the_gun");
	flag_set ("jump_the_gun");
	iprintlnbold("You alerted the convoy to the ambush");
	missionfailed();
}



		// player ruined the element of suprise, now the whole convoy wakes up and lays waste to squad
convoy_ownage()
{
	level endon ("gulch_ambush_started");
	level waittill ("jump_the_gun");
	iprintln ("Wilkins!  What the hell are you doing!  I said hold your fire!");
	//if (level.kubel2_pos == 6)
	//{
	//	flag_wait("truck2here");
	//}
	
	/*convoy = getentarray("gulch_convoy", "script_noteworthy");
	for (i=0; i < convoy.size; i++)
	{
		convoy[i].unload_group = "all";
		convoy[i] notify ("unload");
	}
	*/
	vehicles = getentarray("gulch_convoy", "script_noteworthy");
	for (i=0; i < vehicles.size; i++)
	{
		vehicles[i] notify ("unload");
	}
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		guys[i].pacifist = false;
		guys[i].script_sightrange = 4000000;
		guys[i].maxsightdistsqrd = 4000000;
		guys[i].ignoreme = false;
		guys[i].allowdeath = true;
		guys[i].accuracy = 1;
	}
	sdk = getent("2nd_truck", "targetname");
	sdk thread sdk_luv_you(1);
	wait 0.1;
	level waittill("dynamite_blown");
	flag_set("gulch_ambush_started");
	level notify ("gulch_ambush_started");
}

//ambush_ruined()

	


		// in case player didn't run to eastend of camp, they come anyway after this amount of time
event4_timed_entranceguys()
{
	wait 30;
	getent("waitfor_entranceguys_trig", "targetname") notify ("trigger");
}


		// this kicks off after the flak is destroyed and controls gameplay up to the graveyard
event4_entranceguys_come()
{
	level thread event4_timed_entranceguys();
			// wait a bit while player takes in the situation, then give the objective to retreat
			// give player objective to retreat to south end of camp
	objective_control(10);
				
		 	// wait a few seconds as player takes in situation, then get order to fall back to graveyard
	trig = getent("church_steeple_trig", "targetname");
	trig trigger_on();
	gulch_tiger = getent("gulch_tiger", "targetname");
	gulch_tiger notify ("stop_shootin_u");
	if (isdefined(trig)) trig waittill ("trigger");
	spot = getent("church_tower_exp_spot", "targetname");
	gulch_tiger setturrettargetent(spot, (0,0,0));
	wait 1.5;
	level thread churchtower_blown();
			//  This process controls the steepl getting shot off
	wait 0.1;
	earthquake (0.3, 2,get_players()[0].origin, 400); 

	
	trig2 = getent("waitfor_entranceguys_trig", "targetname");
	trig2 waittill ("trigger");
	earthquake (0.2, 2,get_players()[0].origin, 400); 
	
	wait 1;
	iprintln ("Bloody hell, the bastards are everywhere! ");
	gravetrig = getent("graveyard_wave", "script_noteworthy");
	gravetrig trigger_on();
	wait 4;
	iprintln ("We're cut off, fall back to the graveyard before you get cut to pieces!");


	objective_control(11);
		

	wait 2;
	maps\_spawner::kill_spawnernum(14);
	enemies = getentarray("die_b4_graveyard", "script_noteworthy");
	level thread wait_n_kill_array(enemies, 7);
	
	event4_savetheday();
}
		

		
		// after tank blows whole in graveyard wall, this send axis guys in the area into the graveyard to push
		// you even further back
axis_flood_graveyard()
{
	for (;;)
	{
		guys = getaiarray("axis");
		nodes = getnodearray("final_push_into_graveyard_nodes", "script_noteworthy");
		nodecounter = 0;
		for (i=0; i <  guys.size; i++)
		{
			if (isalive(guys[i]))
			{
				place = guys[i].origin;
				if (place[1] < 10000 && place[1] > 7500)
				{
					guys[i] thread maps\_spawner::go_to_node(nodes[nodecounter]);
					nodecounter++;
					if (nodecounter == 7)
					{
						break;
					}
				}
			}
		}
		wait 3;
				// if the planes have come in to blow everyone off, breaks the thread so remaining axis retreat
		if (flag("planes_came"))
		{
			break;
		}
	}
}	

event4_airstrike_test()
{			
	skipto_trigs_off();
	pre_event4_trigs_off();
	players = get_players();
	event4_players_start = getentarray("event4_players_start", "targetname");
	for (i=0; i < players.size ; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin);
		players[i] setplayerangles( event4_players_start[i].angles);
	}
	
	wait 20;
	my_flak = getent("my_flak", "targetname");
	user = my_flak getvehicleowner();
	if (isdefined(user))
	{
		my_flak useby(user);
	}
	my_flak makevehicleunusable();
	iprintlnbold("should be off");
	wait 0.1;
	my_flak.health = 1;
	org = my_flak.origin;
	get_players()[0] thread shock_me("death", 5);
	get_players()[0]EnableInvulnerability();
	radiusdamage(my_flak.origin, 50, 6, 4);
	wait 0.1;
	get_players()[0]DisableInvulnerability();
	
	
	level.radioguyspawner = getent("radio_guy", "targetname");
	level.radioguy = level.radioguyspawner stalingradspawn();
	level.radioguy thread magic_bullet_shield();
	level.radioguy enable_ai_color();
	level.radioguy.isplayingsound = true;
	level.rocket_barrage_allowed = true;
	
	wait 10;
	blowspot1 = getstruct("hq_blows", "targetname");
	playfx (level._effect["satchel_house_1"], blowspot1.origin, anglestoforward(blowspot1.angles));
	blowspot2 = getstruct("hq_blows2", "targetname");
	playfx (level._effect["satchel_house_2"], blowspot2.origin, anglestoforward(blowspot2.angles));
	blowspot3 = getstruct("dynamite_effect_in_hq", "targetname");
	playfx(level._effect["road_dynamite"], blowspot3.origin);
	
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		/*dist = distance(players[i].origin, blowspot2.origin);
		if (dist > 2000)
			dist = 1900;
		
		num = 2000 - dist;
		scale = (num / dist) / 2;
	*/	
		earthquake(0.5, 2, blowspot2.origin, 2000);
	}
	flag_set("stopstar_onsarge");
	maps\hol2_event3::destroy_hq_roof();
}

	
		
		// This waits a given time, then starts the objective to throw smoke for the planes, which destroy
		// all the bad men and end the level
event4_savetheday()
{

	
	woods_tiger = getent("woods_tiger", "targetname");
	tiger = 			getent("gulch_tiger", "targetname");
	node = 										getvehiclenode("gulchtiger_inplace_node", "script_noteworthy");
	woodsnode = 							getvehiclenode("woodstiger_inplace_node", "script_noteworthy");
	woodsnode thread waittill_trig_n_setflag("woodstiger_inplace", woods_tiger);
	node		  thread waittill_trig_n_setflag("gulchtiger_inplace", tiger);
	tiger thread tiger_in_loop_flag();
	woods_tiger thread speed_up_woodstiger();
	
	
	gulch_panzer = getent("gulch_panzer", "targetname");
	if (isdefined(gulch_panzer) && gulch_panzer.classname == "script_vehicle" && gulch_panzer.health > 0)
	{
		gulch_panzer setspeed(2,5,5);
	}
	
	level thread player_hunter();
	wait 4;
	trig = getent("graveyard_save", "script_noteworthy");
	trig trigger_on();
	spawners = getentarray("graveyard_attackers", "targetname");
	maps\_spawner::flood_spawner_scripted(spawners);

					
	graveyard_check = getent("in_graveyard_now_trig", "targetname");
	graveyard_check trigger_on();
	graveyard_check waittill ("trigger");
	wait 10;
	// speedy E4
	graveyard_check delete();
	
	// speedy E4
	iprintln("This is Red Squadron, We're above your position but we're going to need you to mark your targets");
	wait 5;
	iprintln("Press Right on the D-pad to call in air support");
	
			// control new objective to throw smoke, get the position of objective
	objective_control(12);
			
			// turn on use trigger to throw smoke, waittill its used, throw the smoke
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] giveweapon("rocket_barrage");
	}
	level.radioguy = spawn("script_origin", (0,100,0));
	level.radioguy.isplayingsound = true;
	level.rocket_barrage_allowed = true;
	level thread dpad_reminder();
	
	if (tiger.health > 1)
	{			
		tiger thread blow_gravestones();
	}
	wait 10;


	//tiger thread tanks_luv_you(200, 11);

	if (isdefined(woods_tiger) && woods_tiger.classname == "script_vehicle" && woods_tiger.health > 1)
	{		
		woods_tiger setspeed(1,5,5);	
		flag_wait("woodstiger_inplace");
		emptyarray= [];
		tree = getent("falling_tree", "targetname");
		level thread maps\_anim::anim_ents( emptyarray, "tree_falling", undefined, undefined, tree, "tree_fall" );
		tree delete();
		woods_tiger thread blow_gravestones();
		woods_tiger thread gulchtiger_speed_loop();
	}

	getent("graveyard_wave", "script_noteworthy") trigger_off();
	wait 3;


	getent("graveyard_second_fallback_pos", "targetname") thread trigger_and_delete();
	
	if (isdefined(tiger)&& tiger.classname == "script_vehicle" && tiger.health > 0)
	{
		tiger waittill ("death");
	}
	if (isdefined(woods_tiger) && woods_tiger.classname == "script_vehicle" && woods_tiger.health > 0)
	{
		woods_tiger waittill ("death");
	}

	if (isdefined(gulch_panzer) && gulch_panzer.health > 0)
	{
		gulch_panzer waittill ("death");
	}
	
	level notify ("e5_tanks_dead");
			// grab all the vehicles i want to blow up
	maps\_spawner::kill_spawnernum(15);
	
	enemies3 = getaiarray("axis");
	level thread survivors_retreat(enemies3);
	
				// FIN
	wait 12;
	iprintln ("They're retreating!  Thank bloody God!");
	wait 6;
	iprintln ("No, thank the bloody RAF!  Back on your feet, we need to get out of here right quick");
	wait 7;
	nextmission();
}
		
		
dpad_reminder()
{
	level endon ("e5_tanks_dead");
	while (1)
	{	
		dpad_reminder_loop();
	}
}
	
dpad_reminder_loop()
{
	level endon ("airstrike_called");
	wait 75;
	iprintlnbold ("Press right on the D pad to call in air support");
	wait 5;
	iprintln ("Wilkins, target those tanks for the air support!");
}
survivors_retreat(guys)
{
	nodes = getnodearray("level_over_retreat_nodes", "script_noteworthy");
	nodecounter = 0;
	for (i=0; i < guys.size; i++)
	{
		if (isalive(guys[i]) && nodecounter < 18)
		{
			guys[i] thread maps\_spawner::go_to_node(nodes[nodecounter]);
			nodecounter++;
			guys[i].ignoreall = true;
		}
		else if(isalive(guys[i]) && nodecounter >= 18)
		{
			guys[i] dodamage(guys[i].health *10, (0,0,0));
		}
	}
}
		// this controls a group of 3 guys that come clean up the player if he is hiding in a corner somewhere
event4_cleanup_crew()
{
	trig = getent("cleanupcrew_callin", "script_noteworthy");
	trig trigger_on();
	trig waittill ("trigger");
	wait 1;
	for (;;)
	{
		guys = getentarray("event5_cleanup_crew", "script_noteworthy");
		for (i=0; i < guys.size; i++)
		{
			guys[i].goalradius = 100;
			guys[i] SetGoalEntity( get_closest_player() );
			level thread maps\_spawner::delayed_player_seek_think(guys[i]);
		}
		wait 5;
		if (flag("planes_came"))
		{
			break;
		}
	}
}

		// just knocks some trees over on the hill across from the flak
woodstiger_tree_knockover()
{
	wait 6;
	(getent("woodstiger_tree1", "targetname")) rotateroll(90, 1.5, 0.3, .1);
	wait 2;
	(getent("woodstiger_tree2", "targetname")) rotateroll(90, 1.5, 0.3, .1);
	wait 0.5;
	(getent("woodstiger_tree3", "targetname")) rotateroll(90, 1.5, 0.3, .1);
	wait 0.5;
	(getent("woodstiger_tree4", "targetname")) rotateroll(90, 1.5, 0.3, .1);
	iprintln("Tiger on the hill!  GET AWAY FROM THE FLAK!");
}

		// a redshirt is going to be ahead of the squad waving you to retreat, then the tank comes and blows him up
	
		// sets an earthquake on the player	
quake_players()
{
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		earthquake(0.3, 2, players[i].origin, 500);
	}
}
	
		// if for some reason your friendlies are stuck in the gulch in a car or something, this will warp 
		// em up so they move back to the flak properly
friendlies_stuck_ingulch()
{
	for (p=0; p<10; p++)
	{
		guys = getaiarray("allies");
		for (i=0; i < guys.size; i++)
		{
			guy_spot = guys[i].origin;
			if (guy_spot[1] > 11000)
			{
				warpout = getent("warp_out_of_gulch", "targetname");
				guys[i] teleport (warpout.origin, warpout.angles);
				wait 2;
			}
		}
	wait 10;
	}
}


tank_stop_shootin_u()
{
	self.shootingguy = true;
	self waittill("stop_shootin_u");
	self.shootingguy = false;
}
				// turn off trigs that should only be turned off when doing this skipto
skipto_trigs_off()
{
	getent("church_steeple_trig", "targetname") trigger_off();
	getent("waitfor_entranceguys_trig", "targetname") trigger_off();
	getent("flak_defense_trig", "script_noteworthy") trigger_off();
	getent("event4_flak_savetrig", "script_noteworthy") trigger_off();
	getent("graveyard_save", "script_noteworthy") trigger_off();
	getent("graveyard_wave", "script_noteworthy") trigger_off();
	getent("in_graveyard_now_trig", "targetname") trigger_off();
	getent("tank_bust_gate", "targetname") trigger_off();
	getent("temp_player_explosives_trig", "targetname") trigger_off();
	 getent("convoy_arrives_trig", "script_noteworthy") trigger_off();
	getent("flaktrack_trig", "script_noteworthy") delete();
	
	trigs = getentarray("player_reveals_ambush", "targetname");
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] trigger_off();
	}
	wall = getentarray("broken_mg_wall","targetname");
	for (i=0; i < wall.size; i++)
	{
		wall[i] hide();
	}
	maps\_spawner::kill_spawnernum(52);
  //getent("flaktrack_trig", "script_noteworthy") thread trigger_and_delete();


	getent("open_door", "targetname") delete();
	
	dynamite = getentarray("dynamite_models", "script_noteworthy");
	array_thread (dynamite,:: trigger_off);
	getent("ambush_trig_1", "targetname") trigger_off();

	getent("fake_flaktrack", "targetname") trigger_on();
	getent("flakmg_position_nosight", "targetname") trigger_off();
	
	graves_d = getentarray("gravestones_destroyed", "script_noteworthy");
	for (i=0; i< graves_d.size; i++)
	{
		graves_d[i] hide();
	}	
	
}

blow_gravestones()
{
	self endon("death");
	graves = getentarray("gravestones_intact", "script_noteworthy");
	pillars = getentarray("pillars_destroyed", "script_noteworthy");
	walls = getentarray("grave_wall_d", "script_noteworthy");
	graves = array_combine(graves, pillars);
	graves = array_combine(graves, walls);
	level.gravestone_isblowing = false;
	level.graves_blowstatus = [];
	for (i=0; i < graves.size; i++)
	{
		level.graves_blowstatus[i] = false;
		graves[i] thread grave_blow_in_face(self, level.graves_blowstatus[i]);
	}
	while (1)
	{
		graves = getentarray("gravestones_intact", "script_noteworthy");
		pillars = getentarray("pillars_destroyed", "script_noteworthy");
		walls = getentarray("grave_wall_d", "script_noteworthy");
		graves = array_combine(graves, pillars);
		graves = array_combine(graves, walls);
		if (graves.size < 1)
		{
			break;
		}
		wait 5;
	}
	self thread tanks_luv_you(100, 8);
}
	

grave_blow_in_face(tank, num)
{
	tank endon ("death");
	self endon ("death");
	gravespot = self.origin;
	endthread = false;
	counter = 0;
	for (;;)
	{
		players = get_players();
		for (x=0; x < players.size; x++)
		{
			players_spot = players[x].origin;
					// checks if the player is within certain radius of gravestone
			check_x_axis1 = gravespot[0] - players_spot[0];
			check_x_axis2 = players_spot[0] - gravespot[0];
			check_y_axis1 = gravespot[1] - players_spot[1];
			check_y_axis2 = players_spot[1] - gravespot[1];
			if((((( check_x_axis1 < 200 && check_x_axis1 > 0) || ( check_x_axis2 < 200 && check_x_axis2 > 0))
			&& 		( check_y_axis1 < 200 && check_y_axis1 > 0)) 
			|| (self.script_noteworthy == "grave_wall_d")
			|| (counter > 7) 														)
			&&		level.gravestone_isblowing == false)
			{
				tank setturrettargetent(self, (0,0,10));
				level.gravestone_isblowing = true;
				level.graves_blowstatus[num] = true;
				level thread makesure_stone_blows(self, num);
				wait randomintrange(7,12);
				playfxontag(level._effect["tiger_fakefire"], tank, "tag_flash");
				tank joltbody (tank.origin+(0,0,20), 0.5);
				wait 0.05;
				playfx (level._effect["grave_blow"], self.origin);
				d_vers = getent(self.targetname+"_d", "targetname");
				if (isdefined(d_vers))
				{
					d_vers show();
				}
				earthquake(0.1, 1, get_players()[0].origin, 300);
				endthread = true;
				if (self.script_noteworthy == "pillars_destroyed")
				{
					otherpillars = getentarray("pillars_destroyed", "script_noteworthy");
					for (i=0; i < otherpillars.size; i++)
					{
						dist = distance(otherpillars[i].origin, self.origin);
						if (dist <150 && self != otherpillars[i])
						{
							otherpillars[i] delete();
						}
					}
				}
				level.gravestone_isblowing = false;
				level.graves_blowstatus[num] = false;
				self delete();
				break;
			}
		}
		if (endthread == true)
		{
			break;
		}
		wait 1;
		counter++;
		if (counter > 10)
		{
			counter = 0;
		}
	}
}

makesure_stone_blows(thing, num)
{
	wait 14;
	if (!isdefined(thing) && level.graves_blowstatus[num] == true)
	{
		level.gravestone_isblowing = false;
	}
}


dropbombs_and_quake()
{
	self waittill("trigger");
	wait 0.7;
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		earthquake(0.4, 2, players[i].origin, 500);
	}
}

	
enemy_wave_control(spawners)
{
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] dospawn(spawners[i].targetname+"_spawned");
	}
	spawned = getentarray(spawners[i].targetname+"_spawned", "targetname");
	while(spawned.size > 1)
	{
		wait 1;
	}
}
	
tanks_target_something(tanktarget,offset, shoottime)
{
	self endon("stop_turret");
	for (;;)
	{
		if (self.health > 0) 
		{
			self setTurretTargetEnt (tanktarget, (randomint(offset) - randomint(offset), randomint(offset) - randomint(offset), randomint(offset) - randomint(offset)));
		}
		wait shoottime;
		if (self.health > 0) 
		{
			self fireweapon();
		}
		if (self.health > 0) 
		{
			self clearturrettarget();	
		}
	}
}

tanks_enter_camp()
{
	panzer1 = getent("gulch_panzer", "targetname");
	panzer1 endon("death");
	node = getvehiclenode("tank_movin_to_town", "targetname");
	wait 0.2;
	node waittill ("trigger");
	tanktarget = getent("tanks_initial_target", "targetname");
	panzer1 thread tanks_target_something(tanktarget, 250, 8);
	node2 = getvehiclenode("panzer_roll_into_town", "targetname");
	wait 0.2;
	node3 = getvehiclenode("own_flak_mg", "targetname");
	node3 waittill ("trigger");
	wait 0.2;
	mg = getent("flak_mg", "targetname") ;
	//wall = getentarray("unbroken_mg_wall", "targetname");
	//broken_wall = getentarray("broken_mg_wall", "targetname");
	panzer1 setturrettargetent(mg, (0,0,0));
	wait 1;
	playfxontag(level._effect["tiger_fakefire"], panzer1, "tag_flash");
	panzer1 joltbody(panzer1.origin + (0,0,20), .5);
	wait 0.1;
	org = mg.origin;
	/*for (i=0; i < wall.size; i++)
	{
		wall[i] delete();
	}
	for (i=0; i < broken_wall.size; i++)
	{
		broken_wall[i] show();
	}
	playfx(level._effect["vehicle_blow"], mg.origin);
	*/
	mg delete();
	playfx(level._effect["snow_exp"], org);
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		dist = distance(org, players[i].origin);
		if (dist < 200)
		{
			players[i] thread shock_me("death", 4);
		}
	}
	
	
	panzer1 thread tanks_target_something(tanktarget, 250, 8);
	spawners = getentarray("flak_flankers", "targetname");
	if (isdefined(spawners) && isdefined(spawners.size) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	panzer1 endon ("death");
	panzer1 setwaitnode(node2);
	wait 0.1;
	panzer1 waittill ("reached_wait_node");
	panzer1 notify ("stop_turret");
	panzer1 thread tanks_luv_you(200, 8);
	panzer1 setspeed (0,5,5);
}

man_the_mg()
{
	flak_defense_trig = getent("flak_defense_trig", "script_noteworthy");
	flak_defense_trig waittill ("trigger");
	spawners = getentarray("2nd_gulch_spawners", "targetname");
	iprintln("Wilkins!  Get on that MG42!");
	wait 10;
	maps\_spawner::flood_spawner_scripted(spawners);

}

turnoff_house_turrets()
{
	mgs = getentarray("house_mgs", "script_noteworthy");
	for (i=0; i < mgs.size; i++)
	{
		mgs[i] delete();
	}
}

temp_dynamite_trig_to_player()
{
	trig = getent("temp_player_explosives_trig", "targetname");
	trig trigger_on();

	iprintln("Wilkins, blow the dynamite now!");
	level thread wait_n_notify(8, "dynamite_failsafe");
	trig waittill ("trigger");
	level notify ("dynamite_blown");
	waittillframeend;
	squad = getaiarray("allies");
	for (i=0; i < squad.size; i++)
	{
		squad[i] allowedstances("stand", "prone", "crouch");
	}
	if (isdefined(trig)) 
	{	
		trig delete();
	}
}

newhero_by_plunger()
{
	level endon("dynamite_blown");
	newhero = grab_ai_by_script_noteworthy("newhero", "allies");
	node = getnode("dynamite_failsafe_node", "targetname");
	newhero.animname = "dynamite_failsafe_guy";
	node anim_reach_solo(newhero, "push_and_blow");
	level waittill ("dynamite_failsafe");
	newhero newhero_plunge();
}

newhero_plunge()
{
	self anim_single_solo(self, "push_and_blow");
	wait 1;
	getent("temp_player_explosives_trig", "targetname") notify ("trigger");
}

tank_blow_house()
{
	panzer2 = getent("gulch_panzer", "targetname");
	panzershot_spot = getstruct("gulch_panzers_first_shot_spot", "targetname");
	panzer2 setturrettargetvec (panzershot_spot.origin);
	wait 1;
	panzer2 fireweapon();
	wait 1;
	node = getvehiclenode("tank_movin_to_town", "target");
	tank = getent("gulch_panzer", "targetname");
	node waittill_trig_n_notify("empty_notify", tank);
	tanks = getentarray("gulch_tanks", "script_noteworthy");
	for (i=0; i < tanks.size; i++)
	{
		tanks[i] setspeed (0,3,3);
	}
	spot = getstruct("ambush_spot1", "targetname");
	tank setTurretTargetvec(spot.origin);
	wait 2;
	tank fireweapon();
	housed = getentarray("ambush_house_d", "targetname");
		playfx(level._effect["vehicle_blow"], spot.origin);
	for (i=0; i < housed.size; i++)
	{
		housed[i] delete();
	}
	while (1)
	{
		players_stillthere = 0;
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i].origin[1] >  10500)
			{
				tank setTurretTargetent(players[i], (0,0,70));
				wait 5;
				tank fireweapon();
				radiusdamage(spot.origin, 150, 200, 85);
				players_stillthere ++;
			}
		}
		if (players_stillthere == 0)
			break;
		wait 1;
	}
	tanks = getentarray("gulch_tanks", "script_noteworthy");
	for (i=0; i < tanks.size; i++)
	{
		tanks[i] resumespeed (5);
	}
	
	tank thread gulch_panzer_mg(3);
	tiger = getent("gulch_tiger", "targetname");
	node = getvehiclenode("tiger_gate_stop", "targetname");
	tank.health = 20;
	
}

gulchtiger_speed_loop()
{
	self endon ("death");
	while (1)
	{
		self setspeed (2,5,5);
		wait (randomint(15));
		self setspeed(0,5,5);
		wait (randomint(17));
	}
}
		
	
flak_mg_nosight_toggle()
{
	nosight = getent("flakmg_position_nosight", "targetname");
	while (!flag("e4_flakfight_over"))
	{
		nosight trigger_on();
		wait (randomint(17));
		nosight trigger_off();
		wait (randomint(5));
	}
}

ai_counter()
{
	while (1)
	{
		axis = getaiarray("axis");
		allies = getaiarray("allies");
		iprintln("Axis: "+ axis.size);
		iprintln("Allies: "+ allies.size);
		iprintln("Total: "+ (allies.size+axis.size));
		wait 1;
	}
}

sdk_luv_you(offset)
{
	self endon("stop_turret");
	self endon("death");
	while (isalive(self))
	{
		players = get_players();
		tanktarget = players[randomint(players.size)];
		self setTurretTargetEnt (tanktarget, (0,0,0));
		wait randomfloat(2);
		shoottime = randomint(50);
		for (i=0; i < shoottime; i++)
			{
			if (isdefined(tanktarget) && isalive(tanktarget))
			self setTurretTargetEnt (tanktarget, (0,0,0));
			wait 0.2;
			self fireweapon();
		}
		self clearturrettarget();	
	}
}

/*right_lane_pullovers()
{
	level endon ("gulch_ambush_started");
	level.kubel2_pos = 0;
	kubel2_watcher();
	if (level.kubel2_pos == 6)
		return;
	flag_set("e4_convoy_notinplace");
	x = level.kubel2_pos+1;
	kubel2 = getent("2nd_kubel", "targetname");
	node = getvehiclenode("kubel2_prepull_"+x, "targetname");
	snode = getvehiclenode("right_pullover_"+x, "targetname");
	kubel2.dontunloadonend = undefined;
	kubel2 setswitchnode(node, snode);
	lane2trucks = [];
	lane2trucks[0] = getent("2nd_lane_truck", "targetname");
	lane2trucks[1] = getent("2nd_lane_truck2", "targetname");
	lane2trucks[2] = getent("2nd_lane_truck3", "targetname");
	
	if (level.kubel2_pos > 0)
	{
		node = getvehiclenode(lane2trucks[0].targetname+"_kubel2_prepull_"+level.kubel2_pos, "targetname");
		snode = getvehiclenode("right_pullover_"+level.kubel2_pos, "targetname");
		lane2trucks[0].dontunloadonend = undefined;
		lane2trucks[0] setswitchnode(node, snode);
	}
	if (level.kubel2_pos > 1)
	{
		y = level.kubel2_pos - 1;
		node = getvehiclenode(lane2trucks[1].targetname+"_kubel2_prepull_"+y, "targetname");
		snode = getvehiclenode("right_pullover_"+y, "targetname");
		lane2trucks[1].dontunloadonend = undefined;
		lane2trucks[1] setswitchnode(node, snode);
	}
	if (level.kubel2_pos > 2)
	{
		y = level.kubel2_pos - 2;
		node = getvehiclenode(lane2trucks[2].targetname+"_kubel2_prepull_"+y, "targetname");
		snode = getvehiclenode("right_pullover_"+y, "targetname");
		lane2trucks[2].dontunloadonend = undefined;
		lane2trucks[2] setswitchnode(node, snode);
	}
	
	if (level.kubel2_pos == 2)
	{
		lane2trucks[2] setspeed(0, 10, 10);
		lane2trucks[2].unload_group = "all";
		lane2trucks[2] notify ("unload");
	}
	
	if (level.kubel2_pos == 1)
	{
		lane2trucks[1] setspeed(0, 10, 10);
		lane2trucks[1].unload_group = "all";
		lane2trucks[1] notify ("unload");
		lane2trucks[2] setspeed(0, 10, 10);
		lane2trucks[2].unload_group = "all";
		lane2trucks[2] notify ("unload");
	}
	
	if (level.kubel2_pos == 0)
	{
		for (i=0; i < lane2trucks.size; i++)
		{
			lane2trucks[i] setspeed(0, 10, 10);
			lane2trucks[i].unload_group = "all";
			lane2trucks[i] notify ("unload");
		}
	}
}
	
left_lane_pullovers()
{
	level endon ("gulch_ambush_started");
	level.kubel1_pos = 0;
	kubel1_watcher();
	if (level.kubel1_pos == 4)
	{
		flag_wait(("truck2here"));
		flag_wait(("jump_the_gun"));
		vehicles = getentarray("gulch_convoy", "script_noteworthy");
		for (i=0; i < vehicles.size; i++)
		{
			vehicles[i].dontunloadonend = undefined;
			vehicles[i] notify ("unload");
		}	
		return;
	}
	flag_set("e4_convoy_notinplace");
	x = level.kubel1_pos+1;
	kubel1 = getent("1st_vehicle", "targetname");
	node = getvehiclenode("kubel1_prepull_"+x, "targetname");
	snode = getvehiclenode("left_pullover_"+x, "targetname");
	kubel1.dontunloadonend = undefined;
	kubel1 setswitchnode(node, snode);
	sdk = getent("2nd_truck", "targetname");
	sdk thread sdk_luv_you(1);
	halftrack = getent("gulch_halftrack", "targetname");

	if (level.kubel1_pos > 0)
	{
		node = getvehiclenode(halftrack.targetname+"_kubel1_prepull_"+level.kubel1_pos, "targetname");
		snode = getvehiclenode("left_pullover_"+level.kubel1_pos, "targetname");
		halftrack.dontunloadonend = undefined;
		halftrack setswitchnode(node, snode);
	}
	else
	{
		halftrack setspeed(0, 10, 10);
		halftrack.unload_group = "all";
		halftrack notify ("unload");
	}
}	
*/
	
kubel2_watcher()
{
	level endon ("jump_the_gun");
	kubel2 = getent("2nd_kubel", "targetname");
	node0 = getvehiclenode("kubel2_prepull_1", "target");
	node0 waittill_trig_n_notify("empty_notify", kubel2);
	node = [];
	for (i=1; i < 7; i++)
	{
		node[i] = getvehiclenode("kubel2_prepull_"+i, "targetname");
		node[i] waittill_trig_n_notify("empty_notify", kubel2);
		level.kubel2_pos ++;
	}
}

	
kubel1_watcher()
{
	level endon ("jump_the_gun");
	kubel1 = getent("1st_vehicle", "targetname");
	node0 = getvehiclenode("kubel1_prepull_1", "target");
	node0 waittill_trig_n_notify("empty_notify", kubel1);
	node = [];
	for (i=1; i < 5; i++)
	{
		node[i] = getvehiclenode("kubel1_prepull_"+i, "targetname");
		node[i] waittill_trig_n_notify("empty_notify", kubel1);
		level.kubel1_pos ++;
	}
}

#using_animtree ("hol2_vehicles");
convoy_do_anim(animname)
{
	
	dupe = getent(self.targetname+"_dupe", "targetname");
	dupe trigger_on();
	dupe.origin = self.origin;
			// TEMP! Take take 90 twist out after anim is fixed
	dupe.angles = self.angles;// + (0,90,0);
	dupe useanimtree(#animtree);
	dupe setflaggedanim( "anim", animname, 1, 0.1, 1 );
	self vehicle_deleteme();
}

convoy_blown_anims()
{
	if (isdefined(self))
	{
		self endon ("death");
	}
	if (self.targetname == "1st_vehicle" && !flag("e4_convoy_notinplace"))
	{
		self thread convoy_do_anim(%v_holland2_german_convoy_HORCH_right);
	}
	if (self.targetname == "2nd_truck" &&!flag("e4_convoy_notinplace"))
	{
		self thread convoy_do_anim(%v_holland2_german_convoy_SDK);
	}
	if (self.targetname == "2nd_kubel" &&!flag("e4_convoy_notinplace"))
	{
		self thread convoy_do_anim(%v_holland2_german_convoy_HORCH_left);
	}
	if (self.targetname == "2nd_lane_truck" && !flag("e4_convoy_notinplace"))
	{
		self thread convoy_do_anim(%v_holland2_german_convoy_OPEL);
	}
	else if (	!flag("e4_convoy_notinplace"))
	{
		self setspeed (70,100,100);
	}
}

churchtower_blown()
{
	chunk1 = getent("church_chunk1", "targetname");
	chunk2 = getent("church_chunk2", "targetname");
	chunk3 = getent("church_chunk3", "targetname");
	chunk4 = getent("church_chunk4", "targetname");
	chunk1.script_linkto = "chunk01_jnt";
	chunk2.script_linkto = "chunk02_jnt";
	chunk3.script_linkto = "chunk03_jnt";
	chunk4.script_linkto = "top_chunk_jnt";
		
	chunks = getentarray("church_chunks", "script_noteworthy");
	tower = getent("tower_about_to_fall", "targetname");
	spot = getent("church_tower_exp_spot", "targetname");	
	playfx(level._effect["steeple_blow"], spot.origin);
		
	level thread maps\_anim::anim_ents( chunks, "tower_falling", undefined, undefined, tower, "churchtower_fall" );
	spot = getent("church_tower_shot_spot", "targetname");
	
	wait 2.6;
	playfx(level._effect["steeple"], spot.origin);
	wait 3;
	tower delete();
}

tiger_in_loop_flag()
{
	self endon ("death");
	flag_wait("gulchtiger_inplace");
	self setspeed (1,5,5);
	node = getvehiclenode("tiger_into_loop", "targetname");
	wait 0.2;
	self setwaitnode(node);
	wait 0.2;
	self waittill ("reached_wait_node");
	flag_set("gulchtiger_inloop");
	self thread gulchtiger_speed_loop();
}


falling_tree()
{
	emptyarray = [];
	tree1 = GetEnt( "falling_tree1", "targetname" );
	tree2 = GetEnt( "falling_tree2", "targetname" );
	tree3= GetEnt( "falling_tree3", "targetname" );
	level thread maps\_anim::anim_ents( emptyarray, "tree_falling", undefined, undefined, tree1, "tree_fall" );
	tree1 delete();
	wait 2.1;
	level thread maps\_anim::anim_ents( emptyarray, "tree_falling", undefined, undefined, tree3, "tree_fall" );
	tree3 delete();
	wait 0.8;
	level thread maps\_anim::anim_ents( emptyarray, "tree_falling", undefined, undefined, tree2, "tree_fall" );
	tree2 delete();
}

convoy_crawlers()
{
	self endon ("death");
	self.allowdeath = true;
	self.animname = "stunned_guys";
	self thread anim_loop_solo(self, "crawl1", undefined, "death");
	thread wait_n_kill(self, randomfloat(10));
}

player_hunter()
{
	wait 180;
	spawners = getentarray("graveyard_attackers", "targetname");
	for (i=0; i < spawners.size;i++)
	{
		if (!isai(spawners[i]))
		{
			spawners[i] add_spawn_function(::player_hunter_go);
		}
	}
}
	
player_hunter_go()
{
	players = get_players();
	self setgoalentity(players[randomint(players.size)]);
}

speed_up_woodstiger()
{
	self endon ("death");
	tiger = getent("gulch_tiger", "targetname");
	tiger waittill ("death");
	if (!flag("woodstiger_inplace"))
	{
		self setspeed (5,5,5);
	}
}