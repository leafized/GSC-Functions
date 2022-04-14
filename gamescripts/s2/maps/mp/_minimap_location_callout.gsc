/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _minimap_location_callout.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 134 ms
 * Timestamp: 8/24/2021 10:26:39 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	level.var_620F = getentarray("minimap_location_callout","targetname");
}

//Function Id: 0x63C2
//Function Number: 2
func_63C2()
{
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self.var_2942 = -1;
	self setclientomnvar("ui_minimap_location_callout",-1);
	wait 0.05;
	func_21D1(1);
	while(isdefined(self))
	{
		wait(0.1);
		func_21D1(0);
	}
}

//Function Id: 0x21D1
//Function Number: 3
func_21D1(param_00)
{
	var_01 = 0;
	var_02 = -1;
	foreach(var_04 in level.var_620F)
	{
		if(var_04 method_858B(self.var_0116))
		{
			var_01 = 1;
			var_02 = int(var_04.var_0165);
			continue;
		}
	}

	if(var_01)
	{
		if(param_00 || var_02 != self.var_2942)
		{
			self.var_2942 = var_02;
			self setclientomnvar("ui_minimap_location_callout",self.var_2942);
		}

		self.var_99F2 = gettime();
	}

	if(!var_01 && self.var_2942 != -1 && !isdefined(self.var_99F2) || self.var_99F2 + 2000 < gettime())
	{
		self.var_2942 = -1;
		self setclientomnvar("ui_minimap_location_callout",-1);
	}
}