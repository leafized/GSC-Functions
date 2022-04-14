/*-----------------------------------------------------
Animation loadout for Okinawa 2
-----------------------------------------------------*/
#include maps\_utility;
#include maps\_anim;

main()
{

	precache_anims();
	maps\_mganim::main();
	
	//animation level vars
	level.bridgestate = 0;

}

#using_animtree ("generic_human");
precache_anims()
{
//
//	level.scr_anim["truck_left1"]["pickup"] = %Ch_rhineland1_engineer1_part1;
//	level.scr_anim["truck_right1"]["pickup"] = %Ch_rhineland1_engineer2_part1;
//	level.scr_anim["truck_left2"]["pickup"] = %Ch_rhineland1_engineer1_part1;
//	level.scr_anim["truck_right2"]["pickup"] = %Ch_rhineland1_engineer2_part1;
//	level.scr_anim["truck_back_left"]["bolt"] = %o_rhineland_bridge1;
//	level.scr_anim["truck_back_right"]["bolt"] = %o_rhineland_bridge2;
	
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
}


set_animnames()
{
	guys = getentarray("engineers","targetname");
	for(i=0;i<guys.size;i++)
	{		
		guys[i].animname = guys[i].script_noteworthy;
	}	
}


#using_animtree ("generic_human");
pickup_new_piece()
{
	for(;;)
	{
		//guys on left side of truck
		engineer_l1 = getent("truck_left1","script_noteworthy");
		engineer_l2 = getent("truck_left2","script_noteworthy");
		
		//guys on right side of truck
		engineer_r1 =getent("truck_right1","script_noteworthy");
		engineer_r2 =getent("truck_right2","script_noteworthy");
		
		//nodes
		l1 = getnode("truck_left1","targetname");
		l2 = getnode("truck_left2","targetname");
		r1 = getnode("truck_right1","targetname");
		r2 = getnode("truck_right2","targetname");
		
		
		//make sure guys are at their nodes
		engineer_l1 setgoalnode (l1);
		engineer_l2 setgoalnode (l2);
		engineer_r1 setgoalnode (r1);
		engineer_r2 setgoalnode (r1);
		
		//engineer_l1 waittill("goal");
		//engineer_l2 waittill ("goal");
		//engineer_r1	waittill ("goal");
		//engineer_r2	waittill ("goal");
		

		// Set up the array of guys to pass into the anim_loop
		engineers = [];
		engineers = array_add ( engineers, engineer_l1 );
		engineers = array_add ( engineers, engineer_l2 );
		engineers = array_add ( engineers, engineer_r1 );
		engineers = array_add ( engineers, engineer_r2 );
	
		// Start the anim_reach thread. We're using the model as the entity to thread this,
		// but it could be a script origin or a node, or any entity with an origin and angles.
		engineer_l1 anim_single ( engineers, "pickup");
		wait (3);
	}	
}


send_to_nodes()
{
	
	
	
			
}

