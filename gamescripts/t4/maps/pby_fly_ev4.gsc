


main()
{
	maps\pby_fly_fx::main();
	maps\pby_fly_anim::main();
	
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair");
	maps\_aircraft::main( "vehicle_jap_airplane_zero_fly", "zero" );
	build_player_planes("pby");
	build_enemy_vehicles("zero"); //-- This should take the place of maps\_aircraft::main( "vehicle_jap_airplane_zero_fly", "zero" );
	build_enemy_vehicles("jap_ptboat");
	build_enemy_vehicles("jap_shinyo");
	
	//-- Precache some stuff
	precacheitem("type99_lmg");
	precachemodel("vehicle_jap_airplane_zero_d_wingr");
	precachemodel("vehicle_jap_airplane_zero_d_wingl");
	precachemodel("vehicle_jap_airplane_zero_d_tail");
	precachemodel("tag_origin");
	
	//-- Checkpoints and Default Starts
	add_start( "crash", ::jumpto_event5 );
	add_start( "rescue", ::jumpto_event4 );
	add_start( "after_boats", ::jumpto_event3 );
	add_start( "turret_tut", ::jumpto_event2 );
	add_start( "boat_strafe", ::jumpto_event2_strafe_boats );
	//default_start( ::event1 ); //event1
	default_start( ::jumpto_event4 );
	
	//level.custom_introscreen = ::pby_custom_introscreen;
			
	maps\_load::main();
	
	//reset the center of the map
	SetMapCenter((0,0,0));
	
	//-- Enable the Mitton Water
	watersimenable (true);
	my_level_init();
}

my_level_init()
{
	wait_for_first_player();
	
	//-- Basic Level Var Setup
	level.undef = Spawn("script_origin", (0,0,0));
	assert(IsDefined(level.undef), "wtf are you defined?");
	
	//-- init flying vars
	//level.max_speed = 60; //PBY
	level.max_speed = 40; //PBY
	level.zero_max_speed = 120;
	level.zero_min_speed = 70;
			
	//-- Setup the players on the plane
	setup_player_planes();
	level notify("planes_inited");
	
	//-- I put this in here for the jumpto functions
	level notify("player_plane_inited");
	
	level.players = get_players_pby();
	level.players[0].plane = level.plane_a;
	for(i=0; i<4; i++)
	{
		if(IsDefined(level.players[i])&& (level.players[i] != level.undef))
		{
			level.players[i] thread turret_switch_watch();
			level.players[i] setup_seat_control();
			level.players[i] thread move_to_pilots_suggested_seat();
			level.players[i] DisableTurretDismount();
			
			
			//TODO: remove this or do it properly somewhere else
			level.players[i] thread manage_pilots_suggested_seat();
			level.players[i] set_pilots_suggested_seat("pby_rightgun", "pby_frontgun");
		}
	}
	
	for(i=0; i<4; i++)
	{
		if(IsDefined(level.players[i])&& (level.players[i] != level.undef))
		{
			get_players_pby()[i] force_players_into_seat("starting");
		}
	}
	
	init_callbacks();
	
	//level thread maps\pby_fly_fx::spawn_cloud_effects();
	
	/#
	
	run_special_debug_functions();
	
	#/
	
	level thread debug_hud_elems();
}

debug_hud_elems()
{
	level.seat_hud = newHudElem();
	level.seat_hud.alignX = "left";
	level.seat_hud.x = 20;
	level.seat_hud.y = 290;
	
	while(1)
	{
		level.seat_hud SetText(get_players_pby()[0].current_seat);
		wait(0.1);
	}	
}

//-- Co-op Callback Init
init_callbacks()
{
	level thread onPlayerConnect();
}

//-- Sets up the planes with guns/seats
setup_player_planes()
{
	level.plane_a = player_pby_init("player_plane_a", "_a");
	level.plane_b = player_pby_init("player_plane_b", "_b");
}

//-- setup variables for seat tracking
setup_seat_control(specific_seat)
{
	if(!IsDefined(specific_seat))
	{
		self.current_seat = "undefined";
		self.wanted_seat = "undefined";
	}
	else
	{	//-- Used when the player is forced into a specific seat
		self.current_seat = specific_seat;
		self.wanted_seat = "undefined";
	}
}


//-- Controls the Pilot's Suggested Seat and sets that value on the player characters
set_pilots_suggested_seat(suggested_seat, alternate_seat)
{
	if(IsDefined(self))
	{
		self.pilots_suggested_seat = suggested_seat;
		self.pilots_alternate_seat = alternate_seat;
	}
}

manage_pilots_suggested_seat()
{
	if(self.plane == level.plane_a)
	{
		waittill_ent = level.plane_a;
	}
	else
	{
		waittill_ent = level.plane_b;
	}
	
	while(1) //infinite loop go!
	{
		waittill_ent waittill("noteworthy", the_noteworthy);
		
		//setup the specific pilot specified seats using noteworthys from the planes path
		switch(the_noteworthy)
		{
			case "pilot_seats_front_right":
				self set_pilots_suggested_seat("pby_frontgun", "pby_rightgun");
			break;
			
			case "pilot_seats_front_left":
				self set_pilots_suggested_seat("pby_frontgun", "pby_leftgun");
			break;
			
			case "pilot_seats_front_rear":
				self set_pilots_suggested_seat("pby_frontgun", "pby_backgun");
			break;
			
			case "pilot_seats_right_front":
				self set_pilots_suggested_seat("pby_rightgun", "pby_frontgun");
			break;
			
			case "pilot_seats_right_left":
				self set_pilots_suggested_seat("pby_rightgun", "pby_leftgun");
			break;
			
			case "pilot_seats_right_rear":
				self set_pilots_suggested_seat("pby_rightgun", "pby_backgun");
			break;
			
			case "pilot_seats_left_front":
				self set_pilots_suggested_seat("pby_leftgun", "pby_frontgun");
			break;
			
			case "pilot_seats_left_right":
				self set_pilots_suggested_seat("pby_leftgun", "pby_rightgun");
			break;
			
			case "pilot_seats_left_rear":
				self set_pilots_suggested_seat("pby_leftgun", "pby_backgun");
			break;
			
			case "pilot_seats_rear_front":
				self set_pilots_suggested_seat("pby_backgun", "pby_frontgun");
			break;
			
			case "pilot_seats_rear_right":
				self set_pilots_suggested_seat("pby_backgun", "pby_rightgun");
			break;
			
			case "pilot_seats_rear_left":
				self set_pilots_suggested_seat("pby_backgun", "pby_leftgun");
			break;
		}
		
		//iprintlnbold("pilot seats adjusted");
	}
}

//-- Moves the player to the pilot's favorite seat if they hit the USE button
move_to_pilots_suggested_seat()
{
	if(!IsDefined(self.in_saving_position))
	{
			self.in_saving_position = false;
	}
		
	while(true)
	{
		while(!self useButtonPressed())
		{
			wait(0.05);
		}
		
		if(!self.in_saving_position)
		{
			switch_successful = self switch_turret(self.pilots_suggested_seat);
			
			if(!switch_successful)
			{
				switch_successful = self switch_turret(self.pilots_alternate_seat);
			}
			
			ASSERTEX(switch_successful, "The player failed to go to the suggested or alternate seat. Something is broken.");
			
			wait(2); //TODO: FIGURE OUT THE ACTUAL TIME FOR THIS
		}
		else
		{
			self notify("perform_save");
			wait(2);
		}
	}
}

//-- Returns TRUE if the player is in his proper seat according to the pilot
compare_seat_to_pilots()
{
	in_proper_seat = false;
	
	if(self.current_seat == self.pilots_suggested_seat)
	{
		in_proper_seat = true;
	}
	
	if(self.current_seat == self.pilots_alternate_seat)
	{
		in_proper_seat = true;
	}
	
	return in_proper_seat;
}
//-- Level Gameplay Functions --------------------------------------------------------------------------------

//--  Plane starts in the air, PBY calls into nearby fleet, Player gets told the instructions on how to move
event1()
{
	//level waittill("finished final intro screen fadein");
	//level waittill( "controls_active" );
	
	set_objective("scout_ocean");
	
	//-- starting pby_node
	new_starting_node = GetVehicleNode("pby_a_level_start", "targetname");
			
	//-- Start Plane A flying
	level.plane_a AttachPath(new_starting_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_a StartPath();
	level.max_speed = 40; //slower at the beginning
	level.plane_a jumpto_speed(level.max_speed);
	
	level thread event1_dialogue();
	level thread event1_player_prints();
	
	//-- wait until specific point in the path, then switch to event2
	trig_ev2 = GetEnt("trigger_event2", "targetname");
	trig_ev2 waittill("trigger");
	event2_strafe_boats();
}

event1_dialogue()
{
	//-- intro pilot dialogue
	level anim_single_solo(level.plane_a.pilot, "intro");
	wait(5);
	level anim_single_solo(level.plane_a.radioop, "intro");
	wait(5);
	level anim_single_solo(level.plane_a.radioop, "intro2");
	wait(5);
	//-- TODO: add in the radios response
	wait(5);
	level anim_single_solo(level.plane_a.pilot, "intro2");
	
	wait(15);
	
	level anim_single_solo(level.plane_a.pilot, "do_you_see");
	wait(5);
	level anim_single_solo(level.plane_a.copilot, "i_see");
	wait(3);
	level anim_single_solo(level.plane_a.pilot, "ok_form_up");
}

event1_player_prints()
{
	iprintlnbold("Use the D-Pad to navigate around the aircraft from turret to turret.");
	wait(5);
	iprintlnbold("Press X to go to the seat suggested by the Pilot.");
	wait(5);
}

take_off_accel()
{
	current_speed = self GetSpeedMPH();
	
	//-- Initial rolling speed
	while(current_speed < (level.max_speed * 0.3))
	{
		current_speed = current_speed + 0.3;
		self SetSpeedImmediate(current_speed, 0.1, 0.1);
		wait(0.1);
	}
	
	//-- Getting faster
	while(current_speed < (level.max_speed * 0.6))
	{
		current_speed = current_speed + 1.0;
		self SetSpeedImmediate(current_speed, 0.1, 0.1);
		wait(0.1);
	}
	
	//-- Yay I'm flying
	while(current_speed < (level.max_speed))
	{
		current_speed = current_speed + 1.4;
		self SetSpeedImmediate(current_speed, 0.1, 0.1);
		wait(0.1);
	}
}

jumpto_speed(new_speed)
{
	self SetSpeedImmediate(new_speed, 0.1, 0.1);
}

//-- This will display the tutorial text for how to switch between turrets.
//--   It will also handle the tutorial targets that you shoot.

//gp_tutorial_turret()
event2()
{
	level thread event3();
	level thread spawn_escorting_corsairs();
	
	//-- setup initial strings and hud elem
	str_intro = &"PBY_FLY_TUT_INTRO";
	str_dpad = &"PBY_FLY_TUT_SWITCH";
	
	level.tut_hud = newHudElem();
	level.tut_hud.alignX = "left";
	level.tut_hud.x = 20;
	level.tut_hud.y = 277;
	
	level.tut_hud SetText(str_intro);
	wait(5);
	level.tut_hud SetText(str_dpad);
	
	//-- wait until the player switches to a new turret position
	
	//-- check and see if the player is playing co-op
	
}

spawn_escorting_corsairs()
{
	my_trig = GetEnt("spawn_corsair_trig", "targetname");
	my_trig waittill("trigger");
	
	rcl_node = GetVehicleNode("right_corsair_lead", "targetname");
	rca_node = GetVehicleNode("right_corsair_a", "targetname");
	rcb_node = GetVehicleNode("right_corsair_b", "targetname");
	
	corsair_right_lead = spawn_plane_and_pace("corsair", rcl_node, level.plane_a, 1000);
	spawn_plane_and_pace("corsair", rca_node, corsair_right_lead, 500);
	spawn_plane_and_pace("corsair", rcb_node, corsair_right_lead, 500);
	
}

watch_for_targets()
{
	i = 0;
	level.tut_targets = [];
	
	//start_node = GetVehicleNode("start_zero_spawning", "targetname");
	start_node = GetVehicleNode("start_chase_zeros", "targetname");
	//start_node waittill("trigger");
	//level thread turn_on_the_clouds();
	
	level.spawned_hud = newHudElem();
	level.spawned_hud.alignX = "left";
	level.spawned_hud.x = 20;
	level.spawned_hud.y = 303;
	
	level.killed_hud = newHudElem();
	level.killed_hud.alignX = "left";
	level.killed_hud.x = 20;
	level.killed_hud.y = 316;
	
	
	level.spawned_hud SetText("Zeros Spawned: " + i);
	level.killed_hud SetText("Zeros Killed: " + i);
	
	ai_type = "doodoo";
	
	level thread debug_watch_dead_zeros();
	
	while(1)
	{
		ai_type = "basic_rear";
		
		/*
		//TODO: TURN THIS INTO THE ACTUAL TARGET TRAINING
		if(RandomInt(2) == 1)
		{
			ai_type = "intercept_right";
		}
		else
		{
			ai_type = "intercept_left";
		}
		*/
		level.tut_targets[i] = spawn_enemy_plane("zero", "tut_plane" +i, ai_type);
		if(!IsDefined(level.tut_targets[i]))
		{
			break;
		}
		i++;
		level.spawned_hud SetText("Zeros Spawned: " + i);
		wait(5);
	}
}

//TODO: FINISH THIS SO IT WORKS FOR BOTH PLANES
turn_on_the_clouds()
{
	cloud_fx = playloopedfx(level._effect["ambient_clouds"], 3, level.plane_a.origin, 0);
}

debug_watch_dead_zeros()
{
	i = 0;
	
	while(1)
	{
		level waittill("zero_killed");
		i++;
		level.killed_hud SetText("Zeros Killed: " + i);
	}
	
}


//-- This is the event where the player(s) taxi to the victim(s) and rescue the victim(s) from the water
event3()
{
	iprintlnbold("THE SUN RISES");
	
	level thread event3_ambient(); 
	level thread event3_dialogue();
	
	level.plane_a waittill("reached_end_node");
	
	new_start_node = GetVehicleNode("circling_start_node", "targetname");
			
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
	
	level thread event4();
}

event3_dialogue()
{
	wait(5);
	level anim_single_solo(level.plane_a.radioop, "recieved_distress"); 	//"print: We just received a distress call from that naval fleet.";
	wait(5);
	level anim_single_solo(level.plane_a.radioop, "kamikaze_attack");			//"print: Sounds like they were victim of a jap kamikaze ambush.";
	wait(5);
	level anim_single_solo(level.plane_a.radioop, "requesting_help");			//"print: They are requesting help from anyone in the area.  Do we have enough fuel to go help out?";
	wait(5);
	level anim_single_solo(level.plane_a.pilot, "save_and_fuel");					//"print: It doesn't matter if we have enough fuel! Tell them we are on the way!";
	set_objective("respond_to_distress_call");
	

}


//-- This should handle the dog fights that are happening above the wreckage
//-- Need about 10 planes total probably
event3_ambient()
{
	df_splines = [];	
	df_splines[0] = GetVehicleNode("dogfight_spline_00", "targetname");
	df_splines[1] = GetVehicleNode("dogfight_spline_01", "targetname");
	df_splines[2] = GetVehicleNode("dogfight_spline_02", "targetname");
	
	//-- Spawn the fleeing planes and set them on the spline
	level thread spawn_plane_loop_spline("corsair", df_splines[0]);
	level thread spawn_plane_loop_spline("zero", df_splines[1]);
	level thread spawn_plane_loop_spline("corsair", df_splines[2]);
	
	wait(2);
	
	//-- Spawn the pursuing planes and set them on the spline
	level thread spawn_plane_loop_spline("zero", df_splines[0]);
	level thread spawn_plane_loop_spline("corsair", df_splines[1]);
	level thread spawn_plane_loop_spline("zero", df_splines[2]);
	
	wait(10);
	
	level thread spawn_plane_loop_spline("corsair", df_splines[0]);
	wait(0.2);
	level thread spawn_plane_loop_spline("zero", df_splines[1]);
	wait(0.2);
	level thread spawn_plane_loop_spline("zero", df_splines[2]);
	
	wait(2.6);
	
	level thread spawn_plane_loop_spline("zero", df_splines[0]);
	wait(0.2);
	level thread spawn_plane_loop_spline("corsair", df_splines[1]);
	wait(0.3);
	level thread spawn_plane_loop_spline("corsair", df_splines[2]);
	
}

spawn_plane_loop_spline(type, start_node)
{
	plane = level.undef;
	model = "vehicle_jap_airplane_zero_fly";
	t_name = start_node.targetname + type;
	position = start_node.origin;
	ang = start_node.angles;
	
	if(type == "zero")
	{
		model = "vehicle_jap_airplane_zero_fly";
		t_name = start_node.targetname + type;
		type = "zero";
		position = start_node.origin;
		ang = start_node.angles;
	}
	else if(type == "corsair")
	{
		model = "vehicle_usa_aircraft_f4ucorsair";
		t_name = start_node.targetname + type;
		type = "corsair";
		position = start_node.origin;
		ang = start_node.angles;
	}
	else
	{
		ASSERTEX(false, "You have a spelling error somewhere.");
	}
	
	plane = SpawnVehicle(model, t_name, type, position, ang);
	
	while(1)
	{
		plane AttachPath(start_node);
		plane StartPath();
		plane SetSpeed(60, 20, 20);
		
		plane waittill("reached_end_node");
	}
}

spawn_plane_and_pace(type, start_node, lead_plane, distance)
{
	plane = level.undef;
	model = "vehicle_jap_airplane_zero_fly";
	t_name = start_node.targetname + type;
	position = start_node.origin;
	ang = start_node.angles;
	
	if(type == "corsair")
	{
		model = "vehicle_usa_aircraft_f4ucorsair";
		t_name = start_node.targetname + type;
		type = "corsair";
		position = start_node.origin;
		ang = start_node.angles;
	}
	else
	{
		ASSERTEX(false, "You have a spelling error somewhere.");
	}
	
	plane = SpawnVehicle(model, t_name, type, position, ang);
	
	plane AttachPath(start_node);
	plane StartPath();
	plane SetSpeed(level.max_speed, 20, 20);
	
	if(!IsDefined(distance))
	{
		distance = 30;
	}
	
	plane thread corsair_pby_pacing(lead_plane, distance);
	
	return plane;
		
}

//-- This is the saving event that is long and overly complicated because I love a huge scripting mess
event4()
{
	rescue_scene_init();
	
	stop_node = GetVehicleNode("stop_for_rescue_1_a", "targetname");
	stop_node waittill("trigger");
	
	level.plane_a SetSpeed(0,100,100);
	
	//-- This is a boat test
	test_boat = GetEnt("test_boat", "targetname");
	test_boat.scriptname = "test_boat";
	test_boat thread track_damage_and_sink();
	test_boat_node = GetVehicleNode("boat_test_node", "targetname");
	
	test_boat AttachPath(test_boat_node);
	test_boat StartPath();
	test_boat SetSpeed(10, 10, 10);
	
		
	//test_boat waittill("reached_end_node");
	
	//-- This is where the first rescue will happen
	
	wait(2);
	
	for(i = 0; i < level.survivors_group_1.size; i++)
	{
		level.survivors_group_1[i] notify("swimming_notify" + i);
		level.survivors_group_1[i] thread rescue_scenario();
		level.survivors_group_1[i] waittill("rescued");
	}
	
	wait(5);
	
	//-- This is where the slo-mo event will happen
	
	//-- Taxi to the next section
	level.plane_a SetSpeed(20, 10, 10);
	
	//-- Stop for 2nd rescue
	stop_node = GetVehicleNode("stop_for_rescue_2_a", "targetname");
	stop_node waittill("trigger");
	
	level.plane_a SetSpeed(0, 100, 100);
	
	//-- This is where the second rescue will happen
		
	wait(5);
	
	//-- Take off into event 5
	level.plane_a SetSpeed(20, 10, 10);
	level.plane_a waittill("reached_end_node");
	iprintlnbold(" Zero Zig Zag Event Coming Soon!  END SCRIPT ");
	
	/* -------------------------------  THIS IS OLD EVENT 4 SCRIPT ----------------------------------------------
	
	level.plane_a waittill("rescue_done");
		
	taxi_start_node = GetVehicleNode("plane_a_taxi_start_b", "targetname");
	level.plane_a AttachPath(taxi_start_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
	
	//TODO: make this happen at a specific place
	level thread watch_for_targets();
	level thread switching_to_occupied_turret_text();
	
	level thread event5(); //-- Next event fires at the end of the path.
	*/
}

rescue_scenario()
{
	self waittill("ready_to_be_saved");
	
	possible_player = level.undef;
	while(possible_player == level.undef)
	{
		wait(0.1);
		possible_player = is_there_a_player_in_seat(self.plane, self.side);
	}
	
	possible_player.in_saving_position = true;
	possible_player waittill("perform_save");
	self notify("being saved");
	
	possible_player thread play_rescue_animation(self.plane, self.side);
	
	self.animname = "being_saved";
	self anim_single_solo(self, "enter_pby");
	
	bunk_tag = get_empty_bunk(self.plane);
	
	if(bunk_tag == "tag_bunk_left_bottom")
	{
		self.animname = "rescue_a_4";
		self.plane thread anim_loop_solo(self, "my_idle", bunk_tag);
	}
	else if(bunk_tag == "tag_bunk_left_top")
	{
		self.animname = "rescue_a_3";
		self.plane thread anim_loop_solo(self, "my_idle", bunk_tag);
	}
	else if(bunk_tag == "tag_bunk_right_bottom")
	{
		self.animname = "rescue_a_1";
		self.plane thread anim_loop_solo(self, "my_idle", bunk_tag);
	}
	else //tag_bunk_right_top
	{
		self.animname = "rescue_a_2";
		self.plane thread anim_loop_solo(self, "my_idle", bunk_tag);
	}

	self LinkTo(self.plane, bunk_tag);
	
	self notify("rescued");
}

play_rescue_animation(plane, side)
{
	//-- Take the player off of the plane
	plane UseBy(self);
	
	if(side == "left")
	{
		anim_str = "pby_left_rescue";
	}
	else
	{
		anim_str = "pby_right_rescue";
	}
	//-- plays the animation	
	startorg = getstartOrigin( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
	startang = getstartAngles( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
		
	player_hands = spawn_anim_model( "player_hands" );
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane);
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;
	self PlayerLinkTo(player_hands, "tag_player", 1.0, 10, 10, 10, 10);
		
	plane maps\_anim::anim_single_solo( player_hands, anim_str );
	
	player_hands delete();
	//-- end playing the animation
	
	if(self.current_seat == "pby_leftgun")
	{
		plane usevehicle(self, 2);
	}
	else
	{
		plane usevehicle(self, 3);
	}
}

get_empty_bunk(plane)
{
	for(i=0; i < plane.bunks.size; i++)
	{
		if(plane.bunks[i]["status"] == "empty")
		{
			//tag_position = plane GetTagOrigin(plane.bunks[i]["tag"];
			//return tag_position;
			plane.bunks[i]["status"] = "full";
			return plane.bunks[i]["tag"];
		}
	}	
	
	ASSERTEX(false, "THERE WERE NO FREE BUNKS");
}

is_there_a_player_in_seat(plane, seat)
{
	if(seat == "left")
	{
		seat_wanted = "pby_leftgun";
	}
	else
	{
		seat_wanted = "pby_rightgun";
	}
	
	current_players = get_players_pby();
	
	for(i=0; i<current_players.size; i++)
	{
		if(current_players[i] != level.undef)
		{
			//if( pick_proper_plane(current_players[i]) == plane )
			//{
				if(current_players[i].current_seat == seat_wanted)
				{
					return current_players[i];
				}
			//}
		}
	}
	
	return level.undef;
}

rescue_scene_init()
{
	//spawn first group of survivors
	surv_spawners = [];
	surv_spawners = GetEntArray("survivor_rescue_1", "targetname");
	
	level.survivors_group_1 = [];
	for(i = 0; i<surv_spawners.size; i++)
	{
		level.survivors_group_1[i] = surv_spawners[i] StalingradSpawn();
		level.survivors_group_1[i] thread survivor_init(level.plane_a, "_group_1", i);
	}
}

#using_animtree ("generic_human");

//sets the survivor up to go to his goal saving position
survivor_init(plane, group, id)
{
	//-- assign the guy his side
	self.plane = plane;
	self.side = self.script_noteworthy;
	self.animname = "survivor_" + id;
	self.run_noncombatanim = %ch_pby_swimming_soldier;
	
	//setup the treading activity
	self.activity = "treading";
	self thread survivor_wave();
		
	self waittill("swimming_notify" + id);
	
	//-- send the guy to his new goal position, then raise the "i need to be saved signal", the make the player save them.
	self.goalradius = 32;
	goal_pos = (0,0,0);
	
	if(self.side == "left")
	{
		goal_pos = plane GetTagOrigin("tag_blister_left_rescue");
	}
	else
	{
		goal_pos = plane GetTagOrigin("tag_blister_right_rescue");
	}
	
	self.activity = "swimming";
	self SetGoalPos(goal_pos);
	self waittill("goal");
	
	
	self.activity = "treading";
	self thread survivor_wave();
	self notify("ready_to_be_saved");
	
	if(self.side == "left")
	{
		iprintlnbold("Left Blister - survivor ready");
	}
	else
	{
		iprintlnbold("Right Blister - survivor ready");
	}
	
}

//-- play the treading water/waving animation on the survivors when they aren't swimming or at the boat
survivor_wave()
{
	//TODO: Look into this being played as an actual animloop, instead of as a looping anim_single_solo
	self endon("being saved");
	
	//self anim_single_solo(self, "enter_pby");
	//anim_loop( guy, anime, tag, ender, node, tag_entity )
	//self anim_loop_solo( self, "float", undefined, "end_floating");
	
	while(self.activity == "treading")
	{
		self anim_single_solo(self, "float");
	}
	
	//self notify("end_floating");
}

//-- This is the EMERGENCY LANDING!!! BLAMMO
event5()
{
	level.plane_a waittill("reached_end_node");
	
	iprintlnbold("THE EMERGENCY ANIMATION GOES HERE");
	missionsuccess("hol2",false);
}


//-- Player on the plane functions --------------------------------------------------------------------------------


//-- Inits all the values for each player plane
player_pby_init(plane_name, crew_id)
{
	plane = GetEnt(plane_name, "targetname");
	plane.plane_name = plane_name;	
	plane.crew_id = crew_id;
		
	plane.front = "empty";
	plane.left = "empty";
	plane.right = "empty";
	plane.back = "empty";
	
	plane.bunks = [];
	plane.bunks[0]["status"] = "empty";
	plane.bunks[1]["status"] = "empty";
	plane.bunks[2]["status"] = "empty";
	plane.bunks[3]["status"] = "empty";
	
	plane.bunks[0]["tag"] = "tag_bunk_left_bottom";
	plane.bunks[1]["tag"] = "tag_bunk_left_top";
	plane.bunks[2]["tag"] = "tag_bunk_right_bottom";
	plane.bunks[3]["tag"] = "tag_bunk_right_top";
	
	plane pby_crew_init();
	plane thread pby_crew_idles();
	
	return(plane); 
}

//-- Sets up the crew for the plane
pby_crew_init()
{
	//-- Pilot
	pilot_spawner = GetEnt(self.plane_name + "_pilot", "targetname");
	self.pilot = pilot_spawner StalingradSpawn();
	//self.pilot LinkTo(self, "tag_pilot", (0,0,0), (0,0,0));
	self.pilot.animname = "pilot" + self.crew_id;
	
	//-- Co-Pilot
	copilot_spawner = GetEnt(self.plane_name + "_copilot", "targetname");
	self.copilot = copilot_spawner StalingradSpawn();
	//self.copilot LinkTo(self, "tag_copilot", (0,0,0), (0,0,0));
	self.copilot.animname = "copilot" + self.crew_id;
	
	//-- Radio Operator
	radioop_spawner = GetEnt(self.plane_name + "_radioop", "targetname");
	self.radioop = radioop_spawner StalingradSpawn();
	//self.radioop LinkTo(self, "tag_radioop", (0,0,0), (0,0,0));
	self.radioop.animname = "radio_op" + self.crew_id;
		
	//-- Engineer
	engineer_spawner = GetEnt(self.plane_name + "_engineer", "targetname");
	self.engineer = engineer_spawner StalingradSpawn();
	//self.engineer LinkTo(self, "tag_engineer", (0,0,0), (0,0,0));
	self.engineer.animname = "engineer" + self.crew_id;
}

pby_crew_idles()
{
	//TODO: HOOK THIS UP FOR THE 2ND CREW
	if(self.crew_id == "_b")
	{
		return;
	}
	
	self thread anim_loop_solo(self.pilot, "my_idle", "tag_pilot", "stop_idling");
	self.pilot LinkTo(self, "tag_pilot");
	
	self thread anim_loop_solo(self.copilot, "my_idle", "tag_copilot", "stop_idling");
	self.copilot LinkTo(self, "tag_copilot");
	
	self thread anim_loop_solo(self.radioop, "my_idle", "navigator_seat_jnt", "stop_idling");
	self.radioop LinkTo(self, "navigator_seat_jnt");
	
	self thread anim_loop_solo(self.engineer, "my_idle", "tag_engineer", "stop_idling");
	self.engineer LinkTo(self, "tag_engineer");
}

//-- fires off when the weapon is changed
turret_switch_watch()
{
	for(;;)
	{
		self waittill("weapon_change_on_turret", weapon_name);
		//self waittill("weapon_change");
		self switch_turret(weapon_name);		
	}
}

//-- Moves the player around the plane based on the selected seat.
switch_turret(weapon_name)
{
	
	if(IsDefined(self.seat_locked))
	{
		if(self.seat_locked)
		{
			return false; //-- Players seat is locked and he can't switch 
		}
	}
	
	plane = "undefined";
	plane = pick_proper_plane(self);
			
	self.wanted_seat = weapon_name;
		

	if(self.wanted_seat == "pby_frontgun")
	{
		if(plane.front == "empty")
		{
			plane.front = "has_player";
			
			self play_transition_to_front(plane);
			plane usevehicle(self, 1);
		}
	}
	else if(self.wanted_seat == "pby_leftgun")
	{
		if(plane.left == "empty")
		{
			plane.left = "has_player";
			
			self play_transition_to_left(plane);
			plane usevehicle(self, 2);
		}
	}
	else if(self.wanted_seat == "pby_rightgun")
	{
		if(plane.right == "empty")
		{
			plane.right = "has_player";
			
			self play_transition_to_right(plane);
			plane usevehicle(self, 3);
		}
	}
	else if(self.wanted_seat == "pby_backgun")
	{
		if(plane.back == "empty")
		{
			plane.back = "has_player";
			
			self play_transition_to_rear(plane);
			plane usevehicle(self, 4);
		}
	}
	else //The wanted seat was not available
	{
		return false; //non successful seat found
	}
		
	switch(self.current_seat)
	{
		case "pby_frontgun":
			plane.front = "empty";
		break;
	
		case "pby_leftgun":
			plane.left = "empty";
		break;
	
		case "pby_rightgun":
			plane.right = "empty";
		break;
	
		case "pby_backgun":
			plane.back = "empty";
		break;
	
		default:
		break;
	}
		
	self.current_seat = self.wanted_seat;
	self.wanted_seat = -1;
	
	return true; //successful seat switch
}

play_transition_to_rear(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
			self play_transition_animation(plane, "pby_front_to_rear");
		break;
		
		case "pby_leftgun":
			self play_transition_animation(plane, "pby_left_to_rear");
		break;
		
		case "pby_rightgun":
			self play_transition_animation(plane, "pby_right_to_rear");
		break;
		
		default:
		break;
	}
}


play_transition_to_front(plane)
{
	switch(self.current_seat)
	{
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_front");
		break;
		
		case "pby_leftgun":
			self play_transition_animation(plane, "pby_left_to_front");
		break;
		
		case "pby_rightgun":
			self play_transition_animation(plane, "pby_right_to_front");
		break;
		
		default:
		break;
	}
}


play_transition_to_right(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
			self play_transition_animation(plane, "pby_front_to_right");
		break;
		
		case "pby_leftgun":
			self play_transition_animation(plane, "pby_left_to_right");
		break;
		
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_right");
		break;
		
		default:
		break;
	}
}

play_transition_to_left(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
			self play_transition_animation(plane, "pby_front_to_left");
		break;
		
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_left");
		break;
		
		case "pby_rightgun":
			self play_transition_animation(plane, "pby_right_to_left");
		break;
		
		default:
		break;
	}
}


play_transition_animation(plane, anim_str)
{
	//-- Take the player off of the plane
	plane UseBy(self);
	
	//-- plays the animation	
	startorg = getstartOrigin( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
	startang = getstartAngles( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
		
	player_hands = spawn_anim_model( "player_hands" );
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane);
	
	//TODO: I think this is a hack and it seems like PlayerLinkTo isn't actually really linking the player and it's not clamping the angles.
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;
	//self PlayerLinkTo(player_hands, "tag_player", 1.0, 20, 20, 10, 10);
	self PlayerLinkTo(player_hands, "tag_player", 1.0, 10, 10, 10, 10);
	//self PlayerLinkTo(player_hands);
	
	plane maps\_anim::anim_single_solo( player_hands, anim_str );
	
	player_hands delete();
	//-- end playing the animation
}


//-- returns the proper plane for me based on which player me is
pick_proper_plane( me )
{
	placeholder = get_players_pby();
	for(i=0; i<4; i++)
	{
		if(IsDefined(placeholder[i]))
		{
			if(me == placeholder[i])
			{
				/* TODO: MAKE THIS 2 PLANES AGAIN
				if(i == 0 || i == 2)
				{
					return level.plane_a;
				}
				else
				{
					return level.plane_b;
				}
				*/
				
				return level.plane_a;
			}
		}
	}
}

//-- This is used to place players in specific seats during
//-- specific sections of gameplay
force_players_into_seat(position_string)
{
	plane = pick_proper_plane(self);
	
	switch(position_string) //-- The position that the players start in for the map
	{
		case "starting":
			if(self.play_tag == "player_1")
			{
					plane.back = "has_player";
					//plane.gun_back UseBy(self);
					plane usevehicle(self, 4); //TODO CHANGE THIS BACK to 4
					self setup_seat_control("pby_backgun");
			}
			else if(self.play_tag == "player_2")
			{
				plane.right = "has_player";
				//plane.gun_right UseBy(self);
				plane usevehicle(self, 3);
				self setup_seat_control("pby_rightgun");
			}
			else if(self.play_tag == "player_3")
			{
				plane.left = "has_player";
				//plane.gun_left UseBy(self);
				plane usevehicle(self, 2);
				self setup_seat_control("pby_leftgun");
			}
			else if(self.play_tag == "player_4")
			{
				plane.left = "has_player";
				//plane.gun_left UseBy(self);
				plane usevehicle(self, 2);
				self setup_seat_control("pby_leftgun");
			}
			else
			{
				ASSERTEX(false, "The player being forced into a seat doesn't exist");
			}
		break;
		case "rescue": //-- The position that the player's have to be in for the rescue portion of the map
			if(self.play_tag == "player_1")
			{
			}
			else if(self.play_tag == "player_2")
			{
				
			}
			else if(self.play_tag == "player_3")
			{
				
			}
			else if(self.play_tag == "player_4")
			{
				
			}
			else
			{
				ASSERTEX(false, "The player being forced into a seat doesn't exist");
			}
		break;
		default:
		break;
	}
}

//-- Initialize the specific loadouts of the plane for the mission ------------------------------------------------

//-- Builds Custom Player Plane
build_player_planes( type ) //-- There might be more than one type... maybe... or something...
{
	model = undefined;
	death_model = undefined;
	death_fx = "explosions/large_vehicle_explosion";
	death_sound = "explo_metal_rand";
	bombs = false;
	turretType = "default_aircraft_turret";
	turretModel = "weapon_machinegun_tiger";
	func = undefined;
	health = 15;
	min_health = 10;
	max_health = 20;
	team = "axis";

	if( type == "pby" )
	{
		model = "vehicle_usa_pby_exterior";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_usa_pby_exterior";
		health = 10000;
		min_health = 9999;
		max_health = 10001;
		team = "allies";
		
		func = ::pby_plane_init;
	}

	maps\_vehicle::build_template( "stuka", model, type );
	
	maps\_vehicle::build_localinit( func );

	maps\_vehicle::build_deathmodel( model, death_model );

	maps\_vehicle::build_deathfx( death_fx, "tag_engine", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	maps\_vehicle::build_life( health, min_health, max_health );

	maps\_vehicle::build_treadfx();

	maps\_vehicle::build_team( team );
}

pby_plane_init()
{
	//-- empty currently
}
 
//-- Builds Custom Enemy Planes and Boat
//---- more specifically this is where you setup the planes that will break into multiple pieces as they take damage.
//---- this also includes the pt_boat
build_enemy_vehicles( type )
{
	
	model = undefined;
	death_model = undefined;
	death_fx = "explosions/large_vehicle_explosion";
	death_sound = "explo_metal_rand";
	bombs = false;
	turretType = "default_aircraft_turret";
	turretModel = "weapon_machinegun_tiger";
	func = undefined;
	health = 15;
	min_health = 10;
	max_health = 20;
	team = "axis";

	if( type == "zero" )
	{
		model = "vehicle_jap_airplane_zero_d_fuselage";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_airplane_zero_d_fuselage";
		health = 15;
		min_health = 10;
		max_health = 20;
		team = "axis";
		
		func = ::zero_plane_init;
		
		level.vehicle_death_thread[type] = ::zero_death_thread;
	}

	if( type == "zero_old" )
	{
		model = "vehicle_jap_airplane_zero_fly";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_airplane_zero_fly";
		health = 15;
		min_health = 10;
		max_health = 20;
		team = "axis";
		
		func = ::zero_plane_init;
		
		level.vehicle_death_thread[type] = ::zero_death_thread;
	}
	
	if( type == "jap_ptboat" )
	{
		model = "vehicle_jap_ship_ptboat";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_ship_ptboat";
		health = 15;
		min_health = 10;
		max_health = 20;
		team = "axis";
		
		func = ::pt_boat_init;
		
		level.vehicle_death_thread[type] = ::pt_boat_death_thread;
	}

	if( type == "jap_shinyo" )
	{
		model = "vehicle_jap_ship_shinyou";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_ship_shinyou";
		health = 15;
		min_health = 10;
		max_health = 20;
		team = "axis";
		
		func = ::shinyo_boat_init;
		
		level.vehicle_death_thread[type] = ::shinyo_boat_death_thread;
	}	
	
	
	maps\_vehicle::build_template( "stuka", model, type );
	
	maps\_vehicle::build_localinit( func );

	maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this

	if(type != "jap_ptboat" && type != "jap_shinyo")
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	}
	else
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine_left", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	}
	
	maps\_vehicle::build_life( health, min_health, max_health );

	maps\_vehicle::build_treadfx();

	maps\_vehicle::build_team( team );
	
	if(type != "jap_ptboat")
	{
		maps\_vehicle::build_turret( turretType, "tag_gunLeft", turretModel, true );
		maps\_vehicle::build_turret( turretType, "tag_gunRight", turretModel, true );
	}
}

spawn_enemy_plane( type, t_name, ai_type )
{
	model = undefined;
	
	if( type == "zero" )
	{
		model = "vehicle_jap_airplane_zero_d_fuselage";
	}
	
	if( type == "zero_old" )
	{
		model = "vehicle_jap_airplane_zero_fly";
	}
	
	if( !IsDefined( t_name ) )
	{
		t_name = "switch_to_undefined";
	}

	plane_vals = ai_pilot_prethink(ai_type);
	
	if(!plane_vals["is_plane_valid"])
	{
		return undefined;
	}
		
		
	plane = SpawnVehicle( model, t_name, type, plane_vals["org"], plane_vals["ang"] );
	plane.vehicletype = type;
	maps\_vehicle::vehicle_init(plane);
	plane.ai_type = ai_type;
	plane setturningability(0.9);

	if( t_name == "switch_to_undefined" )
	{
		plane.targetname = undefined;
	}

	//-- Setup all of the planes values based on the pre-think
	for(i=0; i < GetArrayKeys(plane_vals).size; i++)
	{
		index = GetArrayKeys(plane_vals)[i];
		plane.pilot_vals[index] = plane_vals[index];
	}
	
	plane thread ai_pilot_think(ai_type);
	
	//compass
	plane AddVehicleToCompass();
	
	return plane;
}

zero_plane_init()
{
	//-- specific inits to the Zero	
	
	//-- Assemble the rest of the planes parts
	self.right_wing = Spawn("script_model", self.origin);
	self.right_wing SetModel("vehicle_jap_airplane_zero_d_wingr");
	self.right_wing LinkTo(self, "tag_attach_wing_RI", (0,0,0), (0,0,0));
	self.right_wing.health = 1000;
	self.right_wing SetCanDamage(true);
	self.right_wing.name_str = "right_wing";
	self.left_wing = Spawn("script_model", self.origin);
	self.left_wing SetModel("vehicle_jap_airplane_zero_d_wingl");
	self.left_wing LinkTo(self, "tag_attach_wing_LE", (0,0,0), (0,0,0));
	self.left_wing.health = 1000;
	self.left_wing SetCanDamage(true);
	self.left_wing.name_str = "left_wing";
	self.tail = Spawn("script_model", self.origin);
	self.tail SetModel("vehicle_jap_airplane_zero_d_tail");
	self.tail LinkTo(self, "tag_attach_tail", (0,0,0), (0,0,0));
	self.tail.health = 1000;
	self.tail SetCanDamage(true);
	self.tail.name_str = "tail";
	
	
/*

	self thread drawTagForever( "tag_attach_wing_RI", ( 0.9, 0.2, 0.2 ) );
	self thread drawTagForever( "tag_attach_wing_LE", ( 0.9, 0.2, 0.2 ) );
	self thread drawTagForever( "tag_attach_tail", ( 0.9, 0.2, 0.2 ) );
	
	self.right_wing thread drawTagForever( "tag_origin", ( 0.2, 0.9, 0.2 ) );
	self.left_wing thread drawTagForever( "tag_origin", ( 0.2, 0.9, 0.2 ) );
	self.tail thread drawTagForever( "tag_origin", ( 0.2, 0.9, 0.2 ) );
	
*/

	wait(0.1); //-- Let the rest of the init function in _vehicle.gsc run before adjusting it
	
	self notify( "stop_friendlyfire_shield" ); //-- Stop the built in friendlyfire_shield()
	self thread zero_damage_thread();
}

zero_damage_thread()
{
	self endon( "death" );
	
	self.healthbuffer = 20000; 
	self.health += self.healthbuffer;
	self.currenthealth = self.health; 
	attacker = undefined; 
	amount = undefined;
	part_of_plane = undefined;
	
	self.right_wing thread zero_piece_damage_thread(self);
	self.left_wing thread zero_piece_damage_thread(self);
	self.tail thread zero_piece_damage_thread(self);
	self thread zero_piece_damage_thread(self);

	while( self.health > 0 )
	{
		self waittill("partial_damage", amount, part_of_plane);
		self.health = self.health - amount;
		
		if( self.health < self.healthbuffer )
			break; 
	}
	
	if(IsDefined(part_of_plane.name_str))
	{
		self.last_damage = part_of_plane.name_str;
	}
	else
	{
		self.last_damage = "fuselage";
	}
	
	self.right_wing notify("death");
	self.left_wing notify("death");
	self.tail_wing notify("death");
	self notify( "death", attacker );
}

zero_piece_damage_thread(fuselage)
{
	self endon("death");
	
	amount = undefined; 
	self.team = "axis";
	while(1)
	{
		self waittill("damage", amount);
		//self.health = self.health - amount;
		
		fuselage notify("partial_damage", amount, self);
	}
}

zero_death_thread()
{
	//-- specific thread for a zero's death	
	//self notify("death");
	//self setspeed(0, 1000, 1000);
	
	//self endon("death");
	
	//TODO: REMOVE THIS
	level notify("zero_killed");
	self RemoveVehicleFromCompass();
	
	crashing_plane = Spawn("script_model", self.origin);
	crashing_plane SetModel("vehicle_jap_airplane_zero_d_fuselage");
	crashing_plane.angles = self.angles;
	
	//-- unlink parts from vehicle
	self hide();
	self.right_wing unlink();
	self.left_wing unlink();
	self.tail unlink();
	//-- relink parts to new script model
	self.right_wing LinkTo(crashing_plane, "tag_attach_wing_RI", (0,0,0), (0,0,0));
	self.left_wing LinkTo(crashing_plane, "tag_attach_wing_LE", (0,0,0), (0,0,0));
	self.tail LinkTo(crashing_plane, "tag_attach_tail", (0,0,0), (0,0,0));
	
	switch(self.last_damage)
	{
		case "right_wing":
			self.right_wing unlink();
			
			crashing_plane MoveGravity(VectorNormalize(AnglesToForward(self.angles - (0, 45, 0))) * self getspeed(), 10);
			self.right_wing MoveGravity(VectorNormalize(AnglesToForward(self.angles + (0, 45, 0))) * (self getspeed() * 0.5), 10);
		break;
		
		case "left_wing":
			self.left_wing unlink();
			
			crashing_plane MoveGravity(VectorNormalize(AnglesToForward(self.angles + (0, 45, 0))) * self getspeed(), 10);
			self.left_wing MoveGravity(VectorNormalize(AnglesToForward(self.angles - (0, 45, 0))) * (self getspeed() * 0.5), 10);
		break;
		
		case "tail":
			self.tail unlink();
			crashing_plane MoveGravity(VectorNormalize(AnglesToForward(self.angles)) * self getspeed(), 10);
		break;
		
		case "fuselage":
			crashing_plane MoveGravity(VectorNormalize(AnglesToForward(self.angles)) * self getspeed(), 10);
		break;
		
		default:
			//ASSERTEX(false, "Plane crashed in a non-handled manner");
		break;
	}
	
	self notify( "crash_done" );
}

pt_boat_init()
{
	self.script_crashtypeoverride = "none"; //-- should keep this from running the airplane crash code
}

pt_boat_death_thread()
{
	//TODO: REMOVE THIS
	iprintlnbold("pt_boat_destroyed");
	
	self notify( "crash_done" );
}

shinyo_boat_init()
{
	self.script_crashtypeoverride = "none"; //-- should keep this from running the airplane crash code
}

shinyo_boat_death_thread()
{
	//iprintlnbold("shinyo_destroyed");
	
	self SetSpeed(0, 5, 5);
	
	self notify("crash_done");
}

ai_pilot_prethink(ai_type)
{
	new_plane_vals = [];
	
	//new_plane_vals["speed_offset"] = the offset of speed faster than the target;
	//new_plane_vals["strafe_start_pos"] = the location that the plane starts in: ("rear", "front", etc);
	//new_plane_vals["strafe_start_val"] = the distance offset from the target plane that the new plane spawns in at;
	//new_plane_vals["strafe_end_pos"] = the position that the plane will end it's strafing run at;
	//new_plane_vals["strafe_end_val"] = the distance offset from the target plane that the plane will stop its strafing run;
	//new_plane_vals["end_strafe_action"] = the action taken when the plane reaches the end of its strafing path: ("death", "loop_around", "start_tailing", etc);
	
	switch(ai_type)
	{
		case "basic_rear":
			
			//-- move 10 faster than the target
			new_plane_vals["speed_offset"] = 10;
			
			//-- start attack 500 units from the rear
			new_plane_vals["strafe_start_pos"] = "rear";
			new_plane_vals["strafe_start_val"] = 500;
			
			//-- end attack 500 units to the front
			new_plane_vals["strafe_end_pos"] = "front";
			new_plane_vals["strafe_end_val"] = 4000;
			
			//-- what to do at the end of a strafing run
			new_plane_vals["end_strafe_action"] = "death";
			
		break;
		
		case "intercept_right":
		case "intercept_left":
			
			new_plane_vals["speed_offset"] = 30;
			
			//-- start attack 500 units from the rear
			if(ai_type == "intercept_right")  new_plane_vals["strafe_start_pos"] = "front_right";
			if(ai_type == "intercept_left")  new_plane_vals["strafe_start_pos"] = "front_left";
			new_plane_vals["strafe_start_val"] = 20000;
			
			//-- end attack 500 units to the front
			if(ai_type == "intercept_right") new_plane_vals["strafe_end_pos"] = "right";
			if(ai_type == "intercept_left") new_plane_vals["strafe_end_pos"] = "left";
			new_plane_vals["strafe_end_val"] = 500;
			
			//-- what to do at the end of a strafing run
			new_plane_vals["end_strafe_action"] = "peel_off";
			
			//-- SPECIFIC TO INTERCEPT FLIGHT
			new_plane_vals["target_offset"] = 200;
			new_plane_vals["max_height_diff"] = 200;
			
		break;
		
		default:
		break;
	}
	
	//-- TODO: MAKE IT SO THIS TARGETS ALL THE PLAYERS, NOT JUST PLAYER 1
	new_plane_vals["target"] = pick_proper_plane(get_players_pby()[0]);
	
	switch(new_plane_vals["strafe_start_pos"])
	{
		case "rear":
			new_plane_vals["org"] = new_plane_vals["target"].origin - ( VectorNormalize(AnglesToForward(new_plane_vals["target"].angles)) * new_plane_vals["strafe_start_val"]);
			new_plane_vals["ang"] = new_plane_vals["target"].angles;
		break;
		
		case "front":
			//-- empty
		break;
		
		case "front_right":
		case "front_left":
			ref_point = new_plane_vals["target"].origin + ( (VectorNormalize(AnglesToForward(new_plane_vals["target"].angles))* (1,0.1,1)) * 500); //-- The 2000 here is completely arbitrary
			ref_ang = (0,0,0);
			
			if(new_plane_vals["strafe_start_pos"] == "front_right") ref_ang = new_plane_vals["target"].angles - (0,RandomIntRange(160, 180),0);
			if(new_plane_vals["strafe_start_pos"] == "front_left") ref_ang = new_plane_vals["target"].angles + (0,RandomIntRange(160, 180),0);
			
			new_plane_vals["org"] = ref_point + (VectorNormalize(AnglesToForward(ref_ang)) * new_plane_vals["strafe_start_val"]) + /*elevation*/ (0, 0, RandomIntRange(-400, 400)) ;
			new_plane_vals["ang"] = VectorNormalize(ref_point - new_plane_vals["org"]);
			new_plane_vals["target_point"] = ref_point;
		break;
		
		default:
			//-- empty
		break;
	}
	
	//-- Check to see if plane is spawned inside the map
	new_plane_vals["is_plane_valid"] = true;
	if(new_plane_vals["org"][0] > 65000 || new_plane_vals["org"][0] < -65000)
	{
		new_plane_vals["is_plane_valid"] = false;
	}
	if(new_plane_vals["org"][1] > 65000 || new_plane_vals["org"][1] < -65000)
	{
		new_plane_vals["is_plane_valid"] = false;
	}
	if(new_plane_vals["org"][2] > 32000 || new_plane_vals["org"][2] < -32000)
	{
		new_plane_vals["is_plane_valid"] = false;
	}
	
	return new_plane_vals;
}

//-- This function is threaded on all the enemy planes that fight the player dynamically.
//-- This is not used on planes that are attached to splines.
//-- TODO: see if i need the keep_flying VAR
ai_pilot_think(ai_type)
{
	self endon("death");
	
	//TODO: temporarily turned off -- Thread the cannons
	//self thread ai_turret_think(ai_type);
	
	target = self.pilot_vals["target"];
		
	keep_flying = true;
	
	switch(ai_type)
	{
		
		case "basic_rear": //CURRENTLY TWEAKING THIS ONE TO USE THE setplanegoalpos() functionality!!
			while(keep_flying)
			{
				target.current_speed = target GetSpeed();
				//self SetSpeed( target.current_speed + self.pilot_vals["speed_offset"] , 1000, 1000);
				target_speed = (target.current_speed * 3600) / 63360; //convert the target speed to mph
		
				self.pilot_vals["destination"] = target.origin + ( VectorNormalize(AnglesToForward(target.angles)) * self.pilot_vals["strafe_end_val"]);
				//self SetVehGoalPos( self.pilot_vals["destination"]);
				self.wanted_angles = VectorNormalize(self.pilot_vals["destination"] - self.origin);
				self setplanegoalpos( self.pilot_vals["destination"], self.wanted_angles, target_speed + self.pilot_vals["speed_offset"] );

				wait(1); // plane adjusts for new player plane position every second
				
				
				/*
				target.current_speed = target GetSpeed();
				self SetSpeed( target.current_speed + self.pilot_vals["speed_offset"] , 1000, 1000);
		
				self.pilot_vals["destination"] = target.origin + ( VectorNormalize(AnglesToForward(target.angles)) * self.pilot_vals["strafe_end_val"]);
				self SetVehGoalPos( self.pilot_vals["destination"]);

				//-- Destination Reached Check
				if(Distance(self.origin, self.pilot_vals["destination"]) < 1000)
				{
					switch(self.pilot_vals["end_strafe_action"])
					{
						case "death":
							//self DoDamage(self.health + 10000, (0,0,0));
							self notify("death", self);
						break;
						default:
						break;
					}
				}
				// else continue what you were doing
				wait(1); // plane adjusts for new player plane position every second
				*/
			}
		break;
		
		
		case "intercept_right":
		case "intercept_left":
			while(keep_flying)
			{
				target.current_speed = target GetSpeedMPH();
				
				self.pilot_vals["target_point"] = self.pilot_vals["target"].origin + ( (VectorNormalize(AnglesToForward(self.pilot_vals["target"].angles))* (1,0.1,1)) * 500); //-- The 200 here is completely arbitrary
				
				//goal_speed = distance from target point / time for target to get to target point;
				goal_speed = 0;
				if(target.current_speed > 0)
				{
					goal_speed = Distance(self.origin, self.pilot_vals["target_point"]) / ( Distance(target.origin, self.pilot_vals["target_point"]) / target.current_speed);
				}
				
				
				if(goal_speed > level.zero_max_speed)
				{
					goal_speed = level.zero_max_speed;
				}
				else if(goal_speed < level.zero_min_speed)
				{
					goal_speed = level.zero_min_speed;
				}
				
				self SetSpeed(goal_speed, 30, 30);
								
				self SetVehGoalPos( self.pilot_vals["target_point"]);
						
				//-- Destination Reached Check
				if(Distance2d(self.origin, self.pilot_vals["target"].origin) < 1500)
				{
					break;
				}		
				
				wait (0.1);
			}
		break;
		
		case "peel_off":
		
			//-- Obtain peel off point
			peel_off_angle = (0,0,0);
			if(self.ai_type == "intercept_right") peel_off_angle = (0, -90, 0);
			if(self.ai_type == "intercept_left") peel_off_angle = (0, 90, 0);
			self.pilot_vals["target_point"] = self.origin + VectorNormalize( AnglesToForward(self.angles) + peel_off_angle ) * 2000;
			
			self SetNearGoalNotifyDist( 300 );
			self SetVehGoalPos( self.pilot_vals["target_point"]);
			self waittill_any( "goal", "near_goal" );
			
			self SetVehGoalPos( self.origin, 1);
			
			self.pilot_vals["end_strafe_action"] = "death";
	
		break;
		
		default:
		break;
	}
	
	if(self.pilot_vals["end_strafe_action"] != "death")
	{
		self thread ai_pilot_think(self.pilot_vals["end_strafe_action"]);
	}
	
}

ai_turret_think(ai_type)
{
	self endon("death");
	
	i = 0;
	
	while(1)
	{
		//magicbullet("mosin_nagant_sniper", self.origin, target.origin)
		turret_origin = self.origin + (AnglesToForward(self.angles) * 300);
		turret_target = self.origin + (AnglesToForward(self.angles) * 5000);
		MagicBullet("type99_lmg", turret_origin, turret_target);
		i++;
		wait(0.1);
		/*
		if(i > 20)
		{
			wait(2);
			i = 0;
		}
		*/
	}
}


//-- Co-op Functions ------------------------------------------------

//-- returns a player array with each player in their initial player position regardless of who has joined/dropped
//-- (or 3rd player is always 3rd player, even if there are only 2 players playing now)
get_players_pby()
{
	if(!IsDefined(level.players))
	{
		level.players = get_players();
		
		for(i=0; i<4; i++)
		{
			if(!IsDefined(level.players[i]))
			{
				level.players[i] = level.undef;
			}
		}
	}
	
	old_players = level.players; //-- the last known version of players[]
	new_players = get_players(); //-- new version of players[]
	
	players = [];
	for(i=0; i<4; i++)
	{
		players[i] = level.undef;
	}
	
	//-- Checks to see if the old players are still playing. Sets any missing players to undefined.
	for(i=0; i<4; i++)
	{
		player_exists = false;
		
		if(IsDefined(old_players[i]))
		{
			if(old_players[i] != level.undef)
			{
				for(j=0; j<new_players.size; j++)
				{
					if(old_players[i] == new_players[j])
					{
						players[i] = old_players[i]; //-- add player to new array
						new_players[j] = level.undef; //-- removed player already dealt with
						player_exists = true;
						break;
					}
				}
			}
			
			if(!player_exists)
			{
				players[i] = level.undef;
			}
		}
		else
		{
			players[i] = level.undef;
		}
	}
	
	//-- Swaps in the new players in the first available open position.
	//found_position = false;
	for(i=0; i<new_players.size; i++)
	{
		if(IsDefined(new_players[i]))
		{
			if(new_players[i] != level.undef)
			{
				for(j=0; j<4; j++)
				{
					if(players[i] == level.undef)
					{
						players[i] = new_players[i];
						break;
					}
				}
			}
		}
	}
	
	//-- Quickly label the players
	for(i=0; i<4; i++)
	{
		if(players[i] != level.undef)
		{
			players[i].play_tag = "player_" + (i+1);
 		}
	}
	
	//-- Return the valid player array
	return players;
}

//-- Displays text if the player tries to switch to an occupied turret.
//-- This text needs to be sent to only the client that tried to switch to
//    an occupied turret.
switching_to_occupied_turret_text()
{
	// "You cannot switch to a turret occupied by another player."
	// TODO: FINISH THIS FUNCTION
	
}

corsair_pby_pacing(plane, my_dist)
{
	self endon("reached_end_node");
	
	level.corsair_pacing_distance = 10;
	self.keep_pacing = true;
	
	current_speed = self GetSpeedMPH();
	plane_speed = plane GetSpeedMPH();
	
	if(IsDefined(my_dist))
	{
		self.pacing_distance = my_dist;	
	}
	else
	{
		self.pacing_distance = level.corsair_pacing_distance;
	}
		
	while(self.keep_pacing)
	{
		dist = VectorDot((plane.origin - self.origin), AnglesToForward(plane.angles));
		
		current_speed = self GetSpeedMPH();
		plane_speed = plane GetSpeedMPH();
		
		if(dist < 0) //plane is ahead of pacing point and needs to slowdown
		{
			if(current_speed > plane_speed)
			{
				current_speed = plane_speed - 3;
			}
			else
			{
				current_speed = current_speed - 1;
			}	
		}
		else if(dist > 0 && dist < self.pacing_distance - (self.pacing_distance * 0.1))
		{
			if(current_speed > plane_speed)
			{
				current_speed = plane_speed - 3;
			}
			else
			{
				current_speed = current_speed - 1;
			}	
		}
		else if(dist > self.pacing_distance + (self.pacing_distance * 0.1)) //assumed that the plane is behind then
		{
			if(current_speed < plane_speed)
			{
				current_speed = plane_speed + 3;
			}
			else
			{
				current_speed = current_speed + 1;
			}
		}
		else
		{
			current_speed = plane_speed;
		}
				
		self SetSpeedImmediate(current_speed, 1, 1);
		wait(0.5);
	}
}

player_one_setup( player )
{
	//-- This matches the OnPlayerConnect setup done for any players that connect after it starts
	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println("Player connected to game.");
		
		//-- init the players plane and a bunch of other stuff
		player.my_plane = pick_proper_plane(player);
		player thread turret_switch_watch();
		player setup_seat_control();
		player set_pilots_suggested_seat("pby_rightgun", "pby_leftgun");
		player thread manage_pilots_suggested_seat();
		player thread move_to_pilots_suggested_seat();
		player DisableTurretDismount();
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println("Player disconnected from the game.");
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");

		// put any calls here that you want to happen when the player gets killed
		println("Player killed at " + self.origin);
		
	}
}	

//----------------------------------------------------------------------------------------------------------
//
//
//
// 																		DEBUG FUNCTIONS
//
//
//
//----------------------------------------------------------------------------------------------------------

//TODO: MAKE THESE JUMPTO FUNCTIONS HANDLE CO-OP...
jumpto_event2()
{
	//-- this is the path that moves onto the main one
	new_starting_node = GetVehicleNode("debug_start_tutorial", "targetname");
	
	
	//-- Start Plane A flying
	level.plane_a AttachPath(new_starting_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
	
	level thread event2();
}

jumpto_event2_strafe_boats()
{
	//-- this is the path that moves onto the main one
	new_starting_node = GetVehicleNode("boat_strafing_node", "targetname");
	
	
	//-- Start Plane A flying
	level.plane_a AttachPath(new_starting_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
	
	level thread event2_strafe_boats();
}

jumpto_event3()
{
	level thread event3();
	
	new_start_node = GetVehicleNode("ev3_jumpto_node", "targetname");
			
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
}

jumpto_event4()
{
	//level waittill("finished final intro screen fadein");
	
	//new_start_node = GetVehicleNode("event4_start_path", "targetname");
	//new_start_node = GetVehicleNode("circling_start_node", "targetname");
	new_start_node = GetVehicleNode("debug_node_rescue", "targetname");
	
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	level.plane_a thread take_off_accel();
	
	level thread event4();
}

jumpto_event5()
{
	
	
}


run_special_debug_functions()
{
	//level thread dbg_training_planes();	
}

dbg_training_planes()
{
	my_trig = GetEnt("debug_training_target", "targetname");
	my_trig waittill("trigger");
	
	wait(1);
	
	plane0 = GetEnt("training_plane_0", "targetname");
	plane1 = GetEnt("training_plane_1", "targetname");
	plane2 = GetEnt("training_plane_2", "targetname");
	
	plane0 thread dbg_plane_taking_damage();
	plane1 thread dbg_plane_taking_damage();
	plane2 thread dbg_plane_taking_damage();
}

dbg_plane_taking_damage()
{
	i = 0;
	
	while(1)
	{
		self waittill("damage", amount);
	
		level.dbg_text_plane_dmg = newHudElem();
		level.dbg_text_plane_dmg.alignX = "center";
		level.dbg_text_plane_dmg.x = 200;
		level.dbg_text_plane_dmg.y = 300;
	
		//level.dbg_text_plane_dmg SetText(self.targetname + " took " + amount + " damage " + i + " times.");
		//iprintlnbold(self.targetname + " took " + amount + " damage " + i + " times.");
		iprintlnbold(self.targetname + " has " + self.health + " remaining ");
	}
}

event2_strafe_boats()
{
	//-- setup objective
	set_objective("merchant_boats");
	
	
	/*
		Boats available:  ev2_ship_00, ev2_ship_01, ev2_ship_02, ev2_ship_03, ev2_ship_04, ev2_ship_05
	*/
	
	level.boats = [];
	level.boats = GetEntArray("ev2_ship", "targetname");
	
	for(i = 0; i < level.boats.size; i++)
	{
		level.boats[i] SetCanDamage(true);
		level.boats[i].scriptname = "boat_" + i;
		
		level.boats[i] thread track_damage_and_sink();
	}
	
	
	level.plane_a waittill("start_event_3");
	
	set_objective("back_to_base");
	//level.plane_a waittill("reached_end_node");
	level thread event3();
}

track_damage_and_sink()
{
	/*  AROUND 40,000 DAMAGE  for 3 Passes with pretty even distribution of fire*/
	
	boat_alive = true;
	total_damage = 0;
	
	while(boat_alive)
	{
		self waittill("damage", amt);
		
		total_damage = (total_damage + amt);
		iprintlnbold(self.scriptname + " taken " + total_damage + " damage.");
		
		if(total_damage > 40000)
		{
			boat_alive = false;
		}
	}
	
	self Delete();
}

//-- OBJECTIVES
set_objective(my_obj, ent)
{
	// Scout The Ocean
	if(my_obj == "scout_ocean")
	{
		obj_marker = GetEnt("obj_ev1", "targetname");
		objective_add(1, "active", &"PBY_FLY_OBJ_EV1", obj_marker.origin );
		objective_current( 1 );
	}
	// Sink the Boats
	else if (my_obj == "merchant_boats")
	{
		objective_state (1, "done");
		objective_add( 2, "active", &"PBY_FLY_OBJ_EV2", ( 42399, 1718, 531 ) );
		objective_current( 2 );
	}
	//Setup the other objectives .. in the proper order and everything
	else if (my_obj == "back_to_base")
	{
		objective_state (2, "done");
		obj_marker = GetEnt("base_obj", "targetname");
		objective_add( 3, "active", &"PBY_FLY_OBJ_EV3", obj_marker.origin );
		objective_current( 3 );
	}
	else if(my_obj == "respond_to_distress_call")
	{
		objective_state (3, "done");
		obj_marker = GetEnt("fleet_obj", "targetname");
		objective_add( 4, "active", &"PBY_FLY_OBJ_EV3B", obj_marker.origin );
		objective_current( 4 );
	}
}

//introscreen test
pby_custom_introscreen(string1, string2, string3, string4)
{
	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true; 
	level.introblack SetShader( "black", 640, 480 ); 

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	//freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.05 ); 
 
	level.introstring = []; 
	
	//Title of level
	
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1 ); 
	}
	
	wait( 2 );
	
	//City, Country, Date
	
	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2 ); 
	}

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3 ); 
	}
	
	//Optional Detailed Statement
	
	if( IsDefined( string4 ) )
	{
		wait( 2 ); 
	}
	
	if( IsDefined( string4 ) )
	{
		maps\_introscreen::introscreen_create_line( string4 ); 
	}
	
	level notify( "finished final intro screen fadein" ); 
	
	wait( 3 ); 

	// Fade out black
	level.introblack FadeOverTime( 1.5 ); 
	level.introblack.alpha = 0; 

	flag_set( "starting final intro screen fadeout" );
	
	// Restore player controls part way through the fade in
	//freezecontrols_all( false ); 

	level._introscreen = false;

	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}