/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _bots_gametype_dm.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 174 ms
 * Timestamp: 8/24/2021 10:20:37 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	func_87A7();
	func_8793();
}

//Function Id: 0x87A7
//Function Number: 2
func_87A7()
{
	level.var_19D5["gametype_think"] = ::func_19B1;
}

//Function Id: 0x8793
//Function Number: 3
func_8793()
{
}

//Function Id: 0x19B1
//Function Number: 4
func_19B1()
{
	self notify("bot_dm_think");
	self endon("bot_dm_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("owner_disconnect");
	for(;;)
	{
		self [[ self.var_6F7F ]]();
		wait 0.05;
	}
}