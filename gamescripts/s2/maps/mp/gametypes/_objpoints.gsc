/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _objpoints.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 388 ms
 * Timestamp: 8/24/2021 10:22:42 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	precacheshader("objpoint_default");
	level.var_6995 = [];
	level.var_6996 = [];
	if(level.var_910F)
	{
		level.var_6998 = 15;
	}
	else
	{
		level.var_6998 = 8;
	}

	level.var_6994 = 0.7;
	level.var_6997 = 1;
}

//Function Id: 0x282F
//Function Number: 2
func_282F(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = func_45D6(param_00);
	if(isdefined(var_06))
	{
		func_2D3E(var_06);
	}

	if(!isdefined(param_03))
	{
		param_03 = "objpoint_default";
	}

	if(!isdefined(param_05))
	{
		param_05 = 1;
	}

	if(param_02 == "all")
	{
		var_06 = newhudelem();
	}
	else if(param_02 == "broadcaster")
	{
		var_06 = newteamhudelem("spectator");
	}
	else
	{
		var_06 = newteamhudelem(param_02);
	}

	var_06.var_0109 = param_00;
	var_06.var_01D3 = param_01[0];
	var_06.var_01D7 = param_01[1];
	var_06.var_01D9 = param_01[2];
	var_06.var_01A7 = param_02;
	var_06.var_56F5 = 0;
	var_06.var_57CB = 1;
	var_06 setshader(param_03,level.var_6998,level.var_6998);
	var_06 setwaypoint(1,0);
	if(isdefined(param_04))
	{
		var_06.var_0018 = param_04;
	}
	else
	{
		var_06.var_0018 = level.var_6994;
	}

	var_06.var_15F3 = var_06.var_0018;
	var_06.var_00D4 = level.var_6995.size;
	level.var_6996[param_00] = var_06;
	level.var_6995[level.var_6995.size] = param_00;
	return var_06;
}

//Function Id: 0x2D3E
//Function Number: 3
func_2D3E(param_00)
{
	if(level.var_6996.size == 1)
	{
		level.var_6996 = [];
		level.var_6995 = [];
		param_00 destroy();
		return;
	}

	var_01 = param_00.var_00D4;
	var_02 = level.var_6995.size - 1;
	var_03 = func_45D5(var_02);
	level.var_6995[var_01] = var_03.var_0109;
	var_03.var_00D4 = var_01;
	level.var_6995[var_02] = undefined;
	level.var_6996[param_00.var_0109] = undefined;
	param_00 destroy();
}

//Function Id: 0xA145
//Function Number: 4
func_A145(param_00)
{
	if(self.var_01D3 != param_00[0])
	{
		self.var_01D3 = param_00[0];
	}

	if(self.var_01D7 != param_00[1])
	{
		self.var_01D7 = param_00[1];
	}

	if(self.var_01D9 != param_00[2])
	{
		self.var_01D9 = param_00[2];
	}
}

//Function Id: 0x86E6
//Function Number: 5
func_86E6(param_00,param_01)
{
	var_02 = func_45D6(param_00);
	var_02 func_A145(param_01);
}

//Function Id: 0x45D6
//Function Number: 6
func_45D6(param_00)
{
	if(isdefined(level.var_6996[param_00]))
	{
		return level.var_6996[param_00];
	}

	return undefined;
}

//Function Id: 0x45D5
//Function Number: 7
func_45D5(param_00)
{
	if(isdefined(level.var_6995[param_00]))
	{
		return level.var_6996[level.var_6995[param_00]];
	}

	return undefined;
}

//Function Id: 0x92CF
//Function Number: 8
func_92CF()
{
	self endon("stop_flashing_thread");
	if(self.var_56F5)
	{
		return;
	}

	self.var_56F5 = 1;
	while(self.var_56F5)
	{
		self fadeovertime(0.75);
		self.var_0018 = 0.35 * self.var_15F3;
		wait(0.75);
		self fadeovertime(0.75);
		self.var_0018 = self.var_15F3;
		wait(0.75);
	}

	self.var_0018 = self.var_15F3;
}

//Function Id: 0x9401
//Function Number: 9
func_9401()
{
	if(!self.var_56F5)
	{
		return;
	}

	self.var_56F5 = 0;
}