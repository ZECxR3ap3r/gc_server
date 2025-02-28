#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {
    replacefunc(maps\mp\gametypes\_weapons::mayDropWeapon, ::mayDropWeaponReplace);

    // if (GetDvar("g_gametype") == "infect") {
        level.ChangeInterval = 30;

        level.starting_weapon = [];
        level.starting_weapon[level.starting_weapon.size] = "iw5_iw3ak74u_mp_xmags";
        level.starting_weapon[level.starting_weapon.size] = "iw5_mp7_mp_silencer";
        level.starting_weapon[level.starting_weapon.size] = "iw5_pp90m1_mp_silencer";
        level.starting_weapon[level.starting_weapon.size] = "iw5_ump45_mp_silencer";
        level.starting_weapon[level.starting_weapon.size] = "iw5_mp5_mp_xmags";
        level.starting_weapon[level.starting_weapon.size] = "iw5_p90_mp_rof";
        level.starting_weapon[level.starting_weapon.size] = "iw4_krissxmags_mp";

        level.selected_starting_weapon = level.starting_weapon[randomint(level.starting_weapon.size)];

        level.weapons_list          = [];
        level.wpn_class_list        = [];
        level.wpn_display_list      = [];
        level.wpn_forced_list       = [];
        level.wpn_forced_camo_list  = [];

        level.current_weapon = [];

        level.GlobalCurrentGun = "defaultweapon_mp";
        level.GlobalCurrentGun_base = "defaultweapon";

        level.gun_errors = 0;

        init_Weapons();

        level thread rotateGuns();
    // }
}


rotateGuns() {
    level endon("game_ended");
    // level waittill("prematch_over");

    // level.current_weapon["base_weapon"]          //   
    // level.current_weapon["give_weapon"]          //   
    // level.current_weapon["displayname"]          //   
    // level.current_weapon["iw4_akimbo"]           //    
    // level.current_weapon["iw4_camo"]             //    
    // level.current_weapon["underbarrel_launcher"] //    

    x = 4;
    y = 110;

    get_random_weapon();
    passedTime = level.ChangeInterval;

    while(1) {
        passedTime -= 1;

        if(passedTime == 0) {
            passedTime = level.ChangeInterval;

            foreach(player in level.players) {
            	if(player.team == "allies") {
                    player give_global_weapon();
                        
                    if(!player isUsingRemote() && player getcurrentweapon() != "none" && (player getcurrentweapon() == level.GlobalCurrentGun || player getcurrentweapon() == "alt_"+level.GlobalCurrentGun) || !isDefined(player.hadgunsrotated))
                        player switchtoweaponimmediate(level.current_weapon["give_weapon"]);
                    else if(player isusingremote() || player getcurrentweapon() == "none")
                        player.saved_lastWeapon = level.selected_starting_weapon;

                    if(!isDefined(player.hadgunsrotated)) {
                        player SetPerk("specialty_fastreload", 1, 0);
                        player SetPerk("specialty_quickswap", 1, 0);
                    } else {
                        player takeweapon(level.GlobalCurrentGun);
                    }

                    player.hadgunsrotated = 1;
                }
            }

            level.GlobalCurrentGun = level.current_weapon["give_weapon"];
            level.GlobalCurrentGun_base = level.current_weapon["base_weapon"];

            while(true) {
                get_random_weapon();
                if(level.GlobalCurrentGun_base != level.current_weapon["base_weapon"] && level.GlobalCurrentGun != level.selected_starting_weapon)
                    break;

                wait .05;
            }
        }
        else {
            if(passedtime < 4) {
                foreach(player in level.players) {
            	    if(player.team == "allies")
                        player iPrintLnBold("Next Gun ^8" + level.current_weapon["displayname"] + "^7 in ^8" + passedtime);
                }
            }
        }

        wait 1;
    }
}

init_Weapons() {
    // manual_add_to_weapons_list( 0 , 0 , "iw5_44magnum_mp" , "Magnum" , "pistol" , undefined , undefined , ["akimbo","tactical","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_usp45_mp" , "USP-45" , "pistol" , undefined , undefined , ["silencer02","akimbo","tactical","xmags","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_deserteagle_mp" , "Desert Eagle" , "pistol" , undefined , undefined , ["akimbo","tactical","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_mp412_mp" , "MP412" , "pistol", undefined , undefined , ["akimbo","tactical","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_mp412jugg_mp" , "displayname" , "pistol", undefined , undefined , ["tactical","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_p99_mp" , "P99" , "pistol", undefined , undefined , ["silencer02","akimbo","tactical","xmags","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_fnfiveseven_mp" , "Five-Seven" , "pistol", undefined , undefined , ["silencer02","akimbo","tactical","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_fmg9_mp" , "FMG-9" , "machine_pistol", undefined , ["reflex","eotech"] , ["silencer02","akimbo","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_skorpion_mp" , "Skorpion" , "machine_pistol", undefined , ["reflex","eotech"] , ["silencer02","akimbo","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mp9_mp" , "MP-9" , "machine_pistol", undefined , ["reflex","eotech"] , ["silencer02","akimbo","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_g18_mp" , "G18" , "machine_pistol", undefined , ["reflex","eotech"] , ["silencer02","akimbo","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mp5_mp" , "MP5" , "machine_pistol", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_m9_mp" , "PM9" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_p90_mp" , "P90" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_pp90m1_mp" , "PP90M1" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer", "akimbo","rof","xmags","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_ump45_mp" , "UMP-45" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","rof","xmags","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_ump45aki_mp" , "UMP-45" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer", "akimbo","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mp7_mp" , "MP7" , "submachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_ak47_mp" , "AK-47" , "machine_gun", ["gp25","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_m16_mp" , "M16A4" , "machine_gun", ["gl","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","rof","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_m4_mp" , "M4A1" , "machine_gun" , ["gl","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_fad_mp" , "FAD" , "machine_gun" , ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] ); 
    manual_add_to_weapons_list( 0 , 0 , "iw5_acr_mp" , "ACR 6.8" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_type95_mp" , "TYPE 95" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","rof","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mk14_mp" , "MK14" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","rof","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_scar_mp" , "Scar-L" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_g36c_mp" , "G36C" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_cm901_mp" , "CM901" , "machine_gun", ["m320","shotgun"] , ["reflex","acog","eotech","thermal"] , ["silencer","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "m320_mp" , "M320" , "launcher", undefined , undefined , undefined );
    manual_add_to_weapons_list( 0 , 0 , "rpg_mp" , "RPG-7" , "launcher", undefined , undefined , undefined );
    manual_add_to_weapons_list( 0 , 0 , "iw5_smaw_mp" , "SMAW" , "launcher", undefined , undefined , undefined );
    // manual_add_to_weapons_list( 0 , 0 , "stinger_mp" , "Stinger" , "launcher", undefined , undefined , undefined );
    manual_add_to_weapons_list( 0 , 0 , "javelin_mp" , "Javelin" , "launcher", undefined , undefined , undefined );
    // manual_add_to_weapons_list( 0 , 0 , "xm25_mp" , "XM25" , "launcher", undefined , undefined , undefined );
    manual_add_to_weapons_list( 0 , 0 , "iw5_dragunov_mp" , "Dragunov" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_msr_mp" , "MSR" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_barrett_mp" , "Barret .50Cal" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_rsass_mp" , "RSASS" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_as50_mp" , "AS50" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_l96a1_mp" , "L118A" , "sniper", undefined , ["acog","thermal","vzscope"] , ["silencer03","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_ksg_mp" , "KSG-12" , "shotgun", undefined , ["reflex","eotech"] , ["grip","silencer03","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_1887_mp" , "Model 1887" , "shotgun", undefined , undefined ,  ["akimbo","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_striker_mp" , "Striker" , "shotgun", undefined , ["reflex","eotech"] , ["grip","silencer03","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_aa12_mp" , "AA-12" , "shotgun", undefined , ["reflex","eotech"] , ["grip","silencer03","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_usas12_mp" , "USAS-12" , "shotgun", undefined , ["reflex","eotech"] , ["grip","silencer03","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_spas12_mp" , "Spas-12" , "shotgun", undefined , ["reflex","eotech"] , ["grip","silencer03","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_m60_mp" , "M60E4" , "lightmachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","grip","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mk46_mp" , "MK46" , "lightmachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","grip","rof","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_pecheneg_mp" , "PKP Pecheneg" , "lightmachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","grip","rof","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_sa80_mp" , "L86 LSW" , "lightmachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","grip","rof","heartbeat","xmags","none"] );
    manual_add_to_weapons_list( 0 , 0 , "iw5_mg36_mp" , "MG36" , "lightmachine_gun", undefined , ["reflex","acog","eotech","thermal"] , ["silencer","grip","rof","heartbeat","xmags","none"] );
    
    manual_add_to_weapons_list( 1 , 0 , "iw4_kriss_mp" , "MW2 - Vector", "submachine_gun" , undefined , undefined, ["iw4_krissacog_mp", "iw4_krisseotech_mp", "iw4_krissreflex_mp", "iw4_krisssilencer_mp", "iw4_krissthermal_mp", "iw4_krissrof_mp", "iw4_krissaki_mp"]);
    manual_add_to_weapons_list( 0 , 0 , "iw5_iw3ak74u_mp" , "CoD4 - AK-74u", "submachine_gun" , undefined , ["reflexsmg","acogsmg","eotechsmg","thermalsmg"], ["rof", "xmags", "none"]);
    // manual_add_to_weapons_list( 0 , 0 , "iw5_ballista_mp" , "BO2 - Ballista", "sniper" , undefined , ["acog","thermal"] , ["silencer03","xmags","none"] );
    // manual_add_to_weapons_list( 0 , 0 , "iw5_ballistascope_mp" , "BO2 - Ballista", "sniper" , undefined , undefined , ["silencer03","xmags","none"] );

    // build_dynamic_weapons_list();
    // manual_add_to_weapons_list("iw5_m60jugg_mp_rof_silencer_thermal", ["forced"]);
    // manual_add_to_weapons_list("iw5_mp412jugg_mp", ["tactical","none"]);
    // manual_add_to_weapons_list("iw5_usp45jugg_mp", ["tactical","xmags","silencer02","none"]);
    // manual_add_to_weapons_list("iw5_iw3ak74u_mp", ["reflex","silencer","rof","acog","eotech","xmags","thermal","none"]);

    
    level.weapons_list_keys = GetArrayKeys(level.weapons_list);
}

manual_add_to_weapons_list(forced, camo, weapon_name, display_name, weapon_class, underbarrel_array, scope_array, attach_array) {
    level.weapons_list[weapon_name] = [];
    level.wpn_class_list[weapon_name] = weapon_class;
    level.wpn_display_list[weapon_name] = display_name;

    if(isdefined(attach_array)) {
        foreach(attach in attach_array) {
            level.weapons_list[weapon_name][attach] = true;
        }
    }

    if(forced == 1) {
        level.wpn_forced_list[weapon_name] = true;
    }
    if(camo > 0) {
        level.wpn_forced_camo_list[weapon_name] = camo;
    }

    if(isdefined(underbarrel_array)) {
        level.weapons_list[weapon_name]["underbarrel"] = [];
        foreach(item in underbarrel_array)
            level.weapons_list[weapon_name]["underbarrel"][item] = true;
    }

    if(isdefined(scope_array)) {
        level.weapons_list[weapon_name]["scope"] = [];
        foreach(item in scope_array)
            level.weapons_list[weapon_name]["scope"][item] = true;
    }
}

temp_dev_print(string) {
    // print(string);
}

get_random_weapon() {
    rand_wep = level.weapons_list_keys[randomint(level.weapons_list_keys.size)];
    
    rand_wep_attach_keys = GetArrayKeys(level.weapons_list[rand_wep]);

    reticle = undefined;
    camo = undefined;
    attach1 = undefined;
    attach2 = undefined;
    selected_weapon = undefined;
    temp1 = "nibba";
    temp2 = "nibba";

    if(level.weapons_list[rand_wep].size > 1 && !isdefined(level.wpn_forced_list[rand_wep])) {
        temp1 = rand_wep_attach_keys[randomint(rand_wep_attach_keys.size)];
        temp2 = rand_wep_attach_keys[randomint(rand_wep_attach_keys.size)];

        cock = false;
        if(temp1 == temp2)
            cock = true;
        if( temp1 == "underbarrel" && temp2 == "underbarrel")
            cock = true;
        if( temp1 == "scope" && temp2 == "scope" )
            cock = true;
        
        while(cock) {
            temp2 = rand_wep_attach_keys[randomint(rand_wep_attach_keys.size)];
            if(temp1 == temp2)
                continue;
            if( temp1 == "underbarrel" && temp2 == "underbarrel")
                continue;
            if( temp1 == "scope" && temp2 == "scope" )
                continue;

            break;
        }

        attach1 = get_underbarrel_scope_attach(rand_wep, temp1);
        attach2 = get_underbarrel_scope_attach(rand_wep, temp2);

        if(attach1 == "none" && attach2 != "none") {
            attach1 = attach2;
            attach2 = "none";
        }

        return_array = check_class_camo_akimbo(rand_wep, attach1, attach2);

        if(isdefined(return_array["camo"]))
            camo = return_array["camo"];
        

        attach1 = return_array["attach1"];
        attach2 = return_array["attach2"];

        reticle = randomint(7);
    } else {
        attach1 = "none";
        attach2 = "none";
        camo = undefined;
        reticle = 0;
    }

    level.current_weapon["base_weapon"] = rand_wep;
    level.current_weapon["give_weapon"] = rand_wep;
    level.current_weapon["displayname"] = level.wpn_display_list[rand_wep];
    level.current_weapon["iw4_akimbo"] = false;
    level.current_weapon["iw4_camo"] = 0;
    level.current_weapon["underbarrel_launcher"] = false;
    
    selected_weapon = undefined;

    if(isdefined(level.wpn_forced_list[rand_wep]) && !isdefined(level.wpn_forced_camo_list[rand_wep])) {
        selected_weapon = rand_wep_attach_keys[randomint(rand_wep_attach_keys.size)];
        if(issubstr(selected_weapon, "aki_mp"))
            level.current_weapon["iw4_akimbo"] = true;
    }
    else if(isdefined(level.wpn_forced_camo_list[rand_wep])) { // broken sys for now i think
        selected_weapon = rand_wep_attach_keys[randomint(rand_wep_attach_keys.size)]; 
        camo = randomint(level.wpn_forced_camo_list[rand_wep]);
        level.current_weapon["iw4_camo"] = camo;
        if(issubstr(selected_weapon, "aki_mp"))
            level.current_weapon["iw4_akimbo"] = true;
    }
    else {
        selected_weapon = maps\mp\gametypes\_class::buildWeaponName( getbaseweaponname(rand_wep), attach1, attach2, camo, reticle );
    }

    level.current_weapon["give_weapon"] = selected_weapon;

    if(level.wpn_class_list[rand_wep] == "launcher" || temp1 == "underbarrel" || temp2 == "underbarrel") {
        level.current_weapon["underbarrel_launcher"] = true;
    }

    

    // debug

    // self setspawnweapon(selected_weapon);
    // wait 0.05;
    // if(self getcurrentweapon() != selected_weapon) {
    //     print("^1" + selected_weapon + " ^3- Didn't Work");
    //     level.gun_errors++;
    //     print("^1GUN ERRORS: " + level.gun_errors);
    //     foreach(attachment_item in rand_wep_attach_keys) {
    //         str = attachment_item;
    //         if(IsArray(attachment_item)) {
    //             tmpkeys = GetArrayKeys(level.weapons_list[rand_wep][attachment_item]);
    //             str = str + "    ^6";
    //             foreach(attachment_item_sub in tmpkeys) {
    //                 str = str + attachment_item_sub + "\n    ^6";
    //             }
    //         }
    //     }
    // }
}

give_global_weapon() {
    if(!level.current_weapon["iw4_akimbo"] && level.current_weapon["iw4_camo"] == 0) {
        self giveweapon(level.current_weapon["give_weapon"]);
    } else if(level.current_weapon["iw4_akimbo"]) {
        if(level.current_weapon["iw4_camo"] > 0)
            self giveweapon(level.current_weapon["give_weapon"], level.current_weapon["iw4_camo"], 1);
        else
            self giveweapon(level.current_weapon["give_weapon"], 0, 1);
    } else if(level.current_weapon["iw4_camo"] > 0) {
        self giveweapon(level.current_weapon["give_weapon"], level.current_weapon["iw4_camo"]);
    }

    if(!level.current_weapon["underbarrel_launcher"]) {
        stock = self GetWeaponAmmoStock(level.current_weapon["give_weapon"]);
        frac = self GetFractionMaxAmmo(level.current_weapon["give_weapon"]);
        val = (stock / frac) * 0.85;
        self SetWeaponAmmoStock(level.current_weapon["give_weapon"], int(val));
    } else {
        self SetWeaponAmmoStock(level.current_weapon["give_weapon"], 2000);
    }
}







get_underbarrel_scope_attach(weapon_name, attach) {
    if( attach == "underbarrel" || attach == "scope" ) {
        tempkey = GetArrayKeys(level.weapons_list[weapon_name][attach]);
        return tempkey[randomint(tempkey.size)];
    } else
        return attach;
}

check_class_camo_akimbo(weapon_name, attach1, attach2) {
    return_array = [];
    return_array["attach1"] = attach1;
    return_array["attach2"] = attach2;
    if(level.wpn_class_list[weapon_name] == "pistol" || level.wpn_class_list[weapon_name] == "machine_pistol") {
        if((attach1 == "akimbo" && attach2 == "tactical") || (attach1 == "tactical" && attach2 == "akimbo")) {
            return_array["attach1"] = "akimbo";
            return_array["attach2"] = "none";
        }
    } /* else {
        camo_tmp = randomint(12);
        if(camo_tmp == 0)
            camo = undefined;
        else
            camo = camo_tmp;
        
        return_array["camo"] = camo;
    } */
    return return_array;
}

mayDropWeaponReplace(weapon) {
    return 0;
}
/*
build_dynamic_weapons_list() {
    level.weapons_list = [];
	max_weapon_num = 61;
	for( weaponId = 2; weaponId <= max_weapon_num; weaponId++ )
	{
        temp_dev_print("^1=======================");
		weapon_name = Tablelookup( "mp/statstable.csv", 0, weaponId, 4 );
        temp_dev_print(weapon_name);
		if( weapon_name == "" )
			continue;
        if( weapon_name == "gl" || weapon_name == "iw5_m60jugg" || weapon_name == "iw5_usp45jugg")
            continue;

        weapon_name = weapon_name + "_mp";
        temp_dev_print("^1=======================");

        level.weapons_list[weapon_name] = [];
        for(i=11;i<=21;i++) {
            attach = tablelookup( "mp/statstable.csv", 0, weaponId, i );
            if( attach == "hybrid" )
			    continue;
            if( attach == "" )
			    break;
            temp_dev_print(attach);
            if(attach == "m320" || attach == "shotgun" || attach == "gp25" || attach == "gl") {
                if(!isdefined(level.weapons_list[weapon_name]["underbarrel"]))
                    level.weapons_list[weapon_name]["underbarrel"] = [];
                level.weapons_list[weapon_name]["underbarrel"][attach] = true;
            }else if(IsSubStr(attach , "reflex") || IsSubStr(attach , "acog") || IsSubStr(attach , "thermal") || IsSubStr(attach , "reflex") || IsSubStr(attach , "eotech") || IsSubStr(attach , "hybrid") || IsSubStr(attach , "scope")) {
                if(!isdefined(level.weapons_list[weapon_name]["scope"]))
                    level.weapons_list[weapon_name]["scope"] = [];
                level.weapons_list[weapon_name]["scope"][attach] = true;
            } else 
                level.weapons_list[weapon_name][attach] = true;
        }
        level.weapons_list[weapon_name]["none"] = true;
		temp_dev_print("^1=======================");
        
        attachment_string = "undefined_cock";
        scope_string = "undefined_cock";
        underbarrel_string = "undefined_cock";

        if(isdefined(level.weapons_list[weapon_name]["underbarrel"])) {
            keys = GetArrayKeys(level.weapons_list[weapon_name]["underbarrel"]);

            for(i=0;i<keys.size;i++) {
                if(underbarrel_string == "undefined_cock")
                    underbarrel_string = "[";

                if(i == keys.size - 1)
                    underbarrel_string = underbarrel_string + keys[i] + "]";
                else
                    underbarrel_string = underbarrel_string + keys[i] + ",";
            }
        }

        if(isdefined(level.weapons_list[weapon_name]["scope"])) {
            keys = GetArrayKeys(level.weapons_list[weapon_name]["scope"]);

            for(i=0;i<keys.size;i++) {
                if(scope_string == "undefined")
                    scope_string = "[";

                if(i == keys.size - 1)
                    scope_string = scope_string + keys[i] + "]";
                else
                    scope_string = scope_string + keys[i] + ",";
            }
        }

        if(isdefined(level.weapons_list[weapon_name])) {
            keys = GetArrayKeys(level.weapons_list[weapon_name]);

            for(i=0;i<keys.size;i++) {
                if(keys[i] == "underbarrel" || keys[i] == "scope")
                    continue;

                if(attachment_string == "undefined")
                    attachment_string = "[";

                if(i == keys.size - 1)
                    attachment_string = attachment_string + keys[i] + "]";
                else
                    attachment_string = attachment_string + keys[i] + ",";
            }
        }

        // temp_dev_print(underbarrel_string);
        // temp_dev_print(scope_string);
        // temp_dev_print(attachment_string);

        // writefile(level.gun_filepath,  "manual_add_to_weapons_list( \"" + weapon_name + "\" , \"" + underbarrel_string + "\" , \"" + scope_string + "\" , \"" + attachment_string + "\" );\n", 1);
	}
}*/