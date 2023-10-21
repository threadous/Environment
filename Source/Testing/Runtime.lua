local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)
local MyEnv = RbxEnv.new("MyEnvironment")
local DuoEnv = RbxEnv.new("Duo")

local Limit = MyEnv:Variable("Limit").set("Sky")
local Depth = DuoEnv:Variable("Depth").set(0)

task.wait()
local ENV = RbxEnv.GetEnvironment("ENV")
local NetworkEnvironment = RbxEnv.new("NetworkEnv")

-- Each network = 1 Remote Event
NetworkEnvironment:CreateNetwork("CoreNetwork")

game:GetService('Players').PlayerAdded:Connect(function(player : Player)
	task.wait(.5)
	NetworkEnvironment:GetNetwork("CoreNetwork"):Fire(player, "this is from the client!") -- See EnvClient to set up
    
	local newEnv = RbxEnv.GetEnvironment("NetworkEnv")
	print("Fired!")
end)

-- Variables
ENV:Variable("Throttle").set(25)

print(ENV:fetch("Throttle"))

ENV:Get("Throttle").set(ENV:fetch("Throttle") + 50)
print(ENV:fetch("Throttle"))

RbxEnv.Initialize() -- This should only be called ONCE in your entire codebase and must be at the very end (would recommend adding a task.wait())
