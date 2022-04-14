#include maps\_utility;
main()
{	
	
	wait 5;
	intro_credits();
}

intro_credits()
{
	// loads up all the names into a name array
	name_loader();
	
	// fade time
	level.fade_time = 2;
	
	// length for text to be seen, not including fade time
	level.name_view_time = 3;
	
	// time between each name set
	level.in_between_time = 2;
	
	// x values for each quad
	level.quadrants = [];
	level.quadrants[0]["x"] = 100;
	level.quadrants[1]["x"] = 100;
	level.quadrants[2]["x"] = 500;
	level.quadrants[3]["x"] = 500;
	
	// y values for each quad
	level.quadrants[0]["y"] = 100;
	level.quadrants[1]["y"] = 300;
	level.quadrants[2]["y"] = 100;
	level.quadrants[3]["y"] = 300;
	
	// textsize & offsets
	textsize = 1.25;
	y_offset = 22;
	
	// the name containers
	level.hud_elems = [];
	level.hud_elems[0] = NewClientHudElem(get_players()[0]);
	level.hud_elems[0].alpha = 0;
	level.hud_elems[0].alignX = "center";
	level.hud_elems[0].alignY = "middle";
	level.hud_elems[0].fontScale = textsize;
	level.hud_elems[0].font = "objective";
	
	level.hud_elems[1] = NewClientHudElem(get_players()[0]);
	level.hud_elems[1].alpha = 0;
	level.hud_elems[1].alignX = "center";
	level.hud_elems[1].alignY = "middle";
	level.hud_elems[1].fontScale = textsize;
	level.hud_elems[1].font = "objective";
	
	level.hud_elems[2] = NewClientHudElem(get_players()[0]);
	level.hud_elems[2].alpha = 0;
	level.hud_elems[2].alignX = "center";
	level.hud_elems[2].alignY = "middle";
	level.hud_elems[2].fontScale = textsize;
	level.hud_elems[2].font = "objective";
	
	level.hud_elems[3] = NewClientHudElem(get_players()[0]);
	level.hud_elems[3].alpha = 0;
	level.hud_elems[3].alignX = "center";
	level.hud_elems[3].alignY = "middle";
	level.hud_elems[3].fontScale = textsize;
	level.hud_elems[3].font = "objective";
	
	level.hud_elems[4] = NewClientHudElem(get_players()[0]);
	level.hud_elems[4].alpha = 0;
	level.hud_elems[4].alignX = "center";
	level.hud_elems[4].alignY = "middle";
	level.hud_elems[4].fontScale = textsize;
	level.hud_elems[4].font = "objective";
						
	// seeds the previous quad, the last quad sucks ass now anyway	
	previous_quad = 3;
	name_array_index = 0;
			
	while (name_array_index < level.name_array.size)
	{
		quad = randomint (4);					// get a 0-3
		if (quad == previous_quad)		// if we're in the same quad as before, find a new one
		{
			continue;
		} 	
		previous_quad = quad;					// update previous quad
		
		// set the text on each hudelem
		for (i = 0; i < level.hud_elems.size; i++)
		{
			if (isdefined(level.name_array[name_array_index]))
			{
				level.hud_elems[i].text = level.name_array[name_array_index];
				level.hud_elems[i].x = level.quadrants[quad]["x"] - 10 + randomint(20);
				level.hud_elems[i].y = level.quadrants[quad]["y"] + (y_offset * i);
				level.hud_elems[i] settext( level.hud_elems[i].text );
				
				if (i % 2 == 0)
				{
					direction =  "left";
				}
				else
				{
					direction = "right";
				}
				
				level.hud_elems[i] thread move_and_fade_name(direction);
								
				name_array_index++;
			}
			else
			{
				level.hud_elems[i].text = "";
			}
		}
		
		// wait time between each set of names
		wait ((level.fade_time * 2)+ level.name_view_time + level.in_between_time);		
	}
	
}

move_and_fade_name(direction)
{	
	total_time = (level.fade_time * 2)+ level.name_view_time;	
	
	if (direction == "left")
	{
		movement = -100 + randomint(50);
	}
	else
	{
		movement = 50 + randomint(50);
	}
	
	// fade in
	self fadeovertime(level.fade_time);
	self.alpha = 1;
	
	self moveovertime(total_time);
	self.x = self.x + movement;
	
	// stay on-screen, non faded for this long
	wait (level.fade_time + level.name_view_time);
	
	// fade out
	self fadeovertime(level.fade_time);
	self.alpha = 0;
}

name_loader()
{
	level.name_array = [];
	
	level.name_array[level.name_array.size] = &"MAK_CREDITS_YANBING_CHEN";     
	level.name_array[level.name_array.size] = &"MAK_CREDITS_WILSON_IP";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_TREVOR_WALKER";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_STEVEN_RIVERA";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_STEV_KALINOWSKI";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_STEPHEN_MCCAUL";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_SHANE_SASAKI";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_SEAN_SLAYBACK";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_RICHARD_MITTON";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_RICHARD_FARRELLY";        
	level.name_array[level.name_array.size] = &"MAK_CREDITS_QUINN_NGUYEN";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PHILLIP_LOZANO";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PETER_LAM";               
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PENNY_CHOCK";             
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PAUL_SANDLER";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PAT_GRIFFITH";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_PAT_DWYER";               
	level.name_array[level.name_array.size] = &"MAK_CREDITS_OMAR_GONZALEZ";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MY_WU";                   
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MURAD_AINUDDIN";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MIKE_UHLIK";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MIKE_DENNY";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MIKE_CURRAN";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MELISSA_BUFFALOE";      
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MAX_PORTER";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MATT_KIMBERLING";       
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MASAAKI_KAWAKUBO";      
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MARWAN_ABDERRAZZAQ";    
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MARVIN_ROJAS";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MARTIN_DONLON";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MARK_MURAKAMI";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_MARIA_BAROT";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_LUCAS_SEIBERT";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_LOUDVIK_AKOPYAN";       
	level.name_array[level.name_array.size] = &"MAK_CREDITS_LEI_HU";                
	level.name_array[level.name_array.size] = &"MAK_CREDITS_KEVIN_SHERWOOD";        
	level.name_array[level.name_array.size] = &"MAK_CREDITS_KENT_DRAEGER";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_KAORI_KATO";            
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JON_STOLL";             
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JOHN_SHUBERT";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JOHN_MCGINLEY";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JOEY_TERREBONNE";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JIMMY_ZIELINSKI";         
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JESSE_SNYDER";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JEFF_ZARING";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JED_ADAMS";             
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JASON_SCHOONOVER";      
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JASON_MCCORD";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JASON_GUYAN";           
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JARED_DICKINSON";       
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JAMES_SNIDER";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_JAMES_MCCAWLEY";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_IGOR_KRINISKIY";        
	level.name_array[level.name_array.size] = &"MAK_CREDITS_IAN_KOWALSKI";          
	level.name_array[level.name_array.size] = &"MAK_CREDITS_GIL_DORON";             
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_GAVIN_LOCKE";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_GAVIN_JAMES";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_GARY_SPINRAD";          
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_GARRETT_NGUYEN";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ERIK_DRAGESET";         
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ERIC_SMITH";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DOUGLAS_GUANLAO";       
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DOMINICK_GUZZO";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DOM_DROZDZ";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DIMITER_STANEV";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAVE_KING";             
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAVE_ANTHONY";          
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAN_LAUFER";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAN_BUNTING";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAN_BICKELL";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DAMOUN_SHABESTARI";     
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_DALE_MULCHAY";          
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_CRAIG_SCHILLER";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_CRAIG_HOUSTON";         
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_COLIN_WHITNEY";         
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_COLIN_AYERS";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_CHRIS_PIERRO";          
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_CHRIS_DIONNE";          
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_CAMERON_PETTY";         
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRIAN_TUEY";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRIAN_JOYAL";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRYAN_BLUMENKOPF";      
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRIAN_ANDERSON";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRENT_TODA";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRANDON_SOUDERS";       
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BRAD_GRACE";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_BARRY_WHITNEY";         
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ANTHONY_FLAMER";        
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ANTHONY_DOE";           
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ANH_NGUYEN";            
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ALEX_LIU";              
 	level.name_array[level.name_array.size] = &"MAK_CREDITS_ALEXANDER_CONSERVA";        
} 

precache_names()
{
	precachestring( &"MAK_CREDITS_YANBING_CHEN");    																								     
	precachestring( &"MAK_CREDITS_WILSON_IP");       																								     
	precachestring( &"MAK_CREDITS_TREVOR_WALKER");   																								     
	precachestring( &"MAK_CREDITS_STEVEN_RIVERA");   																								     
	precachestring( &"MAK_CREDITS_STEV_KALINOWSKI"); 																								     
	precachestring( &"MAK_CREDITS_STEPHEN_MCCAUL");  																								     
	precachestring( &"MAK_CREDITS_SHANE_SASAKI");    																								     
	precachestring( &"MAK_CREDITS_SEAN_SLAYBACK");   																								     
	precachestring( &"MAK_CREDITS_RICHARD_MITTON");  																								     
	precachestring( &"MAK_CREDITS_RICHARD_FARRELLY");																								     
	precachestring( &"MAK_CREDITS_QUINN_NGUYEN");    																								     
	precachestring( &"MAK_CREDITS_PHILLIP_LOZANO");  																								     
	precachestring( &"MAK_CREDITS_PETER_LAM");       																								     
	precachestring( &"MAK_CREDITS_PENNY_CHOCK");     																								     
	precachestring( &"MAK_CREDITS_PAUL_SANDLER");    																								     
	precachestring( &"MAK_CREDITS_PAT_GRIFFITH");    																								     
	precachestring( &"MAK_CREDITS_PAT_DWYER");       																								     
	precachestring( &"MAK_CREDITS_OMAR_GONZALEZ");   																								     
	precachestring( &"MAK_CREDITS_MY_WU");           																								     
	precachestring( &"MAK_CREDITS_MURAD_AINUDDIN");  																								     
	precachestring( &"MAK_CREDITS_MIKE_UHLIK");      																								     
	precachestring( &"MAK_CREDITS_MIKE_DENNY");      																								     
	precachestring( &"MAK_CREDITS_MIKE_CURRAN");     																								     
	precachestring( &"MAK_CREDITS_MELISSA_BUFFALOE");																								     
	precachestring( &"MAK_CREDITS_MAX_PORTER");      																								     
	precachestring( &"MAK_CREDITS_MATT_KIMBERLING"); 																								     
	precachestring( &"MAK_CREDITS_MASAAKI_KAWAKUBO");																								     
	precachestring( &"MAK_CREDITS_MARWAN_ABDERRAZZAQ"																								);   
	precachestring( &"MAK_CREDITS_MARVIN_ROJAS");    																								     
	precachestring( &"MAK_CREDITS_MARTIN_DONLON");   																								     
	precachestring( &"MAK_CREDITS_MARK_MURAKAMI");   																								     
	precachestring( &"MAK_CREDITS_MARIA_BAROT");     																								     
	precachestring( &"MAK_CREDITS_LUCAS_SEIBERT");   																								     
	precachestring( &"MAK_CREDITS_LOUDVIK_AKOPYAN"); 																								     
	precachestring( &"MAK_CREDITS_LEI_HU");          																								     
	precachestring( &"MAK_CREDITS_KEVIN_SHERWOOD");  																								     
	precachestring( &"MAK_CREDITS_KENT_DRAEGER");    																								     
	precachestring( &"MAK_CREDITS_KAORI_KATO");      																								     
	precachestring( &"MAK_CREDITS_JON_STOLL");       																								     
	precachestring( &"MAK_CREDITS_JOHN_SHUBERT");    																								     
	precachestring( &"MAK_CREDITS_JOHN_MCGINLEY");   																								     
	precachestring( &"MAK_CREDITS_JOEY_TERREBONNE");   																								     
	precachestring( &"MAK_CREDITS_JIMMY_ZIELINSKI");   																								     
	precachestring( &"MAK_CREDITS_JESSE_SNYDER");    																								     
	precachestring( &"MAK_CREDITS_JEFF_ZARING");     																								     
	precachestring( &"MAK_CREDITS_JED_ADAMS");       																								     
	precachestring( &"MAK_CREDITS_JASON_SCHOONOVER");																								     
	precachestring( &"MAK_CREDITS_JASON_MCCORD");    																								     
	precachestring( &"MAK_CREDITS_JASON_GUYAN");     																								     
	precachestring( &"MAK_CREDITS_JARED_DICKINSON"); 																								     
	precachestring( &"MAK_CREDITS_JAMES_SNIDER");    																								     
	precachestring( &"MAK_CREDITS_JAMES_MCCAWLEY");  																								     
	precachestring( &"MAK_CREDITS_IGOR_KRINISKIY");  																								     
	precachestring( &"MAK_CREDITS_IAN_KOWALSKI");    																								     
	precachestring( &"MAK_CREDITS_GIL_DORON");       																								     
	precachestring( &"MAK_CREDITS_GAVIN_LOCKE");     																								     
	precachestring( &"MAK_CREDITS_GAVIN_JAMES");     																								     
	precachestring( &"MAK_CREDITS_GARY_SPINRAD");    																								     
	precachestring( &"MAK_CREDITS_GARRETT_NGUYEN");  																								     
	precachestring( &"MAK_CREDITS_ERIK_DRAGESET");   																								     
	precachestring( &"MAK_CREDITS_ERIC_SMITH");      																								     
	precachestring( &"MAK_CREDITS_DOUGLAS_GUANLAO"); 																								     
	precachestring( &"MAK_CREDITS_DOMINICK_GUZZO");  																								     
	precachestring( &"MAK_CREDITS_DOM_DROZDZ");      																								     
	precachestring( &"MAK_CREDITS_DIMITER_STANEV");  																								     
	precachestring( &"MAK_CREDITS_DAVE_KING");       																								     
	precachestring( &"MAK_CREDITS_DAVE_ANTHONY");    																								     
	precachestring( &"MAK_CREDITS_DAN_LAUFER");      																								     
	precachestring( &"MAK_CREDITS_DAN_BUNTING");     																								     
	precachestring( &"MAK_CREDITS_DAN_BICKELL");     																								     
	precachestring( &"MAK_CREDITS_DAMOUN_SHABESTARI")																								;    
	precachestring( &"MAK_CREDITS_DALE_MULCHAY");    																								     
	precachestring( &"MAK_CREDITS_CRAIG_SCHILLER");  																								     
	precachestring( &"MAK_CREDITS_CRAIG_HOUSTON");   																								     
	precachestring( &"MAK_CREDITS_COLIN_WHITNEY");   																								     
	precachestring( &"MAK_CREDITS_COLIN_AYERS");     																								     
	precachestring( &"MAK_CREDITS_CHRIS_PIERRO");    																								     
	precachestring( &"MAK_CREDITS_CHRIS_DIONNE");    																								     
	precachestring( &"MAK_CREDITS_CAMERON_PETTY");   																								     
	precachestring( &"MAK_CREDITS_BRIAN_TUEY");      																								     
	precachestring( &"MAK_CREDITS_BRIAN_JOYAL");     																								     
	precachestring( &"MAK_CREDITS_BRYAN_BLUMENKOPF");																								     
	precachestring( &"MAK_CREDITS_BRIAN_ANDERSON");  																								     
	precachestring( &"MAK_CREDITS_BRENT_TODA");      																								     
	precachestring( &"MAK_CREDITS_BRANDON_SOUDERS"); 																								     
	precachestring( &"MAK_CREDITS_BRAD_GRACE");      																								     
	precachestring( &"MAK_CREDITS_BARRY_WHITNEY");   																								     
	precachestring( &"MAK_CREDITS_ANTHONY_FLAMER");  																								     
	precachestring( &"MAK_CREDITS_ANTHONY_DOE");     																								     
	precachestring( &"MAK_CREDITS_ANH_NGUYEN");      																								     
	precachestring( &"MAK_CREDITS_ALEX_LIU");        																								     
	precachestring( &"MAK_CREDITS_ALEX_CONSERVA");   																								     

}