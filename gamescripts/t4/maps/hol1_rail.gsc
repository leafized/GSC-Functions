#include maps\_utility;
#include maps\hol1_util;

put_player_on_rail( player )
{
	// lock the player(s) into position
	//get_players()[0] playerlinktodelta( level.jeep2, "tag_passenger", 1.0, 180, 180, 180, 180);
	//get_players()[0] playerlinktodelta( level.jeep1, "tag_passenger4", 1.0, 180, 180, 180, 180); // car 2 test
	level.jeep1 = getent( "jeep1", "targetname" );
	level.jeep2 = getent( "jeep2", "targetname" );

	if( level.rail_seat_taken_1 == false )
	{
		//player playerlinktodelta( level.jeep2, "tag_passenger", 1.0, 180, 180, 180, 180);	// standard player 1
		//player playerlinktodelta( level.jeep1, "tag_passenger4", 1.0, 180, 180, 180, 180);  // simulate player 2

		//p1 = GetDvarInt( "fake_player2" );
		//if( p1 == 0 )
		//{

			org = level.jeep2 gettagOrigin( "tag_passenger" );
			ang = level.jeep2 gettagangles( "tag_passenger" );
			
			// set the players to the tag origins and angles
			player setorigin( org );
			player setplayerangles( ang );
			
			// link the player in place
			player.link_spot = spawn( "script_origin", org );
			player.link_spot linkto( level.jeep2, "tag_passenger", (0,0,-30), (0,0,0) );
			player playerlinktodelta( player.link_spot, undefined, 1.0 );

			//SetDvar("fake_player2", "1");
		/*
		}
		else
		{
			org = level.jeep1 gettagOrigin( "tag_passenger4" );
			ang = level.jeep1 gettagangles( "tag_passenger4" );
			
			// set the players to the tag origins and angles
			player setorigin( org );
			player setplayerangles( ang );
			
			// link the player in place
			player.link_spot = spawn( "script_origin", org );
			player.link_spot linkto( level.jeep1, "tag_passenger4", (0,0,-30), (0,0,0) );
			player playerlinktodelta( player.link_spot, undefined, 1.0 );
			
			SetDvar("fake_player2", "0");
		}
		*/
		/////////////////////////////////////////////
		level.rail_seat_taken_1 = true;
		player.current_seat = 1;
	}
	else if( level.rail_seat_taken_2 == false )
	{
		player playerlinktodelta( level.jeep1, "tag_passenger4", 1.0, 180, 180, 180, 180);
		level.rail_seat_taken_2 = true;
		player.current_seat = 2;
	}
	else if( level.rail_seat_taken_3 == false )
	{
		player playerlinktodelta( level.jeep2, "tag_passenger3", 1.0, 180, 180, 180, 180);
		level.rail_seat_taken_3 = true;
		player.current_seat = 3;
	}
	else if( level.rail_seat_taken_4 == false )
	{
		player playerlinktodelta( level.jeep1, "tag_passenger3", 1.0, 180, 180, 180, 180);
		level.rail_seat_taken_4 = true;
		player.current_seat = 4;
	}
	else
	{
		iprintlnbold( "something wrong with the script" );
	}

	player setstance( "crouch" );
}

remove_player_from_rail( player )
{
	if( player.current_seat == 1 )
	{
		level.rail_seat_taken_1 = false;
	}
	else if( player.current_seat == 2 )
	{
		level.rail_seat_taken_2 = false;
	}
	else if( player.current_seat == 3 )
	{
		level.rail_seat_taken_3 = false;
	}
	else if( player.current_seat == 4 )
	{
		level.rail_seat_taken_4 = false;
	}
	player unlink();
}

rail_standard_vehicle_setup( start_name_1, start_name_2 )
{
	level.jeep1 = getent( "jeep1", "targetname" );
	jeep1_start = getvehiclenode( start_name_1, "script_noteworthy" );
	level.jeep1 attachPath( jeep1_start );
	level.jeep1.health = 100000000; 
	level.jeep1 startenginesound();

	level.jeep2 = getent( "jeep2", "targetname" );
	jeep2_start = getvehiclenode( start_name_2, "script_noteworthy" );
	level.jeep2 attachPath( jeep2_start );
	level.jeep2.health = 100000000; 
	level.jeep2 startenginesound();

	level.jeep1 thread maps\hol1_fx::vehicle_sharp_turn_left_snow_splash();
	level.jeep2 thread maps\hol1_fx::vehicle_sharp_turn_left_snow_splash();

	level.jeep1 thread maps\hol1_fx::vehicle_sharp_turn_right_snow_splash();
	level.jeep2 thread maps\hol1_fx::vehicle_sharp_turn_right_snow_splash();

	level.jeep1 thread maps\hol1_fx::vehicle_snow_splash_large();
	level.jeep2 thread maps\hol1_fx::vehicle_snow_splash_large();

	level.jeep1 thread maps\hol1_fx::vehicle_snow_flutter_left();
	level.jeep2 thread maps\hol1_fx::vehicle_snow_flutter_left();

	level.jeep1 thread maps\hol1_fx::vehicle_snow_flutter_right();
	level.jeep2 thread maps\hol1_fx::vehicle_snow_flutter_right();

	level.jeep1 thread maps\hol1_fx::vehicle_snow_falling_tree();
	level.jeep2 thread maps\hol1_fx::vehicle_snow_falling_tree();

	level.jeep1 thread maps\hol1_fx::vehicle_snow_wheels_accelerate();
	level.jeep2 thread maps\hol1_fx::vehicle_snow_wheels_accelerate();

	level thread maps\hol1_fx::attach_headlights( level.jeep1 );
	level thread maps\hol1_fx::attach_headlights( level.jeep2 );

	// AIs setup
	level.maddock = getent( "maddock", "targetname" );
	level.goddard = getent( "goddard", "targetname" );
	level.friend1 = getent( "friend1", "targetname" );
	level.friend2 = getent( "friend2", "targetname" );

	level.maddock thread magic_bullet_shield();
	level.goddard thread magic_bullet_shield();
	level.friend1 thread magic_bullet_shield();
	level.friend2 thread magic_bullet_shield();

	level.friend1 linkto( level.jeep1, "tag_driver" );
	level.maddock linkto( level.jeep1, "tag_passenger" );
	level.friend2 linkto( level.jeep2, "tag_passenger2" );
	level.goddard linkto( level.jeep2, "tag_driver" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		level thread put_player_on_rail( players[i] );
	}

	// these threads will animate the jeep crew. 
	// They will react based on notifies
	level thread maps\hol1_anim::driver_anims( level.friend1 );
	level thread maps\hol1_anim::driver_anims( level.goddard );
	level thread maps\hol1_anim::passenger_anims( level.maddock );
	level thread maps\hol1_anim::passenger2_anims( level.friend2 );
}

rail_standard_response( start_node, vehicle )
{
	if( start_node.script_noteworthy == "left" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify_crew( "turn_left" );
	}
	else if( start_node.script_noteworthy == "right" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify_crew( "turn_right" );
	}
	else if( start_node.script_noteworthy == "sharp_left" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify_crew( "sharp_turn_left" );
	}
	else if( start_node.script_noteworthy == "sharp_right" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify_crew( "sharp_turn_right" );
	}
	else if( start_node.script_noteworthy == "resume" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle resumespeed( 10 );
	}	
	else if( start_node.script_noteworthy == "shake" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		earthquake( 0.4, 1, vehicle.origin, 300 );
	}
	else if( start_node.script_noteworthy == "snow_light" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		level notify( "light_snow" );
	}
	else if( start_node.script_noteworthy == "snow_heavy" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		level notify( "heavy_snow" );
	}
	else if( start_node.script_noteworthy == "snow_intense" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		level notify( "intense_snow" );
	}
	else if( start_node.script_noteworthy == "snow_left_splash" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "snow_left_splash" );
	}
	else if( start_node.script_noteworthy == "snow_right_splash" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "snow_right_splash" );
	}
	else if( start_node.script_noteworthy == "snow_splash_large" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "snow_splash_large" );
	}
	else if( start_node.script_noteworthy == "flutter_left" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "flutter_left" );
	}
	else if( start_node.script_noteworthy == "flutter_right" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "flutter_right" );
	}
	else if( start_node.script_noteworthy == "snow_falling_tree" )
	{
		wait_till_reach_vehicle_node( start_node, vehicle );
		vehicle notify( "snow_falling_tree" );
	}
}

wait_till_reach_vehicle_node( node, vehicle )
{		
	vehicle setwaitnode( node );
	vehicle waittill( "reached_wait_node" );
}

notify_crew( msg )
{
	if( self == level.jeep1 )
	{
		level.friend1 notify( msg );
		level.maddock notify( msg );
	}
	else
	{
		level.friend2 notify( msg );
		level.goddard notify( msg );
	}
}

ev1_rail_reactions_init( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );
			if( start_node.script_noteworthy == "enter_checkpoint" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "checkpoint_entered" );
			}
			else if( start_node.script_noteworthy == "checkpoint_stop1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 99, 99 );
				level notify( "stop_at_checkpoint" );

				level waittill( "move_forward" );
				self setspeed( 5, 2, 2 );
			}
			else if( start_node.script_noteworthy == "checkpoint_stop2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 99, 99 );

				level waittill( "move_forward" );
				wait( 1 );
				self setspeed( 5, 2, 2 );
			}
			else if( start_node.script_noteworthy == "checkpoint_resume1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "stop_at_checkpoint2" );
				self setspeed( 0, 15, 15 );

				level waittill( "maddock_captured" );
				self resumespeed( 20 );
			}
			else if( start_node.script_noteworthy == "checkpoint_resume2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 15, 15 );

				level waittill( "maddock_captured" );
				wait( 1 );
				self resumespeed( 20 );
			}
			else if( start_node.script_noteworthy == "ev1_end_jeep1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
			}
			else if( start_node.script_noteworthy == "ev1_end_jeep2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 5, 10, 10 );

				level notify( "stop_jeep_at_overlook" );
			}
		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}


ev2_rail_reactions_init_a( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );

			if( start_node.script_noteworthy == "ev2_jeep2_start1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 2, 5, 5 );
			}
			else if( start_node.script_noteworthy == "ev2_jeep2_start2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				//self setspeed( 0, 999, 999 );
				//wait( 0.5 );
				self resumespeed( 15 );
			}
			else if( start_node.script_noteworthy == "ev2_jeep2_start3" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "jeep2_starts" );
			}
			else if( start_node.script_noteworthy == "ev2_jeep1_overlook_speed_up" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self resumespeed( 15 );
			}

			else if( start_node.script_noteworthy == "jeep1_curve_sharp" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 1, 1, 1 );
			}
			else if( start_node.script_noteworthy == "jeep1_curve_sharp2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
				level waittill( "move_from_halftrack" );
				self resumespeed( 25 );
			}
			else if( start_node.script_noteworthy == "jeep2_curve_sharp" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 1, 1, 1 );
			}
			else if( start_node.script_noteworthy == "jeep2_curve_sharp2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 5, 999, 999 );
				level notify( "stop_at_halftrack" );
				
				iprintlnbold( "AI: What should we do now?" );
				wait( 1 );
				iprintlnbold( "Goddard: Run through the fence!" );

				level notify( "move_from_halftrack" );
				self resumespeed( 25 );
			}
			else if( start_node.script_noteworthy == "ev2_lake_stop1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 1, 999, 999 );
				level notify( "rail_section_a_ends" );
			}
			else if( start_node.script_noteworthy == "ev2_lake_stop2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "lake_stop" );
				self setspeed( 5, 999, 999 );
			}
		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}

ev2_rail_reactions_init_b( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );

			// vehicle 2 only:

			if( self == level.jeep2 )
			{
				if( start_node.script_noteworthy == "ev2_convoy_1" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_1" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_2" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_2" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_2b" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_2b" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_3" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_3" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_4" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_4" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_5" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_5" );
				}
				else if( start_node.script_noteworthy == "ev2_convoy_6" )
				{
					wait_till_reach_vehicle_node( start_node, self );
					start_rail_opel( "ev2_convoy_start_6" );
				}
			}


			if( start_node.script_noteworthy == "ev2_convoy_ends_1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
			}
			else if( start_node.script_noteworthy == "truck_collision_anim_starts" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "truck_collision_anim_starts" );
			}
			else if( start_node.script_noteworthy == "ev2_convoy_ends_2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
				//iprintlnbold( "TRUCK COLLISION ANIM" );
				wait( 3 );  // until anim is playing
				level notify( "rail_section_b_ends" );
			}
		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}

ev2_rail_reactions_init_c( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );

	

			if( start_node.script_noteworthy == "bump" )
			{
				//
			}
			else if( start_node.script_noteworthy == "snow_pile" )
			{
				//
			}
			else if( start_node.script_noteworthy == "ev2_closing_in_camp" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "raise fog" );
			}
			else if( start_node.script_noteworthy == "ev2_spawn_panther_hit" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "time_to_spawn_panther" );
			}
			else if( start_node.script_noteworthy == "ev2_forest_end_1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
			}
			else if( start_node.script_noteworthy == "ev2_forest_end_2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 999, 999 );
				level notify( "stop_at_tank" );
				level notify( "tank_guards_escape" );

				level notify( "rail_section_c_ends" );
			}
		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}

ev2_rail_reactions_init_d( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );

			if( start_node.script_noteworthy == "ev2_spawn_panther_hit" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "ready_to_spawn_panther" );
			}
			else if( start_node.script_noteworthy == "ev2_see_tank_jeep2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				iprintlnbold( "Panther! Watch out!" );
			}
			else if( start_node.script_noteworthy == "ev2_jeep2_see_chase" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				iprintlnbold( "We got to help them out!" );
			}
			else if( start_node.script_noteworthy == "ev2_lake_edge_stop" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 5, 10, 10 );
			}
			else if( start_node.script_noteworthy == "ev2_lake_enter1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 5, 10, 10 );
			}
			else if( start_node.script_noteworthy == "ev2_lake_enter2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				self setspeed( 0, 99, 99 );
				level waittill( "tank_at_edge" );
				self resumespeed( 15 );
				level notify( "rail_section_d_ends" );
			}


		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}

ev2_rail_reactions_init_e( start_node, end_node )
{
	self endon( "stop_reactions" );
	self endon( "death" );

	// from the starting node, we will identify the next node with a script noteworthy, and wait till it gets hit
	while( isdefined( start_node ) )
	{
		// check to see if the node has a valid script noteworthy. If not, iterate the next node
		if( isdefined( start_node.script_noteworthy ) )
		{
			rail_standard_response( start_node, self );

			if( start_node.script_noteworthy == "lights_off" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				//iprintlnbold( "Turn off the lights. Let's sneak around on the lake" );
				
				level.jeep2 notify( "lights_off" );
				level.jeep1 notify( "lights_off" );
			}
			else if( start_node.script_noteworthy == "ev2_lake_speed_up_1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				iprintlnbold( "Turn off the lights. Let's find a way to sneak out of the lake!" );
				players = get_players();
				for( i = 0; i < players.size; i++ )
				{
					players[i] disableWeapons();
				}
			}
			else if( start_node.script_noteworthy == "ev2_lake_see_lights" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				iprintlnbold( "This way." );
			}
			else if( start_node.script_noteworthy == "ev2_spawn_chasers" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level thread start_rail_opel( "ev2_chaser_start_1" );
				level thread start_rail_opel( "ev2_chaser_start_2" );
			}
			else if( start_node.script_noteworthy == "ev2_stop_rail_1" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "rail_section_e_ends" );
			}
			else if( start_node.script_noteworthy == "ev2_stop_rail_2" )
			{
				wait_till_reach_vehicle_node( start_node, self );
				level notify( "rail_section_e_ends" );
			}

		}

		// if we have reached the end node, then stop iteration and exit
		if( start_node == end_node )
		{
			return;
		}

		// Continue to get the next node. If this is the last node, then exit
		if( isdefined( start_node.target ) )
		{
			next_node = getvehiclenode( start_node.target, "targetname" );
			start_node = next_node;
		}
		else
		{
			return;
		}
	}
}