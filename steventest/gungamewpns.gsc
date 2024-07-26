#include maps\mp\_utility;
#include common_scripts\utility;
#include common_scripts\_destructible;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;

init() {
    replacefunc(::giveRankXP, ::giveRankXP_edit);

    level.gun_guns[0]  = "iw5_ump45mw";    
    level.gun_guns[1]  = "iw5_thundergun";
    level.gun_guns[2]  = "iw5_rpgdragon";
    level.gun_guns[3]  = "iw5_r700";
    level.gun_guns[4]  = "iw5_mp40";
    level.gun_guns[5]  = "iw5_saug";
    level.gun_guns[6]  = "iw5_k7";
    level.gun_guns[7]  = "iw5_mp5k";            
    level.gun_guns[8]  = "iw5_cheytacheaven";            
    level.gun_guns[9]  = "iw5_arx160";
    level.gun_guns[10] = "iw5_pp2k";
    level.gun_guns[11] = "iw5_hk21";
    level.gun_guns[12] = "iw5_stakeout";
    level.gun_guns[13] = "iw5_h1de50";        
    level.gun_guns[14] = "iw5_dsr50";
    level.gun_guns[15] = "iw5_commando";
    level.gun_guns[16] = "iw5_raygunmk2";
    level.gun_guns[17] = "iw5_colt44";
    level.gun_guns[18] = "iw5_m27";
    level.gun_guns[19] = "iw5_h2aa12";
    level.gun_guns[20] = "iw5_ariar";
    level.gun_guns[21] = "iw5_an94";
    level.gun_guns[22] = "iw5_fang45";
    level.gun_guns[23] = "iw5_50gs";
    level.gun_guns[24] = "iw5_tac330";
    level.gun_guns[25] = "iw5_ak104";    
    level.gun_guns[26] = "iw5_1911"; 
    level.gun_guns[27] = "iw5_raygun";    
    level.gun_guns[28] = "iw5_vepr";    
    level.gun_guns[29] = "iw5_rpk";
    level.gun_guns[30] = "iw5_magnum";
    level.gun_guns[31] = "iw5_m40a3";
    level.gun_guns[32] = "iw5_rnma";
    level.gun_guns[33] = "iw5_reichsrevolver";
    level.gun_guns[34] = "iw5_blunderbuss";
    SetDynamicDvar( "scr_gun_scorelimit", level.gun_guns.size );
    registerScoreLimitDvar( level.gameType, level.gun_guns.size );
    
    setdvar( "disable_challenges", 1 ); 
}

giveRankXP_edit( type, value, weapon, sMeansOfDeath, challengeName ) {
    if(!isDefined(value))
        value = getScoreInfoValue(type);
        
    self thread xpPointsPopup(value, 0, (1, 1, 1), 0);
}