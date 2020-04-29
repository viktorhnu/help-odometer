local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_odometer")

MySQL.createCommand("vRP/vrp_odometer", [[
ALTER TABLE vrp_user_vehicles ADD veh_odometer varchar(255) NOT NULL DEFAULT 0;
CREATE TABLE `vrp_odometer`(
    `id` INT AUTO_INCREMENT,
    `user_id` INT(30) NOT NULL,
    `vehicle` VARCHAR(255) NOT NULL,
    `kms` varchar(255) NOT NULL DEFAULT '0',
    PRIMARY KEY (id)
);
]])


MySQL.createCommand("vRP/odometer_getVehs", "SELECT `vehicle` FROM `vrp_user_vehicles` WHERE `user_id`=@user_id")
MySQL.createCommand("vRP/odometer_kmVeh", [[
  UPDATE vrp_user_vehicles SET veh_odometer = @km WHERE `user_id`=@user_id AND `vehicle`= @vehiclex;
  INSERT IGNORE INTO `vrp_odometer` (`user_id`, `vehicle`, `kms`) VALUES (@user_id, @vehiclex, @km);
]])


RegisterServerEvent("odometer:UpdateKM")
AddEventHandler("odometer:UpdateKM", function(vehicle, km)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
	TriggerClientEvent("odometer:GetKM", player)
    MySQL.query("vRP/odometer_getVehs", {user_id = user_id, vehicle = vehicle}, function(rows, affected)
        if #rows > 0 then
			for i, v in pairs(rows) do
				if GetHashKey(v.vehicle) == vehicle then
					local vehiclex = v.vehicle
					MySQL.query("vRP/odometer_kmVeh", {user_id = user_id, vehiclex = vehiclex, km = km})
				end
			end
		end
    end)
end)