// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_14f4a3c583c77d4b;
#using script_27c22e1d8df4d852;
#using script_2fcb47e3735a6edd;
#using script_6021ce59143452c3;
#using script_d19b1fbf1d7cdd6;
#using scripts\core_common\callbacks_shared.gsc;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\exploder_shared.gsc;
#using scripts\core_common\flag_shared.gsc;
#using scripts\core_common\scene_shared.gsc;
#using scripts\core_common\spawner_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\core_common\util_shared.gsc;
#using scripts\core_common\values_shared.gsc;
#using scripts\core_common\vehicle_shared.gsc;
#using scripts\zm_common\zm_pack_a_punch.gsc;

#namespace namespace_309b53e1;

/*
	Name: function_89f2df9
	Namespace: namespace_309b53e1
	Checksum: 0xBC44EA1
	Offset: 0x1D0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_21e6bbd00961a975", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_309b53e1
	Checksum: 0xBB6B959E
	Offset: 0x218
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!zm_trial::function_b47f6aba())
	{
		return;
	}
	zm_trial::register_challenge(#"hash_1d70527739c796e5", &function_d1de6a85, &function_9e7b3f4d);
}

/*
	Name: function_d1de6a85
	Namespace: namespace_309b53e1
	Checksum: 0x98BE9A42
	Offset: 0x280
	Size: 0xE0
	Parameters: 0
	Flags: Linked, Private
*/
function private function_d1de6a85()
{
	str_targetname = "trials_lighthouse_beam";
	level setup_lighthouse();
	callback::function_33f0ddd3(&function_33f0ddd3);
	level zm_trial::function_25ee130(1);
	foreach(player in getplayers())
	{
		player thread function_1e902f3b();
	}
}

/*
	Name: function_9e7b3f4d
	Namespace: namespace_309b53e1
	Checksum: 0x2AC6BC5A
	Offset: 0x368
	Size: 0x12C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9e7b3f4d(round_reset)
{
	level notify(#"hash_2b53ed06a97eb26c");
	level.var_ab11c23d function_f223e16f(round_reset);
	callback::function_824d206(&function_33f0ddd3);
	level zm_trial::function_25ee130(0);
	foreach(player in getplayers())
	{
		player thread namespace_b22c99a5::function_dc0859e();
		player thread namespace_b22c99a5::function_73ff0096();
	}
	level.var_7f31a12d = undefined;
	level namespace_d09ff23c::function_d85bd834();
}

/*
	Name: setup_lighthouse
	Namespace: namespace_309b53e1
	Checksum: 0x68CA260F
	Offset: 0x4A0
	Size: 0x394
	Parameters: 0
	Flags: Linked, Private
*/
function private setup_lighthouse()
{
	level notify(#"hash_661044fd7c7faa55");
	if(level.var_7d8bf93f zm_pack_a_punch::is_on())
	{
		if(level.var_7d8bf93f flag::get("Pack_A_Punch_on"))
		{
			level.var_7d8bf93f flag::wait_till("pap_waiting_for_user");
		}
		var_611e46b7 = undefined;
		foreach(var_143bf55a in level.var_9f657597)
		{
			if(var_143bf55a.script_noteworthy == (level.var_7d8bf93f.script_noteworthy + "_debris"))
			{
				var_611e46b7 = var_143bf55a;
				break;
			}
		}
		level.var_7d8bf93f zm_pack_a_punch::function_bb629351(0, "initial");
		if(level.var_7d8bf93f == level.var_9d121dce)
		{
			exploder::exploder_stop("fxexp_pap_light_icefloe");
		}
		if(isdefined(var_611e46b7))
		{
			while(var_611e46b7 scene::is_playing("melt"))
			{
				wait(0.25);
			}
			var_611e46b7 thread namespace_44916ada::function_69a4b74b(1);
			if(isdefined(var_611e46b7.target))
			{
				clip_brush = getent(var_611e46b7.target, "targetname");
				clip_brush thread namespace_44916ada::function_4d7320f5(1);
			}
		}
	}
	if(level.var_ab11c23d.var_58df9892 == 3 || level.var_ab11c23d.var_58df9892 == 8)
	{
		level.var_ab11c23d notify(#"hash_1aa56851d9d4ec0d");
		if(isdefined(level.var_ab11c23d.vh_target))
		{
			level.var_ab11c23d.vh_target.b_moving = 0;
			level.var_ab11c23d.vh_target clientfield::set("" + #"hash_19bce46b8ab82440", 0);
			waitframe(1);
			level.var_ab11c23d.vh_target delete();
		}
		if(isdefined(level.var_ab11c23d.var_9bda8088))
		{
			level.var_ab11c23d.var_9bda8088 notify(#"trap_done");
			waitframe(1);
			level.var_ab11c23d.var_9bda8088 delete();
		}
	}
	level thread namespace_d09ff23c::function_ad646ef8(0);
	level.var_ab11c23d thread function_dbad2f5a();
}

/*
	Name: function_dbad2f5a
	Namespace: namespace_309b53e1
	Checksum: 0x59D30458
	Offset: 0x840
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function function_dbad2f5a()
{
	self endon(#"death", #"hash_2b53ed06a97eb26c");
	level.var_ab11c23d notify(#"hash_78fc5bbd712046b0");
	vh_target = spawner::simple_spawn_single(getent("virgil", "targetname"));
	while(!isdefined(vh_target))
	{
		waitframe(1);
		vh_target = spawner::simple_spawn_single(getent("virgil", "targetname"));
	}
	self.var_da138ae4 = getvehiclenode("trials_lighthouse_start", "targetname");
	vh_target.origin = self.var_da138ae4.origin;
	vh_target.b_moving = 0;
	vh_target val::set(#"hash_69024cc79ba5b8d3", "takedamage", 0);
	self.vh_target = vh_target;
	self namespace_d09ff23c::function_1b488412(vh_target.origin, 1);
	self.vh_target.e_spotlight = util::spawn_model("tag_origin", self.vh_target.origin);
	self.vh_target.e_spotlight enablelinkto();
	self.vh_target.e_spotlight linkto(self.vh_target, "tag_origin", vectorscale((0, 0, 1), 390), vectorscale((1, 0, 0), 90));
	self waittill(#"rotatedone");
	level.var_ab11c23d clientfield::set("lighthouse_on", 3);
	self.vh_target.e_spotlight clientfield::set("" + #"trials_lighthouse_beam", 2);
	self.vh_target thread namespace_d09ff23c::function_18f63949();
	self namespace_d09ff23c::function_2b2f2a7f();
	wait(1);
	self.vh_target thread function_b502c51(self.var_da138ae4);
}

/*
	Name: function_b502c51
	Namespace: namespace_309b53e1
	Checksum: 0x4808DB5C
	Offset: 0xB28
	Size: 0x96
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b502c51(nd_start)
{
	self endon(#"death", #"hash_2b53ed06a97eb26c");
	while(true)
	{
		self thread vehicle::get_on_and_go_path(nd_start);
		self setspeed(4);
		self.b_moving = 1;
		self waittill(#"reached_end_node");
	}
}

/*
	Name: function_f223e16f
	Namespace: namespace_309b53e1
	Checksum: 0x2E265467
	Offset: 0xBC8
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function function_f223e16f(round_reset)
{
	self endon(#"death");
	self.vh_target.b_moving = 0;
	wait(2);
	self.vh_target clientfield::set("" + #"hash_19bce46b8ab82440", 0);
	self.vh_target.e_spotlight delete();
	self.vh_target delete();
	if(round_reset !== 1)
	{
		level thread namespace_d09ff23c::function_ad646ef8(1);
		switch(level.var_98138d6b)
		{
			case 2:
			{
				level thread namespace_44916ada::function_56db9cdc();
				break;
			}
			case 3:
			{
				level thread namespace_44916ada::function_56db9cdc();
				break;
			}
		}
	}
}

/*
	Name: function_1e902f3b
	Namespace: namespace_309b53e1
	Checksum: 0xF302A899
	Offset: 0xD10
	Size: 0x10E
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1e902f3b()
{
	self endon(#"disconnect");
	level endon(#"hash_7646638df88a3656");
	var_407eb07 = 0;
	while(true)
	{
		var_f2b6fe6e = 0;
		n_distance = distancesquared(level.var_ab11c23d.vh_target.origin, self.origin);
		if(n_distance < 30000)
		{
			var_f2b6fe6e = 1;
		}
		if(var_f2b6fe6e && var_407eb07)
		{
			self namespace_b22c99a5::function_dc0859e();
			var_407eb07 = 0;
		}
		else if(!var_f2b6fe6e && !var_407eb07)
		{
			self namespace_b22c99a5::function_bf710271();
			var_407eb07 = 1;
		}
		waitframe(1);
	}
}

/*
	Name: function_91f0d131
	Namespace: namespace_309b53e1
	Checksum: 0x85955ADE
	Offset: 0xE28
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function function_91f0d131()
{
	n_distance = distancesquared(level.var_ab11c23d.vh_target.origin, self.origin);
	if(n_distance < 30000)
	{
		return true;
	}
	return false;
}

/*
	Name: function_33f0ddd3
	Namespace: namespace_309b53e1
	Checksum: 0x3CC6DF86
	Offset: 0xE88
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_33f0ddd3(s_event)
{
	if(s_event.event === "give_weapon")
	{
		var_f2b6fe6e = 0;
		if(self.b_in_water === 1)
		{
			var_f2b6fe6e = 1;
		}
		else if(!var_f2b6fe6e && !zm_loadout::function_2ff6913(s_event.weapon))
		{
			self function_28602a03(s_event.weapon, 1, 1);
		}
	}
}

