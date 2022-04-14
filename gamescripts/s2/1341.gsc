/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1341.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 2 ms
 * Timestamp: 8/24/2021 10:29:17 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_053D::func_00D5()
{
	level.var_AC18 = common_scripts\utility::func_46B7("zombie_debris","targetname");
	common_scripts\utility::func_0FB2(level.var_AC18,::lib_053D::func_51B0);
}

//Function Id: 0x51B0
//Function Number: 2
lib_053D::func_51B0()
{
	var_00 = getentarray(self.var_01A2,"targetname");
	self.var_17E7 = [];
	self.var_9DC2 = [];
	self.var_267B = self.var_8140;
	foreach(var_02 in var_00)
	{
		wait 0.05;
		switch(var_02.var_0165)
		{
			case "zombies_debris_blocker":
				self.var_17E7 = common_scripts\utility::func_0F6F(self.var_17E7,var_02);
				break;

			case "zombies_debris_trigger":
				self.var_9DC2 = common_scripts\utility::func_0F6F(self.var_9DC2,var_02);
				var_02.var_267B = self.var_267B;
				var_02.var_7778 = lib_0552::func_7BDD(var_02);
				var_02.var_7778.var_3259 = self.var_267B;
				break;
		}
	}

	foreach(var_05 in self.var_9DC2)
	{
		var_05 thread lib_053D::func_11BA(self);
	}

	self waittill("debris_purchased",var_07);
	if(isdefined(self.var_819A))
	{
		common_scripts\utility::func_3C8F(self.var_819A,var_07);
	}

	foreach(var_09 in self.var_17E7)
	{
		if(var_09.var_003A != "script_model")
		{
			var_09 method_8060();
		}

		var_09 notsolid();
		var_09 delete();
	}

	foreach(var_09 in self.var_9DC2)
	{
		var_09 common_scripts\utility::func_9D9F();
	}
}

//Function Id: 0x11BA
//Function Number: 3
lib_053D::func_11BA(param_00)
{
	self notify("start_attempt_debris_purchase");
	self endon("start_attempt_debris_purchase");
	var_01 = 0;
	var_02 = undefined;
	if(lib_0547::func_5565(self.var_81A1,"requires_power"))
	{
		self.var_3276 = spawnstruct();
		self.var_3276.var_81A1 = "power_sz2";
	}

	while(!var_01)
	{
		self waittill("trigger",var_02);
		if(lib_0547::func_5565(self.var_81A1,"requires_power") && !common_scripts\utility::func_3C77("power_sz2"))
		{
			var_02 iclientprintlnbold("requires power!");
			continue;
		}

		var_01 = var_02 maps/mp/gametypes/zombies::func_11C2(param_00.var_267B);
	}

	param_00 notify("debris_purchased",var_02);
}