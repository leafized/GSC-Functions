/*
    This weapon scripts list will work for most, but not all games. Games that may require additional attention are
    T7, T8, S2.
    Repository Managed By: Leafized
    Created 4/14/2022
*/

c_GiveWeapon(weapon)
{
    if(!isDefined(weapon))
        return;
    else 
    {
        self TakeWeapon(self getCurrentWeapon());
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self iPrintLn(weapon + " ^2given!")
    }
}
/*
    Function Name: c_GiveWeapon
    Function Parameters: weapon (string, "raygun_zm")
    Function Description: gives weapon to caller
 */

 c_freezePlayer(player)
 {
     player.frozeinplace = player.frozeinplace ? false : true;
     player FreezeControls( player.frozeinplace );
 }
 /*
    Function Name: c_freezePlayer(player)
    Function Parameters: player (player, g_entity)
    Function Description: freezes player.
 */