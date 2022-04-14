#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_brandenburg_art::main();
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();
	spawnFX();
}

// load fx used by util scripts
precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
	level._effect["mp_fire_small_detail"]							  = loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_small"]							        = loadfx("maps/mp_maps/fx_mp_fire_small");
	level._effect["mp_fire_medium"]							        = loadfx("maps/mp_maps/fx_mp_fire_medium");
	level._effect["mp_fire_large"]							        = loadfx("maps/mp_maps/fx_mp_fire_large");
	level._effect["mp_fire_tree_trunk"]							    = loadfx("maps/mp_maps/fx_mp_fire_tree_trunk");
	level._effect["mp_battlesmoke_thick_large_area"]    = loadfx("maps/mp_maps/fx_mp_battlesmoke_thick_large_area");
	level._effect["mp_battlesmoke_thick_small_area"]	  = loadfx("maps/mp_maps/fx_mp_battlesmoke_thick_small_area");
	level._effect["mp_fog_rolling_thick_large_area"]	  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_large_area");
	level._effect["mp_fog_rolling_thick_small_area"]	  = loadfx("maps/mp_maps/fx_mp_fog_rolling_thick_small_area");
	level._effect["mp_smoke_ambiance_indoor"]						= loadfx("maps/mp_maps/fx_mp_smoke_ambiance_indoor");
	level._effect["mp_smoke_column_tall"]							  = loadfx("maps/mp_maps/fx_mp_smoke_column_tall");
	level._effect["mp_smoke_column_short"]						  = loadfx("maps/mp_maps/fx_mp_smoke_column_short");
	level._effect["mp_light_glow_indoor_short"]				  = loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short");
	level._effect["mp_light_glow_indoor_long"]				  = loadfx("maps/mp_maps/fx_mp_light_glow_indoor_long");
	level._effect["mp_light_glow_outdoor"]							= loadfx("maps/mp_maps/fx_mp_light_glow_outdoor");
}

spawnFX()
{
	maps\mp\createfx\mp_brandenburg_fx::main();
}