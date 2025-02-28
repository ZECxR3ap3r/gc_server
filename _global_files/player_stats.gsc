#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;

init() {
	level.basepath = "C:/IW5-Data/global_stats";

    level.base_values                           = [];
    level.base_values["choosen_pres"]           = -1;
    level.base_values["cl_voice"]               = 1;
    level.base_values["xp_bar"]                 = 1;
    level.base_values["velocity"]               = 0;
    level.base_values["cancelled_moabs"]        = 0;
    level.base_values["conv_card"]              = "iw5_cardtitle_camo_classic";
    level.base_values["inf_kills"]              = 0;
    level.base_values["surv_kills"]             = 0;
    level.base_values["bounces"]                = 0;
    level.base_values["tk_kills"]               = 0;
    level.base_values["nade_kills"]             = 0;
    level.base_values["betty_kills"]            = 0;
    level.base_values["melee_kills"]            = 0;
    level.base_values["knife_moab_challenge"]   = 0;
    level.base_values["ti_cancel"]              = 0;
    level.base_values["chicken_kill"]           = 0;
    level.base_values["bb_deaths"]              = 0;
    level.base_values["cj_challenge_01"]        = 0;
    level.base_values["inf_teamcolor_surv"]     = 0;
    level.base_values["inf_teamcolor_inf"]      = 0;
    level.base_values["render_skybox"]          = 1;
    level.base_values["ui_scorelimit"]          = 1;
    level.base_values["custom_ents"]            = 1;
    level.base_values["gc_hud"]                 = 1;
    level.base_values["prestige"]               = 0;
    level.base_values["xp"]                     = 0;
    level.base_values["suicides"]               = 0;
    level.base_values["assists"]                = 0;
    level.base_values["died_by_moabs"]          = 0;
    level.base_values["kills"]                  = 0;
    level.base_values["deaths"]                 = 0;
    level.base_values["headshots"]              = 0;
    level.base_values["called_in_moabs"]        = 0;
    level.base_values["challenge_halloween"]    = 1;
    level.base_values["inf_ks_5"]               = 0;
    level.base_values["inf_ks_10"]              = 0;
    level.base_values["inf_ks_15"]              = 0;
    level.base_values["inf_ks_20"]              = 0;
    level.base_values["inf_ks_25"]              = 0;
    level.base_values["inf_ks_30"]              = 0;

	replacefunc(maps\mp\gametypes\_rank::updateRankAnnounceHUD, ::draw_rank_popup);
	replacefunc(maps\mp\gametypes\_hud_message::actionNotifyMessage, ::actionNotifyMessageReplace);
	replacefunc(maps\mp\killstreaks\_nuke::nukedeath, ::nukedeath_replace);
	replacefunc(maps\mp\gametypes\_missions::mayProcessChallenges, ::mayProcessChallengesreplace);
    replacefunc(maps\mp\gametypes\_rank::updateRank, ::updateRank_hook);


    SetDvarIfUninitialized("inf_xp", 5);

    level thread on_connect();

    if(is_weekend()) {
        if(getdvarint("inf_xp") != 20)
            setdvar("inf_xp", 20);
    }
    else {
        if(getdvarint("inf_xp") != 5)
            setdvar("inf_xp", 5);
    }

    wait 0.5;
    level.callbackplayerkilledMain 		= level.callbackPlayerKilled;
    level.callbackPlayerKilled 			= ::cPlayerKilled;
}

is_weekend() {
    if(getcurrentday() == "Friday" && int(strtok(strtok(getservertime(), " ")[1], ":")[0]) > 18 || getcurrentday() == "Saturday" || getcurrentday() == "Sunday")
        return 1;
    else
        return 0;
}

on_connect() {
    while(1) {
        level waittill("connected", player);

        player thread player_settings_main();
        player.survivor_melee_kills = 0;

        player setclientdvar("inf_xp", getdvarint("inf_xp"));
    }
}

player_settings_main() {
    self endon("disconnect");

    players_dir = level.basepath + "/players/" + self.guid + "/infected_data.csv";
    player_csv_data = readFile(players_dir);

    clippy_files                        = [];
    clippy_files["deaths"]              = 1;
    clippy_files["saved_experience"]    = 1;
    clippy_files["saved_prestige"]      = 1;
    clippy_files["suicides"]            = 1;
    clippy_files["headshots"]           = 1;
    clippy_files["kills"]               = 1;
    clippy_files["called_in_moabs"]     = 1;
    clippy_files["assists"]             = 1;
    clippy_files["died_by_moabs"]       = 1;

    self.player_settings                = [];
    needs_update                        = undefined;

    int_columns = strTok("inf_ks_5,inf_ks_10,inf_ks_15,inf_ks_20,inf_ks_25,inf_ks_30,challenge_halloween,called_in_moabs,assists,xp,prestige,deaths,suicides,died_by_moabs,kills,headshots,gc_hud,custom_ents,ui_scorelimit,render_skybox,cj_challenge_01,bb_deaths,inf_teamcolor_inf,inf_teamcolor_surv,conv_card,chicken_kill,ti_cancel,choosen_pres,cl_voice,xp_bar,velocity,cancelled_moabs,inf_kills,surv_kills,bounces,tk_kills,nade_kills,betty_kills,melee_kills,knife_moab_challenge", ",");

    if(!isDefined(player_csv_data) || player_csv_data == "") {
        keys = getarraykeys(level.base_values);

        for(i = 0;i < keys.size;i++)
            self.player_settings[keys[i]] = level.base_values[keys[i]];

        needs_update = 1;
    }
    else {
        self.player_settings = scripts\_global_files\core::csv_decode(player_csv_data)[0];

        foreach(i_column in int_columns) {
            if(!isdefined(self.player_settings[i_column])) {
                self.player_settings[i_column] = level.base_values[i_column];

                needs_update = 1;

                if(isdefined(clippy_files[i_column]) && fileexists(level.basepath + "/players/" + self.guid + "/" + i_column + ".csv")) {
                    self.player_settings[i_column] = readfile(level.basepath + "/players/" + self.guid + "/" + i_column + ".csv");
                    deletefile(level.basepath + "/players/" + self.guid + "/" + i_column + ".csv");
                }
                else if(i_column == "xp" && fileexists(level.basepath + "/players/" + self.guid + "/saved_experience.csv")) {
                    self.player_settings[i_column] = readfile(level.basepath + "/players/" + self.guid + "/saved_experience.csv");
                    deletefile(level.basepath + "/players/" + self.guid + "/saved_experience.csv");
                }
                else if(i_column == "prestige" && fileexists(level.basepath + "/players/" + self.guid + "/saved_prestige.csv")) {
                    self.player_settings[i_column] = readfile(level.basepath + "/players/" + self.guid + "/saved_prestige.csv");
                    deletefile(level.basepath + "/players/" + self.guid + "/saved_prestige.csv");
                }

                if(fileexists(level.basepath + "/players/" + self.guid + "/global_stats.csv"))
                    deletefile(level.basepath + "/players/" + self.guid + "/global_stats.csv");
            }
        }
    }

    foreach(i_column in int_columns) {
        if(i_column != "conv_card")
            self.player_settings[i_column] = int(self.player_settings[i_column]);
    }

    if(isdefined(self.player_settings["special_xp"]))
        self.player_settings["special_xp"] = int(self.player_settings["special_xp"]);
    if(isdefined(self.player_settings["special_xp_time"]))
        self.player_settings["special_xp_time"] = int(self.player_settings["special_xp_time"]);


    self thread update_stats_aftertime(25);
    //self thread getclientdvar("clantag");

    /*if(isdefined(level.special_people[tolower(self.guid)])) {
        if(!isdefined(self.player_settings["special_xp"])) {
            self.player_settings["special_xp"] = 20;
            self.player_settings["special_xp_time"] = 720;
            self delay_tell("^6^7[ ^6Gift ^7]: You Recieved a Gift from ^6ZECxR3ap3r^7 [ ^620x ^7for ^612^7 Ingame Hours ]");
            needs_update = 1;
            self thread special_xp_counter();

            if(isdefined(self.player_settings["special_xp"]) && self.player_settings["special_xp"] != 0) {
                if(!isdefined(self.hud_element_xp["xp_special_timer"])) {
                    self.hud_element_xp["xp_special_timer"] = newclienthudelem(self);
                    self.hud_element_xp["xp_special_timer"].horzalign = "fullscreen";
                    self.hud_element_xp["xp_special_timer"].vertalign = "fullscreen";
                    self.hud_element_xp["xp_special_timer"].alignx = "center";
                    self.hud_element_xp["xp_special_timer"].aligny = "bottom";
                    self.hud_element_xp["xp_special_timer"].x = 320;
                    self.hud_element_xp["xp_special_timer"].y = 465;
                    self.hud_element_xp["xp_special_timer"].archived = 1;
                    self.hud_element_xp["xp_special_timer"].alpha = 1;
                    self.hud_element_xp["xp_special_timer"].fontscale = 1;
                    self.hud_element_xp["xp_special_timer"].font = "small";
                    self.hud_element_xp["xp_special_timer"] settenthstimerstatic(self.player_settings["special_xp_time"]);
                    self.hud_element_xp["xp_special_timer"].hidewheninmenu = 1;
                }
            }

            self setclientdvar("inf_xp", self.player_settings["special_xp"]);
        }
        else {
            if(self.player_settings["special_xp_time"] != 0) {
                self thread special_xp_counter();

                if(isdefined(self.player_settings["special_xp"]) && self.player_settings["special_xp"] != 0) {
                    if(!isdefined(self.hud_element_xp["xp_special_timer"])) {
                        self.hud_element_xp["xp_special_timer"] = newclienthudelem(self);
                        self.hud_element_xp["xp_special_timer"].horzalign = "fullscreen";
                        self.hud_element_xp["xp_special_timer"].vertalign = "fullscreen";
                        self.hud_element_xp["xp_special_timer"].alignx = "center";
                        self.hud_element_xp["xp_special_timer"].aligny = "bottom";
                        self.hud_element_xp["xp_special_timer"].x = 320;
                        self.hud_element_xp["xp_special_timer"].y = 465;
                        self.hud_element_xp["xp_special_timer"].archived = 1;
                        self.hud_element_xp["xp_special_timer"].alpha = 1;
                        self.hud_element_xp["xp_special_timer"].fontscale = 1;
                        self.hud_element_xp["xp_special_timer"].font = "small";
                        self.hud_element_xp["xp_special_timer"] settenthstimerstatic(self.player_settings["special_xp_time"]);
                        self.hud_element_xp["xp_special_timer"].hidewheninmenu = 1;
                    }
                }

                self setclientdvar("inf_xp", self.player_settings["special_xp"]);
            }
        }
    }*/

    self setclientdvars("inf_ks_30", self.player_settings["inf_ks_30"], "inf_ks_25", self.player_settings["inf_ks_25"], "inf_ks_20", self.player_settings["inf_ks_20"], "inf_ks_15", self.player_settings["inf_ks_15"], "inf_ks_10", self.player_settings["inf_ks_10"], "inf_ks_5", self.player_settings["inf_ks_5"], "challenge_halloween", self.player_settings["challenge_halloween"], "ui_username", self.name, "inf_gc_hud", self.player_settings["gc_hud"], "custom_ents", self.player_settings["custom_ents"], "ui_value", 0, "inf_render_skybox", self.player_settings["render_skybox"], "inf_bb_deaths", self.player_settings["bb_deaths"], "cj_challenge_01", self.player_settings["cj_challenge_01"], "inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "inf_chickens", self.player_settings["chicken_kill"], "inf_hud_xp_bar", self.player_settings["xp_bar"], "inf_hud_velocity", self.player_settings["velocity"], "inf_ti_cancel", self.player_settings["ti_cancel"], "inf_experience", self.player_settings["xp"], "inf_challenge_1", self.player_settings["knife_moab_challenge"], "inf_nade_kills", self.player_settings["nade_kills"], "inf_surv_kills", self.player_settings["surv_kills"], "inf_inf_kills", self.player_settings["inf_kills"], "inf_melee_kills", self.player_settings["melee_kills"], "inf_prestige", self.player_settings["prestige"], "inf_moabs", self.player_settings["called_in_moabs"], "inf_cancel_moabs", self.player_settings["cancelled_moabs"]);

    if(self.player_settings["ui_scorelimit"] == 1)
        self setclientdvar("inf_scorelimit", 18);
    else
        self setclientdvar("inf_scorelimit", 0);

    self.rank = maps\mp\gametypes\_rank::getRankForXp(self.player_settings["xp"]);

    card = self convert_callingcard_data(self.player_settings["conv_card"]);

    if(isdefined(card))
        self.player_settings["conv_card"] = card;
    else
        self.player_settings["conv_card"] = "iw5_cardtitle_camo_classic";

    if(self.player_settings["inf_teamcolor_surv"] == 1)
        self SetClientDvar("cg_teamcolor_allies", ".15 .15 .85 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 2)
        self SetClientDvar("cg_teamcolor_allies", "1 0.41 0.71 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 3)
        self SetClientDvar("cg_teamcolor_allies", ".15 .85 .15 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 4)
        self SetClientDvar("cg_teamcolor_allies", ".85 .15 .15 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 5)
        self SetClientDvar("cg_teamcolor_allies", ".85 .85 .15 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 6)
        self SetClientDvar("cg_teamcolor_allies", "1 0.5 0 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 7)
        self SetClientDvar("cg_teamcolor_allies", ".15 .85 .85 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 8)
        self SetClientDvar("cg_teamcolor_allies", "0.5 0 0.5 1");
    else if(self.player_settings["inf_teamcolor_surv"] == 0)
        self SetClientDvar("cg_teamcolor_allies", "0 .7 1 1");

    if(self.player_settings["inf_teamcolor_inf"] == 1)
        self SetClientDvar("cg_teamcolor_axis", ".15 .15 .85 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 2)
        self SetClientDvar("cg_teamcolor_axis", "1 0.41 0.71 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 3)
        self SetClientDvar("cg_teamcolor_axis", ".15 .85 .15 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 4)
        self SetClientDvar("cg_teamcolor_axis", ".85 .15 .15 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 5)
        self SetClientDvar("cg_teamcolor_axis", ".85 .85 .15 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 6)
        self SetClientDvar("cg_teamcolor_axis", "1 0.5 0 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 7)
        self SetClientDvar("cg_teamcolor_axis", ".15 .85 .85 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 8)
        self SetClientDvar("cg_teamcolor_axis", "0.5 0 0.5 1");
    else if(self.player_settings["inf_teamcolor_inf"] == 0)
        self SetClientDvar("cg_teamcolor_axis", "0 .7 1 1");

    wait .05;
    
    if(self.player_settings["choosen_pres"] != -1)
        self setrank(self.pers["rank"], self.player_settings["choosen_pres"]);

    if(self.player_settings["gc_hud"] == 1) {
        if(isdefined(self.gc_hud_elements)) {
            foreach(hud in self.gc_hud_elements)
                hud.alpha = 1;
        }
    }
    else {
        if(isdefined(self.gc_hud_elements)) {
            foreach(hud in self.gc_hud_elements)
                hud.alpha = 0;
        }
    }

    if(self.player_settings["xp_bar"] == 1) {
        if(isdefined(self.hud_element_xp)) {
            foreach(hud in self.hud_element_xp)
                hud.alpha = 1;
        }
    }
    else {
        if(isdefined(self.hud_element_xp)) {
            foreach(hud in self.hud_element_xp)
                hud.alpha = 0;
        }
    }

    self setrank(self.rank, self.player_settings["prestige"]);

    while(1) {
        if(!isdefined(needs_update))
            self waittill("player_stats_updated");
        else
            needs_update = undefined;

        if(self.player_settings["gc_hud"] == 1) {
            if(isdefined(self.gc_hud_elements)) {
                foreach(hud in self.gc_hud_elements)
                    hud.alpha = 1;
            }
        }
        else {
            if(isdefined(self.gc_hud_elements)) {
                foreach(hud in self.gc_hud_elements)
                    hud.alpha = 0;
            }
        }

        if(self.player_settings["xp_bar"] == 1) {
            if(isdefined(self.hud_element_xp)) {
                foreach(hud in self.hud_element_xp)
                    hud.alpha = 1;
            }
        }
        else {
            if(isdefined(self.hud_element_xp)) {
                foreach(hud in self.hud_element_xp)
                    hud.alpha = 0;
            }
        }

        player_data = scripts\_global_files\core::csv_encode(self.player_settings);
        writeFile(players_dir, player_data);

        self setclientdvars("inf_ks_30", self.player_settings["inf_ks_30"], "inf_ks_25", self.player_settings["inf_ks_25"], "inf_ks_20", self.player_settings["inf_ks_20"], "inf_ks_15", self.player_settings["inf_ks_15"], "inf_ks_10", self.player_settings["inf_ks_10"], "inf_ks_5", self.player_settings["inf_ks_5"], "challenge_halloween", self.player_settings["challenge_halloween"], "ui_username", self.name, "inf_gc_hud", self.player_settings["gc_hud"], "custom_ents", self.player_settings["custom_ents"], "ui_value", 0, "inf_render_skybox", self.player_settings["render_skybox"], "inf_bb_deaths", self.player_settings["bb_deaths"], "cj_challenge_01", self.player_settings["cj_challenge_01"], "inf_teamcolor_surv", self.player_settings["inf_teamcolor_surv"], "inf_teamcolor_inf", self.player_settings["inf_teamcolor_inf"], "inf_chickens", self.player_settings["chicken_kill"], "inf_hud_xp_bar", self.player_settings["xp_bar"], "inf_hud_velocity", self.player_settings["velocity"], "inf_ti_cancel", self.player_settings["ti_cancel"], "inf_experience", self.player_settings["xp"], "inf_challenge_1", self.player_settings["knife_moab_challenge"], "inf_nade_kills", self.player_settings["nade_kills"], "inf_surv_kills", self.player_settings["surv_kills"], "inf_inf_kills", self.player_settings["inf_kills"], "inf_melee_kills", self.player_settings["melee_kills"], "inf_prestige", self.player_settings["prestige"], "inf_moabs", self.player_settings["called_in_moabs"], "inf_cancel_moabs", self.player_settings["cancelled_moabs"]);
        //self setclientdvars("inf_experience", self.player_settings["xp"], "inf_gc_hud", self.player_settings["gc_hud"], "custom_ents", self.player_settings["custom_ents"], "inf_render_skybox", self.player_settings["render_skybox"], "inf_bb_deaths", self.player_settings["bb_deaths"], "inf_chickens", self.player_settings["chicken_kill"], "inf_hud_xp_bar", self.player_settings["xp_bar"], "inf_hud_velocity", self.player_settings["velocity"], "inf_ti_cancel", self.player_settings["ti_cancel"], "inf_challenge_1", self.player_settings["knife_moab_challenge"], "inf_nade_kills", self.player_settings["nade_kills"], "inf_surv_kills", self.player_settings["surv_kills"], "inf_inf_kills", self.player_settings["inf_kills"], "inf_melee_kills", self.player_settings["melee_kills"], "inf_prestige", self.player_settings["prestige"], "inf_moabs", self.player_settings["called_in_moabs"], "inf_cancel_moabs", self.player_settings["cancelled_moabs"]);
    }
}

Prestige_Logic() {
	if(self.player_settings["xp"] >= maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && self.player_settings["prestige"] < level.maxPrestige) {
		var_1 = self maps\mp\gametypes\_rank::getRankForXp(0);
		self.pers["rank"] = var_1;
		self.pers["rankxp"] = 0;
		self.player_settings["xp"] = 0;

		var_2 = self.player_settings["prestige"] + 1;
		self.player_settings["prestige"] = var_2;

		self setRank( var_1, var_2 );

		self iprintln("You Are Now Prestige ^1" + var_2 + "^7!");
		self tell("You Are Now Prestige ^1" + var_2 + "^7!");

        self notify("player_stats_updated");
	}
	else if(self.player_settings["xp"] == maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && self.player_settings["prestige"] == level.maxPrestige) {
		self.pers["prestige"] = 100;
		self setRank( 40, 100 );
		self.player_settings["prestige"] = 40;

		self iprintln("^1Ultra^7 Prestige Unlocked!");
		self tell("^1Ultra^7 Prestige Unlocked!");

        self notify("player_stats_updated");
	}
}

delay_tell(message) {
    wait 10;
    if(isdefined(self))
        self tell_raw(message);
}

update_stats_aftertime(time) {
    self endon("disconnect");

    while(1) {
        wait time;

        self notify("player_stats_updated");
    }
}

cPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ) {
    port = getdvarint("net_port");
    if(port == 25025 || port == 27027) {
        print("kill");
        if(attacker.sessionteam == "axis" && attacker.name != self.name) {
            if(isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_MELEE")
                attacker.player_settings["melee_kills"]++;
            if(isdefined(sWeapon) && sWeapon == "throwingknife_mp")
                attacker.player_settings["tk_kills"]++;
            if(isdefined(sWeapon) && sWeapon == "bouncingbetty_mp")
                attacker.player_settings["betty_kills"]++;
            if(isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_GRENADE_SPLASH")
                attacker.player_settings["nade_kills"]++;

            attacker.player_settings["inf_kills"]++;
        }
        else if(attacker.sessionteam == "allies" && attacker.name != self.name) {

            if(isdefined(sMeansOfDeath) && sMeansOfDeath == "MOD_MELEE") {
                attacker.player_settings["melee_kills"]++;

                if(attacker.player_settings["knife_moab_challenge"] == 0) {
                    if(isdefined(attacker.last_ti_spawn) && (gettime() - attacker.last_ti_spawn) > 500 && attacker.last_knife != self.name || !isdefined(attacker.last_ti_spawn))
                        attacker.survivor_melee_kills++;

                    attacker.last_knife = self.name;

                    if(attacker.survivor_melee_kills == 15) {
                        attacker.player_settings["knife_moab_challenge"] = 1;
                        attacker tell_raw("^:^7[ ^:System^7 ] you completed the ^:15^7 Kill Knife Challenge!");
                    }
                }
            }
            else {
                if(attacker.survivor_melee_kills != 0)
                    attacker.survivor_melee_kills = 0;
            }

            attacker.player_settings["surv_kills"]++;
        }

        if(port == 25025 && isalive(attacker)) {
            if((attacker getplayerData("killstreaksState", "count") + 1) == 5) {
                attacker.player_settings["inf_ks_5"]++;
                attacker thread send_hud_notification("hud_material/h1_medal_killstreak5", 5);
            }
            else if((attacker getplayerData("killstreaksState", "count") + 1) == 10) {
                attacker.player_settings["inf_ks_10"]++;
                attacker thread send_hud_notification("hud_material/h1_medal_killstreak10", 10);
            }
            else if((attacker getplayerData("killstreaksState", "count") + 1) == 15) {
                attacker.player_settings["inf_ks_15"]++;
                attacker thread send_hud_notification("hud_material/h1_medal_killstreak15", 15);
            }
            else if((attacker getplayerData("killstreaksState", "count") + 1) == 20) {
                attacker.player_settings["inf_ks_20"]++;
               attacker thread send_hud_notification("hud_material/h1_medal_killstreak20", 20);
            }
            else if((attacker getplayerData("killstreaksState", "count") + 1) == 25) {
                attacker.player_settings["inf_ks_25"]++;
                attacker thread send_hud_notification("hud_material/h1_medal_killstreak25", 25);
            }
            else if((attacker getplayerData("killstreaksState", "count") + 1) == 30) {
                attacker.player_settings["inf_ks_30"]++;
                attacker thread send_hud_notification("hud_material/h1_medal_killstreak30", 30);
            }
        }


        if(isdefined(sWeapon) && sWeapon == "bouncingbetty_mp" && self.name != attacker.name)
            self.player_settings["bb_deaths"]++;

        if(port == 25025)
            attacker killEvent(eInflictor, self, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
    }

    attacker notify("player_stats_updated");

    if(port == 25025) {
        if(self.sessionteam == "allies")
            self thread nodamagetoteam();
    }

    [[level.callbackplayerkilledMain]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}

send_hud_notification(material, value) {
    icon = newclienthudelem(self);
    icon.horzalign = "fullscreen";
    icon.vertalign = "fullscreen";
    icon.alignx = "center";
    icon.aligny = "middle";
    icon.x = 320;
    icon.y = 70;
    icon.alpha = 0;
    icon setshader(material, 28, 32);

    text = newclienthudelem(self);
    text.horzalign = "fullscreen";
    text.vertalign = "fullscreen";
    text.alignx = "center";
    text.aligny = "middle";
    text.x = 320;
    text.y = 95;
    text.glowcolor = (.25, .75, .25);
    text.glowalpha = 1;
    text.font = "bigfixed";
    text.fontscale = .45;
    text.alpha = 0;
    text.label = &"^2&&1^7 Killstreak Medal!";
    text setvalue(value);

    text fadeovertime(.2);
    text.alpha = 1;
    icon fadeovertime(.2);
    icon.alpha = 1;

    wait 1.5;

    text fadeovertime(.2);
    text.alpha = 0;
    icon fadeovertime(.2);
    icon.alpha = 0;

    wait .2;

    text destroy();
    icon destroy();
}

nodamagetoteam() {
	self.no_damage_protection = 1;
	wait 6;
	self.no_damage_protection = undefined;
}

updateRank_hook(value) {
	newRankId = maps\mp\gametypes\_rank::getRankForXp(self.player_settings["xp"]);

	if(newRankId == self.rank)
		return false;

    if(self.player_settings["prestige"] != 40 && newRankId >= 79) {
        self.rank = 79;
	    self setRank(79);
        return false;
    }

    self.rank = newRankId;
    self setRank(newRankId);

	return true;
}

add_xp(value) {
    port = getdvarint("net_port");
    if(isdefined(self.player_settings["special_xp"]) && self.player_settings["special_xp"] != 0 && self.player_settings["special_xp"] > getdvarint("inf_xp"))
        value = int(value * self.player_settings["special_xp"]);
    else
        value = int(value * getdvarint("inf_xp"));

    if(port == 27025 || port == 27027) {
        if(self.player_settings["prestige"] != 40) {
            if((self.player_settings["xp"] + value) > 1746199)
                self.player_settings["xp"] = 1746199;
            else
                self.player_settings["xp"] += value;
        }
        else {
            if((self.player_settings["xp"] + value) > maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank))
                self.player_settings["xp"] = maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank);
            else
                self.player_settings["xp"] += value;
        }
    }
    else {
        if((self.player_settings["xp"] + value) > maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank))
            self.player_settings["xp"] = maps\mp\gametypes\_rank::getRankInfoMaxXP(level.maxRank);
        else
            self.player_settings["xp"] += value;
    }
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
                    self tell_raw("^8^7[ ^8Information ^7]: You have a ^6M.O.A.B^7. use it or you will ^6Die!");
            }
        }
    }
}

blank(amount) {
}

actionNotifyMessageReplace( actionData )
{
	self endon ( "disconnect" );

	assert( isDefined( actionData.slot ) );
	slot = actionData.slot;

	if ( level.gameEnded )
	{
		wait ( 0 );

		if ( isDefined( actionData.type ) && ( actionData.type == "rank" || actionData.type == "weaponRank" ) )
		{
			self setClientDvar( "ui_promotion", 1 );
			self.postGamePromotion = true;
		}
		else if ( isDefined( actionData.type ) && actionData.type == "challenge" )
		{
			self.pers["postGameChallenges"]++;
			self setClientDvar( "ui_challenge_"+ self.pers["postGameChallenges"] +"_ref", actionData.name );
		}

		if ( self.splashQueue[ slot ].size )
			self thread maps\mp\gametypes\_hud_message::dispatchNotify( slot );

		return;
	}
	else
	{
		if(isDefined( actionData.type ) && ( actionData.type == "rank"))
		{
			return;
		}
	}

	assertEx( tableLookup( "mp/splashTable.csv", 0, actionData.name, 0 ) != "", "ERROR: unknown splash - " + actionData.name );

	// defensive ship hack for missing table entries
	if ( tableLookup( "mp/splashTable.csv", 0, actionData.name, 0 ) != "" )
	{
		if ( isDefined( actionData.playerCardPlayer ) )
			self SetCardDisplaySlot( actionData.playerCardPlayer, 5 );

		if ( isDefined( actionData.optionalNumber ) )
			self ShowHudSplash( actionData.name, actionData.slot, actionData.optionalNumber );
		else
			self ShowHudSplash( actionData.name, actionData.slot );

		self.doingSplash[ slot ] = actionData;

		duration = stringToFloat( tableLookup( "mp/splashTable.csv", 0, actionData.name, 4 ) );

		if ( isDefined( actionData.sound ) )
			self playLocalSound( actionData.sound );

		if ( isDefined( actionData.leaderSound ) )
		{
			if ( isDefined( actionData.leaderSoundGroup ) )
				self leaderDialogOnPlayer( actionData.leaderSound, actionData.leaderSoundGroup, true );
			else
				self leaderDialogOnPlayer( actionData.leaderSound );
		}

		self notify ( "actionNotifyMessage" + slot );
		self endon ( "actionNotifyMessage" + slot );

		wait ( duration - 0.05 );

		self.doingSplash[ slot ] = undefined;
	}

	if ( self.splashQueue[ slot ].size )
		self thread maps\mp\gametypes\_hud_message::dispatchNotify( slot );
}

nukedeath_replace()
{
    level endon( "nuke_cancelled" );
    level notify( "nuke_death" );
    ambientstop(1);
    level.moabs_activated++;

    level.nukeinfo.player.player_settings["called_in_moabs"]++;

    foreach ( var_1 in level.players )
    {
        if ( level.teambased )
        {
            if ( isdefined( level.nukeinfo.team ) && var_1.team == level.nukeinfo.team )
                continue;
        }
        else if ( isdefined( level.nukeinfo.player ) && var_1 == level.nukeinfo.player )
            continue;

        var_1.player_settings["died_by_moabs"]++;

        if ( isalive( var_1 ) )
            var_1 thread maps\mp\gametypes\_damage::finishplayerdamagewrapper( level.nukeinfo.player, level.nukeinfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", var_1.origin, var_1.origin, "none", 0, 0 );
    }

    level.nukeincoming = undefined;
}

draw_rank_popup() {
	rank_icon = newclienthudelem(self);
	rank_icon.y = -160;
	rank_icon.alignx = "center";
	rank_icon.aligny = "middle";
	rank_icon.horzalign = "center";
	rank_icon.vertalign = "middle";
	rank_icon.archived = false;
	rank_icon.foreground = true;
	rank_icon.alpha = 0;
	rank_icon.hidewheninmenu = true;
	rank_icon.hidewhendead = true;
	rank_icon setShader(tableLookup("mp/rankIconTable.csv", 0, maps\mp\gametypes\_rank::getRankForXp(self.player_settings["xp"]), self.player_settings["prestige"] + 1), 102, 102);

	level_hint = newclienthudelem(self);
	level_hint.y = -129;
	level_hint.alignx = "center";
	level_hint.aligny = "middle";
	level_hint.horzalign = "center";
	level_hint.vertalign = "middle";
	level_hint.archived = false;
	level_hint.foreground = true;
	level_hint.fontscale = 1.15;
	level_hint.alpha = 0;
	level_hint.color = (1, 1, 1);
	level_hint.hidewheninmenu = true;
	level_hint.hidewhendead = true;
	level_hint.font = "default";
	level_hint.label = &"LEVEL ^3&&1";
	level_hint setvalue(maps\mp\gametypes\_rank::getRankForXp(self.player_settings["xp"]) + 1);

    self playlocalsound("mp_level_up");

	rank_icon fadeovertime(.25);
	rank_icon scaleovertime(.25, 46, 46);
	rank_icon.alpha = 1;

	wait .25;
	level_hint fadeovertime(.25);
	level_hint.alpha = 1;

	wait 3;
	rank_icon fadeovertime(.25);
	level_hint fadeovertime(.25);
	rank_icon.alpha = 0;
	level_hint.alpha = 0;

	wait .25;
	rank_icon destroy();
	level_hint destroy();
}

mayProcessChallengesreplace() {
	return false;
}

convert_callingcard_data(card) {
    switch(card) {
        case "calling_cards/emblem_custom_07":
            if(self.pers["prestige"] >= 5)
                return "calling_cards/emblem_custom_07";
        case "calling_cards/emblem_custom_02":
            if(self.pers["prestige"] >= 10)
                return "calling_cards/emblem_custom_02";
        case "calling_cards/emblem_bg_prestige15":
            if(self.pers["prestige"] >= 15)
                return "calling_cards/emblem_bg_prestige15";
        case "calling_cards/emblem_custom_10":
            if(self.pers["prestige"] >= 20)
                return "calling_cards/emblem_custom_10";
        case "calling_cards/emblem_custom_20":
            if(self.player_settings["called_in_moabs"] >= 10)
                return "calling_cards/emblem_custom_20";
        case "calling_cards/emblem_custom_19":
            if(self.player_settings["called_in_moabs"] >= 50)
                return "calling_cards/emblem_custom_19";
        case "calling_cards/emblem_custom_18":
            if(self.player_settings["called_in_moabs"] >= 150)
                return "calling_cards/emblem_custom_18";
        case "calling_cards/emblem_custom_17":
            if(self.player_settings["called_in_moabs"] >= 300)
                return "calling_cards/emblem_custom_17";
        case "calling_cards/emblem_custom_16":
            if(self.player_settings["called_in_moabs"] >= 600)
                return "calling_cards/emblem_custom_16";
        case "calling_cards/emblem_custom_26":
            if(self.player_settings["cancelled_moabs"] >= 5)
                return "calling_cards/emblem_custom_26";
        case "calling_cards/emblem_custom_08":
            if(self.player_settings["cancelled_moabs"] >= 10)
                return "calling_cards/emblem_custom_08";
        case "calling_cards/emblem_custom_05":
            if(self.player_settings["cancelled_moabs"] >= 20)
                return "calling_cards/emblem_custom_05";
        case "calling_cards/emblem_custom_01":
            if(self.player_settings["cancelled_moabs"] >= 35)
                return "calling_cards/emblem_custom_01";
        case "calling_cards/emblem_custom_21":
            if(self.player_settings["melee_kills"] >= 1000)
                return "calling_cards/emblem_custom_21";
        case "calling_cards/emblem_custom_13":
            if(self.player_settings["melee_kills"] >= 3000)
                return "calling_cards/emblem_custom_13";
        case "calling_cards/emblem_custom_27":
            if(self.player_settings["nade_kills"] >= 100)
                return "calling_cards/emblem_custom_27";
        case "calling_cards/emblem_custom_04":
            if(self.player_settings["nade_kills"] >= 250)
                return "calling_cards/emblem_custom_04";
        case "calling_cards/emblem_custom_23":
            if(self.player_settings["nade_kills"] >= 500)
                return "calling_cards/emblem_custom_23";
        case "calling_cards/emblem_custom_06":
            if(self.player_settings["surv_kills"] >= 10000)
                return "calling_cards/emblem_custom_06";
        case "calling_cards/emblem_custom_25":
            if(self.player_settings["inf_kills"] >= 5000)
                return "calling_cards/emblem_custom_25";
        case "calling_cards/emblem_custom_34":
            if(self.pers["prestige"] >= 30)
                return "calling_cards/emblem_custom_34";
        case "calling_cards/emblem_custom_33":
            if(self.pers["prestige"] >= 40)
                return "calling_cards/emblem_custom_33";
        case "calling_cards/emblem_custom_44":
            if(self.player_settings["knife_moab_challenge"] == 1)
                return "calling_cards/emblem_custom_44";
        case "calling_cards/emblem_custom_43":
            if(self.player_settings["ti_cancel"] >= 100)
                return "calling_cards/emblem_custom_43";
        case "calling_cards/emblem_custom_28":
            if(self.player_settings["ti_cancel"] >= 250)
                return "calling_cards/emblem_custom_28";
        case "calling_cards/emblem_custom_38":
            if(self.player_settings["ti_cancel"] >= 500)
                return "calling_cards/emblem_custom_38";
        case "calling_cards/emblem_custom_45":
            if(self.player_settings["called_in_moabs"] >= 1000)
                return "calling_cards/emblem_custom_45";
        case "calling_cards/emblem_custom_46":
            if(self.player_settings["chicken_kill"] >= 25)
                return "calling_cards/emblem_custom_46";
        case "calling_cards/emblem_custom_47":
            if(self.player_settings["bb_deaths"] >= 10)
                return "calling_cards/emblem_custom_47";
        case "calling_cards/emblem_custom_48":
            if(self.player_settings["cj_challenge_01"] == 1)
                return "calling_cards/emblem_custom_48";
        case "calling_cards/emblem_custom_42":
            if(self.name == "DeBrezo")
                return "calling_cards/emblem_custom_42";
        case "calling_cards/emblem_custom_54":
            if(self.name == "Malyyz")
                return "calling_cards/emblem_custom_54";
        case "calling_cards/emblem_custom_53":
            if(self.player_settings["halloween_challenge"] == 1)
                return "calling_cards/emblem_custom_53";
        default:
            return undefined;
    }
}