#include maps\_utility;

main()
{
	precache_effects();
	spawnFX();
	level thread playerBlizzard();
	level.event3 = false;
	level.event4 = false;
	set_environment ("cold");
}

precache_effects()
{
	 level._vehicle_effect[ "jeep" ][ "snow" ]                 = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
   level._vehicle_effect[ "opel" ][ "snow" ]           = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
   level._vehicle_effect[ "panzeriv" ][ "snow" ]                 = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
		level._vehicle_effect[ "halftrack" ][ "snow" ]                 = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
   level._vehicle_effect[ "tiger" ][ "snow" ]           = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");
   level._vehicle_effect[ "sdk" ][ "snow" ]                 = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");

	
	level._effect["vehicle_blow"] 				= loadfx("explosions/large_vehicle_explosion");
	level._effect["artillery_blow"] 			= loadfx("explosions/fx_mortarExp_dirt");
	level._effect["artillery_blow_water"] = loadfx("explosions/mortarExp_water");
	level._effect["grave_blow"]						= loadfx("destructibles/fx_dest_grave_marker");
	level._effect["wood_blow"]						= loadfx("explosions/grenadeexp_wood");
	level._effect["campfire"]             = loadfx("maps/hol1/fx_fire_barrel_small_wind");
	level._effect["tripwire"]             = loadfx("maps/hol2/fx_snow_tripwire_exp");
	
	level._effect["steeple"]    				= loadfx("maps/hol2/fx_steeple_tower_fall");
	level._effect["steeple_blow"]         = loadfx("maps/hol2/fx_steeple_tower_exp");
	
	level._effect["88_on_house"]        	 = loadfx("maps/hol2/fx_house_88_destroy");
	level._effect["tiger_fakefire"]				 = loadfx("weapon/muzzleflashes/fx_tank_tiger_fire_flash");
	
	
	level._effect["road_dynamite"]        = loadfx("maps/hol2/fx_bridge_dynamite_exp");
	level._effect["satchel_house_1"]      = loadfx("maps/hol2/fx_satchel_window_exp_blk");
	level._effect["satchel_house_2"]      = loadfx("maps/hol2/fx_satchel_window_exp_gry");
	level._effect["snow_exp"]             = loadfx("weapon/artillery/fx_artillery_snow");

	
	level._effect["betty_explosion"] 			= LoadFx( "weapon/bouncing_betty/fx_betty_snow_exp" );
	level._effect["betty_smoketrail"] 		= LoadFx("impacts/fx_pipe_steam");
	level._effect["betty_groundPop"] 			= LoadFX( "weapon/bouncing_betty/fx_betty_snow_exit" );
	
	
	level.doorblow												= loadfx("explosions/grenadeExp_wood");
	level.wallblow 												= loadfx("explosions/grenadeExp_concrete");
	level._effect["cold_breath"]				  = loadfx("system_elements/fx_smoke_short_burst");


		// blizzard!
	level.fx_blizzard = loadfx("env/weather/fx_snow_windy_heavy"); 
	
	

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRYS SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
	level._effect["snow_lrg_falling_tree"]			   = loadfx ("env/foliage/fx_snow_falling_tree_light");
	level._effect["snow_small_falling_tree"]		   = loadfx ("env/foliage/fx_snow_flutter_bush_1");
	level._effect["snow_gust_heavy_lrg"]			     = loadfx ("env/weather/fx_snow_gust_heavy_1200");
	level._effect["snow_gust_roof"]			           = loadfx ("env/weather/fx_snow_gust_roof_600");
	
	level._effect["smk_plume"]			               = loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");
	level._effect["smk_smokebank"]			           = loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");

	level._effect["water_single_leak"]			      = loadfx ("env/water/fx_water_single_leak");
	level._effect["wire_sparks"]		              = loadfx ("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["fire_static_blk_smk"]			   = loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]			       = loadfx ("env/light/fx_dlight_fire_glow");
	
  level._effect["fire_distant_150_150"]			   = loadfx ("env/fire/fx_fire_150x150_tall_distant");
  
  level._effect["fire_win_smk_0x35y50z_blk"]	 = loadfx ("env/fire/fx_fire_win_smk_0x35y50z_blk");
  level._effect["fire_wall_100_150"]			     = loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
  level._effect["fire_static_detail"]			     = loadfx ("env/fire/fx_static_fire_detail_ndlight");
  level._effect["smoke_window_out"]			       = loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
//////////////////////////////////////////////////////////////////////
//////////////////////END BARRYS SECTION//////////////////////////////
//////////////////////////////////////////////////////////////////////

}


event1_campfire()
{ 

	firepoint = getstruct("campfire_pos", "targetname");
	playfx(level._effect["campfire"], firepoint.origin);	
}

		
playerBlizzard()
{
	wait 5;
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] thread player_blizzard_loop();
	}
}

// borrowed from _weather.gsc
// possibly moving it into _weather.gsc
player_blizzard_loop()
{
	self endon("death");
	self endon("disconnect");
	
	for (;;)
	{
		playfx ( level.fx_blizzard, self.origin + (0,0,0), self.origin + (0,0,0) );
		wait (0.1);
		if (level.event3 == true || level.event4==true) break;
	}
				waittime = 0.1;
				cyclecounter = 0;
				nextcycle = false;
				for (;;)
					{
						playfx ( level.fx_blizzard, self.origin + (0,0,0), self.origin + (0,0,0) );
						wait waittime;
						cyclecounter++;
						if (cyclecounter== 20) 
							{
								waittime = waittime + (0.1);
								cyclecounter = 0;
							}
						if (level.event3 == false) break;
						if (waittime > 1.5) break;
					}
}


event_1_amb()
{
	setexpfog(150, 800, 0.803, 0.812, 0.794, 10);
}

event_1_amb_1()
{
	setexpfog(150, 450, 0.803, 0.812, 0.794, 10);
}

event_1_amb_2()
{
	setexpfog(250, 1000, 0.803, 0.812, 0.794, 10);
}
	
event_2_amb()
{
	setexpfog(150, 401.733, 0.803, 0.812, 0.794, 20);
}
	
event_2_amb_2()
{
	setexpfog(500, 1000, 0.803, 0.812, 0.794, 5);
	wait 10;
	setexpfog(8000, 10000, 0.803, 0.812, 0.794, 500);
}
	
event_4_amb()
{
	setexpfog(99999999, 9999999999, 0.803, 0.812, 0.794, 200);
}

spawnFX()
{
	maps\createfx\hol2_fx::main();
}    
