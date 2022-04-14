// Ambients Level File

#include maps\_utility;
#include maps\_ambientpackage;

main()
{
	

	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************
	
	 
	
	 
	
	//***************
	//rhi3_Base
	//***************   
	
	            declareAmbientPackage( "rhi3_base_pkg" );            
	
	                        addAmbientElement( "rhi3_base_pkg", "amb_dog_bark", 30, 60, 300, 2000 );
	                        addAmbientElement( "rhi3_base_pkg", "amb_waterbirds", 30, 60, 1000, 4000 );
	                        addAmbientElement( "rhi3_base_pkg", "amb_raven", 30, 60, 1000, 4000 );
	                        
	//***************
	//rhi3_indoor
	//***************   
	 
	            declareAmbientPackage( "rhi3_indoor_pkg" );         
	
	
	            
			
	
	           
	//************************************************************************************************
	//                                              ROOMS
	//************************************************************************************************
	
	 
	//***************
	//rhi3_Base
	//***************
	
	            declareAmbientRoom( "rhi3_base_room" );
	
	                        setAmbientRoomTone( "rhi3_base_room", "outdoor_room" );
	
	//***************
	//rhi3_indoor
	//***************
	 
	            declareAmbientRoom( "rhi3_indoor_room" );
	 
	                        setAmbientRoomTone( "rhi3_indoor_room", "indoor_room" );
	                  
	            declareAmbientRoom( "rhi3_hangar_room" );
	 
	                        setAmbientRoomTone( "rhi3_hangar_room", "hangar_room" );
	
	
	
	
	//************************************************************************************************
	
	//                                              ACTIVATE DEFAULT AMBIENT SETTINGS
	
	//************************************************************************************************
	
	            activateAmbientPackage( "rhi3_base_pkg", 0 );
	
		    activateAmbientRoom( "rhi3_base_room", 0 );
	 
	
	 
	
	//*************************************************************************************************
	
	//                                              START SCRIPTS
	
	//*************************************************************************************************
	
	

	
	

}
