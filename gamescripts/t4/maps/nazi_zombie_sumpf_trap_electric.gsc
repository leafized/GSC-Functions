#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
//#include maps\nazi_zombie_sumpf_trap_barrel;

///////////////////////////////////////////////////////////////////////
// Electric Trap
///////////////////////////////////////////////////////////////////////
initElectricTrap()
{	
	electricTrapBuyTrigger = getentarray("electric_trap_buy_trigger","targetname");
	
	for(i = 0; i < electricTrapBuyTrigger.size; i++)
	{
		ent = getent(electricTrapBuyTrigger[i].target, "targetname");
		
		if ( IsDefined ( ent.script_noteworthy ) && ent.script_noteworthy == "lever")
		{
			electricTrapBuyTrigger[i].lever = ent;
			electricTrapBuyTrigger[i].electricDamageTrig = getent((electricTrapBuyTrigger[i].lever).target, "targetname");
		}
		else
		{
			electricTrapBuyTrigger[i].electricDamageTrig = getent(electricTrapBuyTrigger[i].target, "targetname");
		}
		
		electricTrapBuyTrigger[i] sethintstring( &"ZOMBIE_CLEAR_DEBRIS" );
		electricTrapBuyTrigger[i] setCursorHint( "HINT_NOICON" );
	}
		
}

moveElectricLeverDown()
{		
	self.lever rotatepitch(180,.5);
	
	self.lever waittill ("rotatedone");
	
	self notify ("electricLeverDown");
	
}

moveElectricLeverUp()
{
	self.lever rotatepitch(-180,.5);
	
	self.lever waittill ("rotatedone");
	
	self notify ("electricLeverUp");
}
	
electricTrapThink()
{	
	self sethintstring( &"ZOMBIE_ACTIVATE_TRAP" );
	level thread maps\nazi_zombie_sumpf::turnLightGreen("electric_light");
	self.is_available = undefined;
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
						
					electricTrapBuyTrigger = getentarray("electric_trap_buy_trigger","targetname");
					array_thread (electricTrapBuyTrigger,::trigger_off);
					level thread maps\nazi_zombie_sumpf::turnLightRed("electric_light");
					
					play_sound_at_pos( "purchase", who.origin );
					
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );
					
					if (IsDefined(self.lever))
					{
						self thread moveElectricLeverDown();
						
						self waittill("electricLeverDown");
					}
					
					//adding a ramp up time, I'm sure this will be accompanied by audio
					wait(0.5);
						
					self.electricDamageTrig trigger_on();
						
					self thread activateElectricTrap();
					self waittill("shockEffectDone");
					
					self.electricDamageTrig trigger_off();
					
					if (IsDefined(self.lever))
					{
						self thread moveElectricLeverUp();
						
						self waittill("electricLeverUp");
					}
						
					wait (20);
									
					array_thread (electricTrapBuyTrigger,::trigger_on);
					level thread maps\nazi_zombie_sumpf::turnLightGreen("electric_light");
						
					self.in_use = 0;					
				}
			}
		}
	}
}

activateElectricTrap()
{	
	electricTrapPoints = getentarray("electric_trap_origins","targetname");
	for(i=0;i<electricTrapPoints.size;i++)
	{
		electricTrapPoints[i] thread electricTrapFx(self);
	}
	
	//do the damage
	self.electricDamageTrig thread electricTrapDamage(self);
}

electricTrapFx(notify_ent)
{	
	//shockEffect = SpawnFx( level._effect["zapper"], self.origin, anglestoforward(self.angles), anglestoup(self.angles) );
	shockEffect = SpawnFx( level._effect["zapper"], self.origin, anglestoforward(self.angles));
	TriggerFX(shockEffect);
	
	wait (30);
	
	notify_ent notify ("shockEffectDone");
	level notify ("arc_done");
	shockEffect delete();

}
play_electrical_sound()
{
	level endon ("arc_done");
	while(1)
	{	
		wait(randomfloatrange(0.1, 0.5));
		playsoundatposition("elec_arc", self.origin);
	}
	

}
electricTrapDamage(parent)
{	
	while(1)
	{
		self waittill("trigger",ent);
		
		//player is standing flames, dumbass
		if(isplayer(ent) )
		{
			ent thread playerElectricTrapDamage();
		}
		else
		{
			ent thread zombieElectricTrapDamage();

			//add the round number when player made a kill with the trap.
			parent.used_by.electric_killed = level.round_number;
		}
	}
}

playerElectricTrapDamage()
{	
	self endon("death");
	self endon("disconnect");
	
	players = get_players();
	if (players.size == 1)
	{
		self thread maps\_zombiemode::player_damage_override( undefined, undefined, 100, undefined, "MOD_BURNED", undefined, self.origin, self.origin, undefined, undefined, undefined );
	}
	else
	{
		if(!self maps\_laststand::player_is_in_laststand() )
		{                
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
		}
	}	
}

zombieElectricTrapDamage()
{
	self endon("death");
	
	if(level.burning_zombies.size < 6)
	{
		level.burning_zombies[level.burning_zombies.size] = self;
		self zombie_flame_watch();
		self playloopsound("fire_manager_0");
		self thread animscripts\death::flame_death_fx();
		wait(randomfloat(1.25));		
	}
	else
	{
		
		refs[0] = "guts";
		refs[1] = "right_arm"; 
		refs[2] = "left_arm"; 
		refs[3] = "right_leg"; 
		refs[4] = "left_leg"; 
		refs[5] = "no_legs";
		refs[6] = "head";
		self.a.gib_ref = refs[randomint(refs.size)];
	}

	self dodamage(self.health + 600, self.origin);
}

zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	level.burning_zombies = array_remove_nokeys(level.burning_zombies,self);
}

