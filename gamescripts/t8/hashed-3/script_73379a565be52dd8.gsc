// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_2595527427ea71eb;
#using script_27c22e1d8df4d852;
#using script_6021ce59143452c3;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\system_shared.gsc;

#namespace namespace_11338c5f;

/*
	Name: function_89f2df9
	Namespace: namespace_11338c5f
	Checksum: 0xF305A062
	Offset: 0xA0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_5c210d5d635233ba", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_11338c5f
	Checksum: 0x5E63C76A
	Offset: 0xE8
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
	zm_trial::register_challenge(#"hash_4746da5c54386c3d", &function_d1de6a85, &function_9e7b3f4d);
}

/*
	Name: function_d1de6a85
	Namespace: namespace_11338c5f
	Checksum: 0x7C21EE17
	Offset: 0x150
	Size: 0x108
	Parameters: 1
	Flags: Private
*/
function private function_d1de6a85(n_timer)
{
	n_timer = zm_trial::function_5769f26a(n_timer);
	level.var_63c017bd = n_timer;
	callback::on_spawned(&on_player_spawned);
	callback::add_callback(#"hash_137b937fd26992be", &function_ff66b979);
	foreach(player in getplayers())
	{
		player thread function_2e2a518(n_timer);
	}
}

/*
	Name: function_9e7b3f4d
	Namespace: namespace_11338c5f
	Checksum: 0xB1732B09
	Offset: 0x260
	Size: 0xE0
	Parameters: 1
	Flags: Private
*/
function private function_9e7b3f4d(round_reset)
{
	level.var_63c017bd = undefined;
	callback::remove_on_spawned(&on_player_spawned);
	callback::remove_callback(#"hash_137b937fd26992be", &function_ff66b979);
	foreach(player in getplayers())
	{
		player stop_timer();
	}
}

/*
	Name: function_2e2a518
	Namespace: namespace_11338c5f
	Checksum: 0xFBC2EA30
	Offset: 0x348
	Size: 0x184
	Parameters: 2
	Flags: Private
*/
function private function_2e2a518(n_timer, var_f97d1a30)
{
	self endon(#"disconnect");
	level endon(#"hash_7646638df88a3656", #"hash_76fb373d2d71c744", #"host_migration_begin");
	if(!(isdefined(var_f97d1a30) && var_f97d1a30))
	{
		wait(12);
	}
	while(true)
	{
		while(!isalive(self))
		{
			self waittill(#"spawned");
			wait(2);
		}
		self start_timer(n_timer, var_f97d1a30);
		var_be17187b = undefined;
		var_be17187b = self waittilltimeout(n_timer, #"spent_points", #"hash_14b0ad44336160bc");
		self stop_timer();
		if(var_be17187b._notify == "timeout")
		{
			zm_trial::fail(#"hash_1a444a987e075837", array(self));
			level notify(#"hash_76fb373d2d71c744");
			return;
		}
		wait(3);
	}
}

/*
	Name: on_player_spawned
	Namespace: namespace_11338c5f
	Checksum: 0x5B2C53BF
	Offset: 0x4D8
	Size: 0x5C
	Parameters: 0
	Flags: Private
*/
function private on_player_spawned()
{
	self endon(#"disconnect");
	level endon(#"host_migration_begin");
	wait(2);
	if(isdefined(self.n_time_remaining))
	{
		self start_timer(self.n_time_remaining);
	}
}

/*
	Name: start_timer
	Namespace: namespace_11338c5f
	Checksum: 0x92F5C193
	Offset: 0x540
	Size: 0xCC
	Parameters: 2
	Flags: Private
*/
function private start_timer(timeout, var_f97d1a30)
{
	if(!level.var_f995ece6 zm_trial_timer::is_open(self))
	{
		level.var_f995ece6 zm_trial_timer::open(self);
		level.var_f995ece6 zm_trial_timer::function_8ede8e82(self, #"hash_424e01ea2299eec0");
		level.var_f995ece6 zm_trial_timer::function_6ad54036(self, 1);
		self namespace_b22c99a5::start_timer(timeout);
		self thread function_a0f0109f(timeout, var_f97d1a30);
	}
}

/*
	Name: function_a0f0109f
	Namespace: namespace_11338c5f
	Checksum: 0x3A613C17
	Offset: 0x618
	Size: 0xC8
	Parameters: 2
	Flags: None
*/
function function_a0f0109f(timeout, var_f97d1a30)
{
	if(isdefined(self.n_time_remaining) && (!(isdefined(var_f97d1a30) && var_f97d1a30)))
	{
		return;
	}
	self endon(#"disconnect", #"hash_2a79adac1fd03c09");
	level endon(#"hash_7646638df88a3656", #"end_game", #"host_migration_begin");
	if(!isdefined(self.n_time_remaining))
	{
		self.n_time_remaining = timeout;
	}
	while(self.n_time_remaining > 0)
	{
		wait(1);
		self.n_time_remaining--;
	}
}

/*
	Name: stop_timer
	Namespace: namespace_11338c5f
	Checksum: 0xF78AE29E
	Offset: 0x6E8
	Size: 0x76
	Parameters: 0
	Flags: Private
*/
function private stop_timer()
{
	if(level.var_f995ece6 zm_trial_timer::is_open(self))
	{
		level.var_f995ece6 zm_trial_timer::close(self);
		self namespace_b22c99a5::stop_timer();
	}
	self notify(#"hash_2a79adac1fd03c09");
	self.n_time_remaining = undefined;
}

/*
	Name: function_ff66b979
	Namespace: namespace_11338c5f
	Checksum: 0xC8FCA87C
	Offset: 0x768
	Size: 0x198
	Parameters: 0
	Flags: Private
*/
function private function_ff66b979()
{
	level endon(#"end_round", #"host_migration_begin");
	foreach(player in getplayers())
	{
		if(level.var_f995ece6 zm_trial_timer::is_open(player))
		{
			level.var_f995ece6 zm_trial_timer::close(player);
			player namespace_b22c99a5::stop_timer();
		}
	}
	wait(5);
	foreach(player in getplayers())
	{
		player thread function_2e2a518((isdefined(player.n_time_remaining) ? player.n_time_remaining : level.var_63c017bd), 1);
	}
}

