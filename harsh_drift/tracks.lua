


-- Add track blips to map
Citizen.CreateThread(function()
  for _,track in pairs(Config.Tracks) do
    track.blip = AddBlipForCoord(track.Start)
    SetBlipSprite(track.blip, 315)
    SetBlipDisplay(track.blip, 4)
		SetBlipScale(track.blip, 1.0)
    SetBlipColour(track.blip, 1)
    SetBlipAsShortRange(track.blip, true)
  	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(track.Name)
    EndTextCommandSetBlipName(track.blip)
  end
end)

Citizen.CreateThread(function()
  TriggerServerEvent('drift:GetCurrentTrackPoints')

  while true do Citizen.Wait(0)
    while not IsPedInAnyVehicle(playerPed, true) do Citizen.Wait(100)
      if TrackStarted then
        TrackStarted = false
        CurrentMapTrack = nil
        CurrentDrifter = nil
        TriggerServerEvent('drift:CancelTrack')
        print("You have been disqualified for this track.")
      end
    end

    for k,v in pairs(Config.Tracks) do
      local distanceToStart = GetDistanceBetweenCoords(v.Start, vehCoords, true)
      if distanceToStart <= Config.DrawDistance then

        if not v.Started and not CurrentMapTrack then
          DrawMarker(1, v.Start, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.5, v.r, v.g, v.b, v.a, 0, 1, 2, 0, 0, 0, 0)
          if distanceToStart <= Config.ActivationDistance then
            local bannerText = ""
            if v.RecordDrifter and v.RecordPoints then
              bannerText = "DriftKing: "..v.RecordDrifter.." ["..v.RecordPoints.."]"
            end
            if v.LastDrifter and v.LastPoints then
              bannerText = bannerText.."\nCurrent: "..v.LastDrifter.." ["..v.LastPoints.."]"
            end

            DrawText3D(v.Start.x, v.Start.y, v.Start.z + 2.0, "[E] "..v.Name.."\n"..bannerText, 255, 255, 255)

            if IsControlJustReleased(0, Config.Keys['E']) then
              v.TimePenalty = 0
              CurrentMapTrack = k
              CurrentDrifter = GetPlayerName(PlayerId())
              SetNewWaypoint(v.End.x, v.End.y)
              TriggerServerEvent('drift:StartDriftTrack', CurrentMapTrack, CurrentDrifter)
            end
          end
        else
          if v.CurrentPoints then
            local bannerText = ""
            if v.RecordDrifter and v.RecordPoints then
              bannerText = "DriftKing: "..v.RecordDrifter.." ["..v.RecordPoints.."]\n"
            end

            bannerText = bannerText..v.CurrentDrifter..": "..v.CurrentPoints
            DrawText3D(v.Start.x, v.Start.y, v.Start.z + 1.5, bannerText, 255, 255, 255)
          end
        end
      end

      if v.Started then
        TrackStarted = true

        if type(v.TimePenalty) == "number" then
          v.TimePenalty = v.TimePenalty + 1
        else
          v.TimePenalty = 0
        end

        local distanceToEnd = GetDistanceBetweenCoords(v.End, vehCoords, true)
        DrawMarker(1, v.End, 0, 0, 0, 0, 0, 0, 10.0, 10.0, 0.5, v.r, v.g, v.b, v.a, 0, 1, 2, 0, 0, 0, 0)
        if distanceToEnd <= Config.ActivationDistance * 2 then
          if CurrentDrifter then
            v.TimePenalty = math.floor(v.TimePenalty / 2)
            local rawPoints = VehicleStatus.driftPoints + v.CurrentPoints
            local finalPoints = rawPoints - v.TimePenalty

            TriggerServerEvent('drift:EndDriftTrack', CurrentMapTrack, CurrentDrifter, finalPoints)
            print(v.Name.." raw points: "..rawPoints.." (-"..v.TimePenalty.." time penalty)")

            v.Started = false
            TrackStarted = false
            CurrentMapTrack = nil
            CurrentDrifter = nil
          end
        end
      end

    end
  end
end)

RegisterNetEvent('drift:GetCurrentTrackPoints')
AddEventHandler('drift:GetCurrentTrackPoints', function(TrackHighScores)
  for mapKey,best in pairs(TrackHighScores) do
    Config.Tracks[mapKey].RecordDrifter = best.drifter
    Config.Tracks[mapKey].RecordPoints = best.points
  end
end)

RegisterNetEvent('drift:StartDriftTrack')
AddEventHandler('drift:StartDriftTrack', function(mapKey, drifterName)
  Config.Tracks[mapKey].CurrentPoints = 0
  Config.Tracks[mapKey].Started = true
  Config.Tracks[mapKey].CurrentDrifter = drifterName
end)

RegisterNetEvent('drift:EndDriftTrack')
AddEventHandler('drift:EndDriftTrack', function(mapKey, drifterName, newPoints)
  Config.Tracks[mapKey].Started = false
  if not Config.Tracks[mapKey].RecordPoints then
    Config.Tracks[mapKey].RecordDrifter = drifterName
    Config.Tracks[mapKey].RecordPoints = newPoints
  else
    if Config.Tracks[mapKey].RecordPoints < newPoints then
      -- Set new record holder
      Config.Tracks[mapKey].RecordDrifter = drifterName
      Config.Tracks[mapKey].RecordPoints = newPoints
    else
      -- Set last drifter points
      Config.Tracks[mapKey].LastDrifter = drifterName
      Config.Tracks[mapKey].LastPoints = newPoints
    end
  end
end)

RegisterNetEvent('drift:CancelTrack')
AddEventHandler('drift:CancelTrack', function(mapKey)
  Config.Tracks[mapKey].Started = false
end)

RegisterNetEvent('drift:SetCurrentTrackPoints')
AddEventHandler('drift:SetCurrentTrackPoints', function(mapKey, newPoints)
  Config.Tracks[mapKey].CurrentPoints = Config.Tracks[mapKey].CurrentPoints + newPoints
end)

