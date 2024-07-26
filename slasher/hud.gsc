#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
 	 level thread onConnect();
}

onConnect() {
  	for (;;) {
    	level waittill("connected", player);
    	
    	player notifyOnPlayerCommand("FpsFix_action", "vote no");
		player notifyOnPlayerCommand("Fullbright_action", "vote yes");
    	
    	player thread mainHudSystem();
    	player thread doFps();
		player thread doFullbright();
		player thread FpsDisplay();
    	player thread onSpawned();
  	}
}

onSpawned() {
  	self endon("disconnect");
  	
  	self.initial_spawn = 0;
  	
  	for(;;) {
    	self waittill("spawned_player");
    	if(self.team == "axis" && IsAlive(self))
    		self thread monitorStuck();
    	
    	if(self.initial_spawn == 0) {
    		self.initial_spawn = 1;
    		self thread scripts\slasher\main::ReaperHud();
    	}
  	}
}

mainHudSystem() {
    self endon("disconnect");
    level endon("game_ended");	
   	
   	self.SplashBrand = newClientHudElem( self );
    self.SplashBrand.x = 595;
    self.SplashBrand.y = 7;
    self.SplashBrand.alignx = "right";
    self.SplashBrand.aligny = "middle";
    self.SplashBrand.horzalign = "fullscreen";
    self.SplashBrand.vertalign = "fullscreen";
    self.SplashBrand.alpha = 0.3;
    self.SplashBrand.fontscale = 1;
    self.SplashBrand.archived = true;
    self.SplashBrand.hidewheninmenu = true;
    self.SplashBrand setText("^7v1.3 | Mod By: Wiizard, Clippy & ZECxR3ap3r | Discord: GilletteClan.com |"); 
   	
   	self thread onMapEnd();
}

onMapEnd() {
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

doFps() {
	self endon("disconnect");
    level endon("game_ended");
    self.Fps = 0;

    while(true) {
        self waittill("FpsFix_action");
		if (self.Fps == 0) {
			self setClientDvar ( "r_zfar", "3000" );
			self.Fps = 1;
			self iprintln("^13000");
		}
		else if (self.Fps == 1) {
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 2;
			self iprintln("^12000");
		}
		else if (self.Fps == 2) {
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 3;
			self iprintln("^11500");
		}
		else if (self.Fps == 3) {
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 4;
			self iprintln("^11000");
		}
		else if (self.Fps == 4) {
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 5;
			self iprintln("^1500");
		}
		else if (self.Fps == 5) {
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 0;
			self iprintln("^1Disabled");
		}
	}
}

doFullbright() {
	self endon("disconnect");
    level endon("game_ended");
    self.Fullbright = 0;

    while(true) {
    	self waittill("Fullbright_action");
		if (self.Fullbright == 0) {
			self SetClientDvars("r_fog", "0");
			self.Fullbright = 1;
			self iprintln("^3Fog");
		}
		else if (self.Fullbright == 1) {
			self SetClientDvars( "fx_enable", "0");
			self.Fullbright = 2;
			self iprintln("^3Fx");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvars( "fx_enable", "1", "r_fog", "1", "r_lightmap", "1" );
			self.Fullbright = 0;
			self iprintln("^1Disabled");
		}
	}
}

FpsDisplay() {
	self endon("disconnect");
  
    self.someText = self createFontString( "default", 1.1);
	self.someText setPoint( "TOP", "TOP", 30, 4 );
	self.someText.color = level.ui_better_red;
    self.someText setText("^7[{vote no}] ^1High Fps");
	self.someText.HideWhenInMenu = true;
    self.someText.archived = false;
    self.someText thread scripts\slasher\main::SetAlphaLow();

    self.someText2 = self createFontString( "default", 1.1);
    self.someText2 setPoint( "TOP", "TOP", -30, 4 );
    self.someText2.color = level.ui_better_red;
    self.someText2 setText("^7[{vote yes}] ^1No Fog/FX");
	self.someText2.HideWhenInMenu = true;
    self.someText2.archived = false;
    self.someText2 thread scripts\slasher\main::SetAlphaLow();
}

/*  Stuck monitoring sys for The Slasher - by Wiizard :)  */
monitorStuck() {
    self endon("end_stuck_monitoring");
    self.stuckText = self createFontString( "default", 1.1);
    self.stuckText.color = level.ui_better_red;
    self.stuckText setPoint( "TOP", "TOP", 0, 20 );
    self.stuckText setText("[{+actionslot 6}] ^1TP to Spawn");
    self.stuckText.HideWhenInMenu = true;
    self.stuckText.archived = false;
    self.stuckText thread scripts\slasher\main::SetAlphaLow();

    self notifyonplayercommand("stuck", "+actionslot 6");
    
	while(true) {
		self waittill("stuck");
        if(self.team == "axis" && self.team != "spectator") {
           	ori = self.origin;
           	i=5;
           	while(Distance(ori, self.origin) < 50) {
             	if(i == 0) {
               		origin = level.spawnpoints[randomint(level.spawnpoints.size)];
               		self setOrigin(origin.origin);
               		self setplayerangles(origin.angles);
               		self monitorStuckCooldown();
               		self.stuckText setText("[{+actionslot 6}] ^1TP to Spawn");
               		break;
            	}
             	self iprintln("Dont Move For ^1" + i + " ^7Seconds");
             	i--;
             	wait 1;
         	}
      	}
      	else
       		self iPrintln("Cannot TP until round is in-progress!");
	}
}

monitorStuckCooldown() {
	self endon("end_stuck_monitoring");
  	time = 60;
  	while(time > 0) {
		if(level.finalPlayer || level.escapeInit) {
      		if(isdefined(self.stuckText)) 
      			self.stuckText destroy();
      		
      		self notify("end_stuck_monitoring");
    	}
   		self.stuckText setText("^3[{+actionslot 6}] ^1TP to Spawn (Cooldown - ^3"+time+"^1s)");
    	time--;
    	wait 1;
  	}
}


















