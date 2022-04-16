/*
    FUNCTION NAME: setVision
    FUNCTION CALLER: player
    FUNCTION INPUT: setVision( "mpintro", 0.25 );
    DESCRIPTION: Sets a players vision
    NOTES: For BO1 Multiplayer it onlys works for host.
*/

setVision(vision, time)
{
    self visionSetNaked( vision, time );
}

/*
    FUNCTION NAME: isHost
    FUNCTION CALLER: player
    FUNCTION INPUT: isHost()
    DESCRIPTION: Grabs the hosts entity number
    NOTES: Mainly for games/modes that does not have a bulit in function for isHost(Ie BO1 Zombies, WAW Zombies)
*/

isHost()
{
    if(self == get_players()[0]) // get_players can also be changed to level.players
        return true;
    else 
        return false;
}