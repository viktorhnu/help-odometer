local vehPlate

local x = 0.01135
local y = 0.002
hasKM = 0
showKM = 0


function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
end

RegisterNetEvent("odometer:GetKM")
AddEventHandler("odometer:GetKM", function(hasKM)
	showKM = math.floor(hasKM*1.33)/1000
	local oldPos = GetEntityCoords(PlayerPedId())
	Citizen.Wait(1000)
	local curPos = GetEntityCoords(PlayerPedId())
	dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
	hasKM = hasKM + dist
	TriggerServerEvent("odometer:UpdateKM", vehiclex,  hasKM)
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			Citizen.Wait(50)
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			Citizen.Wait(50)
			vehPlate = GetVehicleNumberPlateText(veh)
			Citizen.Wait(1)
			showKM = math.floor(hasKM*1.33)/1000
			local oldPos = GetEntityCoords(player)
			local curPos = GetEntityCoords(player)
			km = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
			hasKM = hasKM + km
			TriggerServerEvent("odometer:UpdateKM", vehiclex,  hasKM)
		end
	end
end)]]

displayHud = true

Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local veh = GetVehiclePedIsIn(PlayerPedId(),false)
			local driver = GetPedInVehicleSeat(veh, -1)
			if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
				DrawAdvancedText(0.270 - x, 0.97 - y, 0.005, 0.0028, 0.6, round(showKM, 2), 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.325 - x, 0.97 - y, 0.005, 0.0028, 0.6, "kms", 255, 255, 255, 255, 6, 1)
			end
		else
			Citizen.Wait(750)
		end

		Citizen.Wait(0)
	end
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end