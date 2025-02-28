#include scripts\inf_tpjugg\map_funcs;
init() {
    precachemodel(getAlliesFlagModel(getdvar("ui_mapname")));
    precachemodel("prop_flag_neutral");
    precachemodel("com_plasticcase_green_big");

    precacheshader("waypoint_flag_friendly");
    //precacheshader("compass_waypoint_bomb");
    precachemodel("projectile_cbu97_clusterbomb");
    precachemodel("projectile_javelin_missile");
	
	// level.use_stock_helicopter_system = disable custom helicopter movement
	// level.use_stock_predator_system = disable custom predator spawn above player char
	// level.showinviscrates = true; // shows invis crates
    
	level thread Select_Mapedit();
}

add_map_to_maplist(map, display_name, edit_name, edit_func, maker) {
	if(!isdefined(level.tpjugg_maplist[map])) {
		level.tpjugg_maplist[map] = [];
		level.tpjugg_maplist_display_name[map] = display_name;
	}
	level.tpjugg_maplist[map][level.tpjugg_maplist[map].size] = edit_name;
	level.tpjugg_mapedit[edit_name] = edit_func;
	level.tpjugg_mapedit_credits[edit_name] = maker;
}

Select_Mapedit() {
	rnd = undefined;
    level.map_name = getdvar("mapname");

	delete_all_spawn_except("tdm");

	level.tpjugg_maplist = [];
	level.tpjugg_mapedit = [];
	level.tpjugg_maplist_display_name = [];
	//^1(Updated!) ^7
	add_map_to_maplist("mp_showdown_sh", "Showdown" ,"Rooftop Rumble", ::showdown_edit1, "Clippy");
	add_map_to_maplist("mp_rust", "Rust" ,"Run Around Rust", ::rust_edit1, "Clippy");
	add_map_to_maplist("mp_village", "Village" ,"Village Sux", ::village_edit1, "Unveiled");
	add_map_to_maplist("mp_hillside_ss", "Getaway" ,"Beach Invasion", ::Getaway_edit1, "TMGlion");
	add_map_to_maplist("mp_paris", "Resistance" ,"Alley Annihilation", ::resistance_edit1, "Revox");
	add_map_to_maplist("mp_paris", "Resistance" ,"Roof Revenge", ::resistance_edit2, "Clippy");
	add_map_to_maplist("mp_paris", "Resistance" ,"Lush Lane", ::resistance_edit3, "TMGlion");
	add_map_to_maplist("mp_exchange", "Downturn" ,"Running For Cover", ::downturn_edit1, "Unveiled & Clippy");
	add_map_to_maplist("mp_exchange", "Downturn" ,"Crossing The Bridge", ::downturn_edit2, "Unveiled, Clippy & TMGlion");
	add_map_to_maplist("mp_exchange", "Downturn" ,"Gated Roofs", ::downturn_edit3, "TMGlion");
	add_map_to_maplist("mp_lambeth", "Fallen" ,"Rundown Warehouse", ::fallen_edit1, "Revox");
	add_map_to_maplist("mp_lambeth", "Fallen" ,"Fallen Chimney", ::fallen_edit2, "Clippy & TMGlion");
	add_map_to_maplist("mp_hardhat", "Hardhat" ,"Construction Pit", ::hardhat_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_hardhat", "Hardhat" ,"Road Refuge", ::hardhat_edit2, "Clippy & TMGlion");
	add_map_to_maplist("mp_mogadishu", "Bakaara" ,"Attack on the backlot", ::bakaara_edit1, "Unveiled & Clippy");
	add_map_to_maplist("mp_mogadishu", "Bakaara" ,"Docks", ::bakaara_edit2, "Clippy & TMGlion");
	add_map_to_maplist("mp_mogadishu", "Bakaara" ,"Guns N' Roofs", ::bakaara_edit3, "TMGlion");
	add_map_to_maplist("mp_bravo", "Mission" ,"Open plane with a building", ::mission_edit1, "Unveiled");
	add_map_to_maplist("mp_bravo", "Mission" ,"Around & Up", ::mission_edit2, "Clippy, Sloth & TMGlion");
	add_map_to_maplist("mp_favela", "Favela" ,"Jesus", ::favela_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_favela", "Favela" ,"Streets & Roofs", ::favela_edit2, "Revox & TMGlion");
	add_map_to_maplist("mp_interchange", "Interchange" ,"Highway...", ::interchange_edit1, "Unveiled & Clippy & TMGlion");
	add_map_to_maplist("mp_interchange", "Interchange" ,"between two warehouses", ::interchange_edit2, "Unveiled");
	add_map_to_maplist("mp_seatown", "Seatown" ,"Coast Castle", ::seatown_edit1, "Clippy");
	add_map_to_maplist("mp_seatown", "Seatown" ,"Truck Gate", ::seatown_edit2, "Unveiled & Clippy");
	add_map_to_maplist("mp_plaza2", "Arkaden" ,"Plaza Road", ::arkaden_edit1, "Revox");
	add_map_to_maplist("mp_plaza2", "Arkaden" ,"Bridge Domination", ::arkaden_edit2, "Unveiled & Clippy");
	add_map_to_maplist("mp_alpha", "Lockdown" ,"Roof Runners", ::lockdown_edit1, "Clippy" );
	add_map_to_maplist("mp_alpha", "Lockdown" ,"Street Scurry", ::lockdown_edit2, "TMGlion");
	add_map_to_maplist("mp_nuked", "Nuketown" ,"Bunker Bombing", ::nuketown_edit1, "TMGlion");
	add_map_to_maplist("mp_carbon", "Carbon" ,"Factory Fumbling", ::carbon_edit1, "Unveiled, Clippy & TMGlion");
	add_map_to_maplist("mp_bootleg", "Bootleg" ,"Tuk Tuk Trouble", ::bootleg_edit1, "Revox");
	add_map_to_maplist("mp_bootleg", "River" ,"River Splashing", ::bootleg_edit2, "Unveiled");
	//add_map_to_maplist("mp_dome", "Dome" ,"Around The Back", ::dome_edit1, "Unveiled");
	//add_map_to_maplist("mp_dome", "Dome" ,"Dome Depot", ::dome_edit2, "Clippy");
	add_map_to_maplist("mp_dome", "Dome" ,"Bunker Defence", ::dome_edit3, "TMGlion");
	add_map_to_maplist("mp_underground", "Underground" ,"Loading Bay", ::underground_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_underground", "Underground" ,"The Long Road", ::underground_edit2, "TMGlion");
	add_map_to_maplist("mp_underground", "Underground" ,"Abandoned Station", ::underground_edit3, "TMGlion");
	add_map_to_maplist("mp_nightshift", "Skidrow" ,"The Long Straight", ::skidrow_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_nightshift", "Skidrow" ,"Venting rooftop", ::skidrow_edit2, "Clippy & TMGlion");
	add_map_to_maplist("mp_nightshift", "Skidrow" ,"Stairway Struggle", ::skidrow_edit3, "TMGlion");
	add_map_to_maplist("mp_terminal_cls", "Terminal" ,"Airport Shops", ::terminal_edit1, "Clippy");
	add_map_to_maplist("mp_terminal_cls", "Terminal" ,"...No Russian", ::terminal_edit2, "TMGlion");
	add_map_to_maplist("mp_roughneck", "Offshore" ,"Crane Blasting", ::offshore_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_courtyard_ss", "Erosion" ,"Courtyard", ::erosion_edit1, "Revox");
	add_map_to_maplist("mp_courtyard_ss", "Erosion" ,"Bridge Runner", ::erosion_edit2, "TMGlion");
	add_map_to_maplist("mp_highrise", "Highrise" ,"Helipad Crossing", ::highrise_edit1, "Clippy");
	add_map_to_maplist("mp_highrise", "Highrise" ,"Around The Roof", ::highrise_edit2, "Clippy & TMGlion");
	add_map_to_maplist("mp_moab", "Gulch" ,"Prickly Pain", ::gulch_edit1, "Clippy");
	add_map_to_maplist("mp_shipbreaker", "Decommision" ,"Coastal Defence", ::decommision_edit1, "Clippy");
	// add_map_to_maplist("mp_boneyard", "Scrapyard" ,"Airplane Graveyard", ::scrapyard_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_vacant", "Vacant" ,"Hotel Polissya", ::vacant_edit1, "Clippy & Sloth");
	add_map_to_maplist("mp_vacant", "Vacant" ,"Shit Vacant", ::vacant_edit2, "Clippy");
	add_map_to_maplist("mp_lockout_h2", "Lockout H2" ,"Halo Ascension", ::lockout_h2_edit1, "Clippy & TMGlion");
	add_map_to_maplist("mp_lockout_h2", "Lockout H2" ,"Shafted", ::lockout_h2_edit2, "Clippy");
	add_map_to_maplist("mp_cement", "Foundation" ,"Cement Cannon", ::foundation_edit1, "Sloth & TMGlion");
	add_map_to_maplist("mp_derail", "Derail" ,"Snowy Sewer", ::derail_edit1, "Revox, Sloth & TMGlion");
	add_map_to_maplist("mp_checkpoint", "Karachi" ,"Storm the Drain", ::karachi_edit1, "TMGlion");
	add_map_to_maplist("mp_checkpoint", "Karachi" ,"Base Defence", ::karachi_edit2, "TMGlion");
	add_map_to_maplist("mp_overwatch", "Overwatch" ,"Skyscraper", ::overwatch_edit1, "Steven, TMGlion & Sloth");
	add_map_to_maplist("mp_qadeem", "Oasis" ,"Pool Defence", ::oasis_edit1, "TMGlion");
	add_map_to_maplist("mp_factory_sh", "Der Riese" ,"Camping at the Catwalk", ::DerRiese_edit1, "TMGlion");
	add_map_to_maplist("mp_poolparty", "Pool Party" ,"^1(NEW!) ^7Dock Party", ::poolparty_edit1, "Clippy");
	add_map_to_maplist("mp_firingrange", "Firing Range" ,"^1(NEW!) ^7Target Practice", ::firingrange_edit1, "Clickerz");
	add_map_to_maplist("mp_minecraft", "Minecraft" ,"^1(NEW!) ^7Mining & Camping", ::minecraft_edit1, "Clippy");

	// add_map_to_maplist("devmap name", "mapname" ,"^1(NEW!) ^7editname", ::firingrange_edit1, "edit makers name"); // EXAMPLE

	selected_edit = strtok(getdvar("mapvote_mapedit"), ";");
	
	if(isdefined(selected_edit[0]) && selected_edit[0] == level.map_name) {
		rnd = selected_edit[1];
		level [[level.tpjugg_mapedit[selected_edit[1]]]]();
		if(isdefined(level.tpjugg_mapedit_credits[selected_edit[1]]))
			level thread map_credits_edit_hud(level.tpjugg_maplist_display_name[selected_edit[0]], selected_edit[1], level.tpjugg_mapedit_credits[selected_edit[1]]);
		else
			level thread map_credits_edit_hud(level.tpjugg_maplist_display_name[selected_edit[0]], selected_edit[1]);
	}
	else if(isdefined(level.tpjugg_maplist[level.map_name])) {
		rnd = level.tpjugg_maplist[level.map_name][randomint(level.tpjugg_maplist[level.map_name].size)];
		level [[level.tpjugg_mapedit[rnd]]]();
		if(isdefined(level.tpjugg_mapedit_credits[rnd]))
			level thread map_credits_edit_hud(level.tpjugg_maplist_display_name[level.map_name], rnd, level.tpjugg_mapedit_credits[rnd]);
		else
			level thread map_credits_edit_hud(level.tpjugg_maplist_display_name[level.map_name], rnd);
	}

	if(!isdefined(level.lowest_crate)) {
		ents = getentarray("tpjug", "targetname");
	
		if(ents.size) {
			level.lowest_crate = ents[0].origin[2];
			for(i = 0;i < ents.size;i++) {
				if(ents[i].origin[2] < level.lowest_crate)
					level.lowest_crate = ents[i].origin[2];
			}
		}
	}

	delete_remote_spawnpoints();
	
    if(!isdefined(rnd))
		print(getdvar("prefix") + "No Random Map Edit On Map: ^5" + level.map_name + " - Playing Mapedit ^5" + rnd);
    else
		print(getdvar("prefix") + "Mapedit ^5" + rnd + " ^7Picked On ^5" + level.map_name);
	
	//Logic after map load
	level thread anti_breach_logic();
	level thread airstrike_ent_check();
	wait 5;
	print("^1-= Edit Has : ^3" + level.crates_placed + "^1 Crates =-");
}

airstrike_ent_check() {
	ents = GetEntArray("script_origin", "classname");
	airstrikeheight = false;
	foreach(ent in ents) {
		if(isdefined(ent.targetname) && ent.targetname == "airstrikeheight")
			airstrikeheight = true;
	}

	if(!airstrikeheight) {
		if(isdefined(level.lowest_crate)) {
			airstrike_height = spawn("script_origin", level.lowest_crate + (0,0,1500));
			airstrike_height.targetname = "airstrikeheight";
		} else{
			trace = bullettrace((0,0,10000), (0,0,-5000), false, undefined);
			airstrike_height = spawn("script_origin", trace["position"] + (0,0,1000));
			airstrike_height.targetname = "airstrikeheight";
		}
	}

}

map_credits_edit_hud(map, edit, maker) {
	if(!isdefined(map) || !isdefined(edit))
		return;

	if(!isdefined(level.info_hud_elements))
		level.info_hud_elements = [];

	level.info_hud_elements["credits_info"] = newhudelem();
	level.info_hud_elements["credits_info"].horzalign = "fullscreen";
	level.info_hud_elements["credits_info"].vertalign = "fullscreen";
	level.info_hud_elements["credits_info"].alignx = "left";
	level.info_hud_elements["credits_info"].aligny = "top";
	level.info_hud_elements["credits_info"].x = 5;
	level.info_hud_elements["credits_info"].y = 126;
	level.info_hud_elements["credits_info"].font = "bigfixed";
	level.info_hud_elements["credits_info"].archived = true;
	level.info_hud_elements["credits_info"].hidewheninmenu = 1;
	level.info_hud_elements["credits_info"].hidewheninkillcam = 1;
	level.info_hud_elements["credits_info"].fontscale = .4;
	if(isdefined(maker))
		level.info_hud_elements["credits_info"] settext("^7Map: ^8" + map + "\n^7Edit: ^8" + edit + "\n^7Made By: ^8" + maker);
	else
		level.info_hud_elements["credits_info"] settext("^7Map: ^8" + map + "\n^7Edit: ^8" + edit);

	while(isdefined(level.infect_timerDisplay))
		wait 0.05;
	
	level.info_hud_elements["credits_info"] destroy();
}

minecraft_edit1() {
	minimap_corner = spawn("script_origin", (800, 300, 800));
	minimap_corner.targetname = "minimap_corner";
	minimap_corner = spawn("script_origin", (800, 300, 800) + (-3000,-3000,0));
	minimap_corner.targetname = "minimap_corner";
	maps\mp\_compass::setupMiniMap( "black" );
	
	level.overwrite_reapertrace = true;
	moveac130position((-439, -1416, -300));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1930, -1175, 265);
	mp_global_intermission.angles = (0, -180, 0);

	arrow_array = [];
	arrow_array[arrow_array.size] = ((-1574.54, -1593.93, 83.199));
	arrow_array[arrow_array.size] = ((-1028.08, -1565.84, 96.5869));
	arrow_array[arrow_array.size] = ((-314.119, -1535.81, 109.83));
	arrow_array[arrow_array.size] = ((325.469, -1482.78, 108.966));
	arrow_array[arrow_array.size] = ((327.297, -975.453, 106.989));
	arrow_array[arrow_array.size] = ((40.564, -992.588, 246.236));
	arrow_array[arrow_array.size] = ((-658.255, -902.768, 292.943));
	arrow_array[arrow_array.size] = ((-654.914, -435.355, 248.155));
	arrow_array[arrow_array.size] = ((-771.665, -540.042, 486.371));
	arrow_array[arrow_array.size] = ((-756.878, -797.484, 511.083));
	arrow_array[arrow_array.size] = ((-1359.68, -792.825, 534.175));
	show_route_arrows(arrow_array, 0.6);

	disable_spawn_array = [];
	disable_spawn_array[disable_spawn_array.size] = (-1314, -2233, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (-1314, -2187, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (-1263, -2186, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (-1263, -2232, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (426, -2203, 36.125);
	disable_spawn_array[disable_spawn_array.size] = (445, -2146, 36.125);
	disable_spawn_point(disable_spawn_array);

	add_spawn_point((18, -1394, 38),(0, 44, 0));
	add_spawn_point((-17, -1202, 38),(0, -27, 0));
	add_spawn_point((-269, -1204, 38),(0, -13, 0));
	add_spawn_point((-107, -1031, 38),(0, -165, 0));
	add_spawn_point((-174, -924, 38),(0, -155, 0));
	add_spawn_point((-1878, -976, 2),(0, 16, 0));
	add_spawn_point((-1776, -1084, 2),(0, 8, 0));
	add_spawn_point((-1898, -825, 218),(0, -35, 0));
	add_spawn_point((-1775, -934, 218),(0, -130, 0));

	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn");

	for(i=0;i<20;i++)
		spawncrate((-441, -875 + i*-30, 182) , (0, -90, -45) , "com_plasticcase_friendly");


	CreateGrids((-510, -930, 202),(-580, -870, 202), (0,0,0));
	CreateGrids((-685, -930, 202),(-625, -722, 202), (0,0,0));

	CreateWalls((170, -1125, 0),(310, -1125, 160));
	spawncrate((-1440, -874, 214), (0, 0, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -874, 214), (0, 0, 0),"com_plasticcase_friendly");
	spawncrate((-1350, -874, 214), (0, 0, 0),"com_plasticcase_friendly");
	CreateGrids((-1440, -770, 202),(-1340, -840, 202), (0,0,0));
	CreateGrids((-1290, -770, 202),(-730, -770, 202), (0,0,0));


	CreateDoors((-650, -732, 370),(-650, -732, 255),(90, 90, 0), 4, 1, 35, 70);

	for(i=0;i<5;i++) {
		spawncrate((-625, -732, 130 + i*-30), (0, 0, 90),"com_plasticcase_friendly");
		spawncrate((-680, -732, 130 + i*-30), (0, 0, 90),"com_plasticcase_friendly");
	}

	for(i=0;i<3;i++) {
		spawncrate((30, -1340 + i*-20, 362), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((70, -1340 + i*-20, 362), (0, 0, 0),"com_plasticcase_friendly");
	}

	CreateGrids((-730, -760, 382),(-1440, -830, 382), (0,0,0));
	CreateGrids((-610, -668, 382),(-690, -735, 382), (0,0,0));

	spawncrate((-785, -730, 360), (0, 0, 0),"com_plasticcase_friendly");
	spawncrate((-765, -730, 360), (0, 0, 0),"com_plasticcase_friendly");
	spawncrate((-725, -695, 360), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-580, -695, 360), (0, 90, 0),"com_plasticcase_friendly");

	CreateHiddenTP((-1985, -763, 396),(57, -1359, 376),(0,0,0));

	spawncrate((-1978, -1302, 393), (0, 0, 0),"com_plasticcase_friendly"); // ladder block

	CreateWalls((-1945, -1088, 584.5),(-1780, -1088, 409.5));
	CreateGrids((-1655, -978, 598),(-1655, -1088, 598), (0,0,0));
	CreateGrids((-1710, -1088, 598),(-1760, -1088, 598), (0,0,0));

	CreateWalls((-40, -1465, 240),(150, -1465, 480)); // wall at ladder end part block

	for(i=0;i<4;i++) {
		spawncrate((305, -1800, 380 + i*-30), (0, 0, 90),"com_plasticcase_friendly");
	}

	CreateWalls((280, -2280, 320),(280, -2100, 430));
	CreateGrids((710, -2263, 332),(310, -2263, 332), (0,0,24));

	spawncrate((545, -2240, 55), (0, 0, 0)); // secret room blocker

	fufalldamage((-653, -373, -25), 350 , 300);

	spawncrate((-653,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653,-540, 235), (0, 0, 0),"com_plasticcase_enemy");
	i=-1;
	spawncrate((-653 + 147 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 60 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 30 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 45 * i,-540, 235), (0, 0, 0),"com_plasticcase_enemy");
	i=1;
	spawncrate((-653 + 147 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 60 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 30 * i,-500, 235), (0, -90, 0),"com_plasticcase_enemy");
	spawncrate((-653 + 45 * i,-540, 235), (0, 0, 0),"com_plasticcase_enemy");


	spawncrate((355, -940, -14), (0, 0, 0));
	spawncrate((355, -980, -14), (0, 0, 0));
	spawncrate((318, -980, -14), (0, 0, 0));
	spawncrate((318, -1020, -14), (0, 0, 0));
	spawncrate((318, -1060, -14), (0, 0, 0));

	spawncrate((320, -2106, 331) , (0, 0, -45) , "com_plasticcase_friendly");
	spawncrate((355, -2106, 331) , (0, 0, -45) , "com_plasticcase_friendly");
	spawncrate((390, -2106, 331) , (0, 0, -45) , "com_plasticcase_friendly");
	spawncrate((425, -2106, 331) , (0, 0, -45) , "com_plasticcase_friendly");
}

poolparty_edit1() {

	arrow_array = [];
	arrow_array[arrow_array.size] = ((408.806, -680.641, 42.1275));
	arrow_array[arrow_array.size] = ((504.103, -224.906, 109.095));
	arrow_array[arrow_array.size] = ((508.947, 290.413, 112.659));
	arrow_array[arrow_array.size] = ((511.359, 764.703, 110.011));
	arrow_array[arrow_array.size] = ((254.221, 1130.25, 111.878));
	show_route_arrows(arrow_array, 0.75);

	arrow_array = [];
	arrow_array[arrow_array.size] = ((408.806*-1, -680.641, 42.1275));
	arrow_array[arrow_array.size] = ((504.103*-1, -224.906, 109.095));
	arrow_array[arrow_array.size] = ((508.947*-1, 290.413, 112.659));
	arrow_array[arrow_array.size] = ((511.359*-1, 764.703, 110.011));
	arrow_array[arrow_array.size] = ((254.221*-1, 1130.25, 111.878));
	show_route_arrows(arrow_array, 0.75);

	Deathradius((0, 1200, -1000), 3000, 600);

	spawncrate((296, 859, 244), (0, 90, 0));
	CreateQuicksteps((-240, 1185, 18),98, 15, 2, (0, -90, 0));
	CreateQuicksteps((240, 1185, 18),98, 15, 2, (0, -90, 0));
	CreateQuicksteps((0, 1300, 21),148, 15, 2, (0, 90, 0));

	CreateGrids((100, 2640, -80),(-160, 2640, -80), (0,0,0));
	CreateGrids((100, 2679, -100),(-160, 2679, -100), (0,0,-30));
	CreateinvisWalls((110, 2605, -110),(-170, 2605, -20));
	
	CreateinvisGrids((-210, 2500, -126),(-270, 2850, -126), (0,0,0));
	CreateinvisGrids((140, 2500, -126),(200, 2850, -126), (0,0,0));

	spawnmodel((-127, 1497, -113) , (0, 20, 0) , "vehicle_small_hatchback_green");

	spawnmodel((4, 2621, -45) , (0, 0, 90) , "com_conference_table1");
	spawnmodel((-68, 2624, -45) , (0, 0, 90) , "com_conference_table1");
	spawnmodel((4, 2622, -80) , (0, 0, 90) , "com_conference_table1");
	spawnmodel((-68, 2620, -80) , (0, 0, 90) , "com_conference_table1");

	spawnmodel((4, 2621, -45) + (0,-33,0), (0, 180, 90) , "com_conference_table1");
	spawnmodel((-68, 2624, -45) + (0,-33,0), (0, 180, 90) , "com_conference_table1");
	spawnmodel((4, 2622, -80) + (0,-33,0), (0, 180, 90) , "com_conference_table1");
	spawnmodel((-68, 2620, -80) + (0,-33,0), (0, 180, 90) , "com_conference_table1");

	spawnmodel((118, 2605, -111) , (0, -90, 0) , "com_filecabinetblackclosed");
	spawnmodel((118, 2605, -69) , (0, -90, 0) , "com_filecabinetblackclosed");

	spawnmodel((-185, 2605, -111) , (0, -90, 0) , "com_filecabinetblackclosed");
	spawnmodel((-185, 2605, -69) , (0, -90, 0) , "com_filecabinetblackclosed");
	i=0;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;
	spawnmodel((-178 + i*48, 2605, -27) , (0, -90, -90) , "com_filecabinetblackclosed"); i++;

	spawnmodel((379, 1255, -67) , (0, 90, 0) , "foliage_hedge_wall_1");
	spawnmodel((150, 1263, 28) , (180, 90, 0) , "foliage_hedge_wall_1");
	spawnmodel((0, 1262, 28) , (180, 90, 0) , "foliage_hedge_wall_1");
	spawnmodel((-379, 1255, -67) , (0, 90, 0) , "foliage_hedge_wall_1");
	spawnmodel((-150, 1263, 28) , (180, 90, 0) , "foliage_hedge_wall_1");

	for(i=0;i<4;i++) {
		spawnmodel((120, 1400 + i*320, -112) , (0, 0, 0) , "me_streetlight");
		spawnmodel((-180, 1400 + i*320, -112) , (0, 180, 0) , "me_streetlight");
	}

	spawnmodel((85, 2115, -113) , (0, 0, 0) , "com_vending_can_new1");
	spawncrate((85, 2115, -113) + (20, -20, 40), (90, 0, 0) , "com_plasticcase_friendly");
	spawnmodel((45, 2115, -113) , (0, 0, 0) , "com_vending_can_new1");
	spawncrate((45, 2115, -113) + (20, -20, 40), (90, 0, 0) , "com_plasticcase_friendly");

	spawnmodel((-168, 2315, -111) , (0, 0, 0) , "com_photocopier");
	spawncrate((-168, 2315, -111) + (0, 0, 15), (90, 0, 0) , "com_plasticcase_friendly");

	spawnmodel((145, 2610, -145) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((190, 2610, -143) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((145, 2750, -144) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((190, 2750, -145) , (0, -90, 0) , "com_conference_table1");

	spawnmodel((-260, 2610, -145) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((-215, 2610, -143) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((-260, 2750, -144) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((-215, 2750, -145) , (0, -90, 0) , "com_conference_table1");

	pos1 = (-72, 1517, -84);
	pos2 = (-191, 1470, -84);
	ang = vectortoangles(pos1 - pos2);
	CreateinvisWalls(pos1, pos2, ang + (0,90,0));
}

village_edit1(){
	level.meat_playable_bounds = [
		(-448.797, -4094.38, 1352.15),
		(-5746.19, -4099.51, 1358.47),
		(-5750.29, -3132.04, 1355.26),
		(-3073.89, -3130.34, 1352.13),
		(-1792.87, -2423.5, 1352.13),
		(-1020.57, -2749.4, 1352.13),
		(-318.149, -3520.32, 1344.16)
	];
	createPolygon();
	
	moveac130position((-3380, -4080, 1400));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-4093, -3891, 1361);
	mp_global_intermission.angles = (-9, 141, 0);
	
	CreateWalls((-640, -3460, 1400),(-600, -3260, 1320));
	CreateWalls((-555, -3240, 1375),(-335, -3460, 1375));
	CreateWalls((-315, -3475, 1375),(-455, -4105, 1375));
	CreateWalls((-455, -4105, 1375),(-620, -4105, 1375));
	CreateWalls((-2460, -3210, 1400),(-2460, -2930, 1320));
	CreateWalls((-4520, -3790, 1365),(-4520, -3990, 1320));
	
	createTurret((-4525,-3830,1397), (0,0,0));
	createTurret((-4525,-3945,1397), (0,0,0));
	
	CreateWalls((-3380, -4080, 1400),(-3380, -3880, 1320));
	CreateWalls((-4700, -4100, 1400),(-4700, -3710, 1320));
	CreateDoors((-4700,-3590,1450) /*open*/, (-4700,-3590,1360) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	CreateWalls((-4700, -3470, 1400),(-4700, -3120, 1320));
	
	createTP((1153, -629, 287),(-552, -3398, 1344), (2, -82, 0));
	createTP((-1805, 1005, 277),(-552, -3398, 1344), (2, -82, 0));
	createTP((1072, 1045, 240),(-552, -3398, 1344), (2, -82, 0));
	createTP((-1182, -1713, 374),(-552, -3398, 1344), (2, -82, 0));
	createTP((-675, -726, 334),(-552, -3398, 1344), (2, -82, 0));
	createTP((78, -2746, 319),(-552, -3398, 1344), (2, -82, 0));
	createTP((-44, 1746, 273),(-552, -3398, 1344), (2, -82, 0));
	//createHiddenTP((-5690.35,-4089.9,1344.13), (-2053.21,453.705,261.088), undefined, "out");
	//sloth wall
	CreateWalls((-1590, -3407, 1400),(-1609, -3663, 1320));
}
village_edit2(){
	level.meat_playable_bounds = [
		(2627.797, 747, 1352.15),
		(2325.7, 596.6, 400.47),
		(2413.9, 317, 400.26),
		(2405.89, -99.34, 400.13),
		(2474.87, -417.5, 1352.13),
		(2310.57, -708.4, 1352.13),
		(2839.57, -1006.4, 1352.13),
		(2587.57, -1678.4, 1352.13),
		(2010.57, -1682.4, 1352.13),
		(1992.57, -1004.4, 1352.13),
		(915.57,  622.4, 1352.13),
		(2415.6, 1333.42, 1344.16)
	];
	createPolygon();
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "hanging_sheet" || ent.model == "vehicle_bm21_cover_destructible_dusty" || ent.model == "com_trashcan_metal_closed" || ent.model == "chicken_black_white" || ent.model == "vehicle_80s_wagon1_green_destructible_mp") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
		}
	}
	moveac130position((2002, -169, 1022));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1875, -279, 535);
	mp_global_intermission.angles = (-19, -46, 0);
	createTP((1153, -629, 287),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((-1805, 1005, 277),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((1072, 1045, 240),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((-1182, -1713, 374),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((-675, -726, 334),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((78, -2746, 319),(2134, 665, 252), ( 0 , 17 , 0 ));
	createTP((-44, 1746, 273),(2134, 665, 252), ( 0 , 17 , 0 ));
	
	//createHiddenTP((2031, -1567, 693.125), (-265, -1624, 354), undefined, "out");
 
	CreateGrids((2130, 620, 366),(2130, 440, 366), (0,10,0));
	CreateWalls((2231, 748, 345),(2076, 690, 345), vectortoangles((2231, 748, 345) - (2076, 690, 345)));
	spawncrate((2090, 660, 361), (0, 20, 0), "com_plasticcase_friendly");
	spawncrate((2130, 660, 361), (0, 110, 0), "com_plasticcase_friendly");
	CreateRamps((2240, 265, 370),(2310, -40, 493));
	CreateWalls((1860, -135, 520),(2257, -60, 520));
	CreateWalls((1860, -135, 520),(1785, -330, 520));
	
	CreateGrids((2190, -455, 503),(2130, -1170, 503), (0,0,0));
	//spawncrate((2825, -990, 530), (0, 45, 0), "com_plasticcase_friendly"); // blocker
	CreateQuicksteps((2281, 705, 360), 120, 15, 2, (0, -160,0));
	
	CreateGrids((2060, -1430, 680),(2560, -1550, 680), (0,0,0));
	CreateWalls((2060, -1410, 700),(2500, -1410, 700));
	CreateGrids((2560, -1400, 680),(2530, -1340, 680), (0,0,0));
	CreateRamps((2500, -1370, 670),(2250, -1370, 510));
	CreateWalls((2024, -1659, 566),(2020, -1455, 566));
	//CreateWalls((2393, -1675, 566),(2024, -1659, 566));
	
	CreateWalls((2024, -1659, 636),(2020, -1455, 636));
	//CreateWalls((2393, -1675, 636),(2024, -1659, 636));
	
	CreateInvisWalls((2024, -1659, 706),(2020, -1455, 706));
	//CreateInvisWalls((2433, -1675, 706),(2024, -1659, 706));
	
	CreateInvisWalls((2024, -1659, 776),(2020, -1455, 776));
	//CreateInvisWalls((2433, -1675, 776),(2024, -1659, 776));

	spawncrate((2064, -483, 541), (90, -80, 0), "com_plasticcase_friendly"); //next to door
	CreateWalls((2236, -449, 545),(2445, -408, 545));
	CreateDoors((2155, -465, 620) /*open*/, (2155, -465, 555) /*close*/, (90,100,0) /*angle*/, 3 /*size*/, 1 /*height*/, 40 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	CreateQuicksteps((2300, 630, 366), 125, 15, 2, ( 0 , -70 , 0 ));
	
	////tmg added shit
	
	spawnmodel((2537, 1034, 370), (357, 110, 0), "foliage_afr_tree_brokentrunk_01a");
	spawnmodel((2088, 663, 378), (10, 111, 90), "wood_plank1");
	spawnmodel((2120, 693, 378), (10, 111, 90), "wood_plank1");
	
	CreateInvisWalls((2710, 725, 390),(2380, 725, 390));
	CreateInvisWalls((2550, 725, 450),(2380, 725, 450));
	
	spawncrate((2338, 664, 400), (0, 270, 90));
	spawncrate((2338, 664, 460), (0, 270, 90));
	
	spawncrate((2351, 598, 400), (0, 290, 90));
	spawncrate((2351, 598, 460), (0, 290, 90));
	
	//stuck spots
	
	spawncrate((2063, 194, 365), (0, 190, 20));
	spawncrate((2167, 213, 365), (0, 190, 20));
	
	CreateDeathRegion((2957, -710, 385), (2063, -1099, 470));
	
	CreateDeathRegion((2381.9, -40.96, 375), (2544, -332.8, 420));//wall
}

Getaway_edit1(){
	level.meat_playable_bounds = 
	[
	(-897.875, -1338.7, 2600.125),
	(-2377, -1311.38, 2600.679),
	(-2377, -1556.53, 2600.125),
	(-2377, -2484.12, 2600.125),
	(-895.375, -2484.12, 2600.125),
	(-692, -2353.5, 2600.125),
	(1138, -3270.5, 2600.125),
	(1721.32, -2423.06, 2600.425),
	(2019.32, -1524.06, 2260.425),
	(1977.32, -278.06, 2260.425),
	(1549.32, -280.06, 2260.425),
	(1464.88, 369.875, 2600.125),
	(1163.12, 369.875, 2600.125),
	(1163.15, -16.875, 2600.125)
	];
	createPolygon();
	moveac130position((821, -1980, 3009));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1133, -1530, 2295);
	mp_global_intermission.angles = (-23, -137, 0);
	spawnmodel((464, -1152, 2072) , (0, -55, 0) , "foliage_tree_palm_bushy_2_static_flag");
	spawnmodel((-1413, -2219, 2297) , (5, 80, 0) , "brn_cluster_1_rock");
	spawnmodel((-2108, -1692, 2495) , (0, 9, 0) , "me_banana");
	spawnmodel((-2106, -1686, 2494) , (77, 113, 0) , "billiard_ball_01");
	spawnmodel((-2113, -1685, 2495) , (65, 135, 0) , "billiard_ball_08");
	spawnmodel((-2081, -1717, 2461) , (16, 80, 0) , "billiard_table_modern_stick");
	spawnmodel((-2085, -2036, 2624) , (0, 0, 0) , "rst_fluorescent_light_01"); //NEW
	spawnmodel((-2068, -1915, 2477) , (-91, -25, 0) , "afr_militarytent_wood_table");//NEW
	spawnmodel((-2078, -2210, 2461) , (0, -65, 0) , "sofa_sectional_3_seater_lightblue");//NEW
	spawnmodel((-1994, -2234, 2461) , (0, 0, 0) , "furniture_table_coffee3");//NEW
	spawnmodel((-1983, -2307, 2461) , (0, -175, 0) , "sofa_sectional_2_seater_lightblue");//NEW
	
	//steps
	CreateInvisRamps((-1621, -1516.4, 2286.37),(-1621, -1588, 2338.13));	
	CreateInvisRamps((-1661, -1516.4, 2286.37),(-1661, -1588, 2338.13));
	spawnmodel((-1641, -1589, 2342), (0, 90, 0), "com_woodlog_24_96_a");
	spawnmodel((-1641, -1572, 2327), (30, 90, 1), "com_woodlog_24_96_a");
	spawnmodel((-1641, -1555, 2312), (30, 90, 1), "com_woodlog_24_96_a");
	
	spawncrate((-2131, -1699, 2500),(0,0,0));
	spawncrate((-2061, -1699, 2500),(0,0,0));
	
	//afch_flatrock_02  //good massive rock model
	
	//new flank block
	for(i = 0;i < 9;i++)
	spawncrate((-927, -2510, 2280) + (0, -60* i, 0), (90, 90, 0));
	spawnmodel((-947, -2658, 2210), (0, 90, 90), "afch_flatrock_01"); 

	spawnmodel((78, -1220, 2200), (0, 20, 0), "com_woodlog_24_96_a");
	spawnmodel((78, -1220, 2222), (22, 20, 0), "com_woodlog_24_96_a");
	spawnmodel((78, -1220, 2244), (11, 15, 0), "com_woodlog_24_96_a");
	spawnmodel((78, -1220, 2266), (42, 17, 0), "com_woodlog_24_96_a");
	spawnmodel((61, -1224, 2240), (0, 107, 94), "pool_ring");
	spawnmodel((90, -1231, 2233), (352, 200, 0), "kitchen_faucet_modern");
	spawnmodel((101, -1227, 2232), (0, 17, 0), "african_bowl_01");
	spawnmodel((93, -1230, 2235), (0, 107, 0), "pool_towel_hook");
	spawnmodel((93, -1230, 2237), (0, 107, 180), "prop_flag_delta");
	spawnmodel((80, -1192, 2248), (0, 107, 0), "pool_towel_hook");
	spawnmodel((83, -1191, 2248), (0, 107, 0), "pool_towel_hanging_white");
	
	spawncrate((84, -1238, 2259), (0, 107, 90));
	spawncrate((72, -1198.8, 2259), (0, 107, 90));
	spawncrate((84, -1238, 2209), (0, 107, 90));
	spawncrate((72, -1198.8, 2209), (0, 107, 90));

	spawnmodel((12, -2359, 2177) , (0, -10, 0) , "foliage_hedge_boxy_overgrown2");
	spawnmodel((-220, -2308, 2188) , (0, -60, 0) , "foliage_hedge_boxy_overgrown2");

	spawnmodel((-1513, -2285, 2460) , (0, 0, 0) , "ow_patio_umb_closed");
	spawnmodel((-1513, -1623, 2395) , (0, 0, 0) , "foliage_hill_plant_fern_02");
	spawnmodel((-984, -1386, 2160) , (0, 0, 0) , "foliage_tree_palm_bushy_2_static_flag");
	spawnmodel((559, -2902, 2216) , (0, 9, 0) , "prk_river_rock_05");
	spawnmodel((-2077, -1670, 2461) , (0, 9, 0) , "billiard_table_modern_teal");
	spawnmodel((-2136, -1712, 2736) , (0, 33, 0) , "me_banana");
	spawnmodel((-2126, -1692, 2736) , (3, 130, 0) , "me_banana");
	spawnmodel((1799, -1847, 2170) , (0, 0, 0) , "ch_wooden_fence_post_04");
	spawnmodel((1797, -2035, 2170) , (0, 0, 0) , "ch_wooden_fence_post_04");
	spawnmodel((1688, -2291, 2160) , (0, 0, 0) , "ch_wooden_fence_post_04");
	spawnmodel((1959, -1597, 2170) , (0, 0, 0) , "ch_wooden_fence_post_04");
	spawnmodel((728, -1461, 2220) , (0, 2, 0) , "thatched_hut_large");
	spawnmodel((1537, -1249, 2240) , (90, 90, 0) , "thatched_hut_large");
	spawnmodel((-280, -1800.6, 2175) , (0, 0, 0) , "foliage_hedge_boxy_overgrown");
	spawnmodel((-290, -1800.6, 2175) , (0, 180, 0) , "foliage_hedge_boxy_overgrown");
	spawnmodel((-289, -2141.6, 2191) , (0, 0, 0) , "foliage_hedge_boxy_overgrown2");
	spawnmodel((728, -1461, 2220) , (90, 2, 0) , "thatched_hut_large");
	spawnmodel((728, -1461, 2220) , (90, 182, 0) , "thatched_hut_large");
	
	CreateInvisWalls((1455, -1112, 2245),(1616, -1112, 2300));
	CreateInvisWalls((854, -1550, 2260),(854, -1375.5, 2315));
	CreateInvisWalls((603, -1550, 2260),(603, -1375.5, 2315));
	//oceanhouse gate
	spawnmodel((-918, -1805, 2295) , (0, 90, 87) , "ivy_vine_column");
	spawnmodel((-918, -1815, 2291) , (0, 85, 87) , "ivy_vine_column");
	spawnmodel((-918, -1814, 2291) , (0, 85, 87) , "ivy_vine_column");
	spawnmodel((-919, -1834, 2283) , (3, 88, 89) , "ivy_vine_column");
	spawnmodel((-918, -1843, 2295) , (0, 80, 87) , "ivy_vine_column");
	spawnmodel((-917, -1850, 2294) , (0, 90, 87) , "ivy_vine_column");
	spawnmodel((-924, -1805, 2295) , (0, 270, 87) , "ivy_vine_column");//flip
	spawnmodel((-924, -1815, 2291) , (0, 265, 87) , "ivy_vine_column");
	spawnmodel((-924, -1814, 2291) , (0, 265, 87) , "ivy_vine_column");
	spawnmodel((-924, -1834, 2283) , (3, 268, 89) , "ivy_vine_column");
	spawnmodel((-924, -1843, 2295) , (0, 260, 87) , "ivy_vine_column");
	spawnmodel((-924, -1850, 2294) , (0, 270, 87) , "ivy_vine_column");
	
	spawnmodel((-921, -1960, 2328) , (0, -90, 0) , "lam_foliage_hanging_ivy_02");
	spawnmodel((-919, -1985, 2289) , (0, 90, 87) , "ivy_vine_column");
	spawnmodel((-918, -2038, 2278) , (0, 90, 87) , "ivy_vine_column");
	spawnmodel((-920, -2027, 2287) , (0, 92, 87) , "ivy_vine_column");
	spawnmodel((-923, -1952, 2328) , (0, 90, 0) , "lam_foliage_hanging_ivy_02");
	spawnmodel((-903, -2013, 2223) , (2, 89, 180) , "ims_scorpion_body_placement");
	spawnmodel((-900, -1838, 2217) , (2, 89, 180) , "ims_scorpion_body_placement");
	CreateInvisQuicksteps((-923, -2020, 2310), 100, 16, 2, (0, 0,0));
	CreateInvisQuicksteps((-923, -2020, 2310), 100, 16, 2, (0, 180,0));
	CreateInvisQuicksteps((-923, -1832, 2310), 100, 16, 2, (0, 0,0));
	CreateInvisQuicksteps((-923, -1832, 2310), 100, 16, 2, (0, 180,0));
	createTurret((-1503, -2057, 2481), (0,0,0), 50, 50, 30, 10, 10);
	spawnmodel((-1503, -2057, 2460) , (0, 80, 0) , "furniture_modern_patio_ottoman");
	
	//oceanhouse glass walls
	spawncrate((-1491, -1726, 2499),(0,0,0));
	spawncrate((-1571, -1726, 2499),(0,0,0));

	spawnmodel((-1469, -1733, 2455) , (0, 90, 0) , "fence_glass");
	spawnmodel((-1531, -1733, 2455) , (0, 90, 0) , "fence_glass");
	spawnmodel((-1687, -1733, 2455) , (0, 90, 0) , "fence_glass");//new
	spawnmodel((-1750, -1733, 2455) , (0, 90, 0) , "fence_glass");//new

	spawncrate((-1734, -1733, 2499),(0,0,0));
	spawncrate((-1491, -2336, 2495),(0,0,0));
	spawncrate((-1579, -2336, 2495),(0,0,0));
	spawncrate((-1667, -2336, 2495),(0,0,0));
	spawncrate((-1755, -2336, 2495),(0,0,0));

	spawnmodel((-1797, -2326, 2455) , (0, 270, 0) , "fence_glass");
	spawnmodel((-1732, -2326, 2455) , (0, 270, 0) , "fence_glass");
	spawnmodel((-1667, -2326, 2455) , (0, 270, 0) , "fence_glass");
	spawnmodel((-1602, -2326, 2455) , (0, 270, 0) , "fence_glass");
	spawnmodel((-1537, -2326, 2455) , (0, 270, 0) , "fence_glass");
	spawnmodel((-1469, -2320, 2455) , (0, 0, 0) , "fence_glass");
	spawnmodel((-1469, -2255, 2455) , (0, 0, 0) , "fence_glass");
	spawnmodel((-1469, -2190, 2455) , (0, 0, 0) , "fence_glass");

	spawncrate((-1461, -2281, 2495),(0,90,0));
	spawncrate((-1461, -2152, 2495),(0,90,0));
	spawncrate((-1461, -2217, 2495),(0,90,0));

	//doors
	CreateDoors((-1734, -1753, 2499) /*open*/,(-1640, -1753, 2499) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 1 /*height*/, 30 /*hp*/, 50 /*range*/);
	CreateDoors((-1840, -2038.4, 2585) /*open*/, (-1840, -2038.4, 2475) /*close*/, (90,0,0) /*angle*/, 6 /*size*/, 2 /*height*/, 30 /*hp*/, 100 /*range*/);
	
	CreateInvisWalls((-1661, -1875, 2330),(-1608, -1875, 2330),(0,0,90));
	CreateInvisWalls((-1661, -1875, 2380),(-1608, -1875, 2380),(0,0,90));
	
	//roof
	CreateInvisGrids((-2190, -2177, 2871),(-1970, -2177, 2871), (0,0,0));
	CreateInvisGrids((-2190, -1902, 2871),(-1970, -1902, 2871), (0,0,0));
	
	i=0;
	for(i = 0;i < 15;i++)
	spawnmodel((-1919, -2176, 2874) + (-22* i, 0, 0), (0, 0, 0) + (8* i,0,0), "com_woodlog_24_96_a");
	for(i = 0;i < 15;i++)
    spawnmodel((-1919, -1903, 2874) + (-22* i, 0, 0), (13, 0, 0) + (10* i,0,0), "com_woodlog_24_96_a");
	
	//house tps
	createTP((-2308, -2267, 2461), (-2308, -2267, 2890), (0,30,0), 1);
	spawnmodel((-2308, -2267, 2462), (180, 0, 0) , "african_bowl_02");//podium
	spawnmodel((-2308, -2267, 2888), (180, 0, 0) , "african_bowl_03");//podium
	createTP((-2308, -1780, 2885), (-2308, -1780, 2466), (0,330,0));
	spawnmodel((-2308, -1780, 2888), (180, 0, 0) , "african_bowl_02");//podium
	spawnmodel((-2308, -1780, 2462), (180, 0, 0) , "african_bowl_03");//podium
	createTP((-2165, -1739, 2718), (1203, 87, 2319), (0,45,0), undefined,20,120,undefined,1);
	//createHiddenTP((-978.28,-1382.125,2254.125), (-487.49,-837.31,2234.598), (0, 25, 0), "out");
	//IN MAP TPS
	createTP((533, -168.38, 2209), (1559, -2404, 2200), (0,170,0));
	createTP((900, 440.38, 2219), (841, -3009, 2220), (0,170,0));
	createTP((1640, -672.38, 2311), (841, -3009, 2220), (0,170,0));
	createTP((-388.6, 943.38, 2182), (1196, -831, 2226), (0,270,0));
	createTP((1643, 504.38, 2311), (1196, -831, 2226), (0,270,0));
	fufalldamage((-1589, -2015, 2452),400, 420);
	
}
resistance_edit1(){
	
	//Edit By Revox
	moveac130position((-2735, 1444, 1400));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-4308, 1654, 321);
	mp_global_intermission.angles = (-24, -155, 0);
	
	spawncrate((-2015, 2275, 318), (-90, 90, 0));
	spawncrate((-2124, 2275, 318) , (-90, 90, 0));
	spawncrate((-1085, 2156, 250), (0, 90, 0), "com_plasticcase_friendly");
	CreateWalls((-1190, 2620, 230),(-1190, 2620, 330),(0,0,90));
	CreateDoors((-1070, 2620, 340) /*open*/, (-1070, 2620, 250) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	CreateWalls((-950, 2620, 230),(-950, 2620, 330),(0,0,90));
	CreateWalls((-3380, 1710, 240),(-3375, 1710, 360),(0,0,90));
	CreateDoors((-3260, 1710, 370) /*open*/, (-3260, 1710, 280) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	CreateWalls((-3140, 1710, 240),(-3140, 1710, 360),(0,0,90));
	CreateWalls((-3670, 1720, 240),(-3670, 1720, 360),(0,90,90));
	CreateDoors((-3670, 1600, 370) /*open*/, (-3670, 1600, 280) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 85 /*range*/, 1 /*sideways*/);
	CreateWalls((-3670, 1480, 240),(-3670, 1480, 360),(0,90,90));

	CreateWalls((-5160, 1770, 350),(-5240, 1770, 240));
	CreateWalls((-5250, 900, 330),(-4860, 900, 240));
	CreateWalls((-5250, 900, 280),(-4860, 900, 280));
	CreateWalls((-5250, 900, 330),(-4860, 900, 330));
	CreateWalls((-5250, 900, 380),(-4860, 900, 380));
	CreateWalls((-4900, 1570, 270),(-4900, 1490, 240));
	createTurret((-4900,1500,300), (0,0,0));
	createTurret((-4900,1560,300), (0,0,0));
	createTP((-2082, 158, 187), (-1089, 2867, 222), (1, -88, 0), undefined);
	createTP((1618, 584, -15), (-1089, 2867, 222), (1, -88, 0), undefined);
	createTP((-1159, 1554, 226), (-1089, 2867, 222), (1, -88, 0), undefined);
	createTP((611, -594, 3), (-1089, 2867, 222), (1, -88, 0), undefined);
	createTP((-1071, -620, 49), (-1089, 2867, 222), (1, -88, 0), undefined);
	createTP((687, 1799, -28), (-1089, 2867, 222), (1, -88, 0), undefined);
	//createHiddenTP((-4943.13,941.415,260.016), (-1587.67,350.486,68.0757), undefined, "out");
}
resistance_edit2(){
	level.meat_playable_bounds = [
		(187.835, -1548.32, 937.125),
		(-152.917, -1548.34, 937.125),
		(-155.396, -1095.49, 937.125),
		(-309.248, -1095.5, 937.125),
		(-309.251, -1589.48, 937.125),
		(-417.745, -1589.5, 896.125),
		(-418.563, -2329.09, 967.708),
		(132.857, -2329, 282.441),
		(134.049, -3462.89, 282.441),
		(606.557, -3466.88, 282.441),
		(597.096, -2315.44, 566.161),
		(1080.28, -2315.29, 683.422),
		(1082.58, -1821.89, 550.151),
		(1154.67, -1821.86, 612.492),
		(1153.71, -1084.3, 774.707),
		(491.772, -1088.06, 774.707),
		(495.431, -1393.52, 774.707),
		(172.053, -1394.74, 774.707)
	];
	createPolygon();
	
	//Edit By Clippy
	
	moveac130position((603, -1585, 1500));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (241, -2036, 167);
	mp_global_intermission.angles = (-17, -23, 0);
	
	//roof cp fix
	spawnmodel((129, -1969, 601) , (0, -180, 0) , "roof_03_12w_front");
	
	CreateWalls((620, -2850, 60),(620, -3450, 60));
	CreateWalls((620, -2850, 110),(620, -3450, 110));
	CreateWalls((620, -2850, 160),(620, -3450, 160));
	CreateWalls((120, -3150, 60),(120, -3450, 60));
	CreateWalls((120, -3150, 110),(120, -3450, 110));
	CreateWalls((120, -3150, 160),(120, -3450, 160));
	spawncrate((565, -3445, 33), (0, 0, 0), "com_plasticcase_friendly");
	CreateWalls((903, -2300, 30),(903, -2070, 120));
	CreateRamps((760, -1875, 10),(570, -1875, 62));
	CreateWalls((580, -2340, 100),(460, -2340, 190));
	spawncrate((590, -2340, 65), (90, 0, 0), "com_plasticcase_friendly");
	CreateWalls((180, -2570, 40),(180, -2570, 150),(0,0,90));
	CreateWalls((330, -2570, 40),(385, -2570, 150));
	spawncrate((510, -1580, 401), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((510, -1625, 401), (0, 90, 0), "com_plasticcase_friendly");
	CreateGrids((905, -1545, 644),(905, -1670, 644), (0,0,0));
	CreateRamps((885, -1650, 640),(160, -1650, 700));
	CreateWalls((1167, -1100, 670),(1167, -1570, 670));
	CreateWalls((1167, -1100, 720),(1167, -1570, 720));
	CreateGrids((918, -2300, 141),(1065, -2030, 141), (0,0,0));
	CreateGrids((1167, -1570, 580),(1410, -1570, 580), (25,-90,90));
	CreateGrids((1167, -1570, 520),(1410, -1570, 520), (25,-90,90));
	CreateGrids((1167, -1570, 460),(1410, -1570, 460), (25,-90,90));
	CreateGrids((975, -1560, 530),(1125, -1560, 530), (25,-90,90));
	CreateGrids((975, -1560, 500),(1125, -1560, 500), (25,-90,90));
	CreateGrids((975, -1560, 470),(1125, -1560, 470), (25,-90,90));
	CreateGrids((975, -1560, 440),(1125, -1560, 440), (25,-90,90));
	CreateInvisWalls((-322, -1573, 910),(-322, -1110, 910));
	spawncrate((-322, -1130, 850), (0, 90, 90));
	spawncrate((-366, -1593, 920), (0, 0, 90));
	CreateInvisWalls((-420, -1630, 910),(-420, -2330, 910));
	CreateInvisWalls((-400, -2359, 830),(-210, -2359, 830));
	CreateInvisWalls((-143, -1090, 910),(-143, -1535, 910));
	CreateInvisWalls((-111, -1535, 910),(160, -1535, 910));
	CreateInvisWalls((-320, -1081, 910),(-175, -1081, 910));
	CreateDoors((260, -2570, 150) /*open*/, (260, -2570, 50)/*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 40 /*hp*/, 120 /*range*/);
	createHiddenTP((525, -2428, 48), (1066, -1593, 409), (0, -90, 0), undefined, 1);
	//createHiddenTP((-376, -2309, 820.125), (-1763, 718, 248.125), (25, -90, 0), "out", 1);
	createTP((-2082, 158, 187), (1007, -2270, 29), (-0, 90, 0), undefined);
	createTP((1618, 584, -15), (1007, -2270, 29), (-0, 90, 0), undefined);
	createTP((-1159, 1554, 226), (1007, -2270, 29), (-0, 90, 0), undefined);
	createTP((611, -594, 3), (1007, -2270, 29), (-0, 90, 0), undefined);
	createTP((-1071, -620, 49), (1007, -2270, 29), (-0, 90, 0), undefined);
	createTP((687, 1799, -28), (1007, -2270, 29), (-0, 90, 0), undefined);
	CreateDeathRegion((623, -3068, 12), (61, -3515, -40));
}


resistance_edit3(){

ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "com_trashbin01" || ent.model == "ch_curtain01" || ent.model == "com_tv1_cinematic" || ent.model == "com_recyclebin01") {
			//iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}
	}
	
	moveac130position((2856, 742, 2200));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (3679.98, 1887.47, 20.7);
	mp_global_intermission.angles = (-16, 230, 0);
	
	level.meat_playable_bounds = [
		(4161.98, 1943.39, 500),
		(2047, 1974, 500),
		(2047, -652.875, 500),
		(2318, -652.875, 500),
		(2318, -481, 500),
		(2566, -481, 500),
		(2558.63, -1639, 500),
		(3324.24, -1639.41, 500),
		(3350, 344, 600),
		(3779, 870, 600),
		(3774.6, 1177.68, 500),
		(4161.98, 1177.68, 500)
	];
	createPolygon();
	
	//update
	spawncrate((3357, 960, 25) , (0, 22, 0));//wall skip block
	spawncrate((3299, 940, 25) , (0, 13, 0));//wall skip block
	spawncrate((3227, 926, 25) , (0, 9, 0));//wall skip block
	for(i = 0;i < 2;i++)//wall skip block
	spawncrate((3088, 921, 25)+(70*i,0,0) , (0, 0, 0));//wall skip block
	spawncrate((3764, 1021, 567), (90, 0, 0));
	spawnmodel((3489, 407, 642) , (0, 50, 0) , "mil_razorwire_long_static");
	spawnmodel((3688, 637, 652) , (0, 50, 0) , "mil_razorwire_long_static");
	spawnmodel((3339, 320, 646) , (-5, -83, 0) , "ch_sign_noentry");
	spawnmodel((3755, 1953, 634) , (-5, -308, 0) , "ch_sign_noentry");
	fufalldamage((3053, 901, -26), 1400, 750);
	
	spawnmodel((2642, 129, 497) , (0, 0, 0) , "roof_03_12w_front");//cps fix
	

	spawnmodel((3093, 107, 695) , (14, 0, 0) , "parachute_ground_static_1");

	spawnmodel((2333, -2815, 98) , (0, -47, -180) , "bldgbody_01_12w10h_bg");//oom detail
	spawnmodel((3465, 1960, 670) , (0, 0, 0) , "mil_razorwire_long_static");
	CreateDeathRegion((3796.89, 1902, 668),(3262.6, 2283, 870));
 
 
	spawnmodel((2261, 1873, 60) , (-90, -90, 0) , "roof_04_chimney_01"); //START WALLS
	spawnmodel((2264, 1969, 63) , (-90, -90, 0) , "roof_04_chimney_01");
	spawnmodel((2241, 1877, 25) , (0, 0, 90) , "bldgbody_01_cornice_04");
	spawnmodel((2244, 1878, 25) , (0, 0, 90) , "bldgbody_01_cornice_04");
	for(i = 0;i < 2;i++)
	spawncrate((2260, 1882, 25)+(0,0,98*i) , (90, 0, 0));
	spawncrate((2260, 1924, 25) , (90, 0, 0));
	spawnmodel((2810, 1750, 50) , (-90, -270, 0) , "roof_04_chimney_01");//WALL 2
	spawnmodel((2830, 1746, 16) , (0, -180, 90) , "bldgbody_01_cornice_04");
	spawnmodel((2827, 1747, 16) , (0, -180, 90) , "bldgbody_01_cornice_04");
	for(i = 0;i < 2;i++)
	spawncrate((2809, 1741, 25)+(0,0,89*i), (90, 0, 0));
	for(i = 0;i < 2;i++)
	spawncrate((2809, 1704, 25)+(0,0,89*i), (90, 0, 0));
	
    spawnmodel((2245, 1868, -7) , (0, 90, 0) , "newspaper_kiosk_poster_skinny_01");
	spawnmodel((3374, 1232, 60) , (0, 89, -1) , "gaslamp");
	spawnmodel((2845, 1712, -37) , (6, 87, -1) , "com_bicycle_urban_black");
	spawnmodel((2261, 1868, 124) , (0, -90, 0) , "ch_street_wall_light_01_off");
	spawnmodel((2829, 1755, 142) , (0, -85, 0) , "com_wallchunk_brickwallcorner02");
	spawnmodel((2792, 1756, -44) , (0, -94, 0) , "com_wallchunk_brickwallcorner01");
	
	//wall near door
	spawnmodel((3568, 1025, 26) , (-180, -180, 0) , "roof_04_chimney_01");
	spawnmodel((3749, 1025, 26) , (-180, -180, 0) , "roof_04_chimney_01");
	spawnmodel((3609, 1045, 22) , (0, -90, 0) , "bldgbody_01_cornice_04");
	spawnmodel((3609, 1042, 21) , (0, -90, 0) , "bldgbody_01_cornice_04");
	spawnmodel((3726, 1027, -21) , (0, 0, 0) , "foliage_hedge_wallmodularmid_1");
	spawnmodel((3726, 1027, -68) , (0, 0, 0) , "foliage_hedge_wallmodularmid_1");
	spawnmodel((3650, 1027, -21) , (0, 180, 0) , "foliage_hedge_wallmodularmidendcap_1");
	spawnmodel((3650, 1027, -68) , (0, 180, 0) , "foliage_hedge_wallmodularmidendcap_1");
	spawnmodel((3592, 1045, 5) , (45, 0, 0) , "paris_traffic_symbol_02");
	for(i = 0;i < 5;i++)
	spawncrate((3517, 1024.6, 3) + (60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 3;i++)
	spawnmodel((3544, 984, -75)+(90* i,0,0) , (0, 0, 0) , "foliage_hedge_wallmodularmid_1");
	for(i = 0;i < 4;i++)
	spawncrate((3513, 982, -30)+(70* i,0,0) , (0, 0, 0));
	
	//inf cover 3
	spawnmodel((3354, 1213, -37) , (0, 90, 90) , "bldgbody_01_cornice_04");
	spawnmodel((3358, 1233, -3) , (-90, 0, 1) , "roof_04_chimney_01");
	spawnmodel((3355, 1217, -37) , (0, 90, 90) , "bldgbody_01_cornice_04");
	spawncrate((3335, 1234, 4) , (0, 0, 0));
	spawncrate((3335, 1234, 74) , (0, 0, 0));
	spawncrate((3335, 1231, 4) , (0, 0, 0));
	spawncrate((3335, 1231, 74) , (0, 0, 0));
	
	spawncrate((3428, 1312, -20) , (0, 0, 0));//tree
	spawncrate((3428, 1360, -20) , (0, 0, 0));//tree
	spawncrate((3448, 1312, -20) , (0, 0, 0));//tree
	spawncrate((3448, 1360, -20) , (0, 0, 0));//tree
	spawnmodel((3440, 1337, 0) , (0, -105, 0) , "ac_prs_prp_tree_oak_single1");
	spawnmodel((3438, 1335, -48) , (0, 0, 0) , "paris_planter_round");
	
	//doorskip block (maybe add later)
	spawncrate((3261, 1156, 52) , (90, -90, -90));

	spawnmodel((3445, 425, 3) , (0, 0, 0) , "foliage_hedge_wallmodularmid_1");
	spawncrate((3416, 439, 70) , (90, -90, -90));
	CreateDeathRegion((3332.8, 410.82, -5),(3776, -273, 40)); 
 
    //final tp
	createHiddenTP((2427, -520, -130), (2944, -1420, 720), (0, 90, 0), undefined, 1, 120, 250, 30);
	for(i = 0;i < 3;i++)
    spawnmodel((2490, -1027, 32)+(-60*i,0,0) , (0, 0, 0) , "com_bollard_metal_01");
    spawnmodel((2438, -1170, 32) , (0, -83, 0) , "vehicle_delivery_theme_park_truck_destructible");
	
	//final roof
	spawnmodel((2947, -1256, 700) , (0, 0, 0) , "roof_04_chimney_01");
    spawnmodel((3008, 379, 666) , (0, 0, 0) , "roof_04_chimney_01");
	for(i = 0;i < 4;i++)
	spawncrate((3085, 379, 742)+ (-52* i,0,0) , (0, 90, 0));
	/*
	spawnmodel((2947, -784, 700) , (0, 180, 0) , "roof_04_chimney_01");
	for(i = 0;i < 4;i++)
	spawncrate((3024, -783, 763)+ (-52* i,0,0) , (90, 0, 0));
	spawncrate((3024, -783, 690), (90,0,0));
	spawncrate((2868, -783, 690), (90,0,0));
	*/
	for(i = 0;i < 4;i++)
	spawncrate((3024, -1255, 763)+ (-52* i,0,0) , (90, 0, 0));
	spawncrate((3024, -1255, 690), (90,0,0));
	spawncrate((2868, -1255, 690), (90,0,0));

    //mid roof cover
	spawnmodel((2694, 1438, 468) , (0, 90, 0) , "roof_04_chimney_01");
	for(i = 0;i < 4;i++)
	spawncrate((2694, 1359, 544)+ (0,60* i,0) , (0, 0, 0));
	
	for(i = 0;i < 17;i++)
	spawncrate((2345, 1567, 575) + (60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 10;i++)
	spawncrate((2345, 1567, 674) + (60* i,0,0), (90, 0, 0)); 
	CreateDeathRegion((2319, 1561, 190),(3272, 1683, 640));
	
	createHiddenTP((2289, 1446, 546), (2319, 1122, -22), (0, 320, 0), undefined, 1, 50, undefined, 30);
	
	//roof block
	spawnmodel((3767, 1103, 504) , (0, 0, 0) , "roof_04_window_tower_01");
	spawnmodel((3811, 1229, 639) , (0, -213, 0) , "ch_sign_noentry");
	for(i = 0;i < 7;i++)
	spawncrate((3870, 1174, 700) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 7;i++)
	spawncrate((3870, 1174, 601) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 5;i++)
	spawncrate((3750, 1174, 502) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 5;i++)
	spawncrate((3750, 1174, 403) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 10;i++)
	spawnmodel((4141, 1880, 780)+(0,-72* i,0) , (0, 90, 0) , "paris_window_bars_07");
	for(i = 0;i < 12;i++)
	spawncrate((4159, 1890, 760) + (0,-60* i,0), (90, 90, 0)); 
	CreateDeathRegion((3673, 1207, 720),(3807, 1043, 830));

	//gutter pipe
	spawnmodel((3242, 1396, 505) , (92, 3, 0) , "paris_chase_building_middle_gutter01");
	spawnmodel((3296, 1378, 507) , (92, 1, 0) , "paris_chase_building_middle_gutter01");
	for(i = 0;i < 6;i++)
	spawncrate((3706, 1404, 490) + (-83* i,-3* i,3* i), (2, 1, 0));
	createHiddenTP((3756, 1896, -38), (4112.9, 1877.76, 718), (-0, 250, 0), undefined, 1, undefined, undefined, 30 );

	createTP((-2082, 158, 187), (2193, 1960,  -20), (-0, 270, 0), undefined);
	createTP((1618, 584, -15), (2193, 1960,  -20), (-0, 270, 0), undefined);
	createTP((-1159, 1554, 226), (2193, 1960,  -20), (-0, 270, 0), undefined);
	createTP((611, -594, 3), (2193, 1960,  -20), (-0, 270, 0), undefined);
	createTP((-1071, -620, 49), (2193, 1960, -20), (-0, 270, 0), undefined);
	createTP((687, 1799, -28), (2193, 1960, -20), (-0, 270, 0), undefined);

	CreateDoors((3040, 1045, 90) /*open*/, (3040, 1045, 0)/*close*/, (90,90,90) /*angle*/, 4 /*size*/, 2 /*height*/, 50 /*hp*/, 55 /*range*/, 1 /*sideways*/);
	
	//roof hints
	spawnmodel((3547, 421, 647) , (0, -73, 0) , "ch_sign_noentry");
	spawnmodel((2589, -321, 543) , (0, -90, 0) , "berlin_sign_txt_ahb_d");
	spawnmodel((2589, -435, 542) , (0, -90, 0) , "berlin_sign_txt_ahb_l");
	spawnmodel((2591, -570, 543) , (0, -90, 0) , "berlin_sign_txt_ahb_e");
	
}


downturn_edit1(){
	moveac130position((4000, 1285, 1500));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (3499, 1344, 1425);
	mp_global_intermission.angles = (33, 1, 0);

		ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "berlin_traffic_signal_2x_01_green_on" || ent.model == "berlin_traffic_signal_2x_01_off" || ent.model == "vehicle_taxi_yellow_destructible_dusty" || ent.model == "com_filecabinetblackclosed" || ent.model == "ma_flatscreen_tv_on_wallmount_02_static" || ent.model == "prop_photocopier_destructible_02" || ent.model == "com_pipe_4x256_gas" || ent.model == "vehicle_taxi_rooftop_ad_base" || ent.model == "vehicle_taxi_rooftop_ad_1" || ent.model == "vehicle_taxi_rooftop_ad_3" || ent.model == "vehicle_taxi_rooftop_ad_4" || ent.model == "vehicle_taxi_rooftop_ad_2" || ent.model == "vehicle_taxi_toplight" ) {
	 //iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
		}
	}
	
	
	spawnmodel((4480, 1890, 1028) , (0, 0, 0) , "com_warning_sign");
	spawnmodel((1719, 2758, 1623) , (5, -125, 0) , "handicapsign_01");
	spawnmodel((5381, 2222, 969.4) , (0, 90, 0) , "ny_manhattan_building_electricalboxunit_e");
	spawnmodel((4751, 2222, 969.4) , (0, 90, 0) , "ny_manhattan_building_electricalboxunit_e");
	spawnmodel((5378, 1677, 1181) , (-90, -90, 0) , "ny_manhattan_building_electricalboxunit_e");
	spawnmodel((5363, 2101, 1085) , (0, 0, 0) , "ex_window_volksbank_facade_small");
	spawnmodel((5379, 2020, 1021) , (0, 0, 0) , "ny_manhattan_building_electricalboxunit_d");
	
	for(i = 0;i < 11;i++)
	spawncrate((5995, 2205, 1035) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 8;i++)
	spawncrate((5207, 1801, 1149) + (-60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 3;i++)
	spawncrate((4762, 1801, 1149) + (0,-60* i,0), (90, 0, 0)); 
	for(i = 0;i < 3;i++)
	spawncrate((4762, 1801, 1049) + (0,-60* i,0), (90, 0, 0)); 
	for(i = 0;i < 4;i++)
	spawncrate((5243, 1999, 1149) + (0,-60* i,0), (90, 90, 0)); 
	for(i = 0;i < 2;i++)
	spawncrate((5303, 1997.5, 1149) + (60* i,0,0), (90, 0, 0)); 
	for(i = 0;i < 4;i++)
	spawncrate((5378, 2033, 1149) + (0,60* i,0), (90,90, 0)); 
	
	CreateInvisGrids((5034, 1989, 1087),(5216, 1843, 1087), (0,0,0));
	CreateInvisGrids((5082, 2199, 1087),(5336, 2041, 1087), (0,0,0));
	
	spawnmodel((4184, 1966, 931) , (0, 90, 90) , "concrete_slabs_lrg1");
	spawnmodel((4182, 1767, 982) , (90, 85, 90) , "concrete_slabs_lrg1");
	
	//box cover

	//spawnmodel((4503, 3020, 999) , (0, -90, 0) , "berlin_rooftop_utilitybox");
	spawnmodel((4503, 2131, 987) , (0, -90, 0) , "berlin_rooftop_utilitybox");
	spawnmodel((4503, 2231, 987) , (0, -90, 0) , "berlin_rooftop_utilitybox");

    for(i = 0;i < 4;i++)
	spawncrate((4495, 2104, 1051) + (0,51* i,0), (90,90, 0)); 
	for(i = 0;i < 4;i++)
	spawncrate((4509, 2104, 1051) + (0,51* i,0), (90,90, 0)); 
	CreateInvisWalls((4190, 1680, 1060),(4190, 2080, 1060));
	CreateInvisWalls((4190, 1680, 999),(4190, 2080, 999));
	
	//Bridge
	
	spawnmodel((4509, 1051, 874) , (-163, -90, 0) , "berlin_hotel_metalawning_01");
	spawnmodel((4510, 1447, 995) , (-163, -90, 0) , "berlin_hotel_metalawning_01");
	
	CreateInvisRamps((4460,1625,1040), (4460,1015,855)); //ramp small
	CreateInvisRamps((4387,1625,1040), (4387,1015,855)); //ramp small
	CreateInvisRamps((4460,949,840), (4460,905,815)); //ramp small2
	CreateInvisRamps((4387,949,840), (4460,905,815)); //ramp small2
	
	//pipe
	
	spawnmodel((4499, 1667, 1021) , (90, 0, 0) , "com_railpipe_med_05_d");
	spawnmodel((4426, 1666, 1023) , (90, 180, 0) , "com_railpipe_med_05_d");
	CreateInvisWalls((4190, 1665, 1010),(4720, 1665, 1010));
	
	CreateDoors((5040, 3445, 1040) /*open*/, (5040, 3650, 1040) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateWalls((5040, 3760, 1080),(5040, 3760, 990),(0,90,90));
 
	spawnmodel((3219, 2370, 1336) , (0, 90, 40) , "ex_victory_column_statue");
	createTurret((3260, 2370, 1395), (0,0,0), 60, 18, 30, 0, 10);
	spawncrate((3245, 2373, 1357) , (-24, 0, 0));
	cannonball((4584, 566, 968), (0,0,0), 3, (4556, 1768, 1058), 900);

	createTP((2423, 1104, 92), (4227, 263, 1028), (4, 88, 0));
	createTP((-555, 161, 229), (4227, 263, 1028), (4, 88, 0));
	createTP((-555, 161, 69), (4227, 263, 1028), (4, 88, 0));
	createTP((257, -971, -175), (4227, 263, 1028), (4, 88, 0));
	createTP((257, -971, 39), (4227, 263, 1028), (4, 88, 0));
	createTP((1533, 901, 86), (4227, 263, 1028), (4, 88, 0));
	createTP((-951, -752, -12), (4227, 263, 1028), (4, 88, 0));
	createTP((1483, -493, 88), (4227, 263, 1028), (4, 88, 0));
	createTP((-642, 1256, 57), (4227, 263, 1028), (4, 88, 0));
	createTP((747, 626, -113), (4227, 263, 1028), (4, 88, 0));
	createTP((1061, -1557, 45), (4227, 263, 1028), (4, 88, 0));
	createTP((1169, 1339, 64), (4227, 263, 1028), (4, 88, 0));
	createTP((1169, 1339, -175), (4227, 263, 1028), (4, 88, 0));
	createHiddenTP((5460, 2297, 998.125), (3125, 2620, 1359), (0, -90, 0), undefined, 1,70,150);
	//createHiddenTP((-164.728,2885.13,1590), (4227, 263, 1028), (4, 88, 0), undefined, "out");
	CreateRamps((4460, 3670, 984),(4320, 3670, 900));
	CreateWalls((4195, 2680, 920),(4195, 2930, 990));
	CreateWalls((4480, 3160, 1010),(4480, 3330, 1080));
 
	CreateElevator((2500, 2460, 1344.5),(2445, 2520, 1344.5), 255, 1.25);
	CreateGrids((2370, 2460, 1600),(2370, 2520, 1600), (0,0,0));
	CreateQuicksteps((2325, 2490, 1600), 75, 15, 2, (0,180,0));
	CreateRamps((710, 2670, 1545),(710, 2820, 1592));
	CreateRamps((635, 2950, 1605),(635, 3030, 1628));
	CreateGrids((730, 2885, 1600),(640, 2915, 1600), (0,0,0));
	spawncrate((635, 3065, 1639), (0, 0, 0));
	spawncrate((635, 3100, 1639), (0, 0, 0));
	CreateRamps((570, 2950, 1590),(570, 3030, 1628));
	spawncrate((570, 3065, 1639), (0, 0, 0));
	spawncrate((570, 3100, 1639), (0, 0, 0));
 
	CreateRamps((4410,2200,920), (4410,2100,971));
	moveac130position((3248, 2373, 2044.19));
	CreateDeathRegion((2810, -2000, 0),(7500, 6000, 820));
	CreateDeathRegion((2810, 1760, 0), (-3000, 6000, 740));
	
	CreateDeathRegion((6022, 2222, 1060), (5383, 1991, 1146));
	
	//roof wallbreach
	
	spawncrate((1685.76, 2725, 1664.50), (0,0,0));
	spawncrate((1685.76, 2765, 1664.50), (0,0,0));
	spawncrate((1685.76, 2805, 1664.50), (0,0,0));
	spawncrate((1615.76, 2725, 1664.50), (0,0,0));
	spawncrate((1615.76, 2765, 1664.50), (0,0,0));
	spawncrate((1615.76, 2805, 1664.50), (0,0,0));
}
downturn_edit2(){
	level.meat_playable_bounds = [
		(5039.4, 3772.32, 1006.14),
		(4144.66, 3778.29, 946.134),
		(4138.89, 2636.16, 930.591),
		(3253.97, 2746.42, 1367.14),
		(2388.41, 2923.49, 1551.83),
		(656.537, 2937.14, 1549.51),
		(654.682, 4384.98, 1576.88),
		(-313.498, 4405.47, 1581.92),
		(-225.926, 2840.81, 1584.59),
		(-202.479, 2015.27, 1403.8),
		(675.21, 2019.98, 1367.13),
		(676.296, 2168.03, 1367.13),
		(1096.54, 2171.46, 1425.69),
		(1263.97, 2341.63, 1516.69),
		(1439.73, 2143.69, 1541.34),
		(2350.86, 2156.33, 1345.41),
		(2350.88, 1990.44, 1343.87),
		(3364, 1925.24, 1340.9),
		(4146.37, 2347.17, 902.973),
		(4175.63, 2100.63, 930.127),
		(4178.91, 1650.27, 1074.15),
		(4771.51, 1646.09, 1087.22),
		(5042.83, 3568.56, 1118.13)
	];
	moveac130position((4000, 1285, 1500));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (3693, 1701, 1529);
	mp_global_intermission.angles = (34, 90, 0);
	createPolygon();
	CreateInvisWalls((4762, 1671, 1015),(4763, 1805, 1015));
	CreateInvisWalls((4762, 1671, 1085),(4763, 1805, 1085));
	CreateRamps((4145,2390,903), (3255,2390,1332)); //ramp big
	CreateWalls((5035, 3590, 1090),(5035, 3780, 970));
	cannonball((4450, 2830, 910), (0,90,0), 3, (3153, 2627, 1419), 900);
	createTP((2423, 1104, 92), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((-555, 161, 229), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((-555, 161, 69), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((257, -971, -175), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((257, -971, 39), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((1533, 901, 86), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((-951, -752, -12), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((1483, -493, 88), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((-642, 1256, 57), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((747, 626, -113), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((1061, -1557, 45), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((1169, 1339, 64), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	createTP((1169, 1339, -175), (4935.8, 3644.15, 998.125), (0,180,0), 1);
	//createHiddenTP((-164.728,2885.13,1590), (450.253,1335.79,206.125), undefined, "out");
	CreateRamps((4460, 3670, 984),(4320, 3670, 900));
	CreateWalls((4195, 2680, 920),(4195, 2930, 990));
	CreateWalls((4480, 3160, 1010),(4480, 3330, 1080));
	CreateWalls((4480, 2100, 1010),(4480, 2290, 1080));
	CreateElevator((2500, 2460, 1344.5),(2445, 2520, 1344.5), 255, 1.25);
	CreateGrids((2370, 2460, 1600),(2370, 2520, 1600), (0,0,0));
	CreateQuicksteps((2325, 2490, 1600), 75, 15, 2, (0,180,0));
	CreateRamps((710, 2670, 1545),(710, 2820, 1592));
	CreateRamps((635, 2950, 1605),(635, 3030, 1628));
	CreateGrids((730, 2885, 1600),(640, 2915, 1600), (0,0,0));
	spawncrate((635, 3065, 1639), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((635, 3100, 1639), (0, 0, 0), "com_plasticcase_friendly");
	CreateRamps((570, 2950, 1590),(570, 3030, 1628));
	spawncrate((570, 3065, 1639), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((570, 3100, 1639), (0, 0, 0), "com_plasticcase_friendly");
	CreateWalls((4190, 1680, 1060),(4190, 2080, 980));
	CreateRamps((4410,2200,920), (4410,2100,971));
	moveac130position((3248, 2373, 2044.19));
	CreateDeathRegion((2810, -2000, 0),(7500, 6000, 740));
	CreateDeathRegion((2810, 1760, 0), (-3000, 6000, 740));
	
	//roof wallbreach
	
	spawncrate((1685.76, 2725, 1664.50), (0,0,0));
	spawncrate((1685.76, 2765, 1664.50), (0,0,0));
	spawncrate((1685.76, 2805, 1664.50), (0,0,0));
	spawncrate((1615.76, 2725, 1664.50), (0,0,0));
	spawncrate((1615.76, 2765, 1664.50), (0,0,0));
	spawncrate((1615.76, 2805, 1664.50), (0,0,0));
}
downturn_edit3(){
	level.meat_playable_bounds = [
		(387, 2054, 22),
		(387, 1771, 22),
		(-885, -1023, 22),
		(-885, -3134, 22),
				
		(-2389, -3134, 22),
		(-2389, -2050, 22),
		(-2243, -2048, 22),
		(-2243, -2185, 22),
		(-1608, -2185, 22),
				
		(-1608, -1795, 22),
		(-1969, -1795, 22),
		(-1969, -1138, 22),
		(-2409, -1138, 22),

		(-2403, -695, 22),
		(-2781, -735.5, 22),
		(-2781, 1771, 22),
		(-1824, 1771, 22),
		(-1909, 3488, 22),
		(-1391, 3461, 22),
		(-1352.88, 3382, 22),
		(-217, 3382, 100)
	];
	moveac130position((-1808, -1134, 1500));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	
	random = randomint(2);
		if(random == 0)
			mp_global_intermission.origin = (-1559, -404, 1137);
		else
			mp_global_intermission.origin = (-729, -3264, 1456);
		if(random == 0)
			mp_global_intermission.angles = (-19, -114, 0);
		else
			mp_global_intermission.angles = (10, 135, 0);
	createPolygon();
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "berlin_traffic_signal_2x_01_green_on" || ent.model == "berlin_traffic_signal_2x_01_off" || ent.model == "vehicle_taxi_yellow_destructible_dusty" || ent.model == "com_filecabinetblackclosed" || ent.model == "ma_flatscreen_tv_on_wallmount_02_static" || ent.model == "prop_photocopier_destructible_02" || ent.model == "com_pipe_4x256_gas" || ent.model == "vehicle_taxi_rooftop_ad_base" || ent.model == "vehicle_taxi_rooftop_ad_1" || ent.model == "vehicle_taxi_rooftop_ad_3" || ent.model == "vehicle_taxi_rooftop_ad_4" || ent.model == "vehicle_taxi_rooftop_ad_2" || ent.model == "vehicle_taxi_toplight" ) {
	 //iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
		}
	}
	CreateDeathRegion((-2677, 578, 690), (-3280, 751, 800));
	spawnmodel((-2252, -1866, 1102) , (0, 90, 0) , "ny_manhattan_building_electricalboxunit_e");
	
	spawnmodel((-2377, -2049, 1115), (0, 180, 0), "fence_metal_black");	
	spawnmodel((-2298, -2049, 1115), (0, 180, 0), "fence_metal_black");
	
	for(i = 0;i < 3;i++)
	spawncrate((-2249, -2045, 1167) + (-60* i, 0, 0), (90, 0, 0)); 
    for(i = 0;i < 2;i++)
	spawncrate((-2239, -2117, 1167) + (0, 60* i, 0), (90, 0, 0));  
	for(i = 0;i < 2;i++)
	spawncrate((-2179, -2167, 1167) + (-60* i, 0, 0), (90, 0, 0)); 
	
	i=0;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((-2402, -2093, 1167) + (0, -60* i, 0), (90, 0, 90)); i++;
					
	spawnmodel((-1127, -1551, 1361), (0, 90, 0), "ex_window_volksbank_facade_large"); 
	spawnmodel((-1260, -1312, 1361) , (0, 0, 0) , "ex_window_volksbank_facade_large");
	spawnmodel((-1259, -1420, 1361), (0, 0, 0), "ex_window_volksbank_facade_large"); 
	spawnmodel((-998, -1294, 1361) , (0, 0, 0) , "ex_window_volksbank_facade_large");
	spawnmodel((-999, -1420, 1361), (0, 0, 0), "ex_window_volksbank_facade_large"); 
	spawnmodel((-1389, -1664, 1351), (30, 245, 0), "com_security_camera"); 
	 
	CreateWalls((-1352, 3352, 400),(-257, 3352, 400));
	CreateWalls((-1352, 3352, 340),(-257, 3352, 340));
	CreateWalls((-1352, 3352, 280),(-257, 3352, 280));
	CreateWalls((-1352, 3352, 220),(-257, 3352, 220));
	CreateWalls((-1352, 3352, 160),(-257, 3352, 160));
	CreateInvisWalls((-1397, 3437, 350.693),(-1397, 3197, 350.693));
	CreateInvisWalls((-1397, 3017, 350.693),(-1397, 3167, 350.693));
	CreateInvisWalls((-1397, 3017, 290.693),(-1397, 3197, 290.693));
	
	/*
	i=0;
	spawncrate((-1358, 2687.67, 305) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2687.67, 305) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2687.67, 305) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	i=0;
	spawncrate((-1358, 2327.67, 400) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 390) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 370) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 370) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 370) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 390) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 390) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 390) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2327.67, 390) + (0, 60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	
	i=0;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1358, 2717, 460) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	
	i=0;
	spawncrate((-1390, 2510.67, 355) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++; //
	spawncrate((-1390, 2510.67, 355) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	spawncrate((-1390, 2510.67, 355) + (0, -60* i, 0), (90, 0, 90), "com_plasticcase_friendly"); i++;
	*/
	
	CreateinvisWalls((-1370, 2427, 330.693),(-1370, 2607, 330.693));
	CreateinvisWalls((-1370, 2347, 360.693),(-1370, 2690, 360.693));
	CreateinvisWalls((-1370, 2347, 390.693),(-1370, 2607, 390.693));
	CreateinvisWalls((-1370, 2267, 420.693),(-1370, 3007, 420.693));
	spawncrate((-1338, 2270, 433), (90, 0, 90));
	
	CreateinvisWalls((-1350, 2675, 280),(-1350, 2804, 335));
	
	CreateWalls((-1395, 2692, 260),(-1395, 2804, 260));
	
	spawncrate((-1350, 2788, 384), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((-1350, 2788, 434), (0, 90, 0), "com_plasticcase_friendly");
	
	CreateDoors((-1376, 2907.5, 400) /*open*/, (-1376, 2907.5, 300) /*close*/, (90,8,0) /*angle*/, 4 /*size*/, 3 /*height*/, 60 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	spawnmodel((-1398, 2286, 322.125), (0, 0, 90), "concrete_pillarchunk_lrg_01");
	spawnmodel((-1405, 3184, 313.125), (270, 1, 90), "concrete_pillarchunk_lrg_01");
	spawnmodel((-1410, 3164, 373.125), (90, 181, 90), "concrete_pillarchunk_lrg_01");
	spawnmodel((-1374, 2576, 373.125), (90, 181, 90), "concrete_pillarchunk_lrg_01");	
	spawnmodel((-1348.5, 2795, 333.125), (0, 181, 0), "concrete_pillarchunk_lrg_01");		
	spawnmodel((-1361.92, 2755.72, 343.125), (180, 181, 0), "concrete_pillarchunk_lrg_01");
	spawnmodel((-1348.5, 2777, 363.125), (0, 201, 80), "concrete_pillarchunk_lrg_01");
	spawnmodel((-1363.5, 2681, 400.125), (0, 93, 80), "concrete_slabs_lrg1");
	spawnmodel((-1348.5, 2466, 500.125), (40, 90, 80), "concrete_slabs_lrg1");	
	spawnmodel((-1357.5, 2902, 528.125), (0, 90, 80), "concrete_slabs_lrg1");
	
	//1st area
	spawnmodel((-1604, -1570, 1116.125), (0, 0, 270), "berlin_hotel_metalawning_01");
	spawnmodel((-2176, -1570, 1116.125), (0, 0, 270), "berlin_hotel_metalawning_01");	
	spawnmodel((-1813, -1579, 1258), (0, 180, 0), "berlin_hotel_lights_wall2_on");
	spawnmodel((-1966, -1579, 1258), (0, 180, 0), "berlin_hotel_lights_wall2_on");
	spawnmodel((-1690, -3028, 1110), (0, 90, 0), "berlin_rooftop_utilitybox");
	spawnmodel((-1851, -3028, 1110), (0, 90, 0), "berlin_rooftop_utilitybox");
	spawnmodel((-1683, -1570, 1269), (0, 180, 210), "ny_manhattan_sewer_wires_01");
	spawnmodel((-2090, -1570, 1270), (0, 180, 350), "ny_manhattan_sewer_wires_01");
	spawnmodel((-2390, -1570, 1270), (0, 180, 70), "ny_manhattan_sewer_wires_01");
	spawnmodel((-1677, -1570, 1270), (0, 0, 70), "ny_manhattan_sewer_wires_01");
	spawnmodel((-1390, -1530, 1172), (0, 270, 0), "icbm_electricpanel1");
	spawnmodel((-1390, -1461, 1172), (0, 270, 90), "com_telephone_wall");
	spawnmodel((-1398, -1484, 1172), (0, 180, 0), "com_fire_extinguisher_incase");
	spawnmodel((-1693, -254, 770), (0, 90, 0), "prague_awning02_green");
	CreateDoors((-1708, -1565, 1140.125) /*open*/, (-1890, -1565, 1140.125) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 3 /*height*/, 55 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	spawncrate((-1426, -1562, 1160), (0, 0, 0));
	spawncrate((-1514, -1562, 1160), (0, 0, 0));
	spawncrate((-1602, -1562, 1160), (0, 0, 0));
	spawncrate((-1690, -1562, 1160), (0, 0, 0));
	spawncrate((-1778, -1562, 1160), (0, 0, 0));
	spawncrate((-1426, -1562, 1220), (0, 0, 0));
	spawncrate((-1514, -1562, 1220), (0, 0, 0));
	spawncrate((-1602, -1562, 1220), (0, 0, 0));
	spawncrate((-1690, -1562, 1220), (0, 0, 0));
	spawncrate((-1778, -1562, 1220), (0, 0, 0));
	spawncrate((-1942, -1573, 1250), (0, 0, 0));
	spawncrate((-1854, -1573, 1250), (0, 0, 0));
	/*
	spawncrate((-1639, -2450, 1160), (0, 90, 0));
	spawncrate((-1639, -2370, 1160), (0, 90, 0));
	spawncrate((-1639, -2290, 1160), (0, 90, 0));
	spawncrate((-1639, -2210, 1160), (0, 90, 0));
	spawncrate((-1914, -3026, 1160), (0, 90, 0));
	spawncrate((-1914, -3100, 1160), (0, 90, 0));
	*/
	spawncrate((-1999, -1780, 1170), (90, 90, 0));
	spawncrate((-1999, -1720, 1170), (90, 90, 0));

	CreateQuicksteps((-1403, -1356, 1370), 280, 18, 2, (0,180,0));
	fufalldamage((-1300, -1476, 1100.125), 600, 300);
	fufalldamage((-1850, -245, 590.125), 400, 527);
	//hole patches
	CreateGrids((-1530, 3460, 387.152),(-1669, 3460, 384.693), (0,0,0));
	spawncrate((-1656, 3425, 384.693), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-270, 3322, 180.693), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-454, 1881, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-454, 1931, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-454, 1981, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-534, 1881, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-534, 1931, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-544, 1981, 65), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-454, 2121, 62), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-514, 2121, 62), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-454, 2161, 59), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-558, 2060, 62), (0, 90, 0), "com_plasticcase_friendly");
	createTP((2423, 1104, 92), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((-555, 161, 229), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((-555, 161, 69), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((257, -971, -175), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((257, -971, 39), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((1533, 901, 86), (-1846,-3018.48,1120.13), (0,180,0), 1);
	createTP((-951, -752, -12), (-1846,-3018.48,1120.13), (0,180,0), 1);
	createTP((1483, -493, 88), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((-642, 1256, 57), (-1846,-3018.48,1120.13), (0,180,0), 1);
	createTP((747, 626, -113), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((1061, -1557, 45), (-1846,-3018.48,1120.13), (0,180,0), 1);
	createTP((1169, 1339, 64), (-1846,-3018.48,1120.13), (0,0,0), 1);
	createTP((1169, 1339, -175), (-1846,-3018.48,1120.13), (0,180,0), 1);
	spawnmodel((87.6, 1954, 190.125), (0, 170, 14), "concrete_pillarchunk_lrg_01");
	createTurret((-1390, 2175, 335), (0,0,0), 50, 50, 30, 10, 10);
	//1st flag delayed spawn
	createHiddenTP((-1333, -1085, 1382), (-1220, -429, 1181.13), (0,150,0), undefined, 1, 10, undefined, 100);
	spawnmodel((-1661, -500, 1155), (27, 152, 0), "usa_sign_oneway2_right");
	spawnmodel((-1735, -121, 1180), (313, 0, 0), "usa_sign_oneway2_left");
	spawnmodel((-1751, -121, 1110), (270, 0, 0), "usa_sign_oneway2_left");
	spawnmodel((-1751, -121, 1040), (270, 0, 0), "usa_sign_oneway2_left");
	spawnmodel((-1666, -496, 1065), (70, 0, 0), "hind_arena_safenet_pole");
	//2nd
	createHiddenTP((-2728, -35, 590), (251.762, 1995.88, 160.13), (0,188,0), undefined, undefined, undefined, undefined, 115);
	createHiddenTP((-1270.96, 1814, 90), (-2321, -1095, 1116), (0,-5,0), undefined, 1, undefined, undefined, 115);
	spawncrate((-1240, -462.5, 1140), (0, 0, 0));
 	spawncrate((-1240, -402.5, 1140), (0, 0, 0));
 	spawncrate((-1240,  -342.5, 1140), (0, 0, 0));
	CreateDeathRegion((-1569, -1600, -100), (-3493, 46, 200));
	spawncrate((-1155,  -525.5, 1155), (0, 90, 0));
	spawncrate((-1155,  -525.5, 1185), (0, 90, 0));
	spawncrate((-1150,  -196.5, 1175), (90, 0, 0));
	spawncrate((-1418,  -180.5, 1192), (0, 0, 0));
	spawncrate((-1490,  -180.5, 1192), (0, 0, 0));
	spawncrate((-1490,  -180.5, 1162), (0, 0, 0));
	spawncrate((-1690,  -269, 1162), (90, 0, 0));
}
fallen_edit1(){
	level.meat_playable_bounds = [
		(-1946, -4857, 177.125),
		(-1051, -4856, 122.807),
		(-1037, -4312, 115.514),
		(-1000, -4312, -152.718),
		(-1000, -2303, -152.875),
		(-2034, -2290, -152.875),
		(-2099, -2963, -61.937),
		(-1977, -2970, 60.603),
		(-1945, -4053, -149.627),
		(-2415, -4046, -152.875),
		(-2419, -4658, -63.3313),
		(-1935, -4651, 25.7954)
    ];
	createPolygon();
	moveac130position((-1586, -4186, -246));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1274, -3128, -237);
	mp_global_intermission.angles = (-22, -126, 0);
	//ents
	spawnmodel((-2237, -4554, -220) , (0, 0, 0) , "com_propane_tank02");
	spawnmodel((-1369, -4300, -246.875) , (0, 90, 0) , "junk_crushedcars_1");
	//No way its all walls
	CreateWalls((-2410, -4637, -240),(-2410, -4052, -240));
	CreateWalls((-2410, -4637, -180),(-2410, -4052, -180));
	CreateWalls((-2380, -4052, -240),(-1978, -4052, -240));
	CreateWalls((-2380, -4052, -180),(-1978, -4052, -180));
	CreateWalls((-2095, -4668, -240),(-1956, -4668, -240));
	CreateWalls((-2095, -4668, -180),(-1956, -4668, -180));
	CreateWalls((-1978, -3813, -240),(-1978, -2992, -240));
	CreateWalls((-1978, -3813, -180),(-1978, -2992, -180));
	CreateWalls((-995, -3478, -240),(-995, -2325, -240));
	CreateWalls((-995, -3478, -180),(-995, -2325, -180));
	CreateWalls((-1026, -2295, -240),(-2039, -2295, -240));
	CreateWalls((-1026, -2295, -180),(-2039, -2295, -180));
	CreateWalls((-1001, -4312, -240),(-1001, -3703, -240));
	CreateWalls((-1001, -4312, -180),(-1001, -3703, -180));
	CreateWalls((-1913, -4857, -240),(-1071, -4857, -240));
	CreateWalls((-1913, -4857, -180),(-1071, -4857, -180));
	CreateWalls((-1873, -4090, -240),(-1668, -4090, -160));
	CreateWalls((-1667, -4110, -240),(-1667, -4650, -160));
	CreateWalls((-1637, -4650, -240),(-1311, -4650, -240));
	CreateWalls((-1637, -4650, -185),(-1311, -4650, -185));
	//solid wall for hiding
	CreateWalls((-1100, -3800, -240),(-1220, -3800, -160));
	//CreateQuicksteps((3940,680,-100), 200, 20, 20, (0, 173.766, 0));
	CreateQuicksteps((-1775, -2513, -75), 190, 18, 2, (0,-6.30,0));
	CreateGrids((-1400, -2700, -109),(-1545, -2620, -109), (0,0,0));
	fufalldamage((-1586, -4186, -246.875), 2000, 100);
	CreateGrids((-1700, -4317, -160),(-1780, -4655, -160), (0,0,0));
	//Turret
	spawncrate((-1441, -2866, 10), (90, -96.87622, 0), "com_plasticcase_trap_friendly");
	createTurret((-1441, -2866, 45), (0,-96.87622,0), 25, 25, undefined, -5, 10);
	//player cannons
	cannonball((-1545, -2650, -100), (0,90,0), 1, (-1552, -3796, 295), 300);
	cannonball((-1471, -2650, -100), (0,90,0), 1, (-1552, -4305, 295), 300);
	cannonball((-1400, -2650, -100), (0,90,0), 1, (-1551, -4835, 295), 300);
	//El Doorado
	CreateDoors((-1312, -4752, -150) /*open*/, (-1312, -4752, -230) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 1 /*sideways*/);
	
	createTP((-1025, -712, -191), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((1445, -1066, -175), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((-1034, 1155, -249), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((1276, 2643, -273), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((200, 2247, -239), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((1866, 897, -324), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((394, -1378, -247), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((2861, -339, -260), (-2235, -4557, -258.647), (0, 48, 0));
	createTP((420, 509, -255), (-2235, -4557, -258.647), (0, 48, 0));
	//createHiddenTP((-1972, -2395, -112.897), (1184, 720, -126.649), (0, 0, 0), "out");
}
fallen_edit2(){
	level.meat_playable_bounds =
	[
	(2864.33, 1425.65, -209.659),
	(3024.51, 1652.24, -227.132),
	(3191.99, 1780.99, -227.784),
	(3531.29, 1927, -216.43),
	(4476.12, 2267.53, -192.875),
	(4990.12, 2509.05, -192.875),
	(5113.32, 1987.7, -192.875),
	(4729.65, 1921.87, -192.875),
	(4729.75, 120.1, -192.875),
	(5011.55, -248.1, -192.875),
	(5011.55, -716.1, -192.875),
	
	(3662.82, -716.1, -186.928),
	(3156.71, 811.257, -153.779),
	(3145, 1212.25, -217.654)
	];
	createPolygon();
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2757.24, 1817, -153);
	mp_global_intermission.angles = (12, 345, 0);
	
	//models
	
	spawncrate((3886, -1, -160) , (0, 70, 0)); //stuckfix
	
	//roof
	spawnmodel((4139.96, 1121.9, 154), (0, 4, 0), "mil_razorwire_long_static");
	spawnmodel((3805.96, 1141.9, 164), (0, 0, 60), "mil_razorwire_long_static");
	spawnmodel((4437.33, 1122, 157), (0, 90, 50), "mil_razorwire_long_static");

	//EFFICIENT INVIS WALLS
	i=0;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	spawncrate((4551, 1118, 214) + (-60* i, 0, 0), (90, 0, 0)); i++;
	
	//spawnmodel((4436.92, 1225.88, 156), (0, 90, 0), "com_airduct_02");
	//spawnmodel((4429.7, 841.88, 156), (0, 90, 0), "com_airduct_02");
	
	spawnmodel((4300.7, 1339.88, 157), (0, 211, 0), "sentry_grenade_launcher");
	
	//ladder
	spawnmodel((4121.96, 921, 10), (3, 0, 0), "com_ladder_wood");
	spawnmodel((4119.96, 921, -81), (3, 0, 0), "com_ladder_wood");		
	CreateInvisQuicksteps((4148, 920, 150), 244, 18, 1, (0,180,0));
	//bush
	spawnmodel((4439, 529, -290), (0, 0, 0), "lam_hedge_boxy_overgrown2");
	spawnmodel((4449, 330, -290), (0, 0, 0), "foliage_hedge_boxy_overgrown3");
	spawnmodel((4429, 130, -320), (0, 10, 0), "foliage_hedge_boxy_overgrown3");
	spawnmodel((4439, -60, -290), (0, 0, 0), "foliage_hedge_boxy_overgrown3");
	spawnmodel((4250, 375, -340), (0, 20, 0), "foliage_hedge_boxy_overgrown3");
	spawnmodel((4461, -103, -300), (0, 0, 0), "foliage_lam_tree_beech_1"); 
	
	//EFFICIENT INVIS WALLS bush
	i=0;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((4501, 285, -200) + (0, 60* i, 0), (90, 0, 90)); i++;
	
	//pipes
	spawnmodel((4045.9, -265, -97), (-107, 180, 0), "lam_smokestack01");
	spawnmodel((3888.9, -288, -202), (0, 0, -93), "lam_smokestack01");
	spawnmodel((3938.51, 356, -204), (0, 180, -90), "lam_smokestack01");
	spawnmodel((3868.51, -266, -296), (30, 0, 0), "building_damage_generic_01");
	
	i=0;
	spawncrate((3938.51, 437.464, -143) + (0, -70* i, 0), (0, 90, 0)); i++;
	spawncrate((3938.51, 437.464, -143) + (0, -70* i, 0), (0, 90, 0)); i++;
	spawncrate((3938.51, 437.464, -143) + (0, -70* i, 0), (0, 90, 0)); i++;
	spawncrate((3938.51, 437.464, -143) + (0, -70* i, 0), (0, 90, 0)); i++;
	spawncrate((3938.51, 437.464, -143) + (0, -70* i, 0), (0, 90, 0)); i++;
	i=0;
	spawncrate((3901.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 330)); i++;
	spawncrate((3901.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 330)); i++;
	spawncrate((3901.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 330)); i++;
	spawncrate((3901.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 330)); i++;
	//spawncrate((3901.51, 447.464, -157) + (0, -73* i, 0), (18, 120, 334)); i++; //cringeold
	spawncrate((3891.51, 467.464, -164) + (0, -73* i, 0), (18, 120, 334)); i++; //cringe

	i=0;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	spawncrate((3975.51, 437.464, -157) + (0, -73* i, 0), (0, 90, 30)); i++;
	
	i=0;
	spawncrate((3889.12, -370, -140) + (0,70* i, -3.5* i), (3, 90, 0)); i++;
	spawncrate((3889.12, -370, -140) + (0,70* i, -3.5* i), (3, 90, 0)); i++;
	spawncrate((3889.12, -370, -140) + (0,70* i, -3.5* i), (3, 90, 0)); i++;
	spawncrate((3889.12, -370, -140) + (0,70* i, -3.5* i), (3, 90, 0)); i++;
	spawncrate((3889.12, -370, -140) + (0,70* i, -3.5* i), (3, 90, 0)); i++;
		
	spawncrate((3926.12, -370, -154), (3, 90, 30));
	
	spawncrate((3926.12, -127, -166), (3, 90, 30));
	spawncrate((3926.12, -197, -162.5), (3, 90, 30));
	
	i=0;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	spawncrate((3851.12, -370, -154) + (0,73* i, -3.7* i), (3, 90, 330)); i++;
	
	//first ramp pipe
	
	i=0;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	spawncrate((4300.91, -264.474, -265) + (-70* i, 0, 21.5* i), (17, 0, 0)); i++;
	
	i=0;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	spawncrate((4300.91, -310.474, -255) + (-70* i, 0, 21.5* i), (17, 0, -30)); i++;
	
	i=0;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	spawncrate((4300.91, -218.474, -255) + (-70* i, 0, 21.5* i), (17, 0, 30)); i++;
	
	//CreateWalls((4300.91, -350.474, -205),(3944, -350, -30));
	CreateInvisWalls((4300.91, -350.474, -205),(4185, -350.2, -116));
	CreateInvisWalls((4185, -350.2, -150),(3944, -350, -50));
	
	CreateInvisWalls((4300.91, -183.474, -205),(4185, -183.2, -116));
	CreateInvisWalls((4185, -183.2, -150),(3944, -183, -50));
	
	

	//pipe bridge
	
	spawnmodel((3957, 583.3, -96.5), (13, 260, 0), "com_pipe_4x256_metal_rusted");
	spawnmodel((3970, 583.3, -96.5), (13, 260, 0), "com_pipe_4x256_metal_rusted");
	spawnmodel((3935.15, 458.826, -125), (13, 260, 0), "com_pipe_4_coupling_metal_rusted");
	spawnmodel((3948.13, 459, -125), (13, 260, 0), "com_pipe_4_coupling_metal_rusted");
	spawnmodel((3991.81, 706, -67), (-13, 80, 0), "com_pipe_4_coupling_metal_rusted");
	spawnmodel((3978.95, 706.67, -67), (-13, 80, 0), "com_pipe_4_coupling_metal_rusted");
	i=0;
	spawncrate((3975.31, 653.362, -93) + (-11.44* i, -70.891* i, -16.6* i), (13, 260, 0)); i++;
	spawncrate((3975.31, 653.362, -93) + (-11.44* i, -70.891* i, -16.6* i), (13, 260, 0)); i++;
	spawncrate((3975.31, 653.362, -93) + (-11.44* i, -70.891* i, -16.6* i), (13, 260, 0)); i++;
	spawncrate((3975.31, 653.362, -93) + (-11.44* i, -70.891* i, -16.6* i), (13, 260, 0)); i++;
	spawncrate((3984.16, 699.89, -98), (90, 260, 0));
	
	//ladder bridge 
	
	spawnmodel((3882.9, -39.4, -142), (85, 68, 0), "com_ladder_wood");	
	
	spawncrate((3895.2, -8.63, -153), (-4, 68, 0));
	spawncrate((3915.89, 42.9992, -149.5), (-4, 68, 0));
	spawncrate((3936.76, 94.3502, -145.6), (-4, 68, 0));
	//spawncrate((3910.38, 104.3502, -145.6), (-4, 68, 0));
	spawncrate((3938.3, 126.7, -145.6), (0, 0, 0));
	//fence
	spawnmodel((5030, 2269, -274), (2, 94, 3), "com_barrier_tall1");
	spawncrate((5030, 2241, -235),(90,90,0));
	spawncrate((5030, 2301, -235),(90,90,0));
	
	spawncrate((4267, 2188, -235),(0,108,0));//wallbreach
	
	i=0;
	spawnmodel((4720, 1800, -255) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -255) + (0, -128* i, 0), (0, 1, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -255) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -255) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -261) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -255) + (0, -128* i, 0), (0, 2, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, -1, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4720, 1800, -253) + (0, -128* i, 0), (0, 0, 0), "ch_post_fence_128"); i++;
	spawnmodel((4728, 1927, -255), (0, 285, 0), "ch_post_fence_128"); 
	
		
	spawnmodel((4854, 1958.88, -255), (0, 280, 0), "ch_post_fence_128"); 
	spawnmodel((4980.29, 1975.58, -255), (0, 280, 0), "ch_wooden_fence_post_03"); 
	spawnmodel((5094, 1976.88, -275), (10, 100, 10), "ch_post_fence_128"); 
	
	i=0;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	spawncrate((4736, 1909, -223) + (0, -60* i, 0), (90, 0, 90)); i++;
	CreateInvisWalls((4834.68, 1939, -220), (4744.83, 1915.33, -220));
	CreateInvisWalls((5103.74, 1988.9, -220), (4856.27, 1943.17, -220));
	
	
	//stop signs
	
	spawnmodel((4402, 2327, -220), (0, 0, 10), "ch_sign_noparking"); 
	spawnmodel((4731, 2449, -250), (15, 0, 0), "ch_sign_noparking"); 
	spawnmodel((4927, -865, -260), (7, 190, 0), "ch_sign_noparking"); 
	spawnmodel((4479, -858, -270), (2, 180, 3), "ch_sign_noparking"); 
	
	//ladder2
	
	CreateInvisQuicksteps((3647, 1535, -205), 110, 17, 2, (0,-130,0));
	
	spawnmodel((3628.46, 1512.81, -300), (5, 50, 0), "com_ladder_wood");
	spawnmodel((3641.44, 1518.61, -294), (3, 20, -10), "foliage_tree_birch_red_1");
	
	//bush block
	
	spawncrate((3785, 799, -240), (90, 0, 90)); 
	spawnmodel((3749, 737.79, -297), (355, 10, 357), "foliage_afr_tall_bush_01a");
	
	
	//high ground
	
	spawnmodel((3706, 1168, -76), (0, 0, 90), "me_corrugated_metal8x8");
	spawnmodel((3611, 1168, -76), (0, 0, 90), "me_corrugated_metal8x8");
	spawnmodel((3516, 1168, -76), (0, 0, 90), "me_corrugated_metal8x8");
	
	spawnmodel((3706, 1052, -76), (0, 0, 90), "me_corrugated_metal8x8");
	spawnmodel((3611, 1052, -76), (0, 0, 90), "me_corrugated_metal8x8");
	spawnmodel((3516, 1052, -76), (0, 0, 90), "me_corrugated_metal8x8");
	spawnmodel((3800, 1055, -75), (0, 5, 90), "me_corrugated_metal8x8");
	spawnmodel((3704, 1111, -74), (0, 93, 90), "me_corrugated_metal4x8_holes");
	spawnmodel((3599, 1111, -74), (0, 88, 90), "me_corrugated_metal4x8_holes");
	spawnmodel((3506, 1112, -74), (0, 88, 90), "me_corrugated_metal8x8");
	
	CreateInvisGrids((3810,1200,-91),(3500,1020,-91),(0,0,0));
	
	spawnmodel((3473, 1047, -69), (0, 90, 270), "paris_sewer_ibeam_large_dmg");
	spawnmodel((3473, 1175, -69), (180, 90, 270), "paris_sewer_ibeam_large_dmg");
	
	spawnmodel((3473, 1047, -50), (0, 90, 270), "paris_sewer_ibeam_large_dmg");
	spawnmodel((3473, 1175, -50), (180, 90, 270), "paris_sewer_ibeam_large_dmg");
	
	spawnmodel((3481, 1067, -57), (86, 90, 0), "me_corrugated_metal4x8_holes");
	
	
	spawnmodel((3730, 1200, -202), (100, 180, 0), "com_pipe_4x256_metal_rusted");
	spawnmodel((3745, 1011, -187), (120, 180, 0), "com_pipe_4x256_metal_rusted");
	
	CreateInvisWalls((3470,1200,-73), (3470,1020,-73));

	//wallbreach
	CreateinvisGrids((3952, 756, -57),(3906, 918, -57), (0,0,0));
	CreateinvisGrids((3957, 876, -25),(3906, 918, -25), (0,0,0));
	
	spawncrate((4280,2150,-240), (0,110,0));
	spawncrate((4280,2150,-200), (0,110,0));
	spawncrate((4280,2150,-160), (0,110,0));
	spawncrate((4265,2195,-160), (0,110,0));
	spawncrate((4365,1840,-240), (0,20,0));
	spawncrate((4365,1840,-200), (0,20,0));
	spawncrate((4365,1840,-160), (0,20,0));
	spawncrate((4380,1790,-240), (0,110,0));
	spawncrate((4380,1790,-200), (0,110,0));
	spawncrate((4380,1790,-160), (0,110,0));
	
	CreateDoors((4324,1991,-120) /*open*/, (4324,1991,-240) /*close*/, (90,17,0) /*angle*/, 5 /*size*/, 2 /*height*/, 30 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	
	moveac130position((2485, -85, -250));
	fufalldamage((4100, 0, -225), 200, 100);
	fufalldamage((3994.87, 950, -69), 200, 250);
      
	CreateDoors((4470,267,-240) /*open*/, (4625,267,-240) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	//TPs
	createTP((132.893,-57.1034,-243.921), (3151, 1286, -323.427), (0, 50, 0));
	createTP((-888.628,-676.319,-192.073), (3151, 1286, -323.427), (0, 50, 0));
	createTP((2206.97,560.653,-290.207), (3046, 1396, -319.954), (0, 30, 0));
	createTP((1458.78,-1071.89,-168.131), (2952, 1484, -310.613), (0, 15, 0));
	createTP((987.398,2618.55,-263.284), (2952, 1484, -310.613), (0, 15, 0));
	createTP((-702.325,1482.61,-257.749), (3046, 1396, -319.954), (0, 30, 0));
	//createHiddenTP((4115, 1090, -79.875), (795, 1680, -50.875), (0, 180, 0), "out");
}
hardhat_edit1(){
	level.meat_playable_bounds = [
		(2090.2, 1469.27, 700.754),
		(2090.2, 3195.8, 703.031),
		(2396.15, 3580.7, 512.125),
		(2400.63, 4063.12, 512.125),
		(-2025.11, 4064.89, 448.125),
		(-2020.51, 1739.14, 573.599),
		(-16464.8, -15679.89, 448.125),
		(-18313, -15679.89, 448.125),
		(-16464.8, -16996, 448.125),
		(-16464.8, -15679.89, 448.125),
		(-2020.51, 1739.14, 573.599),
		(-578.852, 1736, 742.125),
		(-576.939, 1341.15, 742.125)
	];
	createPolygon();
	moveac130position((-556, 3054, 2000.125));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1058, 3651, 104);
	mp_global_intermission.angles = (-22, -48, 0);
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "fence_tarp_128x84" || ent.model == "machinery_oxygen_tank02" || ent.model == "machinery_oxygen_tank01" || ent.model == "com_barrel_benzin" || ent.model == "fence_tarp_192x84_a" || ent.model == "plastic_fence_264x40" || ent.model == "plastic_fence_234x88" || ent.model == "fence_tarp_196x36" || ent.model == "plastic_fence_528x88" || ent.model == "fence_tarp_draping_98x94_01" || ent.model == "fence_tarp_draping_224x116") {
	// iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
		}
	}
	//new spawn room
	spawnmodel((-16911, -16260, 579) , (-86, 61, -90) , "concrete_sewer_pipe_large"); //idea1
	spawnmodel((-16659, -16188, 512) , (0, 106, 0) , "pb_pallet_bags"); //idea1
	createTP((-16922.9, -16267.7, 510), (-1938.9, 1762, 224), (2, 90, 0),undefined, 160, undefined, undefined, 1);
	createTP((-16647, -16218.8, 510), (-1963, 3945, 32), (0, 0, 0),undefined, 160, undefined, undefined, 1);
	CreateDeathRegion((-17551, -17009, 455), (-16025, -15126.6, 330));
	
	spawnmodel((1026, 2360, 334) , (-92, 0, 181) , "com_barrier_tall1"); //new visual
	spawnmodel((2094, 1505, 384) , (0, -85, 0) , "me_dumpster_close_green");
	spawnmodel((2110, 3173, 444) , (107, 96, -73) , "wood_plank1");
	spawnmodel((2120, 2419, 419) , (0, 0, 0) , "pb_pallet_bags");
	spawnmodel((2123, 2418, 383) , (0, 0, 0) , "ch_crate48x64");
	spawnmodel((2187, 3202, 448) , (-35, -115, 0) , "hanging_dead_paratrooper01");
	spawnmodel((1384, 4082, 384) , (0, 6, 0) , "ny_manhattan_barrier_sawhorse");
	spawnmodel((1553, 4079, 384) , (0, -5, 0) , "ny_manhattan_barrier_sawhorse");
	spawnmodel((2038, 3571, 473) , (0, 0, 0) , "intro_construction_rebar_tuft02");
	spawncrate((2045, 3574, 566) , (90, 0, 0));
	
	spawncrate((2103, 3174, 442) , (90, 0, 0));
	spawncrate((2103, 3174, 547) , (90, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((2111, 2414, 430)+(0,0,83*i), (0, 90, -90));
	for(i = 0;i < 3;i++)
	spawncrate((2058, 1503, 441)+(0,0,104*i), (90, 90, 0));
	
	//spawn1
	spawnmodel((-1939, 1830, 273) , (5, 0, -5) , "concrete_sewer_pipe_large");
	spawnmodel((-1613, 2081, 145) , (-10, -85, 0) , "plastic_fence_300x88");
	spawnmodel((-1629, 2223, 147) , (80, -100, -100) , "wood_plank1");
	spawnmodel((-1596, 1931, 199) , (80, -100, -100) , "wood_plank1");
	
	for(i = 0;i < 3;i++)
	spawncrate((-1889, 1764, 226)+(0,67*i,-6*i) , (-5, -90, 39));
    for(i = 0;i < 3;i++)
	spawncrate((-1874, 1781, 281)+(0,61*i,-5*i) , (-5, -90, 90));
	for(i = 0;i < 4;i++)
	spawncrate((-1893, 1921, 331)+(0,-60*i,6*i) , (30, 0, -5));
	for(i = 0;i < 3;i++)
	spawncrate((-1999, 1764, 226)+(0,67*i,-6*i) , (-5, -90, -39));
	for(i = 0;i < 3;i++)
	spawncrate((-2014, 1783, 281)+(0,60*i,-5*i) , (-5, -90, -90));
	for(i = 0;i < 4;i++)
	spawncrate((-1985, 1921, 331)+(0,-60*i,6*i) , (-30, 0, -5));

	//spawn2
	spawnmodel((-1714, 3987, 31) , (0, 0, 0) , "pb_pallet_bags");
	spawnmodel((-1706, 3937, 31) , (0, 90, 0) , "pb_pallet_bags");
	spawnmodel((-1703, 3895, 31) , (0, 90, 0) , "pb_pallet_bags");
	spawnmodel((-1703, 3938, 75) , (0, 90, 0) , "pb_pallet_bags");
	spawnmodel((-1713, 3988, 75) , (0, 0, 0) , "pb_pallet_bags");
	spawnmodel((-1705, 3896, 75) , (0, 91, 0) , "pb_pallet_bags");
	spawnmodel((-1917, 3844, 25) , (0, -90, 0) , "com_industrialtrashbin");
	spawnmodel((-1709, 3958, 114) , (0, 0, 0) , "fence_tarp_draping_98x94_02");
	spawnmodel((-1758, 4000, 31) , (0, 0, 0) , "pb_pallet_bags"); 
	for(i = 0;i < 4;i++)
	spawncrate((-1817, 3815, 76)+(-60*i,0,0) , (90, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-1817, 3870, 76)+(-60*i,0,0) , (90, 0, 0));
	spawncrate((-1758, 3998, 60) , (0, 90, 0));
	spawncrate((-1718, 3998, 85) , (90, 0, 0));
	spawncrate((-1718, 3998, 85) , (90, 0, 0));
	spawncrate((-1713, 3984, 85) , (90, 0, 0));
	spawncrate((-1690, 3940, 85) , (90, 0, 0));
	spawncrate((-1716, 3940, 85) , (90, 0, 0));
	spawncrate((-1690, 3894, 85) , (90, 0, 0));
	spawncrate((-1716, 3894, 85) , (90, 0, 0));
	
	spawnmodel((-605, 3865, 130) , (0, -68, 0) , "com_trashchuteslide");//ramp
	CreateInvisRamps((-774, 3842, 24),(-639, 3895, 131));
	spawncrate((-610, 3907, 145) , (0, 111, 0));
	spawnmodel((-694, 3967, 32) , (0, -66, 0) , "construction_porter_potty_green_nolodout");
	spawncrate((-703, 3961, 77) , (0, -66, 0));
	spawncrate((-685, 3969, 77) , (0, -66, 0));
	spawncrate((-703, 3961, 124) , (0, -66, 0));
	spawncrate((-685, 3969, 124) , (0, -66, 0));
	
	//cover
	spawnmodel((-1689, 2601, 32) , (0, 0, 0) , "me_construction_dumpster_close");
	spawnmodel((-1718, 2596, 104) , (-4, 0, 85) , "com_door_01_handleleft");
	spawnmodel((-1688, 2542, 39) , (0, 0, 0) , "ch_crate48x64");
	spawnmodel((-1685, 2711, 81) , (0, 0, 40) , "prop_bm21_crte_clsed");
	spawnmodel((-1689, 2629, 51) , (0, -90, 0) , "construction_porter_potty_green_nolodout");
	for(i = 0;i < 5;i++)
	spawncrate((-1688, 2504, 72)+(0,48.5*i,0) , (0, 0, 0));
	spawncrate((-1689, 2618, 132) , (0, 0, 0));
	spawncrate((-1689, 2640, 132), (0, 0, 0)); 
 
	spawnmodel((-848, 2157, 94) , (0, 0, 0) , "concrete_sewer_pipe_large");
	for(i = 0;i < 6;i++)
	spawncrate((-800, 2246, 40)+(0,-33*i,0) , (-41, 360, 0));	
	for(i = 0;i < 6;i++)
	spawncrate((-896, 2246, 40)+(0,-33*i,0) , (-41, 180, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-777, 2246, 85)+(0,-33*i,0) , (-90, 360, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-919, 2246, 85)+(0,-33*i,0) , (-90, 180, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-800, 2246, 146)+(0,-33*i,0) , (-139, 360, 0));	
	for(i = 0;i < 6;i++)
	spawncrate((-896, 2246, 146)+(0,-33*i,0) , (-139, 180, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-849, 2246, 167)+(0,-41*i,0) , (0, 180, 0));
	
	spawnmodel((-376, 2300, 116) , (-171, 91, -90) , "concrete_sewer_pipe_large");
	spawncrate((-388, 2235, 90) , (-90, 79, 0));//cylinder
	spawncrate((-422, 2254, 90) , (-90, 44, 0));
	spawncrate((-351, 2240, 90) , (-90, 114, 0));
	spawncrate((-321, 2268, 90) , (-90, 149, 0));
	spawncrate((-314, 2307, 90) , (-90, 184, 0));
	spawncrate((-328, 2341, 90) , (-90, 219, -2));
	spawncrate((-359, 2361, 90) , (-90, 254, 0));
	spawncrate((-397, 2360, 90) , (-90, 289, 0));
	spawncrate((-426, 2339, 90) , (-90, 324, 0));
	spawncrate((-437, 2304, 90) , (-90, 359, 0));
	spawncrate((-434, 2277, 90) , (-90, 19, 0));
	CreateDeathRegion((-291, 2230, 117), (-463, 2396, 260));//cylinder
    
	spawnmodel((-1137, 1832, 156) , (18, 30, 0) , "vehicle_bulldozer");
	spawncrate((-1166, 1817, 239) , (0, -60, -20));
	spawncrate((-1158, 1821, 264) , (0, -60, -20));
	spawncrate((-1097, 1856, 192) , (20, 30, 0));
	spawncrate((-1155, 1797, 185) , (-20, -150, -2));
	spawncrate((-1181, 1842, 185) , (-20, -150, -2));
	spawncrate((-1110, 1823, 165) , (-20, -150, -2));
	spawncrate((-1136, 1868, 165) , (-20, -150, -2));

	//door 
	spawnmodel((299, 3145, 108) , (5, -95, 0) , "fence_tarp_196x146");
	spawnmodel((290, 2698, 109) , (0, 90, 0) , "fence_tarp_352x88");
	spawnmodel((290, 2875, 66) , (0, -35, 0) , "me_chainlink_fence_pole");
	spawnmodel((292, 2833, 3) , (0, -90, 0) , "com_barrier_tall1");
	spawnmodel((292, 2741, 3) , (0, -90, 0) , "com_barrier_tall1");
	CreateDoors((323, 3170, 60) /*open*/, (310, 2996, 60) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 20 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	for(i = 0;i < 3;i++)
	spawncrate((311, 3065, 145)+(0,60*i,0) , (90, -90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((303, 2855, 123)+(0,-60*i,0) , (90, -90, 90));
	for(i = 0;i < 2;i++)
	spawncrate((303, 2855, 73)+(0,-60*i,0) , (90, -90, 90));
	
	//main ladder ramp
    spawnmodel((127, 1805, 212) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((129, 1805, 122) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((127, 1806, 29) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((131, 2064, 31) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((134, 2063, 124) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((128, 2303, 159) , (0, 0, 0) , "com_pallet_2");
	spawnmodel((177, 1960, 233) , (110, -270, -90) , "me_construction_dumpster_close");
	spawnmodel((75, 1959, 233) , (110, -270, 90) , "me_construction_dumpster_close");
	spawnmodel((179, 2199, 166) , (101, -270, -90) , "me_construction_dumpster_close");
	spawnmodel((77, 2199, 166) , (101, -270, 90) , "me_construction_dumpster_close");
	spawnmodel((200, 2334, 140) , (90, 180, 90) , "me_construction_dumpster_close");
	spawnmodel((137, 2384, 75) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((136, 2391, 37) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((199, 2436, 141) , (90, -360, 90) , "me_construction_dumpster_close");
	spawnmodel((363, 2402, 178) , (18, 0, 181) , "com_barrier_tall1");
	spawnmodel((126, 1837, 300) , (0, 0, 90) , "me_corrugated_metal4x4");
	spawnmodel((126, 1789, 300) , (0, 0, 90) , "me_corrugated_metal4x4");
	spawncrate((351, 2404, 164) , (-18, -180, -1));
	for(i = 0;i < 6;i++)
	spawncrate((248, 2402, 156)+(-30*i,0,0) , (0, 90, 0));
	for(i = 0;i < 3;i++)
	spawncrate((158, 2335, 156)+(-30*i,0,0) , (0, 90, 0));
    CreateInvisRamps((139,2291,160), (139,2089,200));
	CreateInvisRamps((109,2291,160), (109,2089,200));
	CreateInvisRamps((139,2083,202), (139,1880,276));
	CreateInvisRamps((109,2083,202), (109,1880,276));
	CreateInvisQuicksteps((132, 1716, 620), 330, 18, 3, (0,90,0));
	CreateInvisQuicksteps((96, 1716, 620), 330, 18, 3, (0,90,0));
	for(i = 0;i < 3;i++)
	spawncrate((151, 1822, 288)+(-30*i,0,0) , (0, 90, 0));
	spawnmodel((154, 1755, 472) , (80, 62, -118) , "plastic_fence_400x88");
    spawnmodel((-793, 1713, 625) , (0, 0, 0) , "plastic_fence_528x88");
    spawnmodel((-539, 1713, 650) , (90, -5, -100) , "wood_plank1");
	for(i = 0;i < 4;i++)
	spawncrate((-412, 1327, 698) + (-60* i, 0, 0), (90, 0, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-590, 1380, 698)+ (0, 60* i, 0) , (90, 90, 0));
	spawncrate((-551, 1724, 698) , (90, 90, 0));
	spawncrate((239, 1440, 680), (90, 0, 0));

	//in map los block
	spawnmodel((1834, 1447, 241) , (90, -90, 0) , "ny_manhattan_building_electricalboxunit_e");
	spawnmodel((1205, 1312, 240) , (90, 90, 0) , "ny_manhattan_building_electricalboxunit_e");
	createTP((1710, 1366, 200), (-1938.9, 1762, 224), (0, 86, 0), undefined, 130, 150,undefined, 1);//spawnfix
	createTP((1384, 1237, 326), (-1938.9, 1762, 224), (0, 86, 0), undefined, 230, 90);//spawnfixvisible
	spawncrate((1218, 1413, 384), (90, 180, 0));
	
	//end bridge
	spawnmodel((1422, 2001, 635) , (91, 0, 0) , "fx_wood_beam");
	spawnmodel((1293, 2001, 640) , (93, 0, 0) , "fx_wood_beam");
	spawnmodel((1164, 2001, 647) , (93, 0, 0) , "fx_wood_beam");
	for(i = 0;i < 5;i++)
	spawncrate((1135, 2001, 631)+ (60* i, 0, -3* i) , (-3, 180, 0));
	CreateElevator((1137, 1631, 365),(1137, 1601, 365), 269, 2, (0,90,0));
	fufalldamage((188, 1946, 320.125), 250, 100);
	createTP((842, -1500, 273), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((2089, -649, 295), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((-849, -44, 160), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((-432, 724, 364), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((691, -184, 288), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((-293, -1165, 287), (-16715, -15833.5, 516), (0, 264, 0),1);
	createTP((1602, 207, 184), (-16715, -15833.5, 516), (0, 264, 0),1);
	level.lowspawnoverwriteheight = -100;
}
hardhat_edit2(){
	level.meat_playable_bounds = [
		(-118.023, -3075.33, 507.581),
		(612.361, -2527.87, 438.92),
		(612.088, -1782.75, 578.877),
		(-1167.15, -245, 721.038),
		(-3293.64, -245, 797.203),
		(-3283.05, -3052.75, 665.954),
		(-1024.68, -3046.49, 438.606)
	];
	createPolygon();
	moveac130position((-892, -1541, 2000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2089, -1838, 654);
	mp_global_intermission.angles = (24, -42, 0);
	
	//spawn cover
	spawnmodel((-231, -2502, 428) , (0, 1, 0) , "pb_pallet_bags");
	spawnmodel((-232, -2504, 384) , (0, 0, 0) , "pb_pallet_bags");
	spawncrate((-225, -2504, 420) , (0, -90, 0));
	spawncrate((-225, -2504, 458) , (0, -90, 0));
	spawncrate((-235, -2504, 420) , (0, -90, 0));
	spawncrate((-235, -2504, 458) , (0, -90, 0));
	
	//boundary
	spawnmodel((-127, -3125, 384) , (0, -2, 0) , "me_dumpster_close_green");
	spawncrate((-142, -3089, 442) , (90, 0, 0));//bincol
	spawnmodel((652, -2218, 385) , (0, -88, 0) , "ny_barrier_construction_01");
	spawnmodel((679, -2417, 384) , (0, -78, 0) , "ny_barrier_construction_01");
	spawnmodel((683, -2029, 384) , (0, -93, 0) , "ny_barrier_construction_01");
	spawnmodel((-1116, -3146, 384) , (0, -13, 0) , "vehicle_policecar_lapd");
	spawnmodel((-1377, -3195, 384) , (0, -30, 0) , "vehicle_policecar_lapd");
	spawnmodel((-2162, -3072, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2332, -3080, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2448, -3075, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2742, -3079, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2599, -3077, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2733, -183, 512) , (0, 0, 0) , "com_trafficcone02");//2nd row
	spawnmodel((-2588, -229, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2388, -222, 510) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-2227, -209, 512) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-3422, -2044, 508) , (0, 0, 0) , "ny_manhattan_building_electricalboxunit_e");
	spawnmodel((-3423, -2329, 544) , (0, -90, 0) , "arc_house_window_facade");
	spawnmodel((-3421, -2259, 602) , (0, 90, 0) , "fence_tarp_352x88");

	//hut
	spawnmodel((-558, -1930, 397) , (0, 0, 0) , "furniture_metal_door02_handleright");
	spawnmodel((-615, -1932, 392) , (0, 90, 0) , "com_door_01_handleleft");
	spawnmodel((-637, -2002, 420) , (0, -180, 0) , "arc_house_window_facade");
	spawnmodel((-637, -2007, 419) , (0, -1, 0) , "payback_sstorm_debris_wood_5");
	spawnmodel((-637, -2002, 419) , (0, -1, 0) , "payback_sstorm_debris_wood_5");
	spawnmodel((-560, -1902, 505) , (0, 90, 0) , "com_lightbox");
	spawnmodel((-560, -1799, 358) , (0, 0, 0) , "ny_manhattan_building_electricalboxunit_d");
	spawnmodel((-581, -1904, 381) , (0, -90, -88) , "com_barrier_tall1");
	spawnmodel((-537, -1903, 381) , (0, 0, 0) , "com_pallet");
	spawnmodel((-542, -1825, 384) , (0, 0, 0) , "com_barrel_corrosive_rust");
	spawnmodel((-731, -1915, 383) , (0, 0, 0) , "ctl_light_spotlight_generator");
	spawnmodel((-766, -1826, 384) , (0, -7, 0) , "ny_manhattan_barrier_sawhorse");
	spawnmodel((-693, -2021, 384) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((-687, -1980, 524) , (0, 0, 0) , "bc_military_tire05_big");
	spawnmodel((-555, -2004, 448) , (85, 9, 93) , "wood_plank1");
	for(i = 0;i < 4;i++)
	spawncrate((-575, -1990, 431) + (0,60* i,0), (90, 90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-695, -1990, 431)+ (0,60* i,0) , (90, 90, 0));
	spawncrate((-635, -1990, 431), (90, 90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-696, -1977, 503)+ (0,50* i,0) , (0, -90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-575, -1977, 503)+ (0,50* i,0) , (0, -90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-656, -1977, 503)+ (0,50* i,0) , (0, -90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-616, -1977, 503)+ (0,50* i,0) , (0, -90, 0));
	spawncrate((-544, -1822, 398) , (90, 0, 0));//barrelcol
	spawncrate((-534, -1918, 377) , (0, 90, 0));//doortablet
	spawncrate((-534, -1890, 377) , (0, 90, 0));//doortablet
	 
	//cover
	spawnmodel((-678, -2460, 383) , (0, 0, 0) , "construction_porter_potty_green_nolodout");
	spawncrate((-678, -2450, 423) , (0, 0, 0));
	spawncrate((-678, -2471, 423) , (0, 0, 0));
	spawncrate((-678, -2450, 475) , (0, 0, 0));
	spawncrate((-678, -2471, 475) , (0, 0, 0));
	
	spawnmodel((-1134, -2472, 384) , (0, -180, 0) , "com_industrialtrashbin");
	for(i = 0;i < 4;i++)
	spawncrate((-1162, -2385, 434)+ (0,-60* i,0) , (90, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-1107, -2385, 434)+ (0,-60* i,0) , (90, 0, 0));
	
	spawnmodel((-1062, -2372, 416) , (0, 3, 90) , "ch_crate48x64");
	spawncrate((-1054, -2402, 418) , (90, 0, 0));//cratecol
	spawncrate((-1054, -2390, 418) , (90, 0, 0));//cratecol

	//tarp ramp
	spawnmodel((-1099, -1753, 344) , (0, -90, 0) , "ny_manhattan_building_electricalboxunit_c");
	spawnmodel((-1222, -1552, 397) , (0, -90, -4) , "com_industrialtrashbin");
	spawnmodel((-1218, -1427, 402) , (0, -4, 46) , "com_wallchunk_metalstudwall01");
	
	for(i = 0;i < 3;i++)
	spawncrate((-1267, -1488, 441)+ (44* i,-2* i,-1* i) , (44, 86, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-1264, -1447, 401)+ (44* i,-2* i,-1* i) , (44, 86, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-1311, -1524, 458)+ (60* i,0,-4* i) , (-94, -180, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-1311, -1577, 458)+ (60* i,0,-4* i) , (-94, -180, 0));
	
	spawnmodel((-1244, -1554, 480) , (3, 40, -90) , "wood_plank1");
	spawnmodel((-1155, -1550, 474) , (3, 47, -90) , "wood_plank1");
	spawnmodel((-1287, -1558, 483) , (3, 50, -90) , "wood_plank1");
	spawnmodel((-1202, -1559, 480) , (2, 70, 93) , "me_corrugated_metal2x8");

	for(i = 0;i < 2;i++)//ny_manhattan_building_electricalboxunit_c
	spawncrate((-1285, -1619, 439)+ (0,-60* i,0) , (90, 90, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-1272, -1623, 489)+ (60* i,0,0) , (0, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-1272, -1666, 489)+ (60* i,0,0) , (0, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-1272, -1709, 489)+ (60* i,0,0) , (0, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-1272, -1752, 489)+ (60* i,0,0) , (0, 0, 0));
	
	//final ramp
	spawnmodel((-3048, -1942, 761) , (0, 90, 0) , "com_trashchuteslide");
	spawnmodel((-2877, -1940, 625) , (0, 90, 0) , "com_trashchuteslide");
	spawnmodel((-2974, -1942, 447) , (0, 90, 180) , "com_trashchuteslide");
	
	CreateInvisRamps((-2682,-1984,495), (-3026,-1984,764));
	
    //restaurant
	spawnmodel((-1501, -194, 544) , (0, 7, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1151, -194, 544) , (0, 7, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1326, -194, 587) , (0, 0, 0) , "fence_tarp_352x88");
	spawnmodel((-1326, -194, 544) , (0, 7, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1814, -225, 755) , (0, 0, 0) , "plastic_fence_264x40");

	spawnmodel((-1604, -576, 512) , (0, 0, 0) , "machinery_stairs_moveable_large");
	for(i = 0;i < 5;i++)
	spawncrate((-1605, -681, 498) + (0,34* i,29* i) , (-40, 90, 0));
	spawncrate((-1584, -492, 640) , (0, -90, 0));
	spawncrate((-1641, -492, 640) , (0, -90, 0));
	
	createTurret((-2059, -2238, 550), (0,0,0), 50, 50, undefined, undefined, 10);
	//createHiddenTP((-3156, -340, 800.125), (603.197,-27.7726,288.125), undefined, "out");
	//createHiddenTP((-1273, -325, 545.78), (603.197,-27.7726,288.125), undefined, "out");
	
	createTP((814, 1377, 370), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((842, -1500, 273), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((2089, -649, 295), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((-849, -44, 160), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((-432, 724, 364), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((691, -184, 288), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((-293, -1165, 287), (-191.11,-2995.71,384.125), (0,90,0));
	createTP((1515, 563, 184), (-191.11,-2995.71,384.125), (0,90,0));
}
bakaara_edit1(){
	level.meat_playable_bounds = [
		(-2889, -125, 47.125),
		(-2889.88, -514.21, 47.125),
		(-1433.55, -2796.79, 238.389),
		(-1020.74, -827.581, 109.625),
		(-809.737, 210.095, 321.229),
		(-803.48, 1945.83, 452.385),
		(-1251.62, 1959.5, 527.737),
		(-1230.16, 301.982, 38.0133),
		(-1883.43, 316.562, 307.125),
		(-1873.68, -100, 307.125),
		(-2283, -100, 314.125),
		(-2283, -125, 314.125)
	];
	createPolygon();
	//Edit By ? edited by clippy
	moveac130position((-985, 445, 2026.13));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2454, -231, -30);
	mp_global_intermission.angles = (-14, -34, 0);
	CreateDeathRegion((-1368, 725, -28), (-1101, 1981, 92));
	CreateWalls((-2880, -120, -30),(-2280, -120, 20));
	spawncrate((-2900, -153, -10),(90,0,0));
	CreateWalls((-2900, -130, 20),(-2900, -500, 20));
	CreateWalls((-2500, -410, -40),(-2500, -510, 35));
	CreateGrids((-1565, -490, -38),(-1565, -660, -38), (45,90,0));
	CreateQuicksteps((-1597, -765, 228), 240, 15, 2, (0,0,0));
	CreateQuicksteps((-1597, -825, 228), 240, 15, 2, (0,0,0));
	CreateGrids((-1750, -125, 220),(-1680, -455, 220), (0,0,0));
	CreateWalls((-1870, -100, 280),(-1870, 280, 200));
	CreateWalls((-1870, -100, 280),(-2070, -100, 200));
	CreateWalls((-1870, 300, 280),(-1220, 300, 200));
	CreateWalls((-1220, 300, 280),(-1220, 760, 200));
	CreateGrids((-1240, 1610, 209),(-1240, 1940, 209), (0,0,0));
	CreateWalls((-1100, 1955, 300),(-1220, 1955, 220));
	spawncrate((-1260, 1925, 250),(90,0,0), "com_plasticcase_friendly");
	spawncrate((-1260, 1925, 300),(90,0,0), "com_plasticcase_friendly");
	spawncrate((-1260, 1925, 350),(90,0,0), "com_plasticcase_friendly");
	CreateInvisWalls((-1031, -700, 0),(-1031, -840, 110));
	CreateWalls((-1695, -125, -35),(-1695, -250, 30));
	CreateWalls((-1695, -420, -35),(-1695, -460, 30));
	CreateDoors((-1695, -335, 70) /*open*/, (-1695, -335, 0) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 1 /*height*/, 25 /*hp*/, 95 /*range*/);
	CreateWalls((-1170, 1355, 220),(-970, 1355, 268));
	createTurret((-1070, 1355, 275), (0,-90,0));
	createTP((-666, -258, -38), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((1693, 1783, -4), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((681, 3149, 123), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((-702, 1518, -34), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((-632, 2821, 153), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((837, -1032, -43), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((1607, -75, -61), (-2712, -454, -39), (-2, 41, 0), undefined);
	createTP((148, 771, -65), (-2712, -454, -39), (-2, 41, 0), undefined);
	//createHiddenTP((-847.125,1900.88,224.125), (-418.459,1845.59,70.125), undefined, "out");
}bakaara_edit2(){
	level.meat_playable_bounds = [
		(4058.57, 700.67, 347.175),
		(2486.72, 717.21, 365.122),
		(2489.07, 1375.29, 365.122),
		(2312.5, 1376.66, 365.122),
		(1996.16, 865.18, 366.743),
		(2019.09, 7.96558, 226.456),
		(1813.97, 5.02721, 226.456),
		(1824.35, -1485.78, 226.456),
		(2058.33, -1491.74, 342.154),
		(2060.56, -2164.41, 425.341),
		(4079.86, -2159.95, 425.341)
	];
	createPolygon();
	
	//Edit By ?
	
	//Ladder
	spawnmodel((2299, 724, 30), (0, 0, 95), "pb_wood_board");
	spawnmodel((2228, 724, 30), (0, 0, 95), "pb_wood_board");
	
	spawnmodel((2226, 722, 14), (0, 0, 5), "me_window_bars_02");
	spawnmodel((2226, 722, 7), (0, 0, 5), "me_window_bars_02");
	spawnmodel((2226, 728, -54), (0, 0, 5), "me_window_bars_02");
	CreateInvisQuicksteps((2260, 700, 65), 120, 15, 2, (0,90,0));
	
	//1st path wood
	CreateInvisGrids((2260, 690, 65),(2260, 212, 65), (0,0,0));
	spawnmodel((2219.9, 643, 81), (0, 90, 90), "ch_wood_fence_128a");
	spawnmodel((2303, 547, 80), (0, 270, 90), "ch_wood_fence_128a");
	
	spawnmodel((2219.9, 417, 81), (0, 90, 90), "ch_wood_fence_128a");
	spawnmodel((2303, 321, 80), (0, 270, 90), "ch_wood_fence_128a");
	
	spawnmodel((2219.9, 221, 81), (0, 90, 90), "ch_wood_fence_128a");
	i=0;
	spawnmodel((2303, 165, 80) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
    spawnmodel((2303, 165, 82) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++; 
	spawnmodel((2303, 165, 80) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 82) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++; 	
	spawnmodel((2303, 165, 80) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 82) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 80) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 82) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 80) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	spawnmodel((2303, 165, 82) + (80* i, 0, 0), (0, 270, 90), "ch_wood_fence_128a"); i++;
	
	spawnmodel((2921, 160, 85), (0, 70, 90), "afr_corrugated_metal4x8");
	spawnmodel((2692, 180, 85), (0, 20, 90), "afr_corrugated_metal4x8");
	spawnmodel((2426, 180, 85), (0, 50, 90), "afr_corrugated_metal4x8");
	spawnmodel((2539, 198, 85) , (0, 85, 93) , "afr_corrugated_metal4x8");
    spawnmodel((2916, 165, 85) , (0, 70, 90) , "afr_corrugated_metal4x8");
	
	CreateInvisGrids((2260, 190, 65),(2999, 115, 65), (0,0,0));
	
	spawnmodel((2304, 104.7, -50), (0, 90, 0), "com_scaffold_red");
	spawnmodel((2550, 104.7, -50), (0, 90, 0), "com_scaffold_red");
	spawnmodel((2550, 220, -50), (0, 90, 0), "com_scaffold_red");
	spawnmodel((2924, 122, -50), (0, 90, 0), "com_scaffold_red");
	spawnmodel((2924, 220, -50), (0, 90, 0), "com_scaffold_red");
	spawnmodel((2967, 169, -50), (0, 0, 0), "com_scaffold_red");
	spawnmodel((2879, 169, -50), (0, 0, 0), "com_scaffold_red");
	spawnmodel((2226, 199, -50), (0, 0, 0), "com_scaffold_red");
	spawnmodel((2226, 328, -50), (0, 0, 0), "com_scaffold_red");
	
	//debris bridge
	spawnmodel((3647, -746, -60), (0, 0, 0), "ac_prs_bld_debris_wood_a_2");
	i=0;	
	spawncrate((3655, -520, -65) + (-1* i,-55* i,0), (0, 0, 0)); i++;
	spawncrate((3655, -520, -65) + (-1* i,-55* i,0), (0, 0, 0)); i++;
	spawncrate((3655, -520, -65) + (-1* i,-55* i,0), (0, 0, 0)); i++;
	spawncrate((3655, -520, -65) + (-3* i,-55* i,0), (0, 0, 0)); i++;
	spawncrate((3614, -658, -65), (0, 80, 0));
	spawncrate((3606, -706, -65), (0, 80, 0));
	spawncrate((3621, -835.7, -65), (0, 30, 0));
	
	i=0;	
	for(i = 0;i < 5;i++)
	spawncrate((3662, -745, -65) + (-2* i,-65* i,0), (0, 88, 0)); 
	
	//ramp
	spawnmodel((3205, 165, 13), (-180,180,-90), "me_construction_dumpster_close"); 
	spawnmodel((3205, 68, 13), (-180,0,-90), "me_construction_dumpster_close"); 
	spawnmodel((3205, -35, 81), (-180,0,-22), "me_construction_dumpster_close"); 
    spawnmodel((3205, -244, -7), (-180,0,-22), "me_construction_dumpster_close"); 
	CreateInvisRamps((3205, 55, 102),(3205, -340, -55));
	
	//cover
	spawnmodel((2746, -460, -46), (0, 90, 0), "pb_pallet_bags");
	spawnmodel((2746, -460, -2), (0, 0, 0), "pb_pallet_bags");
	spawnmodel((2688, -460, -46), (0, 90, 0), "pb_pallet_bags");
	spawnmodel((2710, -460, -2), (0, 0, 0), "pb_pallet_bags");
	spawncrate((2758, -465, -5), (0, 90, 0));
	spawncrate((2710, -465, -5), (0, 90, 0));
	spawncrate((2679, -465, -16), (0, 90, 0));
	spawncrate((2758, -460, 25), (0, 90, 0));
	spawncrate((2710, -460, 25), (0, 90, 0));
	
	//small wood+metal bridges
	spawnmodel((2637, 253, 165), (0, 92, 90), "afr_corrugated_metal4x8");
	spawnmodel((2677, 252, 163), (0, 91, 90), "afr_corrugated_metal4x8");
	spawncrate((2690, 258, 150), (0, 0, 0));
	spawncrate((2620, 258, 150), (0, 0, 0));
	spawncrate((2690, 250, 150), (0, 0, 0));
	spawncrate((2620, 250, 150), (0, 0, 0));

	CreateInvisRamps((3040, 246, 149),(3140, 246, 149));
	spawnmodel((3047, 245, 155) , (0, 0, 0) , "com_pallet");
	spawnmodel((3095, 245, 155) , (0, 0, 0) , "com_pallet");
	spawnmodel((3143, 245, 155) , (0, 0, 0) , "com_pallet");
	spawnmodel((3147, 246, 163) , (-180, 0, 0) , "com_pallet");
	
	spawnmodel((2953, 245, 130) , (-17, 0, 0) , "com_pallet");
	spawnmodel((2999, 245, 144) , (-17, 0, 0) , "com_pallet");
	CreateInvisRamps((2999, 246, 137),(2958, 246, 124));
	
	spawncrate((3205, 150, 113), (0, 0, 0));
	spawncrate((3205, 120, 113), (0, 0, 0));
	spawncrate((3205, 90, 113), (0, 0, 0));
	
	spawnmodel((3046, 134, 75), (-5, 0, 0), "com_pallet");
	
	spawnmodel((3065, 134, 73), (-18, 0, 0), "com_pallet");
	spawnmodel((3110, 134, 88), (-18, 0, 0), "com_pallet");
	spawnmodel((3155, 134, 103), (-18, 0, 0), "com_pallet");
	CreateInvisRamps((3154, 134, 99),(3060, 134, 70));
    
    //2nd ladder
	CreateInvisQuicksteps((2400, -1300, 71), 135, 15, 2, (0,90,0));
	
	spawnmodel((2365, -1282.86, 22), (0, 0, 5), "me_window_bars_02");
	spawnmodel((2365, -1282.86, 15), (0, 0, 5), "me_window_bars_02");
	spawnmodel((2365, -1276.86, -46), (0, 0, 5), "me_window_bars_02");
	spawnmodel((2438, -1279.86, 20), (0, 0, 95), "pb_wood_board");
	spawnmodel((2367, -1279.86, 20), (0, 0, 95), "pb_wood_board");
	
	moveac130position((2442, -226, 2018.13));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2542, -186, -44);
	mp_global_intermission.angles = (-15, -32, 0);
	CreateQuicksteps((2340, 220, 113), 45, 15, 2, (0,-90,0));
	
	//CreateInvisGrids((1986.6, -1211.9, 30),(1967.4, -1205, 30), (0,341,0)); //Forklift block

	CreateInvisWalls((2250, 122, 90),(2275, 122, 140), (0,0,270));
	CreateInvisWalls((2313, 122, 90),(2553, 122, 170), (0,0,270));
	CreateInvisWalls((2812, 197, 130),(2995, 197, 210), (0,0,270));
	
	CreateInvisWalls((2080, 0, 130),(2390, 0, 130));
	CreateInvisWalls((2080, 0, 190),(2390, 0, 190));
	
	CreateDeathRegion((1990, 0, -60), (4825, 720, 60));
	createTP((-666, -258, -38), (2388, 1307, -29), (0,270,0), undefined);
	createTP((1693, 1783, -4), (2388, 1307, -29), (0,270,0), undefined);
	createTP((681, 3149, 123), (2388, 1307, -29), (0,270,0), undefined);
	createTP((-702, 1518, -34), (2388, 1307, -29), (0,270,0), undefined);
	createTP((-632, 2821, 153), (2388, 1307, -29), (0,270,0), undefined);
	createTP((837, -1032, -43), (2388, 1307, -29), (0,270,0), undefined);
	createTP((1607, -75, -61), (2388, 1307, -29), (0,270,0), undefined);
	createTP((148, 771, -65), (2388, 1307, -29), (0,270,0), undefined);
	//createHiddenTP((2533, -1660, 97.2698), (-487, -55, 96.125), undefined, "out");
	
	//boat wall block
	CreateInvisGrids((2047, -1555, 210),(2197, -1555, 210), (30,-90,90));
	CreateInvisGrids((2047, -1555, 280),(2197, -1555, 280), (30,-90,90));
	spawnmodel((2048, -1621, 166), (28, 270, 0), "props_common_fence_old_01");
	
	spawnmodel((2048, -1640, 200), (30, 270, 0), "props_common_fence_old_01");
	spawnmodel((2048, -1482, 220), (-3, 270, 0), "props_common_fence_old_01");
	spawnmodel((2048, -1386.5, 150), (-30, 270, 0), "props_common_fence_old_01");
	spawnmodel((2049, -1642, 180), (29, 270, 0), "fence_tarp_107x56");
	spawnmodel((2046, -1549, 200), (10, 270, 0), "afr_corrugated_metal8x8");
	
	//new shit
	spawncrate((3398, -794, -40), (90, 0, 0));
	
	CreateInvisRamps((3396, -949, -75),(3382, -1113, -75));
	CreateInvisRamps((3100, -994, -75),(3155, -1089, -75));
	
	spawnmodel((2255, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2255, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2311, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2311, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2367, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2367, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2423, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2423, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2479, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2479, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2535, 108, 98) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2535, 108, 128) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2324, 108, 158) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2380, 108, 158) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2436, 108, 158) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2492, 108, 158) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2542, 108, 158) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2823, 184, 141) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2823, 184, 171) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2823, 184, 201) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2879, 184, 141) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2879, 184, 171) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2879, 184, 201) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2935, 184, 141) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2935, 184, 171) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2935, 184, 201) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2985, 184, 141) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2985, 184, 171) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((2985, 184, 201) , (0, 180, 90) , "com_plasticcase_green_big_us_dirt");
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (3710, -80, 152);
	mp_global_intermission.angles = (12, 210, 0);
}
bakaara_edit3(){
	level.meat_playable_bounds = [
		(1206, 3456.67, 40.175),
		(1205, 3928.67, 40.175),
		(809, 3930.67, 40.175),
		(809, 4506.67, 40.175),
		(773, 4509.67, 40.175),
		(775, 5007.67, 40.175),
		(-667, 4865.67, 200.175),
		(-1106, 4865.67, 200.175),
		(-1107, 4120.67, 200.175),
		(-1741, 4132.67, 200.175),
		(-1907, 3389.67, 200.175),
		(-761, 3392.67, 200.175),
		(-761, 3117.67, 200.175),
		(-1100, 3123.67, 200.175),
		(-1255, 788.67, 200.175),
		(-1070, -1399.67, 200.175),
		(2281, -1724.67, 200.175),
		(3069, 1489.67, 200.175)
	];
	createPolygon();
	//Edit By TMG
	
	moveac130position((-342, 4272, 2000.125));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-244, 3881, 122);
	mp_global_intermission.angles = (-14, 54, 0);
	//floors
	CreateGrids((-658, 4817, 250),(325, 4711, 250), (0,0,0));
	CreateGrids((-658, 4844, 520),(325, 4711, 520), (0,0,0));
	//flagfloor
	CreateGrids((160, 4850, 250),(51, 4950, 250), (0,0,0));
	//guard rail
	CreateGrids((-652, 4844, 285.125),(28, 4844, 285.125), (0,0,0));
	CreateGrids((195, 4844, 285.125),(328, 4844, 285.125), (0,0,0));
	//turret
	spawncrate((-140, 4711, 278.125), (0,0,0), "com_plasticcase_friendly");
	createTurret((-140, 4711, 298.135), (0,270,0), 60, 60, 20, 10, 10);
	//cover
	CreateWalls((43, 4723, 265.125), (43, 4723, 370.125), (0,90,0));
	CreateWalls((87, 4711, 265.125), (87, 4711, 370.125), (0,0,0));
	CreateGrids((-29, 4796, 380.25),(188, 4691, 380.25), (0,0,0));
	CreateGrids((188, 4691, 355.375),(-29, 4691, 355.375), (0,0,0));
	CreateWalls((-82, 3610, 348.125), (-82, 3610, 448.125), (0,90,0));
	CreateWalls((-194, 3610, 348.125), (-194, 3610, 448.125), (0,90,0));
	CreateQuicksteps((413, 3576, 508.125), 185, 18, 2, (0,180,0));
	CreateQuicksteps((-685, 3576, 528.125), 199, 18, 2, (0,0,0));
	CreateQuicksteps((-620, 4679, 250), 180, 18, 2, (0,270,0));
	CreateQuicksteps((-520, 4679, 250), 180, 18, 2, (0,270,0));
	CreateDoors((-381, 4896, 285.125) /*open*/, (-381, 4777, 285.125) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	CreateGrids((-1107, 3855, 525),(-1107, 4084, 525), (0,0,0));
	
	createTP((-666, -258, -38), (374, 3683, 100), (0, 120, 0));
	createTP((1693, 1783, -4), (-643, 3683, 90), (0, 70, 0));
	createTP((681, 3149, 123), (374, 3683, 100), (0, 120, 0));
	createTP((-702, 1518, -34), (-643, 3683, 90), (0, 70, 0));
	createTP((-632, 2821, 153), (374, 3683, 100), (0, 120, 0));
	createTP((837, -1032, -43), (-643, 3683, 90), (0, 70, 0));
	createTP((1607, -75, -61), (374, 3683, 100), (0, 120, 0));
	createTP((148, 771, -65), (-643, 3683, 90), (0, 70, 0));
	
	createHiddenTP((103, 4970, 266.125), (-139, 3615, 355), (0, 270, 0));
	
	CreateWalls((-1749, 4140, 574.125), (-1894, 3394, 574.125));
	CreateWalls((340, 4879, 576.125), (770, 4879, 576.125));
	CreateWalls((340, 4910, 576.125), (340, 5039, 576.125));
	//tp spawn protection
	CreateGrids((-610, 3756, 180),(-474, 3608, 180), (0,0,0));
	CreateGrids((194, 3756, 200),(330, 3608, 200), (0,0,0));
	CreateWalls((-466, 3756, 143.125), (-520, 3756, 60.125), (0,0,0));
	//spawn camp block
	spawncrate((319, 3622, 130), (0, 0, 0));
	spawncrate((290, 3622, 130), (0, 0, 0));
	spawncrate((225, 3622, 130), (0, 0, 0));
	CreateDeathRegion((360, 3590, 90), (183, 3547, 170));
	CreateDeathRegion((1992.81, 2329, 20), (2243, 2654.7, 130));
	CreateDeathRegion((-1063.81, 3121, 329), (-1288, 2815.7, 545));
	//createHiddenTP((-163, 4889, 540.2698), (1038, 3706, 229.125), (0, 260, 0), "out");
}
mission_edit1(){
	level.meat_playable_bounds = [
		(-5649, -6733.89, 1644.63),
		(-5413.08, -6501.37, 1644.63),
		(-5412.53, -5204.05, 1644.63),
		(-7399.95, -3216.82, 1644.63),
		(-8280.3, -4100.26, 1644.63)
	];
	CreateDeathRegion((-615, 733, 890), (-832, 622.9, 950));//rock
	moveac130position((-5582, -4890, 1584));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-5825, -4924, 1587);
	mp_global_intermission.angles = (-12, -97, 0);
	createPolygon();
	CreateWalls((-5650, -6750, 1590),(-8300, -4100, 1645));// |
	CreateWalls((-8300, -4100, 1590),(-7400, -3200, 1645));// --
	CreateWalls((-7400, -3200, 1590),(-5400, -5200, 1645));// |
	CreateWalls((-5400, -5200, 1590),(-5400, -6500, 1645));// /
	CreateWalls((-5600, -6300, 1590),(-5600, -5400, 1645));// /
	CreateWalls((-5600, -5400, 1590),(-5700, -5300, 1645));// |
	CreateWalls((-5600, -6300, 1590),(-5850, -6550, 1645));// -
	CreateWalls((-5400, -6500, 1590),(-5650, -6750, 1645));// -
	CreateWalls((-6200, -5200, 1590),(-6300, -5300, 1645));// Safety wall
	CreateWalls((-6700, -4300, 1590),(-6800, -4400, 1645));// Safety wall
	CreateWalls((-7000, -5000, 1590),(-7100, -5100, 1645));// Safety wall

	CreateDoors((-5500, -6200, 1680) /*open*/, (-5500, -6200, 1600) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	CreateDoors((-5600, -5200, 1680) /*open*/, (-5600, -5200, 1600) /*close*/, (90,-45,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 110 /*range*/, 1 /*sideways*/);

	//createHiddenTP((-8237, -4109, 1584.13), (-1824.22,760.875,1096.93), undefined, "out");
	
	createTP((1851, -571, 1169), (-5656, -6577, 1584), (0, 67, 0));
	createTP((-1776, 314, 937), (-5656, -6577, 1584), (0, 67, 0));
	createTP((1383, 830, 1211), (-5656, -6577, 1584), (0, 67, 0));
	createTP((-16, -813, 978), (-5656, -6577, 1584), (0, 67, 0));
	createTP((-899, -470, 995), (-5656, -6577, 1584), (0, 67, 0));
	createTP((-693, 1250, 1213), (-5656, -6577, 1584), (0, 67, 0));
	createTP((260, 336, 1206), (-5656, -6577, 1584), (0, 67, 0));
}
mission_edit2(){
	level.meat_playable_bounds = [
		(2127, 384.448, 1459.62),
		(2127, 1190.88, 1387.13),
		(2237, 1190.88, 1387.13),
		(2237, 1351.97, 1387.13),
		(2465, 1364.83, 1685.13),
		(2445.1, 1739.31, 1685.13),
		(2419.43, 1737.82, 1688.32),
		(2414.84, 2349.74, 1722.13),
		(2382.82, 2840.93, 100),
		(1265.85, 2691.79, 100),
		(1267, 2158.86, 100),
		(1042.57, 1957.44, 100),
		(1042.57, 384.448, 1384.98)
	];
	createPolygon();
	
	CreateDeathRegion((-615, 733, 890), (-832, 622.9, 950));//rock
	
	spawnmodel((2193, 1951, 1212) , (0, 0, 0) , "ch_woodfence01");
	spawnmodel((2431, 1778, 1254) , (0, 0, 0) , "com_barrel_biohazard_rust");
	spawnmodel((1060, 1641, 1184) , (10, -275, 0) , "ch_mattress_bent_2");
	
	//TPs
	createTP((1851, -571, 1169), (1665, 937, 1212.18), (0, 0, 0));
	createTP((-1776, 314, 937), (1665, 937, 1212.18), (0, 0, 0));
	createTP((1383, 830, 1211), (1665, 937, 1212.18), (0, 0, 0));
	createTP((-16, -813, 978), (1665, 937, 1212.18), (0, 0, 0));
	createTP((-899, -470, 995), (1665, 937, 1212.18), (0, 0, 0));
	createTP((-472.9, 1095, 1213), (1665, 937, 1212.18), (0, 0, 0));
	createTP((260, 336, 1206), (1665, 937, 1212.18), (0, 0, 0));
	moveac130position((2753, 1424, 3000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2038, 816, 1245);
	mp_global_intermission.angles = (-18, 121, 0);
	//Spawn TP Roof
	spawnmodel((1702, 927, 1337) , (180, -5, 0) , "ac_prs_bld_debris_wood_a_1");
	spawnmodel((1648, 834, 1359) , (-4, 0, 0) , "afr_breakaway_roof_01");
	spawnmodel((1743, 812, 1360) , (-4, 0, 0) , "afr_breakaway_roof_01");
	spawnmodel((1640, 912, 1358) , (-5, 36, 0) , "afr_breakaway_roof_01");
	spawnmodel((1740, 894, 1357) , (-5, 36, 0) , "afr_breakaway_roof_01");
	spawnmodel((1660, 968, 1355) , (-5, 232, 0) , "afr_breakaway_roof_01");
	spawnmodel((1653, 1031, 1365) , (4, -164, 0) , "afr_breakaway_roof_01");
	spawnmodel((1764, 944, 1355) , (-5, 225, 0) , "afr_breakaway_roof_01");
	spawnmodel((1744, 1027, 1364) , (-6, 225, -4) , "afr_breakaway_roof_01");
	spawnmodel((1809, 1003, 1360) , (-3, 225, -5) , "afr_breakaway_roof_01");
	spawnmodel((1815, 854, 1357) , (-5, 98, 0) , "afr_breakaway_roof_01");
	spawnmodel((1980, 1105, 1350) , (25, 90, -90) , "foliage_tree_oak_1_destroyed_branch1");
	spawnmodel((1702, 927, 1337) , (180, -5, 0) , "ac_prs_bld_debris_wood_a_1");
	spawnmodel((1896, 707, 1357) , (15, 0, -90) , "foliage_tree_oak_1_destroyed_branch1");

	spawnmodel((2101, 1122, 1319) , (-4, -194, 0) , "afr_breakaway_roof_01");
	spawnmodel((2100, 1102, 1211) , (0, 0, 0) , "pb_cubical_planter_dam");
	spawnmodel((2100, 1102, 1317) , (-180, 0, 0) , "pb_cubical_planter_dam");
	spawncrate((2090, 1127, 1246), (0, 0, 90));
	spawncrate((2090, 1080, 1246), (0, 0, 90));
	spawncrate((2090, 1127, 1300), (0, 0, 90));
	spawncrate((2090, 1080, 1300), (0, 0, 90));
	CreateInvisGrids((1604, 831, 1350),(1805, 1035, 1350), (0,0,0));
	
	spawnmodel((2103, 1102, 1181) , (0, 0, 0) , "foliage_pacific_bushtree02_animated");
	spawnmodel((2097, 1096, 1315) , (0, 0, 0) , "foliage_pacific_forest_shrub01");
	CreateDoors((1815, 1368.42, 1299) /*open*/, (1815, 1368.42, 1250) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	spawnmodel((2180, 1322, 1310) , (-330, 0, -90) , "com_railpipe_large_06_d");
	spawnmodel((2180, 967, 1308) , (-330, 0, 90) , "com_railpipe_large_06_d");
	spawnmodel((2220, 682, 1233) , (130, -71, 0) , "com_railpipe_large_07_d");
	spawnmodel((2312, 1259, 1068) , (-20, 20, 0) , "foliage_afr_tree_asipalm_01a");
	
	for(i = 0;i < 15;i++)
	spawncrate((2154, 618, 1341) + (0, 60* i, 0), (90, 90, 0)); 
	//Gate Before Door
	spawnmodel((2067, 1478, 1212) , (0, -90, 0) , "pb_front_gate");
	spawnmodel((1877, 1502, 1211) , (0, 0, 0) , "pb_cubical_planter_dam");
	spawnmodel((1877, 1502, 1317) , (-180, 0, 0) , "pb_cubical_planter_dam");
	spawnmodel((1868, 1497, 1319) , (-4, -59, 0) , "afr_breakaway_roof_01");
	spawnmodel((1880, 1517, 1181) , (0, 0, 0) , "foliage_pacific_bushtree02_animated");
	spawncrate((1885, 1481, 1253), (0, 0, 0));
	spawncrate((1885, 1526, 1253), (0, 0, 0));
	spawncrate((1885, 1481, 1300), (0, 0, 0));
	spawncrate((1885, 1526, 1300), (0, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((1943, 1493.46, 1260) + (60* i, 0, 0), (90, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((1943, 1493.46, 1290) + (60* i, 0, 0), (90, 0, 0));
	CreateInvisRamps((2194.8, 1729, 1270),(2194.8, 1544, 1270));
	
	for(i = 0;i < 4;i++)
	spawncrate((2222, 1460, 1320)+ (0, -60* i, 0), (90, 0, 0));
	
	spawncrate((2269, 1370.7, 1320), (90, 90, 0));
	spawncrate((2308, 1370.7, 1380), (90, 90, 0));
	
	spawncrate((2187, 1221, 1314), (0, 0, -90));
	
	spawncrate((2186.9, 1487, 1262), (0, 0, 0));
	spawncrate((2186.9, 1431, 1266), (0, 90, 0));
	spawncrate((2186.9, 1395, 1266), (0, 90, 0));
	spawncrate((2186.9, 1360, 1266), (0, 90, 0));
	
	spawncrate((2186.9, 1455, 1364), (0, 90, 0));
	spawncrate((2186.9, 1390, 1364), (0, 90, 0));
	spawncrate((2186.9, 1332, 1364), (0, 90, 0));
	spawncrate((2186.9, 1280, 1360), (0, 90, 0));
	
	//Door
	
	//side fence
	spawnmodel((2370, 1804, 1284) , (0, 90, 0) , "props_common_fence_old_01");
	spawncrate((2389, 1765.8, 1282) , (0, 90, 0));
	spawncrate((2389, 1765.8, 1342) , (0, 90, 0));

	//Fence
	spawnmodel((1439, 1597, 1168) , (0, -90, 0) , "ch_woodfence_broken");
	spawnmodel((1491, 1469, 1181) , (-2, 2, 5) , "ch_woodfence02");
	spawnmodel((1491, 1726, 1175) , (-2, -3, 5) , "ch_woodfence02");
	//Block Window
	spawncrate((1555, 1627, 1253), (90, 0, 0));
	spawnmodel((1538, 1635, 1251) , (-35, -80, 85) , "pb_wood_board");
	spawnmodel((1535, 1629, 1244) , (-105, -83, 85) , "pb_wood_board");
	//Tree Pot (Cover)
	spawnmodel((1780, 1203, 1230) , (0, 0, 0) , "pb_cubical_planter_dam");
	spawnmodel((1779, 1203, 1230) , (-180, 0, 0) , "pb_cubical_planter_dam");
	spawncrate((1773, 1229, 1222), (0, 0, 90));
	spawncrate((1773, 1182, 1222), (0, 0, 90));
	spawncrate((1773, 1229, 1266), (0, 0, 90));
	spawncrate((1773, 1182, 1266), (0, 0, 90));
	//Block path
	spawncrate((1047, 1361, 1204) , (0, 89.5441, 0));
	spawncrate((1047, 1361, 1250) , (0, 89.5441, 0));
	spawnmodel((1064, 1379, 1173) , (0, 0, 0) , "intro_props_front_gate");
	spawnmodel((1064, 1305, 1178) , (0, 90, 0) , "ch_woodfence01");
	spawnmodel((1754, 1225, 1284) , (-4, -104, 0) , "afr_breakaway_roof_01");
	spawnmodel((1776, 1167, 1287) , (-5, -311, 0) , "afr_breakaway_roof_01");
	//Ladder Up
	spawnmodel((2107, 1670, 1123) , (10, 0, 0) , "com_ladder_wood");
	CreateInvisQuicksteps((2155, 1670, 1271), 100, 15, 2, (0,180,0));
	spawnmodel((2205, 1696, 1284) , (-4, 109, 4) , "afr_breakaway_roof_01");
	spawnmodel((2191, 1588, 1286) , (-5, -75, 3) , "afr_breakaway_roof_01");
	spawnmodel((2194, 1722, 1252) , (0, 0, 0) , "com_pallet_stack");
	spawnmodel((2194, 1665, 1252) , (0, 0, 0) , "com_pallet_stack");
	spawnmodel((2195, 1608, 1252) , (0, 0, 0) , "com_pallet_stack");
	spawnmodel((2195, 1551, 1252) , (0, 0, 0) , "com_pallet_stack");
	spawnmodel((2200, 1766, 1264) , (0, -90, 59) , "afr_corrugated_metal2x8");
	spawncrate((2190, 1770, 1252) , (31, -1, 0));
	spawncrate((2241, 1769, 1221) , (31, -1, 0));
	
	
	//OOE Ents
	spawnmodel((1467, 2352, 1223) , (10, -30, 0) , "foliage_afr_tree_fanpalm_01b");
	spawnmodel((1100, 2323, 1200) , (0, 0, 0) , "afr_hut_bkg_01");
	spawnmodel((1714, 2468, 1215) , (10, 0, 0) , "afr_pano_hut_02");
	spawnmodel((2290, 2477, 1244) , (-5, -55, -5) , "afr_cloth_wall_module_01");
	spawnmodel((1088, 1992, 1188) , (-10, 45, 0) , "afr_twig_fence_02");
	spawnmodel((1467, 2352, 1223) , (10, -30, 0) , "foliage_afr_tree_fanpalm_01b");
	spawnmodel((1100, 2323, 1200) , (0, 0, 0) , "afr_hut_bkg_01");
	spawnmodel((1714, 2468, 1215) , (10, 0, 0) , "afr_pano_hut_02");
	spawnmodel((2290, 2477, 1244) , (-5, -55, -5) , "afr_cloth_wall_module_01");
	spawnmodel((1088, 1992, 1188) , (-10, 45, 0) , "afr_twig_fence_02");
	spawnmodel((1467, 2352, 1223) , (10, -30, 0) , "foliage_afr_tree_fanpalm_01b");
	spawnmodel((1100, 2323, 1200) , (0, 0, 0) , "afr_hut_bkg_01");
	spawnmodel((1714, 2468, 1215) , (10, 0, 0) , "afr_pano_hut_02");
	spawnmodel((2290, 2477, 1244) , (-5, -55, -5) , "afr_cloth_wall_module_01");
	spawnmodel((1088, 1992, 1188) , (-10, 45, 0) , "afr_twig_fence_02");
	spawnmodel((1154, 2062, 1212) , (-10, 45, 0) , "afr_twig_fence_02");
	spawnmodel((1234, 2123, 1242) , (-10, 35, 0) , "afr_twig_fence_02");

	//1st Ramp To Roof
	CreateinvisRamps((2130, 1572, 1270),(1785, 1572, 1460));
	spawnmodel((2027, 1573, 1345) , (0, -90, 61) , "afr_corrugated_metal4x8");
	spawnmodel((1943, 1573, 1391) , (0, -90, 61) , "afr_corrugated_metal4x8");
	spawnmodel((1859, 1573, 1437) , (0, -90, 61) , "afr_corrugated_metal4x8");
	spawnmodel((2111, 1573, 1299) , (0, -90, 61) , "afr_corrugated_metal4x8");
	spawnmodel((2051, 1688, 1628) , (110, 0, 0) , "com_powerpole1");
	//tmg roof stuck spots fix
	spawncrate((1540, 1470, 1438), (0, 90, -21));
	spawncrate((1540, 1530, 1438), (0, 90, -21));
	spawncrate((1540, 1590, 1438), (0, 90, -21));
	spawncrate((1540, 1650, 1438), (0, 90, -21));
	spawncrate((1540, 1710, 1438), (0, 90, -21));
	spawncrate((1590, 1456, 1460), (-22, 0, 0));
	//Visual Block
	spawnmodel((1409, 1299, 1500) , (0, 0, 0) , "mil_razorwire_mid_static");
	spawnmodel((1234, 1295, 1504) , (0, 0, 0) , "mil_razorwire_mid_static");
	spawnmodel((1574, 1284, 1505) , (0, -90, 0) , "mil_razorwire_mid_static");
	//2nd Ramp To Roof
	CreateinvisRamps((1700, 1690, 1500),(2205, 1690, 1660));
	spawnmodel((1752, 1690, 1533) , (0, -90, 108) , "afr_corrugated_metal4x8");
	spawnmodel((1842, 1690, 1562) , (0, -90, 108) , "afr_corrugated_metal4x8");
	spawnmodel((1931, 1690, 1591) , (0, -90, 108) , "afr_corrugated_metal4x8");
	spawnmodel((2020, 1690, 1620) , (0, -90, 108) , "afr_corrugated_metal4x8");
	spawnmodel((2110, 1690, 1649) , (0, -90, 108) , "afr_corrugated_metal4x8");
	spawnmodel((2173, 1690, 1669) , (0, -90, 108) , "afr_corrugated_metal4x8");


	CreateinvisGrids((2250, 1775, 1690),(2400, 1775, 1690), (0,0,30));
	spawnmodel((2221, 1769, 1705) , (60, 90, 90) , "me_refrigerator2");
	spawnmodel((2346, 1768, 1705) , (60, 90, 90) , "me_refrigerator2");
	spawnmodel((2321, 1769, 1707) , (0, 0, 26) , "me_rebar01");
	spawnmodel((2322, 1779, 1715) , (0, 0, -60) , "me_hanging_clothes_sheet_white");
	spawnmodel((2326, 1753, 1673) , (0, -90, 0) , "foliage_tree_destroyed_fallen_log_a");
	//End Plat Form
	CreateInvisGrids((2170, 2095, 1708),(1810, 2155, 1708), (0,0,0));
	spawnmodel((2015, 2127, 1693) , (-330, 90, -90) , "com_railpipe_large_06_d");
	spawnmodel((1962, 2105, 1680) , (130, 0, 0) , "me_telegraphpole2");
	spawnmodel((1962, 2147, 1680) , (130, 0, 0) , "me_telegraphpole2");
	spawnmodel((1803, 2127, 1725) , (-6, -71, -2) , "afr_breakaway_roof_01");
	spawnmodel((1862, 2130, 1727) , (-4, -255, 3) , "afr_breakaway_roof_01");
	spawnmodel((1906, 2128, 1727) , (-4, -435, 4) , "afr_breakaway_roof_01");
	spawnmodel((1965, 2130, 1727) , (-4, -253, -3) , "afr_breakaway_roof_01");
	spawnmodel((2012, 2130, 1728) , (-4, -433, -3) , "afr_breakaway_roof_01");
	spawnmodel((2078, 2131, 1727) , (-2, -613, -1) , "afr_breakaway_roof_01");
	spawnmodel((2122, 2129, 1726) , (-7, -790, 0) , "afr_breakaway_roof_01");

	//Exit Flag
	//createHiddenTP((2394, 2329.8, 1722.13), (-55, -335, 1220.13), undefined, "out");
}
favela_edit1(){

	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "me_electricbox2" || ent.model == "me_electricbox4" || ent.model == "me_fanceil1" || ent.model == "com_tv2" || ent.model == "com_tv1" || ent.model == "hanging_apron" || ent.model == "hanging_short_sleeve" || ent.model == "hanging_long_sleeve" || ent.model == "utility_transformer_small01") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
	}
	}
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (10428, 17841, 12966);
	mp_global_intermission.angles = (-34, 133, 0);
	fufalldamage((9969, 18482, 12610.125),550,900);
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (10428, 17841, 12966);
	mp_global_intermission.angles = (-34, 133, 0);
	fufalldamage((9969, 18482, 12610.125),550,900);
	
	
	
	//new shoot cover shit
	for(i = 0;i < 5;i++)
	spawnmodel((9982, 18319, 12643)+(0,0,86*i) , (0, 0, 0) , "com_water_tank2_stand");
	spawnmodel((10036, 18299, 13077) , (0, 90, 0) , "hanging_sheet");
	spawnmodel((10031, 18301, 12965) , (12, 90, 0) , "me_corrugated_metal4x8");
	//spawnmodel((9930, 18305, 12851) , (-8, 90, 0) , "me_corrugated_metal4x8");
	spawnmodel((9984, 18289, 12641) , (0, 0, 12) , "ch_mattress_boxspring");
	for(i = 0;i < 6;i++)
	spawnmodel((9967, 18318, 12603)+(0,0,76*i), (0, 0, -90)+(0,20*i,0) , "com_railpipe_med_03_d");
	
	spawnmodel((9955, 18316, 13080) , (195, -175, -90) , "com_railpipe_med_03_d");
	
	//bottom floor
	for(i = 0;i < 4;i++)
	spawnmodel((9798, 18534, 12644)+(96*i,0,0) , (0, 0, 90)+(0,-1*i,0) , "me_corrugated_metal8x8");
	
	CreateInvisRamps((9767, 18556, 12628.5),(10123, 18550, 12628.5));
	
	//spawn cover
	CreateInvisGrids((9780, 18508, 12770),(9830, 18390, 12770), (0,0,0));
	CreateInvisGrids((9780, 18508, 12782),(9830, 18375, 12782), (0,0,0));
	spawnmodel((9799, 18407, 12795) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9802, 18474, 12797) , (0, -2, 90) , "me_corrugated_metal8x8");
	
	for(i = 0;i < 4;i++)
	spawnmodel((9847, 18515, 12776)+(0,-31*i,0) , (0, -90, 90) , "me_refrigerator_d");
	spawnmodel((9780, 18479, 12599) , (0, 0, 0) , "me_chainlink_fence_pole");
	spawnmodel((9780, 18479, 12688) , (0, 0, 0) , "me_chainlink_fence_pole");
	
 
	
	//highest floor
	for(i = 0;i < 5;i++)
	spawnmodel((10555, 18182, 13632)+(0,96*i,0) , (0, 0, 90) , "me_corrugated_metal8x8");
	for(i = 0;i < 5;i++)
	spawnmodel((10571, 18182, 13631)+(0,96*i,0) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((10558, 18629, 13630) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((10592, 18329, 13628) , (-109, -11, 0) , "com_powerpole3");
	spawnmodel((10575, 18499, 13627) , (-109, 19, 0) , "com_powerpole3");
	CreateInvisGrids((10535, 18660, 13620),(10590, 18150, 13620), (0,0,0));
	
	//highest floor2
	spawnmodel((9455, 18237, 13610) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9455, 18362, 13610) , (0, 0, 90) , "me_corrugated_metal8x8"); 
	spawnmodel((9440, 18300, 13611) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9439, 18240, 13609) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9439, 18357, 13609) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9455, 18504, 13610) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9455, 18651, 13610) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9455, 18573, 13609) , (0, 0, 90) , "me_corrugated_metal8x8");
	 
	CreateInvisGrids((9420, 18205, 13601),(9475, 18383, 13601), (0,0,0));
	for(i = 0;i < 7;i++)
	spawncrate((9476, 18490, 13601)+(0,32*i,0) , (0, 0, 0));
	for(i = 0;i < 7;i++)
	spawncrate((9435, 18490, 13601)+(0,32*i,0) , (0, 0, 0));
	
	//highest ladder floor
	spawnmodel((9873, 18289, 13618) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9958, 18294, 13619) , (0, 120, 90) , "me_corrugated_metal4x8");
	spawnmodel((10016, 18330, 13617) , (0, 0, 90) , "me_corrugated_metal8x8");
	spawnmodel((9933, 18321, 13621) , (0, 87, 90) , "me_corrugated_metal4x8");//NEW

	spawnmodel((9882, 18297, 13523) , (0, 0, 0) , "com_water_tank2_stand");
	
	for(i = 0;i < 2;i++)
	spawncrate((9854, 18258, 13603)+(0,64*i,0) , (0, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((9902, 18258, 13603)+(0,32*i,0) , (0, 0, 0));
	spawncrate((9954, 18284, 13603) , (0, 30, 0));
	spawncrate((9960, 18324, 13603) , (0, 0, 0));
	spawncrate((10035, 18321, 13603) , (0, 0, 0));
	spawncrate((10035, 18298, 13603) , (0, 0, 0));
	spawncrate((10048, 18359, 13603) , (0, -90, 0));
	spawncrate((10151, 18374, 13589) , (8, -1, 0));
	spawncrate((10085, 18376, 13598) , (8, -1, 0));
	
	//newwallcover
	CreateWalls((10172, 18645, 13200),(10172, 18540, 13078));

	//ents
	//hair
	spawnmodel((9944, 18434, 13611) , (15, 34, 0) , "foliage_tree_river_birch_med_a");
	spawnmodel((9944, 18434, 13611) , (15, 134, 0) , "foliage_tree_river_birch_med_a");
	spawnmodel((9944, 18447, 13611) , (15, 184, 0) , "foliage_tree_river_birch_med_a");
	spawnmodel((9957, 18408, 13682) , (90, 0, 0) , "foliage_pacific_tropic_shrub03");
	spawnmodel((9947, 18409, 13682) , (90, 180, 0) , "foliage_pacific_tropic_shrub03");

	//bush
	spawnmodel((10086, 18321, 12638) , (0, 0, 0) , "foliage_pacific_fern01");
	spawnmodel((9762, 18394, 12638) , (0, 0, 0) , "foliage_pacific_fern02");
	spawnmodel((9893, 18312, 12642) , (0, 20, 0) , "foliage_pacific_fern02");

	//ladders

	spawnmodel((9802, 18290, 13489) , (351, 180, 0) , "com_steel_ladder");
	spawnmodel((9824, 18290, 13645) , (351, 180, 0) , "com_steel_ladder");
	spawnmodel((9877, 18291, 13612) , (90, 180, 0) , "roadkill_wood_door_64");
	spawnmodel((9918, 18290, 13613) , (90, 180, 0) , "roadkill_wood_door_64");
	spawnmodel((9771, 18309, 12837) , (354, 0, 0) , "com_steel_ladder");
	spawnmodel((9763, 18309, 12947) , (354, 0, 0) , "com_steel_ladder");
	spawnmodel((9706, 18312, 12932) , (90, 0, 0) , "roadkill_wood_door_64");
	spawnmodel((9665, 18311, 12933) , (90, 0, 0) , "roadkill_wood_door_64");
	CreateInvisQuicksteps((9746, 18310, 12930), 300, 18, 2, (0,0,0));
	CreateInvisQuicksteps((9839, 18290, 13603), 320, 14, 2, (0,180,0));
	
	//com_electrical_pipe
	 
	CreateGrids((9680, 18290, 12930),(9680, 18680, 12930), (0,0,0));
	CreateGrids((9735, 18290, 12930),(9735, 18680, 12930), (0,0,0));
	CreateRamps((10050, 18650, 13100),(9780, 18650, 12930));
	CreateGrids((10080, 18540, 13113),(10130, 18680, 13113), (0,0,0));
	CreateRamps((10050, 18570, 13100),(9780, 18570, 13270));
	CreateGrids((9740, 18610, 13283),(9690, 18280, 13283), (0,0,0));
	CreateDoors((9765, 18420, 13350) /*open*/, (9765, 18565, 13350) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 1 /*height*/, 35 /*hp*/, 100 /*range*/);
	
	
	createTP((923, 2546, 240.625), (9798, 18433, 12643), (0, -90, 0), 1);
	createTP((1010, 10, 198.939), (9798, 18433, 12643), (0, -90, 0), 1);
	createTP((1199, -1201, 187.083), (9798, 18433, 12643), (0, -90, 0), 1);
	createTP((-438, 377, 0.125), (9798, 18433, 12643), (0, -90, 0), 1);
	createTP((-1603, 855, 8.0225), (9798, 18433, 12643), (0, -90, 0), 1);
	createTP((-754, 1356, 92.4042), (9798, 18433, 12643), (0, -90, 0), 1);
	//createHiddenTP((9345, 18435, 13635),(-778, 2947, 410), undefined , "out");
	CreateDoors((9700, 18375, 13050) /*open*/, (9700, 18375, 12970) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 20 /*hp*/, 220 /*range*/, 1 /*sideways*/);
	CreateDeathRegion((14000,13500,11000), (6000,22500,0));
	moveac130position((9938, 18427, 12636.6));
}
favela_edit2(){
	level.meat_playable_bounds = [
		(980, 2456, 446.063),
		(1358, 2458, 376.328),
		(1528.34, 2835.86, 746.825),
		(1646, 3209, 1000),
		(1970.92, 3094.92, 1000),
		(2617, 3176, 464.125),
		(3059, 3139, 464.125),
		(3062, 3042, 464.125),
		(2744, 2847, 432.125),
		(2613.9, 2862, 432.125),
		(2191, -1896, 432.125),
		(1194, -1768, 432.125),
		(1664, 2313, 432.125),
		(1363, 2173, 448.062),
		(969, 2175, 470.453)
	];
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "me_electricbox2" || ent.model == "me_electricbox4" || ent.model == "me_fanceil1" || ent.model == "com_tv2" || ent.model == "com_tv1" || ent.model == "hanging_apron" || ent.model == "hanging_short_sleeve" || ent.model == "hanging_long_sleeve" || ent.model == "utility_transformer_small01") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
	}
	}
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1569, 2489, 337);
	mp_global_intermission.angles = (-39, -15, 0);
	createPolygon();
	moveac130position((2213, 830, 3366.986));
	
	spawnmodel((2086, 2889, 260) , (3, 301, 0) , "com_ladder_wood");
	CreateInvisQuicksteps((2087.4, 2885.4, 415), 60, 18, 1, (0,121,0));
	
	spawncrate((1860.58, 2767, 397.7), (90, 45, 0));
	spawncrate((1862.89, 2783.76, 379), (0, 80, 0));
	spawnmodel((1862, 2758.61, 372) , (90, 80, 0) , "com_barrel_blue_rust");
	spawnmodel((1860, 2760.61, 386) , (0, 260, 0) , "com_barrel_tan_rust");
	spawnmodel((1781, 2734.4, 364) , (0, 260, 0) , "com_barrel_tan_rust");//hmm
	spawncrate((1786, 2733.9, 373.7), (90, 0, 0));
	spawncrate((1806, 2743.53, 373.7), (90, 0, 0)); 
	
	createTP((923, 2546, 240.625), (1132, 2398, 281), (0, -12, 0));
	createTP((1010, 10, 198.939), (1104, 2401, 281), (0, -12, 0));
	createTP((1199, -1201, 187.083), (1104, 2401, 281), (0, -12, 0));
	createTP((-438, 377, 0.125), (1104, 2401, 281), (0, -12, 0));
	createTP((-1603, 855, 8.0225), (1104, 2401, 281), (0, -12, 0));
	createTP((-754, 1356, 92.4042), (1104, 2401, 281), (0, -12, 0));
	createhiddenTP((3015, 3102, 280.125), (1648, 2999, 686), (0, -58, 0), undefined);
	//createHiddenTP((1757, -1645, 728.125),(-177, -753, 431.167), undefined , "out");
	//End of road wall 3-stack
	CreateInvisWalls((2753, 2864, 290),(3040, 3043, 290));
	CreateInvisWalls((2753, 2864, 360),(3040, 3043, 360));
	spawnmodel((2866, 2935, 295) , (0, 35, 0) , "foliage_pacific_tropic_shrub03");
	spawnmodel((1326, 2448, 394) , (0, 0, -85) , "ch_mattress_2");
	spawnmodel((1225, 2449, 389) , (-5, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1094, 2450, 370) , (1, 0, 0) , "me_corrugated_metal8x8");
	CreateInvisWalls((1000, 2453, 400),(1340, 2454, 400));

	//Door
	CreateDoors((1894, 2612, 390) /*open*/, (1894, 2612, 300) /*close*/, (90,25,0) /*angle*/, 5 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, 0 /*sideways*/);
	fufalldamage((1889, 2613, 286),500,450);
	// Ents
	spawnmodel((1643, 2141, 305) , (0, 80, 0) , "foliage_tree_oak_1");
	spawnmodel((2137, 2033, 669) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((2103, 2121, 670) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((2069, 2209, 671) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((2035, 2297, 671) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((2001, 2385, 671) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((1967, 2473, 671) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((1933, 2561, 673) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((1899, 2649, 673) , (0, 111, 270) , "ch_mattress_boxspring");
	spawnmodel((1865, 2737, 673) , (0, 111, 270) , "ch_mattress_boxspring");
	
	//ladder bridge
	i=0;
	spawnmodel((1820, 1790, 678)+(0,201* i,0), (270, 90, 0) , "com_steel_ladder");
	spawnmodel((1820, 1991, 678)+(0,201* i,0) , (270, 90, 0) , "com_steel_ladder");
	spawnmodel((1820, 2192, 678)+(0,201* i,0) , (270, 90, 0) , "com_steel_ladder");
	spawnmodel((1820, 2393, 678)+(0,201* i,0) , (270, 90, 0) , "com_steel_ladder");
	spawnmodel((1820, 2594, 678)+(0,201* i,0) , (270, 90, 0) , "com_steel_ladder");
	
	//Ramp from 1st building
	CreateInvisRamps((2131, 1963, 662),(1823, 2767, 668));
	
	for(i = 0;i < 16;i++)
	spawncrate((1820, 1893, 669) + (0,55* i,0), (0, 90, 0));
	
	//Ladders
	CreateInvisQuicksteps((2003.17, 1365.246, 665), 130, 18, 2, (0,-256,0));
	spawnmodel((2001, 1372, 707) , (-7, 104, 0) , "com_steel_ladder");
	CreateInvisQuicksteps((1957.25, 439.8, 617), 130, 18, 2, (0,-269,0));
	spawnmodel((1955, 445, 652) , (-10, 90, 0) , "com_steel_ladder");
	CreateInvisQuicksteps((1967.71, 87.477, 713), 100, 18, 2, (0,86,0));
	spawnmodel((1968, 86, 767) , (-12, 86, 0) , "com_steel_ladder");
	CreateInvisQuicksteps((1776.86, -448.32, 713), 130, 18, 4, (0,-275,0));
	spawnmodel((1775, -457, 780) , (-15, 85, 0) , "com_steel_ladder");
	CreateInvisQuicksteps((1791, -1375, 713.5), 130, 18, 4, (0,97,0));
	spawnmodel((1791, -1377, 778) , (-16, 97, 0) , "com_steel_ladder");
	//Ramps
	CreateInvisRamps((2129, 1734, 666),(2201, 1420, 666));
	spawnmodel((2137, 1701, 681) , (0, 13, -90) , "me_corrugated_metal4x8");
	spawnmodel((2153, 1627, 680) , (0, 13, -90) , "me_corrugated_metal4x8");
	spawnmodel((2169, 1548, 681) , (0, 11, -90) , "me_corrugated_metal4x8");
	spawnmodel((2185, 1472, 680) , (0, 13, -90) , "me_corrugated_metal4x8");
	CreateInvisRamps((2118, 769, 617),(2119, 448, 617));
	spawnmodel((2118, 723, 633) , (0, 1, -90) , "me_corrugated_metal4x8");
	spawnmodel((2119, 635, 632) , (0, 0, -90) , "me_corrugated_metal4x8");
	spawnmodel((2120, 550, 633) , (0, 1, -90) , "me_corrugated_metal4x8");
	spawnmodel((2120, 502, 632) , (0, 1, -90) , "me_corrugated_metal4x8");
	CreateInvisRamps((1966, -138, 710),(1938, -458, 710));
	spawnmodel((1960, -184, 729) , (0, 1, -90) , "me_corrugated_metal4x8");
	spawnmodel((1956, -252, 730) , (0, -5, -89) , "me_corrugated_metal4x8");
	spawnmodel((1948, -340, 728) , (0, -5, -89) , "me_corrugated_metal4x8");
	spawnmodel((1941, -404, 728) , (0, -5, -89) , "me_corrugated_metal4x8");
	CreateInvisRamps((1907, -1025, 710),(1947, -1344, 710));
	spawnmodel((1914, -1077, 726) , (0, 7, -90) , "me_corrugated_metal4x8");
	spawnmodel((1923, -1150, 727) , (0, 7, -90) , "me_corrugated_metal4x8");
	spawnmodel((1933, -1230, 726) , (0, 7, -90) , "me_corrugated_metal4x8");
	spawnmodel((1938, -1309, 728) , (-1, 0, -91) , "me_corrugated_metal4x8");
	//1st Roof wall
	CreateInvisWalls((1656, 3205, 720),(1541, 2860, 720));
	CreateInvisWalls((1687, 3203, 720),(1946, 3110, 720));
	
	spawnmodel((1909, 3107, 734) , (0, -20, 0) , "me_corrugated_metal8x8");
	spawnmodel((1824, 3140, 710) , (90, -20, 0) , "me_corrugated_metal4x8");
	spawnmodel((1738, 3169, 708) , (90, -20, 0) , "me_corrugated_metal4x8");
	spawnmodel((1680, 3193, 709) , (-19, -20, 0) , "me_corrugated_metal4x4");
	spawnmodel((1654, 3150, 710) , (90, 70, 0) , "me_corrugated_metal4x8");
	spawnmodel((1623, 3070, 733) , (90, 70, 0) , "me_corrugated_metal8x8");
	spawnmodel((1562, 2901, 709) , (90, 70, 0) , "me_corrugated_metal4x8");
	spawnmodel((1595, 2988, 708) , (90, 70, 0) , "me_corrugated_metal4x8");
	//Death Barriers
	CreateDeathRegion((1487, 680, 100.125), (2972, -2380, 490));
	CreateDeathRegion((2380, 2616, 100), (3894, -2645, 1005));
	CreateDeathRegion((1549, 2257, 100), (2363, 1247, 490));
	//CreateDeathRegion((2874, 4440, 350), (991, 2483, 490)); //CHECKKK
	CreateDeathRegion((969, 2972, 354.856), (-165, 4397, 1066.66));
	CreateDeathRegion((864, 3445, 534.097), (3307, 5253, 1719.86));
	CreateDeathRegion((1530, 1792, 60.097), (2720, 3070, 280));
	CreateDeathRegion((1583.79, 2928.94, 500), (1785.37, 3374, 680));
	CreateDeathRegion((1807.12, 1200.88, 490), (3166.52, -1245.16, 170));
	
	//cuck perch
	spawnmodel((2204, 1072, 674) , (0, -79, -90) , "me_corrugated_metal4x8");
	spawnmodel((2199, 1099, 659) , (-40, -79, -90) , "me_corrugated_metal4x8");
	spawncrate((2185, 1063, 659) , (0, 11, 0));
	spawncrate((2225, 1071, 659) , (0, 11, 0));
}
interchange_edit1(){
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "vehicle_subcompact_mica_destructible" || ent.model == "vehicle_taxi_yellow_destructible_dusty" || ent.model == "vehicle_taxi_yellow_destructible" || ent.model == "com_ex_airconditioner" || ent.model == "vehicle_jeep_destructible" || ent.model == "me_electricbox4") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
	}
	}
	
	level.meat_playable_bounds = [
		(-4622.8, 1690, 100),
		(-4615.22, 2574.86, 1000),	
		(-7660.25, 5296.49, 1000),
		(-8111.68, 4793.93, 3333),	
		(-9630.37, 5641.32, 1000),
		(-10119.88, 5340.7, 1000),
		(-8952.36, 3311.2, 1000),
		(-8393.5, 3564, 1000),
		(-9630.37, 5641.32, 1000),
		(-8111.68, 4793.93, 3333)
	];
	createPolygon();
	moveac130position((-6395, 3700, 1678));
	CreateDeathRegion((-7360, 5289, 590), (-8153, 4764, 800));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	
	random = randomint(3);
		if(random == 0)
			mp_global_intermission.origin = (-5013, 2885, 988);
		else if(random == 1)
			mp_global_intermission.origin = (-6341, 2202, 1019);
		else
			mp_global_intermission.origin = (-4665, 2292, 1068.8);
		if(random == 0)
			mp_global_intermission.angles = (-24, -85, 0);
		else if(random == 1)
			mp_global_intermission.angles = (-20, 47, 0);
		else
			mp_global_intermission.angles = (4, 142, 0);
	
	
	CreateInvisWalls((-8108, 4817, 920),(-7678, 5299, 920));
	CreateInvisWalls((-8108, 4817, 970),(-7678, 5299, 970));
	
	CreateInvisWalls((-4623, 1665, 970),(-8124, 4792, 970));
	CreateInvisWalls((-7652, 5317, 970),(-4643, 2627, 970));
	
	CreateInvisWalls((-4865.7, 1885.25, 1030),(-5313.82, 2285.14, 1030));
	CreateInvisWalls((-4825.16, 2784.36, 1030),(-4626.12, 2609.39, 1030));
	CreateInvisWalls((-9073, 3513, 1450),(-10002, 5118, 1450));
	
	spawnmodel((-9178, 3611.6, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9306.65, 3835, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9435.3, 4058.4, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9563.95, 4281.8, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9692.6, 4505.2, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9821.25, 4728.6, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	spawnmodel((-9949.9, 4952, 1415), (0, 210, 0), "cargocontainer_20ft_green");
	
	spawnmodel((-8059, 4929.11, 912), (0, 138, 0), "cargocontainer_20ft_green");
	spawnmodel((-7890, 5116.5, 912), (0, 138, 0), "cargocontainer_20ft_green");
	spawnmodel((-7721, 5303.89, 912), (0, 138, 0), "cargocontainer_20ft_green");

	//spawnwalls
	
	CreateInvisWalls((-4596, 2574, 1060),(-4617, 2216, 1060));
	
	CreateInvisWalls((-4635, 2592, 920),(-5052, 2178, 920));
	spawncrate((-5060, 2170, 966), (0, 225, 90));
	CreateInvisWalls((-4635, 2592, 973),(-5068, 2162, 973));
	
	i=0;
	spawnmodel((-4676.87, 2549.4, 949)+ (-72.53* i,-72.7* i,0), (0, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	spawnmodel((-4676.87, 2549.4, 949)+ (-72.53* i,-72.7* i,0), (0, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	spawnmodel((-4676.87, 2549.4, 949)+ (-72.53* i,-72.7* i,0), (30, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	spawnmodel((-4676.87, 2549.4, 949)+ (-72.53* i,-72.7* i,0), (0, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	spawnmodel((-4666.87, 2559.4, 949)+ (-72.53* i,-72.7* i,0), (90, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	spawnmodel((-4665.87, 2558.4, 949)+ (-72.53* i,-72.7* i,0), (0, 226, 90), "ny_harbor_concrete_floor_broken_med01"); i++; 
	
		
	spawnmodel((-4706.6, 2547, 903), (0, 225, 90), "ny_debris_floor_metal_studs_02");
	spawnmodel((-5014.6, 2242.7, 890), (0, 225, 88), "ny_debris_floor_metal_studs_02");
	spawnmodel((-4893.6, 2353.5, 910), (90, 135, 0), "concrete_slabs_lrg1");
	spawnmodel((-5000, 2229, 914), (0, 46, 83), "rubble_large_slab_02");
	spawnmodel((-4886.66, 2320.54, 931), (104, 135, 90), "ny_metal_beam_red_01");
		
	//ladders
	CreateInvisQuicksteps((-4733.8, 2494, 985), 84, 18, 2, (0,315,0));
	CreateInvisQuicksteps((-4833.8, 2394, 985), 84, 18, 2, (0,315,0));
	
	//spawnmodel((-4720.6, 2482.7, 941), (0, 226, 10), "ny_debris_metal_cluster01");
 	//spawnmodel((-4834, 2370.23, 941), (0, 226, 10), "ny_debris_metal_cluster01");
	
	spawnmodel((-4818, 2384, 961), (104, 136, 90), "wood_plank2");
	spawnmodel((-4849, 2352, 961), (104, 136, 90), "wood_plank2");
	spawnmodel((-4704, 2501, 961), (104, 136, 90), "wood_plank2");
	spawnmodel((-4734, 2460.5, 946), (104, 136, 90), "wood_plank2");
	
	spawnmodel((-4839, 2370.5, 966), (95, 316, 70), "ny_debris_metal_beam04");
	
	spawnmodel((-4851, 2353.6, 980), (17, 133, 90), "aftermath_rebar_group_03");	
	spawnmodel((-4737.4, 2463.8, 970), (17, 133, 87), "aftermath_rebar_group_03");
	
	spawnmodel((-4629.66, 2610.1, 917), (0, 226, 0), "ny_harbor_hwsign_01");
	spawnmodel((-4551, 2090, 914), (0, 270, 0), "vehicle_bus_destructible_mp");
	
	CreateElevator((-9870, 5150, 1245),(-8100, 5150, 1245), 150, 2, (0,-60,0));
	CreateWalls((-9343, 4644.55, 1180),(-9153.27, 4315.7, 1280));
	CreateDeathRegion((-11397, 6261, 400), (-8227, 2599, 1150));
	
	createTP((422, 1699, 15), (-4672, 2166, 915));
	createTP((388, -2222, 161), (-4672, 2166, 915));
	createTP((-899, -829, 87), (-4672, 2166, 915));
	createTP((2343, -461, 97), (-4672, 2166, 915));
	createTP((1388, 1033, 62), (-4672, 2166, 915));
	createTP((659, -525, 81), (-4672, 2166, 915));
	createTP((1254, -3018, 121), (-4672, 2166, 915));
	createTP((-910, 510, -8), (-4672, 2166, 915));
	
	createHiddenTP((-8089.4,4806.79,915.625), (-9194, 4514, 1161.13));
	createHiddenTP((-9619,5299.4,1162), (-8010, 4869, 915), (0,-30,0), undefined, 1);
	
	spawnmodel((-4559, 1782, 915), (0, 10, 0), "vehicle_taxi_yellow_destroy");
	
	//truck
	spawnmodel((-6213, 3784, 915), (0, 340, 0), "vehicle_mack_truck_long");
	
	spawncrate((-6070.32, 3701.08, 960), (0, 340, 90)); 
	spawncrate((-6070.32, 3701.08, 1015), (0, 340, 0)); 
	spawncrate((-6046.33, 3755.79, 960), (0, 340, 270)); 
	spawncrate((-6046.33, 3755.79, 1015), (0, 340, 270)); 
	
	spawncrate((-6049, 3694, 960), (0, 340, 90)); 
	spawncrate((-6029, 3749, 960), (0, 340, 270)); 
	
	spawncrate((-6049, 3694, 1015), (0, 340, 0)); 
	spawncrate((-6029, 3749, 1015), (0, 340, 0)); 
	
	//CreateInvisWalls((-6151, 3786, 973),(-6510, 3917, 973));
	//CreateInvisWalls((-6165, 3746, 973),(-6525, 3875, 973));
	
	//CreateInvisWalls((-6151, 3786, 1010),(-6510, 3918, 1010),(0,340,0));
	//CreateInvisWalls((-6165, 3746, 1010),(-6525, 3875, 1010),(0,340,0));
	CreateInvisWalls((-6526, 3932, 926),(-6550, 3872, 926));
	//CreateInvisQuicksteps((-6522, 3896, 1008), 60, 11, 2, (0,160,0));
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	laddercoll = ladder[0];
	clonedcollision((-6537, 3902.81, 981), (0, 115, 0), laddercoll);
	
	truckcoll = ladder[1];
	clonedcollision((-6343.8, 3836.86, 1003), (0, 115, 0), truckcoll);
	
	//trucktop = getent( "pf968_auto3", "targetname" );
	//clonedcollision((-6335.5, 3828.62, 1040), (0, 115, 0), trucktop);
	//spawncrate((-6200.93, 3776.88, 1020),(90,-20,0),"com_plasticcase_friendly");
	//spawncrate((-6297, 3813.84, 1020),(90,-20,0),"com_plasticcase_friendly");
	
    for(i = 0;i < 3;i++)
	spawncrate((-6200, 3779, 1027)+(-49*i,18*i,0) , (0, -20, 0));
	spawncrate((-6206, 3781, 1021) , (-90, -20, 0));
	spawncrate((-6300, 3816, 1021) , (-90, -20, 0));
	spawncrate((-6496, 3886, 1026) , (0, -20, 0));
	
	spawnmodel((-9354, 4634.78, 1250), (0, 120, 0), "ex_picture_cat_01");
}
interchange_edit2(){
	level.meat_playable_bounds = [
		(-9842.5, 3083.34, 807.125),
		(-10991.8, 2510.78, 775.758),
		(-11932.4, 2158.81, 1397.97),
		(-12564.3, 3894.71, 1410.13),
		(-11608.4, 4226.21, 812.733),
		(-10757.1, 4654.46, 769.483)
	];
	createPolygon();

	createTP((422, 1699, 15), (-10013, 3123, 702), (0, 119, 0));
	createTP((388, -2222, 161), (-10013, 3123, 702), (0, 119, 0));
	createTP((-899, -829, 87), (-10013, 3123, 702), (0, 119, 0));
	createTP((2343, -461, 97), (-10013, 3123, 702), (0, 119, 0));
	createTP((1388, 1033, 62), (-10013, 3123, 702), (0, 119, 0));
	createTP((659, -525, 81), (-10013, 3123, 702), (0, 119, 0));
	createTP((1254, -3018, 121), (-10013, 3123, 702), (0, 119, 0));
	createTP((-910, 510, -8), (-10013, 3123, 702), (0, 119, 0));
	createHiddenTP((-11899.9,4113.32,1258.59), (-11818, 3201, 1434.96), undefined, undefined,1);
	//createHiddenTP((-11921.9,4118.8,1410.13), (131.177,1965.62,-15.9421), undefined, "out");
	
	moveac130position((-6395, 3700, 1678));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-10676, 4159, 754);
	mp_global_intermission.angles = (-13, -113, 0);
	
	CreateWalls((-9884, 3062, 720),(-10967, 2524, 720));
	CreateWalls((-9884, 3062, 780),(-10967, 2524, 780));
	CreateWalls((-10218, 3278, 710),(-10073, 3001, 820));
	CreateDoors((-10127, 3333, 800) /*open*/, (-10127, 3333, 720) /*close*/, (90,120,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateWalls((-10792, 4635, 720),(-11588, 4231, 720));
	CreateWalls((-10792, 4635, 780),(-11588, 4231, 780));
	CreateGrids((-10599, 3329, 912),(-10689, 3137, 912), (0,20,0));
	CreateWalls((-10696, 3285, 930),(-10658, 3181, 1010));
	CreateRamps((-10608, 3351, 897),(-10716, 3642, 700));
	CreateRamps((-10655, 3118, 920),(-11120, 2948, 1130));
}

interchange_edit3(){
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "vehicle_subcompact_mica_destructible" || ent.model == "vehicle_taxi_yellow_destructible_dusty" || ent.model == "vehicle_taxi_yellow_destructible" || ent.model == "com_ex_airconditioner" || ent.model == "vehicle_jeep_destructible" || ent.model == "me_electricbox4") {
			//iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}	
	}

	level.meat_playable_bounds = [
		(-9842.5, 3083.34, 807.125),
		(-10991.8, 2510.78, 775.758),
		(-11932.4, 2158.81, 1397.97),
		(-12564.3, 3894.71, 1410.13),
		(-11608.4, 4226.21, 812.733),
		(-10757.1, 4654.46, 769.483)
	];

	createTP((1765.05,-1472.41,82.125), (3456, -1049, 165));
	createTP((1207.71,-3008.1,113.377), (3456, -1049, 165));
	createTP((-689.772,511.373,-8.875), (3456, -1049, 165));
	createTP((1478.27,-164.083,131.108), (3456, -1049, 165));
	createTP((1222.88,1316.79,73.66), (3456, -1049, 165));
	createTP((5233, -911, 688), (131.177,1965.62,-15.9421), undefined, "out");
	
	createPolygon();
	
	//Fake floor
	//CreateGrids((3425, -185, 93),(3143, 132, 93), (0, 31,0));	
	//CreateWalls((2976, -37, 83),(3741, 417, 83),vectortoangles((2976, -37, 83)-(3741, 417, 83))+(0,90,0));
	
	//Block wall
	//CreateWalls((3602, 643, 150),(2533, -26, 150));
	//CreateWalls((3602, 643, 90),(2533, -26, 90));
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((2558, 13, 150), (0, 170, 0), truckcoll);
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((2778, 151, 150), (0, 170, 0), truckcoll);
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((2966, 272, 150), (0, 170, 0), truckcoll);
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((3182, 410, 150), (0, 170, 0), truckcoll);
	
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((3379, 539, 150), (0, 165, 0), truckcoll);
	
	//end wall block
	spawncrate((3603, 648, 100), (0, 30, 0));
	spawncrate((3598, 645, 180), (0, 30, 0));
	// First Door
	CreateDoors((3716, 550, 250) /*open*/, (3716, 550, 160) /*close*/, (90,30,0) /*angle*/, 2 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	spawncrate((3716, 550, 137), (0, -60, 0)); //walk up
	
	//Door Ramp
	CreateinvisGrids((3602, 450, 83),(3736, 510, 83), (-18,31,0));
	
	ent = spawn("script_model", (3649, 508, 103));
	ent.angles = (-16, 0, 10);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	
	ent = spawn("script_model", (3680, 560, 95));
	ent.angles = (0, 0, 0);
	ent setmodel_hook("com_trafficcone02");
	
	//Left Side
	spawncrate((3667, 626, 117), (0, -60, 0));
	spawncrate((3667, 626, 175), (0, -60, 0));
	spawncrate((3667, 626, 240), (0, -60, 0));
	
	ent = spawn("script_model", (3667, 626, 93));
	ent.angles = (0, -60, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3667, 626, 125));
	ent.angles = (0, -145, 0);
	ent setmodel_hook("aftermath_rebar_group_03");
	
	ent = spawn("script_model", (3667, 626, 180));
	ent.angles = (0, -145, 0);
	ent setmodel_hook("aftermath_rebar_group_03");
	
	//Right Side
	spawncrate((3769, 458, 117), (0, -60, 0));
	spawncrate((3769, 458, 175), (0, -60, 0));
	spawncrate((3769, 458, 240), (0, -60, 0));
	
	ent = spawn("script_model", (3769, 458, 109));
	ent.angles = (0, -60, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3769, 458, 135));
	ent.angles = (0, 35, 0);
	ent setmodel_hook("aftermath_rebar_group_03");
	
	ent = spawn("script_model", (3769, 458, 190));
	ent.angles = (0, 35, 0);
	ent setmodel_hook("aftermath_rebar_group_03");
	
	//Truck bed
	CreateinvisWalls((3713, 607, 165),(4018, 792, 170));
	
	ent = spawn("script_model", (3725, 610, 152));
	ent.angles = (0, 30, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3791, 649, 152));
	ent.angles = (0, 30, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3854, 687, 152));
	ent.angles = (0, 30, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3917, 725, 152));
	ent.angles = (0, 30, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	ent = spawn("script_model", (3983, 766, 152));
	ent.angles = (0, 30, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	
	//block under truck bed
	spawncrate((3869, 637, 115), (0, 30, 0));
	
	//Truck bed to ramp
	//CreateRamps((4032, 669, 128),(4100, 557, 128));
	//CreateRamps((4078, 689, 128),(4139, 591, 128));
	
	ent = spawn("script_model", (4080, 633, 131));
	ent.angles = (0, 0, 0);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	
	//Ramp Up
	CreateRamps((4105, 551, 136),(4370, 105, 400));
	CreateRamps((4154, 579, 136),(4406, 126, 398));
	
	ent = spawn("script_model", (4240, 374, 148));
	ent.angles = (0, 30, -27);
	ent setmodel_hook("cargocontainer_20ft_green");
	
	ent = spawn("script_model", (4357, 171, 266));
	ent.angles = (0, 30, -27);
	ent setmodel_hook("cargocontainer_20ft_green");
	
	//Top Ramp Floor
	spawncrate((4450, 62, 418), (0, 125, 0),"com_plasticcase_friendly");
	spawncrate((4397, 27, 418), (0, 125, 0),"com_plasticcase_friendly");
	spawncrate((4476, 16, 418), (0, 125, 0),"com_plasticcase_friendly");
	spawncrate((4428, -17, 418), (0, 125, 0),"com_plasticcase_friendly");
	spawncrate((4468, -26, 451), (0, -150, 0),"com_plasticcase_friendly");
	spawncrate((4472, -24, 503), (0, -150, 0),"com_plasticcase_friendly");
	
	//Side Spot ¯\_(ツ)_/¯
	ent = spawn("script_model", (5202, 38, 265));
	ent.angles = (0, -30, 0);
	ent setmodel_hook("defaultactor");
	
	//Roof Walls
	i=-0;
	ent = spawn("script_model", (4188, -235, 433));
	ent.angles = (0, 121, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (4412, -100, 433));
	ent.angles = (0, 121, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((4263, -193, 500), (0, -15, 0), truckcoll);
	
	i=-0;
	ent = spawn("script_model", (3836, 17, 433)+(131* i, -225* i, 0));i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3836, 17, 433)+(131* i, -225* i, 0));i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3836, 17, 433)+(131* i, -225* i, 0));i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3836, 17, 433)+(131* i, -225* i, 0));i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ladder = getentarray( "pf968_auto1", "targetname" );
	truckcoll = ladder[1];
	clonedcollision((4092, 378, 500), (0, 0, 0), truckcoll);
	
	i=-0;
	ent = spawn("script_model", (3392, 20, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3392, 20, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3392, 20, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3392, 20, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (3392, 20, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	
	i=-0;
	ent = spawn("script_model", (4064, 420, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	ent = spawn("script_model", (4064, 420, 433)+(132* i, -222* i, 0));i++;
	ent.angles = (0, 211, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	
	i=-0;
	ent = spawn("script_model", (4111, -826, 433));
	ent.angles = (0, 121, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
	
	
	//Ramp up (last stage)
	CreateInvisRamps((4239, -995, 660),(4026, -604, 415));
	CreateInvisRamps((4186, -1022, 660),(3973, -634, 415));	

	i=0;
	ent = spawn("script_model", (4032, -662, 443)+(45* i, -80* i, 50* i));i++;
	ent.angles = (0, 31, -30);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	ent = spawn("script_model", (4032, -662, 443)+(45* i, -80* i, 50* i));i++;
	ent.angles = (0, 31, -30);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	ent = spawn("script_model", (4032, -662, 443)+(45* i, -80* i, 50* i));i++;
	ent.angles = (0, 31, -30);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	ent = spawn("script_model", (4032, -662, 443)+(45* i, -80* i, 50* i));i++;
	ent.angles = (0, 31, -30);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	ent = spawn("script_model", (4032, -662, 443)+(45* i, -80* i, 50* i));i++;
	ent.angles = (0, 31, -30);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	
	
	i=0;
	
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_pipe_8x128_metal_rusted");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower");
	ent = spawn("script_model", (-9949.9, 5152, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_base_broken1");
	ent = spawn("script_model", (-9949.9, 5352, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_base2_broken1");
	ent = spawn("script_model", (-9949.9, 5552, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_top_broken2");
	ent = spawn("script_model", (-9949.9, 5752, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_top_broken3");
	ent = spawn("script_model", (-9949.9, 5952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_top2_broken2");
	ent = spawn("script_model", (-9949.9, 6152, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("com_powerline_tower_top2_broken3");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("concrete_barrier_damaged_2");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("concrete_barrier_damaged_3");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("concrete_slabs_lrg1");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_barrier_bollard_02");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_debris_floor_metal_studs_02");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_debris_metal_beam04");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_debris_metal_cluster01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_med01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,200* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_harbor_concrete_floor_broken_sml01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_harbor_hwsign_01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_harbor_hwsign_02");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("ny_metal_beam_red_01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("road_debris_01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("rubble_large_slab_02");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("vehicle_bus_destructible_mp");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("vehicle_bus_static");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("vehicle_firetruck");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("vehicle_m1a1_abrams_dmg");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("vehicle_mack_truck_long");	
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("beam_med_short_01");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("wood_plank2");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("aftermath_rebar_group_03_50_scale");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("concrete_barrier_damaged_1");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("aftermath_rebar_group_03");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("aftermath_rebar_group_02_50_scale");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_white");
	ent = spawn("script_model", (-9949.9, 4952, 1600) + (0,0,300* i)); i++;
	ent.angles = (0, 210, 0);
	ent setmodel_hook("cargocontainer_20ft_green");
}

seatown_edit1(){
	//Edit By Clippy
	
	level.meat_playable_bounds = [
		(-3188.13, -3681.67, 27.125),
		(-1929.02, -3682.69, 247.125),
		(-1927.83, -3397.11, 242.099),
		(-1579.16, -2032.88, 486.348),
		(-1576.37, -1939.12, 439.473),
		(-2657.88, -91.531, 297.103),
		(-3070.26, -93.9842, 54.4214),
		(-4196.31, -3763.55, 174.354),
		(-3667.78, -4391.33, 174.354)
	];
	createPolygon();

	CreateInvisWalls((-2270, -2800, 200),(-2270, -2640, 350));
	CreateWalls((-1915, -3409, 220),(-1915, -3695, 220));
	CreateWalls((-1946, -3695, 220),(-2720, -3695, 220));
	CreateWalls((-2720, -3695, 240),(-2720, -3695, 400), (0,180,90));
	CreateWalls((-2705, -3695, 400),(-3050, -3695, 480));
	CreateWalls((-3050, -3695, 0),(-3050, -3695, 480), (0,180,90));
	CreateWalls((-3050, -3695, 0),(-3170, -3695, 0));
	CreateQuicksteps((-2970, -2505, 473), 100, 18, 2, (0,-90,0));
	CreateQuicksteps((-2920, -2505, 473), 100, 18, 2, (0,-90,0));
	CreateGrids((-3000, -2500, 473),(-2330, -2400, 473), (0,0,0));
	CreateGrids((-2700, -80, 170),(-3050, -80, 170),(-20,0,90));
	i=0;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
	i=0;
	spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	CreateWalls((-1560, -2030, 430),(-1560, -1940, 560));
	createTP((-1754, 1293, 200), (-2156, -2723, 192.125), undefined);
	createTP((82, 1091, 87), (-2156, -2723, 192.125), undefined);
	createTP((1219, 1094, 170), (-2156, -2723, 192.125), undefined);
	createTP((1129, -1121, 205), (-2156, -2723, 192.125), undefined);
	createTP((-1483, -1261, 152), (-2156, -2723, 192.125), undefined);
	createTP((-2144, -277, 188), (-2156, -2723, 192.125), undefined);
	createTP((-2206, -1488, 288), (-2156, -2723, 192.125), undefined);
	createTP((-2206, -1488, 152), (-2156, -2723, 192.125), undefined);
	createTP((-659, -216, 166), (-2156, -2723, 192.125), undefined);
	//createHiddenTP((-2089, -3341, 448.125), (-2096.49,-1771.31,214.598), undefined, "out");
	moveac130position((-2321, -1658, 417.316));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2993, -3515, 498);
	mp_global_intermission.angles = (22, 35, 0);
	
	
	i=0;
	spawnmodel((-2279, -2664, 240)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 240)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 240)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 240)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	
	i=0;
	spawnmodel((-2279, -2664, 335)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 335)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 335)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
	spawnmodel((-2279, -2664, 335)+ (0,-60* i,0), (90, 90, 0), "ch_mattress_boxspring"); i++;
}

seatown_edit2(){
	//Edit By ?
	
	level.meat_playable_bounds = [
		(2701.45, 290.792, 620.458),
		(3107.82, 290.708, 620.458),
		(3107.74, 1135.29, 620.458),
		(2635.94, 1141.91, 774.125),
		(2629.21, 1548.18, 774.125),
		(1664.96, 1550.8, 774.125),
		(1665.06, 1727.63, 774.125),
		(1091.55, 1727.89, 774.125),
		(1089.27, 1294.78, 801.906),
		(1433.62, 1054.16, 609.126),
		(1438.19, 378.08, 586.621),
		(1719.27, 375.997, 539.179),
		(1732.13, 528.438, 292.125),
		(2343.46, 528.211, 292.125),
		(2343.18, -2.55017, 299.125),
		(2704.78, -2.69424, 300.125)
	];
	createPolygon();
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2834.2, 177, 909);
	mp_global_intermission.angles = (29, 140, 0);	
	
	CreateDeathRegion((2249, 78, 166), (2700, -149, 120));//WALLBREACH FIX
	
	spawnmodel((1678, 730, 395), (90, 270, 0), "me_corrugated_metal8x8_holes");
	spawnmodel((1680, 681, 390), (90, 270, 0), "me_corrugated_metal8x8_holes");
	spawnmodel((1680, 803, 390), (103, 270, 0), "me_corrugated_metal8x8_holes");
	CreateWalls((3120, 275, 550),(3120, 1135, 550));
	CreateWalls((3120, 275, 600),(3120, 1135, 600));
	CreateWalls((3120, 1135, 550),(2630, 1135, 550));
	CreateWalls((3120, 1135, 600),(2630, 1135, 600));
	CreateWalls((3080, 275, 550),(2690, 275, 550));
	CreateWalls((3080, 275, 600),(2690, 275, 600));
	CreateInvisWalls((2585, -15, 190),(2359, -15, 190));
	CreateInvisWalls((2585, -15, 260),(2359, -15, 260));
	CreateWalls((2670, 1045, 140),(2670, 1045, 500),(0,0,90));
	CreateWalls((2340, 1550, 770),(2340, 1360, 850));
	CreateWalls((2340, 1180, 770),(2340, 970, 850));
	CreateWalls((1880, 1180, 770),(1880, 970, 850));
	CreateWalls((1880, 1550, 770),(1880, 1360, 850));
	CreateGrids((1680, 1310, 759),(1680, 1530, 759), (0,0,0));
	CreateRamps((1550, 1280, 750),(1550, 570, 560));
	spawncrate((1715, 550, 565), (90, 0, 0), "com_plasticcase_trap_friendly");
	createTurret((1715, 550, 595), (0,0,0), undefined, undefined, 80, 10);
	moveac130position((1036, 166, 228.986));
	CreateGrids((1645, 615, 225),(1470, 615, 225), (0,0,0));
	spawncrate((1487, 773, 235), (0, 0, 0), "com_plasticcase_friendly");
	i=0;
	p = (2667, 960, 525);
	spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
	spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
	spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
	spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
	i=0;
	p = (2800, 1032, 530);
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
	CreateDoors((2340, 1270, 870) /*open*/, (2340, 1270, 790) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 1 /*sideways*/);
	CreateDoors((1880, 1270, 870) /*open*/, (1880, 1270, 790) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 80 /*range*/, 1 /*sideways*/);
	CreateElevator((2745, 1000, 548),(2650, 1100, 548), 211, 2);
	CreateGrids((2650, 1100, 548),(2745, 1000, 548), (0,0,0));
	fufalldamage((1595, 708, 564.125),200,100);
	CreateDeathRegion((1435, 1055, 340), (1765, 1590, 170));
	createTP((-1754, 1293, 200), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((82, 1091, 87), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((1219, 1094, 170), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((1129, -1121, 205), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((-1483, -1261, 152), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((-2144, -277, 188), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((-2206, -1488, 288), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((-2206, -1488, 152), (1525.86,707.351,323.926),(0, 0, 0));
	createTP((-659, -216, 166), (1525.86,707.351,323.926),(0, 0, 0));
	createHiddenTP((2688.88,49.8435,180.645), (3062.9,348.911,563.125),(0, 110, 0));
}
arkaden_edit1(){
	level.meat_playable_bounds = [
	(-1065, -2323, 801.43),
	(-4069, -2377, 808.473),
	(-4092, -1420, 762.768),
	(-4746, -1409, 757.026),
	(-5504, -1400, 759.22),
	(-5497, 1017, 741.642),
	(-4739, 1018, 765.486),
	(-4735, -633, 769.485),
	(-2048, -632, 744.207),
	(-2020, -1766, 772.807),
	(-1060, -1762, 783.368)
		];
	createPolygon();
	//Edit By Revox
	moveac130position((-3394, -1562, 4700));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-5380, 359, 1350);
	mp_global_intermission.angles = (-17, 47, 0);
	//protecting wall
	CreateWalls((-1180, -2030, 745),(-1180, -2140, 825));
	// small wall at the TP
	CreateWalls((-1065, -2192, 750),(-1065, -2275, 750));
	CreateWalls((-1065, -2192, 800),(-1065, -2275, 800));
	//long wall left side road block
	CreateWalls((-1980, -2338, 770),(-2673, -2338, 746));
	//Grid by 1st doors
	CreateGrids((-2000, -1810, 800),(-1900, -2000, 800), (-30,0,0));
	//death barrier below grid
	CreateDeathRegion((-2065, -2030, 500), (-663, -1780, 800));
	//ramp to grid
	CreateRamps((-2077, -1810, 730),(-2077, -1990, 785));
	//top of grid ramp
	CreateRamps((-1860, -2000, 870),(-1860, -1800, 870));
	//wall end of ramp
	CreateWalls((-1908, -2009, 850),(-2097, -2009, 770));
	//wall next to doors
	CreateWalls((-1800, -2260, 750),(-1800, -2300, 830));
	//doors
	CreateDoors((-1800, -2130, 830) /*open*/, (-1800, -2130, 760) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 1 /*sideways*/);
	// long wall left side end of edit
	CreateWalls((-4112, -1423, 750),(-4721, -1423, 750));
	//long wall right side end of edit
	CreateWalls((-3216, -636, 770),(-4721, -635, 770));
	//grid / elevator
	CreateElevator((-4700, -666, 725),(-4700, -1393, 725), 605, 2, (0,0,0));
	//Soft Landing
	fufalldamage((-4422, -1023, 736.125),650, 1000);
	//walls protecting the player cannons
	CreateWalls((-3744, -1390, 745),(-3744, -1180, 850));
	CreateWalls((-3743, -855, 745),(-3744, -645, 850));
	//Top of building elevator sight blocker
	CreateWalls((-4700, -633, 1350),(-4860, -633, 1430));
	//Player cannons
	cannonball((-3667, -750, 720), (0,0,0), 3, (-4769, -750, 1420), 300);
	cannonball((-3672, -1300, 720), (0,0,0), 3, (-4765, -1320, 1420), 300);
	//End of edit roof wall
	CreateWalls((-4747, 1011, 1370),(-5494, 1012, 1370));
	//Roof Pylons
	spawncrate((-5125, -362, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5125, -362, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4987, -121, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4987, -121, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5292, -189, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5292, -189, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5231, 36, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5231, 36, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4986, 177, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4986, 177, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4842, 28, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-4842, 28, 1415),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5411, 137, 1365),(90,90,0), "com_plasticcase_friendly");
	spawncrate((-5411, 137, 1415),(90,90,0), "com_plasticcase_friendly");
	//Roof turrets
	spawncrate((-5380, 738, 1345), (90, 90, 0), "com_plasticcase_trap_friendly");
	createTurret((-5380, 738, 1380), (0,-90,0), 25, 25, undefined,undefined, 10);
	spawncrate((-4860, 738, 1345), (90, 90, 0), "com_plasticcase_trap_friendly");
	createTurret((-4860, 738, 1380), (0,-90,0), 25, 25, undefined,undefined, 10);
	//Turrets Inner Walls
	CreateWalls((-5349, 735, 1380),(-5249, 735, 1380));
	CreateWalls((-5349, 735, 1350),(-5249, 735, 1350));
	CreateWalls((-4893, 736, 1380),(-4993, 736, 1380));
	CreateWalls((-4893, 736, 1350),(-4993, 736, 1350));
	//Roof Doors
	CreateDoors((-5121, 737, 1440) /*open*/, (-5121, 737, 1360) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	spawncrate((-4941, 764, 1356) , (0, 0, 0) , "com_plasticcase_friendly"); //tmg headglitch
	//Turret Side Walls
	CreateWalls((-4829, 736, 1380),(-4736, 980, 1380));
	CreateWalls((-5413, 736, 1380),(-5504, 980, 1380));
	CreateWalls((-4829, 736, 1350),(-4736, 980, 1350));
	CreateWalls((-5413, 736, 1350),(-5504, 980, 1350));
	//Turret Top Blocker
	spawncrate((-5381, 713, 1360),(0,0,0), "com_plasticcase_friendly");
	spawncrate((-4860, 713, 1360),(0,0,0), "com_plasticcase_friendly");
	spawncrate((-5381, 713, 1420),(0,0,0), "com_plasticcase_friendly");
	spawncrate((-4860, 713, 1420),(0,0,0), "com_plasticcase_friendly");
	createTP((-42, 1399, 616), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-224, -1431, 608), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-1353, 1318, 730), (-1121, -2086, 736), (0, -90, 0), 1);    // TPs out the map
	createTP((-1088, -784, 801), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((391, -816, 642), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-1433, 14, 800), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-1433, 14, 800), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-1433, 14, 608), (-1121, -2086, 736), (0, -90, 0), 1);    //
	createTP((-346, -177, 640), (-1121, -2086, 736), (0, -90, 0), 1);    //
	//createHiddenTP((-5125, 962, 1338.15), (1126.04,-1715.55,670.125), undefined, "out"); // TP back into the map
}
arkaden_edit2(){
	level.meat_playable_bounds = [
		(3018.95, 93.915, 697.125),
		(1339.98, 88.2641, 711.375),
		(1330.08, 2414.41, 735.691),
		(32.9156, 4531.84, 702.012),
		(-1069.5, 3325.6, 672.612),
		(-4132.24, 3237.36, 892.178),
		(-4143.19, 4732.5, 654.97),
		(-2051.9, 4835.49, 727.125),
		(-2051.9, 4835.49, 727.125),
		(-990, 5175, 640),
		(83.7819, 5859.87, 725.449),
		(1057.34, 4975.4, 765.886),
		(2606.98, 2391.93, 767.438),
		(3043.53, 2393.7, 660.489)
	];
	createPolygon();
	moveac130position((-551, 3749, 5000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1216, 2950, 734);
	mp_global_intermission.angles = (-12, 54, 0);
	
	spawnmodel((2880, 1314, 777) , (15, 0, 0) , "pb_pallet_bags");
	spawnmodel((2841, 1314, 787) , (15, 0, 0) , "pb_pallet_bags");
	spawnmodel((2802, 1314, 797) , (15, 0, 0) , "pb_pallet_bags");
	spawnmodel((2764, 1313, 806) , (15, 0, 0) , "pb_pallet_bags");
	spawnmodel((2728, 1312, 815) , (15, 0, 0) , "pb_pallet_bags");
	spawnmodel((2877, 1343, 816) , (0, -90, -14) , "berlin_painting_tall_10");
	spawnmodel((2805, 1343, 827) , (14, 1, 0) , "ch_corkboard_metaltrim_4x8");
	spawnmodel((2718, 1311, 818) , (14, 0, 0) , "com_ammo_pallet");
	spawnmodel((2804, 1344, 815) , (-9, 180, 0) , "berlin_sign_arkaden");
	spawnmodel((2805, 1329, 822) , (9, 1, 0) , "com_airduct_150x_square");
	for(i = 0;i < 4;i++)
	spawncrate((2716, 1310, 848)+ (56* i,0,-15* i) , (0, 90, 15));

	CreateInvisWalls((-1019, 5163, 700),(-1253, 5032, 750));
	CreateWalls((2990, 80, 670),(1780, 80, 670));	   // long wall at the back near TP
	CreateInvisWalls((1841, 2004, 640),(1944, 1979, 640));  //
	CreateInvisWalls((1944, 1979, 640),(2035, 1928, 640));  // 3 Under car / terrain clip blockers
	CreateInvisWalls((2035, 1928, 640),(2091, 1761, 640));  //
	CreateWalls((1325, 1960, 740),(1325, 1460, 740));	//
	CreateWalls((1325, 1960, 680),(1325, 1460, 680));	// 3 stack wall by car
	CreateWalls((1325, 1960, 620),(1325, 1460, 620));	//
	CreateWalls((2990, 2390, 620),(2600, 2390, 700));	//
	CreateWalls((2600, 2390, 620),(2340, 2820, 700));	// 3 Small walls before bridge
	CreateWalls((1325, 2220, 620),(1325, 2310, 700));	//
	// 1350 middle
	CreateWalls((730, 3440, 860),(1250, 3440, 720));	// Bridge wall Left
	CreateWalls((1450, 3440, 860),(2000, 3440, 720));	// Bridge wall Right
	spawncrate((695, 3391, 869), (0, 45, 0), "com_plasticcase_friendly");
	// Bridge doors
	CreateDoors((1350,3440,850) /*open*/, (1350,3440,780) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 1 /*sideways*/);
	CreateWalls((1010, 5000, 680),(1140, 4780, 620));
	CreateWalls((1040, 4970, 680),(50, 5870, 620));	 // Behind bridge wall 1/2
	CreateWalls((50, 5860, 680),(-52, 5880, 620));	  // 2/2
	CreateWalls((-2070, 4820, 640),(-2140, 4820, 720));     // Between buildings wall
	CreateWalls((-4150, 4550, 660),(-4150, 3230, 660));     // Big Wall at the end 1/2
	CreateWalls((-4150, 4550, 710),(-4150, 3230, 710));     // 2/2
	
	createTP((-42, 1399, 616), (2914.75,762.342,775.904), (0, 121, 0));    //
	createTP((-224, -1431, 608), (2914.75,762.342,775.904), (0, 121, 0));    //
	createTP((-1353, 1318, 730), (2914.75,762.342,775.904), (0, 121, 0));    //TPs out the map
	createTP((-1088, -784, 801), (2914.75,762.342,775.904), (0, 121, 0));    //
	createTP((391, -816, 642), (2914.75,762.342,775.904), (0, 121, 0));    //
	createTP((-1433, 14, 800), (2914.75,762.342,775.904), (0, 121, 0));    //
	createTP((-1433, 14, 608), (2914.75,762.342,775.904), (0, 121, 0));    //
	//createHiddenTP((-4120,3760,634), (1126.04,-1715.55,670.125), undefined, "out"); // TP back into the map
	//tmg crate oom fix
	CreateDeathRegion((-4354, 4550, 790),(-4061, 4810, 450));
	//tmg wall
	CreateWalls((-1667, 4152, 635),(-1652, 3901, 710));
	CreateDeathRegion((83, 2254, 400), (1720, 5475, 620));
	CreateDeathRegion((2359, 2848, 400), (-226, 4417, 600));
}
lockdown_edit1(){
	level.meat_playable_bounds = [
		(-1488.65, -826.026, 1046.47),
		(556.228, 2005.88, 733.294),
		(779.125, 2056.78, 742.548),
		(1135.59, 2056.82, 738.606),
		(1122.55, 669.333, 767.639),
		(1412.79, 668.803, 663.544),
		(1477.35, -439.518, 616.125),
		(2245.86, -442.607, 616.125),
		(2245.47, -1988.48, 616.125),
		(-1223.93, -1991.2, 695.837),
		(-1236.9, -1307.45, 977.125),
		(-1486.07, -1307.44, 977.125)
	];
	createPolygon();
	moveac130position((354, -470, 3000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (580, -1516, 647);
	mp_global_intermission.angles = (-21, 45, 0);
	h = 950;
	CreateWalls((-1499, -870, h),(-1499, -1310, h));
	CreateWalls((-1470, -1320, h),(-1250, -1320, h));
	h -= 50;
	CreateWalls((-1499, -870, h),(-1499, -1310, h));
	CreateWalls((-1470, -1320, h),(-1250, -1320, h));
	h -= 50;
	CreateWalls((-1499, -870, h),(-1499, -1310, h));
	CreateWalls((-1470, -1320, h),(-1250, -1320, h));
	h -= 50;
	CreateWalls((-1499, -870, h),(-1499, -1310, h));
	CreateWalls((-1470, -1320, h),(-1250, -1320, h));
	h = 640;
	CreateWalls((443.5, -1420, h),(-150, -1420, h));
	CreateWalls((445, -1450, h),(445, -1980, h));
	h += 50;
	CreateWalls((443.5, -1420, h),(-150, -1420, h));
	CreateWalls((445, -1450, h),(445, -1980, h));
	h += 50;
	CreateWalls((443.5, -1420, h),(-150, -1420, h));
	CreateWalls((445, -1450, h),(445, -1980, h));
	h += 50;
	CreateWalls((443.5, -1420, h),(-150, -1420, h));
	CreateWalls((445, -1450, h),(445, -1980, h));
	CreateWalls((1030, -1600, 620),(780, -1600, 705.5));
	CreateWalls((320, -1200, 620),(320, -1020, 620));
	CreateWalls((320, -1200, 677),(320, -1020, 677));
	CreateDoors((320, -1310, 710) /*open*/, (320, -1310, 637) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateRamps((740, -1840, 600),(990, -1840, 680));
	spawncrate((1030, -1840, 689),(0,90,0), "com_plasticcase_friendly");
	CreateGrids((1400, -1760, 689),(1800, -1730, 689), (0,0,0));
	CreateGrids((2000, -1600, 689),(2000, -870, 689), (0,0,0));
	CreateGrids((1820, -790, 689),(1430, -760, 689), (0,0,0));
	CreateRamps((1300, -670, 700),(1300, -300, 850));
	CreateWalls((1115, 1270, 740),(1000, 1270, 825));
	fufalldamage((295, -1615, -10),250, 100);
	fufalldamage((-644, -808, 616.125),250, 100);
	CreateDeathRegion((-63, -2034, -96.8731),(-1317, -644, 268.455));
	CreateDeathRegion((1256, -448, 126.872),(1639, 635, -24.0806));
	createTP((-1647, 2339, 129), (-1436, -973, 810), (0,0,0));
	createTP((193, -58, -3), (-1436, -973, 810), (0,0,0));
	createTP((-35, 2227, -7), (-1436, -973, 810), (0,0,0));
	createTP((-1680, 1482, -7), (-1436, -973, 810), (0,0,0));
	createTP((-652, -118, -4), (-1436, -973, 810), (0,0,0));
	createTP((-1640, -160, 0), (-1436, -973, 810), (0,0,0));
	createTP((-521, 1205, -7), (-1436, -973, 810), (0,0,0));
	//createHiddenTP((888, 1882, 896.075), (323, 2173, 1), undefined,  "out");
	//Wall Breach Patch
	CreateWalls((1115, 2050, 550),(652, 2050, 700));
}

lockdown_edit2(){
	level.meat_playable_bounds = [
		(330, 2509, 801.43),
		(632, 3550, 808.473),
		(1357, 3550, 762.768),
		(1357, 4767, 762.768),
		(-1357, 4764, 762.768),
		(137, 4764, 759.22),
		(-499, 4927, 222),
		(-546, 4668, 765.486),
		(-3443, 4584, 769.485),
		(-3513, 5306, 744.207),
		(-5663, 7072, 772.807),
		(-6787, 5387, 772.807),
		(-3968, 3390, 772.807),
		(-3016, 2945, 772.807),
		(-2386, 2655, 772.807),
		(-1157, 2482, 783.368)
	];
	createPolygon();
	moveac130position((-1818, 4772, 4180));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (31, 2966, 35);
	mp_global_intermission.angles = (-22.0276, 71, 0);
	
	//TP in edit
	createTP((-1647, 2339, 129), (-28,2578,0),(0, 90, 0),undefined);
	createTP((193, -58, -3), (-28,2578,0),(0, 90, 0),undefined);
	createTP((-35, 2227, -7), (170,2589,0),(0, 90, 0),undefined);
	createTP((-1680, 1482, -7), (170,2589,0),(0, 90, 0),undefined);
	createTP((-652, -118, -4), (-28,2578,0),(0, 90, 0),undefined);
	createTP((-1640, -160, 0), (-28,2578,0),(0, 90, 0),undefined);
	createTP((-521, 1205, -7), (-28,2578,0),(0, 90, 0),undefined);
	//2nd stage
	createTP((1312,4350.673,-3.875), (-101,3192.81,625.625),(0, 180, 0),1,50,100,40);
	createTP((-323.4,4078.623,-50.875), (-101,3192.81,625.625),(0, 180, 0),1,50,100,40);
	createTP((-275.56, 4397.2, -40.875), (-65,3701.11,625.625),(0, 180, 0),1,50,40,40);
	
	createTP((-1277, 3967, 838), (-3640.2,3280.4,960),(0, 63, 0),1,40,100,80);
	createHiddenTP((-5816, 5020, 1033),(-1106.68,2714,710), (0,0,0), undefined, 1, undefined, undefined, 80);
	CreateWalls((-1497, 3712, 900),(-1497, 4233, 900));
	CreateWalls((-1497, 3712, 840),(-1497, 4233, 840));
	CreateWalls((-1497, 4024, 780),(-1497, 4233, 780));
	CreateWalls((-1497, 4129, 720),(-1497, 4233, 720));
	//late flag spawn
	createTP((-249,3591,-10), (-3640.2,3280.4,960),(0, 63, 0),1,40,100,430);
	//CreateBombsquadGrids((134, 3601, 200),(28, 3601, 200),(-23,0,90));
	//spawncrate((45, 3600, 127),(45,0,90), "com_plasticcase_trap_bombsquad");
	//spawncrate((28, 3600, 187),(285,0,90), "com_plasticcase_trap_bombsquad");

	CreateQuicksteps((-3516, 3499, 820), 80, 18, 14, (0,330,0));
	CreateQuicksteps((-4692, 4839, 760), 140, 18, 14, (0,340,0));
	CreateRamps((-4557, 4789, 631),(-4592, 4803, 643));
	spawncrate((922, 4045, 600), (90, 270, 90));

	CreateDeathRegion((255, 2541, -200), (1111, 3909, 156));
	CreateInvisWalls((220.824, 2827, 170),(220.824, 2980, 170));
	CreateWalls((-309.5, 3546, -4),(-309.5, 3640, 123));
	CreateWalls((-368.8, 4076.8, -40),(-368.8, 4281.8, 70));
	CreateWalls((-276, 4407, -35),(-276, 4619, 95));
	CreateWalls((227.9, 4775.7, 40),(1328, 4775.7, 40));
	//CreateDoors((230.4,3945,10) /*open*/, (70.4,3945,10) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 3 /*height*/, 20 /*hp*/, 130 /*range*/, 1 /*sideways*/);
	spawncrate((271, 3240, 410),(90,90,0));
	spawncrate((271, 3920, 410),(90,90,0));
	spawncrate((-82, 3859, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((-62, 3963, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((-45, 4075, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((-25, 4185, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((-20, 4295, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((9, 4406, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((27, 4517, 470),(90,350,0), "com_plasticcase_friendly");
	spawncrate((49.8, 4632.4, 470),(90,342,0), "com_plasticcase_friendly");
	CreateRamps((-637, 4045, 705),(-494, 4045, 675));
	CreateRamps((-673, 2742, 690),(-673, 2889, 720));
	spawncrate((-673, 2920, 725),(0,0,0), "com_plasticcase_friendly");
	CreateRamps((161, 2734, -23),(161, 2830, 4));
	CreateDeathRegion((-462.3,4744.13,90), (-1121.13,2945.9,200.64));
	CreateDeathRegion((-936.9,3734.25,90), (-2653.5,4926.4,200.64));
	CreateDeathRegion((-1864,2699.4,90), (-5196, 7616, 420.64));
	CreateDeathRegion((-5273, 4377.4,780), (-6962, 6545, 300.64));
	CreateDeathRegion((-379.3,4663.13,157), (-560.13,4795.9,355.64));
	CreateWalls((-3783.6, 3322.5, 940),(-3386.88, 3111.8, 940));
	CreateWalls((-3783.6, 3322.5, 1010),(-3386.88, 3111.8, 1010));

	spawncrate((-3733, 3413, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3706, 3463, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3679, 3513, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3652, 3563, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3625, 3613, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3652, 3627, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3679, 3641, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3706, 3655, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3733, 3669, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3760, 3683, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3787, 3697, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3814, 3711, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3841, 3725, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3868, 3739, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3895, 3753, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3922, 3767, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3949, 3781, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3976, 3795, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4003, 3809, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4030, 3823, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4057, 3837, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4084, 3851, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4111, 3865, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4138, 3879, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4165, 3893, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4192, 3907, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4219, 3921, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4246, 3935, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4273, 3949, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4300, 3963, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4327, 3977, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4354, 3991, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4381, 4005, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4408, 4019, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-4435, 4033, 730),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-5562, 4047, 730),(0,62,0), "com_plasticcase_friendly");

	spawncrate((-3738.9, 3396, 920),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3765.9, 3346, 920),(0,62,0), "com_plasticcase_friendly");
	spawncrate((-3733, 3413, 773),(90,62,0), "com_plasticcase_friendly");
	spawncrate((-3733, 3413, 830),(90,62,0), "com_plasticcase_friendly");
	spawncrate((-3733, 3413, 888),(90,62,0), "com_plasticcase_friendly");
	spawncrate((-3684, 3313, 931),(0,62,270), "com_plasticcase_friendly");
	CreateWalls((-3592, 3635, 745),(-3542, 3609, 810));
	CreateWalls((-3591, 3651, 745),(-3493, 3827, 810));
	CreateBombsquadWalls((-3019, 3836.6, 890),(-4024, 4419.6, 890));
	spawncrate((-4013, 4412, 875),(305,152,90), "com_plasticcase_trap_bombsquad");
	spawncrate((-4013, 4412, 927),(55,152,90), "com_plasticcase_trap_bombsquad");

	CreateBombsquadWalls((-3612, 5270, 1136),(-4335, 5887, 1136));
	CreateBombsquadWalls((-4335, 5887, 1136),(-4510, 5999, 1136));
	spawncrate((-4499, 5995, 1121),(305,152,90), "com_plasticcase_trap_bombsquad");
	spawncrate((-4499, 5995, 1173),(55,152,90), "com_plasticcase_trap_bombsquad");

	CreateRamps((-4436, 4319, 721),(-4436, 4598, 630));
	CreateRamps((-4813, 5155, 754),(-4660, 5466, 884));
	CreateRamps((-5488, 5245, 1004),(-5230, 5400, 940));
	spawncrate((-5518.5, 5225.9, 1010),(0,121,0), "com_plasticcase_friendly");
	CreateRamps((-5703, 5345, 1004),(-5703, 5670, 1160));

	//cannonball((-1457, 3120, 230), (0,90,0), 3, (-4281, 5437, 1080), 2100);
	cannonball((-4737, 4364, 844), (0,62,0), 4, (-4281, 5437, 1080), 300);
	fufalldamage((-4509, 4962, 630),660, 1000);
	fufalldamage((783, 3547, -10),1300, 1000);
	spawnmodel((845, 3972, 581) , (0, 20, 90) , "viewmodel_desert_eagle_gold_mp");
	spawnmodel((217, 2651, 141) , (0, 90, 0) , "prague_awning02");
	CreateDeathRegion((1366, 3560, 803), (921, 4028, 536));
}

nuketown_edit1(){
	classicents = GetEntArray("classicinf", "targetname");
	foreach(ent in classicents)
		ent delete();

	level.meat_playable_bounds = [
		(-177, -16389, 22),
		(314, -16536, -22),
		(339, -19945, -22),
		(-132, -19945, -22),
		(-16958, -4030, -22),
		(-17554, -3197, -22),
		(-16686, -2399, -22),
		(-15960, -3186, -22)
	];

	createPolygon();
	moveac130position((22, -18212, 100));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (197, -17698, 51);
	mp_global_intermission.angles = (-29, 115, 0);
	
	//wallbreach fix
	spawncrate((26, -19399, 69) , (0, -90, 0));
	spawncrate((26, -19451, 69) , (0, -90, 0));
	spawncrate((132, -19399, 69) , (0, -90, 0));
	spawncrate((132, -19451, 69) , (0, -90, 0));
	CreateDoors(( -20, -19346, 89) /*open*/,(39, -19346, 89) /*close*/, (90,0,90) /*angle*/, 1 /*size*/, 1 /*height*/, 30 /*hp*/, 19 /*range*/, 1 /*sideways*/);
	createTurret((88,-19353,108), (0,90,358),46,46);
	
	//wall (start)
	createwalls((-17228, -3585, -40),(-17110, -2869, 84));
	createwalls((-17081, -3748, -40),(-16735, -3737, 84));

	//createHiddenTP((49, -15949, -193.18), (-233,-525, -30), (0,90,0), "out", 0, 90, 220);
	createTP((-17142, -3198, -31), (46, -17076, 663), (0, 270, 0),0,40,100,20);
	createTP((-16892, -3723, -31), (46, -17076, 663), (0, 270, 0),0,40,100,20);
	createTP((-1335, 1002, -63), (-16725, -2617, -26), (0, 310, 0));
	createTP((-500, 564, -61), (-16725, -2617, -26), (0, 310, 0), undefined, undefined, 300 );
	createTP((-1295, 257, -60), (-16725, -2617, -26), (0, 310, 0));
	createTP((699, 660, -60), (-16217, -3253, -26), (0, 130, 0));
	createTP((1400, 271, -60), (-16217, -3253, -26), (0, 130, 0));
	createTP((796, -22, -60), (-16217, -3253, -26), (0, 130, 0));
	//spawncrate((33, -19313, 44), (0,180,24));
	spawncrate((33, -19313, 42), (0,180,24));
	CreateWalls((-16325, -3216, -21),(-16430, -3086, -21));
	CreateWalls((-16325, -3216, 45),(-16430, -3086, 45));
	CreateWalls((-16325, -3216, -21),(-16255, -3300, 80));
	CreateWalls((-16581, -2913, -21),(-16724, -2740, -21));
	CreateWalls((-16581, -2913, 45),(-16724, -2740, 45));
	CreateWalls((-16800, -2651, -21),(-16724, -2740, 80));
	CreateWalls((-16501, -3177.4, -26),(-16438, -3260, 86));
	CreateWalls((-16767, -2854, -26),(-16669, -2964.4, 86));

	//backup
	//CreateTrapWalls((-16442, -3088, -31),(-16791, -3379, 80));
	//CreateTrapWalls((-16576, -2917, -31),(-16923, -3215, 80));
	CreateTrapWalls((-16791, -3379, -25),(-16432.1, -3079.5, -25));
	CreateTrapWalls((-16576, -2917, -25),(-16923, -3215, -25));
	CreateTrapWalls((-16721.7, -3323, 5),(-16432.1, -3079.5, 5));
	CreateTrapWalls((-16576, -2917, 5),(-16860, -3159.9, 5));
	CreateTrapWalls((-16721.7, -3323, 35),(-16432.1, -3079.5, 35));
	CreateTrapWalls((-16576, -2917, 35),(-16860, -3159.9, 35));
	CreateTrapWalls((-16781, -3370.34, 5),(-16781, -3370.34, 60),(0,40,90));
	CreateTrapWalls((-16912, -3207.77, 5),(-16912, -3207.77, 60),(0,40,90));
	CreateTrapWalls((-16791, -3379, 61),(-16432.1, -3079.5, 61));
	CreateTrapWalls((-16576, -2917, 61),(-16923, -3215, 61));
	//doors
	//spawncrate((-16793, -3330, 14), (0, -90, 0));
	//spawncrate((-16878, -3235, 14), (0, -21, 0));
	//CreateDoors(( -16824, -3277, -60) /*open*/,(-16824, -3277, -16) /*close*/, (90,85,90) /*angle*/, 2 /*size*/, 1 /*height*/, 60 /*hp*/, 160 /*range*/);
	CreateDoors(( -16828, -3273, 90) /*open*/,(-16828, -3273, -16) /*close*/, (90,130,90) /*angle*/, 6 /*size*/, 2 /*height*/, 50 /*hp*/, 130 /*range*/);
	fufalldamage((75, -17230, -9),660, 900);
}
carbon_edit1(){
	level.meat_playable_bounds = [
	(-3003.22, -4593.43, 4177.53),
	(-2924, -5631, 3664.11),
	(-2842.49, -6045.9, 4034.92),
	(-2391.51, -6182.24, 4345.49),
	(-2483.94, -6527.66, 4391.08),
	(-1788.78, -6711.94, 4347.13),
	(-1787.23, -7328.73, 4070.34),
	(-2043.3, -7331.33, 4057.89),
	(-2042.83, -7912.82, 4062.91),
	(-1010.91, -7914.66, 4105.9),
	(-1015.96, -7668.05, 4171.26),
	(-642.198, -7667.54, 4258.32),
	(-640.88, -6375.64, 4072.64),
	(-54.9237, -6375.67, 4064.13),
	(-55.0662, -6029.2, 4064.13),
	(-396.45, -5950.17, 4060.32),
	(-125.462, -4444.11, 4594.04)
	];
	createPolygon();
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "me_lightfluohang" || ent.model == "me_electricbox4" || ent.model == "com_barrel_benzin" || ent.model == "com_wall_fan_blade" || ent.model == "utility_transformer_ratnest01" || ent.model == "machinery_oxygen_tank01" || ent.model == "fence_tarp_40x58" ||ent.model == "machinery_oxygen_tank02" ||ent.model == "com_ex_airconditioner") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
	}  
	}
	moveac130position((-1485, -6573, 5945));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2096, -5195, 3781);
	mp_global_intermission.angles = (-17, -71, 0);
	createTP((-2549, -4792, 3724), (-1447, -5107, 3790.18), (0,190,0 ), 1);
	createTP((-3554, -3925, 3571), (-2874, -5564, 3664.18), (0,90,0 ), 1);
	createTP((-2988, -3209, 3752), (-1447, -5107, 3790.18), (0,190,0 ), 1);
	createTP((-134, -3402, 3898), (-2874, -5564, 3664.18), (0,90,0 ), 1);
	createTP((-464, -4494, 3906), (-2874, -5564, 3664.18), (0,90,0 ), 1);
	createTP((-1726, -3896, 3751), (-2874, -5564, 3664.18), (0,90,0 ), 1);
	//createHiddenTP((-1053, -7863, 4772.18), (-2228.91,-2783.47,3758.13), undefined, "out");
	createHiddenTP((-685, -7624, 4080.96), (-1767.57, -7628.52, 4608.13), undefined);
	
	//new tmg shit
	
	//ladders
	
	CreateInvisQuicksteps((-2451.47, -5774, 4010), 100, 16, 2, (0,180,0));	
	CreateInvisQuicksteps((-2786.86, -5933, 3890), 100, 16, 1, (0,280,0));
	spawncrate((-2788, -5971.7, 3795), (0, 100, 0));
	CreateInvisQuicksteps((-2764.88, -5970, 3795), 70, 16, 1, (0,10,0));
	
	spawnmodel((-2771, -5946.86, 3810), (0,190,0), "com_stepladder_large_closed");
	spawnmodel((-2777, -5962.37, 3803), (0,100,0), "com_pallet_2");
	spawnmodel((-2742, -5956.2, 3724), (0,280,0), "com_stepladder_large_closed");
	
	spawnmodel((-2466, -5791, 3930), (0,90,0), "com_stepladder_large_closed");	
	
	//pipe bridge
	CreateInvisramps((-2380.73, -5828.51, 3983),(-2069.93, -6258.73, 4019), (0,0,0));
	
	spawnmodel((-2160, -6100, 4014), (94,126,0), "roof_chimney_metal_tall_01");	
	spawnmodel((-2160.11, -6100.46, 4013.5), (86, 306, 0), "roof_chimney_metal_tall_01");
	spawnmodel((-2176, -6110, 4014), (94,126,0), "roof_chimney_metal_tall_01");	
	spawnmodel((-2176.11, -6110.46, 4013.5), (86, 306, 0), "roof_chimney_metal_tall_01");
	spawnmodel((-2192, -6120, 4014), (94,126,0), "roof_chimney_metal_tall_01");	
	spawnmodel((-2192.11, -6120.46, 4013.5), (86, 306, 0), "roof_chimney_metal_tall_01");		
	// Spawn Blocker
	CreateWalls((-2930, -5630, 3710),(-2960, -5530, 3710));
	// Conveyor wall
	CreateWalls((-2835, -5985, 3740),(-2835, -5985, 3740),(0,90,90));
	CreateWalls((-2835, -5985, 3810),(-2835, -5985, 3810),(0,90,90));
	// Grid wall long
	CreateGrids((-630, -6420, 4000),(-1880, -6420, 4000),(6,90,90));
	CreateGrids((-630, -6420, 4060),(-1880, -6420, 4060),(6,90,90));
	// Near tp wall
	CreateWalls((-1001, -7680, 4090),(-616, -7680, 4090));
	CreateWalls((-1001, -7680, 4140),(-616, -7680, 4140));
	// ele
	CreateElevator((-1645, -5649, 3745),(-1700, -5545, 3745), 193, 2,(0,-18,0));
	CreateElevator((-1770, -7855, 4600),(-1820, -7740, 4600), 168, 2,(0,0,0));
	// Roof walls
	CreateGrids((-2500, -6535, 4330),(-2860, -6535, 4330),(0,-105,90));
	CreateGrids((-2497, -6535, 4330),(-3200, -6535, 4330),(0,165,90));
	// Spawn roof
	CreateGrids((-2912, -5611, 3771.35),(-2768, -5731, 3771.35),(0,90,0));
	CreateGrids((-1800, -6750, 4320),(-2400, -6750, 4320),(-23,90,90));
	CreateGrids((-1800, -6900, 4170),(-2040, -6900, 4170),(-23,90,90));
	CreateGrids((-1800, -7075, 3980),(-2040, -7075, 3980),(0,90,90));
	CreateGrids((-1800, -7075, 4050),(-2040, -7075, 4050),(0,90,90));
	spawncrate((-290, -6195, 3930), (0, 80, 0), "com_plasticcase_friendly");
	moveac130position((-1735, -6197, 3891.97));
	//CreateWalls((-2534, -6508, 4302),(-1949, -6665, 4342));
	//CreateWalls((-2465, -6495, 4288),(-2377, -6179, 4309));
}
bootleg_edit1(){
	level.meat_playable_bounds = [
	(1238.7, -596.576, 250.531),
	(1271.92, -1252.4, 103.542),
	(1108.45, -1251.23, 96.5536),
	(1110.75, -1393.06, 96.5536),
	(912.855, -1394.75, 84.5103),
	(911.424, -1719.38, 94.0974),
	(1423.96, -1717.56, 60.9901),
	(2201.13, -1828.87, 28.125),
	(2713.48, -1829.31, 28.125),
	(2713.48, -1117.87, 28.125),
	(2999.7, -1117.87, 28.125),
	(3029, -773.992, 20.4325),
	(2708.94, -773.992, 20.4325),
	(2684.86, -775.7, -12.875),
	(2690.69, 311.321, -8.98451),
	(1982.25, 326.462, -94.8811),
	(1983.98, 692.35, -55.6746),
	(1881.96, 692.354, 0.46185),
	(1348, 690.988, -56.9334),
	(1337.06, 689.715, 497.125),
	(1338.87, -112.082, 493.802),
	(1245.91, -449.441, 153.715)
	];
	createPolygon();
	moveac130position((2281, -627, 3222));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1479, -1280, -61);
	mp_global_intermission.angles = (-21, 49, 0);
	// Spawn wall
	CreateWalls((940, -1710, -30),(1400, -1710, -30));
	// 1st wall + doors
	CreateWalls((1830, -1250, -80),(1830, -1490, 25));
	CreateWalls((1830, -880, -80),(1830, -1050, 25));
	CreateDoors((1830, -1150, 60) /*open*/, (1830, -1150, -65) /*close*/, (90,180,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	// outer map bounds wall
	cannonball((1311, -809, 168.), (0,0,0), 3, ((2597, 251, -20)), 1000);
	CreateWalls((2685, -771, -40),(2685, 307, -40));
	CreateWalls((2685, -771, -80),(2685, 307, -80));
	// Camping angled wall grid
	CreateGrids((2000, -330, 10),(2330, -385, 10), (0,0,0));
	// 2nd doors/grid floor
	CreateGrids((2300, 290, 10),(2480, 130, 10), (0,0,0));
	CreateGrids((2300, 96, 10),(2300, -300, 10), (0,0,0));
	CreateDoors((2345, 210, 140) /*open*/, (2345, 210, 50) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateWalls((2345, 105, 30),(2345, -250, 115));
	// End of map roof grid
	CreateGrids((1550, -95, 320),(1440, 140, 320), (0,0,0));
	// Roof long wall
	CreateInvisWalls((1335, 850, 420),(1335, -95, 495));
	// End map indicator wall
	CreateWalls((1365, 703, -80),(1895, 703, -80));
	//block/crate
	spawncrate((1985, -640, 260), (90, 90, 0), "com_plasticcase_friendly");
	spawncrate((1985, -640, 330), (90, 90, 0), "com_plasticcase_friendly");
	//block in edit window (building)
	spawncrate((2717, -843, 2), (90, 0, 0));
	spawncrate((2717, -1052, 2), (90, 0, 0));
	// Quicksteps up //(Height, step units,Dist-per-step)
	CreateQuicksteps((1840, -711, 153), 260, 16, 2, (0,0,0));
	CreateQuicksteps((2480, 104, 10), 110, 16, 2, (0,-90,0));
	CreateQuicksteps((2010, -300, 10), 130, 16, 2, (0,90,0));
	CreateQuicksteps((1380, 580, 350), 100, 16, 2, (0,90,0));
	// Elevator
	//CreateGrids((1590, -80, -116),(1695, -25, -116), (0,0,0));
	CreateElevator((1610, -80, -116),(1710, -25, -116), 436, 2);
	fufalldamage((1659, -49, -109.719),100, 500);
	createTP((-1739, 99, -49), (1005, -1475, -65), (1, -39, 0));
	createTP((-907, 1370, -101), (1005, -1475, -65), (1, -39, 0));
	createTP((-838, -147, 78), (1005, -1475, -65), (1, -39, 0));
	createTP((-838, -147, -67), (1005, -1475, -65), (1, -39, 0));
	createTP((-1416, -1355, 2), (1005, -1475, -65), (1, -39, 0));
	createTP((185, -2004, 8), (1005, -1475, -65), (1, -39, 0));
	createTP((527, 685, -100), (1005, -1475, -65), (1, -39, 0));
	createTP((503, -679, -67), (1005, -1475, -65), (1, -39, 0));
	//createHiddenTP((1383, -76, 406), (-343.66,567.401,-67.875), undefined, "out");
	//createHiddenTP((1613, 664, -110), (-343.66,567.401,-67.875), undefined, "out");
	fufalldamage((2071, -692, -71.875),250, 100);
}
bootleg_edit2(){
level.meat_playable_bounds = [
	(-3504.88, 62.875, -49.375),
	(-2535.12, 62.8695, -49.375),
	(-2535.12, -3639.88, -49.375),
	(-3504.88, -3639.87, -16.875)
	];
	createPolygon();
	CreateDeathRegion((-3839, -2435.6, -30), (-4020, -3004, 220));
	moveac130position((-2406, -1913, 3333));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2568, -91, -46);
	mp_global_intermission.angles = (-20, -139, 0);
	createTP((-1739, 99, -49), (-3426, -90, -104), (3, 29, 0));
	createTP((-907, 1370, -101), (-3426, -90, -104), (3, 29, 0));
	createTP((-838, -147, 78), (-3426, -90, -104), (3, 29, 0));
	createTP((-838, -147, -67), (-3426, -90, -104), (3, 29, 0));
	createTP((-1416, -1355, 2), (-3426, -90, -104), (3, 29, 0));
	createTP((185, -2004, 8), (-3426, -90, -104), (3, 29, 0));
	createTP((527, 685, -100), (-3426, -90, -104), (3, 29, 0));
	createTP((503, -679, -67), (-3426, -90, -104), (3, 29, 0));
	//createHiddenTP((-3481, -3616, -71.875), (-343.66,567.401,-67.875), undefined, "out");

	// Spawn wall
	CreateWalls((-3505, -170, -105),(-3244, -170, -20));
	CreateWalls((-3244, -140, -105),(-3244, -90, -20));
	// Under bridge blocker
	CreateWalls((-3505, 93, -80),(-2536, 93, -80));
	// small cover walls
	CreateWalls((-2536, -1443, -105),(-2667, -1443, -20));
	CreateWalls((-2960, -845, -105),(-3100, -845, -20));
	// dirt pille blocker
	//CreateInvisWalls((-3535, -2165, 40),(-3535, -3238, 120));
	CreateInvisWalls((-3535, -2165, 70),(-3535, -3238, 70));
	CreateInvisWalls((-3535, -2165, 120),(-3535, -3238, 120));
	// end of edit wall
	CreateWalls((-3500, -3670, -105),(-2530, -3670, 40));
}
dome_edit1(){
	level.meat_playable_bounds = [
		(2049.92, 1554.75, -77.0074),
		(2049.88, 1750.53, -112.875),
		(1664.43, 1752.46, -112.875),
		(1666.16, 3086.18, -112.875),
		(276.588, 3085.48, -112.875),
		(177.655, 2340.49, -65.6654),
		(-369.34, 2389.11, -40.9176),
		(-400.516, 2036.9, -8.65177),
		(-863.373, 1844.95, 60.5338),
		(-866.619, 1512.67, 14.7827)
	];
	//Edit By ?
	createPolygon();
	moveac130position((1492, 3233, 2260));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1756, 3199, -13);
	mp_global_intermission.angles = (30, -133, 0);
	CreateWalls((2065, 1575, -140),(2065, 1770, -220));
	CreateWalls((2065, 1770, -140),(1680, 1770, -220));
	CreateWalls((1680, 1770, -140),(1680, 3100, -220));
	CreateWalls((1680, 3100, -140),(260, 3100, -220));
	CreateWalls((700, 3100, -220),(260, 3100, -275));
	CreateWalls((260, 3080, -140),(260, 2950, -275));
	CreateDoors((1550, 1905, -85) /*open*/, (1550, 1905, -180) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 118 /*range*/, 1 /*sideways*/);
	CreateDoors((1440, 2825, -180) /*open*/, (1590, 2825, -180) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	createHiddenTP((343.967,2958.23,-253.358), (335.964,2842.02,-256.891), undefined);
	//createHiddenTP((-830, 1591, -195.692), (-275.176,-154.868,-194.375), undefined, "out");
	CreateWalls((-875, 1540, -182),(-875, 1830, 5));
	createTP((1314, 1234, -254), (1957.74,1637.76,-184.385), (0, 180, 0));
	createTP((744, -353, -394), (1957.74,1637.76,-184.385), (0, 180, 0));
	createTP((-556, 165, -416), (1957.74,1637.76,-184.385), (0, 180, 0));
	createTP((665, 2031, -250), (1957.74,1637.76,-184.385), (0, 180, 0));
	createTP((183, 1050, -308), (1957.74,1637.76,-184.385), (0, 180, 0));
	createTP((-1238, 1203, -435), (1957.74,1637.76,-184.385), (0, 180, 0));
	spawnmodel((-211, 1983, -160), (0,270, 90), "foliage_drygrass_squareclump");//importantmodel
}
dome_edit2(){
	level.meat_playable_bounds = [
		(2055.34, 1544.1, -2.46946),
		(2113.14, 258.18, -68.6855),
		(1551.61, -353.257, -139.933),
		(-119.59, -288.15, -191.048),
		(-545.548, -480.529, -220.675),
		(-976.108, -612.992, -223.743),
		(-1142.43, -217.422, -207.92),
		(-1295.35, 322.345, -285.796),
		(-1800.38, 954.672, 33.474),
		(1943.76, 1544.14, 64.8481)
	];
	createPolygon();
	//Edit By ?
	//stop cp blocking
	moveac130position((2017, -166, 1330));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2169, 200, -29);
	mp_global_intermission.angles = (32, 131, 0);
	spawnmodel((-730, -491, -320), (0,202, 0), "com_steel_ladder2");
	spawnmodel((-730, -491, -320), (0,202, 0), "com_steel_ladder_top");
	CreateInvisQuicksteps((-718, -486.9, -325), 105, 15, 2, (0,202,0));
	spawncrate((-1057, -346.9, -366), (90, 20, 90), "com_plasticcase_friendly");
	spawncrate((-1153, -97.9, -366), (90, 200, 90), "com_plasticcase_friendly");
	CreateRamps((-1164, -95, -318),(-1054, -363, -318));
	
	CreateGrids((2052, 1549, -90.297),(1955, 1364, -90.297), (0,0,0));
	spawncrate((1745, 820, -220), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((1800, 820, -220), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((1855, 820, -220), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((1720, 930, -220), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((1720, 875, -220), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((1565, 430, -265), (0, -110, 0), "com_plasticcase_friendly");
	spawncrate((1545, 375, -265), (0, -110, 0), "com_plasticcase_friendly");
	spawncrate((1525, 320, -265), (0, -110, 0), "com_plasticcase_friendly");
	spawncrate((1505, 265, -265), (0, -110, 0), "com_plasticcase_friendly");
	CreateRamps((1945, 960, -280),(1730, 960, -210));

	CreateWalls((2065, 925, -230),(1860, 925, -285));
	CreateWalls((2065, 925, -140),(1860, 925, -195));
	CreateWalls((1940, 700, -140),(1700, 700, -195));
	CreateInvisWalls((1940, 700, -210),(1790, 700, -210));

	spawncrate((1710, 700, -202), (90, 90, 0), "com_plasticcase_friendly");
	spawncrate((1740, 700, -202), (90, 90, 0), "com_plasticcase_friendly");
	CreateRamps((2000, 585, -320),(2000, 310, -228));
	CreateGrids((2000, 289, -220),(1719, 182, -220), (0,0,0));
	CreateWalls((1680, 0, -170),(1680, 680, -250));
	CreateWalls((1710, 315, -200),(1890, 315, -200));

	CreateDoors((1965, 810, -275) /*open*/, (1965, 810, -170) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 10 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	CreateWalls((1420, -360, -340),(1510, -360, -260));

	CreateQuicksteps((-329, -150, -319), 105, 15, 2, (0,25,0));
	spawncrate((-532, -470, -319), (0, 25, 0), "com_plasticcase_friendly");
	spawncrate((-646, -506, -319), (0, 25, 0), "com_plasticcase_friendly");
	CreateQuicksteps((-1180, 420, -102), 200, 18, 2, (0,-90,0));
	CreateGrids((-1330, 405, -122),(-1080, 710, -122), (0,24,0));
	CreateWalls((-1047, 486, -80),(-1196, 808, -150));
	Deathradius((-1360, 498, -270), 150, 140);
	Deathradius((-913, 678, -270), 210, 140);
	Deathradius((-1216, 1006, -270), 350, 140);
	Deathradius((-1612, 745, -270), 400, 140);
	createTP((1314, 1234, -254), (1989, 1505, -183.423), (0, -91, 0));
	createTP((744, -353, -394), (1989, 1505, -183.423), (0, -91, 0));
	createTP((-556, 165, -416), (1989, 1505, -183.423), (0, -91, 0));
	createTP((665, 2031, -250), (1989, 1505, -183.423), (0, -91, 0));
	createTP((183, 1050, -308), (1989, 1505, -183.423), (0, -91, 0));
	createTP((-1238, 1203, -435), (1989, 1505, -183.423), (0, -91, 0));
	createHiddenTP((1737, 632, -230.875), (-190, -283, -403.783), (0, 115, 0), undefined, undefined, 30, 80);
	//createHiddenTP((-1150, 781, -18.9069), (956, 2026, -254.875), (0, 115, 0), "out");
}
dome_edit3(){
	
	//machinery_windmill //maybe not
	//foliage_desertbrush_3_animated //mb not
	//foliage_pacific_flowers06_animated
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "com_ex_airconditioner" || ent.model == "vehicle_hummer_destructible" || ent.model == "machinery_oxygen_tank02" || ent.model == "me_electricbox4" || ent.model == "fence_tarp_130x56" || ent.model == "fence_tarp_107x56" || ent.model == "fence_tarp_151x56" || ent.model == "fence_tarp_134x56" || ent.model == "fence_tarp_140x56" || ent.model == "fence_tarp_167x56" || ent.model == "fence_tarp_134x76"       || ent.model == "foliage_pacific_bushtree01_animated" || ent.model == "foliage_desertbrush_3_animated" || ent.model == "foliage_pacific_flowers06_animated")  {	 
	ent delete();
	}
	}
	//end screen memes 
	spawnmodel((932, 1434, -253) , (-1, 7, 0) , "mp_body_opforce_ghillie_desert_sniper");
	//spawnmodel((929, 1433, -194) , (-11, 366, -12) , "com_teddy_bear");
	//spawnmodel((1012, 1386, -197) , (-18, 439, -22) , "com_teddy_bear");
	spawnmodel((1016, 1389, -255) , (-1, 69, -4) , "mp_body_opforce_ghillie_desert_sniper");
	spawnmodel((858, 1312, -256) , (0, 0, 0) , "com_restaurantchair_1");
	spawnmodel((955, 1415, -214) , (29, 334, -64) , "weapon_desert_eagle_iw5");
	spawnmodel((872, 1227, -255) , (0, 459, 0) , "com_floodlight_blue_on");
	spawnmodel((825, 1326, -255) , (0, 15, 0) , "com_red_toolbox_dusty");
	spawnmodel((929, 1433, -194) , (-1, 371, -12) , "com_teddy_bear");
	spawnmodel((1011, 1388, -197) , (-13, 454, -2) , "com_teddy_bear");
	spawnmodel((841, 1216, -181) , (0, 175, 0) , "ch_bulletinpaperdecals_1");
	  //tps
	 createTP((-764, 565, -376), (-717.76, 510.12, -252), undefined, undefined, 20, 112, undefined); //fence
	 spawnmodel((-784, 583, -273) , (1, 213, 171) , "ims_scorpion_body_placement");
	 createHiddenTP((464, -166, -390),(-586, 1918, -206),(0, 210, 0), undefined, 1,60);
	  
	//spawns
	//wtf is this spawn holy shit kill me dm spawns too?
	createTP((135.5, 255.6, -496), (1375.5, 294, -368), (0, 111, 0), undefined, 1, 112, undefined, 1);//spawn_wtf
	spawnmodel((131, 274, -391) , (0, 25, 0) , "icbm_electronic_cabinet7_busted");
	spawncrate((134, 265, -346) , (90, 25, 0)); 
	createTP((28.2, -344.6, -480), (1119, 333, -380), (0, -10, 0), undefined, 1, 112, undefined, 1);//spawn_wtf2
	spawnmodel((39, -361, -391) , (0, 179, 0) , "icbm_electronic_cabinet7_busted");
	spawncrate((37, -353, -336) , (90, 179, 0)); 
	
	createTP((-799.8, 1456.9, -350), (1192, 1476, -249), (0, -45, 0), undefined, 1, 112, undefined, 1);//spawn1
	spawnmodel((-809, 1461, -268) , (0, 0, 0) , "berlin_hesco_barrier_med");//spawn1
	spawncrate((-809, 1460, -244) , (90, 0, 0));//spawn1
	createTP((-764.7, -177.6, -510), (1241, 292, -381), (0, 76, 0), 1, 2, 112, undefined, 1);//spawn2
	spawnmodel((-755, -173, -419) , (0, 15, 0) , "berlin_hesco_barrier_med");//spawn2
	spawncrate((-755, -173, -395) , (90, 15, 0));//spawn2
	createTP((-1007.7, 166, -516), (1375.5, 294, -368), (0, 111, 0), 1, 1, 112, undefined, 1);//spawn3
	spawnmodel((-1007.7, 166, -414) , (0, 0, 0) , "com_barrel_fire");//spawn3
	spawncrate((-1007.7, 166, -394) , (90, 20, 0));//spawn3
	createTP((-147.1, 2174.2, -390), (1348.6, 1471, -250), (0, 270, 0), 1, 1, 112, undefined, 1); //spawn4
	spawnmodel((-147.1, 2174.2, -292) , (0, 0, 0) , "com_barrel_white_rust");//spawn4
	spawncrate((-147.1, 2174.2, -235) , (90, 20, 0));//spawn4
	createTP((-846.2, 604.5, -560), (1176.6, 1385, -250), (0, 10, 0), 1, 1, 112, undefined, 1);//spawn5  
	spawnmodel((-867, 646, -438) , (90, -41, 0) , "icbm_electronic_cabinet2_busted");//spawn5 	
	spawncrate((-851, 621, -437) , (0, -41, 0));//spawn5 
	spawncrate((-828, 601, -437) , (0, -41, 0));//spawn5 
	createTP((-1538.9, 1360.2, -530), (1176.6, 1385, -250), (0, -20, 0), 1, 1, 112, undefined, 1);//spawn6
	spawnmodel((-1549, 1367, -431) , (0, 90, 0) , "ch_icbm_console_busted");//spawn6
	spawncrate((-1524, 1364, -417) , (0, 90, 0));//spawn6
	spawncrate((-1524, 1377, -417) , (0, 90, 0));//spawn6
	spawncrate((-1541, 1364, -401) , (0, 90, 0));//spawn6
	spawncrate((-1541, 1377, -401) , (0, 90, 0));//spawn6	
	createTP((313.9, 2175.9, -350), (1642.2, 799.8, -310), (0, 225, 0), 1, 1, 112, undefined, 1);//spawn7
	spawnmodel((318, 2174, -264) , (0, -6, 0) , "berlin_hesco_barrier_med");//spawn7
	for(i = 0;i < 3;i++)
	spawncrate((311, 2178, -210)+(0,0,i*32) , (0, -96, 1));//spawn7
	createTP((1174, 2442, -390), (1515, 1428, -252), (0, 270, 0), undefined, 50, 200, undefined, 1);//
	createTP((1110, 1577.1, -370), (1413, 425.6, -345), (0, 110, 0), undefined, 50, 200, undefined, 1);//
	createTP((951, -391, -490), (1330.6, 434.9, -356), (0, 100, 0), 1, 550, 200, undefined, 1);//
	
	moveac130position((-606, 2015, 0));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1006.57, 1426.1, -218);
	mp_global_intermission.angles = (-24, 224, 0);
	spawnmodel((-2735, 1270, -82) , (0, 0, 0) , "machinery_radome_cage");//dome
	CreateDoors((-936, 1186, -424) /*open*/, (-879, 1051, -424) /*close*/, (90,115,90) /*angle*/, 5 /*size*/, 2 /*height*/, 45 /*hp*/, 118 /*range*/);
	CreateElevator((-1254.66, 1131.45, -442),(-1194.67, 1266, -442), 170, 8, (0,20,0));
	CreateDoors((-191, 138, -268) /*open*/, (-191, 138, -350) /*close*/, (90,115,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 50 /*range*/, 1 /*sideways*/);
	fufalldamage((-209, -11, -380),500, 250);
	
	//stuck spots
	spawncrate((-950, 961, -266) , (0, 105, 0));
	spawncrate((-973, 1045, -266) , (0, 105, 0));
	spawncrate((-548, -475, -327) , (0, 25, 0));
	spawncrate((-661, -512, -327) , (0, 20, 0));
	spawncrate((63, -340, -190) , (0, -3, 0));//dome stuck
	spawncrate((0, 271, -222), (0, 25, 0)); //deathbarrier block
	spawncrate((390, 108, -222) , (0, -63, 0));//dome hole
	spawncrate((-82, 229, -222) , (0, -148, 0));//dome hole
	spawncrate((-224, -96, -222) , (0, -68, 0));//dome hole
	spawncrate((-224, -96, -219) , (0, -68, 0));//dome stuck
	spawncrate((304, -245, -146) , (-39, -51, 0));//dome stuck
	spawncrate((286, -224, -169) , (-39, -51, 0));//dome stuck
	spawncrate((406, -60, -134) , (-39, 0, 0));//dome stuck
	spawncrate((380, -59, -155) , (-39, 0, 0));//dome stuck
	spawncrate((-19, 177, -172) , (0, 24, 0));//dome stuck
	spawncrate((23, 196, -172) , (0, 24, 0));//dome stuck
	spawncrate((-54, -228, -174) , (0, -44, -34));//dome stuck
	spawncrate((-92, -191, -174) , (0, -44, -34));//dome stuck
	spawncrate((134, 302, -95) , (0, 0, 0));//dome stuck
	spawncrate((-221, 104, -43) , (92, 74, -1));//dome stuck
	spawncrate((-230, -51, -93) , (0, 94, 0));//dome stuck
	spawncrate((378, -165, -200) , (0, -127, 0));
	spawncrate((343.7, -219, -200) , (0, -127, 0));
	
	//fence
	spawncrate((-892, 489, -103) , (0, 20, 0));//stuck
	spawncrate((-957, 464, -103) , (0, 20, 0));//stuck
	for(i = 0;i < 4;i++)
	spawncrate((-1161, 378, -42)+(-60* i, 0, 0) , (90, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-1161, 378, 52)+(-60* i, 0, 0) , (90, 0, 0));
    
	//cover
	spawnmodel((741, 1130, -278) , (0, 86, 0) , "ny_manhattan_building_electricalboxunit_a");
	/* //try with it off
	spawnmodel((700, 995, -309) , (5, 1, 4) , "com_pallet_stack");
	spawnmodel((704, 991, -277) , (5, -6, 3) , "com_pallet_stack");
	spawnmodel((619, 994, -317) , (-1, 0, 4) , "vehicle_forklift");
	*/
	spawncrate((761, 1103, -222) , (0, 85, 0));
	spawncrate((791, 1101, -222) , (0, 86, 0));
	spawncrate((821, 1097, -222) , (0, -94, 0));
	spawncrate((761, 1103, -190) , (0, 86, 0));
	spawncrate((791, 1101, -190) , (0, 86, 0));
	spawncrate((821, 1097, -190) , (0, -94, 0));
	 
    //block funnels
	spawnmodel((87, 881, -317) , (0, 0, 0) , "berlin_hesco_barrier_med");//mid map
	spawnmodel((287, 845, -323) , (0, 0, 0) , "berlin_hesco_barrier_med");
	spawnmodel((237, 845, -324) , (0, -10, 0) , "berlin_hesco_barrier_med");
	spawnmodel((186, 845, -317) , (-1, 0, 1) , "berlin_hesco_barrier_med");
	spawnmodel((139, 871, -317) , (0, 0, 0) , "berlin_hesco_barrier_med");
	spawnmodel((75, 920, -301) , (0, 0, 0) , "com_barrel_fire");
	spawnmodel((118, 806, -328) , (0, 0, 0) , "foliage_pacific_bushtree01_animated");
	spawncrate((282, 849, -260) , (90, 0, 0));//coll
	spawncrate((238, 844, -261) , (90, -10, 0));//coll
	spawncrate((185, 844, -262) , (90, 0, 0));//coll
	spawncrate((140, 870, -259) , (90, 0, 0));//coll
	spawncrate((87, 880, -246) , (90, 0, 0));//coll
	spawncrate((76, 918, -244) , (90, 0, 0));//coll
    spawnmodel((1287, 1519, -255) , (0, -90, 0) , "com_restaurantsteelshelf_rusty_01");
	spawnmodel((1359, 1542, -268) , (0, -63, 0) , "ch_furniture_teachers_desk_dusty_1");
	for(i = 0;i < 3;i++)
	spawncrate((1293, 1515, -197)+ (50* i, 0, 0) , (90, 0, 0));
	spawnmodel((922, 432, -384) , (-6, 56, 0) , "com_barrel_blue_rust");
	spawnmodel((969, 432, -383) , (0, 0, 0) , "com_barrel_blue_rust");
	for(i = 0;i < 2;i++)
	spawncrate((918, 437, -320)+ (60* i, 0, 0) , (90, 0, 0));
	spawncrate((957, 437, -225) , (0, 0, 0));
	spawncrate((889, 455, -238) , (-90, -86, 0));

	spawnmodel((344, 2101, -263) , (0, 0, 0) , "berlin_hesco_barrier_med");
	spawnmodel((342, 2044, -263) , (0, 9, 0) , "berlin_hesco_barrier_med");
	for(i = 0;i < 3;i++)
	spawncrate((335, 2033, -197)+ (0, 40* i, 0) , (90, 90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((335, 2100, -143)+ (0, -52* i, 0) , (0, 90, 0));
	spawnmodel((1374, 242, -384) , (0, 2, 0) , "berlin_hesco_barrier_med");
	spawnmodel((1321, 227, -386) , (0, 1, 0) , "berlin_hesco_barrier_med");
	spawnmodel((1253, 224, -357) , (70, 0, 7) , "com_pallet_stack");
	for(i = 0;i < 3;i++)
	spawncrate((1359, 248, -324)+ (-60* i, 0, 0) , (90, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((1359, 248, -224)+ (-60* i, 0, 0) , (90, 0, 0));
	spawnmodel((1041, 362, -363) , (-55, 79, 0) , "com_wooden_pallet");
	for(i = 0;i < 2;i++)
	spawncrate((1063, 353, -331)+ (0, 0, 100* i) , (90, -13, 0));
	
	//bunker wall/door
	spawnmodel((-619, 1624, -265) , (90, 7, -1) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-631, 1709, -265) , (90, 7, -1) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-630, 1709, -226) , (90, 7, -1) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-619, 1624, -226) , (90, 7, 0) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-619, 1624, -187) , (90, 7, 0) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-630, 1709, -187) , (90, 7, 0) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-624, 1670, -150) , (90, 7, 0) , "ch_furniture_teachers_desk_dusty_1"); 
	spawnmodel((-593, 1720, -263) , (-90, 20, -12) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-581, 1634, -263) , (-90, 20, -12) , "ch_furniture_teachers_desk_dusty_1");
	spawnmodel((-583, 1670, -286) , (0, -83, 0) , "me_cargocontainersingleface_white");
	spawnmodel((-627, 1666, -206) , (0, 98, 0) , "fence_tarp_134x76");
	
	for(i = 0;i < 2;i++)
	spawncrate((-595, 1648, -230)+ (-6* i, 57* i, 0) , (90, 96, 0));
	spawncrate((-618, 1705, -276) , (0, 95, 0));
	spawncrate((-610, 1621, -276) , (0, 96, 0));
	
	//replaced hummers
	spawnmodel((-541, 671, -330) , (0, 0, 0) , "foliage_pacific_bushtree01_animated");
	spawnmodel((-545, 757, -341) , (0, 0, 0) , "foliage_pacific_bushtree01_animated");
	spawnmodel((-540, 800, -338) , (0, 0, 0) , "foliage_pacific_bushtree01_animated");
	spawnmodel((-365, 759, -282) , (0, 9, 0) , "com_pallet_stack");
	spawnmodel((-348, 867, -282) , (0, -109, 0) , "vehicle_forklift");
	spawnmodel((1190.2, 982.3, -321.4) , (357.936, 358.597, 2.32599) , "vehicle_hummer_destroyed");
	spawnmodel((479.2, 887.3, -318.4) , (0.372607, 344.221, -2.07905) , "vehicle_hummer_destroyed");
	spawnmodel((63.7, 1567.3, -292) , (0.534933, 355.449, 0.588343) , "vehicle_hummer_destroyed");
	spawnmodel((-23.8, 1856.3, -292) , (0, 286.8, 0) , "vehicle_hummer_destroyed");
	
	//tarp
	spawnmodel((-459, 1879, -231) , (0, 0, 0) , "foliage_pacific_bushtree01_animated");
	spawnmodel((-544, 1856, -173) , (0, -90, 0) , "fence_tarp_167x56");
	spawnmodel((-544, 1941, -221) , (0, 8, 0) , "me_chainlink_fence_pole");
	
	for(i = 0;i < 3;i++)
	spawncrate((-524, 1831, -154)+ (0, 60* i, 0) , (90, -90, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-524, 1831, -54)+ (0, 60* i, 0) , (90, -90, 0));
	
	//ladder block
	
	spawnmodel((494, 149, -200) , (0, 25, 0) , "com_steel_rails_med");
	spawnmodel((442, 173, -195) , (0, 0, 0) , "com_pallet_stack");
	spawncrate((438, 186, -150) , (0, 0, 0));
	spawncrate((438, 186, -100) , (0, 0, 0));
	
	spawnmodel((-392, -82, -405) , (-2, 16, 0) , "berlin_hesco_barrier_med");
	spawnmodel((-391, -80, -351) , (0, 20, 0) , "com_pallet_stack");
	
	spawncrate((-383, -80, -366) , (0, 113, 0));
	spawncrate((-395, -87, -366) , (-4, 113, 0));
	spawncrate((-383, -80, -331) , (0, 113, 0));
	spawncrate((-395, -87, -331) , (0, 113, 0));
	
	//custom ladder
	spawnmodel((257, -124, -195) , (-10, -155, 0) , "com_steel_ladder2");
	spawnmodel((246, -81, -215) , (0, -47, -90) , "ch_corkboard_metaltrim_4x8");
	CreateInvisQuicksteps((256.25, -123.5, -228), 170, 15, 2, (0,-155,0));
	spawncrate((242, -79, -228) , (0, -47, 0));
	spawnmodel((329, 250, -165) , (0, 46, 0) , "com_steel_ladder_top");//ladder2
	spawnmodel((323, 264, -158) , (-180, -44, 0) , "com_steel_rails_short");//ladder2
	CreateTP((336, 258.26, -450), (311.766, 230.353, -200), (0,160,0),1,1,330);
	spawnmodel((-249, -25, -165) , (0, 5, 0) , "com_steel_ladder_top");//ladder3
	spawnmodel((-244, -11, -158) , (-180, -85, 0) , "com_steel_rails_short");//ladder3
	CreateTP((-235.262, -25.19, -490), (-272.271, -27.9565, -190), (0,160,0),1,1,330); 	
	
	//bridge
	spawnmodel((77, -87, -166) , (93, 0, 0) , "com_steel_ladder2");
	spawncrate((-75, -87, -179) , (0, 0, 0));
		for(i = 0;i < 3;i++)
	spawncrate((-14, -87, -183)+(56* i,-1* i,-3* i) , (3, 0, 0));
	
	//dome cover
	spawnmodel((391, 275, -102) , (0, -47, -50) , "com_pallet");
	spawnmodel((355, 309, -102) , (0, -42, -50) , "com_pallet");
	spawnmodel((314, 340, -103) , (0, -34, -50) , "com_pallet");
	spawnmodel((270, 365, -103) , (0, -25, -50) , "com_pallet");
	spawnmodel((220, 383, -104) , (0, -12, -50) , "com_pallet");
	spawnmodel((204, 386, -104) , (0, -18, -50) , "com_pallet");
	spawnmodel((166, 388, -103) , (0, -1, -50) , "com_pallet");
	spawnmodel((115, 386, -103) , (0, 4, -50) , "com_pallet");
	spawnmodel((61, 379, -105) , (0, 9, -48) , "com_pallet");
	spawnmodel((10, 367, -105) , (0, 17, -48) , "com_pallet");
	spawnmodel((-38, 352, -105) , (0, 20, -48) , "com_pallet");
	spawnmodel((-85, 331, -106) , (0, 29, -48) , "com_pallet");
	spawnmodel((-128, 305, -106) , (0, 33, -48) , "com_pallet");
	spawnmodel((-169, 276, -107) , (0, 39, -48) , "com_pallet");
	
	//roof
	spawnmodel((347, 251, -79) , (0, -135, 0) , "com_pallet");
	spawnmodel((305, 292, -76) , (0, -132, 0) , "com_pallet");
	spawnmodel((257, 325, -79) , (0, -117, 0) , "com_pallet");
	spawnmodel((203, 341, -78) , (0, -95, 0) , "com_pallet");
	spawnmodel((143, 342, -81) , (0, -87, 0) , "com_pallet");
	spawnmodel((83, 336, -79) , (0, -82, 0) , "com_pallet");
	spawnmodel((31, 328, -84) , (0, -75, 0) , "com_pallet");
	spawnmodel((-30, 310, -82) , (0, -69, 0) , "com_pallet");
	spawnmodel((-88, 285, -81) , (0, -65, 0) , "com_pallet");
	spawnmodel((-138, 250, -82) , (0, -54, 0) , "com_pallet");
	spawnmodel((-144, 327, -172) , (180, 32, 7) , "ch_corkboard_metaltrim_4x8"); //maybe remove
	
	//death boundary
	spawnmodel((-1359, 1691, -115) , (0, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1357, 1857, -119) , (0, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1805, 1857, -38) , (0, -54, 0) , "me_chainlink_fence_pole"); 
	spawnmodel((-2066, 1857, 0) , (11, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-2066, 1617, -10) , (11, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-2075, 1290, -64) , (11, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-2066, 905, -121) , (11, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-2066, 506, -176) , (11, -54, 0) , "me_chainlink_fence_pole");
	spawnmodel((-2066, 187, -404) , (11, -54, 0) , "me_chainlink_fence_pole");
    spawnmodel((-1713, 192, -390) , (26, -96, 0) , "me_chainlink_fence_pole");
	spawnmodel((-1360, 187, -387) , (3, -96, 0) , "me_chainlink_fence_pole");
	
	spawnmodel((-1716, 167, -335) , (0, -183, -26) , "usa_sign_donotenter");
	spawnmodel((-1356, 185, -326) , (15, -176, -3) , "usa_sign_donotenter");
	spawnmodel((-2063, 1281, -4) , (-9, 84, 0) , "usa_sign_donotenter");
	spawnmodel((-2055, 496, -116) , (-12, 90, 0) , "usa_sign_donotenter");
	spawnmodel((-1804, 1856, 11) , (-4, 5, 0) , "usa_sign_donotenter");
	
	spawnmodel((-1805, 1857, 54) , (78, 99, 0) , "weapon_light_stick_tactical_bombsquad");
    spawnmodel((-2064, 1275, 31) , (78, 128, 0) , "weapon_light_stick_tactical_bombsquad");
	spawnmodel((-1361, 184, -290) , (78, 275, 0) , "weapon_light_stick_tactical_bombsquad");	
	spawnmodel((-1717, 150, -302) , (109, 270, 0) , "weapon_light_stick_tactical_bombsquad");
	spawnmodel((-2054, 490, -80) , (68, 148, -35) , "weapon_light_stick_tactical_bombsquad");
	spawnmodel((-1796, 1894, -36) , (9, 0, 0) , "mil_razorwire_long_static");
	for(i = 0;i < 4;i++)
	spawncrate((-1345, 1704, -56)+ (0, 60* i, 0) , (90, 90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-1345, 1704, 51)+ (0, 60* i, 0) , (90, 90, 0));
	spawnmodel((-1359, 1774, -60) , (0, 90, 0) , "fence_tarp_167x56");
	CreateDeathRegion((-763.8, 1907, -160), (-2471, 2244, 551));
	CreateDeathRegion((-2104.8, 2334.77, -430), (-2476, -124, 551));
	CreateDeathRegion((-2386.7, 122, -430), (-1060, -300, 551));
	}


underground_edit1(){
	level.meat_playable_bounds = [
		(-2613.03, 876.747, 53.8561),
		(-2727.27, 1162.78, -119.875),
		(-2730.09, 3146.31, 87.125),
		(-2041.81, 3834.28, 87.125),
		(-1658.74, 3454.24, 87.125),
		(-1240.65, 3379.27, 60.125),
		(-507.828, 2692.84, 390.821),
		(-506.868, 2102.71, 421.434),
		(-1820.74, 1277.59, -71.85),
		(-1823.18, 882.512, -76.0389)
	];
	createPolygon();
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "com_locker_double" || ent.model == "com_security_camera_tilt_animated" || ent.model == "com_locker_open" || ent.model == "com_trashcan_metal_closed" || ent.model == "me_electricbox4" || ent.model == "me_electricbox2" || ent.model == "com_filecabinetblackclosed" || ent.model == "vehicle_moving_truck_destructible" || ent.model == "com_ex_airconditioner") {
	// iprintln(ent.model);
	// logprint(ent.model + "\n");
	ent delete();
		}
	}
	moveac130position((-2028, 2410, 2070));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2594, 1498, -165);
	mp_global_intermission.angles = (-25, 36, 0);
	
	//trucks
	spawnmodel((778, -803, 1), (0, 4.5999, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-1314, 2861, -256), (0, 126.9, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-2098, 1088, -216), (0, 272.3, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-1334, 2120, -256), (0, 273.5, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-1591, 1551, -256.5), (0, 27.8, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-2337, 1806, -216), (0, 273.4, 0), "vehicle_moving_truck_destructible"); 
	spawnmodel((-2498, 1803, -216), (0, 269.7, 0), "vehicle_moving_truck_destructible"); 
	
	// 1st roof edge walls
	CreateWalls((-2740, 2204, 140),(-2740, 2640, 140));
	CreateDoors((-2645, 2640, 240) /*open*/, (-2645, 2640, 150) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 1 /*height*/, 35 /*hp*/, 75 /*range*/, false /*sideways*/);
	CreateWalls((-2550, 2640, 140),(-2120, 2640, 140));
	CreateWalls((-2740, 2680, 60),(-2740, 3150, 60));
	CreateWalls((-2740, 3150, 60),(-2040, 3850, 60));
	CreateWalls((-2040, 3850, 60),(-1640, 3450, 60));
	Createramps((-1450, 3180, 70),(-1690, 3420, 35));
	spawncrate((-1727, 3455, 27), (0, 45, -15), "com_plasticcase_friendly");
	CreateGrids((-2709, 2690, 37),(-2431, 2690, 37), (0,0,0));
	CreateWalls((-1880, 2450, 220),(-1880, 2050, 220),(0,90,0));
	CreateWalls((-2086, 3043, 55),(-2012, 3117, 135));
	CreateGrids((-661, 2526, 340),(-553, 2642, 340), (0,0,0));
	CreateinvisWalls((-852, 2689, 370),(-616, 2691, 370));
	CreateinvisWalls((-852, 2689, 430),(-616, 2691, 430));
	
	//truck ramps + cover
	
	
	spawnmodel((-2180.77, 1581, -216), (0, 320, 0), "pb_pallet_buckets");
	spawncrate((-2181, 1580, -199), (0, 320, 90));	
	spawncrate((-2181, 1580, -156), (0, 320, 90));		
	
	spawnmodel((-2325.77, 1632, -184), (40, 270, 90), "ch_corkboard_woodtrim_4x8");		
	spawnmodel((-2498, 1630, -184), (40, 270, 90), "ch_corkboard_woodtrim_4x8"); 
	
	CreateInvisRamps((-2499, 1670, -170),(-2499, 1611, -219));
	spawncrate((-2499, 1699, -156), (0, 0, 0));
	
	CreateInvisRamps((-2325, 1670, -170),(-2325, 1611, -219));
	spawncrate((-2325, 1699, -156), (0, 0, 0));
	
	// garage block
	CreateInvisWalls((-2286, 1216, -184),(-2286, 895, -184));
	
	spawnmodel((-2293, 1060, -206), (90, 90, 90), "ug_parking_garage_beam");	
	spawnmodel((-2293, 1060, -161), (90, 90, 90), "ug_parking_garage_beam");
	spawnmodel((-2293, 1060, -116), (90, 90, 90), "ug_parking_garage_beam");
	spawnmodel((-2293, 1060, -71), (90, 90, 90), "ug_parking_garage_beam");
	
	spawnmodel((-2443, 874, -206), (90, 0, 90), "ug_parking_garage_beam");	
	spawnmodel((-2443, 874, -161), (90, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-2443, 874, -116), (90, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-2443, 874, -71), (90, 0, 90), "ug_parking_garage_beam");
	
	spawnmodel((-2333, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2378, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2423, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2468, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2513, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2558, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	spawnmodel((-2603, 1060, -51), (0, 0, 0), "ug_parking_garage_beam");
	// Garage/alley blocker
	CreateWalls((-2415, 2690, -200),(-2415, 2690, -200),(0,90,90));
	CreateWalls((-2415, 2690, -140),(-2415, 2690, -140),(0,90,90));
	// roof to roof ramp
	CreateWalls((-1290, 2460, 210),(-1360, 2530, 210));
	CreateWalls((-1290, 2460, 270),(-1360, 2530, 270));
	CreateDoors((-1219, 2449, 380) /*open*/, (-1219, 2449, 250) /*close*/, (90,90,0) /*angle*/, 2 /*size*/, 2 /*height*/, 35 /*hp*/, 75 /*range*/, false /*sideways*/);
	CreateRamps((-1185, 2521, 191),(-1185, 2830, 57));
	// Roof door walls
	CreateWalls((-1920, 2505, 210),(-1920, 1980, 290));

	// quicksteps
	CreateQuicksteps((-2420, 2190, 95), 120, 16, 2, (0,-90,0));

	// Hide spot roof 1
	CreateWalls((-2292, 2610, 100),(-2292, 2480, 180));
	//CreateWalls((-2060, 1205, -98),(-1920, 1205, -98));

	//createHiddenTP((-578, 2170, 351.824), (32, 2022, -127.885), undefined, "out");
	//createHiddenTP((-1464, 3390, -170.824), (32, 2022, -127.885), undefined, "out");
	createTP((-280, 407, -127), (-1992, 1044, -215), (0, 89, 0), undefined);
	createTP((-1274, 1185, -255), (-2393, 951, -215), (-1, 123, 0), undefined);
	createTP((25, 2989, -127), (-2393, 951, -215), (-1, 123, 0), undefined);
	createTP((1406, 464, -55), (-1992, 1044, -215), (0, 89, 0), undefined);
	createTP((714, 1819, -255), (-1992, 1044, -215), (0, 89, 0), undefined);
	createTP((-92, -1087, 8), (-2393, 951, -215), (-1, 123, 0), undefined);
	createTP((152, -1077, 8), (-1992, 1044, -215), (0, 89, 0), undefined);
	
	//tmg new shit
	
	//new spawn protection
	CreateGrids((-2045, 1150, -84),(-1915, 1260, -84), (0,0,0));
	
	//invisible cps?
	spawnmodel((-2046, 1263, -100) , (0, 0, 0) , "com_plasticcase_beige_big");
	spawnmodel((-2046, 1233, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-2046, 1203, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-2046, 1173, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-2046, 1143, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1990, 1263, -100) , (0, 0, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1990, 1233, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1990, 1203, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1990, 1173, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1990, 1143, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1934, 1263, -100) , (0, 0, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1934, 1233, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1934, 1203, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1934, 1173, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	spawnmodel((-1934, 1143, -100) , (0, 180, 0) , "com_plasticcase_beige_big");
	
	//parking lot struts
	spawnmodel((-2263, 2911, 110) , (0, 225, 90) , "ug_parking_garage_beam");
	spawnmodel((-2273, 2899, 110) , (0, 45, 90) , "ug_parking_garage_beam");
	spawnmodel((-2007, 3163, 110) , (0, 225, 90) , "ug_parking_garage_beam");
	spawnmodel((-2017, 3151, 110) , (0, 45, 90) , "ug_parking_garage_beam");
	spawnmodel((-1760, 3415, 110) , (0, 225, 90) , "ug_parking_garage_beam");
	spawnmodel((-1770, 3403, 110) , (0, 45, 90) , "ug_parking_garage_beam");
	
	//crate
	spawnmodel((-1964, 1242.8, -152) , (0, 90, 0) , "ug_crate_pallet");
	spawncrate((-1960, 1235, -102), (0, 0, 0));
	spawncrate((-1960, 1257, -102), (0, 0, 0));
}
underground_edit2(){
	level.meat_playable_bounds = [
		(2241.2, 3316.37, 112.13),
		(1806, 3316.37, 152.135),
		(1806, 1705.24, 152.131),
		(1520.58, 1708.91, 291.279),
		(989.553, 1165.19, 214.604),
		(542, 1167.41, 330.686),
		(584.422, -1183.16, 257.149),
		(1369.422, -1270.16, 257.149),
		(1878.422, -1270.16, 257.149),
		(2539.71, -1066.53, 93.3717),
		(2544.14, -445.376, 164.656),
		(2283.72, 957.882, 112.355),
		(2274.24, 2058.55, 112.126)
	];
	createPolygon();
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "com_security_camera_tilt_animated" || ent.model == "me_electricbox4" || ent.model == "com_locker_open" || ent.model == "me_electricbox2" || ent.model == "machinery_oxygen_tank01" || 
		ent.model == "machinery_oxygen_tank02" || ent.model == "com_tv1" || ent.model == "com_ex_airconditioner" || ent.model == "com_locker_double") {
	ent delete();
	}
	}
	moveac130position((2184, 1050, 1550));
	CreateDeathRegion((1827, 2378, 123), (1577, 2655, 300));
	CreateDeathRegion((1385, -1285, 90), (1506, -1194.6, 200)); //
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1458, 224, 365);
	mp_global_intermission.angles = (33, 45, 0);
	
	//crate
	spawnmodel((1831, 2715, -18), (0, 90, 0), "ug_crate_pallet");
	spawncrate((1834, 2703, 28), (0, 0, 0));
	spawncrate((1834, 2731, 28), (0, 0, 0));
	spawncrate((1834, 2703, 76), (0, 0, 0));
	spawncrate((1834, 2731, 76), (0, 0, 0));
	spawnmodel((1931, 3084.9, -12), (0, 35, 10), "ny_barrier_pedestrian_01");
	spawnmodel((2108, 2912, -13) , (346, 30, 0) , "com_scaffold_red");
	spawnmodel((2036, 2999, 16) , (66, 30, 0) , "com_pallet_2");
	spawnmodel((2135, 3247, -12) , (0, 350, 0) , "ny_barrier_pedestrian_01");
	spawnmodel((1976, 3320, -12) , (0, 344, 0) , "ny_barrier_pedestrian_01");
	spawnmodel((1860, 3345, -12) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((1455, 771, 164) , (0, 30, 0) , "prop_flag_unionjack");
	spawnmodel((1455, 771, 174) , (0, 30, 0) , "me_chainlink_fence_pole");
	
	//gate
	
	spawnmodel((1887, 197, 0) , (0, 180, 0) , "payback_sstorm_fence_chainlink");
	spawnmodel((2195, 197, 0) , (0, 0, 0) , "payback_sstorm_fence_chainlink");
	spawnmodel((2279, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((2209, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((2139, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((2069, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((1999, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((1929, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((1859, 201, 100) , (6, 90, 0) , "ch_bunker_wires_01");
	spawnmodel((2132, 198, 93) , (0, 0, 0) , "berlin_hotel_lights_wall2_on");
	spawnmodel((1950, 198, 93) , (0, 0, 0) , "berlin_hotel_lights_wall2_on");
		
	//roof wall
	
	spawnmodel((1617, 1706.5, 214) , (90, 0, 90) , "ug_parking_garage_beam");
	spawnmodel((1617, 1693, 214) , (90, 180, 90) , "ug_parking_garage_beam");
	spawnmodel((1617, 1706.5, 170) , (90, 0, 90) , "ug_parking_garage_beam");
	spawnmodel((1617, 1693, 170) , (90, 180, 90) , "ug_parking_garage_beam");
	spawnmodel((1620, 1706.5, 226) , (180, 90, 0) , "ug_parking_garage_beam");
	spawnmodel((1620, 1690, 228) , (0, 90, 0) , "ug_parking_garage_beam");
	spawnmodel((1793, 1690, 53) , (180, 270, 90) , "ug_parking_garage_beam");
	spawnmodel((1793, 1690, 53) , (0, 90, 90) , "ug_parking_garage_beam");
	CreateWalls((1780, 1700, 150),(1536, 1700, 150));
	CreateWalls((1780, 1700, 203),(1536, 1700, 203));
	
	//bus
	
	CreateInvisWalls((1933, 2965, 22),(1993, 2864, 22));
	CreateInvisWalls((2040, 2785, 22),(2087, 2700, 22));
	//door steps
	spawncrate((1916, 3012, -15),(0,120,0));
	spawncrate((2021, 2827, -15),(0,120,0));
	
	CreateInvisWalls((1997, 3064, 10),(2181, 2745, 10));
	CreateInvisWalls((1997, 3064, 60),(2181, 2745, 60));
	CreateInvisWalls((1997, 3064, 125),(2181, 2745, 125));
	
	CreateInvisWalls((1939, 3029, 125),(2009, 2908, 125));
	
	//front
	CreateInvisWalls((1970, 3099, 30),(1894, 3055, 50));
	CreateInvisWalls((1970, 3099, 10),(1894, 3055, 10));
	
	//back
	CreateInvisWalls((2129, 2714, 20),(2099, 2697, 20));
	
	
	spawncrate((1946, 3087, 138),(0,30,90));
	spawncrate((2036, 2921, 138),(0,210,90));
	
	spawncrate((1975, 3037, 192),(0,120,180));
	spawncrate((2018, 2966, 192),(0,120,180));
	
	//step
	spawncrate((2020, 2963, 5),(0,120,0));
	
	
	CreateInvisRamps((1940, 3054, -5),(2131, 2723, -5));
	
	CreateInvisRamps((1914, 3040, 108),(2105, 2709, 108));
	CreateInvisRamps((2021, 2903, 108),(2128, 2723, 108));
	
	CreateInvisRamps((2000, 3019, 62),(2014, 2996, 35));
	spawncrate((1966, 3052, 80),(0,120,0));
	spawncrate((1966, 3052, 25),(0,120,90));
	
	spawnmodel((2027, 2880, -13) , (0, 30, 0) , "ug_vehicle_london_bus_closed");
	spawnmodel((1945, 3021, 96) , (0, 340, 0) , "utility_sign_wet_floor");
	
	//police van
	
	spawnmodel((2159, 1576, 0) , (0, 100, 0) , "vehicle_uk_police_van");
	
	CreateInvisWalls((2172, 1669, 20),(2205, 1501, 20));
	CreateInvisWalls((2116, 1658, 20),(2149, 1490, 20));
	CreateInvisWalls((2131, 1570, 77),(2149, 1490, 77));
	CreateInvisWalls((2186, 1582, 77),(2204, 1502, 77));
	
	spawncrate((2123, 1613, 60),(45,100,0));
	spawncrate((2174, 1624, 60),(45,100,0));
	
	spawncrate((2263, 1879, 150),(0,0,90));
	
	createTP((-280, 407, -127), (2101, 3129, -12), (0,-126,0));
	createTP((-1274, 1185, -255),(2101, 3129, -12), (0,-126,0));
	createTP((25, 2989, -127), (2101, 3129, -12), (0,-126,0));
	createTP((1406, 464, -55), (2101, 3129, -12), (0,-126,0));
	createTP((714, 1819, -255), (2101, 3129, -12), (0,-126,0));
	createTP((-92, -1087, 8), (2101, 3129, -12), (0,-126,0));
	createTP((152, -1077, 8), (2101, 3129, -12), (0,-126,0));
	//createHiddenTP((565.125,1135.89,174.125), (-737.578,3282.3,-127.875), undefined, "out");
	
	// Door walls
	CreateInvisWalls((1839, 190, 8),(1934, 190, 92)); // Right wall
	CreateInvisWalls((2256, 190, 8),(2143, 190, 92)); // Left wall
	CreateDoors((2040, 190, 100) /*open*/, (2040, 190, 21) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	
	// Back of map Bin area blocker
	CreateInvisWalls((2514, -1038, 40),(2329, -1038, 40));
	CreateInvisWalls((2514, -1038, 100),(2329, -1038, 100));
	
	// Back of map street blocker
	CreateInvisWalls((1810, -1270, 36),(1542, -1270, 36));
	spawnmodel((1684, -1305, 0) , (0, 20, 0) , "ny_barrier_pedestrian_01");
	spawnmodel((1584, -1351, 0) , (0, 350, 0) , "ny_barrier_pedestrian_01");
	spawnmodel((1773, -1273, 8) , (0, 0, 0) , "com_trafficcone02");
	spawnmodel((1812, -1272, 8) , (0, 0, 0) , "com_trafficcone02");

	//elevator
	CreateElevator((1220, 160, 0),(1300, 30, 0), 132, 3);
}
underground_edit3(){
 ents = GetEntArray();
    foreach(ent in ents) {
	if(ent.model == "uk_police_estate_destructible" || ent.model == "com_security_camera_tilt_animated" || ent.model == "vehicle_london_cab_black_destructible" || ent.model == "me_electricbox4" || ent.model == "com_locker_open" || ent.model == "me_electricbox2" || ent.model == "machinery_oxygen_tank01" || ent.model == "machinery_oxygen_tank02" || ent.model == "com_tv1" || ent.model == "com_ex_airconditioner" || ent.model == "com_tv1" || ent.model == "com_locker_double") {
	ent delete();
	}
	}
	
	//tp spawn fix
	disable_spawn_array = [];
	disable_spawn_array[disable_spawn_array.size] = (-639.1, 3361.8, -108);
	disable_spawn_array[disable_spawn_array.size] = (724.1, 3095.4, -127);
	disable_spawn_point(disable_spawn_array);
	
	level.meat_playable_bounds = [
		(-760, 3427, 50),
		(-880, 2991.24, 50),
		(-4706, -1471.58, 50),
		(1787, -1285.94, 50), 
		(1787, 6855, 50),
		(-3287.48, 6720.22, 50),
		(-859.48, 4292.22, 50),
		(-1389.48, 3762.22, 50)
	];
	createPolygon();

	moveac130position((-102, 3283, 1500));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (627,2953,112);
	mp_global_intermission.angles = (23, 130, 5);
	 
	spawnmodel((-112, 3634, -101) , (0, 180, 0) , "com_wall_streetlamp");//ledge block			
	spawncrate((-96, 3631, -90),(0,0,90));//ledge block
	
	//maybe
	//spawnmodel((-268, 3295, -4) , (0, -90, 25) , "prague_awning01_burgundy");
	
	//roof cover
	spawnmodel((-511, 5299, -112) , (0, -3, 0) , "ny_rooftop_ac_unit");
    spawncrate((-512, 5270, -80),(0,-3,0));	
	spawncrate((-509, 5325, -80) , (0, -3, 0));
			
	//in map blocks
				
	spawnmodel((339, 2386, -242), (0, 90, 0), "ug_vehicle_subway_cart_02");
	spawnmodel((338, 2126, -295) , (0, 90, 0) , "vehicle_subway_cart_dest_chasis_mp");
	spawnmodel((1124, 1607, -13), (0, 270, 0), "venetian_blind_white_128x96");
	spawnmodel((1253, 1607, -13), (0, 270, 0), "venetian_blind_white_128x96");
				
	spawncrate((1122, 1605, -50),(0,180,90));
	spawncrate((1248, 1605, -50),(0,180,90));		
	spawncrate((985, 1788, -77),(0,90,90));
	spawnmodel((993, 1758, -20), (2, 90, 0), "com_wallchunk_boardcorner02");	
	spawnmodel((993, 1791, -89), (0, 90, 0), "com_wallchunk_boardbase02");
				
	spawncrate((816, 2098, -36),(0,180,90));
	spawnmodel((839, 2115, -104), (0, 180, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((377, 1950, -96), (0, 180, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((-315, 1950, -96), (0, 0, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((-1025, 2730, -256), (0, 135, 0), "payback_sstorm_fence_chainlink");
				
	spawncrate((-992, 2718, -200),(90,225,90)); 
	spawncrate((-1033, 2759, -200),(90,225,90)); 
	
	spawnmodel((1411, 1636, -120), (0, 180, 0), "furniture_desk_office");
	spawnmodel((1400, 1636, -92), (0, 177, 0), "furniture_desk_office");
				
	spawncrate((1399, 1630, -80),(0,180,90)); 
				
	spawnmodel((-422, 2043, -275), (2, 0, 4), "vehicle_subway_cart_dest_chasis_mp");
	spawnmodel((-422, 2043, -215), (90, 0, 0), "concrete_pillarchunk_med_01");
				
	spawncrate((-330, 2026, -260),(0,0,90)); 
	spawncrate((-380, 2026, -260),(0,0,90)); 
	spawncrate((-452, 2026, -260),(0,0,90));	
	spawncrate((-330, 2026, -190),(0,0,90)); 
	spawncrate((-380, 2026, -200),(0,0,90)); 
	spawncrate((-452, 2026, -200),(0,0,90));
				
	spawnmodel((476, 2035, -128), (0, 5, 0), "construction_porter_potty_green_nolodout");
	spawnmodel((486, 2080, -128), (0, 11, 0), "com_trafficcone02");
				
	spawncrate((486, 2061, -90), (0, 90, 90));
	spawncrate((461, 2061, -90), (0, 90, 90));
	spawncrate((486, 2061, -30), (0, 90, 90));
	spawncrate((461, 2061, -30), (0, 90, 90));	
	spawncrate((411, 1947, -40), (90, 0, 90));
	spawncrate((356, 1947, -40), (90, 0, 90));
	spawncrate((-288, 1947, -40), (90, 0, 90));
	spawncrate((-342, 1947, -40), (90, 0, 90));
	spawncrate((-497, 2054, -75), (90, 0, 90));
	spawncrate((-497, 1994, -75), (90, 0, 90));						
	spawnmodel((-513, 2026, -129), (0, 90, 0), "payback_sstorm_fence_chainlink");
				
	//train collision		
	for(i = 0;i < 4;i++)
	spawncrate((395, 2137, -183)+(0, 80* i,0) , (180, 90, 151)); i++;
	CreateInvisRamps((338, 2390, -167),(338, 2147, -167));
	for(i = 0;i < 4;i++)
	spawncrate((288, 2137, -186)+(0, 80* i,0) , (180, 90, 216)); i++;
	
	spawncrate((399, 1987, -265),(90,90,90));
	spawncrate((399, 2047, -265),(90,90,90));
	spawncrate((401, 1950, -180),(0,90,90));	
	spawncrate((263, 1955, -174),(0,0,90));
	spawncrate((190, 1955, -220),(0,0,90));
	spawncrate((190, 1955, -164),(0,0,90));		
	spawncrate((-117, 1955, -220),(0,0,90));
	spawncrate((-117, 1955, -164),(0,0,90));		
	spawnmodel((190, 1952, -257), (0, 180, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((-92, 1952, -257), (0, 0, 0), "payback_sstorm_fence_chainlink");
						
	//ramps
					
	CreateInvisRamps((23, 3196, -144),(560, 3196, -144));
	CreateInvisRamps((537, 3262, -144),(538, 3385, -144));
				 
	spawnmodel((70, 3146, -130), (0, 180, 88), "payback_sstorm_fence_chainlink");
	spawnmodel((200, 3146, -130), (0, 180, 88), "payback_sstorm_fence_chainlink");
	spawnmodel((330, 3146, -130), (0, 180, 86), "payback_sstorm_fence_chainlink");
	spawnmodel((460, 3146, -130), (0, 180, 86), "payback_sstorm_fence_chainlink");
	spawnmodel((590, 3215, -130), (0, 270, 90), "payback_sstorm_fence_chainlink");
	spawnmodel((590, 3350, -130), (0, 270, 88), "payback_sstorm_fence_chainlink");
				
	CreateInvisRamps((-154.7, 4346.65, -160),(180, 4427.8, -170));	
	spawncrate((-172, 4343, -159) , (0, -75, 0));

	i=0;					
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (2, 14, 0), "com_pallet_2"); i++; 
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (2, 14, 0), "com_pallet_2"); i++; 
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (-2, 194, 0), "com_pallet_2"); i++; 
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (2, 14, 0), "com_pallet_2"); i++; 
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (-2, 194, 0), "com_pallet_2"); i++; 
	spawnmodel((-141, 4350, -152) + (62* i,15* i,-2* i), (2, 14, 0), "com_pallet_2"); i++; 
				
	spawnmodel((-154, 5806, -140), (93, 340, 6), "com_powerpole3");
				
	spawncrate((116, 5673, -165), (3, 334, 0));
	spawncrate((61, 5699, -162), (3, 334, 0));
	spawncrate((-4.8, 5733, -159), (3, 334, 0));
	spawncrate((-65.2, 5763, -156), (3, 334, 0));
	spawncrate((-125.6, 5793, -153), (3, 334, 0));
				
	spawnmodel((-496, 4999, -97), (100, 360, 6), "com_powerpole3");
			
	spawncrate((-217, 4968, -158), (9, 354, 0));
	spawncrate((-273, 4974, -149), (9, 354, 0));
	spawncrate((-329, 4980, -140), (9, 354, 0));
	spawncrate((-385, 4986, -131), (9, 354, 0));
	spawncrate((-441, 4992, -122), (9, 354, 0));			
				
	//flags
	createTP((37.7, -704.38, -1), (1469, 1687, -117), (0,155,0), 1);
	createTP((-661, 1683, -260), (1469, 1687, -117), (0,155,0), 1);
	createTP((838.5, 1744.4, -237), (1469, 1687, -117), (0,155,0), 1);
	createTP((-1129.5, 496.7, -62), (1469, 1687, -117), (0,155,0), 1);
	createTP((31.5, 535.7, -133), (1469, 1687, -117), (0,155,0), 1);		
	CreateTP((-18, 7490, -291.875), (111.8, 6502.6, -320), (0,290,0),1,800,200, undefined,1); 
	CreateTP((762, 3236.3, 53), (540, 3163, -122.125), (0,90,0),undefined,240,60, undefined, 1); //early fence skip mb delete
	CreateTP((-474.127, 3334.85, -140), (-498.677, 3310.7, -120), (0,260,0),undefined,10,60, 45, 1);//stuck spot
			
	for(i = 0;i < 5;i++) //train stuck fix
	spawncrate((289, 4809, -201)+ (-5* i, 77* i,0) , (0, 94, 0)); i++;
				
	//stairs
	CreateInvisRamps((-86, 3286, -154),(-86, 3630, -318));
	CreateInvisRamps((-32, 3286, -154),(-32, 3630, -318));
    spawncrate((-20, 3492, -292) , (180, -90, 270));
	for(i = 0;i < 5;i++)
	spawncrate((-20, 3191, -272) + (0, 60* i, 0), (90, 90, 0));
    for(i = 0;i < 3;i++)
	spawncrate((-20, 3191, -189) + (0, 60* i, 0), (90, 90, 0));
				
	//wallbreach
	CreateInvisWalls((-568, 4345, -70),(-716, 4345, -70));
				
	//station ladders
				
	CreateInvisQuicksteps((-685, 4363, -10), 122, 16, 2, (0,90,0));
	CreateInvisQuicksteps((-549, 4421, -127), 140, 16, 2, (0,0,0));
				
	spawnmodel((-577, 4420, -210), (0, 180, 0), "ug_crate_frame");
	spawnmodel((-577, 4420, -305.5), (0, 180, 0), "ug_crate_frame");
	spawnmodel((-686, 4331, -90), (0, 270, 0), "ug_crate_frame");
	spawnmodel((-686, 4331, -185.5), (0, 270, 0), "ug_crate_frame");
	spawnmodel((-540, 4436, -222), (30, 0, 0), "foliage_gardenflowers_white");
	spawnmodel((-540, 4409, -191), (20, 0, 0), "foliage_gardenflowers_red_group");
	spawnmodel((-576, 4479, -180), (90, 180, 0), "ch_corkboard_woodtrim_4x8");
	spawnmodel((-615, 4478, -180), (90, 180, 0), "ch_corkboard_woodtrim_4x8");
	spawnmodel((-663, 4478, -180), (90, 180, 0), "ch_corkboard_woodtrim_4x8");
	spawnmodel((-704, 4479, -180), (90, 180, 0), "ch_corkboard_woodtrim_4x8");
	spawnmodel((-636, 4495, -234), (90, 180, 0), "ug_parking_garage_column_03");
	
	for(i = 0;i < 3;i++)
	spawncrate((-579, 4462, -180) + (-60* i, 0, 0), (90, 0, 0));
	spawncrate((-585, 4476, -242) , (0, 0, 0));
	spawncrate((-649, 4476, -241) , (0, 0, 0));
	spawncrate((-718, 4494, -241) , (0, 0, 0));
			 
	CreateInvisRamps((31, 4149, -270),(31, 4231, -270));
	CreateInvisRamps((31, 4398, -270),(31, 4480, -270));
						
	//station ramp	
	CreateInvisRamps((-495, 4262, -326),(-490, 4330, -286));
	CreateInvisRamps((-465, 4262, -326),(-460, 4330, -286));
	
	//tunnel seal
	spawnmodel((-329, 3639.5, -292), (90, 0, 90), "ug_parking_garage_beam");	
	spawnmodel((-329, 3639.5, -247), (90, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-329, 3639.5, -203), (90, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-329, 3639.5, -158), (90, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-176, 3642, -314), (0, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-529, 3642, -314), (0, 0, 90), "ug_parking_garage_beam");
	spawnmodel((-553, 3818, -314), (0, 270, 90), "ug_parking_garage_beam");

    for(i = 0;i < 7;i++)
	spawncrate((-512, 3632, -269) + (55* i, 0, 0), (90, 0, 0),"com_plasticcase_trap_friendly");
	for(i = 0;i < 7;i++)
	spawncrate((-512, 3632, -180) + (55* i, 0, 0), (90, 0, 0),"com_plasticcase_trap_friendly");

	//fence
				
	spawnmodel((-405, 3824, -321), (0, 180, 0), "payback_sstorm_fence_chainlink");	
	spawncrate((-359, 3839, -267),(90,0,90));
	spawnmodel((-367, 4771, -320) , (0, 176, 0) , "payback_sstorm_fence_chainlink");		
	 
	//tunnel		
	spawnmodel((-39, 7523, -242) , (0, 110, -60) , "ug_vehicle_subway_cart_02");
	spawnmodel((97, 7289, -261) , (15, -78, 60) , "vehicle_subway_cart_dest_chasis_mp");
	spawnmodel((-40, 6787, -227) , (0, -85, 0) , "usa_traffic_signal_2_fsh_red");
	spawnmodel((-40, 6787, -325) , (0, 0, 0) , "me_chainlink_fence_pole");
	spawnmodel((-65, 7707, -719) , (0, 0, 0) , "foliage_tree_oak_1");
	spawncrate((-321, 6726, -217),(0,0,90));
	spawncrate((-321, 6726, -140),(0,0,90));
	spawncrate((-321, 6726, -63),(0,0,90));
	spawncrate((-286, 6752, -277),(0,90,90));
				
	//fort
	for(i = 0;i < 5;i++)
	spawncrate((-957, 5770, 320) + (0, -60* i, 0), (90, 90, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-1017, 5500, 320) + (-60* i, 0, 0), (90, 0, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-1370, 5790, 320) + (0, -60* i, 0), (90, 90, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-957, 5770, 420) + (0, -60* i, 0), (90, 90, 0));
	for(i = 0;i < 6;i++)
	spawncrate((-1017, 5500, 420) + (-60* i, 0, 0), (90, 0, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-1370, 5790, 420) + (0, -60* i, 0), (90, 90, 0));
		
	spawnmodel((-1049, 5485, 288), (36, 90, 0), "rubble_roof_slab_03");
	spawnmodel((-1235, 5485, 288), (36, 91, 10), "rubble_roof_slab_03");
	spawnmodel((-975, 5557, 257), (0, 90, 0), "concrete_barrier_damaged_1");
	spawnmodel((-970, 5650, 257), (0, 90, 0), "concrete_barrier_damaged_1");
	spawnmodel((-965, 5722, 257), (0, 90, 3), "concrete_barrier_damaged_1");
	spawnmodel((-961, 5806, 257), (0, 91, 0), "concrete_barrier_damaged_1");
	spawnmodel((-1143, 5690, 397), (335, 20, 45), "ug_awning_cafe");
	spawnmodel((-973, 5569, 291), (0, 119, 39), "me_chainlink_fence_pole");
	spawnmodel((-980, 5574, 286), (39, 20, 0), "prop_flag_unionjack");
				
	createHiddenTP((-693, 5753, -95),(-1004, 5785.8, 270), (0,220,0), undefined,1,undefined,undefined, 40);
	createHiddenTP((-1327, 5814, 270),(-629, 5747.8, -250), (0,277,0), undefined, 1,undefined,undefined, 40);				
						
	//right side deathzone
				
	CreateInvisWalls((430, 6006, -286),(472, 5167, -286));
	CreateInvisWalls((319, 6543, -286),(427, 6040, -286));
	CreateInvisWalls((295, 6736, -286),(310, 6596, -286));
	
	spawncrate((442, 5138, -280),(0,180,90));
				
	spawnmodel((356, 6351, -257), (0, 290, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((431, 5914, -257), (0, 274, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((467, 5507, -257), (0, 293, 0), "payback_sstorm_fence_chainlink");
	spawnmodel((350, 6360, -240), (0, 290, 0), "ug_sign_track_warning");
	spawnmodel((458, 5522, -240), (0, 293, 0), "ug_sign_track_warning");
	spawnmodel((428, 5926, -235) , (-14, 274, 0) , "ug_sign_track_warning");
				
	CreateDeathRegion((324, 6795, -338), (475, 6464, -50));
	CreateDeathRegion((360.3, 6506.8, -338), (557.3, 6295.6, -50));
	CreateDeathRegion((394.7, 6334, -338), (576, 6191, -50));
	CreateDeathRegion((425, 6314.5, -338), (651.3, 5495, -50));
	CreateDeathRegion((485.33, 5485, -338), (653.3, 5662, -50));
	
	//hole
	
	for(i = 0;i < 9;i++)
	spawncrate((-763, 3860.6, -143)+(0,70* i,0) , (0, 90, 0));
	spawnmodel((-794, 4259, -197) , (90, 0, 90) , "ug_parking_garage_beam");	
    spawnmodel((-794, 4259, -146) , (90, 0, 90) , "ug_parking_garage_beam");
	for(i = 0;i < 3;i++)
	spawnmodel((-736, 4128, -274)+(0,-130* i,0) , (0, -90, 0) , "vehicle_moving_truck_destructible");
	spawnmodel((534, 4241, -268), (33, 270, 0), "com_pallet_2");
	spawnmodel((534, 4187, -303), (33, 270, 0), "com_pallet_2");
	spawnmodel((534, 4301, -256), (0, 270, 0), "com_pallet_2");	
	spawncrate((522, 4288, -262), (0, 0, 0));
	
	for(i = 0;i < 6;i++)
	spawncrate((602, 4288, -264)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 5;i++)			
	spawncrate((522, 4348, -269)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 5;i++)	
	spawncrate((502, 4648, -269)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 4;i++)	
	spawncrate((492, 4948, -269)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 5;i++)
	spawncrate((582, 4648, -264)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 4;i++)
	spawncrate((572, 4948, -264)+(0,60* i,0), (0, 0, 0));
	for(i = 0;i < 11;i++)
	spawncrate((668, 4799, -264)+(-7* i,60* i,0), (0, 0, 0));
	for(i = 0;i < 5;i++)
	spawncrate((520, 5413, -269)+(5* i,-60* i,0), (0, 0, 0));
	for(i = 0;i < 4;i++) //collision fence
	spawncrate((454, 5459, -205)+(60* i,0,0), (90, 0, 0)); //collision fence

	//ramps
	spawncrate((533, 4236, -282), (33, 270, 0));	
	spawncrate((533, 4170, -325), (33, 270, 0));			

	spawnmodel((411, 5293, -330) , (0, 0, 0) , "ug_crate_pallet");
	spawnmodel((382, 5384, -319) , (0, 0, 40) , "vehicle_subway_door_left_d");
	spawncrate((399, 5350, -304) , (40, 90, 0));
	spawncrate((393, 5296, -281) , (0, 90, 0));
    spawncrate((443, 5296, -281) , (0, 90, 0));
	
	//ladder
	spawnmodel((406, 4822, -268) , (0, 185, 0) , "ug_crate_frame");	
	CreateInvisQuicksteps((432, 4825, -189), 70, 16, 2, (0,5,0));
	
	//gate flags
				
	CreateTP((-157.1, 3125.4, -247), (-158, 3163, -122.125), undefined,undefined,6,130, 45);
	CreateTP((546, 3124.88, -447), (540, 3163, -122.125), undefined,undefined,6,330, 75); 
    spawnmodel((543, 3120, -152) , (6, -100, 69) , "concrete_pillarchunk_sml_01");
	spawnmodel((537, 3136, -174) , (0, 0, 0) , "metal_hanging_strips_sml_01");
	
	spawnmodel((-157, 3120, -126) , (0, 0, 180) , "ims_scorpion_body_placement",45);
	spawnmodel((546, 3121, -126) , (0, 0, 180) , "ims_scorpion_body_placement", 30);
	
}
skidrow_edit1(){
	Deathradius((1433, -6213, 230), 4500, 200);
	moveac130position((3438, -3668, 3000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1659, -1795, 25);
	mp_global_intermission.angles = (-18, -48, 0);
	spawncrate((2055, -740, 30),(0,0,90), "com_plasticcase_friendly");
	spawncrate((2055, -740, 80),(0,0,90), "com_plasticcase_friendly");
	spawncrate((2055, -740, 130),(0,0,90), "com_plasticcase_friendly");
	//End edit wall
	startlocation = (1583, -7700, 20);
	i=0; h = 0;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
	spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
	// 1st doors + walls
	CreateWalls((2010, -4050, 0),(2010, -4050, 100), (0,0,90));
	CreateWalls((2065, -4050, 0),(2065, -4050, 100), (0,0,90));
	CreateDoors((1670, -4050, 25) /*open*/, (1885, -4050, 25) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateWalls((1755, -4050, 0),(1755, -4050, 100), (0,0,90));
	CreateWalls((1700, -4050, 0),(1700, -4050, 100), (0,0,90));
	CreateWalls((1645, -4050, 0),(1645, -4050, 100), (0,0,90));
	CreateWalls((1590, -4050, 0),(1590, -4050, 100), (0,0,90));
	// 2nd doors + walls
	CreateWalls((2010, -6000, 0),(2010, -6000, 100), (0,0,90));
	CreateWalls((2065, -6000, 0),(2065, -6000, 100), (0,0,90));
	CreateDoors((1670, -6000, 25) /*open*/, (1885, -6000, 25) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	CreateWalls((1755, -6000, 0),(1755, -6000, 100), (0,0,90));
	CreateWalls((1700, -6000, 0),(1700, -6000, 100), (0,0,90));
	CreateWalls((1645, -6000, 0),(1645, -6000, 100), (0,0,90));
	CreateWalls((1590, -6000, 0),(1590, -6000, 100), (0,0,90));
	createTP((422.541,-4.74144,0.124998), (1855.07,-968.006,0.125001));
	createTP((1082.29,-1368.61,-7.875), (1886.86,-976.47,0.125001));
	createTP((-1413.83,-965.665,-6.58853), (1871.85,-1006.05,0.124999));
	createTP((-270.78,194.355,176.011), (1880.66,-988.33,0.125));
	createTP((-735.229,-2030.04,0.124998), (1881.5,-997.739,0.125136));
	//createHiddenTP((1620, -7630, 0), (255.1,-603.316,0.125001), undefined, "out");
	CreateDeathRegion((3774.3,-4424.13,-1348.78), (2008.13,-11069.9,-102.64));
	createDeathLine((1395.98,-2429.13,208.13), (1512.73,-11307,191.329));
	createDeathLine((1576.12,-8155,8.13167), (3521.12,-8293.78,47.4947));
	
	//models
	
	spawnmodel((1862, -1040, -1) , (0, 90, 0) , "mil_sandbag_desert_short");
	spawnmodel((1803, -1040, -1) , (0, 90, 0) , "mil_sandbag_desert_end_right");
	spawnmodel((1921, -1040, -1) , (0, 90, 0) , "mil_sandbag_desert_end_left");
	spawnmodel((1843, -1038, 29) , (0, 90, 0) , "mil_sandbag_desert_end_right");
	spawnmodel((1884, -1038, 29) , (0, 90, 0) , "mil_sandbag_desert_end_left");
	
	spawncrate((1909,-1039,10), (0,0,0)); 
	spawncrate((1825,-1039,10), (0,0,0)); 
	spawncrate((1868,-1044,40), (0,0,0)); 
	
	//ramp
	
	CreateRamps((1617, -6015, 62),(1617, -6102, 1));
	CreateRamps((1705, -6015, 62),(1705, -6102, 1));
}
skidrow_edit2(){
	moveac130position((-1394, 1099, 3000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2197, 531, 358);
	mp_global_intermission.angles = (-24, -21, 0);
	spawncrate((-2332, 527, 370), (0, 0, 0));
	spawncrate((-2395, 784, 370), (0, 0, 0));
	spawncrate((-2068, 736, 370), (0, 0, 0));
	
	spawncrate((-681, -120, 600), (90, 0, 0), "com_plasticcase_friendly");
	spawncrate((-681, -120, 670), (90, 0, 0), "com_plasticcase_friendly");
	spawncrate((-70, 710, 580), (90, 0, 0), "com_plasticcase_friendly");
	CreateWalls((-470, 515, 465),(-470, 627, 570),(0,90,90));
	CreateWalls((-1760, 680, 340),(-1840, 580, 440));
	CreateWalls((-681, -450, 640),(-681, -800, 640));
	CreateWalls((-1020, -1130, 575),(-1160, -1130, 575));
	CreateWalls((-1020, -1130, 640),(-1160, -1130, 640));
	spawncrate((-1930, -424, 652), (0, 90, 0), "com_plasticcase_friendly");
	CreateGrids((-1420, 180, 553),(-1820, 210, 553), (0,0,0));
	CreateGrids((-1875, 280, 321),(-1985, 250, 321), (0,0,0));
	CreateGrids((-1875, 180, 553),(-1985, 210, 553), (0,0,0));
	CreateGrids((-1055, 185, 553),(-1105, 155, 553), (0,0,0));
	CreateElevator((-1875, 280, 321),(-1985, 250, 321), 232, 1.5,(0,0,0), undefined, (-1875, 280, 553));
	spawncrate((-980, -160, 553), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-980, -440, 553), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-1053, -290, 553), (0, 90, 0), "com_plasticcase_friendly");
	CreateDeathRegion((-3230, 956, 800), (-1560, 1200, 200));
	CreateDeathRegion((-1560, 945, 800),(400, 1200, 200));
	CreateDeathRegion((-2520, 970, 290),(-3170, 250, 175));
	CreateDeathRegion((-300, -1127, 670),(-1250, -1600, 440));
	CreateDeathRegion((-688, -1127, 670),(-300, -100, 440));
	createTP((-719, -408, 136.125), (-203, 574, 466), (0,180,0), 1);
	createTP((691, 315, 8.125), (-203, 574, 466), (0,180,0), 1);
	createTP((576, -616, 0.0939837), (-203, 574, 466), undefined, 1);
	createTP((575, -1741, -7.875), (-203, 574, 466), (0,180,0), 1);
	createTP((-818, -2044, 0.125), (-203, 574, 466), undefined, 1);
	createTP((-2450, -280, 128.125), (-203, 574, 466), undefined, 1);
	createTP((-1195, 706, -7.875), (-203, 574, 466), (0,180,0), 1);
	//createDeathLine((1576.12,-8155,8.13167), (3521.12,-8293.78,47.4947));
}
skidrow_edit3(){
	moveac130position((-606, -1876, 3700));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-627, -2143, 93);
	mp_global_intermission.angles = (-29, 133, 0);
	//block wb
	CreateWalls((-241, -1165, 690),(-241, -1760, 690));
	spawncrate((-348, -1288, 640) , (0, -90, 0));
	spawncrate((-523, -1144, 639) , (0, -180, 0));	

	spawncrate((139, -1608, 700), (0, 90, 0));
	spawncrate((139, -1558, 700), (0, 90, 0));
	spawncrate((139, -1249, 700), (0, 90, 0));
	CreateInvisWalls((-673, -1284, 140),(-511, -1284, 185));
	CreateWalls((-903, -1426, -11),(-984, -1424, 111));
	CreateWalls((-1507, -1921, 0),(-1507, -1823, 95));
	CreateWalls((967, -1779, 55),(1097, -1779, 55));
	CreateWalls((967, -1779, 115),(1097, -1779, 115));
	CreateWalls((-673, -1120, 630),(-271, -1120, 630));
	CreateWalls((-673, -1120, 690),(-271, -1120, 690));
	//CreateInvisWalls((-240, -1120, 690),(220, -1120, 690));
	CreateInvisWalls((-230, -1797, 690),(220, -1797, 690));
	//CreateInvisWalls((220, -1761, 690),(220, -1155, 690));
	CreateWalls((-190, -2346, 740),(-376, -2346, 740));
	CreateWalls((-190, -2346, 705),(-1169, -2346, 705));
	CreateWalls((-190, -2346, 670),(-1169, -2346, 670));
	CreateWalls((-190, -2346, 635),(-1169, -2346, 635));
	CreateWalls((-190, -2346, 600),(-1169, -2346, 600));
	CreateWalls((-190, -2346, 540),(-448, -2346, 540));
	CreateWalls((-255, -2346, 480),(-448, -2346, 480));
	CreateWalls((491, -1779, 60),(199, -1779, 60));
	CreateWalls((491, -1779, 10),(199, -1779, 10));
	CreateInvisWalls((-170, -2290, 570),(-170, -1810, 570));
	CreateInvisWalls((-170, -2290, 630),(-170, -1810, 630));
	CreateInvisWalls((-170, -2290, 690),(-170, -1810, 690));

	spawncrate((-1010, -1681, 20), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((-1010, -1681, 90), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((-1107, -1887, 40), (90, 90, 0));
	spawncrate((-1053, -951, 590), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-1053, -951, 640), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((-1627, -1554, 680), (0, 90, 0), "com_plasticcase_friendly");
	CreateGrids((-468, -1559, 433),(-468, -1767, 433), (0,0,0));
	CreateGrids((-992, -1782, 267),(-886, -1695, 267), (0,0,0));
	spawnmodel((-833, -3030, -1050) , (0, 0, 0) , "city_facade_tier_with_roof");

	CreateQuicksteps((-686, -1727, 270), 150, 16, 2, (0,0,0));
	CreateQuicksteps((-1092, -1732, 483), 220, 16, 2, (0,0,0));
	CreateQuicksteps((-295, -1770, 590), 170, 16, 2, (0,270,0));

	CreateDoors((-707, -1497, 470) /*open*/, (-707, -1643, 470) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, 1 /*sideways*/);

	 spawnmodel((-650, -1284, 134) , (0, 0, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-590, -1284, 134) , (0, 0, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-533, -1284, 134) , (0, 1, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-642, -1284, 162) , (0, 0, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-583, -1284, 162) , (0, 0, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-527, -1284, 162) , (0, 0, 0) , "com_plasticcase_green_big_us_dirt");
	spawnmodel((-1113, -1889, 10) , (0, 0, 0) , "mil_sandbag_desert_short");
	createTurret((-1113, -1888, 40), (0,0,0), 33, 33, 3, undefined);
	createTP((-1417,-1982.68,-10), (-597, -1462, 150), (0,270,0));
	createTP((-1417,-1982.68, 585), (-1280, -1616, 0), (0,304,0));
	CreateDeathRegion((-178, -1791, 566), (40, -2317, 287));
	CreateDeathRegion((697, -1960, 440), (-435, -2983, 209));
	CreateDeathRegion((-661, -2374, 600), (864, -2983, 209));
	CreateDeathRegion((-997, -1143, 710), (561, -701, 580));
	fufalldamage((-1024, -1552, 1),900, 680);

	createTP((-1770,-1458.5, -14), (1087.6, -1820.8, 40), (0,220,0));
	createTP((-599,-709, 68), (1087.6, -1820.8, 40), (0,220,0),1,undefined,90);
	//CreateTP(enter, exit, angle, slowed, radius, height, delay)
	
	createTP((0, 181.5, 0), (1087.6, -1820.8, 40), (0,220,0));
	createTP((-1434, 243.5, -5), (1087.6, -1820.8, 40), (0,220,0));
	createTP((1271, -833.5, -5), (1087.6, -1820.8, 40), (0,220,0));
}
terminal_edit1(){
	moveac130position((3643, 3158, 616));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (3425, 2940, 203);
	mp_global_intermission.angles = (-17, 44, 0);
	CreateWalls((4000, 2400, 190),(4210, 2400, 300));
	CreateWalls((3980, 2980, 190),(3540, 2540, 300));
	CreateWalls((4015, 3005, 190),(4015, 3205, 230));
	CreateWalls((4015, 3005, 270),(4015, 3205, 300));
	CreateWalls((4100, 3220, 190),(4220, 3220, 300));
	CreateDoors((4500, 3220, 220) /*open*/, (4330, 3220, 220) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	CreateWalls((3860, 3550, 190),(3860, 3410, 300));
	CreateDoors((3570, 3230, 220) /*open*/, (3390, 3230, 220) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, 1 /*sideways*/);
	CreateWalls((3530, 3230, 190),(3715, 3230, 300));
	CreateWalls((3260, 3230, 190),(3300, 3230, 300));
	CreateWalls((3240, 2990, 190),(3240, 3070, 330));
	CreateRamps((3522, 3564, 190),(3829, 3569, 340));
	createTP((1455, 4379, 168.125), (4103, 2137, 193.125), (0,90,0));
	createTP((2787, 2940, 76.125), (4103, 2137, 193.125), (0,90,0));
	createTP((753, 2860, 40.125), (4103, 2137, 193.125), (0,90,0));
	createTP((-266, 5131, 193.125), (4103, 2137, 193.125), (0,90,0));
	createTP((1515, 6341, 192.125), (4103, 2137, 193.125), (0,90,0));
	createTP((3025, 3500, 192),(3045, 3160, 192), (0,270,0));
	createTP((3045, 2888, 192),(3763, 3367, 192), (0,170,0));
	//createHiddenTP((2975, 4081, 192),(357, 4587, 306), (0,270,0) , "out");
	spawncrate((3487.8, 5018, 186), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((3755.7, 4899.8, 186), (0, 90, 0), "com_plasticcase_friendly");
}
terminal_edit2(){
	level.meat_playable_bounds = [
		(-71.125, 3910.24, 520.038),
		(-1388, 3910.86, 289.564),
		(-1388, 3409.3, 258.936),
		(-2037.78, 3413.33, 167.125),
		(-2411.18, 3502.8, 227.125),
		(-2398.77, 3644.73, 133.125),
		(-2728.5, 3634.5, 483.335),
		(-2728.5, 4067.5, 483.335),
		(-2943.12, 4067.5, 483.335),
		(-2920.5, 5457.6, 483.335),
		(-2703.5, 5461.6, 483.335),
		(-2699.5, 5282.6, 483.335),
		(-1123.87, 5284.56, 483.335),
		(-1155, 4507.56, 483.335),
		(-556.7, 4509.49, 483.335),
		(-572.49, 4856.64, 483.335),
		(-19, 4879, 489.63)
	];
	createPolygon();
	moveac130position((-2117, 3649, 1900));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1908, 3539, 45);
	mp_global_intermission.angles = (-23, 45, 0);
	spawncrate((-3065, 4781, 181), (0, 0, 0));
	spawncrate((-2995, 4781, 181), (0, 0, 0));
	spawncrate((-3040, 4712, 165), (0, 270, 0));
	spawncrate((-2990, 4712, 165), (0, 270, 0));
	spawncrate((-2934, 4949, 492), (27, 270, 270), "com_plasticcase_friendly");
	spawncrate((-2934, 4899.5, 466.5), (27, 270, 270), "com_plasticcase_friendly");
	spawncrate((-2934, 4850, 441), (27, 270, 270), "com_plasticcase_friendly");
	spawncrate((-2934, 4800.5, 415.5), (27, 270, 270), "com_plasticcase_friendly");
	spawncrate((-2934, 4751, 390), (27, 270, 270), "com_plasticcase_friendly");
	spawncrate((-2934, 4734, 360), (90, 0, 0), "com_plasticcase_friendly");
	spawncrate((-2934, 4734, 305), (90, 0, 0), "com_plasticcase_friendly");
	spawncrate((-2934, 4734, 250), (90, 0, 0), "com_plasticcase_friendly");
	spawncrate((-2934, 4734, 195), (90, 0, 0), "com_plasticcase_friendly");
	CreateWalls((-2934, 4128, 172),(-2934, 4709, 172));
	CreateWalls((-2934, 4678, 115),(-2934, 5416, 115));
	CreateWalls((-2934, 4678, 55),(-2934, 5416, 55));
	CreateWalls((-2934, 5138, -5),(-2934, 5416, -5));
	CreateWalls((-1359, 4098, 55),(-1879, 4098, 55));
	CreateWalls((-1359, 4098, 115),(-1879, 4098, 115));
	CreateWalls((-1359, 4098, 172),(-1879, 4098, 172));
	CreateWalls((-2019, 4098, 55),(-2260, 4098, 55));
	CreateWalls((-2019, 4098, 115),(-2934, 4098, 115));
	CreateWalls((-2019, 4098, 172),(-2934, 4098, 172));
	CreateWalls((-2375, 4098, 55),(-2934, 4098, 55));
	CreateWalls((-2934, 4986, 493),(-2934, 5282, 493));
	CreateWalls((-1184, 5299, 493),(-2903.88, 5299, 493));

	CreateWalls((-1154, 4683, 493),(-1154, 5282, 493));
	CreateWalls((-1154, 4683, 433),(-1154, 4961, 433));
	CreateWalls((-1154, 4683, 373),(-1154, 4841, 373));
	CreateWalls((-1154, 4213, 423),(-1154, 4070, 423));
	spawncrate((-1781, 4005, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1781, 4005, 198), (0, 10, 90), "com_plasticcase_friendly");
	spawncrate((-1781, 4005, 228), (0, 10, 90), "com_plasticcase_friendly");
	spawncrate((-1781, 4005, 258), (0, 10, 90), "com_plasticcase_friendly");
	
	spawncrate((-1776, 3975, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1771.5, 3945, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1766, 3915, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1761.5, 3885, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1757.5, 3855, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1752.5, 3825, 169), (0, 10, 0), "com_plasticcase_friendly");
	spawncrate((-1748.5, 3795, 169), (0, 10, 0), "com_plasticcase_friendly");
	CreateRamps((-1795.6, 3803, 170),(-1892, 3787, 230));
	CreateRamps((-1938.6, 3797, 248),(-2050, 3871, 289));
	spawncrate((-1926.5, 3782, 244), (0, 100, 0), "com_plasticcase_friendly");
	spawncrate((-2073.5, 3885, 297), (0, 52, 0), "com_plasticcase_friendly");
	spawncrate((-2130.5, 3996, 297), (0, 0, 0));
	spawncrate((-2160.5, 3996, 297), (0, 0, 0));
	CreateQuicksteps((-2146, 4655, 345), 50, 16, 2, (0,270,0));
	CreateQuicksteps((-2468, 4655, 345), 50, 16, 2, (0,270,0));
	spawncrate((-1921.5, 4161, 124), (0, 330, 0));

	CreateQuicksteps((-1847, 4211, 130), 100, 16, 2, (0,355,0), 390);
	spawncrate((-1265, 4105, 110), (0, 0, 0));
	spawncrate((-1359, 4059, 66), (0, 90, 0), "com_plasticcase_friendly");
	CreateWalls((-1359, 4082, 115),(-1359, 3414, 115));
	CreateWalls((-1359, 3627, 49),(-1359, 3414, 49));
	CreateDoors((-1194, 4282, 145) /*open*/, (-1194, 4282, 70) /*close*/, (90,0,0) /*angle*/, 6 /*size*/, 2 /*height*/, 15 /*hp*/, 150 /*range*/, 0 /*sideways*/);
	CreateDoors((-2819.5, 4855, 145) /*open*/, (-2819.5, 4855, 70) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 100 /*range*/, 0 /*sideways*/);
	CreateDeathRegion((-2947, 5916, -30),(-3436, 4831, 315));
	CreateDeathRegion((-1135.88, 4382.8, 370),(-454, 4940, 462));
	CreateDeathRegion((-1086.43, 3510.46, 28),(-43, 3100, 150));
	CreateDeathRegion((-1135.88, 4532.87, 540),(-656,4298.8, 660));
	createTP((1073.1,6304.08,191.875), (-466, 4690, 44), (0, -90,0));
	createTP((2431.35,5453.63,216.125), (-466, 4690, 44), (0, -90,0));
	createTP((1391.9,3610.83,40.125), (-466, 4690, 44), (0, -90,0));
	createTP((514.71,4868.89,42.6011), (-466, 4690, 44), (0, -90,0));
	createTP((-128.276,5128.76,193.125), (-466, 4690, 44), (0, -90,0));
	createTP((2429.09,3384.08,80.125), (-466, 4690, 44), (0, -90,0));
	createTP((-2815.89,5409.9,0.125), (-2690, 3825, 50), (0,0,0));
	//createHiddenTP((-2149.64, 5251, 470), (1066.99, 7427.14, 215), (0, 270, 0), "out");
	fufalldamage((-2019, 4128, 60),1500, 900);
	spawnmodel((-600, 3346, 40) , (0, 10, 0) , "police_barrier_01");
	spawnmodel((-414, 3326, 40) , (0, 13, 0) , "police_barrier_01");
	spawnmodel((-862, 3339, 40) , (0, 13, 0) , "vehicle_policecar_russia_destructible");
	spawnmodel((-2405, 4200, 299) , (270, 357, 0) , "com_steel_ladder");
	spawncrate((-2355, 4198, 289), (0, 357, 0));
	spawncrate((-2270, 4193, 289), (0, 357, 0));
}
offshore_edit1(){
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "me_electricbox2" || ent.model == "com_tv1_cinematic" || ent.model == "machinery_oxygen_tank01" || ent.model == "com_wall_fan_blade" || ent.model == "com_barrel_benzin" || ent.model == "com_filecabinetblackclosed") {
			//iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}  
	}
	
	//new bridge
	
	spawnmodel((-1388, 3121, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1377, 3110, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1366, 3099, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1355, 3088, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1344, 3077, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1333, 3066, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	spawnmodel((-1322, 3055, 857) , (-16, 45, 0) , "rnk_crane_boom_part_01");
	
	spawnmodel((-1336, 3107, 810) , (-16, 45, 0) , "rnk_crane_vista");
	CreateInvisRamps((-2195, 2215, 500),(-1295, 3115, 860));
	CreateInvisRamps((-2230, 2250, 500),(-1330, 3150, 860));
	
	for(i = 0;i < 7;i++)
	spawnmodel((-1215, 3220, 876)+(-13* i,-13* i,0), (0, -45, -5) , "rnk_pipe_8x128_light_metal");

	for(i = 0;i < 7;i++)
	spawnmodel((-1260, 3265, 876)+(-13* i,-13* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal");
	
	
	i=0;
	spawnmodel((-1119, 3124, 876)+(-13* i,-13* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1121, 3126, 876)+(-13* i,-13* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1127, 3132, 876)+(-13* i,-13* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1127, 3132, 876)+(-16* i,-10* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1116, 3121, 876)+(-19* i,-7* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1127, 3132, 876)+(-19* i,-7* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	spawnmodel((-1127, 3132, 876)+(-19* i,-7* i,0), (0, -45, 0) , "rnk_pipe_8x256_light_metal"); i++;
	
	i=0;
	spawnmodel((-1027, 3032, 876)+(-13* i,-13* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1029, 3034, 876)+(-13* i,-13* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1035, 3040, 876)+(-13* i,-13* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1035, 3040, 876)+(-16* i,-10* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1024, 3029, 876)+(-19* i,-7* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1035, 3040, 876)+(-19* i,-7* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	spawnmodel((-1035, 3040, 876)+(-19* i,-7* i,0) , (0, -45, 0) , "rnk_pipe_coupling_light_metal_long_lod"); i++;
	
	
	spawnmodel((-1232, 3183, 866) , (0, 0, 0) , "rnk_drill_pipe");
	spawnmodel((-1149, 3094, 868) , (0, 80, 0) , "rnk_drill_pipe");
	spawnmodel((-1075, 3015, 709) , (50, -55, 0) , "rnk_crane_end_vista");
	
	 
	
	for(i = 0;i < 6;i++)
	spawnmodel((-1301, 3078, 863)+(-13* i,13* i, 0) , (-16, 45, 0) , "rnk_pipe_8x64_light_metal");
	for(i = 0;i < 6;i++)
	spawnmodel((-1272, 3107, 872)+(-13* i,13* i, 0) , (-5, 45, 0) , "rnk_pipe_8x32_light_metal");


	spawnmodel((-1350, 3096, 827) , (0, -45, 106) , "commerce_ceiling_tile");
	spawnmodel((-1323, 3069, 827) , (0, -45, 106) , "commerce_ceiling_tile");
	spawnmodel((-1377, 3123, 827) , (0, -45, 106) , "commerce_ceiling_tile");
	CreateInvisGrids((-1315, 3175, 868),(-1050, 3270, 868), (0,-45,0));
	
	//spawns
	
	thread createTP((-1294, 1059.5, -11.875),(-1247, 3170, 884), (0, 315, 0), 1,undefined,undefined,430);//latetp
	
	disable_spawn_array = [];
	disable_spawn_array[disable_spawn_array.size] = (1233.5, 209.1, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (1711.6, -212.2, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (2366.5, 339.9, -11.875);
	disable_spawn_array[disable_spawn_array.size] = (-321.9, -1997.4, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (2076.7, 901.2, -11.875);
	disable_spawn_array[disable_spawn_array.size] = (-1584.1, -1127.5, -3.875);
	disable_spawn_array[disable_spawn_array.size] = (-607.5, -1470.5, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (-1399.3, -1687.7, -11.875);
	disable_spawn_array[disable_spawn_array.size] = (1611.5, -374.2, -179.875);
	disable_spawn_array[disable_spawn_array.size] = (1366.6, 931.3, -171.875);
	disable_spawn_array[disable_spawn_array.size] = (-1703.7, -948.6, -171.875);
	disable_spawn_array[disable_spawn_array.size] = (-1650.8, -1693.1, -11.875);
	disable_spawn_point(disable_spawn_array);

	add_spawn_point((-1433.48, 152.25, 3),(0, 90, 0));
	add_spawn_point((-1565.36, 301.72, 3),(0, 45, 0));
	
	add_spawn_point((-658.753, 1557.11, 3),(0, -45, 0));
	add_spawn_point((-589.68, 1596.63, 3),(0, -55, 0));
	add_spawn_point((-695.3, 1499.76, 3),(0, -33, 0));
	
	add_spawn_point((-305, 1630.33, 3),(0, 225, 0));
	add_spawn_point((-41.99, 1130.75, 3),(0, 190, 0));
	add_spawn_point((-150.822, 1247.84, 3),(0, 180, 0));
	add_spawn_point((-245.363, 1324.16, 3),(0, 195, 0));
	
	add_spawn_point((-950.23, 492.717, 3),(0, 135, 0));
	add_spawn_point((-235, 129, 3),(0, 135, 0));
	add_spawn_point((-1779.4, 463, 3),(0, -35, 0));
	
	add_spawn_point((-1023.72, 919, 3),(0, 135, 0));
	add_spawn_point((-411, 942, 3),(0, 146, 0));

	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn");
	
	createTP((-450, -896, -179.875),(-659, 1279, -7.875), (0, -135, 0), undefined);
	createTP((1976, 328, -11.875),(-659, 1279, -7.875), (0, -135, 0), undefined);
	createTP((897, 55, -179.875),(-659, 1279, -7.875), (0, -135, 0), undefined);
	createTP((-727, -1472, -11.875),(-659, 1279, -7.875), (0, -135, 0), undefined);

	
	spawnmodel((-1092, 1291, 30) , (270, 45, 90) , "rnk_tarp_3");
	spawnmodel((-1091, 1290, 30), (270, 225, 90), "rnk_tarp_3");	
	
	spawnmodel((-1391, 990, 30), (270, 45, 90), "rnk_tarp_3");	
	spawnmodel((-1391, 990, 30), (270, 225, 90), "rnk_tarp_3");
		
	
	 //CreateInvisRamps((-1282, 1175, -23),(-1422, 1315, -23)); //delete when ents
	
	i=0;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	spawncrate((1485 ,1196 ,544) + (55* i, 55* i, 0), (0,45,90)); i++;
	
	spawncrate((-2143 ,2118, 504), (18,315,90));
	spawncrate((-2134 ,2109, 561), (18,315,90));
	
	spawncrate((-2176.6 ,2148 ,522), (0,315,90)); 
	spawncrate((-2176.6 ,2148 ,582), (0,315,90)); 
	
	i=0;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2170 ,2177 ,550) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	
	i=0;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;
	spawncrate((-2181 ,2166 ,610) + (59* i, 59* i, 24* i), (16,225,90)); i++;

	spawnmodel((-340, 1109, 214), (0, 135, 0), "rnk_propane_tank02");
	//spawnmodel((-2234, 2403, 570), (-16, 45, 0), "rnk_propane_tank02");
	//spawnmodel((-1993, 2642, 670), (-16, 45, 0), "rnk_propane_tank02");
	spawnmodel((-1752, 2881, 790), (16, -135, 0), "rnk_propane_tank02");
	spawnmodel((-1511, 3120, 890), (16, -135, 0), "rnk_propane_tank02");
	spawnmodel((-1107, 3198, 920), (0, 135, 0), "rnk_propane_tank02");	
	spawnmodel((-904, 2855, 920), (0, 108, 0), "rnk_propane_tank02");
	spawnmodel((-2064, 2231, 560), (-16, 45, 0), "rnk_propane_tank02");	
	spawnmodel((-1823, 2472, 660), (-16, 45, 0), "rnk_propane_tank02");	
	
	spawnmodel((-1292, 1183, 100), (0, 45, 0), "rnk_pipe_8x256_red");
	spawnmodel((-1281, 1172, 100), (0, 45, 0), "rnk_pipe_8x256_red");
	spawnmodel((-1270, 1161, 100), (0, 45, 0), "rnk_pipe_8x256_red");
	spawnmodel((-1259, 1150, 100), (0, 45, 0), "rnk_pipe_8x256_red");
	spawnmodel((-1248, 1139, 100), (0, 45, 0), "rnk_pipe_8x256_red");
	spawnmodel((-1011, 1354, 100), (0, 45, 0), "rnk_pipe_8x128_red");
	spawnmodel((-1000, 1343, 100), (0, 45, 0), "rnk_pipe_8x128_red");
	spawnmodel((-989, 1332, 100), (0, 45, 0), "rnk_pipe_8x128_red");
	spawnmodel((-978, 1321, 100), (0, 45, 0), "rnk_pipe_8x128_red");
	spawnmodel((-1237, 1128, 100), (0, 45, 0), "rnk_pipe_8x512_red");
	spawnmodel((-1226, 1117, 100), (0, 45, 0), "rnk_pipe_8x512_red");
	spawnmodel((-1215, 1106, 100), (0, 45, 0), "rnk_pipe_8x512_red");
	spawnmodel((-1204, 1095, 100), (0, 45, 0), "rnk_pipe_8x512_red");

	//cannonball

	spawnmodel((-1786, 1524, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1801, 1539, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1816, 1554, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1831, 1569, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1846, 1584, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1861, 1599, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	spawnmodel((-1876, 1614, 246), (0, 45, 0), "rnk_pipe_8x128_white");
	
	spawnmodel((-1739, 1571, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1754, 1586, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1769, 1601, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1784, 1616, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1799, 1631, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1814, 1646, 246), (0, 45, 0), "rnk_pipe_coupling_white");
	spawnmodel((-1829, 1661, 246), (0, 45, 0), "rnk_pipe_coupling_white");	
	
	CreateInvisGrids((-1840, 1635, 238),(-1985, 1535, 238), (0,45,0));
	spawncrate((-1980, 1480, 238) , (0, 45, 0));
	
	spawnmodel((-1958, 1524, 188) , (43, 56, 6) , "rnk_pipe_8x256_white");
	spawnmodel((-1880, 1640, 58) , (43, 56, 6) , "rnk_pipe_8x256_white");
	
	spawnmodel((-1930, 1560, 246) , (0, 45, -2) , "rnk_pipe_8x128_white");
	spawnmodel((-1900, 1530, 246) , (0, 45, -2) , "rnk_pipe_8x128_white");
	spawnmodel((-1886, 1514, 246) , (0, 45, 2) , "rnk_pipe_8x128_white");
	spawnmodel((-1871, 1499, 246) , (0, 45, -11) , "rnk_pipe_8x128_white");
	spawnmodel((-1856, 1484, 246) , (0, 45, -2) , "rnk_pipe_8x128_white");
	spawnmodel((-1951, 1509, 246) , (0, 45, -2) , "rnk_pipe_8x128_white");

	spawnmodel((-2010, 1447, 274) , (43, 51, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1997, 1464, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1975, 1515, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1944, 1486, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1930, 1470, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1915, 1455, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1900, 1440, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1830, 1481, 246) , (0, 45, 0) , "rnk_pipe_coupling_white");
	spawnmodel((-1799, 1510, 251) , (0, -46, 2) , "rnk_handrail_128_double_blue");
	//spawnmodel((-1875, 1537, 236) , (0, 68, 0) , "rnk_drill_pipe");
	spawnmodel((-1861, 1533, 235) , (0, 22, 0) , "rnk_drill_pipe");
	cannonball((-1884, 1519, 241), (0,45,0), 2, (-998, 2765, 870.618), 700);
	spawnmodel((-1722, 1678, 351) , (80, 135, 450) , "rnk_crane_arm_base_1");
	spawnmodel((-1671, 1713, 219) , (-85, 17, 0) , "rnk_pipe_8x64_single_white");
	for(i = 0;i < 3;i++)
	spawncrate((-1754, 1734, 235) + (28* i, -28* i, -7* i), (80, 135, 90)); 
	for(i = 0;i < 3;i++)
	spawncrate((-1729, 1759, 235) + (28* i, -28* i, -7* i), (80, 135, 90));
	for(i = 0;i < 3;i++)
	spawncrate((-1743, 1723, 325) + (28* i, -28* i, -7* i), (80, 135, 90)); 
	for(i = 0;i < 3;i++)
	spawncrate((-1718, 1748, 325) + (28* i, -28* i, -7* i), (80, 135, 90));
	
	createHiddenTP((-628, 1555, 722.125),(1546, 1142, 508.125), (0, 90, 0) , undefined);
	createHiddenTP((1815, 1131, 633),(-653, 1740.47, 733), (0, 120, 0) , undefined, 1);//way back?
	createTP((-1294, 1059.5, -11.875),(-1247, 3170, 884), (0, 315, 0), 1,undefined,undefined,430);//latetp
	CreateDoors((1990,1370, 510)/*open*/,(1890,1470, 510) /*close*/, (90,45,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/,  true /*sideways*/);
	
	//end platform

	CreateInvisWalls((1460, 1130, 510),(1530, 1060, 600));

	for(i = 0;i < 3;i++)	
	spawnmodel((1536, 1747, 618) + (-148* i,-148* i, 0) , (195, 45, 0) , "rnk_crane_arm_base_2_gold");
	for(i = 0;i < 3;i++)	
	spawnmodel((1537, 1899, 618)+ (-148* i,-148* i, 0), (195, 225, 0) , "rnk_crane_arm_base_2_gold");
	
	spawnmodel((1316, 1531, 639) , (0, 45, -90) , "berlin_office_ceiling_light_off");
	spawnmodel((1315, 1532, 639) , (0, 225, -90) , "berlin_office_ceiling_light_off");
	spawnmodel((1386, 1619, 624) , (0, 45, 0) , "rnk_engine_machine");
	spawnmodel((1505, 1730, 632) , (0, 47, -33) , "rnk_pipe_8x256_metal_rusted");
	spawnmodel((1505, 1727, 647) , (0, 46, 0) , "rnk_pipe_8x256_metal_rusted");
	spawnmodel((1592, 1824, 632) , (0, 47, -3) , "rnk_pipe_coupling_metal_rusted");
	spawnmodel((1595, 1821, 647) , (0, 46, 0) , "rnk_pipe_coupling_metal_rusted");
	CreateInvisGrids((1188.66, 1441, 613),(1141, 2064, 613), (0,-45,0));
	for(i = 0;i < 2;i++)	
	spawncrate((1363.7, 1597, 644) + (35* i, 35* i, 0), (90, 45, 0));  
	spawncrate((1297, 1501, 641), (0, 45, 90));  
	spawncrate((1337, 1541, 641), (0, 45, 90));  
	for(i = 0;i < 5;i++)
	spawncrate((1426, 1640, 637) + (40* i, 40* i, 0), (0, 45, 90));   
	spawnmodel((1417, 1280, 619) , (0, 135, 0) , "rnk_crane_webbing_main_gold_no_end");
	spawnmodel((1591, 1104, 619) , (0, 135, 0) , "rnk_crane_webbing_main_gold_no_end");
	spawnmodel((1243, 1458, 618) , (0, -45, 0) , "rnk_crane_webbing_main_gold_no_end");
	spawnmodel((1419, 1282, 618) , (0, -45, 0) , "rnk_crane_webbing_main_gold_no_end");
	spawnmodel((1205, 1559, 612) , (-45, 138, 0) , "rnk_crane_boom_part_01");
	spawnmodel((1587, 1929, 615) , (-40, 102, 0) , "rnk_crane_boom_part_01");
	CreateInvisRamps((1489, 1210, 613),(1259, 1440, 613));
	
	//ladder

    spawnmodel((2205, 1266, 625) , (90, -135, 0) , "cargo_cage_wall_long");
	spawnmodel((2192.7, 1266.5, 623) , (0, 45, 0) , "rnk_handrail_64_double_yel");
	spawnmodel((2218, 1240, 623) , (0, 136, 0) , "rnk_handrail_90_yel");
	spawnmodel((2165, 1287, 623) , (0, -46, 0) , "rnk_handrail_90_right_yel");
	spawnmodel((2194, 1212, 623) , (0, -223, 0) , "rnk_handrail_64_double_yel");
	spawnmodel((2175, 1183, 623) , (0, 44, 0) , "rnk_handrail_90_right_yel");
	spawnmodel((2141, 1277, 620), (0, 45, 10), "rnk_russian_oscar2_ladder_a2");	
	
	CreateInvisQuicksteps((2155, 1260, 613), 190, 16, 2, (0,135,0));
	spawncrate((2166, 1263.88, 611), (0,45,0));
    spawncrate((2189, 1240.88, 611), (0,45,0));
	for(i = 0;i < 2;i++)
	spawncrate((2193, 1188, 672) + (30* i, 30* i, 0), (90, 45, 0)); 
	for(i = 0;i < 2;i++)
	spawncrate((2213, 1268, 672) + (-30* i, 30* i, 0), (90, 135, 0)); 
	 
	//fence to block sky barrier (maybe remove?)
	spawnmodel((1560, 1242, 628) , (0, 44, 0) , "rnk_handrail_90_right_yel");
	spawnmodel((1709, 1399, 628) , (0, 135, 0) , "cs_handrail_64_end_yel");
	spawnmodel((1603, 1293, 628) , (0, -45, 0) , "rnk_handrail_128_double_yel");
	spawnmodel((1670, 1360, 628) , (0, -45, 0) , "cs_handrail_64_damage_yel");
	for(i = 0;i < 5;i++)
	spawncrate((1561, 1269, 682) + (37* i, 37* i, 0), (90, 45, 0)); 
	 
	 
	//createHiddenTP((1602, 1885, 628.125),(-807, -1957, 200.125), undefined , "out");
	CreateDeathRegion((2940, 1045, 400.563), (677, -1151, 586.764));
	CreateDeathRegion((-1588, 4500, 683.461), (336, 521, 380.717));
	 
	fuckerbeepboop = getent("mp_global_intermission", "classname");
	fuckerbeepboop.origin = (230, -1181, 1995);
	fuckerbeepboop.angles = (38, 90, 5);
	spawnmodel((210, -1145, 1985), (-34, -65, -25), "com_teddy_bear");
	//block wb (end edit)
	spawncrate((1819, 1431, 660) , (0, 135, 0));
	spawncrate((1783, 1395, 660) , (0, 135, 0));
}
erosion_edit1(){
	tpents = GetEntArray("tpjug", "targetname");
	foreach(ent in tpents)
		ent delete();
	level.meat_playable_bounds = [
		(-1219.73, -2110.63, 520.038),
		(686.432, -2132.5, 289.564),
		(681.381, -3397.63, 258.936),
		(-1769.8, -3402.51, 167.125),
		(-1769.57, -1760.16, 227.125),
		(-1833.73, -1124.05, 483.335),
		(-1825.76, -841.271, 483.335),
		(-1213.48, -837.654, 464.135),
		(-1219.61, -2013.79, 489.63)
	];
	createPolygon();
	moveac130position((-672, -2966, 1960));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-1531, -3302, 66);
	mp_global_intermission.angles = (-17, 50, 0);
	
	CreateRamps((-1266.84, -2637, 250),(-1266.84, -2862, 250));
	fufalldamage((-1260, -2748, 25),600, 420);
	
	createTP((-50, -1942, 127.457), (-650, -2644, 49), (0, 40, 0));
	createTP((776, -728, 129.125), (-650, -2644, 49), (0, 40, 0));
	createTP((-69, -325, 121.69), (-650, -2644, 49), (0, 40, 0));
	createTP((-682, -736, -1.81347), (-650, -2644, 49), (0, 40, 0));
	createTP((-1081, -1985, 248.125), (-650, -2644, 49), (0, 40, 0));
	createTP((-43, -1090, 126.125), (-650, -2644, 49), (0, 40, 0));
	//createHiddenTP((-1542, -937, 440.125), (-63, 326, 128.125), undefined, "out");
	// Spawn wall fill
	CreateWalls((-129, -2725, 40),(256, -2725, 40));
	CreateWalls((-129, -2725, 100),(256, -2725, 100));
	CreateWalls((-129, -2725, 160),(256, -2725, 160));
	CreateInvisWalls((-370, -2725, 220),(256, -2725, 220));
	CreateInvisWalls((-370, -2725, 280),(256, -2725, 280));
	// Out of spawn long wall
	CreateWalls((687, -3170, 20),(687, -2490, 20));
	CreateWalls((687, -3170, 80),(687, -2380, 80));
	CreateWalls((687, -3220, 140),(687, -2150, 140));
	CreateWalls((687, -2650, 200),(687, -2150, 200));
	CreateWalls((687, -2650, 260),(687, -2150, 260));
	// Blockers
	spawncrate((594, -2165, 280), (90, 90, 0), "com_plasticcase_friendly");
	spawncrate((467, -2158, 280), (90, 90, 0), "com_plasticcase_friendly");
	// Doors Left
	CreateWalls((287, -2785, 40),(287, -2925, 40));
	CreateWalls((287, -2785, 100),(287, -2925, 100));
	CreateWalls((287, -2785, 160),(287, -2925, 160));
	//
	CreateWalls((437, -2785, 40),(437, -2925, 40));
	CreateWalls((437, -2785, 100),(437, -2925, 100));
	CreateWalls((437, -2785, 160),(437, -2925, 160));
	//
	CreateWalls((317, -2926, 40),(406, -2926, 40));
	CreateWalls((317, -2926, 100),(406, -2926, 100));
	CreateWalls((317, -2926, 160),(406, -2926, 160));
	// Doors Right
	CreateWalls((287, -3228, 40),(287, -3379, 40));
	CreateWalls((287, -3228, 100),(287, -3379, 100));
	CreateWalls((287, -3228, 160),(287, -3379, 160));
	//
	CreateWalls((437, -3228, 40),(437, -3379, 40));
	CreateWalls((437, -3228, 100),(437, -3379, 100));
	CreateWalls((437, -3228, 160),(437, -3379, 160));
	//
	CreateWalls((317, -3226, 40),(406, -3226, 40));
	CreateWalls((317, -3226, 100),(406, -3226, 100));
	CreateWalls((317, -3226, 160),(406, -3226, 160));
	// 1st Door
	CreateDoors((287, -3072, 140) /*open*/, (287, -3072, 60) /*close*/, (90,0,0) /*angle*/, 5 /*size*/, 3 /*height*/, 30 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	// 2nd wall fill
	CreateWalls((-289, -3407, 70),(-72, -3407, 70));
	CreateWalls((-300, -3407, 130),(-10, -3407, 130));
	CreateWalls((-330, -3407, 190),(20, -3407, 190));
	// Shooting platform
	CreateGrids((-432, -3025, 200),(-582, -2736, 200), (0,0,0));
	CreateRamps((-630, -2770, 187),(-850, -2770, 40));
	// Shooting platform side blocker
	CreateWalls((-800, -2715, 220),(-400, -2715, 300));
	CreateWalls((-395, -2750, 220),(-395, -2930, 300));
	// Yet another wall filler xD pog lmao good one
	CreateWalls((-1264, -3408, 20),(-1762, -3408, 20));
	CreateWalls((-1264, -3408, 80),(-1762, -3408, 80));
	CreateWalls((-1264, -3408, 140),(-1762, -3408, 140));
	CreateWalls((-1775, -3380, 20),(-1775, -3360, 20));
	CreateWalls((-1775, -3380, 80),(-1775, -3300, 80));
	CreateWalls((-1775, -3380, 140),(-1775, -3300, 140));
	// Death barrier
	CreateDeathRegion((-1240, -1747, 0), (-2207, -201, 160));
	CreateDeathRegion((-1218, -1132, 0), (-1971, -480, 350));
	// Near end wall small
	CreateWalls((-1584, -1766, 80),(-1768, -1766, 80));
	CreateWalls((-1584, -1766, 140),(-1768, -1766, 140));
	CreateWalls((-1584, -1766, 200),(-1768, -1766, 200));
	// Near end wall big
	CreateWalls((-1775, -1770, 80),(-1775, -2000, 80));
	CreateWalls((-1775, -1770, 140),(-1775, -2110, 140));
	CreateWalls((-1775, -1770, 200),(-1775, -2220, 200));
	// Tower barrier block
	CreateInvisWalls((-1225, -1761, 520),(-1213, -633, 520));
	CreateInvisWalls((-1225, -1761, 580),(-1213, -633, 580));
	// end wall blocker
	spawncrate((-1756, -2209, 250), (0, 0, 0));
	spawncrate((-1756, -2209, 290), (0, 0, 0));
	spawncrate((-1820, -2209, 250), (0, 0, 0));
	spawncrate((-1820, -2209, 290), (0, 0, 0));
	spawncrate((-758, -2746, 280), (0, 0, 0));
	// 2nd door wall
	CreateWalls((-1745, -2611, 20),(-1555, -2611, 140));
	CreateDoors((-1458, -2607, 120) /*open*/, (-1458, -2607, 42) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 3 /*height*/, 20 /*hp*/, 80 /*range*/, 0 /*sideways*/);
	// Tower quickstep
	CreateQuicksteps((-1476, -1403, 470), 200, 16, 2, (0,-90,0));
	// Blocker to stop getting stuck between tower and map barrier
	spawncrate((-1249, -1145, 470), (0, 90, 0), "com_plasticcase_friendly");
}
erosion_edit2(){
	spawncrate((-3639, -2044, -570), (0, 90, 0));
	level.meat_playable_bounds = [
		(-3452.02, -4116.92, -404.549),
		(-3457.85, -3806.45, -191.573),
		(-3399.6, -3800.25, -191.62),
		(-3399.6, -3200.25, -191.62),
		(-2892.6, -3200.25, -191.62),
		(-2892.6, -2886.25, -191.62),
		(-3375.6, -2729.25, -191.62),
		(-3385.83, -557.059, -141.667),
		(-3902.02, -586.576, -276.99),
		(-3905.5, -4103.74, -438.422),
		(-3452.02, -4116.92, -404.549),
		(-3252.02, -2734.92, -404.549),
		(304.02, -2717.92, -404.549),
		(538.02, -2636.92, -404.549),
		(538.02, -5837.92, -404.549),
		(86.02, -5837.92, -404.549)
	];
	createPolygon();
	moveac130position((-1688, -3417, 2089));
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-3534, -3258, -466);
	mp_global_intermission.angles = (-13, 115, 0);
	
	//flag cover
	
	/*	
	ent = spawn("script_model", (392, -3763, 716));
	ent.angles = (0, 0, 0);
	ent setmodel_hook("intro_alleyway_gate_01");
	*/
	spawnmodel((-3857, -3940, -510) , (0, 80, 0) , "aq_crate02");
	spawnmodel((-3857, -3940, -485) , (0, 85, 0) , "aq_crate02");
	spawnmodel((-3857, -3940, -460) , (0, 120, 0) , "aq_crate02");
	spawnmodel((-3805, -3941, -517) , (0, 0, 0) , "aq_crate02");
	spawnmodel((-3809, -3947, -493) , (0, 193, 0) , "aq_crate02");
	spawnmodel((-3853, -3964, -520) , (0, 80, 0) , "aq_debris_pile_white_gravel");
	spawnmodel((-3852, -3977, -510) , (0, 0, 0) , "skassault_rubble_brickpile_01");
	spawnmodel((-3877, -3952, -510) , (5, 25, 0) , "ctl_foliage_grass_multiclump");
	
	spawncrate((-3859 ,-3949 ,-500), (0,10,0));
	spawncrate((-3859 ,-3949 ,-450), (0,10,0));
	spawncrate((-3809 ,-3950 ,-480), (0,104,0));
	
	CreateInvisWalls((-3920, -3649, -390),(-3920, -4109, -390));
	CreateInvisWalls((-3889, -4122, -396),(-3642, -4113, -396));

	CreateInvisRamps((-3870, -3780, -495),(-3870, -3214, -510), (0,0,0)); //wallbreach
	CreateInvisRamps((-3870, -3214, -510),(-3870, -2396, -490), (0,0,0)); //wallbreach
	spawncrate((-3889, -3824, -495), (0, 45, 0)); //wallbreach

	//createTurret((286, -5359, 897), (0,90,0), 25, 25, 35, 10);
	
	CreateDoors((-4043, -2218, -510) /*open*/,(-3649, -2218, -510) /*close*/, (90,90,0) /*angle*/, 9 /*size*/, 4 /*height*/, 15 /*hp*/, 230 /*range*/, 0 /*sideways*/);
	spawnmodel((419, -3768, 766) , (0, 93, 90) , "aq_stone_block_04");
	spawnmodel((310, -3768, 755) , (0, 3, 270) , "aq_stone_block_04");
	spawnmodel((335, -3728, 690) , (0, 93, 180) , "aq_stone_block_04");
	spawnmodel((400, -3728, 690) , (0, 93, 180) , "aq_stone_block_04");
	spawnmodel((395, -3768, 810) , (0, 93, 180) , "aq_stone_block_05");
	spawnmodel((335, -3768, 810) , (0, 103, 180) , "aq_stone_block_05");
	spawnmodel((310, -3750, 812) , (0, 273, 0) , "aq_ivy_pillar");
	spawnmodel((363, -4269, 524) , (0, 13, 0) , "foliage_afr_tree_umbrellathorn_01a");
	//foliage_tree_oak_2
	//363, -4269, 504
	spawnmodel((368, -4280, 713) , (88, 85, 0) , "afr_ladder_01");
	spawnmodel((364, -5250, 714) , (30, 270, 0) , "afr_ladder_01");
	
	//new miniarch
	spawnmodel((419, -4437, 766) , (0, 93, 90) , "aq_stone_block_04");
	spawnmodel((310, -4437, 755) , (0, 3, 270) , "aq_stone_block_04");
	spawnmodel((335, -4397, 690) , (0, 93, 180) , "aq_stone_block_04");
	spawnmodel((400, -4397, 690) , (0, 93, 180) , "aq_stone_block_04");
	spawnmodel((395, -4437, 810) , (0, 93, 180) , "aq_stone_block_05");
	spawnmodel((335, -4437, 810) , (0, 103, 180) , "aq_stone_block_05");
	
	//archway 2
	spawncrate((324 ,-4397 ,700), (0,0,0));
	spawncrate((405 ,-4397 ,700), (0,0,0));
	
	spawncrate((419 ,-4438 ,760), (90,90,0), "com_plasticcase_friendly");
	spawncrate((310 ,-4438 ,760), (90,90,0), "com_plasticcase_friendly");
	spawncrate((364, -4438 ,814), (0,0,0));

	fufalldamage((-3664, -3026, -500),530, 770);

	cannonballInvis((167, -5347, 846), (0,325,0), 0, (-3676, -2582, -450), 1200);
	spawncrate((221 ,-5386 ,846), (0,325,0));
	spawnmodel((185, -5350, 863) , (0, 325, 90) , "wood_plank1");
	spawnmodel((185, -5370, 863) , (0, 324, 90) , "wood_plank2");
	spawnmodel((185, -5350, 863) , (0, 325, 90) , "wood_plank1");
	spawnmodel((185, -5370, 863) , (0, 324, 90) , "wood_plank2");
	spawnmodel((433, -5350, 860) , (0, 0, 0) , "aq_brick_tan");
	spawnmodel((364, -2831, 715) , (0, 0, 0) , "aq_statue_female_01");
	spawnmodel((362, -2752, 730) , (0, 0, 0) , "aq_brick_tan_short_02");
	spawnmodel((362, -2752, 752) , (0, 0, 0) , "aq_brick_tan_short_02");
	spawnmodel((362, -2752, 774) , (0, 0, 0) , "aq_brick_tan_short_02");
	spawnmodel((362, -2752, 795) , (0, 0, 0) , "aq_brick_tan_short_01");
	spawnmodel((323, -5352, 875) , (0, 0, 0) , "aq_stone_block_06");
	spawnmodel((287, -5352, 875) , (0, 0, 90) , "aq_stone_block_07");
	spawnmodel((251, -5352, 875) , (0, 180, 0) , "aq_stone_block_06");
	spawnmodel((355, -5355, 840) , (0, 270, 0) , "aq_stone_block_04");
	spawnmodel((355, -5390, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((355, -5430, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((355, -5470, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((289, -5355, 840) , (0, 270, 0) , "aq_stone_block_04");
	spawnmodel((289, -5390, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((289, -5430, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((289, -5470, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((289, -5500, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((355, -5500, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((400, -5500, 840) , (0, 90, 0) , "aq_stone_block_04");
	spawnmodel((411, -5370, 840) , (0, 0, 0) , "aq_stone_block_04");
	spawnmodel((445, -5370, 840) , (0, 0, 0) , "aq_stone_block_04");
	spawnmodel((478, -5370, 840) , (0, 180, 0) , "aq_stone_block_04");
	spawnmodel((411, -5440, 840) , (0, 0, 0) , "aq_stone_block_04");
	spawnmodel((445, -5440, 840) , (0, 0, 0) , "aq_stone_block_04");
	spawnmodel((478, -5440, 840) , (0, 180, 0) , "aq_stone_block_04");
	spawnmodel((240, -5499, 840) , (0, 180, 0) , "aq_stone_block_04");
	spawnmodel((240, -5440, 840) , (0, 180, 0) , "aq_stone_block_04");
	spawnmodel((240, -5370, 840) , (0, 0, 0) , "aq_stone_block_04");
	spawnmodel((359, -5411, 670) , (0, 180, 90) , "aq_stone_block_04");
	spawnmodel((359, -5411, 740) , (0, 140, 90) , "aq_stone_block_04");
	spawnmodel((359, -5411, 800) , (0, 93, 0) , "aq_stone_block_04");
	spawnmodel((364, -5219, 686) , (0, 93, 270) , "aq_stone_block_05");
	spawnmodel((364, -5250, 686) , (0, 90, 270) , "aq_stone_block_05");
	spawnmodel((452, -5336, 890) , (0, 0, 0) , "ctl_vine_patch_hang");
	spawnmodel((493, -5349, 872) , (0, 0, 4) , "prop_flag_sas");
	spawncrate((340 ,-5228 ,655), (0,90,0));
	spawncrate((380 ,-5228 ,655), (0,90,0));

	spawncrate((365 ,-5230 ,700), (0,90,0));
	CreateinvisGrids((466, -5355, 848),(255, -5471, 848), (0,0,0));
	CreateinvisGrids((416, -5500, 848),(255, -5500, 848), (0,0,0));
	CreateInvisQuicksteps((362, -5340, 835), 150, 16, 8, (0,90,0));
	spawncrate((255 ,-5512 ,848), (0,0,0));
	spawncrate((314 ,-5352 ,876), (0,0,0));
	spawncrate((266 ,-5352 ,876), (0,0,0));
	spawncrate((424 ,-5352 ,865), (0,0,0));
	spawncrate((464 ,-5352 ,865), (0,0,0));

		spawncrate((430 ,-2832 ,760), (0,90,0));
	spawncrate((291 ,-2832 ,760), (0,90,0));
	spawncrate((430 ,-2916 ,760), (0,90,0));
	spawncrate((291 ,-2916 ,760), (0,90,0));
	spawncrate((430 ,-2832 ,810), (0,90,0));
	spawncrate((291 ,-2832 ,810), (0,90,0));
	spawncrate((430 ,-2916 ,810), (0,90,0));
	spawncrate((291 ,-2916 ,810), (0,90,0));

	spawncrate((340 ,-2822 ,700), (0,90,0));
	spawncrate((380 ,-2822 ,700), (0,90,0));
	spawncrate((340 ,-2890 ,700), (0,90,0));
	spawncrate((380 ,-2890 ,700), (0,90,0));
	spawncrate((340 ,-2958 ,700), (0,90,0));
	spawncrate((380 ,-2958 ,700), (0,90,0));
		spawncrate((340 ,-3026 ,700), (0,90,0));
	spawncrate((380 ,-3026 ,700), (0,90,0));
	spawncrate((340 ,-3094 ,700), (0,90,0));
	spawncrate((380 ,-3094 ,700), (0,90,0));
	spawncrate((340 ,-3162 ,700), (0,90,0));
	spawncrate((380 ,-3162 ,700), (0,90,0));
	spawncrate((340 ,-3230 ,700), (0,90,0));
	spawncrate((380 ,-3230 ,700), (0,90,0));
	spawncrate((340 ,-3298 ,700), (0,90,0));
	spawncrate((380 ,-3298 ,700), (0,90,0));
	spawncrate((340 ,-3366 ,700), (0,90,0));
	spawncrate((380 ,-3366 ,700), (0,90,0));
	spawncrate((340 ,-3434 ,700), (0,90,0));
	spawncrate((380 ,-3434 ,700), (0,90,0));
	spawncrate((340 ,-3502 ,700), (0,90,0));
	spawncrate((380 ,-3502 ,700), (0,90,0));
	spawncrate((340 ,-3570 ,700), (0,90,0));
	spawncrate((380 ,-3570 ,700), (0,90,0));
	spawncrate((340 ,-3638 ,700), (0,90,0));
	spawncrate((380 ,-3638 ,700), (0,90,0));
	spawncrate((340 ,-3706 ,700), (0,90,0), "com_plasticcase_friendly");
	spawncrate((380 ,-3706 ,700), (0,90,0), "com_plasticcase_friendly");
	spawncrate((340 ,-3774 ,700), (0,90,0), "com_plasticcase_friendly");
	spawncrate((380 ,-3774 ,700), (0,90,0), "com_plasticcase_friendly");
	
	//archway
	spawncrate((324 ,-3732 ,700), (0,0,0));
	spawncrate((405 ,-3732 ,700), (0,0,0));
	
	spawncrate((419 ,-3769 ,760), (90,90,0), "com_plasticcase_friendly");
	spawncrate((310 ,-3769 ,760), (90,90,0), "com_plasticcase_friendly");
	spawncrate((364, -3769 ,814), (0, 0,0));
	spawncrate((340 ,-3842 ,700), (0,90,0));
	spawncrate((380 ,-3842 ,700), (0,90,0));
	spawncrate((340 ,-3910 ,700), (0,90,0));
	spawncrate((380 ,-3910 ,700), (0,90,0));
	spawncrate((340 ,-3978 ,700), (0,90,0));
	spawncrate((380 ,-3978 ,700), (0,90,0));
	spawncrate((340 ,-4046 ,700), (0,90,0));
	spawncrate((380 ,-4046 ,700), (0,90,0));
	spawncrate((340 ,-4114 ,700), (0,90,0));
	spawncrate((380 ,-4114 ,700), (0,90,0));
	spawncrate((340 ,-4182 ,700), (0,90,0), "com_plasticcase_friendly");
	spawncrate((380 ,-4182 ,700), (0,90,0), "com_plasticcase_friendly");
	spawncrate((340 ,-4250 ,700), (0,90,0));
	spawncrate((380 ,-4250 ,700), (0,90,0));
	spawncrate((340 ,-4330 ,700), (0,90,0));
	spawncrate((380 ,-4330 ,700), (0,90,0));
	spawncrate((340 ,-4400 ,700), (0,90,0));
	spawncrate((380 ,-4400 ,700), (0,90,0));
	spawncrate((340 ,-4470 ,700), (0,90,0));
	spawncrate((380 ,-4470 ,700), (0,90,0));
	spawncrate((340 ,-4540 ,700), (0,90,0));
	spawncrate((380 ,-4540 ,700), (0,90,0));
	spawncrate((340 ,-4680 ,700), (0,90,0));
	spawncrate((380 ,-4680 ,700), (0,90,0));
	spawncrate((340 ,-4750 ,700), (0,90,0));
	spawncrate((380 ,-4750 ,700), (0,90,0));
	spawncrate((340 ,-4820 ,700), (0,90,0));
	spawncrate((380 ,-4820 ,700), (0,90,0));
	spawncrate((340 ,-4890 ,700), (0,90,0));
	spawncrate((380 ,-4890 ,700), (0,90,0));
	spawncrate((340 ,-4960 ,700), (0,90,0));
	spawncrate((380 ,-4960 ,700), (0,90,0));
	spawncrate((340 ,-5030 ,700), (0,90,0));
	spawncrate((380 ,-5030 ,700), (0,90,0));
	spawncrate((340 ,-5080 ,700), (0,90,0));
	spawncrate((380 ,-5080 ,700), (0,90,0));

	createTP((105,-558,-1), (-3825, -4050, -510), (0, 70, 0));
	createTP((938,-1038,170), (-3825, -4050, -510), (0, 70, 0));
	createTP((8,423,124), (-3512, -4050, -490), (0, 100, 0));
	createTP((-185,-1898,120), (-3512, -4050, -490), (0, 100, 0));
	createTP((-1018,-211,127), (-3512, -4050, -490), (0, 100, 0));
	createHiddenTP((-3624.9, -681, -350.415),(362, -2810, 720), (0, 270, 0) , undefined);
	CreateDeathRegion((744, -6184, 650), (-255, -2181, 148));
	createHiddenTP((-3492, -3308, -558),(362, -2810, 720), (0, 270, 0) , undefined, undefined, undefined, undefined, 430); //lateflag
	spawnmodel((-3571, -3400, -514) , (25, -35, -75) , "aq_statue_female_01", 430); //lateflag

	//createHiddenTP((355, -5790, 777), (-848, -1798, 30), (20, 45, 0), "out", 1);
}
highrise_edit1(){
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-2831, 18727, 3357);
	mp_global_intermission.angles = (34.0785, 27.7426, 4);
	
	//block spot in crane
	spawncrate((-2631, 20956, 1915), (0, 90, 0));
	spawncrate((-2586, 20980, 1916), (0, 0, 0));

	//start of edit
	spawnmodel((-6765, 21814, -262) , (0, 0, 0) , "city_facade_large_g");
	spawnmodel((-3356, 18202, 579) , (0, 0, 0) , "city_facade_tier_e");
	spawnmodel((-411, 17996, 377) , (0, 0, 0) , "city_facade_tier");
	spawnmodel((-5806, 19957, 604) , (0, 0, 0) , "city_facade_empire_b");
	spawnmodel((-6664, 17079, 537) , (0, 0, 0) , "city_facade_empire_b");
	spawnmodel((-4174, 17800, 4578) , (10, -237.541, 0) , "vehicle_ac130_low");

	spawnmodel((2787, 22648, 640) , (0, -30, 0) , "com_tower_crane");
	spawnmodel((-1406, 20038, 1632) , (0, -90, 0) , "kriegler_highrise");

	// ontop of helipad survivors
	spawnmodel((-817, 20303, 2086) , (0, -90, 90) , "com_conference_table2");
	spawnmodel((-705, 19790, 2086) , (0, -90, 90) , "com_conference_table2");
	spawnmodel((-467, 19750, 2103) , (-80, 0, 0) , "me_market_umbrella_6");
	spawnmodel((-459, 19766, 2070) , (0, 0, 0) , "ma_sloped_back_chair_1");
	spawnmodel((-456, 19744, 2070) , (0, 0, 0) , "ma_restaurant_table");
	spawnmodel((-458, 19720, 2069) , (0, -180, 0) , "ma_sloped_back_chair_1");

	//ontop of helipad zombies
	createinviswalls((-2583, 20034, 2100),(-2583, 19812, 2100), (90,0,0)); // vending machines
	for(i=0;i<6;i++) {
		random = randomint(3);
		if(random == 0)
			spawnmodel((-2568, 20040 - 40*i, 2068) , (0, -90, 0) , "com_vending_can_new1");
		else if(random == 1)
			spawnmodel((-2568, 20040 - 40*i, 2068) , (0, -90, 0) , "com_vending_can_new1_lit");
		else
			spawnmodel((-2568, 20040 - 40*i, 2068) , (0, -90, 0) , "com_vending_can_new2");
	}

	for(i=0;i<4;i++)
		spawnmodel((-2523, 20320 - 204*i, 2031) , (0, 0, 0) , "highrise_fencetarp_03");


	//right side flank fallen tower
	spawnmodel((-2330, 19338, 1900) , (265, 0, 180) , "bc_military_comm_tower");
	spawnmodel((-1166, 19335, 1870) , (0, -90, 0) , "com_electrical_transformer_large_dam");
	spawnmodel((-2321, 19340, 1903) , (-45, 0, -90) , "ch_corkboard_metaltrim_4x8");
	spawncrate((-2295, 19340, 1912), (0, 90, -45));
	spawncrate((-2335, 19340, 1872), (0, 90, -45));
	CreateinvisRamps((-2265, 19340, 1920),(-1174, 19340, 2000));

	//left side flank cover zombie
	spawnmodel((-2205, 20733, 1870) , (0, 90, 0) , "machinery_trashcomp01_roof");
	spawnmodel((-2196, 20638, 1869) , (0, -270, 0) , "com_electrical_transformer_large_dam");
	//left side flank crane
	spawnmodel((-2268, 20775, 1862) , (-96, 60, 0) , "com_steel_ladder");
	spawncrate((-2242, 20822, 1855), (0, 60, 0));
	spawncrate((-2222, 20855, 1860), (0, 60, 0));
	spawncrate((-2200, 20891, 1865), (0, 60, 0));
	spawnmodel((-1748, 20955, 1880) , (0, -90, 0) , "machinery_crane02_platform");
	spawnmodel((-1753, 20955, 1678) , (0, -90, 0) , "machinery_crane02_cab");
	spawnmodel((-1753, 20955, 1231) , (0, 0, 0) , "machinery_crane02_scaffolding");
	spawnmodel((-1753, 20955, 783) , (0, 0, 0) , "machinery_crane02_scaffolding");
	spawnmodel((-1753, 20955, 335) , (0, 0, 0) , "machinery_crane02_scaffolding");

	//middle bridge
	spawnmodel((-1557, 20195, 1859) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-1557, 19995, 1859) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-2069, 20195, 1859) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-2069, 19995, 1859) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");

	spawnmodel((-1557, 20031, 1828) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-2069, 20031, 1828) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-1557, 20159, 1828) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");
	spawnmodel((-2069, 20159, 1828) , (0, 0, 0) , "oilrig_catwalk_ibeam_long");

	for(i=0;i<12;i++)
		spawnmodel((-1435 + -53*i, 20099, 1836) , (0, -90, 0) , "com_conference_table2");

	createinviswalls((-1407, 20481, 1965),(-1407, 20221, 1965));
	createinviswalls((-1407, 20481, 1890),(-1407, 20221, 1890));
	createinviswalls((-1407, 19976, 1965),(-1407, 19720, 1965));
	createinviswalls((-1407, 19976, 1890),(-1407, 19720, 1890));
	CreateDoors((-1407, 20098, 2000),(-1407, 20098, 1910) , (90,0,0) , 4 , 2 , 30 , 110 ,true);

	
	//decorative
	spawnmodel((-2934, 18601, 3456) , (0, 50, 0) , "vehicle_mi17_woodland_static");

	// future moving crane
	/*
	spawnmodel((-2799, 19495, 3479) , (0, -90, 0) , "machinery_crane02_platform");
	crane_org = (-945, 19522, 3083); 
	spawnmodel(crane_org , (0, 0, 0) , "machinery_crane02_hook");
	spawnmodel(crane_org + (0,0,-540) , (20, 45, 0) , "machinery_crane02_hook");
	spawnmodel(crane_org + (0,0,-540) , (20, 135, 0) , "machinery_crane02_hook");
	spawnmodel(crane_org + (0,0,-540) , (20, -45, 0) , "machinery_crane02_hook");
	spawnmodel(crane_org + (0,0,-540) , (20, -135, 0) , "machinery_crane02_hook");
	*/


	// door walls
	height=80;
	for(i=0;i<3;i++){
		spawnmodel((-1407, 20252 + 96*i , 1894) , (0, -90, 0) , "ch_corkboard_metaltrim_4x8");
		spawnmodel((-1407, 20252 + 96*i , 1894 + height) , (0, -90, 0) , "ch_corkboard_metaltrim_4x8");
	}
	for(i=0;i<3;i++){
		spawnmodel((-1407, 19947 + -96*i , 1894) , (0, -90, 0) , "ch_corkboard_metaltrim_4x8");
		spawnmodel((-1407, 19947 + -96*i , 1894 + height) , (0, -90, 0) , "ch_corkboard_metaltrim_4x8");
	}

	spawnmodel((-1408, 19995, 1934) , (90, 0, 0) , "com_pipe_4x128_gas");
	spawnmodel((-1408, 19707, 1934) , (90, 0, 0) , "com_pipe_4x128_gas");
	spawnmodel((-1408, 20204, 1934) , (90, 0, 0) , "com_pipe_4x128_gas");
	spawnmodel((-1408, 20492, 1934) , (90, 0, 0) , "com_pipe_4x128_gas");

	// crane flank human side
	spawnmodel((-998, 20723, 1872) , (0, 0, 0) , "ch_crate64x64");
	spawnmodel((-990, 20658, 1868) , (0, 0, 0) , "ch_crate48x64");
	spawncrate((-988, 20655, 1900), (0, 90, 0));
	spawncrate((-1000, 20710, 1880), (0, 0, 0));
	spawncrate((-1000, 20710, 1920), (0, 0, 0));
	spawncrate((-1000, 20737, 1880), (0, 0, 0));
	spawncrate((-1000, 20737, 1920), (0, 0, 0));
	spawnmodel((-818, 20741, 1864) , (-96, 90, 0) , "com_steel_ladder");
	spawncrate((-819, 20860, 1860), (0, 90, 0));
	spawncrate((-819, 20900, 1865), (0, 90, 0));

	//main bridge cover zombies
	spawnmodel((-2069, 20282, 1870) , (0, 0, 0) , "ch_crate64x64");
	spawnmodel((-2072, 20348, 1870) , (0, 0, 0) , "ch_crate64x64");
	spawnmodel((-2075, 20313, 1933) , (0, 0, 0) , "ch_crate48x64");
	spawnmodel((-2033, 19915, 1858) , (-90, 135, 0) , "com_propane_tank02");
	spawnmodel((-2111, 19837, 1858) , (-90, 135, 0) , "com_propane_tank02");
	spawnmodel((-2138, 19725, 1858) , (-90, 180, 0) , "com_propane_tank02");

	
	spawncrate((-1106, 19533, 1898), (0, 90, 0));
	spawnmodel((-1106, 19533, 1868) , (0, 0, 0) , "com_bomb_objective");
	spawncrate((-1106, 19615, 1898), (0, 90, 0));
	spawnmodel((-1106, 19615, 1868) , (0, 0, 0) , "com_bomb_objective");


	offset = -24;
	for(i=0;i<7;i++) {
		spawnmodel((-705, 20220 + offset * i, 1834) , (0, 90, 0) , "com_locker_double");
		spawnmodel((-705, 20220 + offset * (i-1), 1989) , (-180, 90, 0) , "com_locker_double");
	}
	createinviswalls((-710, 20100, 1895),(-710, 20228, 1895));
	createinviswalls((-710, 20100, 1945),(-710, 20228, 1945));
	
	CreateinvisQuicksteps((-1391, 19522, 1855), 220, 15, 1, (0,180,0));
	spawnmodel((-1408, 19523, 1861) , (0, 180, 0) , "com_steel_ladder_top");
	spawnmodel((-1408, 19523, 1861) , (0, -180, 0) , "com_steel_ladder");

	createinviswalls((-2025, 19980, 1900),(-2155, 19850, 1900)); // up facing tankers
	createinviswalls((-2025, 19980, 1980),(-2155, 19850, 1980)); // up facing tankers
	createinviswalls((-2170, 19820, 1900),(-2170, 19696, 1900));
	createinviswalls((-2170, 19820, 1980),(-2170, 19696, 1980));

	height =60;
	for(i=0;i<3;i++) {
		spawncrate((-1159, 19364, 1883 +height*i), (0, 0, 0));
		spawncrate((-1159, 19308, 1883 +height*i), (0, 0, 0));
	}

	createinviswalls((-2000, 20170, 1845),(-1435, 20170, 1845), (0,90,0)); // main bridge floor
	createinviswalls((-2000, 20100, 1845),(-1435, 20100, 1845), (0,90,0));
	createinviswalls((-2000, 20030, 1845),(-1435, 20030, 1845), (0,90,0));

	spacing_x = 68;
	spacing_y = 45;
	for(i=0;i<41;i++) {
		spawncrate((-2638 + spacing_x*i, 20932, 1870 ), (0, 0, 0));
		spawncrate((-2638 + spacing_x*i, 20932 + spacing_y, 1870 ), (0, 0, 0));
	}
	spawncrate((130, 20954, 1870), (0, 90, 0));

	spawncrate((-2205, 20605, 1915), (0, 0, 0));
	spawncrate((-2205, 20660, 1915), (0, 0, 0));
	spawncrate((-2175, 20640, 1915), (0, 90, 0));
	spawncrate((-2205, 20605, 1970), (0, 0, 0));
	spawncrate((-2205, 20660, 1970), (0, 0, 0));
	spawncrate((-2175, 20640, 1970), (0, 90, 0));

	
	spawncrate((-2210, 20675, 1950), (90, 90, 0));

	spawncrate((-2205, 20710, 1900), (0, 0, 0));
	spawncrate((-2205, 20755, 1900), (0, 0, 0));
	spawncrate((-2205, 20755, 1920), (90, 0, 0));


	spawncrate((-2070, 20360, 1880), (0, 0, 0));
	spawncrate((-2070, 20315, 1880), (0, 0, 0));
	spawncrate((-2070, 20270, 1880), (0, 0, 0));
	spawncrate((-2070, 20360, 1920), (0, 0, 0));
	spawncrate((-2070, 20315, 1920), (0, 0, 0));
	spawncrate((-2070, 20270, 1920), (0, 0, 0));


	spawncrate((-2075, 20312, 1967), (0, 90, 0));

	/*
	crate_orgs = [];
	crate_orgs[crate_orgs.size] = (0, 20330, 1870);
	crate_orgs[crate_orgs.size] = (0, 20395, 1870);
	crate_orgs[crate_orgs.size] = (36, 20264, 1870);
	crate_orgs[crate_orgs.size] = (-132, 19880, 1870);
	crate_orgs[crate_orgs.size] = (-142, 19815, 1870);
	crate_orgs[crate_orgs.size] = (-318, 19449, 1870);
	crate_orgs[crate_orgs.size] = (-351, 19384, 1870);
	crate_orgs[crate_orgs.size] = (-566, 20097, 2070);
	crate_orgs[crate_orgs.size] = (-522, 20032, 2070);

	for(i=0;i<crate_orgs.size;i++) {
		spawnmodel(crate_orgs[i], (0, 0, 0) , "ch_crate64x64");
		spawncrate(crate_orgs[i] + (0,15,20) , (0, 0, 0));
		spawncrate(crate_orgs[i] + (0,-15,20) , (0, 0, 0));
		spawncrate(crate_orgs[i] + (0,15,45) , (0, 0, 0));
		spawncrate(crate_orgs[i] + (0,-15,45) , (0, 0, 0));
	}*/

	spawnmodel((-2802, 18735, 3353) , (7, 116, 12) , "cs_coffeemug01");
	spawnmodel((-2803, 18728, 3356) , (0, 155, 8) , "com_teddy_bear");



	spawnmodel((-2921, 19742, 1882) , (0, -90, 90) , "com_conference_table2");
	spawnmodel((-2921, 19742, 1935) , (0, -90, 90) , "com_conference_table2");
	spawnmodel((-2921, 19742, 1988) , (0, -90, 90) , "com_conference_table2");
	spawnmodel((-2921, 19742, 2041) , (0, -90, 90) , "com_conference_table2");

	CreateinvisWalls((-3462, 20190, 1905),(-3462, 19970, 1905), (90,0,0)); // vending machines
	CreateinvisWalls((-3462, 20190, 1980),(-3462, 19970, 1980), (90,0,0)); // vending machines
	height = 74;
	for(i=0;i<6;i++) {
		random = randomint(3);
		if(random == 0)
			spawnmodel((-3480, 20160 - 40*i, 1870) , (0, 90, 0) , "com_vending_can_new1");
		else if(random == 1)
			spawnmodel((-3480, 20160 - 40*i, 1870) , (0, 90, 0) , "com_vending_can_new1_lit");
		else
			spawnmodel((-3480, 20160 - 40*i, 1870) , (0, 90, 0) , "com_vending_can_new2");

		random = randomint(3);
		if(random == 0)
			spawnmodel((-3480, 20160 - 40*i, 1870 + height) , (0, 90, 0) , "com_vending_can_new1");
		else if(random == 1)
			spawnmodel((-3480, 20160 - 40*i, 1870 + height) , (0, 90, 0) , "com_vending_can_new1_lit");
		else
			spawnmodel((-3480, 20160 - 40*i, 1870 + height) , (0, 90, 0) , "com_vending_can_new2");
	}

	cannonball((-2566, 20426, 2053), (0,0,0), 2, (89, 20953, 1945), 700);
	Deathradius((584, 19675, -2921), 4500, 4500);
	createTurret((-1403, 19769, 1920), (0,180,0), 65, 48, 20,15, 10);

	moveac130position((-1653, 20134, 4842));

	// block inmap
	spawncrate((19, 6844, 3070), (0, 0, 0));
	spawnmodel((20, 6836, 3020), (0, 0, 0), "ch_crate64x64");

	createTP((-3261, 5746, 2824), (-3578, 20076, 1870), undefined, true);
	createTP((-2269, 6060, 2776), (-3578, 20076, 1870), undefined, true);
	createTP((-1369, 5227, 2776), (-3578, 20076, 1870), undefined, true);
	createTP((263, 5333, 2824), (-3578, 20076, 1870), undefined, true);
	createTP((1266, 6631, 2824), (-3578, 20076, 1870), undefined, true);
	createTP((-1235, 7429, 2776), (-3578, 20076, 1870), undefined, true);
	createTP((-1279, 6310, 2776), (-3578, 20076, 1870), undefined, true);
	createTP((-2774, 6923, 2776), (-3578, 20076, 1870), undefined, true);

	classicents = GetEntArray("classicinf", "targetname");
	foreach(ent in classicents)
	ent delete();

}
highrise_edit2(){

	spawncrate((19, 6844, 3050), (0, 359, 0));
	spawnmodel((20, 6836, 3020), (0, 0, 0), "ch_crate64x64");
	classicents = GetEntArray("classicinf", "targetname");
	foreach(ent in classicents)
	ent delete();
	spawnmodel((-4600, 4150, 3813) , (0, 0, 0) , "com_propane_tank02");
	moveac130position((-4079, 2713, 5240));
	fufalldamage((-3374, 5217, 2380),220, 770);
	createTP((-3606, 5236, 3116), (-4704, 4142, 3770), (0, 0, 0),1,undefined);

	createTP((-3261, 5746, 2824), (-3575, 5206, 2390.13), (0,0,0));
	createTP((-2269, 6060, 2776), (-3575, 5206, 2390.13), (0,0,0));
	createTP((-1369, 5227, 2776), (-3575, 5206, 2390.13), (0,0,0));
	createTP((263, 5333, 2824), (-3575, 5206, 2390.13), (0,0,0));
	createTP((1266, 6631, 2824), (-3575, 5206, 2390.13), (0,0,0));
	createTP((-1235, 7429, 2776), (-3575, 5206, 2390.13), (0,0,0));
	createTP((-1279, 6310, 2776), (-3575, 5206, 2390.13), (0,0,0));
	createTP((-2774, 6923, 2776), (-3575, 5206, 2390.13), (0,0,0));

	//createHiddenTP((-3517, 1069, 3770), (-2795, 6942, -2810), (0,0,0), "out");
	cannonballInvis((-2687, 6947, -2841), (0,0,0), 0, (-2687, 6947, 2780), 900);
	CreateGrids((-2622, 7000, -2841),(-2783, 6895, -2841), (0,0,0));
	CreateRamps((-3216, 5302, 2378),(-3552, 5302, 2596));
	CreateRamps((-3552, 5139, 2620),(-3216, 5139, 2830));
	CreateGrids((-3589, 5312, 2610),(-3589, 5127, 2610), (0,0,0));

	CreateGrids((-3155, 5314, 3103),(-3155, 5129, 3103), (0,0,0));
	CreateGrids((-3210, 5236, 3103),(-3620, 5236, 3103), (0,0,0));
	CreateWalls((-3440, 2690, 3765),(-4470, 2690, 3765));
	CreateInvisWalls((-3127, 4454, 3820),(-3929, 4456, 3820));
	CreateGrids((-4780, 3820, 3873),(-4830, 3120, 3873), (0,-25,0));
	CreateGrids((-5130, 2150, 3873),(-5080, 3190, 3873), (0,0,0));
	CreateGrids((-4780, 1520, 3873),(-4830, 2220, 3873), (0,25,0));
	CreateQuicksteps((-3497, 1529, 3873), 132, 12, 2, (0,90,0));
	CreateQuicksteps((-4688, 1280, 3873), 132, 12, 2, (0,270,0));
	CreateQuicksteps((-3516, 4066, 3873), 132, 12, 2, (0,90,0));
	CreateQuicksteps((-3170, 5138, 3102), 272, 12, 1, (0,180,0));
	CreateGrids((-3530, 1710, 4050),(-4560, 1740, 4050), (0,0,0));
	CreateRamps((-3570, 1520, 3870),(-3570, 1680, 4026));
	CreateDoors((-4950, 2293, 3920) /*open*/,(-5105, 2293, 3920) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 160 /*range*/, 1 /*sideways*/);
	CreateDoors((-4428, 2663, 3770) /*open*/,(-4638, 2663, 3770) /*close*/, (90,90,0) /*angle*/, 6 /*size*/, 1 /*height*/, 40 /*hp*/, 110 /*range*/, 1 /*sideways*/);
	Deathradius((-4052, 2683, 2222), 2450, 200);
}
gulch_edit1(){
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (908, 1982, 596);
	mp_global_intermission.angles = (6, 1, 0);
	spawnmodel((1051, 2077, 535) , (-14, 65, 2) , "com_pan_copper");
	spawnmodel((1016, 2013, 528) , (10, -50, 5) , "com_pan_metal");
	spawnmodel((994, 1973, 524) , (14, -125, -5) , "com_pan_copper");
	//block wb
	spawnmodel((1372, 2305, 385) , (0, 30, 0) , "ch_hayroll_02");
	spawncrate((1369, 2308, 425), (0, 35, 0));
	spawnmodel((1430, 2347, 390) , (0, 115, 0) , "ch_hayroll_02");
	spawncrate((1430, 2347, 430) , (0, 115, 0));
	level.meat_playable_bounds = [
		(1264.99, 1067.38, 643.299),
		(675.464, 3285.13, 763.651),
		(129.151, 3841.46, 809.003),
		(1425.62, 4263.06, 816.994),
		(2317.39, 3084.71, 845.712),
		(2437.5, 2133.64, 859.242),
		(2138.72, 1536.59, 894.847),
		(2623.01, 704.074, 1105.24),
		(2439.23, 135.448, 1037.46),
		(2334.91, 131.832, 1037.46),
		(2042.31, -133.468, 1013.65),
		(1850.8, 151.694, 999.753),
		(1993.49, 833.232, 765.997)
	];
	createPolygon();
	createTP((1290, 1723, 166),(1633, 1402, 466));
	createTP((-488, 1640, 193),(1633, 1402, 466));
	createTP((-1719, 725, 160),(1633, 1402, 466));
	createTP((-560, -277, -39),(1633, 1402, 466));
	createTP((-13, -1754, 83),(1633, 1402, 466));
	createTP((309, 602, 206),(1633, 1402, 466));
	//createHiddenTP((2175, 1196, 1141),(83, -1268, 293), undefined, "out");

	CreateGrids((1590, 1670, 560),(1790, 1300, 560), (0,0,0));
	CreateWalls((1550, 1670, 548),(1550, 1300, 380));
	CreateWalls((1590, 1670, 520),(1590, 1670, 400));
	CreateWalls((1635, 1670, 520),(1830, 1670, 520));
	CreateWalls((1655, 1815, 430),(1745, 1815, 535));

	// creategrids((1460, 1086, 550),(1660, 1208, 550),(0,0,0));
	// CreateWalls((1495, 1225, 440),(1634, 1225, 550));

	CreateWalls((1797, 1184, 748),(1957, 961, 748),VectortoAngles((1797, 1184, 748)-(1957, 961, 748)));
	CreateWalls((1957, 961, 748),(2065, 869, 748),vectortoangles((1957, 961, 748)-(2065, 869, 748)));
	CreateWalls((2065, 869, 748),(2109, 751, 748),vectortoangles((2065, 869, 748)-(2109, 751, 748)));
	CreateWalls((2109, 751, 748),(2100, 525, 748),vectortoangles((2109, 751, 748)-(2100, 525, 748)));
	CreateWalls((1792, 1188, 748),(1802, 1334,748),vectortoangles((1792, 1188, 748)-(1802, 1334,748)));
	CreateWalls((1802, 1334, 748),(1899, 1550, 748),vectortoangles((1802, 1334, 748)-(1899, 1550, 748)));
	CreateWalls((1899, 1550, 748),(2029, 1803, 748),vectortoangles((1899, 1550, 748)-(2029, 1803, 748)));
	CreateWalls((2029, 1803, 748),(2069, 2060, 748),vectortoangles((2029, 1803, 748)-(2069, 2060, 748)));
	CreateWalls((2069, 2060, 715),(2051, 2393, 715),vectortoangles((2069, 2060, 715)-(2051, 2393, 715)));
	CreateWalls((2051, 2393, 715),(2010, 2680, 715),vectortoangles((2051, 2393, 715)-(2010, 2680, 715)));
	CreateWalls((1984, 2715, 715),(1722, 3144, 715),vectortoangles((1984, 2715, 715)-(1722, 3144, 715)));
	CreateWalls((1705, 3205, 715),(1505, 3430, 715),vectortoangles((1705, 3205, 715)-(1505, 3430, 715)));
	CreateWalls((1478, 3457, 715),(1134, 3540, 715),vectortoangles((1478, 3457, 715)-(1134, 3540, 715)));
	CreateRamps((1101, 3538, 712),(721, 3295, 712));
	CreateRamps((945, 3393, 700),(1342, 2759, 360));
	CreateGrids((1990, 2075, 582),(1890, 2380, 582), (0,0,0));
	CreateWalls((2034, -126, 770),(1865, 140, 770));
	CreateWalls((2034, -126, 830),(1865, 140, 830));
	CreateWalls((2034, -126, 890),(1865, 140, 890));
	CreateWalls((2034, -126, 950),(1865, 140, 950));
	CreateWalls((2339, 111, 890),(2064, -139, 890));
	CreateWalls((2339, 111, 950),(2064, -139, 950));
	CreateWalls((2339, 111, 1010),(2064, -139, 1010));
	CreateGrids((1664, 2820, 520),(1735, 3000, 520), (0,20,0));
	CreateWalls((1650, 2820, 380),(1620, 2915, 510));
	CreateWalls((1300, 2975, 380),(1400, 2975, 480));

	CreateGrids((1970, 181, 763),(1920, 21, 763), (0,33,0));
	CreateRamps((2088, 492, 763),(1910, 167, 763));
	CreateWalls((1550, 1840, 410),(1550, 2115, 500));
	CreateRamps((2031, -29, 847),(1961, 76, 760));
	CreateWalls((1180, 3560, 740),(1280, 3560, 840));
	CreateWalls((1880, 3130, 740),(1980, 3130, 840));
	CreateWalls((2370, 2260, 760),(2270, 2260, 860));
	CreateDeathRegion((2109, -448, 765.03),(1416, 1051, 428.91));
	spawncrate((2397, 301, 975), (-19, 60, 0), "com_plasticcase_friendly");
	CreateRamps((2430, 351, 990),(2430, 713, 1094));
	spawncrate((2450, 760, 1102), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((2420, 760, 1102), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((2450, 820, 1102), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((2420, 820, 1102), (0, 90, 0), "com_plasticcase_friendly");
	spawncrate((2475, 460, 990), (0, 90, 0));
	spawncrate((2475, 520, 1000), (0, 90, 0));
	spawncrate((2475, 582, 1020), (0, 90, 0));
	spawncrate((2475, 654, 1060), (0, 90, 0));
	spawncrate((2475, 710, 1090), (0, 90, 0));
	CreateWalls((2180, 1250, 1140),(2100, 1250, 1220));// high blocker
	moveac130position((1800, 2058, 1933.74));
}
decommision_edit1(){
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1819, 152, 1312);
	mp_global_intermission.angles = (5, -73, 12);
	level.meat_playable_bounds = [
	(2632.75, -2146.07, 1268.43),
	(4783.71, -3447.72, 1268.43),
	(5037.53, -4409.28, 1267.72),
	(4677.44, -5755.09, 1263.24),
	(3985.08, -5572.77, 1217.49),
	(3309.64, -4864.53, 937.125),
	(3308.06, -3689.4, 937.125),
	(2867, -3349, 725.4),
	(2206.87, -2909.46, 877.391)
	];
	createPolygon();
	CreateDeathRegion((3987, -5644, 592),(3038, -1694, 419));
	spawncrate((-144, 334, 710), (90, -45, 0), "com_plasticcase_friendly"); // normal oom blocker
	spawncrate((4216, -3554, 850) , (90, 11, 0));  // rock stuck fix
	createTP((2289, -2416, 637),(2567, -3047, 672), (0, 55, 0));
	createTP((860, -2307, 731),(2567, -3047, 672), (0, 55, 0));
	createTP((-266, -1456, 674),(2567, -3047, 672), (0, 55, 0));
	createTP((1169, -696, 654),(2567, -3047, 672), (0, 55, 0));
	createTP((1265, -1765, 707),(2567, -3047, 672), (0, 55, 0));
	//createHiddenTP((4426, -5648, 1141), (1345, -2383, 864), (0, 150, 0), "out");
	CreateGrids((2280, -2840, 783),(2280, -2980, 783), (0,-30,0));
	CreateWalls((4120, -3255, 730),(4260, -3255, 850));
	CreateWalls((3540, -3380, 720),(3440, -3380, 820));
	CreateWalls((3760, -3380, 720),(3705, -3380, 820));
	CreateDoors((3625, -3380, 820) /*open*/,(3625, -3380, 740) /*close*/, (90,90,0) /*angle*/, 2 /*size*/, 2 /*height*/, 40 /*hp*/, 70 /*range*/, true /*sideways*/);
	CreateWalls((3305, -3710, 790),(3305, -3880, 790));
	CreateWalls((3305, -3710, 850),(3305, -4860, 850));
	CreateWalls((3305, -3710, 910),(3305, -4860, 910));
	CreateWalls((3305, -4860, 850),(3985, -5540, 850));
	CreateWalls((3305, -4860, 910),(3985, -5540, 910));
	CreateWalls((3990, -5377, 890),(3965, -5495, 890));
	CreateWalls((4200, -3985, 850),(4200, -3815, 850));
	CreateWalls((4480, -4720, 840),(4420, -4720, 950));
	CreateDoors((4360, -4720, 1000) /*open*/,(4360, -4720, 880) /*close*/, (90,90,0) /*angle*/, 1 /*size*/, 2 /*height*/, 30 /*hp*/, 50 /*range*/, true /*sideways*/);
	spawncrate((4435, -4755, 850), (0, 0, 30), "com_plasticcase_friendly");
	CreateRamps((4370, -4675, 825),(4320, -5100, 1070));
	spawncrate((4300, -5137, 1083.5), (0, 80, 0), "com_plasticcase_friendly");
	spawncrate((4490, -5320, 1126), (0, -14, 0), "com_plasticcase_friendly");
	spawncrate((4040, -5200, 1110), (0, -14, -30), "com_plasticcase_friendly");
	CreateRamps((4030, -4615, 1076),(4030, -4550, 1068));
	CreateRamps((4330, -4740, 1085),(4470, -4740, 1120));
	CreateRamps((4150, -3803, 965),(4150, -3979, 1048));
	CreateGrids((4235, -3750, 951),(3985, -3250, 951), (0,20,0));
	moveac130position((4279, -3765, 966.125));
}
scrapyard_edit1(){
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "machinery_oxygen_tank02" || ent.model == "me_electricbox4" || ent.model == "foliage_tree_oak_1_animated2" || ent.model == "me_lightfluohang_on" || ent.model == "machinery_oxygen_tank01") {
			// iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}
	}
	level.meat_playable_bounds = [
		(-1780, 1682, 58),
		(-160, 1700, -59),
		(-153, 2711, -56),
		(-2745, 2711, -64),
		(-2762, 764, 111),
		(-2705, 641, 112),
		(-1769, 638, 98)
	];
	createPolygon();
	
	 //new
	spawnmodel((-875, 1891, -59) , (1, 0, -2) , "cargocontainer_20ft_red");
	spawnmodel((-1316, 1962, 31) , (131, -37, 44) , "727_wing_flaps_long_left");
	
	spawnmodel((-2184, 773, 1398) , (0, 330, 0) , "stopsign_01");
	spawnmodel((-1891, 1722, 50) , (-5, 70, 0) , "727_wing_flaps_long_left");
	spawnmodel((-2560, 1048, -17) , (119, -54, -49) , "727_wing_flaps_long_right");
	spawnmodel((-2022, 2072, -77) , (120, 52, 45) , "727_wing_flaps_long_left");
	spawnmodel((-2649, 1346, 29) , (0, 0, -90) , "727_platform_base");
	spawnmodel((-2642, 1340, -86) , (0, 0, -90) , "727_platform_base");
	spawnmodel((-2597, 2110, -63) , (0, 26, 0) , "cargocontainer_20ft_white");
	CreateGrids((-2163, 539, 1412),(-2223, 589, 1412), (0,-20,0));
	CreateWalls((-2145, 545, 1430),(-2145, 545, 1513), (0,252,90));
	spawnmodel((-939, 2528, -69) , (62, 130, 100) , "727_wing_flaps_long_right");//NEW
	
	//wallbreach fix
	CreateInvisWalls((-2063, 2553, -30),(-2280, 2566, -30)); 
	CreateInvisWalls((-2298, 2561, -30),(-2190, 2286, -30)); 
	CreateInvisWalls((-2174, 2282, -30),(-2052, 2295, -30)); 
	CreateInvisWalls((-2280, 1821, -58),(-2505, 1833, -58)); 
	CreateInvisWalls((-2513, 1829, -58),(-2552, 1558, -58)); 
	CreateInvisWalls((-2532, 1561, -58),(-2227, 1666, -58)); 
	CreateInvisWalls((-2234, 1670, -58),(-2276, 1819, -58)); 
	CreateInvisWalls((-2280, 1821, 0),(-2505, 1833, 0)); 
	CreateInvisWalls((-2513, 1829, 0),(-2552, 1558, 0)); 
	CreateInvisWalls((-2532, 1561, 0),(-2227, 1666, 0)); 
	CreateInvisWalls((-2234, 1670, 0),(-2276, 1819, 0)); 
	spawncrate((-2479 ,1635 ,12), (0,15,0));
	spawncrate((-2398 ,1662 ,12), (0,15,0));
	spawncrate((-2337 ,1688 ,12), (0,105,0));
	spawncrate((-2288 ,1707 ,12), (0,105,0));
	spawncrate((-2323 ,1751 ,12), (0,15,0));
	spawncrate((-2405 ,1721 ,12), (0,15,0));
	spawncrate((-2473 ,1688 ,12), (0,15,0));
	spawncrate((-2342 ,1795 ,12), (0,15,0));
	spawncrate((-2418 ,1792 ,12), (0,356,0));
	spawncrate((-2446 ,1792 ,12), (0,356,0));
	spawncrate((-2473 ,1755 ,12), (0,83,0));
	spawncrate((-2413 ,1753 ,12), (0,15,0));
	spawncrate((-2080 ,2351 ,-18), (0,0,0));
	spawncrate((-2147 ,2338 ,-18), (0,0,0));
	spawncrate((-2090 ,2401 ,-18), (0,0,0));
	spawncrate((-2157 ,2388 ,-18), (0,0,0));
	spawncrate((-2090 ,2451 ,18), (0,0,0));
	spawncrate((-2090 ,2511 ,18), (0,0,0));
	spawncrate((-2175 ,2451 ,18), (0,0,0));
	spawncrate((-2175 ,2511 ,18), (0,0,0));
	spawncrate((-2202 ,2419 ,-18), (0,104,0));
	spawncrate((-2227 ,2498 ,-18), (0,104,0));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-367, -505, -90);
	mp_global_intermission.angles = (-12, 90, 0);
	spawnmodel((-368, -470, -84) , (4, -90, 0) , "com_teddy_bear_sitting");
	spawnmodel((-368, -467, -104) , (10, -90, 0) , "com_folding_chair");
	spawnmodel((-1720, 730, 120) , (0, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1710, 730, 195) , (-22, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1720, 490, 120) , (0, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1710, 490, 195) , (-22, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1720, 250, 120) , (0, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1710, 250, 195) , (-22, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1720, 10, 120) , (0, 0, 0) , "cargocontainer_20ft_red");
	spawnmodel((-1710, 10, 195) , (-22, 0, 0) , "cargocontainer_20ft_red");
	spawncrate((-1770, 95, 170), (0, 90, 90), "com_plasticcase_friendly");
	spawncrate((-1592, 784, 130), (0, 0, 0), "com_plasticcase_friendly");
	createTP((76, 1449, -71),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((973, 1244, -84),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((1896, 428, -151),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((946, -469, -139),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((-746, -144, -139),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((-311, 930, -135),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createTP((692, 400, -123),(-389, 2458, -63), ( 0 , -139 , 0 ));
	createHiddenTP((-1835, 718, 113),(-2882, 895, 1370), undefined, "out");
	createTP((-2155, 723, 1428),(-2685, 834, -70), undefined);
	//createHiddenTP((-374, -19, 1561),(-1300, -103, 143), undefined, "out");
	CreateGrids((-2130, 690, 1412),(-2190, 740, 1412), (0,-20,0));
	CreateGrids((-1800, 750, 97),(-2650, 678, 97), (0,0,0));
	CreateWalls((-1790, 775, 110),(-2530, 775, 110));

	spawnmodel((-1771, 924, 56) , (-5, -90, 0) , "ch_corkboard_woodtrim_4x8");
	
	spawnmodel((-2544, 1041, -80) , (0, -90, -90) , "727_platform_base");
	spawnmodel((-2536, 846, -35) , (-145, -95, -90) , "727_platform_base");

	CreateInvisWalls((-2745, 1320, -70),(-2555, 1320, -70));
	CreateInvisWalls((-2745, 1320, -10),(-2555, 1320, -10));
	CreateInvisWalls((-2745, 1320, 50),(-2555, 1320, 50));
	
	CreateDoors((-2555, 1230, 40) /*open*/,(-2555, 1230, -50) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 3 /*height*/, 25 /*hp*/, 65 /*range*/, true /*sideways*/);
	CreateInvisWalls((-2555, 1150, -70),(-2555, 780, -70));
	CreateInvisWalls((-2555, 1150, -10),(-2555, 780, -10));
	CreateInvisWalls((-2555, 1150, 50),(-2555, 780, 50));
	CreateRamps((-2600, 1106, -90),(-2600, 783, 85));
	CreateWalls((-1800, 1660, -90),(-2010, 1660, -90));
	CreateWalls((-1800, 1660, -20),(-2010, 1660, -20));
	CreateDoors((-2010, 1760, 40) /*open*/,(-2010, 1760, -50) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 60 /*range*/, true /*sideways*/);
	CreateWalls((-2010, 1857, -70),(-2034, 2702, -70));
	CreateWalls((-2010, 1857, -10),(-2034, 2702, -10));
	createTurret((-1979, 774, 140), (0, 90, 0), 45, 65, undefined,undefined, 10);
	CreateDeathRegion((-4084, -1552, 1314.59),(746, 2943, 718.328));
	CreateDeathRegion((-1779, 746, -188.015),(-3125, -689, 34.372));
	moveac130position((-2044, 2022, 185.666));
}
vacant_edit1(){
	level.meat_playable_bounds = [
	(-3994.97, -6303.94, 108.125),
	(-4870.69, -6302.4, 128.125),
	(-4870.04, -6161.9, 6.92505),
	(-5700.91, -6167.37, 92.125),
	(-5700.91, -5833.89, 92.125),
	(-6005.28, -5833.92, 174.679),
	(-6013.92, -5447.32, 180.125),
	(-7804.95, -5447.47, 180.125),
	(-7804.98, -5907.88, 180.125),
	(-6426.84, -5907.79, 180.125),
	(-6420.47, -7709.15, 372.125),
	(-5772.8, -7706.87, 372.125),
	(-5760.88, -7098.67, 92.125),
	(-4260.36, -7100.22, 92.125),
	(-3716.32, -7952.63, 174.425),
	(-3404.26, -7634.42, 174.425)
	];
	createPolygon();
	
	//TP Flags
	createTP((-797, -285, -48),(-5666, -7004, -91.875), (0,90,0));
	createTP((952, 570, -48),(-5666, -7004, -91.875), (0,90,0));
	createTP((-14, -79, -48),(-5666, -7004, -91.875), (0,90,0));
	createTP((-781, -1358, -103),(-5666, -7004, -91.875), (0,90,0));
	createTP((1604, -910, -48),(-5666, -7004, -91.875), (0,90,0));
	createTP((-1629, 967, -94),(-5666, -7004, -91.875), (0,90,0));
	createTP((-118, 967, -54),(-5666, -7004, -91.875), (0,90,0));
	CreateDeathRegion((-4265, -5585, -140),(-2775, -8710, 80));
	moveac130position((-5300, -6700, 1000));
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-4576, -6600, 105);
	mp_global_intermission.angles = (4, -140, 0);
	//1st TP Wall
	orig=(-5540, -7029, -60); height=96; spacing=95;
	for(i=0;i<8;i++){
	spawnmodel(orig+(0,spacing*i,0) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel(orig+(0,spacing*i,height) , (0, -90, 0) , "me_corrugated_metal8x8");
	}
	orig=(-5533, -7010, -70); height=80; spacing=60;
	for(i=0;i<12;i++){
		spawncrate(orig + (0, spacing* i, 0), (90, 0, 0));
		spawncrate(orig + (0, spacing* i, height), (90, 0, 0));
	}
	//Wall Next To Door
	orig=(-5318, -6319, -70); height=96; spacing=-95;
	for(i=0;i<3;i++){
		spawnmodel(orig + (spacing* i, 0, 0), (0, 0, 0),"me_corrugated_metal8x8");
		spawnmodel(orig + (spacing* i, 0, height), (0, 0, 0),"me_corrugated_metal8x8");
	}
	orig=(-5324, -6325, -70); height=50; spacing=-78;
	for(i=0;i<3;i++){
		spawncrate(orig + (spacing* i, 0, 0), (0, 0, 0));
		spawncrate(orig + (spacing* i, 0, height), (0, 0, 0));
	}
	//Stack Box Cover
	spawnmodel((-5572, -6351, -77) , (0, 0, -90) , "ch_crate48x64");
	spawnmodel((-5572, -6351, -13) , (0, 0, -90) , "ch_crate48x64");
	spawncrate((-5572, -6327, -60), (-90, -90, 0));
	spawncrate((-5572, -6327, -80), (-90, -90, 0));
	//1st Door
	CreateDoors((-5400, -6319, -40) /*open*/,(-5162, -6319, -40) /*close*/, (90,90,0) /*angle*/, 7 /*size*/, 1 /*height*/, 20 /*hp*/, 110 /*range*/);
	//End Of Walk Way Ents
	spawnmodel((-4844, -6238, -128) , (0, -123, -95) , "ch_railing_long");
	spawnmodel((-4825, -6198, -130) , (0, -60, -90) , "ch_sign_stopsign");
	//1st ele
	CreateElevator((-5088, -6653, -106),(-5483, -6653, -106), 215, 1.25);
	//Hide Caulk After ele
	spawnmodel((-5044, -6641, 101) , (90, 90, 0) , "me_corrugated_metal4x8");
	spawnmodel((-5044, -6511, 101) , (90, 90, 0) , "me_corrugated_metal4x8");
	spawnmodel((-5044, -6415, 101) , (90, 90, 0) , "me_corrugated_metal4x8");
	spawnmodel((-5044, -6575, 101) , (90, -90, 0) , "me_corrugated_metal4x4_holes");
	//Tanker Cover
	spawnmodel((-5392, -7737, -1415) , (0, 145, 0) , "com_tower_crane");
	spawnmodel((-4682, -6732, 140) , (0, -90, 0) , "com_propane_tank02");
	spawnmodel((-4625, -6815, 84) , (0, -90, 0) , "ch_mattress_boxspring");
	spawnmodel((-4625, -6626, 84) , (0, -90, 0) , "ch_mattress_boxspring");
	spawnmodel((-4625, -6720, 84) , (0, -90, 0) , "ch_mattress_boxspring");
	spawnmodel((-4615, -6598, 84) , (0, 0, 0) , "machinery_generator");
	spawnmodel((-4604, -6659, 86) , (0, 0, 0) , "ch_mattress_2");
	spawnmodel((-4563, -6799, 87) , (-6, 197, -81) , "com_bike_dlc");
	spawnmodel((-4606, -6689, 97) , (0, 0, -90) , "furniture_blowupdoll01");
	spawnmodel((-4605, -6631, 102) , (-90, -90, 0) , "sunglasses01");
	spawnmodel((-4607, -6690, 89) , (0, -180, 60) , "furniture_blowupdoll01");
	spawnmodel((-4607, -6637, 114) , (-306, -267, 0) , "sunglasses01");
	spawnmodel((-4591, -6636, 94) , (0, -65, 90) , "weapon_desert_eagle_iw5");
	//cannonball To Top Roof
	cannonball((-4664, -7026, 70), (0,0,0), 3, (-5917, -7042, 432.125), 900);
	//Tanker Cover coll
	spawncrate((-4688, -6593, 130) , (90, 0, 0));
	spawncrate((-4683, -6878, 130) , (90, 0, 0));
	orig=(-4643, -6878, 130); height=0; spacing=57;
	for(i=0;i<6;i++){
		spawncrate(orig + (0, spacing* i, 0), (90, 0, 0));
		spawncrate(orig + (0, spacing* i, height), (90, 0, 0));
	}
	orig=(-4728, -6878, 130); height=0; spacing=57;
	for(i=0;i<6;i++){
		spawncrate(orig + (0, spacing* i, 0), (90, 0, 0));
		spawncrate(orig + (0, spacing* i, height), (90, 0, 0));
	}
	orig=(-4688, -6878, 175); height=0; spacing=57;
	for(i=0;i<6;i++){
		spawncrate(orig + (0, spacing* i, 0), (0, 0, 0));
		spawncrate(orig + (0, spacing* i, height), (0, 0, 0));
	}
	//End Walkway Bridge
	CreateinvisGrids((-4220, -6965, 77),(-4220, -6715, 77), (0,0,0));
	spawnmodel((-4204, -6921, 93) , (0, -90, 90) , "ch_mattress_boxspring");
	spawnmodel((-4204, -6826, 93) , (0, -90, 90) , "ch_mattress_boxspring");
	spawnmodel((-4195, -6933, 94) , (0, 13, -90) , "me_corrugated_metal2x8_holes");
	spawnmodel((-4242, -6735, 93) , (0, 13, -90) , "me_corrugated_metal2x8_holes");
	spawnmodel((-4257, -6757, 91) , (0, 13, -90) , "me_corrugated_metal2x8_holes");
	//End Walkway Wall
	CreateInvisWalls((-3400, -7650, 120),(-3700, -7950, 175));
	spawnmodel((-3468, -7804, 89) , (0, 55, 0) , "vehicle_mack_truck_short_destroy");
	spawnmodel((-3533, -7755, 126) , (-1, 45, 108) , "vehicle_80s_sedan1_red_destroyed");
	spawnmodel((-2760, -6887, -1405) , (0, 321, 0) , "com_tower_crane");
	spawncrate((-3634, -7864, 164) , (-90, -68.0991, 0));
	//Lower Roof Cover
	spawnmodel((-5751, -6844, 162) , (0, -90, 0) , "com_conference_table1");
	spawnmodel((-5752, -6843, 196) , (180, -90, 0) , "com_conference_table1");
	CreateinvisGrids((-5756, -6948, 177),(-5752, -6741, 177), (0,0,0));
	//Lower Roof Walkway
	CreateinvisGrids((-5740, -6310, 77),(-5740, -5860, 77), (0,0,0));
	spawnmodel((-5776, -6250, 66) , (90, 0, 0) , "me_dumpster_close");
	spawnmodel((-5776, -6154, 66) , (90, 0, 0) , "me_dumpster_close");
	spawnmodel((-5776, -6058, 66) , (90, 0, 0) , "me_dumpster_close");
	spawnmodel((-5776, -5962, 66) , (90, 0, 0) , "me_dumpster_close");
	spawnmodel((-5776, -5866, 66) , (90, 0, 0) , "me_dumpster_close");
	spawncrate((-5741, -5833, 77) , (0, -180, 0));
	CreateinvisRamps((-5780, -5875, 77),(-5995, -5875, 154)); //Next Ramp UP
	spawnmodel((-5878, -5887, 139) , (180, -90, 20) , "com_industrialtrashbin");
	spawnmodel((-6006, -5892, 172) , (0, -90, 75) , "ch_corkboard_woodtrim_4x8");
	//Hide Caulk Below ele 
	orig=(-6102, -5928, 180); height=0; spacing=-71;
	for(i=0;i<5;i++){
		spawnmodel(orig + (spacing* i, 0, 0), (0, 90, 90),"com_locker_double_destroyed");
		spawnmodel(orig + (spacing* i, 0, height), (0, 90, 90),"com_locker_double_destroyed");
	}
	//2nd ele
	CreateElevator((-6119, -5905, 166),(-6293, -5905, 166), 191, 1.25);
	//Top Roof Cover
	spawnmodel((-6319, -6349, 368) , (0, 20, 0) , "concrete_barrier_damaged_2");
	spawncrate((-6222, -6810, 387) , (0, -180, 0));
	spawnmodel((-5902, -6653, 371) , (0, -25, 0) , "concrete_barrier_damaged_2");
	spawncrate((-5919, -6057, 387) , (0, -160, 0));
	spawnmodel((-6218, -6810, 371) , (0, 0, 0) , "concrete_barrier_damaged_2");
	spawncrate((-6321, -6350, 387) , (0, -160, 0));
	spawnmodel((-5919, -6057, 372) , (0, 20, 0) , "concrete_barrier_damaged_2");
	spawncrate((-5902, -6653, 387) , (0, -206, 0));
	spawnmodel((-6380, -7669, 371) , (0, 50, 0) , "ch_furniture_couch01");
	spawncrate((-6370, -7675, 377) , (0, -40, 0));
	spawncrate((-6388, -7661, 377) , (0, -40, 0));
	spawnmodel((-5872, -7034, 376) , (0, -90, 90) , "ch_mattress_boxspring");
	//In Edit TP
	createHiddenTP((-6100, -7749, 373), (-5477, -7010, -92), ((4, 67, 0)), undefined, undefined, undefined, undefined, undefined);
	//Exit Flag
	//createHiddenTP((-7340, -5683, 180),(1292, -940, 48), undefined , "out");
	//Out Of Edit Buildings
	spawnmodel((-8159, -8144, 181) , (0, 0, 0) , "ch_apartment_5story_noentry_01");
	spawnmodel((-5107, -4726, 432) , (0, 0, 0) , "ch_apartment_9story_noentry_02");
	spawnmodel((-1737, -5745, 182) , (0, 0, 0) , "ch_apartment_5story_noentry_01");
	spawnmodel((-7676, -4315, 452) , (0, 0, 0) , "ch_apartment_9story_noentry_02");
	spawnmodel((-9720, -6015, 180) , (0, -90, 0) , "ch_apartment_5story_noentry_01");
	spawnmodel((-6499, -3034, 191) , (0, -90, 0) , "ch_apartment_5story_noentry_01");
	spawnmodel((-6450, -9871, 482) , (0, 0, 0) , "ch_apartment_9story_noentry_02");
	spawnmodel((-4010, -11078, 199) , (0, 0, 0) , "ch_apartment_5story_noentry_01");
}
vacant_edit2(){
	level.meat_playable_bounds = [
		(1975, -3697, 523.751),
		(1947, -7545, 561.909),
		(4368, -7491, 578.856),
		(4685, -2418, 505.52),
		(4310, -1903, 505.52),
		(3652, -1904, 505.52)
	];
	createPolygon();
	
    ents = GetEntArray();	   
		foreach(ent in ents) {
		if(ent.model == "foliage_tree_river_birch_xl_a_animated" || ent.model == "me_electricbox4" || ent.model == "machinery_generator" || ent.model == "com_locker_double" || ent.model == "com_filecabinetblackclosed" || ent.model == "machinery_oxygen_tank01" || ent.model == "machinery_oxygen_tank02") {
	//iprintln(ent.model);
	//logprint(ent.model + "\n");
	ent delete();
		}
	}
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (1597, -6140, 710);
	mp_global_intermission.angles = (4, 10, 0);
	
	spawnmodel((4225, -2265, -367) , (0, 180, 0) , "ch_apartment_9story_noentry_02");
	
	for(i = 0;i < 21;i++)
	spawnmodel((3817, -2364, 352)+ (0,-71* i,0) , (0, 0, -90) , "me_refrigerator");
	
	
	createTP((-797, -285, -48),(4620, -2412, 372.125), (0,180,0), true);
	createTP((952, 570, -48),(4620, -2412, 372.125), (0,180,0), true);
	createTP((-14, -79, -48),(4620, -2412, 372.125), (0,180,0), true);
	createTP((-781, -1358, -103),(4620, -2412, 372.125), (0,180,0), true);
	createTP((1604, -910, -48),(4620, -2412, 372.125), (0,180,0), true);
	createTP((-1629, 967, -94),(4620, -2412, 372.125), (0,180,0), true);
	createTP((-118, 967, -54),(4620, -2412, 372.125), (0,180,0), true);
	
	spawnmodel((4075, -2408, 372) , (-1, 70, 0) , "me_dumpster_close");
	 
	CreateInvisGrids((4300, -2450, 357),(4620, -2306, 357), (0,0,0));//spawn
	CreateInvisGrids((4297, -2270, 357),(4491, -1897, 357), (0,0,0));//spawn
	for(i = 0;i < 3;i++)
	spawncrate((4232, -1897, 357)+ (0,-30* i,0) , (0, 180, 0));
	for(i = 0;i < 2;i++)
	spawncrate((4665, -2458, 429)+ (0,60* i,0) , (90, 90, 0));
	for(i = 0;i < 7;i++)
	spawncrate((4618, -2507, 430)+ (-60* i,0,0), (90, 180, 0));
	for(i = 0;i < 6;i++)
	spawncrate((4258, -2512, 429)+ (0,-54* i,0), (90, 90, 0));
	
	CreateDeathRegion((4243.8, -2791, 455),(4674, -2491, 550));
	
	CreateWalls((3880, -3120, 380),(3990, -3120, 485));
	CreateWalls((4250, -4000, 380),(4185, -4000, 485));
	CreateWalls((3488, -4043, 380),(3655, -4233, 485));
	CreateWalls((4177, -4923, 380),(4173, -5124, 485));
	CreateWalls((2747, -4160, 380),(3058, -4161, 485));
	CreateGrids((2660, -5210, 605),(2660, -5300, 605), (0,0,0)); // for ramp
	CreateRamps((2660, -5700, 355),(2660, -5330, 592)); // ramp
	CreateGrids((2320, -6895, 605),(2320, -7036, 605), (0,0,0)); // for 2nd ramp
	CreateRamps((2320, -6370, 355),(2320, -6860, 592)); // ramp 2
	CreateGrids((2923, -5732, 605),(3065, -6145, 605), (0,0,0));
	CreateGrids((3380, -5180, 500),(3755, -5130, 500), (0,0,0));
	CreateGrids((3400, -6145, 500),(3235, -6095, 500), (0,0,0));
	CreateWalls((3900, -5705, 380),(4230, -5705, 380));
	CreateWalls((2660, -5207, 380),(2250, -5207, 380));
	CreateWalls((3900, -5705, 440),(4230, -5705, 440));
	CreateWalls((2660, -5207, 440),(2250, -5207, 440));
	CreateWalls((3900, -5705, 500),(4230, -5705, 500));
	CreateWalls((2660, -5207, 500),(2250, -5207, 500));
	CreateGrids((3790, -2320, 357),(3730, -2220, 357), (0,0,0)); // cannon
	cannonball((3759, -2270, 362), (0,0,0), 2, (2980, -4018, 440.135), 400);
	CreateDoors((3695, -5705, 392.125) /*open*/,(3828, -5705, 392.125) /*close*/, (90,90,0) /*angle*/, 2 /*size*/, 3 /*height*/, 30 /*hp*/, 75 /*range*/, true);
	CreateDeathRegion((630, -1030, -400.875),(6333, -9129, 301.355));
	moveac130position((3480, -4706, 372.125));
}

lockout_h2_edit1(){
	level.use_stock_helicopter_system = true;
	level.use_stock_predator_system = true;
	mantles = getentarray( "mantle", "targetname" );
	mantlecoll = mantles[0];
	
	level.ac130.angles = (45,0,0);
	createTP((3751.86, 3842.73, 2640),(3414.31, 4500.98, 3652), (0,270,0), 1, undefined, undefined,480);
	createTP((2825.86, 3305, 2865),(3414.31, 4500.98, 3652), (0,270,0), 1, 400, 500,480);
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	random = randomint(3);
		if(random == 0)
			mp_global_intermission.origin = (4411,2222, 3591.8);
		else if(random == 1)
			mp_global_intermission.origin = (4688, 3840, 3115);
		else
			mp_global_intermission.origin = (3563, 2772, 3350);
		if(random == 0)
			mp_global_intermission.angles = (10, 120, 0);
		else if(random == 1)
			mp_global_intermission.angles = (90, 0, 0);
		else
			mp_global_intermission.angles = (-15, 80, 0);
	spawncrate((3456, 3720, 3304) , (39, -180, 90) , "com_plasticcase_friendly");//NEW STRUT
	spawncrate((3472, 3720, 3339) , (90, 90, 0) , "com_plasticcase_friendly");//NEW STRUT
	spawncrate((3472, 3720, 3394) , (90, 90, 0) , "com_plasticcase_friendly");//NEW STRUT
	CreateInvisWalls((3431, 4229, 3740),(3503, 4265, 3799)); //new cover BARRIER
	CreateDeathRegion((3498, 4369, 3778), (3298, 4535, 3830));//roof
	
	spawncrate((3704, 4277, 3707) , (82, 2, 0) , "com_plasticcase_friendly");//strut
	spawncrate((3708, 4293, 3672) , (40, 85, 79) , "com_plasticcase_friendly");//strut
	spawncrate((3696, 4277, 3762) , (82, 2, 0) , "com_plasticcase_friendly");//strut
	spawncrate((4012, 4277, 3778) , (82, 2, 0) , "com_plasticcase_friendly");//strut2
	spawncrate((4016, 4293, 3743) , (40, 85, 79) , "com_plasticcase_friendly");//strut2
	spawncrate((4004, 4277, 3833) , (82, 2, 0) , "com_plasticcase_friendly");//strut2
	spawncrate((3992, 4276, 3775) , (82, 2, 0) , "com_plasticcase_friendly");//strut2pt2
	spawncrate((3984, 4276, 3830) , (82, 2, 0) , "com_plasticcase_friendly");//strut2pt2
	spawncrate((3996, 4292, 3740) , (40, 85, 79) , "com_plasticcase_friendly");//strut2pt2
	spawncrate((4306, 4277, 3844) , (82, 2, 0) , "com_plasticcase_friendly");//strut3
	spawncrate((4310, 4293, 3809) , (40, 85, 79) , "com_plasticcase_friendly");//strut3
	spawncrate((4298, 4277, 3899) , (82, 2, 0) , "com_plasticcase_friendly");//strut3
	spawncrate((4286, 4276, 3841) , (82, 2, 0) , "com_plasticcase_friendly");//strut3pt2
	spawncrate((4290, 4292, 3806) , (40, 85, 79) , "com_plasticcase_friendly");//strut3pt2
	spawncrate((4278, 4276, 3896) , (82, 2, 0) , "com_plasticcase_friendly");//strut3pt2
	spawncrate((3472, 3851, 3328) , (90, 90, 0) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3457, 3851, 3294) , (39, -180, 90) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3472, 3851, 3383) , (90, 90, 0) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3457, 4002, 3285) , (39, -180, 90) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3472, 4002, 3319) , (90, 90, 0) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3472, 4002, 3374) , (90, 90, 0) , "com_plasticcase_friendly");//NEWstrut
	spawncrate((3502, 4393, 3752) , (0, 266, 125) , "com_plasticcase_friendly");
	spawncrate((3501, 4507, 3753) , (0, 274, 125) , "com_plasticcase_friendly");
	//new cover archway
	for(i = 0;i < 2;i++)
	spawncrate((3379, 3225, 3333)+ (0,0,54* i) , (-90, 0, 0) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((3449, 3225, 3333)+ (0,0,54* i) , (-90, 0, 0) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((3519, 3225, 3333)+ (0,0,54* i) , (-90, 0, 0) , "com_plasticcase_friendly");
	spawncrate((3414, 3225, 3353) , (-90, 0, 0));
	spawncrate((3484, 3225, 3353) , (-90, 0, 0));
	spawncrate((3505, 3225, 3412) , (0, -4, -50) , "com_plasticcase_friendly");
	spawncrate((3395, 3225, 3412) , (0, 4, -50) , "com_plasticcase_friendly");
	spawncrate((3450, 3227, 3412) , (0, 0, -50) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((3383, 3197, 3420)+ (0,-55* i,0) , (0, -90, 0) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((3517, 3197, 3420)+ (0,-55* i,0) , (0, -90, 0) , "com_plasticcase_friendly");
	for(i = 0;i < 4;i++)
	spawncrate((3423, 3210, 3426)+ (0,-30* i,0) , (0, 0, 0) , "com_plasticcase_friendly");
	for(i = 0;i < 4;i++)
	spawncrate((3477, 3210, 3426)+ (0,-30* i,0) , (0, 0, 0) , "com_plasticcase_friendly");
	spawncrate((3400, 3116, 3421) , (2, 211, 0) , "com_plasticcase_friendly");
	spawncrate((3500, 3116, 3421) , (2, 329, 0) , "com_plasticcase_friendly");
    //mid archway
    for(i = 0;i < 3;i++)
	spawncrate((3807, 3597, 3309)+ (0,0,54* i) , (90, 90, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3807, 3713, 3304)+ (0,0,54* i) , (90, 90, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3720, 3713, 3304)+ (0,0,54* i) , (90, 90, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3566, 3713, 3304)+ (0,0,54* i) , (90, 90, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 5;i++)
	spawncrate((3794, 3729, 3422)+ (-55* i,0,0) , (0, 0, -45) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3697, 3706, 3320)+ (-54* i,0,0) , (0, 0, 75) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3682, 3709, 3346)+ (0,0,30* i) , (0, 0, 90) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3604, 3709, 3346)+ (0,0,30* i) , (0, 0, 90) , "com_plasticcase_friendly");
	for(i = 0;i < 4;i++)
	spawncrate((3770, 3710, 3434)+ (-55* i,0,0) , (0, 0, -15) , "com_plasticcase_friendly");
	for(i = 0;i < 4;i++)
	spawncrate((3770, 3684, 3439)+ (-55* i,0,0) , (0, 0, -8) , "com_plasticcase_friendly");
	for(i = 0;i < 4;i++)
	spawncrate((3770, 3657, 3442)+ (-55* i,0,0) , (0, 0, -5) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((3770, 3629, 3444)+ (-55* i,0,0) , (0, 0, -2) , "com_plasticcase_friendly");
	spawncrate((3809, 3706, 3437) , (27, 90, -90) , "com_plasticcase_friendly");
	spawncrate((3809, 3658, 3453) , (10, 90, -90) , "com_plasticcase_friendly");
	spawncrate((3809, 3609, 3457) , (0, 90, -90) , "com_plasticcase_friendly");
	spawncrate((3565, 3706, 3437) , (27, 90, 90) , "com_plasticcase_friendly");
    spawncrate((3565, 3658, 3453) , (10, 90, 90) , "com_plasticcase_friendly");
	spawncrate((3565, 3609, 3457) , (0, 90, 90) , "com_plasticcase_friendly");
	spawncrate((3805, 3628, 3332) , (7, -90, 90) , "com_plasticcase_friendly");
	spawncrate((3805, 3681, 3335) , (0, -90, 90) , "com_plasticcase_friendly");
	spawncrate((3806, 3679, 3337) , (0, 270, 90));
	//safe higher spot
	spawncrate((3372, 4254, 3625) , (0, 0, 0) , "com_plasticcase_friendly");
	spawncrate((3429, 4257, 3625) , (0, 6, 0) , "com_plasticcase_friendly");
	spawncrate((3480, 4281, 3625),(0,45,0), "com_plasticcase_friendly");
	CreateWalls((3510, 4520, 3646),(3510, 4380, 3750));
	CreateGrids((3475, 4520, 3763),(3325, 4380, 3763), (0,0,0));
	CreateRamps((3512, 4320, 3627),(4308, 4320, 3808));
	CreateWalls((3431, 4229, 3600),(3503, 4265, 3720)); //new cover
	spawncrate((3419, 4241, 3586) , (40, 117, 90) , "com_plasticcase_friendly");
	spawncrate((3497, 4282, 3586) , (40, 117, 90) , "com_plasticcase_friendly"); 
	//low ladder
    CreateGrids((3059, 3125, 2901),(3202, 3175, 2901), (0,0,0));
	CreateQuicksteps((3280, 3150, 3353), 452, 18, 2, (0,180,0));
	clonedcollision((3024, 3118, 2916.13), (0,90,0), mantlecoll);
	clonedcollision((3024, 3184, 2916.13), (0,90,0), mantlecoll);
	clonedcollision((3129, 3072, 3172.13), (0,0,0), mantlecoll);
	clonedcollision((3191, 3072, 3172.13), (0,0,0), mantlecoll);
	clonedcollision((3256, 3072, 3172.13), (0,0,0), mantlecoll);
	//mid map
	CreateRamps((3428, 4117, 3275),(3428, 3707, 3302));
	CreateQuicksteps((3765, 3700, 3305), 198, 18, 2, (0,90,0));
	CreateGrids((3600, 3231, 3305),(3600, 3591, 3305), (0,0,0));
	CreateGrids((3370, 3620, 3305),(3780, 3690, 3305), (0,0,0));
	CreateRamps((3371, 3715, 3302),(3371, 4225, 3611)); //big ramp
	//top map
	CreateGrids((4350, 4060, 3817),(4405, 4330, 3817), (0,0,0));
	CreateRamps((4556, 3995, 3820),(4749, 3995, 3900));
	CreateRamps((4555, 3680, 3820),(4761, 3680, 3900));
	CreateInvisRamps((4638, 4016, 3765),(4639, 3663, 3765));
	clonedcollision((4587, 3935, 3834.13), (0,270,0), mantlecoll); //?????
	for(i = 0;i < 4;i++)
	clonedcollision((4332.5, 4210, 3840)+(0,-62*i,0), (0,90,0), mantlecoll);
	//cannonball
	CreateGrids((3445, 4830, 3055),(3355, 5060, 3055), (0,0,0));
	clonedcollision((3366, 4797, 3060), (0,0,0), mantlecoll);
	clonedcollision((3427, 4796, 3043), (0,0,0), mantlecoll);
	clonedcollision((3279, 4799, 3132), (0,0,0), mantlecoll);
	cannonball((3400, 5037, 3055), (0,0,0), 1, (3406, 4526, 3710), 450);
	fufalldamage((3389, 4713, 2851.08), 500, 400);
	for(i = 0;i < 3;i++)
	spawncrate((3466, 4844, 3048)+(0,101*i,0) , (0, 90, -78) , "com_plasticcase_friendly");
	for(i = 0;i < 3;i++)
	spawncrate((3334, 4844, 3048)+(0,101*i,0) , (0, -90, -78) , "com_plasticcase_friendly");
}


lockout_h2_edit2() {
	arrow_array = [];
	arrow_array[arrow_array.size] = ((2955.06, 2552.78, 3279.13));
	arrow_array[arrow_array.size] = ((2955.08, 2880.71, 3183.13));
	arrow_array[arrow_array.size] = ((2955.08, 3296.56, 3167.13));
	arrow_array[arrow_array.size] = ((2960.63, 3611.34, 3183.13));
	arrow_array[arrow_array.size] = ((3305.01, 3611.38, 3183.13));
	arrow_array[arrow_array.size] = ((3606.98, 4137.15, 3183.13));
	arrow_array[arrow_array.size] = ((3608.57, 4259.49, 3052.97));
	show_route_arrows(arrow_array, 0.75);

	arrow_array = [];
	arrow_array[arrow_array.size] = ((2977.48, 2982.57, 2927.13));
	arrow_array[arrow_array.size] = ((2975.13, 3517.38, 2927.13));
	arrow_array[arrow_array.size] = ((3558.23, 3528.34, 3005.79));
	arrow_array[arrow_array.size] = ((3605.33, 3967.18, 3007.13));
	arrow_array[arrow_array.size] = ((3607.13, 4481.45, 3007.13));
	arrow_array[arrow_array.size] = ((3924.24, 4481.45, 3049.47));
	arrow_array[arrow_array.size] = ((4460.97, 4481.31, 2831.13));
	arrow_array[arrow_array.size] = ((4460.97, 4100.04, 2783.13));
	show_route_arrows(arrow_array, 0.75);

	disable_spawn_array = [];
	disable_spawn_array[disable_spawn_array.size] = (4527.2, 4522, 2776.13);
	disable_spawn_array[disable_spawn_array.size] = (4175, 3688, 2840.13);
	disable_spawn_array[disable_spawn_array.size] = (4176, 3984, 2840.13);
	disable_spawn_array[disable_spawn_array.size] = (4544, 3691, 3160.13);
	disable_spawn_array[disable_spawn_array.size] = (4544, 3972, 3160.13);
	disable_spawn_point(disable_spawn_array);

	
	add_spawn_point((3720, 3067, 2954),(0, 154, 0));
	add_spawn_point((3498, 2947, 2954),(0, 161, 0));
	add_spawn_point((2910, 2974, 2874),(0, 76, 0));
	add_spawn_point((3738, 3718, 2954),(0, 135, 0));
	add_spawn_point((3483, 3677, 3018),(0, 60, 0));
	add_spawn_point((3466, 2920, 3130),(0, 140, 0));
	add_spawn_point((3749, 2943, 3130),(0, 112, 0));
	add_spawn_point((3527, 4533, 2954),(0, -27, 0));
	add_spawn_point((3288, 4440, 3130),(0, 10, 0));
	add_spawn_point((2813, 3501, 3130),(0, 30, 0));
	add_spawn_point((2836, 2950, 3130),(0, 36, 0));
	add_spawn_point((3844, 3189, 3130),(0, -141, 0));
	add_spawn_point((3374, 3200, 3130),(0, -18, 0));


	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn");

	shaft_ents = [];
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3965, 3130));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3965, 3130); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3710, 3130));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3710, 3130); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3837, 3130));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3837, 3130); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3965, 3130) + (0,0,460));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3965, 3130) + (0,0,460); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3710, 3130) + (0,0,460));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3710, 3130) + (0,0,460); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;
	shaft_ents[index] = SpawnFX(level._effect[ "shaft2" ], (4200, 3837, 3130) + (0,0,460));	TriggerFX(shaft_ents[index]);
	ent = common_scripts\_createfx::createLoopSound(); ent.v[ "origin" ] = (4200, 3837, 3130) + (0,0,460); ent.v[ "angles" ] = ( 0, 0, 0 ); ent.v[ "soundalias" ] = "emt_grav_loop";
	index = shaft_ents.size;

	upshaft((4180, 3965, 3130), 50, 50, 860, true);
	upshaft((4180, 3710, 3130), 50, 50, 860, true);
	upshaft((4180, 3837, 3130), 50, 50, 860, true);

	CreateInvisGrids((4120, 4045, 3975),(4280, 3630, 3975), (-45,0,0));

	CreateGrids((4565, 4015, 3820),(4765, 3665, 3820), (-22,0,0));
	

	CreateWalls((4110, 3760, 3180),(4110, 3925, 3180));
	CreateWalls((4110, 3760, 3160),(4110, 3925, 3160));

	i=0;
	CreateWalls((4110, 3640, 3205 + i * 30),(4460, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4460, 4035, 3205 + i * 30));
	i++;
	CreateWalls((4110, 3640, 3205 + i * 30),(4460, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4460, 4035, 3205 + i * 30));
	i++;
	CreateWalls((4110, 3640, 3205 + i * 30),(4260, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4260, 4035, 3205 + i * 30));
	i++;
	CreateWalls((4110, 3640, 3205 + i * 30),(4230, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4230, 4035, 3205 + i * 30));
	i++;
	CreateWalls((4110, 3640, 3205 + i * 30),(4200, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4200, 4035, 3205 + i * 30));


	for(i=0; i<4; i++) {
		spawncrate((4110, 3812, 2855 + i * 30), (0, 90, 90),"com_plasticcase_friendly");
		spawncrate((4110, 3868, 2855 + i * 30), (0, 90, 90),"com_plasticcase_friendly");
	}

	CreateGrids((3510, 3800, 2937),(3460, 3880, 2937), (0,0,0));

	CreateGrids((4399, 4399, 2920),(4559, 4559, 2920), (0,0,0));

	for(i=0; i<7; i++) {
		spawncrate((4399, 4399, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4399, 4559, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4559, 4399, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4559, 4559, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
	}

	CreateDoors((4455, 4035, 2870),(4455, 4035, 2750),(90, 90, 0), 3, 2, 40, 140);

	fufalldamage((3796, 3842, 2077), 2000 , 6000);
	// CreateHiddenTP((4098, 3836, 2696),(3606, 3848, 2952));

	CreateGrids((4880, 4050, 3795),(4930, 4430, 3795), (0,0,0));

	CreateGrids((4000, 4130, 4541),(3700, 3560, 4541), (0,0,0));
	CreateWalls((4025, 4100, 4550),(4025, 3590, 4550), (0,90,0));

	delete_array = [];
	delete_array[delete_array.size] = spawncrate((3600-75, 3290, 3280), (0, 0, 0),"com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600-25, 3290, 3280), (0, 0, 0),"com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600+25, 3290, 3280), (0, 0, 0),"com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600+75, 3290, 3280), (0, 0, 0),"com_plasticcase_enemy");

	delete_array[delete_array.size] = spawncrate((3600+75, 2640, 3400) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600+25, 2640, 3400) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600-25, 2640, 3400) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600-75, 2640, 3400) , (90, -90, 0) , "com_plasticcase_enemy");
	
	delete_array[delete_array.size] = spawncrate((3600+75, 2640, 3400-50) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600+25, 2640, 3400-50) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600-25, 2640, 3400-50) , (90, -90, 0) , "com_plasticcase_enemy");
	delete_array[delete_array.size] = spawncrate((3600-75, 2640, 3400-50) , (90, -90, 0) , "com_plasticcase_enemy");
	
	wait (4 * 60);

	foreach(crate in delete_array)
		crate delete();

	cannonball((3600+100, 3070, 3307),(0, 0, 0), 2 ,(3325+100, 4400, 3697), 306);
	cannonball((3600-100, 3070, 3307),(0, 0, 0), 2 ,(3325-100, 4400, 3697), 306);

	cannonball((3325+100, 4400, 3627),(0, 0, 0), 1 ,(4380, 3840-150, 3920), 306);
	cannonball((3325-100, 4400, 3627),(0, 0, 0), 1 ,(4380, 3840+150, 3920), 306);

	CreateGrids((3600 + 240, 2870, 3417+20),(3600 - 240, 2870, 3417+20), (0,0,-55));
}

foundation_edit1(){
	level.meat_playable_bounds = [
		(-1117.97, -1419.2, 615.134),
		(-1974.71, -861.718, 473.934),
		(-3379.06, -564.918, 474.66),
		(-4257, -550.879, 528.649),
		(-4257, 273, 528.649),
		(-5067, 273, 528.649),
		(-5063, -1265, 387),
		(-4332.21, -1849.75, 487.297),
		(-3391.44, -1865.38, 653.284),
		(-3382, -1941.88, 631.692),
		(-3240.8, -2233.24, 685.863),
		(-2676.06, -2229.94, 874.95),
		(-2414.4, -2060.56, 641.486),
		(-1117.97, -2060.56, 641.486)
	];
	createPolygon();
	
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "me_electricbox2" || ent.model == "mp_cement_tarp4") {
			//iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}
	}
	
	 CreateDeathRegion((-5991, -2255, 200), (-4354, -1277, 600));
	CreateDeathRegion((-3178, -2108, 1050), (-2769, -1813, 1170));//rooftop
    fuckyou = getent("mp_global_intermission","classname");
	fuckyou.angles = (8, -180, 10);
	fuckyou.origin = (-4980, -900, 700);
	moveac130position((-3252, -1890, 3000));

	//spawn
	spawnmodel((-1260, -1685, 391) , (0, 0, 0) , "construction_porter_potty_blue");
	spawncrate((-1246, -1685, 433) , (0, 90, 0));
	spawncrate((-1271, -1685, 433) , (0, 90, 0));
    spawncrate((-1246, -1685, 485) , (0, 90, 0));
	spawncrate((-1271, -1685, 485) , (0, 90, 0));
	for(i = 0;i < 14;i++) //spinning
	spawncrate((-1603, -1970, 550)+ (-60* i,0,0), (90, 0, 0));//spinning

	//ramp new
	spawnmodel((-1596, -1712, 424) , (-29, -188, -90) , "afr_river_wood_plank1");
	spawnmodel((-1599, -1732, 427) , (-31, -188, -76) , "afr_river_wood_plank1");
	spawncrate((-1572, -1726, 396) , (-30, 172, 0));
	spawncrate((-1618, -1719, 423) , (-30, 172, 0));
	spawncrate((-1667, -1711, 441) , (0, 172, 0));
	
	//stuck spot fixes
	spawncrate((-1420, -1808, 425) , (0, 0, 0));
	spawncrate((-1544, -1808, 425) , (0, 0, 0));
	spawncrate((-2452, -1399, 365) , (0, -90, 0));//warehouse room block
	spawncrate((-1982, -972, 361) , (0, 90, 0));//warehouse room stuck
	spawncrate((-2046, -1827, 459), (0, 85, 0)); //potty
	//fence
	spawnmodel((-2826, -1624, 298) , (3, 79, 0) , "cement_fence_construction_02");
	spawnmodel((-2825, -1721, 304) , (4, 90, 0) , "cement_fence_construction_02");
	spawnmodel((-2825, -1817, 311) , (4, 90, 0) , "cement_fence_construction_02");
	for(i = 0;i < 5;i++)
	spawncrate((-2830, -1788, 352)+ (0,60* i,0) , (90, 90, 0));
	
	//door watch canister
	CreateInvisQuicksteps((-3144, -1685, 617), 130, 18, 2, (0,0,0));
	spawnmodel((-3110, -1685, 503) , (0, -270, -7) , "clt_ladder_construction_01");
	
	spawnmodel((-3109, -1693, 487) , (0, 0, 0) , "com_pallet");
	spawnmodel((-3102, -1693, 496) , (0, 0, 0) , "com_pallet_2");
	spawnmodel((-3126, -1692, 463) , (-89, 0, 0) , "com_pallet");
	spawnmodel((-3106, -1690, 467) , (-45, 0, 0) , "com_pallet");
	spawncrate((-3092, -1694, 489) , (0, 90, 0));
	CreateInvisGrids((-3110, -1805, 467),(-3110, -1405, 467), (0,0,0));
	
	//canister collision
	for(i = 0;i < 8;i++)
	spawncrate((-2982, -1829, 352) + (0,60* i,0) , (90, 90, 0));
	spawncrate((-2967, -1407, 455), (90, 90, 0));
	spawncrate((-3012, -1407, 465), (90, 90, 0));
	spawncrate((-3072, -1407, 455), (90, 90, 0));
	spawncrate((-3012, -1407, 410) , (90, 90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((-3042, -1409, 352)+ (-60* i,0,0), (90, 90, 0));
	
	spawnmodel((-2915, -1687, 418) , (0, 90, 0) , "usa_sign_sharpcurve");
	spawnmodel((-2915, -1569, 414) , (0, 90, 0) , "usa_sign_sharpcurve");
	spawnmodel((-3160, -1295, 494) , (65, 90, 0) , "usa_sign_sharpcurve");
	spawnmodel((-3160, -1176, 492) , (120, 90, 0) , "usa_sign_sharpcurve");
	spawnmodel((-4703, -1272, 489) , (218, 179, 0) , "usa_sign_sharpcurve");
	spawnmodel((-4494, -1272, 557) , (209, 179, 0) , "usa_sign_sharpcurve");
   
	createTP((-3291, 898, 344),(-1146, -1686, 392), (0,170,0), 0);
	createTP((857, -890, 326),(-1146, -1686, 392), (0,170,0), 0);
	createTP((-205, 978, 316),(-1146, -1686, 392), (0,170,0), 0);
	createTP((-2343, -532, 349),(-1146, -1686, 392), (0,170,0), 0);
	createTP((-364, -1381, 338),(-1146, -1686, 392), (0,170,0), 0);

	createTP((637, 389, 352),(-1146, -1686, 392), (0,170,0), 0);
	createTP((-659, -270, 392),(-1146, -1686, 392), (0,170,0), 0);
	createHiddenTP((-3332, -914, 680), (-3996, -592, 410), (0,-160,0), undefined, undefined, 10);
	
    spawnmodel((-3241, -1060, 325) , (0, 0, 0) , "prop_vent_large");
	spawnmodel((-3241, -860, 325) , (0, 180, 0) , "prop_vent_large");
	spawnmodel((-3247, -860, 326) , (6, 0, -180) , "prop_vent_large");
	spawnmodel((-3236, -1060, 326) , (6, 180, -180) , "prop_vent_large");
	for(i = 0;i < 4;i++)
	spawncrate((-3240, -1046, 330)+ (0,60* i,0) , (90, 90, 0));
	for(i = 0;i < 4;i++)
	spawncrate((-3240, -1046, 416)+ (0,60* i,0) , (90, 90, 0));
	
	//new truck to funnel
	spawnmodel((-3550, -1347, 294) , (0, 10, 0) , "vehicle_korean_blue_truck");
	spawnmodel((-3738, -1363, 296) , (0, 260, 0) , "prop_korean_barricade_01");
	for(i = 0;i < 6;i++)
	spawncrate((-3757, -1352, 328)+ (57* i,10* i,0) , (90, 100, 90));
	for(i = 0;i < 5;i++)
	spawncrate((-3633, -1389, 328)+ (57* i,10* i,0) , (90, 100, 90));
	spawncrate((-3443, -1308, 332) , (0, 100, 90));
	spawncrate((-3471, -1333, 377) , (180, 100, -180));


	//end walls
    for(i = 0;i < 11;i++)
	spawncrate((-5088, -1227, 353)+ (0,60* i,0) , (90, 90, 0));
	for(i = 0;i < 11;i++)
	spawncrate((-4353, -1306, 353)+ (0,-60* i,0) , (90, 90, 0)); 
	for(i = 0;i < 11;i++)
	spawncrate((-4353, -1306, 443)+ (0,-60* i,0) , (90, 90, 0)); 
	for(i = 0;i < 7;i++)
	spawncrate((-4353, -1546, 533)+ (0,-60* i,0) , (90, 90, 0)); 
	for(i = 0;i < 6;i++)
	spawncrate((-4353, -1287, 443)+ (-60* i,0,0) , (90, 90, 0)); 
	
	//back door
	CreateDoors((-4370, -990, 312),(-4370, -1165, 312),(90, 0, 0), 3, 2, 50, 90, true);
	spawnmodel((-4102, -618, 297) , (0, 90, 0) , "cargocontainer_20ft_blue");
	spawnmodel((-4297, -705, 297) , (0, 180, 0) , "cargocontainer_20ft_blue");
	for(i = 0;i < 5;i++)
	spawncrate((-3966, -651, 344)+ (-60* i,0,0) , (-90, 0, 0));
	for(i = 0;i < 7;i++)
	spawncrate((-3981, -638, 387)+ (-40* i,0,0) , (0, 90, 0));
	for(i = 0;i < 7;i++)
	spawncrate((-3981, -590, 387)+ (-40* i,0,0) , (0, 90, 0));
	for(i = 0;i < 7;i++)
	spawncrate((-4317, -574, 387)+ (0,-40* i,0) , (0, 0, 0));
	for(i = 0;i < 7;i++)
	spawncrate((-4276, -574, 387)+ (0,-40* i,0) , (0, 0, 0));
	for(i = 0;i < 3;i++)
	spawncrate((-4265, -815, 344)+ (0,60* i,0) , (-90, 90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((-4327, -815, 343)+ (0,20* i,0) , (-90, 90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((-4330, -670, 334)+ (0,60* i,0) , (0, 90, 0));
	for(i = 0;i < 5;i++)
	spawncrate((-4352, -839, 353)+ (0,-56* i,0) , (-90, 90, 0));
	for(i = 0;i < 3;i++)
	spawnmodel((-3974, -662, 399)+ (-95* i,0,0) , (0, 180, 0) , "cement_fence_construction_02");
	spawnmodel((-4257, -662, 399) , (0, -90, 0) , "cement_fence_construction_01");
	
	CreateInvisWalls((-4242, -546, 500),(-3982, -546, 500)); // block back wall
	
	
	spawncrate((-4559, -659, 345) , (-90, 90, 0));//STUCK SPOT
	
	spawnmodel((-4378, -742, 296) , (0, 0, 0) , "ug_crate_pallet");
	for(i = 0;i < 2;i++)
	spawncrate((-4394, -742, 347)+ (0,0,-60* i) , (0, 90, 0));
	for(i = 0;i < 2;i++)
	spawncrate((-4367, -742, 347)+ (0,0,-60* i) , (0, 90, 0));
	
	spawncrate((-4332, -740, 368) , (0, 90, 0));//pallet
	spawnmodel((-4325, -740, 374) , (0, 0, 0) , "berlin_com_pallet");
	
	//spawnmodel((-4371, -680, 292) , (0, 0, 0) , "construction_porter_potty_green");
	
	spawnmodel((-4455, -737, 332) , (-33, 0, 90) , "afr_river_wood_plank1");
	spawnmodel((-4455, -758, 332) , (-33, 0, 90) , "afr_river_wood_plank1");
	spawncrate((-4431, -747, 327) , (33, 180, 0));
	spawncrate((-4475, -747, 298) , (33, 180, 0));
	
	spawnmodel((-4351, -887, 341) , (0, -90, 0) , "props_common_fence_old_01");
	spawnmodel((-4354, -1013, 342) , (0, -90, 0) , "props_common_fence_old_01");
	spawnmodel((-4355, -888, 322) , (88, 90, 0) , "afr_corrugated_metal4x8");
	spawnmodel((-4351, -1251, 345) , (173, 90, 0) , "afr_corrugated_metal2x8");
	
	spawnmodel((-5052, -900, 650) , (0, 0, 0) , "mp_fullbody_ally_juggernaut");
	//Back cannons
	cannonball((-4990, -1090, 281), (0,263,0), 2, (-3297, -1231, 740), 500);
	cannonball((-4990, -990, 281), (0,260,0), 2, (-3297, -1231, 740), 500);
	cannonball((-4990, -890, 281), (0,256,0), 2, (-3297, -1231, 740), 500); 
	cannonball((-4990, -790, 281), (0,254,0), 2, (-3297, -1231, 740), 500);
	spawnmodel((-5007, -1088, 326) , (0, -97, -152) , "com_wall_fan_blade");
	spawnmodel((-5005, -988, 326) , (0, -100, -152) , "com_wall_fan_blade");
	spawnmodel((-5003, -888, 326) , (0, -104, -152) , "com_wall_fan_blade");
	spawnmodel((-5002, -788, 326) , (0, -106, -152) , "com_wall_fan_blade");
	spawnmodel((-5003, -1119, 296) , (0, 83, -28) , "com_wall_fan");
	spawnmodel((-5003, -1019, 296) , (0, 80, -28) , "com_wall_fan");
	spawnmodel((-5003, -919, 296) , (0, 76, -28) , "com_wall_fan");
	spawnmodel((-5003, -819, 296) , (0, 74, -28) , "com_wall_fan");
	spawnmodel((-5078, -1114, 294) , (-38, -7, -90) , "railing_old_span64_blue");
	spawnmodel((-5071, -1004, 294) , (-38, -10, -90) , "railing_old_span64_blue");
    spawnmodel((-5070, -901, 294) , (-38, -14, -90) , "railing_old_span64_blue");
    spawnmodel((-5073, -796, 294) , (-38, -16, -90) , "railing_old_span64_blue");
	spawnmodel((-5090, -582, 296) , (0, 0, 0) , "prop_korean_barricade_03");


    //stairs + door
	CreateDoors((-2844, -2171, 1000),(-2844, -2171, 912),(60, 0, 0), 2, 1, 20, 70, true);
	spawnmodel((-3189, -1983, 667) , (0, 0, 0) , "prop_preheater_stairs");
	spawnmodel((-2912, -2162, 836) , (0, 90, 0) , "prop_preheater_stairs");
	spawnmodel((-3231, -2119, 733) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	spawnmodel((-3176, -2119, 733) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	spawnmodel((-3121, -2119, 733) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	spawnmodel((-3093, -2119, 734) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	
	spawnmodel((-3221, -2177, 732) , (0, 90, 0) , "railing_old_span64_yellow"); 
	spawnmodel((-3221, -2195, 732) , (0, 90, 0) , "railing_old_span32_yellow");
	spawnmodel((-3108, -2195, 732) , (0, 0, 0) , "railing_old_span64_yellow");
	spawnmodel((-3172, -2195, 732) , (0, 0, 0) , "railing_old_span64_yellow");
	spawnmodel((-3221, -2195, 732) , (0, 0, 0) , "railing_old_span64_yellow");

	spawnmodel((-3221, -2195, 732) , (0, 90, 0) , "railing_old_post_yellow");
	spawnmodel((-3163, -2195, 732) , (0, 90, 0) , "railing_old_post_yellow");
	spawnmodel((-3105, -2195, 732) , (0, 90, 0) , "railing_old_post_yellow");
	
	spawnmodel((-2776, -2123, 907) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	spawnmodel((-2733, -2123, 906) , (270, 0, 0) , "vehicle_dump_container_door_swing");
	
	spawnmodel((-2782, -2195, 901) , (0, 0, 0) , "railing_old_span64_yellow");
	spawnmodel((-2718, -2195, 901) , (0, 0, 0) , "railing_old_span32_yellow");
	spawnmodel((-2685, -2194, 901) , (0, 90, 0) , "railing_old_span64_yellow");
	spawnmodel((-2685, -2195, 901) , (0, 90, 0) , "railing_old_post_yellow");
	spawnmodel((-2732, -2195, 901) , (0, 90, 0) , "railing_old_post_yellow");
	spawnmodel((-2685, -2129, 901) , (0, 90, 0) , "railing_old_post_yellow");
	 
	//stair collision
	for(i = 0;i < 3;i++) 
	spawncrate((-2696, -2161, 893)+(-30* i,0,0) , (0, 90, 0));
    CreateInvisRamps((-2785, -2161, 878),(-2874, -2161, 806));
	for(i = 0;i < 2;i++) 
	spawncrate((-2893, -2161, 806)+(-25* i,0,0) , (0, 90, 0));
	CreateInvisRamps((-2950, -2161, 791),(-3040, -2161, 719));
	for(i = 0;i < 5;i++) 
	spawncrate((-3058, -2150, 720)+(-35* i,0,0) , (0, 90, 0));
	CreateInvisRamps((-3187, -2106, 704),(-3187, -2017, 632));
	spawncrate((-3192, -1969, 636) , (0, 180, 0));
	spawncrate((-3192, -2002, 636) , (0, 0, 0));
	
	//stair railing coll
	spawncrate((-3236, -1979, 675) , (0, 90, 180));
	spawncrate((-3236, -2035, 689) , (39, 90, 180));
	spawncrate((-3236, -2088, 732) , (39, 90, 180));
	for(i = 0;i < 2;i++) 
	spawncrate((-3236, -2147, 759)+(0,-50* i,0) , (0, 90, 180));
	for(i = 0;i < 3;i++) 
	spawncrate((-3180, -2210, 759)+(50* i,0,0) , (0, 180, 180));
	spawncrate((-3013, -2210, 780) , (39, 180, 180));
	spawncrate((-2963, -2210, 821) , (39, 180, 180));
	spawncrate((-2904, -2210, 848) , (0, 0, 180));
	spawncrate((-2925, -2210, 831) , (-90, 180, 180));
	spawncrate((-2855, -2210, 863) , (39, 180, 180));
	spawncrate((-2807, -2210, 903) , (39, 180, 180));
	for(i = 0;i < 2;i++) 
	spawncrate((-2759, -2210, 925)+(50* i,0,0) , (0, 180, 180));
	for(i = 0;i < 2;i++) 
	spawncrate((-2670, -2197, 925)+(0,47* i,0) , (0, 90, 180));
	
	// new roof vents
	spawnmodel((-2487, -1971, 876) , (0, -90, -7) , "ny_rooftop_ac_unit");
	spawnmodel((-2487, -1853, 876) , (0, -90, -7) , "ny_rooftop_ac_unit");  
    for(i = 0;i < 3;i++) 
	spawncrate((-2510, -1971, 913)+(27* i,0,-3* i) , (0, 90, 7));
	for(i = 0;i < 3;i++) 
	spawncrate((-2510, -1853, 913)+(27* i,0,-3* i) , (0, 90, 7));
}



derail_edit1(){
	ents = GetEntArray();
	foreach(ent in ents) {
		if(ent.model == "com_filecabinetblackclosed" || ent.model == "com_roofvent2_animated" || ent.model == "me_electricbox4" || ent.model == "me_electricbox2") {
			//iprintln(ent.model);
			//logprint(ent.model + "\n");
			ent delete();
		}
	}
	
	level.meat_playable_bounds = [
		(3660, 3864, 400),
		(3662, 3596, 400),
		(5019.44, 3375, 400),
		(4873, 4876.6, 400),
		(4200, 4864, 400),
		(2755, 5174, 400),
		(1119, 5182, 400),
		(1119, 3864, 233.91)
	];
	createPolygon();
	
	moveac130position((3602, 4337, 1000));
	
	spawncrate((-280, -503, 46) , (0, 20, 90)); //wallbreach
	spawncrate((-222, -482, 46) , (0, 20, 90)); //wallbreach
	spawncrate((-173, -464, 42) , (0, 20, 90)); //wallbreach
	
	//Quicksteps
	CreateInvisQuicksteps((3475, 4450, 61), 110, 18, 2, (0,180,0));
	spawnmodel((3445, 4444, -125), (-4, 180, 180), "com_steel_ladder");
	
	//Broken fence blocker
	CreateinvisWalls((3457, 3876, 85),(3641, 3876, 160));
	
	//Start Ramp
	CreateinvisRamps((3590, 4554, 77),(3373, 4554, 130));
	CreateinvisRamps((3333, 4554, 137),(3038, 4554, 195));
	spawnmodel((3350, 4530, 140), (12, 0, 0), "com_pipe_8x512_metal");
	spawnmodel((3350, 4545, 140), (12, 0, 0), "com_pipe_8x512_metal");
	spawnmodel((3350, 4560, 140), (12, 0, 0), "com_pipe_8x512_metal");
	spawnmodel((3350, 4575, 140), (12, 0, 0), "com_pipe_8x512_metal");
	spawnmodel((3070, 4530, 200), (12, 0, 0), "com_pipe_8x64_metal");
	spawnmodel((3070, 4545, 200), (12, 0, 0), "com_pipe_8x64_metal");
	spawnmodel((3070, 4560, 200), (12, 0, 0), "com_pipe_8x64_metal");
	spawnmodel((3070, 4575, 200), (12, 0, 0), "com_pipe_8x64_metal");
	spawnmodel((3032, 4552, 208), (0, 0, 0), "snow_wood_log_24_96_a");
	spawnmodel((3005, 4559, 68) , (1, 180, 0) , "me_dumpster_close");
	spawnmodel((3005, 4550, 128) , (1, 180, 0) , "me_dumpster_close");
	
	//Grid ramp
	CreateinvisGrids((3010, 4720, 218),(3010, 4620, 218), (-25,0,0));
	spawnmodel((2975, 4642, 200), (0, 90, 60), "snow_barrier_tall_1");
	spawnmodel((3035, 4646, 237), (0, 0, 0), "snow_wood_log_24_96_a");
	spawnmodel((3000, 4720, 212), (0, 90, -30), "snow_wood_log_24_96_a");
	spawnmodel((3000, 4700, 212), (0, 90, -30), "snow_wood_log_24_96_a");
	spawnmodel((3052, 4715, 219) , (-60, 0, 0) , "ch_crate32x48_snow");
	
	
	//Wall Blocker
	
	for(i = 0;i < 3;i++)
	spawncrate((2597, 4783, 265) + (0, -45* i, 0), (90, 90, 0)); 	
	for(i = 0;i < 2;i++)
	spawncrate((2509, 4602, 265) + (0, -60* i, 0), (90, 90, 0));
	
	spawncrate((2544, 4640, 249) , (0, 80, 0));
	spawncrate((2544, 4640, 280.8) , (0, 80, 0));
	spawncrate((2582, 4633, 249) , (0, 80, 0));
	spawncrate((2582, 4633, 280.8) , (0, 80, 0));

	spawnmodel((2573, 4705, 216) , (0, 0, 0) , "ch_crate64x64_snow");
	spawnmodel((2585, 4773, 208) , (0, -5, 0) , "ch_crate48x64_snow");
	spawnmodel((2566, 4637, 216) , (0, 80, 0) , "ch_crate64x64_snow");
	spawnmodel((2484, 4590, 264) , (90, 0, 0) , "locomotive_bogie_01");
	

	//Ramp Up(Quickstep to container) 
	CreateinvisRamps((4350, 3900, 277),(4348, 3708, 418));
	spawnmodel((4370, 3785, 370), (0, 0, -35), "snow_wood_log_24_192_c");
	spawnmodel((4350, 3785, 370), (0, 0, -35), "snow_wood_log_24_192_c");
	spawnmodel((4330, 3785, 370), (0, 0, -35), "snow_wood_log_24_192_c");
	spawnmodel((4350, 3870, 306), (0, 90, 0), "snow_wood_log_24_96_a");
	//CreateQuicksteps((4365, 3715, 432), 160, 18, 2, (0,90,0));
	
	//Container Gap Fillers
	spawncrate((4127, 3676, 432) , (0, -90, 0));
	spawncrate((4127, 3637, 432) , (0, -90, 0));
	spawnmodel((4137, 3655, 432), (0, 0, 0), "snow_wood_log_24_96_a");
	spawnmodel((4114, 3655, 432), (0, 0, 0), "snow_wood_log_24_96_a");
	spawncrate((3822, 3676, 432), (0, -90, 0));
	spawncrate((3822, 3637, 432), (0, -90, 0));
	spawnmodel((3832, 3657, 432), (0, 0, 0), "snow_wood_log_24_96_a");
	spawnmodel((3811, 3657, 432), (0, 0, 0), "snow_wood_log_24_96_a");
	spawncrate((3746, 4159, 432), (0, -180, 0));
	spawncrate((3766, 4159, 432), (0, -180, 0));
	spawnmodel((3746, 4148, 432), (0, 90, 0), "snow_wood_log_24_96_a");
	spawnmodel((3746, 4172, 432), (0, 90, 0), "snow_wood_log_24_96_a");
	
	
	
	
	
	//Death barrier behind double wall
	CreateDeathRegion((2575, 4852, 180), (2401, 4631, 450));
	CreateDeathRegion((2477, 4852, 180), (1150, 4488, 450));
	CreateDeathRegion((4219, 4897, 85), (-41, 6205, 500.449));
	
	//Wall on top of container near player cannons
	i =0;
	spawncrate((3694, 4170, 485) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((3694, 4170, 485) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((3694, 4170, 485) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((3694, 4170, 485) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((3694, 4170, 485) + (0, 60* i, 0), (90, 0, 90)); i++;
	
	spawnmodel((3701, 4200, 445), (0, 90, 0), "snow_barrier_tall_1");
	spawnmodel((3701, 4292, 445), (0, 90, 0), "snow_barrier_tall_1");
	spawnmodel((3701, 4384, 445), (0, 90, 0), "snow_barrier_tall_1");
	
	
	//Roof wall
	i =0;
	spawncrate((2453, 4970, 630) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((2453, 4970, 630) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((2453, 4970, 630) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((2453, 4970, 630) + (0, 60* i, 0), (90, 0, 90)); i++;
	spawncrate((2453, 4970, 630) + (0, 60* i, 0), (90, 0, 90)); i++;
	
	spawnmodel((2453, 5000, 592), (0, 90, 0), "snow_barrier_tall_1");
	spawnmodel((2453, 5092, 592), (0, 90, 0), "snow_barrier_tall_1");
	spawnmodel((2453, 5184, 592), (0, 90, 0), "snow_barrier_tall_1");
	
	//Player cannons
	cannonball((3825, 4418, 432), (0,0,0), 1, (2575, 5115, 670), 150, 120);
	cannonball((3825, 4348, 432), (0,0,0), 1, (2575, 5039, 670), 150, 120);
	cannonball((3825, 4278, 432), (0,0,0), 1, (2575, 4990, 670), 150, 120);
	cannonball((3825, 4208, 432), (0,0,0), 1, (2575, 4939, 670), 150, 120);
	//bunker walls
	CreateWalls((1420, 5157, 600),(1155, 5157, 780));
	CreateWalls((1420, 4831, 600),(1155, 4831, 780));
	CreateWalls((1155, 4860, 600),(1155, 5126, 780));
	//Upper bunker floor
	CreateGrids((1409, 4864, 695),(1249, 5124, 695), (0,0,0));
	//upper bunker front wall
	CreateWalls((1417, 4860, 715),(1417, 5126, 715));
	//bunker doors
	CreateDoors((1420, 4993, 445) /*open*/, (1420, 4993, 602) /*close*/, (90,0,0) /*angle*/, 2 /*size*/, 2 /*height*/, 25 /*hp*/, 75 /*range*/);
	//door walls
	CreateWalls((1420, 4946, 600),(1420, 4860, 600));
	CreateWalls((1420, 5039, 600),(1420, 5126, 600));
	CreateWalls((1420, 4946, 655),(1420, 4860, 655));
	CreateWalls((1420, 5039, 655),(1420, 5126, 655));
	//Turrets
	createTurret((1419, 5102, 625), (0,0,0), 25, 40, undefined,undefined, 10);
	createTurret((1422, 4883, 625), (0,0,0), 25, 40, undefined,undefined, 10);
	//createTurret((1411, 4993, 750), (0,0,0), 25, 40, undefined,undefined, 10);
	//Bunker quicksteps
	CreateQuicksteps((1192, 4863, 695), 120, 18, 2, (0,90,0));
	CreateQuicksteps((1192, 5124, 695), 120, 18, 2, (0,270,0));
	//TPS
	createTP((268, 764, 112.123), (3583, 3987, 94.9783), (0, 50, 0),undefined);
	createTP((-2214, 1528, 28.7465), (3344, 4446, -15.875), (0, 50, 0),undefined);
	createTP((-894, -3100, 100.078), (3583, 3987, 94.9783), (0, 30, 0),undefined);
	createTP((2325, 2199, 142.125), (3344, 4446, -15.875), (0, 15, 0),undefined);
	createTP((557, 2872, 126.211), (3583, 3987, 94.9783), (0, 15, 0),undefined);
	createTP((-215, -1960, 117.383), (3344, 4446, -15.875), (0, 30, 0),undefined);
	createTP((2429, -1920, 42.2997), (3344, 4446, -15.875), (0, 30, 0),undefined);
	createHiddenTP((1198, 4992, 780), (2685, 4818, 210), (0,-90,0), undefined, undefined, undefined, undefined, 160);
	//createHiddenTP((1198, 4992, 780), (111, 1013, 593.823), (0, 180, 0), "out");
	
	//new shit
	spawnmodel((5313, 1845, 470) , (-15, 65, 0) , "com_phonebooth_america");
	spawnmodel((5304, 1827, 575) , (-15, 65, 0) , "com_emergencylightcase");
	spawnmodel((5321, 1829, 558) , (0, 39, 0) , "com_teddy_bear_sitting");
	spawnmodel((5386, 1750, 416) , (0, 0, 0) , "foliage_tree_pine_snow_sm_b");
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (5311, 1933, 512);
	mp_global_intermission.angles = (-4, 270, 0);
	
	createTP((5306, 1858, 400), (2524, 5118, 599), (0, 270, 0),1,30,100,undefined,1);
	
	 
	//spawnmodel((5301, 1838.8, 400) , (0, 0, 0) , "prop_flag_speznas");
	
	spawnmodel((4545, 4876, 247) , (10, 0, 0) , "ch_sign_stopsign");
	spawnmodel((4332, 4882, 252) , (0, 0, 0) , "ch_sign_stopsign");
	spawnmodel((5093, 4840, 258) , (0, 0, 0) , "foliage_tree_pine_snow_tall");
	spawnmodel((5149, 5212, 257) , (0, 0, 0) , "foliage_tree_pine_snow_xl_b");
	spawnmodel((5299, 4490, 310) , (0, 0, 0) , "foliage_tree_pine_snow_2");
	spawnmodel((4939, 4338, 261) , (0, 0, 0) , "foliage_tree_pine_snow_lg_a");
	spawnmodel((4924, 4529, 262) , (0, 0, 0) , "foliage_tree_pine_snow_sm_b");
	spawnmodel((4644, 5088, 292) , (0, 0, 0) , "foliage_tree_pine_snow_2");
	spawnmodel((5057, 4026, 423) , (-10, -5, 0) , "foliage_tree_pine_snow_sm_b");
	spawnmodel((5008, 3607, 492) , (0, 0, 0) , "foliage_tree_pine_snow_lg_b");
	spawnmodel((4831, 3017, 423) , (0, 0, 0) , "foliage_tree_pine_snow_2");
	spawnmodel((5113, 3209, 511) , (0, 0, 0) , "foliage_tree_pine_snow_2");
	spawnmodel((4983, 3728, 514) , (10, -90, 0) , "ch_sign_stopsign");
	spawnmodel((4384, 5177, 302) , (-20, 90, 0) , "snow_fallen_tree_1");
	
	spawnmodel((5957, 4942, 300) , (0, 0, 0) , "foliage_tree_pine_snow_xl_b");
	spawnmodel((5769, 3818, 431) , (-5, 50, 0) , "foliage_tree_pine_snow_xl_b");
	spawnmodel((5149, 5212, 257) , (5, 0, 0) , "foliage_tree_pine_snow_xl_b");
	
	/*
	//rock
	spawnmodel((4788, 4208, 291) , (0, -20, 0) , "prop_misc_rock_boulder_snow_03");
	spawncrate((4691, 4194, 324) , (0, 150, 90));
	spawncrate((4738, 4167, 324) , (0, 150, 90));
	spawncrate((4780, 4157, 337) , (0, 185, 90));
	spawncrate((4819, 4175, 335) , (0, 273, 90));
	spawncrate((4802, 4213, 334) , (0, 135, 90));
	spawncrate((4756, 4241, 327) , (0, 150, 90));
	spawncrate((4705, 4257, 325) , (0, 175, 90));
	spawncrate((4669, 4223, 305) , (0, 80, 90));
	spawncrate((4714, 4223, 323) , (0, 165, 90));
	spawncrate((4784, 4186, 345) , (-10, 155, 90));
	*/
	
	//snowcat
	
	spawnmodel((4518, 3648, 362) , (15, -165, 0) , "snowcat");
	spawncrate((4501, 3612, 443) , (15, -165, 90));
	spawncrate((4486, 3668, 443) , (15, -165, 90));
	spawncrate((4516, 3616, 390) , (-15, 15, 90));
	spawncrate((4500, 3671, 390) , (-15, 15, 90));
	
	spawncrate((4553, 3684, 435) , (10, -165, 90));
	spawncrate((4588, 3696, 442) , (10, -165, 90));
	spawncrate((4565, 3634, 435) , (-10, 15, 90));
	spawncrate((4604, 3646, 442) , (-10, 15, 90));
	
	
	spawncrate((4649, 3658, 435) , (-15, 15, 90));
	spawncrate((4633, 3708, 433) , (15, -165, 90));
	 
	spawncrate((4638, 3741, 417) , (15, -165, 90));
	spawncrate((4575, 3724, 399) , (15, -165, 90));
	spawncrate((4512, 3707, 381) , (15, -165, 90));
	spawncrate((4668, 3629, 420) , (-15, 15, 90));
	spawncrate((4604, 3612, 402) , (-15, 15, 90));
	spawncrate((4542, 3595, 384) , (-15, 15, 90));
	
	
	fufalldamage((2747, 4675, 227),200, 600);
}
karachi_edit1(){
	ents = getEntArray();
	for ( index = 0; index < ents.size; index++ )
	{
	if(isSubStr(ents[index].classname, "trigger_hurt"))
	ents[index].origin = (99999999, 999999, 9999999);
	}

	classicents = GetEntArray("classicinf", "targetname");
	foreach(ent in classicents)
	ent delete();
	
	level.meat_playable_bounds =
	[
	(6498, 1636, 399.625),
	(6688, 1824, 399.625),
	(7449, 1824, 399.625),
	(7442, 1308, 396.825),
	(5020, -1139, 339.148),
	(4857, -951, 570.423),
	(4214, -305, 626.306),
	(4101, -1122, 193.762),
	(3532, -1987, 233.91),
	(3638, -2759, 233.91),
	(3651, -3180, 233.91),
	(2896, -3180, 233.91),
	(2890, -1992, 233.91),
	(2837, -1989, 233.91),
	(2839, -475, 233.91),
	(2711, -475, 233.91),
	(2957, 630, 233.91),
	(3640, 870, 233.91),
	(5741, 1441, 233.91),
	(5962, 1619, 233.91)
	];
	createPolygon();
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (7181, 1433, -92);
	mp_global_intermission.angles = (-1, 215, 0);
 
	CreateDeathRegion((4154, -1767, -210), (2797, -3270, -310)); //under map fix

	 //oom block
	spawncrate((-117, -12, 415), (90, 90, 90), "com_plasticcase_friendly");
	spawncrate((-110, -128, 390), (90, 90, 90), "com_plasticcase_friendly");
	spawncrate((6269, 1254, -63), (0, 135, 0), "com_plasticcase_friendly");
	spawncrate((6290, 1275, -63), (0, 135, 0), "com_plasticcase_friendly");
	spawncrate((6311, 1296, -63), (0, 135, 0), "com_plasticcase_friendly");
	spawncrate((6250, 1235, -78), (0, 315, 35), "com_plasticcase_friendly");
	spawncrate((6330, 1315, -78), (0, 135, 35), "com_plasticcase_friendly");
	CreateWalls((7475, 1817, -50),(7475, 1495, -50));
	CreateWalls((7475, 1817, -111),(7475, 1495, -111));
	CreateWalls((4844, -961, -185),(4588, -705, -185));
	CreateWalls((4844, -961, -125),(4480, -594, -125));
	CreateWalls((4844, -961, -65),(4480, -594, -65));
	CreateWalls((4844, -961, -5),(4480, -594, -5));
	CreateWalls((4844, -961, 60),(4243, -357, 60));

	//fix wb (start edit)
	CreateDeathRegion((5917, 1204, 41), (5715, 1161, 110));

	CreateInvisWalls((5940, 1213, 64),(5795, 1060, 64));
	CreateInvisWalls((5850, 1297, 64),(5705, 1150, 64));
	spawncrate((5893, 1256, 75),(0, -45, 0), "com_plasticcase_friendly");
	spawncrate((5754, 1105, 75),(0, -45, 0), "com_plasticcase_friendly");

	CreateInvisWalls((5940, 1213, 110),(5795, 1060, 110));
	CreateInvisWalls((5850, 1297, 110),(5705, 1150, 110));
	spawncrate((5893, 1256, 120),(0, -45, 0), "com_plasticcase_friendly");
	spawncrate((5754, 1105, 120),(0, -45, 0), "com_plasticcase_friendly");

	CreateWalls((5020, -1142, 30),(4864, -980, 30));
	CreateWalls((5659, -514, 30),(5049, -1125, 30));
	CreateWalls((5659, -514, 60),(5467, -706.5, 60));
	CreateWalls((4221, -336, 60),(4107, -1086, 60));
	spawncrate((6219, 1358, 58), (0, 45, 0));
	spawncrate((6159, 1298, 58), (0, 45, 0));
	spawncrate((6099, 1238, 58), (0, 45, 0));
	spawncrate((6039, 1178, 58), (0, 45, 0));
	spawncrate((5979, 1118, 58), (0, 45, 0));
	spawncrate((5919, 1058, 58), (0, 45, 0));
	spawncrate((5859, 998, 58), (0, 45, 0));
	spawncrate((5799, 938, 58), (0, 45, 0));
	spawncrate((5739, 878, 58), (0, 45, 0));
	spawncrate((5710, 849, 58), (0, 45, 0));
	//pipe bridge
	spawncrate((6328, 1416, 26), (0, 135, 0));
	spawncrate((6388.7, 1355, 26), (0, 135, 0));
	spawncrate((6449.4, 1294, 26), (0, 135, 0));
	spawncrate((6510.1, 1233, 26), (0, 135, 0));
	spawncrate((6570.8, 1172, 26), (0, 135, 0));
	spawncrate((6631.5, 1111, 26), (0, 135, 0));
	spawncrate((6692.2, 1050, 26), (0, 135, 0));
	spawncrate((6752.9, 989, 26), (0, 135, 0));
	spawncrate((6813.6, 928, 26), (0, 135, 0));
	spawncrate((6874.3, 867, 26), (0, 135, 0));
	spawncrate((6935, 806, 26), (0, 135, 0));
	CreateRamps((7139, 1028, -70),(6947, 833, 17));
	CreateWalls((6910, 795, 100),(6910, 795, 10), (0, 135, 90));

	//fence block
	spawncrate((7424, 1246, 60), (0, 45, 0));
	spawncrate((7362, 1184, 60), (0, 45, 0));
	spawncrate((7300, 1122, 60), (0, 45, 0));
	spawncrate((7238, 1060, 60), (0, 45, 0));
	spawncrate((7176, 998, 60), (0, 45, 0));
	spawncrate((7114, 936, 60), (0, 45, 0));
	spawncrate((7114, 936, 120), (0, 45, 0));
	spawncrate((7052, 874, 60), (0, 45, 0));
	spawncrate((7052, 874, 20), (0, 45, 0));
	spawncrate((7052, 874, 120), (0, 45, 0));

	spawncrate((6990, 812, 60), (0, 45, 0));
	spawncrate((6990, 812, 120), (0, 45, 0));
	spawncrate((6928, 750, 60), (0, 45, 0));
	spawncrate((6928, 750, 120), (0, 45, 0));
	spawncrate((6866, 688, 60), (0, 45, 0));
	spawncrate((6866, 6988, 120), (0, 45, 0));
	spawncrate((6804, 626, 60), (0, 45, 0));
	spawncrate((6742, 564, 60), (0, 45, 0));
	spawncrate((6680, 502, 60), (0, 45, 0));
	spawncrate((6618, 440, 60), (0, 45, 0));
	spawncrate((6556, 378, 60), (0, 45, 0));
	spawncrate((6494, 316, 60), (0, 45, 0));
	spawncrate((6432, 254, 60), (0, 45, 0));
	spawncrate((6370, 192, 60), (0, 45, 0));
	spawncrate((6306, 132, 50), (0, 45, 0));
	CreateWalls((6274.82, 101, 30),(5903, -272, 108));
	//barbed wire
	spawnmodel((5688, -522, 33) , (0, 45, 0) , "mil_razorwire_long_static");
	spawncrate((5872, -302, 70), (0, 45, 0));
	spawncrate((5812, -362, 70), (0, 45, 0));
	spawncrate((5752, -422, 70), (0, 45, 0));
	spawncrate((5692, -482, 70), (0, 45, 0));


	//brick wall
	spawncrate((6519, 1648, 85), (0, 0, 0));
	spawncrate((6435, 1648, 85), (0, 0, 0));
	spawncrate((6351, 1647, 85), (0, 0, 0));
	spawncrate((6267, 1647, 85), (0, 0, 0));
	spawncrate((6183, 1647, 85), (0, 0, 0));
	spawncrate((6099, 1647, 85), (0, 0, 0));
	spawncrate((6015, 1647, 85), (0, 0, 0));

	CreateQuicksteps((4522, -563, -65), 100, 16, 2, (0, 0,0));
	//big bridge
	CreateWalls((5602, -546, 8),(4355, 30, 8), (0,155,0));
	CreateWalls((5643.44, -505.23, 8),(4396.44, 70.77, 8), (0,155,0));
	CreateWalls((5684.88, -464.46, 8),(4437.88, 111.54, 8), (0,155,0));
	CreateWalls((5726.32, -423.69, 8),(4479.32, 152.31, 8), (0,155,0));
	CreateWalls((5767.76, -382.92, 8),(4520.76, 193.08, 8), (0,155,0));
	CreateWalls((5809.2, -342.15, 8),(4562.2, 233.85, 8), (0,155,0));
	CreateWalls((5850.64, -301.38, 8),(4603.64, 274.62, 8), (0,155,0));
	CreateWalls((5892, -260.61, 8),(4645.08, 315.39, 8), (0,155,0));


	CreateElevator((2993, -2074, 31),(3066, -2160, 31), 307, 3.0,(0,0,0));
	CreateGrids((2960, -2054, 28),(3074, -2180, 28), (0,0,0));

	createTP((1502, -517, 5), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
	createTP((-1462, -446, -11), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
	createTP((391, -1413, -11), (6278, 1265.66, -160.875), (0, 320, 0),1);
	createTP((2076, 1062, 41), (6278, 1265.66, -160.875), (0, 320, 0),1);
	createTP((1803, 1524, 0), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
	createTP((-745, 2043, 1), (6278, 1265.66, -160.875), (0, 320, 0),1);
	createTP((299, -2577, 1), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
	createTP((-2228, 141, 5), (6278, 1265.66, -160.875), (0, 320, 0),1);

	//late game  flag
	//createTP((5433, 849, 42), (2985, -2516, 55), (0, 80, 0), undefined, undefined, undefined,500);

	//createHiddenTP((3023, -2763, 370), (769, -1826, 20), (0, 180, 0), "out");
	//createHiddenTP((3023, -2763, 44), (769, -1826, 20), (0, 180, 0), "out");
	//createHiddenTP((3023, -2763, -160), (769, -1826, 20), (0, 180, 0), "out");
	//staircase block
	spawncrate((3342, -2712, 293), (0, 0, 0), "com_plasticcase_friendly");
	//gate
	CreateDoors((5408, -81, -105) /*open*/, (5408, -81, -145) /*close*/, (90,66,0) /*angle*/, 4 /*size*/, 4 /*height*/, 20 /*hp*/, 220 /*range*/, 1 /*sideways*/);
	spawnmodel((5210, -36, -160) , (0, 153, 0) , "vehicle_80s_sedan1_silvdest");
	spawnmodel((5210, -44, -110) , (0, 320, 0) , "vehicle_80s_hatch1_reddest");
	spawnmodel((5370, -39, -14) , (0, 156, 0) , "me_corrugated_metal8x8");
	spawnmodel((5277, 2, -24) , (10, 156, 5) , "me_corrugated_metal8x8");
	spawnmodel((5498, -99, -25) , (350, 156, 0) , "me_corrugated_metal8x8");
	spawnmodel((5427, -64, -25) , (344, 156, 0) , "me_corrugated_metal4x8");
	spawncrate((5157, 20, -119), (0, 155, 0));
	spawncrate((5210.8, -4, -119), (0, 155, 0));
	spawncrate((5254.6, -17.7, -119), (0, 155, 0));
	spawncrate((5112.6, -12.3, -119), (0, 155, 0));
	spawncrate((5192.1, -47.3, -119), (0, 155, 0));
	spawncrate((5251.7, -75, -119), (0, 155, 0));

	//other side gate wall
	spawnmodel((5570, -137, -97) , (0, 156, 0) , "me_corrugated_metal8x8");
	spawncrate((5554, -149, -120), (0, 156, 0));
	spawncrate((5554, -149, -70), (0, 156, 0));
	spawncrate((5596, -167.6, -100), (0, 156, 0));

	//sandbags
	spawnmodel((7123, 1750, -128) , (0, 45, 0) , "mil_sandbag_desert_long");
	spawnmodel((7202, 1670, -128) , (0, 45, 0) , "mil_sandbag_desert_short");
	spawnmodel((7244, 1630, -128) , (0, 45, 0) , "mil_sandbag_desert_end_left");
		//
	spawnmodel((7229, 1645, -98) , (0, 45, 0) , "mil_sandbag_desert_end_left");
	spawnmodel((7189, 1685, -98) , (0, 45, 0) , "mil_sandbag_desert_short");
	spawnmodel((7108, 1765, -98) , (0, 45, 0) , "mil_sandbag_desert_long");
		//
	spawnmodel((7169, 1705, -68) , (0, 45, 0) , "mil_sandbag_desert_end_left");
	spawnmodel((7105, 1769, -68) , (0, 45, 0) , "mil_sandbag_desert_long");
	spawncrate((7242, 1627, -112), (353, 135, 0));
	spawncrate((7222, 1647, -80), (353, 135, 0));
	spawncrate((7167, 1702, -58), (353, 135, 0));
	spawncrate((7189, 1680, -112), (0, 135, 0));
	spawncrate((7129, 1740, -94), (0, 135, 0));
	spawncrate((7089, 1780, -94), (0, 135, 0));
	spawncrate((7049, 1820, -53), (0, 135, 0));
	spawncrate((7111, 1758, -53), (0, 135, 0));
		CreateWalls((4097, -1118, 10),(3531, -1987, 10));
		CreateWalls((4097, -1118, 70),(3531, -1987, 70));

		//backlot corrugated wall
	spawncrate((2865, -2012, 70), (0, 345, 0));
	spawncrate((2804, -1995.6, 70), (0, 345, 0));
	spawnmodel((2842, -1983, 70) , (350, 345, 0) , "me_corrugated_metal8x8");
	CreateDoors((3408, -2017, 100) /*open*/, (3344, -2017, 100) /*close*/, (0,0,90) /*angle*/, 1 /*size*/, 1 /*height*/, 15 /*hp*/, 120 /*range*/, 1 /*sideways*/);
	spawncrate((3140, -2021.6, 95), (0, 0, 0));
	spawncrate((3070, -2021.6, 95), (0, 0, 0));
	spawncrate((2995, -2021.6, 95), (0, 0, 0));

		CreateWalls((2745, -3212, 47),(3828, -3212, 47));
		moveac130position((4855, -304, 1770));
}
karachi_edit2(){
	ents = getEntArray();
	for ( index = 0; index < ents.size; index++ )
	{
		if(isSubStr(ents[index].classname, "trigger_hurt"))
		ents[index].origin = (99999999, 999999, 9999999);
	}

	classicents = GetEntArray("classicinf", "targetname");
	foreach(ent in classicents)
		ent delete();
	level.meat_playable_bounds =
	[
	(1007.12, -1713, 399.625),
	(2710.12, -1713, 399.625),
	(2710.69, -1943, 399.625),
	(2910.31, -1990.58, 399.625),
	(3532.31, -1990.58, 399.625),
	(4003.31, -3551.58, 399.625),
	(3901.31, -3630.58, 399.625),
	(3536.31, -3203.58, 399.625),
	(2935.31, -3188.8, 399.625),
	(2897.88, -3167.92, 399.625),
	(1123.88, -3195.92, 399.625),
	(1121.88, -3318, 399.625),
	(608.88, -3319.92, 399.625),
	(552.88, -1939.92, 399.625),
	(817, -1688, 233.91)
	];
	createPolygon();
	
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (2203, -1124.8, 185);
	mp_global_intermission.angles = (-14, 260, 0);
	
	spawncrate((-117, -12, 415), (90, 90, 90), "com_plasticcase_friendly");
	spawncrate((-110, -128, 390), (90, 90, 90), "com_plasticcase_friendly");
	spawncrate((2865, -2012, 70), (0, 345, 0));
	spawncrate((2804, -1995.6, 70), (0, 345, 0));
	spawnmodel((2842, -1983, 70) , (350, 345, 0) , "me_corrugated_metal8x8");
	spawnmodel((1108, -3111, 122) , (5, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((1081, -2777, 85) , (2, 110, 0) , "me_corrugated_metal8x8");
	CreateWalls((2680, -1737, 20),(2680, -1942, 100));
	CreateInvisWalls((2680, -1737, 133),(2680, -2000, 133));
	CreateInvisWalls((1860, -1709, 130),(2557, -1709, 130));

	CreateQuicksteps((1657, -1960, 77), 90, 16, 2, (0,90,0));
	CreateQuicksteps((1657, -1962, 77), 70, 16, 2, (0,270,0));
	CreateQuicksteps((2536, -1949, 77), 70, 16, 2, (0,90,0));
	createTurret((2926,-2697.5,233), (0,180,0), 50, 50, 25, undefined, 9);

	CreateWalls((2902, -3181, 33),(1953, -3181, 33));
	CreateWalls((2902, -3181, 93),(1895, -3181, 93));
	CreateWalls((2902, -3181, 153),(1895, -3181, 153));
	CreateWalls((2902, -3181, 213),(1895, -3181, 213));
	CreateWalls((2902, -3181, 273),(1895, -3181, 273));
	//backlot building walls
	CreateWalls((2927, -2053, 55),(2927, -2290, 177));
	CreateWalls((2927, -2450, 55),(2927, -2532, 177));
	CreateWalls((2927, -2692, 55),(2927, -2804, 55));
	CreateWalls((2927, -2692, 127),(2927, -2804, 127));
	CreateWalls((3176, -3174, 55),(3498, -3174, 55));
	CreateWalls((3531, -3134, 55),(3531, -2872, 55));
	CreateWalls((2944, -2830, 220),(3177, -2830, 320));
	CreateWalls((3497, -2534, 75),(3497, -2054, 75));
	CreateInvisWalls((3343, -2009, 75),(3343, -2009, 75));
	CreateWalls((3176, -2022, 75),(2954, -2022, 75));
	CreateWalls((3497, -2534, 235),(3497, -2054, 235));
	CreateWalls((3466, -2020, 235),(3242, -2020, 235));
	CreateWalls((3208, -2805, 340),(3208, -2661, 340));
	CreateInvisWalls((3208, -2805, 410),(3208, -2661, 410));
	CreateWalls((3208, -2805, 480),(3208, -2661, 464));
	CreateWalls((3315, -2805, 480),(3315, -2661, 464));
	CreateWalls((3400, -2805, 480),(3400, -2661, 464));
	CreateWalls((3485, -2805, 480),(3485, -2661, 464));
	CreateInvisWalls((3179, -2566.76, 520),(3465, -2566.76, 520));
	CreateInvisWalls((3179, -2576.76, 600),(3527, -2575.76, 600));
	spawncrate((2921, -2566.76, 565), (90, 90, 90));
	spawncrate((2948, -2503.76, 530), (90, 90, 90));
	spawncrate((3480, -2690, 380), (0, 90, 0));
	spawncrate((3480, -2776, 380), (0, 90, 0));
	spawncrate((3398, -2689.76, 450), (0, 90, 270), "com_plasticcase_friendly");

	CreateGrids((3292, -3039, 155),(3172, -3110, 155), (0,0,0));
	CreateGrids((3184, -3108, 275),(3184, -2960, 275), (0,0,0));
	CreateQuicksteps((3238, -3136, 527), 375, 16, 2, (0,90,0));
	CreateRamps((3033, -2840, 385),(3033, -2740, 348));

	spawncrate((3340, -2692, 215), (0, 270, 32));
	spawncrate((3369, -2692, 235), (0, 270, 32));
	spawncrate((3393, -2692, 250), (0, 270, 32));
	spawncrate((3440, -2690, 270), (0,0,0));

	spawncrate((3010, -2838, 149), (0, 0, 0), "com_plasticcase_friendly");
	spawncrate((3530, -2903, 119), (0, 90, 0));
	spawncrate((2892, -2838, 251), (90, 0, 0));
	CreateDoors((2926.72,-3065.705,120) /*open*/, (2926.72,-3065.705,60) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 50 /*range*/, 1 /*sideways*/);
	CreateDoors((3060.72,-2838.705,70) /*open*/, (3127.72,-2838.705,70) /*close*/, (90,90,0) /*angle*/, 1 /*size*/, 2 /*height*/, 25 /*hp*/, 50 /*range*/, 1 /*sideways*/);
	CreateDoors((3160.22,-2558.705,390) /*open*/, (3261.22,-2558.705,390) /*close*/, (90,90,0) /*angle*/, 1 /*size*/, 2 /*height*/, 20 /*hp*/, 50 /*range*/, 1 /*sideways*/);

	CreateGrids((2960, -2054, 28),(3084, -2180, 28), (0,0,0));

	CreateQuicksteps((3387, -2783, -20), 190, 16, 2, (0,0,0));
	createTP((1502, -517, 5), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
	createTP((-1462, -446, -11), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
	createTP((391, -1413, -11), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
	createTP((2076, 1062, 41), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
	createTP((1803, 1524, 0), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
	createTP((-745, 2043, 1), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
	createTP((299, -2577, 1), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
	createTP((-2228, 141, 5), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
	createTP((-675, 810, -3), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
	//createHiddenTP((3017, -2117, 90), (746, 2290, 30), (0, 190, 0), "out");
	fufalldamage((3242, -2989, 33),300, 600);
	fufalldamage((3910, -3509, 44),20, 600);
	CreateDeathRegion((3527, -1810, 37), (4123, -2831, 10));
	CreateDeathRegion((3560, -2831, 37), (4123, -3830, -338));
	CreateDeathRegion((4123, -3830, -338), (1897, -3211, 37));
	CreateDeathRegion((4123, -3830, -338), (2718, -3038, -200));
	spawncrate((3913, -3512, 26), (80, 0, 0), "com_plasticcase_trap_friendly");
	spawncrate((3625, -3635, 46), (80, 30, 0), "com_plasticcase_trap_friendly");
	spawncrate((3276, -3723, 46), (74, 60, 0), "com_plasticcase_trap_friendly");
	spawnmodel((3618, -3638, 70) , (0, 120, 350) , "mp_fullbody_ally_juggernaut");
	moveac130position((1745, -1807, 3000));
}
overwatch_edit1(){
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );
	foreach(bleep in hurttriggers)
	{
		bleep.origin=((bleep.origin[0],bleep.origin[1], 5500));
	}
	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-5102, 11875, 13365);
	mp_global_intermission.angles = (-20, 42, 0);
	moveac130position((-4571, 6094, 20233));
	
	//NEW WB Block
	spawncrate((-6627, 1315, 10394) , (0, 355, 0));
	spawncrate((-6624, 1349, 10394) , (0, 355, 0));
	spawncrate((-6809, 1331, 10394) , (0, 355, 0));
	spawncrate((-6806, 1365, 10394) , (0, 355, 0));
	spawncrate((-6877, 1337, 10394) , (0, 355, 0));
	spawncrate((-6874, 1371, 10394) , (0, 355, 0));
	spawncrate((-7057, 1354, 10394) , (0, 355, 0));
	spawncrate((-7054, 1388, 10394) , (0, 355, 0));
	spawncrate((-7045, 1465, 10394) , (0, 355, 0));
	spawncrate((-7042, 1499, 10394) , (0, 355, 0));
	
	spawncrate((-4969, 1153, 10394) , (0, 355, 0));
	spawncrate((-4966, 1187, 10394) , (0, 355, 0));
	spawncrate((-5154, 1171, 10394) , (0, 355, 0));
	spawncrate((-5151, 1205, 10394) , (0, 355, 0));
    spawncrate((-5222, 1177, 10394) , (0, 355, 0));	
    spawncrate((-5219, 1211, 10394) , (0, 355, 0));	
	spawncrate((-5402, 1194, 10394) , (0, 355, 0));
	spawncrate((-5399, 1228, 10394) , (0, 355, 0));
	spawncrate((-5390, 1305, 10394) , (0, 355, 0));
	spawncrate((-5387, 1339, 10394) , (0, 355, 0));
	
	spawncrate((-6431, 1936, 10296) , (0, 84, 0) , "com_plasticcase_friendly");
	
	//Side Wall
	CreateWalls((-4712, 13671, 13390),(-5268, 13672, 13390));
	CreateWalls((-4519, 11655, 13390),(-4523, 13640, 13390));
	
	//TP Wall 
	CreateWalls((-5077, 13337, 13450),(-5301, 13141, 13335));
	CreateWalls((-5056, 13345, 13450),(-4822, 13345, 13450));
	CreateWalls((-5056, 13345, 13385),(-4822, 13345, 13385));
	//Door
	CreateDoors((-4822, 13500, 13461) /*open*/,(-4822, 13506, 13395) /*close*/, (90,0,0) /*angle*/, 5 /*size*/, 2 /*height*/, 30 /*hp*/, 105 /*range*/,  1 /*sideways*/);
	//Cover
	CreateWalls((-4616, 12873, 13385),(-4773, 12873, 13335));
	CreateWalls((-5119, 12360, 13385),(-5281, 12360, 13335));
	CreateWalls((-4616, 11846, 13435),(-4773, 11846, 13335));
	CreateRamps((-4760, 11715, 13335),(-4760, 11825, 13410));
	CreateRamps((-4696, 11715, 13335),(-4696, 11825, 13410));
	CreateRamps((-4634, 11715, 13335),(-4634, 11825, 13410));
	CreateRamps((-4568, 11715, 13335),(-4568, 11825, 13410));
	//wallbreach
	spawncrate((-6037, 2319, 10371), (0, 355, 0));
	spawncrate((-6035, 2344, 10371), (0, 355, 0));
	
	spawncrate((-6037, 2319, 10441), (0, 355, 0));
	spawncrate((-6035, 2344, 10441), (0, 355, 0));
	
	spawncrate((-5920, 2306, 10371), (0, 355, 0));
	spawncrate((-5918, 2331, 10371), (0, 355, 0));
	
	spawncrate((-5902, 2492, 10371), (0, 355, 0));
	spawncrate((-5898, 2537, 10371), (0, 355, 0));
	spawncrate((-5894, 2582, 10371), (0, 355, 0));
	
	spawncrate((-5876, 2742, 10371), (0, 355, 0));
	spawncrate((-5874, 2765, 10371), (0, 355, 0));

	CreateDeathRegion((-3822, 2025, 10333),(-3541, 2547, 10482));
	CreateDeathRegion((-5478, 1163, 10349),(-4913, 1343, 10463));
	CreateDeathRegion((-6108, 2262, 10333),(-5820, 2797, 10463));
	CreateDeathRegion((-7137, 1322, 10349),(-6558, 1500, 10463));
	
	CreateInvisWalls((-6207, 3035, 10400),(-5638, 2979, 10400));
	CreateWalls((-5536, 2487, 10293),(-5571, 2191, 10323));
	CreateWalls((-5119, 1702, 10293),(-5154, 1462, 10323));
	CreateWalls((-6371, 2251, 10293),(-6414, 1826, 10363));
	CreateWalls((-6495, 1056, 10293),(-6449, 1501, 10363));
	//steps block
	spawncrate((-4386, 1919, 10400), (0, 355, 0));
	spawncrate((-4386, 1919, 10460), (0, 355, 0));
	spawncrate((-4403, 1725, 10400), (0, 355, 0));
	spawncrate((-4403, 1725, 10460), (0, 355, 0));
	
	//Steps
	CreateQuicksteps((-4402, 1795, 10363.6), 90, 16, 2, (0, -6,0)); //flag side
	CreateQuicksteps((-4398, 1844, 10363.6), 90, 16, 2, (0, -6,0)); //flag side
	CreateQuicksteps((-4402, 1799, 10363.6), 90, 16, 2, (0, -186,0)); //flag side
	CreateQuicksteps((-4398, 1848, 10363.6), 90, 16, 2, (0, -186,0)); //flag side

	//Door
	CreateDoors(((-6433, 1660, 10380)) /*open*/,(-6433, 1660, 10314) /*close*/, (90,-6,0) /*angle*/, 6 /*size*/, 2 /*height*/, 30 /*hp*/, 120 /*range*/,  1 /*sideways*/);
	//Flags
	createTP((-1199, -709, 12703),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((-764, 850, 12672),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((532, -1374, 12672),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((532, -1374, 12864),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((399, 759, 12864),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((1190, 303, 12672),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((-123, 1741, 12864),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createTP((-485, -643, 12865),(-5243, 13264, 13420), (0, 55, 0), undefined);
	createHiddenTP((-5256, 11681, 13360),(-3623, 1732, 10283), (4, -168, 0) , undefined);
	createHiddenTP((-7352, 1752, 10285),(-4588, 11689, 13360), (-1, 135, 0) , undefined);
	//createHiddenTP((-7555, 1197, 10283),(8, -2159, 12864), (0, 88.6308, 0) , undefined, "out");
	//Death Barriers
	Deathradius((-74, 16, 8000), 3400, 4200);
	Deathradius((-4904, 12596, 8345), 6000, 5000);
}
oasis_edit1(){
	level.meat_playable_bounds = [
		(-3877.13, 1009.32, 443.117),
		(-3614.96, 2244.4, 750.731),
		(-3049.15, 1764.47, 1048.98),
		(-2517.08, 1766.86, 812.26),
		(-2121.75, 1982.26, 820.263),
		(-1632.17, 1983.1, 820.263),
		(-1630.48, 485.71, 800.068),
		(-1371.88, 233.608, 800.068),
		(-689.258, 235.157, 800.068),
		(-695.946, -879.152, 870.662),
		(-1400.66, -862.714, 747.261),
		(-2513.62, -741.655, 685.678),
		(-3111.57, -365.922, 312.121),
		(-3291.83, -476.508, 421.602),
		(-3478.61, -492.864, 421.602),
		(-3866.58, -420.204, 421.602)
	];
	createPolygon();

	spawncrate((3185, 1570, 220), (0, 90, -90),"com_plasticcase_friendly");
	spawncrate((3185, 1510, 220), (0, 90, -90),"com_plasticcase_friendly");
	spawncrate((3185, 1450, 220), (0, 90, -90),"com_plasticcase_friendly");
	spawncrate((3185, 1570, 280), (0, 90, -90),"com_plasticcase_friendly");
	spawncrate((3185, 1510, 280), (0, 90, -90),"com_plasticcase_friendly");
	spawncrate((3185, 1450, 280), (0, 90, -90),"com_plasticcase_friendly");

	spawncrate((3200, 1390, 280), (0, 0, 90),"com_plasticcase_friendly");
	spawncrate((3260, 1390, 280), (0, 0, 90),"com_plasticcase_friendly");
	spawncrate((3320, 1390, 280), (0, 0, 90),"com_plasticcase_friendly");

	spawncrate((3200, 1615, 280), (0, -180, 90),"com_plasticcase_friendly");
	spawncrate((3260, 1615, 280), (0, -180, 90),"com_plasticcase_friendly");
	spawncrate((3320, 1615, 280), (0, -180, 90),"com_plasticcase_friendly");

	spawncrate((3315, 1252, 220), (0, -180, 90),"com_plasticcase_friendly");
	spawncrate((3315, 1252, 280), (0, -180, 90),"com_plasticcase_friendly");

	Deathradius((2976, 1952, 39), 1000 , 80);
	Deathradius((3330, 1070, 211), 180 , 300);
	CreateDeathRegion((3360, 682, 146), (4020, 1978, 676));
	Deathradius((3291, 1510, 188), 80 , 100);

	CreateDeathRegion((-836, -771, 100),(-2544, -1300, 400));
	CreateDeathRegion((-1396, -187, 100),(-2544, -759, 400));


	//treestuckspot
	spawncrate((-2454, 681, 252) , (90, 45, 0));
	
	
	spawnmodel((-3496, 7, 152) , (0, -77, -90) , "dub_oasis_sign_logo");
	spawnmodel((-4243, 588, 234) , (-2, 22, 0) , "dub_rock_02");
	spawnmodel((-4136, 479, 286) , (0, 33, 0) , "dub_oasis_sign");
	
	ents = GetEntArray();
		foreach(ent in ents) {
			if(ent.model == "vehicle_taxi_yellow_destructible_dubai" || ent.model == "vehicle_luxurysedan_2008_destructible" || ent.model == "vehicle_taxi_yellow_destructible" || ent.model == "qad_lamp_windy_model" || ent.model == "vehicle_taxi_toplight_dubai") {
				//iprintln(ent.model);
				//logprint(ent.model + "\n");
                ent delete();
				}
			}

	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (-3262.73, -501, 552);
	mp_global_intermission.angles = (29, -222, 0);
	moveac130position((-3100, 226, 1200));

	//brick wall
			
	i=0;
	for(i = 0;i < 8;i++)
	spawncrate((-3778, 1420, 270) + (60* i, 0, 0), (90, 0, 0));
	i=0;
	for(i = 0;i < 4;i++)
	spawncrate((-3739, 1430, 340) + (60* i, 0, 0), (90, 0, 0)); 
	for(i = 5;i < 11;i++)
	spawncrate((-3800, 1430, 350) + (60* i, 0, 0), (90, 0, 0));
	spawncrate((-3260, 1420, 270), (90, 0, 0));
	spawncrate((-3200, 1420, 270), (90, 0, 0));
	spawncrate((-3310.82, 1437, 270), (90, 0, 0));

	i=0;
	for(i = 0;i < 3;i++)
	spawnmodel((-3643.6, 1431, 215)+(127* i,0,0), (0, 180, 0), "qad_brickset_01_128"); i++;
	i=0;
	for(i = 0;i < 2;i++)
	spawnmodel((-3643.6, 1411, 348)+(127* i,0,0), (0, 180, 180), "qad_brickset_01_128"); i++;
	for(i = 2;i < 5;i++)
	spawnmodel((-3643.6, 1411, 378)+(127* i,0,0), (0, 180, 180), "qad_brickset_01_128"); i++;
			
	spawnmodel((-3343, 1431, 215), (0, 90, 0), "qad_brickset_01_end");
	spawnmodel((-3341, 1420, 217), (0, 90, 0), "iron_door_01");
	spawnmodel((-3310, 1419, 217), (0, 98, 0), "iron_door_01");
	spawnmodel((-3232, 1431, 215), (0, 90, 0), "qad_brickset_01_end2");
	spawnmodel((-3135, 1431, 215), (0, 180, 0), "qad_brickset_01_128");
	spawnmodel((-3343, 1441, 230.7), (0, 90, 0), "qad_brickset_02_88");
	spawnmodel((-3343, 1435, 245.5), (0, 90, 0), "qad_brickset_02_88");
	//spawnmodel((-3431, 1424, 282), (0, -90, 0) , "iron_square_pattern_window_01");
	//spawnmodel((-3461, 1424, 282), (0, -90, 0) , "iron_square_pattern_window_01");
	spawnmodel((-3281, 1420, 315), (180, 0, 0) , "qad_roof_decor_01_row_x5_tan02");
	spawnmodel((-3818, 1425, 348), (0, 0, 0) , "qad_roof_decor_04_row_x5_tan02");
	spawnmodel((-3655, 1425, 348), (0, 0, 0) , "qad_roof_decor_04_row_x5_tan02");
    spawnmodel((-3124, 1437, 231), (0, 90, 0) , "qad_brickset_02_88");
	spawnmodel((-3191, 1436, 245), (0, 90, 0) , "qad_brickset_02_88");	
	spawnmodel((-3128, 1436, 246), (0, 90, 0) , "qad_brickset_02_88");
	spawnmodel((-3192, 1441, 231), (0, 90, 0) , "qad_brickset_02_88");
			
	//pool wall
	spawnmodel((-4047, -399, -127), (0, 90, 114), "ny_rooftop_skylight");
	spawnmodel((-4047, 199, -127), (0, 90, 114), "ny_rooftop_skylight");
	spawnmodel((-4048, -36, -127) , (0, 90, 114) , "ny_rooftop_skylight");
	spawnmodel((-3870, -273, 214) , (0, 70, 0) , "dub_rooftop_flag1");
	spawnmodel((-3870, 457, 214) , (0, 72, 0) , "dub_rooftop_flag1");
	//spawnmodel((-3881, 52, 49) , (-105, -5, 0) , "dub_rock_02");
	//spawnmodel((-3911, 92, 64) , (-110, -165, -5) , "dub_rock_02");
	spawnmodel((-3871, -273, 51) , (0, -90, 0) , "qad_pool_column_01");
	spawnmodel((-3871, 456, 51) , (0, -90, 0) , "qad_pool_column_01");
			
	//bushcover
	spawnmodel((-2647, -69, 238),(0, -45, 0), "qad_planter_courtyard_upper");
	spawnmodel((-2623, -45, 238),(0, -45, 0), "qad_planter_courtyard_upper");
	spawnmodel((-2661, -46, 230),(-2, -45, 0), "foliage_hedge_boxy_2");
	spawnmodel((-2746, -532, 227),(-2, -45, 0), "foliage_dub_potted_palm_01");
	spawncrate((-2685, -29, 260) , (0, -134.321, 90));
	spawncrate((-2647, -66, 260) , (0, -134.321, 90));
	spawncrate((-2685, -29, 290) , (0, -134.321, 90));
	spawncrate((-2647, -66, 290) , (0, -134.321, 90));
	
	spawnmodel((-2959, -182, 258) , (90, -30, 0) , "qad_poolside_canopy_01");
	spawnmodel((-3004, -257, 258) , (90, -30, 0) , "qad_poolside_canopy_01");
	spawnmodel((-2928, 116, 258) , (90, 1, 0) , "qad_poolside_canopy_01");
	spawnmodel((-2926, 202, 258) , (90, 1, 0) , "qad_poolside_canopy_01");
	spawnmodel((-2930, 28, 258) , (90, 1, 0) , "qad_poolside_canopy_01");
	
			
			
	CreateDeathRegion((2263, 284, 147), (2116, 536, 250));
	CreateDeathRegion((-2099, 1450, 200), (-4363, 2764, 280));
	CreateDeathRegion((-1752, 1572.68, 760), (-2104, 1931.8, 900));//NEW DB

	//conector + flags
	spawnmodel((3411, -321, 150), (0, 30, 0), "qad_fountain_lion");
	//spawnmodel((-2044, -195, 549), (0, 35, 0), "dub_lounge_sofa_02");
			
	//spawncrate((-2030, -195, 590), (0, 135, 90));
	//spawncrate((-1980, -245, 590), (0, 135, 90));
	fufalldamage((-1788, 217, 230),700, 700);

	createTP((-1937, 1095, 277), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);
	createTP((1282, 204, 172), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);
	createTP((-1304, 549, 215), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);
	createTP((2298, 1025, 215), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);
	createTP((29, 1984.5, 340), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);
	createTP((19.5, 177, 215), (2622, 1343, 188), (0, 45, 0),1,undefined, undefined, undefined, undefined, true);

	createTP((2668, 1692, 188), (-3730.9, -398.556, 159), (0, 54, 0)); //right		
	//createTP((3156, -393, 156), (-3839, -376.04, 159), (0, 45, 0),undefined,240,50); //original +no slow
	createTP((3081, 1547, 188), (-3735.51, 603.04, 159), (0, 316, 0)); //left	
	//createTP((3604, -106, 156), (-3832, 558.04, 159), (0, 320, 0),undefined,240,50); //original +no slow

	createHiddenTP((-2056, -147, 715), (-2575, 1701.04, 690), (0, 225, 0), undefined,1);
	createHiddenTP((-3113, 1706, 676), (-1973, 1501, 612), (0, -90, 0), undefined,1);
	createTP((-1751.88, 1826.62, 250), (-1509.43, 196.77, 733), (0, 180, 0),1,15,100,undefined,1);
			
	//spawncrate((-2092, 308, 450), (35, 225, 0));//invisible ledge
	
	CreateElevator((-2287, 154, 201.6),(-2182, 214, 201.6), 260, 1.4, (0,45,0));
	//treeramp

	spawnmodel((-2569, 737, 200) , (53, -45, 0) , "qad_tree_palm_tall_2");
	spawnmodel((-2561, 721, 217) , (0, 0, 0) , "qad_planter_ring_01");

	i=0;
	for(i = 0;i < 11;i++)
	spawncrate((-2573, 742, 201)+(45*i,-45* i, 31* i), (-26, -45, 0));

	//tower
	CreateInvisWalls((-3120, 1748.3, 710),(-2955, 1748.3, 710));
	CreateInvisWalls((-3120, 1748.3, 770),(-2955, 1748.3, 770));
	CreateInvisWalls((-3151, 1550, 710),(-3151, 1719, 710));
	spawncrate((-3151, 1560, 770), (0, 90, 90));
	spawncrate((-3181, 1476, 740), (0, 90, 90));
	spawncrate((-3181, 1476, 800), (0, 90, 90));

	spawncrate((-3010, 1401, 740), (0, 0, 90));
	spawncrate((-3090, 1401, 740), (0, 0, 90));
	spawncrate((-3170, 1401, 740), (0, 0, 90));
	spawncrate((-3010, 1401, 800), (0, 0, 90));
	spawncrate((-3090, 1401, 800), (0, 0, 90));
	spawncrate((-3170, 1401, 800), (0, 0, 90));
	
	CreateInvisWalls((-3197, 224, 190),(-3081, 303, 190));
	CreateInvisWalls((-3157.7, 421.5, 190),(-3277.5, 345.1, 190));
	CreateInvisWalls((-3267, 325, 190),(-3215, 248, 190));
	CreateInvisWalls((-3044, -112, 190),(-3151, -76.6, 190));
	CreateInvisWalls((-3160.3, -84.1, 190),(-3201, -211.4, 190));
	CreateInvisWalls((-3174, -218.1, 190),(-3083, -252.4, 190));
	CreateInvisWalls((-3434, 510.1, 190),(-3399, 630.3, 190));
	CreateInvisWalls((-3538, 667.9, 190),(-3573.6, 542.4, 190));
	CreateInvisWalls((-3555.8, 536.3, 190),(-3450.4, 509.6, 190));

	CreateInvisWalls((-3483, -447, 190),(-3460, -331, 190));
	CreateInvisWalls((-3475, -324, 190),(-3592, -305, 190));
	CreateInvisWalls((-3605, -304, 190),(-3628, -425, 190));

	CreateInvisWalls((-3039, 278, 185),(-3011, 190.5, 185));
	CreateInvisWalls((-3004, 167, 185),(-2979, -7.5, 185));
	CreateInvisWalls((-2980, 5.7, 185),(-2985.6, -81.8, 185));

	CreateInvisWalls((-3049.6, -294.8, 185),(-3105, -373, 185));
	CreateInvisWalls((-3116.1, -383.3, 185),(-3204, -448.5, 185));
	CreateInvisWalls((-3209.5, -453.8, 185),(-3331.7, -496.3, 185));
	CreateInvisWalls((-3319, -493.8, 185),(-3467, -500, 185));
	CreateInvisWalls((-3647, -469.8, 185),(-3877, -418, 185));

	CreateInvisWalls((-3560, 699, 185),(-3666, 694, 185));
	CreateInvisWalls((-3675, 690, 185),(-3811, 638, 185));
	CreateInvisWalls((-3828, 626, 185),(-3850, 612, 185));

	CreateInvisWalls((-3243.7, 571.2, 185),(-3162.2, 479.1, 185));
	CreateInvisWalls((-3357.7, 651.3, 185),(-3238.2, 566.9, 185));

	CreateQuicksteps((-1945, 450, 597),104, 15, 2, (0, -90, 0));
	CreateQuicksteps((-1527, -63, 585),92, 15, 2, (0, 180, 0));
	CreateRamps((-1336, -600, 565),(-1017, -600, 665));

	spawncrate((-982, -610, 681), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-982, -560, 681), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-982, -510, 681), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-982, -460, 681), (0, 90, 0),"com_plasticcase_friendly");

	spawncrate((-1395, -300, 569), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -360, 569), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -420, 569), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -480, 569), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -540, 569), (0, 90, 0),"com_plasticcase_friendly");
	spawncrate((-1395, -600, 569), (0, 90, 0),"com_plasticcase_friendly");

	//ladders
	CreateInvisQuicksteps((-2999.35, 87.83, 201), 70, 16, 2, (0,188,0));
	spawnmodel((-3012.78, 53.7, 172) , (0, 188, 0) , "qad_latticegeo_01");
	spawnmodel((-3011.34, 56, 219) , (0, 56, 0) , "hos_wood_beam_01");
	spawnmodel((-3019.74, 116, 219) , (0, 56, 0) , "hos_wood_beam_01"); 
	CreateInvisQuicksteps((-3217.8, 531.36, 201), 70, 16, 2, (0,222,0));
	spawnmodel((-3211.95, 494.218, 172) , (0, 222, 0) , "qad_latticegeo_01");
	spawnmodel((-3212.33, 497.147, 219) , (0, 90, 0) , "hos_wood_beam_01");
	spawnmodel((-3252.25, 541.489, 219) , (0, 90, 0) , "hos_wood_beam_01");
	CreateInvisQuicksteps((-2767, 785.684, 201), 50, 16, 2, (0,90,0));
	spawnmodel((-2799, 802, 186) , (-2, 90, 0) , "qad_latticegeo_01");
	spawnmodel((-2799, 805, 143) , (-2, 90, 0) , "qad_latticegeo_01");
	spawnmodel((-2737, 798, 233) , (-2, 109, 0) , "hos_wood_beam_01");
	spawnmodel((-2796, 798, 233) , (-2, 109, 0) , "hos_wood_beam_01");
	 
	CreateInvisQuicksteps((-2248, -327, 655), 120, 16, 2, (0,315,0));
	spawnmodel((-2258, -364, 550) , (2, 135, 0) , "qad_latticegeo_01");
	spawnmodel((-2259, -362, 590) , (2, 135, 0) , "qad_latticegeo_01");
	spawnmodel((-2261, -360, 634) , (2, 135, 0) , "qad_latticegeo_01");
	
	CreateInvisQuicksteps((-2260, 40, 526), 30, 16, 2, (0,45,0));
	spawnmodel((-2246, 54, 520) , (0, -225, -89) , "pb_window_arch_03");
	spawnmodel((-2248, 54, 537) , (0, -225, -89) , "pb_window_arch_03");
	
	spawnmodel((-2012, -137, 508) , (0, 132, 0), "dub_lounge_sofa_02");  //NEW SOFA
	spawncrate((-2012, -141, 514) , (0, -48, 0));
	spawncrate((-2039, -165, 532) , (0, -48, 0));
	
	spawnmodel((-3132, -806, 216) , (0, -40, 0) , "qad_pool_column_01");
	spawnmodel((-3415, -593, 216) , (0, -40, 0) , "qad_pool_column_01");
	spawnmodel((-3340, -686, 235) , (90, -11, 0) , "qad_pool_column_01");
	spawnmodel((-3680, -519, 216) , (0, -10, 0) , "qad_pool_column_01");
	spawnmodel((-3868, -489, 216) , (0, -10, 0) , "qad_pool_column_01");
	spawnmodel((-4064, -452, 215) , (0, 2, 0) , "qad_pool_column_01");
	
	//column col
	i=0;
	for(i = 0;i < 3;i++)
	spawncrate((-3496.61, -489.73, 270) + (40* i, -40* i, 0), (90, 45, 0));
	
	for(i = 0;i < 4;i++)
	spawncrate((-2753, -670, 270) + (0, 60* i, 0), (90, 90, 0));
	
	spawnmodel((-2750, -611, 220),(-2, 90, 0), "foliage_hedge_boxy_2");

	i=0;
	for(i = 0;i < 4;i++)
	spawncrate((-3820, 1026.5, 270) + (0, 60* i, 0), (90, 90, 0));
	for(i = 4;i < 7;i++)
	spawncrate((-3788, 1002.5, 270) + (0, 60* i, 0), (90, 90, 0));
	i=0;
	for(i = 0;i < 8;i++)
	spawncrate((-3788, 1026.5, 360) + (0, 60* i, 0), (90, 90, 0));
	i=0;
	for(i = 0;i < 9;i++)
	spawncrate((-3788, 1026.5, 450) + (0, 60* i, 0), (90, 90, 0));
	spawnmodel((-3866, 1128, 228) , (0, 0, 0) , "dub_restaurant_roundtable_set_sim");
	spawncrate((-3886.51, 970, 260), (0, 90, 0));
	spawncrate((-3886.51, 970, 320), (0, 90, 0));

 //pool wall col
	i=0;
	for(i = 0;i < 18;i++)
	spawncrate((-3887.5, -391, 210) + (0, 60* i, 0), (90, 90, 0));
	i=0;
	for(i = 0;i < 6;i++)
	spawncrate((-3887.5, 389, 300) + (0, 60* i, 0), (90, 90, 0));

	spawncrate((-3862, 1026.5, 260), (0, 0, 90));
	spawncrate((-3862, 1026.5, 320), (0, 0, 90));
	spawncrate((-3862, 1026.5, 380), (0, 0, 90));
	spawncrate((-3862, 1026.5, 440), (0, 0, 90));
	spawncrate((-3862, 1026.5, 500), (0, 0, 90));

	spawncrate((-2604, -155, 490), (0, 135, 0));
			
	//pool floor
	spawncrate((-3045, -96, 144), (0, 0, 0));
	spawncrate((-3045, -46, 144), (0, 0, 0));
	spawncrate((-3045, 14, 144), (0, 0, 0));
	spawncrate((-3045, 70, 144), (0, 10, 0));
	spawncrate((-3060, 130, 144), (0, 10, 0));
	spawncrate((-3070, 190, 144), (0, 15, 0));
	spawncrate((-3090, 240, 144), (0, 18, 0));

	spawncrate((-3125, -46, 144), (0, 0, 0));
	spawncrate((-3125, 14, 144), (0, 0, 0));
	spawncrate((-3125, 70, 144), (0, 0, 0));
	spawncrate((-3135, 130, 144), (0, 0, 0));
	spawncrate((-3145, 190, 144), (0, 0, 0));
	spawncrate((-3155, 240, 144), (0, 0, 0));

	spawncrate((-3125, -356, 144), (0, 0, 0));
	spawncrate((-3125, -296, 144), (0, 0, 0));
    spawncrate((-3125, -236, 144), (0, 0, 0));

	spawncrate((-3045, -286, 144), (0, 0, 0));

	spawncrate((-3205, -406, 144), (0, 0, 0));
	spawncrate((-3205, -346, 144), (0, 0, 0));
	spawncrate((-3205, -286, 144), (0, 0, 0));
	spawncrate((-3205, -226, 144), (0, 0, 0));
	spawncrate((-3205, -166, 144), (0, 0, 0));
	spawncrate((-3205, -106, 144), (0, 0, 0));
	spawncrate((-3205, -46, 144), (0, 0, 0));
	spawncrate((-3205, 14, 144), (0, 0, 0));
	spawncrate((-3205, 74, 144), (0, 0, 0));
	spawncrate((-3205, 134, 144), (0, 0, 0));
	spawncrate((-3205, 194, 144), (0, 0, 0));
	spawncrate((-3205, 254, 144), (0, 0, 0));
	spawncrate((-3205, 435, 144), (0, 0, 0));
	spawncrate((-3205, 494, 144), (0, 0, 0));

	spawncrate((-3285, -466, 144), (0, 0, 0));
	spawncrate((-3285, -406, 144), (0, 0, 0));
	spawncrate((-3285, -346, 144), (0, 0, 0));
	spawncrate((-3285, -286, 144), (0, 0, 0));
	spawncrate((-3285, -226, 144), (0, 0, 0));
	spawncrate((-3285, -166, 144), (0, 0, 0));
	spawncrate((-3285, -106, 144), (0, 0, 0));
	spawncrate((-3285, -46, 144), (0, 0, 0));
	spawncrate((-3285, 14, 144), (0, 0, 0));
	spawncrate((-3285, 74, 144), (0, 0, 0));
	spawncrate((-3285, 134, 144), (0, 0, 0));
	spawncrate((-3285, 194, 144), (0, 0, 0));
	spawncrate((-3285, 254, 144), (0, 0, 0));
	spawncrate((-3285, 314, 144), (0, 0, 0));
	spawncrate((-3285, 374, 144), (0, 0, 0));
	spawncrate((-3285, 434, 144), (0, 0, 0));
	spawncrate((-3285, 494, 144), (0, 0, 0));
	spawncrate((-3285, 554, 144), (0, 0, 0));
	spawncrate((-3285, 614, 144), (0, 0, 0));

	spawncrate((-3365, -466, 144), (0, 0, 0));
	spawncrate((-3365, -406, 144), (0, 0, 0));
	spawncrate((-3365, -346, 144), (0, 0, 0));
	spawncrate((-3365, -286, 144), (0, 0, 0));
	spawncrate((-3365, -226, 144), (0, 0, 0));
	spawncrate((-3365, -166, 144), (0, 0, 0));
	spawncrate((-3365, -106, 144), (0, 0, 0));
	spawncrate((-3365, -46, 144), (0, 0, 0));
	spawncrate((-3365, 14, 144), (0, 0, 0));
	spawncrate((-3365, 74, 144), (0, 0, 0));
	spawncrate((-3365, 134, 144), (0, 0, 0));
	spawncrate((-3365, 194, 144), (0, 0, 0));
	spawncrate((-3365, 254, 144), (0, 0, 0));
	spawncrate((-3365, 314, 144), (0, 0, 0));
	spawncrate((-3365, 374, 144), (0, 0, 0));
	spawncrate((-3365, 434, 144), (0, 0, 0));
	spawncrate((-3365, 494, 144), (0, 0, 0));
	spawncrate((-3365, 554, 144), (0, 0, 0));
	spawncrate((-3365, 614, 144), (0, 0, 0));

	spawncrate((-3445, -466, 144), (0, 0, 0));
	spawncrate((-3445, -406, 144), (0, 0, 0));
	spawncrate((-3445, -346, 144), (0, 0, 0));
	spawncrate((-3445, -286, 144), (0, 0, 0));
	spawncrate((-3445, -226, 144), (0, 0, 0));
	spawncrate((-3445, -166, 144), (0, 0, 0));
	spawncrate((-3445, -106, 144), (0, 0, 0));
	spawncrate((-3445, -46, 144), (0, 0, 0));
	spawncrate((-3445, 14, 144), (0, 0, 0));
	spawncrate((-3445, 74, 144), (0, 0, 0));
	spawncrate((-3445, 134, 144), (0, 0, 0));
	spawncrate((-3445, 194, 144), (0, 0, 0));
	spawncrate((-3445, 254, 144), (0, 0, 0));
	spawncrate((-3445, 314, 144), (0, 0, 0));
	spawncrate((-3445, 374, 144), (0, 0, 0));
	spawncrate((-3445, 434, 144), (0, 0, 0));
	spawncrate((-3445, 494, 144), (0, 0, 0));

	spawncrate((-3525, -286, 144), (0, 0, 0));
	spawncrate((-3525, -226, 144), (0, 0, 0));
	spawncrate((-3525, -166, 144), (0, 0, 0));
	spawncrate((-3525, -106, 144), (0, 0, 0));
	spawncrate((-3525, -46, 144), (0, 0, 0));
	spawncrate((-3525, 14, 144), (0, 0, 0));
	spawncrate((-3525, 74, 144), (0, 0, 0));
	spawncrate((-3525, 134, 144), (0, 0, 0));
	spawncrate((-3525, 194, 144), (0, 0, 0));
	spawncrate((-3525, 254, 144), (0, 0, 0));
	spawncrate((-3525, 314, 144), (0, 0, 0));
	spawncrate((-3525, 374, 144), (0, 0, 0));
	spawncrate((-3525, 434, 144), (0, 0, 0));
	spawncrate((-3525, 494, 144), (0, 0, 0));

	spawncrate((-3605, -346, 144), (0, 0, 0));
	spawncrate((-3605, -286, 144), (0, 0, 0));
	spawncrate((-3605, -226, 144), (0, 0, 0));
	spawncrate((-3605, -166, 144), (0, 0, 0));
	spawncrate((-3605, -106, 144), (0, 0, 0));
	spawncrate((-3605, -46, 144), (0, 0, 0));
	spawncrate((-3605, 14, 144), (0, 0, 0));
	spawncrate((-3605, 74, 144), (0, 0, 0));
	spawncrate((-3605, 134, 144), (0, 0, 0));
	spawncrate((-3605, 194, 144), (0, 0, 0));
	spawncrate((-3605, 254, 144), (0, 0, 0));
	spawncrate((-3605, 314, 144), (0, 0, 0));
	spawncrate((-3605, 374, 144), (0, 0, 0));
	spawncrate((-3605, 434, 144), (0, 0, 0));
	spawncrate((-3605, 494, 144), (0, 0, 0));
	spawncrate((-3605, 554, 144), (0, 0, 0));
	spawncrate((-3605, 614, 144), (0, 0, 0));
	spawncrate((-3605, 674, 144), (0, 0, 0));

	spawncrate((-3685, -406, 144), (0, 0, 0));
	spawncrate((-3685, -346, 144), (0, 0, 0));
	spawncrate((-3685, -286, 144), (0, 0, 0));
	spawncrate((-3685, -226, 144), (0, 0, 0));
	spawncrate((-3685, -166, 144), (0, 0, 0));
	spawncrate((-3685, -106, 144), (0, 0, 0));
	spawncrate((-3685, -46, 144), (0, 0, 0));
	spawncrate((-3685, 14, 144), (0, 0, 0));
	spawncrate((-3685, 74, 144), (0, 0, 0));
	spawncrate((-3685, 134, 144), (0, 0, 0));
	spawncrate((-3685, 194, 144), (0, 0, 0));
	spawncrate((-3685, 254, 144), (0, 0, 0));
	spawncrate((-3685, 314, 144), (0, 0, 0));
	spawncrate((-3685, 374, 144), (0, 0, 0));
    spawncrate((-3685, 434, 144), (0, 0, 0));
	spawncrate((-3685, 494, 144), (0, 0, 0));
	spawncrate((-3685, 554, 144), (0, 0, 0));
	spawncrate((-3685, 614, 144), (0, 0, 0));
	spawncrate((-3685, 674, 144), (0, 0, 0));

	spawncrate((-3765, -406, 144), (0, 0, 0));
	spawncrate((-3765, -346, 144), (0, 0, 0));
	spawncrate((-3765, -286, 144), (0, 0, 0));
	spawncrate((-3765, -226, 144), (0, 0, 0));
	spawncrate((-3765, -166, 144), (0, 0, 0));
	spawncrate((-3765, -106, 144), (0, 0, 0));
	spawncrate((-3765, -46, 144), (0, 0, 0));
	spawncrate((-3765, 14, 144), (0, 0, 0));
	spawncrate((-3765, 74, 144), (0, 0, 0));
	spawncrate((-3765, 134, 144), (0, 0, 0));
	spawncrate((-3765, 194, 144), (0, 0, 0));
	spawncrate((-3765, 254, 144), (0, 0, 0));
	spawncrate((-3765, 314, 144), (0, 0, 0));
	spawncrate((-3765, 374, 144), (0, 0, 0));
	spawncrate((-3765, 434, 144), (0, 0, 0));
	spawncrate((-3765, 494, 144), (0, 0, 0));
	spawncrate((-3765, 554, 144), (0, 0, 0));
	spawncrate((-3765, 614, 144), (0, 0, 0));

	spawncrate((-3845, -406, 144), (0, 0, 0));
	spawncrate((-3845, -346, 144), (0, 0, 0));
	spawncrate((-3845, -286, 144), (0, 0, 0));
	spawncrate((-3845, -226, 144), (0, 0, 0));
	spawncrate((-3845, -166, 144), (0, 0, 0));
	spawncrate((-3845, -106, 144), (0, 0, 0));
	spawncrate((-3845, -46, 144), (0, 0, 0));
	spawncrate((-3845, 14, 144), (0, 0, 0));
	spawncrate((-3845, 74, 144), (0, 0, 0));
	spawncrate((-3845, 134, 144), (0, 0, 0));
	spawncrate((-3845, 194, 144), (0, 0, 0));
	spawncrate((-3845, 254, 144), (0, 0, 0));
	spawncrate((-3845, 314, 144), (0, 0, 0));
	spawncrate((-3845, 374, 144), (0, 0, 0));
	spawncrate((-3845, 434, 144), (0, 0, 0));
	spawncrate((-3845, 494, 144), (0, 0, 0));
	spawncrate((-3845, 554, 144), (0, 0, 0));
	spawncrate((-3845, 614, 144), (0, 0, 0));
}

showdown_edit1() {
	
	level.meat_playable_bounds = [
		(-853.197, -1611.95, 382.886),
		(-852.416, -3492.46, 715.528),
		(1191.64, -3500.52, 618.622),
		(1204.48, -1620.88, 635.01)
	];

	mp_global_intermission = getent( "mp_global_intermission", "classname" );
	mp_global_intermission.origin = (90, -2693, 982);
	mp_global_intermission.angles = (12, 31, 3);

	CreateDoors((436, -2241, 450) /*open*/, (436, -2241, 365) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 1 /*height*/, 40 /*hp*/, 50 /*range*/);
	CreateDoors((-66, -2950, 340) /*open*/, (-66, -2950, 415) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 1 /*height*/, 20 /*hp*/, 60 /*range*/, 0 /*sideways*/);


	createPolygon();
	
	//tmg added shit
	spawncrate((-537, -2073, 340), (0, -90, 0));

	CreateTP((950, 401, 184),(652, -3338, 319), ( 0 , 90 , 0 ));
	CreateTP((-20, 1580, -2),(652, -3338, 319), ( 0 , 90 , 0 ));
	CreateTP((-947, -304, 184),(652, -3338, 319), ( 0 , 90 , 0 ));
	CreateTP((-536, 59, 0),(652, -3338, 319), ( 0 , 90 , 0 ));
	CreateTP((483, -100, 0),(652, -3338, 319), ( 0 , 90 , 0 ));
	CreateTP((4, -1943, 16),(652, -3338, 319), ( 0 , 90 , 0 ));

	// spawnmodel((3080, -1715, 115) , (0, -90, 0) , "btn_vista_buildings_05");
	spawnmodel((1913, -2195, 115) , (0, 180, 0) , "btn_vista_buildings_05");

	CreateinvisRamps((930, -2505, 235),(930, -2325, 293));
	CreateinvisRamps((885, -2505, 235),(885, -2325, 293));
	CreateinvisGrids((930, -2225, 304),(930, -2290, 304), (0,0,0));
	CreateinvisGrids((885, -2225, 304),(885, -2290, 304), (0,0,0));

	spawnmodel((907, -2416, 296) , (180, 0, -17) , "com_industrialtrashbin");
	spawnmodel((907, -2202, 330) , (180, 0, 0) , "com_industrialtrashbin");

	spawncrate((1100, -2555, 290), (0, -90, 0));
	spawncrate((1100, -2555, 350), (0, -90, 0));
	spawncrate((1100, -2555, 410), (0, -90, 0));
	spawncrate((1100, -2510, 290), (0, -90, 0));
	spawncrate((1100, -2510, 350), (0, -90, 0));
	spawncrate((1100, -2510, 410), (0, -90, 0));

	for(i = 0;i < 5;i++)
	spawncrate((970, -2230, 490) + (0,-60* i,0), (90, 0, 90));
	for(i = 0;i < 5;i++)
	spawncrate((970, -2230, 420) + (0,-60* i,0), (90, 0, 90)); 
	for(i = 0;i < 5;i++)
	spawncrate((970, -2230, 350) + (0,-60* i,0), (90, 0, 90));
	
	
	for(i = 0;i < 3;i++)
	spawncrate((970, -2350, 290) + (0,-60* i,0), (90, 0, 90)); 
	
	for(i = 0;i < 2;i++)
	spawncrate((1030, -2470, 290) + (60* i,0,0), (90, 0, 90)); 
	for(i = 0;i < 2;i++)
	spawncrate((1030, -2470, 350) + (60* i,0,0), (90, 0, 90)); 
	for(i = 0;i < 2;i++)
	spawncrate((1030, -2470, 420) + (60* i,0,0), (90, 0, 90)); 

	spawncrate((816, -2361, 390), (0, -90, 0));
	spawncrate((816, -2410, 390), (0, -90, 0));
	spawncrate((780, -2361, 390), (0, -90, 0));
	spawncrate((780, -2410, 390), (0, -90, 0));
	spawncrate((742, -2361, 390), (0, -90, 0));
	spawncrate((742, -2410, 390), (0, -90, 0));
	spawnmodel((803, -2380, 354) , (0, 0, 0) , "me_dumpster_close_sh");
	spawnmodel((755, -2381, 354) , (0, -180, 0) , "me_dumpster_close_sh");

	
	
	center_org = (-370, -2960, 267); dist = 45; up = 162; corners = 15;
	spawnmodel(center_org , (0, 0, 0) , "com_water_tank2_no_arab");
	spawncrate(center_org + (0,0,up), (90, 0, 0));

	spawncrate(center_org + (dist,0,up), (90, 0, 0));
	spawncrate(center_org + (dist -corners,dist -corners,up), (90, 45, 0));
	spawncrate(center_org + (0,dist,up), (90, 90, 0));
	spawncrate(center_org + (-dist +corners,dist -corners,up), (90, 135, 0));
	spawncrate(center_org + (-dist,0,up), (90, 180, 0));
	spawncrate(center_org + (-dist +corners,-dist +corners,up), (90, 225, 0));
	spawncrate(center_org + (0,-dist,up), (90, 270, 0));
	spawncrate(center_org + (dist -corners,-dist +corners,up), (90, 315, 0));

	center_org = (436, -3319, 526); dist = 28; up = 45; corners = 8;
	// spawncrate(center_org + (0,0,up), (90, 0, 0));
	spawncrate(center_org + (dist,0,up), (90, 0, 0));
	spawncrate(center_org + (dist -corners,dist -corners,up), (90, 45, 0));
	spawncrate(center_org + (0,dist,up), (90, 90, 0));
	spawncrate(center_org + (-dist +corners,dist -corners,up), (90, 135, 0));
	spawncrate(center_org + (-dist,0,up), (90, 180, 0));
	spawncrate(center_org + (-dist +corners,-dist +corners,up), (90, 225, 0));
	spawncrate(center_org + (0,-dist,up), (90, 270, 0));
	spawncrate(center_org + (dist -corners,-dist +corners,up), (90, 315, 0));
	
	spawncrate(center_org + (dist,0,up*2), (90, 0, 0));
	spawncrate(center_org + (dist -corners,dist -corners,up*2), (90, 45, 0));
	spawncrate(center_org + (0,dist,up*2), (90, 90, 0));
	spawncrate(center_org + (-dist +corners,dist -corners,up*2), (90, 135, 0));
	spawncrate(center_org + (-dist,0,up*2), (90, 180, 0));
	spawncrate(center_org + (-dist +corners,-dist +corners,up*2), (90, 225, 0));
	spawncrate(center_org + (0,-dist,up*2), (90, 270, 0));
	spawncrate(center_org + (dist -corners,-dist +corners,up*2), (90, 315, 0));


	spawncrate((742, -2361, 390), (0, -90, 0));


	spawnmodel((397, -2967, 319) , (0, 15, 0) , "crate_01_sh");
	spawnmodel((393, -2891, 319) , (0, -10, 0) , "crate_01_sh");
	spawnmodel((464, -3015, 319) , (0, -15, 0) , "crate_01_sh");
	spawnmodel((390, -2822, 319) , (0, -15, 0) , "crate_01_sh");
	spawnmodel((401, -2832, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((400, -2866, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((408, -2901, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((392, -2930, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((404, -2963, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((433, -2987, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((471, -2997, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((476, -3033, 381) , (0, 0, 0) , "dist_basket_wicker08_lod");
	spawnmodel((360, -3023, 319) , (0, -210, 0) , "me_satellitedish");

	i=0;
	spawncrate((392, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((392, -2790 + -50*i, 360), (0, 0, 0));
	i++;
	spawncrate((392, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((392, -2790 + -50*i, 355), (0, 0, 0));
	i++;
	spawncrate((392, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((392, -2790 + -50*i, 355), (0, 0, 0));
	i++;
	spawncrate((392, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((392, -2790 + -50*i, 355), (0, 0, 0));
	i++;
	spawncrate((392, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((392, -2790 + -50*i, 355), (0, 0, 0));
	spawncrate((470, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((470, -2790 + -50*i, 355), (0, 0, 0));
	i++;
	spawncrate((470, -2790 + -50*i, 410), (0, 0, 0));
	spawncrate((470, -2790 + -50*i, 355), (0, 0, 0));


	spawnmodel((810, -2820, 191) , (0, 0, 0) , "bri_tarp_plastic_ground_02");
	spawnmodel((900, -2860, 190) , (0, 180, 0) , "bri_tarp_plastic_ground_02");
	spawnmodel((990, -2820, 191) , (0, 0, 0) , "bri_tarp_plastic_ground_02");
	spawnmodel((1080, -2860, 190) , (0, 180, 0) , "bri_tarp_plastic_ground_02");
	spawnmodel((774, -2803, 194) , (90, -35, -35) , "me_corrugated_metal4x8");
	spawnmodel((866, -2803, 194) , (90, -35, -35) , "me_corrugated_metal4x8");
	spawnmodel((954, -2803, 194) , (90, -35, -35) , "me_corrugated_metal4x8");
	spawnmodel((1042, -2803, 194) , (90, -35, -35) , "me_corrugated_metal4x8");
	spawncrate((790, -2835, 211), (0, 90, 0));
	spawncrate((790, -2830, 215), (-35, 90, 0));
	spawncrate((835, -2850, 189), (40, 0, 0));
	spawnmodel((794, -2845, 229) , (0, -180, 90) , "me_corrugated_metal4x8");
	spawnmodel((853, -2849, 197) , (0, -90, 48) , "me_corrugated_metal4x8");
	spawnmodel((789, -2809, 229) , (0, -90, 0) , "me_stone_block01");

	spawnmodel((601, -3065, 317) , (0, 0, 0) , "me_stone_column_03");
	spawnmodel((615, -3065, 317) , (0, 0, 0) , "me_stone_column_03");
	spawnmodel((615, -3058, 317) , (0, -180, 0) , "me_stone_column_03");
	spawnmodel((601, -3058, 317) , (0, -180, 0) , "me_stone_column_03");
	spawnmodel((601, -3065, 417) , (0, 0, 0) , "me_stone_column_03");
	spawnmodel((615, -3065, 417) , (0, 0, 0) , "me_stone_column_03");
	spawnmodel((615, -3058, 417) , (0, -180, 0) , "me_stone_column_03");
	spawnmodel((601, -3058, 417) , (0, -180, 0) , "me_stone_column_03");
	spawncrate((606, -3060, 350), (90, 90, 0));
	spawncrate((606, -3060, 420), (90, 90, 0));
	spawncrate((606, -3060, 490), (90, 90, 0));
	spawnmodel((609, -3063, 517) , (0, 0, 0) , "com_cardboardboxshortclosed_1");

	spawnmodel((645, -3059, 317) , (27, 90, 0) , "me_canopy_04");
	spawnmodel((645, -3169, 317) , (27, -90, 0) , "me_canopy_04");
	spawnmodel((645, -3169, 317) , (27, 90, 0) , "me_canopy_04");
	spawnmodel((645, -3279, 317) , (27, -90, 0) , "me_canopy_04");
	spawnmodel((645, -3279, 317) , (27, 90, 0) , "me_canopy_04");
	spawnmodel((645, -3389, 317) , (27, -90, 0) , "me_canopy_04");
	CreateinvisGrids((680, -3085, 304),(680, -3375, 304), (0,0,0));
	CreateinvisGrids((625, -3085, 304),(625, -3375, 304), (0,0,0));
	spawnmodel((650, -3388, 318) , (0, 90, 0) , "me_iron_gate");
	spawncrate((680, -3405, 350), (0, 0, 90));
	spawncrate((625, -3405, 350), (0, 0, 90));
	spawncrate((680, -3405, 410), (0, 0, 90));
	spawncrate((625, -3405, 410), (0, 0, 90));

	spawnmodel((589, -3450, 459) , (0, -90, 0) , "me_supermarket_sign");
	spawnmodel((589, -3452, 335) , (0, -90, 0) , "me_supermarket_sign");
	spawncrate((590, -3445, 480), (90, 90, 0));
	spawncrate((590, -3445, 420), (90, 90, 0));
	spawncrate((590, -3445, 360), (90, 90, 0));

	spawncrate((696, -3475, 540) , (90, 0, 0));
	spawncrate((696, -3475, 600) , (90, 0, 0));
	spawnmodel((698, -3485, 545) , (0, 45, 0) , "me_corrugated_metal2x8");

	spawnmodel((655, -2785, 267) , (-11, -90, 0) , "com_wagon_donkey");
	spawnmodel((675, -2785, 255) , (0, 0, 0) , "me_stone_block01");
	spawnmodel((638, -2785, 255) , (0, 0, 0) , "me_stone_block01");
	spawnmodel((655, -2725, 275) , (0, 0, 60) , "me_corrugated_metal4x8");
	CreateinvisRamps((655, -2715, 250),(655, -2790, 291));



	CreateinvisGrids((680, -3085, 511),(680, -3445, 511), (0,0,0));
	CreateinvisGrids((625, -3085, 511),(625, -3445, 511), (0,0,0));


	//door
	// spawncrate((471, -2235, 341), (0, -92, 0),"com_plasticcase_friendly");
	// spawncrate((471, -2283, 342), (0, -91, 0),"com_plasticcase_friendly");
	// spawncrate((471, -2324, 341), (0, -90, 0),"com_plasticcase_friendly");

	spawnmodel((395, -2145, 231) , (0, 0, 0) , "com_water_tank1_stand");
	spawnmodel((395, -2235, 231) , (0, 0, 0) , "com_water_tank1_stand");
	spawnmodel((395, -2260, 321) , (0, -90, 90) , "me_corrugated_metal4x8"); i=1;
	spawnmodel((395, -2260 + (45*i), 321) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel((395, -2260 + (45*i), 321) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel((395, -2260 + (45*i), 321) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawncrate((430, -2100, 353), (0, 0, 0));
	spawncrate((380, -2100, 353), (0, 0, 0));
	spawncrate((430, -2050, 353), (0, 0, 0));
	spawncrate((380, -2050, 353), (0, 0, 0));
	spawncrate((430, -2127, 335), (0, 0, 45));
	spawncrate((380, -2127, 335), (0, 0, 45));
	CreateinvisGrids((380, -2265, 304),(380, -2120, 304), (0,0,0));
	spawnmodel((395, -2144, 335) , (45, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((395, -2131, 349) , (45, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((395, -2091, 365) , (0, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((395, -2043, 365) , (0, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((395, -2285, 341) , (90, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((395, -2286, 370) , (90, -90, 90) , "me_corrugated_metal4x8");
	spawncrate((415, -2300, 377), (0, 0, -90));
	spawncrate((375, -2300, 377), (0, 0, -90));
	spawncrate((415, -2300, 337), (0, 0, -90));
	spawncrate((375, -2300, 337), (0, 0, -90));

	org = (130, -2104, 425); i = 0;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-45*i,0,0) , (0, 0, 0) , "me_corrugated_metal4x8"); i++;
	CreateinvisWalls((137, -2120, 400),(-100, -2120, 400));
	CreateinvisWalls((137, -2120, 447),(-100, -2120, 447));

	org = (862, -2445, 271.25); i=0;
	spawnmodel(org + (0,45*i,0) , (0, 90, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,45*i,0) , (0, 90, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,45*i,0) , (0, 90, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,45*i,0) , (0, 90, 0) , "me_corrugated_metal4x8"); i++;

	spawnmodel((-355, -2190, -10) , (0, 0, 0) , "me_telegraphpole");
	spawnmodel((-425, -2190, -10) , (0, 0, 0) , "me_telegraphpole");
	spawnmodel((-355, -2360, -62) , (0, 0, 0) , "me_telegraphpole");
	spawnmodel((-425, -2360, -62) , (0, 0, 0) , "me_telegraphpole");
	spawnmodel((-387, -2220, 327) , (0, 0, -74) , "me_corrugated_metal4x8");
	spawnmodel((-387, -2307, 301) , (0, 0, -74) , "me_corrugated_metal4x8");
	spawnmodel((-387, -2144, 349) , (0, 0, -74) , "me_corrugated_metal4x8");
	spawnmodel((-387, -2396, 276) , (0, 0, -76) , "me_corrugated_metal4x8");
	spawnmodel((-387, -2485, 259) , (0, 0, -83) , "me_corrugated_metal4x8");
	CreateinvisRamps((-387, -2099, 344),(-387, -2459, 240));
	spawncrate((-507, -2085, 352), (0, 0, 0));
	spawncrate((-447, -2085, 352), (0, 0, 0));
	spawncrate((-387, -2085, 352), (0, 0, 0));
	spawncrate((-387, -2050, 352), (0, 0, 0));
	spawnmodel((-440, -2081, 361) , (0, -270, 90) , "me_corrugated_metal4x8");
	spawnmodel((-498, -2080, 362) , (0, -270, 90) , "me_corrugated_metal4x8");




	CreateInvisRamps((-235, -3160, 370),(-75, -3160, 500));
	spawnmodel((-51, -3204, 500) , (0, -90, 0) , "com_trashchuteslide");

	spawnmodel((-32, -3103, 382) , (0, 0, 180) , "me_dumpster_close_sh");
	spawnmodel((-32, -3198, 382) , (0, 0, 180) , "me_dumpster_close_sh");
	spawnmodel((-32, -3293, 382) , (0, 0, 180) , "me_dumpster_close_sh");
	spawnmodel((-13, -3056, 399) , (-90, 0, 0) , "me_corrugated_metal4x8");
	spawnmodel((-13, -3342, 399) , (-90, 180, 0) , "me_corrugated_metal4x8");
	spawnmodel((-60, -3294, 399) , (-90, 90, 0) , "me_corrugated_metal4x8"); i=1;
	spawnmodel((-60, -3294 + 95*i, 399) , (-90, 90, 0) , "me_corrugated_metal4x8"); i++;
	spawnmodel((-60, -3294 + 95*i, 399) , (-90, 90, 0) , "me_corrugated_metal4x8"); i++;

	org = (638, -3077, 527); i = 0;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (0,-45*i,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;

	spawnmodel((469, -3055, 492) , (0, 90, 0) , "me_canopy_large3");
	spawnmodel((228, -3055, 492) , (0, 90, 0) , "me_canopy_large3");
	spawnmodel((704, -3105, 510) , (0, -180, 0) , "me_canopy_large3");
	spawnmodel((704, -3347, 510) , (0, -180, 0) , "me_canopy_large3");

	spawnmodel((472, -3450, 495) , (0, -90, 0) , "me_canopy_large3");
	spawnmodel((530, -3065, 525) , (0, 0, 180) , "me_sign_shakar");
	spawnmodel((411, -3065, 525) , (0, 0, 180) , "me_sign_shakar");
	spawnmodel((292, -3065, 525) , (0, 0, 180) , "me_sign_shakar");
	spawnmodel((173, -3065, 525) , (0, 0, 180) , "me_sign_shakar");
	spawnmodel((54, -3065, 525) , (0, 0, 180) , "me_sign_shakar");

	spawncrate((-36, -3071, 344) , (0, 180, 90));

	spawnmodel((-44, -2947, 332) , (90, -180, 0) , "com_industrialtrashbin");

	CreateinvisRamps((12, -2950, 293),(-42, -2950, 343));
	spawnmodel((-13, -2950, 362) , (133, -180, 0) , "dist_wheelbarrow_lod");

	CreateinvisGrids((-480, -2820, 240),(-160, -2820, 240), (0,0,0));
	CreateinvisRamps((-210, -2833, 220),(-140, -2833, 290));
	spawnmodel((-173, -2832, 238) , (0, 0, -90) , "me_sign_miscshopsign");
	spawnmodel((-133, -2832, 279) , (-90, 0, -90) , "me_sign_miscshopsign");
	org = (-180, -2824, 253); i = 0;
	spawnmodel(org + (-95*i,0,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-95*i,0,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-95*i,0,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;
	spawnmodel(org + (-95*i,0,0) , (0, -90, 90) , "me_corrugated_metal4x8"); i++;

	spawnmodel((-546, -2063, 338) , (90, -90, 0) , "me_corrugated_metal4x8");
	spawnmodel((-832, -2063, 338) , (90, -270, 0) , "me_corrugated_metal4x8");

	i=0;
	spawnmodel((-594 + -95*i, -2110, 338) , (90, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((-594 + -95*i, -2086, 326) , (0, -90, 90) , "me_corrugated_metal4x8"); //floor
	i++;
	spawnmodel((-594 + -95*i, -2110, 338) , (90, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((-594 + -95*i, -2086, 326) , (0, -90, 90) , "me_corrugated_metal4x8"); //floor
	i++;
	spawnmodel((-594 + -95*i, -2110, 338) , (90, -90, 90) , "me_corrugated_metal4x8");
	spawnmodel((-594 + -95*i, -2086, 326) , (0, -90, 90) , "me_corrugated_metal4x8"); //floor



	spawnmodel((145, -4547, 436) , (0, 40, 0) , "vehicle_bulldozer");
	spawnmodel((177, -4396, 469) , (90, -60, -190) , "me_statue");
	spawnmodel((-62, -2745, 634) , (0, 0, 0) , "me_statue");
	//spawnmodel((366, -2595, -88) , (0, 0, 0) , "me_mosque_tower02");
	spawnmodel((592, -2541, 20) , (0, 0, 0) , "foliage_tree_palm_bushy_1_static");
	spawnmodel((-319, -2426, 0) , (0, 0, 0) , "foliage_tree_palm_med_1");

	spawnmodel((-921, -2033, -53 -500) , (0, 60, 0) , "com_tower_crane");
	spawnmodel((137, -2638, 1438 -500) , (180, -10, 0) , "me_statue");
	spawnmodel((126, -2630, 1480 -500) , (50, -202, 0) , "com_hatchet");

	spawnmodel((-285, -3301, 343) , (0, 0, 0) , "mil_razorwire_mid");
	spawnmodel((-504, -3257, 343) , (0, -20, 0) , "mil_razorwire_mid");
	spawnmodel((-570, -3036, 340) , (0, -70, 0) , "mil_razorwire_mid");
	spawnmodel((462, -3620, 435) , (0, 0, 0) , "mil_razorwire_mid");
	spawnmodel((252, -3621, 436) , (0, 0, 0) , "mil_razorwire_mid");
	spawnmodel((281, -2169, 8) , (0, -70, 0) , "mil_razorwire_mid");
	spawnmodel((188, -2206, 7) , (0, -160, 0) , "mil_razorwire_mid");
	spawnmodel((-193, -2366, 7) , (0, -205, 0) , "mil_razorwire_mid");
	spawnmodel((-648, -2199, 7) , (0, -120, 0) , "mil_razorwire_mid");
	spawnmodel((231, -2550, -12) , (0, -120, 0) , "mil_razorwire_mid");
	spawnmodel((565, -2687, -22) , (0, -170, 0) , "mil_razorwire_mid");
	spawnmodel((600, -2498, 119) , (0, -180, 0) , "mil_razorwire_mid");
	spawnmodel((405, -2498, 119) , (0, -180, 0) , "mil_razorwire_mid");
	spawnmodel((218, -2495, 127) , (0, -180, 0) , "mil_razorwire_mid");

	CreateDeathRegion((-1674, -2008, 167), (2191, -4910, -460));
	CreateDeathRegion((-832, -2008, 167), (-1589, -1470, -460));
	CreateDeathRegion((-522, -2463, -6), (-828, -2974, 546));
	CreateDeathRegion((-29, -3079, 246), (-478, -3397, 305));
}

rust_edit1() {
	CreateTP((1752, 1659, -129),(715, 992, 268), ( 0 , 135 , 0 ));

	//spawnkill block rocks
	spawnmodel((61, 1745, -240) , (0, 0, 0) , "afch_bigrock_01");
	spawnmodel((-36, 1625, -124) , (0, 30, 0) , "afch_bigrock_01");
	spawnmodel((27, 1468, -130) , (0, 162, 0) , "afch_bigrock_01");
	spawnmodel((140, 1580, -185) , (0, 272, -60) , "afch_bigrock_01");
	
	//added shit(not clippy)
	createHiddenTP((766.7, 788, 180), (1626, -210.7, -200), ((0, 135, 0)), undefined,1, 10);
	spawncrate((948, 896, 151) , (90, 0, 0));//wallbreach stuck spot
	spawncrate((890, 1023, 200) , (90, 0, 0));//rock fill
	spawncrate((932, 1023, 200) , (90, 0, 0));//rock fill

	disable_spawn_array = [];
	disable_spawn_array[disable_spawn_array.size] = (-193, -208.5, -235.886);
	disable_spawn_array[disable_spawn_array.size] = (-432, 981, -231.436);
	disable_spawn_array[disable_spawn_array.size] = (1188, 1772, -228.019);
	disable_spawn_array[disable_spawn_array.size] = (1572, -68, -233.264);
	disable_spawn_array[disable_spawn_array.size] = (1436, -164, -231.628);
	disable_spawn_array[disable_spawn_array.size] = (1516, 844, -231.37);
	disable_spawn_array[disable_spawn_array.size] = (1434, 1388.5, -239.875);
	disable_spawn_array[disable_spawn_array.size] = (579, -20, -220.975);
	disable_spawn_array[disable_spawn_array.size] = (-200, 1752, -237.285);
	disable_spawn_point(disable_spawn_array);

	
	add_spawn_point((-205, 1715, -229),(0, 180, 0));
	add_spawn_point((-155, 1772, -239),(0, 180, 0));
	add_spawn_point((-133, 1718, -230),(0, 180, 0));
	add_spawn_point((-140, 1789, -240),(0, 180, 0));
	add_spawn_point((-272, 1789, -243),(0, 180, 0));
	add_spawn_point((-318, 1715, -234),(0, 180, 0));
	add_spawn_point((-320, 1783, -244),(0, -142, 0));

	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn");
	

	spawnmodel((182, 1321, -234) , (0, -255, -10) , "vehicle_ch46e_damaged_front_piece");
	spawnmodel((204, 1161, -237) , (0, 90, 0) , "vehicle_ch46e_damaged_rear_piece");
	spawnmodel((162, 937, -235) , (-28, -8, 12) , "com_plasticcase_beige_big");
	spawnmodel((218, 929, -238) , (-20, 96, 0) , "com_plasticcase_beige_big");
	spawnmodel((111, 608, -244) , (2, -90, 0) , "vehicle_opfor_truck");
	spawnmodel((207, 439, -188) , (90, 0, 0) , "me_corrugated_metal4x8_holes");
	spawnmodel((315, 438, -186) , (90, -180, 0) , "me_corrugated_metal4x8_holes");
	spawnmodel((162, 487, -186) , (90, 90, 0) , "me_corrugated_metal4x8_holes");
	spawnmodel((450, 362, -208) , (0, 120, -81) , "vehicle_pickup_destroyed_static");
	spawnmodel((602, 204, -83) , (-10, -250, -180) , "afch_bigrock_01");
	spawnmodel((603, 329, -233) , (0, -52, -80) , "afch_flatrock_01");
	spawnmodel((515, 88, -238) , (0, -68, 0) , "concrete_barrier_damaged_2");
	spawnmodel((242, 36, -217) , (0, -60, -90) , "afch_flatrock_01");
	spawnmodel((-136, 1359, -96) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((-182, 1407, -96) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((-40, 1359, -96) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((56, 1359, -96) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((-182, 1503, -96) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((-107, 1717, -193) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((-107, 1813, -193) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((-144, 1685, -82) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((-107, 1717, -97) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((-231, 399, -194) , (0, -54, 0) , "me_corrugated_metal8x8");
	spawnmodel((-290, 466, -194) , (0, -45, 0) , "me_corrugated_metal8x8");

	spawnmodel((1023, 617, -246) , (45, -428, 10) , "afch_bigrock_01");
	spawnmodel((1133, 650, -227) , (-90, 0, -10) , "rock_tan_boulder_3");
	spawnmodel((1007, 458, -206) , (0, -2, -100) , "afch_flatrock_01");
	spawnmodel((1160, 493, -237) , (0, 0, 0) , "com_bomb_objective");
	spawnmodel((1125, 509, -198) , (-110, 0, -10) , "rock_tan_boulder_3");
	spawnmodel((896, 436, -240) , (0, 0, 0) , "com_barrel_black_rust");
	spawnmodel((850, 1284, -248) , (0, -80, 10) , "vehicle_mack_truck_short_white_destroy");
	spawnmodel((902, 1429, -219) , (0, 24, -90) , "com_barrel_black_rust");
	spawnmodel((905, 1080, -198) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((926, 993, -198) , (0, -60, 0) , "me_corrugated_metal8x8");
	spawnmodel((1017, 864, -200) , (0, -73, 0) , "me_corrugated_metal8x8");
	spawnmodel((987, 928, -200) , (0, -51, 0) , "me_corrugated_metal4x8_holes");

	spawnmodel((552, 1478, -216) , (0, -54, -72) , "vehicle_pickup_destroyed_static");
	spawnmodel((509, 1521, -235) , (0, 0, 0) , "com_barrel_black_rust");
	spawnmodel((548, 1690, -186) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((548, 1786, -186) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((548, 1618, -186) , (0, 90, 0) , "me_corrugated_metal4x8_holes");

	spawnmodel((2227, 1555, -87) , (-10, -20, 0) , "afch_bigrock_01"); //maybe
	spawnmodel((2230, 1723, -105) , (-10, -20, 0) , "afch_bigrock_01"); //maybe
	
	//spawnmodel((676, -139, 1044) , (0, 0, 0) , "oilrig_storage_tank_01_support_ring"); //maybe?
	// spawnmodel((1757, 1655, -99) , (-90, 10, -10) , "oilrig_storage_tank_01_support_ring"); //maybe?
	// spawnmodel((1650, 1654, -97) , (-90, 10, -10) , "oilrig_storage_tank_01_support_ring"); //maybe?

	spawnmodel((1271, 1584, -92) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1354, 1583, -198) , (0, -90, -90) , "com_woodlog_24_192_b");
	spawnmodel((1186, 1586, -198) , (0, -90, -90) , "com_woodlog_24_192_b");
	spawnmodel((1350, 1701, -198) , (0, -90, -90) , "com_woodlog_24_192_b");
	spawnmodel((1177, 1699, -200) , (0, -90, -90) , "com_woodlog_24_192_b");
	spawnmodel((1270, 1609, -92) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1265, 1633, -90) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1268, 1655, -91) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1265, 1679, -93) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1265, 1702, -92) , (0, -90, 0) , "com_woodlog_24_192_b");
	spawnmodel((1313, 1579, -149) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1232, 1579, -149) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1353, 1642, -149) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((1305, 1703, -151) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1215, 1703, -151) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1180, 1642, -150) , (0, -90, 0) , "me_corrugated_metal8x8");
	spawnmodel((1083, 1584, -92) , (0, -90, 0) , "com_woodlog_24_192_b");

	spawnmodel((1494, 799, -134) , (0, 0, 0) , "concrete_barrier_damaged_2");


	//flooring ontop
	spawnmodel((504, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((600, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((696, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((792, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((888, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((984, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1080, 620, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");

	spawnmodel((1128, 667, 120) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((1128, 763, 120) , (-90, 90, 0) , "me_corrugated_metal8x8");

	spawnmodel((984, 810, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1080, 810, 120) , (-90, 0, 0) , "me_corrugated_metal8x8");

	spawnmodel((456, 667, 120) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((456, 763, 120) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((456, 859, 120) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((456, 1060, 243) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((456, 1156, 243) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((504, 1203, 243) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((600, 1203, 243) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((696, 1203, 243) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((792, 1203, 243) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((888, 1203, 243) , (-90, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((936, 1060, 243) , (-90, 90, 0) , "me_corrugated_metal8x8");
	spawnmodel((936, 1156, 243) , (-90, 90, 0) , "me_corrugated_metal8x8");



	spawnmodel((504, 1060, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((504, 1156, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((600, 1156, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((696, 1156, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((792, 1156, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((792, 1060, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((888, 1060, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((888, 1156, 263) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((905, 859, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((905, 955, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((940, 1009, 229) , (0, 0, 90) , "com_woodlog_24_192_a");
	spawnmodel((940, 1009, 37) , (0, 0, 90) , "com_woodlog_24_192_a");
	spawnmodel((504, 976, 233) , (40, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((504, 903, 172) , (40, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((504, 859, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((504, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((504, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((696, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((600, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((600, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((696, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((792, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((792, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((600, 859, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((888, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((984, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((1080, 763, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((1080, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((984, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((888, 667, 140) , (0, -90, 90) , "me_corrugated_metal8x8");
	spawnmodel((681, 224, -210) , (-110, 0, -10) , "rock_tan_boulder_3");
	spawnmodel((665, 854, 139) , (0, 180, 90) , "me_corrugated_metal4x8_holes");
	spawnmodel((602, 966, 266) , (0, 90, 90) , "me_corrugated_metal8x8");
	spawnmodel((601, 905, 174) , (-90, 114, 66) , "me_corrugated_metal8x8");
	spawnmodel((601, 911, 243) , (72, 270, 90) , "me_corrugated_metal4x8_holes");
	spawnmodel((553, 966, 219) , (-90, 24, 66) , "me_corrugated_metal8x8");
	

	CreateinvisGrids((1100, 635, 128),(480, 635, 128), (0,0,0));
	CreateinvisGrids((1100, 670, 128),(480, 670, 128), (0,0,0));
	CreateinvisGrids((1100, 705, 128),(480, 705, 128), (0,0,0));
	CreateinvisGrids((1100, 740, 128),(480, 740, 128), (0,0,0));
	CreateinvisGrids((1100, 775, 128),(480, 775, 128), (0,0,0));

	CreateinvisGrids((640, 810, 128),(480, 810, 128), (0,0,0));
	CreateinvisGrids((640, 845, 128),(480, 845, 128), (0,0,0));
	CreateinvisGrids((640, 880, 128),(480, 880, 128), (0,0,0));

	CreateinvisGrids((1100, 810, 128),(885, 810, 128), (0,0,0));
	CreateinvisGrids((925, 845, 128),(885, 845, 128), (0,0,0));
	CreateinvisGrids((925, 880, 128),(885, 880, 128), (0,0,0));
	CreateinvisGrids((925, 915, 128),(885, 915, 128), (0,0,0));
	CreateinvisGrids((925, 950, 128),(885, 950, 128), (0,0,0));
	CreateinvisGrids((925, 985, 128),(885, 985, 128), (0,0,0));

	//upper part
	spawncrate((480, 1030, 254) , (0, 0, 0));
	spawncrate((480, 1070, 254) , (0, 0, 0));
	spawncrate((480, 1110, 254) , (0, 0, 0));
	CreateinvisGrids((915, 1030, 254),(780, 1030, 254), (0,0,0));
	CreateinvisGrids((915, 1070, 254),(780, 1070, 254), (0,0,0));
	CreateinvisGrids((915, 1110, 254),(780, 1110, 254), (0,0,0));
	CreateinvisGrids((915, 1150, 254),(480, 1150, 254), (0,0,0));
	CreateinvisGrids((915, 1190, 254),(480, 1190, 254), (0,0,0));

	//at ladder
	spawncrate((580, 980, 254) , (0, 0, 0));
	spawncrate((580, 940, 254) , (0, 0, 0));
	spawncrate((635, 980, 254) , (0, 0, 0));
	spawncrate((635, 940, 254) , (0, 0, 0));

	CreateinvisRamps((480, 880, 140),(480, 1008, 237));
	CreateinvisRamps((520, 880, 140),(520, 1008, 237));
	CreateinvisWalls((570, 920, 140),(650, 920, 140));
	CreateinvisWalls((570, 920, 190),(650, 920, 190));
	CreateinvisWalls((570, 925, 230),(650, 925, 230), (0,0,70));

	//all main blocking walls
	spawncrate((122, 900, -130), (90, 0, 0));
	CreateinvisWalls((155, 930, -215),(130, 1360, -215));
	CreateinvisWalls((155, 930, -145),(130, 1360, -145));
	spawncrate((-136, 1325, -70), (0, 90, 0));
	CreateinvisWalls((-176, 1511, -74),(-175, 1364, -74));
	CreateinvisWalls((-175, 1364, -74),(93, 1366, -74));
	spawncrate((-181, 1711, -110), (0, -180, 0));
	CreateinvisWalls((-87, 1791, -210),(-86, 1698, -210));
	CreateinvisWalls((-87, 1791, -170),(-86, 1698, -170));
	CreateinvisWalls((80, 722, -220),(80, 500, -220)); // wall at truck 1
	CreateinvisWalls((80, 722, -160),(80, 500, -160)); // wall at truck 1
	spawncrate((126, 500, -210), (0, 0, 0));
	spawncrate((126, 500, -140), (0, 0, 0));
	spawncrate((168, 458, -140), (0, 90, 0));
	spawncrate((230, 444, -140), (0, 0, 0));
	spawncrate((310, 444, -140), (0, 0, 0));

	CreateinvisWalls((375, 406, -220),(548, 56, -220));
	CreateinvisWalls((375, 406, -160),(548, 56, -160));

	spawncrate((298, -17, -130), (0, 122, 0));
	spawncrate((256, 51, -130), (0, 122, 0));
	spawncrate((210, 118, -130), (0, 132, 0));
	spawncrate((298, -17, -190), (0, 122, 0));
	spawncrate((256, 51, -190), (0, 122, 0));
	spawncrate((210, 118, -190), (0, 132, 0));

	spawncrate((429, -115, -125), (0, 0, 0));
	spawncrate((429, -75, -125), (0, 0, 0));
	spawncrate((429, -27, -125), (0, 0, 0));

	// door here
	CreateDoors((535, -160, -70) /*open*/, (535, -160, -190) /*close*/, (90,0,0) /*angle*/, 2 /*size*/, 2 /*height*/, 25 /*hp*/, 60 /*range*/, 1 /*sideways*/);

	CreateinvisWalls((680, 87, -220),(680, 423, -220));
	CreateinvisWalls((680, 87, -150),(680, 423, -150));
	CreateinvisWalls((734, 420, -100),(929, 420, -100));

	CreateinvisWalls((965, 460, -210),(1160, 460, -210));
	CreateinvisWalls((965, 460, -150),(1160, 460, -150));

	CreateinvisWalls((1165, 512, -180),(1165, 587, -180));
	CreateinvisWalls((1165, 470, -130),(1165, 587, -130));
	spawncrate((1130, 630, -120), (90, 0, 0));
	CreateinvisWalls((1120, 587, -210),(1120, 674, -210));

	spawncrate((1144, 676, -109), (0, 0, 0));
	spawncrate((1153, 676, -9), (0, -0, 0));

	spawnmodel((1220, 792, -188) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1316, 792, -188) , (0, 0, 0) , "me_corrugated_metal8x8");
	spawnmodel((1412, 792, -188) , (0, 0, 0) , "me_corrugated_metal8x8");
	CreateinvisWalls((1197, 800, -205),(1429, 800, -205));
	CreateinvisWalls((1197, 800, -150),(1429, 800, -150));
	CreateinvisWalls((1635, 800, -100),(1200, 800, -100));
	//door here
	CreateDoors((1508, 797, -70) /*open*/, (1508, 797, -195) /*close*/, (90,90,0) /*angle*/, 2 /*size*/, 2 /*height*/, 25 /*hp*/, 60 /*range*/, 1 /*sideways*/);

	CreateinvisWalls((1463, 846, -100),(1463, 1027, -100));
	CreateinvisWalls((1496, 1035, -100),(1642, 1035, -100));

	spawncrate((1000, 854, -190), (90, 20, 0));
	spawncrate((906, 987, -200), (0, 125, 0));
	spawncrate((906, 987, -150), (0, 125, 0));

	CreateinvisWalls((890, 1124, -210),(890, 1450, -210));
	CreateinvisWalls((890, 1124, -150),(890, 1450, -150));
	CreateinvisWalls((874, 1461, -210),(804, 1432, -210));
	CreateinvisWalls((874, 1461, -150),(804, 1432, -150));

	CreateinvisWalls((643, 1439, -210),(552, 1590, -210));
	CreateinvisWalls((643, 1439, -150),(552, 1590, -150));
	CreateinvisWalls((537, 1719, -210),(536, 1819, -210));
	CreateinvisWalls((537, 1719, -150),(536, 1819, -150));
	spawncrate((537, 1655, -185), (90, 0, 0));

	spawnmodel((1559, 1259, -185) , (180, -176, -90) , "afch_flatrock_01");
	spawnmodel((1424, 1265, -191) , (-180, -182, -90) , "afch_flatrock_01");
	spawnmodel((1650, 1137, -173) , (180, -87, -90) , "afch_flatrock_01");
	CreateinvisWalls((1450, 1240, -210),(1620, 1240, -210));
	CreateinvisWalls((1450, 1240, -150),(1620, 1240, -150));

	spawncrate((1599, 1581, -70), (0, 0, 0));

	spawncrate((1340, 1610, -170), (0, -90, 0));
	spawncrate((1290, 1610, -170), (0, -90, 0));
	spawncrate((1240, 1610, -170), (0, -90, 0));
	spawncrate((1190, 1610, -170), (0, -90, 0));
	spawncrate((1340, 1680, -170), (0, -90, 0));
	spawncrate((1290, 1680, -170), (0, -90, 0));
	spawncrate((1240, 1680, -170), (0, -90, 0));
	spawncrate((1190, 1680, -170), (0, -90, 0));
	spawncrate((1340, 1610, -105), (0, -90, 0));
	spawncrate((1290, 1610, -105), (0, -90, 0));
	spawncrate((1240, 1610, -105), (0, -90, 0));
	spawncrate((1190, 1610, -105), (0, -90, 0));
	spawncrate((1340, 1680, -105), (0, -90, 0));
	spawncrate((1290, 1680, -105), (0, -90, 0));
	spawncrate((1240, 1680, -105), (0, -90, 0));
	spawncrate((1190, 1680, -105), (0, -90, 0));

	spawncrate((1090, 1590, -105), (0, 0, 0));
	spawncrate((1140, 1590, -105), (0, 0, 0));

	spawnmodel((1049, 700, 95) , (183, 14, 0) , "afch_bigrock_01");
	spawnmodel((1033, 776, 96) , (183, 4, 0) , "afch_bigrock_01");
	spawnmodel((571, 693, 101) , (183, -161, 0) , "afch_bigrock_01");
	spawnmodel((542, 933, 167) , (40, -432, -178) , "afch_bigrock_01");
	spawnmodel((680, 1044, 95) , (-10, 0, -80) , "afch_bigrock_01");
	spawnmodel((854, 1015, 5) , (-10, -70, -80) , "afch_bigrock_01");
	spawnmodel((495, 1039, 0) , (20, -95, -90) , "afch_flatrock_01");
	spawnmodel((820, 1124, 257) , (183, 14, 0) , "afch_bigrock_01");

	spawnmodel((632, 450, -199) , (15, -180, -90) , "afch_flatrock_01");
	spawnmodel((565, 1123, 235) , (183, -180, 0) , "afch_bigrock_01");
	spawnmodel((907, 1039, 158) , (-58, 94, 0) , "rock_tan_boulder_3");
	spawnmodel((819, 711, 20) , (21, 3, 108) , "afch_bigrock_01");
	spawnmodel((631, 575, -39) , (0, -5, -111) , "afch_flatrock_01");

	CreateDeathRegion((898, 1427, -500), (162, 435, 60));
	CreateDeathRegion((1200, 583, -60), (424, 855, 60));
	CreateDeathRegion((1000, 1730, -60), (424, 855, 60));
	CreateDeathRegion((544, 1864, -500), (-105, 1360, 60));
	CreateDeathRegion((497, 118, -500), (690, 567, 60));
	CreateDeathRegion((1134, 463, -500), (926, 686, 60));
}

DerRiese_edit1() {

	CreateDeathRegion((-195, 400, 180),(74, 700, 350));
	moveac130position((334, -1557, 0));
	for(i = 0;i < 2;i++)
	spawncrate((-82, 475, 153)+(60* i, 0, 0) , (-90, 0, 0)); //pap blocker
	for(i = 0;i < 2;i++)
	spawncrate((-45, -2267, 104)+(0, -80* i, 0) , (0, -90, 0));
	CreateDoors((500, -1999, 130) /*open*/,(262, -1999, 130) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 35 /*hp*/, 90 /*range*/, 1 /*sideways*/);
	CreateDoors((-67, -2230, 175) /*open*/,(-67, -2091, 175) /*close*/, (90,0,0) /*angle*/, 2 /*size*/, 2 /*height*/, 25 /*hp*/, 50 /*range*/, 1 /*sideways*/);
	spawncrate((377, -2380, 153) , (0, 0, -84) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((154, -2382, 109)+(-55* i, 0, 0) , (0, 0, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((154, -2382, 148)+(-55* i, 0, 0) , (0, 0, -90) , "com_plasticcase_friendly");
	for(i = 0;i < 2;i++)
	spawncrate((154, -2382, 178)+(-55* i, 0, 0) , (0, 0, -90) , "com_plasticcase_friendly");
	createhiddenTP((-145, -3096.6, 193), (-408, -2269, 156), (0,45,0), undefined,undefined,20,120);
	
	createTP((630, 178, 60), (508, -814, 70), (0,300,0), 1, undefined);
	createTP((-588, -81, 63), (21.8, -969.9, 70), (0,334,0), 1, undefined);
 }

 firingrange_edit1() {

	mp_global_intermission = getentarray( "mp_global_intermission", "classname" );
	mp_global_intermission[0].origin = (-2, -84, -70);
	mp_global_intermission[0].angles = (0, 0, 0);
	mp_global_intermission[1].origin = (913, 1124, 21);
	mp_global_intermission[1].angles = (0, 150, 0);

	disable_spawn_array = []; 
	disable_spawn_array[disable_spawn_array.size] = (1972, 1860, -43.2992);
	disable_spawn_array[disable_spawn_array.size] = (-1080, 1710, -56.8623);
	disable_spawn_array[disable_spawn_array.size] = (1093, 919, -51.875);
	disable_spawn_array[disable_spawn_array.size] = (1224, 1196, -54.0587);
	disable_spawn_array[disable_spawn_array.size] = (-1234, 727, -52.7257);
	disable_spawn_array[disable_spawn_array.size] = (-1241, 1301, -58.0489);
	disable_spawn_array[disable_spawn_array.size] = (1277, 332, -127.774);
	disable_spawn_array[disable_spawn_array.size] = (-1312, 1086, -58.8451);
	disable_spawn_array[disable_spawn_array.size] = (1713, 2539, -45.2866);
	disable_spawn_array[disable_spawn_array.size] = (1933, 2316, -43.875);
	disable_spawn_array[disable_spawn_array.size] = (-300, 1980, -7.875);
	disable_spawn_array[disable_spawn_array.size] = (-300, 974, -48.298);
	disable_spawn_array[disable_spawn_array.size] = (315.5, -513, -123.875);
	disable_spawn_array[disable_spawn_array.size] = (-355, -328, -123.875);
	disable_spawn_array[disable_spawn_array.size] = (-44, -387, -123.875);
	disable_spawn_array[disable_spawn_array.size] = (45, 867, -56.2681);
	disable_spawn_array[disable_spawn_array.size] = (716.3, 2665.8, -55.875);
	disable_spawn_array[disable_spawn_array.size] = (-742, -459, -127.875);
	disable_spawn_array[disable_spawn_array.size] = (872, 996, -43.875);
	disable_spawn_array[disable_spawn_array.size] = (968, 702, -39.7151);
	disable_spawn_array[disable_spawn_array.size] = (-99.6, 2638.4, -51.875);
	disable_spawn_point(disable_spawn_array);
	add_spawn_point((-668, -616, -126),(0, -3, 0));
	add_spawn_point((-668, -723, -126),(0, -2, 0));
	add_spawn_point((-668, -834, -126),(0, -2, 0));
	add_spawn_point((-577, -854, -126),(0, 85, 0));
	add_spawn_point((-579, -593, -126),(0, -87, 0));
	add_spawn_point((103, -883, -126),(0, 139, 0));
	add_spawn_point((153, -811, -126),(0, 158, 0));
	add_spawn_point((283, -391, -126),(0, -130, 0));
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn");
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn");

	// Spawn room
	CreateInvisWalls((-393, -65, -110),(-393, 35, -50));
	spawnmodel((-411, 2, -80) , (0, -90, 0) , "p_glo_corrugated_metal4");
	spawnmodel((-410, -36, -80) , (0, -90, 0) , "p_glo_corrugated_metal4");

	CreateInvisWalls((-130, -419, -100),(-20, -419, -50));
	spawnmodel((-99, -435, -66) , (0, 0, 0) , "p_glo_corrugated_metal4");
	spawnmodel((-47, -436, -66) , (0, 0, 0) , "p_glo_corrugated_metal4");

	CreateInvisWalls((295, -269, -115),(458, -269, -115));
	CreateInvisWalls((295, -269, -55),(458, -269, -55));
	CreateInvisWalls((295, -269, 5),(458, -269, 5));
	CreateInvisWalls((295, -269, 65),(458, -269, 65));
	spawnmodel((366, -257, -130) , (0, 90, 0) , "p_jun_storage_crate");
	spawnmodel((366, -257, -61) , (0, 90, 0) , "p_jun_storage_crate");
	spawnmodel((448, -289, -57) , (0, 0, 0) , "p_glo_corrugated_metal_002");

	CreateDoors((-1039, 1197, 90),(-1039, 1197, -35),(90, -110, 0), 1, 2, 20, 140, true); //First door
		
	// Second room
	spawncrate((-533, 843, -12) , (90, 0, 0));
	spawnmodel((-549, 844, -2) , (0, -90, 0) , "p_glo_corrugated_metal4");

	CreateInvisWalls((-500, 960, -35),(-500, 1285, -35));
	CreateInvisWalls((-500, 960, 25),(-500, 1285, 25));
	CreateInvisWalls((-500, 960, 85),(-500, 1285, 85));
	CreateInvisWalls((-500, 960, 145),(-500, 1285, 145));
	CreateInvisWalls((-500, 960, 205),(-500, 1285, 205));
	spawnmodel((-485, 1033, -66) , (0, 0, 0) , "p_jun_storage_crate");
	spawnmodel((-486, 1204, -66) , (0, 0, 0) , "p_jun_storage_crate");
	spawnmodel((-487, 1033, 4) , (0, 0, 0) , "p_jun_storage_crate");
	spawnmodel((-485, 1204, 3) , (0, 0, 0) , "p_jun_storage_crate");

	CreateInvisWalls((-531, 1245, -35),(-862, 1245, -35));
	CreateInvisWalls((-531, 1245, 25),(-862, 1245, 25));
	CreateInvisWalls((-531, 1245, 85),(-862, 1245, 85));
	CreateInvisWalls((-531, 1245, 145),(-862, 1245, 145));
	CreateInvisGrids((-531, 1275, -35),(-862, 1275, -35), (0,0,0));
	CreateInvisGrids((-531, 1310, -50),(-800, 1310, -50), (0,0,-25));
	spawnmodel((-611, 1330, -38) , (30, 90, 90) , "p_glo_corrugated_metal_003_firingrange");
	spawnmodel((-784, 1327, -38) , (30, 90, 90) , "p_glo_corrugated_metal_003_firingrange");
	spawnmodel((-606, 1256, -92) , (0, 90, 0) , "p_jun_storage_crate");
	spawnmodel((-785, 1256, -92) , (0, 90, 0) , "p_jun_storage_crate");
	spawnmodel((-562, 1248, -14) , (0, -90, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((-654, 1248, -14) , (0, -90, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((-746, 1248, -14) , (0, -90, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((-838, 1248, -14) , (0, -90, 0) , "p_dest_concrete_barrier03_static");
	
	// Bunker
	spawncrate((-878, 1972, -20) , (0, -20, 0));
	spawncrate((-878, 1972, 15) , (0, -20, 0));
	spawnmodel((-899, 1976, -56) , (0, 0, 0) , "mp_firingrange_tire_wall");
	spawnmodel((-864, 1963, -56) , (0, -180, 0) , "mp_firingrange_tire_wall");
	spawnmodel((-775, 1623, 15) , (0, 0, 0) , "p_glo_emergency_light");
	spawnmodel((-818, 1506, 11) , (0, 0, 0) , "p_glo_emergency_light");

	CreateInvisWalls((-460, 1575, -35),(-335, 1720, -35));
	CreateInvisWalls((-460, 1575, 25),(-335, 1720, 25));	
	CreateInvisWalls((-460, 1575, 85),(-335, 1720, 85));
	CreateInvisWalls((-460, 1575, 145),(-335, 1720, 145));
	spawnmodel((-393, 1621, -52) , (0, -135, 0) , "t5_veh_ultimate_jeep_d");

	// Caravan Blocker
	spawncrate((-154, 2061, 37) , (90, 111, 0));
	spawnmodel((-149, 2048, -8) , (0, 21, 0) , "p_dest_metal_locker01_base");

	CreateDoors((1041, 2455, 75),(1041, 2455, -15),(90, 173, 0), 4, 2, 20, 140, true); //Second door

	// Third Room
	spawncrate((1375, 2470, -41) , (0, 90, 0));
	spawncrate((1375, 2516, -41) , (0, 90, 0));
	spawnmodel((1382, 2481, -34) , (0, 90, 0) , "p_jun_us_ammo_crate");

	spawncrate((1759, 2488, -4) , (90, 180, 0));
	spawnmodel((1744, 2518, 7) , (-90, 0, 0) , "p_rus_basement_door");

	spawncrate((1865, 1927, -4) , (90, -90, 0));
	spawnmodel((1865, 1960, -30) , (0, 0, 85) , "p_glo_table_bunker");
	spawnmodel((1865, 1963, 2) , (0, 0, 85) , "p_glo_table_bunker");

	// Crows Nest
	spawncrate((1300, 1577, -10) , (90, 60, 0));
	spawnmodel((1312, 1591, -5) , (0, -30, 0) , "p_glo_corrugated_metal4");
	CreateInvisGrids((1221, 1536, 79),(1125, 1600, 79), (0,-30,0));
	spawnmodel((1192, 1488, 97) , (0, -30, 0) , "p_jun_sandbag_roof");
	spawncrate((1194, 1299, 133) , (90, 60, 0));
	spawnmodel((1184, 1282, 128) , (0, -30, -90) , "p_glo_table_bunker");
	spawnmodel((1184, 1282, 162) , (0, -30, -90) , "p_glo_table_bunker");
	spawncrate((1048, 1495, 133) , (90, -30, 0));
	spawnmodel((1030, 1502, 128) , (0, -120, -90) , "p_glo_table_bunker");
	spawnmodel((1030, 1502, 162) , (0, -120, -90) , "p_glo_table_bunker");

	// Road Last Stand Area
	CreateInvisWalls((2020, 1687, -35),(2020, 1538, -35));
	CreateInvisWalls((2020, 1687, 25),(2020, 1538, 25));
	CreateInvisWalls((2020, 1687, 85),(2020, 1538, 85));
	CreateInvisWalls((2020, 1687, 145),(2020, 1538, 145));
	CreateInvisWalls((2300, 1311, -35),(2300, 1448, -35));
	CreateInvisWalls((2300, 1311, 25),(2300, 1448, 25));
	CreateInvisWalls((2300, 1311, 85),(2300, 1448, 85));
	CreateInvisWalls((2300, 1311, 145),(2300, 1448, 145));
	spawnmodel((2299, 1420, -56) , (0, -180, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((2299, 1328, -56) , (0, -180, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((2020, 1657, -54) , (0, -180, 0) , "p_dest_concrete_barrier03_static");
	spawnmodel((2020, 1565, -54) , (0, -180, 0) , "p_dest_concrete_barrier03_static");

	CreateInvisWalls((860, 2075, -35),(860, 1850, -35));
	CreateInvisWalls((860, 2075, 25),(860, 1850, 25));
	CreateInvisWalls((860, 2075, 85),(860, 1850, 85));
	CreateInvisWalls((860, 2075, 145),(860, 1850, 145));
	spawnmodel((849, 1996, -55) , (0, -90, 0) , "vehicle_80s_sedan1_nt_destroyed");

	CreateInvisWalls((1368, 1051, -40),(1587, 925, -40));
	CreateInvisWalls((1368, 1051, 20),(1587, 925, 20));
	CreateInvisWalls((1368, 1051, 80),(1587, 925, 80));
	CreateInvisWalls((1368, 1051, 140),(1587, 925, 140));
	spawnmodel((1518, 971, -68) , (0, -30, 0) , "p_glo_barricade_wood_barb");
	spawnmodel((1413, 1032, -63) , (4, -30, 0) , "p_glo_barricade_wood_barb");

	// AntiOOM
	Deathradius((384, -48, -88), 100 , 100);
	Deathradius((-282, 1096, -72), 100 , 100);
	Deathradius((-279, 1240, -72), 100 , 100);
	Deathradius((-181, 1675, -72), 100 , 100);
	Deathradius((-380, 1341, -74), 100 , 100);
	Deathradius((716, 2016, -64), 100 , 100);
	Deathradius((764, 1822, -68), 100 , 100);
	Deathradius((1437, 852, -87), 100 , 100);
	Deathradius((1336, 925, -73), 100 , 100);
	CreateDeathRegion((845, 2092, -300),(17, -263, 400));
	CreateDeathRegion((34, -420, -300),(-414, 1600, 400));
	Deathradius((801, 1131, -100), 300 , 400);

	array = getentarray("script_brushmodel","classname");
	foreach(collision in array){
		if(collision.origin == (1536, 1343, 270))
			collision delete();
	}
}

setmodel_hook(model) {
	self setmodel(model);
	print("spawnmodel(" + self.origin + " , " + self.angles + " , \"" + self.model + "\");");
}
