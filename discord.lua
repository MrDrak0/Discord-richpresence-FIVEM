local WaitTime = 1500 -- How often do you want to update the status (In MS)
local appid = '442784212794212363' -- Make an application @ https://discordapp.com/developers/applications/ ID can be found there.
local asset = 'g512' -- Go to https://discordapp.com/developers/applications/APPID/rich-presence/assets

function SetRP()
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())

    SetDiscordAppId('442784212794212363')
	SetDiscordRichPresenceAsset('9a3da')
	SetDiscordRichPresenceAssetText('')
	SetDiscordRichPresenceAssetSmall('')
	SetDiscordRichPresenceAssetSmallText('')
	SetDiscordRichPresenceAction(0, "join Server!", "fivem://connect/localhost:30120") -- Button 1, config: 0 = number of button 0-1 / Button Text / Link that opens when you click button
    SetDiscordRichPresenceAction(1, "join Discord!", "https://dsc.gg/9a3da-gaming-roleplay")
     
end


Citizen.CreateThread(function()

	SetRP()

	while true do
		local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
		if VehName == "NULL" then VehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		local pId = GetPlayerServerId(PlayerId())
		local pName = GetPlayerName(PlayerId())
		local playerCount = #GetActivePlayers()

		Citizen.Wait(WaitTime)

		SetRP()
		
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is sprinting down "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is running down "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is walking down "..StreetName)
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is standing on "..StreetName.."")
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
				if MPH > 50 then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is speeding down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH <= 50 and MPH > 0 then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is cruising down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH == 0 then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is parked on "..StreetName.." in a "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is flying over "..StreetName.." in a "..VehName)
				else
					SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is landed at "..StreetName.." in a "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is swimming")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is sailing in a "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence(playerCount.."/48 - ID: "..pId.." | "..pName.." is in a yellow submarine")
			end
		end
	end
end)