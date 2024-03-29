#include maps\_utility; 
#include common_scripts\utility;

main()
{
	precache_scripted_fx();
	precache_createfx_fx();
	footsteps(); 
	//maps\createart\nazi_zombie_tutorial_art::main();
	spawnFX();
}

footsteps()
{
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
}

precache_scripted_fx()
{
	level._effect["large_ceiling_dust"]		= LoadFx( "env/dirt/fx_dust_ceiling_impact_lg_mdbrown" );
	level._effect["poltergeist"]			= LoadFx( "misc/fx_zombie_couch_effect" );
	level._effect["gasfire"] 				= LoadFx("destructibles/fx_dest_fire_vert");
	level._effect["switch_sparks"]			= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["wire_sparks_oneshot"] = loadfx("env/electrical/fx_elec_wire_spark_dl_oneshot");
	
	// rise fx
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
}

precache_createfx_fx()
{
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

	
	//ESM - added for perk machines
	level._effect["electric_short_oneshot"] = loadfx("env/electrical/fx_elec_short_oneshot");
}

spawnFX()
{
	maps\createfx\nazi_zombie_tutorial_fx::main();
}