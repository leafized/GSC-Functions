/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: mp_zombie_nest_trap_firewell.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 44 ms
 * Timestamp: 8/24/2021 10:28:49 PM
*******************************************************************/

//Function Id: 0x9CAA
//Function Number: 1
func_9CAA(param_00)
{
	level notify("firewell_machinery_reset");
	wait(1.5);
	maps/mp/mp_zombie_nest_ee_fire_well::func_9CAB(param_00);
}