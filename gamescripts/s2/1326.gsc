/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1326.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:13 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_052E::func_00D5()
{
	level.adrenalineshotmovespeedscale = 1.1;
	level.var_0A0A = 100;
	level.var_0A0B = 1.5;
	level.var_0A0C = 13.33;
	level.var_0A07 = 1;
	self.var_4B50 = 0;
}

//Function Id: 0x3662
//Function Number: 2
lib_052E::func_3662()
{
	maps\mp\_utility::func_870F(level.var_0A0A);
	self.var_7AD7 = level.var_0A0A;
	self.var_98E1 = level.var_0A0B;
	self.var_98E2 = level.var_0A0C;
	self.var_4B50 = 1;
	maps\mp\gametypes\_weapons::func_A13B();
}

//Function Id: 0x2F9E
//Function Number: 3
lib_052E::func_2F9E()
{
	maps\mp\_utility::func_870F(0);
	self.var_7AD7 = 0;
	self.var_98E1 = undefined;
	self.var_98E2 = undefined;
	self.var_4B50 = 0;
	maps\mp\gametypes\_weapons::func_A13B();
}