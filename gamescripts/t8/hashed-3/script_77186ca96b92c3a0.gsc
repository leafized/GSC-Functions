// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_171437aa8f3ddc24;
#using scripts\core_common\system_shared.csc;

#namespace namespace_b6e8664e;

/*
	Name: function_89f2df9
	Namespace: namespace_b6e8664e
	Checksum: 0x2ABE99D
	Offset: 0x78
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_5f346d1d9a7b2a08", &__init__, undefined, #"hash_1fd69f0c10bde41c");
}

/*
	Name: __init__
	Namespace: namespace_b6e8664e
	Checksum: 0xD721633
	Offset: 0xC8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	namespace_fa6b9ef8::function_82330491(#"hash_772c78d5db0889f1", #"hash_78c357c8a5680d67", #"hash_9e0be370fa2d311", &function_d95e620c, #"hash_91d5ea7b26a8aca", #"hash_91d5da7b26a8917");
}

/*
	Name: function_d95e620c
	Namespace: namespace_b6e8664e
	Checksum: 0xE5515B19
	Offset: 0x148
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_d95e620c()
{
	var_4bbd2b8a = (isdefined(getgametypesetting(#"hash_50b1121aee76a7e4")) ? getgametypesetting(#"hash_50b1121aee76a7e4") : 0) && (isdefined(getgametypesetting(#"hash_34ea44c91776e52c")) ? getgametypesetting(#"hash_34ea44c91776e52c") : 0);
	return var_4bbd2b8a;
}

