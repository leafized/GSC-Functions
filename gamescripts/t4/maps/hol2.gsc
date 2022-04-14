#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#using_animtree("generic_human");

main()
{
	// precache strings
	stringrefs();
		
			// vehicle loading
	maps\_truck::main( "vehicle_ger_wheeled_opel_blitz_winter", "opel" );
	maps\_jeep::main( "vehicle_ger_wheeled_horch1a_winter_backseat" );
	maps\_halftrack::main("vehicle_ger_tracked_halftrack");
	maps\_panzeriv::main( "vehicle_ger_tracked_panzer4", "panzeriv" );	
	maps\_tiger::main( "vehicle_ger_tracked_king_tiger", "tiger" );
	maps\_panzeriv::main( "vehicle_ger_tracked_panzer4v1" );
	maps\_flak88::main( "artillery_ger_flak88_winter" ); 
	maps\_stuka::main("vehicle_spitfire_flying" );
	maps\_sdk::main("vehicle_ger_wheeled_sdk222_winter");	
		
	precachevehicle ("stuka");
	precachemodel("vehicle_spitfire_flying");
	init_flags();

	add_start( "event3", maps\hol2_event3::start_event3 );
	//default_start( maps\hol2_event4::start_event4 );
	add_start( "graveyard", maps\hol2_event4::start_graveyard );
	add_start( "event2", maps\hol2_event2::start_event2 );
	default_start( 	maps\hol2_event1::event1_setup); 			
	add_start( "event4", maps\hol2_event4::start_event4 );
			
	add_start( "airstrike", maps\hol2_event4::event4_airstrike_test);
		
	thread maps\hol2_airstrike::airstrike_init();
	
			// bouncing better stuffs
	precacheShader("white"); 
	precacheshellshock("death");
	precachemodel("aircraft_bomb");
	precachemodel("vehicle_spitfire_flying");
	PrecacheModel( "tag_origin" );
	
	thread maps\_bouncing_betties::init_bouncing_betties();
	thread onPlayerConnect();
	
	maps\hol2_fx::main();
		    // loads game functionality			
  maps\_load::main();
  
  maps\_tankmantle::init_models( "viewmodel_usa_player", "fraggrenade" );
  
    				// level support scripts	
	maps\hol2_anim::main();
	thread	maps\hol2_amb::main();
 			// loads MG-42 gunner animations				
	maps\_mganim::main();
	

	
			// adds pacifist spawn function to all spawners desired to be pacifist
	level thread setup_paci_spawners();
	
			// turns the reinforcements on and off so that guys only reinforce in groups every minute
			// instead of a constant stream of one guy at a time
	level thread reinforcements_in_waves();
	
			// level variables
	
			//**TEMP - Mocks where the truck is in e3 for the e4 skipto
	getent("fake_flaktrack", "targetname") trigger_off();
	
	
	level thread maps\hol2_fx::event1_campfire();
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] takeweapon("rocket_barrage");
	}
	
	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	
		// put any calls here that you want to happen when the player connects to the game
		println("Player connected to game.");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread maps\hol2_airstrike::airstrike_player_init();
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
	}
}

		// Paces objective star on a given actor
star_on_sarge(obj_num, guy)
{
	while (isalive(guy))
	{
		objective_position(obj_num, guy.origin);
		wait 0.1;
		if (flag("stopstar_onsarge"))
		{
			break;
		}
	}
}

delete_trig_onuse()
{
	self waittill ("trigger");
	wait 1;
	self delete();
}

		// sets an array of guys to cqbwalk on or off	
do_set_cqbwalking(guys, cqbstate)
{
	for (i=0; i < guys.size; i++)
	{
		guys[i].cqbwalking = cqbstate;
	}
}
		// had trouble with just setting .pacifist, so use this funct to make sure they work
solo_set_pacifist(pacifist_state)
{
	self endon ("death");
	if (isdefined(self) && isai(self))
	{
		self.pacifist = pacifist_state;
		if (pacifist_state == false)
		{
			self.maxsightdistsqrd = 4000000;
			self stopanimscripted();
			self.ignoreme = false;
			self reset_run_anim();
			self.ignoreall = false;
		}
	}
}
		// takes an array and pacifist state and sets everyone in the array to that state
do_set_pacifist(guys, pacifist_state)
{
	for (i=0; i<guys.size; i++)
	{
		guys[i] endon ("death");
		guys[i] solo_set_pacifist(pacifist_state);
	}
}

		// pretty much just puts MBS on heroes
squad_setup(guys)
{
	for (i=0; i< guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			if ( (isdefined(guys[i].script_noteworthy)) && 
			(guys[i].script_noteworthy == "hero" 			|| 
			 guys[i].script_noteworthy == "fake_hero" ||
			 guys[i].script_noteworthy == "newhero" ))
			{
				guys[i] thread magic_bullet_shield();
			}
		}
	}
	level thread heroes_threatbias();
	//level.maddock thread magic_bullet_shield();
}

dospawn_array(guys)
{
	for (i=0; i < guys.size; i++)
	{
		guys[i] dospawn();
	}
}

stringrefs()
{
	precachestring(&"HOL2_OBJ1A");
	precachestring(&"HOL2_OBJ1B");
	precachestring(&"HOL2_OBJ1C");
	precachestring(&"HOL2_OBJ1D");
	precachestring(&"HOL2_OBJ6_GATEHOUSE");
	precachestring(&"HOL2_OBJ6_ENTRANCE");
	precachestring(&"HOL2_OBJ11");
	precachestring(&"HOL2_OBJ11B");
	precachestring(&"HOL2_OBJ12");
	precachestring(&"HOL2_OBJ14");
	precachestring(&"HOL2_OBJ14B");
	precachestring(&"HOL2_OBJ15");
	precachestring(&"HOL2_OBJ12B");
}
	
kill_guys_in_array(guys)
{
	for (i=0; i < guys.size;i++)
	{
		if(isdefined(guys[i]))
		{
			guys[i] dodamage (guys[i].health * 5, (0,0,0));
		}
	}
}

init_flags()
{
	flag_init ("stopstar_onsarge");
	flag_init ("ambush_countdown");
	flag_init ("1st_kubeldead");
	flag_init ("1st_opeldead");
	flag_init ("2nd_opeldead");
	flag_init ("ambushpos1");
	flag_init ("ambushpos2");
	flag_init ("ambushpos3");
	flag_init ("ambushpos4");
	flag_init ("ambushpos5");
	flag_init ("stop_clipdrag");
	flag_init ("event1_ambushstart");
	flag_init ("jump_the_gun");
	flag_init ("gulch_ambush_started");
	flag_init ("smoke_out");
	flag_init ("planes_came");
	flag_init ("event3_fightstart");
	flag_init ("flaktrack_guysout");
	flag_init ("retreat_togatehouse");
	flag_init ("tanks_intown");
	flag_init ("campfire_fightstart");
	flag_init ("event1_stop_convoy");
	flag_init ("event2_past_tripwire");
	flag_init ("event1_player_kills_bomber");
	flag_init ("event1_sarge_kills_bomber");
	flag_init ("main_convoy_wokeup");
	flag_init ("bomb1_diffused");
	flag_init ("bomb2_diffused");
	flag_init ("bomb3_diffused");
	flag_init ("sarge_rdy_4_satchel");
	flag_init ("dynamite_planted0");
	flag_init ("dynamite_planted1");
	flag_init ("dynamite_planted2");
	flag_init ("dynamite_planted3");
	flag_init ("e4_flakfight_over");
	flag_init ("truck2here");
	flag_init ("e4_convoy_notinplace");
	flag_init("woodstiger_dead");
	flag_init("gulchtiger_dead");
	flag_init("north_of_house_clear");
	flag_init("camptown_battle");
	flag_init("path1_clear");
	flag_init("path2_clear");
	flag_init("gulchtiger_inplace");
	flag_init("woodstiger_inplace");
	flag_init("gulchtiger_inloop");
	flag_init("sarge_knifed_nazi");
	flag_init("sdk_stopped");
	flag_init("bridge3_peaceful");
	flag_init("brige3_fightstarted");
}


objective_control(num)
{
	if(num==0)
	{
				// First objective after hopping fence
		objective_add(1, "active", &"HOL2_OBJ0", level.maddock.origin);
		objective_current(1);
		level thread star_on_sarge(1, level.maddock);
	}
	if(num==1)
	{
		flag_set ("stopstar_onsarge");
		bomb1 = getstruct("diffuse_first_bomb_pos", "targetname");
		bomb2 = getstruct("bridge2_bomb_pos", "targetname");
		bomb3 = getstruct("bridge_defuse", "targetname");
		objective_add(0, "active", &"HOL2_OBJ1A", bomb1.origin);
		objective_current(0);
		objective_additionalposition(0, 2, bomb2.origin);
		level waittill ("a_bomb_was_diffused");
		objective_delete(0);
		if (flag("bomb1_diffused"))
		{
			objective_add(0, "active", &"HOL2_OBJ1B", bomb2.origin);
			objective_current(0);
			flag_wait("bomb2_diffused");
		}
		else
		{
			objective_add(0, "active", &"HOL2_OBJ1B", bomb1.origin);
			objective_current(0);
			flag_wait("bomb1_diffused");
		}
		objective_delete(0);
		objective_add(0, "active", &"HOL2_OBJ1C", bomb3.origin);
		objective_current(0);
	}
			
		if(num==2)
	{
		objective_string(0, &"HOL2_OBJ1D");
		objective_state(0, "done");
		objective_delete(1);
		wait 0.2;
		spot = getstruct("scout_forces_obj_spot", "targetname");
		objective_add(1, "active", &"HOL2_OBJ0");
		objective_current(1);
		flag_clear("stopstar_onsarge");
		level thread star_on_sarge(1, level.maddock);
	}
	if(num == 3)
	{
		spot = getstruct("begin_assault", "targetname");
		objective_delete(1);
		objective_add(1, "active", &"HOL2_OBJ5B", spot.origin);
	}
	if(num==4)
	{
		objective_delete(1);
		wait 0.3;
				// these are the entrance guys
		objective_add(1, "active", &"HOL2_OBJ6_ENTRANCE", (2600, 7500.5, -314));
		objective_state(1, "current");
	}
	if (num == 4.5)
	{
		flag_set("stopstar_onsarge");
		objective_state(1, "done");
		objective_add(5, "active", &"HOL2_OBJ6_GATEHOUSE", (1486.5, 10051.5, -312));
		objective_state(5, "current");
	}
	if(num==5)
	{
				// clear the sub-objectives
		for (i=1; i<6; i++)
		{
			objective_delete(i);
			wait 0.3;
		}
	}
	if(num==6)
	{
		regroup_spot = getstruct("event3_regroup_spot", "targetname");
		objective_add(1, "active", &"HOL2_OBJ11", regroup_spot.origin);
		objective_current (1);
	}
	if(num==7)
	{
		level.dynamite_planted = 0;
		objective_delete(1);		
		wait 0.2;
		spots = getstructarray("convoy_ambush_dynamite_spots", "script_noteworthy");
		objective_add(1, "active", &"HOL2_OBJ11B");
		objective_add(7, "current");
		objective_current(7);
		for (i=0; i < 4; i++)
		{
			objective_additionalposition(7, i, spots[i].origin);
			level thread dynamite_plant_control(i);
		}
		//objective_state(7,"invisible");
		level waittill ("dyn_planted");
		level waittill ("dyn_planted");
		level waittill ("dyn_planted");
		level waittill ("dyn_planted");
		objective_state (1, "done");
		objective_delete(7);
		wait 0.2;
		spot = getstruct("ambush_spot1", "targetname");
		objective_add(2, "current", &"HOL2_OBJ12", spot.origin);
		level notify ("all_dynamite_planted");
		level.dynamite_planted = undefined;
		trig = getent("ambush_trig_1", "targetname");
		trig waittill ("trigger");
		objective_string(2, &"HOL2_OBJ12B");
	}
	if(num==9)
	{
		objective_state(2, "done");
				// set the objective to fall back to the flak
		my_flak = getent("my_flak", "targetname");
		objective_add(12, "active", &"HOL2_OBJ13", my_flak.origin);
		objective_state(12, "current");
	}
	if(num==10)
	{
		obj_13_pos = getstruct("2nd_tolast_obj", "targetname");	
		objective_state (12, "done");
		objective_add (13, "active", &"HOL2_OBJ14", obj_13_pos.origin);
		objective_state (13, "current");
	}
	if(num==11)
	{
		objective_delete (13);
		graveyard_pos = getstruct ("graveyard_pos", "targetname");
		objective_add(14 ,"active", &"HOL2_OBJ14b",  graveyard_pos.origin);
		objective_state (14, "current");
	}
	if(num==12)
	{
		smokethrow_pos = getstruct("smokethrow_pos", "targetname");
		objective_delete(14);
		objective_add(15, "active", &"HOL2_OBJ15", smokethrow_pos.origin);
		objective_state (15, "current");
		flag_set("smoke_out");
	}
}

dynamite_plant_control(num)
{
	level waittill ("dyn_planted"+num);
	flag_set("dynamite_planted"+num);
	level.dynamite_planted ++;
	spots = getstructarray("convoy_ambush_dynamite_spots", "script_noteworthy");
	objective_delete(7);
	objective_add(7, "current");
	objective_current(7);
	for (i=0; i < 4; i++)
		{
			if (!flag("dynamite_planted"+i))
			{
				objective_additionalposition(7, i, spots[i].origin);
			}
		}
		//objective_state(7,"invisible");
	level notify ("dyn_planted");
}
	
	
	
		// was using this to get around bug that kept a script origin in when spawning vehicles
get_true_vehicle(value, key)
{
	vehicle = getentarray(value, key);
	for (i=0; i < vehicle.size; i++)
	{
		if (vehicle[i].classname == "script_vehicle")
		{
			true_vehicle = vehicle[i];
			return true_vehicle;
		}
	}
}

killspawner_after_trig(num)
{
	self waittill ("trigger");
	wait 0.5;
	maps\_spawner::kill_spawnernum(num);
}

wait_n_spawn(value,key,waittime)
{
	wait waittime;
	spawners = getentarray(value,key);
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] dospawn();
	}
}

wait_n_spawn_solo(waittime)
{
	wait waittime;
	self stalingradspawn();
}

wait_n_kill(guy,waittime)
{
	guy endon ("death");
	wait waittime;
	if (isdefined(guy)&& isalive(guy))
	{
		guy dodamage(guy.health * 5, (0,0,0));
	}
}

wait_n_kill_array(guys, waittime)
{
	for (i=0; i < guys.size; i++)
	{
		level thread wait_n_kill(guys[i],randomfloat(waittime));
	}
}

grab_ai_by_script_noteworthy(value,side)
{
	guys = getaiarray(side);
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == value)
		{
			return guys[i];
		}
	}
}
grab_ai_by_targetname(value,side)
{
	guys = getaiarray(side);
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].targetname) && guys[i].targetname == value)
		{
			return guys[i];
		}
	}
}

count_guys_by_script_noteworthy(value)
{
	all_guys = getaiarray("axis");
	guys = [];
	for (i=0; i < all_guys.size; i++)
	{
		if (isdefined (guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == value)
		{
			guys = array_add (guys, all_guys[i]);
		}
	}
	return guys.size;
}

	// sets up the threatbias of allied heroes and axis
heroes_threatbias()
{
	createthreatbiasgroup("heroes");
	createthreatbiasgroup("squad");
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy) && allies[i].script_noteworthy == "hero")
		{
			allies[i] setthreatbiasgroup("heroes");
		}
		else
		{
			allies[i] setthreatbiasgroup("squad");
		}
	}
	setthreatbias("axis", "squad" , 100);
	setignoremegroup("heroes","axis");
}
	
trigger_and_delete()
{
	self notify ("trigger");
	wait 2;
	if (isdefined(self)) self delete();
}

		// faked way of having the player appear to get shot and killed from a location
scripted_player_shot_death(shotspot)
{
	self endon("death");
	if (self getstance() == "prone")
	{
		axis = getaiarray("axis");
		if (isdefined(axis[0]) && isalive(axis[0]))
		{
			axis[0] magicgrenade(self.origin+(0,0,50), self.origin, 1.0);
		}
		wait 3;
	}
	for(i=0; i < 4; i++)
	{
		self dodamage(20, shotspot);
		wait 0.2;
	}
	self dodamage(self.health * 1000, (shotspot));
}

		// faked way of killing player with grenades
magic_grenades_at_player(startspot, loops)
{
	for(i=0; i < loops; i++)
	{
		axis = getaiarray("axis");
		if (isdefined(axis[0]) && isalive(axis[0]))
		{			
			self dodamage(20, startspot);
			axis[0] magicgrenade(startspot, self.origin, 3.0);
			wait randomint (5);
		}
	}
}

		// changes player speed over set time
player_speed_set(speed, time)
{
	currspeed = int( getdvar( "g_speed" ) );
	goalspeed = speed;
	if( !isdefined( self.g_speed ) )
		self.g_speed = currspeed;     
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;          
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
    setsaveddvar( "g_speed", int(currspeed) );
  	wait interval;
	}
  setsaveddvar( "g_speed", goalspeed );
}

wait_n_notify(time, mynotify)
{
	wait time;
	if (isdefined(self))
		self notify (mynotify);
}

wait_n_delete(time)
{
	wait time;
	if (isdefined(self))
		self delete();
}

waittill_trig_n_setflag(myflag, thing)
{
	thing setwaitnode(self);
	wait 0.2;
	thing waittill ("reached_wait_node");
	flag_set(myflag);
}
waittill_trig_n_notify(mynotify, thing, sdknode)
{
	while (1)
	{
		self waittill ("trigger", triggerer);
		if (!isdefined(thing))
			break;
		if (thing == triggerer)
			break;
	}
	if (isdefined(sdknode))
	{
		level.sdknode = sdknode;
	}
	level notify (mynotify);
}
			// adds pacifist spawn function to all spawners desired to be pacifist
setup_paci_spawners()
{
	guys = getentarray("initial_convoy_guys", "targetname");
	level thread setup_paci_spawners2(guys);
	
	guys = getentarray("E1_C1_weary_soldiers", "targetname");
	level thread setup_paci_spawners2(guys);
	
	guy = getent("bridge2_guy", "targetname");
	guy thread add_spawn_function(::solo_set_pacifist, true);
	
	guys = getentarray("bridge3_guys_infight", "targetname"); 
	level thread setup_paci_spawners2(guys);
	
	guys = getentarray("bridge2_convoy_guys", "targetname"); 
	level thread setup_paci_spawners2(guys);
}


setup_paci_spawners2(guys)
{
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::solo_set_pacifist,true);
	}
}
			// turns the reinforcements on and off so that guys only reinforce in groups every minute
			// instead of a constant stream of one guy at a time
reinforcements_in_waves()
{
	trigs = getentarray("friendly_respawn_trigger", "targetname");
	array_thread(trigs, ::respawn_go);
	level waittill ("respawn_guys_now");
	for (;;)
	{
		level endon ("level_ending");
		flag_clear("respawn_friendlies");
		wait 60;
		flag_set("respawn_friendlies");
		wait 5;
	}
}
		// used for reinforcements, waits for the first reinforcement trigger to call loop in 
		// previous function and ends this thread on all other trigger
respawn_go()
{
	level endon ("respawn_guys_now");
	self waittill ("trigger");
	level notify ("respawn_guys_now");
}

		// sends notify when player shoots
waitfor_player_attack(mynotify,org_coord, coord_val)
{
	self endon ("death");
	self endon ("disconnect");
	while (1)
	{
		self thread waitfor_player_grenade(mynotify);
		self waittill( "action_notify_attack" );
		if (isdefined(org_coord) && isdefined(coord_val) && self.origin[org_coord] > coord_val)
		{
			break;
		}
		else if (!isdefined (org_coord))
			break;
	}
	level notify (mynotify);
}
		// sends notify when player uses grenade
waitfor_player_grenade(mynotify)
{
	self endon("death");
	self endon ("disconnect");
	self waittill ("grenade_pullback");
	wait 4;
	level notify (mynotify);
}

notify_on_trig(mynotify)
{
	self waittill ("trigger");
	level notify (mynotify);
}

		// ends when a vehicle gets to a node
vehicle_at_node(node)
{
	while (1)
	{
		node waittill ("trigger", thing);
		if (thing==self)
		{
			break;
		}
	}
}
	
set_stances(stance1, stance2, stance3)
{
	if (isdefined(stance3))
	{
		for (i=0; i<self.size; i++)
		{
			self[i] allowedstances(stance1, stance2, stance3);
		}
		return;
	}
	if (isdefined(stance2))
	{
		for (i=0; i<self.size; i++)
		{
			self[i] allowedstances(stance1, stance2);
		}
		return;
	}
	else
	{
		for (i=0; i<self.size; i++)
		{
			self[i] allowedstances(stance1);
		}
	}
}

waittill_enemy(mynotify)
{
	self.goalradius = 25;
	self waittill_either ("enemy", "death");
	level notify (mynotify);
}

waittill_notify_n_trig(mynotify, trigme)
{
	self waittill (mynotify);
	if (isdefined(trigme))
		trigme thread trigger_and_delete();
}

triggeron_on_notify(mynotify, trigmeon)
{
	self waittill (mynotify);
	if (isdefined(trigmeon))
		trigmeon trigger_on();
}


reset_run_anim()
{
	self endon ("death");
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}

set_sneak_walk(state)
{
	self endon ("death");
	if (state == true)
	{
		self.animname = "sneaky_squad";
		self thread set_run_anim( "sneaky_walk1");
	}
	else 
	{
		self reset_run_anim();
		self.cqbwalking = false;
		self allowedstances("stand","crouch","prone");
	}
}

stop_on_node(node)
{
	node waittill_trig_n_notify("nothing", self);
	self setspeed (0,100,100);
	self.inplace = true;
}

tiger_stop_on_node(node)
{
	self setwaitnode(node);
	wait 0.2;
	self waittill ("reached_wait_node");
	self setspeed (0,10,10);
}

wait_n_destroy(waittime)
{
	wait (waittime);
	self.health = 1;
	radiusdamage(self.origin, 200, 50, 35);
}

shock_me(shock, time)
{
	self endon ("death");
	self shellshock(shock, time);
	self setstance("prone");
	self allowstand(false);
	self allowcrouch(false);
	wait (time-2);
	self allowstand(true);
	self allowcrouch(true);
}
