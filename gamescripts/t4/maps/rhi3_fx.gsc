// FX Level File
#include maps\_utility;

main()
{
	precache_fx();
}


precache_fx()
{
	level.fx_sub_explosion = loadfx("explosions/fx_mortarexp_dirt"); 
	level.flak_tracer = loadfx("weapon/tracer/fx_tracer_quad_20mm_Flak38_noExp"); 
	//level.flak_tracer = loadfx("weapon/tracer/fx_tracer_flak_single_noExp");
}
