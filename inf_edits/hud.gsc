#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread onConnect();
    level thread PlayerSpawnedConnected();
    //level.HeathAbility = "iw5_cardicon_medkit";
    //level.SpeedAbility = "iw5_cardicon_capsule";
    //level.BarLine = "line_horizontal_scorebar";
    //level.Normal = "white";
   
    //precacheshader(level.HeathAbility);
    //precacheshader(level.SpeedAbility);
    //precacheshader(level.BarLine);
    //precacheshader(level.Normal);

}

onConnect()
{
  for (;;)
  {
    level waittill("connected", player);
    player thread mainHudSystem();

    player notifyOnPlayerCommand("FpsFix_action", "vote no");
		player notifyOnPlayerCommand("Fullbright_action", "vote yes");

		player thread setVision();
    player thread doFps();
		player thread doFullbright();
		player thread FpsDisplay();

  }
}

PlayerSpawnedConnected()
{
  self endon("disconnect");
  for(;;)
  {
    self waittill("spawned_player");
  }
}

mainHudSystem()
{
    self endon("disconnect");
    level endon("game_ended");	

    //self.BarLineBackground = self createIcon( level.BarLine, 600,6);
    //self.BarLineBackground setPoint( "center","center", -550,-90 );
    //self.BarLineBackground.color = (0.9, 0.9, 0.9);

    /*
    self.SquareHudBackground1 = self createIcon( level.Normal, 30,30);
    self.SquareHudBackground1 setPoint( "center","center", 390,35 );
    self.SquareHudBackground1.color = (0.0, 0.0, 0.0);
    self.SquareHudBackground1.alpha = 0.5;

    self.SquareHudBackground2 = self createIcon( level.Normal, 30,30);
    self.SquareHudBackground2 setPoint( "center","center", 390,75 );
    self.SquareHudBackground2.color = (0.0, 0.0, 0.0);
    self.SquareHudBackground2.alpha = 0.5;

    self.HeatlthAbility = self createIcon( level.HeathAbility , 20, 20 );
    self.HeatlthAbility setPoint( "center", "center", 390, 35 );
    self.HeatlthAbility.foreground = true;

    self.SpeedAbility = self createIcon( level.SpeedAbility , 25, 25 );
    self.SpeedAbility setPoint( "center", "center", 390, 75 );
    self.SpeedAbility.foreground = true;

    self.SpeedAbilityCounter = self createFontString( "objective", 1.2 );
    self.SpeedAbilityCounter setPoint( "center", "center", 404, 88 );
    self.SpeedAbilityCounter setText("0");  
    
    self.HeatlthAbilityCounter = self createFontString( "objective", 1.2 );
    self.HeatlthAbilityCounter setPoint( "center", "center", 404, 48 );
    self.HeatlthAbilityCounter setText("0"); 

    self.SoonText = self createFontString( "objective", 1.0 );
    self.SoonText setPoint( "center", "center", 390, 10 );
    self.SoonText setText("Soon!"); 
    self.SoonText.alpha = 1.0;
    self.SoonText.glowalpha = 1; 
    self.SoonText.glowcolor = (0.5, 0.5, 0.5);
    */

    //self.AbilityPoints = self createFontString( "objective", 1.0 );
    //self.AbilityPoints setPoint( "TOP", "TOP", -343, 127 );
    //self.AbilityPoints setText("Ability points to spend: 0"); 
    //self.AbilityPoints.alpha = 1.0;
    //self.AbilityPoints.glowalpha = 1; 
    //self.AbilityPoints.glowcolor = (0.5, 0.5, 0.5); 

    self.RotaionGunText = self createFontString( "objective", 1.3 );
    //self.RotaionGunText setPoint( "TOP", "TOP", -263, 90 );
    self.RotaionGunText setPoint( "TOP", "TOP", -376, 110 );
    self.RotaionGunText setText("");  

   self.SplashBrand = self createFontString( "default", 1.0 );
   self.SplashBrand setPoint( "CENTER", "CENTER", 315, -233 );
   self.SplashBrand setText("Discord: GilletteClan.com |"); 
   self.SplashBrand.alpha = 0.3;

  // self.SplashBrand.glowalpha = 1; 
   //self.SplashBrand.glowcolor = (0.5, 0.5, 0.5); 
   self thread onMapEnd();
}

onMapEnd()
{
	self endon( "disconnect" );
	level waittill("game_ended");
	
	if (isDefined(self.RotaionGunText))
		self.RotaionGunText destroy();
  if (isDefined(self.SplashBrand))
    self.SplashBrand destroy();
  if (isDefined(self.someText))
    self.someText destroy();
  if (isDefined(self.someText2))
    self.someText2 destroy();
  if (isDefined(self.someText3))
    self.someText3 destroy();
}

doFps()
{
	  self endon("disconnect");
    level endon("game_ended");
    self.Fps = 0;

    while(true)
    {
        self waittill("FpsFix_action");

			if (self.Fps == 0)
			{
				self setClientDvar ( "r_zfar", "3000" );
				self.Fps = 1;
				self iprintln("^53000");
			}
			else if (self.Fps == 1)
			{
				self setClientDvar ( "r_zfar", "2000" );
				self.Fps = 2;
				self iprintln("^52000");
			}
			else if (self.Fps == 2)
			{
				self setClientDvar ( "r_zfar", "1000" );
				self.Fps = 3;
				self iprintln("^51000");
			}
			else if (self.Fps == 3)
			{
				self setClientDvar ( "r_zfar", "500" );
				self.Fps = 4;
				self iprintln("^5500");
			}
			else if (self.Fps == 4)
			{
				self setClientDvar ( "r_zfar", "0" );
				self.Fps = 0;
				self iprintln("^1Disabled");
			}
	}
}

doFullbright()
{
	  self endon("disconnect");
    level endon("game_ended");
    self.Fullbright = 0;

    while(true)
    {
        self waittill("Fullbright_action");
			if (self.Fullbright == 0)
			{
				self SetClientDvars( "fx_enable", "0", "r_fog", "0");
				self.Fullbright = 1;
				self iprintln("^3Fx^5/^3Fog");
			}
			else if (self.Fullbright == 1)
			{
				self SetClientDvar("r_lightmap", "2" );
				self.Fullbright = 2;
				self iprintln("^3Fx^5/^3Fog^5/^3Fullbright");
			}
			else if (self.Fullbright == 2)
			{
				self SetClientDvars( "fx_enable", "1", "r_fog", "1", "r_lightmap", "1" );
				self.Fullbright = 0;
				self iprintln("^1Disabled");
			}
	}
}

FpsDisplay()
{
	self endon("disconnect");
  
    self.someText = self createFontString( "default", 1.1);
	  self.someText setPoint( "TOP", "TOP", 29, 00 );
    self.someText setText("^3[{vote no}] ^5High Fps");
	  self.someText.HideWhenInMenu = true;

    self.someText2 = self createFontString( "default", 1.1);
    self.someText2 setPoint( "TOP", "TOP", -29, 0 );
    self.someText2 setText("^3[{vote yes}] ^5Fullbright");
	  self.someText2.HideWhenInMenu = true;

    self.someText3 = self createFontString( "default", 1.1);
    self.someText3 setPoint( "TOP", "TOP", 0, 14 );
    self.someText3 setText("^3[{+actionslot 6}] ^5Suicide");
	  self.someText3.HideWhenInMenu = true;
}

setVision() 
{
	self waittill("spawned_player");
	self VisionSetNakedForPlayer( getdvar("mapname"), 0 );
}