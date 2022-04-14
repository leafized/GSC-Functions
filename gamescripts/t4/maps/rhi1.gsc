/*-----------------------------------------------------
 file: 		rhi1.gsc
 description: 	level script for Rhineland 1
 scripter: 	Chris_P
 builder: 	Jeff Zaring
-----------------------------------------------------*/

#include maps\_utility;
#include common_scripts\utility;
main()
{
	

	init_starts();
	init_vehicles();
	
	level.tanks = 0;
	// Required to set up the vehicles through the vehicle script
	maps\_flak88::main( "german_artillery_flak88_nm" );
		
	//_load baby! 
	maps\_load::main();
	
	
	//level flags
	level.patrollers_cleared = false;
	level.pod1_enemies_cleared = false;
	level.pod1_complete = false;
	level.ai_at_lvt1 = false;
	level.ai_at_lvt2 = false;
	level.lvt1 = getent("player_vehicle_1","targetname");
	level.lvt2 = getent("player_vehicle_2","targetname");
	
	
	//level support scripts
	maps\rhi1_anim::main();
	maps\rhi1_fx::main();
	maps\rhi1_amb::main();
	maps\rhi1_status::main();
	maps\_mortarteam::main();
	
	createthreatbiasgroup("engineers");
	createthreatbiasgroup("attackers");				
	
	//camera stuff
	maps\createcam\rhi1_cam::main(); 
	
	
	
	//Start Ambient sounds
	thread maps\rhi1_amb::main();
	
}


/*-----------------------------------------------------
initialize the skipto's
-----------------------------------------------------*/
init_starts()
{
	
	add_start( "factory", ::start_factory_assault );
	add_start("pod2",::pod_2);
	add_start("pod3",::start_pod3);
	add_start("camera",::camera_start);
	
	default_start( ::pod_1 );
}

/*-----------------------------------------------------
initialize vehicles
-----------------------------------------------------*/
init_vehicles()
{
	
	maps\_buffalo::main( "vehicle_usa_tracked_lvt4" );
	maps\_flak88::main( "german_artillery_flak88_nm" );
	
	//maps\_jeep::main( "vehicle_german_kubel_nomandy" );
}


camera_start()
{
	
	//level thread maps\rhi1_fx::dust();
	
}

/*-----------------------------------------------------
start the first event
-----------------------------------------------------*/
pod_1()
{
	// wait until the first player spawns into the game before setting up friendlies
	//level waittill("first_player_ready",player);
		
	//set initial friendlychain
	players = get_players();
	players[0] setfriendlychain( getnode("pod1_chain_start","targetname"));
	
	//put AI on LVT for first "pod"
	thread put_ai_on_lvt(1,1,true);
	thread put_ai_on_lvt(2,1,true);
	
	//add the first objective
	level waittill("introscreen_complete");
	
	//level thread maps\_camsys::playback_scene( "beg" );
	//level waittill("plackback_finished");

	//put players on LVT
	thread put_players_on_lvt();	
	
	objective_add(1,"current",&"RHI1_OBJ1");

	//start the LVT's rolling and monitor them 
	level notify("start lvts");
	thread monitor_lvt(1,1);
	thread monitor_lvt(2,1);
	
	//monitor the patrollers
	thread pod1_patrollers();
	
	//add the new objective when the players get off the vehicle
	level waittill("lvt unloaded");
	objective_add (2,"current",&"RHI1_OBJ_SECURE",(-12992,17034,50));
	
		
	//wait until the players clear pod1...
	//this doesn't always work right ?
	level waittill_aigroupcleared ("pod1_enemies");
	
	
	//put players and AI back onto the LVTs to take them to the next area
	thread ai_goto_lvt(1);
	
	objective_state(2,"done");
	wait(1);
	objective_add(3,"current",&"RHI1_OBJ_REGROUP",level.lvt1.origin);
	objective_additionalposition(3,1,level.lvt2.origin);
	
	
	
	lvt_wait();
	level waittill("player used lvt");

	objective_state(3,"done");
	objective_delete(3);
	objective_delete(2);	
		
	thread put_ai_on_lvt(1,2,false);
	thread put_ai_on_lvt(2,2,false);
	thread put_players_on_lvt();
	
	level notify("start lvts");
	thread monitor_lvt(1,2);
	thread monitor_lvt(2,2);
		
	thread house_shutter_guys("house1_shutter_guys",1);
	thread house_shutter_guys("house2_shutter_guys",2);
	
	level waittill("lvt unloaded");
	
	thread runners();
	
	objective_add (3,"current",&"RHI1_OBJ_SECURE",(-14678,12879,150));
	
	//Why doesn't this work sometimes ??? 	
	//level waittill_aigroupcleared("pod2_enemies");	
	
	while(get_ai_group_ai("pod2_enemies").size >0)
	{
		wait(2);		
	}	
	
	objective_state(3,"done");
	wait(1);
	objective_add(4,"current",&"RHI1_OBJ_REGROUP",level.lvt1.origin);
	objective_additionalposition(4,1,level.lvt2.origin);
	
	
	thread ai_goto_lvt(2);
	lvt_wait();
		
	objective_state(3,"done");
	objective_delete(3);
	objective_delete(2);
	
	pod_3(false);	
}


start_pod3()
{
	pod_3(true);
}

pod_3(start)
{
	//thread pod3_stuff();
	if(!start)
	{
		level waittill("player used lvt");
		//objective_state(4,"done");
		objective_delete(3);
		objective_delete(4);
		objective_delete(2);
	}

	players = get_players();
	players[0] setfriendlychain( getnode("pod3_chain_start","targetname"));
	
	thread put_ai_on_lvt(1,3,start);
	thread put_ai_on_lvt(2,3,start);
	thread put_players_on_lvt();
	wait(1);
	level notify("start lvts");
	thread monitor_lvt(1,3);
	thread monitor_lvt(2,3);
	
	wait (randomint(4));
	level.lvt1 thread lvt_explosions();
	level.lvt2 thread lvt_explosions();
	
	level waittill("lvt unloaded");
	
	players = get_players();
	players[0] setfriendlychain( getnode("pod3_chain_start","targetname"));

		
	level notify("end lvt mortars");
	
	objective_add (2,"current",&"RHI1_OBJ_SECURE",(-8626,10964,600));
	
	//level waittill_aigroupcleared ("pod3_enemies");
	while(get_ai_group_ai("pod3_enemies").size >0)
	{
		wait(2);		
	}	
	
	objective_state(2,"done");
	
	wait(2);
	start_factory_assault();
		
}


/*-----------------------------------------------------
The guys who run away from you at pod2
-----------------------------------------------------*/
runners()
{
	runners = getentarray("runners","targetname");
	for(i=0;i<runners.size;i++)
	{
		guy = runners[i] stalingradspawn();
		guy waittill("finished spawning");
		guy.targetname = "runners";
		runners[i] delete();
	}
	
	guys = getentarray("runners","targetname");
	array_thread(guys,::runto_goal);
}

/*-----------------------------------------------------
some logic for the running guys
-----------------------------------------------------*/
runto_goal()
{
	self endon("death");
	
	self.pathenemyFightdist = 64;
	self.pathenemyLookahead = 64;
	self.goalradius = 64;
	
	self waittill("goal");
	
	self.goalradius = 2048;	
	self set_default_pathenemy_settings();

}

/*-----------------------------------------------------
start pod2
-----------------------------------------------------*/
pod_2()
{
	
	//start mortars
	//
	patrollers = getentarray("auto3922","targetname");
	for(i=0;i<patrollers.size;i++)
	{
		patrollers[i] delete();
	}
	
	mortars = getentarray("mortar_team","targetname");
	for(i=0;i<mortars.size;i++)
	{
		if(mortars[i].target != "auto1")
		{
			mortars[i] notify ("trigger");
		}
	}
	
	thread put_ai_on_lvt(1,2,true);
	thread put_ai_on_lvt(2,2,true);
	
	thread put_players_on_lvt();
	wait(1);
	
	level notify("start lvts");
	thread monitor_lvt(1,2);
	thread monitor_lvt(2,2);
		
	level waittill("lvt unloaded");
	
	thread runners();
	objective_add (1,"current",&"RHI1_OBJ1");
	objective_add (3,"current",&"RHI1_OBJ_SECURE",(-14678,12879,150));
	//thread ai_stuff();
	
	while(get_ai_group_ai("pod2_enemies").size >0)
	{
		wait(1);		
	}
	
	//level waittill_aigroupcleared("pod2_enemies");
	
	objective_state(3,"done");
	wait(1);
	objective_add(4,"current",&"RHI1_OBJ_REGROUP");
	
	lvt_Wait();
		
	pod_3(false);
	
	
}

/*-----------------------------------------------------
make the lvts usable
-----------------------------------------------------*/
lvt_wait()
{
	//level.lvt1 makevehicleusable();
	//level.lvt2 makevehicleusable();
	
	level.lvt1 thread lvt_think(1);
	level.lvt2 thread lvt_think(2);
	  
}


/*-----------------------------------------------------
monitor for players to use the LVT
// - currently just waits for player to get within a radius
-----------------------------------------------------*/
lvt_think(lvt_num)
{
	//self waittill("trigger",other);	
	level endon("player used lvt");
	
	waiting = true;
	
	while(waiting)
	{
		wait(1);
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if( distancesquared(players[i].origin, self.origin) < 128*128)
			{
				players[i].current_lvt = lvt_num;
				//iprintlnbold("current lvt: " + lvt_num);
				waiting = false;				
			}
		}
	}
	
	level notify("player used lvt");
}



ai_goto_lvt(pod_num)
{
	lvt1_nodes = getnodearray("pod" + pod_num + "_lvt1_ai","targetname");
	lvt2_nodes = getnodearray("pod" + pod_num + "_lvt2_ai","targetname");
	
	lvt1_guys = getentarray("lvt1_guys","targetname");
	lvt2_guys = getentarray("lvt2_guys","targetname");
	
	array_thread (lvt1_guys,::ai_runto_lvt,lvt1_nodes);
	array_thread(lvt2_guys,::ai_runto_lvt,lvt2_nodes);
	
}


ai_runto_lvt(target_nodes)
{
	self endon("death");
		
	if(isDefined(target_nodes))
	{
		self.pathenemyfightdist = 64;
		self.pathenemylookahead = 64;
		self.goalradius = 128;
		self setgoalnode( target_nodes[randomint(target_nodes.size)] );
	}
		
}



monitor_lvt(lvt_num,pod_num)
{
	
	lvt = getent("player_vehicle_" + lvt_num,"targetname");
	
	
	if(lvt_num == 1 && pod_num == 1)
	{
		vehnode = getvehiclenode("auto3992","targetname");
		vehnode waittill("trigger");
								
		iprintlnbold("Guys...shhhh...enemies spotted ahead");
		wait(5);
		iprintlnbold("Lets take 'em by surprise");
	}
	
	lvt waittill("reached_end_node");
	
	if( (lvt_num == 1) && (pod_num == 2) )
	{
		iprintlnbold("We've got emeies ahead!! GO! GO! GO!!");
	}
	
	players = get_players();
	
	for(x=0;x<players.size;x++)
	{
		players[x] setorigin( players[x].origin - (0,0,1000));	
	}
	
	danodes = getnodearray("pod" + pod_num + "_lvt" + lvt_num + "_ai","targetname");
	guys = getentarray("lvt" + lvt_num + "_guys","targetname");
	for(i=0;i<guys.size;i++)
	{
		guys[i] unlink();
		guys[i] teleport(danodes[i].origin );
		guys[i] setgoalentity( players[0]);
		guys[i].ignoreall = false;
		
		if(pod_num == 1)
		{
			guys[i] allowedstances ( "crouch","prone");
			guys[i].pacifist = true;
		}
	}			
	
	players = get_players();	
	for (i = 0; i < players.size; i++)
	{
		players[i] setorigin( players[i].origin + (0,0,1000));	
		player = players[i];
		if( isDefined(player.current_lvt ) && (player.current_lvt == lvt_num) )
		{	
			player unlink();
			points = getentarray("player_getoff_" + player.current_lvt + "_" + pod_num,"targetname");
			point = points[randomint(points.size)];
			
			player setorigin(point.origin);
			player setplayerangles(point.angles);			
			player.current_lvt = undefined;
		}
		
	}
	
	level notify("lvt unloaded");	
}



/*-----------------------------------------------------
patollers around the first area
-----------------------------------------------------*/
pod1_patrollers()
{
	
	
	patrollers = getentarray("auto3922","targetname");	
	array_thread(patrollers,::monitor_pod1_patroller);
			
	level waittill("pod1 alerted");
	
	ai1 = getentarray("lvt1_guys","targetname");
	ai2 = getentarray("lvt2_guys","targetname");
	for(i = 0;i<ai1.size;i++)
	{
		ai1[i] allowedstances ("stand","crouch","prone");
		ai1[i].pacifist = false;	
	}
	
	for(i = 0;i<ai2.size;i++)
	{
		ai2[i] allowedstances ("stand","crouch","prone");
		ai2[i].pacifist = false;	
	}
	
		
	//should play some kind of whistle blowing, or yelling, or something
	wait randomintrange(0,4);
	maps\_spawner::flood_spawner_scripted( getentarray("pod1_reinforcements","targetname") );
	
}



///*-----------------------------------------------------
//mortar teams in first area
//-----------------------------------------------------*/
//monitor_pod1_enemies()
//{
//
//	while( (!level.pod1_enemies_cleared) && (!level.patrollers_cleared) )
//	{
//		wait 1;
//	}
//	
//	level.pod1_complete = true;
//
//}
//
//monitor_pod1_patrollers()
//{
//	waittill_aigroupcleared ("pod1_patrollers");
//	level.patrollers_cleared = true;
//	
//}

//pod1_mortarteam1()
//{
//
//		waittill_aigroupcleared ("pod1_mortarteam_1");		
//		level notify("mortar cleared",1);
//		
//}
//
//pod1_mortarteam2()
//{
//
//		waittill_aigroupcleared ("pod1_mortarteam_2");		
//		level notify("mortar cleared",2);
//		
//}
//
//monitor_mortarteams_pod1()
//{
//	mortar1cleared = false;
//	mortar2cleared = false;
//	objective_add(1,"current",&"RHI1_OBJ1",(-13831 ,16504.5, 91));
//	objective_additionalposition(1,1,(-13567 ,17877.5, 96));
//	level endon("mortars cleared");
//	
//	for(;;)
//	{
//		level waittill("mortar cleared",mortargroup);
//		if(mortargroup ==1)
//		{
//			if( mortar2cleared )
//			{
//				objective_State(1,"done");
//				level.pod1_complete = true;
//				level notify("mortars cleared");				
//			}
//			else
//			{
//				objective_delete(1);
//				objective_add(1,"current",&"RHI1_OBJ1");
//				objective_additionalposition(1,0,(-13831 ,16504.5, 91));
//				mortar1cleared = true;
//			}
//		}
//		else
//		{
//			if( mortar1cleared)
//			{
//				objective_state(1,"done");
//				level.pod1_complete = true;				
//				level notify("mortars cleared");
//				
//			}
//			else
//			{
//				objective_delete(1);
//				objective_add(1,"current",&"RHI1_OBJ1");
//				objective_additionalposition(1,0,(-13567 ,17877.5, 96));
//				mortar2cleared = true;
//			}
//		}
//		
//	}
//}


/*-----------------------------------------------------
monitor the patrol guys to see when they spot an enemy
-----------------------------------------------------*/
monitor_pod1_patroller()
{
	self waittill("enemy");
	level notify("pod1 alerted");
	guys = getentarray("auto3922","targetname");
	for(i=0;i<guys.size;i++)
	{
		guys[i] notify("enemy");
		guys[i].goalradius = level.default_goalradius;
	}
}


/*-----------------------------------------------------
start the last event - assault the port factory to eliminate the MG42's
-----------------------------------------------------*/
start_factory_assault(start_point)
{
	
	
	//mortars
//	//generic_style( strExplosion, fDelay, iBarrageSize, fBarrageDelay, iMinRange, iMaxRange, bTargetsUsed )
//	level thread maps\_mortar::generic_style( "water_mortar", 1, 5, 3, 200, 10000, undefined);
//	level thread maps\_mortar::generic_style( "dirt_mortar", 1, 5, 3, 200, 10000, undefined);

	// MikeD (8/20/2007): Updated the _mortar script.

	// water mortars
	maps\_mortar::set_mortar_delays( "water_mortar", 0.75, 1, 2, 3 );
	maps\_mortar::set_mortar_range( "water_mortar", 200, 10000 );
	level thread maps\_mortar::mortar_loop( "water_mortar", 5 );

	// dirt mortars
	maps\_mortar::set_mortar_delays( "dirt_mortar", 0.75, 1, 2, 3 );
	maps\_mortar::set_mortar_range( "dirt_mortar", 200, 10000 );
	level thread maps\_mortar::mortar_loop( "dirt_mortar", 5 );
	
	
	patrollers = getentarray("auto3922","targetname");
	for(i=0;i<patrollers.size;i++)
	{
		patrollers[i] delete();
	}
	
	motars = getentarray("mortar_team","targetname");
	for(i=0;i<motars.size;i++)
	{
		motars[i] delete();
	}
	
	level notify("start_mortars");	
	
	if(isDefined(start_point))
	{
			level waittill ("introscreen_complete");	
	}
			
	level thread maps\_camsys::playback_scene( "mid" );
	level waittill("plackback_finished");	

	//grab the players & friendly AI and move them into the starting positions
	player_starts = getentarray("e2_player_start","targetname");
	players = get_players();
	
	startnode = getnode( "auto3710", "targetname" );

	if( isDefined( players[0]))
	{
		players[0] setfriendlychain( startnode ); 
	}
		
	for(i=0;i<players.size;i++)
	{
		players[i] setorigin (player_starts[i].origin + (0,0,-10000));
	}	
	
	ai_starts = getentarray("factory_ai_start","targetname");
	
	guys = getentarray("friends","targetname");		
	
	for(i=0;i<guys.size;i++)
	{
		guy = guys[i] stalingradspawn();
		guy waittill("finished spawning");
		guy teleport(ai_starts[i].origin);
		guy setgoalentity( players[0]);
		guy.targetname = guys[i].targetname;
		if(i < 3)
		{
			guy magic_bullet_shield();
		}
				
		guys[i] delete();		
		
	}	
	
	for(i=0;i<players.size;i++)
	{
		players[i] setorigin (player_starts[i].origin);
		players[i] setplayerangles( player_starts[i].angles);
	}		
  
  //start the action!
	factory_assault();
	
}


/*-----------------------------------------------------
begin the assault
-----------------------------------------------------*/
factory_assault()
{
	
	//spawn and initialize the engineers who are  under attack
	init_engineers();
	init_mg42s();
	
	//setup the objectives
	level thread init_factory_objectives();
	level thread monitor_factory_objectives();
	
	//set the threat bias so that the attackers continue to attack the engineers as long as possible
	setthreatbias("attackers","engineers",1200);
	setthreatbias("attackers","allies",-100);
	
	players = get_players();
	startnode = getnode( "auto3710", "targetname" );
	if( isDefined( players[0]))
	{
		players[0] setfriendlychain( startnode ); 
	}
	
	thread delete_guys();
		
}


delete_guys()
{
	
	lvt1guys = getentarray("lvt1_guys","targetname");
	lvt2guys = getentarray("lvt2_guys","targetname");

	for(x=0;x<lvt1guys.size;x++)
	{
		
		if ( isdefined( lvt1guys[x].magic_bullet_shield ) && lvt1guys[x].magic_bullet_shield )
		{
			lvt1guys[x] notify( "stop magic bullet shield" );
			wait (.1);
			lvt1guys[x] delete();
			
		}
	}	
	for(x=0;x<lvt2guys.size;x++)
	{
		if ( isdefined( lvt2guys[x].magic_bullet_shield ) && lvt2guys[x].magic_bullet_shield )
		{
			lvt2guys[x] notify( "stop magic bullet shield" );
			wait (.1);
			lvt2guys[x] delete();
		}
	}
	
}


/*-----------------------------------------------------
initialize the objectives for the MG42's
-----------------------------------------------------*/
init_factory_objectives()
{
	
	//wait a few seconds for the guys to spawn and then grab them
	wait(2);	
	guys = get_ai_group_ai("factory_objectives");	
	level notify("update objectives");	
	array_thread(guys,::factory_objectives);
		
}

init_mg42s()
{
	
}

/*-----------------------------------------------------
wait for the guy to die and then notify the level
-----------------------------------------------------*/
factory_objectives()
{
	self waittill("death");
	level notify("update objectives");		
		
}

/*-----------------------------------------------------
update the objectives
-----------------------------------------------------*/
monitor_factory_objectives()
{
	
	level endon ("all objectives done");
	
	
	for(;;)
	{
		
		level waittill("update objectives");
				
		guys = get_ai_group_ai("factory_objectives");
		if(guys.size)
		{
			objective_delete(1);
			switch(guys.size)
			{
				case 1:	objective_add(1,"current",&"RHI1_OBJ4_1");	break;
				case 2: objective_add(1,"current",&"RHI1_OBJ4_2");	break;
				case 3: objective_add(1,"current",&"RHI1_OBJ4_3");	break;
			
			}
			
			for(i=0;i<guys.size;i++)
			{
				objective_additionalposition(1, i ,guys[i].origin);			
			}
		}
		else
		{
			objective_string_nomessage(1, &"RHI1_OBJ4");
			objective_state(1,"done");
			wait(5);
			missionsuccess( "rhi1", false );
		}	
	}
	
}


/*-----------------------------------------------------
initialize the engineers
-----------------------------------------------------*/
init_engineers()
{
		spawners = getentarray("engineers","targetname");
		for(i=0;i<spawners.size;i++)
		{
			guy = spawners[i] stalingradspawn();
			guy waittill("finished spawning");
			guy.targetname = "engineers";			
			guy.target = spawners[i].target;
			guy.script_noteworthy = spawners[i].script_noteworthy;
			guy thread magic_bullet_Shield();
			guy setthreatbiasgroup( "engineers");
			guy.ignoreall = true;
			guy.pacifist = true;
			guy.pacifistwait = .05;
			spawners[i] delete();
			
		}
		
		//maps\rhi1_anim::set_animnames();
		//level thread engineer_think();
		//level thread engineers_build_bridge();
}



/*-----------------------------------------------------
///////////////////////////////////////////////////////

previous stuff - removed 

///////////////////////////////////////////////////////
-----------------------------------------------------*/

//swiped from Alex!( and modified )
lvt_explosions()
{

	level endon( "end lvt mortars" );
	
	while( 1 )
	{
		wait( randomintrange(5,10) + randomint(4) );
		
		forward_vec = anglestoforward( self.angles );
		destination_pos = self.origin + forward_vec * 300 + ( 0, randomintrange(-125,125), 0 );
		
		ent = spawnstruct();
		ent.origin = destination_pos;
		ent maps\_mortar::mortar_boom( destination_pos, randomfloatrange(.45,1), undefined, 400, level._effect["water_mortar"], true );
		
		
		//playfx(level._effect["water_mortar"],destination_pos);		
		//doesn't seem to work ??
		//self joltbody((self.origin + (0,0,64)) ,1000000);
		
		//hackey bits to simulate joltbody..
//		players = get_players();
//		for(i=0;i<players.size;i++)
//		{
//			if( (players[i].current_lvt == 1) &&  ( self.targetname == "player_vehicle_1"))
//			{
//				players[i] shellshock("tankblast",randomintrange(3,6));
//			}
//			if((players[i].current_lvt == 2) && ( self.targetname =="player_vehicle_2"))
//			{
//				players[i] shellshock("tankblast",randomintrange(3,6));
//			}
//		}
		
	}
}

//// put ai on the lvt
put_ai_on_lvt(lvt,start_num,do_spawn)
{
	//spawn LVT guys
	
	if(do_spawn)
	{
		spawners = getentarray("lvt" + lvt + "_guys","targetname");
		for(i=0;i<spawners.size;i++)
		{
			guy = spawners[i] stalingradspawn();
			guy waittill("finished spawning");
			guy.targetname = spawners[i].targetname;
			
			if(start_num == 1)
			{
				guy.pacifist = true;
			}
			else
			{
				guy.pacifist = false;
			}
			
			if(isDefined (spawners[i].script_noteworthy) && spawners[i].script_noteworthy == "players")
			{
				guy thread magic_bullet_shield();
			}
			
			spawners[i] delete();
		}
	}
	
	guys = getentarray("lvt" + lvt + "_guys","targetname");
	the_lvt = getent("player_vehicle_" + lvt,"targetname");
	start_node = getvehiclenode("lvt_" + lvt + "_start" + start_num,"targetname");
	
	tag = undefined;
	for (i = 0; i < guys.size; i++)
	{
		if( i <= 1)
		{
			tag = "tag_gunner" + (i+1);
		}
		else
		{
			tag = "tag_passenger" + (i+1);
		}
		
		guys[i] linkto (the_lvt, tag, (0,0,0), (0,0,0));
		//guys[i].currentlvt = lvt;
		guys[i].ignoreall = true;
		
		//guys[i].goalradius = 2048;	
		guys[i] set_default_pathenemy_settings();
		
		
	}
	
	the_lvt attachPath( start_node );
	level waittill ("start lvts");
	the_lvt startpath();
	//ai_lvt thread start_ai_lvt();
}


put_players_on_lvt()
{
	
	players = get_players();
	
	tag = undefined;
	for (i = 0; i < players.size; i++)
	{
		tag = "tag_passenger" + (i+5);
		if(i % 2)
		{
			players[i] playerlinktodelta (level.lvt2, tag, 0.5);
			players[i] setplayerangles(0,300,0);
			if(!isDefined(players[i].current_lvt))
			{
				players[i].current_lvt = 2;
				
			}
		}
		else
		{
			players[i] playerlinktodelta (level.lvt1, tag, 0.5);
			if(!isDefined(players[i].current_lvt))
			{
				players[i].current_lvt = 1;
			}
		}
	}	
		
}



//engineers_build_bridge()
//{
//		engineers = getentarray("engineers","targetname");
//		
//		//toggle_ignore_engineers(true);
//		
//		for(i=0;i<engineers.size;i++)
//		{
//			guy = engineers[i];
//			danode = getnode(guy.script_noteworthy,"targetname");
//			guy.goalradius = 24;
//			guy setgoalnode( danode );
//			guy thread monitor_engineer_damage();
//		}
//	
//		//thread maps\rhi1_anim::pickup_new_piece();
//	
//}
//


//engineers_take_cover()
//{
//		engineers = getentarray("engineers","targetname");
//		//toggle_ignore_engineers(false);
//		
//		for(i=0;i<engineers.size;i++)
//		{
//			guy = engineers[i];
//			danode = getnode(guy.target,"targetname");
//			guy.goalradius = 24;
//			guy setgoalnode( danode );
//		}
//	
//}
//

//toggle_ignore_players(toggle)
//{
//
//	players = get_players();
//	for(i=0;i<players.size;i++)
//	{
//		players[i].ignoreme = toggle;
//	}
//	
//	ai_guys = getentarray("friends","targetname");
//	for(i=0;i<ai_guys.size;i++)
//	{
//		ai_guys[i].ignoreme = toggle;
//		ai_guys[i].pacifist = toggle;
//	}
//	
//}
//
//

//monitor_engineer_damage()
//{
//	self waittill("damage");
//	level notify("engineers under attack");
//}
//
//

//engineer_think()
//{
//
//	for(;;)
//	{
//		level waittill("engineers under attack");
//		engineers_take_cover();
//		
//		level waittill("engineers safe");
//		engineers_build_bridge();
//	}
//
//}


house_shutter_guys(trig,house)
{
	trig = getent(trig,"targetname");
	trig waittill("trigger");
		
	for(i=1;i<=3;i++)
	{
		thread house_shutters(i,house);	
	}
}

house_shutters(num,house)
{
	wait(randomfloatrange(.5,2));
		
	shutter_l = getent("house" + house + "_shutter" + num + "_l","targetname");
	shutter_r = getent("house" + house + "_shutter" + num + "_r","targetname");
	guy = getent("house"+ house + "_guy" + num,"targetname");
	
	ai = guy stalingradspawn();
	shutter_l rotateyaw( -140,.2);
	shutter_r rotateyaw ( 140,.13);
	wait(1);
	if(isDefined(ai))
	{
		ai thread bloody_death(true,9);
	}	
	
}



// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die )
	{
		self DoDamage( self.health + 50, self.origin );
	}
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}
