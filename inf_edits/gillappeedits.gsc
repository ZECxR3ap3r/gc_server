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
    else if(getDvar("mapname") == "mp_courtyard_ss"){ /** Erosion **/
		level thread Erosion();
	}
    else if(getDvar("mapname") == "mp_aground_ss"){ /** Aground **/
		level thread Aground();
	}
    else if(getDvar("mapname") == "mp_paris"){ /** Resistance **/
		level thread Resistance();
	}
    else if(getDvar("mapname") == "mp_bravo"){ /** Mission **/
		level thread Mission();
	}
    else if(getDvar("mapname") == "mp_nightshift"){ /** Skidrow **/
		level thread Skidrow();
	}
    else if(getDvar("mapname") == "mp_terminal_cls"){ /** Terminal **/
		level thread Terminal();
	}
    else if(getDvar("mapname") == "mp_highrise"){ /** Highrise **/
		level thread Highrise();
	}
	else if(getDvar("mapname") == "mp_rats"){ /** Rats **/
		level thread Rats();
	}
	else if(getDvar("mapname") == "mp_quarry"){ /** Quarry **/
		level thread Quarry();
	}
	else if(getDvar("mapname") == "mp_exchange"){ /** Downturn **/
		level thread Downturn();
	}
	else if(getDvar("mapname") == "mp_dome"){ /** Dome **/
		level thread Dome();
	}
	else if(getDvar("mapname") == "mp_plaza2"){ /** Arkaden **/
		level thread Arkaden();
	}
	else if(getDvar("mapname") == "mp_abandon"){ /** Carnival **/
		level thread Carnival();
	}
	else if(getDvar("mapname") == "mp_bootleg"){ /** Bootleg **/
		level thread Bootleg();
	}
	else if(getDvar("mapname") == "mp_qadeem"){ /** Oasis **/
		level thread Oasis();
			}
	else if(getDvar("mapname") == "mp_six_ss"){ /** Vortex **/
		level thread Vortex();
	}
	else if(getDvar("mapname") == "mp_favela"){ /** Favela **/
		level thread Favela();
	}
	else if(getDvar("mapname") == "mp_fav_tropical"){ /** FavelaTropical **/
		level thread FavelaTropical();
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

Erosion()
{
    CreateBlocks((485, -2150, 250), (0, 0, 0));
    CreateBlocks((-58, -1250, 533), (0, 0, 0));
    CreateBlocks((100, -1084, 533), (0, 90, 0));
}

Aground()
{
    CreateBlocks((-93, 1225, 625), (0, -165, 0));

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

Resistance()
{
    CreateBlocks((1100, 1668, 130), (0, 0, 0));
	thread createText((-108, 165, 103), "^1What are you doing, step bro?", 1, 10);
}

Mission()
{
    CreateBlocks((-1900, 1010, 1480), (0, -90, 0));
    CreateBlocks((-1900, 1010, 1520), (0, -90, 0));

    CreateBlocks((-1710, 1140, 1490), (90, 90, 0));

    CreateBlocks((-705, 488, 1595), (90, 90, 0));
	
	thread createText((-1028, 214, 1513), "^1I see you HAHA! - bayz", 1, 1);
}

Skidrow()
{
    //CreateBlocks((-485, -1760, 235), (0, 90, 0));
    //CreateBlocks((-430, -2670, 450), (0, 0, 0));
    //CreateBlocks((-430, -2720, 485), (0, 0, 0));
    //CreateBlocks((-540, -2700, 540), (0, 0, 0));
    //CreateBlocks((-1695, -2460, 120), (0, 0, 0));
    //CreateBlocks((-1830, -2515, 135), (0, 165, 0));

    //CreateBlocks((-1170, 640, 170), (0, 0, -60));
    //CreateBlocks((-1815, 155, 245), (20, 0, 0));

    //CreateBlocks((637, -1660, 85), (0, -90, 75));
    //CreateBlocks((637, -1695, 85), (0, -90, 75));

    //CreateBlocks((190, -1180, 238), (0, -90, 0));

    //CreateBlocks((-1000, -965, 228), (0, 90, 0));
    //CreateBlocksInf((-471, -1592.59, 433), (0, 90, 0));
	
	//thread createText((-437, 351, 438), "^1Jump Crouch", 10, 1);
	//thread createText((-989, -2119, 310), "^1Jump Crouch", 10, 10);
	
	//CreateBlocksInf((-535, -2247, 425), (0, -90, 0));
	
	/////////////////////////////////////////////////////////////////////
	
	CreateBlocksRed((-1137, -1323, 135), (0, 180, 0)); //grand opening sign
	CreateBlocksRed((-1200, -1323, 135), (0, 180, 0)); //grand opening sign
	CreateBlocksRed((1300, -1340, 50), (0, 180, 0)); //flagbase car bhop
	CreateBlocksRed((1215, -1340, 50), (0, 180, 0)); //flagbase car bhop
	CreateBlocksRed((1164, -1340, 35), (90, 0, 0)); //flagbase car bhop	
	CreateBlocksRed((48, -504, 320), (90, 180, 0));	// bakery pipe	
	CreateBlocksRed((685, 307, 160), (0, 0, 0)); //barber tarpool	
	CreateBlocksRed((-173, -30, 378), (90, -180, 90)); //blocked OOM
	CreateBlocksRed((195, -67, 60), (90, -180, 90));  //Sign 1
	CreateBlocksRed((195, -67, 100), (90, -180, 90));  //Sign 1
	CreateBlocksRed((286, -67, 100), (90, -180, 90)); //sign 2
	CreateBlocksRed((268, 247, 130), (0, 90, 0)); //Liquor sign
	CreateBlocks((384, -543, 5), (0, 90, 0)); //Forklift spot
	CreateBlocksRed((-1642, -1661, 130), (90, -180, 90)); //Blocked OG OOM
	CreateBlocksRed((-1642, -1661, 190), (90, -180, 90)); //Blocked OG OOM
	CreateBlocksRed((-1936, -1590, 152), (0, -180, 6)); //Blocked OG tarpool OOM
	CreateBlocksRed((-1475, -266, 230), (0, 90, 0)); //fire escape stairs (play ground)
	CreateBlocksRed((-1637, -270, 230), (0, 90, 0)); //fire escape stairs (play ground)
	CreateBlocksRed((-1601, -285, 230), (0, -180, 0)); //fire escape stairs (play ground)
	CreateBlocks((1510, -512, 200), (0, 90, 0)); //Flag base
	CreateBlocks((1472, -470, 200), (0, 180, 0)); //Flag base
	CreateBlocks((1472, -556, 200), (0, 180, 0)); //Flag base
	CreateBlocks((1431, -512, 200), (0, 90, 0)); //Flag base
	CreateBlocks((1514, -557, 200), (0, -135, 0)); //Flag base
	CreateBlocks((1512, -472, 200), (0, -45, 0)); //Flag base
	CreateBlocks((1430, -555, 200), (0, 135, 0)); //Flag base
	CreateBlocks((1429, -469, 200), (0, 45, 0)); //Flag base	
	CreateBlocks((1765, 317, 178), (0, -90, 0)); //containers	
	thread createText((1473, -514, 275), "^7Gillette^4Clan^7.com", 55, 1); //flag base text
	thread createText((-209, 242, 308), "^1now where are you gonna go?", 25, 1); //antenna text next to OOM
	thread CreateElevator((-2093, -1344, -100), (1879, 294, 108),(0, 100, 0),0,false); //Tp to containers

}

Terminal()
{
    CreateBlocks((905, 5545, 345), (0, -90, 10));

    CreateBlocks((1395, 5640, 255), (0, -90, 0));
    CreateBlocks((1395, 5555, 345), (0, -90, -10));

    CreateBlocks((2140, 5560, 180), (0, 90, 75));
    CreateBlocks((2720, 5700, 180), (0, 0, 75));
    CreateBlocks((2660, 6005, 345), (0, 0, 20));
    CreateBlocks((2210, 6000, 345), (0, 0, 20));
	CreateElevator((2879, 4544, 195), (3135, 4544, 195),(0, 200, 0),0,true); //Teleport to Extra Shops
	CreateBlocks((3490, 4972, 279), (0, 0, 0));
	CreateBlocks((3717, 4926, 286), (0, -90, 0));
	CreateBlocks((3717, 4869, 286), (0, -90, 0));
	CreateElevator((2999, 3989, 192), (2727, 3986, 80),(0, 200, 0),0,true); //Teleport out the Shops
	
	CreateBlocks((2008, 2907, 89), (0, -164, 75));
}

Highrise()
{
    CreateBlocks((270, 6580, 2825), (0, 90, 60));
    CreateBlocks((270, 6325, 2825), (0, 90, 60));
	CreateBlocks((280, 6130, 2825), (0, 90, 60));

    CreateBlocks((-632, 7142, 2755), (0, 0, 70));
	thread CreateElevator((-1487, 7426, 2786), (-2518, 9941, 2274),(0, 200, 0),0,true); //Teleport to other skyscraper
	thread CreateElevator((-1233, 7426, 2786), (-855, 10045, 2178),(0, 200, 0),0,true); //Teleport to other skyscraper
	thread CreateElevator((-1951, 10212, 2274), (-1443, 6285, 2658),(0, 200, 0),0,true); //Teleport back to highrise
	CreateBlocks((-2407.13, 10207.1, 2224.36), (0, -0.241699, 0));
	CreateBlocks((-2407, 10239, 2176), (0, 0, 0));
	CreateBlocks((-2407, 11232, 2216), (0, 0, 0));
	CreateBlocks((-2407, 11201, 2176), (0, 0, 0));
	CreateBlocks((-1728, 11087, 2210), (0, -90, 0));
	CreateBlocks((-1696, 11087, 2168), (0, -90, 0));
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

	thread createText((-4615, 700, -180), "^6Cosy :3", 5, 5);
	thread createText((-2948, -1652, 184), "^5Lil Stick's Hideout", 10, 10);
	thread createText((-5845, 300, 280), "^1Spot Reserved for a085", 5, 5);
	thread createText((-5800, 1167, 453), "^1I'M GOING TO BREAK MY MONITOR, I SWEAR! - Ghusliks", 5, 5);
	thread createText((-3032, -344, 385), "^1Cant sit here now you RAT!", 20, 20);
	thread CreateJumpZoneNoVel((-4021, -159, -115), (0,0,800), (80));
	
	//CreateBlocks((-5075, -159, 375), (0, 90, 0)); //barn 14
	//CreateBlocks((-5075, -159, 415), (0, 90, 0)); //barn 14
	//CreateBlocks((-5075, -159, 450), (0, 90, 0)); //barn 14
	
	CreateBlocksRed((-3498, 147, 400), (90, 15, 0)); //small silo
	CreateBlocksRed((-3461, -450, 400), (90, -5, 0)); //small silo
	CreateBlocksRed((-3378, 155, 400), (90, 0, 0)); //small silo
	
	CreateBlocksRed((-3203, -885, 400), (90, 90, 0)); //lampost 1
	CreateBlocksRed((-3203, -885, 500), (90, 90, 0)); //lampost 1
	CreateBlocksRed((-3639, -929, 400), (90, 90, 0)); //lampost 2
	CreateBlocksRed((-3639, -929, 500), (90, 90, 0)); //lampost 2
	
	//CreateWalls((-5620, 1263, 200),(-5621, 1552, 201)); //Block rock wall
	//CreateWalls((-5620, 1263, 250),(-5621, 1552, 251)); //Block rock wall
	//CreateWalls((-5620, 1263, 300),(-5621, 1552, 301)); //Block rock wall
	
	CreateBlocksRed((-5520, 1583, 410), (0, -180, 0));
	CreateBlocksRed((-5520, 1583, 350), (0, -180, 0));
	
	CreateWallsRed((-5646, 1250, 374), (-5793, 1250, 375)); //Top stairs in rock wall
	CreateBlocksRed((-5676, 1246, 325), (0, -180, 0)); //Top stairs in rock wall
	CreateRamps((-5608, 1556, 165), (-5600, 1399, 70)); //Top stairs in rock wall
	
	CreateBlocksRed((-5156, 1787, 84), (0, -180, 0)); //bent fence
	CreateBlocksRed((-5179, 1787, 105), (-45, -180, 0)); //bent fence
	CreateBlocksRed((-5057, 1786, 105), (45, -180, 0)); //bent fence
	
	CreateBlocksRed((-5248, 1622, 56), (0, 30, 0)); // 1
	CreateBlocksRed((-5020, 1715, 65), (0, 7, 0)); // 2
	CreateBlocksRed((-4940, 1725, 65), (0, 7, 0)); // 3
	CreateBlocksRed((-4868, 1734, 65), (0, 3, 0)); // 4
	
	CreateWallsRed((-5655, 55, -95), (-5655, -247, -96)); //fuel truck
	CreateBlocksRed((-5594, 79, -90), (0, -180, 0)); //fuel truck
	CreateBlocksRed((-5640, 79, -90), (0, -180, 0)); //fuel truck
	
	CreateBlocksRed((-5553, -91, 365), (90, 0, 0));
	CreateBlocksRed((-5553, -91, 440), (90, 0, 0));
	
	CreateRamps((-3435, -1671, 215), (-3375, -1671, 170));
	
	CreateBlocksRed((-3696, 1879, 272), (0, 90, 0));
	
	thread CreateJumpZoneNoVel((-4274, 639, 125), (400,0,700), (80));

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

	thread createText((-462, -1430, 320), "^1Welcome to Spooners Castle", 20, 20);
	
	//Ramp onto Ride/Green Roof
	CreateRamps((1961, -2536, 189),(1705, -2730, 45));
	CreateRamps((1961, -2536, 189),(1705, -2730, 45));
	CreateBlocks((1984, -2518, 184), (0, 127, 0));
	//Stop from being stuck onto F wheel spot
	CreateBlocksInf((287, 921, 170), (-25, 138, 90));
	//Help inf get to F wheel
	thread CreateJumpZoneNoVel((960, 821, 66), (0,0,600), (20));
	//Bounce to Green Roof
	CreateBlocks((2153, -2261, 130), (0, -131, 75));
	CreateBlocks((2071, -1709, 220), (-30, -129, 0));
	//Block Wallbreach
	//CreateBlocks((-440, -25, 135), (0, -128, 0));
	//CreateBlocks((-440, -25, 185), (0, -128, 0));
	//CreateWalls( (-583, -208, 120),(-427, -3, 145));
	CreateForce( (-404, 67, 185),(-604, -184, 200));
	CreateForce( (-404, 67, 230),(-604, -184, 250));

}

Dome()
{

	thread CreateElevator((25, -331, -390), (46, -465, -396),(0, 200, 0),0,true); //Tp out the map
	thread CreateElevator((1747, 1291, -250), (2002, 1475, -183),(0, -96, 0),1,true); //Tp out the map
	thread CreateElevator((1448, -1022, -340), (-955, 138, -415),(0, 22, 0),1,true); //tp back in the map
	//thread CreateElevator((1884, 810, -325), (-1252, 501, -220),(0, 20, 0),1,false);
	//thread CreateElevator((-1108, 555, -219), (665, -1033, -360),(0, 50, 0),1,false);

}

Arkaden()
{

	thread CreateElevator((-423, 737, 615), (-423, 678, 615),(0, 100, 0),0,true); //Tp into store 1 - take away 12 from prone
	thread CreateElevator((-243, 576, 648), (-188, 576, 648),(0, 10, 0),0,false); //Tp out of store 1
	thread CreateElevator((-680, 471, 616), (-784, 178, 648),(0, 0, 0),1,false); //Tp to lower door
	thread CreateElevator((-543, 122, 648), (-2455, 160, 800),(0, 50, 0),0,false); //Tp lower to tech store
	thread CreateElevator((-1785, 321, 800), (-1876, 321, 800),(0, 50, 0),0,true); //Tp mall to tech store
	thread CreateElevator((-2456, 477, 800), (-233, 358, 801),(0, 50, 0),0,false); //tp tech store to mall
	thread CreateElevator((712, 1279, 648), (1380, 1155, 832),(0, 180, 0),1,true); //tp into diner 
	thread CreateElevator((760, 557, 648), (663, 728, 832),(0, 50, 0),0,true); //tp into diner
	thread CreateElevator((813.895, 921.704, 715.125), (-1596, 69, 608),(0, 0, 0),1,false); //tp out of diner
	CreateForce( (630, 821, 870),(630, 1005, 895)); //diner wall
	CreateForce( (1348, 1427, 705),(923, 1425, 730)); //diner wall block outside
	CreateWalls( (-2240, 105, 830),(-1805, 105, 845));
	CreateWalls( (-2240, 105, 880),(-1805, 105, 905));
	CreateWalls( (-2240, 105, 930),(-1805, 105, 945));
	thread createText((101, 864, 832), "^2SHEEEEESH! Look at this guy!", 50, 50);
	thread createText((379, -663, 887), "^5HELICOPTER! HELICOPTER!", 25, 0);

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
	thread createText((-562, 1706, -98), "^1DO NOT GO IN THIS BIN!", 25, 0);
	thread CreateElevator((-565, 1745, -135), (-342.099, -445.523, -307.318),(0, 0, 0),1,false); //Death bin

}

Oasis()
{
	CreateWallsRed( (1070, 2112, 490),(1070, 1847, 515));
	CreateWallsRed( (1070, 2464, 540),(1070, 1830, 565));
	CreateWallsRed( (1070, 2464, 590),(1070, 1830, 615));
	CreateBlocksRed((-1663, 1950, 325), (0, 90, 0));
	CreateBlocksRed((-1663, 1950, 375), (0, 90, 0));
	CreateBlocksRed((-1663, 1950, 425), (0, 90, 0));
	CreateBlocksRed((-1663, 1950, 475), (0, 90, 0));
	CreateBlocksRed((-1663, 1950, 525), (0, 90, 0));
	CreateBlocksRed((-1663, 1950, 575), (0, 90, 0));
	
	CreateBlocksRed((-1663, 2025, 325), (0, 90, 0));
	CreateBlocksRed((-1663, 2025, 375), (0, 90, 0));
	CreateBlocksRed((-1663, 2025, 425), (0, 90, 0));
	CreateBlocksRed((-1663, 2025, 475), (0, 90, 0));
	CreateBlocksRed((-1663, 2025, 525), (0, 90, 0));
	CreateBlocksRed((-1663, 2025, 575), (0, 90, 0));
	CreateWallsRed( (-1510, 307, 510),(-1684, 482, 535));
	CreateWallsRed( (-1510, 307, 560),(-1684, 482, 585));
	CreateBlocksRed((-1676, 535, 560), (0, 90, 0));
	CreateBlocksRed((-1676, 585, 560), (0, 90, 0));
	
	CreateBlocks((212, 400, 500), (0, 90, 90));
}

Favela()
{
	CreateBlocks((-127, 181, 5), (0, -90, 75));
	//CreateBlocks((-537, 751, 341), (0, -180, 0));
	//Block above ice cream shop
	CreateBlocks((-115, 180, 85), (0, -95, 0));
	CreateBlocksRed((-705, 1427, 486), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 535), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 584), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 633), (0, -90, 90)); //left
	CreateBlocksRed((-540, 1436, 486), (0, -90, 90));
	CreateBlocksRed((-540, 1436, 535), (0, -90, 90));
	
	CreateBlocksInf((455, 875, 445), (0, -180, 0));
	
}

FavelaTropical()
{
	CreateBlocks((-127, 181, 5), (0, -90, 75));
	//CreateBlocks((-537, 751, 341), (0, -180, 0));
	//Block above ice cream shop
	CreateBlocks((-115, 180, 85), (0, -95, 0));
	CreateBlocksRed((-705, 1427, 486), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 535), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 584), (0, -90, 90)); //left
	CreateBlocksRed((-705, 1427, 633), (0, -90, 90)); //left
	CreateBlocksRed((-540, 1436, 486), (0, -90, 90));
	CreateBlocksRed((-540, 1436, 535), (0, -90, 90));
	
	CreateBlocksInf((455, 875, 445), (0, -180, 0));
	
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
