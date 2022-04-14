/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1362.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 31
 * Decompile Time: 58 ms
 * Timestamp: 8/24/2021 10:29:21 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_0552::func_00D5()
{
	level.var_ABD1 = [];
	for(var_00 = 0;var_00 < 4;var_00++)
	{
		var_01 = spawnstruct();
		var_01.var_4DBA = 0;
		var_01.var_2903 = undefined;
		var_01.var_A902 = [];
		level.var_ABD1 = common_scripts\utility::func_0F6F(level.var_ABD1,var_01);
	}

	level.var_47DF = [];
	level thread lib_0552::func_540F();
}

//Function Id: 0x540F
//Function Number: 2
lib_0552::func_540F()
{
	for(;;)
	{
		level waittill("connected",var_00);
		level thread lib_0552::func_09B1(var_00);
		level thread lib_0552::func_A151(var_00);
		level thread lib_0552::func_540E(var_00);
	}
}

//Function Id: 0x09B1
//Function Number: 3
lib_0552::func_09B1(param_00)
{
	var_01 = param_00 getentitynumber();
	var_02 = level.var_ABD1[var_01];
	foreach(var_04 in level.var_47DF)
	{
		var_02.var_A902 = common_scripts\utility::func_0F6F(var_02.var_A902,var_04);
	}
}

//Function Id: 0x540E
//Function Number: 4
lib_0552::func_540E(param_00)
{
	var_01 = param_00 getentitynumber();
	param_00 waittill("disconnect");
	lib_0552::func_2391(var_01);
}

//Function Id: 0x2391
//Function Number: 5
lib_0552::func_2391(param_00)
{
	var_01 = level.var_ABD1[param_00];
	var_01.var_4DBA = 0;
	var_01.var_2903 = undefined;
	var_01.var_A902 = [];
	foreach(var_03 in level.var_47DF)
	{
		var_03.var_9FD3.refresh_internal_times_per_player[param_00] = undefined;
		var_03.var_9FD3.disabled_internal_per_player[param_00] = undefined;
	}
}

//Function Id: 0x7BFE
//Function Number: 6
lib_0552::func_7BFE(param_00,param_01,param_02,param_03)
{
	return lib_0552::func_7BF4(param_00,1,param_01,param_02,param_03);
}

//Function Id: 0x7BF3
//Function Number: 7
lib_0552::func_7BF3(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	return lib_0552::func_7BF4(param_00,2,param_01,param_02,param_03);
}

//Function Id: 0x7BED
//Function Number: 8
lib_0552::func_7BED(param_00,param_01)
{
	return lib_0552::func_7BF4(param_00,3,param_01,0);
}

//Function Id: 0x7BFC
//Function Number: 9
lib_0552::func_7BFC(param_00)
{
	return lib_0552::func_7BE4(4,param_00,0);
}

//Function Id: 0x7BDD
//Function Number: 10
lib_0552::func_7BDD(param_00)
{
	return lib_0552::func_7BE4(5,param_00,0);
}

//Function Id: 0x7BE1
//Function Number: 11
lib_0552::func_7BE1(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(isdefined(param_00))
	{
		return lib_0552::func_7BF4(param_00,6,param_01,param_02,param_03,param_04);
	}

	return lib_0552::func_7BE4(6,param_01,param_02,param_03,param_04);
}

//Function Id: 0x7BE4
//Function Number: 12
lib_0552::func_7BE4(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = lib_0552::func_2823(param_00,param_01,param_02,param_03,param_04);
	level.var_47DF = common_scripts\utility::func_0F6F(level.var_47DF,var_05);
	level thread maps\mp\_utility::func_6F74(::lib_0552::func_09E2,var_05);
	return var_05.var_9FD3;
}

//Function Id: 0x09E2
//Function Number: 13
lib_0552::func_09E2(param_00)
{
	var_01 = self getentitynumber();
	var_02 = level.var_ABD1[var_01];
	var_02.var_A902 = common_scripts\utility::func_0F6F(var_02.var_A902,param_00);
}

//Function Id: 0x7BF4
//Function Number: 14
lib_0552::func_7BF4(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = lib_0552::func_2823(param_01,param_02,param_03,param_04,param_05);
	param_00 lib_0552::func_09E2(var_06);
	return var_06.var_9FD3;
}

//Function Id: 0x2823
//Function Number: 15
lib_0552::func_2823(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = spawnstruct();
	var_05.var_01B9 = param_00;
	var_05.var_9D65 = param_01;
	var_05.var_6641 = param_02;
	if(!isdefined(param_03))
	{
		param_03 = param_01.var_0116;
	}

	if(!isdefined(param_04))
	{
		param_04 = 250;
	}

	var_05.var_5EB5 = param_03;
	var_05.radial_progress_time = param_04;
	var_06 = spawnstruct();
	if(param_00 == 1)
	{
		var_06.var_A9B4 = undefined;
		var_06.var_A9A5 = 0;
	}
	else if(param_00 == 2)
	{
		var_06.var_6F58 = undefined;
		var_06.var_6F56 = 0;
	}
	else if(param_00 == 3)
	{
		var_06.var_1B73 = 0;
		var_06.var_1B74 = undefined;
		var_06.var_1B6F = 0;
		var_06.var_1B72 = undefined;
	}
	else if(param_00 == 4)
	{
		var_06.var_9CCA = 0;
		var_06.var_9C9D = 0;
		var_06.var_9CBE = 0;
		var_06.var_9C9B = 0;
	}
	else if(param_00 == 5)
	{
		var_06.var_3264 = 0;
		var_06.var_3259 = 0;
	}
	else if(param_00 == 6)
	{
		var_06.var_4028 = 0;
		var_06.var_401E = 0;
	}

	var_06.var_6642 = 0;
	var_06.var_2F74 = 0;
	var_06.var_0C13 = 0;
	var_06.refresh_internal_time = 0;
	var_06.refresh_internal_times_per_player = [];
	var_06.disabled_internal_per_player = [];
	var_05.var_9FD3 = var_06;
	return var_05;
}

//Function Id: 0x44FF
//Function Number: 16
lib_0552::func_44FF(param_00)
{
	var_01 = tablelookup("mp/zombieInteractTable.csv",2,param_00,1);
	return int(var_01);
}

//Function Id: 0x267D
//Function Number: 17
lib_0552::func_267D(param_00,param_01)
{
	if(isdefined(param_01))
	{
		return param_01;
	}

	return param_00;
}

//Function Id: 0x8C05
//Function Number: 18
lib_0552::func_8C05(param_00,param_01,param_02)
{
	var_03 = 0;
	var_04 = 0;
	var_05 = param_00 getentitynumber();
	markrefreshed(var_05,param_01);
	if(param_01.var_01B9 == 1 && isdefined(param_01.var_9FD3.var_A9B4))
	{
		var_06 = tablelookuprownum("mp/zombieInteractTable.csv",2,param_01.var_9FD3.var_A9B4);
		var_07 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_06,0));
		var_08 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_06,1));
		var_03 = var_07 | var_08 << 4;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_A9A5,param_02);
	}
	else if(param_01.var_01B9 == 2 && isdefined(param_01.var_9FD3.var_6F58))
	{
		var_06 = tablelookuprownum("mp/zombieInteractTable.csv",2,param_01.var_9FD3.var_6F58);
		var_07 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_06,0));
		var_08 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_06,1));
		var_03 = var_07 | var_08 << 4;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_6F56,param_02);
	}
	else if(param_01.var_01B9 == 3 && param_01.var_9FD3.var_1B73 != 0)
	{
		var_06 = tablelookuprownum("mp/zombieInteractTable.csv",2,"mysterybox");
		var_07 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_06,0));
		var_08 = 0;
		if(param_01.var_9FD3.var_1B73 == 2)
		{
			var_09 = tablelookuprownum("mp/zombieInteractTable.csv",2,param_01.var_9FD3.var_1B74);
			var_08 = int(tablelookupbyrow("mp/zombieInteractTable.csv",var_09,1));
		}

		var_03 = var_07 | var_08 << 4;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_1B6F,param_02) | param_01.var_9FD3.var_1B73 << 16;
	}
	else if(param_01.var_01B9 == 4)
	{
		var_07 = 4;
		var_0A = param_01.var_9FD3.var_9CCA;
		var_0B = param_01.var_9FD3.var_9CBE;
		var_0C = param_01.var_9FD3.var_9C9B;
		var_03 = var_07 | var_0A << 4 | var_0B << 8;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_9C9D,param_02) | var_0C << 16;
	}
	else if(param_01.var_01B9 == 5)
	{
		var_07 = 5;
		var_03 = var_07 | param_01.var_9FD3.var_3264 << 4;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_3259,param_02);
	}
	else if(param_01.var_01B9 == 6)
	{
		var_07 = 6;
		var_03 = var_07 | param_01.var_9FD3.var_4028 << 4;
		var_04 = lib_0552::func_267D(param_01.var_9FD3.var_401E,param_02);
	}

	param_00 setclientomnvar("ui_zm_interaction_flags",var_03);
	param_00 setclientomnvar("ui_zm_interaction_data",var_04);
}

//Function Id: 0x0000
//Function Number: 19
hideinteractprompt(param_00,param_01)
{
	param_00 luinotifyeventextraplayer(&"stop_progressive_interact",0);
	param_00 luinotifyeventextraplayer(&"remove_progressive_interact",0);
	param_01.var_4DBA = 0;
	param_01.var_4DB6 = undefined;
	param_00 setclientomnvar("ui_zm_interaction_flags",0);
}

//Function Id: 0x4205
//Function Number: 20
lib_0552::func_4205(param_00,param_01,param_02)
{
	if(isdefined(param_02))
	{
		var_03 = param_02 - param_00 geteye();
	}
	else
	{
		var_03 = param_02.var_0116 - param_01 geteye();
	}

	var_04 = vectornormalize((var_03[0],var_03[1],0));
	var_05 = anglestoforward(param_00.var_001D);
	var_06 = vectornormalize((var_05[0],var_05[1],0));
	var_07 = vectordot(var_04,var_06);
	var_08 = acos(clamp(var_07,-1,1));
	return var_08;
}

//Function Id: 0x990A
//Function Number: 21
lib_0552::func_990A(param_00)
{
	var_01 = param_00 < 60;
	return var_01;
}

//Function Id: 0x55E2
//Function Number: 22
lib_0552::func_55E2(param_00,param_01,param_02)
{
	var_03 = lib_0552::func_4205(param_00,param_01,param_02);
	var_04 = lib_0552::func_990A(var_03);
	return var_04;
}

//Function Id: 0x21B8
//Function Number: 23
lib_0552::func_21B8(param_00,param_01)
{
	if(param_01.var_01B9 == 3)
	{
		var_02 = param_01.var_9FD3.var_1B72 maps\mp\zombies\_zombies_magicbox::func_43FF(param_00);
		if(param_01.var_9FD3.var_1B6F != var_02)
		{
			return int(var_02);
		}
	}
	else if(param_01.var_01B9 == 5)
	{
		var_03 = param_00 lib_0577::func_4687();
		if(var_03 != 1)
		{
			return int(var_03 * param_01.var_9FD3.var_3259);
		}
	}

	return undefined;
}

//Function Id: 0x0000
//Function Number: 24
check_for_door_power(param_00,param_01)
{
	while(param_00.var_4DBA)
	{
		var_02 = param_01.var_3276 lib_053F::func_3278() && !param_01.var_3276 lib_053F::func_3262();
		if(var_02)
		{
			wait(0.25);
			continue;
		}

		break;
	}
}

//Function Id: 0x0000
//Function Number: 25
check_if_perk_empty(param_00,param_01)
{
	while(param_00.var_4DBA)
	{
		var_02 = param_01.var_9FD3.var_6F58;
		if(var_02 == "lost_and_found_empty")
		{
			wait(0.25);
			continue;
		}

		break;
	}
}

//Function Id: 0x0000
//Function Number: 26
check_if_trap_ready(param_00,param_01)
{
	while(param_00.var_4DBA)
	{
		var_02 = param_01.var_9FD3.var_9CCA;
		if(var_02 != 3)
		{
			wait(0.25);
			continue;
		}

		break;
	}
}

//Function Id: 0x0000
//Function Number: 27
check_progressive_interact_input(param_00,param_01)
{
	var_02 = 0;
	var_03 = 0;
	var_04 = 1;
	var_05 = param_01.var_9D65;
	while(param_00.var_4DBA)
	{
		if(common_scripts\utility::func_562E(param_01.var_9FD3.interact_disabled))
		{
			if(var_02 == 1)
			{
				self luinotifyeventextraplayer(&"stop_progressive_interact",0);
				self luinotifyeventextraplayer(&"remove_progressive_interact",0);
				var_02 = 0;
			}

			wait 0.05;
			continue;
		}

		if(!isdefined(self.interactneedrelease) || !self usebuttonpressed())
		{
			self.interactneedrelease = 0;
		}

		var_04 = self usebuttonpressed() && !self.interactneedrelease;
		if(!var_03)
		{
			if(var_04)
			{
				self luinotifyeventextraplayer(&"start_progressive_interact",1,param_01.radial_progress_time);
				var_03 = 1;
				var_02 = 1;
			}

			continue;
		}

		if(!var_04)
		{
			self luinotifyeventextraplayer(&"stop_progressive_interact",0);
			var_03 = 0;
		}

		wait 0.05;
	}

	self luinotifyeventextraplayer(&"stop_progressive_interact",0);
	self luinotifyeventextraplayer(&"remove_progressive_interact",0);
}

//Function Id: 0xA151
//Function Number: 28
lib_0552::func_A151(param_00)
{
	param_00 endon("disconnect");
	var_01 = param_00 getentitynumber();
	var_02 = level.var_ABD1[var_01];
	for(;;)
	{
		refreshplayerinteractprompts(param_00,var_02);
		var_03 = param_00 method_84D1(1);
		if(var_02.var_4DBA)
		{
			if(!isdefined(var_03) || var_02.var_2903.var_9D65 != var_03)
			{
				hideinteractprompt(param_00,var_02);
			}
			else
			{
				var_04 = lib_0552::func_21B8(param_00,var_02.var_2903);
				var_05 = needsrefresh(var_01,var_02.var_2903);
				if(var_05 || isdefined(var_04))
				{
					param_00 luinotifyeventextraplayer(&"add_progressive_interact",1,var_02.var_2903.var_9D65);
					lib_0552::func_8C05(param_00,var_02.var_2903,var_04);
				}
			}
		}
		else if(isdefined(var_03))
		{
			for(var_06 = 0;var_06 < var_02.var_A902.size;var_06++)
			{
				var_07 = var_02.var_A902[var_06];
				if(var_07.var_9D65 == var_03)
				{
					var_02.var_4DBA = 1;
					var_02.var_2903 = var_07;
					var_04 = lib_0552::func_21B8(param_00,var_02.var_2903);
					param_00 luinotifyeventextraplayer(&"add_progressive_interact",1,var_07.var_9D65);
					lib_0552::func_8C05(param_00,var_07,var_04);
					param_00 childthread check_progressive_interact_input(var_02,var_07);
					break;
				}
			}
		}

		wait 0.05;
	}
}

//Function Id: 0x0000
//Function Number: 29
needsrefresh(param_00,param_01)
{
	var_02 = param_01.var_9FD3.refresh_internal_times_per_player[param_00];
	if(!isdefined(var_02) || var_02 < param_01.var_9FD3.refresh_internal_time)
	{
		return 1;
	}

	return 0;
}

//Function Id: 0x0000
//Function Number: 30
markrefreshed(param_00,param_01)
{
	param_01.var_9FD3.refresh_internal_times_per_player[param_00] = param_01.refresh_internal_time;
}

//Function Id: 0x0000
//Function Number: 31
refreshplayerinteractprompts(param_00,param_01)
{
	var_02 = param_00 getentitynumber();
	for(var_03 = 0;var_03 < param_01.var_A902.size;var_03++)
	{
		var_04 = param_01.var_A902[var_03];
		if(var_04.var_9FD3.var_6642)
		{
			var_04.var_9FD3.var_6642 = 0;
			var_04.var_9FD3.refresh_internal_time = gettime();
		}

		var_05 = needsrefresh(var_02,var_04);
		var_06 = 0;
		var_06 = var_06 | common_scripts\utility::func_562E(var_04.var_9FD3.var_2F74);
		if(var_05)
		{
			if(common_scripts\utility::func_562E(var_04.var_6641))
			{
				var_04.var_9D65 usetouchtriggerrequirefacingposition(1,var_04.var_5EB5);
				var_04.var_9D65 usetriggerrequirelookat(0);
			}

			if(!isdefined(param_01.var_2903) || var_04 != param_01.var_2903)
			{
				markrefreshed(var_02,var_04);
			}
		}

		if(common_scripts\utility::func_562E(var_04.var_9FD3.require_standing))
		{
			switch(param_00 getstance())
			{
				case "prone":
				case "crouch":
					var_06 = var_06 | 1;
					break;
			}
		}

		if(!lib_0547::func_5565(var_04.var_9FD3.disabled_internal_per_player[var_02],var_06))
		{
			var_04.var_9FD3.disabled_internal_per_player[var_02] = var_06;
			if(var_06)
			{
				var_04.var_9D65 disableplayeruse(param_00);
				continue;
			}

			var_04.var_9D65 enableplayeruse(param_00);
		}
	}
}