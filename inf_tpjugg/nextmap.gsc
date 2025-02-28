#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
    replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::finalkillcamhook);
	// logprint("__________MAP_LIST__________\n");
	// keys = GetArrayKeys(level.tpjugg_maplist);
	// foreach(key in keys) {
		// logprint(key + "\n");
		// for(i=0;i<level.tpjugg_maplist[key].size; i++)
			// logprint("__ " + level.tpjugg_maplist[key][i] + "\n");
	// }
	// for(i=0; i<level.tpjugg_maplist.size; i++)	{
		// logprint(level.tpjugg_maplist[keys[i]]);
	// }
	setdvarifuninitialized("mapvote_mapedit", "undefined;undefined");
	setdvarifuninitialized("mapvote_skip_maps", "undefined;undefined;undefined;undefined;undefined;undefined;undefined;undefined;undefined;undefined");
	level.unselected_color = (0.5,0.0,0.0);
	level.selected_color = (0,1,1);
	level.selected_text_color = (1,0.8,0.0);

	// wait 14;
	//logprint("calling function\n");
	// setdvar("scr_" + getdvar("g_gametype") + "_timelimit", 100);
}


finalkillcamhook() {
    if (!IsDefined(level.finalkillcam_winner)) {
		wait 1.5;
        map_vote();
        return false;
    } else {
        level waittill("final_killcam_done");
		wait 1.5;
        map_vote();
        return true;
    }
}


map_vote() {

	// devprint("__________Selected_Maps__________\n");
	tpjugg_maplist_keys = GetArrayKeys(level.tpjugg_maplist);

	skip_maps_array = strtok(getdvar("mapvote_skip_maps"), ";");
	level.map_vote_selected_maps = [];
	for(i=0;level.map_vote_selected_maps.size < 3;) {
		possible_map = tpjugg_maplist_keys[randomint(tpjugg_maplist_keys.size)];
		// devprint(possible_map);
		if(possible_map == getdvar("mapname"))
			continue;

		should_skip = false;
		foreach(map in skip_maps_array) {
			if(possible_map == map) {
				should_skip = true;
				// devprint("skipping " + possible_map + " Cause Map Was recently played");
				break;
			}
		}
		if(should_skip)
			continue;

		if(!isdefined(level.map_vote_selected_maps[possible_map])) {
			level.map_vote_selected_maps[possible_map] = spawnstruct();
			// devprint(possible_map + " ^2Selected\n");
			i++;
		}
	}
	// devprint("_______Selected_Maps_Edit_______\n");

	level.map_vote_selected_maps_keys = GetArrayKeys(level.map_vote_selected_maps);
	for(i=0;i < 3;i++) {
		map = level.map_vote_selected_maps_keys[i];
		map_edit_index = randomint(level.tpjugg_maplist[map].size);
		// devprint(map);
		// devprint(map_edit_index);
		level.map_vote_selected_maps[map].selected_edit = level.tpjugg_maplist[map][map_edit_index];
		// devprint(level.map_vote_selected_maps[map].selected_edit);
		// devprint(level.tpjugg_maplist_display_name[map]);
		// devprint(level.tpjugg_maplist_display_name[map] + "\n  |__: "+ level.map_vote_selected_maps[map].selected_edit);
		// iprintln(level.tpjugg_maplist_display_name[map] + "\n  |__: "+ level.map_vote_selected_maps[map].selected_edit);
	}
	
	level.mapvote_votes = [];
	level.mapvote_votes["map_0"] = 0;
	level.mapvote_votes["map_1"] = 0;
	level.mapvote_votes["map_2"] = 0;
	level thread best_map();
	foreach(player in level.players) {
		player thread mapvote_hud();
	}

	if(!isdefined(level.map_vote_hud))
		level.map_vote_hud = [];
	
	level.voting_time = 15;

	level.map_vote_hud["map_vote_timer"] = newHudElem();
	level.map_vote_hud["map_vote_timer"].x = 180;
	level.map_vote_hud["map_vote_timer"].y = 100; 
	level.map_vote_hud["map_vote_timer"].alignx = "left";
	level.map_vote_hud["map_vote_timer"].aligny = "middle";
	level.map_vote_hud["map_vote_timer"].horzAlign = "fullscreen";
	level.map_vote_hud["map_vote_timer"].vertalign = "fullscreen";
	level.map_vote_hud["map_vote_timer"].fontscale = 0.57;
	level.map_vote_hud["map_vote_timer"].font = "hudbig";
	level.map_vote_hud["map_vote_timer"].hidewheninmenu = true;
	level.map_vote_hud["map_vote_timer"].archived = false;
	level.map_vote_hud["map_vote_timer"].alpha = 1;
	level.map_vote_hud["map_vote_timer"].label = &"^7Map Vote - Time Remaining: ^3&&1";
	level.map_vote_hud["map_vote_timer"] setvalue(level.voting_time);

	for(; level.voting_time >= 0; level.voting_time--) {
		level.map_vote_hud["map_vote_timer"] setvalue(level.voting_time);
		if(level.voting_time < 5) {
			if(level.voting_time == 0) {
				foreach(p in level.players){
					p playlocalsound("new_title_unlocks");
					p playlocalsound("new_perk_unlocks");
				}
				continue;
			}
			else {
				foreach(p in level.players)
					p playlocalsound("new_perk_unlocks");
			}
		}

		wait 1;
	}

	level notify("end_mapvote");

	level.map_vote_best_maps = [];
	level.map_vote_best_maps[0] = 0;
	level.map_vote_best_maps[1] = 0;
	level.map_vote_best_maps[2] = 0;
	foreach(player in level.players) {
		if(isdefined(player) && isdefined(player.selected_map) && player.selected_map != -1)
			level.map_vote_best_maps[player.selected_map]++;
	}


	map = 0;
	if(level.map_vote_best_maps[0] < level.map_vote_best_maps[1]) {
		map = 1;
		if(level.map_vote_best_maps[1] < level.map_vote_best_maps[2]) {
			map = 2;
		}
	}
	else if(level.map_vote_best_maps[0] < level.map_vote_best_maps[2]) {
		map = 2;
	}

	nomap = [];
	map1 = [];
	map2 = [];
	map3 = [];

	foreach(player in level.players) {
		if(!isdefined(player.selected_map)) {
			continue;

		}
		if(player.selected_map == -1) {
			nomap[nomap.size] = player.name;
			player tell_raw("^8^7[ ^8Information ^7]: Remember to ^3Vote^7 for a map");
		}
		else if(player.selected_map == 0) {
			map1[map1.size] = player.name;
		} else if(player.selected_map == 1) {
			map2[map2.size] = player.name;
		} else if(player.selected_map == 2) {
			map3[map3.size] = player.name;
		}
	}

	foreach(player in level.players) {
		if(!isdefined(str))
			str = player.name;
		else
			str = str + "->" + player.name;
	}
	setdvar("connectionlist", str);

	iprintln("^3===================");
	iprintln("^1Didnt Vote");
	foreach(name in nomap)
		iprintln("^7   " + name);
	iprintln("^2Voted For ^3" + level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[0]] + "^7 - ^3"+ level.map_vote_selected_maps[level.map_vote_selected_maps_keys[0]].selected_edit);
	foreach(name in map1)
		iprintln("^7   " + name);
	iprintln("^2Voted For ^3" + level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[1]] + "^7 - ^3"+ level.map_vote_selected_maps[level.map_vote_selected_maps_keys[1]].selected_edit);
	foreach(name in map2)
		iprintln("^7   " + name);
	iprintln("^2Voted For ^3" + level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[2]] + "^7 - ^3"+ level.map_vote_selected_maps[level.map_vote_selected_maps_keys[2]].selected_edit);
	foreach(name in map3)
		iprintln("^7   " + name);
	iprintln("^3===================");

	foreach(player in level.players) {
		if(isdefined(player.map_vote_hud["map_0"])) {
			player.map_vote_hud["map_0_count"] setvalue(level.map_vote_best_maps[0]);
			player.map_vote_hud["map_1_count"] setvalue(level.map_vote_best_maps[1]);
			player.map_vote_hud["map_2_count"] setvalue(level.map_vote_best_maps[2]);
			player.map_vote_hud["map_0"].color = (1,1,1);
			player.map_vote_hud["map_1"].color = (1,1,1);
			player.map_vote_hud["map_2"].color = (1,1,1);
			player.map_vote_hud["map_0_2"].color = (1,1,1);
			player.map_vote_hud["map_1_2"].color = (1,1,1);
			player.map_vote_hud["map_2_2"].color = (1,1,1);
			player.map_vote_hud["map_0_shader"].color = level.unselected_color;
			player.map_vote_hud["map_1_shader"].color = level.unselected_color;
			player.map_vote_hud["map_2_shader"].color = level.unselected_color;
			player.map_vote_hud["map_0_shader2"].color = level.unselected_color;
			player.map_vote_hud["map_1_shader2"].color = level.unselected_color;
			player.map_vote_hud["map_2_shader2"].color = level.unselected_color;


			player.map_vote_hud["map_" + map].color = level.selected_text_color;
			player.map_vote_hud["map_" + map + "_2"].color = level.selected_text_color;
			player.map_vote_hud["map_" + map + "_shader"].color = level.selected_text_color;
			player.map_vote_hud["map_" + map + "_shader2"].color = level.selected_text_color;
		}
	}

	setdvar("mapvote_mapedit", level.map_vote_selected_maps_keys[map]+";"+level.map_vote_selected_maps[level.map_vote_selected_maps_keys[map]].selected_edit);
	level.map_vote_hud["map_vote_timer"].label = &"";
	level.map_vote_hud["map_vote_timer"] settext("^7Switching to - ^3"+level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[map]] + "^7  Edit - ^3" +level.map_vote_selected_maps[level.map_vote_selected_maps_keys[map]].selected_edit);
	level thread update_last_maps_played();
	wait 5;
	cmdexec("map " + level.map_vote_selected_maps_keys[map]);

}

update_last_maps_played() {
	maps_array = strtok(getdvar("mapvote_skip_maps"), ";");
	// for(i=0;i<maps_array.size;i++)
		// print("^2"+maps_array[i]);

	for(i=0;i<maps_array.size;i++) {
		if(isdefined(maps_array[i+1]))
			maps_array[i] = maps_array[i+1];
	}
	maps_array[maps_array.size-1] = getdvar("mapname");

	// for(i=0;i<maps_array.size;i++)
		// print("^1"+maps_array[i]);
	
	string = "";
	for(i=0;i<maps_array.size;i++) {
		if(i == maps_array.size-1)
			string = string + maps_array[i];
		else
			string = string + maps_array[i] + ";";
	}
	print("^1" + string);
	setdvar("mapvote_skip_maps",string);
}

mapvote_hud() {

	x_add = 140;
	y_add = 70;
	x = 320;
	y = 210;
	i = 0;
	selected_maps = level.map_vote_selected_maps;
	selected_maps_keys = level.map_vote_selected_maps_keys;

	font_scale = 0.57;


	self.map_vote_hud = [];

	self.map_vote_hud["bg_shader"] = newclienthudelem(self);
	self.map_vote_hud["bg_shader"] setshader("white", 300, 280);
	self.map_vote_hud["bg_shader"].x = x;
	self.map_vote_hud["bg_shader"].y = y + 10;
	self.map_vote_hud["bg_shader"].alignx = "CENTER";
	self.map_vote_hud["bg_shader"].aligny = "middle";
	self.map_vote_hud["bg_shader"].horzalign = "fullscreen";
	self.map_vote_hud["bg_shader"].vertalign = "fullscreen";
	self.map_vote_hud["bg_shader"].hideWhenInMenu = true;
	self.map_vote_hud["bg_shader"].archived = false;
	self.map_vote_hud["bg_shader"].color = (0,0,0);
	self.map_vote_hud["bg_shader"].sort = -5;
	self.map_vote_hud["bg_shader"].alpha = 0.85;

	self.map_vote_hud["map_0"] = newClientHudElem(self);
	self.map_vote_hud["map_0"].x = x-x_add+5;
	self.map_vote_hud["map_0"].y = y - y_add; 
	self.map_vote_hud["map_0"].alignx = "left";
	self.map_vote_hud["map_0"].aligny = "middle";
	self.map_vote_hud["map_0"].horzAlign = "fullscreen";
	self.map_vote_hud["map_0"].vertalign = "fullscreen";
	self.map_vote_hud["map_0"].fontscale = font_scale;
	self.map_vote_hud["map_0"].font = "hudbig";
	self.map_vote_hud["map_0"].hidewheninmenu = true;
	self.map_vote_hud["map_0"].archived = true;
	self.map_vote_hud["map_0"].alpha = 1;
	self.map_vote_hud["map_0"] settext(level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[0]]);
	
	self.map_vote_hud["map_0_2"] = newClientHudElem(self);
	self.map_vote_hud["map_0_2"].x = x-40;
	self.map_vote_hud["map_0_2"].y = self.map_vote_hud["map_0"].y; 
	self.map_vote_hud["map_0_2"].alignx = "left";
	self.map_vote_hud["map_0_2"].aligny = "middle";
	self.map_vote_hud["map_0_2"].horzAlign = "fullscreen";
	self.map_vote_hud["map_0_2"].vertalign = "fullscreen";
	self.map_vote_hud["map_0_2"].fontscale = font_scale;
	self.map_vote_hud["map_0_2"].font = "hudbig";
	self.map_vote_hud["map_0_2"].hidewheninmenu = true;
	self.map_vote_hud["map_0_2"].archived = true;
	self.map_vote_hud["map_0_2"].alpha = 1;
	self.map_vote_hud["map_0_2"] settext(level.map_vote_selected_maps[level.map_vote_selected_maps_keys[0]].selected_edit);

	self.map_vote_hud["map_0_count"] = newClientHudElem(self);
	self.map_vote_hud["map_0_count"].x = x+x_add-10;
	self.map_vote_hud["map_0_count"].y = self.map_vote_hud["map_0"].y; 
	self.map_vote_hud["map_0_count"].alignx = "right";
	self.map_vote_hud["map_0_count"].aligny = "middle";
	self.map_vote_hud["map_0_count"].horzAlign = "fullscreen";
	self.map_vote_hud["map_0_count"].vertalign = "fullscreen";
	self.map_vote_hud["map_0_count"].fontscale = font_scale;
	self.map_vote_hud["map_0_count"].font = "hudbig";
	self.map_vote_hud["map_0_count"].hidewheninmenu = true;
	self.map_vote_hud["map_0_count"].archived = true;
	self.map_vote_hud["map_0_count"].alpha = 1;
	self.map_vote_hud["map_0_count"].label = &"&&1";
	self.map_vote_hud["map_0_count"] setvalue(level.mapvote_votes["map_0"]);

	self.map_vote_hud["map_0_shader"] = newclienthudelem(self);
	self.map_vote_hud["map_0_shader"] setshader("white", 190, 40);
	self.map_vote_hud["map_0_shader"].x = x+x_add;
	self.map_vote_hud["map_0_shader"].y = self.map_vote_hud["map_0"].y;
	self.map_vote_hud["map_0_shader"].alignx = "right";
	self.map_vote_hud["map_0_shader"].aligny = "middle";
	self.map_vote_hud["map_0_shader"].horzalign = "fullscreen";
	self.map_vote_hud["map_0_shader"].vertalign = "fullscreen";
	self.map_vote_hud["map_0_shader"].hideWhenInMenu = true;
	self.map_vote_hud["map_0_shader"].archived = false;
	self.map_vote_hud["map_0_shader"].color = level.unselected_color;
	self.map_vote_hud["map_0_shader"].sort = -4;
	self.map_vote_hud["map_0_shader"].alpha = 0.30;

	self.map_vote_hud["map_0_shader2"] = newclienthudelem(self);
	self.map_vote_hud["map_0_shader2"] setshader("white", 80, 40);
	self.map_vote_hud["map_0_shader2"].x = x-x_add;
	self.map_vote_hud["map_0_shader2"].y = self.map_vote_hud["map_0"].y;
	self.map_vote_hud["map_0_shader2"].alignx = "left";
	self.map_vote_hud["map_0_shader2"].aligny = "middle";
	self.map_vote_hud["map_0_shader2"].horzalign = "fullscreen";
	self.map_vote_hud["map_0_shader2"].vertalign = "fullscreen";
	self.map_vote_hud["map_0_shader2"].hideWhenInMenu = true;
	self.map_vote_hud["map_0_shader2"].archived = false;
	self.map_vote_hud["map_0_shader2"].color = level.unselected_color;
	self.map_vote_hud["map_0_shader2"].sort = -4;
	self.map_vote_hud["map_0_shader2"].alpha = 0.30;

	self.map_vote_hud["map_1"] = newClientHudElem(self);
	self.map_vote_hud["map_1"].x = x-x_add+5;
	self.map_vote_hud["map_1"].y = y; 
	self.map_vote_hud["map_1"].alignx = "left";
	self.map_vote_hud["map_1"].aligny = "middle";
	self.map_vote_hud["map_1"].horzAlign = "fullscreen";
	self.map_vote_hud["map_1"].vertalign = "fullscreen";
	self.map_vote_hud["map_1"].fontscale = font_scale;
	self.map_vote_hud["map_1"].font = "hudbig";
	self.map_vote_hud["map_1"].hidewheninmenu = true;
	self.map_vote_hud["map_1"].archived = true;
	self.map_vote_hud["map_1"].alpha = 1;
	self.map_vote_hud["map_1"] settext(level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[1]]);

	self.map_vote_hud["map_1_2"] = newClientHudElem(self);
	self.map_vote_hud["map_1_2"].x = x-40;
	self.map_vote_hud["map_1_2"].y = self.map_vote_hud["map_1"].y; 
	self.map_vote_hud["map_1_2"].alignx = "left";
	self.map_vote_hud["map_1_2"].aligny = "middle";
	self.map_vote_hud["map_1_2"].horzAlign = "fullscreen";
	self.map_vote_hud["map_1_2"].vertalign = "fullscreen";
	self.map_vote_hud["map_1_2"].fontscale = font_scale;
	self.map_vote_hud["map_1_2"].font = "hudbig";
	self.map_vote_hud["map_1_2"].hidewheninmenu = true;
	self.map_vote_hud["map_1_2"].archived = true;
	self.map_vote_hud["map_1_2"].alpha = 1;
	self.map_vote_hud["map_1_2"] settext(level.map_vote_selected_maps[level.map_vote_selected_maps_keys[1]].selected_edit);

	self.map_vote_hud["map_1_count"] = newClientHudElem(self);
	self.map_vote_hud["map_1_count"].x = x+x_add-10;
	self.map_vote_hud["map_1_count"].y = self.map_vote_hud["map_1"].y; 
	self.map_vote_hud["map_1_count"].alignx = "right";
	self.map_vote_hud["map_1_count"].aligny = "middle";
	self.map_vote_hud["map_1_count"].horzAlign = "fullscreen";
	self.map_vote_hud["map_1_count"].vertalign = "fullscreen";
	self.map_vote_hud["map_1_count"].fontscale = font_scale;
	self.map_vote_hud["map_1_count"].font = "hudbig";
	self.map_vote_hud["map_1_count"].hidewheninmenu = true;
	self.map_vote_hud["map_1_count"].archived = true;
	self.map_vote_hud["map_1_count"].alpha = 1;
	self.map_vote_hud["map_1_count"].label = &"&&1";
	self.map_vote_hud["map_1_count"] setvalue(level.mapvote_votes["map_0"]);

	self.map_vote_hud["map_1_shader"] = newclienthudelem(self);
	self.map_vote_hud["map_1_shader"] setshader("white", 190, 40);
	self.map_vote_hud["map_1_shader"].x = x+x_add;
	self.map_vote_hud["map_1_shader"].y = self.map_vote_hud["map_1"].y;
	self.map_vote_hud["map_1_shader"].alignx = "right";
	self.map_vote_hud["map_1_shader"].aligny = "middle";
	self.map_vote_hud["map_1_shader"].horzalign = "fullscreen";
	self.map_vote_hud["map_1_shader"].vertalign = "fullscreen";
	self.map_vote_hud["map_1_shader"].hideWhenInMenu = true;
	self.map_vote_hud["map_1_shader"].archived = false;
	self.map_vote_hud["map_1_shader"].color = level.unselected_color;
	self.map_vote_hud["map_1_shader"].sort = -4;
	self.map_vote_hud["map_1_shader"].alpha = 0.30;

	self.map_vote_hud["map_1_shader2"] = newclienthudelem(self);
	self.map_vote_hud["map_1_shader2"] setshader("white", 80, 40);
	self.map_vote_hud["map_1_shader2"].x = x-x_add;
	self.map_vote_hud["map_1_shader2"].y = self.map_vote_hud["map_1"].y;
	self.map_vote_hud["map_1_shader2"].alignx = "left";
	self.map_vote_hud["map_1_shader2"].aligny = "middle";
	self.map_vote_hud["map_1_shader2"].horzalign = "fullscreen";
	self.map_vote_hud["map_1_shader2"].vertalign = "fullscreen";
	self.map_vote_hud["map_1_shader2"].hideWhenInMenu = true;
	self.map_vote_hud["map_1_shader2"].archived = false;
	self.map_vote_hud["map_1_shader2"].color = level.unselected_color;
	self.map_vote_hud["map_1_shader2"].sort = -4;
	self.map_vote_hud["map_1_shader2"].alpha = 0.30;

	self.map_vote_hud["map_2"] = newClientHudElem(self);
	self.map_vote_hud["map_2"].x = x-x_add+5;
	self.map_vote_hud["map_2"].y = y + y_add;
	self.map_vote_hud["map_2"].alignx = "left";
	self.map_vote_hud["map_2"].aligny = "middle";
	self.map_vote_hud["map_2"].horzAlign = "fullscreen";
	self.map_vote_hud["map_2"].vertalign = "fullscreen";
	self.map_vote_hud["map_2"].fontscale = font_scale;
	self.map_vote_hud["map_2"].font = "hudbig";
	self.map_vote_hud["map_2"].hidewheninmenu = true;
	self.map_vote_hud["map_2"].archived = false;
	self.map_vote_hud["map_2"].alpha = 1;
	self.map_vote_hud["map_2"] settext(level.tpjugg_maplist_display_name[level.map_vote_selected_maps_keys[2]]);

	self.map_vote_hud["map_2_2"] = newClientHudElem(self);
	self.map_vote_hud["map_2_2"].x = x-40;
	self.map_vote_hud["map_2_2"].y = self.map_vote_hud["map_2"].y; 
	self.map_vote_hud["map_2_2"].alignx = "left";
	self.map_vote_hud["map_2_2"].aligny = "middle";
	self.map_vote_hud["map_2_2"].horzAlign = "fullscreen";
	self.map_vote_hud["map_2_2"].vertalign = "fullscreen";
	self.map_vote_hud["map_2_2"].fontscale = font_scale;
	self.map_vote_hud["map_2_2"].font = "hudbig";
	self.map_vote_hud["map_2_2"].hidewheninmenu = true;
	self.map_vote_hud["map_2_2"].archived = true;
	self.map_vote_hud["map_2_2"].alpha = 1;
	self.map_vote_hud["map_2_2"] settext(level.map_vote_selected_maps[level.map_vote_selected_maps_keys[2]].selected_edit);


	self.map_vote_hud["map_2_count"] = newClientHudElem(self);
	self.map_vote_hud["map_2_count"].x = x+x_add-10;
	self.map_vote_hud["map_2_count"].y = self.map_vote_hud["map_2"].y;
	self.map_vote_hud["map_2_count"].alignx = "right";
	self.map_vote_hud["map_2_count"].aligny = "middle";
	self.map_vote_hud["map_2_count"].horzAlign = "fullscreen";
	self.map_vote_hud["map_2_count"].vertalign = "fullscreen";
	self.map_vote_hud["map_2_count"].fontscale = font_scale;
	self.map_vote_hud["map_2_count"].font = "hudbig";
	self.map_vote_hud["map_2_count"].hidewheninmenu = true;
	self.map_vote_hud["map_2_count"].archived = true;
	self.map_vote_hud["map_2_count"].alpha = 1;
	self.map_vote_hud["map_2_count"].label = &"&&1";
	self.map_vote_hud["map_2_count"] setvalue(level.mapvote_votes["map_0"]);

	self.map_vote_hud["map_2_shader"] = newclienthudelem(self);
	self.map_vote_hud["map_2_shader"] setshader("white", 190, 40);
	self.map_vote_hud["map_2_shader"].x = x+x_add;
	self.map_vote_hud["map_2_shader"].y = self.map_vote_hud["map_2"].y;
	self.map_vote_hud["map_2_shader"].alignx = "right";
	self.map_vote_hud["map_2_shader"].aligny = "middle";
	self.map_vote_hud["map_2_shader"].horzalign = "fullscreen";
	self.map_vote_hud["map_2_shader"].vertalign = "fullscreen";
	self.map_vote_hud["map_2_shader"].hideWhenInMenu = true;
	self.map_vote_hud["map_2_shader"].archived = false;
	self.map_vote_hud["map_2_shader"].color = level.unselected_color;
	self.map_vote_hud["map_2_shader"].sort = -4;
	self.map_vote_hud["map_2_shader"].alpha = 0.30;

	self.map_vote_hud["map_2_shader2"] = newclienthudelem(self);
	self.map_vote_hud["map_2_shader2"] setshader("white", 80, 40);
	self.map_vote_hud["map_2_shader2"].x = x-x_add;
	self.map_vote_hud["map_2_shader2"].y = self.map_vote_hud["map_2"].y;
	self.map_vote_hud["map_2_shader2"].alignx = "left";
	self.map_vote_hud["map_2_shader2"].aligny = "middle";
	self.map_vote_hud["map_2_shader2"].horzalign = "fullscreen";
	self.map_vote_hud["map_2_shader2"].vertalign = "fullscreen";
	self.map_vote_hud["map_2_shader2"].hideWhenInMenu = true;
	self.map_vote_hud["map_2_shader2"].archived = false;
	self.map_vote_hud["map_2_shader2"].color = level.unselected_color;
	self.map_vote_hud["map_2_shader2"].sort = -4;
	self.map_vote_hud["map_2_shader2"].alpha = 0.30;

	self.map_vote_hud["map_vote_info"] = newClientHudElem(self);
	self.map_vote_hud["map_vote_info"].x = x;
	self.map_vote_hud["map_vote_info"].y = y - -y_add*1.75; 
	self.map_vote_hud["map_vote_info"].alignx = "center";
	self.map_vote_hud["map_vote_info"].aligny = "middle";
	self.map_vote_hud["map_vote_info"].horzAlign = "fullscreen";
	self.map_vote_hud["map_vote_info"].vertalign = "fullscreen";
	self.map_vote_hud["map_vote_info"].fontscale = font_scale;
	self.map_vote_hud["map_vote_info"].font = "hudbig";
	self.map_vote_hud["map_vote_info"].hidewheninmenu = true;
	self.map_vote_hud["map_vote_info"].archived = false;
	self.map_vote_hud["map_vote_info"].alpha = 1;
	self.map_vote_hud["map_vote_info"] settext("^7Confirm Selection - ^3[{+activate}]    ^7Move up - ^3[{+forward}]    ^7Move down - ^3[{+back}]");

	self thread map_mapvote_selecting();
}

on_disconnect() {
	self waittill("disconnect");
	level notify("recalculate_map");
}

map_mapvote_selecting() {
	self endon("disconnect");
	self thread on_disconnect();
	self thread forwardbutton();
	self thread backbutton();
	self thread selectionbutton();

	self notifyonplayercommand("use_pressed","+activate");

	if(!isdefined(level.voting_time))
		wait 0.05;


	self.selected = 0;
	self.selected_map = -1;
	self.map_vote_hud["map_0"].color = level.selected_text_color;
	self.map_vote_hud["map_0_2"].color = level.selected_text_color;
	self.map_vote_hud["map_0_shader"].color = level.selected_color;
	self.map_vote_hud["map_0_shader2"].color = level.selected_color;


	while(level.voting_time>=0) {
		wait 0.05;
		if(self.confirm) {
			if(self.selected_map != self.selected) {
				self.selected_map = self.selected;
				self playLocalSound( "new_weapon_unlocks" );
				level notify("recalculate_map");
			}

			while(self.confirm)
				wait 0.05;
		}
		
		if(self.forward && !self.back) {
			self.selected--;
			if(self.selected < 0) self.selected = level.map_vote_selected_maps.size-1;

			self.map_vote_hud["map_0"].color = (1,1,1);
			self.map_vote_hud["map_1"].color = (1,1,1);
			self.map_vote_hud["map_2"].color = (1,1,1);
			self.map_vote_hud["map_0_2"].color = (1,1,1);
			self.map_vote_hud["map_1_2"].color = (1,1,1);
			self.map_vote_hud["map_2_2"].color = (1,1,1);
			self.map_vote_hud["map_0_shader"].color = level.unselected_color;
			self.map_vote_hud["map_1_shader"].color = level.unselected_color;
			self.map_vote_hud["map_2_shader"].color = level.unselected_color;
			self.map_vote_hud["map_0_shader2"].color = level.unselected_color;
			self.map_vote_hud["map_1_shader2"].color = level.unselected_color;
			self.map_vote_hud["map_2_shader2"].color = level.unselected_color;


			self.map_vote_hud["map_" + self.selected].color = level.selected_text_color;
			self.map_vote_hud["map_" + self.selected + "_2"].color = level.selected_text_color;
			self.map_vote_hud["map_" + self.selected + "_shader"].color = level.selected_color;
			self.map_vote_hud["map_" + self.selected + "_shader2"].color = level.selected_color;
			self playLocalSound( "new_emblem_unlocks" );

			if(self.selected_map != self.selected) {
				self.selected_map = self.selected;
				self playLocalSound( "new_weapon_unlocks" );
				level notify("recalculate_map");
			}

			wait 0.15;
		}
		else if(self.back && !self.forward) {
			self.selected++;
			if(self.selected > level.map_vote_selected_maps.size-1) self.selected = 0;

			self.map_vote_hud["map_0"].color = (1,1,1);
			self.map_vote_hud["map_1"].color = (1,1,1);
			self.map_vote_hud["map_2"].color = (1,1,1);
			self.map_vote_hud["map_0_2"].color = (1,1,1);
			self.map_vote_hud["map_1_2"].color = (1,1,1);
			self.map_vote_hud["map_2_2"].color = (1,1,1);
			self.map_vote_hud["map_0_shader"].color = level.unselected_color;
			self.map_vote_hud["map_1_shader"].color = level.unselected_color;
			self.map_vote_hud["map_2_shader"].color = level.unselected_color;
			self.map_vote_hud["map_0_shader2"].color = level.unselected_color;
			self.map_vote_hud["map_1_shader2"].color = level.unselected_color;
			self.map_vote_hud["map_2_shader2"].color = level.unselected_color;


			self.map_vote_hud["map_" + self.selected].color = level.selected_text_color;
			self.map_vote_hud["map_" + self.selected + "_2"].color = level.selected_text_color;
			self.map_vote_hud["map_" + self.selected + "_shader"].color = level.selected_color;
			self.map_vote_hud["map_" + self.selected + "_shader2"].color = level.selected_color;
			self playLocalSound( "new_emblem_unlocks" );

			if(self.selected_map != self.selected) {
				self.selected_map = self.selected;
				self playLocalSound( "new_weapon_unlocks" );
				level notify("recalculate_map");
			}
			
			wait 0.15;
		}
	}
}

best_map() {
	level endon("end_mapvote");
	for(;;) {
		level waittill_any("recalculate_map");
		level.map_vote_best_maps = [];
		level.map_vote_best_maps[0] = 0;
		level.map_vote_best_maps[1] = 0;
		level.map_vote_best_maps[2] = 0;
		foreach(player in level.players) {
			if(isdefined(player) && isdefined(player.selected_map) && player.selected_map != -1)
				level.map_vote_best_maps[player.selected_map]++;
		}

		foreach(player in level.players) {
			if(isdefined(player.map_vote_hud["map_0_count"])) {
				player.map_vote_hud["map_0_count"] setvalue(level.map_vote_best_maps[0]);
				player.map_vote_hud["map_1_count"] setvalue(level.map_vote_best_maps[1]);
				player.map_vote_hud["map_2_count"] setvalue(level.map_vote_best_maps[2]);
			}
		}
	}
}




forwardbutton() {
	level endon("end_mapvote");
	self notifyonplayercommand("forward_pressed","+forward");
	self notifyonplayercommand("forward_un_pressed","-forward");
	self notifyonplayercommand("forward_pressed","+actionslot 1");
	self notifyonplayercommand("forward_un_pressed","-actionslot 1");
	self.forward = false;
	while(true) {
		self waittill("forward_pressed");
		self.forward = true;
		self waittill("forward_un_pressed");
		self.forward = false;
	}
}

backbutton() {
	level endon("end_mapvote");
	self notifyonplayercommand("back_pressed","+back");
	self notifyonplayercommand("back_un_pressed","-back");
	self notifyonplayercommand("back_pressed","+actionslot 2");
	self notifyonplayercommand("back_un_pressed","-actionslot 2");
	self.back = false;
	while(true) {
		self waittill("back_pressed");
		self.back = true;
		self waittill("back_un_pressed");
		self.back = false;
	}
}

selectionbutton() {
	level endon("end_mapvote");
	self notifyonplayercommand("selection_pressed","+activate");
	self notifyonplayercommand("selection_un_pressed","-activate");
	self notifyonplayercommand("selection_pressed","+gostand");
	self notifyonplayercommand("selection_un_pressed","-gostand");
	self.confirm = false;
	while(true) {
		self waittill("selection_pressed");
		self.confirm = true;
		self waittill("selection_un_pressed");
		self.confirm = false;
	}
}






//isdefined(level.next_map)
// hud_iw5_devider
// hud_killstreak_bridge
// hud_weaponbar_line

devprint(printer) {
	// print(printer);
	//logprint(printer);
}