#include maps\hol2;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#using_animtree("generic_human");

		// for skipto
start_event3()
{
	level.newhero = getent("newhero", "script_noteworthy") stalingradspawn();
	level.newhero.name = "Cpl. Goddard";

	wait 0.1;
	level thread event3_squad_paci_till_fight();
	level.maddock = getent("actor_ally_brit_hol_maddock", "classname");
	level.maddock.name = "Sgt. Maddock";
	squad = getaiarray("allies");
	players = get_players();
	event3_players_start = getentarray("event3_players_start", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event3_players_start[i].origin+ (-10000,-10000,-10000));
		players[i] setplayerangles( event3_players_start[i].angles);
	}
		wait 0.5;
	
	squad_start_spots = getentarray("event3_squad_origins", "targetname");
	for (i=0; i < squad.size; i++)
	{
		squad[i] teleport(squad_start_spots[i].origin, squad_start_spots[i].angles);
	}
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event3_players_start[i].origin);
		players[i] setplayerangles( event3_players_start[i].angles);
	}
	squad_setup(squad);
	objective_control(2);
	event3_setup();
}

event3_trigs_off()
{
	getent("graveyard_save", "script_noteworthy") trigger_off();
	getent("regroup_event3_trig", "targetname") trigger_off();
  getent("throwsmoke_trig", "targetname")trigger_off();
  getent("waitfor_entranceguys_trig", "targetname") trigger_off();
  getent("flak_defense_trig", "script_noteworthy") trigger_off();
  getent("event4_flak_savetrig", "script_noteworthy") trigger_off();
  getent("church_steeple_trig", "targetname") trigger_off();
  getent("graveyard_wave", "script_noteworthy") trigger_off();
  getent("in_graveyard_now_trig", "targetname") trigger_off();
  getent("tank_bust_gate", "targetname") trigger_off();
  getent("temp_player_explosives_trig", "targetname") trigger_off();
  getent("convoy_arrives_trig", "script_noteworthy") trigger_off();
  getent("flakmg_position_nosight", "targetname") trigger_off();
  getent("block_ai_from_street", "targetname") trigger_off();
  
  	
	blowtrigs = getentarray("runback_explosion_trigs", "script_noteworthy");
	for (i=0; i < blowtrigs.size; i++)
	{
		blowtrigs[i] trigger_off();
	}
	getent("closed_door", "targetname") trigger_off();
	
	blockprops = getentarray("temp_block_props", "targetname");
	for (i=0; i < blockprops.size; i++)
	{
		if (blockprops[i].classname == "script_brushmodel")
		{
			blockprops[i] connectpaths();
		}
		blockprops[i] trigger_off();
	}
	getent("start_flanking_hq2", "targetname") trigger_off();
	getent("start_flanking_hq3", "targetname") trigger_off();
	
	getent("heroes_to_breach_house_trig", "targetname") trigger_off();
	
	getent("e3_mainhouse_killtrig", "targetname") trigger_off();
	getent("right_flank_chain", "targetname") trigger_off();
	getent("ambush_trig_1", "targetname") trigger_off();
	
	dynamite = getentarray("dynamite_models", "script_noteworthy");
	array_thread (dynamite, :: trigger_off);
	
	dupes = getentarray("e4_dupe_vehicles" , "script_noteworthy");
	for (i=0; i<dupes.size; i++)
	{
		dupes[i] trigger_off();
	}
	
	graves_d = getentarray("gravestones_destroyed", "script_noteworthy");
	for (i=0; i< graves_d.size; i++)
	{
		graves_d[i] hide();
	}
	
	
	
}

event3_setup()
{
	
	level.newhero setthreatbiasgroup("heroes");
	level.newhero.dontavoidplayer = true;
	setignoremegroup("heroes","axis");
	
	level thread maps\hol2_fx::event_2_amb_2();
			// used to reference fog/snow controls
	level.event3 = true;
			// level variable to keep track of guys retreating to house
		level thread heroes_threatbias();
	
	players = get_players();
	array_thread(players, ::player_speed_set, 190,180);
	level thread event3_squad_paci_till_fight();
	event3_trigs_off();
	clear_event3_flags();
	level thread entranceguys_hangin();
	level thread event3_kill_guys_together();
	level thread shutters_open();
	level thread event3_entrance_guys_killed();
	level thread camp_patrollers();
	level thread e3_killspawners_after_trig();
	level thread in_camptown_directive();
	level thread chains_off_till_fight();
	
	event3_start_fight();
	mgguy = getent("gatehouse_mg_guys", "script_noteworthy");
	mgguy add_spawn_function(::ai_ignore_housemg_guy);
	level thread clean_preflak_guys();
	level thread event3_gatehouse_guys_killed();
	level thread heroes_satchel_house();
	level thread event3_right_guys_killed();
	level thread mg_guy_dead();
	level thread flaktrack_end_of_path();
}

clear_event3_flags()
{
	flag_clear ("ambush_countdown");
	flag_clear ("ambushpos1");
	flag_clear ("ambushpos2");
	flag_clear ("ambushpos3");
	flag_clear ("ambushpos4");
	flag_clear ("ambushpos5");
	flag_clear("event3_fightstart");
}

event3_squad_paci_till_fight()
{
	squad = getaiarray("allies");
	do_set_pacifist(squad, true);
}

wait_goal_count()
{
	self waittill ("goal");
	level.ducksinarow++;
}

event3_kill_guys_together()
{
	//fakehero2 = grab_ai_by_script_noteworthy("sidekick","allies");
	//fakehero2 disable_ai_color();
	level.ducksinarow = 0;
	trig = getent("in_shack_chain", "targetname");
	trig waittill ("trigger");
	squad = getaiarray("allies");
	array_thread(squad, ::set_sneak_walk,true);
	level endon ("event3_fightstart");
	for (i=0; i < squad.size; i++)
	{
		if (isdefined(squad[i].script_noteworthy) && squad[i].script_noteworthy != "sidekick" )
		{
			squad[i] thread wait_goal_count();
		}
	}
	wait 2;
	//fakehero2 enable_ai_color();
	iprintln("Shh...  we got Jerry");
	
	wait 5;
	iprintln("Line up on your targets, Wilkins take the smoker");
	wait 3;

	while (level.ducksinarow < 3)
	{
		wait 0.5;
	}
	iprintln("Fire on the count of 3");
	wait 4;
	maps\_spawner::kill_spawnernum(7);
	
	
	guy1 = grab_ai_by_script_noteworthy("e3_entrance_guy1", "axis");
	guy2 = grab_ai_by_script_noteworthy("e3_entrance_guy2", "axis");
	guy3 = grab_ai_by_script_noteworthy("e3_entrance_guy3", "axis");
	guy4 = grab_ai_by_script_noteworthy("e3_entrance_guy4", "axis");
	spot2 = getent("e3_backtruck_guy_aim", "targetname");
	spot3 = getent("e3_right_guy_aim", "targetname");
	
	fakehero = getent("fake_hero", "script_noteworthy");

	guy4.health = 1;
	
	
	iprintln("1");
	wait 1;
	wait .5;
	iprintln("2");
	wait 1;
	level thread event3_ent_shootguys(fakehero, guy1, guy2, guy3, guy4, spot2, spot3);
}

event3_ent_shootguys(fakehero, guy1, guy2, guy3, guy4, spot2, spot3)
{
	
	level.newhero setentitytarget (spot3,1);
	level.maddock setentitytarget (spot2,1);
	fakehero			setentitytarget (spot2,1);
	wait 0.5;
	iprintln("3");

	wait 0.5;
	
	level.maddock shoot();
	fakehero shoot();
	level.newhero shoot();

	level thread wait_n_kill(guy1, randomfloat(0.25));
	level thread wait_n_kill(guy2, randomfloat(0.25));
	level thread wait_n_kill(guy3, randomfloat(0.25));
	level notify ("e3_entguys_woken");
	wait 1;
	if (isdefined (guy4) && isalive(guy4) && guy4.health > 0)
	{
		level.newhero setentitytarget (spot3,1);
		level.maddock setentitytarget (spot2,1);
		fakehero setentitytarget (spot2,1);
		wait 1;
		level.maddock shoot();
		guy4 dodamage(guy4.health*10, (level.maddock.origin));
		iprintln("Hit your bloody target next time Wilkins");
		level notify ("e3_entguys_killed");
	}
	else 
		{
			level notify ("e3_entguys_killed");
		}
	level.newhero clearentitytarget ();
	level.maddock clearentitytarget ();
	fakehero clearentitytarget ();
	spot2 delete();
	spot3 delete();	
}
	
e3_killspawners_after_trig()
{
	right_guys_trig2 = getent("right_side_camp_spawners", "target");
	right_guys_trig2 thread killspawner_after_trig(2);
	
	trig = getent("camptown_patrollers", "target");
	trig thread killspawner_after_trig(62);
	
	trig = getent("obj6_trig", "script_noteworthy");
	trig thread killspawner_after_trig(7);
}

block_ai_from_street()
{
	trig = getent("flak_spawners", "target");
	trig waittill ("trigger");
	getent("block_ai_from_street", "targetname") trigger_on();
}
	
event3_start_fight()
{
	level endon ("e3_entguys_killed");

	getent("obj6_trig", "script_noteworthy") waittill ("trigger");
	allies = getaiarray("allies");
	do_set_pacifist(allies, true);
	kick_ent_door();
	level thread event3_fightstart_loop();
	level waittill_either ("event3_fightstart", "e3_entguys_woken");
	guys = getaiarray("axis");
	level thread do_set_pacifist(guys, false);
	nodes = getnodearray("church_guy_fallback_nodes", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(nodes[i]))
			guys[i] thread maps\_spawner::go_to_node(nodes[i]);
	}
	//getent("nosight_ent", "targetname") delete();
	squad = getaiarray("allies");
	do_set_pacifist(squad, false);
	array_thread(squad, ::set_sneak_walk,false);
	wait 2;
	iprintln("German screams out and alerts the camp");
}
	
event3_fightstart_loop()
{
	level thread event3_fightstart_by_trig();
	players = get_players();
	array_thread(players, ::waitfor_player_attack, "event3_fightstart");
}	

event3_fightstart_by_trig()
{
	trig = getent("player_steps_out", "targetname");
	if (isdefined(trig))
		trig waittill ("trigger");
	level notify ("event3_fightstart");
}
	
event3_regroup_athouse()
{
	(getent("gatehouse_chain", "targetname")) delete();
	pre_event4_chains = getentarray("pre_event4_chains", "script_noteworthy");
	for (i=0; i < pre_event4_chains.size ; i++)
	{
		pre_event4_chains[i] delete();
		if (isdefined(pre_event4_chains[i]))
		{
			pre_event4_chains[i] trigger_off();
		}
	}
	wait 0.2;
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] stopanimscripted();
		allies[i] enable_ai_color();
		allies[i] solo_set_pacifist(true);
	}
	wait 1;
	trig = getent("flak_regroup_trig", "targetname");
	trig thread trigger_and_delete();
	
	objective_control(6);
	getent("regroup_event3_trig", "targetname") trigger_on();
	level.fogclear =1;
	getent("regroup_event3_trig", "targetname") waittill ("trigger");
	iprintln("*radio crackles* Your orders are to hold that camp");
	wait 4;
	if (isdefined(trig)) trig delete();
	iprintln ("There's a small convoy incoming, we need you to take it out.  Air support is inbound");
	wait 4;
	iprintln ("*radio cuts out* Fights not over yet lads, incoming convoy");
	iprintln ("Wilkins grab some of that dynamite and plant it on the road");
	wait 3;
	event3_end();
}

event3_end()
{
	level notify ("event3_complete");
	level thread objective_control(7);
	level.ready4ambush = 0;
	getent("closed_door", "targetname") trigger_on();
	getent("open_door", "targetname") delete();
	blockprops = getentarray("temp_block_props", "targetname");
	array_thread(blockprops, ::trigger_on);
	maps\hol2_event4::event4_setup();
}
		

camp_patrollers()
{
	spawners = getentarray("camptown_patrollers", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] add_spawn_function(::waittill_enemy, "camptown_battle");
	}
	/*spawners = getentarray("ent_patrolguys", "script_noteworthy");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] add_spawn_function(::waittill_enemy, "harhar");
	}
	*/

	
	trig2 = getent("right_side_camp_spawners", "target");
	trig2 thread waittill_trig_n_notify("camptown_battle");
	
	trig3 = getent("guys_up_to_wall", "targetname");
	level thread waittill_notify_n_trig("camptown_battle", trig3);
	
	trig4 = getent("e3_tower_flank_guards", "target");
	level thread triggeron_on_notify("camptown_battle", trig4);
	
	trig = getent("right_alley_runners", "target");
	level thread triggeron_on_notify("camptown_battle", trig);
	
	trig = getent("right_flank_chain", "targetname");
	level thread triggeron_on_notify("camptown_battle", trig);
	
	level thread spawn_middle_building_guys();
	level waittill ("camptown_battle");
	flag_set("camptown_battle");
	
	maps\_spawner::kill_spawnernum(65);
	for (i=0; i < 4; i++)
	{
		guy = grab_ai_by_script_noteworthy("camptown_patroller"+i, "axis");
		node = getnode("camptown_patroller_node"+i, "script_noteworthy");
		if (isdefined(guy) && isdefined(node))
		{
			guy thread maps\_spawner::go_to_node(node);
		}
	}
	
	allies = getaiarray("allies");
	do_set_pacifist(allies, false);
	array_thread(allies, ::set_sneak_walk,false);
}
	
spawn_middle_building_guys()
{
	level waittill ("camptown_battle");
	wait_n_spawn("e3_middle_building_spawners", "targetname", 0.5);
	
	shutters_open_2();
	wait randomint(15);
	maps\_spawner::kill_spawnernum(2);
	trig = getent("right_side_camp_spawners", "target");
	if (isdefined(trig))
		trig thread trigger_and_delete();
	wait randomint(30);
	trig2 = getent("right_alley_runners", "target");
	if (isdefined(trig2))
		trig2 thread trigger_and_delete();
	wait 1;
	getent("e3_mainhouse_killtrig", "targetname") trigger_on();
	getent("someguys_inmidhouse_killspawner_trig", "targetname") trigger_and_delete();

}
	

event3_right_guys_killed()
{
	level waittill_aigroupcleared ("rightside_spawners");
	oldchains = getentarray("pre_event4_chains", "script_noteworthy");
	for (i=0; i < oldchains.size; i++)
	{
		spot = oldchains[i].origin;
		if (spot[1] < 8500)
		{
			oldchains[i] delete();
		}
	}
	level waittill_aigroupcleared ("smallhouse_mg_guy");
	trig = getent("mg_pin_free", "targetname");
		if (isdefined(trig))
		{
			trig thread trigger_and_delete();			
		}
	wait randomint(12);
	trig = getent("flak_spawners", "target");
	if (isdefined(trig))
		trig trigger_and_delete();
	
}

event3_gatehouse_guys_killed()
{
	level waittill_aigroupcleared ("gatehouse_spawners");
	level waittill_aigroupcleared ("flak_spawners");
	flag_set("stopstar_onsarge");
	objective_state(5, "done");
	enemies = getaiarray("axis");
	for (i=0; i < enemies.size; i++)
	{
		if (isdefined(enemies[i]))
		{
			enemies[i] dodamage(enemies[i].health *5, (0,0,0));
		}
	}
	event3_regroup_athouse();
}


guy1_sequence()
{
	tpoint = getent("truckanim_ref_point", "targetname");
	self.pacifist = true;
	self.animname = "truck_vin_fuel";
	self.allowdeath = true;
	self endon ("death");
	level waittill ("entrance_door_open");
	wait 0.5;
	tpoint anim_single_solo(self, "refueling");
	tpoint anim_single_solo(self, "transition");
	tpoint anim_loop_solo(self, "talk_loop", undefined, "death");
}
guy1_sequence2()
{
	self stopanimscripted();
	tpoint = getent("truckanim_ref_point", "targetname");
	self.animname = "truck_vin_fuel";
	tpoint anim_single_solo(self, "refueling");
	tpoint anim_single_solo(self, "transition");
	tpoint anim_loop_solo(self, "talk_loop", undefined, "death");
}

guy2_sequence()
{
	tpoint = getent("truckanim_ref_point", "targetname");
	self.pacifist = true;
	self.animname = "truck_vin_back";
	self endon ("death");
	self.allowdeath = true;
	level waittill ("entrance_door_open");
	wait 1;
	tpoint anim_single_solo(self, "backdoor");
	tpoint anim_loop_solo (self, "talk_loop2", undefined, "death");
}
	
guy3_sequence(i)
{
	self.pacifist = true;
	self.animname = "ent_smoker_"+i;
	self.allowdeath = true;
	self endon ("death");
	tpoint = getent("e3_right_guy_aim", "targetname");
	tpoint anim_loop_solo(self, "smoke_it", undefined, "death");
}

entranceguys_hangin()
{
	guy = getent("e3_entrance_guy1", "script_noteworthy");
	guy	add_spawn_function(::guy1_sequence);
	
	guy = getent("e3_entrance_guy2", "script_noteworthy");
	guy add_spawn_function(::guy2_sequence);
	
	guy = getent("e3_entrance_guy3", "script_noteworthy");
	guy	add_spawn_function(::guy3_sequence, 1);
	
	guy = getent("e3_entrance_guy4", "script_noteworthy");
	guy	add_spawn_function(::guy3_sequence, 2);
	
	
	getent("obj6_trig", "script_noteworthy") waittill ("trigger");
	wait 0.3;

}

shutters_open()
{
	getent("right_side_camp_spawners", "target") waittill ("trigger");
	level notify ("housefighting_begin");
	wait 1;
	wait randomfloat(2);
	br_left_shudder = getent("br_left_shudder", "targetname");
	br_right_shudder = getent("br_right_shudder", "targetname");
	br_left_shudder rotateyaw((-90), 0.4, 0.3, .1);
	br_right_shudder rotateyaw((90), 0.4, 0.3, .1);
		wait randomfloat(0.7);
	bl_left_shudder = getent("bl_left_shudder", "targetname");
	bl_right_shudder = getent("bl_right_shudder", "targetname");
	bl_left_shudder rotateyaw((-90), 0.4, 0.3, .1);
	bl_right_shudder rotateyaw((90), 0.4, 0.3, .1);
}

shutters_open_2()
{
	wait 0.7;
	wait randomfloat(0.1);
	sh_l_left_shudder = getent("sh_l_left_shudder", "targetname");
	sh_l_right_shudder = getent("sh_l_right_shudder", "targetname");
	sh_l_left_shudder rotateyaw((-90), 0.4, 0.3, .1);
	sh_l_right_shudder rotateyaw((90), 0.4, 0.3, .1);
	wait .5;
	wait randomfloat(1);
	sh_r_left_shudder = getent("sh_r_left_shudder", "targetname");
	sh_r_right_shudder = getent("sh_r_right_shudder", "targetname");
	sh_r_left_shudder rotateyaw((-90), 0.4, 0.3, .1);
	sh_r_right_shudder rotateyaw((90), 0.4, 0.3, .1);	
	door = getent ("e3_middle_building_door", "targetname");
	door rotateyaw((-110), 0.4, 0.3, .1);
	door connectpaths();
}

mg_guy_dead()
{
		level waittill_aigroupcleared ("smallhouse_mg_guy");
		wait 1;
		trig = getent("mg_pin_free", "targetname");
		if (isdefined(trig))
		{
			trig notify ("trigger");			
		}
}

flaktrack_end_of_path()
{
	trig = getent("flaktrack_trig", "script_noteworthy");
	trig waittill ("trigger");
	wait 2;
	truck = getent("flak_halftrack", "targetname");
	truck.unload_group = "all";
	node = getvehiclenode("truck_end_path", "script_noteworthy");
	node waittill ("trigger");
	wait 5;
	flag_set("flaktrack_guysout");
}

event3_entrance_guys_killed()
{
	level waittill_aigroupcleared ("entrance_guys");
	level notify ("e3_entguys_killed");
	objective_control(4.5);
	iprintln("Area secure");
	allies = getaiarray("allies");
	if (!flag("camptown_battle"))
	{
		do_set_pacifist(allies, true);
		iprintln("Let's check these buildings.  Wilkins on point");
	} 	
	array_thread(allies,::set_sneak_walk,false);
	getent("into_camp_chain", "targetname") trigger_and_delete();
}

kick_ent_door()
{
	level notify ("sarge_at_e3_door");
	kicknode = getent("sarge_door_open_spot", "targetname");
	door = getentarray("barn_door", "targetname");
	level.maddock.animname = "door_kick_guy";
	kicknode anim_reach_solo(level.maddock, "door_kick");
	kicknode thread anim_single_solo(level.maddock, "door_kick");
	wait 4;
	level notify ("entrance_door_open");
	for (i=0; i < door.size; i++)
	{
		door[i] connectpaths();
		door[i] rotateyaw((120), 3.5, 2, 1.5);
		door[i] connectpaths();
		//door[i] delete();
	}
	//door rotateyaw((120), 0.4, 0.3, .1);
	//door connectpaths();
	level.maddock enable_ai_color();
	wait 4;
	getent ("in_shack_chain", "targetname") trigger_and_delete();
}

chain_up_to_hq()
{
	level endon ("blew_house_with_flak");
	level.heroes_inpos = 0;
	level thread north_of_house_clear();
	trig = getent("start_flanking_hq2", "targetname");
	trig trigger_on();
	
	if (isdefined(trig))
		trig waittill ("trigger");
	
	trig = getent("start_flanking_hq3", "targetname");
	trig trigger_on();
	if (isdefined(trig))
		trig waittill ("trigger");
	level thread maps\_spawner::kill_spawnernum(67);
	iprintln("Clear out the infantry and we'll satchel the house!");
	flag_wait("north_of_house_clear");
	trig = getent("heroes_to_breach_house_trig", "targetname");
	trig thread trigger_and_delete();
}

north_of_house_clear()
{
	wait 20;
	while (1)
	{
		axisinway = 0;
		axis = getaiarray("axis");
		for (i=0; i < axis.size; i++)
		{
			if (axis[i].origin[1] > 10300 && axis[i].origin[0] > 2000)
			{
				axisinway++;
			}
		}
		if (axisinway == 0)
			break;
		wait 1;
	}
	flag_set("north_of_house_clear");
	trig = getent("start_flanking_hq2", "targetname");
	if (isdefined(trig))
	{
		trig trigger_and_delete();
	}
	trig = getent("start_flanking_hq3", "targetname");
	if (isdefined(trig))
	{
		trig trigger_and_delete();
	}
}

heroes_satchel_house()
{
	guys = getentarray("flak_spawners", "targetname");
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::flakspawners_retreat);
	}
	trig = getent("flak_spawners", "target");
	trig waittill ("trigger");
	trig2 = getent("gatehouse_runback_guys", "target");
	trig2 thread wait_n_notify (randomint(20), "trigger");
	by_flak_too_long = 0;
	roof = getentarray("hq_house_d_stuff", "script_noteworthy");
	for (i=0; i < roof.size; i++)
	{
		roof[i] thread blow_hq_with_flak();
	}
			// loop runs until axis are out of the flak area
	while (1)
	{
		wait 1;
		ai = getaiarray("axis");
		house_assault = 1;
		for (i=0; i < ai.size; i++)
		{
			if (ai[i].origin[0] > 2700)
			{
				house_assault = 0;
				if (by_flak_too_long > 100)
				{
					ai[i] dodamage(ai[i].health * 10, (0,0,0));
				}
			}
		}
		if (house_assault ==1)
			break;
		by_flak_too_long++;
	}
	
	trig = getent("gatehouse_chain", "targetname");
	if (isdefined(trig))
		trig notify ("trigger");
	flag_clear("stopstar_onsarge");
	iprintln("Come with me Wilkins, we gotta flank those MG's");
	getent("start_flanking_hq", "targetname") notify ("trigger");
	level thread star_on_sarge(5, level.maddock);
	level thread chain_up_to_hq();
	level endon ("blew_house_with_flak");
	level waittill_aigroupcleared ("flak_spawners");

	level.maddock.animname = "window_smash_guy";
	level.newhero.animname = "window_smash_guy";
	
	breach_anim_spot = getent("sarge_breach_node", "targetname");
	level.maddock.animname = "hq_breach_maddock";
	level.newhero.animname = "hq_breach_newhero";
	heroes = [];
	heroes = array_add(heroes, level.maddock);
	heroes = array_add(heroes, level.newhero);
	
	
	breach_anim_spot anim_reach(heroes, "hq_breach_and_satchel");
	breach_anim_spot thread anim_single(heroes, "hq_breach_and_satchel");
	wait 13.1;
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
	
	level thread maps\_spawner::kill_spawnernum(50);
	level thread maps\_spawner::kill_spawnernum(5);
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] dodamage(axis[i].health * 10, (0,0,0));
	}
	
	level.maddock enable_ai_color();
	level.newhero enable_ai_color();
	wait 0.1;
	destroy_hq_roof();
}

destroy_hq_roof()
{
	roof = getentarray("hq_house_d_stuff", "script_noteworthy");
	for (i=0; i < roof.size; i++)
	{
		roof[i] delete();
	}
}

flakspawners_retreat()
{
	self.goalradius = 25;
	self.ignoreall = true;
	self waittill ("goal");
	self.ignoreall = false;
	self.pacifist = false;
}

in_camptown_directive()
{
	level endon ("camptown_battle");
	trig = getent("in_camptown_now", "script_noteworthy");
	trig waittill ("trigger");
	iprintln("Wilkins, take out their patrols quietly");
}

chains_off_till_fight()
{
	pre_event4_chains = getentarray("pre_event4_chains", "script_noteworthy");
	for (i=0; i < pre_event4_chains.size ; i++)
	{
		pre_event4_chains[i] trigger_off();
	}
	level waittill ("camptown_battle");
	pre_event4_chains = getentarray("pre_event4_chains", "script_noteworthy");
	for (i=0; i < pre_event4_chains.size ; i++)
	{
		pre_event4_chains[i] trigger_on();
	}
}

clean_preflak_guys()
{
	trig = getent("preflak_enemy_cleanser", "targetname");
	trig waittill ("trigger");
	guys = getaiarray("axis");
	for (i = 0; i < guys.size; i++)
	{
		if (isdefined(guys[i].script_aigroup) && (guys[i].script_aigroup == "rightside_spawners"
																					|| 	guys[i].script_aigroup == "smallhouse_mg_guy"))   
		{
			level thread wait_n_kill(guys[i], 10);
		}
	}
}

blow_hq_with_flak()
{
	self endon ("death");
	self setcandamage(true);
	self.health = 9999999999;
	flak = getent("my_flak", "targetname");
	while (1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, damageType );
		if (attacker == flak)
		{
			break;
		}
	}
	roof = getentarray("hq_house_d_stuff", "script_noteworthy");
	for (i=0; i < roof.size; i++)
	{
		if (roof[i] != self)
		{
			roof[i] delete();
		}
	}
	blowspot = getstruct("hq_blows", "targetname");
	playfx (level._effect["88_on_house"], blowspot.origin, anglestoforward(blowspot.angles));

	
	level thread maps\_spawner::kill_spawnernum(50);
	level thread maps\_spawner::kill_spawnernum(5);
	level thread maps\_spawner::kill_spawnernum(67);
	level notify ("blew_house_with_flak");
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		earthquake(0.2, 1.4, players[i].origin, 200);
	}

	level thread maps\_spawner::kill_spawnernum(50);
	level thread maps\_spawner::kill_spawnernum(5);
	radiusdamage(self.origin, 500, 1000, 500);
	guy = grab_ai_by_script_noteworthy("gatehouse_mg_guys", "axis");
	if (isdefined(guy) && isai(guy))
	{
		guy dodamage(guy.health *10, (0,0,0));
	}
	self delete();
}
	
ai_ignore_housemg_guy()
{
	self.ignoreme = true;
}