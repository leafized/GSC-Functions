#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{
	PrecacheModel( "tag_origin" );	   

 	maps\_load::main();


	// Will need to put this in levelname_fx.gsc
	level._effect["betty_explosion"] = LoadFx( "explosions/grenadeExp_dirt" );
	level._effect["betty_smoketrail"] = LoadFx("impacts/fx_pipe_steam");
	level._effect["betty_groundPop"] = LoadFX( "impacts/small_snowhit" );


    wait_for_first_player();	
		players = get_players();
		players[0] giveweapon ("thompson");
		players[0] giveweapon ("m1garand");
		setexpfog(500, 900, 0.803, 0.812, 0.794, 10);
		
	


		

	level thread test_betties();

}

test_betties()
{
	level.betty_trigs = GetEntArray( "trip_betty", "targetname" );

	for( i = 0; i < level.betty_trigs.size; i++ )
	{
		level thread betty_think( level.betty_trigs[i] );
	}
}

// TODO add functionality to do damage/kill AIs
//   make sure to test if they are magic_bullet_shield protected
betty_think( trigger )
{
	trigger waittill( "trigger" );

	// get our objects
	tripwire = GetEnt( trigger.target, "targetname" );
	betty = GetEnt( tripwire.target, "targetname" );
	betty_radius = 80;

	//ASSERTEX( trigger.classname == "trigger_radius", "bouncing betty trigger at origin '" + trigger.origin + "' needs to be a trigger radius." );

	// set up values
	jumpHeight = RandomIntRange( 68, 80 );  // world units
	dropHeight = RandomIntRange( 10, 20 );

	jumpTime = 0.15;  // seconds
	dropTime = 0.1;
	clickWaitTime = 0.05;  // seconds after the "click" til the betty jumps up
	radiusMultiplier = 1;  // how big of an area outside the touch trigger should dudes be damaged instead of killed?  1 = 100% bigger radius.
	damageMultiplier = 0.5;  // how much less damage do guys near but not touching the trigger take?

	// TODO replace with click sound
	iprintln( "Click!" );

	wait( clickWaitTime );

	// play ground impact particle where it pops out of the ground
	PlayFX( level._effect["betty_groundPop"], betty.origin + ( 0, 0, 10 ) );
	
	// start rotating
	betty thread betty_rotate();

	// jump up out of the ground
	betty MoveTo( betty.origin + ( 0, 0, jumpHeight ), jumpTime, 0, jumpTime * 0.5 );
	betty waittill( "movedone" );

	// fall back down a bit
	betty MoveTo( betty.origin - ( 0, 0, dropHeight ), dropTime, dropTime * 0.5 );
	betty waittill( "movedone" );

	// let our threads know it's time to start cleaning up
	betty notify( "stop_rotate_thread" );

	// Blow up!
	PlayFx( level._effect["betty_explosion"], betty.origin );

	// damage players in the area, if they're not proned
	// can't use RadiusDamage because we want prone guys to be safe
	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		// if prone, you're cool
		if( player GetStance() == "prone" )
		{
			continue;
		}

		// non-proning players touching the trigger...
		if( player IsTouching( trigger ) )
		{
			// ... will DIEEE
			player DoDamage( player.health + 200, betty.origin );
		}
		// if player isn't touching the trigger, but is close to it...
		else if( Distance( player.origin, betty.origin ) > betty_radius + ( betty_radius * radiusMultiplier ) )
		{
			// just damage the player
			player DoDamage( player.health * damageMultiplier, betty.origin );
		}
	}

	// set off other betties nearby
	for( i = 0; i < level.betty_trigs.size; i++ )
	{
		otherBetty = level.betty_trigs[i];

		if( !IsDefined( otherBetty ) || trigger == otherBetty )
		{
			continue;
		}

		// NOTE: this should work for all but the craziest of cases
		if( Distance2D( betty.origin, otherBetty.origin ) <= betty_radius + ( betty_radius * radiusMultiplier ) )
		{
			// set it off!
			otherBetty thread betty_pop( RandomFloatRange( 0.15, 0.25 ) );
		}
	}

	betty Delete();
	tripwire Delete();
	trigger Delete();
}

// rotates the bouncing betty as it comes out of the ground.
// NOTE: for this to look good, the betty needs to be angled already.
// self = the betty
betty_rotate()
{
	self endon( "stop_rotate_thread" );

	self thread betty_rotate_fx();

	rotateAngles = 360;
	rotateTime = 0.125;

	while( 1 )
	{
		self RotateYaw( rotateAngles, rotateTime );
		self waittill( "rotatedone" );
	}
}

// TODO this won't work until Conserva's fix works
// plays a little trail of particles off the origin of
//   the betty, to set it off visually
// self = the betty
betty_rotate_fx()
{
	self endon( "stop_rotate_thread" );

	fxOrg = Spawn( "script_model", self.origin );
	fxOrg SetModel( "tag_origin" );

	fxOrg LinkTo( self );

	wait( 0.75 );  // I thought Conserva fixed this?

	fx = PlayFxOnTag( level._effect["betty_smoketrail"], fxOrg, "tag_origin" );
}

// sets off a betty manually
// self = the betty
betty_pop( waitTime )
{
	if( IsDefined( waitTime ) && waitTime > 0 )
	{
		wait( waitTime );
	}

	self notify( "trigger" );
}




		