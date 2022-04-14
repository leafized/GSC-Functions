//Created by _createcam.gsc, if you need help talk to MikeD
main()
{
     // intro
     maps\_camsys::create_cam_node( "intro", (-1066.91, -12227.8, -85), (8, 12, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-1015.41, -12408.1, -85), (8, 29, 0), 4000, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-638.9, -12687.8, -85), (8, 60, 0), 7000, 0, 0 );
     maps\_camsys::create_cam_node( "intro", (-248, -13195, -85), (8, 315, 0), 5000, 0, 0 );

     // mid
     maps\_camsys::create_cam_node( "mid", (2258, -520, 230), (0, 65, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "mid", (2354, -558, 230), (0, 80, 0), 2350, 0, 0 );
     maps\_camsys::create_cam_node( "mid", (2470, -560, 230), (0, 90, 0), 2650, 0, 0 );

     // end
     maps\_camsys::create_cam_node( "end", (1443, 7754, 648), (0, 275, 0), 0, 0, 0 );
     maps\_camsys::create_cam_node( "end", (2091, 7862, 648), (0, 270, 0), 2550, 0, 0 );
     maps\_camsys::create_cam_node( "end", (2732, 7806, 648), (0, 260, 0), 3350, 0, 0 );


}
