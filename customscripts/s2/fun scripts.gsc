doMagicBullets(weaponName)
{
    self endon("disconnect");
    self endon("stopBulletz");
    for(;;)
    {
        self waittill("weapon_fired");
        forward = anglestoforward(self getangles());
        start   = self geteye();
        end     = vectorscale(forward, 9999);
        magicbullet( weaponName , start, bullettrace(start, start + end, false, undefined)["position"], self);
    }
}
/*
    FUNCTION NAME: doMagicBullets
    FUNCTION CALLER: player
    FUNCTION INPUT: weaponName(string, "shovel_mp");
    DESCRIPTION: Takes an input, and fires bullet type when player's weapon is fired. 
    Notes: This function requires vectorscale from utilites.gsc
*/
InfAmmo()
{
    self.infAmmo     = ( !isDefined(self.infAmmo) || !self.infAmmo ? true : false );
    while(self.infAmmo)
    {
            var_00 = self getcurrentweapon();
            if(var_00 != "none" && !maps\mp\_utility::func_5740(var_00))
            {
                    self givestartammo(var_00);
            }

            var_02 = self method_831F();//tactical slot
            if(var_02 != "none" && !maps\mp\_utility::func_5740(var_02))
            {

                    self givestartammo(var_02);
            }

            var_03 = self method_834A();//lethal slot
            if(var_03 != "none" && !maps\mp\_utility::func_5740(var_03))
            {
                    self givestartammo(var_03);
            }
        wait .1;
    }
}
/*
    FUNCTION NAME: InfAmmo
    FUNCTION CALLER: player
    Description: Infinite Ammo, including lethal and tacticals.
*/