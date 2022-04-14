#include maps\_utility;
#include maps\_ambientpackage;
main()
{
	
	//Set up Ambient Rooms and Packages

//************************************************************************************************
//				Ambient Packages
//************************************************************************************************

//***************
//_generic
//***************
	package = "_generic";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );	
	
//***************
//_paddedcell
//***************
	package = "_paddedcell";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_room
//***************
	package = "_room";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_bathroom
//***************
	package = "_bathroom";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_livingroom
//***************
	package = "_livingroom";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_stoneroom
//***************
	package = "_stoneroom";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_auditorium
//***************
	package = "_auditorium";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150);

//***************
//_concerthall
//***************
	package = "_concerthall";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_cave
//***************
	package = "_cave";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_arena
//***************
	package = "_arena";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150);
		

//***************
//_hangar
//***************
	package = "_hangar";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_carpetedhallway
//***************
	package = "_carpetedhallway";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150);
		

//***************
//_hallway
//***************
	package = "_hallway";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_stonecorridor
//***************
	package = "_stonecorridor";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_alley
//***************
	package = "_alley";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_forest
//***************
	package = "_forest";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_city
//***************
	package = "_city";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_mountains
//***************
	package = "_mountains";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_quarry
//***************
	package = "_quarry";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_plain
//***************
	package = "_plain";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_parkinglot
//***************
	package = "_parkinglot";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_sewerpipe
//***************
	package = "_sewerpipe";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_underwater
//***************
	package = "_underwater";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );

//***************
//_drugged
//***************
	package = "_drugged";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
	
//***************
//_dizzy
//***************
	package = "_dizzy";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_psychotic
//***************
	package = "_psychotic";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//***************
//_psychotic
//***************
	package = "none";
	declareAmbientPackage( package );
		addAmbientElement( package, "pa_fire", 10, 20, 10, 150 );
		addAmbientElement( package, "amb_bugs_cicada", 4, 8, 10, 150 );
		addAmbientElement( package, "amb_flies", 8, 10, 10, 150 );
		addAmbientElement( package, "amb_odd_bug", 4, 8, 10, 150 );
		
		
//***************
//_interior
//***************
	package = "interior";
	declareAmbientPackage( package );		
		addAmbientElement( package, "amb_water_drips", 1, 2, 10, 150 );
		addAmbientElement( package, "bomb_medium", 8, 22, 10, 150 );
		addAmbientElement( package, "bomb_far", 2, 18, 10, 150 );
		addAmbientElement( package, "ship_creak", 1, 2, 10, 150 );
		addAmbientElement( package, "amb_dist_voices", 4, 8, 10, 150 );
		
//************************************************************************************************
//				ROOMS
//************************************************************************************************



//***************
//_generic 
//***************
	room = "_generic";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "generic" );
		setAmbientRoomReverb( room, "generic", 1, 0.5 );
		
//***************
//_paddedcell 
//***************
	room = "_paddedcell";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "paddedcell" );
		setAmbientRoomReverb( room, "paddedcell", 1, 0.5 );
		
//***************
//_room 
//***************
	room = "_room";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "room" );
		setAmbientRoomReverb( room, "room", 1, 0.5 );
		
//***************
//_bathroom 
//***************
	room = "_bathroom";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "bathroom" );
		setAmbientRoomReverb( room, "bathroom", 1, 0.5 );

//***************
//_livingroom 
//***************
	room = "_livingroom";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "livingroom" );
		setAmbientRoomReverb( room, "livingroom", 1, 0.5 );
	
//***************
//_stoneroom 
//***************
	room = "_stoneroom";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "stoneroom" );
		setAmbientRoomReverb( room, "stoneroom", 1, 0.5 );

//***************
//_auditorium 
//***************
	room = "_auditorium";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "auditorium" );
		setAmbientRoomReverb( room, "auditorium", 1, 0.5 );

//***************
//_concerthall 
//***************
	room = "_concerthall";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "concerthall" );
		setAmbientRoomReverb( room, "concerthall", 1, 0.5 );
	
//***************
//_cave 
//***************
	room = "_cave";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "cave" );
		setAmbientRoomReverb( room, "cave", 1, 0.5 );	
		
//***************
//_arena 
//***************
	room = "_arena";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "arena" );
		setAmbientRoomReverb( room, "arena", 1, 0.5 );
		
//***************
//_hangar 
//***************
	room = "_hangar";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "hangar" );
		setAmbientRoomReverb( room, "hangar", 1, 0.5 );
		
//***************
//_carpetedhallway 
//***************
	room = "_carpetedhallway";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "carpetedhallway" );
		setAmbientRoomReverb( room, "carpetedhallway", 1, 0.5 );
		
//***************
//_hallway 
//***************
	room = "_hallway";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "hallway" );
		setAmbientRoomReverb( room, "hallway", 1, 0.5 );
		
//***************
//_stonecorridor 
//***************
	room = "_stonecorridor";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "stonecorridor" );
		setAmbientRoomReverb( room, "stonecorridor", 1, 0.5 );
		
//***************
//_alley 
//***************
	room = "_alley";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "alley" );
		setAmbientRoomReverb( room, "alley", 1, 0.5 );
		
//***************
//_forest 
//***************
	room = "_forest";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "forest" );
		setAmbientRoomReverb( room, "forest", 1, 0.5 );
		
//***************
//_city 
//***************
	room = "_city";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "city" );
		setAmbientRoomReverb( room, "city", 1, 0.5 );

//***************
//_mountains 
//***************
	room = "_mountains";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "mountains" );
		setAmbientRoomReverb( room, "mountains", 1, 0.5 );
		
//***************
//_quarry 
//***************
	room = "_quarry";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "quarry" );
		setAmbientRoomReverb( room, "quarry", 1, 0.5 );	

//***************
//_plain 
//***************
	room = "_plain";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "plain" );
		setAmbientRoomReverb( room, "plain", 1, 0.5 );		
		
//***************
//_parkinglot 
//***************
	room = "_parkinglot";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "parkinglot" );
		setAmbientRoomReverb( room, "parkinglot", 1, 0.5 );			
		
//***************
//_sewerpipe 
//***************
	room = "_sewerpipe";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "sewerpipe" );
		setAmbientRoomReverb( room, "sewerpipe", 1, 0.5 );		
		
//***************
//_underwater 
//***************
	room = "_underwater";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "underwater" );
		setAmbientRoomReverb( room, "underwater", 1, 0.5 );			
		
//***************
//_drugged 
//***************
	room = "_drugged";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "drugged" );
		setAmbientRoomReverb( room, "drugged", 1, 0.5 );	

//***************
//_dizzy 
//***************
	room = "_dizzy";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "dizzy" );
		setAmbientRoomReverb( room, "dizzy", 1, 0.5 );		

//***************
//_psychotic 
//***************
	room = "_psychotic";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "psychotic" );
		setAmbientRoomReverb( room, "psychotic", 1, 0.5 );		
//***************
//none
//***************
	room = "none";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "none" );
		setAmbientRoomReverb( room, "plain", 1, 0.5 );
//***************
//INTERIOR
//***************
	room = "interior";
	declareAmbientRoom(room );
		setAmbientRoomTone( room, "none" );
		setAmbientRoomReverb( room, "sewerpipe", 1, 1 );
	
//************************************************************************************************
//				ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************
	activateAmbientPackage( "none", 0 );
	activateAmbientRoom( "none", 0 );


//*************************************************************************************************
//				   START SCRIPTS
//*************************************************************************************************
	level thread start_noise_test();
	
}

//************************************************************************************************
//			 	OTHER AUDIO FUNCTIONS
//************************************************************************************************
start_noise_test()
{
	level waittill ("yo_bitch_play_stuff");	
	level thread noisytime();	

}
noisytime()
{
	left_front_l = getent("left_front", "targetname");	
	right_front_l = getent("right_front", "targetname");
	center_l = getent("center", "targetname");
	left_surround_l = getent("left_surround", "targetname");
	right_surround_l = getent("right_surround", "targetname");
	
	level endon("reset");
	
	while(1)
	{ 
	
	
		left_front_l playsound("noise_test", "targetname");
		wait(2);
		center_l playsound("noise_test", "targetname");
		wait(2);
		right_front_l playsound("noise_test", "targetname");
		wait(2);
		right_surround_l playsound("noise_test", "targetname");
		wait(2);
		left_surround_l playsound("noise_test", "targetname");
		wait(2);
		
		/*
		playsoundatposition("noise_test", left_front_l.origin);		
		wait (2);		
		playsoundatposition("noise_test", center_l.origin);
		wait (2);
		playsoundatposition("noise_test", right_front_l.origin);
		wait (2);
		playsoundatposition("noise_test", right_surround_l.origin);
		wait (2);
		playsoundatposition("noise_test", left_surround_l.origin);
		wait(2);
		*/
	}

}