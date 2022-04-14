// hol3 ambient script file

#include maps\_utility;
#include maps\_ambientpackage;
main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Hol3_Outdoors
	//*************** 

		declareAmbientPackage( "hol3_outdoors_pkg" );
			
			addAmbientElement( "hol3_outdoors_pkg", "snow_flakes", .1, .2, 100, 500);
			addAmbientElement( "hol3_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//Hol3_Building_Interrior
	//*************** 

		declareAmbientPackage( "hol3_stone_room_pkg" );
		
			addAmbientElement( "hol3_stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "hol3_stone_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol3_stone_room_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "hol3_wood_room_pkg" );
	
			addAmbientElement( "hol3_wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			addAmbientElement( "hol3_wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			addAmbientElement( "hol3_wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "hol3_wood_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "hol3_wood_room_pkg", "bomb_medium", 15, 30, 100, 500 );

	//***************
	//Hol3_Asylum
	//*************** 
		
		declareAmbientPackage( "ber1_asylum_pkg" );
		
			addAmbientElement( "ber1_asylum_pkg", "amb_rodents", 5, 35, 100, 500 );
				
	//***************
	//Hol3_Tunnel
	//*************** 
	
		declareAmbientPackage( "hol3_tunnel_pkg" );
		
			addAmbientElement( "hol3_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Hol3_Outdoors
	//*************** 

		declareAmbientRoom( "hol3_outdoors_room" );
	
			setAmbientRoomTone( "hol3_outdoors_room", "outdoor_wind" );
			
	//***************
	//Hol3_Building_Interrior
	//*************** 

		declareAmbientRoom( "hol3_closed_room" );
	
			setAmbientRoomTone( "hol3_closed_room", "closed_room_wind" );
	
		declareAmbientRoom( "hol3_partial_room" );
	
			setAmbientRoomTone( "hol3_partial_room", "heater_room" );
	
			
	//***************
	//Hol3_Asylum
	//***************

		declareAmbientRoom( "hol3_asylum" );
	
			setAmbientRoomTone( "hol3_asylum", "asylum_wind" );
			
	//***************
	//Hol3_Tunnel
	//***************

		declareAmbientRoom( "hol3_tunnel" );
	
			setAmbientRoomTone( "hol3_tunnel", "train_station_wind" );
	

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
	wait (1);
		activateAmbientPackage( "hol3_outdoors_pkg", 0 );
		activateAmbientRoom( "hol3_outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************

		//Start_Intro_Music();
}

	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

//Start_Intro_Music()
//{
//	musicplay("MX_Intro", 0);	
//}

//********************************************************************************************************
