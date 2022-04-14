// Level: oki1
// Scripter: MikeD

#include maps\_utility;
#include maps\oki1_callbacks;
main()
{
	// FX for oki1
	maps\oki1_fx::main();

	// Starts the threads in oki1_callbacks.gsc
	init_callbacks();

	maps\_load::main();
	maps\oki1_anim::main();
	maps\oki1_amb::main();
	maps\oki1_status::main();

	// Setup Level Variables.
	init_level_vars();
	init_flags();
}

//--------------//
// INIT Section //
//--------------//

// Thread the oki1_callbacks.gsc, handles coop players connecting/disconnecting as well as spawned/killed.
init_callbacks()
{
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();
}

init_level_vars()
{
}

init_flags()
{
}

init_friendlies()
{
	
}

//--------------------//
// Objectives Section //
//--------------------//
set_objective()
{
	
}

//--------//
// Events //
//--------//

// Start Event1
event1()
{
	
}

//-----------------//
// Plane Utilities //
//-----------------//

// Builds Aircraft to a custom order, using _vehicle.gsc
build_custom_aircraft( type )
{
	model = undefined;
	death_model = undefined;
	death_fx = "explosions/large_vehicle_explosion";
	death_sound = "explo_metal_rand";
	health = 2000;
	min_health = 1000;
	max_health = 5000;
	team = "axis";
	bombs = false;
	turretType = "default_aircraft_turret";
	turretModel = "weapon_machinegun_tiger";
	func = undefined;

	if( type == "rufe" )
	{
		model = "vehicle_jap_airplane_rufe_fly";
		death_fx = "env/smoke/fx_plane_smoke_trail_damage";
		death_model = "vehicle_jap_airplane_rufe_fly";
		health = 750;
		min_health = 500;
		max_health = 1000;
		team = "axis";
		func = ::axis_plane_init;

//		maps\_vehicle::build_predeathfx( "env/smoke/fx_plane_smoke_trail_damage", "tag_origin", undefined, undefined, undefined, undefined, undefined, true );
	}

	maps\_vehicle::build_template( "stuka", model, type );
	maps\_vehicle::build_localinit( func );

	maps\_vehicle::build_deathmodel( model, death_model );

//				   build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
	maps\_vehicle::build_deathfx( death_fx, "tag_engine", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	maps\_vehicle::build_life( health, min_health, max_health );

	maps\_vehicle::build_treadfx();

	maps\_vehicle::build_team( team );

	// Bomb stuff: TODO update with actual explosion fx, sound, and bomb model when we get them
	//  quakepower, quaketime, quakeradius, range, min_damage, max_damage
//	maps\_planeweapons::build_bomb_explosions( type, 0.5, 2.0, 1024, 768, 400, 25 );
//	maps\_planeweapons::build_bombs( type, "com_trashbag", "explosions/fx_mortarExp_dirt", "artillery_explosion" );
	
	maps\_vehicle::build_turret( turretType, "tag_gunLeft", turretModel, true );
	maps\_vehicle::build_turret( turretType, "tag_gunRight", turretModel, true );
}

axis_plane_init()
{
}

allies_plane_init()
{
}

spawn_player_plane()
{
}

spawn_plane( type, position, angles, t_name )
{	
}

//-----------------//
// FlakGun Section //
//-----------------//

// Spawns a flakgun at the given location, also activating it, also sets up the default gun paramenters.
// Self is level
spawn_flak( pos, team )
{
	trigger_dmg = Spawn( "trigger_radius", pos, 0, 200, 200 );

	if( team == "axis" )
	{
		trigger_dmg.targetname = "flak_axis";
	}
	else
	{
		trigger_dmg.targetname = "flak_allies";
	}

	flak = SpawnStruct();
	flak.origin = pos;
	flak.flak_accuracy  	= 0.8;
	flak.flak_accuracy_min  = 0.1;
	flak.flak_maxrange		= 10000;
	flak.flak_minrange		= 3000;
	flak.script_team		= team;
	flak.flak_target 		= undefined;
	flak.reacquire_mintime	= 0.25; // seconds
	flak.reacquire_maxtime	= 3; // seconds

	flak thread flak_target_think();
	flak thread flak_shoot();
	trigger_dmg thread flak_death_think();

	// Debug
	flak thread debug_flak_target();
}

// Controls the flak gun
flak_target_think()
{
	self endon( "flak_destroyed" );
	reacquire_timer = 0;

	while( 1 )
	{
		target = flak_acquire_target();

		if( !IsDefined( target ) )
		{
			wait( 0.1 );
			continue;
		}

		// Check for priority


		// Set the target, if priority or reacquire time says so.
		if( GetTime() > reacquire_timer )
		{
			reacquire_timer = GetTime() + RandomFloatRange( self.reacquire_mintime * 1000, self.reacquire_maxtime * 1000 );
			self.flak_target = target;
		}

		wait( 0.1 );
	}
}

flak_shoot()
{
	self endon( "flak_destroyed" );

	max_dist = 2048; // Max radius around the plane. for accuracy.
	offset = [];

	while( 1 )
	{
		accuracy = self get_flak_accuracy();

		if( accuracy < 0 ) // Out of range, or too close
		{
			wait( 0.1 );
			continue;
		}

		origin = self.flak_target.origin;

		offset[0] = RandomFloat( max_dist - ( accuracy * max_dist ) );
		offset[1] = RandomFloat( max_dist - ( accuracy * max_dist ) );
		offset[2] = RandomFloat( max_dist - ( accuracy * max_dist ) );

		for( i = 0; i < offset.size; i++ )
		{
			if( RandomInt( 2 ) == 0 )
			{
				offset[i] = offset[i] * -1;
			}
		}

		PlayFx( level._effect["air_burst"], origin + ( offset[0], offset[1], offset[2] ) );

		wait( RandomFloatRange( 0.5, 1 ) );
	}
}

flak_acquire_target()
{
	vehicles = GetEntArray( "script_vehicle", "classname" );

	enemy_vehicles = [];
	for( i = 0; i < vehicles.size; i++ )
	{
		if( IsDefined( vehicles[i].script_team ) && vehicles[i].script_team != self.script_team )
		{
			if( vehicles[i] is_plane() )
			{
				enemy_vehicles[enemy_vehicles.size] = vehicles[i];
			}
		}
	}

	target = undefined;
	dist = 99999999 * 99999999;
	for( i = 0; i < enemy_vehicles.size; i++ )
	{
		dist_check = DistanceSquared( self.origin, enemy_vehicles[i].origin );
		if( dist_check < dist )
		{
			target = enemy_vehicles[i];
			dist = dist_check;
		}
	}

	return target;
}

// 
flak_death_think()
{
	while( 1 )
	{
		self waittill( "damage", dmg );
		println( "Flak got damaged, ", dmg );
	}
}

get_flak_accuracy()
{
//	if( !IsDefined( self.flak_target ) || self.flak_target.health < 0 )
//	{
//		return -1;
//	}

	flak_minrange_squared = self.flak_minrange * self.flak_minrange;
	flak_maxrange_squared = self.flak_maxrange * self.flak_maxrange;

	dist = DistanceSquared( self.origin, self.flak_target.origin );
	if( dist < flak_minrange_squared )
	{
		return -1;
	}
	else if( dist < flak_maxrange_squared )
	{
		accuracy_mod = 1 - ( ( dist - flak_minrange_squared ) / flak_maxrange_squared );
		accuracy = self.flak_accuracy * accuracy_mod;

		if( accuracy < self.flak_accuracy_min )
		{
			accuracy = self.flak_accuracy_min;
		}

		return accuracy;
	}
	else
	{
		return -1; // Out of range.
	}
}

//-----------------//
// Utility Section //
//-----------------//
// Rounds to the nearest num... num is used like 100, which rounds to the nearest 100th( 0.01 )
round_to( val, num ) 
{
	return Int( val * num ) / num; 
}

// Checks to see if self is a defined plane or not.
is_plane()
{
	if( IsDefined( self.vehicletype ) )
	{
		type = self.vehicletype;

		if( IsDefined( level.plane_types[type] ) && level.plane_types[type] )
		{
			return true;
		}
	}

	return false;
}


//-----------------//
// Testing Section //
//-----------------//
test_flak()
{
	spawn_flak( get_players()[0].origin, "axis" );
	spawn_flak( get_players()[0].origin + ( 500, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 1000, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 1500, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 2000, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 2500, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 3000, 0, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 0, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 500, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 1000, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 1500, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 2000, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 2500, -500, 0 ), "axis" );
	spawn_flak( get_players()[0].origin + ( 3000, -500, 0 ), "axis" );
}

test_spawn_plane()
{
	plane = spawn_plane( "p51", level.player_plane_spawn_origin + ( -2000, 0, 100 ), ( 0, 0, 0 ) );
	plane.script_team = "allies";

	wait( 1 );

	plane SetSpeed( 100, 500, 500 );

	players = get_players();

	pos = players[0].origin;

	plane setNearGoalNotifyDist( 256 );
	plane setyawspeed( 360, 120 );

	while( 1 )
	{
		plane SetVehGoalPos( pos + ( 0, 0, 5000 ), 0 );
		plane waittill( "near_goal" );

		plane SetVehGoalPos( pos + ( 30000, 30000, 5000 ), 0 );
		plane waittill( "near_goal" );

		plane SetVehGoalPos( pos + ( 0, 30000, 5000 ), 0 );
		plane waittill( "near_goal" );

		plane SetVehGoalPos( pos + ( -30000, 30000, 5000 ), 0 );
		plane waittill( "near_goal" );
	}
}

fake_goal_radius( pos )
{
	while( DistanceSquared( self.origin, pos ) > 256 * 256 )
	{
		wait( 0.05 );
	}

	return;
}

//---------------//
// Debug Section //
//---------------//
debug_flak_target()
{
/#
	if( GetDvar( "flak_debug" ) == "" )
	{
		SetDvar( "flak_debug", "1" );
	}

	color = ( 0, 0, 0 );

	while( 1 )
	{
		if( GetDvarInt( "flak_debug" ) < 1 )
		{
			return;
		}

		if( IsDefined( self.flak_target ) )
		{
			// Accuracy
			accuracy = self get_flak_accuracy();
			
			if( accuracy < 0 )
			{
				color = ( 1, 1, 1 );
			}
			else
			{
				red 	= 1;
				green 	= 1 - accuracy;
				blue	= 0;
				color = ( red, green, blue );
			}

			line( self.origin, self.flak_target.origin, color );
			print3d( self.origin, accuracy, color );
		}

		wait( 0.05 );
	}
#/
}

line_ent_to_player( ent, color )
{
/#
	if( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	while( 1 )
	{
		line( ent.origin, get_players()[0].origin, color );
		wait( 0.05 );
	}
#/
}

draw_tag_forever( tag )
{
/#
	while( 1 )
	{
		org = self GetTagOrigin( tag );
		ang = self GetTagAngles( tag );
		level thread draw_axis( org, ang, undefined, 100 );

		wait( 0.05 );
	}
#/
}

draw_axis( org, ang, opcolor, size )
{
/#
	if( !IsDefined( size ) )
	{
		size = 10;
	}

	forward = anglestoforward (ang);
	forwardFar = common_scripts\utility::vectorscale(forward, size);
	forwardClose = common_scripts\utility::vectorscale(forward, 8);
	right = anglestoright (ang);
	leftdraw = common_scripts\utility::vectorscale(right, -2);
	rightdraw = common_scripts\utility::vectorscale(right, 2);
	
	up = anglestoup(ang);
	right = common_scripts\utility::vectorscale(right, size);
	up = common_scripts\utility::vectorscale(up, size);
	
	red = ( 0.9, 0.2, 0.2 );
	green = ( 0.2, 0.9, 0.2 );
	blue = ( 0.2, 0.2, 0.9 );
	if ( isdefined( opcolor ) )
	{
		red = opcolor;
		green = opcolor;
		blue = opcolor;
	}
	
	line( org, org + forwardFar, red, 0.9 );
	line( org + forwardFar, org + forwardClose + rightdraw, red, 0.9 );
	line( org + forwardFar, org + forwardClose + leftdraw, red, 0.9 );

	line( org, org + right, blue, 0.9 );
	line( org, org + up, green, 0.9 );
#/
}

draw_line_to_player( color )
{
/#
	self endon( "death" );

	if( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	while( 1 )
	{
		players = get_players();
		line( self.origin, players[0].origin, color );
		wait( 0.05 );
	}
#/
}
