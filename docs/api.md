# RbxEnv 1.0.0 Docs

## Getting Started

Place the downloaded package in game/ReplicatedStorage. Create a server and a client:

https://github.com/threadous/Environment/blob/f03573f76ccd581cd56df123044b1b958711061a/Source/ExampleServer.lua#L1-L4

Set up for both server and client is the same, except you use RbxEnv.LoadClient() on the client. 

## Creating an Environment

https://github.com/threadous/Environment/blob/4e4baa79f8c2aa9150dc31c276689461f6dcc23d/Source/CreateEnv.lua#L1

## Creating a shared variable

It isn't recommended to create ALL your variables using RbxEnv. If you have variables being shared across two or more scripts, then you should use environments. 

