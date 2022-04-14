/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _destructables.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 374 ms
 * Timestamp: 8/24/2021 10:26:10 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	var_00 = getentarray("destructable","targetname");
	if(getdvar("scr_destructables") == "0")
	{
		for(var_01 = 0;var_01 < var_00.size;var_01++)
		{
			var_00[var_01] delete();
		}

		return;
	}

	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_00[var_01] thread func_2DE1();
	}
}

//Function Id: 0x2DE1
//Function Number: 2
func_2DE1()
{
	var_00 = 40;
	var_01 = 0;
	if(isdefined(self.var_80F8))
	{
		var_00 = self.var_80F8;
	}

	if(isdefined(self.var_82B7))
	{
		var_01 = self.var_82B7;
	}

	if(isdefined(self.var_8162))
	{
		var_02 = strtok(self.var_8162," ");
		for(var_03 = 0;var_03 < var_02.size;var_03++)
		{
			func_17D7(var_02[var_03]);
		}
	}

	if(isdefined(self.var_81BB))
	{
		self.var_3F2F = loadfx(self.var_81BB);
	}

	var_04 = 0;
	self setcandamage(1);
	for(;;)
	{
		self waittill("damage",var_05,var_06);
		if(var_05 >= var_01)
		{
			var_04 = var_04 + var_05;
			if(var_04 >= var_00)
			{
				thread func_2DE0();
				return;
			}
		}
	}
}

//Function Id: 0x2DE0
//Function Number: 3
func_2DE0()
{
	var_00 = self;
	if(isdefined(self.var_8162))
	{
		var_01 = strtok(self.var_8162," ");
		for(var_02 = 0;var_02 < var_01.size;var_02++)
		{
			func_A017(var_01[var_02]);
		}
	}

	if(isdefined(var_00.var_3F2F))
	{
		playfx(var_00.var_3F2F,var_00.var_0116 + (0,0,6));
	}

	var_00 delete();
}

//Function Id: 0x17D7
//Function Number: 4
func_17D7(param_00)
{
}

//Function Id: 0x17E0
//Function Number: 5
func_17E0(param_00,param_01)
{
}

//Function Id: 0xA017
//Function Number: 6
func_A017(param_00)
{
}

//Function Id: 0xA018
//Function Number: 7
func_A018(param_00,param_01)
{
}