// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\lui_shared.csc;

class class_e5d48e46 : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_e5d48e46
		Checksum: 0x5A1F9D79
		Offset: 0x1F0
		Size: 0x14
		Parameters: 0
		Flags: Linked, 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_e5d48e46
		Checksum: 0x38E5B514
		Offset: 0x398
		Size: 0x14
		Parameters: 0
		Flags: Linked, 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: function_693a2be8
		Namespace: namespace_e5d48e46
		Checksum: 0xE043B1B9
		Offset: 0x320
		Size: 0x6C
		Parameters: 1
		Flags: Linked
	*/
	function function_693a2be8(localclientnum)
	{
		current_val = [[ self ]]->function_92ba69fa(localclientnum, "pulse");
		new_val = (current_val + 1) % 2;
		[[ self ]]->function_d7d2fcce(localclientnum, "pulse", new_val);
	}

	/*
		Name: open
		Namespace: namespace_e5d48e46
		Checksum: 0x62DCC94F
		Offset: 0x2E8
		Size: 0x2C
		Parameters: 1
		Flags: Linked
	*/
	function open(localclientnum)
	{
		namespace_6aaccc24::open(localclientnum, #"scavenger_icon");
	}

	/*
		Name: function_fa582112
		Namespace: namespace_e5d48e46
		Checksum: 0x8692CDA2
		Offset: 0x2A0
		Size: 0x40
		Parameters: 1
		Flags: Linked
	*/
	function function_fa582112(localclientnum)
	{
		namespace_6aaccc24::function_fa582112(localclientnum);
		[[ self ]]->function_d7d2fcce(localclientnum, "pulse", 0);
	}

	/*
		Name: function_5c1bb138
		Namespace: namespace_e5d48e46
		Checksum: 0x584E9E2C
		Offset: 0x270
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
		Namespace: namespace_e5d48e46
		Checksum: 0x28AD2964
		Offset: 0x210
		Size: 0x54
		Parameters: 2
		Flags: Linked
	*/
	function setup_clientfields(uid, var_bea2552f)
	{
		namespace_6aaccc24::setup_clientfields(uid);
		namespace_6aaccc24::function_da693cbe("pulse", 1, 1, "counter", var_bea2552f);
	}

}

#namespace scavenger_icon;

/*
	Name: register
	Namespace: scavenger_icon
	Checksum: 0xB31CCEE8
	Offset: 0xB0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function register(uid, var_bea2552f)
{
	elem = new class_e5d48e46();
	[[ elem ]]->setup_clientfields(uid, var_bea2552f);
	return elem;
}

/*
	Name: function_5c1bb138
	Namespace: scavenger_icon
	Checksum: 0xF35D5888
	Offset: 0x108
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_5c1bb138(uid)
{
	elem = new class_e5d48e46();
	[[ elem ]]->function_5c1bb138(uid);
	return elem;
}

/*
	Name: open
	Namespace: scavenger_icon
	Checksum: 0x401A29F5
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
	Namespace: scavenger_icon
	Checksum: 0xC1539E1F
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
	Namespace: scavenger_icon
	Checksum: 0x6EAA0A23
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
	Name: function_693a2be8
	Namespace: scavenger_icon
	Checksum: 0xC168E99F
	Offset: 0x1C8
	Size: 0x1C
	Parameters: 1
	Flags: None
*/
function function_693a2be8(localclientnum)
{
	[[ self ]]->function_693a2be8(localclientnum);
}

