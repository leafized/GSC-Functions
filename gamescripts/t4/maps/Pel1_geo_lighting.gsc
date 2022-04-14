#include maps\_utility;

main()
{

	//---------------------

	//setExpFog(50, 4000, 0.4, 0.46, 0.47, 0.0);
	//setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)
	setVolFog(30, 4500, 0, 0, 0.4, 0.425, 0.44, 0.0);
	

	//----------------------

	maps\_load::main();
	
	wait(10);

	
	
	VisionSetNaked("Pel1",0);



}
