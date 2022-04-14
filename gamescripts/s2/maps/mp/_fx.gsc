/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _fx.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 260 ms
 * Timestamp: 8/24/2021 10:26:33 PM
*******************************************************************/

//Function Id: 0x8274
//Function Number: 1
func_8274()
{
	if(!isdefined(self.var_81BB) || !isdefined(self.var_81BA) || !isdefined(self.var_0161))
	{
		self delete();
		return;
	}

	if(isdefined(self.var_01A2))
	{
		var_00 = getent(self.var_01A2).var_0116;
	}
	else
	{
		var_00 = "undefined";
	}

	if(self.var_81BA == "OneShotfx")
	{
	}

	if(self.var_81BA == "loopfx")
	{
	}

	if(self.var_81BA == "loopsound")
	{
	}
}

//Function Id: 0x4866
//Function Number: 2
func_4866(param_00)
{
	playfx(level.var_0611["mechanical explosion"],param_00);
	earthquake(0.15,0.5,param_00,250);
}

//Function Id: 0x8F42
//Function Number: 3
func_8F42(param_00,param_01,param_02)
{
	var_03 = spawn("script_origin",(0,0,0));
	var_03.var_0116 = param_01;
	var_03 method_861D(param_00);
	if(isdefined(param_02))
	{
		var_03 thread func_8F43(param_02);
	}
}

//Function Id: 0x8F43
//Function Number: 4
func_8F43(param_00)
{
	level waittill(param_00);
	self delete();
}

//Function Id: 0x1797
//Function Number: 5
func_1797(param_00)
{
	self waittill("death");
	param_00 delete();
}