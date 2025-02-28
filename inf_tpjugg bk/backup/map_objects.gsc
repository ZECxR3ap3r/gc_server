#include scripts\inf_tpjugg\map_funcs;

init() {
    level.mapname = getdvar("ui_mapname");
    precacheshader("weapon_m16_iw5");
    precachemodel(getAlliesFlagModel(getdvar("ui_mapname")));
    precachemodel("prop_flag_neutral");
    precachemodel("com_plasticcase_green_big");
    
    level.flag_exit_shader = "compass_waypoint_target";
    
    precacheshader("waypoint_flag_friendly");
    precacheshader(level.flag_exit_shader);
    precacheshader("compass_waypoint_bomb");
    precachemodel("projectile_cbu97_clusterbomb");
    precachemodel("projectile_javelin_missile");
    
    level thread spawnObjects();
}

spawnObjects() {
    rnd = undefined;

    switch(getdvar("ui_mapname")){
        case "mp_village":
            level.meat_playable_bounds = [
                (-448.797, -4094.38, 1352.15),
                (-5746.19, -4099.51, 1358.47),
                (-5750.29, -3132.04, 1355.26),
                (-3073.89, -3130.34, 1352.13),
                (-1792.87, -2423.5, 1352.13),
                (-1020.57, -2749.4, 1352.13),
                (-318.149, -3520.32, 1344.16)
            ];
            
            thread createPolygon();
            thread CreateWalls((-640, -3460, 1400),(-600, -3260, 1320));
            thread CreateWalls((-555, -3240, 1375),(-335, -3460, 1375));
            thread CreateWalls((-315, -3475, 1375),(-455, -4105, 1375));
            thread CreateWalls((-455, -4105, 1375),(-620, -4105, 1375));
            thread CreateWalls((-2460, -3210, 1400),(-2460, -2930, 1320));
            thread CreateWalls((-4520, -3790, 1365),(-4520, -3990, 1320));
            thread createTurret((-4525,-3830,1397), (0,0,0));
            thread createTurret((-4525,-3945,1397), (0,0,0));
            thread CreateWalls((-3380, -4080, 1400),(-3380, -3880, 1320));
            thread moveac130position((-3380, -4080, 1400));
            thread CreateWalls((-4700, -4100, 1400),(-4700, -3710, 1320));
            thread CreateDoors((-4700,-3830,1360) /*open*/, (-4700,-3590,1360) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 120 /*range*/, true /*sideways*/);
            thread CreateWalls((-4700, -3470, 1400),(-4700, -3120, 1320));
            thread createTP((-702.28, -2069.41, 296.697), (-514.905, -3360.75, 1344.13), undefined);
            thread createTP((-132.622,-640.915,399.324), (-514.905, -3360.75, 1344.13), undefined);
            thread createTP((-1076.34,1597.55,262.125), (-514.905, -3360.75, 1344.13), undefined);
            thread createTP((141.4,-2770.87,327.646), (-514.905, -3360.75, 1344.13), undefined);
            thread createTP((704.721,-802.928,276.813), (-514.905, -3360.75, 1344.13), undefined);
            thread createTP((88.9215,1346.11,270.154), (-514.905, -3360.75, 1344.13), undefined);
            thread createHiddenTP((-5690.35,-4089.9,1344.13), (-2053.21,453.705,261.088), undefined, "out");
            break;
		case "mp_hillside_ss":
			level.meat_playable_bounds = [
	         (1152.46, -919.125, 6.92505),
                (-143.149, -993.39, 92.125), 
                (-897.875, -1338.7, 92.125),
                (-2377, -1311.38, 174.679),
                (-2377, -1556.53, 180.125),
                (-2377, -2362.79, 180.125),
                (-1708.12, -2362.79, 372.125),
                (-1708.12, -2484.12, 372.125),
                (-895.375, -2484.12, 372.125),
                (-657.375, -2270.5, 372.125),
				(1138, -3270.5, 372.125),
                (1721.32, -2423.06, 174.425),  
				(1721, -802, 108.125),
				(1167.15, -795.125, 2600.125),
				(1464.88, -12.934, 2600.125),
				(1464.88, 369.875, 2600.125),
				(1163.12, 369.875, 2600.125),
				(1163.15, -16.875, 2600.125)
	            ];
			
			 	thread createPolygon();
			 	
		        thread CreateRamps((-1641, -1492, 2266.37),(-1641, -1588, 2338.13),30);
		        thread spawncrate((-2131, -1699, 2500),(0,0,0));
		        thread spawncrate((-2061, -1699, 2500),(0,0,0));
		
		
	 
				ent = spawn("script_model", (559, -2902, 2216));
                ent.angles = (0, 9, 0);
           	    ent setmodel("prk_river_rock_05");	
		
		        ent = spawn("script_model", (-2077, -1670, 2461));
                ent.angles = (0, 9, 0);
           	    ent setmodel("billiard_table_modern_teal");	
			    ent = spawn("script_model", (-2109, -1680, 2495));
                ent.angles = (0, 9, 0);
                ent setmodel("me_banana");
				ent = spawn("script_model", (-2074, -1712, 2736));
                ent.angles = (0, 33, 0);
                ent setmodel("me_banana");
				ent = spawn("script_model", (-2064, -1692, 2736));
                ent.angles = (3, 130, 0);
                ent setmodel("me_banana");
				ent = spawn("script_model", (1799, -1847, 2170));
                ent.angles = (0, 0, 0);
                ent setmodel("ch_wooden_fence_post_04");
				ent = spawn("script_model", (1797, -2035, 2170));
                ent.angles = (0, 0, 0);
                ent setmodel("ch_wooden_fence_post_04");
				ent = spawn("script_model", (1688, -2291, 2160));
                ent.angles = (0, 0, 0);
                ent setmodel("ch_wooden_fence_post_04");
				ent = spawn("script_model", (1959, -1597, 2170));
                ent.angles = (0, 0, 0);
                ent setmodel("ch_wooden_fence_post_04");
				ent = spawn("script_model", (728, -1461, 2220));
                ent.angles = (0, 2, 0);
                ent setmodel("thatched_hut_large");
				ent = spawn("script_model", (1537, -1249, 2240));
                ent.angles = (90, 90, 0);
                ent setmodel("thatched_hut_large");
				ent = spawn("script_model", (-280, -1800.6, 2175));
                ent.angles = (0, 0, 0);
                ent setmodel("foliage_hedge_boxy_overgrown");
				ent = spawn("script_model", (-290, -1800.6, 2175));
                ent.angles = (0, 180, 0);
                ent setmodel("foliage_hedge_boxy_overgrown");
				ent = spawn("script_model", (-289, -2141.6, 2191));
                ent.angles = (0, 0, 0);
                ent setmodel("foliage_hedge_boxy_overgrown2");
				ent = spawn("script_model", (728, -1461, 2220));
                ent.angles = (90, 2, 0);
                ent setmodel("thatched_hut_large");
				ent = spawn("script_model", (728, -1461, 2220));
                ent.angles = (90, 182, 0);
                ent setmodel("thatched_hut_large");
				
				thread CreateInvisWalls((1455, -1112, 2245),(1616, -1112, 2300));
				thread CreateInvisWalls((854, -1550, 2260),(854, -1375.5, 2315));
				thread CreateInvisWalls((603, -1550, 2260),(603, -1375.5, 2315));
				//mansion gate
				thread CreateQuicksteps((-923, -2020, 2310), 100, 16, 2, (0, 0,0));	
                thread CreateQuicksteps((-923, -2020, 2310), 100, 16, 2, (0, 180,0));		
	            thread CreateQuicksteps((-923, -1832, 2310), 100, 16, 2, (0, 0,0));	
                thread CreateQuicksteps((-923, -1832, 2310), 100, 16, 2, (0, 180,0));				
				thread createTurret((-1503, -2057, 2481), (0,0,0), 50, 50, 30, 10);
				ent = spawn("script_model", (-1503, -2057, 2460));
                ent.angles = (0, 80, 0);
                ent setmodel("furniture_modern_patio_ottoman");
				//mansion glass walls
				thread spawncrate((-1491, -1726, 2499),(0,0,0));
				thread spawncrate((-1571, -1726, 2499),(0,0,0));
				ent = spawn("script_model", (-1469, -1733, 2455));
                ent.angles = (0, 90, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1531, -1733, 2455));
                ent.angles = (0, 90, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1714, -1733, 2455));
                ent.angles = (0, 90, 0);
                ent setmodel("fence_glass");
				thread spawncrate((-1734, -1733, 2499),(0,0,0));
				thread spawncrate((-1491, -2336, 2495),(0,0,0));
				thread spawncrate((-1579, -2336, 2495),(0,0,0));
				thread spawncrate((-1667, -2336, 2495),(0,0,0));
				thread spawncrate((-1755, -2336, 2495),(0,0,0));
				ent = spawn("script_model", (-1797, -2326, 2455));
                ent.angles = (0, 270, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1732, -2326, 2455));
                ent.angles = (0, 270, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1667, -2326, 2455));
                ent.angles = (0, 270, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1602, -2326, 2455));
                ent.angles = (0, 270, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1537, -2326, 2455));
                ent.angles = (0, 270, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1469, -2320, 2455));
                ent.angles = (0, 0, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1469, -2255, 2455));
                ent.angles = (0, 0, 0);
                ent setmodel("fence_glass");
				ent = spawn("script_model", (-1469, -2190, 2455));
                ent.angles = (0, 0, 0);
                ent setmodel("fence_glass");
				thread spawncrate((-1461, -2281, 2495),(0,90,0));
				thread spawncrate((-1461, -2152, 2495),(0,90,0));
				thread spawncrate((-1461, -2217, 2495),(0,90,0));
				//doors
				thread CreateDoors((-1734, -1733, 2499) /*open*/,(-1649, -1733, 2499) /*close*/, (90,90,0) /*angle*/, 2 /*size*/, 1 /*height*/, 15 /*hp*/, 80 /*range*/);
				thread CreateDoors((-1840, -2038.4, 2585) /*open*/, (-1840, -2038.4, 2475) /*close*/, (90,0,0) /*angle*/, 6 /*size*/, 2 /*height*/, 30 /*hp*/, 180 /*range*/);
				//roof
				thread CreateGrids((-2190, -2177, 2871),(-1970, -2177, 2871), (0,0,0));
				thread CreateGrids((-2190, -1902, 2871),(-1970, -1902, 2871), (0,0,0)); 
				//house tps
				thread createTP((-2308, -2267, 2466), (-2244, -2259, 2890), (0,30,0));
				thread createTP((-2182, -1746.38, 2890), (-2308, -1780, 2466), (0,330,0));
				thread createTP((-2182, -1746.38, 2653), (1203, 87, 2319), (0,45,0));
				thread createHiddenTP((-978.28,-1382.125,2254.125), (-487.49,-837.31,2234.598), (0, 25, 0), "out");
				//IN MAP TPS
				thread createTP((533, -168.38, 2209), (1559, -2404, 2200), (0,170,0));
				thread createTP((-148, -33.38, 2219), (727, -2956, 2210), (0,170,0));
				thread createTP((-388.6, 943.38, 2182), (1613, -1231.5, 2245), (0,182,0));
				thread createTP((1643, 504.38, 2311), (1613, -1231.5, 2245), (0,182,0));
			    thread moveac130position((-455, -1772, 1500));
                thread fufalldamage((-1589, -2015, 2452),400, 420);
		break;
        case "mp_paris":

            rnd = randomint(2);
            if(rnd == 0)
            {
                thread CreateWalls((-1190, 2620, 230),(-1190, 2620, 330),(0,0,90));
                thread CreateDoors((-1070, 2620, 340) /*open*/, (-1070, 2620, 250) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, true /*sideways*/);
                thread CreateWalls((-950, 2620, 230),(-950, 2620, 330),(0,0,90));

                thread CreateWalls((-3380, 1710, 240),(-3375, 1710, 360),(0,0,90));
                thread CreateDoors((-3260, 1710, 370) /*open*/, (-3260, 1710, 280) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, true /*sideways*/);
                thread CreateWalls((-3140, 1710, 240),(-3140, 1710, 360),(0,0,90));

                thread CreateWalls((-3670, 1720, 240),(-3670, 1720, 360),(0,90,90));
                thread CreateDoors((-3670, 1600, 370) /*open*/, (-3670, 1600, 280) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 25 /*hp*/, 120 /*range*/, true /*sideways*/);
                thread CreateWalls((-3670, 1480, 240),(-3670, 1480, 360),(0,90,90));


                thread CreateWalls((-5160, 1770, 350),(-5240, 1770, 240));
                thread CreateWalls((-5250, 900, 330),(-4860, 900, 240));
                thread CreateWalls((-5250, 900, 280),(-4860, 900, 280));
                thread CreateWalls((-5250, 900, 330),(-4860, 900, 330));
                thread CreateWalls((-5250, 900, 380),(-4860, 900, 380));

                thread CreateWalls((-4900, 1570, 270),(-4900, 1490, 240));

                thread createTurret((-4900,1500,300), (0,0,0));
                thread createTurret((-4900,1560,300), (0,0,0));

                thread createTP((-274.169,-977.591,31.9036), (-1106.66,2912.26,221.417), undefined);
                thread createTP((-1946.99,860.39,248.125), (-1094.22,2905.95,222.105), undefined);
                thread createTP((-796.373,39.0597,57.3202), (-1098.99,2901.76,221.701), undefined);
                thread createTP((1028.24,462.045,-18.875), (-1089.8,2894.93,222.39), undefined);
                thread createTP((1122.24,1869.16,-32.7764), (-1098.87,2906.89,221.69), undefined);
                thread createTP((-343.239,1925.08,-51.875), (-1095.11,2895.09,222.081), undefined);
                thread createHiddenTP((-4943.13,941.415,260.016), (-1587.67,350.486,68.0757), undefined, "out");
            }
            else if(rnd == 1) {
                level.meat_playable_bounds = [
                    (187.835, -1548.32, 937.125),
                    (-152.917, -1548.34, 937.125),
                    (-155.396, -1095.49, 937.125),
                    (-309.248, -1095.5, 937.125),
                    (-309.251, -1589.48, 937.125),
                    (-417.745, -1589.5, 896.125),
                    (-418.563, -2346.09, 967.708),
                    (132.857, -3130.16, 282.441),
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

                thread createPolygon();

                thread CreateWalls((620, -2850, 60),(620, -3450, 60));
                thread CreateWalls((620, -2850, 110),(620, -3450, 110));
                thread CreateWalls((620, -2850, 160),(620, -3450, 160));

                thread CreateWalls((120, -3150, 60),(120, -3450, 60));
                thread CreateWalls((120, -3150, 110),(120, -3450, 110));
                thread CreateWalls((120, -3150, 160),(120, -3450, 160));

                thread spawncrate((565, -3445, 33), (0, 0, 0), "com_plasticcase_friendly");

                thread CreateWalls((903, -2300, 30),(903, -2070, 120));
                thread CreateRamps((760, -1875, 10),(570, -1875, 62));

                thread CreateWalls((580, -2340, 100),(460, -2340, 190));
                thread spawncrate((590, -2340, 65), (90, 0, 0), "com_plasticcase_friendly");
                
                thread CreateWalls((180, -2570, 40),(180, -2570, 150),(0,0,90));
                thread CreateWalls((330, -2570, 40),(385, -2570, 150));
                
                thread spawncrate((510, -1580, 401), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((510, -1625, 401), (0, 90, 0), "com_plasticcase_friendly");

                thread CreateGrids((905, -1545, 644),(905, -1670, 644), (0,0,0));
                thread CreateRamps((885, -1650, 640),(160, -1650, 700));
            
                thread CreateWalls((1167, -1100, 670),(1167, -1570, 670));
                thread CreateWalls((1167, -1100, 720),(1167, -1570, 720));

                thread CreateGrids((918, -2300, 141),(1065, -2030, 141), (0,0,0));
                thread CreateGrids((1167, -1570, 580),(1410, -1570, 580), (25,-90,90));
                thread CreateGrids((1167, -1570, 520),(1410, -1570, 520), (25,-90,90));
                thread CreateGrids((1167, -1570, 460),(1410, -1570, 460), (25,-90,90));

                thread CreateGrids((975, -1560, 530),(1125, -1560, 530), (25,-90,90));
                thread CreateGrids((975, -1560, 500),(1125, -1560, 500), (25,-90,90));
                thread CreateGrids((975, -1560, 470),(1125, -1560, 470), (25,-90,90));
                thread CreateGrids((975, -1560, 440),(1125, -1560, 440), (25,-90,90));

                thread CreateInvisWalls((-322, -1573, 910),(-322, -1110, 910));
                thread spawncrate((-322, -1130, 850), (0, 90, 90));

                thread spawncrate((-366, -1593, 920), (0, 0, 90));

                thread CreateInvisWalls((-420, -1630, 910),(-420, -2330, 910));
                thread CreateInvisWalls((-400, -2359, 830),(-210, -2359, 830));

                thread CreateInvisWalls((-143, -1090, 910),(-143, -1535, 910));
                thread CreateInvisWalls((-111, -1535, 910),(160, -1535, 910));
                thread CreateInvisWalls((-320, -1081, 910),(-175, -1081, 910));
                
                thread CreateDoors((260, -2570, 150) /*open*/, (260, -2570, 50)/*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 40 /*hp*/, 120 /*range*/);

                thread createHiddenTP((525, -2428, 48), (1066, -1593, 409), (0, -90, 0), undefined, true);
                thread createHiddenTP((-376, -2309, 820.125), (-1763, 718, 248.125), (25, -90, 0), "out", true);

                thread createTP((-274.169,-977.591,31.9036), (1002, -2277, 29.6926), undefined);
                thread createTP((-1946.99,860.39,248.125), (1002, -2277, 29.6926), undefined);
                thread createTP((-796.373,39.0597,57.3202), (1002, -2277, 29.6926), undefined);
                thread createTP((1028.24,462.045,-18.875), (1002, -2277, 29.6926), undefined);
                thread createTP((1122.24,1869.16,-32.7764), (1002, -2277, 29.6926), undefined);
                thread createTP((-343.239,1925.08,-51.875), (1002, -2277, 29.6926), undefined);
            }
            break;
        case "mp_exchange":
            rnd = randomint(3);
            
            if(rnd == 0) {
                thread CreateWalls((4190, 1665, 1010),(4720, 1665, 1010));

                thread CreateWalls((4765, 1690, 1180),(4765, 1790, 1010));

                thread CreateWalls((5390, 2230, 1060),(6010, 2230, 970));
                thread CreateDoors((5040, 3445, 1040) /*open*/, (5040, 3650, 1040) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                thread CreateWalls((5040, 3760, 1080),(5040, 3760, 990),(0,90,90));

                thread CreateRamps((4460,1625,1040), (4460,1015,855)); //ramp small

                thread spawncrate((3240, 2370, 1360), (90,0,0), "com_plasticcase_trap_friendly");
                thread createTurret((3240, 2370, 1395), (0,0,0), 60, 18, undefined, 10);

                thread cannonball((4584, 566, 968), (0,0,0), (-70,600,700), 3, (4556, 1768, 1058), 900);
                

                thread createTP((-124.827,-1578.52,44.0955), (4286.72,147.162,1028.13), undefined, true);
                thread createTP((1293.41,1635.58,88.125), (4289.37,136.012,1028.13), undefined, true);
                thread createTP((-645.692,1296.37,54.3093), (4457.81,351.375,1028.13), undefined, true);
                thread createTP((660.841,-1262.38,27.5371), (4175.44,365.429,1028.13), undefined, true);
                thread createTP((2270.57,1151.03,96.7406), (4285.04,212.019,1028.13), undefined, true);
                thread createTP((-410.885,121.441,229.125), (4230.13,445.576,1028.13), undefined, true);
                thread createHiddenTP((5430, 2297, 998.125), (3169.54,2652.23,1359.13), undefined);
                thread createHiddenTP((-164.728,2885.13,1590), (450.253,1335.79,206.125), undefined);
				
				thread CreateRamps((4460, 3670, 984),(4320, 3670, 900));

				thread CreateWalls((4195, 2680, 920),(4195, 2930, 990));
				thread CreateWalls((4480, 3160, 1010),(4480, 3330, 1080));
				thread CreateWalls((4480, 2100, 1010),(4480, 2290, 1080));

				thread CreateElevator((2500, 2460, 1345),(2445, 2520, 1345), 255, 1.25);
				thread CreateGrids((2370, 2460, 1600),(2370, 2520, 1600), (0,0,0));

				thread CreateQuicksteps((2325, 2490, 1600), 75, 15, 2, (0,180,0));

				thread CreateRamps((710, 2670, 1545),(710, 2820, 1592));
				thread CreateRamps((635, 2950, 1605),(635, 3030, 1628));
				thread CreateGrids((730, 2885, 1600),(640, 2915, 1600), (0,0,0));
				thread spawncrate((635, 3065, 1639), (0, 0, 0));
				thread spawncrate((635, 3100, 1639), (0, 0, 0));

				thread CreateRamps((570, 2950, 1590),(570, 3030, 1628));
				thread spawncrate((570, 3065, 1639), (0, 0, 0));
				thread spawncrate((570, 3100, 1639), (0, 0, 0));

				thread CreateWalls((4190, 1680, 1060),(4190, 2080, 980));
				thread createRamps((4410,2200,920), (4410,2100,971));

				thread moveac130position((3248, 2373, 2044.19));

				thread createDeathRegion((2810, -2000, 0),(7500, 6000, 820));
				thread createDeathRegion((2810, 1760, 0), (-3000, 6000, 740));
            }
            else if(rnd == 1) {
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

                thread createPolygon();

                thread CreateRamps((4145,2390,903), (3255,2390,1332)); //ramp big

                thread CreateWalls((5035, 3590, 1090),(5035, 3780, 970));

                thread cannonball((4450, 2830, 910), (0,90,0), (-450,-150,1200), 5, (3153, 2627, 1419), 900);

                thread createTP((-124.827,-1578.52,44.0955), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createTP((1293.41,1635.58,88.125), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createTP((-645.692,1296.37,54.3093), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createTP((660.841,-1262.38,27.5371), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createTP((2270.57,1151.03,96.7406), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createTP((-410.885,121.441,229.125), (4935.8, 3644.15, 998.125), (0,180,0), true);
                thread createHiddenTP((-164.728,2885.13,1590), (450.253,1335.79,206.125), undefined, "out");
                thread CreateRamps((4460, 3670, 984),(4320, 3670, 900));

	            thread CreateWalls((4195, 2680, 920),(4195, 2930, 990));
	            thread CreateWalls((4480, 3160, 1010),(4480, 3330, 1080));
	            thread CreateWalls((4480, 2100, 1010),(4480, 2290, 1080));
	
	            thread CreateElevator((2500, 2460, 1345),(2445, 2520, 1345), 255, 1.25);
	            thread CreateGrids((2370, 2460, 1600),(2370, 2520, 1600), (0,0,0));
	
	            thread CreateQuicksteps((2325, 2490, 1600), 75, 15, 2, (0,180,0));
	
	            thread CreateRamps((710, 2670, 1545),(710, 2820, 1592));
	            thread CreateRamps((635, 2950, 1605),(635, 3030, 1628));
	            thread CreateGrids((730, 2885, 1600),(640, 2915, 1600), (0,0,0));
	            thread spawncrate((635, 3065, 1639), (0, 0, 0), "com_plasticcase_friendly");
	            thread spawncrate((635, 3100, 1639), (0, 0, 0), "com_plasticcase_friendly");
	
	            thread CreateRamps((570, 2950, 1590),(570, 3030, 1628));
	            thread spawncrate((570, 3065, 1639), (0, 0, 0), "com_plasticcase_friendly");
	            thread spawncrate((570, 3100, 1639), (0, 0, 0), "com_plasticcase_friendly");
	
	            thread CreateWalls((4190, 1680, 1060),(4190, 2080, 980));
	            thread CreateRamps((4410,2200,920), (4410,2100,971));
	
	            thread moveac130position((3248, 2373, 2044.19));
	
	            thread createDeathRegion((2810, -2000, 0),(7500, 6000, 740));
	            thread createDeathRegion((2810, 1760, 0), (-3000, 6000, 740));
            }
            else if(rnd == 2) {
            	level.meat_playable_bounds = [
	                (387, 2054, 22),
                (387, 1771, 22),
				(-885, -1023, 22),
				(-885, -3134, 22),
				(-1881, -3134, 22),
				(-1881, -2535, 22),
				(-1608, -2535, 22),
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
				
				thread createPolygon();
				
            	thread CreateWalls((-1352, 3352, 400),(-257, 3352, 400));
				thread CreateWalls((-1352, 3352, 340),(-257, 3352, 340));
				thread CreateWalls((-1352, 3352, 280),(-257, 3352, 280));
				thread CreateWalls((-1352, 3352, 220),(-257, 3352, 220));
				thread CreateWalls((-1352, 3352, 160),(-257, 3352, 160));
               
				thread CreateInvisWalls((-1397, 3437, 350.693),(-1397, 3197, 350.693));
				
				thread CreateInvisWalls((-1397, 3017, 350.693),(-1397, 3167, 350.693));
				
				thread CreateInvisWalls((-1397, 3017, 290.693),(-1397, 3197, 290.693));
				
				thread CreateInvisWalls((-1370, 2427, 330.693),(-1370, 2607, 330.693));
				thread CreateInvisWalls((-1370, 2347, 360.693),(-1370, 2690, 360.693));
				thread CreateInvisWalls((-1370, 2347, 390.693),(-1370, 2607, 390.693));
				thread CreateInvisWalls((-1370, 2267, 420.693),(-1370, 3007, 420.693));
				
				thread CreateInvisWalls((-1350, 2675, 280),(-1350, 2804, 335));
				thread CreateInvisWalls((-1395, 2692, 260),(-1395, 2804, 260));
				
				thread spawncrate((-1350, 2788, 384), (0, 90, 0));
				thread spawncrate((-1350, 2788, 434), (0, 90, 0));
				
				thread CreateDoors((-1376, 2907.5, 400) /*open*/, (-1376, 2907.5, 300) /*close*/, (90,8,0) /*angle*/, 4 /*size*/, 3 /*height*/, 60 /*hp*/, 140 /*range*/, true /*sideways*/);
				
				ent = spawn("script_model", (-1398, 2286, 322.125));
                ent.angles = (0, 0, 90);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1405, 3184, 313.125));
                ent.angles = (270, 1, 90);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1410, 3164, 373.125));
                ent.angles = (90, 181, 90);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1374, 2576, 373.125));
                ent.angles = (90, 181, 90);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1348.5, 2795, 333.125));
                ent.angles = (0, 181, 0);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1361.92, 2755.72, 343.125));
                ent.angles = (180, 181, 0);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1348.5, 2777, 363.125));
                ent.angles = (0, 201, 80);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
				ent = spawn("script_model", (-1363.5, 2681, 400.125));
                ent.angles = (0, 93, 80);
                ent setmodel("concrete_slabs_lrg1");
				
				ent = spawn("script_model", (-1348.5, 2466, 500.125));
                ent.angles = (40, 90, 80);
                ent setmodel("concrete_slabs_lrg1");
				
				ent = spawn("script_model", (-1357.5, 2902, 528.125));
                ent.angles = (0, 90, 80);
                ent setmodel("concrete_slabs_lrg1");
				 //1st area
				ent = spawn("script_model", (-1604, -1570, 1116.125));
                ent.angles = (0, 0, 270);
                ent setmodel("berlin_hotel_metalawning_01");
				
				ent = spawn("script_model", (-2176, -1570, 1116.125));
                ent.angles = (0, 0, 270);
                ent setmodel("berlin_hotel_metalawning_01");
				
				ent = spawn("script_model", (-1813, -1579, 1258));
                ent.angles = (0, 180, 0);
                ent setmodel("berlin_hotel_lights_wall2_on");
				
				ent = spawn("script_model", (-1966, -1579, 1258));
                ent.angles = (0, 180, 0);
                ent setmodel("berlin_hotel_lights_wall2_on");
				
				ent = spawn("script_model", (-1690, -3028, 1110));
                ent.angles = (0, 90, 0);
                ent setmodel("berlin_rooftop_utilitybox");
				
				ent = spawn("script_model", (-1851, -3028, 1110));
                ent.angles = (0, 90, 0);
                ent setmodel("berlin_rooftop_utilitybox");
				
				ent = spawn("script_model", (-1683, -1570, 1269));
                ent.angles = (0, 180, 210);
                ent setmodel("ny_manhattan_sewer_wires_01");
				
				ent = spawn("script_model", (-2090, -1570, 1270));
                ent.angles = (0, 180, 350);
                ent setmodel("ny_manhattan_sewer_wires_01");
                
				ent = spawn("script_model", (-2390, -1570, 1270));
                ent.angles = (0, 180, 70);
                ent setmodel("ny_manhattan_sewer_wires_01");
				
				ent = spawn("script_model", (-1677, -1570, 1270));
                ent.angles = (0, 0, 70);
                ent setmodel("ny_manhattan_sewer_wires_01");
				
				ent = spawn("script_model", (-1390, -1530, 1172));
                ent.angles = (0, 270, 0);
                ent setmodel("icbm_electricpanel1");
				
				ent = spawn("script_model", (-1390, -1461, 1172));
                ent.angles = (0, 270, 90);
                ent setmodel("com_telephone_wall");
				
				ent = spawn("script_model", (-1398, -1484, 1172));
                ent.angles = (0, 180, 00);
                ent setmodel("com_fire_extinguisher_incase");
				 
				ent = spawn("script_model", (-1693, -254, 770));
                ent.angles = (0, 90, 0);
                ent setmodel("prague_awning02_green");
				   
				thread CreateDoors((-1708, -1565, 1140.125) /*open*/, (-1890, -1565, 1140.125) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 3 /*height*/, 40 /*hp*/, 100 /*range*/, true /*sideways*/);
				
				thread spawncrate((-1426, -1562, 1160), (0, 0, 0));
				thread spawncrate((-1514, -1562, 1160), (0, 0, 0));
				thread spawncrate((-1602, -1562, 1160), (0, 0, 0));
				thread spawncrate((-1690, -1562, 1160), (0, 0, 0));
				thread spawncrate((-1778, -1562, 1160), (0, 0, 0));
			    thread spawncrate((-1426, -1562, 1220), (0, 0, 0));
				thread spawncrate((-1514, -1562, 1220), (0, 0, 0));
				thread spawncrate((-1602, -1562, 1220), (0, 0, 0));
				thread spawncrate((-1690, -1562, 1220), (0, 0, 0));
				thread spawncrate((-1778, -1562, 1220), (0, 0, 0));
				
				thread spawncrate((-1942, -1573, 1250), (0, 0, 0));
				thread spawncrate((-1854, -1573, 1250), (0, 0, 0));
				
				thread spawncrate((-1639, -2450, 1160), (0, 90, 0));
				thread spawncrate((-1639, -2370, 1160), (0, 90, 0));
				thread spawncrate((-1639, -2290, 1160), (0, 90, 0));
				thread spawncrate((-1639, -2210, 1160), (0, 90, 0));
				
		        thread spawncrate((-1914, -3026, 1160), (0, 90, 0));
				thread spawncrate((-1914, -3100, 1160), (0, 90, 0));
				
				thread spawncrate((-2000, -1780, 1170), (90, 90, 0));
				thread spawncrate((-2000, -1720, 1170), (90, 90, 0));
				
				
				thread CreateQuicksteps((-1403, -1356, 1370), 280, 18, 2, (0,180,0));
				thread fufalldamage((-1300, -1476, 1100.125), 600, 300);
				thread fufalldamage((-1670, -245, 590.125), 140, 527);
				
				//hole patches
				thread CreateGrids((-1530, 3460, 387.152),(-1669, 3460, 384.693), (0,0,0));
                thread spawncrate((-1656, 3425, 384.693), (0, 0, 0), "com_plasticcase_friendly");
				thread spawncrate((-270, 3322, 180.693), (0, 0, 0), "com_plasticcase_friendly");
				
				thread spawncrate((-454, 1881, 65), (0, 0, 0), "com_plasticcase_friendly");
				thread spawncrate((-454, 1931, 65), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-454, 1981, 65), (0, 0, 0), "com_plasticcase_friendly");
		  
		        thread spawncrate((-534, 1881, 65), (0, 0, 0), "com_plasticcase_friendly");
		        thread spawncrate((-534, 1931, 65), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-544, 1981, 65), (0, 0, 0), "com_plasticcase_friendly");
		        thread spawncrate((-454, 2121, 62), (0, 0, 0), "com_plasticcase_friendly");
		        thread spawncrate((-514, 2121, 62), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-454, 2161, 59), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-558, 2060, 62), (0, 90, 0), "com_plasticcase_friendly");
 
                thread createTP((-124.827,-1578.52,40.0955), (-1846,-3018.48,1120.13), (0,0,0), true);
				
                thread createTP((1293.41,1635.58,88.125), (-1846,-3018.48,1120.13), (0,0,0), true);
                thread createTP((-645.692,1296.37,54.3093), (-1846,-3018.48,1120.13), (0,0,0), true);
                thread createTP((2270.57,1151.03,96.7406), (-1846,-3018.48,1120.13), (0,0,0), true);
                thread createTP((-410.885,121.441,229.125), (-1686, -3028, 1120.13), (0,0,0), true); 
				
				thread createTP((349.1, -869.25, -180), (-1686, -3028, 1120.13), (0,0,0), true);				
				thread createTP((-983, -451, -21), (-1686, -3028, 1120.13), (0,0,0), true);
				
				ent = spawn("script_model", (87.6, 1954, 190.125));
                ent.angles = (0, 170, 14);
                ent setmodel("concrete_pillarchunk_lrg_01");
				
			 	thread createHiddenTP((-1248, 1827, 90.875), (-247.5, -629, -102), (0, 0, 0), "out");
			 
			 	thread createTurret((-1390, 2175, 335), (0,0,0), 50, 50, 30, 10);
			 
			 //1st flag delayed spawn
			 	thread createTP((-1333, -1085, 1382), (-1220, -429, 1181.13), (0,170,0), undefined, undefined, undefined, 100);
			 	thread createTP((-2321, -1095, 1116), (-1220, -429, 1181.13), (0,170,0), undefined, undefined, undefined, 100);
				
				ent = spawn("script_model", (-1661, -500, 1155));
                ent.angles = (27, 152, 0);
                ent setmodel("usa_sign_oneway2_right");
				
				ent = spawn("script_model", (-1735, -121, 1180));
                ent.angles = (313, 0, 0);
                ent setmodel("usa_sign_oneway2_left");
				
				ent = spawn("script_model", (-1751, -121, 1110));
                ent.angles = (270, 0, 0);
                ent setmodel("usa_sign_oneway2_left");
				
				ent = spawn("script_model", (-1751, -121, 1040));
                ent.angles = (270, 0, 0);
                ent setmodel("usa_sign_oneway2_left");
				
				ent = spawn("script_model", (-1666, -496, 1065));
                ent.angles = (70, 0, 0);
                ent setmodel("hind_arena_safenet_pole");
			 	
			//2nd
			 	thread createTP((-2728, -35, 590), (251.762, 1995.88, 160.13), (0,188,0), undefined, undefined, undefined, 115);
			 
			 	thread spawncrate((-1240, -462.5, 1140), (0, 0, 0));
             	thread spawncrate((-1240, -402.5, 1140), (0, 0, 0));
             	thread spawncrate((-1240,  -342.5, 1140), (0, 0, 0));
				
				thread CreateDeathRegion((-1569, -1600, -100), (-3493, 46, 200));
				
				thread spawncrate((-1155,  -525.5, 1155), (0, 90, 0));
				thread spawncrate((-1155,  -525.5, 1185), (0, 90, 0));
				thread spawncrate((-1150,  -196.5, 1175), (90, 0, 0));
			 
				thread spawncrate((-1418,  -180.5, 1192), (0, 0, 0));
				thread spawncrate((-1490,  -180.5, 1192), (0, 0, 0));
				thread spawncrate((-1490,  -180.5, 1162), (0, 0, 0));
				thread spawncrate((-1690,  -269, 1162), (90, 0, 0));
            }
            break;
        case "mp_lambeth":

            rnd = randomint(2);
            if(rnd == 0)
            {
            level.meat_playable_bounds =
            [
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

            thread createPolygon();

            //ents
                ent = spawn("script_model", (-2237, -4554, -220));
                ent.angles = (0, 00, 0);
                ent setmodel("com_propane_tank02");

                ent = spawn("script_model", (-1369, -4300, -246.875));
                ent.angles = (0, 90, 0);
                ent setmodel("junk_crushedcars_1");
            //No way its all walls
            thread CreateWalls((-2410, -4637, -240),(-2410, -4052, -240));
            thread CreateWalls((-2410, -4637, -180),(-2410, -4052, -180));
            thread CreateWalls((-2380, -4052, -240),(-1978, -4052, -240));
            thread CreateWalls((-2380, -4052, -180),(-1978, -4052, -180));
            thread CreateWalls((-2095, -4668, -240),(-1956, -4668, -240));
            thread CreateWalls((-2095, -4668, -180),(-1956, -4668, -180));
            thread CreateWalls((-1978, -3813, -240),(-1978, -2992, -240));
            thread CreateWalls((-1978, -3813, -180),(-1978, -2992, -180));
            thread CreateWalls((-995, -3478, -240),(-995, -2325, -240));
            thread CreateWalls((-995, -3478, -180),(-995, -2325, -180));
            thread CreateWalls((-1026, -2295, -240),(-2039, -2295, -240));
            thread CreateWalls((-1026, -2295, -180),(-2039, -2295, -180));
            thread CreateWalls((-1001, -4312, -240),(-1001, -3703, -240));
            thread CreateWalls((-1001, -4312, -180),(-1001, -3703, -180));
            thread CreateWalls((-1913, -4857, -240),(-1071, -4857, -240));
            thread CreateWalls((-1913, -4857, -180),(-1071, -4857, -180));
            thread CreateWalls((-1873, -4090, -240),(-1668, -4090, -160));
            thread CreateWalls((-1667, -4110, -240),(-1667, -4650, -160));
            thread CreateWalls((-1637, -4650, -240),(-1311, -4650, -240));
            thread CreateWalls((-1637, -4650, -185),(-1311, -4650, -185));
            //solid wall for hiding
            thread CreateWalls((-1100, -3800, -240),(-1220, -3800, -160));
            //thread CreateQuicksteps((3940,680,-100), 200, 20, 20, (0, 173.766, 0));
            thread CreateQuicksteps((-1775, -2513, -75), 190, 18, 2, (0,-6.30,0));
            thread CreateGrids((-1400, -2700, -109),(-1545, -2620, -109), (0,0,0));
            thread fufalldamage((-1586, -4186, -246.875), 2000, 100);
            thread CreateGrids((-1700, -4317, -160),(-1780, -4655, -160), (0,0,0));
            //Turret
            thread spawncrate((-1441, -2866, 10), (90, -96.87622, 0), "com_plasticcase_trap_friendly");
            thread createTurret((-1441, -2866, 45), (0,-96.87622,0), 25, 25, undefined, 10);
            //player cannons
            thread cannonball((-1545, -2650, -100), (0,90,0), (-620,0,870), 1, (-1552, -3796, 295), 300);
            thread cannonball((-1471, -2650, -100), (0,90,0), (-620,0,870), 1, (-1552, -4305, 295), 300);
            thread cannonball((-1400, -2650, -100), (0,90,0), (-620,0,870), 1, (-1551, -4835, 295), 300);
            //El Doorado
            thread CreateDoors((-1312, -4752, -150) /*open*/, (-1312, -4752, -230) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, true /*sideways*/);
            //TPs            
            thread createTP((132.893,-57.1034,-243.921), (-2235, -4557, -258.647), (0, 0, 0));
            thread createTP((-888.628,-676.319,-192.073), (-2235, -4557, -258.647), (0, 0, 0));
            thread createTP((2206.97,560.653,-290.207), (-2235, -4557, -258.647), (0, 0, 0));
            thread createTP((1458.78,-1071.89,-168.131), (-2235, -4557, -258.647), (0, 0, 0));
            thread createTP((987.398,2618.55,-263.284), (-2235, -4557, -258.647), (0, 0, 0));
            thread createTP((-702.325,1482.61,-257.749), (-2235, -4557, -258.647), (0, 0, 0));
            thread createHiddenTP((-1972, -2395, -112.897), (1184, 720, -126.649), (0, 0, 0), "out");
            //AC130 pos
            thread moveac130position((-1586, -4186, -246.875));
            }
            else if(rnd == 1)
            {

            level.meat_playable_bounds =
            [
                (2864.33, 1425.65, -209.659),
                (3024.51, 1652.24, -227.132),
                (3191.99, 1780.99, -227.784),
                (3531.29, 1927, -216.43),
                (4711.3, 2327.84, -192.875),
                (4706.6, -387.064, -192.875),
                (3662.82, -385.347, -186.928),
                (3156.71, 811.257, -153.779),
                (3145, 1212.25, -217.654)
            ];

            thread createPolygon();

            thread CreateWalls((4255,2195,-220), (4720,2340,-220));
            thread spawncrate((4280,2150,-240), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4280,2150,-200), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4280,2150,-160), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4265,2195,-160), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4365,1840,-240), (0,20,0), "com_plasticcase_friendly");
            thread spawncrate((4365,1840,-200), (0,20,0), "com_plasticcase_friendly");
            thread spawncrate((4365,1840,-160), (0,20,0), "com_plasticcase_friendly");
            thread spawncrate((4380,1790,-240), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4380,1790,-200), (0,110,0), "com_plasticcase_friendly");
            thread spawncrate((4380,1790,-160), (0,110,0), "com_plasticcase_friendly");
            thread CreateDoors((4230,1975,-120) /*open*/, (4230,1975,-240) /*close*/, (90,20,0) /*angle*/, 6 /*size*/, 2 /*height*/, 30 /*hp*/, 180 /*range*/, true /*sideways*/);
            thread CreateWalls((4720,2340,-220), (4720,-400,-220));
            thread CreateWalls((4720,2340,-280), (4720,2000,-280));
            thread CreateWalls((4720,-400,-220), (3660,-400,-220));
            thread CreateWalls((4460,-400,-280), (3660,-400,-280));
            //thread CreateQuicksteps((3940,680,-100), 200, 20, 20, (0,-90,45));
            thread CreateQuicksteps((3647, 1535, -205), 110, 17, 2, (0,-130,0));
            thread moveac130position((2485, -85, -250));
            //thread CreateQuicksteps((3940,680,-91), 200, 15, 2, (0,-70,0));
            //thread CreateElevator(corner1, corner2, height, time)
            thread fufalldamage((4100, 0, -225), 200, 100);
            thread CreateElevator((4150,-40,-280),(4050,40,-280), 189, 2);
            //thread CreateGrids((4150,-40,-280),(4050,40,-280),(0,0,0)); //////
            thread CreateGrids((4120,80,-91),(4080,680,-91),(0,0,0));
            thread CreateGrids((3810,1200,-91),(3500,1020,-91),(0,0,0));
            thread CreateWalls((3470,1200,-73), (3470,1020,-73));
            thread CreateWalls((3785, 799, -290), (3785, 799, -100), (0,0,-90));
            //thread CreateDoors((4630,670,-200) /*open*/, (4470,670,-200) /*close*/, (90,90,0) /*angle*/, 5 /*size*/, 1 /*height*/, 50 /*hp*/, 120 /*range*/);
            thread CreateDoors((4470,670,-240) /*open*/, (4630,670,-240) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 120 /*range*/, true /*sideways*/);
            //TPs
            thread createTP((132.893,-57.1034,-243.921), (3151, 1286, -323.427), (0, 50, 0));
            thread createTP((-888.628,-676.319,-192.073), (3151, 1286, -323.427), (0, 50, 0));
            thread createTP((2206.97,560.653,-290.207), (3046, 1396, -319.954), (0, 30, 0));
            thread createTP((1458.78,-1071.89,-168.131), (2952, 1484, -310.613), (0, 15, 0));
            thread createTP((987.398,2618.55,-263.284), (2952, 1484, -310.613), (0, 15, 0));
            thread createTP((-702.325,1482.61,-257.749), (3046, 1396, -319.954), (0, 30, 0));
            thread createHiddenTP((4115, 1090, -79.875), (795, 1680, -50.875), (0, 180, 0), "out");
            }


            break;
        case "mp_hardhat":
            
            rnd = randomint(2);
            if(rnd == 0)
            {
                level.meat_playable_bounds = [
                    (2038.88, 1469.27, 700.754),
                    (2091.33, 2376.46, 721.977),
                    (2090.2, 3195.8, 703.031),
                    (2396.15, 3580.7, 512.125),
                    (2400.63, 4063.12, 512.125),
                    (-2025.11, 4064.89, 448.125),
                    (-2020.51, 1739.14, 573.599),
                    (-578.852, 1736, 742.125),
                    (-576.939, 1341.15, 742.125),
                    (-226.698, 1341.77, 664.448),
                    (1061.85, 1453.49, 661.146)
                ];

                thread createPolygon();

                thread CreateWalls((-1830, 1950, 200),(-1920, 1950, 350));
                thread CreateWalls((-1820, 1740, 200),(-1820, 1920, 350));

                thread CreateWalls((-2000, 3840, 40),(-1830, 3840, 160));
                thread CreateWalls((-1700, 4040, 40),(-1700, 3720, 160));

                thread CreateWalls((-1390, 2480, 30),(-1390, 2670, 150));
                
                thread CreateRamps((-900, 3900, 20),(-600, 3900, 140));

                thread CreateWalls((303, 3230, 30),(303, 3080, 170));
                thread CreateWalls((303, 2850, 30),(303, 2710, 170));

                thread CreateDoors((303, 2780, 60) /*open*/, (303, 2970, 60) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 120 /*range*/, true /*sideways*/);

                

                thread CreateWalls((1280, 4079, 410),(1650, 4079, 410));
                thread CreateWalls((1280, 4079, 480),(1650, 4079, 480));

                thread CreateWalls((2000, 3550, 530),(1870, 3550, 530));
                thread CreateWalls((2000, 3550, 600),(1870, 3550, 600));


                thread CreateWalls((2047, 1500, 370),(2047, 1500, 700), (0,90,90));
                thread CreateWalls((2103, 2410, 370),(2103, 2410, 700), (0,90,90));
                thread CreateWalls((2103, 3170, 370),(2103, 3170, 700), (0,90,90));

                thread CreateGrids((460, 2380, 177),(160, 2480, 177), (0,0,0));
                thread CreateRamps((165, 2350, 180),(165, 2090, 290));
                thread CreateGrids((165, 2065, 305),(165, 1740, 305), (0,0,0));

                thread CreateQuicksteps((165, 1713, 625), 320, 18, 2, (0,90,0));

                thread CreateInvisWalls((-590, 1335, 665),(-590, 1760, 665));
                thread CreateInvisWalls((-390, 1329, 665),(-595, 1329, 665));

                thread CreateInvisWalls((-590, 1335, 715),(-590, 1760, 715));
                thread CreateInvisWalls((-390, 1329, 715),(-595, 1329, 715));

                thread spawncrate((239, 1440, 680), (90, 0, 0));

                thread moveac130position((-556, 3054, 2000.125));

                thread fufalldamage((188, 1946, 320.125), 250, 100);

                thread createHiddenTP((-539, 1379, 640.125), (-295, -1006, 386.125), undefined, "out");
                thread createTP((-50.5413,815.739,376.125), (-1952, 3956, 32.125));
                thread createTP((1842.59,523.412,184.125), (-1936, 1821, 224.125));
                thread createTP((-1051.08,-472.688,182.643), (-1952, 3956, 32.125));
                thread createTP((2185.11,-814.549,305.125), (-1936, 1821, 224.125));
                thread createTP((997.322,940.85,371.881), (-1952, 3956, 32.125));
                thread createTP((1373.88,-1257.92,304.191), (-1936, 1821, 224.125));

                level.lowspawnoverwriteheight = -100;
            }
            else if(rnd == 1)
            {
                level.meat_playable_bounds = [
                    (-118.023, -3075.33, 507.581),
                    (612.361, -2527.87, 438.92),
                    (612.088, -1782.75, 578.877),
                    (-1167.15, -291.466, 721.038),
                    (-3293.64, -289.755, 797.203),
                    (-3283.05, -3052.75, 665.954),
                    (-1024.68, -3046.49, 438.606)
                ];
                
                thread createPolygon();

                thread CreateRamps((-2550,-1960,512), (-3030,-1960,772));

                thread CreateWalls((-140, -3087, 380),(-140, -3087, 490));

                thread spawncrate((-240, -2515, 415), (90, -90, 0), "com_plasticcase_friendly");
                thread spawncrate((-240, -2515, 465), (90, -90, 0), "com_plasticcase_friendly");

                thread CreateWalls((625, -2510, 420),(625, -1790, 420));

                thread CreateWalls((-1150, -2380, 390),(-1150, -2560, 470));

                thread CreateWalls((-590, -1960, 390),(-590, -1800, 470));

                thread CreateWalls((-1040, -3060, 410),(-1600, -3060, 410));
                thread CreateWalls((-2020, -3060, 540),(-2810, -3060, 540));

                thread CreateWalls((-3290, -2540, 540),(-3290, -2090, 540));

                thread CreateWalls((-1500, -270, 760),(-2050, -270, 760));
                thread CreateWalls((-2060, -270, 540),(-3040, -270, 540));
                thread CreateWalls((-1520, -270, 570),(-1170, -270, 570));

                thread CreateRamps((-1565, -755, 510),(-1565, -470, 630));

                thread CreateGrids((-1130, -1600, 476),(-1280, -1480, 476), (0,0,-30));
                thread CreateGrids((-1130, -1630, 489),(-1280, -1760, 489), (0,0,0));

                thread createTurret((-2059, -2238, 550), (0,0,0), 25, 40, undefined, 10);

                thread createHiddenTP((-3156, -340, 800.125), (603.197,-27.7726,288.125), undefined, "out");
                thread createHiddenTP((-1273, -325, 545.78), (603.197,-27.7726,288.125), undefined, "out");
                thread createTP((-50.5413,815.739,376.125), (-195.159,-3031.52,384.125), (0,90,0));
                thread createTP((1842.59,523.412,184.125), (-190.698,-2994.41,384.125), (0,90,0));
                thread createTP((-1051.08,-472.688,182.643), (-190.426,-3002.27,384.125), (0,90,0));
                thread createTP((2185.11,-814.549,305.125), (-196.08,-3002.68,384.125), (0,90,0));
                thread createTP((997.322,940.85,371.881), (-197.317,-2993.48,384.125), (0,90,0));
                thread createTP((1373.88,-1257.92,304.191), (-191.11,-2995.71,384.125), (0,90,0));

            }

            break;
        case "mp_mogadishu":
            
            rnd = randomint(3);
            //rnd = 1;
            if(rnd == 0)
            {
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

                thread createPolygon();

                thread CreateWalls((-2880, -120, -30),(-2280, -120, 20));
                thread spawncrate((-2900, -153, -10),(90,0,0));
                thread CreateWalls((-2900, -130, 20),(-2900, -500, 20));

                thread CreateWalls((-2500, -410, -40),(-2500, -510, 35));

                thread CreateGrids((-1565, -490, -38),(-1565, -660, -38), (45,90,0));
                
                thread CreateQuicksteps((-1597, -765, 228), 240, 15, 2, (0,0,0));
                thread CreateQuicksteps((-1597, -825, 228), 240, 15, 2, (0,0,0));

                thread CreateGrids((-1750, -125, 220),(-1680, -455, 220), (0,0,0));

                thread CreateWalls((-1870, -100, 280),(-1870, 280, 200));
                thread CreateWalls((-1870, -100, 280),(-2070, -100, 200));
                thread CreateWalls((-1870, 300, 280),(-1220, 300, 200));
                thread CreateWalls((-1220, 300, 280),(-1220, 760, 200));

                thread CreateGrids((-1240, 1610, 209),(-1240, 1940, 209), (0,0,0));
                thread CreateWalls((-1100, 1955, 300),(-1220, 1955, 220));

                thread spawncrate((-1260, 1925, 250),(90,0,0), "com_plasticcase_friendly");
                thread spawncrate((-1260, 1925, 300),(90,0,0), "com_plasticcase_friendly");
                thread spawncrate((-1260, 1925, 350),(90,0,0), "com_plasticcase_friendly");

                thread CreateInvisWalls((-1031, -700, 0),(-1031, -840, 110));

                thread CreateWalls((-1695, -125, -35),(-1695, -250, 30));
                thread CreateWalls((-1695, -420, -35),(-1695, -460, 30));

                thread CreateDoors((-1695, -335, 70) /*open*/, (-1695, -335, 0) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 1 /*height*/, 25 /*hp*/, 95 /*range*/);
                
                thread CreateWalls((-1170, 1355, 220),(-970, 1355, 268));
                thread createTurret((-1070, 1355, 278), (0,-90,0));

                thread createTP((311.467,-934.079,-42.8023), (-2758.52,-345.167,-39.876), undefined);
                thread createTP((-13.0837,2583.99,87.9326), (-2770.19,-300.245,-39.8806), undefined);
                thread createTP((430.104,809.773,-60.8435), (-2783.4,-258.911,-39.8774), undefined);
                thread createTP((1260.16,1963.78,4.45646), (-2813.56,-290.12,-39.875), undefined);
                thread createTP((1629.24,185.788,-57.4053), (-2821.61,-225.312,-39.8948), undefined);
                thread createHiddenTP((-847.125,1900.88,224.125), (-418.459,1845.59,70.125), undefined, "out");
            }
            else if(rnd == 1)
            {  
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

                thread createPolygon();

                thread CreateQuicksteps((2260, 700, 65), 120, 15, 2, (0,90,0));
                thread CreateQuicksteps((2340, 220, 113), 45, 15, 2, (0,-90,0));

                thread CreateGrids((2260, 690, 65),(2260, 240, 65), (0,0,0));
                thread CreateGrids((2260, 210, 65),(3160, 160, 65), (0,0,0));
				
				thread CreateGrids((1986.6, -1211.9, 30),(1967.4, -1205, 30), (0,341,0));
				
			    thread CreateRamps((3154, 134, 99),(3060, 134, 70));
				
				thread CreateWalls((2500, 122, 90),(2553, 122, 170), (0,90,0));
				
                thread CreateGrids((2690, 225, 149),(2635, 280, 149), (0,0,0));
                thread CreateGrids((3040, 210, 149),(3140, 260, 149), (0,0,0));
                thread CreateRamps((3205, 55, 102),(3205, -340, -55));
                thread spawncrate((3205, 150, 113), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((3205, 120, 113), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((3205, 90, 113), (0, 0, 0), "com_plasticcase_friendly");

                thread CreateInvisWalls((2080, 0, 130),(2390, 0, 130));
                thread CreateInvisWalls((2080, 0, 190),(2390, 0, 190));

                thread CreateQuicksteps((2400, -1300, 71), 135, 15, 2, (0,90,0));

                thread CreateGrids((2047, -1555, 210),(2197, -1555, 210), (30,-90,90));
                thread CreateGrids((2047, -1555, 280),(2197, -1555, 280), (30,-90,90));

                thread createDeathRegion((1990, 0, -60), (4825, 720, 80));

                thread createTP((2600, 1468, -26.7422), (2388, 1307, -29.5731), undefined);
                thread createTP((-646, 3168, 92.125), (2388, 1307, -29.5731), undefined);
                thread createTP((-898, 632, 96.125), (2388, 1307, -29.5731), undefined);
                thread createTP((262, 1171, -48.7845), (2388, 1307, -29.5731), undefined);
                thread createTP((915, -54, -47.875), (2388, 1307, -29.5731), undefined);

                thread createHiddenTP((2533, -1660, 97.2698), (-487, -55, 96.125), undefined, "out");
            }
            else if(rnd == 2)
            {  
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

                thread createPolygon();
				
				//floors
				thread CreateGrids((-658, 4817, 250),(325, 4711, 250), (0,0,0));
				thread CreateGrids((-658, 4844, 520),(325, 4711, 520), (0,0,0));
				//flagfloor
				thread CreateGrids((160, 4850, 250),(51, 4950, 250), (0,0,0));
				//guard rail
				thread CreateGrids((-652, 4844, 285.125),(28, 4844, 285.125), (0,0,0));
				thread CreateGrids((195, 4844, 285.125),(328, 4844, 285.125), (0,0,0));
			    //turret
				thread spawncrate((-140, 4711, 278.125), (0,0,0), "com_plasticcase_friendly");
				thread createTurret((-140, 4711, 298.135), (0,270,0), 60, 60, undefined, 10);
				//cover
				thread CreateWalls((43, 4723, 265.125), (43, 4723, 370.125), (0,90,0));
				thread CreateWalls((87, 4711, 265.125), (87, 4711, 370.125), (0,0,0));
				thread CreateGrids((-29, 4796, 380.25),(188, 4691, 380.25), (0,0,0));
				thread CreateGrids((188, 4691, 355.375),(-29, 4691, 355.375), (0,0,0));
				thread CreateWalls((-82, 3610, 348.125), (-82, 3610, 448.125), (0,90,0));
				thread CreateWalls((-194, 3610, 348.125), (-194, 3610, 448.125), (0,90,0));
				thread CreateQuicksteps((413, 3576, 508.125), 185, 18, 2, (0,180,0));
				thread CreateQuicksteps((-685, 3576, 528.125), 199, 18, 2, (0,0,0));
				thread CreateQuicksteps((-620, 4679, 250), 180, 18, 2, (0,270,0));
				thread CreateQuicksteps((-520, 4679, 250), 180, 18, 2, (0,270,0));
				thread CreateDoors((-381, 4896, 285.125) /*open*/, (-381, 4777, 285.125) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 100 /*range*/, true /*sideways*/);
				thread CreateGrids((-1107, 3855, 525),(-1107, 4084, 525), (0,0,0));
				thread createTP((746, 3001, 86), (-643, 3683, 90), (0, 70, 0));
				thread createTP((262, 1171, -48.7845), (374, 3683, 100), (0, 120, 0));
				thread createTP((849, -289, -47.875), (374, 3683, 100), (0, 120, 0));
			    thread createTP((-615, -158, -40.125), (374, 3683, 100), (0, 120, 0));
                thread createTP((2232, 1675, -26.7422), (-643, 3683, 90), (0, 70, 0));
                thread createTP((-646, 3168, 92.125), (-643,3683, 90), (0, 70, 0));
				thread createTP((103, 4970, 266.125), (-139, 3615, 355), (0, 270, 0));
                thread CreateWalls((-1749, 4140, 574.125), (-1894, 3394, 574.125));
				thread CreateWalls((340, 4879, 576.125), (770, 4879, 576.125));
				thread CreateWalls((340, 4910, 576.125), (340, 5039, 576.125));
				//tp spawn protection
                thread CreateGrids((-610, 3756, 180),(-474, 3608, 180), (0,0,0));
				thread CreateGrids((194, 3756, 200),(330, 3608, 200), (0,0,0));
				thread CreateWalls((-466, 3756, 143.125), (-520, 3756, 60.125), (0,0,0));
				//spawn camp block
				thread spawncrate((319, 3622, 130), (0, 0, 0));
				thread spawncrate((290, 3622, 130), (0, 0, 0));
				thread spawncrate((225, 3622, 130), (0, 0, 0));
				thread createDeathRegion((360, 3590, 90), (183, 3547, 170));
				thread createDeathRegion((1992.81, 2329, 20), (2243, 2654.7, 130));
                thread moveac130position((-342, 4272, 2000.125));
                thread createHiddenTP((-163, 4889, 540.2698), (1038, 3706, 229.125), (0, 260, 0), "out");

            }

            break;

        case "mp_bravo":
            rnd = randomint(2);
            if(rnd == 0)
            {
                level.meat_playable_bounds = [
                    (-5649, -6733.89, 1644.63),
                    (-5413.08, -6501.37, 1644.63),
                    (-5412.53, -5204.05, 1644.63),
                    (-7399.95, -3216.82, 1644.63),
                    (-8280.3, -4100.26, 1644.63)
                ];

                thread createPolygon();

                thread CreateWalls((-5650, -6750, 1590),(-8300, -4100, 1645));// |
                thread CreateWalls((-8300, -4100, 1590),(-7400, -3200, 1645));// --
                thread CreateWalls((-7400, -3200, 1590),(-5400, -5200, 1645));// |

                thread CreateWalls((-5400, -5200, 1590),(-5400, -6500, 1645));// /
                thread CreateWalls((-5600, -6300, 1590),(-5600, -5400, 1645));// /
                thread CreateWalls((-5600, -5400, 1590),(-5700, -5300, 1645));// |

                thread CreateWalls((-5600, -6300, 1590),(-5850, -6550, 1645));// -
                thread CreateWalls((-5400, -6500, 1590),(-5650, -6750, 1645));// -

                thread CreateWalls((-6200, -5200, 1590),(-6300, -5300, 1645));// Safety wall
                thread CreateWalls((-6700, -4300, 1590),(-6800, -4400, 1645));// Safety wall
                thread CreateWalls((-7000, -5000, 1590),(-7100, -5100, 1645));// Safety wall
                

                thread CreateDoors((-5500, -6200, 1680) /*open*/, (-5500, -6200, 1600) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 110 /*range*/, true /*sideways*/);
                thread CreateDoors((-5600, -5200, 1680) /*open*/, (-5600, -5200, 1600) /*close*/, (90,-45,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 110 /*range*/, true /*sideways*/);

                
                thread createHiddenTP((-8237, -4109, 1584.13), (-1824.22,760.875,1096.93), undefined, "out");
                thread createTP((-1280.39,204.439,922.347), (-5717, -6533, 1584.13));
                thread createTP((1392.46,-357.538,1166.76), (-5717, -6533, 1584.13));
                thread createTP((-163.464,-626.369,972.125), (-5639, -6605, 1584.13));
                thread createTP((-625.984,1088.97,1215.45), (-5639, -6605, 1584.13));
                thread createTP((974.315,1058.86,1167.13), (-5639, -6605, 1584.13));

                thread moveac130position((-5582, -4890, 1584.13));
            }
            else if(rnd == 1)
            {
                level.meat_playable_bounds = [
                    (2131.55, 384.448, 1459.62),
                    (2127, 992, 1387.13),
                    (2457.8, 983.351, 1719.8),
                    (2445.1, 1739.31, 1685.13),
                    (2419.43, 1737.82, 1688.32),
                    (2414.84, 2349.74, 1722.13),
                    (2195.44, 2348.71, 1722.13),
                    (2195.61, 1929.27, 1722.13),
                    (1379.32, 1920.4, 1279.63),
                    (1378.73, 1321.93, 1279.63),
                    (1673.27, 385.788, 1384.98)
                ];

                thread createPolygon();

                thread CreateGrids((1615, 1025, 1340),(1800, 830, 1340), (0,0,0));
                thread CreateWalls((1590, 1020, 1365),(1590, 670, 1310));

                thread CreateWalls((2148, 433, 1300),(2149, 969, 1300));
                thread CreateWalls((2149, 969, 1300),(2286, 972, 1300));

                thread CreateWalls((2148, 433, 1360),(2149, 969, 1360));
                thread CreateWalls((2149, 969, 1360),(2286, 972, 1360));

                thread CreateWalls((2440, 1350, 1264),(2440, 1350, 1357),(0,90,90));
                thread CreateWalls((1360, 1340, 1170),(1360, 1930, 1280));
                thread CreateWalls((1360, 1940, 1170),(2190, 1940, 1280));
                thread CreateWalls((1980, 1940, 1280),(2190, 1940, 1370));
                thread CreateWalls((2400, 1770, 1260),(2400, 1770, 1430),(0,90,90));

                thread CreateGrids((2195, 1475, 1255),(2195, 1915, 1255), (0,0,0));
                thread CreateGrids((2245, 1765, 1255),(2360, 1765, 1255), (0,0,0));

                thread CreateQuicksteps((2155, 1670, 1271), 100, 15, 2, (0,180,0));
                thread CreateRamps((2130, 1500, 1270),(1785, 1500, 1460));
                thread CreateRamps((1700, 1690, 1500),(2205, 1690, 1660));

                thread CreateGrids((2250, 1775, 1690),(2400, 1775, 1690), (0,0,30));
                thread CreateGrids((2180, 1810, 1708),(1820, 1840, 1708), (0,0,0));

                thread CreateWalls((1855, 1115, 1210),(1855, 1115, 1355),(0,0,90));
                thread CreateWalls((2100, 1115, 1210),(2100, 1115, 1355),(0,0,90));

                thread CreateWalls((2085, 1160, 1210),(2085, 1160, 1355),(0,90,90));
                thread CreateWalls((1868, 1160, 1210),(1868, 1160, 1355),(0,90,90));

                thread CreateDoors((1770, 1150, 1250) /*open*/, (1975, 1150, 1250) /*close*/, (60,-90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 110 /*range*/, true /*sideways*/);

                thread createHiddenTP((2300, 2274, 1722.13), (-55, -335, 1220.13), undefined, "out");
                thread createTP((-1280.39,204.439,922.347), (1665, 937, 1212.18));
                thread createTP((1392.46,-357.538,1166.76), (1665, 937, 1212.18));
                thread createTP((-163.464,-626.369,972.125), (1665, 937, 1212.18));
                thread createTP((-625.984,1088.97,1215.45), (1665, 937, 1212.18));
                thread createTP((974.315,1058.86,1167.13), (1665, 937, 1212.18));
            }

        break;
        case "mp_favela":
            rnd = randomint(3);
            if(rnd == 0)
            {
                thread CreateGrids((9765, 18545, 12628.5),(9765, 18185, 12628.5), (0,90,0));

                thread CreateGrids((9780, 18508, 12770),(9830, 18375, 12770), (0,0,0));

                thread CreateQuicksteps((9760, 18310, 12930), 300, 18, 2, (0,0,0));
                thread CreateGrids((9675, 18290, 12930),(9675, 18680, 12930), (0,0,0));
                thread CreateGrids((9735, 18290, 12930),(9735, 18680, 12930), (0,0,0));
                thread CreateRamps((10050, 18650, 13100),(9780, 18650, 12930));
                thread CreateGrids((10080, 18540, 13113),(10130, 18680, 13113), (0,0,0));
                thread CreateRamps((10050, 18570, 13100),(9780, 18570, 13270));
                thread CreateGrids((9740, 18610, 13283),(9690, 18280, 13283), (0,0,0));
                thread CreateDoors((9765, 18420, 13350) /*open*/, (9765, 18565, 13350) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 1 /*height*/, 20 /*hp*/, 100 /*range*/);
                
                thread CreateQuicksteps((9830, 18290, 13615), 340, 18, 2, (0,180,0));
                thread CreateGrids((9850, 18330, 13615),(9990, 18260, 13615), (0,0,0));

                thread CreateGrids((10535, 18660, 13620),(10590, 18150, 13620), (0,0,0));

                thread CreateGrids((9420, 18205, 13602),(9475, 18684, 13602), (0,0,0));

                thread createTP((923, 2546, 240.625), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createTP((1010, 10, 198.939), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createTP((1199, -1201, 187.083), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createTP((-438, 377, 0.125), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createTP((-1603, 855, 8.0225), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createTP((-754, 1356, 92.4042), (9799, 18422, 12643.1), (0, 90, 0), true);
                thread createHiddenTP((9345, 18435, 13635),(-778, 2947, 410), undefined , "out");

                thread CreateDoors((9900, 18600, 13000) /*open*/, (9700, 18375, 12970) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 100 /*range*/, true /*sideways*/);

                thread createDeathRegion((14000,13500,11000), (6000,22500,0));
                thread moveac130position((9938, 18427, 12636.6));

                thread spawncrate((-590, 396, 275), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-16, 406, 300), (0, 90, 0), "com_plasticcase_friendly");

                thread spawncrate((-425, 1053, 370), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-425, 1053, 315), (0, 90, 0), "com_plasticcase_friendly");
            }
            else if(rnd == 1)
            {
                thread CreateGrids((-250, 1852, 360),(-250, 1445, 360), (0,0,0));
                thread CreateGrids((-210, 1490, 360),(-90, 1420, 360), (0,0,0));
            
                thread CreateRamps((-115, 1420, 355),(-115, 995, 430));
                thread CreateGrids((-115, 970, 440),(437, 940, 440), (0,0,0));
                
                thread CreateRamps((420, 995, 440),(420, 1410, 570));
                thread spawncrate((475, 1405, 557), (0, 45, 0), "com_plasticcase_friendly");
                thread CreateWalls((675, 1410, 570),(675, 1850, 640));
                thread CreateWalls((300, 1850, 570),(300, 1772, 640));
                thread CreateWalls((655, 1850, 570),(320, 1850, 640));

                thread spawncrate((-200, 1525, 334), (45, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-155, 1525, 325), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-110, 1525, 334), (-45, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-76, 1515, 360), (0, -90, 0), "com_plasticcase_friendly");

                thread spawncrate((-315, 1563, 360), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-315, 1533, 360), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-315, 1500, 340), (0, 0, 45), "com_plasticcase_friendly");
                thread spawncrate((-315, 1480, 320), (0, 0, 45), "com_plasticcase_friendly");
                thread spawncrate((-315, 1440, 300), (0, 0, 0), "com_plasticcase_friendly");
                
                thread spawncrate((-170, 1400, 360), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-170, 1350, 360), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-170, 1300, 360), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-170, 1250, 360), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-170, 1200, 360), (0, 90, 0), "com_plasticcase_friendly");

                thread spawncrate((-160, 1140, 400), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-160, 1090, 400), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-160, 1040, 400), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-160, 990, 400), (0, 90, 0), "com_plasticcase_friendly");

                thread spawncrate((245, 1010, 440), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((300, 1010, 440), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((355, 1010, 440), (0, 0, 0), "com_plasticcase_friendly");

                thread spawncrate((-482, 1950, 313), (0, -90, 45), "com_plasticcase_friendly");

                thread CreateDoors((-130, 1325, 500) /*open*/, (-130, 1325, 420) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 1 /*height*/, 30 /*hp*/, 85 /*range*/);

            }
            else if(rnd == 2)
            {
            
                level.meat_playable_bounds = [
                    (980, 2456, 446.063),
                    (1358, 2458, 376.328),
                    (1646, 3209, 746.825),
                    (1962, 3100, 746.825),
                    (3059, 3139, 464.125),
                    (3062, 3042, 464.125),
                    (2743, 2841, 432.125),
                    (2053, 2536, 432.125),
                    (2165, 1989, 680.125),
                    (2367, 1125, 680.125),
                    (2253, 1009, 632.125),
                    (2249, 123, 632.125),
                    (2116, 90, 728.125),
                    (2042, -1027, 728.125),
                    (2120, -1659, 728.125),
                    (1708, -1704, 758.282),
                    (1573, -1075, 728.125),
                    (1549, -827, 728.125),
                    (1645, 133, 728.125),
                    (1848, 176, 632.125),
                    (1798, 758, 632.125),
                    (1799, 1005, 630.001),
                    (1970, 1036, 680.125),
                    (1711, 1883, 679.615),
                    (1664, 2313, 432.125),
                    (1363, 2173, 448.062),
                    (969, 2175, 470.453)
                ];

                thread createPolygon();

                thread createTP((923, 2546, 240.625), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((1010, 10, 198.939), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((1199, -1201, 187.083), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((-438, 377, 0.125), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((-1603, 855, 8.0225), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((-754, 1356, 92.4042), (1123, 2402, 281.601), (0, 0, 0), true);
                thread createTP((3015, 3102, 280.125), (1685, 3130, 686.183), (0, -70, 0), true);
                thread createHiddenTP((1757, -1645, 728.125),(-177, -753, 431.167), undefined , "out");
                //End of road wall 3-stack
                thread CreateWalls((2753, 2864, 290),(3040, 3043, 290));
                thread CreateWalls((2753, 2864, 360),(3040, 3043, 360));
                thread CreateWalls((1000, 2453, 400),(1340, 2454, 400));
                //El Ents
                ent = spawn("script_model", (1735, 2312, 330));
                ent.angles = (0, 100, 0);
                ent setmodel("foliage_tree_oak_1");
                //Ramp from 1st building
                thread CreateRamps((2131, 1963, 662),(1823, 2767, 668));
                //Quicksteps
                thread CreateQuicksteps((2003, 1388, 665), 130, 18, 2, (0,-256,0));
                thread CreateQuicksteps((1957, 459, 620), 130, 18, 2, (0,-269,0));
                thread CreateQuicksteps((1893, 111, 715), 100, 18, 2, (0,-275,0));
                thread CreateQuicksteps((1781, -432, 715), 130, 18, 2, (0,-275,0));
                thread CreateQuicksteps((1787, -1351, 715), 130, 18, 2, (0,-262,0));
                //Ramps
                thread CreateRamps((2129, 1734, 662),(2201, 1420, 662));
                thread CreateRamps((2118, 769, 614),(2119, 448, 614));
                thread CreateRamps((1966, -138, 710),(1938, -458, 710));
                thread CreateRamps((1907, -1025, 710),(1947, -1344, 710));
                //1st Roof wall
                thread CreateWalls((1656, 3205, 720),(1541, 2860, 720));
                thread CreateWalls((1684, 3194, 720),(1943, 3101, 720));
                //Death Barriers
                thread createDeathRegion((1487, 680, 100.125), (2972, -2380, 490));
                thread createDeathRegion((2380, 2616, 100), (3894, -2645, 1005));
                thread createDeathRegion((1549, 2257, 100), (2363, 1247, 490));
                thread createDeathRegion((2874, 4440, 350), (991, 2483, 490));
                thread createDeathRegion((969, 2972, 354.856), (-165, 4397, 1066.66));
                thread createDeathRegion((864, 3445, 534.097), (3307, 5253, 1719.86));
        	}
        	break;
        case "mp_interchange":
            rnd = randomint(2);
            if(rnd == 0) {
	            thread CreateWalls((-4635, 2592, 920),(-5094, 2109, 1000));
	            thread CreateWalls((-7678, 5299, 920),(-8108, 4817, 1000));
	            thread CreateInvisWalls((-5130, 2115, 970),(-8124, 4792, 970));
	            thread CreateInvisWalls((-7652, 5317, 970),(-4643, 2627, 970));
	            thread CreateWalls((-9073, 3513, 1440),(-10002, 5118, 1520));
	            thread CreateElevator((-9870, 5150, 1245),(-8100, 5150, 1245), 150, 2, (0,-60,0));
	            thread CreateWalls((-9396, 4733, 1180),(-9103, 4225, 1280));
	            thread createDeathRegion((-11397, 6261, 400), (-8227, 2599, 1150));
	            thread createTP((1765.05,-1472.41,82.125), (-5043.07,2378.81,915.625));
	            thread createTP((1207.71,-3008.1,113.377), (-5043.07,2378.81,915.625));
	            thread createTP((-689.772,511.373,-8.875), (-5043.07,2378.81,915.625));
	            thread createTP((1478.27,-164.083,131.108), (-5043.07,2378.81,915.625));
	            thread createTP((1222.88,1316.79,73.66), (-5043.07,2378.81,915.625));
	            thread createHiddenTP((-8089.4,4806.79,915.625), (-9194, 4514, 1161.13));
	            thread createHiddenTP((-9033, 3571, 1411.44), (644.666,-547.974,82.5098), undefined, "out");
            }
            else if(rnd == 1) {
             	thread createTP((1765.05,-1472.41,82.125), (-10034.1, 3118.57, 702.125));
	             thread createTP((1207.71,-3008.1,113.377), (-10034.1, 3118.57, 702.125));
	             thread createTP((-689.772,511.373,-8.875), (-10034.1, 3118.57, 702.125));
	             thread createTP((1478.27,-164.083,131.108), (-10034.1, 3118.57, 702.125));
	             thread createTP((1222.88,1316.79,73.66), (-10034.1, 3118.57, 702.125));
	
	             thread createHiddenTP((-11899.9,4113.32,1258.59), (-11818, 3201, 1434.96));
	             thread createHiddenTP((-11921.9,4118.8,1410.13), (131.177,1965.62,-15.9421), undefined, "out");
	
	             level.meat_playable_bounds = [
		             (-9842.5, 3083.34, 807.125),
		             (-10991.8, 2510.78, 775.758),
		             (-11932.4, 2158.81, 1397.97),
		             (-12564.3, 3894.71, 1410.13),
		             (-11608.4, 4226.21, 812.733),
		             (-10757.1, 4654.46, 769.483)
		         ];
	
	             thread createPolygon();
	             thread CreateWalls((-9884, 3062, 720),(-10967, 2524, 720));
	             thread CreateWalls((-9884, 3062, 780),(-10967, 2524, 780));
	             thread CreateWalls((-10218, 3278, 710),(-10073, 3001, 820));
	             thread CreateDoors((-10127, 3333, 800) /*open*/, (-10127, 3333, 720) /*close*/, (90,120,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
	             thread CreateWalls((-10792, 4635, 720),(-11588, 4231, 720));
	             thread CreateWalls((-10792, 4635, 780),(-11588, 4231, 780));
	             thread CreateGrids((-10599, 3329, 912),(-10689, 3137, 912), (0,20,0));
	             thread CreateWalls((-10696, 3285, 930),(-10658, 3181, 1010));
	             thread CreateRamps((-10608, 3351, 897),(-10716, 3642, 700));
	             thread CreateRamps((-10655, 3118, 920),(-11120, 2948, 1130));
            }
            break;
        case "mp_seatown":
            
            rnd = randomint(2);
            if(rnd == 0){
                
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

                thread createPolygon();


                thread CreateWalls((-2270, -2800, 200),(-2270, -2640, 350));
                thread CreateWalls((-1915, -3409, 220),(-1915, -3695, 220));
                thread CreateWalls((-1946, -3695, 220),(-2720, -3695, 220));
                thread CreateWalls((-2720, -3695, 240),(-2720, -3695, 400), (0,180,90));
                thread CreateWalls((-2705, -3695, 400),(-3050, -3695, 480));

                thread CreateWalls((-3050, -3695, 0),(-3050, -3695, 480), (0,180,90));
                thread CreateWalls((-3050, -3695, 0),(-3170, -3695, 0));

                thread CreateQuicksteps((-2970, -2505, 473), 100, 18, 2, (0,-90,0));
                thread CreateQuicksteps((-2920, -2505, 473), 100, 18, 2, (0,-90,0));

                thread CreateGrids((-3000, -2500, 473),(-2330, -2400, 473), (0,0,0));

                thread CreateGrids((-2700, -80, 170),(-3050, -80, 170),(-20,0,90));

                i=0;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2273, -3350, 465) + (0,55 * i,0), (0, 90, 45), "com_plasticcase_friendly"); i++;

                i=0;
                thread spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate((-2265, -2080, 465) + (55 * i, 0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;

                thread CreateWalls((-1560, -2030, 430),(-1560, -1940, 560));
                
                thread createTP((-641.361,-811.601,200.125), (-2156, -2723, 192.125), undefined);
                thread createTP((-2266.06,-170.59,188.125), (-2156, -2723, 192.125), undefined);
                thread createTP((632.221,-797.869,208.125), (-2156, -2723, 192.125), undefined);
                thread createTP((-1226.37,1357.45,248.125), (-2156, -2723, 192.125), undefined);
                thread createTP((37.0393,914.97,91.1074), (-2156, -2723, 192.125), undefined);
                thread createTP((1142.03,831.682,163.515), (-2156, -2723, 192.125), undefined);
                thread createHiddenTP((-2089, -3341, 448.125), (-2096.49,-1771.31,214.598), undefined, "out");

                thread moveac130position((-2321, -1658, 417.316));

            }
            else if(rnd == 1){
                
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

                thread createPolygon();

                thread CreateWalls((3120, 275, 540),(3120, 1135, 620));
                thread CreateWalls((3120, 1135, 540),(2630, 1135, 620));
                thread CreateWalls((3080, 275, 540),(2690, 275, 620));

                thread CreateWalls((2359, -15, 160),(2585, -15, 300));

                thread CreateWalls((2670, 1045, 140),(2670, 1045, 500),(0,0,90));

                thread CreateWalls((2340, 1550, 770),(2340, 1360, 850));
                thread CreateWalls((2340, 1180, 770),(2340, 970, 850));

                thread CreateWalls((1880, 1180, 770),(1880, 970, 850));
                thread CreateWalls((1880, 1550, 770),(1880, 1360, 850));

                thread CreateGrids((1680, 1310, 759),(1680, 1530, 759), (0,0,0));

                thread CreateRamps((1550, 1280, 750),(1550, 570, 560));

                thread spawncrate((1715, 550, 565), (90, 0, 0), "com_plasticcase_trap_friendly");
                thread createTurret((1715, 550, 595), (0,0,0), undefined, undefined, 80, 10);

                thread moveac130position((1036, 166, 228.986));

                thread CreateGrids((1645, 615, 225),(1470, 615, 225), (0,0,0));
                thread spawncrate((1487, 773, 235), (0, 0, 0), "com_plasticcase_friendly");

                i=0;
                p = (2667, 960, 525);
                thread spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (30*i,0,0), (-45, 90, 0), "com_plasticcase_friendly"); i++;

                i=0;
                p = (2800, 1032, 530);
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;
                thread spawncrate(p + (55*i,0,0), (0, 0, 45), "com_plasticcase_friendly"); i++;

                thread CreateDoors((2340, 1270, 870) /*open*/, (2340, 1270, 790) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, true /*sideways*/);
                thread CreateDoors((1880, 1270, 870) /*open*/, (1880, 1270, 790) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 20 /*hp*/, 80 /*range*/, true /*sideways*/);

                thread CreateElevator((2745, 1000, 548),(2650, 1100, 548), 211, 2);
                thread CreateGrids((2650, 1100, 548),(2745, 1000, 548), (0,0,0));

                thread fufalldamage((1595, 708, 564.125),200,100);

                thread createDeathRegion((1435, 1055, 340), (1765, 1590, 170));

                thread createTP((-641.361,-811.601,200.125), (1525.86,707.351,323.926),(0, 0, 0));
                thread createTP((-2266.06,-170.59,188.125), (1534.24,708.667,323.623),(0, 0, 0));
                thread createTP((632.221,-797.869,208.125), (1521.44,707.818,324.088),(0, 0, 0));
                thread createTP((-1226.37,1357.45,248.125), (1547.51,706.641,323.135),(0, 0, 0));
                thread createTP((37.0393,914.97,91.1074), (1522.44,705.014,324.047),(0, 0, 0));
                thread createTP((1142.03,831.682,163.515), (1538.18,705.081,323.472),(0, 0, 0));
                thread createHiddenTP((2688.88,49.8435,180.645), (3062.9,348.911,563.125),(0, 110, 0));
                thread createHiddenTP((1717.28,383.125,564.125), (-2096.49,-1771.31,214.598), (0, 0, 0), "out");
            }

            break;

        case "mp_plaza2":
            rnd = randomint(2);
            	if(rnd == 0) {   
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
	            
	            thread createPolygon();
	
	            //protecting wall
	            thread CreateWalls((-1180, -2030, 745),(-1180, -2140, 825));
	            // small wall at the TP
	            thread CreateWalls((-1065, -2192, 750),(-1065, -2275, 750));
	            thread CreateWalls((-1065, -2192, 800),(-1065, -2275, 800));
	            //long wall left side road block
	            thread CreateWalls((-1980, -2338, 770),(-2673, -2338, 746));
	            //Grid by 1st doors
	            thread CreateGrids((-2000, -1810, 800),(-1900, -2000, 800), (-30,0,0));
	            //death barrier below grid
	            thread createDeathRegion((-2065, -2030, 500), (-663, -1780, 800));
	            //ramp to grid
	            thread CreateRamps((-2077, -1810, 730),(-2077, -1990, 785));
	            //top of grid ramp
	            thread CreateRamps((-1860, -2000, 870),(-1860, -1800, 870));
	            //wall end of ramp
	            thread CreateWalls((-1908, -2009, 850),(-2097, -2009, 770));
	            //wall next to doors
	            thread CreateWalls((-1800, -2260, 750),(-1800, -2300, 830));
	            //doors
	            thread CreateDoors((-1800, -2130, 830) /*open*/, (-1800, -2130, 760) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, true /*sideways*/);
	            // long wall left side end of edit
	            thread CreateWalls((-4112, -1423, 750),(-4721, -1423, 750));
	            //long wall right side end of edit
	            thread CreateWalls((-3216, -636, 770),(-4721, -635, 770));
	            //grid / elevator
	            thread CreateElevator((-4700, -666, 725),(-4700, -1393, 725), 605, 2, (0,0,0));
	            //Soft Landing
	            thread fufalldamage((-4422, -1023, 736.125),650, 100);
	            //walls protecting the player cannons
	            thread CreateWalls((-3744, -1390, 745),(-3744, -1180, 850));
	            thread CreateWalls((-3743, -855, 745),(-3744, -645, 850));
	            //Top of building elevator sight blocker
	            thread CreateWalls((-4700, -633, 1350),(-4860, -633, 1430));
	            //Player cannons
	            thread cannonball((-3667, -750, 720), (0,0,0), (-620,0,870), 3, (-4769, -750, 1420), 300);
	            thread cannonball((-3672, -1300, 720), (0,0,0), (-620,0,870), 3, (-4765, -1320, 1420), 300);
	            //End of edit roof wall
	            thread CreateWalls((-4747, 1011, 1370),(-5494, 1012, 1370));
	            //Roof Pylons
	            thread spawncrate((-5125, -362, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5125, -362, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4987, -121, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4987, -121, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5292, -189, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5292, -189, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5231, 36, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5231, 36, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4986, 177, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4986, 177, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4842, 28, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-4842, 28, 1415),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5411, 137, 1365),(90,90,0), "com_plasticcase_friendly");
	            thread spawncrate((-5411, 137, 1415),(90,90,0), "com_plasticcase_friendly");
	            //Roof turrets
	            thread spawncrate((-5380, 738, 1345), (90, 90, 0), "com_plasticcase_trap_friendly");
	            thread createTurret((-5380, 738, 1380), (0,-90,0), 25, 25, undefined, 10);
	            thread spawncrate((-4860, 738, 1345), (90, 90, 0), "com_plasticcase_trap_friendly");
	            thread createTurret((-4860, 738, 1380), (0,-90,0), 25, 25, undefined, 10);
	            //Turrets Inner Walls
	            thread CreateWalls((-5349, 735, 1380),(-5249, 735, 1380));
	            thread CreateWalls((-5349, 735, 1350),(-5249, 735, 1350));
	            thread CreateWalls((-4893, 736, 1380),(-4993, 736, 1380));
	            thread CreateWalls((-4893, 736, 1350),(-4993, 736, 1350));
	            //Roof Doors
	            thread CreateDoors((-5121, 737, 1440) /*open*/, (-5121, 737, 1360) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
	            //Turret Side Walls
	            thread CreateWalls((-4829, 736, 1380),(-4736, 980, 1380));
	            thread CreateWalls((-5413, 736, 1380),(-5504, 980, 1380));
	            thread CreateWalls((-4829, 736, 1350),(-4736, 980, 1350));
	            thread CreateWalls((-5413, 736, 1350),(-5504, 980, 1350));
	            //Turret Top Blocker
	            thread spawncrate((-5381, 713, 1360),(0,0,0), "com_plasticcase_friendly");
	            thread spawncrate((-4860, 713, 1360),(0,0,0), "com_plasticcase_friendly");
	            thread spawncrate((-5381, 713, 1420),(0,0,0), "com_plasticcase_friendly");
	            thread spawncrate((-4860, 713, 1420),(0,0,0), "com_plasticcase_friendly");
	        
	            thread createTP((-214.597,1207.55,616.125), (-1121, -2086, 736.125), (0, -90, 0), true);    //
	            thread createTP((274.389,-120.492,648.125), (-1121, -2086, 736.125), (0, -90, 0), true);    //
	            thread createTP((-468.558,-1160.7,608.125), (-1121, -2086, 736.125), (0, -90, 0), true);    // TPs out the map
	            thread createTP((-268.693,319.434,801.125), (-1121, -2086, 736.125), (0, -90, 0), true);    //
	            thread createTP((-1464.62,138.581,608.125), (-1121, -2086, 736.125), (0, -90, 0), true);    //
	
	            thread createHiddenTP((-5125, 962, 1338.15), (1126.04,-1715.55,670.125), undefined, "out"); // TP back into the map
	        }
            else if(rnd == 1) {
	            level.meat_playable_bounds = [
	                (3018.95, 93.915, 697.125),
	                (1339.98, 88.2641, 711.375),
	                (1330.08, 2414.41, 735.691),
	                (32.9156, 4531.84, 702.012),
	                (-1069.5, 3325.6, 672.612),
	                (-4132.24, 3237.36, 892.178),
	                (-4143.19, 4732.5, 654.97),
	                (-2051.9, 4835.49, 727.125),
	                (-59.4847, 5897.65, 725.449),
	                (83.7819, 5859.87, 725.449),
	                (1057.34, 4975.4, 765.886),
	                (2606.98, 2391.93, 767.438),
	                (3043.53, 2393.7, 660.489)
	            ];
	
	            thread createPolygon();
	
	            thread CreateWalls((2928, 1330, 790),(2703, 1330, 840));
	            thread CreateInvisWalls((-1019, 5163, 700),(-1253, 5032, 750));
	            thread CreateWalls((2990, 80, 670),(1780, 80, 670));           // long wall at the back near TP
	            thread CreateInvisWalls((1841, 2004, 640),(1944, 1979, 640));  //
	            thread CreateInvisWalls((1944, 1979, 640),(2035, 1928, 640));  // 3 Under car / terrain clip blockers
	            thread CreateInvisWalls((2035, 1928, 640),(2091, 1761, 640));  //
	            thread CreateWalls((1325, 1960, 740),(1325, 1460, 740));       //
	            thread CreateWalls((1325, 1960, 680),(1325, 1460, 680));       // 3 stack wall by car
	            thread CreateWalls((1325, 1960, 620),(1325, 1460, 620));       //
	            thread CreateWalls((2990, 2390, 620),(2600, 2390, 700));       //
	            thread CreateWalls((2600, 2390, 620),(2340, 2820, 700));       // 3 Small walls before bridge
	            thread CreateWalls((1325, 2220, 620),(1325, 2310, 700));       //
	            // 1350 middle
	            thread CreateWalls((730, 3440, 860),(1250, 3440, 720));        // Bridge wall Left
	            thread CreateWalls((1450, 3440, 860),(2000, 3440, 720));       // Bridge wall Right
	            thread spawncrate((695, 3391, 869), (0, 45, 0), "com_plasticcase_friendly");
	            // Bridge doors
	            thread CreateDoors((1350,3440,850) /*open*/, (1350,3440,780) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, true /*sideways*/);
	            thread CreateWalls((1010, 5000, 680),(1140, 4780, 620));
	            thread CreateWalls((1040, 4970, 680),(50, 5870, 620));         // Behind bridge wall 1/2
	            thread CreateWalls((50, 5860, 680),(-52, 5880, 620));          // 2/2
	            thread CreateWalls((-2070, 4820, 640),(-2140, 4820, 720));     // Between buildings wall
	            thread CreateWalls((-4150, 4550, 660),(-4150, 3230, 660));     // Big Wall at the end 1/2
	            thread CreateWalls((-4150, 4550, 710),(-4150, 3230, 710));     // 2/2
	            thread createTP((-214.597,1207.55,616.125), (2914.75,762.342,775.904));    //
	            thread createTP((274.389,-120.492,648.125), (2914.75,762.342,775.904));    //
	            thread createTP((-468.558,-1160.7,608.125), (2914.75,762.342,775.904));    // TPs out the map
	            thread createTP((-268.693,319.434,801.125), (2914.75,762.342,775.904));    //
	            thread createTP((-1464.62,138.581,608.125), (2914.75,762.342,775.904));    //
	            thread createHiddenTP((-4120,3760,634), (1126.04,-1715.55,670.125), undefined, "out"); // TP back into the map
	            //tmg crate oom fix
				thread createDeathRegion((-4354, 4572, 710),(-4061, 4810, 450));
				//tmg wall
				thread CreateWalls((-1667, 4152, 635),(-1652, 3901, 710));
	            thread createDeathRegion((83, 2254, 400), (1720, 5475, 620));
	            thread createDeathRegion((2359, 2848, 400), (-226, 4417, 600));
	        }
	    	break;
        case "mp_alpha":
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

            thread createPolygon();

            h = 950;
            thread CreateWalls((-1499, -870, h),(-1499, -1310, h));
            thread CreateWalls((-1470, -1320, h),(-1250, -1320, h));
            h -= 50;
            thread CreateWalls((-1499, -870, h),(-1499, -1310, h));
            thread CreateWalls((-1470, -1320, h),(-1250, -1320, h));
            h -= 50;
            thread CreateWalls((-1499, -870, h),(-1499, -1310, h));
            thread CreateWalls((-1470, -1320, h),(-1250, -1320, h));
            h -= 50;
            thread CreateWalls((-1499, -870, h),(-1499, -1310, h));
            thread CreateWalls((-1470, -1320, h),(-1250, -1320, h));

            h = 640;
            thread CreateWalls((443.5, -1420, h),(-150, -1420, h));
            thread CreateWalls((445, -1450, h),(445, -1980, h));
            h += 50;
            thread CreateWalls((443.5, -1420, h),(-150, -1420, h));
            thread CreateWalls((445, -1450, h),(445, -1980, h));
            h += 50;
            thread CreateWalls((443.5, -1420, h),(-150, -1420, h));
            thread CreateWalls((445, -1450, h),(445, -1980, h));
            h += 50;
            thread CreateWalls((443.5, -1420, h),(-150, -1420, h));
            thread CreateWalls((445, -1450, h),(445, -1980, h));

            thread CreateWalls((1030, -1600, 620),(780, -1600, 705.5));
            thread CreateWalls((320, -1200, 620),(320, -1020, 620));
            thread CreateWalls((320, -1200, 677),(320, -1020, 677));

            thread CreateDoors((320, -1310, 710) /*open*/, (320, -1310, 637) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);

            thread CreateRamps((740, -1840, 600),(990, -1840, 680));
            thread spawncrate((1030, -1840, 689),(0,90,0), "com_plasticcase_friendly");

            thread CreateGrids((1400, -1760, 689),(1800, -1730, 689), (0,0,0));
            thread CreateGrids((2000, -1600, 689),(2000, -870, 689), (0,0,0));
            thread CreateGrids((1820, -790, 689),(1430, -760, 689), (0,0,0));

            thread CreateRamps((1300, -670, 700),(1300, -300, 850));

            thread CreateWalls((1115, 1270, 740),(1000, 1270, 825));

            thread fufalldamage((295, -1615, -10),250, 100);
            thread fufalldamage((-644, -808, 616.125),250, 100);
        
            thread createDeathRegion((-63, -2034, -96.8731),(-1317, -644, 268.455));
            thread createDeathRegion((1256, -448, 126.872),(1639, 635, -24.0806));

            thread createTP((-1395, 1079, 0), (-1436, -973, 810), (0,0,0));
            thread createTP((-2090, 2323, 130.125), (-1436, -973, 810), (0,0,0));
            thread createTP((663, 1577, 24.125), (-1436, -973, 810), (0,0,0));
            thread createTP((-450, 1072, -7.875), (-1436, -973, 810), (0,0,0));
            thread createTP((-1783, -394, 0), (-1436, -973, 810), (0,0,0));
            thread createTP((878, -99, 0), (-1436, -973, 810), (0,0,0));
            thread createHiddenTP((888, 1882, 896.075), (323, 2173, 1), undefined,  "out");
            //Wall Breach Patch
            thread CreateWalls((1115, 2050, 550),(652, 2050, 700));

            break;

        case "mp_nuked":
		
		 classicents = GetEntArray("classicinf", "targetname");
            foreach(ent in classicents)
                ent delete();
                 
            level.meat_playable_bounds =
            [
                (-177, -16389, 22),
                (314, -16536, -22),
				(339, -19945, -22),
				(-132, -19945, -22),
				(-16958, -4030, -22),
				(-17325, -3529, 22),
				(-17275, -2969, -22),
				(-16686, -2399, -22),
				(-15960, -3186, -22)
				
			];
             
		
			thread createPolygon();

			thread createTP((-17238,-3176,-35), (46, -17076, 663), (0, 270, 0));
			thread createTP((-16932,-3833,-35), (46, -17076, 663), (0, 270, 0));
			thread createTP((-1335, 1002, -63), (-16725, -2617, -26), (0, 310, 0));
			thread createTP((-543, 569, 80), (-16725, -2617, -26), (0, 310, 0));
			thread createTP((-1295, 257, -60), (-16725, -2617, -26), (0, 310, 0));
			thread createTP((699, 660, -60), (-16217, -3253, -26), (0, 130, 0));
			thread createTP((1400, 271, -60), (-16217, -3253, -26), (0, 130, 0));
			thread createTP((796, -22, -60), (-16217, -3253, -26), (0, 130, 0));
			thread createTurret((82,-19353,108), (0,90,358));
			//thread spawncrate((33, -19313, 44), (0,180,24));
			thread spawncrate((33, -19313, 42), (0,180,24));
			thread CreateWalls((-16430, -3086, -21),(-16325, -3216, -21));
			thread CreateWalls((-16430, -3086, 45),(-16325, -3216, 45));
			thread CreateWalls((-16325, -3216, -21),(-16255, -3300, 80));
			thread CreateWalls((-16581, -2913, -21),(-16724, -2740, -21));
			thread CreateWalls((-16581, -2913, 45),(-16724, -2740, 45));
            thread CreateWalls((-16800, -2651, -21),(-16724, -2740, 80));
			//backup
			//CreateTrapWalls((-16442, -3088, -31),(-16791, -3379, 80));
			//CreateTrapWalls((-16576, -2917, -31),(-16923, -3215, 80));
			CreateTrapWalls((-16432.1, -3079.5, -25),(-16791, -3379, -25));
			CreateTrapWalls((-16576, -2917, -25),(-16923, -3215, -25));
			CreateTrapWalls((-16432.1, -3079.5, 5),(-16721.7, -3323, 5));
			CreateTrapWalls((-16576, -2917, 5),(-16860, -3159.9, 5));
			CreateTrapWalls((-16432.1, -3079.5, 35),(-16721.7, -3323, 35));
			CreateTrapWalls((-16576, -2917, 35),(-16860, -3159.9, 35));
			CreateTrapWalls((-16781, -3370.34, 5),(-16781, -3370.34, 60),(0,40,90));
			CreateTrapWalls((-16912, -3207.77, 5),(-16912, -3207.77, 60),(0,40,90));
			CreateTrapWalls((-16432.1, -3079.5, 61),(-16791, -3379, 61));
			CreateTrapWalls((-16576, -2917, 61),(-16923, -3215, 61));
			//doors
			//thread spawncrate((-16793, -3330, 14), (0, -90, 0));
			//thread spawncrate((-16878, -3235, 14), (0, -21, 0));
			//thread CreateDoors(( -16824, -3277, -60) /*open*/,(-16824, -3277, -16) /*close*/, (90,85,90) /*angle*/, 2 /*size*/, 1 /*height*/, 60 /*hp*/, 160 /*range*/);
		    thread CreateDoors(( -16828, -3273, 90) /*open*/,(-16828, -3273, -16) /*close*/, (90,130,90) /*angle*/, 6 /*size*/, 2 /*height*/, 50 /*hp*/, 160 /*range*/);
		    thread fufalldamage((75, -17230, -9),660, 900);
		    thread moveac130position((22, -18212, 100));
			break;

        case "mp_carbon":

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

            thread createPolygon();
            
            thread createTP((-3460.66,-3728.78,3569.63), (-1447, -5107, 3790.18), undefined, true);
            thread createTP((-2922.17,-3099.82,3758.13), (-2874, -5564, 3664.18), undefined, true);
            thread createTP((-358.279,-3517.88,3898.87), (-1447, -5107, 3790.18), undefined, true);
            thread createTP((-1834.06,-3854.32,3753.36), (-2874, -5564, 3664.18), undefined, true);
            thread createTP((-386.813,-4724.77,3906.13), (-1447, -5107, 3790.18), undefined, true);
            thread createHiddenTP((-1053, -7863, 4772.18), (-2228.91,-2783.47,3758.13), undefined, "out");
            thread createHiddenTP((-685, -7624, 4080.96), (-1767.57, -7628.52, 4608.13), undefined);
            
            // Spawn Blocker
            thread CreateWalls((-2930, -5630, 3710),(-2960, -5530, 3710));
            // Conveyor wall
            thread CreateWalls((-2835, -5985, 3740),(-2835, -5985, 3740),(0,90,90));
            thread CreateWalls((-2835, -5985, 3810),(-2835, -5985, 3810),(0,90,90));
            // Grid wall long
            thread CreateGrids((-630, -6420, 4000),(-1880, -6420, 4000),(6,90,90));
            thread CreateGrids((-630, -6420, 4060),(-1880, -6420, 4060),(6,90,90));
            // Near tp wall
            thread CreateWalls((-1001, -7680, 4090),(-616, -7680, 4090));
            thread CreateWalls((-1001, -7680, 4140),(-616, -7680, 4140));
            // ele
            thread CreateElevator((-1645, -5649, 3745),(-1700, -5545, 3745), 193, 2,(0,-18,0));
            thread CreateElevator((-1770, -7855, 4600),(-1820, -7740, 4600), 168, 2,(0,0,0));
            // Roof walls
            thread CreateGrids((-2500, -6535, 4330),(-2860, -6535, 4330),(0,-105,90));
            thread CreateGrids((-2500, -6535, 4330),(-3200, -6535, 4330),(0,165,90));
            // Spawn roof
            thread CreateGrids((-2912, -5611, 3771.35),(-2768, -5731, 3771.35),(0,90,0));

            thread CreateGrids((-1800, -6750, 4320),(-2400, -6750, 4320),(-23,90,90));
            thread CreateGrids((-1800, -6900, 4170),(-2040, -6900, 4170),(-23,90,90));
            thread CreateGrids((-1800, -7075, 3980),(-2040, -7075, 3980),(0,90,90));
            thread CreateGrids((-1800, -7075, 4050),(-2040, -7075, 4050),(0,90,90));

            thread spawncrate((-290, -6195, 3930), (0, 80, 0), "com_plasticcase_friendly");

            thread moveac130position((-1735, -6197, 3891.97));

            //thread CreateWalls((-2534, -6508, 4302),(-1949, -6665, 4342));
            //thread CreateWalls((-2465, -6495, 4288),(-2377, -6179, 4309));

        break;

        case "mp_bootleg":
            rnd = randomint(3);
            if(rnd == 0)
            {
                level.meat_playable_bounds = [
                (1238.7, -596.576, 250.531),
                (1271.92, -1252.4, 103.542),
                (1108.45, -1251.23, 96.5536),
                (1110.75, -1393.06, 96.5536),
                (912.855, -1394.75, 84.5103),
                (911.424, -1719.38, 94.0974),
                (1423.96, -1717.56, 60.9901),
                (2201.13, -1828.87, 28.125),
                (2709.58, -1827.17, 28.125),
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

                thread createPolygon();

                // Spawn wall
                thread CreateWalls((940, -1710, -30),(1400, -1710, -30));
                // 1st wall + doors
                thread CreateWalls((1830, -1250, -80),(1830, -1490, 25));
                thread CreateWalls((1830, -880, -80),(1830, -1050, 25));
                thread CreateDoors((1830, -1330, -65) /*open*/, (1830, -1150, -65) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 3 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                // outer map bounds wall
                thread CreateWalls((2685, -771, -40),(2685, 307, -40));
                thread CreateWalls((2685, -771, -80),(2685, 307, -80));
                // Camping angled wall grid
                thread CreateGrids((2000, -330, 10),(2330, -385, 10), (0,0,0));
                // 2nd doors/grid floor
                thread CreateGrids((2385, 290, 10),(2480, 130, 10), (0,0,0));
                thread CreateDoors((2345, 210, -95) /*open*/, (2345, 210,60) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                thread CreateWalls((2345, 105, 30),(2345, -250, 115));
                // End of map roof grid
                thread CreateGrids((1550, -95, 320),(1440, 140, 320), (0,0,0));
                // Roof long wall
                thread CreateInvisWalls((1335, 850, 420),(1335, -95, 495));
                // End map indicator wall
                thread CreateWalls((1365, 703, -80),(1895, 703, -80));
                //block/crate
                thread spawncrate((1985, -640, 260), (90, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((1985, -640, 330), (90, 90, 0), "com_plasticcase_friendly");
                // Quicksteps up //(Height, step units,Dist-per-step)
                thread CreateQuicksteps((1840, -711, 153), 260, 16, 2, (0,0,0));
                thread CreateQuicksteps((2480, 104, 10), 110, 16, 2, (0,-90,0));
                thread CreateQuicksteps((2010, -300, 10), 130, 16, 2, (0,90,0));
                thread CreateQuicksteps((1380, 580, 350), 100, 16, 2, (0,90,0));
                // Elevator
                //thread CreateGrids((1590, -80, -116),(1695, -25, -116), (0,0,0));
                thread CreateElevator((1610, -80, -116),(1710, -25, -116), 436, 2);
                thread fufalldamage((1659, -49, -109.719),100, 500);

                thread createTP((-1714.27,172.592,-50.5525), (1178, -1466, -66));
                thread createTP((-1381.49,-1091.05,2.125), (1178, -1466, -66));
                thread createTP((-1360.53,1314.26,-102.783), (1178, -1466, -66));
                thread createTP((528.775,683.053,-100.166), (1178, -1466, -66));
                thread createTP((144.369,-1137.19,-70.184), (1178, -1466, -66));
                thread createTP((-775.411,-48.9122,78.125), (1178, -1466, -66));
                thread createHiddenTP((1383, -76, 406), (-343.66,567.401,-67.875), undefined, "out");

                thread moveac130position((2326, -1158, 1310.51));

                thread fufalldamage((2071, -692, -71.875),250, 100);
            }
            else if(rnd == 1)
            {
                level.meat_playable_bounds = [
                    (-3570.62, 387.606, 107.125),
                    (-2510.44, 393.868, 113.792),
                    (-2510.41, 571.642, 113.792),
                    (-2092.14, 567.965, 104.125),
                    (-1951.63, -886.516, 245.104),
                    (-1945.34, -1124.21, 284.29),
                    (-2372.15, -1125.03, 191.144),
                    (-2387.12, -1582.08, 188.67),
                    (-2539.47, -1582.36, 188.67),
                    (-2537.22, 50.658, 215.376),
                    (-3562.34, 54.9576, 107.125)
                ];

                thread createPolygon();

                thread createTP((-1714.27,172.592,-50.5525), (-3500, 230, 15));
                thread createTP((-1381.49,-1091.05,2.125), (-3500, 230, 15));
                thread createTP((-1360.53,1314.26,-102.783), (-3500, 230, 15));
                thread createTP((528.775,683.053,-100.166), (-3500, 230, 15));
                thread createTP((144.369,-1137.19,-70.184), (-3500, 230, 15));
                thread createTP((-775.411,-48.9122,78.125), (-3500, 230, 15));
                thread createHiddenTP((-2438, -1521, -39), (-343.66,567.401,-67.875), undefined, "out");

                // Back wall by TP
                thread CreateWalls((-3560, 390, 20),(-3560, 60, 20));
                thread CreateWalls((-3560, 390, 80),(-3560, 60, 80));
                // Front wall by TP
                thread CreateWalls((-3360, 150, 0),(-3360, 300, 80));
                //Side bridge walls
                thread CreateInvisWalls((-3530, 49, 80),(-2530, 49, 80));
                thread CreateInvisWalls((-3530, 399, 80),(-2530, 399, 80));
                //behind bridge river wall
                thread CreateInvisWalls((-2495, 560, 80),(-2495, 398, 80)); // Left wall
                thread CreateInvisWalls((-2530, -1585, 80),(-2530, 49, 80)); // Right wall (LONG)
                thread CreateInvisWalls((-2410, -1580, 80),(-2500, -1580, 80)); //end of long wall block
                //Doors
                thread CreateDoors((-2450, -220, 130) /*open*/, (-2450, -220, 60) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 3 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                //ramps
                thread spawncrate((-2525, 90, -5), (-18, -90, 25), "com_plasticcase_friendly");
                thread CreateRamps((-2460, -255, 17),(-2460, -459, -45));
                thread CreateRamps((-2400, -255, 17),(-2400, -459, -45));
                thread CreateRamps((-2475, 60, 17),(-2475, 300, -55));
                thread CreateRamps((-2400, 60, 17),(-2400, 300, -55));
                thread CreateRamps((-2270, -880, 130),(-2270, -230, 150));
                //Map wall blocker
                thread spawncrate((-2233, -585, 110), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((-2233, -525, 110), (0, 90, 0), "com_plasticcase_friendly");
                //Map wall blocker
                thread CreateWalls((-2110, -40, 160),(-2350, -40, 240)); //Side wall of upper container spot
                thread CreateWalls((-2110, -45, 80),(-2125, -570, 240)); //Big back protecting wall
                // Quicksteps up //(Height, step units,Dist-per-step)
                thread CreateQuicksteps((-2270, -890, 130), 200, 16, 2, (0,-90,0));
            
            }
            else if(rnd == 2)
            {
                thread createTP((-1714.27,172.592,-50.5525), (-3405, 17, -104.375));
                thread createTP((-1381.49,-1091.05,2.125), (-3405, 17, -104.375));
                thread createTP((-1360.53,1314.26,-102.783), (-3405, 17, -104.375));
                thread createTP((528.775,683.053,-100.166), (-3405, 17, -104.375));
                thread createTP((144.369,-1137.19,-70.184), (-3405, 17, -104.375));
                thread createTP((-775.411,-48.9122,78.125), (-3405, 17, -104.375));
                thread createHiddenTP((-3481, -3616, -71.875), (-343.66,567.401,-67.875), undefined, "out");


                // Spawn wall
                thread CreateWalls((-3505, -170, -105),(-3244, -170, -20));
                thread CreateWalls((-3244, -140, -105),(-3244, -90, -20));
                // Under bridge blocker
                thread CreateWalls((-3505, 93, -80),(-2536, 93, -80));
                // small cover walls
                thread CreateWalls((-2536, -1443, -105),(-2667, -1443, -20));
                thread CreateWalls((-2960, -845, -105),(-3100, -845, -20));

                // dirt pille blocker
                //thread CreateInvisWalls((-3535, -2165, 40),(-3535, -3238, 120));
                thread CreateInvisWalls((-3535, -2165, 70),(-3535, -3238, 70));
                thread CreateInvisWalls((-3535, -2165, 120),(-3535, -3238, 120));

                // end of edit wall
                thread CreateWalls((-3500, -3670, -105),(-2530, -3670, 40));
            }
            
            level.lowspawnoverwriteheight = -200;

            break;

        case "mp_dome":

            rnd = randomint(2);
            if(rnd == 0)
            {
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

                thread createPolygon();

                thread CreateWalls((2065, 1575, -140),(2065, 1770, -220));
                thread CreateWalls((2065, 1770, -140),(1680, 1770, -220));
                thread CreateWalls((1680, 1770, -140),(1680, 3100, -220));

                thread CreateWalls((1680, 3100, -140),(260, 3100, -220));
                thread CreateWalls((700, 3100, -220),(260, 3100, -275));
                thread CreateWalls((260, 3080, -140),(260, 2950, -275));

                thread CreateDoors((1550, 1905, -85) /*open*/, (1550, 1905, -180) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 25 /*hp*/, 118 /*range*/, true /*sideways*/);
                thread CreateDoors((1440, 2825, -180) /*open*/, (1590, 2825, -180) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, true /*sideways*/);

                thread createHiddenTP((343.967,2958.23,-253.358), (335.964,2842.02,-256.891), undefined);
                thread createHiddenTP((-830, 1591, -195.692), (-275.176,-154.868,-194.375), undefined, "out");

                thread CreateWalls((-875, 1540, -182),(-875, 1830, 5));

                thread createTP((828.526,-158.558,-399.077), (1957.74,1637.76,-184.385), (0, 180, 0));
                thread createTP((-378.537,361.14,-401.714), (1957.74,1637.76,-184.385), (0, 180, 0));
                thread createTP((1162.81,673.539,-329.895), (1957.74,1637.76,-184.385), (0, 180, 0));
                thread createTP((918.497,2043.25,-254.875), (1957.74,1637.76,-184.385), (0, 180, 0));
                thread createTP((-1056.96,1284.94,-427.875), (1957.74,1637.76,-184.385), (0, 180, 0));
            }
            else if(rnd == 1)
            {
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

                thread createPolygon();

                //stop cp blocking


                thread CreateGrids((2052, 1549, -90.297),(1955, 1364, -90.297), (0,0,0));

                thread spawncrate((1745, 820, -220), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((1800, 820, -220), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((1855, 820, -220), (0, 0, 0), "com_plasticcase_friendly");

                thread spawncrate((1720, 930, -220), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((1720, 875, -220), (0, 90, 0), "com_plasticcase_friendly");

                thread spawncrate((1565, 430, -265), (0, -110, 0), "com_plasticcase_friendly");
                thread spawncrate((1545, 375, -265), (0, -110, 0), "com_plasticcase_friendly");
                thread spawncrate((1525, 320, -265), (0, -110, 0), "com_plasticcase_friendly");
                thread spawncrate((1505, 265, -265), (0, -110, 0), "com_plasticcase_friendly");
                
                thread CreateRamps((1945, 960, -280),(1730, 960, -210));



                thread CreateWalls((2065, 925, -230),(1860, 925, -285));
                thread CreateWalls((2065, 925, -140),(1860, 925, -195));
                thread CreateWalls((1940, 700, -140),(1700, 700, -195));
                thread spawncrate((1710, 700, -202), (90, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((1740, 700, -202), (90, 90, 0), "com_plasticcase_friendly");

                thread CreateRamps((2000, 585, -320),(2000, 310, -228));
                thread CreateGrids((2000, 289, -220),(1719, 182, -220), (0,0,0));
                thread CreateWalls((1680, 0, -170),(1680, 680, -250));
                thread CreateWalls((1710, 315, -200),(1890, 315, -200));


                thread CreateDoors((1965, 810, -275) /*open*/, (1965, 810, -160) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 10 /*hp*/, 100 /*range*/, true /*sideways*/);

                thread CreateWalls((1420, -360, -340),(1510, -360, -260));

                

                thread CreateQuicksteps((-329, -150, -319), 105, 15, 2, (0,25,0));

                thread spawncrate((-532, -470, -319), (0, 25, 0), "com_plasticcase_friendly");
                thread spawncrate((-646, -506, -319), (0, 25, 0), "com_plasticcase_friendly");

                thread CreateQuicksteps((-1180, 420, -102), 200, 18, 2, (0,-90,0));

                thread CreateGrids((-1330, 405, -122),(-1080, 710, -122), (0,24,0));
                thread CreateWalls((-1047, 486, -80),(-1196, 808, -150));

                Deathradius((-1360, 498, -270), 150, 140);
                Deathradius((-913, 678, -270), 210, 140);
                Deathradius((-1216, 1006, -270), 350, 140);
                Deathradius((-1612, 745, -270), 400, 140);

                thread createTP((828.526,-158.558,-399.077), (1989, 1505, -183.423), (0, -91, 0));
                thread createTP((-378.537,361.14,-401.714), (1989, 1505, -183.423), (0, -91, 0));
                thread createTP((1162.81,673.539,-329.895), (1989, 1505, -183.423), (0, -91, 0));
                thread createTP((420, 1671, -254.875), (1989, 1505, -183.423), (0, -91, 0));
                thread createTP((-1056.96,1284.94,-427.875), (1989, 1505, -183.423), (0, -91, 0));

                thread createHiddenTP((1737, 632, -230.875), (-190, -283, -403.783), (0, 115, 0), undefined, undefined, 30, 80);
                thread createHiddenTP((-1150, 781, -18.9069), (956, 2026, -254.875), (0, 115, 0), "out");
            }

            break;
        case "mp_underground":
            rnd = randomint(2);
            if(rnd == 0) {
                level.meat_playable_bounds = [
                    (-845.979, 4274.76, -57.9189),
                    (-2404.56, 2726.47, -64.4544),
                    (-2404.01, 2631.42, 172.791),
                    (-2719.85, 2625.77, 228.309),
                    (-2716.71, 1171.95, -93.8176),
                    (-2621.99, 875.31, 8.23754),
                    (-1162.97, 903.924, 339.1),
                    (-1161.64, 2508.99, 476.364),
                    (-218.552, 3141.01, 65.0873),
                    (-221.056, 3264.53, 67.204),
                    (-131.831, 3264.53, 67.125),
                    (-134.283, 3625.16, 67.125),
                    (-378.817, 3625.13, 67.125),
                    (-380.541, 3804.67, 67.125),
                    (-781.651, 3819.42, 67.125),
                    (-771.93, 4274.25, -72.875)
                ];

                thread createPolygon();

                // Long roof blocker
                thread CreateWalls((-1150, 2524, 360),(-1150, 1973, 360));
                //end of edit blocker
                thread CreateWalls((-752, 4283, -100),(-799, 4284, -100));
                thread CreateWalls((-758, 3839, -100),(-758, 4281, -100));
                // 1st roof edge walls
                thread CreateWalls((-2740, 2204, 140),(-2740, 2641, 140));
                thread CreateWalls((-2740, 2641, 140),(-2128, 2646, 140));
                // Garage/alley blocker
                thread CreateWalls((-2415, 2690, -220),(-2415, 2690, -100),(0,90,90));
                //new spawn protection
                thread CreateTrapGrids((-2067, 1160.7, 100),(-1925, 975.5, 100), (0,0,0));
                // Garage big entrance blocker
                thread CreateWalls((-1200, 3905, -120),(-973, 4132, -40));
                // roof to roof ramp
                thread CreateRamps((-2140, 2330, 90),(-1870, 2330, 214));
                thread CreateRamps((-2140, 2400, 90),(-1870, 2400, 214));
                thread CreateRamps((-1185, 2521, 191),(-1185, 2830, 57));
                // Roof door walls
                thread CreateWalls((-1920, 2505, 210),(-1920, 2450, 290));
                thread CreateWalls((-1920, 2280, 210),(-1920, 1980, 290));
                thread CreateDoors((-1920, 2200, 223) /*open*/, (-1920, 2365, 223) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 75 /*range*/, false /*sideways*/);
                
                // quicksteps
                thread CreateQuicksteps((-2345, 2190, 95), 120, 16, 2, (0,-90,0));
                thread CreateQuicksteps((-2500, 2190, 95), 120, 16, 2, (0,-90,0));
                // end edit walls
                thread CreateWalls((-782, 3816, 40),(-382, 3816, 40));
                thread CreateWalls((-377, 3820, 40),(-376, 3636, 40));
                thread CreateWalls((-346, 3636, 40),(-125, 3640, 40));
                thread CreateWalls((-121, 3609, 40),(-121, 3284, 40));
                thread CreateWalls((-152, 3280, 40),(-226, 3279, 40));
                thread CreateWalls((-232, 3248, 40),(-232, 3167, 40));
                // Hide spot roof 1
                thread CreateWalls((-2292, 2610, 100),(-2292, 2480, 180));
                // garage block
                thread CreateWalls((-2306, 1216, -210),(-2306, 895, -120));

                thread CreateWalls((-2060, 1205, -98),(-1920, 1205, -98));


                thread createHiddenTP((-306, 3223, 16), (32, 2949, -249), undefined, "out");
                thread createTP((343.421,2488.08,-148.875), (-1997, 1020, -215.875), undefined);
                thread createTP((718.752,1720.09,-255.875), (-2344, 901, -204.875), (0,94,0));
                thread createTP((-358.152,52.1443,-127.875), (-2344, 901, -204.875), (0,94,0));
                thread createTP((422.092,71.6326,-127.875), (-1997, 1020, -215.875), undefined);
                thread createTP((9.44049,-731.92,0.124999), (-1997, 1020, -215.875), undefined);
                thread createTP((-1492.52,1897.44,-255.875), (-1997, 1020, -215.875), undefined);
            }
            else if(rnd == 1) {
                level.meat_playable_bounds = [
                    (2241.2, 3080.37, 112.13),
                    (1786.39, 3094.27, 152.135),
                    (1785.45, 1705.24, 152.131),
                    (1520.58, 1708.91, 291.279),
                    (989.553, 1165.19, 214.604),
                    (542, 1167.41, 330.686),
                    (584.422, -1183.16, 257.149),
                    (2539.71, -1066.53, 93.3717),
                    (2544.14, -445.376, 164.656),
                    (2283.72, 957.882, 112.355),
                    (2274.24, 2058.55, 112.126)
                ];

                thread createPolygon();

                // TPs
                thread createHiddenTP((565.125,1135.89,174.125), (-737.578,3282.3,-127.875), undefined, "out");
                thread createTP((343.421,2488.08,-148.875), (2169.93, 2971.3, -12.4441));
                thread createTP((718.752,1720.09,-255.875), (2169.93, 2971.3, -12.4441));
                thread createTP((-358.152,52.1443,-127.875), (2169.93, 2971.3, -12.4441));
                thread createTP((422.092,71.6326,-127.875), (2169.93, 2971.3, -12.4441));
                thread createTP((9.44049,-731.92,0.124999), (2169.93, 2971.3, -12.4441));
                thread createTP((-1492.52,1897.44,-255.875), (2169.93, 2971.3, -12.4441));

                // Edit
                //Spawn back wall
                thread CreateWalls((1807, 3070, -2),(2217, 3070, 78));
                //spawn front wall
                thread CreateWalls((2040, 2883, -2),(2240, 2885, 78));
                // roof wall
                thread CreateWalls((1780, 1700, 150),(1536, 1700, 230));
                // Door walls
                thread CreateWalls((1839, 190, 8),(1954, 190, 92)); // Right wall
                thread CreateWalls((2256, 190, 8),(2143, 190, 92)); // Left wall
                thread CreateDoors((2050, 190, 100) /*open*/, (2050, 190, 25) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                // Back of map Bin area blocker
                thread CreateWalls((2514, -1045, 8),(2329, -1045, 92));
                // Back of map street blocker
                thread CreateWalls((1810, -1150, 8),(1450, -1150, 92));
                //elevator
                thread CreateElevator((1220, 160, 0),(1300, 30, 0), 132, 3);
            }

            break;
        case "mp_nightshift":
            rnd = randomint(3);
            if(rnd == 0) {
                thread spawncrate((2055, -740, 30),(0,0,90), "com_plasticcase_friendly");
                thread spawncrate((2055, -740, 80),(0,0,90), "com_plasticcase_friendly");
                thread spawncrate((2055, -740, 130),(0,0,90), "com_plasticcase_friendly");
                //End edit wall
                startlocation = (1583, -7700, 20);
                i=0; h = 0;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;

                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h++;
                thread spawncrate(startlocation + (80 * i,0,60*h), (0,0,90), "com_plasticcase_friendly"); h=0; i++;
                
                // 1st doors + walls
                thread CreateWalls((2010, -4050, 0),(2010, -4050, 100), (0,0,90));
                thread CreateWalls((2065, -4050, 0),(2065, -4050, 100), (0,0,90));
                thread CreateDoors((1670, -4050, 25) /*open*/, (1885, -4050, 25) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                thread CreateWalls((1755, -4050, 0),(1755, -4050, 100), (0,0,90));
                thread CreateWalls((1700, -4050, 0),(1700, -4050, 100), (0,0,90));
                thread CreateWalls((1645, -4050, 0),(1645, -4050, 100), (0,0,90));
                thread CreateWalls((1590, -4050, 0),(1590, -4050, 100), (0,0,90));
                
                // 2nd doors + walls
                thread CreateWalls((2010, -6000, 0),(2010, -6000, 100), (0,0,90));
                thread CreateWalls((2065, -6000, 0),(2065, -6000, 100), (0,0,90));
                thread CreateDoors((1670, -6000, 25) /*open*/, (1885, -6000, 25) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                thread CreateWalls((1755, -6000, 0),(1755, -6000, 100), (0,0,90));
                thread CreateWalls((1700, -6000, 0),(1700, -6000, 100), (0,0,90));
                thread CreateWalls((1645, -6000, 0),(1645, -6000, 100), (0,0,90));
                thread CreateWalls((1590, -6000, 0),(1590, -6000, 100), (0,0,90));

                thread createTP((422.541,-4.74144,0.124998), (1855.07,-968.006,0.125001));
                thread createTP((1082.29,-1368.61,-7.875), (1886.86,-976.47,0.125001));
                thread createTP((-1413.83,-965.665,-6.58853), (1871.85,-1006.05,0.124999));
                thread createTP((-270.78,194.355,176.011), (1880.66,-988.33,0.125));
                thread createTP((-735.229,-2030.04,0.124998), (1881.5,-997.739,0.125136));
                thread createHiddenTP((1620, -7630, 0), (255.1,-603.316,0.125001), undefined, "out");
        


                thread createDeathRegion((3774.3,-4424.13,-1348.78), (2008.13,-11069.9,-102.64));
                createDeathLine((1395.98,-2429.13,208.13), (1512.73,-11307,191.329));
                createDeathLine((1576.12,-8155,8.13167), (3521.12,-8293.78,47.4947));
            }
            else if(rnd == 1)
            {

				thread CreateTrapGrids((-157, 529, 650),(-277, 678, 650), (0,0,0));
                thread spawncrate((-681, -120, 600), (90, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-681, -120, 670), (90, 0, 0), "com_plasticcase_friendly");

                thread spawncrate((-70, 710, 580), (90, 0, 0), "com_plasticcase_friendly");

                thread CreateWalls((-470, 515, 465),(-470, 515, 570),(0,90,90));
                thread CreateWalls((-1760, 680, 340),(-1840, 580, 440));

                thread CreateWalls((-681, -450, 640),(-681, -800, 640));
                thread CreateWalls((-1020, -1130, 575),(-1160, -1130, 575));
                thread CreateWalls((-1020, -1130, 640),(-1160, -1130, 640));

                thread spawncrate((-1930, -424, 652), (0, 90, 0), "com_plasticcase_friendly");

                thread CreateGrids((-1420, 180, 553),(-1820, 210, 553), (0,0,0));

                thread CreateGrids((-1875, 280, 321),(-1985, 250, 321), (0,0,0));
                thread CreateGrids((-1875, 180, 553),(-1985, 210, 553), (0,0,0));

                thread CreateGrids((-1055, 185, 553),(-1105, 155, 553), (0,0,0));

                thread CreateElevator((-1875, 280, 321),(-1985, 250, 321), 232, 1.5,(0,0,0));

                thread spawncrate((-980, -160, 553), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-980, -440, 553), (0, 0, 0), "com_plasticcase_friendly");
                thread spawncrate((-1053, -290, 553), (0, 90, 0), "com_plasticcase_friendly");

                thread createDeathRegion((-3230, 956, 800), (-1560, 1200, 200));
                thread createDeathRegion((-1560, 945, 800),(400, 1200, 200));
                thread createDeathRegion((-2520, 970, 290),(-3170, 250, 175));

                thread createDeathRegion((-300, -1127, 670),(-1250, -1600, 440));
                thread createDeathRegion((-688, -1127, 670),(-300, -100, 440));

                thread createTP((-719, -408, 136.125), (-203, 574, 466), (0,180,0), true);
                thread createTP((691, 315, 8.125), (-203, 574, 466), (0,180,0), true);
                thread createTP((576, -616, 0.0939837), (-203, 574, 466), undefined, true);
                thread createTP((575, -1741, -7.875), (-203, 574, 466), (0,180,0), true);
                thread createTP((-818, -2044, 0.125), (-203, 574, 466), undefined, true);
                thread createTP((-2450, -280, 128.125), (-203, 574, 466), undefined, true);
                thread createTP((-1195, 706, -7.875), (-203, 574, 466), (0,180,0), true);
                
                //createDeathLine((1576.12,-8155,8.13167), (3521.12,-8293.78,47.4947));
            }
			
			 else if(rnd == 2)
            {
				thread CreateWalls((-673, -1284, 140),(-511, -1284, 185));
				thread CreateWalls((-903, -1426, -11),(-984, -1424, 111));
				thread CreateWalls((-1507, -1921, 0),(-1507, -1823, 95));
				thread CreateWalls((967, -1779, 55),(1097, -1779, 55));
				thread CreateWalls((967, -1779, 115),(1097, -1779, 115));
		
				thread CreateWalls((-673, -1120, 630),(-271, -1120, 630));
				thread CreateWalls((-673, -1120, 690),(-271, -1120, 690));
				thread CreateInvisWalls((-240, -1120, 690),(220, -1120, 690));
				thread CreateInvisWalls((-230, -1807, 690),(220, -1807, 690));
				thread CreateInvisWalls((220, -1761, 690),(220, -1155, 690));
		
				thread CreateWalls((-190, -2346, 740),(-376, -2346, 740));
				thread CreateWalls((-190, -2346, 705),(-1169, -2346, 705));
				thread CreateWalls((-190, -2346, 670),(-1169, -2346, 670));
				thread CreateWalls((-190, -2346, 635),(-1169, -2346, 635));
				thread CreateWalls((-190, -2346, 600),(-1169, -2346, 600));
		
				thread CreateWalls((-190, -2346, 540),(-448, -2346, 540));
				thread CreateWalls((-255, -2346, 480),(-448, -2346, 480));
		
				thread CreateWalls((491, -1779, 60),(199, -1779, 60));
				thread CreateWalls((491, -1779, 10),(199, -1779, 10));
				thread CreateInvisWalls((-170, -2290, 570),(-170, -1810, 570));
				thread CreateInvisWalls((-170, -2290, 630),(-170, -1810, 630));
				thread CreateInvisWalls((-170, -2290, 690),(-170, -1810, 690));
		
		
				thread spawncrate((-1010, -1681, 20), (0, 90, 0), "com_plasticcase_friendly");
				thread spawncrate((-1010, -1681, 90), (0, 90, 0), "com_plasticcase_friendly");
		
				thread spawncrate((-1107, -1887, 40), (90, 90, 0));
				thread spawncrate((-1053, -951, 590), (0, 0, 0), "com_plasticcase_friendly");
				thread spawncrate((-1053, -951, 640), (0, 0, 0), "com_plasticcase_friendly");
				thread spawncrate((-1627, -1554, 680), (0, 90, 0), "com_plasticcase_friendly");
		
				thread CreateGrids((-468, -1559, 433),(-468, -1767, 433), (0,0,0));
				thread CreateGrids((-992, -1782, 267),(-886, -1695, 267), (0,0,0));
		
		
				ent = spawn("script_model", (-833, -3030, -1050));
				ent.angles = (0, 0, 0);
				ent setmodel("city_facade_tier_with_roof");	
	
		
				thread CreateQuicksteps((-686, -1727, 270), 150, 16, 2, (0,0,0));
				thread CreateQuicksteps((-1092, -1732, 483), 220, 16, 2, (0,0,0));
		
				thread CreateQuicksteps((-295, -1770, 590), 170, 16, 2, (0,270,0));
		

				thread CreateDoors((-707, -1497, 470) /*open*/, (-707, -1643, 470) /*close*/, (90,0,0) /*angle*/, 4 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, true /*sideways*/); 
		
		
				ent = spawn("script_model", (-650, -1284, 134));
				ent.angles = (0, 0, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
		
				ent = spawn("script_model", (-590, -1284, 134));
				ent.angles = (0, 0, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
		
				ent = spawn("script_model", (-533, -1284, 134));
				ent.angles = (0, 1, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
		
				ent = spawn("script_model", (-642, -1284, 162));
				ent.angles = (0, 0, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
		
				ent = spawn("script_model", (-583, -1284, 162));
				ent.angles = (0, 0, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
				ent = spawn("script_model", (-527, -1284, 162));
				ent.angles = (0, 0, 0);
				ent setmodel("com_plasticcase_green_big_us_dirt");
		
		
		
		
		
				ent = spawn("script_model", (-1113, -1889, 10));
				ent.angles = (0, 0, 0);
				ent setmodel("mil_sandbag_desert_short");	
		
				thread createTurret((-1113, -1888, 40), (0,0,0), 33, 33, 3, undefined);
		
				thread createTP((-1417,-1982.68,-10), (-597, -1462, 150), (0,270,0));
				thread createTP((-1417,-1982.68, 585), (-1280, -1616, 0), (0,304,0));
		
				thread createDeathRegion((-178, -1791, 566), (40, -2317, 287));
				thread createDeathRegion((697, -1960, 440), (-435, -2983, 209));
				thread createDeathRegion((-661, -2374, 600), (864, -2983, 209));
				thread createDeathRegion((-1015, -1109, 710), (561, -701, 580));
		
				thread fufalldamage((-1024, -1552, 1),900, 680);
		
		
				thread createTP((-1770,-1458.5, -14), (1087.6, -1820.8, 60), (0,220,0));
				thread createTP((-1193,-653.5, -14), (1087.6, -1820.8, 60), (0,220,0));
				thread createTP((0, 181.5, 0), (1087.6, -1820.8, 60), (0,220,0));
				thread createTP((-1434, 243.5, -5), (1087.6, -1820.8, 60), (0,220,0));
			    thread createTP((1271, -833.5, -5), (1087.6, -1820.8, 60), (0,220,0)); 
			
			
			}

            break;
        case "mp_terminal_cls":

            rnd = randomint(3);
            if(rnd == 0)
            {
                level.meat_playable_bounds = [
                (7374.95, 1920.5, 464.125),
                (3512.75, 1909.48, 464.125),
                (2874.28, 2550.23, 466.528),
                (2864.37, 3124.61, 481.673),
                (2820.23, 3124.52, 481.673),
                (2818.5, 3737.38, 577.125),
                (7376.41, 3744.49, 464.125)
                ];

                thread createPolygon();

                thread CreateWalls((5330, 3750, 500),(2820, 3750, 500));
                thread CreateWalls((5330, 3750, 550),(2820, 3750, 550));

                thread CreateWalls((2810, 3150, 500),(2810, 3740, 500));
                thread CreateWalls((2810, 3150, 550),(2810, 3740, 550));

                thread CreateWalls((6660, 3050, 460),(6660, 3480, 560));
                thread CreateWalls((5800, 2500, 460),(5800, 2300, 560));
                thread CreateWalls((5100, 3600, 460),(5100, 3480, 560));
                thread CreateWalls((5480, 2930, 460),(5680, 3130, 560));

                thread spawncrate((3470, 3730, 560), (0, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((3510, 3730, 560), (0, 90, 0), "com_plasticcase_friendly");

                thread createTP((1391.9,3610.83,40.125), (7042.91, 2827.69, 464.125));
                thread createTP((514.71,4868.89,42.6011), (6958.87, 3122.01, 464.125));
                thread createTP((-128.276,5128.76,193.125), (7044.81, 3083.88, 464.125));
                thread createTP((1468.77,5608.75,192.125), (6959.89, 2865.68, 464.125));
                thread createTP((2431.35,5453.63,216.125), (7039.03, 3191.91, 464.125));
                thread createTP((2429.09,3384.08,80.125), (7046.13, 2759.87, 464.125));
                thread createHiddenTP((2850, 3706, 464.125), (1747.58,4604.66,173.516), undefined, "out");
            }
            else if(rnd == 1)
            {
                thread CreateWalls((4000, 2400, 190),(4210, 2400, 300));

                thread CreateWalls((3980, 2980, 190),(3540, 2540, 300));

                thread CreateWalls((4015, 3005, 190),(4015, 3205, 230));
                
                thread CreateWalls((4015, 3005, 270),(4015, 3205, 300));

                thread CreateWalls((4100, 3220, 190),(4220, 3220, 300));
                thread CreateDoors((4500, 3220, 220) /*open*/, (4330, 3220, 220) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, true /*sideways*/);          

                thread CreateWalls((3860, 3550, 190),(3860, 3410, 300));
                thread CreateDoors((3570, 3230, 220) /*open*/, (3390, 3230, 220) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 2 /*height*/, 15 /*hp*/, 100 /*range*/, true /*sideways*/);
                thread CreateWalls((3530, 3230, 190),(3715, 3230, 300));
                
                thread CreateWalls((3260, 3230, 190),(3300, 3230, 300));

                thread CreateWalls((3240, 2990, 190),(3240, 3070, 330));

                thread CreateRamps((3522, 3564, 190),(3829, 3569, 340));

                thread createTP((1455, 4379, 168.125), (4103, 2137, 193.125), (0,90,0));
                thread createTP((2787, 2940, 76.125), (4103, 2137, 193.125), (0,90,0));
                thread createTP((753, 2860, 40.125), (4103, 2137, 193.125), (0,90,0));
                thread createTP((-266, 5131, 193.125), (4103, 2137, 193.125), (0,90,0));
                thread createTP((1515, 6341, 192.125), (4103, 2137, 193.125), (0,90,0));

                thread createHiddenTP((3025, 3500, 192),(3045, 3160, 192), undefined);
                thread createHiddenTP((3045, 2888, 192),(357, 4587, 306), undefined , "out");
            }
			else if(rnd == 2)
            {
			
			level.meat_playable_bounds = [
                    (-71.125, 4094.24, 520.038),
                    (-1329, 4080.86, 289.564),
                    (-1328.88, 3409.3, 258.936),
                    (-2037.78, 3413.33, 167.125),
                    (-2411.18, 3502.8, 227.125),
                    (-2398.77, 3644.73, 133.125),
                    (-2728.5, 3634.5, 483.335),
					(-2728.5, 4067.5, 483.335),
					(-2943.12, 4067.5, 483.335),
					(-2940.5, 5282.6, 483.335),
					(-1123.87, 5284.56, 483.335),
					(-1210.1, 4507.56, 483.335),
					(-556.7, 4509.49, 483.335),
					(-572.49, 4856.64, 483.335),
                    (-19, 4879, 489.63)
                ];

                thread createPolygon();

        thread spawncrate((-3065, 4781, 181), (0, 0, 0));
        thread spawncrate((-2995, 4781, 181), (0, 0, 0));
        thread spawncrate((-3040, 4712, 165), (0, 270, 0));
		thread spawncrate((-2990, 4712, 165), (0, 270, 0));
        
		thread spawncrate((-2934, 4949, 492), (27, 270, 0), "com_plasticcase_friendly");
		thread spawncrate((-2934, 4899.5, 466.5), (27, 270, 0), "com_plasticcase_friendly");
		thread spawncrate((-2934, 4850, 441), (27, 270, 0), "com_plasticcase_friendly");
		thread spawncrate((-2934, 4800.5, 415.5), (27, 270, 0), "com_plasticcase_friendly");
		thread spawncrate((-2934, 4751, 390), (27, 270, 0), "com_plasticcase_friendly");

		thread spawncrate((-2934, 4734, 360), (90, 0, 0), "com_plasticcase_friendly");
		thread spawncrate((-2934, 4734, 305), (90, 0, 0), "com_plasticcase_friendly");
        thread spawncrate((-2934, 4734, 250), (90, 0, 0), "com_plasticcase_friendly");
        thread spawncrate((-2934, 4734, 195), (90, 0, 0), "com_plasticcase_friendly");
     
		thread CreateWalls((-2934, 4128, 172),(-2934, 4709, 172));
		thread CreateWalls((-2934, 4678, 115),(-2934, 5416, 115));
		thread CreateWalls((-2934, 4678, 55),(-2934, 5416, 55));
		thread CreateWalls((-2934, 5138, -5),(-2934, 5416, -5));
		
		thread CreateWalls((-1359, 4098, 55),(-1879, 4098, 55));
		thread CreateWalls((-1359, 4098, 115),(-1879, 4098, 115));
		thread CreateWalls((-1359, 4098, 172),(-1879, 4098, 172));
		
		thread CreateWalls((-2019, 4098, 55),(-2260, 4098, 55));
        thread CreateWalls((-2019, 4098, 115),(-2934, 4098, 115));
		thread CreateWalls((-2019, 4098, 172),(-2934, 4098, 172));
		thread CreateWalls((-2375, 4098, 55),(-2934, 4098, 55));
		
		thread CreateWalls((-2934, 4986, 493),(-2934, 5282, 493));
		
		thread CreateWalls((-1184, 5299, 493),(-2903.88, 5299, 493));
		

		
		thread CreateWalls((-1154, 4683, 493),(-1154, 5282, 493));
		thread CreateWalls((-1154, 4683, 433),(-1154, 4961, 433));	
        thread CreateWalls((-1154, 4683, 373),(-1154, 4841, 373));		

        thread CreateWalls((-1154, 4213, 423),(-1154, 4070, 423));		

        thread spawncrate((-1776, 3975, 169), (0, 10, 0), "com_plasticcase_friendly");
		thread spawncrate((-1771.5, 3945, 169), (0, 10, 0), "com_plasticcase_friendly");
		
		thread spawncrate((-1766, 3915, 169), (0, 10, 0), "com_plasticcase_friendly");
		thread spawncrate((-1761.5, 3885, 169), (0, 10, 0), "com_plasticcase_friendly");
		thread spawncrate((-1757.5, 3855, 169), (0, 10, 0), "com_plasticcase_friendly");
		
		thread spawncrate((-1752.5, 3825, 169), (0, 10, 0), "com_plasticcase_friendly");
		thread spawncrate((-1748.5, 3795, 169), (0, 10, 0), "com_plasticcase_friendly");
		
		thread CreateRamps((-1795.6, 3803, 170),(-1892, 3787, 230));
		thread CreateRamps((-1938.6, 3797, 248),(-2050, 3871, 289));
		thread spawncrate((-1926.5, 3782, 244), (0, 100, 0), "com_plasticcase_friendly");
		
		thread spawncrate((-2073.5, 3885, 297), (0, 52, 0), "com_plasticcase_friendly");
		thread spawncrate((-2130.5, 3996, 297), (0, 0, 0));
		thread spawncrate((-2160.5, 3996, 297), (0, 0, 0));
		
		thread CreateQuicksteps((-2146, 4655, 345), 50, 16, 2, (0,270,0));
		thread CreateQuicksteps((-2468, 4655, 345), 50, 16, 2, (0,270,0));
		
		thread spawncrate((-1921.5, 4161, 124), (0, 330, 0));


	    thread CreateQuicksteps((-1847, 4211, 130), 100, 16, 2, (0,355,0), 420);
		
		thread spawncrate((-1265, 4105, 110), (0, 0, 0));
		thread spawncrate((-1359, 4059, 66), (0, 90, 0), "com_plasticcase_friendly");
		thread CreateWalls((-1359, 4082, 115),(-1359, 3414, 115));
		thread CreateWalls((-1359, 3627, 49),(-1359, 3414, 49));
		
		thread CreateDoors((-1194, 4282, 145) /*open*/, (-1194, 4282, 70) /*close*/, (90,0,0) /*angle*/, 6 /*size*/, 2 /*height*/, 20 /*hp*/, 150 /*range*/, false /*sideways*/);
		thread CreateDoors((-2819.5, 4883, 145) /*open*/, (-2819.5, 4883, 70) /*close*/, (90,90,0) /*angle*/, 4 /*size*/, 2 /*height*/, 30 /*hp*/, 150 /*range*/, false /*sideways*/);
		
		thread createDeathRegion((-2947, 5916, -30),(-3436, 4831, 315));
		thread createDeathRegion((-1135.88, 4382.8, 370),(-454, 4940, 462));
		
		thread createDeathRegion((-1086.43, 3510.46, 28),(-43, 3100, 150));
		thread createDeathRegion((-1135.88, 4532.87, 540),(-656,4298.8, 660));
		
		thread createTP((1073.1,6304.08,191.875), (-442, 4741, 55.875), (0,250,0));
		thread createTP((2431.35,5453.63,216.125), (-180, 4739, 55.875), (0,220,0));
		thread createTP((1391.9,3610.83,40.125), (-442, 4741, 55.875), (0,250,0));
		thread createTP((514.71,4868.89,42.6011), (-180, 4739, 55.875), (0,220,0));
		thread createTP((-128.276,5128.76,193.125), (-442, 4741, 55.875), (0,250,0));
		thread createTP((2429.09,3384.08,80.125), (-180, 4739, 55.875), (0,220,0));
		
		thread createTP((-2815.89,5409.9,0.125), (-2690, 3825, 50), (0,0,0));
		thread createHiddenTP((-2149.64, 5251, 470), (1066.99, 7427.14, 215), (0, 270, 0), "out");
		
		thread fufalldamage((-2019, 4128, 60),1500, 900);
		
		 
		
		ent = spawn("script_model", (-600, 3346, 40));
        ent.angles = (0, 10, 0);
        ent setmodel("police_barrier_01");	
				
		ent = spawn("script_model", (-414, 3326, 40));
        ent.angles = (0, 13, 0);
        ent setmodel("police_barrier_01");

		ent = spawn("script_model", (-862, 3339, 40));
        ent.angles = (0, 13, 0);
        ent setmodel("vehicle_policecar_russia_destructible");
            
	}
        break;

        case "mp_courtyard_ss":


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

                thread createPolygon();

                thread createTP((-50, -1942, 127.457), (-502, -2425, 29.1895));
                thread createTP((776, -728, 129.125), (-502, -2425, 29.1895));
                thread createTP((-69, -325, 121.69), (-502, -2425, 29.1895));
                thread createTP((-682, -736, -1.81347), (-502, -2425, 29.1895));
                thread createTP((-1081, -1985, 248.125), (-502, -2425, 29.1895));
                thread createTP((-43, -1090, 126.125), (-502, -2425, 29.1895));
                thread createHiddenTP((-1542, -937, 440.125), (-63, 326, 128.125), undefined, "out");

                // Spawn wall fill
                thread CreateWalls((-129, -2725, 40),(256, -2725, 40));
                thread CreateWalls((-129, -2725, 100),(256, -2725, 100));
                thread CreateWalls((-129, -2725, 160),(256, -2725, 160));
                thread CreateInvisWalls((-370, -2725, 220),(256, -2725, 220));
                thread CreateInvisWalls((-370, -2725, 280),(256, -2725, 280));
                // Out of spawn long wall
                thread CreateWalls((687, -3170, 20),(687, -2490, 20));     
                thread CreateWalls((687, -3170, 80),(687, -2380, 80));     
                thread CreateWalls((687, -3220, 140),(687, -2150, 140));   
                thread CreateWalls((687, -2650, 200),(687, -2150, 200));
                thread CreateWalls((687, -2650, 260),(687, -2150, 260));
                // Blockers
                thread spawncrate((594, -2165, 280), (90, 90, 0), "com_plasticcase_friendly");
                thread spawncrate((467, -2158, 280), (90, 90, 0), "com_plasticcase_friendly");
                // Doors Left
                thread CreateWalls((287, -2785, 40),(287, -2925, 40));
                thread CreateWalls((287, -2785, 100),(287, -2925, 100));
                thread CreateWalls((287, -2785, 160),(287, -2925, 160));
                //
                thread CreateWalls((437, -2785, 40),(437, -2925, 40));
                thread CreateWalls((437, -2785, 100),(437, -2925, 100));
                thread CreateWalls((437, -2785, 160),(437, -2925, 160));
                //
                thread CreateWalls((317, -2926, 40),(406, -2926, 40));
                thread CreateWalls((317, -2926, 100),(406, -2926, 100));
                thread CreateWalls((317, -2926, 160),(406, -2926, 160));
                // Doors Right
                thread CreateWalls((287, -3228, 40),(287, -3379, 40));
                thread CreateWalls((287, -3228, 100),(287, -3379, 100));
                thread CreateWalls((287, -3228, 160),(287, -3379, 160));
                //
                thread CreateWalls((437, -3228, 40),(437, -3379, 40));
                thread CreateWalls((437, -3228, 100),(437, -3379, 100));
                thread CreateWalls((437, -3228, 160),(437, -3379, 160));
                //
                thread CreateWalls((317, -3226, 40),(406, -3226, 40));
                thread CreateWalls((317, -3226, 100),(406, -3226, 100));
                thread CreateWalls((317, -3226, 160),(406, -3226, 160));
                // 1st Door
                thread CreateDoors((287, -3072, 140) /*open*/, (287, -3072, 60) /*close*/, (90,0,0) /*angle*/, 5 /*size*/, 3 /*height*/, 30 /*hp*/, 80 /*range*/, false /*sideways*/);
                // 2nd wall fill
                thread CreateWalls((-289, -3407, 70),(-72, -3407, 70));
                thread CreateWalls((-300, -3407, 130),(-10, -3407, 130));
                thread CreateWalls((-330, -3407, 190),(20, -3407, 190));
                // Shooting platform
                thread CreateGrids((-432, -3025, 200),(-582, -2736, 200), (0,0,0));
                thread CreateRamps((-630, -2770, 187),(-850, -2770, 40));
                // Shooting platform side blocker
                thread CreateWalls((-800, -2715, 220),(-400, -2715, 300));
                thread CreateWalls((-395, -2750, 220),(-395, -2930, 300));
                // Yet another wall filler xD pog lmao good one
                thread CreateWalls((-1264, -3408, 20),(-1762, -3408, 20));
                thread CreateWalls((-1264, -3408, 80),(-1762, -3408, 80));
                thread CreateWalls((-1264, -3408, 140),(-1762, -3408, 140));
                thread CreateWalls((-1775, -3380, 20),(-1775, -3360, 20));
                thread CreateWalls((-1775, -3380, 80),(-1775, -3300, 80));
                thread CreateWalls((-1775, -3380, 140),(-1775, -3300, 140));
                // Death barrier
                thread createDeathRegion((-1240, -1747, 0), (-2207, -201, 160));
                thread createDeathRegion((-1218, -1132, 0), (-1971, -480, 350));
                // Near end wall small
                thread CreateWalls((-1584, -1766, 80),(-1768, -1766, 80));
                thread CreateWalls((-1584, -1766, 140),(-1768, -1766, 140));
                thread CreateWalls((-1584, -1766, 200),(-1768, -1766, 200));
                // Near end wall big
                thread CreateWalls((-1775, -1770, 80),(-1775, -2000, 80));
                thread CreateWalls((-1775, -1770, 140),(-1775, -2110, 140));
                thread CreateWalls((-1775, -1770, 200),(-1775, -2220, 200));
                // Tower barrier block
                thread CreateInvisWalls((-1225, -1761, 520),(-1213, -633, 520));
                thread CreateInvisWalls((-1225, -1761, 580),(-1213, -633, 580));
                // end wall blocker
                thread spawncrate((-1756, -2209, 250), (0, 0, 0));
                thread spawncrate((-1756, -2209, 290), (0, 0, 0));
                thread spawncrate((-1820, -2209, 250), (0, 0, 0));
                thread spawncrate((-1820, -2209, 290), (0, 0, 0));
                thread spawncrate((-758, -2746, 280), (0, 0, 0));
                // 2nd door wall
                thread CreateWalls((-1745, -2611, 20),(-1555, -2611, 140));
                thread CreateDoors((-1458, -2607, 120) /*open*/, (-1458, -2607, 30) /*close*/, (90,90,0) /*angle*/, 3 /*size*/, 3 /*height*/, 20 /*hp*/, 80 /*range*/, false /*sideways*/);
                // Tower quickstep
                thread CreateQuicksteps((-1476, -1403, 470), 200, 16, 2, (0,-90,0));
                // Blocker to stop getting stuck between tower and map barrier
                thread spawncrate((-1249, -1145, 470), (0, 90, 0), "com_plasticcase_friendly");
				
        break;
        case "mp_highrise":
            classicents = GetEntArray("classicinf", "targetname");
            foreach(ent in classicents)
                ent delete();

            thread CreateWalls((-2970, 19860, 1870),(-2970, 19560, 1980)); // walls for tp flag
            thread CreateWalls((-2587, 19820, 2070),(-2587, 19982, 2154)); // walls tp side ontop of helipad
            thread CreateWalls((-2500, 20100, 1870),(-2500, 20350, 2000)); // wall next to stairs tp side
            thread CreateGrids((-2038, 20040, 1855),(-1412, 20160, 1855), (0,0,0)); // floor crossing buildings

            thread CreateWalls((-1400, 19600, 1900),(-1400, 20000, 1900)); // 
            thread CreateWalls((-1400, 19600, 1960),(-1400, 20000, 1960)); // next to door

            thread CreateWalls((-1400, 20200, 1900),(-1400, 20600, 1900)); //
            thread CreateWalls((-1400, 20200, 1960),(-1400, 20600, 1960)); // next to door

            thread CreateWalls((-780, 20220, 2070),(-780, 20375, 2070));
            thread CreateWalls((-620, 19670, 2070),(-620, 19870, 2070));

            thread CreateWalls((-1040, 19530, 1870),(-1040, 19430, 1960));
            thread CreateWalls((-935, 20730, 1870),(-935, 20530, 1960));

            thread CreateGrids((-2500, 19740, 2059),(-940, 19740, 2059),(0,0,0));
            thread CreateGrids((-2500, 20430, 2059),(-940, 20430, 2059),(0,0,0));

            thread spawncrate((-920, 20100, 2075), (90, 0, 0), "com_plasticcase_trap_friendly");
            thread createTurret((-920, 20100, 2110), (0,180,0), 25, 25, undefined, 10);

            thread createTP((-3261, 5746, 2824), (-3295, 19658, 1870.13), undefined);
            thread createTP((-2269, 6060, 2776), (-3295, 19658, 1870.13), undefined);
            thread createTP((-1369, 5227, 2776), (-3295, 19658, 1870.13), undefined);
            thread createTP((263, 5333, 2824), (-3295, 19658, 1870.13), undefined);
            thread createTP((1266, 6631, 2824), (-3295, 19658, 1870.13), undefined);
            thread createTP((-1235, 7429, 2776), (-3295, 19658, 1870.13), undefined);
            thread createTP((-1279, 6310, 2776), (-3295, 19658, 1870.13), undefined);
            thread createTP((-2774, 6923, 2776), (-3295, 19658, 1870.13), undefined);

            thread createHiddenTP((101, 20074, 1870.13),(-298, 5631, 2912.13), undefined);

            thread cannonball((-2538, 20100, 2059), (0,0,0), (500,0,900), 3, (-1107, 20096, 1930), 900);

            Deathradius((584, 19675, -2921), 4500, 4500);

            thread CreateDoors((-1400, 19850, 1925) /*open*/,(-1400, 20100, 1925) /*close*/, (90,0,0) /*angle*/, 5 /*size*/, 1 /*height*/, 20 /*hp*/, 110 /*range*/);

            level.lowspawnoverwriteheight = 1800;

        break;
        case "mp_vacant":
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

            thread createPolygon();

            thread CreateWalls((-5533, -7030, -90),(-5533, -6750, 50));
            thread CreateWalls((-5533, -6670, -90),(-5533, -6385, 50));

            thread CreateWalls((-5324, -6319, -70),(-5491, -6319, -40));

            thread CreateElevator((-5088, -6653, -106),(-5483, -6653, -106), 215, 1.25);

            thread CreateGrids((-5740, -6310, 77),(-5740, -5860, 77), (0,0,0));

            thread CreateRamps((-5780, -5875, 77),(-5995, -5875, 154));

            thread CreateElevator((-6119, -5905, 166),(-6293, -5905, 166), 191, 1.25);

            thread CreateInvisWalls((-3400, -7650, 120),(-3700, -7950, 175));

            thread CreateGrids((-4220, -6965, 77),(-4220, -6715, 77), (0,0,0));
            thread CreateWalls((-4665, -6820, 95),(-4665, -6640, 210));

            thread CreateGrids((-5760, -6960, 175),(-5760, -6718, 175), (0,0,0));

            thread cannonball((-4664, -7026, 70), (0,0,0), (-620,0,870), 3, (-5917, -7042, 432.125), 900);

            thread createDeathRegion((-4265, -5585, -140),(-2775, -8710, 80));

            thread createTP((-797, -285, -48),(-5666, -7004, -91.875), (0,90,0));
            thread createTP((952, 570, -48),(-5666, -7004, -91.875), (0,90,0));
            thread createTP((-14, -79, -48),(-5666, -7004, -91.875), (0,90,0));
            thread createTP((-781, -1358, -103),(-5666, -7004, -91.875), (0,90,0));
            thread createTP((1604, -910, -48),(-5666, -7004, -91.875), (0,90,0));
            thread createTP((-1629, 967, -94),(-5666, -7004, -91.875), (0,90,0));

            thread createHiddenTP((-7340, -5683, 180),(1292, -940, 48), undefined , "out");

            thread moveac130position((-5300, -6700, 1000));

            thread CreateDoors((-5400, -6319, -40) /*open*/,(-5162, -6319, -40) /*close*/, (90,90,0) /*angle*/, 7 /*size*/, 1 /*height*/, 20 /*hp*/, 110 /*range*/);
        break;
        case "mp_lockout_h2":
            mantles = getentarray( "mantle", "targetname" );
            mantlecoll = mantles[0];

            thread CreateGrids((3600, 3225, 3305),(3600, 3585, 3305), (0,0,0));
            thread CreateGrids((3380, 3620, 3305),(3790, 3690, 3305), (0,0,0));

            thread CreateGrids((3474, 3620, 3415),(3850, 3740, 3415), (0,0,0));
			thread CreateWalls((3533, 3690, 3325),(3533, 3690, 3405));
			thread createTP((3751.86, 3842.73, 2640),(3414.31, 4500.98, 3652), (0,270,0), undefined, undefined, undefined,480);
			thread createTP((2825.86, 3305, 2865),(3414.31, 4500.98, 3652), (0,270,0), undefined, undefined, undefined,480);

            thread CreateRamps((3380, 3715, 3302),(3380, 4225, 3611));
            thread spawncrate((3430, 4253, 3625), (0,0,0), "com_plasticcase_friendly");
			thread spawncrate((3380, 4253, 3625), (0,0,0), "com_plasticcase_friendly");

            thread spawncrate((3480, 4281, 3625),(0,45,0), "com_plasticcase_friendly");

            thread CreateWalls((3510, 4520, 3650),(3510, 4380, 3750));
            thread CreateGrids((3495, 4520, 3763),(3345, 4380, 3763), (0,0,0));

            thread CreateRamps((3512, 4320, 3627),(4308, 4320, 3808));
            thread CreateGrids((4350, 4060, 3817),(4405, 4330, 3817), (0,0,0));
            
            thread CreateRamps((4556, 3995, 3820),(4749, 3995, 3900));
            thread CreateRamps((4555, 3680, 3820),(4761, 3680, 3900));

            thread CreateGrids((3059, 3125, 2901),(3202, 3175, 2901), (0,0,0));
            thread CreateQuicksteps((3280, 3150, 3353), 452, 18, 2, (0,180,0));
            thread clonedcollision((3024, 3118, 2916.13), (0,90,0), mantlecoll);
            thread clonedcollision((3024, 3184, 2916.13), (0,90,0), mantlecoll);
            thread clonedcollision((3129, 3072, 3172.13), (0,0,0), mantlecoll);
            thread clonedcollision((3191, 3072, 3172.13), (0,0,0), mantlecoll);
            thread clonedcollision((3256, 3072, 3172.13), (0,0,0), mantlecoll);
            thread CreateDoors((4515, 4050, 3885) /*open*/,(4377, 4110, 3885) /*close*/, (90,90,0) /*angle*/, 7 /*size*/, 1 /*height*/, 15 /*hp*/, 80 /*range*/);
            level.ac130.angles = (45,0,0);
            thread CreateQuicksteps((3765, 3700, 3305), 198, 18, 2, (0,90,0));
	    thread CreateGrids((3333, 3268, 3447),(3567, 3118, 3447), (0,0,0));
			
			thread clonedcollision((4587, 3935, 3834.13), (0,270,0), mantlecoll);
			thread CreateRamps((4638, 4016, 3765),(4639, 3663, 3765));
			thread CreateRamps((3428, 4117, 3275),(3428, 3707, 3304.13));
			thread CreateWalls((3322, 3237, 3365.13),(3416, 3233, 3460.13));
        	break;
        case "mp_derail":
            level.meat_playable_bounds =
            [
                (3660, 3864, 399.625),
                (3662, 3596, 399.625),
                (4425, 3599, 399.625),
                (4433, 4869, 396.825),
                (4200, 4864, 339.148),
                (2755, 5174, 555.483),
                (1119, 5182, 570.423),
                (1133, 4491, 626.306),
                (3028, 4503, 193.762),
                (3036, 3859, 233.91)
            ];
            thread createPolygon();
            //Broken fence blocker
            thread CreateWalls((3457, 3876, 85),(3641, 3876, 160));
            //Start Ramp
            thread CreateRamps((3590, 4554, 77),(3373, 4554, 130));
            thread CreateRamps((3333, 4554, 137),(3038, 4554, 195));
            //Grid ramp
            thread CreateGrids((3010, 4720, 218),(3010, 4620, 218), (-25,0,0));
            //Wall Blocker
            thread CreateWalls((2600, 4788, 220),(2600, 4519, 220));
            thread CreateWalls((2600, 4788, 280),(2600, 4519, 280));
            //Quickstep to container
            thread CreateQuicksteps((4365, 3715, 432), 160, 18, 2, (0,90,0));
            //Container Gap Fillers
            thread spawncrate((4126, 3655, 432), (0, -90, 0), "com_plasticcase_friendly");
            thread spawncrate((3822, 3657, 432), (0, -90, 0), "com_plasticcase_friendly");
            thread spawncrate((3746, 4159, 432), (0, -180, 0), "com_plasticcase_friendly");
            //Long wall by containers
            //CreateWalls((4434, 3612, 430),(4434, 4870, 430));
            thread CreateWalls((4434, 3612, 370),(4434, 4870, 370));
            thread CreateWalls((4434, 3720, 310),(4434, 4870, 310));
            thread CreateWalls((4434, 4110, 250),(4434, 4870, 250));
            //Short wall
            //CreateWalls((4219, 4867, 370),(4403, 4867, 370));
            thread CreateWalls((4219, 4867, 310),(4403, 4867, 310));
            thread CreateWalls((4219, 4867, 250),(4403, 4867, 250));
            //Death barrier behind double wall
            thread CreateDeathRegion((2575, 4852, 180), (1150, 4488, 450));
            thread CreateDeathRegion((4219, 4897, 258.125), (-41, 6205, 500.449));
            //Wall on top of container near player cannons
            thread CreateWalls((3680, 4190, 455),(3680, 4430, 530));
            //Roof wall
            thread CreateWalls((2453, 4920, 600),(2453, 5180, 680));
            //Player cannons
            thread cannonball((3825, 4418, 432), (0,0,0), (-620,0,870), 1, (2575, 5115, 670), 150);
            thread cannonball((3825, 4348, 432), (0,0,0), (-620,0,870), 1, (2575, 5039, 670), 150);
            thread cannonball((3825, 4278, 432), (0,0,0), (-620,0,870), 1, (2575, 4990, 670), 150);
            thread cannonball((3825, 4208, 432), (0,0,0), (-620,0,870), 1, (2575, 4939, 670), 150);
            //bunker walls
            thread CreateWalls((1420, 5157, 600),(1155, 5157, 780));
            thread CreateWalls((1420, 4831, 600),(1155, 4831, 780));
            thread CreateWalls((1155, 4860, 600),(1155, 5126, 780));
            //Upper bunker floor
            thread CreateGrids((1409, 4864, 695),(1249, 5124, 695), (0,0,0));
            //upper bunker front wall
            thread CreateWalls((1417, 4860, 715),(1417, 5126, 715));
            //bunker doors
            thread CreateDoors((1280, 4993, 602) /*open*/, (1420, 4993, 602) /*close*/, (90,0,0) /*angle*/, 2 /*size*/, 2 /*height*/, 25 /*hp*/, 95 /*range*/);
            //door walls
            thread CreateWalls((1420, 4946, 600),(1420, 4860, 600));
            thread CreateWalls((1420, 5039, 600),(1420, 5126, 600));
            thread CreateWalls((1420, 4946, 655),(1420, 4860, 655));
            thread CreateWalls((1420, 5039, 655),(1420, 5126, 655));
            //Turrets
            thread createTurret((1419, 5082, 625), (0,0,0), 25, 40, undefined, 10);
            thread createTurret((1422, 4903, 625), (0,0,0), 25, 40, undefined, 10);
            thread createTurret((1411, 4993, 745), (0,0,0), 25, 40, undefined, 10);
            //Bunker quicksteps
            thread CreateQuicksteps((1192, 4863, 695), 120, 18, 2, (0,90,0));
            thread CreateQuicksteps((1192, 5124, 695), 120, 18, 2, (0,270,0));
            thread CreateQuicksteps((3448, 4450, 61), 120, 18, 2, (0,180,0));
            //TPS
            thread createTP((268, 764, 112.123), (3583, 3987, 94.9783), (0, 50, 0),undefined);
            thread createTP((-2214, 1528, 28.7465), (3344, 4446, -15.875), (0, 50, 0),undefined);
            thread createTP((-894, -3100, 100.078), (3583, 3987, 94.9783), (0, 30, 0),undefined);
            thread createTP((2325, 2199, 142.125), (3344, 4446, -15.875), (0, 15, 0),undefined);
            thread createTP((557, 2872, 126.211), (3583, 3987, 94.9783), (0, 15, 0),undefined);
            thread createTP((-215, -1960, 117.383), (3344, 4446, -15.875), (0, 30, 0),undefined);
            thread createTP((2429, -1920, 42.2997), (3344, 4446, -15.875), (0, 30, 0),undefined);
            thread createHiddenTP((1198, 4992, 780), (111, 1013, 593.823), (0, 180, 0), "out");
            break;
			
			case "mp_checkpoint":
			
				ents = getEntArray();
			for ( index = 0; index < ents.size; index++ ) 
			{
				if(isSubStr(ents[index].classname, "trigger_hurt"))
				ents[index].origin = (99999999, 999999, 9999999);
			}
			
			
			classicents = GetEntArray("classicinf", "targetname");
            foreach(ent in classicents)
                ent delete();
			
			
			rnd = randomint(2);
            if(rnd == 0)
            {
			
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
			
			 thread createPolygon();
			 
			 
			
             //oom block
			 thread spawncrate((-117, -12, 415), (90, 90, 90), "com_plasticcase_friendly");
			 thread spawncrate((-110, -128, 390), (90, 90, 90), "com_plasticcase_friendly");
			
			 thread spawncrate((6269, 1254, -63), (0, 135, 0), "com_plasticcase_friendly");
			 thread spawncrate((6290, 1275, -63), (0, 135, 0), "com_plasticcase_friendly");
			 thread spawncrate((6311, 1296, -63), (0, 135, 0), "com_plasticcase_friendly");
			 thread spawncrate((6250, 1235, -78), (0, 315, 35), "com_plasticcase_friendly");
			 thread spawncrate((6330, 1315, -78), (0, 135, 35), "com_plasticcase_friendly");
			 
			 thread CreateWalls((7475, 1817, -50),(7475, 1495, -50));
			 thread CreateWalls((7475, 1817, -111),(7475, 1495, -111));
			 
			 thread CreateWalls((4844, -961, -185),(4588, -705, -185));
			 thread CreateWalls((4844, -961, -125),(4480, -594, -125));
			 thread CreateWalls((4844, -961, -65),(4480, -594, -65));
			 thread CreateWalls((4844, -961, -5),(4480, -594, -5));
			 thread CreateWalls((4844, -961, 60),(4243, -357, 60));
			 
			 
			 thread CreateWalls((4864, -980, 30),(5020, -1142, 30));
			 thread CreateWalls((5659, -514, 30),(5049, -1125, 30));
			 
			thread CreateWalls((5659, -514, 60),(5467, -706.5, 60));
			 thread CreateWalls((4221, -336, 60),(4107, -1086, 60));
			 
			 thread spawncrate((6219, 1358, 58), (0, 45, 0));
			 thread spawncrate((6159, 1298, 58), (0, 45, 0));
			 thread spawncrate((6099, 1238, 58), (0, 45, 0));
			 thread spawncrate((6039, 1178, 58), (0, 45, 0));
			 thread spawncrate((5979, 1118, 58), (0, 45, 0));
			 thread spawncrate((5919, 1058, 58), (0, 45, 0));
			 thread spawncrate((5859, 998, 58), (0, 45, 0));
			 thread spawncrate((5799, 938, 58), (0, 45, 0));
			 thread spawncrate((5739, 878, 58), (0, 45, 0));
			 thread spawncrate((5710, 849, 58), (0, 45, 0));
			 
			 //pipe bridge
			 
			 thread spawncrate((6328, 1416, 26), (0, 135, 0));
			 thread spawncrate((6388.7, 1355, 26), (0, 135, 0));
			 thread spawncrate((6449.4, 1294, 26), (0, 135, 0));
			 thread spawncrate((6510.1, 1233, 26), (0, 135, 0));
			 thread spawncrate((6570.8, 1172, 26), (0, 135, 0));
			 thread spawncrate((6631.5, 1111, 26), (0, 135, 0));
			 thread spawncrate((6692.2, 1050, 26), (0, 135, 0));
			 thread spawncrate((6752.9, 989, 26), (0, 135, 0));
			 thread spawncrate((6813.6, 928, 26), (0, 135, 0));
			 thread spawncrate((6874.3, 867, 26), (0, 135, 0));
			 thread spawncrate((6935, 806, 26), (0, 135, 0));
			 
			 thread CreateRamps((7139, 1028, -70),(6947, 833, 17));
			 
			 
			 //fence block
				  
			thread spawncrate((7424, 1246, 60), (0, 45, 0));
			thread spawncrate((7362, 1184, 60), (0, 45, 0));
			thread spawncrate((7300, 1122, 60), (0, 45, 0));
			thread spawncrate((7238, 1060, 60), (0, 45, 0));
			thread spawncrate((7176, 998, 60), (0, 45, 0));
			thread spawncrate((7114, 936, 60), (0, 45, 0));
			thread spawncrate((7114, 936, 120), (0, 45, 0));
			
			thread spawncrate((7052, 874, 60), (0, 45, 0));
			thread spawncrate((7052, 874, 20), (0, 45, 0));
			thread spawncrate((7052, 874, 120), (0, 45, 0));
			
			
			thread spawncrate((6990, 812, 60), (0, 45, 0));
			thread spawncrate((6990, 812, 120), (0, 45, 0));
			thread spawncrate((6928, 750, 60), (0, 45, 0));
			thread spawncrate((6928, 750, 120), (0, 45, 0));
			thread spawncrate((6866, 688, 60), (0, 45, 0));
			thread spawncrate((6866, 6988, 120), (0, 45, 0));
			thread spawncrate((6804, 626, 60), (0, 45, 0));
			thread spawncrate((6742, 564, 60), (0, 45, 0));
			thread spawncrate((6680, 502, 60), (0, 45, 0));
			thread spawncrate((6618, 440, 60), (0, 45, 0));
			thread spawncrate((6556, 378, 60), (0, 45, 0));
			thread spawncrate((6494, 316, 60), (0, 45, 0));
			thread spawncrate((6432, 254, 60), (0, 45, 0));
			thread spawncrate((6370, 192, 60), (0, 45, 0));
			
			thread spawncrate((6306, 132, 50), (0, 45, 0));
			 thread CreateWalls((6274.82, 101, 30),(5903, -272, 108));
			
			//barbed wire
		
		    	ent = spawn("script_model", (5688, -522,  33));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_razorwire_long_static");	
			thread spawncrate((5872, -302, 70), (0, 45, 0));
			thread spawncrate((5812, -362, 70), (0, 45, 0));
			thread spawncrate((5752, -422, 70), (0, 45, 0));
			thread spawncrate((5692, -482, 70), (0, 45, 0));
			

			
			
			//brick wall
			 thread spawncrate((6519, 1648, 85), (0, 0, 0));
			 thread spawncrate((6435, 1648, 85), (0, 0, 0));
			 thread spawncrate((6351, 1647, 85), (0, 0, 0));
			 thread spawncrate((6267, 1647, 85), (0, 0, 0));
			 thread spawncrate((6183, 1647, 85), (0, 0, 0));
			 thread spawncrate((6099, 1647, 85), (0, 0, 0));
			 thread spawncrate((6015, 1647, 85), (0, 0, 0));
			 
			 
			 thread CreateQuicksteps((4522, -563, -65), 100, 16, 2, (0, 0,0));	
			 
			 //big bridge
			 thread CreateWalls((5600, -552, 8),(4355, 30, 8));
			 thread CreateWalls((5642, -507.6, 8),(4397, 74.4, 8));
			 thread CreateWalls((5684, -463.2, 8),(4439, 118.8, 8));
			 
			 thread CreateWalls((5726, -418.8, 8),(4481, 163.2, 8));
			 thread CreateWalls((5768, -374.4, 8),(4523, 207.6, 8));
			 thread CreateWalls((5810, -330, 8),(4565, 252, 8));
			 
			  thread CreateWalls((5852, -285.6, 8),(4607, 296.4, 8));
			    thread CreateWalls((5852+48, -285.6+33.6, 8),(4607+48, 296.4+33.6, 8));
			 
	
			 
			 
			 thread CreateElevator((2993, -2074, 31),(3066, -2160, 31), 307, 3.0,(0,0,0));
			 thread CreateGrids((2960, -2054, 28),(3074, -2180, 28), (0,0,0));
			 
			 
			 
		     thread createTP((1502, -517, 5), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
			 thread createTP((-1462, -446, -11), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
			 thread createTP((391, -1413, -11), (6268, 1255.66, -155.875), (0, 320, 0),undefined);
			 thread createTP((2076, 1062, 41), (6268, 1255.66, -155.875), (0, 320, 0),undefined);
			 thread createTP((1803, 1524, 0), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
			 thread createTP((-745, 2043, 1), (6268, 1255.66, -155.875), (0, 320, 0),undefined);
			 thread createTP((299, -2577, 1), (7125.29, 1804.78, -121.9783), (0, 335, 0),undefined);
			 thread createTP((-2228, 141, 5), (6268, 1255.66, -155.875), (0, 320, 0),undefined);
			 
			 
			 //late game  flag
			 thread createTP((5433, 849, 42), (2985, -2516, 55), (0, 80, 0), undefined, undefined, undefined,500);
			 
			 
			 
			 thread createHiddenTP((3023, -2763, 370), (769, -1826, 20), (0, 180, 0), "out");
			 thread createHiddenTP((3023, -2763, 44), (769, -1826, 20), (0, 180, 0), "out");
			 thread createHiddenTP((3023, -2763, -160), (769, -1826, 20), (0, 180, 0), "out");
			 
			 //staircase block
			 thread spawncrate((3342, -2712, 293), (0, 0, 0), "com_plasticcase_friendly");
			 
			 //gate
			 
			 thread CreateDoors((5408, -81, -105) /*open*/, (5408, -81, -145) /*close*/, (90,66,0) /*angle*/, 4 /*size*/, 4 /*height*/, 20 /*hp*/, 220 /*range*/, true /*sideways*/);
			 
			 ent = spawn("script_model", (5210, -36, -160));
                ent.angles = (0, 153, 0);
           	    ent setmodel("vehicle_80s_sedan1_silvdest");	
				
				ent = spawn("script_model", (5210, -44, -110));
                ent.angles = (0, 320, 0);
           	    ent setmodel("vehicle_80s_hatch1_reddest");	
				
				ent = spawn("script_model", (5370, -39, -14));
                ent.angles = (0, 156, 0);
           	    ent setmodel("me_corrugated_metal8x8");	
				
					ent = spawn("script_model", (5277, 2, -24));
                ent.angles = (10, 156, 5);
           	    ent setmodel("me_corrugated_metal8x8");	
				
					ent = spawn("script_model", (5498, -99, -25));
                ent.angles = (350, 156, 0);
           	    ent setmodel("me_corrugated_metal8x8");	
				
				ent = spawn("script_model", (5427, -64, -25));
                ent.angles = (344, 156, 0);
           	    ent setmodel("me_corrugated_metal4x8");	
				
				thread spawncrate((5157, 20, -119), (0, 155, 0));
				thread spawncrate((5210.8, -4, -119), (0, 155, 0));
				thread spawncrate((5254.6, -17.7, -119), (0, 155, 0));
				
				thread spawncrate((5112.6, -12.3, -119), (0, 155, 0));
				thread spawncrate((5192.1, -47.3, -119), (0, 155, 0));
				thread spawncrate((5251.7, -75, -119), (0, 155, 0));
				
				
				
				//otherside gate wall
				ent = spawn("script_model", (5570, -137, -97));
                ent.angles = (0, 156, 0);
           	    ent setmodel("me_corrugated_metal8x8");

              thread spawncrate((5554, -149, -120), (0, 156, 0));
			  thread spawncrate((5554, -149, -70), (0, 156, 0));
              thread spawncrate((5596, -167.6, -100), (0, 156, 0));				  
				
				
				
				//sanbags
				
				ent = spawn("script_model", (7123, 1750, -128));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_long");	
				
				ent = spawn("script_model", (7202, 1670, -128));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_short");	
				
				ent = spawn("script_model", (7244, 1630, -128));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_end_left");
					//
				ent = spawn("script_model", (7229, 1645, -98));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_end_left");
				
				ent = spawn("script_model", (7189, 1685, -98));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_short");
				
				ent = spawn("script_model", (7108, 1765, -98));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_long");	
			     	//
				ent = spawn("script_model", (7169, 1705, -68));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_end_left");
				
				ent = spawn("script_model", (7105, 1769, -68));
                ent.angles = (0, 45, 0);
           	    ent setmodel("mil_sandbag_desert_long");
				
			     thread spawncrate((7242, 1627, -112), (353, 135, 0)); 
				 thread spawncrate((7222, 1647, -80), (353, 135, 0));
				 thread spawncrate((7167, 1702, -58), (353, 135, 0)); 
				 thread spawncrate((7189, 1680, -112), (0, 135, 0)); 
				 thread spawncrate((7129, 1740, -94), (0, 135, 0)); 
				 thread spawncrate((7089, 1780, -94), (0, 135, 0)); 
				 thread spawncrate((7049, 1820, -53), (0, 135, 0));
				 thread spawncrate((7111, 1758, -53), (0, 135, 0)); 
		 
		 thread CreateWalls((4097, -1118, 10),(3531, -1987, 10));
		 thread CreateWalls((4097, -1118, 70),(3531, -1987, 70));
		 
		 
		 //backlot corrugated wall
		
		  thread spawncrate((2865, -2012, 70), (0, 345, 0));
		  thread spawncrate((2804, -1995.6, 70), (0, 345, 0));
		 
		 	ent = spawn("script_model", (2842, -1983, 70));
                ent.angles = (350, 345, 0);
           	    ent setmodel("me_corrugated_metal8x8");	

			thread CreateDoors((3408, -2017, 100) /*open*/, (3344, -2017, 100) /*close*/, (0,0,90) /*angle*/, 1 /*size*/, 1 /*height*/, 15 /*hp*/, 120 /*range*/, true /*sideways*/);
				
			thread spawncrate((3140, -2021.6, 95), (0, 0, 0));	
			thread spawncrate((3070, -2021.6, 95), (0, 0, 0));	
			thread spawncrate((2995, -2021.6, 95), (0, 0, 0));
		 
		 
		 thread CreateWalls((2745, -3212, 47),(3828, -3212, 47));
		 
		 
			}
		else if(rnd == 1)
            {
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
			
			 thread createPolygon();
			 
			 thread spawncrate((-117, -12, 415), (90, 90, 90), "com_plasticcase_friendly");
			 thread spawncrate((-110, -128, 390), (90, 90, 90), "com_plasticcase_friendly");
	
			thread spawncrate((2865, -2012, 70), (0, 345, 0));
			thread spawncrate((2804, -1995.6, 70), (0, 345, 0));
			ent = spawn("script_model", (2842, -1983, 70));
			ent.angles = (350, 345, 0);
			ent setmodel("me_corrugated_metal8x8");		
			
		   
			thread CreateWalls((2680, -1737, 20),(2680, -1942, 100));
			thread CreateInvisWalls((2680, -1737, 133),(2680, -2000, 133));
		   
			thread CreateInvisWalls((1860, -1709, 130),(2557, -1709, 130)); 		   
			 
			 
			thread CreateQuicksteps((1657, -1960, 77), 90, 16, 2, (0,90,0));	
			thread CreateQuicksteps((1657, -1962, 77), 70, 16, 2, (0,270,0));

			thread CreateQuicksteps((2536, -1949, 77), 70, 16, 2, (0,90,0));	

			thread createTurret((2277,-1770,71), (0,180,0), 25, 25, 3, 1);
			thread createTurret((2926,-2697.5,233), (0,180,0), 50, 50, 25, 9);


			thread CreateWalls((2902, -3181, 33),(1953, -3181, 33));
			thread CreateWalls((2902, -3181, 93),(1895, -3181, 93));	
			thread CreateWalls((2902, -3181, 153),(1895, -3181, 153));	
			thread CreateWalls((2902, -3181, 213),(1895, -3181, 213));	
			thread CreateWalls((2902, -3181, 273),(1895, -3181, 273));

			//backlot building walls

			thread CreateWalls((2927, -2053, 55),(2927, -2290, 177));
			thread CreateWalls((2927, -2450, 55),(2927, -2532, 177));
			thread CreateWalls((2927, -2692, 55),(2927, -2804, 55));	
			thread CreateWalls((2927, -2692, 127),(2927, -2804, 127));
			thread CreateWalls((3176, -3174, 55),(3498, -3174, 55));
			thread CreateWalls((3531, -3134, 55),(3531, -2872, 55));
			thread CreateWalls((2944, -2830, 220),(3177, -2830, 320));
			thread CreateWalls((3497, -2534, 75),(3497, -2054, 75));
			thread CreateInvisWalls((3343, -2009, 75),(3343, -2009, 75));
			thread CreateWalls((3176, -2022, 75),(2954, -2022, 75));
			
			thread CreateWalls((3497, -2534, 235),(3497, -2054, 235));
			thread CreateWalls((3466, -2020, 235),(3242, -2020, 235));
			
			thread CreateWalls((3208, -2805, 340),(3208, -2661, 340));
			thread CreateInvisWalls((3208, -2805, 410),(3208, -2661, 410));
			thread CreateWalls((3208, -2805, 480),(3208, -2661, 464));
			thread CreateWalls((3315, -2805, 480),(3315, -2661, 464));
			thread CreateWalls((3400, -2805, 480),(3400, -2661, 464));
			thread CreateWalls((3485, -2805, 480),(3485, -2661, 464));
			
			thread CreateInvisWalls((3179, -2566.76, 520),(3465, -2566.76, 520));
			thread CreateInvisWalls((3179, -2576.76, 600),(3527, -2575.76, 600));
			
			thread spawncrate((2921, -2566.76, 565), (90, 90, 90));
			thread spawncrate((2948, -2503.76, 530), (90, 90, 90));
			
			thread spawncrate((3480, -2690, 380), (0, 90, 0));
			thread spawncrate((3480, -2776, 380), (0, 90, 0));
			
			thread spawncrate((3398, -2689.76, 450), (0, 90, 0), "com_plasticcase_friendly");
			
			
			thread CreateGrids((3292, -3039, 155),(3172, -3110, 155), (0,0,0));
			thread CreateGrids((3184, -3108, 275),(3184, -2960, 275), (0,0,0));
			thread CreateQuicksteps((3238, -3136, 527), 375, 16, 2, (0,90,0));
			thread CreateRamps((3033, -2840, 385),(3033, -2740, 348));
			
			
			thread spawncrate((3340, -2692, 215), (0, 270, 32));
			thread spawncrate((3369, -2692, 235), (0, 270, 32));
			thread spawncrate((3393, -2692, 250), (0, 270, 32));
			thread spawncrate((3440, -2690, 270), (0,0,0));
			
			

            thread spawncrate((3010, -2838, 149), (0, 0, 0), "com_plasticcase_friendly");
			thread spawncrate((3530, -2903, 119), (0, 90, 0));
			thread spawncrate((2892, -2838, 251), (90, 0, 0));
			
			thread CreateDoors((2926.72,-3065.705,120) /*open*/, (2926.72,-3065.705,60) /*close*/, (90,0,0) /*angle*/, 3 /*size*/, 2 /*height*/, 30 /*hp*/, 90 /*range*/, true /*sideways*/);
			thread CreateDoors((3060.72,-2838.705,70) /*open*/, (3127.72,-2838.705,70) /*close*/, (90,90,0) /*angle*/, 1 /*size*/, 2 /*height*/, 20 /*hp*/, 50 /*range*/, true /*sideways*/);
			thread CreateDoors((3160.22,-2558.705,390) /*open*/, (3261.22,-2558.705,390) /*close*/, (90,90,0) /*angle*/, 1 /*size*/, 2 /*height*/, 15 /*hp*/, 50 /*range*/, true /*sideways*/);

			
			thread CreateGrids((2960, -2054, 28),(3084, -2180, 28), (0,0,0));			
			 	

			thread CreateQuicksteps((3387, -2783, -20), 190, 16, 2, (0,0,0));	

			 thread createTP((1502, -517, 5), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
			 thread createTP((-1462, -446, -11), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
			 thread createTP((391, -1413, -11), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
			 thread createTP((2076, 1062, 41), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
			 thread createTP((1803, 1524, 0), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
			 thread createTP((-745, 2043, 1), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
			 thread createTP((299, -2577, 1), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
			 thread createTP((-2228, 141, 5), (704, -3228.5, 40.9783), (0, 45, 0),undefined);
			 thread createTP((-675, 810, -3), (1041.69, -1775.04, 35.9783), (0, 10, 0),undefined);
			thread createHiddenTP((3017, -2117, 90), (746, 2290, 30), (0, 190, 0), "out");
			thread fufalldamage((3242, -2989, 33),300, 600);
			thread fufalldamage((3910, -3509, 44),20, 600);
			thread CreateDeathRegion((3527, -1810, 37), (4123, -2831, 10));
			thread CreateDeathRegion((3560, -2831, 37), (4123, -3830, -338));
			thread CreateDeathRegion((4123, -3830, -338), (1897, -3211, 37));
			thread CreateDeathRegion((4123, -3830, -338), (2718, -3038, -200));
			
			thread spawncrate((3913, -3512, 26), (80, 0, 0), "com_plasticcase_trap_friendly");
			thread spawncrate((3625, -3635, 46), (80, 30, 0), "com_plasticcase_trap_friendly");
			thread spawncrate((3276, -3723, 46), (74, 60, 0), "com_plasticcase_trap_friendly");
			
			ent = spawn("script_model", (3618, -3638, 70));
			ent.angles = (0, 120, 350);
			ent setmodel("mp_fullbody_ally_juggernaut");
			
			thread moveac130position((1745, -1807, 3000));
			 
			 }
			break;
			
			
    }

	if(!isdefined(level.lowest_crate)) {
		ents = getentarray("tpjug", "targetname");
		
		if(isdefined(ents)) {
			level.lowest_crate = ents[0].origin[2];
			
			for(i = 0;i < ents.size;i++) {
				if(ents[i].origin[2] < level.lowest_crate)
					level.lowest_crate = ents[i].origin[2];
			}
		}
	}

    if(!isdefined(rnd))
        print("^1No ^6Random Map Edit On Map: ^1" + level.mapname);
    else
        print("^6Edit ^1" + rnd + "^6 Picked On Map: ^1" + level.mapname);
}



