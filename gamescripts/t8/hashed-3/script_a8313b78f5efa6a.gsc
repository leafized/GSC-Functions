// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\clientfield_shared.csc;
#using scripts\core_common\system_shared.csc;
#using scripts\zm_common\zm_perks.csc;

#namespace namespace_10df686;

/*
	Name: function_89f2df9
	Namespace: namespace_10df686
	Checksum: 0x24CBF04A
	Offset: 0x90
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_89f2df9()
{
	system::register(#"hash_3e54b9da1b1e7a51", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_10df686
	Checksum: 0x9E79AF00
	Offset: 0xD8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	function_27473e44();
}

/*
	Name: function_27473e44
	Namespace: namespace_10df686
	Checksum: 0xF4B90430
	Offset: 0xF8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_27473e44()
{
	zm_perks::register_perk_clientfields(#"specialty_mod_extraammo", &function_12161a30, &function_b10a7225);
	zm_perks::register_perk_effects(#"specialty_mod_extraammo", "sleight_light");
	zm_perks::register_perk_init_thread(#"specialty_mod_extraammo", &init_perk);
}

/*
	Name: init_perk
	Namespace: namespace_10df686
	Checksum: 0x1D4428C2
	Offset: 0x1A0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_perk()
{
}

/*
	Name: function_12161a30
	Namespace: namespace_10df686
	Checksum: 0x80F724D1
	Offset: 0x1D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_12161a30()
{
}

/*
	Name: function_b10a7225
	Namespace: namespace_10df686
	Checksum: 0x80F724D1
	Offset: 0x1E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_b10a7225()
{
}

