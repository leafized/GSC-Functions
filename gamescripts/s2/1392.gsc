/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1392.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:30 PM
*******************************************************************/

//Function Id: 0x52A4
//Function Number: 1
lib_0570::func_52A4()
{
	lib_0561::initconsumablesfromtable("full_meter",::lib_0570::func_A20D,::lib_0570::func_1F7E,::lib_0570::func_44F3);
}

//Function Id: 0x1F7E
//Function Number: 2
lib_0570::func_1F7E(param_00)
{
	if(!lib_0561::func_1F7B())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0xA20D
//Function Number: 3
lib_0570::func_A20D(param_00)
{
	maps/mp/gametypes/zombies::func_0840(self,1);
}

//Function Id: 0x44F3
//Function Number: 4
lib_0570::func_44F3(param_00)
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