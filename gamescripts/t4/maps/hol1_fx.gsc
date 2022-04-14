// FX Level File
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.blizzard_intensity = 1;

	precache_fx();
	spawnFX();	
	
	level thread playerBlizzard();
	
	level thread other_fx();
}


precache_fx()
{
	//level.fx_tank_blast = loadfx("explosions/tank_impact_dirt"); 
	//level.fx_lake_blast = loadfx("explosions/fx_mortarExp_dirt"); 
	
	// blizzard!
	level.fx_blizzard = loadfx("env/weather/fx_snow_windy_heavy"); 

	level._effect["cold_breath"] = loadfx("system_elements/fx_smoke_short_burst");

	level._effect["headlight"]	 = loadfx("env/light/fx_ray_headlight_truck"); 
	level._effect["brakelight"]	 = loadfx("env/light/fx_glow_brakelight_red"); 

	level._effect["barrel_fire"]            	= loadfx("maps/hol1/fx_fire_barrel_small_wind");

	level._vehicle_effect[ "jeep" ][ "snow" ]   = loadfx ("vehicle/treadfx/fx_treadfx_md_snow");

	// mortars
	//level._effectType["dirt_mortar"] 			= "mortar";
	//level._effect["dirt_mortar"]					= loadfx("explosions/fx_mortarExp_dirt");

	level._effect["blizzard_light"] = loadfx("env/weather/fx_snow_blizzard_light");	
	level._effect["blizzard_heavy"] = loadfx("env/weather/fx_snow_blizzard_heavy");	
	level._effect["blizzard_intense"] = loadfx("env/weather/fx_snow_blizzard_intense");	

	level._effect["snow_gust_road"] = loadfx("maps/hol1/fx_snow_gust_road");	

	level._effect["snow_wheel_splash"] = loadfx("misc/fx_snow_splash_tire_1");	

	level._effect["snow_splash_small"] = loadfx("misc/fx_snow_crash_plume_1");	
	level._effect["snow_splash_large"] = loadfx("maps/hol1/fx_snow_vehicle_splash_1_night");	

	level._effect["snow_flutter"] = loadfx("maps/hol1/fx_snow_flutter_bush_1");	
	
	level._effect["snow_tree_falling"] = loadfx("maps/hol1/fx_snow_falling_tree_large_wind");	


	level._effect["rifleflash"] = LoadFX( "weapon/muzzleflashes/rifleflash" );
	level._effect["rifle_shelleject"] = LoadFX( "weapon/shellejects/rifle" );
	level._effect["headshot"] = LoadFX( "impacts/flesh_hit_head_fatal_exit" );


///////////////////////////////////////////////////////////////
// Quinn Section

  level._effect["chimney_smoke_large"] = LoadFX( "maps/hol1/fx_smoke_chimney_wind" );
  level._effect["fire_barrel_small"] = LoadFX( "maps/hol1/fx_fire_barrel_small_wind" );
  level._effect["glow_outdoor"] = LoadFX( "env/light/fx_glow_lampost_white_dim_static" );
  level._effect["glow_indoor"] = LoadFX( "env/light/fx_light_indoor_white_static" );
  level._effect["glow_indoor_spot"] = LoadFX( "env/light/fx_glow_indoor_white_dim_static" );
  level._effect["glow_outdoor_spot"] = LoadFX( "env/light/fx_glow_outdoor_spot_dim_static" );
  level._effect["snow_gust_rooftop"] = LoadFX( "maps/hol1/fx_snow_gust_rooftop" );
  level._effect["dlight_fire"] = LoadFX( "maps/hol1/fx_fire_barrel_d_light" );
  level._effect["snow_gust_detail_1"] = LoadFX( "maps/hol1/fx_snow_gust_detail_1" );
  level._effect["snow_gust_detail_2"] = LoadFX( "maps/hol1/fx_snow_gust_detail_2" );
  level._effect["snow_gust_detail_3"] = LoadFX( "maps/hol1/fx_snow_gust_detail_3" );
  level._effect["snow_falling_tree_wind_sml"] = LoadFX( "maps/hol1/fx_snow_falling_tree_small_wind" );
  level._effect["snow_falling_tree_wind_lrg"] = LoadFX( "maps/hol1/fx_snow_falling_tree_large_wind" );
  level._effect["snow_falling_tree_runner_lrg"] = LoadFX( "maps/hol1/fx_snow_falling_tree_large_wind_loop" );
  level._effect["snow_falling_tree_runner_sml"] = LoadFX( "maps/hol1/fx_snow_falling_tree_small_wind_loop" );
  level._effect["glow_spotlight"] = LoadFX( "env/light/fx_glow_spotlight_white_dim_static" );

// End Quinn Section
///////////////////////////////////////////////////////////////

}

spawnFX()
{
	// uncomment this when checking the effect file
	maps\createfx\hol1_fx::main();
}    



// borrowed from _weather.gsc
// possibly moving it into _weather.gsc
playerBlizzard()
{
	//level waittill ("introscreen_complete"); // temp. Wait for players to all join
		
	wait( 2 );

	level thread blizzard_intensity_updater( "light_snow", 1 );
	level thread blizzard_intensity_updater( "heavy_snow", 2 );
	level thread blizzard_intensity_updater( "intense_snow", 3 );
	level thread blizzard_intensity_updater( "stop_snow", 0 );

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
		if( level.blizzard_intensity == 1 )
		{
			playfx ( level._effect["blizzard_light"], self.origin + (0,0,0), self.origin + (0,0,0) );
		}
		else if( level.blizzard_intensity == 2 )
		{
			playfx ( level._effect["blizzard_heavy"], self.origin + (0,0,0), self.origin + (0,0,0) );
		}
		else if( level.blizzard_intensity == 3 )
		{
			playfx ( level._effect["blizzard_intense"], self.origin + (0,0,0), self.origin + (0,0,0) );
		}

		// if intensity is any other level, play nothing		

		wait (0.1);
	}
}

blizzard_intensity_updater( msg, intensity )
{
	while( 1 )
	{
		level waittill( msg );	
		level.blizzard_intensity = intensity;
	}
}

attach_headlights( vehicle )
{
	wait( 3 );
	fx_l = playfxontag( level._effect["headlight"], vehicle, "tag_headlight_left" );
	fx_r = playfxontag( level._effect["headlight"], vehicle, "tag_headlight_right" );
	//playfxontag( level._effect["brakelight"], vehicle, "tag_brakelight_left" );
	//playfxontag( level._effect["brakelight"], vehicle, "tag_brakelight_right" );
	
	vehicle waittill_either( "death", "lights_off" );
	//fx_l delete();
	//fx_r delete();
}


attach_headlights_to_struct( struct_targetname )
{
	pos = getstructarray( struct_targetname, "targetname" );
	for( i = 0; i < pos.size; i++ )
	{
		playfx( level._effect["headlight"], pos[i].origin, anglestoforward( pos[i].angles ), anglestoup( pos[i].angles ) );
	}
}

other_fx()
{
	wait( 5 );
	pos = getstructarray( "ev1_barrel_fire", "targetname" );
	for( i = 0; i < pos.size; i++ )
	{
		playfx( level._effect["barrel_fire"], pos[i].origin );
	}

	pos = getstructarray( "snow_gust_road", "targetname" );
	for( i = 0; i < pos.size; i++ )
	{
		playfx( level._effect["snow_gust_road"], pos[i].origin );
	}

}


vehicle_sharp_turn_left_snow_splash()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "snow_left_splash" );

		for( i = 0; i < 3; i++ )
		{
			// shift position back a bit
			current_angle = self.angles;
			forward_vector = vectornormalize( anglestoforward( current_angle ) );
			forward_distance = -40;
			displacement_vector = forward_vector * forward_distance;

			angle_to_right = current_angle + ( 0, -90, 0 );
			angle_to_right = angle_to_right + ( -70, 0, 0 );

			origin1 = self gettagorigin( "tag_wheel_front_left" );
			origin2 = self gettagorigin( "tag_wheel_front_right" );
			origin3 = self gettagorigin( "tag_wheel_back_left" );
			origin4 = self gettagorigin( "tag_wheel_back_right" );

			forward_vector = anglestoforward( angle_to_right );
			up_vector = anglestoup( angle_to_right );

			playfx( level._effect["snow_wheel_splash"], origin1 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin2 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin3 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin4 + displacement_vector, forward_vector, up_vector );

			wait( 0.1 );
		}
	}
}

vehicle_sharp_turn_right_snow_splash()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "snow_right_splash" );

		for( i = 0; i < 3; i++ )
		{
			// shift position back a bit
			current_angle = self.angles;
			forward_vector = vectornormalize( anglestoforward( current_angle ) );
			forward_distance = -40;
			displacement_vector = forward_vector * forward_distance;

			angle_to_left = current_angle + ( 0, 90, 0 );
			angle_to_left = angle_to_left + ( -70, 0, 0 );

			origin1 = self gettagorigin( "tag_wheel_front_left" );
			origin2 = self gettagorigin( "tag_wheel_front_right" );
			origin3 = self gettagorigin( "tag_wheel_back_left" );
			origin4 = self gettagorigin( "tag_wheel_back_right" );

			forward_vector = anglestoforward( angle_to_left );
			up_vector = anglestoup( angle_to_left );

			playfx( level._effect["snow_wheel_splash"], origin1 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin2 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin3 + displacement_vector, forward_vector, up_vector );
			playfx( level._effect["snow_wheel_splash"], origin4 + displacement_vector, forward_vector, up_vector );

			wait( 0.1 );
		}
	}
}

vehicle_snow_splash_large()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "snow_splash_large" );

		// This effect has to play several units in front of the vehicle
		// So we calculate a forward position using the vehicle's angles
		current_angle = self.angles;
		forward_vector = vectornormalize( anglestoforward( current_angle ) );
		forward_distance1 = 90;
		forward_distance2 = 120;
		displacement_vector1 = forward_vector * forward_distance1;
		displacement_vector2 = forward_vector * forward_distance2;
		forward_position1 = self.origin + displacement_vector1;
		forward_position2 = self.origin + displacement_vector2;

		// now the effect has to be played at a random angle, so as not to 
		// look the same every time
		up_vector = anglestoup( current_angle );
		random_angle_x = randomint( 180 ) - 90;
		random_angle_y = randomint( 180 ) - 90;
		random_angle_z = randomint( 180 ) - 90;
		forward_vector = anglestoforward( ( random_angle_x, random_angle_y, random_angle_z ) );
		
		playfx( level._effect["snow_splash_large"], forward_position1, forward_vector, up_vector );

		random_angle_x = randomint( 180 ) - 90;
		random_angle_y = randomint( 180 ) - 90;
		random_angle_z = randomint( 180 ) - 90;
		forward_vector = anglestoforward( ( random_angle_x, random_angle_y, random_angle_z ) );
		
		playfx( level._effect["snow_splash_large"], forward_position2, forward_vector, up_vector );
	}
}

vehicle_snow_flutter_left()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "flutter_left" );

		// This effect has to play several units in front of the vehicle
		// So we calculate a forward position using the vehicle's angles
		current_angle = self.angles;
		left_angle = current_angle + ( 0, 90, 0 );

		left_vector = vectornormalize( anglestoforward( left_angle ) );
		forward_vector = vectornormalize( anglestoforward( current_angle ) );

		left_distance = 50;
		forward_distance1 = 100;
		forward_distance2 = 50;
		forward_distance3 = 0;
		forward_distance4 = -50;
		forward_distance5 = -100;

		left_displacement_vector = left_vector * left_distance;
		forward_displacement_vector1 = forward_vector * forward_distance1;
		forward_displacement_vector2 = forward_vector * forward_distance2;
		forward_displacement_vector3 = forward_vector * forward_distance3;
		forward_displacement_vector4 = forward_vector * forward_distance4;
		forward_displacement_vector5 = forward_vector * forward_distance5;

		position1 = self.origin + left_displacement_vector + forward_displacement_vector1;
		position2 = self.origin + left_displacement_vector + forward_displacement_vector2;
		position3 = self.origin + left_displacement_vector + forward_displacement_vector3;
		position4 = self.origin + left_displacement_vector + forward_displacement_vector4;
		position5 = self.origin + left_displacement_vector + forward_displacement_vector5;

		// now the effect has to be played at a random angle, so as not to 
		// look the same every time
		up_vector = anglestoup( current_angle );
		random_angle_x = randomint( 180 ) - 90;
		random_angle_y = randomint( 180 ) - 90;
		random_angle_z = randomint( 180 ) - 90;
		forward_vector = anglestoforward( ( random_angle_x, random_angle_y, random_angle_z ) );
		
		playfx( level._effect["snow_flutter"], position1, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position2, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position3, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position4, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position5, forward_vector, up_vector );
		wait( 1 );
	}
}

vehicle_snow_flutter_right()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "flutter_right" );

		// This effect has to play several units in front of the vehicle
		// So we calculate a forward position using the vehicle's angles
		current_angle = self.angles;
		left_angle = current_angle + ( 0, -90, 0 );

		left_vector = vectornormalize( anglestoforward( left_angle ) );
		forward_vector = vectornormalize( anglestoforward( current_angle ) );

		left_distance = 50;
		forward_distance1 = 100;
		forward_distance2 = 50;
		forward_distance3 = 0;
		forward_distance4 = -50;
		forward_distance5 = -100;

		left_displacement_vector = left_vector * left_distance;
		forward_displacement_vector1 = forward_vector * forward_distance1;
		forward_displacement_vector2 = forward_vector * forward_distance2;
		forward_displacement_vector3 = forward_vector * forward_distance3;
		forward_displacement_vector4 = forward_vector * forward_distance4;
		forward_displacement_vector5 = forward_vector * forward_distance5;

		position1 = self.origin + left_displacement_vector + forward_displacement_vector1;
		position2 = self.origin + left_displacement_vector + forward_displacement_vector2;
		position3 = self.origin + left_displacement_vector + forward_displacement_vector3;
		position4 = self.origin + left_displacement_vector + forward_displacement_vector4;
		position5 = self.origin + left_displacement_vector + forward_displacement_vector5;

		// now the effect has to be played at a random angle, so as not to 
		// look the same every time
		up_vector = anglestoup( current_angle );
		random_angle_x = randomint( 180 ) - 90;
		random_angle_y = randomint( 180 ) - 90;
		random_angle_z = randomint( 180 ) - 90;
		forward_vector = anglestoforward( ( random_angle_x, random_angle_y, random_angle_z ) );
		
		playfx( level._effect["snow_flutter"], position1, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position2, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position3, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position4, forward_vector, up_vector );
		wait( 0.1 );
		playfx( level._effect["snow_flutter"], position5, forward_vector, up_vector );
		wait( 1 );
	}
}

vehicle_snow_falling_tree()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "snow_falling_tree" );

		// This effect has to play several units in front of the vehicle
		// So we calculate a forward position using the vehicle's angles
		current_angle = self.angles;
		forward_vector = vectornormalize( anglestoforward( current_angle ) );
		forward_distance = 160;
		displacement_vector = forward_vector * forward_distance;
		forward_position = self.origin + displacement_vector;

		// now the effect has to be played at a random angle, so as not to 
		// look the same every time
		up_vector = anglestoup( current_angle );
		random_angle_x = randomint( 180 ) - 90;
		random_angle_y = randomint( 180 ) - 90;
		random_angle_z = randomint( 180 ) - 90;
		forward_vector = anglestoforward( ( random_angle_x, random_angle_y, random_angle_z ) );
		
		playfx( level._effect["snow_tree_falling"], forward_position + ( 0, 0, 40 ), forward_vector, up_vector );
	}

}


vehicle_snow_wheels_accelerate()
{
	self endon( "death" );

	while( 1 )
	{
		
		// We need to determine if the vehicle is moving fast enough to warrant this particle
		old_pos = self.origin;
		wait( 0.05 );
		new_pos = self.origin;
		displacement = distance( old_pos, new_pos );

		if( displacement >= 3 ) 
		{
			// need to know if the car is going forward or backward
			displacement_vector = new_pos - old_pos;
			displacement_vector = vectornormalize( displacement_vector );
			car_displacement_vector = vectornormalize( anglestoforward( self.angles ) );
			dot = vectordot( displacement_vector, car_displacement_vector );

			backward = false;
			if( dot < 0 )
			{
				backward = true;
			}
	
			// now the particle is going to play depending on the speed
			// angles to play range from 350 (low) to 300 (high)
			// range of displacement is at most about 18
			
			angles_variation = ( displacement - 3 ) * 3;
			if( angles_variation > 50 )
			{
				angles_variation = 50;
			}
			angles_variation = -1 * angles_variation;

			if( backward == false )
			{
				angles = self.angles + ( 350, 180, 0 ) + ( angles_variation, 0, 0 );
			}
			else
			{
				angles = self.angles + ( 350, 0, 0 ) + ( angles_variation, 0, 0 );
			}

			origins1 = self gettagorigin( "tag_wheel_back_left" );
			origins2 = self gettagorigin( "tag_wheel_back_right" );
			origins3 = self gettagorigin( "tag_wheel_front_left" );
			origins4 = self gettagorigin( "tag_wheel_front_right" );

			playfx( level._effect["snow_wheel_splash"], origins1, anglestoforward( angles ), anglestoup( angles ) );
			playfx( level._effect["snow_wheel_splash"], origins2, anglestoforward( angles ), anglestoup( angles ) );
			playfx( level._effect["snow_wheel_splash"], origins3, anglestoforward( angles ), anglestoup( angles ) );
			playfx( level._effect["snow_wheel_splash"], origins4, anglestoforward( angles ), anglestoup( angles ) );

			// wait time depends on speed
			intervals = 1 - ( ( displacement - 3 ) * 0.08 );
			if( intervals <= 0.1 )
			{
				intervals = 0.1;
			}
			wait( intervals );
		}
	}
}
