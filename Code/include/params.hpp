class Params
{
    class A3E_Param_Loadparams
    {
            title = "Parameter Load and Save (save params between sessions, see readme!)";
            values[] = {0, 1, 2};
            texts[] = {"Use settings below and save (settings will be restored on mission restart)", "Load previously saved settings (Use below if none found)", "Use settings below without saving"};
            default = 1;
	};
	class A3E_Param_Spacer1
    {
            title = "==================== Difficulty Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
    class A3E_Param_EnemySkill
	{
            title = "Enemy Skill";
            values[] = {0, 1, 2, 3, 4};
            texts[] = {"Cadet", "Easy", "Normal", "Hard", "Extreme"};
			livechanges = 1;
            default = 1;
	};
	class A3E_Param_EnemyFrequency
	{
		title="Enemy Groupsize (depreciated)";
		values[]={1,2,3};
		texts[]={"Few (1-3)", "Some (3-5)", "Large (5-7)"};
		livechanges = 1;
		default = 2;
	};
	class A3E_Param_EnemyGroupSize
	{
		title="Enemy Squadsize";
		values[]={2,4,6,8,-1,-2,-3};
		texts[]={"Few (2-3)", "Some (3-5)", "Large (5-7)", "Max (7-9)","Players 1:0.5","Players 1:1","Players 1:1.5"};
		livechanges = 1;
		default = -2;
	};
	class A3E_Param_EnemySpawnDistance
	{
		title="Enemy Spawn Distance";
		values[]={500,800,1000,1200};
		texts[]={"Short (better performance, spawn in view possible)", "Medium", "A Good Bit", "Far (for good rigs)"};
		default = 800;
	};
	class A3E_Param_VillageSpawnCount
	{
		title="Village Patrol Spawns";
		values[]={1, 2, 3};
		texts[]={"Low (better performance)", "Medium", "High (Very demanding)"};
		livechanges = 1;
		default = 1;
	};
	class A3E_Param_SearchChopper
	{
		title="Search Chopper Type";
		values[]={-1,0,1,2};
		texts[]={"None","Random (Chooses between Easy and Hard Values)","Easy","Hard"};
		default = 0;
	};
	class A3E_Param_SpawnGuards
	{
		title="Prison Guards";
		values[]={0,1};
		texts[]={"No Guards", "Spawn Guards"};
		default = 1;
	};
	class A3E_Param_SpawnPrisonBackpack
	{
		title="Prison Backpack";
		values[]={0,1,2};
		texts[]={"No Prison Backpack", "Spawn Prison Backpack", "Spawn as Crate"};
		default = 1;
	};
	class A3E_Param_CivilianSpawning
	{
		title="Civilian Spawning";
		values[]={0,1,2,3};
		texts[]={"No Civilian Spawning", "All Spawning", "Only Civilian Traffic", "Only Village Spawning"};
		livechanges = 1;
		default = 1;
	};
	class A3E_Param_AmmoScarcity
	{
		title="Ammo Scarcity";
		values[]={0,25,50,75,95,99};
		texts[]={"None", "Little", "Some", "Scarce", "Somewhat Extreme", "Extreme"};
		livechanges = 1;
		tooltip = "The amount of ammo removed from AI bodies and unconcious (if ACE_Medical is installed).";
		default = 0;
	};	
	class A3E_Param_Spacer2
    {
            title = "==================== Environment Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_TimeOfDay	
	{	
	    title="Time Of Day";
		values[]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};
		texts[]={"00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","Random","Daytime","Nighttime"};
		default = 8;
		//function = "A3E_fnc_paramDaytime"; // (Optional) Function called when player joins, selected value is passed as an argument
	};
	class A3E_Param_TimeMultiplier	
	{	
	    title="Time Multiplier (Fasttime)";
		values[]={0.01,0.5,1,2,4,6,12,24,36};
		texts[]={"100:1 (Day = A Really Long Time)","2:1 (Day = 48 Hours)","1:1 (Normal)","1:2 (Day = 12 Hours)","1:3 (Day = 8 Hours)","1:4 (Day = 6 Hours)","1:6 (Day = 4 Hours)","1:12 (Day = 2 Hours)","1:24 (Day = 1 Hour)","1:36 (Day = 40 Minutes)"};
		livechanges = 1;
		code = "if(isserver) then {setTimeMultiplier _this;};";
		default = 6;
	};
	class A3E_Param_WeatherOvercast
	{
		title="Cloud Cover";
		values[] = {-1,0,1,2,3,4,5,6,7,8,9,10};
		texts[] = {"Randomly picks one of the below values (weighted towards low cloud cover for a better gameplay experience)","No Clouds","10%","20%","30%","40%","50% (Minimum needed for rain to appear)","60%","70%","80%","90%","100%"};
		default = -1;
	};
	class A3E_Param_WeatherFog
	{
		title="Fog Density";
		values[] = {-1,0,1,2,3,4,5,6,7,8,9,10};
		texts[] = {"Randomly picks one of the below values (heavily weighted towards no fog for a better gameplay experience)","No Fog","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"};
		default = -1;
	};
	class A3E_Param_WeatherWind
	{
		title="Wind";
		values[] = {-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
		texts[] = {"Randomly picks one of the below values (except last 4 and heavily weighted towards low wind for a better gameplay experience)","No Wind","Lvl 1 Wind","Lvl 2 Wind","Lvl 3 Wind (Start to see the effects on smoke around here)","Lvl 4 Wind","Lvl 5 Wind (Smoke grenades are less effective)","Lvl 6 Wind","Lvl 7 (Smoke Grenades are useless at this point)","Lvl 8 Wind","Lvl 9 Wind","Lvl 10 Wind (Game wasn't designed for wind this fast at this point.  Doesn't affect framerate.)","Lvl 11 Wind","Lvl 1337 Wind","Lvl 9001 Wind"};
		default = -1;
	};
	class A3E_Param_WeatherRain
	{
		title="Rain Density (Cloud Cover must be at least 50%)";
		values[] = {-1,1,2,3,4,5,6,7,8,9,10,11};
		texts[] = {"Randomly picks one of the below values","No Rain","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"};
		default = -1;
	};
	class A3E_Param_Grass
	{	
		title="Grass Visibility";
		values[]={50,25,12,6,2};
		texts[]={"No Grass", "Proximity", "Normal", "Far", "Very Far"};
		default = 12;
	};
	class A3E_Param_Spacer3
    {
            title = "==================== Gameplay Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_TracerReplacer
	{
		title="Tracer Replacer";
		values[]={0,1,2};
		texts[]={"Disabled","Enabled","Faction Specific"};
		default = 0;
		tooltip = "This will attempt to swap all spawned AI's primary ammuntion with applicable tracer variants. Enjoy the lightshow! Faction Specific option makes Yellow, Green, and Red, for Bluefor, OpFor, and Independent factions, respectively if applicable.";
	}	
	class A3E_Param_UseIntel
	{
		title="Collect intel to reveal markers on map";
		values[]={0,1};
		texts[]={"Disabled","Enabled"};
		default = 1;
		tooltip = "This will enable the collection of intel from enemies. Intel will reveal locations on the map.";
	};
	class A3E_Param_IntelChance
	{
		title="Chance an enemy carries intel";
		values[]={5,10,20,30,40,50,100};
		texts[]={"5%","10%","20%","30%","40%","50%","100%(For Debugging)"};
		livechanges = 1;
		default = 20;
	};
	class A3E_Param_RevealMarkers
	{
		title="Display of markers on map";
		values[]={0,1,2,3};
		texts[]={"Always show (with type)","Always show marker but hide type (questionmark)","Show marker upon discovery","Never show markers"};
		default = 2;
	};
	class A3E_Param_AIUseRadioAnimation
	{
		title="AI Use Radio Animation";
		values[]={0, 1};
		texts[]={"No", "Yes"};
		default = 1;
		tooltip = "Allow AI units to play a animation when calling in your position.";
	};
	class A3E_Param_VehicleLock
	{
		title="Lock Vehicles";
		values[]={0, 1, 2};
		texts[]={"None", "Armed", "All"};
		default = 0;
	};
	class A3E_Param_Artillery
	{
		title="Artillery and CAS Strikes";
		values[]={0,0.1,0.25,0.5,1,2};
		texts[]={"None","Really Really Reduced","Really Reduced","Reduced","Default","Death in fire"};
		livechanges = 1;
		default = 1;
	};
	class A3E_Param_War_Torn
	{
		title="War-Torn mode (OpFor and Independent are fighting each other)";
		values[]={0,1};
		texts[]={"Disabled","Enabled"};
		default = 0;
	};
	class A3E_Param_ReviveView
	{
		title="Unconscious View";
		values[]={0,1};
		texts[]={"First-/Third-Person","Hindsight Cam"};
		default = 1;
	};
	class A3E_Param_ExtractionSelection
	{
		title="Extraction Points";
		values[]={0, 1, 2};
		texts[]={"Random", "Close", "Far"};
		livechanges = 1;
		default = 0;
	};
	class A3E_Param_Waffelbox
	{
		title="Additional Weaponbox (with less random content) at depots";
		values[]={0,1};
		texts[]={"Off", "On"};
		default = 0;
	};
	class A3E_Param_NoNightvision
	{
		title="NVG-Goggles and TWS Scopes";
		values[]={0,1};
		texts[]={"All", "No Goggles and TWS"};
		livechanges = 1;
		default = 0;
	};
	class A3E_Param_Spacer4
    {
            title = "==================== Statistic Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_SendStatistics
	{
		title="Send statistics at mission end";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_Spacer5
    {
            title = "==================== DLC Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_UseDLCApex
	{
		title="Allow usage of units from Apex DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_UseDLCHelis
	{
		title="Allow usage of units from Helicopters DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_UseDLCMarksmen
	{
		title="Allow usage of premium classes from Marksmen DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	/*class A3E_Param_UseDLCJets
	{
		title="Allow usage of units from Jets DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};*/
	class A3E_Param_UseDLCLaws
	{
		title="Allow usage of units from Laws of War DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_UseDLCTanks
	{
		title="Allow usage of units from Tanks DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_UseDLCContact
	{
		title="Allow usage of units from Contact DLC";
		values[]={0,1};
		texts[]={"No", "Yes"};
		default = 1;
	};
	class A3E_Param_Spacer6
	{
            title = "==================== 3rd-party scripts ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_Magrepack
	{
		title="Mag repack";
		values[]={0,1};
		texts[]={"Disabled", "Enabled"};
		default = 0;
	};
	class A3E_Param_Spacer7
    {
            title = "==================== Debug Settings ====================";
            values[] = {0};
            texts[] = {""};
            default = 0;
	};
	class A3E_Param_Debug
	{
		title="Debug (you should keep this off)";
		values[]={0,1};
		texts[]={"Off","On"};
		livechanges = 1;
		default = 0;
	};
};