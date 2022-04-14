// Destructible initialization script
#include maps\_destructible;
#using_animtree( "vehicles" );

init()
{
	set_function_pointer( "explosion_anim", "dest_type95scoutcar", ::get_explosion_animation );
	set_function_pointer( "flattire_anim", "dest_type95scoutcar", ::get_flattire_animation );

	build_destructible_radiusdamage( "dest_type95scoutcar", undefined, 175, 180, 40, true );
	build_destructible_deathquake( "dest_type95scoutcar", 0.4, 1.0, 450 );

	set_pre_explosion( "dest_type95scoutcar", "destructibles/fx_dest_fire_car_fade_40" );
}

get_explosion_animation( broken_notify )
{
	return %v_beetle_explode;
}

get_flattire_animation( broken_notify )
{
	if( broken_notify == "flat_tire_left_rear" )
	{
		return %v_type95_scoutcar_flatire_lb;
	}
	else if( broken_notify == "flat_tire_right_rear" )
	{
		return %v_type95_scoutcar_flatire_rb;
	}
	else if( broken_notify == "flat_tire_left_front" )
	{
		return %v_type95_scoutcar_flatire_lf;		
	}
	else if( broken_notify == "flat_tire_right_front" )
	{
		return %v_type95_scoutcar_flatire_rf;
	}
}

empty()
{
}