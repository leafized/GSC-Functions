#include maps\mp\_utility;

main()
{
	precacheFX();
	spawnFX();
}

precacheFX()
{
	//////////////////////////////////////////////////////////////////////////////////////
	// Alex Section:

	//level._effect["distant_muzzleflash"]		=	loadfx("weapon/muzzleflashes/heavy");

	//level._effect["flak_flash"] 	= loadfx("weapon/flak/fx_flak_cloudflash_night");
		
}

spawnFX()
{
	maps\mp\createfx\mp_trenches_fx::main();
}    

