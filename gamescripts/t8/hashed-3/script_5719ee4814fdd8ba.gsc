// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_3affe3aaa3f22cb0;
#using scripts\core_common\system_shared.gsc;

#namespace namespace_7ce321ae;

/*
	Name: function_89f2df9
	Namespace: namespace_7ce321ae
	Checksum: 0xCE5E9AA3
	Offset: 0x78
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_28852d6f266c0fcc", &__init__, undefined, #"hash_1fd69f0c10bde41c");
}

/*
	Name: __init__
	Namespace: namespace_7ce321ae
	Checksum: 0xA7481883
	Offset: 0xC8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	namespace_fa6b9ef8::function_82330491(#"hash_64b65ba370766cff", #"hash_76cce42bfc9866cd", #"hash_68307ed314684f1d", &function_d95e620c, #"hash_555c37b28c4a770c", #"hash_555c3ab28c4a7c25");
}

/*
	Name: function_d95e620c
	Namespace: namespace_7ce321ae
	Checksum: 0x35DBC53E
	Offset: 0x148
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_d95e620c()
{
	var_17805812 = (isdefined(getgametypesetting(#"hash_50b1121aee76a7e4")) ? getgametypesetting(#"hash_50b1121aee76a7e4") : 0) && (isdefined(getgametypesetting(#"hash_6b1ec01fa78af670")) ? getgametypesetting(#"hash_6b1ec01fa78af670") : 0);
	return var_17805812;
}

