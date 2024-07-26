Main() {
    InitChatCommands();
}

InitChatCommands() {
    level.commands_prefix = "!";
    level.commands = [];

    InitCommands();

    level thread ChatListener();
}

InitCommands() {
    CreateCommand("help", "text", ["Type " + level.commands_prefix + "commands to get a list of commands", "Type " + level.commands_prefix + "help followed by a command name to see how to use it"]);
    CreateCommand("km", "function", ::SuicideCommand);
    CreateCommand("fps", "function", ::FpsCommand);
    CreateCommand("3rd", "function", ::ThirdPersonCommand);
    CreateCommand("discord", "function", ::DiscordCommand);
}

CreateCommand(commandName, commandType, commandValue, commandHelp) {
    level.commands[commandName]["type"] = commandType;

    if (IsDefined(commandHelp))
        level.commands[commandName]["help"] = commandHelp;

    if (commandType == "text")
        level.commands[commandName]["text"] = commandValue;
    else if (commandType == "function")
        level.commands[commandName]["function"] = commandValue;
}

ChatListener() {
    while (true)  {
        level waittill("say", message, player);

        if(message.size == 0)
        	continue;

        if (message[0] == level.commands_prefix)
            DoCommand(message, player);
    }
}

DoCommand(message, player) {
    commandArray = [];
    commandArray = StrTok(message, " "); // Separate the command by space character. Example: ["!map", "mp_dome"]

    command = commandArray[0]; // The command as text. Example: !map

    args = []; // The arguments passed to the command. Example: ["mp_dome"]

    for (i = 1; i < commandArray.size; i++)
        args = AddElementToArray(args, commandArray[i]);

    if (IsDefined(level.commands) && level.commands.size > 0)
    {
        // commands command
        if (command == level.commands_prefix + "commands")
        {
            player thread TellPlayer(GetArrayKeys(level.commands), 2, true);
        }
        else
        {
            // help command
            if (command == level.commands_prefix + "help" && !IsDefined(level.commands["help"]) || command == level.commands_prefix + "help" && IsDefined(level.commands["help"]) && args.size >= 1)
            {
                if (args.size < 1)
                {
                    player thread TellPlayer(NotEnoughArgsError(1), 1.5);
                }
                else
                {
                    commandValue = level.commands[args[0]];

                    if (IsDefined(commandValue))
                    {
                        commandHelp = commandValue["help"];

                        if (IsDefined(commandHelp))
                        {
                            player thread TellPlayer(commandHelp, 1.5);
                        }
                    }
                }
            }
            // any other command
            else
            {
                commandName = GetSubStr(command, 1);
                commandValue = level.commands[commandName];

                if (IsDefined(commandValue))
                {
                    if (commandValue["type"] == "text")
                    {
                        player thread TellPlayer(commandValue["text"], 2);
                    }
                    else if (commandValue["type"] == "function")
                    {
                        error = player [[commandValue["function"]]](args);

                        if (IsDefined(error))
                        {
                            player thread TellPlayer(error, 1.5);
                        }
                    }
                }

            }
        }
    }//end
}


TellPlayer(messages, waitTime, isCommand)
{
    for (i = 0; i < messages.size; i++)
    {
        message = messages[i];

        if (IsDefined(isCommand) && isCommand)
        {
            message = level.commands_prefix + message;
        }

        self tell(message);

        if (i < (messages.size - 1)) // Don't unnecessarily wait after the last message has been displayed
        {
            wait waitTime;
        }
    }
}



/* Command functions section */

SuicideCommand(args) {
	self notify("suicide_action");
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

ThirdPersonCommand(args){
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

	if(!isdefined(self.thirdperson_cross)) {
		self.thirdperson_cross = newclienthudelem(self);
		self.thirdperson_cross.horzalign = "center";
		self.thirdperson_cross.vertalign = "middle";
		self.thirdperson_cross.x = -12;
		self.thirdperson_cross.y = -12;
		self.thirdperson_cross.color = (1, 1, 1);
		self.thirdperson_cross.alpha = 1;
		self.thirdperson_cross setshader("reticle_center_cross", 24, 28);
	}

    self SetClientDvar("cg_thirdPerson", 1);
    self SetClientDvar("cg_thirdPersonRange", 80);
    self iprintln("^7Third person ^5Enabled");
}

disable3rd(){
    self.has3rdEnabled = false;

    if(isdefined(self.thirdperson_cross))
    	self.thirdperson_cross destroy();

    self SetClientDvar("cg_thirdPerson", 0);
    self iprintln("^7Third person ^5Disabled");
}

enableFps(){
    self.hasFpsEnabled = true;
    self SetClientDvar("r_fog",0);
    self SetClientDvar("fx_drawclouds",0);
    self SetClientDvar("fx_enable",0);
    self SetClientDvar("r_lightmap", 3);
    self iprintln("^7FPS ^5enabled");
}

disableFps(){
    self.hasFpsEnabled = false;
    self SetClientDvar("r_fog",1);
    self SetClientDvar("fx_drawclouds",1);
    self SetClientDvar("fx_enable",1);
    self SetClientDvar("r_lightmap", 1);
    self iprintln("^7FPS ^5disabled");
}

fpsThread(){
    level endon("game_ended");
    self endon("disconnect");
    self endon("disableFps");

    self iprintln("Press ^53 ^7to enable/disable ^5FPS");

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

    self iprintln("Press ^53 ^7to enable/disable ^5Third person mode");


    for(;;){
        self notifyonplayercommand("toggle3rd", "+actionslot 3");
        self waittill("toggle3rd");

        if(self has3rdEnabled()){
            self disable3rd();
        } else {
            self enable3rd();
        }
        wait .2;
    }
}


has3rdEnabled(){
    return isDefined(self.has3rdEnabled) && self.has3rdEnabled == true;
}

hasFpsEnabled(){
    return isDefined(self.hasFpsEnabled) && self.hasFpsEnabled == true;
}

DiscordCommand(args){
    self iprintln("^5discord.gg/GilletteClan");
}

NotEnoughArgsError(minimumArgs) {
    return ["Not enough arguments supplied", "At least " + minimumArgs + " argument expected"];
}

AddElementToArray(array, element) {
    array[array.size] = element;
    return array;
}











