extends Camera2D

const PORT = 1234
var peer = ENetMultiplayerPeer.new()
var ip = ""

func _on_host_pressed() -> void:
	peer.create_server(PORT, 3)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	start_game()

func _on_join_pressed() -> void:
	if $VBoxContainer/IP.text == "":
		ip = "localhost"
	else:
		ip = $VBoxContainer/IP.text
	
	peer.create_client(ip, PORT)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id = 1):
	print("Peer " + str(id) + " connected")
	
func _on_connected_to_server():
	print("Connected to server")
	start_game()

func start_game():
	PlayerStats.is_multiplayer = true
	get_tree().change_scene_to_file("res://Scenes/Rooms/Start/start_room.tscn")
