/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 639.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:37 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
lib_027F::func_00F9()
{
	self setmodel("mp_sentinel_body_nojet_b");
	lib_0281::func_114A("alias_mp_sentinel_heads",lib_03D7::func_00F9());
	self setviewmodel("viewhands_s1_pmc");
	self.var_A600 = "american";
	self method_83E1("vestlight");
}

//Function Id: 0x0136
//Function Number: 2
lib_027F::func_0136()
{
	precachemodel("mp_sentinel_body_nojet_b");
	lib_0281::func_7653(lib_03D7::func_00F9());
	precachemodel("viewhands_s1_pmc");
}