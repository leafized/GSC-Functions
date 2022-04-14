/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1396.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 1 ms
 * Timestamp: 8/24/2021 10:29:31 PM
*******************************************************************/

//Function Id: 0x52A4
//Function Number: 1
lib_0574::func_52A4()
{
	lib_0561::initconsumablesfromtable("nuke",::lib_0574::func_A221,::lib_0574::func_1F83,::lib_0574::func_45BA);
}

//Function Id: 0x1F83
//Function Number: 2
lib_0574::func_1F83(param_00)
{
	if(!lib_0561::func_1F7B())
	{
		return 0;
	}

	return 1;
}

//Function Id: 0xA221
//Function Number: 3
lib_0574::func_A221(param_00)
{
	maps/mp/gametypes/zombies::func_685F(self,1);
}

//Function Id: 0x45BA
//Function Number: 4
lib_0574::func_45BA(param_00)
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