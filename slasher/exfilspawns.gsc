#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()  {
    map = getDvar("mapname");
    num = randomint(3);
    level.flytohigher = (0,0,600);

    if (map == "mp_rust") {
        num = randomint(6);
        
        level.nukepos = (704.797, 933.231, 418.125);
        
        if(num == 0)
            HeliSpawns((-10837,490,2279),(-388,927,-130));
        else if(num == 1)
            HeliSpawns((-4973,-4756,1651),(-349,-97,-229));
        else if(num == 2)
            HeliSpawns((8081,-1871,1200),(1563,914,-130));
        else if(num == 3)
            HeliSpawns((-4637,11309,1827),(657,1021,268));
        else if(num == 4)
            HeliSpawns((9186,10087,3459),(1501,1670,-200));
        else if(num == 5)
            HeliSpawns((9046,8781,2052),(329,1268,-226));
    }
    else if (map == "mp_meteora") {
    	num = randomint(5);
    	 
        level.nukepos = (-90, 1077, 1732);
        
        if(num == 0)
             HeliSpawns((2166.5, -3221.43, 2138.08),(-1012.61, -845.928, 1605.55));
        else if(num == 1)
			 HeliSpawns((1652.4, -3703.63, 2312.69),(1867.67, -420.491, 1588.2));
        else if(num == 2)
			 HeliSpawns((439.395, 5926, 2080.96),(-491.907, 2919.17, 1571.15));
		else if(num == 3)
			 HeliSpawns((-3733.25, -1450.61, 2261.98),(-1747.07, 925.362, 1548.41));
		else if(num == 4)
			 HeliSpawns((1577.86, 6363.66, 2045.13),(835.6, 3382.76, 1607.12));
	}
    else if (map == "mp_moab") {
    	num = randomint(3);
    	 
        level.nukepos = (-553.834, 257.465, 219.674);
        
        if(num == 0)
             HeliSpawns((-3854.21, -3990.48, 696.634),(-1286.31, -1281.56, -85.0237));
        else if(num == 1)
			 HeliSpawns((-5071.23, -519.048, 845.013),(-1906.49, 251.53, 137.375));
        else if(num == 2)
			 HeliSpawns((1288.61, -3215.39, 1462.65),(-553.834, 257.465, 219.674));
	}
	else if (map == "mp_overwatch") {
    	 num = randomint(3);
    	 
        level.nukepos = (-0.451965, -3.76143, 12836.1);
        
        if(num == 0)
             HeliSpawns((1604.73, -4798.09, 13257.3),(1178.03, -953.177, 12683.1));
        else if(num == 1)
			 HeliSpawns((4764.78, 620, 13349.2),(1234.09, 770.92, 12681.1));
        else if(num == 2)
			 HeliSpawns((-2957.55, 4154.56, 13187.3),(-866.574, 1947.57, 12683.1));
	}
    else if (map == "mp_seatown") {
    	 num = randomint(6);
    	 
        level.nukepos = (-211,-230,510);
        
        if(num == 0)
             HeliSpawns((-1331,8268,2027),(1080,990,170));
        else if(num == 1)
			 HeliSpawns((-2644,12478,1679),(-1105,1438,240));
        else if(num == 2)
			 HeliSpawns((-9965,-680,1379),(-2283,-291,193));
        else if(num == 3)
			 HeliSpawns((5188,-6057,1885),(-1303,-1491,144));
        else if(num == 4)
			 HeliSpawns((-6291,-5124,2226),(1162,-760,232));
        else if(num == 5)
			 HeliSpawns((-754,-8531,2240),(-671,-209,176));
	}
    else if (map == "mp_dome") {
    	num = randomint(7);
    	
        level.nukepos = (105,-41,795);
        
        if(num == 0)
            HeliSpawns((-1780,-9108,1586),(739,-506,-386));
        else if(num == 1)
            HeliSpawns((11644,-449,1900),(1594,780,-308));
        else if(num == 2)
            HeliSpawns((-9063,6274,1891),(2,2099,-291));
        else if(num == 3)
            HeliSpawns((-9900,2215,1495),(-1243,1216,-436));
        else if(num == 4)
            HeliSpawns((-8268,-7052,2066),(-606,114,-410));
        else if(num == 5)
            HeliSpawns((11460,723,999),(672,1726,-240),(-95,90,0));
        else if(num == 6)
            HeliSpawns((8274,-8051,1710),(590,1020,-307));
	}
	/*else if (map == "mp_plaza2") { 
        level.nukepos = (-1087,82,1308);
        if(num == 0){
            HeliSpawns((9804,-8022,3181),(864,-1822,855));
        } else if(num == 1){
            HeliSpawns((2929,9880,2522),(-1386,1423,1015));
        } else if(num == 2){
            HeliSpawns((-9859,-7187,3189),(222,30,1027));
        }
    }*/
	else if (map == "mp_alpha") {
		num = randomint(6);
		
        level.nukepos = (-1026,1076,932);
        
        if(num == 0) {
            HeliSpawns((-10876,820,2161),(-1103,632,0));
            level.flytohigher = (0,0,1000);
        } 
        else if(num == 1) {
            HeliSpawns((-9933,-183,1711),(-1695,-222,0));
            level.flytohigher = (0,0,900);
        } 
        else if(num == 2) {
           HeliSpawns((7301,-7218,2345),(640,-370,-8));
           level.flytohigher = (0,0,800);
        } 
        else if(num == 3) {
           HeliSpawns((-768,-8736,3886),(29,2181,-8));
           level.flytohigher = (0,0,900);
        } 
        else if(num == 4) {
           HeliSpawns((-9843,2525,2279),(-1425,1830,136));
           level.flytohigher = (0,-100,700);
        } 
        else if(num == 5) {
           HeliSpawns((-1567,10659,5328),(-1484,2724,123));
           level.flytohigher = (0,0,700);
        }
	}
    else if (map == "mp_mogadishu") {
        num = randomint(8);
        
        level.nukepos = (-447,2169,886);
        
        if(num == 0)
            HeliSpawns((9038,8864,3551),(2431,1922,6),(-95,180,0));
        else if(num == 1)
            HeliSpawns((11841,1374,3110),(1652,-294,-48));
        else if(num == 2)
            HeliSpawns((4279,-9604,2645),(-43,-1013,-44));
        else if(num == 3) {
            HeliSpawns((-3969,-203,4090),(-677,1611,-18),(-98,90,0));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 4)
            HeliSpawns((-10129,3137,3348),(-889,2618,90),(-97,0,0));
        else if(num == 5)
            HeliSpawns((7562,816,2249),(694,2385,44),(-95,120,0));
        else if(num == 6)
            HeliSpawns((7934,-6341,2406),(869,-541,-43));
        else if(num == 7)
            HeliSpawns((39,8453,3712),(154,769,-41));
    }
	else if (map == "mp_bootleg") {
        num = randomint(8);
        
        level.nukepos = (-1212,-555,546);
        
        if(num == 0) {
            HeliSpawns((-7332,2720,1808),(176,-2060,8));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 1)
            HeliSpawns((9729,-1227,2613),(1039,-1114,-65));
        else if(num == 2) {
            HeliSpawns((6620,1066,6391),(958,1168,-88));
            level.flytohigher = (0,0,750);
        } 
        else if(num == 3) {
            HeliSpawns((-8772,1514,2636),(-1185,1517,-95));
            level.flytohigher = (0,0,750);
        } 
        else if(num == 4)
            HeliSpawns((8396,4681,3458),(-1744,-1369,10));
        else if(num == 5) {
            HeliSpawns((-3971,-4349,9278),(-419,63,-68));
            level.flytohigher = (0,0,900);
        } 
        else if(num == 6) {
            HeliSpawns((-9,8325,3097),(-531,620,-70),(-87,0,0));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 7)
            HeliSpawns((-7759,6204,2632),(-1985,-422,65),(-95,0,0));
    }
	else if (map == "mp_bravo") {
		num = randomint(7);
		
        level.nukepos = (-696,161,1698);
       
       if(num == 0)
            HeliSpawns((-6543,-8657,4573),(-1546,-405,960),(-97,0,0));
        else if(num == 1)
            HeliSpawns((-9213,1116,3391),(-2020,1060,1098),(-80,-100,0));
        else if(num == 2) {
            HeliSpawns((7597,-6889,4014),(669,896,1132),(-98,0,0));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 3)
            HeliSpawns((9524,-859,4631),(1805,-595,1169),(-90,0,0));
        else if(num == 4)
            HeliSpawns((-5240,-3020,4225),(-89,-1013,979));
        else if(num == 5)
            HeliSpawns((-4868,8439,4686),(912,468,1197));
        else if(num == 6)
            HeliSpawns((-234,-6360,4533),(-94,-165,1223));
    }
	else if (map == "mp_carbon") {
		num = randomint(8);
		
        level.nukepos = (-2329,-3755,4091);
        
        if(num == 0)
            HeliSpawns((-3444,-10437,6487),(-1575,-4374,3861));
        else if(num == 1)
            HeliSpawns((-9475,-5080,5391),(-3078,-4983,3607),(-83,100,0));
        else if(num == 2)
            HeliSpawns((-9098,3760,5853),(-3248,-3331,3580));
        else if(num == 3)
            HeliSpawns((1283,7013,7912),(-77,-2854,3943),(-85,-90,0));
        else if(num == 4)
            HeliSpawns((-4590,-10375,5810),(-236,-4908,3917));
        else if(num == 5)
            HeliSpawns((-8787,3410,7322),(267,-3828,3925),(-85,180,0));
        else if(num == 6)
            HeliSpawns((6155,4397,8292),(-2235,-3666,3918));
        else if(num == 7)
            HeliSpawns((-11517,-2233,5276),(-3868,-3810,3578));
    }
	/*else if (map == "mp_exchange"){                ////crashes////
        level.nukepos = (-138,143,1275);
        if(num == 0){
            HeliSpawns((10155,1787,1493),(9975,1619,1419));
        } else if(num == 1){
           HeliSpawns((2503,1337,410),(-9468,846,2113));
        } else if(num == 2){
            HeliSpawns((-1191,-818,272),(6249,-9547,5302));
        }
    }*/
	else if (map == "mp_hardhat") {
        num = randomint(8);
        
        level.nukepos = (18,-524,1839);
        
        if(num == 0)
            HeliSpawns((-8209,10068,6425),(-23,1107,379));
        else if(num == 1)
            HeliSpawns((-9295,-630,4919),(-960,-980,302),(-93,-120,0));
        else if(num == 2) {
            HeliSpawns((-7271,-6578,5295),(-339,-1491,298),(-93,90,0));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 3)
            HeliSpawns((1360,-9407,3292),(1924,-1488,310));
        else if(num == 4)
            HeliSpawns((10770,-1396,4318),(2142,262,327));
        else if(num == 5)
            HeliSpawns((465,10159,6049),(1699,1268,310),(-92,90,0));
        else if(num == 6) {
            HeliSpawns((-5645,9751,5594),(-41,-211,296),(-94,-90,0));
            level.flytohigher = (0,0,1100);
        } 
        else if(num == 7) {
            HeliSpawns((9700,-1669,2730),(900,-878,303),(-95,0,0));
            level.flytohigher = (0,0,1000);
        }
    }
	/*else if (map == "mp_interchange"){ ////////////crashes
        level.nukepos = (305,-715,628);
        if(num == 0){
			HeliSpawns((2855,9929,797),(-2,1907,361)); // done
        } else if(num == 1){
			HeliSpawns((-4756,-9996,1277),(428,-2201,478)); // done
        } else if(num == 2){
            HeliSpawns((9863,-832,1076),(2479,-372,468)); // done
        }
    }*/
	else if (map == "mp_lambeth") {
		num = randomint(11);
		
        level.nukepos = (792,-988,828);
        
        if(num == 0)
            HeliSpawns((9018,9554,3947),(2847,1105,-320));
        else if(num == 1)
            HeliSpawns((5072,10928,3162),(1264,2707,-269));
        else if(num == 2)
            HeliSpawns((-10114,9254,3548),(-1181,1327,-252));
        else if(num == 3)
            HeliSpawns((-9810,-9262,4186),(-1159,-828,-191));
        else if(num == 4)
            HeliSpawns((-1943,-7534,1862),(-345,-1400,-235),(-92,180,0));
        else if(num == 5)
            HeliSpawns((9394,-9288,3732),(1810,-1207,-248));
        else if(num == 6)
            HeliSpawns((3480,-9396,2580),(2797,-546,-260));
        else if(num == 7)
            HeliSpawns((6008,-10081,2035),(1947,-290,-254),(-93,-20,0));
        else if(num == 8)
            HeliSpawns((7911,-1017,4481),(133,130,-234));
        else if(num == 9)
            HeliSpawns((7297,9455,2120),(1229,720,-120));
        else if(num == 10)
            HeliSpawns((-5052,8749,1849),(216,2851,-237));
    }
	else if (map == "mp_paris") {
		num = randomint(9);
		
        level.nukepos = (-551,930,1268);
        
        if(num == 0) {
            HeliSpawns((-4235,-8158,4729),(678,-935,112));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 1) {
            HeliSpawns((-995,-9060,2967),(-955,-1002,52));
            level.flytohigher = (0,0,1000);
        } 
        else if(num == 2) {
            HeliSpawns((-9932,-1845,4741),(-2123,5,192));
            level.flytohigher = (0,0,1000);
        } 
        else if(num == 3) {
            HeliSpawns((-6692,8826,4685),(-1747,1587,256),(-88,0,0));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 4) {
            HeliSpawns((7901,3505,3679),(766,2189,-16));
            level.flytohigher = (0,0,900);
        } 
        else if(num == 5)
            HeliSpawns((8176,-4166,3427),(1773,83,114));
        else if(num == 6) {
            HeliSpawns((-9031,5548,5269),(-788,158,59));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 7)
            HeliSpawns((10094,1839,4081),(1584,1795,-6));
    }
	/*else if (map == "mp_radar"){ /////////////////// crashes
        level.nukepos = (-5819,2031,2297);
        if(num == 0){
            HeliSpawns((6411,348,1959),(-3846,825,1591));
        } else if(num == 1){
           HeliSpawns((-7,6930,2365),(-5675,2855,1678));
        } else if(num == 2){
            HeliSpawns((-11949,8750,2788),(-7361,4494,1750));
        }
    }
	else if (map == "mp_trop_rust"){
        level.nukepos = (626,850,586);
        if(num == 0){
            HeliSpawns((6903,-9681,1682),(1296,74,345)); // done
        } else if(num == 1){
			HeliSpawns((-8945,-3117,2098),(-102,271,49)); // done
        } else if(num == 2){
            HeliSpawns((-4899,9896,2893),(411,-461,690)); // done 
        }
    }*/
	else if (map == "mp_underground") {
		num = randomint(8);
		
        level.nukepos = (31,1098,480);
        
        if(num == 0) {
			HeliSpawns((-9762,3265,2356),(-1497,1855,-256));
            level.flytohigher = (0,0,700);
        }
        else if(num == 1){
            HeliSpawns((-7416,-7312,4984),(-239,-794,0));
            level.flytohigher = (0,0,750);
        }
        else if(num == 2)
			HeliSpawns((4437,-8906,2376),(1067,323,-47));
        else if(num == 3)
			HeliSpawns((2157,9494,2199),(737,2264,-104));
        else if(num == 4)
			HeliSpawns((-3939,8861,2574),(36,2027,-129));
        else if(num == 5){
			HeliSpawns((-628,3145,-128),(37,-88,8));
            level.flytohigher = (0,0,700);
        }
        else if(num == 6)
			HeliSpawns((-6100,8366,2976),(1438,845,-122));
        else if(num == 7)
			HeliSpawns((-463,9305,3106),(-636,3147,-128));
    }
	else if (map == "mp_village") {
		num = randomint(8);
		 
        level.nukepos = (1173,400,904);
        
        if(num == 0)
			HeliSpawns((6691,4218,4866),(299,-2673,358),(-98,0,0));
        else if(num == 1) {
            HeliSpawns((-9940,3286,5328),(-889,-2087,362),(-75,0,0));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 2)
			HeliSpawns((-6196,6241,3373),(243,41,188),(-93,0,0));
        else if(num == 3) {
			HeliSpawns((5570,6823,2451),(1748,-455,237));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 4)
			HeliSpawns((6593,6277,3660),(1113,1091,240));
        else if(num == 5)
			HeliSpawns((-5375,6712,3018),(-614,892,318));
        else if(num == 6)
			HeliSpawns((-8124,-4271,4647),(-1432,506,251));
        else if(num == 7)
			HeliSpawns((3976,8491,2508),(-22,1743,280));
    }
	/*else if (map == "mp_nightshift"){ //////////////////// crashes
        level.nukepos = (-38,-944,656);
        if(num == 0){
            HeliSpawns((-1924,-9353,1739),(-1742,-656,356));
        } else if(num == 1){
           HeliSpawns((10707,-1038,1497),(828,-1249,436));
        } else if(num == 2){
            HeliSpawns((-6434,7266,2437),(-738,-1973,547));
        }
    }*/
	else if (map == "mp_courtyard_ss") {
		num = randomint(7);
		
        level.nukepos = (-54,-1083,484);
        
        if(num == 0)
			HeliSpawns((851,10497,5028),(725,325,133));
        else if(num == 1) {
            HeliSpawns((8852,-987,2506),(1024,-1133,173));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 2)
			HeliSpawns((-96,-11951,2695),(-68,-1967,133));
        else if(num == 3) {
			HeliSpawns((-10209,-1137,3766),(-1088,-1086,133));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 4)
			HeliSpawns((-9215,10771,5303),(-1070,405,128));
        else if(num == 5)
			HeliSpawns((-9583,-3556,2969),(-291,-252,129));
        else if(num == 6)
			HeliSpawns((-927,8885,4893),(-335,-1085,129));
    }
	else if (map == "mp_aground_ss") {
        num = randomint(4);
        
        if(num == 0)
			HeliSpawns((10932,3007,3024),(1426,-591,14));
        else if(num == 1)
            HeliSpawns((10139,532,1855),(397,664,406),(-87,-55,0));
        else if(num == 2)
			HeliSpawns((-8324,805,4679),(-864,769,310),(-89,-63,0));
        else if(num == 3)
			HeliSpawns((9569,-6239,2179),(376,-1222,305),(-88,-63,0));
    }
	else if (map == "mp_terminal_cls") {
		num = randomint(8);
		
        level.nukepos = (1694,2539,429);
        
        if(num == 0)
			HeliSpawns((-8810,-2212,3751),(866,3239,180),(-92,120,0));
        else if(num == 1) {
            HeliSpawns((7402,-5858,4237),(2583,2831,40));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 2)
			HeliSpawns((-6182,-2058,3402),(283,4931,192));
        else if(num == 3) {
			HeliSpawns((9262,7331,3771),(2289,5867,192));
            level.flytohigher = (160,160,700);
        } 
        else if(num == 4)
			HeliSpawns((8693,3094,3291),(1673,4619,178),(-95,65,0));
        else if(num == 5)
			HeliSpawns((1190,-8517,1932),(1984,3267,120));
        else if(num == 6) {
			HeliSpawns((-1632,12554,4795),(878,6169,192));
            level.flytohigher = (0,0,800);
        }
        else if(num == 7)
			HeliSpawns((-2115,-8592,2375),(1149,4938,192));
    }
	else if (map == "mp_favela") {
		num = randomint(10);
		 
        level.nukepos = (9935,18417,13804);
        
        if(num == 0)
            HeliSpawns((734,9783,4576),(472,2789,294));
        else if(num == 1)
            HeliSpawns((-6854,7121,3869),(-1018,2378,283));
        else if(num == 2)
            HeliSpawns((-8151,7381,3081),(-1493,-158,8));
        else if(num == 3)
            HeliSpawns((-7674,-7445,3744),(-821,-860,29));
        else if(num == 4)
            HeliSpawns((8305,3757,3974),(1342,1556,193));
        else if(num == 5)
            HeliSpawns((131,-6466,4166),(613,583,321));
        else if(num == 6)
            HeliSpawns((3194,-9271,4678),(598,-1093,153));
        else if(num == 7)
            HeliSpawns((277,8099,7180),(244,1455,156));
        else if(num == 8)
            HeliSpawns((6358,-2604,4676),(1105,-713,197));
        else if(num == 9)
            HeliSpawns((-6346,-2733,5514),(-300,1028,288));
    }
	else if (map == "mp_fav_tropical") {
		num = randomint(10);
		
        level.nukepos = (9935,18417,13804);
        
        if(num == 0)
            HeliSpawns((734,9783,4576),(472,2789,294));
        else if(num == 1)
            HeliSpawns((-6854,7121,3869),(-1018,2378,283));
        else if(num == 2)
            HeliSpawns((-8151,7381,3081),(-1493,-158,8));
        else if(num == 3)
            HeliSpawns((-7674,-7445,3744),(-821,-860,29));
        else if(num == 4)
            HeliSpawns((8305,3757,3974),(1342,1556,193));
        else if(num == 5)
            HeliSpawns((131,-6466,4166),(613,583,321));
        else if(num == 6)
            HeliSpawns((3194,-9271,4678),(598,-1093,153));
        else if(num == 7)
            HeliSpawns((277,8099,7180),(244,1455,156));
        else if(num == 8)
            HeliSpawns((6358,-2604,4676),(1105,-713,197));
        else if(num == 9)
            HeliSpawns((-6346,-2733,5514),(-300,1028,288));
    }
	else if (map == "mp_showdown_sh"){ ///////////////////// crashes
		num = randomint(2);
		
        level.nukepos = (3,74,386);
        
        if(num == 0){
            HeliSpawns((-84,-7683,1150),(8,-1735,27.125)); //done
        } else if(num == 1){
           HeliSpawns((-6833,7210,1073),(-2,1602,4.125)); //done
        }
	}
	/*else if (map == "mp_italy"){ ////////////////////////// crashes
        level.nukepos = (771,-139,1584);
        if(num == 0){
            HeliSpawns((946,-11809,1395),(1096,-1181,1080)); //done
        } else if(num == 1){
			HeliSpawns((1735,10121,5306),(-1555,686,1503)); //done
        } else if(num == 2){
			HeliSpawns((10176,954,3791),(1013,1857,1690)); // done
        }
		
    }
	else if (map == "mp_abandon"){ ////////////////////////// crashes
        level.nukepos = (2278,499,334);
        if(num == 0){
            HeliSpawns((12840,3152,1657),(3345,669,367));
        } else if(num == 1){
           HeliSpawns((-9319,4693,1626),(-318,261,360));
        } else if(num == 2){
            HeliSpawns((-1843,-11735,1582),(1675,-2377,352));
        }
	}*/
    else if(map == "mp_boneyard") {
    	num = randomint(7);
    	
        level.nukepos = (420,448,70);
        if(num == 0) {
			HeliSpawns((-8164,-4497,3731),(-1608,-495,-128));
            level.flytohigher = (0,0,750);
        } 
        else if(num == 1)
            HeliSpawns((391,-8121,1941),(19,-545,-140));
        else if(num == 2)
			HeliSpawns((9546,-453,2104),(1582,-466,-148),(-86,0,0));
        else if(num == 3) {
			HeliSpawns((1035,9144,1757),(1093,1528,-67),(-93,0,0));
            level.flytohigher = (0,0,750);
        } 
        else if(num == 4) {
			HeliSpawns((-752,9275,1902),(-319,1444,-76));
            level.flytohigher = (0,0,700);
        } 
        else if(num == 5)
			HeliSpawns((958,12917,3080),(-368,378,-119));
        else if(num == 6)
			HeliSpawns((-12770,2515,3124),(-1377,1198,-131));
    }
    else if (map == "mp_roughneck") {
    	num = randomint(7);
    	
        level.nukepos = (-223,127,247);
        
        if(num == 0) {
			HeliSpawns((10172,-616,657),(2085,325,-10));
            level.flytohigher = (0,0,750);
        } 
        else if(num == 1)
            HeliSpawns((4471,-5563,839),(231,-788,-180));
        else if(num == 2)
            HeliSpawns((-8317,-2254,1430),(-1116,-117,-5));
        else if(num == 3)
            HeliSpawns((-1311,-8751,939),(-691,-1848,200));
        else if(num == 4) {
            HeliSpawns((6941,-7700,1047),(-604,1077,-7));
            level.flytohigher = (200,0,600);
        }
        else if(num == 5) {
            HeliSpawns((-894,8678,2710),(1276,714,-12));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 6) {
            HeliSpawns((-6293,-9966,128),(1023,-1473,-213));
            level.flytohigher = (150,-150,100);
        }
    }
    else if (map == "mp_quarry") {
    	num = randomint(8);
    	
        level.nukepos = (-4482,-159,562);
        
        if(num == 0) {
            HeliSpawns((-5981,-10220,2365),(-5356,-726,-190));
            level.flytohigher = (0,0,950);
        } 
        else if(num == 1) {
            HeliSpawns((-3744,-8636,2682),(-3391,-1345,-94),(-95,-30,0)); 
            level.flytohigher = (0,0,1050);
        } 
        else if(num == 2) {
            HeliSpawns((6025,3568,2120),(-2276,2713,79),(-85,0,0)); 
            level.flytohigher = (0,0,650);
        } 
        else if(num == 3) {
            HeliSpawns((-6401,9340,1629),(-3262,3031,15));
            level.flytohigher = (0,0,650);
        } 
        else if(num == 4) {
            HeliSpawns((-10473,7338,2631),(-5072,2197,80));
            level.flytohigher = (0,0,1100);
        } 
        else if(num == 5) {
            HeliSpawns((-6713,-8280,2056),(-5211,478,-195));
            level.flytohigher = (0,0,1200);
        } 
        else if(num == 6) {
            HeliSpawns((-2139,7374,1754),(-2153,1401,22));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 7) {
            HeliSpawns((2944,5402,1737),(-3277,1002,-90),(-80,-90,0));
            level.flytohigher = (0,0,800);
        } 
        else if(num == 8) {
            HeliSpawns((4270,5798,2222),(-2278,-262,-45),(-88,50,0));
            level.flytohigher = (0,0,800);
        }
    }
	else if (map == "mp_cargoship_sh") {
    	num = randomint(5);
		
        level.nukepos = (1056,12,176);
        
        if(num == 0) {
            HeliSpawns((-2183,9410,2693),(-1702,52,136));
        } 
        else if(num == 1) {
            HeliSpawns((-9406,5000,3442),(-3304,-5,228));
			level.flytohigher = (-200,0,600);
        } 
        else if(num == 2) {
            HeliSpawns((2136,-9986,3483),(2003,-45,137)); 
        } 
        else if(num == 3) {
            HeliSpawns((12313,-246,2233),(3707,3,212));
        } 
        else if(num == 4) {
            HeliSpawns((-418,10878,7022),(272,10,21));
			level.flytohigher = (0,0,800);
        } 
    }
	else if (map == "mp_crash_snow") {
    	num = randomint(5);
		
        level.nukepos = (-39,319,440);
        
        if(num == 0) {
            HeliSpawns((-7406,1106,4446),(1109,1135,134));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 1) {
            HeliSpawns((1584,10943,5345),(-346,1627,238),(-86,0,0));
        } 
        else if(num == 2) {
            HeliSpawns((-8355,1150,4461),(1686,536,580)); 
        } 
        else if(num == 3) {
            HeliSpawns((2040,7830,3716),(221,-20,130));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 4) {
            HeliSpawns((-8332,-4377,4261),(930,-895,304));
			level.flytohigher = (0,0,800);
        } 
    }
	else if (map == "mp_overgrown") {
    	num = randomint(6);

        level.nukepos = (1189,-2322,156);
        
        if(num == 0) {
            HeliSpawns((10862,120,4833),(522,245,-174));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 1) {
            HeliSpawns((-937,-9594,1663),(210,-2798,-339));
        } 
        else if(num == 2) {
            HeliSpawns((-1621,-14517,2888),(-1390,-4237,-125));
        } 
        else if(num == 3) {
            HeliSpawns((12873,-3740,4192),(2167,-3343,-171));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 4) {
            HeliSpawns((-700,-13943,4051),(-1140,-1951,-192));
			level.flytohigher = (0,0,800);
        }
		else if(num == 5) {
            HeliSpawns((14253,-3036,4597),(1655,-1542,28));
        } 		
    }
	else if (map == "mp_rust_long") {
    	num = randomint(5);

        level.nukepos = (434,1041,2);
        
        if(num == 0) {
            HeliSpawns((12675,1564,4488),(1170,1409,-114));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 1) {
            HeliSpawns((1523,11731,4133),(1089,-31,-235));
        } 
        else if(num == 2) {
            HeliSpawns((12458,1266,6443),(2560,1147,-212)); 
        } 
        else if(num == 3) {
            HeliSpawns((-1005,-15089,10763),(-1126,1469,-229));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 4) {
            HeliSpawns((15500,1678,5230),(500,998,3));
			level.flytohigher = (0,0,800);
        } 
    }
	else if (map == "mp_citystreets") {
    	num = randomint(5);

        level.nukepos = (5049,-442,333);
        
        if(num == 0) {
            HeliSpawns((-11021,-31,6268),(4340,-411,16));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 1) {
            HeliSpawns((5014,-11279,4361),(5644,66,-972));
			level.flytohigher = (0,0,1800);
        } 
        else if(num == 2) {
            HeliSpawns((5810,10231,7160),(5511,-2175,-1));
			level.flytohigher = (0,0,1000);
        } 
        else if(num == 3) {
            HeliSpawns((2947,-14086,5679),(2850,901,-11));
			level.flytohigher = (0,0,800);
        } 
        else if(num == 4) {
            HeliSpawns((2672,12890,5830),(3018,-1554,-108));
			level.flytohigher = (0,0,1000);
        } 
    }
    else if(map == "mp_kwakelo"){
        level.nukepos = (252,-122,816);
        num = randomint(6);
        if(num == 0){
            HeliSpawns((-218,7532,4047),(-387,-441,416));
            level.flytohigher = (0,0,750);
        } else if(num == 1){
            HeliSpawns((-218,7532,4047),(885,-628,0));
            level.flytohigher = (-200,200,1100);
        } else if(num == 2){
            HeliSpawns((-218,7532,4047),(14,236,208));
            level.flytohigher = (0,-100,850);
        } else if(num == 3){
            HeliSpawns((-218,7532,4047),(-704,-699,-246));
            level.flytohigher = (200,200,1300);
        } else if(num == 4){
            HeliSpawns((-218,7532,4047),(-696,476,208));
            level.flytohigher = (200,-200,850);
        } else if(num == 5){
            HeliSpawns((-218,7532,4047),(934,463,0));
            level.flytohigher = (0,0,1100);
        }
    }

    else if(map == "mp_rustbucket"){
        level.nukepos = (1893,1350,269);
        num = randomint(5);
		//num=4;

        if(num == 0){
            HeliSpawns((1079,12801,3931),(550,1675,339));
            level.flytohigher = (0,0,800);
        } else if(num == 1){
            HeliSpawns((-7551,1118,4085),(-436,815,420));
            level.flytohigher = (0,0,700);
        } else if(num == 2){
            HeliSpawns((1280,-8732,4865),(1323,338,398));
            level.flytohigher = (0,0,800);
        } else if(num == 3){
            HeliSpawns((9781,1338,5011),(1180,1336,239));
            level.flytohigher = (0,0,750);
        } else if(num == 4){
            HeliSpawns((-492,13380,1294),(-6,241,-238));
            level.flytohigher = (0,0,1300);
        } 
    }
    else {
        origin = level.spawnpoints[randomint(level.spawnpoints.size)];
        HeliSpawns((-8000,8000,8000),origin.origin+(0,0,10));
        level.flytohigher = (0,0,1000);
    }
}

HeliSpawns(Spawnloc, flytoloc, angles) {
    level.helispawn = Spawnloc;
    level.flyto = flytoloc;
    
    if(isdefined(angles))
    	level.fxangles = angles;
    
    level.accel = distance(level.helispawn, level.flyto) / 300;
    level.helimsg = 10;
}



















