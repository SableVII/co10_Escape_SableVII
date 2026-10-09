params ["_unit", ["_factionSpecific", false]];

private _ReplaceMagsInContainer = {
	params ["_container", "_compatibleWeaponMags", "_tracerMag"];
			
	private _leftoverMagAmmos = []; // [[Original Mag Name, Replacement Mag Name, Original Ammo Count]]
	if (isNull _container == false) then {
		private _magsToReplace = []; //[[Original Mag Name, Replacement Mag Name, Original Ammo Count]]
		
		// Find mags in container
		{
			if (toLower (_x select 0) in _compatibleWeaponMags) then
			{
				_magsToReplace pushBack _x;				 
			};							   
		} foreach magazinesAmmoCargo _container;
		
		// Remove original mags with a replacement from the container
		{
			_container addMagazineCargoGlobal [_x select 0, -1]; // Removes one magazine of type
		} foreach _magsToReplace;
					
		// Place new mags in container
		{
			if (_container canAdd [_tracerMag, 1]) then {
				_container addMagazineAmmoCargo [_tracerMag, 1, _x select 1];	 
			} else {
				_leftoverMagAmmos pushBack [_x select 1];
			};
		} foreach _magsToReplace;
	};

	_leftoverMagAmmos;	   
};

private _ReplaceMagsInUnit = {
	params ["_unit", "_weapon", "_tracerMag"];
	private _compatibleWeaponMags = a3e_var_WeaponToCompatMagsMap get (toLower _weapon);
	if (count _compatibleWeaponMags == 0) exitWith
	{
		false;
	}; 
				 
	// Go through the pockets, and attempt to add the magazine to the correct pockets. If the new mag cannot fit, just try adding the ammo to any pocket.
	private _leftoverMagAmmos = []; // [[Original Mag Name, Replacement Mag Name, Original Ammo Count]];
	
	// Uniform
	_leftoverMagAmmos append ([uniformContainer _unit, _compatibleWeaponMags, _tracerMag] call _ReplaceMagsInContainer);
	
	// Vest
	_leftoverMagAmmos append ([vestContainer _unit, _compatibleWeaponMags, _tracerMag] call _ReplaceMagsInContainer);
	
	// Backpack
	_leftoverMagAmmos append ([backpackContainer _unit, _compatibleWeaponMags, _tracerMag] call _ReplaceMagsInContainer);
	
	// Add whatever leftover mags to the player. The original mags should already be removed.
	{
		_unit addMagazine [_tracerMag, _x];		
	} foreach _leftoverMagAmmos;
	
	true; 
};	

private _side = side _unit;

// Primary
private _primaryWeapon = primaryWeapon _unit;
if (_primaryWeapon != "") then
{
	private _primaryTracerMag = [_primaryWeapon, _factionSpecific, _side] call a3e_fnc_GetWeaponTracerMagazine;
	
	if (_primaryTracerMag != "") then
	{
		[_unit, _primaryWeapon, _primaryTracerMag] call _ReplaceMagsInUnit;
	
		if ((primaryWeaponMagazine _unit) select 0 != "") then
		{
			_unit addWeaponItem [_primaryWeapon, [_primaryTracerMag, _unit ammo _primaryWeapon], true];		   
		};
	};
};

// Handgun
private _handgunWeapon = handgunWeapon _unit;	
if (_handgunWeapon != "") then
{
	private _handgunTracerMag = [_handgunWeapon, _factionSpecific, _side] call a3e_fnc_GetWeaponTracerMagazine;
	
	if (_handgunTracerMag != "") then
	{
		[_unit, _handgunWeapon, _handgunTracerMag] call _ReplaceMagsInUnit;
	
		if (count (handgunMagazine _unit) != 0) then
		{
			_unit addWeaponItem [_handgunWeapon, [_handgunTracerMag, _unit ammo _handgunWeapon], true];		   
		};			   
	};								
};

true;