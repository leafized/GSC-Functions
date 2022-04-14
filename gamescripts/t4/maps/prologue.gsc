#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim; 

#using_animtree( "generic_human" ); 
main()
{
	PrecacheModel( "tag_origin" ); 
	PrecacheModel( "weapon_jap_katana_long" );
	PrecacheModel( "viewmodel_usa_player" );
	PrecacheShellshock( "concussion_grenade_mp" );
	// Sets up the onPlayerconnect/disconnect, etc
	maps\prologue_net::main();
	
	maps\_flare::main( "tag_origin", undefined, "white" );
	
	add_start( "flare", ::begin_event2 );
	add_start( "decapitate", ::begin_event3 );
	default_start( ::begin_event1 ); 
	
	level._effect["grenade_ph"] = loadfx("weapon/grenade/fx_grenade_explosion_body");
	level._effect["grenade_flesh_ph"] = loadfx("impacts/flesh_hit_head_fatal_exit");
	
	maps\_load::main();
	
	maps\prologue_anim::main();
	
	setup_threat_bias();
	
	// LDS - used to debug engagement distance stuff
	level.deletefriends = false;
	
	setup_foxhole1();
	setup_foxhole2();
	setup_foxhole3();
	
	level.near_player_nodes = GetEntArray( "near_player_node", "targetname" );
	level.side1goalNodes = GetNodeArray( "goal_side1_node", "script_noteworthy" );
	level.side3goalNodes = GetNodeArray( "goal_side3_node", "script_noteworthy" );
	level.default_goalradius = 64;
	
	level.anim_node = GetNode( "anim_origin", "script_noteworthy" );
	
	pathbreaks = GetEntArray( "pathbreakbrush", "script_noteworthy" );
	for( i = 0; i < pathbreaks.size; i++ )
	{
		pathbreaks[i] delete();
	}
	
	battlechatter_off( "allies" );
	
	resting_spot = getvehiclenode( "flare_fade_node", "script_noteworthy" );
	start_spot = GetEnt( "flare_origin", "targetname" );
	level.strobe_direction = (  resting_spot.origin -  start_spot.origin );
	
	VisionSetNaked( "mak", 0.1 ); 
	SetSavedDvar( "hud_showStance", 0 );
	SetSavedDvar( "compass", "0" );
}

setup_foxhole1()
{
	level.foxhole1Wave1Spawners = [];
	for( i = 0; i < 3; i++ )
	{
		level.foxhole1FriendlyArray[i] = setup_friendly( "friendanim"+(i+1)+"Foxhole1", "script_noteworthy" );
		level.foxhole1FriendlyArray[i].candamage = false;
		level.foxhole1FriendlyArray[i].Nofriendlyfire = true;
		assert( isDefined( level.foxhole1FriendlyArray[i] ) );
		level.foxhole1FriendlyArray[i].deathanim = %ch_peleliu1_bayonet_guy3_dead;
		level.foxhole1Wave1Spawners = array_add( level.foxhole1Wave1Spawners, getEnt( "anim"+(i+1)+"Foxhole1", "script_noteworthy" ) );
		level.foxhole1FriendlyArray[i] thread magic_bullet_shield();
	}
	level.foxhole1Wave2Spawners = getEntArray( "wave2Foxhole1", "targetname" );
}

setup_foxhole2()
{
	if( level.deletefriends )
	{
		level.officer = setup_friendly( "officer", "script_noteworthy" );
		level.grant = setup_friendly( "grant", "script_noteworthy" );
		level.officer Delete();
		level.grant Delete();
	}
	else
	{
		level.officer = setup_friendly( "officer", "script_noteworthy" );
		level.officer.animname = "Sarge";
		level.officer thread magic_bullet_shield();
		level.officer setThreatBiasGroup( "corky" );
		level.officer.Nofriendlyfire = true;
		level.officer.goalradius = 4;
		
		level.grant = setup_friendly( "grant", "script_noteworthy" );
		level.grant.animname = "PvtGrant";
		level.grant thread magic_bullet_shield();
		level.grant setThreatBiasGroup( "grant" ); 
		level.grant.Nofriendlyfire = true;
		level.grant.goalradius = 4;
	}
	
	level.foxhole2Wave1Spawners = getEntArray( "wave1Foxhole2", "targetname" );
	
	wait_for_first_player();
	level.players = get_players();
	level.players[0] AllowProne( false );
	level.players[0] AllowStand( false );
	level.players[0] AllowJump( false );
	level.players[0] SetWeaponAmmoClip( "colt", 7 );
	level.players[0] SetWeaponAmmoClip( "m1garand", 0 );
	level.players[0] SetWeaponAmmoStock( "colt", 28 );
	level.players[0] SetWeaponAmmoStock( "m1garand", 0 );
	level.players[0] setThreatBiasGroup( "player" );
	level.players[0] setup_timer_hudelems();
	
	level.startInvulnerableTime = GetDvarInt( "player_deathInvulnerableTime" );
	setsaveddvar( "player_deathInvulnerableTime", 70000 );
}

setup_foxhole3()
{
	level.foxhole3Wave1Spawners = [];
	for( i = 0; i < 3; i++ )
	{
		level.foxhole3FriendlyArray[i] = setup_friendly( "friendanim"+(i+1)+"Foxhole3", "script_noteworthy" );
		level.foxhole3FriendlyArray[i].candamage = false;
		level.foxhole3FriendlyArray[i].Nofriendlyfire = true;
		level.foxhole3FriendlyArray[i] thread magic_bullet_shield();
		assert( isDefined( level.foxhole3FriendlyArray[i] ) );
		if( i == 1 )
		{
			level.foxhole3FriendlyArray[i].deathanim = %ai_bonzai_buddy_fail_rear;
			level.foxhole3FriendlyArray[i].animname = "fightback";
		}
		else
		{
			level.foxhole3FriendlyArray[i].deathanim = %ch_bayonet_flipover_guy2;
		}
		level.foxhole3Wave1Spawners = array_add( level.foxhole3Wave1Spawners, getEnt( "anim"+(i+1)+"Foxhole3", "script_noteworthy" ) );
	}
	level.foxhole3Wave2Spawners = getEntArray( "wave2Foxhole3", "targetname" );
}

setup_threat_bias()
{
	CreateThreatBiasGroup( "grant" );
	CreateThreatBiasGroup( "corky" );
	CreateThreatBiasGroup( "friendly" );
	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "foxhole1" );
	CreateThreatBiasGroup( "foxhole2" );
	CreateThreatBiasGroup( "foxhole3" );
	
	// Enemies favor the hero on their side
	SetThreatBias( "grant", "foxhole3", 2000 );
	SetThreatBias( "grant", "foxhole2", 500 );
	SetThreatBias( "grant", "foxhole1", -2000 );
	
	SetThreatBias( "corky", "foxhole1", 2000 );
	SetThreatBias( "corky", "foxhole2", 500 );
	SetThreatBias( "corky", "foxhole3", -2000 );
	
	// All enemies have no threat for friendlies (who will be animated)
	SetThreatBias( "friendly", "foxhole1", -10000 );
	SetThreatBias( "friendly", "foxhole2", -10000 );
	SetThreatBias( "friendly", "foxhole3", -10000 );
	
	
	// Side foxholes do not favor the player (we want them looking down the center)
	SetThreatBias( "player", "foxhole1", -2000 );
	SetThreatBias( "player", "foxhole2", 700 );
	SetThreatBias( "player", "foxhole3", -2000 );
	
	// All friendlies favor the foxhole on their side, except for the redshirts
	SetThreatBias( "foxhole3", "grant", 2000 );
	SetThreatBias( "foxhole2", "grant", 500 );
	SetThreatBias( "foxhole1", "grant", -2000 );
	
	SetThreatBias( "foxhole1", "corky", 2000 );
	SetThreatBias( "foxhole2", "corky", 500 );
	SetThreatBias( "foxhole3", "corky", -2000 );
	
	SetThreatBias( "foxhole1", "friendly", -10000 );
	SetThreatBias( "foxhole2", "friendly", -10000 );
	SetThreatBias( "foxhole3", "friendly", -10000 );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Level Events
// 1: Officer gives the player background and mood setting, ie lets the player know they are low on ammo and they
//    are awaiting reinforments. There is noise and a scout goes out to investigate. A thump is heard.
// 2: The officer whispers the scout's name several times and a flare is sent up. The first wave of Japanese troops are 
//    revealed. There is a moment surprise where the Americans do some damage to the Japanese. Casualties occur on both
//    sides.
// 3: When the Japanese ranks have been thinned a bit, a second and third wave comes in, led by two officers with katanas. The
//		player either runs out of ammunition or a timer runs out and he is warned of someone behind him. Either we take
//    the camera and jerk it to look at the attacker or we see the blade and spray of blood as the player is 
//    decapitated from behind. The camera then rolls and settles, showing the officer turning to look at approaching
//    figures in the darkness. Fade to black
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
begin_event1()
{
	level waittill("controls_active");
	level thread event1_foxhole2();
	level waittill("introscreen_complete");
	level thread event1_timer();
	level thread event1_foxhole1();
	level thread event1_foxhole3();
	
	wait( 15 );
	begin_event2();
}

// Event 1 Foxhole specific
event1_foxhole1()
{
	level endon ("begin event2");
	wait( 14 );
	level.foxhole1FriendlyArray[2] playSound( "GRAN_BC_002A" );
	
}

event1_foxhole2()
{
	level endon ("begin event2");
	if( !level.deletefriends )
	{
		level.officer allowedstances( "crouch" );
		level.grant allowedstances( "crouch" );
	}
	level.players[0] AllowStand( true );
	level.players[0].ignoreme = true;
	if( !level.deletefriends )
	{
		level.anim_node anim_reach_solo( level.officer, "reinforce", undefined, level.anim_node, undefined );
		level.grant thread anim_single_solo( level.grant, "radio", undefined, level.anim_node );
		level.officer thread anim_single_solo( level.officer, "reinforce", undefined, level.anim_node );
	}
	wait( 9.5 );
	level.players[0] SetWeaponAmmoStock( "m1garand", 8 );
	level.players[0] SwitchToWeapon( "m1garand" );
	wait( 2 );
}

event1_foxhole3()
{
	level endon ("begin event2" );
}

begin_event2()
{
	level notify("begin event2" );
	level thread event2_timer();
	// Run the foxholes
	level thread event2_foxhole1();
	level thread event2_foxhole2();
	level thread event2_foxhole3();
	
	// World Flare Effects
	level thread wait_for_strobe();
	level thread wait_for_final_flicker(); 

	wait( 27 );
	
	begin_event3();
}

event2_foxhole1()
{
	level endon( "begin event3" );
	spawn_foxhole1_waves();
	//LDS: Get the flare guy in position to fire his flare and play muffled scream
	//thread maps\_flare::flare_from_targetname( "flare", 0.9, 1, 0.4, ( 0.83, 0.82, 1 ) );
	thread maps\_flare::flare_from_targetname( "flare", 1, 2, 0.4, ( 0.83, 0.82, 1 ) );
	flag_wait( "flare_start_setting_sundir" );
	thread activate_foxhole1_waves();
	for( i = 0; i < level.foxhole1Wave1.size; i++ )
	{
		level.foxhole1Wave1[i] notify( "stop looping" );
	}
	for( i = 0; i < level.foxhole1Wave1.size; i++ )
	{
		level.foxhole1Wave1[i] show();
		level.foxhole1Wave1[i].activatecrosshair = true;
	}
	wait( 4 );
	
}

event2_foxhole2()
{
	level endon( "begin event3" );
	level.players[0] AllowStand( true );
	flag_wait("flare_in_use");
	level thread wait_for_bloom();
	
	if( !level.deletefriends )
	{
		level.officer thread anim_single_solo( level.officer, "flare_wait" );
		level.grant thread anim_single_solo( level.grant, "flare_wait" );
	}
	
	thread spawn_foxhole2_waves();
	
	flag_wait( "flare_start_setting_sundir" );
	if( !level.deletefriends )
	{
		level.officer thread anim_single_solo( level.officer, "flare_explode" );
	}
	for( i = 0; i < level.foxhole2Wave1.size; i++ )
	{
		if( isDefined( level.foxhole2Wave1[i] ) )
		{
			level.foxhole2Wave1[i] show();
			level.foxhole2Wave1[i] thread magic_bullet_shield();
			level.foxhole2Wave1[i].activatecrosshair = true;
		}
	}
	wait( 0.5 );
	level.players[0].ignoreme = false;
	if( !level.deletefriends )
	{
		level thread do_friendly_battlechatter();
		level.grant.ignoreme = false;
		level.officer.ignoreme = false;
	}
	
	thread activate_foxhole2_waves();
	thread activate_friendlies();
	wait(14);
	grenade_spawner = GetEnt( "grenade_suicide", "script_noteworthy" );
	level.grenade_ent = grenade_spawner spawn_entity();
	level.grenade_ent allowedStances( "stand" );
	level.grenade_ent.animname = "grenadeGuy";
	level.grenade_ent SetGoalPos( level.grenade_ent.origin );
	level.grenade_ent thread magic_bullet_shield();
	level.grenade_ent hide();
	level.grenade_ent anim_single_solo( level.grenade_ent, "getupStandup" );
	level.grenade_ent.pathenemylookahead = 0;
	level.grenade_ent.goalradius = 4;
	wait( 4.5 );
	level.grenade_ent show();
	level.grenade_ent set_generic_run_anim( "banzai" );
	level.grenade_ent setGoalNode( GetNode( level.grenade_ent.target, "targetname" ) );
	wait( 3 );
}

event2_foxhole3()
{
	level endon( "begin event3" );
	thread spawn_foxhole3_waves();
	flag_wait( "flare_start_setting_sundir" );
	for( i = 0; i < level.foxhole3Wave1.size; i++ )
	{
		level.foxhole3Wave1[i] show();
		level.foxhole3Wave1[i].activatecrosshair = true;
		level.foxhole1Wave1[i] notify( "stop looping" );
	}
	thread activate_foxhole3_waves();
}

begin_event3()
{
	level notify( "begin event3" );
	level thread event3_timer();
	level thread event3_foxhole1();
	level thread event3_foxhole2();
	level thread event3_foxhole3();
	// Either the player camera is grabbed and turned to see the officer's sword coming down or we see the blade
	// and a spray of blood
	
	// lerp the player during fx to a good place
	
	// do the camera roll for decapitation
}

event3_foxhole1()
{
}

event3_foxhole2()
{
	level.players[0] SetStance( "crouch" );
	anim_start_origin = GetEnt( "fall_origin", "targetname" );
	animname = "player_interactive";
	hands = spawn_anim_model( animname );
	hands Hide();
	hands.origin = anim_start_origin.origin;
	hands.angles = anim_start_origin.angles;
	hands.attachedplayer = level.players[0];
	
	sword_officer = spawn_wave_of_mutilation();
	
	level.players[0] thread do_decapitation_event(hands, sword_officer );
	// Set their origins properly here
	if( !level.deletefriends )
	{
		wait( 3.5 );
		struggle_array = [];
		struggle_array = array_add( struggle_array, level.officer );
		struggle_array = array_add( struggle_array, level.officer_enemy );
		level.officer.ignoreme = true;
		level.officer.ignoreall = true;
		level.anim_node thread anim_single( struggle_array, "finalEvent", undefined, undefined,level.anim_node );
		wait(3.75);
		bayonet_array = [];
		bayonet_array = array_add( bayonet_array, level.grant );
		level.grant.deathanim = %ch_prologue_end_bayonet_guy1;
		bayonet_array = array_add( bayonet_array, level.grant_enemy );
		level.grant.ignoreme = true;
		level.grant.ignoreall = true;
		level.anim_node thread anim_single( bayonet_array, "finalEvent", undefined, undefined, level.anim_node );
		if( level.grant.magic_bullet_shield )
		{
			level.grant stop_magic_bullet_shield();
		}
		level.grant DoDamage( level.grant.health + 5,(0,180,48) );
		wait( 4 );
		level.grant_enemy hide();
	}
}

event3_foxhole3()
{
}

do_decapitation_event( hands, sword_officer )
{
	if( isDefined( level.grenade_ent ) )
	{
		explode_origin = level.grenade_ent getTagOrigin( "J_Spine4" );
		explode_orient = anglestoforward( vectortoangles( level.grenade_ent.origin - level.players[0].origin ) );
		playfx( level._effect["grenade_ph"], explode_origin, explode_orient );
		playfx( level._effect["grenade_flesh_ph"], explode_origin, explode_orient );
		level.grenade_ent playSound( "rpg_impact_boom" );
		if( isDefined( level.grenade_ent.magic_bullet_shield ) )
		{
			level.grenade_ent stop_magic_bullet_shield();
		}
		level.grenade_ent doDamage( level.grenade_ent.health+5, (0,180,48) );
	}
	else
	{
		explode_origin = GetEnt( "explode_origin", "targetname" );
		playfx( level._effect["grenade_ph"], explode_origin.origin );
	}
	// LDS: look_origin and kill_origin are temps until we get the final turn/decapitate anim
	look_origin = GetEnt( "look_origin", "targetname" );
	kill_origin = GetEnt( "kill_origin", "targetname" );
	// END TEMP
	
	//self FreezeControls(true);
	self.ignoreme = true;
	self DisableWeapons();
	//hands show();
	self shellshock( "concussion_grenade_mp", 2 );
	self lerp_player_view_to_tag( hands, "tag_player", 1.75, 1, 0, 0, 0, 0  );
	
	wait( 2 );
	
	// LDS: Temp on decap animation
	hands lerp_to_pos_orient( 1.25, look_origin.origin, look_origin.angles );
	wait( 1.2 );
	sword_officer gun_remove();
	hands thread lerp_to_pos_orient( 4.25, kill_origin.origin, (look_origin.angles[0], kill_origin.angles[1], kill_origin.angles[2]) );
	wait( 1.25 );
	level thread do_gradual_timescale( 0.5, 1, 0.2 );
	wait( 0.6 );
	level thread do_gradual_timescale( 0.5, 0.2, 0.6 );
	wait( 1.6 );
	sword_officer thread anim_single_solo( sword_officer, "beheaded" );
	// END TEMP
	wait( 0.2 );
	hands thread lerp_to_pos_orient( 0.3, kill_origin.origin, kill_origin.angles);
	wait( 0.35 );
	self playerlinktoabsolute( hands, "tag_player" );
	level thread do_gradual_timescale( 0.5, 0.6, 1);
	hands AnimScripted( "player_beheaded_anim", hands.origin, hands.angles, level.scr_anim["player_interactive"]["beheaded"] );
	wait( 3 );
	level notify( "final_flicker" );
	wait( 4 );
	setsaveddvar( "player_deathInvulnerableTime", level.startInvulnerableTime );
	nextmission_wait();
}



//////////////////////////////////////////////
// Helper Functions
//////////////////////////////////////////////

//Setup
setup_friendly( value, key )
{
	ent = GetEnt( value, key );
	ent set_startup_vars();
	return ent;
}

set_startup_vars()
{
	self allowedStances( "crouch" );
	self.ignoreall = true;
	self.ignoreme = true;
}

spawn_foxhole1_waves()
{
	level.foxhole1Wave1 = [];
	level.foxhole1Wave2 = [];
	
	
	for( i = 0; i < level.foxhole1Wave1Spawners.size; i++ )
	{
		level.foxhole1Wave1[i] = level.foxhole1Wave1Spawners[i] spawn_entity();
		level.foxhole1Wave1[i].animname = "bayonet_enemy1";
		if( i == 1 )
		{
			level.foxhole1Wave1[i].animname = "bayonet_enemy1_alt";
		}
		level.foxhole1Wave1[i] thread magic_bullet_shield();
		level.foxhole1Wave1[i].candamage = false;
		level.foxhole1Wave1[i].ignoreall = true;
		level.foxhole1Wave1[i].ignoreme = true;
		level.foxhole1Wave1[i].pathenemylookahead = 0;
		level.foxhole1Wave1[i].script_noteworthy = level.foxhole1Wave1Spawners[i].script_noteworthy+"_ent";
		level.foxhole1Wave1[i] hide();
		level.foxhole1Wave1[i].activatecrosshair = false;
		level.foxhole1Wave1[i] setThreatBiasGroup( "foxhole1" );
		level.foxhole1Wave1[i] allowedStances( "stand" );
		level.foxhole1Wave1[i].goalradius = 32;
		if( level.foxhole1Wave1[i].script_noteworthy == "anim2" )
		{
			level.foxhole1Wave1[i].deathanim = %ch_bayonet_jumpin_guy1;
		}
	}
	
	for( i = 0; i < level.foxhole1Wave2Spawners.size; i++ )
	{
		level.foxhole1Wave2[i] = level.foxhole1Wave2Spawners[i] spawn_entity();
		level.foxhole1Wave2[i].ignoreall = true;
		level.foxhole1Wave2[i] hide();
		level.foxhole1Wave2[i].activatecrosshair = false;
		level.foxhole1Wave2[i] setThreatBiasGroup( "foxhole1" );
		level.foxhole1Wave2[i] allowedStances( "prone" );
	}
}

spawn_foxhole2_waves()
{
	level.foxhole2Wave1 = [];
	
	i = 0;
	num_guys = 9;
	while( i < num_guys )
	{
		ent = getEnt( "center"+(i+1), "script_noteworthy" );
		level.foxhole2Wave1[i] = ent spawn_entity();
		//level.foxhole2Wave1[i].ignoreall = true;  // TEMP
		level.foxhole2Wave1[i] SetGoalPos( level.foxhole2Wave1[i].origin );
		level.foxhole2Wave1[i].pathenemylookahead = 0;
		level.foxhole2Wave1[i].script_noteworthy = ent.script_noteworthy+"_ent";
		level.foxhole2Wave1[i] hide();
		level.foxhole2Wave1[i].activatecrosshair = false;
		level.foxhole2Wave1[i] setThreatBiasGroup( "foxhole2" );
		level.foxhole2Wave1[i] allowedStances( "prone" );
		//level.foxhole2Wave1[i] set_generic_run_anim( "banzai" );  // DEPRECATED

		i++;
	}
	/*for( i = 0; i < level.foxhole2Wave1Spawners.size; i++ )
	{
		level.foxhole2Wave1[i] = level.foxhole2Wave1Spawners[i] spawn_entity();
		level.foxhole2Wave1[i].ignoreall = true;
		level.foxhole2Wave1[i].script_noteworthy = level.foxhole2Wave1Spawners[i].script_noteworthy+"ent";
		level.foxhole2Wave1[i] hide();
		level.foxhole2Wave1[i].activatecrosshair = false;
		level.foxhole2Wave1[i] setThreatBiasGroup( "wave1" );
		level.foxhole2Wave1[i] allowedStances( "prone" );
	}*/
}

// self = an AI
ignore_til_goal()
{
	self endon( "death" );
	
	self thread ignoreAllEnemies( true );
	self waittill( "goal" );
	self thread ignoreAllEnemies( false );
}

spawn_foxhole3_waves()
{
	level.foxhole3Wave1 = [];
	level.foxhole3Wave2 = [];

	for( i = 0; i < level.foxhole3Wave1Spawners.size; i++ )
	{
		level.foxhole3Wave1[i] = level.foxhole3Wave1Spawners[i] spawn_entity();
		level.foxhole3Wave1[i].animname = "bayonet_enemy3";
		level.foxhole3Wave1[i] thread magic_bullet_shield();
		level.foxhole3Wave1[i].ignoreme = true;
		level.foxhole3Wave1[i].pathenemylookahead = 0;
		level.foxhole3Wave1[i].candamage = false;
		level.foxhole3Wave1[i].ignoreall = true;
		level.foxhole3Wave1[i].script_noteworthy = level.foxhole3Wave1Spawners[i].script_noteworthy+"_ent";
		level.foxhole3Wave1[i] hide();
		level.foxhole3Wave1[i].activatecrosshair = false;
		level.foxhole3Wave1[i] setThreatBiasGroup( "foxhole3" );
		level.foxhole3Wave1[i] allowedStances( "crouch" );
		level.foxhole3Wave1[i].goalradius = 32;
		
		if( level.foxhole3Wave1[i].script_noteworthy == "anim2" )
		{
			level.foxhole3Wave1[i].deathanim = %ch_bayonet_jumpin_guy1;
		}
	}

	for( i = 0; i < level.foxhole3Wave2Spawners.size; i++ )
	{
		level.foxhole3Wave2[i] = level.foxhole3Wave2Spawners[i] spawn_entity();
		level.foxhole3Wave2[i].ignoreall = true;
		level.foxhole3Wave2[i] hide();
		level.foxhole3Wave2[i].activatecrosshair = false;
		level.foxhole3Wave2[i] setThreatBiasGroup( "foxhole3" );
		level.foxhole3Wave2[i] allowedStances( "prone" );
	}
}

spawn_wave_of_mutilation()
{
	spawnArray = [];
	waveOfMutilation = [];
	
	spawnArray = GetEntArray( "waveOfMutilation", "targetname" );
	for( i = 0; i < spawnArray.size; i++ )
	{
		waveOfMutilation[i] = spawnArray[i] spawn_entity();
		waveOfMutilation[i].ignoreall = true;
		waveOfMutilation[i].ignoreme = true;
		waveOfMutilation[i] show();
		waveOfMutilation[i] allowedStances( "crouch" );
		if( isDefined( waveOfMutilation[i].script_noteworthy ) && waveOfMutilation[i].script_noteworthy == "sargeVs" )
		{
			level.officer_enemy = waveOfMutilation[i];
			waveOfMutilation[i].animname = "SargeVs";
		}
		if( isDefined( waveOfMutilation[i].script_noteworthy) && waveOfMutilation[i].script_noteworthy == "grantVs"  )
		{
			level.grant_enemy = waveOfMutilation[i];
			waveOfMutilation[i].animname = "PvtGrantVs";
		}
	}
	
	spawner = GetEnt( "sword_officer", "targetname" );
	sword_officer = spawner spawn_entity();
	sword_officer.ignoreme = true;
	sword_officer.ignoreall = true;
	sword_officer.goalradius = 4;
	//sword_officer gun_remove();
	sword_officer.animname = "KatanaGuy";
	sword_officer thread magic_bullet_shield();
	sword_officer attach( "weapon_jap_katana_long", "tag_weapon_left" );
	return sword_officer;
}

spawn_entity( spawn )
{
    spawn = self spawn_ai(); 

    if ( spawn_failed( spawn ) ) 
    {
         assertex( 0, "spawn failed from prologue::spawn_entity()" );
         return;               
    }
    spawn endon( "death" );
    spawn.health = 400;
    return spawn;
}

//AI
activate_foxhole1_waves()
{
	for( i = 0; i < level.foxhole1FriendlyArray.size; i++ )
	{
		level.foxhole1FriendlyArray[i] allowedStances( "stand" );
	}
	
	for( i = 0; i < level.foxhole1Wave1.size; i++ )
	{
		level.foxhole1Wave1[i] thread stagger_standing( 0.1 );
	}
	thread do_foxhole1_trench_combat();
	wait( 14 );
	for( i = 0; i < level.foxhole1Wave2.size; i++ )
	{
		if( isDefined( level.foxhole1Wave2[i] ) )
		{
			level.foxhole1Wave2[i] show();
			level.foxhole1Wave2[i].ignoreme = false;
			level.foxhole1Wave2[i].ignoreall = false;
			level.foxhole1Wave2[i].goalradius = 32;
			level.foxhole1Wave2[i] allowedStances("stand");
			level.foxhole1Wave2[i] setGoalNode( GetNode( "foxhole1_cover"+(i+1), "targetname" ) );
		}
	}
}

activate_foxhole2_waves()
{
	for( i = 0; i < level.foxhole2Wave1.size; i++ )
	{
		if( isDefined( level.foxhole2Wave1[i] ) ) 
		{
			level.foxhole2Wave1[i].ignoreme = false;
			//level.foxhole2Wave1[i].ignoreall = false;  // TEMP
		}
	}
	thread do_center_standing();
}

activate_foxhole3_waves()
{
	for( i = 0; i < level.foxhole3Wave1.size; i++ )
	{
		level.foxhole3Wave1[i] stagger_standing( 0.15 );
	}
	for( i = 0; i < level.foxhole3FriendlyArray.size; i++ )
	{
		level.foxhole3FriendlyArray[i] allowedStances( "stand" );
	}
	thread do_foxhole3_trench_combat();
	wait( 10 );
	for( i = 0; i < level.foxhole3Wave2.size; i++ )
	{
		if( isDefined( level.foxhole3Wave2[i] ) )
		{
			level.foxhole3Wave2[i] show();
			level.foxhole3Wave2[i].ignoreme = false;
			level.foxhole3Wave2[i].ignoreall = false;
			level.foxhole3Wave2[i].goalradius = 32;
			level.foxhole3Wave2[i] allowedStances("stand");
			level.foxhole3Wave2[i] setGoalNode( GetNode( "foxhole3_cover"+(i+1), "targetname" ) );
		}
	}
}

activate_friendlies()
{
	// TODO make dvar activated
	if( level.deletefriends )
	{
		return;
	}
	
	corky_node = GetNode( "corky_node", "targetname" );
	level.officer.ignoreme = false;
	level.officer.ignoreall = false;
	level.officer allowedStances( "prone", "crouch", "stand" );
	level.officer SetGoalNode( corky_node );
	
	grant_node = GetNode( "grant_node", "targetname" );
	level.grant.ignoreme = false;
	level.grant.ignoreall = false;
	level.grant allowedStances( "prone", "crouch", "stand" );
	level.grant SetGoalNode( grant_node );
}

do_center_standing()
{
	targeting_count = 2;
	standing_count = 3;
	current_stander = 1;
	standing_array = [];
	targeting_array = [];
	for( i = 0; i < standing_count; i++ )
	{
		ent = GetEnt( "center"+current_stander+"_ent", "script_noteworthy" );
		if( isDefined( ent ) && ent.health > 0 )
		{
			ent allowedstances("stand");
			standing_array = array_add( standing_array, ent );
			if( isDefined( ent.magic_bullet_shield ) )
			{
				ent thread stop_magic_bullet_soon( 0.5 );
			}
			ent SetGoalNode( GetNode( "goal_node"+(i+1), "targetname" ) );
			if( i < targeting_count )
			{
				targeting_array = array_add( targeting_array, ent );
			}
			else
			{
				random = randomint( level.near_player_nodes.size-1 );
				ent setEntityTarget( level.near_player_nodes[random] );
			}
			wait( randomfloatrange(0.1, 0.2) );
		}
		else
		{
			i--;
		}
		current_stander++;
	}
	assert( standing_array.size == standing_count );
	assert( targeting_array.size == targeting_count );
	
	for(;;)
	{
		for( i = 0; i < standing_array.size; i++ )
		{
			
			if( !isDefined( standing_array[i] ) )
			{
				ent = GetEnt( "center"+current_stander+"_ent", "script_noteworthy" );
				if( isDefined( ent ) && ent.health > 0 )
				{
					ent allowedstances("stand");
					standing_array[i] = ent;
					if( isDefined( ent.magic_bullet_shield ) )
					{
						ent thread stop_magic_bullet_soon( 1.5 );
					}
					ent SetGoalNode( GetNode( "goal_node"+(i+1), "targetname" ) );
				}
				current_stander++;
				if( current_stander > 6 )
				{
					break;
				}
			}
		}
		for( i = 0; i < targeting_array.size; i++ )
		{
			if( !isDefined( targeting_array[i] ) )
			{
				for( j = 0; j < standing_array.size; j++ )
				{
					if( isDefined( targeting_array[i] ) && !array_check_for_dupes( standing_array, targeting_array[i] ) )
					{
						targeting_array[i] = standing_array[j];
						targeting_array[i] ClearEntityTarget();
						break;
					}
				}
			}
		}
		wait( 0.05 );
	}
}

stop_magic_bullet_soon(time)
{
	wait( time );
	if( isDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}
}

do_foxhole1_trench_combat()
{
	for( i = 0; i < level.foxhole1Wave1.size; i++ )
	{
		level.foxhole1Wave1[i] allowedStances( "stand" );
		
		level.foxhole1FriendlyArray[i].animname = "bayonet_friendly1";
		// Set up the array of guys to pass into the anim_loop
		bayonet_array = [];
		bayonet_array = array_add ( bayonet_array, level.foxhole1Wave1[i] );
		bayonet_array = array_add ( bayonet_array, level.foxhole1FriendlyArray[i] );
		level thread do_individual_combat( bayonet_array, i, 1, "stab", false, true, "stop looping" );
		wait( randomfloatrange( 0.2, 0.4 ) );
	}
	wait(5);
	activate_enemy_motion_pincer( level.foxhole1Wave1, 1 );
	for( i = 0; i < level.foxhole1Wave1.size; i++ )
	{
		if( isDefined( level.foxhole1Wave1[i] ) )
		{
			level.foxhole1Wave1[i].candamage = true;
			level.foxhole1Wave1[i].ignoreme = false;
			level.foxhole1Wave1[i].ignoreall = false;
		}
	}
}

do_foxhole3_trench_combat()
{
	for( i = 0; i < level.foxhole3Wave1.size; i++ )
	{
		level.foxhole3FriendlyArray[i].animname = "bayonet_friendly3";
		level.foxhole3Wave1[i] allowedStances( "stand" );
		// Set up the array of guys to pass into the anim_loop
		bayonet_array = [];
		bayonet_array = array_add ( bayonet_array, level.foxhole3Wave1[i] );
		bayonet_array = array_add ( bayonet_array, level.foxhole3FriendlyArray[i] );
		if( i == 1 )
		{
			anime = "fightback";
			reach = false;
		}
		else
		{
			anime = "flipover";
			reach = true;
		}
		level thread do_individual_combat( bayonet_array, i, 3, anime, reach );
		wait( randomfloatrange( 0.2, 0.4 ) );
	}
	wait( 1 );
	bayonet_array = [];
	killer = level.foxhole3Wave1[2];
	killee = level.foxhole3FriendlyArray[1];
	bayonet_array = array_add( bayonet_array, killer );
	bayonet_array = array_add( bayonet_array, killee );
	anim_org = GetNode( "seconddeathnode", "script_noteworthy" );
	anim_org anim_reach( bayonet_array, "secondDeath", undefined, undefined, anim_org );
	level anim_single( bayonet_array, "secondDeath", undefined, undefined, anim_org ); 
	if( isDefined( killee ) )
		killee doDamage(killee.health + 5,(0,180,48));
	activate_enemy_motion_pincer( level.foxhole3Wave1, 3 );
	for( i = 0; i < level.foxhole3Wave1.size; i++ )
	{
		if( isDefined( level.foxhole3Wave1[i] ) )
		{
			level.foxhole3Wave1[i].candamage = true;
			level.foxhole3Wave1[i].ignoreme = false;
			level.foxhole3Wave1[i].ignoreall = false;
		}
	}
}

do_individual_combat( bayonet_array, animator, foxhole, animname, reach, loop, loop_cond )
{
	die_index = 1;
	other_index = 0;
	deathstring = "deathnode"+(animator+1)+""+foxhole;
	anim_org = getNode( deathstring, "script_noteworthy" );
	if( animator == 1 && foxhole == 3 )
	{
		die_index = 0;
		other_index = 1;
	}
	if( reach ) 
	{
		anim_org anim_reach ( bayonet_array, animname, undefined, undefined, anim_org);
	}
	if( !isDefined( bayonet_array[0] ) || !isDefined( bayonet_array[1] ) || bayonet_array[0].health < 0 || bayonet_array[1].health < 0 )
	{
		return;
	}
	if( isDefined( loop ) && loop ) 
	{
		bayonet_array[0] thread anim_loop_solo ( bayonet_array[other_index], animname, undefined, loop_cond, anim_org );
		//anim_org thread anim_single_solo ( bayonet_array[1], animname, undefined, anim_org );
	}
	else
	{
		anim_org thread anim_single_solo ( bayonet_array[other_index], animname, undefined, undefined, anim_org);
	}
		
	if( isDefined( bayonet_array[die_index].magic_bullet_shield ) )
	{
		bayonet_array[die_index] stop_magic_bullet_shield();
	}
	
	wait( 0.05 );
	
	bayonet_array[die_index] setcandamage(true);

	bayonet_array[die_index] doDamage(bayonet_array[die_index].health + 5,(0,180,48));
}

do_friendly_battlechatter()
{
	wait(1);
	level.officer playSound( "Pro1_INT_005A_SARG" );	//They're all around
	wait(2);
	level.grant playSound( "GRAN_BC_003A" );			//Ah shit, shit!!
	wait(2);
	level.grant playSound( "GRAN_BC_004A" );			//There's more of them, There's more of them
	wait(3.5);
	level.officer playSound("SARG_BC_004A");			//Hold em back!
	wait(2);
	level.officer playSound( "SARG_BC_007A");			//God damnit!
	wait(4);
	level.grant playSound( "GRAN_BC_006A" );//Saaarge!
	wait(1.5);
	level.officer playSound( "SARG_BC_011A" );//Keep it together!
	wait(2);
	level.officer playSound( "SARG_BC_014A" );//Keep on em!
	wait(1);
	level.grant playSound( "GRAN_BC_005A" );//I'm nearly out!
	wait(1);
	level.officer playSound( "SARG_BC_013A" );//There's more of them
	wait(1);
	level.grant playSound( "Pro1_INT_100A_GRAN" );//Enemies to the West, to the West
	wait(3);
	level.grant playSound( "Pro1_INT_006A_GRAN" );//GRENADE!
	wait(5);
//leave this out for now; Talk to DK	
//	level.officer playSound( "Pro1_INT_007A_SARG" );//West, Mason, WEST!!
	wait(2);
	level.grant playSound( "GRAN_BC_007A" );//Oh god, NO!
}

activate_enemy_motion(enemyArray)
{
	for( i = 0; i < enemyArray.size; i++ )
	{
		if( isDefined( enemyArray[i] ) )
		{
			enemyArray[i] thread ignore_til_goal();
			node = GetNode( enemyArray[i].target, "targetname" );
			enemyArray[i] setGoalNode( node );
		}
	}
}

activate_enemy_motion_pincer( enemyArray, side )
{
	for( i = 0; i < enemyArray.size; i++ )
	{
		if( isDefined( enemyArray[i] ) )
		{
			enemyArray[i] SetGoalNode( GetNode( enemyArray[i].target, "targetname" ) );
			if( isDefined( enemyArray[i].magic_bullet_shield ) )
			{
				enemyArray[i] stop_magic_bullet_shield();
			}
			enemyArray[i] notify("stop looping");
		}
	}
}

//Effect Conditions
wait_for_strobe()
{
	flag_wait( "flare_stop_setting_sundir" );
	level endon( "final_flicker" );
	resting_spot = getvehiclenode( "flare_fade_node", "script_noteworthy" );
	direction = anglestoforward( vectortoangles( level.strobe_direction ) );
	//color = ( 0.8, 0.4, 0.4 );
	color = ( 0.83, 0.82, 1 );
	up_bright = 1.25;
	down_bright = 0.55;
	flash_time = 0.1;
	flicker_amt = 0.3;
	brightness = 0.25;
	time = 0;
	while( 1 )
	{
		rand = randomfloat( flicker_amt );
		if( time > flash_time * 2.0 )
			time = 0;
		if( time < flash_time )
			brightness = up_bright + rand;
		else if( time < 2.0*flash_time )
			brightness = down_bright + rand;
		rgb = vector_Multiply( color, brightness );
		setSunLight( rgb[ 0 ], rgb[ 1 ], rgb[ 2 ] );
		time += (0.1+rand);
		lerpSunDirection( direction, direction, 0.1+rand );
		wait( 0.1+rand );
	}
}

wait_for_bloom()
{
	flag_wait( "flare_start_setting_sundir" ); 
  
  VisionSetNaked( "mak_flare", 0.1 ); 
  wait( 0.5 );
  VisionSetNaked( "mak", 2 );
}

wait_for_final_flicker()
{
	level waittill( "final_flicker" );
	brightness = 0.6;
	bright_per_frame = brightness/0.4/30;
	color = ( 0.8, 0.4, 0.4 );
	while( 1 )
	{
		brightness -= bright_per_frame;
		rgb = vector_Multiply( color, brightness );
		setSunLight( rgb[ 0 ], rgb[ 1 ], rgb[ 2 ] );
		wait( 0.1 );
		if( brightness == 0 )
			break;
	}
	level notify( "fade_to_black" );
}

// Helper
nextmission_wait()
{
	// Eventually, we may want to play the intro cinematic here
	nextmission();
}

do_gradual_timescale( time, startSpeed, endSpeed )
{
	level notify( "scaling" );
	level endon("scaling");
	
	currTime = 0;
	for( ;; )
	{
		currSpeed = startSpeed + ((currTime/time)*(endSpeed-startSpeed));
		SetTimeScale( currSpeed );
		wait( 0.05 );
		currTime += 0.05;
		if( currTime == time )
			break;
	}
}

stagger_standing( time )
{
	wait( randomfloat( time ) );
	if( isDefined( self ) )
	{
		self allowedStances( "stand" );
	}
}

lerp_pos_over_time( time, distance )
{
	level notify( "lerping" );
	level endon( "lerping" );
	startOrigin = self.origin;
	currTime = 0;
	for(;;)
	{
		percent = currTime/time;
		self.origin = startOrigin + (distance[0]*percent, distance[1]*percent, distance[2]*percent );
		currTime += 0.05;
		wait( 0.05 );
		if( currTime >= time )
			break;
	}
}

lerp_to_pos_orient( time, pos, angles )
{
	level notify( "lerping" );
	level endon( "lerping" );
	startPos = self.origin;
	startAngles = self.angles;
	diffPos = pos - self.origin;
	diffAngles = angles - self.angles;
	currTime = 0;
	
	for(;;)
	{
		percent = currTime/time;
		self.origin = startPos + (diffPos[0]*percent, diffPos[1]*percent, diffPos[2]*percent );
		self.angles = startAngles + (diffAngles[0]*percent, diffAngles[1]*percent, diffAngles[2]*percent );
		currTime += 0.05;
		wait( 0.05 );
		if( currTime >= time )
			break;
	}
}

// Debug timer functions
setup_timer_hudelems()
{
	/#
	level.event1_time = 0.00;
	level.event2_time = 0.00;
	level.event3_time = 0.00;
	
	level.event1_timer = newclienthudelem(self);
	level.event2_timer = newclienthudelem(self);	
	level.event3_timer = newclienthudelem(self);
	
	level.event1_timer.x =-60;
	level.event2_timer.x =-60;
	level.event3_timer.x =-60;
	
	level.event1_timer.y = 140;
	level.event2_timer.y = 160;
	level.event3_timer.y = 180;
	
	level.event1_timer.alignX = "left";
	level.event2_timer.alignX = "left";
	level.event3_timer.alignX = "left";
	
	level.event1_timer.alignY = "bottom";
	level.event2_timer.alignY = "bottom";
	level.event3_timer.alignY = "bottom";
	
	level.event1_timer.fontScale = 2;
	level.event2_timer.fontScale = 2;
	level.event3_timer.fontScale = 2;
	
	level.event1_timer.alpha = 0;
	level.event2_timer.alpha = 0;
	level.event3_timer.alpha = 0;
	
	level.event1_timer.foreground = true;
	level.event2_timer.foreground = true;
	level.event3_timer.foreground = true;
	
	level.event1_timer settext( "event 1 time: "+level.event1_time );
	level.event2_timer settext( "event 2 time: "+level.event2_time );
	level.event3_timer settext( "event 3 time: "+level.event3_time );
	
	level.finish_event_1 = false;
	level.finish_event_2 = false;
	level.finish_event_3 = false;
	#/
}

event1_timer()
{
	/#
	level.event1_timer.alpha = 1;
	level.event1_timer.color = (1, 0, 0);
	level endon("begin event2");
	for(;;)
	{
		level.event1_time += 0.1;
		level.event1_timer settext( "event 1 time: "+level.event1_time );
		wait( 0.1 );
	}
	#/
}

event2_timer()
{
	/#
	level.event2_timer.alpha = 1;
	level.event1_timer.color = (1, 1, 1);
	level.event2_timer.color = (1, 0, 0);
	level endon("begin event3");
	for(;;)
	{
		level.event2_time += 0.1;
		level.event2_timer settext( "event 2 time: "+level.event2_time );
		wait( 0.1 );
	}
	#/
}

event3_timer()
{
	/#
	level.event3_timer.alpha = 1;
	level.event2_timer.color = (1, 1, 1);
	level.event3_timer.color = (1, 0, 0);
	level endon("begin event 3");
	for(;;)
	{
		level.event3_time += 0.1;
		level.event3_timer settext( "event 3 time: "+level.event3_time );
		wait( 0.1 );
	}
	#/
}