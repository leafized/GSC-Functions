/*-----------------------------------------------------
Effects used for Rhineland 1
-----------------------------------------------------*/
#include maps\_utility;

main()
{
	
	precachefx();
	pod1_fx();		
}


precacheFX()
{
	
	level.mortar = loadfx("explosions/fx_mortarExp_dirt");
	
	level._effectType["dirt_mortar"] 			= "mortar";
	level._effect["dirt_mortar"]					= loadfx("explosions/fx_mortarExp_dirt");
	
	level._effectType["water_mortar"] 		= "mortar";
	level._effect["water_mortar"]					= loadfx("explosions/mortarExp_water");
		
	level._effectType["convoy_mortar"] 		= "mortar";
	level._effect["convoy_mortar"]					= loadfx("explosions/fx_mortarExp_dirt");
	
	//level._effect["test_dust"] = loadfx("env/dirt/fx_dust_ceiling_impact_lg_mdbrown");
	
	level._effect["chimney_smoke"]		= loadfx ("smoke/thin_black_smoke_M");
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );	
}

pod1_fx()
{

	thread chimney_smoke();

}

chimney_smoke()
{
	chimney = getent("chim_smoke","targetname");
	x = maps\_utility::createLoopEffect("chimney_smoke");
  x.v["origin"] = chimney.origin;
  x.v["angles"] = chimney.angles;
}


//dust()
//{
//	iprintlnbold("playing the dust effect");
//	while(1)
//	{
//		wait(4);
//		playfx(level._effect["test_dust"],(-14220,21880,136));
//	}
//	//dust = (-14220,21880,136);
//	//x = maps\_utility::createLoopEffect("test_dust");
// /// x.v["origin"] = (-14220,21880,136);
// // x.v["angles"] = (0,0,0);
//}