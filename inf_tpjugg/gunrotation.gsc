#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    replacefunc(maps\mp\gametypes\_weapons::mayDropWeapon, ::mayDropWeaponReplace);

    if (GetDvar("g_gametype") == "infect") {
        level.ChangeInterval = 30;
        level.Secondary = "iw5_p99_mp_akimbo";
        level.NextPrimary = "";
        level.PrimaryFullName = "";
        level.GlobalCurrentGun = "";

        init_Weapons();

        level thread rotateGuns();
    }
}


rotateGuns() {
    level endon("game_ended");
    level waittill("prematch_over");

    x = 4;
    y = 110;

    level.PrimaryFullName = level.Weapons[randomInt(level.Weapons.size)];
    passedTime = 30;

    while(1) {
        passedTime -= 1;

        if(passedTime == 0) {
            passedTime = 30;

            foreach(player in level.players) {
            	if(player.team == "allies") {
                	player giveWeapon(level.PrimaryFullName);
                    player giveStartAmmo(level.PrimaryFullName);
                    if(IsSubStr(level.PrimaryFullName, "aa12") )
                        player setweaponammostock(level.PrimaryFullName, 32);
                        
                    if(!player isUsingRemote() && player getcurrentweapon() != "none" && (player getcurrentweapon() == level.GlobalCurrentGun || player getcurrentweapon() == "alt_"+level.GlobalCurrentGun) || player.hadgunsrotated == 0)
                        player switchtoweapon(level.PrimaryFullName);
                    else if(player isusingremote() || player getcurrentweapon() == "none")
                        player.saved_lastWeapon = "iw5_mp7_mp_silencer";

                    if(isDefined(player.hadgunsrotated) && player.hadgunsrotated == 0) {
                        player TakeWeapon(player.primaryWeapon);
                        player TakeWeapon(player.secondaryWeapon);
                        player SetPerk("specialty_fastreload", 1, 0);
                        player SetPerk("specialty_quickswap", 1, 0);
                    }
                    else {
                    	player TakeWeapon(level.GlobalCurrentGun);
                        player TakeWeapon(level.Secondary);

                        if(player.primaryWeapon == "iw5_usp45jugg_mp" && player.primaryWeapon == "iw5_riotshieldjugg_mp") {
                        	player TakeWeapon("iw5_usp45jugg_mp");
                            player TakeWeapon("iw5_riotshieldjugg_mp");
                            player SetPerk("specialty_fastreload", 1, 0);
                            player SetPerk("specialty_quickswap", 1, 0);
                        }
                        if(player.primaryWeapon ==  "iw5_m60jugg_mp" && player.primaryWeapon == "iw5_mp412jugg_mp") {
                            player TakeWeapon("iw5_m60jugg_mp");
                            player TakeWeapon("iw5_mp412jugg_mp");
                            player SetPerk("specialty_fastreload", 1, 0);
                            player SetPerk("specialty_quickswap", 1, 0);
                        }
                        if(player.primaryWeapon == "iw5_g36c_mp_m320_reflex" && player.primaryWeapon == "iw5_pp90m1_mp") {
                            player TakeWeapon("iw5_g36c_mp_m320_reflex");
                            player TakeWeapon("iw5_pp90m1_mp");
                            player SetPerk("specialty_fastreload", 1, 0);
                            player SetPerk("specialty_quickswap", 1, 0);
                        }
                    }

                    player.hadgunsrotated = 1;
                }
            }

            level.GlobalCurrentGun = level.PrimaryFullName;

            while(1) {
                level.PrimaryFullName = level.Weapons[randomInt(level.Weapons.size)];

                if(get_weapon_name_conv(level.GlobalCurrentGun) != get_weapon_name_conv(level.PrimaryFullName) && level.PrimaryFullName != level.Secondary)
                	break;

                wait .05;
            }
        }
        else {
            if(passedtime < 4) {
                foreach(player in level.players) {
            	    if(player.team == "allies")
                        player iPrintLnBold("Next Gun ^8" + get_weapon_name_conv(level.PrimaryFullName) + "^7 in ^8" + passedtime);
                }
            }
        }

        wait 1;
    }
}

HadGunsRotated(player) {
    if (isDefined(player.hadgunsrotated) && player.hadgunsrotated != 0)
        return 1;
    else
        return 0;
}

inArray(array, text) {
    for(i=0; i<array.size; i++) {
        if(array[i] == text)
          return 1;
    }
    return 0;
}

init_Weapons() {
    level.Weapons= [];

    level.Weapons[level.Weapons.size] = "iw5_acr_mp_camo01";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_reflex_camo02";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_silencer_camo03";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_m320_camo04";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_acog_camo05";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_heartbeat_camo06";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_eotech_camo07";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_shotgun_camo08";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_hybrid_camo09";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_xmags_camo10";
    level.Weapons[level.Weapons.size] = "iw5_acr_mp_thermal_camo11";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_camo12";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_reflex_camo13";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_silencer_camo01";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_m320_camo02";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_acog_camo03";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_heartbeat_camo04";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_eotech_camo05";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_shotgun_camo06";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_hybrid_camo07";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_xmags_camo08";
    level.Weapons[level.Weapons.size] = "iw5_type95_mp_thermal_camo09";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_camo10";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_reflex_camo11";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_silencer_camo12";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_gl_camo13";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_acog_camo01";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_heartbeat_camo02";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_eotech_camo03";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_shotgun_camo04";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_hybrid_camo05";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_xmags_camo06";
    level.Weapons[level.Weapons.size] = "iw5_m4_mp_thermal_camo07";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_camo08";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_reflex_camo09";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_silencer_camo10";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_gp25_camo11";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_acog_camo12";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_heartbeat_camo13";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_eotech_camo01";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_shotgun_camo02";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_hybrid_camo03";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_xmags_camo04";
    level.Weapons[level.Weapons.size] = "iw5_ak47_mp_thermal_camo05";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_camo06";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_reflex_camo07";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_silencer_camo08";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_gl_camo09";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_acog_camo10";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_heartbeat_camo11";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_eotech_camo12";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_shotgun_camo13";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_hybrid_camo01";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_m16_mp_thermal_camo03";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_camo04";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_reflex_camo05";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_silencer_camo06";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_m320_camo07";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_acog_camo08";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_heartbeat_camo09";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_eotech_camo10";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_shotgun_camo11";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_hybrid_camo12";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_xmags_camo13";
    level.Weapons[level.Weapons.size] = "iw5_mk14_mp_thermal_camo01";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_camo02";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_reflex_camo03";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_silencer_camo04";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_m320_camo05";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_acog_camo06";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_heartbeat_camo07";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_eotech_camo08";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_shotgun_camo09";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_hybrid_camo10";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_xmags_camo11";
    level.Weapons[level.Weapons.size] = "iw5_g36c_mp_thermal_camo12";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_camo13";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_reflex_camo01";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_silencer_camo02";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_m320_camo03";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_acog_camo04";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_heartbeat_camo05";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_eotech_camo06";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_shotgun_camo07";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_hybrid_camo08";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_xmags_camo09";
    level.Weapons[level.Weapons.size] = "iw5_scar_mp_thermal_camo10";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_camo11";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_reflex_camo12";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_silencer_camo13";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_m320_camo01";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_acog_camo02";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_heartbeat_camo03";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_eotech_camo04";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_shotgun_camo05";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_hybrid_camo06";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_xmags_camo07";
    level.Weapons[level.Weapons.size] = "iw5_fad_mp_thermal_camo08";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_camo09";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_reflex_camo10";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_silencer_camo11";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_m320_camo12";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_acog_camo13";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_heartbeat_camo01";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_eotech_camo02";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_shotgun_camo03";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_hybrid_camo04";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_xmags_camo05";
    level.Weapons[level.Weapons.size] = "iw5_cm901_mp_thermal_camo06";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_camo07";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_reflexsmg_camo08";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_silencer_camo09";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_rof_camo10";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_acogsmg_camo11";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_eotechsmg_camo12";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_hamrhybrid_camo13";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_xmags_camo01";
    level.Weapons[level.Weapons.size] = "iw5_mp5_mp_thermalsmg_camo02";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_camo03";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_reflexsmg_camo04";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_silencer_camo05";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_rof_camo06";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_acogsmg_camo07";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_eotechsmg_camo08";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_hamrhybrid_camo09";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_xmags_camo10";
    level.Weapons[level.Weapons.size] = "iw5_p90_mp_thermalsmg_camo11";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_camo12";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_reflexsmg_camo13";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_silencer_camo01";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_rof_camo02";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_acogsmg_camo03";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_eotechsmg_camo04";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_hamrhybrid_camo05";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_xmags_camo06";
    level.Weapons[level.Weapons.size] = "iw5_m9_mp_thermalsmg_camo07";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_camo08";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_reflexsmg_camo09";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_silencer_camo10";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_rof_camo11";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_acogsmg_camo12";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_eotechsmg_camo13";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_hamrhybrid_camo01";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_pp90m1_mp_thermalsmg_camo03";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_camo04";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_reflexsmg_camo05";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_silencer_camo06";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_rof_camo07";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_acogsmg_camo08";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_eotechsmg_camo09";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_hamrhybrid_camo10";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_xmags_camo11";
    level.Weapons[level.Weapons.size] = "iw5_ump45_mp_thermalsmg_camo12";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_camo13";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_reflexsmg_camo01";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_silencer_camo02";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_rof_camo03";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_acogsmg_camo04";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_eotechsmg_camo05";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_hamrhybrid_camo06";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_xmags_camo07";
    level.Weapons[level.Weapons.size] = "iw5_mp7_mp_thermalsmg_camo08";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_camo09";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_reflexsmg_camo10";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_silencer_camo11";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_rof_camo12";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_acogsmg_camo13";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_eotechsmg_camo01";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_ak74u_mp_thermalsmg_camo03";
    level.Weapons[level.Weapons.size] = "iw5_spas12_mp_camo04";
    level.Weapons[level.Weapons.size] = "iw5_spas12_mp_grip_camo05";
    level.Weapons[level.Weapons.size] = "iw5_spas12_mp_reflex_camo06";
    level.Weapons[level.Weapons.size] = "iw5_spas12_mp_eotech_camo07";
    level.Weapons[level.Weapons.size] = "iw5_spas12_mp_xmags_camo08";
    level.Weapons[level.Weapons.size] = "iw5_aa12_mp_camo10";
    level.Weapons[level.Weapons.size] = "iw5_aa12_mp_grip_camo11";
    level.Weapons[level.Weapons.size] = "iw5_aa12_mp_reflex_camo12";
    level.Weapons[level.Weapons.size] = "iw5_aa12_mp_eotech_camo13";
    level.Weapons[level.Weapons.size] = "iw5_aa12_mp_xmags_camo01";
    level.Weapons[level.Weapons.size] = "iw5_striker_mp_camo03";
    level.Weapons[level.Weapons.size] = "iw5_striker_mp_grip_camo04";
    level.Weapons[level.Weapons.size] = "iw5_striker_mp_reflex_camo05";
    level.Weapons[level.Weapons.size] = "iw5_striker_mp_eotech_camo06";
    level.Weapons[level.Weapons.size] = "iw5_striker_mp_xmags_camo07";
    level.Weapons[level.Weapons.size] = "iw5_1887_mp_camo08";
    level.Weapons[level.Weapons.size] = "iw5_usas12_mp_camo09";
    level.Weapons[level.Weapons.size] = "iw5_usas12_mp_grip_camo10";
    level.Weapons[level.Weapons.size] = "iw5_usas12_mp_reflex_camo11";
    level.Weapons[level.Weapons.size] = "iw5_usas12_mp_eotech_camo12";
    level.Weapons[level.Weapons.size] = "iw5_usas12_mp_xmags_camo13";
    level.Weapons[level.Weapons.size] = "iw5_ksg_mp_camo02";
    level.Weapons[level.Weapons.size] = "iw5_ksg_mp_grip_camo03";
    level.Weapons[level.Weapons.size] = "iw5_ksg_mp_reflex_camo04";
    level.Weapons[level.Weapons.size] = "iw5_ksg_mp_eotech_camo05";
    level.Weapons[level.Weapons.size] = "iw5_ksg_mp_xmags_camo06";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_camo08";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_reflexlmg_camo09";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_silencer_camo10";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_grip_camo11";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_acog_camo12";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_rof_camo13";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_eotechlmg_camo01";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_m60_mp_thermal_camo03";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_camo04";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_reflexlmg_camo05";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_silencer_camo06";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_grip_camo07";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_acog_camo08";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_rof_camo09";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_eotechlmg_camo10";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_xmags_camo11";
    level.Weapons[level.Weapons.size] = "iw5_pecheneg_mp_thermal_camo12";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_camo13";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_reflexlmg_camo01";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_silencer_camo02";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_grip_camo03";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_acog_camo04";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_rof_camo05";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_heartbeat_camo06";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_eotechlmg_camo07";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_xmags_camo08";
    level.Weapons[level.Weapons.size] = "iw5_mk46_mp_thermal_camo09";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_camo10";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_reflexlmg_camo11";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_silencer_camo12";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_grip_camo13";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_acog_camo01";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_rof_camo02";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_heartbeat_camo03";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_eotechlmg_camo04";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_xmags_camo05";
    level.Weapons[level.Weapons.size] = "iw5_sa80_mp_thermal_camo06";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_camo07";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_reflexlmg_camo08";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_silencer_camo09";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_grip_camo10";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_acog_camo11";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_rof_camo12";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_heartbeat_camo13";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_eotechlmg_camo01";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_mg36_mp_thermal_camo03";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_barrettscope_camo04";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_acog_camo05";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_barrettscope_heartbeat_camo06";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_barrettscope_xmags_camo07";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_thermal_camo08";
    level.Weapons[level.Weapons.size] = "iw5_barrett_mp_barrettscopevz_camo09";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_msrscope_camo11";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_acog_camo12";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_heartbeat_msrscope_camo13";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_msrscope_xmags_camo01";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_thermal_camo02";
    level.Weapons[level.Weapons.size] = "iw5_msr_mp_msrscopevz_camo03";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_rsassscope_camo05";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_acog_camo06";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_heartbeat_rsassscope_camo07";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_rsassscope_xmags_camo08";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_thermal_camo09";
    level.Weapons[level.Weapons.size] = "iw5_rsass_mp_rsassscopevz_camo10";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_dragunovscope_camo12";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_acog_camo13";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_dragunovscope_heartbeat_camo01";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_dragunovscope_xmags_camo02";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_thermal_camo03";
    level.Weapons[level.Weapons.size] = "iw5_dragunov_mp_dragunovscopevz_camo04";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_cheytacscope_camo06";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_acog_camo07";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_cheytacscope_heartbeat_camo08";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_cheytacscope_xmags_camo09";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_thermal_camo10";
    level.Weapons[level.Weapons.size] = "iw5_cheytac_mp_cheytacscopevz_camo11";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_as50scope_camo13";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_acog_camo01";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_as50scope_heartbeat_camo02";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_as50scope_xmags_camo03";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_thermal_camo04";
    level.Weapons[level.Weapons.size] = "iw5_as50_mp_as50scopevz_camo05";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_l96a1scope_camo07";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_acog_camo08";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_heartbeat_l96a1scope_camo09";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_l96a1scope_xmags_camo10";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_thermal_camo11";
    level.Weapons[level.Weapons.size] = "iw5_l96a1_mp_l96a1scopevz_camo12";
    level.Weapons[level.Weapons.size] = "iw5_fmg9_mp";
    level.Weapons[level.Weapons.size] = "iw5_fmg9_mp_silencer02";
    level.Weapons[level.Weapons.size] = "iw5_fmg9_mp_akimbo";
    level.Weapons[level.Weapons.size] = "iw5_fmg9_mp_xmags";
    level.Weapons[level.Weapons.size] = "iw5_g18_mp";
    level.Weapons[level.Weapons.size] = "iw5_g18_mp_silencer02";
    level.Weapons[level.Weapons.size] = "iw5_g18_mp_akimbo";
    level.Weapons[level.Weapons.size] = "iw5_g18_mp_xmags";
    level.Weapons[level.Weapons.size] = "iw5_mp9_mp";
    level.Weapons[level.Weapons.size] = "iw5_mp9_mp_silencer02";
    level.Weapons[level.Weapons.size] = "iw5_mp9_mp_akimbo";
    level.Weapons[level.Weapons.size] = "iw5_mp9_mp_xmags";
    level.Weapons[level.Weapons.size] = "iw5_skorpion_mp";
    level.Weapons[level.Weapons.size] = "iw5_skorpion_mp_silencer02";
    level.Weapons[level.Weapons.size] = "iw5_skorpion_mp_akimbo";
    level.Weapons[level.Weapons.size] = "iw5_skorpion_mp_xmags";
    level.Weapons[level.Weapons.size] = "rpg_mp";
    level.Weapons[level.Weapons.size] = "iw5_smaw_mp";
    level.Weapons[level.Weapons.size] = "javelin_mp";
    level.Weapons[level.Weapons.size] = "m320_mp";
    level.Weapons[level.Weapons.size] = "defaultweapon_mp";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo01";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo02";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo03";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo04";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo05";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo06";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo07";
    level.Weapons[level.Weapons.size] = "iw5_m60jugg_mp_silencer_thermal_camo08";
    level.Weapons[level.Weapons.size] = "iw5_mk12spr_mp_thermal";
}

get_weapon_name_conv(weapon) {
	weapon = getbaseweaponname(weapon);
  	switch (weapon) {
        case "iw5_m60jugg": return "AUG-HBAR";
        case "iw5_mk12spr": return "MK12-SPR";
	    case "iw5_44magnum": return ".44 Magnum";
	    case "iw5_usp45": return "USP .45";
	    case "iw5_deserteagle": return "Desert Eagle";
	    case "iw5_mp412": return "MP412";
	    case "iw5_g18": return "G18";
	    case "iw5_fmg9": return "FMG9";
	    case "iw5_mp9": return "MP9";
	    case "iw5_skorpion": return "Skorpion";
	    case "iw5_p99": return "P99";
	    case "iw5_fnfiveseven": return "Five Seven";
	    case "iw5_m320": return "M320 GLM";
	    case "rpg": return "RPG";
	    case "iw5_smaw": return "SMAW";
	    case "iw5_stinger": return "Stinger";
	    case "javelin": return "Javelin";
	    case "iw5_m4": return "M4A1";
	    case "iw5_riotshield": return "Riot Shield";
	    case "iw5_ak47": return "AK-47";
	    case "iw5_m16": return "M16";
	    case "iw5_fad": return "FAD";
	    case "iw5_mk46": return "MK46";
	    case "iw5_acr": return "ACR 6.8";
	    case "xm25": return "XM25";
	    case "iw5_type95": return "Type 95";
	    case "iw5_mk14": return "MK14";
	    case "iw5_g36c": return "G36C";
	    case "iw5_scar": return "SCAR-L";
	    case "iw5_cm901": return "CM901";
	    case "iw5_mp5": return "MP5";
	    case "iw5_mp7": return "MP7";
	    case "iw5_m9": return "PM-9";
	    case "iw5_pp90m1": return "PP90M1";
	    case "iw5_p90": return "P90";
	    case "iw5_ump45": return "UMP45";
	    case "iw5_l86lsw": return "L86 LSW";
	    case "iw5_mg36": return "MG36";
	    case "iw5_pecheneg": return "Pecheneg";
	    case "iw5_sa80": return "L86 LSW";
	    case "iw5_m60e4": return "M60E4";
	    case "iw5_barrett": return "Barrett .50cal";
	    case "iw5_rsass": return "RSASS";
	    case "iw5_dragunov": return "Dragunov";
	    case "iw5_as50": return "AS50";
	    case "iw5_msr": return "MSR";
	    case "iw5_l96a1": return "L118A";
	    case "iw5_usas12": return "USAS12";
	    case "iw5_ksg": return "KSG";
	    case "iw5_spas12": return "SPAS-12";
	    case "iw5_striker": return "Striker";
	    case "iw5_aa12": return "AA-12";
	    case "iw5_1887": return "Model 1887";
	    case "iw5_glock18": return "G18";
	    case "iw5_cheytac": return "Intervention";
	    case "iw5_m60": return "M60";
	    case "iw5_ak74u": return "AK74u";
	    default: return weapon;
	}
}

mayDropWeaponReplace(weapon) {
    return 0;
}