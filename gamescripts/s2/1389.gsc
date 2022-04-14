/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1389.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 105 ms
 * Timestamp: 8/24/2021 10:29:30 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_056D::func_00D5()
{
	while(!isdefined(level.var_947C))
	{
		waittillframeend;
	}

	if(!isdefined(level.var_AC4F))
	{
		level.var_AC4F = [];
	}

	level.var_AC11 = 0;
	level.var_4699 = [];
	level.var_1F4F = [];
	level.var_7F22 = [];
	level.var_7F18 = [];
	level.var_6889 = [];
	level.var_65C9 = [];
	level.var_64B7 = [];
	level.var_64C3 = [];
	level.var_672E = [];
	level.var_9D0E = [];
	lib_056D::func_52B5();
	level.var_ABEC = maps\mp\_utility::func_5DC8();
	level.var_ABED = maps\mp\_utility::func_5DC8();
	level.var_AC12 = maps\mp\_utility::func_5DC8();
	run_post_launch_optional_spawner_params_override();
}

//Function Id: 0x0000
//Function Number: 2
run_post_launch_optional_spawner_params_override()
{
	var_00 = common_scripts\utility::func_46B7("zmb_addon_script_parameters_override","targetname");
	var_01 = common_scripts\utility::func_46B7("zombie_spawner","script_noteworthy");
	var_02 = undefined;
	foreach(var_04 in var_00)
	{
		var_05 = common_scripts\utility::func_4461(var_04.var_0116,var_01);
		var_05.var_8260 = var_04.var_8260;
		var_06 = strtok(var_05.var_8260," ,");
		foreach(var_08 in var_06)
		{
			if(var_08 == "requireNavmesh_no")
			{
				var_05.requirenavmesh = 0;
			}
		}
	}
}

//Function Id: 0x52B5
//Function Number: 3
lib_056D::func_52B5()
{
	var_00 = "mp/zombieEnemyWaves.csv";
	if(isdefined(level.var_2986))
	{
		var_00 = level.var_2986;
	}

	var_01 = function_027A(var_00);
	var_02 = function_027B(var_00);
	var_03 = var_02 - 2;
	level.var_3774 = [];
	for(var_04 = 1;var_04 <= 4;var_04++)
	{
		level.var_3774[var_04] = [];
		for(var_05 = 1;var_05 <= var_03;var_05++)
		{
			level.var_3774[var_04][var_05] = [];
		}
	}

	for(var_05 = 1;var_05 <= var_03;var_05++)
	{
		for(var_06 = 0;var_06 < var_01;var_06++)
		{
			var_07 = tablelookupbyrow(var_00,var_06,1);
			if(isdefined(level.wavetabletypestoexclude))
			{
				if(isarray(level.wavetabletypestoexclude) && common_scripts\utility::func_0F79(level.wavetabletypestoexclude,var_07))
				{
					continue;
				}
			}

			var_04 = lib_0547::func_9470(tablelookupbyrow(var_00,var_06,0));
			var_08 = lib_0547::func_9470(tablelookupbyrow(var_00,var_06,var_05 + 1));
			if(var_08 > 0)
			{
				if(isdefined(level.var_3774[var_04][var_05][var_07]))
				{
					level.var_3774[var_04][var_05][var_07] = level.var_3774[var_04][var_05][var_07] + var_08;
					continue;
				}

				level.var_3774[var_04][var_05][var_07] = var_08;
			}
		}
	}

	level.var_3775 = var_03;
}

//Function Id: 0x4743
//Function Number: 4
lib_056D::func_4743(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		param_00 = level.var_A980;
	}

	if(!isdefined(param_01))
	{
		param_01 = level.var_744A.size;
	}

	return level.var_3774[param_01][int(min(param_00,level.var_3775))];
}

//Function Id: 0x468C
//Function Number: 5
lib_056D::func_468C()
{
	return 2;
}

//Function Id: 0x1E51
//Function Number: 6
lib_056D::func_1E51(param_00)
{
	if(isdefined(level.var_6893) && isdefined(level.var_6893[level.var_7F2A]))
	{
		return [[ level.var_6893[level.var_7F2A] ]](param_00);
	}

	return param_00;
}

//Function Id: 0xA78F
//Function Number: 7
lib_056D::func_A78F()
{
	var_00 = 0;
	while(var_00 == 0)
	{
		var_00 = 1;
		if(lib_0547::func_585E())
		{
			var_00 = 0;
			wait 0.05;
		}

		while(lib_056D::func_5867())
		{
			var_00 = 0;
			wait(0.1);
		}

		while(maps/mp/agents/_agent_utility::func_45BB() >= lib_056D::func_4577())
		{
			var_00 = 0;
			wait(0.1);
		}

		while(isdefined(level.var_ABE3) && level.var_ABE3 > 0)
		{
			var_00 = 0;
			wait(0.1);
		}
	}
}

//Function Id: 0x8A6E
//Function Number: 8
lib_056D::func_8A6E(param_00)
{
	level.var_ABE2 = param_00;
}

//Function Id: 0x5867
//Function Number: 9
lib_056D::func_5867()
{
	return common_scripts\utility::func_562E(level.var_ABE2);
}

//Function Id: 0x76A8
//Function Number: 10
lib_056D::func_76A8(param_00)
{
	var_01 = [];
	foreach(var_05, var_03 in lib_056D::func_4743(param_00))
	{
		for(var_04 = 0;var_04 < var_03;var_04++)
		{
			var_01[var_01.size] = var_05;
		}
	}

	var_01 = common_scripts\utility::func_0F92(var_01);
	return var_01;
}

//Function Id: 0x5A86
//Function Number: 11
lib_056D::func_5A86()
{
	if(isdefined(self.customrecyclehandling))
	{
		[[ self.customrecyclehandling ]]();
		return;
	}

	var_00 = spawnstruct();
	var_00.var_AC0B = self.var_0A4B;
	var_00.var_A97C = self.var_901F;
	var_00.var_3EEC = 1;
	var_00.var_6A37 = self.var_00BC;
	if(self.var_0A4B == "zombie_generic")
	{
		if(isdefined(self.var_3C70))
		{
			var_00.var_3C70 = self.var_3C70;
		}
		else
		{
			var_00.var_3C70 = self.var_90AB;
		}

		var_00.var_6A3D = self.var_0108;
		var_00.var_6A3C = self.var_6481;
		var_00.var_6A3F = self.var_A978;
		if(isdefined(self.var_1CF1))
		{
			var_00.var_6A2C = self.var_1CF1;
		}
	}

	if(maps\mp\_utility::func_585F())
	{
		if(common_scripts\utility::func_3794("zombie_passive"))
		{
			level.var_ABED maps\mp\_utility::func_5DC6(var_00);
		}
		else
		{
			level.var_ABEC maps\mp\_utility::func_5DC6(var_00);
		}
	}

	self.var_6734 = 1;
	self.var_AC10 = 1;
	self suicide();
}

//Function Id: 0x7D06
//Function Number: 12
lib_056D::func_7D06(param_00)
{
}

//Function Id: 0x7B87
//Function Number: 13
lib_056D::func_7B87(param_00)
{
	if(level.var_AC12 maps\mp\_utility::func_5DCB() == 0)
	{
		level.var_A981++;
		var_01 = level.var_A981;
		if(isdefined(param_00))
		{
			var_01 = param_00;
			level.var_A981 = param_00;
		}

		var_02 = lib_056D::func_76A8(var_01);
		foreach(var_04 in var_02)
		{
			var_05 = spawnstruct();
			var_05.var_AC0B = var_04;
			var_05.var_A97C = var_01;
			level.var_AC12 maps\mp\_utility::func_5DC6(var_05);
		}
	}
}

//Function Id: 0x66D7
//Function Number: 14
lib_056D::func_66D7()
{
	if(level.var_ABEC maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_ABEC maps\mp\_utility::func_5DC9().var_A97C;
	}

	if(level.var_ABED maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_ABED maps\mp\_utility::func_5DC9().var_A97C;
	}

	lib_056D::func_7B87();
	if(level.var_AC12 maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_AC12 maps\mp\_utility::func_5DC9().var_A97C;
	}
}

//Function Id: 0x220F
//Function Number: 15
lib_056D::func_220F()
{
	if(level.var_ABEC maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_ABEC maps\mp\_utility::func_5DCA();
	}

	if(level.var_ABED maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_ABED maps\mp\_utility::func_5DCA();
	}

	lib_056D::func_7B87();
	if(level.var_AC12 maps\mp\_utility::func_5DCB() > 0)
	{
		return level.var_AC12 maps\mp\_utility::func_5DCA();
	}
}

//Function Id: 0x7FE1
//Function Number: 16
lib_056D::func_7FE1()
{
	level.var_AC50 = 99999;
	wait 0.05;
	if(!isdefined(level.var_A981))
	{
		level.var_A981 = 0;
	}

	for(;;)
	{
		lib_056D::func_A78F();
		var_00 = 1;
		if(var_00)
		{
			if(common_scripts\utility::func_562E(level.iszombiesshotgun) && common_scripts\utility::func_562E(level.zmb_is_endless_wave))
			{
				if(lib_056D::func_66D7() > level.var_A980)
				{
					level.var_AC12 maps\mp\_utility::func_5DC7();
					lib_056D::func_7B87(level.var_A980);
				}
			}
			else
			{
				while(lib_056D::func_66D7() > level.var_A980)
				{
					wait(0.2);
				}

				lib_056D::func_A78F();
			}
		}

		var_01 = lib_056D::func_220F();
		if(!isdefined(var_01))
		{
			wait(1);
			continue;
		}

		var_02 = 0;
		var_03 = var_01.var_AC0B;
		var_04 = undefined;
		if(isdefined(var_01.var_3EEC))
		{
			var_04 = spawnstruct();
			var_04.var_6A37 = var_01.var_6A37;
			if(var_03 == "zombie_generic")
			{
				var_04.var_3C70 = var_01.var_3C70;
				var_04.var_6A3C = var_01.var_6A3C;
				var_04.var_6A3D = var_01.var_6A3D;
				var_04.var_6A3F = var_01.var_6A3F;
				if(isdefined(var_01.var_6A2C))
				{
					var_04.var_6A2C = var_01.var_6A2C;
				}
			}
		}

		if(isdefined(level.var_1CC0))
		{
			var_03 = common_scripts\utility::func_7A33(level.var_1CC0);
		}

		if(should_override_follower_spawn(isdefined(var_01.var_3EEC),var_03))
		{
			if(maps\mp\_utility::func_4571() == "mp_zombie_house")
			{
				var_03 = "zombie_generic";
			}
			else
			{
				var_03 = common_scripts\utility::func_7A33(["zombie_exploder","zombie_berserker","zombie_berserker"]);
			}
		}

		if(lib_0547::func_0796())
		{
			var_06 = 0;
			var_07 = 0;
			foreach(var_09 in level.var_744A)
			{
				if(isalive(var_09) && !common_scripts\utility::func_562E(var_09.var_5728))
				{
					var_06++;
				}

				if(common_scripts\utility::func_562E(var_09.var_5579))
				{
					var_07++;
				}
			}

			if(var_07 == var_06 && lib_0547::func_4254() >= 5)
			{
				var_0B = undefined;
			}
			else
			{
				var_0C = lib_0547::func_7A37();
				var_0B = lib_055A::func_4696(var_03,0,0,var_0C.var_38C2);
			}
		}
		else if(isdefined(level.zmb_locked_spawn_zones))
		{
			var_09 = lib_055A::func_4696(var_07,0,0,common_scripts\utility::func_7A33(level.zmb_locked_spawn_zones));
		}
		else
		{
			var_09 = undefined;
		}

		for(;;)
		{
			var_0A = lib_054D::func_90BA(var_07,var_09,"wave system",1,0,1,undefined,var_06,var_0D.var_A97C,var_08);
			if(!isdefined(level.zm_shotgun_health_mod))
			{
				level.zm_shotgun_health_mod = getdvarfloat("spv_zm_shotgun_health_mod",1);
			}

			if(isdefined(var_0A) && getdvarint("spv_zm_difficulty_enabled") == 1)
			{
				var_0E = int(var_0A.var_00FB * level.zm_shotgun_health_mod);
				var_0A.var_00FB = var_0E;
				var_0A.var_00BC = var_0A.var_00FB;
			}

			if(isdefined(var_0A))
			{
				break;
			}
			else if(isdefined(level.zmb_locked_spawn_zones))
			{
				var_09 = lib_055A::func_4696(var_07,0,0,common_scripts\utility::func_7A33(level.zmb_locked_spawn_zones));
			}

			wait 0.05;
		}

		wait(lib_056D::func_1E56());
	}
}

//Function Id: 0x0000
//Function Number: 17
should_override_follower_spawn(param_00,param_01)
{
	if(level.var_744A.size == 1)
	{
		var_02 = 2;
	}
	else if(level.var_744A.size == 2)
	{
		var_02 = 3;
	}
	else
	{
		var_02 = 4;
	}

	if(param_00)
	{
		return 0;
	}

	if(lib_0547::func_4090("zombie_heavy").size < var_02)
	{
		return 0;
	}

	if(!lib_0547::func_5565(param_01,"zombie_heavy"))
	{
		return 0;
	}

	return 1;
}

//Function Id: 0x4577
//Function Number: 18
lib_056D::func_4577()
{
	var_00 = 24;
	var_01 = 18;
	return var_01;
}

//Function Id: 0xA6DC
//Function Number: 19
lib_056D::func_A6DC(param_00)
{
	while(!lib_056D::func_584C(param_00))
	{
		wait(0.5);
	}
}

//Function Id: 0x584C
//Function Number: 20
lib_056D::func_584C(param_00)
{
	if(lib_0547::func_585E())
	{
		return 0;
	}

	if(isdefined(level.zmb_force_ended_wave))
	{
		if(level.zmb_force_ended_wave != param_00)
		{
			level.zmb_force_ended_wave = undefined;
			return 0;
		}
		else
		{
			level.zmb_force_ended_wave = undefined;
			return 1;
		}
	}

	if(common_scripts\utility::func_562E(level.zmb_is_endless_wave))
	{
		return 0;
	}

	if(level.var_6F43 > 0)
	{
		return 0;
	}

	if(!isdefined(level.var_A981) || level.var_A981 <= param_00)
	{
		return 0;
	}

	foreach(var_02 in maps/mp/agents/_agent_utility::func_43FD("all"))
	{
		if(common_scripts\utility::func_562E(var_02.var_6816))
		{
			continue;
		}

		if(var_02.var_901F <= param_00)
		{
			return 0;
		}
	}

	foreach(var_05 in level.var_ABEC maps\mp\_utility::func_5DCC())
	{
		if(var_05.var_A97C <= param_00)
		{
			return 0;
		}
	}

	foreach(var_05 in level.var_ABED maps\mp\_utility::func_5DCC())
	{
		if(var_05.var_A97C <= param_00)
		{
			return 0;
		}
	}

	level.zmb_force_ended_wave = undefined;
	return 1;
}

//Function Id: 0x45C2
//Function Number: 21
lib_056D::func_45C2()
{
	var_00 = maps/mp/agents/_agent_utility::func_43FD("all");
	var_01 = 0;
	foreach(var_03 in var_00)
	{
		if(var_03.var_01A7 == level.var_3772)
		{
			var_01++;
		}
	}

	return var_01;
}

//Function Id: 0x1E56
//Function Number: 22
lib_056D::func_1E56()
{
	if(isdefined(level.overridespawndelay))
	{
		return level.overridespawndelay;
	}

	if(isdefined(level.zombieslevelspawndelayfunc))
	{
		return [[ level.zombieslevelspawndelayfunc ]](level.var_A980);
	}

	return lib_056D::func_957F(level.var_A980);
}

//Function Id: 0x957C
//Function Number: 23
lib_056D::func_957C(param_00)
{
	if(param_00 <= 11)
	{
		return 0;
	}

	if(param_00 > 30)
	{
		return 0.05;
	}
	else if(param_00 > 25)
	{
		return 0.04;
	}
	else if(param_00 > 15)
	{
		return 0.03;
	}
	else
	{
		return 0.02;
	}

	return 0;
}

//Function Id: 0x957B
//Function Number: 24
lib_056D::func_957B(param_00,param_01)
{
	var_02 = param_00;
	if(param_01 < 2)
	{
		var_02 = int(param_00 * 0.25);
	}
	else if(param_01 < 3)
	{
		var_02 = int(param_00 * 0.3);
	}
	else if(param_01 < 4)
	{
		var_02 = int(param_00 * 0.5);
	}
	else if(param_01 < 5)
	{
		var_02 = int(param_00 * 0.7);
	}
	else if(param_01 < 6)
	{
		var_02 = int(param_00 * 0.9);
	}

	return var_02;
}

//Function Id: 0x957D
//Function Number: 25
lib_056D::func_957D(param_00,param_01)
{
	var_02 = 24;
	var_03 = 6;
	var_04 = param_00 / 5;
	if(var_04 < 1)
	{
		var_04 = 1;
	}

	if(param_00 >= 10)
	{
		var_04 = var_04 * param_00 * 0.15;
	}

	if(param_01 == 1)
	{
		var_02 = var_02 + int(0.5 * var_03 * var_04);
	}
	else
	{
		var_02 = var_02 + int(param_01 - 1 * var_03 * var_04);
	}

	var_05 = lib_056D::func_957B(var_02,param_00);
	return var_05;
}

//Function Id: 0x957F
//Function Number: 26
lib_056D::func_957F(param_00)
{
	if(param_00 < 2)
	{
		return 3;
	}

	if(param_00 < 5)
	{
		return 2;
	}

	if(param_00 > 60)
	{
		param_00 = 60;
	}

	var_01 = 0.95;
	var_02 = 0;
	switch(level.var_744A.size)
	{
		case 1:
			var_02 = 2;
			break;

		case 2:
			var_02 = 1.5;
			break;

		case 3:
			var_02 = 0.89;
			break;

		case 4:
			var_02 = 0.67;
			break;
	}

	for(var_03 = 1;var_03 < param_00;var_03++)
	{
		var_02 = var_02 * var_01;
		if(var_02 <= 0.1)
		{
			var_02 = 0.1;
			break;
		}
	}

	return var_02;
}