/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _fmj.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 43 ms
 * Timestamp: 8/24/2021 10:26:32 PM
*******************************************************************/

//Function Id: 0x3D93
//Function Number: 1
func_3D93()
{
	self endon("death");
	self endon("disconnect");
	self endon("faux_spawn");
	self.var_4B2D = 0;
	for(;;)
	{
		if(!self.var_4B2D)
		{
			if(maps\mp\_utility::func_0649("specialty_bulletpenetration"))
			{
				maps\mp\_utility::func_0735("specialty_bulletpenetration");
				if(!maps\mp\_utility::func_0649("specialty_superbulletpenetration"))
				{
					maps\mp\_utility::func_0735("specialty_armorpiercing");
				}
			}

			wait 0.05;
			continue;
		}

		if(!maps\mp\_utility::func_0649("specialty_bulletpenetration"))
		{
			maps\mp\_utility::func_47A2("specialty_bulletpenetration");
			maps\mp\_utility::func_47A2("specialty_armorpiercing");
		}

		wait 0.05;
	}
}