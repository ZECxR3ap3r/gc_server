#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
    level thread nextmaptell();
}

nextmaptell() {
    level waittill("connected");
    
    wait 20;
    
    level thread seperate_maprotation_array();
}

seperate_maprotation_array() {
    level endon("nonextmap");

    level.mapsinrotation = StrTok(getdvar("sv_maprotationcurrent"), " ");
    level.shortednmlist = [];

    if(level.mapsinrotation.size == 0) {
        level.mapsinrotation = StrTok(getdvar("sv_maprotation"), " ");
        i = 0;
        t = 0;
        foreach ( s in level.mapsinrotation ) {
            if (s != "map" && t > 1) {
                level.shortednmlist[i] = s;
                i++;
            }
            t++;
        }
    }
    else {
        i = 0;
        t = 0;
        foreach ( s in level.mapsinrotation ) {
            if (s != "map" && s != "dsr") {
                level.shortednmlist[i] = s;
                i++;
            }
            t++;
        }
    }
    
    cmdexec("say ^1Next Map: ^7" + mapname(level.shortednmlist[0]));
    level waittill("game_ended");
    cmdexec("say ^1Next Map: ^7" + mapname(level.shortednmlist[0]));
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
	    case "mp_lockout_h2": return "Lockout";
	    case "mp_poolday": return "Poolday";
	    case "mp_bog_sh": return "Bog";
	    case "mp_subbase": return "Subbase";
	    case "mp_vacant": return "Vacant";
	    case "mp_storm": return "Storm";
	    case "mp_shipment": return "Shipment";
	    case "mp_overgrown": return "Overgrown";
	    case "mp_killhouse": return "Killhouse";
	    case "mp_geometric": return "Geometric";
    	default: return map;
    }
}








