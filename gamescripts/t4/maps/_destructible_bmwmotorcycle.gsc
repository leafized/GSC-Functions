// Destructible initialization script
#include maps\_destructible;
#using_animtree( "vehicles" );

init()
{
	set_function_pointer( "explosion_anim", "dest_bmwmotorcycle", ::get_explosion_animation );
	set_function_pointer( "flattire_anim", "dest_bmwmotorcycle", ::get_flattire_animation );

	build_destructible_radiusdamage( "dest_bmwmotorcycle", undefined, 125, 200, 40, true );
	build_destructible_deathquake( "dest_bmwmotorcycle", 0.3, 1.0, 400 );

	set_pre_explosion( "dest_bmwmotorcycle", "destructibles/fx_dest_fire_car_fade_40" );
}

get_explosion_animation()
{
	return %v_bmwmotorcycle_explode;
}

get_flattire_animation( broken_notify )
{
	if( broken_notify == "flat_tire_left_rear" )
	{
		return %v_bmwmotorcycle_flattire_back;
	}
	else if( broken_notify == "flat_tire_right_rear" )
	{
		return %v_bmwmotorcycle_flattire_sidecar;
	}
	else if( broken_notify == "flat_tire_left_front" )
	{
		return %v_bmwmotorcycle_flattire_front;		
	}
	else if( broken_notify == "flat_tire_spare" )
	{
		return %v_bmwmotorcycle_flattire_spare;
	}
}

empty()
{
}