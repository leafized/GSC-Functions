/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1388.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 2 ms
 * Timestamp: 8/24/2021 10:29:29 PM
*******************************************************************/

//Function Id: 0xA9CE
//Function Number: 1
lib_056C::func_A9CE()
{
	level.var_A9CC = ::lib_056C::func_4735;
}

//Function Id: 0x0000
//Function Number: 2
getattachmentforzombieweapon(param_00,param_01)
{
	if(!isdefined(param_01) || !isstring(param_01) || param_01 == "")
	{
		return undefined;
	}

	var_02 = function_0060(param_00);
	foreach(var_04 in var_02)
	{
		if(issubstr(var_04,param_01))
		{
			return var_04;
		}
	}

	return undefined;
}

//Function Id: 0x4735
//Function Number: 3
lib_056C::func_4735(param_00,param_01)
{
	if(param_01 == "none")
	{
		return;
	}

	if(!issubstr(param_01,"_zm"))
	{
		return;
	}

	var_02 = lib_0547::func_AAF9(param_01);
	var_03 = lib_0547::func_9475(var_02) + "_mp";
	if(!maps/mp/zombies/zombie_weapon_kits_shared::func_5842(var_03))
	{
		return;
	}

	var_04 = maps/mp/zombies/zombie_weapon_kits_shared::getweaponkitmp(param_00,var_03);
	var_05 = [];
	foreach(var_07 in var_04.var_114C)
	{
		var_08 = getzombieattachmentoverrideguid(var_07,param_01);
		if(isdefined(var_08))
		{
			var_05[var_05.size] = var_08;
		}
	}

	var_04.var_114C = var_05;
	return var_04;
}

//Function Id: 0x0000
//Function Number: 4
getzombieattachmentoverrideguid(param_00,param_01)
{
	var_02 = maps\mp\_utility::func_452B(param_00);
	if(!isdefined(var_02))
	{
		return undefined;
	}

	var_03 = getattachmentforzombieweapon(param_01,var_02);
	if(!isdefined(var_03))
	{
		return undefined;
	}

	return maps\mp\_utility::func_452A(var_03);
}

//Function Id: 0x0000
//Function Number: 5
weaponkitsgetvalidbaseweaponrefmp(param_00)
{
	if(param_00 == "none")
	{
		return;
	}

	if(!issubstr(param_00,"_zm"))
	{
		return;
	}

	var_01 = lib_0547::func_AAF9(param_00);
	var_02 = lib_0547::func_9475(var_01) + "_mp";
	if(!maps/mp/zombies/zombie_weapon_kits_shared::func_5842(var_02))
	{
		return;
	}

	return var_02;
}

//Function Id: 0x0000
//Function Number: 6
getzombiepaintjob(param_00,param_01)
{
	var_02 = lib_0547::func_AAF9(param_01,0,0);
	if(var_02 == "none")
	{
		return 0;
	}

	var_03 = function_02FF(var_02,"_zm") + "_mp";
	if(!maps/mp/zombies/zombie_weapon_kits_shared::func_5842(var_03))
	{
		return 0;
	}

	var_04 = lib_0547::func_AAF9(param_01,0,1);
	var_05 = function_02FF(var_04,"_zm") + "_mp";
	var_06 = getitemguidfromref(var_05);
	var_07 = param_00 getrankedplayerdata(common_scripts\utility::func_46A8(),"weaponBuildKits",var_03,"weapon");
	if(var_07 == 0)
	{
		var_07 = var_06;
	}

	var_08 = getitemreffromguid(var_07);
	if(var_05 != var_08)
	{
		return 0;
	}

	var_0A = param_00 getrankedplayerdata(common_scripts\utility::func_46A8(),"weaponBuildKits",var_03,"paintjob");
	return var_0A;
}