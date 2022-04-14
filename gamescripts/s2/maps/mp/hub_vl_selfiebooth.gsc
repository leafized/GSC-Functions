/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: hub_vl_selfiebooth.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 280 ms
 * Timestamp: 8/24/2021 10:27:38 PM
*******************************************************************/

//Function Id: 0x525D
//Function Number: 1
func_525D()
{
	var_00 = common_scripts\utility::func_46B5("selfie_player_pos","targetname");
	if(!isdefined(var_00))
	{
		return;
	}

	var_01 = common_scripts\utility::func_46B5(var_00.var_01A2,"targetname");
	var_02 = common_scripts\utility::func_46B5(var_01.var_01A2,"targetname");
	level.var_83C4 = spawnstruct();
	level.var_83C4.var_7300 = var_00;
	level.var_83C4.var_1EA0 = var_02;
	setdvarifuninitialized("scr_vlobby_selfie_correction_y",32);
	setdvarifuninitialized("scr_vlobby_selfie_collision_z",10);
	level thread func_7F6F();
}

//Function Id: 0x7F6F
//Function Number: 2
func_7F6F()
{
	while(!isdefined(level.var_721C))
	{
		wait 0.05;
	}

	level.var_721C func_90A1();
	wait(5);
	for(;;)
	{
		wait 0.05;
		if(function_02A4() || !function_02A3() || getdvarint("664"))
		{
			continue;
		}

		if(!func_8B81())
		{
			continue;
		}

		func_95CD();
	}
}

//Function Id: 0x90A1
//Function Number: 3
func_90A1()
{
	while(!isdefined(level.var_721C.var_9042) || !isdefined(level.var_721C.var_9042.var_267E))
	{
		wait 0.05;
	}

	var_00 = level.var_83C4.var_7300.var_0116;
	var_01 = getdvarfloat("scr_vlobby_selfie_collision_z",0);
	var_02 = getdvarfloat("scr_vlobby_selfie_correction_y",0);
	var_03 = (0,var_02,var_01);
	var_00 = var_00 + var_03;
	var_04 = level.var_83C4.var_7300.var_001D;
	var_05 = maps/mp/agents/_agent_utility::func_44EE("selfie_clone");
	var_05.var_565F = 1;
	var_05 method_838F(var_00,var_04,undefined,undefined,undefined,undefined,1);
	var_06 = level.var_721C getxuid();
	function_02BA(var_05,var_06);
	var_05 method_83D6(1);
	var_05 method_83D5("vlobby_animclass");
	var_05 method_83D7("lobby_idle","selfie_01",1);
	var_05 setcostumemodels(level.var_721C.var_9042.var_267E);
	var_05 linkto(level.var_83C4.var_7300);
	level.var_83C4.var_242C = var_05;
	self.var_83C3 = var_05;
}

//Function Id: 0x8B81
//Function Number: 4
func_8B81()
{
	if(!isdefined(level.var_721C))
	{
		return 0;
	}

	if(!isdefined(level.var_721C.var_9042) || !isdefined(level.var_721C.var_9042.var_267E))
	{
		return 0;
	}

	if(level.var_721C method_84FC())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0x95CD
//Function Number: 5
func_95CD()
{
	if(!isdefined(level.var_83C4.var_242C))
	{
		return;
	}

	if(!isdefined(level.var_721C))
	{
		return;
	}

	if(!isdefined(level.var_721C.var_9042))
	{
		return;
	}

	if(!isdefined(level.var_721C.var_9042.var_267E))
	{
		return;
	}

	var_00 = level.var_83C4.var_242C.var_0116;
	var_01 = level.var_83C4.var_242C geteye();
	level.var_83C4.var_242C setcostumemodels(level.var_721C.var_9042.var_267E);
	wait 0.05;
	if(!level.var_721C selfierequestupdate(level.var_83C4.var_1EA0.var_0116,var_00,var_01[2] - var_00[2],0,0))
	{
		return;
	}

	while(isdefined(level.var_721C) && !level.var_721C method_8500())
	{
		wait 0.05;
	}
}