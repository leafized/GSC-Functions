footsteps()
{
    animscripts\utility::setFootstepEffect( "brick",		LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "carpet",	LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "cloth",		LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "concrete",	LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "dirt",		LoadFX( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "foliage",	LoadFX( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "gravel",	LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "grass",		LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "metal",		LoadFX( "bio/player/fx_footstep_dust" ) );  
    animscripts\utility::setFootstepEffect( "paper",		LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "plaster",	LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "rock",		LoadFX( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "sand",		LoadFX( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "water",		LoadFX( "bio/player/fx_footstep_water" ) ); 
    animscripts\utility::setFootstepEffect( "wood",		LoadFX( "bio/player/fx_footstep_dust" ) ); 

}


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
	// Flamethrower
	level._effect["character_fire_pain_sm_1sec"] 	= LoadFX( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"]    	= LoadFX( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFX( "env/fire/fx_fire_player_torso" );
	
	// misc
	level._effect["flesh_hit"]						= LoadFX( "impacts/flesh_hit" );
	level._effect["payLoadFX"] 						= LoadFX( "env/light/fx_ray_sun_med_linear" );
	level._effect["kamikaze_boom"] 					= LoadFX( "explosions/fx_flamethrower_char_explosion" );
	level._effect["cow_milk"] 						= LoadFX( "explosions/cow_milk" );	
	
	level._effect["payLoadFX"] 						= LoadFX( "env/light/fx_ray_sun_med_linear" );
	level._effect["kamikaze_boom"] 					= LoadFX( "explosions/fx_flamethrower_char_explosion" );
	level._effect["cow_milk"]						= LoadFX( "explosions/cow_milk" );
	level._effect["dog_splat"] 						= LoadFX( "impacts/flesh_hit_splat" );
	level._effect["eye_glow"]			 			= LoadFX( "misc/fx_zombie_eye_single" ); 
	level._effect["headshot"] 						= LoadFX( "impacts/flesh_hit_head_fatal_lg_exit" );
	level._effect["headshot_nochunks"] 				= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] 					= LoadFX( "misc/fx_zombie_bloodspurt" );
	
	// Flamethrower
	level._effect["character_fire_pain_sm"]			= LoadFX( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"]        = LoadFX( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFX( "env/fire/fx_fire_player_torso" );
}

precache_createfx_fx()
{
	//level._effect["insect_swarm"]						= LoadFX ("bio/insects/fx_insects_ambient");
}


main()
{
	//clientscripts\createfx\pel2_fx::main();

	precache_util_fx();
	
	footsteps();
	
	//precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}