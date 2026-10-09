params["_unit"];
_unit setVehicleAmmo (0.2 + random 0.4); 

// Get _isNight
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

//Hopefully fixing BIS broken scripts:
private _AISkill = 0.1;
switch (A3E_Param_EnemySkill) do {
	case 0: { _AISkill = 0.1; };
	case 1: { _AISkill = 0.2; };
	case 2: { _AISkill = 0.3; };
	case 3: { _AISkill = 0.4; };
	case 4: { _AISkill = 0.5; };
	default { _AISkill = 0.2; };
};
_unit setskill _AISkill;
_unit setskill ["spotdistance", _AISkill];
_unit setskill ["aimingaccuracy", _AISkill]; 
_unit setskill ["aimingshake", _AISkill]; 
_unit setskill ["spottime", _AISkill];
_unit setskill ["commanding", _AISkill];

_unit removeItem "FirstAidKit";

// Chance for a random scope (and no scope):
if(random 100 < 70) then {
	removeAllPrimaryWeaponItems _unit;
	if((random 100 < 30)) then {
		private _currentItem = (primaryWeaponItems _unit) select 2; // Remove optic	
		
		_scopes = A3E_arr_Scopes;
		if(A3E_Param_NoNightvision==0) then {
			_scopes = _scopes + A3E_arr_TWSScopes;
			_scopes = _scopes + A3E_arr_NightScopes;			
		};

		_scope = selectRandom _scopes;
		_unit addPrimaryWeaponItem _scope;
	};
};

// NVGoggles
private _nvgs = hmd _unit; 
if (_nvgs isEqualTo "") then {
	// Find some unequiped NVGs on the unit if any
	private _cfgWeapons = configFile >> "CfgWeapons";
	{
		if (616 == getNumber (_cfgWeapons >> _x >> "ItemInfo" >> "type")) exitWith {
			_nvgs = _x;
		};
	} forEach items _unit;
};

if (A3E_Param_NoNightvision>0) then
{
	// Remove night vision
	if (random 100 > 2) then
	{
		_unit unlinkItem _nvgs;
		_unit removeItem _nvgs;	
	};
} else {
	if(_nvgs != "") then {
		// If NVGs were found, have a chance to remove them
		if (((_isNight) and (random 100 < 4)) or (!(_isNight) and (random 100 > 5))) then
		{
			_unit unlinkItem _nvgs;
			_unit removeItem _nvgs;	
		};
	} else {
		// If NVGs were not found, have a chance to add vanilla night vision if supported by mission type
		if (((_isNight) and (random 100 < 40)) or (!(_isNight) and (random 100 < 5))) then
		{
			if (missionnamespace getvariable ["A3E_Var_AllowVanillaNightVision", true]) then
			{
				_unit linkItem "NVGoggles_OPFOR";
			};
		};
	};
};


// Chance for random attachment
if(random 100 < 70) then
{
	if (A3E_Param_NoNightvision > 0) then {
		_unit addPrimaryWeaponItem "acc_flashlight";
	} else {
		if (random 100 < 50 or _isNight == false) then
		{		
			_unit addPrimaryWeaponItem "acc_flashlight";
		} else {
			_unit addPrimaryWeaponItem "acc_pointer_IR";
			_unit linkItem "NVGoggles_OPFOR";
		};
	};
};

// Bipod chance
if((random 100 < 20)) then {
	_unit addPrimaryWeaponItem (selectRandom a3e_arr_Bipods);
};

// Chance for silencers
//if((random 100 < 10)) then {
//	
//};

// Remove Maps
private _mapItems = missionNamespace getVariable ["A3E_MapItemsUsedInMission",["ItemMap"]]; // Remove potentially loose maps in inventory
{_unit removeItems _x;} foreach _mapItems;
if (random 100 > 13) then {
	{_unit unlinkItem _x;} foreach _mapItems;
	_unit unlinkItem (_unit getSlotItemName 608); // 608 Map Slot
};

// Remove Compasses
_unit removeItems "ItemCompass"; // remove potential loose compasses in inventory
if (random 100 > 22.5) then {
	_unit unlinkItem (_unit getSlotItemName 609);
};

// Make units sometimes not have backpacks
if (random 100 > 77) then {
	removeBackpackGlobal _unit;
};

// Removing GPS
if (random 100 > 3) then {
	_unit unlinkItem (_unit getSlotItemName 612); // 612 GPS Slot
};

// Removing binocular/range finder slot
if (random 100 > 30) then {
	_unit unlinkItem (_unit getSlotItemName 617); // 617 Binoculars/Rangefinder slot
};

// Remove additional items
private _itemsToRemove = missionNamespace getVariable ["A3E_ItemsToBeRemoved",[]];
{
	private _items = items _unit;
	if(random 100 > 30) then {
		_unit unlinkItem _x;
	};
} foreach _itemsToRemove;

// Add intel
if(A3E_Param_UseIntel==1) then {
	[_unit] call A3E_fnc_AddIntel;
};

// Randomize weapons
if (A3E_Param_RandomizeWeapons != 0) then {
	[_unit, random 100 < 1, true, random 100 < 7, random 100 < 1] call A3E_FNC_RandomizeUnitWeapons;
	
	// Ensure proper lights are added to units at night
	if(random 100 < 70) then {
		_unit removePrimaryWeaponItem ((primaryWeaponItems _unit) select 1); // Remove rail slot item to garuntee flashlight addition
		_unit addPrimaryWeaponItem "acc_flashlight";
	};
};

// Replacing mags with tracer mags
if (A3E_Param_TracerReplacer == 1) then {
	[_unit,  (A3E_Param_TracerReplacer == 2)] call A3E_FNC_SwapUnitMagsForTracers;
};



// Bind to OnKilled Event
_unit addEventHandler ["Killed", {params ["_unit"]; [_unit] call A3E_fnc_OnAIKilled;}];

//Track kills
_unit addEventHandler ["Killed", {
	params ["_unit", "_killer"];
	if(isPlayer _killer) then {
		private _killStats = missionNamespace getvariable ["A3E_Kill_Count",0];
		missionNamespace setvariable ["A3E_Kill_Count",_killStats+1,false];
	};
}];
