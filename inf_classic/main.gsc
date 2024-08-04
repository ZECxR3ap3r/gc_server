#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\infect;

main() {
    precachemenu("popup_leavegame");
    precachemenu("mainmenu");

    replacefunc(::updateMainMenu, ::blanky);
}

blanky() {
}

init() {
	replacefunc(maps\mp\gametypes\_menus::onmenuresponse, ::onmenuresponse_edit);
    replacefunc(maps\mp\killstreaks\_nuke::cancelnukeondeath, ::cancelnukefix);
    replacefunc(maps\mp\gametypes\infect::setinfectedmsg, ::setinfectedmsg_edit);

	precacheshader("reticle_center_cross");
    precacheshader("killiconmelee");
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
		level.info_hud_elements["text_info_right"] settext("^8[{vote no}] ^7High Fps   ^8[{vote yes}] ^7Fullbright   ^8[{+actionslot 6}] ^7Suicide");
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
		level.info_hud_elements["host"] settext("www.^8Gillette^7Clan.com");
	}

    level.map_name = getdvar("ui_mapname");

    SetDvar("jump_height", 45);
    SetDvar("g_speed", 220);
	SetDvar("player_sprintunlimited", 1);
    SetDvar("scr_nukecancelmode", 1);
    setdvar("scr_infect_timelimit", 10);
    setdvar("sv_cheats", 0);

    if(getdvar("net_port") == "27025") {
        SetDvar("sv_enablebounces", 1);
        SetDvar("sv_allanglesbounces", 1);
        SetDvar("jump_disablefalldamage", 1);
        SetDvar("g_playercollision", 2);
        SetDvar("g_playerejection", 2);

        level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::onPlayerDamageBOUNCE;
    }

    level.callbackplayerkilledMain 		= level.callbackPlayerKilled;
    level.modifyplayerdamage 			= ::onplayerdamage_callback;
    level.callbackPlayerKilled 			= ::cPlayerKilled;
    level.SpawnedPlayersCheck 			= [];
    level.infected_players              = [];

    level thread on_connect();
    level thread on_connecting();
    level thread nuke_handler();

    playerwaittime = 20;
    matchstarttime = 20;

    level.nukeInfo.xpScalar = 2;

    level.gameTweaks["playerwaittime"] = spawnStruct();
	level.gameTweaks["playerwaittime"].value = playerwaittime;
	level.gameTweaks["playerwaittime"].lastValue = playerwaittime;
	level.gameTweaks["playerwaittime"].dVar = "scr_game_playerwaittime";
    level.gameTweaks["matchstarttime"] = spawnStruct();
	level.gameTweaks["matchstarttime"].value = matchstarttime;
	level.gameTweaks["matchstarttime"].lastValue = matchstarttime;
	level.gameTweaks["matchstarttime"].dVar = "scr_game_matchstarttime";

	// TK
	add_throwingknife_map("mp_highrise");
    add_throwingknife_map("mp_highrise_sh");
    add_throwingknife_map("mp_pipeline");
    add_throwingknife_map("mp_checkpoint");
    add_throwingknife_map("mp_overgrown");
    add_throwingknife_map("mp_citystreets");
    add_throwingknife_map("mp_quarry");
    add_throwingknife_map("mp_rustbucket");
    add_throwingknife_map("mp_qadeem");
    add_throwingknife_map("mp_crossfire");
	add_throwingknife_map("mp_fav_tropical");
	add_throwingknife_map("mp_mw2_rust");

    // Betties
    add_betties_map("mp_boneyard");
    add_betties_map("mp_nightshift");
	add_betties_map("mp_asylum");
	add_betties_map("mp_storm");
    add_betties_map("mp_offshore_sh");
    add_betties_map("mp_cargoship");
    add_betties_map("mp_cargoship_sh");
    add_betties_map("mp_overwatch");
    add_betties_map("mp_brecourt");
    add_betties_map("mp_terminal_cls");
    add_betties_map("mp_dome");
    add_betties_map("mp_subbase");
    add_betties_map("mp_invasion");
    add_betties_map("mp_derail");
    add_betties_map("mp_derail");
    add_betties_map("mp_crash_snow");
    add_betties_map("mp_showdown_sh");
    add_betties_map("mp_compact");
    add_betties_map("mp_estate");
    add_betties_map("mp_backlot_sh");
    add_betties_map("mp_underpass");
    add_betties_map("mp_abandon");
    add_betties_map("mp_firingrange");
    add_betties_map("mp_factory_sh");
    add_betties_map("mp_poolday");
	add_betties_map("mp_melee_resort");
    add_betties_map("mp_wasteland_sh");
	add_betties_map("mp_exchange");
	add_betties_map("mp_moab");
	add_betties_map("mp_farm");
    add_betties_map("mp_base");
	add_betties_map("mp_fuel2");
	add_betties_map("mp_marketcenter");
    add_betties_map("mp_creek");

    level.jump_players = [];
    level.jump_players[tolower("010000000013BF4B")] = 1; // Kiwi
    level.jump_players[tolower("010000000025809B")] = 1;
    level.jump_players[tolower("010000000046A466")] = 1;
    level.jump_players[tolower("0100000000383AD7")] = 1;
    level.jump_players[tolower("01000000003EA63D")] = 1;
    level.jump_players[tolower("01000000001BC6B0")] = 1;

    turrets = GetEntArray("misc_turret","classname");
    for(i=0;i<turrets.size;i++)
        turrets[i] delete();

    tpents = GetEntArray("tpjug", "targetname");
    foreach(ent in tpents)
        ent delete();

    if(level.map_name == "mp_highrise") {
        classicents = GetEntArray("classicinf", "targetname");
        foreach(ent in classicents)
            ent delete();
    }

    if(level.map_name == "mp_backlot_sh")
    	add_death_trigger((level.mapcenter - (0, 0, 500)), 3000, 1500, 1);
    if(level.map_name == "mp_six_ss")
    	add_death_trigger((663.0, 1381.0, 180), 135, 135, 0);

    if(isdefined(level.infect_timerDisplay)) {
    	level.infect_timerDisplay destroy();

    	level.infect_timerDisplay = createServerTimer("bigfixed", .5);
		level.infect_timerDisplay.horzalign = "fullscreen";
		level.infect_timerDisplay.vertalign = "fullscreen";
		level.infect_timerDisplay.alignx = "left";
		level.infect_timerDisplay.aligny = "top";
		level.infect_timerDisplay.x = 5;
		level.infect_timerDisplay.y = 108;
		level.infect_timerDisplay.alpha = 0;
		level.infect_timerDisplay.archived = false;
		level.infect_timerDisplay.hideWhenInMenu = true;
    }

	wait 1;

    if(level.map_name == "mp_test")
        visionsetnaked("default", 0.1);

    level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
    level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
    level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quieter_ks";
    level.infect_loadouts["allies"]["loadoutKillstreak3"] = "_specialty_blastshield_ks";

    stringy = "Welcome to INF ^5Classic Bounce^7 24/7 | Join us on Discord ^5discord.gg/GilletteClan";
    if(getdvar("sv_motd") != stringy)
        setdvar("sv_motd", stringy);

    cmdexec("load_dsr INF_default");
}

nuke_handler() {
    nukes = 0;

    while(1) {
        level waittill("nuke_death");

        nukes++;

        if(nukes == 3) {
            if(!isdefined(level.betties_map)) {
                level.betties_map = 1;

                foreach(player in level.players) {
                    if(player.team == "axis")
                        player GiveWeapon("bouncingbetty_mp");
                }

                say_raw("^8^7[ ^8Information^7 ] Infected Equipment: ^8Bouncing Betty^7 Unlocked");
            }
            else if(!isdefined(level.throwing_knifes_map)) {
                level.throwing_knifes_map = 1;
                level.infect_loadouts["axis"]["loadoutDeathstreak"] = "";
                say_raw("^8^7[ ^8Information^7 ] Infected Equipment: ^8Throwing Knife^7 Unlocked");
            }
        }
    }
}

cancelnukefix( player ) {
    level endon( "nuke_death" );

    player common_scripts\utility::waittill_any("death", "disconnect");
    if(isdefined(player.nukekiller)) {
        iPrintLnBold("^8" + player.name + "^7 M.O.A.B got ^8Cancelled^7 by ^:" + player.nukekiller.name);
        player.nukekiller = undefined;
    }
    else
        iPrintLnBold("^8" + player.name + "^7 M.O.A.B got ^8Cancelled");

    setdvar( "ui_bomb_timer", 0 );
    level.nukeincoming = undefined;
    level notify( "nuke_cancelled" );
    visionsetnaked(getdvar("mapname"), 0.1);
	visionsetpain( getdvar("mapname") );
}

setinfectedmsg_edit() {
    if ( isdefined( self.changingtoregularinfected ) )
    {
        self.changingtoregularinfected = undefined;

        if ( isdefined( self.changingtoregularinfectedbykill ) )
        {
            self.changingtoregularinfectedbykill = undefined;
            thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRSTBLOOD" );
            maps\mp\gametypes\_gamescore::givePlayerScore( "first_draft", self );
            thread maps\mp\gametypes\_rank::giveRankXP( "first_draft" );
        }
    }
}

add_death_trigger(origin, radius, height, method) {
	trigger = spawn("trigger_radius", origin, 1, radius, height);

	while(1) {
        if(isdefined(level.players)) {
            foreach(player in level.players) {
                if(isdefined(method) && method == 1) {
                    if(!player istouching(trigger))
                        player _suicide();
                }
                else {
                    if(player istouching(trigger))
                        player _suicide();
                }
            }
        }

    	wait .15;
    }
}

on_connect() {
    for(;;) {
        level waittill("connecting", player);

		if(level.players.size > 10) {
        	if(getNumSurvivors() <= 3)
        		player.spawnasinf = 1;
        }
    }
}

on_connecting() {
    for(;;) {
        level waittill("connected", player);

        player.infDeathsCounter = 0;

        player SetClientDvar("cg_teamcolor_allies", "0 .7 1 1");
        player SetClientDvar("cg_teamcolor_axis", "1 .25 .25 1");

        player thread on_spawned();
        player thread watchWeaponChange();
		player thread on_team_change();

        player setclientdvars("cg_overheadnamesfont", 2, "g_scriptMainMenu", "mainmenu");

        if(isdefined(level.infected_players[player.guid]) && level.infected_players[player.guid] == "left_first") {
            for(i = 0;i < level.players.size;i++) {
                if(isdefined(level.admin_commands_clients[level.players[i].guid]["access"]) && level.admin_commands_clients[level.players[i].guid]["access"] == 3 && level.players[i] != player)
                    level.players[i] tell_raw(level.commands_prf + "^3" + player.name + "^7 Joined back ( ^:Left as First Infected^7 )");
            }
        }

        if(!isdefined(level.SpawnedPlayersCheck[player.guid]) && !isdefined(player.spawnasinf))
			level.SpawnedPlayersCheck[player.guid] = 1;
		else {
			player maps\mp\gametypes\_menus::addToTeam( "axis", true );
			maps\mp\gametypes\infect::updateTeamScores();
			player.infect_firstSpawn = false;
			player.pers["class"] = "gamemode";
			player.pers["lastClass"] = "";
			player.class = player.pers["class"];
			player.lastClass = player.pers["lastClass"];
			foreach(players in level.players) {
				if(isDefined(players.isInitialInfected))
					players thread maps\mp\gametypes\infect::setInitialToNormalInfected();
			}
			if(isdefined(level.infect_timerdisplay) && level.infect_timerdisplay.alpha == 1)
				level.infect_timerdisplay.alpha = 0;
		}
    }
}

on_spawned() {
    self endon("disconnect");

	self.initial_spawn = 0;
    self.hud_elements = [];

    for(;;) {
        self waittill("spawned_player");

        self freezecontrols(false);
        self SetClientDvar("cg_objectiveText", "^8Gillette^7Clan.com\n^7Join us on Discord ^8discord.gg/GilletteClan");

        if(isdefined(level.jump_players)) {
            if(isdefined(level.jump_players[self.guid]))
                self setclantag("I <3 GC");
        }

        if(self.initial_spawn == 0) {
        	self.initial_spawn = 1;

       		self notifyOnPlayerCommand("FpsFix_action", "vote no");
			self notifyOnPlayerCommand("Fullbright_action", "vote yes");
			self notifyOnPlayerCommand("suicide_action", "+actionslot 6");

			self thread doFps();
			self thread doFullbright();
			self thread suicidePlayer();
			self thread too_low_check();
            self thread on_discnnect();
            self thread hud_create();
        }

        if(!isdefined(self.afkwatcherenabled)) {
	    	self.afkwatcherenabled = 1;
        	self thread adv_afk_check();
        }

	    if(self.sessionteam == "allies") {
	        self survivor_init();
	        self SetPerk("specialty_fastsprintrecovery", true, false);
	    }
	    else if(self.sessionteam == "axis") {
	    	if(self getcurrentweapon() != "iw5_usp45_mp_tactical") {
	    		self takeallweapons();

	    		self giveweapon("iw5_usp45_mp_tactical");
	    		self setspawnweapon("iw5_usp45_mp_tactical");
	    		self setweaponammoclip("iw5_usp45_mp_tactical", 0);
	    		self setweaponammostock("iw5_usp45_mp_tactical", 0);
	    		self GiveWeapon("flare_mp");
	    		self giveperk("specialty_tacticalinsertion", 1);
                if(isdefined(self.isInitialInfected))
                    self giveweapon("throwingknife_mp");
	    	}

            if(self.guid == "0100000000043211") {
                self takeweapon("iw5_usp45_mp_tactical");
                self giveweapon("iw5_usp45_mp_tactical_camo13");
	    		self setspawnweapon("iw5_usp45_mp_tactical_camo13");
	    		self setweaponammoclip("iw5_usp45_mp_tactical_camo13", 0);
	    		self setweaponammostock("iw5_usp45_mp_tactical_camo13", 0);
            }

            if(!isdefined(level.infected_players[self.guid]))
                level.infected_players[self.guid] = 1;

	    	if(isdefined(level.throwing_knifes_map) && level.throwing_knifes_map == 1) {
	    		if(self.stats["stats_deathstreak"].value >= 4)
	    			self thread create_deathstreak_hud("specialty_juiced", "killiconmelee");
	    	}
	    	else if(isdefined(level.betties_map) && level.betties_map == 1)
	    		self GiveWeapon("bouncingbetty_mp");

		    self SetPerk("specialty_fastmantle", true, false);
		    self SetPerk("specialty_fastoffhand", true, false);
		    self SetPerk("specialty_fastsprintrecovery", true, false);

		    self SetClientDvar("lowAmmoWarningColor1", "0 0 0 0");
		    self SetClientDvar("lowAmmoWarningColor2", "0 0 0 0");
		    self SetClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 0 0");
		    self SetClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 0 0");
		    self SetClientDvar("lowAmmoWarningNoReloadColor1", "0 0 0 0");
		    self SetClientDvar("lowAmmoWarningNoReloadColor2", "0 0 0 0");
	    }
    }
}

on_discnnect() {
    guid = self.guid;

    self waittill("disconnect");

    if(isdefined(level.infected_players[guid])) {
        if(level.teamCount["axis"] == 0)
            level.infected_players[guid] = "left_first";
        else
            level.infected_players[guid] = "left";
    }
}

create_deathstreak_hud(background, topshader) {
	self endon("disconnect");

    if(isdefined(self.deathstreak_background_icon))
        self.deathstreak_background_icon destroy();
    if(isdefined(self.deathstreak_icon))
        self.deathstreak_icon destroy();
    if(isdefined(self.deathstreak_text))
        self.deathstreak_text destroy();
    if(isdefined(self.deathstreak_desc))
        self.deathstreak_desc destroy();

	self.deathstreak_background_icon = newclienthudelem(self);
	self.deathstreak_background_icon.horzalign = "center";
	self.deathstreak_background_icon.vertalign = "middle";
	self.deathstreak_background_icon.alignx = "center";
	self.deathstreak_background_icon.aligny = "middle";
	self.deathstreak_background_icon.x = 0;
	self.deathstreak_background_icon.y = -155;
	self.deathstreak_background_icon.alpha = 0;
	self.deathstreak_background_icon.sort = 0;
	self.deathstreak_background_icon setshader(background, 32, 32);

	self.deathstreak_icon = newclienthudelem(self);
	self.deathstreak_icon.horzalign = "center";
	self.deathstreak_icon.vertalign = "middle";
	self.deathstreak_icon.alignx = "center";
	self.deathstreak_icon.aligny = "middle";
	self.deathstreak_icon.x = -1;
	self.deathstreak_icon.y = -155;
	self.deathstreak_icon.color = (1, 1, 1);
	self.deathstreak_icon.alpha = 0;
	self.deathstreak_icon.sort = 1;
	self.deathstreak_icon setshader(topshader, 27, 21);

	self.deathstreak_text = newclienthudelem(self);
	self.deathstreak_text.horzalign = "center";
	self.deathstreak_text.vertalign = "middle";
	self.deathstreak_text.alignx = "center";
	self.deathstreak_text.aligny = "middle";
	self.deathstreak_text.x = 0;
	self.deathstreak_text.y = -125;
	self.deathstreak_text.glowalpha = 1;
	self.deathstreak_text.glowcolor = game["colors"]["red"];
	self.deathstreak_text.alpha = 0;
	self.deathstreak_text.font = "bigfixed";
	self.deathstreak_text.fontscale = .75;
	self.deathstreak_text settext(&"PERKS_KNIFETHROW");

	self.deathstreak_desc = newclienthudelem(self);
	self.deathstreak_desc.horzalign = "center";
	self.deathstreak_desc.vertalign = "middle";
	self.deathstreak_desc.alignx = "center";
	self.deathstreak_desc.aligny = "middle";
	self.deathstreak_desc.x = 0;
	self.deathstreak_desc.y = -105;
	self.deathstreak_desc.color = (1, 1, 1);
	self.deathstreak_desc.alpha = 0;
	self.deathstreak_desc.fontscale = 1.2;
	self.deathstreak_desc settext(&"CHALLENGE_DESC_ATM");

	self.deathstreak_background_icon fadeovertime(.15);
	self.deathstreak_icon fadeovertime(.15);
	self.deathstreak_text fadeovertime(.15);
	self.deathstreak_desc fadeovertime(.15);
	self.deathstreak_background_icon.alpha = 1;
	self.deathstreak_icon.alpha = 1;
	self.deathstreak_text.alpha = 1;
	self.deathstreak_desc.alpha = 1;

	wait .1;

    self GiveWeapon("throwingknife_mp");
    self SetOffhandPrimaryClass( "throwingknife" );
	self SetWeaponAmmoClip("throwingknife_mp", 1);

	self common_scripts\utility::waittill_any_timeout(3, "death");

    if(isdefined(self.deathstreak_background_icon)) {
        self.deathstreak_background_icon fadeovertime(.15);
        self.deathstreak_icon fadeovertime(.15);
        self.deathstreak_text fadeovertime(.15);
        self.deathstreak_desc fadeovertime(.15);

        self.deathstreak_background_icon.alpha = 0;
        self.deathstreak_icon.alpha = 0;
        self.deathstreak_text.alpha = 0;
        self.deathstreak_desc.alpha = 0;
    }

	wait .15;

    if(isdefined(self.deathstreak_background_icon))
        self.deathstreak_background_icon destroy();
    if(isdefined(self.deathstreak_icon))
        self.deathstreak_icon destroy();
    if(isdefined(self.deathstreak_text))
        self.deathstreak_text destroy();
    if(isdefined(self.deathstreak_desc))
        self.deathstreak_desc destroy();
}

too_low_check() {
	self endon("disconnect");

	while(1) {
		if(isalive(self)) {
			if(self.origin[2] > (level.lowspawn.origin[2] + 10000) || self.origin[2] < (level.lowspawn.origin[2] - 10000))
				self suicide();
		}

		wait .05;
	}
}

onplayerdamage_callback(victim, eAttacker, iDamage, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc) {
	if(isdefined(eAttacker)) {
        if(isdefined(eAttacker.classname) && eAttacker.classname == "trigger_hurt")
            return iDamage;

		if(issubstr(sWeapon, "aa12"))
			iDamage = int(iDamage * 2);

        if(issubstr(sWeapon, "stakeout"))
			iDamage = int(iDamage * 1.4);

        if(issubstr(sWeapon, "freedom"))
			iDamage = int(iDamage * 1.2);

        if(issubstr(sWeapon, "1887"))
			iDamage = int(iDamage * 1.7);

		if(sWeapon == "barrel_mp")
			iDamage = int(0);

        if(isdefined(level.nukeinfo.player) && level.nukeinfo.player == self && isdefined(eAttacker.name))
            level.nukeinfo.player.nukekiller = eAttacker;

        if(!isdefined(self.isdead) && sWeapon == "ac130_105mm_mp")
            iDamage = int(0);
        else
            self.isdead = undefined;

		if(isdefined(eAttacker.no_damage_protection)) {
			if(!issubstr(sWeapon, "usp45"))
				iDamage = int(0);
		}

        if(eAttacker.sessionteam == "axis" && eAttacker.stats["stats_deathstreak"].value > 0)
            eAttacker.stats["stats_deathstreak"].value = 0;
	}

	return iDamage;
}

onPlayerDamageBOUNCE(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {
	self endon("disconnect");
    iDFlags = 4;
	[[level.prevCallbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

onmenuresponse_edit() {
    self endon( "disconnect" );

    for (;;) {
        self waittill( "menuresponse", var_0, var_1 );

        if ( var_1 == "back" ) {
            self closepopupmenu();
            self closeingamemenu();

            if ( isoptionsmenu( var_0 ) ) {
                if ( self.pers["team"] == "allies" )
                    self openpopupmenu( game["menu_class_allies"] );

                if ( self.pers["team"] == "axis" )
                    self openpopupmenu( game["menu_class_axis"] );
            }
            continue;
        }

        if ( var_1 == "changeteam" ) {
        	self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_1 == "changeclass_marines" ) {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_1 == "changeclass_opfor" ) {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_1 == "changeclass_marines_splitscreen" ) {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_1 == "changeclass_opfor_splitscreen" ) {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_1 == "endgame" )
        {
            if ( level.splitscreen )
            {
                endparty();

                if ( !level.gameended )
                    level thread maps\mp\gametypes\_gamelogic::forceend();
            }

            continue;
        }

        if ( var_1 == "endround" )
        {
            if ( !level.gameended )
                level thread maps\mp\gametypes\_gamelogic::forceend();
            else
            {
                self closepopupmenu();
                self closeingamemenu();
                self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
            }

            continue;
        }

        if ( var_0 == game["menu_team"] )
        {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_0 == game["menu_changeclass"] || isdefined( game["menu_changeclass_defaults_splitscreen"] ) && var_0 == game["menu_changeclass_defaults_splitscreen"] || isdefined( game["menu_changeclass_custom_splitscreen"] ) && var_0 == game["menu_changeclass_custom_splitscreen"] )
        {
            self closepopupmenu();
            self closeingamemenu();
            continue;
        }

        if ( var_0 == game["menu_team"] ) {
            switch ( var_1 ) {
                case "allies":
                    self closepopupmenu();
            		self closeingamemenu();
                    break;
                case "axis":
                    self closepopupmenu();
            		self closeingamemenu();
                    break;
                case "autoassign":
                    self closepopupmenu();
            		self closeingamemenu();
                    break;
                case "spectator":
                    self closepopupmenu();
            		self closeingamemenu();
                    break;
            }

            continue;
        }
    }
}

isoptionsmenu( var_0 ) {
    if ( var_0 == game["menu_changeclass"] )
        return 1;

    if ( var_0 == game["menu_team"] )
        return 1;

    if ( var_0 == game["menu_controls"] )
        return 1;

    if ( issubstr( var_0, "pc_options" ) )
        return 1;

    return 0;
}

on_team_change() {
    self endon( "disconnect" );

    for( ;; ) {
        self waittill( "joined_team" );
        wait .25;
        LogPrint( GenerateJoinTeamString( false ) );
    }
}

GenerateJoinTeamString( isSpectator ) {
    team = self.team;

    if ( IsDefined( self.joining_team ) )
        team = self.joining_team;
    else {
        if ( isSpectator || !IsDefined( team ) )
            team = "spectator";
    }

    guid = self GetXuid();

    if ( guid == "0" )
        guid = self.guid;

    if ( !IsDefined( guid ) || guid == "0" )
        guid = "undefined";

    return "JT;" + guid + ";" + self getEntityNumber() + ";" + team + ";" + self.name + "\n";
}

adv_afk_check() {
	self endon("disconnect");
	level endon("game_ended");

	wait 3;

	arg = 0;

    while(1) {
        wait 1;
        if(isdefined(self.isinufo))
            continue;

    	if(level.players.size > 3) {
	    	if(isdefined(self.isInitialInfected) && isAlive(self)) {
	    		org = self.origin;

	    		wait 1;

	    		if(isAlive(self)) {
					if(distance(org, self.origin) <= 20)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 20)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else if(self.team == "axis" && isAlive(self)) {
				org = self.origin;

	    		wait 1;

				if(isAlive(self)) {
					if(distance(org, self.origin) <= 60)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 60)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else
				wait 1;
		}

    }
}

watchWeaponChange(){
    level endon("game_ended");
    self endon("disconnect");

    for(;;) {
        self waittill("used_nuke");

        level notify("anticamp_start", self);
    }
}

cPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {
    attacker killEvent(eInflictor, self, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if(self.sessionteam == "allies")
		self thread nodamagetoteam();

    [[level.callbackplayerkilledMain]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}

killEvent(eInflictor, PlayerWhoDied, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration){
    if (isDefined( self ) && isPlayer( self ) && self != PlayerWhoDied && self.SessionTeam == "allies") {
        if (sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE") {
            if ( self GetPlayerData("killstreaksState", "icons", 0) == 30  && self GetPlayerData("killstreaksState", "hasStreak", 0) == 1) {
                Kills = self.kills;
                if((Kills + 1) >= 30) {
                    rot = RandomIntRange(0, 360);
                    explosionEffect = spawnFx(level.AnticampExplosive, self.Origin + (0, 0, 50), (0, 0, 1), (Cos(rot), Sin(rot), 0));
                    triggerFx(explosionEffect);
                    self _suicide();
                    playSoundAtPos(self.Origin, "exp_suitcase_bomb_main");
                }

                if((Kills + 1) >= 24)
                    self tell("You have a ^8M.O.A.B^7. use it or you will ^8Die!");
            }
        }
    }
}

survivor_init() {
    weap1 = self scripts\inf_classic\weapons::BuildWeapon("ShotGun");
    weap2 = self scripts\inf_classic\weapons::BuildWeapon("Pistol");

    self TakeAllWeapons();
    self GiveWeapon(weap1);
    self GiveMaxAmmo(weap1);
    self GiveWeapon(weap2);
    self GiveMaxAmmo(weap2);

    randomItem2 = ["smoke_grenade_mp", "flash_grenade_mp"];
    secondaryOffHand = randomItem2[RandomIntRange(0,2)];
    self GiveWeapon(secondaryOffHand);
    if(secondaryOffHand == "smoke_grenade_mp")
        self SetOffhandSecondaryClass( "smoke" );

    randomItem = ["bouncingbetty_mp", "c4_mp", "semtex_mp", "claymore_mp", "throwingknife_mp"];
    primaryOffHand = randomItem[RandomIntRange(0,5)];
    self GiveWeapon(primaryOffHand);
    if(primaryOffHand == "throwingknife_mp"){
        self SetOffhandPrimaryClass( "throwingknife" );
        self SetWeaponAmmoClip("throwingknife_mp", 1);
    }
    else if(primaryOffHand == "semtex_mp")
        self SetOffhandPrimaryClass( "other" );

    wait .25;
    self setspawnweapon(weap1);
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
			self iprintln("^83000");
		}
		else if (self.Fps == 1) {
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 2;
			self iprintln("^82000");
		}
		else if (self.Fps == 2) {
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 3;
			self iprintln("^81500");
		}
		else if (self.Fps == 3) {
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 4;
			self iprintln("^81000");
		}
		else if (self.Fps == 4) {
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 5;
			self iprintln("^8500");
		}
		else if (self.Fps == 5) {
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 0;
			self iprintln("^8Default");
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
			self SetClientDvars( "fx_enable", "0", "r_fog", "0", "fx_drawclouds", "0");
			self.Fullbright = 1;
			self iprintln("^8Fx^7/^8Fog");
		}
		else if (self.Fullbright == 1) {
			self SetClientDvar("r_lightmap", "3");
			self.Fullbright = 2;
			self iprintln("^8Fullbright Grey");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvar("r_lightmap", "2" );
			self.Fullbright = 3;
			self iprintln("^8Fullbright White");
		}
		else if (self.Fullbright == 3) {
			self SetClientDvars( "fx_enable", "1", "r_fog", "1", "r_lightmap", "1" , "fx_drawclouds", "1");
			self.Fullbright = 0;
			self iprintln("^8Default");
		}
	}
}

suicidePlayer() {
	self endon("disconnect");
	level endon("game_ended");

	while(1) {
        self waittill("suicide_action");

        self suicide();
    }
}

nodamagetoteam() {
	self.no_damage_protection = 1;
	wait 6;
	self.no_damage_protection = undefined;
}

getNumSurvivors() {
	numSurvivors = 0;
	foreach(player in level.players) {
		if(player.team == "allies")
			numSurvivors++;
	}

	return numSurvivors;
}

add_throwingknife_map(mapname) {
	if(getdvar("mapname") == mapname) {
		level.throwing_knifes_map = 1;

        level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";
    }
}

add_betties_map(mapname) {
	if(getdvar("mapname") == mapname)
		level.betties_map = 1;
}

playerCardSplashNotify_edit(splashRef, player, optionalNumber) {
	self endon ( "disconnect" );
	waittillframeend;

	if ( level.gameEnded )
		return;

	actionData = spawnStruct();

	actionData.name = splashRef;
	actionData.optionalNumber = optionalNumber;

	actionData.sound = tableLookup( "mp/splashTable.csv", 0, actionData.name, 9 );
	actionData.playerCardPlayer = player;
	actionData.slot = 1;

	self thread actionNotify( actionData );
}

destroy_on_notify(notifyname) {
	level waittill(notifyname);

	if(isdefined(self))
		self destroy();
}

hud_create() {
    self endon("disconnect");
    level endon("game_ended");

    x_spacing = 35;
    seg_fontscale = .37;

    if (!isdefined(self.hud_elements["health_ui"])) {
        self.hud_elements["health_ui"] = newClientHudElem(self);
        self.hud_elements["health_ui"].alignx = "left";
        self.hud_elements["health_ui"].aligny = "top";
        self.hud_elements["health_ui"].horzAlign = "fullscreen";
        self.hud_elements["health_ui"].vertalign = "fullscreen";
        self.hud_elements["health_ui"].x = 240 - x_spacing;
        self.hud_elements["health_ui"].y = 2;
        self.hud_elements["health_ui"].font = "bigfixed";
        self.hud_elements["health_ui"].fontscale = seg_fontscale;
        self.hud_elements["health_ui"].label = &"Health: ^8";
        self.hud_elements["health_ui"].hidewheninmenu = 1;
        self.hud_elements["health_ui"].hidewheninkillcam = 1;
        self.hud_elements["health_ui"].archived = 0;
        self.hud_elements["health_ui"].alpha = 1;
    }

    if (!isdefined(self.hud_elements["kills_ui"])) {
        self.hud_elements["kills_ui"] = newClientHudElem(self);
        self.hud_elements["kills_ui"].alignx = "left";
        self.hud_elements["kills_ui"].aligny = "top";
        self.hud_elements["kills_ui"].horzAlign = "fullscreen";
        self.hud_elements["kills_ui"].vertalign = "fullscreen";
        self.hud_elements["kills_ui"].x = 240 - (x_spacing * 2) + 7;
        self.hud_elements["kills_ui"].y = 2;
        self.hud_elements["kills_ui"].font = "bigfixed";
        self.hud_elements["kills_ui"].fontscale = seg_fontscale;
        self.hud_elements["kills_ui"].label = &"Kills: ^8";
        self.hud_elements["kills_ui"].hidewheninmenu = 1;
        self.hud_elements["kills_ui"].hidewheninkillcam = 1;
        self.hud_elements["kills_ui"].archived = 0;
        self.hud_elements["kills_ui"].alpha = 1;
    }

    if (!isdefined(self.hud_elements["killsstreak_ui"])) {
        self.hud_elements["killsstreak_ui"] = newClientHudElem(self);
        self.hud_elements["killsstreak_ui"].alignx = "left";
        self.hud_elements["killsstreak_ui"].aligny = "top";
        self.hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
        self.hud_elements["killsstreak_ui"].vertalign = "fullscreen";
        self.hud_elements["killsstreak_ui"].x = 240 - (x_spacing * 3);
        self.hud_elements["killsstreak_ui"].y = 2;
        self.hud_elements["killsstreak_ui"].font = "bigfixed";
        self.hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
        self.hud_elements["killsstreak_ui"].label = &"Killstreak: ^8";
        self.hud_elements["killsstreak_ui"].hidewheninmenu = 1;
        self.hud_elements["killsstreak_ui"].hidewheninkillcam = 1;
        self.hud_elements["killsstreak_ui"].archived = 0;
        self.hud_elements["killsstreak_ui"].alpha = 1;
    }

    while (1) {
        if (isdefined(self.hud_elements["killsstreak_ui"])) {
            self.hud_elements["killsstreak_ui"] setValue(self getplayerData("killstreaksState", "count"));
            self.hud_elements["kills_ui"] setvalue(self.kills);
            self.hud_elements["health_ui"] setvalue(self.health);
        }

        wait .1;
    }
}