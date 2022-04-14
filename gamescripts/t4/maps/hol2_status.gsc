#include maps\_utility;


/////////////////////////////////////////////////////////////
//                                                         //
//    My Task List                                          //
//                                                         //
//                                                         // 
//                                                         //
/////////////////////////////////////////////////////////////

	/*  1) set up triggering spawners in event 3 when one group dies
			2) make skipto's work
			3) Do the multi-objectives for event 3

///////////////////////

*/

main()
{
/#
	event1();
	event2();
	event3();
	event4();
	event5();
#/
}

event1()
{
/#
		maps\_status::scripter_task( "Event 1 - Road Ambush", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", .5, 100 );
		maps\_status::scripter_subtask( "Gameplay", 2, 100);
		maps\_status::scripter_subtask( "IGC Camera", .5, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}

event2()
{
/#
		maps\_status::scripter_task( "Event 2 - Forest Trail", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 2, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100);
#/
}

event3()
{
/#
		maps\_status::scripter_task( "Event 3 - Camp Clear", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100);
#/
}

event4()
{
/#
		maps\_status::scripter_task( "Event 4 - Ambush Convey", 5, 10 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 90 );
		maps\_status::scripter_subtask( "Animation", 1, 75 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 80);
#/
}

event5()
{
/#
		maps\_status::scripter_task( "Event 5 - ", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 0);
#/
}