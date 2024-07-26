#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// Made by ZECxR3ap3r

main() {
	// disable hitmarkers
	replacefunc(maps\mp\gametypes\_damagefeedback::init, ::blank);
	replacefunc(maps\mp\gametypes\_damagefeedback::updatedamagefeedback, ::blank);
	// save shaders
	replacefunc(maps\mp\killstreaks\_killstreaks::init, ::killstreaks_init_edit);
	// removing all intro huds
	replacefunc(maps\mp\gametypes\_gamelogic::matchstarttimer, ::hud_game_intro);
	replacefunc(maps\mp\gametypes\gun::initGunHUD, ::blank);
	replacefunc(maps\mp\gametypes\gun::updateGunHUD, ::blank);


}

init() {
	replacefunc(maps\mp\gametypes\_rank::xpEventPopup, ::xpEventPopup_new);
	replacefunc(maps\mp\gametypes\_rank::xpPointsPopup, ::xpPointsPopup_new);
	replacefunc(maps\mp\perks\_perkfunctions::GlowStickUseListener, ::GlowStickUseListener_new);
	
    precacheshader("damage_feedback");
    precacheshader("gradient_fadein");
    
    precacheshader("specialty_ks_null");
    precacheshader("stencil_base");
    precacheshader("line_horizontal");
    
	level thread add_hud_weapon("iw5_1911", "hud_icon_acr", "1911");
	level thread add_hud_weapon("iw5_ak104", "hud_icon_ak104", "AK104");
	level thread add_hud_weapon("iw5_an94", "hud_icon_an94", "AN-94");
	level thread add_hud_weapon("iw5_ariar", "hud_icon_acr", "Ariar");
	level thread add_hud_weapon("iw5_blunderbuss", "hud_icon_acr", "Blunderbuss");
	level thread add_hud_weapon("iw5_colt44", "hud_icon_colt_anaconda", "anaconda");
	level thread add_hud_weapon("iw5_commando", "hud_icon_acr", "Commando");
	level thread add_hud_weapon("iw5_dsr50", "hud_icon_dsr50", "dsr-50");
	level thread add_hud_weapon("iw5_h1de50", "hud_icon_acr", "H1 DesertEgale");
	level thread add_hud_weapon("iw5_hk21", "hud_icon_hk21", "HK-21");
	level thread add_hud_weapon("iw5_mp40", "hud_icon_acr", "MP40");
	level thread add_hud_weapon("iw5_mp44", "hud_icon_mp44", "MP44");
	level thread add_hud_weapon("iw5_r700", "hud_icon_remington700", "R700");
	level thread add_hud_weapon("iw5_rpgdragon", "hud_icon_rpgdragon", "Dragon RPG");
	level thread add_hud_weapon("iw5_rpk", "hud_icon_acr", "RPK");
	level thread add_hud_weapon("iw5_mp5k", "hud_icon_t5_mp5k", "MP5K");
	level thread add_hud_weapon("iw5_ump45mw", "hud_icon_ump45", "UMP45 MW");
	level thread add_hud_weapon("iw5_vepr", "hud_icon_vepr", "Vepr");
	level thread add_hud_weapon("iw5_arx160", "hud_icon_arx", "ARX-160");
	level thread add_hud_weapon("iw5_rpk", "hud_icon_arx", "RPK");
	level thread add_hud_weapon("iw5_sickle", "cardicon_knife_logo", "Sickle");
	level thread add_hud_weapon("iw5_barber", "cardicon_knife_logo", "Barber");
	level thread add_hud_weapon("iw5_raygun", "hud_icon_raygun", "Raygun");
	
    flag_init("hud_visible");
    
    level.ui_score_y = 22;
    level.ui_color = spawnstruct();
	level.ui_color.blue = (.094, .514, 1);
	level.ui_color.red = (.753, .255, .231);
	
	game["strings"]["axis_name"] = "";
	game["strings"]["allies_name"] = "";
	
	game["icons"]["allies"] = "stencil_base";
	game["icons"]["axis"] = "stencil_base";
	
	setdvar("g_hardcore", 1);
	setdvar("g_compassShowEnemies", 1);
	setdvar("g_ScoresColor_Allies", "" + level.ui_color.blue[0] + " " + level.ui_color.blue[1] + " " + level.ui_color.blue[2] + " 1");
    setdvar("g_ScoresColor_Axis", "" + level.ui_color.red[0] + " " + level.ui_color.red[1] + " " + level.ui_color.red[2] + " 1");
	
    level thread on_connect();
}

on_connect() {
  	for (;;) {
    	level waittill("connected", player);
    	
    	player setclientdvar("cg_teamcolor_allies", "" + level.ui_color.blue[0] + " " + level.ui_color.blue[1] + " " + level.ui_color.blue[2] + " 1");
    	player setclientdvar("cg_teamcolor_axis", "" + level.ui_color.red[0] + " " + level.ui_color.red[1] + " " + level.ui_color.red[2] + " 1");
    	
    	player thread on_spawned();
    	player thread damage_callback();
    	player thread ui_create_player();
	}
}

on_spawned() {
	self endon("disconnect");
	
	self.grenade_hud = spawnstruct();
	self.grenade_hud.grenade_shader = "";
	self.grenade_hud.secondary_shader = "";
	
	while(1) {
		self waittill("spawned_player");
		
		flag_wait("hud_visible");
		
		self setclientdvar("g_compassShowEnemies", 1);
		
		if(!isdefined(self.initial_spawn_main))
			self thread watch_kit_change();
		
		self set_player_grenades();
		
		//self giveweapon("iw5_acr_mp");
	}
}

add_hud_weapon(weaponname, hudicon, conv_string) {
	if(!isdefined(level.hud_weapons))
		level.hud_weapons = [];
		
	if(!isdefined(level.hud_weapons[weaponname])) {
		level.hud_weapons[weaponname] = spawnstruct();
		level.hud_weapons[weaponname].icon = hudicon;
		level.hud_weapons[weaponname].string = conv_string;
		
		precacheshader(level.hud_weapons[weaponname].icon);
	}
}

hud_game_intro(start_time, time) {
	hey = undefined;
	
	visionsetnaked( "mpIntro", 1);
	
	if(!isdefined(level.top_bg)) {
		level.top_bg = newhudelem();
		level.top_bg.horzalign = "fullscreen";
		level.top_bg.vertalign = "fullscreen";
		level.top_bg.alignx = "left";
		level.top_bg.aligny = "top";
		level.top_bg.x = 0;
		level.top_bg.y = 0;
		level.top_bg.sort = 1;
		level.top_bg.alpha = .9;
		level.top_bg.hidewheninmenu = 1;
		level.top_bg setshader("black", 640, 50);
		
		level.match_begin = newhudelem();
		level.match_begin.horzalign = "fullscreen";
		level.match_begin.vertalign = "fullscreen";
		level.match_begin.alignx = "center";
		level.match_begin.aligny = "top";
		level.match_begin.x = 320;
		level.match_begin.y = 12;
		level.match_begin.color = (.8, .8, .8);
		level.match_begin.alpha = 1;
		level.match_begin.sort = 2;
		level.match_begin.font = "small";
		level.match_begin.fontscale = .75;
		level.match_begin.hidewheninmenu = 1;
		level.match_begin settext(game["strings"]["match_starting_in"]);
		
		level.match_timer = newhudelem();
		level.match_timer.horzalign = "fullscreen";
		level.match_timer.vertalign = "fullscreen";
		level.match_timer.alignx = "center";
		level.match_timer.aligny = "top";
		level.match_timer.x = 320;
		level.match_timer.y = 25;
		level.match_timer.sort = 2;
		level.match_timer.color = (1, .75, 0);
		level.match_timer.alpha = 1;
		level.match_timer.font = "small";
		level.match_timer.fontscale = 1.25;
		level.match_timer settenthstimer(time);
		level.match_timer.hidewheninmenu = 1;
	}
	
	for(i = time;i > 0;i--) {
		if(i == 1)
			visionsetnaked( getDvar( "mapname" ), 1);
		
		if(time == 5 && !isdefined(hey)) {
			level.match_timer destroy();
			
			hey = true;
			
			level.match_timer = newhudelem();
			level.match_timer.horzalign = "fullscreen";
			level.match_timer.vertalign = "fullscreen";
			level.match_timer.alignx = "center";
			level.match_timer.aligny = "top";
			level.match_timer.x = 320;
			level.match_timer.y = 25;
			level.match_timer.sort = 2;
			level.match_timer.color = (1, .75, 0);
			level.match_timer.alpha = 1;
			level.match_timer.font = "small";
			level.match_timer.fontscale = 1.25;
			level.match_timer settenthstimer(time);
			level.match_timer.hidewheninmenu = 1;
		}
		
		wait 1;
	}
	
	if(isdefined(level.match_timer))
		level.match_timer destroy();
	if(isdefined(level.match_begin))
		level.match_begin destroy();
	if(isdefined(level.top_bg))
		level.top_bg destroy();
	
	flag_set("hud_visible");
}

blank(var_0) {
	
}

update_hitmarker() {
	scale_up = 1.25;
    scale_down = .875;
    scale_time = .04;
    
    while(1) {
    	self waittill("trigger_hitmarker");
    	
		if(isalive(self)) {
			self playlocalsound( "MP_hit_alert" );
				
	        self.ui_elements["hitmarker"].color = self.recommended_color;
	        
	        self.recommended_color = (1, 1, 1);
	           	
	        self.ui_elements["hitmarker"].alpha = 1;
	
	        self.ui_elements["hitmarker"] scaleovertime(scale_time, int(24 * scale_up), int(48 * scale_up));
	        self.ui_elements["hitmarker"] moveovertime(scale_time);
	        self.ui_elements["hitmarker"].x = int(-12 * scale_up);
	        self.ui_elements["hitmarker"].y = int(-12 * scale_up);
	
	        wait float(scale_time * 2);
	
	        self.ui_elements["hitmarker"] scaleovertime(scale_time, int(24 * scale_down), int(48 * scale_down));
	        self.ui_elements["hitmarker"] moveovertime(scale_time);
	        self.ui_elements["hitmarker"].x = int(-12 * scale_down);
	        self.ui_elements["hitmarker"].y = int(-12 * scale_down);
	
	        self.ui_elements["hitmarker"] fadeovertime(.35);
	        self.ui_elements["hitmarker"].alpha = 0;
	 	}
	}
}

watch_kit_change() {
	self endon("disconnect");
	
	while(1) {
		self waittill("changed_kit");

		// stuff here
	}
}

//self set_player_grenades();

damage_callback() {
	self endon("disconnect");
	
	self.recommended_color = (1,1,1);
	
	self thread update_hitmarker();
	
	while(1) {
		self waittill("damage", amount, attacker, direction, point, type, modelname, tagname, partname, weaponname);
		
		if(isdefined(attacker) && attacker != self) {
			if(!isalive(self))
				attacker.recommended_color = level.ui_color.red;
			else
				attacker.recommended_color = (1,1,1);
		}
		
		attacker notify("trigger_hitmarker");
	}
}

set_player_grenades() {
	wait .1;
	
	if(getdvar("g_gametype") != "gun") {
		offhandWeapons = self getWeaponsListOffhands();
		if(isdefined(offhandWeapons[0])) {
			if(offhandWeapons[0] == "frag_grenade_mp")
				self.grenade_hud.grenade_shader = "hud_us_grenade";
			else if(offhandWeapons[0] == "c4_mp")
				self.grenade_hud.grenade_shader = "hud_icon_c4";
			else if(offhandWeapons[0] == "semtex_mp")
				self.grenade_hud.grenade_shader = "hud_us_semtex";
			else if(offhandWeapons[0] == "claymore_mp")
				self.grenade_hud.grenade_shader = "hud_icon_claymore";
			else if(offhandWeapons[0] == "bouncingbetty_mp")
				self.grenade_hud.grenade_shader = "hud_icon_bouncingbetty";
			else if(offhandWeapons[0] == "throwingknife_mp")
				self.grenade_hud.grenade_shader = "equipment_throwing_knife";
			else
				self.grenade_hud.grenade_shader = "";
			
			self.grenade_hud.grenade_name = offhandWeapons[0];
		}
				
		self.ui_elements["weapon_grenade_grenade_icon"] setshader(self.grenade_hud.grenade_shader, 15, 15);
		
		if(isdefined(offhandWeapons[1])) {
			if(offhandWeapons[1] == "flash_grenade_mp")
				self.grenade_hud.secondary_shader = "hud_us_flashgrenade";
			else if(offhandWeapons[1] == "concussion_grenade_mp")
				self.grenade_hud.secondary_shader = "hud_us_stungrenade";
			else if(offhandWeapons[1] == "smoke_grenade_mp")
				self.grenade_hud.secondary_shader = "hud_us_smokegrenade";
			else if(offhandWeapons[1] == "flare_mp")
				self.grenade_hud.secondary_shader = "equipment_flare";
			else if(offhandWeapons[1] == "trophy_mp")
				self.grenade_hud.secondary_shader = "hud_icon_trophy";
			else if(offhandWeapons[1] == "scrambler_mp")
				self.grenade_hud.secondary_shader = "hud_icon_scrambler";
			else if(offhandWeapons[1] == "portable_radar_mp")
				self.grenade_hud.secondary_shader = "hud_icon_portable_radar";
			else if(offhandWeapons[1] == "emp_grenade_mp")
				self.grenade_hud.secondary_shader = "equipment_emp_grenade";
			else
				self.grenade_hud.secondary_shader = "";
			
			self.grenade_hud.secondary_name = offhandWeapons[1];
		}
	}
	
	if(isdefined(self.pers["killstreaks"][3].streakName)) {
		if(isdefined(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][3].streakName))) {
			self.ui_elements["weapon_killstreak_icon_3"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_3"].alpha = .45;
			
			self.ui_elements["weapon_killstreak_icon_3"] setshader(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][3].streakName), self.ui_elements["weapon_killstreak_icon_3"].icon_size, self.ui_elements["weapon_killstreak_icon_3"].icon_size);
		}
		else {
			self.ui_elements["weapon_killstreak_icon_3"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_3"].icon_size, self.ui_elements["weapon_killstreak_icon_3"].icon_size);
			
			self.ui_elements["weapon_killstreak_icon_3"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_3"].alpha = .45;
		}
	}
	else {
		self.ui_elements["weapon_killstreak_icon_3"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_3"].icon_size, self.ui_elements["weapon_killstreak_icon_3"].icon_size);
		
		self.ui_elements["weapon_killstreak_icon_3"].alpha = .45;
		self.ui_elements["weapon_killstreak_box_3"].alpha = .45;
	}
		
	
	if(isdefined(self.pers["killstreaks"][2].streakName)) {
		if(isdefined(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][2].streakName))) {
			self.ui_elements["weapon_killstreak_icon_2"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_2"].alpha = .45;
			
			self.ui_elements["weapon_killstreak_icon_2"] setshader(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][2].streakName), self.ui_elements["weapon_killstreak_icon_2"].icon_size, self.ui_elements["weapon_killstreak_icon_2"].icon_size);
		}
		else {
			self.ui_elements["weapon_killstreak_icon_2"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_2"].icon_size, self.ui_elements["weapon_killstreak_icon_2"].icon_size);
			
			self.ui_elements["weapon_killstreak_icon_2"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_2"].alpha = .45;
		}
	}
	else {
		self.ui_elements["weapon_killstreak_icon_2"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_2"].icon_size, self.ui_elements["weapon_killstreak_icon_2"].icon_size);
		
		self.ui_elements["weapon_killstreak_icon_2"].alpha = .45;
		self.ui_elements["weapon_killstreak_box_2"].alpha = .45;
	}
	
	if(isdefined(self.pers["killstreaks"][1].streakName)) {
		if(isdefined(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][1].streakName))) {
			self.ui_elements["weapon_killstreak_icon_1"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_1"].alpha = .45;
			
			self.ui_elements["weapon_killstreak_icon_1"] setshader(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][1].streakName), self.ui_elements["weapon_killstreak_icon_1"].icon_size, self.ui_elements["weapon_killstreak_icon_1"].icon_size);
		}
		else {
			self.ui_elements["weapon_killstreak_icon_3"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_3"].icon_size, self.ui_elements["weapon_killstreak_icon_3"].icon_size);
			
			self.ui_elements["weapon_killstreak_icon_1"].alpha = .45;
			self.ui_elements["weapon_killstreak_box_1"].alpha = .45;
		}
	}
	else {
		self.ui_elements["weapon_killstreak_icon_1"] setshader("specialty_ks_null", self.ui_elements["weapon_killstreak_icon_1"].icon_size, self.ui_elements["weapon_killstreak_icon_1"].icon_size);
		
		self.ui_elements["weapon_killstreak_icon_1"].alpha = .45;
		self.ui_elements["weapon_killstreak_box_1"].alpha = .45;
	}
		
	//self.ui_elements["weapon_grenade_secondary_icon"] setshader(self.grenade_hud.secondary_shader, 15, 15);
		
	if(isdefined(self.ui_elements["weapon_name"]))
		self.ui_elements["weapon_name"] settext(self get_weapon_name_conv(getbaseweaponname(self getcurrentweapon())));
}

low_clip_ammo() {
	self endon("disconnect");
	
	wait 1;
	
	while(1) {
		if(isalive(self) && self.sessionstate == "playing") {
			current = self getcurrentweapon();
			
			if(self getweaponammoclip(current) < int(weaponClipSize(current) / 2)) {
				self.ui_elements["weapon_clip_count"] fadeovertime(.4);
				self.ui_elements["weapon_clip_count"].color = level.ui_color.red;
				wait .4;
				self.ui_elements["weapon_clip_count"] fadeovertime(.4);
				self.ui_elements["weapon_clip_count"].color = (1, 1, 1);
				wait .4;
			}
		}
		
		wait .1;
	}
}

track_killstreaks() {
	self endon("disconnect");
	
	while(1) {
		self waittill_any("received_earned_killstreak", "finish_death", "weapon_change");
		
		if(isdefined(self.pers["killstreaks"][0].available) && self.pers["killstreaks"][0].available == 1) {
			self.ui_elements["weapon_killstreak_icon_" + 0].alpha = 1;
			self.ui_elements["weapon_killstreak_box_" + 0].color = (.5, .5, .5);
			self.ui_elements["weapon_killstreak_box_" + 0].alpha = .5;
			self.ui_elements["weapon_killstreak_icon_" + 0] setshader(maps\mp\killstreaks\_killstreaks::getKillstreakIcon(self.pers["killstreaks"][0].streakname), 16, 16);
		}
		else {
			self.ui_elements["weapon_killstreak_icon_" + 0].alpha = 0;
			self.ui_elements["weapon_killstreak_box_" + 0].color = (0, 0, 0);
			self.ui_elements["weapon_killstreak_box_" + 0].alpha = 0;
		}
		
		for(i = 1;i < self.pers["killstreaks"].size;i++) {
			if(isdefined(self.pers["killstreaks"][i].available) && self.pers["killstreaks"][i].available == 1) {
				if(isdefined(self.ui_elements["weapon_killstreak_icon_" + i])) {
					self.ui_elements["weapon_killstreak_icon_" + i].alpha = 1;
					self.ui_elements["weapon_killstreak_box_" + i].color = (.5, .5, .5);
				}
			}
			else {
				if(isdefined(self.pers["killstreaks"][i].available) && self.pers["killstreaks"][i].available == 0) {
					if(isdefined(self.ui_elements["weapon_killstreak_icon_" + i])) {
						self.ui_elements["weapon_killstreak_icon_" + i].alpha = .5;
						self.ui_elements["weapon_killstreak_box_" + i].color = (0, 0, 0);
					}
				}
			}
		}
	}
}

create_weapon_ui() {
	self endon("disconnect");
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
		
	self thread low_clip_ammo();
	self thread track_killstreaks();
	
	box_size 		= 18;
	icon_size		= 16;
	x 				= 630;
	y 				= 470;
	base_alpha 		= .5;
	
	if(!isdefined(self.ui_elements["weapon_right_bg"])) {
		self.ui_elements["weapon_right_bg"] = newclienthudelem(self);
		self.ui_elements["weapon_right_bg"].x = x;
		self.ui_elements["weapon_right_bg"].basex = x;
	    self.ui_elements["weapon_right_bg"].y = y;
	    self.ui_elements["weapon_right_bg"].alignx = "right";
	    self.ui_elements["weapon_right_bg"].aligny = "bottom";
	    self.ui_elements["weapon_right_bg"].horzalign = "fullscreen";
	    self.ui_elements["weapon_right_bg"].vertalign = "fullscreen";
	    self.ui_elements["weapon_right_bg"].alpha = base_alpha;
	    self.ui_elements["weapon_right_bg"].basealpha = base_alpha;
	    self.ui_elements["weapon_right_bg"].sort = 1;
	    self.ui_elements["weapon_right_bg"].archived = true;
	    self.ui_elements["weapon_right_bg"].foreground = true;
	    self.ui_elements["weapon_right_bg"].hidewheninmenu = true;
	    self.ui_elements["weapon_right_bg"].hidewhendead = true;
	    self.ui_elements["weapon_right_bg"] setshader("black", 80, 30);
	    self.ui_elements["weapon_right_bg"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_shader"])) {
		self.ui_elements["weapon_shader"] = newclienthudelem(self);
		self.ui_elements["weapon_shader"].x = x - 6;
		self.ui_elements["weapon_shader"].basex = self.ui_elements["weapon_shader"].x;
	    self.ui_elements["weapon_shader"].y = y - 15;
	    self.ui_elements["weapon_shader"].alignx = "right";
	    self.ui_elements["weapon_shader"].aligny = "middle";
	    self.ui_elements["weapon_shader"].horzalign = "fullscreen";
	    self.ui_elements["weapon_shader"].vertalign = "fullscreen";
	    self.ui_elements["weapon_shader"].alpha = 1;
	    self.ui_elements["weapon_shader"].sort = 2;
	    self.ui_elements["weapon_shader"].archived = true;
	    self.ui_elements["weapon_shader"].foreground = true;
	    self.ui_elements["weapon_shader"].hidewheninmenu = true;
	    self.ui_elements["weapon_shader"].hidewhendead = true;
	    self.ui_elements["weapon_shader"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_right_bg_light"])) {
		self.ui_elements["weapon_right_bg_light"] = newclienthudelem(self);
		self.ui_elements["weapon_right_bg_light"].x = x - 80;
		self.ui_elements["weapon_right_bg_light"].basex = self.ui_elements["weapon_right_bg_light"].x;
	    self.ui_elements["weapon_right_bg_light"].y = y;
	    self.ui_elements["weapon_right_bg_light"].alignx = "right";
	    self.ui_elements["weapon_right_bg_light"].aligny = "bottom";
	    self.ui_elements["weapon_right_bg_light"].horzalign = "fullscreen";
	    self.ui_elements["weapon_right_bg_light"].vertalign = "fullscreen";
	    self.ui_elements["weapon_right_bg_light"].alpha = base_alpha - .1;
	    self.ui_elements["weapon_right_bg_light"].basealpha = base_alpha - .1;
	    self.ui_elements["weapon_right_bg_light"].sort = 1;
	    self.ui_elements["weapon_right_bg_light"].archived = true;
	    self.ui_elements["weapon_right_bg_light"].foreground = true;
	    self.ui_elements["weapon_right_bg_light"].hidewheninmenu = true;
	    self.ui_elements["weapon_right_bg_light"].hidewhendead = true;
	    self.ui_elements["weapon_right_bg_light"] setshader("black", 30, 30);
	    self.ui_elements["weapon_right_bg_light"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_name_bg"])) {
		self.ui_elements["weapon_name_bg"] = newclienthudelem(self);
		self.ui_elements["weapon_name_bg"].x = x;
		self.ui_elements["weapon_name_bg"].basex = self.ui_elements["weapon_name_bg"].x;
	    self.ui_elements["weapon_name_bg"].y = y - 33;
	    self.ui_elements["weapon_name_bg"].alignx = "right";
	    self.ui_elements["weapon_name_bg"].aligny = "bottom";
	    self.ui_elements["weapon_name_bg"].horzalign = "fullscreen";
	    self.ui_elements["weapon_name_bg"].vertalign = "fullscreen";
	    self.ui_elements["weapon_name_bg"].alpha = base_alpha + 0.1;
	    self.ui_elements["weapon_name_bg"].basealpha = base_alpha + 0.1;
	    self.ui_elements["weapon_name_bg"].sort = 1;
	    self.ui_elements["weapon_name_bg"].archived = true;
	    self.ui_elements["weapon_name_bg"].foreground = true;
	    self.ui_elements["weapon_name_bg"].hidewheninmenu = true;
	    self.ui_elements["weapon_name_bg"].hidewhendead = true;
	    self.ui_elements["weapon_name_bg"].color = (0, 0, 0);
	    self.ui_elements["weapon_name_bg"] setshader("gradient_fadein", 115, 11);
	    self.ui_elements["weapon_name_bg"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_clip_count"])) {
		self.ui_elements["weapon_clip_count"] = newclienthudelem(self);
		self.ui_elements["weapon_clip_count"].x = self.ui_elements["weapon_right_bg_light"].x - 15;
		self.ui_elements["weapon_clip_count"].basex = self.ui_elements["weapon_clip_count"].x;
	    self.ui_elements["weapon_clip_count"].y = self.ui_elements["weapon_right_bg_light"].y - 16;
	    self.ui_elements["weapon_clip_count"].alignx = "center";
	    self.ui_elements["weapon_clip_count"].aligny = "middle";
	    self.ui_elements["weapon_clip_count"].horzalign = "fullscreen";
	    self.ui_elements["weapon_clip_count"].vertalign = "fullscreen";
	    self.ui_elements["weapon_clip_count"].alpha = 1;
	    self.ui_elements["weapon_clip_count"].basealpha = 1;
	    self.ui_elements["weapon_clip_count"].sort = 3;
	    self.ui_elements["weapon_clip_count"].archived = true;
	    self.ui_elements["weapon_clip_count"].foreground = true;
	    self.ui_elements["weapon_clip_count"].hidewheninmenu = true;
	    self.ui_elements["weapon_clip_count"].hidewhendead = true;
	    self.ui_elements["weapon_clip_count"].font = "hudbig";
	    self.ui_elements["weapon_clip_count"].fontscale = 1.1;
	    self.ui_elements["weapon_clip_count"].color = (1, 1, 1);
	    self.ui_elements["weapon_clip_count"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_stock_count"])) {
		self.ui_elements["weapon_stock_count"] = newclienthudelem(self);
		self.ui_elements["weapon_stock_count"].x = x - 78;
		self.ui_elements["weapon_stock_count"].basex = self.ui_elements["weapon_stock_count"].x;
	    self.ui_elements["weapon_stock_count"].y = self.ui_elements["weapon_right_bg_light"].y - 16;
	    self.ui_elements["weapon_stock_count"].alignx = "left";
	    self.ui_elements["weapon_stock_count"].aligny = "middle";
	    self.ui_elements["weapon_stock_count"].horzalign = "fullscreen";
	    self.ui_elements["weapon_stock_count"].vertalign = "fullscreen";
	    self.ui_elements["weapon_stock_count"].alpha = 1;
	    self.ui_elements["weapon_stock_count"].basealpha = 1;
	    self.ui_elements["weapon_stock_count"].sort = 3;
	    self.ui_elements["weapon_stock_count"].archived = true;
	    self.ui_elements["weapon_stock_count"].foreground = true;
	    self.ui_elements["weapon_stock_count"].hidewheninmenu = true;
	    self.ui_elements["weapon_stock_count"].hidewhendead = true;
	    self.ui_elements["weapon_stock_count"].font = "hudbig";
	    self.ui_elements["weapon_stock_count"].fontscale = .55;
	    self.ui_elements["weapon_stock_count"].color = (.5, .5, .5);
	    self.ui_elements["weapon_stock_count"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_name"])) {
		self.ui_elements["weapon_name"] = newclienthudelem(self);
		self.ui_elements["weapon_name"].x = x - 5;
		self.ui_elements["weapon_name"].basex = self.ui_elements["weapon_name"].x;
	    self.ui_elements["weapon_name"].y = self.ui_elements["weapon_name_bg"].y;
	    self.ui_elements["weapon_name"].alignx = "right";
	    self.ui_elements["weapon_name"].aligny = "bottom";
	    self.ui_elements["weapon_name"].horzalign = "fullscreen";
	    self.ui_elements["weapon_name"].vertalign = "fullscreen";
	    self.ui_elements["weapon_name"].alpha = 1;
	    self.ui_elements["weapon_name"].basealpha = 1;
	    self.ui_elements["weapon_name"].sort = 3;
	    self.ui_elements["weapon_name"].font = "small";
	    self.ui_elements["weapon_name"].archived = true;
	    self.ui_elements["weapon_name"].foreground = true;
	    self.ui_elements["weapon_name"].hidewheninmenu = true;
	    self.ui_elements["weapon_name"].hidewhendead = true;
	    self.ui_elements["weapon_name"].fontscale = .95;
	    self.ui_elements["weapon_name"].color = (1, 1, 1);
	    self.ui_elements["weapon_name"] thread destroy_on_notify( "end_game" );
	    self.ui_elements["weapon_name"] thread watch_weapon_change(self);
	}
	
	if(!isdefined(self.ui_elements["weapon_grenade_bg"])) {
		self.ui_elements["weapon_grenade_bg"] = newclienthudelem(self);
		self.ui_elements["weapon_grenade_bg"].x = x;
		self.ui_elements["weapon_grenade_bg"].basex = self.ui_elements["weapon_grenade_bg"].x;
	    self.ui_elements["weapon_grenade_bg"].y = self.ui_elements["weapon_name"].y - 13;
	    self.ui_elements["weapon_grenade_bg"].alignx = "right";
	    self.ui_elements["weapon_grenade_bg"].aligny = "bottom";
	    self.ui_elements["weapon_grenade_bg"].horzalign = "fullscreen";
	    self.ui_elements["weapon_grenade_bg"].vertalign = "fullscreen";
	    self.ui_elements["weapon_grenade_bg"].alpha = base_alpha;
	    self.ui_elements["weapon_grenade_bg"].basealpha = base_alpha;
	    self.ui_elements["weapon_grenade_bg"].sort = 1;
	    self.ui_elements["weapon_grenade_bg"].archived = true;
	    self.ui_elements["weapon_grenade_bg"].foreground = true;
	    self.ui_elements["weapon_grenade_bg"].hidewheninmenu = true;
	    self.ui_elements["weapon_grenade_bg"].hidewhendead = true;
	    self.ui_elements["weapon_grenade_bg"] setshader("black", 40, 20);
	    self.ui_elements["weapon_grenade_bg"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_grenade_grenade_icon"])) {
		self.ui_elements["weapon_grenade_grenade_icon"] = newclienthudelem(self);
		self.ui_elements["weapon_grenade_grenade_icon"].x = x - 39;
		self.ui_elements["weapon_grenade_grenade_icon"].basex = self.ui_elements["weapon_grenade_grenade_icon"].x;
	    self.ui_elements["weapon_grenade_grenade_icon"].y = self.ui_elements["weapon_name"].y - 15;
	    self.ui_elements["weapon_grenade_grenade_icon"].alignx = "left";
	    self.ui_elements["weapon_grenade_grenade_icon"].aligny = "bottom";
	    self.ui_elements["weapon_grenade_grenade_icon"].horzalign = "fullscreen";
	    self.ui_elements["weapon_grenade_grenade_icon"].vertalign = "fullscreen";
	    self.ui_elements["weapon_grenade_grenade_icon"].alpha = 1;
	    self.ui_elements["weapon_grenade_grenade_icon"].basealpha = 1;
	    self.ui_elements["weapon_grenade_grenade_icon"].sort = 2;
	    self.ui_elements["weapon_grenade_grenade_icon"].archived = true;
	    self.ui_elements["weapon_grenade_grenade_icon"].foreground = true;
	    self.ui_elements["weapon_grenade_grenade_icon"].hidewheninmenu = true;
	    self.ui_elements["weapon_grenade_grenade_icon"].hidewhendead = true;
	    self.ui_elements["weapon_grenade_grenade_icon"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_grenade_secondary_icon"])) {
		self.ui_elements["weapon_grenade_secondary_icon"] = newclienthudelem(self);
		self.ui_elements["weapon_grenade_secondary_icon"].x = x - 21;
		self.ui_elements["weapon_grenade_secondary_icon"].basex = self.ui_elements["weapon_grenade_secondary_icon"].x;
	    self.ui_elements["weapon_grenade_secondary_icon"].y = self.ui_elements["weapon_name"].y - 15;
	    self.ui_elements["weapon_grenade_secondary_icon"].alignx = "left";
	    self.ui_elements["weapon_grenade_secondary_icon"].aligny = "bottom";
	    self.ui_elements["weapon_grenade_secondary_icon"].horzalign = "fullscreen";
	    self.ui_elements["weapon_grenade_secondary_icon"].vertalign = "fullscreen";
	    self.ui_elements["weapon_grenade_secondary_icon"].alpha = 1;
	    self.ui_elements["weapon_grenade_secondary_icon"].basealpha = 1;
	    self.ui_elements["weapon_grenade_secondary_icon"].sort = 2;
	    self.ui_elements["weapon_grenade_secondary_icon"].archived = true;
	    self.ui_elements["weapon_grenade_secondary_icon"].foreground = true;
	    self.ui_elements["weapon_grenade_secondary_icon"].hidewheninmenu = true;
	    self.ui_elements["weapon_grenade_secondary_icon"].hidewhendead = true;
	    self.ui_elements["weapon_grenade_secondary_icon"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_grenade_grenade_counter"])) {
		self.ui_elements["weapon_grenade_grenade_counter"] = newclienthudelem(self);
		self.ui_elements["weapon_grenade_grenade_counter"].x = x - 23;
		self.ui_elements["weapon_grenade_grenade_counter"].basex = self.ui_elements["weapon_grenade_grenade_counter"].x;
	    self.ui_elements["weapon_grenade_grenade_counter"].y = self.ui_elements["weapon_grenade_grenade_icon"].y - 8;
	    self.ui_elements["weapon_grenade_grenade_counter"].alignx = "left";
	    self.ui_elements["weapon_grenade_grenade_counter"].aligny = "middle";
	    self.ui_elements["weapon_grenade_grenade_counter"].horzalign = "fullscreen";
	    self.ui_elements["weapon_grenade_grenade_counter"].vertalign = "fullscreen";
	    self.ui_elements["weapon_grenade_grenade_counter"].alpha = 1;
	    self.ui_elements["weapon_grenade_grenade_counter"].basealpha = 1;
	    self.ui_elements["weapon_grenade_grenade_counter"].sort = 2;
	    self.ui_elements["weapon_grenade_grenade_counter"].fontscale = .4;
	    self.ui_elements["weapon_grenade_grenade_counter"].font = "hudbig";
	    self.ui_elements["weapon_grenade_grenade_counter"].archived = true;
	    self.ui_elements["weapon_grenade_grenade_counter"].foreground = true;
	    self.ui_elements["weapon_grenade_grenade_counter"].hidewheninmenu = true;
	    self.ui_elements["weapon_grenade_grenade_counter"].hidewhendead = true;
	    self.ui_elements["weapon_grenade_grenade_counter"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_grenade_secondary_counter"])) {
		self.ui_elements["weapon_grenade_secondary_counter"] = newclienthudelem(self);
		self.ui_elements["weapon_grenade_secondary_counter"].x = x - 6;
		self.ui_elements["weapon_grenade_secondary_counter"].basex = self.ui_elements["weapon_grenade_secondary_counter"].x;
	    self.ui_elements["weapon_grenade_secondary_counter"].y = self.ui_elements["weapon_grenade_grenade_icon"].y - 8;
	    self.ui_elements["weapon_grenade_secondary_counter"].alignx = "left";
	    self.ui_elements["weapon_grenade_secondary_counter"].aligny = "middle";
	    self.ui_elements["weapon_grenade_secondary_counter"].horzalign = "fullscreen";
	    self.ui_elements["weapon_grenade_secondary_counter"].vertalign = "fullscreen";
	    self.ui_elements["weapon_grenade_secondary_counter"].alpha = 1;
	    self.ui_elements["weapon_grenade_secondary_counter"].basealpha = 1;
	    self.ui_elements["weapon_grenade_secondary_counter"].sort = 2;
	    self.ui_elements["weapon_grenade_secondary_counter"].fontscale = .4;
	    self.ui_elements["weapon_grenade_secondary_counter"].font = "hudbig";
	    self.ui_elements["weapon_grenade_secondary_counter"].archived = true;
	    self.ui_elements["weapon_grenade_secondary_counter"].foreground = true;
	    self.ui_elements["weapon_grenade_secondary_counter"].hidewheninmenu = true;
	    self.ui_elements["weapon_grenade_secondary_counter"].hidewhendead = true;
	    self.ui_elements["weapon_grenade_secondary_counter"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_attachments"])) {
		self.ui_elements["weapon_attachments"] = newClientHudElem(self);
   		self.ui_elements["weapon_attachments"].x = self.ui_elements["weapon_right_bg_light"].x - 35;
   		self.ui_elements["weapon_attachments"].basex = self.ui_elements["weapon_attachments"].x;
    	self.ui_elements["weapon_attachments"].y = y - 20;
	    self.ui_elements["weapon_attachments"].horzalign = "fullscreen";
	    self.ui_elements["weapon_attachments"].vertalign = "fullscreen";
	    self.ui_elements["weapon_attachments"].alignx = "right";
	    self.ui_elements["weapon_attachments"].aligny = "top";
	    self.ui_elements["weapon_attachments"].color = (1, 1, 1);
	    self.ui_elements["weapon_attachments"].alpha = 1;
	    self.ui_elements["weapon_attachments"].archived = true;
	    self.ui_elements["weapon_attachments"].sort = 1;
	    self.ui_elements["weapon_attachments"].font = "small";
	    self.ui_elements["weapon_attachments"].fontscale = .9;
	    self.ui_elements["weapon_attachments"].hidewheninmenu = 1;
	    self.ui_elements["weapon_attachments"].hidewhendead = true;
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_box_1"])) {
		self.ui_elements["weapon_killstreak_box_1"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_box_1"].x = x;
		self.ui_elements["weapon_killstreak_box_1"].basex = self.ui_elements["weapon_killstreak_box_1"].x;
	    self.ui_elements["weapon_killstreak_box_1"].y = self.ui_elements["weapon_grenade_bg"].y - 30;
	    self.ui_elements["weapon_killstreak_box_1"].alignx = "right";
	    self.ui_elements["weapon_killstreak_box_1"].aligny = "bottom";
	    self.ui_elements["weapon_killstreak_box_1"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_1"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_1"].alpha = base_alpha;
	    self.ui_elements["weapon_killstreak_box_1"].sort = 1;
	    self.ui_elements["weapon_killstreak_box_1"].color = (0, 0, 0);
	    self.ui_elements["weapon_killstreak_box_1"].archived = true;
	    self.ui_elements["weapon_killstreak_box_1"].foreground = true;
	    self.ui_elements["weapon_killstreak_box_1"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_box_1"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_box_1"] setshader("white", box_size, box_size);
	    self.ui_elements["weapon_killstreak_box_1"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_icon_1"])) {
		self.ui_elements["weapon_killstreak_icon_1"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_icon_1"].x = x - 1;
		self.ui_elements["weapon_killstreak_icon_1"].basex = self.ui_elements["weapon_killstreak_icon_1"].x;
	    self.ui_elements["weapon_killstreak_icon_1"].y = self.ui_elements["weapon_killstreak_box_1"].y - (box_size / 2);
	    self.ui_elements["weapon_killstreak_icon_1"].alignx = "right";
	    self.ui_elements["weapon_killstreak_icon_1"].aligny = "middle";
	    self.ui_elements["weapon_killstreak_icon_1"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_1"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_1"].alpha = .5;
	    self.ui_elements["weapon_killstreak_icon_1"].sort = 2;
	    self.ui_elements["weapon_killstreak_icon_1"].icon_size = icon_size;
	    self.ui_elements["weapon_killstreak_icon_1"].archived = true;
	    self.ui_elements["weapon_killstreak_icon_1"].foreground = true;
	    self.ui_elements["weapon_killstreak_icon_1"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_icon_1"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_icon_1"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_box_2"])) {
		self.ui_elements["weapon_killstreak_box_2"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_box_2"].x = x;
		self.ui_elements["weapon_killstreak_box_2"].basex = self.ui_elements["weapon_killstreak_box_2"].x;
	    self.ui_elements["weapon_killstreak_box_2"].y = self.ui_elements["weapon_killstreak_box_1"].y - box_size - 2;
	    self.ui_elements["weapon_killstreak_box_2"].alignx = "right";
	    self.ui_elements["weapon_killstreak_box_2"].aligny = "bottom";
	    self.ui_elements["weapon_killstreak_box_2"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_2"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_2"].alpha = base_alpha;
	    self.ui_elements["weapon_killstreak_box_2"].sort = 1;
	    self.ui_elements["weapon_killstreak_box_2"].color = (0, 0, 0);
	    self.ui_elements["weapon_killstreak_box_2"].archived = true;
	    self.ui_elements["weapon_killstreak_box_2"].foreground = true;
	    self.ui_elements["weapon_killstreak_box_2"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_box_2"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_box_2"] setshader("white", box_size, box_size);
	    self.ui_elements["weapon_killstreak_box_2"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_icon_2"])) {
		self.ui_elements["weapon_killstreak_icon_2"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_icon_2"].x = x - 1;
		self.ui_elements["weapon_killstreak_icon_2"].basex = self.ui_elements["weapon_killstreak_icon_2"].x;
	    self.ui_elements["weapon_killstreak_icon_2"].y = self.ui_elements["weapon_killstreak_box_2"].y - (box_size / 2);
	    self.ui_elements["weapon_killstreak_icon_2"].alignx = "right";
	    self.ui_elements["weapon_killstreak_icon_2"].aligny = "middle";
	    self.ui_elements["weapon_killstreak_icon_2"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_2"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_2"].alpha = .5;
	    self.ui_elements["weapon_killstreak_icon_2"].sort = 2;
	    self.ui_elements["weapon_killstreak_icon_2"].icon_size = icon_size;
	    self.ui_elements["weapon_killstreak_icon_2"].archived = true;
	    self.ui_elements["weapon_killstreak_icon_2"].foreground = true;
	    self.ui_elements["weapon_killstreak_icon_2"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_icon_2"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_icon_2"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_box_3"])) {
		self.ui_elements["weapon_killstreak_box_3"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_box_3"].x = x;
		self.ui_elements["weapon_killstreak_box_3"].basex = self.ui_elements["weapon_killstreak_box_3"].x;
	    self.ui_elements["weapon_killstreak_box_3"].y = self.ui_elements["weapon_killstreak_box_2"].y - box_size - 2;
	    self.ui_elements["weapon_killstreak_box_3"].alignx = "right";
	    self.ui_elements["weapon_killstreak_box_3"].aligny = "bottom";
	    self.ui_elements["weapon_killstreak_box_3"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_3"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_3"].alpha = base_alpha;
	    self.ui_elements["weapon_killstreak_box_3"].sort = 1;
	    self.ui_elements["weapon_killstreak_box_3"].color = (0, 0, 0);
	    self.ui_elements["weapon_killstreak_box_3"].archived = true;
	    self.ui_elements["weapon_killstreak_box_3"].foreground = true;
	    self.ui_elements["weapon_killstreak_box_3"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_box_3"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_box_3"] setshader("white", box_size, box_size);
	    self.ui_elements["weapon_killstreak_box_3"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_icon_3"])) {
		self.ui_elements["weapon_killstreak_icon_3"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_icon_3"].x = x - 1;
		self.ui_elements["weapon_killstreak_icon_3"].basex = self.ui_elements["weapon_killstreak_icon_3"].x;
	    self.ui_elements["weapon_killstreak_icon_3"].y = self.ui_elements["weapon_killstreak_box_3"].y - (box_size / 2);
	    self.ui_elements["weapon_killstreak_icon_3"].alignx = "right";
	    self.ui_elements["weapon_killstreak_icon_3"].aligny = "middle";
	    self.ui_elements["weapon_killstreak_icon_3"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_3"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_3"].alpha = .5;
	    self.ui_elements["weapon_killstreak_icon_3"].sort = 2;
	    self.ui_elements["weapon_killstreak_icon_3"].icon_size = icon_size;
	    self.ui_elements["weapon_killstreak_icon_3"].archived = true;
	    self.ui_elements["weapon_killstreak_icon_3"].foreground = true;
	    self.ui_elements["weapon_killstreak_icon_3"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_icon_3"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_icon_3"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_box_0"])) {
		self.ui_elements["weapon_killstreak_box_0"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_box_0"].x = x;
		self.ui_elements["weapon_killstreak_box_0"].basex = self.ui_elements["weapon_killstreak_box_0"].x;
	    self.ui_elements["weapon_killstreak_box_0"].y = self.ui_elements["weapon_killstreak_box_1"].y + box_size + 2;
	    self.ui_elements["weapon_killstreak_box_0"].alignx = "right";
	    self.ui_elements["weapon_killstreak_box_0"].aligny = "bottom";
	    self.ui_elements["weapon_killstreak_box_0"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_0"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_box_0"].alpha = 0;
	    self.ui_elements["weapon_killstreak_box_0"].sort = 1;
	    self.ui_elements["weapon_killstreak_box_0"].color = (0, 0, 0);
	    self.ui_elements["weapon_killstreak_box_0"].archived = true;
	    self.ui_elements["weapon_killstreak_box_0"].foreground = true;
	    self.ui_elements["weapon_killstreak_box_0"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_box_0"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_box_0"] setshader("white", box_size, box_size);
	    self.ui_elements["weapon_killstreak_box_0"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["weapon_killstreak_icon_0"])) {
		self.ui_elements["weapon_killstreak_icon_0"] = newclienthudelem(self);
		self.ui_elements["weapon_killstreak_icon_0"].x = x - 1;
		self.ui_elements["weapon_killstreak_icon_0"].basex = self.ui_elements["weapon_killstreak_icon_0"].x;
	    self.ui_elements["weapon_killstreak_icon_0"].y = self.ui_elements["weapon_killstreak_box_0"].y - (box_size / 2);
	    self.ui_elements["weapon_killstreak_icon_0"].alignx = "right";
	    self.ui_elements["weapon_killstreak_icon_0"].aligny = "middle";
	    self.ui_elements["weapon_killstreak_icon_0"].horzalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_0"].vertalign = "fullscreen";
	    self.ui_elements["weapon_killstreak_icon_0"].alpha = 0;
	    self.ui_elements["weapon_killstreak_icon_0"].sort = 2;
	    self.ui_elements["weapon_killstreak_icon_0"].icon_size = icon_size;
	    self.ui_elements["weapon_killstreak_icon_0"].archived = true;
	    self.ui_elements["weapon_killstreak_icon_0"].foreground = true;
	    self.ui_elements["weapon_killstreak_icon_0"].hidewheninmenu = true;
	    self.ui_elements["weapon_killstreak_icon_0"].hidewhendead = true;
	    self.ui_elements["weapon_killstreak_icon_0"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["killstreak_scroller"])) {
		self.ui_elements["killstreak_scroller"] = newclienthudelem(self);
		self.ui_elements["killstreak_scroller"].x = x - 19;
	    self.ui_elements["killstreak_scroller"].alignx = "right";
	    self.ui_elements["killstreak_scroller"].aligny = "middle";
	    self.ui_elements["killstreak_scroller"].horzalign = "fullscreen";
	    self.ui_elements["killstreak_scroller"].vertalign = "fullscreen";
	    self.ui_elements["killstreak_scroller"].alpha = 0;
	    self.ui_elements["killstreak_scroller"].sort = 1;
	    self.ui_elements["killstreak_scroller"].color = (1, 1, 1);
	    self.ui_elements["killstreak_scroller"].archived = true;
	    self.ui_elements["killstreak_scroller"].foreground = true;
	    self.ui_elements["killstreak_scroller"].hidewheninmenu = true;
	    self.ui_elements["killstreak_scroller"].hidewhendead = true;
	    //self.ui_elements["killstreak_scroller"] setshader("ui_arrow_right", 12, 12);
	    self.ui_elements["killstreak_scroller"] thread destroy_on_notify( "end_game" );
	}
	
	if(!isdefined(self.ui_elements["hitmarker"])) {
		self.ui_elements["hitmarker"] = newclienthudelem(self);
    	self.ui_elements["hitmarker"].horzalign = "center";
        self.ui_elements["hitmarker"].vertalign = "middle";
        self.ui_elements["hitmarker"].x = -12;
        self.ui_elements["hitmarker"].y = -12;
    	self.ui_elements["hitmarker"].alpha = 0;
    	self.ui_elements["hitmarker"].foreground = true;
    	self.ui_elements["hitmarker"].hidewheninmenu = true;
    	self.ui_elements["hitmarker"].archived = false;
    	self.ui_elements["hitmarker"] setshader("damage_feedback", 24, 48);
	}
	
	while(1) {
		if(isalive(self)) {
			current_gun = self getcurrentweapon();
			
			self.ui_elements["weapon_clip_count"] setvalue(self getweaponammoclip(current_gun));
			self.ui_elements["weapon_stock_count"] setvalue(self getweaponammostock(current_gun));
			
			if(isdefined(self.grenade_hud)) {
				if(isdefined(self.grenade_hud.grenade_name))
					self.ui_elements["weapon_grenade_grenade_counter"] setvalue(self getammocount(self.grenade_hud.grenade_name));
			
				if(isdefined(self.grenade_hud.secondary_name))
					self.ui_elements["weapon_grenade_secondary_counter"] setvalue(self getammocount(self.grenade_hud.secondary_name));
			}
			
			if(isdefined(self.killstreakindexweapon)) {
				if(isdefined(self.ui_elements["weapon_killstreak_icon_" + self.killstreakindexweapon])) {
					self.ui_elements["killstreak_scroller"].y = self.ui_elements["weapon_killstreak_icon_" + self.killstreakindexweapon].y;
					self.ui_elements["killstreak_scroller"].alpha = 1;
				}
			}
			else {
				if(self.ui_elements["killstreak_scroller"].alpha == 1)
					self.ui_elements["killstreak_scroller"].alpha = 0;
			}
		}
		
		wait .05;
	}
}

watch_weapon_change(player) {
	player endon("disconnect");
	
	while(isdefined(self)) {
		player waittill("weapon_change", gun);
		
		gun = player get_weapon_name_conv(getbaseweaponname(gun));
		
		if(gun != "none") {
			if(isdefined(player.ui_elements["weapon_name"].basealpha)) {
				if(player.ui_elements["weapon_name"].alpha != player.ui_elements["weapon_name"].basealpha) {
					player.ui_elements["weapon_name"].alpha = player.ui_elements["weapon_name"].basealpha;
					player.ui_elements["weapon_stock_count"].alpha = player.ui_elements["weapon_stock_count"].basealpha;
					player.ui_elements["weapon_clip_count"].alpha = player.ui_elements["weapon_clip_count"].basealpha;
					player.ui_elements["weapon_name_bg"].alpha = player.ui_elements["weapon_name_bg"].basealpha;
					player.ui_elements["weapon_right_bg_light"].alpha = player.ui_elements["weapon_right_bg_light"].basealpha;
					player.ui_elements["weapon_right_bg"].alpha = player.ui_elements["weapon_right_bg"].basealpha;
					player.ui_elements["weapon_attachments"].alpha = 1;
					player.ui_elements["weapon_shader"].alpha = 1;
				}
			}
			
			self settext(player get_weapon_name_conv(getbaseweaponname(player getcurrentweapon())));
			self.x -= 5;
			self moveovertime(.1);
			self.x += 5;
			
			array = getWeaponAttachments(player getcurrentweapon());
       	
       		output = "";
       		
       		player.ui_elements["weapon_attachments"].alpha = 0;
       		if(array.size >= 1) {
       			player.ui_elements["weapon_attachments"].alpha = 1;
       			
       			for(i = 0;i < array.size;i++)
       				arr = get_attachments_conv(array[i]);
       				output += arr + " ";
       		}
       	
       		player.ui_elements["weapon_attachments"] settext("^3" + output);
       		player.ui_elements["weapon_attachments"].x -= 5;
			player.ui_elements["weapon_attachments"] moveovertime(.1);
			player.ui_elements["weapon_attachments"].x += 5;
			
       		player thread attachments_fade(3);
			
			wait .1;
		}
		else {
			player.ui_elements["weapon_name"].alpha = 0;
			player.ui_elements["weapon_stock_count"].alpha = 0;
			player.ui_elements["weapon_clip_count"].alpha = 0;
			player.ui_elements["weapon_name_bg"].alpha = 0;
			player.ui_elements["weapon_right_bg_light"].alpha = 0;
			player.ui_elements["weapon_right_bg"].alpha = 0;
			player.ui_elements["weapon_attachments"].alpha = 0;
			player.ui_elements["weapon_shader"].alpha = 0;
		}
	}
}

attachments_fade(time) {
	self endon("disconnect");
	self endon("weapon_change");
	
	wait time;
	
	self.ui_elements["weapon_attachments"] fadeovertime(.5);
	self.ui_elements["weapon_attachments"].alpha = 0;
}

create_health_bar() {
    level endon("end_game");
    self endon("disconnect");
	
	color 		= (1, 1, 1);
    x 			= 10;
    y 			= 460;
    base_width 	= 70;
    base_height = 4;
    
    self.special_health_color = 0;
    
    if(!isdefined(self.ui_healthbar))
    	self.ui_healthbar = [];

	if(!isdefined(self.ui_healthbar["healthbar"])) {
	    self.ui_healthbar["healthbar"] = newClientHudElem(self);
	    self.ui_healthbar["healthbar"].x = x;
	    self.ui_healthbar["healthbar"].y = y;
	    self.ui_healthbar["healthbar"].alignx = "left";
	    self.ui_healthbar["healthbar"].aligny = "middle";
	    self.ui_healthbar["healthbar"].horzalign = "fullscreen";
	    self.ui_healthbar["healthbar"].vertalign = "fullscreen";
	    self.ui_healthbar["healthbar"].alpha = 1;
	    self.ui_healthbar["healthbar"].basealpha = 1;
	    self.ui_healthbar["healthbar"].sort = 1;
	    self.ui_healthbar["healthbar"].archived = true;
	    self.ui_healthbar["healthbar"].foreground = true;
	    self.ui_healthbar["healthbar"].hidewheninmenu = true;
	    self.ui_healthbar["healthbar"].hidewhendead = true;
	    self.ui_healthbar["healthbar"] setshader("white", base_width, base_height);
	    self.ui_healthbar["healthbar"] thread destroy_on_notify( "end_game" );
	}
    
    if(!isdefined(self.ui_healthbar["frame"])) {
	    self.ui_healthbar["frame"] = newClientHudElem(self);
	    self.ui_healthbar["frame"].x = x;
	    self.ui_healthbar["frame"].y = y;
	    self.ui_healthbar["frame"].alignx = "left";
	    self.ui_healthbar["frame"].aligny = "middle";
	    self.ui_healthbar["frame"].horzalign = "fullscreen";
	    self.ui_healthbar["frame"].vertalign = "fullscreen";
	    self.ui_healthbar["frame"].alpha = .75;
	    self.ui_healthbar["frame"].basealpha = .75;
	    self.ui_healthbar["frame"].sort = -1;
	    self.ui_healthbar["frame"].color = (0, 0, 0);
	    self.ui_healthbar["frame"].archived = true;
	    self.ui_healthbar["frame"].foreground = true;
	    self.ui_healthbar["frame"].hidewheninmenu = true;
	    self.ui_healthbar["frame"].hidewhendead = true;
	    self.ui_healthbar["frame"] setshader("white", base_width, base_height);
	    self.ui_healthbar["frame"] thread destroy_on_notify( "end_game" );
	}
    
    if(!isdefined(self.ui_healthbar["name"])) {
	    self.ui_healthbar["name"] = newclienthudelem(self);
	    self.ui_healthbar["name"].x = x;
	    self.ui_healthbar["name"].y = y - 7;
	    self.ui_healthbar["name"].alignx = "left";
	    self.ui_healthbar["name"].aligny = "bottom";
	    self.ui_healthbar["name"].horzalign = "fullscreen";
	    self.ui_healthbar["name"].vertalign = "fullscreen";
	    self.ui_healthbar["name"].alpha = 1;
	    self.ui_healthbar["name"].color = (1, 1, 1);
	    self.ui_healthbar["name"].archived = true;
	    self.ui_healthbar["name"].sort = 10;
	    self.ui_healthbar["name"].fontscale = .9;
	    self.ui_healthbar["name"].font = "small";
	    self.ui_healthbar["name"].foreground = true;
	    self.ui_healthbar["name"].hidewheninmenu = true;
	    self.ui_healthbar["name"].hidewhendead = true;
	    self.ui_healthbar["name"] settext(self.name);
	    self.ui_healthbar["name"] thread destroy_on_notify( "end_game" );
	}
        
    self thread LowHealthPulse();

    old_width 		= 0;
    downed			= 0;
    low_health		= 0;

    while (1) {
        if(self.sessionstate == "playing") {
      	    low_health = self.health < 50;
       		
        	width = (self.health / self.maxhealth) * base_width * (250 / 250);
        	width = int(max(width, 1));
        	
        	if(width > base_width)
        		width = base_width;
			
			self.ui_healthbar["healthbar"] setShader("progress_bar_fill", width, base_height);

			if(isdefined(self.special_health_color) && self.special_health_color == 0)
				self.ui_healthbar["healthbar"].color = color;
      	}
      	else
      		wait .1;
      	
		wait .05;
    }
}

LowHealthPulse() {
	self endon("disconnect");
	level endon("end_game");
	
	pulse_time = .3;
	
	while(1) {
		wait .05;
			
		if(isalive(self)) {
			if(self.health < 50) {
				if(self.special_health_color == 0)
					self.special_health_color = 1;
			
				self.ui_healthbar["healthbar"] fadeovertime(pulse_time);
				self.ui_healthbar["healthbar"].color = (1,0,0);
				wait pulse_time;
				self.ui_healthbar["healthbar"] fadeovertime(pulse_time);
				self.ui_healthbar["healthbar"].color = (.31, 0, 0);
				wait pulse_time;
			}
			else {
				if(self.special_health_color == 1)
					self.special_health_color = 0;
			}
		}
	}
}

create_mantle_ui() {
	self endon("disconnect");
	
	if(!isdefined(self.ui_elements["hud_mantle"])) {
		self.ui_elements["hud_mantle"] = newclienthudelem(self);
	    self.ui_elements["hud_mantle"].x = 320;
	    self.ui_elements["hud_mantle"].y = 400;
	    self.ui_elements["hud_mantle"].alignx = "center";
	    self.ui_elements["hud_mantle"].aligny = "middle";
	    self.ui_elements["hud_mantle"].horzalign = "fullscreen";
	    self.ui_elements["hud_mantle"].vertalign = "fullscreen";
	    self.ui_elements["hud_mantle"].alpha = 0;
	    self.ui_elements["hud_mantle"].sort = 1;
	    self.ui_elements["hud_mantle"].color = (1, 1, 1);
	    self.ui_elements["hud_mantle"].archived = false;
	    self.ui_elements["hud_mantle"].font = "small";
	    self.ui_elements["hud_mantle"].fontscale = 1.25;
	    self.ui_elements["hud_mantle"] settext("Press ^3[{+gostand}]^7 to Mantle");
	    self.ui_elements["hud_mantle"].hidewheninmenu = true;
	}
	
	if(!isdefined(self.ui_elements["hud_mantle_bg"])) {
		self.ui_elements["hud_mantle_bg"] = newclienthudelem(self);
	    self.ui_elements["hud_mantle_bg"].x = 320;
	    self.ui_elements["hud_mantle_bg"].y = 401;
	    self.ui_elements["hud_mantle_bg"].alignx = "center";
	    self.ui_elements["hud_mantle_bg"].aligny = "middle";
	    self.ui_elements["hud_mantle_bg"].horzalign = "fullscreen";
	    self.ui_elements["hud_mantle_bg"].vertalign = "fullscreen";
	    self.ui_elements["hud_mantle_bg"].alpha = 0;
	    self.ui_elements["hud_mantle_bg"].sort = 0;
	    self.ui_elements["hud_mantle_bg"].color = (0, 0, 0);
	    self.ui_elements["hud_mantle_bg"].archived = false;
	    self.ui_elements["hud_mantle_bg"] setshader("line_horizontal", 170, 16);
	    self.ui_elements["hud_mantle_bg"].hidewheninmenu = true;
	}
	
	while(1) {
		if(isdefined(self.ui_elements["hud_mantle_bg"])) {
			if(self canmantle()) {
				if(self.ui_elements["hud_mantle"].alpha != 1) {
					self.ui_elements["hud_mantle"].alpha = 1;
					self.ui_elements["hud_mantle_bg"].alpha = 1;
				}
			}
			else {
				if(self.ui_elements["hud_mantle"].alpha == 1) {
					self.ui_elements["hud_mantle"].alpha = 0;
					self.ui_elements["hud_mantle_bg"].alpha = 0;
				}
			}
		}
		
		wait .05;
	}
}

ui_create_player() {
	self endon("disconnect");
	self waittill("spawned_player");
	
	flag_wait("hud_visible");
	
	self thread create_health_bar();
	self thread create_weapon_ui();
	self thread create_mantle_ui();
	self thread ui_score_create();
	
	if(!isdefined(self.ui_elements))
		self.ui_elements = [];
		
	if(!isdefined(self.ui_elements["score_teamicon"])) {
		self.ui_elements["score_teamicon"] = newclienthudelem(self);
	    self.ui_elements["score_teamicon"].x = 320;
	    self.ui_elements["score_teamicon"].y = level.ui_score_y;
	    self.ui_elements["score_teamicon"].alignx = "center";
	    self.ui_elements["score_teamicon"].aligny = "middle";
	    self.ui_elements["score_teamicon"].horzalign = "fullscreen";
	    self.ui_elements["score_teamicon"].vertalign = "fullscreen";
	    self.ui_elements["score_teamicon"].alpha = .5;
	    self.ui_elements["score_teamicon"].sort = 0;
	    self.ui_elements["score_teamicon"].color = (1, 1, 1);
	    self.ui_elements["score_teamicon"].archived = false;
	    //self.ui_elements["score_teamicon"] setshader(getdvar("g_teamicon_" + self.team), 20, 20);
	    self.ui_elements["score_teamicon"].hidewheninmenu = true;
	}
	
	if(!isdefined(self.ui_elements["score_team_situation"])) {
		self.ui_elements["score_team_situation"] = newclienthudelem(self);
	    self.ui_elements["score_team_situation"].x = 320;
	    self.ui_elements["score_team_situation"].y = level.ui_score_y + 15;
	    self.ui_elements["score_team_situation"].alignx = "center";
	    self.ui_elements["score_team_situation"].aligny = "middle";
	    self.ui_elements["score_team_situation"].horzalign = "fullscreen";
	    self.ui_elements["score_team_situation"].vertalign = "fullscreen";
	    self.ui_elements["score_team_situation"].alpha = 1;
	    self.ui_elements["score_team_situation"].sort = 0;
	    self.ui_elements["score_team_situation"].fontscale = .85;
	    self.ui_elements["score_team_situation"].archived = false;
	    self.ui_elements["score_team_situation"].hidewheninmenu = true;
	}
	
	team_situation = 0;
	highest = 0;
	
	while(1) {
		wait .05;
		
		if(self.team == "allies")
			enemyteam = "axis";
		else
			enemyteam = "allies";
			
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].guid != self.guid && level.players[i].score > highest)
				highest = level.players[i].score;
		}
		
		if(isdefined(self.ui_elements["score_team_situation"])) {
			if(self.score > highest && team_situation != 1) {
				self.ui_elements["score_team_situation"] settext("^4Winning");
				team_situation = 1;
			}
			else if(self.score < highest && team_situation != 2) {
				self.ui_elements["score_team_situation"] settext("^8Losing");
				team_situation = 2;
			}
			else if(self.score == highest && team_situation != 3) {
				self.ui_elements["score_team_situation"] settext("^3Tied");
				team_situation = 3;
			}
		}
	}
}

ui_score_create() {
	self endon("disconnect");
	flag_wait("hud_visible");
   	
   	if(!isdefined(self.ui_elements["ui_timer"])) {
	    self.ui_elements["ui_timer"] = newclienthudelem(self);
	    self.ui_elements["ui_timer"].x = 320;
	    self.ui_elements["ui_timer"].y = level.ui_score_y;
	    self.ui_elements["ui_timer"].alignx = "center";
	    self.ui_elements["ui_timer"].aligny = "middle";
	    self.ui_elements["ui_timer"].horzalign = "fullscreen";
	    self.ui_elements["ui_timer"].vertalign = "fullscreen";
	    self.ui_elements["ui_timer"].alpha = 1;
	    self.ui_elements["ui_timer"].sort = 1;
	    self.ui_elements["ui_timer"].color = (1,1,1);
	    self.ui_elements["ui_timer"].archived = false;
	    self.ui_elements["ui_timer"].fontscale = .7;
	    self.ui_elements["ui_timer"].font = "hudsmall";
		self.ui_elements["ui_timer"] settimer((getdvarint("ui_timelimit") * 60));
		self.ui_elements["ui_timer"].hidewheninmenu = true;
	}
	
	if(!isdefined(self.ui_elements["allies_box"])) {
		self.ui_elements["allies_box"] = newclienthudelem(self);
	    self.ui_elements["allies_box"].x = 295;
	    self.ui_elements["allies_box"].y = level.ui_score_y;
	    self.ui_elements["allies_box"].alignx = "center";
	    self.ui_elements["allies_box"].aligny = "middle";
	    self.ui_elements["allies_box"].horzalign = "fullscreen";
	    self.ui_elements["allies_box"].vertalign = "fullscreen";
	    self.ui_elements["allies_box"].alpha = 1;
	    self.ui_elements["allies_box"].sort = 0;
	    self.ui_elements["allies_box"].color = level.ui_color.blue;
	    self.ui_elements["allies_box"].archived = false;
	    self.ui_elements["allies_box"] setshader("white", 14, 14);
	    self.ui_elements["allies_box"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["axis_box"])) {
	    self.ui_elements["axis_box"] = newclienthudelem(self);
	    self.ui_elements["axis_box"].x = 345;
	    self.ui_elements["axis_box"].y = level.ui_score_y;
	    self.ui_elements["axis_box"].alignx = "center";
	    self.ui_elements["axis_box"].aligny = "middle";
	    self.ui_elements["axis_box"].horzalign = "fullscreen";
	    self.ui_elements["axis_box"].vertalign = "fullscreen";
	    self.ui_elements["axis_box"].alpha = 1;
	    self.ui_elements["axis_box"].sort = 0;
	    self.ui_elements["axis_box"].color = level.ui_color.red;
	    self.ui_elements["axis_box"].archived = false;
	    self.ui_elements["axis_box"] setshader("white", 14, 14);
	    self.ui_elements["axis_box"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["allies_score"])) {
	    self.ui_elements["allies_score"] = newclienthudelem(self);
	    self.ui_elements["allies_score"].x = 295;
	    self.ui_elements["allies_score"].y = level.ui_score_y;
	    self.ui_elements["allies_score"].alignx = "center";
	    self.ui_elements["allies_score"].aligny = "middle";
	    self.ui_elements["allies_score"].horzalign = "fullscreen";
	    self.ui_elements["allies_score"].vertalign = "fullscreen";
	    self.ui_elements["allies_score"].alpha = 1;
	    self.ui_elements["allies_score"].sort = 1;
	    self.ui_elements["allies_score"].color = (1,1,1);
	    self.ui_elements["allies_score"].font = "hudsmall";
	    self.ui_elements["allies_score"].archived = false;
	    self.ui_elements["allies_score"].fontscale = .48;
	    self.ui_elements["allies_score"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["axis_score"])) {
	    self.ui_elements["axis_score"] = newclienthudelem(self);
	    self.ui_elements["axis_score"].x = 345;
	    self.ui_elements["axis_score"].y = level.ui_score_y;
	    self.ui_elements["axis_score"].alignx = "center";
	    self.ui_elements["axis_score"].aligny = "middle";
	    self.ui_elements["axis_score"].horzalign = "fullscreen";
	    self.ui_elements["axis_score"].vertalign = "fullscreen";
	    self.ui_elements["axis_score"].alpha = 1;
	    self.ui_elements["axis_score"].sort = 1;
	    self.ui_elements["axis_score"].color = (1,1,1);
	    self.ui_elements["axis_score"].archived = false;
	    self.ui_elements["axis_score"].font = "hudsmall";
	    self.ui_elements["axis_score"].fontscale = .48;
		self.ui_elements["axis_score"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["axis_bar_bg"])) {
	    self.ui_elements["axis_bar_bg"] = newclienthudelem(self);
	    self.ui_elements["axis_bar_bg"].x = 355;
	    self.ui_elements["axis_bar_bg"].y = level.ui_score_y;
	    self.ui_elements["axis_bar_bg"].alignx = "left";
	    self.ui_elements["axis_bar_bg"].aligny = "middle";
	    self.ui_elements["axis_bar_bg"].horzalign = "fullscreen";
	    self.ui_elements["axis_bar_bg"].vertalign = "fullscreen";
	    self.ui_elements["axis_bar_bg"].alpha = .5;
	    self.ui_elements["axis_bar_bg"].sort = 1;
	    self.ui_elements["axis_bar_bg"].color = (0,0,0);
	    self.ui_elements["axis_bar_bg"].archived = false;
	    self.ui_elements["axis_bar_bg"] setshader("black", 60, 5);
	    self.ui_elements["axis_bar_bg"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["axis_bar"])) {
	    self.ui_elements["axis_bar"] = newclienthudelem(self);
	    self.ui_elements["axis_bar"].x = self.ui_elements["axis_bar_bg"].x;
	    self.ui_elements["axis_bar"].y = level.ui_score_y;
	    self.ui_elements["axis_bar"].alignx = "left";
	    self.ui_elements["axis_bar"].aligny = "middle";
	    self.ui_elements["axis_bar"].horzalign = "fullscreen";
	    self.ui_elements["axis_bar"].vertalign = "fullscreen";
	    self.ui_elements["axis_bar"].alpha = 1;
	    self.ui_elements["axis_bar"].sort = 2;
	    self.ui_elements["axis_bar"].color = level.ui_color.red;
	    self.ui_elements["axis_bar"].archived = false;
	    self.ui_elements["axis_bar"] setshader("progress_bar_fill", 0, 5);
	    self.ui_elements["axis_bar"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["allies_bar_bg"])) {
	    self.ui_elements["allies_bar_bg"] = newclienthudelem(self);
	    self.ui_elements["allies_bar_bg"].x = 285;
	    self.ui_elements["allies_bar_bg"].y = level.ui_score_y;
	    self.ui_elements["allies_bar_bg"].alignx = "right";
	    self.ui_elements["allies_bar_bg"].aligny = "middle";
	    self.ui_elements["allies_bar_bg"].horzalign = "fullscreen";
	    self.ui_elements["allies_bar_bg"].vertalign = "fullscreen";
	    self.ui_elements["allies_bar_bg"].alpha = .5;
	    self.ui_elements["allies_bar_bg"].sort = 0;
	    self.ui_elements["allies_bar_bg"].color = (0,0,0);
	    self.ui_elements["allies_bar_bg"].archived = false;
	    self.ui_elements["allies_bar_bg"] setshader("black", 60, 5);
	    self.ui_elements["allies_bar_bg"].hidewheninmenu = true;
	}
    
    if(!isdefined(self.ui_elements["allies_bar"])) {
	    self.ui_elements["allies_bar"] = newclienthudelem(self);
	    self.ui_elements["allies_bar"].x = self.ui_elements["allies_bar_bg"].x;
	    self.ui_elements["allies_bar"].y = level.ui_score_y;
	    self.ui_elements["allies_bar"].alignx = "right";
	    self.ui_elements["allies_bar"].aligny = "middle";
	    self.ui_elements["allies_bar"].horzalign = "fullscreen";
	    self.ui_elements["allies_bar"].vertalign = "fullscreen";
	    self.ui_elements["allies_bar"].alpha = 1;
	    self.ui_elements["allies_bar"].sort = 2;
	    self.ui_elements["allies_bar"].color = level.ui_color.blue;
	    self.ui_elements["allies_bar"].archived = false;
	    self.ui_elements["allies_bar"] setshader("progress_bar_fill", 0, 5);
	    self.ui_elements["allies_bar"].hidewheninmenu = true;
	}
    
    allieswidth = 0;
    axiswidth = 0;
    alliesoldwidth = 0;
    axisoldwidth = 0;
    highest = 0;
	
    while(1) {
    	scorelimit = getdvarint("ui_scorelimit");
    	if(scorelimit == 0)
    		scorelimit = level.players.size;
    	
		allieswidth = self.score * 59 / scorelimit;
		
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].guid != self.guid && level.players[i].score > highest)
				highest = level.players[i].score;
		}
		
		axiswidth = highest * 59 / scorelimit;
		
		if(isdefined(self.ui_elements["allies_bar"]) && isdefined(allieswidth) && allieswidth != alliesoldwidth)
			self.ui_elements["allies_bar"] scaleovertime(.1, int(allieswidth), 5);
		if(isdefined(self.ui_elements["axis_bar"]) && isdefined(axiswidth) && axiswidth != axisoldwidth)
			self.ui_elements["axis_bar"] scaleovertime(.1, int(axiswidth), 5);
		
		if(isdefined(self.ui_elements["allies_score"]))
			self.ui_elements["allies_score"] setvalue(self.score);
		if(isdefined(self.ui_elements["axis_score"]))
			self.ui_elements["axis_score"] setvalue(highest);
		
		alliesoldwidth = allieswidth;
		axisoldwidth = axiswidth;
		
		wait .1;
    }
}

destroy_on_notify(notifyname) {
	level waittill(notifyname);
	
	if(isdefined(self))
		self destroy();
}

get_weapon_name_conv(weapon) {
	weaponname = "";
	
	if(isdefined(level.hud_weapons[weapon])) {
    	self.ui_elements["weapon_shader"].alpha = 1;
    	self.ui_elements["weapon_shader"] setshader(level.hud_weapons[weapon].icon, 52, 28);
    	
    	if(isdefined(level.hud_weapons[weapon].string))
    		weaponname = level.hud_weapons[weapon].string;
    }
    else
    	self.ui_elements["weapon_shader"].alpha = 0;
    
    return weaponname;
}

get_attachments_conv(attachment) {
	attachmentname = "";
	
	switch(attachment) {
		case "acog":
		case "acogsmg":
			attachmentname = "ACOG SCOPE";
			break;
		case "akimbo":
			attachmentname = "AKIMBO";
			break;
		case "eotech":
		case "eotechsmg":
		case "eotechlmg":
			attachmentname = "HOLOGRAPHIC SIGHT";
			break;
		case "grip":
			attachmentname = "GRIP";
			break;
		case "heartbeat":
			attachmentname = "HEARTBEAT SENSOR";
			break;
		case "hybrid":
			attachmentname = "HYBRID SIGHT";
		case "hamrhybrid":
			attachmentname = "HAMR SCOPE";
			break;
		case "reflex":
		case "reflexsmg":
		case "reflexlmg":
			attachmentname = "RED DOT SIGHT";
			break;
		case "rof":
			attachmentname = "RAPID FIRE";
			break;
		case "shotgun":
			attachmentname = "SHOTGUN";
			break;
		case "silencer":
		case "silencer01":
		case "silencer02":
		case "silencer03":
			attachmentname = "SILENCER";
			break;
		case "thermal":
		case "thermalsmg":
			attachmentname = "THERMAL";
			break;
		case "vzscope":
			attachmentname = "VARIABLE ZOOM SCOPE";
			break;
		case "xmags":
			attachmentname = "EXTENDED MAGAZIN";
			break;
		case "fmj":
			attachmentname = "FMJ";
			break;
		case "tactical":
			attachmentname = "TACTICAL KNIFE";
			break;
	}
	
	return attachmentname;
} 

getWeaponAttachments( weapon )  {
	tokenizedWeapon = strTok( weapon, "_" );
	attachmentArray = [];
	
	foreach( token in tokenizedWeapon ) {
		if ( isSubStr( token, "scopevz" ) )
			attachmentArray[ attachmentArray.size ] = "vzscope";
		
		if( maps\mp\gametypes\_class::isValidAttachment( token, false ) )
			attachmentArray[ attachmentArray.size ] = token;
	}
	return attachmentArray;
}

initkillstreakdata_edit() {
    var_0 = 1;

    for (;;) {
        var_1 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 1 );

        if ( !isdefined( var_1 ) || var_1 == "" )
            break;

        var_2 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 1 );
        var_3 = tablelookupistring( "mp/killstreakTable.csv", 0, var_0, 6 );
        precachestring( var_3 );
        var_4 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 8 );
        game["dialog"][var_2] = var_4;
        var_5 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 9 );
        game["dialog"]["allies_friendly_" + var_2 + "_inbound"] = "use_" + var_5;
        game["dialog"]["allies_enemy_" + var_2 + "_inbound"] = "enemy_" + var_5;
        var_6 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 10 );
        game["dialog"]["axis_friendly_" + var_2 + "_inbound"] = "use_" + var_6;
        game["dialog"]["axis_enemy_" + var_2 + "_inbound"] = "enemy_" + var_6;
        var_7 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 12 );
        precacheitem( var_7 );
        var_8 = int( tablelookup( "mp/killstreakTable.csv", 0, var_0, 13 ) );
        maps\mp\gametypes\_rank::registerscoreinfo( "killstreak_" + var_2, var_8 );
        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 14 );
        precacheshader( var_9 );
        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 15 );

        if ( var_9 != "" )
            precacheshader( var_9 );

        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 16 );

        if ( var_9 != "" )
            precacheshader( var_9 );

        var_9 = tablelookup( "mp/killstreakTable.csv", 0, var_0, 17 );

        var_0++;
    }
}

killstreaks_init_edit() {
    precachestring( &"MP_KILLSTREAK_N" );
    precachestring( &"MP_NUKE_ALREADY_INBOUND" );
    precachestring( &"MP_UNAVILABLE_IN_LASTSTAND" );
    precachestring( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP" );
    precachestring( &"MP_UNAVAILABLE_FOR_N_WHEN_NUKE" );
    precachestring( &"MP_UNAVAILABLE_USING_TURRET" );
    precachestring( &"MP_UNAVAILABLE_WHEN_INCAP" );
    precachestring( &"MP_HELI_IN_QUEUE" );
    precachestring( &"MP_SPECIALIST_STREAKING_XP" );
    precachestring( &"MP_AIR_SPACE_TOO_CROWDED" );
    precachestring( &"MP_CIVILIAN_AIR_TRAFFIC" );
    precachestring( &"MP_TOO_MANY_VEHICLES" );
    precachestring( &"SPLASHES_HEADSHOT" );
    precachestring( &"SPLASHES_FIRSTBLOOD" );
    precachestring( &"MP_ASSIST" );
    precachestring( &"MP_ASSIST_TO_KILL" );
    initkillstreakdata_edit();
    level.killstreakfuncs = [];
    level.killstreaksetupfuncs = [];
    level.killstreakweapons = [];
    thread maps\mp\killstreaks\_ac130::init();
    thread maps\mp\killstreaks\_remotemissile::init();
    thread maps\mp\killstreaks\_uav::init();
    thread maps\mp\killstreaks\_airstrike::init();
    thread maps\mp\killstreaks\_airdrop::init();
    thread maps\mp\killstreaks\_helicopter::init();
    thread maps\mp\killstreaks\_helicopter_flock::init();
    thread maps\mp\killstreaks\_helicopter_guard::init();
    thread maps\mp\killstreaks\_autosentry::init();
    thread maps\mp\killstreaks\_emp::init();
    thread maps\mp\killstreaks\_nuke::init();
    thread maps\mp\killstreaks\_escortairdrop::init();
    thread maps\mp\killstreaks\_remotemortar::init();
    thread maps\mp\killstreaks\_deployablebox::init();
    thread maps\mp\killstreaks\_ims::init();
    thread maps\mp\killstreaks\_perkstreaks::init();
    thread maps\mp\killstreaks\_remoteturret::init();
    thread maps\mp\killstreaks\_remoteuav::init();
    thread maps\mp\killstreaks\_remotetank::init();
    thread maps\mp\killstreaks\_juggernaut::init();
    level.killstreakweildweapons = [];
    level.killstreakweildweapons["cobra_player_minigun_mp"] = 1;
    level.killstreakweildweapons["artillery_mp"] = 1;
    level.killstreakweildweapons["stealth_bomb_mp"] = 1;
    level.killstreakweildweapons["pavelow_minigun_mp"] = 1;
    level.killstreakweildweapons["sentry_minigun_mp"] = 1;
    level.killstreakweildweapons["harrier_20mm_mp"] = 1;
    level.killstreakweildweapons["ac130_105mm_mp"] = 1;
    level.killstreakweildweapons["ac130_40mm_mp"] = 1;
    level.killstreakweildweapons["ac130_25mm_mp"] = 1;
    level.killstreakweildweapons["remotemissile_projectile_mp"] = 1;
    level.killstreakweildweapons["cobra_20mm_mp"] = 1;
    level.killstreakweildweapons["nuke_mp"] = 1;
    level.killstreakweildweapons["apache_minigun_mp"] = 1;
    level.killstreakweildweapons["littlebird_guard_minigun_mp"] = 1;
    level.killstreakweildweapons["uav_strike_marker_mp"] = 1;
    level.killstreakweildweapons["osprey_minigun_mp"] = 1;
    level.killstreakweildweapons["strike_marker_mp"] = 1;
    level.killstreakweildweapons["a10_30mm_mp"] = 1;
    level.killstreakweildweapons["manned_minigun_turret_mp"] = 1;
    level.killstreakweildweapons["manned_gl_turret_mp"] = 1;
    level.killstreakweildweapons["airdrop_trap_explosive_mp"] = 1;
    level.killstreakweildweapons["uav_strike_projectile_mp"] = 1;
    level.killstreakweildweapons["remote_mortar_missile_mp"] = 1;
    level.killstreakweildweapons["manned_littlebird_sniper_mp"] = 1;
    level.killstreakweildweapons["iw5_m60jugg_mp"] = 1;
    level.killstreakweildweapons["iw5_mp412jugg_mp"] = 1;
    level.killstreakweildweapons["iw5_riotshieldjugg_mp"] = 1;
    level.killstreakweildweapons["iw5_usp45jugg_mp"] = 1;
    level.killstreakweildweapons["remote_turret_mp"] = 1;
    level.killstreakweildweapons["osprey_player_minigun_mp"] = 1;
    level.killstreakweildweapons["deployable_vest_marker_mp"] = 1;
    level.killstreakweildweapons["ugv_turret_mp"] = 1;
    level.killstreakweildweapons["ugv_gl_turret_mp"] = 1;
    level.killstreakweildweapons["uav_remote_mp"] = 1;
    level.killstreakchainingweapons = [];
    level.killstreakchainingweapons["remotemissile_projectile_mp"] = "predator_missile";
    level.killstreakchainingweapons["ims_projectile_mp"] = "ims";
    level.killstreakchainingweapons["sentry_minigun_mp"] = "airdrop_sentry_minigun";
    level.killstreakchainingweapons["artillery_mp"] = "precision_airstrike";
    level.killstreakchainingweapons["cobra_20mm_mp"] = "helicopter";
    level.killstreakchainingweapons["apache_minigun_mp"] = "littlebird_flock";
    level.killstreakchainingweapons["littlebird_guard_minigun_mp"] = "littlebird_support";
    level.killstreakchainingweapons["remote_mortar_missile_mp"] = "remote_mortar";
    level.killstreakchainingweapons["ugv_turret_mp"] = "airdrop_remote_tank";
    level.killstreakchainingweapons["ugv_gl_turret_mp"] = "airdrop_remote_tank";
    level.killstreakchainingweapons["pavelow_minigun_mp"] = "helicopter_flares";
    level.killstreakchainingweapons["ac130_105mm_mp"] = "ac130";
    level.killstreakchainingweapons["ac130_40mm_mp"] = "ac130";
    level.killstreakchainingweapons["ac130_25mm_mp"] = "ac130";
    level.killstreakchainingweapons["iw5_m60jugg_mp"] = "airdrop_juggernaut";
    level.killstreakchainingweapons["iw5_mp412jugg_mp"] = "airdrop_juggernaut";
    level.killstreakchainingweapons["osprey_player_minigun_mp"] = "osprey_gunner";
    level.killstreakrounddelay = maps\mp\_utility::getintproperty( "scr_game_killstreakdelay", 8 );
    level thread maps\mp\killstreaks\_killstreaks::onplayerconnect();
}

xpPointsPopup_new( amount, bonus, hudColor, glowAlpha ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if(amount == 0)
		return;
		
	self notify( "xpPointsPopup" );
	self endon( "xpPointsPopup" );

	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;

	self.hud_xpPointsPopup.label = &"+ &&1 XP";
	
	self.hud_xpPointsPopup.color = (1, 1, 0);
	self.hud_xpPointsPopup.font = "small";

	self.hud_xpPointsPopup setValue(self.xpUpdateTotal);
	self.hud_xpPointsPopup.alpha = 1;
	self.hud_xpPointsPopup.fontscale = 1.15;
	
	wait 1;
	
	self.hud_xpPointsPopup fadeOverTime(.75);
	self.hud_xpPointsPopup.alpha = 0;	
	
	self.xpUpdateTotal = 0;		
}

xpEventPopup_new( event, hudColor, glowAlpha ) {
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");

	hudColor = (.9, .9, .9);
	
	self notify( "xpEventPopup" );
	self endon( "xpEventPopup" );
	
	self.hud_xpEventPopup.font = "default";
	self.hud_xpEventPopup.fontscale = 1;
	self.hud_xpEventPopup.color = hudColor;
	self.hud_xpEventPopup.x = 95;
	self.hud_xpEventPopup.y = -50;

	self.hud_xpEventPopup setText(event);
	self.hud_xpEventPopup.alpha = 1;

	wait 1;
	
	self.hud_xpEventPopup fadeOverTime(.75);
	self.hud_xpEventPopup.alpha = 0;	
}

setNewCursorHint2(owner) {
	self endon("death");
	owner endon("disconnect");
	level endon("game_ended");
	while(1) {
		self waittill("trigger", player);
		if(player != owner && player.team != owner.team) {
			player setLowerMessage("msg", "Press and Hold ^:[{+activate}]^7 to Destroy Tactical Insertion!");
            player thread deleteLowerMsg(self, 75);
		}
	}
}

setNewCursorHint(owner) {
	self endon("death");
	owner endon("disconnect");
	level endon("game_ended");
	while(1) {
		self waittill("trigger", player);
		if(player == owner) {
			player setLowerMessage("msg", "Press and Hold ^:[{+activate}]^7 to pick up Tactical Insertion!");
            player thread deleteLowerMsg(self, 75);
		}
	}
}

deleteLowerMsg(trigger, range) {
    self notify("Deletemsg");
    self endon("Deletemsg");
    self endon("disconnect");
    
    near = true;
    
    while(near) {
        wait .5;
		if(isdefined(trigger)) {
        	if(Distance(self.origin,trigger.origin) > range) {
            	self clearLowerMessage("msg");
            	near = false;
            }
        }
        else {
        	self clearLowerMessage("msg");
            near = false;
        }
    }
}

GlowStickUseListener_new( owner ) {
	self endon ( "death" );
	level endon ( "game_ended" );
	owner endon ( "disconnect" );
	
	self thread maps\mp\perks\_perkfunctions::updateEnemyUse( owner );
	triggerfriendly = Spawn( "trigger_radius", self.origin, 0, 75, 75 );
	triggerfriendly thread setNewCursorHint(owner);
	triggerenemy = Spawn( "trigger_radius", self.origin, 0, 75, 75 );
	triggerenemy thread setNewCursorHint2(owner);
	self thread WatchDeath(triggerenemy, triggerfriendly);
	
	for ( ;; ) {
		self waittill ( "trigger", player );
		
		player playSound( "chemlight_pu" );
		triggerenemy delete();
		triggerfriendly delete();
		player thread maps\mp\perks\_perkfunctions::setTacticalInsertion();
		player thread maps\mp\perks\_perkfunctions::deleteTI( self );
	}
}

WatchDeath(trig, trig2) {
	level endon ( "game_ended" );
	self endon("DDDDD");
	
	self waittill("death");
	
	if(isdefined(trig))
		trig delete();
	if(isdefined(trig2))
		trig2 delete();
	
	self notify("DDDDD");
}









