// Destructible initialization script
#include maps\_destructible;
#using_animtree( "vehicles" );

init()
{
	set_function_pointer( "explosion_anim", "dest_horch1a", ::get_explosion_animation );
	set_function_pointer( "flattire_anim", "dest_horch1a", ::get_flattire_animation );

	build_destructible_radiusdamage( "dest_horch1a", undefined, 240, 210, 60, true );
	build_destructible_deathquake( "dest_horch1a", 0.4, 1.0, 500 );

	set_pre_explosion( "dest_horch1a", "destructibles/fx_dest_fire_car_fade_40" );
}

get_explosion_animation( broken_notify )
{
	return %v_horch1a_explode;
}

get_flattire_animation( broken_notify )
{
	if( broken_notify == "flat_tire_left_rear" )
	{
		return %v_horch1a_flattire_lb;
	}
	else if( broken_notify == "flat_tire_right_rear" )
	{
		return %v_horch1a_flattire_rb;
	}
	else if( broken_notify == "flat_tire_left_front" )
	{
		return %v_horch1a_flattire_lf;		
	}
	else if( broken_notify == "flat_tire_right_front" )
	{
		return %v_horch1a_flattire_rf;
	}
}

empty()
{
}