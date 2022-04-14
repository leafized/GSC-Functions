/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1374.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 2 ms
 * Timestamp: 8/24/2021 10:29:25 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_055E::func_00D5()
{
	level.var_0A41["zombie_boss"] = level.var_0A41["zombie"];
	level.var_0A41["zombie_boss"]["think"] = ::lib_055E::func_AB60;
	level.var_0A41["zombie_boss"]["move_mode"] = ::lib_055E::func_AB5F;
	level.var_0A41["zombie_boss"]["get_action_params"] = ::lib_055E::func_AB5D;
	level.var_0A41["zombie_boss"]["tesla_delayed_dmg"] = ::zombie_boss_tesla_delayed_dmg;
	var_00 = spawnstruct();
	var_00.var_0A4B = "zombie_boss";
	var_00.var_0EAE = "zombie_boss_animclass";
	var_00.var_0879 = "zombie_boss";
	var_00.var_5ED2["default"]["whole_body"] = "zom_brute_b_base";
	var_00.var_5ED2["default"]["heads"] = ["zom_head_fdr02_org1"];
	var_00.var_4C12 = 1;
	var_00.var_7F1A = 15000;
	var_00.var_60E2 = 40;
	var_00.parenttype = "zombie_generic";
	lib_0547::func_0A52(var_00,"zombie_boss");
}

//Function Id: 0xAB5F
//Function Number: 2
lib_055E::func_AB5F()
{
	return "walk";
}

//Function Id: 0xAB5D
//Function Number: 3
lib_055E::func_AB5D()
{
	var_00 = lib_054D::func_AC22();
	return var_00;
}

//Function Id: 0x0000
//Function Number: 4
zombie_boss_tesla_delayed_dmg(param_00,param_01,param_02)
{
	return param_00;
}

//Function Id: 0xAB61
//Function Number: 5
lib_055E::func_AB61()
{
	maps/mp/agents/humanoid/_humanoid::func_8A27();
	thread lib_054D::func_A146();
}

//Function Id: 0xAB60
//Function Number: 6
lib_055E::func_AB60()
{
	self endon("death");
	level endon("game_ended");
	self endon("owner_disconnect");
	lib_055E::func_AB61();
	for(;;)
	{
		self method_8395(self.var_0116);
		wait(0.5);
	}
}

//Function Id: 0xAAF6
//Function Number: 7
lib_055E::func_AAF6()
{
}