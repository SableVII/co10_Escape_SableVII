if (!isServer) exitWith {};

private ["_minEnemySkill", "_maxEnemySkill", "_debug"];
private ["_surprises", "_surprise", "_executedSurprises", "_surpriseID", "_surpriseTimeSec", "_condition", "_isExecuted", "_surpriseArgs", "_timeInSek", "_enemyFrequency", "_spawnSegment"];

_minEnemySkill = _this select 0;
_maxEnemySkill = _this select 1;
_enemyFrequency = _this select 2;
if (count _this > 3) then { _debug = _this select 3; } else { _debug = false; };
// Create all surprises

waitUntil {([drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists)};

_surprises = [];

// A surprise have members [ID, MissionTimeSec, Condition, IsExecuted, Surprice Arguments].

// Drop Chopper

_surpriseArgs = [(_enemyFrequency + 2) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
_timeInSek = 5 * 60 + random (60 * 60);
//_timeInSek = 10;
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_condition = {true};
_surprise = ["DROPCHOPPER", _timeInSek, _condition, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);


_surpriseArgs = [(_enemyFrequency + 4) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
_timeInSek = 5 * 60 + random (60 * 60);
//_timeInSek = 15;
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_condition = {true};
_surprise = ["DROPCHOPPER_I", _timeInSek, _condition, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Russian Search Chopper

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 45 * 60 + random (30 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["RUSSIANSEARCHCHOPPER", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

//Search Drone

if(count(missionNamespace getvariable ["a3e_arr_searchdrone",[]])>0) then
{
	_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
	_timeInSek = 5 * 60 + random (30 * 60);
	_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
	_surprise = ["SEARCHDRONE", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
	_surprises set [count _surprises, _surprise];
	diag_log ("ESCAPE SURPRISE: " + str _surprise);
};

//Leaflet Drone

if(count(missionNamespace getvariable ["a3e_arr_leafletdrone",[]])>0 || isNil "a3e_arr_leafletdrone") then
{
	_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
	_timeInSek = 5 * 60 + random (30 * 60);
	_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
	_surprise = ["LEAFLETDRONE", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
	_surprises set [count _surprises, _surprise];
	diag_log ("ESCAPE SURPRISE: " + str _surprise);
};

// Motorized Search Group

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 20 * 60 + random (60 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["MOTORIZEDSEARCHGROUP", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Reinforcement Truck

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 10 * 60 + random (30 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["REINFORCEMENTTRUCK", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Enemies in a civilian car

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 60 + random (60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["CIVILIANENEMY", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);


// Execute surprises

// Note: Everytime a surprise is played, a new surprise is added to the end of the list. The old surprise is left just sitting there never to be needed again... Probally requires re-writting. (Optionally make new surprises happen a tad more frequently over time)

_executedSurprises = 0;

while {true} do {
	private _index = -1;
    {
		_index = _index + 1;
        _surprise = _x;
        _surpriseID = _x select 0;
        _surpriseTimeSec = _x select 1;
        _condition = _x select 2;
        _isExecuted = _x select 3;
        _surpriseArgs = _x select 4;

        if (!_isExecuted && (time > _surpriseTimeSec)) then {
            //SystemChat Format["Spawning Escape Surprise: %1", _surpriseID];
			
            if (call _condition) then {
                _surprise set [3, true];
                _executedSurprises = _executedSurprises + 1;
                
                if (_debug) then {
                    ["Starting surprise: " + _surpriseID] call drn_fnc_CL_ShowDebugTextAllClients;
                };
                
                if (_surpriseID == "MOTORIZEDSEARCHGROUP") then {
					call DRN_fnc_SpawnMotorizedSearchGroupSurprise;				
				
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 20 * 60 + random (60 * 60);
                    _timeInSek = time + _timeInSek * (4 - _enemyFrequency);
                    _surprise = ["MOTORIZEDSEARCHGROUP", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: MOTORIZEDSEARCHGROUP";						
                };
                
                if (_surpriseID == "DROPCHOPPER") then {
					call DRN_fnc_SpawnDropChopperSurprise;

					// Create next drop chopper
					//_surpriseArgs = [(_enemyFrequency + 2) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
					_timeInSek = random (45 * 60);
					//_timeInSek = 15;
					_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
					_condition = {true};
					_surprise = ["DROPCHOPPER", _timeInSek, _condition, false, _surpriseArgs];
					_surprises set [_index, _surprise];
					diag_log ("ESCAPE SURPRISE: " + str _surprise);					
					
					//SystemChat "Escape Surprise: DROPCHOPPER";				
                };
                
				if (_surpriseID == "DROPCHOPPER_I") then {
					call DRN_fnc_SpawnDropChopperISurprise;

                    // Create next drop chopper
                    _surpriseArgs = [(_enemyFrequency + 2) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
                    _timeInSek = random (45 * 60);
					//_timeInSek =  15;
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _condition = {true};
                    _surprise = ["DROPCHOPPER_I", _timeInSek, _condition, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
					diag_log ("ESCAPE SURPRISE: " + str _surprise);					
					
					//SystemChat "Escape Surprise: DROPCHOPPER_I";							
                };
				
                if (_surpriseID == "RUSSIANSEARCHCHOPPER") then {
                    private ["_chopper", "_result", "_group","_helitype","_crewtype"];
                    _helitype = a3e_arr_O_attack_heli select floor(random(count(a3e_arr_O_attack_heli)));
					_crewtype = a3e_arr_O_pilots select floor(random(count(a3e_arr_O_pilots)));
                    //_chopper = "O_Heli_Light_02_F" createVehicle getMarkerPos "drn_russianSearchChopperStartPosMarker";
                    _chopper = createVehicle [_helitype, (getMarkerPos "drn_russianSearchChopperStartPosMarker"), [], 0, "FLY"];
                    _chopper lock false;
					[_chopper] call a3e_fnc_onVehicleSpawn;
                    _chopper setVehicleVarName "drn_russianSearchChopper";
                    _chopper call compile format ["%1=_this;", "drn_russianSearchChopper"];
                    
                    _group = createGroup A3E_VAR_Side_Opfor;

                    //"O_Pilot_F" createUnit [[0, 0, 30], _group, "", (_minEnemySkill + random (_maxEnemySkill - _minEnemySkill)), "LIEUTNANT"];
                    //"O_Pilot_F" createUnit [[0, 0, 30], _group, "", (_minEnemySkill + random (_maxEnemySkill - _minEnemySkill)), "LIEUTNANT"];
                    _group createUnit [_crewtype, [0, 0, 30], [], 0, "FORM"];
                    _group createUnit [_crewtype, [0, 0, 30], [], 0, "FORM"];

                    ((units _group) select 0) assignAsDriver _chopper;
                    ((units _group) select 0) moveInDriver _chopper;
                    ((units _group) select 1) assignAsGunner _chopper;
                    ((units _group) select 1) moveInGunner _chopper;
                    
                    {
                        _x setUnitRank "LIEUTENANT";
                        _x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
                    } foreach units _group;
                    
                    //[_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), a3e_var_Escape_debugSearchChopper] execVM "Scripts\DRN\SearchChopper\SearchChopper.sqf";
                    [_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), A3E_Debug] spawn DRN_fnc_SearchChopper;
                  
                    // Create new russian search chopper
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 30 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["RUSSIANSEARCHCHOPPER", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: RUSSIANSEARCHCHOPPER";						
                };
				
				
				if (_surpriseID == "SEARCHDRONE") then {
                    private ["_chopper", "_result"];

					_chopper = createVehicle [selectRandom a3e_arr_searchdrone, getMarkerPos "drn_russianSearchChopperStartPosMarker", [], random 360, "FLY"];
					createVehicleCrew _chopper;
					
					_chopper lock false;
					_chopper setVehicleVarName "a3e_searchdrone";
					_chopper call compile format ["%1=_this;", "a3e_searchdrone"];

                    
                    //[_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), a3e_var_Escape_debugSearchChopper] execVM "Scripts\DRN\SearchChopper\SearchChopper.sqf";
                    [_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), A3E_Debug] spawn A3E_fnc_SearchDrone;
                  
                    // Create new russian search chopper
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 30 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["SEARCHDRONE", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: SEARCHDRONE";								
                };
				
				if (_surpriseID == "LEAFLETDRONE") then {
                    private ["_chopper", "_result", "_group","_helitype","_arr","_dronetype"];
					
					_dronetype = missionnamespace getvariable ["a3e_arr_leafletdrone", ["I_UAV_06_F"]];
					_arr = [(getMarkerPos "drn_russianSearchChopperStartPosMarker"), 0, selectRandom _dronetype, A3E_VAR_Side_Ind] call bis_fnc_spawnvehicle;
					_chopper = _arr select 0;
					_group = _arr select 2;
					_chopper lock false;
					_chopper setVehicleVarName "a3e_leafletdrone";
					_chopper call compile format ["%1=_this;", "a3e_leafletdrone"];
					_chopper addmagazine "1Rnd_Leaflets_Guer_F";
					_chopper addweapon "Bomb_Leaflets";

                    
                    //[_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), a3e_var_Escape_debugSearchChopper] execVM "Scripts\DRN\SearchChopper\SearchChopper.sqf";
                    [_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), A3E_Debug] spawn A3E_fnc_LeafletDrone;
                  
                    // Create new russian search chopper
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 30 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["LEAFLETDRONE", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: LEAFLETDRONE";						
                };
                
                if (_surpriseID == "REINFORCEMENTTRUCK") then {
					call DRN_fnc_SpawnReinforcementTruckSurprise;                    
					
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["REINFORCEMENTTRUCK", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: REINFORCEMENTTRUCK";					
                };
                
                if (_surpriseID == "CIVILIANENEMY") then {
					call DRN_fnc_SpawnCivilianEnemySurprise;
                    
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 15 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["CIVILIANENEMY", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [_index, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
					
					//SystemChat "Escape Surprise: CIVILIANENEMY";
                };
            };
        };
		
    } foreach _surprises;
    
    sleep 5;
};


