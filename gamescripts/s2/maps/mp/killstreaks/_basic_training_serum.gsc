/*******************************************************************
 * Decompiled By: AgreedBog381
 * Decompiled File: _basic_training_serum.gsc
 * Game: Call of Duty: WWII
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 311 ms
 * Timestamp: 8/24/2021 10:24:41 PM
*******************************************************************/

//Function Id: 0x00D5
//Function Number: 1
func_00D5()
{
	level thread scorestreakdvarhostmigration();
	level.var_5A61["basic_training_serum"] = ::tryusebasictrainingserum;
	level.var_5A7D["basic_training_serum"] = "basic_training_serum";
	level.basictrainingserumperks = ["specialty_rof","specialty_bulletaccuracy","specialty_fastreload","specialty_quickdraw_new","specialty_quickswap"];
	level.serumbasictrainingcooldowninterval = 30000;
	level.serumbasictrainingactiveduration = 8;
}

//Function Id: 0x0000
//Function Number: 2
scorestreakdvarhostmigration()
{
	level endon("game_ended");
	setdvar("scorestreak_enabled_basic_training_serum",1);
	for(;;)
	{
		level waittill("host_migration_begin");
		setdvar("scorestreak_enabled_basic_training_serum",1);
		maps\mp\gametypes\_hostmigration::func_A782();
	}
}

//Function Id: 0x0000
//Function Number: 3
tryusebasictrainingserum(param_00)
{
	var_01 = tryusebasictrainingseruminternal();
	return var_01;
}

//Function Id: 0x0000
//Function Number: 4
tryusebasictrainingseruminternal()
{
	if(maps\mp\_utility::func_57A0(self))
	{
		if(!isdefined(self.raidserumactive) || !self.raidserumactive)
		{
			maps\mp\_matchdata::func_5E9A("basic_training_serum",self.var_0116);
			self.var_012C["basicTrainingSerumsUsed"]++;
			self.var_012C["basicTrainingSerumEarnTimeRemaining"] = level.serumbasictrainingcooldowninterval;
			self.var_012C["basicTrainingSerumEarnProgress"] = 0;
			thread startcombatbuff();
			lib_0378::func_8D74("aud_serum_syringe_foley");
			lib_0378::func_8D74("aud_serum_buff_start");
			return 1;
		}

		self iclientprintlnbold(&"KILLSTREAKS_DLC4_ONE_SERUM_AT_A_TIME");
		return 0;
	}

	return 0;
}

//Function Id: 0x0000
//Function Number: 5
startcombatbuff()
{
	thread combatbuffdeathlistener();
	self.raidpreserumperkslist = self.var_6F65;
	self.raidbasictrainingbuff = 1;
	self.raidserumactive = 1;
	self.basictrainingserumactive = 1;
	maps\mp\gametypes\_weapons::func_A13B();
	foreach(var_01 in level.basictrainingserumperks)
	{
		if(!maps\mp\_utility::func_0649(var_01))
		{
			maps\mp\_utility::func_47A2(var_01);
		}
	}

	thread maps/mp/killstreaks/_raid_ss_serum_util::altered_state_apply(0,level.serumbasictrainingactiveduration,"orange",0.25,0.125,0.4);
	thread maps/mp/killstreaks/_raid_ss_serum_util::serumtimerupdate(level.serumbasictrainingactiveduration);
	self waittill("serum_finished");
	foreach(var_01 in level.basictrainingserumperks)
	{
		if(!maps/mp/killstreaks/_raid_ss_serum_util::serumhadperk(var_01))
		{
			maps\mp\_utility::func_0735(var_01);
		}
	}

	self.raidbasictrainingbuff = undefined;
	self.raidserumactive = undefined;
	self.basictrainingserumactive = undefined;
	maps\mp\gametypes\_weapons::func_A13B();
}

//Function Id: 0x0000
//Function Number: 6
combatbuffdeathlistener()
{
	self endon("disconnect");
	self endon("serum_finished");
	level endon("game_ended");
	self waittill("death");
	self.raidbasictrainingbuff = undefined;
	self.raidserumactive = undefined;
	self.basictrainingserumactive = undefined;
	maps\mp\gametypes\_weapons::func_A13B();
}