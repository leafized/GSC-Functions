/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 1332.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:15 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
lib_0534::func_00D5()
{
	self.var_4B91 = 0;
	level.var_83C8 = 6;
	level.var_83C9 = 0.05;
	level.var_83C7 = 1.25;
	level.var_83CA = 4;
}

//Function Id: 0x3662
//Function Number: 2
lib_0534::func_3662()
{
	maps\mp\_utility::func_47A2("specialty_finalstand");
	self.var_4B91 = 1;
	self notify("self_revive");
}

//Function Id: 0x2F9E
//Function Number: 3
lib_0534::func_2F9E()
{
	maps\mp\_utility::func_0735("specialty_finalstand");
	self.var_4B91 = 0;
	self waittill("revive");
	self.var_98E2 = undefined;
}