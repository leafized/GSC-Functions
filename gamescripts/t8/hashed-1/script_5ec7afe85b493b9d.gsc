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

#namespace zm_talisman_perk_permanent_4;

/*
	Name: function_89f2df9
	Namespace: zm_talisman_perk_permanent_4
	Checksum: 0x2FB60F68
	Offset: 0xD0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"zm_talisman_perk_permanent_4", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_talisman_perk_permanent_4
	Checksum: 0xD4FD3E61
	Offset: 0x118
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_talisman::function_88a60d36("talisman_perk_permanent_4", &activate_talisman);
}

/*
	Name: activate_talisman
	Namespace: zm_talisman_perk_permanent_4
	Checksum: 0x7E39CB7
	Offset: 0x150
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function activate_talisman()
{
	self.var_c4cce77d = 4;
}

