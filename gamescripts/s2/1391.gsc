/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1391.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:30 PM
*******************************************************************/

//Function Id: 0x52A4
//Function Number: 1
lib_056F::func_52A4()
{
	lib_0561::initconsumablesfromtable("double_points",::lib_056F::func_A208,::lib_056F::func_1F7D,::lib_056F::func_44A8);
}

//Function Id: 0x1F7D
//Function Number: 2
lib_056F::func_1F7D(param_00)
{
	if(!lib_0561::func_1F7B())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0xA208
//Function Number: 3
lib_056F::func_A208(param_00)
{
	maps/mp/gametypes/zombies::func_32C8(self,1);
}

//Function Id: 0x44A8
//Function Number: 4
lib_056F::func_44A8(param_00)
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