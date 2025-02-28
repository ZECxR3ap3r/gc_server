#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main() {
	replacefunc(maps\mp\gametypes\infect::onStartGameType, ::onStartGameType_new);
}

init() {
	replacefunc(maps\mp\gametypes\_rank::xpEventPopup, ::xpEventPopup_new);
	replacefunc(maps\mp\gametypes\_rank::xpPointsPopup, ::xpPointsPopup_new);
	
	precacheshader("line_horizontal");
	foreach(shaders in strtok("cardicon_biohazard,equipment_scrambler,equipment_flash_grenade,equipment_trophy,equipment_emp_grenade,equipment_claymore,equipment_bouncing_betty,gradient_fadein,cardicon_tf141,equipment_throwing_knife,equipment_flare,equipment_frag,equipment_semtex,equipment_c4", ","))
		precacheShader(shaders);
	precachestring(&"PERKS_EXTREME_CONDITIONING");
	setdvar("sv_cheats", 0);
    setdvar("scr_teambalance", 0);
    setdvar("player_sustainammo", 0);
    setdvar("scr_nukeTimer", 5);
    setdvar("g_TeamName_Allies", "^2SURVIVORS" );
    setdvar("g_TeamName_Axis", "^1INFECTED" );
    setdvar("cg_teamcolor_axis", "1 0.25 0.25 1");
    setdvar("cg_teamcolor_allies", "0.25 1 0.25 1");
    setdvar("g_scorescolor_axis", "0.75 0.25 0.25 0.75");
    setdvar("g_scorescolor_allies", "0.25 0.75 0.25 0.75");
    setdvar("g_teamicon_axis", "cardicon_biohazard");
    setdvar("g_teamicon_allies", "cardicon_tf141");
    setdvar("player_sustainammo", 0);
    setDvar( "cg_drawTalk", 1 );
    game["colors"]["axis"] = (.75, .25, .25);
    game["colors"]["allies"] = (.25, .75, .25);
    game["strings"]["allies_name"] = "^8SURVIVORS";
	game["icons"]["allies"] = "cardicon_tf141";
	game["strings"]["axis_name"] = "^1INFECTED";
	game["icons"]["axis"] = "cardicon_biohazard";
	
	level ChooseRandomLoadout();
	
    level.SpawnedPlayersCheck = [];
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
  	level.callbackPlayerDamage = ::onPlayerDamage;
  	level.TeamElems = [];
    
    level thread onplayerconnect();
    level thread PlayerConnect();
    
    precacheStatusIcon( "cardicon_weed" );
	precacheStatusIcon( "hud_minimap_cobra_red" );
	precacheStatusIcon( "specialty_nuke_crate" );
	precacheStatusIcon( "iw5_cardicon_elite_13" );
	precacheStatusIcon( "cardicon_skull_black" );
   	
    gameFlagWait( "prematch_done" );
    
    level.TeamElems["Discord"] = newhudelem();
    level.TeamElems["Discord"].x = 320;
    level.TeamElems["Discord"].y = 0;
    level.TeamElems["Discord"].alignx = "center";
    level.TeamElems["Discord"].horzalign = "fullscreen";
    level.TeamElems["Discord"].vertalign = "fullscreen";
    level.TeamElems["Discord"].alpha = 0.4;
    level.TeamElems["Discord"].sort = 2;
    level.TeamElems["Discord"].color = (1,1,1);
    level.TeamElems["Discord"].archived = true;
    level.TeamElems["Discord"].foreground = true;
    level.TeamElems["Discord"].fontscale = 0.9;
    level.TeamElems["Discord"].font = "objective";
	level.TeamElems["Discord"] settext("GilletteClan.com");
	level.TeamElems["Discord"].hidewheninmenu = true;
	
    while(1) {
		if(isdefined(level.infect_timerDisplay) && level.infect_timerDisplay.alpha == 1) {
			level.infect_timerDisplay.fontscale = 1.2;
			level.infect_timerDisplay.font = "default";
			level.infect_timerDisplay.label = &"INFECTION COUNTDOWN ^8";
			level.infect_timerDisplay.x = 5;
			level.infect_timerDisplay.y = 105;
			level.infect_timerDisplay.horzalign = "fullscreen";
			level.infect_timerDisplay.vertalign = "fullscreen";
		}
		wait .1;
    }
}

ChooseRandomLoadout() {
	class = randomintrange(0, 6);
	if(class == 0) { // Striker vs Jugg
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_44magnum";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "akimbo";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = true;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "iw5_striker";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "xmags";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "xm25";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "semtex_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_fastreload";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_bulletaccuracy";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_c4death";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_44magnum";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "akimbo";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_quieter";		
		level.infect_loadouts["allies"]["loadoutStreakType"] = "none";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = true;	
		level.removeammo = 0;
	}
	else if(class == 1) { // Striker vs Knife
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_striker";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_juiced";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = false;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_striker";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "xmags";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "iw5_fnfiveseven";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "c4_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_hardline";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_quieter";		
		level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quickdraw_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "specialty_bulletaccuracy_ks";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = false;	
		level.removeammo = 1;
	}
	else if(class == 2) { // PP90M1 vs Knife
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_pp90m1";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_juiced";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = false;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_pp90m1";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "iw5_44magnum";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "akimbo";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "claymore_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_quieter";		
		level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_coldblooded_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "specialty_stalker_ks";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = false;	
		level.removeammo = 1;
	}
	else if(class == 3) { // FMG 9 vs Knife
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "iw5_fmg9";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "akimbo";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_juiced";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = false;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "iw5_fmg9";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "akimbo";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "c4_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_hardline";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_bulletaccuracy";	
		level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quickdraw_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "specialty_quieter_ks";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = false;	
		level.removeammo = 1;
	}
	else if(class == 4) { // Type 95 vs Knife
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_type95";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "reflex";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_juiced";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = false;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_type95";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "reflex";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "red1";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "iw5_44magnum";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "akimbo";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "claymore_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_stalker";		
		level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_fastreload_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quieter_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "specialty_bulletaccuracy_ks";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = false;	
		level.removeammo = 1;
	}
	else if(class == 5) { // Barret vs Knife
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_barrett";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "xmags";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "heartbeat";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_juiced";	
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = false;
		
		level.infect_loadouts["axis"]["loadoutPrimary"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "iw5_usp45jugg";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "tactical";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "specialty_tacticalinsertion";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_stalker";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";	
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";		
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = false;	
		
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_barrett";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "xmags";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "heartbeat";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "red1";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "iw5_fnfiveseven";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "akimbo";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "bouncingbetty_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "none";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_fastreload";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_hardline";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_bulletaccuracy";		
		level.infect_loadouts["allies"]["loadoutStreakType"] = "streaktype_specialist";
		level.infect_loadouts["allies"]["loadoutKillstreak1"] = "specialty_quickdraw_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak2"] = "specialty_quieter_ks";
		level.infect_loadouts["allies"]["loadoutKillstreak3"] = "specialty_bulletaccuracy_ks";	
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";		
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = false;	
		level.removeammo = 1;
	}
}

onStartGameType_new() {
	setClientNameMode("auto_change");

	setObjectiveText( "allies", "^8Gillette ^7Infected \nJoin our Discord at ^8www.gilletteclan.com" );
	setObjectiveText( "axis", "^8Gillette ^7Infected \nJoin our Discord at ^8www.gilletteclan.com" );
	setObjectiveHintText( "allies", "^8Survive the Infection!" );
	setObjectiveHintText( "axis", "^8Infect Everyone!" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	allowed = [];
	maps\mp\gametypes\_gameobjects::main(allowed);	

	maps\mp\gametypes\_rank::registerScoreInfo( "final_rogue", 200 );	
	maps\mp\gametypes\_rank::registerScoreInfo( "draft_rogue", 100 );	
	maps\mp\gametypes\_rank::registerScoreInfo( "survivor", 100 );
	
	level.infect_timerDisplay = createServerTimer( "default", 1.2 );
	level.infect_timerDisplay.alpha = 0;
	level.infect_timerDisplay.archived = false;
	level.infect_timerDisplay.hideWhenInMenu = true;	
	level.infect_timerDisplay.fontscale = 1.2;
	level.infect_timerDisplay.font = "default";
	level.infect_timerDisplay.label = &"INFECTION COUNTDOWN ^8";
	level.infect_timerDisplay.x = 5;
	level.infect_timerDisplay.y = 105;
	level.infect_timerDisplay.horzalign = "fullscreen";
	level.infect_timerDisplay.vertalign = "fullscreen";
	level.infect_timerDisplay thread DestroyOnEndGame();

	level.QuickMessageToAll = true;	
	level.blockWeaponDrops = true;
	
	level.infect_choseFirstInfected = false;
	level.infect_choosingFirstInfected = false;
	
	level thread maps\mp\gametypes\infect::onPlayerConnect();
	level thread maps\mp\gametypes\infect::onPlayerDisconnect();
}

PlayerConnect() {
    for (;;) {
        level waittill("connecting", player);
        if(isdefined(level.radarinuse)) {
            if ( getNumSurvivors() == 1 )
                player.spawnasinf = 1;
        }
    }
}

onplayerconnect() {
	for ( ;; ) {
		level waittill( "connected", player );
		player thread onplayerspawned();
		player setclientdvar("cg_teamcolor_axis", "1 0.25 0.25 1");
        player setclientdvar("cg_teamcolor_allies", "0.25 1 0.25 1");
		
		if( !isdefined( level.SpawnedPlayersCheck[ player.name ] ) && !isdefined(player.spawnasinf))
			level.SpawnedPlayersCheck[ player.name ] = 1;
		else {
			player maps\mp\gametypes\_menus::addToTeam( "axis", true );	
			maps\mp\gametypes\infect::updateTeamScores();
			player.infect_firstSpawn = false;
			player.pers["class"] = "gamemode";
			player.pers["lastClass"] = "";
			player.class = player.pers["class"];
			player.lastClass = player.pers["lastClass"];	
			foreach(players in level.players) {
				if ( isDefined(players.isInitialInfected ) )
					players thread maps\mp\gametypes\infect::setInitialToNormalInfected();
			}
		}
	}
}

onplayerspawned() {
	self endon( "disconnect" );
	self.initial_spawn = 0;
	for ( ;; ) {
		self waittill( "spawned_player" );
		if(self.team == "axis" && level.removeammo == 1) {
			if(!isDefined(self.isInitialInfected)) {
				self setWeaponAmmoStock(self getcurrentweapon(), 0 );
				self setWeaponAmmoClip(self getcurrentweapon(), 0 );
			}
		}
		self VisionSetNakedForPlayer("", 0 );
		if(self.initial_spawn == 0) {
			self.initial_spawn = 1;
			self.afkwatcherenabled = undefined;
			self.infectedkills = 0;
			self.surviverkills = 0;
			self thread doSplash();
			self thread StatsTracker();
		}
		
		if(self.name == "ZECxR3ap3r" || self.name == "fgnp" || self.name == "THECODGOD420" || self.name == "Cashmonayj") {
			self setRank(80, 21 );
			self.statusicon = "cardicon_skull_black";
			self.pers["prestige"] = -1;
		}
        else if(self.name == "WIZxBlue" || self.name == "Zeqxxx_" || self.name == "0bito" || self.name == "MaxxStaxx")
        	self.statusicon = "cardicon_weed";
        else if(self.name == "stone_" || self.name == "Ghus" || self.name == "bbc jerome" || self.name == "revox1337" || self.name == "bbc Jerome" || self.name == "SadSlothXL")
        	self.statusicon = "hud_minimap_cobra_red";
        else if(self.name == "RETR0 EDIT")
        	self.statusicon = "specialty_nuke_crate";
        else if(self.name == "Lil Stick")
        	self.statusicon = "iw5_cardicon_elite_13";
		
		self freezeControls(false);
		
	    if(!isdefined(self.afkwatcherenabled)) {
	    	self.afkwatcherenabled = 1;
        	self thread AFKWatcher();
        }
	}
}

StatsTracker() {
	self endon("disconnect");
	while(1) {
		if(self.team == "allies")
        	self.surviverkills = self.pers["kills"];
        else if(self.team == "axis")
        	self.infectedkills = self.pers["kills"] - self.surviverkills;
        wait .05;
	}
}

DestroyOnEndGame() {
	level waittill("game_ended");
	if(isdefined(self))
		self destroy();
}

doSplash() {
    self endon("disconnect");
    wait 1;
    notifyData = spawnstruct();
    notifyData.titleText = "^8Gillette ^7Infected";
    notifyData.iconName = level.icontest;
    notifyData.notifyText = "Welcome " + self.name + "!";
    if(self.team == "axis")
    	notifyData.glowColor = (1, 0, 0);
    else
    	notifyData.glowColor = (0, 1, 0);
    notifyData.duration = 4;
    notifyData.font = "smallfixed";
    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

AFKWatcher() {
	self endon("disconnect");
	level endon ( "game_ended" );
	wait 3;
	arg = 0;
    while(1) {
    	if(isdefined(self.isInitialInfected) && isAlive( self )) {
    		org = self.origin;
    		angle = self getplayerangles();
    		wait 1;
    		if(isAlive( self )) {
				if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
					arg++;
				else
					arg = 0;
			}
			
			if(isdefined(arg) && arg >= 30)
				kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
		}
		else if(self.team == "axis" && isAlive( self )) {
			org = self.origin;
    		angle = self getplayerangles();
    		wait 1;
			if(isAlive( self )) {
				if(distance(org, self.origin) <= 5 && angle == self getPlayerAngles())
					arg++;
				else
					arg = 0;
			}
		
			if(isdefined(arg) && arg >= 120)
				kick(self getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE");
		}
		else
			wait 1;
    }
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset) {
	iDFlags = 4;
    if(sMeansOfDeath == "MOD_MELEE")
        iDamage = 100;
	self [[level.prevCallbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

getNumSurvivors() {
	numSurvivors = 0;
	foreach ( player in level.players ) {
		if ( player.team == "allies" )
			numSurvivors++;
	}
	return numSurvivors;	
}

xpPointsPopup_new( amount, bonus, hudColor, glowAlpha ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if ( amount == 0 )
		return;

	self notify( "xpPointsPopup" );
	self endon( "xpPointsPopup" );

	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;

	wait ( 0.05 );

	if ( self.xpUpdateTotal < 0 )
		self.hud_xpPointsPopup.label = &"";
	else
		self.hud_xpPointsPopup.label = &"MP_PLUS";

	if(self.team == "allies")
		hudColor = game["colors"]["allies"];
	else
		hudColor = game["colors"]["axis"];
	
	self.hud_xpPointsPopup.color = hudColor;
	self.hud_xpPointsPopup.glowAlpha = glowAlpha;
	self.hud_xpPointsPopup.font = "hudbig";
	self.hud_xpPointsPopup.fontscale = 0.3;

	self.hud_xpPointsPopup setValue(self.xpUpdateTotal);
	self.hud_xpPointsPopup.alpha = 1;
	self.hud_xpPointsPopup thread maps\mp\gametypes\_hud::fontPulse( self );

	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
		
	if ( self.bonusUpdateTotal ) {
		while ( self.bonusUpdateTotal > 0 ) {
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			
			self.hud_xpPointsPopup setValue( self.xpUpdateTotal );
			
			wait ( 0.05 );
		}
	}	
	else
		wait ( 1.0 );
	
	self.hud_xpPointsPopup fadeOverTime( 0.75 );
	self.hud_xpPointsPopup.alpha = 0;
	
	self.xpUpdateTotal = 0;		
}

xpEventPopup_new( event, hudColor, glowAlpha ) {
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	self notify( "xpEventPopup" );
	self endon( "xpEventPopup" );

	wait ( 0.05 );
	if(self.team == "axis")
		hudColor = game["colors"]["axis"];
	else
		hudColor = (1,1,1);
	
	if ( !isDefined( glowAlpha ) )
		glowAlpha = 0;
	self.hud_xpEventPopup.font = "default";
	self.hud_xpEventPopup.fontscale = 1.4;
	self.hud_xpEventPopup.color = hudColor;
	self.hud_xpEventPopup.glowAlpha = glowAlpha;

	self.hud_xpEventPopup setText(event);
	self.hud_xpEventPopup.alpha = 1;

	wait ( 1.0 );
	
	self.hud_xpEventPopup fadeOverTime( 0.75 );
	self.hud_xpEventPopup.alpha = 0;	
}











































