#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;



#using_animtree ("generic_human");
main()
{
	
	// _load!
	maps\_load::main();
	
	// All the level support scripts.
	
	maps\audio_test_tuey_amb::main();
	
	//setdvar("ai_accu_player_lateral_speed", 1000);
	
	precacheitem("thompson");
	//precacheitem("fraggrenade");
	
	
}

