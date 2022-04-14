////
//// file: ber3_event_atgun.gsc
//// description: atgun event script for berlin3
//// scripter: slayback
////
//
//#include common_scripts\utility;
//#include maps\_utility;
//#include maps\_anim;
//#include maps\ber3;
//#include maps\ber3_util;
//
//#using_animtree ("generic_human");
//
//// -- STARTS --
//// start at the start of the atgun event
//event_atgun_start()
//{
//	objectives_skip( 2 );
//	
//	GetEnt( "trig_atgun_tankSpawner", "targetname" ) notify( "trigger" );
//	
//	warp_players_underworld();
//	warp_friendlies( "struct_atgun_start_friends", "targetname" );
//	warp_players( "struct_atgun_start", "targetname" );
//	//set_friendlychain( "node_intro_fc13" );
//
//	level thread event_atgun_setup();
//}
//
//event_atgun_tank_start()
//{
//	GetEnt( "trig_spawner_e1_axisflood_1", "script_noteworthy" ) Delete();  // delete spawn trigger
//	
//	objectives_skip( 3 );
//	
//	GetEnt( "trig_atgun_tankSpawner", "targetname" ) notify( "trigger" );
//	
//	warp_players_underworld();
//	warp_friendlies( "struct_atgun_start_friends", "targetname" );
//	warp_players( "struct_atgun_start", "targetname" );
//
//	maps\_status::show_task( "atgun" );
//	level thread event_atgun_tank();
//}
//// -- END STARTS --
//
//event_atgun_setup()
//{
//	set_objective( 3 );
//	maps\_status::show_task( "atgun" );
//	
//	thread event_atgun_action();
//}
//
//event_atgun_action()
//{
//	/* DEPRECATED
//	flag_clear( "atgun_barricade_left_destroyed" );
//	flag_clear( "atgun_barricade_right_destroyed" );
//	
//	thread barricade_think( "sbmodel_atgun_barricade_left", "atgun_barricade_left_destroyed" );
//	thread barricade_think( "sbmodel_atgun_barricade_right", "atgun_barricade_right_destroyed" );
//	
//	while( !flag( "atgun_barricade_right_destroyed" ) || !flag( "atgun_barricade_left_destroyed" ) )
//	{
//		wait( 1 );
//	}
//	*/
//	
//	trigger_wait( "trig_spawner_e1_specialAIs", "script_noteworthy" );
//	wait( 0.25 );
//	
//	// grab guys
//	commanders = get_ai_group_ai( "e1_commander" );
//	
//	ASSERTEX( IsDefined( commanders ) && commanders.size > 0, "couldn't find any commanders!" );
//	
//	numCommanders = commanders.size;
//	level.commandersDead = 0;
//	
//	for( i = 0; i < commanders.size; i++ )
//	{
//		level thread commander_think( commanders[i] );
//	}
//	
//	while( level.commandersDead < numCommanders )
//	{
//		wait( 0.1 );
//	}
//	
//	thread event_atgun_tank();
//}
//
//commander_think( commander )
//{
//	commander waittill( "goal" );
//	
//	commander.health = 10;
//	commander.suppressionwait = 0;
//	commander.allowDeath = true;
//	commander.animname = "officer";
//	
//	animSpot = GetNode( commander.target, "targetname" );
//	
//	// TODO replace with a binocular loop or something
//	animSpot thread anim_loop_solo( commander, "signal_loop", undefined, "stopanim", undefined );
//	
//	while( is_active_ai( commander ) )
//	{
//		wait( 0.1 );
//	}
//	
//	animSpot notify( "stopanim" );
//	
//	level.commandersDead++;
//}
//
///* DEPRECATED
//barricade_think( barricadeTN, flagString )
//{
//	barricade = GetEnt( barricadeTN, "targetname" );
//	ASSERTEX( IsDefined( barricade ), "Can't find barricade with targetname " + barricadeTN );
//	ASSERTEX( IsDefined( barricade.target ), "Barricade " + barricadeTN + " doesn't have a damage trigger targeted." );
//	
//	dmgtrig = GetEnt( barricade.target, "targetname" );
//	ASSERTEX( IsDefined( dmgtrig ), "Can't find damage trigger with targetname " + barricade.target );
//	
//	// wait for damage to accumulate
//	// TEMP it has to take damage 3 times, change later when trigger_damages work properly?
//	for( i = 0; i < 3; i ++ )
//	{
//		dmgtrig waittill( "trigger" );
//		wait( 1 );
//	}
//	
//	wait( 0.5 );
//	
//	// remove the barricade
//	iprintlnbold( "barricade destroyed, good job!" );
//	
//	// TODO play particles etc.
//	barricade ConnectPaths();
//	barricade Delete();
//	dmgtrig Delete();
//	
//	flag_set( flagString );
//	
//	guysTN = undefined;
//	endNodesTN = undefined;
//	
//	// send Russian troops through the barricade
//	if( barricadeTN == "sbmodel_atgun_barricade_left" )
//	{
//		guysTN = "spawner_atgun_left";
//		endNodesTN = "node_atgun_barricadeEndNodes_left";
//	}
//	else if( barricadeTN == "sbmodel_atgun_barricade_right" )
//	{
//		guysTN = "spawner_atgun_right";
//		endNodesTN = "node_atgun_barricadeEndNodes_right";
//	}
//	
//	if( IsDefined( guysTN ) && IsDefined( endNodesTN ) )
//	{
//		thread barricade_send_troops( guysTN, endNodesTN );
//	}
//	else
//	{
//		ASSERTMSG( "either guysTN or endNodesTN is not specified for barricade named " + barricadeTN );
//	}
//}
//*/
//
//barricade_send_troops( guysTN, endNodesTN )
//{
//	/*
//	// spawn some more guys for fun
//	spawners = GetEntArray( guysTN, "targetname" );
//	for( i = 0; i < spawners.size; i++ )
//	{
//		guy = spawners[i] spawn_ai();
//		wait( RandomFloat( 2 ) );
//	}
//	*/
//		
//	ents = GetEntArray( guysTN, "script_noteworthy" );
//	guys = [];
//	endnodes = [];
//	
//	// get the guys
//	for( i = 0; i < ents.size; i++ )
//	{
//		ent = ents[i];
//		if( is_active_ai( ent ) )
//		{
//			guys[guys.size] = ent;
//		}
//	}
//	
//	// collect all the nodes beyond the barricade	
//	endnodes = GetNodeArray( endNodesTN, "targetname" );
//	
//	/#
//	println( "guys array is size " + guys.size );
//	println( "endnodes array is size " + endnodes.size );
//	#/
//	
//	// send them to nodes
//	for( i = 0; i < guys.size; i++ )
//	{
//		guy = guys[i];
//		if( IsDefined( endnodes[i] ) )
//		{
//			guy SetGoalNode( endnodes[i] );
//		}
//		// in case we run out of nodes
//		else
//		{
//			guy SetGoalPos( endnodes[RandomInt( endnodes.size - 1 )] );
//		}
//		
//		guy thread barricade_troop_delete();
//	}
//}
//
//barricade_troop_delete()
//{
//	if( is_active_ai( self ) )
//	{
//		self waittill( "goal" );
//		self bloody_death( true, 10 );
//	}
//}
//
//event_atgun_tank()
//{
//	set_objective( 4 );
//	//set_friendlychain( "node_intro_fc15" );
//	
//	trigger_wait( "trig_atgun_regroupSpot", "targetname" );
//	
//	set_objective( 5 );
//	
//	level thread event_atgun_waveleadertrig();
//	
//	// TODO set up friendlies at barricade (in ber3_event_wave, probably)
//	
//	// roll out tank
//	tank = GetEnt( "vehicle_atgun_housetank", "targetname" );
//	tank thread atgun_tank_think();
//	
//	blocker = GetEnt( "sbmodel_atgun_exitblocker", "targetname" );
//	blocker Delete();
//	
//	wait( 0.1 );  // let the vehicle connect the paths around it
//	
//	// send level control to ber3_event_wave
//	level thread maps\ber3_event_wave::event_wave_setup();
//}
//
//event_atgun_waveleadertrig()
//{
//	trig = GetEnt( "trig_wave_playerAtBarricade", "targetname" );
//	trig trigger_off();
//	
//	while( !flag( "barricade_doors_connected" ) )
//	{
//		wait( 0.1 );
//	}
//	
//	trig trigger_on();
//}
//
//// self = the tank
//atgun_tank_think()
//{
//	thread maps\_vehicle::gopath( self );
//	
//	// TODO do this when hitting pathnodes
//	wait( 3 );
//	
//	barricade_right_array = GetEntArray( "sbmodel_atgun_center_barricade_1", "targetname" );
//	barricade_center = GetEnt( "sbmodel_wave1_tankThruWall_left", "targetname" );
//	
//	self thread atgun_tank_turret( barricade_right_array );
//	level thread atgun_blow_wall();
//	
//	wait( 8 );
//	level thread atgun_move_barricade();
//	
//	self waittill( "reached_end_node" );
//	self DisconnectPaths();
//	RadiusDamage( self.origin, 128, self.health, self.health );
//}
//
//// self = the tank
//atgun_tank_turret( barricade_right_array )
//{
//	self SetTurretTargetEnt( barricade_right_array[0] );
//	self waittill ("turret_on_target");
//	wait( RandomFloatRange( 1, 3 ) );
//	level notify( "right_wall_destroy" );
//	self FireWeapon();
//	wait( RandomFloatRange( 1, 3 ) );
//	self ClearTurretTarget();
//}
//
//atgun_blow_wall( justDelete )
//{
//	if( !IsDefined( justDelete ) )
//	{
//		justDelete = false;
//	}
//	
//	wall_array = GetEntArray( "sbmodel_atgun_center_barricade_1", "targetname" );
//	
//	if( !justDelete )
//	{
//		level waittill( "right_wall_destroy" );
//	}
//	
//	// TODO make destruction fancier
//	for( i = 0; i < wall_array.size; i++ )
//	{
//		piece = wall_array[i];
//		if( piece.classname == "script_brushmodel" )
//		{
//			piece ConnectPaths();
//		}
//		piece Delete();
//	}
//}
//
//atgun_move_barricade()
//{
//	wall_left = GetEnt( "sbmodel_wave1_tankThruWall_left", "targetname" );
//	wall_right = GetEnt( "sbmodel_wave1_tankThruWall_right", "targetname" );
//	
//	wall_left ConnectPaths();
//	wall_right ConnectPaths();
//	
//	flag_set( "barricade_doors_connected" );
//	
//	wall_left RotateTo( ( 0, 120, 0 ), 2 );
//	wall_right RotateTo( ( 0, -120, 0 ), 2 );
//	
//	wall_right waittill( "rotatedone" );
//	
//	wall_left DisconnectPaths();
//	wall_right DisconnectPaths();
//}
//
//// for level starts - simulates that the tank has run its course
//atgun_tank_skip()
//{
//	trig = GetEnt( "trig_atgun_regroupSpot", "targetname" );
//	trig Delete();
//	
//	thread atgun_blow_wall( true );
//	thread atgun_move_barricade();
//	
//	GetEnt( "trig_atgun_tankSpawner", "targetname" ) notify( "trigger" );
//	wait( 0.1 );
//	
//	tank = GetEnt( "vehicle_atgun_housetank", "targetname" );	
//	thread maps\_vehicle::gopath( tank );
//	tank SetSpeed( 1000, 1000 );
//	tank waittill( "reached_end_node" );
//	tank DisconnectPaths();
//	RadiusDamage( tank.origin, 256, tank.health, tank.health );
//}
