//
// file: rhi2_util.gsc
// description: utility script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;

// --------------
//     COOP
// --------------
get_playerone()
{
	return get_players()[0];
}

// --------------
// AI MANAGEMENT
// --------------

// Grab starting AI, probably heroes
grab_starting_friends()
{
	startguys = GetEntArray( "starting_allies", "targetname" );
	ASSERT( IsDefined( startguys ) && startguys.size > 0, "grab_starting_guys(): can't find the starting guys!" );
	
	return startguys;
}

// renames a friendly.
//  newName: the name
//  doWait: if calling at level start, set to true so that you override _name::get_name() 
rename_friendly( newName, doWait )
{
	if( IsDefined( doWait ) && doWait == true )
	{
		self waittill("set name and rank" );
	}
	
	self.name = newName;
}

// sets a new friendlychain for the AIs in the level.friends array, and sets their leader as the player
// (basically everything to set a new friendlychain)
set_friendlychain( nodeTN )
{
	ASSERTEX( flag( "friends_setup" ), "set_friendlychain(): level.friends needs to be set up before this runs." );
	
	define_active_chain( nodeTN );
	level.friends set_squad_goal();
}

define_active_chain( nodeTN )
{
	chain_startNode = GetNode( nodeTN, "targetname" );
	ASSERT( IsDefined( chain_startNode ), "define_active_chain(): can't find friendlychain start node" );
	
	get_playerone() SetFriendlyChain( chain_startNode );
}

// self = the array we're setting up to follow the player
set_squad_goal()
{
	for (i = 0; i < self.size; i++)
	{
		self[i] SetGoalEntity( get_playerone() );
	}	
}

// adds a guy to level.friends
friend_add( guy )
{
	if( IsDefined( level.friends ) )
	{
		level.friends = array_add( level.friends, guy );
	}
}

// removes a guy from level.friends
friend_remove( guy )
{
	if( IsDefined( level.friends ) )
	{
		level.friends = array_remove( level.friends, guy );
	}
}

// makes a guy follow the player around
// self = the guy
// interval = the amount of time to wait before checking where the player is at
friend_follow_player( interval, followdist )
{
	self endon( "death" );
	level endon( "friend_follow_player_stop" );

	if( !IsDefined( self.goalradius ) )
	{
		println( "friend_follow_player(): a friendly's goalradius wasn't defined! aborting." );
		return;
	}

	if( !IsDefined( interval ) || interval <=0 )
	{
		interval = 0.5;
	}

	while( 1 )
	{
		if( is_active_ai( self ) )
		{
			if( DistanceSquared( level.player.origin, self.origin ) > (followdist*followdist) )
			{
				// move the guy
				self SetGoalPos( level.player.origin );
				//println( "friendly moving!" );
			}
		}

		wait( interval );
	}
}


// removes a guy from level.friends when he dies
// self = the guy
friend_remove_on_death()
{
	self waittill( "death" );
	friend_remove( self );
}


// spawns a guy
// spawner = the spawner to spawn a guy from
spawn_guy( spawner )
{
	spawnedGuy = spawner StalingradSpawn();
	spawn_failed (spawnedGuy);
	assert (isDefined (spawnedGuy));

	return spawnedGuy;
}


// grabs triggers and does stuff to them
trigger_setup()
{
	fs_trigs = GetEntArray( "flood_spawner", "targetname" );

	for( i = 0; i < fs_trigs.size; i++ )
	{
		if( IsDefined( fs_trigs[i] ) )
		{
			fs_trigs[i] thread trigger_floodspawn_think();
		}
	}
	
	fc_trigs = GetEntArray( "trigger_friendlychain", "classname" );

	for( i = 0; i < fc_trigs.size; i++ )
	{
		if( IsDefined( fc_trigs[i] ) )
		{
			fc_trigs[i] thread trigger_friendlychain_think();
		}
	}
}

trigger_friendlychain_think()
{
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "delete" )
		{
			self waittill( "trigger" );
			wait( 0.1 );
			self Delete();
		}
	}
}

// deletes a floodspawn trigger with a script_noteworthy=delete
trigger_floodspawn_think()
{
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "delete" )
		{
			self waittill( "trigger" );
			wait( 0.1 );
			self Delete();
		}
		// otherwise it's telling us about another trigger, related to it in some way, that we want to delete
		//  for example for multipath stuff
		else
		{
			otherTrig = GetEnt( "self.script_noteworthy", "targetname" );

			if( IsDefined( otherTrig ) )
			{
				self waittill( "trigger" );
				otherTrig Delete();
			}
		}
	}
}


// waits until a trigger area is clear of enemies
// team = "axis", "allies", "neutral"
waittill_triggerarea_clear( trig, team, maxWait )
{
	startTime = GetTime();
	ais = [];
	loop = true;
	
	if( !IsDefined( trig ) )
	{
		println( "waittill_triggerarea_clear(): trig is not defined! aborting." );
		return;
	}
	
	while( 1 )
	{
		//println( "waittill_triggerarea_clear(): starting check loop" );
		
		foundOne = false;
		
		ais = GetAiArray( team );
		
		if( ais.size <= 0 )
		{
			return;
		}
		
		// see if any of the axis are standing in our trigger
		for( i = 0; i < ais.size; i++ )
		{
			guy = ais[i];
			
			if( guy IsTouching( trig ) )
			{
				//println( "waittill_triggerarea_clear(): found a guy touching the trigger" );
				foundOne = true;
				continue;
			}
		}
		
		// break if we didn't find anyone in the trigger
		if( !foundOne )
		{
			println( "waittill_triggerarea_clear(): didn't find anyone touching the trigger, done waiting." );
			break;
		}
	
		// break if our maxwait has been exceeded
		if( IsDefined( maxWait ) )
		{
			if( ( GetTime() - startTime ) > ( maxWait * 1000 ) )
			{
				println( "waittill_triggerarea_clear(): maxWait exceeded, done waiting." );
				break;
			}
		}
		
		wait( 0.25 );
	}		
}

// returns an array of AIs - should usually be off of script_noteworthy
get_ais( value, key )
{
	ents = GetEntArray( value, key );
	guys = [];
	endnodes = [];
	
	if( !IsDefined( ents.size ) || ents.size <=0 )
	{
		ASSERTMSG( "get_ais(): couldn't find any AIs of key/value " + key + "/" + value );
		return guys;
	}
	
	// get the guys
	for( i = 0; i < ents.size; i++ )
	{
		ent = ents[i];
		if( is_active_ai( ent ) )
		{
			guys[guys.size] = ent;
		}
	}
	
	return guys;
}


// wait for every AI in array "group" to die, before the script continues.
// group = the AI array
// maxWait = the maximum amount of time you want to wait before just moving on
// amount = the number of guys REMAINING that you'll be satisfied with before moving on
// kill_rest = once "amount" has been reached, should we kill the rest off artifically?
waittill_group_dies( group, maxWait, amount, kill_rest )
{
	level.groupIsDead = false;
	level.groupTimerDone = false;
	
	if( group.size <= 0 )
	{
		return;
	}

	if( IsDefined( maxWait ) )
	{
		level thread waittill_group_dies_timeout( maxWait );
		// if we time out, kill the rest of the guys
		kill_rest = true;
	}
	
	if( !IsDefined( amount ) )
	{
		amount = 0;  // we want the player to kill them all
	}
	
	if( !IsDefined( kill_rest ) )
	{
		kill_rest = true;
	}

	level.deathWaitTracker = group.size;

	println( "^5Waiting for " + level.deathWaitTracker + " AI to die..." );

	for( i = 0; i < group.size; i++ )
	{
		if( IsAlive( group[i] ) )
		{
			level thread death_wait( group[i], amount, kill_rest, group );
		}
	}

	while( !level.groupIsDead && !level.groupTimerDone )
	{
		wait( 0.25 );
	}

	return;	
}

waittill_group_dies_timeout( timer )
{
	startTime = GetTime();

	while( !level.groupIsDead && ( ( GetTime() - startTime ) < ( timer * 1000 ) ) )
	{
		wait( 0.25 );
	}

	if( !level.groupIsDead )
	{
		level.groupTimerDone = true;

		println( "waittill_group_dies_timeout() timed out after " + timer + " seconds.  Killing fools and continuing." );
	}
	else
	{
		println( "waittill_group_dies_timeout() didn't get a chance to time out." );
	}
}

death_wait( ent, amount, kill_rest, group )
{	
	while( IsAlive( ent ) )
	{
		if( !level.groupTimerDone )
		{
			wait( 0.25 );
		}
		else
		{
			break;
		}
	}

	level.deathWaitTracker--;

	if( !IsDefined( amount ) )
	{
		amount = 0;
	}

	println( "death_wait(): Waiting for " + level.deathWaitTracker + " AI to die... Needs to be: " + amount );

	if( level.deathWaitTracker <= amount )
	{
		if( kill_rest )
		{
			for( i = 0; i < group.size; i ++ )
			{
				guy = group[i];
				if( is_active_ai( guy ) )
				{
					guy thread bloody_death( true, 3.0 );
				}
			}
		}

		if( amount > 0 && level.deathWaitTracker <= 0 )
		{
			level.groupIsDead = true;
		}
		else
		{
			level.groupIsDead = true;
		}
	}
}

// kill all the axis in the map.
kill_all_axis( delay )
{
	axis = GetAIArray( "axis" );
	
	if( axis.size <= 0 )
	{
		return;
	}
	
	if( !IsDefined( delay ) )
	{
		delay = 0;
	}
	
	for( i = 0; i < axis.size; i++ )
	{
		if( IsDefined( axis[i] ) )
		{
			axis[i] thread bloody_death( true, delay );
		}
	}
}

// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die )
	{
		self DoDamage( self.health + 50, self.origin );
	}
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

// cool IW steez, not sure if I will use it though
schoolcircle(nodename, guys)
{	
	//Makes any number of Allied troops assemble with a leader, useful for regrouping for in-level briefings
	
	//nodename = targetname of the nodes used by the grunts
	//guys = array of guys to distribute at the destination
	
	nodearray = getnodearray( nodename, "targetname" );
	
	assertEX( nodearray.size >= guys.size , "You have more guys than nodes for them to go to." );
	
	for( i = 0; i < guys.size; i++ )
	{
		guys[ i ] thread schoolcircle_nav( nodearray, i ); 
	}
}

schoolcircle_nav(nodearray, i)
{
	self endon ("death");
	
	wait 2.5;	//soft wait to avoid traffic jams w/ leader
	self setgoalnode(nodearray[i]);
	self.goalradius = 32;
	self.dontavoidplayer = true;
	self allowedstances ("stand");
	if(!isdefined(nodearray[i].script_noteworthy))
		return;
	if(nodearray[i].script_noteworthy == "kneel")
		thread schoolcircle_crouch(self);
}

schoolcircle_crouch(soldier)
{
	soldier waittill ("goal");
	soldier allowedstances ("crouch");
}


//------------
// DEBUG
//------------

// Guzzo steez
debug_ai()
{
	while( 1 )
	{
		//set_hud_text( level.event_info, "total_friends: " + level.totalfriends );
		//set_hud_text( level.extra_info, "maxfriendlies: " + level.maxfriendlies );
	
		//total_ai = GetAiArray( "axis", "allies" );
		axis_ai = GetAiArray( "axis" );
		set_hud_text( level.ai_info, "total axis: " + axis_ai.size );
	
		wait 1.5;
	}
}

setup_hud()
{
	level.event_info = NewHudElem();
	level.event_info.alignX = "right";
	level.event_info.x = 110;
	level.event_info.y = 245;

	level.extra_info = NewHudElem();
	level.extra_info.alignX = "right";
	level.extra_info.x = 100;
	level.extra_info.y = 262;

	level.ai_info = NewHudElem();
	level.ai_info.alignX = "right";
	level.ai_info.x = 100;
	level.ai_info.y = 277;
}

set_hud_text( hud_elem, text )
{
	hud_elem setText( text );
}
