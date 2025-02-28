#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// coonouk shame on you

init() {
	precacheshader("iw5_cardtitle_specialty_veteran");

	seg_fontscale = .37;

	if(!isdefined(level.info_hud_elements))
		level.info_hud_elements = [];

	if(!isdefined(level.info_hud_elements["background"])) {
		level.info_hud_elements["background"] = newhudelem();
		level.info_hud_elements["background"].horzalign = "fullscreen";
		level.info_hud_elements["background"].vertalign = "fullscreen";
		level.info_hud_elements["background"].alignx = "center";
		level.info_hud_elements["background"].aligny = "top";
		level.info_hud_elements["background"].x = 320;
		level.info_hud_elements["background"].y = -17;
		level.info_hud_elements["background"].color = (.4, .4, .4);
		level.info_hud_elements["background"].sort = -2;
		level.info_hud_elements["background"].archived = false;
		level.info_hud_elements["background"].hidewheninmenu = 1;
		level.info_hud_elements["background"].hidewheninkillcam = 1;
		level.info_hud_elements["background"].alpha = 1;
		level.info_hud_elements["background"] setshader("iw5_cardtitle_specialty_veteran", 180, 45);
	}

	if(!isdefined(level.info_hud_elements["background_right"])) {
		level.info_hud_elements["background_right"] = newhudelem();
		level.info_hud_elements["background_right"].horzalign = "fullscreen";
		level.info_hud_elements["background_right"].vertalign = "fullscreen";
		level.info_hud_elements["background_right"].alignx = "left";
		level.info_hud_elements["background_right"].aligny = "top";
		level.info_hud_elements["background_right"].x = 275;
		level.info_hud_elements["background_right"].y = -20;
		level.info_hud_elements["background_right"].color = (.4, .4, .4);
		level.info_hud_elements["background_right"].sort = -3;
		level.info_hud_elements["background_right"].archived = false;
		level.info_hud_elements["background_right"].hidewheninmenu = 1;
		level.info_hud_elements["background_right"].hidewheninkillcam = 1;
		level.info_hud_elements["background_right"].alpha = 1;
		level.info_hud_elements["background_right"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(level.info_hud_elements["background_left"])) {
		level.info_hud_elements["background_left"] = newhudelem();
		level.info_hud_elements["background_left"].horzalign = "fullscreen";
		level.info_hud_elements["background_left"].vertalign = "fullscreen";
		level.info_hud_elements["background_left"].alignx = "right";
		level.info_hud_elements["background_left"].aligny = "top";
		level.info_hud_elements["background_left"].x = 365;
		level.info_hud_elements["background_left"].y = -20;
		level.info_hud_elements["background_left"].color = (.4, .4, .4);
		level.info_hud_elements["background_left"].sort = -3;
		level.info_hud_elements["background_left"].archived = false;
		level.info_hud_elements["background_left"].hidewheninmenu = 1;
		level.info_hud_elements["background_left"].hidewheninkillcam = 1;
		level.info_hud_elements["background_left"].alpha = 1;
		level.info_hud_elements["background_left"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(level.info_hud_elements["text_info_right"])) {
		level.info_hud_elements["text_info_right"] = newhudelem();
		level.info_hud_elements["text_info_right"].horzalign = "fullscreen";
		level.info_hud_elements["text_info_right"].vertalign = "fullscreen";
		level.info_hud_elements["text_info_right"].alignx = "left";
		level.info_hud_elements["text_info_right"].aligny = "top";
		level.info_hud_elements["text_info_right"].x = 400;
		level.info_hud_elements["text_info_right"].y = 2;
		level.info_hud_elements["text_info_right"].font = "bigfixed";
		level.info_hud_elements["text_info_right"].archived = false;
		level.info_hud_elements["text_info_right"].hidewheninmenu = 1;
		level.info_hud_elements["text_info_right"].hidewheninkillcam = 1;
		level.info_hud_elements["text_info_right"].fontscale = seg_fontscale;
		level.info_hud_elements["text_info_right"] settext("^5[{vote no}] ^7High Fps   ^5[{vote yes}] ^7Fullbright   ^5[{+actionslot 1}] ^7Suicide");
	}

	if(!isdefined(level.info_hud_elements["host"])) {
		level.info_hud_elements["host"] = newhudelem();
		level.info_hud_elements["host"].horzalign = "fullscreen";
		level.info_hud_elements["host"].vertalign = "fullscreen";
		level.info_hud_elements["host"].alignx = "center";
		level.info_hud_elements["host"].aligny = "top";
		level.info_hud_elements["host"].x = 320;
		level.info_hud_elements["host"].y = 1;
		level.info_hud_elements["host"].font = "bigfixed";
		level.info_hud_elements["host"].archived = false;
		level.info_hud_elements["host"].hidewheninmenu = 1;
		level.info_hud_elements["host"].hidewheninkillcam = 1;
		level.info_hud_elements["host"].fontscale = .6;
		level.info_hud_elements["host"] settext("www.^5Gillette^7Clan.com");
	}

	level thread on_connect();
}

on_connect() {
	self endon ("disconnect");
  	for (;;) {
		level waittill("connected", player);

		player.hadgunsrotated = 0;

		if(!isdefined(player.hud_elements))
			player.hud_elements = [];

		player SetClientDvar("cg_objectiveText", "^5Gillette^7Clan.com\n^7Join us on Discord ^5discord.gg/GilletteClan");

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
            self thread hud_create();
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
			self SetClientDvars("r_fog", "0");
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
			self SetClientDvars("r_fog", "1", "r_lightmap", "1");
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

hud_create() {
	self endon("disconnect");
	level endon("game_ended");

	x_spacing = 35;
	seg_fontscale = .37;

	if(!isdefined(self.hud_elements["health_ui"])) {
		self.hud_elements["health_ui"] = newClientHudElem(self);
		self.hud_elements["health_ui"].alignx = "left";
		self.hud_elements["health_ui"].aligny = "top";
		self.hud_elements["health_ui"].horzAlign = "fullscreen";
		self.hud_elements["health_ui"].vertalign = "fullscreen";
		self.hud_elements["health_ui"].x = 240 - x_spacing;
		self.hud_elements["health_ui"].y = 2;
		self.hud_elements["health_ui"].font = "bigfixed";
		self.hud_elements["health_ui"].fontscale = seg_fontscale;
		self.hud_elements["health_ui"].label = &"Health: ^5";
		self.hud_elements["health_ui"].hidewheninmenu = true;
		self.hud_elements["health_ui"].hidewheninkillcam = true;
		self.hud_elements["health_ui"].archived = false;
		self.hud_elements["health_ui"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["kills_ui"])) {
		self.hud_elements["kills_ui"] = newClientHudElem(self);
		self.hud_elements["kills_ui"].alignx = "left";
		self.hud_elements["kills_ui"].aligny = "top";
		self.hud_elements["kills_ui"].horzAlign = "fullscreen";
		self.hud_elements["kills_ui"].vertalign = "fullscreen";
		self.hud_elements["kills_ui"].x = 240 - (x_spacing * 2) + 7;
		self.hud_elements["kills_ui"].y = 2;
		self.hud_elements["kills_ui"].font = "bigfixed";
		self.hud_elements["kills_ui"].fontscale = seg_fontscale;
		self.hud_elements["kills_ui"].label = &"Kills: ^5";
		self.hud_elements["kills_ui"].hidewheninmenu = true;
		self.hud_elements["kills_ui"].hidewheninkillcam = true;
		self.hud_elements["kills_ui"].archived = false;
		self.hud_elements["kills_ui"].alpha = 1;
	}

	if(!isdefined(self.hud_elements["killsstreak_ui"])) {
		self.hud_elements["killsstreak_ui"] = newClientHudElem(self);
		self.hud_elements["killsstreak_ui"].alignx = "left";
		self.hud_elements["killsstreak_ui"].aligny = "top";
		self.hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
		self.hud_elements["killsstreak_ui"].vertalign = "fullscreen";
		self.hud_elements["killsstreak_ui"].x = 240 - (x_spacing * 3);
		self.hud_elements["killsstreak_ui"].y = 2;
		self.hud_elements["killsstreak_ui"].font = "bigfixed";
		self.hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
		self.hud_elements["killsstreak_ui"].label = &"Killstreak: ^5";
		self.hud_elements["killsstreak_ui"].hidewheninmenu = true;
		self.hud_elements["killsstreak_ui"].hidewheninkillcam = true;
		self.hud_elements["killsstreak_ui"].archived = false;
		self.hud_elements["killsstreak_ui"].alpha = 1;
	}

	while(1) {
		self.hud_elements["killsstreak_ui"] setValue(self getplayerData("killstreaksState","count"));
		self.hud_elements["kills_ui"] setvalue(self.kills);
		self.hud_elements["health_ui"] setvalue(self.health);

        wait .05;
	}
}

