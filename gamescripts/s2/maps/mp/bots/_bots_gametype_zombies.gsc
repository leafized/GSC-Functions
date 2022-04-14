/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _bots_gametype_zombies.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 166 ms
 * Timestamp: 8/24/2021 10:21:01 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
func_00F9()
{
	func_87A7();
	func_879C();
}

//Function Id: 0x87A7
//Function Number: 2
func_87A7()
{
	level.var_19D5["gametype_think"] = ::func_1B2E;
}

//Function Id: 0x879C
//Function Number: 3
func_879C()
{
	level.var_1B3E = 1;
	level.var_1B3F = 1;
}

//Function Id: 0x1B2E
//Function Number: 4
func_1B2E()
{
	self notify("bot_zombies_think");
	self endon("bot_zombies_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		if(self method_8368() != "run_and_gun")
		{
			maps/mp/bots/_bots_util::func_1AD5("run_and_gun");
		}

		if(!isdefined(self.var_19A1))
		{
			var_00 = 9999;
			var_01 = undefined;
			foreach(var_03 in level.var_744A)
			{
				if(isbot(var_03))
				{
					continue;
				}

				if(!isdefined(var_03.var_489E))
				{
					var_03.var_489E = 0;
				}

				if(var_03.var_489E < var_00)
				{
					var_00 = var_03.var_489E;
					var_01 = var_03;
				}
			}

			if(isdefined(var_01))
			{
				thread maps/mp/bots/_bots_strategy::func_1A0C(var_01,800);
				var_01.var_489E++;
			}
		}

		self [[ self.var_6F7F ]]();
		wait 0.05;
	}
}