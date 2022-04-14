// Animation Level File
#include maps\_anim;

#using_animtree("generic_human");

main()
{
	anim_loader();
}

anim_loader()
{
	//animations for the first 3 germans watching the bombers.
	level.scr_anim["bombwatcher1"]["single_anim"] = %door_kick_in;
	level.scr_sound["bombwatcher1"]["single_anim"] = "print: German: Those damn planes still bombing the city.";
	level.scr_anim["bombwatcher2"]["single_anim"] = %door_kick_in;
	level.scr_anim["bombwatcher3"]["single_anim"] = %door_kick_in;
	level.scr_sound["bombwatcher3"]["single_anim"] = "print: German: Yeah I hope that Flak Tower takes a few of them out.";
	
	//animations for the second group of germans watching the bombers.
	level.scr_anim["bombwatcher4"]["single_anim"] = %door_kick_in;
	level.scr_sound["bombwatcher4"]["single_anim"] = "print: German: I get tired of watching the city burn";
	level.scr_anim["bombwatcher5"]["single_anim"] = %door_kick_in;
	
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

	//MORE TO COME
}

rhi_dialog_and_anim(index)
{
	switch(index)
	{
		case 0: //-- event1: germans watching bombing run and then sets them to path, etc after they are done
			level endon("actor_damaged");
			
			self anim_single_solo(self, "single_anim"); //exits on completion
			//self waittill("single_anim");
			//self setthreatbiasgroup("enemies");
			
			wait 2;
			
			//make me patrol!
			self.target = self.script_noteworthy;
			self thread maps\_patrol::patrol();
		break;
		
		case 1: //-- event1: if you shoot the crane and it drops its package, you get some words of encouragement
		        // from the Sgt.
		        
		        
		break;
		
		default:
		break;
	}
}