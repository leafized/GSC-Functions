// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	codescripts\character::setModelFromArray(xmodelalias\char_jap_impinfwet_body4alias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\char_jap_impinf_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\char_jap_impinfwet_helm_oki_alias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\char_jap_impinfwet_gear4alias::main());
	self attach(self.gearModel, "", true);
	self.voice = "japanese";
	self.torsoDmg1 = "char_jap_impinfwet_body4_g_upclean";
	self.torsoDmg2 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_rarmoffalias::main());
	self.torsoDmg3 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_larmoffalias::main());
	self.torsoDmg4 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_torsoalias::main());
	self.torsoDmg5 = "char_jap_impinfwet_body4_g_behead";
	self.legDmg1 = "char_jap_impinfwet_body4_g_lowclean";
	self.legDmg2 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_rlegoffalias::main());
	self.legDmg3 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_llegoffalias::main());
	self.legDmg4 = codescripts\character::randomElement(xmodelalias\char_jap_infwet_body4_g_legsoffalias::main());
	self.gibSpawn1 = "char_jap_impinfwet_body4_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "char_jap_impinfwet_body4_g_larmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "char_jap_impinfwet_body4_g_rlegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "char_jap_impinfwet_body4_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\char_jap_impinfwet_body4alias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_impinf_headalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_impinfwet_helm_oki_alias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_impinfwet_gear4alias::main());
	precacheModel("char_jap_impinfwet_body4_g_upclean");
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_rarmoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_larmoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_torsoalias::main());
	precacheModel("char_jap_impinfwet_body4_g_behead");
	precacheModel("char_jap_impinfwet_body4_g_lowclean");
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_rlegoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_llegoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_legsoffalias::main());
	precacheModel("char_jap_impinfwet_body4_g_rarmspawn");
	precacheModel("char_jap_impinfwet_body4_g_larmspawn");
	precacheModel("char_jap_impinfwet_body4_g_rlegspawn");
	precacheModel("char_jap_impinfwet_body4_g_llegspawn");
	precacheModel("char_jap_impinfwet_body4_g_upclean");
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_rarmoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_larmoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_torsoalias::main());
	precacheModel("char_jap_impinfwet_body4_g_behead");
	precacheModel("char_jap_impinfwet_body4_g_lowclean");
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_rlegoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_llegoffalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_jap_infwet_body4_g_legsoffalias::main());
	precacheModel("char_jap_impinfwet_body4_g_rarmspawn");
	precacheModel("char_jap_impinfwet_body4_g_larmspawn");
	precacheModel("char_jap_impinfwet_body4_g_rlegspawn");
	precacheModel("char_jap_impinfwet_body4_g_llegspawn");
}