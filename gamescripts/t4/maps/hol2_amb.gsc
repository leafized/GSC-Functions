#include maps\_utility;
#include maps\_ambientpackage;


main()
{
	level.fogclear = 0;

	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Hol2_Outdoors
	//*************** 

		declareAmbientPackage( "hol2_outdoors_pkg" );
			
			addAmbientElement( "hol2_outdoors_pkg", "snow_flakes", .1, .2, 10, 1000);
			addAmbientElement( "hol2_outdoors_pkg", "snow_flakes", .1, .2, 50, 200);

			addAmbientElement( "hol2_outdoors_pkg", "bomb_far", 15, 25, 10, 200 );
			addAmbientElement( "hol2_outdoors_pkg", "wolves", 15, 35, 500, 1500 );
			addAmbientElement( "hol2_outdoors_pkg", "choradyl", 25, 45, 500, 1200 );
			addAmbientElement( "hol2_outdoors_pkg", "owl", 20, 60, 100, 800 );
			addAmbientElement( "hol2_outdoors_pkg", "tawny", 30, 40, 500, 1200 );
			addAmbientElement( "hol2_outdoors_pkg", "bomb_far", 10, 20,1000, 10500);	
			addAmbientElement( "hol2_outdoors_pkg", "amb_distant_arty", 20, 30,8000, 12000);
	//***************
	//Hol2_Building_Interrior
	//*************** 

		declareAmbientPackage( "hol2_stone_room_pkg" );
		
			addAmbientElement( "hol2_stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "hol2_stone_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol2_stone_room_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "hol2_wood_room_pkg" );
	
			addAmbientElement( "hol2_wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			addAmbientElement( "hol2_wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			addAmbientElement( "hol2_wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "hol2_wood_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol2_wood_room_pkg", "bomb_medium", 15, 30, 100, 500 );

	//***************
	//Hol2_Asylum
	//*************** 
		
		declareAmbientPackage( "ber1_asylum_pkg" );
		
			addAmbientElement( "ber1_asylum_pkg", "amb_rodents", 5, 35, 100, 500 );
				
	//***************
	//Hol2_Tunnel
	//*************** 
	
		declareAmbientPackage( "hol2_tunnel_pkg" );
		
			addAmbientElement( "hol2_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Hol2_Outdoors
	//*************** 

		declareAmbientRoom( "hol2_outdoors_room" );
	
			setAmbientRoomTone( "hol2_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "hol2_outdoors_room", "paddedcell", 0.75, 1 );
			
	//***************
	//Hol2_Building_Interrior
	//*************** 

		declareAmbientRoom( "hol2_closed_room" );
	
			setAmbientRoomTone( "hol2_closed_room", "closed_room_wind" );
	
		declareAmbientRoom( "hol2_partial_room" );
	
			setAmbientRoomTone( "hol2_partial_room", "heater_room" );
	
			
	//***************
	//Hol2_Asylum
	//***************

		declareAmbientRoom( "ber1_asylum" );
	
			setAmbientRoomTone( "ber1_asylum", "asylum_wind" );
			
	//***************
	//Hol2_Tunnel
	//***************

		declareAmbientRoom( "hol2_tunnel" );
	
			setAmbientRoomTone( "hol2_tunnel", "train_station_wind" );
	

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
	wait (1);
		activateAmbientPackage( "hol2_outdoors_pkg", 0 );
		activateAmbientRoom( "hol2_outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************

		//Start_Intro_Music();
		start_vehicle_sounds();
}
	
	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

//Start_Intro_Music()
//{
//	musicplay("MX_Intro", 0);	
//}

//********************************************************************************************************

	
start_vehicle_sounds()
{
	level waittill("trucks_go");
	
	truck1 = getent("initial_convoy_truck1", "targetname");
	truck2 = getent("initial_convoy_truck2", "targetname");
	truck3 = getent("initial_convoy_truck3", "targetname");
	
	truck1 playsound ("kubel_truck_hack");
	wait(0.5);
	//truck2 playsound ("kubel_truck_hack");
	wait (0.35);
	truck3 playsound ("kubel_truck_hack_alt");
}