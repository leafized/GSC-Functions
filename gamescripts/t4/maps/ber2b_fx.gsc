//
// file: ber2b_fx.gsc
// description: fx script for berlin2b
// scripter: slayback
//

#include maps\_utility;
#include maps\ber2_util;

main()
{
	precache_util_fx();
	maps\createfx\ber2b_fx::main();
	precache_createfx_fx();
}

	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////BARRYS SECTION	////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////
precache_createfx_fx()
{
	level._effect["fire_blown_md_blk_smk"]		   	= loadfx ("env/fire/fx_fire_blown_md_blk_smk");
	level._effect["smoke_hallway_thick_dark"]			= loadfx ("maps/ber2/fx_smoke_hallway_smoke_roll_dark");
	level._effect["smoke_hallway_faint_dark"]			= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]			        = loadfx ("env/smoke/fx_smoke_window_lg_gry");
	level._effect["smoke_plume_lg_slow_blk"]			= loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");
	
	level._effect["building_2b_collapase_delete_me"]			        = loadfx ("maps/ber2/fx_building_2b_collapse");
	level._effect["building_2b_collapase_fallout_delete_me"]			= loadfx ("maps/ber2/fx_building_2b_collapse_fallout");

	level._effect["fire_static_blk_smk"]			= loadfx ("env/fire/fx_static_fire_md_anim");
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
}
