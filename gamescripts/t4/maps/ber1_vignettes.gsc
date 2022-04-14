// scripting by Bloodlust

#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;

#using_animtree ("generic_human");

// handle Berlin 1 vignettes
main()
{
//	level thread vig1();
//	level thread vig2();
//	level thread vig3();
//	level thread vig4();
}

// the epic struggle in the destroyed house
//vig1()
//{
//	endnode = getnode("vig1_cover", "targetname");
//	vig1node = getnode("vig1node", "targetname");
//	
//	//trigger = getEnt("vigtrig1", "targetname");
//	//trigger waittill("trigger");
//	
//	// flag set on trigger
//	flag_wait( "epic_struggle" );
//	
//	spawner = getEnt("vig1_german", "targetname");
//	german = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(german))
//	{
//		german setup_vig_ai("german");
//		german.deathanim = level.scr_anim["german"]["epic_struggle_death"];
//	}
//	
//	spawner = getEnt("vig1_russian", "targetname");
//	russian = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(russian))
//	{
//		russian setup_vig_ai("russian");
//	}
//	
//	guys = [];
//	guys[0] = german;
//	guys[1] = russian;
//	
//	waittillframeend;
//	
//	if(are_vig_guys_alive(german, russian, 1))
//	{
//		if(isalive(german) && isalive(russian))
//		{
//			level anim_reach(guys, "epic_struggle", undefined, vig1node, undefined);
//		}
//		
//		
//		if(isalive(german) && isalive(russian))
//		{
//			russian thread monitor_vig_death(german, 1);
//			german thread monitor_vig_death(russian, 1);
//			level anim_single(guys, "epic_struggle", undefined, vig1node, undefined);
//		}
//		
//		if(isalive(russian))
//		{
//			russian.health = 25;
//			russian enable_ai_color();
//		}
//	}
//}

// German bayonettes a Russian in the office building
//vig2()
//{
//	cover = getnode("vig2_cover", "targetname");
//	vig2node = getnode("vig2_node", "targetname");
//	
//	trigger = getEnt("office_vignette_spawn", "targetname");
//	trigger waittill("trigger");
//	
//	spawner = getEnt("vig2_russian", "targetname");
//	russian = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(russian))
//	{
//		russian setup_vig_ai("russian");
//		russian.deathanim = level.scr_anim["russian"]["bayonette_death"];
//	}
//	
//	wait 1;
//	
//	spawner = getEnt("vig2_german", "targetname");
//	german = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(german))
//	{
//		german setup_vig_ai("german");
//		level.bayonette_killer = german;
//	}
//	
//	guys = [];
//	guys[0] = german;
//	guys[1] = russian;
//	
//	waittillframeend;
//	
//	if(are_vig_guys_alive(german, russian, 2))
//	{
//		level anim_reach(guys, "bayonette", undefined, vig2node, undefined);
//		
//		trigger = getEnt("office_vignette_trigger", "targetname");
//		trigger waittill("trigger");
//		
//		if(isalive(german) && isalive(russian))
//		{
//			russian thread monitor_vig_death(german, 2);
//			german thread monitor_vig_death(russian, 2);
//			level anim_single(guys, "bayonette", undefined, vig2node, undefined);
//		}
//		
//		if(isalive(russian))
//		{
//			russian dodamage(russian.health + 50, russian.origin);
//		}
//		
//		if(isalive(german))
//		{
//			german.health = 100;
//			german.ignoreall = false;
//			german.ignoreme = false;
//			german setgoalnode(cover);
//		}
//	}
//}

// the big fight in front of the office building
//vig3()
//{
//	endnode = getnode("vig3_cover", "targetname");
//	vig3node = getnode("vig3node", "targetname");
//	trigger = getEnt("vigtrig3", "targetname");
//	trigger waittill("trigger");
//	
//	// cancel raidus check for rocket barrage survivors
//	level notify("cancel_enemy_radius_check");
//	
//	spawner = getEnt("vig3_german", "targetname");
//	german = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(german))
//	{
//		german setup_vig_ai("german");
//		german.deathanim = level.scr_anim["german"]["knee_and_headbutt_death"];
//	}
//	
//	spawner = getEnt("vig3_russian", "targetname");
//	russian = spawner stalingradspawn();
//	if(!maps\_utility::spawn_failed(russian))
//	{
//		russian setup_vig_ai("russian");
//	}
//	
//	guys = [];
//	guys[0] = german;
//	guys[1] = russian;
//	
//	waittillframeend;
//	
//	if(are_vig_guys_alive(german, russian, 3))
//	{
//		if(isalive(german) && isalive(russian))
//		{
//			level anim_reach(guys, "knee_and_headbutt", undefined, vig3node, undefined);
//		}
//		
//		if(isalive(german) && isalive(russian))
//		{
//			russian thread monitor_vig_death(german, 3);
//			german thread monitor_vig_death(russian, 3);
//			level anim_single(guys, "knee_and_headbutt", undefined, vig3node, undefined);
//		}
//		
//		if(isalive(russian))
//		{
//			russian.health = 25;
//			russian setgoalnode(endnode);
//		}
//	}
//}

// setup default properties on vignette AI
//setup_vig_ai(ai_team)
//{
//	self.targetname = ai_team;
//	self.animname = ai_team;
//	self.ignoreall = true;
//	self.ignoreme = true;
//	self.goalradius = 32;
//	self.allowdeath = true;
//}

// check if both AI are alive before attempting to play the vignette
//are_vig_guys_alive(german, russian, vig_num)
//{
//	deathnode_g = getnode("vig2_die", "targetname");
//	deathnode_r = getnode("vig3_cover", "targetname");
//	
//	if(!isdefined(german) || !isdefined(russian))
//	{
//		if(!isdefined(german))
//		{
//			iprintln("German didnt spawn for Vignette #" + vig_num);
//		}
//		
//		if(!isdefined(russian))
//		{
//			iprintln("Russian didnt spawn for Vignette #" + vig_num);
//		}
//		
//		if(isdefined(german))
//		{
//			german.ignoreall = false;
//			german.ignoreme = false;
//			german setgoalnode(deathnode_g);
//			german thread elysium_bloody();
//		}
//		
//		if(isdefined(russian))
//		{
//			russian.ignoreme = false;
//			russian setgoalnode(deathnode_r);
//			russian waittill("goal");
//			
//			if(isAlive(russian))
//			{
//				russian thread bloody_death();
//			}
//		}
//		
//		return false;
//	}
//	else
//	{
//		return true;
//	}
//}

// check for interruption of the vignette
// if so, stop the survivor from playing the rest of the vignette
// self = the surviving vignette actor
//monitor_vig_death(otherguy, num)
//{
//	endnode1 = getnode("vig1_cover", "targetname");
//	deathnode = getnode("vig2_die", "targetname");
//	endnode3 = getnode("vig3_cover", "targetname");
//	vig2end = getnode("vig2_cover", "targetname");
//	
//	while(isAlive(self))
//	{
//		if(!isAlive(otherguy))
//		{
//			self StopAnimScripted();
//			
//			self.health = 25;
//			
//			if(num == 1)
//			{
//				if(self.team == "allies")
//				{
//					self setgoalnode(endnode1);
//					self waittill("goal");
//					
//					wait randomfloatrange(0.300, 1.2);
//					
//					if(isAlive(self))
//					{
//						self.ignoreall = false;
//						self.ignoreme = false;
//						self enable_ai_color();
//					}
//				}
//				else
//				{
//					if(isAlive(self))
//					{
//						self setgoalnode(deathnode);
//						self thread elysium_bloody();
//					}
//				}
//			}
//			else
//			{
//				if(self.team == "allies")
//				{
//					self setgoalnode(endnode3);
//					self waittill("goal");
//					
//					wait randomfloatrange(0.300, 1.2);
//					
//					if(isAlive(self))
//					{
//						self.ignoreall = false;
//						self.ignoreme = false;
//						self enable_ai_color();
//					}
//				}
//				else if(num != 2)
//				{
//					if(isAlive(self))
//					{
//						self setgoalnode(deathnode);
//						self thread elysium_bloody();
//					}
//				}
//				else
//				{
//					if(isAlive(self))
//					{
//						self setgoalnode(vig2end);
//						self waittill("goal");
//						
//						self.ignoreall = false;
//						self.ignoreme = false;
//					}
//				}
//			}
//		}
//		
//		wait 0.1;		
//	}
//}