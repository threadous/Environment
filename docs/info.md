# RbxEnv 1.0.0 Docs

## Getting Started

Place the downloaded package in game/ReplicatedStorage. Create a server and a client:

Set up for both server and client is the same, except you use RbxEnv.LoadClient() on the client. 


## Creating an Environment


## Creating a shared variable

It isn't recommended to create ALL your variables using RbxEnv. If you have variables being shared across two or more scripts, then you should use environments. 

To create a shared variable, you could do

## Accessing a shared variable


## Networks

Creating a Network with RbxEnv is completely optional. Networks are basically `Remote Events` which you can define inside environments. RbxEnv will automatically handle remote events for you without you sorting all your remote events into folders and organizing them. 

For easier understanding, 1 Network = 1 Remote Event. A `Network` is made up for 3 components: Name, Environment (Environment in which the networks runs in), and Core (the remote event object itself).

Creating a network is very similar to creating a variable:

### Handling a Network

If you'd like the access the network from another script

