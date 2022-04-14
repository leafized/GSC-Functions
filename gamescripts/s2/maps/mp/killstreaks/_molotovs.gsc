/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _molotovs.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 125 ms
 * Timestamp: 8/24/2021 10:24:55 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	level.var_5A61["molotovs"] = ::func_9E32;
	level.var_5A7D["killstreak_molotov_cocktail_mp"] = "molotovs";
	level.var_5A7D["killstreak_molotov_cocktail_grenadier_mp"] = "molotovs";
	level.var_5A7D["thermite_flames_mp"] = "molotovs";//effect
}

//Function Id: 0x9E32
//Function Number: 2
func_9E32(param_00)
{
	var_01 = func_9E33();
	return var_01;
}

//Function Id: 0x9E33
//Function Number: 3
func_9E33()
{
	if(maps\mp\_utility::func_57A0(self))
	{
		maps\mp\_matchdata::func_5E9A("molotovs",self.var_0116);
		return 1;
	}

	return 0;
}