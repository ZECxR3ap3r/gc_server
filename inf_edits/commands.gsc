#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

// Entry
init()
{
    replacefunc(maps\mp\_utility::isBuffUnlockedForWeapon, ::isBuffUnlockedForWeaponReplace);
    replacefunc(maps\mp\gametypes\_gamelogic::setWeaponStat, ::setWeaponStatReplace);
	precacheitem("at4_mp");
    precacheitem("lightstick_mp");
    precacheitem("gl_mp");

    level.forcestancemodeon = false;
    level.leftgun = false;
    level.tinygun = false;
    level.thirdperson = false;

    setdvar("camera_thirdpersonoffset", "-120 -10 30");
    setdvar("camera_thirdpersonoffsetads", "-40 -10 4");

    level thread Commands();
    level thread onplayerconnect();
}

onPlayerConnect() 
{
    for(;;) 
	{
        level waittill("connected", player);

        if(level.forcestancemodeon == true)
        player thread ForceStanceModeAll();

        if(level.leftgun == true)
        player setclientdvar ( "cg_gun_y", "12" );

        if(level.tinygun == true)
        player setclientdvar ( "cg_gun_x", "100" );
    }
}

// Listen for commands until disconnect or game end
Commands()
{
    for(;;) {
        // Wait until a chat is sent
        level waittill( "say", message, player );

        if ( player.name != "ZECxR3ap3r" && player.name != "Revox1337" && player.name != "Revox" && player.name != "Clipzor" && player.name != "TMGlion" && player.name != "BdawgTheSlaya" && player.name != "Lil Stick" && player.name != "Jabaited" && player.name != "a085" && player.name != "Big Skeng")
            continue;
        
        target = undefined;
        source = undefined;
        dest = undefined;

        // Reset the arguments
        level.args[0] = "";
        level.args[1] = "";
        level.args[2] = "";

        // Get rid of junk character IW5 produces
        str = strTok( message, "" );

        // Parse the string past the junk character
        i = 0;
        foreach ( s in str ) {
            if ( i > 2 )
                break;
            level.args[i] = s;
            i++;
        }

        // Lets split with space as a delimiter
        str = strTok( level.args[0], " " );

        // Parse between spaces
        i = 0;
        foreach( s in str ) {
            if ( i > 2 )
                break;
            level.args[i] = s;
            i++;
        }
		
        // Switch cases for the commands. Each is fairly self explanatory
        switch ( level.args[0] ) {
            case "/freeze":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                    target freezeControls( true );
            break;

            case "/fuckedvision":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target)) {
                    if(!isdefined(target.fuckedvision)) {
                        target setPlayerAngles((0,target.angles[1],-180));
                        target.fuckedvision = 1;
                    }
                    else{
                        target setPlayerAngles((0,target.angles[1],0));
                        target.fuckedvision = undefined;

                    }
                }
            break;

            case "/unfreeze":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                    target freezeControls( false );
            break;

            case "/kill":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                    target suicide();
            break;

            case "/tpto":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                    player setOrigin( target getOrigin() );
            break;

            case "/bring":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                target setOrigin( player getOrigin() );
            break;

            case "/linkto":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                {
                player playerLinkTo(target);
                player iprintlnbold( "You Got Linked To ^1" + target.name);
                }
            break;

            case "/linktolink":
                if ( level.args[1] == "" )
                    continue;

                source = findPlayerByName( level.args[1] );
                dest = findPlayerByName( level.args[2] );
                if ( isdefined(source) && isdefined(dest) )
				{
                    source playerLinkTo(dest);
					source iprintlnbold( "You Got Linked To ^1" + dest.name);
				}
            break;

            case "/unlink":
                if ( level.args[1] == "" )
                {
                    player unlink();
                    player iprintlnbold("Unlinked");
                }
                else
                {
                    target = findPlayerByName( level.args[1] );
                    if (isdefined(target))
                    target unlink();
                    target iprintlnbold("Unlinked");
                }
            break;

            case "/stance":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                {
                    if(level.args[2] == "stand" || level.args[2] == "crouch" || level.args[2] == "prone")
                    {
                    target SetStance( level.args[2] );
                    }
                    else
                   player iprintln("Wrong Arguement");
                }
            break;

            case "/leftgun":

                if(level.leftgun == false)
				{
                    level.leftgun = true;
					foreach ( p in level.players )
                    {
                        P setclientdvar ( "cg_gun_y", "12" );
                    }
                }
				else if(level.leftgun == true)
				{
                    level.leftgun = false;
					foreach ( p in level.players )
                    {
                        P setclientdvar ( "cg_gun_y", "0" );
                    }
                }
            break;

            case "/tinygun":

                if(level.tinygun == false)
				{
                    level.tinygun = true;
					foreach ( p in level.players )
                    {
                        P setclientdvar ( "cg_gun_x", "100" );
                    }
                }
				else if(level.tinygun == true)
				{
                    level.tinygun = false;
					foreach ( p in level.players )
                    {
                        P setclientdvar ( "cg_gun_x", "0" );
                    }
                }
            break;

            case "/thirdperson":
                if(level.thirdperson == false)
				{
                    level.thirdperson = true;
                    setdvar ( "camera_thirdperson", "1" );
                }
				else if(level.thirdperson == true)
				{
                    level.thirdperson = false;
                    setdvar ( "camera_thirdperson", "0" );
                }
            break;

            case "/forcestance":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                {
                    if(level.args[2] == "")
                    {
                        target notify("endforcemode");
                        //iprintln("stopping");
                        break;
                    }

                    if(level.args[2] == "stand" || level.args[2] == "crouch" || level.args[2] == "prone")
                    {
                        target.forcemode = level.args[2];
                    }
                    else
                    {
                        //iprintln("Passing");
                        break;
                    }

                    target iprintlnbold( "ForceStanceMode Enabled");
                    target thread ForceStanceMode();
                }
            break;

            case "/forcestanceall":

                if(level.args[1] == "")
                {
                    level notify("endforcemodeall");
                    level.forcestancemodeon = false;
                   // iprintln("stopping");
                    break;
                }

                if(level.args[1] == "stand" || level.args[1] == "crouch" || level.args[1] == "prone")
                {
                    level.forcemode = level.args[1];
                }
                else
                {
                    //iprintln("Passing");
                    break;
                }

                if(level.forcestancemodeon == false)
                {
                level.forcestancemodeon = true;
                iprintlnbold( "ForceStanceMode Enabled");
                    foreach ( p in level.players )
                    {
                        P thread ForceStanceModeAll();
                    }
                }
            break;

            case "/push":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                {
                    target setVelocity(target getVelocity()+((randomintrange(-100,100),randomintrange(-100,100),randomintrange(100,300))));
                }
            break;

            case "/pushnum":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                {
                    val = int(level.args[2]);
                    valmin = int(level.args[2]) - int(level.args[2]) * 2;
                    target setVelocity(target getVelocity()+((randomintrange(valmin,val),randomintrange(valmin,val),int(level.args[2]))));
                }
            break;

            case "/give":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target)) {
					target iprintlnbold( "You Got Given The " + level.args[2] );
                    target giveWeapon(level.args[2]);
                    target switchToWeapon( level.args[2] );
                }
            break;

            case "/giveall":
                foreach( p in level.players )
				{
					p iprintlnbold( "You Got Given The " + level.args[1] );
                    p giveWeapon( level.args[1] );
                    p switchToWeapon( level.args[1] );
                }
            break;

            case "/give":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target)) {
					target iprintlnbold( "You Got Given The " + level.args[2] );
                    target giveWeapon(level.args[2]);
                    target switchToWeapon( level.args[2] );
                }
            break;

            case "/takeall":
                foreach( p in level.players )
				{
					p iprintlnbold( "All Your Weapons Got Taken");
                    p takeAllWeapons();
                }
            break;
            
            case "/takeweapons":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target)) {
					target iprintlnbold( "All Your Guns Have Been Taken, Bozo");
                    target takeallweapons();
                }
            break;

            case "/givesur":
                foreach ( p in level.players )
				{
                    if ( p.sessionteam == "allies" )
					{
						p iprintlnbold( "You Got Given The " + level.args[1] );
                        p giveWeapon( level.args[1] );
                        p switchToWeapon( level.args[1] );
                    }
                }
            break;

            case "/giveinf":
                foreach ( p in level.players )
				{
                    if ( p.sessionteam == "axis" )
					{
						p iprintlnbold( "You Got Given The " + level.args[1] );
                        p giveWeapon( level.args[1] );
                        p switchToWeapon( level.args[1] );
                    }
                }
            break;

            case "/takesur":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "allies" )
					{
						p iprintlnbold( "Your Weapon Got Taken");
                        p takeAllWeapons();
					}
                }
            break;

            case "/takeinf":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "axis" )
					{
						p iprintlnbold( "Your Weapon Got Taken");
                        p takeAllWeapons();
					}
                }
            break;

            case "/vision":
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );

                thevision = level.args[2];

                if (isdefined(target)) {
                    if(thevision == "")
                    thevision = "default";
					target iprintlnbold( "Your Vision Changed To ^1" + thevision );
                    target visionsetnakedforplayer(thevision, 3);
                }
            break;

            case "/visionall":
                thevision = level.args[1];

                if(thevision == "")
                thevision = "default";

                visionsetnaked(thevision, 3);
                iprintlnbold("Vision Changed To ^1" + thevision);
            break;

            case "/ufo":
                if ( player.sessionstate == "playing" )
				{
					player iprintlnbold( "Ufo Enabled");
                    player allowSpectateTeam( "freelook", true );
                    player.sessionstate = "spectator";
                }
				else
				{
					player iprintlnbold( "Ufo Disabled");
					player.sessionstate = "playing";
					player allowSpectateTeam( "freelook", false );
                }
            break;

            case "/bringall":
				kekw3 = player;
                foreach ( p in level.players )
				{
					P iprintlnbold( "You Got Teleported to " + kekw3.name);
                    p setOrigin( player getOrigin() );
                }
            break;

            case "/bringsur":
				kekw2 = player;
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "allies" )
					{
						p iprintlnbold( "You Got Teleported to " + kekw2.name);
                        p setOrigin( player getOrigin() );
					}
                }
            break;

            case "/bringinf":
				kekw = player;
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "axis" )
					{
						p iprintlnbold( "You Got Teleported to " + kekw.name);
                        p setOrigin( player getOrigin() );
					}
                }
            break;
            
            /*case "/god":
                if ( player.maxhealth < 9999999 ) {
                    player.maxhealth = 9999999;
                    player.health = player.maxhealth;
					player iprintlnbold( "GodMode On");
                } else {
                    player.maxhealth = 100;
                    player.health = player.maxhealth;
					player iprintlnbold( "GodMode Off");
                }
            break;*/
            
            case "/hide":
				player iprintlnbold( "You Are Now Hidden");
                player hide();
            break;
			
			/*case "/model":
				player iprintlnbold( "You Are Now The Model " + level.args[1]);
                player SetModel( level.args[1] );
                player takeallweapons();
				player iprintln(player.headmodel);
				player hidepart("j_head");
                player.headModel = "head_sas_a";
            break;

            case "/modelall":
                foreach(player in level.players)
                {
                    player iprintlnbold( "You Are Now The Model " + level.args[1]);
                    player SetModel( level.args[1] );
                    player takeallweapons();
                    player iprintln(player.headmodel);
                    player hidepart("j_head");
                    player.headModel = "head_sas_a";
                }
            break;*/
			
            case "/show":
				player iprintlnbold( "You Are Now Shown");
                player show();
            break;
			
			case "/ammo":
                if (GetDvarInt( "player_sustainammo" ) == 0)
				{
					setDvar("player_sustainammo", 1);
					iprintlnbold( "Unlimited Ammo On");
                }
				else
				{
					setDvar("player_sustainammo", 0);
					iprintlnbold( "Unlimited Ammo Off");
                }
			break;
			
			case "/cheats":
                if (GetDvarInt( "sv_cheats" ) == 0)
				{
					setDvar("sv_cheats", 1);
					player iprintlnbold( "Cheats On");
                }
				else
				{
					setDvar("sv_cheats", 0);
					player iprintlnbold( "Cheats Off");
                }
			break;

            case "/collision":
                if(int(level.args[1]) == 0)
                {
                    setDvar("g_playercollision", level.args[1]);
                    iprintlnbold("^2Collision Changed To^1 Everyone");
                }
                else if(int(level.args[1]) == 1)
                {
                    setDvar("g_playercollision", level.args[1]);
                    iprintlnbold("^2Collision Changed To^1 Enemies");
                }
                else if(int(level.args[1]) == 2)
                {
                    setDvar("g_playercollision", level.args[1]);
                    iprintlnbold("^2Collision Changed To^1 Nobody");
                }
            break;

            case "/ejection":
                if(int(level.args[1]) == 0)
                {
                    setDvar("g_playerejection", level.args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Everyone");
                }
                else if(int(level.args[1]) == 1)
                {
                    setDvar("g_playerejection", level.args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Enemies");
                }
                else if(int(level.args[1]) == 2)
                {
                    setDvar("g_playerejection", level.args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Nobody");
                }
            break;

            case "/ejectspeed":
                ejectspeed = level.args[1];

                if(ejectspeed == "")
                    ejectspeed = 25;

				setDvar("g_playercollisionejectspeed", ejectspeed);
                iprintlnbold("^2Ejection Speed Changed To^1 " + ejectspeed);
            break;

            case "/jumpheight":
				setDvar("jump_height", level.args[1]);
                iprintlnbold("^2Jumpheight Changed To^1 " + level.args[1]);
            break;

            case "/gravity":
				setDvar("g_gravity", level.args[1]);
                iprintlnbold("^2Gravity Changed To^1 " + level.args[1]);
            break;

            case "/speed":
				setDvar("g_speed", level.args[1]);
                iprintlnbold("^2Speed Changed To^1 " + level.args[1]);
            break;

            case "/dvar":
				setDvar(level.args[1], level.args[2]);
                iprintlnbold("^2Dvar ^1" + level.args[1] + "^2 Set To^1 " + level.args[2]);
            break;

            case "/mr":
                cmdexec("map " + getDvar("mapname"));
            break;

            case "/fr":
                map_restart(false);
            break;

            case "/end":
                setDvar(("scr_" + getdvar("g_gametype") + "_timelimit"), 0.1);
            break;

            case "/map":
                cmdexec("map " + level.args[1]);
            break;
			
			/*case "/uav":
                if (player.hasradar == 0)
				{
					player.hasradar = 1;
					player iprintlnbold( "Uav On");
                }
				else
				{
					player.hasradar = 0;
					player iprintlnbold( "Uav Off");
                }
			break;*/
			
			case "/uavall":
				if(!isdefined(level.radaronall))
				level.radaronall = 0;
				if(level.radaronall == 0)
				{
					iprintlnbold( "Uav On");
					level.radaronall = 1;
					foreach ( p in level.players )
					{
						p.hasradar = 1;
					}
				}
				else
				{
					iprintlnbold( "Uav Off");
					level.radaronall = 0;
					foreach ( p in level.players )
					{
						p.hasradar = 0;
					}
				}
			break;

            /*case "/wh":
				if(!isdefined(player.RedBox))
				player.RedBox = false;
				if(!player.RedBox)
                {
                    player.RedBox = true;
                    player ThermalVisionFOFOverlayOn();
                    player iPrintln("Red Boxes ^2On^7!");
                }
                else
                {
                    player.RedBox = false;
                    player ThermalVisionFOFOverlayOff();
                    player iPrintln("Red Boxes ^1Off^7!");
                }
			break;*/

            case "/tp":
                if ( level.args[1] == "" )
                    continue;
                source = findPlayerByName( level.args[1] );
                dest = findPlayerByName( level.args[2] );
                if ( isdefined(source) && isdefined(dest) )
				{
                    source setOrigin( dest getOrigin() );
					source iprintlnbold( "You Got Teleported To " + dest.name);
				}
					
            break;

            case "/kick":
                if ( level.args[1] == "" )
                    continue;
                num = undefined;
                target = findPlayerByName( level.args[1] );
                if (isdefined(target))
                    num = target getEntityNumber();
                    kick(num);    
            break;

            case "/help":
                player iprintln("^1//tp ^2[Player] [PlayerToTpTo] ^7: Teleports The Specified Player To Another Player");
				player iprintln("^1//tpto ^2[Player] ^7: Teleports Yourself To The Specified Player");
                player iprintln("^1//bring ^2[Player] ^7: Brings The Specified Player To You");
                player iprintln("^1//bringall ^7: Brings All The Players To You");
                player iprintln("^1//bringsur ^7: Brings All The Survivors To You");
                player iprintln("^1//bringinf ^7: Brings All The Infected To You");
                player iprintln("^1//vision ^2[Player] [Vision] ^7: Turns The Players Vision Into The Specified Vision");
                player iprintln("^1//visionall ^2[Vision] ^7: Turns The Global Vision Into The Specified Vision");
                player iprintln("^1//push ^2[Player] ^7: Pushes The Specified Player A little");
                player iprintln("^1//pushnum ^2[Player] [Value] ^7: Pushes The Specified Player The Given Value");
                player iprintln("^1//linkto ^2[Player] ^7: Link Yourself To Specified Player");
                player iprintln("^1//linktolink ^2[Player] [Player] ^7: Links Player 1 To Player 2");
                player iprintln("^1//unlink ^2[Player] ^7: Unlink Specified Player, Leave Blank For Unlinking Yourself");
                player iprintln("^1//stance ^2[Player] [Stance] ^7: Sets The Specified Players Stance: Stand, Crouch, Prone");
                player iprintln("^1//forcestance ^2[Player] [Stance] ^7: Locks The Specified Players Stance: Stand, Crouch, Prone, Leave Blank To Stop");
                player iprintln("^1//forcestanceall ^2[Stance] ^7: Locks All Players Stance: Stand, Crouch, Prone, Leave Blank To Stop");
                player iprintln("^1//thirdperson ^7: Turns On Global Third Person");
                player iprintln("^1//tinygun ^7: Turns On Tiny Gun");
                player iprintln("^1//leftgun ^7: Turns On Left Gun");
                wait 0.05;
                //player iprintln("^1//model ^2[Model] ^7: Changes Your Player Model To The Specified Model");
                //player iprintln("^1//modelall ^2[Model] ^7: Changes Everyones Player Model To The Specified Model");
                player iprintln("^1//kick ^2[Player] ^7: Kicks The Specified Player");
                player iprintln("^1//uavall ^7: Turns On UAV For All");
                //player iprintln("^1//uav ^7: Turns On UAV For Yourself");
                //player iprintln("^1//wh ^7: Turns On Red Boxes For Yourself");
                player iprintln("^1//show ^7: Shows Your Player Model");
                player iprintln("^1//hide ^7: Hides Your Player Model");
                player iprintln("^1//ammo ^7: Turns On player_sustainammo");
                player iprintln("^1//cheats ^7: Turns On sv_cheats");
                player iprintln("^1//jumpheight ^2[JumpHeight] ^7: Adjusts The JumpHeight To The Given Value");
                player iprintln("^1//gravity ^2[Gravity] ^7: Adjusts The Gravity To The Given Value");
                player iprintln("^1//speed ^2[Speed] ^7: Adjusts The Speed To The Given Value");
                player iprintln("^1//collision ^2[0/1/2] ^7: Changes Collision: 0 - Everyone, 1 - Enemies, 2 - Nobody");
                player iprintln("^1//ejection ^2[0/1/2] ^7: Changes Ejection: 0 - Everyone, 1 - Enemies, 2 - Nobody");
                player iprintln("^1//ejectspeed ^2[Value] ^7: Sets The Ejection Speed To The Specified Value");
                player iprintln("^1//dvar ^2[Dvar] [Value] ^7: Sets The Dvar To The Specified Value/String");
                wait 0.05;
                player iprintln("^1//map ^2[MapName]^7: Changes The Map To The Specified Map");
                player iprintln("^1//mr ^7: Restarts The Map");
                player iprintln("^1//fr ^7: Fast Restarts The Map");
                player iprintln("^1//end ^7: Ends The Map");
                //player iprintln("^1//god ^7: Turns On GodMode");
                player iprintln("^1//ufo ^7: Turns On UFO");
                player iprintln("^1//kill ^2[Player] ^7: Kills The Specified Player");
                player iprintln("^1//freeze ^2[Player] ^7: Freezes The Specified Player");
                player iprintln("^1//unfreeze ^2[Player] ^7: UnFreezes The Specified Player");
                player iprintln("^1//takeweapons ^2[Player] ^7: Takes All The Weapons From The Specified Player");
                player iprintln("^1//takeall ^7: Takes All The Weapons From Every Player");
                player iprintln("^1//takeinf ^7: Takes All The Weapons From The Infected");
                player iprintln("^1//takesur ^7: Takes All The Weapons From The Survivors");
                player iprintln("^1//give ^2[Player] [WeaponName] ^7: Gives The Specified Player The Specified Weapon");
                player iprintln("^1//giveall ^2[WeaponName] ^7: Gives Every Player The Specified Weapon");
                player iprintln("^1//giveinf ^2[WeaponName] ^7: Gives The Infected The Specified Weapon");
                player iprintlnbold("Press ^2Shift ^1+ ^2` ^7To See The Commands");
            break;
        }
    }
}

// Returns the player of the name passed in, if in the game. 0 if not.
findPlayerByName( name ) {
    foreach ( player in level.players ) {
		if(issubstr(tolower(player.name), name))
			return player;
    }
    return undefined;
}

ForceStanceMode()
{
    self endon("disconnect");
    level endon("game_ended");
    self notify("endforcemode");
    self endon("endforcemode");

    for(;;)
    {
        wait 0.05;
        if(self getstance() != self.forcemode)
        self setstance(self.forcemode);
    }
}

ForceStanceModeAll()
{
    self endon("disconnect");
    self notify("refresh");
    self endon("refresh");
    level endon("game_ended");
    level endon("endforcemodeall");

    for(;;)
    {
        wait 0.05;
        if(self getstance() != level.forcemode)
        self setstance(level.forcemode);
        //self iprintln(level.forcemode);
    }
}

isBuffUnlockedForWeaponReplace( buffRef, weaponRef )
{
	return false;
}


setWeaponStatReplace( name, incValue, statName )
{
	if ( !incValue )
		return;
	
	weaponClass = getWeaponClass( name );
	
	// we are not currently tracking killstreaks or deathstreaks
	if( isKillstreakWeapon( name ) || weaponClass == "killstreak" || weaponClass == "deathstreak" || weaponClass == "other" )
		return;
		
	// we don't want to track environment weapons, like a mounted turret
	if( isEnvironmentWeapon( name ) )
		return;

	if( weaponClass == "weapon_grenade" || weaponClass == "weapon_riot" || weaponClass == "weapon_explosive" )
	{
			return;
	}
	
	if( statName != "deaths" )
	{
		name = self getCurrentWeapon();  
	}
	
	// defensive check to ensure current weapon isnt killstreak or deathstreaks weapon
	if( isKillstreakWeapon( name ) || weaponClass == "killstreak" || weaponClass == "deathstreak" || weaponClass == "other" )
		return; 
	
	if( !isdefined( self.trackingWeaponName ) )
		self.trackingWeaponName = name;
	
	if( name != self.trackingWeaponName )
	{
		self maps\mp\gametypes\_persistence::updateWeaponBufferedStats();
		self.trackingWeaponName = name;
	}
	
	switch( statName )
	{
		case "shots":
			self.trackingWeaponShots++;
			break;
		case "hits":
			self.trackingWeaponHits++;
			break;
		case "headShots":
			self.trackingWeaponHeadShots++;
			self.trackingWeaponHits++;
			break;
		case "kills":
			self.trackingWeaponKills++;
			break;
	}
	
	if( statName == "deaths" )
	{
		println("wrote deaths");
		tmp = name;
		tokens = strTok( name, "_" );
		
		altAttachment = undefined;
	
		//updating for IW5 weapons
		if ( tokens[0] == "iw5" )
			weaponName = tokens[0] + "_" + tokens[1];
		else if( tokens[0] == "alt" )
			weaponName = tokens[1] + "_" + tokens[2];
		else
			weaponName = tokens[0];
			
		if ( !isCACPrimaryWeapon( weaponName ) && !isCACSecondaryWeapon( weaponName ) )
			return;
		
		/*
		if ( isSubStr( weaponName, "akimbo" ) )
		{
			weaponName = fixAkimboString( weaponName, false );
		}
		*/
		
		if ( tokens[0] == "alt" )
		{
			weaponName = tokens[1] + "_" + tokens[2];
			
			foreach( token in tokens )
			{
				if ( token == "gl" || token == "gp25" || token == "m320" )
				{
					altAttachment = "gl";
					break;	
				}
				if ( token == "shotgun" )
				{
					altAttachment = "shotgun";
					break;	
				}
			}
		}
		
		if( isDefined( altAttachment) && ( altAttachment == "gl" || altAttachment == "shotgun" ) )
		{
			self maps\mp\gametypes\_persistence::incrementAttachmentStat( altAttachment, statName, incValue ); 
			self maps\mp\_matchdata::logAttachmentStat( altAttachment, statName, incValue);
			return;
		}
	
		self maps\mp\gametypes\_persistence::incrementWeaponStat( weaponName, statName, incValue );
		self maps\mp\_matchdata::logWeaponStat( weaponName, "deaths", incValue );
	
		//weaponAttachments = getWeaponAttachments( name );
		if( tokens[0] != "none" )
		{
			for( i = 0; i < tokens.size; i++ )
			{
				//iw5 token magic	
				if(tokens[i] == "alt" )
				{	
					i += 2;
					continue;			
				}	
				
				//iw5 token magic	
				if(tokens[i] == "iw5" )
				{	
					i += 1;
					continue;
				}
				
				if(tokens[i] == "mp" )
					continue;
				
				if( isSubStr( tokens[i], "camo" ) )
					continue;
				
				//handles iw5 scoped weapons
				if( isSubStr( tokens[i], "scope" ) && !isSubStr( tokens[i], "vz" ) )
					continue; 
				
				if ( isSubStr( tokens[i], "scope" ) && isSubStr( tokens[i], "vz" ) )
					tokens[i] = "vzscope";
				
				tokens[i] = validateAttachment( tokens[i] );				
				
				//IW4 weapon check
				if ( i == 0 && ( tokens[i] != "iw5" && tokens[i] != "alt" ) )
					continue;
					
				self maps\mp\gametypes\_persistence::incrementAttachmentStat( tokens[i], statName, incValue ); 
				self maps\mp\_matchdata::logAttachmentStat( tokens[i], statName, incValue);
			}
		}
	}
}