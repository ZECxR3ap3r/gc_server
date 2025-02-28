#include zec\maps\zec_utility;

leaderboard_init() {
	level setup_routes_data();

	level.leaderboard_data = [];

	if(isdefined(level.map_data)) {
		level thread leaderboard_handler();
		level thread leaderboard_refresh();

		if(!directoryExists(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard_runs/"))
			createDirectory(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard_runs/");
	}
}

leaderboard_top_bounces(key) {
    temp = [];
    if(!isdefined(level.client_stats))
        level.client_stats = [];

    level.client_total_stats = 0;

    path = getDvar("fs_homepath") + "/cjstats" + "/players/_total_stats/";
    amount = getdirectorysize(path);

    print("\r^5Starting Total Stats Check");
    last = 0;

    for(a = 0;a < amount;a++) {
        last++;
        data = getfile(path, a);

        if(isdefined(data) && data != "") {
            conv = csv_decode(readfile(data, 0, 1))[0];

            if(isdefined(conv)) {
                guid = strtok(data, "/");
                guid = getsubstr(guid[guid.size - 1], 0, guid[guid.size - 1].size - 4);

                if(isdefined(conv[key]) && int(conv["loads"]) > 35000) // shitty way but works for now
                    temp[temp.size] = conv;

                if(isdefined(conv) && isdefined(conv["name"]))
                    level.client_stats[conv["name"]] = guid;

                conv = undefined;
                level.client_total_stats++;
            }
        }

        if(last > 10) {
            last = 0;
            wait .05;
        }
    }

    print("\r^6Total Stats Check ^7Completed");
    print("\rTotal Amount: ^5" + level.client_total_stats);

    for(i = 0; i < temp.size - 1; i++) {
        for(j = 0; j < temp.size - i - 1; j++) {
            if(isdefined(temp[j]) && isdefined(temp[j + 1])) {
                if(int(temp[j][key]) < int(temp[j + 1][key])) {
                    temp_swap = temp[j];
                    temp[j] = temp[j + 1];
                    temp[j + 1] = temp_swap;
                }
            }
        }
    }

    for(i = 0; i < 10;i++) {
        if(isdefined(temp[i]))
            level.leaderboard_data["total_stats"][i] = temp[i]["name"] + "," + temp[i][key] + "," + temp[i]["saves"] + "," + temp[i]["loads"] + "," + to_mins(int(int(temp[i]["timeplayed"]) * 60));
    }

    temp = undefined;
}

/*leaderboard_top_bounces(key) {
    path                = getDvar("fs_homepath") + "/cjstats" + "/players/_total_stats/";
    data                = listfiles(path);
    map_path            = getDvar("fs_homepath") + "/cjstats" + "/players/";
    int_columns         = strTok("timeplayed,saves,loads,name,draw_xp,height_x,height_y,inspect,minimap,key_x,key_y,vel_x,vel_y,R,G,B,fpsx,fpsy,camo,vel_fs,hideothers,min_bg,hud_sec_c,R2,G2,B2,fpsfs,spechud,bc,bounces,created,desc,xp,min_x,min_y,comp_angle,comp_line", ",");

    for(a = 0;a < data.size; a++) {
        if(isdefined(data[a]) && data[a] != "" && issubstr(data[a], "0100000000095251")) {
            saves   = 0;
            loads   = 0;
            time    = 0;

            stats = readfile(data[a]);
            guid = strtok(data[a], "/");
            guid = getsubstr(guid[guid.size - 1], 0, guid[guid.size - 1].size - 4);

            for(i = 0;i < level.sv_mappool.size;i++) {
                if(directoryexists(map_path + level.sv_mappool[i].mapname + "/")) {
                    if(fileexists(map_path + level.sv_mappool[i].mapname + "/" + guid + ".csv")) {
                        file_data = readfile(map_path + level.sv_mappool[i].mapname + "/" + guid + ".csv");
                        if(isdefined(file_data) && file_data != "") {
                            client_map_stats   = csv_decode(file_data)[0];
                            saves       += int(client_map_stats["saves"]);
                            loads       += int(client_map_stats["loads"]);
                            time        += int(client_map_stats["timeplayed"]);

                            print("\rFound ^5" + guid + "in ^3" + level.sv_mappool[i].mapname + "^7 " + saves + "     " + loads + "     Time :+^2" + client_map_stats["timeplayed"] + " ^7/ Total ^3" + time);
                        }
                    }
                }
            }

            player_settings = [];

            if(isdefined(stats)) {
                converted = csv_decode(stats)[0];

                foreach(i_column in int_columns) {
                    if(i_column == "saves")
                        player_settings[i_column] = saves;
                    else if(i_column == "loads")
                        player_settings[i_column] = loads;
                    else if(i_column == "timeplayed")
                        player_settings[i_column] = time;
                    else if(i_column == "created")
                        player_settings[i_column] = converted["created"];
                    else if(i_column == "desc")
                        player_settings[i_column] = converted["desc"];
                    else if(i_column == "name")
                        player_settings[i_column] = converted["name"];
                    else
                        player_settings[i_column] = converted[i_column];
                }
                csv_data = csv_encode(player_settings);
                writefile(data[a], csv_data);

                player_settings = undefined;
                map_stats = undefined;
            }
        }
    }
}*/

leaderboard_handler() {
	if(!directoryexists(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/"))
		createdirectory(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/");

	keys = getarraykeys(level.map_data["routes"]);

	for(i = 0;i < keys.size;i++) {
		if(!isdefined(level.leaderboard_data[keys[i]]))
			level.leaderboard_data[keys[i]] = [];
	}

	for(i = 0;i < keys.size;i++) {
        if(keys[i] == "total_stats")
            level thread leaderboard_top_bounces("bounces");
        else {
            data = readfile(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/" + keys[i] + ".json");

            if(!isdefined(data) || data == "") {
                level.leaderboard_data[keys[i]] = [];

                for(a = 0;a < 10;a++)
                    level.leaderboard_data[keys[i]][a] = "none,none,none,none,none";

                writefile(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/" + keys[i] + ".json", jsonSerialize(level.leaderboard_data[keys[i]], 4));
            }
            else {
                data = readfile(getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/" + keys[i] + ".json");

                level.leaderboard_data[keys[i]] = jsonparse(data);
           }
        }
	}
}

get_specific_stat(stat, file) {
    if(isdefined(stat) && isdefined(file)) {
        stats = readfile(file);
        converted = csv_decode(stats)[0];

        if(isdefined(converted[stat]))
            return converted[stat];
    }
}

playerruns_think() {
	self endon("disconnect");

	self.category_selected = 0;

	self setclientdvar("menu_leaderboard_bt_t", "Start Run");
	keys = getarraykeys(level.map_data["routes"]);
    if(keys[self.category_selected] == "total_stats")
	    self setclientdvars("menu_settings_category", "Total Stats", "menu_leaderboard_header_2", "Bounces");
    else
        self setclientdvars("menu_settings_category", keys[self.category_selected], "menu_leaderboard_header_2", "Time");

	for(i = 0;i < 10;i++) {
		data = strtok(level.leaderboard_data[keys[self.category_selected]][i], ",");

        if(isdefined(data)) {
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
        else
            break;
	}

	self.leaderboard_file = getdvar("fs_homepath") + "/cjstats/map_data/" + getdvar("mapname") + "/leaderboard_runs/" + self getguid() + ".txt";

	if(fileexists(self.leaderboard_file)) {
		self setclientdvars("menu_leaderboard_has_run", 1, "menu_leaderboard_bt_2", "Continue Run");
		self.has_old_lb_run = 1;
	}
	else {
		self setclientdvar("menu_leaderboard_has_run", 0);
		self.has_old_lb_run = undefined;
	}

	self thread leaderboard_anti_cheat();

	while(1) {
		self waittill("begin_playerrun");

		self iprintlnbold("^8Speedrun Started, Good Luck!");
		self.demo_prepare_watch 		= 1;
		self.isspeedrun 				= 1;
		self.playerrun_stats_rpg 		= 0;
        self.playerrun_stats_rpg_saved 	= 0;
		self.playerrun_stats_loads 		= 0;
		self setclientdvars("menu_leaderboard_bt_t", "Cancel Run", "menu_leaderboard_bt_2", "Pause Run", "menu_leaderboard_has_run", 1);
		self.speedrun_time = 0;
		self setorigin(self.saved_spawn);
		self setplayerangles(self.saved_angles);
        self.saved_position.origin 		= self.origin;
        self.saved_position.angles 		= self getplayerangles();
        self.save_history               = undefined;
        self.save_history               = [];
        self.selectedpoint              = 1;
		self takeallweapons();
		self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
		self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
		self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);

		if(!isdefined(self.playerrun_timer)) {
			self.playerrun_timer = newclienthudelem(self);
			self.playerrun_timer.horzalgin = "fullscreen";
			self.playerrun_timer.vertalign = "fullscreen";
			self.playerrun_timer.alignx = "center";
			self.playerrun_timer.aligny = "bottom";
			self.playerrun_timer.x = 320;
			self.playerrun_timer.y = 460;
			self.playerrun_timer.font = "small";
			self.playerrun_timer.fontscale = 1.35;
            self.playerrun_timer.color = self.choosencolor;
			self.playerrun_timer settenthstimerup(0);
		}

		self thread playerrun_file_tracking();
		self thread playerrun_leave();
		self thread playerrun_track_time();
	}
}

playerrun_track_time() {
	self endon("disconnect");
	self endon("leaderboard_run_over");

	while(1) {
		self.speedrun_time += .1;
		wait .1;
	}
}

playerrun_pause() {
	self notify("leaderboard_run_over", "Speedrun Paused");
}

playerrun_file_tracking() {
	self endon("disconnect");
	self endon("leaderboard_run_over");

	while(1) {
		self waittill("playerrun_file_update");

		writefile(self.leaderboard_file, "" + self.saved_position.origin[0] + "," + self.saved_position.origin[1] + "," + self.saved_position.origin[2] + "," + self.saved_position.angles[0] + "," + self.saved_position.angles[1] + "," + self.saved_position.angles[2] + "," + self.playerrun_stats_rpg + "," + self.playerrun_stats_loads + "," + self.speedrun_time + "," + (issubstr(self getcurrentweapon(), "rpg") ? "1" : "0"));
	}
}

leaderboard_continue_run() {
	data = readfile(self.leaderboard_file);

	raw_data = strtok(data, ",");

	self iprintlnbold("^8INFO_LEADERBOARD_CONTINUE");
	self.isspeedrun 				= 1;
	self.playerrun_stats_rpg 		= 0;
	self.playerrun_stats_loads 		= 0;
    self.save_history               = undefined;
    self.save_history               = [];
	self.demo_prepare_watch 		= 1;
    self.selectedpoint              = 1;

	self thread playerrun_file_tracking();
	self thread playerrun_leave();

	self setclientdvars("menu_leaderboard_bt_t", "Cancel Run", "menu_leaderboard_bt_2", "Pause Run", "menu_leaderboard_has_run", 1);

	self setorigin((float(raw_data[0]), float(raw_data[1]), float(raw_data[2])));
	self setplayerangles((float(raw_data[3]), float(raw_data[4]), float(raw_data[5])));
    self.saved_position.origin 		= (float(raw_data[0]), float(raw_data[1]), float(raw_data[2]));
	self.saved_position.angles 		= (float(raw_data[3]), float(raw_data[4]), float(raw_data[5]));
	self.playerrun_stats_rpg 		= int(raw_data[6]);
	self.playerrun_stats_loads 		= int(raw_data[7]);
	self.speedrun_time 				= float(raw_data[8]);
	self thread playerrun_track_time();

	if(int(raw_data[9]) == 1) {
		self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
		self setspawnweapon(level.cj_weapons.rpg + "_mp_camo0" + self.player_settings["camo"]);
	}
	else if(int(raw_data[9]) == 0) {
		self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
		self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
	}

	if(isdefined(self.playerrun_timer))
		self.playerrun_timer destroy();

	self.playerrun_timer = newclienthudelem(self);
	self.playerrun_timer.horzalgin = "fullscreen";
	self.playerrun_timer.vertalign = "fullscreen";
	self.playerrun_timer.alignx = "center";
	self.playerrun_timer.aligny = "bottom";
	self.playerrun_timer.x = 320;
	self.playerrun_timer.y = 460;
	self.playerrun_timer.font = "small";
	self.playerrun_timer.fontscale = 1.35;
    self.playerrun_timer.color = self.choosencolor;
	self.playerrun_timer settenthstimerup(-self.speedrun_time);
}

playerrun_leave() {
	self endon("disconnect");
	self endon("playerrun_ended");

	while(1) {
		self waittill("leaderboard_run_over", reason);

		if(reason != "finished")
			self iprintlnbold("Run Ended: ^8" + reason);

		self.demo_prepare_watch = undefined;
		self.isspeedrun = undefined;
		if(isdefined(self.playerrun_timer))
			self.playerrun_timer destroy();

		self setclientdvar("menu_leaderboard_bt_t", "Start Run");
		self setorigin(self.saved_spawn);
		self setplayerangles(self.saved_angles);
		self takeallweapons();
		self giveweapon(level.cj_weapons.deagle + "_mp", self.player_settings["camo"]);
		self giveweapon(level.cj_weapons.rpg + "_mp", self.player_settings["camo"]);
		self setspawnweapon(level.cj_weapons.deagle + "_mp_camo0" + self.player_settings["camo"]);
		self.playerrun_stats_rpg = undefined;
		self.playerrun_stats_loads = undefined;

		if(fileexists(self.leaderboard_file)) {
			self setclientdvars("menu_leaderboard_has_run", 1, "menu_leaderboard_bt_2", "Continue Run");
			self.has_old_lb_run = 1;
		}
		else {
			self setclientdvar("menu_leaderboard_has_run", 0);
			self.has_old_lb_run = undefined;
		}

		self notify("playerrun_ended");
	}
}

leaderboard_anti_cheat() {
	self endon("disconnect");

	while(1) {
		if(isdefined(self.isspeedrun)) {
			if(isdefined(self.cj_ufo) || isdefined(self.cj_noclip))
				self notify("leaderboard_run_over", "Cheating");
		}

		wait .05;
	}
}

leaderboard_refresh() {
	while(1) {
		level waittill("refresh_leaderboards", route);

		foreach(player in level.players) {
			if(player.category_selected == route) {
				for(i = 0;i < 10;i++) {
					data = strtok(level.leaderboard_data[route][i], ",");

                    if(route != "total_stats") {
                        if(data[0] != "none") {
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + to_mins(float(data[1])) + "\r                                                                                          " + data[2]);
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                        }
                        else {
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                        }
                    }
                    else {
                        if(data[0] != "none") {
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "" + data[0] + "\r                                           " + int(data[1]) + "\r                                                                                          " + data[2]);
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "" + data[3] + "\r                                " + data[4]);
                        }
                        else {
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_a", "");
                            player setclientdvar("menu_leaderboard_slot_" + (i + 1) + "_b", "");
                        }
                    }
				}
			}
		}
	}
}

setup_routes_data() {
	mapname = getdvar("mapname");

	level.map_data = [];
    level.map_data["routes"] = [];
	level.map_data["routes"]["total_stats"] = 1;

	switch(mapname) {
		case "mp_phoenix":
			level.map_data["routes"]["Easy"] 		= getent("endeasy", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("endinter", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("endhard", "targetname");
			level.map_data["routes"]["Advanced"] 	= getent("endadv", "targetname");
			level.map_data["routes"]["Secret"] 		= getent("endsecret", "targetname");
			break;
        case "mp_breeze_v2":
			level.map_data["routes"]["Easy"] 		= getent("endeasy", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("endinter", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("endhard", "targetname");
			level.map_data["routes"]["Advanced"] 	= getent("endadv", "targetname");
			level.map_data["routes"]["Secret"] 		= getent("endsecret", "targetname");
			break;
		case "mp_race":
			level.map_data["routes"]["Easy"] 		= getent("easyend", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("interend", "targetname");
			level.map_data["routes"]["Inter+"] 		= getent("interplusend", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("hardend", "targetname");
			level.map_data["routes"]["Fun"] 		= getent("funend", "targetname");
			level.map_data["routes"]["Bhop"] 		= getent("bhopend", "targetname");
			break;
		case "mp_mody_v4":
			level.map_data["routes"]["Easy"] 		= getent("easy_end", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("inter_end", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("hard_end", "targetname");
			break;
		case "mp_galaxy":
			level.map_data["routes"]["Easy"] 		= getent("easy_end", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("inter_end", "targetname");
			level.map_data["routes"]["Inter+"] 		= getent("interplus_end", "targetname");
			level.map_data["routes"]["Member Test"] = getent("test_end", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("hard_end", "targetname");
			break;
        case "mp_void_v2":
			level.map_data["routes"]["Easy"] 		= getent("easyfinishprint", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("interfinishprint", "targetname");
			level.map_data["routes"]["Inter+"] 		= getent("interplusfinishprint", "targetname");
			level.map_data["routes"]["Hard"]        = getent("hardfinishprint", "targetname");
			level.map_data["routes"]["Advanced"] 	= getent("advfinishprint", "targetname");
			break;
        case "mp_void":
			level.map_data["routes"]["Noob"] 		= getent("noobfinishtimer", "targetname");
			level.map_data["routes"]["Easy"] 		= getent("easyfinishtimer", "targetname");
            level.map_data["routes"]["Inter"]       = getent("interfinishtimer", "targetname");
			level.map_data["routes"]["Inter+"] 		= getent("interplusfinishtimer", "targetname");
			level.map_data["routes"]["Hard"] 	    = getent("hardfinishtimer", "targetname");
			break;
        case "mp_edge_v2":
			level.map_data["routes"]["Normal"] 		= spawn("trigger_radius", (-79219, -48846, -42964), 1, 200, 200);
			level.map_data["routes"]["Brutal"] 		= spawn("trigger_radius", (9357, 83173, -66744), 1, 200, 200);
			break;
		case "mp_spectrum":
			triggers = getentarray("trigger_multiple", "classname");
			for(i = 0;i < triggers.size;i++) {
				if(isdefined(triggers[i].target) && triggers[i].target == "exit") {
					if(triggers[i].origin == (-41980, -49683, -9764))
						level.map_data["routes"]["Beginner"] = triggers[i];
					else if(triggers[i].origin == (26414, -37605, -7653))
						level.map_data["routes"]["Easy"] = triggers[i];
					else if(triggers[i].origin == (37324, 39396, -1193))
						level.map_data["routes"]["Inter"] = triggers[i];
					else if(triggers[i].origin == (-33368, 4408, -7108))
						level.map_data["routes"]["Hard"] = triggers[i];
					else if(triggers[i].origin == (32876, 33500, 2190))
						level.map_data["routes"]["Fun"] = triggers[i];
					else if(triggers[i].origin == (72423, -1118, -4281))
						level.map_data["routes"]["ADI"] = triggers[i];
					else if(triggers[i].origin == (12160, 32939, -3224))
						level.map_data["routes"]["Advanced"] = triggers[i];
					else if(triggers[i].origin == (15758, -39237, -6326))
						level.map_data["routes"]["Purple V2"] = triggers[i];
					else if(triggers[i].origin == (-8558, -34582, -5934))
						level.map_data["routes"]["Secret"] = triggers[i];
				}
			}
			break;
		case "mp_crade":
			level.map_data["routes"]["Easy"] 		= getent("trigger_EasyEnd", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("trigger_InterEnd", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("trigger_HardEnd", "targetname");
			break;
		case "mp_galaxy_v2":
			level.map_data["routes"]["Easy"] 		= getent("efin", "targetname");
			level.map_data["routes"]["Inter"] 		= getent("ifin", "targetname");
			level.map_data["routes"]["Inter+"] 		= getent("i2fin", "targetname");
			level.map_data["routes"]["Hard"] 		= getent("hfin", "targetname");
			break;
	}

	keys = getarraykeys(level.map_data["routes"]);
	for(i = 0;i < keys.size;i++) {
        if(keys[i] != "total_stats")
		    level thread leaderboard_end_trigger(level.map_data["routes"][keys[i]], keys[i]);
    }

    level.leaderboard_count = level.map_data["routes"].size;
}

leaderboard_end_trigger(route_ent, route_name) {
	while(1) {
		if(isdefined(route_ent)) {
			foreach(player in level.players) {
				if(isdefined(player.isspeedrun) && player istouching(route_ent)) {
                    if(route_name == "Easy" && getdvar("mapname") == "mp_galaxy")
                        player thread complete_global_challenge("cj_challenge_01");

					player thread finished_run(player.speedrun_time, route_name);
					say_raw("^8" + player.name + " Completed ^8" + route_name + "^7 in ^8" + to_mins(player.speedrun_time));
				}
			}
		}

		wait .05;
	}
}

complete_global_challenge(stat_name) {
    players_dir = "C:/IW5-Data/global_stats" + "/players/" + self.guid + "/infected_data.csv";
    player_stats_name = readFile(players_dir, 0, 0, 0);
    player_stats_data = readFile(players_dir, 0, 0, 1);


    array_stats_name = strtok(player_stats_name, ",");
    array_stats_data = strtok(player_stats_data, ",");

    conv_data_data = "";
    conv_data_name = "";

    for(i = 0;i < array_stats_name.size;i++) {
        if(array_stats_name[i] == stat_name)
            array_stats_data[i] = 1;

        if(i == (array_stats_name.size - 1)) {
            conv_data_name += array_stats_name[i];
            conv_data_data += array_stats_data[i];
        }
        else {
            conv_data_name += array_stats_name[i] + ",";
            conv_data_data += array_stats_data[i] + ",";
        }
    }

    writefile(players_dir, conv_data_name + "\n" + conv_data_data);
}

finished_run(time, route_name) {
	self endon("leaderboard_run_over");

    found_spot = 69696;

    already_has_run = 0;

    for(i = 0;i < 10;i++) {
    	data = strtok(level.leaderboard_data[route_name][i], ",");

    	if(isdefined(data[0]) && data[0] == self.name) {
    		if(float(data[1]) > time)
    			level.leaderboard_data[route_name][i] = "none,none,none,none,none";
    		else {
    			self notify("leaderboard_run_over", "finished");
    			break;
    		}
    	}
    }

    for(i = 0; i < 10; i++) {
        data = strtok(level.leaderboard_data[route_name][i], ",");

        if(isdefined(data[0]) && data[0] != "none") {
            if(float(data[1]) > float(time)) {
                found_spot = i;

                for(a = 9; a > found_spot; a--)
                    level.leaderboard_data[route_name][a] = level.leaderboard_data[route_name][a - 1];

                break;
        	}
        }
        else {
            found_spot = i;
            break;
        }
    }

    if(found_spot != 69696) {
        level.leaderboard_data[route_name][found_spot] = self.name + "," + time + "," + self.playerrun_stats_rpg + "," + self.playerrun_stats_loads + "," + strtok(getservertime(), " ")[0];

        filePath = getDvar("fs_homepath") + "/cjstats" + "/map_data/" + getdvar("mapname") + "/leaderboard/" + route_name + ".json";
        writefile(filePath, jsonSerialize(level.leaderboard_data[route_name], 4));
    }

	if(fileexists(self.leaderboard_file))
		deletefile(self.leaderboard_file);

    self.player_settings["routes"]++;

    level notify("refresh_leaderboards", route_name);
    self notify("leaderboard_run_over", "finished");
}