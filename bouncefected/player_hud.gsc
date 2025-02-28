#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

destroy_on_notify(notifyname) {
	level waittill(notifyname);
	
	if(isdefined(self))
		self destroy();
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
		self.ui_elements["binds_ui"] settext("^5[{vote no}] ^7High Fps\n^5[{vote yes}] ^7Fullbright\n^5[{+actionslot 6}] ^7Or ^5[{+actionslot 1}] ^7Suicide\n^5[{+actionslot 3}] ^7Auto Skip Killcam");
		self.ui_elements["binds_ui"] thread destroy_on_notify("game_ended");
	}
	
	while(1) {
		wait .5;
		
		self.ui_elements["killsstreak_ui"] 	setValue(self getplayerData("killstreaksState","count"));
		self.ui_elements["kills_ui"] 		setvalue(self.kills);
		self.ui_elements["health_ui"]		setvalue(self.health);
	}
}
