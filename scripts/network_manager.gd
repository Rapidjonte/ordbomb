extends Node

var is_server = false
var peer = ENetMultiplayerPeer.new()

func start_server(port = 4242, max_clients = 8):
	peer.create_server(4242, 4)
	get_tree().multiplayer.multiplayer_peer = peer
	print("Server started:", get_tree().multiplayer.is_server())
	
func start_client(server_ip = "127.0.0.1", port = 4242):
	peer.create_client("127.0.0.1", 4242)
	get_tree().multiplayer.multiplayer_peer = peer
	print("Client connected:", get_tree().multiplayer.get_unique_id())
