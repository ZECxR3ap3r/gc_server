#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\infect;

main() {
    precachemenu("popup_leavegame");
    precachemenu("mainmenu");
    precachemenu("main_mod_settings");
    precachemenu("getclientdvar");
    precachemenu("youkilled_card_display");
    precachemenu("enter_prestige");
    precachemenu("sendclientdvar");
    precachemenu("killedby_card_display");

    replacefunc(maps\mp\killstreaks\_killstreaks::initKillstreakData, ::initKillstreakData_empty);
    replacefunc(maps\mp\gametypes\_damage::doFinalKillcam, ::doFinalKillcam_edit);
    replacefunc(maps\mp\gametypes\_damage::handleNormalDeath, ::handleNormalDeath_edit);
    replacefunc(maps\mp\gametypes\_damage::handleSuicideDeath, ::handleSuicideDeath_edit);
    replacefunc(maps\mp\gametypes\_gamelogic::fixranktable, ::blanky);
    replacefunc(maps\mp\gametypes\_rank::init, ::_rank_init_edit);
    replacefunc(maps\mp\gametypes\_playerlogic::spawnplayer, ::spawnplayer_edit);
    replacefunc(::updateMainMenu, ::blanky);
    replacefunc(maps\mp\gametypes\_gamelogic::prematchPeriod, ::prematchPeriod_new);
    replacefunc(maps\mp\gametypes\_damage::Callback_PlayerDamage, ::Callback_PlayerDamage_hook);

    level.lastopfer = "";
}

init() {
	replacefunc(maps\mp\gametypes\_menus::onmenuresponse, ::onmenuresponse_edit);
    replacefunc(maps\mp\killstreaks\_nuke::cancelnukeondeath, ::cancelnukefix);
    replacefunc(maps\mp\gametypes\infect::setinfectedmsg, ::setinfectedmsg_edit);

    precacheshader("stencil_base");
    precacheshader("killiconmelee");
    precacheshader("gradient");
    precacheshader("iw5_cardtitle_specialty_veteran");

    precacheshader("rank_prestige1");
    precacheshader("rank_prestige2");
    precacheshader("rank_prestige3");
    precacheshader("rank_prestige4");
    precacheshader("rank_prestige5");
    precacheshader("rank_prestige6");
    precacheshader("rank_prestige7");
    precacheshader("rank_prestige8");
    precacheshader("rank_prestige9");
    precacheshader("rank_prestige10");
    precacheshader("prestiges/bo3_zm_pres_1");
    precacheshader("prestiges/bo1_pres_12");
    precacheshader("prestiges/bo1_pres_13");
    precacheshader("prestiges/bo1_pres_14");
    precacheshader("prestiges/bo1_pres_15");
    precacheshader("prestiges/dpad_ks_ac130");
    precacheshader("prestiges/dpad_emp");
    precacheshader("prestiges/hud_mw2_nuke");
    precacheshader("prestiges/master_prestige_04");
    precacheshader("prestiges/master_prestige_05");
    precacheshader("prestiges/master_prestige_06");
    precacheshader("prestiges/master_prestige_07");
    precacheshader("prestiges/master_prestige_08");
    precacheshader("prestiges/master_prestige_09");
    precacheshader("prestiges/master_prestige_10");
    precacheshader("prestiges/master_prestige_11");
    precacheshader("prestiges/master_prestige_12");
    precacheshader("prestiges/master_prestige_13");
    precacheshader("prestiges/master_prestige_14");
    precacheshader("prestiges/master_prestige_15");
    precacheshader("prestiges/master_prestige_16");
    precacheshader("prestiges/master_prestige_17");
    precacheshader("prestiges/master_prestige_18");
    precacheshader("prestiges/master_prestige_19");
    precacheshader("prestiges/master_prestige_20");
    precacheshader("prestiges/master_prestige_21");
    precacheshader("prestiges/master_prestige_22");
    precacheshader("prestiges/master_prestige_23");
    precacheshader("prestiges/master_prestige_24");
    precacheshader("prestiges/master_prestige_25");
    precacheshader("hud_material/xp_token");
    precacheshader("hud_material/pumpkin");
    precacheshader("hud_material/h1_medal_killstreak5");
    precacheshader("hud_material/h1_medal_killstreak10");
    precacheshader("hud_material/h1_medal_killstreak15");
    precacheshader("hud_material/h1_medal_killstreak20");
    precacheshader("hud_material/h1_medal_killstreak25");
    precacheshader("hud_material/h1_medal_killstreak30");

    level.special_people = [];
    level.special_people[tolower("0100000000043211")] = "ZEC";
    level.map_name = getdvar("ui_mapname");

    SetDvar("jump_height", 45);
    SetDvar("g_speed", 220);
	SetDvar("player_sprintunlimited", 1);
    SetDvar("scr_nukecancelmode", 1);
    setdvar("scr_infect_timelimit", 10);
    setdvar("sv_cheats", 0);
    setdvar("sv_allowaimassist", 1);
    SetDvar("sv_enablebounces", 1);
    SetDvar("sv_allanglesbounces", 1);
    SetDvar("jump_disablefalldamage", 1);
    SetDvar("g_playercollision", 2);
    SetDvar("g_playerejection", 2);

    level.prevCallbackPlayerDamage      = level.callbackPlayerDamage;
    level.callbackPlayerDamage          = ::onPlayerDamageBOUNCE;
    level.modifyplayerdamage 			= ::onplayerdamage_callback;
    level.SpawnedPlayersCheck 			= [];
    level.infected_players              = [];

    level thread on_connect();
    level thread on_connecting();
    level thread nuke_handler();
    //if(level.map_name == "mp_dam_specops")
        //level thread dam_barriers();
    level.maxPrestige = 40;

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

    level.jump_players = [];
    level.jump_players[tolower("010000000013BF4B")] = 1; // Kiwi
    level.jump_players[tolower("010000000025809B")] = 1;
    level.jump_players[tolower("010000000046A466")] = 1;
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

        level thread PushRegionThread((-2837.96,5076.25,3213.06), (-2584.63,6882.61,3472.84), (-2816.88, 6891.32, 3232.13));

        foreach(ent in classicents)
            ent delete();
    }

    ents = getentarray();
    foreach(ent in ents) {
        if(isdefined(ent.targetname) && ent.targetname == "destructible_toy") {
            if(isdefined(ent.model) && issubstr(ent.model, "chicken"))
                ent thread track_chicken_damage();
        }
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
		level.infect_timerDisplay.x = 8;
		level.infect_timerDisplay.y = 115;
		level.infect_timerDisplay.alpha = 0;
		level.infect_timerDisplay.archived = false;
		level.infect_timerDisplay.hideWhenInMenu = true;
    }

    setObjectiveHintText("allies", &"");
	setObjectiveHintText("axis", &"");

	wait 1;

    if(getdvarint("net_port") != 25025) {
        setdvar("scr_infect_timelimit", 0);
        setdvar("sv_cheats", 1);
    }

    level.skybox = 0;
    rand = randomint(100);
    if(rand < 30 && rand >= 15) {
        level.skybox = 2;
        setExpFog(0, 10000, .5, .5, .25, 0, 0);
    }
    else if(rand < 40 && rand >= 30) {
        level.skybox = 3;
        setExpFog(0, 10000, .5, .5, .25, 0, 0);
    }

    level thread event_handler();
    if(!isdefined(level.default_map)) {
        if(randomint(100) > 25)
            level.skybox = 4;
        else
            level.skybox = 0;
    }

    level.infect_loadouts["allies"]["loadoutPrimary"] = "none";
	level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "none";
	level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
	level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
	level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
	level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";

	level.infect_loadouts["allies"]["loadoutSecondary"] = "none";
	level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
	level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
	level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
	level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
	level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";

    if(level.map_name == "mp_test")
        visionsetnaked("default", 0.1);

    if(level.skybox == 1) {
        VisionSetPain("icbm_sunrise1", 0.1);
        visionsetnaked("icbm_sunrise1", 0.1);
        setsunlight(0.5, 0.5, 0.5);
        level.nukeDetonated = 1;
        level.nukeVisionSet = "icbm_sunrise1";
    }
    else if(level.skybox == 2) {
        VisionSetPain("seaknight_assault", .1);
        visionsetnaked("seaknight_assault", .1);
        setsunlight(1, .4, 0);
        level.nukeDetonated = 1;
        level.nukeVisionSet = "seaknight_assault";
    }
    else if(level.skybox == 3) {
        VisionSetPain("airport", .1);
        visionsetnaked("airport", .1);
        setsunlight(1, 1, 1);
        level.nukeDetonated = 1;
        level.nukeVisionSet = "airport";
    }
    else if(level.skybox == 4) {
        VisionSetPain("icbm_sunrise1", 0 );
        visionsetnaked("icbm_sunrise1", 0);
        setsunlight(0.45, 0.45, 0.55);
        level.nukeDetonated = 1;
        level.nukeVisionSet = "icbm_sunrise1";
    }

    level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
    level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
    level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quieter_ks";
    level.infect_loadouts["allies"]["loadoutKillstreak3"] = "_specialty_blastshield_ks";

    stringy = "Welcome to INF ^5Classic Bounce^7 24/7 | Join us on Discord ^5discord.gg/GilletteClan";
    if(getdvar("sv_motd") != stringy)
        setdvar("sv_motd", stringy);

    cmdexec("load_dsr INF_default");

    wait .5;

    game["strings"]["axis_name"] =  "";
    game["strings"]["allies_name"] =  "";
    game["icons"]["axis"] = "stencil_base";
    game["icons"]["allies"] = "stencil_base";

    if(level.skybox == 4) {
        setExpFog(125, 500, .3, .3, .3, .8, 1);
        //level thread custom_placed_models();
    }

    level waittill("game_ended");

	if(isdefined(level.next_map))
        say_raw("^8^7[ ^8Information ^7]: Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(level.next_map));
	else
        say_raw("^8^7[ ^8Information ^7]: Next Map: ^8" + scripts\inf_classic\map_rotation::mapname(level.calc_next_map));
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

        player thread on_spawned();
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
    self.survivor_melee_kills = 0;
    self.hud_elements = [];

    for(;;) {
        self waittill("spawned_player");

        self freezecontrols(false);
        self SetClientDvar("cg_objectiveText", "^8Gillette^7Clan.com\n^7Join us on Discord ^8discord.gg/GilletteClan");

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
            self thread menu_handler();
            self thread track_insertions();
            self thread velocity_hud();
            self thread melee_weapon_attack();
            self thread adv_afk_check();
            self thread lunge_detection();
            self thread halloween_event_hud();

            self thread scripts\_global_files\commands::wallhack();

            //if(self.name == "ZECxR3ap3r")
			//    self thread forgeplacer();

            if(level.skybox != 0 && self.player_settings["render_skybox"] == 1)
                self thread change_skybox();
        }

        if(!isdefined(level.sniper_lobby)) {
            if(self.sessionteam == "allies") {
                self survivor_init();
                self attach("iw6_pumpkin_head", "j_helmet", 1);
                self SetPerk("specialty_fastsprintrecovery", true, false);
            }
            else if(self.sessionteam == "axis") {
                self takeallweapons();

                /*sep_camos = ["none","camo01","camo02","camo03","camo04","camo05"];
                camo = sep_camos[randomint(sep_camos.size)];

                if(camo == "none") {
                    self giveweapon("iw5_usp45_mp_tactical");
                    self setspawnweapon("iw5_usp45_mp_tactical");
                    self setweaponammoclip("iw5_usp45_mp_tactical", 0);
                    self setweaponammostock("iw5_usp45_mp_tactical", 0);
                }
                else {
                    self giveweapon("iw5_usp45_mp_tactical_" + camo);
                    self setspawnweapon("iw5_usp45_mp_tactical_" + camo);
                    self setweaponammoclip("iw5_usp45_mp_tactical_" + camo, 0);
                    self setweaponammostock("iw5_usp45_mp_tactical_" + camo, 0);
                }*/

                self detachall();
                self setmodel("mp_body_iw6_mmyers");
                self setviewmodel("vh_iw6_mmyers");
                self giveweapon("iw5_axe_mp");
                self setspawnweapon("iw5_axe_mp");

                self GiveWeapon("flare_mp");
                self giveperk("specialty_tacticalinsertion", 1);
                if(isdefined(self.isInitialInfected))
                    self giveweapon("throwingknife_mp");

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
        else {
            self takeallweapons();

            if(isdefined(level.longweapons)) {
                self giveweapon(level.longweapons);
                self setspawnweapon(level.longweapons);
            }
            else if(isdefined(level.melee_lobby)) {
                sep_camos = ["camo01","camo02","camo03","camo04","camo05"];
                camo = sep_camos[randomint(sep_camos.size)];

                self giveweapon("iw5_usp45_mp_tactical_" + camo);
                self setspawnweapon("iw5_usp45_mp_tactical_" + camo);
                self setweaponammoclip("iw5_usp45_mp_tactical_" + camo, 0);
                self setweaponammostock("iw5_usp45_mp_tactical_" + camo, 0);
            }
            else {
                weapon = level.sniper_weapons[randomint(level.sniper_weapons.size)];
                self giveweapon(weapon);
                self setspawnweapon(weapon);
            }
        }

        if(level.skybox == 1)
            self visionsetnakedforplayer("icbm_sunrise1", 0.1);
        else if(level.skybox == 2)
            self visionsetnakedforplayer("seaknight_assault", 0.1);
        else if(level.skybox == 3)
            self visionsetnakedforplayer("airport", 0.1);
        else if(level.skybox == 4)
            self visionsetnakedforplayer("icbm_sunrise1", 0.1);
    }
}

halloween_event_hud() {
    wait 1;

    icon = newclienthudelem(self);
    icon.horzalign = "fullscreen";
    icon.vertalign = "fullscreen";
    icon.alignx = "center";
    icon.aligny = "middle";
    icon.x = 320;
    icon.y = 100;
    icon.alpha = 0;
    icon setshader("hud_material/pumpkin", 32, 32);

    text = newclienthudelem(self);
    text.horzalign = "fullscreen";
    text.vertalign = "fullscreen";
    text.alignx = "center";
    text.aligny = "middle";
    text.x = 320;
    text.y = 125;
    text.font = "bigfixed";
    text.fontscale = .7;
    text.color = (1, .4, 0);
    text.alpha = 0;
    text settext("Halloween Event");

    desc = newclienthudelem(self);
    desc.horzalign = "fullscreen";
    desc.vertalign = "fullscreen";
    desc.alignx = "center";
    desc.aligny = "middle";
    desc.x = 320;
    desc.y = 140;
    desc.fontscale = 1;
    desc.alpha = 0;
    desc settext("Enjoy the Double XP");

    wait .5;

    desc fadeovertime(.3);
    desc.alpha = 1;
    text fadeovertime(.3);
    text.alpha = 1;
    icon fadeovertime(.3);
    icon.alpha = 1;

    wait .5;

    self playlocalsound("halloween_spawn");

    wait 8;

    desc fadeovertime(.3);
    desc.alpha = 0;
    text fadeovertime(.3);
    text.alpha = 0;
    icon fadeovertime(.3);
    icon.alpha = 0;

    wait .3;

    desc destroy();
    text destroy();
    icon destroy();
}

melee_weapon_attack() {
    self endon("disconnect");

    while(1) {
        if(self getcurrentweapon() == "iw5_axe_mp" && self attackbuttonpressed())
            self thread clientCmd("+melee;-melee");

        wait .05;
    }
}

clientCmd( dvar ) {
	self setClientDvar( "clientcmd", dvar );
	self openMenu( "sendclientdvar" );
}

forgeplacer() {
    self endon("disconnect");

    model = array("wm_iw6_pumpkin","wm_iw6_pumpkinxl","wm_iw6_pumpkinxxl","candle_holder_medium");

    self.selected = 0;

    entity = spawn("script_model", (0, 0, 0));
    entity setmodel(model[self.selected]);
    entity.angles = (0, 0, 0);

    file = getdvar("fs_homepath") + getdvar("mapname") + "_edits.txt";

    if(self.name == "ZECxR3ap3r")
        writefile(file, "");

    while(1) {
        if(self adsbuttonpressed()) {
            eye = self geteye();
            vec = anglesToForward(self getPlayerAngles());
            end = (vec[0] * 1000000,vec[1] * 1000000,vec[2] * 1000000);
            origin = BulletTrace(eye,end,0,self)["position"];

            if(entity.model == "candle_holder_medium")
                entity.origin = origin - (0, 0, 60);
            else
                entity.origin = origin;
        }
        if(self attackbuttonpressed())
            entity.angles += (0, 5, 0);
        if(self usebuttonpressed()) {
            say_raw("^1^7[ ^1Forge^7 ]: Model Saved!");

            writefile(file, "add_map_xmodel((" + entity.origin[0] + "," + entity.origin[1] + "," + entity.origin[2] + "), (" + entity.angles[0] + "," + entity.angles[1] + "," + entity.angles[2] + "), \"" + entity.model + "\");\n", 1);

            wait .5;

            entity = spawn("script_model", (0, 0, 0));
            entity setmodel(model[self.selected]);
            entity.angles = (0, 0, 0);
        }
        if(self fragbuttonpressed()) {
            self.selected++;

            if(!isdefined(model[self.selected]))
                self.selected = 0;

            entity setmodel(model[self.selected]);
            wait .5;
        }

        wait .05;
    }
}

change_skybox() {
    self endon("disconnect");
    self endon("skybox_change");

    self.skybox_model = spawn("script_model", self.origin);
    if(level.skybox == 1) {
        self.skybox_model setmodel("skybox_mp_night");
        self visionsetnakedforplayer("icbm_sunrise1", .1);
    }
    else if(level.skybox == 2) {
        self.skybox_model setmodel("skybox_mp_abandon_sh");
        self visionsetnakedforplayer("dcemp_parking", .1);
    }
    else if(level.skybox == 3) {
        self.skybox_model setmodel("skybox_mp_day");
        self visionsetnakedforplayer("airport", .1);
    }
    else {
        self.skybox_model setmodel("skybox_mp_halloween");
        self visionsetnakedforplayer("icbm_sunrise1", .1);
    }

    self.skybox_model thread rotatesky();
    self.skybox_model hide();
    self.skybox_model showtoplayer(self);

    for(;;) {
        self.skybox_model.origin = self.origin;
        wait .05;
    }
}

rotatesky() {
    while(isdefined(self)) {
        self rotateyaw(360, 800);
        wait 800;
    }
}

velocity_hud() {
    self endon("disconnect");

    if(!isdefined(self.hud_elements["velocity"])) {
        self.hud_elements["velocity"] = newClientHudElem(self);
        self.hud_elements["velocity"].x = 320;
        self.hud_elements["velocity"].y = 380;
        self.hud_elements["velocity"].alignx = "center";
        self.hud_elements["velocity"].aligny = "BOTTOM";
        self.hud_elements["velocity"].horzalign = "fullscreen";
        self.hud_elements["velocity"].vertalign = "fullscreen";
        self.hud_elements["velocity"].alpha = 1;
        self.hud_elements["velocity"].sort = 1;
        self.hud_elements["velocity"].fontscale = .6;
        self.hud_elements["velocity"].font = "bigfixed";
        self.hud_elements["velocity"].foreground = 0;
        self.hud_elements["velocity"].label = &"^8";
        self.hud_elements["velocity"].HideWhenInMenu = 1;
        self.hud_elements["velocity"].archived = 1;
    }

    while(1) {
        wait .05;

        if(self.hud_elements["velocity"].alpha != 1 && self.player_settings["velocity"] == 1)
            self.hud_elements["velocity"].alpha = 1;
        else if(self.hud_elements["velocity"].alpha != 0 && self.player_settings["velocity"] == 0)
            self.hud_elements["velocity"].alpha = 0;

        self.newvel = self getvelocity();

        if(isdefined(self.newvel)) {
            self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1]));
            self.vel = self.newvel;
        }

        if(isdefined(self.vel))
            self.hud_elements["velocity"] setvalue(int(self.vel));
    }
}

track_insertions() {
    self endon("disconnect");

    while(1) {
        self waittill("destroyed_insertion", owner);

        if(owner.name != self.name)
            self.player_settings["ti_cancel"]++;
    }
}

special_xp_counter() {
    self endon("disconnect");

    while(isdefined(self)) {
        wait 15;
        self.player_settings["special_xp_time"] -= .25;

        if(isdefined(self.hud_element_xp["xp_special_timer"]))
            self.hud_element_xp["xp_special_timer"] settenthstimerstatic(self.player_settings["special_xp_time"]);

        if(self.player_settings["special_xp_time"] <= 0) {
            self.player_settings["special_xp_time"] = 0;
            self.player_settings["special_xp_time"] = 0;
            self notify("player_stats_updated");
            self tell_raw("^8^7[ ^8Information ^7]: Special XP Expired! After this Map");
            break;
        }

        self notify("player_stats_updated");
    }
}

menu_handler() {
    self endon("disconnect");

    base_keys = getarraykeys(level.base_values);

    while(1) {
        self waittill("menuresponse", menu, response);

        self setclientdvars("inf_prestige", self.player_settings["prestige"], "inf_moabs", self.player_settings["moabs"], "inf_cancel_moabs", self.player_settings["cancelled_moabs"]);

        if(response == "enter_prestige")
            self thread Prestige_Logic();

        if(menu == "main_mod_settings") {
            if(issubstr(response, "prestige_selected")) {
                for(i = 0;i < level.maxPrestige + 1;i++) {
                    if(response == "prestige_selected_" + i) {
                        if(self.player_settings["prestige"] >= i) {
                            self.player_settings["choosen_pres"] = i;
                            self setrank(self.rank, self.player_settings["choosen_pres"]);
                            self notify("player_stats_updated");
                            self tell_raw("^8^7[ ^8Information ^7]: Prestige Icon Successfully Updated!");
                        }
                    }
                }
            }
            else if(issubstr(response, "calling_cards/")) {
                card = self scripts\_global_files\player_stats::convert_callingcard_data(response);

                if(isdefined(card)) {
                    self.player_settings["conv_card"] = card;
                    self tell_raw("^8^7[ ^8Information ^7]: Callingcard Successfully Updated!");
                    self notify("player_stats_updated");
                }
            }
            else if(issubstr(response, "inf_settings_")) {
                for(i = 0;i < base_keys.size;i++) {
                    if(response == "inf_settings_" + base_keys[i]) {
                        if(self.player_settings[base_keys[i]] == 0)
                            self.player_settings[base_keys[i]] = 1;
                        else if(self.player_settings[base_keys[i]] == 1)
                            self.player_settings[base_keys[i]] = 0;

                        if(response == "inf_settings_ui_scorelimit") {
                            if(self.player_settings["ui_scorelimit"] == 1)
                                self setclientdvar("inf_scorelimit", 18);
                            else
                                self setclientdvar("inf_scorelimit", 0);
                        }

                        self notify("player_stats_updated");
                    }
                }
            }
            else if(issubstr(response, "teamcolor_surv_")) {
                if(response == "teamcolor_surv_1") {
                    self.player_settings["inf_teamcolor_surv"] = 1;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Blue");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .15 .85 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_2") {
                    self.player_settings["inf_teamcolor_surv"] = 2;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Pink");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "1 0.41 0.71 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_3") {
                    self.player_settings["inf_teamcolor_surv"] = 3;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Green");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .85 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_4") {
                    self.player_settings["inf_teamcolor_surv"] = 4;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Red");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".85 .15 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_5") {
                    self.player_settings["inf_teamcolor_surv"] = 5;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Yellow");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".85 .85 .15 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_6") {
                    self.player_settings["inf_teamcolor_surv"] = 6;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Orange");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "1 0.5 0 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_7") {
                    self.player_settings["inf_teamcolor_surv"] = 7;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Cyan");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", ".15 .85 .85 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_8") {
                    self.player_settings["inf_teamcolor_surv"] = 8;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Purple");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "0.5 0 0.5 1");
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_surv_0") {
                    self.player_settings["inf_teamcolor_surv"] = 0;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Survivors^7 Changed to ^8Default");
                    self SetClientDvars("inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "cg_teamcolor_allies", "0 .7 1 1");
                    self notify("player_stats_updated");
                }
            }
            else if(issubstr(response, "teamcolor_inf_")) {
                if(response == "teamcolor_inf_1") {
                    self.player_settings["inf_teamcolor_inf"] = 1;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Blue");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .15 .85 1");  // Blue
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_2") {
                    self.player_settings["inf_teamcolor_inf"] = 2;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Pink");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "1 0.41 0.71 1");  // Pink
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_3") {
                    self.player_settings["inf_teamcolor_inf"] = 3;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Green");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .85 .15 1");  // Green
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_4") {
                    self.player_settings["inf_teamcolor_inf"] = 4;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Red");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".85 .15 .15 1");  // Red
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_5") {
                    self.player_settings["inf_teamcolor_inf"] = 5;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Yellow");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".85 .85 .15 1");  // Yellow
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_6") {
                    self.player_settings["inf_teamcolor_inf"] = 6;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Orange");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "1 0.5 0 1");  // Orange
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_7") {
                    self.player_settings["inf_teamcolor_inf"] = 7;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Cyan");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", ".15 .85 .85 1");  // Cyan
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_8") {
                    self.player_settings["inf_teamcolor_inf"] = 8;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Purple");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "0.5 0 0.5 1");  // Purple
                    self notify("player_stats_updated");
                }
                else if(response == "teamcolor_inf_0") {
                    self.player_settings["inf_teamcolor_inf"] = 0;
                    self tell_raw("^8^7[ ^8Information ^7]: Teamcolor for ^:Infected^7 Changed to ^8Default");
                    self SetClientDvars("inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "cg_teamcolor_axis", "0 .7 1 1");  // Default
                    self notify("player_stats_updated");
                }
            }

            if(response == "inf_settings_render_skybox") {
                if(self.player_settings["render_skybox"] == 0 && isdefined(self.skybox_model)) {
                    self.skybox_model delete();
                    self notify("skybox_change");
                }
                else if(self.player_settings["render_skybox"] == 1 && !isdefined(self.skybox_model) && level.skybox != 0)
                    self thread scripts\inf_classic\main::change_skybox();
            }
        }
    }
}

getclientdvar(dvar) {
    wait 5;

    self setclientdvar("getting_dvar", "clantag");
    self openmenu("getclientdvar");

    while(1) {
        self waittill("menuresponse", menu, response);

        if(menu == "getclientdvar") {
            if(dvar == "clantag") {
                self.clantag = response;
                print("^5" + self.clantag);
                break;
            }
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
			if(self.origin[2] > (level.lowspawn.origin[2] + 13000) || self.origin[2] < (level.lowspawn.origin[2] - 10000))
				self suicide();
		}

		wait .05;
	}
}

onplayerdamage_callback(victim, eAttacker, iDamage, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc) {
	if(isdefined(eAttacker)) {
        if(isdefined(eAttacker.classname) && eAttacker.classname == "trigger_hurt")
            return iDamage;

        conv_name   = getbaseweaponname(sWeapon) + "_mp";
        distance    = distance(self.origin, eAttacker.origin);

        if(isdefined(level.inf_weapons["spread"][conv_name])) {
            prozent = distance / level.inf_weapons["spread"][conv_name]["range"];

            damage_unterschied = level.inf_weapons["spread"][conv_name]["max_damage"] - level.inf_weapons["spread"][conv_name]["min_damage"];
            iDamage = int(level.inf_weapons["spread"][conv_name]["max_damage"] - (damage_unterschied * prozent));

            if(iDamage >= level.inf_weapons["spread"][conv_name]["max_damage"])
                iDamage = int(level.inf_weapons["spread"][conv_name]["max_damage"]);

            if(iDamage <= level.inf_weapons["spread"][conv_name]["min_damage"])
                iDamage = int(level.inf_weapons["spread"][conv_name]["min_damage"]);

            if(sHitLoc == "head")
                iDamage = int(iDamage * 1.25);
        }

        if(isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_MELEE")
            iDamage = int(iDamage * 100);

		if(sWeapon == "barrel_mp")
			iDamage = int(0);

        if(isdefined(level.nukeinfo.player) && level.nukeinfo.player == self && isdefined(eAttacker.name))
            level.nukeinfo.player.nukekiller = eAttacker;

        if(!isdefined(self.isdead) && sWeapon == "ac130_105mm_mp")
            iDamage = int(0);
        else
            self.isdead = undefined;

		if(isdefined(eAttacker.no_damage_protection)) {
			if(isdefined(sMeansOfDeath) && sMeansOfDeath != "MOD_MELEE")
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

    	if(level.players.size > 8) {
	    	if(isdefined(self.isInitialInfected) && isAlive(self)) {
	    		org = self.origin;

	    		wait 1;

	    		if(isAlive(self)) {
					if(distance(org, self.origin) <= 15)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 15)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else if(self.team == "axis" && isAlive(self)) {
				org = self.origin;

	    		wait 1;

				if(isAlive(self)) {
					if(distance(org, self.origin) <= 25)
						arg++;
					else
						arg = 0;
				}

				if(isdefined(arg) && arg >= 25)
					kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
			}
			else
				wait 1;
		}

    }
}

anti_camp() {
    self endon("disconnect");

    self tell_raw("^8^7[ ^8Information ^7]: Start Running, no camping allowed anymore!");

    self.anti_camp_origins = [];

    for (i = 0; i < 16; i++)
        self.anti_camp_origins[i] = (0, 0, 0);

    while(isalive(self)) {
        for(i = 0; i < 15; i++)
            self.anti_camp_origins[i] = self.anti_camp_origins[i + 1];

        self.anti_camp_origins[15] = self.origin;

        wait .7;

        for (i = 0; i < 15; i++) {
            if(distance(self.origin, self.anti_camp_origins[i]) < 128) {
                self iprintln("Keep Moving");
                self thread maps\mp\gametypes\_damage::finishplayerdamagewrapper(self, self, 20, 0, "MOD_SUICIDE", "none", self.origin, self.origin, "none", 0, 0);
                break;
            }
        }
    }
}

survivor_init() {
    weap1 = self scripts\inf_classic\weapons::generate_weapon("spread");
    weap2 = self scripts\inf_classic\weapons::generate_weapon("pistol");

    self takeallweapons();
    self GiveWeapon(weap1);
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
    self switchtoweapon(weap1);
}

doFps() {
	self endon("disconnect");

    self.Fps = 0;

    while(true) {
        self waittill("FpsFix_action");
		if (self.Fps == 0) {
			self setClientDvar ( "r_zfar", "3000" );
			self.Fps = 1;
			self iprintln("r_zfar: set to ^83000");
		}
		else if (self.Fps == 1) {
			self setClientDvar ( "r_zfar", "2000" );
			self.Fps = 2;
			self iprintln("r_zfar: set to ^82000");
		}
		else if (self.Fps == 2) {
			self setClientDvar ( "r_zfar", "1500" );
			self.Fps = 3;
			self iprintln("r_zfar: set to ^81500");
		}
		else if (self.Fps == 3) {
			self setClientDvar ( "r_zfar", "1000" );
			self.Fps = 4;
			self iprintln("r_zfar: set to ^81000");
		}
		else if (self.Fps == 4) {
			self setClientDvar ( "r_zfar", "500" );
			self.Fps = 5;
			self iprintln("r_zfar: set to ^8500");
		}
		else if (self.Fps == 5) {
			self setClientDvar ( "r_zfar", "0" );
			self.Fps = 0;
			self iprintln("r_zfar: set to ^8Default");
		}
	}
}

doFullbright() {
	self endon("disconnect");

    self.fullbright = 0;

    while(1) {
        self waittill("Fullbright_action");

        if(self.fullbright == 0) {
            self.fullbright++;
			self iprintln("^8Fog");
            self SetClientDvars("r_fog", 0, "fx_drawclouds", 0);
        }
		else if(self.fullbright == 1) {
			self SetClientDvars("fx_enable", 0, "r_fog", 0, "fx_drawclouds", 0);
			self.fullbright++;
			self iprintln("^8FX");
		}
		else if (self.Fullbright == 2) {
			self SetClientDvar("r_lightmap", 3);
			self.fullbright++;
			self iprintln("^8Fullbright Grey");
		}
		else if (self.Fullbright == 3) {
			self SetClientDvar("r_lightmap", 2);
			self.fullbright++;
			self iprintln("^8Fullbright White");
		}
		else if (self.Fullbright == 4) {
			self SetClientDvars("fx_enable", 1, "r_fog", 1, "r_lightmap", 1 , "fx_drawclouds", 1);
			self.fullbright = 0;
			self iprintln("^8Default");
		}
	}
}

suicidePlayer() {
	self endon("disconnect");
	level endon("game_ended");

	while(1) {
        self waittill("suicide_action");

        if(level.teamCount["allies"] == 1 && self.team == "allies" && level.players.size > 8)
            self iPrintLnBold("Cannot Suicide as last!");
        else
            self suicide();
    }
}

getNumSurvivors() {
	numSurvivors = 0;
	foreach(player in level.players) {
		if(player.team == "allies")
			numSurvivors++;
	}

	return numSurvivors;
}

destroy_on_notify(notifyname) {
	level waittill(notifyname);

	if(isdefined(self))
		self destroy();
}

hud_create() {
    self endon("disconnect");

    x_spacing = 35;
    seg_fontscale = .37;

    if(!isdefined(self.gc_hud_elements))
        self.gc_hud_elements = [];

	if(!isdefined(self.gc_hud_elements["background"])) {
		self.gc_hud_elements["background"] = newClientHudElem(self);
		self.gc_hud_elements["background"].horzalign = "fullscreen";
		self.gc_hud_elements["background"].vertalign = "fullscreen";
		self.gc_hud_elements["background"].alignx = "center";
		self.gc_hud_elements["background"].aligny = "top";
		self.gc_hud_elements["background"].x = 320;
		self.gc_hud_elements["background"].y = -17;
		self.gc_hud_elements["background"].color = (.4, .4, .4);
		self.gc_hud_elements["background"].sort = -2;
		self.gc_hud_elements["background"].archived = 1;
		self.gc_hud_elements["background"].hidewheninmenu = 1;
		self.gc_hud_elements["background"].hidewheninkillcam = 1;
		self.gc_hud_elements["background"].alpha = 1;
		self.gc_hud_elements["background"] setshader("iw5_cardtitle_specialty_veteran", 180, 45);
	}

	if(!isdefined(self.gc_hud_elements["background_right"])) {
		self.gc_hud_elements["background_right"] = newClientHudElem(self);
		self.gc_hud_elements["background_right"].horzalign = "fullscreen";
		self.gc_hud_elements["background_right"].vertalign = "fullscreen";
		self.gc_hud_elements["background_right"].alignx = "left";
		self.gc_hud_elements["background_right"].aligny = "top";
		self.gc_hud_elements["background_right"].x = 275;
		self.gc_hud_elements["background_right"].y = -20;
		self.gc_hud_elements["background_right"].color = (.4, .4, .4);
		self.gc_hud_elements["background_right"].sort = -3;
		self.gc_hud_elements["background_right"].archived = 1;
		self.gc_hud_elements["background_right"].hidewheninmenu = 1;
		self.gc_hud_elements["background_right"].hidewheninkillcam = 1;
		self.gc_hud_elements["background_right"].alpha = 1;
		self.gc_hud_elements["background_right"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.gc_hud_elements["background_left"])) {
		self.gc_hud_elements["background_left"] = newClientHudElem(self);
		self.gc_hud_elements["background_left"].horzalign = "fullscreen";
		self.gc_hud_elements["background_left"].vertalign = "fullscreen";
		self.gc_hud_elements["background_left"].alignx = "right";
		self.gc_hud_elements["background_left"].aligny = "top";
		self.gc_hud_elements["background_left"].x = 365;
		self.gc_hud_elements["background_left"].y = -20;
		self.gc_hud_elements["background_left"].color = (.4, .4, .4);
		self.gc_hud_elements["background_left"].sort = -3;
		self.gc_hud_elements["background_left"].archived = 1;
		self.gc_hud_elements["background_left"].hidewheninmenu = 1;
		self.gc_hud_elements["background_left"].hidewheninkillcam = 1;
		self.gc_hud_elements["background_left"].alpha = 1;
		self.gc_hud_elements["background_left"] setshader("iw5_cardtitle_specialty_veteran", 280, 45);
	}

	if(!isdefined(self.gc_hud_elements["text_info_right"])) {
		self.gc_hud_elements["text_info_right"] = newClientHudElem(self);
		self.gc_hud_elements["text_info_right"].horzalign = "fullscreen";
		self.gc_hud_elements["text_info_right"].vertalign = "fullscreen";
		self.gc_hud_elements["text_info_right"].alignx = "left";
		self.gc_hud_elements["text_info_right"].aligny = "top";
		self.gc_hud_elements["text_info_right"].x = 400;
		self.gc_hud_elements["text_info_right"].y = 2;
		self.gc_hud_elements["text_info_right"].font = "bigfixed";
		self.gc_hud_elements["text_info_right"].archived = 1;
		self.gc_hud_elements["text_info_right"].hidewheninmenu = 1;
		self.gc_hud_elements["text_info_right"].hidewheninkillcam = 1;
		self.gc_hud_elements["text_info_right"].fontscale = seg_fontscale;
		self.gc_hud_elements["text_info_right"] settext("^8[{vote no}] ^7High Fps   ^8[{vote yes}] ^7Fullbright   ^8[{+actionslot 6}] ^7Suicide");
	}

	if(!isdefined(self.gc_hud_elements["host"])) {
		self.gc_hud_elements["host"] = newClientHudElem(self);
		self.gc_hud_elements["host"].horzalign = "fullscreen";
		self.gc_hud_elements["host"].vertalign = "fullscreen";
		self.gc_hud_elements["host"].alignx = "center";
		self.gc_hud_elements["host"].aligny = "top";
		self.gc_hud_elements["host"].x = 320;
		self.gc_hud_elements["host"].y = 1;
		self.gc_hud_elements["host"].font = "bigfixed";
		self.gc_hud_elements["host"].archived = 1;
		self.gc_hud_elements["host"].hidewheninmenu = 1;
		self.gc_hud_elements["host"].hidewheninkillcam = 1;
		self.gc_hud_elements["host"].fontscale = .6;
		self.gc_hud_elements["host"] settext("www.^8Gillette^7Clan.com");
	}

    if (!isdefined(self.gc_hud_elements["health_ui"])) {
        self.gc_hud_elements["health_ui"] = newClientHudElem(self);
        self.gc_hud_elements["health_ui"].alignx = "left";
        self.gc_hud_elements["health_ui"].aligny = "top";
        self.gc_hud_elements["health_ui"].horzAlign = "fullscreen";
        self.gc_hud_elements["health_ui"].vertalign = "fullscreen";
        self.gc_hud_elements["health_ui"].x = 240 - x_spacing;
        self.gc_hud_elements["health_ui"].y = 2;
        self.gc_hud_elements["health_ui"].font = "bigfixed";
        self.gc_hud_elements["health_ui"].fontscale = seg_fontscale;
        self.gc_hud_elements["health_ui"].label = &"Health: ^8";
        self.gc_hud_elements["health_ui"].hidewheninmenu = 1;
        self.gc_hud_elements["health_ui"].hidewheninkillcam = 1;
        self.gc_hud_elements["health_ui"].archived = 1;
        self.gc_hud_elements["health_ui"].alpha = 1;
    }

    if (!isdefined(self.gc_hud_elements["kills_ui"])) {
        self.gc_hud_elements["kills_ui"] = newClientHudElem(self);
        self.gc_hud_elements["kills_ui"].alignx = "left";
        self.gc_hud_elements["kills_ui"].aligny = "top";
        self.gc_hud_elements["kills_ui"].horzAlign = "fullscreen";
        self.gc_hud_elements["kills_ui"].vertalign = "fullscreen";
        self.gc_hud_elements["kills_ui"].x = 240 - (x_spacing * 2) + 7;
        self.gc_hud_elements["kills_ui"].y = 2;
        self.gc_hud_elements["kills_ui"].font = "bigfixed";
        self.gc_hud_elements["kills_ui"].fontscale = seg_fontscale;
        self.gc_hud_elements["kills_ui"].label = &"Kills: ^8";
        self.gc_hud_elements["kills_ui"].hidewheninmenu = 1;
        self.gc_hud_elements["kills_ui"].hidewheninkillcam = 1;
        self.gc_hud_elements["kills_ui"].archived = 1;
        self.gc_hud_elements["kills_ui"].alpha = 1;
    }

    if (!isdefined(self.gc_hud_elements["killsstreak_ui"])) {
        self.gc_hud_elements["killsstreak_ui"] = newClientHudElem(self);
        self.gc_hud_elements["killsstreak_ui"].alignx = "left";
        self.gc_hud_elements["killsstreak_ui"].aligny = "top";
        self.gc_hud_elements["killsstreak_ui"].horzAlign = "fullscreen";
        self.gc_hud_elements["killsstreak_ui"].vertalign = "fullscreen";
        self.gc_hud_elements["killsstreak_ui"].x = 240 - (x_spacing * 3);
        self.gc_hud_elements["killsstreak_ui"].y = 2;
        self.gc_hud_elements["killsstreak_ui"].font = "bigfixed";
        self.gc_hud_elements["killsstreak_ui"].fontscale = seg_fontscale;
        self.gc_hud_elements["killsstreak_ui"].label = &"Killstreak: ^8";
        self.gc_hud_elements["killsstreak_ui"].hidewheninmenu = 1;
        self.gc_hud_elements["killsstreak_ui"].hidewheninkillcam = 1;
        self.gc_hud_elements["killsstreak_ui"].archived = 1;
        self.gc_hud_elements["killsstreak_ui"].alpha = 1;
    }

    if(self.player_settings["gc_hud"] == 1) {
        foreach(hud in self.gc_hud_elements)
            hud.alpha = 1;
    }
    else {
        foreach(hud in self.gc_hud_elements)
            hud.alpha = 0;
    }

    while(1) {
        if(isdefined(self.gc_hud_elements["killsstreak_ui"])) {
            self.gc_hud_elements["killsstreak_ui"] setValue(self getplayerData("killstreaksState", "count"));
            self.gc_hud_elements["kills_ui"] setvalue(self.kills);
            self.gc_hud_elements["health_ui"] setvalue(self.health);
        }

        wait .05;
    }
}

doFinalKillcam_edit() {
	level waittill ( "round_end_finished" );

	level.showingFinalKillcam = true;

	winner = "none";
	if( IsDefined( level.finalKillCam_winner ) )
		winner = level.finalKillCam_winner;

	delay = level.finalKillCam_delay[ winner ];
	victim = level.finalKillCam_victim[ winner ];
	attacker = level.finalKillCam_attacker[ winner ];
	attackerNum = level.finalKillCam_attackerNum[ winner ];
	killCamEntityIndex = level.finalKillCam_killCamEntityIndex[ winner ];
	killCamEntityStartTime = level.finalKillCam_killCamEntityStartTime[ winner ];
	sWeapon = level.finalKillCam_sWeapon[ winner ];
	deathTimeOffset = level.finalKillCam_deathTimeOffset[ winner ];
	psOffsetTime = level.finalKillCam_psOffsetTime[ winner ];
	timeRecorded = level.finalKillCam_timeRecorded[ winner ];
	timeGameEnded = level.finalKillCam_timeGameEnded[ winner ];

	if( !isDefined( victim ) ||
		!isDefined( attacker ) )
	{
		level.showingFinalKillcam = false;
		level notify( "final_killcam_done" );
		return;
	}

	// if the killcam happened longer than 15 seconds ago, don't show it
	killCamBufferTime = 15;
	killCamOffsetTime = timeGameEnded - timeRecorded;
	if( killCamOffsetTime > killCamBufferTime )
	{
		level.showingFinalKillcam = false;
		level notify( "final_killcam_done" );
		return;
	}

	if ( isDefined( attacker ) )
		attacker.finalKill = true;

	postDeathDelay = (( getTime() - victim.deathTime ) / 1000);

	foreach(player in level.players){
		player closePopupMenu();
		player closeInGameMenu();
		if( IsDefined( level.nukeDetonated ) )
			player VisionSetNakedForPlayer( level.nukeVisionSet, 0 );
		else
			player VisionSetNakedForPlayer( "", 0 ); // go to default visionset

        player setclientdvars("ui_playercard_prestige", attacker.player_settings["prestige"], "playercard_type", attacker.player_settings["conv_card"]);

		player.killcamentitylookat = victim getEntityNumber();

		if ( (player != victim || (!isRoundBased() || isLastRound())) && player _hasPerk( "specialty_copycat" ) )
			player _unsetPerk( "specialty_copycat" );

		player thread maps\mp\gametypes\_killcam::killcam( attackerNum, killcamentityindex, killcamentitystarttime, sWeapon, postDeathDelay + deathTimeOffset, psOffsetTime, 0, 10000, attacker, victim );
	}

	wait .1;

	while ( maps\mp\gametypes\_damage::anyPlayersInKillcam() )
		wait .05;

	level notify( "final_killcam_done" );
	level.showingFinalKillcam = false;
}

initKillstreakData_empty()
{
	for ( i = 1; true; i++ )
	{
		retVal = tableLookup( "mp/killstreakTable.csv", 0, i, 1 );
		if ( !IsDefined( retVal ) || retVal == "" )
			break;

		if (retVal == "ac130" || retVal == "predator_missile" || retVal == "remote_mortar" || retVal == "remote_uav" || retVal == "osprey_gunner")
			continue;

		streakRef = tableLookup( "mp/killstreakTable.csv", 0, i, 1 );
		assert( streakRef != "" );

		streakUseHint = tableLookupIString( "mp/killstreakTable.csv", 0, i, 6 );
		assert( streakUseHint != &"" );
		PreCacheString( streakUseHint );

		streakEarnDialog = tableLookup( "mp/killstreakTable.csv", 0, i, 8 );
		assert( streakEarnDialog != "" );
		game[ "dialog" ][ streakRef ] = streakEarnDialog;

		streakAlliesUseDialog = tableLookup( "mp/killstreakTable.csv", 0, i, 9 );
		assert( streakAlliesUseDialog != "" );
		game[ "dialog" ][ "allies_friendly_" + streakRef + "_inbound" ] = "use_" + streakAlliesUseDialog;
		game[ "dialog" ][ "allies_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAlliesUseDialog;

		streakAxisUseDialog = tableLookup( "mp/killstreakTable.csv", 0, i, 10 );
		assert( streakAxisUseDialog != "" );
		game[ "dialog" ][ "axis_friendly_" + streakRef + "_inbound" ] = "use_" + streakAxisUseDialog;
		game[ "dialog" ][ "axis_enemy_" + streakRef + "_inbound" ] = "enemy_" + streakAxisUseDialog;

		streakWeapon = tableLookup( "mp/killstreakTable.csv", 0, i, 12 );
		precacheItem( streakWeapon );

		streakPoints = int( tableLookup( "mp/killstreakTable.csv", 0, i, 13 ) );
		assert( streakPoints != 0 );
		maps\mp\gametypes\_rank::registerScoreInfo( "killstreak_" + streakRef, streakPoints );

		streakShader = tableLookup( "mp/killstreakTable.csv", 0, i, 14 );
		precacheShader( streakShader );

		streakShader = tableLookup( "mp/killstreakTable.csv", 0, i, 15 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( "mp/killstreakTable.csv", 0, i, 16 );
		if ( streakShader != "" )
			precacheShader( streakShader );

		streakShader = tableLookup( "mp/killstreakTable.csv", 0, i, 17 );
		if(!issubstr(streakShader, "dpad_killstreak_"))
			precacheShader( streakShader );
	}
}

blanky() {
}

handleNormalDeath_edit( lifeId, attacker, eInflictor, sWeapon, sMeansOfDeath ) {
	attacker thread maps\mp\_events::killedPlayer( lifeId, self, sWeapon, sMeansOfDeath );

    self setclientdvars("ui_playercard_prestige", attacker.player_settings["prestige"], "playercard_type", attacker.player_settings["conv_card"]);
    attacker setclientdvars("ui_playercard_prestige", self.player_settings["prestige"], "playercard_type", self.player_settings["conv_card"]);

	attacker SetCardDisplaySlot( self, 8 );
	attacker openMenu( "youkilled_card_display" );

	self SetCardDisplaySlot( attacker, 7 );
	self openMenu( "killedby_card_display" );

	if ( sMeansOfDeath == "MOD_HEAD_SHOT" ) {
		attacker incPersStat( "headshots", 1 );
		attacker.headshots = attacker getPersStat( "headshots" );
		attacker incPlayerStat( "headshots", 1 );

		if ( isDefined( attacker.lastStand ) )
			value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) * 2;
		else
			value = undefined;

		attacker playLocalSound( "bullet_impact_headshot_2" );
	}
	else {
		if ( isDefined( attacker.lastStand ) )
			value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) * 2;
		else
			value = undefined;
	}

	attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value, sWeapon, sMeansOfDeath );

	attacker incPersStat( "kills", 1 );
	attacker.kills = attacker getPersStat( "kills" );
	attacker updatePersRatio( "kdRatio", "kills", "deaths" );
	attacker maps\mp\gametypes\_persistence::statSetChild( "round", "kills", attacker.kills );
	attacker incPlayerStat( "kills", 1 );

	lastKillStreak = attacker.pers["cur_kill_streak"];

	if ( isAlive( attacker ) || attacker.streakType == "support" ) {
		if ( attacker killShouldAddToKillstreak( sWeapon ) ) {
			attacker thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
			attacker.pers["cur_kill_streak"]++;

			if( !isKillstreakWeapon( sWeapon ) )
				attacker.pers["cur_kill_streak_for_nuke"]++;

			numKills = 25;
			if( attacker _hasPerk( "specialty_hardline" ) )
				numKills--;

			if( !isKillstreakWeapon( sWeapon ) && attacker.pers["cur_kill_streak_for_nuke"] == numKills && !isdefined(attacker.hasnuke)) {
                attacker.hasnuke = 1;
				attacker thread maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", false, true, attacker, true );
				attacker thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "nuke", numKills );
			}
		}

		attacker setPlayerStatIfGreater( "killstreak", attacker.pers["cur_kill_streak"] );

		if ( attacker.pers["cur_kill_streak"] > attacker getPersStat( "longestStreak" ) )
			attacker setPersStat( "longestStreak", attacker.pers["cur_kill_streak"] );
	}

	attacker.pers["cur_death_streak"] = 0;

	if(attacker.pers["cur_kill_streak"] > attacker maps\mp\gametypes\_persistence::statGetChild( "round", "killStreak") )
		attacker maps\mp\gametypes\_persistence::statSetChild( "round", "killStreak", attacker.pers["cur_kill_streak"] );

	if(attacker.pers["cur_kill_streak"] > attacker.kill_streak) {
		attacker maps\mp\gametypes\_persistence::statSet( "killStreak", attacker.pers["cur_kill_streak"] );
		attacker.kill_streak = attacker.pers["cur_kill_streak"];
	}

	maps\mp\gametypes\_gamescore::givePlayerScore( "kill", attacker, self );
	maps\mp\_skill::processKill( attacker, self );

	if ( isDefined( level.ac130player ) && level.ac130player == attacker )
		level notify( "ai_killed", self );

	//if ( lastKillStreak != attacker.pers["cur_kill_streak"] )
	level notify ( "player_got_killstreak_" + attacker.pers["cur_kill_streak"], attacker );
	attacker notify( "got_killstreak" , attacker.pers["cur_kill_streak"] );

	attacker notify ( "killed_enemy" );

	if(isDefined(self.UAVRemoteMarkedBy)) {
		if ( self.UAVRemoteMarkedBy != attacker )
			self.UAVRemoteMarkedBy thread maps\mp\killstreaks\_remoteuav::remoteUAV_processTaggedAssist( self );
		self.UAVRemoteMarkedBy = undefined;
	}

	if ( isDefined( level.onNormalDeath ) && attacker.pers[ "team" ] != "spectator" )
		[[ level.onNormalDeath ]]( self, attacker, lifeId );

	if ( !level.teamBased ) {
		self.attackers = [];
		return;
	}

	level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );

	if ( isDefined( self.lastAttackedShieldPlayer ) && isDefined( self.lastAttackedShieldTime ) && self.lastAttackedShieldPlayer != attacker )
	{
		if ( getTime() - self.lastAttackedShieldTime < 2500 )
		{
			self.lastAttackedShieldPlayer thread maps\mp\gametypes\_gamescore::processShieldAssist( self );

			// if you are using the assists perk, then every assist is a kill towards a killstreak
			if( self.lastAttackedShieldPlayer _hasPerk( "specialty_assists" ) )
			{
				self.lastAttackedShieldPlayer.pers["assistsToKill"]++;

				if( !( self.lastAttackedShieldPlayer.pers["assistsToKill"] % 2 ) )
				{
					self.lastAttackedShieldPlayer maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
					self.lastAttackedShieldPlayer maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
					self.lastAttackedShieldPlayer.pers["cur_kill_streak"]++;
				}
			}
			else
			{
				self.lastAttackedShieldPlayer.pers["assistsToKill"] = 0;
			}
		}
		else if ( isAlive( self.lastAttackedShieldPlayer ) && getTime() - self.lastAttackedShieldTime < 5000 )
		{
			forwardVec = vectorNormalize( anglesToForward( self.angles ) );
			shieldVec = vectorNormalize( self.lastAttackedShieldPlayer.origin - self.origin );

			if ( vectorDot( shieldVec, forwardVec ) > 0.925 )
			{
				self.lastAttackedShieldPlayer thread maps\mp\gametypes\_gamescore::processShieldAssist( self );

				if( self.lastAttackedShieldPlayer _hasPerk( "specialty_assists" ) )
				{
					self.lastAttackedShieldPlayer.pers["assistsToKill"]++;

					if( !( self.lastAttackedShieldPlayer.pers["assistsToKill"] % 2 ) )
					{
						self.lastAttackedShieldPlayer maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
						self.lastAttackedShieldPlayer maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
						self.lastAttackedShieldPlayer.pers["cur_kill_streak"]++;
					}
				}
				else
				{
					self.lastAttackedShieldPlayer.pers["assistsToKill"] = 0;
				}
			}
		}
	}

	if ( isDefined( self.attackers )) {
		foreach ( player in self.attackers ) {
			if ( !isDefined( player ) )
				continue;

			if ( player == attacker )
				continue;

			player thread maps\mp\gametypes\_gamescore::processAssist( self );

			if( player _hasPerk( "specialty_assists" ) ) {
				player.pers["assistsToKill"]++;

				if( !( player.pers["assistsToKill"] % 2 ) ) {
					player maps\mp\gametypes\_missions::processChallenge( "ch_hardlineassists" );
					player maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill" );
					player.pers["cur_kill_streak"]++;

					numKills = 25;
					if( player _hasPerk( "specialty_hardline" ) )
						numKills--;

					if( player.pers["cur_kill_streak"] == numKills && !isdefined(player.hasnuke)) {
                        player.hasnuke = 1;
						player thread maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", false, true, player, true );
						player thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "nuke", numKills );
					}
				}
			}
			else
				player.pers["assistsToKill"] = 0;
		}
		self.attackers = [];
	}
}

handleSuicideDeath_edit( sMeansOfDeath, sHitLoc ) {
    self setclientdvars("ui_playercard_prestige", self.player_settings["prestige"], "playercard_type", self.player_settings["conv_card"]);

	self SetCardDisplaySlot( self, 7 );
	self openMenu( "killedby_card_display" );

	self thread [[ level.onXPEvent ]]( "suicide" );
	self incPersStat( "suicides", 1 );
	self.suicides = self getPersStat( "suicides" );

	if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && isDefined( self.throwingGrenade ) )
		self.lastGrenadeSuicideTime = gettime();
}

spawnplayer_edit() {
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self notify( "spawned" );
	self notify( "end_respawn" );

    if(isDefined(self.setSpawnPoint) && self maps\mp\gametypes\_playerlogic::tiValidationCheck()) {
		spawnPoint = self.setSpawnPoint;

		self playLocalSound( "tactical_spawn" );

		if ( level.teamBased )
			self playSoundToTeam( "tactical_spawn", level.otherTeam[self.team] );
		else
			self playSound( "tactical_spawn" );

		spawnOrigin = self.setSpawnPoint.playerSpawnPos;
		spawnAngles = self.setSpawnPoint.angles;

        self.last_ti_spawn = gettime();

		if ( isDefined( self.setSpawnPoint.enemyTrigger ) )
			 self.setSpawnPoint.enemyTrigger Delete();

		self.setSpawnPoint delete();

		spawnPoint = undefined;
	}
	else {
		spawnPoint = self [[level.getSpawnPoint]]();
		spawnOrigin = spawnpoint.origin;
		spawnAngles = spawnpoint.angles;
	}

	self maps\mp\gametypes\_playerlogic::setSpawnVariables();

	hadSpawned = self.hasSpawned;
	self.fauxDead = undefined;
	self.killsThisLife = [];
	self maps\mp\gametypes\_playerlogic::updateSessionState( "playing", "" );
	self ClearKillcamState();
	self.cancelkillcam = 1;
	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.wasTI = !isDefined( spawnPoint );
	self.afk = false;
	self.lastStand = undefined;
	self.infinalStand = undefined;
	self.inC4Death = undefined;
	self.damagedPlayers = [];
	self.moveSpeedScaler = 1;
	self.killStreakScaler = 1;
	self.xpScaler = 1;
	self.objectiveScaler = 1;
	self.inLastStand = false;
	self.clampedHealth = undefined;
	self.shieldDamage = 0;
	self.shieldBulletHits = 0;
	self.recentShieldXP = 0;
	self.disabledWeapon = 0;
	self.disabledWeaponSwitch = 0;
	self.disabledOffhandWeapons = 0;
	self resetUsability();
	self.avoidKillstreakOnSpawnTimer = 5.0;

	self maps\mp\gametypes\_playerlogic::addToAliveCount();

	if(!self.wasAliveAtMatchStart) {
		acceptablePassedTime = 20;
		if ( getTimeLimit() > 0 && acceptablePassedTime < getTimeLimit() * 60 / 4 )
			acceptablePassedTime = getTimeLimit() * 60 / 4;

		if ( level.inGracePeriod || getTimePassed() < acceptablePassedTime * 1000 )
			self.wasAliveAtMatchStart = true;
	}

	self setClientDvar( "cg_thirdPerson", "0" );
	self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	self setClientDvar( "cg_fov", "65" );

	if(isDefined(spawnPoint)) {
		self maps\mp\gametypes\_spawnlogic::finalizeSpawnpointChoice( spawnpoint );
		spawnOrigin = maps\mp\gametypes\_playerlogic::getSpawnOrigin( spawnpoint );
		spawnAngles = spawnpoint.angles;
	}
	else
		self.lastSpawnTime = getTime();

	self.spawnPos = spawnOrigin;

	self spawn( spawnOrigin, spawnAngles );
	[[level.onSpawnPlayer]]();

	if ( isDefined( spawnPoint ) )
		self maps\mp\gametypes\_playerlogic::checkPredictedSpawnpointCorrectness( spawnPoint.origin );

	self maps\mp\gametypes\_missions::playerSpawned();

	prof_begin( "spawnPlayer_postUTS" );

	self maps\mp\gametypes\_class::setClass(self.class);
	self maps\mp\gametypes\_class::giveLoadout(self.team, self.class);

	if ( !gameFlag( "prematch_done" ) )
		self freezeControlsWrapper( true );
	else
		self freezeControlsWrapper( false );

	if ( !gameFlag( "prematch_done" ) || !hadSpawned && game["state"] == "playing" )
	{
		self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );

		team = self.pers["team"];

		if ( game["status"] == "overtime" )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"]["overtime"], game["strings"]["overtime_hint"], undefined, (1, 0, 0), "mp_last_stand" );
		else if ( getIntProperty( "useRelativeTeamColors", 0 ) )
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team] + "_blue", game["colors"]["blue"] );
		else
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team] );

		thread maps\mp\gametypes\_playerlogic::showSpawnNotifies();
	}

	if ( !level.splitscreen && getIntProperty( "scr_showperksonspawn", 1 ) == 1 && game["state"] != "postgame" ) {
		self openMenu( "perk_display" );
		self thread maps\mp\gametypes\_playerlogic::hidePerksAfterTime( 4.0 );
		self thread maps\mp\gametypes\_playerlogic::hidePerksOnDeath();
	}

	prof_end( "spawnPlayer_postUTS" );
	waittillframeend;
	self.spawningAfterRemoteDeath = undefined;

	self notify( "spawned_player" );
	level notify ( "player_spawned", self );

	if(game["state"] == "postgame") {
		assert( !level.intermission );
		self maps\mp\gametypes\_gamelogic::freezePlayerForRoundEnd();
	}
}

registerScoreInfo( type, value )
{
	level.scoreInfo[type]["value"] = value;
}

_rank_init_edit() {
	level.scoreInfo = [];
	level.xpScale = getDvarInt( "scr_xpscale" );

	if ( level.xpScale > 4 || level.xpScale < 0)
		exitLevel( false );

    registerScoreInfo( "kill", 50 );
	registerScoreInfo( "headshot", 50 );
	registerScoreInfo( "assist", 10 );
	registerScoreInfo( "suicide", 0 );
	registerScoreInfo( "teamkill", 0 );
    registerScoreInfo( "final_rogue", 200 );
	registerScoreInfo( "draft_rogue", 100 );
	registerScoreInfo( "survivor", 100 );
	registerScoreInfo( "win", 1 );
	registerScoreInfo( "loss", 0.5 );
	registerScoreInfo( "tie", 0.75 );
	registerScoreInfo( "capture", 300 );
	registerScoreInfo( "defend", 300 );

	level.xpScale = min( level.xpScale, 4 );
	level.xpScale = max( level.xpScale, 0 );

	level.rankTable = [];
	level.weaponRankTable = [];

	precacheShader("white");

	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_WEAPON_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"RANK_PROMOTED_WEAPON" );
	precacheString( &"MP_PLUS" );
	precacheString( &"RANK_ROMANI" );
	precacheString( &"RANK_ROMANII" );
	precacheString( &"RANK_ROMANIII" );

	precacheString( &"SPLASHES_LONGSHOT" );
	precacheString( &"SPLASHES_PROXIMITYASSIST" );
	precacheString( &"SPLASHES_PROXIMITYKILL" );
	precacheString( &"SPLASHES_EXECUTION" );
	precacheString( &"SPLASHES_AVENGER" );
	precacheString( &"SPLASHES_ASSISTEDSUICIDE" );
	precacheString( &"SPLASHES_DEFENDER" );
	precacheString( &"SPLASHES_POSTHUMOUS" );
	precacheString( &"SPLASHES_REVENGE" );
	precacheString( &"SPLASHES_DOUBLEKILL" );
	precacheString( &"SPLASHES_TRIPLEKILL" );
	precacheString( &"SPLASHES_MULTIKILL" );
	precacheString( &"SPLASHES_BUZZKILL" );
	precacheString( &"SPLASHES_COMEBACK" );
	precacheString( &"SPLASHES_KNIFETHROW" );
	precacheString( &"SPLASHES_ONE_SHOT_KILL" );

	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );

	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );

		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	}

	weaponMaxRank = int(tableLookup( "mp/weaponRankTable.csv", 0, "maxrank", 1 ));
	for( i = 0; i < weaponMaxRank + 1; i++ )
	{
		level.weaponRankTable[i][1] = tableLookup( "mp/weaponRankTable.csv", 0, i, 1 );
		level.weaponRankTable[i][2] = tableLookup( "mp/weaponRankTable.csv", 0, i, 2 );
		level.weaponRankTable[i][3] = tableLookup( "mp/weaponRankTable.csv", 0, i, 3 );
	}

	level thread maps\mp\gametypes\_rank::patientZeroWaiter();
	level thread maps\mp\gametypes\_rank::onPlayerConnect();
}

Prestige_Logic() {
    if(self maps\mp\gametypes\_rank::getRankXP() == int(maps\mp\gametypes\_rank::getRankInfoMaxXP(79) - 1) && self.player_settings["prestige"] < level.maxPrestige) {
		var_1 = self maps\mp\gametypes\_rank::getRankForXp(0);
		self.pers["rank"] = var_1;
		self.pers["rankxp"] = 0;
		self.player_settings["xp"] = 0;

		var_2 = self.player_settings["prestige"] + 1;
		self.pers["prestige"] = var_2;

		self setRank( var_1, var_2 );

		self tell_raw("^8^7[ ^8Information ^7]: You Are Now Prestige ^8" + var_2);
        iprintln("^8" + self.name + "^7 is now Prestige: ^8" + var_2);

        self setclientdvar("inf_prestige", self.pers["prestige"]);
	}
}

Callback_PlayerDamage_hook(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {
    if(level.lastopfer != self.name) {
	    maps\mp\gametypes\_damage::Callback_PlayerDamage_internal( eInflictor, eAttacker, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
        level.lastopfer = self.name;
        wait .05;
        level.lastopfer = "";
    }
}

prematchPeriod_new() {
}

PushRegionThread(corner1, corner2, pushOrigin){
    level endon("game_ended");

    for(;;) {
        foreach (entity in level.Players) {
            if(insideRegionZ(corner1, corner2, entity.Origin))
                entity SetOrigin(pushOrigin);
        }

        wait 0.1;
    }
}

insideRegionZ ( A , B , C) {

    x1 = A[0];
    x2 = B[0];

    y1 = A[1];
    y2 = B[1];

    z2 = B[2];
    z = A[2];

    xP = C[0];
    yP = C[1];
    zP = C[2];

    return ((x1 < xP && xP < x2) || x1 > xP && xP > x2) && ((y1 < yP && yP < y2) || y1 > yP && yP > y2) && (zP < z2) && (zP > z);
}

event_handler() {
    switch(getdvar("mapname")) {
        case "mp_lambeth":
            add_map_xmodel((-1203.09,731.552,-249.091), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1035.63,730.318,-251.42), (0,125,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1519.4,804.703,-249), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1425.73,1393.71,-195.629), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-456.201,1771.39,-87.2701), (0,595,0), "wm_iw6_pumpkin");
            add_map_xmodel((-900.364,1237.77,-253.865), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((410.721,1650.28,-227.883), (0,515,0), "wm_iw6_pumpkin");
            add_map_xmodel((397.194,1653.21,-287.169), (0,110,0), "candle_holder_medium");
            add_map_xmodel((414.484,1638.02,-288.184), (0,0,0), "candle_holder_medium");
            add_map_xmodel((646.454,1545.46,-109.181), (0,0,0), "candle_holder_medium");
            add_map_xmodel((671.021,1517.18,-109.181), (0,0,0), "candle_holder_medium");
            add_map_xmodel((670.885,1572.42,-109.181), (0,0,0), "candle_holder_medium");
            add_map_xmodel((615.216,1571.09,-109.181), (0,0,0), "candle_holder_medium");
            add_map_xmodel((616.039,1516.5,-109.181), (0,0,0), "candle_holder_medium");
            add_map_xmodel((644.683,1452.76,-22.3686), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((921.2,1769.21,-50.875), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((662.104,1952.65,-50.875), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((2010.49,2510.25,-187.292), (0,585,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((73.5266,3108.03,-232.288), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((823.131,2649.87,-240.933), (0,335,0), "wm_iw6_pumpkin");
            add_map_xmodel((2219.54,1386.23,-126.399), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((2208.75,694.02,-213.476), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((2281.84,694.604,-264.289), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((2364.87,485.091,-283.803), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((2337.94,466.337,-344.635), (0,5,0), "candle_holder_medium");
            add_map_xmodel((2330.47,461.21,-344.855), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2352.82,308.457,-254.363), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((2073.26,-41.1369,-251.306), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((2058.12,-240.525,-91.8819), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1564.8,574.817,-299.998), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((1778.86,1107.81,-299.636), (0,350,0), "wm_iw6_pumpkin");
            add_map_xmodel((1778.2,1079.99,-299.955), (0,345,0), "wm_iw6_pumpkin");
            add_map_xmodel((1743.74,1085.8,-300.142), (0,345,0), "wm_iw6_pumpkin");
            add_map_xmodel((1750.24,1113.46,-298.967), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((0,0,0), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((0,0,0), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1288.78,985.825,-316.101), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((179.472,1140.21,400.8708), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            break;
        case "mp_rust":
            add_map_xmodel((226.123,105.458,-196.878), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-44.3408,1504.94,743.878), (0,300,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((524.247,1026.38,266.108), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((746.984,1110.4,266.129), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((583.16,-19.9948,-97.5344), (0,130,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1158.79,251.415,-202.456), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((1475.66,379.781,-198.456), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1408.53,999.408,-191.956), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((1164.78,1498.76,-196.956), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((141.272,903.268,-188.012), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-325.818,1313.3,-191.956), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-279.899,529.96,-167.967), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-58.5807,1711.39,-152.817), (0,525,0), "wm_iw6_pumpkin");
            add_map_xmodel((1972,1657.8,-124.618), (0,180,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1173.32,688.43,-5.39877), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((718.819,1353.65,10.7833), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((568.647,877.328,125.493), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((692.859,445.907,-117.848), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((244.108,85.22,-194.001), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((260.95,58.7246,-194.083), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((552.382,879.728,-163.183), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((878.761,4584.92,-153.278), (0,275,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1760.48,-325.878,-193.218), (0,135,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-395.284,1283.29,-254.161), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-253.263,1285.99,-259.044), (0,0,0), "candle_holder_medium");
            add_map_xmodel((130.911,900.318,-248.139), (0,0,0), "candle_holder_medium");
            add_map_xmodel((160.381,457.483,-263.888), (0,0,0), "candle_holder_medium");
            add_map_xmodel((332.472,434.291,-263.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((161.488,609.642,-263.892), (0,0,0), "candle_holder_medium");
            add_map_xmodel((256.757,619.22,-256.865), (0,0,0), "candle_holder_medium");
            add_map_xmodel((349.721,559.96,-256.475), (0,0,0), "candle_holder_medium");
            add_map_xmodel((215.224,116.51,-255.702), (0,0,0), "candle_holder_medium");
            add_map_xmodel((537.182,274.414,-228.772), (0,0,0), "candle_holder_medium");
            add_map_xmodel((490.502,414.844,-128.972), (0,0,0), "candle_holder_medium");
            add_map_xmodel((537.27,536.688,-72.96), (0,0,0), "candle_holder_medium");
            add_map_xmodel((490.34,655.421,10.3716), (0,0,0), "candle_holder_medium");
            add_map_xmodel((536.898,805.056,53.7579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((488.361,942.897,113.75), (0,0,0), "candle_holder_medium");
            add_map_xmodel((652.175,735.394,-40.8487), (0,0,0), "candle_holder_medium");
            add_map_xmodel((837.734,734.926,-48), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1048.23,683.984,-66.5361), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1184.04,795.09,-65.3131), (0,0,0), "candle_holder_medium");
            add_map_xmodel((923.607,978.816,-55.7726), (0,0,0), "candle_holder_medium");
            add_map_xmodel((963.35,1302.5,-77.8103), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1004.87,1632.76,-161.261), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1261.29,1638.75,-212.144), (0,0,0), "candle_holder_medium");
            add_map_xmodel((651.011,1653.02,-107), (0,0,0), "candle_holder_medium");
            add_map_xmodel((328.959,1686.72,-109.041), (0,0,0), "candle_holder_medium");
            add_map_xmodel((4.51418,1796.41,-108.642), (0,0,0), "candle_holder_medium");
            add_map_xmodel((158.34,1614.38,-157.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((22.3596,1304.22,-157.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-182.516,1439.04,-189.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((641.936,62.2603,-237.075), (0,0,0), "candle_holder_medium");
            add_map_xmodel((518.315,1111.11,206.134), (0,0,0), "candle_holder_medium");
            add_map_xmodel((651.644,1012.55,208.1), (0,0,0), "candle_holder_medium");
            add_map_xmodel((655.082,936.161,206.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((714.934,1116.51,206.135), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1441.13,419.382,-256.956), (0,0,0), "candle_holder_medium");
            add_map_xmodel((0.0328456,-124.183,-276.817), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-242.112,149.017,-242.919), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1680.99,1675.26,-202.848), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1758.63,1656.42,-187.42), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1833.88,1652.78,-178.021), (0,0,0), "candle_holder_medium");
            break;
        case "mp_underground":
            add_map_xmodel((-404.735,-878.396,44.0621), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-514.358,-629.743,44.0316), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-682.876,-433.825,51.5825), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-892.127,-8.81885,34.125), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-226.078,-1116.73,51.9527), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-100.014,-1469.1,37.1898), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((193.588,-1315.89,37.1903), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-128.24,-1232.31,37.2459), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((743.317,-1128.7,-111.875), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((615.763,-890.193,-189.875), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((308.227,-1131.57,8.11503), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((208.521,-421.614,57), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((196.016,-360.927,57), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((259.143,-370.314,57), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-176.845,-356.802,57), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-176.876,-417.748,57), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-115.069,-377.03,57), (0,15,0), "wm_iw6_pumpkin");
            add_map_xmodel((-834.867,-155.307,47.2343), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-852.501,265.921,-55.875), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1036.39,426.407,-55.875), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1398.14,457.314,-98.5), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1400.7,675.756,-168), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1050.57,1052.77,-215.875), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1179.68,1688.21,-215.949), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1578.05,1607.78,-110.065), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1677.64,1460.65,-109.951), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-725.104,1794.65,-234.688), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1001.18,2412.06,-255.875), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((-955.293,2687.44,-212.956), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1144.89,2684.55,-212.956), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1442.07,2556.47,-255.878), (0,625,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-705.996,2103.17,-274.514), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-569.964,2104.1,-183.826), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-606.863,1944.37,-208.425), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1414.12,1726.69,-264.3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1571.25,1508.45,-170.036), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1685.19,1550.64,-169.977), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1651.39,1465.93,-169.969), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1279.8,642.737,-203.008), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1239.58,569.696,-123.882), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1360.32,433.73,-116.284), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-851.513,-133.54,-27.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-921.576,-270.046,-25.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-758.221,-375.746,-8.38081), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-579.553,-533.122,-16.5909), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-461.726,-752.388,-16.3343), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-279.067,-991.943,-10.2222), (0,0,0), "candle_holder_medium");
            add_map_xmodel((248.51,-417.066,-3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((211.634,-349.18,-3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-137.443,-349.686,-3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-132.357,-421.223,-3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-188.384,-390.503,-3), (0,0,0), "candle_holder_medium");
            add_map_xmodel((145.606,-7.27653,-19.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((146.559,146.158,-117.438), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-82.6572,86.1067,-77.4044), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-81.0729,-40.714,-19.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-261.652,272.876,-106.791), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((356.963,182.341,-91.875), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((340.235,1112.26,-127.875), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((9.56993,1685.02,-234.809), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((54.5172,1452.45,-234.805), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-565.565,2400.19,-82.8941), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-454.491,3037.87,-95.875), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-442.615,3102.5,-95.875), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-612.169,2936.58,-93.875), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-124.427,2982.23,-95.875), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((114,2530.42,-95.875), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-48.5253,2179.9,-95.6525), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-327.81,1942.73,-95.875), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-128.37,2103.12,-155.888), (0,0,0), "candle_holder_medium");
            add_map_xmodel((113.7,2220.68,-155.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-47.034,2565.16,-155.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((113.024,2930.43,-155.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((346.8,2986.72,-155.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((858.221,2102.87,-133.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((989.301,1819.93,-87.875), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((993.962,1230.06,-81.3799), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((805.885,1547.7,-17.875), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((785.671,1945.97,-215.875), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-652.293,590.618,-191.325), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-738.73,1161,-255.875), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-806.593,1162.55,-255.875), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-930.283,687.745,-55.8872), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((1168.74,113.328,45.125), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1333.43,512.219,-23.5), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((1467.06,824.588,-89.875), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1172.5,1210.95,-81.875), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((1065.46,1370.86,-262.452), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1066.09,1239.39,-167.603), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1172.77,1349.08,-141.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((986.398,1759.26,-147.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((491.994,1160.84,-255.102), (0,100,0), "wm_iw6_pumpkinxl");
            break;
        case "mp_meteora":
            add_map_xmodel((-1260.5,2658.07,1583.13), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1259.05,2624.29,1523.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1258.35,2461.95,1523.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-804.263,2799.95,1601), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-649.329,2738.6,1601), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-671.459,2899.92,1601), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-617.227,2816.4,1541), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-760.788,2893.43,1541), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-765.861,2731.54,1541), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-458.837,2518.15,1537.71), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-322.128,2359.15,1533.81), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-252.347,2072,1534.78), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-313.629,1655.08,1584.54), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-477.034,1526.47,1574.15), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-531.027,1755.34,1600.46), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-478.371,1897.08,1580.45), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-490.581,2187.57,1588), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-482.841,2356.27,1588), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-615.266,2318.27,1588), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-598.577,1892.59,1593.62), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-772.012,2150.51,1585.13), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-773.307,2363.22,1585.15), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-885.191,2527.25,1601), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1714.37,1962.93,1568.45), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1873.68,2130.73,1568.45), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2211.07,2048.78,1552), (0,0,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-2281.91,1418.24,1589.09), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2056.1,1385.22,1556.86), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1874.25,1198.43,1578.71), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1763.5,1087.25,1578.83), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1895.63,1038.81,1578.88), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1842.44,704.163,1545.56), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1896.88,350.022,1554.86), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1591.83,517.796,1583), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1420.98,589.194,1583), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1544.14,736.885,1573.7), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1611.36,986.852,1493.09), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1808.58,1026.56,1518.89), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1779.43,1179.06,1518.73), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1940.29,1136.47,1518.78), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2072.82,1377.39,1496.86), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2106.53,1379.69,1498.61), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1633.86,1255.14,1501.92), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1631.24,1224.5,1500.19), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1296.94,1246.28,1493.4), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1361.94,884.339,1529.46), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1342.19,913.802,1531.68), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1270.23,623.754,1584.21), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1276.51,895.089,1591.25), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1347.95,279.787,1647), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1633.26,-358.486,1645.8), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1821.28,-479.6,1680.75), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1301.88,-668.567,1603.13), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((-756.396,-924.173,1629.13), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-764.558,-1416.42,1524.14), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-845.976,-1409.64,1466.4), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-759.424,-1400.64,1465.56), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-689.562,-1180.11,1535.38), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-793.323,-749.978,1575.63), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-708.796,-545.96,1573.98), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-595.791,-287.853,1571.07), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-306.71,-545.135,1610.24), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-77.3978,-286.963,1625.34), (0,0,0), "candle_holder_medium");
            add_map_xmodel((73.0965,-544.388,1621.68), (0,0,0), "candle_holder_medium");
            add_map_xmodel((305.307,-285.197,1593.16), (0,0,0), "candle_holder_medium");
            add_map_xmodel((506.078,-547.036,1571.27), (0,0,0), "candle_holder_medium");
            add_map_xmodel((809.402,-615.965,1573.49), (0,0,0), "candle_holder_medium");
            add_map_xmodel((930.27,-475.817,1575.83), (0,0,0), "candle_holder_medium");
            add_map_xmodel((678.213,-146.099,1572.98), (0,0,0), "candle_holder_medium");
            add_map_xmodel((540.188,174.297,1574), (0,0,0), "candle_holder_medium");
            add_map_xmodel((382.928,387.716,1573.42), (0,0,0), "candle_holder_medium");
            add_map_xmodel((238.948,687.576,1576.98), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-94.6027,690.666,1576.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-458.284,691.774,1577.17), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-405.861,692.664,1636.13), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((-172.746,688.898,1636.13), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((203.838,688.274,1636.13), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((340.844,487.548,1630.64), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((575.763,117.479,1634.51), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((670.905,-174.163,1632.24), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((590.028,-548.648,1634.05), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((191.151,-544.726,1668.77), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((49.8769,-286.687,1681.49), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-433.614,-549.672,1652.64), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-704.385,-287.493,1633.38), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-789.143,-33.5219,1633.08), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((-655.807,258.804,1630.71), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-420.657,822.313,1624.44), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-22.5078,1138.86,1600.13), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-168.822,1039.58,1600.13), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-96.9895,1467.79,1636.13), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((257.027,1354.87,1624.44), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((491.789,1151.62,1627.09), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((889.098,1053.37,1764.09), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((888.452,801.242,1764.09), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((643.04,716.809,1782.13), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1010.31,588.304,1761.09), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((1079.84,896.435,1761.09), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((1268.71,1423.11,1947.73), (0,280,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1126.22,1131.87,2166.79), (0,225,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((800.863,1459,2205.98), (0,155,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1570.01,1583.2,2400.92), (0,230,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1619.24,1477.13,1681.34), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1906.21,1462.44,1680.62), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1587.95,1718.02,1680.56), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1594.63,1830,1740), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1696.07,1463.49,1740), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((2183.96,1587.08,1744.09), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((2087.39,2090.88,1744.09), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((1522.43,2343.54,1744.09), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((1096.4,2360.63,1749), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((920.97,2362.25,1749), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((331.858,2108.78,1602.43), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((35.2884,2262.34,1634.82), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-184.858,2544.64,1642.48), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((82.7447,1795.36,1627.05), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((316.065,1552.21,1629.41), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-257.4,2950.41,1632), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-309.923,3004.1,1731.71), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-719.252,1126.09,1627.09), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1839.1,1097.16,1729.08), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((1157.91,-218.831,1587.15), (0,175,0), "candle_holder_medium");
            add_map_xmodel((1306.81,-60.6454,1681.33), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1503.11,-120.213,1768.27), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1609.93,24.0532,1837.55), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1646.86,146.482,1832.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1908.45,-186.459,1851.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2141.68,-107.729,1851.15), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2238.59,-72.9775,1911.13), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((1778.43,-229.42,1911.11), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((1646,-94.8549,1920.21), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((1494.16,-9.15684,1837.49), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1340.15,-170.089,1741.08), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((1164.12,-99.0073,1666.25), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((1671.09,70.5438,1892.13), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((1353.88,157.963,1865.13), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((962.804,9.77325,1865.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((998.196,-42.6938,1829.13), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((983.785,-36.5876,1811.33), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1136.68,-6.30543,1805.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1310.38,62.3677,1804.9), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1584.33,-357.061,1844.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1410.78,-324.796,1844.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1196.66,-354.237,1844.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1201.7,-323.953,1904.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1291.81,-361.721,1866.13), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((1576.11,-340.907,1904.13), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1825.14,-581.53,1622.13), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((1998.37,-336.386,1622.13), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((1997.17,-398.526,1563.95), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1933.95,-579.11,1562.69), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1729.36,-580.451,1562.11), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2613.29,-642.376,1369.05), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((2626.66,-682.418,1309.13), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2568.68,-655.355,1306.63), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2582.55,-697.06,1311.96), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1686.12,-761.854,1576.13), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((1068.94,-712.622,1576.15), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((694.553,371.396,1616.13), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((519.946,1327.88,1770.13), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((884.987,1335.4,1770.13), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((688.303,1526.57,1640.13), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-24.0363,2788.83,1625.02), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((213.768,2983.88,1634.02), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((432.403,2968.12,1608.13), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((737.411,3320.95,1640.5), (0,225,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((814.676,3112.41,1558.56), (0,0,0), "candle_holder_medium");
            add_map_xmodel((809.567,2664.91,1576.31), (0,0,0), "candle_holder_medium");
            add_map_xmodel((315.771,-2411.29,839.097), (0,105,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-535.064,-2950.56,1231.96), (0,80,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1165,-3479.7,1731.68), (0,120,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-1228.12,-1238.49,2355.01), (0,410,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((2580.37,-1476.24,2525.3), (0,120,0), "wm_iw6_pumpkinxxl");
            break;
        case "mp_dome":
            add_map_xmodel((-172.303,1245.7,-194.578), (0,310,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((115.716,-40.7448,-174.5), (0,490,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((753.365,-81.9968,-362.226), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((216.981,255.38,-350.891), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-64.3106,173.857,-361.375), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-500.787,406.566,-367.261), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-524.392,459.302,-363.672), (0,335,0), "wm_iw6_pumpkin");
            add_map_xmodel((-554.389,385.014,-370.697), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-625.294,-75.7975,-367.721), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((-581.816,-56.0548,-367.025), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((-366.633,-133.866,-304.885), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((433.556,183.154,-292.869), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((888.663,475.582,-334.507), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((1148.29,571.216,-229.966), (0,65,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1615.51,1416.56,-214.053), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((1397.11,1698.52,-214.053), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((475.244,2331,-214.053), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((23.9116,1794.94,-238.668), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-296.874,1841.36,-250.263), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1165.01,1328.98,-383.803), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1125.53,1236.74,-384.101), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-864.696,674.299,-421.184), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((-203.286,673.665,-310.921), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-25.7906,1861.72,-254.297), (0,290,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-163.813,-104.051,-367.845), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-782.831,51.5668,-370.62), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((740.96,1083.69,-262.875), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((928.931,2030.38,-254.875), (0,900,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1053.73,2456.45,-214.053), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((996.642,2468.84,-214.053), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((1408.31,2090.85,-211.956), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((1010.67,1842.78,-282.067), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1388.18,1710.35,-274.053), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1264.97,945.703,-327.728), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1020.76,571.348,-383.884), (0,0,0), "candle_holder_medium");
            add_map_xmodel((998.216,447.494,-383.873), (0,0,0), "candle_holder_medium");
            add_map_xmodel((473.011,211.255,-215.727), (0,0,0), "candle_holder_medium");
            add_map_xmodel((290.644,392.857,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((6.10976,397.091,-215.72), (0,0,0), "candle_holder_medium");
            add_map_xmodel((175.366,325.254,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((338.626,232.277,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-94.0751,247.236,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-245.27,247.227,-215.932), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-255.58,94.12,-215.927), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-347.74,-32.6041,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-230.863,-133.485,-215.579), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-386.521,-199.635,-215.621), (0,0,0), "candle_holder_medium");
            add_map_xmodel((529.785,306.252,-352.914), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((333.843,1036.19,-331.289), (0,0,0), "candle_holder_medium");
            add_map_xmodel((72.1663,840.68,-324.386), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-468.461,1612.78,-311.863), (0,0,0), "candle_holder_medium");
            break;
        case "mp_plaza2":
            add_map_xmodel((-1503.48,851.137,848.105), (0,395,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1192.54,888.414,848.105), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1813.8,72.9332,834.295), (0,365,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1829.6,57.3458,844.326), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1811.03,43.9171,822.883), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1813.67,11.5963,833.315), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1831.56,-3.69166,844.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1808.83,-24.2904,820.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1814.24,-207.447,832.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1830.82,-223.246,844.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1808.63,-239.722,820.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1832.15,-271.572,844.575), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1810.05,-287.626,832.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-891.858,-90.8188,829.961), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-891.691,106.811,829.915), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1428.5,339.178,856.125), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1559.49,-661.673,858.728), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1555.84,-700.192,858.728), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-848.429,-587.347,872.358), (0,215,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-685.671,-1212.45,810.728), (0,190,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((142.75,-1422.64,640.125), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((-559.771,-1310.68,651.006), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((687.558,-1647.6,683.044), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((715.067,-1648.3,683.044), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((276.915,-1753.34,793.682), (0,670,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((924.072,-907.987,678.829), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((948.616,-907.441,678.855), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((651.056,-1289.6,666.649), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((650.078,-1259.94,666.684), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((940.288,-1254.69,663.569), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((850.034,-1348.28,661.283), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((850.965,-1403.67,664.526), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((1115.57,-1270.17,677.86), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((962.189,-1051.2,661.432), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((963.329,-1074.74,661.457), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((740.585,-629.721,656.125), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((85.259,-877.97,730.97), (0,355,0), "wm_iw6_pumpkin");
            add_map_xmodel((-392.275,-638.192,668.633), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-398.204,-596.275,668.649), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-399.547,-741.001,668.657), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-395.541,-500.396,668.626), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-460.878,-423.701,735.18), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1077.2,-229.959,714.121), (0,95,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1432.29,205.349,626.304), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1432.36,236.095,626.312), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1760.75,-180.115,651.243), (0,0,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-784.565,1101.28,750.981), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((542.405,997.208,694), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((529.158,834.768,694), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-221.804,982.543,662), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((300.525,911.504,1024), (0,540,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((432.013,2033.86,807.125), (0,200,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-774.834,2175.88,841.648), (0,305,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-273.725,1015.21,662), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-305.37,965.518,662), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-17.2316,765.17,652.14), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((279.88,30.2147,739.125), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((39.5503,-291.871,694), (0,340,0), "wm_iw6_pumpkin");
            add_map_xmodel((-27.31,-235.553,694), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((985.574,-380.45,689.439), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((211.2,450.555,694), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-344.679,803.979,847.469), (0,460,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1116.45,1133.8,840.981), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-417.673,476.886,850.625), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-357.713,-437.962,829.774), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-51.1072,-764.747,830.857), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((133.911,-1126.44,881.963), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((338.054,-1050,880.101), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((430.254,-1002.25,877.642), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((500.577,-969.614,878.847), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((230.249,-1101.19,874.163), (0,115,0), "wm_iw6_pumpkin");
            break;
        case "mp_carbon":
            add_map_xmodel((-584.73,-2683.2,3987.65), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((-440.132,-2968.52,3991.04), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-74.2592,-3139.87,3965.85), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-355.197,-3612.43,3943.34), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-642.951,-3998.31,3967), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-685.287,-3682.74,3960.35), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((-892.266,-3693.46,3965.04), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((-920.258,-3856.41,3965.04), (0,15,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1135.86,-3698.2,3962.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1134.94,-3815.27,3962.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-948.627,-3557.61,3973.04), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1086.43,-3344.05,3965.04), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1343.79,-3476.53,3962.95), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1987.78,-3573.65,4137.99), (0,295,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-2437.57,-4145.38,3779.18), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2510.03,-4026.4,3779.67), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2425.83,-3645.15,3785.54), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2543.83,-3461.13,3785.65), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1992.72,-3480.69,3801.36), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1892.07,-3532.21,3801.75), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1671.62,-3292.42,3779.14), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1745.5,-3317.74,3780.42), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2927.25,-3195.67,3796.75), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3238.33,-3062.72,3786.85), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3666.9,-3023.64,3794.13), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3664.31,-3328.2,3611.04), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3802.22,-3189.08,3658.95), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3405.84,-4100.42,3684.57), (0,475,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-3708.23,-4420.33,3614.03), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3601.86,-4717.65,3633.06), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3401.8,-4642.04,3626.05), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3296.99,-4675.35,3752.13), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3302.79,-4743.87,3752.13), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2552.68,-4775.92,3785.64), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2691.46,-4806.85,3788.27), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2697.64,-4872.79,3785.94), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2668.03,-4105.2,4044.93), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2051.31,-4023.29,3794.23), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1892.18,-3840.72,3812.76), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1922.61,-3833.11,3812.78), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1903.72,-4102.56,3929.63), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1896.9,-3546.62,3959.04), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2080.41,-3211.63,3946.96), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2082.2,-3289.22,3946.22), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((336.095,-3570.38,3993.1), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((425.191,-3092.77,3993.1), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((702.937,-3735.28,3924.14), (0,195,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-867.824,-4568.55,3928.59), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-908.237,-4656.86,3922.18), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-633.725,-4950.22,3948.13), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-337.992,-4227.94,3960.09), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1683.15,-4298.92,3861.31), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1607.02,-4507.37,3860.15), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1332.14,-4658.4,3937.27), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2915.52,-3861.43,3787.04), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2858.03,-3589.19,3714.14), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2714.52,-2953.72,3787.77), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1380.37,-3171.82,3801.26), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1547.88,-3776.86,3791.43), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3108.92,-3738.28,3647.87), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3392.55,-3204.02,3627.09), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3500.27,-3531.32,3640.04), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3511.61,-3496.6,3640.06), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3488.32,-3116.23,3658.95), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2995.72,-3030.54,3797.13), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2995.45,-2997.38,3796.95), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2997.32,-2964.38,3797.2), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2310.58,-3278.6,3953.13), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2320.63,-3669.09,3959.04), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1928.45,-3745.87,3953.04), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1831.99,-3665.36,3953.13), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1494.57,-3533.97,3953.13), (0,320,0), "wm_iw6_pumpkin");
            break;
        case "mp_nuked":
            add_map_xmodel((1478.73,1025.49,-43.7598), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-267.029,475.369,-61.0021), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-253.659,488.338,-60.9995), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((-174.157,541.105,-61.0041), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-192.664,533.178,-60.9903), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-238.108,519.048,37.3528), (0,690,0), "wm_iw6_pumpkin");
            add_map_xmodel((1.3806,822.865,-2.1329), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((166.079,940.643,-1.73074), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((581.197,590.104,5.35351), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((805.068,444.764,4.83594), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((876.763,372.34,-9.57583), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((802.316,140.484,-6.98516), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((648.388,328.077,-13.3792), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((653.185,292.115,-16.8991), (0,10,0), "wm_iw6_pumpkin");
            add_map_xmodel((-218.124,-394.62,0.303239), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-38.3963,-1519.6,-65), (0,90,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-1062.25,2059.42,804.235), (0,305,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-506.684,212.574,-14.8724), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-628.409,15.0619,-21.5104), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-642.059,-27.5231,-21.583), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1091.3,367.287,-21.375), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1293.7,1044.71,16.1323), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1189.58,1089.5,-68.7866), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1186.95,777.991,115.125), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1152.34,439.424,115.125), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1012.03,486.71,114.603), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-856.657,368.279,121.425), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-592.978,500.096,119.579), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-338.838,598.491,125.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1107.59,130.934,136.659), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((925.225,399.172,141.344), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((762.499,230.917,79.125), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((680.566,287.686,146.183), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((614.088,98.9233,121.259), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((621.892,57.5368,103.077), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((748.51,125.708,140.85), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((1376.19,249.144,115.125), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((1232.92,507.537,115.125), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((1470.94,551.741,-27.875), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1073.54,71.7586,-6.51961), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((565.116,-28.8954,-16.8723), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((243.953,-316.949,-60.7), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-634.481,628.473,92.4304), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-666.504,533.731,-19.9526), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1037.8,469.317,-14.875), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-765.069,626.26,-12.7075), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-904.067,670.178,-41.2253), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((-938.072,647.601,-41.1885), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-752.047,339.986,-35.9719), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-656.812,308.106,-36.1295), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-504.369,396.08,-56.875), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((151.794,181.168,100.044), (0,320,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1511.56,985.563,-39.0909), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-242.407,498.457,-120.996), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-203.168,521.812,-121.04), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-240.687,486.026,-121.159), (0,0,0), "candle_holder_medium");
            add_map_xmodel((55.1726,285.141,-95.7561), (0,0,0), "candle_holder_medium");
            add_map_xmodel((165.387,390.717,-97.3616), (0,0,0), "candle_holder_medium");
            add_map_xmodel((158.597,364.116,-37.1706), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-11.1994,746.069,-88.8452), (0,0,0), "candle_holder_medium");
            add_map_xmodel((569.325,150.39,-60.375), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((823.257,158.507,-84.7803), (0,0,0), "candle_holder_medium");
            add_map_xmodel((833.301,327.567,-79.9526), (0,0,0), "candle_holder_medium");
            add_map_xmodel((920.177,373.305,-82.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1038.26,111.644,-14.875), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((1455.62,545.04,-87.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1216.11,897.228,-121.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1354.14,331.285,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1321.84,441.009,-16.0529), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1237.34,211.597,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1251.5,435.348,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1129.16,499.658,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1079.74,381.154,51.366), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1057.68,396.097,100.826), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((817.63,124.037,-54.4338), (0,0,0), "candle_holder_medium");
            add_map_xmodel((859.657,136.311,-26.2355), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-438.015,438.489,-88.8938), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1271.78,536.162,-52.9299), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1224.5,666.426,40.0109), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1129.66,756.519,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1031.95,720.601,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1178.96,584.192,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1107.78,424.782,55.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2016.62,678.396,-21.8327), (0,300,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-838.326,935.731,-66.875), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-530.207,823.644,-50.9499), (0,0,0), "candle_holder_medium");
            add_map_xmodel((215.015,-587.856,-13.7761), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-66.6142,-576.124,-19.3701), (0,165,0), "wm_iw6_pumpkin");
            break;
        case "mp_seatown":
            add_map_xmodel((432.899,787.552,174.125), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((369.708,389.131,254.771), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-57.3024,120.529,218.271), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((38.7213,-433.012,212.544), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((493.502,-323.878,212.044), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((1076.59,-1102.5,233.249), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((1139.38,-1193.56,233.279), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((1198.2,-1103.78,233.036), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((1345.84,-1328.9,237.158), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1102.74,537.764,240.006), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((1284.26,534.984,240.125), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((853.709,1193,201.703), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((-239.196,1049.45,115.036), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-742.96,959.487,197.066), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-738.045,1039.17,191.731), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-732.844,1269.07,158.114), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1222.83,1363.2,248.105), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-983.681,858.751,320.119), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-984.117,944.94,320.137), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-984.722,1038.1,320.125), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-985.264,1133.71,320.123), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-591.063,401.641,347.044), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((161.05,408.624,356.304), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((30.1135,1254.4,326.125), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((114.621,1252.5,325.857), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((29.8693,843.65,326.125), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((114.031,986.811,326.049), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((-604.418,592.337,298.122), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((-700.874,-1562.72,188.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-661.672,-1526.49,188.125), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1987.49,-1795.5,211.608), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2434.57,-1821.72,309.453), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2417.26,-1876.14,309.443), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2417.29,-1773.26,309.442), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2361.15,-1763.2,309.449), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2363.69,-1888.62,309.442), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2175.8,-1268.07,309.463), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2108.27,-1267.33,309.459), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1560.16,-1292.66,322.125), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1563.09,-1425.63,322.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2130.15,-801.146,158.131), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2130.28,-680.931,158.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2260.76,-212.408,188), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2103.27,40.4195,240), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2382.75,-31.5976,240.15), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2357.23,222.814,239.969), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2265.32,84.8432,900), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            add_map_xmodel((-1729.37,760.394,259.125), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1592.46,759.83,259.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1216.13,477.675,335.71), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1533.85,354.141,207.359), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1332.87,-261.229,214.772), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1164.45,-163.636,214.772), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((-600.072,-616.971,249.125), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((-548.002,542.782,183.029), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-828.21,128.892,212.096), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((-145.788,321.584,168.125), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((122.332,177.072,168.125), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-88.5956,510.482,214.095), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-267.908,464.056,248.125), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1171.69,1132.73,34.1491), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1851.54,1470.13,91.0437), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2073.46,1455.1,200.075), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1877.43,1098.86,236.125), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1045,355.905,350.772), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((654.065,-166.081,248.125), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((790.606,-215.538,248.122), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1187.6,-585.403,276.125), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((146.109,-1225.8,242.063), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-318.602,-1190.36,231.386), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-307.017,-1155.85,231.386), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1388.88,-1214.65,188.503), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1916.43,-1316.65,172.12), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1881.44,-1313.56,172.186), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1925.34,-1628.95,184.508), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2385.8,-1186.17,202.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2433.79,-1220.93,309.374), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2051.97,-1057.12,309.437), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1827.1,-908.974,333.402), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1905.5,-912.63,334.125), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1715.83,-491.143,112.125), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1427.04,-492.614,186.044), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1443.1,66.3439,214.772), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2128.01,-746.114,98.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2129.8,-492.638,170.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2186.1,-63.5438,179.976), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2427.13,105.468,180.25), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2205.13,238.315,180.226), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1663.51,761.03,199.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1404.71,760.069,163.118), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-880.086,353.662,280.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-664.369,354.026,280.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-328.373,333.513,293.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-380.826,333.728,293.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((194.605,487.769,292.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-188.919,688.307,295.625), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-82.5726,760.068,295.625), (0,0,0), "candle_holder_medium");
            add_map_xmodel((141.493,760.743,295.625), (0,0,0), "candle_holder_medium");
            add_map_xmodel((26.2184,962.685,266.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((113.986,1130.09,264.163), (0,0,0), "candle_holder_medium");
            add_map_xmodel((28.6793,1189.4,266.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-83.8796,526.903,154.095), (0,0,0), "candle_holder_medium");
            add_map_xmodel((334.729,325.815,194.772), (0,0,0), "candle_holder_medium");
            add_map_xmodel((508.519,-27.8686,220.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1011.87,-50.5461,224.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1187.11,-516.532,216.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1327.72,-479.754,216.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1113.69,-1067.19,173.529), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1184.43,-1167.94,173.907), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1088.35,-1169.87,173.736), (0,0,0), "candle_holder_medium");
            add_map_xmodel((169.808,-1224.88,182.063), (0,0,0), "candle_holder_medium");
            add_map_xmodel((189.877,-1214.45,182.063), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-378.964,-1233.48,216.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-542.146,-1232.22,216.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-674.82,-1023.39,188.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-564.221,-615.355,172.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-769.171,-813.41,202.063), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((-764.065,-643.784,330.125), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-808.405,-626.89,272.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-903.841,-626.008,272.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-994.369,-809.454,325.788), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-950.475,-729.815,326.404), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1954.64,-1355.45,124.508), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2381.27,-1172.79,142.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2412.96,-637.195,212.801), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2223.16,-1035.12,258.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2030.01,-1181.99,258.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1432.33,56.4343,154.771), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-1295.33,-254.41,154.772), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-2265.32,84.8432,100), (0,0,0), "wm_iw6_pumpkinxxl", "music");
            break;
        case "mp_terminal_cls":
            add_map_xmodel((2137.47,6042.48,224.125), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((2267.49,6009.86,224.125), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((2342.38,5447.73,224.125), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((2521.77,5449.61,224.125), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((2453.78,4879.23,213.183), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((2430.05,4876.88,212.773), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((2342.58,4798.94,213.273), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((2344.59,4732.66,213.19), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((2104.73,4454.74,208.681), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((1905.03,4626.28,213.657), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1900.88,4658.49,213.327), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((2516.05,4754.59,212.549), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((2515.14,4797.77,212.303), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((2898.22,4706.72,213.522), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((2826.61,4671.04,213.643), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((2864.5,5049.76,213.578), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((2024.17,5057.58,208.681), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((2000.36,5059.9,208.491), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((1577.23,4806.83,212.76), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((1555.24,4806.1,212.563), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((1191.83,4807.45,212.928), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((1043.33,4803.78,211.935), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((756.315,5019.54,213.151), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((843.028,5020.9,212.834), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((1459.64,4948.57,232.441), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((1694.2,2343.07,449.199), (0,120,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1240.2,3645.77,20.1055), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1216.69,3646.21,80.1055), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((1094.21,3649.77,80.1055), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((877.244,3487.53,111.654), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((545.945,3780.18,223.051), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((610.505,4289.36,156.556), (0,95,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1503.29,3928.72,75.6378), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1562.77,3713.02,79.3773), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((1718.34,3091.08,111.654), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((2214.5,2783.27,80.1055), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((2524.26,3362.53,84.125), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((2407.62,3439.6,64.441), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((2115.5,3382.16,89.125), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((2001.77,3812.55,84.125), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((2180.41,3867.9,84.125), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((2663.26,4031.2,64.6806), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((2666.37,3819.57,64.644), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((2213.49,4275.73,304.131), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((1160.9,4975.79,192.125), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-181.204,4809.84,244.125), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-236.248,4813.13,248.637), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-296.034,4809.01,244.125), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-353.404,5005.86,263.421), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-370.382,5119.92,250.074), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-175.399,5436.25,236.125), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((324.855,5100.79,240.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((127.275,5545.78,223.157), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1033.32,6044.41,401.76), (0,485,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((802.392,5541.36,208.217), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((668.468,5543.46,208.427), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((643.349,5547.06,208.681), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((543.054,5644.54,208.387), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((591.978,5934.83,208.598), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((1407.87,6934.1,226.091), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((1181.69,7036.04,226.091), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((965.584,6930.03,226.091), (0,245,0), "wm_iw6_pumpkin");
            add_map_xmodel((484.928,7013.08,234.102), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((986.922,8127.9,246.551), (0,270,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1843.15,7206.32,192.112), (0,185,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1981.62,7387.87,192.132), (0,215,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1940.2,7107.24,192.125), (0,160,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((2040.02,7295.41,192.125), (0,520,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1521.67,6398.82,226.091), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((1593.4,5791.88,223.935), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((1949.66,6038.39,211.805), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1325.18,2627.97,154.813), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((658.184,2857.72,202.625), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((561.457,3118.74,220.52), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((560.47,3456.91,220.812), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((677.878,3590.47,223.084), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((604.034,4260.47,252.78), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((498.943,4626.32,79.2396), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((492.704,4595.83,19.2396), (0,0,0), "candle_holder_medium");
            add_map_xmodel((228.268,4498.76,51.839), (0,0,0), "candle_holder_medium");
            add_map_xmodel((228.7,4346.25,172.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((274.829,4284.64,172.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((630.48,4257.16,191.881), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1158.88,3644.48,20.1055), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1501.35,3955.61,15.6378), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2000.73,3675.09,24.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2375.13,4242.92,54.009), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2314.59,4413.51,167.879), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2549.68,4412.64,167.933), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2662.4,4427.5,164.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2286.11,4699.58,176.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2494.47,4849.76,176.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2591.58,4700.01,176.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2896.17,4781.68,158.625), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2450.89,5392.66,164.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2431.63,5554.11,164.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2360.92,5485.57,164.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((2195.9,6006.21,164.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1953.14,6017.97,164.529), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1209.25,5712.9,168.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((823.571,5787.84,172.43), (0,0,0), "candle_holder_medium");
            add_map_xmodel((292.154,5319.39,180.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((289.657,5152.4,179.834), (0,0,0), "candle_holder_medium");
            add_map_xmodel((387.344,5094.01,180.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((-95.1482,5418.04,183.125), (0,0,0), "candle_holder_medium");
            add_map_xmodel((783.567,4844.94,172.375), (0,0,0), "candle_holder_medium");
            add_map_xmodel((1479.96,4905.51,172.429), (0,0,0), "candle_holder_medium");
            add_map_xmodel((495.529,4083.06,202.125), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((329.612,4391.54,238.375), (0,80,0), "wm_iw6_pumpkin");
            break;
        case "mp_hardhat":
            add_map_xmodel((1621.75,1381.77,353.044), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((1702.01,974.539,320.094), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((1746.02,824.758,370.125), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((1950.28,944.193,362.844), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((1859.84,609.917,362.844), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((1798.76,123.826,368.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((1836.72,135.903,320.125), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1871.42,-417.807,332.116), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((1956.09,-684.394,295.881), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((2090.46,-891.977,348.772), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1879.26,-1161.27,379.556), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((1900.86,-1165.73,379.638), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((1259.91,707.432,281.857), (0,595,0), "wm_iw6_pumpkin");
            add_map_xmodel((1261.96,948.568,179.994), (0,270,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((986.777,508.252,295.195), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((867.032,509.742,295.195), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((664.421,871.751,393.611), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((159.492,776.212,418.844), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((193.012,1154.47,412.503), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((1044.77,930.722,416.129), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1009.61,897.384,416.131), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((1350.61,1426.28,367.426), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((999.945,486.318,376.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((1004.62,466.966,376.125), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((1034.78,580.724,447.129), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-132.489,43.3308,299.917), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-782.193,-0.212248,218.204), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-821.702,61.0355,217.357), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1066.04,-294.913,224.244), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((189.868,-283.917,331.044), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((249.967,-251.947,331.044), (0,370,0), "wm_iw6_pumpkin");
            add_map_xmodel((231.89,-54.7501,331.044), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((734.752,-28.5862,336.917), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((1248.63,-248.641,281.123), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((656.731,-538.492,331.044), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((1003.57,-979.339,354.126), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((852.934,-1684.09,333.648), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((1484.46,-1324.27,338.27), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1825.41,-1342.45,333.157), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-94.7991,-1501.86,331.044), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-373.424,-1055.33,336.076), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-523.484,-1107.61,331.044), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-211.098,-1369.67,336.125), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-726.1,-815.267,328.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-903.458,-811.508,328.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-404.656,-181.27,453.054), (0,180,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-406.956,-334.529,460.14), (0,165,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((726.773,392.115,1060.56), (0,485,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((1758.07,147.537,181.558), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((1736.52,145.327,181.834), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((2058.07,433.675,226.844), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((2020.13,401.873,226.844), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((2068.07,709.694,257.117), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((2052.4,597.964,320.137), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((2018.54,601.465,321.117), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((2067.46,-105.328,268.081), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((1093.14,-1658.01,325.447), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((674.796,-1481.81,340.42), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((789.824,-1180.45,285.307), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((799.374,-1235.33,285.262), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1259.39,-663.875,184.317), (0,90,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1425.66,1219.76,328.575), (0,340,0), "wm_iw6_pumpkinxl");
            break;
        case "mp_paris":
            add_map_xmodel((259.044,-574.284,53.6196), (0,370,0), "wm_iw6_pumpkin");
            add_map_xmodel((250.933,-546.765,54.5324), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((245.504,-633.378,43.0882), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((220.408,-1020.25,68.125), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((913.258,-411.838,39.125), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((903.384,-677.746,37.825), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((1199.08,-533.642,36.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((952.234,-739.508,37.825), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((764.313,-807.239,146.125), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((561.046,-953.794,146.125), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((569.83,-833.629,146.125), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((284.093,-1017.93,185.42), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-541.343,-1058.66,48.0309), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-338.408,-852.123,39.7147), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((41.2826,-1056.05,8.00001), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1105.74,-1098.72,48.9799), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1399.71,-779.614,96.625), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1434.66,-1051.55,96.625), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1568.73,-931.115,94.625), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1931.39,-769.164,129.625), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1810.24,-931.74,129.625), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1958.18,-294.019,147.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1957.46,-251.343,147.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2037.54,214.468,223.125), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2038.42,106.566,223.139), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1950.33,550.95,224.619), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1885,548.9,224.311), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2070.81,633.044,289.01), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1876.96,631.243,289.042), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2103.47,875.781,295.105), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1220.8,2016.88,229.671), (0,280,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-334.671,1927.43,237.376), (0,205,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1851.6,1884.96,21.9834), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1832.4,1693.36,-13.7483), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((1818.78,1673.88,-13.7443), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((1570.3,1633.94,48.125), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((1558.28,1969.42,-11.7157), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((1712.43,1391.58,-16), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((1427.08,1240.86,-16), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((1425.88,1384.65,-16), (0,15,0), "wm_iw6_pumpkin");
            add_map_xmodel((1678.6,833.099,28.9809), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((1781.76,1001.97,32.125), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1623.55,1092.13,144.125), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((1460.76,1092.91,144.125), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((904.477,1225.21,144.125), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((798.703,1088.02,130.125), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((796.01,1654.2,32.1304), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((903.439,1653.25,32.1311), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((335.616,1147.62,0.175302), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-276.582,-91.0341,41.8691), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((-504.8,441.43,102.927), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-787.695,314.619,79.579), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-605.624,159.242,79.2858), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((-946.732,177.614,79.2816), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-946.763,145.857,79.2816), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1165.08,-348.64,100.832), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((1225.04,113.385,11.7738), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1389.37,550.042,21.9485), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((1304.92,545.841,21.7577), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((1025.2,976.748,30.125), (0,330,0), "wm_iw6_pumpkin");
            add_map_xmodel((958.454,972.225,30.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1541.72,695.521,400.7781), (0,10,0), "wm_iw6_pumpkinxxl", "float");
            add_map_xmodel((-104.219,981.792,100.402), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-96.1457,912.032,142.125), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((62.4092,899.235,124.721), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((93.0149,864.187,124.528), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-139.168,349.078,142.125), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-270.336,497.493,103.125), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-270.296,421.988,103.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-843.592,690.829,85.139), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1196.45,1356.58,152.476), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1714.76,1417.32,287.906), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2235.04,1670.31,317.52), (0,20,0), "wm_iw6_pumpkin");
            break;
        case "mp_showdown_sh":
            add_map_xmodel((-274.325,-112.869,47.181), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((-183.583,376.256,47.181), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((173.215,472.831,23.181), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((556.492,231.893,23.8685), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((381.97,-294.135,61.1009), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((1034.13,-129.019,78.1009), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1059.12,-858.509,52.125), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((635.419,-577.972,66.0012), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((1036.95,-1200.76,66.0012), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((738.426,-1150.72,41.0435), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((389.744,-1447.67,66.0012), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6.01985,-2070.99,400.143), (0,450,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-620.561,-1432.35,55.3342), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-969.825,-301.273,16), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-935.905,-301.754,16), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1031.18,-213.757,220.125), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-887.068,-348.139,220.125), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-617.664,-280.799,224.125), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-0.485572,62.7115,377.776), (0,270,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-96.2483,870.783,63.181), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((92.7755,1098.06,63.181), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((255.618,1657.22,49.0475), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((782.606,1156.68,36.125), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((549.503,873.349,36.125), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((387.119,836.651,140.125), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((4.69977,2202.26,-2), (0,270,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-841.118,596.513,16), (0,195,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-669.486,1156.36,36.1232), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-867.977,1154.32,36.1129), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-866.627,1026.92,36.1503), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-668.634,1028.26,36.1318), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((82.7671,1575.97,-11.9881), (0,215,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((848.145,460.398,220.125), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((1016.45,457.88,219.605), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((1141.32,99.8084,184), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((1143.6,-140.832,184), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((1145.04,-517.877,184), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((643.468,-538.728,184), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((805.432,-506.601,184), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((824.142,-241.471,184.125), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((821.652,42.0108,184), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((954.572,-542.386,192.125), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((806.362,-1017.17,82.3024), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-456.738,-1111.81,522.125), (0,310,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-35.2897,1073.97,63.181), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-618.782,-221.463,48.125), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-269.094,-508.853,16.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((161.751,-506.413,16.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((765.91,-508.317,104.125), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((708.619,-447.879,219.294), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-435.739,-472.895,242.678), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-740,167.769,239.837), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-772.555,620.128,192.125), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-774.088,341.325,88.125), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((151.274,523.985,192.125), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((768.4,-193.358,192.125), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-59.9605,-748.246,63.181), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((-55.2035,-1177.93,171.595), (0,290,0), "wm_iw6_pumpkin");
            break;
        case "mp_alpha":
            add_map_xmodel((19.6489,177.968,24.4363), (0,350,0), "wm_iw6_pumpkin");
            add_map_xmodel((19.6499,137.069,24.4363), (0,355,0), "wm_iw6_pumpkin");
            add_map_xmodel((321.886,321.812,36.125), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((172.89,318.097,36.125), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((138.704,-488.387,34.0437), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((88.9068,-738.56,-8), (0,85,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-893.542,161.927,26.125), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-931.161,161.419,43.125), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-787.039,351.396,64.125), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1080.43,494.741,184.125), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-992.287,233.774,184.625), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((-770.631,-120.218,170.125), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-772.472,-244.896,170.125), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((-947.619,-248.444,170.125), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-800.613,-640.56,172.503), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-709.125,-501.073,171.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-772.111,992.959,170.125), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((-825.568,1265.47,181.477), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-823.174,1291.89,181.485), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-752.573,1748.11,158.42), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-581.321,1836.53,190.85), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-579.513,1874.69,191.583), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-390.439,2234.75,163.738), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-390.712,2066.03,163.464), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1478.22,2387.38,180.96), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1701.49,2518.35,177.474), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1821.59,1969.93,138.125), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1979.86,1972.24,138.125), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1916.93,1730.8,168.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2051.41,1304.15,168.125), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2051.42,1733.5,168.125), (0,405,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1822.7,1184.54,160.083), (0,55,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1264.36,1745.59,294.008), (0,245,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1899.85,1747.06,282.183), (0,285,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((415.67,106.752,156.73), (0,220,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((9.96497,-393.907,157.369), (0,510,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1435.12,-478.152,288.056), (0,85,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-998.423,-476.919,285.402), (0,90,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1796.39,-480.365,292.519), (0,70,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((22.8913,1924.36,40.1119), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-133.182,1937.23,36.893), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-106.18,1461.33,47.0747), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((112.956,1169.62,35.0437), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((328.725,1256.77,44.9809), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((409.915,1246.96,48.1119), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((679.931,1590.88,24.125), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((354.501,1489.65,24.125), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-388.911,837.745,55.7597), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-518.941,827.027,62.9394), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((-576.999,808.649,55.2605), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-600.625,806.857,41.1437), (0,445,0), "wm_iw6_pumpkin");
            add_map_xmodel((-416.122,838.319,41.335), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-366.788,837.6,40.1225), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-527.578,312.403,24.5277), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-296.985,-28.0762,35.0588), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-399.527,-32.2875,19.7744), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-70.1067,135.468,42.125), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((-201.904,425.887,126.725), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-83.4781,428.881,207.095), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((226.145,623.869,207.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((203.901,729.419,207.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((237.074,373.587,204.125), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((8.78417,993.628,176.83), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((56.9061,659.35,188.673), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-57.8572,1028.21,197.625), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-133.376,840.031,197.625), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-970.712,562.078,0.0731726), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1737.93,904.783,31.1327), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1772.75,906.57,35.4726), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-2138.86,1266.95,44.9809), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1754.34,1612.6,27.8997), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((-945.53,2469.95,172.503), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-221.25,1298.59,450), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            break;
        case "so_deltacamp":
            add_map_xmodel((249.073,-763.434,374.532), (0,140,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-2.83845,-507.147,373.219), (0,225,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-385.653,-776.161,362.614), (0,105,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((876.917,-639.735,286.051), (0,195,0), "wm_iw6_pumpkin");
            add_map_xmodel((620.683,-416.792,281.053), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((842.624,-453.964,281.053), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-926.711,-758.062,224.553), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-959.946,-703.105,223.715), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-984.735,-415.583,192.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-672.456,-224.873,193.741), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((-997.538,-31.3988,192.125), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-827.29,64.914,227.125), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((-952.599,209.875,64.125), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-798.62,436.651,0.125002), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-655.857,346.901,43.0437), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-430.635,429.699,28.6585), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-66.6131,553.625,25.0535), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((324.446,408.512,46.7715), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((430.655,475.753,456), (0,245,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-342.526,-105.433,556.048), (0,300,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((56.3283,-1528.46,113.265), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((80.1944,-1552.37,112.941), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((45.2542,-1225.93,98.0627), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((151.005,-1223.18,98.0627), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((853.573,-918.424,281.063), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((853.451,-971.195,281.063), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((836.518,-1014.97,271.553), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((125.15,-511.032,231.145), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((123.885,-770.619,231.86), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-249.879,-769.565,231.515), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-123.858,-507.935,229.967), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((346.15,-390.057,192.125), (0,205,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-331.441,-2754.29,0.117674), (0,80,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-1124.9,-1343.81,104.029), (0,0,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-174.788,-408.805,44.6497), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((115.189,-66.2938,19.0053), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((155.948,506.256,30.8607), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-557.815,617.034,0.125002), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-533.418,619.138,0.124999), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-349.265,164.969,40.7492), (0,130,0), "wm_iw6_pumpkin");
            break;
        case "mp_exchange":
            add_map_xmodel((651.395,-28.9094,354.65), (0,265,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((806.386,-131.788,211.549), (0,275,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1160.05,-122.286,260.432), (0,215,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((175.594,-362.271,97.4271), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((218.584,-149.652,105.625), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((255.672,112.383,105.625), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((253.351,188.237,105.625), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((251.982,635.173,105.625), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-58.0238,703.291,100.18), (0,280,0), "wm_iw6_pumpkin");
            add_map_xmodel((-124.077,63.9084,257.125), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-763.214,176.877,262.125), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-993.564,-93.2386,102.125), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-630.417,176.102,105.625), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((-371.76,-89.7606,105.625), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-267.368,23.1895,105.625), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-417.04,616.979,238.762), (0,95,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-441.582,1275.32,53.3685), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((347.24,1347.94,144.195), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((914.795,1513.07,127.022), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1092.51,1715.29,124.03), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((2328.01,844.153,258.365), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((2614.86,592.524,123.42), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((2491.92,330.589,81.7878), (0,90,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1757.01,122.768,104.125), (0,20,0), "wm_iw6_pumpkin");
            add_map_xmodel((2015.36,-0.631119,107.842), (0,540,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((1316.22,-914.803,99.649), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((1275.76,-905.148,113.921), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((1620.34,-1504.17,61.2099), (0,165,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((878.602,-2110.3,493.152), (0,485,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-221.825,-1994.42,84.1246), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-102.081,-1995.51,84.1311), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-300.557,-1522.79,58.2921), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-295.426,-1340.53,80.8403), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1347,-534.118,148.314), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((-916.058,-215.544,1.125), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1142.48,-380.002,-7.6007), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1110.28,-286.33,-7.72431), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1074.77,-208.426,260.607), (0,320,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-835.884,-375.693,237.068), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-836.947,-351.563,236.866), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-824.283,-208.832,243.084), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((1060.41,905.942,-145.385), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((1064.31,1572.19,-127.936), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((1669.28,1305.05,-175.876), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((905.548,1075.14,-175.875), (0,10,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((412.375,-1313.73,-88.1387), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((191.328,-1131.62,-130.873), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-153.624,-939.316,-135.848), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((107,-573.861,31.4522), (0,330,0), "wm_iw6_pumpkin");
            add_map_xmodel((107.803,-680.756,30.859), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-335.354,-969.871,151.571), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-359.97,-753.17,43.5982), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((951.156,-778.368,115.394), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1558.07,-251.266,102.125), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1677.92,719.476,117.121), (0,255,0), "wm_iw6_pumpkin");
            add_map_xmodel((1418.48,837.214,140.955), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((1327.14,689.165,144.787), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((912.72,449.42,38.6265), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((428.028,334.758,199.336), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((572.275,-573.39,184.278), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1228.71,-1028.89,187.725), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-356.726,1200.03,189.649), (0,515,0), "wm_iw6_pumpkin");
            add_map_xmodel((-793.651,1049.5,200.705), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-948.716,1362.86,200.354), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((433.845,1566.03,-63.875), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((431.419,1312.4,-151.878), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((913.798,1452.44,-175.875), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((1691.08,891.325,87.4998), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1695.63,999.487,87.5249), (0,340,0), "wm_iw6_pumpkin");
            add_map_xmodel((2104.05,1480.15,116.278), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((1893.88,340.388,92.6183), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1894.99,368.355,92.5115), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1639.7,72.6524,91.2097), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((556.132,-802.914,537.948), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            break;
        case "mp_radar":
            add_map_xmodel((-4043.98,721.337,1205.04), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4078,309.681,1205.04), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3731.16,297.635,1217.04), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3185.18,-115.895,1195.04), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3183.17,15.3252,1195.13), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3185.03,147.246,1195.06), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3185.45,285.474,1194.68), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3185.08,416.96,1194.84), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3511.64,-102.518,1184.13), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3287.42,-297.045,1205.04), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3667.26,-685.45,1206.13), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3864.69,-164.581,1184.13), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3861.01,-103.953,1184.13), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4034.14,397.059,1387.69), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4360.81,503.705,1387.92), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4702.65,261.842,1248.84), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3681.11,-173.404,2177.23), (0,475,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-4945.51,818.844,1196.55), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5007.47,822.387,1196.65), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5483.44,779.882,1184.15), (0,25,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5655.49,881.303,1232.1), (0,340,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5858.34,1096.32,1275.04), (0,175,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5820,1015,1275.04), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6049.64,524.112,1341.04), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5694.98,135.997,1333), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6137.75,-180.282,1241.5), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6049.69,-53.124,1186.13), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5699.05,-26.5891,1186.13), (0,235,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-6586.05,1742.45,1303.19), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6614.28,1722.94,1303.02), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7104.61,2329.46,1308.13), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7455.28,2480.78,1336.05), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7379.24,2705.28,1308.13), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7461.86,2709.91,1308.13), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7833.57,2904.73,1296), (0,0,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-7412.2,3410.77,1405.99), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-7665.66,4101.1,1391.71), (0,290,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6903.66,4401.06,1382.12), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6918.87,4426.81,1384.81), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5909.32,4276.23,1353.34), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5510.6,4176.54,1400.82), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5840.15,3609.27,1333.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6148.85,3634.03,1387.04), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-6541.35,3907.9,1360.29), (0,275,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-5457.49,3277.84,1298.74), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4840.25,2816.18,1208.48), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4804.07,2503.65,1168.08), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4893.74,2505.17,1167.92), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4496.94,3905.13,1243.8), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4187.91,3905.5,1243.79), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4113.65,4257.67,1208.13), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4380.09,3027.19,1200.27), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4525.94,2697.97,1162.13), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4337.15,2111.38,1160.11), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4412.83,2108.27,1160.14), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4198.7,1816.55,1162.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4198.22,1899.95,1162.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3911.21,1901.57,1207.04), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3833.33,1816.96,1326.58), (0,270,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-3791.37,1488.75,1268.05), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3894.82,1710.02,1269.05), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3476.74,1660.1,1203.13), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((-3757.83,1895.62,1233.1), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4647.13,1684.09,1200.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4681.36,1201.41,1200.13), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4683.42,1301.89,1200.13), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-4950.52,-275.249,1210.64), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5623.04,-518.242,1170), (0,10,0), "wm_iw6_pumpkin");
            add_map_xmodel((-5645.94,-498.698,1170.13), (0,130,0), "wm_iw6_pumpkin");
            break;
        case "mp_boneyard":
            add_map_xmodel((-749.637,1624.26,-166.159), (0,260,0), "wm_iw6_pumpkin");
            add_map_xmodel((-968.507,1427.17,-102.753), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1296.51,890.11,-87.0034), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1690.48,587.847,-98.2262), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1585.01,397.198,-58.1451), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1553.99,-19.0396,48.125), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1748.14,-19.0752,48.147), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1396.75,-16.0649,48.125), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1395.63,482.883,48.125), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1487.71,-427.626,-88.4039), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1477.27,-562.369,-84.9563), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-959.272,-621.249,-128), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1076.66,-231.744,-84.8614), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((362.853,-285.933,-88.819), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((660.031,-608.303,-93.0145), (0,75,0), "wm_iw6_pumpkin");
            add_map_xmodel((514.004,-6.8863,-74.5372), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((540.878,-23.8044,-77.1943), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((761.804,-217.26,-98.2456), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((1797.82,561.702,-108.718), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((2341.98,494.549,-107.904), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((2339.5,133.87,-107.904), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((2054.54,458.125,24.125), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((2339.21,456.372,24.125), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((1966.91,639.01,10.053), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((1779.23,315.301,-119.875), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((1345.21,506.125,-165.275), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1351.99,37.4515,-163.511), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((877.112,182.843,-96.9752), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((353.302,264.467,-69.375), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((493.332,740.658,-69.375), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((300.006,589.303,-67.375), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-178.034,669.074,4.15431), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((-881.059,486.445,354.818), (0,85,0), "wm_iw6_pumpkinxxl");
            add_map_xmodel((-76.2446,1442.8,184.125), (0,530,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((523.175,1467.04,-32.0464), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((382.824,1088.35,-39.875), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-13.4062,1088.97,-39.8869), (0,250,0), "wm_iw6_pumpkin");
            add_map_xmodel((-406.263,1090.99,-39.8769), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((-733.12,1087.87,-39.875), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((420.831,666.927,-119.383), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((1011.69,228.163,-99.0013), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-287.605,32.3374,-64.0301), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1268.09,211.878,150.125), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1265.91,-57.6081,150.125), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((20.8035,1597.67,-28.9563), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((656.878,1611.45,-28.9563), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1758.71,664.712,-128.819), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((1731.68,683.323,-128.819), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((1738.14,665.37,-128.819), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((1770.11,-479.881,-124.101), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((1753.8,-597.941,-125.394), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((446.529,-444.932,-96.2905), (0,225,0), "wm_iw6_pumpkin");
            add_map_xmodel((1109.88,18.0326,400.88), (0,160,0), "wm_iw6_pumpkinxxl", "watch");
            break;
        case "mp_italy":
            add_map_xmodel((-847.636,-1446.31,765.787), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-950.898,-1405.71,757.419), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-780.17,-1385.94,771.425), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1025.66,-1261.94,757.365), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1127.63,-1121.78,771.427), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((-704.365,-1319.27,782.789), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-563.793,-1236.09,813.071), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((-394.987,-1105.15,853.383), (0,120,0), "wm_iw6_pumpkin");
            add_map_xmodel((-775.828,-1343.74,899.246), (0,140,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-956.673,-1308.54,889.343), (0,60,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1192.7,-816.312,768.125), (0,0,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-942.5,-294.669,806.128), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-846.537,-203.468,840.119), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-646.406,-129.52,876.126), (0,275,0), "wm_iw6_pumpkin");
            add_map_xmodel((-602.698,-131.051,876.109), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((15.6108,-289.773,872.125), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-35.6736,-332.972,872.125), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-355.094,-620.409,909.127), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((-425.002,-550.964,909.14), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-180.017,348.295,876.125), (0,295,0), "wm_iw6_pumpkin");
            add_map_xmodel((63.9558,34.1032,872.125), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((-39.3776,-86.7033,896.608), (0,200,0), "wm_iw6_pumpkin");
            add_map_xmodel((197.105,-140.664,928.127), (0,205,0), "wm_iw6_pumpkin");
            add_map_xmodel((317.264,54.3561,1032.13), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((752.18,66.2849,1057.75), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((989.854,7.2142,1040.13), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((865.797,12.6945,1040.13), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((1166.07,206.019,1032.13), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1165.03,130.913,1032.13), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((777.926,476.213,1056.13), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((1025.82,492.711,1055), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((1336.73,787.454,1139.16), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1282.8,945.717,1171.07), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((1153.21,1054.16,1193.06), (0,105,0), "wm_iw6_pumpkin");
            add_map_xmodel((900.433,964.744,1152.13), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((836.747,1906.13,1250.13), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((991.433,2224.73,1248), (0,310,0), "wm_iw6_pumpkin");
            add_map_xmodel((1106.49,2226.85,1248), (0,240,0), "wm_iw6_pumpkin");
            add_map_xmodel((1287.26,1893.95,1249.13), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1782.76,1861.31,1216), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1777.4,1786.31,1216), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((1627.47,1685.18,1237.44), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1626.32,1507.62,1237.31), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1627.53,1528.68,1237.35), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1401.1,1420.4,1216.13), (0,220,0), "wm_iw6_pumpkin");
            add_map_xmodel((1655.67,1067.51,1088), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((1985.97,755.304,1072), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((1857.6,751.029,1072), (0,305,0), "wm_iw6_pumpkin");
            add_map_xmodel((1772.23,9.31013,1029.58), (0,155,0), "wm_iw6_pumpkin");
            add_map_xmodel((1735.72,-10.8327,1030.84), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((1549.15,-309.037,939.543), (0,30,0), "wm_iw6_pumpkin");
            add_map_xmodel((1553.94,-208.864,938.243), (0,330,0), "wm_iw6_pumpkin");
            add_map_xmodel((1351.27,352.117,1048), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((1903.36,-583.316,1073.1), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((1842.82,-691.11,992.125), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((1721.41,-1078.42,896.125), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1194.74,-881.563,736.125), (0,40,0), "wm_iw6_pumpkin");
            add_map_xmodel((1044.32,-883.263,736.125), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((1048.43,-1035.53,736.125), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((1116.08,-969.219,853.847), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((1193.46,-1030.73,736.125), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((803.451,-1081.65,736.125), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((890.185,-1220.64,736), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((1116.35,-1349.87,736), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((1351.73,-1212.38,736), (0,150,0), "wm_iw6_pumpkin");
            add_map_xmodel((631.072,-1100.76,736.125), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((414.488,-979.636,732.345), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((449.745,-853.715,728), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((364.502,-894.134,736), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((-96.0485,-1177.03,864.122), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((-346.051,-76.1492,898.172), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-397.638,239.643,1130.09), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-450.548,759.442,1186.13), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-579.048,888.792,1186.13), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((-642.573,785.75,1186.05), (0,55,0), "wm_iw6_pumpkin");
            add_map_xmodel((-229.433,492.087,1170.13), (0,95,0), "wm_iw6_pumpkin");
            add_map_xmodel((120.77,645.947,1185.49), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((302.664,1109.73,1166.5), (0,180,0), "wm_iw6_pumpkin");
            add_map_xmodel((-183.924,1548.68,1358), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((-213.331,1520.5,1314), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((-147.741,1532.2,1278), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-66.7741,1759.2,1299.38), (0,265,0), "wm_iw6_pumpkin");
            add_map_xmodel((-657.34,1420.68,1216.13), (0,110,0), "wm_iw6_pumpkin");
            add_map_xmodel((-772.247,1066.79,1152.13), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-666.866,1671.87,1398.1), (0,90,0), "wm_iw6_pumpkin");
            add_map_xmodel((-996.965,1398.84,1280.13), (0,80,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1301.33,1620.84,1152.14), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1646.74,1154.1,1081.05), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1264.88,1007.43,1056.27), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1177.17,559.978,1058.13), (0,125,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1364.01,375.162,1057.23), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1721.21,702.498,1039.38), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1533.8,884.87,1039.38), (0,270,0), "wm_iw6_pumpkin");
            add_map_xmodel((-837.798,707.767,1098.7), (0,135,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1156.3,118.653,960.125), (0,85,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1039.02,87.3777,960.125), (0,140,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1121.85,-45.1591,1000.13), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1512.57,-341.898,909.182), (0,35,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1379.56,-475.473,861.068), (0,115,0), "wm_iw6_pumpkin");
            add_map_xmodel((-1107.57,-626.973,803.311), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((-975.509,-806.382,962.125), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((-765.499,-689.453,998.613), (0,170,0), "wm_iw6_pumpkin");
            add_map_xmodel((-822.129,-717.912,1155.12), (0,140,0), "wm_iw6_pumpkinxl");
            add_map_xmodel((-1542.93,695.065,1500), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            break;
        case "mp_killhouse":
            add_map_xmodel((3727.31,489.576,50.7715), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((3634.47,233.475,48.6395), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((3571.55,101.412,49.056), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((3553.59,-316.387,52.125), (0,80,0), "wm_iw6_pumpkin");
            add_map_xmodel((3704.44,-342.716,51.8762), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((3973.86,-534.495,52.125), (0,60,0), "wm_iw6_pumpkin");
            add_map_xmodel((3672.05,-531.433,156.125), (0,315,0), "wm_iw6_pumpkin");
            add_map_xmodel((3851.13,-534.183,156.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((4238.42,-898.102,48.0958), (0,235,0), "wm_iw6_pumpkin");
            add_map_xmodel((4048.85,-1069.15,48.0958), (0,160,0), "wm_iw6_pumpkin");
            add_map_xmodel((3458,-1072.84,48.0958), (0,65,0), "wm_iw6_pumpkin");
            add_map_xmodel((3258.42,-1151.88,32.7738), (0,70,0), "wm_iw6_pumpkin");
            add_map_xmodel((2974.85,-924.884,38.0627), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((2974.72,-524.917,38.0627), (0,325,0), "wm_iw6_pumpkin");
            add_map_xmodel((3095.99,-272.261,4.125), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((2975.72,-486.741,37.6772), (0,45,0), "wm_iw6_pumpkin");
            add_map_xmodel((3430,384.958,37.7932), (0,210,0), "wm_iw6_pumpkin");
            add_map_xmodel((3432.27,424.68,39.8619), (0,215,0), "wm_iw6_pumpkin");
            add_map_xmodel((3587.3,811.907,36.125), (0,300,0), "wm_iw6_pumpkin");
            add_map_xmodel((3849.84,852.606,36.125), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((3674.83,1392.97,38.0627), (0,320,0), "wm_iw6_pumpkin");
            add_map_xmodel((4213.89,1164.83,38.0627), (0,145,0), "wm_iw6_pumpkin");
            add_map_xmodel((3747.86,811.843,156.125), (0,140,0), "wm_iw6_pumpkin");
            add_map_xmodel((3998.49,185.603,4.125), (0,230,0), "wm_iw6_pumpkin");
            add_map_xmodel((3780.49,22.4832,37.5986), (0,10,0), "wm_iw6_pumpkin");
            add_map_xmodel((4225.96,96.1843,25.4656), (0,185,0), "wm_iw6_pumpkin");
            add_map_xmodel((4225.23,66.2234,25.7927), (0,165,0), "wm_iw6_pumpkin");
            add_map_xmodel((4037.54,204.904,63.0532), (0,285,0), "wm_iw6_pumpkin");
            add_map_xmodel((4235.37,233.147,63.4787), (0,100,0), "wm_iw6_pumpkin");
            add_map_xmodel((3662.21,208.309,126.128), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((3546.12,102.297,236.125), (0,50,0), "wm_iw6_pumpkin");
            add_map_xmodel((3657.47,131.88,236.125), (0,130,0), "wm_iw6_pumpkin");
            add_map_xmodel((4067.52,225.729,161.025), (0,190,0), "wm_iw6_pumpkin");
            add_map_xmodel((3370.98,-29.1549,131.025), (0,0,0), "wm_iw6_pumpkin");
            add_map_xmodel((2993.85,322.381,131.025), (0,10,0), "wm_iw6_pumpkin");
            add_map_xmodel((3524.08,121.308,1000.31), (0,0,0), "wm_iw6_pumpkinxxl", "float");
            break;
        default:
            level.default_map = 1;
    }
}

lunge_detection() {
    self endon("disconnect");

    origin = undefined;

    while(1) {
        if(self isonground()) {
            self.last_time = gettime();
            origin = self.origin;
        }

        if(self meleebuttonpressed()) {
            if(self getvelocity()[2] > 500 && (gettime() - self.last_time < 200)) { // 200 cus ppl can stll lunge when being in air
                foreach(player in level.players) {
                    if(player != self) {
                        if(distance2d(self.origin, player.origin) < 200) {
                            self setvelocity((0, 0, 0));
                            self setorigin(origin);
                        }
                    }
                }
            }
        }

        wait .05;
    }
}

dam_barriers() {
    ents = getentarray("blocker", "targetname");

    foreach(ent in ents)
        ent hide();
}

custom_placed_models() {
    while(1) {
        if(isdefined(level.custom_ents)) {
            foreach(ent in level.custom_ents)
                ent hide();

            foreach(player in level.players) {
                if(player.player_settings["custom_ents"] == 1) {
                    foreach(ent in level.custom_ents)
                        ent showtoplayer(player);
                }
            }
        }

        wait 1;
    }
}

add_map_xmodel(origin, angle, model, ability) {
    if(!isdefined(level.custom_ents))
        level.custom_ents = [];

    num = level.custom_ents.size;

    if(isdefined(ability) && ability != "music" || !isdefined(ability)) {
        level.custom_ents[num] = spawn("script_model", origin);
        level.custom_ents[num].angles = angle;
        level.custom_ents[num] setmodel(model);

        if(isdefined(ability)) {
            if(ability == "float") {
                level.custom_ents[num] thread float_pumpkin();
                level.custom_ents[num] thread pumpkin_watch();
            }
            else if(ability == "watch")
                level.custom_ents[num] thread pumpkin_watch();
            else if(ability == "tornado")
                level.custom_ents[num] thread tornado_pumpkin();
        }
    }
    //else
    //    level thread music_tracker(origin);
}

music_tracker(origin) {
    while(1) {
        foreach(player in level.players) {
            if(distance(player.origin, origin) < 500)
                player.is_close = 1;
            else
                player.is_close = 0;

            if(!isdefined(player.music_ent) && player.is_close == 1) {
                player.music_ent = spawn("script_model", origin);
                player.music_ent hide();
                player.music_ent playsound("halloween_song");
                player.music_ent showtoplayer(player);
            }
            else if(isdefined(player.music_ent) && player.is_close == 0)
                player.music_ent delete();
        }

        wait 1;
    }
}

tornado_pumpkin() {
    coords = array((-2382.11,-5807.5,2028.65),(-1180.28,-6275.81,2506.79),(-247.775,-7292.05,2962.02),(-220.29,-8789.92,3117.68),(-635.535,-10200.3,3117.68),(-1943.07,-10794.2,2777.82),(-3822.13,-10845.4,2345.41),(-5237.69,-10753.1,2155.87),(-6284.36,-9772.78,1792.86),(-6846.78,-7934.15,2000.11),(-6610.81,-6531,2005.74),(-5170.1,-5751.61,1876.21),(-3894.59,-5543.35,1756.32));

    start = randomintrange(0, coords.size - 1);

    while(1) {
        for(i = start;i < coords.size;i++) {
            time = int(distance(self.origin, coords[i]) / 1100);
            self moveto(coords[i], time);
            wait time;

            if(i == (coords.size - 1))
                start = 0;
        }

        wait .05;
    }
}

rotaterandom() {
    while(isdefined(self)) {
        self rotateto((randomint(360), randomint(360), randomint(360)), 1.5);
        wait 1.5;
    }
}

float_pumpkin() {
    while(isdefined(self)) {
        self moveto(self.origin - (0, 0, 200), 4);
        wait 4;
        self moveto(self.origin + (0, 0, 200), 4);
        wait 4;
    }
}

pumpkin_watch() {
    the_player = undefined;

    while(isdefined(self)) {
        closest = 50000;

        if(level.players.size > 0) {
            foreach(player in level.players) {
                if(distance(player.origin, self.origin) < closest) {
                    closest = distance(player.origin, self.origin);
                    the_player = player;
                }
            }

            nX = the_player.origin[0] - self.origin[0];
            nY = the_player.origin[1] - self.origin[1];
            nZ = the_player.origin[2] - self.origin[2];

            d_2d = distance2D(self.origin, the_player.origin);

            anglePitch = ATan(nZ/d_2d);
            anglePitch = 0 - anglePitch - 10;

            angleYaw = ATan(nY/nX);

            if(nX < 0 && nY > 0)
                angleYaw = angleYaw + 180;

            if(nY < 0 && nX < 0)
                angleYaw = angleYaw + 180;

            newAngles = (anglePitch, angleYaw, 0);
            self rotateTo(newAngles, .4);
        }

        wait .4;
    }
}

track_chicken_damage() {
    while(1) {
        self waittill("damage", amount, other);

        if(isdefined(other) && self.health <= 0) {
            other.player_settings["chicken_kill"]++;
            other notify("player_stats_updated");
            break;
        }
    }
}

nuke_handler() {
    level.activated_nukes = 0;

    while(1) {
        level waittill("nuke_death");

        if(isdefined(level.nukeinfo.player) && level.nukeinfo.player.team == "allies")
            level.nukeinfo.player thread anti_camp();

        level.activated_nukes++;

        if(level.activated_nukes == 3) {
            if(!isdefined(level.betties_map) && !isdefined(level.throwing_knifes_map)) {
                level.betties_map = 1;

                foreach(player in level.players) {
                    if(player.team == "axis")
                        player GiveWeapon("bouncingbetty_mp");
                }

                say_raw("^8^7[ ^8Information ^7]: Infected Equipment: ^8Bouncing Betty^7 Unlocked");
            }
            else if(!isdefined(level.throwing_knifes_map)) {
                level.throwing_knifes_map = 1;
                level.infect_loadouts["axis"]["loadoutDeathstreak"] = "";
                say_raw("^8^7[ ^8Information ^7]: Infected Equipment: ^8Throwing Knife^7 Unlocked");
            }
        }
    }
}

cancelnukefix( player ) {
    level endon( "nuke_death" );

    player common_scripts\utility::waittill_any("death", "disconnect");
    if(isdefined(player.nukekiller)) {
        iPrintLnBold("^8" + player.name + "^7 M.O.A.B got ^8Cancelled^7 by ^:" + player.nukekiller.name);
        player.nukekiller.player_settings["cancelled_moabs"]++;
        //player.nukekiller setclientdvar("inf_cancel_moabs", "");
        player.nukekiller = undefined;
    }
    else
        iPrintLnBold("^8" + player.name + "^7 M.O.A.B got ^8Cancelled");

    setdvar( "ui_bomb_timer", 0 );
    level.nukeincoming = undefined;
    level notify( "nuke_cancelled" );

    if(level.skybox == 0) {
        visionsetnaked(getdvar("mapname"), 0.1);
        visionsetpain( getdvar("mapname") );
    }
    else if(level.skybox == 1) {
        visionsetnaked("icbm_sunrise1", 0.1);
        visionsetpain("icbm_sunrise1");
    }
    else if(level.skybox == 2) {
        visionsetnaked("seaknight_assault", 0.1);
        visionsetpain("seaknight_assault");
    }
    else if(level.skybox == 3) {
        visionsetnaked("airport", 0.1);
        visionsetpain("airport");
    }
    else if(level.skybox == 4) {
        visionsetnaked("icbm_sunrise1", 0.1);
        visionsetpain("icbm_sunrise1");
    }
}

setinfectedmsg_edit() {
    if(isdefined(self.changingtoregularinfected)) {
        self.changingtoregularinfected = undefined;

        if(isdefined(self.changingtoregularinfectedbykill)) {
            self.changingtoregularinfectedbykill = undefined;
            thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRSTBLOOD" );
            maps\mp\gametypes\_gamescore::givePlayerScore( "first_draft", self );
            thread maps\mp\gametypes\_rank::giveRankXP( "first_draft" );
        }
    }
}