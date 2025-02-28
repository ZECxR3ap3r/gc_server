main() {
	file                    = getdvar("fs_homepath") + "/server_data/current_rotation.txt";
    level.sv_maps           = [];

    add_map_to_pool("mp_plaza2",        1, 0, undefined);
    add_map_to_pool("mp_mogadishu",     1, 0, undefined);
    add_map_to_pool("mp_bootleg",       1, 0, undefined);
    add_map_to_pool("mp_carbon",        1, 0, undefined);
    add_map_to_pool("mp_dome",          1, 0, "betty");
    add_map_to_pool("mp_radar",         1, 0, undefined);
    add_map_to_pool("mp_exchange",      1, 0, "betty");
    add_map_to_pool("mp_lambeth",       1, 0, undefined);
    add_map_to_pool("mp_hardhat",       1, 0, undefined);
    add_map_to_pool("mp_alpha",         1, 0, undefined);
    add_map_to_pool("mp_bravo",         1, 1, undefined);
    add_map_to_pool("mp_paris",         1, 0, undefined);
    add_map_to_pool("mp_seatown",       1, 0, undefined);
    add_map_to_pool("mp_underground",   1, 0, undefined);
    add_map_to_pool("mp_interchange",   1, 0, undefined);
    add_map_to_pool("mp_aground_ss",    0, 0, undefined);
    add_map_to_pool("mp_courtyard_ss",  0, 0, undefined);
    add_map_to_pool("mp_rust",          0, 0, undefined);
    add_map_to_pool("mp_terminal_cls",  0, 0, "betty");
    add_map_to_pool("mp_nuked",         0, 0, undefined);
    add_map_to_pool("mp_village",       1, 0, undefined);
    add_map_to_pool("mp_favela",        0, 0, undefined);

    // Custom

    add_map_to_pool("mp_test",          0, 0, undefined);
    add_map_to_pool("mp_abandon",       0, 1, "tk");
    add_map_to_pool("mp_highrise",      1, 1, "tk");
    add_map_to_pool("mp_nightshift",    0, 1, "betty");
    add_map_to_pool("mp_asylum",        0, 0, "betty");
    add_map_to_pool("mp_morningwood",   0, 1, undefined);
    add_map_to_pool("mp_boardwalk",     1, 0, undefined);
    add_map_to_pool("mp_cement",        0, 0, undefined);
    add_map_to_pool("mp_hillside_ss",   1, 0, undefined);
    add_map_to_pool("mp_moab",          0, 0, "betty");
    add_map_to_pool("mp_crosswalk_ss",  0, 0, undefined);
    add_map_to_pool("mp_restrepo_ss",   0, 0, undefined);
    add_map_to_pool("mp_qadeem",        0, 1, "tk");
    add_map_to_pool("mp_six_ss",        1, 0, undefined);
    //add_map_to_pool("mp_convoy",      0, 0, undefined);
    add_map_to_pool("mp_crossfire",     0, 1, "tk");
    //add_map_to_pool("mp_countdown",   0, 1, undefined);
    add_map_to_pool("mp_citystreets",   0, 0, "tk");
    add_map_to_pool("mp_farm",          0, 1, "betty");
    //add_map_to_pool("mp_pipeline",    0, 1, "tk");
    add_map_to_pool("mp_complex",       0, 0, undefined);
    add_map_to_pool("mp_derail",        0, 0, "betty");
    add_map_to_pool("mp_fav_tropical",  0, 1, "tk");
    add_map_to_pool("mp_checkpoint",    0, 1, "tk");
    add_map_to_pool("mp_quarry",        0, 1, "tk");
    add_map_to_pool("mp_compact",       0, 1, "betty");
    add_map_to_pool("mp_boneyard",      0, 0, "betty");
    add_map_to_pool("mp_storm",         1, 0, "betty");
    add_map_to_pool("mp_subbase",       0, 0, "betty");
    add_map_to_pool("mp_vacant",        1, 0, undefined);
    add_map_to_pool("mp_backlot_sh",    0, 1, "betty");
    add_map_to_pool("mp_firingrange",   1, 0, "betty");
    add_map_to_pool("mp_radiation_sh",  1, 0, undefined);
    add_map_to_pool("mp_showdown_sh",   0, 0, "betty");
    add_map_to_pool("mp_lockout_h2",    0, 0, undefined);
	add_map_to_pool("mp_crash_snow",    0, 1, "betty");
    add_map_to_pool("mp_bog_sh",        0, 1, undefined);
    add_map_to_pool("mp_shipment",      0, 1, undefined);
    add_map_to_pool("mp_killhouse",     0, 0, undefined);
    add_map_to_pool("mp_geometric",     0, 1, undefined);
    add_map_to_pool("mp_mideast",       0, 0, undefined);
    add_map_to_pool("mp_brecourt",      0, 1, "betty");
    //add_map_to_pool("mp_mw2_rust",    0, 0, "tk");
    add_map_to_pool("mp_wasteland_sh",  0, 0, "betty");
    add_map_to_pool("mp_offshore_sh",   0, 0, "betty");
    add_map_to_pool("mp_factory_sh",    0, 0, "betty");
    add_map_to_pool("mp_seatown_sh",    0, 0, undefined);
    //add_map_to_pool("mp_melee_resort", 0, 1, "betty");
    add_map_to_pool("mp_highrise_sh",   0, 1, "tk");
    add_map_to_pool("mp_boomtown",      0, 0, undefined);
    add_map_to_pool("mp_park",          0, 0, undefined);
    add_map_to_pool("mp_trailerpark",   0, 0, undefined);
    //add_map_to_pool("mp_raid",        0, 0, undefined);
    add_map_to_pool("mp_meteora",       0, 0, "betty");
    add_map_to_pool("mp_nola",          0, 0, undefined);
    add_map_to_pool("mp_overgrown",     0, 0, "tk");
    add_map_to_pool("mp_italy",         0, 0, undefined);
    //add_map_to_pool("mp_kwarryer",    0, 1, "tk");
    //add_map_to_pool("mp_port_d",      0, 0, undefined);
    add_map_to_pool("mp_creek",         0, 1, "tk");
    add_map_to_pool("mp_nukearena_sh",  0, 0, undefined);
    add_map_to_pool("mp_roughneck",     0, 0, undefined);
    add_map_to_pool("mp_shipbreaker",   0, 0, undefined);
    add_map_to_pool("mp_kwakelo",       0, 0, undefined);
    add_map_to_pool("mp_fuel2",         0, 1, "betty");
    add_map_to_pool("mp_csgo_mirage",   0, 0, undefined);
    //add_map_to_pool("mp_cargoship_sh",  0, 0, "betty");
    //add_map_to_pool("mp_estate",        0, 1, "tk");
    add_map_to_pool("mp_cha_quad",      0, 0, undefined);
    add_map_to_pool("mp_overwatch",     0, 0, "betty");
    add_map_to_pool("so_deltacamp",     0, 0, undefined);
    add_map_to_pool("mp_broadcast",     0, 1, "tk");
    //add_map_to_pool("mp_dwarf_sh",    0, 1, undefined);
    //add_map_to_pool("mp_village_sh",  0, 0, undefined);
    //add_map_to_pool("mp_strike_sh",   0, 0, undefined);
    add_map_to_pool("mp_bootleg_sh",    0, 0, undefined);

    //add_map_to_pool("mp_marketcenter", 0, 0, undefined);

    map = getdvar("mapname");
    writeclipdata(file, map, 1, 20);

    not_picking = strtok(readfile(file), "\n");

    data = spawnstruct();
    for(i = 0;i < level.sv_maps.size;i++) {
        if(issubstr(map, level.sv_maps[i].map))
            data.current_map = level.sv_maps[i];
        if(issubstr(not_picking[0], level.sv_maps[i].map))
            data.last_map_0 = level.sv_maps[i];
        if(issubstr(not_picking[1], level.sv_maps[i].map))
            data.last_map_1 = level.sv_maps[i];
    }

    nextmapfound = undefined;

    while(!isdefined(nextmapfound)) {
        continue_checking = 1;
        random = randomintrange(0, level.sv_maps.size - 1);

        if(data.current_map.aids == 1 && level.sv_maps[random].aids == 1 || data.last_map_0.aids == 1 && level.sv_maps[random].aids == 1 || data.last_map_1.aids == 1 && level.sv_maps[random].aids == 1)
            continue_checking = 0;

        for(i = 0;i < not_picking.size;i++) {
            if(issubstr(not_picking[i], level.sv_maps[random].map)) {
                continue_checking = 0;
                break;
            }
        }

        if(continue_checking == 1) {
            level.calc_next_map = level.sv_maps[random].map;
            setdvar("sv_maprotationcurrent", "map " + level.calc_next_map);
            nextmapfound = 1;
            break;
        }

        wait .05;
    }
}

add_map_to_pool(mapname, stock, aids, equipment) {
    if(mapexists(mapname)) {
        num = level.sv_maps.size;

        level.sv_maps[num]          = spawnstruct();
        level.sv_maps[num].map      = mapname;
        level.sv_maps[num].stock    = stock;
        level.sv_maps[num].aids     = aids;

        if(getdvar("mapname") == mapname) {
            if(isdefined(equipment) && equipment == "betty")
                level.betties_map = 1;
            else if(isdefined(equipment) && equipment == "tk") {
                level.throwing_knifes_map = 1;
                level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";
            }
        }
    }
}

get_hour(data) {
	info = strtok(data, ":");
	if(isdefined(info[0]))
		return info[0];
}

get_min(data) {
	info = strtok(data, ":");
	if(isdefined(info[1]))
		return info[1];
}

get_seconds(data) {
	info = strtok(data, ":");
	if(isdefined(info[2]))
		return info[2];
}

get_year(data) {
	info = strtok(data, "-");
	if(isdefined(info[0]))
		return info[0];
}

get_month(data) {
	info = strtok(data, "-");
	if(isdefined(info[1]))
		return info[1];
}

get_day(data) {
	info = strtok(data, "-");
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

mapname(map) {
    switch(map) {
    	case "mp_plaza2": return "Arkaden";
	    case "mp_mogadishu": return "Bakaara";
	    case "mp_bootleg": return "Bootleg";
	    case "mp_carbon": return "Carbon";
	    case "mp_dome": return "Dome";
	    case "mp_exchange": return "Downturn";
	    case "mp_lambeth": return "Fallen";
	    case "mp_hardhat": return "Hardhat";
	    case "mp_interchange": return "Interchange";
	    case "mp_alpha": return "Lockdown";
	    case "mp_bravo": return "Mission";
	    case "mp_radar": return "Outpost";
	    case "mp_paris": return "Resistance";
	    case "mp_seatown": return "Seatown";
	    case "mp_underground": return "Underground";
	    case "mp_village": return "Village";
	    case "mp_aground_ss": return "Aground";
	    case "mp_morningwood": return "Black Box";
	    case "mp_boardwalk": return "Boardwalk";
	    case "mp_shipbreaker": return "Decommission";
	    case "mp_courtyard_ss": return "Erosion";
	    case "mp_favela": return "Favela";
	    case "mp_cement": return "Foundation";
	    case "mp_hillside_ss": return "Getaway";
	    case "mp_moab": return "Gulch";
	    case "mp_highrise": return "Highrise";
	    case "mp_crosswalk_ss": return "Intersection";
	    case "mp_park": return "Liberation";
	    case "mp_restrepo_ss": return "Lookout";
	    case "mp_nuked": return "Nuketown";
	    case "mp_qadeem": return "Oasis";
	    case "mp_roughneck": return "Off Shore";
	    case "mp_overwatch": return "Overwatch";
	    case "mp_nola": return "Parish";
	    case "mp_italy": return "Piazza";
	    case "mp_rust": return "Rust";
	    case "mp_meteora": return "Sanctuary";
	    case "mp_nightshift": return "Skidrow";
	    case "mp_terminal_cls": return "Terminal";
	    case "mp_burn_ss": return "U-Turn";
	    case "mp_six_ss": return "Vortex";
	    case "mp_convoy": return "Ambush";
	    case "mp_crossfire": return "Crossfire";
	    case "mp_countdown": return "Countdown";
	    case "mp_crash": return "Crash";
	    case "mp_citystreets": return "District";
	    case "mp_farm": return "Downpour";
	    case "mp_pipeline": return "Pipeline";
	    case "mp_trailerpark": return "Trailer Park";
	    case "mp_underpass": return "Underpass";
	    case "mp_crash_snow": return "Winter Crash";
	    case "mp_afghan": return "Afghan";
	    case "mp_complex": return "Bailout";
	    case "mp_abandon": return "Carnival";
	    case "mp_derail": return "Derail";
	    case "mp_estate": return "Estate";
	    case "mp_fav_tropical": return "Favela Tropical";
	    case "mp_invasion": return "Invasion";
	    case "mp_checkpoint": return "Karachi";
	    case "mp_quarry": return "Quarry";
	    case "mp_compact": return "Salvage";
	    case "mp_boneyard": return "Scrapyard";
	    case "mp_storm": return "Storm";
	    case "mp_subbase": return "Subbase";
	    case "mp_vacant": return "Vacant";
	    case "mp_backlot_sh": return "Backlot";
	    case "mp_dwarf_sh": return "Dwarf";
	    case "mp_firingrange": return "Firing Range";
	    case "mp_cargoship_sh": return "Freighter";
	    case "mp_radiation_sh": return "Radiation";
	    case "mp_showdown_sh": return "Showdown";
	    case "mp_cargoship": return "Wetwork";
	    case "mp_lockout_h2": return "Lockout Halo";
	    case "mp_poolday": return "Poolday";
	    case "mp_bog_sh": return "Bog";
	    case "mp_shipment": return "Shipment";
	    case "mp_overgrown": return "Overgrown";
	    case "mp_killhouse": return "Killhouse";
	    case "mp_geometric": return "Geometric";
	    case "mp_brecourt": return "Wasteland";
	    case "mp_mw2_rust": return "Tropical Rust";
	    case "mp_rustbucket": return "Rustbucket";
	    case "mp_raid": return "Raid";
	    case "mp_strike_sh": return "Strike ^7[ Codo ]";
	    case "mp_factory_sh": return "Der Riese";
	    case "mp_highrise_sh": return "Highrise ^7[ Codo ]";
	    case "mp_seatown_sh": return "Seatown ^7[ Codo ]";
	    case "mp_bootleg_sh": return "Bootleg ^7[ Codo ]";
	    case "mp_melee_resort": return "Melee Resort";
	    case "mp_tunisia": return "Tunisia";
        case "mp_wasteland_sh": return "Wasteland Short";
        case "mp_village_sh": return "Standoff";
        case "mp_port_d": return "Port D";
        case "mp_asylum": return "Asylum";
        case "mp_mario": return "Mario";
        case "so_deltacamp": return "Deltacamp";
        case "mp_fuel2": return "Fuel";
        case "mp_broadcast": return "Broadcast";
        case "mp_dwarf_sh": return "Dwarf";
        case "mp_poolparty": return "Poolparty";
        case "mp_kwakelo": return "Kwakelo";
        case "mp_offshore_sh": return "Doomsday Drilling";

    	default: return map;
    }
}

/*if(!fileexists(file))
		writefile(file, "69");

	if(getdvar("net_port") == "27015") {
		if(fileexists(file2)) {
			rotation = readfile(file2);
			if(getdvar("sv_maprotation") != rotation) {
				setdvar("sv_maprotation", rotation);
				setdvar("sv_maprotationcurrent", rotation);
			}
		}
	}
	else {
        last_day = readfile(file);

        print("^5" + last_day);

		if(day != last_day) {
			writefile(file, day);

			if(isdefined(level.sv_maps)) {
				choosen_maps            = spawnstruct();
                choosen_maps.stock      = 0;
                choosen_maps.custom     = 0;
                choosen_maps.aids       = 0;

                maps_picked             = [];

				map_string 	            = "";
                old_rotation_conv       = "";

				max_custom 	            = 15;
                max_stock 	            = 10;
                max_aids 	            = 3;

                old_rotation_strip = strtok(getdvar("sv_maprotation"), " ");
                for(i = 1;i < old_rotation_strip.size;i += 2) {
                    if(isdefined(old_rotation_strip[i]))
                        old_rotation_conv += old_rotation_strip[i] + " ";
                }

                old_rotation_strip = strtok(old_rotation_conv, " ");
                old_rotation_conv = undefined;

				while(1) {
					if((choosen_maps.stock + choosen_maps.custom) >= (max_custom + max_stock))
						break;

                    num = randomint(level.sv_maps.size);

                    if(!isdefined(maps_picked[level.sv_maps[num].map])) {
                        good_map = 1;

                        if(choosen_maps.stock < max_stock && level.sv_maps[num].stock == 1) {
                            if(level.sv_maps[num].aids == 1 && choosen_maps.aids >= max_aids)
                                good_map = 0;

                            if(good_map == 1) {
                                map_string += "map " + level.sv_maps[num].map + " ";
                                maps_picked[level.sv_maps[num].map] = 1;

                                choosen_maps.stock += 1;
                                if(level.sv_maps[num].aids == 1)
                                    choosen_maps.aids += 1;
                            }
                        }
                        else if(choosen_maps.custom < max_custom && level.sv_maps[num].stock == 0) {
                            if(level.sv_maps[num].aids == 1 && choosen_maps.aids >= max_aids)
                                good_map = 0;

                            if(good_map == 1) {
                                for(i = 0;i < old_rotation_strip.size;i++) {
                                    if(level.sv_maps[num].map == old_rotation_strip[i])
                                        good_map = 0;
                                }

                                if(good_map == 1) {
                                    map_string += "map " + level.sv_maps[num].map + " ";
                                    maps_picked[level.sv_maps[num].map] = 1;

                                    choosen_maps.custom += 1;
                                    if(level.sv_maps[num].aids == 1)
                                        choosen_maps.aids += 1;
                                }
                            }
                        }
                    }
				}

                map_string = getsubstr(map_string, 0, map_string.size - 1);

				setdvar("sv_maprotation", map_string);
				setdvar("sv_maprotationcurrent", map_string);

				writefile(file2, map_string);

				print("\r[ ^1Map Rotation^7 ] Used Characters: ^1" + map_string.size);
				print("\r[ ^1Map Rotation^7 ] Rotation Successfully Updated!");
			}
		}
        else {
            if(getdvar("sv_maprotation") != readfile(file2)) {
                setdvar("sv_maprotation", readfile(file2));
                setdvar("sv_maprotationcurrent", readfile(file2));
                print("\r[ ^1Map Rotation^7 ] Rotation Successfully Updated!");
            }
        }
    }*/