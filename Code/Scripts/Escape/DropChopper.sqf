if (!isServer) exitWith {};

private ["_chopper", "_noOfDropUnits", "_dropPosition", "_side", "_spawnPos", "_onGroupDropped", "_debug", "_group", "_waypoint"];

_chopper = _this select 0;
_noOfDropUnits = _this select 1;
_dropPosition = _this select 2;
_side = _this select 3;
_spawnPos = _this select 4;
if (count _this > 5) then {_onGroupDropped = _this select 5;} else {_onGroupDropped = {};};
if (count _this > 6) then {_debug = _this select 6;} else {_debug = false;};

_group = group _chopper;

if (_debug) then {
    player sideChat "Starting drop chopper script...";
};

if (vehicleVarName _chopper == "") exitWith {
	sleep 5;
	player sideChat "Drop chopper must have a name. Script exiting.";
};

_chopper setVariable ["waypointFulfilled", false];
_chopper setVariable ["missionCompleted", false];

[_chopper, _noOfDropUnits, _dropPosition, _onGroupDropped, _side, _spawnPos, _debug] spawn {
	private ["_chopper", "_noOfDropUnits", "_dropPosition", "_onGroupDropped", "_side", "_spawnPos", "_debug", "_i", "_dropGroup", "_dropUnits", "_soldierType"];
	
    _chopper = _this select 0;
    //_dropUnits = _this select 1;
    _noOfDropUnits = _this select 1;
	_dropPosition = _this select 2;
    _onGroupDropped = _this select 3;
	_side = _this select 4;
	_spawnPos = _this select 5;
    _debug = _this select 6;
	
	_dropGroup = createGroup _side;	
	_dropUnits = [];
    
	while {!(_chopper getVariable "waypointFulfilled")} do {
		sleep 1;
	};

	if (_debug) then {
		player sideChat "Drop chopper dropping cargo...";
	};
	
	
	
	if (_side == A3E_VAR_Side_Opfor) then {
		_soldierType = A3E_arr_recon_InfantryTypes select floor (random count A3E_arr_recon_InfantryTypes);
	} else {
		_soldierType = a3e_arr_recon_I_InfantryTypes select floor (random count a3e_arr_recon_I_InfantryTypes);
	};
	
	private _flareDropUnit = round random (_noOfDropUnits - 1);
	
	for "_i" from 0 to (_noOfDropUnits - 1) step 1 do {
		// Create Unit
		private _dropUnit = _dropGroup createUnit [_soldierType, _spawnPos, [], 0, "FORM"];
		_dropUnit setRank "CAPTAIN";

		[_dropUnit] joinSilent _dropGroup;
		_dropUnit call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
		_dropUnits pushBack _dropUnit;
		
		// Assign as Cargo to hopefully make them 'Eject' correctly
		_dropUnit assignAsCargo _chopper;
		_dropUnit moveInCargo _chopper;
				
		// Determine if its night	
		private _sunriseSunsetTime = date call BIS_fnc_sunriseSunsetTime;
		private _sunrise = _sunriseSunsetTime select 0;
		private _sunset = _sunriseSunsetTime select 1;
		private _isNight = _sunrise == -1; // Checking for polar winter (always night)
		if (_isNight == false and _sunset != -1) then // not polar summer (always day)
		{
			if (_sunset < _sunrise) then
			{
				_isNight = dayTime > _sunset and dayTime < _sunrise;
			} else {
				_isNight = dayTime > _sunset or dayTime < _sunrise;		
			};
		};
				
		//_dropUnit = _dropUnits select _i;
		//_dropUnit enableAI "ALL"; // Re-enable AI 
		removeBackpack _dropUnit;
		unassignVehicle _dropUnit;
		_dropUnit action ["eject", _chopper]; 
		 
		_dropUnit setdir ((direction _chopper)-25+(random 50));
		_dropUnit setPos [(getPos _chopper) select 0,(getPos _chopper) select 1, ((getPos _chopper) select 2) - 5];
		
		// _dropUnit action ["eject", _chopper]; 
        // waitUntil {vehicle _dropUnit != _chopper};
		
		private _dropFlares = _isNight and (_i == _flareDropUnit); // Drop only at night
		private _dropSmokes = (_isNight == false) and (_i == 0 or _i == (_noOfDropUnits - 1)); // Drop only at day
		private _dropChemlights = _isNight; // Drop chemlights at night for units who isnt dropping a flare
		[_dropUnit,_chopper,85+(random 10),false,_dropSmokes,_dropFlares,_dropChemlights] spawn {
			params ["_unit","_chopper","_openHeight","_para","_smokes","_flares","_chems"];
			private ["_smoke","_flare","_chem"];
			
			if(isNull _unit || !alive _unit) exitwith {};
			while {((getPos _unit)# 2)>_openHeight} do {
				if(isNull _unit || !alive _unit) exitwith {diag_log "Escape Error: Dropunit empty or dead. Breaking loop";};
				sleep 0.1;
			};
			
			_unit addBackPackGlobal "B_parachute";
			
			// Drop flare
			if (_flares) then {
				waitUntil{((getPos _unit)select 2)<35};
				_flare = createVehicle ["F_40mm_" + selectRandom["red", "yellow", "green", "white"],  (getPos _unit), [], 0, "NONE"];
				_flare setVelocity [wind select 0, wind select 1, 15]; // Nudge flare to simulate phsyics
			};
			
			// Drop smokes
			if (_smokes) then {
				waitUntil{((getPos _unit)select 2)<10};
				_smoke = createVehicle ["SmokeShell", (getPos _unit), [], 0, "NONE"];
			};
			
			// Drop chemlights
			if (_chems) then {
				waitUntil{((getPos _unit)select 2)<5};
				
				_chem = createVehicle ["Chemlight_" + selectRandom["red", "yellow", "green", "blue"], (getPos _unit), [], 0, "NONE"];
			};
			
			/*private _vel = velocity _unit;
			_para = createVehicle ["Steerable_Parachute_F", [0,0,0], [], direction _unit, 'CAN_COLLIDE'];
			_para disableCollisionWith _unit;
			_para setPos (getPos _unit);
			_unit moveInDriver _para;
			_para setvelocity _vel;*/
	

		};
		
		// Delay till next spawning next unit
		sleep (0.3 + random 0.3);
	};
	

    _dropUnits = units (group (_dropUnits select 0));
    _dropGroup = group (_dropUnits select 0);
    [_dropGroup, _dropPosition] call _onGroupDropped;
    
	while {!(_chopper getVariable "missionCompleted")} do {
		sleep 1;
	};

	if (_debug) then {
		player sideChat "Drop chopper terminating...";
	};

	{
		deleteVehicle _x;
	} foreach units group _chopper;
	deleteVehicle _chopper;
};

if (_debug) then {
	//"SmokeShellRed" createVehicle _dropPosition;
	createVehicle ["SmokeShellRed", _dropPosition, [], 0, "NONE"];
	player sideChat "Drop chopper moving out...";
};

_chopper flyInHeight 250;
_chopper engineOn true;
_chopper move [position _chopper select 0, position _chopper select 1, 100];
while {(position _chopper) select 2 < 100} do {
	sleep 1;
};

_waypoint = _group addWaypoint [_dropPosition, 0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointStatements ["true", vehicleVarName _chopper + " setVariable [""waypointFulfilled"", true];"];


_waypoint = _group addWaypoint [getPos _chopper, 0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointStatements ["true", vehicleVarName _chopper + " setVariable [""missionCompleted"", true];"];



