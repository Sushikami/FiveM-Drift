Config = {}

Config.DriftTimeout = 100 -- drift threshold in frame ticks to still consider a drift when [LEFT SHIFT] is no longer being pressed.

Config.DriftTick = 1 -- base drift-point tick.

Config.DriftSpeed = 40 -- minimum vehicle speed to be considered "drifting" (as opposed to just doing burnouts)

Config.SpeedDivisor = 30

Config.AngleDivisor = 10

-- value in degrees. This would cut of drift scoring if value is more than threshold
-- (i.e. accelerator cut-offs at this point if car is moving backwards from a drift)
Config.AngleDiffThreshold = 90

Config.Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config.ActivationDistance = 5.0

Config.DrawDistance = 20.0

Config.Tracks = {
	Hill_Pass1 = { Name = "Azuma Straight", Start = vector3(-721.72, 1003.07, 237.15), End = vector3(-134.02, 2845.94, 48.94), r=255, g=0, b=0, a=0.6 },
	Hill_Pass2 = { Name = "Akina Straight", Start = vector3(-1873.53, 2017.55, 139.47), End = vector3(-3080.78, 1187.1, 19.89), r=255, g=0, b=0, a=0.6 },
	Hill_Pass3 = { Name = "Irouha Straight", Start = vector3(-1633.29, 989.54, 151.97), End = vector3(1039.57, 711.26, 157.52), r=255, g=0, b=0, a=0.6 },
	Hill_Pass4 = { Name = "Haruna Straight", Start = vector3(281.76, 745.96, 182.7), End = vector3(-1958.99, 521.78, 108.33), r=255, g=0, b=0, a=0.6 },
	Hill_Pass5 = { Name = "Inazuma Straight", Start = vector3(839.69, 2227.5, 47.535), End = vector3(-1727.38, 89.55, 65.68), r=255, g=0, b=0, a=0.6 },
	Hill_Pass6 = { Name = "Suzumiya Straight", Start = vector3(237.57, 1356.9, 238.04), End = vector3(-1679.31, 2425.44, 27.90), r=255, g=0, b=0, a=0.6 },
}
