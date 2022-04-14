// hol3 fx script
#include maps\_utility;

main()
{
	precachefx();
	spawnfx();	
	thread wind_settings();
}


///////////////////
//
// Precache fx for use later on
//
///////////////////////////////

precachefx()
{
	
	// set up the tread fx for snow
	level._vehicle_effect[ "jeep" ][ "snow" ] 		= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	level._vehicle_effect[ "horch" ][ "snow" ] 		= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	level._vehicle_effect[ "wc51" ][ "snow" ] 		= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	level._vehicle_effect[ "sherman" ][ "snow" ] 	= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	level._vehicle_effect[ "gmc" ][ "snow" ] 		= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	level._vehicle_effect[ "wasp" ][ "snow" ] 		= loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
	
	// FLAME AI FX
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFx( "env/fire/fx_fire_player_torso" );	
	
	level._effect["large_vehicle_explosion"]		= loadfx ("explosions/large_vehicle_explosion");
	// TEMP
	level._effect["rocket_trail"] 					= loadfx( "weapon/rocket/fx_trail_bazooka_geotrail" );
	
	level._effect["barrel_fire"]            		= loadfx("env/fire/fx_fire_campfire_small");
	level._effect["sherman_smoke"]            		= loadfx("vehicle/vfire/fx_vfire_sherman");
	level._effect["stuck_jeep_tread"]				= loadfx("vehicle/treadfx/fx_treadfx_snow_spinout");
	
	level._effect["sandbags_explosion"]				= loadfx("maps/hol3/fx_exp_window_snow");
	level._effect["satchel_house"]					= loadfx("maps/hol3/fx_satchel_house_exp");
	level._effect["body_toss_impact"]				= loadfx("maps/hol3/fx_snow_impact_puff");
	level._effect["gate_vehicle_damage"]			= loadfx("maps/hol3/fx_gate_vehicle_damage");
	level._effect["wall_vehicle_damage"]			= loadfx("maps/hol3/fx_wall_vehicle_damage");
	
	level._effect["wasp_fire"]						= loadfx ("maps/hol3/fx_fire_house_wasp");
	level._effect["wasp_smoke"]						= loadfx ("maps/hol3/fx_smoke_window_wasp");
	level._effect["wasp_guy_fire"]					= loadfx ("env/fire/fx_fire_player_torso");
	

	level._effect["mg42_muzzleflash"]				= loadfx("weapon/muzzleflashes/mg42hv");	
	level._effect["flesh_hit"]						= LoadFX( "impacts/flesh_hit" );
	
	level._effect["cold_breath"] 					= loadfx("system_elements/fx_smoke_short_burst");
	
	
	level._effect["betty_explosion"]				= LoadFx( "weapon/bouncing_betty/fx_betty_snow_exp" );
	level._effect["betty_groundPop"] 				= LoadFX( "weapon/bouncing_betty/fx_betty_snow_exit" );
	level._effect["betty_smoketrail"] 				= LoadFX( "weapon/bouncing_betty/fx_betty_trail" );
	
	
	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////BARRYS SECTION	////And Dale, too!//////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////
	level._effect["snow_lrg_falling_tree"]			   = loadfx ("env/foliage/fx_snow_falling_tree_light");
	level._effect["snow_small_falling_tree"]		   = loadfx ("env/foliage/fx_snow_flutter_bush_1");
	level._effect["snow_gust_heavy_lrg"]			     = loadfx ("env/weather/fx_snow_gust_heavy_1200");
	level._effect["snow_gust_light_lrg"]			     = loadfx ("env/weather/fx_snow_gust_lght_1200");
	level._effect["snow_gust_roof"]			           = loadfx ("env/weather/fx_snow_gust_roof_600");
	level._effect["snow_windy_small"]			         = loadfx ("env/weather/fx_snow_windy_small");
	
	level._effect["smk_plume"]			               = loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");
	level._effect["smk_smokebank"]			           = loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");

	level._effect["water_single_leak"]			     = loadfx ("env/water/fx_water_single_leak");
	level._effect["wire_sparks"]		             = loadfx ("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["fire_static_blk_smk"]			   = loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]			       = loadfx ("env/light/fx_dlight_fire_glow");
	
  level._effect["fire_distant_150_150"]			   = loadfx ("env/fire/fx_fire_150x150_tall_distant");
  
  level._effect["fire_win_smk_0x35y50z_blk"]	 = loadfx ("env/fire/fx_fire_win_smk_0x35y50z_blk");
  level._effect["fire_wall_100_150"]			     = loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
  level._effect["fire_static_detail"]			     = loadfx ("env/fire/fx_static_fire_detail_ndlight");
  level._effect["smoke_window_out"]			       = loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
}


// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
//	SetSavedDvar( "wind_global_vector", "-63 70 0" ); // (-63, 70) = 5.56 mph w/ a normal of -0.9
//	SetSavedDvar( "wind_global_low_altitude", -200 );
//	SetSavedDvar( "wind_global_hi_altitude", 1600 );
//	SetSavedDvar( "wind_global_low_strength_percent", 0.3 );

	// Add a while loop to vary the strength of the wind over time.
}


spawnfx()
{
	maps\createfx\hol3_fx::main();
}