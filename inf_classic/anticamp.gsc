#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
	level.AnticampExplosive = loadfx("explosions/tanker_explosion");
	level thread watchAntiCamp();
}

watchAntiCamp() {
	level endon("game_ended");

	for(;;) {
		level waittill("anticamp_start", player);
		player thread antiCampStart();
	}
}


antiCampStart() {
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	level endon("game_ended");
	self.antiCampAttempts = 0;

	wait 7.5;

	weewarns = 0;

	while(true)
	{
		oldorg = self.origin;
		wait 0.75;
		if(distance(oldorg, self.origin) < 100)
		{
			weewarns++;
			if(weewarns == 5)
			{
				if(self.antiCampAttempts < 3)
				{
					self iprintlnbold("^1You Have To Run Or You Will Die!");
					self PlayLeaderDialog("new_positions");
				}
				else
				{
					self iprintlnbold("^1You Should Have Kept Running!");
					self explodePlayer();
				}
				self.antiCampAttempts++;
				weewarns = 0;
			}
		}
		else
		{
			weewarns = 0;
		}

	}
}

explodePlayer() {
	rot = RandomIntRange(0, 360);
	explosionEffect = spawnFx(level.AnticampExplosive, self.Origin + (0, 0, 50), (0, 0, 1), (Cos(rot), Sin(rot), 0));
	triggerFx(explosionEffect);

	self _suicide();

	playSoundAtPos(self.Origin, "exp_suitcase_bomb_main");
}

GetTeamVoicePrefix(teamRef) {
	return TableLookup("mp/factionTable.csv", 0, teamRef, 7);
}

PlayLeaderDialog(sound) {
	name = GetTeamVoicePrefix(GetMapCustom("allieschar"));
	self PlayLocalSound(name + "1mc_" + sound);
}
