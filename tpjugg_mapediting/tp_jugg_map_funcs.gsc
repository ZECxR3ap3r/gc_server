#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
    level._meat_location_center = (0,0,0);

    level.mapname = getdvar("ui_mapname");
    level.curObjID = 1;
    level.usables = [];
    level.teleporter_ents = [];
}

delete_remote_spawnpoints() {
	if(isdefined(level.use_stock_predator_system))
		return;

    remoteMissileSpawnArray = getEntArray( "remoteMissileSpawn" , "targetname" );
	foreach ( spawn in remoteMissileSpawnArray )
	{
		spawn delete();
	}
}

oomzonehud() {
    if(!isdefined(self.oom_hud)) {
    	self.oom_hud = newclienthudelem(self);
    	self.oom_hud.horzalign = "fullscreen";
    	self.oom_hud.vertalign = "fullscreen";
    	self.oom_hud.alignx = "center";
    	self.oom_hud.aligny = "top";
    	self.oom_hud.x = 320;
    	self.oom_hud.y = 210;
    	self.oom_hud.alpha = 0;
    	self.oom_hud.archived = 0;
    	self.oom_hud.fontscale = 1.05;
    	self.oom_hud.font = "hudbig";
    	self.oom_hud.label = &"^3";
    }
}

CreateHiddenTP(enter, exit, angle, setStatus, slowed, radius, height, delay) {
    thread CreateHiddenTPthread(enter, exit, angle, setStatus, slowed, radius, height, delay);
}

CreateHiddenTPthread(enter, exit, angle, setStatus, slowed, radius, height, delay) {
if(isdefined(delay))
        wait delay;
		
    setStatus = isDefined(setStatus) ? setStatus : undefined;

    ent1 = spawn("script_model", enter + (0,0,46));
    ent1 setModel("projectile_cbu97_clusterbomb");
    ent1.angles = (-90,0,0);
    ent1 thread keeprotating();

    ent2 = spawn("script_model", exit - (0,0,44));
    ent2 setModel("projectile_javelin_missile");
    ent2.angles = (-90,0,0);
    ent2 thread keeprotating();

    level.teleporter_ents[level.teleporter_ents.size] = ent2;

    level.curObjId+=1;
    nobj = level.curObjId;
    v5 = 31 - nobj;
    fx = undefined;
    objective_add(v5, "active");
    if(isdefined(setstatus) && setstatus == "out") {
        fx = SpawnFX(level.spawnGlow["enemy"] , enter + (0,0,80));
        objective_icon(v5, "waypoint_flag_enemy");
    }
    else {
        fx = SpawnFX(level.spawnGlow["friendly"] , enter + (0,0,80));
        objective_icon(v5, "waypoint_flag_friendly");
    }
    objective_position(v5, ent1.Origin);
    TriggerFX(fx);

    level thread HiddenTpThread(enter, exit, angle, setStatus, slowed, radius, height);
}

keeprotating() {
    level endon("game_ended");

    for(;;) {
        self RotateYaw(360, 5);
        wait 5;
    }
}

HiddenTpThread(enter, exit, angle, setStatus, slowed, radius, height){
    level endon("game_ended");

    if(!isdefined(radius))
        radius = 50;
    if(!isdefined(height))
        height = 100;

    trigger = Spawn( "trigger_radius", enter, 0, radius, height);

    for(;;) {
        trigger waittill( "trigger", player);

        player setorigin(exit);
        if(isdefined(angle))
            player setplayerangles((player getplayerangles()[0], angle[1], 0));
        if(isdefined(slowed))
            player thread freezeontp();
        if(isDefined(setStatus)) {
            player.status = setStatus;

            if(player.oom_hud.alpha == 1) { // needs changing
            	player notify("flag_teleport");
           		player.inoomzone = 0;
    			player.oomAttempts = 0;
    			player SetBlurForPlayer(0, 0);
			}
        }
    }
}

CreateTP(enter, exit, angle, slowed, radius, height, delay, noradar) {
    thread CreateTPthread(enter, exit, angle, slowed, radius, height, delay, noradar);
}

CreateTPthread(enter, exit, angle, slowed, radius, height, delay, noradar) {
    if(isdefined(delay))
        wait delay;

    entity = spawn( "script_model",enter);
	
	if(!isdefined(noradar)) {
    	level.curObjId+=1;
		nobj = level.curObjId;
		v5 = 31 - nobj;
		objective_add(v5, "active");
		objective_position(v5, entity.Origin);
	}
    entity setModel(getAlliesFlagModel(level.mapname));
    entity2 = spawn("script_model", exit);
    entity2 setmodel("tag_origin");

    level.teleporter_ents[level.teleporter_ents.size] = entity2;

    level thread TpThread(enter, exit, angle, slowed, radius, height);
}

TpThread(enter, exit, angle, slowed, radius, height){
    level endon("game_ended");

    if(!isdefined(radius))
        radius = 50;
    if(!isdefined(height))
        height = 100;

    trigger = Spawn( "trigger_radius", enter, 0, radius, height );

    for(;;) {
        trigger waittill("trigger", player );

        player setorigin(exit);

        if(isdefined(angle))
            player setplayerangles((player getplayerangles()[0], angle[1], 0));
        if(isdefined(slowed))
            player thread freezeontp();

        player.status = "in";
    }
}

freezeontp() {
    self freezecontrols(1);
    wait .1;
    self freezecontrols(0);
}

CreateRamps(start, end, angles, delay) {
    thread CreateRampsthread(start, end, angles, delay, "com_plasticcase_friendly");
}

CreateInvisRamps(start, end, angles, delay) {
	if(!isdefined(level.showinviscrates))
    	thread CreateRampsthread(start, end, angles, delay, undefined);
	else
   		thread CreateRampsthread(start, end, angles, delay, "com_plasticcase_trap_bombsquad");
}

CreateRedRamps(start, end, angles, delay) {
    thread CreateRampsthread(start, end, angles, delay, "com_plasticcase_enemy");
}

CreateTrapRamps(start, end, angles, delay) {
    thread CreateRampsthread(start, end, angles, delay, "com_plasticcase_trap_friendly");
}

CreateBombsquadRamps(start, end, angles, delay) {
    thread CreateRampsthread(start, end, angles, delay, "com_plasticcase_trap_bombsquad");
}

CreateRampsthread(top, bottom, angles, delay, model) {
	if(isdefined(delay))
		wait delay;

    num2 = Int(ceil(Distance(top, bottom) / 30));
    vector = ((top[0] - bottom[0]) / num2, (top[1] - bottom[1]) / num2, (top[2] - bottom[2]) / num2);
    vector2 = vectortoangles(top - bottom);
    
    if(!isdefined(angles))
        angles = (vector2[2], vector2[1] + 90, vector2[0]);

    entity = spawn("script_origin", vector);

    for (i = 0; i <= num2; i++) {
        if(isdefined(model))
            ent = spawncrate(bottom + (vector * i), angles, model);
        else
            ent = spawncrate(bottom + (vector * i), angles);

        ent linkto(entity);
    }
}

CreateTurret(origin, angles, left, right, bottom, top, droppitch, delay) {
    thread CreateTurretthread(origin, angles, left, right, bottom, top, droppitch, delay);
}

CreateTurretthread(origin, angles, left, right, bottom, top, droppitch, delay) {
	if(isdefined(delay))
		wait delay;

    entity = spawnTurret("misc_turret", origin, "remote_turret_mp");
    entity setmodel("weapon_minigun");
    entity.angles = angles;
    entity sethintstring(&"PLATFORM_HOLD_TO_USE");

    if(isdefined(left)) entity SetLeftArc( left ); else entity SetLeftArc( 60 );
    if(isdefined(right)) entity SetRightArc( right ); else entity SetRightArc( 60 );
    if(isdefined(bottom)) entity SetBottomArc( bottom ); else entity SetBottomArc( 35 );
	if(isdefined(top)) entity SetTopArc( top ); else entity SetTopArc( 25 );
    if(isdefined(droppitch)) entity SetDefaultDropPitch( droppitch ); else entity SetDefaultDropPitch( .0 );
}

createwalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, "com_plasticcase_friendly", angles, delay);
}

CreateInvisWalls(start, end, angles, delay) {
	if(!isdefined(level.showinviscrates))
    	thread CreateWallthread(start, end, undefined, angles, delay);
	else
    	thread CreateWallthread(start, end, "com_plasticcase_trap_bombsquad", angles, delay);
}

CreateRedWalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, "com_plasticcase_enemy", angles, delay);
}

CreateTrapWalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, "com_plasticcase_trap_friendly", angles, delay);
}

CreateBombsquadWalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, "com_plasticcase_trap_bombsquad", angles, delay);
}

CreateWallthread(start, end, model, angles, delay) {
	if(isdefined(delay))
		wait delay;

    D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
    H = Distance((0, 0, start[2]), (0, 0, end[2] + 1));
    blocks = round(D/55);
    height = round(H/30);
    CX = end[0] - start[0];
    CY = end[1] - start[1];
    CZ = end[2] - start[2];

    if(CX == 0) {
        XA = 0;
	    TXA = 0;
    }
	else {
	    XA = (CX/blocks);
        TXA = (XA/4);
    }

    if(CY == 0) {
        YA = 0;
	    TYA = 0;
    }
	else {
	    YA = (CY/blocks);
        TYA = (YA/4);
    }

    if(CZ == 0)
		ZA =  CZ;
	else
		ZA = (CZ/height);

    Temp = VectorToAngles(end - start);

    if(isdefined(angles))
        Angle = angles;
    else
        Angle = (0, Temp[1], 90);

    for(h = 0; h < height; h++) {
    	block = spawnCrate((start + (TXA, TYA, 10) + ((0, 0, ZA) * h)), Angle, model);
        wait .05;
        for(i = 1; i < blocks; i++) {
       		block = spawnCrate((start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)), Angle, model);
            wait .05;
        }
        block = spawnCrate((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h), Angle, model);
        wait .05;
    }
}

CreateQuicksteps(position, height, stepsize, distperstep, angles, delay) {
    thread CreateQuickstepsthread(position, height, stepsize, distperstep, angles, delay, "com_plasticcase_friendly");
}

CreateInvisQuicksteps(position, height, stepsize, distperstep, angles, delay) {
	if(!isdefined(level.showinviscrates))
    	thread CreateQuickstepsthread(position, height, stepsize, distperstep, angles, delay);
	else
		thread CreateQuickstepsthread(position, height, stepsize, distperstep, angles, delay, "com_plasticcase_trap_bombsquad");
}

CreateQuickstepsthread(position, height, stepsize, distperstep, angles, delay, model) {
	if(isdefined(delay))
		wait delay;

    crates = round((height/stepsize));
    forang = AnglesToForward(angles);

    for(i = 0;i < crates;i++) {
        if(isdefined(model))
            block = spawnCrate((position + (forang * distperstep) * i) - (0,0,stepsize) * i, angles + (0,90,0), "com_plasticcase_friendly");
        else
            block = spawnCrate((position + (forang * distperstep) * i) - (0,0,stepsize) * i, angles + (0,90,0));

        wait .05;
    }
}

CreateMovingBlock(origin, goalpos, angle, time, wait_time, rotate_to, delay) {
    thread CreateMovingBlockThread(origin, goalpos, angle, time, wait_time, rotate_to, delay);
}

CreateMovingBlockThread(origin, goalpos, angle, time, wait_time, rotate_to, delay) {
    if(isdefined(delay))
		wait delay;
    
    block = spawnCrate(origin, angle, "com_plasticcase_enemy");
    for(;;) {
        block moveto(goalpos, time);
        if(isdefined(rotate_to))
            block RotateTo(rotate_to, time);
        wait time;
        wait wait_time;
        block moveto(origin, time);
        if(isdefined(rotate_to))
            block RotateTo(angle, time);
        wait time;
        wait wait_time;
    }
}

CreateElevator(corner1, corner2, totalheight, time, angle, delay, goalpos) {
    thread CreateElevatorthread(corner1, corner2, totalheight, time, angle, delay, goalpos);
}

CreateElevatorthread(corner1, corner2, totalheight, time, angle, delay, goalpos) {
	if(isdefined(delay))
		wait delay;

    W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0));
    L = Distance((0, corner1[1], 0), (0, corner2[1], 0));
    CX = corner2[0] - corner1[0];
    CY = corner2[1] - corner1[1];
    ROWS = round(W/55);
    COLUMNS = round(L/30);

    if(CX == 0)
		XA = CX;
	else
		XA = (CX/ROWS);

	if(CY == 0)
		YA = CY;
	else
		YA = (CY/COLUMNS);

    center = spawn("script_origin", corner1);
    center.blocks = [];
    for(r = 0; r <= ROWS; r++){
        for(c = 0; c <= COLUMNS; c++){
            block = spawnCrate((corner1 + (XA * r, YA * c, 0)), (0,0,0), "com_plasticcase_enemy");
            block linkto(center);
            center.blocks[center.blocks.size] = block;
            wait .05;
        }
    }

    if(!isdefined(angle))
        center.angles = (0,0,0);
    else
        center.angles = angle;

    wait 1;

    while(1) {
    	wait 2.5;

    	foreach(player in level.players) {
    		foreach(ent in center.blocks) {
    			if(distance(player.origin, ent.origin) < 30 && !player islinked()) {
    				player setorigin((player.origin[0], player.origin[1], center.origin[2] + 15));
    				player playerlinkto(ent);
    				player playerLinkedOffsetEnable();
    			}
    		}
    	}

    	wait .05;

    	if(isdefined(goalpos))
    		center moveto(goalpos, time);
    	else
    		center MoveTo(corner1 + (0,0, totalheight), time);

        wait time;
        wait .05;

        foreach(player in level.players) {
    		foreach(ent in center.blocks) {
    			if(distance(player.origin, ent.origin) < 55 && player islinked()) {
    				player unlink();
    				player setorigin((player.origin[0], player.origin[1], center.origin[2] + 20));
    			}
    		}
    	}

        wait 2.5;

        if(isdefined(goalpos)) {
            foreach(player in level.players) {
                foreach(ent in center.blocks) {
                    if(distance(player.origin, ent.origin) < 30 && !player islinked()) {
                        player setorigin((player.origin[0], player.origin[1], center.origin[2] + 15));
                        player playerlinkto(ent);
                        player playerLinkedOffsetEnable();
                    }
                }
            }
        }

    	wait .05;

    	center moveto(corner1, time);

        wait time;
        wait .05;

        if(isdefined(goalpos)) {
            foreach(player in level.players) {
                foreach(ent in center.blocks) {
                    if(distance(player.origin, ent.origin) < 55 && player islinked()) {
                        player unlink();
                        player setorigin((player.origin[0], player.origin[1], center.origin[2] + 20));
                    }
                }
            }
        }
    }
}

spawnmodel(origin, angles, model) {
    entity = spawn("script_model", origin);
    if(isdefined(model))
    	entity setmodel(model);
    entity.angles = angles;

    return entity;
}

fufalldamage(position, range, height) { // this needs checking
    if(!isdefined(level.falldamagetriggers))
        level.falldamagetriggers = [];

    level.falldamagetriggers[level.falldamagetriggers.size] = Spawn( "trigger_radius", position, 0, range, height);
}

CreateGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, "com_plasticcase_friendly", angle, delay);
}

CreateInvisGrids(corner1, corner2, angle, delay) {
	if(!isdefined(level.showinviscrates))
    	thread CreateGridsThread(corner1, corner2, undefined, angle, delay);
	else
		thread CreateGridsThread(corner1, corner2, "com_plasticcase_trap_bombsquad", angle, delay);
}

CreateRedGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, "com_plasticcase_enemy", angle, delay);
}

CreateTrapGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, "com_plasticcase_trap_friendly", angle, delay);
}

CreateBombsquadGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, "com_plasticcase_trap_bombsquad", angle, delay);
}

CreateGridsThread(corner1, corner2, model, angle, delay) {
	if(isdefined(delay))
		wait delay;

	W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0));
	L = Distance((0, corner1[1], 0), (0, corner2[1], 0));
	H = Distance((0, 0, corner1[2]), (0, 0, corner2[2]));
	CX = corner2[0] - corner1[0];
	CY = corner2[1] - corner1[1];
	CZ = corner2[2] - corner1[2];
	ROWS = round(W/55);
	COLUMNS = round(L/30);
	HEIGHT = round(H/20);

	if(CX == 0)
		XA = CX;
	else
		XA = (CX/ROWS);

	if(CY == 0)
		YA = CY;
	else
		YA = (CY/COLUMNS);

	if(CZ == 0)
		ZA =  CZ;
	else
		ZA = (CZ/HEIGHT);

	center = spawn("script_model", corner1);

        for(r = 0; r <= ROWS; r++) {
            for(c = 0; c <= COLUMNS; c++) {
                for(h = 0; h <= HEIGHT; h++) {
                    block = spawnCrate((corner1 + (XA * r, YA * c, ZA * h)), (0,0,0), model);
                    block LinkTo(center);
                    wait .05;
                }
            }
	    }
	center.angles = angle;
}

CreateDoors(open, close, angle, size, height, hp, range, side, delay, model) {
    thread CreateDoorsthread(open, close, angle, size, height, hp, range, side, delay, model);
}

CreateDoorsthread(open, close, angle, size, height, hp, range, side, delay, model) {
	if(isdefined(delay))
		wait delay;

    offset = (((size / 2)- .5) * -1);
	center = spawn("script_model", open);
	center.linked_ents = [];

    if(isdefined(side)) {
        for(j=0;j < size;j++) {
            if(!isdefined(model))
                door = spawnCrate(open + ((0,55,0) * offset), (0,90,0), "com_plasticcase_enemy");
            else
                door = spawnCrate(open + ((0,55,0) * offset), (0,90,0), model);

            center.linked_ents[center.linked_ents.size] = door;
            door LinkTo(center);

            for(h=1;h < height;h++) {
                if(!isdefined(model))
                    door = spawnCrate(open + ((0,55,0) * offset)-((50,0,0) * h), (0,90,0), "com_plasticcase_enemy");
                else
                    door = spawnCrate(open + ((0,55,0) * offset)-((50,0,0) * h), (0,90,0), model);

                center.linked_ents[center.linked_ents.size] = door;
                door LinkTo(center);
            }
            offset += 1;
        }
    }
    else {
        for(j=0;j < size;j++) {
            if(!isdefined(model))
                door = spawnCrate(open + ((0,30,0) * offset), (0,0,0), "com_plasticcase_enemy");
            else
                door = spawnCrate(open + ((0,30,0) * offset), (0,0,0), model);

            center.linked_ents[center.linked_ents.size] = door;
            door LinkTo(center);

            for(h=1;h < height;h++) {
                if(!isdefined(model))
                    door = spawnCrate(open + ((0,30,0) * offset)-((70,0,0) * h), (0,0,0), "com_plasticcase_enemy");
                else
                    door = spawnCrate(open + ((0,30,0) * offset)-((70,0,0) * h), (0,0,0), model);

                center.linked_ents[center.linked_ents.size] = door;
                door LinkTo(center);
            }
            offset += 1;
        }
    }

	center.angles           = angle;
	center.state            = "open";
    center.origin           = open;
	center.hp               = hp;
    center.maxhp            = hp;
	center.range            = range;
    center.open             = open;
    center.close            = close;

    center.trigger          = spawn("trigger_radius", close - (0, 0, 35), 1, range, 300);

	center thread handle_door_damage();

    if(!isdefined(level.door_triggers))
        level.door_triggers = [];

    level.door_triggers[level.door_triggers.size] = center.trigger;
}

handle_door_damage(door) {
    self endon("destroyed_door");

    self.moving = 0;

    while(1) {
        foreach(player in level.players) {
            if(player istouching(self.trigger)) {
                player iprintln("Touching Door Trigger");
                if(player usebuttonpressed() && isalive(player)) {
					if(self.state == "closed") {
						if(self.moving == 0) {
							self thread handle_door_animation("closed", 4);
							iPrintLn("^:" + player.name + "^7 ^2Opened ^7the Door!");
						}
					}
					else if(self.state == "open") {
						if(self.moving == 0) {
							self thread handle_door_animation("open", 4);
							iPrintLn("^:" + player.name + "^7 ^1Closed ^7the Door!");
						}
					}
                }
            }
        }

        wait .1;
    }
}

handle_door_animation(state, time) {
    self.moving = 1;

    if(state == "closed") {
        self moveto(self.open, 3);
        wait 3;
        self.state = "open";
        self.moving = 0;
    }
    else {
        self moveto(self.close, 3);
        wait 3;
        self.state = "closed";
        self.moving = 0;
    }
}

spawnCrate(origin, angles, model) {
    entity = spawn("script_model", origin);
    if(isdefined(model))
    	entity setmodel(model);
	else if(isdefined(level.showinviscrates))
		entity setmodel("com_plasticcase_trap_bombsquad");
    entity.angles = angles;
    entity CloneBrushmodelToScriptmodel(level.airDropCrateCollision);

    return entity;
}

moveac130position(location) {
    level.ac130.origin = location;
    level.UAVRig.origin = location;
}

getAlliesFlagModel(mapname) {
    switch(mapname) {
        case "mp_alpha":
        case "mp_dome":
        case "mp_hardhat":
        case "mp_interchange":
        case "mp_cement":
        case "mp_hillside_ss":
        case "mp_morningwood":
        case "mp_overwatch":
        case "mp_park":
        case "mp_qadeem":
        case "mp_restrepo_ss":
        case "mp_terminal_cls":
        case "mp_roughneck":
        case "mp_boardwalk":
        case "mp_moab":
        case "mp_nola":
        case "mp_radar":
        case "mp_nightshift":
            return "prop_flag_delta";
        case "mp_exchange":
            return "prop_flag_american05";
        case "mp_bootleg":
        case "mp_bravo":
        case "mp_mogadishu":
        case "mp_village":
        case "mp_shipbreaker":
            return "prop_flag_pmc";
        case "mp_paris":
            return "prop_flag_gign";
        case "mp_plaza2":
        case "mp_aground_ss":
        case "mp_courtyard_ss":
        case "mp_italy":
        case "mp_meteora":
        case "mp_underground":
            return "prop_flag_sas";
        case "mp_seatown":
        case "mp_carbon":
        case "mp_lambeth":
            return "prop_flag_seal";
    }
    return "prop_flag_neutral";
}

round( floatVal , blank) {
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

DebugPolygon() {
	for(i=0;i<level.meat_playable_bounds.size;i++) {
		box = spawncrate(level.meat_playable_bounds[i], (90,0,0), "com_plasticcase_enemy");
		box thread keep_height();
	}
}

keep_height() {
	for(;;) {
		wait 0.05;
		if(isdefined(level.players[0])) {
			self.origin = (self.origin[0],self.origin[1],level.players[0].origin[2] - 400);
		}
	}
}

createPolygon() {
    level endon("death_bounds_stop");
	level thread checkPolygon();
    if(isdefined(level.debugpolygon))
        thread DebugPolygon();
}

checkPolygon() {
	level endon("game_ended");
	for(;;) {
		foreach(player in level.players) {
            if(player.status == "out") continue;

			if(!player.inoomzone && isalive(player) && !checkPointInsidePolygon(player.Origin)){
                player.inoomzone = 1;
                player thread PersonalPlayeroomtimer();
			}
		}

		wait .7;
	}
}


PersonalPlayeroomtimer() {
	self endon("disconnect");
	self endon("flag_teleport");

    self.oomAttempts = 40;

    self SetBlurForPlayer(9, 4);
    while(isalive(self) && !checkPointInsidePolygon(self.Origin)) {
    	wait .1;
        self.oomAttempts -= 1;

        if(self.oomAttempts >= 30)
            self.oom_hud setvalue(float("3." + (self.oomAttempts - 30)));
        else if(self.oomAttempts >= 20)
            self.oom_hud setvalue(float("2." + (self.oomAttempts - 20)));
        else if(self.oomAttempts >= 10)
            self.oom_hud setvalue(float("1." + (self.oomAttempts - 10)));
        else if(self.oomAttempts > 0)
            self.oom_hud setvalue(float("." + self.oomAttempts));
        else {
            self.oom_hud setvalue(0);
            self maps\mp\_utility::_suicide();
            wait 1;
            break;
        }
    }

    self SetBlurForPlayer(0, 0);
    self.inoomzone = 0;

    self.oomAttempts = 0;
}

checkPointInsidePolygon(p) {
	poly = level.meat_playable_bounds;

    p1 = (0,0,0);
    p2 = (0,0,0);

    inside = 0;

    oldPoint = (poly[poly.size - 1][0], poly[poly.size - 1][1], 0);

    for (i = 0; i < poly.size; i++) {
        newPoint = (poly[i][0], poly[i][1], 0);

        if (newPoint[0] > oldPoint[0]) {
            p1 = oldPoint;
            p2 = newPoint;
        }
        else {
            p1 = newPoint;
            p2 = oldPoint;
        }

        if ((newPoint[0] < p[0]) == (p[0] <= oldPoint[0])
            && (p[1] - p1[1])*(p2[0] - p1[0])
            < (p2[1] - p1[1])*(p[0] - p1[0]))
        {
            inside = !inside;
        }

        oldPoint = newPoint;
    }

    return inside;
}

Deathradius(position, radius, height, test) {
    thread Deathradiusthread(position, radius, height, test);
}

Deathradiusthread(position, radius, height, test){
    if(!isdefined(radius))
        radius = 200;
    if(!isdefined(height))
        height = 150;

    trigger = Spawn( "trigger_radius", position, 0, radius, height);

    if(isdefined(test) || isdefined(level.debugdeathradius)) {
        while(1) {
            trigger waittill( "trigger", player );

            player IPrintLn("^1INSIDE DEATHRADIUS");
            player IPrintLnbold("^1INSIDE DEATHRADIUS");
            wait 0.1;
        }
    }
    else {
        while(1) {
            trigger waittill( "trigger", player );

            if(isAlive(player))
                player _suicide();
        }
    }
}

CreateDeathRegion(corner1, corner2){
    level thread DeathRegionThread(corner1, corner2);
}

DeathRegionThread(corner1, corner2) {
    level endon("game_ended");
    level endon("death_region_stop");

    for(;;) {
        foreach(entity in level.players) {
            if(isAlive(entity) && insideRegionZ(corner1, corner2, entity.Origin))
				//iprintln("Dead");
                entity _suicide();
        }

        wait .25;
    }
}

insideRegionZ( A , B , C) {
    x = 0;
	y = 0;
	z = 0;

    if (A[2] <= B[2])
        if (C[2] >= A[2] && C[2] <= B[2])
            z = 1;
        else
            return 0;
    else
        if (C[2] <= A[2] && C[2] >= B[2])
            z = 1;
        else
            return 0;

    if(A[0] <= B[0])
        if (C[0] >= A[0] && C[0] <= B[0])
            x = 1;
        else
            return 0;
    else
        if(A[0] >= B[0])
            if (C[0] <= A[0] && C[0] >= B[0])
                x = 1;
            else
                return 0;

    if(A[1] <= B[1])
        if (C[1] >= A[1] && C[1] <= B[1])
            y = 1;
        else
            return 0;
    else
        if (A[1] >= B[1])
            if (C[1] <= A[1] && C[1] >= B[1])
                y = 1;
            else
                return 0;

    if (x && y && z)
        return 1;
    else
        return 0;
}

CreateDeathLine(corner1, corner2) {
    level thread DeathLineThread(corner1, corner2);
}

DeathLineThread(corner1, corner2) {
    level endon("game_ended");
    level endon("death_line_stop");

    for(;;) {
        foreach(entity in level.Players) {
            if(AreABCOneTheSameLine(corner1, corner2, entity.Origin)) {
                if(isAlive(entity))
                    entity suicide();
            }
        }
        wait .5;
    }
}

AreABCOneTheSameLine ( A , B , C) {
    return distance2d(A, C) + distance2d(C, B) - distance2d(A, B) < 2.5;
}

clonedcollision(position, angle, cloned) {
    thing = spawn("script_model", position);
    thing.angles = angle;
    thing clonebrushmodeltoscriptmodel(cloned);
    return thing;
}

upshaft(position, velocity, radius, height, add_mode) {
    thread upshaftthread(position, velocity, radius, height, add_mode);
}

upshaftthread(position, velocity, radius, height, add_mode) {
    trigger = spawn("trigger_radius", position, 0, radius, height);

    if(isdefined(add_mode))
        add = true;
    else
        add = false;
     
    for(;;) {
        trigger waittill("trigger", player);

        if(add) {
            vel = player getvelocity();
            player setvelocity((vel[0], vel[1], vel[2] + velocity));
        } else {
            vel = player getvelocity();
            player setvelocity((vel[0], vel[1], velocity));
        }
    }
}

cannonball(position, angles, waittime, goalpos, height, delay) {
    thread cannonballthread(position, angles, waittime, goalpos, height, delay, "com_plasticcase_trap_bombsquad");
}

cannonballInvis(position, angles, waittime, goalpos, height, delay) {
    thread cannonballthread(position, angles, waittime, goalpos, height, delay);
}

cannonballthread(position, angles, waittime, goalpos, height, delay, model) {
	if(isdefined(delay))
		wait delay;

    if(isdefined(model)) {
        cannonball = spawncrate(position, angles, model);
        cannonball2 = spawncrate(position, angles, model);
    } else {
        cannonball = spawncrate(position, angles);
        cannonball2 = spawncrate(position, angles);
    }


    cannonball.trigger = spawn("trigger_radius", cannonball.origin+(0,0,16), 0, 20, 20);
    cannonball.inuse = 0;

    for(;;) {
        cannonball.trigger waittill("trigger", player);

        if(!cannonball.inuse) {
            cannonball.inuse = 1;

            if(!player isusingremote()) {
                i = waittime;
                player iprintlnbold("Cannonball Launching In: ^8" + i);

                player playerlinkto(cannonball.trigger);
                exit = 0;
                cannonball playsound("reaper_impact");
                wait 1;
                i--;
                while(isalive(player) && !exit) {
                    if(i > 0) {
                        player iprintlnbold("Cannonball Launching In: ^8" + i);
                        cannonball playsound("reaper_impact");
                        wait 1;
                        i--;
                    }
                    else {
                        cannonball playsound("exp_ac130_105mm_dist");

                       	player thread cannonball_launch(position, 3, height, 60, goalpos);
                       	//player waittill("cannon_done");

                        exit = 1;
                    }
                }
            }

            wait 1.25;
            cannonball.inuse = 0;
        }

        wait 1;
    }
}

cannonball_launch(start, time, zOffset, zPeakProgress, end) {
	//self endon("cannon_done");

	end = (end[0], end[1], end[2] - 80);

	startX 			= start[0];
	startY 			= start[1];
	startZ 			= start[2];
	EndX 			= end[0] - startX;
	EndY 			= end[1] - startY;
	EndZ 			= end[2] - startZ;

	totalTime 		= time;
	increments 		= .065;

	ent 			= spawn("script_origin", self.origin);
	wait .05;

	self playerLinkTo(ent);

	for (i = 0; i < totalTime; i += increments) {
		if(isdefined(self) && isalive(self)) {
			animProgress 		= i / totalTime * 100;
			dx 					= linear(animProgress, 0, EndX, 101);
			dy 					= linear(animProgress, 0, EndY, 101);
			dz 					= linear(animProgress, 0, EndZ, 101);

			if (animProgress < zPeakProgress)
				addZ 			= easeOutSine(animProgress, 0, zOffset, zPeakProgress);
			else
				addZ 			= zOffset - easeInSine(animProgress - zPeakProgress, 0, zOffset, 100 - zPeakProgress);

			x 					= startX + dx;
			y 					= startY + dy;
			z 					= startZ + dz + addZ;

			ent moveTo((x, y, z), increments, 0, 0);

			wait increments;
		}
		else {
			ent delete();
			//self notify("cannon_done");
		}
	}

	earthQuake(.6, 3, self.origin, 200);
	self unlink();
	ent delete();
	//self notify("cannon_done");
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

manual_check_map_models( origin )
{
	if(!isdefined(level.check_models)) {
		level.check_models = [];
		level.check_models_triggers = [];
		level.check_models_index = 0;
		level.check_models_distance = 200;
		level.check_models_distance_2 = 400;
		level.check_models_stack = 0;
		level.check_models_stack_2 = 0;
	}

	level.check_models[level.check_models_index] = spawn("script_model", origin + ( level.check_models_distance_2 * level.check_models_stack_2, 0 , level.check_models_distance * level.check_models_stack ));
	level.check_models[level.check_models_index] setmodel("default_actor");
	level.check_models_triggers[level.check_models_index] = spawn("script_origin", level.check_models[level.check_models_index].origin);
	level.check_models_triggers[level.check_models_index] thread hint_on_trigger("defaultactor");

	level.check_models_index ++;
	level.check_models_stack ++;
	if(level.check_models_stack > 15) {
		level.check_models_stack = 0;
		level.check_models_stack_2 ++;
	}
}

check_map_models( origin )
{
	if(!isdefined(level.check_models)) {
		level.check_models = [];
		level.check_models_triggers = [];
		level.check_models_index = 0;
		level.check_models_distance = 200;
		level.check_models_distance_2 = 400;
		level.check_models_stack = 0;
		level.check_models_stack_2 = 0;
	}

	ents = getentarray();
	for(i=0;i<ents.size;i++) {
		if(!isdefined(ents[i].model))
			continue;

		if(IsSubStr(ents[i].model, "weapon"))
			continue;

		dupe = 0;
		for(j=0;j<level.check_models.size;j++) {
			if(ents[i].model == level.check_models[j].model) {
				dupe = 1;
			}
		}

		if(!dupe) {
			level.check_models[level.check_models_index] = spawn("script_model", origin + ( level.check_models_distance_2 * level.check_models_stack_2, 0 , level.check_models_distance * level.check_models_stack ));
			level.check_models[level.check_models_index] setmodel(ents[i].model);
			level.check_models_triggers[level.check_models_index] = spawn("script_origin", level.check_models[level.check_models_index].origin);
			level.check_models_triggers[level.check_models_index] thread hint_on_trigger(ents[i].model);

			level.check_models_index ++;
			level.check_models_stack ++;
			if(level.check_models_stack > 15) {
				level.check_models_stack = 0;
				level.check_models_stack_2 ++;
			}

		}
	}
}

manually_add_check_map_model(model, brushmodel_col) {
	level.check_models[level.check_models_index] = spawn("script_model", level.check_models[0].origin + ( level.check_models_distance_2 * level.check_models_stack_2, 0 , level.check_models_distance * level.check_models_stack ));
	level.check_models[level.check_models_index] setmodel(model);
	if(isdefined(brushmodel_col)) {
		level.check_models[level.check_models_index] CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	}
	level.check_models_triggers[level.check_models_index] = spawn("script_origin", level.check_models[level.check_models_index].origin);
	level.check_models_triggers[level.check_models_index] thread hint_on_trigger(model);

	level.check_models_index ++;
	level.check_models_stack ++;
	if(level.check_models_stack > 15) {
		level.check_models_stack = 0;
		level.check_models_stack_2 ++;
	}
}

hint_on_trigger(model_name) {
	for(;;) {
		wait 0.05;
		if(!isdefined(level.players[0]) || distance(level.players[0] geteye(),self.origin) > level.check_models_distance/2)
			continue;

		if(!isdefined(level.players[0].custom_model_label)) {
			level.players[0].custom_model_label = newclienthudelem(level.players[0]);
			level.players[0].custom_model_label.horzalign = "fullscreen";
			level.players[0].custom_model_label.vertalign = "fullscreen";
			level.players[0].custom_model_label.alignx = "center";
			level.players[0].custom_model_label.aligny = "top";
			level.players[0].custom_model_label.x = 320;
			level.players[0].custom_model_label.y = 240;
			level.players[0].custom_model_label.alpha = 0;
			level.players[0].custom_model_label.fontscale = 1.2;
			level.players[0].custom_model_label.font = "objective";
			level.players[0].custom_model_label.color = (0.6,0.3,0.2);
		}
		level.players[0].custom_model_label settext(model_name);
		level.players[0].custom_model_label.alpha = 1;

		while(distance(level.players[0] geteye(),self.origin) <= level.check_models_distance/2.1) {
			wait 0.05;
		}

		level.players[0].custom_model_label.alpha = 0;
	}
}