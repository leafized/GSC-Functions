/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1390.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:30 PM
*******************************************************************/

//Function Id: 0x52A4
//Function Number: 1
lib_056E::func_52A4()
{
	lib_0561::func_52A5("attack_dogs","Attack Dogs",::lib_056E::func_A1FA,::lib_056E::func_1F2D,::lib_056E::func_4423);
	level thread maps\mp\killstreaks\_dog_killstreak::func_00D5();
}

//Function Id: 0x1F2D
//Function Number: 2
lib_056E::func_1F2D()
{
	return 1;
}

//Function Id: 0xA1FA
//Function Number: 3
lib_056E::func_A1FA()
{
	self method_8615("zmb_pickup_general");
	thread maps\mp\killstreaks\_dog_killstreak::func_9E26();
}

//Function Id: 0x4423
//Function Number: 4
lib_056E::func_4423(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = "";
	}

	switch(param_00)
	{
		case "epic":
			return 4;

		case "legendary":
			return 3;

		case "rare":
			return 2;

		case "common":
			return 1;

		default:
			return 0;
	}
}