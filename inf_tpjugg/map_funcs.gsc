#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
    replacefunc(maps\mp\killstreaks\_autosentry::updateSentryPlacement, ::updateSentryPlacementReplace);
    replacefunc(maps\mp\killstreaks\_ims::updateImsPlacement, ::updateImsPlacementReplace);

    replacefunc(maps\mp\killstreaks\_helicopter_guard::lbSupport_followPlayer, ::lbSupport_followPlayerReplace);
    replacefunc(maps\mp\killstreaks\_helicopter::heli_explode, ::heli_explode_replace); // cause theres a large explosion in _helicopter that calls it
    replacefunc(maps\mp\killstreaks\_helicopter::heli_crash, ::heli_crash_replace);
    replacefunc(maps\mp\killstreaks\_helicopter::heli_think, ::heli_think_replace);
	replacefunc(maps\mp\killstreaks\_helicopter::heli_fly_well, ::heli_fly_well_replace);
    replacefunc(maps\mp\killstreaks\_helicopter::heli_fly_loop_path, ::heli_fly_loop_path_replace);
    replacefunc(maps\mp\killstreaks\_helicopter::heli_health, ::heli_health_replace);
    
    replacefunc(maps\mp\killstreaks\_ac130::overlay, ::overlayreplace);
    replacefunc(maps\mp\killstreaks\_airdrop::getflyheightoffset, ::getflyheightoffset_edit);
    replacefunc(maps\mp\killstreaks\_airdrop::dropTheCrate, ::dropTheCrate_edit);
	replacefunc(maps\mp\_events::monitorCrateJacking, ::monitorCrateJackingreplace);

	replacefunc(maps\mp\gametypes\_healthoverlay::playerPainBreathingSound, ::playerPainBreathingSound_replace);
	replacefunc(maps\mp\_equipment::trophyActive, ::trophyActive_replace);
	replacefunc(maps\mp\_javelin::EyeTraceForward, ::EyeTraceForward_edit);

	

	

    // decoy is fucked atm
    
    level._meat_location_center = (0,0,0);

    level.mapname = getdvar("ui_mapname");
    level.curObjID = 1;
	level.crates_placed = 1;
    level.usables = [];
    level.teleporter_ents = [];

	level.original_getSpawnPoint = level.getSpawnPoint;
	level.getSpawnPoint = ::new_getspawnpoint;

	replacefunc(maps\mp\gametypes\_spawnlogic::getSpawnpointArray, ::getSpawnpointArray_replace);
	replacefunc(maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints, ::getTeamSpawnPoints_replace);
}


new_getspawnpoint() {
	spawnPoint = self [[level.original_getSpawnPoint]]();
	// if(isdefined(spawnPoint.custom))
	// 	print("^5" + spawnPoint.origin + " = CUSTOM");
	// else if(isdefined(spawnPoint.disabled))
	// 	print("^4" + spawnPoint.origin + " = DISABLED");
	// else
	// 	print("^3" + spawnPoint.origin);
	waittillframeend;
	return spawnPoint;
}

getTeamSpawnPoints_replace( team )
{
	return getSpawnpointArray_replace();
}

getSpawnpointArray_replace( classname )
{
	spawnPoints = getEntArray( "mp_tdm_spawn", "classname" );

	tmp = [];
	for(i=0;i<spawnPoints.size; i++) {
		if(!isdefined(spawnPoints[i].disabled))
			tmp[tmp.size] = spawnPoints[i];
	}

	// print("^3yeetus");
	if ( !isdefined( level.custom_spawnpoints ))
		return tmp;

	// print("^2yeetus");
	for(i=0;i<level.custom_spawnpoints.size; i++) {
		tmp[tmp.size] = level.custom_spawnpoints[i];
	}
		return tmp;
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

createAirDropCrate_edit( owner, dropType, crateType, startPos )
{
	dropCrate = spawn( "script_model", startPos );
	
	dropCrate.curProgress = 0;
	dropCrate.useTime = 0;
	dropCrate.useRate = 0;
	dropCrate.team = self.team;
	
	if ( isDefined( owner ) )
		dropCrate.owner = owner;
	else
		dropCrate.owner = undefined;
	
	dropCrate.crateType = crateType;
	dropCrate.dropType = dropType;
	dropCrate.targetname = "care_package";
	
	dropCrate setModel( maps\mp\gametypes\_teams::getTeamCrateModel( dropCrate.team ) );
	dropCrate thread maps\mp\killstreaks\_airdrop::crateTeamModelUpdater();	

	modelName = "com_plasticcase_friendly";
	if( crateType == "airdrop_trap" )
	{
		modelName = "com_plasticcase_trap_friendly";
		dropCrate thread maps\mp\killstreaks\_airdrop::trap_createBombSquadModel();
	}
	dropCrate.friendlyModel = spawn( "script_model", startPos );
	dropCrate.friendlyModel setModel( modelName );
	dropCrate.enemyModel = spawn( "script_model", startPos );
	dropCrate.enemyModel setModel( "com_plasticcase_enemy" );

	dropCrate.friendlyModel thread maps\mp\killstreaks\_airdrop::deleteOnOwnerDeath( dropCrate );
	if( level.teambased )
		dropCrate.friendlyModel thread maps\mp\killstreaks\_airdrop::crateModelTeamUpdater( dropCrate.team );
	else
		dropCrate.friendlyModel thread maps\mp\killstreaks\_airdrop::crateModelPlayerUpdater( owner, true );

	dropCrate.enemyModel thread maps\mp\killstreaks\_airdrop::deleteOnOwnerDeath( dropCrate );
	if( level.teambased )
		dropCrate.enemyModel thread maps\mp\killstreaks\_airdrop::crateModelTeamUpdater( level.otherTeam[dropCrate.team] );
	else
		dropCrate.enemyModel thread maps\mp\killstreaks\_airdrop::crateModelPlayerUpdater( owner, false );

	dropCrate.inUse = false;
	
	dropCrate.killCamEnt = Spawn( "script_model", dropCrate.origin + (0, 0, 300) );
	dropCrate.killCamEnt SetScriptMoverKillCam( "explosive" );
	dropCrate.killCamEnt LinkTo( dropCrate );

	level.numDropCrates++;
	dropCrate thread maps\mp\killstreaks\_airdrop::dropCrateExistence();

	return dropCrate;
}

dropTheCrate_edit( dropPoint, dropType, lbHeight, dropImmediately, crateOverride, startPos, dropImpulse, previousCrateTypes, tagName )
{
	dropCrate = [];
	self.owner endon ( "disconnect" );
	
	if ( !isDefined( crateOverride ) )
	{
		//	verify emergency airdrops don't drop dupes
		if ( isDefined( previousCrateTypes ) )
		{
			foundDupe = undefined;
			crateType = undefined;
			for ( i=0; i<100; i++ )
			{
				crateType = maps\mp\killstreaks\_airdrop::getCrateTypeForDropType( dropType );
				foundDupe = false;
				for ( j=0; j<previousCrateTypes.size; j++ )
				{
					if ( crateType == previousCrateTypes[j] )
					{
						foundDupe = true;
						break;
					}
				}
				if ( foundDupe == false )
					break;
			}
			//	if 100 attempts fail, just get whatever, we tried		
			if ( foundDupe == true )
			{
				crateType = maps\mp\killstreaks\_airdrop::getCrateTypeForDropType( dropType );
			}
		}
		else
			crateType = maps\mp\killstreaks\_airdrop::getCrateTypeForDropType( dropType );	
	}	
	else
		crateType = crateOverride;
		
	if ( !isDefined( dropImpulse ) )
		dropImpulse = (randomInt(5),randomInt(5),randomInt(5));
		
	dropCrate = createAirDropCrate_edit( self.owner, dropType, crateType, startPos );
	
	switch( dropType )
	{
	case "airdrop_mega":
	case "nuke_drop":
	case "airdrop_juggernaut":
	case "airdrop_juggernaut_recon":
		dropCrate LinkTo( self, "tag_ground" , (64,32,-128) , (0,0,0) );
		break;
	case "airdrop_escort":
	case "airdrop_osprey_gunner":
		dropCrate LinkTo( self, tagName, (0,0,0), (0,0,0) );
		break;
	default:
		dropCrate LinkTo( self, "tag_ground" , (32,0,5) , (0,0,0) );
		break;
	}

	dropCrate.angles = (0,0,0);
	dropCrate show();
	dropSpeed = self.veh_speed;
	
	self thread waitfordropcratemsg_edit( dropPoint, dropCrate, dropImpulse, dropType, crateType );
	
	return crateType;
}

trace_untill_found(dropPoint, crate, var_1, var_2, var_3) {
    self endon("drop_crate");
    yeet = false;
    times = 0;
    while(!yeet) {
        location = bullettrace(dropPoint + (0, 0, 700), dropPoint + (0, 0, -1000), 0, crate);
        if(Distance(dropPoint, location["position"]) < 18) {
            // print("^1Drop Location Found");
            crate.trace = location;
            yeet = true;
        } else if(times >= 12) {
            crate.trace = bullettrace(dropPoint + (0, 0, 700), dropPoint + (0, 0, -1000), 0, crate);
            yeet = true;
        } else {
            times++;
            // print("^2Drop Location Further then distance - " + times);
        }
        wait 0.25;
    }
}

waitfordropcratemsg_edit(dropPoint, crate, var_1, var_2, var_3) {
    thread trace_untill_found(dropPoint, crate, var_1, var_2, var_3);
    self waittill("drop_crate");

    if(!isdefined(crate.trace)) {
        crate.trace = bullettrace(dropPoint + (0, 0, 700), dropPoint + (0, 0, -1000), 0, crate);
		// print("^1TRACENOTDEFINED");
	}
    
    //crate.trace = bullettrace(dropPoint + (0, 0, 700), dropPoint + (0, 0, -1000), 0, crate);
    angles = undefined;
	if(isdefined(crate.trace[ "normal" ]))
        angles = VectorToAngles(crate.trace[ "normal" ]);
    
    crate_ground = undefined;
    crate unlink();
    var_6 = undefined;

    entity_system   = false;
    normal_system   = false;
    physics_system  = false;

    //lerped_pos = VectorLerp(crate.origin, dropPoint, .2);
    //print(crate.origin[2] + " - " + lerped_pos[2] + " - " + dropPoint[2]);
    //crate.trace = bullettrace(lerped_pos, dropPoint + (0, 0, -2000), 0, crate);
	// print(crate.trace["entity"]);
    if(isdefined(crate.trace["entity"]) && isdefined(crate.trace["entity"].origin) && isdefined(crate.trace["entity"].model) && IsSubStr(crate.trace["entity"].model, "com_plasticcase")) {
	    var_5 = distance(crate.origin, crate.trace["entity"].origin);
	    var_6 = var_5 / 800;
        entity_system = true;
	    crate rotatevelocity((randomintrange(0, 360), randomintrange(0, 360), randomintrange(0, 360)), var_6 / 2);
        // print("^3system entity");
        if(isdefined(angles)) {
             forward = anglestoforward(angles);
	         crate moveto(crate.trace[ "position" ] + forward * 15, var_6);
        }
        else
	        crate moveto(crate.trace["entity"].origin + (0, 0, 28), var_6);
		
		crate thread detect_no_prone();
	} else if(isdefined(crate.trace[ "position" ]) && isdefined(crate.trace["entity"]) && isdefined(crate.trace["entity"].model) && crate.trace["entity"].model != "") {
        // print("^3system normal");
        // print("^:" + crate.trace["entity"].model);
		
        normal_system = true;
		crate thread detect_no_prone();
		// crate CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		
		var_5 = distance(crate.origin, crate.trace[ "position" ]);
	    var_6 = var_5 / 800;
	    crate rotatevelocity((randomintrange(0, 360), randomintrange(0, 360), randomintrange(0, 360)), var_6 / 2);
	    forward = anglestoforward(angles);
        crate moveto(crate.trace[ "position" ] + forward * 15, var_6);
    }
	else {
        // print("^3system physics");
        physics_system  = true;
		crate CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		crate physicslaunchserver((0, 0, 0), var_1);
    }

    if(normal_system || entity_system) {
	    crate thread physicswaiter_edit(var_2, var_3, 1);
		if(isdefined(crate.killcament)) {
			crate.killcament unlink();
			// crate.trace = bullettrace(crate.origin, crate.origin + (0, 0, -10000), 0, crate);
			var_5 = distance(crate.origin, crate.trace["position"]);
			var_6 = var_5 / 800;
			crate.killcament moveto(crate.trace["position"] + (0, 0, 300), var_6);
		}
	}
    else {
        crate thread physicswaiter_edit(var_2, var_3);
	}
	
	// print(crate.trace["entity"]);

    if(isdefined(crate.trace["entity"]) && entity_system) {
	    wait var_6 / 2;

	    if(crate.trace["entity"].angles[2] == 0 && crate.trace["entity"].angles[0] == 0) {
	    	crate rotateto((crate.trace["entity"].angles[0], randomintrange(0, 360), crate.trace["entity"].angles[2]), var_6 / 2);
			// print("^2Sys A");
		}
	    else {
	    	crate rotateto((crate.trace["entity"].angles[0], crate.trace["entity"].angles[1], crate.trace["entity"].angles[2]), var_6 / 2);
			// print("^2Sys B");
		}

	    wait var_6 / 2;
	    crate notify("crate_reached_pos");
	} else if(isdefined(crate.trace[ "position" ]) && normal_system) {
        wait var_6 / 2;

	    // if(crate.trace["position"].angles[2] == 0)
	    	// crate rotateto((crate.trace["position"].angles[0], randomintrange(0, 360), crate.trace["position"].angles[2]), var_6 / 2);
	    // else
            // random = randomintrange(0, 360);
	    crate rotateto((90+angles[0], angles[1], angles[2]), var_6 / 2);

	    wait var_6 / 2;
	    crate notify("crate_reached_pos");
    }

}

detect_no_prone() {
	self endon("death");
	for(;;) {
		level waittill("breach_check");
		foreach(player in level.players) {
			if(!isalive(player))
				continue;
			if(!isdefined(player.breaching) && /* player istouching(self) && */ distance(player geteye(), self.origin) < 25) {
				player.breaching = true;
				print("breaching");
			}
		}
	}
}

enable_damage_from_owner() {
    self endon("death");
    self setcandamage(1);
    self.actual_health = 500;
    self.health = 1000000;
    self.maxhealth = 1000000;

    while(isdefined(self)) {
        self waittill("damage", amount, who);

        if(who == self.owner)
            self.actual_health -= (amount * 2);
        else
            self.actual_health -= amount;

        if(self.actual_health <= 0) {
            self maps\mp\killstreaks\_airdrop::deletecrate();
            break;
        }
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
    	self.cz_elements["title"].archived = 0;
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
    	self.cz_elements["reason"].archived = 0;
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
    	self.cz_elements["timer"].archived = 0;
    	self.cz_elements["timer"].fontscale = 1.05;
    	self.cz_elements["timer"].font = "hudbig";
    	self.cz_elements["timer"].label = &"^3";
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

            if(player.cz_elements["title"].alpha == 1) {
            	player notify("flag_teleport");
           		player.inoomzone = 0;
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

CreateTP(enter, exit, angle, slowed, radius, height, delay, noradar, nostatus) {
    thread CreateTPthread(enter, exit, angle, slowed, radius, height, delay, noradar, nostatus);
}

CreateTPthread(enter, exit, angle, slowed, radius, height, delay, noradar, nostatus) {
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

    level thread TpThread(enter, exit, angle, slowed, radius, height, nostatus);
}

TpThread(enter, exit, angle, slowed, radius, height, nostatus){
    level endon("game_ended");

    if(!isdefined(radius))
        radius = 50;
    if(!isdefined(height))
        height = 100;

    trigger = Spawn( "trigger_radius", enter, 0, radius, height );

    for(;;) {
        trigger waittill("trigger", player );

		player thread protection_thread();
        player setorigin(exit);

        if(isdefined(angle)) {
			if(!player UseButtonPressed() && !player SecondaryOffhandButtonPressed() && !player FragButtonPressed())
            	player setplayerangles((player getplayerangles()[0], angle[1], 0));
		}
        if(isdefined(slowed))
            player thread freezeontp();

		if(!isdefined(nostatus))
            player.status = "in";
        else {
            player.status = "out";

            if(player.cz_elements["title"].alpha == 1) {
            	player notify("flag_teleport");
           		player.inoomzone = 0;
    			player.oomAttempts = 0;
    			player SetBlurForPlayer(0, 0);
				
                foreach(hud in player.cz_elements)
    				hud.alpha = 0;
			}
        }

    }
}

protection_thread() {
	self notify("kankermongool");
	self endon("kankermongool");
	self.flag_protection = true;
	self waittill_any_timeout( 0.8, "death" );
	self.flag_protection = undefined;
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
    entity thread overheating();

    if(isdefined(left)) entity SetLeftArc( left ); else entity SetLeftArc( 60 );
    if(isdefined(right)) entity SetRightArc( right ); else entity SetRightArc( 60 );
    if(isdefined(bottom)) entity SetBottomArc( bottom ); else entity SetBottomArc( 35 );
	if(isdefined(top)) entity SetTopArc( top ); else entity SetTopArc( 25 );
    if(isdefined(droppitch)) entity SetDefaultDropPitch( droppitch ); else entity SetDefaultDropPitch( .0 );
}

overheating() {
    self.momentum = 0;
    self.heatLevel = 0;
    self.overheated = 0;
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
		self waittill("trigger", player);

		if(IsDefined(self.inUseBy))
			continue;
		if(!isReallyAlive(player))
			continue;

        self.inuseby = player;
        player.using_minigun = 1;

        player.turret_overheat_bar = player createBar( colorStable, 100, 6 );
		player.turret_overheat_bar setPoint("CENTER", "BOTTOM", 0, -70 );
		player.turret_overheat_bar.alpha = .65;
		player.turret_overheat_bar.bar.alpha = .65;

        while(player IsUsingTurret()) {
			if(self.heatLevel >= self.overheatTime)
				barFrac = 1;
			else
				barFrac = self.heatLevel / self.overheatTime;

			player.turret_overheat_bar updateBar( barFrac );

			if (self.overheated ) {
				self TurretFireDisable();
				player.turret_overheat_bar.bar.color = colorOverheated;
			}
			else if ( self.heatLevel > self.overheatTime * .75)
				player.turret_overheat_bar.bar.color = colorUnstable;
			else if(!self.overheated) {
				player.turret_overheat_bar.bar.color = colorStable;
				self TurretFireEnable();
			}

			wait .05;
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

	self.overheatTime = 9;
	self.overheatCoolDown = .2;

	for(;;) {
		if ( self.heatLevel != self.lastHeatLevel )
			wait ( self.fireTime );
		else
			self.heatLevel = max( 0, self.heatLevel - .05 );

		if ( self.heatLevel > self.overheatTime ) {
			self.overheated = 1;
			self thread PlayHeatFX();

			while ( self.heatLevel ) {
				self.heatLevel = max( 0, self.heatLevel - self.overheatCoolDown );
				wait .1;
			}

			self.overheated = 0;
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

playHeatFX() {
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

launchy() {
	ent = spawn("script_model", self.origin);
	ent setmodel("com_plasticcase_trap_friendly");
	ent.angles = self.angles;
	self delete();
    ent physicslaunchserver((randomintrange(-300, 300), randomintrange(-300, 300), 1000), (randomintrange(-300, 300), randomintrange(-300, 300), 1000));
    wait 15;
    ent delete();
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

spawnmodel(origin, angles, model) {
    entity = spawn("script_model", origin);
    if(isdefined(model))
    	entity setmodel(model);
    entity.angles = angles;

    if(!isdefined(level.lowest_crate))
		level.lowest_crate = origin[2];

	if(origin[2] < level.lowest_crate)
		level.lowest_crate = origin[2];

    return entity;
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

    while(isdefined(level.infect_choseFirstInfected) && !level.infect_choseFirstInfected)
        wait 0.1;

    while(1) {
        foreach(player in level.players) {
            if(player istouching(self.trigger)) {
                if(!isdefined(player.touching_trigger))
                    player.touching_trigger = self;

                if(player usebuttonpressed() && isalive(player)) {
                    if(player.team == "allies") {
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
                    else {
                        if(self.state == "closed") {
                            if(self.hp > 0) {
                                if(!isdefined(player.door_cooldown)) {
                                    player notify("door_damage");
									player PlayLocalSound("grenade_bounce_flesh");

                                    self.hp -= 1;
                                }
                            }
                            else {
                                foreach(ent in self.linked_ents)
                                    ent thread launchy();
                                self playSound( "exp_suitcase_bomb_main" );
                                playfx(level.harrier_deathfx, self.origin);
                                self.trigger delete();
                                self delete();
                                self notify("destroyed_door");
                            }
                        }
                    }
                }
            }
            else if(isdefined(player.touching_trigger)) {
                good = 0;

                foreach(trig in level.door_triggers) {
                    if(isdefined(trig)) {
                        if(player istouching(trig))
                            good = 1;
                    }
                }

                if(good == 0)
                    player.touching_trigger = undefined;
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

        self thread check_stuck_ppl();
    }
    else {
        self moveto(self.close, 3);
        wait 3;
        self.state = "closed";
        self.moving = 0;

        self thread check_stuck_ppl();
    }
}

check_stuck_ppl() {
    org = undefined;

    foreach(player in level.players) {
        if(isdefined(player.touching_trigger) && player.touching_trigger == self) {
            org = player.origin;
            player setvelocity((0, 0, 15));
            wait .05;
            if(player.origin == org)
                player setorigin(player.save_origin);
        }
    }
}

spawnCrate(origin, angles, model) {
    entity = spawn("script_model", origin);
    if(isdefined(level.showinviscrates))
		entity setmodel("com_plasticcase_trap_bombsquad");
    else if(isdefined(model))
    	entity setmodel(model);
    entity.angles = angles;
    entity CloneBrushmodelToScriptmodel(level.airDropCrateCollision);

    if(!isdefined(level.lowest_crate))
		level.lowest_crate = origin[2];

	if(origin[2] < level.lowest_crate)
		level.lowest_crate = origin[2];

	level.crates_placed++;

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

	sentryGun.canBePlaced = 1;
	lastCanPlaceSentry = -1;

	for(;;) {
        placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), 0, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), 0, self);

		sentryGun.origin = placement[ "origin" ];
		sentryGun.angles = placement[ "angles" ];
		sentryGun.canBePlaced = self isOnGround()  && ( abs(sentryGun.origin[2]-self.origin[2]) < 10 ) && placement[ "result" ] && traceer || trace["fraction"] < 1 && traceer;

		if(sentryGun.canBePlaced != lastCanPlaceSentry) {
			if (sentryGun.canBePlaced) {
				sentryGun setModel( level.sentrySettings[ sentryGun.sentryType ].modelPlacement);
				self ForceUseHintOn( &"SENTRY_PLACE" );
			}
			else {
				sentryGun setModel(level.sentrySettings[ sentryGun.sentryType ].modelPlacementFailed);
				self ForceUseHintOn( &"SENTRY_CANNOT_PLACE" );
			}
		}

		lastCanPlaceSentry = sentryGun.canBePlaced;
		wait .05;
	}
}

updateIMSPlacementReplace( ims ) {
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	ims endon ( "placed" );
	ims endon ( "death" );

	ims.canBePlaced = 1;
	lastCanPlaceIMS = -1; // force initial update

	for(;;) {
		placement = self canPlayerPlaceSentry();

        forang = anglestoforward(self getplayerangles());
        position = self.origin + forang * 55;
        trace = bullettrace(position + (0,0,50), position - (0,0,30), 0, self);
        traceer = bullettracepassed(self.origin + (0,0,40), position + (0,0,40), 0, self);

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

        wait .05;
	}
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
    //level.meat_playable_bounds
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

title_warning_pulse() {
	level endon("game_ended");
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
    self.inoomzone = 0;

    foreach(hud in self.cz_elements)
    	hud.alpha = 0;

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

    if(isdefined(test)) {
        while(1) {
            trigger waittill( "trigger", player );

            player IPrintLn("^1INSIDE DEATHRADIUS");
            player IPrintLnbold("^1INSIDE DEATHRADIUS");
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

	self.inTransit = 1;
    a = distance(self.owner.origin, self.origin);
    if(a  > 1000)
        self Vehicle_SetSpeed( (a / 30), (a / 30)/10, (a / 30)/10 );
    else
        self Vehicle_SetSpeed( self.speed, 60, 30 );
	self setVehGoalPos( self.owner.origin + (0,0,700) + (randomintrange(-50,50),randomintrange(-50,50),randomintrange(-10,10)), 1 );
	self waittill ( "goal" );
	self.inTransit = 0;
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

	while(1) {
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
	level.HUDItem[ "enhanced_vision" ].alpha = 1;

	player thread maps\mp\killstreaks\_ac130::overlay_coords();
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
            if(isdefined(model)) {
                cannonball setmodel("com_plasticcase_trap_friendly");
                cannonball2 setmodel("com_plasticcase_trap_friendly");
            }

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
            if(isdefined(model)) {
                cannonball setmodel(model);
                cannonball2 setmodel(model);
            }
        }

        wait .5;
    }
}

cannonball_launch(start, time, zOffset, zPeakProgress, end) {
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
			break;
		}
	}

	if(isdefined(ent)) {
		earthQuake(.6, 3, self.origin, 200);
		self unlink();
		ent delete();
	}
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

    self thread enable_damage_from_owner();

	if(isdefined(self)) {
    	self thread [[ level.cratefuncs[var_0][var_1] ]]( var_0 );
    	level thread maps\mp\killstreaks\_airdrop::droptimeout( self, self.owner, var_1 );

    	if(distance(self.origin, var_3) > 3500 || self.owner.team != self.team)
        	self maps\mp\killstreaks\_airdrop::deletecrate();

		if(isdefined(level.lowest_crate)) {
    		if(self.origin[2] < level.lowest_crate && self.origin[2] < level.lowspawn.origin[2])
    			self maps\mp\killstreaks\_airdrop::deletecrate();
    	}

        if(isdefined(level.teleporter_ents)) {
            foreach(ent in level.teleporter_ents) {
                if(distance2d(self.origin, ent.origin) < 50)
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

        if(owner.sessionteam != self.sessionteam)
            say_raw("^4^7[ ^4Information^7 ] ^2" + self.name + " ^7Stole ^1" + owner.name + "^7's Carepackage!");

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



////////////////////////// helicopter functions ///////////////////////

heli_fly_loop_path_custom(  )
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	self notify( "flying");
	self endon( "flying" );
	
	maps\mp\killstreaks\_helicopter::heli_reset();
	position = undefined;
    rndpos = undefined;
	while (1)
	{
        for(i=0; i<8; i++) {
            for(;;) {
                rndpos = self.owner.origin + (randomintrange(-2400, 2400),randomintrange(-2400, 2400),randomintrange(2500, 2900));
                if(Distance2D(rndpos, self.owner.origin) > 800)
                    break;
            }

            if(SightTracePassed(rndpos, self.owner.origin, false, self)) {
                position = rndpos;
                break;
            }
        }

        if(!isdefined(position))
            position = self.owner.origin + (randomintrange(-2400, 2400),randomintrange(-2400, 2400),randomintrange(2500, 2900));
		
		self setVehGoalPos( position, true );
		self waittill( "near_goal" );

        rnd = randomintrange(0, 30) / 10;
        if(rnd != 0)
		    wait( rnd );
	}
}

heli_fly_simple_path_custom(dying)
{
	self endon ( "death" );
	self endon ( "leaving" );

	// only one thread instance allowed
	self notify( "flying");
	self endon( "flying" );

	maps\mp\killstreaks\_helicopter::heli_reset();

    // dying = false;
    // if( self.damageTaken > self.maxhealth )
        // dying = true;
	if(!isdefined(dying))
		dying = false;
    
    position = undefined;

    if(!dying) {
        position = self.owner.origin + (randomintrange(-2400, 2400),randomintrange(-2400, 2400),randomintrange(2500, 2900));

        self setVehGoalPos( position, true );
		self waittill( "near_goal" );
    } else {
        endpos = undefined;
        trace = undefined;
        self Vehicle_SetSpeed( 50, 10 , 60);
        self setneargoalnotifydist( 135 );

        for(i=0; i<4; i++) {
            rndpos = self.owner.origin + (randomintrange(-1600, 1600),randomintrange(-1600, 1600),2000);
            trace = BulletTrace(rndpos, rndpos + (0,0,-4000), 1, self, 1, 1);
            if(isdefined(trace["position"]) && isdefined(trace["fraction"]) && trace["fraction"] < 1) {
                position = trace["position"];
                break;
            }
        }
        
        if(!isdefined(position))
            position = level.players[randomint(level.players.size)].origin;
            
        self setVehGoalPos( position, true );
        self thread wall_detection_crash(position);
		self waittill_any( "near_goal" , "died_fly_wall");
    }

}

wall_detection_crash(position) {
    self endon ( "death" );
	self endon ( "leaving" );
    self endon ( "near_goal" );

    for(;;) {
        ang = anglestoforward(VectortoAngles(position - self.origin));
        trace = BulletTrace(self.origin, self.origin + ang * 300, 0, self, 1, 1, self.attractor);
        if(isdefined(trace["fraction"]) && trace["fraction"] < 0.9) {
            self notify("died_fly_wall");
            return;
        }
        wait 0.1;
    }
}

heli_explode_replace( altStyle , harrier)
{
	self notify( "death" );
    self.heli_explode_death = 1;
	
	if ( isDefined( altStyle ) && isDefined( level.chopper_fx["explode"]["air_death"][self.heli_type] ) ) {
		deathAngles = self getTagAngles( "tag_deathfx" );

        self RadiusDamage( self.origin + ( 0, 0, 10 ), 350, 500, 1, self );
		if(isDefined( harrier )) {
			deathAngles = self getTagAngles( "tag_deathfx" );		
			playFx( level.harrier_deathfx, self getTagOrigin( "tag_deathfx" ), anglesToForward( deathAngles ), anglesToUp( deathAngles ) );
		} else
			playFx( level.chopper_fx["explode"]["air_death"][self.heli_type], self getTagOrigin( "tag_deathfx" ), anglesToForward( deathAngles ), anglesToUp( deathAngles ) );
		//playFxOnTag( level.chopper_fx["explode"]["air_death"][self.heli_type], self, "tag_deathfx" );	
	}
	else {
		org = self.origin;	
		forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;
		if(isDefined( harrier )) {
			deathAngles = self getTagAngles( "tag_deathfx" );		
			playFx( level.harrier_deathfx, self getTagOrigin( "tag_deathfx" ), anglesToForward( deathAngles ), anglesToUp( deathAngles ) );
		} else
			playFx( level.chopper_fx["explode"]["death"][self.heli_type], org, forward );
        self RadiusDamage( self.origin + ( 0, 0, 10 ), 350, 500, 1, self );
	}
	
	
	// play heli explosion sound
	if(isDefined( harrier )) {
		self playSound( "harrier_jet_crash" );
	} else
		self playSound( level.heli_sound[self.team]["crash"] );

	// give "death" notify time to process
	wait ( 0.05 );
	
	if( IsDefined( self.killCamEnt ) )
		self.killCamEnt delete();

	// decrement the faux vehicle count right before it is deleted this way we know for sure it is gone
	if(!isDefined( harrier )) {
		decrementFauxVehicleCount();
	}
	else {
		level.airPlane[level.airPlane.size - 1] = undefined; 
		self notify ( "explode" );
		wait 0.05;
	}
	
	self delete();
}

heli_crash_replace(harrier)
{
	self notify( "crashing" );

	self thread maps\mp\killstreaks\_helicopter::heli_spin( 1028 );
	self thread maps\mp\killstreaks\_helicopter::heli_secondary_explosions();
	self heli_fly_simple_path_custom(true);
	
	self thread heli_explode_replace(undefined, harrier);
}

heli_think_replace( lifeId, owner, startNode, heli_team, heliType )
{   
    if(isdefined(level.use_stock_helicopter_system))
        self thread stock_helicopter_logic( lifeId, owner, startNode, heli_team, heliType );
    else
        self thread custom_helicopter_logic( lifeId, owner, startNode, heli_team, heliType );
}

stock_helicopter_logic( lifeId, owner, startNode, heli_team, heliType ) {
    heliOrigin = startNode.origin;
	heliAngles = startNode.angles;

	switch( heliType )
	{
		case "minigun":
			vehicleType = "cobra_minigun_mp";
			if ( owner.team == "allies" )
				vehicleModel = "vehicle_apache_mp";
			else
				vehicleModel = "vehicle_mi-28_mp";
			break;
		case "flares":
			vehicleType = "pavelow_mp";
			if ( owner.team == "allies" )
				vehicleModel = "vehicle_pavelow";
			else
				vehicleModel = "vehicle_pavelow_opfor";
			break;
		default:
			vehicleType = "cobra_mp";
			if ( owner.team == "allies" )
			//	vehicleModel = "vehicle_apache_iw5";
				vehicleModel = "vehicle_cobra_helicopter_fly_low";
			else
				vehicleModel = "vehicle_mi24p_hind_mp";
			break;		
	}

	chopper = maps\mp\killstreaks\_helicopter::spawn_helicopter( owner, heliOrigin, heliAngles, vehicleType, vehicleModel );

	if ( !isDefined( chopper ) )
		return;
		
	level.chopper = chopper;
	chopper.heliType = heliType;
	chopper.lifeId = lifeId;
	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;	
	chopper.owner = owner;
	//chopper ThermalDrawEnable();

	if ( heliType == "flares" )
		chopper.maxhealth = 2500;			// max health
	else
		chopper.maxhealth = 1500;			// max health

	chopper.targeting_delay = level.heli_targeting_delay;		// delay between per targeting scan - in seconds
	chopper.primaryTarget = undefined;					// primary target ( player )
	chopper.secondaryTarget = undefined;				// secondary target ( player )
	chopper.attacker = undefined;						// last player that shot the helicopter
	chopper.currentstate = "ok";						// health state
	
	chopper.empGrenaded = false;

	if ( heliType == "flares" || heliType == "minigun" )
		chopper thread maps\mp\killstreaks\_helicopter::heli_flares_monitor();
	
	// helicopter loop threads
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_damage_monitor();				// monitors damage
	chopper thread maps\mp\killstreaks\_helicopter::heli_health();						// display helicopter's health through smoke/fire
	chopper thread maps\mp\killstreaks\_helicopter::heli_existance();

	// flight logic
	chopper endon ( "helicopter_done" );
	chopper endon ( "crashing" );
	chopper endon ( "leaving" );
	chopper endon ( "death" );

	// initial flight into play space	
	if ( heliType == "minigun" )
	{
		owner thread maps\mp\killstreaks\_helicopter::heliRide( lifeId, chopper );
		chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_spawned( owner );
	}

	attackAreas = getEntArray( "heli_attack_area", "targetname" );
	//attackAreas = [];
	loopNode = level.heli_loop_nodes[ randomInt( level.heli_loop_nodes.size ) ];	

	// specific logic per type
	switch ( heliType )
	{
		case "minigun":
			chopper thread maps\mp\killstreaks\_helicopter::heli_targeting();
			chopper maps\mp\killstreaks\_helicopter::heli_fly_simple_path( startNode );
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 40.0 );
			if ( attackAreas.size )
				chopper thread maps\mp\killstreaks\_helicopter::heli_fly_well( attackAreas );
			else
				chopper thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path( loopNode );
			break;
		case "flares":
			chopper thread maps\mp\killstreaks\_helicopter::makeGunShip();
			thread teamPlayerCardSplash( "used_helicopter_flares", owner );
			chopper maps\mp\killstreaks\_helicopter::heli_fly_simple_path( startNode );
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 60.0 );
			chopper thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path( loopNode );
			break;
		default:
			chopper thread maps\mp\killstreaks\_helicopter::attack_targets();
			chopper thread maps\mp\killstreaks\_helicopter::heli_targeting();
			chopper maps\mp\killstreaks\_helicopter::heli_fly_simple_path( startNode );
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 60.0 );
			chopper thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path( loopNode );
			break;
	}
}

custom_helicopter_logic( lifeId, owner, startNode, heli_team, heliType ) {
    org = AnglesToForward((0,randomintrange(-180,180),0));
    heliOrigin = self.origin + (org[0]*8000,org[1]*8000,5700);
    ang = VectortoAngles(self.origin - startNode.origin);
    heliAngles = (0,ang[1],0);

	switch( heliType )
	{
		case "minigun":
			vehicleType = "cobra_minigun_mp";
			if ( owner.team == "allies" )
				vehicleModel = "vehicle_apache_mp";
			else
				vehicleModel = "vehicle_mi-28_mp";
			break;
		case "flares":
			vehicleType = "pavelow_mp";
			if ( owner.team == "allies" )
				vehicleModel = "vehicle_pavelow";
			else
				vehicleModel = "vehicle_pavelow_opfor";
			break;
		default:
			vehicleType = "cobra_mp";
			if ( owner.team == "allies" )
			//	vehicleModel = "vehicle_apache_iw5";
				vehicleModel = "vehicle_cobra_helicopter_fly_low";
			else
				vehicleModel = "vehicle_mi24p_hind_mp";
			break;		
	}

	chopper = maps\mp\killstreaks\_helicopter::spawn_helicopter( owner, heliOrigin, heliAngles, vehicleType, vehicleModel );

	if ( !isDefined( chopper ) )
		return;
		
	level.chopper = chopper;
	chopper.heliType = heliType;
	chopper.lifeId = lifeId;
	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;	
	chopper.owner = owner;
	//chopper ThermalDrawEnable();

	if ( heliType == "flares" )
		chopper.maxhealth = level.heli_maxhealth*2;			// max health
	else
		chopper.maxhealth = level.heli_maxhealth;			// max health

	chopper.targeting_delay = level.heli_targeting_delay;		// delay between per targeting scan - in seconds
	chopper.primaryTarget = undefined;					// primary target ( player )
	chopper.secondaryTarget = undefined;				// secondary target ( player )
	chopper.attacker = undefined;						// last player that shot the helicopter
	chopper.currentstate = "ok";						// health state
	
	chopper.empGrenaded = false;

	if ( heliType == "flares" || heliType == "minigun" )
		chopper thread maps\mp\killstreaks\_helicopter::heli_flares_monitor();
	
	// helicopter loop threads
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended( owner );
	chopper thread maps\mp\killstreaks\_helicopter::heli_damage_monitor();				// monitors damage
	chopper thread maps\mp\killstreaks\_helicopter::heli_health();						// display helicopter's health through smoke/fire
	chopper thread maps\mp\killstreaks\_helicopter::heli_existance();

	// flight logic
	chopper endon ( "helicopter_done" );
	chopper endon ( "crashing" );
	chopper endon ( "leaving" );
	chopper endon ( "death" );

	// initial flight into play space	
	if ( heliType == "minigun" )
	{
		owner thread maps\mp\killstreaks\_helicopter::heliRide( lifeId, chopper );
		chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_spawned( owner );
	}

	// specific logic per type
	switch ( heliType )
	{
		case "minigun":
			chopper thread maps\mp\killstreaks\_helicopter::heli_targeting();
			chopper heli_fly_simple_path_custom();
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 40.0 );
			chopper thread heli_fly_loop_path_custom();
			break;
		case "flares":
			chopper thread maps\mp\killstreaks\_helicopter::makeGunShip();
			thread teamPlayerCardSplash( "used_helicopter_flares", owner );
			chopper heli_fly_simple_path_custom();
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 60.0 );
			chopper thread heli_fly_loop_path_custom();
			break;
		default:
			chopper thread maps\mp\killstreaks\_helicopter::attack_targets();
			chopper thread maps\mp\killstreaks\_helicopter::heli_targeting();
			chopper heli_fly_simple_path_custom();
			chopper thread maps\mp\killstreaks\_helicopter::heli_leave_on_timeout( 60.0 );
			chopper thread heli_fly_loop_path_custom();
			break;
	}
}

heli_fly_well_replace( destNodes )
{
	if(!isdefined(level.use_stock_helicopter_system)) {
		level heli_fly_loop_path_custom(destNodes);
		return;
	}

	self notify( "flying");
	self endon( "flying" );

	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	for ( ;; )	
	{
		currentNode = self maps\mp\killstreaks\_helicopter::get_best_area_attack_node( destNodes );
	
		maps\mp\killstreaks\_helicopter::travelToNode( currentNode );
		
		// motion change via node
		if( isdefined( currentNode.script_airspeed ) && isdefined( currentNode.script_accel ) )
		{
			heli_speed = currentNode.script_airspeed;
			heli_accel = currentNode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 15+randomInt(15);
		}
		
		self Vehicle_SetSpeed( heli_speed, heli_accel );	
		self setvehgoalpos( currentNode.origin + self.zOffset, 1 );
		self setgoalyaw( currentNode.angles[ 1 ] + level.heli_angle_offset );	

		if ( level.heli_forced_wait != 0 )
		{
			self waittill( "near_goal" ); //self waittillmatch( "goal" );
			wait ( level.heli_forced_wait );			
		}
		else if ( !isdefined( currentNode.script_delay ) )
		{
			self waittill( "near_goal" ); //self waittillmatch( "goal" );

			wait ( 5 + randomInt( 5 ) );
		}
		else
		{				
			self waittillmatch( "goal" );				
			wait ( currentNode.script_delay );
		}
	}
}

heli_fly_loop_path_replace( startNode )
{
	if(!isdefined(level.use_stock_helicopter_system)) {
		level heli_fly_loop_path_custom(startNode);
		return;
	}

	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	// only one thread instance allowed
	self notify( "flying");
	self endon( "flying" );
	
	maps\mp\killstreaks\_helicopter::heli_reset();
	
	self thread maps\mp\killstreaks\_helicopter::heli_loop_speed_control( startNode );
	
	currentNode = startNode;
	while ( isDefined( currentNode.target ) )
	{
		nextNode = getEnt( currentNode.target, "targetname" );
		assertEx( isDefined( nextNode ), "Next node in path is undefined, but has targetname. Bad Node Position: " + currentNode.origin );
		
		if( isDefined( currentNode.script_airspeed ) && isDefined( currentNode.script_accel ) )
		{
			self.desired_speed = currentNode.script_airspeed;
			self.desired_accel = currentNode.script_accel;
		}
		else
		{
			self.desired_speed = 30 + randomInt( 20 );
			self.desired_accel = 15 + randomInt( 15 );
		}
		
		if ( self.heliType == "flares" )
		{
			self.desired_speed *= 0.5;
			self.desired_accel *= 0.5;
		}
		
		if ( isDefined( nextNode.script_delay ) && isDefined( self.primaryTarget ) && !self maps\mp\killstreaks\_helicopter::heli_is_threatened() )
		{
			self setVehGoalPos( nextNode.origin+(self.zOffset), true );
			self waittill( "near_goal" );

			wait ( nextNode.script_delay );
		}
		else
		{
			self setVehGoalPos( nextNode.origin+(self.zOffset), false );
			self waittill( "near_goal" );

			self setGoalYaw( nextNode.angles[ 1 ] );

			self waittillmatch( "goal" );
		}

		currentNode = nextNode;
	}
}

////////////////////////////// end helicopter ////////////////////////
 
playerPainBreathingSound_replace( useless )
{
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "joined_team" );
	self endon ( "joined_spectators" );
	
	wait ( 2 );

	for (;;)
	{
		wait ( 0.2 );
		
		if ( self.health <= 0 )
			return;
			
		// Player still has a lot of health so no breathing sound
		if ( self.health >= self.maxhealth * 0.55 )
			continue;
		
		if ( level.healthRegenDisabled && gettime() > self.breathingStopTime )
			continue;
			
		if( self isUsingRemote() )
			continue;

		self playLocalSound( "breathing_hurt" );

		wait ( .784 );
		wait ( 0.1 + randomfloat (0.8) );
	}
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

disable_spawn_point(remove_spawn_array, debug) {
	spawn_points = getEntArray( "mp_tdm_spawn", "classname" );
	if(isdefined(debug)) {
		foreach(item in spawn_points) {
			ent = spawn("script_model", item.origin);
			ent.angles = (90,0,0);
			print("disable_spawn_array[disable_spawn_array.size] = " + item.origin + ";");
		}
	}
	// print("^1DISABLING SPAWNS");
	foreach(item in remove_spawn_array) {
		// found = false;
		for(i=0;i<spawn_points.size;i++) {
			if(distance(spawn_points[i].origin, item) < 15) {
				spawn_points[i].disabled = true;
				// print(item + " ^2Disabled");
				// found = true;
			}
			// else
				// print("skipping - " + spawn_points[i].origin + " __ " + item);
		}
	}
}

add_spawn_point(origin, angles) {
	if(!isdefined(level.custom_spawnpoints))
		level.custom_spawnpoints = [];

	ent = spawn("script_origin", origin);
	ent.origin = origin;
	ent.angles = angles;
	ent.custom = true;
	
	level.custom_spawnpoints[level.custom_spawnpoints.size] = ent;
}



delete_all_spawn_except(exception) {
	all_ents = getentarray();
	// print("^1" + all_ents.size);
	temp_array = [];
	for(i=0;i<all_ents.size;i++) {
		if(IsSubStr(all_ents[i].classname,"_spawn"))
			temp_array[temp_array.size] = all_ents[i];
	}
	// print("^3" + temp_array.size);
	temp_array_2 = [];
	for(i=0;i<temp_array.size;i++) {
		if(!IsSubStr(temp_array[i].classname,exception)) {
			temp_array_2[temp_array_2.size] = true;
			temp_array[i] delete();
		}
	}
	// print("^2" + temp_array_2.size);

}

heli_health_replace()
{
	self endon( "death" );
	self endon( "leaving" );
	self endon( "crashing" );
	
	self.currentstate = "ok";
	self.laststate = "ok";
	self setDamageState( 3 );
	
	damageState = 3;
	self setDamageState( damageState );
	
	for ( ;; )
	{
		if ( self.damageTaken >= (self.maxhealth * 0.33) && damageState == 3 )
		{
			damageState = 2;
			self setDamageState( damageState );
			self.currentstate = "light smoke";
			playFxOnTag( level.chopper_fx["damage"]["light_smoke"], self, "tag_engine_left" );
		}
		else if ( self.damageTaken >= (self.maxhealth * 0.66) && damageState == 2 )
		{
			damageState = 1;
			self setDamageState( damageState );
			self.currentstate = "heavy smoke";
			stopFxOnTag( level.chopper_fx["damage"]["light_smoke"], self, "tag_engine_left" );
			playFxOnTag( level.chopper_fx["damage"]["heavy_smoke"], self, "tag_engine_left" );
		}
		else if( self.damageTaken > self.maxhealth )
		{
			damageState = 0;
			self setDamageState( damageState );

			stopFxOnTag( level.chopper_fx["damage"]["heavy_smoke"], self, "tag_engine_left" );
			
			playFxOnTag( level.chopper_fx["damage"]["on_fire"], self, "tag_engine_left" );
			self thread heli_crash_replace();
		}
		
		wait 0.05;
	}
}


trophyActive_replace( owner )
{
	owner endon( "disconnect" );
	self endon ( "death" );
	
	position = self.origin;
	
	for( ;; )
	{
		wait 0.05;
		if ( !isDefined( level.grenades ) || ( level.grenades.size < 1 && level.missiles.size < 1 ) || isDefined( self.disabled ) )
		{
			continue;
		}
		
		sentryTargets = combineArrays ( level.grenades, level.missiles );
		
		i=1;
		foreach ( grenade in sentryTargets )
		{
			if(i % 10 == 0) {
				wait( .05 );
			}

			i++;

			if ( !isDefined(grenade) )
				continue;
			
			if ( grenade == self )
				continue;
			
			switch( grenade.model )
			{
			case "mp_trophy_system":
			case "weapon_radar":
			case "weapon_jammer":
			case "weapon_parabolic_knife":
				continue;
			}
			
			if ( isDefined( grenade.weaponName) )
			{
				switch( grenade.weaponName )
				{
				case "claymore_mp":
					continue;
				}
			}

	
			if ( !isDefined( grenade.owner ) )
				grenade.owner = GetMissileOwner( grenade );
			
			//assertEx( isDefined( grenade.owner ), "grenade has no owner"  );
			//grenades owner may have disconnected by now if they do we should just assume enemy and detonate it.
			
			if ( isDefined( grenade.owner ) && level.teamBased && grenade.owner.team == owner.team )
				continue;
			
			//dont blow up owners grenades in FFA	
			if ( isDefined( grenade.owner ) && grenade.owner == owner )
				continue;

			
			grenadeDistanceSquared = DistanceSquared( grenade.origin, (self.origin + (0,0,20)) );
			
			if ( grenadeDistanceSquared < 147456 )
			{
				if ( BulletTracePassed( grenade.origin, (self.origin + (0,0,10)), false, self ) || BulletTracePassed( grenade.origin, (self.origin + (0,0,30)), false, self ))
				{
					playFX( level.sentry_fire, self.origin + (0,0,32) , ( grenade.origin - self.origin ), AnglesToUp( self.angles ) );
					self playSound( "trophy_detect_projectile" );
					
					owner thread maps\mp\_equipment::projectileExplode( grenade, self );
					owner maps\mp\gametypes\_missions::processChallenge( "ch_noboomforyou" );			

					self.ammo--;
					
					if ( self.ammo <= 0 )
						self thread maps\mp\_equipment::trophyBreak();
				}
			}	
		}
	}
}


EyeTraceForward_edit()
{
	origin = self GetEye();
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );
	endpoint = origin + forward * 30000;
	
	res = BulletTrace( origin, endpoint, false, undefined );

	if ( res["surfacetype"] == "none" )
		return undefined;
	if ( res["surfacetype"] == "default" )
		return undefined;

	ent = res["entity"];
	if ( IsDefined( ent ) )
	{
		if ( ent == level.ac130.planeModel )
			return undefined;
	}

	results = [];
	results[0] = res["position"];
	results[1] = res["normal"];
	return results;
}


show_route_arrows(array, delay) {
    thread show_route_arrows_thread(array, delay);
}

show_route_arrows_thread(array, delay) {
    arrindex = undefined;
    if(!isdefined(level.arrowindex)) {
        level.arrowindex = 0;
        arrindex = level.arrowindex;
    }
    else {
        level.arrowindex++;
        arrindex = level.arrowindex;
    }


    if(isdefined(delay)){
        level endon("kill_arrows_" + arrindex);
        delay = delay * 60;
        thread notify_after_time( delay , "kill_arrows_" + arrindex );
    }
    
    arrow_array = [];
    for(i=0;i<array.size - 1;i++) { 
        arrow_array[i] = spawn("script_model", array[i]);
        arrow_array[i] setmodel("sundirection_arrow");
        arrow_array[i].angles = VectortoAngles(array[i] - array[i + 1]);
        arrow_array[i].current_node = i;
        if(isdefined(delay))
            arrow_array[i] thread delete_after_level_notify("kill_arrows_" + arrindex );
    }


    for(;;) { 

        for(i=0;i<arrow_array.size;i++) {
            arrow_array[i].current_node = arrow_array[i].current_node + 1;
            if(arrow_array[i].current_node > array.size - 1) {
                arrow_array[i].current_node = 1;
                arrow_array[i].origin = array[0];
                arrow_array[i].angles = VectortoAngles(array[0] - array[arrow_array[i].current_node]);
            }

            arrow_array[i] MoveTo(array[arrow_array[i].current_node], 3);
        }

        wait 2;

        for(i=0;i<arrow_array.size;i++) {
            if(arrow_array[i].current_node < arrow_array.size)
                arrow_array[i] RotateTo(VectortoAngles(array[arrow_array[i].current_node] - array[arrow_array[i].current_node + 1]), 1);
        }

        wait 1;
    }
}

notify_after_time(delay, string) {
    wait delay;
    level notify(string);
}

delete_after_level_notify(string) {
    level waittill(string);
    self delete();
}

antibreach(position, range, height) {
    if(!isdefined(level.antibreachtriggers))
        level.antibreachtriggers = [];

    level.antibreachtriggers[level.antibreachtriggers.size] = Spawn( "trigger_radius", position, 0, range, height);
}

antibreach_box(position1, position2) {
    if(!isdefined(level.antibreachtriggers))
        level.antibreachtriggers = [];

    index = level.antibreachtriggers.size;
    level.antibreachtriggers[index] = SpawnStruct();
    level.antibreachtriggers[index].classname = "cube";
    level.antibreachtriggers[index].corner1 = position1;
    level.antibreachtriggers[index].corner2 = position2;
}

anti_breach_logic() {

	for(;;) {
		wait 0.5;
		foreach(player in level.players) {
			player.breaching = undefined;
		}

		if(isdefined(level.antibreachtriggers)) {
			for(i=0;i<level.antibreachtriggers.size;i++) {
				foreach(player in level.players) {
					if(player.team != "allies")
						continue;
					
					if(level.antibreachtriggers[i].classname == "trigger_radius") {
						if(player istouching(level.antibreachtriggers[i]))
							player.breaching = true;
					}
					else {
						if(insideRegionZ(level.antibreachtriggers[i].corner1, level.antibreachtriggers[i].corner2, player.origin))
							player.breaching = true;
					}
				}
			}
		}
		
		level notify("breach_check");
	}
}
