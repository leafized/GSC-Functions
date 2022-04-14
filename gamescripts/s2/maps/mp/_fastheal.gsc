/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _fastheal.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 323 ms
 * Timestamp: 8/24/2021 10:26:31 PM
*******************************************************************/

//Function Id: 0xA908
//Function Number: 1
func_A908()
{
	self endon("spawned_player");
	self endon("disconnect");
	self endon("death");
	self endon("faux_spawn");
	if(!isdefined(level.var_3A58))
	{
		func_3A57();
	}

	for(;;)
	{
		self waittill("grenade_fire",var_00,var_01);
		if(var_01 == "fast_heal_mp")
		{
			if(!isalive(self))
			{
				var_00 delete();
				return;
			}

			thread func_9E29();
		}
	}
}

//Function Id: 0x3A57
//Function Number: 2
func_3A57()
{
	self.var_3A58 = spawnstruct();
}

//Function Id: 0x9E29
//Function Number: 3
func_9E29()
{
	if(!isdefined(self.var_3A58))
	{
		func_3A57();
	}

	func_7D5D();
	thread func_92CC();
	thread func_63BF();
	return 1;
}

//Function Id: 0x92CC
//Function Number: 4
func_92CC()
{
	self endon("ClearFastHeal");
	self endon("death");
	self method_8615("earn_superbonus");
	self.var_56E9 = 1;
	self.var_50A0 = 1;
	self.var_98E1 = 1.5;
	self.var_98E2 = 13.33;
	self notify("damage");
	wait(10);
	self.var_98E1 = undefined;
	self.var_98E2 = undefined;
	self.var_56E9 = 0;
	if(isdefined(self.var_3A58.var_6CA4))
	{
		self.var_3A58.var_6CA4 destroy();
	}

	self notify("EndFastHeal");
}

//Function Id: 0x7D5D
//Function Number: 5
func_7D5D()
{
	if(isdefined(self.var_56E9) && self.var_56E9 == 1)
	{
		if(isdefined(self.var_3A58.var_6CA4))
		{
			self.var_3A58.var_6CA4 destroy();
		}

		self.var_98E1 = undefined;
		self.var_98E2 = undefined;
		self notify("ClearFastHeal");
	}
}

//Function Id: 0x63BF
//Function Number: 6
func_63BF()
{
	self endon("EndFastHeal");
	self waittill("death");
	self.var_98E1 = undefined;
	self.var_98E2 = undefined;
	self.var_56E9 = 0;
	if(isdefined(self.var_3A58.var_6CA4))
	{
		self.var_3A58.var_6CA4 destroy();
	}
}

//Function Id: 0x7723
//Function Number: 7
func_7723()
{
	self endon("EndFastHeal");
	self endon("death");
	for(;;)
	{
		iprintlnbold(self.var_00BC);
		wait(1);
	}
}