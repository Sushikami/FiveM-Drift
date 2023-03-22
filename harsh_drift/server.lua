

local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/876616058247733298/TTmbXWtA9cKjXmkjGVOxlqgFk_7UfAucYQUvF16d2hF4mDZvAgr_VvYH_Jeu18fTei7K" -- Here you need write the id of the weebhook copied in the options of the channel
local DISCORD_NAME = "DriftKing" -- Write the name as you want, example ls-logs
local STEAM_KEY = "1B781F57CB4D61FEF4FADB318FC78756" -- Write here your steam key
local DISCORD_IMAGE = "" -- This its optional if you wont let it empty


local ActiveTracks = {}
local TrackHighScores = {}

RegisterServerEvent('drift:StartDriftTrack')
AddEventHandler('drift:StartDriftTrack', function(mapKey, drifterName)
  TriggerClientEvent('drift:StartDriftTrack', -1, mapKey, drifterName)
  ActiveTracks[""..source] = mapKey
end)

RegisterServerEvent('drift:EndDriftTrack')
AddEventHandler('drift:EndDriftTrack', function(mapKey, drifterName, newPoints)
  TriggerClientEvent('drift:EndDriftTrack', -1, mapKey, drifterName, newPoints)
  ActiveTracks[""..source] = nil

  if TrackHighScores[mapKey] then
    if TrackHighScores[mapKey].points < newPoints then
      -- if stored points is lower than new points
      TrackHighScores[mapKey] = {
        drifter = drifterName,
        points = newPoints
      }
      
      sendToDiscord("New Drift King for "..mapKey..":  "..drifterName.." at " .. newPoints)
      
    end
  else
    -- set new record if not currently available
    TrackHighScores[mapKey] = {
      drifter = drifterName,
      points = newPoints
    }
  end
end)

RegisterServerEvent('drift:CancelTrack')
AddEventHandler('drift:CancelTrack', function()
  if ActiveTracks[""..source] then
    TriggerClientEvent('drift:CancelTrack', -1, ActiveTracks[""..source])
    ActiveTracks[""..source] = nil
  end
end)

RegisterServerEvent('drift:SetCurrentTrackPoints')
AddEventHandler('drift:SetCurrentTrackPoints', function(mapKey, newPoints)
  TriggerClientEvent('drift:SetCurrentTrackPoints', -1, mapKey, newPoints)
end)

RegisterServerEvent('drift:GetCurrentTrackPoints')
AddEventHandler('drift:GetCurrentTrackPoints', function()
  TriggerClientEvent('drift:GetCurrentTrackPoints', source, TrackHighScores)
end)

-- Dropped players should cancel the current track
AddEventHandler('playerDropped', function (reason)
  if ActiveTracks[""..source] then
    TriggerClientEvent('drift:CancelTrack', -1, ActiveTracks[""..source])
    ActiveTracks[""..source] = nil
  end
end)


function sendToDiscord(name, message, color)
	local connect = {
		{
			["color"] = color,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
												["text"] = "DriftKing",
									 },
		}
	}
	PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
