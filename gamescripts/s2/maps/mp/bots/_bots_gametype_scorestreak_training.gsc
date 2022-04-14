/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _bots_gametype_scorestreak_training.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 148 ms
 * Timestamp: 8/24/2021 10:20:55 PM
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
	level.var_19D5["gametype_think"] = ::func_1ABC;
}

//Function Id: 0x1ABC
//Function Number: 3
func_1ABC()
{
	self notify("bot_scorestreak_training_think");
	self endon("bot_scorestreak_training_think");
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