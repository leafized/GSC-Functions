// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_3469488e46c579c6;
#using scripts\core_common\system_shared.gsc;

#namespace ballistic_knife;

/*
	Name: function_89f2df9
	Namespace: ballistic_knife
	Checksum: 0x113F649D
	Offset: 0x78
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"ballistic_knife", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ballistic_knife
	Checksum: 0x2258FCB0
	Offset: 0xC0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
}

