// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 

	//* Fog section * 

	//setdvar("scr_fog_exp_halfplane", "4353");
	//setdvar("scr_fog_exp_halfheight", "5000");
	//setdvar("scr_fog_nearplane", "1024");
	//setdvar("scr_fog_red", "0.53125");
	//setdvar("scr_fog_green", "0.507813");
	//setdvar("scr_fog_blue", "0.5");
	//setdvar("scr_fog_baseheight", "0");

	setdvar("scr_fog_exp_halfplane", "1763.99");
	setdvar("scr_fog_exp_halfheight", "541.494");
	setdvar("scr_fog_nearplane", "814.911");
	setdvar("scr_fog_red", "0..49");
	setdvar("scr_fog_green", "0.60");
	setdvar("scr_fog_blue", "0.73");
	setdvar("scr_fog_baseheight", "-451.652");

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "10");
	setdvar("visionstore_glowTweakRadius1", "10");
	setdvar("visionstore_glowTweakBloomCutoff", "0.25");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.65");
	setdvar("visionstore_glowTweakBloomIntensity1", "0.65");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.29");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0.29");
	setdvar("visionstore_glowRayExpansion", "1.5");
	setdvar("visionstore_glowRayIntensity", "0.75");
	setdvar("visionstore_filmEnable", "1");
	setdvar("visionstore_filmContrast", "1.15");
	setdvar("visionstore_filmBrightness", "0.07");
	setdvar("visionstore_filmDesaturation", "0.05");

	setdvar("visionstore_filmInvert", "0");
	setdvar("visionstore_filmLightTint", "1.2 1.18 0.95");
	setdvar("visionstore_filmDarkTint", "0.97 1 1");
	
	setVolFog(814.911, 1763.99, 541.494, -451.652, 0.506273, 0.613708, 0.657198, 0);

	//setVolFog(1024, 3353, 5000, 0, 0.5, 0.507813, 0.5, 0);
	VisionSetNaked( "mp_beachhead", 0 );

}

