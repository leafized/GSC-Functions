// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\lui_shared.csc;

class class_14224618 : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_14224618
		Checksum: 0xE8886016
		Offset: 0x3A0
		Size: 0x14
		Parameters: 0
		Flags: Linked, 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_14224618
		Checksum: 0x643ED5B6
		Offset: 0x848
		Size: 0x14
		Parameters: 0
		Flags: Linked, 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: function_ae1277a0
		Namespace: namespace_14224618
		Checksum: 0xA96A7069
		Offset: 0x810
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_ae1277a0(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "drawHUD", value);
	}

	/*
		Name: function_331f9dd
		Namespace: namespace_14224618
		Checksum: 0x762135CA
		Offset: 0x7D8
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_331f9dd(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "endAlpha", value);
	}

	/*
		Name: function_9cd54463
		Namespace: namespace_14224618
		Checksum: 0x2F79870B
		Offset: 0x7A0
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_9cd54463(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "startAlpha", value);
	}

	/*
		Name: function_237ff433
		Namespace: namespace_14224618
		Checksum: 0x780C8161
		Offset: 0x768
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_237ff433(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "fadeOverTime", value);
	}

	/*
		Name: function_7420df0a
		Namespace: namespace_14224618
		Checksum: 0x51E86F79
		Offset: 0x730
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_7420df0a(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "blue", value);
	}

	/*
		Name: function_2208b8db
		Namespace: namespace_14224618
		Checksum: 0x87EFAB85
		Offset: 0x6F8
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_2208b8db(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "green", value);
	}

	/*
		Name: function_eccc151d
		Namespace: namespace_14224618
		Checksum: 0x59BF51D1
		Offset: 0x6C0
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_eccc151d(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "red", value);
	}

	/*
		Name: open
		Namespace: namespace_14224618
		Checksum: 0x1F1F9B49
		Offset: 0x688
		Size: 0x2C
		Parameters: 1
		Flags: Linked
	*/
	function open(localclientnum)
	{
		namespace_6aaccc24::open(localclientnum, #"full_screen_black");
	}

	/*
		Name: function_fa582112
		Namespace: namespace_14224618
		Checksum: 0xD53FCE31
		Offset: 0x570
		Size: 0x110
		Parameters: 1
		Flags: Linked
	*/
	function function_fa582112(localclientnum)
	{
		namespace_6aaccc24::function_fa582112(localclientnum);
		[[ self ]]->function_d7d2fcce(localclientnum, "red", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "green", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "blue", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "fadeOverTime", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "startAlpha", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "endAlpha", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "drawHUD", 0);
	}

	/*
		Name: function_5c1bb138
		Namespace: namespace_14224618
		Checksum: 0x805BB644
		Offset: 0x540
		Size: 0x24
		Parameters: 1
		Flags: Linked
	*/
	function function_5c1bb138(uid)
	{
		namespace_6aaccc24::function_5c1bb138(uid);
	}

	/*
		Name: setup_clientfields
		Namespace: namespace_14224618
		Checksum: 0xB7350A45
		Offset: 0x3C0
		Size: 0x174
		Parameters: 8
		Flags: Linked
	*/
	function setup_clientfields(uid, var_9350f184, var_788c188f, var_3fb95ac9, var_a3e0a6ce, var_b046940, var_34291db, var_32445b2)
	{
		namespace_6aaccc24::setup_clientfields(uid);
		namespace_6aaccc24::function_da693cbe("red", 1, 3, "float", var_9350f184);
		namespace_6aaccc24::function_da693cbe("green", 1, 3, "float", var_788c188f);
		namespace_6aaccc24::function_da693cbe("blue", 1, 3, "float", var_3fb95ac9);
		namespace_6aaccc24::function_da693cbe("fadeOverTime", 1, 12, "int", var_a3e0a6ce);
		namespace_6aaccc24::function_da693cbe("startAlpha", 1, 5, "float", var_b046940);
		namespace_6aaccc24::function_da693cbe("endAlpha", 1, 5, "float", var_34291db);
		namespace_6aaccc24::function_da693cbe("drawHUD", 1, 1, "int", var_32445b2);
	}

}

#namespace full_screen_black;

/*
	Name: register
	Namespace: full_screen_black
	Checksum: 0x320D2459
	Offset: 0xF0
	Size: 0x94
	Parameters: 8
	Flags: Linked
*/
function register(uid, var_9350f184, var_788c188f, var_3fb95ac9, var_a3e0a6ce, var_b046940, var_34291db, var_32445b2)
{
	elem = new class_14224618();
	[[ elem ]]->setup_clientfields(uid, var_9350f184, var_788c188f, var_3fb95ac9, var_a3e0a6ce, var_b046940, var_34291db, var_32445b2);
	return elem;
}

/*
	Name: function_5c1bb138
	Namespace: full_screen_black
	Checksum: 0x9EC43F2D
	Offset: 0x190
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_5c1bb138(uid)
{
	elem = new class_14224618();
	[[ elem ]]->function_5c1bb138(uid);
	return elem;
}

/*
	Name: open
	Namespace: full_screen_black
	Checksum: 0xB631F30B
	Offset: 0x1D8
	Size: 0x1C
	Parameters: 1
	Flags: None
*/
function open(player)
{
	[[ self ]]->open(player);
}

/*
	Name: close
	Namespace: full_screen_black
	Checksum: 0x131FB4BD
	Offset: 0x200
	Size: 0x1C
	Parameters: 1
	Flags: None
*/
function close(player)
{
	[[ self ]]->close(player);
}

/*
	Name: is_open
	Namespace: full_screen_black
	Checksum: 0xE1A3A1E5
	Offset: 0x228
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function is_open(localclientnum)
{
	return [[ self ]]->is_open(localclientnum);
}

/*
	Name: function_eccc151d
	Namespace: full_screen_black
	Checksum: 0x7056E8B8
	Offset: 0x250
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_eccc151d(localclientnum, value)
{
	[[ self ]]->function_eccc151d(localclientnum, value);
}

/*
	Name: function_2208b8db
	Namespace: full_screen_black
	Checksum: 0x9C50F715
	Offset: 0x280
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_2208b8db(localclientnum, value)
{
	[[ self ]]->function_2208b8db(localclientnum, value);
}

/*
	Name: function_7420df0a
	Namespace: full_screen_black
	Checksum: 0xD20AB2CD
	Offset: 0x2B0
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_7420df0a(localclientnum, value)
{
	[[ self ]]->function_7420df0a(localclientnum, value);
}

/*
	Name: function_237ff433
	Namespace: full_screen_black
	Checksum: 0x4371CE57
	Offset: 0x2E0
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_237ff433(localclientnum, value)
{
	[[ self ]]->function_237ff433(localclientnum, value);
}

/*
	Name: function_9cd54463
	Namespace: full_screen_black
	Checksum: 0x558D1C5A
	Offset: 0x310
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_9cd54463(localclientnum, value)
{
	[[ self ]]->function_9cd54463(localclientnum, value);
}

/*
	Name: function_331f9dd
	Namespace: full_screen_black
	Checksum: 0x9254A5B7
	Offset: 0x340
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_331f9dd(localclientnum, value)
{
	[[ self ]]->function_331f9dd(localclientnum, value);
}

/*
	Name: function_ae1277a0
	Namespace: full_screen_black
	Checksum: 0xBBD2D0CF
	Offset: 0x370
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_ae1277a0(localclientnum, value)
{
	[[ self ]]->function_ae1277a0(localclientnum, value);
}

