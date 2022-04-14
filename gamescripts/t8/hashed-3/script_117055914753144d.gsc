// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\lui_shared.csc;

class class_8305f378 : class_6aaccc24
{

	/*
		Name: constructor
		Namespace: namespace_8305f378
		Checksum: 0x458129F0
		Offset: 0x330
		Size: 0x14
		Parameters: 0
		Flags: 8
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_8305f378
		Checksum: 0x86FA6254
		Offset: 0x970
		Size: 0x14
		Parameters: 0
		Flags: 16, 128
	*/
	destructor()
	{
	}

	/*
		Name: function_3de638a
		Namespace: namespace_8305f378
		Checksum: 0xCF225402
		Offset: 0x938
		Size: 0x30
		Parameters: 2
		Flags: None
	*/
	function function_3de638a(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "medalThresholds", value);
	}

	/*
		Name: function_1ca82588
		Namespace: namespace_8305f378
		Checksum: 0x1EA2A59B
		Offset: 0x900
		Size: 0x30
		Parameters: 2
		Flags: None
	*/
	function function_1ca82588(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "missionResultMsg", value);
	}

	/*
		Name: function_f8ec6ad7
		Namespace: namespace_8305f378
		Checksum: 0x2315508B
		Offset: 0x8C8
		Size: 0x30
		Parameters: 2
		Flags: None
	*/
	function function_f8ec6ad7(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "bestTimeMilliseconds", value);
	}

	/*
		Name: function_4d4ee577
		Namespace: namespace_8305f378
		Checksum: 0xD5A20EE6
		Offset: 0x890
		Size: 0x30
		Parameters: 2
		Flags: None
	*/
	function function_4d4ee577(localclientnum, value)
	{
		[[ self ]]->function_d7d2fcce(localclientnum, "timeMilliseconds", value);
	}

	/*
		Name: set_state
		Namespace: namespace_8305f378
		Checksum: 0x2C98A537
		Offset: 0x5A8
		Size: 0x2DC
		Parameters: 2
		Flags: None
	*/
	function set_state(localclientnum, state_name)
	{
		if(#"defaultstate" == state_name)
		{
			[[ self ]]->function_d7d2fcce(localclientnum, "_state", 0);
		}
		else
		{
			if(#"hash_9eb93e70b62ebd" == state_name)
			{
				[[ self ]]->function_d7d2fcce(localclientnum, "_state", 1);
			}
			else
			{
				if(#"hash_e4c570778eda419" == state_name)
				{
					[[ self ]]->function_d7d2fcce(localclientnum, "_state", 2);
				}
				else
				{
					if(#"fail" == state_name)
					{
						[[ self ]]->function_d7d2fcce(localclientnum, "_state", 3);
					}
					else
					{
						if(#"hash_718c7e5495bf7124" == state_name)
						{
							[[ self ]]->function_d7d2fcce(localclientnum, "_state", 4);
						}
						else
						{
							if(#"hash_548784ff7a210cc0" == state_name)
							{
								[[ self ]]->function_d7d2fcce(localclientnum, "_state", 5);
							}
							else
							{
								if(#"hash_3d4fff458e63e427" == state_name)
								{
									[[ self ]]->function_d7d2fcce(localclientnum, "_state", 6);
								}
								else
								{
									if(#"hash_44e0b76bd50b192e" == state_name)
									{
										[[ self ]]->function_d7d2fcce(localclientnum, "_state", 7);
									}
									else
									{
										if(#"hash_18174a43e0ca3b90" == state_name)
										{
											[[ self ]]->function_d7d2fcce(localclientnum, "_state", 8);
										}
										else
										{
											if(#"hash_3327faf4ae535f2b" == state_name)
											{
												[[ self ]]->function_d7d2fcce(localclientnum, "_state", 9);
											}
											else
											{
												if(#"hash_32ceb5e1ecc00d78" == state_name)
												{
													[[ self ]]->function_d7d2fcce(localclientnum, "_state", 10);
												}
												else
												{
													if(#"hash_71b423d13c228d59" == state_name)
													{
														[[ self ]]->function_d7d2fcce(localclientnum, "_state", 11);
													}
													else
													{
														/#
															assertmsg("");
														#/
														/#
														#/
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	/*
		Name: open
		Namespace: namespace_8305f378
		Checksum: 0x1F7F7E7D
		Offset: 0x570
		Size: 0x2C
		Parameters: 1
		Flags: None
	*/
	function open(localclientnum)
	{
		namespace_6aaccc24::open(localclientnum, #"hash_68dbe5296e5fce65");
	}

	/*
		Name: function_fa582112
		Namespace: namespace_8305f378
		Checksum: 0x903C3B6E
		Offset: 0x498
		Size: 0xCC
		Parameters: 1
		Flags: None
	*/
	function function_fa582112(localclientnum)
	{
		namespace_6aaccc24::function_fa582112(localclientnum);
		[[ self ]]->set_state(localclientnum, #"defaultstate");
		[[ self ]]->function_d7d2fcce(localclientnum, "timeMilliseconds", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "bestTimeMilliseconds", 0);
		[[ self ]]->function_d7d2fcce(localclientnum, "missionResultMsg", #"");
		[[ self ]]->function_d7d2fcce(localclientnum, "medalThresholds", #"");
	}

	/*
		Name: function_5c1bb138
		Namespace: namespace_8305f378
		Checksum: 0xAB58DEE
		Offset: 0x468
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
		Namespace: namespace_8305f378
		Checksum: 0x12FFBB4F
		Offset: 0x350
		Size: 0x10C
		Parameters: 5
		Flags: None
	*/
	function setup_clientfields(uid, var_fa61efce, var_a2ce4dd8, var_28aefa0, var_30cfd9be)
	{
		namespace_6aaccc24::setup_clientfields(uid);
		namespace_6aaccc24::function_da693cbe("_state", 1, 4, "int");
		namespace_6aaccc24::function_da693cbe("timeMilliseconds", 1, 14, "int", var_fa61efce);
		namespace_6aaccc24::function_da693cbe("bestTimeMilliseconds", 1, 14, "int", var_a2ce4dd8);
		namespace_6aaccc24::function_dcb34c80("string", "missionResultMsg", 1);
		namespace_6aaccc24::function_dcb34c80("string", "medalThresholds", 1);
	}

}

#namespace namespace_5cb8426f;

/*
	Name: register
	Namespace: namespace_5cb8426f
	Checksum: 0x6BAF0A55
	Offset: 0x108
	Size: 0x70
	Parameters: 5
	Flags: None
*/
function register(uid, var_fa61efce, var_a2ce4dd8, var_28aefa0, var_30cfd9be)
{
	elem = new class_8305f378();
	[[ elem ]]->setup_clientfields(uid, var_fa61efce, var_a2ce4dd8, var_28aefa0, var_30cfd9be);
	return elem;
}

/*
	Name: function_5c1bb138
	Namespace: namespace_5cb8426f
	Checksum: 0x2039AF39
	Offset: 0x180
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_5c1bb138(uid)
{
	elem = new class_8305f378();
	[[ elem ]]->function_5c1bb138(uid);
	return elem;
}

/*
	Name: open
	Namespace: namespace_5cb8426f
	Checksum: 0xAECA93D2
	Offset: 0x1C8
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
	Namespace: namespace_5cb8426f
	Checksum: 0xBEF23E4
	Offset: 0x1F0
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
	Namespace: namespace_5cb8426f
	Checksum: 0x8E64B0E8
	Offset: 0x218
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function is_open(localclientnum)
{
	return [[ self ]]->is_open(localclientnum);
}

/*
	Name: set_state
	Namespace: namespace_5cb8426f
	Checksum: 0xD6875125
	Offset: 0x240
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function set_state(localclientnum, state_name)
{
	[[ self ]]->set_state(localclientnum, state_name);
}

/*
	Name: function_4d4ee577
	Namespace: namespace_5cb8426f
	Checksum: 0xF036B1C2
	Offset: 0x270
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_4d4ee577(localclientnum, value)
{
	[[ self ]]->function_4d4ee577(localclientnum, value);
}

/*
	Name: function_f8ec6ad7
	Namespace: namespace_5cb8426f
	Checksum: 0x75089D9
	Offset: 0x2A0
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_f8ec6ad7(localclientnum, value)
{
	[[ self ]]->function_f8ec6ad7(localclientnum, value);
}

/*
	Name: function_1ca82588
	Namespace: namespace_5cb8426f
	Checksum: 0x4B732412
	Offset: 0x2D0
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_1ca82588(localclientnum, value)
{
	[[ self ]]->function_1ca82588(localclientnum, value);
}

/*
	Name: function_3de638a
	Namespace: namespace_5cb8426f
	Checksum: 0xCBDEC09
	Offset: 0x300
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function function_3de638a(localclientnum, value)
{
	[[ self ]]->function_3de638a(localclientnum, value);
}

