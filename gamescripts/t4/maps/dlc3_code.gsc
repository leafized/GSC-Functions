// Sparks (9/12/2009 3:20:27 PM)

#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_music;

// DLC3 Utilities
#include maps\dlc3_teleporter;

/***********************************************************************
    DLC3 STUFF
***********************************************************************/ 

initDLC3_Vars()
{
	// Alter The Pulls
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = false;
	
	// Coop Heroes Loadout
	if( isDefined( level.DLC3.useCoopHeroes ) && level.DLC3.useCoopHeroes )
	{
		level.use_zombie_heroes = level.DLC3.useCoopHeroes;
	}
	else
	{
		level.use_zombie_heroes = true;
	}

	// Bowie Knife Damage
	if( isDefined( level.DLC3.perk_altMeleeDamage ) && level.DLC3.perk_altMeleeDamage )
	{
		SetDvar( "perk_altMeleeDamage", level.DLC3.perk_altMeleeDamage );
	}
	else
	{
		SetDvar( "perk_altMeleeDamage", 1000 );
	}

	// Dogs Enabled
	if( isDefined( level.DLC3.useHellHounds ) && level.DLC3.useHellHounds )
	{
		level.dogs_enabled = level.DLC3.useHellHounds;
	}
	else
	{
		level.dogs_enabled = true;
	}
	
	// Mixed Crawlers And Dogs
	if( isDefined( level.DLC3.useMixedRounds ) && level.DLC3.useMixedRounds )
	{
		level.mixed_rounds_enabled = level.DLC3.useMixedRounds;
	}
	else
	{
		level.mixed_rounds_enabled = true;
	}
	
	// Array For Burning Zombies, Traps, and Risers -- Leave These
	level.burning_zombies = [];
	level.traps = [];
	level.zombie_rise_spawners = [];
	
	// Barrier Search Override
	if( isDefined( level.DLC3.barrierSearchOverride ) && level.DLC3.barrierSearchOverride )
	{
		level.max_barrier_search_dist_override = level.DLC3.barrierSearchOverride;
	}
	else
	{
		level.max_barrier_search_dist_override = 400;
	}
	
	// Pointer Functions -- These Are Stock
	level.door_dialog_function = maps\_zombiemode::play_door_dialog;
	level.achievement_notify_func = maps\_zombiemode_utility::achievement_notify;
	level.dog_spawn_func = maps\_zombiemode_dogs::dog_spawn_factory_logic;
	
	level.zombie_anim_override = maps\dlc3_code::anim_override_func;
}

initDLC3_Vars2()
{	
	// Special level specific settings
	if( isDefined( level.DLC3.powerUpDropMax ) && level.DLC3.powerUpDropMax )
	{
		set_zombie_var( "zombie_powerup_drop_max_per_round", level.DLC3.powerUpDropMax );	// lower this to make drop happen more often
	}
	{
		set_zombie_var( "zombie_powerup_drop_max_per_round", 3 );	// lower this to make drop happen more often
	}
}

DLC3_threadCalls()
{
	initDLC3_Vars();
	
	script_anims_init();
	
	level thread maps\_callbacksetup::SetupCallbacks();
	
	precacheDLC3();
}

DLC3_threadCalls2()
{
	if( isArray( level.DLC3.initialZones ) && isDefined( level.DLC3.initialZones[ 0 ] ) )
	{
		level thread maps\_zombiemode_zone_manager::manage_zones( level.DLC3.initialZones );
	}
	
	if( isDefined( level.DLC3.useSnow ) && level.DLC3.useSnow )
	{
		level thread player_Snow();
	}
	
	init_sounds();
	
	level thread initDLC3_Vars2();
	
	if( isDefined( level.DLC3.useElectricSwitch ) && level.DLC3.useElectricSwitch )
	{
		level thread power_electric_switch();
	}
	else
	{
		level thread power_electric_switch_on();
	}
	
	level thread magic_box_init();

	if( isDefined( level.DLC3.useElectricTraps ) && level.DLC3.useElectricTraps )
	{
		thread init_elec_trap_trigs();
	}
	
	// Need this here because of the createFX hack for teleporter FX
	if( !isDefined( level._script_exploders ) )
	{
		level._script_exploders = [];
	}
	
	teleporter_init();
	
	level thread mapStartAudio();
	
	level thread intro_screen();

	level thread jump_from_bridge();
	level lock_additional_player_spawner();

	if( isDefined( level.DLC3.useBridge ) && level.DLC3.useBridge )
	{
		level thread bridge_init();
	}

	level thread perkMachineRattles();
}

precacheDLC3()
{
	precachestring(&"ZOMBIE_FLAMES_UNAVAILABLE");
	precachestring(&"ZOMBIE_ELECTRIC_SWITCH");

	precachestring(&"ZOMBIE_POWER_UP_TPAD");
	precachestring(&"ZOMBIE_TELEPORT_TO_CORE");
	precachestring(&"ZOMBIE_LINK_TPAD");
	precachestring(&"ZOMBIE_LINK_ACTIVE");
	precachestring(&"ZOMBIE_INACTIVE_TPAD");
	precachestring(&"ZOMBIE_START_TPAD");

	precacheshellshock("electrocution");
	precachemodel("zombie_zapper_cagelight_red");
	precachemodel("zombie_zapper_cagelight_green");
	precacheModel("lights_indlight_on" );
	precacheModel("lights_milit_lamp_single_int_on" );
	precacheModel("lights_tinhatlamp_on" );
	precacheModel("lights_berlin_subway_hat_0" );
	precacheModel("lights_berlin_subway_hat_50" );
	precacheModel("lights_berlin_subway_hat_100" );
	precachemodel("collision_geo_32x32x128");

	precachestring(&"ZOMBIE_BETTY_ALREADY_PURCHASED");
	precachestring(&"ZOMBIE_BETTY_HOWTO");
}

intro_screen()
{

	flag_wait( "all_players_connected" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 3; i++)
	{
		level.intro_hud[i] = newHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = true;

		if ( level.splitscreen && !level.hidef )
		{
			level.intro_hud[i].fontScale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontScale = 1.75;
		}
		level.intro_hud[i].alpha = 0.0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inuse = false;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;


	level.intro_hud[0] settext(level.DLC3.introString);
	level.intro_hud[1] settext("");
	level.intro_hud[2] settext("");

	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}	
	//wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	}
}

init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
	maps\_zombiemode_utility::add_sound( "gate_door",	"open_door" );
	maps\_zombiemode_utility::add_sound( "heavy_door",	"open_door" );
}

include_weapons()
{
	include_weapon( "zombie_colt" );
	include_weapon( "zombie_colt_upgraded", false );
	include_weapon( "zombie_sw_357" );
	include_weapon( "zombie_sw_357_upgraded", false );

	// Bolt Action
	include_weapon( "zombie_kar98k" );
	include_weapon( "zombie_kar98k_upgraded", false );

	// Semi Auto
	include_weapon( "zombie_m1carbine" );
	include_weapon( "zombie_m1carbine_upgraded", false );
	include_weapon( "zombie_m1garand" );
	include_weapon( "zombie_m1garand_upgraded", false );
	include_weapon( "zombie_gewehr43" );
	include_weapon( "zombie_gewehr43_upgraded", false );

	// Full Auto
	include_weapon( "zombie_stg44" );
	include_weapon( "zombie_stg44_upgraded", false );
	include_weapon( "zombie_thompson" );
	include_weapon( "zombie_thompson_upgraded", false );
	include_weapon( "zombie_mp40" );
	include_weapon( "zombie_mp40_upgraded", false );
	include_weapon( "zombie_type100_smg" );
	include_weapon( "zombie_type100_smg_upgraded", false );

	// Scoped
	include_weapon( "ptrs41_zombie" );
	include_weapon( "ptrs41_zombie_upgraded", false );

	// Grenade
	include_weapon( "molotov" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher	
	include_weapon( "m1garand_gl_zombie" );
	include_weapon( "m1garand_gl_zombie_upgraded", false );
	include_weapon( "m7_launcher_zombie" );
	include_weapon( "m7_launcher_zombie_upgraded", false );

	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	include_weapon( "m2_flamethrower_zombie_upgraded", false );

	// Shotgun
	include_weapon( "zombie_doublebarrel" );
	include_weapon( "zombie_doublebarrel_upgraded", false );
	include_weapon( "zombie_shotgun" );
	include_weapon( "zombie_shotgun_upgraded", false );

	// Heavy MG
	include_weapon( "zombie_bar" );
	include_weapon( "zombie_bar_upgraded", false );
	include_weapon( "zombie_fg42" );
	include_weapon( "zombie_fg42_upgraded", false );

	include_weapon( "zombie_30cal" );
	include_weapon( "zombie_30cal_upgraded", false );
	include_weapon( "zombie_mg42" );
	include_weapon( "zombie_mg42_upgraded", false );
	include_weapon( "zombie_ppsh" );
	include_weapon( "zombie_ppsh_upgraded", false );

	// Rocket Launcher
	include_weapon( "panzerschrek_zombie" );
	include_weapon( "panzerschrek_zombie_upgraded", false );

	// Special
	include_weapon( "ray_gun", true, ::factory_ray_gun_weighting_func );
	include_weapon( "ray_gun_upgraded", false );
	include_weapon( "tesla_gun", true );
	include_weapon( "tesla_gun_upgraded", false );
	include_weapon( "zombie_cymbal_monkey", true, ::factory_cymbal_monkey_weighting_func );
	// include_weapon( "mortar_round" );

	// Bouncing betties
	include_weapon( "mine_bouncing_betty", false );
	
	// Added By Sniperbolt
	// include_weapon( "zombie_the_sniperbolt", true );
	// include_weapon( "zombie_the_sniperbolt_upgrated", false );

	// Limited weapons
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_colt", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_gewehr43", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_m1garand", 0 );
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
	include_powerup( "carpenter" );
}

DLC3_FX()
{
	// THESE ARE NEEDED FOR ZOMBIE MODE -- LEAVE THESE
	
	// Scripted FX
	level._effect["large_ceiling_dust"]		= LoadFx( "env/dirt/fx_dust_ceiling_impact_lg_mdbrown" );
	level._effect["poltergeist"]			= LoadFx( "misc/fx_zombie_couch_effect" );
	level._effect["gasfire"] 				= LoadFx("destructibles/fx_dest_fire_vert");
	level._effect["switch_sparks"]			= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["wire_sparks_oneshot"] = loadfx("env/electrical/fx_elec_wire_spark_dl_oneshot");
	
	level._effect["rise_burst"]		= LoadFx("maps/mp_maps/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow"]	= LoadFx("maps/mp_maps/fx_mp_zombie_body_dirt_billowing");	
	level._effect["rise_dust"]		= LoadFx("maps/mp_maps/fx_mp_zombie_body_dust_falling");		
	
	level._effect["dog_eye_glow"] = loadfx("maps/zombie/fx_zombie_dog_eyes");
	level._effect["dog_gib"] = loadfx( "maps/zombie/fx_zombie_dog_explosion" );
	level._effect["dog_trail_fire"] = loadfx("maps/zombie/fx_zombie_dog_fire_trail");
	level._effect["dog_trail_ash"] = loadfx("maps/zombie/fx_zombie_dog_ash_trail");
	level._effect["dog_breath"] = Loadfx("maps/zombie/fx_zombie_dog_breath");	
	
	level._effect["lght_marker"]			= Loadfx("maps/zombie/fx_zombie_factory_marker");
	level._effect["lght_marker_flare"]		= Loadfx("maps/zombie/fx_zombie_factory_marker_fl");

	level._effect["betty_explode"]			= loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
	level._effect["betty_trail"]			= loadfx("weapon/bouncing_betty/fx_betty_trail");

	level._effect["zapper_fx"] 				= loadfx("misc/fx_zombie_zapper_powerbox_on");	
	level._effect["zapper"]					= loadfx("misc/fx_zombie_electric_trap");
	level._effect["zapper_wall"] 			= loadfx("misc/fx_zombie_zapper_wall_control_on");
	level._effect["zapper_light_ready"]		= loadfx("maps/zombie/fx_zombie_light_glow_green");
	level._effect["zapper_light_notready"]	= loadfx("maps/zombie/fx_zombie_light_glow_red");
	level._effect["elec_room_on"] 			= loadfx("fx_zombie_light_elec_room_on");
	level._effect["elec_md"] 				= loadfx("env/electrical/fx_elec_player_md");
	level._effect["elec_sm"] 				= loadfx("env/electrical/fx_elec_player_sm");
	level._effect["elec_torso"] 			= loadfx("env/electrical/fx_elec_player_torso");

	level._effect["elec_trail_one_shot"]	= loadfx("misc/fx_zombie_elec_trail_oneshot");
	level._effect["wire_spark"] = loadfx("maps/zombie/fx_zombie_wire_spark");
	level._effect["powerup_on"] 				= loadfx( "misc/fx_zombie_powerup_on" );
	
	// Create FX
	
	if( isDefined( level.DLC3.myFX ) )
	{
		[[level.DLC3.myFX]]();
	}
	
	level._effect["transporter_beam"]				          = loadfx("maps/zombie/fx_transporter_beam");
	level._effect["transporter_pad_start"]				    = loadfx("maps/zombie/fx_transporter_pad_start");
	level._effect["transporter_start"]				        = loadfx("maps/zombie/fx_transporter_start");		
	level._effect["transporter_ambient"]				      = loadfx("maps/zombie/fx_transporter_ambient");		
	level._effect["zombie_mainframe_link_all"]				= loadfx("maps/zombie/fx_zombie_mainframe_link_all");
	level._effect["zombie_mainframe_link_single"]			= loadfx("maps/zombie/fx_zombie_mainframe_link_single");
	level._effect["zombie_mainframe_linked"]		     	= loadfx("maps/zombie/fx_zombie_mainframe_linked");	
	level._effect["zombie_mainframe_beam"]			      = loadfx("maps/zombie/fx_zombie_mainframe_beam");	
	level._effect["zombie_mainframe_flat"]			      = loadfx("maps/zombie/fx_zombie_mainframe_flat");	
	level._effect["zombie_mainframe_flat_start"]		  = loadfx("maps/zombie/fx_zombie_mainframe_flat_start");				
	level._effect["zombie_mainframe_beam_start"]		  = loadfx("maps/zombie/fx_zombie_mainframe_beam_start");
	level._effect["zombie_flashback_american"]		    = loadfx("maps/zombie/fx_zombie_flashback_american");
	level._effect["gasfire2"] 			                  = Loadfx("destructibles/fx_dest_fire_vert");	
	level._effect["mp_light_lamp"] 			              = Loadfx("maps/mp_maps/fx_mp_light_lamp");	
	level._effect["zombie_difference"]		            = loadfx("maps/zombie/fx_zombie_difference");
	level._effect["zombie_mainframe_steam"]		        = loadfx("maps/zombie/fx_zombie_mainframe_steam");	
	level._effect["zombie_heat_sink"]		              = loadfx("maps/zombie/fx_zombie_heat_sink");
	level._effect["mp_smoke_stack"] 			            = loadfx("maps/mp_maps/fx_mp_smoke_stack");
	level._effect["mp_elec_spark_fast_random"] 			  = loadfx("maps/mp_maps/fx_mp_elec_spark_fast_random");
	level._effect["zombie_elec_gen_idle"] 		    	  = loadfx("misc/fx_zombie_elec_gen_idle");
	level._effect["zombie_moon_eclipse"]		          = loadfx("maps/zombie/fx_zombie_moon_eclipse");
	level._effect["zombie_clock_hand"]		            = loadfx("maps/zombie/fx_zombie_clock_hand");
	level._effect["zombie_elec_pole_terminal"]		    = loadfx("maps/zombie/fx_zombie_elec_pole_terminal");
	level._effect["mp_elec_broken_light_1shot"] 	  		  = loadfx("maps/mp_maps/fx_mp_elec_broken_light_1shot");	
	level._effect["mp_light_lamp_no_eo"] 	  		      = loadfx("maps/mp_maps/fx_mp_light_lamp_no_eo");
	level._effect["zombie_packapunch"]		            = loadfx("maps/zombie/fx_zombie_packapunch");
	level._effect["electric_short_oneshot"] = loadfx("env/electrical/fx_elec_short_oneshot");
	
	animscripts\utility::setFootstepEffect( "asphalt",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cloth",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete",   LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud",        LoadFx( "bio/player/fx_footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood",       LoadFx( "bio/player/fx_footstep_dust" ) );
	
	[[level.DLC3.createArt]]();
	
	spawnFX();
}

spawnFX()
{
	[[level.DLC3.createFX]]();
	
	maps\createFX\dlc3_fx::main();
}

/***********************************************************************
    TRAP STUFF
***********************************************************************/ 
init_elec_trap_trigs()
{
	//trap_trigs = getentarray("gas_access","targetname");
	//array_thread (trap_trigs,::electric_trap_think);
	//array_thread (trap_trigs,::electric_trap_dialog);

	// MM - traps disabled for now
	array_thread( getentarray("warehouse_electric_trap",	"targetname"), ::electric_trap_think, "enter_warehouse_building" );
	array_thread( getentarray("wuen_electric_trap",			"targetname"), ::electric_trap_think, "enter_wnuen_building" );
	array_thread( getentarray("bridge_electric_trap",		"targetname"), ::electric_trap_think, "bridge_down" );
}

electric_trap_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				
				index = maps\_zombiemode_weapons::get_player_index(players[i]);
				plr = "plr_" + index + "_";
				//players[i] create_and_play_dialog( plr, "vox_level_start", 0.25 );
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}


electric_trap_think( enable_flag )
{	
	self sethintstring("turn power on");
	self.zombie_cost = 100;
	
	//self thread electric_trap_dialog();

	// get a list of all of the other triggers with the same name
	triggers = getentarray( self.targetname, "targetname" );
	flag_wait( "electricity_on" );


	// Get the damage trigger.  This is the unifying element to let us know it's been activated.
	//self.zombie_dmg_trig = getEnt(self.target,"targetname");
	//self.zombie_dmg_trig.in_use = 0;

	// Set buy string
	self sethintstring("turn on trap [ cost: "+self.zombie_cost+"]");

	// Getting the light that's related is a little esoteric, but there isn't
	// a better way at the moment.  It uses linknames, which are really dodgy.
	light_name = "";	// scope declaration
	damage_trigger = "";
	tswitch = getent(self.script_linkto,"script_linkname");
	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuenn
	case "11":
		light_name = "zapper_light_wuen";
		damage_trigger = "zapper_damage_wuen";
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		damage_trigger = "zapper_damage_warehouse";
		break;

	case "30":	// Bridge
	case "31":
		light_name = "zapper_light_bridge";
		damage_trigger = "zapper_damage_bridge";
		break;
	}
	// Get the damage trigger.  This is the unifying element to let us know it's been activated.
	self.zombie_dmg_trig = getEnt(damage_trigger,"targetname");
	self.zombie_dmg_trig.in_use = 0;
	
	// The power is now on, but keep it disabled until a certain condition is met
	//	such as opening the door it is blocking or waiting for the bridge to lower.

	if ( !flag( enable_flag ) )
	{
		self trigger_off();
		zapper_light_red( light_name );
		flag_wait( enable_flag );
		self trigger_on();
	}

	// Open for business!  
	zapper_light_green( light_name );
	
	while(1)
	{
		//valve_trigs = getentarray(self.script_noteworthy ,"script_noteworthy");		
	
		//wait until someone uses the valve
		self waittill("trigger",who);
		if( who in_revive_trigger() )
		{
			continue;
		}
		
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.zombie_dmg_trig.in_use)
				{
					self.zombie_dmg_trig.in_use = 1;

					//turn off the valve triggers associated with this trap until available again
					array_thread (triggers, ::trigger_off);

					play_sound_at_pos( "purchase", who.origin );
					self thread electric_trap_move_switch(self);
					//need to play a 'woosh' sound here, like a gas furnace starting up
					self waittill("switch_activated");
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );

					//this trigger detects zombies walking thru the flames
					self.zombie_dmg_trig trigger_on();

					//play the flame FX and do the actual damage
					self thread activate_electric_trap();					

					//wait until done and then re-enable the valve for purchase again
					self waittill("elec_done");
					
					clientnotify(self.script_string +"off");
										
					//delete any FX ents
					if(isDefined(self.fx_org))
					{
						self.fx_org delete();
					}
					if(isDefined(self.zapper_fx_org))
					{
						self.zapper_fx_org delete();
					}
					if(isDefined(self.zapper_fx_switch_org))
					{
						self.zapper_fx_switch_org delete();
					}
										
					//turn the damage detection trigger off until the flames are used again
			 		self.zombie_dmg_trig trigger_off();
					wait(25);

					array_thread (triggers, ::trigger_on);

					//COLLIN: Play the 'alarm' sound to alert players that the traps are available again (playing on a temp ent in case the PA is already in use.
					//speakerA = getstruct("loudspeaker", "targetname");
					//playsoundatposition("warning", speakera.origin);
					self notify("available");

					self.zombie_dmg_trig.in_use = 0;
				}
			}
		}
	}
}

electric_trap_move_switch(parent)
{
	light_name = "";	// scope declaration
	tswitch = getent(parent.script_linkto,"script_linkname");
	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuen
	case "11":
		light_name = "zapper_light_wuen";	
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		break;

	case "30":
	case "31":
		light_name = "zapper_light_bridge";
		break;
	}
	
	//turn the light above the door red
	zapper_light_red( light_name );
	tswitch rotatepitch(180,.5);
	tswitch playsound("amb_sparks_l_b");
	tswitch waittill("rotatedone");

	self notify("switch_activated");
	self waittill("available");
	tswitch rotatepitch(-180,.5);

	//turn the light back green once the trap is available again
	zapper_light_green( light_name );
}

activate_electric_trap()
{
	if(isDefined(self.script_string) && self.script_string == "warehouse")
	{
		clientnotify("warehouse");
	}
	else if(isDefined(self.script_string) && self.script_string == "wuen")
	{
		clientnotify("wuen");
	}
	else
	{
		clientnotify("bridge");
	}	
		
	clientnotify(self.target);
	
	fire_points = getentarray(self.target,"targetname");
	
	for(i=0;i<fire_points.size;i++)
	{
		wait_network_frame();
		fire_points[i] thread electric_trap_fx(self);		
	}
	
	//do the damage
	self.zombie_dmg_trig thread elec_barrier_damage();
	
	// reset the zapper model
	level waittill("arc_done");
}

electric_trap_fx(notify_ent)
{
	self.tag_origin = spawn("script_model",self.origin);
	self.tag_origin setmodel("tag_origin");

	playfxontag(level._effect["zapper"],self.tag_origin,"tag_origin");

	self.tag_origin playsound("elec_start");
	self.tag_origin playloopsound("elec_loop");
	self thread play_electrical_sound();
	
	wait(25);
		
	self.tag_origin stoploopsound();
		
	self.tag_origin delete(); 
	notify_ent notify("elec_done");
	level notify ("arc_done");	
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

elec_barrier_damage()
{	
	while(1)
	{
		self waittill("trigger",ent);
		
		//player is standing electricity, dumbass
		if(isplayer(ent) )
		{
			ent thread player_elec_damage();
		}
		else
		{
			if(!isDefined(ent.marked_for_death))
			{
				ent.marked_for_death = true;
				ent thread zombie_elec_death( randomint(100) );
			}
		}
	}
}

play_elec_vocals()
{
	if(IsDefined (self)) 
	{
		org = self.origin;
		wait(0.15);
		playsoundatposition("elec_vocals", org);
		playsoundatposition("zombie_arc", org);
		playsoundatposition("exp_jib_zombie", org);
	}
}

player_elec_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if(!IsDefined (level.elec_loop))
	{
		level.elec_loop = 0;
	}	
	
	if( !isDefined(self.is_burning) && !self maps\_laststand::player_is_in_laststand() )
	{
		self.is_burning = 1;		
		self setelectrified(1.25);	
		shocktime = 2.5;			
		//Changed Shellshock to Electrocution so we can have different bus volumes.
		self shellshock("electrocution", shocktime);
		
		if(level.elec_loop == 0)
		{	
			elec_loop = 1;
			self playloopsound ("electrocution");
			self playsound("zombie_arc");
		}
		if(!self hasperk("specialty_armorvest") || self.health - 100 < 1)
		{
			
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
			self.is_burning = undefined;
		}
		else
		{
			self dodamage(50, self.origin);
			wait(.1);
			self playsound("zombie_arc");
			self.is_burning = undefined;
		}
	}
}

zombie_elec_death(flame_chance)
{
	self endon("death");
	
	//10% chance the zombie will burn, a max of 6 burning zombs can be goign at once
	//otherwise the zombie just gibs and dies
	if(flame_chance > 90 && level.burning_zombies.size < 6)
	{
		level.burning_zombies[level.burning_zombies.size] = self;
		self thread zombie_flame_watch();
		self playsound("ignite");
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

		playsoundatposition("zombie_arc", self.origin);
		if( !self enemy_is_dog() && randomint(100) > 50 )
		{
			self thread electroctute_death_fx();
			self thread play_elec_vocals();
		}
		wait(randomfloat(1.25));
		self playsound("zombie_arc");
	}

	self dodamage(self.health + 666, self.origin);
	iprintlnbold("should be damaged");
}

zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	level.burning_zombies = array_remove_nokeys(level.burning_zombies,self);
}

zapper_light_red( lightname )
{
	zapper_lights = getentarray( lightname, "targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\_zombiemode_net::network_safe_spawn( "trap_light_red", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_notready"],zapper_lights[i].fx,"tag_origin");
	}
}

zapper_light_green( lightname )
{
	zapper_lights = getentarray( lightname, "targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\_zombiemode_net::network_safe_spawn( "trap_light_green", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_ready"],zapper_lights[i].fx,"tag_origin");
	}
}

electroctute_death_fx()
{
	self endon( "death" );

	if (isdefined(self.is_electrocuted) && self.is_electrocuted )
	{
		return;
	}
	
	self.is_electrocuted = true;
	
	self thread electrocute_timeout();
		
	// JamesS - this will darken the burning body
	self StartTanning(); 

	if(self.team == "axis")
	{
		level.bcOnFireTime = gettime();
		level.bcOnFireOrg = self.origin;
	}
	
	PlayFxOnTag( level._effect["elec_torso"], self, "J_SpineLower" ); 
	self playsound ("elec_jib_zombie");
	wait 1;

	tagArray = []; 
	tagArray[0] = "J_Elbow_LE"; 
	tagArray[1] = "J_Elbow_RI"; 
	tagArray[2] = "J_Knee_RI"; 
	tagArray[3] = "J_Knee_LE"; 
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_md"], self, tagArray[0] ); 
	self playsound ("elec_jib_zombie");

	wait 1;
	self playsound ("elec_jib_zombie");

	tagArray[0] = "J_Wrist_RI"; 
	tagArray[1] = "J_Wrist_LE"; 
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
	{
		tagArray[2] = "J_Ankle_RI"; 
		tagArray[3] = "J_Ankle_LE"; 
	}
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[0] ); 
	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[1] );
}

electrocute_timeout()
{
	self endon ("death");
	self playloopsound("fire_manager_0");
	// about the length of the flame fx
	wait 12;
	self stoploopsound();
	if (isdefined(self) && isalive(self))
	{
		self.is_electrocuted = false;
		self notify ("stop_flame_damage");
	}
}

/***********************************************************************
    ELECTRIC SWITCH STUFF
***********************************************************************/ 

power_electric_switch()
{
	trig = getent("use_power_switch","targetname");
	master_switch = getent("power_switch","targetname");	
	master_switch notsolid();
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");

	cheat = false;
	
/# 
	if( GetDvarInt( "zombie_cheat" ) >= 3 )
	{
		wait( 5 );
		cheat = true;
	}
#/	

	user = undefined;
	if ( cheat != true )
	{
		trig waittill("trigger",user);
	}

	master_switch rotateroll(-90,.3);

	//TO DO (TUEY) - kick off a 'switch' on client script here that operates similiarly to Berlin2 subway.
	master_switch playsound("switch_flip");
	
	power_electric_switch_on();
	
	playfx(level._effect["switch_sparks"] ,getstruct("power_switch_fx","targetname").origin);
	
	trig delete();
}
	
power_electric_switch_on()
{
	flag_set( "electricity_on" );
	wait_network_frame();
	clientnotify( "revive_on" );
	wait_network_frame();
	clientnotify( "fast_reload_on" );
	wait_network_frame();
	clientnotify( "doubletap_on" );
	wait_network_frame();
	clientnotify( "jugger_on" );
	wait_network_frame();
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "revive_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
	wait_network_frame();
	level notify( "specialty_armorvest_power_on" );
	wait_network_frame();
	level notify( "specialty_rof_power_on" );
	wait_network_frame();
	level notify( "specialty_quickrevive_power_on" );
	wait_network_frame();
	level notify( "specialty_fastreload_power_on" );
	wait_network_frame();

	ClientNotify( "pl1" );	// power lights on
	exploder(600);

	// Don't want east or west to spawn when in south zone, but vice versa is okay
	//maps\_zombiemode_zone_manager::connect_zones( "outside_east_zone", "outside_south_zone" );
	//maps\_zombiemode_zone_manager::connect_zones( "outside_west_zone", "outside_south_zone", true );
}

/***********************************************************************
    BRIDGE STUFF
***********************************************************************/ 

bridge_init()
{
	flag_init( "bridge_down" );
	// raise bridge
	wnuen_bridge = getent( "wnuen_bridge", "targetname" );
	wnuen_bridge_coils = GetEntArray( "wnuen_bridge_coils", "targetname" );
	for ( i=0; i<wnuen_bridge_coils.size; i++ )
	{
		wnuen_bridge_coils[i] LinkTo( wnuen_bridge );
	}
	wnuen_bridge rotatepitch( 90, 1, .5, .5 );

	warehouse_bridge = getent( "warehouse_bridge", "targetname" );
	warehouse_bridge_coils = GetEntArray( "warehouse_bridge_coils", "targetname" );
	for ( i=0; i<warehouse_bridge_coils.size; i++ )
	{
		warehouse_bridge_coils[i] LinkTo( warehouse_bridge );
	}
	warehouse_bridge rotatepitch( -90, 1, .5, .5 );
	
	bridge_audio = getent( "bridge_audio", "targetname" );

	// wait for power
	flag_wait( "electricity_on" );

	// lower bridge
	wnuen_bridge rotatepitch( -90, 4, .5, 1.5 );
	warehouse_bridge rotatepitch( 90, 4, .5, 1.5 );
	
	if(isdefined( bridge_audio ) )
		playsoundatposition( "bridge_lower", bridge_audio.origin );

	wnuen_bridge connectpaths();
	warehouse_bridge connectpaths();

	exploder( 500 );

	// wait until the bridges are down.
	wnuen_bridge waittill( "rotatedone" );
	
	flag_set( "bridge_down" );
	if(isdefined( bridge_audio ) )
		playsoundatposition( "bridge_hit", bridge_audio.origin );

	wnuen_bridge_clip = getent( "wnuen_bridge_clip", "targetname" );
	wnuen_bridge_clip delete();

	warehouse_bridge_clip = getent( "warehouse_bridge_clip", "targetname" );
	warehouse_bridge_clip delete();

	//maps\_zombiemode_zone_manager::connect_zones( "wnuen_bridge_zone", "bridge_zone" );
	//maps\_zombiemode_zone_manager::connect_zones( "warehouse_top_zone", "bridge_zone" );
}

jump_from_bridge()
{
	trig = GetEnt( "trig_outside_south_zone", "targetname" );
	
	if( isDefined( trig ) )
	{
		trig waittill( "trigger" );
	}
	
	//maps\_zombiemode_zone_manager::connect_zones( "outside_south_zone", "bridge_zone", true );
	//maps\_zombiemode_zone_manager::connect_zones( "outside_south_zone", "wnuen_bridge_zone", true );
}

/***********************************************************************
    AUDIO STUFF
***********************************************************************/

perkMachineRattles()
{
	// Check under the machines for change
	trigs = GetEntArray( "audio_bump_trigger", "targetname" );
	
	for ( i=0; i<trigs.size; i++ )
	{
		if ( IsDefined(trigs[i].script_sound) && trigs[i].script_sound == "perks_rattle" )
		{
			trigs[i] thread check_for_change();
		}
	}
}

mapStartAudio()
{
	players = get_players(); 
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread player_killstreak_timer();
		players[i] thread player_zombie_awareness();
	}
	
	players[randomint(players.size)] thread level_start_vox(); //Plays a "Power's Out" Message from a random player at start
}

player_zombie_awareness()
{
	self endon("disconnect");
	self endon("death");
	players = getplayers();
	index = maps\_zombiemode_weapons::get_player_index(self);
	while(1)
	{
		wait(1);		
		//zombie = get_closest_ai(self.origin,"axis");
		
		zombs = getaiarray("axis");
		for(i=0;i<zombs.size;i++)
		{
			if(DistanceSquared(zombs[i].origin, self.origin) < 200 * 200)
			{
				if(!isDefined(zombs[i]))
				{
					continue;
				}
				
				dist = 200;				
				switch(zombs[i].zombie_move_speed)
				{
					case "walk": dist = 200;break;
					case "run": dist = 250; break;
					case "sprint": dist = 275;break;
				}				
				if(distance2d(zombs[i].origin,self.origin) < dist)
				{				
					yaw = self animscripts\utility::GetYawToSpot(zombs[i].origin );
					//check to see if he's actually behind the player
					if(yaw < -95 || yaw > 95)
					{
						zombs[i] playsound ("behind_vocals");
					}
				}				
			}
		}
		if(players.size > 1)
		{
			//Plays 'teamwork' style dialog if there are more than 1 player...
			close_zombs = 0;
			for(i=0;i<zombs.size;i++)
			{
				if(DistanceSquared(zombs[i].origin, self.origin) < 250 * 250)
				{
					close_zombs ++;
				}
			}
			if(close_zombs > 4)
			{
				if(randomintrange(0,20) < 5)
				{
					plr = "plr_" + index + "_";
					self thread create_and_play_dialog( plr, "vox_oh_shit", .25, "resp_ohshit" );	
				}
			}
		}
	}
}

level_start_vox()
{
	index = maps\_zombiemode_weapons::get_player_index( self );
	plr = "plr_" + index + "_";
	wait( 6 );
	self thread create_and_play_dialog( plr, "vox_level_start", 0.25 );
}

check_for_change()
{
	while (1)
	{
		self waittill( "trigger", player );

		if ( player GetStance() == "prone" )
		{
			player maps\_zombiemode_score::add_to_player_score( 25 );
			play_sound_at_pos( "purchase", player.origin );
			break;
		}
	}
}

/***********************************************************************
    WEAPON STUFF
***********************************************************************/ 



magic_box_init()
{
	level.open_chest_location = [];
	
	for( x = 0 ; x < level.DLC3.PandoraBoxes.size ; x++ )
	{
		level.open_chest_location[ x ] = level.DLC3.PandoraBoxes[ x ];
	}
}

factory_ray_gun_weighting_func()
{
	if( level.box_moved == true )
	{	
		num_to_add = 1;
		// increase the percentage of ray gun
		if( isDefined( level.pulls_since_last_ray_gun ) )
		{
			// after 12 pulls the ray gun percentage increases to 15%
			if( level.pulls_since_last_ray_gun > 11 )
			{
				num_to_add += int(level.zombie_include_weapons.size*0.1);
			}			
			// after 8 pulls the Ray Gun percentage increases to 10%
			else if( level.pulls_since_last_ray_gun > 7 )
			{
				num_to_add += int(.05 * level.zombie_include_weapons.size);
			}		
		}
		return num_to_add;	
	}
	else
	{
		return 0;
	}
}

factory_cymbal_monkey_weighting_func()
{
	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] maps\_zombiemode_weapons::has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}

/***********************************************************************
    ZOMBIE STUFF
***********************************************************************/ 

#using_animtree( "zombie_factory" );
script_anims_init()
{
	level.scr_anim[ "half_gate" ]			= %o_zombie_lattice_gate_half;
	level.scr_anim[ "full_gate" ]			= %o_zombie_lattice_gate_full;
	level.scr_anim[ "difference_engine" ]	= %o_zombie_difference_engine_ani;

	level.blocker_anim_func = ::factory_playanim;
}

factory_playanim( animname )
{
	self UseAnimTree(#animtree);
	self animscripted("door_anim", self.origin, self.angles, level.scr_anim[animname] );
}

lock_additional_player_spawner()
{
	
	spawn_points = getentarray("player_respawn_point", "targetname");
	for( i = 0; i < spawn_points.size; i++ )
	{

			spawn_points[i].locked = true;
	}
}

#using_animtree( "generic_human" );
anim_override_func()
{
		level._zombie_melee[0] 				= %ai_zombie_attack_forward_v1; 
		level._zombie_melee[1] 				= %ai_zombie_attack_forward_v2; 
		level._zombie_melee[2] 				= %ai_zombie_attack_v1; 
		level._zombie_melee[3] 				= %ai_zombie_attack_v2;	
		level._zombie_melee[4]				= %ai_zombie_attack_v1;
		level._zombie_melee[5]				= %ai_zombie_attack_v4;
		level._zombie_melee[6]				= %ai_zombie_attack_v6;	

		level._zombie_run_melee[0]				=	%ai_zombie_run_attack_v1;
		level._zombie_run_melee[1]				=	%ai_zombie_run_attack_v2;
		level._zombie_run_melee[2]				=	%ai_zombie_run_attack_v3;

		level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v2;
		level.scr_anim["zombie"]["run5"] 	= %ai_zombie_run_v4;
		level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v3;

		level.scr_anim["zombie"]["walk5"] 	= %ai_zombie_walk_v6;
		level.scr_anim["zombie"]["walk6"] 	= %ai_zombie_walk_v7;
		level.scr_anim["zombie"]["walk7"] 	= %ai_zombie_walk_v8;
		level.scr_anim["zombie"]["walk8"] 	= %ai_zombie_walk_v9;
}

/***********************************************************************
    HELP CENTER STUFF
***********************************************************************/ 

modderHelp( Entity, Msg )
{
	// Developer Needs To Be Set To 1
	if( getDvarInt( "developer" ) >= 1 )
	{
		// Title
		if( !isDefined( level.modderHelpText[ 0 ] ) )
		{
			level.modderHelpText[ 0 ] = modderHelpHUD_CreateText( "^2Nazi Zombie DLC3 Help Center" );
		}
		
		// Check If Entity Exists Or Forced Error Msg
		if( !isDefined( Entity ) )
		{
			// Check If Error Msg Exists
			if( !isDefined( Msg ) )
			{
				return false;
			}
			
			// Let Modder Know What's Wrong And How To Fix			
			level.modderHelpText[ level.modderHelpText.size ] = modderHelpHUD_CreateText( "^1   -" + Msg );
			
			return true; // Return That There Was Something Wrong
		}
	}
	
	return false;
}

modderHelpHUD_CreateText( Msg )
{
	temp_modderHelpHUD = newHudElem();
	temp_modderHelpHUD.x = 0; 
	temp_modderHelpHUD.y = level.modderHelpText.size * 20; 
	temp_modderHelpHUD.alignX = "left"; 
	temp_modderHelpHUD.alignY = "top"; 
	temp_modderHelpHUD.horzAlign = "left"; 
	temp_modderHelpHUD.vertAlign = "top"; 
	temp_modderHelpHUD.sort = 1;
	temp_modderHelpHUD.foreground = true; 
	temp_modderHelpHUD.fontScale = 1.25;
	temp_modderHelpHUD SetText( Msg ); 
	temp_modderHelpHUD.alpha = 0; 
	temp_modderHelpHUD FadeOverTime( 1.2 ); 
	temp_modderHelpHUD.alpha = 1;
	
	return temp_modderHelpHUD;
}

/***********************************************************************
    MISC STUFF
***********************************************************************/ 

player_Snow()
{
	players = get_players();
	array_thread( players, ::_player_Snow );
}

_player_Snow()
{
	self endon("death");
	self endon("disconnect");

	for (;;)
	{
		playfx ( level._effect["snow_thick"], self.origin + (0,0,0));
		wait (0.2);
	}
}

extra_events()
{
	self UseTriggerRequireLookAt();
	self SetCursorHint( "HINT_NOICON" ); 
	self waittill( "trigger" );

	targ = GetEnt( self.target, "targetname" );
	if ( IsDefined(targ) )
	{
		targ MoveZ( -10, 5 );
	}
}

#using_animtree( "generic_human" ); 
force_zombie_crawler()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	if( !self.gibbed )
	{
		refs = []; 

		refs[refs.size] = "no_legs"; 

		if( refs.size )
		{
			self.a.gib_ref = animscripts\death::get_random( refs ); 
		
			// Don't stand if a leg is gone
			self.has_legs = false; 
			self AllowedStances( "crouch" ); 
								
			which_anim = RandomInt( 5 ); 
			
			if( which_anim == 0 ) 
			{
				self.deathanim = %ai_zombie_crawl_death_v1;
				self set_run_anim( "death3" );
				self.run_combatanim = level.scr_anim["zombie"]["crawl1"];
				self.crouchRunAnim = level.scr_anim["zombie"]["crawl1"];
				self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl1"];
			}
			else if( which_anim == 1 ) 
			{
				self.deathanim = %ai_zombie_crawl_death_v2;
				self set_run_anim( "death4" );
				self.run_combatanim = level.scr_anim["zombie"]["crawl2"];
				self.crouchRunAnim = level.scr_anim["zombie"]["crawl2"];
				self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl2"];
			}
			else if( which_anim == 2 ) 
			{
				self.deathanim = %ai_zombie_crawl_death_v1;
				self set_run_anim( "death3" );
				self.run_combatanim = level.scr_anim["zombie"]["crawl3"];
				self.crouchRunAnim = level.scr_anim["zombie"]["crawl3"];
				self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl3"];
			}
			else if( which_anim == 3 ) 
			{
				self.deathanim = %ai_zombie_crawl_death_v2;
				self set_run_anim( "death4" );
				self.run_combatanim = level.scr_anim["zombie"]["crawl4"];
				self.crouchRunAnim = level.scr_anim["zombie"]["crawl4"];
				self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl4"];
			}
			else if( which_anim == 4 ) 
			{
				self.deathanim = %ai_zombie_crawl_death_v1;
				self set_run_anim( "death3" );
				self.run_combatanim = level.scr_anim["zombie"]["crawl5"];
				self.crouchRunAnim = level.scr_anim["zombie"]["crawl5"];
				self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl5"];
			}								
		}

		if( self.health > 50 )
		{
			self.health = 50;
			
			// force gibbing if the zombie is still alive
			self thread animscripts\death::do_gib();
		}
	}
}