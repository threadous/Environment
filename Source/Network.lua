local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local RbxEnv = ReplicatedStorage:WaitForChild('RbxEnv')

local Shared = RbxEnv.Shared
	
local NetworkModule = {}
NetworkModule.__index = NetworkModule

--[[
		
	@ Heirachy:
		
		@ NetworkModule [
			@ Network [
				-> Name : Network name
				-> Environment : Network Environment
				-> Core : Remote event
			]
		]

]]

function NetworkModule.create(name : string)
	local Network = {}
	Network.Name = name
	Network.Suspended = false
	Network.Environment = {}
	
	if not Shared:FindFirstChild(name) then	
		local RemoteEvent = Instance.new('RemoteEvent', RbxEnv)
		RemoteEvent.Name = name
		RemoteEvent.Parent = Shared
		
		Network["Core"] = RemoteEvent
	else
		Network["Core"] = Shared:FindFirstChild(name)
	end
	
	setmetatable(Network, NetworkModule)
	return Network
end

function NetworkModule:SetEnv(Environment)
	Environment["Networks"][self.Name] = self
end

function NetworkModule:Suspend()
	self.Suspended = true
end

function NetworkModule:Unsuspend()
	self.Suspended = false
end

function NetworkModule:Fire(player, ...)
	player = player or 0
	
	if self["Core"]:IsA('RemoteEvent') and not self.Suspended then
		if RunService:IsServer() then
			if player:IsA("Player") then
				self["Core"]:FireClient(player, ...)
			else
				return error("Player parameter is missing!")
			end
		elseif RunService:IsClient() then
			self["Core"]:FireServer(player, ...)
		end
	elseif self.Suspended then
		return warn(self.Name.." Network is currently suspended, any events will not register!")
	elseif self['Core']:IsA('RemoteEvent') == false then
		return error(self.Name.." Unable to find remote event!")
	end
		
end

function NetworkModule:Grab(...)
	local method = ({...})
	if RunService:IsClient() then
		self["Core"].OnClientEvent:Connect(function(...)
			method[1](...)
		end)
	elseif RunService:IsServer() then
		self["Core"].OnServerEvent:Connect(function(...)
			method[1](...)
		end)
	end
end


return NetworkModule
