
init() {
    add_weapon("iw5_spas12_mp",        700, 50, 145,                        ["_grip","_reflex","_xmags"],        ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);
    add_weapon("iw5_aa12_mp",          780, 25, 105,                        ["_xmags","_reflex","_eotech"],      ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);
    add_weapon("iw5_striker_mp",       700, 25, 115,                        ["_grip","_reflex","_eotech"],       ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);
    add_weapon("iw5_1887_mp",          750, 45, 125,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);
    add_weapon("iw5_usas12_mp",        750, 45, 125,                        ["_grip","_reflex"],                 ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);
    add_weapon("iw5_stakeout_mp",      780, 50, 140,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_bulldog_mp",       700, 50, 125,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_kam12_mp",         700, 25, 105,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_freedom_mp",       780, 45, 140,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_s12_mp",           550, 35, 100,                        ["_reflex","_eotech","_xmags"],      ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo11"]);
    add_weapon("iw5_m1014_mp",         700, 25, 110,                        ["_eotech","_reflex"],               ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo11"]);
    add_weapon("iw5_tac12_mp",         700, 45, 135,                        ["_eotech","_reflex"],               ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_spas_mp",          700, 25, 105,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_w1200_mp",         700, 50, 145,                        ["_eotech","_reflex"],               ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo11","_camo13"]);
    add_weapon("iw5_olympia_mp",       850, 50, 155,                        undefined,                           ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_ksg_mp",           780, 55, 140,                        ["_grip","_reflex"],                 ["","_camo01","_camo02","_camo03","_camo04","_camo05","_camo06","_camo07","_camo08","_camo09","_camo10","_camo11"]);

    add_weapon("iw5_usp45_mp",         undefined, undefined, undefined,     ["_tactical"],                       ["","_camo01","_camo02","_camo03","_camo04","_camo05"]);
    add_weapon("iw5_mp412_mp",         undefined, undefined, undefined,     ["_akimbo","_tactical"],             undefined);
    add_weapon("iw5_44magnum_mp",      undefined, undefined, undefined,     ["_akimbo","_tactical"],             undefined);
    add_weapon("iw5_deserteagle_mp",   undefined, undefined, undefined,     ["_akimbo","_tactical"],             undefined);
    add_weapon("iw5_p99_mp",           undefined, undefined, undefined,     ["_akimbo","_tactical"],             undefined);
    add_weapon("iw5_fnfiveseven_mp",   undefined, undefined, undefined,     ["_akimbo","_tactical"],             undefined);
}

add_weapon(name, range, min_damage, max_damage, attachments, camos) {
    if(!isdefined(level.inf_weapons))
        level.inf_weapons                           = [];

    class = weaponClass(name);

    if(!isdefined(level.inf_weapons[class]))
        level.inf_weapons[class] = [];

    level.inf_weapons[class][name] = [];
    if(isdefined(attachments))
        level.inf_weapons[class][name]["attachments"] = attachments;
    if(isdefined(camos))
        level.inf_weapons[class][name]["camos"]     = camos;

    if(isdefined(range)) {
        level.inf_weapons[class][name]["range"]         = range;
        level.inf_weapons[class][name]["min_damage"]    = min_damage;
        level.inf_weapons[class][name]["max_damage"]    = max_damage;
    }
}

generate_weapon(class) {
    array_keys = getarraykeys(level.inf_weapons[class]);

    weapon_string = array_keys[randomint(array_keys.size)];
    data = level.inf_weapons[class][weapon_string];

    if(isdefined(data["attachments"]) && randomint(50) > 15)
        weapon_string += data["attachments"][randomint(data["attachments"].size)];
    if(isdefined(data["camos"]))
        weapon_string += data["camos"][randomint(data["camos"].size)];

    return weapon_string;
}