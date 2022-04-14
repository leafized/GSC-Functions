#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;

// hol3 town square

main()
{

	savegame( "Hol3 Townsquare begin" );

	simple_spawn( "square_mg_spawners" );
	simple_spawn( "square_friendlies", ::square_friendlies_strat  );

	level thread square_sdks();
	level thread panzerschrek_respawn();

	trigger_wait( "trig_town_square", "targetname" );

	level thread mission_end_timer();

	flag_set( "wasps_move_into_square" );
	
	set_color_chain( "chain_square_1" );
	
}



mission_end_timer()
{

	trigger_wait( "trig_town_square", "targetname" );
	
	wait( 35 );
	
	flag_set( "sdk_1_dead" );
	flag_set( "sdk_2_dead" );
	
}


panzerschrek_respawn()
{

	panzerschreks = getentarray( "weapon_panzerschrek", "classname" );
	
	respawn_schrek = undefined;
	respawn_origin = undefined;
	respawn_angles = undefined;
	
	for( i  = 0; i < panzerschreks.size; i++ )
	{
		if( panzerschreks[i].angles == (0, 64.6, 0 ) )
		{
			respawn_schrek = panzerschreks[i];	
			respawn_origin = panzerschreks[i].origin;
			respawn_angles = panzerschreks[i].angles;
		}
	}
	
	
//	panzerschrek_info = [];
//	
//	// save their locations
//	for( i  = 0; i < panzerschreks.size; i++ )
//	{
//		panzerschrek_info[i] = spawnstruct();
//		panzerschrek_info[i].origin = panzerschreks[i].origin;
//		panzerschrek_info[i].angles = panzerschreks[i].angles;
//	}
	
	while( 1 )
	{
	
		if( !isdefined( respawn_schrek ) )
		{
			respawn_schrek = spawn( "weapon_panzerschrek", respawn_origin );
			respawn_schrek.angles = respawn_angles;			
		}	
	
//		for( i  = 0; i < panzerschreks.size; i++ )
//		{
//			if( !isdefined( panzerschreks[i] ) )
//			{
//				new_panzerschrek = spawn( "weapon_panzerschrek", panzerschrek_info[i].origin );
//				new_panzerschrek.angles = panzerschrek_info[i].angles;
//				panzerschreks[i] = new_panzerschrek;
//			}
//		}
		
		wait( 1 );
		
	}

}
	



///////////////////
//
// What the non-player squad is doing in the town square for the end event
//
///////////////////////////////

square_friendlies_strat()
{

	self endon( "death" );
	self magic_bullet_shield();
	
}



square_sdks()
{

	level.square_sdk_1 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "square_sdk_1" );
	level.square_sdk_2 = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "square_sdk_2" );

	level thread destroy_sdks_to_win();

	//level.square_sdk_1 thread keep_tank_alive();
	//level.square_sdk_2 thread keep_tank_alive();

	level.square_sdk_1 thread sdk_strat_1();
	level.square_sdk_2 thread sdk_strat_2();
	
	level thread sdk_1_death();
	level thread sdk_2_death();

}



sdk_1_death()
{

	level.square_sdk_1 waittill( "death" );
	flag_set( "sdk_1_dead" );
	
}



sdk_2_death()
{

	level.square_sdk_2 waittill( "death" );
	flag_set( "sdk_2_dead" );
	
}



destroy_sdks_to_win()
{

	flag_wait_all( "sdk_1_dead", "sdk_2_dead" );

	// TEMP
	if( isdefined( level.square_sdk_2 ) && level.square_sdk_2.health > 0 )
	{
		RadiusDamage( level.square_sdk_2.origin, 50, level.square_sdk_2.health + 100, level.square_sdk_2.health + 100 );			
	}

	level notify( "obj_town_assault_complete" );

	// have axis retreat
	axis_ai = getaiarray( "axis" );
	array_thread( axis_ai, ::retreat_delay );

	wait( 13 );
	nextmission();	
	
}



///////////////////
//
// SDK that gets flamed
//
///////////////////////////////

sdk_strat_1()
{

	self endon( "death" );
	self.health = 500;

	self veh_stop_at_node( "square_sdk_stop_1aa" );	
	
	flag_wait( "wasps_flame_fountain" );
	self resumespeed( 5 );
	
	vnode = getvehiclenode( "square_sdk_stop_1a", "script_noteworthy" );
	vnode waittill( "trigger" );

	// start shooting at the wasp while nearing end node
	self thread sdk_shoot_at_wasp_2();

	self veh_stop_at_node( "square_sdk_stop_1" );
	
	flag_wait( "wasp_counterattack" );
	
	wait( 2.5 );
	
	// take off its shield
	//self notify( "stop_keep_tank_alive" );
	
	RadiusDamage( self.origin, 100, self.health + 100, self.health + 100 );	
	
}



sdk_shoot_at_wasp_2()
{

	self endon( "death" );

	i = 0;

	while( i < 3 )
	{
	
		self setturrettargetent( level.wasp_2 );
		
		self waittill( "turret_on_target" ); 		
		
		self ClearTurretTarget(); 
		
		how_many_shots = randomintrange( 3, 5 );
		
		for( i  = 0; i < how_many_shots; i++ )
		{
			self notify( "turret_fire" );	
			wait( 0.35 );
		}
		
		wait( RandomFloatRange( 0.5, 1.5 ) );
		
		if( flag( "wasp_counterattack" ) )
		{
			i++;	
		}		
		
	}	
	
}



sdk_shoot_at_wasp_1()
{

	self endon( "death" );
	level endon( "wasp_counterattack" );
	
	while( 1 )
	{
	
		self setturrettargetent( level.wasp_1 );
		
		self waittill( "turret_on_target" ); 		
		
		self ClearTurretTarget(); 
		
		how_many_shots = randomintrange( 3, 5 );
		
		for( i  = 0; i < how_many_shots; i++ )
		{
			self notify( "turret_fire" );	
			wait( 0.35 );
		}
		
		wait( RandomFloatRange( 0.5, 1.5 ) );
		
	}	
	
}



///////////////////
//
// SDK that player kills
//
///////////////////////////////

sdk_strat_2()
{

	self endon( "death" );
	self.health = 500;

	self veh_stop_at_node( "square_sdk_stop_2aa" );	
	
	flag_wait( "wasps_flame_fountain" );
	self resumespeed( 5 );

	vnode = getvehiclenode( "square_sdk_stop_2a", "script_noteworthy" );
	vnode waittill( "trigger" );

	// start shooting at the wasp while nearing end node
	self thread sdk_shoot_at_wasp_2();

	self veh_stop_at_node( "square_sdk_stop_2" );	

	flag_wait( "wasp_2_dead" );

	self thread sdk_shoot_at_wasp_1();

	flag_wait( "wasp_counterattack" );
	
	self resumespeed( 5 );	
	
//	// take off its shield
//	self notify( "stop_keep_tank_alive" );	
	
	self thread sdk_fire_at_player();
	
	source_node = getvehiclenode ( "square_sdk_2_switch", "script_noteworthy" );
	dest_node = getvehiclenode( "square_sdk_2_switch_1", "script_noteworthy" );
	self setswitchnode( source_node, dest_node );	
	
	// wait till we're at the beginning of the spline loop
	self setwaitnode( dest_node );
	self waittill( "reached_wait_node" );	
	wait( 1 );	
	
	// have sdk 'patrol'
	while( 1 )
	{
		
		source_node = getvehiclenode ( "square_sdk_2_switch_2", "script_noteworthy" );
		dest_node = getvehiclenode( "square_sdk_2_switch_3", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );		
		
		self setwaitnode( dest_node );
		self waittill( "reached_wait_node" );			
		wait( 1 );
		
		// random wait on the path to mix it up
		if( randomint( 2 ) )
		{
			wait( 1 );
			self setspeed( 0, 7, 7 );	
			wait( RandomInt( 3, 6 ) );
			self resumespeed( 8 );	
		}
		
		source_node = getvehiclenode ( "square_sdk_2_switch_4", "script_noteworthy" );
		dest_node = getvehiclenode( "square_sdk_2_switch_1", "script_noteworthy" );
		self setswitchnode( source_node, dest_node );	
		
		self setwaitnode( getvehiclenode( "square_sdk_2_switch_1", "script_noteworthy" ) );
		self waittill( "reached_wait_node" );			
		wait( 1 );
		
	}	
	
}


///////////////////
//
// Wasp that survives
//
///////////////////////////////

wasp_1_square_strat()
{
	
	level.wasp_1 veh_stop_at_node( "wasp_1_stop_square_1" );	

	flag_wait( "wasps_move_into_square" );
	
	level.wasp_1 resumespeed( 5 );

	level.wasp_1 veh_stop_at_node( "wasp_1_stop_square_2" );	
	
	flag_set( "wasps_flame_fountain" );
	
	// flame guys in circle
	maps\hol3_yard::house_fire( level.wasp_1, "orig_square_1_fire", 7, undefined, "wasp_2_dead" );
	
	// move to counterattack sdk
	level.wasp_1 resumespeed( 5 );
	
	level.wasp_1 veh_stop_at_node( "wasp_1_stop_square_3" );		
	
	flag_set( "wasp_counterattack" );
	
	simple_floodspawn( "square_mg_spawners_2" );
	simple_spawn_single( "square_officer", ::square_officer_strat );
	
	
	// flame sdk
	maps\hol3_yard::house_fire( level.wasp_1, "orig_square_3_fire", 6, undefined, "sdk_2_dead" );	
	
	flag_wait( "sdk_2_dead" );
	
	level.wasp_1 resumespeed( 5 );	
	
	level.wasp_1 veh_stop_at_node( "wasp_1_stop_square_4" );		
	
	// flame the guys retreating
	maps\hol3_yard::house_fire( level.wasp_1, "orig_square_4_fire", 7 );	
	
}



///////////////////
//
// Wasp that dies
//
///////////////////////////////

wasp_2_square_strat()
{
	
	level.wasp_2 veh_stop_at_node( "wasp_2_stop_square_1" );	

	flag_wait( "wasps_move_into_square" );
	
	level.wasp_2 resumespeed( 5 );

	level.wasp_2 veh_stop_at_node( "wasp_2_stop_square_2" );	

	// flame guys in circle
	level thread maps\hol3_yard::house_fire( level.wasp_2, "orig_square_2_fire", 7, 15 );

	level thread wasp_2_death_notify();

	// make the wasp no longer invincible
	level.wasp_2.health = 16000;
	level.wasp_2 notify( "stop_keep_tank_alive" );
	
}



wasp_2_death_notify()
{

	level.wasp_2 waittill( "death" );
	
	flag_set( "wasp_2_dead" );
	
	level thread square_chain_2();
	
	level.wasp_2.looper = playLoopedFx( level._effect["sherman_smoke"], 1, level.wasp_2.origin );
	
}



sdk_fire_at_player()
{

	self endon( "death" );
	
	while( 1 )
	{
		
		players = get_players();
	
		self setturrettargetent( players[randomint(players.size)], ( RandomIntRange( -9, 9 ), RandomIntRange( -9, 9 ), RandomIntRange( 0, 18 ) ) );		
	
		self waittill( "turret_on_target" ); 		
		
		//self ClearTurretTarget(); 
		
		how_many_shots = randomintrange( 1, 3 );
		
		for( i  = 0; i < how_many_shots; i++ )
		{
			self notify( "turret_fire" );	
			wait( 0.3 );
		}
		
		wait( RandomFloatRange( 0.5, 1.25 ) );
		
	}		
	
}



square_chain_2()
{

	wait( 3 );

	set_color_chain( "chain_square_2" );
	
}


retreat_delay()
{

	self endon( "death" );

	self.animname = "square";

	wait( RandomIntRange( 1, 5 ) );
	
//	if( RandomInt( 2 ) )
//	{
//		thread anim_single_solo( self, "retreat_c", undefined, self );			
//	}
	
	orig = getstruct( "orig_square_retreat", "targetname" ).origin;
	self setgoalpos( orig );
	
}



square_officer_strat()
{

	self endon( "death" );
	
	self.ignoreme = 1;
	
	level waittill( "obj_town_assault_complete" );
	
	self.animname = "square";
	
	//node = getnode( "test_node_1", "targetname" );
	
	thread anim_single_solo( self, "retreat_a", undefined, self );	
	
	self setgoalpos( ( 7792, 5351.5, 258.5 ) );	
	
}