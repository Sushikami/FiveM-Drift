-- Vehicle Drift Status
VehicleStatus = {
	driftPoints = 0,
	timeout = 0,
	driftSpeed = 0,
	speedMultiplier = 0,
	angleMultiplier = 0,
	driftMultiplier = 0
}

-- Main Loop
Citizen.CreateThread(function()
	while true do
		playerPed = PlayerPedId()
		playerVeh = GetVehiclePedIsIn(playerPed, false)
		vehCoords = GetEntityCoords(playerVeh)

		local x, y, z = table.unpack(vehCoords)

		if IsControlPressed(0, Config.Keys['LEFTSHIFT']) and IsControlPressed(0, Config.Keys['W']) then -- and (IsControlPressed(0, Config.Keys['A']) or IsControlPressed(0, Config.Keys['D'])) then
			if VehicleStatus.driftSpeed >= Config.DriftSpeed then
				drifting = true
				SetVehicleReduceGrip(playerVeh, true)
			end
		end

		if drifting and IsControlPressed(0, Config.Keys['LEFTSHIFT']) then
			VehicleStatus.timeout = Config.DriftTimeout
			SetVehicleReduceGrip(playerVeh, true)
		else
			SetVehicleReduceGrip(playerVeh, false)
		end

		if drifting and CurrentMapTrack then
			local pointsText = "Drift Points: "..VehicleStatus.driftPoints
			if VehicleStatus.driftMultiplier > 0 then
				pointsText = pointsText.." x"..VehicleStatus.driftMultiplier
			end
			DrawText3D(x, y, z + 1, pointsText, 255, 255, 255)
		end

		Citizen.Wait(0)
	end
end)

-- Tick drift points
Citizen.CreateThread(function()
	while true do Citizen.Wait(10)
		VehicleStatus.driftSpeed = GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 3.6
		if drifting and CurrentMapTrack then
			if VehicleStatus.driftSpeed >= Config.DriftSpeed then
				VehicleStatus.speedMultiplier = math.ceil((VehicleStatus.driftSpeed - Config.DriftSpeed) / Config.SpeedDivisor)
				VehicleStatus.driftMultiplier = VehicleStatus.speedMultiplier * VehicleStatus.angleMultiplier
				VehicleStatus.driftPoints = VehicleStatus.driftPoints + (Config.DriftTick * VehicleStatus.driftMultiplier)
			else
				VehicleStatus.timeout = 0
			end
		end
	end
end)

-- Check if no longer drifting
Citizen.CreateThread(function()
	while true do
		if drifting then
			while VehicleStatus.timeout > 0 do
				Citizen.Wait(10)
				VehicleStatus.timeout = VehicleStatus.timeout - 1
			end

			if CurrentMapTrack then
				TriggerServerEvent('drift:SetCurrentTrackPoints', CurrentMapTrack, VehicleStatus.driftPoints)
			end

			VehicleStatus.driftPoints = 0
			drifting = false
		else
			Citizen.Wait(50)
		end
	end
end)

-- Calculate car vector, and angle
Citizen.CreateThread(function()
	while true do Citizen.Wait(0)
    vehHeading = GetEntityHeading(playerVeh)

    if oldCoords then
      local x = oldCoords.x - vehCoords.x
      local y = vehCoords.y - oldCoords.y
      local h = math.sqrt(x^2 + y^2)
      local a = math.deg(math.asin(x/h))
      local vectorAngle

      if x >= 0 and y >= 0 then
        vectorAngle = a
      elseif x < 0 and y >= 0 then
        vectorAngle = 360 + a
      else
        vectorAngle = 180 - a
      end

			if vectorAngle >= 0 then
				local aDifference = angle_difference(vectorAngle, vehHeading)
				
				VehicleStatus.angleMultiplier = math.floor(aDifference / Config.AngleDivisor)

				if aDifference > Config.AngleDiffThreshold then
					VehicleStatus.angleMultiplier = 0
				end

				-- Angle Debug
				-- local angle_1 = round(vehHeading, 2)
				-- local angle_2 = round(vectorAngle, 2)
	      -- displayText = "h: "..angle_1.."\nH: "..angle_2.."\nD"..aDifference
				-- DrawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 1, displayText, 255, 255, 255)

			end
    end

    oldCoords = vehCoords
  end
end)

-- round down number to decimal place
function round(val, decimal)
  local power = 10^decimal
  return math.floor(val * power) / power
end

-- Get difference of two angles
function angle_difference(a, b)
	local r

	if a >= b then
		if a - b > 270 then
			a = 360 - a
			r = a + b
		else
			r = a - b
		end
	else
		if b - a > 270 then
			b = 360 - b
			r = a + b
		else
			r = b - a
		end
	end

	return r
end

-- Draw text in 3D space
function DrawText3D(x, y, z, text, r, g, b)
  local onScreen,_x,_y=World3dToScreen2d(x, y, z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

  local scale = (2 / dist)
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov

  if onScreen then
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
  end
end

Citizen.CreateThread(function()
    while true do
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        Citizen.Wait(1)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                if IsControlPressed(0, 21) then
                    SetVehicleReduceGrip(veh, true)
                end

                if IsControlJustReleased(0, 21) then
                    SetVehicleHandbrake(veh, true)
                    SetVehicleBrake(veh, true)
                    Citizen.Wait(1) -- adjust this number for brake bias
                    SetVehicleReduceGrip(veh, false)
                    SetVehicleHandbrake(veh, false)
                    SetVehicleBrake(veh, false)
                end
            end
        end
    end
end)