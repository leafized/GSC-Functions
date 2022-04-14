// Ambients Level File
#include maps\_utility;
#include maps\_ambientpackage;

main()
{
	// fog effects - need intense tweaking
	level.fog_r = 0.375;
	level.fog_g = 0.408;
	level.fog_b = 0.389;
	
	// normal fog. Close to player
	level.fog_normal_near = 0;
	level.fog_normal_mid = 800;
	level.fog_normal_height_mid = 600;
	level.fog_normal_height_ground = 0;	

	level.fog_transition = 2;

	// culling
	level.cull_distance = 5000;

	set_fog_culling( level.fog_normal_near, level.fog_normal_mid, level.fog_normal_height_ground, level.cull_distance );




	// more points of adjustments to come
	
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Hol1_Outdoors
	//*************** 

		declareAmbientPackage( "hol1_outdoors_pkg" );
			
			addAmbientElement( "hol1_outdoors_pkg", "snow_flakes", .1, .2, 100, 500);
			addAmbientElement( "hol1_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );
	//***************
	//Hol1_Outdoors
	//*************** 

		declareAmbientPackage( "hol1_outdoors_pkg" );
			
			addAmbientElement( "hol1_outdoors_pkg", "snow_flakes", .1, .2, 100, 500);
			addAmbientElement( "hol1_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//Hol1_Building_Interrior
	//*************** 

		declareAmbientPackage( "hol1_stone_room_pkg" );
		
			addAmbientElement( "hol1_stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "hol1_stone_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol1_stone_room_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "hol1_wood_room_pkg" );
	
			addAmbientElement( "hol1_wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			addAmbientElement( "hol1_wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			addAmbientElement( "hol1_wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "hol1_wood_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol1_wood_room_pkg", "bomb_medium", 15, 30, 100, 500 );

	//***************
	//Hol1_Asylum
	//*************** 
		
		declareAmbientPackage( "ber1_asylum_pkg" );
		
			addAmbientElement( "ber1_asylum_pkg", "amb_rodents", 5, 35, 100, 500 );
				
	//***************
	//Hol1_Tunnel
	//*************** 
	
		declareAmbientPackage( "hol1_tunnel_pkg" );
		
			addAmbientElement( "hol1_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Hol1_Outdoors
	//*************** 

		declareAmbientRoom( "hol1_outdoors_room" );
	
			setAmbientRoomTone( "hol1_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "hol1_outdoors_room", "paddedcell",  0.8, 1 );
	//***************
	//Hol1_Outdoors
	//*************** 

		declareAmbientRoom( "hol1_outdoors_windy" );
	
			setAmbientRoomTone( "hol1_outdoors_windy", "outdoor_windy" );
			setAmbientRoomReverb( "hol1_outdoors_windy", "paddedcell",  0.8, 1 );
			
	//***************
	//Hol1_Building_Interrior
	//*************** 

		declareAmbientRoom( "hol1_closed_room" );	
			setAmbientRoomTone( "hol1_closed_room", "closed_room_wind" );
	
		declareAmbientRoom( "hol1_partial_room" );	
			setAmbientRoomTone( "hol1_partial_room", "heater_room" );
	
			
	//***************
	//Hol1_Asylum
	//***************

		declareAmbientRoom( "ber1_asylum" );	
			setAmbientRoomTone( "ber1_asylum", "asylum_wind" );
			
	//***************
	//Hol1_Tunnel
	//***************

		declareAmbientRoom( "hol1_tunnel" );
	
			setAmbientRoomTone( "hol1_tunnel", "train_station_wind" );
	

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
	wait (1);
		activateAmbientPackage( "hol1_outdoors_pkg", 0 );
		activateAmbientRoom( "hol1_outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************
//pull
		//Start_Intro_Music();
		level thread start_jeep_hack();
		level thread play_siren();
}

	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

//Start_Intro_Music()
//{
//	musicplay("MX_Intro", 0);	
//}

//********************************************************************************************************


start_jeep_hack()
{

//audio_additional
	engine_on = getent  ("audio_engine_origin","targetname");
	idle = getent("audio_idle_origin", "targetname");
	engine_off = getent("audio_stopengine", "targetname");
	level endon("player_outta_car");
	while(1)
	{
		level waittill ("audio_engine_on");
		engine_off playsound ("start_hack");
		engine_on playloopsound("jeep_engine_low_hack");
		idle stoploopsound();
		level waittill ("audio_engine_off");
		engine_off playsound ("stop_hack");
		engine_on stoploopsound();
		idle playloopsound("jeep_idle_low_hack");
		
	
	}

}
play_siren()
{

	klaxxon_close = getent ("audio_klaxxon_origin_a","targetname");
	pa = getent ("audio_klaxxon_origin_b", "targetname");
	level waittill("sound_alarm");
	klaxxon_close playloopsound("klaxxon_close");
	pa playsound("german_pa");
	

}
event1()
{
	level endon( "event1_ends" );
	

}

event2()
{
	level endon( "event2_ends" );

}


set_fog_culling( near, mid, base, cull_dist )
{
	level.fog_normal_near = near;
	level.fog_normal_mid = mid;
	level.fog_normal_height_ground = base;
	level.cull_distance = cull_dist;

	setVolFog( near, mid, level.fog_normal_height_mid, base, level.fog_r, level.fog_g, level.fog_b, level.fog_transition );  
	setculldist( cull_dist );
}
