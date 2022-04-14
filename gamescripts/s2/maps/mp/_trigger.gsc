/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _trigger.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 98 ms
 * Timestamp: 8/24/2021 10:26:58 PM
*******************************************************************/

//Function Id: 0x41FC
//Function Number: 1
func_41FC()
{
	var_00 = common_scripts\_trigger::func_4323();
	var_01 = [];
	var_01["trigger_multiple_spawn_once"] = ::maps\mp\_stop_current_floodspawner::func_9DB1;
	var_01["trigger_multiple_spawn_flood"] = ::maps\mp\_stop_current_floodspawner::func_9D7C;
	var_01 = common_scripts\utility::func_0F76(var_01,var_00);
	return var_01;
}

//Function Id: 0x5258
//Function Number: 2
func_5258()
{
	var_00 = func_41FC();
	var_01 = [];
	foreach(var_05, var_03 in var_00)
	{
		var_04 = getentarray(var_05,"classname");
		common_scripts\utility::func_0F8A(var_04,var_03);
		var_01 = common_scripts\utility::func_0F73(var_01,var_04);
	}

	var_04 = [];
	var_06 = ["trigger_multiple","trigger_once","trigger_radius","trigger_disk","trigger_hurt","trigger_damage","trigger_use"];
	foreach(var_08 in var_06)
	{
		var_09 = getentarray(var_08,"code_classname");
		var_04 = common_scripts\utility::func_0F8C(var_04,var_09);
	}

	var_0B = common_scripts\utility::func_0F7D(var_04,var_01);
	var_0C = [];
	foreach(var_0E in var_0B)
	{
		var_0F = 0;
		foreach(var_08 in var_06)
		{
			if(var_0E.var_003A == var_08)
			{
				var_0F = 1;
				break;
			}
		}

		if(!var_0F)
		{
			foreach(var_08 in var_0C)
			{
				if(var_0E.var_003A == var_08 || issubstr(var_0E.var_003A,var_08))
				{
					var_0F = 1;
					break;
				}
			}
		}

		if(var_0F)
		{
			var_0B = common_scripts\utility::func_0F93(var_0B,var_0E);
		}
	}

	if(isdefined(var_0B) && var_0B.size > 0)
	{
		foreach(var_0E in var_0B)
		{
		}
	}

	for(var_17 = 0;var_17 < var_04.size;var_17++)
	{
		if(isdefined(var_04[var_17].var_81A1))
		{
			level thread common_scripts\_trigger::func_9DAC(var_04[var_17]);
		}

		if(isdefined(var_04[var_17].var_819E))
		{
			level thread common_scripts\_trigger::func_9DAB(var_04[var_17]);
		}

		if(isdefined(var_04[var_17].var_82BE))
		{
			var_04[var_17] thread common_scripts\_trigger::func_9D85();
		}

		if(isdefined(var_04[var_17].var_8272))
		{
			var_04[var_17].var_8186 = var_04[var_17].var_8272;
		}
	}
}