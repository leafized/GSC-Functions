/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1331.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 19
 * Decompile Time: 29 ms
 * Timestamp: 8/24/2021 10:29:14 PM
*******************************************************************/

//Function Id: 0x7BCE
//Function Number: 1
lib_0533::func_7BCE(param_00,param_01,param_02,param_03)
{
	var_04 = spawnstruct();
	var_04.var_52BC = param_01;
	var_04.var_6AF7 = param_02;
	var_04.var_6AED = param_03;
	level.var_7ED0[param_00] = var_04;
}

//Function Id: 0x7BA6
//Function Number: 2
lib_0533::func_7BA6()
{
	lib_0533::func_7BCE("role_ability_adrenaline_shot_mp",::lib_052E::func_00D5,::lib_052E::func_3662,::lib_052E::func_2F9E);
	lib_0533::func_7BCE("role_ability_steel_bib_mp",::lib_0535::func_00D5,::lib_0535::func_3662,::lib_0535::func_2F9E);
	lib_0533::func_7BCE("role_ability_extreme_conditioning_mp",::lib_0531::func_00D5,::lib_0531::func_3662,::lib_0531::func_2F9E);
	lib_0533::func_7BCE("role_ability_doron_vest_mp",::lib_0530::func_00D5,::lib_0530::func_3662,::lib_0530::func_2F9E);
	lib_0533::func_7BCE("role_ability_combat_focus_mp",::lib_052F::func_00D5,::lib_052F::func_3662,::lib_052F::func_2F9E);
	lib_0533::func_7BCE("role_ability_undercover_mp",::lib_0536::func_00D5,::lib_0536::func_3662,::lib_0536::func_2F9E);
	lib_0533::func_7BCE("role_ability_misinformation_mp",::lib_0532::func_00D5,::lib_0532::func_3662,::lib_0532::func_2F9E);
	lib_0533::func_7BCE("role_ability_self_revive_mp",::lib_0534::func_00D5,::lib_0534::func_3662,::lib_0534::func_2F9E);
}

//Function Id: 0x00D5
//Function Number: 3
lib_0533::func_00D5()
{
	self.var_7ED1 = [];
	level.var_7ED0 = [];
	if(isdefined(level.var_7BF5))
	{
		level [[ level.var_7BF5 ]]();
	}
	else
	{
		lib_0533::func_7BA6();
	}

	foreach(var_01 in level.var_7ED0)
	{
		level thread [[ var_01.var_52BC ]]();
	}

	level thread lib_0533::func_6B6C();
	setdvarifuninitialized("rolePowerGainOnDeathShouldCheckWasActive",0);
}

//Function Id: 0x6B6C
//Function Number: 4
lib_0533::func_6B6C()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!maps\mp\_utility::func_585F())
		{
			if(!isdefined(var_00.var_012C["roleRespawnPower"]))
			{
				var_00.var_012C["roleRespawnPower"] = 0;
			}
		}

		var_00 thread lib_0533::func_6B82();
	}
}

//Function Id: 0x6B82
//Function Number: 5
lib_0533::func_6B82()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned");
		self.var_7ED1["activeOnDeath"] = 0;
		lib_0533::func_7DF5();
		if(getdvarint("1936"))
		{
			thread lib_0533::func_6B7A();
			thread lib_0533::func_6B74();
			thread lib_0533::func_6B98();
			thread lib_0533::func_6B76();
		}
	}
}

//Function Id: 0x6B7A
//Function Number: 6
lib_0533::func_6B7A()
{
	self endon("disconnect");
	self endon("spawned");
	self waittill("joined_team");
	lib_0533::func_7D6B();
}

//Function Id: 0x6B74
//Function Number: 7
lib_0533::func_6B74()
{
	self endon("disconnect");
	self endon("spawned");
	self waittill("death");
	var_00 = self rolecheckstate("active");
	self.var_7ED1["activeOnDeath"] = var_00;
	self roleondeath();
	lib_0533::func_942F();
}

//Function Id: 0x6B76
//Function Number: 8
lib_0533::func_6B76()
{
	self endon("disconnect");
	self endon("spawned");
	self endon("death ");
	var_00 = self rolecheckstate("ready");
	if(var_00)
	{
		return;
	}

	for(;;)
	{
		var_01 = self rolecheckstate("ready");
		var_02 = self rolecheckstate("active");
		if(!var_00 && var_01 || var_02)
		{
			if(maps\mp\_utility::func_585F())
			{
				lib_0378::func_8D74("role_ready");
			}
			else
			{
				self method_860F("ks_earn_dna_bomb",self,1);
			}

			return;
		}
		else
		{
			wait 0.05;
		}
	}
}

//Function Id: 0x6B98
//Function Number: 9
lib_0533::func_6B98()
{
	self endon("disconnect");
	self endon("spawned");
	level waittill("game_ended");
	if(maps\mp\_utility::func_57B2() && !maps\mp\_utility::func_5743())
	{
		var_00 = self rolecheckstate("active");
		self.var_7ED1["activeOnDeath"] = var_00;
		self roleondeath();
		lib_0533::func_942F();
	}
}

//Function Id: 0x3662
//Function Number: 10
lib_0533::func_3662(param_00)
{
	if(!getdvarint("1936"))
	{
		return;
	}

	if(isdefined(self.var_7ED1) && isdefined(self.var_7ED1[param_00]) && self.var_7ED1[param_00] == 1)
	{
		lib_0533::func_2F9E(param_00);
		return;
	}

	var_01 = level.var_7ED0[param_00];
	if(isdefined(var_01))
	{
		self thread [[ var_01.var_6AF7 ]]();
	}
	else
	{
		return;
	}

	self.var_7ED1[param_00] = 1;
	thread lib_0533::func_2F94(param_00);
}

//Function Id: 0x2F9E
//Function Number: 11
lib_0533::func_2F9E(param_00)
{
	if(!getdvarint("1936"))
	{
		return;
	}

	self notify("DisabledRoleAbility");
	self notify("DisabledRoleAbility_" + param_00);
	var_01 = level.var_7ED0[param_00];
	if(isdefined(var_01))
	{
		self thread [[ var_01.var_6AED ]]();
	}
	else
	{
		return;
	}

	if(maps\mp\_utility::func_585F())
	{
		var_02 = self getentitynumber();
		function_0327(&"activate_special_teammate",3,var_02,param_00,0);
	}

	self.var_7ED1[param_00] = 0;
	lib_0533::func_2408();
}

//Function Id: 0x2F94
//Function Number: 12
lib_0533::func_2F94(param_00)
{
	level endon("game_ended");
	self endon("DisabledRoleAbility");
	common_scripts\utility::func_A70A("death","disconnect","joined_team","joined_spectators");
	lib_0533::func_2F9E(param_00);
}

//Function Id: 0x2408
//Function Number: 13
lib_0533::func_2408()
{
	self roleapplypowerchange(-1);
}

//Function Id: 0x0F37
//Function Number: 14
lib_0533::func_0F37(param_00,param_01,param_02)
{
	if(isdefined(self.powerbuffamount))
	{
		param_00 = param_00 * self.powerbuffamount;
	}

	if(param_00 > 0 && param_00 < 1 && isdefined(level._zmb_roles_positive_power_multiplier))
	{
		param_00 = param_00 * level._zmb_roles_positive_power_multiplier;
	}

	if(!getdvarint("1936"))
	{
		return;
	}

	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(self.var_0178 == "dead")
	{
		if(isdefined(self.var_012C["roleRespawnPower"]))
		{
			var_03 = getdvarint("rolePowerGainOnDeathShouldCheckWasActive") == 1;
			if(var_03)
			{
				if(isdefined(self.var_7ED1["activeOnDeath"]))
				{
					var_04 = self.var_7ED1["activeOnDeath"];
					if(!var_04)
					{
						self.var_012C["roleRespawnPower"] = self.var_012C["roleRespawnPower"] + param_00;
						self roleapplypowerchange(param_00,param_01);
						return;
					}

					return;
				}

				return;
			}

			self.var_012C["roleRespawnPower"] = self.var_012C["roleRespawnPower"] + param_00;
			self roleapplypowerchange(param_00,param_01);
			return;
		}

		return;
	}

	var_05 = self rolecheckstate("active");
	if(!var_05 || param_02)
	{
		self roleapplypowerchange(param_00,param_01);
	}
}

//Function Id: 0x3F90
//Function Number: 15
lib_0533::func_3F90()
{
	if(!maps\mp\_utility::func_585F())
	{
		lib_0533::func_0F37(0.07);
	}
}

//Function Id: 0x6BCF
//Function Number: 16
lib_0533::func_6BCF(param_00)
{
	if(!maps\mp\_utility::func_585F())
	{
		lib_0533::func_0F37(0.0425);
	}
}

//Function Id: 0x942F
//Function Number: 17
lib_0533::func_942F()
{
	var_00 = self rolegetpower();
	if(isdefined(self.var_012C["roleRespawnPower"]))
	{
		self.var_012C["roleRespawnPower"] = var_00;
	}
}

//Function Id: 0x7D6B
//Function Number: 18
lib_0533::func_7D6B()
{
	if(isdefined(self.var_012C["roleRespawnPower"]))
	{
		self.var_012C["roleRespawnPower"] = 0;
	}
}

//Function Id: 0x7DF5
//Function Number: 19
lib_0533::func_7DF5()
{
	if(isdefined(self.var_012C["roleRespawnPower"]))
	{
		self roleapplypowerchange(self.var_012C["roleRespawnPower"]);
	}
}