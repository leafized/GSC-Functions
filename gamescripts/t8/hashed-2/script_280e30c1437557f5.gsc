// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_8abfb58852911dd;
#using scripts\core_common\struct.gsc;
#using scripts\core_common\system_shared.gsc;

#namespace namespace_d0937679;

/*
	Name: function_89f2df9
	Namespace: namespace_d0937679
	Checksum: 0xDDD7F5DF
	Offset: 0xC8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_1f56d362760c2c6b", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d0937679
	Checksum: 0x2668BA7B
	Offset: 0x110
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_fdbdcdfd = (isdefined(getgametypesetting(#"hash_6fbf57e2af153e5f")) ? getgametypesetting(#"hash_6fbf57e2af153e5f") : 0);
	level thread function_61a426a5();
}

/*
	Name: function_61a426a5
	Namespace: namespace_d0937679
	Checksum: 0x4E322F47
	Offset: 0x190
	Size: 0x202
	Parameters: 0
	Flags: Linked
*/
function function_61a426a5()
{
	var_37f8a843 = getdvarint(#"hash_79ed3a19e0cdd3c5", -1);
	if(var_37f8a843 < 0)
	{
		var_37f8a843 = undefined;
	}
	zombie_apoc_homunculus = getdynent("zombie_apoc_homunculus");
	if(!isdefined(zombie_apoc_homunculus) && (!(isdefined(level.var_fdbdcdfd) && level.var_fdbdcdfd)))
	{
		return;
	}
	item_world::function_4de3ca98();
	if(isdefined(zombie_apoc_homunculus))
	{
		points = struct::get_array("zombie_apoc_homunculus_point", "targetname");
		if(isdefined(points))
		{
			for(index = 0; index < points.size; index++)
			{
				randindex = function_d59c2d03(points.size);
				var_521b73a = points[index];
				points[index] = points[randindex];
				points[randindex] = var_521b73a;
			}
			randindex = function_d59c2d03(points.size);
			if(isdefined(var_37f8a843))
			{
				zombie_apoc_homunculus.origin = points[var_37f8a843].origin;
				zombie_apoc_homunculus.angles = points[var_37f8a843].angles;
			}
			else
			{
				zombie_apoc_homunculus.origin = points[randindex].origin;
				zombie_apoc_homunculus.angles = points[randindex].angles;
			}
		}
	}
}

