params ["_weapon", ["_typeHint", 1]];

if (isNil "a3e_var_WeaponToWeaponMap") then 
{
	a3e_var_WeaponToWeaponMap = createHashMap;
};

if (isNil "a3e_var_RandomWeaponPool") then
{
	a3e_var_RandomWeaponPool = [];
};

if (isNil "a3e_var_RandomHandgunWeaponPool") then
{
	a3e_var_RandomHandgunWeaponPool = [];
};

if (isNil "a3e_var_RandomSecondaryWeaponPool") then
{
	a3e_var_RandomSecondaryWeaponPool = [];
};			

if (isNil "a3e_var_MuzzleToCompatMagsMap") then
{
	a3e_var_MuzzleToCompatMagsMap = createHashMap;
};

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
	
if (_weapon in a3e_var_WeaponToWeaponMap == false) then
{
	private _weaponInfo = [];
	private _selectedWeapon = "";
	private _weaponExtraInfo = "";
	
	// Only choosing first compatible mag as its likely to corrispond to the most 'correct' use of the weapon: 30rnd Mag for M16, 200rnd belt for M249.
	private _mag = "";
	private _magCapacity = 0;
	private _magCount = 2; // Roughly: (200, 1), (100, 2), (30, 5), (20, 7), (10, 10), (5, 15), (1, 25)
	private _magExtraCount = 1; // Roughly: (200, 1), (100,1.2), (30, 2), (20, 2.2), (10, 3), (1, 4)

	// Get a random weapon to tie it to the current primary weapon
	if (count a3e_var_RandomWeaponPool == 0 and count a3e_var_RandomHandgunWeaponPool == 0 and count a3e_var_RandomSecondaryWeaponPool == 0) then
	{
		[] call A3E_FNC_PopulateWeaponArray;	  
	};
	
	// Primary Weapons
	if (_weaponType <= 1) then 
	{			
		if (count a3e_var_RandomWeaponPool == 0) exitWith { };
		
		_selectedWeapon = a3e_var_RandomWeaponPool select (floor random (count a3e_var_RandomWeaponPool));
		
		// Only choosing first compatible mag as its likely to corrispond to the most 'correct' use of the weapon: 30rnd Mag for M16, 200rnd belt for M249.
		_mag = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "magazines") select 0;
		_magCapacity = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
		_magCount = round(165 / (_magCapacity + 12.5)) + ((0.00000025 * _magCapacity ^ 3) + (0.0000271 * _magCapacity ^ 2) - (0.03555 * _magCapacity) + 1.53553); // Roughly: (200, 1), (100, 2), (30, 5), (20, 6), (10, 8), (5, 10), (1, 15)
		_magExtraCount = 7.98 * (_magCapacity ^ -0.416); // Roughly: (200, 1), (100,1.2), (30, 2), (20, 2.2), (10, 3), (1, 8)
		
		if (_magCapacity == 1) then
		{
			_magCount = _magCount * 2;
		};
		
		if (_magCapacity == 20) then
		{
			_magCount = _magCount + 2;
			_magExtraCount = _magExtraCount + 1;
		};
		
		_magCount = 1.55 max _magCount;
		
		private _weaponDescription = getText (configFile >> "CfgWeapons" >> _selectedWeapon >> "descriptionShort");
		
		if ("submachine" in toLower _weaponDescription ) then
		{
			_magCount = round(_magCount * 2.0);
		};
			
		if (("Grenade" in _weaponDescription or "Rocket" in _weaponDescription) and "Assault" in _weaponDescription == false) then
		{
			_magCount = round(_magCount * 0.25);
		};
		
		if (".50" in _weaponDescription or ".338" in _weaponDescription) then
		{
			_magCount = round(_magCount * 0.75);
		};			 
	};
	
	// Handgun Weapons
	if (_weaponType == 2) then
	{			
		if (count a3e_var_RandomHandgunWeaponPool == 0) exitWith { };
		
		_selectedWeapon = a3e_var_RandomHandgunWeaponPool select (floor random (count a3e_var_RandomHandgunWeaponPool));			

		// Only choosing first compatible mag as its likely to corrispond to the most 'correct' use of the weapon: 30rnd Mag for M16, 200rnd belt for M249.
		_mag = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "magazines") select 0;
		_magCapacity = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
		_magCount = 1;
		_magExtraCount = 1;			
	};
	
	// Secondary Weapons
	if (_weaponType == 4) then
	{			
		if (count a3e_var_RandomSecondaryWeaponPool == 0) exitWith { };
		
		_selectedWeapon = a3e_var_RandomSecondaryWeaponPool select (floor random (count a3e_var_RandomSecondaryWeaponPool));			

		// Only choosing first compatible mag as its likely to corrispond to the most 'correct' use of the weapon: 30rnd Mag for M16, 200rnd belt for M249.
		_mag = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "magazines") select 0;
		_magCapacity = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
		_magCount = 0;
		_magExtraCount = 2;
		
		// Checking for disposable
		private _disposable = false;
		private _mags = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "magazines");
		{
			if ("Fake" in _x) then
			{
				_disposable = true;					
			};
		} forEach _mags;
		
		// Checking for disposable - some have this value
		private _agmTube = getText (configFile >> "CfgWeapons" >> _selectedWeapon >> "AGM_UsedTube");
		if (_agmTube != "") then
		{
			_disposable = true;					
		};
		
		// Maybe I can find more single-shot/disposable weapons via descriptions
		private _weaponDescription = toLower getText (configFile >> "CfgWeapons" >> _selectedWeapon >> "descriptionShort");
		if ("single-shot" in _weaponDescription or "disposable" in _weaponDescription) then
		{
			_disposable = true;			
		};
		
		// Another possible one
		private _weaponInfoType = toLower getText (configFile >> "CfgWeapons" >> _selectedWeapon >> "weaponInfoType");
		if ("single-shot" in _weaponInfoType or "disposable" in _weaponInfoType) then
		{
			_disposable = true;							 
		};
		
		if (_disposable) then
		{
			_magCount = 0;
			_magExtraCount = 0;
			_weaponExtraInfo = _weaponExtraInfo + "disposable";
		};			
	};					   
			
	_weaponInfo pushBack _selectedWeapon;		
	_weaponInfo pushBack [_mag, _magCount, _magExtraCount];
		   
	// Get the muzzle magazine if any (grenade launcher)
	private _muzzles = getArray (configFile >> "CfgWeapons" >> _selectedWeapon >> "muzzles");
	if (count _muzzles > 1) then
	{
		private _muzzle1 = _muzzles select 1;

		if (_muzzle1 in a3e_var_MuzzleToCompatMagsMap == false) then 
		{
			a3e_var_MuzzleToCompatMagsMap set [_muzzle1, compatibleMagazines [_selectedWeapon, _muzzle1]];  
		};
		
		private _muzzleMags = a3e_var_MuzzleToCompatMagsMap get _muzzle1;
		private _primaryMuzzleMag = _muzzleMags select 0;	   
		private _primaryMuzzleMagRoundCount = getNumber (configFile >> "CfgMagazines" >> _primaryMuzzleMag >> "count");
		private _primaryMuzzleMagCount = 2;
		private _primaryMuzzleRandomExtraCount = 3;
		if (_primaryMuzzleMagRoundCount > 1) then
		{
			_primaryMuzzleMagCount = 0;
			_primaryMuzzleRandomExtraCount = 1;			
		};
					
		// Find illuminating flare munitions (makes for great night-time fighting)
		private _illuminatingFlares = [];
		{
			if (getNumber (configFile >> "CfgMagazines" >> _x >> "scope") != 2 or getNumber (configFile >> "CfgMagazines" >> _x >> "type") != 16) then
			{
				continue;
			};
			
			private _magLowerName = toLower _x;
			
			// Ignore 3rnd grenade launcher rounds
			if ("3rnd" in _magLowerName) then
			{
				continue;
			};
			
			// Check for flares
			if ("flare" in _magLowerName == false) then
			{
				// Special case for dumb RHS illuminating rounds
				if (("m583" in _magLowerName == true) or ("m661" in _magLowerName == true) or ("m662" in _magLowerName == true) or ("40op" in _magLowerName == true)) then				
				{				
					//_debugString = _debugString + format[toString [13, 10] + "%1", _mag];
					_illuminatingFlares pushBack _x;
				};
				
				continue;
			};
			
			if ("illu" in _magLowerName or "ilu" in _magLowerName or "starflare" in _magLowerName) then
			{
				//_debugString = _debugString + format[toString [13, 10] + "%1", _mag];
				_illuminatingFlares pushBack _x;
				continue;	  
			};	
		} forEach _muzzleMags;
					
		_weaponInfo pushBack [_muzzle1, [_primaryMuzzleMag, _primaryMuzzleMagCount, _primaryMuzzleRandomExtraCount], _illuminatingFlares];
	} else {
		_weaponInfo pushBack "none";
	};
				
	// https://community.bistudio.com/wiki/compatibleItems
	// https://cbateam.github.io/CBA_A3/docs/files/jr/fnc_compatibleItems-sqf.html
	 
	// Get possible optics attachments
	_weaponInfo pushBack ([_selectedWeapon, "CowsSlot", "optic"] call A3E_FNC_GetWeaponCompatibleAttachments);

	// Get possible muzzle attachments
	_weaponInfo pushBack ([_selectedWeapon, "MuzzleSlot", "muzzle"] call A3E_FNC_GetWeaponCompatibleAttachments);
				
	// Possible bipod attachments
	_weaponInfo pushBack ([_selectedWeapon, "BipodSlot", "bipod"] call A3E_FNC_GetWeaponCompatibleAttachments);
		
	// Possible rail attachments
	_weaponInfo pushBack ([_selectedWeapon, "PointerSlot", "pointer"] call A3E_FNC_GetWeaponCompatibleAttachments);
  
	// Extra info as string
	_weaponInfo pushBack _weaponExtraInfo;
	
	// Put weapon info into HashMap
	a3e_var_WeaponToWeaponMap set [_weapon, _weaponInfo];  
};
	
a3e_var_WeaponToWeaponMap get _weapon;