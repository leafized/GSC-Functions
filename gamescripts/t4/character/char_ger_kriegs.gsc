// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	codescripts\character::setModelFromArray(xmodelalias\char_ger_waffen_bodyalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\char_ger_waffen_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\char_ger_waffen_helmalias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\char_ger_waffen_gearalias::main());
	self attach(self.gearModel, "", true);
	self.voice = "german";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\char_ger_waffen_bodyalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_waffen_headalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_waffen_helmalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_waffen_gearalias::main());
}