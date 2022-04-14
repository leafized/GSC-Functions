#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_anim;

// see2_town script

main()
{

	maps\_status::show_task( "Event3" );

	level.player_in_tank = false;

	level thread trucks();

	// spawn escaping trucks before player teleports
	trig = getent( "trig_town_trucks", "targetname" );
	trig notify( "trigger" );

	start_teleport_players( "orig_start_town" );	

	// TODO replace with color chain
//	set_player_chain( "node_chain_town" );

	maps\see2::setup_friendlies();


	simple_floodspawn( "town_spawners_1" );
	
	level thread train();
	level thread tank_blocker();
	level thread setup_player_tiger();
	
}


///////////////////
//
// Setup the germans trying to get into the Tiger 
//
///////////////////////////////

tiger_tank_crew()
{

	trig = getent( "trig_spawn_tiger_tankcrew", "targetname" );
	trig waittill( "trigger" );

	simple_spawn( "tiger_tank_crew" );
	
}


///////////////////
//
// Vehicle that blocks the path so the player is forced into the depot building
//
///////////////////////////////

tank_blocker()
{

	trig = getent( "trig_move_town_tiger", "targetname" );
	trig waittill( "trigger" );

	tank = getent( "town_end_tiger", "targetname" );

	// tank fires at the depot area
	// TODO taken out, malloc crash from dyn brushes was annoying
	//tank thread tank_fire_at_depot();
	
	wait_node = getvehiclenode( "auto1277", "targetname" );
	
	tank setWaitNode( wait_node );
	tank waittill( "reached_wait_node" );	

	// have tank stop and fire at the player	
	tank setspeed( 0, 2, 2 );
	
	trig = getent( "trig_tank_blocker_backup", "targetname" );
	trig waittill( "trigger" );
	
	// TODO this objective update should happen when player is actually in tank
	level notify( "obj_commandeer_complete" );
	
	level notify( "tank_blocker_moving" );
	
	// once player is in the tiger, move the tank back so it's an easy target
	tank resumespeed( 12, 2, 2 );
	
	
	level thread maps\see2_tiger::main();
	
	
}


///////////////////
//
// Sets up the Tiger tank to be commandeered
//
///////////////////////////////

setup_player_tiger()
{


	trig = getent( "trig_spawn_player_tiger", "targetname" );
	trig waittill( "trigger" );
	
	wait( 0.01 );
	
	level notify( "obj_town_complete" );
	
	tiger = getent( "captured_tiger", "targetname" );
	tiger makevehicleusable();

	// TODO make sure player is actually in tank before doing this
	level.player_in_tank = true;

	level thread cleanup_town_ai();
	level thread tiger_tank_crew();
	
}


///////////////////
//
// Kill axis ai in the town once the player is down near the tiger
//
///////////////////////////////

cleanup_town_ai()
{

	trig = getent( "trig_delete_town_ai", "targetname" );
	trig waittill( "trigger" );

	// stop friendly wave
	friendly_wave_trig = getent( "auto1683", "targetname" );
	friendly_wave_trig delete();

	axis_ai = getaiarray( "axis" );
	
	for( i = 0; i < axis_ai.size; i++ )
	{
		
		if( isdefined( axis_ai[i].script_noteworthy ) && ( axis_ai[i].script_aigroup == "ai_tiger_crew" || axis_ai[i].script_aigroup == "ai_tank_blocker" ) )
		{
			continue;
		}
		else
		{
			axis_ai[i] dodamage( axis_ai[i].health + 100, ( 0, 0, 0 ) );
		}
		
	}

}

///////////////////
//
// Tank fires at depot area near player
//
///////////////////////////////

tank_fire_at_depot()
{

	self endon( "death" );
	level endon( "tank_blocker_moving" );

	fire_origins = getentarray( "town_tank_attack_origs", "targetname" );
	
	while( 1 )
	{
	
		self SetTurretTargetEnt( fire_origins[randomint(fire_origins.size)], ( 0, 0, 0 ) );

		self waittill( "turret_on_target" ); 

		wait ( 1 );

		self ClearTurretTarget(); 
		self notify( "turret_fire" ); 
		
		wait( randomintrange( 3, 5  ) );
		
	}
	
}



///////////////////
//
// Trucks that are escaping
//
///////////////////////////////

trucks()
{

	trig = getent( "trig_town_trucks", "targetname" );
	trig waittill( "trigger" );

	wait( 0.01 );

	truck_1 = getent( "town_truck_1", "targetname" );
	truck_2 = getent( "town_truck_2", "targetname" );
	
	level thread maps\_vehicle::gopath( truck_1 );
	
	level thread truck_1_guys();
	
	trig = getent( "town_spawners_2", "target" ); 
	trig waittill( "trigger" );
	
	level thread maps\_vehicle::gopath( truck_2 );
	
	level thread truck_2_guys();
	
}


///////////////////
//
// Guys that escape with truck
//
///////////////////////////////

truck_1_guys()
{

	guys = simple_spawn( "truck_guys_1" );
	
	array_thread( guys, ::truck_guy_strat );
	
}


truck_2_guys()
{

	guys = simple_spawn( "truck_guys_2" );

	array_thread( guys, ::truck_guy_strat );
	
}


///////////////////
//
// Thread run on truck escape guys after they spawn
//
///////////////////////////////


truck_guy_strat()
{

	self.pacifist = 1;
	self.ignoreme = 1;
	
	self waittill( "goal" );
	
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
	
}


///////////////////
//
// Handles the train escaping
//
///////////////////////////////

train()
{

	level thread train_guys();

	// Have the train leave if the player doesn't move up after a while
	level thread train_leave_timeout();

	trig = getent( "trig_train_move", "targetname" );
	trig waittill( "trigger" );

	level notify( "train_leaving" );


	wait( randomfloatrange( 1.0, 2.0 ) );

	train = getent( "town_train", "targetname" );
	
	moveto_orig = getent( "orig_tank_moveto", "targetname" );
	
	train moveto( moveto_orig.origin, 45, 6, 3 );


	train thread train_connectpaths();

	wait( 45 );
	
	train delete();

	
}



///////////////////
//
// Have the train leave if the player doesn't move up after a while
//
///////////////////////////////

train_leave_timeout()
{

	level endon( "train_leaving" );

	wait( 18 );

	trig = getent( "trig_train_move", "targetname" );
	trig notify( "trigger" );
	
}



///////////////////
//
// Guys that are helping load the armored train
//
///////////////////////////////

train_guys()
{

	guys = simple_spawn( "train_guys" );
	
	for( i = 0; i < guys.size; i++ )
	{
		
		guys[i].allowdeath = 1;
		
	}
	
	array_thread( guys, ::train_guy_strat );
	
	level thread anim_loop_solo( guys[0], "motioning_a", undefined, "train_leaving", guys[0] );	
	level thread anim_loop_solo( guys[1], "motioning_b", undefined, "train_leaving", guys[1] );	
	
	
	flatbed_guys = simple_spawn( "train_guy_climb" );
	
	level thread train_guy_climb_flatbed( flatbed_guys[0] );
	level thread train_guy_climb_flatbed( flatbed_guys[1] );
	//level thread train_guy_climb_run_boxcar();
	

	
}



train_guy_climb_flatbed( guy )
{

	//guy = simple_spawn_single( "train_guy_climb" );
	
	guy.animname = "retreat";
	
	guy.allowdeath = 1;
	guy.pacifist = 1;
	guy.ignoreme = 1;
	
	// have him motioning
	level thread anim_loop_solo( guy, "motioning_b", undefined, "train_leaving", guy );	
	
	level waittill( "train_leaving" );
	
	// have him climb onto the flatbed
	level thread anim_single_solo( guy, "climb_flatbed_a", undefined, guy );	
	
	guy waittill( "single anim" );
	
	guy.pacifist = 0;
	guy.goalradius = 10;
	guy setgoalpos( guy.origin );
	
	train = getent( "town_train", "targetname" );
	
	orig = spawn( "script_origin", guy.origin );

	guy linkto( orig );
	orig linkto( train );
	
}



//train_guy_climb_run_boxcar()
//{
//	
//	guy = simple_spawn_single( "train_guy_run_boxcar" );
//	
//	guy.animname = "retreat";
//	
//	guy.allowdeath = 1;
//	guy.pacifist = 1;
//	guy.ignoreme = 1;
//	
//	level thread anim_single_solo( guy, "climb_run_boxcar", undefined, guy );	
//	
//	guy waittill( "single anim" );
//	
//	guy.pacifist = 0;
//	guy.goalradius = 10;
//	guy setgoalpos( guy.origin );
//	
//	train = getent( "town_train", "targetname" );
//	
//	orig = spawn( "script_origin", guy.origin );
//
//	guy linkto( orig );
//	orig linkto( train );	
//	
//}



///////////////////
//
// How the guys retreating with the train behave
//
///////////////////////////////

train_guy_strat()
{
	
	self endon( "death" );
	
	self thread magic_bullet_shield();
	self.pacifist = 1;
	self.ignoreme = 1;
	self.animname = "retreat";
	
	level waittill( "train_leaving" );
	
	self thread stop_magic_bullet_shield();
	self.goalradius = 30;
	
	goal_node = getnode( self.target, "targetname" );
	
	self setgoalnode( goal_node );
	
	// for guy that runs along the side of the platform
	if( isdefined( goal_node.target ) )
	{
		self waittill( "goal" );
		self setgoalnode( getnode( goal_node.target, "targetname" ) );
	}
	
	self waittill( "goal" );
	
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
	
}


///////////////////
//
// Connect paths across the tracks that the scriptbrushmodel blocks at compile time
//
///////////////////////////////

train_connectpaths()
{
	
	wait( 3 );

	self connectpaths();
	
	
	wait( 20 );
	
	self connectpaths();	
	
}


///////////////////
//
// Mid IGC
//
///////////////////////////////

// TODO make these ai instead of script_models?
#using_animtree("generic_human");
mid_igc_begin()
{

	// remove old tanks
	delete_targetname_ents( "graveyard_panthers" );
	
	// put tanks in their positions
	origs = getentarray( "orig_igc_t34", "targetname" );
	for( i = 0; i < origs.size; i++ )
	{
	
		t34 = spawn( "script_model", origs[i].origin );
		t34.angles = origs[i].angles;
		t34 setmodel( "vehicle_rus_tracked_t34" );		
		
	}

	simple_spawn( "spawner_igc" );

	// play IGC
	level thread maps\_camsys::playback_scene( "mid" );

	// with script models...
	
//	orig_1 = getent( "orig_tankcrew_igc_1", "targetname" );
//	orig_2 = getent( "orig_tankcrew_igc_2", "targetname" );
//	
//	guy_1 = spawn( "script_model", orig_1.origin );
//	guy_1.angles = orig_1.angles;
//	guy_1 character\char_rus_r_rifle::main();
//	guy_1 UseAnimTree( #animtree );
//	guy_1.animname = "midigc";
//	
//	level thread anim_single_solo( guy_1, "dismount_a", undefined, guy_1 );	
//	
//	
//	guy_2 = spawn( "script_model", orig_2.origin );
//	guy_2.angles = orig_2.angles;
//	guy_2 character\char_rus_r_rifle::main();
//	guy_2 UseAnimTree( #animtree );
//	guy_2.animname = "midigc";
//	
//	level thread anim_single_solo( guy_2, "dismount_b", undefined, guy_2 );	

	wait( 4 );

	// with ai...

	igc_guys = simple_spawn( "spawner_tankcrew_igc" );	

	igc_guys[0].animname = "midigc";
	igc_guys[1].animname = "midigc";
	
	level thread anim_single_solo( igc_guys[0], "dismount_a", undefined, igc_guys[0] );	
	level thread anim_single_solo( igc_guys[1], "dismount_b", undefined, igc_guys[1] );	

	level waittill( "plackback_finished" );
	
	maps\see2::cleanup_early_tanks();
	
	kill_all_ai();
	
	maps\see2_town::main();
	
}