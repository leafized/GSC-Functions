// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_3f9e0dc8454d98e1;
#using script_6021ce59143452c3;
#using script_61a734c95edc17aa;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\flag_shared.gsc;
#using scripts\core_common\math_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\zm_common\zm_utility.gsc;

#namespace namespace_93759983;

/*
	Name: function_89f2df9
	Namespace: namespace_93759983
	Checksum: 0xA38454FA
	Offset: 0xF8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_716faff417d0eef3", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_93759983
	Checksum: 0x55ECAE43
	Offset: 0x140
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!zm_trial::function_b47f6aba())
	{
		return;
	}
	zm_trial::register_challenge(#"hash_576c8d43b54453d0", &function_d1de6a85, &function_9e7b3f4d);
}

/*
	Name: function_d1de6a85
	Namespace: namespace_93759983
	Checksum: 0xCFBEABF8
	Offset: 0x1A8
	Size: 0x2FA
	Parameters: 1
	Flags: Private
*/
function private function_d1de6a85(var_bd9d962 = #"invert")
{
	level endon(#"hash_7646638df88a3656");
	wait(5);
	level.var_2439365b = var_bd9d962;
	switch(level.var_2439365b)
	{
		case "invert":
		{
			foreach(player in getplayers())
			{
				player clientfield::set_to_player("" + #"hash_6536ca4fb2858a9f", 1);
			}
			break;
		}
		case "turret":
		{
			foreach(player in getplayers())
			{
				player bgb_pack::function_59004002(#"zm_bgb_anywhere_but_here", 1);
				player bgb_pack::function_59004002(#"hash_a303f67afd6f4a8", 1);
				player thread function_3d8fa20a();
			}
			callback::on_ai_spawned(&function_a5b02a07);
			callback::on_spawned(&function_eaba7c6f);
			break;
		}
		case "hash_9378b865415ee5c":
		{
			foreach(player in getplayers())
			{
				player setmovespeedscale(0.5);
				player allowsprint(0);
				player allowslide(0);
			}
			break;
		}
	}
}

/*
	Name: function_9e7b3f4d
	Namespace: namespace_93759983
	Checksum: 0xD894B862
	Offset: 0x4B0
	Size: 0x306
	Parameters: 1
	Flags: Private
*/
function private function_9e7b3f4d(round_reset)
{
	switch(level.var_2439365b)
	{
		case "invert":
		{
			foreach(player in getplayers())
			{
				player clientfield::set_to_player("" + #"hash_6536ca4fb2858a9f", 0);
			}
			break;
		}
		case "turret":
		{
			foreach(player in getplayers())
			{
				player bgb_pack::function_59004002(#"zm_bgb_anywhere_but_here", 0);
				player bgb_pack::function_59004002(#"hash_a303f67afd6f4a8", 0);
				player setmovespeedscale(1);
				player allowjump(1);
				player allowprone(1);
				player allowsprint(1);
			}
			callback::remove_on_ai_spawned(&function_a5b02a07);
			callback::remove_on_spawned(&function_eaba7c6f);
			break;
		}
		case "hash_9378b865415ee5c":
		{
			foreach(player in getplayers())
			{
				player setmovespeedscale(1);
				player allowsprint(1);
				player allowslide(1);
			}
			break;
		}
	}
	level.var_2439365b = undefined;
}

/*
	Name: function_eaba7c6f
	Namespace: namespace_93759983
	Checksum: 0x48140072
	Offset: 0x7C0
	Size: 0x1C
	Parameters: 0
	Flags: Private
*/
function private function_eaba7c6f()
{
	self thread function_3d8fa20a();
}

/*
	Name: function_3d8fa20a
	Namespace: namespace_93759983
	Checksum: 0xE62260D0
	Offset: 0x7E8
	Size: 0x108
	Parameters: 0
	Flags: Private
*/
function private function_3d8fa20a()
{
	self notify("63943c3872eb77bc");
	self endon("63943c3872eb77bc");
	self endon(#"death");
	level endon(#"hash_7646638df88a3656");
	wait(5);
	while(self zm_utility::is_jumping())
	{
		waitframe(1);
	}
	self setmovespeedscale(0);
	self thread function_dc856fd8();
	while(true)
	{
		self waittill(#"player_downed");
		self setmovespeedscale(1);
		self waittill(#"player_revived");
		self setmovespeedscale(0);
	}
}

/*
	Name: function_dc856fd8
	Namespace: namespace_93759983
	Checksum: 0xD3974D2D
	Offset: 0x8F8
	Size: 0x128
	Parameters: 0
	Flags: Private
*/
function private function_dc856fd8()
{
	self notify("4becff0e4eba900e");
	self endon("4becff0e4eba900e");
	level endon(#"hash_7646638df88a3656");
	self endon(#"disconnect");
	self allowjump(0);
	self allowprone(0);
	self allowsprint(0);
	while(true)
	{
		self waittill(#"hash_7fd32c9551894e64", #"hash_424834e6dee13bc3", #"bgb_update");
		if(isalive(self))
		{
			self allowjump(0);
			self allowprone(0);
			self allowsprint(0);
		}
	}
}

/*
	Name: function_a5b02a07
	Namespace: namespace_93759983
	Checksum: 0x8A6637DE
	Offset: 0xA28
	Size: 0x184
	Parameters: 0
	Flags: Private
*/
function private function_a5b02a07()
{
	self endon(#"death");
	wait(0.5);
	n_players = getplayers().size;
	switch(n_players)
	{
		case 1:
		{
			var_e0e5e1ab = 0;
			break;
		}
		case 2:
		{
			var_e0e5e1ab = 40;
			break;
		}
		case 3:
		{
			var_e0e5e1ab = 75;
			break;
		}
		case 4:
		{
			var_e0e5e1ab = 100;
			break;
		}
	}
	if(math::cointoss(var_e0e5e1ab))
	{
		self zombie_utility::set_zombie_run_cycle("sprint");
	}
	else
	{
		if(n_players > 1)
		{
			self zombie_utility::set_zombie_run_cycle("run");
		}
		else
		{
			if(math::cointoss())
			{
				self zombie_utility::set_zombie_run_cycle("run");
			}
			else
			{
				self zombie_utility::set_zombie_run_cycle("walk");
			}
		}
	}
}

