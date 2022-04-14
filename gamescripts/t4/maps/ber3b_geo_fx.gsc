//
// file: ber3b_fx.gsc
// description: fx script for berlin3b: setup, special fx functions, etc.
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\ber3_util;

main()
{
	maps\createart\ber3b_art::main();
	maps\createfx\ber3b_fx::main();
	precache_util_fx();
	precache_createfx_fx();
	fireflicker();	
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) )
	{
		disableFX = 0;
	}
	
	if( disableFX <= 0 )
	{
		precache_scripted_fx();
		thread play_scripted_fx();
	}
	
	thread vol_fog_think( disableFX );

	VisionSetNaked( "Ber3b", 0.1 );
}

precache_scripted_fx()
{
	// fakefire muzzleflashes
	level._effect["distant_muzzleflash"] = LoadFX( "weapon/muzzleflashes/heavy" );
	
	// sandbag explosion
	level._effect["sandbag_explosion_small"] = LoadFX( "maps/ber3/fx_sandbag_exp_sm" );
	
	// spotlight
	level._effect["spotlight_beam"] = LoadFX( "env/light/fx_ray_spotlight_md" );
	level._effect["spotlight_burst"] = LoadFX( "env/electrical/fx_elec_searchlight_burst" );
	
	// banner on fire
	level._effect["banner_fire_large"] = LoadFX( "destructibles/fx_fire_banner_lg_04" );
	
	// flag highlight (d-light)
	level._effect["flag_highlight"] = LoadFX( "misc/fx_NV_dlight" );
	
	// eagle fall
	level._effect["eagle_support_break"] = LoadFX( "maps/ber3/fx_dust_eagle_support_break" );
	level._effect["eagle_fall_impact"] = LoadFX( "maps/ber3/fx_eagle_fall_impact" );
	
	// mortar team stuff
	level._effect["mortar_flash"] = LoadFx( "weapon/mortar/fx_mortar_launch_w_trail" );
	level.scr_sound["mortar_flash"] ="wpn_mortar_fire";
	level._effect["mortar_explosion"] = LoadFX( "explosions/fx_mortarexp_dirt" );
	
	level.mortar = level._effect["mortar_explosion"];
	
	// statue fall
	level._effect["statue_fall"] = LoadFX( "maps/ber3/fx_statue_fall_cloud" );
	
	// plane tracers
	level._effect["plane_tracers"] = LoadFX( "weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	
	// gun fx
	level._effect["rifleflash"] = LoadFX( "weapon/muzzleflashes/rifleflash" );
	level._effect["rifle_shelleject"] = LoadFX( "weapon/shellejects/rifle" );
	level._effect["pistolflash"] = LoadFX( "weapon/muzzleflashes/pistolflash" );
	level._effect["pistol_shelleject"] = LoadFX( "weapon/shellejects/pistol" );
}

play_scripted_fx()
{	
	level waittill( "load main complete" );
	
	thread spotlight_fx();
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
}

// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["fx_reichstage_dome_fallout"] = loadfx ("maps/ber3/fx_reichstage_dome_fallout");
	
	level._effect["fire_static_detail"]			     = loadfx ("env/fire/fx_static_fire_detail_ndlight");
	level._effect["fire_static_small"]			     = loadfx ("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]			   = loadfx ("env/fire/fx_static_fire_md_ndlight");
  level._effect["dlight_fire_glow"]			       = loadfx ("env/light/fx_dlight_fire_glow");

	level._effect["fire_distant_150_150"]			   = loadfx ("env/fire/fx_fire_150x150_tall_distant");
	level._effect["fire_distant_150_600"]			   = loadfx ("env/fire/fx_fire_150x600_tall_distant");

	level._effect["fire_wall_100_150"]			     = loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["fire_ceiling_100_100"]			   = loadfx ("env/fire/fx_fire_ceiling_100x100");
	level._effect["fire_ceiling_300_300"]			   = loadfx ("env/fire/fx_fire_ceiling_300x300");
	level._effect["fire_win_smk_0x35y50z_blk"]	 = loadfx ("env/fire/fx_fire_win_smk_0x35y50z_blk");

	level._effect["smoke_detail"]			            = loadfx ("env/smoke/fx_smoke_smolder_sm_blk");
  level._effect["smoke_battle_mist"]			      = loadfx ("maps/ber3/fx_smoke_dome_floor");
  level._effect["smoke_plume_lg_slow_blk"]			= loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");

	level._effect["smoke_hallway_thick_dark"]			= loadfx ("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]			= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]			        = loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	
	level._effect["water_single_leak"]			      = loadfx ("env/water/fx_water_single_leak");
	level._effect["water_leak_runner"]			      = loadfx ("env/water/fx_water_leak_runner_100");
	
	level._effect["debris_burning_paper_dome"]		= loadfx ("maps/ber3/fx_debris_burning_papers_dome");
  level._effect["debris_paper_falling"]		      = loadfx ("maps/ber3/fx_debris_papers_falling");
  level._effect["debris_wood_burn_fall"]			  = loadfx ("maps/ber3/fx_debris_burning_wood_fall");

  level._effect["flak_field"]		                = loadfx ("weapon/flak/fx_flak_field_8k");
  level._effect["ray_huge_light"]		            = loadfx ("env/light/fx_ray_sun_xxlrg_linear");
  
  level._effect["wire_sparks"]		              = loadfx ("env/electrical/fx_elec_wire_spark_burst");
  level._effect["wire_sparks_blue"]		          = loadfx ("env/electrical/fx_elec_wire_spark_burst_blue");
  
  level._effect["lantern_light"]		            = loadfx ("env/light/fx_lights_lantern_on");
  level._effect["candle_flame"]		              = loadfx ("env/light/fx_lights_candle_flame"); 
}

spotlight_fx()
{
	spots = GetStructArray( "struct_spotlight_fx", "targetname" );
	
	for( i = 0; i < spots.size; i++ )
	{
		spot = spots[i];
		
		spot thread spotlight_fx_spawn();
	}
}

// self = the fx spot
spotlight_fx_spawn()
{
	org = Spawn( "script_model", self.origin );
	org.angles = self.angles;
	org SetModel( "tag_origin" );
	PlayFXOnTag( level._effect["spotlight_beam"], org, "tag_origin" );
	org playloopsound( "ber3b_lightbulb_loop" );
	self.fxOrg = org;		
	self thread spotlight_damage_think();
}

// self = a spotlight fx spot
spotlight_damage_think()
{
	if( !IsDefined( self.target ) )
	{
		return;
	}
	
	trig = undefined;
	model_undamaged = undefined;
	
	ents = GetEntArray( self.target, "targetname" );
	
	for( i = 0; i < ents.size; i++ )
	{
		ent = ents[i];
		
		if( ent.classname == "trigger_damage" )
		{
			trig = ent;
		}
		else if( ent.classname == "script_model" )
		{
			model_undamaged = ent;
		}
		else
		{
			ASSERTMSG( "spotlight_damage_think(): couldn't identify fxspot target of classname " + ent.classname );
		}
	}
	
	ASSERTEX( IsDefined( trig ) && IsDefined( model_undamaged ), "spotlight_damage_think(): couldn't find either the damage trigger or the undamaged model for fxspot at origin " + self.origin );

	model_damaged = GetEnt( model_undamaged.target, "targetname" );
	middleman = GetStruct( trig.target, "targetname" );
	light = GetEnt( middleman.target, "targetname" );
	
	ASSERTEX( IsDefined( trig.classname ) && trig.classname == "trigger_damage", "Trigger fx spot at origin " + self.origin + " does not target a damage trigger." );
	ASSERTEX( IsDefined( light ), "Trigger fx spot at origin " + self.origin + " does not connect to a light source." );
	
	light.ogIntensity = light GetLightIntensity();
	
	// hide damaged version
	model_damaged Hide();
	
	trig waittill( "trigger" );
	
	trig Delete();
	
	// model swap
	model_undamaged Hide();
	model_damaged Show();
	
	if( IsDefined( self.fxOrg ) )
	{
		PlayFX( level._effect["spotlight_burst"], self.fxOrg.origin, self.fxOrg.angles );
		
		light SetLightIntensity( light GetLightIntensity() - ( light.ogIntensity / 2 ) );
		
		self.fxOrg Delete();
	}
}

vol_fog_think( disableFX )
{
	set_vol_fog( "map_start" );
	
	//if( disableFX <= 0 )
	//{
	//	trigger_wait( "trig_roof_outside_entrance", "targetname" );
	//	set_vol_fog( "roof" );
	//}
}

set_vol_fog( section )
{
	switch( section )
	{
		case "map_start":
			setVolFog( 90, 2500, 0, 3000, 0.2901, 0.2941, 0.3019, 0 );
			break;
			
		case "roof":
			setVolFog( 90, 8000, 0, 3750, 0.3137, 0.3176, 0.3254, 5 );
			break;
			
		default:
			ASSERTMSG( "vol_fog setting for map section " + section + " not found." );
	}
}


// ---------------------
// ambient FX functions
// ---------------------

// self = a script_struct in the map
ambient_fakefire( endonString, delayStart )
{
	if( delayStart )
	{
		wait( RandomFloatRange( 0.25, 5 ) );
	}
	
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}
	
	team = undefined;
	fireSound = undefined;
	weapType = "rifle";
	
	if( !IsDefined( self.script_noteworthy ) )
	{
		team = "allied_rifle";
	}
	else
	{
		team = self.script_noteworthy;
	}
	
	switch( team )
	{
		case "axis_rifle":
			fireSound = "weap_g43_fire";
			weapType = "rifle";
			break;
		
		case "allied_rifle":
			fireSound = "weap_svt40_fire";
			weapType = "rifle";
			break;
			
		case "axis_smg":
			fireSound = "weap_mp44_fire";
			weapType = "smg";
			break;
		
		case "allied_smg":
			fireSound = "weap_ppsh_fire";
			weapType = "smg";
			break;
			
		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}
	
	// TODO make the sound chance dependent on player proximity?
	
	if( weapType == "rifle" )
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 60;
		
		burstMin = 1;
		burstMax = 4;
		betweenShotsMin = 0.8;
		betweenShotsMax = 1.3;
		reloadTimeMin = 5;
		reloadTimeMax = 10;
	}
	else
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 45;
		
		burstMin = 6;
		burstMax = 17;
		betweenShotsMin = 0.08;
		betweenShotsMax = 0.12;
		reloadTimeMin = 5;
		reloadTimeMax = 12;
	}
	
	while( 1 )
	{		
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );
		
		for (i = 0; i < burst; i++)
		{			
			// TODO randomize the target a bit so we're not always firing in the same direction
			// get a point in front of where the struct is pointing
			traceDist = 10000;
			target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );
			
			BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			PlayFX( muzzleFlash, self.origin, AnglesToForward( self.angles ) );
			
			// snyder steez - reduce popcorn effect
			if( RandomInt( 100 ) <= soundChance )
			{
				thread play_sound_in_space( fireSound, self.origin );
			}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
	
}

fireflicker()
{
	lights = getentarray("firecaster","targetname");
	array_thread(lights,::fire_lights);
}
fire_lights()
{
	//light thread maps\_lights::generic_flickering();
	//self thread maps\_lights::flickerLight( (1, 0.5647, 0),(1, 0.3215, 0.0156), .05, .5);
	self thread maps\_lights::burning_trash_fire();
}