/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _bots_gametype_dogfight.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 123 ms
 * Timestamp: 8/24/2021 10:20:37 PM
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
	level.var_19D5["gametype_think"] = ::bot_dogfight_think;
}

//Function Id: 0x0000
//Function Number: 3
bot_dogfight_think()
{
}