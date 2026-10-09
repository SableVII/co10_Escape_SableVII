params [["_givenWeaponArray", []], ["_filterExtremePrimaries", true]];   
 
a3e_var_RandomWeaponPool = [];
a3e_var_RandomHandgunWeaponPool = [];
a3e_var_RandomSecondaryWeaponPool = [];

private _weaponConfigs = [];
{
	private _weaponConfig = (configFile >> "CfgWeapons" >> _x);
	if (isNull _weaponConfig == false) then
	{
			_weaponConfigs pushBack (configFile >> "CfgWeapons" >> _x);
	};
} forEach _givenWeaponArray;  

// Grab all classes if nothing is in the _givenWeaponArray param
if (count _weaponConfigs <= 0) then
{
	_weaponConfigs = ("true" configClasses (configFile >> "CfgWeapons"));
};
	
// Populate all primary weapon list 
{		
	if (getNumber (_x >> "scope") != 2) then
	{
		continue;
	};
					
	private _type = getNumber (_x >> "type");
	if (_type == 1) then
	{
		if ((configName _x) in a3e_var_RandomWeaponPool) then 
		{ 
			continue; 
		};	
	
		if (_filterExtremePrimaries) then
		{
			private _name = getText (_x >> "displayName");
			if ("Flamethrower" in _name) then
			{
				continue;
			};
		
			private _weaponDescription = getText (_x >> "descriptionShort");		
			if (("Grenade" in _weaponDescription or "Rocket" in _weaponDescription) and "Assault" in _weaponDescription == false) then
			{
				continue;
			};	
		};		   
					
		a3e_var_RandomWeaponPool pushback configName _x;			
	};
	
	if (_type == 2) then
	{
		if ((configName _x) in a3e_var_RandomHandgunWeaponPool) then 
		{ 
			continue; 
		};
	
		private _name = getText (_x >> "displayName");
		if ("Spectrum" in _name or "Periscope" in _name or "Image" in _name) then
		{
			continue;
		};		
	
		private _weaponDescription = getText (_x >> "descriptionShort");		
		if ("Metal detector" in _weaponDescription or "flashlight" in _weaponDescription) then
		{
			continue;
		};
		
		a3e_var_RandomHandgunWeaponPool pushback configName _x;
	};
	
	if (_type == 4) then
	{
		if ((configName _x) in a3e_var_RandomSecondaryWeaponPool) then 
		{ 
			continue; 
		};		
	
		// Need to check for non-useful launchers
		private _magazines = getArray (_x >> "magazines");
		private _handAnims = getArray (_x >> "handAnim");
 
		if (count _magazines <= 0 or count _handAnims <= 0) then
		{
			continue;
		};			 
	
		a3e_var_RandomSecondaryWeaponPool pushback configName _x;		
	};				 
} forEach _weaponConfigs;
