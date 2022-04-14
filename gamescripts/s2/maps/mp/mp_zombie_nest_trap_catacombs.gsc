/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: mp_zombie_nest_trap_catacombs.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 397 ms
 * Timestamp: 8/24/2021 10:28:49 PM
*******************************************************************/

//Function Id: 0x9C9A
//Function Number: 1
func_9C9A(param_00)
{
	param_00.var_8073 = common_scripts\utility::func_46B7("catacombs_saw_spawner","script_noteworthy");
	param_00.var_8074 = common_scripts\utility::func_46B7("catacombs_saw_spawner_fixed","script_noteworthy");
	param_00 thread func_9098(param_00.var_8073);
	foreach(var_02 in param_00.var_8074)
	{
		param_00 thread func_6F70(var_02);
	}
}

//Function Id: 0x9098
//Function Number: 2
func_9098(param_00)
{
	self endon("cooldown");
	self endon("no_power");
	self endon("deactivate");
	self endon("ready");
	for(;;)
	{
		param_00 thread func_902B(self);
		wait(1);
	}
}

//Function Id: 0x6F70
//Function Number: 3
func_6F70(param_00)
{
	var_01 = get_riverside_door();
	var_02 = distance(param_00.var_0116,var_01.var_0116) < 512;
	var_03 = (0,0,0);
	if(var_02 && !common_scripts\utility::func_3C77("underground_to_riverside1"))
	{
		return;
	}
	else if(var_02)
	{
		var_03 = -4 * vectornormalize(anglestoforward(param_00.var_001D));
		var_03 = var_03 + 96 * vectornormalize(anglestoright(param_00.var_001D));
		var_03 = var_03 + (0,0,-2);
	}

	var_04 = spawn("script_model",param_00.var_0116 + (0,0,-128) + var_03);
	var_04.var_9C92 = self;
	var_04.var_9CBB = self.var_0165;
	var_04 setmodel("zmb_catacomb_trap_saw_02");
	var_04.var_001D = param_00.var_001D;
	var_04 rotateby((0,0,-36000),100);
	var_04 movez(128,1,0,0.5);
	var_04 thread func_6F72(self);
	var_04 thread func_6F73(self);
	common_scripts\utility::func_A70A("cooldown","no_power","deactivate","ready");
	var_04 movez(-128,1,0,0.5);
	wait(0.5);
	var_04 delete();
}

//Function Id: 0x0000
//Function Number: 4
get_riverside_door()
{
	foreach(var_01 in level.var_AC1D)
	{
		if(lib_0547::func_5565(var_01.var_819A,"underground_to_riverside1"))
		{
			return var_01;
		}
	}

	return undefined;
}

//Function Id: 0x902B
//Function Number: 5
func_902B(param_00)
{
	var_01 = common_scripts\utility::func_7A33(self);
	var_02 = common_scripts\utility::func_46B5(var_01.var_01A2,"targetname");
	var_03 = spawn("script_model",var_01.var_0116 + (0,0,-128));
	var_03.var_9C92 = param_00;
	var_03.var_9CBB = param_00.var_0165;
	var_03 setmodel("zmb_catacomb_trap_saw_02");
	var_03.var_001D = var_01.var_001D + (180,0,0);
	var_03 rotatevelocity((0,0,-1000),10);
	var_04 = spawn("script_model",var_01.var_0116);
	var_04 setmodel("tag_origin");
	var_04.var_001D = var_01.var_001D;
	var_03 movez(128,0.5);
	playfxontag(level.var_0611["zmb_catacombs_saw_on"],var_04,"tag_origin");
	var_03 lib_0378::func_8D74("aud_saw_blade_sound");
	wait(0.5);
	var_03 moveto(var_02.var_0116,2.5,0.25,0.25);
	var_04 moveto(var_02.var_0116,2.5,0.25,0.25);
	var_03 func_8075(2.5,param_00);
	stopfxontag(level.var_0611["zmb_catacombs_saw_on"],var_04,"tag_origin");
	var_03 movez(-128,1);
	var_03 lib_0378::func_8D74("aud_saw_blade_end");
	wait(1);
	var_03 delete();
	var_04 delete();
}

//Function Id: 0x6F72
//Function Number: 6
func_6F72(param_00)
{
	param_00 endon("cooldown");
	param_00 endon("no_power");
	param_00 endon("deactivate");
	param_00 endon("ready");
	for(;;)
	{
		var_01 = lib_0547::func_408F();
		foreach(var_03 in var_01)
		{
			if(!isdefined(var_03) || !isalive(var_03))
			{
				continue;
			}

			if(isplayer(var_03))
			{
				continue;
			}

			if(isdefined(var_03.var_53D9) && var_03.var_53D9 == 1)
			{
				continue;
			}

			if(distance(self.var_0116,var_03.var_0116) > 64)
			{
				continue;
			}

			if(var_03 lib_0547::func_580A())
			{
				var_03 dodamage(var_03.var_00BC * 0.25,self.var_0116,self,self,"MOD_EXPLOSIVE","trap_zm_mp");
			}
			else
			{
				param_00 maps/mp/mp_zombie_nest_ee_hc_raven_weapon_upgrades::func_6FEE(var_03);
				var_04 = 500 * vectornormalize(var_03.var_0116 - self.var_0116);
				var_03 lib_0547::func_5A85("torso_lower",(var_04[0],var_04[1],1500),self,"trap_zm_mp");
			}

			wait 0.05;
		}

		wait(0.1);
	}
}

//Function Id: 0x6F73
//Function Number: 7
func_6F73(param_00)
{
	param_00 endon("cooldown");
	param_00 endon("no_power");
	param_00 endon("deactivate");
	param_00 endon("ready");
	for(;;)
	{
		foreach(var_02 in level.var_744A)
		{
			if(!isalive(var_02))
			{
				continue;
			}

			if(lib_0547::func_577E(var_02))
			{
				continue;
			}

			if(distance(self.var_0116,var_02.var_0116) > 64)
			{
				continue;
			}

			var_03 = gettime();
			if(!isdefined(var_02.var_A86A))
			{
				var_02.var_A86A = gettime();
			}

			if(isalive(var_02) && var_03 > var_02.var_A86A + 500 && !lib_0547::func_577E(var_02))
			{
				var_02 dodamage(5,self.var_0116,undefined,undefined,"MOD_CRUSH");
				var_02.var_A86A = gettime();
				wait 0.05;
			}
		}

		wait(0.1);
	}
}

//Function Id: 0x8075
//Function Number: 8
func_8075(param_00,param_01)
{
	var_02 = 0;
	while(var_02 < param_00)
	{
		var_03 = lib_0547::func_408F();
		var_04 = common_scripts\utility::func_0F73(var_03,level.var_744A);
		foreach(var_06 in var_04)
		{
			if(!isdefined(var_06) || !isalive(var_06))
			{
				continue;
			}

			if(isplayer(var_06))
			{
				if(lib_0547::func_577E(var_06))
				{
					continue;
				}
			}
			else if(isdefined(var_06.var_53D9) && var_06.var_53D9 == 1)
			{
				continue;
			}

			if(distance(self.var_0116,var_06.var_0116) > 64)
			{
				continue;
			}

			if(isplayer(var_06))
			{
				var_06 dodamage(5,self.var_0116,undefined,undefined,"MOD_CRUSH");
			}
			else if(var_06 lib_0547::func_580A())
			{
				var_06 dodamage(var_06.var_00BC * 0.25,self.var_0116,self,self,"MOD_EXPLOSIVE","trap_zm_mp");
			}
			else
			{
				param_01 maps/mp/mp_zombie_nest_ee_hc_raven_weapon_upgrades::func_6FEE(var_06);
				var_07 = 500 * vectornormalize(var_06.var_0116 - self.var_0116);
				var_06 lib_0547::func_5A85("torso_lower",(var_07[0],var_07[1],1500),self,"trap_zm_mp");
				if(!isdefined(self.hitbytrap))
				{
					foreach(var_09 in level.var_744A)
					{
						var_09 maps/mp/gametypes/zombies::func_47C7("kill_trap");
						self.hitbytrap = 1;
					}
				}
			}

			wait 0.05;
		}

		wait(0.1);
		var_02 = var_02 + 0.1;
	}
}

//Function Id: 0x8076
//Function Number: 9
func_8076(param_00,param_01)
{
	wait 0.05;
}