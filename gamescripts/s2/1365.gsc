/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1365.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 1 ms
 * Timestamp: 8/24/2021 10:29:22 PM
*******************************************************************/

//Function Id: 0x531F
//Function Number: 1
lib_0555::func_531F()
{
}

//Function Id: 0x83DD
//Function Number: 2
lib_0555::func_83DD(param_00,param_01,param_02,param_03)
{
	var_04 = tablelookuprownum("mp/zombieNotificationTable.csv",1,param_00);
	if(var_04 != -1)
	{
		var_05 = int(tablelookupbyrow("mp/zombieNotificationTable.csv",var_04,0));
		var_06 = -1;
		var_07 = int(tablelookupbyrow("mp/zombieNotificationTable.csv",var_04,11));
		if(isdefined(var_07) && var_07 == 1 && isplayer(param_01))
		{
			param_01.interactneedrelease = 1;
		}

		if(isdefined(param_01))
		{
			if(isplayer(param_01))
			{
				var_06 = param_01 getentitynumber();
			}
			else if(function_02A2(param_01))
			{
				var_06 = param_01;
			}
		}

		if(isdefined(param_03))
		{
			function_0327(&"zm_player_notification",4,var_05,var_06,param_02,param_03);
			return;
		}

		if(isdefined(param_02))
		{
			function_0327(&"zm_player_notification",3,var_05,var_06,param_02);
			return;
		}

		function_0226(&"zm_player_notification",2,var_05,var_06);
		return;
	}
}