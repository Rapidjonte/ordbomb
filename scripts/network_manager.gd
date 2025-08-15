extends Node

var peer = ENetMultiplayerPeer.new()

func start_server(port = 4242, max_clients = 8):
	peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = peer
	print("server started!")
	get_parent().say("Server started!")
	
func start_client(server_ip = "127.0.0.1", port = 4242):
	peer.create_client(server_ip, port)
	multiplayer.multiplayer_peer = peer
	get_parent().say("Server joined!")
