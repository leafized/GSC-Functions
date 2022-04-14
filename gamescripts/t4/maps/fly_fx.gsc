// FX Level File

main()
{
	flak();
}

// Setup the flak FX.
flak()
{
	level._effect["air_burst"]	= LoadFx( "explosions/default_explosion" );
	//level._effect["wing_tip"]	= LoadFx( "smoke/smoke_geotrail_rpg" );

	level._effect["puff"]		= LoadFx( "env/smoke/fx_plane_smoke_trail_puff_02" );
	level._effect["wing_tip"]	= LoadFx( "env/smoke/fx_plane_wingtip_geotrail" );
//	level._effect["wing_tip"]	= LoadFx( "weapon/rocket/fx_LCI_rocket_geotrail" );

	level._effect["damage"]		= LoadFx( "env/smoke/fx_plane_smoke_trail_damage" );
}