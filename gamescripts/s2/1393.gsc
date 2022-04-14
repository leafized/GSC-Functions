/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1393.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:31 PM
*******************************************************************/

//Function Id: 0x52A4
//Function Number: 1
lib_0571::func_52A4()
{
	lib_0561::initconsumablesfromtable("insta_kill",::lib_0571::func_A218,::lib_0571::func_1F80,::lib_0571::func_4525);
}

//Function Id: 0x1F80
//Function Number: 2
lib_0571::func_1F80(param_00)
{
	if(!lib_0561::func_1F7B())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0xA218
//Function Number: 3
lib_0571::func_A218(param_00)
{
	maps/mp/gametypes/zombies::func_53DD(self,1);
}

//Function Id: 0x4525
//Function Number: 4
lib_0571::func_4525(param_00)
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