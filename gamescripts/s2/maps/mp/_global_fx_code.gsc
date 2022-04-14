/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _global_fx_code.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 42 ms
 * Timestamp: 8/24/2021 10:26:33 PM
*******************************************************************/

//Function Id: 0x47DC
//Function Number: 1
func_47DC(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = common_scripts\utility::func_46B7(param_00,"targetname");
	if(var_05.size <= 0)
	{
		return;
	}

	if(!isdefined(param_02))
	{
		param_02 = randomfloatrange(-20,-15);
	}

	if(!isdefined(param_03))
	{
		param_03 = param_01;
	}

	foreach(var_07 in var_05)
	{
		if(!isdefined(level.var_0611))
		{
			level.var_0611 = [];
		}

		if(!isdefined(level.var_0611[param_03]))
		{
			level.var_0611[param_03] = loadfx(param_01);
		}

		if(!isdefined(var_07.var_001D))
		{
			var_07.var_001D = (0,0,0);
		}

		var_08 = common_scripts\utility::func_281B(param_03);
		var_08.var_A265["origin"] = var_07.var_0116;
		var_08.var_A265["angles"] = var_07.var_001D;
		var_08.var_A265["fxid"] = param_03;
		var_08.var_A265["delay"] = param_02;
		if(isdefined(param_04))
		{
			var_08.var_A265["soundalias"] = param_04;
		}
	}
}