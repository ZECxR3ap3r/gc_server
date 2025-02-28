main()
{
    replacefunc(maps\mp\killstreaks\_nuke::nukeSlowMo, ::disableNukeSlowMo);
    replacefunc(maps\mp\gametypes\_killcam::doFinalKillCamFX, ::disableDoFinalKillCamFX);
}

disableNukeSlowMo()
{

}

disableDoFinalKillCamFX( camtime ) {
	if(isDefined(level.doingFinalKillcamFx))
    	return;
    level.doingFinalKillcamFx = true;
    level.doingFinalKillcamFx = undefined;
}





