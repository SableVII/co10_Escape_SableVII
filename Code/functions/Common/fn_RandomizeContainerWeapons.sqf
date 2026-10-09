params ["_container"];

if (isNull _container) exitWith
{
	false;
};

private _weaponInfoInBox = getWeaponCargo _container;
//systemChat format ["Weapon In Object: %1", _weaponInfoInBox];

private _magazineInfoInBox = getMagazineCargo _container;
//systemChat format ["Magazines In Object: %1", _magazineInfoInBox];

private _weaponsInBox = _weaponInfoInBox select 0;
private _weaponsAmountInBox = _weaponInfoInBox select 1;

private _magazinesInBox = _magazineInfoInBox select 0;
private _magazinesAmountInBox = _magazineInfoInBox select 1;

private _weaponIndexesToRemove = [];
for "_i" from 0 to (count _weaponsInBox - 1) do
{
	private _weapon = _weaponsInBox select _i;
	private _type = getNumber (configFile >> "CfgWeapons" >> _weapon >> "type");
	//systemChat format ["Type: %1", _type];
	
	if (_type == 1 or _type == 2 or _type == 4) then
	{
		//_container addItemCargoGlobal [_weapon, (_weaponsAmountInBox select _i) * -1];
		_weaponIndexesToRemove pushback _i;
	};
};


for "_i" from 0 to (count _magazinesInBox - 1) do
{
	private _mag = _magazinesInBox select _i;
	if (_mag isKindOf ["CA_Magazine", configFile >> "CfgMagazines"] == false and _mag isKindOf ["CA_LauncherMagazine", configFile >> "CfgMagazines"] == false) then
	{
		continue;
	};
	
	if (isThrowable _mag or _mag isKindOf ["HandGrenade", configFile >> "CfgMagazines"] == true or _mag isKindOf ["ATMine_Range_Mag", configFile >> "CfgMagazines"] == true) then
	{
		continue;
	};
	
	if (_mag isKindOf ["SatchelCharge_Remote_Mag", configFile >> "CfgMagazines"] == true or _mag isKindOf ["ACE_SatchelCharge_Remote_Mag_Throwable", configFile >> "CfgMagazines"] == true) then
	{
		continue;
	};
	
	if (getNumber (configFile >> "CfgMagazines" >> _mag >> "ace_explosives_placeable") != 0) then
	{
		continue;	
	};
			
	_container addItemCargoGlobal [_mag, -1e38];
};


// Remove all primary and handguns from the box
{
	_container addItemCargoGlobal [_weaponsInBox select _x, -1e38]
} forEach _weaponIndexesToRemove;


// Add weapon and magazines
{
	private _newWeaponInfo = ((_weaponsInBox select _x) call A3E_FNC_ConvertToRandomWeapon);   
	
	private _weaponsToAdd = (_weaponsAmountInBox select _x);
	
	private _weaponExtraInfo = _newWeaponInfo select 7;
	private _disposableLauncher = "disposable" in _weaponExtraInfo;   
	
	if ("disposable" in _weaponExtraInfo) then
	{
		  private _previousNumber = _weaponsToAdd;

		  for "_i" from 1 to _previousNumber do
		  {
			  _weaponsToAdd = _weaponsToAdd + round (1 + random 1.4);
		  };
	};
	
	// [muzzle, [muzzleMag, magCount, randomExtraMag], [flareMags]] or "none"
	private _magInfo = _newWeaponInfo select 1;
	private _muzzleInfo = _newWeaponInfo select 2;
	
	private _muzzleMagCargoInfo = [];
	if (typeName(_muzzleInfo) isEqualTo "ARRAY") then
	{
		private _muzzleMagInfo = _muzzleInfo select 1;	
	
		// Add grenade rounds
		_muzzleMagCargoInfo = [_muzzleMagInfo select 0, 1e38];
		_container addItemCargoGlobal [_muzzleMagInfo select 0, (_muzzleMagInfo select 1) * (_weaponsToAdd + 1)];
		
		// Adding flares
		private _flares = _muzzleInfo select 2;
		for "_i" from 1 to _weaponsToAdd do
		{
			//systemChat format ["Adding Flare: %1  Amount: %2", _flares select (floor random (count _flares)), 3 * _weaponsToAdd];
			_container addItemCargoGlobal [_flares select (floor random (count _flares)), 3 * _weaponsToAdd];			
		};
	}; 
				
	_container addWeaponWithAttachmentsCargoGlobal [[_newWeaponInfo select 0, "", "", "", [_magInfo select 1, 1e38], _muzzleMagCargoInfo, ""], _weaponsToAdd];
	_container addItemCargoGlobal [_magInfo select 0, ((_magInfo select 1) + (_magInfo select 2)) * (_weaponsToAdd + 1)];
	
} forEach _weaponIndexesToRemove;

true;