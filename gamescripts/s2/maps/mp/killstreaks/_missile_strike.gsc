/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _missile_strike.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 117 ms
 * Timestamp: 8/24/2021 10:24:55 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	level.var_80B7["missile_strike"] = 450;
	level.var_80B8["missile_strike"] = 300;
	level.var_80B6["missile_strike"] = 0;
	level.var_80B9["missile_strike"] = 1;
	level.var_80B5["missile_strike"] = 18;
	level.var_5A61["missile_strike"] = ::func_9E31;
	level.var_5A7D["missile_strike_projectile_mp"] = "missile_strike";
	level.var_5A7D["missile_strike_projectile_axis_mp"] = "missile_strike";
}

//Function Id: 0x9E31
//Function Number: 2
func_9E31(param_00)
{
	return maps\mp\killstreaks\_v2_missle_strike::func_9E39(param_00,"missile_strike");
}