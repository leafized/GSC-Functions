/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: mp_hub_allies_lighting.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 87 ms
 * Timestamp: 8/24/2021 10:27:44 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	thread func_6B82();
}

//Function Id: 0x6B82
//Function Number: 2
func_6B82()
{
	level endon("game_ended");
	for(;;)
	{
		level waittill("player_spawned",var_00);
		var_00 vignettesetparams(level.var_A4B5["intensity"],level.var_A4B5["falloff"],level.var_A4B5["scaleX"],level.var_A4B5["scaleY"],level.var_A4B5["squareAspectRatio"]);
		var_00 setscriptmotionblurparams(level.var_6465["velocityscaler"],level.var_6465["cameraRotationInfluence"],level.var_6465["cameraTranslationInfluence"]);
	}
}