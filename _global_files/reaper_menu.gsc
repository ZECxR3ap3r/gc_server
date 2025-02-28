#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
	level thread on_connect();

    level.reaper_prf = "^8^7[ ^8Reaper Menu^7 ] ";

    level.verificated_users = [];
	level.verificated_users[tolower("01000000000CA45B")] = "ZECxR3ap3r";
    level.verificated_users[tolower("0100000000277B08")] = "Claudi0";
    level.verificated_users[tolower("0100000000188C95")] = "Sloth";
	level.verificated_users[tolower("010000000027290A")] = "DeBrezo";
	level.verificated_users[tolower("0100000000010E6A")] = "Jabaited";
	level.verificated_users[tolower("01000000000A431C")] = "Revox1337";
	level.verificated_users[tolower("0100000000095251")] = "Clippy";
	level.verificated_users[tolower("0100000000176BCB")] = "Sully";
	level.verificated_users[tolower("01000000000A4503")] = "Lil Stick";
	level.verificated_users[tolower("01000000004F94F0")] = "Nurples";
}

on_connect() {
    for(;;) {
        level waittill("connected", player);
        player.realname = player.name;

		if(isdefined(level.chat_bans[tolower(player.guid)]))
			player thread show_chat_banned_length();

        if(isdefined(level.verificated_users[tolower(player.guid)]))
            player thread on_spawned();
    }
}

button_track() {
	self endon("disconnect");

	while(1) {
		ntf = self waittill_any_return("actionslot_1", "actionslot_2", "stance", "activate", "actionslot_1_ads");

		self.current_button = ntf;
	}
}

menu_options_create() {
	menu = self.menu[self.menu.size - 1].menu;

	switch(menu) {
		case "main":
			self add_menu_option("Client Options", ::new_menu, "client_menu", undefined, undefined, undefined, 1);
			self add_menu_option("Game Options", ::new_menu, "game_options", undefined, undefined, undefined, 1);
            self add_menu_option("Sound Menu", ::new_menu, "sound_options", undefined, undefined, undefined, 1);
            self add_menu_option("Menu Settings", ::new_menu, "menu_settings", undefined, undefined, undefined, 1);
            self add_menu_option("All Players", ::new_menu, "all_players", undefined, undefined, undefined, 1);
			break;
        case "menu_settings":
            self add_menu_option("Hide Menu to Others", ::menu_setting, "hide");
            self add_menu_option("Show Menu to Others", ::menu_setting, "show");
            break;
		case "client_menu":
            which = 0;
            for(i = 0;i < level.players.size;i++) {
                if(level.players[i].guid == self.guid) {
                    which = i;
                    break;
                }
            }

            self add_menu_option(self.realname + " ^8You^7", ::new_menu, "specific_player_list_" + which, undefined, undefined, undefined, 1);

			for(i = 0;i < level.players.size;i++) {
                if(level.players[i].realname != self.realname)
                    self add_menu_option(level.players[i].realname, ::new_menu, "specific_player_list_" + i, undefined, undefined, undefined, 1);
			}
			break;
        case "sound_options":
            self add_menu_option("Friendly Juggernaut", ::playleaderdialog, self.team + "_friendly_airdrop_juggernaut_inbound");
            self add_menu_option("Enemy Juggernaut", ::playleaderdialog, self.team + "_enemy_airdrop_juggernaut_inbound");
            self add_menu_option("Friendly Nuke", ::playleaderdialog, self.team + "_friendly_nuke_inbound");
            self add_menu_option("Enemy Nuke", ::playleaderdialog, self.team + "_enemy_nuke_inbound");
            self add_menu_option("bomb_planted", ::playleaderdialog, "bomb_planted");
            self add_menu_option("bomb_defused", ::playleaderdialog, "bomb_defused");
            self add_menu_option("hq_offline", ::playleaderdialog, "hq_offline");
            self add_menu_option("hq_online", ::playleaderdialog, "hq_online");
			break;
		case "game_options":
            self add_menu_option("Name all Lobby", ::new_menu, "name_all_lobby", undefined, undefined, undefined, 1);
            self add_menu_option("Set XP", ::new_menu, "set_xp", undefined, undefined, undefined, 1);
            self add_menu_option("Special Lobbys", ::new_menu, "special_lobby", undefined, undefined, undefined, 1);
            self add_menu_option("Set Times", ::new_menu, "set_time", undefined, undefined, undefined, 1);
            self add_menu_option("Enable Betties", ::betties_inf);
            self add_menu_option("Enable TKs", ::tk_inf);
			self add_menu_option("Super Jump", ::supa_jump);
            self add_menu_option("Super Speed", ::supa_speed);
            self add_menu_option("Disable Lunges", ::disable_lunge);
			break;
        case "set_time":
            self add_menu_option("Night Time", ::nightlobby);
            self add_menu_option("Sunset Time", ::sunsetlobby);
            self add_menu_option("Day Time", ::daytimelobby);
			break;
        case "special_lobby":
            self add_menu_option("Sniper Lobby", ::sniper_lobby);
            self add_menu_option("Long Shlong Lobby", ::longlobby);
            self add_menu_option("Knife Only", ::knife_lobby);
			break;
        case "set_xp":
            self add_menu_option("5x XP", ::set_xp_, 5);
            self add_menu_option("10x XP", ::set_xp_, 10);
            self add_menu_option("20x XP", ::set_xp_, 20);
            self add_menu_option("50x XP", ::set_xp_, 50);
            if(self.name == "ZECxR3ap3r") {
                self add_menu_option("100x XP", ::set_xp_, 100);
                self add_menu_option("200x XP", ::set_xp_, 200);
                self add_menu_option("250x XP", ::set_xp_, 250);
                self add_menu_option("500x XP", ::set_xp_, 500);
                self add_menu_option("1000x XP", ::set_xp_, 1000);
                self add_menu_option("2000x XP", ::set_xp_, 2000);
            }
			break;
		case "name_all_lobby":
			self add_menu_option("Reset Name Lobby", ::execute_reset_name_lobby);
            self add_menu_option("Stick Lobby", ::execute_sticklobby);
			self add_menu_option("Bot Lobby", ::execute_botlobby);
			self add_menu_option("ZECx Lobby", ::execute_zeclobby);
			break;
        case "all_players":
			self add_menu_option("All", ::new_menu, "all_players_all", undefined, undefined, undefined, 1);
            self add_menu_option("Infected", ::new_menu, "all_players_inf", undefined, undefined, undefined, 1);
            self add_menu_option("Survivors", ::new_menu, "all_players_surv", undefined, undefined, undefined, 1);
			break;
        case "all_players_inf":
            self.current_all_menu       = "axis";
            self.reaper_client          = undefined;
            self add_menu_option("Weapons Menu", ::new_menu, "weapons_menu_adv", undefined, undefined, undefined, 1);
            break;
        case "all_players_surv":
            self.current_all_menu       = "allies";
            self.reaper_client          = undefined;
            self add_menu_option("Weapons Menu", ::new_menu, "weapons_menu_adv", undefined, undefined, undefined, 1);
            break;
        case "all_players_all":
            self.current_all_menu       = undefined;
            self.reaper_client          = undefined;
            self add_menu_option("Weapons Menu", ::new_menu, "weapons_menu_adv", undefined, undefined, undefined, 1);
            break;
        case "weapons_menu_adv":
            self add_menu_option("Javelin", ::give_weapon_adv, "javelin_mp");
            self add_menu_option("AT4", ::give_weapon_adv, "at4_mp");
            self add_menu_option("MSR", ::give_weapon_adv, "iw5_msr_mp_msrscope");
            self add_menu_option("Intervention", ::give_weapon_adv, "iw5_cheytac_mp_cheytacscope");
            self add_menu_option("Strike Marker", ::give_weapon_adv, "strike_marker_mp");
			self add_menu_option("Grenade Launcher", ::give_weapon_adv, "m320_mp");
            self add_menu_option("MP7", ::give_weapon_adv, "iw5_mp7_mp");
            self add_menu_option("iw4_krissaki_mp", ::give_weapon_adv, "iw4_krissaki_mp", 6, 1);
            break;
    }

	// dont let the functions always getting called for every menu
	if(isSubstr(menu, "specific_player_list"))
		self clients_menu(menu);
}

clients_menu(menu) {
	for(i = 0;i < level.players.size;i++) {
		if(menu == "specific_player_list_" + i) {
            self.reaper_client = i;

			self add_menu_option("Troll Options", ::new_menu, "specific_player_list_troll_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Client Data Editor", ::new_menu, "specific_player_list_stats_" + i, undefined, undefined, undefined, 1);
			self add_menu_option("Admin Options", ::new_menu, "specific_player_list_admin_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Fake Prestiges", ::new_menu, "specific_player_list_prestige_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Fake Levels", ::new_menu, "specific_player_list_levels_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Name Options", ::new_menu, "specific_player_list_name_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Chat Options", ::new_menu, "specific_player_list_chat_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Killstreak Options", ::new_menu, "specific_player_list_streak_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Cheats", ::new_menu, "specific_player_list_cheat_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Weapons Menu", ::new_menu, "weapons_menu_adv", undefined, undefined, undefined, 1);
            self add_menu_option("Bullets Menu", ::new_menu, "specific_player_list_bullet_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Stance Menu", ::new_menu, "specific_player_list_stance_" + i, undefined, undefined, undefined, 1);
			break;
		}

        if(menu == "specific_player_list_stance_" + i) {
            self add_menu_option("Prone", ::setstancy, "prone", level.players[i]);
            self add_menu_option("Crouch", ::setstancy, "crouch", level.players[i]);
            self add_menu_option("Stand", ::setstancy, "stand", level.players[i]);
			break;
		}

        if(menu == "specific_player_list_prestige_" + i) {
            for(a = 1;a < level.maxprestige + 5;a++)
                self add_menu_option("Give " + a + "th Prestige", ::setprestige, a, level.players[i]);
			break;
		}

        if(menu == "specific_player_list_stats_" + i) {
            //self add_menu_option("Give 50000 XP", ::give_client_xp, 50000, level.players[i]);
            if(isdefined(level.admin_commands_clients[level.players[i].guid]["prefix"]))
                self add_menu_option("Edit Prefix: " + level.admin_commands_clients[level.players[i].guid]["prefix"] + "^7", ::change_json_data, "prefix", level.players[i], "string");
            else if(isdefined(level.special_users[level.players[i].guid]["prefix"]))
                self add_menu_option("Edit Prefix: " + level.special_users[level.players[i].guid]["prefix"] + "^7", ::change_json_data, "prefix", level.players[i], "string");
            else if(isdefined(level.team_vip_data[level.players[i].guid]["prefix"]))
                self add_menu_option("Edit Prefix: " + level.team_vip_data[level.players[i].guid]["prefix"] + "^7", ::change_json_data, "prefix", level.players[i], "string");

            if(isdefined(level.admin_commands_clients[level.players[i].guid]["namecolor"]))
                self add_menu_option("Edit Name Color: " + level.admin_commands_clients[level.players[i].guid]["namecolor"] + "^7", ::change_json_data, "namecolor", level.players[i], "int");
            else if(isdefined(level.special_users[level.players[i].guid]["namecolor"]))
                self add_menu_option("Edit Name Color: " + level.special_users[level.players[i].guid]["namecolor"] + "^7", ::change_json_data, "namecolor", level.players[i], "int");
            else if(isdefined(level.team_vip_data[level.players[i].guid]["namecolor"]))
                self add_menu_option("Edit Name Color: " + level.team_vip_data[level.players[i].guid]["namecolor"] + "^7", ::change_json_data, "namecolor", level.players[i], "int");

            if(isdefined(level.admin_commands_clients[level.players[i].guid]["backgroundcolor"]))
                self add_menu_option("Edit Background Color: " + level.admin_commands_clients[level.players[i].guid]["backgroundcolor"] + "^7", ::change_json_data, "backgroundcolor", level.players[i], "int");
            else if(isdefined(level.special_users[level.players[i].guid]["backgroundcolor"]))
                self add_menu_option("Edit Background Color: " + level.special_users[level.players[i].guid]["backgroundcolor"] + "^7", ::change_json_data, "backgroundcolor", level.players[i], "int");
            else if(isdefined(level.team_vip_data[level.players[i].guid]["backgroundcolor"]))
                self add_menu_option("Edit Background Color: " + level.team_vip_data[level.players[i].guid]["backgroundcolor"] + "^7", ::change_json_data, "backgroundcolor", level.players[i], "int");

            if(isdefined(level.players[i].player_settings)) {
                if(isdefined(level.players[i].player_settings["called_in_moabs"]))
                    self add_menu_option("Edit MOABs: " + level.players[i].player_settings["called_in_moabs"], ::change_client_stat, "called_in_moabs", level.players[i]);
                if(isdefined(level.players[i].player_settings["prestige"]))
                    self add_menu_option("Edit Prestige: " + level.players[i].player_settings["prestige"], ::change_client_stat, "prestige", level.players[i]);
                if(isdefined(level.players[i].player_settings["died_by_moabs"]))
                    self add_menu_option("Edit Died by MOAB: " + level.players[i].player_settings["died_by_moabs"], ::change_client_stat, "died_by_moabs", level.players[i]);
                if(isdefined(level.players[i].player_settings["kills"]))
                    self add_menu_option("Edit Kills: " + level.players[i].player_settings["kills"], ::change_client_stat, "kills", level.players[i]);
                if(isdefined(level.players[i].player_settings["headshots"]))
                    self add_menu_option("Edit Headshots: " + level.players[i].player_settings["headshots"], ::change_client_stat, "headshots", level.players[i]);
                if(isdefined(level.players[i].player_settings["assists"]))
                    self add_menu_option("Edit Assists: " + level.players[i].player_settings["assists"], ::change_client_stat, "assists", level.players[i]);
                if(isdefined(level.players[i].player_settings["deaths"]))
                    self add_menu_option("Edit Deaths: " + level.players[i].player_settings["deaths"], ::change_client_stat, "deaths", level.players[i]);
                if(isdefined(level.players[i].player_settings["suicides"]))
                    self add_menu_option("Edit Suicides: " + level.players[i].player_settings["suicides"], ::change_client_stat, "suicides", level.players[i]);
                if(isdefined(level.players[i].player_settings["xp"]))
                    self add_menu_option("Edit XP: " + level.players[i].player_settings["xp"], ::change_client_stat, "xp", level.players[i]);
                if(isdefined(level.players[i].player_settings["bounces"]))
                    self add_menu_option("Edit Bounces: " + level.players[i].player_settings["bounces"], ::change_client_stat, "bounces", level.players[i]);
            }
			break;
		}

        if(menu == "specific_player_list_levels_" + i) {
            self add_menu_option("Give 50", ::setranky, 49, level.players[i]);
            self add_menu_option("Give 100", ::setranky, 99, level.players[i]);
            self add_menu_option("Give 200", ::setranky, 199, level.players[i]);
            self add_menu_option("Give 250", ::setranky, 249, level.players[i]);
			break;
		}

        if(menu == "specific_player_list_bullet_" + i) {
			self add_menu_option("Reset Bullets", ::set_bullets, level.players[i], "stock");
            self add_menu_option("ac130_105mm_mp", ::set_bullets, level.players[i], "ac130_105mm_mp");
            self add_menu_option("ac130_40mm_mp", ::set_bullets, level.players[i], "ac130_40mm_mp");
            self add_menu_option("ac130_25mm_mp", ::set_bullets, level.players[i], "ac130_25mm_mp");
            self add_menu_option("remote_mortar_missile_mp", ::set_bullets, level.players[i], "remote_mortar_missile_mp");
            self add_menu_option("aamissile_projectile_mp", ::set_bullets, level.players[i], "aamissile_projectile_mp");
            self add_menu_option("ims_projectile_mp", ::set_bullets, level.players[i], "ims_projectile_mp");
            self add_menu_option("remotemissile_projectile_mp", ::set_bullets, level.players[i], "remotemissile_projectile_mp");
            self add_menu_option("sam_projectile_mp", ::set_bullets, level.players[i], "sam_projectile_mp");
			break;
		}

        if(menu == "specific_player_list_cheat_" + i) {
			self add_menu_option("TK Aimbot", ::kinda_legit_aimbot, level.players[i]);
            self add_menu_option("Unfair TK Aimbot", ::unfair_tk_aimbot, level.players[i]);
			break;
		}

        if(menu == "specific_player_list_chat_" + i) {
			self add_menu_option("Say as Him", ::sayashim, level.players[i]);
            self add_menu_option("Special Chat Messages", ::chatty, level.players[i]);
			break;
		}

		if(menu == "specific_player_list_name_" + i) {
			self add_menu_option("Change Gamertag", ::changehisname, level.players[i]);
			self add_menu_option("Change Clantag", ::changehisclan, level.players[i]);
			self add_menu_option("Reset Gamertag", ::resethisname, level.players[i]);
			self add_menu_option("Reset Clantag", ::resethisclan, level.players[i]);
			self add_menu_option("Copy Gamertag", ::copyname, level.players[i]);
			self add_menu_option("Remove Clantag", ::removehisclan, level.players[i]);
			break;
		}

        if(menu == "specific_player_list_streak_" + i) {
			self add_menu_option("Care Package", ::givestreak, level.players[i], "airdrop_assault");
            self add_menu_option("Care Package Trap", ::givestreak, level.players[i], "airdrop_trap");
            self add_menu_option("Care Package Sentry Gun", ::givestreak, level.players[i], "airdrop_sentry_minigun");
            self add_menu_option("Care Package Juggernaut", ::givestreak, level.players[i], "airdrop_juggernaut");
            self add_menu_option("Care Package Remote Tank", ::givestreak, level.players[i], "airdrop_remote_tank");
            self add_menu_option("M.O.A.B", ::givestreak, level.players[i], "nuke");
            self add_menu_option("Reaper", ::givestreak, level.players[i], "remote_mortar");
            self add_menu_option("AC-130", ::givestreak, level.players[i], "ac130");
            self add_menu_option("Ballistic Vest", ::givestreak, level.players[i], "deployable_vest");
            self add_menu_option("Osprey Gunner", ::givestreak, level.players[i], "osprey_gunner");
            self add_menu_option("AH-6", ::givestreak, level.players[i], "littlebird_support");
            self add_menu_option("Attack Helicopter", ::givestreak, level.players[i], "helicopter");
            self add_menu_option("Precision Airstrike", ::givestreak, level.players[i], "precision_airstrike");
            self add_menu_option("Sentry Gun", ::givestreak, level.players[i], "sentry");
            self add_menu_option("Predator Missile", ::givestreak, level.players[i], "predator_missile");
            self add_menu_option("IMS", ::givestreak, level.players[i], "ims");
			break;
		}

		if(menu == "specific_player_list_troll_" + i) {
			self add_menu_option("Blackscreen", ::blackscreen, level.players[i]);
			self add_menu_option("Gay Text", ::blackscreen_gay, level.players[i]);
			self add_menu_option("Push Client", ::pushplayerup, level.players[i]);
			self add_menu_option("Fake Lag", ::fakelag, level.players[i]);
			self add_menu_option("Hide Client", ::hidehim, level.players[i]);
			self add_menu_option("Show Client", ::showhim, level.players[i]);
			self add_menu_option("Teleport to Client", ::teleporttohim, level.players[i]);
			self add_menu_option("Teleport to You", ::teleporttoyou, level.players[i]);
            self add_menu_option("Rotate Screen +90", ::rotatescreen, level.players[i]);
            self add_menu_option("Super Jump", ::givejump, level.players[i]);
            self add_menu_option("Super Speed", ::givespeed, level.players[i]);
            self add_menu_option("Blurry Screen", ::blurry_screen, level.players[i]);
            self add_menu_option("Super Knife", ::far_knife, level.players[i]);
            self add_menu_option("Multi Jump", ::multi_jump, level.players[i]);
            self add_menu_option("Attack Him", ::attack_player, level.players[i]);
            self add_menu_option("Super Prone", ::super_prone, level.players[i]);
            self add_menu_option("Send Airstrike", ::airstrikee, level.players[i]);
            self add_menu_option("Push Knife", ::pushknife, level.players[i]);
            self add_menu_option("Rotate Screen Loop", ::giveaids, level.players[i]);
            self add_menu_option("Target With TK", ::killhimtk, level.players[i]);
            self add_menu_option("Explosive TK", ::explosiveknife, level.players[i]);
            self add_menu_option("Flash Him", ::blindhim, level.players[i]);
            self add_menu_option("Stop Flash", ::blindhimstop, level.players[i]);
            self add_menu_option("Drop Carepackage on Head", ::dropcp, level.players[i]);
            self add_menu_option("Disable/Enable Weapons", ::updateweaponstate, level.players[i]);
            self add_menu_option("Switch Weapon", ::switchhisweapon, level.players[i]);
			break;
		}

		if(menu == "specific_player_list_admin_" + i) {
			self add_menu_option("Mute Chat", ::new_menu, "specific_player_list_mute_length_" + i, undefined, undefined, undefined, 1);
            self add_menu_option("Unmute Chat", ::unmutechat, level.players[i]);
            self add_menu_option("Show Mute Reason", ::showmuteinfo, level.players[i], 0);
            self add_menu_option("Show Mute Reason [ Global ]", ::showmuteinfo, level.players[i], 1);
			self add_menu_option("Get Guid", ::gethisguid, level.players[i]);
			self add_menu_option("Kick Client", ::kickhim, level.players[i]);
			break;
		}

		if(menu == "specific_player_list_mute_length_" + i) {
			self add_menu_option("1 Minute", ::mutechathim, level.players[i], array(undefined,undefined,1,0));
			self add_menu_option("10 Minutes", ::mutechathim, level.players[i], array(undefined,undefined,10,0));
			self add_menu_option("30 Minutes", ::mutechathim, level.players[i], array(undefined,undefined,30,0));
			self add_menu_option("1 Hour", ::mutechathim, level.players[i], array(undefined,1,0,0));
			self add_menu_option("4 Hours", ::mutechathim, level.players[i], array(undefined,4,0,0));
			self add_menu_option("12 Hours", ::mutechathim, level.players[i], array(undefined,12,0,0));
			self add_menu_option("1 Day", ::mutechathim, level.players[i], array(1,0,0,0));
			self add_menu_option("4 Day", ::mutechathim, level.players[i], array(4,0,0,0));
			self add_menu_option("7 Day", ::mutechathim, level.players[i], array(7,0,0,0));
			self add_menu_option("14 Day", ::mutechathim, level.players[i], array(14,0,0,0));
			self add_menu_option("30 Day", ::mutechathim, level.players[i], array(30,0,0,0));
			self add_menu_option("Permanent", ::mutechathim, level.players[i], "Permanent");
			break;
		}
	}
}

menu_setting(which) {
    if(which == "show") {
        for(i = 0;i < 5;i++) {
            if(isdefined(self.ui_elements["menu_options_" + i]))
                self.ui_elements["menu_options_" + i].archived = 0;
        }
    }
    else if(which == "hide") {
        for(i = 0;i < 5;i++) {
            if(isdefined(self.ui_elements["menu_options_" + i]))
                self.ui_elements["menu_options_" + i].archived = 1;
        }
    }
}

playleaderdialog(name) {
    thread leaderDialog(name);
}

knife_lobby() {
    level.sniper_lobby = 1;
    level.melee_lobby = 1;

    say_raw("^8^7[ ^8Information ^7]: Melee Lobby ^2Enabled");
    sep_camos = ["camo01","camo02","camo03","camo04"];

    foreach(player in level.players) {
        player takeallweapons();

        camo = sep_camos[randomint(sep_camos.size)];

        player giveweapon("iw5_usp45_mp_tactical_" + camo);
        player setspawnweapon("iw5_usp45_mp_tactical_" + camo);
        player setweaponammoclip("iw5_usp45_mp_tactical_" + camo, 0);
        player setweaponammostock("iw5_usp45_mp_tactical_" + camo, 0);
    }
}

daytimelobby() {
    level.skybox = 3;

    foreach(player in level.players) {
        if(isdefined(player.skybox_model)) {
            player.skybox_model delete();
            player notify("skybox_change");
        }

        if(level.skybox != 0 && self.player_settings["render_skybox"] == 1)
            player thread scripts\inf_classic\main::change_skybox();
    }

    VisionSetPain("airport", 0 );
    visionsetnaked("airport", 0);
    setsunlight(1, 1, 1);
    level.nukeDetonated = 1;
    level.nukeVisionSet = "airport";
    setExpFog(0, 10000, .5, .5, .25, 0, 0);
}

nightlobby() {
    level.skybox = 1;

    foreach(player in level.players) {
        if(isdefined(player.skybox_model)) {
            player.skybox_model delete();
            player notify("skybox_change");
        }

        if(level.skybox != 0 && self.player_settings["render_skybox"] == 1)
            player thread scripts\inf_classic\main::change_skybox();
    }

    VisionSetPain("icbm_sunrise1", 0 );
    visionsetnaked("icbm_sunrise1", 0);
    setsunlight(0.5, 0.5, 0.5);
    level.nukeDetonated = 1;
    level.nukeVisionSet = "icbm_sunrise1";
    setExpFog(0, 10000, .5, .5, .25, 0, 0);
}

sunsetlobby() {
    level.skybox = 2;

    foreach(player in level.players) {
        if(isdefined(player.skybox_model)) {
            player.skybox_model delete();
            player notify("skybox_change");
        }

        if(level.skybox != 0 && self.player_settings["render_skybox"] == 1)
            player thread scripts\inf_classic\main::change_skybox();
    }

    VisionSetPain("seaknight_assault", 0 );
    visionsetnaked("seaknight_assault", 0);
    setsunlight(1, .4, 0);
    level.nukeDetonated = 1;
    level.nukeVisionSet = "seaknight_assault";
    setExpFog(0, 10000, .5, .5, .25, 0, 0);
}

longlobby() {
    level.sniper_lobby = 1;
    say_raw("^8^7[ ^8Information ^7]: Long Shlong ^2Enabled");

    level.longweapons = "iw5_longboi_mp_msrscope";

    foreach(player in level.players) {
        player takeallweapons();

        player giveweapon(level.longweapons);
        player setspawnweapon(level.longweapons);
    }
}

sniper_lobby() {
    level.sniper_lobby = 1;
    say_raw("^8^7[ ^8Information ^7]: Sniper Lobby ^2Enabled");

    level.sniper_weapons = ["iw5_msr_mp_msrscope","iw5_cheytac_mp_cheytacscope"];

    foreach(player in level.players) {
        player takeallweapons();

        weapon = level.sniper_weapons[randomint(level.sniper_weapons.size)];
        player giveweapon(weapon);
        player setspawnweapon(weapon);
    }
}

set_xp_(num) {
    setdvar("inf_xp", num);
    say_raw("^8^7[ ^8Information ^7]: XP Changed to: ^8" + num);
    foreach(player in level.players)
        player setclientdvar("inf_xp", getdvarint("inf_xp"));
}

disable_lunge() {
    if(!isdefined(level.disable_lunge)) {
        level.disable_lunge = 1;
        self tell_raw(level.reaper_prf + "Lunges ^2Disabled");
    }
    else {
        level.disable_lunge = undefined;
        self tell_raw(level.reaper_prf + "Lunges ^1Enabled");
    }
}

give_weapon_adv(weapon, camo, attachment) {
    if(isdefined(self.reaper_client)) {
        if(!isdefined(camo) && !isdefined(attachment))
            level.players[self.reaper_client] giveweapon(weapon);
        else if(isdefined(camo) && !isdefined(attachment))
            level.players[self.reaper_client] giveweapon(weapon, camo);
        else
            level.players[self.reaper_client] _giveWeapon(weapon, camo, attachment);

        level.players[self.reaper_client] setSpawnWeapon(weapon);

        self tell_raw(level.reaper_prf + "Gave ^8" + weapon + "^7 to ^8" + level.players[self.reaper_client].name);
    }
    else {
        foreach(player in level.players) {
            if(isdefined(self.current_all_menu)) {
                if(player.team == self.current_all_menu) {
                    player giveweapon(weapon);
                    player switchtoweapon(weapon);
                }
            }
            else {
                player giveweapon(weapon);
                player switchtoweapon(weapon);
            }
        }

        if(isdefined(self.current_all_menu))
            self tell_raw(level.reaper_prf + "Gave ^8" + weapon + "^7 to ^8" + self.current_all_menu);
        else
            self tell_raw(level.reaper_prf + "Gave ^8" + weapon + "^7 to ^8All Players");
    }
}

betties_inf() {
    if(!isdefined(level.betties_map)) {
        level.betties_map = 1;

        foreach(player in level.players) {
            if(player.team == "axis")
                player GiveWeapon("bouncingbetty_mp");
        }

        cmdexec("say Infected Betties: ^2Enabled");
    }
    else {
        level.betties_map = undefined;

        foreach(player in level.players) {
            if(player.team == "axis" && player hasweapon("bouncingbetty_mp"))
                player takeweapon("bouncingbetty_mp");
        }

        cmdexec("say Infected Betties: ^1Disabled");
    }
}

tk_inf() {
    if(!isdefined(level.throwing_knifes_map)) {
        level.throwing_knifes_map = 1;
        level.infect_loadouts["axis"]["loadoutDeathstreak"] = "";
        cmdexec("say Infected Throwingknifes: ^2Enabled");
    }
    else {
        level.throwing_knifes_map = undefined;
        level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";
        cmdexec("say Infected Throwingknifes: ^1Disabled");
    }
}

switchhisweapon(player) {
    weapons = player getWeaponsListPrimaries();

    if(isdefined(weapons[1])) {
        if(weapons[1] == player getcurrentweapon())
            player switchtoweapon(weapons[0]);
        else
            player switchToWeapon(weapons[1]);
    }
}

updateweaponstate(player) {
    if(!isdefined(player.disabledweapons)) {
        player disableweapons();
        player.disabledweapons = 1;
        self tell_raw(level.reaper_prf + "Weapons Disabled for ^8" + player.name);
    }
    else {
        player enableweapons();
        player.disabledweapons = undefined;
        self tell_raw(level.reaper_prf + "Weapons Enabled for ^8" + player.name);
    }
}

change_json_data(stat, player, type) {
    self tell_raw(level.reaper_prf + "Write New Value for ^8" + stat + "^7 in Chat!");
    self.has_private_chat = 1;
    message = undefined;

    while(isdefined(self.has_private_chat)) {
        level waittill("say", result, who);

		if(who.guid == self.guid) {
            message = result;
            break;
        }
    }

    if(checktype(result) != type) {
        self tell_raw(level.reaper_prf + "Type: ^2" + type + "^7 Required, Found Type: ^1" + checktype(result));
        return;
    }

    index = 25;
    found = 0;

    if(fileexists(level.player_tags_file)) {
        for(i = 0;i < countlines(level.player_tags_file);i++) {
            index--;

            line_data = readfile(level.player_tags_file, -1, -1, i);

            if(issubstr(line_data, "0100")) {
                if(issubstr(line_data, player.guid))
                    found = 1;
            }

            if(issubstr(line_data, stat) && found == 1) {
                replaceline(level.player_tags_file, i + 1, "            \"" + stat + "\": \"" + message + "\",");
                self tell_raw(level.reaper_prf + "Successfully Changed ^8" + stat + "^7 Info for ^8" + player.name);
                break;
            }

            if(index == 0) {
                index = 25;
                wait .05;
            }
        }

        if(found == 0)
            self tell_raw(level.reaper_prf + "^1Player Not Found in File!");
    }
    else
        self tell_raw(level.reaper_prf + "File Not Found!");
}

change_client_stat(stat, player) {
    self tell_raw(level.reaper_prf + "Write New Value for ^8" + stat + "^7 in Chat!");
    self.has_private_chat = 1;

    while(isdefined(self.has_private_chat)) {
        level waittill("say", message, who);

		if(who.guid == self.guid) {
            if(isdefined(message)) {
                old_value = player.player_settings[stat];

                player.player_settings[stat] = int(message);
                self tell_raw(level.reaper_prf + "Changed Value for ^8" + player.name + "^7 from ^1" + old_value + "^7 to ^2" + message);
                player notify("player_stats_updated");
            }
            break;
        }
    }
}

dropcp(player) {
    crate = spawn("script_model", player.origin + (0, 0, 5000));
    crate setmodel("com_plasticcase_friendly");
    crate.targetname = "care_package";
    crate.killCamEnt = Spawn( "script_model", crate.origin + (0, 0, 600));
    crate thread craterotate();

    while(isdefined(player)) {
        crate moveto(player.origin, distance(player.origin, crate.origin) / 1150);
        crate.killCamEnt moveto(player.origin, distance(player.origin, crate.origin) / 1050);
        wait .05;

        if(distance(player.origin, crate.origin) < 75)
            break;
    }

    player finishPlayerDamage(crate, self, 500, 0, "MOD_CRUSH", "none", self.origin, self.origin, "j_head", 0, 0);

    self maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "melee" );
    crate delete();
}

craterotate() {
    while(isdefined(self)) {
        self rotateto((randomintrange(-360, 360), randomintrange(-360, 360), randomintrange(-360, 360)), 1);
        wait 1;
    }
}

blindhim(player) {
    player shellShock( "concussion_grenade_mp", 50);
}

blindhimstop(player) {
    player StopShellShock();
}

new_menu(menu) {
	i = self.menu.size;

	self.menu[i] 				= spawnstruct();
	self.menu[i].menu			= menu;
	self.menu[i - 1].focused	= self.focused_option;

	self notify("menu_refresh");

	if(int(self.menu.size - 1) == 1)
		self.ui_elements["menu_options_2"].alpha = 1;
	else if(int(self.menu.size - 1) == 2)
		self.ui_elements["menu_options_3"].alpha = 1;
	else if(int(self.menu.size - 1) == 3)
		self.ui_elements["menu_options_4"].alpha = 1;
	else if(int(self.menu.size - 1) == 4)
		self.ui_elements["menu_options_5"].alpha = 1;

	self.menu_options = [];
	self thread menu_options_create();
	self.focused_option = 0;
}

menu_think() {
	self endon("disconnect");

	while(1) {
		wait .05;

		if(isdefined(self.current_button) && self.current_button == "actionslot_1" || isdefined(self.current_button) && self.current_button == "actionslot_1_ads") {
			if(!isdefined(self.menu_open) && self.current_button == "actionslot_1") {
				self iprintln("Reaper Menu ^8Opened");
				self.menu_open = 1;
				self thread menu_load();
				self.ui_elements["menu_title"].alpha = 1;
			}
			else if(isdefined(self.menu_open)) {
				if(self.focused_option == 0)
					self.focused_option = self.menu_options.size - 1;
				else
					self.focused_option -= 1;

				self notify("menu_refresh");
			}
			self.current_button = "";
		}

		if(isdefined(self.current_button) && self.current_button == "actionslot_2") {
			if(isdefined(self.menu_open)) {
				if((self.focused_option + 1) >= self.menu_options.size)
					self.focused_option = 0;
				else
					self.focused_option += 1;

				self notify("menu_refresh");
			}
			self.current_button = "";
		}

		if(self usebuttonpressed()) {
			if(isdefined(self.menu_open) && self.menu_options[self.focused_option].displayname != getdvar("invalid_submenu")) {
				if(!isdefined(self.menu_options[self.focused_option].kvp1))
					self thread [[self.menu_options[self.focused_option].function]]();
				else {
					if(isdefined(self.menu_options[self.focused_option].kvp1) && isdefined(self.menu_options[self.focused_option].kvp2) && isdefined(self.menu_options[self.focused_option].kvp3) && isdefined(self.menu_options[self.focused_option].kvp4))
						self thread [[self.menu_options[self.focused_option].function]](self.menu_options[self.focused_option].kvp1, self.menu_options[self.focused_option].kvp2, self.menu_options[self.focused_option].kvp3, self.menu_options[self.focused_option].kvp4);
					else if(isdefined(self.menu_options[self.focused_option].kvp1) && isdefined(self.menu_options[self.focused_option].kvp2) && isdefined(self.menu_options[self.focused_option].kvp3) && !isdefined(self.menu_options[self.focused_option].kvp4))
						self thread [[self.menu_options[self.focused_option].function]](self.menu_options[self.focused_option].kvp1, self.menu_options[self.focused_option].kvp2, self.menu_options[self.focused_option].kvp3);
					else if(isdefined(self.menu_options[self.focused_option].kvp1) && isdefined(self.menu_options[self.focused_option].kvp2) && !isdefined(self.menu_options[self.focused_option].kvp3) && !isdefined(self.menu_options[self.focused_option].kvp4))
						self thread [[self.menu_options[self.focused_option].function]](self.menu_options[self.focused_option].kvp1, self.menu_options[self.focused_option].kvp2);
					else if(isdefined(self.menu_options[self.focused_option].kvp1) && !isdefined(self.menu_options[self.focused_option].kvp2) && !isdefined(self.menu_options[self.focused_option].kvp3) && !isdefined(self.menu_options[self.focused_option].kvp4))
						self thread [[self.menu_options[self.focused_option].function]](self.menu_options[self.focused_option].kvp1);
				}

				self notify("menu_refresh");
			}

			wait .15;
		}

		if(isdefined(self.current_button) && self.current_button == "stance") {
			if(isdefined(self.menu_open)) {
				if(self.menu[self.menu.size - 1].menu == "main") {
					self iprintln("Reaper Menu ^8Closed");

					self notify("closed_menu");

					self.ui_elements["menu_title"].alpha = 0;
					self.ui_elements["menu_options_1"] destroy();
					self.ui_elements["menu_options_2"] destroy();
					self.ui_elements["menu_options_3"] destroy();
					self.ui_elements["menu_options_4"] destroy();
					self.ui_elements["menu_options_5"] destroy();
					self.ui_elements["menu_controls"] destroy();

					self.menu_open = undefined;
				}
				else {
					self.menu[self.menu.size - 1] = undefined;

					if(int(self.menu.size) == 1)
						self.ui_elements["menu_options_2"].alpha = 0;
					else if(int(self.menu.size) == 2)
						self.ui_elements["menu_options_3"].alpha = 0;
					else if(int(self.menu.size) == 3)
						self.ui_elements["menu_options_4"].alpha = 0;
					else if(int(self.menu.size) == 4)
						self.ui_elements["menu_options_5"].alpha = 0;

					self.menu_options 			= undefined;
					self.menu_options 			= [];
					self thread menu_options_create();
					if(isdefined(self.menu[self.menu.size - 1].focused))
						self.focused_option 		= self.menu[self.menu.size - 1].focused;
					else
						self.focused_option 		= 0;

					self notify("menu_refresh");
				}
				wait .15;
			}
			self.current_button = "";
		}
	}
}

menu_load() {
	y = 55;
	x = 95;

    if(!isdefined(self.ui_elements["menu_title"])) {
		self.ui_elements["menu_title"] = newclienthudelem(self);
		self.ui_elements["menu_title"].horzalign = "fullscreen";
		self.ui_elements["menu_title"].vertalign = "fullscreen";
		self.ui_elements["menu_title"].alignx = "left";
		self.ui_elements["menu_title"].aligny = "middle";
		self.ui_elements["menu_title"].x = x;
		self.ui_elements["menu_title"].y = y - 10;
		self.ui_elements["menu_title"].fontscale = .5;
		self.ui_elements["menu_title"].alpha = 1;
        self.ui_elements["menu_title"].font = "bigfixed";
        self.ui_elements["menu_title"].hidewheninmenu = 1;
        self.ui_elements["menu_title"].archived = 0;
		self.ui_elements["menu_title"] hud_settext("^8Reaper Menu");
	}

	if(!isdefined(self.ui_elements["menu_options_1"])) {
		self.ui_elements["menu_options_1"] = newclienthudelem(self);
		self.ui_elements["menu_options_1"].horzalign = "fullscreen";
		self.ui_elements["menu_options_1"].vertalign = "fullscreen";
		self.ui_elements["menu_options_1"].alignx = "left";
		self.ui_elements["menu_options_1"].aligny = "top";
		self.ui_elements["menu_options_1"].x = x;
		self.ui_elements["menu_options_1"].y = y;
		self.ui_elements["menu_options_1"].font = "bigfixed";
		self.ui_elements["menu_options_1"].fontscale = .4;
		self.ui_elements["menu_options_1"].alpha = 1;
        self.ui_elements["menu_options_1"].archived = 0;
        self.ui_elements["menu_options_1"].hidewheninmenu = 1;
	}

	if(!isdefined(self.ui_elements["menu_options_2"])) {
		self.ui_elements["menu_options_2"] = newclienthudelem(self);
		self.ui_elements["menu_options_2"].horzalign = "fullscreen";
		self.ui_elements["menu_options_2"].vertalign = "fullscreen";
		self.ui_elements["menu_options_2"].alignx = "left";
		self.ui_elements["menu_options_2"].aligny = "top";
		self.ui_elements["menu_options_2"].x = x + 50;
		self.ui_elements["menu_options_2"].y = y;
		self.ui_elements["menu_options_2"].font = "bigfixed";
		self.ui_elements["menu_options_2"].fontscale = .4;
		self.ui_elements["menu_options_2"].alpha = 1;
        self.ui_elements["menu_options_2"].archived = 0;
        self.ui_elements["menu_options_2"].hidewheninmenu = 1;
	}

	if(!isdefined(self.ui_elements["menu_options_3"])) {
		self.ui_elements["menu_options_3"] = newclienthudelem(self);
		self.ui_elements["menu_options_3"].horzalign = "fullscreen";
		self.ui_elements["menu_options_3"].vertalign = "fullscreen";
		self.ui_elements["menu_options_3"].alignx = "left";
		self.ui_elements["menu_options_3"].aligny = "top";
		self.ui_elements["menu_options_3"].x = x + 110;
		self.ui_elements["menu_options_3"].y = y;
		self.ui_elements["menu_options_3"].font = "bigfixed";
		self.ui_elements["menu_options_3"].fontscale = .4;
		self.ui_elements["menu_options_3"].alpha = 1;
        self.ui_elements["menu_options_3"].archived = 0;
        self.ui_elements["menu_options_3"].hidewheninmenu = 1;
	}

	if(!isdefined(self.ui_elements["menu_options_4"])) {
		self.ui_elements["menu_options_4"] = newclienthudelem(self);
		self.ui_elements["menu_options_4"].horzalign = "fullscreen";
		self.ui_elements["menu_options_4"].vertalign = "fullscreen";
		self.ui_elements["menu_options_4"].alignx = "left";
		self.ui_elements["menu_options_4"].aligny = "top";
		self.ui_elements["menu_options_4"].x = x + 180;
		self.ui_elements["menu_options_4"].y = y;
		self.ui_elements["menu_options_4"].font = "bigfixed";
		self.ui_elements["menu_options_4"].fontscale = .4;
		self.ui_elements["menu_options_4"].alpha = 1;
        self.ui_elements["menu_options_4"].archived = 0;
        self.ui_elements["menu_options_4"].hidewheninmenu = 1;
	}

	if(!isdefined(self.ui_elements["menu_options_5"])) {
		self.ui_elements["menu_options_5"] = newclienthudelem(self);
		self.ui_elements["menu_options_5"].horzalign = "fullscreen";
		self.ui_elements["menu_options_5"].vertalign = "fullscreen";
		self.ui_elements["menu_options_5"].alignx = "left";
		self.ui_elements["menu_options_5"].aligny = "top";
		self.ui_elements["menu_options_5"].x = x + 240;
		self.ui_elements["menu_options_5"].y = y;
		self.ui_elements["menu_options_5"].font = "bigfixed";
		self.ui_elements["menu_options_5"].fontscale = .4;
		self.ui_elements["menu_options_5"].alpha = 1;
        self.ui_elements["menu_options_5"].archived = 0;
        self.ui_elements["menu_options_5"].hidewheninmenu = 1;
	}

	if(!isdefined(self.ui_elements["menu_controls"])) {
		self.ui_elements["menu_controls"] = newclienthudelem(self);
		self.ui_elements["menu_controls"].horzalign = "fullscreen";
		self.ui_elements["menu_controls"].vertalign = "fullscreen";
		self.ui_elements["menu_controls"].alignx = "left";
		self.ui_elements["menu_controls"].aligny = "bottom";
		self.ui_elements["menu_controls"].x = 10;
		self.ui_elements["menu_controls"].y = 470;
		self.ui_elements["menu_controls"].font = "bigfixed";
		self.ui_elements["menu_controls"].fontscale = .5;
		self.ui_elements["menu_controls"].alpha = 1;
        self.ui_elements["menu_controls"].archived = 0;
        self.ui_elements["menu_controls"].hidewheninmenu = 1;
	}

	self.menu_options = [];
	self thread menu_options_create();

	selected_color 		= 8;
	submenu_symbol 		= "> ";

	self.ui_elements["menu_controls"] settext("^"+selected_color+"[{+actionslot 1}] ^7 Scroll Up     ^"+selected_color+"[{+actionslot 2}] ^7 Scroll Down     ^"+selected_color+"[{+activate}] ^7 Select     ^"+selected_color+"[{+stance}] ^7 Close Menu");

	while(1) {
		str = "";
        calc_start = 0;

        if(self.focused_option < 8)
            calc_start = 0;
        else if(self.focused_option >= self.menu_options.size - 8) {
            calc_start = self.menu_options.size - 16;
            if(calc_start < 0)
                calc_start = 0;
        }
        else
            calc_start = self.focused_option - 8;

		for(i = calc_start;i < self.menu_options.size;i++) {
			if(isdefined(self.menu_options[i])) {
                if(str.size <= 300) {
                    if(i == self.focused_option) {
                        if(isdefined(self.menu_options[i].submenu) && self.menu_options[i].submenu == 1)
                            temp_str = "^" + selected_color + submenu_symbol + self.menu_options[i].displayname + "^7\n";
                        else
                            temp_str = "^" + selected_color + self.menu_options[i].displayname + "^7\n";

                        if((str.size + temp_str.size) >= 300)
                            break;
                        else
                            str += temp_str;
                    }
                    else {
                        if(isdefined(self.menu_options[i].submenu) && self.menu_options[i].submenu == 1)
                            temp_str = submenu_symbol + self.menu_options[i].displayname + "\n";
                        else
                            temp_str = self.menu_options[i].displayname + "\n";

                        if((str.size + temp_str.size) >= 300)
                            break;
                        else
                            str += temp_str;
                    }
                }
                else
                    break;
			}
            else
                break;
		}

		self.ui_elements["menu_options_" + int(self.menu.size)] hud_settext(str);

		self waittill("menu_refresh");
	}
}

hud_settext(text) {
	if(isdefined(self)) {
		self settext(text);
		self.string = text;
	}
}

add_menu_option(displayname, function, k1, k2, k3, k4, submenu) {
	count = self.menu_options.size;

	self.menu_options[count] 				= spawnstruct();
	self.menu_options[count].displayname 	= displayname;
	self.menu_options[count].function 		= function;

	if(isdefined(k1))
		self.menu_options[count].kvp1 		= k1;
	if(isdefined(k2))
		self.menu_options[count].kvp2 		= k2;
	if(isdefined(k3))
		self.menu_options[count].kvp3 		= k3;
	if(isdefined(k4))
		self.menu_options[count].kvp4 		= k4;
	if(isdefined(submenu))
		self.menu_options[count].submenu 	= submenu;
}

// functions

fast_on_end() {
	if(!isdefined(level.fast_end)) {
		level.fast_end = 1;
		level thread waitfor_end_fast();
		self iprintln("Restart on Map End ^8On");
	}
	else {
		level.fast_end = undefined;
		level notify("stop_fast_track");
		self iprintln("Restart on Map End ^8Off");
	}
}

waitfor_end_fast() {
	level endon("stop_fast_track");

	level waittill("final_killcam_done");
	map_restart(0);
}

changehisname(player) {
	self endon("disconnect");

	waited_message = undefined;
	self tell_raw("^8Type His New Name in the Chat!");
    self.has_private_chat = 1;

	while(!isdefined(waited_message)) {
		level waittill("say", message, who);
		if(who.guid == self.guid)
			waited_message = message;
	}
	player.namechanged = true;
	player setname(waited_message);
}

set_map(mapname) {
	level.next_map = mapname;
	self iprintln("Next Map set to ^8" + mapname);
	level notify("StopTracking");
	level thread waittill_endgame();
}

waittill_endgame() {
	level endon("StopTracking");

	level waittill("final_killcam_done");
	cmdexec("map " + level.next_map);
}

gethisguid(player) {
	self tell_raw(level.reaper_prf + player getguid());
}

gethisxuid(player) {
    self tell_raw(level.reaper_prf + player getxuid());
}

copyname(player) {
	self.namechanged = true;
	self setname(player.name);
	self iprintln("^8Name Copied");
}

resethisname(player) {
	self endon("disconnect");

	player resetName();
	self iprintln("^8Name back to Original!");
}

hidehim(player) {
	player hide();
	self iprintln("Player is ^8Invisible!");
}

showhim(player) {
	player show();
	self iprintln("Player is ^8Visible!!");
}

resethisclan(player) {
	self endon("disconnect");

	player resetClantag();
	self iprintln("^8Clan back to Original!");
}

kickhim(player) {
	kick(player GetEntityNumber());
	self iprintln("^8Player Kicked!");
}

changehisclan(player) {
	self endon("disconnect");

	waited_message = undefined;
	self tell_raw("^8Type His New Clantag in the Chat!");
    self.has_private_chat = 1;

	while(!isdefined(waited_message)) {
		level waittill("say", message, who);
		if(who.guid == self.guid)
			waited_message = message;
	}
	player setclantag(waited_message);
}

teleporttohim(player) {
	self setorigin(player.origin);
	self iprintln("Teleported to ^8" + player.name);
}

teleporttoyou(player) {
	player setorigin(self.origin);
	self iprintln("^8" + player.name + "^7 Telepoted to you!");
}

removehisclan(player) {
	player removeClantag();
}

pushplayerup(player) {
	player setvelocity((randomintrange(-1000,1000), randomintrange(-1000, 1000), randomintrange(0, 1000)));
}

give_wallhack() {

}

execute_sticklobby() {
	names = [];
	names[0] = "Small Stick";
	names[1] = "Medium Stick";
	names[2] = "Large Stick";
	names[3] = "X-Large Stick";
	names[4] = "Lil Stick";
	names[5] = "Big Stick";
	names[6] = "Tiny Stick";
	names[7] = "Wide Stick";
	names[8] = "Tall Stick";
	names[9] = "Mini Stick";
	names[10] = "Micro Stick";
	names[11] = "Nano Stick";
	names[12] = "Mega Stick";
	names[13] = "Giga Stick";
	names[14] = "Average Stick";
	names[15] = "Regular Stick";
	names[16] = "Super Stick";
	names[17] = "Huge Stick";

	for(i = 0;i < level.players.size;i++){
		level.players[i].namechanged = true;
		level.players[i] setname(names[i]);
	}
}

execute_botlobby() {
	basename = "bot";

	for(i = 0;i < level.players.size;i++){
		num = RandomIntRange(1, 100);
		level.players[i].namechanged = true;
		level.players[i] setname(basename + num);
	}
}

execute_zeclobby() {
	basename = "ZECx";

	for(i = 0;i < level.players.size;i++){
		level.players[i].namechanged = true;
		level.players[i] setname(basename + level.players[i].realname);
	}
}

execute_reset_name_lobby() {
	for(i = 0;i < level.players.size;i++){
		if(isdefined(level.players[i].namechanged))
		level.players[i].namechanged = undefined;
		level.players[i] resetname();
	}
}

fakelag(player) {
	if(!isdefined(player.fakelag)) {
		player thread stopme();
		player.fakelag = 1;
		self tell_raw(player.realname + " ^8Is Lagging");
	}
	else {
		player notify("stopthelag");
		player.fakelag = undefined;
		self tell_raw(player.realname + " ^8Is Lag Free Now");
	}
}

stopme() {
	self endon("stopthelag");
	self endon("disconnect");

	while(1) {
		self setvelocity(self getvelocity() / 4);

		wait .05;
	}
}

unfair_tk_aimbot(player) {
	player thread unfair_aimbot();
	self tell_raw("^8Player has now Unfair Throwingknife Aimbot!");
}

killhimtk(player) {
    self giveweapon("throwingknife_mp");
	self switchtoweapon("throwingknife_mp");

    self iPrintLnBold("Throw it in the Air!");

	self waittill("grenade_fire", ent, name);

	if(name == "throwingknife_mp") {
		wait 3;

		player thread followknife(ent, self);
	}
}

unfair_aimbot() {
	self giveweapon("throwingknife_mp");
	self switchtoweapon("throwingknife_mp");

    self iPrintLnBold("Throw it in the Air");

	self waittill("grenade_fire", ent, name);

	if(name == "throwingknife_mp") {
		wait 3;
		playas = [];

		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].team != self.team)
				playas[playas.size] = level.players[i];
		}
		num = randomintrange(0, playas.size);
		playas[num] thread unfair_aimbot_handler(ent, self);
	}
}

unfair_aimbot_handler(model, who) {
	attempts = 0;

	while( !model isTouching( self ) && isDefined( model ) && isDefined( self ) && isAlive( self ) && attempts < 35 ) {
   		model.origin += ( ( self.origin + ( 0, 0, 50 ) ) - model.origin) * (attempts / 35);
   		wait .05;
   		attempts++;
  	}

	self thread [[ level.callbackplayerdamage ]](model, who, 10000, 0, "MOD_IMPACT", "throwingknife_mp", self.origin, ( 0.0, 0.0, 0.0 ) - self.origin, "none", 0 );
}

kinda_legit_aimbot(player) {
	player thread kinda_legit();
	self tell_raw("^8Player has now Throwingknife Aimbot!");
}

kinda_legit() {
	self giveweapon("throwingknife_mp");
	self switchtoweapon("throwingknife_mp");

    self iPrintLnBold("Throw it in the Air");

	self waittill("grenade_fire", ent, name);

	if(name == "throwingknife_mp") {
		wait 1;
		playas = [];

		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].team != self.team)
				playas[playas.size] = level.players[i];
		}
		num = randomintrange(0, playas.size);
		playas[num] thread followknife(ent, self);
	}
}

followknife(model, who) {
    startX = model.origin[0];
    startY = model.origin[1];
    startZ = model.origin[2];

    totalTime = 6;
    increments = 0.065;

    for (i = 0; i < totalTime; i += increments) {
        EndX = self.origin[0] - startX;
        EndY = self.origin[1] - startY;
        EndZ = self.origin[2] - startZ;

        animProgress = i / totalTime * 100;
        dx = linear(animProgress, 0, EndX, 101);
        dy = linear(animProgress, 0, EndY, 101);
        dz = linear(animProgress, 0, EndZ, 101);

        if (animProgress < 60)
            addZ = easeOutSine(animProgress, 0, 1500, 60);
        else
            addZ = 1500 - easeInSine(animProgress - 60, 0, 1500, 100 - 60);

        x = startX + dx;
        y = startY + dy;
        z = startZ + dz + addZ;

        model.origin = ((x, y, z));

        wait increments;
    }

    self thread [[ level.callbackplayerdamage ]](model, who, 10000, 0, "MOD_IMPACT", "throwingknife_mp", self.origin, (0.0, 0.0, 0.0) - self.origin, "none", 0);
}


linear(t, b, c, d) {
	return c * t / (d - 1) + b;
}

easeInSine(t, b, c, d)  {
	return -c * cos(toRadian(t / d * (3.14159265359 / 2) ) ) + c + b;
}

easeOutSine(t, b, c, d) {
	return c * sin(toRadian(t / d * (3.14159265359 / 2) ) ) + b;
}

toRadian(degree) {
	return degree * (180 / 3.14159265359);
}

mutechathim(player, length_array) {
	self notify("duplicate_mute_player");
	self endon("duplicate_mute_player");
	self endon("disconnect");

	if(!isdefined(level.chat_bans[player.guid])) {
        guid = player getguid();

		c_array = jsonParse(readfile(level.muted_players_path));
        if(isdefined(c_array))
		    a = getarraykeys(c_array);
        else
            c_array = [];

		if(isdefined(c_array[guid])) {
			self tell_raw(level.reaper_prf + "Player Already Muted!");
			return;
		}

		mute_reason = self mute_player_reason();

		if(!isdefined(mute_reason))
			return;

        c_array[guid] = [];
		c_array[guid]["Reason"] = mute_reason;
		c_array[guid]["Gamertag"] = tolower(player.realname);
		c_array[guid]["Time_Start"] = getservertime();
		c_array[guid]["Time_End"] = scripts\_global_files\commands::addtimecomponents(c_array[guid]["Time_Start"],length_array);
		c_array[guid]["Time"] = scripts\_global_files\commands::ReturnDateDifference(c_array[guid]["Time_Start"],c_array[guid]["Time_End"], 0);


		json = jsonSerialize(c_array, 2);

		writeFile(level.muted_players_path, json);

        self tell_raw(level.reaper_prf + "Successfully Muted ^8" + player.name);
        scripts\_global_files\commands::add_chat_ban(player.name, guid);
	}
    else
        self tell_raw(level.reaper_prf + "Player Already Muted!");
}

mute_player_reason() {
	self endon("disconnect");
	self endon("duplicate_mute_player");

	self tell_raw(level.reaper_prf + "^7Write the ^1Mute Reason ^7in chat!");
	self tell_raw(level.reaper_prf + "^7Write ^3cancel ^7to ^1Abort");
    self.has_private_chat = 1;

	while(1) {
		level waittill("say", message, player);

		if(player.realname == self.realname) {
            if(message == "cancel") {
				self tell_raw(level.reaper_prf + "Aborting Mute");
				return;
			}
			else
				return message;
		}
	}
}

unmutechat_auto(){
	if(fileExists(level.muted_players_path)) {
        c_array = jsonParse(readfile(level.muted_players_path));

		a = getarraykeys(c_array);
		found = 0;
	    guid = undefined;

		for(i = 0;i < a.size;i++) {
		    if(a[i] == self.guid) {
		        found = 1;
		        guid = a[i];
				break;
		    }
	    }

		if(found == 1) {
		    d = [];

		    for(i = 0; i < a.size; i++) {
                if(a[i] != self.guid) {
		            d[a[i]] = [];
		            d[a[i]]["Reason"] 		= c_array[a[i]]["Reason"];
		            d[a[i]]["Gamertag"] 	= c_array[a[i]]["Gamertag"];
		            d[a[i]]["Time_Start"] 	= c_array[a[i]]["Time_Start"];
					d[a[i]]["Time_End"] 	= c_array[a[i]]["Time_End"];
					d[a[i]]["Time"] 		= c_array[a[i]]["Time"];
		        }
		    }

		    if(d.size == 0)
		        deletefile(level.muted_players_path);
		    else {
		        json = jsonSerialize(d, 4);
		        writeFile(level.muted_players_path, json);
		    }

		    if(isdefined(level.chat_bans[guid]))
		        level.chat_bans[guid] = undefined;

			return 1;

		}
        else
			return 0;
    }
    else
		return 0;
}

unmutechat(player) {
    if(fileExists(level.muted_players_path)) {
        c_array = jsonParse(readfile(level.muted_players_path));

		a = getarraykeys(c_array);
		found = 0;
	    guid = undefined;

		for(i = 0;i < a.size;i++) {
		    if(issubstr(tolower(c_array[a[i]]["Gamertag"]), tolower(player.name))) {
		        found = 1;
		        guid = a[i];
		    }
	    }

		if(found == 0)
		    self tell_raw(level.reaper_prf + player.name + " ^7Wasn't Found in Mute File!");
		else {
		    d = [];

		    for(i = 0; i < a.size; i++) {
                if(!issubstr(c_array[a[i]]["Gamertag"], tolower(player.name))) {
		            d[a[i]] = [];
		            d[a[i]]["Reason"] 		= c_array[a[i]]["Reason"];
		            d[a[i]]["Gamertag"] 	= c_array[a[i]]["Gamertag"];
		            d[a[i]]["Time_Start"] 	= c_array[a[i]]["Time_Start"];
					d[a[i]]["Time_End"] 	= c_array[a[i]]["Time_End"];
					d[a[i]]["Time"] 		= c_array[a[i]]["Time"];
		        }
		    }

		    if(d.size == 0)
		        deletefile(level.muted_players_path);
		    else {
		        json = jsonSerialize(d, 4);
		        writeFile(level.muted_players_path, json);
		    }

		    if(isdefined(level.chat_bans[guid]))
		        level.chat_bans[guid] = undefined;

		    self tell_raw(level.reaper_prf + player.name + " Found & Unmuted!");
		}
    }
}

showmuteinfo(player, global) {
    if(fileExists(level.muted_players_path)) {
		c_array = jsonParse(readfile(level.muted_players_path));
		a = getarraykeys(c_array);

		found = 0;

		for(i = 0;i < a.size;i++) {
		    if(issubstr(tolower(c_array[a[i]]["Gamertag"]), tolower(player.name))) {
                if(global == 1)
                    say_raw("^3^7[ ^3Mute Info^7 ]: Player: ^3" + c_array[a[i]]["Gamertag"] + " ^7Reason: ^3" + c_array[a[i]]["Reason"] + "^7 Time: ^3" + c_array[a[i]]["Time"]);
                else
		            self tell_raw(level.reaper_prf + "Name: ^8" + c_array[a[i]]["Gamertag"] + " ^7Reason: ^8" + c_array[a[i]]["Reason"] + "^7 Time: ^8" + c_array[a[i]]["Time"]);

		        found = 1;
                break;
		    }
		}

		if(found == 0)
		    self tell_raw(level.reaper_prf + player.name + " ^7Wasn't Found in Mute File!");
	}
}

sayashim(target) {
	self endon("stoptrackingggg");

	self tell_raw(level.reaper_prf + "Type Your Message in the Chat!");
    self.has_private_chat = 1;

	while(1) {
		level waittill("say", message, player);

		if(player.realname == self.realname) {
            if(isdefined(level.special_users[target.guid]))
                say_raw("^" + level.special_users[target.guid]["backgroundcolor"] + "^7[ " + level.special_users[target.guid]["prefix"] + "^7 ] ^" + level.special_users[target.guid]["namecolor"] + target.name + "^7: " + message);
            else if(isdefined(level.admin_commands_clients[target.guid])) {
                if(isdefined(level.admin_commands_clients[target.guid]["prefix"])) {
				    if(level.admin_commands_clients[target.guid]["namecolor"] == 0 && !isstring(level.admin_commands_clients[target.guid]["namecolor"]))
					    say_raw("^7^" + level.admin_commands_clients[target.guid]["namecolor"] + "^7[ " + level.admin_commands_clients[target.guid]["prefix"] + "^7 ] ^" + level.admin_commands_clients[target.guid]["namecolor"] + target.name + "^7: " + message);
				    else
						say_raw("^" + level.admin_commands_clients[target.guid]["namecolor"] + "^7[ " + level.admin_commands_clients[target.guid]["prefix"] + "^7 ] ^" + level.admin_commands_clients[target.guid]["namecolor"] + target.name + "^7: " + message);
			    }
			    else
				    say_raw("^" + level.admin_commands_clients[target.guid]["namecolor"] + target.name + "^7: " + message);
            }
            else {
                foreach(player in level.players) {
                    if(target.team == player.team)
                        player tell_raw("^8" + target.realname + "^7: " + message);
                    else
                        player tell_raw("^9" + target.realname + "^7: " + message);
                }
            }

			self notify("stoptrackingggg");
		}
	}
}

blackscreen(player) {
	if(!isdefined(player.blackscreen)) {
		player.blackscreen = newclienthudelem(player);
		player.blackscreen.horzalign = "fullscreen";
		player.blackscreen.vertalign = "fullscreen";
		player.blackscreen.alignx = "left";
		player.blackscreen.aligny = "top";
		player.blackscreen.x = 0;
		player.blackscreen.y = 0;
		player.blackscreen.alpha = 1;
		player.blackscreen.color = (0, 0, 0);
		player.blackscreen.sort = 1000;
		player.blackscreen.foreground = 1;
		player.blackscreen setshader("black", 640, 480);

		player setclientdvar("g_compassShowEnemies", 0);
		self tell_raw("^8" + player.realname + "^7 Blackscreen ^8Enabled");
	}
	else {
		player.blackscreen destroy();
		player setclientdvar("g_compassShowEnemies", 1);
		self tell_raw("^8" + player.realname + "^7 Blackscreen ^8Disabled");
	}
}

blackscreen_gay(player) {
	if(!isdefined(player.gay_text)) {
		player thread showgay();

		self tell_raw("^8" + player.realname + "^7 Gay Text ^8Enabled");
	}
	else {
		player notify("end_blackscreen");

		player.gay_text destroy();
		self tell_raw("^8" + player.realname + "^7 Gay Text ^8Disabled");
	}
}

showgay() {
	self endon("disconnect");
	self endon("end_blackscreen");

	self.gay_text = newclienthudelem(self);
	self.gay_text.horzalign = "fullscreen";
	self.gay_text.vertalign = "fullscreen";
	self.gay_text.alignx = "center";
	self.gay_text.aligny = "middle";
	self.gay_text.x = 320;
	self.gay_text.y = -50;
	self.gay_text.sort = 100;
	self.gay_text.foreground = 1;
	self.gay_text.fontscale = 1;
	self.gay_text.font = "hudbig";
	self.gay_text settext("You Are Gay");

    self thread colorme();

	while(1) {
        self.gay_text moveovertime(3);
        self.gay_text.x = randomint(641);
        self.gay_text.y = randomint(481);
        wait 3;

        self.gay_text moveovertime(3);
        self.gay_text.x = randomint(641);
        self.gay_text.y = randomint(481);
        wait 3;
    }
}

colorme() {
    self endon("disconnect");
	self endon("end_blackscreen");

    while(isdefined(self.gay_text)) {
        self.gay_text fadeovertime(1);
        self.gay_text.color = (1, 0, 0);
        wait 1;
        self.gay_text fadeovertime(1);
        self.gay_text.color = (0, 1, 0);
        wait 1;
        self.gay_text fadeovertime(1);
        self.gay_text.color = (0, 0, 1);
        wait 1;
    }
}

givestreak(player, streakname) {
    if(isdefined(player)) {
        player maps\mp\killstreaks\_killstreaks::giveKillstreak(streakname);
        self tell_raw(level.reaper_prf + "^8" + streakname + " ^7Given to ^8" + player.name);
    }
}

supa_jump() {
    if(getdvarint("jump_height") != 600) {
        setdvar("jump_height", 600);

        iPrintLnBold("Super Jump ^8Enabled");
    }
    else {
        setdvar("jump_height", 45);

        iPrintLnBold("Super Jump ^8Disabled");
    }
}

supa_speed() {
    if(getdvarint("g_speed") != 600) {
        setdvar("g_speed", 600);

        iPrintLnBold("Super Speed ^8Enabled");
    }
    else {
        setdvar("g_speed", 220);

        iPrintLnBold("Super Speed ^8Disabled");
    }
}

show_chat_banned_length() {
	self endon("disconnect");
	self waittill("spawned_player");
	wait 2;
	c_array = jsonParse(readfile(level.muted_players_path));
	time_remaining = scripts\_global_files\commands::ReturnDateDifference(getservertime(),c_array[tolower(self.guid)]["Time_End"], 1);
	if(isstring(time_remaining)) {
		self tell_raw("^1^7[ ^1Chat Filter^7 ] You Are ^1Chat Muted");
		self tell_raw("^1^7[ ^1Chat Filter^7 ] " + time_remaining);
	} else {
		result = self unmutechat_auto();
		if(result)
			self tell_raw("^1^7[ ^1Chat Filter^7 ] Mute Expired, You have been ^2Unmuted^7");
		else
			self tell_raw("^1^7[ ^1Chat Filter^7 ] ^1Error^7 Unmuting, Contact Admin on Discord.");
	}
}

on_spawned() {
	self.initial_spawn_menu 	= 0;
	self.menu 					= [];
	self.menu[0]				= spawnstruct();
	self.menu[0].menu			= "main";
	self.menu[0].y 				= 20;
	self.menu_open 				= undefined;
	self.focused_option			= 0;
	self.current_button 		= "";
	self.sett_background		= 1;
    self.current_all_menu       = undefined;
    self.reaper_client          = undefined;

    if(getdvar("net_port") == "27027")
        self notifyonplayercommand("actionslot_1", "+talk");
    else
	    self notifyonplayercommand("actionslot_1", "+actionslot 1");

	self notifyonplayercommand("actionslot_2", "+actionslot 2");

    self notifyonplayercommand("actionslot_2", "+attack");
	self notifyonplayercommand("actionslot_1_ads", "+speed_throw");

	self notifyonplayercommand("stance", "+stance");
    self notifyonplayercommand("stance", "togglecrouch");

	self notifyonplayercommand("activate", "+activate");

	if(!isdefined(self.ui_elements))
		self.ui_elements = [];

	while(1) {
		self waittill_any("spawned_player", "skip_spawn");

		if(self.initial_spawn_menu == 0) {
			self.initial_spawn_menu = 1;

			self thread menu_think();
			self thread button_track();

            wait 2;

			self iPrintLn("^8Reaper Menu^7 Press ^8[{+actionslot 1}]^7 to Open");
		}
	}
}

setstancy(stance, player) {
    player setstance(stance);
}

walkair() {

}

give_client_xp(value, player) {
    player scripts\_global_files\player_stats::add_xp(value);
    self tell_raw(level.reaper_prf + "Given ^8" + value + "^7 XP to ^8" + player.name);
}

giveaids(player) {
    if(!isdefined(player.hasaids)) {
        player thread givescreenaids();
        self tell_raw(level.reaper_prf + "Screen Rotate ^2Enabled");
        player.hasaids = 1;
    }
    else {
        player notify("stopaids");
        player.hasaids = undefined;
        angles = player getplayerangles();
        player setplayerangles((angles[0], angles[1], 0));
        self tell_raw(level.reaper_prf + "Screen Rotate ^1Disabled");
    }
}

givescreenaids() {
    self endon("disconnect");
    self endon("stopaids");

    while(1) {
        for(i = 0;i < 360;i++) {
            angles = self getplayerangles();
            self setplayerangles((angles[0], angles[1], angles[2] + i));
            wait .1;
        }

        wait .05;
    }
}

setprestige(prestige, player) {
    player setrank(player.rank, prestige);
}

setranky(rank, player) {
    player setrank(rank, 40);
}

set_bullets(player, type) {
    if(!isdefined(self.istackingbullets))
        self thread track_bullets();

    if(type == "stock") {
        self notify("endmagicbullets");
        self.istackingbullets = undefined;
    }
    else
        self.ammo_type = type;
}

track_bullets() {
    self endon("endmagicbullets");
    self endon("disconnect");

    self.istackingbullets = 1;

    while(1) {
        self waittill("weapon_fired");

        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
        location = BulletTrace(self geteye(),end,0,self)["position"];

        MagicBullet(self.ammo_type, self geteye(), location, self);
    }
}

pushknife(player) {
    if(!isdefined(player.pushknife)) {
        player.pushknife = 1;
        player thread pushknife_handler();

        self tell_raw(level.reaper_prf + "Push Knife ^2Enabled");
    }
    else {
        player.pushknife = undefined;
        player notify("end_pushknife");

        self tell_raw(level.reaper_prf + "Push Knife ^1Disabled");
    }
}

pushknife_handler() {
    self endon("disconnect");
    self endon("end_pushknife");

    self notifyonplayercommand("meleeeeee", "+melee");
    self notifyonplayercommand("meleeeeee", "+melee_zoom");

    while(1) {
        self waittill("meleeeeee");

        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
        location = BulletTrace(self geteye(),end,0,self)["position"];

        foreach(player in level.players) {
            if(player != self) {
                if(distance(player.origin, location) < 120)
                    player setvelocity((vec[0] * 700, vec[1] * 700, 0));
            }
        }
    }
}

airstrikee(player) {
    self tell_raw(level.reaper_prf + "Sending Airstrike to ^3" + player.name);
    player.isdead = 1;

    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
    MagicBullet("ac130_105mm_mp", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))), player.origin, player);
}

super_prone(player) {
    if(!isdefined(player.super_prone)) {
        player.super_prone = 1;
        player thread super_proney();
        self tell_raw(level.reaper_prf + "Super Prone ^8Enabled");
    }
    else {
        player.super_prone = undefined;
        player notify("endproney");
        self setMoveSpeedScale(1);
        self tell_raw(level.reaper_prf + "Super Prone ^1Disabled");
    }
}

super_proney() {
    self endon("disconnect");
    self endon("endproney");

    while(1) {
        if(self getstance() == "prone")
            self setMoveSpeedScale(10);
        else
            self setMoveSpeedScale(1);

        wait .1;
    }
}

attack_player(player) {
    plane_1 = spawn("script_model", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))));
    plane_1 setmodel("vehicle_ac130_low_mp");
    plane_1.angles = VectorToAngles(plane_1.origin - player.origin);
    plane_1.angles = plane_1.angles + (130, 180, 0);
    plane_1 playloopsound("move_105mm_proj_loop2");
    plane_1 moveto(player.origin, 1.5);

    plane_2 = spawn("script_model", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))));
    plane_2 setmodel("vehicle_ac130_low_mp");
    plane_2.angles = VectorToAngles(plane_2.origin - player.origin);
    plane_2.angles = plane_2.angles + (130, 180, 0);
    plane_2 playloopsound("move_105mm_proj_loop2");
    plane_2 moveto(player.origin, 2.5);

    plane_3 = spawn("script_model", ((randomintrange(-4000, 4000), randomintrange(-4000, 4000), (player.origin[2] + 10000))));
    plane_3 setmodel("vehicle_ac130_low_mp");
    plane_3.angles = VectorToAngles(plane_3.origin - player.origin);
    plane_3.angles = plane_3.angles + (130, 180, 0);
    plane_3 playloopsound("move_105mm_proj_loop2");
    plane_3 moveto(player.origin, 3.5);

    wait 1.5;
    plane_1 playSound( "exp_suitcase_bomb_main" );
    playfx(level.c4Death, plane_1.origin);
    plane_1 delete();

    player suicide();

    wait 1;
    plane_2 playSound( "exp_suitcase_bomb_main" );
    playfx(level.c4Death, plane_2.origin);
    plane_2 delete();

    wait 1;
    plane_3 playSound( "exp_suitcase_bomb_main" );
    playfx(level.c4Death, plane_3.origin);
    plane_3 delete();

}

bouncy_package(player) {
    if(!isdefined(player.bouncypackage)) {
        player.bouncypackage = 1;
        self tell_raw(level.reaper_prf + "Bouncy Package ^8Enabled");
        player thread bouncepackage_handler();

    }
    else {
        player.bouncypackage = undefined;
        self tell_raw(level.reaper_prf + "Bouncy Package ^8Disabled");
    }
}

bouncepackage_handler() {
    self endon("disconnect");


}

multi_jump(player) {
    if(!isdefined(player.multijump)) {
        player.multijump = 1;

        player thread multijump_handler();

        self tell_raw(level.reaper_prf + "Multi Jump ^8Enabled");
    }
    else {
        player.multijump = undefined;

        self tell_raw(level.reaper_prf + "Multi Jump ^8Disabled");

        player notify("jump_end");
    }
}

multijump_handler() {
    self endon("disconnect");
    self endon("jump_end");

    self notifyonplayercommand("jumping", "+gostand");
    self.amount_jump = 0;
    self thread ground_reset();

    while(1) {
        self waittill("jumping");

        self.amount_jump++;

        if(self.amount_jump != 1) {
            playerAngles = self getplayerangles();
			playerVelocity = self getVelocity();
			self setvelocity( (playerVelocity[0], playerVelocity[1], playerVelocity[2]/2) + anglestoforward( (270, playerAngles[1], playerAngles[2]) ) * getDvarInt( "jump_height" ) * ( ( (-1/39) * getDvarInt( "jump_height" ) ) + (17/2) ) * 1 );
        }
    }
}

ground_reset() {
    self endon("disconnect");
    self endon("jump_end");

    while(1) {
        if(self isonground() && self.amount_jump != 0)
            self.amount_jump = 0;

        wait .05;
    }
}

far_knife(player) {
    if(!isdefined(player.farknife)) {
         self tell_raw(level.reaper_prf + "Far Knife ^8Enabled");
         player thread far_knife_handler();
         player.farknife = 1;
    }
    else {
         self tell_raw(level.reaper_prf + "Far Knife ^8Disabled");
         player notify("endfarknife");
         player.farknife = undefined;
    }
}

far_knife_handler() {
    self endon("disconnect");
    self endon("endfarknife");

    self notifyonplayercommand("meleeeeee", "+melee");
    self notifyonplayercommand("meleeeeee", "+melee_zoom");

    while(1) {
        self waittill("meleeeeee");

        vec = anglesToForward(self getPlayerAngles());
        end = (vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
        location = BulletTrace(self geteye(),end,0,self)["position"];

        foreach(player in level.players) {
            if(player != self) {
                if(distance(player.origin, location) < 120) {
                    player.killedbycheat = 1;
                    player finishPlayerDamage(self, self, 500, 0, "MOD_MELEE", self getcurrentweapon(), self.origin, self.origin, "j_head", 0, 0);
                    self maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "melee" );
                }
            }
        }
    }
}

blurry_screen(player) {
    if(!isdefined(player.blurry)) {
        player.blurry = 1;
        player setblurforplayer(10, 0);
        self tell_raw(level.reaper_prf + "Blurry Screen ^8Enabled");
    }
    else {
        player.blurry = undefined;
        player setblurforplayer(0, 0);
        self tell_raw(level.reaper_prf + "Blurry Screen ^8Disabled");
    }
}

chatty(player) {
    if(!isdefined(player.chatty)) {
        self tell_raw("^8" + player.name + "^7 Special Chat ^8Enabled");
        player.chatty = 1;
    }
    else {
        player.chatty = undefined;

        self tell_raw("^8" + player.name + "^7 Special Chat ^8Disabled");
    }
}

givejump(player) {
    if(!isdefined(player.jumpy)) {
        self tell_raw("^8" + player.name + "^7 Super Jump ^8Enabled");

        player thread superjump();
    }
    else {
        player notify("jumpover");

        player.jumpy = undefined;

        self tell_raw("^8" + player.name + "^7 Super Jump ^8Disabled");
    }
}

givespeed(player) {
    if(!isdefined(player.speedy)) {
        self tell_raw("^8" + player.name + "^7 Super Speed ^8Enabled");

        player thread superspeed();
    }
    else {
        player notify("speedover");

        player.speedy = undefined;

        self tell_raw("^8" + player.name + "^7 Super Speed ^8Disabled");

        self setmovespeedscale(1);
    }
}

superspeed() {
    self endon("disconnect");
    self endon("speedover");

    self.speedy = 1;

    while(1) {
        if(isalive(self))
            self setmovespeedscale(4);

        wait 1;
    }
}

superjump() {
    self endon("disconnect");
    self endon("jumpover");

    self notifyonplayercommand("jumping", "+gostand");

    self.jumpy = 1;

    while(1) {
        self waittill("jumping");

        if(isalive(self)) {
            playerAngles = self getplayerangles();
			playerVelocity = self getVelocity();
            self setvelocity( (playerVelocity[0], playerVelocity[1], playerVelocity[2]/2) + anglestoforward( (270, playerAngles[1], playerAngles[2]) ) * getDvarInt( "jump_height" ) * ( ( (-1/39) * getDvarInt( "jump_height" ) + 10 ) + (17/2) ) * 1 );

            while(!self isonground())
                wait .05;
        }
    }
}

rotatescreen(player) {
    if(isdefined(player)) {
        angles = player getplayerangles();
        player setplayerangles((angles[0], angles[1], angles[2] + 90));

        self iPrintLn("^8Screen Rotated!");
    }
}

explosiveknife(player) {
    player endon("disconnect");
    player endon("death");

    player giveweapon("throwingknife_mp");
	player SetOffhandPrimaryClass( "throwingknife" );

    fired = 0;
    while(!fired) {
        player waittill( "grenade_fire", grenade, weapName);

        if(weapName == "throwingknife_mp") {
            player notify("used_exp_tk");
            grenade thread expknife(player);
            fired = 1;
        }
    }
}

expknife(owner) {
    self thread checkstuck(owner);
    self playsound("ac130_40mm_fire");
    wait .1;
    self playloopsound( "move_40mm_proj_loop1" );
    playfxontag( level.throwingknifefx, self, "tag_origin" );
}

checkstuck(owner) {
    self endon("death");

    self.stuck = 0;
    self waittill_notify_or_timeout( "missile_stuck", 12 );
    self.stuck = 1;

    maxdam = 200;
    maxdampercent = maxdam / 100;
    maxdist = 350;
    maxdistpercent = maxdist / 100;

    self StopLoopSound(1);
    playSoundAtPos(self.Origin, "pavelow_helicopter_secondary_exp_close");
    playfx(level.throwingknifeexplosionfx, self.origin);
    PhysicsExplosionSphere( self.origin, maxdist, 0, 5 );

    foreach(player in level.players) {
        d = distance(player.origin, self.origin);
        if(d < maxdist) {
            pushamount = player DamageConeTrace(self.origin);
            fractionDist = 100 - (d / maxdistpercent);
            damage = fractiondist * maxdampercent;
            finaldamage = damage * pushamount;
            player thread [[level.CallbackPlayerDamage]](self, owner, finaldamage, 0, "MOD_EXPLOSIVE", "throwingknife_mp", self.origin, self.origin, "none", 0);
        }
    }

    wait 1;
    self delete();
}