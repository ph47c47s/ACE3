#include "script_component.hpp"

#include "key.sqf"

// reload mutex, you can't play signal while reloading
GVAR(ReloadMutex) = true;

// PFH for Reloading
[{
    if (isNull (findDisplay 46)) exitWith {};
        // handle reloading
        (findDisplay 46) displayAddEventHandler ["KeyDown", {
        if ((_this select 1) in actionKeys "ReloadMagazine") then {
            _weapon = currentWeapon ACE_player;

            if (_weapon != "") then {
                GVAR(ReloadMutex) = false;

                _gesture  = getText (configfile >> "CfgWeapons" >> _this >> "reloadAction");
                _isLauncher = "Launcher" in ([configFile >> "CfgWeapons" >> _this, true] call BIS_fnc_returnParents);
                _config = ["CfgGesturesMale", "CfgMovesMaleSdr"] select _isLauncher;
                _duration = getNumber (configfile >> _config >> "States" >> _gesture >> "speed");

                if (_duration != 0) then {
                    _duration = if (_duration < 0) then { abs _duration } else { 1 / _duration };
                } else {
                    _duration = 3;
                };

                [{GVAR(ReloadMutex) = true;}, [], _duration] call EFUNC(common,waitAndExecute);
            };
        };
        false
        }];
    [_this select 1] call CBA_fnc_removePerFrameHandler;
}, 0,[]] call CBA_fnc_addPerFrameHandler;