#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    replacefunc(maps\mp\killstreaks\_autosentry::updateSentryPlacement, ::updateSentryPlacementReplace);
    replacefunc(maps\mp\killstreaks\_ims::updateImsPlacement, ::updateImsPlacementReplace);
    replacefunc(maps\mp\killstreaks\_helicopter_guard::lbSupport_followPlayer, ::lbSupport_followPlayerReplace);
    replacefunc(maps\mp\killstreaks\_ac130::overlay, ::overlayreplace);
    replacefunc(maps\mp\killstreaks\_airdrop::getflyheightoffset, ::getflyheightoffset_edit);
	replacefunc(maps\mp\_events::monitorCrateJacking, ::monitorCrateJackingreplace);
	replacefunc(maps\mp\killstreaks\_airdrop::waitfordropcratemsg, ::waitfordropcratemsg_edit);

    precacheshader("compass_waypoint_bomb");

    level._meat_location_center = (0,0,0);
    level thread map_funcs_player_connected();

    level.mapname = getdvar("ui_mapname");
    level.curObjID = 1;
    level.usables = [];
    level.teleporter_ents = [];
}

waitfordropcratemsg_edit(crate, var_1, var_2, var_3) {
    self waittill( "drop_crate" );

    crate_ground = undefined;
    crate unlink();

    var_6 = undefined;
    var_4 = bullettrace(crate.origin, crate.origin + (0, 0, -10000), 0, crate);
    placeholder = spawn("script_model", var_4["position"]);

    foreach(crateent in level.crate_ents) {
    	if(placeholder istouching(crateent)) {
    		crate_ground = crateent;
    		break;
    	}
    }

    if(isdefined(crate_ground)) {
	    var_5 = distance(crate.origin, var_4["position"]);
	    var_6 = var_5 / 800;
	    crate rotatevelocity((randomintrange(0, 360), randomintrange(0, 360), randomintrange(0, 360)), var_6 / 2);
	    crate moveto(var_4["position"] + (0, 0, 14), var_6);
	}
	else
		crate physicslaunchserver((0, 0, 0), var_1);

	crate thread physicswaiter_edit(var_2, var_3, crate_ground);

    if(isdefined(crate.killcament)) {
        crate.killcament unlink();
        var_4 = bullettrace(crate.origin, crate.origin + (0, 0, -10000), 0, crate);
        var_5 = distance(crate.origin, var_4["position"]);
        var_6 = var_5 / 800;
        crate.killcament moveto(var_4["position"] + (0, 0, 300), var_6);
    }

    if(isdefined(crate_ground)) {
	    wait var_6 / 2;
	    if(crate_ground.angles[2] == 0)
	    	crate rotateto((crate_ground.angles[0], randomintrange(0, 360), crate_ground.angles[2]), var_6 / 2);
	    else
	    	crate rotateto((crate_ground.angles[0], crate_ground.angles[1], crate_ground.angles[2]), var_6 / 2);

	    wait var_6 / 2;
	    crate notify("crate_reached_pos");
	    placeholder delete();
	    crate_ground = undefined;
	}
}

atan2(y, x) {
    if (x == 0) {
        if (y > 0) {
            return 90;
        } else if (y < 0) {
            return -90;
        } else {
            return 0;
        }
    }

    angle = atan(y / x) * (180 / 3.14159265359);

    if (x < 0) {
        if (y >= 0) {
            angle += 180;
        } else {
            angle -= 180;
        }
    }

    return angle;
}

map_funcs_player_connected() {
    self endon ("disconnect");
    for (;;) {
        level waittill("connected", player);

        player.status = "out";
        player.inoomzone = false;
        player.attackeddoor = 0;

        player thread threadUse();
        player thread oomzonehud();
        player thread UsablesHud();
    }
}

oomzonehud() {
    if(!isdefined(self.cz_elements))
    	self.cz_elements = [];

    if(!isdefined(self.cz_elements["title"])) {
    	self.cz_elements["title"] = newclienthudelem(self);
    	self.cz_elements["title"].horzalign = "fullscreen";
    	self.cz_elements["title"].vertalign = "fullscreen";
    	self.cz_elements["title"].alignx = "center";
    	self.cz_elements["title"].aligny = "top";
    	self.cz_elements["title"].x = 320;
    	self.cz_elements["title"].y = 155;
    	self.cz_elements["title"].alpha = 0;
    	self.cz_elements["title"].fontscale = 1.25;
    	self.cz_elements["title"].font = "hudbig";
    	self.cz_elements["title"] settext("W A R N I N G");
    }

    if(!isdefined(self.cz_elements["reason"])) {
    	self.cz_elements["reason"] = newclienthudelem(self);
    	self.cz_elements["reason"].horzalign = "fullscreen";
    	self.cz_elements["reason"].vertalign = "fullscreen";
    	self.cz_elements["reason"].alignx = "center";
    	self.cz_elements["reason"].aligny = "top";
    	self.cz_elements["reason"].x = 320;
    	self.cz_elements["reason"].y = 187;
    	self.cz_elements["reason"].alpha = 0;
    	self.cz_elements["reason"].fontscale = .9;
    	self.cz_elements["reason"].font = "hudbig";
    	self.cz_elements["reason"] settext("Return to Combat Zone");
    }

    if(!isdefined(self.cz_elements["timer"])) {
    	self.cz_elements["timer"] = newclienthudelem(self);
    	self.cz_elements["timer"].horzalign = "fullscreen";
    	self.cz_elements["timer"].vertalign = "fullscreen";
    	self.cz_elements["timer"].alignx = "center";
    	self.cz_elements["timer"].aligny = "top";
    	self.cz_elements["timer"].x = 320;
    	self.cz_elements["timer"].y = 210;
    	self.cz_elements["timer"].alpha = 0;
    	self.cz_elements["timer"].fontscale = 1.05;
    	self.cz_elements["timer"].font = "hudbig";
    	self.cz_elements["timer"].label = &"^3";
    }
}

threadUse() {
    self endon("disconnect");

    self notifyonplayercommand("triggeruse", "+activate");
    self notifyonplayercommand("triggeruse", "+usereload");

    for(;;) {
        self waittill("triggeruse");
        self HandleUsables();
    }
}

CreateHiddenTP(enter, exit, angle, setStatus, slowed, radius, height) {
    setStatus = isDefined(setStatus) ? setStatus : undefined;

    ent1 = spawn("script_model", enter + (0,0,46));
    ent1 setModel("projectile_cbu97_clusterbomb");
    ent1.angles = (-90,0,0);
    ent1 thread keeprotating();
    fx = SpawnFX(level.spawnGlow["enemy"] , enter + (0,0,80));
    TriggerFX(fx);

    ent2 = spawn("script_model", exit - (0,0,44));
    ent2 setModel("projectile_javelin_missile");
    ent2.angles = (-90,0,0);
    ent2 thread keeprotating();

    level.teleporter_ents[level.teleporter_ents.size] = ent2;

    level.curObjId+=1;
    nobj = level.curObjId;
    v5 = 31 - nobj;
    objective_add(v5, "active");
    if(isdefined(setstatus) && setstatus == "out")
        objective_icon(v5, level.flag_exit_shader);
    else
        objective_icon(v5, "compass_waypoint_bomb");
    objective_position(v5, ent1.Origin);

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
        trigger waittill( "trigger", player );

        player setorigin(exit);
        if(isdefined(angle))
            player setplayerangles((player getplayerangles()[0], angle[1], 0));
        if(isdefined(slowed))
            player thread freezeontp();
        if(isDefined(setStatus)) {
            player.status = setStatus;

            if(player.cz_elements["title"].alpha == 1) {
            	player notify("flag_teleport");
           		player.inoomzone = false;
    			player.oomAttempts = 0;
    			player SetBlurForPlayer(0, 0);

    			foreach(hud in player.cz_elements)
    				hud.alpha = 0;
			}
        }
        if(player.sessionteam == "axis")
            player.TISpawnPosition = player.origin + (0,0,5);
    }
}

CreateTP(enter, exit, angle, slowed, radius, height, delay) {
    if(isdefined(delay))
        wait delay;

    entity = spawn( "script_model",enter);
    level.curObjId+=1;
    nobj = level.curObjId;
    v5 = 31 - nobj;
    objective_add(v5, "active");
    objective_position(v5, entity.Origin);
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
    self freezecontrols(true);
    wait .1;
    self freezecontrols(false);
}

CreateRamps(top, bottom, delay) {
	if(isdefined(delay))
		wait delay;

    num2 = Int(ceil(Distance(top, bottom) / 30));
    vector = ((top[0] - bottom[0]) / num2, (top[1] - bottom[1]) / num2, (top[2] - bottom[2]) / num2);
    vector2 = vectortoangles(top - bottom);

    angles = (vector2[2], vector2[1] + 90, vector2[0]);
    entity = spawn("script_origin", vector);

    for (i = 0; i <= num2; i++) {
        ent = spawncrate(bottom + (vector * i), angles, "com_plasticcase_friendly");
        ent linkto(entity);
    }
}

CreateTurret(origin, angles, left, right, bottom, droppitch, delay) {
	if(isdefined(delay))
		wait delay;

    entity = spawnTurret("misc_turret", origin, "sentry_minigun_mp");
    entity setmodel("weapon_minigun");
    entity.angles = angles;
    entity sethintstring(&"PLATFORM_HOLD_TO_USE");
    entity thread overheating();

    if(isdefined(left)) entity SetLeftArc( left ); else entity SetLeftArc( 80 );
    if(isdefined(right)) entity SetRightArc( right ); else entity SetRightArc( 80 );
    if(isdefined(bottom)) entity SetBottomArc( bottom ); else entity SetBottomArc( 50 );
    if(isdefined(droppitch)) entity SetDefaultDropPitch( droppitch ); else entity SetDefaultDropPitch( .0 );
}

overheating() {
    self.momentum = 0;
    self.heatLevel = 0;
    self.overheated = false;
    self thread heatmonitoring();
    wait .05;
    self thread turret_shotMonitor();
    self thread sentry_handleUse();
}

sentry_handleUse() {
	self endon ( "death" );
	level endon ( "game_ended" );

    colorStable = (1, .9, .7);
	colorUnstable = (1, .65, 0);
	colorOverheated = (1, .25, 0);

	for ( ;; ) {
		self waittill ( "trigger", player );

		if( IsDefined( self.inUseBy ) )
			continue;
		if( !isReallyAlive( player ) )
			continue;

        self.inuseby = player;
        player.using_minigun = true;

        player.turret_overheat_bar = player createBar( colorStable, 100, 6 );
		player.turret_overheat_bar setPoint("CENTER", "BOTTOM", 0, -70 );
		player.turret_overheat_bar.alpha = .65;
		player.turret_overheat_bar.bar.alpha = .65;

        while(player IsUsingTurret())
		{
			if ( self.heatLevel >= self.overheatTime )
				barFrac = 1;
			else
				barFrac = self.heatLevel / self.overheatTime;

			player.turret_overheat_bar updateBar( barFrac );

			if (self.overheated )
			{
				self TurretFireDisable();
				player.turret_overheat_bar.bar.color = colorOverheated;
			}
			else if ( self.heatLevel > self.overheatTime * .75)
			{
				player.turret_overheat_bar.bar.color = colorUnstable;
			}
			else if(!self.overheated)
			{
				player.turret_overheat_bar.bar.color = colorStable;
				self TurretFireEnable();
			}

			wait( .05 );
		}

        self.inUseBy = undefined;
        player.using_minigun = undefined;
        self notify( "player_dismount" );
		player.turret_overheat_bar destroyElem();
	}
}

heatmonitoring() {
	self.fireTime = weaponFireTime( "manned_minigun_turret_mp" );

	self.lastHeatLevel = 0;
	self.lastFxTime = 0;

	self.overheatTime = 5;
	self.overheatCoolDown = .2;

	for ( ;; )
	{

		if ( self.heatLevel != self.lastHeatLevel )
			wait ( self.fireTime );
		else
			self.heatLevel = max( 0, self.heatLevel - .05 );

		if ( self.heatLevel > self.overheatTime )
		{
			self.overheated = true;
			self thread PlayHeatFX();

			playFxOnTag( getFx( "sentry_smoke_mp" ), self, "tag_aim" );

			while ( self.heatLevel )
			{
				self.heatLevel = max( 0, self.heatLevel - self.overheatCoolDown );
				wait ( .1 );
			}

			self.overheated = false;
			self notify( "not_overheated" );
		}

		self.lastHeatLevel = self.heatLevel;
		wait .05;
	}
}

turret_shotMonitor() {
	fireTime = weaponFireTime( "manned_minigun_turret_mp" );

	for(;;) {
		self waittill ( "turret_fire" );
		self.heatLevel += fireTime;
		self.cooldownWaitTime = fireTime;
	}
}

playHeatFX()
{
	self endon( "death" );
	self endon( "not_overheated" );
	level endon ( "game_ended" );

	self notify( "playing_heat_fx" );
	self endon( "playing_heat_fx" );

	for(;;) {
		playFxOnTag( getFx( "sentry_overheat_mp" ), self, "tag_flash" );

		wait .3;
	}
}

UsablesHud() {
    self endon("disconnect");

    self.message = CreateFontString("hudbig", .6);
    self.message SetPoint("CENTER", "CENTER", 0, -50);

    limit = 0;
    for(;;) {
        _changed = false;
        foreach (ent in level.usables) {
        	if(isdefined(ent) && isdefined(ent.linked_ents)) {
	            if (Distance(self.Origin + (0,0,40), ent.Origin) < ent.range) {
	                switch (ent.usabletype) {
	                    case "door":
	                        if(!isdefined(self.message)) {
	                            self.message = CreateFontString("hudbig", .6);
	                            self.message SetPoint("CENTER", "CENTER", 0, -50);
	                        }
	                        self.message setText(self getDoorText(ent));

	                        break;
	                    default:
	                        if(isdefined(self.message)) self.message destroy();
	                        break;
	                }
	                _changed = true;
	            }
	        }
	    }

        if (!_changed)
            if(isdefined(self.message)) self.message destroy();

        wait .100;
    }
}

getDoorText(door) {
    hp = door.hp;
    maxhp = door.maxhp;
    if (self.sessionteam == "allies") {
        switch (door.state) {
            case "open":
                return "Door is Open. Press ^5[{+activate}] ^7to close it. ( ^5" + hp + "^7 / ^5" + maxhp + "^7 )";
            case "close":
                return "Door is Closed. Press ^5[{+activate}] ^7to open it. ( ^5" + hp + "^7 / ^5" + maxhp + "^7 )";
            case "broken":
                return "^1Door is Broken.";
        }
    }
    else if (self.sessionteam == "axis") {
        switch (door.state) {
            case "open":
                return "Door is Open.";
            case "close":
                return "Press ^5[{+activate}] ^7to attack the door.";
            case "broken":
                return "^1Door is Broken";
        }
    }
    return "";
}

addtousablelist(type)
{
    self.usabletype = type;
    level.usables[level.usables.size] = self;
}

HandleUsables() {
    foreach(ent in level.usables) {
    	if(isdefined(ent)) {
        	if(Distance(self.origin + (0,0,40), ent.origin) < ent.range)
            	self usedDoor(ent);
        }
    }
}

launchy() {
	ent = spawn("script_model", self.origin);
	ent setmodel("com_plasticcase_trap_friendly");
	ent.angles = self.angles;
	self delete();
    ent physicslaunchserver((randomintrange(-300, 300), randomintrange(-300, 300), 1000), (randomintrange(-300, 300), randomintrange(-300, 300), 1000));
    wait 15;
    ent delete();
}

usedDoor(door) {
    if(!isDefined(self))
    	return;
    if(!isAlive(self))
    	return;

    if (door.hp > 0) {
        if (self.sessionteam == "allies") {
            if (door.state == "open") {
                iprintln(self.name + " ^1Closed ^7The Door!");
                door moveto(door.close, 2);
                wait 2.3;
                door.state = "close";
            }
            else if (door.state == "close") {
                iprintln(self.name + " ^2Opened ^7The Door!");
                door moveto(door.open, 2);
                wait 2.3;
                door.state = "open";
            }
        }
        else if (self.sessionteam == "axis") {
            if (door.state == "close") {
                if (self.attackeddoor == 0) {
                    self.attackeddoor = 1;
                    door.hp = door.hp - 1;
                    self iprintlnbold("Door Health: ( ^5" + door.hp + " ^7/ ^5" + door.maxhp + "^7 )");

                    if(door.hp == 5)
                        iprintln("Door ^:Almost Destroyed!");
                    if(door.hp != 0)
                        wait 1;
                    else {
                        iprintln("^5" + self.name + " ^1Destroyed ^7The Door!");
                        door playsound("talon_destroyed");
                        foreach(ent in door.linked_ents)
                			ent thread launchy();
                		door.linked_ents = undefined;
                		door delete();
                    }

                    self.attackeddoor = 0;
                }
            }
        }
    }
}

createwalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, "com_plasticcase_friendly", angles, delay);
}

CreateInvisWalls(start, end, angles, delay) {
    thread CreateWallthread(start, end, undefined, angles, delay);
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
	if(isdefined(delay))
		wait delay;

    crates = round((height/stepsize));
    forang = AnglesToForward(angles);

    for(i=0; i < crates; i++) {
        block = spawnCrate((position + (forang * distperstep) * i) - (0,0,stepsize) * i, angles + (0,90,0), "com_plasticcase_friendly");
        wait .05;
    }
}

CreateInvisQuicksteps(position, height, stepsize, distperstep, angles, delay) {
	if(isdefined(delay))
		wait delay;

    crates = round((height/stepsize));
    forang = AnglesToForward(angles);

    for(i=0; i < crates; i++) {
        block = spawnCrate((position + (forang * distperstep) * i) - (0,0,stepsize) * i, angles + (0,90,0));
        wait .05;
    }
}

CreateElevator(corner1, corner2, totalheight, time, angle, delay, goalpos) {
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

    	playsoundatpos(center.origin, "elev_run_start");
        wait time;
        playsoundatpos(center.Origin, "elev_bell_ding");

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

    	playsoundatpos(center.origin, "elev_run_start");
        wait time;
        playsoundatpos(center.Origin, "elev_bell_ding");

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

fufalldamage(position, range, height) {
    if(!isdefined(level.falldamagetriggers))
        level.falldamagetriggers = [];

    level.falldamagetriggers[level.falldamagetriggers.size] = Spawn( "trigger_radius", position, 0, range, height);
}

CreateGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, "com_plasticcase_friendly", angle, delay);
}

CreateInvisGrids(corner1, corner2, angle, delay) {
    thread CreateGridsThread(corner1, corner2, undefined, angle, delay);
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

    if(isdefined(model)) {
        for(r = 0; r <= ROWS; r++) {
            for(c = 0; c <= COLUMNS; c++) {
                for(h = 0; h <= HEIGHT; h++) {
                    block = spawnCrate((corner1 + (XA * r, YA * c, ZA * h)), (0,0,0), model);
                    block LinkTo(center);
                    wait .05;
                }
            }
	    }
    }

	center.angles = angle;
}

CreateDoors(open, close, angle, size, height, hp, range, side, delay) {
	if(isdefined(delay))
		wait delay;

    offset = (((size / 2)- .5)* -1);
	center = spawn("script_model", open);
	center.linked_ents = [];

    if(isdefined(side)) {
        for(j=0;j < size;j++) {
            door = spawnCrate(open +((0,55,0)* offset), (0,90,0), "com_plasticcase_enemy");
            center.linked_ents[center.linked_ents.size] = door;
            door LinkTo(center);

            for(h=1;h < height;h++) {
                door = spawnCrate(open + ((0,55,0)* offset)-((50,0,0)* h), (0,90,0), "com_plasticcase_enemy");
                center.linked_ents[center.linked_ents.size] = door;
                door LinkTo(center);
            }
            offset += 1;
        }
    }
    else {
        for(j=0;j < size;j++) {
            door = spawnCrate(open +((0,30,0) * offset), (0,0,0), "com_plasticcase_enemy");
            center.linked_ents[center.linked_ents.size] = door;
            door LinkTo(center);

            for(h=1;h < height;h++) {
                door = spawnCrate(open + ((0,30,0) * offset)-((70,0,0)* h), (0,0,0), "com_plasticcase_enemy");
                center.linked_ents[center.linked_ents.size] = door;
                door LinkTo(center);
            }
            offset += 1;
        }
    }

	center.angles=angle;
	center.state="open";
    center.origin = open;
	center.hp=hp;
    center.maxhp = hp;
	center.range=range;
    center.open=open;
    center.close=close;
	center thread addtousablelist("door");
}

spawnCrate(origin, angles, model) {
    entity = spawn("script_model", origin);
    if(isdefined(model))
    	entity setmodel(model);
    entity.angles = angles;
    entity CloneBrushmodelToScriptmodel(level.airDropCrateCollision);

    if(!isdefined(level.lowest_crate))
		level.lowest_crate = origin[2];

	if(origin[2] < level.lowest_crate)
		level.lowest_crate = origin[2];

   	if(!isdefined(level.crate_ents))
   		level.crate_ents = [];

   	level.crate_ents[level.crate_ents.size] = entity;

    return entity;
}

moveac130position(location) {
    level.ac130.origin = location;
    level.UAVRig.origin = location;
}

updateSentryPlacementReplace( sentryGun ) {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	sentryGun endon ( "placed" );
	sentryGun endon ( "death" );

	sentryGun.canBePlaced = true;
	lastCanPlaceSentry = -1;

	for(;;) {
        placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), false, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), false, self);

		sentryGun.origin = placement[ "origin" ];
		sentryGun.angles = placement[ "angles" ];
		sentryGun.canBePlaced = self isOnGround()  && ( abs(sentryGun.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if ( sentryGun.canBePlaced != lastCanPlaceSentry )
		{
			if ( sentryGun.canBePlaced )
			{
				sentryGun setModel( level.sentrySettings[ sentryGun.sentryType ].modelPlacement );
				self ForceUseHintOn( &"SENTRY_PLACE" );
			}
			else
			{
				sentryGun setModel( level.sentrySettings[ sentryGun.sentryType ].modelPlacementFailed );
				self ForceUseHintOn( &"SENTRY_CANNOT_PLACE" );
			}
		}

		lastCanPlaceSentry = sentryGun.canBePlaced;
		wait .05;
	}
}

updateIMSPlacementReplace( ims )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	ims endon ( "placed" );
	ims endon ( "death" );

	ims.canBePlaced = true;
	lastCanPlaceIMS = -1; // force initial update

	for( ;; ) {
		placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), false, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), false, self);

		ims.origin = placement[ "origin" ];
		ims.angles = placement[ "angles" ];
		ims.canBePlaced = self isOnGround() && placement[ "result" ] && ( abs(ims.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if ( ims.canBePlaced != lastCanPlaceIMS )
		{
			if ( ims.canBePlaced )
			{
				ims setModel( level.imsSettings[ ims.imsType ].modelPlacement );
				self ForceUseHintOn( level.imsSettings[ ims.imsType ].placeString );
			}
			else
			{
				ims setModel( level.imsSettings[ ims.imsType ].modelPlacementFailed );
				self ForceUseHintOn( level.imsSettings[ ims.imsType ].cannotPlaceString );
			}
		}

		lastCanPlaceIMS = ims.canBePlaced;
		wait ( .05 );
	}
}

getAlliesFlagModel(mapname)
{
    switch (mapname)
    {
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

round( floatVal , blank) // rounds up
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

createPolygon() {
    level endon("death_bounds_stop");
	level thread checkPolygon();
}

checkPolygon() {
	for(;;) {
		foreach(player in level.Players) {
            if(player.status == "out") continue;

			if(!player.inoomzone && isalive(player) && !checkPointInsidePolygon(player.Origin)){
                player.inoomzone = true;
                player thread PersonalPlayeroomtimer();
			}
		}
		wait .5;
	}
}

title_warning_pulse() {
	self endon("disconnect");

	while(self.cz_elements["title"].alpha == 1) {
		self.cz_elements["title"] fadeovertime(.3);
		self.cz_elements["title"].color = (1, 1, 1);
		wait .3;
		self.cz_elements["title"] fadeovertime(.3);
		self.cz_elements["title"].color = (1, 0, 0);
		wait .3;
	}
}

PersonalPlayeroomtimer() {
	self endon("disconnect");
	self endon("flag_teleport");

    self.oomAttempts = 40;

    foreach(hud in self.cz_elements)
    	hud.alpha = 1;

    self thread title_warning_pulse();

    self SetBlurForPlayer(9, 4);
    while(isalive(self) && !checkPointInsidePolygon(self.Origin)) {
    	wait .1;
        self.oomAttempts -= 1;

        if(self.oomAttempts >= 30)
            self.cz_elements["timer"] setvalue(float("3." + (self.oomAttempts - 30)));
        else if(self.oomAttempts >= 20)
            self.cz_elements["timer"] setvalue(float("2." + (self.oomAttempts - 20)));
        else if(self.oomAttempts >= 10)
            self.cz_elements["timer"] setvalue(float("1." + (self.oomAttempts - 10)));
        else if(self.oomAttempts > 0)
            self.cz_elements["timer"] setvalue(float("." + self.oomAttempts));
        else {
            self.cz_elements["timer"] setvalue(0);
            self maps\mp\_utility::_suicide();
            wait 1;
            break;
        }
    }

    self SetBlurForPlayer(0, 0);
    self.inoomzone = false;

    foreach(hud in self.cz_elements)
    	hud.alpha = 0;

    self.oomAttempts = 0;
}

add_point_to_meat_playable_bounds( point ) {
	if(!isDefined(level.meat_playable_bounds))
		level.meat_playable_bounds = [];

	level.meat_playable_bounds[ level.meat_playable_bounds.size ] = point;
}

checkPointInsidePolygon(p){

	poly = level.meat_playable_bounds;

    p1 = (0,0,0);
    p2 = (0,0,0);

    inside = false;

    oldPoint = (poly[poly.size - 1][0], poly[poly.size - 1][1], 0);

    for (i = 0; i < poly.size; i++)
    {
        newPoint = (poly[i][0], poly[i][1], 0);

        if (newPoint[0] > oldPoint[0])
        {
            p1 = oldPoint;
            p2 = newPoint;
        }
        else
        {
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

CreateDeathZone(corner1, corner2) {
    level thread DeathZoneThread(corner1, corner2);
}

DeathZoneThread(corner1, corner2){

    level endon("game_ended");
    level endon("death_zone_stop");

    for(;;) {
        foreach (entity in level.Players) {
            if(isAlive(entity) && insideRegion(corner1, corner2, entity.Origin))
                entity _suicide();
        }
        wait 1;
    }
}
insideRegion ( A , B , C) {

    x1 = floor(A[0]);
    x2 = floor(B[0]);

    y1 = floor(A[1]);
    y2 = floor(B[1]);

    xP = floor(C[0]);
    yP = floor(C[1]);

    return ((x1 < xP && xP < x2) || x1 > xP && xP > x2) && ((y1 < yP && yP < y2) || y1 > yP && yP > y2);
}

Deathradius(position, radius, height, test){
    thread Deathradiusthread(position, radius, height, test);
}

Deathradiusthread(position, radius, height, test){

    if(!isdefined(radius))
        radius = 200;
    if(!isdefined(height))
        height = 150;

    trigger = Spawn( "trigger_radius", position, 0, radius, height );
    if(isdefined(test))
    {
        for(;;)
        {
            trigger waittill( "trigger", player );

            player IPrintLn("^1INSIDE DEATHRADIUS");
            player IPrintLnbold("^1INSIDE DEATHRADIUS");
        }
    }
    else
    {
        for(;;)
        {
            trigger waittill( "trigger", player );

            if(isAlive(player))
            {
                player _suicide();
            }
        }
    }

}

CreateDeathRegion(corner1, corner2){
    level thread DeathRegionThread(corner1, corner2);
}
DeathRegionThread(corner1, corner2){

    level endon("game_ended");
    level endon("death_region_stop");

    for(;;){
        foreach (entity in level.Players)
        {
            if(isAlive(entity) && insideRegionZ(corner1, corner2, entity.Origin))
            {
                //iPrintlnBold("death zone");
                entity _suicide();
            }
        }
        wait .5;
    }
}
insideRegionZ ( A , B , C)
{
    x = false;
	y = false;
	z = false;

    if(A[0] <= B[0])
        if (C[0] >= A[0] && C[0] <= B[0])
            x = true;
        else
            return false;
    else
        if(A[0] >= B[0])
            if (C[0] <= A[0] && C[0] >= B[0])
                x = true;
            else
                return false;

    if(A[1] <= B[1])
        if (C[1] >= A[1] && C[1] <= B[1])
            y = true;
        else
            return false;
    else
        if (A[1] >= B[1])
            if (C[1] <= A[1] && C[1] >= B[1])
                y = true;
            else
                return false;

    if (A[2] <= B[2])
        if (C[2] >= A[2] && C[2] <= B[2])
            z = true;
        else
            return false;
    else
        if (C[2] <= A[2] && C[2] >= B[2])
            z = true;
        else
            return false;

    if (x && y && z)
    {
        return true;
    }
    else
        return false;
}

CreateDeathLine(corner1, corner2) {
    level thread DeathLineThread(corner1, corner2);
}

DeathLineThread(corner1, corner2){
    level endon("game_ended");
    level endon("death_line_stop");

    for(;;){
        foreach (entity in level.Players) {
            if(AreABCOneTheSameLine(corner1, corner2, entity.Origin)) {
                if(isAlive(entity)){
                    entity suicide();
                }
            }
        }
        wait .2;
    }
}

AreABCOneTheSameLine ( A , B , C) {
    return distance2d(A, C) + distance2d(C, B) - distance2d(A, B) < 2.5;
}

lbSupport_moveToPlayerReplace() {
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );
	self.owner endon( "death" );
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );

	self notify( "lbSupport_moveToPlayer" );
	self endon( "lbSupport_moveToPlayer" );

	self.inTransit = true;
    a = distance(self.owner.origin, self.origin);
    if(a  > 1000)
        self Vehicle_SetSpeed( (a / 30), (a / 30)/10, (a / 30)/10 );
    else
        self Vehicle_SetSpeed( self.speed, 60, 30 );
	self setVehGoalPos( self.owner.origin + (0,0,700) + (randomintrange(-50,50),randomintrange(-50,50),randomintrange(-10,10)), 1 );
	self waittill ( "goal" );
	self.inTransit = false;
	self notify( "hit_goal" );
}

lbSupport_followPlayerReplace() {
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );

	if( !IsDefined( self.owner ) ) {
		self thread maps\mp\killstreaks\_helicopter_guard::lbSupport_leave();
		return;
	}

	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );

	self Vehicle_SetSpeed( self.followSpeed, 20, 20 );

	while(true) {
		if( IsDefined( self.owner ) && IsAlive( self.owner ) ) {
			if(distance2d(self.origin, self.owner.origin) > 300)
			    lbSupport_moveToPlayerReplace();
		}
		wait 1;
	}
}

overlayReplace( player ) {
	level.HUDItem = [];

	level.HUDItem[ "thermal_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "thermal_vision" ].x = 200;
	level.HUDItem[ "thermal_vision" ].y = 0;
	level.HUDItem[ "thermal_vision" ].alignX = "left";
	level.HUDItem[ "thermal_vision" ].alignY = "top";
	level.HUDItem[ "thermal_vision" ].horzAlign = "left";
	level.HUDItem[ "thermal_vision" ].vertAlign = "top";
	level.HUDItem[ "thermal_vision" ].fontScale = 2.5;
	level.HUDItem[ "thermal_vision" ] SetText( &"AC130_HUD_FLIR");
	level.HUDItem[ "thermal_vision" ].alpha = 1.0;

	level.HUDItem[ "enhanced_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "enhanced_vision" ].x = -200;
	level.HUDItem[ "enhanced_vision" ].y = 0;
	level.HUDItem[ "enhanced_vision" ].alignX = "right";
	level.HUDItem[ "enhanced_vision" ].alignY = "top";
	level.HUDItem[ "enhanced_vision" ].horzAlign = "right";
	level.HUDItem[ "enhanced_vision" ].vertAlign = "top";
	level.HUDItem[ "enhanced_vision" ].fontScale = 2.5;
	level.HUDItem[ "enhanced_vision" ] SetText( &"AC130_HUD_OPTICS");
	level.HUDItem[ "enhanced_vision" ].alpha = 1.0;

	player thread maps\mp\killstreaks\_ac130::overlay_coords();
}

clonedcollision(position, angle, cloned) {
    thing = spawn("script_model", position);
    thing.angles = angle;
    thing clonebrushmodeltoscriptmodel(cloned);

    return thing;
}

cannonball(position, angles, velocity, waittime, goalpos, height, delay) {
	if(isdefined(delay))
		wait delay;

    cannonball = spawncrate(position, angles, "com_plasticcase_trap_bombsquad");
    cannonball2 = spawncrate(position, angles, "com_plasticcase_trap_bombsquad");
    cannonball.trigger = spawn("trigger_radius", cannonball.origin+(0,0,16), 0, 20, 20);
    cannonball.inuse = false;

    for(;;) {
        cannonball.trigger waittill("trigger", player);

        if(!cannonball.inuse) {
            cannonball.inuse = true;

            if(!player isusingremote()) {
                i = waittime;
                player iprintlnbold("Cannonball Launching In: ^1" + i);

                player playerlinkto(cannonball.trigger);
                exit = false;
                cannonball playsound("reaper_impact");
                wait 1;
                i--;
                while(isalive(player) && !exit) {
                    if(i > 0) {
                        player iprintlnbold("Cannonball Launching In: ^1" + i);
                        cannonball playsound("reaper_impact");
                        wait 1;
                        i--;
                    }
                    else {
                        player iprintlnbold("Cannonball ^1FIRING!!");

                        cannonball playsound("exp_ac130_105mm_dist");

                       	player thread cannonball_launch(position, 3, height, 60, goalpos);
                       	player waittill("cannon_done");

                        exit = true;
                    }
                }
            }

            wait 2;
            cannonball.inuse = false;
        }

        wait 1;
    }
}
cannonballInvis(position, angles, velocity, waittime, goalpos, height, delay) {
	if(isdefined(delay))
		wait delay;

    cannonball = spawncrate(position, angles);
    cannonball2 = spawncrate(position, angles);
    cannonball.trigger = spawn("trigger_radius", cannonball.origin+(0,0,16), 0, 20, 20);
    cannonball.inuse = false;

    for(;;) {
        cannonball.trigger waittill("trigger", player);

        if(!cannonball.inuse) {
            cannonball.inuse = true;

            if(!player isusingremote()) {
                i = waittime;
                player iprintlnbold("Cannonball Launching In: ^1" + i);

                player playerlinkto(cannonball.trigger);
                exit = false;
                cannonball playsound("reaper_impact");
                wait 1;
                i--;
                while(isalive(player) && !exit) {
                    if(i > 0) {
                        player iprintlnbold("Cannonball Launching In: ^1" + i);
                        cannonball playsound("reaper_impact");
                        wait 1;
                        i--;
                    }
                    else {
                        player iprintlnbold("Cannonball ^1FIRING!!");

                        cannonball playsound("exp_ac130_105mm_dist");

                       	player thread cannonball_launch(position, 3, height, 60, goalpos);
                       	player waittill("cannon_done");

                        exit = true;
                    }
                }
            }

            wait 2;
            cannonball.inuse = false;
        }

        wait 1;
    }
}

cannonball_launch(start, time, zOffset, zPeakProgress, end) {
	self endon("cannon_done");

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
			self notify("cannon_done");
		}
	}

	earthQuake(.6, 3, self.origin, 200);
	self unlink();
	ent delete();
	self notify("cannon_done");
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

physicswaiter_edit(var_0, var_1, special) {
	self endon("death");

	var_3 = self.origin;

	if(isdefined(special))
    	self waittill("crate_reached_pos");
    else
    	self waittill("physics_finished");

	if(isdefined(self)) {
    	self thread [[ level.cratefuncs[var_0][var_1] ]]( var_0 );
    	level thread maps\mp\killstreaks\_airdrop::droptimeout( self, self.owner, var_1 );

    	if(distance(self.origin, var_3) > 3500)
        	self maps\mp\killstreaks\_airdrop::deletecrate();

		if(isdefined(level.lowest_crate)) {
    		if(self.origin[2] < level.lowest_crate && self.origin[2] < level.lowspawn.origin[2])
    			self maps\mp\killstreaks\_airdrop::deletecrate();
    	}

        if(isdefined(level.teleporter_ents)) {
            foreach(ent in level.teleporter_ents) {
                if(distance2d(self.origin, ent.origin) < 75)
                    self maps\mp\killstreaks\_airdrop::deletecrate();
            }
        }
    }
}

getflyheightoffset_edit(var_2) {
	return var_2[2] + 1000;
}

monitorCrateJackingreplace() {
	level endon( "end_game" );
	self endon( "disconnect" );

	for(;;) {
		self waittill( "hijacker", crateType, owner );

		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_HIJACKER" );
		self thread maps\mp\gametypes\_rank::giveRankXP( "hijacker", 100 );

		splashName = "hijacked_airdrop";
		challengeName = "ch_hijacker";

		switch( crateType ) {
			case "sentry":
				splashName = "hijacked_sentry";
				break;
			case "juggernaut":
				splashName = "hijacked_juggernaut";
				break;
			case "remote_tank":
				splashName = "hijacked_remote_tank";
				break;
			case "mega":
			case "emergency_airdrop":
				splashName = "hijacked_emergency_airdrop";
				challengeName = "ch_newjack";
				break;

			default:
				break;
		}


	}
}







