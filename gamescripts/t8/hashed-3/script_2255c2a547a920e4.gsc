// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_35598499769dbb3d;
#using scripts\core_common\math_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\zm_common\zm.gsc;
#using scripts\zm_common\zm_bgb.gsc;
#using scripts\zm_common\zm_stats.gsc;

#namespace namespace_64cafbad;

/*
	Name: function_89f2df9
	Namespace: namespace_64cafbad
	Checksum: 0x84932618
	Offset: 0xA8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_7822c558a509de9", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_64cafbad
	Checksum: 0x88689E1D
	Offset: 0xF0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register(#"hash_7822c558a509de9", "time", 120, &enable, &disable, undefined, undefined);
	bgb::register_actor_damage_override(#"hash_7822c558a509de9", &function_ce76fa9f);
}

/*
	Name: enable
	Namespace: namespace_64cafbad
	Checksum: 0x80F724D1
	Offset: 0x1A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function enable()
{
}

/*
	Name: disable
	Namespace: namespace_64cafbad
	Checksum: 0x80F724D1
	Offset: 0x1B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: function_ce76fa9f
	Namespace: namespace_64cafbad
	Checksum: 0xE06E9DB0
	Offset: 0x1C0
	Size: 0x18E
	Parameters: 12
	Flags: Linked
*/
function function_ce76fa9f(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(!isdefined(self.var_6f84b820))
	{
		return damage;
	}
	switch(shitloc)
	{
		case "head":
		case "helmet":
		case "neck":
		{
			switch(self.var_6f84b820)
			{
				case "popcorn":
				case "basic":
				case "enhanced":
				{
					if(math::cointoss(11))
					{
						gibserverutils::gibhead(self);
						attacker zm_stats::increment_challenge_stat(#"hash_5d098efca02f7c99");
						return self.health;
					}
					break;
				}
			}
			break;
		}
		default:
		{
			return damage;
			break;
		}
	}
	return damage;
}

