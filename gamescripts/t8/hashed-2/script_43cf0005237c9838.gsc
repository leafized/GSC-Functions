// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\system_shared.csc;
#using scripts\zm_common\zm_bgb.csc;

#namespace namespace_2dadcb58;

/*
	Name: function_89f2df9
	Namespace: namespace_2dadcb58
	Checksum: 0x4FB37922
	Offset: 0x88
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_242c2a18cea5e1", &__init__, undefined, #"bgb");
}

/*
	Name: __init__
	Namespace: namespace_2dadcb58
	Checksum: 0x36C2F529
	Offset: 0xD8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register(#"hash_242c2a18cea5e1", "activated");
}

