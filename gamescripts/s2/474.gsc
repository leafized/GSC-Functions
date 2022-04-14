/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 474.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 8/24/2021 10:29:36 PM
*******************************************************************/

//Function Id: 0x00F9
//Function Number: 1
lib_01DA::func_00F9()
{
	wait(0);
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Id: 0x0044
//Function Number: 2
lib_01DA::func_0044()
{
	self endon("death");
	wait 0.05;
	self delete();
}