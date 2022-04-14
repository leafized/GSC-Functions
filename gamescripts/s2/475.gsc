/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 475.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:37 PM
*******************************************************************/

//Function Id: 0x00D6
//Function Number: 1
lib_01DB::func_00D6()
{
	level.var_9478 = [];
}

//Function Id: 0x005E
//Function Number: 2
lib_01DB::func_005E()
{
	var_00 = spawnstruct();
	level.var_9478[level.var_9478.size] = var_00;
	return var_00;
}