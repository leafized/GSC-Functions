/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _agents_gametype_demo.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 131 ms
 * Timestamp: 8/24/2021 10:20:11 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	func_87A7();
}

//Function Id: 0x87A7
//Function Number: 2
func_87A7()
{
	level.var_0A41["player"]["think"] = ::func_0A46;
}

//Function Id: 0x0A46
//Function Number: 3
func_0A46()
{
	common_scripts\utility::func_0615();
	foreach(var_01 in level.var_1913)
	{
		var_01.var_9D65 enableplayeruse(self);
	}

	thread maps/mp/bots/_bots_gametype_sd::func_1AC0();
}