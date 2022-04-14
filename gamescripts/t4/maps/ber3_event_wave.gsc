////
//// file: ber3_event_wave.gsc
//// description: "ride the wave" event script for berlin3
//// scripter: slayback
////
//
//#include common_scripts\utility;
//#include maps\_utility;
//#include maps\ber3;
//#include maps\ber3_util;
//
//// -- STARTS --
//// start at the start of the wave event
//event_wave_start()
//{	
//	thread maps\ber3_event_atgun::atgun_tank_skip();
//	
//	objectives_skip( 5 );
//	
//	warp_players_underworld();
//	warp_friendlies( "struct_wave_start_friends", "targetname" );
//	warp_players( "struct_wave_start", "targetname" );
//	
//	GetEnt( "trig_spawned_wave_guys_safezone1", "script_noteworthy" ) notify( "trigger" );
//
//	level thread event_wave_setup();
//}
//// -- END STARTS --
//
//event_wave_setup()
//{
//	maps\_status::show_task( "wave" );
//	
//	thread event_wave_action();
//}
//
//event_wave_action()
//{
//	//set_friendlychain( "node_wave_fc1" );
//	level thread wave_controller();
//	
//	level waittill( "wave_done" );
//	
//	// finish out by taking players out of ignoreme, just in case
//	players = get_players();
//	for( i = 0; i < get_players().size; i++ )
//	{
//		players[i].ignoreme = false;
//	}
//	
//	set_objective( 7 );
//	trigger_wait( "trig_wave_reichstagRegroupSpot", "targetname" );
//	
//	MissionSuccess( "ber3" );  // TODO make this send players to ber3b
//}
//
//wave_controller()
//{
//	trigger_wait( "trig_wave_playerAtBarricade", "targetname" );
//	
//	// wave setup
//	flag_clear( "wave_active" );
//	level.wave_allowedDistFromLeader = 256;
//	level.wave_playerCheckPeriod = 0.5;
//	level.wave_waveleaderGoalRadius = 32;
//	
//	SetIgnoreMeGroup( "wave_enemies_safezone1", "wave_waveleader" );
//	SetIgnoreMeGroup( "wave_waveleader", "wave_enemies_safezone1" );
//	
//	level.waveleader = wave_setup_leader();
//	level thread wave_handle_players();
//	level thread wave_handle_redshirts();
//	
//	// ready up
//	wave_move_waveleader( "node_wave_waveleader_start" );
//	level thread wave_vo( "getready" );
//	level waittill( "wave_vo_done" );
//	
//	// objective change
//	set_objective( 6 );
//	thread objective_follow_ent( 6, level.waveleader );
//	
//	// first charge
//	level thread wave_move_waveleader( "node_wave_waveleader_spot1" );
//	wait( 0.5 );  // pause for dramatic effect?
//	flag_set( "wave_active" );
//	level thread wave_vo( "charge" );
//	//set_friendlychain( "node_wave_fc3" );
//	level waittill( "waveleader_movedone" );
//	flag_clear( "wave_active" );
//	
//	// first clear
//	level thread wave_vo( "safezone" );
//	wave_handle_safezone_guys( "spawned_wave_guys_safezone1", 20, 1 );
//	level thread wave_vo( "zonecleared" );
//	wait( 5 );
//	
//	// second charge
//	level thread wave_move_waveleader( "node_wave_waveleader_spot2" );
//	flag_set( "wave_active" );
//	level thread wave_vo( "charge" );
//	//set_friendlychain( "node_wave_fc5" );
//	level waittill( "waveleader_movedone" );
//	flag_clear( "wave_active" );
//	
//	// second clear
//	level thread wave_vo( "safezone" );
//	wave_handle_safezone_guys( "spawned_wave_guys_safezone2", 20, 1 );
//	level thread wave_vo( "zonecleared" );
//	wait( 8 );
//	
//	// third charge
//	level thread wave_move_waveleader( "node_wave_waveleader_spot3" );
//	flag_set( "wave_active" );
//	level thread wave_vo( "charge" );
//	//set_friendlychain( "node_wave_fc7" );
//	level waittill( "waveleader_movedone" );
//	flag_clear( "wave_active" );
//	
//	// wave finished
//	// maybe we don't need this?
//	//trigger_wait( "trig_wave_waveDone", "targetname" );
//	level notify( "wave_done" );
//	level thread wave_vo( "wavedone" );
//	
//	// objective change
//	level notify( "objective_stop_following_ent" );
//	objective_position( 5, GetStruct( "struct_objective6_marker", "targetname" ).origin );
//}
//
//wave_setup_leader()
//{
//	spawner = GetEnt( "spawner_wave_waveleader", "targetname" );
//	waveleader = spawner spawn_ai();
//	waveleader waittill( "finished spawning" );
//	
//	// add a flag to this guy to set him off
//	linktag = "J_SpineLower";
//	flag = Spawn( "script_model", waveleader GetTagOrigin( linktag ) );
//	flag LinkTo( waveleader, linktag );
//	flag SetModel( "static_ber_rus_flag" );
//	
//	waveleader thread magic_bullet_shield();
//	waveleader SetThreatBiasGroup( "wave_waveleader" );
//	waveleader.ignoreme = true;
//	waveleader.pacifist = true;
//	waveleader.goalradius = level.wave_waveleaderGoalRadius;
//	waveleader thread keep_waveleader_in_check();
//	waveleader thread debug_waveleader();
//	
//	return waveleader;
//}
//
//// self = the waveleader AI
//keep_waveleader_in_check()
//{
//	self endon( "death" );
//	level endon( "wave_done" );
//	
//	while( 1 )
//	{
//		self.goalradius = level.wave_waveleaderGoalRadius;
//		self.ignoreme = true;
//		self.pacifist = true;
//		wait( 0.05 );
//	}	
//}
//
//// self = the wave leader AI
//debug_waveleader()
//{
//	self endon( "death" );
//	level endon( "wave_done" );
//	
//	while( 1 )
//	{
//		Print3D( self.origin + ( 0, 0, 70 ), "wave leader", ( 1, 1, 1 ), 1, 0.5 );
//		wait( 0.05 );
//	}
//}
//
//wave_move_waveleader( nodeTN )
//{
//	node = GetNode( nodeTN, "targetname" );
//	level.waveleader.goalradius = level.wave_waveleaderGoalRadius;
//	
//	level notify( "waveleader_moving" );
//	level.waveleader SetGoalNode( node );
//	
//	level.waveleader waittill( "goal" );
//	level notify( "waveleader_movedone" );
//}
//
//// thank god we're doing this in a straight line on a cardinal axis... math is hard
//wave_handle_players()
//{
//	level endon( "wave_done" );
//	
//	while( 1 )
//	{
//		players = get_players();
//		
//		// make sure we're not paused
//		if( flag( "wave_active" ) )
//		{		
//			for( i = 0; i < players.size; i++ )
//			{
//				player = players[i];
//				
//				// if ahead of the leader...
//				if( player.origin[1] - level.waveleader.origin[1] > level.wave_allowedDistFromLeader )
//				{
//					//iprintlnbold( "too far in front" );
//					
//					// own their face
//					// TODO maybe target them with an MG?
//					player DoDamage( 5, ( 0, player.origin[1] + 200, 0 ) );
//				}
//				// if behind the leader...
//				else if( level.waveleader.origin[1] - player.origin[1] > level.wave_allowedDistFromLeader )
//				{
//					//iprintlnbold( "too far behind" );
//										
//					// less ownage
//					if( RandomInt( 100 ) > 50 )
//					{
//						player DoDamage( 5, ( 0, player.origin[1] + 200, 0 ) );
//					}
//					
//					// TODO maybe hit em with a mortar
//				}
//			
//				// if we're too far away from the leader at all...
//				if( abs( player.origin[1] - level.waveleader.origin[1] ) > level.wave_allowedDistFromLeader )
//				{
//					//iprintlnbold( "too far away with dist of " + abs( player.origin[1] - level.waveleader.origin[1] ) );
//					// do global stuff
//					player.ignoreme = false;
//				}
//				// otherwise we're in the wave
//				else
//				{
//					player.ignoreme = true;
//				}
//			}
//		}
//		// if the wave is not active, we're in a clear zone and are engaging enemies
//		else
//		{
//			for( i = 0; i < players.size; i++ )
//			{
//				players[i].ignoreme = false;
//			}
//		}
//		
//		wait( level.wave_playerCheckPeriod );
//	}
//}
//
//wave_handle_redshirts()
//{
//	// TODO ...this!
//}
//
//wave_vo( voType )
//{
//	if( voType == "getready" )
//	{
//		iprintlnbold( "wait for the wave..." );
//		wait( 2 );
//		iprintlnbold( "ready..." );
//		wait( 2 );
//	}
//	else if( voType == "charge" )
//	{
//		iprintlnbold( "charge!!" );
//	}
//	else if( voType == "safezone" )
//	{
//		iprintlnbold( "clear the area and wait here!" );
//	}
//	else if( voType == "zonecleared" )
//	{
//		iprintlnbold( "clear! get ready to go again..." );
//	}
//	else if( voType == "wavedone" )
//	{
//		iprintlnbold( "every man for himself!" );
//	}
//	
//	level notify( "wave_vo_done" );
//}
//
//wave_handle_safezone_guys( guysSN, maxWait, amount )
//{
//	ents = GetEntArray( guysSN, "script_noteworthy" );
//	
//	if( !IsDefined( ents ) )
//	{
//		println( "wave_handle_safezone_guys(): couldn't find any ents with script_noteworthy of " + guysSN );
//		return;
//	}
//	
//	guys = [];
//	
//	for( i = 0; i < ents.size; i++ )
//	{
//		ent = ents[i];
//		
//		if( is_active_ai( ent ) )
//		{
//			guys[guys.size] = ent;
//		}
//	}
//	
//	if( !IsDefined( guys ) )
//	{
//		println( "wave_handle_safezone_guys(): couldn't find any active AIs with script_noteworthy of " + guysSN );
//		return;
//	}
//	
//	waittill_group_dies( guys, maxWait, amount );
//}
