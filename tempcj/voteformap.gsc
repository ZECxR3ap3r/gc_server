#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	// these are commands that would be used by normal players so no cheaty admin commands or whatever
	
	level.voteyes = 0;
	level.voteno = 0;
	level.votecolor = ( 0.6, 1, 0.3 );
	level.inprogress = false;
	level.votingnow = false;
	level.votingtime = 0;
	level.votemaptime = 20;

	level thread msgwait(); // chat listener
	level thread onPlayerConnect(); // they didnt vote yet pogu
	level thread usevm(); // auto message to tell people to use commands ( automaticaly uses the server name( your own name if private match))
}

usevm()
{
	level endon("game_ended");
	for(;;)
	{
		wait 120;
		kek = randomint(3);
		if(kek == 0)
		{
			cmdexec("say ^2Want To Change The ^5Map^2?");
			waitframe();
			cmdexec("say ^2Use ^7-votemap ^5Mapname");
		}
		else if(kek == 1)
		{
			cmdexec("say ^2Try Using ^7-height ^2 Or ^7-top^2!");
		}
		else if(kek == 2)
		{
			cmdexec("say ^2Play ^5Tic-Tac-Toe ^2Using ^7-ttt ^5[Name]");
		}
	}
}

onPlayerConnect() 
{
    for(;;) 
	{
        level waittill("connected", player);

		player.hasvoted = false;
	}
}

msgwait()
{
    for(;;) {
        // Wait until a chat is sent
        level waittill( "say", message, player );


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
        switch (tolower(level.args[0]))
		{
            case "-votemap": // votemap mapname
                if ( level.args[1] == "" )
                    continue;

				if(level.votingtime == 0)
				level thread votemap(level.args[1], player);
				else
				player IPrintLnBold("^1Please Wait Before Starting Another Vote");

            break;

			case "-no": // if u dont get this ur dumb
				if(level.votingnow) // if theres a vote in progress
				{
					if(!player.hasvoted) // if the player has not voted yet
					{
						player.hasvoted = true;
						level.voteno++; // total amount of no votes gets increased
						player IPrintLn("^1You Voted No");
					}
					else if(player.hasvoted)
					{
						player IPrintLn("^1You Already Voted");
					}
				}
				else if(!level.votingnow)
				{
					player IPrintLn("^1No Vote In Progress");
				}

            break;

			case "-yes": // same here
				if(level.votingnow) // if theres a vote in progress
				{
					if(!player.hasvoted) // if the player has not voted yet
					{
						player.hasvoted = true;
						level.voteyes++; // total amount of yes votes get increased
						player IPrintLn("^1You Voted Yes");
					}
					else if(player.hasvoted)
					{
						player IPrintLn("^1You Already Voted");
					}
				}
				else if(!level.votingnow)
				{
					player IPrintLn("^1No Vote In Progress");
				}

            break;

			case "-ttt": // tic tac toe so -ttt name
                if ( level.args[1] == "" )
                    continue;
                player1 = player;
                player2 = findPlayerByName( level.args[1] );
                if (isdefined(player1) && isdefined(player2))
                {
                    pos = player1 getorigin();
                    level thread scripts\codjumper\tictactoe::TicStart(pos, player1, player2, false);
                }
            break;

            case "-tttd":
                if ( level.args[1] == "" )
                    continue;
                player1 = player;
                player2 = findPlayerByName( level.args[1] );
                if (isdefined(player1) && isdefined(player2))
                {
                    pos = player1 getorigin();
                    level thread scripts\codjumper\tictactoe::TicStart(pos, player1, player2, true);
                }
            break;

            case "-tttend":
				if(isdefined(level.tttplayer1) || isdefined(level.tttplayer2))
                {
					if(player == level.tttplayer1 || player == level.tttplayer2)
                    level thread scripts\codjumper\tictactoe::endtttgame("force");
					else
					player IPrintLnBold("^1You Can't End Games You Aren't A Part Of");
				}
				else if(level.TicTacToe == true && !isdefined(level.tttplayer1) && !isdefined(level.tttplayer2))
				level thread scripts\codjumper\tictactoe::endtttgame("force");
            break;

			case "-top": // teleports player to top of barriers
				pos = player.origin;
				poser = PlayerPhysicsTrace((pos[0],pos[1],pos[2]+20000), pos);
				player setorigin(poser);
			break;

			case "-height": // starts the height hud
                player thread scripts\codjumper\heightcheck::Heightcheck();
            break;

			case "-heightstop": // stops the height hud
                player thread scripts\codjumper\heightcheck::Heightend();
            break;
		}
    }
}

votemap(votedmap, startplayer)
{
	if(!level.inprogress) // no vote in progress yet
	{
		foreach(player in level.players)
		player.hasvoted = false;

		cmdexec("say ^3[" + startplayer.name + "] ^7Started A Mapvote For Map ^1" + GetSubStr(votedmap, 0, 30));
		waitframe();
		cmdexec("say Use ^2-yes ^7/ ^1-no ^7To Vote");

		level.inprogress = true;
		level.voteyes = 0;
		level.voteno = 0;

		level.voteyes++;
		startplayer.hasvoted = true;

		map = mapname(tolower(votedmap));

		// holy shit what a ugly ass hud

		level.shadervotemap = createRectangle("LEFTTOP","center",-415,20,200,60,(0,0,1),"white",20,0.3);
		level.shadervotemap.archived = true;
		level.shadervotemap2 = createRectangle("LEFTTOP","center",-420,15,210,70,level.votecolor,"white",20,0.5);
		level.shadervotemap2.archived = true;

		level.counter = createServerFontString( "objective", 1);
		level.counter setPoint( "LEFT", "center", -410, 30 );
		level.counter.color = level.votecolor;
		level.counter.foreground = true;
		level.counter.label = &"Vote Map In Progress\nTime Remaining: ";
		level.counter.archived = true;

		level.maptext = createServerFontString( "objective", 1);
		level.maptext setPoint( "LEFT", "center", -410, 55 );
		level.maptext.color = level.votecolor;
		level.maptext.foreground = true;
		level.maptext.archived = true;

		if(map == "Unknown Map: ")
		level.maptext settext(map + GetSubStr(votedmap, 0, 16));
		else
		level.maptext settext(votedmap);

		level.yesnum = createServerFontString( "objective", 1);
		level.yesnum setPoint( "LEFT", "center", -410, 69 );
		level.yesnum.color = level.votecolor;
		level.yesnum.foreground = true;
		level.yesnum.label = &"Yes: ";
		level.yesnum.archived = true;

		level.nonum = createServerFontString( "objective", 1);
		level.nonum setPoint( "LEFT", "center", -360, 69 );
		level.nonum.color = level.votecolor;
		level.nonum.foreground = true;
		level.nonum.label = &"No: ";
		level.nonum.archived = true;

		level.ctime = level.votemaptime;

		if(level.players.size > 1) // this is to check if there are more then 2 player online i think it was
		{
		level.neededvotes = floor(level.players.size / 2 + 1); // if thats the case then more then half the players need to have voted yes
		}
		else
		level.neededvotes = 1; // if not then 1 vote is needed

		level.votingnow = true;
		waitframe();
		level thread trackvotes(); // updates the number of votes hud

		for ( i = level.ctime; i > 0; i-- ) // this handles the timer logic
		{
			level.counter setvalue(i);
			if ( i < 11 )
				foreach ( player in level.players )
					player PlayLocalSound( "ui_mp_timer_countdown" );
			wait 1;
		}
		level.counter setvalue(0);

		level thread CountingDown();

		wait 0.2;
		level notify("KillmeuWankermen");
		level checkvotes(votedmap, map);

		level.votingnow = false;

		level.counter destroy();
		level.maptext destroy();
		level.shadervotemap destroy();
		level.shadervotemap2 destroy();
		level.yesnum destroy();
		level.nonum destroy();

		//FOR LATER level.votingnow = false;
	}
}

CountingDown()
{
	for(level.votingtime = 90; level.votingtime > 0; level.votingtime--)
	{
		wait 1;
	}
}

trackvotes()
{
	level endon("KillmeuWankermen");
	level.nonum setvalue(0);
	level.yesnum setvalue(0);

	while(level.votingnow)
	{
		wait 0.05;
		level.nonum setvalue(level.voteno);
		level.yesnum setvalue(level.voteyes);
	}
}

checkvotes(votedmap, map)
{
	if(level.voteyes > level.voteno)
	{
		if(level.voteyes >= level.neededvotes)
		{
			iprintlnbold("^2Vote Passed");
			wait 1;
			iprintlnbold("Changing to " + votedmap + " In: 3");
			wait 1;
			iprintlnbold("Changing to " + votedmap + " In: 2");
			wait 1;
			iprintlnbold("Changing to " + votedmap + " In: 1");
			wait 1;
			if(map == "Unknown Map: ")
			{
				cmdexec("map " + votedmap);
			}
			else
			{
				cmdexec("map " + map);
			}
		}
		else
		iprintlnbold("^1Not Enough Votes");
	}
	else if(level.voteno > level.voteyes)
	{
		if(level.voteno >= level.neededvotes)
		{
			iprintlnbold("^1Vote Failed");
		}
		else
		iprintlnbold("^1Not Enough Votes");
	}
	else if(level.voteno == level.voteyes)
	{
		iprintlnbold("^3Vote Ended In A Tie");
	}
	level.inprogress = false;
}

mapname(map) // add mapnames here for custom maps etc, and yes eew giant switch case :D
{
    switch(map)
	{
    case "lockdown": return "mp_alpha";
    case "bootleg": return "mp_bootleg";
    case "mission": return "mp_bravo";
    case "carbon": return "mp_carbon";
    case "dome": return "mp_dome";
    case "downturn": return "mp_exchange";
    case "hardhat": return "mp_hardhat";
    case "interchange": return "mp_interchange";
    case "fallen": return "mp_lambeth";
    case "bakaara": return "mp_mogadishu";
    case "resistance": return "mp_paris";
    case "arkaden": return "mp_plaza2";
    case "outpost": return "mp_radar";
    case "seatown": return "mp_seatown";
    case "underground": return "mp_underground";
    case "village": return "mp_village";
    case "terminal": return "mp_terminal_cls";
    case "rust": return "mp_rust";
    case "highrise": return "mp_highrise";
    case "piazza": return "mp_italy";
    case "liberation": return "mp_park";
    case "overwatch": return "mp_overwatch";
    case "blackbox": return "mp_morningwood";
    case "sanctuary": return "mp_meteora";
    case "oasis": return "mp_qadeem";
    case "lookout": return "mp_restrepo_ss";
    case "getaway": return "mp_hillside_ss";
    case "erosion": return "mp_courtyard_ss";
    case "aground": return "mp_aground_ss";
    case "vortex": return "mp_six_ss";
    case "uturn": return "mp_burn_ss";
    case "intersection": return "mp_crosswalk_ss";
    case "decommission": return "mp_shipbreaker";
    case "offshore": return "mp_roughneck";
    case "gulch": return "mp_moab";
    case "boardwalk": return "mp_boardwalk";
    case "parish": return "mp_nola";
    case "favela": return "mp_favela";
    case "nuketown": return "mp_nuked";
    case "skidrow": return "mp_nightshift";
	case "showdown": return "mp_showdown_sh";
	case "galaxy": return "mp_galaxy";
	case "rats": return "mp_rats";
	case "quarry": return "mp_quarry";
	case "carnival": return "mp_abandon";
    default: return "Unknown Map: ";
    }
}

createRectangle(align,relative,x,y,width,height,color,shader,sort,alpha)    
{
	boxElem = level createserverFontString( "objective", 1);
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.sort = sort;
	boxElem.color = color;
	boxElem.alpha = alpha;
	boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem.HideWhenInMenu = false;
    boxElem setPoint(align, relative, x, y);
    return boxElem;
}

// Returns the player of the name passed in, if in the game. 0 if not.
findPlayerByName( name )
{
    foreach ( player in level.players )
	{
		//iprintln(name);
		//iprintln(player);
		if(issubstr(tolower(player.name), name))
		{
			return player;
		}
        //if ( player.name == name )
         //   return player;
    }
    return undefined;
}