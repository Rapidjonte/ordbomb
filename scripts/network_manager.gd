extends Node

var peer : ENetMultiplayerPeer
signal player_list_updated

var players := {}

func start_server(port = 4242, max_clients = 8):
	if peer == null:
		peer = ENetMultiplayerPeer.new()
		
		var err = peer.create_server(port, max_clients)
		if err != OK:
			push_error("failed to create server: %d" % err)
			return
		
		multiplayer.multiplayer_peer = peer
		print("server started!")
		get_parent().say("Lobby started!")
		players[multiplayer.get_unique_id()] = "Host"
		add_player(multiplayer.get_unique_id(), "Host")
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
func start_client(server_ip = "127.0.0.1", port = 4242):
	if peer == null:
		peer = ENetMultiplayerPeer.new()
		
		var err = peer.create_client(server_ip, port)
		if err != OK:
			push_error("failed to create server: %d" % err)
			return
			
		multiplayer.multiplayer_peer = peer
		print("server joined!")
		get_parent().say("Lobby joined!")
		multiplayer.server_disconnected.connect(func(): print("Lost connection"))
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id):
	print("peer connected:", id)
	players[id] = "Guest"
	player_list_updated.emit()
	
	rpc("add_new_player", id, "Guest")

func _on_peer_disconnected(id):
	print("peer disconnected:", id)
	players.erase(id)
	player_list_updated.emit()

@onready var player_scene = preload("res://scenes/player.tscn")
var players_nodes = {}

@rpc("any_peer", "reliable")
func add_new_player(player_id: int, name: String):
	add_player(player_id, name)

func add_player(player_id: int, name: String = "Player"):
	if players_nodes.has(player_id):
		return 
	var player = player_scene.instantiate()
	player.id = player_id
	$playercontainer.add_child(player)
	player.set_player_name(name)
	players_nodes[player_id] = player
	update_player_positions()

func update_player_positions():
	var total = players_nodes.size()
	var radius = 200
	var center = Vector2(576, 324) 
	for i in range(total):
		var player = players_nodes.values()[i]
		player.set_position_on_circle(center, radius, i, total)
