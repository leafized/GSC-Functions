#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;


main()
{
	level thread start_noise_test();
	level thread music_fade_test();
	//level thread occlusion_test();
	level thread occlusion_loop_test();
	level thread stop_loop_test();

	thread music_state_change("music_torch_trigger", "torch");
	thread music_state_change("music_fight_trigger", "fight");
	thread music_state_change("music_path_trigger",  "path");
	thread music_state_change("music_cross_trigger",  "cross");
	thread music_state_change("music_fadeout_trigger",  "fadeout");
	thread music_state_change("music_stop_trigger",  "");
	

	//level thread death_script();

	activateAmbientPackage( "none", 0 );
	activateAmbientRoom( "_Ber1", 0 );
}


//************************************************************************************************
//			 	OTHER AUDIO FUNCTIONS
//************************************************************************************************
start_noise_test()
{
	level waittill ("yo_bitch_play_stuff");	
	level thread noisytime();	

}
noisytime()
{
	left_front_l = getent("left_front", "targetname");	
	right_front_l = getent("right_front", "targetname");
	center_l = getent("center", "targetname");
	left_surround_l = getent("left_surround", "targetname");
	right_surround_l = getent("right_surround", "targetname");
	
	level endon("reset");
	
	while(1)
	{ 
	
	
		left_front_l playsound("noise_test", "targetname");
		wait(2);
		center_l playsound("noise_test", "targetname");
		wait(2);
		right_front_l playsound("noise_test", "targetname");
		wait(2);
		right_surround_l playsound("noise_test", "targetname");
		wait(2);
		left_surround_l playsound("noise_test", "targetname");
		wait(2);
		
		/*
		playsoundatposition("noise_test", left_front_l.origin);		
		wait (2);		
		playsoundatposition("noise_test", center_l.origin);
		wait (2);
		playsoundatposition("noise_test", right_front_l.origin);
		wait (2);
		playsoundatposition("noise_test", right_surround_l.origin);
		wait (2);
		playsoundatposition("noise_test", left_surround_l.origin);
		wait(2);
		*/
	}

}
music_fade_test()
{
	trigger_on = getent("audio_mccaul_music_on", "targetname");
	trigger_off = getent("audio_mccaul_music_off", "targetname");
	music_playa = getent("audio_mccaul_music_playa", "targetname");
	
	while (1)
	{
		trigger_on waittill ("trigger");
		music_playa playloopsound("test_song");
		
		trigger_off waittill ("trigger");
		music_playa stoploopsound(2);
		
		
		//trigger_off waittill("trigger");
		//musicstop(1);
		//wait(2);
		//musicplay("MX_Intro");
	}
}
occlusion_test()
{
	trigger = getent("occluded_mccaul", "targetname");
	
	noise_maker = getent( "occluded_mccaul_random" , "targetname" );

	while (1)
	{
		trigger waittill ("trigger");
		wait randomfloatrange(.5,1);
		noise_maker playsound("occlude", "sound_done");
		noise_maker waittill("sound_done");
		wait randomfloatrange(.2,.5);
	}
}
occlusion_loop_test()
{
	trigger = getent("occluded_mccaul", "targetname");
	
	noise_maker = getent( "occluded_mccaul_random" , "targetname" );

	level waittill ("start");
	//wait randomfloatrange(.5,1);
	noise_maker playloopsound("occlude_loop");
	//noise_maker waittill("sound_done");
	//wait randomfloatrange(.2,.5);
}
stop_loop_test()
{
	
	looper_test = getent( "stop_loop_test" , "targetname" );

	level waittill ("start_loop");
	looper_test playloopsound("klaxxon");
	level waittill ("stop_loop");
	looper_test stoploopsound();
}
music_state_change(triggername, state)
{
	while(1)
	{
		getent(triggername, "targetname") waittill("trigger");
		maps\_music::setMusicState(state);
	}
}
death_script()
{
	wait(8);
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] waittill("death");
		players[i] thread death_music_state();		

	}
	

}
death_music_state()
{	
	setmusicstate("DEATH");
}