// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\lui_shared.csc;

class class_600b033d : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_600b033d
		Checksum: 0x1114332D
		Offset: 0x1F8
		Size: 0x14
		Parameters: 0
		Flags: 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_600b033d
		Checksum: 0x75561621
		Offset: 0x360
		Size: 0x14
		Parameters: 0
		Flags: 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: set_revive_time
		Namespace: namespace_600b033d
		Checksum: 0xC12AB88D
		Offset: 0x328
		Size: 0x30
		Parameters: 2
		Flags: None
	*/
	function set_revive_time(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "revive_time", value);
	}

	/*
		Name: open
		Namespace: namespace_600b033d
		Checksum: 0x89E61657
		Offset: 0x2F0
		Size: 0x2C
		Parameters: 1
		Flags: None
	*/
	function open(localclientnum)
	{
		namespace_6aaccc24::open(localclientnum, #"self_revive_visuals_rush");
	}

	/*
		Name: function_fa582112
		Namespace: namespace_600b033d
		Checksum: 0xDB127588
		Offset: 0x2A8
		Size: 0x40
		Parameters: 1
		Flags: None
	*/
	function function_fa582112(localclientnum)
	{
		namespace_6aaccc24::function_fa582112(localclientnum);
		[[ self ]]->function_d7d2fcce(localclientnum, "revive_time", 0);
	}

	/*
		Name: function_5c1bb138
		Namespace: namespace_600b033d
		Checksum: 0x8260C864
		Offset: 0x278
		Size: 0x24
		Parameters: 1
		Flags: None
	*/
	function function_5c1bb138(uid)
	{
		namespace_6aaccc24::function_5c1bb138(uid);
	}

	/*
		Name: setup_clientfields
		Namespace: namespace_600b033d
		Checksum: 0x29417742
		Offset: 0x218
		Size: 0x54
		Parameters: 2
		Flags: None
	*/
	function setup_clientfields(uid, var_2e62cab3)
	{
		namespace_6aaccc24::setup_clientfields(uid);
		namespace_6aaccc24::function_da693cbe("revive_time", 1, 4, "int", var_2e62cab3);
	}

}

#namespace self_revive_visuals_rush;

/*
	Name: register
	Namespace: self_revive_visuals_rush
	Checksum: 0x785C07F7
	Offset: 0xB0
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function register(uid, var_2e62cab3)
{
	elem = new class_600b033d();
	[[ elem ]]->setup_clientfields(uid, var_2e62cab3);
	return elem;
}

/*
	Name: function_5c1bb138
	Namespace: self_revive_visuals_rush
	Checksum: 0x121ED2F2
	Offset: 0x108
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_5c1bb138(uid)
{
	elem = new class_600b033d();
	[[ elem ]]->function_5c1bb138(uid);
	return elem;
}

/*
	Name: open
	Namespace: self_revive_visuals_rush
	Checksum: 0x6A447992
	Offset: 0x150
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
	Namespace: self_revive_visuals_rush
	Checksum: 0x21C34CC8
	Offset: 0x178
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
	Namespace: self_revive_visuals_rush
	Checksum: 0xD656FA23
	Offset: 0x1A0
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function is_open(localclientnum)
{
	return [[ self ]]->is_open(localclientnum);
}

/*
	Name: set_revive_time
	Namespace: self_revive_visuals_rush
	Checksum: 0x579B804D
	Offset: 0x1C8
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function set_revive_time(localclientnum, value)
{
	[[ self ]]->set_revive_time(localclientnum, value);
}

