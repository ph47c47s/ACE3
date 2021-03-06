/*
 * Author: commy2
 *
 * Check of the unit can reload the launcher of target unit.
 *
 * Argument:
 * 0: Unit to do the reloading (Object)
 * 1: Unit eqipped with launcher (Object)
 * 2: weapon name (String)
 * 3: missile name (String)
 *
 * Return value:
 * NONE
 */
#include "script_component.hpp"

private ["_unit", "_target", "_weapon", "_magazine"];

_unit = _this select 0;
_target = _this select 1;
_weapon = _this select 2;
_magazine = _this select 3;

if (!alive _target) exitWith {false};
if (vehicle _target != _target) exitWith {false};
if !([_unit, _target, []] call EFUNC(common,canInteractWith)) exitWith {false};

// target is awake
if (_target getVariable ["ACE_isUnconscious", false]) exitWith {false};

// has secondary weapon equipped
if !(_weapon in weapons _target) exitWith {false};

// check if the target really needs to be reloaded
if (count secondaryWeaponMagazine _target > 0) exitWith {false};

// check if the launcher is compatible
if (getNumber (configFile >> "CfgWeapons" >> _weapon >> QGVAR(enabled)) == 0) exitWith {false};

// check if the magazine compatible with targets launcher
_magazine in ([_unit, _weapon] call FUNC(getLoadableMissiles))
