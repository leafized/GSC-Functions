// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\lui_shared.csc;

class class_b7f44132 : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_b7f44132
		Checksum: 0xDD5339FC
		Offset: 0x238
		Size: 0x14
		Parameters: 0
		Flags: Linked, 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_b7f44132
		Checksum: 0xCE8B3F15
		Offset: 0x428
		Size: 0x14
		Parameters: 0
		Flags: Linked, 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: function_7f5a9fed
		Namespace: namespace_b7f44132
		Checksum: 0x31406B6D
		Offset: 0x3F0
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_7f5a9fed(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "isAlive", value);
	}

	/*
		Name: function_3b7b386a
		Namespace: namespace_b7f44132
		Checksum: 0x9FBE7107
		Offset: 0x3B8
		Size: 0x30
		Parameters: 2
		Flags: Linked
	*/
	function function_3b7b386a(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "clientnum", value);
	}

	/*
		Name: open
		Namespace: namespace_b7f44132
		Checksum: 0x20F9D129
		Offset: 0x380
		Size: 0x2C
		Parameters: 1
		Flags: Linked
	*/
	function open(localclientnum)
	{
		namespace_6aaccc24::open(localclientnum, #"spectrerisingindicator");
	}

	/*
		Name: function_fa582112
		Namespace: namespace_b7f44132
		Checksum: 0x277EB428
		Offset: 0x318
		Size: 0x5C
		Parameters: 1
		Flags: Linked
	*/
	function function_fa582112(localclientnum)
	{
		namespace_6aaccc24::function_fa582112(localclientnum);
		[[ self ]]->function_d7d2fcce(localclientnum, "clientnum", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "isAlive", 0);
	}

	/*
		Name: function_5c1bb138
		Namespace: namespace_b7f44132
		Checksum: 0x1AE94536
		Offset: 0x2E8
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
		Namespace: namespace_b7f44132
		Checksum: 0x65364C7B
		Offset: 0x258
		Size: 0x84
		Parameters: 3
		Flags: Linked
	*/
	function setup_clientfields(uid, var_c05c67e2, var_f25b9f45)
	{
		namespace_6aaccc24::setup_clientfields(uid);
		namespace_6aaccc24::function_da693cbe("clientnum", 1, 7, "int", var_c05c67e2);
		namespace_6aaccc24::function_da693cbe("isAlive", 1, 1, "int", var_f25b9f45);
	}

}

#namespace spectrerisingindicator;

/*
	Name: register
	Namespace: spectrerisingindicator
	Checksum: 0x213F0B2B
	Offset: 0xB8
	Size: 0x58
	Parameters: 3
	Flags: Linked
*/
function register(uid, var_c05c67e2, var_f25b9f45)
{
	elem = new class_b7f44132();
	[[ elem ]]->setup_clientfields(uid, var_c05c67e2, var_f25b9f45);
	return elem;
}

/*
	Name: function_5c1bb138
	Namespace: spectrerisingindicator
	Checksum: 0xD275265A
	Offset: 0x118
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_5c1bb138(uid)
{
	elem = new class_b7f44132();
	[[ elem ]]->function_5c1bb138(uid);
	return elem;
}

/*
	Name: open
	Namespace: spectrerisingindicator
	Checksum: 0x8FC4912A
	Offset: 0x160
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
	Namespace: spectrerisingindicator
	Checksum: 0x480B25D4
	Offset: 0x188
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
	Namespace: spectrerisingindicator
	Checksum: 0x188E232B
	Offset: 0x1B0
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function is_open(localclientnum)
{
	return [[ self ]]->is_open(localclientnum);
}

/*
	Name: function_3b7b386a
	Namespace: spectrerisingindicator
	Checksum: 0x32292A5E
	Offset: 0x1D8
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_3b7b386a(localclientnum, value)
{
	[[ self ]]->function_3b7b386a(localclientnum, value);
}

/*
	Name: function_7f5a9fed
	Namespace: spectrerisingindicator
	Checksum: 0xF2C22BE4
	Offset: 0x208
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_7f5a9fed(localclientnum, value)
{
	[[ self ]]->function_7f5a9fed(localclientnum, value);
}

