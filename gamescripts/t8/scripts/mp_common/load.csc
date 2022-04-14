// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using script_3f6516099f1d5ff1;
#using script_45e0fb7326469ccf;
#using scripts\core_common\clientfield_shared.csc;
#using scripts\core_common\flagsys_shared.csc;
#using scripts\core_common\system_shared.csc;
#using scripts\core_common\util_shared.csc;
#using scripts\mp_common\callbacks.csc;
#using scripts\mp_common\gametypes\gametype.csc;

#namespace load;

/*
	Name: levelnotifyhandler
	Namespace: load
	Checksum: 0xE656F82
	Offset: 0xF8
	Size: 0x4E
	Parameters: 3
	Flags: Linked
*/
function levelnotifyhandler(clientnum, state, oldstate)
{
	if(state != "")
	{
		level notify(state, {#localclientnum:clientnum});
	}
}

/*
	Name: main
	Namespace: load
	Checksum: 0xF9811A36
	Offset: 0x150
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		assert(isdefined(level.first_frame), "");
	#/
	level thread util::init_utility();
	util::registersystem("levelNotify", &levelnotifyhandler);
	register_clientfields();
	level.createfx_disable_fx = getdvarint(#"disable_fx", 0) == 1;
	map::init();
	gametype::init();
	system::wait_till("all");
	level flagsys::set(#"load_main_complete");
}

/*
	Name: register_clientfields
	Namespace: load
	Checksum: 0xD65A5492
	Offset: 0x260
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("missile", "cf_m_proximity", 1, 1, "int", &callback::callback_proximity, 0, 0);
	clientfield::register("missile", "cf_m_emp", 1, 1, "int", &callback::callback_emp, 0, 0);
	clientfield::register("missile", "cf_m_stun", 1, 1, "int", &callback::callback_stunned, 0, 0);
}

