/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1369.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 5 ms
 * Timestamp: 8/24/2021 10:29:23 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_0559::func_00D5()
{
	level.var_AC0C = [];
	level.var_47DD = [];
	for(var_00 = 0;var_00 < 4;var_00++)
	{
		var_01 = spawnstruct();
		var_01.var_4DBA = 0;
		var_01.var_2900 = undefined;
		var_01.var_A902 = [];
		level.var_AC0C = common_scripts\utility::func_0F6F(level.var_AC0C,var_01);
	}

	level thread lib_0559::func_A1D1();
}

//Function Id: 0xA1D1
//Function Number: 2
lib_0559::func_A1D1()
{
	for(;;)
	{
		level waittill("connected",var_00);
		level thread lib_0559::func_A154(var_00);
	}
}

//Function Id: 0x7C03
//Function Number: 3
lib_0559::func_7C03(param_00,param_01,param_02)
{
	return lib_0559::func_7C02(param_00,1,param_02,param_01);
}

//Function Id: 0x7BE2
//Function Number: 4
lib_0559::func_7BE2(param_00,param_01,param_02)
{
	return lib_0559::func_7C02(param_00,2,param_02,param_01);
}

//Function Id: 0x7BE3
//Function Number: 5
lib_0559::func_7BE3(param_00,param_01,param_02)
{
	var_03 = lib_0559::func_280D(2,param_01,param_00,param_02);
	level.var_47DD = common_scripts\utility::func_0F6F(level.var_47DD,var_03);
	level thread maps\mp\_utility::func_6F74(::lib_0559::func_09E3,var_03,param_02);
	return var_03;
}

//Function Id: 0x280D
//Function Number: 6
lib_0559::func_280D(param_00,param_01,param_02,param_03)
{
	var_04 = spawnstruct();
	var_04.var_7B79 = param_01;
	var_04.var_01B9 = param_00;
	var_04.var_9D65 = param_02;
	var_04.var_6642 = 0;
	var_04.var_2F74 = 0;
	if(isdefined(param_03))
	{
		var_04.var_5A16 = param_03;
	}

	return var_04;
}

//Function Id: 0x09E3
//Function Number: 7
lib_0559::func_09E3(param_00)
{
	var_01 = self getentitynumber();
	var_02 = level.var_AC0C[var_01];
	var_02.var_A902 = common_scripts\utility::func_0F6F(var_02.var_A902,param_00);
}

//Function Id: 0x7C02
//Function Number: 8
lib_0559::func_7C02(param_00,param_01,param_02,param_03)
{
	var_04 = lib_0559::func_280D(param_01,param_02,param_03);
	param_00 lib_0559::func_09E3(var_04);
	return var_04;
}

//Function Id: 0x2D8F
//Function Number: 9
lib_0559::func_2D8F(param_00,param_01)
{
	var_02 = param_00 getentitynumber();
	var_03 = level.var_AC0C[var_02];
	var_03.var_A902 = common_scripts\utility::func_0F93(var_03.var_A902,param_01);
}

//Function Id: 0x2D8E
//Function Number: 10
lib_0559::func_2D8E(param_00)
{
	foreach(var_02 in level.var_744A)
	{
		lib_0559::func_2D8F(var_02,param_00);
	}

	if(isdefined(param_00.var_5A16))
	{
		level notify(param_00.var_5A16);
	}
}

//Function Id: 0x8655
//Function Number: 11
lib_0559::func_8655(param_00,param_01)
{
	var_02 = tablelookuprownum("mp/zombieHintTable.csv",2,param_01.var_7B79);
	if(var_02 == -1)
	{
		return;
	}

	var_03 = int(tablelookupbyrow("mp/zombieHintTable.csv",var_02,0));
	var_04 = int(tablelookupbyrow("mp/zombieHintTable.csv",var_02,1));
	var_05 = var_04 << 4 + var_03;
	param_00 setclientomnvar("ui_zm_contexthint_data",var_05);
	param_01.var_6642 = 0;
}

//Function Id: 0xA154
//Function Number: 12
lib_0559::func_A154(param_00)
{
	param_00 endon("disconnect");
	var_01 = param_00 getentitynumber();
	var_02 = level.var_AC0C[var_01];
	for(;;)
	{
		if(isdefined(var_02.var_2900) && !isdefined(var_02.var_2900.var_9D65))
		{
			lib_0559::func_2D8F(param_00,var_02.var_2900);
			if(var_02.var_4DBA)
			{
				var_02.var_4DBA = 0;
				var_02.var_2900 = undefined;
				param_00 setclientomnvar("ui_zm_contexthint_data",0);
			}

			wait(0.2);
			continue;
		}

		if(var_02.var_4DBA)
		{
			if(!isdefined(var_02.var_2900.var_9D65) || !param_00 istouching(var_02.var_2900.var_9D65) || var_02.var_2900.var_2F74)
			{
				var_02.var_4DBA = 0;
				var_02.var_2900 = undefined;
				param_00 setclientomnvar("ui_zm_contexthint_data",0);
			}
			else if(var_02.var_2900.var_6642)
			{
				lib_0559::func_8655(param_00,var_02.var_2900);
			}
		}
		else
		{
			var_03 = var_02.var_A902.size;
			for(var_01 = 0;var_01 < var_03;var_01++)
			{
				var_04 = var_02.var_A902[var_01];
				if(!var_04.var_2F74 && isdefined(var_04.var_9D65) && param_00 istouching(var_04.var_9D65))
				{
					var_02.var_4DBA = 1;
					var_02.var_2900 = var_04;
					lib_0559::func_8655(param_00,var_04);
				}
			}
		}

		wait(0.2);
	}
}