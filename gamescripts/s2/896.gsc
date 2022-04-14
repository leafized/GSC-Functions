/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 896.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 56
 * Decompile Time: 25 ms
 * Timestamp: 8/24/2021 10:29:46 PM
*******************************************************************/

//Function Id: 0x6840
//Function Number: 1
lib_0380::func_6840(param_00,param_01,param_02,param_03)
{
	lib_0380::func_0785("nsnd_play_2d",param_00);
	var_04 = spawnsoundentity(param_00,undefined,0,param_02,param_03,undefined,undefined,param_01,undefined);
	lib_0380::func_0787(isdefined(var_04),"Call to nsnd failed for alias: " + param_00);
	return var_04;
}

//Function Id: 0x6841
//Function Number: 2
lib_0380::func_6841(param_00,param_01,param_02,param_03,param_04)
{
	lib_0380::func_0785("nsnd_play_2d_untildeath",param_00);
	var_05 = undefined;
	if(isdefined(param_02))
	{
		var_05 = spawnsoundentity(param_00,undefined,0,param_03,param_04,undefined,undefined,param_01,undefined);
		if(isdefined(var_05))
		{
			thread lib_0380::func_0687(var_05,param_02,param_03);
		}
	}

	lib_0380::func_0787(isdefined(var_05),"Call to nsnd failed for alias: " + param_00);
	return var_05;
}

//Function Id: 0x6850
//Function Number: 3
lib_0380::func_6850(param_00,param_01)
{
	if(isdefined(param_00))
	{
		param_00 method_863F(param_01);
	}
}

//Function Id: 0x6844
//Function Number: 4
lib_0380::func_6844(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = undefined;
	if(isdefined(param_02))
	{
		var_05 = spawnsoundentity(param_00,undefined,0,param_03,param_04,param_02,undefined,param_01,undefined);
	}

	lib_0380::func_0787(isdefined(var_05),"Call to nsnd failed for alias: " + param_00);
	return var_05;
}

//Function Id: 0x6848
//Function Number: 5
lib_0380::func_6848(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(isdefined(param_02))
	{
		var_06 = spawnsoundentity(param_00,undefined,0,param_04,param_05,param_02,param_03,param_01,undefined);
	}

	lib_0380::func_0787(isdefined(var_06),"Call to nsnd failed for alias: " + param_00);
	return var_06;
}

//Function Id: 0x6845
//Function Number: 6
lib_0380::func_6845(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(isdefined(param_03))
	{
		var_06 = spawnsoundentity(param_00,undefined,0,param_04,param_05,param_03,undefined,param_01,param_02);
	}

	lib_0380::func_0787(isdefined(var_06),"Call to nsnd failed for alias: " + param_00);
	return var_06;
}

//Function Id: 0x6849
//Function Number: 7
lib_0380::func_6849(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = undefined;
	if(isdefined(param_03))
	{
		var_07 = spawnsoundentity(param_00,undefined,0,param_05,param_06,param_03,param_04,param_01,param_02);
	}

	lib_0380::func_0787(isdefined(var_07),"Call to nsnd failed for alias: " + param_00);
	return var_07;
}

//Function Id: 0x6846
//Function Number: 8
lib_0380::func_6846(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(isdefined(param_02))
	{
		var_06 = spawnsoundentity(param_00,undefined,0,param_03,param_04,param_02,undefined,param_01,undefined);
		if(isdefined(var_06))
		{
			thread lib_0380::func_0687(var_06,param_02,param_05);
		}
	}

	lib_0380::func_0787(isdefined(var_06),"Call to nsnd failed for alias: " + param_00);
	return var_06;
}

//Function Id: 0x684A
//Function Number: 9
lib_0380::func_684A(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = undefined;
	if(isdefined(param_02))
	{
		var_07 = spawnsoundentity(param_00,undefined,0,param_04,param_05,param_02,param_03,param_01,undefined);
		if(isdefined(var_07))
		{
			thread lib_0380::func_0687(var_07,param_02,param_06);
		}
	}

	lib_0380::func_0787(isdefined(var_07),"Call to nsnd failed for alias: " + param_00);
	return var_07;
}

//Function Id: 0x6847
//Function Number: 10
lib_0380::func_6847(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = spawnsoundentity(param_00,undefined,0,param_03,param_04,param_02,undefined,param_01,undefined);
	if(isdefined(var_08))
	{
		thread lib_0380::func_0688(var_08,param_06,param_07,param_05);
	}

	lib_0380::func_0787(isdefined(var_08),"Call to nsnd failed for alias: " + param_00);
	return var_08;
}

//Function Id: 0x684B
//Function Number: 11
lib_0380::func_684B(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	var_09 = spawnsoundentity(param_00,undefined,0,param_04,param_05,param_02,param_03,param_01,undefined);
	if(isdefined(var_09))
	{
		thread lib_0380::func_0688(var_09,param_07,param_08,param_06);
	}

	lib_0380::func_0787(isdefined(var_09),"Call to nsnd failed for alias: " + param_00);
	return var_09;
}

//Function Id: 0x6842
//Function Number: 12
lib_0380::func_6842(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = spawnsoundentity(param_00,param_02,0,param_03,param_04,undefined,undefined,param_01,undefined);
	lib_0380::func_0787(isdefined(var_05),"Call to nsnd failed for alias: " + param_00);
	return var_05;
}

//Function Id: 0x6843
//Function Number: 13
lib_0380::func_6843(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = spawnsoundentity(param_00,param_02,0,param_03,param_04,undefined,undefined,param_01,undefined);
	if(isdefined(var_08))
	{
		thread lib_0380::func_0688(var_08,param_06,param_07,param_05);
	}

	lib_0380::func_0787(isdefined(var_08),"Call to nsnd failed for alias: " + param_00);
	return var_08;
}

//Function Id: 0x684C
//Function Number: 14
lib_0380::func_684C(param_00,param_01,param_02)
{
	lib_0380::func_077E(isdefined(param_00),"Call to nsnd_register_done_notify failed: snd_ent is undefined.");
	lib_0380::func_077E(isdefined(param_01),"Call to nsnd_register_done_notify failed: entity is undefined.");
	return param_00 registersoundentitydonenotify(param_01,param_02);
}

//Function Id: 0x0687
//Function Number: 15
lib_0380::func_0687(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		param_00 endon("death");
		param_01 waittill("death");
		param_00 method_863F(param_02);
	}
}

//Function Id: 0x0688
//Function Number: 16
lib_0380::func_0688(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_00))
	{
		param_00 endon("death");
		param_01 waittill(param_02);
		param_00 method_863F(param_03);
	}
}

//Function Id: 0x0689
//Function Number: 17
lib_0380::func_0689(param_00,param_01,param_02)
{
	param_00 endon("death");
	level waittill(param_02);
	param_00 method_863F(param_01);
}

//Function Id: 0x684F
//Function Number: 18
lib_0380::func_684F(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		thread lib_0380::func_0689(param_00,param_01,param_02);
	}
}

//Function Id: 0x2888
//Function Number: 19
lib_0380::func_2888(param_00,param_01,param_02,param_03)
{
	lib_0380::func_0785("csnd_play_2d",param_00);
	var_04 = playclientsound(param_00,undefined,undefined,undefined,undefined,undefined,param_02,undefined,param_03,undefined,param_01,undefined);
	lib_0380::func_0787(isdefined(var_04),"Call to csnd failed for alias: " + param_00);
	return var_04;
}

//Function Id: 0x2893
//Function Number: 20
lib_0380::func_2893(param_00,param_01)
{
	if(isdefined(param_00))
	{
		stopclientsound(param_00,param_01);
	}
}

//Function Id: 0x288B
//Function Number: 21
lib_0380::func_288B(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = undefined;
	if(isdefined(param_02))
	{
		var_05 = playclientsound(param_00,param_02,undefined,undefined,undefined,"soft",param_03,undefined,param_04,undefined,param_01,undefined);
	}

	lib_0380::func_0787(isdefined(var_05),"Call to csnd failed for alias: " + param_00);
	return var_05;
}

//Function Id: 0x288C
//Function Number: 22
lib_0380::func_288C(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(isdefined(param_03))
	{
		var_06 = playclientsound(param_00,param_03,undefined,undefined,undefined,"soft",param_04,undefined,param_05,undefined,param_01,param_02);
	}

	lib_0380::func_0787(isdefined(var_06),"Call to csnd failed for alias: " + param_00);
	return var_06;
}

//Function Id: 0x288D
//Function Number: 23
lib_0380::func_288D(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(isdefined(param_02))
	{
		var_06 = playclientsound(param_00,param_02,undefined,undefined,undefined,"hard",param_03,undefined,param_04,undefined,param_01,undefined);
	}

	lib_0380::func_0787(isdefined(var_06),"Call to csnd failed for alias: " + param_00);
	return var_06;
}

//Function Id: 0x288E
//Function Number: 24
lib_0380::func_288E(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = undefined;
	if(isdefined(param_02))
	{
		var_07 = playclientsound(param_00,param_02,undefined,undefined,undefined,"soft",param_03,undefined,param_04,undefined,param_01,undefined);
		if(isdefined(var_07))
		{
			thread lib_0380::func_05F0(var_07,param_02,param_06,param_05);
		}
	}

	lib_0380::func_0787(isdefined(var_07),"Call to csnd failed for alias: " + param_00);
	return var_07;
}

//Function Id: 0x2889
//Function Number: 25
lib_0380::func_2889(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = undefined;
	var_05 = playclientsound(param_00,undefined,param_02,undefined,undefined,undefined,param_03,undefined,param_04,undefined,param_01,undefined);
	lib_0380::func_0787(isdefined(var_05),"Call to csnd failed for alias: " + param_00);
	return var_05;
}

//Function Id: 0x288A
//Function Number: 26
lib_0380::func_288A(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = playclientsound(param_00,undefined,param_02,undefined,undefined,undefined,param_03,undefined,param_04,undefined,param_01,undefined);
	if(isdefined(var_08))
	{
		thread lib_0380::func_05F1(var_08,param_06,param_07,param_05);
	}

	lib_0380::func_0787(isdefined(var_08),"Call to csnd failed for alias: " + param_00);
	return var_08;
}

//Function Id: 0x05F2
//Function Number: 27
lib_0380::func_05F2(param_00,param_01,param_02)
{
	level waittill(param_02);
	stopclientsound(param_00,param_01);
}

//Function Id: 0x2892
//Function Number: 28
lib_0380::func_2892(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		thread lib_0380::func_05F2(param_00,param_01,param_02);
	}
}

//Function Id: 0x2890
//Function Number: 29
lib_0380::func_2890(param_00,param_01,param_02)
{
	changeclientsoundpitch(param_00,param_01,param_02);
}

//Function Id: 0x2891
//Function Number: 30
lib_0380::func_2891(param_00,param_01,param_02)
{
	changeclientsoundvolume(param_00,param_01,param_02);
}

//Function Id: 0x684D
//Function Number: 31
lib_0380::func_684D(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		param_00 scalesoundentitypitch(param_01,param_02);
	}
}

//Function Id: 0x684E
//Function Number: 32
lib_0380::func_684E(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		param_00 scalesoundentityvolume(param_01,param_02);
	}
}

//Function Id: 0x288F
//Function Number: 33
lib_0380::func_288F(param_00,param_01,param_02)
{
	lib_0380::func_077E(isdefined(param_00),"Call to nsnd_register_done_notify failed: handle is undefined.");
	lib_0380::func_077E(isdefined(param_01),"Call to nsnd_register_done_notify failed: entity is undefined.");
	return registerclientsounddonenotify(param_00,param_01,param_02);
}

//Function Id: 0x05F1
//Function Number: 34
lib_0380::func_05F1(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_00))
	{
		param_01 endon("death");
		param_01 waittill(param_02);
		stopclientsound(param_00,param_03);
	}
}

//Function Id: 0x05F0
//Function Number: 35
lib_0380::func_05F0(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_00))
	{
		param_01 common_scripts\utility::func_A70A(param_02,"death");
		stopclientsound(param_00,param_03);
	}
}

//Function Id: 0x0787
//Function Number: 36
lib_0380::func_0787(param_00,param_01,param_02)
{
}

//Function Id: 0x077E
//Function Number: 37
lib_0380::func_077E(param_00,param_01,param_02)
{
}

//Function Id: 0x0785
//Function Number: 38
lib_0380::func_0785(param_00,param_01)
{
}

//Function Id: 0x0780
//Function Number: 39
lib_0380::func_0780(param_00,param_01)
{
	var_02 = param_00;
	if(isdefined(param_01))
	{
		var_02 = param_01;
	}

	return var_02;
}

//Function Id: 0x0786
//Function Number: 40
lib_0380::func_0786(param_00,param_01)
{
	param_00 endon("death");
	level waittill(param_01);
	return 1;
}

//Function Id: 0x077F
//Function Number: 41
lib_0380::func_077F(param_00,param_01)
{
	level endon(param_01);
	if(isdefined(param_00))
	{
		wait(param_00);
	}

	return 1;
}

//Function Id: 0x0781
//Function Number: 42
lib_0380::func_0781(param_00,param_01,param_02)
{
	var_03 = lib_0380::func_0786(param_00,param_01);
	if(isdefined(var_03) && isdefined(param_00))
	{
		lib_0380::func_6850(param_00,param_02);
	}
}

//Function Id: 0xAADF
//Function Number: 43
lib_0380::func_AADF(param_00,param_01,param_02,param_03,param_04,param_05)
{
	lib_0380::func_AAD7(param_00,param_01,param_02,param_03,param_04,param_05);
}

//Function Id: 0xAAD6
//Function Number: 44
lib_0380::func_AAD6(param_00,param_01,param_02,param_03,param_04)
{
	lib_0380::func_0785("xsnd_play_2d",param_00);
	if(isdefined(param_01))
	{
		var_05 = lib_0380::func_6840(param_00,undefined,param_02,param_04);
		if(isdefined(var_05))
		{
			thread lib_0380::func_0781(var_05,param_01,param_03);
			return;
		}

		return;
	}

	lib_0380::func_2888(param_00,undefined,param_02,param_04);
}

//Function Id: 0x0782
//Function Number: 45
lib_0380::func_0782(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(isdefined(param_03))
	{
		var_07 = lib_0380::func_077F(param_01,param_03);
	}
	else
	{
		wait(param_02);
		var_07 = 1;
	}

	if(isdefined(var_07))
	{
		lib_0380::func_AAD6(param_00,param_03,param_04,param_05,param_06);
	}
}

//Function Id: 0xAAD9
//Function Number: 46
lib_0380::func_AAD9(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	lib_0380::func_0785("xsnd_play_delayed_2d",param_00);
	thread lib_0380::func_0782(param_00,param_01,param_02,param_03,param_04,param_05,param_06);
}

//Function Id: 0xAADE
//Function Number: 47
lib_0380::func_AADE(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(isdefined(param_01))
	{
		var_07 = undefined;
		if(!isdefined(param_06))
		{
			var_07 = lib_0380::func_6844(param_00,undefined,self,param_02,param_04);
		}
		else
		{
			var_07 = lib_0380::func_6848(param_00,undefined,self,param_06,param_02,param_04);
		}

		if(isdefined(var_07))
		{
			thread lib_0380::func_0781(var_07,param_01,param_03);
			return;
		}

		return;
	}

	if(!isdefined(var_07))
	{
		lib_0380::func_288B(param_01,undefined,self,param_03,param_05);
		return;
	}

	lib_0380::func_6848(param_01,undefined,self,var_07,param_03,param_05);
}

//Function Id: 0xAAE0
//Function Number: 48
lib_0380::func_AAE0(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	lib_0380::func_AADE(param_00,param_01,param_02,param_03,param_04,param_05,param_06);
}

//Function Id: 0x0783
//Function Number: 49
lib_0380::func_0783(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(isdefined(param_04))
	{
		var_08 = lib_0380::func_077F(param_02,param_04);
	}
	else
	{
		wait(param_03);
		var_08 = 1;
	}

	if(isdefined(var_08))
	{
		lib_0380::func_AAD7(param_00,param_01,param_04,param_05,param_06,param_07);
	}
}

//Function Id: 0xAADA
//Function Number: 50
lib_0380::func_AADA(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	thread lib_0380::func_0783(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07);
}

//Function Id: 0xAADD
//Function Number: 51
lib_0380::func_AADD(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	lib_0380::func_AADA(param_00,param_03,param_01,param_02,param_04,param_05,param_06,param_07);
}

//Function Id: 0xAAD7
//Function Number: 52
lib_0380::func_AAD7(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(isdefined(param_02))
	{
		var_06 = lib_0380::func_6842(param_00,undefined,param_01,param_03,param_05);
		if(isdefined(var_06))
		{
			thread lib_0380::func_0781(var_06,param_02,param_04);
			return;
		}

		return;
	}

	lib_0380::func_2889(param_00,undefined,param_01,param_03,param_05);
}

//Function Id: 0x0784
//Function Number: 53
lib_0380::func_0784(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(isdefined(param_03))
	{
		var_07 = lib_0380::func_077F(param_01,param_03);
	}
	else
	{
		if(isdefined(param_02))
		{
			wait(param_02);
		}

		var_07 = 1;
	}

	if(isdefined(var_07))
	{
		self.var_8E50 = lib_0380::func_AADE(param_00,param_03,param_04,param_05,param_06);
	}
}

//Function Id: 0xAADB
//Function Number: 54
lib_0380::func_AADB(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = spawn("script_origin",param_01);
	if(isdefined(var_08))
	{
		if(!isdefined(param_02) || param_02 == 0)
		{
			var_08.var_8E50 = var_08 lib_0380::func_AADE(param_00,param_04,param_05,param_06,param_07);
		}
		else
		{
			var_08 thread lib_0380::func_0784(param_00,param_02,param_03,param_04,param_05,param_06,param_07);
		}
	}

	return var_08;
}

//Function Id: 0xAADC
//Function Number: 55
lib_0380::func_AADC(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(!isdefined(param_01) || param_01 == 0)
	{
		lib_0380::func_AADE(param_00,param_03,param_04,param_05,param_06);
		return;
	}

	thread lib_0380::func_0784(param_00,param_01,param_02,param_03,param_04,param_05,param_06);
}

//Function Id: 0xAAD8
//Function Number: 56
lib_0380::func_AAD8(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = spawn("script_origin",param_01);
	if(isdefined(var_07))
	{
		var_07.var_8E50 = var_07 lib_0380::func_AADE(param_00,param_03,param_04,param_05,param_06);
	}

	return var_07;
}