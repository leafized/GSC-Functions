/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1329.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:14 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_0531::func_00D5()
{
	level.extremeconditioningmovespeedscale = 1.4;
	self.var_4B66 = 0;
}

//Function Id: 0x3662
//Function Number: 2
lib_0531::func_3662()
{
	self.var_4B66 = 1;
	maps\mp\gametypes\_weapons::func_A13B();
}

//Function Id: 0x2F9E
//Function Number: 3
lib_0531::func_2F9E()
{
	self.var_4B66 = 0;
	maps\mp\gametypes\_weapons::func_A13B();
}