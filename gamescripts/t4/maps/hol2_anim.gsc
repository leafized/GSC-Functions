#include maps\_utility;

#using_animtree ("generic_human");
main()
{
	


			// event 1 anims
	level.scr_anim["ev1_campfireguy"]["warmup_0"][0]								= %ch_aroundfire_node_guy_a;
	level.scr_anim["ev1_campfireguy"]["warmup_1"][0]								= %ch_aroundfire_node_guy_d;
	level.scr_anim["ev1_campfireguy"]["warmup_1_alerted"]						= %ch_aroundfire_node_guy_d_alert;
	level.scr_anim["ev1_campfireguy"]["warmup_2"][0]								= %ch_aroundfire_node_guy_b;
	//level.scr_anim["ev1_campfireguy"]["warmup_3"][0]								= %ch_aroundfire_guy_c;
	
	level.scr_anim["road_walkers"]["weary_walk1"]										= %Ai_walk_weary_a;
	level.scr_anim["road_walkers"]["weary_walk2"]										= %Ai_walk_weary_b;
	level.scr_anim["road_walkers"]["weary_walk3"]										= %Ai_walk_weary_c;
	level.scr_anim["road_walkers"]["weary_walk4"]										= %Ai_walk_weary_d;
	
	
	
	
	
	level.scr_anim["sneaky_squad"]["sneaky_walk1"]						= %ai_sneaking_a_walk;
	level.scr_anim["sneaky_squad"]["sneaky_twitch1"]					= %ai_sneaking_a_walk_twitch;
	level.scr_anim["sneaky_squad"]["sneaky_stopright"]				= %ai_sneaking_a_stop_right;
	level.scr_anim["sneaky_squad"]["sneaky_stopleft"]					= %ai_sneaking_a_stop_left;
	level.scr_anim["sneaky_squad"]["sneaky_stopcenter"]				= %ai_sneaking_a_stop_center;
	level.scr_anim["sneaky_squad"]["sneaky_startright"]				= %ai_sneaking_a_start_right;
	level.scr_anim["sneaky_squad"]["sneaky_startleft"]				= %ai_sneaking_a_start_left;
	level.scr_anim["sneaky_squad"]["sneaky_startcenter"]			= %ai_sneaking_a_start_center;
	level.scr_anim["sneaky_squad"]["sneaky_idle_center"]			= %ai_sneaking_a_idle_center;
	level.scr_anim["sneaky_squad"]["sneaky_idle_left"]				= %ai_sneaking_a_idle_left;
	level.scr_anim["sneaky_squad"]["sneaky_idle_right"]				= %ai_sneaking_a_idle_right;

	

	level.scr_anim["sneaky_squad"]["sarge_knife"]									= %ch_holland2_slit_sarge;
	level.scr_anim["eng_knifed"]["sarge_knife"]											= %ch_holland2_slit_german;
	level.scr_anim["sneaky_squad"]["sarge_sneak"]						= %ch_holland2_slit_sarge_sneaking;
	level.scr_anim["sneaky_squad"]["sarge_kill"]							= %ch_holland2_slit_sarge_death;
	level.scr_anim["eng_knifed"]["eng_loop"][0]								= %ch_holland2_slit_german_arming;
	level.scr_anim["eng_knifed"]["eng_death"]									= %ch_holland2_slit_german_death;

	
	
	// event 2 anims
		

	level.scr_anim[ "bridge3_engineer1" ][ "b3_engineers_walk" ]			= %ch_holland2_bridge_engineer_guy1_walk;
	level.scr_anim[ "bridge3_engineer2" ][ "b3_engineers_walk" ]			= %ch_holland2_bridge_engineer_guy2_walk;
	level.scr_anim[ "bridge3_engineer1" ][ "b3_engineers_jumpdown" ]	= %ch_holland2_bridge_engineer_guy1_unload;
	level.scr_anim[ "bridge3_engineer2" ][ "b3_engineers_jumpdown" ]	= %ch_holland2_bridge_engineer_guy2_unload;
	
	level.scr_anim[ "bridge3_commander" ][ "comander_walk" ]					= %ch_holland2_bridge_commander_walk;
	level.scr_anim[ "bridge3_commander" ][ "commander_transition" ]		= %ch_holland2_bridge_commander_trans;
	level.scr_anim[ "bridge3_commander" ][ "commander_loop" ][0]			= %ch_holland2_bridge_commander_loop;
	level.scr_anim[ "bridge3_commander" ][ "commander_alarm" ]				= %ch_holland2_bridge_commander_alarm;

	level.scr_anim[ "bridge3_engineer1" ][ "arm_dynamite" ][0]				= %ch_holland2_dynamite_disarming;
	level.scr_anim[ "bridge3_engineer2" ][ "arm_dynamite" ][0]				= %ch_holland2_dynamite_disarming;
	
	level.scr_anim[ "trip_wire_guys1" ][ "dive" ]		= %exposed_dive_grenade_b;
	level.scr_anim[ "trip_wire_guys2" ][ "dive" ]		= %exposed_dive_grenade_f;
	level.scr_anim[ "trip_wire_guys3" ][ "dive" ]		= %exposed_dive_grenade_b;
	
	level.scr_anim[ "trip_wire_guys1" ][ "trav" ]		= %ch_holland2_wire_a_traverse;
	level.scr_anim[ "trip_wire_guys2" ][ "trav" ]		= %ch_holland2_wire_b1_traverse;
	level.scr_anim[ "trip_wire_guys3" ][ "trav" ]		= %ch_holland2_wire_b2_traverse;
	
	level.scr_anim[ "trip_wire_guys1" ][ "walk" ]		= %ai_sneaking_a_walk;
	level.scr_anim[ "trip_wire_guys2" ][ "walk" ]		= %ch_holland2_wire_b1_walk;
	level.scr_anim[ "trip_wire_guys3" ][ "walk" ]		= %ch_holland2_wire_b2_walk;
	

	
	// event 3 anims

	level.scr_anim[ "truck_vin_fuel" ][ "refueling" ]		= %ch_holland2_truck_sequence_refueling;
	//level.scr_sound[ "truck_vin_fuel" ][ "refueling" ]		= "Print: Do stuff";	
	
	level.scr_anim[ "truck_vin_fuel" ][ "transition" ]	= %ch_holland2_truck_sequence_trans;
	level.scr_anim[ "truck_vin_fuel" ][ "talk_loop" ][0]		= %ch_holland2_truck_sequence_talk_1;

	level.scr_anim[ "truck_vin_back" ][ "backdoor" ]			= %ch_holland2_truck_sequence_door;
	level.scr_anim[ "truck_vin_back" ][ "talk_loop2" ][0]		= %ch_holland2_truck_sequence_talk_2;
	
	level.scr_anim[ "ent_smoker_1" ][ "smoke_it" ][0]			= %ch_holland2_smoking_guy1;
	level.scr_anim[ "ent_smoker_2" ][ "smoke_it" ][0]		= %ch_holland2_smoking_guy2;
	


	level.scr_anim[ "hq_breach_maddock" ][ "hq_breach_and_satchel" ]		= %ch_holland2_shutters_guy1;
	level.scr_anim[ "hq_breach_newhero" ][ "hq_breach_and_satchel" ]		= %ch_holland2_shutters_guy2;
	
	
	
	
	//event 4 anims


	level.scr_anim["door_kick_guy"]["door_kick"]                = %ch_holland2_stealth_door;
	
	level.scr_anim["stunned_guys"]["crawl1"][0] 					 = %dying_crawl;
	
	level.scr_anim["dynamite_failsafe_guy"]["push_and_blow"]                = %door_kick_in;

	//TW - added to fix script assert
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;

	falling_tower_anims();
	falling_tree_anims();
}


#using_animtree( "hol2_scripted_anims" );
falling_tower_anims()
{
	PrecacheModel( "anim_holland_church" );

	level.scr_animtree["churchtower_fall"] = #animtree;	

	level.scr_model["churchtower_fall"] = "anim_holland_church";
	level.scr_anim["churchtower_fall"]["tower_falling"] = %o_holland2_church;
}



#using_animtree( "hol2_scripted_anims" );
falling_tree_anims()
{
	PrecacheModel( "anim_foliage_cod5_tree_pine_02_s_snow" );

	level.scr_animtree["tree_fall"] = #animtree;	

	level.scr_model["tree_fall"] = "anim_foliage_cod5_tree_pine_02_s_snow";
	level.scr_anim["tree_fall"]["tree_falling"] = %o_holland2_tree_fall;
}
