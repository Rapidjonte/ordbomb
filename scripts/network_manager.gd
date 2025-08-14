extends Node

var is_server = false

func start_server(port = 4242, max_clients = 4):
	var network = ENetMultiplayerPeer.new()
	network.create_server(4242, 4) # port 4242, max 4 clients
	get_tree().multiplayer.multiplayer_peer = network
	print("server started")

func start_client(server_ip = "127.0.0.1", port = 4242):
	var network = ENetMultiplayerPeer.new()
	network.create_client("127.0.0.1", 4242) # server IP + port
	get_tree().multiplayer.multiplayer_peer = network
	print("client connected")
