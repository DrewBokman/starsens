-- Ping Module
-- DrewBokman
-- May 3, 2020



local PingModule = {}
local pings = {}
local Event = game.ReplicatedStorage:FindFirstChild("PingRemoteEvent") or Instance.new("RemoteEvent",game.ReplicatedStorage)
Event.Name = "PingRemoteEvent"
Event.OnServerEvent:Connect(function(player)
	local pingInfo = pings[player]
	if pingInfo and pingInfo.sent then
		pingInfo.received = tick()
		pingInfo.ping = math.clamp(pingInfo.received - pingInfo.sent, 0, 5)
		pingInfo.sent = nil
	end
end)

local function playerAdded(player)
	pings[player] = {
		ping = 1
	}
end

game.Players.PlayerAdded:Connect(playerAdded)
for _, player in next, game.Players:GetPlayers() do
	playerAdded(player)
end

game.Players.PlayerRemoving:Connect(function(player)
	pings[player] = nil
end)

spawn(function()
	while true do
		for player, pingInfo in next, pings do
			pingInfo.sent = tick()
			Event:FireClient(player)
		end
		wait(5)
	end
end)

function PingModule:getPing(player)
	return pings[player] and pings[player].ping or 1
end

return PingModule