/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: 640.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 11
 * Decompile Time: 1 ms
 * Timestamp: 8/24/2021 10:29:37 PM
*******************************************************************/

//Function Id: 0x1CE0
//Function Number: 1
lib_0280::func_1CE0(param_00)
{
	function_02F1(param_00);
}

//Function Id: 0x1CDF
//Function Number: 2
lib_0280::func_1CDF(param_00,param_01,param_02,param_03)
{
	function_02EF(param_00,param_01,param_02,param_03);
}

//Function Id: 0x1CDB
//Function Number: 3
lib_0280::func_1CDB(param_00)
{
	return function_02F3(param_00);
}

//Function Id: 0x1CDD
//Function Number: 4
lib_0280::func_1CDD(param_00,param_01,param_02,param_03,param_04)
{
	function_02F0(param_00,param_01,param_02,param_03,param_04);
}

//Function Id: 0x1CDE
//Function Number: 5
lib_0280::func_1CDE(param_00,param_01,param_02,param_03,param_04)
{
	function_02F0(param_00,param_01,param_02,param_03,param_04);
}

//Function Id: 0x1CDA
//Function Number: 6
lib_0280::func_1CDA()
{
	function_02F2();
}

//Function Id: 0x1CE1
//Function Number: 7
lib_0280::func_1CE1()
{
	self method_858F();
}

//Function Id: 0x1CDC
//Function Number: 8
lib_0280::func_1CDC(param_00,param_01,param_02,param_03,param_04,param_05)
{
	function_02F4(param_00,param_01,param_02,param_03,param_04,param_05);
}

//Function Id: 0x002D
//Function Number: 9
lib_0280::func_002D(param_00,param_01,param_02,param_03)
{
	var_04 = level.var_54F7;
	var_05 = gettime();
	if(isdefined(param_03))
	{
		var_06 = [[ param_03 ]]();
		var_04 = [[ param_01 ]](param_02,var_06);
	}
	else
	{
		var_04 = [[ param_01 ]](param_02);
	}

	if(!isdefined(var_04))
	{
		return 3;
	}

	if(var_04 == level.var_39EB)
	{
		return 0;
	}

	if(var_04 == level.var_94D4)
	{
		return 1;
	}

	if(var_04 == level.var_7FB8)
	{
		return 2;
	}

	return 3;
}

//Function Id: 0x1CD8
//Function Number: 10
lib_0280::func_1CD8(param_00)
{
}

//Function Id: 0x1CD9
//Function Number: 11
lib_0280::func_1CD9(param_00)
{
}