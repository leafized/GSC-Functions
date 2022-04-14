// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\lui_shared.gsc;

class class_5d432d7d : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_5d432d7d
		Checksum: 0x6976581B
		Offset: 0x1A0
		Size: 0x14
		Parameters: 0
		Flags: 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_5d432d7d
		Checksum: 0x1F2476F9
		Offset: 0x270
		Size: 0x14
		Parameters: 0
		Flags: 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: close
		Namespace: namespace_5d432d7d
		Checksum: 0x31E6F50F
		Offset: 0x240
		Size: 0x24
		Parameters: 1
		Flags: None
	*/
	function close(player)
	{
		namespace_6aaccc24::function_a68f6e20(player);
	}

	/*
		Name: open
		Namespace: namespace_5d432d7d
		Checksum: 0x3F193464
		Offset: 0x1F0
		Size: 0x44
		Parameters: 2
		Flags: None
	*/
	function open(player, persistent = 0)
	{
		namespace_6aaccc24::function_8b8089ba(player, "ct_crash_kill_remaining_enemy", persistent);
	}

	/*
		Name: setup_clientfields
		Namespace: namespace_5d432d7d
		Checksum: 0x11774EFE
		Offset: 0x1C0
		Size: 0x24
		Parameters: 1
		Flags: None
	*/
	function setup_clientfields(uid)
	{
		namespace_6aaccc24::setup_clientfields(uid);
	}

}

#namespace ct_crash_kill_remaining_enemy;

/*
	Name: register
	Namespace: ct_crash_kill_remaining_enemy
	Checksum: 0x422151A4
	Offset: 0xC8
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function register(uid)
{
	elem = new class_5d432d7d();
	[[ elem ]]->setup_clientfields(uid);
	return elem;
}

/*
	Name: open
	Namespace: ct_crash_kill_remaining_enemy
	Checksum: 0x85BF1AB3
	Offset: 0x110
	Size: 0x38
	Parameters: 2
	Flags: None
*/
function open(player, persistent = 0)
{
	[[ self ]]->open(player, persistent);
}

/*
	Name: close
	Namespace: ct_crash_kill_remaining_enemy
	Checksum: 0xBB371E81
	Offset: 0x150
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
	Namespace: ct_crash_kill_remaining_enemy
	Checksum: 0x9BD32880
	Offset: 0x178
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function is_open(player)
{
	return [[ self ]]->function_7bfd10e6(player);
}

