
init(){

    Weapons = [];
    Weapons["ShotGun"] =
    [
        "iw5_spas12",
        "iw5_aa12",
        "iw5_striker",
        "iw5_1887",
        "iw5_usas12",
        "iw5_ksg"
    ];
    Weapons["Pistol"] =
    [
        "iw5_usp45",
        "iw5_mp412",
        "iw5_44magnum",
        "iw5_deserteagle",
        "iw5_p99",
        "iw5_fnfiveseven"
    ];

    level.Weapons = Weapons;

    Attachments = [];
    Attachments["iw5_spas12"] =
    [
        "grip",
        "reflex",
        //"eotech"
        "xmags"
        //"silencer03"
    ];

    Attachments["iw5_aa12"] =
    [
        "grip",
        "reflex",
        //"eotech",
        "xmags"
        //"silencer03"
    ];

    Attachments["iw5_striker"] =
    [
        "grip"
        //"reflex",
        //"eotech"
        //"xmags"
        //"silencer03"
    ];

    Attachments["iw5_1887"] = [];

    Attachments["iw5_usas12"] =
    [
        "grip",
        "reflex"
        //"eotech"
        //"xmags"
        //"silencer03"
    ];

    Attachments["iw5_ksg"] =
    [
        "grip",
        "reflex"
        //"eotech"
        //"xmags"
        //"silencer03"
    ];

    Attachments["iw5_usp45"] =
        [
        //"silencer02",
        "akimbo",
        "tactical"
        //"xmags"
    ];

    Attachments["iw5_mp412"] =
    [
        "akimbo",
        "tactical"
    ];

    Attachments["iw5_44magnum"] =
    [
        "akimbo",
        "tactical"
    ];

    Attachments["iw5_deserteagle"] =
    [
        "akimbo",
        "tactical"
    ];

    Attachments["iw5_p99"] =
    [
        //"silencer02",
        "akimbo",
        "tactical"
        //"xmags"
    ];

    Attachments["iw5_fnfiveseven"] =
    [
        //"silencer02",
        "akimbo",
        "tactical"
        //"xmags"
    ];

    level.Attachments = Attachments;

    DefaultSniperScopes = [];

    DefaultSniperScopes["iw5_barrett"] = "barrettscope";
    DefaultSniperScopes["iw5_as50"] = "as50scope";
    DefaultSniperScopes["iw5_l96a1"] = "l96a1scope";
    DefaultSniperScopes["iw5_msr"] = "msrscope";
    DefaultSniperScopes["iw5_dragunov"] = "dragunovscope";
    DefaultSniperScopes["iw5_rsass"] = "rsassscope";

    level.DefaultSniperScopes = DefaultSniperScopes;

    AttachmentExclusions = [];

    AttachmentExclusions["reflex"] =
    [
            "reflex",
            "acog",
            "thermal",
            "eotech",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["reflexsmg"] =
    [
            "reflexsmg",
            "acogsmg",
            "thermalsmg",
            "eotechsmg",
            "vzscope",
            //"hamrhybrid",
            //"hybrid",
            "akimbo"
    ];
    AttachmentExclusions["reflexlmg"] =
    [
            "reflexlmg",
            "acog",
            "thermal",
            "eotechlmg",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["silencer"] =
    [
            //"silencer",
            "silencer02",
            "silencer03",
            "akimbo"
    ];
    AttachmentExclusions["silencer02"] =
        [
            //"silencer",
            "silencer02",
            "silencer03",
            "akimbo"
    ];
    AttachmentExclusions["silencer03"] =
    [
            //"silencer",
            "silencer02",
            "silencer03akimbo"
    ];
    AttachmentExclusions["acog"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "vzscope",
            //"hamrhybrid",
            //"hybrid",
            "akimbo"
    ];
    AttachmentExclusions["acogsmg"] =
    [
            "acogsmg",
            "reflexsmg",
            "thermalsmg",
            "eotechsmg",
            "vzscope",
            //"hamrhybrid",
            //"hybrid",
            "akimbo"
    ];

    AttachmentExclusions["grip"] =
    [
            "grip"
    ];

    AttachmentExclusions["akimbo"] =
    [
            "akimbo",
            "acog",
            "acogsmg",
            "reflex",
            "reflexsmg",
            "thermal",
            "thermalsmg",
            "eotech",
            "vzscope",
            //"hamrhybrid",
            //"hybrid",
            "tactical",
            //"silencer",
            "silencer02",
            "silencer03"
    ];

    AttachmentExclusions["thermal"] =
    [
            "akimbo",
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];

    AttachmentExclusions["thermalsmg"] =
    [
            "akimbo",
            "acogsmg",
            "reflexsmg",
            "thermalsmg",
            "eotechsmg",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];

    AttachmentExclusions["xmags"] =
    [
            "xmags"
    ];

    AttachmentExclusions["rof"] =
    [
            "rof"
    ];

    AttachmentExclusions["eotech"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["eotechsmg"] =
    [
            "acogsmg",
            "reflexsmg",
            "thermalsmg",
            "eotechsmg",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["eotechlmg"] =
    [
            "acog",
            "reflexlmg",
            "thermal",
            "eotechlmg",
            "vzscope"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["tactical"] =
    [
            "tactical",
            "akimbo"
    ];
    AttachmentExclusions["barrettscopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "barrettscopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["as50scopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "as50scopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["l96a1scopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "l96a1scopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["msrscopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "msrscopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["dragunovscopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "dragunovscopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    AttachmentExclusions["rsassscopevz"] =
    [
            "acog",
            "reflex",
            "thermal",
            "eotech",
            "rsassscopevz"
            //"hamrhybrid",
            //"hybrid"
    ];
    level.AttachmentExclusions = AttachmentExclusions;
    ReticuleSights =
    [
        "reflex",
        "reflexsmgs",
        "acog",
        "eotech",
        "reflexlmg",
        "reflexsmg",
        "eotechsmg",
        "eotechlmg",
        "acogsmg",
        "thermalsmg"
    ];
    level.ReticuleSights = ReticuleSights;
    SniperSights =
    [
        "barrettscopevz",
        "as50scopevz",
        "l96a1scopevz",
        "msrscopevz",
        "dragunovscopevz",
        "rsassscopevz",
        "acog",
        "thermal"
    ];
    level.SniperSights = SniperSights;
    Camouflages =
    [
        "none",
        "camo01",
        "camo02",
        "camo03",
        "camo04",
        "camo05",
        "camo06",
        "camo07",
        "camo08",
        "camo09",
        "camo10",
        "camo11",
        "camo12",
        "camo13"
    ];
    level.Camouflages = Camouflages;
    Reticles =
    [
        "none",
        "scope1",
        "scope2",
        "scope3",
        "scope4",
        "scope5",
        "scope6"
    ];
    level.Reticles = Reticles;
}




BuildWeapon(itemType)
{
    switch (itemType)
    {
        case "AssaultRifle":
            return GenerateRandomWeapon("AssaultRifle", false);
        case "LMG":
            return GenerateRandomWeapon("LMG", false);
        case "SMG":
            return GenerateRandomWeapon("SMG", false);
        case "ShotGun":
            return GenerateRandomWeapon("ShotGun", false);
        case "SniperRifle":
            return GenerateRandomWeapon("SniperRifle", false);
        case "MachinePistol":
            return GenerateRandomWeapon("MachinePistol", false);
        case "Pistol":
            return GenerateRandomWeapon("Pistol", false);
    }
    return "";
}


GenerateRandomWeapon(type, akimbo)
{

    //akimbo = isDefined(akimbo) ? akimbo : false;
    //print("type - weapon " + level.Weapons[type].size);
    WeaponTechName = level.Weapons[type][RandomIntRange(0, level.Weapons[type].size)];
    //print(WeaponTechName);
    WeaponFullName = WeaponTechName + "_mp" + (akimbo ? "_akimbo" : "");

    if (level.Attachments[WeaponTechName].size != 0)
    {
        rand1 = RandomIntRange(0, level.Attachments[WeaponTechName].size);
        rand2 = RandomIntRange(0, level.Attachments[WeaponTechName].size);

        Attachment_1 = level.Attachments[WeaponTechName][rand1];
        Attachment_2 = level.Attachments[WeaponTechName][rand2];

        //print("Attachment_1" + Attachment_1);
        //print("Attachment_2" + Attachment_2);
        // print("isDefined att 1 "+ level.SniperSights[Attachment_1]);
        // print("isDefined att 2 "+ level.SniperSights[Attachment_2]);
        //if we have at least one attachment as scope we should
        if (
            type == "SniperRifle" && 

            !containsValue(level.SniperSights, Attachment_1)

            && !containsValue(level.SniperSights, Attachment_2)
        ){
            WeaponFullName += "_" + level.DefaultSniperScopes[WeaponTechName];
        }

        if(rand1 < rand2){
            WeaponFullName += "_" + Attachment_1;

            if(Attachment_2 != Attachment_1 && !containsValue(level.AttachmentExclusions[Attachment_1], Attachment_2) ){
                WeaponFullName += "_" + Attachment_2;
            }

        } else {
            WeaponFullName += "_" + Attachment_2;

            if(Attachment_1 != Attachment_2  && !containsValue(level.AttachmentExclusions[Attachment_2], Attachment_1)){
                WeaponFullName += "_" + Attachment_1;
            }
        }

        // if (isDefined(level.ReticuleSights[Attachment_1]) || isDefined(level.ReticuleSights[Attachment_2]))
        // {
        //     Scope = level.Reticles[RandomIntRange(level.Reticles.size)];

        //     if (Scope != "none")
        //         WeaponFullName += "_" + Scope;
        // }
        if (!(type == "Pistol" || type == "MachinePistol"))
        {
            camo = level.Camouflages[RandomIntRange(0, level.Camouflages.size)];

            if (camo != "none")
                WeaponFullName += "_" + camo;
        }
    }
    //print(WeaponFullName);
    return WeaponFullName;
}

containsValue(vec, element){

    for(i = 0; i < vec.size; i++){
        if(vec[i] == element){
            return true;
        }
    }

    return false;
}



