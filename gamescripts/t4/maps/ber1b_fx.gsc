// scripting by Bloodlust
// level design by BSouds

// sets up FX for Berlin 1
main()
{
	level.fleshhit 								= loadfx("impacts/flesh_hit");
	level.headshot  							= loadfx("impacts/flesh_hit_head_fatal_exit");
	level.mortar 								= loadfx("explosions/fx_mortarExp_dirt");
	
	
	
	level._effect["alley_wall_explode"]			= loadfx("weapon/satchel/fx_satchel_concrete");
	level._effect["bunker_explode"]				= loadfx("maps/ber1/fx_mg_bunker_explosion_md");
	level._effect["tank_thru_wall"]				= loadfx("maps/ber1/fx_tank_wall_damage_dust");
	level._effect["mg42_thru_door"]				= loadfx("maps/ber1/fx_doors_destroyed_bullets");
	
	level._effect["flatcar_explode"]			= loadfx("maps/ber1/fx_train_flatbed_explosion");
	level._effect["tankercar_explode"]			= loadfx("maps/ber1/fx_traincar_fuel_explosion_lg");
	
	level._effect["stuka_hit"]					= loadfx("vehicle/fx_Vexplode_generic_sm");
	level._effect["stuka_smoke_trail"]			= loadfx("trail/fx_trail_plane_smoke_fire_damage");
	level._effect["stuka_explode"]				= loadfx("vehicle/vexplosion/fx_Vexplode_stuka_crash_ground");
	
	level._effect["rocket_trail"]				= loadfx("weapon/rocket/fx_trail_panzerfaust_geotrail");
	level._effect["rocket_explode"]				= loadfx("Weapon/Rocket/fx_LCI_rocket_explosion_beach");
	
	level._effect["smokenade"]					= loadfx("weapon/fx_smoke_grenade_generic");
	level._effect["tankdust"]					= loadfx("maps/ber1/fx_tank_wall_roof_dust");
	
	
	
	precacheshellshock("teargas");
	precacheshader("black");
}