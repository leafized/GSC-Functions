#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\Utility;

init()
{
	init_quad_zombie_anims();
	
	level.quad_spawners = GetEntArray( "quad_zombie_spawner", "script_noteworthy" );
	array_thread( level.quad_spawners, ::add_spawn_function, maps\_zombiemode_ai_quad::quad_prespawn );
}

#using_animtree( "generic_human" );
quad_prespawn()
{
	self.animname = "quad_zombie";
	
	self.custom_idle_setup = maps\_zombiemode_ai_quad::quad_zombie_idle_setup;
	
	self.a.idleAnimOverrideArray = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideArray["stand"][0][0] 	= %ai_zombie_quad_idle;
	self.a.idleAnimOverrideWeights["stand"][0][0] 	= 10;
	
	self maps\_zombiemode_spawner::zombie_spawn_init( true );
}

quad_zombie_idle_setup()
{
	
	self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
	self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
	self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
	self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
	self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
	self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
	self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
	self.a.array["turn_right_180"] = %exposed_tracking_turn180L;
	self.a.array["exposed_idle"] = array( %ai_zombie_quad_idle );		
	self.a.array["straight_level"] = %ai_zombie_quad_idle;
	self.a.array["stand_2_crouch"] = %ai_zombie_shot_leg_right_2_crawl;
}

init_quad_zombie_anims()
{
	// deaths
	level.scr_anim["quad_zombie"]["death1"] 	= %ai_zombie_quad_death;
	level.scr_anim["quad_zombie"]["death2"] 	= %ai_zombie_quad_death_2;
	level.scr_anim["quad_zombie"]["death3"] 	= %ai_zombie_quad_death_3;
	level.scr_anim["quad_zombie"]["death4"] 	= %ai_zombie_quad_death_4;

	// run cycles
	level.scr_anim["quad_zombie"]["walk1"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk2"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk3"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk4"] 	= %ai_zombie_quad_crawl_2;
	level.scr_anim["quad_zombie"]["walk5"] 	= %ai_zombie_quad_crawl_2;
	level.scr_anim["quad_zombie"]["walk6"] 	= %ai_zombie_quad_crawl_3;
	level.scr_anim["quad_zombie"]["walk7"] 	= %ai_zombie_quad_crawl_3;
	level.scr_anim["quad_zombie"]["walk8"] 	= %ai_zombie_quad_crawl_3;

	level.scr_anim["quad_zombie"]["run1"] 	= %ai_zombie_quad_crawl_run;
	level.scr_anim["quad_zombie"]["run2"] 	= %ai_zombie_quad_crawl_run_2;
	level.scr_anim["quad_zombie"]["run3"] 	= %ai_zombie_quad_crawl_run_3;
	level.scr_anim["quad_zombie"]["run4"] 	= %ai_zombie_quad_crawl_run_4;
	level.scr_anim["quad_zombie"]["run5"] 	= %ai_zombie_quad_crawl_run_5;
	level.scr_anim["quad_zombie"]["run6"] 	= %ai_zombie_quad_crawl_run;

	level.scr_anim["quad_zombie"]["sprint1"] = %ai_zombie_quad_crawl_sprint;
	level.scr_anim["quad_zombie"]["sprint2"] = %ai_zombie_quad_crawl_sprint_2;
	level.scr_anim["quad_zombie"]["sprint3"] = %ai_zombie_quad_crawl_sprint_3;
	level.scr_anim["quad_zombie"]["sprint4"] = %ai_zombie_quad_crawl_sprint;

	// run cycles in prone
	level.scr_anim["quad_zombie"]["crawl1"] 	= %ai_zombie_crawl;
	level.scr_anim["quad_zombie"]["crawl2"] 	= %ai_zombie_crawl_v1;
	level.scr_anim["quad_zombie"]["crawl3"] 	= %ai_zombie_crawl_v2;
	level.scr_anim["quad_zombie"]["crawl4"] 	= %ai_zombie_crawl_v3;
	level.scr_anim["quad_zombie"]["crawl5"] 	= %ai_zombie_crawl_v4;
	level.scr_anim["quad_zombie"]["crawl6"] 	= %ai_zombie_crawl_v5;
	level.scr_anim["quad_zombie"]["crawl_hand_1"] = %ai_zombie_walk_on_hands_a;
	level.scr_anim["quad_zombie"]["crawl_hand_2"] = %ai_zombie_walk_on_hands_b;

	level.scr_anim["quad_zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["quad_zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["quad_zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;

	if( !isDefined( level._zombie_melee ) )
	{
		level._zombie_melee = [];
	}
	if( !isDefined( level._zombie_walk_melee ) )
	{
		level._zombie_walk_melee = [];
	}
	if( !isDefined( level._zombie_run_melee ) )
	{
		level._zombie_run_melee = [];
	}

	level._zombie_melee["quad_zombie"] = [];
	level._zombie_walk_melee["quad_zombie"] = [];
	level._zombie_run_melee["quad_zombie"] = [];

	level._zombie_melee["quad_zombie"][0] 					= %ai_zombie_quad_attack; 
	level._zombie_melee["quad_zombie"][1] 					= %ai_zombie_quad_attack_2; 
	level._zombie_melee["quad_zombie"][2] 					= %ai_zombie_quad_attack_3; 
	level._zombie_melee["quad_zombie"][3] 					= %ai_zombie_quad_attack_4;	
	level._zombie_melee["quad_zombie"][4]						= %ai_zombie_quad_attack_5;
	level._zombie_melee["quad_zombie"][5]						= %ai_zombie_quad_attack_6;
	level._zombie_melee["quad_zombie"][6]						= %ai_zombie_quad_attack_double;
	level._zombie_melee["quad_zombie"][7]						= %ai_zombie_quad_attack_double_2;
	level._zombie_melee["quad_zombie"][8]						= %ai_zombie_quad_attack_double_3;
	level._zombie_melee["quad_zombie"][9]						= %ai_zombie_quad_attack_double_4;
	level._zombie_melee["quad_zombie"][10]						= %ai_zombie_quad_attack_double_5;
	level._zombie_melee["quad_zombie"][11]						= %ai_zombie_quad_attack_double_6;
	/*
	level._zombie_run_melee["quad_zombie"][0]				=	%ai_zombie_quad_attack;
	level._zombie_run_melee["quad_zombie"][1]				=	%ai_zombie_quad_attack;
	level._zombie_run_melee["quad_zombie"][2]				=	%ai_zombie_quad_attack;
	level._zombie_walk_melee["quad_zombie"][0]			= %ai_zombie_quad_attack;
	level._zombie_walk_melee["quad_zombie"][1]			= %ai_zombie_quad_attack;
	level._zombie_walk_melee["quad_zombie"][2]			= %ai_zombie_quad_attack;
	level._zombie_walk_melee["quad_zombie"][3]			= %ai_zombie_quad_attack;
	*/

	if( isDefined( level.quad_zombie_anim_override ) )
	{
		[[ level.quad_zombie_anim_override ]]();
	}

	// melee in crawl
	if( !isDefined( level._zombie_melee_crawl ) )
	{
		level._zombie_melee_crawl = [];
	}
	level._zombie_melee_crawl["quad_zombie"] = [];
	level._zombie_melee_crawl["quad_zombie"][0] 		= %ai_zombie_attack_crawl; 
	level._zombie_melee_crawl["quad_zombie"][1] 		= %ai_zombie_attack_crawl_lunge;

	if( !isDefined( level._zombie_stumpy_melee ) )
	{
		level._zombie_stumpy_melee = [];
	}
	level._zombie_stumpy_melee["quad_zombie"] = [];
	level._zombie_stumpy_melee["quad_zombie"][0] = %ai_zombie_walk_on_hands_shot_a;
	level._zombie_stumpy_melee["quad_zombie"][1] = %ai_zombie_walk_on_hands_shot_b;

	// tesla deaths
	if( !isDefined( level._zombie_tesla_death ) )
	{
		level._zombie_tesla_death = [];
	}
	level._zombie_tesla_death["quad_zombie"] = [];
	level._zombie_tesla_death["quad_zombie"][0] = %ai_zombie_quad_death_tesla;
	level._zombie_tesla_death["quad_zombie"][1] = %ai_zombie_quad_death_tesla_2;
	level._zombie_tesla_death["quad_zombie"][2] = %ai_zombie_quad_death_tesla_3;
	level._zombie_tesla_death["quad_zombie"][3] = %ai_zombie_quad_death_tesla_4;

	if( !isDefined( level._zombie_tesla_crawl_death ) )
	{
		level._zombie_tesla_crawl_death = [];
	}
	level._zombie_tesla_crawl_death["quad_zombie"] = [];
	level._zombie_tesla_crawl_death["quad_zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_tesla_crawl_death["quad_zombie"][1] = %ai_zombie_tesla_crawl_death_b;


	// deaths
	if( !isDefined( level._zombie_deaths ) )
	{
		level._zombie_deaths = [];
	}
	level._zombie_deaths["quad_zombie"] = [];
	level._zombie_deaths["quad_zombie"][0] = %ai_zombie_quad_death;
	level._zombie_deaths["quad_zombie"][1] = %ai_zombie_quad_death_2;
	level._zombie_deaths["quad_zombie"][2] = %ai_zombie_quad_death_3;
	level._zombie_deaths["quad_zombie"][3] = %ai_zombie_quad_death_4;

	/*
	ground crawl
	*/

	if( !isDefined( level._zombie_rise_anims ) )
	{
		level._zombie_rise_anims = [];
	}

	// set up the arrays
	level._zombie_rise_anims["quad_zombie"] = [];

	level._zombie_rise_anims["quad_zombie"][1]["walk"][0]		= %ai_zombie_traverse_ground_v1_crawl;

	level._zombie_rise_anims["quad_zombie"][1]["run"][0]		= %ai_zombie_traverse_ground_v1_crawlfast;

	level._zombie_rise_anims["quad_zombie"][1]["sprint"][0]	= %ai_zombie_traverse_ground_v1_crawlfast;

	level._zombie_rise_anims["quad_zombie"][2]["walk"][0]		= %ai_zombie_traverse_ground_v1_crawl;

	// ground crawl death
	if( !isDefined( level._zombie_rise_death_anims ) )
	{
		level._zombie_rise_death_anims = [];
	}
	
	level._zombie_rise_death_anims["quad_zombie"] = [];

	level._zombie_rise_death_anims["quad_zombie"][1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims["quad_zombie"][1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;

	level._zombie_rise_death_anims["quad_zombie"][1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims["quad_zombie"][1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;

	level._zombie_rise_death_anims["quad_zombie"][2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims["quad_zombie"][2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;

	level._zombie_rise_death_anims["quad_zombie"][2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims["quad_zombie"][2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;
	
	//taunts
	if( !isDefined( level._zombie_run_taunt ) )
	{
		level._zombie_run_taunt = [];
	}
	if( !isDefined( level._zombie_board_taunt ) )
	{
		level._zombie_board_taunt = [];
	}
	level._zombie_run_taunt["quad_zombie"] = [];
	level._zombie_board_taunt["quad_zombie"] = [];
	
	level._zombie_board_taunt["quad_zombie"][0] = %ai_zombie_quad_taunt;
	level._zombie_board_taunt["quad_zombie"][1] = %ai_zombie_quad_taunt_2;
	level._zombie_board_taunt["quad_zombie"][2] = %ai_zombie_quad_taunt_3;
	level._zombie_board_taunt["quad_zombie"][3] = %ai_zombie_quad_taunt_4;
	level._zombie_board_taunt["quad_zombie"][4] = %ai_zombie_quad_taunt_5;
	level._zombie_board_taunt["quad_zombie"][5] = %ai_zombie_quad_taunt_6;
}