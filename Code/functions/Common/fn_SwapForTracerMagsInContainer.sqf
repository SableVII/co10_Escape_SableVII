params ["_container", ["_factionSpecific", false], ["_faction", independent]];

if (isNull _container) exitWith
{
	false;
};

private _weaponInfoInBox = getWeaponCargo _container;	
private _magazineInfoInBox = getMagazineCargo _container;

private _weaponsInBox = _weaponInfoInBox select 0;
private _weaponsAmountInBox = _weaponInfoInBox select 1;

private _magazinesInBox = _magazineInfoInBox select 0;
private _magazinesInBox = _magazineInfoInBox select 0;
private _magazinesAmountInBox = _magazineInfoInBox select 1;
private _magsToAdd = []; //[[mag, magsToAdd]]	
{
	private _compatMags = [_x] call a3e_fnc_TryGetCompatibleWeaponMags;
	private _tracerMag = "";		
	for "_i" from 0 to (count _magazinesInBox - 1) do
	{
		private _mag = _magazinesInBox select _i;
		if (_mag == "") then { continue; };	  
		
		if ((toLower _mag) in _compatMags) then
		{				
			if (_tracerMag == "") then
			{
				_tracerMag = [_x] call a3e_fnc_GetWeaponTracerMagazine; 
				if (_tracerMag == "") then
				{
				   _tracerMag = "<none>";
				   continue; 
				};
			};

			if (_tracerMag == "<none>") then
			{
				continue;
			};
			
			// Remove pre-existing magazine
			_container addItemCargoGlobal [_mag, -1e38];
			_magsToAdd pushBack [_tracerMag, _magazinesAmountInBox select _i];
			_magazinesInBox set [_i, ""]; // to skip searching for future weapons again (optimization)
		};
	}; 
} forEach _weaponsInBox;

// Add tracer magazines to container
{
	_container addItemCargoGlobal [_x select 0, _x select 1];
	//systemChat Format["%1, %2", _x select 0, _x select 1];  
} forEach _magsToAdd;