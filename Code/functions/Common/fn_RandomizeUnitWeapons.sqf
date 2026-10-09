params ["_unit", ["_forceAttachmentSwaps", false], ["_forcePrimarySwap", false], ["_forceHandgunSwap", false], ["_forceSecondarySwap", false]];

if (_forcePrimarySwap or primaryWeapon _unit != "") then
{
	[_unit, primaryWeapon _unit, _forceAttachmentSwaps, 1] call A3E_FNC_SwapToRandomizedWeapon;	
};
if (_forceHandgunSwap or handGunWeapon _unit != "") then
{
	[_unit, handGunWeapon _unit, _forceAttachmentSwaps, 2] call A3E_FNC_SwapToRandomizedWeapon;	
};
if (_forceSecondarySwap or secondaryWeapon _unit != "") then
{
   [_unit, secondaryWeapon _unit, _forceAttachmentSwaps, 4] call A3E_FNC_SwapToRandomizedWeapon;
};