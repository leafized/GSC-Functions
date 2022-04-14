// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\struct.gsc;
#using scripts\core_common\system_shared.gsc;

#namespace namespace_720bad73;

/*
	Name: function_89f2df9
	Namespace: namespace_720bad73
	Checksum: 0x88DBED92
	Offset: 0xC0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_333ef86886930605", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: namespace_720bad73
	Checksum: 0xCF44DFF5
	Offset: 0x108
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("zbarrier", "" + #"hash_7e15d8abc4d6c79a", 24000, 1, "int");
	level thread function_ffef72a();
}

/*
	Name: function_ffef72a
	Namespace: namespace_720bad73
	Checksum: 0x2E2FBAB1
	Offset: 0x170
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_ffef72a()
{
	var_98415589 = getentarray("zombie_debris", "targetname");
	foreach(trigger in var_98415589)
	{
		trigger thread function_31a1d10f();
	}
}

/*
	Name: function_31a1d10f
	Namespace: namespace_720bad73
	Checksum: 0xC4456010
	Offset: 0x218
	Size: 0x298
	Parameters: 0
	Flags: Linked
*/
function function_31a1d10f()
{
	self endon(#"death");
	var_6a20a57a = struct::get_array(self.target + "_struct", "targetname");
	if(isdefined(var_6a20a57a[0]))
	{
		if(!isdefined(self.var_9aa0f846))
		{
			self.var_9aa0f846 = [];
		}
		else if(!isarray(self.var_9aa0f846))
		{
			self.var_9aa0f846 = array(self.var_9aa0f846);
		}
		var_1151d2f8 = getentarray(var_6a20a57a[0].target, "targetname");
		foreach(e_debris in var_1151d2f8)
		{
			if(e_debris iszbarrier())
			{
				if(!isdefined(self.var_9aa0f846))
				{
					self.var_9aa0f846 = [];
				}
				else if(!isarray(self.var_9aa0f846))
				{
					self.var_9aa0f846 = array(self.var_9aa0f846);
				}
				self.var_9aa0f846[self.var_9aa0f846.size] = e_debris;
			}
		}
		self waittill(#"kill_debris_prompt_thread");
		foreach(var_532cdfcf in self.var_9aa0f846)
		{
			var_532cdfcf playsound(#"hash_717ab767ebc92682");
			var_532cdfcf clientfield::set("" + #"hash_7e15d8abc4d6c79a", 1);
		}
	}
}

