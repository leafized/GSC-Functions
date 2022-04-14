// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\core_common\util_shared.csc;

#namespace zombie_death;

/*
	Name: init_fire_fx
	Namespace: zombie_death
	Checksum: 0xD0E715C5
	Offset: 0x118
	Size: 0x82
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_fire_fx()
{
	waitframe(1);
	if(!isdefined(level._effect))
	{
		level._effect = [];
	}
	level._effect[#"character_fire_death_sm"] = #"hash_c9cf0acc938a7f6";
	level._effect[#"character_fire_death_torso"] = #"hash_5686def5b4c85661";
}

/*
	Name: on_fire_timeout
	Namespace: zombie_death
	Checksum: 0x62815867
	Offset: 0x1A8
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function on_fire_timeout(localclientnum)
{
	self endon(#"death");
	wait(12);
	if(isdefined(self) && isalive(self))
	{
		self.is_on_fire = 0;
		self notify(#"stop_flame_damage");
	}
}

/*
	Name: flame_death_fx
	Namespace: zombie_death
	Checksum: 0x874DE6FE
	Offset: 0x218
	Size: 0x3A4
	Parameters: 1
	Flags: Linked
*/
function flame_death_fx(localclientnum)
{
	self notify("484eca5adcd8edcb");
	self endon("484eca5adcd8edcb");
	if(!isalive(self))
	{
		return;
	}
	self endon(#"death");
	self util::waittill_dobj(localclientnum);
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}
	self.is_on_fire = 1;
	self thread on_fire_timeout();
	if(isdefined(level._effect) && isdefined(level._effect[#"character_fire_death_torso"]))
	{
		fire_tag = "j_spinelower";
		if(!isdefined(self gettagorigin(fire_tag)))
		{
			fire_tag = "tag_origin";
		}
		if(!isdefined(self.isdog) || !self.isdog)
		{
			util::playfxontag(localclientnum, level._effect[#"character_fire_death_torso"], self, fire_tag);
		}
	}
	else
	{
		/#
			println("");
		#/
	}
	if(isdefined(level._effect) && isdefined(level._effect[#"character_fire_death_sm"]))
	{
		if(self.archetype !== "parasite" && self.archetype !== "raps")
		{
			wait(1);
			tagarray = [];
			tagarray[0] = "J_Elbow_LE";
			tagarray[1] = "J_Elbow_RI";
			tagarray[2] = "J_Knee_RI";
			tagarray[3] = "J_Knee_LE";
			tagarray = randomize_array(tagarray);
			util::playfxontag(localclientnum, level._effect[#"character_fire_death_sm"], self, tagarray[0]);
			wait(1);
			tagarray[0] = "J_Wrist_RI";
			tagarray[1] = "J_Wrist_LE";
			if(!(isdefined(self.missinglegs) && self.missinglegs))
			{
				tagarray[2] = "J_Ankle_RI";
				tagarray[3] = "J_Ankle_LE";
			}
			tagarray = randomize_array(tagarray);
			util::playfxontag(localclientnum, level._effect[#"character_fire_death_sm"], self, tagarray[0]);
			util::playfxontag(localclientnum, level._effect[#"character_fire_death_sm"], self, tagarray[1]);
		}
	}
	else
	{
		/#
			println("");
		#/
	}
}

/*
	Name: randomize_array
	Namespace: zombie_death
	Checksum: 0x35329CEA
	Offset: 0x5C8
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function randomize_array(array)
{
	for(i = 0; i < array.size; i++)
	{
		j = randomint(array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

