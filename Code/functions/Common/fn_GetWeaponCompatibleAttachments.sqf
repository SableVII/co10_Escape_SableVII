params ["_selectedWeapon", "_attachmentName", ["_attachmentNameCBA", ""]];
private _compatibleItemsDirty = [];

// In case CBA is not installed
if (!isNil "CBA_fnc_compatibleItems") then 
{
	_compatibleItemsDirty = [_selectedWeapon, _attachmentNameCBA] call CBA_fnc_compatibleItems;
} else {
	_compatibleItemsDirty = compatibleItems [_selectedWeapon, _attachmentName];
};

private _compatibleItems = [];
{
	// If scope is == 2, then its a valid scope to spawn
	_weaponScope = getNumber(configFile >> "CfgWeapons" >> _x >> "scope");
	if (_weaponScope == 2) then
	{
		_compatibleItems pushback _x;
	};	 
} foreach _compatibleItemsDirty;
	
_compatibleItems;