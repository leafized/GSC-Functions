// _flakvierling.gsc
// Sets up the behavior for the Flakvierling.

// Cleaned up by: SRS (03/29/07)
// included correcting as many instances of incorrect spelling as possible
// ("flakveirling" when it should be "flakvierling")
//
// WORK IN PROGRESS: no functionality yet, really.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
main( model, type )
{
	build_template( "flakvierling", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "german_artillery_flakveirling", "german_artillery_flakveirling_d" );
	build_shoot_shock( "tankblast" );
	//build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	//build_exhaust( "distortion/abrams_exhaust" );
	//build_deckdust( "dust/abrams_desk_dust" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	//build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_mainturret();
	//build_compassicon();
	build_aianims( ::setanims , ::set_vehicle_anims );
}

// Anything specific to this vehicle, used globally.
init_local()
{

}

// Animtion set up for vehicle anims
#using_animtree( "tank" );
set_vehicle_anims( positions )
{
	return positions;
}

setanims()
{
}
