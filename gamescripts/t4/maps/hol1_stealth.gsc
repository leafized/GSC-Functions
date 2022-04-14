#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;



#using_animtree( "generic_human" );

custom_stealth_detection_range_setup( health, front, back, corpse_front, corpse_back, shot, cautious )
{
	level.stealth_enemy_init_health = health;
	level.stealth_enemy_detect_front = front; 
	level.stealth_enemy_detect_back = back; 
	level.stealth_enemy_detect_corpse_front = corpse_front; 
	level.stealth_enemy_detect_corpse_back = corpse_back; 
	level.stealth_enemy_detect_shot = shot; 
	level.stealth_enemy_cautious_approach = cautious;
}


custom_stealth_ai( ai_group_name )
{
	self thread custom_stealth_reduce_initial_health();
	level thread custom_stealth_monitor_damage( self, ai_group_name );
	self thread custom_stealth_react_to_approaching_player( ai_group_name );
	self thread custom_stealth_idle();
	self thread custom_stealth_enter_combat();
}


// This runs on the level, not the ai entity
// When the trigger is pulled, alert the ai group of the player presence
custom_stealth_react_to_gun_fire( ai_friends )
{
	level endon( "end_stealth" );
	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] AttackButtonPressed() )
			{
				level notify( "attack_button_pressed" );
				if( players[i] close_to_any_friend( ai_friends ) )
				{
					level thread custom_stealth_full_alert( players[i].origin, ai_friends );
				}
			}
		}
		wait( 0.05 );
	}
}

custom_stealth_reduce_initial_health()
{
	self.old_health = self.health;
	self.health = level.stealth_enemy_init_health;
}

custom_stealth_monitor_damage( guy, ai_friends )
{
	self endon( "enemy_in_sight" );

	guy waittill( "damage", dmg );

	// check to see if this kills the ai
	if( guy.health <= 0 )
	{
		level thread custom_stealth_soft_alert( guy.origin, ai_friends );
	}
	else
	{
		level thread custom_stealth_full_alert( guy.origin, ai_friends );
	}
}

custom_stealth_react_to_approaching_player( ai_friends )
{
	self endon( "death" );
	self endon( "enemy_in_sight" );

	detection_range = 0;

	while( 1 )
	{	
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{

			// 1. Depending on if the player is in front arc or back arc of the entity
			//    react to him at different detection distances
			if ( self entity_is_in_front_of_me( players[i] ) )
			{
				detection_range = level.stealth_enemy_detect_front; 

				if ( distance( players[i].origin, self.origin ) < detection_range )
				{
					if( bullettracepassed( players[i] getEye(), self.origin + (0,0,48), false, self ) )
					{
						iprintlnbold( "Getting too close" );

						if( level.stealth_enemy_cautious_approach )
						{
							// turn towards player if necessary
							self turn_towards_target( players[i] );

							// say something: papers please
							iprintlnbold( "German: where's your papers?" );
							wait( 2 );
						}
						else
						{
							// gives player a chance to kill him or take cover
							wait( 1 );
							if( bullettracepassed( players[i] getEye(), self.origin + (0,0,48), false, self ) == false )
							{
								continue;
							}
						}

						// alert everyone
						iprintlnbold( "German: Intruders!" );
						level thread custom_stealth_full_alert( players[i].origin, ai_friends );
						return;
					}
				}
			}
			else
			{
				detection_range = level.stealth_enemy_detect_back;
	
				// 2. Now check to see if the player is within that distance
				if ( distance( players[i].origin, self.origin ) < detection_range )
				{
					iprintlnbold( "Getting too close" );
	
					if( level.stealth_enemy_cautious_approach )
					{
						// turn towards player if necessary
						self turn_towards_target( players[i] );
	
						// say something: papers please
						iprintlnbold( "German: where's your papers?" );
						wait( 2 );
					}
					else
					{
						// gives player a chance to kill him. Thread will end here if he dies
						wait( 3 );
					}
	
					// alert everyone
					iprintlnbold( "German: Intruders!" );
					level thread custom_stealth_full_alert( players[i].origin, ai_friends );
					return;
				}
			}
		}
		wait( 0.1 );
	}
}


custom_stealth_full_alert( enemy_origin, ai_friends )
{
	friends = get_ai_group_ai( ai_friends );

	level notify( ai_friends );

	for( i = 0; i < friends.size; i++ )
	{
		friends[i] notify( "stop_idle_anim" );
		friends[i] notify( "enemy_in_sight" );
	}
}

custom_stealth_soft_alert( enemy_origin, ai_friends )
{
	friends = get_ai_group_ai( ai_friends );

	for( i = 0; i < friends.size; i++ )
	{
		// if the enemy is in front
		if( friends[i] point_is_in_front_of_me( enemy_origin ) )
		{
			if( distance( enemy_origin, friends[i].origin  ) < level.stealth_enemy_detect_corpse_front )
			{
				if( bullettracepassed( enemy_origin + (0,0,48), friends[i].origin + (0,0,48), false, friends[i] ) )
				{
					level notify( ai_friends );
					friends[i] notify( "stop_idle_anim" );
					friends[i] notify( "enemy_in_sight" );
				}
			}
		}
		// ai cannot see the enemy and depend purely on distance
		else
		{
			if( distance( enemy_origin, friends[i].origin  ) < level.stealth_enemy_detect_corpse_back )
			{
				level notify( ai_friends );
				friends[i] notify( "stop_idle_anim" );
				friends[i] notify( "enemy_in_sight" );
			}
		}
	}
}


entity_is_in_front_of_me( target_entity )
{
	// We do this by:
	// 1, Form a line going from left to the right of self.
	// 2. Find the perpendicular vector from this line to the target entity's origin
	// 3. Dot product this vector with self's forward angle
	// 4. If the dot is positive (same direction vectors) it's in front

	point1 = self.origin; // 2 points needed to determine a line
	right_vector = anglestoright( self.angles );
	point2 = point1 + right_vector;

	vector_to_target = VectorFromLineToPoint( point1, point2, target_entity.origin );

	forward_vector = anglestoforward( self.angles );
	dot_product = vectordot( forward_vector, vector_to_target );

	if( dot_product >= 0 )
	{
		return true;
	}
	return false;
}

point_is_in_front_of_me( target_point )
{
	point1 = self.origin; // 2 points needed to determine a line
	right_vector = anglestoright( self.angles );
	point2 = point1 + right_vector;

	vector_to_target = VectorFromLineToPoint( point1, point2, target_point );

	forward_vector = anglestoforward( self.angles );
	dot_product = vectordot( forward_vector, vector_to_target );

	if( dot_product >= 0 )
	{
		return true;
	}
	return false;
}

turn_towards_target( target_entity )
{
	self notify( "stop_idle_anim" );
	vector_to_target = vectornormalize( target_entity.origin - self.origin );
	new_pos = self.origin + vector_to_target * 60;
	
	self.goalradius = 4;
	self setgoalpos( new_pos );
	self waittill( "goal" );
}

close_to_any_friend( ai_friends )
{
	friends = get_ai_group_ai( ai_friends );

	for( i = 0; i < friends.size; i++ )
	{
		if( distance( self.origin, friends[i].origin ) < 1024 )
		{
			return true;
		}
	}
	return false;
}

custom_stealth_idle()
{
	self endon( "death" );
	self endon( "enemy_in_sight" );

	self.ignoreall = 1;
	self.goalradius = 4;
	self.pacifist = 1;

	if( isdefined( self.script_patroller ) && self.script_patroller == 1 )
	{
		// patrollers don't need special anims
	}
	else
	{
		self.animname = "generic";
		//self thread anim_loop_solo( self, "patrol_idle_all", undefined, "stop_idle_anim" );
	}
}

custom_stealth_enter_combat()
{
	self endon( "death" );
	self waittill( "enemy_in_sight" );
	self notify( "stop_idle_anim" );
	level notify( "entering_combat" );

	self stopanimscripted();

	self.ignoreall = 0;
	self.goalradius = 1024;
	self.pacifist = 0;

	self.health = self.old_health;

	self FindBestCoverNode();
}