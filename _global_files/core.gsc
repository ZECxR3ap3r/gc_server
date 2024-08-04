#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include scripts\_global_files\commands;

// Dont Touch unless you are ZEC

// Test Penis

init() {
    precachestatusicon("cardicon_weed");
    precachestatusicon("cardicon_prpurchase_1");
    precachestatusicon("iw5_cardicon_devil");
    precachestatusicon("iw5_cardicon_gargoyle");
    precachestatusicon("iw5_cardicon_fly");
	precachestatusicon("iw5_cardicon_cat");

	setdvar("sv_cheats", 0);

    string = "";
    string += tolower("01000000000783F3");

    setdvar("sv_mutedplayers", string);

    onPlayerSay(::chat_handler);

    level.data_path                     = getdvar("fs_homepath") + "/server_data/";
	level.file_commands                 = getDvar("fs_homepath") + "chatlistener.txt";
    level.player_tags_file              = "C:/Servers/IW4mAdmin/Configuration/player_tags.json";

    level.special_users                 = [];
    level.team_vip_data                 = [];
    level.admin_commands_clients        = [];

    add_forbidden_word("nazi", 0);
    add_forbidden_word("nig", 0);
    add_forbidden_word("igger", 0);
    add_forbidden_word("gger", 0);
    add_forbidden_word("nigg", 1);
    add_forbidden_word("coon", 1);
    add_forbidden_word("n i g", 1);
    add_forbidden_word("n ig", 1);
    add_forbidden_word("ni g", 1);
    add_forbidden_word("n1g", 1);
    add_forbidden_word("sieg", 1);
    add_forbidden_word("heil", 1);
    add_forbidden_word("hitler", 1);
    add_forbidden_word("coomer", 1);
    add_forbidden_word("nagger", 1);
    add_forbidden_word("faggot", 1);
    add_forbidden_word("fag", 1);
    add_forbidden_word("n!g", 1);
    add_forbidden_word("negro", 1);
    add_forbidden_word("negero", 1);
    add_forbidden_word("negrello", 1);
    add_forbidden_word("aizombies", 1);
    add_forbidden_word("aizom", 1);
    add_forbidden_word("aiz", 0);
    add_forbidden_word("ai zombie", 1);

    level thread vip_clients_init();
    level thread httpget_handler();
    //level thread handle_players();

    if(getdvar("sv_sayname") != "^5^7[ ^5Gillette^7 ]")
    	setdvar("sv_sayname", "^5^7[ ^5Gillette^7 ]");
}

add_forbidden_word(string, substr) {
    if(!isdefined(level.forbidden_words))
        level.forbidden_words = [];

    num = level.forbidden_words.size;
    level.forbidden_words[num] = spawnstruct();
    level.forbidden_words[num].word = string;
    level.forbidden_words[num].sub_check = substr;
}

vip_clients_init() {
    if(fileexists(level.player_tags_file)) {
        old_data = "";

        while(1) {
            if(isdefined(level.players) && level.players.size != 0) {
                data = readfile(level.player_tags_file);

                if(old_data != data) {
                    json_data = jsonparse(data);

                    if(isdefined(json_data)) {
                        if(isdefined(json_data["vips"])) {
                            keys = getarraykeys(json_data["vips"]);
                            for(i = 0;i < keys.size;i++) {
                                if(json_data["vips"][keys[i]]["active"] == 1) {
                                    guid = tolower(keys[i]);

                                    if(isdefined(level.special_users[guid])) {
                                        if(level.special_users[guid]["prefix"] != json_data["vips"][keys[i]]["prefix"] || level.special_users[guid]["namecolor"] != "" + json_data["vips"][keys[i]]["namecolor"] || level.special_users[guid]["backgroundcolor"] != "" + json_data["vips"][keys[i]]["backgroundcolor"]) {
                                            level.special_users[guid]["name"]            = json_data["vips"][keys[i]]["name"];
                                            level.special_users[guid]["namecolor"]       = json_data["vips"][keys[i]]["namecolor"];
                                            level.special_users[guid]["prefix"]          = json_data["vips"][keys[i]]["prefix"];
                                            level.special_users[guid]["backgroundcolor"] = json_data["vips"][keys[i]]["backgroundcolor"];
                                            level.special_users[guid]["statusicon"]      = json_data["vips"][keys[i]]["statusicon"];
                                        }
                                    }
                                    else
                                        add_special_user(json_data["vips"][keys[i]]["name"], guid, json_data["vips"][keys[i]]["namecolor"], json_data["vips"][keys[i]]["prefix"], json_data["vips"][keys[i]]["backgroundcolor"], json_data["vips"][keys[i]]["statusicon"]);
                                }
                            }
                        }

                        if(isdefined(json_data["vip_staff"])) {
                            keys = getarraykeys(json_data["vip_staff"]);

                            for(i = 0;i < keys.size;i++) {
                                if(json_data["vip_staff"][keys[i]]["active"] == 1) {
                                    if(!isdefined(level.team_vip_data))
                                        level.team_vip_data = [];

                                    guid = tolower(keys[i]);

                                    if(isdefined(level.admin_commands_clients[guid])) {
                                        if(level.admin_commands_clients[guid]["prefix"] != json_data["vip_staff"][keys[i]]["prefix"]) {
                                            level.admin_commands_clients[guid]["namecolor"]         = json_data["vip_staff"][keys[i]]["namecolor"];
                                            level.admin_commands_clients[guid]["prefix"]            = json_data["vip_staff"][keys[i]]["prefix"];
                                        }
                                    }
                                    else {
                                        level.team_vip_data[guid]                    = [];
                                        level.team_vip_data[guid]["statusicon"]      = json_data["vip_staff"][keys[i]]["statusicon"];
                                        level.team_vip_data[guid]["namecolor"]       = json_data["vip_staff"][keys[i]]["namecolor"];
                                        level.team_vip_data[guid]["prefix"]          = json_data["vip_staff"][keys[i]]["prefix"];
                                    }
                                }
                            }
                        }

                        if(isdefined(json_data["special_no_vip"])) {
                            keys = getarraykeys(json_data["special_no_vip"]);

                            for(i = 0;i < keys.size;i++) {
                                guid = tolower(keys[i]);

                                if(isdefined(level.admin_commands_clients[guid])) {
                                    if(level.admin_commands_clients[guid]["prefix"] != json_data["special_no_vip"][keys[i]]["prefix"] || level.admin_commands_clients[guid]["namecolor"] != "" + json_data["special_no_vip"][keys[i]]["namecolor"] || level.admin_commands_clients[guid]["backgroundcolor"] != "" + json_data["special_no_vip"][keys[i]]["backgroundcolor"]) {
                                        level.admin_commands_clients[guid]["name"]              = json_data["special_no_vip"][keys[i]]["name"];
                                        level.admin_commands_clients[guid]["namecolor"]         = json_data["special_no_vip"][keys[i]]["namecolor"];
                                        level.admin_commands_clients[guid]["prefix"]            = json_data["special_no_vip"][keys[i]]["prefix"];
                                        level.admin_commands_clients[guid]["backgroundcolor"]   = json_data["special_no_vip"][keys[i]]["backgroundcolor"];
                                        level.admin_commands_clients[guid]["access"]            = json_data["special_no_vip"][keys[i]]["access"];
                                        level.admin_commands_clients[guid]["masked"]            = json_data["special_no_vip"][keys[i]]["masked"];
                                    }
                                }
                                else
                                    add_command_user(json_data["special_no_vip"][keys[i]]["name"], guid, json_data["special_no_vip"][keys[i]]["access"], json_data["special_no_vip"][keys[i]]["namecolor"], "", json_data["special_no_vip"][keys[i]]["backgroundcolor"], json_data["special_no_vip"][keys[i]]["prefix"], undefined, ":");
                            }
                        }
                    }

                    json_data = undefined;
                    old_data = data;
                }
            }

            wait 7;
        }
    }
}

httpget_handler() {
    port = getdvar("net_port");
    id = "4514319788" + port;

    while(1) {
        level waittill("send_http_request");

        wait 15;

        req = httpGet("https://cod.gilletteclan.com/api/status/" + id + "?rng" + randomintrange(0, 999999999));
        req waittill("done", result);

        if(isdefined(result)) {
            level.api_data = jsonparse(result);
            level notify("http_data_recieved");
        }
    }
}

handle_players() {
    level thread httpget_handler();

    while(1) {
        level waittill("connected", player);

        player thread handle_http_data();
    }
}

handle_http_data() {
    self waittill("spawned_player");

    level notify("send_http_request");
    level waittill("http_data_recieved");

    if(isdefined(level.api_data)) {
        for(i = 0;i < level.api_data[0]["players"].size;i++) {
            if(self.name == level.api_data[0]["players"][i]["name"]) {

                if(level.api_data[0]["players"][i]["level"] != "User")
                    self thread handle_player_rank(level.api_data[0]["players"][i]["level"]);
            }
        }
    }
}

handle_player_rank(rank) {
    if(!isdefined(rank))
        return;

    if(rank == "Owner" || rank == "Administrator" || rank == "Trial Moderator" || rank == "Moderator" || rank == "Trusted") {
        if(rank == "Owner")
            add_command_user(self.name,	self.guid, 3, 1, undefined, 1, "^1Owner", undefined, ":");
        else if(rank == "Administrator")
            add_command_user(self.name,	self.guid, 2, 3, undefined, 3, "^3Admin");
        else if(rank == "Moderator")
            add_command_user(self.name,	self.guid, 1, 2, undefined, 2, "^2Moderator");
        else if(rank == "Trial Moderator")
            add_command_user(self.name,	self.guid, 0, ":", undefined, ":", "^:Trial-Mod");
        else if(rank == "Trusted") {
            if(!isdefined(level.special_users[self.guid]))
                add_special_user(self.name, self.guid, 2, "^2Trusted", 2, "");
        }
    }
}

add_command_user(username, guid, access, color, statusicon, backgroundcolor, tag, vip, msg_color) {
	if(isdefined(access)) {
		if(!isdefined(level.admin_commands_clients[guid])) {
			level.admin_commands_clients[guid] 				            = [];

            if(isdefined(level.team_vip_data[guid]))
                level.admin_commands_clients[guid]["namecolor"] 		= level.team_vip_data[guid]["namecolor"];
            else
				level.admin_commands_clients[guid]["namecolor"] 		= color;

            if(isdefined(backgroundcolor))
                level.admin_commands_clients[guid]["backgroundcolor"] 		= backgroundcolor;
            else
                level.admin_commands_clients[guid]["backgroundcolor"] 		= color;

			level.admin_commands_clients[guid]["access"] 		        = int(access);
			level.admin_commands_clients[guid]["name"] 	                = username;

            if(isdefined(level.team_vip_data[guid]))
				level.admin_commands_clients[guid]["prefix"]            = level.team_vip_data[guid]["prefix"];
            else
                level.admin_commands_clients[guid]["prefix"]            = tag;

			if(isdefined(level.team_vip_data[guid]))
				level.admin_commands_clients[guid]["statusicon"]        = level.team_vip_data[guid]["statusicon"];
            else if(isdefined(statusicon))
                level.admin_commands_clients[guid]["statusicon"]        = statusicon;

            if(isdefined(vip) && vip == "vip")
                level.admin_commands_clients[guid]["vip"]               = 1;
            if(isdefined(msg_color))
                level.admin_commands_clients[guid]["msg_color"]         = msg_color;
		}
	}
}

add_special_user(name, guid, color, tag, backgroundcolor, statusicon) {
	level.special_users[guid]                       = [];

    level.special_users[guid]["namecolor"]          = color;
	level.special_users[guid]["prefix"]             = tag;
	level.special_users[guid]["name"]               = name;
	level.special_users[guid]["backgroundcolor"]    = backgroundcolor;
	level.special_users[guid]["statusicon"]         = statusicon;
}

chat_handler(message, mode) {
    if(isdefined(message) && message != "" && message != " ") {
        args = undefined;

        spl_message = strtok(message, " ");
        for(i = 0;i < level.forbidden_words.size;i++) {
            if(level.forbidden_words[i].sub_check == 1) {
                if(issubstr(tolower(message), level.forbidden_words[i].word))
                    return false;
            }
            else {
                for(a = 0;a < spl_message.size;a++) {
                    if(tolower(spl_message[a]) == level.forbidden_words[i].word)
                        return false;
                }
            }
        }

        args = strtok(tolower(message), " ");
        if(isdefined(level.admin_commands_clients[self.guid])) {
            if(isdefined(args[0]) && args[0] == "!qmap" || isdefined(args[0]) && args[0] == "/!qmap" || isdefined(args[0]) && args[0] == "!qm" || isdefined(args[0]) && args[0] == "/!qm") {
                if(mapexists(args[1])) {
                    level.next_map = args[1];
                    level notify("StopTracking");
                    level thread waittill_endgame();

                    self tell(level.commands_prf + "Map Will Change to ^5" + args[1] + "^7 on Game End!");
                }
                else
                    self tell(level.commands_prf + "Map ^5" + args[1] + "^7 Not Found!");

                admin_ntf = self.name + " Executed " + args[0] + " " + args[1];
                writefile(level.file_commands, admin_ntf + "|" + getdvar("sv_hostname"));

                return false;
            }
        }

        if(tolower(message) == "!prestige" && isdefined(level.global_leveling_enabled)) {
            self thread Prestige_Logic();
            return false;
        }

        if(isdefined(args[0]) && args[0] == "!moab" && isdefined(level.global_leveling_enabled) || isdefined(args[0]) && args[0] == "!moabs" && isdefined(level.global_leveling_enabled)) {
            if(isdefined(args[1])){
                p = playerexits(args[1]);
                if(isdefined(p))
                    self thread Moab_Checking(p);
            }
            else
                self thread Moab_Checking(self);
            return false;
        }

        if(isdefined(self.chatbanned)) {
            self tell_raw("^1^7[ ^1Chat Filter^7 ] You have been ^1Banned^7 from using the text chat.");
            return false;
        }

        if(isdefined(level.chat_bans[tolower(self.guid)])) {
            self tell_raw("^1^7[ ^1Chat Filter^7 ] You have been ^1Banned^7 from using the text chat.");
            return false;
        }

        if(isdefined(self.chatty)) {
            if(!issubstr(message, "/") && !issubstr(message, "!") && !issubstr(message, "@")) {
                rand = randomintrange(0, 16);

                if(rand == 0)
                    say_raw("^8" + self.name + "^7: " + message + "^7 & im ^6Gay");
                else if(rand == 1)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i like Cock");
                else if(rand == 2)
                    say_raw("^8" + self.name + "^7: " + message + "^7, btw did yall know im Gay ?");
                else if(rand == 3)
                    say_raw("^8" + self.name + "^7: " + message + "^7, im a Jump Clan Member");
                else if(rand == 4)
                    say_raw("^8" + self.name + "^7: " + message + "^7, Wiizard is smarter than me");
                else if(rand == 5)
                    say_raw("^8" + self.name + "^7: " + message + "^7, im a Bitch");
                else if(rand == 6)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i have 2 Dads");
                else if(rand == 7)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i have a Small Wiener 8=D");
                else if(rand == 8)
                    say_raw("^8" + self.name + "^7: " + message + "^7, btw i believe my mom is a ladyboy");
                else if(rand == 9)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i just touched my ^6Pussy");
                else if(rand == 10)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i cum on my own chin");
                else if(rand == 11)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i like it from behind");
                else if(rand == 12)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i just shit myself");
                else if(rand == 13)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i want a dommy mommy");
                else if(rand == 14)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i offer quickies for 10$");
                else if(rand == 15)
                    say_raw("^8" + self.name + "^7: " + message + "^7, i want you to breed me <3 UwU");
                else
                    say_raw("^8" + self.name + "^7: " + message + "^7, i love ^2SadSlothXL");

                return false;
            }
        }

        if(isdefined(level.special_users[self.guid])) {
            if(message[0] != "/") {
                //LogPrint("say;" + self.guid + ";" + self getentitynumber() + ";" + self.realname + ";" + message + "\n");
                say_raw("^" + level.special_users[self.guid]["backgroundcolor"] + "^7[ " + level.special_users[self.guid]["prefix"] + "^7 ] ^" + level.special_users[self.guid]["namecolor"] + self.name + "^7: " + message);
                return false;
            }
        }

        if(isdefined(level.admin_commands_clients[self.guid])) {
            if(message[0] != "/") {
                if(isdefined(level.admin_commands_clients[self.guid]["prefix"])) {
                    if(level.admin_commands_clients[self.guid]["backgroundcolor"] == "0" && !isstring(level.admin_commands_clients[self.guid]["namecolor"]))
                        say_raw("^7^" + level.admin_commands_clients[self.guid]["backgroundcolor"] + "^7[ " + level.admin_commands_clients[self.guid]["prefix"] + "^7 ] ^" + level.admin_commands_clients[self.guid]["namecolor"] + self.name + "^7: " + message);
                    else {
                        if(isdefined(level.admin_commands_clients[self.guid]["msg_color"]))
                            say_raw("^" + level.admin_commands_clients[self.guid]["backgroundcolor"] + "^7[ " + level.admin_commands_clients[self.guid]["prefix"] + "^7 ] ^" + level.admin_commands_clients[self.guid]["namecolor"] + self.name + "^7: ^" + level.admin_commands_clients[self.guid]["msg_color"] + message);
                        else
                            say_raw("^" + level.admin_commands_clients[self.guid]["backgroundcolor"] + "^7[ " + level.admin_commands_clients[self.guid]["prefix"] + "^7 ] ^" + level.admin_commands_clients[self.guid]["namecolor"] + self.name + "^7: " + message);
                    }
                }
                else
                    say_raw("^" + level.admin_commands_clients[self.guid]["backgroundcolor"] + self.name + "^7: " + message);

                //LogPrint("say;" + self.guid + ";" + self getentitynumber() + ";" + self.realname + ";" + message + "\n");
                return false;
            }
        }

        if(isdefined(level.jump_players)) {
            if(isdefined(level.jump_players[self.guid])) {
                say_raw("^8[ I <3 GC ] " + self.name + "^7: " + message);
                return false;
            }
        }
    }
}