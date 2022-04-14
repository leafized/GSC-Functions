//
// file: rhi2_amb.gsc
// description: level ambience script for rhineland2
// scripter: slayback
//

#include maps\_utility;
#include maps\_ambientpackage;

main()
{
	
	
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************
	
	 
	
	 
	
	//***************
	//rhi2_Base
	//***************   
	
	            declareAmbientPackage( "rhi2_base_pkg" );            
	
	                        addAmbientElement( "rhi2_base_pkg", "amb_dog_bark", 30, 60, 300, 2000 );
	                        addAmbientElement( "rhi2_base_pkg", "amb_birds", 30, 60, 1000, 4000 );
	                        addAmbientElement( "rhi2_base_pkg", "amb_raven", 30, 60, 1000, 4000 );
	                        
	 //***************
	 //rhi2_indoor
	 //***************   
	 
	             declareAmbientPackage( "rhi2_indoor_pkg" );         
	
	
	            
			
	
	           
	//************************************************************************************************
	//                                              ROOMS
	//************************************************************************************************
	
	 
	//***************
	//rhi2_Base
	//***************
	
	            declareAmbientRoom( "rhi2_base_room" );
	
	                        setAmbientRoomTone( "rhi2_base_room", "outdoor_room" );
	
	 //***************
	 //rhi2_indoor
	 //***************
	 
	             declareAmbientRoom( "rhi2_indoor_room" );
	 
	                         setAmbientRoomTone( "rhi2_indoor_room", "indoor_room" );
	
	
	
	
	//************************************************************************************************
	
	//                                              ACTIVATE DEFAULT AMBIENT SETTINGS
	
	//************************************************************************************************
	
	            activateAmbientPackage( "rhi2_base_pkg", 0 );
	
			activateAmbientRoom( "rhi2_base_room", 0 );
	 
	
	 
	
	//*************************************************************************************************
	
	//                                              START SCRIPTS
	
	//*************************************************************************************************
	
	

	
	

}
