#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
//#include maps\mp\gametypes\_hud_message;

init()
{
 // we dont init anything here cause we start the script in voteformap
}

Heightend()
{
	// this just stops the entire hud and functions
	self notify("stoppingheight");

	self.above = undefined;
	self.HeightMeterVel = undefined;
	self.HeightMeterVelTop = undefined;

	if(isdefined(self.HeightMeter))	self.HeightMeter destroy();
	if(isdefined(self.HeightMeterTop))	self.HeightMeterTop destroy();
}

HeightCheckHud()
{
	// builds the ugly temporary hud that i never finished lol
	self.HeightMeter = self createFontString( "hudbig", 1);
	self.HeightMeter setPoint( "LEFT", "Center", 150, 200 );
	self.HeightMeter.label = &"";
	self.HeightMeter.color = (1,0,0);
	self.HeightMeter setvalue(0);
	self.HeightMeterVel = 0;

	self.HeightMeterTop = self createFontString( "hudbig", 1);
	self.HeightMeterTop setPoint( "RIGHT", "Center", 130, 200 );
	self.HeightMeterTop.label = &"";
	self.HeightMeterTop.color = (0,1,0);
	self.HeightMeterTop setvalue(0);
	self.HeightMeterVelTop = 0;
}

HeightCheckPoint()
{
	self endon("disconnect");
	self endon("stoppingheight");

	self  notifyonplayercommand("newheight", "+reload"); // pressing r while the function is active sets the height ur trying to reach

	for(;;)
	{
		self waittill("newheight"); // when u press button
		self.HeightMeterTop setvalue(floor(self.origin[2])+60); // sets the value and corrects for the players height
		self.HeightMeterVelTop = self.origin[2]+60; // i dont remember lol
		wait 0.5;
	}
}

HeightResetPoint()
{
	self endon("disconnect");
	self endon("stoppingheight");

	self  notifyonplayercommand("resetheight", "+activate"); // resets height when u press use (load position)

	for(;;)
	{
		self waittill("resetheight"); // wait for button
		self.above = false; // resets if u got above ur set value
		self.HeightMeterVel = 0; // resets height
		self.HeightMeter setvalue(self.HeightMeterVel); // sets the value to 0
		self.HeightMeter.color = (1,0,0); // changes color to red
	}
}

Heightcheck()
{
	self endon("disconnect");
	self endon("stoppingheight");
	
	if(!isdefined(self.HeightMeter)) // if isnt used yet then start the functions
	{
		self HeightCheckHud();
		self thread HeightCheckPoint();
		self thread HeightResetPoint();
		self.above = false;
	}
	else
		return;
	
	for(;;)
    {
        waitframe();

		if(self.HeightMeterVel < self.origin[2]+60) //self.heightmetervel is 0 at first and gets set to your total height dont know why i called it vel cause it has nothing to do with velocity
		{// this also only goes higher then your previous height, so the value never goes down untill u load
			self.HeightMeterVel = self.origin[2]+60; // sets it to your current height
			self.HeightMeter setvalue(floor(self.HeightMeterVel)); // adjusts the hud according
		}

		if(self.HeightMeterVel >= self.HeightMeterVelTop && !self.above) // if current height is higher then the height u wanted that u set before and u are not above yet
		{
			self.above = true; // u are above so it only calls this once
			self.HeightMeter.color = (0,1,0); // changes the color to green to show that u got the right height
		}
    }
}

