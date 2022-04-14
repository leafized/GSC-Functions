#include maps\_utility;
#using_animtree( "flag" );

init()
{
	level.scr_animtree["flag"] = #animtree; 	
	level.scr_model["flag"] = "anim_berlin_russian_flag"; 	
	precachemodel( level.scr_model[ "flag" ] );

	level.scr_anim["flag"]["flutter"] = %o_flag_flutter_loop;
	level.scr_anim["flag"]["idle"] = %o_flag_idle_loop;
	level.scr_anim["flag"]["flutter_2_idle"] = %o_flag_flutter_to_idle;
	level.scr_anim["flag"]["idle_2_flutter"] = %o_flag_idle_to_flutter;
}

spawn_flag()
{
	newFlag = spawn( "script_model", (0,0,0) );
	newFlag setmodel( level.scr_model["flag"] );
	newFlag.animname = "flag";
	newFlag useanimtree( level.scr_animtree["flag"] );	
	return newFlag;
}

flag_think()
{
	currState = "idle";
	
	historySize = 2;
	posHistory = [];
	for ( i = 0; i < historySize; i++ )
	{
		posHistory[i] = self.origin;
	}
	currHistorySlot = -1;
	
	timeBetweenChecks = 0.05;
	
	timeBetweenTransitions = 1.0;
	timeTilNextTransition = timeBetweenTransitions;
	
	while( 1 )
	{
		currHistorySlot = ( currHistorySlot + 1 ) % historySize;
		posHistory[ currHistorySlot ] = self.origin;		
		avgVelocity = posHistory[ currHistorySlot ] - posHistory[ ( currHistorySlot + historySize - 1 ) % historySize ];
		amMoving = LengthSquared( avgVelocity ) > 64;

		//if ( amMoving )
		//	println( "Flag is moving at time " + gettime()/1000 );
		//else
		//	println( "Flag stopped at time " + gettime()/1000 );
		
		switch ( currState )
		{
			case "idle":
			{
				if ( !amMoving )
				{
					self setAnimKnob( level.scr_anim["flag"]["idle"] );
				}
				else if ( timeTilNextTransition <= 0 )
				{
					self SetFlaggedAnimKnob( "flagflag", level.scr_anim["flag"]["idle_2_flutter"] );
					self waittillmatch( "flagflag", "end" );
					timeTilNextTransition = timeBetweenTransitions;
					currState = "flutter";
					continue;
				}
				break;
			}
			
			case "flutter":
			{
				if ( amMoving )
				{
					self setAnimKnob( level.scr_anim["flag"][currState] );
				}
				else if ( timeTilNextTransition <= 0 )
				{
					self SetFlaggedAnimKnob( "flagflag", level.scr_anim["flag"]["flutter_2_idle"] );
					self waittillmatch( "flagflag", "end" );
					timeTilNextTransition = timeBetweenTransitions;
					currState = "idle";
					continue;
				}
				break;
			}
		}
		
		timeTilNextTransition -= timeBetweenChecks;
		wait( timeBetweenChecks );
	}
}
