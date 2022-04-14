/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _agents_gametype_hp.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 82 ms
 * Timestamp: 8/24/2021 10:20:13 PM
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
	level.var_0A41["player"]["think"] = ::maps/mp/bots/_bots_gametype_hp::func_1A1A;
}