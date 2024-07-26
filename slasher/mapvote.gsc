#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    precacheshader("gradient_fadein");
    precacheshader("gradient_top");
    precacheshader("white");
    
    level.mapvotemaps = strtok("mp_alpha#mp_bootleg#mp_bravo#mp_carbon#mp_dome#mp_hardhat#mp_lambeth#mp_mogadishu#mp_paris#mp_seatown#mp_underground#mp_village#mp_terminal_cls#mp_rust#mp_courtyard_ss#mp_aground_ss#mp_favela#mp_boneyard#mp_roughneck#mp_quarry#mp_showdown_sh#mp_overwatch#mp_moab#mp_meteora#mp_cargoship_sh#mp_crash_snow#mp_overgrown#mp_rust_long#mp_citystreets#mp_kwakelo#mp_rustbucket", "#");
    //level.mapvotedescs = strtok("European city center. Great for Team \nDefender.#Medium sized Asian market. Fun for all game \nmodes.#African colonial settlement. Fight to control \nthe center.#Medium sized refinery. Great for any number \nof players.#Small outpost in the desert. Fast and frantic \naction.#Destroyed freeway. Great for a wide range of \nspaces and styles.#Derelict Russian ghost town. Great for \ncareful, tactical engagements.#Crash site in an African city. Classic urban \ncombat.#Parisian district. Great for Domination and Kill \nConfirmed.#Medium sized German mall. Intense Search & \nDestroy games.#A costal town. Narrow streets bring hectic, \nclose encounters.#Small subway station. Fast paced action both \ninside and out.#Large African village. Great for all game \nmodes.#Russian airport terminal under siege. The \nclassic fan favorite is back.#Tiny desert sandstorm. Fast-paced action on \na small map.#A small coastal Italian town. Features tight \nclose quarter combat.#Roman ruins near Mt. Vesuvius. Strong \ninteriors offset by multi-level flanks.#Shipwreck on the irish coast. Open layout \nallows for long distance engagements#Alleyways of Brazil. Great for all game modes\nand all sizes.#Small airplane graveyard. Great for any number of players.#Off Shore from MW3 DLC Pack 7\nConverted to usermaps by Artyx#Showdown from CoD: Online\nPorted by Brent.#Overwatch from MW3 DLC Pack 2\nConverted to usermaps by Artyx#Gulch from MW3 DLC Pack 9\nConverted to usermaps by Artyx#Sanctuary from MW3 DLC Pack 4\nConverted to usermaps by Artyx#Freighter, snow version of wet work\nfrom cod online\nPorted by Artyx#Winter Crash from cod4\nPorted by Artyx#Overgrown from cod4\nPorted by Artyx#Rust Long from cod online\nPorted by Artyx#District from cod4\nPorted by Artyx", "#");
    level.mapvoteindices = randomindices();
    
    replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::finalkillcamhook);

    setDvarIfUninitialized("Lastmap", "none");
    setDvarIfUninitialized("Lastmap2", "none");
    setDvarIfUninitialized("Lastmap3", "none");
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

mapvote() {
    level.mapvoteui[0] = shader("white", "TOP", "TOP", 0, 120, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[1] = shader("white", "TOP", "TOP", 0, 140, 350, 60, (0.15,0.15,0.15), 1, 1, true);
    level.mapvoteui[2] = shader("gradient_top", "TOP", "TOP", 0, 140, 350, 2, (1,0,0), 1, 2, true);
    level.mapvoteui[3] = shader("white", "TOP", "TOP", 0, 200, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[4] = shader("white", "TOP", "TOP", 0, 220, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[5] = shader("white", "TOP", "TOP", 0, 240, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[9] = shader("white", "TOP", "TOP", 0, 260, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[10] = shader("white", "TOP", "TOP", 0, 280, 350, 20, (0.1,0.1,0.1), 1, 1, true);
    level.mapvoteui[11] = shader("gradient_top", "TOP", "TOP", 0, 260, 350, 2, (1,0,0), 1, 2, true);
    level.mapvoteui[12] = text(&"VOTING PHASE: ", "LEFT", "TOP", -170, 130, 0.70, "bigfixed", (1,0,0), 1, 3, true, 15);
    level.mapvoteui[13] = text(maptostring(level.mapvotemaps[level.mapvoteindices[0]]), "LEFT", "TOP", -170, 210, 0.60, "bigfixed", (1,0,0), 1, 3, true, 0);
    level.mapvoteui[14] = text(maptostring(level.mapvotemaps[level.mapvoteindices[1]]), "LEFT", "TOP", -170, 230, 0.60, "bigfixed", (1,0,0), 1, 3, true, 0);
    level.mapvoteui[15] = text(maptostring(level.mapvotemaps[level.mapvoteindices[2]]), "LEFT", "TOP", -170, 250, 0.60, "bigfixed", (1,0,0), 1, 3, true, 0);
    level.mapvoteui[19] = text("Up:  ^3[{+attack}]   ^7|   Down:  ^3[{+toggleads_throw}]", "LEFT", "TOP", -170, 275, 0.55, "bigfixed", (1,0,0), 1, 3, true);
    level.mapvoteui[20] = text("Vote:    ^3[{+activate}]", "RIGHT", "TOP", 170, 275, 0.55, "bigfixed", (1,0,0), 1, 3, true);
    
    foreach(player in level.players) 
    	player thread input();
    
    MVP_Title = newhudelem();
    MVP = newhudelem();
    
    MVP_Title.x = 320;
    MVP_Title.y = 70;
    MVP_Title.alignx = "center";
    MVP_Title.horzalign = "fullscreen";
    MVP_Title.vertalign = "fullscreen";
    MVP_Title.alpha = 1;
    MVP_Title.sort = 2;
    MVP_Title.font = "objective";
    MVP_Title.archived = true;
    MVP_Title.color = level.ui_better_red;
    MVP_Title.foreground = true;
    MVP_Title.fontscale = 1.4;
    MVP_Title settext("Player of the Game");
    MVP_Title thread GlowMe();
    
    MVP.x = 320;
    MVP.y = 85;
    MVP.alignx = "center";
    MVP.horzalign = "fullscreen";
    MVP.vertalign = "fullscreen";
    MVP.alpha = 1;
    MVP.sort = 2;
    MVP.font = "objective";
    MVP.color = (1,1,1);
    MVP.archived = true;
    MVP.foreground = true;
    MVP.fontscale = 1.2;
    
    highestscore = 0;
    playersaved = "";
    
    for(i = 0;i < level.players.size;i++) {
    	if(level.players[i].score > highestscore) {
    		playersaved = level.players[i];
    		highestscore = level.players[i].score;
    	}
    }
    
    for(i = 0;i < level.players.size;i++) {
    	if(level.players[i].score > highestscore) {
    		playersaved = level.players[i];
    		highestscore = level.players[i].score;
    	}
    }
    if(isdefined(playersaved))
    	MVP settext(playersaved.name + " ^3" + playersaved.score + " Points");
    
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
    //Note: We wait to prevent the scoreboard popping up at the end for a cleaner transition (Don't wait infinitely as a failsafe).
    //TODO: Proper manipulation of sv_maprotation is the better way to do this as it would allow the final scoreboard to show.
    cmdexec("map " + level.mapvotemaps[level.mapvoteindices[besti]]);
    //cmdexec("map mp_rust");
    wait 5;
}

GlowMe() {
	while(isdefined(self)) {
		self FadeOverTime(2);
    	self.color = (1, 0, 0);
    	wait 2;
    	self FadeOverTime(1);
    	self.color = (0, 0, 0);
    	wait 1;
    	self FadeOverTime(2);
    	self.color = (1, 0, 1);
    	wait 2;
	}
}

FreezeMe() {
	self endon("disconnect");
	
	self hide();
	while(1) {
		self freezecontrols(true);
		
		if(isdefined(self.someText3)) {
			self.someText3 destroy();
			self notify("endthis");
		}
		if(isdefined(self.GhostText))
			self.GhostText destroy();
		wait .10;
	}
}

input() {
    self endon("disconnect");
    self endon("mapvote_over");
    
    self thread FreezeMe();
    
    index = 0;
    selected = -1;
    select[0] = self text((index + 1) + "/3", "RIGHT", "TOP", 170, 130, 0.70, "bigfixed", (1,0,0), 1, 3, false);
    select[1] = self text("Michael Myers Mod By\n^1Wiizard^7, ^1Clippy^7, ^1ZECxR3ap3r", "LEFT", "TOP", -170, 150, 1.5, "default", (1,0,0), 1, 3, false);
    select[2] = self shader("gradient_fadein", "TOP", "TOP", 0, 200, 350, 20, (1,0,0), 0.5, 2, false);
    select[3] = self shader("gradient_top", "TOP", "TOP", 0, 220, 350, 2, (1,0,0), 1, 2, false);
    
    self.sessionstate = "playing";
    self allowSpectateTeam( "allies", false );
	self allowSpectateTeam( "axis", false );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", true );
    self freezecontrols(true);
    
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
    element.glowcolor = (0,0,0);
    element.glowalpha = 1;
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
    for (i = 0; i < 3; i++) {
        array[i] = randomint(level.mapvotemaps.size);
        //iprintln(level.mapvotemaps[array[i]]);
        if(level.mapvotemaps[array[i]] == getdvar("mapname"))
        {
            array[i] = randomint(level.mapvotemaps.size);
            //iprintln(level.mapvotemaps[array[i]]);
            //iprintln("^1Same Map Picked ^^^^^");
        }
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
        case "mp_roughneck": return &"OFF SHORE: ";
        case "mp_highrise": return &"HIGHRISE: ";
        case "mp_italy": return &"PIAZZA: ";
        case "mp_courtyard_ss": return &"EROSION: ";
        case "mp_aground_ss": return &"AGROUND: ";
        case "mp_favela": return &"FAVELA: ";
        case "mp_nightshift": return &"SKIDROW: ";
        case "mp_boneyard": return &"SCRAPYARD: ";
        case "mp_quarry": return &"QUARRY: ";
        case "mp_showdown_sh": return &"SHOWDOWN: ";
        case "mp_fav_tropical": return &"FAVELA TROPICAL: ";
        case "mp_overwatch": return &"OVERWATCH: ";
        case "mp_moab": return &"GULCH: ";
        case "mp_meteora": return &"SANCTUARY: ";
		case "mp_cargoship_sh": return &"FREIGHTER: ";
		case "mp_crash_snow": return &"WINTER CRASH: ";
		case "mp_overgrown": return &"OVERGROWN: ";
		case "mp_rust_long": return &"RUST LONG: ";
		case "mp_citystreets": return &"DISTRICT: ";
        case "mp_kwakelo": return &"KWAKELO: ";
        case "mp_rustbucket": return &"RUSTBUCKET ^1[CUSTOM MAP]^7: ";
        default: return &"MAP: ";
    }
}






















