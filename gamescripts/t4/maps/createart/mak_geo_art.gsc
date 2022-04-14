//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2312.57");
	setdvar("scr_fog_nearplane", "2753.72");
	setdvar("scr_fog_red", "0.427334");
	setdvar("scr_fog_green", "0.419713");
	setdvar("scr_fog_blue", "0.55171");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "7.71515e-005");
	setdvar("visionstore_glowTweakBloomIntensity0", "1.79437");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.35743");
	setdvar("visionstore_filmTweakBrightness", "0.149483");
	setdvar("visionstore_filmTweakDesaturation", "0.325251");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.1 1.05 0.85");
	setdvar("visionstore_filmTweakDarkTint", "0.7 0.85 1");

	//

	setExpFog(2753.72, 2312.57, 0.427334, 0.419713, 0.55171, 0);
	VisionSetNaked( "mak_geo", 0 );

}
