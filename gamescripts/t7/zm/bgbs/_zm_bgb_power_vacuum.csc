// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_power_vacuum;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_power_vacuum
	Checksum: 0x392D3DFD
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_power_vacuum", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_power_vacuum
	Checksum: 0x21B10EB4
	Offset: 0x188
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_power_vacuum", "rounds");
}
