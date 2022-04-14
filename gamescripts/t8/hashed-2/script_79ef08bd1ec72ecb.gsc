// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\callbacks_shared.csc;
#using scripts\core_common\struct.csc;
#using scripts\core_common\system_shared.csc;
#using scripts\core_common\util_shared.csc;
#using scripts\zm_common\zm_weapons.csc;

#namespace namespace_2f354b06;

/*
	Name: function_89f2df9
	Namespace: namespace_2f354b06
	Checksum: 0x8E7403C7
	Offset: 0xA0
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_382e78e18269d3cd", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2f354b06
	Checksum: 0xBF452352
	Offset: 0xF0
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_2274350d = getweapon(#"tundragun");
	level.var_a3ee16a0 = getweapon(#"tundragun_upgraded");
}

/*
	Name: __main__
	Namespace: namespace_2f354b06
	Checksum: 0x230C890
	Offset: 0x150
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	callback::function_f77ced93(&function_f77ced93);
}

/*
	Name: function_f77ced93
	Namespace: namespace_2f354b06
	Checksum: 0x8EF745F0
	Offset: 0x180
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_f77ced93(s_params)
{
	w_new_weapon = s_params.weapon;
	w_old_weapon = s_params.last_weapon;
	if(w_new_weapon == level.var_2274350d || w_new_weapon == level.var_a3ee16a0)
	{
		/#
			iprintlnbold("");
		#/
	}
}

/*
	Name: function_4017174b
	Namespace: namespace_2f354b06
	Checksum: 0x6D9D7003
	Offset: 0x208
	Size: 0x160
	Parameters: 2
	Flags: None
*/
function function_4017174b(localclientnum, w_weapon)
{
	self endon(#"disconnect");
	self endon(#"weapon_change");
	self endon(#"death");
	n_old_ammo = -1;
	n_shader_val = 0;
	while(true)
	{
		wait(0.1);
		if(!isdefined(self))
		{
			return;
		}
		n_ammo = getweaponammoclip(localclientnum, w_weapon);
		if(n_old_ammo > 0 && n_old_ammo != n_ammo)
		{
			function_ac62a2fd(localclientnum);
		}
		n_old_ammo = n_ammo;
		if(n_ammo == 0)
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
		}
		else
		{
			n_shader_val = 4 - n_ammo;
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, n_shader_val, 0);
		}
	}
}

/*
	Name: function_ac62a2fd
	Namespace: namespace_2f354b06
	Checksum: 0xF7129A1D
	Offset: 0x370
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_ac62a2fd(localclientnum)
{
	playsound(localclientnum, #"wpn_thunder_breath", (0, 0, 0));
}

