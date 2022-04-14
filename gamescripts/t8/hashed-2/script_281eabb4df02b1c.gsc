// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\array_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\struct.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\zm_common\util.gsc;
#using scripts\zm_common\zm_stats.gsc;
#using scripts\zm_common\zm_talisman.gsc;
#using scripts\zm_common\zm_utility.gsc;

#namespace zm_talisman_box_guarantee_lmg;

/*
	Name: function_89f2df9
	Namespace: zm_talisman_box_guarantee_lmg
	Checksum: 0x34450DF
	Offset: 0xD8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"zm_talisman_box_guarantee_lmg", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_talisman_box_guarantee_lmg
	Checksum: 0x41BAE602
	Offset: 0x120
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_talisman::function_88a60d36("talisman_box_guarantee_lmg", &activate_talisman);
}

/*
	Name: activate_talisman
	Namespace: zm_talisman_box_guarantee_lmg
	Checksum: 0xC94702DD
	Offset: 0x158
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function activate_talisman()
{
	self.var_afb3ba4e = &function_8d50b46a;
	self.var_c21099c0 = 1;
}

/*
	Name: function_8d50b46a
	Namespace: zm_talisman_box_guarantee_lmg
	Checksum: 0xF5A05B0F
	Offset: 0x188
	Size: 0xFA
	Parameters: 1
	Flags: Linked
*/
function function_8d50b46a(a_keys)
{
	a_valid = array();
	foreach(var_e64c7df8 in a_keys)
	{
		if(var_e64c7df8.weapclass == "mg")
		{
			array::add(a_valid, var_e64c7df8);
		}
	}
	if(a_valid.size == 0)
	{
		a_valid = a_keys;
	}
	a_valid = array::randomize(a_valid);
	self.var_afb3ba4e = undefined;
	self.var_c21099c0 = undefined;
	return a_valid;
}

