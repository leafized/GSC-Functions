/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1359.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 3 ms
 * Timestamp: 8/24/2021 10:29:21 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_054F::func_00D5()
{
	level.var_24DC = [];
	var_0C = getentarray("lore_primary","script_noteworthy");
	foreach(var_0E in var_0C)
	{
		var_0F = spawnstruct();
		var_0F.var_378F = var_0E;
		var_0F.var_24D1 = var_0E.var_8260;
		var_0F.var_9D64 = "use";
		lib_054F::func_7BA2(var_0F);
	}
}

//Function Id: 0x7BA2
//Function Number: 2
lib_054F::func_7BA2(param_00)
{
	if(getdvarint("scr_zombieAllowNestCollectibles",0) == 1)
	{
		param_00.var_24D2 = lib_0550::func_24D3(param_00.var_24D1);
		var_01 = [];
		if(!isdefined(param_00.var_9D64))
		{
			param_00.var_9D64 = "use";
		}

		if(param_00.var_9D64 == "use")
		{
			var_01 = getentarray(param_00.var_378F.var_01A2,"targetname");
			var_01[0].var_378F = param_00.var_378F;
			var_01[0].var_5F13 = param_00;
			thread maps\mp\_utility::func_6F74(::lib_054F::func_5F11,var_01[0]);
		}

		foreach(var_03 in var_01)
		{
			var_03 usetriggerrequirelookat(1);
			param_00 thread lib_054F::func_5F10(var_03);
		}

		level.var_24DC[param_00.var_24D1] = param_00;
		return;
	}

	var_01 = getentarray(param_00.var_378F.var_01A2,"targetname");
	var_01[0] makeunusable();
	param_00.var_378F method_805C();
}

//Function Id: 0x86B3
//Function Number: 3
lib_054F::func_86B3(param_00,param_01,param_02)
{
	param_00 [[ common_scripts\utility::func_98E7(param_02,::showtoclient,::hidefromclient) ]](param_01);
}

//Function Id: 0x86B2
//Function Number: 4
lib_054F::func_86B2(param_00,param_01,param_02)
{
	param_00 [[ common_scripts\utility::func_98E7(param_02,::enableplayeruse,::disableplayeruse) ]](param_01);
}

//Function Id: 0x5F0F
//Function Number: 5
lib_054F::func_5F0F(param_00)
{
	var_01 = self;
}

//Function Id: 0x5F0E
//Function Number: 6
lib_054F::func_5F0E(param_00)
{
	var_01 = self;
	param_00 lib_054F::func_5F11(var_01);
}

//Function Id: 0x5F11
//Function Number: 7
lib_054F::func_5F11(param_00)
{
	var_01 = param_00.var_5F13;
	var_02 = var_01.var_24D2;
	var_03 = param_00.var_378F;
	var_04 = lib_0550::func_415C(self,var_02);
	lib_054F::func_86B3(var_03,self,!var_04);
	lib_054F::func_86B2(param_00,self,!var_04);
}

//Function Id: 0x5F12
//Function Number: 8
lib_054F::func_5F12(param_00)
{
	var_01 = self;
	var_02 = var_01.var_24D2;
	if(isdefined(level.var_744A))
	{
		foreach(var_04 in level.var_744A)
		{
			var_04 lib_054F::func_5F11(param_00);
		}
	}

	for(;;)
	{
		level waittill("connected",var_04);
		var_04 lib_054F::func_5F11(param_00);
	}
}

//Function Id: 0x5F10
//Function Number: 9
lib_054F::func_5F10(param_00)
{
	for(;;)
	{
		param_00 waittill("trigger",var_01);
		if(!isplayer(var_01))
		{
			continue;
		}

		self.var_378F hidefromclient(var_01);
		param_00 disableplayeruse(var_01);
		if(isdefined(self.var_6FC0))
		{
			self thread [[ self.var_6FC0 ]](var_01);
		}

		if(lib_0550::func_415C(var_01,self.var_24D2))
		{
			continue;
		}

		lib_0550::func_8470(var_01,self.var_24D2,1);
		var_01 lib_0378::func_8D74("found_collectible");
	}
}