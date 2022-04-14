// Level: Fly
// Scripter: MikeD

// LDD:
//--------------------------------------------------------------------------------------------------------------------------------
//Event 1 – Scout the South
//-	IGC: Plane is started and takes off, points the player in the right direction.
//-	Objectives are bread crumbed to fly over different locations.
//-	This gives the player time to learn the controls. 
//-	The plane flies over the taken beach. Lots of landing craft landing and squads setting up. 
//-	Player sees battleships in the distance.
//-	TOO - A Japanese Sea Plane is scouting in this area. If seen and taken out, there will be less enemy planes in Event 3.

//Event 2 – Support the Ground Troops
//-	Player is joined by other Corsairs
//-	Red smoke is seen in the distance, marking targets for the planes
//-	Player has to fly over and destroy the camps/bunkers with machine guns and/or rockets
//-	Some camps are supported by AA, mounted machine guns and Japanese soldiers.
//-	Ambient battles are taking place, allied soldiers are shooting into the camps from the outside (safe from the player’s fire)

//Event 3 – Dogfighting
//-	The player is briefed that Japanese fighters are incoming.
//-	Player and his allied planes must shoot down a number of Japanese fighter planes.
//-	The amount of planes here is determined by whether the player destroyed the Japanese scout plane in Event 1 or not.

//Event 4 – Refuel and Restock
//-	The player must fly back to the airfield and fly directly over the airfield in which the IGC takes over.
//-	IGC: Shows the plane being refueled and restocked with napalm. Then, the plane takes off and turns right, facing the player in the right direction for when the controls are returned.

//Event 5 – Clean out Bloody Nose Ridge
//-	Metal doors open all over the ridge and guns are rolled out. Guns start shooting at the player.
//-	TOO – If the player follows the road to the north of the ridge, a light convoy of jeeps and trucks will be available to shoot. If taken out, this stops a radio warning to the enemy and less enemy planes are deployed.
//-	Japanese planes attack from a distance to defend the ridge. 
//-	The player must take out all the planes and destroy all the guns on the ridge.
//-	After things are clear, the player is instructed to drop napalm on the ridge. Flying over the ridge and dropping napalm anywhere on it will initiate the end IGC.
//-	IGC: Napalm covers the ridge as Japanese soldiers flee out of the caves. They are met with squads of allies and surrender.
//--------------------------------------------------------------------------------------------------------------------------------


// F4U-1D Corsair Specs:
//Wingspan:							40 ft. 10 in.
//Overall Length:					33 ft. 8 in.
//Height:							14 ft. 9 in.
//Empty Weight:						9,206 lbs.
//Gross Weight:						14,670 lbs.
//Fuel Capacity:					534 gal.
//Oil Capacity:						20 gal.
//Engine:							Pratt & Whitney R-2800-18W 18 cylinder, twin row, air-cooled radial, 2,450 hp with water injection
//Propeller:						Hamilton Standard 4-blade, 13 ft. 2 in. diameter
//Maximum Speed, Sea Level:			417 mph ( 7339.2 / units per second, 611.6 / ft per second)
//Initial Rate-of-Climb:			3,870 ft./min.
//Cruise Speed, Sea Level:			182 mph ( 3202.8 / units per second, 266.9 / ft per second)
//Range at Cruise Speed:			1,015 miles
//Service Ceiling:					33,900 ft.
//Crew:								1
//Armament:							Six .50 cal machine guns
//Bomb Load:						up to 4,000 lb on centerline and pylon racks
//Total Built, F4U-4:				5,380 aircraft
//Total Built, all F4U variants:	12,571 aircraft

// NOTE:              	**  This engine provided 2,450 hp for short periods of time by the use of water injection for war emergency power.
// IL2 Sturmovik Stats:
// 5+ seconds to do a full roll
// 7+ seconds to do a full horizontal 360 turn.

// TODO List:
//-----------
// - Weapons
// - Objectives
// - Waypoints
// - Tutorial
// - Remove Temp Hud, wait for code to implement it correctly.

// Overall stuff to fix:
//----------------------
// - Camera Shake when firing MGs.
// - Plane Feel
// - (LUCAS) Config file for controls
// - (LUCAS) Notify for when the player switches weapon (only for the fly level, player_cmd bound)
// - (LUCAS) Bug about camera offset not staying with the plane during Rolls/Flips.
// - target_set() no longer works.
// - (LUCAS) Need a friendly_set() similar to target_set, just can't padlock to them. This can also be used on Coop Players.
// - (LUCAS) Tracers need to work on player vehicle weapons.
// - (LUCAS) Need to be able to "use" the plane via script, UseBy();
// - (LUCAS) Hud instruments

#include maps\_utility;
#include common_scripts\utility;
#include maps\fly_callbacks;
main()
{
	PrecacheModel( "temp_larger" );

	// Celing Cap
	SetSavedDvar( "vehPlaneAltCap", "25000" );

	// No compass needed in the fly level
	SetSavedDvar( "compass", "0" );

	// _player_corsair will be used rather than _player_aircraft.
	maps\_player_corsair::main( "vehicle_usa_aircraft_f4ucorsair" );
	maps\_p51::main( "vehicle_p51_mustang" );
	build_custom_aircraft( "rufe" );

	// Starts the threads in fly_callbacks.gsc
	init_callbacks();

	maps\_load::main();
	maps\fly_anim::main();
	maps\fly_fx::main();
	maps\fly_amb::main();
	maps\fly_status::main();
	maps\createcam\fly_cam::main();

	// Setup Level Variables.
	init_level_vars();
	init_plane_types();
	init_flags();

	if( GetDvar( "createcam" ) == "1" )
	{
		return;
	}

//	// TESTING:
//	while( 1 )
//	{
//		vehicles = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 10001 );
//		
//		wait( 5 );
//		RadiusDamage( vehicles[0].origin, 200, vehicles[0].health, vehicles[0].health );
//
//		wait( 1 );
//	}

	// Begin the level.
	intro();
	level thread event1();

	// TESTING SECTION
//	wait( 1 );
//	level thread test_spawn_plane();
}

//--------------//
// INIT Section //
//--------------//

// Thread the fly_callbacks.gsc, handles coop players connecting/disconnecting as well as spawned/killed.
init_callbacks()
{
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();
}

init_plane_types()
{
	add_plane_type( "player_corsair" );
}

add_plane_type( type )
{
	if( !IsDefined( level.plane_types ) )
	{
		level.plane_types = [];
	}

	level.plane_types[type] = true;
}

init_level_vars()
{
	level.sea_level = 0;

	// Localized Strings
	add_localized_string( "tutorial1", &"FLY_TUT_PLANE_ROLL" );
	add_localized_string( "tutorial2", &"FLY_TUT_PLANE_PITCH" );
	add_localized_string( "tutorial3", &"FLY_TUT_PLANE_ACCEL" );
	add_localized_string( "tutorial4", &"FLY_TUT_PLANE_DECCEL" );
	add_localized_string( "tutorial5", &"FLY_TUT_PLANE_RUDDER" );
	add_localized_string( "tutorial6", &"FLY_TUT_PLANE_FIREWEAPONS" );
	add_localized_string( "tutorial7", &"FLY_TUT_PLANE_SWITCHWEAPONS" );
}

add_localized_string( ref, string )
{
	if( !IsDefined( level.l_strings ) )
	{
		level.l_strings = [];
	}

	level.l_strings[ref] = string;
	PrecacheString( string );
}

init_flags()
{
	flag_init( "spawn_event1_recon" );
	flag_set( "spawn_event1_recon" );
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

// Temp intro, should be moved to fly_igc.gsc
intro()
{
/#
	if( GetDvar( "igc_intro" ) == "" )
	{
		SetDvar( "igc_intro", "1" );
	}
#/

	level waittill( "starting final intro screen fadeout" );

	if( GetDvar( "igc_intro" ) == "1" )
	{
//		level thread maps\_camsys::playback_scene( undefined, "stop_igc" );
	}

	iprintlnbold( "Waiting for plane to take off..." );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] SetPlayerAngles( players[i].angles + ( 0, 180, 0 ) );
	}

	plane = GetEnt( "player_corsair", "targetname" );
//	vnode = GetVehicleNode( "intro_vehicle_node1", "targetname" );
//	plane AttachPath( vnode );
//	plane StartPath();

//	plane waittill( "reached_end_node" );

	wait( 4 );
	level notify( "stop_igc" );
	plane UseBy( get_players()[0] );

//	wait( 3 );

//	origin = plane.origin;
//	angles = plane.angles;
//	speed = plane.speed;

//	plane Delete();

//	plane = spawn_plane( "player_corsair", origin + ( 0, 0, 400 ), angles );

//	plane ReturnPlayerControl();
}

// Start Event1
event1()
{
	maps\_status::show_task( "Event1" );

	// Spawn in the recon plane, if prematurely triggered too
	level thread event1_recon();

	// Tutorial on how to fly the plane along with the waypoints.
	level event1_tutorial();

	// Spawn in the recon plane
	if( flag( "spawn_event1_recon" ) )
	{
		level notify( "stop_event1_recon" );
		level event1_recon( true );
	}
}

// This handles the tutorial portion of event1
event1_tutorial()
{
	level endon( "stop_event1_tutorial" );

	level event1_tutorial_waypoints();
}

// Handles the "Fly from Waypoint to Waypoint" at the beginning.
event1_tutorial_waypoints()
{
	level endon( "stop_event1_tutorial" );

//	set_objective( 1 );
	struct = getstruct( "tutorial_waypoints", "targetname" );

	while( 1 )
	{
		trigger_waypoint( struct.origin );

		if( !IsDefined( struct.target ) )
		{
			break;
		}

		struct = getstruct( struct.target, "targetname" );
	}
}

// Spawns in the recon plane once the trigger is hit, or when the tutorial is done
event1_recon( after_tutorial )
{
	level endon( "stop_event1_recon" );

	trigger = GetEnt( "event1_recon", "targetname" );
	if( IsDefined( after_tutorial ) && after_tutorial )
	{
		trigger Delete();
	}
	else
	{
		trigger waittill( "trigger" );
		event1_stop_tutorial();
	}

	// Spawn the recon plane.
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
}

// Stops the tutorial prematurely, since a player did not want to do it.
event1_stop_tutorial()
{
	flag_clear( "spawn_event1_recon" ); // Used to determine to spawn the recon plane at the end of the tutorial or not.
	level notify( "stop_event1_tutorial" );
	level notify( "stop_trigger_waypoint" );
	level notify( "remove_waypoint" );
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
	maps\_player_corsair::set_target( self, "air_target", "air_target_offscreen" );
}

allies_plane_init()
{
	maps\_player_corsair::set_target( self, "air_friendly", "air_friendly_offscreen" );
}

spawn_player_plane()
{
}

spawn_plane( type, position, angles, t_name )
{
	model = undefined;
	if( type == "zero" )
	{
		model = "vehicle_jap_aircraft_zero";
	}
	else if( type == "player_corsair" )
	{
		health = 1000;
		model = "vehicle_usa_aircraft_f4ucorsair";
	}

	if( !IsDefined( t_name ) )
	{
		t_name = "switch_to_undefined";
	}

	plane = SpawnVehicle( model, t_name, type, position, angles );
	plane.vehicletype = type;
	plane.health = 1000;

	if( type == "zero" )
	{
	}
	else if( type == "player_corsair" )
	{
//		plane.wait_for_pilot = false;
		plane maps\_player_corsair::init_local();
	}

	if( t_name == "switch_to_undefined" )
	{
		plane.targetname = undefined;
	}

	return plane;
	
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

// Simply IPRINTLNBOLD, but using the localized strings.
print_hint( ref )
{
	IPrintlnBold( level.l_strings[ref] );
}

// Sets up a waypoint with a trigger radius around it.
trigger_waypoint( origin, radius, height )
{
	level endon( "stop_trigger_waypoint" );

	if( !IsDefined( radius ) )
	{
		radius = 5000;
	}

	if( !IsDefined( height ) )
	{
		height = 5000;
	}

	trigger = Spawn( "trigger_radius", origin - ( 0, 0, height * 0.5 ), 24, radius, height );

	waypoint_ent = maps\_player_corsair::set_waypoint( origin );

	// TEMP, till target_set works.
	temp_model = Spawn( "script_model", waypoint_ent.origin );
	temp_model Setmodel( "temp_larger" );
	temp_model thread draw_line_to_player();

	// This is mainly so we can have some other function interrupt the waypoint stuff.
	level thread remove_waypoint_think( waypoint_ent, trigger, temp_model );

	// Check to make sure the vehicle that hit the trigger is a Player.
	while( 1 )
	{
		trigger waittill( "trigger", other );

		if( IsPlayer( other GetVehicleOwner( other ) ) )
		{
			break;
		}
	}

	level notify( "remove_waypoint" );
}

// Waits until the next trigger_waypoint is trigger (or interrupted) then removes any entities.
remove_waypoint_think( waypoint_ent, trigger, temp_model )
{
	level waittill( "remove_waypoint" );

	waypoint_ent Delete();
	trigger Delete();

	// TEMP, till target_set works.
	temp_model Delete();

	level notify( "waypoint_reached" );
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
