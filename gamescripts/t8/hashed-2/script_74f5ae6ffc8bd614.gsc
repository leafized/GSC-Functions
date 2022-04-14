// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\clientfield_shared.csc;
#using scripts\core_common\system_shared.csc;

#namespace namespace_8f39dfb1;

/*
	Name: init
	Namespace: namespace_8f39dfb1
	Checksum: 0xD2BF4060
	Offset: 0xA0
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "medallion_fx", 1, 1, "int", &function_6624b679, 0, 0);
	level._effect[#"hash_2c71b21e072366c2"] = #"hash_4960d9278d639297";
}

/*
	Name: function_6624b679
	Namespace: namespace_8f39dfb1
	Checksum: 0xFB225B19
	Offset: 0x128
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function function_6624b679(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		up = anglestoup(self.angles + (0, -90, -90));
		forward = anglestoforward(self.angles + (0, -90, -90));
		playfx(localclientnum, level._effect[#"hash_2c71b21e072366c2"], self.origin, forward, up);
		playsound(localclientnum, #"hash_23ed06ab941bc579", self.origin);
	}
}

