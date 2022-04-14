#include maps\mp\_utility;

main()
{
	precacheFX();
	spawnFX();
}

precacheFX()
{
	level._effect["mortar_point"]			= loadfx("maps/ber1/fx_exp_katyusha_barrage_far");
//	level._effect["mortar_point"]			= loadfx("explosions/fx_mortarExp_dirt_airfield");
	level._effectType["mortar_point"]	 	= "artillery"; // "mortar", "bomb" or "artillery"
	
	level._effect["car_fire_large"]			= loadfx ("env/fire/fx_fire_blown_md_blk_smk");
	level._effect["fire_static_blk_smk"]	= loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["fire_static_small"]		= loadfx ("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_smoke_med"]       	= loadfx("env/fire/fx_fire_smoke_house_wood_med");
	level._effect["tree_fire_med"]       	= loadfx("env/fire/fx_fire_smoke_tree_trunk_med");
	level._effect["flak88_fire"] 			= loadFX("weapon/tracer/fx_tracer_flak_single_noExp");	
}

spawnFX()
{
	maps\mp\createfx\mp_cavern_fx::main();
}