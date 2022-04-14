/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _playercards.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 83 ms
 * Timestamp: 8/24/2021 10:22:44 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	level thread func_6B6C();
}

//Function Id: 0x6B6C
//Function Number: 2
func_6B6C()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!isai(var_00))
		{
		}
	}
}