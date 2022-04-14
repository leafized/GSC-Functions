#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

/////////////////////////////////////////////////////////
//  Trap - Propeller blade functions
/////////////////////////////////////////////////////////

initPropTrap ()
{
	propBuyTrigger = getentarray("spin_buy_trigger","targetname");
	
	for(i = 0; i < propBuyTrigger.size; i++)
	{
		propBuyTrigger[i].lever = getent(propBuyTrigger[i].target, "targetname");
		propBuyTrigger[i].propDamageTrig = getent((propBuyTrigger[i].lever).target, "targetname");
		propBuyTrigger[i].prop = getent((propBuyTrigger[i].propDamageTrig).target, "targetname");
		propBuyTrigger[i].fx_origin = getent((propBuyTrigger[i].prop).target, "targetname");
		
		propBuyTrigger[i] sethintstring( &"ZOMBIE_CLEAR_DEBRIS" );
		propBuyTrigger[i] setCursorHint( "HINT_NOICON" );
		
	}
	propBuyTrigger[0].propDamageTrig EnableLinkTo();
	propBuyTrigger[0].propDamageTrig LinkTo (propBuyTrigger[0].prop);
	propBuyTrigger[0].fx_origin linkto(propBuyTrigger[0].prop);

	//rotate the blade and the trigger so we can spin it diagonally
	propBuyTrigger[0].prop rotateto ((0, -45, 0), 0.1);
	
	propBuyTrigger[0].prop waittill ("rotatedone");
	
	propBuyTrigger[0].propDamageTrig unlink();
	propBuyTrigger[0].fx_origin unlink();
		
}

moveSpinLeverDown()
{		
	self.lever rotatepitch(180,.5);
	
	self.lever waittill ("rotatedone");
	
	self notify ("spinLeverDown");
}

moveSpinLeverUp()
{
	self.lever rotatepitch(-180,.5);
	
	self.lever waittill ("rotatedone");
	
	self notify ("spinLeverUp");
}

spinTrapThink()
{	
	self sethintstring( &"ZOMBIE_ACTIVATE_TRAP" );
	self setCursorHint( "HINT_NOICON" );
	level thread maps\nazi_zombie_sumpf::turnLightGreen("propeller_light");
	self.zombie_cost = 1000;
	self.in_use = 0;
	
	while(1)
	{
		self waittill( "trigger", who );
		self.used_by = who;
		if( who in_revive_trigger() )
		{
			continue;
		}
					
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.in_use)
				{
					self.in_use = 1;
						
					propBuyTrigger = getentarray("spin_buy_trigger","targetname");
					array_thread (propBuyTrigger,::trigger_off);
					level thread maps\nazi_zombie_sumpf::turnLightRed("propeller_light");
						
					play_sound_at_pos( "purchase", who.origin );
					
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );
					
					self thread moveSpinLeverDown();
						
					self waittill("spinLeverDown");
					
					//adding a ramp up time, I'm sure this will be accompanied by audio
					wait(0.5);
					
					self thread activateProp();				
						
					self waittill("spin_off");
					
					self thread moveSpinLeverUp(); 
					
					self waittill("spinLeverUp");
										
					//cool down for 20 seconds
					wait (20.0);
					
					array_thread (propBuyTrigger,::trigger_on);
					level thread maps\nazi_zombie_sumpf::turnLightGreen("propeller_light");
						
					self.in_use = 0;					
				}
			}
		}
	}
}
	
activateProp() 
{	
    //turn off the collision while it spins 
    self.prop notsolid();
    
    //spawn fx at the center of the propeller
    chopper_blur = spawnfx(level._effect["chopper_blur"], (self.fx_origin).origin, anglestoforward((self.fx_origin).angles), anglestoup((self.fx_origin).angles));

	endtime = GetTime() + 8000;
	begintime = 1;
	rps = 1;
    
    self.propDamageTrig thread spinKill(self);
    self.propDamageTrig trigger_on();
    self.propactive = true;
    
    endtime = GetTime() + 20000;
    
    for (i=0; i < rps; i++)
	{
   		self.prop rotateto ((0, -45, 180), begintime);
	   	wait(begintime);
	   	(self.prop).angles = (0, -45, 0);
	    	
	    if ( (i + 1) == rps && rps < 6)
	    {
	    	i = -1;
	    	rps++;
	    	begintime = (1 / rps);
	    }	
	 }
      
    //once the propeller is going, start the fx
    triggerfx(chopper_blur);
        
    while (GetTime() < endtime)
    {	
    	self.prop rotateto ((0, -45, 180), .16);
    	wait(.16);
    	
    	(self.prop).angles = (0, -45, 0);
    }
    
    //delete fx once the ramp down starts
    chopper_blur delete();
    	
    begintime = .16;
    rps = 6;
    	 
    for (i=0; i < rps; i++)
	{
    	self.prop rotateto ((0, -45, 180), begintime);
	    wait(begintime);
	    (self.prop).angles = (0, -45, 0);
	    	
	    if ( (i + 1) == rps && rps > 1)
	    {
	    	i = -1;
	    	rps--;
	    	begintime = (1 / rps);
	    }	
	} 
    
    //self.prop waittill ("rotatedone");
    
    self.prop solid();
    
    self.propDamageTrig trigger_off();
    self.propactive = false;
    
    self notify ("spin_off");
}

spinKill(parent)
{
	while(1)
	{
		self waittill("trigger",ent);
		
		if (parent.propactive == true)
		{
			if(isplayer(ent) )
			{
				ent thread player_spin_damage();
			}
			else
			{
				ent thread zombie_spin_death();

				//add the round number when player made a kill with the trap.
				parent.used_by.propeller_killed = level.round_number;
			}
		}
	}
}

//zombie hit the spinning blade of death, kill it
zombie_spin_death()
{
	//gibbing is always fun, set up the array
	refs[0] = "guts";
	refs[1] = "right_arm"; 
	refs[2] = "left_arm"; 
	refs[3] = "head";

	self dodamage(self.health + 50, self.origin);
	self.a.gib_ref = refs[randomint(refs.size)]; //gib randomly for now
	playfxontag(level._effect["trap_blade"],self,"tag_origin");
}

//player hit the spinning blade of death, throw into last stand mode if possible, otherwise do a bunch of damage
player_spin_damage()
{
	self endon("death");
	self endon("disconnect");
		
	players = get_players();
	if (players.size == 1)
	{
		self thread maps\_zombiemode::player_damage_override( undefined, undefined, 100, undefined, "MOD_MELEE", undefined, self.origin, self.origin, undefined, undefined, undefined );
	}
	else
	{
		if(!self maps\_laststand::player_is_in_laststand() )
		{                
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
		}
	}	
}


