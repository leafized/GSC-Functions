// 	scripting by Bloodlust
// 	level design by BSouds


// 	FOR FUTURE REFERENCE - DO NOT DELETE!
//	level.scr_notetrack["basher1"][0]["notetrack"] = "pickup"; 										// Sets up basher1 to 'listen' for a notetrack of "pickup"
//	level.scr_notetrack["basher1"][0]["selftag"] = "tag_weapon_right"; 								// This is the tag name the model will attach to
//	level.scr_notetrack["basher1"][0]["attach model"] = "name_of_the_model_attached_to_guys_hands"; // This is the name of the model to attach to the tag


// 	Animation Level File
#using_animtree("generic_human");
main()
{
	// name of AI playing the animation, animation alias, name of the animation
	level.scr_anim["wavers"]["wave"][0] = %ch_berlin1_commissar_waving;
	
	level.scr_anim["sarge"]["door_kick"] = %door_kick_in;
	level.scr_anim["kicker"]["kick_bench"] = %ch_berlin1_kickBench;
	
	level.scr_anim["german"]["knife_bash_shoot"] = %ch_berlin1_E3vignette1_german;
	level.scr_anim["russian1"]["knife_bash_shoot"] = %ch_berlin1_E3vignette1_russian1;
	level.scr_anim["russian2"]["knife_bash_shoot"] = %ch_berlin1_E3vignette1_russian2;
	
	level.scr_anim["russian"]["sandbag"] = %ch_berlin1_E3vignette2_german;
	
	level.scr_anim["german"]["melee1"] = %ch_berlin1_E3vignette3_german;
	level.scr_anim["russian"]["melee1"] = %ch_berlin1_E3vignette3_russian;
	
	level.scr_anim["german"]["melee2"] = %ch_berlin1_E3vignette4_german;
	level.scr_anim["russian"]["melee2"] = %ch_berlin1_E3vignette4_russian;
	
	level.scr_anim["german"]["bayonette"] = %ch_berlin1_E3vignette5_german;
	level.scr_anim["russian"]["bayonette"] = %ch_berlin1_E3vignette5_russian;
}