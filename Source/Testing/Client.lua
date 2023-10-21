local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Package = ReplicatedStorage:WaitForChild('RbxEnv')

local RbxEnv = require(Package.Env)
task.wait(1)
RbxEnv.LoadClient() -- Make sure RbxEnv.LoadClient() runs only after RbxEnv.Initialize() has been called on  a server script

local NetworkEnvironment = RbxEnv.GetEnvironment("NetworkEnv") -- Gets the environment
local Env = RbxEnv.GetEnvironment('ENV')

local CoreNetwork = NetworkEnvironment:GetNetwork("CoreNetwork") -- Gets the network (Remote Event) dedicated to the "CoreNetwork" Environment

local statNetwork = Env:GetNetwork("Stats")

local function DoSomething(Message)
  
end

CoreNetwork:Grab(function(...)
	print(...)
end)

statNetwork:Grab(function(throttle, speed, acceleration)
	print("Throttle: "..tostring(throttle))
end)

