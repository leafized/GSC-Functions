#include maps\_utility;
#include common_scripts\utility;

main()
{

	init_vision_triggers();
	
}

init_vision_triggers()
{

	trigs = getentarray("set_vision","targetname");
	array_thread(trigs,::trigger_vision);

}

trigger_vision()
{

	self waittill("trigger");
	iprintlnbold("Vision changed to: " + self.script_noteworthy );
	if(!isDefined(self.script_noteworthy))
	{
		assertmsg("Vision trigger doesn't have a script_noteworthy set");
	}

	//if(self.script_noteworthy == "Ber3B_2")
	{
		//iprintlnbold("sunlight tweaked");
		//setdvar("r_lighttweaksunlight", .8);
	}
	VisionSetNaked(self.script_noteworthy, 3);
}