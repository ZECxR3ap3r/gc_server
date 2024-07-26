#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
//Coded by Slxxpy and Clippy

init(){

    level thread onConnect();

}

onConnect()
{
  for (;;)
  {
    level waittill("connected", player);
    player thread Velocity();
    player thread healthPlayer();
  }
}

Velocity()
{
		self endon("disconnect");
		level endon("game_ended");

        self.velmeter = self createFontString( "default", 1.5 );
        self.velmeter setPoint( "BOTTOM", "BOTTOM", 0, -26  );
        self.velmeter.label = &"^7";
        self.velmeter.HideWhenInMenu = true;

        self.velhigh = 0.0;

        self.velhighmeter = self createFontString( "default", 1.5 );
        self.velhighmeter setPoint( "BOTTOM", "BOTTOM", 0, -41  );
        self.velhighmeter.label = &"^3(&&1)";
        self.velhighmeter setvalue(floor(self.velhigh));
        self.velhighmeter.HideWhenInMenu = true;

		while(true)
		{
		self.newvel = self getvelocity();
		self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1]));
		self.vel = self.newvel;
		self.velmeter setvalue(floor(self.vel));

    if(self.vel > self.velhigh)
    {
      self.velhigh = self.vel;
      self.velhighmeter setvalue(floor(self.velhigh));
    }

		wait 0.05;

		}
}

healthPlayer()
{
    self endon("disconnect");
    self.healthText = createFontString( "default", 1.4 );
    self.healthText setPoint( "BOTTOM", "BOTTOM", 0, -8  );
    self.healthText.label = &"Health: ";
    self.healthText.glowalpha = 1; 
    self.healthText.glowcolor = (0.0, 1.0, 0.0); 
    self.healthText.HideWhenInMenu = true;
   
       for(;;)
        {
          self.healthText setvalue(self.health);
          self.healthText.glowcolor = (1.0 - self.health / 100, self.health / 100, 0.0);
          wait 0.5;
        }
}
