// _goliath.gsc
// Sets up the behavior for the goliath remote bomb.

#include maps\_vehicle_aianim;
#include maps\_vehicle;

main(model,type)
{
	build_template( "goliath", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_ger_tracked_goliath", "vehicle_ger_tracked_goliath" );
	//build_exhaust( "distortion/abrams_exhaust" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_compassicon();
	//build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
}

// Anthing specific to this vehicle, used globally.
init_local()
{
	
}