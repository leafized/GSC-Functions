// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_24c32478acf44108;
#using scripts\core_common\clientfield_shared.gsc;
#using scripts\core_common\math_shared.gsc;
#using scripts\core_common\system_shared.gsc;
#using scripts\zm_common\zm.gsc;
#using scripts\zm_common\zm_equipment.gsc;
#using scripts\zm_common\zm_utility.gsc;

#namespace namespace_e0f208bf;

/*
	Name: function_89f2df9
	Namespace: namespace_e0f208bf
	Checksum: 0xEE3B6DBB
	Offset: 0xB8
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_1729d37a410e5bd1", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e0f208bf
	Checksum: 0x54AB3515
	Offset: 0x108
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm::function_84d343d(#"hash_c78156ba6aeda14", &function_36a0ef3);
	zm::function_84d343d(#"hash_6cb687e3f8c569fd", &function_36a0ef3);
	zm::function_84d343d(#"hash_55a4aa4a1077e2cc", &function_2b4945e4);
	zm::function_84d343d(#"hash_5e1f4dd6a8a34700", &function_2b4945e4);
	zm::function_84d343d(#"hash_753ba1d1412a4962", &function_2b4945e4);
	zm::function_84d343d(#"hash_7d040bd867e93061", &function_2b4945e4);
	zm::function_84d343d(#"hash_5624a55eb03372d0", &function_2b4945e4);
	namespace_9ff9f642::function_9d45c058(#"hash_c78156ba6aeda14", 50, 5, "" + #"hash_682f9312e30af478", "" + #"hash_7fcff4f8340f11f7");
	clientfield::register("actor", "" + #"hash_682f9312e30af478", 1, 1, "int");
	clientfield::register("actor", "" + #"hash_7fcff4f8340f11f7", 1, 1, "int");
}

/*
	Name: __main__
	Namespace: namespace_e0f208bf
	Checksum: 0x21F3C7C4
	Offset: 0x340
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.var_c62ed297 = 1;
}

/*
	Name: function_36a0ef3
	Namespace: namespace_e0f208bf
	Checksum: 0x9A285A74
	Offset: 0x360
	Size: 0xD2
	Parameters: 12
	Flags: Linked
*/
function function_36a0ef3(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	var_b1c1c5cf = zm_equipment::function_7d948481(0.1, 0.25, 0.25, 1);
	var_bb6709b6 = zm_equipment::function_379f6b5d(damage, var_b1c1c5cf, 1, 4, 40);
	return var_bb6709b6;
}

/*
	Name: function_2b4945e4
	Namespace: namespace_e0f208bf
	Checksum: 0x65A2C71A
	Offset: 0x440
	Size: 0x11A
	Parameters: 12
	Flags: Linked
*/
function function_2b4945e4(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	self namespace_9ff9f642::burn(#"hash_c78156ba6aeda14", attacker, getweapon(#"hash_c78156ba6aeda14"), 50);
	var_b1c1c5cf = zm_equipment::function_7d948481(0.1, 0.25, 0.25, 1);
	n_damage = zm_equipment::function_379f6b5d(damage, var_b1c1c5cf, 1, 4, 40);
	return n_damage;
}

