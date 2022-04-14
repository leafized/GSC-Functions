#include maps\_utility;
#include common_scripts\utility;


// USED AT START
// Teleport players to positions of specified scrip_origins
teleport_players( origin_name )
{
	starts = getentarray( origin_name,"targetname" );
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setOrigin( starts[i].origin );
		players[i] setPlayerAngles( starts[i].angles );
	}
}	


// teleport AIs to specified struct positions
// This will move the player temporarily out of the way
// ONLY use it during starts
heroes_force_teleport( struct_name )
{
	ai_starts = getstructarray( struct_name, "targetname");
	
	assertex( ai_starts.size >= level.initial_friendlies.size, "Need more start positions for ai!" ); 
	
	// teleport player out of the way first. AI won't teleport unless player can't see them
	level thread teleport_player_temp_into_enclosure();
	
	for (i = 0; i < level.initial_friendlies.size; i++)
	{
		level.initial_friendlies[i] teleport( ai_starts[i].origin );
	}	
	
	wait( 0.1 ); 
	level notify( "restore_player_positions" );
	wait( 0.1 );
}


// teleport player to a temporary and fully enclosed position
// as to allow AI teleporting (currently they can't while player can see them)
// move players back once teleporting is complete
teleport_player_temp_into_enclosure()
{
	players = get_players();
	old_origins = [];

	origs = getstructarray( "temp_teleport_position", "targetname" );
	if( origs.size >= 4 )
	{
		// store original positions
		for (i = 0; i < players.size; i++)
		{
			old_origins = add_to_array( old_origins, players[i].origin );
			players[i] setOrigin( origs[i].origin );
		}		
		
		level waittill( "restore_player_positions" );
		
		// restore positions
		for (i = 0; i < players.size; i++)
		{
			players[i] setOrigin( old_origins[i] );
		}	
	}
}

	
// Setup friendly chains.
// Example: init_friendlychain( "fc_node01" );
/*
init_friendlychain( node_name )
{
	node = getnode( node_name, "targetname" );

	if( isdefined( node ) )
	{
		get_players()[0] setfriendlychain( node );
		
		for( i = 0; i < level.heroes.size; i++ )
		{
			level.heroes[i] setgoalentity ( get_players()[0] );
		}
	}
}
*/

heroes_make_invincible()
{
	for( i = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] thread magic_bullet_shield();
	}
}

// set off a trigger
script_trigger( trigger_name )
{
	trigger = getent( trigger_name, "targetname" );
	trigger notify( "trigger" );
}

// add an objective, using given script_struct for positioning
objective_add_new( num, obj_string, struct_name )
{
	obj_position = getstruct( struct_name, "targetname" );
	if( isdefined( obj_position ) )
	{
		objective_add( num, "current", obj_string, obj_position.origin );
	}
}

// add an objective and set it as done
objective_add_done( num, obj_string )
{
	objective_add( num, "current", obj_string );
	objective_state( num, "done" );
}

// wait until a trigger goes off, then complete the objective
objective_triggered_complete( num, trigger_name )
{
	trigger_wait( trigger_name, "targetname" );
	objective_state( num, "done" );
}


// wait until a trigger goes off, then update the objective star to the 
// position of the new struct. Mainly used to guide the player through a 
// series of objective star updates
objective_triggered_update_position( num, trigger_name, struct_name )
{
	trigger_wait( trigger_name, "targetname" );
	
	obj_position = getstruct( struct_name, "targetname" );
	if( isdefined( obj_position ) )
	{
		objective_position( num, obj_position.origin );
	}
}


// call this during load (or any time before the spawning occurs)
// Example: initialize_spawn_function( "charging_guys", "targetname", ::charge_up_hill );
initialize_spawn_function( name, key, spawn_func )
{
	spawners = getEntArray( name, key );
	
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			if( !isdefined( spawners[i].spawn_functions ) )
			{
				spawners[i].spawn_functions = [];
			}
			spawners[i] add_spawn_function( spawn_func );
		}
	}
}

delete_noteworthy_group( noteworthy_name )
{
	guys = getentarray( noteworthy_name, "script_noteworthy" );
	if( isdefined( guys ) )
	{
		for( i = 0; i < guys.size; i++ )
		{
			guys[i] delete();
		} 
	}
}

// Stop set of drones
// - Drone trigger must have script_ender set to msg
// - Drones stop when a trigger with targetname:msg is hit 
drones_wait_stop( msg )
{
	stop_trigger = getent( msg, "targetname" );
	stop_trigger waittill( "trigger" );
	
	level notify( msg );
}

kill_all_axis()
{
	guys = getaiarray("axis");
	
	if( isdefined( guys ) )
	{
		for( i = 0; i < guys.size; i++ )
		{
			if( issentient( guys[i] ) )
			{
				guys[i] doDamage( guys[i].health + 1, ( 0,0,72 ) );
			}
			
			wait randomInt( 2 );
		}
	}
}

// USED AS A SPAWN FUNCTION FOR VEHICLES
// After spawning, the AI will run to his goal before engaging in combat
force_goal()
{
	self endon( "death" );
	
	self.pacifist = 1;
	self.goalradius = 30;
	self.ignoreall = 1;

	self waittill( "goal" );
	
	self.pacifist = 0;
	self.goalradius = 256;
	self.ignoreall = 0;
}

go_to_goal( node )
{
	self endon( "death" );
	
	self.pacifist = 1;
	self.goalradius = 30;
	self.ignoreall = 1;

	self setgoalnode( node );

	self waittill( "goal" );
	
	self.pacifist = 0;
	self.goalradius = 256;
	self.ignoreall = 0;
}


// Send AI to a designated goal. WIll not engage in combat till arrival
set_force_goal( node )
{
	self.pacifist = 1;
	self.goalradius = 30;

	self setgoalnode( node );
	self waittill( "goal" );
	
	self.pacifist = 0;
	self.goalradius = 256;
}

// kill the AI after a random time interval
timed_death( min_time, max_time )
{
	self endon( "death" );
	
	timer = randomfloat( max_time - min_time );
	wait( timer + min_time);
	
	self dodamage( self.health + 1, ( 0, 0, 0 ) );
}

// Spawn a t34, move it along the rail, then blow it up
// 1. Player hits specified trigger
// 2. T34 is spawned. The node that trigger targets is the starting node
// 3. T34 moves
// 4. When a node with script_noteworthy of kill_node is hit, the tank blows up and dies
//    (For now, the kill node has to be the 2nd to the last node on the chain)
// TODO: Add more elaborate effects to blowing up
vehicle_move_and_blow_up( trigger )
{
	start_node = getvehiclenode( trigger.target, "targetname" );
	
	if( isdefined( start_node ) )
	{
		trigger waittill( "trigger" );
		
		// spawn and move
		tank = spawnvehicle( 	"vehicle_rus_tracked_t34", 
													"tank", 
													"t34", 
													start_node.origin, 
													start_node.angles );
													
		tank attachPath( start_node );
		tank startpath();
		
		// find the kill node
		kill_node = get_2nd_last_vehicle_node_on_chain( start_node );
		tank setwaitnode( kill_node );
		tank waittill( "reached_wait_node" );
		
		// play fx and kill
		playfx( level.fx_vehicle_explosion, tank.origin );
		
		tank setspeed( 0, 10, 10 );
		tank DoDamage( tank.health + 1, ( 0, 0, 0 ) );
		return;
	}
}

// wait till trigger is hit, then:
// 1. spawn a t34 at the node this trigger is targeting, using the given targetname
// 2. start moving the tank, wait till it hits the end node, with script_noteworthy "end_node"
// 3. tank then fires forward repeatedly
// (Used in multiple events)
t34_trigger_spawn_move_stop_fire( trigger_name, targetname )
{
	/*
	level endon( "event1_ends" );
	level endon( "event2_ends" );
	level endon( "event3_ends" );
	level endon( "event4_ends" );
	*/
		
	trigger = getent( trigger_name, "targetname" );
	if( !isdefined( trigger ) )
	{
		iprintlnbold( "cannot find trigger " + trigger_name );
		return;
	}
	
	start_node_name = trigger.target;
	if( !isdefined( start_node_name ) )
	{
		iprintlnbold( "trigger has no target: " + trigger_name );
		return;
	}
	
	start_node = getvehiclenode( start_node_name, "targetname" );
	if( !isdefined( start_node ) )
	{
		iprintlnbold( "vehicle node not found " + start_node_name );
		return;
	}
	
	trigger waittill( "trigger" );
	
	// spawn the tank and move
	tank = spawnvehicle( 	"vehicle_rus_tracked_t34", 
												targetname, 
												"t34", 
												start_node.origin, 
												start_node.angles );
													
	tank.script_noteworthy = "tank";
	tank.health = 3000;
	tank attachPath( start_node );
	tank startpath();
	
	// wait until end node
	stop_node = get_last_vehicle_node_on_chain( start_node );
	tank setwaitnode( stop_node );
	tank waittill( "reached_wait_node" );
	
	// now the tank fires
	while( 1 )
	{
		wait( randomint( 2 ) + 3 );
		tank FireWeapon();
	}
}

t34_trigger_spawn_move_stop( trigger_name, targetname )
{
	trigger = getent( trigger_name, "targetname" );
	if( !isdefined( trigger ) )
	{
		iprintlnbold( "cannot find trigger " + trigger_name );
		return;
	}
	
	start_node_name = trigger.target;
	if( !isdefined( start_node_name ) )
	{
		iprintlnbold( "trigger has no target: " + trigger_name );
		return;
	}
	
	start_node = getvehiclenode( start_node_name, "targetname" );
	if( !isdefined( start_node ) )
	{
		iprintlnbold( "vehicle node not found " + start_node_name );
		return;
	}
	
	trigger waittill( "trigger" );
	
	// spawn the tank and move
	tank = spawnvehicle( 	"vehicle_rus_tracked_t34", 
												targetname, 
												"t34", 
												start_node.origin, 
												start_node.angles );
													
	tank.script_noteworthy = "tank";
	tank.health = 10000;
	tank attachPath( start_node );
	tank startpath();
}

t34_trigger_spawn_move( start_node_name, targetname )
{
	start_node = getvehiclenode( start_node_name, "targetname" );
	if( !isdefined( start_node ) )
	{
		start_node = getvehiclenode( start_node_name, "script_noteworthy" );
		if( !isdefined( start_node ) )
		{
			iprintlnbold( "vehicle node not found " + start_node_name );
			return;
		}
	}
	
	// spawn the tank and move
	tank = spawnvehicle( 	"vehicle_rus_tracked_t34", 
							targetname, 
							"t34", 
							start_node.origin, 
							start_node.angles );
													
	tank.script_noteworthy = "tank";
	tank.health = 10000;
	tank attachPath( start_node );
	tank startpath();

	return tank;
}

vehicle_wait_till_node( tank, node_script_noteworthy )
{
	tank endon( "death" );
	node = getvehiclenode( node_script_noteworthy, "script_noteworthy" );
	tank setwaitnode( node );
	tank waittill( "reached_wait_node" );
}

tank_fire_weapon_loop()
{
	self endon( "death" );
	self endon( "stop_firing" );
	while( 1 )
	{
		self fireweapon();
		wait( 3 + randomint( 3 ) );
	} 
}

kill_tank( tank )
{
	playfx( level.fx_vehicle_explosion, tank.origin );
	tank dodamage( tank.health + 100, ( 0, 0, 0 ) );
	tank notify( "death" );
	earthquake( 0.3, 1.5, tank.origin, 512 );
}

rocket_fake_fire( start_origin, target_entity, model, time )
{
	start_point = start_origin + ( 0, 0, 60 );
	end_point = target_entity.origin + ( 0, 0, 60 );

	rocket = Spawn( "script_model", start_point );
	rocket SetModel( model );
	rocket.angles = vectortoangles( end_point - start_point );

	level thread rocket_move( rocket, end_point, time );

	wait( 1 );
	
	kill_tank( target_entity );
}

// actually moves the rocket when it is "fired"
rocket_move( rocket, end_point, moveTime )
{
	rocket moveto( end_point, moveTime, 0, 0 );
	PlayFxOnTag( level._effect["rocket_trail"], rocket, "tag_origin" );	// not visual enough
	//Audio Kevin changed the rocket_launch string to the 3rd person panzershreck fire.
	thread play_sound_in_space( "weap_pnzr_fire", rocket.origin );
	// wait until the rocket is done moving, then delete it
	wait( moveTime );
	rocket Delete();
}

// Returns the last node on a vehicle node chain
get_last_vehicle_node_on_chain( start_node )
{
	while( 1 )
	{
		// reached last node
		if( !isdefined( start_node.target ) )
		{
			return start_node;
		}
	
		// this is not the last node, move up one
		start_node = getvehiclenode( start_node.target, "targetname" );
	}
}

// Returns the 2nd to the last node on a vehicle node chain
// (If no node is targeting this node, the current node is returned)
get_2nd_last_vehicle_node_on_chain( start_node )
{
	previous_node = start_node;
	while( 1 )
	{
		// reached last node
		if( !isdefined( start_node.target ) )
		{
			return previous_node;
		}
	
		// this is not the last node, move up one
		previous_node = start_node;
		start_node = getvehiclenode( start_node.target, "targetname" );
	}
}

// Returns the first node on the chain that has the specified script_noteworthy
find_vehicle_node_on_chain_by_script_noteworthy( start_node, value )
{
	while( 1 )
	{
		if( isdefined( start_node.script_noteworthy ) )
		{
			if( start_node.script_noteworthy == value )
			{
				return start_node;
			}
		}
		
		if( !isdefined( start_node.target ) )
		{
			return undefined;
		}
		
		next_node = getvehiclenode( start_node.target, "targetname" );
		if( !isdefined( next_node ) )
		{
			return undefined;
		}
	
		start_node = next_node;
	}
}

// freeze AIs in place
heroes_lock_in_place( msg )
{
	for( i = 0; i < level.heroes.size; i++ )
	{
		org = spawn( "script_origin", level.heroes[i].origin );
		level.heroes[i] linkto( org );
	}
	
	level waittill ( msg );
	
	for( i = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] unlink();
	}
}

show_brush_model( model_name )
{
	model = getent( model_name, "targetname" );
	if( isdefined( model ) )
	{
		model show();
		model solid();
		model disconnectpaths();
	}
}

hide_brush_model( model_name )
{
	model = getent( model_name, "targetname" );
	if( isdefined( model ) )
	{
		model hide();
		model notsolid();
		model connectpaths();
	}
}

// shamelessly stole from pel1.gsc
throw_object_with_gravity( object, target_pos )
{
	 object endon ("remove thrown object");
   start_pos = object.origin; // Get the start position

   ///////// Math Section
   // Reverse the gravity so it's negative, you could change the gravity
// by just putting a number in there, but if you keep the dvar, then the
// user will see it change.
   gravity = GetDvarInt( "g_gravity" ) * -1;
   
   // Get the distance
   dist = Distance( start_pos, target_pos );

   // Figure out the time depending on how fast we are going to
// throw the object... 300 changes the "strength" of the velocity.
// 300 seems to be pretty good. To make it more lofty, lower the number.
// To make it more of a b-line throw, increase the number.
   time = dist / 2000;

   // Get the delta between the 2 points.
   delta = target_pos - start_pos;

   // Here's the math I stole from the grenade code. :) First figure out
// the drop we're going to need using gravity and time squared.
   drop = 0.5 * gravity * ( time * time );

   // Now figure out the trajectory to throw the object at in order to
// hit our map, taking drop and time into account.
   velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
   ///////// End Math Section

   object MoveGravity( velocity, time );    
}