local RunService = game:GetService('RunService')
local Network = require(game:GetService('ReplicatedStorage').RbxEnv.Network)

local RbxEnv = {}
RbxEnv.__index = RbxEnv
ServerEnv = {}

--[[

	@ RbxEnv.new(name : string)
	//Subject: RbxEnv
	//Return: Running environment
	//Differ: Creates new environment
	//Type: Changable
	
	@ Example
	// Defining new
	local ENV = RbxEnv.new("ENV") 
	
	@ GetEnvironment
	// Environment already exists
	local ENV = RbxEnv.GetEnvironment("ENV")
]]

function RbxEnv.new(envName : string)
	
	if ServerEnv[envName] ~= nil then
		return error(envName.." already exists!")
	end
	
	local env = {}
	env.Name = envName
	env.Children = {}
	env.VAR = {}
	env.Networks = {}
	setmetatable(env, RbxEnv)
	
	ServerEnv[envName] = env
	
	return env
end


function RbxEnv.GetEnvironment(name : string)
	if ServerEnv[name] then
		return ServerEnv[name]
	else
		return error(name.." does not exist!")
	end
end

--[[

	@ RbxEnv: LoadClient()
	//Subject:RbxEnv
	//Return: None
	//Differ: Transfers server framework data to client
	//Type: Init

]]

function RbxEnv.LoadClient()
	if RunService:IsClient() then
		local ClientFolder = script:WaitForChild('ClientFolder')
		
		for i, v in pairs(ClientFolder:GetChildren()) do
			local newClientEnv = RbxEnv.new(v.Name)
			for _, ClientNetwork in pairs(v:GetChildren()) do
				local newClientNetwork = newClientEnv:CreateNetwork(ClientNetwork.Name)
			end
		end
	else
		return error("RbxEnv.LoadClient() can only be called on the client!")
	end
	
	return print("Client successfully loaded!")
end

--[[

	@ RbxEnv: Initalize()
	//Subject:RbxEnv
	//Return: None
	//Differ: Initializes server to allow for client transfer
	//Type: Init

]]

function RbxEnv.Initialize()
	
	if RunService:IsServer() then
		
		local ClientFolder = Instance.new("Folder")
		ClientFolder.Name = "ClientFolder"
		ClientFolder.Parent = script
		
		local function makeEnvFolder(envTable)
			local EnvFolder = Instance.new("Folder")
			EnvFolder.Name = envTable.Name
			EnvFolder.Parent = ClientFolder

			for i, v in pairs(envTable.Networks) do
				local ClientNetwork = Instance.new("StringValue")
				ClientNetwork.Parent = EnvFolder
				ClientNetwork.Name = v.Name
			end
		end
		
		for i, v in pairs(ServerEnv) do
			makeEnvFolder(v)
		end
	else
		return error("RbxEnv.Initialize() Function can only be called on the server!")
	end
		
end

--[[

	@ RbxEnv:Variable(name : string)
	//Subject: env
	//Return: Variable value
	//Differ: Creates new variable with corresponding name
	//Type: Changable
	
	// METHODS = .set(name : string)
	// PURPOSE = Set variable value
	
	@ Example
	ENV:Variable("Throttle").set(25)

]]


function RbxEnv:Variable(name : string)
	local var = {}
	var.Name = name
	var.__index = var
	var.parent = self
	var.Value = {}
	
	self.Children[name] = var
	
	var.Value.set = function(object)
		var.Value[var.Name] = object
		return var.Value
	end
	
	self.VAR[var.Name] = var
		
	return var.Value
end 

--[[

	@ RbxEnv:fetch(name : string)
	//Subject: env
	//Return: Variable value
	//Differ: Returns variable value
	//Type: READ ONLY

]]

function RbxEnv:fetch(name : string)
	if self.Children[name] then
		return self.Children[name].Value[name]
	end
	return "Value not assetted"
end

--[[

	@ RbxEnv:Get(name : string)
	//Subject: env
	//Return: Variable table
	//Differ: Returns variable to be set not value
	//Type: Changable

]]
function RbxEnv:Get(name : string)
	local VAR = self.VAR
	if VAR[name] then
		return VAR[name].Value
	else
		return error(name.." does not eixst!")
	end
end

function RbxEnv:CreateNetwork(name : string)
	self:Variable(name).set(Network.create(name))
	self:fetch(name):SetEnv(self)
	
	print("Created!")
end

function RbxEnv:GetNetwork(name : string)
	return self:fetch(name)
end
	
return RbxEnv
