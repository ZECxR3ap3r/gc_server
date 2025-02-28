#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include zec\maps\zec_utility;
#include zec\maps\_voting;
#include zec\maps\_clips;
#include zec\maps\_leaderboard;
#include maps\mp\gametypes\_rank;

main() {
    precachemenu("team_select");
    precachemenu("main_leaderboard");
    precachemenu("main_info");
    precachemenu("main_cosmetics");
    precachemenu("main_mod_settings");
    precachemenu("main_map_vote");
    precachemenu("main_clip_browser");
    precachemenu("main_weapon_camos");
    precachemenu("main_profiles");
    precachemenu("pc_options_video_ingame");
    precachemenu("getclientdvar");
    precachemenu("openclientmenus");
    precachemenu("sendclientdvar");
    precachemenu("popup_leavegame");

    replacefunc(maps\mp\killstreaks\_killstreaks::initKillstreakData, ::initKillstreakData_empty);
    replacefunc(maps\mp\gametypes\_spawnlogic::getbestweightedspawnpoint, ::getbestweightedspawnpoint_new);
    replacefunc(maps\mp\gametypes\_spawnlogic::avoidVisibleEnemies, ::avoidVisibleEnemies_new);
    replacefunc(maps\mp\gametypes\_teams::getTeamIcon, ::return_stencil);
    replacefunc(maps\mp\gametypes\_teams::getTeamHudIcon, ::return_stencil);
    replacefunc(maps\mp\gametypes\_teams::init, ::blanky);
    replacefunc(maps\mp\gametypes\_class::giveLoadout, ::giveLoadout_edit);
    replacefunc(maps\mp\killstreaks\_killstreaks::onplayerspawned, ::blanky);
    replacefunc(maps\mp\gametypes\_missions::init, ::blanky);
    replacefunc(maps\mp\gametypes\_missions::doMissionCallback, ::doMissionCallback_edit);
    replacefunc(::updateMainMenu, ::blanky);
    replacefunc(::killTrigger, ::killTrigger_edit);

    onplayersay(::cj_chat_callback);
}

cj_chat_callback(message, mode) {
    if(message == "!prestige")
        self thread zec\maps\player_stats::Prestige_Logic();

    if(isdefined(level.cj_admin[self.guid])) {
        say_raw("^" + level.cj_admin[self.guid].color + "^7[ ^" + level.cj_admin[self.guid].color + level.cj_admin[self.guid].rank + "^7 ] ^" + level.cj_admin[self.guid].color + self.name + "^7: ^:" + message);
        return false;
    }
    else {
        say_raw("^8^7[ ^" + self.cj_info["color"] + self.cj_info["rank"] + " ] ^8" + self.name + "^7: " + message);
        return false;
    }
}

_suicide_edit() {
    if(isdefined(self.player_settings["deathbarriers"]) && self.player_settings["deathbarriers"] == 1) {
        if(isdefined(self.player_settings["deathbarriers_noti"]) && self.player_settings["deathbarriers_noti"] == 1)
            self.hud_elements["deathbarrier"].alpha = 1;
    }
    else
        self suicide();
}

init() {
    replacefunc(maps\mp\gametypes\_gamelogic::startgame, ::startGame_New);
    replacefunc(maps\mp\gametypes\_damage::Callback_PlayerDamage_internal, ::Callback_PlayerDamage);
    replacefunc(maps\mp\gametypes\_rank::getWeaponRank, ::getWeaponRank_edit);
    replacefunc(::_suicide, ::_suicide_edit);

    level.clip_system_prf = "^8^7[ ^8C^7lip ^8S^7ystem ] ";
    level.general_prf = "^8^7[ ^8C^7odjumper ] ";
    level.commands_prf = "^8^7[ ^8C^7ommands ] ";
    if(getdvar("sv_sayname") != level.general_prf)
        setdvar("sv_sayname", level.general_prf);

    setdvar("max_clips", 1024);

    add_cj_admin("ZECxR3ap3r", 		"0100000000043211", 4, "C^7reator");
	add_cj_admin("Clipzor", 		"0100000000095251", 1, "O^7wner");
	add_cj_admin("Lil Stick", 		"01000000000a4503", 1, "O^7wner");
	add_cj_admin("Revox1337", 		"01000000000a431c", 1, "O^7wner");
	add_cj_admin("a085", 			"0100000000112c1c", 1, "O^7wner");
	add_cj_admin("QueasyNurples", 	"010000000004cb7b", 1, "O^7wner");
	add_cj_admin("StevenGC", 		"01000000001c4067", 2, "T^7rusted");
	add_cj_admin("BethieCake", 		"010000000023b5dc", 2, "T^7rusted");
	add_cj_admin("TMGLion", 		"01000000000168ac", 2, "T^7rusted");
	add_cj_admin("Jebaited", 		"01000000001e9601", 2, "T^7rusted");
	add_cj_admin("Claudi0", 		"0100000000277b08", 2, "T^7rusted");
    add_cj_admin("Sully_", 		    "0100000000176BCB", 2, "T^7rusted");
    add_cj_admin("Sloth", 		    "0100000000188c95", 6, "P^7orter");
    add_cj_admin("Codjumpar", 		"01000000000C3EBA", 3, "H^7ead ^3A^7dmin");
    add_cj_admin("Bigmrk3kek", 		"010000000019A970", 3, "L^7egend");
    add_cj_admin("Visual Krypto", 	"0100000000443179", 3, "L^7egend");

    level.dirty_words = [];
    level.dirty_words[level.dirty_words.size] = "hitler";
    level.dirty_words[level.dirty_words.size] = "nazi";
    level.dirty_words[level.dirty_words.size] = "ni88er";
    level.dirty_words[level.dirty_words.size] = "nagger";
    level.dirty_words[level.dirty_words.size] = "cracker";
    level.dirty_words[level.dirty_words.size] = "coon";
    level.dirty_words[level.dirty_words.size] = "coomer";
    level.dirty_words[level.dirty_words.size] = "c00mers";
    level.dirty_words[level.dirty_words.size] = "faggot";
    level.dirty_words[level.dirty_words.size] = "nigg";
    level.dirty_words[level.dirty_words.size] = "fag";
    level.dirty_words[level.dirty_words.size] = "faggy";
    level.dirty_words[level.dirty_words.size] = "n1gg";
	level.dirty_words[level.dirty_words.size] = "nogger";

    precacheshader("demo_pause");
    precacheshader("line_horizontal");
    precacheshader("analog_background");
    precacheshader("analog_stick");
    precacheshader("gradient");
    precacheshader("w_button_pressed");
    precacheshader("a_button_pressed");
    precacheshader("s_button_pressed");
    precacheshader("d_button_pressed");
    precacheshader("w_button_notpressed");
    precacheshader("a_button_notpressed");
    precacheshader("s_button_notpressed");
    precacheshader("d_button_notpressed");
    precacheshader("iw5_cardtitle_specialty_veteran");
    precacheshader("eye_emoji");

    setdvar("musicActivate", 1);
    setdvar("jump_height", 45);
    setdvar("g_speed", 220);
    setdvar("sv_cheats", 1);
    setdvar("sv_enabledoubletaps", 1);
    setdvar("sv_enablebounces", 1);
    setdvar("sv_allanglesbounces", 1);
    setdvar("jump_disablefalldamage", 1);
    setdvar("g_playercollision", 2);
    setdvar("jump_slowdownenable", 0);
    setdvar("player_sprintunlimited", 1);
    setdvar("g_playerejection", 2);
    setdvar("player_sustainammo", 0);
    setdvar("scr_timelimit", 0);
    setDvar("scr_war_timelimit", 0);
    setdvar("g_scriptmainmenu", "team_select");
    setDvar("scr_dm_timelimit", 0);
    setdvar("g_teamicon_axis", "stencil_base");
    setdvar("g_teamicon_allies", "stencil_base");
    setdvar("g_teamicon_enemyallies", "stencil_base");
    setdvar("g_teamicon_enemyaxis", "stencil_base");
    setdvar("g_teamicon_myallies", "stencil_base");
    setdvar("g_teamicon_myaxis", "stencil_base");
    setdvar("cg_teamcolor_allies", ".75 0 0 .75");
    setdvar("g_scorescolor_allies", "0 0 0 .8");
    setdvar("g_teamname_allies", "^8C^7odjumper^8");
    setdvar("g_teamname_axis", "                                                                                                                                                                                                                                                                                                                                                                                                ");

    game[ "strings" ][ "objective_hint_axis" ] = " ";
    game[ "strings" ][ "objective_hint_allies" ] = " ";

    level.cj_weapons                    = spawnstruct();
    level.cj_weapons.deagle             = "iw5_h1de50";
    level.cj_weapons.rpg                = "iw5_h1rpg";

    level.chat_prefix                   = level.general_prf;

    level.save_ground_fx                = loadfx("zec/save_position");
    level.waypoint_fx                   = loadfx("zec/flare_ambient_blue");
    level.checkpoint_fx                 = loadfx("zec/cj_checkpoint");

    level.base_values                   = [];

    level.base_values["key_x"]          = 50;
    level.base_values["key_y"]          = 440;
    level.base_values["vel_x"]          = 320;
    level.base_values["vel_y"]          = 408;
    level.base_values["fpsx"]           = 595;
    level.base_values["fpsy"]           = 438;
    level.base_values["fpsfs"]          = 1.5;
    level.base_values["R"]              = 0;
    level.base_values["G"]              = 200;
    level.base_values["B"]              = 255;
    level.base_values["camo"]           = 0;
    level.base_values["vel_fs"]         = .6;
    level.base_values["hideothers"]     = 0;
    level.base_values["compass"]        = 1;
    level.base_values["hud_sec_c"]      = 1;
    level.base_values["spechud"]        = 1;
    level.base_values["R2"]             = 255;
    level.base_values["G2"]             = 0;
    level.base_values["B2"]             = 255;
    level.base_values["bc"]             = 0;
    level.base_values["bounces"]        = 0;
    level.base_values["xp"]             = 0;
    level.base_values["min_x"]          = 370;
    level.base_values["min_y"]          = 17;
    level.base_values["comp_angle"]     = 1;
    level.base_values["comp_line"]      = 1;
    level.base_values["minimap"]        = 1;
    level.base_values["inspect"]        = 1;
    level.base_values["height_x"]       = 5;
    level.base_values["height_y"]       = 170;
    level.base_values["draw_xp"]        = 1;
    level.base_values["saves"]          = 0;
    level.base_values["loads"]          = 0;
    level.base_values["rpg_fired"]      = 0;
    level.base_values["clips_created"]  = 0;
    level.base_values["routes"]         = 0;
    level.base_values["fav_map"]        = 0;
    level.base_values["timeplayed"]     = 0;
    level.base_values["deathbarriers"]  = 0;
    level.base_values["deathbarriers_noti"] = 0;

                        //Respone,        // Dvar               // name
    add_client_setting("settings_slnoti", "cj_settings_slnoti", "compass");
    add_client_setting("settings_hud_sec", "hud_sec_c", "hud_sec_c");
    add_client_setting("settings_inspects", "weapon_inspects", "inspect");
    add_client_setting("settings_hideothers", "hideothers", "hideothers");
    add_client_setting("settings_minimap", "cj_hide_map", "minimap");
    add_client_setting("settings_spechud", "spechud", "spechud");
    add_client_setting("settings_comp_line", "compass_help_line", "comp_line");
    add_client_setting("settings_comp_angle", "compass_help_angle", "comp_angle");
    add_client_setting("settings_draw_xp", "cj_draw_xp", "draw_xp");
    add_client_setting("settings_deathbarriers", "cj_deathbarriers", "deathbarriers");
    add_client_setting("settings_deathbarriers_noti", "cj_deathbarriers_noti", "deathbarriers_noti");

    zec\maps\player_stats::init();

    level thread on_connect();
    level thread initVote();
    level thread music_init();
    level thread leaderboard_init();
    level thread spectator_list_updater();
    level thread commands_init();
    level thread hide_others();
    level thread rotate_if_empty();

    clip_init();

    level.clip_max_items = 10;
    level thread check_clip_files();
}

client_courses_init() {
    self endon("disconnect");

    self.course_editor = 1;
}

rotate_if_empty() {
    count = 600;

    while(1) {
        if(level.players.size == 0) {
            count--;

            if(count == 0)
                executecommand("map_rotate");
        }
        else if(level.players.size != 0 && count != 600)
            count = 600;

        wait 1;
    }
}

hide_others() {
    while(1) {
        foreach(player in level.players)
            player hide();

        foreach(player in level.players) {
            foreach(target in level.players) {
                if(target != player) {
                    if(!isdefined(target.isdemo)) {
                        if(isdefined(player.player_settings["hideothers"]) && player.player_settings["hideothers"] == 0)
                            target showtoplayer(player);
                    }
                }
            }
        }

        wait 1;
    }
}

on_connect() {
    for(;;) {
        level waittill("connected", player);

        player notifyOnPlayerCommand("FpsFix_action", "vote no");
        player notifyOnPlayerCommand("Fullbright_action", "vote yes");
        player notifyOnPlayerCommand("actionslot_1", "+actionslot 1");
        player notifyOnPlayerCommand("demo_end", "+actionslot 5");
        player notifyOnPlayerCommand("begin_clip", "+actionslot 7");
        player notifyonplayercommand("waypoint", "+actionslot 6");
        player notifyonplayercommand("reload", "+reload");
        // keyboard
        player notifyonplayercommand("+sprintbutton", "+sprint");
        player notifyonplayercommand("-sprintbutton", "-sprint");
        player notifyonplayercommand("+sprintbutton", "+breath_sprint");
        player notifyonplayercommand("-sprintbutton", "-breath_sprint");
        player notifyonplayercommand("+w", "+forward");
        player notifyonplayercommand("-w", "-forward");
        player notifyonplayercommand("+s", "+back");
        player notifyonplayercommand("-s", "-back");
        player notifyonplayercommand("+d", "+moveright");
        player notifyonplayercommand("-d", "-moveright");
        player notifyonplayercommand("+a", "+moveleft");
        player notifyonplayercommand("-a", "-moveleft");
        player notifyonplayercommand("+f", "+activate");
        player notifyonplayercommand("-f", "-activate");
        player notifyonplayercommand("space", "+gostand");

        player thread on_spawned();

        player setclientdvars("cg_overheadnamesfont", 2, "g_scriptMainMenu", "team_select");
    }
}

on_spawned() {
    self endon("disconnect");

    self.initial_spawn          = 0;
    self.current_input          = "keyboard";
    self.hide_keyboard          = 0;
    self.current_mapvote_filter = "all";
    self.current_clip_filter    = "no_filter";
    self.voting_pages           = calc_mapvote_pages(level.sv_mappool.size, 6);
    self.cj                     = [];
    self.hud_elements           = [];
    self.hud_element_xp         = [];
    self.clip_filter_arr        = [];
    self.viewing_profile        = self.name;
    self.client_button          = 0;

    self setclientdvars("clip_merge_txt", "^1OFF", "menu_cj_info_header", "", "cj_profiles_playersrc", "", "ui_playername", self.name, "cj_course_hud", 0, "menu_leaderboar_count", level.leaderboard_count, "menu_enable_hlsl", 1, "clip_save", 0, "menu_title", "Main Men", "ui_profiles_name", self.name, "menu_int", 1, "cj_selected_clip", 6969696, "clip_current_tag", "> Choose Tag");

    for(;;) {
        self waittill("spawned_player");

        if(self.initial_spawn == 0) {
            self thread player_settings_main();
            self thread player_sessions_main();

            self.specvalue              = 0;
            self.activatedbarriers      = 1;
            self.bounces                = 0;
            self.initial_spawn          = 1;
            self.menu_camo_page_hlsl    = 1;
            self.spectatedPlayers       = [];
            self.spectatorClientNow     = 0;
            self.selectedpoint          = 1;
            self.saved_position         = spawnstruct();
            self.saved_spawn            = self.origin;
            self.saved_angles           = self getplayerangles();
            self.saved_position.origin  = self.origin;
            self.saved_position.angles  = self getplayerangles();
            self.demo_last_model        = self.model;
            self.clientflags            = 0;
            self.afk                    = 0;
            self.capslock               = 0;
            self.client_saarch_current  = "";
            self.save_history           = [];
            self.client_search          = [];
            self.has_cutted             = undefined;

            self thread keyboard_main();
            self thread Timewatcher();
            self thread DeathTracker();
            self thread stop_everything_watcher();
            self thread missle_fire();
            self thread initVoteClient();
            self thread rpg_helper();
            self thread menu_handler();
            self thread handle_better_fps();
            self thread handle_fullbright();
            self thread save_load();
            self thread sprint_checker();
            if(isdefined(level.map_data))
                self thread playerruns_think();
            self thread hud_spectator_list();
            self thread hud_second_color();
            self change_hud_color();
            self thread reload_tracker();
            self thread velocity_hud();
            self thread fps_counter_main();
            self thread keyboard_setup();
            self thread instant_replay_main();
            self thread input_tracker();
            self thread weapon_inspect();
            self thread hud_distance();
            self thread spot_waypoint();
            self thread bounce_detection();
            self thread update_clips_menu();
            self thread afk_check();
            self thread profiles_handler();
            self thread give_cj_rank();
            self thread load_global_stats();
            self thread zec\maps\player_stats::push_client_stats_update();
        }

        self maps\mp\gametypes\_menus::addToTeam("allies");
        self.selectedClass = 1;
        self [[level.class]]("class0");
        self takeallweapons();
        self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
        self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
        self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
        self.vel = int(0);

        self detachall();
        self setviewmodel("viewhands_russian_a");
        self setmodel("mp_body_russian_military_smg_a");
        self attach( "head_russian_military_aa", "", 1 );
        self.headmodel = "head_russian_military_aa";
    }
}

load_global_stats() {
    self.global_stats = [];

    players_dir = "C:/IW5-Data/global_stats" + "/players/" + self.guid + "/infected_data.csv";

    if(fileexists(players_dir)) {
        player_stats_name = readFile(players_dir, 0, 0, 0);
        player_stats_data = readFile(players_dir, 0, 0, 1);

        array_stats_name = strtok(player_stats_name, ",");
        array_stats_data = strtok(player_stats_data, ",");

        conv_data_data = "";
        conv_data_name = "";

        for(i = 0;i < array_stats_name.size;i++) {
            if(array_stats_name[i] != "conv_card")
                self.global_stats[array_stats_name[i]] = int(array_stats_data[i]);
            else
                self.global_stats[array_stats_name[i]] = array_stats_data[i];
        }
    }

    wait .05;

    self.rank = maps\mp\gametypes\_rank::getRankForXp(self.global_stats["xp"]);
    self setrank(self.rank, self.global_stats["prestige"]);
    self setclientdvar("inf_experience", self.global_stats["xp"]);
}

give_cj_rank() {
    self.cj_info = [];

    if(self.playtime < 10) {
        self.cj_info["rank"] = "N^7oob";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 10 && self.playtime < 25) {
        self.cj_info["rank"] = "B^7eginner";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 25 && self.playtime < 50) {
        self.cj_info["rank"] = "N^7ovice";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 50 && self.playtime < 100) {
        self.cj_info["rank"] = "E^7xperienced";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 100 && self.playtime < 200) {
        self.cj_info["rank"] = "V^7eteran";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 200 && self.playtime < 400) {
        self.cj_info["rank"] = "M^7aster";
        self.cj_info["color"] = 8;
    }
    else if(self.playtime >= 400) {
        self.cj_info["rank"] = "L^7egend";
        self.cj_info["color"] = 8;
    }
}

reload_tracker() {
    self endon("disconnect");

    while(1) {
        self waittill("reload");

        if(isdefined(self.isdemo)) {
            if(isdefined(self.demo_timeline_hud["demo_cutbar_1"]))
                self.demo_timeline_hud["demo_cutbar_1"].alpha = 0;
            if(isdefined(self.demo_timeline_hud["demo_cutbar_2"]))
                self.demo_timeline_hud["demo_cutbar_2"].alpha = 0;

            self iPrintLnBold("^8Removed Cut Points!");
        }
    }
}

profiles_handler() {
    self endon("disconnect");
}

client_ladderpush() {
    self endon("disconnect");

    pushnum = 1024;

    self thread client_ladderpush_jump();

    while(1) {
        if(self isonladder()) {
            while(self isonladder()) {
                wait .05;

                if(self.button_space_pressed == 1) {
                    angles = anglestoforward(self getplayerangles());
                    push = pushnum * angles;
                    self setvelocity(push);
                }
            }
        }

        wait .05;
    }
}

client_ladderpush_jump() {
    self endon("disconnect");

    self.button_space_pressed = 0;

    while(1) {
        self waittill("space");

        self.button_space_pressed = 1;

        wait .05;

        self.button_space_pressed = 0;
    }
}

afk_check() {
    self endon("disconnect");

    self.afk = 0;
    old_origin = self.origin;

    count = 0;

    while(1) {
        if(distance(self.origin, old_origin) < 50) {
            if(self.afk != 1)
                count++;
        }
        else {
            count = 0;
            self.afk = 0;
        }

        if(count == 75 && self.afk != 1)
            self.afk = 1;

        old_origin = self.origin;

        wait .5;
    }
}

spot_waypoint() {
    self endon("disconnect");

    self.waypoint = spawn("script_model", self.origin + (0, 0, 10));
    self.waypoint setmodel("tag_origin");
    self.waypoint.angles = (90, 0, 0);
    self.waypoint hide();
    self.waypoint playLoopSound( "emt_road_flare_burn" );
    self.waypoint.hidden = 1;

    if(!isdefined(self.hud_elements["point_bg"])) {
        self.hud_elements["point_bg"] = newclienthudelem(self);
        self.hud_elements["point_bg"].horzalign = "fullscreen";
        self.hud_elements["point_bg"].vertalign = "fullscreen";
        self.hud_elements["point_bg"].alignx = "left";
        self.hud_elements["point_bg"].aligny = "bottom";
        self.hud_elements["point_bg"].x = self.player_settings["height_x"];
        self.hud_elements["point_bg"].y = self.player_settings["height_y"];
        self.hud_elements["point_bg"].alpha = 0;
        self.hud_elements["point_bg"] setshader("gradient", 140, 20);
    }

    if(!isdefined(self.hud_elements["point_info"])) {
        self.hud_elements["point_info"] = newclienthudelem(self);
        self.hud_elements["point_info"].horzalign = "fullscreen";
        self.hud_elements["point_info"].vertalign = "fullscreen";
        self.hud_elements["point_info"].alignx = "left";
        self.hud_elements["point_info"].aligny = "bottom";
        self.hud_elements["point_info"].x = self.player_settings["height_x"] + 2;
        self.hud_elements["point_info"].y = self.player_settings["height_y"] - 10;
        self.hud_elements["point_info"].sort = 3;
        self.hud_elements["point_info"].fontscale = 1;
        self.hud_elements["point_info"].font = "small";
        self.hud_elements["point_info"].label = &"^8Height Distance:\r                                       ^7&&1^8m";
        self.hud_elements["point_info"].alpha = 0;
        self.hud_elements["point_info"] setvalue(0);
    }

    if(!isdefined(self.hud_elements["highest_point"])) {
        self.hud_elements["highest_point"] = newclienthudelem(self);
        self.hud_elements["highest_point"].horzalign = "fullscreen";
        self.hud_elements["highest_point"].vertalign = "fullscreen";
        self.hud_elements["highest_point"].alignx = "left";
        self.hud_elements["highest_point"].aligny = "bottom";
        self.hud_elements["highest_point"].x = self.player_settings["height_x"] + 2;
        self.hud_elements["highest_point"].y = self.player_settings["height_y"];
        self.hud_elements["highest_point"].fontscale = 1;
        self.hud_elements["highest_point"].sort = 3;
        self.hud_elements["highest_point"].font = "small";
        self.hud_elements["highest_point"].colorname = "red";
        self.hud_elements["highest_point"].label = &"^8Highest Point:\r                                       ^7&&1^8m";
        self.hud_elements["highest_point"].alpha = 0;
        self.hud_elements["highest_point"] setvalue(0);
    }

    fxEnt = undefined;

   while(1) {
        self waittill("waypoint");

        if(self.sessionstate != "spectator") {
            if(isdefined(self.isdemo)) {
                self unlink();

                if(isdefined(self.demo_timeline_hud)) {
                    foreach(hud in self.demo_timeline_hud) {
                        if(isdefined(hud))
                            hud destroy();
                    }
                }

                if(isdefined(self.hud_elements["clip_by"]))
                    self.hud_elements["clip_by"] destroy();

                self thread send_clientcmd("-attack;-speed_throw;-forward;-sprint");

                self.demo_prepare_watch             = undefined;
                self.isdemo                         = undefined;

                self.keyw = 0;
                self.keya = 0;
                self.keys = 0;
                self.keyd = 0;

                self notify("demo_leave");

                self takeallweapons();
                self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);

                wait .1;

                clip_data = strtok(readfile(self.watching_file, 0, 0, int(countlines(self.watching_file) - 1)), ",");

                self setorigin((float(clip_data[0]), float(clip_data[1]), float(clip_data[2])));
                self setplayerangles((float(clip_data[3]), float(clip_data[4]), float(clip_data[5])));

                clip_data = undefined;

                if(isdefined(self.hud_elements["demo_binds"]))
                    self.hud_elements["demo_binds"].alpha = 0;
            }
            else {
                if(isdefined(fxEnt))
                    fxEnt delete();

                self.waypoint.origin = self.origin + (0, 0, .05);

                if(self.waypoint.hidden == 1) {
                    self.waypoint.hidden = 0;
                    fxEnt = SpawnFX(level.waypoint_fx, self.waypoint.origin);
                    triggerfx(fxEnt);
                    self.hud_elements["point_info"].alpha = 1;
                    self.hud_elements["highest_point"].alpha = 1;
                    self.hud_elements["point_bg"].alpha = .85;
                    self iPrintLnBold("^8Marker ^7Placed, ^:Press again to Delete!");
                }
                else {
                    self.waypoint hide();
                    self.waypoint.hidden = 1;
                    self.hud_elements["point_info"].alpha = 0;
                    self.hud_elements["highest_point"].alpha = 0;
                    self.hud_elements["point_bg"].alpha = 0;
                    self iPrintLnBold("^8Marker ^7Removed!");
                }
            }
        }
        else {
            player = self GetSpectatingPlayer();

            if(isdefined(player)) {
                self.sessionstate = "playing";
                self takeallweapons();
                wait .05;
                self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
                self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                self.origin = player.origin;
                self.angles = player getplayerangles();
            }
        }
    }
}

commands_init() {
    while(1) {
        level waittill("say", message, player);

        message_data = strtok(message, " ");

        if(isdefined(message_data[0])) {
            if(message_data[0] == "!teleport" || message_data[0] == "!t") {
                if(isdefined(message_data[1])) {
                    target = cmd_find_player(message_data[1]);

                    if(isdefined(target)) {
                        if(!target isonground())
                            player setorigin(target.origin);
                        else
                            player setorigin(target.saved_position.origin);

                        player tell_raw(level.commands_prf + "Teleported to ^8" + target.name);
                    }
                    else
                        player tell_raw(level.commands_prf + "Player ^8" + message_data[1] + "^7 Not Found!");
                }
                else
                    player tell_raw(level.commands_prf + "Not Enough Arguments for Command ^8" + message_data[0]);
            }
            else if(message_data[0] == "!reset" || message_data[0] == "!r") {
                player setorigin(player.saved_spawn);
                player setplayerangles(player.saved_angles);
            }
            else if(message_data[0] == "!demo" || message_data[0] == "!d") {
                found = false;

                for(i = 0;i < level.demo_clips.size;i++) {
                    if(isdefined(level.demo_clips[i]["origin"])) {
                        if(distance(player.origin, level.demo_clips[i]["origin"]) < 150) {
                            player thread play_demo(i);
                            found = true;
                            break;
                        }
                    }
                }

                if(found == false)
                    player iPrintLnBold("^8No Clips Found near you!");
            }
            else if(message_data[0] == "!load" || message_data[0] == "!l") {
                if(isdefined(message_data[1])) {
                    message_data[1] = int(message_data[1]) + 1;

                    if(isdefined(player.save_history[int(message_data[1])])) {
                        player.saved_position.origin = player.save_history[int(message_data[1])].origin;
                        player.saved_position.angles = player.save_history[int(message_data[1])].angles;

                        player setorigin(player.saved_position.origin);
                        player setplayerangles(player.saved_position.angles);

                        player tell_raw(level.commands_prf + "Loaded ^8" + int(message_data[1] - 1) + "^7 Position!");
                    }
                    else
                        player tell_raw(level.commands_prf + "Saved Position ^8" + int(message_data[1] - 1) + "^7 Doesnt Exist!");
                }
                else
                    player tell_raw(level.commands_prf + "Not Enough Arguments for Command ^8" + int(message_data[1] - 1));
            }
        }
    }
}

hud_distance() {
    self endon("disconnect");

    if(!isdefined(self.hud_elements["distance_value"])) {
        self.hud_elements["distance_value"] = newclienthudelem(self);
        self.hud_elements["distance_value"].horzalign = "fullscreen";
        self.hud_elements["distance_value"].vertalign = "fullscreen";
        self.hud_elements["distance_value"].alignx = "center";
        self.hud_elements["distance_value"].aligny = "middle";
        self.hud_elements["distance_value"].x = 320;
        self.hud_elements["distance_value"].y = 240;
        self.hud_elements["distance_value"].alpha = 0;
        self.hud_elements["distance_value"].label = &"^8&&1^7m";
        self.hud_elements["distance_value"].fontscale = 1.2;
    }

    while(1) {
        if(self adsbuttonpressed() && !issubstr(self getcurrentweapon(), "rpg") && !isdefined(self.isdemo) && !isdefined(self.cj_ufo) && !isdefined(self.cj_noclip)) {
            vec = anglesToForward(self getPlayerAngles());
            end = (vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
            location = BulletTrace(self geteye(),end,0,self)["position"];
            value = int(distance(self geteye(), location) / 64);

            if(value < 100000) {
                self.hud_elements["distance_value"] setvalue(value);

                if(self.hud_elements["distance_value"].alpha != 1)
                    self.hud_elements["distance_value"].alpha = 1;
            }
            else {
                if(self.hud_elements["distance_value"].alpha != 0)
                    self.hud_elements["distance_value"].alpha = 0;
            }
        }
        else {
            if(self.hud_elements["distance_value"].alpha != 0)
                self.hud_elements["distance_value"].alpha = 0;
        }

        if(self.hud_elements["deathbarrier"].alpha == 1)
            self.hud_elements["deathbarrier"].alpha = 0;

        wait .05;
    }
}

weapon_inspect() {
    self endon("disconnect");

    time_gone       = 150;
    weapon          = undefined;
    animname        = "";

    self thread weapon_inspect_change();
    self thread weapon_inspect_velocity();

    while(1) {
        if(isdefined(self.vel) && !isdefined(self.isdemo) && self.player_settings["inspect"] != 0) {
            if(self.vel == 0) {
                while(self.vel == 0 && time_gone >= 0 && !self adsbuttonpressed()) {
                    time_gone--;
                    wait .05;
                }

                if(time_gone <= 0) {
                    if(issubstr(self getcurrentweapon(), "rpg")) {
                        weapon = level.cj_weapons.rpg;
                        animname = "h1_wpn_lau_rpg_inspect";
                    }
                    else {
                        weapon = level.cj_weapons.deagle;
                        animname = "h1_wpn_pst_de50_inspect";
                    }

                    self giveweapon(weapon + "inspect_mp", self.player_settings["camo"]);
                    self setspawnweapon(weapon + "inspect_mp_camo0" + self.player_settings["camo"]);

                    self waittill_or_timeout("inspect_over", 6);
                    time_gone = 150;

                    weapons = self getWeaponsListPrimaries();
                    foreach(weap in weapons) {
                        if(issubstr(weap, "inspect"))
                            self takeweapon(weap);
                    }

                    self giveweapon(weapon + "_mp", self.player_settings["camo"]);
                    self setspawnweapon(weapon + "_mp_camo0" + self.player_settings["camo"]);
                }
            }
            else {
                if(time_gone != 150)
                    time_gone = 150;
            }
        }

        wait .05;
    }
}

weapon_inspect_change() {
    self endon("disconnect");

    while(1) {
        self waittill("weapon_change", name);

        if(!issubstr(name, "inspect"))
            self notify("inspect_over");
    }
}

weapon_inspect_velocity() {
    self endon("disconnect");

    while(1) {
        if(issubstr(self getcurrentweapon(), "inspect") && self.vel > 0 || issubstr(self getcurrentweapon(), "inspect") && self attackbuttonpressed())
            self notify("inspect_over");

        wait .05;
    }
}

hud_second_color() {
    self endon("disconnect");

    wait 1;

    self.saved_position.origin = self.origin;
    self.saved_position.angles = self getplayerangles();

    while(1) {
        if(self.player_settings["hud_sec_c"] == 1) {
            if(isdefined(self.vel)) {
                normalized_value = min(1.0, max(0.0, float(self.vel / 1000)));

                interpolated_r = self.choosencolor[0] + (self.choosencolor_2[0] - self.choosencolor[0]) * normalized_value;
                interpolated_g = self.choosencolor[1] + (self.choosencolor_2[1] - self.choosencolor[1]) * normalized_value;
                interpolated_b = self.choosencolor[2] + (self.choosencolor_2[2] - self.choosencolor[2]) * normalized_value;

                if(isdefined(self.hud_elements["velocity"]))
                    self.hud_elements["velocity"].color = (interpolated_r, interpolated_g, interpolated_b);
                if(isdefined(self.hud_keyboard["hud_key_w"])) {
                    self.hud_keyboard["hud_key_w"].color = self.hud_elements["velocity"].color;
                    self.hud_keyboard["hud_key_a"].color = self.hud_elements["velocity"].color;
                    self.hud_keyboard["hud_key_s"].color = self.hud_elements["velocity"].color;
                    self.hud_keyboard["hud_key_d"].color = self.hud_elements["velocity"].color;
                }
                if(isdefined(self.playerrun_timer))
                    self.playerrun_timer.color = self.hud_elements["velocity"].color;
                if(isdefined(self.hud_elements["fps_counter"]))
                    self.hud_elements["fps_counter"].color = self.hud_elements["velocity"].color;
                if(isdefined(self.hud_elements["compass_angles"]))
                    self.hud_elements["compass_angles"].color = self.hud_elements["velocity"].color;
                if(isdefined(self.hud_elements["compass_line"]))
                    self.hud_elements["compass_line"].color = self.hud_elements["velocity"].color;
                if(isdefined(self.hud_elements["compass_bg"]))
                    self.hud_elements["compass_bg"].color = self.hud_elements["velocity"].color;
            }
        }
        else {
            if(self.hud_elements["velocity"].color != self.choosencolor) {
                if(isdefined(self.hud_elements["velocity"]))
                    self.hud_elements["velocity"].color = self.choosencolor;
                if(isdefined(self.hud_keyboard["hud_key_w"])) {
                    self.hud_keyboard["hud_key_w"].color = self.choosencolor;
                    self.hud_keyboard["hud_key_a"].color = self.choosencolor;
                    self.hud_keyboard["hud_key_s"].color = self.choosencolor;
                    self.hud_keyboard["hud_key_d"].color = self.choosencolor;
                }
                if(isdefined(self.playerrun_timer))
                    self.playerrun_timer.color = self.choosencolor;
                if(isdefined(self.hud_elements["fps_counter"]))
                    self.hud_elements["fps_counter"].color = self.choosencolor;
                if(isdefined(self.hud_elements["compass_angles"]))
                    self.hud_elements["compass_angles"].color = self.choosencolor;
                if(isdefined(self.hud_elements["compass_line"]))
                    self.hud_elements["compass_line"].color = self.choosencolor;
                if(isdefined(self.hud_element_xp["xp_bar"]))
                    self.hud_element_xp["xp_bar"].color = self.choosencolor;
                if(isdefined(self.hud_element_xp["xp_value_max"]))
                    self.hud_element_xp["xp_value_max"].color = self.choosencolor;
                if(isdefined(self.hud_element_xp["xp_value"]))
                    self.hud_element_xp["xp_value"].color = self.choosencolor;
            }
        }

        wait .1;
    }
}

menu_handler() {
    self endon("disconnect");

    self.clips_menu_page = 1;

    desc = undefined;
    self.clip_save_desc = "";
    self.found_players = [];
    self setclientdvar("clip_description_txt", "^8Type to Write^7!");

    while(1) {
        self waittill("menuresponse", menu, response);

        if(response == "clips_closed") {
            if(isdefined(self.saving_clip) && !isdefined(self.creating_clip)) {
                self.saving_clip = 0;
                self notify("demo_abbauen");
            }
        }

        if(response == "clips_update")
            self thread update_clips_menu();

        if(response == "update_player_stats")
            self notify("player_stats_updated");

        if(response == "resumegame") {
            if(self.sessionstate == "spectator") {
                self.sessionstate = "playing";
                self takeallweapons();
                wait .05;
                self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
                self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
            }
        }

        if(response == "spectator") {
            if(!isdefined(self.isspeedrun)) {
                if(self.sessionstate != "spectator") {
                    if(isdefined(self.isdemo)) {
                        self unlink();

                        if(isdefined(self.demo_timeline_hud)) {
                            foreach(hud in self.demo_timeline_hud) {
                                if(isdefined(hud))
                                    hud destroy();
                            }
                        }

                        if(isdefined(self.hud_elements["clip_by"]))
                            self.hud_elements["clip_by"] destroy();

                        self thread send_clientcmd("-attack;-speed_throw;-forward;-sprint");

                        self.demo_prepare_watch             = undefined;
                        self.isdemo                         = undefined;

                        self.keyw = 0;
                        self.keya = 0;
                        self.keys = 0;
                        self.keyd = 0;

                        self notify("demo_leave");

                        if(isdefined(self.hud_elements["demo_binds"]))
                            self.hud_elements["demo_binds"].alpha = 0;
                    }

                    if(isdefined(self.isspeedrun))
                        self notify("leaderboard_run_over", "Entered Spectator");

                    self allowSpectateTeam("allies", 1 );
                    self allowSpectateTeam("axis", 1 );
                    self allowSpectateTeam("freelook", 1 );
                    self allowSpectateTeam("none", 1 );
                    self.sessionstate = "spectator";
                }
                else {
                    self.sessionstate = "playing";
                    self takeallweapons();
                    self setorigin(self.saved_spawn);
                    self setplayerangles(self.saved_angles);
                    wait .05;
                    self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                    self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
                    self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                }
            }
            else
                self iprintlnbold("^8Not Allowed in a Speedrun!");
        }

        if(menu == "team_select") {
            if(response == "mapvote_accept") {
                if(!isdefined(self.voting_has_voted)) {
                    self.voting_has_voted = 1;
                    level.map_votes++;
                    self tell_raw(level.chat_prefix + "Successfully Voted for ^3" + level.vote_in_progress.conv_name + "^7!");

                    foreach(player in level.players)
                        player setclientdvar("menu_voting_votes", "Votes: ^2" + int(level.map_votes) + "^7 / ^1" + int(level.players.size));
                }
            }
            else if(response == "mapvote_decline") {
                if(!isdefined(self.voting_has_voted)) {
                    self.voting_has_voted = 1;
                    level.map_vote_declines++;
                    self tell_raw(level.chat_prefix + "Successfully Declined Vote!");
                }
            }
            else if(response == "create_course") {
                self setclientdvar("cj_course_hud", 1);

                self thread client_courses_init();
            }
        }

        if(menu == "main_info") {
            if(response == "info_menu_selection_1")
                self setclientdvar("menu_cj_info_header", "What is Codjumper");
            else if(response == "info_menu_selection_2")
                self setclientdvar("menu_cj_info_header", "Commands");
            else if(response == "info_menu_selection_3")
                self setclientdvar("menu_cj_info_header", "FPS Information");
            else if(response == "info_menu_selection_4")
                self setclientdvar("menu_cj_info_header", "Dvars");
            else if(response == "info_menu_selection_5")
                self setclientdvar("menu_cj_info_header", "Changelog");
            else if(response == "info_menu_selection_6")
                self setclientdvar("menu_cj_info_header", "Credits & Contributors");
            else if(response == "info_menu_selection_7")
                self setclientdvar("menu_cj_info_header", "Other Servers");
        }

        if(menu == "main_profiles") {
            if(issubstr(response, "profile_watch_")) {
                which = int(strtok(response, "_")[2]);

                if(isdefined(level.client_stats[self.client_search[which]])) {
                    csv_data = readfile(getDvar("fs_homepath") + "/cjstats" + "/players/_total_stats/" + level.client_stats[self.client_search[which]] + ".csv");
                    data = csv_decode(csv_data)[0];

                    self.viewing_profile = data["name"];
                    self setclientdvar("ui_profiles_name", self.viewing_profile);

                    if(!isdefined(data["routes"]))
                        data["routes"] = 0;
                    if(!isdefined(data["clips_created"]))
                        data["clips_created"] = 0;
                    if(!isdefined(data["saves"]))
                        data["saves"] = 0;
                    if(!isdefined(data["loads"]))
                        data["loads"] = 0;
                    if(!isdefined(data["rpg_fired"]))
                        data["rpg_fired"] = 0;

                    self setclientdvars("cj_stats_profile_routes", int(data["routes"]), "cj_stats_profile_clips", int(data["clips_created"]), "cj_stats_profile_fav_map", "Dome", "cj_stats_profile_playtime", to_mins(int(int(data["timeplayed"]) * 60)), "cj_stats_profile_rpg", int(data["rpg_fired"]), "cj_stats_profile_bounces", int(data["bounces"]), "cj_stats_profile_saves", int(data["saves"]), "cj_stats_profile_loads", int(data["loads"]));
                }
            }
            else {
                if(self.client_saarch_current.size <= 25) {
                    if(response == "backSpace")
                        self.client_saarch_current = getsubstr(self.client_saarch_current, 0, self.client_saarch_current.size - 1);
                    else if(response == "space")
                        self.client_saarch_current += " ";
                    else
                        self.client_saarch_current += response;
                }
                else if(response == "backSpace")
                    self.client_saarch_current = getsubstr(self.client_saarch_current, 0, self.client_saarch_current.size - 1);

                if(self.client_saarch_current == "")
                    self setClientDvar("ui_cj_map_list_textfield", "Type to Search");
                else {
                    self setClientDvar("ui_cj_map_list_textfield", self.client_saarch_current);

                    found                   = 0;
                    keys                    = getArrayKeys(level.client_stats);
                    self.found_players      = undefined;
                    self.found_players      = [];

                    for(i = 0;i < keys.size;i++) {
                        if(found == 8)
                            break;

                        key = tolower(keys[i]);

                        if(issubstr(key, tolower(self.client_saarch_current))) {
                            if(!isdefined(self.found_players[key])) {
                                self.client_search[found] = keys[i];
                                self.found_players[key] = level.client_stats[keys[i]];
                                found++;
                            }
                        }
                    }

                    player_str = "";
                    for(i = 0;i < self.client_search.size;i++) {
                        if(isdefined(self.client_search[i])) {
                            if(self.client_search[i] != "")
                                player_str += self.client_search[i] + "\n";
                        }
                    }

                    self setClientDvar("cj_profiles_playersrc", player_str);
                }
            }
        }

        if(menu == "main_leaderboard") {
            if(isdefined(level.map_data)) {
                if(response == "category_next") {
                    keys = getarraykeys(level.map_data["routes"]);

                    if(self.category_selected >= (keys.size - 1))
                        self.category_selected = 0;
                    else
                        self.category_selected += 1;

                    self setclientdvar("menu_settings_category", keys[self.category_selected]);

                    if(keys[self.category_selected] == "total_stats")
                        self setclientdvars("menu_settings_category", "Total Stats", "menu_leaderboard_header_2", "Bounces");
                    else
                        self setclientdvars("menu_settings_category", keys[self.category_selected], "menu_leaderboard_header_2", "Time");

                    for(i = 0;i < 10;i++) {
                        data = strtok(level.leaderboard_data[keys[self.category_selected]][i], ",");

                        if(!isdefined(data))
                            break;

                        if(keys[self.category_selected] != "total_stats") {
                            if(data[0] != "none") {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + to_mins(float(data[1])) + "\r                                                                                          " + data[2]);
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                            }
                            else {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                            }
                        }
                        else {
                            if(data[0] != "none") {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + int(data[1]) + "\r                                                                                          " + data[2]);
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                            }
                            else {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                            }
                        }
                    }
                }
                else if(response == "category_prev") {
                    keys = getarraykeys(level.map_data["routes"]);

                    if((self.category_selected - 1) < 0)
                        self.category_selected = (keys.size - 1);
                    else
                        self.category_selected -= 1;

                    self setclientdvar("menu_settings_category", keys[self.category_selected]);

                    if(keys[self.category_selected] == "total_stats")
                        self setclientdvars("menu_settings_category", "Total Stats", "menu_leaderboard_header_2", "Bounces");
                    else
                        self setclientdvars("menu_settings_category", keys[self.category_selected], "menu_leaderboard_header_2", "Time");

                    for(i = 0;i < 10;i++) {
                        data = strtok(level.leaderboard_data[keys[self.category_selected]][i], ",");

                        if(!isdefined(data))
                            break;

                        if(keys[self.category_selected] != "total_stats") {
                            if(data[0] != "none") {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + to_mins(float(data[1])) + "\r                                                                                          " + data[2]);
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                            }
                            else {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                            }
                        }
                        else {
                            if(data[0] != "none") {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + int(data[1]) + "\r                                                                                          " + data[2]);
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                            }
                            else {
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                                self setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                            }
                        }
                    }
                }
                else if(response == "refresh_leaderboards")
                    self thread leaderboard_refresh();
                else if(response == "start_leaderboard_run") {
                    if(self.sessionstate == "playing") {
                        if(!isdefined(self.isspeedrun))
                            self notify("begin_playerrun");
                        else
                            self notify("leaderboard_run_over", "Run Canceled");
                    }
                    else
                        self iPrintLnBold("^8Leave Spectator First!");
                }
                else if(response == "continue_leaderboard_run") {
                    if(self.sessionstate == "playing") {
                        if(isdefined(self.has_old_lb_run) && !isdefined(self.isspeedrun))
                            self thread leaderboard_continue_run();
                        else if(isdefined(self.isspeedrun))
                            self thread playerrun_pause();
                    }
                    else
                        self iPrintLnBold("^8Leave Spectator First!");
                }
            }
        }

        if(menu == "main_map_vote") {
            if(response == "filter_vote_all") {
                self.current_mapvote_filter = "all";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "filter_vote_cod4") {
                self.current_mapvote_filter = "cod4";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "filter_vote_mw2") {
                self.current_mapvote_filter = "mw2";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "filter_vote_mw3") {
                self.current_mapvote_filter = "mw3";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "filter_vote_codo") {
                self.current_mapvote_filter = "codo";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "filter_vote_cj") {
                self.current_mapvote_filter = "cj";
                self.cj["search"] = "";
                maplist = getMapList(self);
                self.voting_pages = calc_mapvote_pages(maplist.size, 6);
                self setClientdvar("ui_cj_map_list_pagecount", self.cj["page"] + " / " + self.voting_pages);
                self updateDvars();
            }
            else if(response == "vote_next")
                self setNextPage();
            else if(response == "vote_prev")
                self setPrevPage();
            else if(issubstr(response, "vote_call_")) {
                if(voteInProgress())
                    self iPrintLnBold("^8a Mapvote is already Running, Please Wait!");
                else {
                    items = self getPageItems(self.cj["page"]);
                    map = strtok(response, "_")[2];
                    level.vote_in_progress = items[int(map)];

                    level.map_votes++;
                    self.voting_has_voted = 1;
                    level.map_vote_declines = 0;

                    if(level.players.size == 1)
                        level thread mapvote_handler_server(1);
                    else {
                        players = 0;

                        foreach(player in level.players) {
                            if(player.afk != 1)
                                players++;
                        }

                        if(players == 1)
                            level thread mapvote_handler_server(1);
                        else {
                            level thread mapvote_handler_server(0);

                            foreach(player in level.players)
                                player setclientdvars("menu_voting_map", level.vote_in_progress.mapname, "menu_voting_votes", "Votes: ^2" + level.map_votes + "^7 / ^1" + level.players.size);

                            if(level.players.size != 1) {
                                say_raw(level.chat_prefix + "^:" + self.name + "^7: Started a Vote for ^8" + level.vote_in_progress.conv_name);
                                say_raw(level.chat_prefix + "vote in the ^8Main Menu^7");
                            }
                        }
                    }
                }
            }

            if(IsSubStr(response, "char_")) {
                pattern = "char_";
                char = getSubStr(response, pattern.size);

                self doSearch(char);
            }
        }

        if(menu == "main_music_menu") {
            if(response == "stop_music")
                self stoplocalsound(self.selected_music);
            else {
                if(isdefined(self.selected_music))
                    self stoplocalsound(self.selected_music);

                self playlocalsound(level.music_data[int(response)].filename);
                self.selected_music = level.music_data[int(response)].filename;

                self iprintlnbold("Now Playing: ^8" + level.music_data[int(response)].songname + "^7 By ^8" + level.music_data[int(response)].artist);
            }
        }

        if(menu == "main_mod_settings") {
            if(response == "reset_hud") {
                if(isdefined(self.hud_elements["velocity"])) {
                    self.hud_elements["velocity"].x = level.base_values["vel_x"];
                    self.hud_elements["velocity"].y = level.base_values["vel_y"];
                    self.hud_elements["velocity"].fontscale = level.base_values["vel_fs"];

                    self.player_settings["vel_x"] = level.base_values["vel_x"];
                    self.player_settings["vel_y"] = level.base_values["vel_y"];
                    self.player_settings["vel_fs"] = level.base_values["vel_fs"];
                }

                if(isdefined(self.hud_elements["fps_counter"])) {
                    self.hud_elements["fps_counter"].x = level.base_values["fpsx"];
                    self.hud_elements["fps_counter"].y = level.base_values["fpsy"];
                    self.hud_elements["fps_counter"].fontscale = level.base_values["fpsfs"];

                    self.player_settings["fpsx"] = level.base_values["fpsx"];
                    self.player_settings["fpsy"] = level.base_values["fpsy"];
                    self.player_settings["fpsfs"] = level.base_values["fpsfs"];
                }

                self.player_settings["key_x"] = level.base_values["key_x"];
                self.player_settings["key_y"] = level.base_values["key_y"];

                self.player_settings["height_x"] = level.base_values["height_x"];
                self.player_settings["height_y"] = level.base_values["height_y"];

                self.hud_keyboard["hud_key_a"].x = self.player_settings["key_x"] - 2;
                self.hud_keyboard["hud_key_a"].y = self.player_settings["key_y"] + 2;
                self.hud_keyboard["hud_key_s"].x = self.player_settings["key_x"];
                self.hud_keyboard["hud_key_s"].y = self.player_settings["key_y"] + 2;
                self.hud_keyboard["hud_key_d"].x = self.player_settings["key_x"] + 2;
                self.hud_keyboard["hud_key_d"].y = self.player_settings["key_y"] + 2;
                self.hud_keyboard["hud_key_w"].x = self.player_settings["key_x"];
                self.hud_keyboard["hud_key_w"].y = self.player_settings["key_y"];

                self.player_settings["R"] = level.base_values["R"];
                self.player_settings["G"] = level.base_values["G"];
                self.player_settings["B"] = level.base_values["B"];
                self.player_settings["R2"] = level.base_values["R2"];
                self.player_settings["G2"] = level.base_values["G2"];
                self.player_settings["B2"] = level.base_values["B2"];

                self.player_settings["min_x"] = level.base_values["min_x"];
                self.player_settings["min_y"] = level.base_values["min_y"];

                self.player_settings["minimap"] = level.base_values["minimap"];

                self setclientdvars("cj_minimap_x", self.player_settings["min_x"], "cj_minimap_y", self.player_settings["min_y"]);

                if(isdefined(self.hud_elements["compass_angles"])) {
                    self.hud_elements["compass_angles"].x = self.player_settings["min_x"] - 50;
                    self.hud_elements["compass_angles"].y = self.player_settings["min_y"] + 15;
                    self.hud_elements["compass_line"].x = self.player_settings["min_x"] - 50;
                    self.hud_elements["compass_line"].y = self.player_settings["min_y"] + 11;
                }

                self.hud_elements["compass_bg"].x = self.player_settings["min_x"] - 50;
                self.hud_elements["compass_bg"].y = self.player_settings["min_y"] + 5;

                self change_hud_color();

                self notify("player_stats_updated");
            }
            else if(response == "change_hud_position" && !isdefined(self.hud_element_editor))
                self thread hud_element_editor();
            else if(response == "change_hud_color" && !isdefined(self.hud_element_editor))
                self thread hud_color_editor(undefined);
            else if(response == "change_hud_color_2" && !isdefined(self.hud_element_editor))
                self thread hud_color_editor(1);
            else if(issubstr(response, "settings_"))
                self thread settings_handler(response);
        }

        if(menu == "main_weapon_camos") {
            if(self.player_settings["bounces"] >= int(tablelookup( "mp/customcamotable.csv", 0, int(response), 5))) {
                self.player_settings["camo"] = int(response);
                self notify("player_stats_updated");

                weapon = self getcurrentweapon();
                self takeallweapons();

                if(issubstr(weapon, "rpg")) {
                    self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                    self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);

                    if(self.player_settings["camo"] < 10) {
                        self switchtoweapon(level.cj_weapons.rpg + "_mp_camo0" + self.player_settings["camo"]);
                        self setspawnweapon(level.cj_weapons.rpg + "_mp_camo0" + self.player_settings["camo"]);
                    }
                    else {
                        self switchtoweapon(level.cj_weapons.rpg + "_mp_camo" + self.player_settings["camo"]);
                        self setspawnweapon(level.cj_weapons.rpg + "_mp_camo" + self.player_settings["camo"]);
                    }
                }
                else {
                    self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                    self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);

                    if(self.player_settings["camo"] < 10) {
                        self switchtoweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                        self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                    }
                    else {
                        self switchtoweapon(level.cj_weapons.deagle + "_mp_camo" + self.player_settings["camo"]);
                        self setspawnweapon(level.cj_weapons.deagle + "_mp_camo" + self.player_settings["camo"]);
                    }
                }

                weapon = undefined;
            }
            else
                self tell_raw(level.chat_prefix + "Camo ^8" + response + "^7 will be unlocked at ^8" + tablelookup( "mp/customcamotable.csv", 0, int(response), 5) + "^7 Bounces!");
        }

        if(menu == "main_clip_browser") {
            if(response == "clips_prev") {
                if(self.clips_menu_page != 1)
                    self update_clips_menu("prev");
            }
            else if(response == "clips_next") {
                if(self.clips_menu_page < level.clip_max_pages)
                    self update_clips_menu("next");
            }
            else if(issubstr(response, "clip_play_")) {
                for(i = 0;i <= level.clip_max_items;i++) {
                    if(response == "clip_play_" + i) {
                        if(self.current_clip_filter != "no_filter")
                            self thread play_demo(i - 1);
                        else
                            self thread play_demo((level.clip_max_items * (self.clips_menu_page - 1)) + i - 1);
                    }
                }
            }
            else if(issubstr(response, "delete_clip_")) {
                for(i = 0;i <= level.clip_max_items;i++) {
                    if(response == "delete_clip_" + i) {
                        if(self.current_clip_filter != "no_filter")
                            level thread delete_clip((i - 1), self);
                        else
                            level thread delete_clip((level.clip_max_items * (self.clips_menu_page - 1)) + i - 1, self);
                    }
                }
            }
            else if(issubstr(response, "rename_clip_")) {
                for(i = 0;i <= level.clip_max_items;i++) {
                    if(response == "rename_clip_" + i) {
                        if(self.current_clip_filter != "no_filter")
                            level thread rename_clip((i - 1), self);
                        else
                            level thread rename_clip((level.clip_max_items * (self.clips_menu_page - 1)) + i - 1, self);
                    }
                }
            }
            else if(response == "backy") {
                self notify("demo_abbauen");

                if(isdefined(self.saving_clip) && !isdefined(self.creating_clip))
                    self.saving_clip = 0;
            }
            else if(response == "save_clip") {
                if(self.clip_save_desc == "")
                    self notify("demo_abbauen");
                else
                    self notify("clip_saved");
            }
            else if(response == "filter_clip_spots")
                self thread filter_clips("# ^8Spots");
            else if(response == "filter_clip_oom")
                self thread filter_clips("# ^6Out of Map");
            else if(response == "filter_clip_challenge")
                self thread filter_clips("# ^1Challenge");
            else if(response == "filter_clip_course")
                self thread filter_clips("# ^2Course");
            else if(response == "filter_clip_route")
                self thread filter_clips("# ^4Route");
            else if(response == "filter_clip_slideybob")
                self thread filter_clips("# ^3Slideybob");
            else if(response == "filter_clip_other")
                self thread filter_clips("# ^5Others");
            else if(response == "filter_clip_all")
                self thread filter_clips("no_filter");
            else if(issubstr(response, "tag_selected_")) {
                if(response == "tag_selected_1") {
                    self setclientdvar("clip_current_tag", "# ^8Spots");
                    self.current_clip_tag = "# ^8Spots";
                }
                else if(response == "tag_selected_2") {
                    self setclientdvar("clip_current_tag", "# ^6Out of Map");
                    self.current_clip_tag = "# ^6Out of Map";
                }
                else if(response == "tag_selected_3") {
                    self setclientdvar("clip_current_tag", "# ^1Challenge");
                    self.current_clip_tag = "# ^1Challenge";
                }
                else if(response == "tag_selected_4") {
                    self setclientdvar("clip_current_tag", "# ^2Course");
                    self.current_clip_tag = "# ^2Course";
                }
                else if(response == "tag_selected_5") {
                    self setclientdvar("clip_current_tag", "# ^4Route");
                    self.current_clip_tag = "# ^4Route";
                }
                else if(response == "tag_selected_6") {
                    self setclientdvar("clip_current_tag", "# ^3Slideybob");
                    self.current_clip_tag = "# ^3Slideybob";
                }
                else if(response == "tag_selected_7") {
                    self setclientdvar("clip_current_tag", "# ^5Others");
                    self.current_clip_tag = "# ^5Others";
                }
            }
            else {
                if(self.clip_save_desc.size <= 20) {
                    if(response == "backSpace")
                        self.clip_save_desc = getsubstr(self.clip_save_desc, 0, self.clip_save_desc.size - 1);
                    else if(response == "space")
                        self.clip_save_desc += " ";
                    else if(response == "caps") {
                        if(self.capslock == 0)
                            self.capslock = 1;
                        else
                            self.capslock = 0;
                    }
                    else if(response != "clips_update" && response != "clips_closed") {
                        if(self.capslock == 1) {
                            if(response == "1")
                                response = "!";
                            else if(response == "3")
                                response = "^";
                            else if(response == "4")
                                response = "$";
                            else if(response == "5")
                                response = "%";
                            else if(response == "6")
                                response = "&";
                            else if(response == "7")
                                response = "/";
                            else if(response == "8")
                                response = "(";
                            else if(response == "9")
                                response = ")";
                            else if(response == "0")
                                response = "=";
                            else if(response == ",")
                                response = ";";
                            else if(response == ".")
                                response = ":";

                            response = toupper(response);
                        }

                        self.clip_save_desc += response;

                        for(i = 0;i < level.dirty_words.size;i++) {
                            if(issubstr(tolower(self.clip_save_desc), level.dirty_words[i])) {
                                self tell_raw(level.clip_system_prf + "^1Bad Word Detected, ^7if you try to avoid it you can get a ^1Clip Ban");

                                self.clip_save_desc = "";
                            }
                        }
                    }
                }
                else if(response == "backSpace")
                    self.clip_save_desc = getsubstr(self.clip_save_desc, 0, self.clip_save_desc.size - 1);

                if(self.clip_save_desc == "")
                    self setclientdvar("clip_description_txt", "^8Type to Write^7!");
                else
                    self setclientdvar("clip_description_txt", self.clip_save_desc);
            }
        }
    }
}

input_tracker() {
    self endon("disconnect");

    self thread controller_analog_tracking();

    while(1) {
        if(!isdefined(self.isdemo)) {
            if(self usinggamepad() == 1)
                self.current_input = "controller";
            else
                self.current_input = "keyboard";
        }

        wait .05;
    }
}

controller_analog_tracking() {
    self endon("disconnect");

    if(!isdefined(self.hud_elements["analog_circle"])) {
        self.hud_elements["analog_circle"] = newclienthudelem(self);
        self.hud_elements["analog_circle"].horzalign = "fullscreen";
        self.hud_elements["analog_circle"].vertalign = "fullscreen";
        self.hud_elements["analog_circle"].alignx = "center";
        self.hud_elements["analog_circle"].aligny = "middle";
        self.hud_elements["analog_circle"].x = self.player_settings["key_x"];
        self.hud_elements["analog_circle"].y = self.player_settings["key_y"] + 10;
        self.hud_elements["analog_circle"].alpha = 0;
        self.hud_elements["analog_circle"].sort = 1;
        self.hud_elements["analog_circle"].color = self.choosencolor;
        self.hud_elements["analog_circle"].hidewheninmenu = 1;
        self.hud_elements["analog_circle"] setshader("analog_stick", 32, 32);
    }

    if(!isdefined(self.hud_elements["analog_circle_background"])) {
        self.hud_elements["analog_circle_background"] = newclienthudelem(self);
        self.hud_elements["analog_circle_background"].horzalign = "fullscreen";
        self.hud_elements["analog_circle_background"].vertalign = "fullscreen";
        self.hud_elements["analog_circle_background"].alignx = "center";
        self.hud_elements["analog_circle_background"].aligny = "middle";
        self.hud_elements["analog_circle_background"].x = self.player_settings["key_x"];
        self.hud_elements["analog_circle_background"].y = self.player_settings["key_y"] + 10;
        self.hud_elements["analog_circle_background"].sort = 0;
        self.hud_elements["analog_circle_background"].alpha = 0;
        self.hud_elements["analog_circle_background"].color = (1, 1, 1);
        self.hud_elements["analog_circle_background"].hidewheninmenu = 1;
        self.hud_elements["analog_circle_background"] setshader("analog_background", 32, 32);
    }

    while(1) {
        if(self.current_input == "controller") {
            if(self.hud_elements["analog_circle"].alpha != 1) {
                self.hud_elements["analog_circle"].alpha = 1;
                self.hud_elements["analog_circle_background"].alpha = 1;

                if(isdefined(self.hud_keyboard)) {
                    foreach(hud in self.hud_keyboard)
                        hud.alpha = 0;
                }
            }

            if(self.hud_elements["analog_circle"].alpha == 1) {
                input = self getnormalizedmovement();

                self.hud_elements["analog_circle"].x = self.hud_elements["analog_circle_background"].x + (input[1] * 12);
                self.hud_elements["analog_circle"].y = self.hud_elements["analog_circle_background"].y - (input[0] * 12);
            }
        }
        else {
            if(self.hud_elements["analog_circle"].alpha == 1) {
                self.hud_elements["analog_circle"].alpha = 0;
                self.hud_elements["analog_circle_background"].alpha = 0;

                if(isdefined(self.hud_keyboard)) {
                    foreach(hud in self.hud_keyboard)
                        hud.alpha = 1;
                }
            }
        }

        wait .05;
    }
}

rpg_helper() {
    self endon("disconnect");
    level endon("game_ended");

    while(1) {
        self waittill("weapon_fired", weaponname);

        if(!issubstr(weaponname, "rpg"))
            self givemaxammo(weaponname);

        self playlocalsound("rpg_sound_1");

        if(!self isonground()) {
            if(issubstr(self getcurrentweapon(), "rpg") && isdefined(self.bouncetime)) {
                if((gettime() - self.bouncetime) <= 200)
                    self thread rpg_shot_indicator((gettime() - self.bouncetime), (0, 1, 0));
                else if((gettime() - self.bouncetime) > 200 && (gettime() - self.bouncetime) <= 350)
                    self thread rpg_shot_indicator((gettime() - self.bouncetime), (1, 1, 0));
                else
                    self thread rpg_shot_indicator((gettime() - self.bouncetime), (1, 0, 0));

                wait 1;
                self.bouncetime = undefined;
            }
        }

        wait .05;
    }
}

rpg_shot_indicator(ms, color) {
    self endon("disconnect");

    if(ms < 1000) {
        if(isdefined(self.rpg_notification))
            self.rpg_notification destroy();

        self.rpg_notification = newclienthudelem(self);
        self.rpg_notification.horzalign = "fullscreen";
        self.rpg_notification.vertalign = "fullscreen";
        self.rpg_notification.alignx = "center";
        self.rpg_notification.aligny = "middle";
        self.rpg_notification.x = 320;
        self.rpg_notification.y = 380;
        self.rpg_notification.alpha = 0;
        self.rpg_notification.color = color;
        self.rpg_notification.fontscale = .5;
        self.rpg_notification.font = "bigfixed";
        self.rpg_notification.label = &"&&1 ms";
        self.rpg_notification setvalue(ms);

        self.rpg_notification fadeovertime(.2);
        self.rpg_notification.alpha = 1;
        wait 1;
        self.rpg_notification fadeovertime(1);
        self.rpg_notification.alpha = 0;
        wait 1;
        self.rpg_notification destroy();
    }
}

trail_fx() {
    self endon("disconnect");

    enty = spawn("script_model", (-900, 579, 567));
    enty setmodel("tag_origin");

    //ent2 = spawn("script_origin", self.origin + (0, 0, 30));
    //enty linkto(ent2);

    //ent2 linkto(self);

    wait 3;

    playfxontag(loadfx("mike/trailtest3"), enty, "tag_origin");

    while(1) {
        enty moveto((-1356, 1649, 567), .05);
        wait .05;
        enty moveto((-900, 579, 567), .05);
        wait .05;
    }
}

clips_system_watch() {
    self endon("disconnect");

    while(1) {
        self waittill("begin_clip");

        if(!isdefined(self.course_editor)) {
            if(self.sessionstate != "spectator") {
                if(!isdefined(self.clip_cooldown)) {
                    if(!isdefined(self.isdemo)) {
                        self.demo_owner = self.name;

                        self.saved_last_origin  = self.origin;
                        self.saved_last_angle   = self getplayerangles();

                        self.clip_model = spawn("script_model", (1, 1, 1));
                        self.clip_model setModel("tag_origin");
                        self.clip_model thread demo_clip_animate_model(self, self.clip_file, 1, self.player_settings["camo"]);
                    }
                }
                else
                    self iprintlnbold("^8Anti Clip Spamming, Wait a Little Bit!");
            }
            else {
                player = self GetSpectatingPlayer();

                if(isdefined(player)) {
                    self.sessionstate = "playing";
                    self takeallweapons();
                    wait .1;
                    self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
                    self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
                    self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
                    self setOrigin(player.saved_position.origin);
                    self setPlayerAngles(player.saved_position.angles);
                    self setvelocity((0, 0, 0));
                }
            }
        }
        else {
            if(!isdefined(self.checkpoints)) {
                self.checkpoints = [];
                self thread track_waypoints();
                //self thread checkpoint_trail();
            }

            self.checkpoints[self.checkpoints.size] = self.origin + (0, 0, 50);
            playfx(level.checkpoint_fx, self.checkpoints[self.checkpoints.size - 1]);
        }
    }
}

track_waypoints() {
    self endon("disconnect");

    self.course_waypoint = newclienthudelem(self);
	self.course_waypoint.archived = true;
	self.course_waypoint.alpha = .8;
	self.course_waypoint setShader("eye_emoji", 10, 10 );
	self.course_waypoint setWaypoint(false, false, false, false);

    while(1) {
        if(isdefined(self.checkpoints[self.checkpoints.size - 1])) {
            self.course_waypoint.x = self.checkpoints[self.checkpoints.size - 1][0];
            self.course_waypoint.y = self.checkpoints[self.checkpoints.size - 1][1];
            self.course_waypoint.z = self.checkpoints[self.checkpoints.size - 1][2] + 50;
        }

        wait .05;
    }
}

checkpoint_trail() {
    self endon("disconnect");

    model = spawn("script_model", (0, 0, 0));
    model setmodel("tag_origin");
    model thread playtrailfx();

    while(1) {
        if(self.checkpoints.size > 1) {
            curve = bezier_curve_3d(self.checkpoints);

            for(i = 0;i < curve.size;i++) {
                model moveto(curve[i], .055);
                wait .055;
            }

            model.origin = curve[0];
        }

        wait .055;
    }
}

playtrailfx() {
    while(isdefined(self)) {
        playfx(level.checkpoint_fx, self.origin);
        wait .05;
    }
}

missle_fire() {
    self endon("disconnect");

    while(1) {
        self waittill("missile_fire", missile, weaponName);

        if(issubstr(weaponname, "rpg")) {
            self setweaponammostock(weaponname, 1024);

            if(isdefined(missile)) {
                if(isdefined(self.playerrun_stats_rpg))
                    self.playerrun_stats_rpg++;

                self.player_settings["rpg_fired"]++;

                missile delete();
            }
        }
    }
}

keyboard_main() {
    self thread Wkey();
    self thread Akey();
    self thread Skey();
    self thread Dkey();
}

stop_everything_watcher() {
    self endon("disconnect");

    noclip                  = 1;
    ufo                     = 2;

    self.cj_noclip          = undefined;
    self.cj_ufo             = undefined;
    self.cj_cheat_skip      = 0;

    self thread cheat_commands_hud();

    while(1) {
        counta = self.clientflags;
        wait .05;
        countb = self.clientflags;

        if(!isdefined(self.cj_noclip) && !isdefined(self.cj_ufo)) {
            if(countb == (counta + noclip)) {
                if(self.cj_cheat_skip != 1) {
                    self iprintlnbold("Noclip ^8On");
                    iPrintLn("^8" + self.name + "^7 Entered ^8Noclip");
                    self.hud_elements["cheat_binds"].alpha = 1;
                }
                self.cj_noclip = 1;
            }
            if(countb == (counta + ufo)) {
                if(self.cj_cheat_skip != 1) {
                    self iprintlnbold("Ufo ^8On");
                    iPrintLn("^8" + self.name + "^7 Entered ^8Ufo");
                    self.hud_elements["cheat_binds"].alpha = 1;
                }
                self.cj_ufo = 1;
            }
        }
        else {
            if(countb == (counta - noclip)) {
                if(self.cj_cheat_skip != 1) {
                    self iprintlnbold("Noclip ^1Off");
                    self.hud_elements["cheat_binds"].alpha = 0;
                }
                self.cj_noclip = undefined;
            }
            if(countb == (counta - ufo)) {
                if(self.cj_cheat_skip != 1) {
                    self iprintlnbold("Ufo ^1Off");
                    self.hud_elements["cheat_binds"].alpha = 0;
                }
                self.cj_ufo = undefined;
            }
        }
    }
}

cheat_commands_hud() {
    if(!isdefined(self.hud_elements["cheat_binds"])) {
        self.hud_elements["cheat_binds"] = newclienthudelem(self);
        self.hud_elements["cheat_binds"].horzalign = "fullscreen";
        self.hud_elements["cheat_binds"].vertalign = "fullscreen";
        self.hud_elements["cheat_binds"].alignx = "left";
        self.hud_elements["cheat_binds"].aligny = "top";
        self.hud_elements["cheat_binds"].x = 2;
        self.hud_elements["cheat_binds"].y = 2;
        self.hud_elements["cheat_binds"].sort = 10000;
        self.hud_elements["cheat_binds"].fontscale = 1;
        self.hud_elements["cheat_binds"].font = "small";
        self.hud_elements["cheat_binds"].label = &"Check if inside Collision:\r                                                               ^8[{+actionslot 5}]\n^7Teleport on top of Collision:\r                                                               ^8[{+actionslot 1}]";
        self.hud_elements["cheat_binds"].alpha = 0;
        self.hud_elements["cheat_binds"].archived = 0;
        self.hud_elements["cheat_binds"].foreground = 1;
        self.hud_elements["cheat_binds"].hidewheninmenu = 1;
    }

    ufo = 0;
    noclip = 0;

    while(1) {
        ntf = self waittill_any_return("demo_end", "actionslot_1");

        if(isdefined(self.cj_ufo) && self.cj_ufo == 1 || isdefined(self.cj_noclip) && self.cj_noclip == 1) {
            if(isdefined(self.cj_ufo) && self.cj_ufo == 1)
                ufo = 1;
            else
                noclip = 1;

            if(ntf == "demo_end") {
                self.cj_cheat_skip = 1;
                if(ufo == 1)
                    self ufo();
                else
                    self noclip();
                vel = self.origin;
                self setvelocity((0, 0, 15));
                wait .05;
                if(self.origin == vel)
                    self iPrintLnBold("^8Collision ^7Detected!");
                else
                    self iPrintLnBold("No ^8Collision^7 Detected!");
                if(ufo == 1)
                    self ufo();
                else
                    self noclip();
                wait .15;
                self.cj_cheat_skip = 0;
            }
            else if(ntf == "actionslot_1") {
                self.cj_cheat_skip = 1;
                if(ufo == 1)
                    self ufo();
                else
                    self noclip();
                vel = self.origin;
                self setvelocity((0, 0, 15));
                wait .05;
                if(self.origin == vel) {
                    self setorigin(playerPhysicsTrace(self.origin + (0, 0, 4000), self.origin));
                    self iPrintLnBold("^8Successfully Teleported!");
                }
                else
                    self iPrintLnBold("No ^8Collision^7 Detected!");
                if(ufo == 1)
                    self ufo();
                else
                    self noclip();
                wait .15;
                self.cj_cheat_skip = 0;
            }

            ufo = 0;
            noclip = 0;
        }
    }
}

hud_color_editor(special) {
    self endon("disconnect");
    self endon("hud_editor_closed");

    width = 200;
    height = 50;

    if(!isdefined(self.hud_element_editor))
        self.hud_element_editor = [];

    if(!isdefined(self.hud_element_editor[0])) {
        self.hud_element_editor[0] = newclienthudelem(self);
        self.hud_element_editor[0].x = (320 - int(width / 4));
        self.hud_element_editor[0].y = 240;
        self.hud_element_editor[0].alignx = "center";
        self.hud_element_editor[0].aligny = "middle";
        self.hud_element_editor[0].horzalign = "fullscreen";
        self.hud_element_editor[0].vertalign = "fullscreen";
        self.hud_element_editor[0].alpha = 1;
        self.hud_element_editor[0].realalpha = 1;
        self.hud_element_editor[0].sort = 4;
        self.hud_element_editor[0].fontscale = 2;
        self.hud_element_editor[0].color = (1, 1, 1);
        self.hud_element_editor[0].archived = 0;
        self.hud_element_editor[0].foreground = 1;
        self.hud_element_editor[0].font = "default";
        self.hud_element_editor[0] setvalue(0);
    }

    if(!isdefined(self.hud_element_editor[1])) {
        self.hud_element_editor[1] = newclienthudelem(self);
        self.hud_element_editor[1].x = 320;
        self.hud_element_editor[1].y = 240;
        self.hud_element_editor[1].alignx = "center";
        self.hud_element_editor[1].aligny = "middle";
        self.hud_element_editor[1].horzalign = "fullscreen";
        self.hud_element_editor[1].vertalign = "fullscreen";
        self.hud_element_editor[1].alpha = 1;
        self.hud_element_editor[1].realalpha = 1;
        self.hud_element_editor[1].sort = 4;
        self.hud_element_editor[1].fontscale = 2;
        self.hud_element_editor[1].color = (1, 1, 1);
        self.hud_element_editor[1].archived = 0;
        self.hud_element_editor[1].foreground = 1;
        self.hud_element_editor[1].font = "default";
        self.hud_element_editor[1] setvalue(0);
    }

    if(!isdefined(self.hud_element_editor[2])) {
        self.hud_element_editor[2] = newclienthudelem(self);
        self.hud_element_editor[2].x = (320 + int(width / 4));
        self.hud_element_editor[2].y = 240;
        self.hud_element_editor[2].alignx = "center";
        self.hud_element_editor[2].aligny = "middle";
        self.hud_element_editor[2].horzalign = "fullscreen";
        self.hud_element_editor[2].vertalign = "fullscreen";
        self.hud_element_editor[2].alpha = 1;
        self.hud_element_editor[2].realalpha = 1;
        self.hud_element_editor[2].sort = 4;
        self.hud_element_editor[2].fontscale = 2;
        self.hud_element_editor[2].color = (1, 1, 1);
        self.hud_element_editor[2].archived = 0;
        self.hud_element_editor[2].foreground = 1;
        self.hud_element_editor[2].font = "default";
        self.hud_element_editor[2] setvalue(0);
    }

    if(!isdefined(self.hud_element_editor["TopLine"])) {
        self.hud_element_editor["TopLine"] = newclienthudelem(self);
        self.hud_element_editor["TopLine"].x = 320;
        self.hud_element_editor["TopLine"].y = 240 - (height / 2);
        self.hud_element_editor["TopLine"].alignx = "center";
        self.hud_element_editor["TopLine"].aligny = "middle";
        self.hud_element_editor["TopLine"].horzalign = "fullscreen";
        self.hud_element_editor["TopLine"].vertalign = "fullscreen";
        self.hud_element_editor["TopLine"].alpha = 1;
        self.hud_element_editor["TopLine"].realalpha = 1;
        self.hud_element_editor["TopLine"].sort = 3;
        self.hud_element_editor["TopLine"].color = self.choosencolor;
        self.hud_element_editor["TopLine"].archived = 0;
        self.hud_element_editor["TopLine"].foreground = 1;
        self.hud_element_editor["TopLine"] setshader("progress_bar_fill", width, 1);
    }

    if(!isdefined(self.hud_element_editor["BottomLine"])) {
        self.hud_element_editor["BottomLine"] = newclienthudelem(self);
        self.hud_element_editor["BottomLine"].x = 320;
        self.hud_element_editor["BottomLine"].y = 240 + (height / 2);
        self.hud_element_editor["BottomLine"].alignx = "center";
        self.hud_element_editor["BottomLine"].aligny = "middle";
        self.hud_element_editor["BottomLine"].horzalign = "fullscreen";
        self.hud_element_editor["BottomLine"].vertalign = "fullscreen";
        self.hud_element_editor["BottomLine"].alpha = 1;
        self.hud_element_editor["BottomLine"].realalpha = 1;
        self.hud_element_editor["BottomLine"].sort = 3;
        self.hud_element_editor["BottomLine"].color = self.choosencolor;
        self.hud_element_editor["BottomLine"].archived = 0;
        self.hud_element_editor["BottomLine"].foreground = 1;
        self.hud_element_editor["BottomLine"] setshader("progress_bar_fill", width, 1);
    }

    if(!isdefined(self.hud_element_editor["Gradient_Center"])) {
        self.hud_element_editor["Gradient_Center"] = newclienthudelem(self);
        self.hud_element_editor["Gradient_Center"].x = 320;
        self.hud_element_editor["Gradient_Center"].y = 240;
        self.hud_element_editor["Gradient_Center"].alignx = "center";
        self.hud_element_editor["Gradient_Center"].aligny = "middle";
        self.hud_element_editor["Gradient_Center"].horzalign = "fullscreen";
        self.hud_element_editor["Gradient_Center"].vertalign = "fullscreen";
        self.hud_element_editor["Gradient_Center"].alpha = .5;
        self.hud_element_editor["Gradient_Center"].realalpha = .5;
        self.hud_element_editor["Gradient_Center"].sort = 3;
        self.hud_element_editor["Gradient_Center"].color = self.choosencolor;
        self.hud_element_editor["Gradient_Center"].archived = 0;
        self.hud_element_editor["Gradient_Center"].foreground = 1;
        self.hud_element_editor["Gradient_Center"] setshader("line_horizontal", width + 30, height);
    }

    if(!isdefined(self.hud_element_editor["Background"])) {
        self.hud_element_editor["Background"] = newclienthudelem(self);
        self.hud_element_editor["Background"].x = 320;
        self.hud_element_editor["Background"].y = 240;
        self.hud_element_editor["Background"].alignx = "center";
        self.hud_element_editor["Background"].aligny = "middle";
        self.hud_element_editor["Background"].horzalign = "fullscreen";
        self.hud_element_editor["Background"].vertalign = "fullscreen";
        self.hud_element_editor["Background"].alpha = .6;
        self.hud_element_editor["Background"].realalpha = .6;
        self.hud_element_editor["Background"].sort = 2;
        self.hud_element_editor["Background"].color = (0,0,0);
        self.hud_element_editor["Background"].archived = 1;
        self.hud_element_editor["Background"].foreground = 1;
        self.hud_element_editor["Background"] setshader("progress_bar_fill", width, height + 60);
    }

    if(!isdefined(self.hud_element_editor["Controls"])) {
        self.hud_element_editor["Controls"] = newclienthudelem(self);
        self.hud_element_editor["Controls"].x = 320;
        self.hud_element_editor["Controls"].y = self.hud_element_editor["BottomLine"].y + 3;
        self.hud_element_editor["Controls"].alignx = "center";
        self.hud_element_editor["Controls"].aligny = "top";
        self.hud_element_editor["Controls"].horzalign = "fullscreen";
        self.hud_element_editor["Controls"].vertalign = "fullscreen";
        self.hud_element_editor["Controls"].alpha = 1;
        self.hud_element_editor["Controls"].realalpha = 1;
        self.hud_element_editor["Controls"].sort = 4;
        self.hud_element_editor["Controls"].fontscale = .9;
        self.hud_element_editor["Controls"].color = (1, 1, 1);
        self.hud_element_editor["Controls"].archived = 0;
        self.hud_element_editor["Controls"].foreground = 1;
        self.hud_element_editor["Controls"].font = "default";
        self.hud_element_editor["Controls"] settext("^3[{+forward}] ^7Scroll Up      ^3[{+back}] ^7Scroll Down      ^3[{+moveleft}] ^7Scroll Left      ^3[{+moveright}] ^7Scroll Right");
    }

    if(!isdefined(self.hud_element_editor["Title"])) {
        self.hud_element_editor["Title"]            = newclienthudelem(self);
        self.hud_element_editor["Title"].x          = 320 - (width - 105);
        self.hud_element_editor["Title"].y          = self.hud_element_editor["TopLine"].y - 5;
        self.hud_element_editor["Title"].alignx     = "left";
        self.hud_element_editor["Title"].aligny     = "bottom";
        self.hud_element_editor["Title"].horzalign  = "fullscreen";
        self.hud_element_editor["Title"].vertalign  = "fullscreen";
        self.hud_element_editor["Title"].alpha      = 1;
        self.hud_element_editor["Title"].realalpha  = 1;
        self.hud_element_editor["Title"].sort       = 4;
        self.hud_element_editor["Title"].fontscale  = .4;
        self.hud_element_editor["Title"].color      = (1, 1, 1);
        self.hud_element_editor["Title"].archived   = 0;
        self.hud_element_editor["Title"].foreground = 1;
        self.hud_element_editor["Title"].font       = "bigfixed";
        self.hud_element_editor["Title"] settext("Change the Values");
    }

    if(!isdefined(self.hud_element_editor["exit_button"])) {
        self.hud_element_editor["exit_button"] = newclienthudelem(self);
        self.hud_element_editor["exit_button"].x = 320 + (width - 105);
        self.hud_element_editor["exit_button"].y = self.hud_element_editor["TopLine"].y - 5;
        self.hud_element_editor["exit_button"].alignx = "right";
        self.hud_element_editor["exit_button"].aligny = "bottom";
        self.hud_element_editor["exit_button"].horzalign = "fullscreen";
        self.hud_element_editor["exit_button"].vertalign = "fullscreen";
        self.hud_element_editor["exit_button"].alpha = 1;
        self.hud_element_editor["exit_button"].realalpha = 1;
        self.hud_element_editor["exit_button"].sort = 4;
        self.hud_element_editor["exit_button"].fontscale = .4;
        self.hud_element_editor["exit_button"].color = (1, 1, 1);
        self.hud_element_editor["exit_button"].archived = 0;
        self.hud_element_editor["exit_button"].foreground = 1;
        self.hud_element_editor["exit_button"].font = "bigfixed";
        self.hud_element_editor["exit_button"] settext("^3[{+melee}] ^7to Exit");
    }

    self.ui_selector = 0;

    if(isdefined(special)) {
        self.R_Value = self.player_settings["R2"];
        self.G_Value = self.player_settings["G2"];
        self.B_Value = self.player_settings["B2"];
    }
    else {
        self.R_Value = self.player_settings["R"];
        self.G_Value = self.player_settings["G"];
        self.B_Value = self.player_settings["B"];
    }

    self.hud_element_editor[0].color = (self.R_Value, self.G_Value, self.B_Value);
    self.hud_element_editor[0] setvalue(self.R_Value);
    self.hud_element_editor[1] setvalue(self.G_Value);
    self.hud_element_editor[2] setvalue(self.B_Value);

    self hide_cj_hud();

    self thread hud_editor_leave("melee_color", special);

    ntf = "";

    self freezecontrols(1);

    while(1) {
        if(isdefined(self.hud_element_editor["Background"])) {
            if(self getnormalizedmovement()[0] > 0) {
                while(self getnormalizedmovement()[0] > 0) {
                    if(self.ui_selector == 0) {
                        self.R_Value += 1;

                        if(self.R_Value > 255)
                            self.R_Value = 0;
                    }
                    else if(self.ui_selector == 1) {
                        self.G_Value += 1;

                        if(self.G_Value > 255)
                            self.G_Value = 0;
                    }
                    else if(self.ui_selector == 2) {
                        self.B_Value += 1;

                        if(self.B_Value > 255)
                            self.B_Value = 0;
                    }

                    self.hud_element_editor[0].color = (1,1,1);
                    self.hud_element_editor[1].color = (1,1,1);
                    self.hud_element_editor[2].color = (1,1,1);
                    self.hud_element_editor[self.ui_selector].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor[0] setvalue(self.R_Value);
                    self.hud_element_editor[1] setvalue(self.G_Value);
                    self.hud_element_editor[2] setvalue(self.B_Value);

                    self.hud_element_editor["Gradient_Center"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor["BottomLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor["TopLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);

                    wait .05;
                }
            }

            if(self getnormalizedmovement()[0] < 0) {
                while(self getnormalizedmovement()[0] < 0) {
                    if(self.ui_selector == 0) {
                        self.R_Value -= 1;

                        if(self.R_Value < 0)
                            self.R_Value = 255;
                    }
                    else if(self.ui_selector == 1) {
                        self.G_Value -= 1;

                        if(self.G_Value < 0)
                            self.G_Value = 255;
                    }
                    else if(self.ui_selector == 2) {
                        self.B_Value -= 1;

                        if(self.B_Value < 0)
                            self.B_Value = 255;
                    }

                    self.hud_element_editor[0].color = (1,1,1);
                    self.hud_element_editor[1].color = (1,1,1);
                    self.hud_element_editor[2].color = (1,1,1);
                    self.hud_element_editor[self.ui_selector].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor[0] setvalue(self.R_Value);
                    self.hud_element_editor[1] setvalue(self.G_Value);
                    self.hud_element_editor[2] setvalue(self.B_Value);

                    self.hud_element_editor["Gradient_Center"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor["BottomLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
                    self.hud_element_editor["TopLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);

                    wait .05;
                }
            }

            if(self getnormalizedmovement()[1] < 0) {
                self.ui_selector--;

                if(self.ui_selector < 0)
                    self.ui_selector = 2;

                wait .1;
            }

            if(self getnormalizedmovement()[1] > 0) {
                self.ui_selector++;

                if(self.ui_selector > 2)
                    self.ui_selector = 0;

                wait .1;
            }

            self.hud_element_editor[0].color = (1,1,1);
            self.hud_element_editor[1].color = (1,1,1);
            self.hud_element_editor[2].color = (1,1,1);
            self.hud_element_editor[self.ui_selector].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
            self.hud_element_editor[0] setvalue(self.R_Value);
            self.hud_element_editor[1] setvalue(self.G_Value);
            self.hud_element_editor[2] setvalue(self.B_Value);

            self.hud_element_editor["Gradient_Center"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
            self.hud_element_editor["BottomLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
            self.hud_element_editor["TopLine"].color = (self.R_Value/255, self.G_Value/255, self.B_Value/255);
        }

        wait .05;
    }
}

hud_element_editor() {
    self endon("disconnect");
    self endon("hud_editor_closed");

    width = 200;
    height = 50;

    if(!isdefined(self.hud_element_editor))
        self.hud_element_editor = [];

    if(!isdefined(self.hud_element_editor["TopLine"])) {
        self.hud_element_editor["TopLine"] = newclienthudelem(self);
        self.hud_element_editor["TopLine"].x = 320;
        self.hud_element_editor["TopLine"].y = 240 - (height / 2);
        self.hud_element_editor["TopLine"].alignx = "center";
        self.hud_element_editor["TopLine"].aligny = "middle";
        self.hud_element_editor["TopLine"].horzalign = "fullscreen";
        self.hud_element_editor["TopLine"].vertalign = "fullscreen";
        self.hud_element_editor["TopLine"].alpha = 1;
        self.hud_element_editor["TopLine"].realalpha = 1;
        self.hud_element_editor["TopLine"].sort = 3;
        self.hud_element_editor["TopLine"].color = self.choosencolor;
        self.hud_element_editor["TopLine"].archived = 0;
        self.hud_element_editor["TopLine"].foreground = 1;
        self.hud_element_editor["TopLine"] setshader("progress_bar_fill", width, 1);
    }

    if(!isdefined(self.hud_element_editor["BottomLine"])) {
        self.hud_element_editor["BottomLine"] = newclienthudelem(self);
        self.hud_element_editor["BottomLine"].x = 320;
        self.hud_element_editor["BottomLine"].y = 240 + (height / 2);
        self.hud_element_editor["BottomLine"].alignx = "center";
        self.hud_element_editor["BottomLine"].aligny = "middle";
        self.hud_element_editor["BottomLine"].horzalign = "fullscreen";
        self.hud_element_editor["BottomLine"].vertalign = "fullscreen";
        self.hud_element_editor["BottomLine"].alpha = 1;
        self.hud_element_editor["BottomLine"].realalpha = 1;
        self.hud_element_editor["BottomLine"].sort = 3;
        self.hud_element_editor["BottomLine"].color = self.choosencolor;
        self.hud_element_editor["BottomLine"].archived = 0;
        self.hud_element_editor["BottomLine"].foreground = 1;
        self.hud_element_editor["BottomLine"] setshader("progress_bar_fill", width, 1);
    }

    if(!isdefined(self.hud_element_editor["Gradient_Center"])) {
        self.hud_element_editor["Gradient_Center"] = newclienthudelem(self);
        self.hud_element_editor["Gradient_Center"].x = 320;
        self.hud_element_editor["Gradient_Center"].y = 240;
        self.hud_element_editor["Gradient_Center"].alignx = "center";
        self.hud_element_editor["Gradient_Center"].aligny = "middle";
        self.hud_element_editor["Gradient_Center"].horzalign = "fullscreen";
        self.hud_element_editor["Gradient_Center"].vertalign = "fullscreen";
        self.hud_element_editor["Gradient_Center"].alpha = .5;
        self.hud_element_editor["Gradient_Center"].realalpha = .5;
        self.hud_element_editor["Gradient_Center"].sort = 3;
        self.hud_element_editor["Gradient_Center"].color = self.choosencolor;
        self.hud_element_editor["Gradient_Center"].archived = 0;
        self.hud_element_editor["Gradient_Center"].foreground = 1;
        self.hud_element_editor["Gradient_Center"] setshader("line_horizontal", width + 30, height);
    }

    if(!isdefined(self.hud_element_editor["Options"])) {
        self.hud_element_editor["Options"] = newclienthudelem(self);
        self.hud_element_editor["Options"].x = 320;
        self.hud_element_editor["Options"].y = 240;
        self.hud_element_editor["Options"].alignx = "center";
        self.hud_element_editor["Options"].aligny = "middle";
        self.hud_element_editor["Options"].horzalign = "fullscreen";
        self.hud_element_editor["Options"].vertalign = "fullscreen";
        self.hud_element_editor["Options"].alpha = 1;
        self.hud_element_editor["Options"].realalpha = 1;
        self.hud_element_editor["Options"].sort = 4;
        self.hud_element_editor["Options"].fontscale = 2;
        self.hud_element_editor["Options"].color = (1, 1, 1);
        self.hud_element_editor["Options"].archived = 0;
        self.hud_element_editor["Options"].foreground = 1;
        self.hud_element_editor["Options"].font = "default";
    }

    if(!isdefined(self.hud_element_editor["Background"])) {
        self.hud_element_editor["Background"] = newclienthudelem(self);
        self.hud_element_editor["Background"].x = 320;
        self.hud_element_editor["Background"].y = 240;
        self.hud_element_editor["Background"].alignx = "center";
        self.hud_element_editor["Background"].aligny = "middle";
        self.hud_element_editor["Background"].horzalign = "fullscreen";
        self.hud_element_editor["Background"].vertalign = "fullscreen";
        self.hud_element_editor["Background"].alpha = .6;
        self.hud_element_editor["Background"].realalpha = .6;
        self.hud_element_editor["Background"].sort = 2;
        self.hud_element_editor["Background"].color = (0,0,0);
        self.hud_element_editor["Background"].archived = 1;
        self.hud_element_editor["Background"].foreground = 1;
        self.hud_element_editor["Background"] setshader("progress_bar_fill", width, height + 60);
    }

    if(!isdefined(self.hud_element_editor["Controls"])) {
        self.hud_element_editor["Controls"] = newclienthudelem(self);
        self.hud_element_editor["Controls"].x = 320;
        self.hud_element_editor["Controls"].y = self.hud_element_editor["BottomLine"].y + 3;
        self.hud_element_editor["Controls"].alignx = "center";
        self.hud_element_editor["Controls"].aligny = "top";
        self.hud_element_editor["Controls"].horzalign = "fullscreen";
        self.hud_element_editor["Controls"].vertalign = "fullscreen";
        self.hud_element_editor["Controls"].alpha = 1;
        self.hud_element_editor["Controls"].realalpha = 1;
        self.hud_element_editor["Controls"].sort = 4;
        self.hud_element_editor["Controls"].fontscale = .9;
        self.hud_element_editor["Controls"].color = (1, 1, 1);
        self.hud_element_editor["Controls"].archived = 0;
        self.hud_element_editor["Controls"].foreground = 1;
        self.hud_element_editor["Controls"].font = "default";
        self.hud_element_editor["Controls"] settext("^3[{+activate}] ^7Select      ^3[{+moveleft}] ^7Scroll Left      ^3[{+moveright}] ^7Scroll Right");
    }

    if(!isdefined(self.hud_element_editor["Title"])) {
        self.hud_element_editor["Title"]            = newclienthudelem(self);
        self.hud_element_editor["Title"].x          = 320 - (width - 105);
        self.hud_element_editor["Title"].y          = self.hud_element_editor["TopLine"].y - 5;
        self.hud_element_editor["Title"].alignx     = "left";
        self.hud_element_editor["Title"].aligny     = "bottom";
        self.hud_element_editor["Title"].horzalign  = "fullscreen";
        self.hud_element_editor["Title"].vertalign  = "fullscreen";
        self.hud_element_editor["Title"].alpha      = 1;
        self.hud_element_editor["Title"].realalpha  = 1;
        self.hud_element_editor["Title"].sort       = 4;
        self.hud_element_editor["Title"].fontscale  = .4;
        self.hud_element_editor["Title"].color      = (1, 1, 1);
        self.hud_element_editor["Title"].archived   = 0;
        self.hud_element_editor["Title"].foreground = 1;
        self.hud_element_editor["Title"].font       = "bigfixed";
        self.hud_element_editor["Title"] settext("Change the Values");
    }

    if(!isdefined(self.hud_element_editor["exit_button"])) {
        self.hud_element_editor["exit_button"] = newclienthudelem(self);
        self.hud_element_editor["exit_button"].x = 320 + (width - 105);
        self.hud_element_editor["exit_button"].y = self.hud_element_editor["TopLine"].y - 5;
        self.hud_element_editor["exit_button"].alignx = "right";
        self.hud_element_editor["exit_button"].aligny = "bottom";
        self.hud_element_editor["exit_button"].horzalign = "fullscreen";
        self.hud_element_editor["exit_button"].vertalign = "fullscreen";
        self.hud_element_editor["exit_button"].alpha = 1;
        self.hud_element_editor["exit_button"].realalpha = 1;
        self.hud_element_editor["exit_button"].sort = 4;
        self.hud_element_editor["exit_button"].fontscale = .4;
        self.hud_element_editor["exit_button"].color = (1, 1, 1);
        self.hud_element_editor["exit_button"].archived = 0;
        self.hud_element_editor["exit_button"].foreground = 1;
        self.hud_element_editor["exit_button"].font = "bigfixed";
        self.hud_element_editor["exit_button"] settext("^3[{+melee}] ^7to Exit");
    }

    options = [];
    options[options.size] = "Keyboard";
    options[options.size] = "Velocity";
    options[options.size] = "FPS Counter";
    options[options.size] = "Compass";
    options[options.size] = "Height Info";

    plus                    = 1;
    movement_x              = undefined;
    movement_y              = undefined;
    element                 = undefined;

    self.ui_selector        = 0;
    self.choosen_element    = undefined;
    self.selected_hud       = undefined;
    self.speedmode          = 0;

    self.hud_element_editor["Options"] settext(options[self.ui_selector]);
    self thread hud_editor_leave("melee_position");
    self freezecontrols(1);

    self thread hud_element_info();
    self thread hud_edtior_speedmode();

    while(1) {
        movement_x = self getnormalizedmovement()[1];
        movement_y = self getnormalizedmovement()[0];

        if(isdefined(self.choosen_element) && self.choosen_element != "") {
            if(self.choosen_element == "Keyboard")
                self.selected_hud = self.hud_keyboard;
            else if(self.choosen_element == "Velocity")
                self.selected_hud = self.hud_elements["velocity"];
            else if(self.choosen_element == "FPS Counter")
                self.selected_hud = self.hud_elements["fps_counter"];
            else if(self.choosen_element == "Compass")
                self.selected_hud = "compass";
            else if(self.choosen_element == "Height Info") {
                self.selected_hud = self.hud_elements["point_bg"];
                if(isdefined(self.waypoint) && self.waypoint.hidden == 1)
                    self.hud_elements["point_bg"].alpha = .85;
            }
        }

        if(isdefined(movement_x) && movement_x < 0) {
            if(isdefined(self.ui_selector)) {
                self.ui_selector -= 1;

                if(self.ui_selector < 0)
                    self.ui_selector = options.size - 1;

                if(isdefined(self.ui_selector))
                    self.hud_element_editor["Options"] settext(options[self.ui_selector]);

                wait .15;
            }

            if(isdefined(self.selected_hud) && self.selected_hud != "compass") {
                if(isdefined(self.choosen_element) && self.choosen_element != "") {
                    if(self.choosen_element == "Keyboard") {
                        foreach(hud in self.selected_hud) {
                            if((hud.x - (plus + self.speedmode)) >= 0)
                                hud.x -= (plus + self.speedmode);
                        }
                    }
                    else {
                        if((self.selected_hud.x - (plus + self.speedmode)) >= 0)
                            self.selected_hud.x -= (plus + self.speedmode);
                    }
                }
            }
            else if(isdefined(self.selected_hud) && self.selected_hud == "compass" && isdefined(self.choosen_element) && self.choosen_element != "") {
                self.player_settings["min_x"] -= (plus + self.speedmode);
                self setclientdvar("cj_minimap_x", self.player_settings["min_x"]);
                self.hud_elements["compass_line"].x -= (plus + self.speedmode);
                self.hud_elements["compass_angles"].x -= (plus + self.speedmode);
                self.hud_elements["compass_bg"].x -= (plus + self.speedmode);
            }

            wait .05;
        }
        else if(isdefined(movement_x) && movement_x > 0) {
            if(isdefined(self.ui_selector)) {
                self.ui_selector += 1;

                if(self.ui_selector > (options.size - 1))
                    self.ui_selector = 0;

                if(isdefined(self.ui_selector))
                    self.hud_element_editor["Options"] settext(options[self.ui_selector]);

                wait .15;
            }

            if(isdefined(self.selected_hud) && self.selected_hud != "compass") {
                if(isdefined(self.choosen_element) && self.choosen_element != "") {
                    if(self.choosen_element == "Keyboard") {
                        foreach(hud in self.selected_hud) {
                            if((hud.x + (plus + self.speedmode)) <= 640)
                                hud.x += (plus + self.speedmode);
                        }
                    }
                    else {
                        if((self.selected_hud.x + (plus + self.speedmode)) <= 640)
                            self.selected_hud.x += (plus + self.speedmode);
                    }
                }
            }
            else if(isdefined(self.selected_hud) && self.selected_hud == "compass" && isdefined(self.choosen_element) && self.choosen_element != "") {
                self.player_settings["min_x"] += (plus + self.speedmode);
                self setclientdvar("cj_minimap_x", self.player_settings["min_x"]);
                self.hud_elements["compass_line"].x += (plus + self.speedmode);
                self.hud_elements["compass_angles"].x += (plus + self.speedmode);
                self.hud_elements["compass_bg"].x += (plus + self.speedmode);
            }

            wait .05;
        }
        else if(isdefined(movement_y) && movement_y < 0) {
            if(isdefined(self.selected_hud) && self.selected_hud != "compass") {
                if(isdefined(self.choosen_element) && self.choosen_element != "") {
                    if(self.choosen_element == "Keyboard") {
                        foreach(hud in self.selected_hud) {
                            if((hud.y + (plus + self.speedmode)) <= 480)
                                hud.y += (plus + self.speedmode);
                        }
                    }
                    else {
                        if((self.selected_hud.y + (plus + self.speedmode)) <= 480)
                            self.selected_hud.y += (plus + self.speedmode);
                    }
                }
            }
            else if(isdefined(self.selected_hud) && self.selected_hud == "compass" && isdefined(self.choosen_element) && self.choosen_element != "") {
                self.player_settings["min_y"] += (plus + self.speedmode);
                self setclientdvar("cj_minimap_y", self.player_settings["min_y"]);
                self.hud_elements["compass_line"].y += (plus + self.speedmode);
                self.hud_elements["compass_angles"].y += (plus + self.speedmode);
                self.hud_elements["compass_bg"].y += (plus + self.speedmode);
            }

            wait .05;
        }
        else if(isdefined(movement_y) && movement_y > 0) {
            if(isdefined(self.selected_hud) && self.selected_hud != "compass") {
                if(isdefined(self.choosen_element) && self.choosen_element != "") {
                    if(self.choosen_element == "Keyboard") {
                        foreach(hud in self.selected_hud) {
                            if((hud.y - (plus + self.speedmode)) >= 0)
                                hud.y -= (plus + self.speedmode);
                        }
                    }
                    else {
                        if((self.selected_hud.y - (plus + self.speedmode)) >= 0)
                            self.selected_hud.y -= (plus + self.speedmode);
                    }
                }
            }
            else if(isdefined(self.selected_hud) && self.selected_hud == "compass" && isdefined(self.choosen_element) && self.choosen_element != "") {
                self.player_settings["min_y"] -= (plus + self.speedmode);
                self setclientdvar("cj_minimap_y", self.player_settings["min_y"]);
                self.hud_elements["compass_line"].y -= (plus + self.speedmode);
                self.hud_elements["compass_angles"].y -= (plus + self.speedmode);
                self.hud_elements["compass_bg"].y -= (plus + self.speedmode);
            }

            wait .05;
        }
        else if(self usebuttonpressed()) {
            if(!isdefined(self.choosen_element)) { // Enter Edtior
                self.choosen_element = options[self.ui_selector];

                self.ui_selector        = undefined;
                self.selected_hud       = undefined;

                foreach(hud in self.hud_element_editor) {
                    hud fadeovertime(1);
                    hud.alpha = 0;
                }
            }
            else if(isdefined(self.choosen_element) && self.choosen_element != "") { // Done Moving
                self.choosen_element    = undefined;
                self.ui_selector        = 1;

                foreach(hud in self.hud_element_editor) {
                    hud fadeovertime(1);
                    hud.alpha = hud.realalpha;
                }
            }

            wait .20;
        }

        wait .05;
    }
}

Wkey() {
    self endon("disconnect");

    while(1) {
        if(!isdefined(self.isdemo)) {
            self waittill("+w");
            self.keyw = 1;
            self waittill("-w");
            self.keyw = 0;
        }
        else
            wait .05;
    }
}

Akey() {
    self endon("disconnect");

    while(1) {
        if(!isdefined(self.isdemo)) {
            self waittill("+a");
            self.keya = 1;
            self waittill("-a");
            self.keya = 0;
        }
        else
            wait .05;
    }
}

Skey() {
    self endon("disconnect");

    while(1) {
        if(!isdefined(self.isdemo)) {
            self waittill("+s");
            self.keys = 1;
            self waittill("-s");
            self.keys = 0;
        }
        else
            wait .05;
    }
}

Dkey() {
    self endon("disconnect");

    while(1) {
        if(!isdefined(self.isdemo)) {
            self waittill("+d");
            self.keyd = 1;
            self waittill("-d");
            self.keyd = 0;
        }
        else
            wait .05;
    }
}

keyboard_setup() {
    self endon("disconnect");

    x = self.player_settings["key_x"];
    y = self.player_settings["key_y"];
    seperator = 2;
    shadersize = 74;

    if(!isdefined(self.hud_keyboard))
        self.hud_keyboard = [];

    if(!isdefined(self.hud_keyboard["hud_key_w"])) {
        self.hud_keyboard["hud_key_w"] = newclienthudelem(self);
        self.hud_keyboard["hud_key_w"].alignx = "center";
        self.hud_keyboard["hud_key_w"].aligny = "middle";
        self.hud_keyboard["hud_key_w"].horzalign = "fullscreen";
        self.hud_keyboard["hud_key_w"].vertalign = "fullscreen";
        self.hud_keyboard["hud_key_w"].x = x;
        self.hud_keyboard["hud_key_w"].y = y;
        self.hud_keyboard["hud_key_w"].color = self.choosencolor;
        self.hud_keyboard["hud_key_w"] setshader("w_button_notpressed", shadersize, shadersize);
        self.hud_keyboard["hud_key_w"].archived = 1;
        self.hud_keyboard["hud_key_w"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_keyboard["hud_key_a"])) {
        self.hud_keyboard["hud_key_a"] = newclienthudelem(self);
        self.hud_keyboard["hud_key_a"].alignx = "center";
        self.hud_keyboard["hud_key_a"].aligny = "middle";
        self.hud_keyboard["hud_key_a"].horzalign = "fullscreen";
        self.hud_keyboard["hud_key_a"].vertalign = "fullscreen";
        self.hud_keyboard["hud_key_a"].x = x - seperator;
        self.hud_keyboard["hud_key_a"].y = y + seperator;
        self.hud_keyboard["hud_key_a"].color = self.choosencolor;
        self.hud_keyboard["hud_key_a"] setshader("a_button_notpressed", shadersize, shadersize);
        self.hud_keyboard["hud_key_a"].archived = 1;
        self.hud_keyboard["hud_key_a"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_keyboard["hud_key_s"])) {
        self.hud_keyboard["hud_key_s"] = newclienthudelem(self);
        self.hud_keyboard["hud_key_s"].alignx = "center";
        self.hud_keyboard["hud_key_s"].aligny = "middle";
        self.hud_keyboard["hud_key_s"].horzalign = "fullscreen";
        self.hud_keyboard["hud_key_s"].vertalign = "fullscreen";
        self.hud_keyboard["hud_key_s"].x = x;
        self.hud_keyboard["hud_key_s"].y = y + seperator;
        self.hud_keyboard["hud_key_s"].color = self.choosencolor;
        self.hud_keyboard["hud_key_s"] setshader("s_button_notpressed", shadersize, shadersize);
        self.hud_keyboard["hud_key_s"].archived = 1;
        self.hud_keyboard["hud_key_s"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_keyboard["hud_key_d"])) {
        self.hud_keyboard["hud_key_d"] = newclienthudelem(self);
        self.hud_keyboard["hud_key_d"].alignx = "center";
        self.hud_keyboard["hud_key_d"].aligny = "middle";
        self.hud_keyboard["hud_key_d"].horzalign = "fullscreen";
        self.hud_keyboard["hud_key_d"].vertalign = "fullscreen";
        self.hud_keyboard["hud_key_d"].x = x + seperator;
        self.hud_keyboard["hud_key_d"].y = y + seperator;
        self.hud_keyboard["hud_key_d"].color = self.choosencolor;
        self.hud_keyboard["hud_key_d"] setshader("d_button_notpressed", shadersize, shadersize);
        self.hud_keyboard["hud_key_d"].archived = 1;
        self.hud_keyboard["hud_key_d"].hidewheninmenu = 1;
    }

    self.keyw = 0;
    self.keya = 0;
    self.keys = 0;
    self.keyd = 0;

    while(1) {
        if(!isdefined(self.ui_selector) && self.current_input != "controller") {
            if(isdefined(self.keyw)) {
                if(self.keyw == 0)
                    self.hud_keyboard["hud_key_w"] setshader("w_button_notpressed", shadersize, shadersize);
                else
                    self.hud_keyboard["hud_key_w"] setshader("w_button_pressed", shadersize, shadersize);
            }
            if(isdefined(self.keya)) {
                if(self.keya == 0)
                    self.hud_keyboard["hud_key_a"] setshader("a_button_notpressed", shadersize, shadersize);
                else
                    self.hud_keyboard["hud_key_a"] setshader("a_button_pressed", shadersize, shadersize);
            }
            if(isdefined(self.keys)) {
                if(self.keys == 0)
                    self.hud_keyboard["hud_key_s"] setshader("s_button_notpressed", shadersize, shadersize);
                else
                    self.hud_keyboard["hud_key_s"] setshader("s_button_pressed", shadersize, shadersize);
            }
            if(isdefined(self.keyd)) {
                if(self.keyd == 0)
                    self.hud_keyboard["hud_key_d"] setshader("d_button_notpressed", shadersize, shadersize);
                else
                    self.hud_keyboard["hud_key_d"] setshader("d_button_pressed", shadersize, shadersize);
            }
        }

        wait .05;
    }
}

handle_better_fps() {
    self endon("disconnect");

    self.zfar   = 0;
    x_left = 205;
    x_right = 445;
    cutpoint_2  = undefined;

    while(1) {
        self waittill("FpsFix_action");

        if(isdefined(self.isdemo) && !isdefined(self.has_cutted)) {
            if(isdefined(self.watching_file) && isdefined(self.demo_timeline_hud["demo_cutbar_1"]) && isdefined(self.last_demo_point)) {
                demo_clip_maxprobes = countlines(self.watching_file);

                cutpoint_2 = demo_clip_maxprobes - (demo_clip_maxprobes - int((self.clip_end_time - self.last_demo_point) / 50));
                position_ratio = 1.0 - (demo_clip_maxprobes - 1) / (demo_clip_maxprobes - 1);
                position = int(x_left + (x_right - x_left) * position_ratio);

                self.demo_timeline_hud["demo_cutbar_1"].alpha = .65;
                self.demo_timeline_hud["demo_cutbar_1"].x = position;

                self.clip_cutpoint_1 = (demo_clip_maxprobes - 1);
                self.demo_point      = cutpoint_2;
                self.clip_cutpoint_2 = self.demo_point;

                wait .05;

                self.demo_timeline_hud["demo_cutbar_2"].alpha = .65;
                self.demo_timeline_hud["demo_cutbar_2"].x = self.demo_timeline_hud["seconds"].x;

                self iPrintLnBold("Press ^8[{+smoke}] ^7to Cut the Clip");
            }
            else
                self iPrintLnBold("^1No save_load Data for Clip found!");
        }
        else {
            if(self.zfar == 0) {
                self setClientDvar ( "r_zfar", "3000" );
                self.zfar = 1;
                self iprintln("z_far : ^83000");
            }
            else if(self.zfar == 1) {
                self setClientDvar ( "r_zfar", "2000" );
                self.zfar = 2;
                self iprintln("z_far : ^82000");
            }
            else if(self.zfar == 2) {
                self setClientDvar ( "r_zfar", "1500" );
                self.zfar = 3;
                self iprintln("z_far : ^81500");
            }
            else if(self.zfar == 3) {
                self setClientDvar ( "r_zfar", "1000" );
                self.zfar = 4;
                self iprintln("z_far : ^81000");
            }
            else if(self.zfar == 4) {
                self setClientDvar ( "r_zfar", "500" );
                self.zfar = 5;
                self iprintln("z_far : ^8500");
            }
            else if(self.zfar == 5) {
                self setClientDvar ( "r_zfar", "0" );
                self.zfar = 0;
                self iprintln("^8Reset");
            }
        }

        wait .20;
    }
}

handle_fullbright() {
    self endon("disconnect");

    self.Fullbright = 0;
    x_left = 205;
    x_right = 445;
    cutpoint_2  = undefined;

    while(1) {
        self waittill("Fullbright_action");

        if(isdefined(self.isdemo) && isdefined(self.demo_timeline_hud["demo_cutbar_1"])) {
            demo_clip_maxprobes = countlines(self.watching_file);

            cutpoint_2 = demo_clip_maxprobes - self.demo_point;
            num = cutpoint_2;

            position_ratio = 1.0 - (demo_clip_maxprobes - 1) / (demo_clip_maxprobes - 1);
            position = int(x_left + (x_right - x_left) * position_ratio);

            self.demo_timeline_hud["demo_cutbar_1"].alpha = .65;
            self.demo_timeline_hud["demo_cutbar_1"].x = position;

            self.clip_cutpoint_1 = (demo_clip_maxprobes - 1);
            self.demo_point      = demo_clip_maxprobes - cutpoint_2;
            self.clip_cutpoint_2 = self.demo_point;

            wait .05;

            self.demo_timeline_hud["demo_cutbar_2"].alpha = .65;
            self.demo_timeline_hud["demo_cutbar_2"].x = self.demo_timeline_hud["seconds"].x;

            self iPrintLnBold("Press ^8[{+smoke}] ^7to Cut the Clip");
        }
        else {
            if (self.Fullbright == 0) {
                self SetClientDvars( "fx_enable", 0, "r_fog", 0);
                self.Fullbright = 1;
                self iprintln("No ^8FX ^7& ^8Fog");
            }
            else if (self.Fullbright == 1) {
                self SetClientDvar("r_portalwalklimit", 1);
                self.Fullbright = 2;
                self iprintln("No ^8FX ^7& ^8Fog ^7& Min Portals ^81");
            }
            else if (self.Fullbright == 2) {
                self SetClientDvar("r_lightmap", 2);
                self SetClientDvar("r_portalwalklimit", 0);
                self.Fullbright = 3;
                self iprintln("No ^8FX ^7& ^8Fog ^7& ^8Fullbright^7");
            }
            else if (self.Fullbright == 3) {
                self SetClientDvars( "fx_enable", 1, "r_fog", 1, "r_lightmap", 1, "r_portalwalklimit", 0);
                self.Fullbright = 0;
                self iprintln("^8All to Default");
            }
        }

        wait .20;
    }
}

player_settings_main() {
    self endon("disconnect");

    players_dir = getDvar("fs_homepath") + "/cjstats" + "/players/_total_stats/" + self getGUID() + ".csv";
    player_csv_data = readFile(players_dir);

    int_total                   = [];
    self.player_settings        = [];
    needs_update                = undefined;

    int_columns = strTok("deathbarriers_noti,deathbarriers,fav_map,routes,rpg_fired,clips_created,timeplayed,saves,loads,draw_xp,height_x,height_y,inspect,minimap,key_x,key_y,vel_x,vel_y,R,G,B,fpsx,fpsy,camo,vel_fs,hideothers,compass,hud_sec_c,R2,G2,B2,fpsfs,spechud,bc,bounces,created,desc,xp,min_x,min_y,comp_angle,comp_line", ",");

    if(!isDefined(player_csv_data) || player_csv_data == "") {
        keys = getarraykeys(level.base_values);

        for(i = 0;i < keys.size;i++)
            self.player_settings[keys[i]] = level.base_values[keys[i]];

        self.player_settings["created"] = getservertime();
        self.player_settings["desc"] = "^8I Love ZEC O_O";
        self.player_settings["name"] = self.name;

        //self thread cj_intro();
    }
    else {
        self.player_settings = csv_decode(player_csv_data)[0];

        foreach(i_column in int_columns) {
            if(!isdefined(self.player_settings[i_column])) {
                if(i_column == "created")
                    self.player_settings[i_column] = getservertime();
                else if(i_column == "desc")
                    self.player_settings[i_column] = "^8I Love ZEC O_O";
                else if(i_column == "fav_map")
                    self.player_settings[i_column] = getdvar("mapname");
                else if(i_column == "name")
                    self.player_settings[i_column] = self.name;
                else
                    self.player_settings[i_column] = level.base_values[i_column];

                needs_update = 1;
            }
        }
    }

    foreach(i_column in int_columns) {
        if(i_column != "created" && i_column != "desc" && i_column != "name" && i_column != "fav_map") {
            if(i_column == "vel_fs" || i_column == "fpsfs")
                self.player_settings[i_column] = float(self.player_settings[i_column]);
            else
                self.player_settings[i_column] = int(self.player_settings[i_column]);
        }
    }

    self SetClientDvars(
        "cj_settings_slnoti", self.player_settings["compass"],
        "cj_settings_hideplayers", self.player_settings["hideothers"],
        "hud_sec_c", self.player_settings["hud_sec_c"],
        "spechud", self.player_settings["spechud"],
        "cj_stats_bounces", self.player_settings["bounces"],
        "cj_stats_created", self.player_settings["created"],
        "cj_stats_desc", self.player_settings["desc"],
        "cj_minimap_x", self.player_settings["min_x"],
        "cj_minimap_y", self.player_settings["min_y"],
        "compass_help_line", self.player_settings["comp_line"],
        "compass_help_angle", self.player_settings["comp_angle"],
        "cj_hide_map", self.player_settings["minimap"],
        "weapon_inspects", self.player_settings["inspect"],
        "cj_deathbarriers", self.player_settings["deathbarriers"],
        "cj_deathbarriers_noti", self.player_settings["deathbarriers_noti"],
        "cj_draw_xp", self.player_settings["draw_xp"]
    );

    self.playtime = to_hours(int(int(self.player_settings["timeplayed"]) * 60));
    self setclientdvars("cj_stats_profile_routes", int(self.player_settings["routes"]), "cj_stats_profile_clips", int(self.player_settings["clips_created"]), "cj_stats_profile_fav_map", "Dome", "cj_stats_profile_playtime", to_mins(int(self.player_settings["timeplayed"] * 60)), "cj_stats_profile_rpg", int(self.player_settings["rpg_fired"]), "cj_stats_profile_bounces", int(self.player_settings["bounces"]), "cj_stats_profile_saves", int(self.player_settings["saves"]), "cj_stats_profile_loads", int(self.player_settings["loads"]));

    self thread update_stats_aftertime(20);

    while(1) {
        if(!isdefined(needs_update))
            self waittill("player_stats_updated");
        else
            needs_update = undefined;

        player_data = csv_encode(self.player_settings);
        writeFile(players_dir, player_data);

        if(self.viewing_profile == self.name)
            self setclientdvars("cj_stats_profile_routes", int(self.player_settings["routes"]), "cj_stats_profile_clips", int(self.player_settings["clips_created"]), "cj_stats_profile_fav_map", "Dome", "cj_stats_profile_playtime", to_mins(int(self.player_settings["timeplayed"] * 60)), "cj_stats_profile_rpg", int(self.player_settings["rpg_fired"]), "cj_stats_profile_bounces", int(self.player_settings["bounces"]), "cj_stats_profile_saves", int(self.player_settings["saves"]), "cj_stats_profile_loads", int(self.player_settings["loads"]));

        wait 1;
    }
}

cj_intro() {
    wait 1;

    self setclientdvar("menu_int", 2);
    self openmenu("openclientmenus");
}

update_stats_aftertime(time) {
    self endon("disconnect");

    while(1) {
        wait 25;

        self notify("player_stats_updated");
    }
}

player_sessions_main() {
    self endon("disconnect");

    if(!directoryExists(getDvar("fs_homepath") + "/cjstats" + "/players/" + getdvar("mapname") + "/"))
        createDirectory(getDvar("fs_homepath") + "/cjstats" + "/players/" + getdvar("mapname") + "/");

    players_dir = getDvar("fs_homepath") + "/cjstats" + "/players/" + getdvar("mapname") + "/";

    int_total               = [];
    self.session_stats      = [];
    self.total_stats        = [];

    int_columns             = strTok("bounces,rpgloads,time,saves,loads,timeplayed", ",");

    foreach(s_column in int_columns)
        self.session_stats[s_column] = 0;

    self.session_stats["uid"] = self getGUID();

    player_file = players_dir + self getGUID() + ".csv";
    player_csv_data = readFile(player_file);

    if(!isDefined(player_csv_data) || player_csv_data == "") {
        foreach(t_column in int_columns)
            self.total_stats[t_column] = 0;

        writeFile(player_file, csv_encode(self.total_stats));
    }
    else
        self.total_stats = csv_decode(player_csv_data)[0];

    foreach(i_column in int_columns)
        int_total[i_column] = int(self.total_stats[i_column]);

    self.score = int_total["bounces"];
    self.pers["score"] = self.score;
    self.kills = int_total["saves"];
    self.pers["kills"] = self.kills;
    self.assists = int_total["loads"];
    self.pers["assists"] = self.assists;
    self.deaths = int_total["timeplayed"];
    self.pers["deaths"] = self.deaths;

    self.savedmins = self.deaths;

    while(1) {
        if(self.sessionstate != "spectator") {
            if(self.pers["score"] != 0) {
                self.session_stats["bounces"] = self.pers["score"];
                self.session_stats["saves"] = self.pers["kills"];
                self.session_stats["loads"] = self.pers["assists"];
                self.session_stats["timeplayed"] = self.savedmins;

                foreach(p_column in int_columns)
                    self.total_stats[p_column] = self.session_stats[p_column];

                player_data = csv_encode(self.total_stats);

                writeFile(player_file, player_data);
            }
        }

        wait 5;
    }
}

fps_counter_think() {
    self endon("disconnect");

    self thread getclientdvar_handler();

    wait 1;

    self.dvar = "clantag";
    self setclientdvar("getting_dvar", self.dvar);
    self openmenu("getclientdvar");
    wait .3;
    self.dvar = "r_vsync";
    self setclientdvar("getting_dvar", self.dvar);
    self openmenu("getclientdvar");
    wait .3;
    self.dvar = "com_maxfps";
    self setclientdvar("getting_dvar", self.dvar);
    self openmenu("getclientdvar");

    while(1) {
        self openmenu("getclientdvar");

        wait .15;
    }
}

fps_counter_main() {
    self endon("disconnect");

    if(!isdefined(self.hud_elements["fps_counter"])) {
        self.hud_elements["fps_counter"] = newclienthudelem(self);
        self.hud_elements["fps_counter"].alignx = "center";
        self.hud_elements["fps_counter"].aligny = "middle";
        self.hud_elements["fps_counter"].horzalign = "fullscreen";
        self.hud_elements["fps_counter"].vertalign = "fullscreen";
        self.hud_elements["fps_counter"].x = self.player_settings["fpsx"];
        self.hud_elements["fps_counter"].y = self.player_settings["fpsy"];
        self.hud_elements["fps_counter"].alpha = 1;
        self.hud_elements["fps_counter"].sort = 2;
        self.hud_elements["fps_counter"].font = "bigfixed";
        self.hud_elements["fps_counter"].fontscale = self.player_settings["fpsfs"];
        self.hud_elements["fps_counter"].color = self.choosencolor;
        self.hud_elements["fps_counter"].archived = 1;
        self.hud_elements["fps_counter"].foreground = 1;
        self.hud_elements["fps_counter"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_elements["compass_angles"])) {
        self.hud_elements["compass_angles"] = newclienthudelem(self);
        self.hud_elements["compass_angles"].alignx = "center";
        self.hud_elements["compass_angles"].aligny = "top";
        self.hud_elements["compass_angles"].x = self.player_settings["min_x"] - 50;
        self.hud_elements["compass_angles"].y = self.player_settings["min_y"] + 18;
        self.hud_elements["compass_angles"].alpha = 0;
        self.hud_elements["compass_angles"].sort = 2;
        self.hud_elements["compass_angles"].font = "small";
        self.hud_elements["compass_angles"].fontscale = 1.2;
        self.hud_elements["compass_angles"].color = self.choosencolor;
        self.hud_elements["compass_angles"].archived = 0;
        self.hud_elements["compass_angles"].foreground = 1;
        self.hud_elements["compass_angles"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_elements["compass_line"])) {
        self.hud_elements["compass_line"] = newclienthudelem(self);
        self.hud_elements["compass_line"].alignx = "center";
        self.hud_elements["compass_line"].aligny = "middle";
        self.hud_elements["compass_line"].x = self.player_settings["min_x"] - 50;
        self.hud_elements["compass_line"].y = self.player_settings["min_y"] + 11;
        self.hud_elements["compass_line"].alpha = 0;
        self.hud_elements["compass_line"].sort = 2;
        self.hud_elements["compass_line"].font = "bigfixed";
        self.hud_elements["compass_line"].fontscale = self.player_settings["fpsfs"];
        self.hud_elements["compass_line"].color = self.choosencolor;
        self.hud_elements["compass_line"].archived = 0;
        self.hud_elements["compass_line"].foreground = 1;
        self.hud_elements["compass_line"].hidewheninmenu = 1;
        self.hud_elements["compass_line"] setshader("white", 1, 12);
    }

    if(!isdefined(self.hud_elements["compass_bg"])) {
        self.hud_elements["compass_bg"] = newclienthudelem(self);
        self.hud_elements["compass_bg"].alignx = "center";
        self.hud_elements["compass_bg"].aligny = "top";
        self.hud_elements["compass_bg"].x = self.player_settings["min_x"] - 50;
        self.hud_elements["compass_bg"].y = self.player_settings["min_y"] + 5;
        self.hud_elements["compass_bg"].alpha = .75;
        self.hud_elements["compass_bg"].sort = -100;
        self.hud_elements["compass_bg"].color = self.choosencolor;
        self.hud_elements["compass_bg"].archived = 0;
        self.hud_elements["compass_bg"].hidewheninmenu = 1;
        self.hud_elements["compass_bg"] setshader("line_horizontal", 250, 12);
    }

    self thread fps_counter_think();

    while(1) {
        if(isdefined(self.hud_elements["fps_counter"])) {
            if(isdefined(self.fps))
                self.hud_elements["fps_counter"] setvalue(self.fps);
        }

        if(self.player_settings["comp_angle"] == 1 && self.hud_elements["compass_angles"].alpha != 1 && self.player_settings["compass"] == 1)
            self.hud_elements["compass_angles"].alpha = 1;
        else if(self.player_settings["comp_angle"] == 0 && self.hud_elements["compass_angles"].alpha != 0 && self.player_settings["compass"] == 1)
            self.hud_elements["compass_angles"].alpha = 0;

        if(self.player_settings["comp_line"] == 1 && self.hud_elements["compass_line"].alpha != 1 && self.player_settings["compass"] == 1)
            self.hud_elements["compass_line"].alpha = 1;
        else if(self.player_settings["comp_line"] == 0 && self.hud_elements["compass_line"].alpha != 0 && self.player_settings["compass"] == 1)
            self.hud_elements["compass_line"].alpha = 0;

        if(self.player_settings["compass"] == 0) {
            if(self.hud_elements["compass_bg"].alpha != 0)
                self.hud_elements["compass_bg"].alpha = 0;
            if(self.hud_elements["compass_angles"].alpha != 0)
                self.hud_elements["compass_angles"].alpha = 0;
            if(self.hud_elements["compass_line"].alpha != 0)
                self.hud_elements["compass_line"].alpha = 0;
        }
        else {
            if(self.hud_elements["compass_bg"].alpha != 1)
                self.hud_elements["compass_bg"].alpha = 1;
            if(self.hud_elements["compass_angles"].alpha != 1 && self.player_settings["comp_angle"] == 1)
                self.hud_elements["compass_angles"].alpha = 1;
            if(self.hud_elements["compass_line"].alpha != 1 && self.player_settings["comp_line"] == 1)
                self.hud_elements["compass_line"].alpha = 1;
        }

        wait .15;
    }
}

DeathTracker() {
    self endon("disconnect");

    while(1) {
        self waittill("death");

        self.score = self.session_stats["bounces"];
        self.kills = self.session_stats["saves"];
        self.assists = self.session_stats["loads"];
        self.deaths = self.session_stats["timeplayed"];
    }
}

TimeWatcher() {
    self endon("disconnect");

    while(1) {
        wait 60;

        self.savedmins++;
        self.deaths = self.savedmins;
        self.pers["deaths"] = self.deaths;
        self.player_settings["timeplayed"]++;
    }
}

bounce_detection() {
    self endon("disconnect");

    self thread calculate_height_waypoint();
    spectating_client       = undefined;

    while(1) {
        if(self.sessionstate != "spectator") {
            if(self getvelocity()[2] >= 300) {
                if(!self isonground() && !self isOnLadder()) {
                    self.bounces++;
                    self.score++;

                    self.bounce_origin = self.origin;
                    self.bouncetime = gettime();
                    self.last_bounced = countlines(self.clip_file);

                    self notify("newbounce");
                    self.pers["score"] = self.score;
                    self.player_settings["bounces"]++;
                    self setclientdvar("cj_stats_bounces", self.player_settings["bounces"]);
                    self zec\maps\player_stats::add_xp(300);

                    while(!self isonground())
                        wait .05;
                }
            }
        }

        wait .05;
    }
}

calculate_height_waypoint() {
    self endon("disconnect");

    self.current_saved_point = -500000;

    while(1) {
        if(isdefined(self.hud_elements["point_info"]) && self.hud_elements["point_info"].alpha == 1) {
            value = abs(self.origin[2] - self.waypoint.origin[2]) / 64;

            if(self.origin[2] < self.waypoint.origin[2]) {
                value = -1 * value;

                self.hud_elements["point_info"].color = (.8, .2, .1);
                self.hud_elements["point_info"] setvalue(value);

                if(self.hud_elements["highest_point"].colorname != "green") {
                    self.hud_elements["highest_point"].color = (.8, .2, .1);
                    self.hud_elements["highest_point"].colorname = "red";
                }

                if(self.current_saved_point < value) {
                    self.current_saved_point = value;
                    self.hud_elements["highest_point"] setvalue(self.current_saved_point);
                }
            }
            else {
                self.hud_elements["point_info"].color = (.1, .8, .1);
                self.hud_elements["highest_point"].color = (.1, .8, .1);
                self.hud_elements["highest_point"].colorname = "green";

                if(self.current_saved_point < value) {
                    self.current_saved_point = value;
                    self.hud_elements["highest_point"] setvalue(self.current_saved_point);
                }
            }
        }

        wait .05;
    }
}

change_hud_color(color) {
    self.choosencolor = ((self.player_settings["R"]/255), (self.player_settings["G"]/255), (self.player_settings["B"]/255));
    self.choosencolor_2 = ((self.player_settings["R2"]/255), (self.player_settings["G2"]/255), (self.player_settings["B2"]/255));

    self setclientdvar("cg_teamcolor_allies", self.choosencolor[0] + " " + self.choosencolor[1] + " " + self.choosencolor[2] + " 1");
    self setclientdvar("cg_teamcolor_axis", self.choosencolor[0] + " " + self.choosencolor[1] + " " + self.choosencolor[2] + " 1");
    self setclientdvar("cg_overheadnamesglow", self.choosencolor[0] + " " + self.choosencolor[1] + " " + self.choosencolor[2] + " 1");
    self setclientdvar("cg_scoreboardmycolor", self.choosencolor[0] + " " + self.choosencolor[1] + " " + self.choosencolor[2] + " 1");

    if(isdefined(self.hud_keyboard)) {
        foreach(hud in self.hud_keyboard)
            hud.color = self.choosencolor;
    }
    if(isdefined(self.hud_elements["velocity"]))
        self.hud_elements["velocity"].color = self.choosencolor;
    if(isdefined(self.hud_elements["fps_counter"]))
        self.hud_elements["fps_counter"].color = self.choosencolor;
    if(isdefined(self.hud_elements["analog_circle"]))
        self.hud_elements["analog_circle"].color = self.choosencolor;
    if(isdefined(self.hud_elements["compass_line"]))
        self.hud_elements["compass_line"].color = self.choosencolor;
    if(isdefined(self.hud_elements["compass_bg"]))
        self.hud_elements["compass_bg"].color = self.choosencolor;
    if(isdefined(self.hud_elements["compass_angles"]))
        self.hud_elements["compass_angles"].color = self.choosencolor;
    if(isdefined(self.hud_element_xp["xp_bar"]))
        self.hud_element_xp["xp_bar"].color = self.choosencolor;
}

save_load() {
    fxEnt = undefined;

    while(isdefined(self)) {
        if(self.sessionstate != "spectator") {
            if(self meleeButtonPressed()) {
                if(!self isMantling() && self isOnGround() && !isdefined(self.ui_selector) && !isdefined(self.isdemo) && !isdefined(self.cj_ufo) && !isdefined(self.cj_noclip)) {
                    if(isdefined(fxEnt))
                        fxEnt delete();

                    fxEnt = SpawnFX(level.save_ground_fx, self.origin + (0, 0, 0));
                    triggerfx(fxEnt);
                    fxEnt hide();
                    fxEnt showtoplayer(self);

                    if(!isdefined(self.selectedpoint))
                        self.selectedpoint = 1;

                    if(isdefined(self.isspeedrun))
                        self notify("playerrun_file_update");

                    if(isdefined(self.playerrun_stats_rpg))
                        self.playerrun_stats_rpg_saved = self.playerrun_stats_rpg;

                    self.last_demo_point = gettime();
                    self thread send_hud_notification_handler("Saved!");

                    self.save_history[self.selectedpoint] = spawnstruct();
                    self.save_history[self.selectedpoint].origin = self.saved_position.origin;
                    self.save_history[self.selectedpoint].angles = self.saved_position.angles;

                    self.saved_position.origin = self.origin;
                    self.saved_position.angles = self getplayerangles();

                    self.current_saved_point = -5000000;
                    self.hud_elements["highest_point"] setvalue(self.current_saved_point);
                    self.hud_elements["highest_point"].colorname = "red";
                    self.selectedpoint++;

                    self.kills++;
                    self.player_settings["saves"]++;
                    self.pers["kills"] = self.kills;

                    wait .5;
                }
            }
            else if(self useButtonPressed() && isdefined(self.selectedpoint) && distance(self getorigin(), self.saved_position.origin) >= 15) {
                if(!self isMantling() && !isdefined(self.ui_selector) && !isdefined(self.isdemo)) {
                    if(isDefined(self.selectedpoint)) {
                        if(isdefined(self.saved_position.angles)) {
                            self thread send_hud_notification_handler("Loaded!", 1);
                            self.assists++;

                            if(isdefined(self.playerrun_stats_loads))
                                self.playerrun_stats_loads++;

                            if(isdefined(self.playerrun_stats_rpg_saved))
                                self.playerrun_stats_rpg = self.playerrun_stats_rpg_saved;

                            foreach(weapon in self getWeaponsListPrimaries())
                                self setweaponammoclip(weapon, 1024);

                            self.current_saved_point = -5000000;
                            self.hud_elements["highest_point"] setvalue(self.current_saved_point);
                            self.hud_elements["highest_point"].colorname = "red";
                            self.last_demo_point = gettime();
                            if(isdefined(self.bouncetime))
                                self.bouncetime = undefined;
                            self.pers["assists"] = self.assists;
                            self.player_settings["loads"]++;
                            self setOrigin(self.saved_position.origin);
                            self setPlayerAngles(self.saved_position.angles);
                            self setvelocity((0, 0, 0));
                        }
                    }

                    wait .5;
                }
            }
        }

        wait .05;
    }

    if(isdefined(fxEnt))
        fxEnt delete();
}

send_hud_notification_handler(Text, min_value) {
    if(isdefined(self.notificationtitle)) {
        self.notificationtitle destroy();
        self.notificationtext destroy();
        self notify("NewInput");
    }

    self thread send_hud_notification(Text, min_value);
}

send_hud_notification(Text, min_value) {
    self endon("disconnect");
    self endon("NewInput");

    if(isdefined(Text)) {
        self.notificationtitle = newClientHudElem(self);
        self.notificationtitle.x = 800;
        self.notificationtitle.y = 100;
        self.notificationtitle.alignx = "right";
        self.notificationtitle.aligny = "middle";
        self.notificationtitle.horzalign = "fullscreen";
        self.notificationtitle.vertalign = "fullscreen";
        self.notificationtitle.alpha = 1;
        self.notificationtitle.sort = 1;
        self.notificationtitle.fontscale = .55;
        self.notificationtitle.font = "bigfixed";
        self.notificationtitle.foreground = 0;
        self.notificationtitle.color = self.choosencolor;
        self.notificationtitle.HideWhenInMenu = 1;
        self.notificationtitle.archived = 1;
        self.notificationtitle.label = &"Position ";
        if(!isdefined(min_value))
            self.notificationtitle setvalue(self.selectedpoint);
        else
            self.notificationtitle setvalue(int(self.selectedpoint - min_value));

        self.notificationtext = newClientHudElem(self);
        self.notificationtext.x = 800;
        self.notificationtext.y = 110;
        self.notificationtext.alignx = "right";
        self.notificationtext.aligny = "middle";
        self.notificationtext.horzalign = "fullscreen";
        self.notificationtext.vertalign = "fullscreen";
        self.notificationtext.alpha = 1;
        self.notificationtext.sort = 1;
        self.notificationtext.fontscale = .45;
        self.notificationtext.color = (1,1,1);
        self.notificationtext.font = "bigfixed";
        self.notificationtext.foreground = 0;
        self.notificationtext.HideWhenInMenu = 1;
        self.notificationtext.archived = 1;
        self.notificationtext settext(text);
    }

    self.notificationtext moveovertime(.2);
    self.notificationtext.x = 635;
    self.notificationtext.y = self.notificationtext.y;
    self.notificationtitle moveovertime(.2);
    self.notificationtitle.x = 635;
    self.notificationtitle.y = self.notificationtitle.y;
    wait 1;
    self.notificationtext fadeovertime(2);
    self.notificationtitle fadeovertime(.2);
    self.notificationtitle.alpha = 0;
    self.notificationtext.alpha = 0;
    wait .25;
    self.notificationtitle destroy();
    self.notificationtext destroy();
}

velocity_hud() {
    self endon("disconnect");

    if(!isdefined(self.hud_elements["velocity"])) {
        self.hud_elements["velocity"] = newClientHudElem(self);
        self.hud_elements["velocity"].x = self.player_settings["vel_x"];
        self.hud_elements["velocity"].y = self.player_settings["vel_y"];
        self.hud_elements["velocity"].alignx = "center";
        self.hud_elements["velocity"].aligny = "BOTTOM";
        self.hud_elements["velocity"].horzalign = "fullscreen";
        self.hud_elements["velocity"].vertalign = "fullscreen";
        self.hud_elements["velocity"].alpha = 1;
        self.hud_elements["velocity"].sort = 1;
        self.hud_elements["velocity"].fontscale = self.player_settings["vel_fs"];
        self.hud_elements["velocity"].color = self.choosencolor;
        self.hud_elements["velocity"].font = "bigfixed";
        self.hud_elements["velocity"].foreground = 0;
        self.hud_elements["velocity"].HideWhenInMenu = 1;
        self.hud_elements["velocity"].archived = 1;
    }

    if(!isdefined(self.hud_elements["deathbarrier"])) {
        self.hud_elements["deathbarrier"] = newClientHudElem(self);
        self.hud_elements["deathbarrier"].x = 320;
        self.hud_elements["deathbarrier"].y = 80;
        self.hud_elements["deathbarrier"].alignx = "center";
        self.hud_elements["deathbarrier"].aligny = "bottom";
        self.hud_elements["deathbarrier"].horzalign = "fullscreen";
        self.hud_elements["deathbarrier"].vertalign = "fullscreen";
        self.hud_elements["deathbarrier"].alpha = 0;
        self.hud_elements["deathbarrier"].sort = 1;
        self.hud_elements["deathbarrier"].fontscale = .5;
        self.hud_elements["deathbarrier"].color = self.choosencolor;
        self.hud_elements["deathbarrier"].font = "bigfixed";
        self.hud_elements["deathbarrier"].foreground = 0;
        self.hud_elements["deathbarrier"].HideWhenInMenu = 1;
        self.hud_elements["deathbarrier"].archived = 0;
        self.hud_elements["deathbarrier"] settext("Touching Deathtrigger");
    }

    spectating_client = undefined;

    while(1) {
        wait .05;

        if(!isdefined(self.isdemo)) {
            self.newvel = self getvelocity();

            if(isdefined(self.newvel)) {
                self.newvel = sqrt(float(self.newvel[0] * self.newvel[0]) + float(self.newvel[1] * self.newvel[1]));
                self.vel = self.newvel;
            }
        }

        if(self.sessionstate == "spectator") {
            spectating_client = self GetSpectatingPlayer();

            if(isdefined(spectating_client) && spectating_client.name != "") {
                if(self.hud_elements["spectator_binds"].alpha != 1)
                    self.hud_elements["spectator_binds"].alpha = 1;
            }
        }
        else if(isdefined(spectating_client))
            spectating_client = undefined;

        if(self.sessionstate != "spectator" && self.hud_elements["spectator_binds"].alpha != 0)
            self.hud_elements["spectator_binds"].alpha = 0;

        if(isdefined(self.hud_elements["compass_angles"]) && self.hud_elements["compass_angles"].alpha == 1 && !isdefined(spectating_client))
            self.hud_elements["compass_angles"] setvalue(int(self get_player_angle()));
        else if(isdefined(self.hud_elements["compass_angles"]) && self.hud_elements["compass_angles"].alpha == 1 && isdefined(spectating_client))
            self.hud_elements["compass_angles"] setvalue(int(spectating_client get_player_angle()));

        if(isdefined(self.vel))
            self.hud_elements["velocity"] setvalue(int(self.vel));
    }
}

_suicide_upg() {
    if(isdefined(self.isdemo)) {

    }
    else {
        if(isdefined(self.activatedbarriers) && self.activatedbarriers == 1) {
            if(isdefined(self.saved_position.origin)) {
                self setOrigin(self.saved_position.origin);
                self setPlayerAngles(self.saved_position.angles);

                self freezeControls(1);
                wait .1;
                self freezeControls(0);
            }
        }
        else if(isdefined(self.saving_clip) && self.saving_clip == 1) {

        }
        else
            self suicide();
    }
}

matchStartTimer_new( type, duration ) {
}

initKillstreakData_empty() {
}

music_init() {
    mapname = getdvar("mapname");
    level.music_data = [];

    switch(mapname) {
        case "mp_phoenix":
            precachemenu("main_music_menu");

            level.music_data[0] = spawnstruct();
            level.music_data[0].artist = "Mpulse";
            level.music_data[0].songname = "Corvus";
            level.music_data[0].filename = "song1";

            level.music_data[1] = spawnstruct();
            level.music_data[1].artist = "Lane 8";
            level.music_data[1].songname = "Fingerprint (Remix)";
            level.music_data[1].filename = "song2";

            level.music_data[2] = spawnstruct();
            level.music_data[2].artist = "Virtual Self";
            level.music_data[2].songname = "Ghost Voices (Hex Cougar Flip)";
            level.music_data[2].filename = "song3";

            level.music_data[3] = spawnstruct();
            level.music_data[3].artist = "War";
            level.music_data[3].songname = "Low Rider (Remix)";
            level.music_data[3].filename = "song4";

            level.music_data[4] = spawnstruct();
            level.music_data[4].artist = "Wizard";
            level.music_data[4].songname = "Don't Stop";
            level.music_data[4].filename = "song5";
            break;
        case "mp_sierra":
            precachemenu("main_music_menu");

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 1";
            level.music_data[i].filename = "dimitri";

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 2";
            level.music_data[i].filename = "funk1";

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 3";
            level.music_data[i].filename = "funk2";

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 4";
            level.music_data[i].filename = "funk3";

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 5";
            level.music_data[i].filename = "funk4";

            i = level.music_data.size;

            level.music_data[i] = spawnstruct();
            level.music_data[i].artist = "Unknown";
            level.music_data[i].songname = "Song 6";
            level.music_data[i].filename = "saunoo";
            break;
        default:
            level.music_data = undefined;
            break;
    }
}

hud_spectator_list() {
    self endon("disconnect");

    self.hud_spectator_emoji = newclienthudelem(self);
    self.hud_spectator_emoji.horzalign = "fullscreen";
    self.hud_spectator_emoji.vertalign = "fullscreen";
    self.hud_spectator_emoji.alignx = "left";
    self.hud_spectator_emoji.aligny = "bottom";
    self.hud_spectator_emoji.x = 5;
    self.hud_spectator_emoji.y = 200;
    self.hud_spectator_emoji.hidewheninmenu = 1;
    self.hud_spectator_emoji.alpha = 0;
    self.hud_spectator_emoji setshader("eye_emoji", 10, 10);

    if(!isdefined(self.hud_elements["spectator_binds"])) {
        self.hud_elements["spectator_binds"] = newclienthudelem(self);
        self.hud_elements["spectator_binds"].horzalign = "fullscreen";
        self.hud_elements["spectator_binds"].vertalign = "fullscreen";
        self.hud_elements["spectator_binds"].alignx = "left";
        self.hud_elements["spectator_binds"].aligny = "top";
        self.hud_elements["spectator_binds"].x = 2;
        self.hud_elements["spectator_binds"].y = 2;
        self.hud_elements["spectator_binds"].sort = 10000;
        self.hud_elements["spectator_binds"].fontscale = 1;
        self.hud_elements["spectator_binds"].font = "small";
        self.hud_elements["spectator_binds"].label = &"Teleport to Player:\r                                                    ^8[{+actionslot 6}]\n^7Teleport to His Save:\r                                                    ^8[{+actionslot 7}]";
        self.hud_elements["spectator_binds"].alpha = 0;
        self.hud_elements["spectator_binds"].archived = 0;
        self.hud_elements["spectator_binds"].foreground = 1;
        self.hud_elements["spectator_binds"].hidewheninmenu = 1;
    }

    if(!isdefined(self.hud_elements["demo_binds"])) {
        self.hud_elements["demo_binds"] = newclienthudelem(self);
        self.hud_elements["demo_binds"].horzalign = "fullscreen";
        self.hud_elements["demo_binds"].vertalign = "fullscreen";
        self.hud_elements["demo_binds"].alignx = "left";
        self.hud_elements["demo_binds"].aligny = "top";
        self.hud_elements["demo_binds"].x = 2;
        self.hud_elements["demo_binds"].y = 2;
        self.hud_elements["demo_binds"].sort = 10000;
        self.hud_elements["demo_binds"].fontscale = 1;
        self.hud_elements["demo_binds"].font = "small";
        self.hud_elements["demo_binds"].label = &"Teleport to Start Position:\r                                                    ^8[{+actionslot 6}]";
        self.hud_elements["demo_binds"].alpha = 0;
        self.hud_elements["demo_binds"].archived = 0;
        self.hud_elements["demo_binds"].foreground = 1;
        self.hud_elements["demo_binds"].hidewheninmenu = 1;
    }

    self.hud_spectator = newclienthudelem(self);
    self.hud_spectator.horzalign = "fullscreen";
    self.hud_spectator.vertalign = "fullscreen";
    self.hud_spectator.alignx = "left";
    self.hud_spectator.aligny = "top";
    self.hud_spectator.x = 5;
    self.hud_spectator.y = 200;
    self.hud_spectator.fontscale = .4;
    self.hud_spectator.font = "bigfixed";
    self.hud_spectator.alpha = 0;
    self.hud_spectator.hidewheninmenu = 1;

    while(1) {
        self waittill("spectator_list_update");

        if(self.player_settings["spechud"] == 1) {
            if(isdefined(self.spec_list) && self.spec_list != "") {
                if(self.hud_spectator.alpha != 1) {
                    self.hud_spectator fadeovertime(.4);
                    self.hud_spectator.alpha = 1;
                    self.hud_spectator_emoji fadeovertime(.4);
                    self.hud_spectator_emoji.alpha = 1;
                    wait .4;
                }

                self.hud_spectator settext(self.spec_list);
            }
            else {
                if(self.hud_spectator.alpha != 0) {
                    self.hud_spectator fadeovertime(.4);
                    self.hud_spectator.alpha = 0;
                    self.hud_spectator_emoji fadeovertime(.4);
                    self.hud_spectator_emoji.alpha = 0;
                    wait .4;
                }
            }
        }
        else {
            if(self.hud_spectator.alpha != 0)
                self.hud_spectator.alpha = 0;
            if(self.hud_spectator_emoji.alpha != 0)
                self.hud_spectator_emoji.alpha = 0;
        }
    }
}

return_stencil(teamname) {
    return "stencil_base";
}

giveLoadout_edit( team, class, allowCopycat, setPrimarySpawnWeapon ) {
}

doMissionCallback_edit( callback, data ) {
}

blanky() {
}

Callback_PlayerDamage( eInflictor, eAttacker, victim, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ) {
    if(isdefined(eAttacker) && isdefined(eAttacker.guid))
        return int(0);

    if(isdefined(self.isdemo))
        return int(0);
    else {
        if(isdefined(self.player_settings["deathbarriers"]) && self.player_settings["deathbarriers"] == 1) {
            if(isdefined(self.player_settings["deathbarriers_noti"]) && self.player_settings["deathbarriers_noti"] == 1)
                self.hud_elements["deathbarrier"].alpha = 1;
        }
        else
            self suicide();
    }
}

killTrigger_edit( pos, radius, height ) {
    trig = spawn( "trigger_radius", pos, 0, radius, height );

    while(isdefined(trig)) {
        trig waittill("trigger", player);

        if(isdefined(player.player_settings["deathbarriers"]) && player.player_settings["deathbarriers"] == 1) {
            if(isdefined(player.player_settings["deathbarriers_noti"]) && player.player_settings["deathbarriers_noti"] == 1)
                player.hud_elements["deathbarrier"].alpha = 1;
        }
        else
            player suicide();
    }
}

getWeaponRank_edit(a) {
    return 0;
}