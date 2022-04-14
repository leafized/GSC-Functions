// scripting by Bloodlust
// level design by BSouds

// sets up FX for Berlin 1
main()
{
maps\createart\ber1_art::main();//added by rich
thread vison_settings();//added by rich
	
	
	
	level.mortar 									= loadfx("explosions/fx_mortarExp_dirt");
	
	level._effect["fleshhit"]						= loadfx("impacts/flesh_hit");
	level._effect["headshot"]  						= loadfx("impacts/flesh_hit_head_fatal_exit");
	level._effect["blood_splat"]  					= loadfx("maps/ber1/fx_flesh_execution_blood");
	
	level._effect["one_squib"]						= loadfx("impacts/fx_bullet_dirt_lg");
	level._effect["distant_muzzleflash"]			= loadfx("weapon/muzzleflashes/heavy");

	level._effect["alley_wall_explode"]				= loadfx("weapon/satchel/fx_satchel_concrete");
	level._effect["bunker_explode"]					= loadfx("maps/ber1/fx_mg_bunker_explosion_md");
	level._effect["mg42_thru_door"]					= loadfx("maps/ber1/fx_doors_destroyed_bullets");
	
	level._effect["flatcar_explode"]				= loadfx("maps/ber1/fx_train_flatbed_explosion");
	level._effect["tankercar_explode"]				= loadfx("maps/ber1/fx_traincar_fuel_explosion_lg");
	level._effect["mg_nest_explode"]				= loadfx("maps/ber1/fx_sandbag_exp_trainyard");
	level._effect["shockwave"]						= loadfx("maps/ber1/fx_exp_shock_blast");
	
	level._effect["stuka_hit"]					   	= loadfx("vehicle/vexplosion/fx_Vexplode_generic_sm");
	level._effect["stuka_smoke_trail"]			  	= loadfx("trail/fx_trail_plane_smoke_fire_damage");
	level._effect["stuka_explode"]					= loadfx("vehicle/vexplosion/fx_Vexplode_stuka_crash_ground");
	level._effect["stuka_impact"]					= loadfx("vehicle/vexplosion/fx_Vexplode_stuka_crash_ground");
	level._effect["stuka_building_collapse"]		= loadfx("maps/ber1/fx_building_stuka_collapse");
	
	level._effect["rocket_launch"]					= loadfx("weapon/muzzleflashes/fx_rocket_katyusha_launch");
	level._effect["rocket_trail"]					= loadfx("weapon/rocket/fx_rocket_katyusha_geotrail");
	level._effect["rocket_explode"]					= loadfx("maps/ber1/fx_exp_katyusha_barrage");
	level._effect["rocket_explode_far"]				= loadfx("maps/ber1/fx_exp_katyusha_barrage_far");
	level._effect["shreck_explode"]					= loadfx("explosions/default_explosion");
	level._effect["shreck_trail"]					= loadfx("weapon/rocket/fx_lci_rocket_geotrail");
	level._effect["barrage_aftermath"]				= loadfx("maps/ber1/fx_rocket_katusha_aftermath");
	
	level._effect["smokenade"]						= loadfx("weapon/grenade/fx_smoke_grenade_generic");
	level._effect["impactdust"]						= loadfx("explosions/tank_impact_dirt");
	
	level._effect["transformer_explode"]			= loadfx("env/electrical/fx_elec_wire_spark_huge_burst");
	level._effect["transformer_sparks"]				= loadfx("env/electrical/fx_elec_tranformer_sparks");
	level._effect["wire_sparks"]					= loadfx("env/electrical/fx_elec_wire_sparks");
	level._effect["wire_sparks_burst"]				= loadfx("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["chimney_collapse"]				= loadfx("maps/ber1/fx_chimney_collapse");
	level._effect["intro_house_collapse"]			= loadfx("maps/ber1/fx_house_artillery_collapse");
	level._effect["office_collapse"]				= loadfx("maps/ber1/fx_building_artillery_collapse");
	level._effect["clock_impact"]					= loadfx("maps/ber1/fx_clock_fall_impact");
	
	level._effect["tank_damage"]					= loadfx("vehicle/vfire/vsmoke_t34_engine");
	level._effect["tank_thru_wall"]					= loadfx("maps/ber1/fx_tank_wall_damage_dust");	
	level._effect["tank_thru_cafe_wall"]			= loadfx("maps/ber1/fx_tank_wall_topple");
	level._effect["asylum_gate_explode"]			= loadfx("maps/ber1/fx_exp_gate_debris");
	level._effect["asylum_wall_explode"]			= loadfx("maps/ber1/fx_exp_wall_debris");
	
	level._effect["train_exhaust_smoke"]			= loadfx("vehicle/exhaust/fx_exhaust_train_smoke");
	level._effect["train_exhaust_steam"]			= loadfx("vehicle/exhaust/fx_exhaust_train_steam");
	level._effect["train_smoke_trail_fx"]			= loadfx("maps/ber1/fx_smk_train_wheel_amb");
	level._effect["train_wheel_steam"]				= loadfx("vehicle/exhaust/fx_exhaust_train_wheel_steam");
	level._effect["train_sun_rays"]					= loadfx("maps/ber1/fx_ray_sun_med_traincar");
	
	
	maps\createfx\ber1_fx::main();
	precacheshellshock("teargas");
	precacheshader("black");

	
	
//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRY'S SECTION	//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
	level._effect["smoke_hallway_thick_dark"]		= loadfx ("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]		= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]				= loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	
	level._effect["smoke_plume_xlg_slow_blk"]		= loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["smoke_plume_sm_fast_blk_w"]		= loadfx ("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_plume_md_slow_def"]		= loadfx ("env/smoke/fx_smoke_plume_md_slow_def");
	level._effect["smoke_plume_lg_slow_def"]		= loadfx ("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["brush_smoke_smolder_sm"]			= loadfx ("env/smoke/fx_smoke_brush_smolder_md");
	
	level._effect["smoke_bank"]						= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["battlefield_smokebank_sm_tan_w"]	= loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["smoke_impact_smolder_w"]		    = loadfx ("env/smoke/fx_smoke_crater_w");
	level._effect["brush_smolder_w"]		      	= loadfx ("env/fire/fx_fire_brush_smolder_md");
	level._effect["brush_fire_smolder_sm"]			= loadfx ("env/fire/fx_fire_brush_smolder_sm");
	
	
	level._effect["fire_static_small"]			    = loadfx ("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]			= loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]			    = loadfx ("env/light/fx_dlight_fire_glow");
	level._effect["fire_blown_pm"]			        = loadfx ("env/fire/fx_fire_barrel_pm");
	level._effect["fire_window"]			        = loadfx ("env/fire/fx_fire_win_nsmk_0x35y50z");
	
	level._effect["fire_wall_100_150"]	  			= loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["car_fire_large"]					= loadfx ("env/fire/fx_fire_blown_md_blk_smk");
	level._effect["bldg_fire_medium"]				= loadfx ("env/fire/fx_fire_blown_md_light_blk_smk");
	level._effect["fire_tree"]						= loadfx ("env/fire/fx_fire_smoke_tree_trunk_med");
	
	level._effect["fire_smoke_med"]       			= loadfx("env/fire/fx_fire_smoke_house_wood_med");
	level._effect["fire_xlarge_distant"]			= loadfx ("env/fire/fx_fire_xlarge_distant");
	
	level._effect["falling_lf_elm"]       			= loadfx("env/foliage/fx_leaves_fall_elm");
	level._effect["debris_paper_falling"]			= loadfx ("maps/ber3/fx_debris_papers_falling");
	level._effect["ash_and_embers"]					= loadfx ("env/fire/fx_ash_embers_light");
	
	level._effect["water_leak_runner"]	  			= loadfx ("env/water/fx_water_leak_runner_100");
}

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////Rich'S SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

vison_settings()//calls the default fog and vision settings
{
	
	VisionSetNaked( "ber1_default", 1 );
	setVolFog(343.302, 2986.33, 116.318, -392.213, 0.804454, 0.714666, 0.609986, 0);

}