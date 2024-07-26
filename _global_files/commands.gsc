#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
    replacefunc(maps\mp\_utility::isBuffUnlockedForWeapon, ::isBuffUnlockedForWeaponReplace);
    replacefunc(maps\mp\gametypes\_gamelogic::setWeaponStat, ::setWeaponStatReplace);

    precacheshader("hud_scorebar_topcap");

	precacheitem("at4_mp");

    level.prevcallbackPlayerDisconnect = level.callbackPlayerDisconnect;
  	level.callbackPlayerDisconnect = ::onDisconnect;

    //"C:/Servers/IW4mAdmin/Configuration/muted_players.json"
    //"C:/Users/Sam/AppData/Local/Plutonium/storage/iw5/server_data/muted_players.json"
    level.muted_players_path            = "C:/Servers/IW4mAdmin/Configuration/muted_players.json";

    level.forcestancemodeon 					= false;
    level.leftgun 								= false;
    level.tinygun 								= false;
    level.thirdperson 							= false;
    level.commands_prf							= "^3^7[ ^3Commands^7 ] ";
    level.chat_bans                             = [];

    setdvar("camera_thirdpersonoffset", 		"-120 -10 30");
    setdvar("camera_thirdpersonoffsetads", 		"-40 -10 4");

    level thread command_listener();
    level thread on_connect();

    level.admin_commands 						= [];

    // 1 Moderator
    add_command("/blocking", 				1, 						"^5//blocking ^2[Player] ^7: Teleport The Specified Player To Nearest Spawn");
	add_command("/push", 					1, 						"^5//push ^2[Player] ^7: Pushes The Specified Player A little");
	add_command("/uavall", 					1, 						"^5//uavall ^7: Turns On UAV For All");
	add_command("/ufo", 					1, 						"^5//ufo ^7: Turns On UFO");
	add_command("/mute", 					1, 						"^5//mute ^7: ^2[Player]");
	add_command("/unmute", 					1, 						"^5//unmute ^7: ^2[Player]");
	add_command("/help", 					1, 						"^5//help ^7: Shows a list of all Commands");
	// 2 Administrator
	add_command("/resetname", 				2, 						"^5//resetname ^2[Player] ^7: Resets Players Name");
    add_command("/killbots", 				2, 						"");
	add_command("/name",     				2, 						"^5//name ^2[Player]/[Name] - [Name] ^7: Sets Your Name Or Another Persons Name");
	add_command("/setclantag", 				2, 						"^5//setclantag ^2[Clantag] ^7: Sets Your Clantag");
	add_command("/tp", 						2, 						"^5//tp ^2[Player] [PlayerToTpTo] ^7: Teleports The Specified Player To Another Player");
	add_command("/tpto", 					2, 						"^5//tpto ^2[Player] ^7: Teleports Yourself To The Specified Player");
	add_command("/bring", 					2, 						"^5//bring ^2[Player] ^7: Brings The Specified Player To You");
    add_command("/bringall", 				2, 						"^5//bringall ^7: Brings All The Players To You");
	add_command("/bringsur",				2, 						"^5//bringsur ^7: Brings All The Survivors To You");
	add_command("/bringinf", 				2, 						"^5//bringinf ^7: Brings All The Infected To You");
	add_command("/vision", 					2, 						"^5//vision ^2[Player] [Vision] ^7: Turns The Players Vision Into The Specified Vision");
	add_command("/visionall", 				2, 						"^5//visionall ^2[Vision] ^7: Turns The Global Vision Into The Specified Vision");
	add_command("/pushnum", 				2, 						"^5//pushnum ^2[Player] [Value] ^7: Pushes The Specified Player The Given Value");
	add_command("/linkto", 					2, 						"^5//linkto ^2[Player] ^7: Link Yourself To Specified Player");
	add_command("/linktolink", 				2, 						"^5//linktolink ^2[Player] [Player] ^7: Links Player 1 To Player 2");
	add_command("/unlink", 					2,						"^5//unlink ^2[Player] ^7: Unlink Specified Player, Leave Blank For Unlinking Yourself");
	add_command("/stance", 					2, 						"^5//stance ^2[Player] [Stance] ^7: Sets The Specified Players Stance: Stand, Crouch, Prone");
	add_command("/forcestance", 			2, 						"^5//forcestance ^2[Player] [Stance] ^7: Locks The Specified Players Stance: Stand, Crouch, Prone, Leave Blank To Stop");
	add_command("/forcestanceall", 			2, 						"^5//forcestanceall ^2[Stance] ^7: Locks All Players Stance: Stand, Crouch, Prone, Leave Blank To Stop");
	add_command("/thirdperson", 			2, 						"^5//thirdperson ^7: Turns On Global Third Person");
	add_command("/tinygun", 				2, 						"^5//tinygun ^7: Turns On Tiny Gun");
	add_command("/leftgun", 				2, 						"^5//leftgun ^7: Turns On Left Gun");
	add_command("/kick", 					2, 						"^5//kick ^2[Player] ^7: Kicks The Specified Player");
	add_command("/uavall", 					2, 						"^5//uavall ^7: Turns On UAV For All");
	add_command("/show", 					2, 						"^5//show ^7: Shows Your Player Model");
	add_command("/hide", 					2, 						"^5//hide ^7: Hides Your Player Model");
	add_command("/ammo", 					2, 						"^5//ammo ^7: Turns On player_sustainammo");
	add_command("/cheats", 					2, 						"^5//cheats ^7: Turns On sv_cheats");
	add_command("/jumpheight", 				2, 						"^5//jumpheight ^2[JumpHeight] ^7: Adjusts The JumpHeight To The Given Value");
	add_command("/gravity", 				2, 						"^5//gravity ^2[Gravity] ^7: Adjusts The Gravity To The Given Value");
	add_command("/speed", 					2, 						"^5//speed ^2[Speed] ^7: Adjusts The Speed To The Given Value");
	add_command("/collision", 				2, 						"^5//collision ^2[0/1/2] ^7: Changes Collision: 0 - Everyone, 1 - Enemies, 2 - Nobody");
	add_command("/ejection", 				2, 						"^5//ejection ^2[0/1/2] ^7: Changes Ejection: 0 - Everyone, 1 - Enemies, 2 - Nobody");
	add_command("/ejectspeed", 				2, 						"^5//ejectspeed ^2[Value] ^7: Sets The Ejection Speed To The Specified Value");
	add_command("/dvar", 					2, 						"^5//dvar ^2[Dvar] [Value] ^7: Sets The Dvar To The Specified Value/String");
	add_command("/map", 					2, 						"^5//map ^2[MapName]^7: Changes The Map To The Specified Map");
	add_command("/mr", 						2, 						"^5//mr ^7: Restarts The Map");
	add_command("/fr", 						2, 						"^5//fr ^7: Fast Restarts The Map");
	add_command("/end", 					2, 						"^5//end ^7: Ends The Map");
	add_command("/kill", 					2, 						"^5//kill ^2[Player] ^7: Kills The Specified Player");
	add_command("/freeze", 					2, 						"^5//freeze ^2[Player] ^7: Freezes The Specified Player");
	add_command("/unfreeze", 				2, 						"^5//unfreeze ^2[Player] ^7: UnFreezes The Specified Player");
	add_command("/takeweapons", 			2, 						"^5//takeweapons ^2[Player] ^7: Takes All The Weapons From The Specified Player");
	add_command("/takeall", 				2, 						"^5//takeall ^7: Takes All The Weapons From Every Player");
	add_command("/takeinf", 				2, 						"^5//takeinf ^7: Takes All The Weapons From The Infected");
	add_command("/takesur", 				2, 						"^5//takesur ^7: Takes All The Weapons From The Survivors");
	add_command("/give", 					2, 						"^5//give ^2[Player] [WeaponName] ^7: Gives The Specified Player The Specified Weapon");
	add_command("/giveall", 				2, 						"^5//giveall ^2[WeaponName] ^7: Gives Every Player The Specified Weapon");
	add_command("/givesur", 				2, 						"^5//givesur ^2[WeaponName] ^7: Gives The Survivors The Specified Weapon");
	add_command("/giveinf", 				2, 						"^5//giveinf ^2[WeaponName] ^7: Gives The Infected The Specified Weapon");
    add_command("/givestreak", 				2, 						"^5//givestreak ^2[Player] [Killstreak] ^7: Gives The Specified Person The Specified Killstreak");
    add_command("/fuckedvision", 			2, 						"");
	// Owner

    wait 1;
    // chat bans
    add_chat_ban("McBigMac", "0100000000184c11");
	add_chat_ban("beefboss97", "01000000003c8765");
	add_chat_ban("Kotonic", "01000000002d8c81");
	if(fileExists(level.muted_players_path)) {
		muted_json = jsonParse(readfile(level.muted_players_path));

        if(isdefined(muted_json)) {
            keys = getarraykeys(muted_json);

            for(i = 0;i < keys.size;i++) {
                if(isdefined(muted_json[keys[i]]["Gamertag"]))
                    add_chat_ban(muted_json[keys[i]]["Gamertag"], keys[i]);
            }
        }
	}
}

on_connect() {
    for(;;) {
        level waittill("connected", player);

       	player thread on_spawned();

        if(level.forcestancemodeon == true)
        	player thread ForceStanceModeAll();

        if(level.leftgun == true)
        	player setclientdvar("cg_gun_y", "12");

        if(level.tinygun == true)
        	player setclientdvar("cg_gun_x", "100");
    }
}

statusicon_setter(var) {
    self endon("disconnect");

    if(!isdefined(var))
        return;

    while(1) {
        if(self.statusicon != var)
            self.statusicon = var;

        wait .05;
    }
}

on_spawned() {
    self endon("disconnect");
    self waittill("spawned_player");

    wait 7;

    if(isdefined(level.special_users[self.guid]) && !isdefined(self.status_set))
        self thread statusicon_setter(level.special_users[self.guid]["statusicon"]);
    else if(isdefined(level.admin_commands_clients[self.guid]) && !isdefined(self.status_set))
        self thread statusicon_setter(level.admin_commands_clients[self.guid]["statusicon"]);
}

add_command(command, accesslevel, desc) {
	if(!isdefined(level.admin_commands[command])) {
		level.admin_commands[command] 				= spawnstruct();
		level.admin_commands[command].cmd 			= command;
		level.admin_commands[command].access 		= accesslevel;
		level.admin_commands[command].description 	= desc;
	}
}

command_listener() {
    for(;;) {
        level waittill("say", message, player);

        if(!isdefined(level.admin_commands_clients[player.guid]))
        	continue;

        target 			= undefined;
        source 			= undefined;
        dest 			= undefined;

		args 			= [];
        args[0] 		= "";
        args[1] 		= "";
        args[2] 		= "";

        str = strTok(message, "");

        i = 0;
        foreach(s in str) {
            if(i > 2)
                break;
            args[i] = s;
            i++;
        }

        str = strTok(args[0], " ");

        i = 0;
        foreach(s in str) {
            if(i > 2)
                break;
            args[i] = s;
            i++;
        }

        if(!isdefined(level.admin_commands[args[0]])) {
        	if(issubstr(args[0], "/"))
        		player iprintln("Command ^1" + args[0] + " ^7Not Found!");
        	continue;
        }

        if(isdefined(level.admin_commands[args[0]]) && level.admin_commands_clients[player.guid]["access"] < level.admin_commands[args[0]].access) {
        	player iprintln("No Access to ^1" + level.admin_commands[args[0]].cmd);
        	continue;
        }

		admin_ntf = "";
		if(isdefined(args[2]) && isdefined(args[1]))
			admin_ntf = player.name + " Executed ^1" + level.admin_commands[args[0]].cmd + " " + args[1] + " " + args[2];
		else if(!isdefined(args[2] && isdefined(args[1])))
			admin_ntf = player.name + " Executed ^1" + level.admin_commands[args[0]].cmd + " " + args[1];
		else
			admin_ntf = player.name + " Executed ^1" + level.admin_commands[args[0]].cmd;

		for(i = 0;i < level.players.size;i++) {
			if(isdefined(level.admin_commands_clients[level.players[i].guid]) && level.admin_commands_clients[level.players[i].guid]["access"]== 3 && level.players[i] != player)
				level.players[i] iprintln(admin_ntf);
		}

		writefile(level.file_commands, admin_ntf + "|" + getdvar("sv_hostname"));

        switch(level.admin_commands[args[0]].cmd) {
        	case "/help":
        		player iprintlnbold("Press ^;Shift ^7& ^;Tilde ^7To See Commands");
        		foreach(command in level.admin_commands) {
        			if(command.access <= level.admin_commands_clients[player.guid]["access"])
        				player iprintln(command.description);
        		}
        		break;
            case "/freeze":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                    target freezeControls( true );
            	break;
            case "/fuckedvision":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                    target setplayerangles((0, 0, 180));
            	break;
            case "/killbots":
                foreach(player in level.players) {
                    if(issubstr(player.name, "bot"))
                        player suicide();
                }
                break;
            case "/name":
            case "/rename":
                if(isdefined(args[2]))
                {
                    target = playerexits( args[1] );

                    if(isdefined(target))
                    {
                        target.namechanged = true;
                        target setname(args[2]);
                    }
                }
                else if(isdefined(args[1]))
                {
                    player.namechanged = true;
                    player setname(args[1]);
                }

            break;
            case "/resetname":
                if(isdefined(args[1]))
                {
                    target = playerexits( args[1] );

                    if(isdefined(target))
                    {
                        if(isdefined(target.namechanged))
                        {
                            target.namechanged = undefined;
                            target resetname();
                        }
                        else
                            player iprintln("Player ^1Has Not Had A Name Change");
                    }
                }
                else
                {
                    if(isdefined(player.namechanged))
                    {
                        player.namechanged = undefined;
                        player resetname();
                    }
                        player iprintln("You ^1Have Not Had A Name Change");
                }
            break;

            case "/setclantag":
            case "/setclan":
            case "/sc":
                if(!isdefined(args[1]))
                    continue;
                conv = getsubstr(message, args[0].size, message.size);
                player setClantag(conv);
            	break;
            case "/unfreeze":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                    target freezeControls( false );
            	break;
            case "/kill":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                    target suicide();
            	break;
            case "/tpto":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                    player setOrigin( target getOrigin() );
            	break;
            case "/bring":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                target setOrigin( player getOrigin() );
            break;
            case "/linkto":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target)) {
                	player playerLinkTo(target);
                	player iprintlnbold( "You Got Linked To ^1" + target.name);
                }
            	break;
            case "/linktolink":
                if(!isdefined(args[1]))
                    continue;

                source = playerexits( args[1] );
                dest = playerexits( args[2] );
                if ( isdefined(source) && isdefined(dest) ) {
                    source playerLinkTo(dest);
					source iprintlnbold( "You Got Linked To ^1" + dest.name);
				}
            	break;
            case "/givestreak":
            case "/givekillstreak":
                if(!isdefined(args[1]) && !isdefined(args[2]))
                	continue;

                target = playerexits( args[1] );
                if (isdefined(target)) {
                    target maps\mp\killstreaks\_killstreaks::giveKillstreak(args[2]);
					target iprintlnbold("Killstreak Given ^1" + args[2]);
              	}
            	break;
            case "/unlink":
                if(!isdefined(args[1]))
                {
                    player unlink();
                    player iprintlnbold("Unlinked");
                }
                else
                {
                    target = playerexits( args[1] );
                    if (isdefined(target))
                    target unlink();
                    target iprintlnbold("Unlinked");
                }
            	break;
            case "/stance":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                {
                    if(args[2] == "stand" || args[2] == "crouch" || args[2] == "prone")
                    {
                    target SetStance( args[2] );
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
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                {
                    if(isdefined(args[2]))
                    {
                        target notify("endforcemode");
                        //iprintln("stopping");
                        break;
                    }

                    if(args[2] == "stand" || args[2] == "crouch" || args[2] == "prone")
                    {
                        target.forcemode = args[2];
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
                if(isdefined(args[1]))
                {
                    level notify("endforcemodeall");
                    level.forcestancemodeon = false;
                   // iprintln("stopping");
                    break;
                }

                if(args[1] == "stand" || args[1] == "crouch" || args[1] == "prone")
                {
                    level.forcemode = args[1];
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
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                {
                    target setVelocity(target getVelocity()+((randomintrange(-100,100),randomintrange(-100,100),randomintrange(100,300))));
                }
            	break;
            case "/pushnum":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target))
                {
                    val = int(args[2]);
                    valmin = int(args[2]) - int(args[2]) * 2;
                    target setVelocity(target getVelocity()+((randomintrange(valmin,val),randomintrange(valmin,val),int(args[2]))));
                }
            	break;
            case "/give":
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
                if (isdefined(target)) {
					target iprintlnbold( "You Got Given The " + args[2] );
                    target _giveWeapon(args[2]);
                    target switchToWeapon( args[2] );
                }
            	break;
            case "/giveall":
                foreach( p in level.players )
				{
					p iprintlnbold( "You Got Given The " + args[1] );
                    p _giveWeapon( args[1] );
                    p switchToWeapon( args[1] );
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
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );
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
						p iprintlnbold( "You Got Given The " + args[1] );
                        p giveWeapon( args[1] );
                        p switchToWeapon( args[1] );
                    }
                }
            	break;
            case "/giveinf":
                foreach ( p in level.players )
				{
                    if ( p.sessionteam == "axis" )
					{
						p iprintlnbold( "You Got Given The " + args[1] );
                        p giveWeapon( args[1] );
                        p switchToWeapon( args[1] );
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
                if(!isdefined(args[1]))
                    continue;
                target = playerexits( args[1] );

                thevision = args[2];

                if (isdefined(target)) {
                    if(thevision == "")
                    thevision = "default";
					target iprintlnbold( "Your Vision Changed To ^1" + thevision );
                    target visionsetnakedforplayer(thevision, 3);
                }
            	break;
            case "/visionall":
                thevision = args[1];

                if(thevision == "")
                	thevision = "default";

                visionsetnaked(thevision, 3);
                iprintlnbold("Vision Changed To ^1" + thevision);
           		break;
            case "/ufo":
                if(player.sessionstate == "playing") {
					player iprintlnbold("Ufo ^2On");
					player.savedweapons = player getweaponslistprimaries();
                    player.isinufo = true;
					player disableweapons();
                    player allowspectateteam("allies", true);
                    player allowspectateteam("axis", true);
                    player allowspectateteam("freelook", true);
                    player.sessionstate = "spectator";
                    player thread wallhack();
                }
				else {
					player iprintlnbold("Ufo ^1Off");
					player.sessionstate = "playing";
                    player.isinufo = undefined;
					player notify("wallhack_end");
					player thread ufo_weapons_back();
                }
            	break;
            case "/bringall":
                foreach(p in level.players) {
					P iprintlnbold("You Got Teleported to ^1" + player.name);
                    p setorigin(player.origin);
                }
            	break;
            case "/bringsur":
                foreach(p in level.players) {
                    if(p.sessionteam == "allies") {
						p iprintlnbold("You Got Teleported to ^1" + player.name);
                        p setorigin(player.origin);
					}
                }
            	break;
            case "/bringinf":
                foreach(p in level.players) {
                    if(p.sessionteam == "axis") {
						p iprintlnbold( "You Got Teleported to " + player.name);
                        p setorigin(player.origin);
					}
                }
            	break;
            case "/hide":
				player iprintlnbold( "You Are Now Hidden");
                player hide();
            	break;
            case "/show":
				player iprintlnbold( "You Are Now Shown");
                player show();
            	break;
			case "/ammo":
                if (GetDvarInt( "player_sustainammo" ) == 0) {
					setDvar("player_sustainammo", 1);
					iprintlnbold( "Unlimited Ammo On");
                }
				else {
					setDvar("player_sustainammo", 0);
					iprintlnbold( "Unlimited Ammo Off");
                }
				break;
			case "/cheats":
                if (GetDvarInt( "sv_cheats" ) == 0) {
					setDvar("sv_cheats", 1);
					player iprintlnbold( "Cheats On");
                }
				else {
					setDvar("sv_cheats", 0);
					player iprintlnbold( "Cheats Off");
                }
				break;
            case "/collision":
                if(int(args[1]) == 0)
                {
                    setDvar("g_playercollision", args[1]);
                    iprintlnbold("^2Collision Changed To^1 Everyone");
                }
                else if(int(args[1]) == 1)
                {
                    setDvar("g_playercollision", args[1]);
                    iprintlnbold("^2Collision Changed To^1 Enemies");
                }
                else if(int(args[1]) == 2)
                {
                    setDvar("g_playercollision", args[1]);
                    iprintlnbold("^2Collision Changed To^1 Nobody");
                }
            	break;
            case "/ejection":
                if(int(args[1]) == 0)
                {
                    setDvar("g_playerejection", args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Everyone");
                }
                else if(int(args[1]) == 1)
                {
                    setDvar("g_playerejection", args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Enemies");
                }
                else if(int(args[1]) == 2)
                {
                    setDvar("g_playerejection", args[1]);
                    iprintlnbold("^2Ejection Changed To^1 Nobody");
                }
            	break;
            case "/ejectspeed":
                ejectspeed = args[1];

                if(ejectspeed == "")
                    ejectspeed = 25;

				setDvar("g_playercollisionejectspeed", ejectspeed);
                iprintlnbold("^2Ejection Speed Changed To^1 " + ejectspeed);
            	break;
            case "/jumpheight":
				setDvar("jump_height", args[1]);
                iprintlnbold("^2Jumpheight Changed To^1 " + args[1]);
            	break;
            case "/gravity":
				setDvar("g_gravity", args[1]);
                iprintlnbold("^2Gravity Changed To^1 " + args[1]);
            	break;
            case "/speed":
				setDvar("g_speed", args[1]);
                iprintlnbold("^2Speed Changed To^1 " + args[1]);
            	break;
            case "/dvar":
				setDvar(args[1], args[2]);
                iprintlnbold("^2Dvar ^1" + args[1] + "^2 Set To^1 " + args[2]);
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
            	if(isdefined(args[1])) {
            		if(mapexists(args[1]))
                        cmdexec("map " + args[1]);
            		else
            			player iprintln("Map ^1" + args[1] + "^7 Not Found!");
            	}
            	else
            		player iprintln("Argument 1 ^1Not Found!");
            	break;
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
            case "/tp":
                if(!isdefined(args[1]))
                    continue;
                source = playerexits( args[1] );
                dest = playerexits( args[2] );
                if ( isdefined(source) && isdefined(dest) )
				{
                    source setOrigin( dest getOrigin() );
					source iprintlnbold( "You Got Teleported To " + dest.name);
				}
            	break;
            case "/blocking":
                if (!isdefined(args[1]))
                    continue;
                target = playerexits(args[1]);

                if(isdefined(target)) {
					target iprintlnbold( "^1Moving To Spawn Due To Blocking/Boosting" );
                    target thread blocking();
                }
                else
                	player iprintln("^2Player ^7Not Found!");
            	break;
            case "/kick":
                if(!isdefined(args[1]))
                    continue;
                num = undefined;
                target = playerexits( args[1] );
                if (isdefined(target))
                    num = target getEntityNumber();
                    kick(num);
            break;
        }
    }
}

waittill_endgame() {
	level endon("StopTracking");

	level waittill("final_killcam_done");

    wait 1;

	cmdexec("map " + level.next_map);
}

playerexits(name) {
    foreach(player in level.players) {
		if(issubstr(tolower(player.name), tolower(name)))
			return player;
    }
    self tell_raw(level.commands_prf + "^3" + name + " ^7Not Found!");
    return undefined;
}

ForceStanceMode() {
    self endon("disconnect");
    level endon("game_ended");
    self notify("endforcemode");
    self endon("endforcemode");

    for(;;) {
        wait .05;

        if(self getstance() != self.forcemode)
        	self setstance(self.forcemode);
    }
}

ForceStanceModeAll() {
    self endon("disconnect");
    self notify("refresh");
    self endon("refresh");
    level endon("game_ended");
    level endon("endforcemodeall");

    for(;;) {
        wait 0.05;
        if(self getstance() != level.forcemode)
        self setstance(level.forcemode);
        //self iprintln(level.forcemode);
    }
}

isBuffUnlockedForWeaponReplace( buffRef, weaponRef ) {
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
		//println("wrote deaths");
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

blocking()
{
    rrr = undefined;
    dist = undefined;
    org = undefined;
    foreach(spot in level.spawnpoints)
    {
        if(!isdefined(org))
        {
            org = spot;
            dist = distance(self.origin, org.origin);
        }
        rrr = Distance(self.origin, spot.origin);
        if(rrr < dist)
        {
            org = spot;
            dist = rrr;
        }
    }
    self setOrigin(org.origin);
    self setplayerangles(org.angles);
}

SuicideCommand(args) {
    self Tell("^7You will now ^1die ^2"+self.name);
    wait 0.5;
    self Suicide();
}

FpsCommand(args){

    self notify("disable3rd");

    if(self hasFpsEnabled()){
        self disableFps();
        self notify("disableFps");
    } else {
        self enableFps();
        self thread fpsThread();

    }
}

ThirdPersonCommand() {
    self notify("disableFps");

    if(self has3rdEnabled()){
        self disable3rd();
        self notify("disable3rd");
    } else {
        self enable3rd();
        self thread thirdPersonThread();
    }
}

enable3rd(){
    self.has3rdEnabled = true;
    self.hud_damagefeedback.alpha = 1;
    self SetClientDvar("cg_thirdPerson", 1);
    self SetClientDvar("cg_thirdPersonRange", 80);
    self tell("^7Third Person ^5Enabled");
}
disable3rd(){
    self.has3rdEnabled = false;
    self.hud_damagefeedback.alpha = 0;
    self SetClientDvar("cg_thirdPerson", 0);
    self tell("^7Third Person ^5Disabled");
}

enableFps(){
    self.hasFpsEnabled = true;
    self SetClientDvar("r_fog",0);
    self SetClientDvar("fx_drawclouds",0);
    self SetClientDvar("fx_enable",0);
    self SetClientDvar("r_lightmap", 3);
    self tell("^7FPS ^5Enabled");
}
disableFps(){
    self.hasFpsEnabled = false;
    self SetClientDvar("r_fog",1);
    self SetClientDvar("fx_drawclouds",1);
    self SetClientDvar("fx_enable",1);
    self SetClientDvar("r_lightmap", 1);
    self tell("^7FPS ^5Disabled");
}

fpsThread(){
    level endon("game_ended");
    self endon("disconnect");
    self endon("disableFps");

    self tell("Press ^53 ^7to enable/disable ^5FPS");

    for(;;){
        self notifyonplayercommand("toggleFps", "+actionslot 3");
        self waittill("toggleFps");

        if(self hasFpsEnabled()){
            self disableFps();
        } else {
            self enableFps();
        }
        wait 0.2;
    }
}

thirdPersonThread(){
    level endon("game_ended");
    self endon("disconnect");
    self endon("disable3rd");

    self tell("Press ^53 ^7to enable/disable ^5Third person mode");

    for(;;){
        self notifyonplayercommand("toggle3rd", "+actionslot 3");
        self waittill("toggle3rd");

        if(self has3rdEnabled()){
            self disable3rd();
        } else {
            self enable3rd();
        }
        wait 0.2;
    }
}

has3rdEnabled() {
    return isDefined(self.has3rdEnabled) && self.has3rdEnabled == true;
}

hasFpsEnabled() {
    return isDefined(self.hasFpsEnabled) && self.hasFpsEnabled == true;
}

wallhack() {
	self endon("disconnect");
	self endon("wallhack_end");

	self.wallhack_huds = [];
	self thread end_wallhack();

	while(1) {
		foreach(player in level.players) {
			if(player != self) {
				if(!isdefined(player.wallhack_shader)) {
					player.wallhack_shader = newclienthudelem(self);
					player.wallhack_shader setshader("hud_scorebar_topcap", 6, 6);
					player.wallhack_shader setwaypoint(2, 0);
					player.wallhack_shader.hideWhenInMenu = false;
					player.wallhack_shader.hidewheninkillcam = false;
					player.wallhack_shader.archived = false;
					player.wallhack_shader.alpha = .4;
					player.wallhack_shader thread destroy_on_notify("disconnect", player);
					self.wallhack_huds[self.wallhack_huds.size] = player.wallhack_shader;
				}
				else {
					player.wallhack_shader.x = player.origin[0];
					player.wallhack_shader.y = player.origin[1];
					player.wallhack_shader.z = player.origin[2] + 10;
				}
				var_0 = self getspectatingplayer();

				if(isdefined(var_0)) {
					if(var_0 is_looking_at(player) && sighttracepassed(var_0.origin + (0, 0, 64), player.origin + (0, 0, 64), false, var_0)) {
						if(player.sessionteam == var_0.sessionteam)
							player.wallhack_shader.color = (0, .5, 1);
						else
							player.wallhack_shader.color = (1, .25, .25);
					}
					else {
						if(player.sessionteam == var_0.sessionteam)
							player.wallhack_shader.color = (.25, 1, .25);
						else
							player.wallhack_shader.color = (.75, .75, 0);
					}
				}
			}
		}

		wait .05;
	}
}

end_wallhack() {
	self endon("disconnect");

	self waittill("wallhack_end");

	foreach(hud in self.wallhack_huds)
		hud destroy();
}

destroy_on_notify(notifyname, who) {
	who waittill(notifyname);

	if(isdefined(self))
		self destroy();
}

is_looking_at(who) {
	angles = vectortoAngles((who.origin + (0,0,50)) - self.origin);
	trigangle = angles[1];
	myangle = self.angles[1];
	if(trigangle > 180)
		trigangle = trigangle - 360;
	looking = (myangle - trigangle);
	if(looking > 340)
		looking = looking - 360;
	if(looking < -340)
		looking = looking + 360;
	if(looking > -35 && looking < 35 )
		return true;
	return false;
}

Prestige_Logic() {
	if(self maps\mp\gametypes\_rank::getRankXP() < maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ))
	{
		diff = maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) - self maps\mp\gametypes\_rank::getRankXP();
		var_2 = self scripts\_global_files\player_stats::getPlayerPrestigeLevel() + 1;
		self iprintln("You Need ^1" + diff + "^7 More ^1XP^7 To Prestige ^1" + var_2 + "^7!");
		self tell("You Need ^1" + diff + "^7 More ^1XP^7 To Prestige ^1" + var_2 + "^7!");
		print(self.name + " Needs ^1" + diff + "^7 More ^1XP^7 To Prestige ^1" + var_2 + "^7!");
	}
	if(self maps\mp\gametypes\_rank::getRankXP() == maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && self scripts\_global_files\player_stats::getPlayerPrestigeLevel() < level.maxPrestige)
	{
		var_1 = self maps\mp\gametypes\_rank::getRankForXp( 0 );
		self.pers["rank"] = var_1;
		self.pers["rankxp"] = 0;
		self scripts\_global_files\player_stats::setStats( "saved_experience", 0);

		var_2 = self scripts\_global_files\player_stats::getPlayerPrestigeLevel() + 1;
		self.pers["prestige"] = var_2;
		self scripts\_global_files\player_stats::setStats( "saved_prestige", var_2 );

		self setRank( var_1, var_2 );

		self iprintln("You Are Now Prestige ^1" + var_2 + "^7!");
		self tell("You Are Now Prestige ^1" + var_2 + "^7!");
		print(self.name + "Is Now Prestige ^1" + var_2 + "^7!");
	}
	else if(self maps\mp\gametypes\_rank::getRankXP() == maps\mp\gametypes\_rank::getRankInfoMaxXP( level.maxRank ) && self scripts\_global_files\player_stats::getPlayerPrestigeLevel() == level.maxPrestige)
	{
		self.pers["prestige"] = 100;
		self setRank( 40, 100 );
		self scripts\_global_files\player_stats::setStats( "saved_prestige", 100 );

		self iprintln("^1Ultra^7 Prestige Unlocked!");
		self tell("^1Ultra^7 Prestige Unlocked!");
		print(self.name + " Has Unlocked ^1Ultra^7 Prestige!");
	}
}

Moab_Checking(checking_user) {
    self tell_raw("^4^7[ ^4Information^7 ] ^4" + checking_user scripts\_global_files\player_stats::getStats( "called_in_moabs") + "^7 M.O.A.Bs Called in by ^4" + checking_user.name);
}

ufo_weapons_back() {
    self enableweapons();
    guns = self getweaponslistprimaries();
    for(i = 0;i < guns.size;i++)
        self takeweapon(guns[i]);

    wait 0.5;

    if(isdefined(self.savedweapons)) {
        if(isdefined(self.savedweapons[0])) {
            self giveweapon(self.savedweapons[0]);
            self switchtoweapon(self.savedweapons[0]);
        }
        if(isdefined(self.savedweapons[1]))
            self giveweapon(self.savedweapons[1]);
    }
    self.health = self.maxhealth;
}

onDisconnect() {
    if(isdefined(self.namechanged))
        self resetname();

    if(isdefined(level.admin_commands_clients) && isdefined(self.guid) && isdefined(level.admin_commands_clients[self.guid]))
        level.admin_commands_clients[self.guid] = undefined;

	self notify("disconnect");

	[[level.prevcallbackPlayerDisconnect]]();
}

add_chat_ban(name, guid) {
    guid = tolower(guid);

	level.chat_bans[guid] = 1;
}


get_hour(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[1], ":");
	if(isdefined(info[0]))
		return info[0];
}

get_min(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[1], ":");
	if(isdefined(info[1]))
		return info[1];
}

get_seconds(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[1], ":");
	if(isdefined(info[2]))
		return info[2];
}

get_year(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[0], "-");
	if(isdefined(info[0]))
		return info[0];
}

get_month(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[0], "-");
	if(isdefined(info[1]))
		return info[1];
}

get_day(data) {
    tmp = strtok(data, " ");
	info = strtok(tmp[0], "-");
	if(isdefined(info[2]))
		return info[2];
}

get_times(data) {
	info = strtok(data, " ");
	if(isdefined(info[1]))
		return info[1];
}

get_date(data) {
	info = strtok(data, " ");
	if(isdefined(info[0]))
		return info[0];
}

strptime(dateString) {
    time = spawnstruct();
    time.year = int(get_year(dateString));
    time.month = int(get_month(dateString));
    time.day = int(get_day(dateString));
    time.hour = int(get_hour(dateString));
    time.minute = int(get_min(dateString));
    time.second = int(get_seconds(dateString));

    return time;
}

isLeapYear(year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

mktime(datetime) {
    // Calculate the number of days since the Unix epoch (1970-01-01)
        days = (datetime.year - 1970) * 365;
    // Add days for leap years
    for (year = 1970; year < datetime.year; year++) {
        if (isLeapYear(year)) {
            days += 1;
        }
    }
    // Days in each month for non-leap years
        monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    // Add days for each month in the current year
    for (month = 1; month < datetime.month; month++) {
        days += monthDays[month - 1];
    }
    // Add one more day for leap year if past February
    if (datetime.month > 2 && isLeapYear(datetime.year)) {
        days += 1;
    }
    // Add the days in the current month
        days += (datetime.day - 1);
        // print("----------");
        // print(datetime.hour);
        // print(datetime.minute);
        // print(datetime.second);
        // print("----------");

    // Calculate the number of seconds
        seconds = days * 86400;
        seconds = seconds + datetime.hour * 3600;
        seconds = seconds + datetime.minute * 60;
        seconds = seconds + datetime.second;

    return seconds;
}

getDateDifferenceInSeconds(startDate, endDate) {
    // Parse the input dates
        startStruct = strptime(startDate);
        endStruct = strptime(endDate);
        // print("strp - Start: " + startDate + "End: " + endDate );
    // Convert the time structs to timestamps
        startTimestamp = mktime(startStruct);
        endTimestamp = mktime(endStruct);
        // print("mk - Start: " + startTimestamp + " End: " + endTimestamp );
    // Calculate the difference in seconds
        diffInSeconds = endTimestamp - startTimestamp;
        // print("diff - " + diffInSeconds);
    return int(diffInSeconds);
}

ReturnDateDifference(startDate, endDate, unmute_check) {
    if(endDate == "Permanent")
        return "Permanent";

    diffInSeconds = getDateDifferenceInSeconds(startDate, endDate);

    if(unmute_check && diffInSeconds < 0)
        return 1;

    days = int(diffInSeconds / 86400);
    remainingSeconds = diffInSeconds % 86400;
    hours = int(remainingSeconds / 3600);
    remainingSeconds = remainingSeconds % 3600;
    minutes = int(remainingSeconds / 60);
    seconds = int(remainingSeconds % 60);

    return "Days-"+days+" Hours-"+hours+" Minutes-"+minutes+" Seconds-"+seconds;
}

addTimeComponents(dateString, timeComponents) {
        if(!isarray(timeComponents))
            return "Permanent";
    // Parse the input date
        dateStruct = strptime(dateString);
    // Convert the date struct to a timestamp
        timestamp = mktime(dateStruct);
    // Calculate the total seconds to add
        for(i=0; i < timeComponents.size; i++) {
            if(!isdefined(timeComponents[i]))
                timeComponents[i] = 0;
        }

        additionalSeconds = (int(timeComponents[0]) * 86400) + (int(timeComponents[1] * 3600)) + (int(timeComponents[2] * 60)) + int(timeComponents[3]);
    // Add the additional seconds to the timestamp
        newTimestamp = timestamp + additionalSeconds;
    // Convert the new timestamp back to a date struct
        newDateStruct = fromTimestamp(newTimestamp);
    // Format the new date struct back to a string
        newDateString = formatDate(newDateStruct);
    return newDateString;
}

fromTimestamp(timestamp) {
    // Calculate the number of days since the Unix epoch (1970-01-01)
        days = timestamp / 86400;
        remainingSeconds = timestamp % 86400;

    // Calculate the number of hours, minutes, and seconds
        hours = remainingSeconds / 3600;
        remainingSeconds = remainingSeconds % 3600;
        minutes = remainingSeconds / 60;
        seconds = remainingSeconds % 60;

    // Calculate the year
        year = 1970;
    while (days >= 365) {
        if (isLeapYear(year)) {
            if (days >= 366) {
                days -= 366;
                year += 1;
            } else {
                break;
            }
        } else {
            days -= 365;
            year += 1;
        }
    }

    // Calculate the month
        monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (isLeapYear(year)) {
        monthDays[1] = 29;
    }

    month = 1;
    while (days >= monthDays[month - 1]) {
        days -= monthDays[month - 1];
        month += 1;
    }

    // Calculate the day
        day = days + 1;

    time = spawnstruct();
    time.year = int(year);
    time.month = int(month);
    time.day = int(day);
    time.hour = int(hours);
    time.minute = int(minutes);
    time.second = int(seconds);

    return time;
}

formatDate(datetime) {
    year = datetime.year;
    month = datetime.month < 10 ? "0" + datetime.month : "" + datetime.month;
    day = datetime.day < 10 ? "0" + datetime.day : "" + datetime.day;
    hour = datetime.hour < 10 ? "0" + datetime.hour : "" + datetime.hour;
    minute = datetime.minute < 10 ? "0" + datetime.minute : "" + datetime.minute;
    second = datetime.second < 10 ? "0" + datetime.second : "" + datetime.second;

    return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
}