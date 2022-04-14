/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1404.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 39 ms
 * Timestamp: 8/24/2021 10:29:33 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_057C::func_00D5()
{
	if(isdefined(level.var_5FEC))
	{
		[[ level.var_5FEC ]]();
	}

	level thread lib_057B::func_00D5();
	level thread lib_057C::func_398E();
	level.var_5A7D["orbital_carepackage_pod_zm_mp"] = "carepackage";
	level.var_69A6 = "orbital_carepackage_pod_zm_mp";
	level thread lib_057C::func_7F1C();
}

//Function Id: 0x398E
//Function Number: 2
lib_057C::func_398E()
{
	level.var_9852["allies"] = 0;
	level.var_9852["axis"] = 0;
	level.var_6C25 = 0;
	level.var_6241 = [];
}

//Function Id: 0x1A4E
//Function Number: 3
lib_057C::func_1A4E()
{
	var_00 = gettime();
	if(!isdefined(level.var_5A59))
	{
		maps/mp/bots/_bots_ks::func_1AB3("zm_squadmate",::maps/mp/bots/_bots_ks::func_1A50);
		maps/mp/bots/_bots_ks::func_1AB3("uav",::maps/mp/bots/_bots_ks::func_1A4B,::maps/mp/bots/_bots_ks::func_1A3E);
		maps/mp/bots/_bots_ks::func_1AB3("carepackage",::maps/mp/bots/_bots_ks::func_1A4B,::maps/mp/bots/_bots_ks::func_1A3E);
		maps/mp/bots/_bots_ks::func_1AB3("missile_strike",::maps/mp/bots/_bots_ks::func_1A4B,::maps/mp/bots/_bots_ks::func_1A3E);
		maps/mp/bots/_bots_ks::func_1AB3("airstrike",::maps/mp/bots/_bots_ks::func_1A4B,::maps/mp/bots/_bots_ks::func_1A3E);
	}
}

//Function Id: 0x0B81
//Function Number: 4
lib_057C::func_0B81()
{
}

//Function Id: 0x809C
//Function Number: 5
lib_057C::func_809C()
{
	var_00 = undefined;
	if(isdefined(level.var_AB45) && level.var_AB45.size > 0)
	{
		var_00 = level.var_AB45[level.var_AB45.size - 1];
	}

	level.var_AB45 = [];
	level.var_AB44 = 0;
	var_01 = [];
	if(isdefined(level.var_AB30))
	{
		var_01 = [[ level.var_AB30 ]]();
	}
	else
	{
		var_01[var_01.size] = "sentry_" + randomintrange(1,4);
		var_01[var_01.size] = "drone_" + randomintrange(1,3);
		var_01[var_01.size] = "money";
		var_01[var_01.size] = "camo";
		var_01[var_01.size] = "sentry_" + randomintrange(1,4);
		var_01[var_01.size] = "drone_" + randomintrange(1,3);
		var_01[var_01.size] = "money";
		var_01[var_01.size] = "camo";
	}

	var_01 = common_scripts\utility::func_0F92(var_01);
	var_02 = var_01.size;
	for(var_03 = 0;var_03 < var_02;var_03++)
	{
		var_04 = lib_057C::func_45AC(var_01,var_02,var_00);
		if(var_04 != -1)
		{
			level.var_AB45[level.var_AB45.size] = var_01[var_04];
			var_00 = var_01[var_04];
			var_01[var_04] = undefined;
			continue;
		}

		level.var_AB45[level.var_AB45.size] = level.var_AB45[0];
		var_04 = getarraykeys(var_01)[0];
		level.var_AB45[0] = var_01[var_04];
	}
}

//Function Id: 0x45AC
//Function Number: 6
lib_057C::func_45AC(param_00,param_01,param_02)
{
	if(isdefined(param_02))
	{
		var_03 = strtok(param_02,"_");
		param_02 = var_03[0];
	}

	for(var_04 = 0;var_04 < param_01;var_04++)
	{
		var_05 = param_00[var_04];
		if(isdefined(var_05))
		{
			if(!isdefined(param_02))
			{
				return var_04;
			}
			else
			{
				var_03 = strtok(var_05,"_");
				var_05 = var_03[0];
				if(var_05 != param_02)
				{
					return var_04;
				}
			}
		}
	}

	return -1;
}

//Function Id: 0x8A17
//Function Number: 7
lib_057C::func_8A17()
{
	level.var_AB20 = common_scripts\utility::func_46B7("carepackageDropPosition","targetname");
	foreach(var_01 in level.var_AB20)
	{
		var_01.var_510A = isdefined(var_01.var_8260) && var_01.var_8260 == "indoors";
		var_01.var_4882 = var_01.var_0116;
		if(var_01.var_510A)
		{
			var_02 = var_01.var_0116;
			var_03 = var_01.var_0116 + (0,0,-10000);
			var_04 = bullettrace(var_02,var_03,0);
			var_01.var_4882 = var_04["position"];
		}

		wait 0.05;
	}
}

//Function Id: 0x809B
//Function Number: 8
lib_057C::func_809B()
{
	var_00 = [];
	var_00[var_00.size] = 100;
	var_00[var_00.size] = 100;
	var_00[var_00.size] = 300;
	var_00[var_00.size] = 400;
	var_00[var_00.size] = 600;
	var_00[var_00.size] = 700;
	var_00[var_00.size] = 800;
	var_00[var_00.size] = 1000;
	level.var_AB38 = common_scripts\utility::func_0F92(var_00);
	level.var_AB39 = 0;
}

//Function Id: 0x45A8
//Function Number: 9
lib_057C::func_45A8()
{
	if(level.var_AB38.size == level.var_AB39)
	{
		lib_057C::func_809B();
	}

	var_00 = level.var_AB38[level.var_AB39];
	level.var_AB39++;
	return var_00;
}

//Function Id: 0x7F1C
//Function Number: 10
lib_057C::func_7F1C()
{
	level.var_AB20 = common_scripts\utility::func_46B7("carepackageDropPosition","targetname");
	if(level.var_AB20.size == 0)
	{
		return;
	}

	level.var_AB47 = [];
	level.var_4477 = ::lib_057C::func_4476;
	level.var_AB34 = 0;
	level.var_AB35 = 0;
	level.var_AB33 = 0;
	thread lib_057C::func_8A17();
	thread lib_057C::func_809C();
	thread lib_057C::func_809B();
	var_00 = randomintrange(3,5);
	for(;;)
	{
		level waittill("zombie_wave_started");
		while(level.var_A980 >= var_00)
		{
			var_01 = randomfloatrange(20,30);
			var_02 = level common_scripts\utility::func_A74D("zombie_wave_ended",var_01);
			if(!isdefined(var_02) || var_02 != "timeout")
			{
				continue;
			}

			if(isdefined(level.var_671D) && level.var_671D == 1)
			{
				continue;
			}

			var_02 = lib_057C::func_3493();
			if(isdefined(var_02))
			{
				if(isdefined(level.var_7F25))
				{
					level.var_7F25[level.var_7F25.size] = var_02;
				}

				if(level.var_744A.size == 4)
				{
					var_02 = lib_057C::func_3493();
					if(isdefined(var_02) && isdefined(level.var_7F25))
					{
						level.var_7F25[level.var_7F25.size] = var_02;
					}
				}

				var_00 = var_00 + randomintrange(2,4);
			}
		}

		level waittill("zombie_wave_ended");
	}
}

//Function Id: 0x4460
//Function Number: 11
lib_057C::func_4460(param_00)
{
	var_01 = function_01AC(level.var_744A,param_00);
	return var_01[0];
}

//Function Id: 0x4476
//Function Number: 12
lib_057C::func_4476(param_00)
{
	if(level.var_AB45.size == level.var_AB44)
	{
		lib_057C::func_809C();
	}

	var_04 = level.var_AB45[level.var_AB44];
	level.var_AB44++;
	return var_04;
}

//Function Id: 0x3493
//Function Number: 13
lib_057C::func_3493(param_00)
{
	var_01 = lib_057C::func_45F6();
	if(!isdefined(var_01))
	{
		return;
	}

	if(!isdefined(param_00))
	{
		param_00 = lib_057C::func_4478(var_01);
	}

	if(!isdefined(param_00))
	{
		return;
	}

	if(!param_00.var_510A)
	{
		var_02 = lib_0529::func_4AAE(var_01,param_00,"zombies",[]);
		if(isdefined(var_02) && !level.var_AB34)
		{
			var_01 = lib_057C::func_4460(param_00.var_0116);
			level.var_AB34 = 1;
		}

		return var_02;
	}

	return lib_057C::func_3495(var_01,param_00);
}

//Function Id: 0x3495
//Function Number: 14
lib_057C::func_3495(param_00,param_01)
{
	var_02 = "airdrop_assault";
	var_03 = lib_057C::func_4476(var_02);
	var_04 = param_00 maps\mp\killstreaks\_airdrop::func_27CB(param_00,var_02,var_03,param_01.var_0116,undefined,0,1);
	var_04 physicslaunchserver((0,0,0));
	var_04 thread lib_0529::func_2745();
	var_04 maps\mp\killstreaks\_airdrop::func_6FAD(var_02,var_03);
	return var_03;
}

//Function Id: 0x45F6
//Function Number: 15
lib_057C::func_45F6()
{
	foreach(var_01 in level.var_744A)
	{
		if(isdefined(var_01))
		{
			return var_01;
		}
	}
}

//Function Id: 0x4478
//Function Number: 16
lib_057C::func_4478(param_00)
{
	var_01 = 2;
	var_02 = lib_057C::func_470A();
	if(var_02.size == 0)
	{
		level.var_AB47 = [];
		var_02 = lib_057C::func_470A();
	}

	var_02 = common_scripts\utility::func_0F92(var_02);
	var_03 = undefined;
	var_04 = 0;
	foreach(var_06 in var_02)
	{
		if(lib_057C::func_2454(var_06.var_0116))
		{
			continue;
		}

		if(var_04 >= var_01)
		{
			wait 0.05;
			var_04 = 0;
		}

		var_07 = lib_057C::func_1FFF(var_06.var_4882,param_00);
		var_04++;
		if(var_07)
		{
			var_03 = var_06;
			break;
		}
	}

	if(isdefined(var_03))
	{
		level.var_AB47[level.var_AB47.size] = var_03;
		return var_03;
	}
}

//Function Id: 0x470A
//Function Number: 17
lib_057C::func_470A()
{
	var_00 = [];
	foreach(var_02 in level.var_AB20)
	{
		if(common_scripts\utility::func_0F79(level.var_AB47,var_02))
		{
			continue;
		}

		if(isdefined(var_02.var_0165) && !common_scripts\utility::func_3C77(var_02.var_0165))
		{
			continue;
		}

		var_00[var_00.size] = var_02;
	}

	return var_00;
}

//Function Id: 0x4689
//Function Number: 18
lib_057C::func_4689(param_00)
{
	var_01 = undefined;
	var_02 = 2;
	var_03 = 5;
	for(var_04 = var_02;var_04 < var_03;var_04++)
	{
		var_05 = param_00.var_012C["killstreaks"][var_04];
		if(!isdefined(var_05) || !isdefined(var_05.var_944C) || var_05.var_13AF == 0)
		{
			var_01 = var_04;
			break;
		}
	}

	return var_01;
}

//Function Id: 0x4AD0
//Function Number: 19
lib_057C::func_4AD0(param_00)
{
	if(!isdefined(lib_057C::func_4689(param_00)))
	{
		lib_057C::func_8C1A(param_00);
		return 1;
	}

	return 0;
}

//Function Id: 0x8C1A
//Function Number: 20
lib_057C::func_8C1A(param_00)
{
	param_00 iclientprintlnbold(&"ZOMBIES_STREAK_LIMIT");
}

//Function Id: 0x2454
//Function Number: 21
lib_057C::func_2454(param_00)
{
	var_01 = 26;
	foreach(var_03 in level.var_6C20)
	{
		var_04 = var_01 * 2;
		var_05 = var_04 * var_04;
		var_06 = distance2dsquared(var_03.var_0116,param_00);
		if(var_06 < var_05)
		{
			return 1;
		}
	}

	return 0;
}

//Function Id: 0x1FFF
//Function Number: 22
lib_057C::func_1FFF(param_00,param_01)
{
	var_02 = 100;
	var_03 = 26;
	return capsuletracepassed(param_00 + (0,0,6),var_03,var_02,param_01,0);
}

//Function Id: 0x5A5F
//Function Number: 23
lib_057C::func_5A5F(param_00)
{
	self endon("death");
	if(!level.var_AB35)
	{
		var_01 = lib_057C::func_4460(self.var_0116);
		level.var_AB35 = 1;
	}

	self.var_0117 = undefined;
	var_02 = self.var_944E;
	var_03 = isdefined(self.var_0117) && self.var_0117 maps\mp\_utility::func_0649("specialty_highroller");
	var_04 = undefined;
	if(var_03)
	{
		var_04 = &"MP_PACKAGE_REROLL";
	}

	var_05 = undefined;
	if(isdefined(game["strings"][param_00 + self.var_275E + "_hint"]))
	{
		var_05 = game["strings"][param_00 + self.var_275E + "_hint"];
	}
	else
	{
		var_05 = &"PLATFORM_GET_KILLSTREAK";
	}

	maps\mp\killstreaks\_airdrop::func_275B(var_05,var_04);
	maps\mp\killstreaks\_airdrop::func_275A("all",maps\mp\killstreaks\_killstreaks::func_4533(var_02));
	thread lib_057C::func_274F();
	for(;;)
	{
		self waittill("captured",var_01);
		var_06 = lib_057C::func_4689(var_01);
		var_02 = self.var_944E;
		if(isdefined(self.var_0117) && var_01 != self.var_0117)
		{
			if(!level.var_984D || var_01.var_01A7 != self.var_01A7)
			{
				var_01 thread maps\mp\_events::func_4D4F(self.var_0117);
			}
			else
			{
				self.var_0117 thread maps\mp\_events::func_8AD6();
			}
		}

		var_01 method_8615("orbital_pkg_use");
		if(!level.var_AB33)
		{
			level.var_AB33 = 1;
		}
		else
		{
		}

		var_01 thread maps\mp\gametypes\_hud_message::func_5A78(var_02,undefined,undefined,var_06);
		var_01 thread maps\mp\killstreaks\_killstreaks::func_478D(var_02,0,0,var_01,var_06);
		maps\mp\killstreaks\_airdrop::func_2D30(1);
	}
}

//Function Id: 0x274F
//Function Number: 24
lib_057C::func_274F(param_00,param_01)
{
	self endon("captured");
	var_02 = self;
	if(isdefined(self.var_6C62))
	{
		var_02 = self.var_6C62;
	}

	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	while(isdefined(self))
	{
		var_02 waittill("trigger",var_03);
		if(isdefined(self.var_0117) && var_03 == self.var_0117)
		{
			continue;
		}

		if(!param_01 && lib_057C::func_4AD0(var_03))
		{
			continue;
		}

		if(var_03 method_83B8() || isdefined(var_03.var_3900) && var_03.var_3900)
		{
			continue;
		}

		if(!var_03 isonground() && !maps\mp\killstreaks\_airdrop::func_A6F8(var_03))
		{
			continue;
		}

		if(!maps\mp\killstreaks\_airdrop::func_A276(var_03))
		{
			continue;
		}

		var_03.var_56A1 = 1;
		var_04 = maps\mp\killstreaks\_airdrop::func_2836();
		var_05 = 0;
		if(self.var_275E == "booby_trap")
		{
			var_05 = var_04 maps\mp\killstreaks\_airdrop::func_A213(var_03,500,param_00);
		}
		else
		{
			var_05 = var_04 maps\mp\killstreaks\_airdrop::func_A213(var_03,2000,param_00);
		}

		if(isdefined(var_04))
		{
			var_04 delete();
		}

		if(!var_05)
		{
			if(isdefined(var_03))
			{
				var_03.var_56A1 = 0;
			}

			continue;
		}

		var_03.var_56A1 = 0;
		if(isdefined(level.var_68A1))
		{
			level.var_68A1--;
		}

		self notify("captured",var_03);
	}
}

//Function Id: 0x62D5
//Function Number: 25
lib_057C::func_62D5(param_00)
{
	self endon("death");
	self.var_0117 = undefined;
	var_01 = undefined;
	if(isdefined(game["strings"][param_00 + self.var_275E + "_hint"]))
	{
		var_01 = game["strings"][param_00 + self.var_275E + "_hint"];
	}
	else
	{
		var_01 = &"PLATFORM_GET_KILLSTREAK";
	}

	maps\mp\killstreaks\_airdrop::func_275B(var_01);
	maps\mp\killstreaks\_airdrop::func_275A("all","hud_carepkg_world_credits");
	thread lib_057C::func_274F(undefined,1);
	for(;;)
	{
		self waittill("captured",var_02);
		var_02 method_8615("zmb_ss_credits_acquire");
		var_03 = lib_057C::func_45A8();
		var_02 maps/mp/gametypes/zombies::func_47AE("crate",var_03,1);
		maps\mp\killstreaks\_airdrop::func_2D30(1);
	}
}

//Function Id: 0x62A8
//Function Number: 26
lib_057C::func_62A8(param_00,param_01,param_02,param_03)
{
	var_04 = param_02;
	if(isplayer(param_01) && function_01EF(param_00))
	{
		return var_04 * level.var_A980;
	}

	switch(param_03)
	{
		case "ugv_missile_mp":
		case "drone_assault_remote_turret_mp":
		case "killstreakmahem_mp":
		case "remote_energy_turret_mp":
		case "sentry_minigun_mp":
			if(lib_0547::func_580A())
			{
				var_04 = int(var_04 * 0.1);
			}
			else
			{
				var_04 = var_04 * 3;
			}
			break;

		case "turretheadmg_mp":
			var_04 = 200 + level.var_A980 * 10;
			break;

		case "turretheadrocket_mp":
			var_04 = 800 + level.var_A980 * randomintrange(50,75);
			break;

		case "turretheadenergy_mp":
			var_04 = var_04 * 3 + int(level.var_A980 / 2);
			break;

		default:
			break;
	}

	return var_04;
}