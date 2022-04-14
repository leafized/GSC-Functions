

#include maps\hol2; 
#include maps\_utility;
#include common_scripts\utility; 
#include maps\_anim; 
#include maps\_vehicle; 
#using_animtree("generic_human");


event1_setup()

{				
			// set up squad
	level.maddock = getent("actor_ally_brit_hol_maddock", "classname");
	level.maddock.name = "Sgt. Maddock";
	squad = getaiarray( "allies" );		
	
			// set up event global vars
	level.convoy_delete_counter = 0;

		// set fog
	maps\hol2_fx::event_1_amb();
	
		//set friendlies to pacifist and crouching against wall
	for (i=0; i < squad.size; i++)
	{
		if (isalive(squad[i]))
		{
			squad[i] allowedstances ("crouch");
		}
	}
	thread do_set_pacifist(squad, true);
	
			// take players weapons, keep him in place
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] thread take_then_give_weapons();
	}
	spawners = getentarray("initial_convoy_guys", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] add_spawn_function(::solo_set_pacifist, true);
	}
	
	getent("first_trucks_go", "targetname") thread trigger_and_delete();
	
	
	level waittill ("introscreen_complete");
	wait_for_first_player();
	
			// reduce plaer speed to keep squad ahead
			// **TEMP - hopefully we can get AI sprinting so that such a drastic speed reduction isn't neccessary
	array_thread(players, ::player_speed_set, 150,1);

			// **TEMP text for VO
	iprintln("Shh.. Stay down and keep quiet");
	
			// Get this level started with all sorts of fun threads
	level thread event1_trigs_off();
	level thread trucks_stop_at_checkpoint();	
	level thread campfire_guys_setup();
	level thread event1_discover_campfire_guys();
	level thread campfire_guys_dead();
	level thread event1_2ndbridge();
	level thread wait_for_convoy_gone();
	trig = getent("E1_C1_weary_soldiers", "target");
	trig thread killspawner_after_trig(60);
		
			// sets up the guys walking with convoy
	guys = getentarray("E1_C1_weary_soldiers", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i]	add_spawn_function(::walk_of_shame);
		guys[i] add_spawn_function(::solo_set_pacifist,true);
	}
			// delete triggers on use i won't need
	getent("attack_at_campfire_trig", "targetname") thread delete_trig_onuse();
	
			// first objective thing and next function
	level thread objective_control(0);
	squad_setup(squad);
	event1_squad_moveup();
}
		// take weapons from player while first vehicles pass
take_then_give_weapons()
{
	self disableweapons();
	wait 2;
	self setstance("crouch");
	self allowstand(false);
	/*spot = spawn("script_origin", self.origin);
	if (self == get_players()[0])
	{
				//**TEMP hackey, player was getting linked too high
		spot = spawn("script_origin", (-3908.5, -7153.99, -192.075));
		self playerlinktodelta(spot, undefined, 1.0);
	}
	else
	{
		self playerlinktodelta(spot, undefined, 1.0);
	}	
	*/

	level waittill ("moving_from_start");
	self enableweapons();
	self allowstand(true);
	self unlink();
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] takeweapon("rocket_barrage");
	}
}
	
		// sets up the walking guys on the road
walk_of_shame()
{
	self endon ("death");
	self.allowdeath = true;
	self.pacifist = true;
	wait randomfloat(.7);
	self.animname = "road_walkers";
	self.goalradius = 64;
	wearywalks = [];
	wearywalks[0] = "weary_walk2";
	wearywalks[1] = "weary_walk2";
	wearywalks[2] = "weary_walk3";
	wearywalks[3] = "weary_walk4";
	wearywalks[4] = "weary_walk1";
	self thread set_run_anim( wearywalks[randomint(4)]);
	self waittill ("goal");
	self delete();
}	
	
		// controls gameplay when squad starts moving at start of level
event1_squad_moveup()
{
	wait 6;
			// squad gets up and moves
	allies = getaiarray("allies");
	allies set_stances("stand");
			// color trig
	trig = getent("movealong_road_trig", "targetname");
	trig thread trigger_and_delete();
	
			//**TEMP text for VO
	iprintln("Alright lets move");
	level notify ("moving_from_start");
	getent("sarge_blocking", "targetname") delete();
	wait 3;
	iprintln("The German 4th army is falling back along this road");
	wait 2;
	wait 3;
	iprintln("So they haven't blown the bridges yet, but they will within the next few hours");
	wait 7;
	iprintln("We'll secure the bridges, diffuse any explosives, and our convoy should be through here by dawn");
}


		// sets up the guys around the barrel fire.  Before it was a barrel fire, it was a campfire
		// Hence the name.
campfire_guys_setup()
{
	trig = getent("campfire_guys_spawner", "script_noteworthy");
	trig waittill ("trigger");
	wait 0.1;
	maps\_spawner::kill_spawnernum(30);
	wait 0.1;
	firespot = getstruct("campfire_pos", "targetname");
	
			// animate barrelfire guys
	for (i=0; i < 3; i++)
	{
		badguy = getent("campfire_guy"+i, "script_noteworthy");
		badguy.allowdeath = true;
		badguy.pacifist = true;
		badguy.animname = "ev1_campfireguy";
		firespot thread anim_loop_solo(badguy, ("warmup_"+i), undefined, "death");
	}
	
			//alert campfire guys if player attacks
			//**TEMP - pending cod4 stealth scripts
	players = get_players();
	array_thread (players, ::event1_fightstart_by_shoot);
	level thread wake_up_campfire_guys();
}


event1_road_convoy()
{
		players = get_players();
		
		scripted_spawn_go(10);
		getent("b2_soldierwalk_trig", "script_noteworthy") trigger_on();
		wait 0.3;
		level thread main_convoy_wakeup();
		convoy = getentarray("road_convoy_vehicles", "script_noteworthy");
		for (i=0; i < convoy.size; i++)
		{
			if (convoy[i].classname == "script_vehicle")
			{
				convoy[i] thread mgoff();
				convoy[i] thread restart_back_onpath();
			}
		}
 	 wait 11;
 	 scripted_spawn_go(13);
 	 wait 0.3;
 	 convoy = getentarray("road_convoy_vehicles2", "script_noteworthy");
		for (i=0; i < convoy.size; i++)
		{
			if (convoy[i].classname == "script_vehicle")
			{
				convoy[i] thread mgoff();
				convoy[i] thread restart_back_onpath2();
			}
		}

}

kill_bomb_arming_guy()
{
	guy = grab_ai_by_script_noteworthy("bomb_arm_guy", "axis");
	guy waittill ("death"); 
	level notify ("convoy_end");
}

restart_back_onpath()
{
	loopnode = getvehiclenode("loop_it_here", "targetname");
	myname = self.targetname;
	wait 0.5;
	truck = get_true_vehicle(myname, "targetname");
	truck startpath();
	for (;;)
	{
		wait 0.2;
		node = getvehiclenode("last_road_node_bf_field", "targetname");
		truck setwaitnode(node);
		wait 0.2;
		truck waittill_either ("reached_wait_node", "delete_path");
		if(flag("event1_stop_convoy") && isdefined(truck))
		{
			truck thread covoy_deletes_properly();
			waittillframeend;
			break;
		}
		truck attachpath(loopnode);

		wait 0.1;
		truck startpath();
	}
}

restart_back_onpath2()
{
	level.convoy2loops = 0;
	loopnode = getvehiclenode("loop_it_here_2", "targetname");
	myname = self.targetname;
	wait 0.5;
	truck = get_true_vehicle(myname, "targetname");
	truck startpath();
	for (;;)
	{
		wait 0.2;
		node = getvehiclenode("last_road_node_bf_field", "targetname");
		truck setwaitnode(node);
		wait 0.2;
		truck waittill_either ("reached_wait_node", "delete_path");
		if(flag("event1_stop_convoy"))
		{
			truck thread covoy_deletes_properly();
			waittillframeend;
			break;
		}
		truck attachpath(loopnode);
		wait 0.1;
		truck startpath();
		waittillframeend;

		if (self.targetname == "road_convoy2_1")
		{
			level.convoy2loops ++;
		}
		if (level.convoy2loops > 10)
		{
			truck thread covoy_deletes_properly();
			waittillframeend;
			break;
		}
	}
}



covoy_deletes_properly()
{
	if (isdefined(self) && isdefined(self.classname) && self.classname != "script_vehicle")
		return;
	node = getvehiclenode("very_last_road_node", "targetname");
	self setwaitnode(node);
	wait 0.1;
	self waittill ("reached_wait_node");
	//node waittill_trig_n_notify("empty_notify", self);
	if (isdefined(self))
		self vehicle_deleteme();
	level.convoy_delete_counter ++;
	if (level.convoy_delete_counter > 5)
	{
		imwalkinhere = true;
		while (imwalkinhere == true)
		{
			imwalkinhere = false;
			guys = getentarray("E1_C1_weary_soldiers", "script_noteworthy");
			for (i=0; i < guys.size; i ++)
			{
				if (guys[i].origin[0] > 1400)
				{
					imwalkinhere = true;
				}
			}
			wait 1;
		}
		
		level notify ("main_convoy_past");
	}
	road_safe = false;
	while (road_safe == false)
	{
		road_safe = true;
		vehicles = getentarray("road_convoy_vehicles", "script_noteworthy");
		vehicles2 = getentarray("road_convoy_vehicles2", "script_noteworthy");
		vehicles = array_combine(vehicles, vehicles2);
		for (i=0; i < vehicles.size; i++)
		{
			if (vehicles[i].origin[0] > 1400)
			{
				road_safe = false;
			}
		}
		wait 1;
	}
}

event1_fightstart_by_shoot()
{
	self thread waitfor_player_attack("campfire_fightstart");
	level thread event1_fightstart_by_trig();
}	

event1_fightstart_by_trig()
{
	trig = getent("wake_campfire_guys", "targetname");
	trig waittill ("trigger");
	level notify ("campfire_fightstart");
}

wake_up_campfire_guys()
{
	level waittill ("campfire_fightstart");
	badguys = getaiarray("axis");
	for (i=0; i < badguys.size; i++)
	{
		if (badguys[i].origin[1] < -7400)
		{
			badguys[i] thread solo_set_pacifist(false);
		}
	}
	//getent("campfire_guys_goto_nodes", "targetname") thread trigger_and_delete();
	allies = getaiarray("allies");
	do_set_pacifist(allies, false);
}

		// Sets up and controls approach to barrelfire checkpoint
event1_discover_campfire_guys()
{
	trig = getent("see_campfire_guys", "targetname");
	trig waittill ("trigger");
	for (;;)
	{
		if (level.maddock.origin[0] > 100)
		{
			break;
		}
		wait 0.5;
	}
	wait 1.5;
	iprintln("We got a Jerry checkpoint- down there.  Follow me, guns silent, wait for my mark");
	
			// delete trucks at the end of their path
	trucks = getentarray("initial_convoy_trucks", "script_noteworthy");
	array_thread(trucks, ::delete_first_convoy);
	
	wait 1.5;


	getent("sarge_to_campfire_trig", "targetname") thread trigger_and_delete();
	wait 1;
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] thread cqbwalk_to_campfire();
	}
	getent("squad_to_campfire_trig", "targetname") thread trigger_and_delete();

	level thread squad_moveup_to_campfire();
}
	
bomb1_trigger()
{
	trig = getent("diffuse_first_bomb_trig", "targetname");
	trig waittill ("trigger");
	getent("dont_forget_to_disarm", "targetname") delete();
	flag_set("bomb1_diffused");
	trig delete();
	getent("bridge1_bomb", "targetname") delete();
}
	
		// controls gameplay for difussing bridge1 bomb
campfire_guys_dead()
{
	level thread bomb1_trigger();
	level waittill_aigroupcleared("campfire_guys");
	level notify ("campfire_guys_dead");
	getent("under_bridge1_chain", "targetname") thread trigger_and_delete();
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{	
		allies[i] set_sneak_walk(false);
		allies[i] clearentitytarget();
	}
	do_set_pacifist(allies, true);
	wait 4;
	maps\hol2_fx::event_1_amb_1();
	level thread objective_control(1);
	if (!flag("bomb1_diffused"))
	{
		iprintln("Those Jerry's were on duty to blow this bridge.  Wilkins, dismantle these explosives");
	}
	flag_wait("bomb1_diffused");
	level notify ("a_bomb_was_diffused");
	level thread event1_road_convoy();
	getent("bridge2_save", "script_noteworthy") trigger_on();
	getent("activity_on_road_trig", "targetname") trigger_on();
	getent("sarge_kill_nazi_engineer", "targetname") trigger_on();
	getent("move_to_second_bridge_trig", "targetname") thread trigger_and_delete();
	level thread squad_gets_down();
	level thread sarge_kill_bridgebomber();
	level thread player_kill_bridgebomber();
}

squad_gets_down()
{
	allies = getaiarray("allies");
	do_set_pacifist(allies, true);
	trig = getent("activity_on_road_trig", "targetname");
	trig waittill ("trigger");
	iprintln("Activity on the road ahead.  Stay low");
	allies = getaiarray("allies");
	do_set_pacifist(allies, true);
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] set_sneak_walk(true);
	}
	do_set_pacifist(allies, true);
	sarge_knife_that_nazi();
}

sarge_knife_that_nazi()
{
			// anim wasnt put in for some reason, commenting all this out
	level endon ("player_killed_bomber");
	level.maddock disable_ai_color();
	node = getent("sarge_knife_node", "targetname");
	
	nazi = grab_ai_by_script_noteworthy("bomb_arm_guy", "axis");
	nazi.animname = "eng_knifed";
	
	vignette_dudes = [];
	vignette_dudes = array_add(vignette_dudes, level.maddock);
	vignette_dudes = array_add(vignette_dudes, nazi);
	
	getent("wake_engineer", "targetname") thread wait_n_delete(7);
	node anim_reach_solo(level.maddock, "sarge_sneak");
	spawners = getentarray("E1_C1_weary_soldiers2", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] stalingradspawn();
	}
	node anim_single_solo(level.maddock, "sarge_sneak");
	maps\_spawner::kill_spawnernum(85);
	nazi stopanimscripted();
	node anim_single(vignette_dudes, "sarge_knife");
	flag_set("sarge_knifed_nazi");
	level notify ("sarge_killed_bomber");
	nazi.deathanim = level.scr_anim["eng_knifed"]["eng_death"];
	nazi dodamage(nazi.health * 10, (nazi.origin));
	node anim_single_solo(level.maddock, "sarge_kill");

	level.maddock enable_ai_color();
	
}
	
		// turn trigs off !
event1_trigs_off()
{
	trig = getent("player_still_on_road_trig", "targetname") trigger_off();
	getent("activity_on_road_trig", "targetname") trigger_off();
	getent("bridge2_bomb_trig", "targetname") trigger_off();
	getent("sarge_kill_nazi_engineer", "targetname") trigger_off();
	getent("bridge2_save", "script_noteworthy") trigger_off();
	getent("b2_soldierwalk_trig", "script_noteworthy") trigger_off();
}

		// controls gameplay between first and second bridges
event1_2ndbridge()
{
	trig = getent("wake_campfire_guys", "targetname");
	trig waittill ("trigger");
	spawner = getent("bridge2_guy", "targetname");	
	guy = spawner stalingradspawn(); //TW - illegal argument - "bridge2_arming_guy");	
//	guy = getent("bridge2_arming_guy", "targetname");
	guy.pacifist = true;
	guy animscripts\shared::placeweaponOn(guy.weapon, "none");
	guy.animname = "eng_knifed";
	guy.allowdeath = true;
	guy thread give_engineer_weapon();
	node = getent("sarge_knife_node", "targetname");
	node thread anim_loop_solo(guy, "eng_loop", undefined, "death");
	wait 1;
	maps\_spawner::kill_spawnernum(31);
	level waittill_aigroupcleared("2nd_bridge_guy");
	if (!flag("sarge_knifed_nazi"))
	{
		level notify ("player_killed_bomber");
		level.maddock stopanimscripted();
	}
	trig = getent("wake_engineer", "targetname");
	if (isdefined(trig))
		trig delete();
	
	level thread bridge2_diffused();
	if (!flag("bomb1_diffused"))
		flag_wait("bomb1_diffused");
	squad = getaiarray("allies");
	for (i=0; i < squad.size; i++)
	{
		caughtup = squad[i] is_guy_past_coord(1, -3700);
		if (caughtup == true)
			continue;
		if (caughtup == false)
		{
			wait 0.3;
			i = i-1;
		}
	} 
	
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
				//**TEMP no animation for allies staying low so using crouch stace
		allies[i] allowedstances("crouch");
		//allies[i] set_sneak_walk(true);
	}
	getent("take_cover_by_road", "targetname") thread trigger_and_delete();

	if (!flag("bomb2_diffused"))
	{
		iprintln("There's a charge on that bridge.  Disarm it Wilkins");
	}
	flag_wait("bomb2_diffused");
	iprintln("Stay down lads and wait for an opening on the road");
	wait 2;
	squad = getaiarray("allies");
	for (i=0; i < squad.size; i++)
	{
		caughtup = squad[i] is_guy_past_coord(1, -3100);
		if (caughtup == true)
			continue;
		if (caughtup == false)
		{
			wait 0.3;
			i = i-1;
		}
	} 
	flag_set("event1_stop_convoy");
	convoy = getentarray("road_convoy_vehicles", "script_noteworthy");
	convoy2 = getentarray("road_convoy_vehicles2", "script_noteworthy");
	convoy = array_combine(convoy, convoy2);
	for (i=0; i < convoy.size; i++)
	{
		convoy[i] notify ("delete_path");
	}
	level notify ("convoy_end");
	level thread convoy_wave2();
	
	wait 2;
	trig2 = getent("player_standing_by_road", "targetname") delete();
}

bridge2_diffused()
{
	trig = getent("bridge2_bomb_trig", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	flag_set("bomb2_diffused");
	getent("bridge2_bomb", "targetname") delete();
	trig delete();
	level notify ("a_bomb_was_diffused");
	level notify ("bomb2_diffused");
}

is_guy_past_coord(coord, pos)
{
	if (isdefined(self) && isalive(self) && self.origin[coord] < pos)
	{
		return false;
	}
	else
		return true;
}
		
		// waits till convoy passes then crosses road
wait_for_convoy_gone()
{
	level waittill ("main_convoy_past");
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] allowedstances("crouch", "stand", "prone");
		allies[i] set_sneak_walk(false);
	}
	clip = getent("bridge2_road_pathblock", "targetname");
	clip connectpaths();
	clip delete();
	iprintln("Now's our chance, accross the road , move!");
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		level thread wake_road_walkers(guys[i]);
		level thread wake_road_walkers_bytrig();

	}
	level notify ("event2_starts");	
	do_set_pacifist(allies, true);
	trig = getent("off_road_move", "targetname");
	trig thread trigger_and_delete();
					 getent("plant_bomb_on_bridge", "targetname") trigger_off();
	 wait 1;
	 getent("mantle_blocker", "targetname") delete();	
	maps\hol2_event2::event2_setup();
}
wake_road_walkers_bytrig()
{
	trig = getent("player_runs_downroad_trig", "targetname");
	trig waittill ("trigger", player);
	level notify ("player_brokestealth_onroad");
	guys = getentarray("E1_C1_weary_soldiers", "script_noteworthy");
	do_set_pacifist(guys, false);
	for(i=0; i < guys.size; i++)
	{
		guys[i] setgoalentity(player);
	}
}

wake_road_walkers(guy)
{
	level endon("bridge3_fight_begin");
	level endon ("player_brokestealth_onroad");
	guy waittill("damage",x, attacker);
	guys = getentarray("E1_C1_weary_soldiers", "script_noteworthy");
	do_set_pacifist(guys, false);
	for(i=0; i < guys.size; i++)
	{
		guys[i] setgoalentity(attacker);
	}
	level notify ("player_brokestealth_onroad");
}
convoy_wave2()
{
	level endon ("convoy2_truck_past_node");
	trig = getent("convoy_2ndwave_trig", "script_noteworthy");
	trig waittill ("trigger");
	iprintln("Hurry up, more vehicles inbound!");
	wait 0.3;
	axis = getaiarray("axis");
	do_set_pacifist(axis, true);
	wait 2;
	level thread main_convoy2_awaken();
	wait 3;
	wait 2;
	convoy = getentarray("bridge2_convoy_after_roadcross", "script_noteworthy");
	for (i=0; i < convoy.size; i++)
	{
		if (convoy[i].classname == "script_vehicle")
		{
			convoy[i] thread covoy_deletes_properly();
			convoy[i] setspeed(9,5,5);
		}
	}
	wait 20;
	for (i=0; i < convoy.size; i++)
	{
		convoy[i] resumespeed(10);
	}
	
}

squad_moveup_to_campfire()
{
	level endon	("campfire_guys_dead");
	level.guys_ready_for_campfire_attack = 0;
	trig = getent("attack_at_campfire_trig", "targetname");
	if (isdefined(trig))
		trig waittill ("trigger");
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i].health = 1;
	}
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] thread check_guys_ready_for_campfire_attack();
	}
	while (level.guys_ready_for_campfire_attack < 6)
	{
		wait 0.5;
	}
	level notify ("stop_counting_guys");

	do_set_pacifist(allies, false);
 	wait 1;
 	level notify ("campfire_fightstart");
}



		// sets up first set of trucks to stop at a checkpoint
trucks_stop_at_checkpoint()
{	
	wait 1;
	truck1 = getent("initial_convoy_truck1", "targetname");
	truck2 = getent("initial_convoy_truck2", "targetname");
	truck3 = getent("initial_convoy_truck3", "targetname");
	node1 = getvehiclenode("initial_convoy_truck1_stop", "targetname");
	node2 = getvehiclenode("initial_convoy_truck2_stop", "targetname");
	node3 = getvehiclenode("trucks_past_moveup", "targetname");
	
	truck1 thread initial_convoy_checkpoint_stop(node1, 0);
	truck2 thread initial_convoy_checkpoint_stop(node2, 1);
	truck3 thread initial_convoy_checkpoint_stop(node3, 2);
	
	//audio notify (TUEY)
	level notify ("trucks_go");
			// event 1 GO
}


		// controls each vehicle at the checkpoint
initial_convoy_checkpoint_stop(node, waittime)
{
	self vehicle_at_node(node);
	self setspeed (0,30,30);
	trig = getent("see_campfire_guys", "targetname");
	trig waittill ("trigger");
	wait waittime;
	self setspeed (15, 6, 6);
}


sarge_kill_bridgebomber()
{

}

player_kill_bridgebomber()
{
	level endon ("sarge_killed_bomber");
	guy = grab_ai_by_script_noteworthy("bomb_arm_guy", "axis");
	if (isdefined(guy))
	{
		guy waittill ("death");
	}
	wait 0.1;
	level notify ("player_killed_bomber");
	level.maddock enable_ai_color();
}
	
		// deletes convoy when it reaches the end of the road
delete_first_convoy()
{
	node = getvehiclenode("initial_convoy_last_node", "targetname");
	self vehicle_at_node(node);
	//self vehicle_deleteme();
}

delete_second_main_convoy()
{
	node = getvehiclenode("initial_convoy_last_node", "targetname");
	self setwaitnode(node);
	wait 0.2;
	self waittill ("reached_wait_node");
	self vehicle_deleteme();
}

wake_convoy_by_trig()
{
	level endon ("event2_starts");
	level endon("main_convoy_wakes_by_shoot");
	level endon ("a_bomb_was_diffused");
	convoy_awaken = 0;
	for (;;)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i] getstance() == "stand" && (players[i].origin[1] > -3220 && players[i].origin[0] < 2150))
			{
				wait 1;
				convoy_awaken++;
				i--;
				if (convoy_awaken > 10)
					break;
			}
		}
		if (convoy_awaken > 10)
		{
			level notify ("main_convoy_wakesup");
			iprintln ("Damnit Wilkins I said stay down!  Now we're all dead!");
			break;
		}
		wait 0.1;
	}
}

is_player_breaking_stealth_mainconvoy()
{
	players = get_players();
	array_thread(players, ::waitfor_player_attack, "main_convoy_wakes_by_shoot", 1, -3900);
}
wake_convoy_by_shoot()
{
	level endon ("event2_starts");
	level endon("main_convoy_wakesup");
	is_player_breaking_stealth_mainconvoy();
	trig = getent("wake_engineer", "targetname");
	trig thread wake_engineer_trig();
	level waittill ("main_convoy_wakes_by_shoot");
	axis = getaiarray("axis");
	do_set_pacifist(axis, false);
	iprintln ("Damnit Wilkins!  Now we're all dead!");
	wait 13;
	iprintlnbold("Your actions got your squad killed");
	missionfailed();
}

wake_engineer_trig()
{
	self endon ("death");
	self waittill ("trigger");
	level notify ("main_convoy_wakes_by_shoot");
}

main_convoy_wakeup()
{
	level thread wake_convoy_by_shoot();
	level thread wake_convoy_by_trig();
	level endon ("event2_starts");
	level waittill_either ("main_convoy_wakesup", "main_convoy_wakes_by_shoot");
	flag_set("main_convoy_wokeup");
	convoy = getentarray("road_convoy_vehicles", "script_noteworthy");
	for (i=0; i < convoy.size; i++)
	{
		if (isdefined(convoy[i]))
			convoy[i] setspeed (0,5,5);
	}
	tank = getent("road_convoy_3", "targetname");
	if (isdefined(tank))
		tank thread maps\hol2_event4::tanks_luv_you(5, 6);
	axis = getaiarray("axis");
	level thread do_set_pacifist(axis, false);
	
	guy = grab_ai_by_script_noteworthy("bomb_arm_guy", "axis");
	if (isdefined(guy))
	{
		guy.maxsightdistsqrd = 4000000;
		guy.pacifist = false;
		guy stopanimscripted();
		guy.ignoreme = false;
	}	
	wait 3;
	spot = getstruct("magic_bullet_nades_spot", "targetname");
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] thread magic_grenades_at_player(spot.origin, 9);
	}
	convoy = getentarray("road_convoy_vehicles", "script_noteworthy");
	for (i=0; i < convoy.size; i++)
	{
		convoy[i] notify ("unload");
	}
	wait 10;
	level thread convoy_guys_goto_nodes();
	level thread exterminate_player(15);
}
	
convoy_guys_goto_nodes()
{
	axis = getaiarray("axis");
	nodes = getnodearray("main_convoy_stop_nodes", "targetname");
	nodecounter =0;
	for (i=0; i < axis.size; i++)
	{
		if (isdefined(axis[i]) && isdefined(nodes[nodecounter]))
		axis[i] thread maps\_spawner::go_to_node(nodes[nodecounter]);
		nodecounter++;
	}
}
	
exterminate_player(waittime)
{
	wait waittime;
	level endon ("event2_starts");
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		if (players[i].origin[1] > -3800 && players[i].origin[1] < 0)
		{
			spot = getstruct("magic_bullet_nades_spot", "targetname");
			players[i] thread scripted_player_shot_death(spot.origin);
		}
	}
	wait 1;
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		if (players[i].health > 1)
		{
			level thread exterminate_player(10);
		}
	}
}

main_convoy2_awaken()
{
	level endon ("convoy2_past");
	wait 6;
	trig = getent("player_still_on_road_trig", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	level notify ("player_still_on_road");
	iprintln("Get the bloody hell out of there Wilkins!");
	convoy = getentarray("2nd_wave_road_convoy", "script_noteworthy");
	for (i=0; i < convoy.size; i++)
	{		
		convoy[i] setspeed (0,5,5);
	}
	wait 3;
		for (i=0; i < convoy.size; i++)
	{		
		convoy[i] notify("unload");
	}
	level thread exterminate_player(7);
}

check_guys_ready_for_campfire_attack()
{
	self endon("death");		
	level endon ("stop_counting_guys");					
	// waits till squad is together near campfire
	while (self.origin[0] < 1200)			// then they will attack together
	{
		wait 0.5;
	}
	level.guys_ready_for_campfire_attack++;
}


cqbwalk_to_campfire()
{
	for (;;)
	{
		if (self.origin[0] > 500)		// check position of actor
		{														// once actor is past this point he starts cqb walking
			self set_sneak_walk(true);
			break;
		}
		wait 0.5;
	}
}


dont_forget_to_disarm()
{
	trig = getent("dont_forget_to_disarm", "targetname");
	trig endon ("death");
	trig waittill("trigger");
	iprintln("Wilkins!  Get back here and disarm this bomb!");
}

give_engineer_weapon()
{
	self endon ("death");
	level endon ("sarge_knifed_nazi");
	level waittill_either ("main_convoy_wakesup", "main_convoy_wakes_by_shoot");
	self animscripts\shared::placeweaponOn(self.weapon, "right");
}