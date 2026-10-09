params ["_weapon"];
private _weaponName = toLower _weapon;
private _weaponCompatMagsMap = createHashMap;
		
if (_weapon in a3e_var_WeaponToCompatMagsMap) then {
	_weaponCompatMagsMap = a3e_var_WeaponToCompatMagsMap get _weaponName;
} else {
	private _compMagWells = []; 
	
	_weaponCompatMagsMap = createHashMap;
	{
		_weaponCompatMagsMap set [toLower _x, true];	
	}foreach getArray(configfile >> "CfgWeapons" >> _weapon >> "magazines");
	
	
	_compMagWells = getArray (configfile >> "CfgWeapons" >> _weapon >> "magazineWell");
	{
		private _mw = configProperties [configfile >> "CfgMagazineWells" >> _x, "isArray _x"];
		{
			private _tt = getarray(_x);
			{
				_weaponCompatMagsMap set  [toLower _x, true];
			} foreach _tt;
		} foreach _mw;
	} foreach _compMagWells;
					
	a3e_var_WeaponToCompatMagsMap set [_weaponName, _weaponCompatMagsMap];
};

_weaponCompatMagsMap;