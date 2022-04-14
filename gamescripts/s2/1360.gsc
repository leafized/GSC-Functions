/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1360.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 1 ms
 * Timestamp: 8/24/2021 10:29:21 PM
*******************************************************************/

//Function Id: 0x0000
//Function Number: 1
assert_collectible_table_valid()
{
	var_00 = function_027A("mp/zombieS2CollectibleTable.csv");
}

//Function Id: 0x5543
//Function Number: 2
lib_0550::func_5543(param_00)
{
	return common_scripts\utility::func_562E(param_00.var_5543);
}

//Function Id: 0x24D4
//Function Number: 3
lib_0550::func_24D4(param_00)
{
	assert_collectible_table_valid();
	var_01 = tablelookupbyrow("mp/zombieS2CollectibleTable.csv",param_00,3);
	var_02 = tablelookupbyrow("mp/zombieS2CollectibleTable.csv",param_00,0);
	var_03 = spawnstruct();
	var_03.var_2A3C = tablelookupbyrow("mp/zombieS2CollectibleTable.csv",param_00,0);
	var_03.var_01B9 = tablelookupbyrow("mp/zombieS2CollectibleTable.csv",param_00,2);
	var_03.unlocks = strtok(var_01," ");
	var_03.var_24D1 = tablelookupbyrow("mp/zombieS2CollectibleTable.csv",param_00,1);
	var_03.var_5543 = 1;
	var_03.var_2A3C = int(var_02);
	return var_03;
}

//Function Id: 0x24D3
//Function Number: 4
lib_0550::func_24D3(param_00)
{
	assert_collectible_table_valid();
	var_01 = tablelookuprownum("mp/zombieS2CollectibleTable.csv",1,param_00);
	return lib_0550::func_24D4(var_01);
}

//Function Id: 0x4083
//Function Number: 5
lib_0550::func_4083()
{
	assert_collectible_table_valid();
	var_00 = [];
	for(var_01 = 0;var_01 < function_027A("mp/zombieS2CollectibleTable.csv");var_01++)
	{
		var_02 = lib_0550::func_24D4(var_01);
		var_00 = common_scripts\utility::func_0F6F(var_00,var_02);
	}

	return var_00;
}

//Function Id: 0x410C
//Function Number: 6
lib_0550::func_410C(param_00)
{
	var_01 = lib_0550::func_4083();
	var_02 = [];
	foreach(var_04 in var_01)
	{
		if(!lib_0550::func_415C(param_00,var_04))
		{
			continue;
		}

		var_02 = common_scripts\utility::func_0F6F(var_02,var_04);
	}

	return var_02;
}

//Function Id: 0x410D
//Function Number: 7
lib_0550::func_410D()
{
	return common_scripts\utility::func_46A8();
}

//Function Id: 0x415C
//Function Number: 8
lib_0550::func_415C(param_00,param_01)
{
	return param_00 getrankedplayerdata(lib_0550::func_410D(),"hasS2ZombieCollectibles",param_01.var_2A3C);
}

//Function Id: 0x8470
//Function Number: 9
lib_0550::func_8470(param_00,param_01,param_02)
{
	param_00 setrankedplayerdata(lib_0550::func_410D(),"hasS2ZombieCollectibles",param_01.var_2A3C,param_02);
}