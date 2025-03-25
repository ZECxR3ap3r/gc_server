#include scripts\tpjugg_mapediting\tp_jugg_map_funcs;
init() {
    level thread Select_Mapedit();
}

add_map_to_maplist(map, display_name, edit_name, edit_func, maker) {
	if(!isdefined(level.edits_maplist[map])) {
		level.edits_maplist[map] = [];
		level.edits_maplist_display_name[map] = display_name;
	}
	level.edits_maplist[map][level.edits_maplist[map].size] = edit_name;
	level.edits_mapedit[edit_name] = edit_func;
	level.edits_mapedit_credits[edit_name] = maker;
}

Select_Mapedit() {
	rnd = undefined;
    level.map_name = getdvar("mapname");

	level.edits_maplist = [];
	level.edits_mapedit = [];
	level.edits_maplist_display_name = [];
	
	//add maps here
	add_map_to_maplist("mp_rust", "Rust" ,"Big Gae", ::rust, "Clippy");
	add_map_to_maplist("mp_moab", "Gulch" ,"Small Spots", ::gulch, "Clippy");
	add_map_to_maplist("mp_courtyard_ss", "Erosion" ,"Small blocker", ::erosion, "Clippy");
	add_map_to_maplist("mp_hillside_ss", "getaway" ,"Small stuff", ::getaway, "Clippy");
	add_map_to_maplist("mp_cha_quad", "monastery" ,"Small stuff", ::monastery, "Clippy");
	add_map_to_maplist("mp_lockout_h2", "Lockout Halo" ,"Shafting", ::lockout_h2, "Clippy");
	add_map_to_maplist("mp_boneyard", "Scrapyard" ,"Cock and balls", ::boneyard, "Clippy");
	

	if(isdefined(level.edits_maplist[level.map_name])) {
		rnd = level.edits_maplist[level.map_name][randomint(level.edits_maplist[level.map_name].size)];
		level [[level.edits_mapedit[rnd]]]();
	}
}

boneyard() {
	check_map_models( (-1000, 0, 1500) );
	manually_add_check_map_model("727_ending"); //1
	manually_add_check_map_model("727_platform_arms"); //6
	manually_add_check_map_model("727_platform_base"); //7
	manually_add_check_map_model("727_seats_row_left"); //8
	manually_add_check_map_model("afch_bigrock_01"); //17
	manually_add_check_map_model("bc_militarytent_wood_table"); //21
	manually_add_check_map_model("bc_military_tire05_big"); //22
	manually_add_check_map_model("cargocontainer_20ft_blue"); //24
	manually_add_check_map_model("cargocontainer_20ft_red"); //25
	manually_add_check_map_model("cargocontainer_20ft_white"); //26
	manually_add_check_map_model("cargo_cage_64x96x48"); //27
	manually_add_check_map_model("ch_angle_support_brace"); //28
	manually_add_check_map_model("ch_crate64x64"); //38
	manually_add_check_map_model("ch_furniture_teachers_desk1"); //39
	manually_add_check_map_model("ch_industrial_light_01_off"); //40
	manually_add_check_map_model("ch_industrial_light_01_on"); //41
	manually_add_check_map_model("ch_industrial_light_02_off"); //42
	manually_add_check_map_model("ch_industrial_light_02_on"); //43
	manually_add_check_map_model("ch_mailboxes"); //44
	manually_add_check_map_model("ch_missle_rack"); //45
	manually_add_check_map_model("ch_rubble_anglemetal01"); //46
	manually_add_check_map_model("ch_rubble_chunk01"); //47
	manually_add_check_map_model("ch_rubble_chunk02"); //48
	manually_add_check_map_model("ch_rubble_particleboard01"); //49
	manually_add_check_map_model("ch_rubble_woodplank01"); //50
	manually_add_check_map_model("ch_wooden_fence_post_01"); //51
	manually_add_check_map_model("ch_wooden_fence_rail_03"); //52
	manually_add_check_map_model("cliffhanger_wire_coil"); //53
	manually_add_check_map_model("com_airduct_02"); //54
	manually_add_check_map_model("com_airduct_circle"); //55
	manually_add_check_map_model("com_airduct_c_90"); //56
	manually_add_check_map_model("com_airduct_c_scale"); //57
	manually_add_check_map_model("com_airduct_c_t"); //58
	manually_add_check_map_model("com_airduct_c_vent"); //59
	manually_add_check_map_model("com_airduct_square"); //60
	manually_add_check_map_model("com_airduct_s_90"); //61
	manually_add_check_map_model("com_airduct_s_holder"); //62
	manually_add_check_map_model("com_airduct_s_short"); //63
	manually_add_check_map_model("com_airduct_s_tran_c"); //64
	manually_add_check_map_model("com_airduct_s_up_down"); //65
	manually_add_check_map_model("com_barrel_biohazard_rust"); //66
	manually_add_check_map_model("com_barrel_blue_rust"); //67
	manually_add_check_map_model("com_barrel_shard3"); //68
	manually_add_check_map_model("com_barrel_shard4"); //69
	manually_add_check_map_model("com_barrel_tan_rust"); //70
	manually_add_check_map_model("com_barrel_white_rust"); //71
	manually_add_check_map_model("com_barrier_tall1"); //72
	manually_add_check_map_model("com_bike_destroyed"); //73
	manually_add_check_map_model("com_bomb_objective"); //74
	manually_add_check_map_model("com_bomb_objective_d"); //75
	manually_add_check_map_model("com_cafe_chair"); //80
	manually_add_check_map_model("com_cardboardbox01"); //81
	manually_add_check_map_model("com_cardboardbox01_open"); //82
	manually_add_check_map_model("com_cardboardbox03"); //83
	manually_add_check_map_model("com_cardboardbox04"); //84
	manually_add_check_map_model("com_cardboardbox05"); //85
	manually_add_check_map_model("com_cardboardboxshortclosed_1"); //86
	manually_add_check_map_model("com_cardboardboxshortopen_2"); //87
	manually_add_check_map_model("com_cellphone_off"); //88
	manually_add_check_map_model("com_cellphone_on"); //89
	manually_add_check_map_model("com_computer_case"); //90
	manually_add_check_map_model("com_computer_keyboard"); //91
	manually_add_check_map_model("com_computer_monitor"); //92
	manually_add_check_map_model("com_computer_mouse"); //93
	manually_add_check_map_model("com_copypaper_box"); //94
	manually_add_check_map_model("com_copypaper_box_lid"); //95
	manually_add_check_map_model("com_copypaper_box_open"); //96
	manually_add_check_map_model("com_debris_metal_frame"); //97
	manually_add_check_map_model("com_electrical_pipe"); //98
	manually_add_check_map_model("com_electrical_pipe_short"); //99
	manually_add_check_map_model("com_electrical_transformer_large_dam"); //100
	manually_add_check_map_model("com_electrical_transformer_large_dam_door1"); //101
	manually_add_check_map_model("com_electrical_transformer_large_dam_door2"); //102
	manually_add_check_map_model("com_electrical_transformer_large_dam_door3"); //103
	manually_add_check_map_model("com_electrical_transformer_large_dam_door4"); //104
	manually_add_check_map_model("com_electrical_transformer_large_dam_door5"); //105
	manually_add_check_map_model("com_electrical_transformer_large_dam_door6"); //106
	manually_add_check_map_model("com_electrical_transformer_large_dam_door7"); //107
	manually_add_check_map_model("com_electrical_transformer_large_des"); //108
	manually_add_check_map_model("com_ex_airconditioner"); //109
	manually_add_check_map_model("com_ex_airconditioner_dam"); //110
	manually_add_check_map_model("com_ex_airconditioner_fan"); //111
	manually_add_check_map_model("com_ex_airconditioner_grating"); //112
	manually_add_check_map_model("com_filecabinetblackclosed"); //113
	manually_add_check_map_model("com_filecabinetblackclosed_dam"); //114
	manually_add_check_map_model("com_filecabinetblackclosed_des"); //115
	manually_add_check_map_model("com_filecabinetblackclosed_drawer"); //116
	manually_add_check_map_model("com_firehydrant"); //117
	manually_add_check_map_model("com_firehydrant_cap"); //118
	manually_add_check_map_model("com_firehydrant_dam"); //119
	manually_add_check_map_model("com_firehydrant_dest"); //120
	manually_add_check_map_model("com_folding_chair"); //121
	manually_add_check_map_model("com_gas_pipes01"); //122
	manually_add_check_map_model("com_industrialtrashbin"); //123
	manually_add_check_map_model("com_junktire"); //124
	manually_add_check_map_model("com_laptop_2_open"); //125
	manually_add_check_map_model("com_milk_carton"); //126
	manually_add_check_map_model("com_office_lamp02"); //129
	manually_add_check_map_model("com_paintcan"); //130
	manually_add_check_map_model("com_pallet"); //131
	manually_add_check_map_model("com_pallet_2"); //132
	manually_add_check_map_model("com_parkingcone01"); //133
	manually_add_check_map_model("com_pipe_4x128_metal"); //134
	manually_add_check_map_model("com_pipe_4x256_metal"); //135
	manually_add_check_map_model("com_pipe_4x32_metal"); //136
	manually_add_check_map_model("com_pipe_4x512_ceramic"); //137
	manually_add_check_map_model("com_pipe_4x512_gas"); //138
	manually_add_check_map_model("com_pipe_4x512_metal"); //139
	manually_add_check_map_model("com_pipe_4x64_metal"); //140
	manually_add_check_map_model("com_pipe_4_45angle_metal"); //141
	manually_add_check_map_model("com_pipe_4_90angle_metal"); //142
	manually_add_check_map_model("com_pipe_4_coupling_metal"); //143
	manually_add_check_map_model("com_pipe_4_coupling_metal_oilrig"); //144
	manually_add_check_map_model("com_pipe_4_fit_metal"); //145
	manually_add_check_map_model("com_pipe_4_fit_metal_oilrig"); //146
	manually_add_check_map_model("com_pipe_8x32_metal"); //147
	manually_add_check_map_model("com_pipe_8_fit_metal"); //148
	manually_add_check_map_model("com_pipe_coupling_metal_oilrig"); //149
	manually_add_check_map_model("com_plasticcase_beige_big"); //150
	manually_add_check_map_model("com_plasticcase_beige_big_us_dirt"); //151
	manually_add_check_map_model("com_plasticcase_beige_rifle"); //152
	manually_add_check_map_model("com_plasticcase_green_big"); //153
	manually_add_check_map_model("com_plasticcase_green_big_us_dirt"); //154
	manually_add_check_map_model("com_plasticcase_green_rifle"); //155
	manually_add_check_map_model("com_plastic_bucket"); //156
	manually_add_check_map_model("com_propane_tank"); //157
	manually_add_check_map_model("com_propane_tank02_des"); //158
	manually_add_check_map_model("com_propane_tank02_valve"); //159
	manually_add_check_map_model("com_prop_rail_wheeltrack"); //160
	manually_add_check_map_model("com_public_speaker_01"); //161
	manually_add_check_map_model("com_railpipe_med_02"); //162
	manually_add_check_map_model("com_railpipe_med_bend"); //163
	manually_add_check_map_model("com_red_toolbox"); //164
	manually_add_check_map_model("com_restaurantkitchentable_3"); //165
	manually_add_check_map_model("com_restaurantkitchentable_6"); //166
	manually_add_check_map_model("com_restaurantkitchentable_7"); //167
	manually_add_check_map_model("com_restaurantstainlessteelshelf_02"); //168
	manually_add_check_map_model("com_roofvent2"); //169
	manually_add_check_map_model("com_soup_can"); //170
	manually_add_check_map_model("com_standpipe"); //171
	manually_add_check_map_model("com_stepladder"); //172
	manually_add_check_map_model("com_studiolight_hanging_off"); //173
	manually_add_check_map_model("com_studiolight_hanging_on"); //174
	manually_add_check_map_model("com_teddy_bear_sitting"); //175
	manually_add_check_map_model("com_telephone_desk"); //176
	manually_add_check_map_model("com_trashbag1_black"); //187
	manually_add_check_map_model("com_trashbag1_white"); //188
	manually_add_check_map_model("com_trashbag2_green"); //189
	manually_add_check_map_model("com_trashbag2_white"); //190
	manually_add_check_map_model("com_trashbin02"); //191
	manually_add_check_map_model("com_trashbin02_dmg"); //192
	manually_add_check_map_model("com_trashbin02_lid"); //193
	manually_add_check_map_model("com_trashcan_metal_with_trash"); //194
	manually_add_check_map_model("com_trash_bin_sml01"); //195
	manually_add_check_map_model("com_vcr_tape_blue"); //196
	manually_add_check_map_model("com_wallchunk_cinderblock08"); //197
	manually_add_check_map_model("com_wallchunk_rebar02"); //198
	manually_add_check_map_model("com_wallchunk_rebar03"); //199
	manually_add_check_map_model("com_wall_fan"); //200
	manually_add_check_map_model("com_wall_fan_blade"); //201
	manually_add_check_map_model("com_water_tank1_ladder"); //202
	manually_add_check_map_model("com_widescreen_monitor"); //203
	manually_add_check_map_model("concrete_barrier_damaged_1"); //204
	manually_add_check_map_model("construction_hardhat"); //205
	manually_add_check_map_model("crashed_satellite_brokenpiece1"); //206
	manually_add_check_map_model("crashed_satellite_brokenpiece2"); //207
	manually_add_check_map_model("crashed_satellite_brokenpiece3"); //208
	manually_add_check_map_model("crashed_satellite_brokenpiece4"); //209
	manually_add_check_map_model("crashed_satellite_brokenpiece5"); //210

	spawnmodel((-1743, 1803, -75) , (0, 0, 0) , "com_electrical_transformer_large_des");
	spawnmodel((-1364, 1825, -69) , (0, -150, 0) , "com_industrialtrashbin");
	spawnmodel((-1865, 2181, -103) , (0, 0, 0) , "afch_bigrock_01");
	spawncrate((-1737, 2125, 61), (0, -1, 0),"com_plasticcase_friendly");
	spawncrate((-1453, 2173, 148), (0, -144, 0),"com_plasticcase_friendly");
	CreateWalls((-1529, 1945, 63),(-1229, 2099, -49));
	CreateGrids((-1416, 2130, 43),(-1217, 2350, 43), (0,0,0));
	CreateRamps((-1511, 2407, 80),(-1658, 2167, -100));
	CreateDoors((-1766, 1936, 77),(-1768, 2175, 77),(90, 1, 0), 3, 2, 20, 140, true);
	CreateQuicksteps((-1449, 2107, 43),122, 15, 2, (0, -155.935, 0));
	cannonball((-1429, 2201, 43),(0, -149.711, 0), 3 ,(-1058, 1448, 95),321);
	fufalldamage((-1447, 1349, -154), 150 , 150);
	CreateTP((-1487, 1388, -141),(-1293, 1496, -140));

}

rust() {
	// CreateElevator( (-111, 871, -215),(-88, 672, 156), 255, 1.25);

	// 	spawncrate((109, 1350, -145), (0, 39, 0),"com_plasticcase_friendly");
	// spawncrate((636, 1279, -11), (0, -151, 0),"com_plasticcase_friendly");

	CreateMovingBlock((109, 1350, -145), (636, 1279, -11), (0, 39, 0), 1, 1.5, undefined, undefined);
}

lockout_h2() {
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
	CreateWalls((4110, 3640, 3205 + i * 30),(4235, 3640, 3205 + i * 30));
	CreateWalls((4110, 3670, 3205 + i * 30),(4110, 4035, 3205 + i * 30));
	CreateWalls((4110, 4035, 3205 + i * 30),(4235, 4035, 3205 + i * 30));



	CreateWalls((4110, 3780, 2840),(4110, 3905, 2960));
	CreateGrids((3510, 3800, 2937),(3460, 3880, 2937), (0,0,0));

	CreateGrids((4399, 4399, 2920),(4559, 4559, 2920), (0,0,0));

	for(i=0; i<7; i++) {
		spawncrate((4399, 4399, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4399, 4559, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4559, 4399, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
		spawncrate((4559, 4559, 2920 - i * 25), (0, 0, 0),"com_plasticcase_friendly");
	}

	CreateDoors((4455, 4029, 2870),(4455, 4029, 2750),(90, 90, 0), 3, 2, 20, 140);

	fufalldamage((3796, 3842, 2077), 2000 , 6000);
	cannonball((3590, 3046, 3305),(0, 89.2365, 0), 3 ,(3398, 4403, 3728),399);
	cannonball((3461, 4492, 3625),(0, -25.9172, 0), 3 ,(4357, 4018, 3920),306);
	// CreateHiddenTP((4098, 3836, 2696),(3606, 3848, 2952));

	CreateGrids((4880, 4050, 3795),(4930, 4430, 3795), (0,0,0));

	CreateGrids((4000, 4130, 4541),(3550, 3560, 4541), (0,0,0));
	CreateWalls((4025, 4100, 4550),(4025, 3590, 4550), (0,90,0));
}


gulch(){
	check_map_models( (-1000, 0, 1500) );
	manually_add_check_map_model("ac_prs_imp_ch_wooden_fence_post_02"); //0
	manually_add_check_map_model("ac_prs_imp_payback_sandbags_technical"); //3
	manually_add_check_map_model("afr_corrugated_metal2x8"); //5
	manually_add_check_map_model("afr_corrugated_metal4x4_holes"); //6
	manually_add_check_map_model("afr_corrugated_metal4x8"); //7
	manually_add_check_map_model("afr_crate01"); //8
	manually_add_check_map_model("afr_junktire"); //10
	manually_add_check_map_model("afr_militarytent_wood_table"); //15
	manually_add_check_map_model("afr_river_wood_plank1"); //18
	manually_add_check_map_model("afr_rusty_fence_post_01"); //20
	manually_add_check_map_model("afr_wood_bundle_tall"); //22
	manually_add_check_map_model("cement_block_03"); //33
	manually_add_check_map_model("ch_bedframemetal_dark"); //34
	manually_add_check_map_model("ch_hayroll_02"); //36
	manually_add_check_map_model("ch_mattress_boxspring"); //37
	manually_add_check_map_model("ch_wooden_fence_post_01"); //38
	manually_add_check_map_model("ch_wood_stove"); //42
	manually_add_check_map_model("com_bomb_objective"); //44
	manually_add_check_map_model("com_crate01"); //49
	manually_add_check_map_model("com_crate02"); //50
	manually_add_check_map_model("com_door_03_handleleft"); //52
	manually_add_check_map_model("com_flashlight_off_dusty"); //55
	manually_add_check_map_model("com_floodlight"); //56
	manually_add_check_map_model("com_floodlight_on"); //57
	manually_add_check_map_model("com_laptop_2_open"); //59
	manually_add_check_map_model("com_pail_metal1"); //62
	manually_add_check_map_model("com_pipe_4x256_single_metal_dull"); //66
	manually_add_check_map_model("com_plasticcase_beige_big"); //69
	manually_add_check_map_model("com_plasticcase_green_big_us_dirt"); //71
	manually_add_check_map_model("com_screwdriver_1"); //77
	manually_add_check_map_model("ctl_foliage_bush_big_longlod"); //85
	manually_add_check_map_model("ctl_foliage_drygrass_squareclump"); //86
	// manually_add_check_map_model("ctl_medium_rocks_14"); //88
	// manually_add_check_map_model("ctl_small_rocks_01"); //89
	manually_add_check_map_model("debris_wood_shard_large_end"); //93
	manually_add_check_map_model("foliage_afr_grass_brown_01a"); //96
	manually_add_check_map_model("foliage_afr_grass_sm_01a"); //97
	manually_add_check_map_model("foliage_afr_tree_brokenlog_lg_01a"); //98
	manually_add_check_map_model("foliage_afr_tree_brokenstump_01a"); //99
	manually_add_check_map_model("foliage_bush_big"); //100
	manually_add_check_map_model("foliage_bush_big_brown"); //101
	manually_add_check_map_model("foliage_cod5_tallgrass10b"); //102
	manually_add_check_map_model("foliage_ctl_shrub_group01"); //103
	manually_add_check_map_model("foliage_desertbrush_1"); //104
	manually_add_check_map_model("foliage_desertbrush_1_animated"); //105
	manually_add_check_map_model("foliage_desertbrush_2"); //106
	manually_add_check_map_model("foliage_desertbrush_3_animated"); //107
	manually_add_check_map_model("foliage_pacific_fern01"); //112
	manually_add_check_map_model("fxanim_gp_chain_arch_sm_mod"); //120
	manually_add_check_map_model("fxanim_gp_chain_med_mod"); //121
	manually_add_check_map_model("fxanim_gp_chain_short_hook_mod"); //122
	manually_add_check_map_model("generic_prop_raven"); //131
	manually_add_check_map_model("haybale"); //132
	manually_add_check_map_model("hos_door_04"); //144
	manually_add_check_map_model("intro_potato_bags_pile_03"); //146
	manually_add_check_map_model("lantern_iron_chain"); //149
	manually_add_check_map_model("lantern_iron_off_animated"); //150
	manually_add_check_map_model("machinery_generator"); //151
	manually_add_check_map_model("me_plastic_crate2"); //159
	manually_add_check_map_model("me_plastic_crate6"); //160
	manually_add_check_map_model("me_woodcrateopen"); //161
	manually_add_check_map_model("moab_aloe_vera"); //164
	manually_add_check_map_model("moab_anvil"); //165
	manually_add_check_map_model("moab_bucket_square_01"); //168
	manually_add_check_map_model("moab_bucket_square_base_01"); //169
	manually_add_check_map_model("moab_cactus_arm"); //171
	manually_add_check_map_model("moab_cactus_arm_bent"); //172
	manually_add_check_map_model("moab_cactus_arm_bent_dead"); //173
	manually_add_check_map_model("moab_cactus_arm_short"); //174
	manually_add_check_map_model("moab_cactus_flower"); //175
	manually_add_check_map_model("moab_cactus_flower_bud"); //176
	manually_add_check_map_model("moab_cactus_pricklypear_clump1"); //177
	manually_add_check_map_model("moab_cactus_pricklypear_clump2"); //178
	manually_add_check_map_model("moab_cactus_pricklypear_clump3"); //179
	manually_add_check_map_model("moab_cactus_trunk"); //180
	manually_add_check_map_model("moab_cactus_trunk_bulge"); //181
	manually_add_check_map_model("moab_cactus_trunk_bulge_dead"); //182
	manually_add_check_map_model("moab_cactus_trunk_dead"); //183
	// manually_add_check_map_model("moab_cliff_chunk_01"); //184
	// manually_add_check_map_model("moab_cliff_chunk_02"); //185
	// manually_add_check_map_model("moab_cliff_chunk_03"); //186
	// manually_add_check_map_model("moab_cliff_rock_01"); //187
	// manually_add_check_map_model("moab_cliff_rock_01_thin"); //188
	manually_add_check_map_model("moab_cloth_anim_01"); //189
	manually_add_check_map_model("moab_cloth_anim_02"); //190
	manually_add_check_map_model("moab_condor_vista"); //191
	manually_add_check_map_model("moab_crate_ammosize_open_01"); //192
	manually_add_check_map_model("moab_dead_coyote"); //194
	manually_add_check_map_model("moab_flowering_agave_01"); //199
	manually_add_check_map_model("moab_flower_01"); //200
	manually_add_check_map_model("moab_flower_01_group"); //201
	manually_add_check_map_model("moab_flower_02"); //202
	manually_add_check_map_model("moab_flower_02_group"); //203
	manually_add_check_map_model("moab_flower_02_group_red"); //204
	manually_add_check_map_model("moab_flower_02_group_yellow"); //205
	manually_add_check_map_model("moab_flower_02_red"); //206
	manually_add_check_map_model("moab_flower_02_yellow"); //207
	manually_add_check_map_model("moab_fossil"); //209
	manually_add_check_map_model("moab_hanging_hay_03b"); //218
	manually_add_check_map_model("moab_homestead_ladder"); //219
	manually_add_check_map_model("moab_metal_panel_flat_02_mort_b"); //221
	manually_add_check_map_model("moab_minecart_01"); //222
	// manually_add_check_map_model("moab_mountain_rock_01"); //223
	// manually_add_check_map_model("moab_mountain_rock_02"); //224
	// manually_add_check_map_model("moab_mountain_rock_03"); //225
	// manually_add_check_map_model("moab_mountain_rock_04"); //226
	manually_add_check_map_model("moab_noose"); //227
	// manually_add_check_map_model("moab_river_rock_05"); //231
	// manually_add_check_map_model("moab_river_rock_cluster_04"); //232
	// manually_add_check_map_model("moab_rock_large_01"); //234
	// manually_add_check_map_model("moab_rock_large_01b"); //235
	// manually_add_check_map_model("moab_rock_large_01_cliff"); //236
	// manually_add_check_map_model("moab_rock_large_01_r_cliff"); //237
	// manually_add_check_map_model("moab_rock_large_01_wall"); //238
	// manually_add_check_map_model("moab_rock_large_02"); //239
	// manually_add_check_map_model("moab_rock_large_02_r_cliff"); //240
	// manually_add_check_map_model("moab_rock_large_02_wall"); //241
	// manually_add_check_map_model("moab_rock_large_03"); //242
	// manually_add_check_map_model("moab_rock_large_03_river"); //243
	// manually_add_check_map_model("moab_rock_large_03_wall"); //244
	// manually_add_check_map_model("moab_rock_large_04"); //245
	// manually_add_check_map_model("moab_rock_large_04_river"); //246
	// manually_add_check_map_model("moab_rock_large_04_wall"); //247
	// manually_add_check_map_model("moab_rock_large_05"); //248
	// manually_add_check_map_model("moab_rock_large_05_wall"); //249
	// manually_add_check_map_model("moab_rock_large_06"); //250
	// manually_add_check_map_model("moab_rock_large_06b"); //251
	// manually_add_check_map_model("moab_rock_large_06b_wall"); //252
	// manually_add_check_map_model("moab_rock_large_06_river"); //253
	// manually_add_check_map_model("moab_rock_large_06_wall"); //254
	manually_add_check_map_model("moab_ropes"); //257
	manually_add_check_map_model("moab_rope_01"); //258
	manually_add_check_map_model("moab_stair_wood_old_01"); //261
	manually_add_check_map_model("moab_tailing_wheel_full"); //263
	manually_add_check_map_model("moab_teddy_bear_sitting"); //265
	manually_add_check_map_model("moab_tent_tarp_vanim_01"); //266
	manually_add_check_map_model("moab_tree_dead_01"); //272
	manually_add_check_map_model("moab_truck_dually_blue_destructible"); //274
	manually_add_check_map_model("moab_wagon_wheel"); //276
	manually_add_check_map_model("nol_wooden_edges_01"); //300
	manually_add_check_map_model("old_wood_barrel_01"); //302
	manually_add_check_map_model("old_wood_barrel_02"); //303
	manually_add_check_map_model("ow_chains01"); //310
	manually_add_check_map_model("ow_comunication_wire_ground_e_1_lod0_ns"); //311
	manually_add_check_map_model("paris_construction_scaffold_piece_06"); //313
	manually_add_check_map_model("pb_chains01"); //317
	manually_add_check_map_model("pb_ropes_cloth"); //319
	manually_add_check_map_model("pb_window_cage_02"); //320
	// manually_add_check_map_model("prk_river_rock_04"); //322
	// manually_add_check_map_model("prk_river_rock_cluster_01"); //323
	// manually_add_check_map_model("prk_river_rock_cluster_04"); //324
	manually_add_check_map_model("prop_barn_door"); //325
	manually_add_check_map_model("prop_hay_stack_01"); //330
	manually_add_check_map_model("rst_flat_tarp_01"); //334
	manually_add_check_map_model("six_ch_haycart"); //338
	manually_add_check_map_model("ug_crate_ammosize"); //348
	manually_add_check_map_model("ug_crate_pallet"); //349
	manually_add_check_map_model("warehouse_window_frame_01"); //356
}

erosion() {
	spawnmodel((489, -2158, 226) , (0, -90, 0) , "aq_stone_block_04");
	spawnmodel((551, -2158, 234) , (0, -90, 0) , "aq_stone_block_04");
	spawnmodel((489, -2157, 264) , (0, -90, 0) , "aq_stone_block_04");
	spawnmodel((550, -2157, 265) , (0, -90, 0) , "aq_stone_block_04");

	spawncrate((470, -2153, 260), (90, 0, 0));
	spawncrate((510, -2153, 260), (90, 0, 0));
	spawncrate((550, -2153, 260), (90, 0, 0));
	spawncrate((590, -2153, 260), (90, 0, 0));

	spawnmodel((366, -1370, 625) , (0, -90, 0) , "aq_statue_female_reflect");


	check_map_models( (-436, -1244, 941) );
	manually_add_check_map_model("afr_ladder_01"); //0
	manually_add_check_map_model("afr_village_claypot_lrg_01"); //1
	manually_add_check_map_model("aq_brick_grey"); //9
	manually_add_check_map_model("aq_brick_grey_short_01"); //10
	manually_add_check_map_model("aq_brick_grey_short_02"); //11
	manually_add_check_map_model("aq_brick_red"); //12
	manually_add_check_map_model("aq_brick_red_short_01"); //13
	manually_add_check_map_model("aq_brick_red_short_02"); //14
	manually_add_check_map_model("aq_brick_tan"); //15
	manually_add_check_map_model("aq_brick_tan_short_01"); //16
	manually_add_check_map_model("aq_brick_tan_short_02"); //17
	manually_add_check_map_model("aq_brick_white"); //18
	manually_add_check_map_model("aq_brick_white_green_short_01"); //19
	manually_add_check_map_model("aq_brick_white_green_short_02"); //20
	manually_add_check_map_model("aq_brick_white_short_01"); //21
	manually_add_check_map_model("aq_brick_white_short_02"); //22
	manually_add_check_map_model("aq_column_01"); //23
	manually_add_check_map_model("aq_column_02"); //24
	manually_add_check_map_model("aq_crate01"); //25
	manually_add_check_map_model("aq_crate02"); //26
	manually_add_check_map_model("aq_debris_pile"); //27
	manually_add_check_map_model("aq_debris_pile_grey"); //28
	manually_add_check_map_model("aq_debris_pile_red"); //29
	manually_add_check_map_model("aq_debris_pile_red_dirt"); //30
	manually_add_check_map_model("aq_debris_pile_tan"); //31
	manually_add_check_map_model("aq_debris_pile_tan_dirt"); //32
	manually_add_check_map_model("aq_debris_pile_white_gravel"); //33
	manually_add_check_map_model("aq_foliage_hanging_ivy_03"); //43
	manually_add_check_map_model("aq_foliage_ivy_red"); //44
	manually_add_check_map_model("aq_ivy_pillar"); //49
	manually_add_check_map_model("aq_statue_female_01"); //55
	manually_add_check_map_model("aq_statue_female_reflect"); //57
	manually_add_check_map_model("aq_stone_block_04"); //58
	manually_add_check_map_model("aq_stone_block_05"); //59
	manually_add_check_map_model("aq_stone_block_06"); //60
	manually_add_check_map_model("aq_stone_block_07"); //61
	manually_add_check_map_model("com_crate02"); //65
	manually_add_check_map_model("com_railpipe_med_01"); //71
	manually_add_check_map_model("com_railpipe_med_05_d"); //72
	manually_add_check_map_model("com_teddy_bear_sitting"); //73
	manually_add_check_map_model("com_wheelbarrow"); //74
	manually_add_check_map_model("ctl_statue_stone_peasant_a"); //78
	manually_add_check_map_model("ctl_vine_patch_hang"); //79
	manually_add_check_map_model("foliage_hedge_boxy_overgrown2"); //90
	manually_add_check_map_model("foliage_pacific_flowers02"); //94
	manually_add_check_map_model("foliage_pacific_flowers04"); //95
	manually_add_check_map_model("intro_alleyway_gate_01"); //119
	manually_add_check_map_model("intro_foliage_hanging_ivy_01"); //120
	manually_add_check_map_model("intro_foliage_hanging_ivy_02"); //121
	manually_add_check_map_model("intro_foliage_hanging_ivy_03"); //122
	manually_add_check_map_model("jeepride_shrubgroup_01"); //128
	manually_add_check_map_model("lam_debris_brick_pile_02"); //129
	manually_add_check_map_model("me_iron_gate"); //132
	manually_add_check_map_model("prop_terracotta_pot_a"); //162
	manually_add_check_map_model("skassault_rubble_brickpile_01"); //163
	manually_add_check_map_model("tile_overhang_02"); //164
	manually_add_check_map_model("wood_plank1"); //168
	manually_add_check_map_model("wood_plank2"); //169

}

getaway() {
	check_map_models( (1000, 0, 3500) );
	manually_add_check_map_model("ac_prs_enm_watch_tower_a"); //24
	manually_add_check_map_model("afch_bigrock_01"); //25
	manually_add_check_map_model("afch_flatrock_01"); //26
	manually_add_check_map_model("afch_flatrock_02"); //27
	manually_add_check_map_model("afr_militarytent_wood_table"); //32
	manually_add_check_map_model("afr_rock_estate_boulders4"); //34
	manually_add_check_map_model("aquarium_coral_reef"); //35
	manually_add_check_map_model("aquarium_seagrass_01"); //36
	manually_add_check_map_model("aquarium_seagrass_02"); //37
	manually_add_check_map_model("bathroom_plunger"); //38
	manually_add_check_map_model("berlin_hotel_lights_wall1_off"); //41
	manually_add_check_map_model("billiard_table_modern_rack"); //58
	manually_add_check_map_model("billiard_table_modern_stick"); //59
	manually_add_check_map_model("billiard_table_modern_teal"); //60
	manually_add_check_map_model("bowl_wood_modern_02_fruit"); //63
	manually_add_check_map_model("bowl_wood_modern_oranges_01"); //68
	manually_add_check_map_model("bo_p_int_surgical_knife"); //72
	manually_add_check_map_model("brazil_boat_fishing"); //75
	manually_add_check_map_model("brn_cluster_1_rock"); //76
	manually_add_check_map_model("ch_campfire_grill"); //78
	manually_add_check_map_model("ch_lawnmower"); //79
	manually_add_check_map_model("ch_roadrock_07"); //80
	manually_add_check_map_model("com_bicycle_velib"); //82
	manually_add_check_map_model("com_boat_fishing_1"); //83
	manually_add_check_map_model("com_boat_fishing_buoy2"); //84
	manually_add_check_map_model("com_boat_fishing_buoy2_scale5"); //85
	manually_add_check_map_model("com_breakable_platestack_large"); //88
	manually_add_check_map_model("com_cafe_wall_light_off"); //89
	manually_add_check_map_model("com_flower_pot01_bigger"); //91
	manually_add_check_map_model("com_flower_pot01_dyn"); //92
	manually_add_check_map_model("com_flower_pot01_small"); //93
	manually_add_check_map_model("com_speaker"); //119
	manually_add_check_map_model("com_teddy_bear"); //120
	manually_add_check_map_model("com_woodlog_24_96_a"); //121
	manually_add_check_map_model("com_woodlog_24_96_a_small"); //122
	manually_add_check_map_model("cs_coffeemug01_static_brazil"); //123
	manually_add_check_map_model("cs_vodkabottle01"); //128
	manually_add_check_map_model("dt_bathroom_scale"); //132
	manually_add_check_map_model("dt_toilet_roll"); //133
	manually_add_check_map_model("dub_door_handle_chrome"); //134
	manually_add_check_map_model("dub_exterior_poolside_lounge_chair"); //135
	manually_add_check_map_model("dub_grand_piano"); //161
	manually_add_check_map_model("dub_grand_piano_bench"); //162
	manually_add_check_map_model("dub_grand_piano_d"); //167
	manually_add_check_map_model("dub_grand_piano_d_pieces5"); //172
	manually_add_check_map_model("dub_lantern_01"); //176
	manually_add_check_map_model("dub_lounge_sofa_06_pillow"); //177
	manually_add_check_map_model("ex_money_stack_01"); //180
	manually_add_check_map_model("ex_money_stack_02"); //181
	manually_add_check_map_model("fence_glass"); //182
	manually_add_check_map_model("foliage_afr_tree_banana_01a_light_rigged"); //185
	manually_add_check_map_model("foliage_aloe_vera"); //186
	manually_add_check_map_model("foliage_dub_palmtree_med_flag_slow"); //188
	manually_add_check_map_model("foliage_dub_potted_spikey_plant"); //193
	manually_add_check_map_model("foliage_hill_plant_fern_02"); //209
	manually_add_check_map_model("foliage_pacific_palms06"); //213
	manually_add_check_map_model("foliage_pacific_tropic_shrub01_light"); //216
	manually_add_check_map_model("foliage_succulent_plant"); //217
	manually_add_check_map_model("furniture_basket_mesh_orange"); //224
	manually_add_check_map_model("furniture_chaise_lounge"); //225
	manually_add_check_map_model("furniture_coffee_table_modern_01"); //226
	manually_add_check_map_model("furniture_coffee_table_modern_01_dest"); //227
	manually_add_check_map_model("furniture_coffee_table_modern_02"); //228
	manually_add_check_map_model("furniture_coffee_table_modern_02_dest"); //229
	manually_add_check_map_model("furniture_couch2_tan"); //230
	manually_add_check_map_model("furniture_grill_big_gas"); //231
	manually_add_check_map_model("furniture_grill_small_charcoal"); //232
	manually_add_check_map_model("furniture_grill_small_charcoal_lid"); //233
	manually_add_check_map_model("furniture_lounge_pillow01"); //234
	manually_add_check_map_model("furniture_modern_patio_1_seater"); //235
	manually_add_check_map_model("furniture_modern_patio_2_seater"); //236
	manually_add_check_map_model("furniture_modern_patio_3_seater"); //237
	manually_add_check_map_model("furniture_modern_patio_ottoman"); //238
	manually_add_check_map_model("furniture_patio_dining_wood_chair"); //239
	manually_add_check_map_model("furniture_table_coffee3"); //240
	manually_add_check_map_model("furniture_waterbottle01"); //241
	manually_add_check_map_model("hillside_awnings_animated"); //272
	manually_add_check_map_model("hillside_drapes_animated"); //273
	manually_add_check_map_model("hill_decorative_metal_statue1"); //278
	manually_add_check_map_model("hill_decorative_metal_statue2"); //279
	manually_add_check_map_model("hill_decorative_statue1"); //280
	manually_add_check_map_model("hill_decorative_statue2"); //281
	manually_add_check_map_model("hill_decorative_statue3"); //282
	manually_add_check_map_model("hill_planter01"); //285
	manually_add_check_map_model("hill_tree_banana_01"); //286
	manually_add_check_map_model("kitchen_coffee_machine"); //291
	manually_add_check_map_model("kitchen_coffee_machine_pot"); //292
	manually_add_check_map_model("kitchen_faucet_modern"); //293
	manually_add_check_map_model("kitchen_microwave"); //294
	manually_add_check_map_model("kitchen_sink_modern"); //295
	manually_add_check_map_model("lam_foliage_hanging_ivy_02"); //296
	manually_add_check_map_model("machinery_hose02"); //298
	manually_add_check_map_model("ma_flatscreen_tv_on_wallmount_02"); //300
	manually_add_check_map_model("ma_industrial_fridge_1_open"); //302
	manually_add_check_map_model("ma_patio_heater"); //305
	manually_add_check_map_model("ma_restaurant_chair"); //306
	manually_add_check_map_model("ma_vase_with_roses"); //307
	manually_add_check_map_model("md_fancy_toilet_01"); //308
	manually_add_check_map_model("md_venetian_blind_dark_128x96_half"); //311
	manually_add_check_map_model("ow_patio_umb_closed"); //333
	manually_add_check_map_model("ow_restaurant_barstool"); //334
	manually_add_check_map_model("paris_kitchen_counter_a"); //338
	manually_add_check_map_model("paris_kitchen_counter_b"); //339
	manually_add_check_map_model("paris_kitchen_hose"); //340
	manually_add_check_map_model("paris_kitchen_stove_top"); //341
	manually_add_check_map_model("pb_fishnet03"); //348
	manually_add_check_map_model("pb_ropes"); //350
	manually_add_check_map_model("pb_seaweed_clump02"); //351
	manually_add_check_map_model("pool_ball"); //352
	manually_add_check_map_model("pool_ring"); //353
	manually_add_check_map_model("pool_towel1"); //354
	manually_add_check_map_model("pool_towel1_white"); //355
	manually_add_check_map_model("pool_towel2_green"); //356
	manually_add_check_map_model("pool_towel2_white"); //357
	manually_add_check_map_model("pool_towel3"); //358
	manually_add_check_map_model("pool_towel_hanging_beige"); //359
	manually_add_check_map_model("pool_towel_hanging_white"); //360
	manually_add_check_map_model("prk_sailboat_mini_01_g"); //368
	manually_add_check_map_model("prk_sailboat_mini_01_y"); //369
	manually_add_check_map_model("props_foliage_horsetail"); //370
	manually_add_check_map_model("props_foliage_horsetail_hillside"); //371
	manually_add_check_map_model("props_foliage_horsetail_short"); //372
	manually_add_check_map_model("rope_swing"); //377
	manually_add_check_map_model("rst_fluorescent_light_01"); //378
	manually_add_check_map_model("slava_docking_ring_02"); //379
	manually_add_check_map_model("sofa_pillow_modern_01"); //380
	manually_add_check_map_model("sofa_pillow_modern_02"); //381
	manually_add_check_map_model("sofa_pillow_modern_03"); //382
	manually_add_check_map_model("sofa_pillow_modern_04"); //383
	manually_add_check_map_model("sofa_sectional_1_seater_corner_end"); //384
	manually_add_check_map_model("sofa_sectional_1_seater_corner_end_lightblue"); //385
}

monastery() {
	spawnmodel((683, -1338, 506) , (0, 90, 0) , "ch_haycart_sh_b");
	spawnmodel((965, -937, 283) , (0, 180, 0) , "com_wine_barrel_withtap");
	spawnmodel((986, -796, 256) , (0, -90, 0) , "p_jun_wood_stack");
	spawnmodel((947, -1056, 272) , (90, 0, 0) , "quad_rope_spool_01");
	spawnmodel((901, -791, 277) , (0, 0, 0) , "static_seelow_woodbarrel_single");
	spawnmodel((1023, -939, 303) , (0, 90, 0) , "foliage_hedge_quad_endcap_1");
	spawnmodel((1022, -985, 303) , (0, 90, 0) , "foliage_hedge_quad_wallmodulartall_3");
	spawnmodel((1022, -1030, 303) , (0, -90, 0) , "foliage_hedge_quad_endcap_1");
	spawnmodel((964, -976, 249) , (0, -90, 0) , "afr_longtable");
	spawnmodel((1118, -795, 255) , (0, -90, 0) , "p_jun_wood_stack");
	spawnmodel((965, -971, 284) , (0, 180, 0) , "com_wine_barrel_withtap");
	spawnmodel((1035, -796, 329) , (60, 0, 0) , "com_ladder_wood");
	spawnmodel((965, -1006, 284) , (0, 180, 0) , "com_wine_barrel_withtap");

	check_map_models( (2500, 1000, 1500) );
	manually_add_check_map_model("afr_longtable"); //1
	manually_add_check_map_model("afr_rock_estate_boulders2"); //2
	manually_add_check_map_model("aq_statue_female_01_bronze"); //3
	manually_add_check_map_model("candle_holder_medium"); //4
	manually_add_check_map_model("carousel_pole"); //5
	manually_add_check_map_model("chair_church"); //6
	manually_add_check_map_model("ch_angle_support_brace"); //7
	manually_add_check_map_model("ch_church_bell01"); //9
	manually_add_check_map_model("ch_crate48x64"); //10
	manually_add_check_map_model("ch_haycart"); //11
	manually_add_check_map_model("ch_haycart_sh_arms"); //12
	manually_add_check_map_model("ch_haycart_sh_b"); //13
	manually_add_check_map_model("codo_wooden_ladder_01"); //14
	manually_add_check_map_model("com_cardboardboxshortclosed_1"); //20
	manually_add_check_map_model("com_cardboardboxshortopen_2"); //21
	manually_add_check_map_model("com_flower_pot01"); //23
	manually_add_check_map_model("com_flower_pot02"); //24
	manually_add_check_map_model("com_ladder_wood"); //25
	manually_add_check_map_model("com_paintcan"); //27
	manually_add_check_map_model("com_potted_plant_large_des"); //30
	manually_add_check_map_model("com_stone_bench_b"); //31
	manually_add_check_map_model("com_trashcan_metal"); //32
	manually_add_check_map_model("com_wallchunk_boardlarge01"); //33
	manually_add_check_map_model("com_wallchunk_boardmedium01"); //34
	manually_add_check_map_model("com_wine_barrel_withtap"); //39
	manually_add_check_map_model("ctl_door_handle_knocker_lion"); //40
	manually_add_check_map_model("cub_pottedplant"); //41
	manually_add_check_map_model("foliage_afr_tall_bush_01a_anim"); //43
	manually_add_check_map_model("foliage_dub_potted_palm_01"); //47
	manually_add_check_map_model("foliage_dub_potted_palm_01_flg"); //48
	manually_add_check_map_model("foliage_gardenflowers_red"); //49
	manually_add_check_map_model("foliage_gardenflowers_yellow"); //51
	manually_add_check_map_model("foliage_gardenflowers_yellow_bright"); //52
	manually_add_check_map_model("foliage_hedge_quad_endcap_1"); //57
	manually_add_check_map_model("foliage_hedge_quad_wallmodulartall_3"); //58
	manually_add_check_map_model("foliage_ls_ivy_corner_01"); //64
	manually_add_check_map_model("foliage_ls_ivy_flat_01"); //65
	manually_add_check_map_model("foliage_ls_ivy_left_01"); //66
	manually_add_check_map_model("foliage_ls_ivy_right_01"); //67
	manually_add_check_map_model("foliage_ls_ivy_top_01"); //68
	manually_add_check_map_model("foliage_pacific_flowers01"); //69
	manually_add_check_map_model("foliage_pacific_flowers01_anim"); //70
	manually_add_check_map_model("foliage_tree_birch_yellow_light_animated"); //79
	manually_add_check_map_model("foliage_tree_oak_light_animated"); //80
	manually_add_check_map_model("furniture_table_end1"); //85
	manually_add_check_map_model("gulag_faucet"); //103
	manually_add_check_map_model("intro_props_broom"); //104
	manually_add_check_map_model("intro_props_front_gate"); //105
	manually_add_check_map_model("junk_wheel_01"); //106
	manually_add_check_map_model("lantern_iron_off"); //109
	manually_add_check_map_model("lantern_iron_off_animated"); //110
	manually_add_check_map_model("lantern_iron_on"); //111
	manually_add_check_map_model("london_bigben_gargoyle"); //112
	manually_add_check_map_model("machinery_crane02_hook"); //113
	manually_add_check_map_model("machinery_generator_sh"); //114
	manually_add_check_map_model("machinery_hose01"); //115
	manually_add_check_map_model("metal_ring"); //116
	manually_add_check_map_model("me_basket_rattan03"); //117
	manually_add_check_map_model("me_basket_rattan_lid"); //118
	manually_add_check_map_model("me_basket_wicker05"); //119
	manually_add_check_map_model("me_basket_wicker07"); //120
	manually_add_check_map_model("me_iron_gate"); //122
	manually_add_check_map_model("mid_sign_plaque_01"); //123
	manually_add_check_map_model("mp_quad_billboard_01"); //125
	manually_add_check_map_model("old_wine_jug_02"); //132
	manually_add_check_map_model("old_wood_barrel_01"); //133
	manually_add_check_map_model("old_wood_barrel_02"); //134
	manually_add_check_map_model("old_wood_bucket_02"); //135
	manually_add_check_map_model("old_wood_churnstick_01"); //136
	manually_add_check_map_model("old_wood_fence_post02"); //137
	manually_add_check_map_model("old_wood_tall_barrel_02"); //138
	manually_add_check_map_model("paris_catacombs_brick_pile_02"); //139
	manually_add_check_map_model("pb_ropes_cloth"); //140
	manually_add_check_map_model("prop_stone_step16"); //151
	manually_add_check_map_model("prop_stone_step32"); //152
	manually_add_check_map_model("prop_stone_step64"); //153
	manually_add_check_map_model("prop_terracotta_pot_a"); //154
	manually_add_check_map_model("prop_terracotta_pot_a_violet"); //155
	manually_add_check_map_model("prop_terracotta_pot_a_white"); //156
	manually_add_check_map_model("prop_terracotta_pot_b_red"); //157
	manually_add_check_map_model("prop_terracotta_pot_b_yellow"); //158
	manually_add_check_map_model("prop_terracotta_pot_c_violet"); //159
	manually_add_check_map_model("prop_terracotta_pot_c_yellow"); //160
	manually_add_check_map_model("prop_terracotta_pot_d"); //161
	manually_add_check_map_model("p_glo_palacepot"); //162
	manually_add_check_map_model("p_jun_wood_stack"); //165
	manually_add_check_map_model("quad_banner_square_orange"); //167
	manually_add_check_map_model("quad_banner_square_yellow"); //168
	manually_add_check_map_model("quad_beam_wood_01"); //169
	manually_add_check_map_model("quad_beam_wood_end_01"); //170
	manually_add_check_map_model("quad_beam_wood_end_02"); //171
	manually_add_check_map_model("quad_bench_curved_01"); //172
	manually_add_check_map_model("quad_boulder_01"); //173
	manually_add_check_map_model("quad_boulder_02"); //174
	manually_add_check_map_model("quad_bridge_rope_01_anim"); //175
	manually_add_check_map_model("quad_cargo_net_01_full_anim"); //176
	manually_add_check_map_model("quad_chandelier1"); //177
	manually_add_check_map_model("quad_cliff_rock_large_01"); //178
	manually_add_check_map_model("quad_cliff_rock_large_02"); //179
	manually_add_check_map_model("quad_cliff_rock_large_03"); //180
	manually_add_check_map_model("quad_cliff_rock_large_03b"); //181
	manually_add_check_map_model("quad_door_handle_01"); //182
	manually_add_check_map_model("quad_double_door_01_left"); //183
	manually_add_check_map_model("quad_double_door_01_right"); //184
	manually_add_check_map_model("quad_flag_rectangular_orange"); //185
	manually_add_check_map_model("quad_flag_rectangular_yellow"); //186
	manually_add_check_map_model("quad_flag_triangular_orange"); //187
	manually_add_check_map_model("quad_flag_triangular_yellow"); //188
	manually_add_check_map_model("quad_floor_stones_group_01"); //189
	manually_add_check_map_model("quad_floor_stones_group_02"); //190
	manually_add_check_map_model("quad_floor_stones_group_05"); //191
	manually_add_check_map_model("quad_floor_stones_group_06"); //192
	manually_add_check_map_model("quad_floor_stones_single_01"); //193
	manually_add_check_map_model("quad_floor_stones_single_02"); //194
	manually_add_check_map_model("quad_floor_stones_single_03"); //195
	manually_add_check_map_model("quad_floor_stones_single_04"); //196
	manually_add_check_map_model("quad_floor_stones_single_05"); //197
	manually_add_check_map_model("quad_floor_stones_single_06"); //198
	manually_add_check_map_model("quad_floor_stones_single_07"); //199
	manually_add_check_map_model("quad_floor_stones_single_08"); //200
	manually_add_check_map_model("quad_floor_stones_single_09"); //201
	manually_add_check_map_model("quad_floor_stones_single_10"); //202
	manually_add_check_map_model("quad_floor_stones_single_11"); //203
	manually_add_check_map_model("quad_floor_stones_single_12"); //204
	manually_add_check_map_model("quad_floor_stones_single_13"); //205
	manually_add_check_map_model("quad_floor_stones_single_14"); //206
	manually_add_check_map_model("quad_floor_stones_single_15"); //207
	manually_add_check_map_model("quad_floor_stones_single_16"); //208
	manually_add_check_map_model("quad_floor_stones_single_17"); //209
	manually_add_check_map_model("quad_fountain_base"); //210
	manually_add_check_map_model("quad_rock_01"); //212
	manually_add_check_map_model("quad_rope_knot"); //215
	manually_add_check_map_model("quad_rope_pulley_01"); //216
	manually_add_check_map_model("quad_rope_spool_01"); //217
	manually_add_check_map_model("quad_shingle_front_32"); //218
	manually_add_check_map_model("quad_shingle_front_64"); //219
	manually_add_check_map_model("quad_shingle_front_double"); //220
	manually_add_check_map_model("quad_shingle_front_single"); //221
	manually_add_check_map_model("quad_shingle_front_worn_32"); //222
	manually_add_check_map_model("quad_shingle_front_worn_64"); //223
	manually_add_check_map_model("quad_shingle_side_64"); //224
	manually_add_check_map_model("quad_shingle_side_64_flip"); //225
	manually_add_check_map_model("quad_shingle_side_end_flip_lrg"); //226
	manually_add_check_map_model("quad_shingle_side_end_flip_sml"); //227
	manually_add_check_map_model("quad_shingle_side_end_flip_worn_lrg"); //228
	manually_add_check_map_model("quad_shingle_side_end_lrg"); //229
	manually_add_check_map_model("quad_shingle_side_end_sml"); //230
	manually_add_check_map_model("quad_shingle_side_worn_64"); //231
	manually_add_check_map_model("quad_shingle_side_worn_64_flip"); //232
	manually_add_check_map_model("quad_statue_monk_01"); //233
	manually_add_check_map_model("quad_stone_paver_01"); //234
	manually_add_check_map_model("quad_stone_paver_02"); //235
	manually_add_check_map_model("quad_stone_paver_03"); //236
	manually_add_check_map_model("quad_stone_paver_04"); //237
	manually_add_check_map_model("quad_stone_paver_05"); //238
	manually_add_check_map_model("quad_stone_paver_06"); //239
	manually_add_check_map_model("quad_stone_paver_07"); //240
	manually_add_check_map_model("quad_stone_paver_08"); //241
	manually_add_check_map_model("quad_stone_paver_09"); //242
	manually_add_check_map_model("quad_stone_paver_10"); //243
	manually_add_check_map_model("quad_trapdoor_wood_01"); //244
	manually_add_check_map_model("rock_estate_boulders1_tropical"); //249
	manually_add_check_map_model("rock_estate_boulders8_tropical"); //250
	manually_add_check_map_model("rope_swing"); //251
	manually_add_check_map_model("rope_swing_anim"); //252
	manually_add_check_map_model("static_seelow_woodbarrel_single"); //254
	manually_add_check_map_model("tile_overhang_01"); //255
	manually_add_check_map_model("tile_overhang_02"); //256
	manually_add_check_map_model("wooden_stool"); //258
	manually_add_check_map_model("wood_bench"); //259
	manually_add_check_map_model("wood_bench_dark"); //260
}