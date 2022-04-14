/*-----------------------------------------------------
Ambient stuff
-----------------------------------------------------*/
#include maps\_utility;
#include maps\_ambientpackage;

main()
{
	
	
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************
	
	 
	
	 
	
	//***************
	//rhi1_Base
	//***************   
	
	            declareAmbientPackage( "rhi1_base_pkg" );            
	
	                        addAmbientElement( "rhi1_base_pkg", "amb_dog_bark", 30, 60, 300, 2000 );
	                        addAmbientElement( "rhi1_base_pkg", "amb_waterbirds", 30, 60, 1000, 4000 );
	                        addAmbientElement( "rhi1_base_pkg", "amb_raven", 30, 60, 1000, 4000 );
	                        
	 //***************
	 //rhi1_indoor
	 //***************   
	 
	             declareAmbientPackage( "rhi1_indoor_pkg" );         
	
	
	            
			
	
	           
	//************************************************************************************************
	//                                              ROOMS
	//************************************************************************************************
	
	 
	//***************
	//rhi1_Base
	//***************
	
	            declareAmbientRoom( "rhi1_base_room" );
	
	                        setAmbientRoomTone( "rhi1_base_room", "outdoor_room" );
	
	 //***************
	 //rhi1_indoor
	 //***************
	 
	             declareAmbientRoom( "rhi1_indoor_room" );
	 
	                         setAmbientRoomTone( "rhi1_indoor_room", "indoor_room" );
	
	
	
	
	//************************************************************************************************
	
	//                                              ACTIVATE DEFAULT AMBIENT SETTINGS
	
	//************************************************************************************************
	
	            activateAmbientPackage( "rhi1_base_pkg", 0 );
	
			activateAmbientRoom( "rhi1_base_room", 0 );
	 
	
	 
	
	//*************************************************************************************************
	
	//                                              START SCRIPTS
	
	//*************************************************************************************************
	
	

	
	

}

