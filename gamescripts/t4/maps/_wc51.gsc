// _wc51.gsc
// Sets up the behavior for the wc51

#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	build_template( "wc51", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_usa_wheeled_wc51", "vehicle_usa_wheeled_wc51" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_deathquake( 0.6, 1.0, 400 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );


// SCRIPTER_MOD: JesseS (5/12/2007) - Took out lights
// TODO: Re-add sick lights!
	//build_light( model, "headlight_truck_left", 		"tag_headlight_left", 		"misc/car_headlight_truck_L", 		"headlights" );
	//build_light( model, "headlight_truck_right", 		"tag_headlight_right", 		"misc/car_headlight_truck_R", 		"headlights" );
	//build_light( model, "parkinglight_truck_left_f",	"tag_parkinglight_left_f", 	"misc/car_parkinglight_truck_LF", 	"headlights" );
	//build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_truck_RF",	"headlights" );
	//build_light( model, "taillight_truck_right",	 	"tag_taillight_right", 		"misc/car_taillight_truck_R", 		"headlights" );
	//build_light( model, "taillight_truck_left",		 	"tag_taillight_left", 		"misc/car_taillight_truck_L", 		"headlights" );

	//build_light( model, "brakelight_truck_right", 		"tag_taillight_right", 		"misc/car_brakelight_truck_R", 		"brakelights" );
	//build_light( model, "brakelight_truck_left", 		"tag_taillight_left", 		"misc/car_brakelight_truck_L", 		"brakelights" );


}

// Anthing specific to this vehicle, used globally.
init_local()
{
	
}

// Animtion set up for vehicle anims
#using_animtree ("tank");
set_vehicle_anims(positions)
{
	return positions;
}


// Animation set up for AI on the jeep
// guzzo 11/12/07 - THESE ARE PLACEHOLDER ANIMS

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i=0;i<6;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";
	positions[2].sittag = "tag_passenger2";
	positions[3].sittag = "tag_passenger3";
	positions[4].sittag = "tag_passenger4";
	positions[5].sittag = "tag_passenger5";
	
	positions[0].idle = %crew_jeep1_driver_drive_idle;
	positions[1].idle = %crew_jeep1_passenger1_drive_idle;
	positions[2].idle = %crew_jeep1_passenger2_drive_idle;
	positions[3].idle = %crew_jeep1_passenger3_drive_idle;
	positions[4].idle = %crew_jeep1_passenger3_drive_idle; // TEMP!
	positions[5].idle = %crew_jeep1_passenger3_drive_idle; // TEMP!

	positions[0].getout = %crew_jeep1_driver_climbout;
	positions[1].getout = %crew_jeep1_passenger1_climbout;
	positions[2].getout = %crew_jeep1_passenger2_climbout;
	positions[3].getout = %crew_jeep1_passenger3_climbout;
	positions[4].getout = %crew_jeep1_passenger3_climbout; // TEMP!
	positions[5].getout = %crew_jeep1_passenger3_climbout; // TEMP!

//	positions[0].getin = %crew_jeep1_driver_climbin;
//	positions[1].getin = %crew_jeep1_passenger1_climbin;
//	positions[2].getin = %crew_jeep1_passenger2_climbin;
//	positions[3].getin = %crew_jeep1_passenger3_climbin;
	
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "passengers" ] = [];


	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;

	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}

