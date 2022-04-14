/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1375.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 64
 * Decompile Time: 132 ms
 * Timestamp: 8/24/2021 10:29:25 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_055F::func_00D5()
{
	level.var_0A41["zombie_boss_village"] = level.var_0A41["zombie"];
	level.var_0A41["zombie_boss_village"]["spawn"] = ::lib_055F::func_AB7D;
	level.var_0A41["zombie_boss_village"]["think"] = ::lib_055F::func_AB7E;
	level.var_0A41["zombie_boss_village"]["move_mode"] = ::lib_055F::func_AB6C;
	level.var_0A41["zombie_boss_village"]["post_model"] = ::lib_055F::func_AB6F;
	level.var_0A41["zombie_boss_village"]["on_damaged"] = ::lib_055F::func_AB6D;
	level.var_0A41["zombie_boss_village"]["on_killed"] = ::lib_055F::func_AB6E;
	level.var_0A41["zombie_boss_village"]["tesla_delayed_dmg"] = ::zombie_boss_village_tesla_delayed_dmg;
	var_00 = spawnstruct();
	var_00.var_0A4B = "zombie_boss_village";
	var_00.var_0EAE = "zombie_boss_animclass";
	var_00.var_0879 = "zombie_boss";
	var_00.var_5ED2["default look"]["whole_body"] = "zom_brute_b_base";
	var_00.var_1144["whole_body"] = "zom_klaus_wholebody";
	var_00.var_4C12 = 1;
	var_00.var_60E2 = 30;
	var_00.var_8302 = 200;
	var_00.var_8303 = 60;
	var_00.parenttype = "zombie_generic";
	if(isdefined(level.var_62AB))
	{
		var_00 = [[ level.var_62AB ]](var_00);
	}

	lib_0547::func_0A52(var_00,"zombie_boss_village");
	level.animtree_lookup["ombie_boss"] = #animtree;
	level.var_5A8A = [];
	var_01 = function_027A("mp/zombieKlausActionTable.csv");
	for(var_02 = 0;var_02 < var_01;var_02++)
	{
		var_03 = tablelookupbyrow("mp/zombieKlausActionTable.csv",var_02,1);
		var_04 = strtok(tablelookupbyrow("mp/zombieKlausActionTable.csv",var_02,2)," ");
		if(isdefined(var_03) && var_03 != "")
		{
			level.var_5A8A[var_03] = var_04;
		}
	}

	level.var_0611["zmb_brute_drool"] = loadfx("vfx/zombie/zmb_brute_drool");
}

//Function Id: 0xAB6D
//Function Number: 2
lib_055F::func_AB6D(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A)
{
	if(!isdefined(param_01) || param_05 == "turretweapon_zeppelin_gun_zm" && common_scripts\utility::func_562E(self.var_A87C))
	{
		return;
	}

	param_01 thread maps\mp\gametypes\_damagefeedback::func_A102("standard");
	self notify("brute_boss_damage",param_02,param_05);
}

//Function Id: 0xAB6E
//Function Number: 3
lib_055F::func_AB6E(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	lib_054D::func_6BD4(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Id: 0xAB6C
//Function Number: 4
lib_055F::func_AB6C()
{
	if(self.var_8BA4 && !isdefined(self.var_1928) && !common_scripts\utility::func_562E(self.var_9E1B))
	{
		return "run";
	}

	return "walk";
}

//Function Id: 0x0000
//Function Number: 5
zombie_boss_village_tesla_delayed_dmg(param_00,param_01,param_02)
{
	return param_00;
}

//Function Id: 0xAB65
//Function Number: 6
lib_055F::func_AB65(param_00,param_01)
{
	lib_055F::func_7678(param_00,0,param_01);
}

//Function Id: 0xAB66
//Function Number: 7
lib_055F::func_AB66(param_00,param_01)
{
	lib_055F::func_7678(param_00,0,param_01,0,undefined,undefined,::lib_055F::func_1CC3,"attack");
}

//Function Id: 0x1CC3
//Function Number: 8
lib_055F::func_1CC3(param_00)
{
	self notify("brute_smash_starting");
	self endon("brute_smash_starting");
	var_01 = "";
	while(var_01 != param_00)
	{
		self waittill("scripted_anim",var_01);
	}

	var_02 = self gettagorigin("J_Wrist_RI");
	playfx(level.var_0611["zmb_brute_slam"],var_02,anglestoforward(self.var_001D),anglestoup(self.var_001D));
	foreach(var_04 in level.var_744A)
	{
		var_05 = distance(self.var_0116,var_04.var_0116);
		if(var_05 < 1)
		{
			var_05 = 1;
		}

		if(var_05 <= 192)
		{
			var_04 shellshock("frag_grenade_mp",1.25);
			var_04 dodamage(150 / var_05 + 30,self.var_0116,self,self,"MOD_GRENADE");
		}
	}
}

//Function Id: 0xAB67
//Function Number: 9
lib_055F::func_AB67(param_00,param_01)
{
	lib_055F::func_7678(param_00,0,param_01,0,undefined,undefined,::lib_055F::func_1CC3,"attack");
}

//Function Id: 0xAB63
//Function Number: 10
lib_055F::func_AB63(param_00,param_01)
{
	lib_055F::func_7678(param_00,0,param_01);
}

//Function Id: 0xAB62
//Function Number: 11
lib_055F::func_AB62(param_00,param_01)
{
	lib_055F::func_7678(param_00,0,param_01);
}

//Function Id: 0xAB68
//Function Number: 12
lib_055F::func_AB68(param_00,param_01,param_02)
{
	lib_055F::func_7678(param_00,0,undefined,1,param_01,param_02);
}

//Function Id: 0xAB69
//Function Number: 13
lib_055F::func_AB69(param_00)
{
	self notify("show an uber battery");
	self endon("returning to arena");
	var_01 = common_scripts\utility::func_46B7("brute_exit_destination","targetname");
	var_02 = common_scripts\utility::func_4461(self.var_0116,var_01);
	self.var_1928 = var_02;
	var_03 = common_scripts\utility::func_46B7("brute_roar_point","targetname");
	var_04 = 1;
	while(var_04)
	{
		foreach(var_06 in var_03)
		{
			if(distance(self.var_0116,var_06.var_0116) < 128)
			{
				var_04 = 0;
				break;
			}
		}

		wait(0.15);
	}

	lib_055F::func_7678("brute_roar_leaving");
}

//Function Id: 0xAB64
//Function Number: 14
lib_055F::func_AB64(param_00)
{
	self notify("returning to arena");
	var_01 = common_scripts\utility::func_46B7("brute_exit_destination","targetname");
	var_02 = lib_055F::func_44C9(var_01,256);
	if(var_02.size > 0)
	{
		var_03 = common_scripts\utility::func_7A33(var_02);
	}
	else
	{
		var_03 = common_scripts\utility::func_7A33(var_02);
	}

	self setorigin(var_03.var_0116 + (0,0,8));
	self.var_001D = var_03.var_001D;
	var_04 = common_scripts\utility::func_46B5("final_brute_boss","targetname");
	self.var_1928 = var_04;
	self.var_9E1B = 1;
	self waittill("traverse_end");
	self.var_9E1B = 0;
	self.var_1928 = undefined;
	lib_055F::func_AB75();
}

//Function Id: 0xAB7B
//Function Number: 15
lib_055F::func_AB7B()
{
	lib_055F::func_AB7A();
	self waittill("brute_unstunned",var_00,var_01);
	return [var_00,var_01];
}

//Function Id: 0xAB6A
//Function Number: 16
lib_055F::func_AB6A(param_00,param_01)
{
	thread lib_055F::func_A6B5(param_01);
	lib_055F::func_7678(param_00,0,undefined,1,"brute_stunned",param_01);
	self.var_3ACE sethintstring(&"ZOMBIES_EMPTY_STRING");
}

//Function Id: 0xAB79
//Function Number: 17
lib_055F::func_AB79()
{
	self notify("set brute behavior","scripted_brute_exit_traversal");
}

//Function Id: 0xAB72
//Function Number: 18
lib_055F::func_AB72()
{
	self notify("set brute behavior","scripted_brute_entrance_traversal");
}

//Function Id: 0xAB74
//Function Number: 19
lib_055F::func_AB74()
{
	self notify("set brute behavior","brute_standing_attack");
}

//Function Id: 0xAB76
//Function Number: 20
lib_055F::func_AB76()
{
	self notify("set brute behavior","brute_hulk_smash");
}

//Function Id: 0xAB77
//Function Number: 21
lib_055F::func_AB77()
{
	self notify("set brute behavior","brute_hulk_smash_180");
}

//Function Id: 0xAB71
//Function Number: 22
lib_055F::func_AB71()
{
	self notify("set brute behavior","brute_standing_attack_180");
}

//Function Id: 0xAB73
//Function Number: 23
lib_055F::func_AB73()
{
	self notify("set brute behavior","brute_walking_attack");
}

//Function Id: 0xAB78
//Function Number: 24
lib_055F::func_AB78()
{
	self notify("set brute behavior","brute_idle");
}

//Function Id: 0xAB7A
//Function Number: 25
lib_055F::func_AB7A()
{
	self notify("set brute behavior","brute_stun_start");
}

//Function Id: 0xAB75
//Function Number: 26
lib_055F::func_AB75()
{
	self notify("set brute behavior","brute_unlock_state");
}

//Function Id: 0xA6AD
//Function Number: 27
lib_055F::func_A6AD()
{
	self waittill("set brute behavior",var_00);
	return var_00;
}

//Function Id: 0x27A2
//Function Number: 28
lib_055F::func_27A2(param_00,param_01,param_02)
{
	var_03 = spawnstruct();
	var_03.var_95AA = param_00;
	var_03.var_73D7 = param_01;
	var_03.var_AC1A = param_02;
	return var_03;
}

//Function Id: 0xAB70
//Function Number: 29
lib_055F::func_AB70()
{
	self endon("death");
	thread lib_055F::func_115A();
	var_00 = 200;
	var_01 = var_00;
	var_02 = var_00;
	var_03 = 10000;
	var_04 = 150;
	var_05 = lib_055F::func_27A2("J_Mid_LE_3",var_01,var_02);
	var_06 = lib_055F::func_27A2("J_Mid_RI_3",var_01,var_02);
	var_07 = lib_055F::func_27A2("tag_origin",var_03,var_04);
	var_08 = [var_05,var_06];
	var_09 = common_scripts\utility::func_0F73(var_08,[var_07]);
	var_0A = ["brute_unlock_state","scripted_brute_exit_traversal","scripted_brute_entrance_traversal","brute_idle","brute_stun_start"];
	var_0B = 0;
	var_0C = "";
	wait 0.05;
	lib_055F::func_7678("brute_roar_recovering",0,undefined);
	for(;;)
	{
		var_0D = lib_055F::func_A6AD();
		self.var_AB5C = var_0D;
		if(var_0B && common_scripts\utility::func_0F79(var_0A,var_0D))
		{
			self notify("brute behavior was unlocked");
			var_0B = 0;
		}

		if(!var_0B)
		{
			switch(var_0D)
			{
				case "brute_walking_attack":
					var_0E = spawnstruct();
					var_0E.var_596D = var_09;
					var_0E.var_67E9 = "stop charge damage";
					if(common_scripts\utility::func_562E(self.var_8BA4))
					{
						var_0D = "brute_running_attack";
					}
		
					childthread lib_055F::func_AB62(var_0D,var_0E);
					break;
	
				case "brute_stun_start":
					var_0B = 1;
					var_0C = "stunned";
					childthread lib_055F::func_AB6A(var_0D,"brute_unstunned");
					break;
	
				case "brute_idle":
					var_0B = 1;
					var_0C = "waiting";
					childthread lib_055F::func_AB68(var_0D,"brute_idle","scripted_brute_entrance_traversal");
					break;
	
				case "scripted_brute_exit_traversal":
					var_0B = 1;
					var_0C = "leaving";
					childthread lib_055F::func_AB69(var_0D);
					break;
	
				case "scripted_brute_entrance_traversal":
					var_0B = 1;
					var_0C = "returning";
					childthread lib_055F::func_AB64(var_0D);
					break;
	
				case "brute_standing_attack":
					var_0E = spawnstruct();
					var_0E.var_596D = var_08;
					var_0E.var_67E9 = "stop forward swing";
					childthread lib_055F::func_AB65(var_0D,var_0E);
					break;
	
				case "brute_hulk_smash":
					var_0E = spawnstruct();
					var_0E.var_596D = var_08;
					var_0E.var_67E9 = "stop ground pound";
					childthread lib_055F::func_AB66(var_0D,var_0E);
					break;
	
				case "brute_hulk_smash_180":
					var_0E = spawnstruct();
					var_0E.var_596D = var_08;
					var_0E.var_67E9 = "stop ground pound_180";
					childthread lib_055F::func_AB67(var_0D,var_0E);
					break;
	
				case "brute_standing_attack_180":
					var_0E = spawnstruct();
					var_0E.var_596D = var_09;
					var_0E.var_67E9 = "stop backhand swing";
					childthread lib_055F::func_AB63(var_0D,var_0E);
					break;
			}

			continue;
		}
	}
}

//Function Id: 0x7678
//Function Number: 30
lib_055F::func_7678(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	self notify("brute_change_actions");
	self endon("brute_change_actions");
	self endon("death");
	if(self.var_0A4B != "zombie_boss_village")
	{
		return;
	}

	var_08 = param_00;
	var_09 = maps/mp/agents/_scripted_agent_anim_util::func_434D(var_08);
	var_0A = self method_83DB(var_09);
	var_0B = randomint(var_0A);
	self method_839C("anim deltas");
	self scragentsetorientmode("face angle abs",self.var_001D);
	self scragentsetscripted(1);
	self.var_01BB = 1;
	if(common_scripts\utility::func_562E(param_01))
	{
		self method_839D("noclip");
	}
	else
	{
		self method_839D("gravity");
	}

	if(isdefined(param_02))
	{
		foreach(var_0D in param_02.var_596D)
		{
			childthread lib_055F::func_3203(var_0D,param_02.var_67E9);
		}
	}

	if(isdefined(param_06))
	{
		self childthread [[ param_06 ]](param_07);
	}

	if(!common_scripts\utility::func_562E(param_03))
	{
		maps/mp/agents/_scripted_agent_anim_util::func_71FA(var_09,var_0B,1,"scripted_anim");
	}
	else
	{
		lib_055F::func_309A(param_00,param_04,param_05);
	}

	if(common_scripts\utility::func_562E(param_01))
	{
		self method_839D("gravity");
	}

	if(isdefined(param_02))
	{
		self notify(param_02.var_67E9);
	}

	self scragentsetscripted(0);
	self notify("brute finished scripted state");
}

//Function Id: 0x309A
//Function Number: 31
lib_055F::func_309A(param_00,param_01,param_02)
{
	self endon("death");
	var_03 = lib_055F::func_43FA(param_00);
	var_04 = spawnstruct();
	var_04.var_8B58 = 0;
	childthread lib_055F::func_49E8(var_04,param_02);
	self.var_55A6 = 1;
	for(var_05 = 0;var_05 < var_03.size;var_05++)
	{
		var_06 = var_03[var_05];
		var_07 = maps/mp/agents/_scripted_agent_anim_util::func_434D(var_06);
		var_08 = maps/mp/agents/_scripted_agent_anim_util::func_7A35(var_07);
		if(var_03[var_05] == param_01)
		{
			childthread maps/mp/agents/_scripted_agent_anim_util::func_71FA(var_07,var_08,1,"scripted_anim");
			while(!var_04.var_8B58)
			{
				lib_0547::func_A6F6();
			}

			continue;
		}

		maps/mp/agents/_scripted_agent_anim_util::func_71FA(var_07,var_08,1,"scripted_anim");
	}

	self.var_55A6 = 0;
}

//Function Id: 0x49E8
//Function Number: 32
lib_055F::func_49E8(param_00,param_01)
{
	self waittill(param_01);
	param_00.var_8B58 = 1;
}

//Function Id: 0x1CB8
//Function Number: 33
lib_055F::func_1CB8()
{
	self endon("death");
	var_00 = 0;
	if(common_scripts\utility::func_562E(self.var_55A6) || maps/mp/agents/_scripted_agent_anim_util::func_57E2())
	{
		return 0;
	}

	var_01 = lib_055F::func_40E4();
	if(var_01.var_8F15 || var_01.var_6895 > 0)
	{
		if(var_01.var_6891 > var_01.var_687E)
		{
			if(common_scripts\utility::func_24A6())
			{
				lib_055F::func_AB74();
			}
			else
			{
				lib_055F::func_AB76();
			}
		}
		else
		{
			lib_055F::func_AB77();
		}

		var_00 = 1;
	}
	else if(var_01.var_6895 > 0 && var_01.var_6891 < var_01.var_687E)
	{
		lib_055F::func_AB71();
		var_00 = 1;
	}
	else if(var_01.var_688D > 0 && var_01.var_6891 > 0)
	{
		if(lib_055F::func_1CC7())
		{
			lib_055F::func_AB73();
			var_00 = 1;
		}
		else
		{
			var_00 = 0;
		}
	}

	return var_00;
}

//Function Id: 0x1CC5
//Function Number: 34
lib_055F::func_1CC5()
{
	wait(4);
	for(;;)
	{
		wait(0.1);
		var_00 = lib_055F::func_40E4();
		if(var_00.var_688D + var_00.var_6897 == lib_055F::func_6873() && !common_scripts\utility::func_562E(self.var_8BA4))
		{
			if(!common_scripts\utility::func_562E(self.var_203F))
			{
				thread lib_055F::func_93BF(5);
			}

			continue;
		}

		if(self.var_8BA4 && var_00.var_6895 > 0)
		{
			thread lib_055F::func_1F35();
		}
	}
}

//Function Id: 0x93BF
//Function Number: 35
lib_055F::func_93BF(param_00)
{
	self endon("cancel_brute_run");
	self.var_8BA4 = 1;
	wait(param_00);
	self.var_8BA4 = 0;
	self.var_203F = 1;
	wait(4);
	self.var_203F = 0;
}

//Function Id: 0x1F35
//Function Number: 36
lib_055F::func_1F35()
{
	self notify("cancel_brute_run");
	self.var_8BA4 = 0;
}

//Function Id: 0x40E4
//Function Number: 37
lib_055F::func_40E4()
{
	var_00 = spawnstruct();
	var_00.var_8F15 = 0;
	var_00.var_6897 = 0;
	var_00.var_6895 = 0;
	var_00.var_688D = 0;
	var_00.var_6891 = 0;
	var_00.var_687E = 0;
	foreach(var_02 in level.var_744A)
	{
		if(distance(var_02.var_0116,self.var_0116) < 50)
		{
			var_00.var_8F15 = 1;
		}
		else if(distance(var_02.var_0116,self.var_0116) < 256)
		{
			var_00.var_6895++;
		}
		else if(distance(var_02.var_0116,self.var_0116) < 768)
		{
			var_00.var_688D++;
		}
		else
		{
			var_00.var_6897++;
		}

		if(var_02 lib_053C::func_5724(self))
		{
			var_00.var_6891++;
			continue;
		}

		var_00.var_687E++;
	}

	var_00.var_6873 = lib_055F::func_6873();
	return var_00;
}

//Function Id: 0x6873
//Function Number: 38
lib_055F::func_6873()
{
	var_00 = 0;
	foreach(var_02 in level.var_744A)
	{
		if(isalive(var_02) && !var_02.var_5378)
		{
			var_00++;
		}
	}

	return var_00;
}

//Function Id: 0x115A
//Function Number: 39
lib_055F::func_115A()
{
	var_00 = getentarray("nest_brute_uber_inserts","targetname");
	while(self.var_0106 == "tag_origin")
	{
		wait 0.05;
	}

	foreach(var_02 in var_00)
	{
		var_02 method_805B();
		var_02.var_0116 = self gettagorigin(var_02.var_0165) + lib_055F::func_425D(var_02.var_0165);
		var_02 linktoblendtotag(self,var_02.var_0165);
	}

	var_00 thread lib_055F::func_1CCD(self);
}

//Function Id: 0x425D
//Function Number: 40
lib_055F::func_425D(param_00)
{
	var_01 = (0,0,0);
	switch(param_00)
	{
		case "J_Knee_LE":
			var_01 = (8,8,-8);
			break;

		case "J_Knee_RI":
			var_01 = (-8,-8,-8);
			break;

		case "J_SpineLower":
			var_01 = (0,16,0);
			break;
	}

	return var_01;
}

//Function Id: 0x1CCD
//Function Number: 41
lib_055F::func_1CCD(param_00)
{
	var_01 = [undefined,undefined,undefined];
	foreach(var_03 in self)
	{
		var_01[var_03.var_8140 - 1] = var_03;
		var_03 method_8511();
	}

	param_00.var_1CCF = var_01;
	foreach(var_06, var_03 in var_01)
	{
		param_00 waittill("show an uber battery");
		var_03 method_805B();
		playfxontag(level.var_0611["gk_raven_hc_ee_uber_attached"],var_03,"tag_origin");
		var_03 lib_0378::func_8D74("uber_battery_spawn");
	}
}

//Function Id: 0x44C9
//Function Number: 42
lib_055F::func_44C9(param_00,param_01)
{
	var_02 = [];
	foreach(var_04 in param_00)
	{
		foreach(var_06 in level.var_744A)
		{
			if(distance(var_04.var_0116,var_06.var_0116) < param_01)
			{
				var_02 = common_scripts\utility::func_0F6F(var_02,var_04);
			}
		}
	}

	return var_02;
}

//Function Id: 0x43FA
//Function Number: 43
lib_055F::func_43FA(param_00)
{
	var_01 = [];
	switch(param_00)
	{
		case "brute_stun_start":
			var_01 = ["brute_stun_start","brute_stunned","brute_stun_end","brute_roar_leaving"];
			break;

		case "brute_idle":
			var_01 = ["brute_idle"];
			break;

		default:
			break;
	}

	return var_01;
}

//Function Id: 0xA6B5
//Function Number: 44
lib_055F::func_A6B5(param_00)
{
	wait(2.25);
	thread lib_055F::func_94BF(2,param_00);
	self endon(param_00);
	var_01 = undefined;
	for(var_02 = 0;!var_02;var_02 = var_01 lib_0585::func_9E12("Blimp Battery Hunt"))
	{
		self.var_3ACE sethintstring(&"ZOMBIE_NEST_PLACE_UBER");
		self.var_3ACE waittill("trigger",var_01);
	}

	self notify(param_00,1,var_01);
}

//Function Id: 0x1CC6
//Function Number: 45
lib_055F::func_1CC6()
{
	level thread maps\mp\_utility::func_6F74(::lib_055F::func_A0EB,self);
}

//Function Id: 0xA0EB
//Function Number: 46
lib_055F::func_A0EB(param_00)
{
	if(!isdefined(param_00))
	{
		return;
	}

	param_00 endon("death");
	lib_055F::func_863C(param_00.var_3ACE,self,0);
	for(;;)
	{
		var_01 = common_scripts\utility::func_A715("uber_gained","uber_lost");
		if(!isalive(self))
		{
			continue;
		}

		if(var_01 == "uber_gained")
		{
			if(lib_0586::func_72C3())
			{
				lib_055F::func_863C(param_00.var_3ACE,self,1);
			}

			continue;
		}

		if(var_01 == "uber_lost")
		{
			lib_055F::func_863C(param_00.var_3ACE,self,0);
		}
	}
}

//Function Id: 0x863C
//Function Number: 47
lib_055F::func_863C(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		param_00 [[ common_scripts\utility::func_98E7(param_02,::enableplayeruse,::disableplayeruse) ]](param_01);
	}
}

//Function Id: 0x94BF
//Function Number: 48
lib_055F::func_94BF(param_00,param_01)
{
	self endon(param_01);
	if(level.var_744A.size == 1)
	{
		param_00 = param_00 + 3;
	}

	lib_0555::func_83DD("brute_stun");
	while(param_00 > 0)
	{
		param_00--;
		wait(1);
	}

	lib_0555::func_83DD("brute_awake");
	self notify(param_01,0);
}

//Function Id: 0x1CC7
//Function Number: 49
lib_055F::func_1CC7(param_00)
{
	if(lib_055F::func_A271(self))
	{
		return 1;
	}

	return 0;
}

//Function Id: 0x3203
//Function Number: 50
lib_055F::func_3203(param_00,param_01)
{
	self endon("brute_change_actions");
	self endon(param_01);
	self endon("death");
	var_02 = [];
	var_03 = param_00.var_95AA;
	var_04 = param_00.var_73D7;
	var_05 = param_00.var_AC1A;
	for(;;)
	{
		var_06 = [];
		if(var_05 > 0)
		{
			var_07 = lib_0547::func_408F();
			var_07 = common_scripts\utility::func_0F93(var_07,self);
			var_06 = common_scripts\utility::func_0F73(var_06,var_07);
		}

		if(var_04 > 0)
		{
			var_06 = common_scripts\utility::func_0F73(var_06,level.var_744A);
		}

		foreach(var_09 in var_06)
		{
			var_0A = common_scripts\utility::func_98E7(isplayer(var_09),var_04,var_05);
			var_0B = self gettagorigin(var_03);
			if(!common_scripts\utility::func_0F79(var_02,var_09) && distance(var_0B,var_09.var_0116) < 64)
			{
				var_09 dodamage(var_0A,var_0B,self,self,"MOD_IMPACT");
				var_02 = common_scripts\utility::func_0F6F(var_02,var_09);
			}
		}

		wait 0.05;
	}
}

//Function Id: 0xAB6B
//Function Number: 51
lib_055F::func_AB6B(param_00)
{
	var_01 = self;
	var_01 endon("death");
	var_02 = var_01 method_8445(param_00);
	if(var_02 == -1)
	{
		return;
	}

	var_03 = spawnstruct();
	var_03.var_0116 = var_01 gettagorigin(param_00);
	var_03.var_001D = var_01.var_001D;
	var_03.var_2F74 = 1;
	var_04 = spawnstruct();
	var_04.var_2434 = 30;
	var_04.var_60C1 = 60;
	var_04.var_3A20 = 90;
	var_04.var_1B70 = 82;
	var_01 childthread lib_0547::tackle_thread(var_03,var_04);
	for(;;)
	{
		wait(0.1);
		if(!isdefined(var_01.var_AB5C))
		{
			continue;
		}

		var_03.var_0116 = var_01 gettagorigin(param_00);
		var_03.var_001D = var_01.var_001D;
		var_03.var_2F74 = !common_scripts\utility::func_0F79(["scripted_brute_exit_traversal","scripted_brute_entrance_traversal","brute_standing_attack","brute_standing_attack_180","brute_walking_attack","brute_up_stairs","brute_down_stairs"],var_01.var_AB5C);
	}
}

//Function Id: 0xAB6F
//Function Number: 52
lib_055F::func_AB6F()
{
	foreach(var_01 in ["j_ball_le","j_ball_ri"])
	{
		thread lib_055F::func_AB6B(var_01);
	}
}

//Function Id: 0xAB7D
//Function Number: 53
lib_055F::func_AB7D(param_00,param_01,param_02)
{
	lib_054D::func_6BD7(param_00,param_01,param_02);
	self.var_90DC = "zombie_boss_village";
}

//Function Id: 0xAB7C
//Function Number: 54
lib_055F::func_AB7C()
{
	var_00 = 48;
	var_01 = 200;
	self method_856C(var_00,var_01);
	self.var_00BD = var_01;
	self.var_014F = var_00;
	self method_85A1("zombie_boss_village");
	self method_84D4();
	self.var_00FB = 100000;
	self.var_00BC = self.var_00FB;
	self.var_6816 = 1;
	self.var_56EB = 1;
	if(!common_scripts\utility::func_562E(level.var_AC14))
	{
		thread lib_055F::func_AB70();
	}

	self.var_5D5F = 1;
	self.var_57E8 = 1;
	self.var_8BA4 = 0;
	self.var_1DEB = 1;
	self method_839F(lib_055F::func_4399());
	thread lib_055F::func_AB5B();
	thread lib_055F::func_1CBE();
}

//Function Id: 0x1CBE
//Function Number: 55
lib_055F::func_1CBE()
{
	wait 0.05;
	playfxontag(level.var_0611["zmb_brute_drool"],self,"J_Head");
}

//Function Id: 0xAB5B
//Function Number: 56
lib_055F::func_AB5B()
{
	var_00 = "tag_origin";
	var_01 = lib_0547::func_0A51("zombie_boss_village");
	var_02 = spawn("script_model",self.var_0116);
	var_02 setmodel(var_01.var_1144["whole_body"]);
	var_02.var_001D = self gettagangles(var_00);
	var_02 linkto(self,var_00);
	self.var_5A9C = var_02;
	self.var_1142 = ::lib_055F::func_84F1;
}

//Function Id: 0x84F1
//Function Number: 57
lib_055F::func_84F1(param_00,param_01,param_02,param_03)
{
	if(!isdefined(self) || !isdefined(self.var_5A9C))
	{
		return;
	}

	self notify("set_klaus_state");
	self endon("set_klaus_state");
	var_04 = param_00;
	if(!isdefined(param_01))
	{
		var_05 = self method_83D9();
		var_06 = self method_83DB(param_00);
		for(var_07 = 0;var_07 < var_06;var_07++)
		{
			var_08 = self method_83D9(param_00,var_07);
			if(var_08 == var_05)
			{
				param_01 = var_07;
				break;
			}
		}
	}

	if(isdefined(self.var_5A9C.var_0EE8) && self.var_5A9C.var_0EE8 == var_04 && isdefined(self.var_5A9C.var_0EC1) && self.var_5A9C.var_0EC1 == param_01)
	{
		return;
	}

	var_09 = undefined;
	var_0A = level.var_5A8A[var_04][param_01];
	wait 0.05;
	self.var_5A9C scriptmodelclearanim();
	self.var_5A9C scriptmodelplayanim(var_0A);
	self.var_5A9C.var_0EE8 = var_04;
	self.var_5A9C.var_0EC4 = var_0A;
	self.var_5A9C.var_0EC1 = param_01;
}

//Function Id: 0xAB7E
//Function Number: 58
lib_055F::func_AB7E()
{
	lib_055F::func_AB7C();
	self endon("death");
	level endon("game_ended");
	self endon("owner_disconnect");
	lib_0566::func_ABB5();
	var_00 = 0.2;
	childthread lib_055F::func_1CC5();
	self.var_117D = 4;
	self.var_1F0F = 1;
	for(;;)
	{
		wait(var_00);
		var_01 = isdefined(self.var_92EA) && gettime() * 0.001 < self.var_92EA;
		self.var_50C5 = common_scripts\utility::func_562E(self.var_54F4) || var_01;
		if(self.var_1F0F && !self.var_50C5)
		{
			if(self.var_117D < 0 && lib_055F::func_1CB8())
			{
				thread lib_055F::func_1160(2);
				continue;
			}
			else if(self.var_117D > 0)
			{
				self.var_117D = self.var_117D - var_00;
			}
		}

		if(lib_053C::func_4F9B())
		{
			continue;
		}

		if(lib_053C::func_4F9A())
		{
			continue;
		}

		lib_053C::func_0647();
	}
}

//Function Id: 0x1160
//Function Number: 59
lib_055F::func_1160(param_00)
{
	self.var_1F0F = 0;
	self.var_117D = param_00;
	common_scripts\utility::func_A70A("brute finished scripted state","brute behavior was unlocked");
	self.var_1F0F = 1;
}

//Function Id: 0x5725
//Function Number: 60
lib_055F::func_5725(param_00)
{
	var_01 = 65536;
	var_02 = 65536;
	var_03 = self.var_001D;
	var_04 = self gettagorigin("tag_origin");
	var_05 = var_04 + var_03 * 1000;
	if(!isdefined(param_00) || !isalive(param_00))
	{
		return 0;
	}

	var_06 = param_00.var_0116 + (0,0,64);
	var_07 = distancesquared(var_04,var_06);
	if(var_07 > var_01)
	{
		return 0;
	}

	var_08 = vectornormalize(var_06 - var_04);
	var_09 = vectordot(var_03,var_08);
	if(0 > var_09)
	{
		return 0;
	}

	var_0A = pointonsegmentnearesttopoint(var_04,var_05,var_06);
	if(distancesquared(var_06,var_0A) > var_02)
	{
		return 0;
	}

	if(0 == param_00 method_81D7(var_04,self))
	{
		return 0;
	}

	if(var_07 < var_01)
	{
		return 1;
	}

	return 0;
}

//Function Id: 0xA271
//Function Number: 61
lib_055F::func_A271(param_00)
{
	var_01 = (0,0,16);
	var_02 = 650;
	var_03 = 5;
	var_04 = [];
	var_05 = [];
	var_06 = lib_055F::func_A01F(param_00.var_001D);
	var_07 = 0;
	var_08 = var_02 / var_03;
	var_09 = 0;
	var_0A = [];
	for(var_0B = 0;var_0B < var_03;var_0B++)
	{
		if(var_0B > 0)
		{
			var_0C = var_04[var_0B - 1] + var_01;
		}
		else
		{
			var_0C = param_00.var_0116 + var_01;
		}

		var_0D = var_0C + var_06 * var_08;
		var_0E = getclosestpointonnavmesh(var_0D,param_00) + var_01;
		var_0F = lib_055F::func_6CC9(var_0D,var_0E);
		var_10 = bullettrace(var_0C,var_0F,0);
		var_04 = common_scripts\utility::func_0F6F(var_04,var_0F);
		if(var_10["fraction"] != 1)
		{
			var_07 = 1;
			break;
		}
	}

	return !var_07;
}

//Function Id: 0xA01F
//Function Number: 62
lib_055F::func_A01F(param_00)
{
	var_01 = anglestoforward(param_00);
	var_01 = common_scripts\utility::func_3D5D(var_01);
	var_01 = vectornormalize(var_01);
	return var_01;
}

//Function Id: 0x6CC9
//Function Number: 63
lib_055F::func_6CC9(param_00,param_01)
{
	return (param_00[0],param_00[1],param_01[2]);
}

//Function Id: 0x4399
//Function Number: 64
lib_055F::func_4399()
{
	var_00 = 0.15;
	var_01 = var_00 * 3.14 * 2 * 0.05;
	return var_01;
}