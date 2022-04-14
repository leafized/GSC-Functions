#include maps\_utility;


main()
{
	precache_createfx_fx();
	thread wind_settings();
	spawnFX();
}



//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRYS SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
precache_createfx_fx()
{
	level._effect["falling_leaves_elm"] = loadfx("env/foliage/fx_leaves_fall_elm_lt");
	level._effect["falling_leaves_pine"] = loadfx("env/foliage/fx_leaves_fall_pine_lt");
	level._effect["leaves_kickup"] = loadfx("env/foliage/fx_leaves_pickup");
	level._effect["water_ripple"] = loadfx("env/water/fx_water_ripple_puddle");
	level._effect["dust_kickup"] = loadfx("env/dirt/fx_dust_kickup_sm");
	level._effect["dust_kickup_lg"] = loadfx("env/dirt/fx_dust_kickup_lg");
	level._effect["godray_small"] = loadfx("env/light/fx_ray_sun_sm_short");
	level._effect["godray_med"] = loadfx("env/light/fx_ray_sun_med_short");
	level._effect["godray_streak"] = loadfx("env/light/fx_ray_sun_streak_short");
	level._effect["insect_cloud"] = loadfx("bio/insects/fx_insects_ambient");
	level._effect["cave_drip"] = loadfx("maps/training/fx_cave_drip");
	level._effect["heat_haze_sm"] = loadfx("env/weather/fx_heathaze_sm");
	level._effect["heat_haze_md"] = loadfx("env/weather/fx_heathaze_md");
	level._effect["circling_seagulls"] = loadfx("bio/animals/fx_seagulls_circling");
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "144 144 0" ); // 211.2 inches per second or about 12mph with wind going NE (if N is (0,1,0))
	SetSavedDvar( "wind_global_low_altitude", 200 );
	SetSavedDvar( "wind_global_hi_altitude", 12000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 ); // brings ground level wind down to 6mph
}

spawnFX()
{
	maps\createfx\training_fx::main();	// Calls in ambient effects created with CreateFX
}