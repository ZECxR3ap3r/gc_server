#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    setDvarIfUninitialized("Lastmap", "none");
    setDvarIfUninitialized("Lastmap2", "none");
    setDvarIfUninitialized("Lastmap3", "none");
    precacheshader("gradient_top");
    level.mapvotemaps = strtok("mp_alpha#mp_bootleg#mp_bravo#mp_carbon#mp_dome#mp_exchange#mp_hardhat#mp_interchange#mp_lambeth#mp_mogadishu#mp_paris#mp_plaza2#mp_seatown#mp_underground#mp_village#mp_terminal_cls#mp_rust#mp_favela#mp_courtyard_ss#mp_aground_ss#mp_showdown_sh#mp_geometric#mp_boneyard#mp_italy#mp_overwatch#mp_morningwood#mp_roughneck#mp_boardwalk#mp_cement#mp_crosswalk_ss#mp_hillside_ss#mp_meteora#mp_moab#mp_nola#mp_park#mp_restrepo_ss#mp_shipbreaker#mp_six_ss#mp_trop_rust#mp_rustbucket#mp_subbase#mp_dwarf_sh#mp_radiation_sh#mp_kwakelo", "#");
	level.mapvotedescs = strtok("European city center. Great for Team \nDefender.#Medium sized Asian market. Fun for all game \nmodes.#African colonial settlement. Fight to control \nthe center.#Medium sized refinery. Great for any number \nof players.#Small outpost in the desert. Fast and frantic \naction.#Urban map with wide streets. Good for long \nand short range fights.#A small construction site. Fast paced, close \nquarter action.#Destroyed freeway. Great for a wide range of \nspaces and styles.#Derelict Russian ghost town. Great for \ncareful, tactical engagements.#Crash site in an African city. Classic urban \ncombat.#Parisian district. Great for Domination and Kill \nConfirmed.#Medium sized German mall. Intense Search & \nDestroy games.#A costal town. Narrow streets bring hectic, \nclose encounters.#Small subway station. Fast paced action both \ninside and out.#Large African village. Great for all game \nmodes.#Russian airport terminal under siege. The \nclassic fan favorite is back.#Tiny desert sandstorm. Fast-paced action on \na small map.#Favela ported from MW2#Erosion#Aground#Showdown from CoD: Online\nPorted by Brent#Geometric from cod4 by xylozi\nPorted by Artyx#Scrapyard from MW2\nPorted by Artyx#Piazza from MW3 DLC Pack 1\nConverted to usermaps by TMGlion#Overwatch from MW3 DLC Pack 2\nConverted to usermaps by Artyx#Black Box from MW3 DLC Pack 3\nConverted to usermaps by Artyx#Off Shore from MW3 DLC Pack 7\nConverted to usermaps by Artyx#Boardwalk from MW3 DLC Pack 9\nConverted to usermaps by Artyx#Foundation from MW3 DLC Pack 4\nConverted to usermaps by Artyx#Intersection from MW3 DLC Pack 6\nConverted to usermaps by Artyx#Getaway from MW3 Faceoff DLC\nConverted to usermaps by Artyx#Sanctuary from MW3 DLC Pack 4\nConverted to usermaps by Artyx#Gulch from MW3 DLC Pack 9\nConverted to usermaps by Artyx#Parish from MW3 DLC Pack 9\nConverted to usermaps by Artyx#Liberation from MW3 DLC Pack 1\nConverted to usermaps by Artyx#Lookout from MW3 Faceoff DLC\nConverted to usermaps by Artyx#Decommission from MW3 DLC Pack 7\nConverted to usermaps by Artyx#Vortex from MW3 DLC Pack 6\nConverted to usermaps by Artyx#Tropical Rust custom map\nMap by Revox\nPorted by TMGlion#RustBucket#Subbase from MW2\nPorted by Artyx#Dwarf from COD:OL\nPorted by Artyx#Radiation from BO1\nPorted by Artyx#Kwakelo by Clippy \nPorted by TMG", "#");
    level.mapvoteindices = randomindices();
    replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::finalkillcamhook);
}

finalkillcamhook() {
    if (!IsDefined(level.finalkillcam_winner)) {
        mapvote();
        return false;
    } else {
        level waittill("final_killcam_done");
        mapvote();
        return true;
    }
}

GlowMe() {
	while(isdefined(self)) {
		self FadeOverTime(1);
    	self.color = (1, 0, 0);
    	wait 1;
    	self FadeOverTime(1);
    	self.color = (0, 1, 0);
    	wait 1;
    	self FadeOverTime(1);
    	self.color = (0, 0, 1);
    	wait 1;
	}
}

AngleMover() {
	self endon("disconnect");
	while(isdefined(self)) {
		self setplayerangles((0,self getplayerangles()[1] + 0.05, 0));
		wait 0.05;
	}
}

mapvote() {
    if (!waslastround()) 
    	return;
    if(level.players.size != 0) {
    	foreach(player in level.players) {
    		player VisionSetNakedForPlayer( game["thermal_vision"], 0);
    		player thread AngleMover();
    		if(isdefined(player.WeaponRank))
    			player.WeaponRank destroy();
    		if(isdefined(player.WeaponRankLine))
    			player.WeaponRankLine destroy();
    		if(isdefined(player.WeaponAmmo))
    			player.WeaponAmmo destroy();
    		if(isdefined(player.weaponName))
    			player.weaponName destroy();
    		if(isdefined(player.WeaponAmmoText))
    			player.WeaponAmmoText destroy();
    		if(isdefined(player.WeaponAmmoTextAkimbo))
    			player.WeaponAmmoTextAkimbo destroy();
    		if(isdefined(player.WeaponAmmoTextStock))
    			player.WeaponAmmoTextStock destroy();
    		if(isdefined(player.health_bar))
    			player.health_bar destroy();
    		if(isdefined(player.health_bar_frame))
    			player.health_bar_frame destroy();
    		if(isdefined(player.health_text))
    			player.health_text destroy();
    		if(isdefined(player.namehud))
    			player.namehud destroy();
    		if(isdefined(player.killstreakcounter))
    			player.killstreakcounter destroy();
    	}
    }
   	 
    level.TeamElems["Discord"].fontscale = 1.1;
    level.TeamElems["Discord"].alpha = 0.5;
    level.TeamElems["Discord"] thread GlowMe();
    
    level.mapvoteui[0] = shader("white", "TOP", "TOP", 0, 120, 350, 20, (0.157,0.173,0.161), 1, 1, true);
    level.mapvoteui[1] = shader("white", "TOP", "TOP", 0, 140, 350, 60, (0.310,0.349,0.275), 1, 1, true);
    level.mapvoteui[2] = shader("gradient_top", "TOP", "TOP", 0, 140, 350, 2, (1,1,1), 1, 2, true);
    level.mapvoteui[3] = shader("white", "TOP", "TOP", 0, 200, 350, 20, (0.212,0.231,0.220), 1, 1, true);
    level.mapvoteui[4] = shader("white", "TOP", "TOP", 0, 220, 350, 20, (0.180,0.196,0.188), 1, 1, true);
    level.mapvoteui[5] = shader("white", "TOP", "TOP", 0, 240, 350, 20, (0.212,0.231,0.220), 1, 1, true);
    level.mapvoteui[9] = shader("white", "TOP", "TOP", 0, 260, 350, 20, (0.157,0.173,.161), 1, 1, true);
    level.mapvoteui[10] = shader("white", "TOP", "TOP", 0, 280, 350, 20, (0.310,0.349,0.275), 1, 1, true);
    level.mapvoteui[11] = shader("gradient_top", "TOP", "TOP", 0, 260, 350, 2, (1,1,1), 1, 2, true);
    level.mapvoteui[12] = text(&"VOTING PHASE: ", "LEFT", "TOP", -170, 130, 1, "hudSmall", (1,1,1), 1, 3, true, 15);
    level.mapvoteui[13] = text(maptostring(level.mapvotemaps[level.mapvoteindices[0]]), "LEFT", "TOP", -170, 210, 1.5, "default", (1,1,1), 1, 3, true, 0);
    level.mapvoteui[14] = text(maptostring(level.mapvotemaps[level.mapvoteindices[1]]), "LEFT", "TOP", -170, 230, 1.5, "default", (1,1,1), 1, 3, true, 0);
    level.mapvoteui[15] = text(maptostring(level.mapvotemaps[level.mapvoteindices[2]]), "LEFT", "TOP", -170, 250, 1.5, "default", (1,1,1), 1, 3, true, 0);
    level.mapvoteui[19] = text("Up ^2[{+attack}] ^7Down ^2[{+toggleads_throw}]", "LEFT", "TOP", -170, 270, 1.5, "default", (1,1,1), 1, 3, true);
    level.mapvoteui[20] = text("Vote ^2[{+activate}]", "RIGHT", "TOP", 170, 270, 1.5, "default", (1,1,1), 1, 3, true);
    
    MostKillsSur = newhudelem();
    MostKillsInf = newhudelem();
    
    if(level.players.size != 0) {
    	MostKillsSur.x = 180;
    	MostKillsSur.y = 50;
    	MostKillsSur.alignx = "left";
    	MostKillsSur.horzalign = "fullscreen";
    	MostKillsSur.vertalign = "fullscreen";
    	MostKillsSur.alpha = 1;
    	MostKillsSur.sort = 2;
    	MostKillsSur.color = game["colors"]["allies"];
    	MostKillsSur.archived = true;
    	MostKillsSur.foreground = true;
    	MostKillsSur.fontscale = 1.4;
    	MostKillsSur.hidewheninmenu = true;
    
    	MostKillsInf.x = 460;
    	MostKillsInf.y = 50;
    	MostKillsInf.alignx = "right";
    	MostKillsInf.horzalign = "fullscreen";
    	MostKillsInf.vertalign = "fullscreen";
    	MostKillsInf.alpha = 1;
    	MostKillsInf.sort = 2;
    	MostKillsInf.color = game["colors"]["axis"];
    	MostKillsInf.archived = true;
    	MostKillsInf.foreground = true;
    	MostKillsInf.fontscale = 1.4;
    	MostKillsInf.hidewheninmenu = true;
    
    	infkills = 0;
    	surkills = 0;
    	currenthighestinf = 0;
    	currenthighestsur = 0;
    
    	if(isdefined(level.finalKillCam_attacker["axis"]) && isdefined(level.finalKillCam_attacker["axis"].infectedkills))
    		level.finalKillCam_attacker["axis"].infectedkills += 1;
    
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].infectedkills >= infkills) {
				currenthighestinf = level.players[i];
				if(isdefined(level.players[i].infectedkills))
					infkills = level.players[i].infectedkills;
			}
		}
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].infectedkills > infkills) {
				currenthighestinf = level.players[i];
				if(isdefined(level.players[i].infectedkills))
					infkills = level.players[i].infectedkills;
			}
		}
		if(isdefined(currenthighestinf.name) && isdefined(currenthighestinf.infectedkills) && currenthighestinf.infectedkills != 0)
			MostKillsInf settext("Most Kills | Infected\n"+currenthighestinf.name+" ["+currenthighestinf.infectedkills+" Kills]");
	
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].surviverkills >= surkills) {
				currenthighestsur = level.players[i];
				if(isdefined(level.players[i].surviverkills))
					surkills = level.players[i].surviverkills;
			}
		}
		for(i = 0;i < level.players.size;i++) {
			if(level.players[i].surviverkills > surkills) {
				currenthighestsur = level.players[i];
				if(isdefined(level.players[i].surviverkills))
					surkills = level.players[i].surviverkills;
			}
		}
		if(isdefined(currenthighestsur.name) && isdefined(currenthighestsur.surviverkills) && currenthighestsur.surviverkills != 0)
			MostKillsSur settext("Most Kills | Survivor\n"+currenthighestsur.name+" ["+currenthighestsur.surviverkills+" Kills]");
	}
    
    foreach(player in level.players) player thread input();
    for(i = 0; i <= 15; i++) {
        level.mapvoteui[12] setvalue(15 - i);
        wait 1;
    }
    level notify("mapvote_over");
    besti = 0;
    bestv = -1;
    for(i = 0; i < 3; i++) {
        if(level.mapvoteui[i + 13].value > bestv) {
            besti = i;
            bestv = level.mapvoteui[i + 13].value;
        }
    }

    setdvar("Lastmap3", getdvar("lastmap2"));
    setdvar("Lastmap2", getdvar("lastmap"));
    setdvar("Lastmap", getdvar("mapname"));

    cmdexec("map " + level.mapvotemaps[level.mapvoteindices[besti]]);
    if(isdefined(MostKillsSur))
    	MostKillsSur destroy();
    if(isdefined(MostKillsInf))
    	MostKillsInf destroy();
    wait 5;
}

input() {
    self endon("disconnect");
    self endon("mapvote_over");
    index = 0;
    selected = -1;
    select[0] = self text((index + 1) + "/3", "RIGHT", "TOP", 170, 130, 1.5, "default", (1,1,1), 1, 3, false);
    select[1] = self text(level.mapvotedescs[level.mapvoteindices[index]], "LEFT", "TOP", -170, 150, 1.5, "default", (1,1,1), 1, 3, false);
    select[2] = self shader("gradient_fadein", "TOP", "TOP", 0, 200, 350, 20, (1,1,1), 0.5, 2, false);
    select[3] = self shader("gradient_top", "TOP", "TOP", 0, 220, 350, 2, (1,1,1), 1, 2, false);
    self notifyonplayercommand("up", "+attack");
	self notifyonplayercommand("up", "+forward");
    self notifyonplayercommand("down", "+toggleads_throw");
    self notifyonplayercommand("down", "+speed_throw");
    self notifyonplayercommand("down", "+back");
    self notifyonplayercommand("select", "+usereload");
    self notifyonplayercommand("select", "+activate");
    self notifyonplayercommand("select", "+frag");
    for(;;) {
        command = self waittill_any_return("up", "down", "select");
        if(command == "up") {
            index--;
            if(index < 0)
            {
            index = 2;
            select[2].y += 60;
            select[3].y += 60;
            }
            select[0] settext((index + 1) + "/3");
            select[1] settext(level.mapvotedescs[level.mapvoteindices[index]]);
            select[2].y -= 20;
            select[3].y -= 20;
            self playlocalsound("mouse_over");
        } else if(command == "down") {
            index++;
            if(index > 2)
            {
            index = 0;
            select[2].y -= 60;
            select[3].y -= 60;
            }
            select[0] settext((index + 1) + "/3");
            select[1] settext(level.mapvotedescs[level.mapvoteindices[index]]);
            select[2].y += 20;
            select[3].y += 20;
            self playlocalsound("mouse_over");
            
        } else if(command == "select") {
            if(selected == -1) {
                selected = index;
                level.mapvoteui[selected + 13].value += 1;
                level.mapvoteui[selected + 13] setvalue(level.mapvoteui[selected + 13].value);
                self playlocalsound("mouse_click");
            } else if(selected != index) {
                level.mapvoteui[selected + 13].value -= 1;
                level.mapvoteui[selected + 13] setvalue(level.mapvoteui[selected + 13].value);
                selected = index;
                level.mapvoteui[selected + 13].value += 1;
                level.mapvoteui[selected + 13] setvalue(level.mapvoteui[selected + 13].value);
                self playlocalsound("mouse_click");
            }
        }
    }
}

text(text, align, relative, x, y, fontscale, font, color, alpha, sort, server, value) {
    element = spawnstruct();
    if(server) {
        element = createserverfontstring(font, fontscale);
    } else {
        element = self createfontstring(font, fontscale);
    }
    if(isdefined(value)) {
        element.label = text;
        element.value = value;
        element setvalue(value);
    } else {
        element settext(text);
    }
    element.hidewheninmenu = true;
    element.color = color;
    element.alpha = alpha;
    element.sort = sort;
    element setpoint(align, relative, x, y);
    return element;
}

shader(shader, align, relative, x, y, width, height, color, alpha, sort, server) {
    element = spawnstruct();
    if(server) {
        element = newhudelem(self);
    } else {
        element = newclienthudelem(self);
    }
    element.elemtype = "icon";
    element.hidewheninmenu = true;
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.align = align;
    element.relative = relative;
    element.xoffset = 0;
    element.yoffset = 0;
    element.children = [];
    element.sort = sort;
    element.color = color;
    element.alpha = alpha;
    element setparent(level.uiparent);
    element setshader(shader, width, height);
    element setpoint(align, relative, x, y);
    return element;
}

randomindices() {
    array = [];
    for (i = 0; i < 3; i++) 
    {
        array[i] = randomint(level.mapvotemaps.size);

        goodmap = false;
        while(!goodmap)
        {
            pog = false;
            //iprintln(level.mapvotemaps[array[i]] + " ^5Start");

            if(level.mapvotemaps[array[i]] == getdvar("mapname") && !pog)
            {
                array[i] = randomint(level.mapvotemaps.size);
                //iprintln("^1Same Map Picked ___");
                pog = true;
            }
            if(level.mapvotemaps[array[i]] == getdvar("Lastmap") && !pog)
            {
                array[i] = randomint(level.mapvotemaps.size);
                //iprintln("^1Lastmap ___");
                pog = true;
            }
            if(level.mapvotemaps[array[i]] == getdvar("Lastmap2") && !pog)
            {
                array[i] = randomint(level.mapvotemaps.size);
                //iprintln("^1Lastmap2 ___");
                pog = true;
            }
            if(level.mapvotemaps[array[i]] == getdvar("Lastmap3") && !pog)
            {
                array[i] = randomint(level.mapvotemaps.size);
                //iprintln("^1Lastmap3 ___");
                pog = true;
            }
            //iprintln(level.mapvotemaps[array[i]] + " ^6End");
            if(!pog)
            {
            //iprintln("^2Actual Good Map");
            goodmap = true;
            }
            //else
            //iprintln("^3Go Agane");
        }
        //iprintln(level.mapvotemaps[array[i]]);
        
        for (j = 0; j < i; j++) {
            if (array[i] == array[j]) {
                i--;
                break;
            }
        }
    }
    return array;
}

maptostring(map) {
    switch(map) {
    case "mp_alpha": return &"LOCKDOWN: ";
    case "mp_bootleg": return &"BOOTLEG: ";
    case "mp_bravo": return &"MISSION: ";
    case "mp_carbon": return &"CARBON: ";
    case "mp_dome": return &"DOME: ";
    case "mp_exchange": return &"DOWNTURN: ";
    case "mp_hardhat": return &"HARDHAT: ";
    case "mp_interchange": return &"INTERCHANGE: ";
    case "mp_lambeth": return &"FALLEN: ";
    case "mp_mogadishu": return &"BAKAARA: ";
    case "mp_paris": return &"RESISTANCE: ";
    case "mp_plaza2": return &"ARKADEN: ";
    case "mp_radar": return &"OUTPOST: ";
    case "mp_seatown": return &"SEATOWN: ";
    case "mp_underground": return &"UNDERGROUND: ";
    case "mp_village": return &"VILLAGE: ";
    case "mp_terminal_cls": return &"TERMINAL: ";
    case "mp_rust": return &"RUST: ";
    case "mp_highrise": return &"HIGHRISE: ";
    // case "mp_park": return &"LIBERATION ^2[DLC]^7: ";
    // case "mp_overwatch": return &"OVERWATCH ^2[DLC]^7: ";
    // case "mp_morningwood": return &"BLACK BOX ^2[DLC]^7: ";
    // case "mp_meteora": return &"SANCTUARY ^2[DLC]^7: ";
    // case "mp_restrepo_ss": return &"LOOKOUT ^2[DLC]^7: ";
    // case "mp_hillside_ss": return &"GETAWAY ^2[DLC]^7: ";
    case "mp_courtyard_ss": return &"EROSION: ";
    case "mp_aground_ss": return &"AGROUND: ";
    /*case "mp_six_ss": return &"VORTEX ^2[DLC]^7: ";
    case "mp_burn_ss": return &"U-TURN ^2[DLC]^7: ";
    case "mp_crosswalk_ss": return &"INTERSECTION ^2[DLC]^7: ";
    case "mp_shipbreaker": return &"DECOMMISSION ^2[DLC]^7: ";
    case "mp_roughneck": return &"OFF SHORE ^2[DLC]^7: ";
    case "mp_moab": return &"GULCH ^2[DLC]^7: ";
    case "mp_boardwalk": return &"BOARDWALK ^2[DLC]^7: ";
    case "mp_nola": return &"PARISH ^2[DLC]^7: ";*/
    case "mp_favela": return &"FAVELA: ";
    case "mp_nuked": return &"NUKETOWN: ";
    case "mp_nightshift": return &"SKIDROW: ";
    /*
    case "mp_abandon": return &"CARNIVAL ^1[CUSTOM MAP]^7: ";
    case "mp_rats": return &"RATS ^1[CUSTOM MAP]^7: ";
    case "mp_qadeem": return &"OASIS ^2[DLC]^7: ";
    case "mp_showdown_sh": return &"SHOWDOWN ^1[CUSTOM MAP]^7: ";
    case "mp_geometric": return &"GEOMETRIC ^1[CUSTOM MAP]^7: ";
    case "mp_complex": return &"BAILOUT ^1[CUSTOM MAP]^7: ";
    case "mp_boneyard": return &"SCRAPYARD ^1[CUSTOM MAP]^7: ";
    case "mp_convoy": return &"AMBUSH ^1[CUSTOM MAP]^7: ";
    case "mp_fav_tropical": return &"TROPICAL FAVELA ^1[CUSTOM MAP]^7: ";
    case "mp_italy": return &"PIAZZA ^2[DLC]^7: ";
    case "mp_storm": return &"STORM ^1[CUSTOM MAP]^7: ";
    case "mp_stickline": return &"LIL STICK'S PIPELINE ^1[CUSTOM MAP]^7: ";
    case "mp_cement": return &"FOUNDATION ^2[DLC]^7: ";
    case "mp_trop_rust": return &"TROPICAL RUST ^1[CUSTOM MAP]^7: ";
    case "mp_rustbucket": return &"RUSTBUCKET ^1[CUSTOM MAP]^7: ";
    case "mp_subbase": return &"SUBBASE ^1[CUSTOM MAP]^7: ";
    case "mp_dwarf_sh": return &"DWARF ^1[CUSTOM MAP]^7: ";
    case "mp_radiation_sh": return &"RADIATION ^1[CUSTOM MAP]^7: ";
    case "mp_kwakelo": return &"KWAKELO ^1[CUSTOM MAP]^7: ";
    */
    default: return &"MAP: ";
    }
}
