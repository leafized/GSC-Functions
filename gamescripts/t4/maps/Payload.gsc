//
//	*******
//	Payload
//	*******
//	Gavin Niebel
//	Tony 'AmishThunder' Kramer
//	Alejandro 'Sparks' Romo

#include maps\_anim; 
#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\utility; 

#using_animtree( "generic_human" ); 

main()
{
	// Don't load script when compiling Reflections
	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return; 
	}

	// Co-op Callbacks
	level thread onFirstPlayerConnect(); 
	level thread onPlayerConnect(); 

	// Vehicles
	maps\_stuka::main( "vehicle_stuka_flying" ); 
	
	// All Precaching done in here
	// thread animscripts\dog_init::initDogAnimations(); 
	thread maps\_loadout::set_player_interactive_hands( "viewmodel_usa_marine_arms" ); 
	PrecacheStuff(); 

	maps\payload_fx::main(); 
	
	// _load
	maps\_load::main(); 

	// ZOMBIE MODE 
	level thread maps\payload_zombiemode::main(); 

	dvar_init(); 

	waittillframeend; 
	
	// Get the bad guys( we should make them into a prefab so easier to implement in different maps )
	level.Enemy_Spawns = getEntArray( "referenceSpawners", "targetname" ); 
	assertex( isdefined( level.Enemy_Spawns ), "The required Axis NPCs are not in the map." ); 
	
	level.Zombie_Spawns = getEntArray( "zombies", "targetname" ); 
	
	// Get our custom spawning system trigs
	level.Enemy_Triggers = getEntArray( "classSpawner", "targetname" ); 
	assertex( isdefined( level.Enemy_Triggers ), "There are no spawn triggers in the map." ); 
	array_thread( level.Enemy_Triggers, ::spawnTrigThink ); 
	
	// Get payload stuff
	//thread maps\_vehicle::scripted_spawn( 0 ); // Not using a vehicle anymore
	//waittillframeend; 
	level.payload = getEnt( "payload", "targetname" ); 
	level.payloadTrig = getEnt( "payload_trig", "targetname" ); 
	assertex( isDefined( level.payload ), "Payload does not exist." ); 
	assertex( isDefined( level.payloadTrig ), "Payload trigger_radius does not exist." ); 
	
	// Airborne dogs
	// dogsTrig(); 
	
	// Cow mortars
	cowTrigs(); 
	
	// Misc stuff
	level.npcCount = 0; 
	level.dogCount = 0; 
	level.payload_fx = "off"; // FX switch on payload
	level.ZombieMode = 0; // Turns off AI classes
	level.Zombie_Counter = 0; 
	level.zTimer = 0; // Zombie Timer round
	level.ZombiesKilled = 0; // Zombie death counter
	level.endGame = false; // Check for end game
	
	thread player_spawns(); 
	thread payload_think(); 
	
	wait_for_all_players(); 
	
	thread setup_objective(); 
	thread autoSaves(); 
	
	// Start the match
	//round_start(); 
}

////////////////////////////////////////////////
// Level Functions
////////////////////////////////////////////////

// Precache everything in here.
PrecacheStuff()
{
	
	// Strings
	precacheString( &"PAYLOAD_OBJECTIVE" ); 
	precacheString( &"PAYLOAD_TIMER" ); 
	precacheString( &"PAYLOAD_FAILED" ); 
	precacheString( &"PAYLOAD_MASTER" ); 
	
	// Shaders
	PrecacheShader( "hit_direction" ); 
	precacheShader( "compass_waypoint_capture" ); 
	precacheShader( "compass_waypoint_defend" ); 
	
	// Models
	precacheModel( "static_seelow_deadcow" ); 
	precacheModel( "static_seelow_deadcowb" ); 
	precacheModel( "clutter_okinawa_prchute_drpbox" ); 
	precacheModel( "static_seelow_tractor" ); 
	precacheModel( "skybox_mak1" ); 
	precachemodel( "char_ger_honorgd_zomb_behead" ); 
	precachemodel( "char_ger_zombieeye" ); 
	
	// Weapons            
	precacheItem( "molotov" );               
	precacheItem( "m2_flamethrower" );          
	precacheItem( "m1carbine" );                    
	precacheItem( "m1garand" );                 
	precacheItem( "ptrs41" );                   
	precacheItem( "kar98k_scoped" );            
	precacheItem( "shotgun" );                  
	precacheItem( "doublebarrel_sawed_grip" );  
	precacheItem( "doublebarrel" );             
	precacheItem( "gewehr43" );              
	precacheItem( "thompson" );                     
	precacheItem( "stg44" ); 
	precacheItem( "mp40" );         
	precacheItem( "mg42_bipod" );               
	precacheItem( "fg42_bipod" );               
	precacheItem( "bar" );             
	precacheItem( "kar98k" );                      
	precacheItem( "springfield" );               
	precacheItem( "colt" );                                 
	precacheItem( "panzerschrek" ); 	   
	precacheItem( "panzershark" ); 	   
	precacheItem( "walther" ); 
	precacheItem( "sw_357" ); 	
	precacheItem( "30cal_bipod" ); 
}

// Dvar stuff. Create, set, check, whatever you want in here.
dvar_init()
{
	
	// CoDWW Farm Mod Dvar
	setdvar( "payload_farmMod", 	"0" ); 
	
	// Max AI/ Dogs
	// Always make sure the two dvars add up to 32
	setdvar( "payload_maxAi", 	"28" ); 
	setdvar( "payload_maxDogs", 	"4" ); 
	
	// Seconds per match -- Perhaps make it dependent on AI skill?
	setdvar( "payload_timerSecs", 		"600" ); 
	
	// Pushing Points
	setdvar( "payload_pushPoints", 		"10" ); 
	setdvar( "payload_pushPointsSecs", 		"10" ); 
	
	// Kill Points
	setdvar( "payload_killPoints", 	"15" ); 

	// AI Attributes
	setdvar( "payload_attackerHealth", 		"125" ); 
	setdvar( "payload_defenderHealth", 	"100" ); 
	setdvar( "payload_kamikazeHealth", 				"80" ); 
	setdvar( "payload_stealerHealth", 	"175" ); 
}

// Secures a check point every so often via script.
autoSaves()
{
	level endon( "reached_end" ); 
	
	counter = 0; 
	min = 10; // Seconds
	max = 16; // Seconds
	
	while( 1 )
	{		
		wait( RandomIntRange( min , max ) ); 
	
		doSave = maps\_autosave::autosave_check_simple(); 
	
		if( doSave == true )
		{
			autosave_by_name( counter ); 
			counter++; 
		}
	}
}

// Anything pertaining to setting up/handling the payload should be managed from here.
payload_think()
{
	// Link collision to payload
	level.payload_col = getent( "payload_collision", "targetname" ); 
	level.payload_col linkto( level.payload ); 
		
	level.payload.hud = newHudElem(); 
	level.payload.hud.hideWhenInMenu = true; 
	level.payload.hud SetTargetEnt( level.payload ); 
	level.payload.hud setWayPoint( true, "compass_waypoint_capture" ); 
	
	level.payload thread payload_trig_update(); 
	//level.payload thread payload_speed(); // Not using a vehicle anymore
	level.payload thread payload_movement(); 
	//level.payload thread payload_clamp(); // Buggy, perhaps we can use a vehicle
}

// Can't do linkTo with a trigger, so lets just move it with the payload : )
payload_trig_update()
{
	self endon( "death" ); // Do we want the payload to be destroyable?
	
	while( 1 )
	{
		org1 = self getorigin(); 
		level.payloadTrig.origin = org1; 
		wait( 0.2 ); 
	}
}

// Handles the payload moving goal to goal
payload_movement()
{
	
	self endon( "death" ); // Do we want the payload to be destroyable?
	
	// Speed + Acceleration can't be 0 before assigning a Goal
	//self setspeed( 1, 1, 1 ); // Not using a vehicle anymore
	
	self.wayPoints = []; 	
	self.wayPoints = getGoals(); // Stores all the waypoint origins
	self.current_waypoint = 0; 
	
	self getMoving(); 
}

// This handles checking if players are near payload.
// By ChrisP. Modified by Sparks.
getMoving()
{
	level endon( "reached_end" ); 
	
	while( !any_player_isTouching( level.payloadTrig ) )
	{
		level.payload notify( "movedone" ); 
		
		self thread move_tractor( 1, self.origin ); 
		
		self notify( "payload_not_moving" ); // Turns off payload FX
		wait( 0.2 ); 
	}
	
	while( any_player_IsTouching( level.payloadTrig ) )
	{
		// Lets call up the FX first so player( s ) knows they at least came in contact
		if( level.payload_fx == "off" )
		{
			self thread payloadFxThink(); 
		}
			
		// Somebody is near Payload, get how many are near it
		speed = thread how_many_IsTouching( level.payloadTrig ); 	
		
		self thread move_tractor( speed ); 
		wait( 0.2 ); 
	}
	
	self thread getMoving(); 
}

// This just handles the actual moveto of the tractor, and will stop when notified.
// By ChrisP. Modified by Sparks.
move_tractor( speed, origin )
{
	level endon( "reached_end" ); 
	
	if( !isDefined( speed ) )
	{
		speed = 1; 
	}
	
	if( !isDefined( origin ) )
	{
		origin = self.wayPoints[self.current_waypoint]; 
	}
	
	if( !isDefined( self.ismoving ) )
	{
		self.ismoving = true; 
		deadZone = 16; // CoD Units		
		
		// Since we're not using a vehicle, getting the script_model to move faster with more
		// people became a bit more complex to implement. So I placed the script_struct waypoints
		// about 434 units apart from each other on the path that way there would always be
		// just about the same distance between points and we can play with the < time > for moveTo
		// and not worry about having the payload go way too fast between two waypoints with a small gap.
		
		baseSpeed = self thread baseSpeed_tweak(); 
		
		actualSpeed = baseSpeed + speed; 
		
		self moveto( origin , actualSpeed ); 
		
		// Lets check to see if it's within deadZone so it can start moving to next wayPoint
		if( DistanceSquared( self.origin, self.wayPoints[self.current_waypoint] ) < deadZone*deadZone )
		{
			self.current_waypoint++; 
			if( isDefined(self.wayPoints[self.current_waypoint]) )
			{
				angles = VectorToAngles( self.wayPoints[self.current_waypoint] - self.origin ); 
			     self RotateTo( angles +( 0, -90, 0 ), 1 ); 
			}
		}
		
		if( !isDefined( self.wayPoints[self.current_waypoint] ) )
		{
			autosave_by_name( "Zombies" ); 
			wait( .8 ); 
			thread ZombInit(); 
			
			// Payload made it to the end!!!
			level notify( "we_win" ); 
			level notify( "reached_end" ); 
		}
		
		self.ismoving = undefined; 
	}
}

// This just tweaks the moveTo speed based on distance from payload to next point.
baseSpeed_tweak()
{
	distance = Distance( self.origin, self.wayPoints[self.current_waypoint] ); 
	
	if( distance > 375 )
	{
		return 2.5; 
	}

	if( distance > 300 )
	{
		return 2; 
	}

	if( distance > 200 )
	{
		return 1.75; 
	}
	else if( distance > 50 )
	{
		return 1; 
	}
	else if( distance > 25 )
	{
		return .6; 
	}
	else
	{
		return .7; 
	}
}

// Created after we switched to using a script_model. Doesn't well though. :( 
// Will probably be commented out.
payload_clamp()
{
	self endon( "death" ); 

	while( 1 )
	{
		trace = bulletTrace( self.origin +( 0, 0, 10 ), self.origin +( 0, 0, -100 ), false, self ); 

		self.origin = ( trace["position"] ); 
		self.currentsurface = trace["surfacetype"]; 
			
		if( self.currentsurface == "none" )
		{
			self.currentsurface = "default"; 
		}

		wait( 0.05 ); 
	}
}

// Gets all the script_structs for the payload and builds a path.
getGoals()
{	
	wayPoints = []; 
	
	// Get the first point
	Point = getStruct( "firstPoint", "targetname" ); 
	assert( isDefined( Point ), "There is no first point for Payload path." ); 
	
	// Set up path for Payload
	while( isdefined( Point ) )
	{
		wayPoints[wayPoints.size] = Point.origin; 
		
		if( isdefined( Point.target ) )
		{
			Point = getStruct( Point.target, "targetname" ); 
		}
		else // No next point
		{
			break; 
		}
		
	}

	return wayPoints; 
}

get( value )
{	
	return getEnt( value, "targetname" ); 
}

// Dependent upon how many players( non-NPC ) are near the Payload
// Or do we want NPCs to push back?
payload_speed()
{
	self endon( "death" ); // Do we want payload to be destroyable?
	self endon( "reached_end" ); // Finished path, stop moving
	
	while( 1 )
	{
		can_move = false; 
		players = get_players(); 
		
		for( i = 0; i < players.size; i++ )
		{
			if( any_player_IsTouching( level.payloadTrig ) )
			{
				can_move = true; 
			}
		}
		
		if( can_move == true )
		{
			// Lets call up the FX first so player( s ) knows they at least came in contact
			if( level.payload_fx == "off" )
			{
				self thread payloadFxThink(); 
			}
			
			// Somebody is near Payload, get how many are near it
			count = how_many_IsTouching( level.payloadTrig ); 
			
			if( count == 0 ) // Fail safe incase someone has ninja moving skills between can_move check and how_many_isTouching check
			{
				self setspeed( 0, 3, 5 ); 
				self notify( "payload_not_moving" ); // Turns off payload FX
			}
			else if( count == 1 )
			{
				self setspeed( 2, 3, 5 ); 
			}
			else if( count == 2 )
			{
				self setspeed( 3, 4, 5 ); 
			}
			else if( count == 3 )
			{
				self setspeed( 4, 5, 5 ); 
			}
			else // count == 4
			{
				self setspeed( 5, 5, 5 ); 
			}
		}
		else // can_move == false
		{
			// No one is near Payload
			self setspeed( 0, 3, 5 ); 
			self notify( "payload_not_moving" ); // Turns off payload FX
		}	
			
		wait( 0.3 ); 
	}
}

// Spawns an FX on the Payload so players know they're moving it
// Do we want to have different visual FXs for how many people are moving it?
payloadFxThink()
{
	level.payload_fx = "on"; 
	
	level.payload.hud destroy(); 
	level.payload.hud = newHudElem(); 
	level.payload.hud.hideWhenInMenu = true; 
	level.payload.hud SetTargetEnt( level.payload ); 
	level.payload.hud setWayPoint( true, "compass_waypoint_defend" ); 
	
	self waittill( "payload_not_moving" ); 

	level.payload.hud destroy(); 
	level.payload.hud = newHudElem(); 
	level.payload.hud.hideWhenInMenu = true; 
	level.payload.hud SetTargetEnt( level.payload ); 
	level.payload.hud setWayPoint( true, "compass_waypoint_capture" ); 

	level.payload_fx = "off"; 
}

// Returns how many people are moving the Payload
how_many_IsTouching( ent )
{
	players = get_players(); 
	count = 0; 

	for( i = 0; i < players.size; i++ )
	{
		if( IsAlive( players[i] ) && players[i] IsTouching( ent ) )
		{
			weapon = players[i] GetCurrentWeapon(); 
			
			// Players get more ammo for pushing the payload
			if( isDefined( weapon ) &&( weapon != "none" ) )
			{
				players[i] GiveMaxAmmo( weapon ); 
			}
			
			count++; 
		}
	}

	return count; 
}

// Return closest node from array.
get_closest_node( org, nodes )
{
	return getClosest( org, nodes ); 
}

// Just displays an objective for the players incase they're lost.
setup_objective()
{
	objective_add( 1, "active", &"PAYLOAD_OBJECTIVE" ); 
	objective_current( 1 ); 
	
	level waittill( "we_win" ); 
	
	objective_state( 1, "done" ); 
}

////////////////////////////////////////////////
// Zombies
////////////////////////////////////////////////
ZombInit()
{
	// Just a safe re-notify
	level notify( "reached_end" ); 
	
	// Don't let any remaining enemies spawn
	array_thread( level.Enemy_Triggers, ::trigger_off ); 
	
	// Kill any remaining enemies
	ai = GetAIArray( "axis" ); 
	array_thread( ai, ::self_delete ); 
	
	masterHud = newHudElem(); 
	masterHud.alpha = 1; 
	masterHud.hidewheninmenu = true; 
	masterHud.horzAlign = "center"; 
	masterHud.vertAlign = "middle"; 
	masterHud.alignX = "center"; 
	masterHud.alignY = "middle"; 
	masterHud.x = 0; 
	masterHud.y = -60; 
	masterHud.font = "big"; 
	masterHud.fontscale = 2.0; 
	masterHud.color = ( 1, 1, 0.5 ); 
	masterHud setText( &"PAYLOAD_MASTER" ); 
	
	level.ZombieMode = 1; 

	players = get_players(); 
	for( x = 0; x < players.size ; x++ )
	{
		players[x] setExpFog( 50, 256, 0, 0, 0, 0 ); 
		players[x] VisionSetNaked( "mak", 2.0 ); 
		players[x] playSound( "laugh" ); 
		players[x] playLoopSound( "bg_zombie_madness" ); 
		players[x] thread watchDuringZombie(); 
	}
		
	// Make spawners into Zombie
	array_thread( level.Zombie_Spawns, ::add_spawn_function, maps\payload_zombiemode_spawner::zombie_spawn_init );
	
	// How much time players have
	thread zombTimer(); 
	
	// Spawn loot of Zombies by barn
	thread BarnSpawn(); 
	
	masterHud destroy(); 
}

watchDuringZombie()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 
	
	while( 1 )
	{
		self waittill( "damage" ); 
		
		if( self maps\_laststand::player_is_in_laststand() )
		{
			// lol @ player
			self 	playSound( "laugh" ); 
			
			// Don't want to spam the laugh while they're in the same last stand
			while( self maps\_laststand::player_is_in_laststand() )
			{
				wait( 1 ); 
			}
		}
			
		wait( .4 ); 
	}
}

zombTimer()
{
	players = get_players(); 
	
	// Tweak how many seconds per player
	if( players.size == 0 )
	{
		level.zTimer = 100; 
	}
	if( players.size == 1 )
	{
		level.zTimer = 90; 
	}
	if( players.size == 2 )
	{
		level.zTimer = 80; 
	}
	else
	{
		level.zTimer = 60; 
	}
		
	level.timer = maps\_hud_util::get_countdown_hud(); 
	level.timer.label = &"PAYLOAD_TIMER"; 
	level.timer settenthstimer( level.zTimer ); 
	level.start_time = gettime(); 
	
	// Wait for timer
	wait( level.zTimer ); 
	// Timer out!
	
	if( level.ZombiesKilled >= 30 )
	{
		iPrintLnBold( "TEMP: YOU WIN!" ); 
		level.endGame = true; 
		
		wait( 2 ); 
		
		nextmission(); 
	}
	else
	{
		setDvar( "ui_deadquote", &"PAYLOAD_FAILED" ); 
		maps\_utility::missionFailedWrapper(); 	
	}
}

BarnSpawn()
{
	ai = undefined; 
	rand = undefined; 
	eSpawned = undefined; 
	zombsToSpawn = 30; // We can push 32 but lets just be safe : )
	
	while( level.endGame != true )
	{
		while( level.Zombie_Counter < zombsToSpawn )
		{
			rand = RandomInt( level.Zombie_Spawns.size ); 
			
			level.Zombie_Spawns[rand].count = 999; 
			eSpawned = level.Zombie_Spawns[rand] StalingradSpawn(); 
			
			if( spawn_failed( eSpawned ) )
			{
			}
			else
			{
					level.Zombie_Counter++; 
			}
			
			wait( 0.1 ); 
		}
		
		wait( .1 ); 
	}
}

////////////////////////////////////////////////
// Cow Mortars
////////////////////////////////////////////////

// Handles and checks triggers for when to drop cows.
cowTrigs()
{
	array_thread( getEntArray( "cow_drop", "targetname" ), :: cowThink ); 
}

// Handles user triggering for cows.
cowThink()
{
	xmodels = []; 
	xmodels[xmodels.size] = "static_seelow_deadcow"; 
	xmodels[xmodels.size] = "static_seelow_deadcowb"; 
	
	while( 1 )
	{
		self waittill( "trigger" ); 
		
		spawnLocs = getStructArray( self.target, "targetname" ); 
		// TODO: Assert
		
		howManyToSpawn = RandomIntRange( 2, spawnLocs.size ); 
		
		newSpawnLocs = array_randomize( spawnLocs ); 
		
		for( x = 0 ; x < howManyToSpawn ; x++ )
		{
			
			tSpawned = spawn( "script_model", newSpawnLocs[x].origin ); 
			tSpawned setModel( xmodels[RandomInt( xmodels.size )] ); 
			tSpawned RotatePitch( -180, 0.01 ); 
			
			thread fallCow( tSpawned, newSpawnLocs[x] ); 
			
			wait( RandomFloatRange( 0.8, 1.4 ) ); 
		}
		
		wait( RandomIntRange( 4, 10 ) ); 
	}
}

// Drops the cows. Perhaps we can just use BulletTrace later?
fallCow( cow, start )
{
	tTarget = getStruct( start.target, "targetname" ); 
	cow MoveTo( tTarget.origin, RandomIntRange( 1, 3 ), RandomFloatRange( .03, .7 ) , .01 ); 
	
	cow waittill( "movedone" ); 
	
	playfx( level._effect["cow_milk"], cow.origin, ( 1, 0, 0 ) ); 
	thread dropletCheck( cow.origin ); 
	
	cow delete(); 
}

// Checks for player collision with milk splash and plays overlay.
dropletCheck( cowOrigin )
{
	players = get_players(); 
	for( x = 0 ; x < players.size ; x++ )
	{
		if( ( DistanceSquared( players[x].origin, cowOrigin ) < 220*220 ) )
		{
			thread do_milk_drops_on_camera_for_time( RandomIntRange( 5, 10 ), players[x] ); 
		}
	}
}

////////////////////////////////////////////////
// Airborne Dogs
////////////////////////////////////////////////

// Handles and checks triggers for when to drop dogs.
dogsTrig()
{
	array_thread( getEntArray( "dog_drop", "targetname" ), ::dogChuteThink ); 
	thread setup_supply_drop_anims(); 
}

// Handles user triggering for dogs.
dogChuteThink()
{
	level endon( "reached_end" ); 
	
	while( 1 )
	{
		self waittill( "trigger" ); 
		
		thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 1 ); 
		// TODO: Assert
		waittillframeend; 
		
		dog = getEnt( "airborne_dog", "targetname" ); 
		plane = getEnt( "dogPlane", "targetname" ); 
	
		thread spawnerMove( dog, plane ); 
		
		// TODO: Modulate which paths plane can use so map only needs 1 plane for all different paths.
		//plane thread maps\_vehicle::goPath(); 
		
		skyTrig = getent( self.script_linkto, "script_linkname" ); 
		// TODO: Assert
		
		// Plane reaches drop point
		skyTrig waittill( "trigger" ); 
		
		skyTrig thread parachuteAway( dog, self ); 
		
		plane waittill( "reached_end_node" ); 
		plane delete(); 
	
		wait( RandomIntRange( 10, 15 ) ); 
	}
}

// Moves the dog spawner with the plane.
spawnerMove( dog, plane )
{
	while( isDefined( plane ) ) // Should probably use a flag
	{
		dog.origin = plane.origin; 
		wait( 0.3 ); 
	}
}

// Spawn a dog.
parachuteAway( dog, trig )
{
	canSpawn = calculateDogs(); 
	
	for( x = 0 ; x < canSpawn ; x++ )
	{
		dSpawned = dog StalingradSpawn(); 
		
		if( spawn_failed( dSpawned ) )
		{
			continue; 
		}
		
		level.dogCount++; 
		dSpawned thread dogDeathDevent(); 
		dSpawned thread parachuteThink(); 
		
		wait( RandomFloat( 2.0 ) ); 
	}
}

// Lower dog limiter when dog dies.
dogDeathDevent()
{
	self waittill( "death" ); 
	level.dogCount--; 
}

#using_animtree( "supply_drop" ); 
// Handles how the dog parachutes down.
parachuteThink( goal )
{
	self.landedEarly = false; 
	self thread magic_bullet_shield(); 
	
	harness = spawn( "script_model", self.origin ); 
	harness setModel( "clutter_okinawa_prchute_drpbox" ); 
	harness.animName = "drop1"; 
	harness useanimtree( #animtree ); 
	
	anchor = spawn( "script_origin", harness.origin ); 
	harness linkto( self ); 
	
	self linkTo( anchor ); 
	
	if( randomint( 100 ) > 50 )
	{
		str = "landing"; 
	}
	else
	{
		str = "landingb"; 
	}
	
	trace = bulletTrace( self.origin +( 0, 0, 0 ), self.origin +( 0, 0, -10000 ), false, self ); 
	dropLocation = ( trace["position"] ); 
	dropLocation += ( 0, 0, 8 ); 
	
	anchor MoveTo( dropLocation, randomintrange( 4, 6 ) ); 	
	harness thread DogVibrate(); 
	self thread checkLanded( anchor ); 
	
	self DogSplat( anchor, harness ); 
	
	harness notify( "movedone" ); 
	
	if( isAlive( self ) && isDefined( self ) )
	{
		self thread attackPlayers(); 
	}
		
	if( self.landedEarly == false )
	{
		harness thread anim_single_solo( harness, str ); 
		harness waittill( "single anim" ); 
	}
	else
	{
		RadiusDamage( self.origin, 100, self.health + 1000, self.health + 10 ); 
	}
	
	harness delete(); 
	anchor delete(); 
}

// Parachute notifies dog when landed.
checkLanded( anchor )
{
	anchor waittill( "movedone" );	
	self notify( "landed" ); 
}

// Splat. Enough said.
DogSplat( anchor, harness )
{
	self waittill_any( "damage", "landed" ); 
	
	self unLink(); 
	harness unLink(); 
	
	trace = bulletTrace( self.origin +( 0, 0, 0 ), self.origin +( 0, 0, -10000 ), false, self ); 
	fallLocation = ( trace["position"] ); 
	
	if( ( DistanceSquared( self.origin, fallLocation ) > 10*10 ) )
	{
		self.landedEarly = true; 
		
		freeFall = spawn( "script_origin", self.origin ); 
		self linkTo( freeFall ); 
		
		harness hide(); 
		
		freeFall moveto( fallLocation, 0.8 ); 
		freeFall waittill( "movedone" ); 
		
		playfx( level._effect["dog_splat"], freeFall.origin, ( 1, 0, 0 ) ); 
		
		self thread stop_magic_bullet_shield(); 
		
		freeFall delete(); 
	}
	else
	{
		self thread stop_magic_bullet_shield(); 
	}
	
	anchor notify( "movedone" ); 
}

#using_animtree( "supply_drop" ); 
// Originally was just shaking the dog, but now using animations for chute.
DogVibrate()
{
	self.animname = "drop1"; 
	self useanimtree( #animtree ); 
	
	self endon( "movedone" ); 
	
	while( 1 )
	{
		self anim_single_solo( self, "drop" ); 
		self waittill( "single anim" ); 
	}
	
}

// Checks how many Dogs can be spawned in when triggered
calculateDogs()
{
	min = 1; // Always try to spawn at least # 
	max = GetDvarInt( "payload_maxDogs" ); // AI allowed per map
	allocationFree = max - level.dogCount; 
	
	if( allocationFree == 0 ) // No room
	{
		return 0; 
	}
	else if( allocationFree > max ) // Enough for max spawn
	{
		return( RandomIntRange( min, max ) ); 
	}
	else // Already dogs spawned
	{
		return( RandomIntRange( min, allocationFree ) ); 
	}
		
	return min; 
}

////////////////////////////////////////////////
// AI Classes And Logic
////////////////////////////////////////////////

chooseClass( howManyCanSpawn, eLocos )
{
	
	// Defender : Will hold their ground.
	// Attacker : Will charge players.
	// Stealer  : Will try to stop Payload.
	// Kamikaze : Blow up on death.
	
	// Add classes here
	// You can stress/bug test a class by commenting out the rest
	eClasses = []; 
	eClasses[eClasses.size] = "Defender"; 
	eClasses[eClasses.size] = "Attacker"; 
	eClasses[eClasses.size] = "Stealer"; 
	eClasses[eClasses.size] = "Kamikaze"; 
		
	// Cycle and choose what classes are going to spawn
	// Then spawn.
	for( x = 0 ; x < howManyCanSpawn ; x++ )
	{
		eSpawner = undefined; 
		
		tempClass = array_randomize( eClasses ); 
		classToSpawn = tempClass[RandomInt( tempClass.size )]; 
		
		guyWeapon = thread weaponClassThink( classToSpawn ); 
				
		thread moveSpawners( eLocos[x] );

		switch( guyWeapon )
		{
			case "ptrs41":
			case "kar98k":
			case "kar98k_scoped":
			case "gewehr43":
			case "shotgun":
			case "doublebarrel_sawed_grip":
			case "doublebarrel":
				eSpawner = findSpawnerScript( "rifle" );
				break;

			case "m2_flamethrower":
				eSpawner = findSpawnerScript( "flame" );
				break;

			case "mg42_bipod":
			case "fg42_bipod":
			case "30cal_bipod":
				eSpawner = findSpawnerScript( "portable" );
				break;

			case "panzerschrek":
			case "panzershark":
				eSpawner = findSpawnerScript( "bazooka" );
				break;

			case "stg44":
			case "mp40":
				eSpawner = findSpawnerScript( "smg" ); 
				break;

			default:
				eSpawner = findSpawnerScript( "rifle" );
				break;
		}

		wait( 0.3 ); 
		eSpawned = eSpawner doSpawn(); 
		if( spawn_failed( eSpawned ) )
		{
			// empty check
		}
		else
		{
			eSpawned thread spawnEvent( classToSpawn, guyWeapon ); 				
			eSpawned thread flyingBodies(); 
		}
	}
	
	thread resetSpawners(); // Return those spawners back to original location until next time
	
	//level notify( "spawners_ready" ); 
}

flyingBodies()
{
	/* Notes:
		Handles how all the AI go flying when you kill them.
	*/
	
	level endon( "reached_end" ); 
	
	self waittill( "death", player ); 
	origin = self.origin; 
	
	explosionPos = origin +( 0, 0, 24 ); 
	explosionPos -= ( 0, 0, 0 ) * 20; 
	explosionRadius = 70; 
	explosionForce = 4; 

	if( IsPlayer( player ) )
	{
		// Humor Mod Merge -- This isn't working yet.
		//temp = spawn( "script_struct", origin ); 
		//player.kill = newClientHudElem(); 
		//player.kill.hideWhenInMenu = true; 
		//player.kill SetTargetEnt( temp ); 
		//player.kill setShader( "compass_waypoint_capture" ); 
		
		if( ( player GetCurrentWeapon() ) != "m2_flamethrower" ) // Letting burning guys burn
		{
			self startragdoll( 1 ); 
			wait( .05 ); 
			physicsExplosionSphere( explosionPos, explosionRadius, explosionRadius/1.2, explosionForce ); 
			
			// Do a second send off incase the first one was too early.
			wait( .04 ); 			
			physicsExplosionSphere( explosionPos, explosionRadius, explosionRadius/1.5, explosionForce/1.3 ); 
		}
		
		//player.kill fadeovertime( 1.3 ); 
		wait( 1.3 ); 
		//player.kill destroy(); 
		//temp delete(); 
	}
}

// Trys to find the best possible actor for a specific gun.
// That way an actor with flame thrower anims isn't trying
// to fire a bazooka for example.
findSpawnerScript( eNoteWorthy )
{
	spawner = undefined; 
	
	for( x = 0 ; x < level.Enemy_Spawns.size ; x++ )
	{
		if( level.Enemy_Spawns[x].script_noteworthy == eNoteWorthy )
		{
			spawner = level.Enemy_Spawns[x]; 
			continue; 
		}
	}
	
	return spawner; 
}

// Main logic for how the enemy team plays against players.
npcClassInit( classToSpawn, weapon )
{
	assert( isDefined( classToSpawn ), "Enemy does not have an assigned class at: " + self.origin ); 
	
	// Class stuff
	switch( classToSpawn )
	{
		case "Defender":
			self PushPlayer( true ); 
			self enable_pain(); 
			self.goalradius = 1024; 
			self.maxhealth = GetDvarInt( "payload_defenderHealth" ) + 10; 
			self thread getToPlayers(); 
			break; 
		case "Attacker":
			self PushPlayer( true ); 
			self disable_pain(); 
			self.goalradius = 512; 
			self.maxhealth = GetDvarInt( "payload_attackerHealth" ) + 10; 
			self thread getToPlayers(); 
			break; 
		case "Stealer":
			self PushPlayer( true ); 
			self enable_pain(); 
			self.goalradius = 256; 
			self set_force_cover( "none" ); 
			self.maxhealth = GetDvarInt( "payload_stealerHealth" ) + 10; 
			self thread getToCart(); 
			break; 
		case "Kamikaze":
			self PushPlayer( true ); 
			self disable_pain(); 
			self.goalradius = 75; 
			self set_force_cover( "none" ); 
			self.maxhealth = GetDvarInt( "payload_kamikazeHealth" ) + 10; 
			//self thread getToPlayers(); 
			break; 
	}
	
	// Weapon stuff
	switch( weapon )
	{
		case "ptrs41":
		case "kar98k":
		case "kar98k_scoped":
		case "gewehr43":
		case "shotgun":
		case "doublebarrel_sawed_grip":
		case "doublebarrel":
			// Rifles & Shotguns
			self set_npc_weapon( weapon ); 
			break;

		case "m2_flamethrower":
			// Flamethrower
			self set_npc_weapon( weapon ); 
			self.baseaccuracy = 0.05; 
			self.a.flamethrowerShootTime_min = 10000; 
			self.a.flamethrowerShootTime_max = 15000; 
			self.a.flamethrowerShootDelay_min = 0; 
			self.a.flamethrowerShootDelay_max = 1;
			break;

		case "mg42_bipod":
		case "fg42_bipod":
		case "30cal_bipod":
			self set_npc_weapon( weapon ); 
			break;
		case "panzerschrek":
		case "panzershark":
			// Bazooka
			self.grenadeAmmo = 5; 
			//self.dropweapon = false; 
			self set_npc_weapon( weapon ); 
			self.a.no_weapon_switch = true; // They will stick to just using bazookas
			break;

		case "stg44":
		case "mp40":
			// SMGs
			self set_npc_weapon( weapon ); 
			break;
	}
	
	// Need to call this whenever we switch weapons on the fly, 
	// else errors/warnings/bugs galore.
	if( weapon != "m2_flamethrower" ) // Flame thrower guys start with flame throwers, skip the
	{
		self animscripts\init::initWeapon( weapon, "primary" ); 
	}
}

set_npc_weapon( weapon )
{
	self.primaryweapon = weapon;
	self animscripts\init::initWeapon( weapon, "primary" );
	self gun_switchto( weapon, "right" );
}

// Assigns a gun to an enemy dependent upon their class.
weaponClassThink( class )
{
	weaponList = []; 
	weapon = ""; 
	
	switch( class )
	{
		case "Defender":
			weaponList[weaponList.size] = "30cal_bipod"; 
			weaponList[weaponList.size] = "gewehr43"; 
			weaponList[weaponList.size] = "panzershark"; 
			break; 
		case "Attacker":
			weaponList[weaponList.size] = "stg44"; 
			weaponList[weaponList.size] = "gewehr43"; 
			weaponList[weaponList.size] = "doublebarrel_sawed_grip"; 
			weaponList[weaponList.size] = "doublebarrel"; 
			weaponList[weaponList.size] = "shotgun"; 
			break; 
		case "Stealer":
			weaponList[weaponList.size] = "m2_flamethrower"; 
			break; 
		case "Kamikaze":
			weaponList[weaponList.size] = "panzershark"; 
			break; 
		default:
			weaponList[weaponList.size] = "gewehr43"; 
			break; 
	}	
	
	if( weaponList.size > 1 )
	{
		tWeaponList = array_randomize( weaponList ); 
		weapon = tWeaponList[RandomInt( tWeaponList.size )]; 
		return weapon; 
	}
	else
	{
		return weaponList[0]; 
	}
}

// Do anything here we want to happen/check when AI spawn.
spawnEvent( classToSpawn, weapon )
{
	level.npcCount++; 
	self thread npcClassInit( classToSpawn, weapon ); 
	
	self waittill( "death", player ); 

	// Do anything here we want to happen/check when AI die.
	
	if( isDefined( player ) && isPlayer( player ) && isAlive( player ) )
	{
		if( player GetCurrentWeapon() == "m2_flamethrower" )
		{
			RadiusDamage( self.origin, 200, 20, 5 ); 
			playfx( level._effect["kamikaze_boom"], self.origin, ( 1, 0, 0 ) ); 
		}
	}
	
	self.grenadeAmmo = 0; 		
	level.npcCount--; 
}

// Handles user triggering for spawners
spawnTrigThink()
{
	level endon( "reached_end" ); 
	
	while( 1 )
	{
		self waittill( "trigger" ); 
		
		eLocos = getStructArray( self.target, "targetname" ); 
		
		if( !isDefined( eLocos ) )
		{
			continue; // No where to spawn :( 
		}
		
		howManyToSpawn = eLocos.size; 
		howManyCanSpawn = allocationFree( howManyToSpawn ); 
		
		if( !isDefined( howManyCanSpawn ) || howManyCanSpawn <= 0 )
		{
			continue; 
		}
		
		// Fail safe incase we go into Zombie mode
		if( !level.ZombieMode )
		{
			chooseClass( howManyCanSpawn, eLocos ); 
		}
		
		wait( RandomIntRange( 4, 10 ) ); 
	}
}

allocationFree( howManyToSpawn )
{
	/* Notes:
		Checks how many AI can be spawned in when triggered
	*/
	
	min = 2; // Always try to spawn at least # 
	max = GetDvarInt( "payload_maxAi" ); // AI allowed per map
	allocationFree = max - level.npcCount; 
	
	if( allocationFree == 0 ) // No room
	{
		return 0; 
	}
	else if( allocationFree > howManyToSpawn ) // More than enough spawn locos
	{
		if( min >= howManyToSpawn )
		{
			return min; 
		}
		
		return( RandomIntRange( min, howManyToSpawn ) ); 
	}
	else // Enough room for each spawn loco
	{
		if( min >= allocationFree )
		{
			return min; 
		}
		
		return( RandomIntRange( min, allocationFree ) ); 
	}
}

// Moves all the spawners to the same location to location.
// findSpawnerScript() chooses which actor to spawn from then moves them.
// It won't/shouldn't telefrag since Spawners are only visual references. ; )
moveSpawners( eLoc )
{
	for( x = 0 ; x < level.Enemy_Spawns.size ; x++ )
	{
		level.Enemy_Spawns[x].origin = eLoc.origin; 
	}
}

// Takes the spawners back to their original location.
// Not really necessary but hey, might as well know where
// our spawners are at when not creating AI.
resetSpawners()
{
	for( x = 0 ; x < level.Enemy_Spawns.size ; x++ )
	{
		tLoc = getEnt( level.Enemy_Spawns[x].target, "targetname" ); 
		level.Enemy_Spawns[x].origin = tLoc getorigin(); 
	}
}

// Reset a single spawner back to its original location.
resetSpawner()
{
	
	tLoc = getEnt( self.target, "targetname" ); 
	self.origin = tLoc getorigin(); 
}

////////////////////////////////////////////////
// AI House Keeping
////////////////////////////////////////////////

// Makes a guy fire at the players.
fireAtPlayers()
{
	self endon( "death" ); 
	
	while( 1 )
	{
		temp = get_players(); 
		mixMeUp = array_randomize( temp ); 
		player = mixMeUp[RandomInt( mixMeUp.size )]; 
		self.goal = player; 
		self thread timeout( RandomIntRange( 4, 6 ) ); 
		
		self waittill_any( "damage", "timeout" ); 
		
		wait( 1 ); 
	}
}

// Makes a dog go straight for players.
// Woof! >: )
attackPlayers()
{
	self endon( "death" ); 
	
	while( 1 )
	{
		temp = get_players(); 
		mixMeUp = array_randomize( temp ); 
		player = mixMeUp[RandomInt( mixMeUp.size )]; 
		self SetGoalPos( player.origin ); 
		self.team = "axis"; 
		self thread timeout( RandomIntRange( 3, 4 ) ); 
		
		self waittill_any( "damage", "timeout" ); 
		
		wait( 1  ); 
	}
}

// Makes an AI go straight for players.
// Watch out! : )
getToPlayers()
{
	self endon( "death" ); 
	
	while( 1 )
	{
		temp = get_players(); 
		players = array_randomize( temp ); 
		self SetGoalPos( players[RandomInt( players.size )] getOrigin() ); 
		self thread timeout( RandomIntRange( 2, 5 ) ); 
		
		self waittill_any( "goal", "damage", "timeout" ); 
		
		wait( 1 ); 
	}
}

// Makes an AI go straight for the payload.
getToCart()
{
	
	self endon( "death" ); 
	
	self SetGoalPos( level.payload getOrigin() ); 
	self waittill( "goal" ); 
	
	while( 1 )
	{
		self SetGoalPos( level.payload getOrigin() ); 
		
		self waittill_any( "goal" ); 
		
		wait( RandomInt( 5 )  ); 
	}
}

// Disable all spawners for xyz reason.
disableSpawners()
{	
	for( x = 0 ; x < level.Enemy_Spawns.size ; x++ )
	{
		level.Enemy_Spawns[x].count = 0; 
	}
}

// Disable a spawner for xyz reason.
disableSpawner()
{	
	self.count = 0; 
}

// Enable all spawners for xyz reason.
enableSpawners()
{
	for( x = 0 ; x < level.Enemy_Spawns.size ; x++ )
	{
		level.Enemy_Spawns[x].count = 9999999; 
	}
}

// Enable a spawner for xyz reason.
enableSpawner()
{	
	self.count = 9999999; 
}

////////////////////////////////////////////////
// Co-Op Callbacks
////////////////////////////////////////////////

onFirstPlayerConnect()
{
	level waittill( "connecting_first_player", player ); 
	
	// put any calls here that you want to happen when the FIRST player connects to the game
	println( "First player connected to game." ); 
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 

		player thread onPlayerDisconnect(); 
		player thread onPlayerSpawned(); 
		player thread onPlayerKilled(); 
	
		// put any calls here that you want to happen when the player connects to the game
		println( "Player connected to game." ); 
		
		player.score = 0;
		
		// Dvars
		player setClientDvars( "ragdoll_explode_force", 30000, 
							 "jump_height", 110, 
							 "jump_slowdownEnable", 0, 
							 "player_sprintUnlimited", 1, 
							 "player_clipSizeMultiplier", 1.0, 
							 "phys_gravity", -400, 
							 "ragdoll_bullet_force", 500, 
							 "ragdoll_explode_upbias", 0.7, 
							 "bg_fallDamageMinHeight", 256, 
							 "bg_fallDamageMaxHeight", 512 ); 
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" ); 
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println( "Player disconnected from the game." ); 
}

onPlayerSpawned()
{
	self endon( "disconnect" ); 	
	
	for( ;; )
	{
		self waittill( "spawned_player" ); 
		
		wait( 0.4 ); 
		
		self takeallweapons(); 
		
		self thread onPlayerSpawned_ChooseClass(); 
		
		self thread maps\_loadout::set_laststand_pistol( "colt" ); 
	}
}

onPlayerSpawned_ChooseClass()
{
	class = RandomInt( 2 ); 
	
	switch( class )
	{
		case 0:
			// MG guy
			self GiveWeapon( "fg42_bipod" ); 
			self GiveMaxAmmo( "fg42_bipod" ); 
			self GiveWeapon( "mg42_bipod" ); 
			self GiveMaxAmmo( "mg42_bipod" ); 
			self GiveWeapon( "30cal_bipod" ); 
			self GiveMaxAmmo( "30cal_bipod" ); 
			
			self GiveWeapon( "fraggrenade" ); 
			
			self SwitchToWeapon( "fg42_bipod" ); 
			break; 
			
		case 1:
			// Explosives guy
			self GiveWeapon( "colt_dirty_harry" ); 
			self GiveWeapon( "m2_flamethrower" ); 
			self GiveWeapon( "fraggrenade" ); 
			self GiveWeapon( "molotov" ); 
			
			self GiveWeapon( "panzershark" ); 
			self GiveMaxAmmo( "panzershark" ); 
			
			self SwitchToWeapon( "colt_dirty_harry" ); 
			break; 
			
		case 2:
			// Maximum damage guy
			self GiveWeapon( "doublebarrel_sawed_grip" ); 
			self GiveMaxAmmo( "doublebarrel_sawed_grip" ); 
			self GiveWeapon( "doublebarrel" ); 
			self GiveMaxAmmo( "doublebarrel" ); 
			self GiveWeapon( "shotgun" ); 
			self GiveMaxAmmo( "shotgun" ); 			
			
			self GiveWeapon( "fraggrenade" ); 
			
			self SwitchToWeapon( "doublebarrel_sawed_grip" ); 
			break; 
	}
}

onPlayerKilled()
{
	self endon( "disconnect" ); 
	
	for( ;; )
	{
		self waittill( "killed_player" ); 

		// put any calls here that you want to happen when the player gets killed
		//println( "Player killed at " + self.origin ); 
		
	}
}

////////////////////////////////////////////////
// Co-Op House Keeping
////////////////////////////////////////////////

player_spawns()
{
	/* Notes:
		At the start of the map place players at spots.
		Otherwise they'll spawn inside each other.
	*/
	
	structs = getStructArray( "player_spawn", "targetname" ); 
	
	flag_wait( "all_players_connected" ); 
	
	players = get_players(); 
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( structs[i].origin ); 
		players[i] setplayerangles( structs[i].angles ); 
	}
}

do_milk_drops_on_camera_for_time( wait_time, player )
{
	/* Notes:
		If a player gets hit with milk.
			From Pel2. Modified by Sparks.
	*/
	
	players_water_drops_on( player ); 
	
	wait( wait_time ); 
	
	players_water_drops_off( player ); 
}

players_water_drops_on( player )
{
	player setwaterdrops( 300 ); 
}

players_water_drops_off( player )
{
	player setwaterdrops( 0 ); 
}

////////////////////////////////////////////////
// Anims
////////////////////////////////////////////////

#using_animtree( "supply_drop" ); 
setup_supply_drop_anims()
{
	/* Notes:
		Parachute animations for the airborne dogs.
	*/
	
	level.scr_anim["drop"]["drop"]							 = %o_supplydrop_loop; 
	level.scr_anim["drop"]["landing"]					 = %o_supplydrop_landing; 
	level.scr_anim["drop"]["landingb"] 				 = %o_supplydrop_landingB; 
	level.scr_anim["drop1"]["drop"]							 = %o_supplydrop_loop; 
	level.scr_anim["drop1"]["landing"]					 = %o_supplydrop_landing; 
	level.scr_anim["drop1"]["landingb"] 				 = %o_supplydrop_landingB; 
	
}