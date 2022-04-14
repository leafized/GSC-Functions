/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 766.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 2 ms
 * Timestamp: 8/24/2021 10:29:44 PM
*******************************************************************/

//Function Id: 0x8CCC
//Function Number: 1
lib_02FE::func_8CCC(param_00,param_01)
{
	return 1;
}

//Function Id: 0x8CCB
//Function Number: 2
lib_02FE::func_8CCB(param_00,param_01)
{
	return gettime() - param_01 * 0.001 >= param_00;
}

//Function Id: 0x8CC0
//Function Number: 3
lib_02FE::func_8CC0(param_00)
{
	if(isdefined(level.var_9321))
	{
		return level.var_9321[param_00];
	}
}

//Function Id: 0x8CBE
//Function Number: 4
lib_02FE::func_8CBE(param_00)
{
	var_01 = spawnstruct();
	var_01.var_9320 = param_00;
	var_01.var_9328 = [];
	level.var_9321[param_00] = var_01;
	return var_01;
}

//Function Id: 0x8CBB
//Function Number: 5
lib_02FE::func_8CBB(param_00)
{
	var_01 = spawnstruct();
	var_01.var_9322 = param_00;
	var_01.var_9C6B = [];
	self.var_9328[param_00] = var_01;
}

//Function Id: 0x8CBC
//Function Number: 6
lib_02FE::func_8CBC(param_00,param_01,param_02,param_03)
{
	var_04 = lib_02FE::func_071C(param_00);
	var_04.var_9C6B[var_04.var_9C6B.size] = [param_01,param_02,param_03];
}

//Function Id: 0x8CB9
//Function Number: 7
lib_02FE::func_8CB9(param_00,param_01,param_02)
{
	var_03 = lib_02FE::func_071C(param_00);
	var_03.var_37B2 = param_01;
	var_03.var_37B3 = param_02;
}

//Function Id: 0x8CBD
//Function Number: 8
lib_02FE::func_8CBD(param_00,param_01,param_02)
{
	var_03 = lib_02FE::func_071C(param_00);
	var_03.var_A0A7 = param_01;
	var_03.var_A0A8 = param_02;
}

//Function Id: 0x8CBA
//Function Number: 9
lib_02FE::func_8CBA(param_00,param_01,param_02)
{
	var_03 = lib_02FE::func_071C(param_00);
	var_03.var_38E9 = param_01;
	var_03.var_38EA = param_02;
}

//Function Id: 0x071C
//Function Number: 10
lib_02FE::func_071C(param_00)
{
	var_01 = self.var_9328[param_00];
	return var_01;
}

//Function Id: 0x071B
//Function Number: 11
lib_02FE::func_071B(param_00,param_01,param_02)
{
	foreach(var_04 in param_01.var_9C6B)
	{
		var_05 = var_04[0];
		var_06 = var_04[1];
		var_07 = var_04[2];
		if(self [[ var_06 ]](var_07,param_02))
		{
			return var_05;
		}
	}

	return undefined;
}

//Function Id: 0x8CBF
//Function Number: 12
lib_02FE::func_8CBF(param_00,param_01)
{
	if(isdefined(param_01))
	{
		self endon("death");
	}

	var_02 = lib_02FE::func_8CC0(param_00);
	self.var_28CD = getfirstarraykey(var_02.var_9328);
	var_03 = var_02.var_9328[self.var_28CD];
	var_04 = gettime();
	if(isdefined(var_03.var_37B2))
	{
		self [[ var_03.var_37B2 ]](var_03.var_37B3);
	}

	for(;;)
	{
		var_05 = lib_02FE::func_071B(var_02,var_03,var_04);
		if(isdefined(var_05))
		{
			self notify("sm_state_change");
			if(isdefined(var_03.var_38E9))
			{
				self [[ var_03.var_38E9 ]](var_03.var_38EA);
			}

			if(var_05 == "")
			{
				return;
			}

			self.var_28CD = var_05;
			var_03 = var_02.var_9328[var_05];
			var_04 = gettime();
			if(isdefined(var_03.var_37B2))
			{
				self [[ var_03.var_37B2 ]](var_03.var_37B3);
			}

			continue;
		}

		if(isdefined(var_03.var_A0A7))
		{
			self [[ var_03.var_A0A7 ]](var_03.var_A0A8,var_04);
		}

		wait 0.05;
	}
}