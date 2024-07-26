#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	
    //level thread onPlayerConnect(); ////////////////// Comment This Line Out To Enable/Disable Block Logging, +talk/Voicechat Key To Place. Gets Logged in games_mp

    level.MSGNUMBER = 0;
    level.flag_ref = 0;
    level.waittime = 0.05;
	level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
    level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );

    precacheModel( level.elevator_model["enter"] );
    precacheModel( level.elevator_model["exit"] );
	

    if(getDvar("mapname") == "mp_rust"){ /** rust **/
		level thread Rust();
	}
    else if(getDvar("mapname") == "mp_terminal_cls"){ /** Terminal **/
		level thread Terminal();
	}
	else if(getDvar("mapname") == "mp_quarry"){ /** Quarry **/
		level thread Quarry();
	}
	else if(getDvar("mapname") == "mp_dome"){ /** Dome **/
		level thread Dome();
	}
	else if(getDvar("mapname") == "mp_bootleg"){ /** Bootleg **/
		level thread Bootleg();
	}	else if(getDvar("mapname") == "mp_courtyard_ss"){ /** Erosion **/
		level thread Erosion();
	}	else if(getDvar("mapname") == "mp_bravo"){ /** Mission **/
		level thread Mission();
    }	else if(getDvar("mapname") == "mp_village"){ /** Village **/
		level thread Village();
    }	else if(getDvar("mapname") == "mp_aground_ss"){ /** Aground **/
		level thread Aground();
    }
}

Rust()
{
    CreateBlocks((1185, 1620, -200), (-10, 180, 0));
    CreateBlocks((1185, 1635, -170), (-10, 180, 0));

    CreateBlocks((1240, 1620, -200), (-10, 180, 0));
    CreateBlocks((1240, 1635, -175), (-10, 180, 0));
	
	CreateGrids((1315, 100, 0), (1315, 10, 0),(0, 0, 0));
}

Aground()
{
    CreateBlocks((684, 1567, 520), (90, 0, 0));
    CreateBlocks((652, 1559, 520), (90, 20, 0));
    CreateBlocks((622, 1537, 520), (90, 50, 0));

    CreateBlocks((581, 1142, 470), (90, -20, 0));
    CreateBlocks((540, 1139, 470), (90, 20, 0));

	CreateBlocks((360, -110, -10), (0, 0, 0));
    CreateBlocks((410, -110, -20), (0, 0, 0));

    CreateBlocks((460, -110, -30), (0, 0, 0));
    CreateBlocks((460, -80, -30), (0, 0, 0));
    CreateBlocks((460, -50, -30), (0, 0, 0));
    CreateBlocks((460, -20, -30), (0, 0, 0));

    CreateBlocks((510, -110, -30), (0, 0, 0));
    CreateBlocks((510, -80, -30), (0, 0, 0));
    CreateBlocks((510, -50, -30), (0, 0, 0));
    CreateBlocks((510, -20, -30), (0, 0, 0));
}

Village()
{
    CreateBlocks((-1187, -822, 550), (0, 0, 0));
    CreateBlocks((-1187, -822, 590), (0, 0, 0));

    CreateBlocks((-2015, 984, 305), (0, 30, 0));
    CreateBlocks((-2015, 1022, 305), (0, -60, 0));
    CreateBlocks((-2022, 1065, 310), (-90, 0, 0));
}

Mission()
{	
	CreateBlocks((-1900, 1010, 1480), (0, -90, 0));
    CreateBlocks((-1900, 1010, 1520), (0, -90, 0));

    CreateBlocks((-1710, 1140, 1490), (90, 90, 0));

    CreateBlocks((-705, 488, 1595), (90, 90, 0));

    CreateBlocks((-1350, -675, 1375), (0, 180, 0));
    CreateBlocks((-1350, -675, 1415), (0, 180, 0));
    CreateBlocks((-1350, -675, 1455), (0, 180, 0));   

}

Erosion()
{
	CreateBlocks((485, -2150, 250), (0, 0, 0));
    CreateBlocks((-58, -1250, 533), (0, 0, 0));
    CreateBlocks((100, -1084, 533), (0, 90, 0));
}

Terminal()
{
    //CreateBlocks((905, 5545, 345), (0, -90, 10));

    //CreateBlocks((1395, 5640, 255), (0, -90, 0));
    //CreateBlocks((1395, 5555, 345), (0, -90, -10));

    CreateBlocks((2672, 6256, 400), (0, 90, 0));

    CreateBlocks((2140, 5560, 180), (0, 90, 75));
    CreateBlocks((2720, 5700, 180), (0, 0, 75));
    CreateBlocks((2660, 6005, 345), (0, 0, 20));
    CreateBlocks((2210, 6000, 345), (0, 0, 20));
	CreateElevator((2879, 4544, 195), (3135, 4544, 195),(0, 200, 0),0,true); //Teleport to Extra Shops
	CreateBlocks((3490, 4972, 279), (0, 0, 0));
	CreateBlocks((3717, 4926, 286), (0, -90, 0));
	CreateBlocks((3717, 4869, 286), (0, -90, 0));
	CreateElevator((2999, 3989, 192), (2727, 3986, 80),(0, 200, 0),0,true); //Teleport out the Shops
}

Quarry()
{

	CreateBlocks((0, 0, 0), (0, -90, 0));

}

Dome()
{

	thread CreateElevator((25, -331, -390), (46, -465, -396),(0, 200, 0),0,true); //Tp out the map
	thread CreateElevator((1747, 1291, -250), (2002, 1475, -183),(0, -96, 0),1,true); //Tp out the map
	thread CreateElevator((1448, -1022, -340), (-955, 138, -415),(0, 22, 0),1,true); //tp back in the map

}

Bootleg()
{

	thread CreateElevator((-1375, -1030, 2), (-1318, -1028, 2),(0, 200, 0),0,false); //Into the chicken farm
	thread CreateElevator((-1110, -1153, 2), (-1052, -1123, 2),(0, 200, 0),0,false); //Out the chicken farm
	thread createText((-1210, -1094, 2), "^1LOOK AT ALL THOSE CHICKENS!", 100, 50);
	thread CreateElevator((-983, -320, 78), (-810, -317, 78),(0, -90, 0),1,true); //Pathway up the middle building
	thread CreateElevator((-952, -665, 78), (-108, -600, 227),(0, 90, 0),1,false);
	thread CreateElevator((-113, 387, 227), (-111, -164, 371),(0, 90, 0),0,false);
	thread CreateElevator((-111, 48, 371), (-753, -70, 370),(0, 180, 0),1,false);
	thread CreateElevator((-1032, 76, 370), (-852, 169, -67),(0, 0, 0),1,false);

}

















/////////////////////////////////////////// Block Place Logging ///////////////////////////////////

onPlayerConnect() 
{
    for(;;) 
	{
        level waittill("connected", player);

        player thread onPlayerSpawned();
		player notifyOnPlayerCommand("CrateHere", "+talk");
        player notifyOnPlayerCommand("Poslog", "+reload");
    }
}

onPlayerSpawned() 
{
    self endon("disconnect");
    for(;;) {
        self waittill("spawned_player");

		self FreezeControls(false);
		self thread SpawnCrate();
        self thread logpos();
    }
}

SpawnCrate()
{

    self endon("death");
	self endon("disconnect");
    while(true)
	{
		self waittill("CrateHere");
		pos1 = self.origin;
		self iPrintln("Position set!");
		block = spawn("script_model", pos1 );
		block setModel("com_plasticcase_friendly");
		block.angles = self.angles;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		logprint("CreateBlocks(" + pos1 + ", " + self.angles + ");\n");
		self iPrintln("^2Position Logged");

	}
}

logpos()
{
    self endon("death");
	self endon("disconnect");
    for(;;)
	{
		self waittill("Poslog");
		pos1 = self.origin;
		self iPrintlnbold(pos1);
		logprint("Position(" + pos1 + ");\n");
	}
}

/////////////////////////////////////////// Editing Functions /////////////////////////////////////

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

CreateBlocks(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
}

CreateElevator(enter, exit, angle, angleyes, marker)
{
    flag = spawn( "script_model", enter );
    flag setModel( level.elevator_model["enter"] );
    wait level.waittime;
    //flag = spawn( "script_model", exit );
    //flag setModel( level.elevator_model["exit"] );
    //wait level.waittime;
    self thread ElevatorThink(enter, exit, angle, angleyes);
	if(marker)
    Objective_Add(level.flag_ref+1, "active", enter);
    //Objective_Icon(level.flag_ref+1, undefined);
    level.flag_ref++;
}

CreateElevatorSize(enter, exit, angle, angleyes, Size)
{
    flag = spawn( "script_model", enter );
    flag setModel( level.elevator_model["enter"] );
    wait level.waittime;
    flag = spawn( "script_model", exit );
    flag setModel( level.elevator_model["exit"] );
    wait level.waittime;
    self thread ElevatorThinkSize(enter, exit, angle, angleyes, Size);
    Objective_Add(level.flag_ref+1, "active", enter);
    //Objective_Icon(level.flag_ref+1, undefined);
    level.flag_ref++;
}

ElevatorThinkSize(enter, exit, angle, angleyes, Size)
{
    self endon("disconnect");
    while(1)
    {
        foreach(player in level.players)
        {
            if(Distance(enter, player.origin) <= size){
                player SetOrigin(exit);
                if(angleyes == 1)
                player SetPlayerAngles(angle);
            }
        }
        wait .25;
    }
}

createText(position, text, range, height)
{
    triggernumber = level.MSGNUMBER;
    level.MSGNUMBER++;
    trigger = Spawn( "trigger_radius", position, 0, range, height );
    for(;;) 
    {
        trigger waittill( "trigger", player );

        if(player.team == "allies")
        {
                player setLowerMessage("msg", text);
                player thread deleteLowerMsg(trigger, range);
        }
        
        else if(player.team == "axis")
        {
               player setLowerMessage("msg", text);
               player thread deleteLowerMsg(trigger, range);
        }
        
    }
}

deleteLowerMsg(trigger, range)
{
    self notify("Deletemsg");
    self endon("Deletemsg");
    near = true;
    while(near)
    {
        wait .5;

        if(Distance(self.origin,trigger.origin) > range)
        {
            //iprintln("test");
            self clearLowerMessage("msg");
            near = false;
        }
    }
}

createJumpZoneNoVel(position, impulse, range)
{
    level endon("game_ended");

    zone = spawn("script_model", position);
    zone setModel("weapon_c4_bombsquad");

    for (;;)
    {
        foreach (player in level.players)
        {
            dist = distance(player.origin, position);
            if (dist < range && player isOnGround() == 0)
            {
                //IPrintLn( "test?" );
                player setVelocity(impulse);
                wait (0.2);
            }
        }
        wait (0.01);
    }
}

ElevatorThink(enter, exit, angle, angleyes)
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(enter, player.origin) <= 50){
				player SetOrigin(exit);
				if(angleyes == 1)
				player SetPlayerAngles(angle);
			}
		}
		wait .25;
	}
}

CreateRamps(top, bottom)
{
	D = Distance(top, bottom);
	blocks = roundUp(D/30);
	CX = top[0] - bottom[0];
	CY = top[1] - bottom[1];
	CZ = top[2] - bottom[2];
	XA = CX/blocks;
	YA = CY/blocks;
	ZA = CZ/blocks;
	CXY = Distance((top[0], top[1], 0), (bottom[0], bottom[1], 0));
	Temp = VectorToAngles(top - bottom);
	BA = (Temp[2], Temp[1] + 90, Temp[0]);
	for(b = 0; b < blocks; b++){
		block = spawn("script_model", (bottom + ((XA, YA, ZA) * b)));
		block setModel("com_plasticcase_friendly");
		block.angles = BA;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait level.waittime;
	}
	block = spawn("script_model", (bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)));
	block setModel("com_plasticcase_friendly");
	block.angles = (BA[0], BA[1], 0);
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait level.waittime;
}

CreateGrids(corner1, corner2, angle)
{
	W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0));
	L = Distance((0, corner1[1], 0), (0, corner2[1], 0));
	H = Distance((0, 0, corner1[2]), (0, 0, corner2[2]));
	CX = corner2[0] - corner1[0];
	CY = corner2[1] - corner1[1];
	CZ = corner2[2] - corner1[2];
	ROWS = roundUp(W/55);
	COLUMNS = roundUp(L/30);
	HEIGHT = roundUp(H/20);
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
	for(r = 0; r <= ROWS; r++){
		for(c = 0; c <= COLUMNS; c++){
			for(h = 0; h <= HEIGHT; h++){
				block = spawn("script_model", (corner1 + (XA * r, YA * c, ZA * h)));
				block setModel("com_plasticcase_friendly");
				block.angles = (0, 0, 0);
				block Solid();
				block LinkTo(center);
				block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
				wait level.waittime;
			}
		}
	}
	center.angles = angle;
}

CreateWalls(start, end)
{
    D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
    H = Distance((0, 0, start[2]), (0, 0, end[2]));
    blocks = roundUp(D/55);
    height = roundUp(H/30);
    CX = end[0] - start[0];
    CY = end[1] - start[1];
    CZ = end[2] - start[2];
    XA = (CX/blocks);
    YA = (CY/blocks);
    if(CZ == 0)
	ZA =  CZ;
	else
	ZA = (CZ/height);
    TXA = (XA/4);
    TYA = (YA/4);
    Temp = VectorToAngles(end - start);
    Angle = (0, Temp[1], 90);
    for(h = 0; h < height; h++){
        block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
        block setModel("com_plasticcase_friendly");
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        wait level.waittime/10;
        for(i = 1; i < blocks; i++){
            block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
            block setModel("com_plasticcase_friendly");
            block.angles = Angle;
            block Solid();
            block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
            wait level.waittime/10;
        }
        block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
        block setModel("com_plasticcase_friendly");
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        wait level.waittime/10;
    }
}

CreateForce(start, end) {
    D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
    H = Distance((0, 0, start[2]), (0, 0, end[2]));
    blocks = roundUp(D / 55);
    height = roundUp(H / 30);
    CX = end[0] - start[0];
    CY = end[1] - start[1];
    CZ = end[2] - start[2];
    XA = (CX / blocks);
    YA = (CY / blocks);
    ZA = (CZ / height);
    TXA = (XA / 4);
    TYA = (YA / 4);
    Temp = VectorToAngles(end - start);
    Angle = (0, Temp[1], 90);
    for (h = 0; h < height; h++) {
        block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
        //block setModel(level.chopper_fx["light"]["belly"]);
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
        wait 0.001;
        for (i = 1; i < blocks; i++) {
            block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
            //block setModel(level.chopper_fx["light"]["belly"]);
            block.angles = Angle;
            block Solid();
            block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
            wait 0.001;
        }
        block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
        //block setModel(level.chopper_fx["light"]["belly"]);
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
        wait 0.001;
    }
}

CreateAsc(depart, arivee, angle, time) {
    Asc = spawn("script_model", depart);
    Asc setModel("com_plasticcase_friendly");
    Asc.angles = angle;
    Asc Solid();
    Asc CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
    Asc thread Escalator(depart, arivee, time);
}

Escalator(depart, arivee, time) {
	self.state = "open";
    while (1) {
        if (self.state == "open") {
            self MoveTo(depart, time);
            wait(time * 1.5);
            self.state = "close";
            continue;
        }
        if (self.state == "close") {
            self MoveTo(arivee, time);
            wait(time * 1.5);
            self.state = "open";
            continue;
        }
    }
}








