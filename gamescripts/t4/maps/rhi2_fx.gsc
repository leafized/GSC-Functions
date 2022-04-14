//
// file: rhi2_fx.gsc
// description: fx script for rhineland2: setup, special fx functions, etc.
// scripter: slayback
//

#include maps\_utility;
main()
{
	precache_util_fx();
	
	level._effect["flamethrower_fire"] = LoadFX( "env/fire/flamethrower_fire" );
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
}