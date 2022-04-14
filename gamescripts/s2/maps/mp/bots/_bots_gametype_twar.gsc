/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _bots_gametype_twar.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 11
 * Decompile Time: 533 ms
 * Timestamp: 8/24/2021 10:20:59 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	level.var_1A1B = 0;
	func_87A7();
	func_879A();
}

//Function Id: 0x87A7
//Function Number: 2
func_87A7()
{
	level.var_19D5["gametype_think"] = ::func_1B12;
	level.var_19D5["should_start_cautious_approach"] = ::func_1B11;
	if(!level.var_1A1B)
	{
		level.var_19D5["get_watch_node_chance"] = ::func_1B0D;
	}
}

//Function Id: 0x879A
//Function Number: 3
func_879A()
{
	maps/mp/bots/_bots_util::func_1B20();
	for(var_00 = 0;var_00 < level.var_9FC2.size;var_00++)
	{
		level.var_9FC2[var_00].var_81E8 = "_" + var_00;
	}

	maps/mp/bots/_bots_gametype_common::func_194F(level.var_9FC2,"zone",level.var_1A1B);
	var_01 = 55;
	var_02 = 0;
	foreach(var_04 in level.var_9FC2)
	{
		if(!isdefined(var_04.var_6638))
		{
			return;
		}

		var_04 thread func_6358();
		var_05 = var_04.var_0116 - (0,0,var_01) + var_04.var_0116 + (0,0,level.var_AC87) / 2;
		var_06 = level.var_AC87 + var_01 / 2;
		var_04.var_671A = getnodesinradius(var_05,level.var_AC8B,0,var_06);
		if(var_04.var_671A.size < 6)
		{
			var_02++;
			if(var_02 == 1)
			{
				wait(5);
				continue;
			}

			wait(1);
		}
	}

	level.var_19E8 = 1;
}

//Function Id: 0x6358
//Function Number: 4
func_6358()
{
	self notify("monitor_twar_zone_control");
	self endon("monitor_twar_zone_control");
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		wait(1);
		var_00 = self.var_0117;
		if(var_00 == "none" && level.var_9FC0.var_A22B > 0)
		{
			var_00 = level.var_9FC0.var_230F;
		}

		if(var_00 != "none")
		{
			var_01 = getzonenearest(self.var_0116);
			if(isdefined(var_01))
			{
				botzonesetteam(var_01,var_00);
			}
		}
	}
}

//Function Id: 0x1B12
//Function Number: 5
func_1B12()
{
	self notify("bot_twar_think");
	self endon("bot_twar_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("owner_disconnect");
	while(!isdefined(level.var_19E8))
	{
		wait 0.05;
	}

	self botsetflag("separation",0);
	self botsetpathingstyle("beeline");
	self botsetflag("force_sprint",1);
	for(;;)
	{
		if(!func_1B10(level.var_9FC0.var_AC7C))
		{
			func_1B0C(level.var_9FC0.var_AC7C);
		}

		wait 0.05;
	}
}

//Function Id: 0x1B0C
//Function Number: 6
func_1B0C(param_00)
{
	self.var_291F = param_00;
	var_01["entrance_points_index"] = func_1B0E(param_00);
	var_01["nearest_node_to_center"] = param_00.var_6638;
	var_01["objective_radius"] = 500;
	maps/mp/bots/_bots_strategy::func_196A(param_00.var_0116,level.var_AC8B,var_01);
}

//Function Id: 0x1B10
//Function Number: 7
func_1B10(param_00)
{
	if(maps/mp/bots/_bots_util::func_1A28())
	{
		if(self.var_291F == param_00)
		{
			return 1;
		}
	}

	return 0;
}

//Function Id: 0x1B0D
//Function Number: 8
func_1B0D(param_00)
{
	var_01 = 0;
	var_02 = func_1B0E(level.var_9FC0.var_AC7C);
	var_03 = func_1B0F(self.var_01A7);
	var_01 = 0;
	foreach(var_05 in var_03)
	{
		if(param_00 maps/mp/bots/_bots_util::func_670D(var_02,func_1B0E(var_05)))
		{
			var_01 = 1;
			break;
		}
	}

	if(var_01)
	{
		var_07 = func_1B0F(common_scripts\utility::func_416F(self.var_01A7));
		foreach(var_09 in var_07)
		{
			if(param_00 maps/mp/bots/_bots_util::func_670D(var_02,func_1B0E(var_09)))
			{
				var_01 = 0;
				break;
			}
		}
	}

	if(var_01)
	{
		return 0.2;
	}

	return 1;
}

//Function Id: 0x1B0F
//Function Number: 9
func_1B0F(param_00)
{
	var_01 = [];
	foreach(var_03 in level.var_9FC2)
	{
		if(var_03.var_0117 == param_00)
		{
			var_01[var_01.size] = var_03;
		}
	}

	return var_01;
}

//Function Id: 0x1B0E
//Function Number: 10
func_1B0E(param_00)
{
	return "zone" + param_00.var_81E8;
}

//Function Id: 0x1B11
//Function Number: 11
func_1B11(param_00)
{
	return 0;
}