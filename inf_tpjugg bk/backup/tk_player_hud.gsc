#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// coonouk shame on you

init() {
	hostnameHud = createServerFontString("objective", 1.2f);
	hostnameHud SetPoint("CENTER", "TOP", 0, 10);
	hostnameHud.label = &"^7INF ^5TP Jugg";
	hostnameHud.hidewheninmenu = 1;
	hostnameHud.alpha = 1;
	hostnameHud.foreground = 1;
	
	level thread on_connect();
}

destroy_on_notify(notifyname) {
	level waittill(notifyname);
	
	if(isdefined(self))
		self destroy();
}

on_connect() {
	self endon ("disconnect");
  	for (;;) {
		level waittill("connected", player);
		
		player.hadgunsrotated = 0;
		
		if(!isdefined(player.ui_elements))
			player.ui_elements = [];
		
		player SetClientDvar("cg_objectiveText", "^5Gillette^7Clan.com\n^7Join us on Discord ^5discord.gg/GilletteClan");
		
		player thread ui_create();
		player thread on_spawned();
  	}
}

on_spawned() {
    level endon("game_ended");
    self endon("disconnect");

	self.initial_spawn = 0;

    for(;;) {
        self waittill("spawned_player");
		
        self SetClientDvar("cg_objectiveText", "^5Gillette^7Clan.com\n^7Join us on Discord ^5discord.gg/GilletteClan");
        
        if(self.initial_spawn == 0) {
        	self.initial_spawn = 1;
        	
			self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 1");
				
			self thread doFps();
			self thread doFullbright();
			self thread suicidePlayer();
			self thread var_resetter();
        }
    }
}

var_resetter() {
	self endon("disconnect");
	
	while(1) {
		self waittill("death");
		
		if(isdefined(self.linkedto))
			self.linkedto = undefined;
	}
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
			self iprintln("^53000");
		}
		else if (self.Fps == 1) {
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 2;
			self iprintln("^52000");
		}
		else if (self.Fps == 2) {
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 3;
			self iprintln("^51500");
		}
		else if (self.Fps == 3) {
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 4;
			self iprintln("^51000");
		}
		else if (self.Fps == 4) {
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 5;
			self iprintln("^5500");
		}
		else if (self.Fps == 5) {
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 0;
			self iprintln("^5Default");
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
			self SetClientDvars("r_fog", "0", "fx_drawclouds", "0");
			self.Fullbright = 1;
			self iprintln("^5Fog");
		}
		else if (self.Fullbright == 1) {
			self SetClientDvar("r_lightmap", "3");
			self.Fullbright = 2;
			self iprintln("^5Fullbright Grey");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvar("r_lightmap", "2" );
			self.Fullbright = 3;
			self iprintln("^5Fullbright White");
		}
		else if (self.Fullbright == 3) {
			self SetClientDvars("r_fog", "1", "r_lightmap", "1" , "fx_drawclouds", "1");
			self.Fullbright = 0;
			self iprintln("^5Default");
		}
	}
}

suicidePlayer() {
	self endon("disconnect");
	level endon("game_ended");
	
	while(true) {
        self waittill("suicide_action");
        self suicide();
    }
}


ui_create() {
	self endon( "disconnect" );
	level endon("game_ended");
	
	if(!isdefined(self.ui_elements["health_ui"])) {
		self.ui_elements["health_ui"] = newClientHudElem(self);
		self.ui_elements["health_ui"].x = 5;
		self.ui_elements["health_ui"].y = 126;
		self.ui_elements["health_ui"].alignx = "left";
		self.ui_elements["health_ui"].aligny = "top";
		self.ui_elements["health_ui"].horzAlign = "fullscreen";
		self.ui_elements["health_ui"].vertalign = "fullscreen";
		self.ui_elements["health_ui"].fontscale = 1;
		self.ui_elements["health_ui"].label = &"^5HEALTH^7: ";
		self.ui_elements["health_ui"].hidewheninmenu = true;
		self.ui_elements["health_ui"].hidewheninkillcam = true;
		self.ui_elements["health_ui"].hidewhendead = true;
		self.ui_elements["health_ui"].archived = false;
		self.ui_elements["health_ui"].alpha = 1;
		self.ui_elements["health_ui"] thread destroy_on_notify("game_ended");
	}
	
	if(!isdefined(self.ui_elements["kills_ui"])) {
		self.ui_elements["kills_ui"] = newClientHudElem(self);
		self.ui_elements["kills_ui"].x = 5;
		self.ui_elements["kills_ui"].y = 116; 
		self.ui_elements["kills_ui"].alignx = "left";
		self.ui_elements["kills_ui"].aligny = "top";
		self.ui_elements["kills_ui"].horzAlign = "fullscreen";
		self.ui_elements["kills_ui"].vertalign = "fullscreen";
		self.ui_elements["kills_ui"].fontscale = 1;
		self.ui_elements["kills_ui"].label = &"^5KILLS^7: ";
		self.ui_elements["kills_ui"].hidewheninmenu = true;
		self.ui_elements["kills_ui"].hidewheninkillcam = true;
		self.ui_elements["kills_ui"].hidewhendead = true;
		self.ui_elements["kills_ui"].archived = false;
		self.ui_elements["kills_ui"].alpha = 1;
		self.ui_elements["kills_ui"] thread destroy_on_notify("game_ended");
	}
	
	if(!isdefined(self.ui_elements["killsstreak_ui"])) {
		self.ui_elements["killsstreak_ui"] = newClientHudElem(self);
		self.ui_elements["killsstreak_ui"].x = 5;
		self.ui_elements["killsstreak_ui"].y = 105; 
		self.ui_elements["killsstreak_ui"].alignx = "left";
		self.ui_elements["killsstreak_ui"].aligny = "top";
		self.ui_elements["killsstreak_ui"].horzAlign = "fullscreen";
		self.ui_elements["killsstreak_ui"].vertalign = "fullscreen";
		self.ui_elements["killsstreak_ui"].fontscale = 1;
		self.ui_elements["killsstreak_ui"].label = &"^5KILLSTREAK^7: ";
		self.ui_elements["killsstreak_ui"].hidewheninmenu = true;
		self.ui_elements["killsstreak_ui"].hidewheninkillcam = true;
		self.ui_elements["killsstreak_ui"].hidewhendead = true;
		self.ui_elements["killsstreak_ui"].archived = false;
		self.ui_elements["killsstreak_ui"].alpha = 1;
		self.ui_elements["killsstreak_ui"] thread destroy_on_notify("game_ended");
	}
	
	if(!isdefined(self.ui_elements["binds_ui"])) {
		self.ui_elements["binds_ui"] = newClientHudElem(self);
		self.ui_elements["binds_ui"].x = 81;
		self.ui_elements["binds_ui"].y = 4; 
		self.ui_elements["binds_ui"].alignx = "left";
		self.ui_elements["binds_ui"].aligny = "top";
		self.ui_elements["binds_ui"].horzAlign = "fullscreen";
		self.ui_elements["binds_ui"].vertalign = "fullscreen";
		self.ui_elements["binds_ui"].fontscale = 1;
		self.ui_elements["binds_ui"].hidewheninmenu = true;
		self.ui_elements["binds_ui"].hidewheninkillcam = true;
		self.ui_elements["binds_ui"].hidewhendead = true;
		self.ui_elements["binds_ui"].archived = false;
		self.ui_elements["binds_ui"].alpha = 1;
		self.ui_elements["binds_ui"] settext("^5[{vote no}] ^7High Fps\n^5[{vote yes}] ^7Fullbright\n^5[{+actionslot 1}] ^7Suicide");
		self.ui_elements["binds_ui"] thread destroy_on_notify("game_ended");
	}
	
	while(1) {
		wait .1;
		
		self.ui_elements["killsstreak_ui"] 	setValue(self getplayerData("killstreaksState","count"));
		self.ui_elements["kills_ui"] 		setvalue(self.kills);
		self.ui_elements["health_ui"]		setvalue(self.health);
	}
}









