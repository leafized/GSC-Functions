#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;


//////////////////////////////////////////////////////////////////////////////////
//Traps - Barrel Tipping Trap
//////////////////////////////////////////////////////////////////////////////////

initBarrelTrap ()
{
	barrelBuyTrigger = getent("barrel_buy_trigger", "targetname");
	
	barrelBuyTrigger.liquidDamageTrig = getent(barrelBuyTrigger.target, "targetname");
	barrelBuyTrigger.liquid = getent((barrelBuyTrigger.liquidDamageTrig).target, "targetname");
	barrelBuyTrigger.barrel = getent((barrelBuyTrigger.liquid).target, "targetname");
	barrelBuyTrigger.pourfxorg = getent((barrelBuyTrigger.barrel).target, "targetname");
	barrelBuyTrigger.bo = getent((barrelBuyTrigger.pourfxorg).target, "targetname");
	barrelBuyTrigger.liquidclip = getent((barrelBuyTrigger.bo).target, "targetname");
	
	//barrelBuyTrigger.clip = getent((barrelBuyTrigger.bo).target, "targetname");
	
	barrelBuyTrigger.liquidDamageTrig trigger_off();
	
	barrelBuyTrigger.barrel LinkTo (barrelBuyTrigger.bo);
	barrelBuyTrigger.pourfxorg LinkTo (barrelBuyTrigger.barrel);
	
	//barrelBuyTrigger.liquidclip EnableLinkTo();
	barrelBuyTrigger.liquidclip LinkTo(barrelBuyTrigger.liquid);

	barrelBuyTrigger thread barrelThink();
}

tipBarrelDown()
{	
	self.barrel notsolid ();

	self.bo RotateRoll( 90, 1, 0, 0 );
	
	self.bo waittill  ("rotatedone");
	
	self notify ("barrelTippedDown");
}

tipBarrelUp()
{	
	self.liquid moveZ( -9, 20, 0, 0 );
	
	self.liquid waittill ("movedone");

	self.bo RotateRoll( -90, 1, 0, 0 );
	
	self.bo waittill ("rotatedone");
	
	self.barrel solid();
	
	self notify ("barrelTippedUp");
}

startBarrelPouring ()
{
	pourfx = SpawnFx( level._effect["pourfx"], (self.pourfxorg).origin, anglestoforward((self.pourfxorg).angles), anglestoup((self.pourfxorg).angles) );
	TriggerFX(pourfx);
	
	self thread startLiquidRising ();
	
	self waittill("liquidAtTop");
	
	pourfx delete();
	
	self notify ("liquidReadyForIgnite");
}

startLiquidRising ()
{	
	self.liquid moveZ( 9, 4, 0, 0 );
	
	self.liquid waittill ("movedone");
	
	self notify ("liquidAtTop");
}
	
barrelThink()
{	
	self sethintstring( &"ZOMBIE_ACTIVATE_TRAP" );
	self setCursorHint( "HINT_NOICON" );
	//self.is_available = undefined;
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
						
					self trigger_off();
						
					play_sound_at_pos( "purchase", who.origin );
					
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );
					
					//adding a ramp up time, I'm sure this will be accompanied by audio
					wait(0.5);
					
					self thread tipBarrelDown();		
					self waittill("barrelTippedDown");
					
					self thread startBarrelPouring();
					self waittill("liquidReadyForIgnite");
						
					self thread activateLiquid();
					self waittill("liquidFireDone");
						
					self.liquidDamageTrig trigger_off();
						
					self thread tipBarrelUp(); 
					self waittill("barrelTippedUp");
										
					self trigger_on();
						
					self.in_use = 0;					
				}
			}
		}
	}
}

activateLiquid()
{	
	liquidFirePoints = getent("liquid_fire_origins","targetname");
	
	liquidFirePoints thread liquidFireFx(self);
	
	//do the damage
	self.liquidDamageTrig trigger_on();
	self.liquidDamageTrig thread liquidFireDamage(self);
}

liquidFireFx(notify_ent)
{	
	fireEffect1 = SpawnFx( level._effect["gasfire1"], self.origin, anglestoforward(self.angles), anglestoup(self.angles) );
	fireEffect2 = SpawnFx( level._effect["gasfire2"], self.origin, anglestoforward(self.angles), anglestoup(self.angles) );
	TriggerFX(fireEffect1);
	TriggerFX(fireEffect2);
	
	wait (30);
	
	notify_ent notify ("liquidFireDone");
	fireEffect1 delete();
	fireEffect2 delete();
}

liquidFireDamage(parent)
{	
	while(1)
	{
		self waittill("trigger",ent);
		
		if(isplayer(ent) )
		{
			ent thread playerLiquidFireDamage();
		}
		else
		{
			ent thread zombieLiquidFireDamage();

			//add the round number when player made a kill with the trap.
			parent.used_by.barrel_killed = level.round_number;
				
		}
	}
}

playerLiquidFireDamage()
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

zombieLiquidFireDamage()
{
	self endon("death");
	
	if(level.burning_zombies.size < 6)
	{
		level.burning_zombies[level.burning_zombies.size] = self;
		self thread zombie_flame_watch();
		self playloopsound("fire_manager_0");
		//self thread animscripts\death::flame_death_fx();
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
	playfxontag(level._effect["trap_fire"],self,"tag_origin");
	self dodamage(self.health + 600, self.origin);
}

zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	level.burning_zombies = array_remove_nokeys(level.burning_zombies,self);
}



