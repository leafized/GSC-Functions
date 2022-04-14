/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 477.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 44
 * Decompile Time: 8 ms
 * Timestamp: 8/24/2021 10:29:37 PM
*******************************************************************/

//Function Id: 0x0052
//Function Number: 1
lib_01DD::func_0052()
{
	if(getdvar("233") == "1")
	{
		level waittill("eternity");
	}

	if(!isdefined(level.var_3FDF) || !level.var_3FDF)
	{
		[[ level.var_1E7F ]]();
		level.var_3FDF = 1;
	}
}

//Function Id: 0x004B
//Function Number: 2
lib_01DD::func_004B()
{
	if(getdvar("233") == "1")
	{
		level waittill("eternity");
	}

	self endon("disconnect");
	[[ level.var_1E77 ]]();
}

//Function Id: 0x004D
//Function Number: 3
lib_01DD::func_004D(param_00)
{
	self notify("disconnect");
	[[ level.var_1E79 ]](param_00);
}

//Function Id: 0x004C
//Function Number: 4
lib_01DD::func_004C(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	self endon("disconnect");
	[[ level.var_1E78 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
}

//Function Id: 0x004F
//Function Number: 5
lib_01DD::func_004F(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self endon("disconnect");
	[[ level.var_1E7B ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Id: 0x0042
//Function Number: 6
lib_01DD::func_0042(param_00,param_01)
{
	self endon("disconnect");
	[[ level.var_1E72 ]](param_00,param_01);
}

//Function Id: 0x004E
//Function Number: 7
lib_01DD::func_004E(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	self endon("disconnect");
	[[ level.var_1E7A ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07);
}

//Function Id: 0x0044
//Function Number: 8
lib_01DD::func_0044()
{
	self endon("disconnect");
	[[ level.var_1E73 ]]();
}

//Function Id: 0x0040
//Function Number: 9
lib_01DD::func_0040(param_00,param_01,param_02,param_03,param_04,param_05)
{
	self endon("disconnect");
	if(isdefined(self.var_1D7D))
	{
		[[ self.var_1D7D ]](param_00,param_01,param_02,param_03,param_04,param_05);
	}
}

//Function Id: 0x0054
//Function Number: 10
lib_01DD::func_0054(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(isdefined(self.var_29B5))
	{
		self [[ self.var_29B5 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
		return;
	}

	self method_827F(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Id: 0x0043
//Function Number: 11
lib_01DD::func_0043(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	if(isdefined(self.var_29B5))
	{
		self [[ self.var_29B5 ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
		return;
	}

	self finishentitydamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B);
}

//Function Id: 0x0041
//Function Number: 12
lib_01DD::func_0041()
{
	self endon("disconnect");
	[[ level.var_1E71 ]]();
}

//Function Id: 0x0048
//Function Number: 13
lib_01DD::func_0048(param_00,param_01,param_02)
{
	maps\mp\gametypes\_killcam::func_92E1(param_00,param_01,param_02);
}

//Function Id: 0x0050
//Function Number: 14
lib_01DD::func_0050(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self endon("disconnect");
	[[ level.var_1E7C ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Id: 0x0051
//Function Number: 15
lib_01DD::func_0051()
{
	self endon("disconnect");
	[[ level.var_1E7D ]]();
}

//Function Id: 0x0047
//Function Number: 16
lib_01DD::func_0047()
{
	[[ level.var_1E75 ]]();
}

//Function Id: 0x2491
//Function Number: 17
lib_01DD::func_2491(param_00,param_01)
{
	if(isbot(param_00) || function_026D(param_00) || (isdefined(param_00.var_01A7) && param_00.var_01A7 == "spectator") || param_00.var_0178 == "spectator")
	{
		return;
	}

	if(!isdefined(level.var_5A61))
	{
		return;
	}

	if((isdefined(level.var_5A61[param_01]) && tablelookup("mp/killstreakTable.csv",1,param_01,0) != "") || issubstr(param_01,"turrethead"))
	{
		if(getdvarint("scorestreak_enabled_" + param_01) == 0)
		{
			iprintlnbold("Scorestreak " + param_01 + " was disabled.  Re-enabling...");
			setdvar("scorestreak_enabled_" + param_01,1);
		}

		var_02 = param_00 maps\mp\killstreaks\_killstreaks::func_46B4(param_01);
		var_03 = param_00 maps\mp\killstreaks\_killstreaks::func_45A5(param_01);
		param_00 thread maps\mp\gametypes\_hud_message::func_5A78(param_01,var_02,undefined,var_03);
		param_00 maps\mp\killstreaks\_killstreaks::func_478D(param_01);
	}
}

//Function Id: 0x47B6
//Function Number: 18
lib_01DD::func_47B6(param_00)
{
	wait 0.05;
	lib_0533::func_3662(param_00);
}

//Function Id: 0x95F2
//Function Number: 19
lib_01DD::func_95F2(param_00)
{
	wait 0.05;
	lib_0533::func_2F9E(param_00);
}

//Function Id: 0x0045
//Function Number: 20
lib_01DD::func_0045(param_00,param_01)
{
	if(function_026D(param_00) || param_00.var_01A7 == "spectator" || param_00.var_0178 == "spectator")
	{
		return;
	}

	param_00 thread lib_01DD::func_47B6(param_01);
}

//Function Id: 0x0053
//Function Number: 21
lib_01DD::func_0053(param_00,param_01)
{
	if(function_026D(param_00) || param_00.var_01A7 == "spectator" || param_00.var_0178 == "spectator")
	{
		return;
	}

	param_00 thread lib_01DD::func_95F2(param_01);
}

//Function Id: 0x2492
//Function Number: 22
lib_01DD::func_2492(param_00,param_01)
{
}

//Function Id: 0x2499
//Function Number: 23
lib_01DD::func_2499(param_00)
{
}

//Function Id: 0x2494
//Function Number: 24
lib_01DD::func_2494(param_00,param_01)
{
}

//Function Id: 0x249D
//Function Number: 25
lib_01DD::func_249D(param_00,param_01)
{
}

//Function Id: 0x249E
//Function Number: 26
lib_01DD::func_249E(param_00,param_01)
{
}

//Function Id: 0x249A
//Function Number: 27
lib_01DD::func_249A(param_00,param_01)
{
}

//Function Id: 0x2496
//Function Number: 28
lib_01DD::func_2496(param_00)
{
}

//Function Id: 0x2490
//Function Number: 29
lib_01DD::func_2490(param_00,param_01)
{
}

//Function Id: 0x249B
//Function Number: 30
lib_01DD::func_249B(param_00,param_01)
{
}

//Function Id: 0x249C
//Function Number: 31
lib_01DD::func_249C(param_00,param_01)
{
}

//Function Id: 0x248F
//Function Number: 32
lib_01DD::func_248F(param_00)
{
}

//Function Id: 0x2495
//Function Number: 33
lib_01DD::func_2495(param_00)
{
}

//Function Id: 0x2493
//Function Number: 34
lib_01DD::func_2493(param_00)
{
}

//Function Id: 0x2498
//Function Number: 35
lib_01DD::func_2498(param_00)
{
}

//Function Id: 0x24A0
//Function Number: 36
lib_01DD::func_24A0(param_00)
{
}

//Function Id: 0x2497
//Function Number: 37
lib_01DD::func_2497(param_00)
{
}

//Function Id: 0x249F
//Function Number: 38
lib_01DD::func_249F(param_00,param_01)
{
}

//Function Id: 0x004A
//Function Number: 39
lib_01DD::func_004A(param_00)
{
	if(isdefined(level.var_6EA3))
	{
		[[ level.var_6EA3 ]](param_00);
	}
}

//Function Id: 0x8A13
//Function Number: 40
lib_01DD::func_8A13()
{
	level.var_503C = 1;
	level.var_5034 = 2;
	level.var_5035 = 4;
	level.var_503B = 8;
	level.var_503A = 16;
	level.var_5040 = 32;
	level.var_503D = 64;
	level.var_503E = 128;
	level.var_503F = 256;
	level.var_5037 = 512;
	level.var_5036 = 1024;
	level.var_5038 = 2048;
	level.var_5039 = level.var_503B | level.var_503A;
}

//Function Id: 0x8A0C
//Function Number: 41
lib_01DD::func_8A0C()
{
	lib_01DD::func_865F();
	lib_01DD::func_8A13();
}

//Function Id: 0x865F
//Function Number: 42
lib_01DD::func_865F()
{
	level.var_1E7F = ::maps\mp\gametypes\_gamelogic::func_1E70;
	level.var_1E77 = ::maps\mp\gametypes\_playerlogic::func_1E67;
	level.var_1E79 = ::maps\mp\gametypes\_playerlogic::func_1E6A;
	level.var_1E78 = ::maps\mp\gametypes\_damage::func_1E68;//callbackPlayerDamage
	level.var_1E7B = ::maps\mp\gametypes\_damage::func_1E6C;
	level.var_1E72 = ::maps\mp\gametypes\_damage::func_1E63;
	level.var_1E73 = ::maps\mp\gametypes\_damage::func_1E64;
	level.var_1E7A = ::maps\mp\gametypes\_damage::func_1E6B;
	level.var_1E71 = ::maps\mp\gametypes\_gamelogic::func_1E62;
	level.var_1E7C = ::maps\mp\gametypes\_damage::func_1E6D;
	level.var_1E7D = ::maps\mp\gametypes\_playerlogic::func_1E6F;
	level.var_1E75 = ::maps\mp\gametypes\_hostmigration::func_1E65;
}

//Function Id: 0x0847
//Function Number: 43
lib_01DD::func_0847()
{
	level.var_1E7F = ::lib_01DD::func_1E81;
	level.var_1E77 = ::lib_01DD::func_1E81;
	level.var_1E79 = ::lib_01DD::func_1E81;
	level.var_1E78 = ::lib_01DD::func_1E81;
	level.var_1E7B = ::lib_01DD::func_1E81;
	level.var_1E73 = ::lib_01DD::func_1E81;
	level.var_1E7A = ::lib_01DD::func_1E81;
	level.var_1E71 = ::lib_01DD::func_1E81;
	level.var_1E7C = ::lib_01DD::func_1E81;
	level.var_1E7D = ::lib_01DD::func_1E81;
	level.var_1E75 = ::lib_01DD::func_1E81;
	setdvar("1924","dm");
	exitlevel(0);
}

//Function Id: 0x1E81
//Function Number: 44
lib_01DD::func_1E81()
{
}