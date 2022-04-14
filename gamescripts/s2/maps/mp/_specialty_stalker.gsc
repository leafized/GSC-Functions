/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _specialty_stalker.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 42 ms
 * Timestamp: 8/24/2021 10:26:52 PM
*******************************************************************/

//Function Id: 0x93B0
//Function Number: 1
func_93B0()
{
	self endon("death");
	self endon("disconnect");
	self endon("faux_spawn");
	self.var_4B45 = 0;
	for(;;)
	{
		if(!self.var_4B45)
		{
			if(self hasperk("specialty_stalker",1))
			{
				self unsetperk("specialty_stalker",1);
			}

			wait 0.05;
			continue;
		}

		if(!self hasperk("specialty_stalker",1))
		{
			self setperk("specialty_stalker",1,0);
		}

		wait 0.05;
	}
}