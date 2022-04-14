#include maps\_utility;
#include maps\_anim;

#using_animtree ("generic_human");

main()
{
	setup_human_anims();
	setup_player_interactive_anims();
	
	// animations needed for util/anim scripts
	maps\_mganim::main();
}

setup_human_anims()
{
	level.scr_anim["PvtGrant"]["radio"] = %ch_prologue_intro_guy2;
	addNotetrack_dialogue( "PvtGrant", "dialog", "radio", "Pro1_INT_000A_GRAN" );
	addNotetrack_dialogue( "PvtGrant", "dialog", "radio", "Pro1_INT_002A_GRAN" );
	addNotetrack_dialogue( "PvtGrant", "dialog", "radio", "Pro1_INT_006A_GRAN" );

	level.scr_anim["Sarge"]["reinforce"] = %ch_prologue_intro_guy1;
	addNotetrack_dialogue( "Sarge", "dialog", "reinforce", "Pro1_INT_001A_SARG" );
	addNotetrack_dialogue( "Sarge", "dialog", "reinforce", "Pro1_INT_003A_SARG" );
	addNotetrack_dialogue( "Sarge", "dialog", "reinforce", "Pro1_INT_004A_SARG" );
	addNotetrack_dialogue( "Sarge", "dialog", "reinforce", "Pro1_INT_005A_SARG" );
	addNotetrack_dialogue( "Sarge", "dialog", "reinforce", "Pro1_INT_007A_SARG" );
	
	level.scr_anim["PvtGrant"]["flare_wait"] = %covercrouch_hide_look;
	level.scr_anim["Sarge"]["flare_wait"] = %covercrouch_hide_look;
	//level.scr_sound["Sarge"]["flare_wait"] = "print: What the hell are those idiots thinking? That flare will give us away";
	
	level.scr_anim["Sarge"]["flare_explode"] = %oki2_pointing_plane;
	level.scr_sound["Sarge"]["flare_explode"] = "print: AMBUSH!";
	
	level.scr_anim["bayonet_enemy1"]["stab"][0] = %ch_prologue_bayonet_guy1;
	level.scr_anim["bayonet_enemy1_alt"]["stab"][0] = %ch_prologue_bayonet_guy2;
	level.scr_anim["bayonet_friendly1"]["stab"] = %ch_peleliu1_bayonet_guy3_dead;
	
	level.scr_anim["bayonet_enemy3"]["flipover"] = %ch_bayonet_flipover_guy1;
	level.scr_anim["bayonet_friendly3"]["flipover"] = %ch_bayonet_flipover_guy2;
	level.scr_anim["bayonet_enemy3"]["fightback"] = %ch_bayonet_jumpin_guy1;
	level.scr_anim["bayonet_friendly3"]["fightback"] = %ch_bayonet_jumpin_guy2;
	level.scr_anim["bayonet_enemy3"]["secondDeath"] = %ai_bonzai_enemy_success_rear;
	level.scr_anim["bayonet_friendly3"]["secondDeath"] = %ai_bonzai_buddy_fail_rear;
	
	level.scr_anim["Sarge"]["finalEvent"] = %ch_prologue_end_struggle_guy1;
	level.scr_sound["Sarge"]["finalEvent"] = "print: BEHIND YOU!";
	level.scr_anim["SargeVs"]["finalEvent"] = %ch_prologue_end_struggle_guy2;
	level.scr_anim["PvtGrant"]["finalEvent"] = %ch_prologue_end_bayonet_guy1;
	level.scr_anim["PvtGrantVs"]["finalEvent"] = %ch_prologue_end_bayonet_guy2;
	
	level.scr_anim["Player"]["decapitate"] = %ch_prologue_intro_player;
	level.scr_anim["KatanaGuy"]["beheaded"] = %ch_prologue_officer_attack;
	
	level.scr_anim["grenadeGuy"]["getupStandup"] = %ch_grass_prone2run_a;
	
	level.scr_anim["generic"]["banzai"] = %ai_bonzai_sprint_a;
	//level.scr_sound["KatanaGuy"]["decapitate"] = "print: Banzai!";
	/*
	level.scr_anim["generic_enemy"]["proneToCrouch"] = %ch_;
	level.scr_anim["generic_enemy"]["crouchToStand"] = %ch_;
	level.scr_anim["generic_enemy"]["banzai1"] = %ch_;
	level.scr_anim["generic_enemy"]["banzai2"] = %ch_;
	level.scr_anim["generic_enemy"]["banzai3"] = %ch_;
	*/
}

// non-AI anim setup
#using_animtree( "player" );

setup_player_interactive_anims()
{
	level.scr_animtree["player_interactive"] = #animtree;
	level.scr_model["player_interactive"] = "viewmodel_usa_player";
	level.scr_anim["player_interactive"]["beheaded"] = %int_prologue_beheaded;
}

notify_after_anim( anim_notify_str, script_notify_str )
{
	if( !IsDefined( anim_notify_str ) )
	{
		anim_notify_str = "single anim";
	}
	if( !IsDefined( script_notify_str ) )
	{
		script_notify_str = "anim complete";
	}

	self waittillmatch( anim_notify_str, "end" );
	self notify(script_notify_str);
}

play_scripted_getup()
{
}