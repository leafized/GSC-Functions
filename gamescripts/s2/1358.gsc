/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1358.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 92
 * Decompile Time: 152 ms
 * Timestamp: 8/24/2021 10:29:20 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_054E::func_00D5()
{
	level lib_054E::func_AB19();
	level thread lib_0554::func_00D5();
	if(isdefined(level.var_0793))
	{
		level thread [[ level.var_0793 ]]();
	}

	if(isdefined(level.var_0792))
	{
		level thread [[ level.var_0792 ]]();
	}

	if(!isdefined(level.var_AB17))
	{
		level.var_AB17 = "mp/sound/soundlength_zm_mp.csv";
	}

	level.var_AB13 = 0;
}

//Function Id: 0xAB19
//Function Number: 2
lib_054E::func_AB19()
{
	level.var_A62B = lib_054E::func_AB1B();
	level.var_A62B lib_054E::func_AB1A("player","ability","special_camo","camouflage",undefined);
	level.var_A62B lib_054E::func_AB1A("player","ability","special_mad","freefire",undefined);
	level.var_A62B lib_054E::func_AB1A("player","ability","special_taunt","frontline",undefined);
	level.var_A62B lib_054E::func_AB1A("player","ability","special_burst","shellshock",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_supplyammo","supplyammomod","thanks");
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_headshot","headshotmod","mod_headshot_reply");
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_headshot_reply","headshot_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_serratededge","serreatededgemod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_enhancedspeed","enhancedspeedmod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_covertexfiltration","covertexfilration","revived");
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_saboteur","saboteur",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_fieryburst","fieryburstmod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_exploitweakness","exploitweaknessmod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_supplyarmor","givearmormod","thanks2");
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_comeandgetit","comeandgetitmod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_counteroffensive","counteroffensivemod",undefined);
	level.var_A62B lib_054E::func_AB1A("player","mod_use","mod_teameffort","teameffort",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","revive_ally","modrevived","revived");
	level.var_A62B lib_054E::func_AB1A("player","general","revived","modrevived_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","give_money","givemoney",undefined,25);
	level.var_A62B lib_054E::func_AB1A("player","general","needmoney","givemoneyv1",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","nag_stop_killing","nagstopkilling",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","thanks","supplyammod_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","thanks2","givearmormod_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","got_item","explosivehandler_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","got_item2","givemoney_reply",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","treasurezombieseen","treasurezombieseen",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","treasurezombiemove","treasurezombiemove",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","treasurezombiefail","treasurezombiefail",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","treasurezombiewarn","treasurezombiewarn",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","treasurezombiewin","treasurezombiewin",undefined);
	level.var_A62B lib_054E::func_AB1A("player","enemy","bombersee","bombersee",undefined,5);
	level.var_A62B lib_054E::func_AB1A("player","enemy","bomberkillshot","bomberskillshot",undefined,25);
	level.var_A62B lib_054E::func_AB1A("player","enemy","sprintersee","sprintersee",undefined,1);
	level.var_A62B lib_054E::func_AB1A("player","enemy","followersurpise","followersurpise",undefined,25);
	level.var_A62B lib_054E::func_AB1A("player","enemy","followeranger","lookout",undefined,25);
	level.var_A62B lib_054E::func_AB1A("player","enemy","firemansee","firemanfearreact",undefined,100);
	level.var_A62B lib_054E::func_AB1A("player","perk","perk_first","vendingfirsttime",undefined);
	level.var_A62B lib_054E::func_AB1A("player","perk","perk_ouch","plr_scripted_pain_lev3_",undefined);
	level.var_A62B lib_054E::func_AB1A("player","perk","perk_shock","blitzshock",undefined);
	level.var_A62B lib_054E::func_AB1A("player","perk","perk_punch","blitzpunch",undefined);
	level.var_A62B lib_054E::func_AB1A("player","general","zmb_char_callout","zmb_char_callout",undefined);
	level.var_AB0E = [];
	level.var_AB0E["prefix"] = "zmb_";
	level.var_AB0E["zombie_generic"] = [];
	level.var_AB0E["zombie_generic"]["idle_low"] = "gen_idle_low";
	level.var_AB0E["zombie_generic"]["idle_high"] = "gen_idle_high";
	level.var_AB0E["zombie_generic"]["move"] = "gen_scream";
	level.var_AB0E["zombie_generic"]["attack"] = "gen_scream";
	level.var_AB0E["zombie_generic"]["spawn"] = "gen_spawn";
	level.var_AB0E["zombie_generic"]["taunt"] = "gen_scream";
	level.var_AB0E["zombie_generic"]["behind"] = "gen_behind";
	level.var_AB0E["zombie_generic"]["pain"] = "gen_pain";
	level.var_AB0E["zombie_dog"] = [];
	level.var_AB0E["zombie_dog"]["idle"] = "dog_idle";
	level.var_AB0E["zombie_dog"]["attack"] = "dog_bite";
	level.var_AB0E["zombie_dog"]["spawn"] = "dog_spawn";
	level.var_AB0E["zombie_dog"]["behind"] = "dog_behind";
	level.var_AB0E["zombie_dog"]["pain"] = "dog_pain";
	level.var_AB0E["zombie_host"] = [];
	level.var_AB0E["zombie_host"]["idle_low"] = "hst_scream";
	level.var_AB0E["zombie_host"]["idle_high"] = "hst_scream";
	level.var_AB0E["zombie_host"]["move"] = "hst_scream";
	level.var_AB0E["zombie_host"]["attack"] = "hst_attack_scream";
	level.var_AB0E["zombie_host"]["spawn"] = "hst_scream";
	level.var_AB0E["zombie_host"]["taunt"] = "hst_scream";
	level.var_AB0E["zombie_host"]["behind"] = "hst_behind";
	level.var_AB0E["zombie_host"]["pain"] = "hst_scream";
}

//Function Id: 0x5165
//Function Number: 3
lib_054E::func_5165()
{
	thread lib_054E::func_73AA();
	thread player_zombie_char_ambient_noises();
}

//Function Id: 0x717E
//Function Number: 4
lib_054E::func_717E(param_00,param_01,param_02,param_03,param_04)
{
	self endon("disconnect");
	self endon("stopSpeaking");
	var_05 = 0.25;
	self.var_90C4 = param_00;
	self.var_57DE = 1;
	self notify("speaking");
	var_06 = undefined;
	if(isdefined(param_03))
	{
		var_06 = level.var_744A;
	}

	if(param_02 == "zmb_char_callout")
	{
		lib_0378::func_307E("plr_zom_zde_callout",var_06);
	}
	else if(param_02 == "perk_ouch")
	{
		lib_0378::func_307E(param_00 + lib_0378::func_307B(self.var_20D8),var_06);
	}
	else if(common_scripts\utility::func_562E(param_04))
	{
		var_07 = lib_0367::func_8EA0();
		var_08 = param_00 + var_07;
		if(function_0344(var_08))
		{
			lib_0378::func_307E(var_08,var_06);
		}
		else if(function_0344(param_00))
		{
			lib_0378::func_307E(param_00,var_06);
		}
	}
	else
	{
		lib_0367::func_8E3C(param_02,var_08);
	}

	if(var_07 > 0)
	{
		wait(var_07);
	}

	self notify("done_speaking");
	level notify("done_speaking");
	self.var_57DE = 0;
	if(isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9) && isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9[param_03]) && isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9[param_03][param_04]))
	{
		level thread lib_054E::func_89B1(self,param_03,param_04,var_05);
	}
}

//Function Id: 0x2780
//Function Number: 5
lib_054E::func_2780(param_00,param_01,param_02,param_03,param_04,param_05)
{
	self endon("death");
	self endon("disconnect");
	wait(param_00);
	thread lib_054E::func_277F(param_01,param_02,param_03,param_04,param_05);
}

//Function Id: 0x277F
//Function Number: 6
lib_054E::func_277F(param_00,param_01,param_02,param_03,param_04)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.var_AB1D))
	{
		return 0;
	}

	if(common_scripts\utility::func_562E(self.var_324E))
	{
		return 0;
	}

	if(!isdefined(self.var_57DE))
	{
		self.var_57DE = 0;
	}

	if(common_scripts\utility::func_562E(self.var_57DE))
	{
		return 0;
	}

	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	if(!param_03 && !lib_054E::func_1F13(self.var_AB1D,param_00,param_01))
	{
		return 0;
	}

	var_05 = "player";
	var_06 = undefined;
	var_07 = undefined;
	var_08 = 0;
	if(isshipzombiesmap())
	{
		var_09 = lib_0367::func_8E9F();
		if(!isdefined(var_09))
		{
			return 0;
		}

		var_07 = level.var_A62B.var_90BE[var_05].var_0BB4[param_00][param_01];
		var_06 = var_09 + var_07;
		if(function_0344(var_06 + "_lo") || function_0344(var_06 + "_md") || function_0344(var_06 + "_hi"))
		{
			var_0A = 1;
		}
	}
	else
	{
		var_0B = get_viable_gbl_aliases(var_05,param_00,param_01,self);
		if(var_0B.size > 0)
		{
			var_07 = common_scripts\utility::func_7A33(var_0B);
			var_08 = 1;
		}
		else if(param_01 == "perk_ouch")
		{
			var_07 = level.var_A62B.var_90BE[var_05].var_0BB4[param_00][param_01];
		}
		else if(!lib_0547::func_5565(self.var_20D8,39))
		{
			return 0;
		}
	}

	if(isdefined(var_08))
	{
		if(lib_0547::func_5565(self.var_20D8,39))
		{
			thread lib_054E::func_717E(var_08,param_01,"zmb_char_callout",var_05,var_0B);
		}
		else
		{
			thread lib_054E::func_717E(var_08,param_01,param_02,var_05,var_0B);
		}
	}
	else if(lib_0547::func_5565(self.var_20D8,39))
	{
		thread lib_054E::func_717E(var_08,param_01,"zmb_char_callout",var_05,var_0B);
	}

	return 1;
}

//Function Id: 0x0000
//Function Number: 7
get_viable_gbl_aliases(param_00,param_01,param_02,param_03)
{
	var_04 = [];
	var_05 = [];
	var_06 = [param_02,param_02 + "1",param_02 + "2",param_02 + "3",param_02 + "4",param_02 + "5"];
	var_07 = param_03.var_20D8;
	var_08 = generate_possible_prefixes(var_07);
	var_09 = var_08[0];
	var_0A = var_08[1];
	var_0B = var_08[2];
	foreach(var_0D in var_06)
	{
		if(isdefined(level.var_A62B.var_90BE[param_00].var_0BB4[param_01][var_0D]))
		{
			var_0E = level.var_A62B.var_90BE[param_00].var_0BB4[param_01][var_0D];
			if(isdefined(var_0A) && var_0B.size > 0)
			{
				foreach(var_10 in var_0B)
				{
					if(function_0344(var_10 + var_0E) || function_0344(var_10 + var_0E + "_lo") || function_0344(var_10 + var_0E + "_md") || function_0344(var_10 + var_0E + "_hi"))
					{
						var_05[var_05.size] = var_10 + var_0E;
					}
				}
			}

			foreach(var_10 in var_09)
			{
				if(function_0344(var_10 + var_0E) || function_0344(var_10 + var_0E + "_lo") || function_0344(var_10 + var_0E + "_md") || function_0344(var_10 + var_0E + "_hi"))
				{
					var_04[var_04.size] = var_10 + var_0E;
				}
			}
		}
	}

	if(var_05.size > 0)
	{
		return var_05;
	}

	return var_04;
}

//Function Id: 0x0000
//Function Number: 8
generate_possible_prefixes(param_00)
{
	var_01 = [];
	var_02 = [];
	var_03 = [];
	var_04 = ["zmb_ship_gbl_","zmb_dlc_gbl_","zmb_dlc_gbl2_"];
	var_05 = lib_0378::dlg_get_char_name_callouts_from_index(param_00);
	if(isarray(var_05))
	{
		var_01 = var_05;
	}
	else
	{
		var_01 = [var_05];
	}

	var_06 = lib_0378::dlg_get_char_name_override_from_index(param_00);
	foreach(var_08 in var_04)
	{
		foreach(var_0A in var_01)
		{
			var_0B = var_08 + var_0A + "_";
			var_02 = common_scripts\utility::func_0F6F(var_02,var_0B);
		}

		if(isdefined(var_06))
		{
			var_0D = var_08 + var_06 + "_";
			var_02 = common_scripts\utility::func_0F6F(var_02,var_0D);
			var_03 = common_scripts\utility::func_0F6F(var_03,var_0D);
			if(lib_0547::func_5565(param_00,7))
			{
				var_03 = common_scripts\utility::func_0F6F(var_03,var_08 + "feml" + "_");
			}
		}
	}

	return [var_02,var_06,var_03];
}

//Function Id: 0x89B1
//Function Number: 9
lib_054E::func_89B1(param_00,param_01,param_02,param_03)
{
	if(level.var_744A.size == 1)
	{
		return;
	}

	if(!isdefined(param_03))
	{
		param_03 = lib_054E::func_464B(param_00);
	}

	if(isdefined(param_03) && isdefined(param_03.var_AB1D))
	{
		var_04 = level.var_A62B.var_90BE[param_03.var_AB1D].var_7DB9[param_01][param_02];
		if(isdefined(var_04))
		{
			param_03 lib_054E::func_277F(param_01,var_04);
		}
	}
}

//Function Id: 0x73AA
//Function Number: 10
lib_054E::func_73AA()
{
	self endon("disconnect");
	if(!isdefined(level.var_7337))
	{
		level.var_7337 = 0;
		level.var_05AC = lib_0547::func_4309();
	}

	for(;;)
	{
		wait 0.05;
		var_00 = gettime();
		if(var_00 > level.var_7337 + 1000)
		{
			level.var_7337 = var_00;
			level.var_05AC = lib_0547::func_4309();
		}

		var_01 = level.var_05AC;
		var_02 = 0;
		for(var_03 = 0;var_03 < var_01.size;var_03++)
		{
			if(!isdefined(var_01[var_03]) || !isdefined(var_01[var_03].var_0A4B) || !isdefined(var_01[var_03].var_0088) || var_01[var_03].var_0088 != self || common_scripts\utility::func_562E(var_01[var_03].var_8385))
			{
				continue;
			}

			var_04 = 200;
			var_05 = 50;
			if(isdefined(var_01[var_03].var_ABDF))
			{
				switch(var_01[var_03].var_ABDF)
				{
					case "walk":
						var_04 = 200;
						break;
	
					case "run":
						var_04 = 250;
						break;
	
					case "sprint":
						var_04 = 275;
						break;
				}
			}

			if(distancesquared(var_01[var_03].var_0116,self.var_0116) < var_04 * var_04)
			{
				var_06 = lib_054E::func_4742(var_01[var_03].var_0116);
				var_07 = self.var_0116[2] - var_01[var_03].var_0116[2];
				if(var_06 > -95 && var_06 < 95 && abs(var_07) < 50)
				{
					var_01[var_03].var_8385 = 1;
					var_08 = undefined;
					switch(var_01[var_03].var_0A4B)
					{
						case "zombie_fireman":
							var_08 = "firemansee";
							break;
	
						case "zombie_exploder":
							var_08 = "bombersee";
							break;
	
						case "zombie_berserker":
							var_08 = "sprintersee";
							break;
					}

					if(isdefined(var_08))
					{
						var_02 = lib_054E::func_277F("enemy",var_08);
					}

					break;
				}
			}
		}

		if(var_02)
		{
			wait(15);
		}
	}
}

//Function Id: 0x0000
//Function Number: 11
player_zombie_char_ambient_noises()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		if(lib_0547::func_5565(self.var_20D8,39) && !common_scripts\utility::func_562E(self.var_57DE))
		{
			switch(randomint(7))
			{
				case 0:
					self method_8617("zvox_gen_growl_lev1");
					break;
	
				default:
					break;
			}
		}

		wait(randomfloatrange(6,10));
	}
}

//Function Id: 0xA60C
//Function Number: 12
lib_054E::func_A60C(param_00,param_01)
{
	var_02 = tablelookup(level.var_AB17,0,param_00,1);
	if(!isdefined(var_02) || var_02 == "")
	{
		if(isdefined(param_01) && param_01 == "exert")
		{
			return 0.5;
		}
		else if(isdefined(param_01) && param_01 == "conversation")
		{
			return 3;
		}
		else
		{
			return 2;
		}
	}

	var_02 = int(var_02);
	var_02 = var_02 * 0.001;
	return var_02;
}

//Function Id: 0x4742
//Function Number: 13
lib_054E::func_4742(param_00)
{
	var_01 = param_00;
	var_02 = self.var_001D[1] - lib_054E::func_4740(var_01);
	var_02 = angleclamp180(var_02);
	return var_02;
}

//Function Id: 0x4740
//Function Number: 14
lib_054E::func_4740(param_00)
{
	var_01 = vectortoangles(param_00 - self.var_0116);
	return var_01[1];
}

//Function Id: 0x3102
//Function Number: 15
lib_054E::func_3102(param_00,param_01,param_02)
{
	lib_0366::func_8E4B(param_00);
}

//Function Id: 0x55AE
//Function Number: 16
lib_054E::func_55AE()
{
	if(lib_056D::func_45C2() <= 1)
	{
		return 1;
	}

	return 0;
}

//Function Id: 0xAB16
//Function Number: 17
lib_054E::func_AB16(param_00)
{
	if(param_00)
	{
		level.var_AB13++;
	}
	else
	{
		level.var_AB13--;
	}

	if(level.var_AB13 < 0)
	{
		level.var_AB13 = 0;
	}
}

//Function Id: 0x277E
//Function Number: 18
lib_054E::func_277E(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	self endon("death");
	self endon("disconnect");
	wait(param_05);
	thread lib_054E::func_277D(param_00,param_01,param_02,param_03,param_04,param_06);
}

//Function Id: 0x277D
//Function Number: 19
lib_054E::func_277D(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isdefined(self.var_AB1D))
	{
		return 0;
	}

	if(level.var_AB13 > 0 && param_00 != "global_priority")
	{
		return 0;
	}

	if(common_scripts\utility::func_562E(self.var_324E))
	{
		return 0;
	}

	if(lib_0547::func_577D(self) && param_01 != "infected" && param_01 != "sq")
	{
		return 0;
	}

	if(!isdefined(self.var_57DE))
	{
		self.var_57DE = 0;
	}

	if(common_scripts\utility::func_562E(self.var_57DE))
	{
		return 0;
	}

	if(lib_054E::func_0F55(param_00))
	{
		return 0;
	}

	var_07 = isdefined(param_02);
	var_08 = undefined;
	var_09 = undefined;
	var_0A = undefined;
	if(!isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_0BB4[param_00]) || !isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_0BB4[param_00][param_01]))
	{
		return 0;
	}

	if(!isdefined(param_04))
	{
		param_04 = 0;
	}

	if(!param_04 && !lib_054E::func_1F13(self.var_AB1D,param_00,param_01))
	{
		return 0;
	}

	var_0B = getarraykeys(level.var_A62B.var_90BE[self.var_AB1D].var_7677);
	var_0A = level.var_A62B.var_90BE[self.var_AB1D].var_7677[var_0B[0]];
	var_08 = level.var_A62B.var_90BE[self.var_AB1D].var_0BB4[param_00][param_01];
	if(isplayer(self))
	{
		if(self.var_0178 != "playing")
		{
			return 0;
		}

		if(lib_0547::func_577E(self) && param_01 != "revive_down" && param_01 != "revive_up" && param_01 != "bonus_line_over")
		{
			return 0;
		}

		var_09 = lib_0547::func_429D(self);
		var_0A = level.var_A62B.var_90BE[self.var_AB1D].var_7677[var_09];
	}

	var_0C = "";
	if(param_00 == "conversation")
	{
		if(!isdefined(param_03))
		{
			param_03 = 1;
		}

		var_0C = lib_054E::func_1D05("",var_08,param_03);
		if(!function_0344(var_0C))
		{
			return 0;
		}
	}
	else
	{
		if(var_07)
		{
			var_0D = param_02 + var_08;
			var_0E = "any_" + var_08;
			var_0F = lib_054E::func_AB1C(var_0A,var_0E,param_03);
			if(isdefined(var_0F) && function_0344(var_0F) && randomint(100) > 50)
			{
				var_08 = var_0E;
			}
			else
			{
				var_08 = var_0D;
			}
		}

		var_0F = lib_054E::func_AB1C(var_0D,var_0B,param_06);
		if(!isdefined(var_0F) && function_0344(var_0D + var_0B))
		{
			var_0F = var_0D + var_0B;
		}
	}

	if(isdefined(var_0F))
	{
		if(!function_0344(var_0F))
		{
			return 0;
		}

		thread lib_054E::func_30DC(var_0D,var_0C,var_0F,param_03,param_04,var_0A,var_08,param_06,var_09);
	}
	else
	{
		return 0;
	}

	return 1;
}

//Function Id: 0x30DC
//Function Number: 20
lib_054E::func_30DC(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self endon("disconnect");
	self endon("stopSpeaking");
	var_09 = 0.25;
	if(param_03 == "exert")
	{
		var_09 = 0;
	}

	self.var_90C4 = param_02;
	self.var_57DE = 1;
	self notify("speaking");
	lib_054E::func_74DB(param_02,param_03,param_04,param_08);
	if(var_09 > 0)
	{
		wait(var_09);
	}

	self notify("done_speaking");
	level notify("done_speaking");
	self.var_57DE = 0;
	if(param_03 == "conversation")
	{
		level thread lib_054E::func_87BB(self,param_01,param_03,param_04,param_06,param_07);
		return;
	}

	if(isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9) && isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9[param_03]) && isdefined(level.var_A62B.var_90BE[self.var_AB1D].var_7DB9[param_03][param_04]))
	{
		if(isdefined(level.var_05A7))
		{
			level thread [[ level.var_05A7 ]](self,param_01,param_03,param_04,param_06);
			return;
		}

		level thread lib_054E::func_89A9(self,param_01,param_03,param_04,param_06);
		return;
	}
}

//Function Id: 0x0F55
//Function Number: 21
lib_054E::func_0F55(param_00)
{
	return lib_054E::func_0F5A() && !common_scripts\utility::func_562E(self.var_509E) && param_00 != "global_priority" && param_00 != "exert" && param_00 != "conversation" && param_00 != "ignore_nearby" && param_00 != "sq";
}

//Function Id: 0xA7A1
//Function Number: 22
lib_054E::func_A7A1(param_00,param_01)
{
	while(param_00 lib_054E::func_0F5A())
	{
		wait 0.05;
	}
}

//Function Id: 0x734D
//Function Number: 23
lib_054E::func_734D()
{
	self notify("stopSpeaking");
	if(common_scripts\utility::func_562E(self.var_57DE) && isdefined(self.var_90C4))
	{
		self method_8613(self.var_90C4);
		self.var_57DE = 0;
	}
}

//Function Id: 0x464B
//Function Number: 24
lib_054E::func_464B(param_00)
{
	var_01 = 250000;
	var_02 = [];
	foreach(var_04 in level.var_744A)
	{
		if(!isdefined(var_04) || var_04 == param_00)
		{
			continue;
		}

		var_05 = distancesquared(param_00.var_0116,var_04.var_0116) < var_01;
		if(var_05)
		{
			var_02[var_02.size] = var_04;
		}
	}

	if(var_02.size == 1)
	{
		return var_02[0];
	}

	if(var_02.size > 1)
	{
		var_07 = randomintrange(0,var_02.size);
		return var_02[var_07];
	}
}

//Function Id: 0x89A9
//Function Number: 25
lib_054E::func_89A9(param_00,param_01,param_02,param_03,param_04)
{
	if(level.var_744A.size == 1)
	{
		return;
	}

	if(!isdefined(param_04))
	{
		param_04 = lib_054E::func_464B(param_00);
	}

	if(isdefined(param_04))
	{
		var_05 = level.var_A62B.var_90BE[param_04.var_AB1D].var_7DB9[param_02][param_03];
		if(isdefined(var_05))
		{
			var_06 = level.var_A62B.var_90BE[param_00.var_AB1D].var_7677[param_01];
			param_04 lib_054E::func_277D(param_02,var_05,var_06);
		}
	}
}

//Function Id: 0x87BB
//Function Number: 26
lib_054E::func_87BB(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(isdefined(param_04) && isalive(param_04))
	{
		param_04 lib_054E::func_277D(param_02,param_03,undefined,param_05 + 1,undefined,param_00);
	}
}

//Function Id: 0x72D2
//Function Number: 27
lib_054E::func_72D2(param_00,param_01,param_02,param_03)
{
	thread lib_054E::func_73A9(param_00,param_01,param_02,param_03);
}

//Function Id: 0x73A9
//Function Number: 28
lib_054E::func_73A9(param_00,param_01,param_02,param_03)
{
	self endon("disconnect");
	if(!isdefined(param_03) || common_scripts\utility::func_562E(self.var_3E09))
	{
		return;
	}

	param_02 = getweapondisplayname(param_02);
	var_04 = lib_054E::func_7479(param_00,param_01,param_02,param_03);
	if(isdefined(var_04))
	{
		self.var_3E09 = 1;
		wait(2);
		self.var_3E09 = 0;
	}
}

//Function Id: 0x1F13
//Function Number: 29
lib_054E::func_1F13(param_00,param_01,param_02)
{
	var_03 = lib_054E::func_417C(param_00,param_01,param_02);
	return var_03 > randomintrange(1,100);
}

//Function Id: 0x417C
//Function Number: 30
lib_054E::func_417C(param_00,param_01,param_02)
{
	if(!isdefined(level.var_A62B.var_90BE[param_00]) || !isdefined(level.var_A62B.var_90BE[param_00].var_20AD) || !isdefined(level.var_A62B.var_90BE[param_00].var_20AD[param_01]) || !isdefined(level.var_A62B.var_90BE[param_00].var_20AD[param_01][param_02]))
	{
		return 0;
	}

	return level.var_A62B.var_90BE[param_00].var_20AD[param_01][param_02];
}

//Function Id: 0x7479
//Function Number: 31
lib_054E::func_7479(param_00,param_01,param_02,param_03)
{
	var_04 = "kill";
	if(lib_0547::func_580B(param_02))
	{
		return;
	}

	if(isdefined(param_03.var_0A4B) && param_03.var_0A4B == "zombie_treasurer")
	{
		lib_054E::func_277F("enemy","treasurezombiewin");
	}
}

//Function Id: 0x9A08
//Function Number: 32
lib_054E::func_9A08(param_00,param_01)
{
	self endon("disconnect");
	self endon("death");
	var_02 = gettime() + param_01 * 1000;
	while(gettime() < var_02)
	{
		if(self.var_5A36 > param_00)
		{
			thread lib_054E::func_277E("kill","streak",undefined,undefined,undefined,1);
			wait(2);
			self.var_5A36 = 0;
			var_02 = -2;
		}

		wait(0.1);
	}

	wait(10);
	self.var_5A36 = 0;
	self.var_9A10 = 0;
}

//Function Id: 0x72A3
//Function Number: 33
lib_054E::func_72A3(param_00,param_01,param_02)
{
}

//Function Id: 0xABCD
//Function Number: 34
lib_054E::func_ABCD(param_00,param_01)
{
}

//Function Id: 0x741B
//Function Number: 35
lib_054E::func_741B()
{
	if(!isdefined(self.var_66C3) || gettime() > self.var_66C3)
	{
		var_00 = lib_054E::func_73DF("laugh");
		if(var_00)
		{
			self.var_66C3 = gettime() + 15000;
		}
	}
}

//Function Id: 0x72A4
//Function Number: 36
lib_054E::func_72A4(param_00)
{
	thread lib_054E::func_277E("general",param_00,undefined,undefined,undefined,1);
}

//Function Id: 0x0998
//Function Number: 37
lib_054E::func_0998(param_00)
{
	if(!isdefined(level.var_683F))
	{
		level.var_683F = [];
	}

	if(common_scripts\utility::func_562E(param_00))
	{
		self.var_509E = 1;
	}
	else
	{
		self.var_509E = 0;
	}

	self.var_575E = 1;
	level.var_683F[level.var_683F.size] = self;
}

//Function Id: 0x0F5A
//Function Number: 38
lib_054E::func_0F5A()
{
	var_00 = 1000000;
	var_01 = 0;
	var_02 = level.var_744A;
	if(isdefined(level.var_683F))
	{
		var_02 = common_scripts\utility::func_0F73(var_02,level.var_683F);
	}

	foreach(var_04 in var_02)
	{
		if(self == var_04)
		{
			continue;
		}

		if(isplayer(var_04))
		{
			if(var_04.var_0178 != "playing" || lib_0547::func_577E(var_04))
			{
				continue;
			}
		}
		else
		{
		}

		if(common_scripts\utility::func_562E(var_04.var_57DE) && !common_scripts\utility::func_562E(var_04.var_509E))
		{
			if(distancesquared(self.var_0116,var_04.var_0116) < var_00)
			{
				var_01 = 1;
				break;
			}
		}
	}

	return var_01;
}

//Function Id: 0xAB1B
//Function Number: 39
lib_054E::func_AB1B()
{
	var_00 = spawnstruct();
	var_00.var_90BE = [];
	return var_00;
}

//Function Id: 0xAB1E
//Function Number: 40
lib_054E::func_AB1E(param_00,param_01,param_02,param_03)
{
	param_02.var_AB1D = param_00;
	if(!isdefined(self.var_90BE[param_00]))
	{
		self.var_90BE[param_00] = spawnstruct();
		self.var_90BE[param_00].var_0BB4 = [];
		self.var_90BE[param_00].var_7677 = [];
		self.var_90BE[param_00].var_37E4 = [];
	}

	self.var_90BE[param_00].var_37E4[param_03] = param_02;
	self.var_90BE[param_00].var_7677[param_03] = param_01;
}

//Function Id: 0xAB1A
//Function Number: 41
lib_054E::func_AB1A(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isdefined(self.var_90BE[param_00]))
	{
		self.var_90BE[param_00] = spawnstruct();
		self.var_90BE[param_00].var_0BB4 = [];
		self.var_90BE[param_00].var_7677 = [];
		self.var_90BE[param_00].var_37E4 = [];
	}

	if(!isdefined(self.var_90BE[param_00].var_0BB4[param_01]))
	{
		self.var_90BE[param_00].var_0BB4[param_01] = [];
	}

	self.var_90BE[param_00].var_0BB4[param_01][param_02] = param_03;
	if(isdefined(param_04))
	{
		if(!isdefined(self.var_90BE[param_00].var_7DB9))
		{
			self.var_90BE[param_00].var_7DB9 = [];
		}

		if(!isdefined(self.var_90BE[param_00].var_7DB9[param_01]))
		{
			self.var_90BE[param_00].var_7DB9[param_01] = [];
		}

		self.var_90BE[param_00].var_7DB9[param_01][param_02] = param_04;
	}

	if(!isdefined(param_05))
	{
		param_05 = 100;
	}

	if(!isdefined(self.var_90BE[param_00].var_20AD))
	{
		self.var_90BE[param_00].var_20AD = [];
	}

	if(!isdefined(self.var_90BE[param_00].var_20AD[param_01]))
	{
		self.var_90BE[param_00].var_20AD[param_01] = [];
	}

	self.var_90BE[param_00].var_20AD[param_01][param_02] = param_05;
}

//Function Id: 0x1D05
//Function Number: 42
lib_054E::func_1D05(param_00,param_01,param_02)
{
	if(param_02 < 10)
	{
		return param_00 + param_01 + "_0" + param_02;
	}

	return param_00 + param_01 + "_" + param_02;
}

//Function Id: 0xAB1C
//Function Number: 43
lib_054E::func_AB1C(param_00,param_01,param_02)
{
	if(!isdefined(self.var_8F2E))
	{
		self.var_8F2E = [];
		self.var_8F2F = [];
	}

	if(!isdefined(self.var_8F2E[param_01]))
	{
		var_03 = lib_054E::func_4255(param_00,param_01);
		if(var_03 <= 0)
		{
			return undefined;
		}

		for(var_04 = 0;var_04 < var_03;var_04++)
		{
			self.var_8F2E[param_01][var_04] = var_04 + 1;
		}

		self.var_8F2F[param_01] = [];
	}

	if(self.var_8F2F[param_01].size <= 0)
	{
		for(var_04 = 0;var_04 < self.var_8F2E[param_01].size;var_04++)
		{
			self.var_8F2F[param_01][var_04] = self.var_8F2E[param_01][var_04];
		}
	}

	var_05 = common_scripts\utility::func_7A33(self.var_8F2F[param_01]);
	self.var_8F2F[param_01] = common_scripts\utility::func_0F93(self.var_8F2F[param_01],var_05);
	if(isdefined(param_02))
	{
		var_05 = param_02;
	}

	return lib_054E::func_1D05(param_00,param_01,var_05);
}

//Function Id: 0x74DB
//Function Number: 44
lib_054E::func_74DB(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_01) && param_01 == "monologue")
	{
		self method_8615(param_00);
	}
	else if(isdefined(param_03) && param_03.size > 0)
	{
		foreach(var_05 in param_03)
		{
			if(isdefined(var_05))
			{
				self method_860F(param_00,var_05,1);
			}
		}
	}
	else
	{
		self playsoundonmovingent(param_00);
	}

	var_07 = lib_054E::func_A60C(param_00,param_01);
	wait(var_07);
}

//Function Id: 0x4255
//Function Number: 45
lib_054E::func_4255(param_00,param_01)
{
	for(var_02 = 1;var_02 < 30;var_02++)
	{
		if(!function_0344(lib_054E::func_1D05(param_00,param_01,var_02)))
		{
			return var_02 - 1;
		}
	}
}

//Function Id: 0x714C
//Function Number: 46
lib_054E::func_714C()
{
	level thread lib_054E::func_8A52();
	wait(1);
	if(isdefined(level.var_AB0F))
	{
		level thread [[ level.var_AB0F ]]();
	}
	else if(level.var_744A.size == 1)
	{
		var_00 = randomintrange(0,level.var_744A.size);
		level.var_744A[var_00] thread lib_054E::func_277D("general","intro");
	}
	else
	{
		level thread lib_054E::func_74EA("wave1",1,2,0,3);
	}

	level.var_AB3E = 0;
	for(;;)
	{
		level waittill("zombie_wave_started");
		wait(1);
		var_01 = 1;
		if(isdefined(level.var_AB10))
		{
			var_01 = [[ level.var_AB10 ]](var_01);
		}
		else
		{
			if(!var_01 && level.var_A980 == 2)
			{
				lib_054E::func_74EA("wave2",2,0,1,3);
				var_01 = 1;
			}
			else if(!var_01 && level.var_A980 == 5 || level.var_A980 == 10 || level.var_A980 == 20 || level.var_A980 == 35 || level.var_A980 == 50)
			{
				var_00 = randomintrange(0,level.var_744A.size);
				level.var_744A[var_00] lib_054E::func_277D("general","round_" + level.var_A980);
				var_01 = 1;
			}

			if(!var_01 && level.var_A980 > 2 && !level.var_AB3E)
			{
				var_02 = randomintrange(0,100);
				if(var_02 < 30)
				{
					lib_054E::func_74EA("wave_early",0,2,1,3);
					level.var_AB3E = 0;
					var_01 = 1;
				}
			}
		}

		if(!var_01 && level.var_A980 > 1)
		{
			var_00 = randomintrange(0,level.var_744A.size);
			level.var_744A[var_00] lib_054E::func_277D("general","wave_start");
			var_01 = 1;
		}

		level waittill("zombie_wave_ended");
		var_03 = 1;
		var_04 = 0;
		if(isdefined(level.var_AB12))
		{
			var_03 = [[ level.var_AB12 ]]();
		}

		if(var_03)
		{
			wait(1);
			var_00 = randomintrange(0,level.var_744A.size);
			var_04 = level.var_744A[var_00] lib_054E::func_277D("general","wave_end");
			if(var_04)
			{
				level.var_744A[var_00] common_scripts\utility::func_A74B("done_speaking",6);
				wait(1);
			}
		}

		if(isdefined(level.var_AB1F))
		{
			var_04 = [[ level.var_AB1F ]](var_04);
		}

		if(!lib_054E::func_74ED() && !var_04)
		{
			lib_054E::func_74E9();
		}
	}
}

//Function Id: 0x74EA
//Function Number: 47
lib_054E::func_74EA(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(!isdefined(param_05))
	{
		param_05 = "general";
	}

	var_06 = lib_054E::func_4454(param_01);
	if(isdefined(var_06) && var_06 lib_054E::func_277D(param_05,param_00))
	{
		level common_scripts\utility::func_A74B("done_speaking",6);
	}

	var_06 = lib_054E::func_4454(param_02);
	if(isdefined(var_06) && var_06 lib_054E::func_277D(param_05,param_00))
	{
		level common_scripts\utility::func_A74B("done_speaking",6);
	}

	var_06 = lib_054E::func_4454(param_03);
	if(isdefined(var_06) && var_06 lib_054E::func_277D(param_05,param_00))
	{
		level common_scripts\utility::func_A74B("done_speaking",6);
	}

	var_06 = lib_054E::func_4454(param_04);
	if(isdefined(var_06) && var_06 lib_054E::func_277D(param_05,param_00))
	{
		level common_scripts\utility::func_A74B("done_speaking",6);
	}
}

//Function Id: 0x74ED
//Function Number: 48
lib_054E::func_74ED()
{
	if(level.var_A980 == 2)
	{
		var_00 = lib_054E::func_462C();
		if(isdefined(var_00))
		{
			return var_00 lib_054E::func_277D("general","weapon_reminder",undefined,1);
		}
	}
	else if(level.var_A980 == 10)
	{
		var_00 = lib_054E::func_462B();
		if(isdefined(var_00))
		{
			return var_00 lib_054E::func_277D("general","weapon_reminder",undefined,2);
		}
	}

	return 0;
}

//Function Id: 0x462C
//Function Number: 49
lib_054E::func_462C()
{
	foreach(var_01 in level.var_744A)
	{
		var_02 = var_01 getweaponslistprimaries();
		if(var_02.size == 1 && var_02[0] == "iw5_titan45zm_mp")
		{
			return var_01;
		}
	}
}

//Function Id: 0x7449
//Function Number: 50
lib_054E::func_7449(param_00)
{
	foreach(var_02 in level.var_744A)
	{
		var_02 lib_054E::func_277F("general",param_00);
	}
}

//Function Id: 0x9D3A
//Function Number: 51
lib_054E::func_9D3A(param_00,param_01)
{
	if(param_01)
	{
		lib_054E::func_277F("enemy","treasurezombiewin");
		return;
	}

	lib_054E::func_277F("enemy","treasurezombiefail");
}

//Function Id: 0x9D39
//Function Number: 52
lib_054E::func_9D39()
{
	lib_054E::func_277F("enemy","treasurezombiewarn");
}

//Function Id: 0x7465
//Function Number: 53
lib_054E::func_7465()
{
	lib_054E::func_277F("enemy","treasurezombieseen");
	lib_054E::func_277F("enemy","treasurezombiemove");
}

//Function Id: 0x18EC
//Function Number: 54
lib_054E::func_18EC()
{
	lib_054E::func_277F("enemy","bomberkillshot");
}

//Function Id: 0x73B3
//Function Number: 55
lib_054E::func_73B3()
{
	lib_054E::func_2780(1,"enemy","followeranger");
}

//Function Id: 0x462B
//Function Number: 56
lib_054E::func_462B()
{
	foreach(var_01 in level.var_744A)
	{
		var_02 = var_01 getweaponslistprimaries();
		foreach(var_04 in var_02)
		{
			if(lib_0547::func_4747(var_01,var_04) < 1)
			{
				return var_01;
			}
		}
	}
}

//Function Id: 0x8A52
//Function Number: 57
lib_054E::func_8A52()
{
	level.var_AB49 = [];
	level.var_AB49[0] = lib_054E::func_66A0();
	level.var_AB49[1] = lib_054E::func_66A0();
}

//Function Id: 0x66A0
//Function Number: 58
lib_054E::func_66A0()
{
	var_00 = spawnstruct();
	var_00.var_20D9 = [];
	var_00.var_7677 = [];
	var_00.var_83EB = 1;
	var_00.var_08BE = 0;
	var_00.var_2566 = 0;
	var_00.var_66CB = 1;
	return var_00;
}

//Function Id: 0x74E9
//Function Number: 59
lib_054E::func_74E9()
{
	if(level.var_744A.size == 1 || !isdefined(level.var_A62B.var_90BE["player"].var_0BB4["conversation"]))
	{
		return 0;
	}

	foreach(var_01 in level.var_AB49)
	{
		if(lib_054E::func_2EBF(var_01) && lib_054E::func_7211(var_01))
		{
			lib_054E::func_2EC1(var_01);
			return 1;
		}
	}

	foreach(var_01 in level.var_AB49)
	{
		if(!var_01.var_08BE && lib_054E::func_27E1(var_01))
		{
			if(lib_054E::func_7211(var_01))
			{
				lib_054E::func_2EC1(var_01);
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}

	return 0;
}

//Function Id: 0x2EBF
//Function Number: 60
lib_054E::func_2EBF(param_00)
{
	return param_00.var_08BE && param_00.var_66CB <= level.var_A980 && lib_054E::func_2EC0(param_00);
}

//Function Id: 0x2EC0
//Function Number: 61
lib_054E::func_2EC0(param_00)
{
	if(param_00.var_20D9.size != 2)
	{
		return 0;
	}

	foreach(var_02 in param_00.var_20D9)
	{
		if(!isdefined(var_02) || !maps\mp\_utility::func_57A0(var_02))
		{
			return 0;
		}
	}

	return 1;
}

//Function Id: 0x2EC1
//Function Number: 62
lib_054E::func_2EC1(param_00)
{
	param_00.var_66CB = param_00.var_66CB + randomintrange(2,4);
	param_00.var_83EB++;
}

//Function Id: 0x7401
//Function Number: 63
lib_054E::func_7401()
{
	foreach(var_01 in level.var_AB49)
	{
		if(common_scripts\utility::func_0F79(var_01.var_20D9,self))
		{
			return 1;
		}
	}

	return 0;
}

//Function Id: 0x27E1
//Function Number: 64
lib_054E::func_27E1(param_00)
{
	var_01 = common_scripts\utility::func_0F92(level.var_744A);
	var_02 = undefined;
	var_03 = undefined;
	foreach(var_05 in var_01)
	{
		if(!var_05 lib_054E::func_7401())
		{
			if(!isdefined(var_02))
			{
				var_02 = var_05;
			}
			else
			{
				var_03 = var_05;
			}
		}

		if(isdefined(var_02) && isdefined(var_03))
		{
			break;
		}
	}

	if(!isdefined(var_02) || !isdefined(var_03))
	{
		return 0;
	}

	param_00.var_20D9[0] = var_02;
	param_00.var_20D9[1] = var_03;
	param_00.var_7677[0] = level.var_A62B.var_90BE[var_02.var_AB1D].var_7677[lib_0547::func_429D(var_02)];
	param_00.var_7677[1] = level.var_A62B.var_90BE[var_03.var_AB1D].var_7677[lib_0547::func_429D(var_03)];
	param_00.var_08BE = 1;
	param_00.var_2566 = 0;
	return 1;
}

//Function Id: 0x7211
//Function Number: 65
lib_054E::func_7211(param_00)
{
	var_01 = "" + param_00.var_7677[0] + param_00.var_7677[1] + param_00.var_83EB;
	var_02 = param_00.var_20D9[0];
	var_03 = param_00.var_20D9[1];
	if(!isdefined(level.var_A62B.var_90BE["player"].var_0BB4["conversation"][var_01]))
	{
		var_01 = "" + param_00.var_7677[1] + param_00.var_7677[0] + param_00.var_83EB;
		var_02 = param_00.var_20D9[1];
		var_03 = param_00.var_20D9[0];
		if(!isdefined(level.var_A62B.var_90BE["player"].var_0BB4["conversation"][var_01]))
		{
			param_00.var_2566 = 1;
			return 0;
		}
	}

	return var_02 lib_054E::func_277D("conversation",var_01,undefined,undefined,undefined,var_03);
}

//Function Id: 0x4454
//Function Number: 66
lib_054E::func_4454(param_00)
{
	foreach(var_02 in level.var_744A)
	{
		if(var_02.var_20D8 == param_00)
		{
			return var_02;
		}
	}
}

//Function Id: 0x4456
//Function Number: 67
lib_054E::func_4456(param_00)
{
	switch(param_00)
	{
		case "jeff":
			return 0;

		case "dros":
			return 1;

		case "mari":
			return 2;

		case "oliv":
			return 3;
	}
}

//Function Id: 0x4455
//Function Number: 68
lib_054E::func_4455(param_00)
{
	return lib_054E::func_4454(lib_054E::func_4456(param_00));
}

//Function Id: 0x441D
//Function Number: 69
lib_054E::func_441D(param_00)
{
	var_01 = lib_054E::func_4455(param_00);
	if(!isdefined(var_01))
	{
		return level.var_744A[randomint(level.var_744A.size)];
	}

	var_02 = common_scripts\utility::func_0F92(level.var_744A);
	foreach(var_04 in level.var_744A)
	{
		if(var_04 != var_01)
		{
			return var_04;
		}
	}
}

//Function Id: 0xAB3D
//Function Number: 70
lib_054E::func_AB3D()
{
	var_00 = randomintrange(0,3);
	lib_054E::func_734D();
	lib_054E::func_746A();
	lib_054E::func_73DF("death" + var_00);
}

//Function Id: 0xAB3C
//Function Number: 71
lib_054E::func_AB3C(param_00)
{
	if(isdefined(self.var_29AB) && self.var_29AB + 5000 > param_00)
	{
		return;
	}

	if(!common_scripts\utility::func_562E(self.var_56E2))
	{
		self.var_29AB = param_00;
		var_01 = randomintrange(0,3);
		lib_054E::func_734D();
		lib_054E::func_73DF("pain" + var_01);
	}
}

//Function Id: 0x73DF
//Function Number: 72
lib_054E::func_73DF(param_00)
{
	return 0;
}

//Function Id: 0x746A
//Function Number: 73
lib_054E::func_746A()
{
	self notify("stopExerting");
	self.var_56E2 = undefined;
}

//Function Id: 0x38E0
//Function Number: 74
lib_054E::func_38E0()
{
	self endon("disconnect");
	self endon("stopExerting");
	wait(1);
	self.var_56E2 = 1;
	wait(randomfloatrange(1.5,3));
	self.var_56E2 = undefined;
}

//Function Id: 0x743B
//Function Number: 75
lib_054E::func_743B()
{
}

//Function Id: 0x743A
//Function Number: 76
lib_054E::func_743A()
{
}

//Function Id: 0x7448
//Function Number: 77
lib_054E::func_7448(param_00)
{
	wait(1);
	if(self == param_00)
	{
		return;
	}

	if(param_00 lib_0547::func_4BA7("specialty_class_covert_exfiltration_zm") && common_scripts\utility::func_562E(param_00.var_569F))
	{
		var_01 = param_00 lib_054E::func_277F("mod_use","mod_covertexfiltration",undefined,undefined,self);
		return;
	}

	var_01 = param_00 lib_054E::func_277F("general","revive_ally",undefined,undefined,self);
}

//Function Id: 0x741A
//Function Number: 78
lib_054E::func_741A()
{
	wait(1);
}

//Function Id: 0x7486
//Function Number: 79
lib_054E::func_7486(param_00)
{
	var_01 = "";
	var_02 = "ability";
	switch(param_00)
	{
		case "role_ability_mad_minute_zm":
			var_01 = "special_mad";
			break;

		case "role_ability_camo_zm":
			var_01 = "special_camo";
			break;

		case "role_ability_stunning_burst_zm":
			var_01 = "special_burst";
			break;

		case "role_ability_taunt_zm":
			var_01 = "special_taunt";
			break;

		case "role_ability_melee_frenzy_zm":
			var_01 = "special_mad";
			break;
	}

	var_03 = lib_054E::func_73C4(var_02,var_01);
	var_02 = var_03[0];
	var_01 = var_03[1];
	lib_054E::func_277F(var_02,var_01);
}

//Function Id: 0x73C4
//Function Number: 80
lib_054E::func_73C4(param_00,param_01)
{
	var_02 = param_01;
	if(param_01 == "special_camo")
	{
		if(lib_0547::func_4BA7("specialty_class_serrated_edge_zm"))
		{
			param_01 = "mod_serratededge";
		}
		else if(lib_0547::func_4BA7("specialty_class_saboteur_zm") && playerismaincast())
		{
			param_01 = "mod_saboteur";
		}
		else if(lib_0547::func_4BA7("specialty_class_mobilization_zm") && playerismaincast() || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"slay") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"mount") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"hunt") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"surv"))
		{
			param_01 = "mod_enhancedspeed";
		}
	}
	else if(param_01 == "special_mad")
	{
		if(lib_0547::func_4BA7("specialty_class_ammo_carrier_zm") && level.var_744A.size > 1)
		{
			param_01 = "mod_supplyammo";
		}
		else if(lib_0547::func_4BA7("specialty_class_squad_tactics_zm"))
		{
			param_01 = "mod_headshot";
		}
	}
	else if(param_01 == "special_burst")
	{
		if(lib_0547::func_4BA7("specialty_class_bolster_morale_zm") && level.var_744A.size > 1 && lib_054E::func_73C3() && playerismaincast())
		{
			param_01 = "mod_supplyarmor";
		}
		else if(lib_0547::func_4BA7("specialty_class_fiery_burst_zm"))
		{
			param_01 = "mod_fieryburst";
		}
		else if(lib_0547::func_4BA7("specialty_class_exploit_weakness_zm") && playerismaincast() || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"slay") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"mount") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"hunt") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"surv"))
		{
			param_01 = "mod_exploitweakness";
		}
	}
	else if(param_01 == "special_taunt")
	{
		if(lib_0547::func_4BA7("specialty_class_team_effort_zm") && level.var_744A.size > 1)
		{
			param_01 = "mod_teameffort";
		}
		else if(lib_0547::func_4BA7("specialty_class_come_get_zm"))
		{
			param_01 = "mod_comeandgetit";
		}
		else if(lib_0547::func_4BA7("specialty_class_counter_offensive_zm") && playerismaincast() || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"slay") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"mount") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"hunt") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"surv"))
		{
			param_01 = "mod_counteroffensive";
		}
	}
	else if(param_01 == "special_melee")
	{
	}

	if(param_01 != var_02)
	{
		param_00 = "mod_use";
	}

	return [param_00,param_01];
}

//Function Id: 0x0000
//Function Number: 81
playerismaincast()
{
	if(lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"dros") || lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"jeff") || lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"mari") || lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"oliv"))
	{
		return 1;
	}

	return 0;
}

//Function Id: 0x73C3
//Function Number: 82
lib_054E::func_73C3()
{
	var_00 = 0;
	var_01 = 518400;
	if(common_scripts\utility::func_562E(lib_0547::func_4BA7("specialty_class_breathing_room_zm")) && !common_scripts\utility::func_562E(lib_0547::func_4BA7("specialty_class_sustain_zone_zm")))
	{
		var_01 = var_01 * 2.25;
	}
	else if(!common_scripts\utility::func_562E(lib_0547::func_4BA7("specialty_class_breathing_room_zm")) && common_scripts\utility::func_562E(lib_0547::func_4BA7("specialty_class_sustain_zone_zm")))
	{
		var_01 = var_01 * 0.25;
	}

	foreach(var_03 in level.var_744A)
	{
		if(var_03 == self)
		{
			continue;
		}

		if(lib_0547::func_577E(var_03))
		{
			continue;
		}

		if(distancesquared(self.var_0116,var_03.var_0116) < var_01)
		{
			if(bullettracepassed(var_03 geteye(),self geteye(),0,undefined))
			{
				var_00 = 1;
			}
		}
	}

	return var_00;
}

//Function Id: 0x0695
//Function Number: 83
lib_054E::func_0695(param_00)
{
	if(!common_scripts\utility::func_562E(self.var_3E08))
	{
		self.var_3E08 = 1;
		lib_054E::func_277F("general",param_00);
		wait(10);
		self.var_3E08 = undefined;
	}
}

//Function Id: 0x745A
//Function Number: 84
lib_054E::func_745A(param_00)
{
	if(level.var_744A.size > 1)
	{
		lib_054E::func_277F("general",param_00);
	}
}

//Function Id: 0x73B9
//Function Number: 85
lib_054E::func_73B9(param_00,param_01)
{
	var_02 = "perk_ouch";
	if(isshipzombiesmap())
	{
		if(common_scripts\utility::func_562E(param_01))
		{
			var_02 = "perk_first";
			if(param_00 == "electriccherry" && lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"jeff") || lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"mari"))
			{
				var_02 = "perk_shock";
			}
			else if(param_00 == "punchperk" && lib_0547::func_5565(lib_0378::func_307B(self.var_20D8),"jeff"))
			{
				var_02 = "perk_punch";
			}
		}
	}
	else if(common_scripts\utility::func_562E(param_01))
	{
		var_02 = "perk_first";
	}
	else
	{
		switch(param_00)
		{
			case "electriccherry":
				var_02 = "perk_shock";
				break;

			case "punchperk":
				var_02 = "perk_punch";
				break;

			case "fastreload":
				var_02 = "perk_reload";
				break;

			case "runperk":
				var_02 = "perk_run";
				break;

			case "quickrevive":
				if(lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"slay") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"mount") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"hunt") || lib_0547::func_5565(lib_0378::dlg_get_char_name_override_from_index(self.var_20D8),"surv"))
				{
					var_02 = "perk_ouch";
				}
				else
				{
					var_02 = "perk_revive";
				}
				break;

			case "doubletap":
				var_02 = "perk_damage";
				break;
		}
	}

	lib_054E::func_277F("perk",var_02);
}

//Function Id: 0x0000
//Function Number: 86
playeruselostandfound()
{
	if(isshipzombiesmap())
	{
		return;
	}

	lib_054E::func_277F("general","lost_and_found");
}

//Function Id: 0x0000
//Function Number: 87
playerbuyweapon(param_00)
{
	if(isshipzombiesmap())
	{
		return;
	}

	if(common_scripts\utility::func_562E(param_00))
	{
		lib_054E::func_277F("general","newpackweapon");
		return;
	}

	lib_054E::func_277F("general","newweapon");
}

//Function Id: 0x0000
//Function Number: 88
playeruseconsumableweapon()
{
	if(isshipzombiesmap())
	{
		return;
	}

	lib_054E::func_277F("general","consumableweapon");
}

//Function Id: 0x0000
//Function Number: 89
isshipzombiesmap()
{
	var_00 = maps\mp\_utility::func_4571();
	if(var_00 == "mp_zombie_nest_01" || var_00 == "mp_zombie_house" || var_00 == "mp_zombie_training")
	{
		return 1;
	}

	return 0;
}

//Function Id: 0x7491
//Function Number: 90
lib_054E::func_7491(param_00,param_01)
{
}

//Function Id: 0x73E4
//Function Number: 91
lib_054E::func_73E4()
{
}

//Function Id: 0x62D9
//Function Number: 92
lib_054E::func_62D9()
{
	self method_8615("interact_purchase");
	lib_0378::func_8D74("money_spend");
}