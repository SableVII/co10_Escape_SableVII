if (!isServer) exitWith {};

params["_extractionPointNo",["_isWater",false]];

private _extraction = (A3E_ExtractionPositions select {_x select 0 == _extractionPointNo}) select 0;

_spawnMarkerName = "A3E_ExtractionSpawnPos" + str _extractionPointNo;
_extractionMarkerName = "A3E_ExtractionPos" + str _extractionPointNo;
_extractionMarkerName2 = "A3E_ExtractionPos" + str _extractionPointNo + "_1";

private _spawnVector = (getMarkerPos _spawnMarkerName) vectorDiff (getMarkerPos _extractionMarkerName);
private _dir = (getMarkerPos _spawnMarkerName) getDir (getMarkerPos _extractionMarkerName);
private _pos = ((getMarkerPos _extractionMarkerName) vectorAdd _spawnVector) vectorAdd [0,0,40];
private _result = [_pos,_dir, selectRandom a3e_arr_extraction_chopper, A3E_VAR_Side_Blufor] call BIS_fnc_spawnVehicle;
private _boat1 = _result select 0;
private _group1 = _result select 2;


_pos = ((getMarkerPos _extractionMarkerName2) vectorAdd (_spawnVector vectorMultiply 1.2)) vectorAdd [0,0,40];
_result = [_pos,_dir, selectRandom a3e_arr_extraction_chopper, A3E_VAR_Side_Blufor] call BIS_fnc_spawnVehicle;
private _boat2 = _result select 0;
private _group2 = _result select 2;

_pos = ((getMarkerPos _extractionMarkerName) vectorAdd (_spawnVector vectorMultiply 0.8)) vectorAdd [0,0,60];
_result = [_pos,_dir, selectRandom a3e_arr_extraction_chopper_escort, A3E_VAR_Side_Blufor] call BIS_fnc_spawnVehicle;
private _boat3 = _result select 0;
private _group3 = _result select 2;

_boat1 setvariable ["State","Init"];
_boat2 setvariable ["State","Init"];
[_boat1, getMarkerPos _extractionMarkerName,(_spawnVector vectorMultiply 5)] spawn A3E_fnc_ExtractionChopper;
[_boat2, getMarkerPos _extractionMarkerName2,(_spawnVector vectorMultiply 5)] spawn A3E_fnc_ExtractionChopper;

_waypoint = _group3 addWaypoint [getMarkerPos _extractionMarkerName, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "COMBAT";
_waypoint setWaypointFormation "WEDGE";
_waypoint setWaypointType "LOITER";
_waypoint setWaypointLoiterRadius 500;


diag_log format["fn_RunExtraction: Extraction choppers spawned: %1, %2 and %3",_boat1,_boat2,_boat3];

A3E_EvacHeli1 = _boat1;
publicvariable "A3E_EvacHeli1";
A3E_EvacHeli2 = _boat2;
publicvariable "A3E_EvacHeli2";
A3E_EvacHeli3 = _boat3;
publicvariable "A3E_EvacHeli3";

_group1 setGroupIdGlobal ["Angel One"];
_group2 setGroupIdGlobal ["Angel Two"];
_group3 setGroupIdGlobal ["Archangel"];



_boat1 flyinheight 40;
_boat2 flyinheight 40;
_boat3 flyinheight 60;

[_boat1] spawn {
	params["_heli"];
	sleep 5;
	[driver _heli,"We are here to get you out. Archangel is providing cover."] remoteExec ["sideChat",0,false];
};
_heloGuard = {
	params["_heli"];
	sleep 6;
	private _msg = ["We are taking damage!","Under fire!","We are under fire!","Taking damage!","I thought the landing zone was safe!"];
	waituntil{sleep 0.5;((getDammage _heli)>0.1)};
	if(alive (driver _heli)) then {
		[driver _heli,selectRandom _msg] remoteExec ["sideChat",0,false];
	};
	waituntil{sleep 0.5;!(alive _heli)};
	if(!(isNull _heli)) then {
		[[A3E_VAR_Side_Blufor,"HQ"],format["%1 is going down!",groupId (group (driver _heli))]] remoteExec ["sideChat",0,false];
	};
};

_extractionGuard = {
	params["_heli1","_heli2","_marker"];
	sleep 6;
	waituntil{sleep 0.5;!(alive _heli1) and !(alive _heli2)};
	if(!(isNull _heli1 or isNull _heli2)) then {
		[[A3E_VAR_Side_Blufor,"HQ"],"Both birds are down!"] remoteExec ["sideChat",0,false];
		_marker setMarkerType "hd_objective";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText "";
	};
};


[_boat1] spawn _heloGuard;
[_boat2] spawn _heloGuard;
[_boat3] spawn _heloGuard;
[_boat1,_boat2,(_extraction select 4)] spawn _extractionGuard;

sleep 1;


// Verkar inte funka...
(driver _boat1) action ["LightOff", _boat1];
(driver _boat2) action ["LightOff", _boat2];

private _boat1Dead = false;
private _boat2Dead = false;
while {{(_x in  _boat1) || (_x in _boat2)} count (call A3E_fnc_GetPlayers) != count(call A3E_fnc_GetPlayers)} do {
	if (!(alive _boat1)) then {
		_boat1Dead = true;
		SystemChat "Boat 1 is Destroyed Before Player Evac!";
	};
	
	if (!(alive _boat2)) then {
		_boat2Dead = true;
		SystemChat "Boat 2 is Destroyed Before Player Evac!";
	};	
	
	sleep 1;
};
_boat1 setvariable ["State","Evac"];
_boat2 setvariable ["State","Evac"];



if(alive (driver _boat1)) then {
[driver _boat1,"Everybody on board? Okay, let's get the hell out of here!"] remoteExec ["sideChat",0,false];
} else {
	if(alive (driver _boat2)) then {
		[driver _boat2,"Everybody on board? Okay, let's get the hell out of here!"] remoteExec ["sideChat",0,false];
	};
};


sleep 10;

["Task complete: Rendesvouz with allied forces."] call drn_fnc_CL_ShowTitleTextAllClients;
A3E_Task_Exfil_Complete = true;
publicvariable "A3E_Task_Exfil_Complete";


// Check to see if evac helicopters fly far enough away to be safe-enough to succed in the mission.
private _negSpawnDir = (vectorNormalized _spawnVector) vectorMultiply -1;
private _boat1FarEnough = false;
private _boat2FarEnough = false;
while { true; } do {
	//SystemChat "Checking Evac";

	// Check for Both Helicopters are destroyed
	if (!(alive _boat1)) then {
		_boat1Dead = true;
		//SystemChat "Boat 1 is Destroyed!";
		
		if (_boat2FarEnough) then {
			//SystemChat "Boat 1 is destoryed, but Boat 2 made it far enough: Mission Ending";
			break;
		};
	};
	
	if (!(alive _boat2)) then {
		_boat2Dead = true;
		//SystemChat "Boat 2 is Destroyed!";
		
		if (_boat1FarEnough) then {
			//SystemChat "Boat 2 is destoryed, but Boat 1 made it far enough: Mission Ending";
			break;
		};
	};
	
	// Both boats are destroyed, fail the mission
	if (_boat1Dead && _boat2Dead) then {
		//SystemChat "Both Boats are Destroyed: Mission Failed";		
		break;
	};
	
	// Boat 1 Checking
	if (!_boat1FarEnough && !_boat1Dead) then {
		private _boat1Vector = (getPos _boat1) vectorDiff (getMarkerPos _spawnMarkerName);
		_boat1Vector = vectorNormalized _boat1Vector;
		private _boat1Dot = _negSpawnDir vectorDotProduct _boat1Vector;

		//SystemChat Format["Boat 1 Dot: %1", _boat1Dot];

		if (_boat1Dot < 0) then {
			_boat1FarEnough = true;
			/*SystemChat "Boat 1 is far enough";
			
			if (_boat2Dead) then {
				SystemChat "Boat 1 Made it while Boat 2 was destroyed";
				break;
			};*/
		};			
	};
	
	// Boat 2 Checking
	if (!_boat2FarEnough && !_boat2Dead) then {
		private _boat2Vector = (getPos _boat2) vectorDiff (getMarkerPos _spawnMarkerName);
		_boat2Vector = vectorNormalized _boat2Vector;
		private _boat2Dot = _negSpawnDir vectorDotProduct _boat2Vector;

		//SystemChat Format["Boat 2 Dot: %1", _boat2Dot];

		if (_boat2Dot < 0) then {
			_boat2FarEnough = true;
			/*SystemChat "Boat 2 is far enough";
			
			if (_boat1Dead) then {
				SystemChat "Boat 2 Made it while Boat 1 was destroyed";
				break;
			};*/
		};			
	};
	
	// One of the boats made it past its starting position
	if (_boat1FarEnough || _boat2FarEnough) then {
		//SystemChat "Both Boats Made it out successfully";
		break;
	};

	sleep 5;
};

sleep 1;

if({vehicle _x == _boat1 || vehicle _x == _boat2} count (call A3E_fnc_GetPlayers) == count (call A3E_fnc_GetPlayers)) then {
	a3e_var_Escape_MissionComplete = true;
	publicVariable "a3e_var_Escape_MissionComplete";
} else {
	a3e_var_Escape_MissionFailed_LeftBehind = true;
	publicVariable "a3e_var_Escape_MissionFailed_LeftBehind";
};

