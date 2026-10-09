params ["_unit", "_weapon", ["_forceAttachmentSwaps", false], ["_typeHint", 1]];   

if (isNil "a3e_var_MuzzleToCompatMagsMap") then 
{
	a3e_var_MuzzleToCompatMagsMap = createHashMap;
};

scopeName "mainScope";

if (true) then
{
	private _weaponType = getNumber (configFile >> "CfgWeapons" >> _weapon >> "type");
	
	// If the Weapon type doesn't match a slot type, and the _typeHint doesn't match anything else, just return the weapon
	if (_weaponType <= 0 or _weaponType == 3 or _weaponType > 4) then
	{
		if (_typeHint != 1 and _typeHint != 2 and _typeHint != 4) exitWith
		{
			_weapon;			
		};
		
		_weaponType = _typeHint;
	};			

	private _weaponItems = weaponsItems _unit;		  
	
	private _weaponInfo = "";		
	{
		if (_x select 0 == _weapon) then
		{
			_weaponInfo = _x;
			break;
		};
	} forEach _weaponItems;			
	
	//systemChat Format["%1", _weaponInfo];		
	private _needsOptic = _forceAttachmentSwaps;
	private _needsMuzzle = _forceAttachmentSwaps;
	private _needsBipod = _forceAttachmentSwaps;
	private _needsRail = _forceAttachmentSwaps;			   
	
	// Cache attachments and remove previous weapon magazines	   
	if (typeName _weaponInfo == "ARRAY") then
	{
		// Determine if original weapon has attachments and new weapon should have attachemnts too
		_needsOptic = _needsOptic or _weaponInfo select 3 != "";
		_needsMuzzle = _needsMuzzle or _weaponInfo select 1 != "";
		_needsBipod = _needsBipod or _weaponInfo select 6 != "";
		_needsRail = _needsRail or _weaponInfo select 2 != "";		 
		
		// Remove all magazines from unit's inventory that match specific type
		private _currentMagInfo = _weaponInfo select 4;
		if (count _currentMagInfo > 0) then
		{
			_unit removeMagazines (_currentMagInfo select 0);
		};
		
		// Remove all compatible secondary (underbarrel) magazines from unit's inventory
		private _weaponMuzzles = getArray (configFile >> "CfgWeapons" >> _weapon >> "muzzles");
		{
			if (_x == "this" or _x == "SAFE") then
			{
				continue;
			};
			
			if (_x in a3e_var_MuzzleToCompatMagsMap == false) then 
			{					
				a3e_var_MuzzleToCompatMagsMap set [_x, compatibleMagazines [_weapon, _x]];  
			};
			
			private _muzzleMags = a3e_var_MuzzleToCompatMagsMap get _x;
			{
				_unit removeMagazines _x;
			} forEach _muzzleMags;

		} forEach _weaponMuzzles;	
	};																			  
	  
			 
	// Remove weapon from player
	_unit removeWeapon [_weapon];

	private _maxMass = getNumber (configFile >> "CfgInventoryGlobalVariable" >> "maxSoldierLoad") * 0.9; // Leave 0.1 mass at most
   
	// New weapon info
	private _newWeaponInfo = [_weapon, _weaponType] call A3E_FNC_ConvertToRandomWeapon;
	private _newWeapon = _newWeaponInfo select 0;
	private _currentMass = loadAbs _unit;
	
	// Check to see if adding a secondary will put the unit over the max mass
	if (_weaponType == 4) then
	{
		private _newWeaponMass = getNumber (configFile >> "CfgWeapons" >> _newWeapon >> "WeaponSlotsInfo" >> "mass");
		private _magMass = getNumber (configFile >> "CfgMagazines" >> (_newWeaponInfo select 1) select 0 >> "mass"); 
		if (_currentMass + _newWeaponMass + _magMass > _maxMass) then // with a little extra padding
		{
			breakOut "mainScope";
		};		  
	};
	 
	// Actually add weapon   
	_unit addWeapon _newWeapon;					

	// Remove default weapon attachments (some come with weapons)
	switch (_weaponType) do
	{
		case 1:
		{
			removeAllPrimaryWeaponItems _unit;
			_unit selectWeapon (primaryWeapon _unit);			 
		};
		case 2:
		{
			removeAllHandgunItems _unit;
		};
		case 4:
		{
			removeAllSecondaryWeaponItems _unit;
		};
	};
													
	// Add magazines to unit
	private _magData = _newWeaponInfo select 1;
	private _mag = _magData select 0;
	private _magsToAdd = round ((_magData select 1) + round random (_magData select 2));
	private _magMass = getNumber (configFile >> "CfgMagazines" >> _mag >> "mass");

	// Add mag directly to weapon
	_unit addWeaponItem [_newWeapon, _mag];
	_currentMass = _currentMass + _magMass; 
			
	for "_i" from 1 to _magsToAdd do
	{
		if ((_unit canAdd _mag) == false and _currentMass + _magMass > _maxMass) then
		{ 
			break; 
		};
	
		_unit addMagazine _mag;
		_currentMass = _currentMass + _magMass;	
	};
							
	// Grenade launcher ammo adding
	private _muzzleMagInfo = _newWeaponInfo select 2;
	if (typeName _muzzleMagInfo != "STRING") then
	{
		private _muzzleMagData = _muzzleMagInfo select 1; 
		private _muzzleMag = _muzzleMagData select 0;
		private _grenadesToAdd = _muzzleMagData select 1 + round (random (_muzzleMagData select 2));
		private _grenadeMagMass = getNumber (configFile >> "CfgMagazines" >> _muzzleMag >> "mass");
						
		// Add directly to weapon's muzzle
		_unit addWeaponItem [_muzzleMagInfo select 0, _muzzleMag];
		_currentMass = _currentMass + _grenadeMagMass;				 

		for "_i" from 1 to _grenadesToAdd do
		{
			if ((_unit canAdd _muzzleMag) == false and _currentMass + _grenadeMagMass > _maxMass) then 
			{ 
				break;
			};
					
			_unit addMagazine _muzzleMag;
			_currentMass = _currentMass + _grenadeMagMass;								
		};
		
		private _flareMags = _muzzleMagInfo select 2;
		if (count _flareMags > 0) then
		{
			private _flaresToAdd = 2 + round random 3;
			for "_i" from 1 to _flaresToAdd do
			{
				private _flare = _flareMags select (floor random (count _flareMags));
				private _flareMass = getNumber (configFile >> "CfgMagazines" >> _flare >> "mass");
				if ((_unit canAdd _flare) == false and _currentMass + _flareMass > _maxMass) then
				{
					break; 
				};
						
				_unit addMagazine _flare;
				_currentMass = _currentMass + _flareMass;				
			};		
		}; 
	};
	
	
	if (_needsOptic) then
	{
		private _attachment = _newWeaponInfo select 3;
		_unit addWeaponItem [_newWeapon, _attachment select (floor random (count _attachment))];			
	};
	if (_needsMuzzle) then
	{
		private _attachment = _newWeaponInfo select 4;
		_unit addWeaponItem [_newWeapon, _attachment select (floor random (count _attachment))];			
	};
	if (_needsBipod) then
	{
		private _attachment = _newWeaponInfo select 5;
		_unit addWeaponItem [_newWeapon, _attachment select (floor random (count _attachment))];			
	};
	if (_needsRail) then
	{
		private _attachment = _newWeaponInfo select 6;
		_unit addWeaponItem [_newWeapon, _attachment select (floor random (count _attachment))];			
	};
};		