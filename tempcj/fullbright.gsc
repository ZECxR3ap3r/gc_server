#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level thread onPlayerConnect();
}

onPlayerConnect() 
{
    for(;;) 
	{
        level waittill("connected", player);

		player notifyOnPlayerCommand("FpsFix_action", "vote no"); // notify for fps / zfar
		player notifyOnPlayerCommand("Fullbright_action", "vote yes"); // notify for fullbright
		player notifyOnPlayerCommand("killme", "+actionslot 6"); // notify for suicide

		player thread doFps(); // logic for switching the fps / zfar
		player thread doFullbright(); // logic for switching fullbright
		player thread endmysuffering(); // suicide button
		player thread thankyou();
		player thread FpsDisplay(); // sets up the hud at the top of screen to show which button to press for what
	}
}

thankyou()
{
	self endon("disconnect");

	self.creditors = newClientHudElem( self );
    self.creditors.x = 10;
    self.creditors.y = 10;
    self.creditors.alignx = "left";
	self.creditors.aligny = "top";
	self.creditors.color = (1,1,1);
	self.creditors.alpha = 1;
	self.creditors.archived = false;
	self.creditors.sort = 80;
    self.creditors.foreground = true;
    self.creditors.fontscale = 0.8;
    self.creditors.font = "objective";
	self.creditors.horzalign = "fullscreen";
	self.creditors.vertalign = "fullscreen";
	self.creditors settext("^8Made By Clipzor With Help From ZECxR3ap3r");
	self.creditors.hidewheninmenu = true;
}

FpsDisplay() {
	self endon("disconnect");
	self.ButtonStuff = newClientHudElem( self );
    self.ButtonStuff.x = 10;
    self.ButtonStuff.y = 20;
    self.ButtonStuff.alignx = "left";
	self.ButtonStuff.aligny = "top";
	self.ButtonStuff.color = (1,1,1);
	self.ButtonStuff.alpha = 1;
	self.ButtonStuff.archived = false;
	self.ButtonStuff.sort = 80;
    self.ButtonStuff.foreground = true;
    self.ButtonStuff.fontscale = 0.8;
    self.ButtonStuff.font = "objective";
	self.ButtonStuff.horzalign = "fullscreen";
	self.ButtonStuff.vertalign = "fullscreen";
	self.ButtonStuff settext("^8[{vote yes}] ^5Fullbright\n^8[{vote no}] ^5High FPS\n^8[{+actionslot 4}]   ^5RPG\n^8[{+actionslot 6}]   ^5Suicide");
	self.ButtonStuff.hidewheninmenu = true;
}

endmysuffering()
{
	self endon("disconnect");
    level endon("game_ended");
    while(true)
    {
        self waittill("killme"); // waits for button

		self suicide();
	}
}

doFps()
{
	self endon("disconnect");
    level endon("game_ended");
    self.Fps = 0;
    while(true)
    {
        self waittill("FpsFix_action"); // waits for button

			if (self.Fps == 0) // first press sets zfar to 3000 etc, rest is just going lower
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
        self waittill("Fullbright_action"); // waits for button
			if (self.Fullbright == 0) // first press turn fx off and fox
			{
				self SetClientDvars( "fx_enable", "0", "r_fog", "0");
				self.Fullbright = 1;
				self iprintln("^8Fx^5/^8Fog");
			}
			else if (self.Fullbright == 1) // second press turn fullbright on
			{
				self SetClientDvar("r_lightmap", "2" );
				self.Fullbright = 2;
				self iprintln("^8Fx^5/^8Fog^5/^8Fullbright");
			}
			else if (self.Fullbright == 2) // last press reset back to normal
			{
				self SetClientDvars( "fx_enable", "1", "r_fog", "1", "r_lightmap", "1" );
				self.Fullbright = 0;
				self iprintln("^1Disabled");
			}
	}
}






