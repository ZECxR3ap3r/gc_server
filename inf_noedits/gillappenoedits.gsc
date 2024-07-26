#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
    level.MSGNUMBER = 0;
    level.flag_ref = 0;
    level.waittime = 0.05;
	level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
    level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );

    precacheModel( level.elevator_model["enter"] );
    precacheModel( level.elevator_model["exit"] );

    if(getDvar("mapname") == "mp_rust")
		level thread Rust();
    else if(getDvar("mapname") == "mp_courtyard_ss")
		level thread Erosion();
    else if(getDvar("mapname") == "mp_aground_ss")
		level thread Aground();
    else if(getDvar("mapname") == "mp_paris")
		level thread Resistance();
    else if(getDvar("mapname") == "mp_bravo")
		level thread Mission();
    else if(getDvar("mapname") == "mp_nightshift")
		level thread Skidrow();
    else if(getDvar("mapname") == "mp_terminal_cls")
		level thread Terminal();
    else if(getDvar("mapname") == "mp_highrise")
		level thread Highrise();
	else if(getDvar("mapname") == "mp_rats")
		level thread Rats();
	else if(getDvar("mapname") == "mp_quarry")
		level thread Quarry();
	else if(getDvar("mapname") == "mp_exchange")
		level thread Downturn();
	else if(getDvar("mapname") == "mp_dome")
		level thread Dome();
	else if(getDvar("mapname") == "mp_plaza2")
		level thread Arkaden();
	else if(getDvar("mapname") == "mp_abandon")
		level thread Carnival();
	else if(getDvar("mapname") == "mp_bootleg")
		level thread Bootleg();
	else if(getDvar("mapname") == "mp_qadeem")
		level thread Oasis();
	else if(getDvar("mapname") == "mp_favela")
		level thread Favela();
	else if(getDvar("mapname") == "mp_six_ss")
		level thread Vortex();
	else if(getDvar("mapname") == "mp_fav_tropical")
		level thread FavelaTropical();
}

Rust() {
	i=0;
    CreateBlocksInf((1090, 1668, -170), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
    CreateBlocksInf((1090-i*50, 1668, -170+i*10), (346, 180, 0)); i++;
	
	CreateBlocksInf((1185, 1620, -200), (-10, 180, 0));
    CreateBlocksInf((1185, 1635, -170), (-10, 180, 0));

    CreateBlocksInf((1240, 1620, -200), (-10, 180, 0));
    CreateBlocksInf((1240, 1635, -175), (-10, 180, 0));
}

Erosion()
{

}

Aground()
{

}

Resistance()
{
	thread createText((-108, 165, 103), "^1What are you doing, step bro?", 1, 10);
}

Vortex()
{
    i=0;
    CreateBlocksInf((550, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((620, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((690, 1260, 180+i*60), (0, 357, 0)); i++;
    CreateBlocksInf((550, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((620, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((690, 1260, 180+i*60), (0, 357, 0)); i++;
    CreateBlocksInf((550, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((620, 1265, 180+i*60), (0, 0, 0));
    CreateBlocksInf((690, 1260, 180+i*60), (0, 357, 0)); i++;

    CreateBlocksInf((550, 1265+5, 180+i*60-20), (0, 0, 60));
    CreateBlocksInf((550, 1265+25, 180+i*60+15), (0, 0, 60));
}

Mission()
{

}

Skidrow()
{


}

Terminal()
{

}

Highrise()
{

}

Rats()
{
    thread CreateJumpZoneNoVel((-60, -199, 532), (0,0,800), (80));
    thread CreateJumpZoneNoVel((-2200, -1184, 532), (0,0,700), (80));
    thread CreateJumpZoneNoVel((-752, -1583, 542), (0,0,700), (80));
    thread CreateJumpZoneNoVel((-2114, -2286, 532), (0,0,1200), (80));
    thread CreateJumpZoneNoVel((-2343, -201, 532), (0,0,1300), (80));
    thread CreateJumpZoneNoVel((128, -186, 1170), (0,0,1000), (80));
    thread CreateJumpZoneNoVel((-2523, -1828, 1060), (0,0,900), (80));
    thread CreateJumpZoneNoVel((-2406, -2025, 1750), (0,0,700), (80));
    thread CreateJumpZoneNoVel((-2309, -2839, 900), (0,0,1100), (80));
    CreateElevatorSize((-1174.0, -1014, 2400), (-1926, -714, 560),(0, 200, 0),0,300);
    CreateElevatorSize((-1174, -1387, 2560), (-1926, -714, 560),(0, 200, 0),0,200);
    CreateElevator((-2053, -2834, 530), (-1926, -714, 560),(0, 200, 0),0,true);
    CreateElevatorSize((-1170, -1715, 2650), (-1926, -714, 560),(0, 200, 0),0,300);
    thread createText((-1175, -333, 2150), "^2Do not go any further!!", 100, 100);
	thread createText((-1175, -651, 2296), "^1You have been warned!", 100, 100);
	thread createText((-1908, -707, 610), "^2You're trash kid!", 100, 100);
	thread createText((-1221, -2091, 553), "^2WTF are you doing here?", 10, 10);


}

Quarry()
{



}

Downturn()
{

	thread createText((1835, 829, 246), "^5Really? You chose this spot?", 20, 20);
	thread createText((2480, 842, 298), "^1WOW! You really are a shitter", 20, 20);
	thread createText((2743, 829, 246), "^6I feel sorry for you :( ", 20, 20);
	thread createText((720, -1783, 52), "^3PRETZEL", 1, 1);
	thread createText((1712, -453, 71), "^1ITS DAX!!!", 1, 1);

}

Carnival()
{



}

Dome()
{



}

Arkaden()
{

	thread createText((101, 864, 832), "^2SHEEEEESH! Look at this guy!", 50, 50);
	thread createText((379, -663, 887), "^5HELICOPTER! HELICOPTER!", 25, 0);

}

Bootleg()
{


}

Oasis()
{

}

Favela()
{

	
}

FavelaTropical()
{

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

CreateBlocksInf(pos, angle)
{
	block = spawn("script_model", pos );
	//block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
}

CreateBlocksRed(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_trap_bombsquad");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
}
CreateBlocksBounce(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_trap");
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

CreateWallsRed(start, end)
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
        block setModel("com_plasticcase_trap_bombsquad");
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        wait level.waittime/10;
        for(i = 1; i < blocks; i++){
            block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
            block setModel("com_plasticcase_trap_bombsquad");
            block.angles = Angle;
            block Solid();
            block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
            wait level.waittime/10;
        }
        block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
        block setModel("com_plasticcase_trap_bombsquad");
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

















